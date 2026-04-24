Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3003FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4033A6B008A; Fri, 24 Apr 2026 13:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF846B008C; Fri, 24 Apr 2026 13:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9206B0092; Fri, 24 Apr 2026 13:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1679B6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:52:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FC2B12028B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:52:37 +0000 (UTC)
X-FDA: 84694194354.19.CEDF91C
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id A477DC0009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:52:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=nm8mYTb0;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=VP9RoJ5H;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf28.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777053156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddmDedl83zXNIObRm6zW5Jzs9CzNkrFziMH4FhbMenE=;
	b=B0etrvMeTUURE+ZLZLm6q/SJj9cAH9Bkck/avhFmxhzv3coRqFHYt7yTEjYaWNzlrJWclg
	i4f0Z82QVgZEUU7qL3JRN3cMwmggFl/vLFXAdKvKmBcHstfgl2Wfywf5dgpo5BQUxGxaoS
	eOXufI0UA7lg+hKLTWaZsyMbcpOeGjg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=nm8mYTb0;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=VP9RoJ5H;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf28.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777053156; a=rsa-sha256;
	cv=none;
	b=6fSDqDW16fgnVcWFCLfBpo1mD/+hQdg8ZfnEPGTEzxpMgWR89CSCfnLimx9Q5te+LBoFQO
	uR11xe1plYSS4FMlGZ3aghXnczfhEtRm7bydPx0qw6TJwzxUy6pHvRE7deey4KnCwcmBOr
	XSA92Y8Elvf71ocqF3q334DCs6dfFgM=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4g2LC5436Rz9v09;
	Fri, 24 Apr 2026 19:52:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddmDedl83zXNIObRm6zW5Jzs9CzNkrFziMH4FhbMenE=;
	b=nm8mYTb08t43c8nFpk+IRDk5KKB7zSBMPjW0nk9RsHy/dGY6NRqtEs3K6FsZjFqMFbRSxC
	M7MVCDvX7nHEZDhNxHN7NIydNv4itYaaFq6draj8c1jeKmWxRBzdxqPIGe70K328h57TA2
	jtuzWSb6mWRlwp9ObXdqnlrz14JQgHwAZPlSOy2ctUICLzh2JRcbl5yo/DgeAnvYSkfqFB
	WiZZrYcVmqsR8IhZG6Wedms2WBv1+M3nuaPMv7l8sgonj4Anf68iRWzuOLkzZ3r0aFaMZ6
	qQWkrv2wGPyYC+XeYCE+j936MiQrMlUvcnPtmj8KZL0wMn82qldZbQAwa8Rj0g==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddmDedl83zXNIObRm6zW5Jzs9CzNkrFziMH4FhbMenE=;
	b=VP9RoJ5HzPBvXr+IN02j+eHBaFjw8jTLH+Z/8lMFH/AIb3PN6GB/jRcbXvbwB8XXWHLhOc
	04bj6PFdVnXFTbz+w2iFxeCTj4Ef8o4khj67l49mPuTCCqnpLF+ehxua9vcLq/FtY/4grQ
	ehyAF5g92JeMqQWzrMVl0FBwk0an6qbuLAESSo8a1yb1OrYo6vo5TxpGHPjW3MAX+eprK9
	AoSqmTQoJtNFqcMN7p5WIadPoQtPsjzKAtyr36y4d1T7P230OJXu4Qe7qLv+WJN7WoF095
	iSNLCVoSTCbPaD/a0xaGHZKBCMxQSe+6O5BPa6tHI158/HfdoL8anburfKQgdQ==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v3 1/3] Documentation: adopt new coding style of type-aware kmalloc-family
Date: Fri, 24 Apr 2026 19:51:40 +0200
Message-ID: <20260424175141.258168-2-manuelebner@mailbox.org>
In-Reply-To: <20260424174743.257951-2-manuelebner@mailbox.org>
References: <20260424174743.257951-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 8820d89aad0e4e8209e
X-MBO-RS-META: g45oidfyf1w6moxjguhzu5rkks79nhda
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A477DC0009
X-Stat-Signature: sd81ik3fqiumdw1teb3qqwamytixn6uj
X-Rspam-User: 
X-HE-Tag: 1777053155-554508
X-HE-Meta: U2FsdGVkX19O7BPF7LFX+7V5u1x72BRtx+9YKfg2n2SjlDeVP8nqxesJzDUQJK8qi6iKk/FtmFP8M0ENsrzTwh52+2/+/MHR8F36GMK1xbk8y/3dk6PgOZBIPtL+Fw+sjt+7gboIg5uEQxkE1qhUz6laPmJz3ebyXJ9BT5fv33NOEnfCl2Hpweij7f6HMbaT02a5R80j2+vN6+TBCOZTrTJqaral4yt0980bcqjKHlcMVwL4s5lMO8a4EbmpvAfGICl6yKNODwvDFb1wCB0XZorZ+nZunGqkmko/fpCiq0J2ygcjJNa0Vk2Vn2uou6+dgawG/+jZOwWzFJuhJvWRA3mxg8XA2lm3NIxoQorg2+sEbD7VvYYGIrxwT12NRPw/UUKrxfoQhB2WpsyOMNiMIDmaWUt+LGtp3LF1jr667Tn0U7dcANe/GTKCVyXYewS791P2i++8aBHt3ouxPkZhDglfhS1KJ2NGhpceOEepNSpYbMKRLpo+oGbUjt1ZGB7/iPlLCC6A8M9oFZRN6lQaMyZ5vD5HRgdC/rWC+V7eQY07+lnSYdSvXfj2kFjaT6PZYuSkUG+Yj70ahZ1XnZx+U+ocsBdycLPok13svwDmSkPoibEJXLteDVDD88Tl1zz50MwWbkGXEHQdUSGNdbUqR+F8+F8NmN9V9+fAv9tgiWfBazgbS0s1T3iS6FRD+1Ti/h29YpHl09kieU4MDrAyiIBbsMWFvd4Vv7lJyPBhZaa4rVxeoXyNGgAlk9aPTpUQ7l+NRAT9y4Mk9/VJKcUGfedCLDhEOCGz9HwioPjFfI2b0SduMi3EWhzEXYSNt9xGKgVtove8DfoKEWgIQ70CaZeqolmdVgzKvlnhLkPlah1tV3qh41vmRPl9ffgUpIYEWbeSEsMLQ1wFFk9YAKNpLbAzVamgucMj2Hs/ah6dclcAzm0yOMgvdvmyKmsaUWMJxHFakaXIjJNtDDIBkR2
 sW6AmQmX
 s8EJzqrXYJ9tfEvpbTLfqPMwhNM3Y/DcLr9W/MxmP3QQzr4BzVBqFiWx6gbEH+ymDiL79dwb3nK32jTkSi+6KGQUNlpvek/eUia5XI2WEFdheibzDy5KiLxr1DC7S1Iv4sQrsJKSJfi4CC8t8D2Kzvzoj3Wz3017K3BcBvvjRnW1nI38SrX4H8V94JnnpI9QsH4H6qH5S2ASZw3Zl62GnR+21d05Tv5+lyywhFDXLAq1IVVZgK8zI+Rfat5wJBUCFs4AhB+5Cfy5LOb1MMD7KBm1vR76YdpaExoLktZfpg99StXldSWIo2qlKAOOvA+NzAV2o4yH2xl6jIQgnqCGh4Udmag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation to reflect new type-aware kmalloc-family as
suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
and family")

ptr = kmalloc(sizeof(*ptr), gfp);
 -> ptr = kmalloc_obj(*ptr);
ptr = kmalloc(sizeof(struct some_obj_name), gfp);
 -> ptr = kmalloc_obj(*ptr);
ptr = kzalloc(sizeof(*ptr), gfp);
 -> ptr = kzalloc_obj(*ptr);
ptr = kmalloc_array(count, sizeof(*ptr), gfp);
 -> ptr = kmalloc_objs(*ptr, count);
ptr = kcalloc(count, sizeof(*ptr), gfp);
 -> ptr = kzalloc_objs(*ptr, count);

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/core-api/kref.rst                      |  4 ++--
 Documentation/core-api/list.rst                      |  4 ++--
 Documentation/driver-api/mailbox.rst                 |  4 ++--
 Documentation/driver-api/media/v4l2-fh.rst           |  2 +-
 Documentation/kernel-hacking/locking.rst             |  4 ++--
 Documentation/locking/locktypes.rst                  |  4 ++--
 Documentation/process/coding-style.rst               |  8 ++++----
 .../sound/kernel-api/writing-an-alsa-driver.rst      | 12 ++++++------
 Documentation/spi/spi-summary.rst                    |  4 ++--
 .../translations/it_IT/kernel-hacking/locking.rst    |  4 ++--
 .../translations/it_IT/locking/locktypes.rst         |  4 ++--
 .../translations/it_IT/process/coding-style.rst      |  2 +-
 .../translations/sp_SP/process/coding-style.rst      |  2 +-
 Documentation/translations/zh_CN/core-api/kref.rst   |  4 ++--
 .../translations/zh_CN/process/coding-style.rst      |  2 +-
 .../zh_CN/video4linux/v4l2-framework.txt             |  2 +-
 .../translations/zh_TW/process/coding-style.rst      |  2 +-
 18 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/Documentation/core-api/kref.rst b/Documentation/core-api/kref.rst
index 8db9ff03d952..1c14c036699d 100644
--- a/Documentation/core-api/kref.rst
+++ b/Documentation/core-api/kref.rst
@@ -40,7 +40,7 @@ kref_init as so::
 
      struct my_data *data;
 
-     data = kmalloc(sizeof(*data), GFP_KERNEL);
+     data = kmalloc_obj(*data);
      if (!data)
             return -ENOMEM;
      kref_init(&data->refcount);
@@ -100,7 +100,7 @@ thread to process::
 	int rv = 0;
 	struct my_data *data;
 	struct task_struct *task;
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kmalloc_obj(*data);
 	if (!data)
 		return -ENOMEM;
 	kref_init(&data->refcount);
diff --git a/Documentation/core-api/list.rst b/Documentation/core-api/list.rst
index 241464ca0549..86cd0a1b77ea 100644
--- a/Documentation/core-api/list.rst
+++ b/Documentation/core-api/list.rst
@@ -112,7 +112,7 @@ list:
 
           /* State 1 */
 
-          grock = kzalloc(sizeof(*grock), GFP_KERNEL);
+          grock = kzalloc_obj(*grock);
           if (!grock)
                   return -ENOMEM;
           grock->name = "Grock";
@@ -123,7 +123,7 @@ list:
 
           /* State 2 */
 
-          dimitri = kzalloc(sizeof(*dimitri), GFP_KERNEL);
+          dimitri = kzalloc_obj(*dimitri);
           if (!dimitri)
                   return -ENOMEM;
           dimitri->name = "Dimitri";
diff --git a/Documentation/driver-api/mailbox.rst b/Documentation/driver-api/mailbox.rst
index 463dd032b96c..4bcd73a99115 100644
--- a/Documentation/driver-api/mailbox.rst
+++ b/Documentation/driver-api/mailbox.rst
@@ -87,8 +87,8 @@ a message and a callback function to the API and return immediately).
 		struct async_pkt ap;
 		struct sync_pkt sp;
 
-		dc_sync = kzalloc(sizeof(*dc_sync), GFP_KERNEL);
-		dc_async = kzalloc(sizeof(*dc_async), GFP_KERNEL);
+		dc_sync = kzalloc_obj(*dc_sync);
+		dc_async = kzalloc_obj(*dc_async);
 
 		/* Populate non-blocking mode client */
 		dc_async->cl.dev = &pdev->dev;
diff --git a/Documentation/driver-api/media/v4l2-fh.rst b/Documentation/driver-api/media/v4l2-fh.rst
index a934caa483a4..38319130ebf5 100644
--- a/Documentation/driver-api/media/v4l2-fh.rst
+++ b/Documentation/driver-api/media/v4l2-fh.rst
@@ -42,7 +42,7 @@ Example:
 
 		...
 
-		my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+		my_fh = kzalloc_obj(*my_fh);
 
 		...
 
diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
index dff0646a717b..d02e62367c4f 100644
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -442,7 +442,7 @@ to protect the cache and all the objects within it. Here's the code::
     {
             struct object *obj;
 
-            if ((obj = kmalloc(sizeof(*obj), GFP_KERNEL)) == NULL)
+            if ((obj = kmalloc_obj(*obj)) == NULL)
                     return -ENOMEM;
 
             strscpy(obj->name, name, sizeof(obj->name));
@@ -517,7 +517,7 @@ which are taken away, and the ``+`` are lines which are added.
              struct object *obj;
     +        unsigned long flags;
 
-             if ((obj = kmalloc(sizeof(*obj), GFP_KERNEL)) == NULL)
+             if ((obj = kmalloc_obj(*obj)) == NULL)
                      return -ENOMEM;
     @@ -63,30 +64,33 @@
              obj->id = id;
diff --git a/Documentation/locking/locktypes.rst b/Documentation/locking/locktypes.rst
index 37b6a5670c2f..ac1ad722a9e7 100644
--- a/Documentation/locking/locktypes.rst
+++ b/Documentation/locking/locktypes.rst
@@ -498,7 +498,7 @@ allocating memory.  Thus, on a non-PREEMPT_RT kernel the following code
 works perfectly::
 
   raw_spin_lock(&lock);
-  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+  p = kmalloc_obj(*p, GFP_ATOMIC);
 
 But this code fails on PREEMPT_RT kernels because the memory allocator is
 fully preemptible and therefore cannot be invoked from truly atomic
@@ -507,7 +507,7 @@ while holding normal non-raw spinlocks because they do not disable
 preemption on PREEMPT_RT kernels::
 
   spin_lock(&lock);
-  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+  p = kmalloc_obj(*p, GFP_ATOMIC);
 
 
 bit spinlocks
diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
index 35b381230f6e..a3bf75dc7c88 100644
--- a/Documentation/process/coding-style.rst
+++ b/Documentation/process/coding-style.rst
@@ -936,7 +936,7 @@ used.
 ---------------------
 
 The kernel provides the following general purpose memory allocators:
-kmalloc(), kzalloc(), kmalloc_array(), kcalloc(), vmalloc(), and
+kmalloc(), kzalloc(), kmalloc_objs(), kzalloc_objs(), vmalloc(), and
 vzalloc().  Please refer to the API documentation for further information
 about them.  :ref:`Documentation/core-api/memory-allocation.rst
 <memory_allocation>`
@@ -945,7 +945,7 @@ The preferred form for passing a size of a struct is the following:
 
 .. code-block:: c
 
-	p = kmalloc(sizeof(*p), ...);
+	p = kmalloc_obj(*p, ...);
 
 The alternative form where struct name is spelled out hurts readability and
 introduces an opportunity for a bug when the pointer variable type is changed
@@ -959,13 +959,13 @@ The preferred form for allocating an array is the following:
 
 .. code-block:: c
 
-	p = kmalloc_array(n, sizeof(...), ...);
+	p = kmalloc_objs(*ptr, n, ...);
 
 The preferred form for allocating a zeroed array is the following:
 
 .. code-block:: c
 
-	p = kcalloc(n, sizeof(...), ...);
+	p = kzalloc_objs(*ptr, n, ...);
 
 Both forms check for overflow on the allocation size n * sizeof(...),
 and return NULL if that occurred.
diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
index 895752cbcedd..12433612aa9c 100644
--- a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
+++ b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
@@ -266,7 +266,7 @@ to details explained in the following section.
               ....
 
               /* allocate a chip-specific data with zero filled */
-              chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+              chip = kzalloc_obj(*chip);
               if (chip == NULL)
                       return -ENOMEM;
 
@@ -628,7 +628,7 @@ After allocating a card instance via :c:func:`snd_card_new()`
   err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
                      0, &card);
   .....
-  chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+  chip = kzalloc_obj(*chip);
 
 The chip record should have the field to hold the card pointer at least,
 
@@ -747,7 +747,7 @@ destructor and PCI entries. Example code is shown first, below::
                       return -ENXIO;
               }
 
-              chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+              chip = kzalloc_obj(*chip);
               if (chip == NULL) {
                       pci_disable_device(pci);
                       return -ENOMEM;
@@ -1737,7 +1737,7 @@ callback::
   {
           struct my_pcm_data *data;
           ....
-          data = kmalloc(sizeof(*data), GFP_KERNEL);
+          data = kmalloc_obj(*data);
           substream->runtime->private_data = data;
           ....
   }
@@ -3301,7 +3301,7 @@ You can then pass any pointer value to the ``private_data``. If you
 assign private data, you should define a destructor, too. The
 destructor function is set in the ``private_free`` field::
 
-  struct mydata *p = kmalloc(sizeof(*p), GFP_KERNEL);
+  struct mydata *p = kmalloc_obj(*p);
   hw->private_data = p;
   hw->private_free = mydata_free;
 
@@ -3833,7 +3833,7 @@ chip data individually::
           err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
                              0, &card);
           ....
-          chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+          chip = kzalloc_obj(*chip);
           ....
           card->private_data = chip;
           ....
diff --git a/Documentation/spi/spi-summary.rst b/Documentation/spi/spi-summary.rst
index 6e21e6f86912..7ad6af76c247 100644
--- a/Documentation/spi/spi-summary.rst
+++ b/Documentation/spi/spi-summary.rst
@@ -249,7 +249,7 @@ And SOC-specific utility code might look something like::
 	{
 		struct mysoc_spi_data *pdata2;
 
-		pdata2 = kmalloc(sizeof *pdata2, GFP_KERNEL);
+		pdata2 = kmalloc_obj(*pdata2);
 		*pdata2 = pdata;
 		...
 		if (n == 2) {
@@ -373,7 +373,7 @@ a bus (appearing under /sys/class/spi_master).
 			return -ENODEV;
 
 		/* get memory for driver's per-chip state */
-		chip = kzalloc(sizeof *chip, GFP_KERNEL);
+		chip = kzalloc(*chip);
 		if (!chip)
 			return -ENOMEM;
 		spi_set_drvdata(spi, chip);
diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
index 4c21cf60f775..acca89a3743a 100644
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -462,7 +462,7 @@ e tutti gli oggetti che contiene. Ecco il codice::
     {
             struct object *obj;
 
-            if ((obj = kmalloc(sizeof(*obj), GFP_KERNEL)) == NULL)
+            if ((obj = kmalloc_obj(*obj)) == NULL)
                     return -ENOMEM;
 
             strscpy(obj->name, name, sizeof(obj->name));
@@ -537,7 +537,7 @@ sono quelle rimosse, mentre quelle ``+`` sono quelle aggiunte.
              struct object *obj;
     +        unsigned long flags;
 
-             if ((obj = kmalloc(sizeof(*obj), GFP_KERNEL)) == NULL)
+             if ((obj = kmalloc_obj(*obj)) == NULL)
                      return -ENOMEM;
     @@ -63,30 +64,33 @@
              obj->id = id;
diff --git a/Documentation/translations/it_IT/locking/locktypes.rst b/Documentation/translations/it_IT/locking/locktypes.rst
index 1c7056283b9d..d5fa36aa05cc 100644
--- a/Documentation/translations/it_IT/locking/locktypes.rst
+++ b/Documentation/translations/it_IT/locking/locktypes.rst
@@ -488,7 +488,7 @@ o rwlock_t. Per esempio, la sezione critica non deve fare allocazioni di
 memoria. Su un kernel non-PREEMPT_RT il seguente codice funziona perfettamente::
 
   raw_spin_lock(&lock);
-  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+  p = kmalloc_obj(*p, GFP_ATOMIC);
 
 Ma lo stesso codice non funziona su un kernel PREEMPT_RT perché l'allocatore di
 memoria può essere oggetto di prelazione e quindi non può essere chiamato in un
@@ -497,7 +497,7 @@ trattiene un blocco *non-raw* perché non disabilitano la prelazione sui kernel
 PREEMPT_RT::
 
   spin_lock(&lock);
-  p = kmalloc(sizeof(*p), GFP_ATOMIC);
+  p = kmalloc_obj(*p, GFP_ATOMIC);
 
 
 bit spinlocks
diff --git a/Documentation/translations/it_IT/process/coding-style.rst b/Documentation/translations/it_IT/process/coding-style.rst
index c0dc786b8474..2a499412a2e3 100644
--- a/Documentation/translations/it_IT/process/coding-style.rst
+++ b/Documentation/translations/it_IT/process/coding-style.rst
@@ -943,7 +943,7 @@ Il modo preferito per passare la dimensione di una struttura è il seguente:
 
 .. code-block:: c
 
-	p = kmalloc(sizeof(*p), ...);
+	p = kmalloc_obj(*p, ...);
 
 La forma alternativa, dove il nome della struttura viene scritto interamente,
 peggiora la leggibilità e introduce possibili bachi quando il tipo di
diff --git a/Documentation/translations/sp_SP/process/coding-style.rst b/Documentation/translations/sp_SP/process/coding-style.rst
index 7d63aa8426e6..44c93d5f6beb 100644
--- a/Documentation/translations/sp_SP/process/coding-style.rst
+++ b/Documentation/translations/sp_SP/process/coding-style.rst
@@ -955,7 +955,7 @@ La forma preferida para pasar el tamaño de una estructura es la siguiente:
 
 .. code-block:: c
 
-	p = kmalloc(sizeof(*p), ...);
+	p = kmalloc_obj(*p, ...);
 
 La forma alternativa donde se deletrea el nombre de la estructura perjudica
 la legibilidad, y presenta una oportunidad para un error cuando se cambia
diff --git a/Documentation/translations/zh_CN/core-api/kref.rst b/Documentation/translations/zh_CN/core-api/kref.rst
index b9902af310c5..fcff01e99852 100644
--- a/Documentation/translations/zh_CN/core-api/kref.rst
+++ b/Documentation/translations/zh_CN/core-api/kref.rst
@@ -52,7 +52,7 @@ kref可以出现在数据结构体中的任何地方。
 
      struct my_data *data;
 
-     data = kmalloc(sizeof(*data), GFP_KERNEL);
+     data = kmalloc_obj(*data);
      if (!data)
             return -ENOMEM;
      kref_init(&data->refcount);
@@ -106,7 +106,7 @@ Kref规则
 	int rv = 0;
 	struct my_data *data;
 	struct task_struct *task;
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kmalloc_obj(*data);
 	if (!data)
 		return -ENOMEM;
 	kref_init(&data->refcount);
diff --git a/Documentation/translations/zh_CN/process/coding-style.rst b/Documentation/translations/zh_CN/process/coding-style.rst
index 5a342a024c01..55d5da974d89 100644
--- a/Documentation/translations/zh_CN/process/coding-style.rst
+++ b/Documentation/translations/zh_CN/process/coding-style.rst
@@ -813,7 +813,7 @@ Documentation/translations/zh_CN/core-api/memory-allocation.rst 。
 
 .. code-block:: c
 
-	p = kmalloc(sizeof(*p), ...);
+	p = kmalloc_obj(*p, ...);
 
 另外一种传递方式中，sizeof 的操作数是结构体的名字，这样会降低可读性，并且可能
 会引入 bug。有可能指针变量类型被改变时，而对应的传递给内存分配函数的 sizeof
diff --git a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
index f0be21a60a0f..ba43c5c4797c 100644
--- a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
@@ -799,7 +799,7 @@ int my_open(struct file *file)
 
 	...
 
-	my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+	my_fh = kzalloc_obj(*my_fh);
 
 	...
 
diff --git a/Documentation/translations/zh_TW/process/coding-style.rst b/Documentation/translations/zh_TW/process/coding-style.rst
index e2ba97b3d8bb..63c78982a1af 100644
--- a/Documentation/translations/zh_TW/process/coding-style.rst
+++ b/Documentation/translations/zh_TW/process/coding-style.rst
@@ -827,7 +827,7 @@ Documentation/translations/zh_CN/core-api/memory-allocation.rst 。
 
 .. code-block:: c
 
-	p = kmalloc(sizeof(*p), ...);
+	p = kmalloc_obj(*p, ...);
 
 另外一種傳遞方式中，sizeof 的操作數是結構體的名字，這樣會降低可讀性，並且可能
 會引入 bug。有可能指針變量類型被改變時，而對應的傳遞給內存分配函數的 sizeof
-- 
2.53.0


