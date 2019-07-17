import tensorflow as tf
from sklearn import datasets as ds 
from tensorflow.keras.preprocessing.image import ImageDataGenerator 
import os
from PIL import Image
import numpy as np
from tensorflow.keras.preprocessing import image



    model = tf.keras.models.Sequential([
        # Note the input shape is the desired size of the image 300x300 with 3 bytes color
        # This is the first convolution
        tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(150, 150, 3)),
        tf.keras.layers.MaxPooling2D(2, 2),
        # The second convolution
        tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2,2),
        # The third convolution
        tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2,2),
        # The fourth convolution
        tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2,2),
        # The fifth convolution
        tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2,2),
        # Flatten the results to feed into a DNN
        tf.keras.layers.Flatten(),
        # 512 neuron hidden layer
        tf.keras.layers.Dense(512, activation='relu'),
        # Only 1 output neuron. It will contain a value from 0-1 where 0 for 1 class ('horses') and 1 for the other ('humans')
        tf.keras.layers.Dense(1, activation='sigmoid')
    ])

    from tensorflow.keras.optimizers import RMSprop

    model.compile(loss='binary_crossentropy',
                optimizer=RMSprop(lr=0.001),
                metrics=['acc'])



    train_datagen = ImageDataGenerator(rescale=1/255)
    validation_datagen = ImageDataGenerator(rescale=1/255)

    # Flow training images in batches of 128 using train_datagen generator
    train_generator = train_datagen.flow_from_directory(
            './traindata',  # This is the source directory for training images
            target_size=(150, 150),  # All images will be resized to 150x150
            batch_size=128,
            # Since we use binary_crossentropy loss, we need binary labels
            class_mode='binary')

    # Flow training images in batches of 128 using train_datagen generator
    validation_generator = validation_datagen.flow_from_directory(
            './traindata',  # This is the source directory for training images
            target_size=(150, 150),  # All images will be resized to 150x150
            batch_size=32,
            # Since we use binary_crossentropy loss, we need binary labels
            class_mode='binary')


    history = model.fit_generator(
        train_generator,
        steps_per_epoch=8,  
        epochs=1,
        verbose=1,
        validation_data = validation_generator,
        validation_steps=8)

    model.summary()


    model.save("image_model.h5")
    # predicting images

    # path = 'C:\\Users\\SHARON ZACHARIA\\Desktop\\Smart Cloud Gallery\\FlaskBackend\\modules\\images.jpg'
    print(path)
    img = image.load_img(path, target_size=(150, 150))
        # img = Image.fromarray(img)
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)

    images = np.vstack([x])
    classes = model.predict(images, batch_size=10)
    print(classes[0])
    if classes[0]>0.5:
        print ("nikki")
    else:
        print ("kajal")