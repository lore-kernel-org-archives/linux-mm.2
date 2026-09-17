Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974BEC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E746B008C; Thu, 17 Sep 2026 09:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8436B0092; Thu, 17 Sep 2026 09:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0D96B0093; Thu, 17 Sep 2026 09:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A198B6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:26:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22705A53C8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:40 +0000 (UTC)
X-FDA: 85223328960.24.51F7A37
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B7F0100002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=fdFj5BGr;
	dmarc=pass (policy=none) header.from=starlabs.systems;
	spf=pass (imf05.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651598;
	b=FawU+60l+0tLv6bjHOoNpMo+d62+Xs2AOtuLHPz4n9PeAwlC1mlWtWYccI+U1npEZuTWBk
	vg2Gh5C+fmOvbvDzfhUmsJMmaOJhb7nfEPlZ7xcof7Un+44Xs/HwtrM80Rmak7I3Wk3SHt
	5tCceks7w3hKKVq+D7Ox4kP6JjpOGIE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=fdFj5BGr;
	dmarc=pass (policy=none) header.from=starlabs.systems;
	spf=pass (imf05.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te9pOkBoV6jMkByYyKZgWN4wOydqVtJW9G1kH7jQqsc=;
	b=RXv+DpKAp0zo8/E+cOnvImsqIUrrM/ny8rBryjCAJ0LSW7ouwieiNfTbOzD5MZc12wdMz/
	Qv01+RyFZg3hH75w4nqU3bTDNaJPbV6GtJQICJlerNnEe9P0SE6UM70ztQNsjAB23IpYpv
	T/Zo0IwY47p7gflGNSReG7PZ6eDmark=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843172bff4so484266f8f.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651597; x=1790256397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=te9pOkBoV6jMkByYyKZgWN4wOydqVtJW9G1kH7jQqsc=;
        b=fdFj5BGrH+kTps8BAHvRcbH9LT5etJT3n9Dq4dmDFQjnVWubkznawWYHtWOZWnt56j
         cZemYfMhk/PSMiXzP3RqEmr+AM8mzAy8XlrtA9b45PnU4J8Julf/kx9MkKpk43ZenCse
         DZHgEODEHAubXKwwb5fTQ92nCAFCzxgAD0j5828Q74CkKdcXrWE+uNIlQ1q8kQwd3TVs
         10QoseCEDrE3K2ot9vOjkjnLoKS2w6BQ+Un/LmzBC9oxauHxVkAqvN6WepoNY/PemK3R
         7h+RG/JykA97SDmYC30M9drl0KUVFgEa2tmR7Oyg1p8dsXvFeX3HiR9hndkGN2ORmmu6
         gmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651597; x=1790256397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=te9pOkBoV6jMkByYyKZgWN4wOydqVtJW9G1kH7jQqsc=;
        b=R8iqwdYJFS1bQC/5qDneaYPWWTTJ65wITzmemSoDBmmWHMD/x8DfKBFdT9X407m2ce
         E74uK+J7IElmJjz1AEOPGFDSE4lVtQEp7EF4rTxvLDl/Cq//C3nQJx6G1kNY6fIUceo+
         bKfheOj4HUJlsolOfo6PWfNRMbCh9oaxOr3yzHFRuEWCcWIRMfVWJ0fRnCCcbrPrWtPT
         aKR8/vOvvGr2KqIzfccwLpKE9nE8Gr46sq3T3PinSodLMJhkOzCvRB6m5ZU92eSqfnqJ
         rZKE+NqAxVlOM9JjKYPCs9+3PBFeH863hlZSBwrsFfgi8LG/FBHLl7P/bQ3rfO+HR0eg
         36Pg==
X-Forwarded-Encrypted: i=1; AKwUvBx6YFNeS9Vlccd88lE7mRVcDh0GZIHPOVnjGOnc30uBsE5EmkasUPiW0mqkCIjOMljcmWSsMiGZZQ==@kvack.org
X-Gm-Message-State: AFuF++m8fmUyvC8uxxqQfrkgUfpBteZV0/uq1nMtf1kM+22sZvGvAFub
	+0AwlSSIeSVJFfTNuXZbMF/BsyZ8VIMZTxqcrKTpFzPFo49IhgDUNNHlvaYDidIaFw==
X-Gm-Gg: AYBFou0V5r+QfqvVH3rPk8BDZfAmRK29kTUWZl8cuSMtWRWmquGjo9P4lzjKugfvUff
	6y9i+NZHXJO6HyENrNgZr/PHsLJTBEiLJuRWe1X+nn7toRN+YtQF6lmIqiheMtAh68MreMYXHYX
	KMfqdDNre0lyCpQFdzZ9znK9K7E6RSGooMtj6Ci7+eYiU4siU8nYfuMMjP50kMNI3C15jXLO45j
	xGbCTEEBkFu9y+CQg6N9JR4eNb97vZHGzxCH4Bn0M5hC4fJkMNFI7LQ7mM8e+rqPwG9ifga4Byv
	VUBQMRlnrZBHMOb2I5tPvT6zuvTO5w93+Q1tFlXRUuJYPN3IDQ2VvrQE8qdF2aGh59xDsk+/sO2
	Xt9f3kC8r5711BiwK3SZDpj3tZjJIX4HmNUpmAicFO0wR+bSuJdQqMqZFhCL6mThHT3vklrjOhS
	j44WfHCgaaqOVD+SRrHHTiqrNyyKuAsz5dpFFBGmQPBqbY0/ktMcT7DbwyIAeoLFvF4S7DGiZHU
	ESife1dgWK8GTjFXSTfU7KuRdsc
X-Received: by 2002:a05:6000:18a6:b0:486:faa5:2165 with SMTP id ffacd0b85a97d-4870d271014mr8862099f8f.54.1789651596443;
        Thu, 17 Sep 2026 06:26:36 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1f6cfsm15879947f8f.13.2026.09.17.06.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:26:35 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Sean Rhodes <sean@starlabs.systems>,
	Evan Green <evgreen@chromium.org>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 1/4] PM: hibernate: add seed-wrapped encrypted snapshots
Date: Thu, 17 Sep 2026 14:26:28 +0100
Message-ID: <e4b751e8e5bf1ee5f1b4c597ac8d5ebc620b7b98.1789651581.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651581.git.sean@starlabs.systems>
References: <cover.1789651581.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B7F0100002
X-Stat-Signature: 4ksnj7u7s9dtnybb3afh3rfkwoirohca
X-HE-Tag: 1789651597-574310
X-HE-Meta: U2FsdGVkX1/3/21e2lHAWBer4LBaCayLkAG0BlPoltdfEgw8nOGeu6FsoAlKObqA1n9TWvgXzlh1dqe56hlpAG9SlD7NEI+U4Emmaec2n71IlREkESLKg+MkA99ak62kYC2s6aueEKvMOUgLboOaErsgqm/xJGa/NVXfXiny899BVebfvzRPnycWGN89Ty9ZD7gvHbzY6e8Uuo6ZBjOQQWaZsPIOQT0taqrlrMaSyGyrgCbjle6hS4hR48iFlvnW/M3xOAW+UoDG3cDt/1xKF8tBGUUP36XSAKqixrOcV3Cv/aHhcl9MbY6kbFHSV/DWGguoVq41KG32R8r5QnwqodFsDprK0WTTcs3z1zqHqqowgPMyYadsFlSVlzSoOJngrU1vWw4qMRiv2cKm7ViluzDpRaCtEPXzT+dBsXJkNw9fch0dwMZE94wJKxzSEp4Xlxc7GxnvZeAqlTEoy/r+rQUgJ0vFw3zeoK8Q509gFQxN1xqJVhJ8kWtdnjE/8IAjlMu+ZWYZvQJV7R2is35uYDSCRpLUOrqL24aqPd01HZuDPo8AcbMItPhQgEiaefQIdldpPoVhDPanLQ+RQiKL048aRQb6CfhEFVx6b/G+Ajn/gps2NSDhPhkB1GO7opBBped4BwSg3ntiHZL2/RhMWDPtXiRp4ONouJPxP2APuFHAd8PZ0dp6NZbm+cnepiuw/MkVYUIhsscf0c7V4pYMrKKKGsbeRlQUzj2cLsTQvcAN4vqK2DrGYhlB0Za7DmK5HKA3pSZ5hgO+j7RZ3WTnAaODgKsXpi6iqH7tBNZqnNMkXsquHa640wyOZ+kT27LIDDjmwEEAeFUQPuYDjAEJxoW6Nf8lsf3Rv6baXXiprb2SOKFODYWdd7oeXevru+FEiuoOeX4QUzpx4ASqbnRA09wpo/eJDNOn0bhBT1TMGA7aR8XueH724Xn4EYoBydpxiw3KG3r+luOd/rLNgTo
 awi1Ds5c
 c8VjjoirvmIdENJB+gIosg4lr9fTkBE6d/KBKWOhYmKj46bwYUs709nNJkQmHbrPPaiOafbb1CwLdVM1wQrERPklzQKhwJPo9OMAHX6oNROSU5OxSQ3Cs4PLSztTuVbUwyfLokTu6OeintwigEq97Zbs6jmIu1h2MPW+be6L6kYg88Sy1O6MbdoU2Q9J9yPh0LPBQ4m1wi5ngLxZD2kzzD/UgdHnE6pP/ZBBswLFOiFtR6RTSvQZykkuTXDvKaZn4A/ShgVpFCkz/7wn9DYyNKKfSSFogupJG99SX9YJm8FXrMS0Ei6vPwQ1+gqDNkPeliAZniTSPL3G/3owq3B2gYqErHJoXTTgclQSmEb/SdtgZCHcSIVjL0mi9Q/lmLW6ILeDYVaGLGTHDCppAGl+cKNvmxml4OKGP1dHb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Evan Green <evgreen@chromium.org>

Encrypt and authenticate uswsusp hibernation images in the kernel so
userspace cannot tamper with the image that will be restored as kernel
memory.

The image data is protected with gcm(aes) in 16-page chunks.
SNAPSHOT_ENABLE_ENCRYPTION enables the encrypted read/write paths and
returns an opaque wrapped image-key blob with the starting nonce on
suspend. On resume, userspace provides the same blob and nonce after
trusted early userspace has written the same 32-byte seed to
/sys/power/snapshot_seed.

The plaintext image key is generated and unwrapped inside the kernel. The
wrapping key is derived from the locked seed, leaving TPM PCR policy and
seed unsealing to early userspace rather than adding TPM or trusted-key
state to PM code.

SNAPSHOT_SET_USER_KEY lets userspace fold extra key material into the
data encryption key after the metadata area has been read or written.

Tested on StarFighter MTL with a TPM-sealed seed: complete keyless and
user-key encrypted uswsusp cycles resumed the same process and boot ID.
Corrupted wrapped data, invalid blob magic, a corrupted complete-chunk
tag and a wrong user key were rejected.

Signed-off-by: Evan Green <evgreen@chromium.org>
Co-developed-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 Documentation/power/userland-swsusp.rst |  16 +
 include/uapi/linux/suspend_ioctls.h     |  31 +-
 kernel/power/Kconfig                    |  15 +
 kernel/power/Makefile                   |   1 +
 kernel/power/hibernate.c                |  24 +
 kernel/power/power.h                    |   1 +
 kernel/power/snapenc.c                  | 952 ++++++++++++++++++++++++
 kernel/power/snapshot.c                 |   5 +
 kernel/power/user.c                     |  59 +-
 kernel/power/user.h                     | 139 ++++
 10 files changed, 1225 insertions(+), 18 deletions(-)
 create mode 100644 kernel/power/snapenc.c
 create mode 100644 kernel/power/user.h

diff --git a/Documentation/power/userland-swsusp.rst b/Documentation/power/userland-swsusp.rst
index 1cf62d80a9ca..282e01d2fe61 100644
--- a/Documentation/power/userland-swsusp.rst
+++ b/Documentation/power/userland-swsusp.rst
@@ -115,6 +115,22 @@ SNAPSHOT_S2RAM
 	to resume the system from RAM if there's enough battery power or restore
 	its state on the basis of the saved suspend image otherwise)
 
+SNAPSHOT_ENABLE_ENCRYPTION
+	Enables encryption of the hibernate image within the kernel. Upon suspend
+	(ie when the snapshot device was opened for reading), returns a blob
+	representing the random encryption key the kernel created to encrypt the
+	hibernate image with. Upon resume (ie when the snapshot device was opened
+	for writing), receives a blob from usermode containing the key material
+	previously returned during hibernate.
+
+SNAPSHOT_SET_USER_KEY
+	Mixes additional user key material into the data portion of an encrypted
+	hibernate image. The ioctl argument points to struct uswsusp_user_key.
+	key_len must be between 8 and USWSUSP_USER_KEY_SIZE bytes, and reserved
+	must be zero. The kernel writes meta_size with the encrypted metadata
+	size that userspace may transfer before providing the user key during
+	resume.
+
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:
 
diff --git a/include/uapi/linux/suspend_ioctls.h b/include/uapi/linux/suspend_ioctls.h
index bcce04e21c0d..5e23bf936277 100644
--- a/include/uapi/linux/suspend_ioctls.h
+++ b/include/uapi/linux/suspend_ioctls.h
@@ -13,6 +13,31 @@ struct resume_swap_area {
 	__u32 dev;
 } __attribute__((packed));
 
+#define USWSUSP_KEY_NONCE_SIZE 16
+#define USWSUSP_USER_KEY_SIZE 32
+
+/*
+ * This structure is used to pass the opaque wrapped hibernate image
+ * encryption key and starting nonce in either direction.
+ */
+struct uswsusp_key_blob {
+	__u32 blob_len;
+	__u8 blob[512];
+	__u8 nonce[USWSUSP_KEY_NONCE_SIZE] __kernel_nonstring;
+} __attribute__((packed));
+
+/*
+ * Allow user mode to fold in key material for the data portion of the hibernate
+ * image.
+ */
+struct uswsusp_user_key {
+	/* Kernel returns the metadata size; resume passes the saved value in. */
+	__u64 meta_size;
+	__u32 key_len;
+	__u32 reserved;
+	__u8 key[USWSUSP_USER_KEY_SIZE] __kernel_nonstring;
+} __attribute__((packed));
+
 #define SNAPSHOT_IOC_MAGIC	'3'
 #define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
 #define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
@@ -29,6 +54,10 @@ struct resume_swap_area {
 #define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
 #define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, __kernel_loff_t)
 #define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
-#define SNAPSHOT_IOC_MAXNR	20
+#define SNAPSHOT_ENABLE_ENCRYPTION	_IOWR(SNAPSHOT_IOC_MAGIC, 21, \
+							struct uswsusp_key_blob)
+#define SNAPSHOT_SET_USER_KEY		_IOWR(SNAPSHOT_IOC_MAGIC, 22, \
+							struct uswsusp_user_key)
+#define SNAPSHOT_IOC_MAXNR	22
 
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 71165e7f04f4..f23d1c7e0ecd 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -115,6 +115,21 @@ config HIBERNATION_DEF_COMP
 	help
 	  Default compressor to be used for hibernation.
 
+config ENCRYPTED_HIBERNATION
+	bool "Encryption support for userspace snapshots"
+	depends on HIBERNATION_SNAPSHOT_DEV
+	select CRYPTO_AES
+	select CRYPTO_GCM
+	select CRYPTO_LIB_SHA256
+	help
+	  Enable support for kernel-based encryption of hibernation snapshots
+	  created by uswsusp tools. A trusted early userspace component must
+	  provide the snapshot encryption seed before enabling encryption.
+
+	  Say N if userspace handles the image encryption.
+
+	  If in doubt, say N.
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on HIBERNATION
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 773e2789412b..2fd31b2a250f 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o
 obj-$(CONFIG_HIBERNATION_SNAPSHOT_DEV) += user.o
+obj-$(CONFIG_ENCRYPTED_HIBERNATION) += snapenc.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+= wakelock.o
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d2479c69d71a..a95cb447a13a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -36,6 +36,7 @@
 #include <trace/events/power.h>
 
 #include "power.h"
+#include "user.h"
 
 
 static int nocompress;
@@ -1376,12 +1377,35 @@ static ssize_t reserved_size_store(struct kobject *kobj,
 
 power_attr(reserved_size);
 
+#ifdef CONFIG_ENCRYPTED_HIBERNATION
+static ssize_t snapshot_seed_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	int ret;
+
+	ret = snapshot_store_encryption_seed(buf, n);
+	return ret ? ret : n;
+}
+
+static struct kobj_attribute snapshot_seed_attr = {
+	.attr	= {
+		.name = "snapshot_seed",
+		.mode = 0200,
+	},
+	.store	= snapshot_seed_store,
+};
+#endif
+
 static struct attribute *g[] = {
 	&disk_attr.attr,
 	&resume_offset_attr.attr,
 	&resume_attr.attr,
 	&image_size_attr.attr,
 	&reserved_size_attr.attr,
+#ifdef CONFIG_ENCRYPTED_HIBERNATION
+	&snapshot_seed_attr.attr,
+#endif
 	NULL,
 };
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 75b63843886e..e080230f97fc 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -160,6 +160,7 @@ struct snapshot_handle {
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
+unsigned long snapshot_get_meta_page_count(void);
 extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 int snapshot_write_finalize(struct snapshot_handle *handle);
diff --git a/kernel/power/snapenc.c b/kernel/power/snapenc.c
new file mode 100644
index 000000000000..b555a699b564
--- /dev/null
+++ b/kernel/power/snapenc.c
@@ -0,0 +1,952 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* This file provides encryption support for system snapshots. */
+
+#include <linux/crypto.h>
+#include <crypto/aead.h>
+#include <crypto/gcm.h>
+#include <crypto/sha2.h>
+#include <crypto/utils.h>
+#include <linux/hex.h>
+#include <linux/mutex.h>
+#include <linux/random.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "power.h"
+#include "user.h"
+
+#define SNAPSHOT_SEED_SIZE SHA256_DIGEST_SIZE
+#define SNAPSHOT_KEY_BLOB_VERSION 1
+
+static const u8 snapshot_key_blob_magic[8] = {
+	'S', 'W', 'S', 'U', 'S', 'P', 'K', '1',
+};
+
+struct snapshot_wrapped_key {
+	u8 magic[sizeof(snapshot_key_blob_magic)];
+	__le32 version;
+	u8 wrap_nonce[GCM_AES_IV_SIZE] __nonstring;
+	u8 encrypted_key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring;
+	u8 tag[SNAPSHOT_AUTH_TAG_SIZE] __nonstring;
+} __packed;
+
+static DEFINE_MUTEX(snapshot_seed_mutex);
+static u8 snapshot_seed[SNAPSHOT_SEED_SIZE] __nonstring;
+static bool snapshot_seed_valid;
+
+int snapshot_store_encryption_seed(const char *buf, size_t count)
+{
+	u8 seed[SNAPSHOT_SEED_SIZE] __nonstring;
+	size_t len = count;
+	int ret;
+
+	if (len && buf[len - 1] == '\n')
+		len--;
+	if (len != SNAPSHOT_SEED_SIZE * 2)
+		return -EINVAL;
+
+	ret = hex2bin(seed, buf, sizeof(seed));
+	if (ret)
+		return ret;
+
+	mutex_lock(&snapshot_seed_mutex);
+	if (snapshot_seed_valid) {
+		ret = crypto_memneq(snapshot_seed, seed, sizeof(seed)) ? -EPERM : 0;
+		goto out;
+	}
+
+	memcpy(snapshot_seed, seed, sizeof(seed));
+	snapshot_seed_valid = true;
+	pr_info("PM: hibernate: snapshot encryption seed locked\n");
+
+out:
+	mutex_unlock(&snapshot_seed_mutex);
+	memzero_explicit(seed, sizeof(seed));
+	return ret;
+}
+
+static bool snapshot_copy_encryption_seed(u8 seed[SNAPSHOT_SEED_SIZE])
+{
+	bool valid;
+
+	mutex_lock(&snapshot_seed_mutex);
+	valid = snapshot_seed_valid;
+	if (valid)
+		memcpy(seed, snapshot_seed, SNAPSHOT_SEED_SIZE);
+	mutex_unlock(&snapshot_seed_mutex);
+
+	return valid;
+}
+
+static int snapshot_derive_wrapping_key(u8 key[SNAPSHOT_ENCRYPTION_KEY_SIZE])
+{
+	static const char label[] = "Linux hibernate snapshot key wrap v1";
+	u8 digest[SHA256_DIGEST_SIZE];
+	u8 seed[SNAPSHOT_SEED_SIZE] __nonstring;
+	struct sha256_ctx sha256_ctx;
+
+	if (!snapshot_copy_encryption_seed(seed))
+		return -ENOKEY;
+
+	sha256_init(&sha256_ctx);
+	sha256_update(&sha256_ctx, label, strlen(label));
+	sha256_update(&sha256_ctx, seed, sizeof(seed));
+	sha256_final(&sha256_ctx, digest);
+
+	memcpy(key, digest, SNAPSHOT_ENCRYPTION_KEY_SIZE);
+	memzero_explicit(seed, sizeof(seed));
+	memzero_explicit(digest, sizeof(digest));
+	return 0;
+}
+
+static int snapshot_crypt_wrapped_key(struct snapshot_wrapped_key *wrapped,
+				      u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE],
+				      bool encrypt)
+{
+	u8 wrap_key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring;
+	u8 buf[SNAPSHOT_ENCRYPTION_KEY_SIZE + SNAPSHOT_AUTH_TAG_SIZE] __nonstring;
+	struct crypto_aead *tfm;
+	struct aead_request *req;
+	struct scatterlist sg;
+	DECLARE_CRYPTO_WAIT(wait);
+	int rc;
+
+	rc = snapshot_derive_wrapping_key(wrap_key);
+	if (rc)
+		return rc;
+
+	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+	if (IS_ERR(tfm)) {
+		rc = PTR_ERR(tfm);
+		goto out_key;
+	}
+
+	rc = crypto_aead_setkey(tfm, wrap_key, sizeof(wrap_key));
+	if (rc)
+		goto out_tfm;
+
+	rc = crypto_aead_setauthsize(tfm, SNAPSHOT_AUTH_TAG_SIZE);
+	if (rc)
+		goto out_tfm;
+
+	req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		rc = -ENOMEM;
+		goto out_tfm;
+	}
+
+	if (encrypt) {
+		get_random_bytes(wrapped->wrap_nonce, sizeof(wrapped->wrap_nonce));
+		memcpy(buf, image_key, SNAPSHOT_ENCRYPTION_KEY_SIZE);
+	} else {
+		memcpy(buf, wrapped->encrypted_key, SNAPSHOT_ENCRYPTION_KEY_SIZE);
+		memcpy(buf + SNAPSHOT_ENCRYPTION_KEY_SIZE, wrapped->tag,
+		       SNAPSHOT_AUTH_TAG_SIZE);
+	}
+
+	sg_init_one(&sg, buf, sizeof(buf));
+	aead_request_set_callback(req, 0, crypto_req_done, &wait);
+	aead_request_set_ad(req, 0);
+	aead_request_set_crypt(req, &sg, &sg,
+			       encrypt ? SNAPSHOT_ENCRYPTION_KEY_SIZE :
+					 sizeof(buf),
+			       wrapped->wrap_nonce);
+
+	rc = crypto_wait_req(encrypt ? crypto_aead_encrypt(req) :
+				       crypto_aead_decrypt(req),
+			     &wait);
+	if (rc)
+		goto out_req;
+
+	if (encrypt) {
+		memcpy(wrapped->encrypted_key, buf, SNAPSHOT_ENCRYPTION_KEY_SIZE);
+		memcpy(wrapped->tag, buf + SNAPSHOT_ENCRYPTION_KEY_SIZE,
+		       SNAPSHOT_AUTH_TAG_SIZE);
+	} else {
+		memcpy(image_key, buf, SNAPSHOT_ENCRYPTION_KEY_SIZE);
+	}
+
+out_req:
+	aead_request_free(req);
+out_tfm:
+	crypto_free_aead(tfm);
+out_key:
+	memzero_explicit(buf, sizeof(buf));
+	memzero_explicit(wrap_key, sizeof(wrap_key));
+	return rc;
+}
+
+static int snapshot_wrap_image_key(const u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE],
+				   struct snapshot_wrapped_key *wrapped)
+{
+	u8 key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring;
+	int rc;
+
+	memset(wrapped, 0, sizeof(*wrapped));
+	memcpy(wrapped->magic, snapshot_key_blob_magic, sizeof(wrapped->magic));
+	wrapped->version = cpu_to_le32(SNAPSHOT_KEY_BLOB_VERSION);
+
+	memcpy(key, image_key, sizeof(key));
+	rc = snapshot_crypt_wrapped_key(wrapped, key, true);
+	memzero_explicit(key, sizeof(key));
+	return rc;
+}
+
+static int snapshot_unwrap_image_key(const struct snapshot_wrapped_key *wrapped,
+				     u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE])
+{
+	struct snapshot_wrapped_key tmp;
+	int rc;
+
+	if (memcmp(wrapped->magic, snapshot_key_blob_magic,
+		   sizeof(snapshot_key_blob_magic)))
+		return -EINVAL;
+	if (le32_to_cpu(wrapped->version) != SNAPSHOT_KEY_BLOB_VERSION)
+		return -EINVAL;
+
+	tmp = *wrapped;
+	rc = snapshot_crypt_wrapped_key(&tmp, image_key, false);
+	memzero_explicit(&tmp, sizeof(tmp));
+	return rc;
+}
+
+static int snapshot_install_image_key(struct snapshot_data *data,
+				      const u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE])
+{
+	int rc;
+
+	memcpy(data->encryption_key, image_key, sizeof(data->encryption_key));
+	rc = crypto_aead_setkey(data->aead_tfm, data->encryption_key,
+				sizeof(data->encryption_key));
+	if (rc)
+		memzero_explicit(data->encryption_key,
+				 sizeof(data->encryption_key));
+
+	return rc;
+}
+
+/* Derive a key from the kernel and user keys for data encryption. */
+static int snapshot_use_user_key(struct snapshot_data *data)
+{
+	u8 digest[SHA256_DIGEST_SIZE];
+	struct sha256_ctx sha256_ctx;
+	int rc;
+
+	/*
+	 * Hash the kernel key and the user key together. This folds in the user
+	 * key, but not in a way that gives the user mode predictable control
+	 * over the key bits.
+	 */
+	sha256_init(&sha256_ctx);
+
+	sha256_update(&sha256_ctx, data->encryption_key,
+		      SNAPSHOT_ENCRYPTION_KEY_SIZE);
+	sha256_update(&sha256_ctx, data->user_key, sizeof(data->user_key));
+	sha256_final(&sha256_ctx, digest);
+
+	BUILD_BUG_ON(SNAPSHOT_ENCRYPTION_KEY_SIZE > SHA256_DIGEST_SIZE);
+
+	rc = crypto_aead_setkey(data->aead_tfm,
+				digest,
+				SNAPSHOT_ENCRYPTION_KEY_SIZE);
+	memzero_explicit(digest, sizeof(digest));
+
+	return rc;
+}
+
+/* Check to see if it's time to switch to the user key, and do it if so. */
+static int snapshot_check_user_key_switch(struct snapshot_data *data)
+{
+	if (data->user_key_valid && data->meta_size &&
+	    data->crypt_total == data->meta_size) {
+		return snapshot_use_user_key(data);
+	}
+
+	return 0;
+}
+
+static loff_t snapshot_encrypted_byte_count(loff_t plain_size);
+
+static void snapshot_set_meta_size(struct snapshot_data *data, u64 meta_size)
+{
+	data->meta_size = meta_size;
+	data->crypt_meta_size = snapshot_encrypted_byte_count(meta_size);
+}
+
+/* Encrypt more data from the snapshot into the staging area. */
+static int snapshot_encrypt_refill(struct snapshot_data *data)
+{
+	struct aead_request *req = data->aead_req;
+	u8 nonce[GCM_AES_IV_SIZE];
+	DECLARE_CRYPTO_WAIT(wait);
+	size_t total = 0;
+	int pg_idx;
+	int res;
+
+	if (data->crypt_total == 0) {
+		snapshot_set_meta_size(data,
+				       snapshot_get_meta_page_count() << PAGE_SHIFT);
+	} else {
+		res = snapshot_check_user_key_switch(data);
+		if (res)
+			return res;
+	}
+
+	/*
+	 * The first buffer is the associated data, set to the offset to prevent
+	 * attacks that rearrange chunks.
+	 */
+	sg_set_buf(&data->sg[0], &data->crypt_total, sizeof(data->crypt_total));
+
+	/* Load the crypt buffer with snapshot pages. */
+	for (pg_idx = 0; pg_idx < SNAPSHOT_CHUNK_SIZE; pg_idx++) {
+		void *buf = data->crypt_pages[pg_idx];
+
+		/* Stop at the meta page boundary before switching keys. */
+		if (data->user_key_valid && total &&
+		    ((data->crypt_total + total) == data->meta_size))
+			break;
+
+		res = snapshot_read_next(&data->handle);
+		if (res < 0)
+			return res;
+		if (res == 0)
+			break;
+
+		WARN_ON(res != PAGE_SIZE);
+
+		/*
+		 * Copy the page into the staging area. A future optimization
+		 * could potentially skip this copy for lowmem pages.
+		 */
+		memcpy(buf, data_of(data->handle), PAGE_SIZE);
+		sg_set_buf(&data->sg[1 + pg_idx], buf, PAGE_SIZE);
+		total += PAGE_SIZE;
+	}
+
+	if (!total)
+		return 0;
+
+	sg_set_buf(&data->sg[1 + pg_idx], &data->auth_tag, SNAPSHOT_AUTH_TAG_SIZE);
+	aead_request_set_callback(req, 0, crypto_req_done, &wait);
+	/*
+	 * Use incrementing nonces for each chunk, since a 64 bit value won't
+	 * roll into re-use for any given hibernate image.
+	 */
+	memcpy(&nonce[0], &data->nonce_low, sizeof(data->nonce_low));
+	memcpy(&nonce[sizeof(data->nonce_low)],
+	       &data->nonce_high,
+	       sizeof(nonce) - sizeof(data->nonce_low));
+
+	data->nonce_low += 1;
+	/* Total does not include AAD or the auth tag. */
+	aead_request_set_crypt(req, data->sg, data->sg, total, nonce);
+	res = crypto_wait_req(crypto_aead_encrypt(req), &wait);
+	if (res)
+		return res;
+
+	data->crypt_size = total;
+	data->crypt_total += total;
+	return 0;
+}
+
+/* Decrypt data from the staging area and push it to the snapshot. */
+static int snapshot_decrypt_drain(struct snapshot_data *data)
+{
+	struct aead_request *req = data->aead_req;
+	u8 nonce[GCM_AES_IV_SIZE];
+	DECLARE_CRYPTO_WAIT(wait);
+	int page_count;
+	size_t total;
+	int pg_idx;
+	int res;
+
+	/* Set up the associated data. */
+	sg_set_buf(&data->sg[0], &data->crypt_total, sizeof(data->crypt_total));
+
+	/*
+	 * Get the number of full pages, which could be short at the end. There
+	 * should also be a tag at the end, so the offset won't be an even page.
+	 */
+	page_count = data->crypt_offset >> PAGE_SHIFT;
+	total = page_count << PAGE_SHIFT;
+	if (total == 0 || total == data->crypt_offset)
+		return -EINVAL;
+
+	/*
+	 * Load the sg list with the crypt buffer. Inline decrypt back into the
+	 * staging buffer. A future optimization could decrypt directly into
+	 * lowmem pages.
+	 */
+	for (pg_idx = 0; pg_idx < page_count; pg_idx++)
+		sg_set_buf(&data->sg[1 + pg_idx], data->crypt_pages[pg_idx], PAGE_SIZE);
+
+	/*
+	 * It's possible this is the final decrypt, or the final decrypt of the
+	 * meta region, and there are fewer than SNAPSHOT_CHUNK_SIZE pages. If this is
+	 * the case we would have just written the auth tag into the first few
+	 * bytes of a new page. Copy to the tag if so.
+	 */
+	if (page_count < SNAPSHOT_CHUNK_SIZE &&
+	    (data->crypt_offset - total) == sizeof(data->auth_tag)) {
+		memcpy(data->auth_tag, data->crypt_pages[pg_idx],
+		       sizeof(data->auth_tag));
+	} else if (data->crypt_offset !=
+		   ((SNAPSHOT_CHUNK_SIZE << PAGE_SHIFT) + SNAPSHOT_AUTH_TAG_SIZE)) {
+		return -EINVAL;
+	}
+
+	sg_set_buf(&data->sg[1 + pg_idx], &data->auth_tag, SNAPSHOT_AUTH_TAG_SIZE);
+	aead_request_set_callback(req, 0, crypto_req_done, &wait);
+	memcpy(&nonce[0], &data->nonce_low, sizeof(data->nonce_low));
+	memcpy(&nonce[sizeof(data->nonce_low)],
+	       &data->nonce_high,
+	       sizeof(nonce) - sizeof(data->nonce_low));
+
+	data->nonce_low += 1;
+	aead_request_set_crypt(req, data->sg, data->sg, total + SNAPSHOT_AUTH_TAG_SIZE, nonce);
+	res = crypto_wait_req(crypto_aead_decrypt(req), &wait);
+	if (res)
+		return res;
+
+	data->crypt_size = 0;
+	data->crypt_offset = 0;
+
+	/* Push the decrypted pages further down the stack. */
+	total = 0;
+	for (pg_idx = 0; pg_idx < page_count; pg_idx++) {
+		void *buf = data->crypt_pages[pg_idx];
+
+		res = snapshot_write_next(&data->handle);
+		if (res < 0)
+			return res;
+		if (res == 0)
+			break;
+
+		if (!data_of(data->handle))
+			return -EINVAL;
+
+		WARN_ON(res != PAGE_SIZE);
+
+		/* Copy the decrypted page into the snapshot image. */
+		memcpy(data_of(data->handle), buf, PAGE_SIZE);
+		total += PAGE_SIZE;
+	}
+
+	if (data->crypt_total == 0) {
+		u64 meta_size = snapshot_get_meta_page_count() << PAGE_SHIFT;
+
+		data->meta_size = meta_size;
+		if (data->user_key_valid &&
+		    data->crypt_meta_size != snapshot_encrypted_byte_count(meta_size))
+			return -EINVAL;
+	}
+
+	data->crypt_total += total;
+	res = snapshot_check_user_key_switch(data);
+	if (res)
+		return res;
+
+	return 0;
+}
+
+static ssize_t snapshot_read_next_encrypted(struct snapshot_data *data,
+					    void **buf)
+{
+	size_t tag_off;
+
+	/* Refill the encrypted buffer if it's empty. */
+	if (data->crypt_size == 0 ||
+	    (data->crypt_offset >=
+	     (data->crypt_size + SNAPSHOT_AUTH_TAG_SIZE))) {
+		int rc;
+
+		data->crypt_size = 0;
+		data->crypt_offset = 0;
+		rc = snapshot_encrypt_refill(data);
+		if (rc < 0)
+			return rc;
+		if (!data->crypt_size)
+			return 0;
+	}
+
+	/* Return data pages if the offset is in that region. */
+	if (data->crypt_offset < data->crypt_size) {
+		size_t pg_idx = data->crypt_offset >> PAGE_SHIFT;
+		size_t pg_off = data->crypt_offset & (PAGE_SIZE - 1);
+		*buf = data->crypt_pages[pg_idx] + pg_off;
+		return PAGE_SIZE - pg_off;
+	}
+
+	/* Use offsets just beyond the size to return the tag. */
+	tag_off = data->crypt_offset - data->crypt_size;
+	if (tag_off > SNAPSHOT_AUTH_TAG_SIZE)
+		tag_off = SNAPSHOT_AUTH_TAG_SIZE;
+
+	*buf = data->auth_tag + tag_off;
+	return SNAPSHOT_AUTH_TAG_SIZE - tag_off;
+}
+
+static ssize_t snapshot_write_next_encrypted(struct snapshot_data *data,
+					     void **buf)
+{
+	size_t size_avail;
+	size_t tag_off;
+
+	/* Return data pages if the offset is in that region. */
+	if (data->crypt_offset < (PAGE_SIZE * SNAPSHOT_CHUNK_SIZE)) {
+		size_t pg_idx = data->crypt_offset >> PAGE_SHIFT;
+		size_t pg_off = data->crypt_offset & (PAGE_SIZE - 1);
+
+		*buf = data->crypt_pages[pg_idx] + pg_off;
+		size_avail = PAGE_SIZE - pg_off;
+	} else {
+		/* Use offsets just beyond the size to return the tag. */
+		tag_off = data->crypt_offset - (PAGE_SIZE * SNAPSHOT_CHUNK_SIZE);
+		if (tag_off > SNAPSHOT_AUTH_TAG_SIZE)
+			tag_off = SNAPSHOT_AUTH_TAG_SIZE;
+
+		*buf = data->auth_tag + tag_off;
+		size_avail = SNAPSHOT_AUTH_TAG_SIZE - tag_off;
+	}
+
+	if (data->user_key_valid && data->crypt_meta_size &&
+	    data->crypt_stream_total < data->crypt_meta_size) {
+		u64 meta_avail = data->crypt_meta_size - data->crypt_stream_total;
+
+		size_avail = min_t(u64, size_avail, meta_avail);
+	}
+
+	return size_avail;
+}
+
+ssize_t snapshot_read_encrypted(struct snapshot_data *data,
+				char __user *buf, size_t count, loff_t *offp)
+{
+	size_t copy_size;
+	size_t not_done;
+	size_t pg_off;
+	void *src;
+	ssize_t src_size;
+
+	if (!count)
+		return 0;
+
+	pg_off = *offp & (PAGE_SIZE - 1);
+	count = min_t(size_t, count, PAGE_SIZE - pg_off);
+
+	src_size = snapshot_read_next_encrypted(data, &src);
+	if (src_size <= 0)
+		return src_size;
+
+	copy_size = min_t(size_t, count, src_size);
+	not_done = copy_to_user(buf, src, copy_size);
+	copy_size -= not_done;
+	if (!copy_size)
+		return -EFAULT;
+
+	data->crypt_offset += copy_size;
+	*offp += copy_size;
+	return copy_size;
+}
+
+ssize_t snapshot_write_encrypted(struct snapshot_data *data,
+				 const char __user *buf, size_t count,
+				 loff_t *offp)
+{
+	size_t copy_size;
+	size_t not_done;
+	size_t pg_off;
+	void *dst;
+	ssize_t dst_size;
+	int rc;
+
+	if (!count)
+		return 0;
+
+	pg_off = *offp & (PAGE_SIZE - 1);
+	count = min_t(size_t, count, PAGE_SIZE - pg_off);
+
+	dst_size = snapshot_write_next_encrypted(data, &dst);
+	if (dst_size <= 0)
+		return dst_size;
+
+	copy_size = min_t(size_t, count, dst_size);
+	not_done = copy_from_user(dst, buf, copy_size);
+	copy_size -= not_done;
+	if (!copy_size)
+		return -EFAULT;
+
+	data->crypt_offset += copy_size;
+	data->crypt_stream_total += copy_size;
+	/*
+	 * Drain the encrypted buffer if it's full, or if we hit the end of the
+	 * encrypted metadata and need a key change before user data pages.
+	 */
+	if (data->crypt_offset >=
+	    (PAGE_SIZE * SNAPSHOT_CHUNK_SIZE) + SNAPSHOT_AUTH_TAG_SIZE ||
+	    (data->user_key_valid && data->crypt_meta_size &&
+	     data->crypt_stream_total == data->crypt_meta_size)) {
+		rc = snapshot_decrypt_drain(data);
+		if (rc < 0)
+			return rc;
+	}
+
+	*offp += copy_size;
+	return copy_size;
+}
+
+static void snapshot_reset_encryption_state(struct snapshot_data *data)
+{
+	data->crypt_offset = 0;
+	data->crypt_size = 0;
+	data->crypt_total = 0;
+	data->crypt_stream_total = 0;
+	data->nonce_low = 0;
+	data->nonce_high = 0;
+	data->meta_size = 0;
+	data->crypt_meta_size = 0;
+	data->user_key_valid = false;
+	memset(data->auth_tag, 0, sizeof(data->auth_tag));
+}
+
+void snapshot_teardown_encryption(struct snapshot_data *data)
+{
+	int i;
+
+	if (data->aead_req) {
+		aead_request_free(data->aead_req);
+		data->aead_req = NULL;
+	}
+
+	if (data->aead_tfm) {
+		crypto_free_aead(data->aead_tfm);
+		data->aead_tfm = NULL;
+	}
+
+	for (i = 0; i < SNAPSHOT_CHUNK_SIZE; i++) {
+		if (data->crypt_pages[i]) {
+			free_page((unsigned long)data->crypt_pages[i]);
+			data->crypt_pages[i] = NULL;
+		}
+	}
+
+	memzero_explicit(data->encryption_key, sizeof(data->encryption_key));
+	memzero_explicit(data->user_key, sizeof(data->user_key));
+	snapshot_reset_encryption_state(data);
+}
+
+static int snapshot_setup_encryption_common(struct snapshot_data *data)
+{
+	int i, rc;
+
+	/* This only works once per hibernate. */
+	if (data->aead_tfm)
+		return -EINVAL;
+
+	snapshot_reset_encryption_state(data);
+	memset(data->crypt_pages, 0, sizeof(data->crypt_pages));
+
+	/* Set up the encryption transform */
+	data->aead_tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+	if (IS_ERR(data->aead_tfm)) {
+		rc = PTR_ERR(data->aead_tfm);
+		data->aead_tfm = NULL;
+		return rc;
+	}
+
+	rc = -ENOMEM;
+	data->aead_req = aead_request_alloc(data->aead_tfm, GFP_KERNEL);
+	if (!data->aead_req)
+		goto setup_fail;
+
+	/* Allocate the staging area */
+	for (i = 0; i < SNAPSHOT_CHUNK_SIZE; i++) {
+		data->crypt_pages[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!data->crypt_pages[i])
+			goto setup_fail;
+	}
+
+	sg_init_table(data->sg, SNAPSHOT_CHUNK_SIZE + 2);
+
+	/*
+	 * The associated data will be the offset so that blocks can't be
+	 * rearranged.
+	 */
+	aead_request_set_ad(data->aead_req, sizeof(data->crypt_total));
+	rc = crypto_aead_setauthsize(data->aead_tfm, SNAPSHOT_AUTH_TAG_SIZE);
+	if (rc)
+		goto setup_fail;
+
+	return 0;
+
+setup_fail:
+	snapshot_teardown_encryption(data);
+	return rc;
+}
+
+int snapshot_get_encryption_key(struct snapshot_data *data,
+				struct uswsusp_key_blob __user *key)
+{
+	struct snapshot_wrapped_key wrapped = {};
+	u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring = {};
+	u8 nonce[USWSUSP_KEY_NONCE_SIZE];
+	int rc;
+
+	/* Don't pull a random key from a world that can be reset. */
+	if (data->ready)
+		return -EPIPE;
+
+	rc = snapshot_setup_encryption_common(data);
+	if (rc)
+		return rc;
+
+	/* Build a random starting nonce. */
+	get_random_bytes(nonce, sizeof(nonce));
+	memcpy(&data->nonce_low, &nonce[0], sizeof(data->nonce_low));
+	memcpy(&data->nonce_high, &nonce[8], sizeof(data->nonce_high));
+
+	/* Build and install a random image encryption key. */
+	get_random_bytes(image_key, sizeof(image_key));
+	rc = snapshot_install_image_key(data, image_key);
+	if (rc)
+		goto fail;
+
+	rc = snapshot_wrap_image_key(image_key, &wrapped);
+	if (rc)
+		goto fail;
+
+	/* Hand the wrapped key and clear nonce back to user mode. */
+	rc = put_user(sizeof(wrapped), &key->blob_len);
+	if (rc)
+		goto fail;
+
+	BUILD_BUG_ON(sizeof(wrapped) >
+		     sizeof(((struct uswsusp_key_blob *)0)->blob));
+	if (copy_to_user(&key->blob, &wrapped, sizeof(wrapped))) {
+		rc = -EFAULT;
+		goto fail;
+	}
+
+	if (copy_to_user(&key->nonce, &nonce, sizeof(nonce))) {
+		rc = -EFAULT;
+		goto fail;
+	}
+
+	memzero_explicit(image_key, sizeof(image_key));
+	memzero_explicit(&wrapped, sizeof(wrapped));
+	return 0;
+
+fail:
+	memzero_explicit(image_key, sizeof(image_key));
+	memzero_explicit(&wrapped, sizeof(wrapped));
+	snapshot_teardown_encryption(data);
+	return rc;
+}
+
+int snapshot_set_encryption_key(struct snapshot_data *data,
+				struct uswsusp_key_blob __user *key)
+{
+	struct uswsusp_key_blob *blob;
+	struct snapshot_wrapped_key wrapped = {};
+	u8 image_key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring = {};
+	int rc;
+
+	/* It's too late if data's been pushed in. */
+	if (data->handle.cur)
+		return -EPIPE;
+
+	rc = snapshot_setup_encryption_common(data);
+	if (rc)
+		return rc;
+
+	/* Load the key from user mode. */
+	blob = memdup_user(key, sizeof(*blob));
+	if (IS_ERR(blob)) {
+		rc = PTR_ERR(blob);
+		goto crypto_setup_fail;
+	}
+
+	if (blob->blob_len != sizeof(wrapped)) {
+		rc = -EINVAL;
+		goto out_blob;
+	}
+
+	memcpy(&wrapped, blob->blob, sizeof(wrapped));
+	rc = snapshot_unwrap_image_key(&wrapped, image_key);
+	if (rc)
+		goto out_blob;
+
+	rc = snapshot_install_image_key(data, image_key);
+	if (rc)
+		goto out_blob;
+
+	/* Load the starting nonce. */
+	memcpy(&data->nonce_low, &blob->nonce[0], sizeof(data->nonce_low));
+	memcpy(&data->nonce_high, &blob->nonce[8], sizeof(data->nonce_high));
+
+out_blob:
+	kfree_sensitive(blob);
+	memzero_explicit(&wrapped, sizeof(wrapped));
+	memzero_explicit(image_key, sizeof(image_key));
+	if (rc)
+		goto crypto_setup_fail;
+
+	return 0;
+
+crypto_setup_fail:
+	memzero_explicit(&wrapped, sizeof(wrapped));
+	memzero_explicit(image_key, sizeof(image_key));
+	snapshot_teardown_encryption(data);
+	return rc;
+}
+
+static loff_t snapshot_encrypted_byte_count(loff_t plain_size)
+{
+	loff_t pages = plain_size >> PAGE_SHIFT;
+	loff_t chunks = (pages + (SNAPSHOT_CHUNK_SIZE - 1)) / SNAPSHOT_CHUNK_SIZE;
+	/*
+	 * The encrypted size is the normal size, plus a stitched in
+	 * authentication tag for every chunk of pages.
+	 */
+	return plain_size + (chunks * SNAPSHOT_AUTH_TAG_SIZE);
+}
+
+static loff_t snapshot_encrypted_split_byte_count(loff_t raw_size,
+						  loff_t meta_plain_size)
+{
+	if (raw_size <= meta_plain_size)
+		return snapshot_encrypted_byte_count(raw_size);
+
+	return snapshot_encrypted_byte_count(meta_plain_size) +
+		snapshot_encrypted_byte_count(raw_size - meta_plain_size);
+}
+
+int snapshot_set_user_key(struct snapshot_data *data,
+			  struct uswsusp_user_key __user *key)
+{
+	struct uswsusp_user_key user_key = {};
+	unsigned int key_len;
+	u64 size;
+	int rc;
+
+	if (!snapshot_encryption_enabled(data))
+		return -EINVAL;
+
+	if (copy_from_user(&user_key, key, sizeof(struct uswsusp_user_key)))
+		return -EFAULT;
+
+	BUILD_BUG_ON(sizeof(data->user_key) < sizeof(user_key.key));
+	rc = -EINVAL;
+	if (user_key.reserved)
+		goto out;
+	if (user_key.key_len > sizeof(data->user_key))
+		goto out;
+	if (user_key.key_len < 8)
+		goto out;
+
+	if (data->mode == O_RDONLY && !data->ready) {
+		rc = -ENODATA;
+		goto out;
+	}
+
+	/*
+	 * Return the metadata size, the number of bytes that can be fed in before
+	 * the user data key is needed at resume time.
+	 */
+	if (data->mode == O_WRONLY && !data->meta_size) {
+		if (user_key.meta_size < PAGE_SIZE + SNAPSHOT_AUTH_TAG_SIZE)
+			goto out;
+
+		data->crypt_meta_size = user_key.meta_size;
+		size = data->crypt_meta_size;
+	} else {
+		snapshot_set_meta_size(data,
+				       snapshot_get_meta_page_count() << PAGE_SHIFT);
+		size = data->crypt_meta_size;
+	}
+
+	rc = put_user(size, &key->meta_size);
+	if (rc)
+		goto out;
+
+	key_len = user_key.key_len;
+
+	/* Don't allow it if it's too late. */
+	if ((data->meta_size && data->crypt_total > data->meta_size) ||
+	    (data->crypt_meta_size &&
+	     data->crypt_stream_total > data->crypt_meta_size)) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * Resume may preload the user key before writing any image data, or
+	 * install it after writing exactly the saved metadata stream. In the
+	 * latter case, authenticate and publish the buffered metadata under the
+	 * original image key before switching keys.
+	 */
+	if (data->mode == O_WRONLY && data->crypt_meta_size &&
+	    data->crypt_stream_total == data->crypt_meta_size &&
+	    data->crypt_offset) {
+		rc = snapshot_decrypt_drain(data);
+		if (rc)
+			goto out;
+		if (data->crypt_total != data->meta_size) {
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
+	memset(data->user_key, 0, sizeof(data->user_key));
+	memcpy(data->user_key, user_key.key, key_len);
+	data->user_key_valid = true;
+	/* Install the key if the user is just under the wire. */
+	rc = snapshot_check_user_key_switch(data);
+	if (rc)
+		goto out;
+
+	rc = 0;
+
+out:
+	memzero_explicit(&user_key, sizeof(user_key));
+	return rc;
+}
+
+loff_t snapshot_get_encrypted_image_size(struct snapshot_data *data,
+					 loff_t raw_size)
+{
+	loff_t meta_plain_size = data->meta_size;
+	loff_t split_size;
+
+	if (!meta_plain_size)
+		meta_plain_size = snapshot_get_meta_page_count() << PAGE_SHIFT;
+
+	split_size = snapshot_encrypted_split_byte_count(raw_size,
+							 meta_plain_size);
+	if (!data->user_key_valid) {
+		/*
+		 * Userspace may install a user key after querying the image size.
+		 * Reserve enough space for either framing so that later splitting at
+		 * the metadata boundary cannot make the reported size too small.
+		 */
+		return max(snapshot_encrypted_byte_count(raw_size), split_size);
+	}
+
+	return split_size;
+}
+
+int snapshot_finalize_decrypted_image(struct snapshot_data *data)
+{
+	int rc;
+
+	if (data->crypt_offset != 0) {
+		rc = snapshot_decrypt_drain(data);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b209712cb2c3..d1a226a25d27 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2177,6 +2177,11 @@ unsigned long snapshot_get_image_size(void)
 	return nr_copy_pages + nr_meta_pages + 1;
 }
 
+unsigned long snapshot_get_meta_page_count(void)
+{
+	return nr_meta_pages + 1;
+}
+
 static int init_header(struct swsusp_info *info)
 {
 	memset(info, 0, sizeof(struct swsusp_info));
diff --git a/kernel/power/user.c b/kernel/power/user.c
index d0fcfba7ac23..07dbb1e82847 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -25,19 +25,10 @@
 #include <linux/uaccess.h>
 
 #include "power.h"
+#include "user.h"
 
 static bool need_wait;
-
-static struct snapshot_data {
-	struct snapshot_handle handle;
-	int swap;
-	int mode;
-	bool frozen;
-	bool ready;
-	bool platform_support;
-	bool free_bitmaps;
-	dev_t dev;
-} snapshot_state;
+static struct snapshot_data snapshot_state;
 
 int is_hibernate_resume_dev(dev_t dev)
 {
@@ -57,13 +48,13 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 
 	if (!hibernate_acquire()) {
 		error = -EBUSY;
-		goto Unlock;
+		goto unlock;
 	}
 
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
 		hibernate_release();
 		error = -ENOSYS;
-		goto Unlock;
+		goto unlock;
 	}
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
@@ -100,7 +91,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	data->platform_support = false;
 	data->dev = 0;
 
- Unlock:
+ unlock:
 	unlock_system_sleep(sleep_flags);
 
 	return error;
@@ -125,6 +116,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	} else if (data->free_bitmaps) {
 		free_basic_memory_bitmaps();
 	}
+	snapshot_teardown_encryption(data);
 	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	hibernate_release();
@@ -147,12 +139,18 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 	data = filp->private_data;
 	if (!data->ready) {
 		res = -ENODATA;
-		goto Unlock;
+		goto unlock;
+	}
+
+	if (snapshot_encryption_enabled(data)) {
+		res = snapshot_read_encrypted(data, buf, count, offp);
+		goto unlock;
 	}
+
 	if (!pg_offp) { /* on page boundary? */
 		res = snapshot_read_next(&data->handle);
 		if (res <= 0)
-			goto Unlock;
+			goto unlock;
 	} else {
 		res = PAGE_SIZE - pg_offp;
 	}
@@ -162,7 +160,7 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 	if (res > 0)
 		*offp += res;
 
- Unlock:
+ unlock:
 	unlock_system_sleep(sleep_flags);
 
 	return res;
@@ -185,6 +183,11 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 
 	data = filp->private_data;
 
+	if (snapshot_encryption_enabled(data)) {
+		res = snapshot_write_encrypted(data, buf, count, offp);
+		goto unlock;
+	}
+
 	if (!pg_offp) {
 		res = snapshot_write_next(&data->handle);
 		if (res <= 0)
@@ -328,6 +331,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:
+		if (snapshot_encryption_enabled(data)) {
+			error = snapshot_finalize_decrypted_image(data);
+			if (error)
+				break;
+		}
+
 		error = snapshot_write_finalize(&data->handle);
 		if (error)
 			break;
@@ -346,6 +355,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		swsusp_free();
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
 		data->ready = false;
+		snapshot_teardown_encryption(data);
 		/*
 		 * It is necessary to thaw kernel threads here, because
 		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
@@ -368,6 +378,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		}
 		size = snapshot_get_image_size();
 		size <<= PAGE_SHIFT;
+		if (snapshot_encryption_enabled(data))
+			size = snapshot_get_encrypted_image_size(data, size);
 		error = put_user(size, (loff_t __user *)arg);
 		break;
 
@@ -425,6 +437,17 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = snapshot_set_swap_area(data, (void __user *)arg);
 		break;
 
+	case SNAPSHOT_ENABLE_ENCRYPTION:
+		if (data->mode == O_RDONLY)
+			error = snapshot_get_encryption_key(data, (void __user *)arg);
+		else
+			error = snapshot_set_encryption_key(data, (void __user *)arg);
+		break;
+
+	case SNAPSHOT_SET_USER_KEY:
+		error = snapshot_set_user_key(data, (void __user *)arg);
+		break;
+
 	default:
 		error = -ENOTTY;
 
@@ -448,6 +471,8 @@ snapshot_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SNAPSHOT_ALLOC_SWAP_PAGE:
 	case SNAPSHOT_CREATE_IMAGE:
 	case SNAPSHOT_SET_SWAP_AREA:
+	case SNAPSHOT_ENABLE_ENCRYPTION:
+	case SNAPSHOT_SET_USER_KEY:
 		return snapshot_ioctl(file, cmd,
 				      (unsigned long) compat_ptr(arg));
 	default:
diff --git a/kernel/power/user.h b/kernel/power/user.h
new file mode 100644
index 000000000000..b0c20e5d5ee9
--- /dev/null
+++ b/kernel/power/user.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __POWER_USER_H
+#define __POWER_USER_H
+
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/suspend_ioctls.h>
+#include <crypto/aead.h>
+#include <crypto/aes.h>
+
+#define SNAPSHOT_ENCRYPTION_KEY_SIZE AES_KEYSIZE_128
+#define SNAPSHOT_AUTH_TAG_SIZE 16
+
+/* Define the number of pages in a single AEAD encryption chunk. */
+#define SNAPSHOT_CHUNK_SIZE 16
+
+struct snapshot_data {
+	struct snapshot_handle handle;
+	int swap;
+	int mode;
+	bool frozen;
+	bool ready;
+	bool platform_support;
+	bool free_bitmaps;
+	dev_t dev;
+
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	struct crypto_aead *aead_tfm;
+	struct aead_request *aead_req;
+	void *crypt_pages[SNAPSHOT_CHUNK_SIZE];
+	u8 auth_tag[SNAPSHOT_AUTH_TAG_SIZE];
+	struct scatterlist sg[SNAPSHOT_CHUNK_SIZE + 2]; /* Add room for AD and auth tag. */
+	size_t crypt_offset;
+	size_t crypt_size;
+	u64 crypt_total;
+	u64 crypt_stream_total;
+	u64 nonce_low;
+	u64 nonce_high;
+	u8 encryption_key[SNAPSHOT_ENCRYPTION_KEY_SIZE] __nonstring;
+	u8 user_key[USWSUSP_USER_KEY_SIZE] __nonstring;
+	bool user_key_valid;
+	u64 meta_size;
+	u64 crypt_meta_size;
+#endif
+
+};
+
+/* kernel/power/snapenc.c routines */
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+
+ssize_t snapshot_read_encrypted(struct snapshot_data *data,
+				char __user *buf, size_t count, loff_t *offp);
+
+ssize_t snapshot_write_encrypted(struct snapshot_data *data,
+				 const char __user *buf, size_t count,
+				 loff_t *offp);
+
+void snapshot_teardown_encryption(struct snapshot_data *data);
+int snapshot_get_encryption_key(struct snapshot_data *data,
+				struct uswsusp_key_blob __user *key);
+
+int snapshot_set_encryption_key(struct snapshot_data *data,
+				struct uswsusp_key_blob __user *key);
+
+int snapshot_set_user_key(struct snapshot_data *data,
+			  struct uswsusp_user_key __user *key);
+
+int snapshot_store_encryption_seed(const char *buf, size_t count);
+
+loff_t snapshot_get_encrypted_image_size(struct snapshot_data *data,
+					 loff_t raw_size);
+
+int snapshot_finalize_decrypted_image(struct snapshot_data *data);
+
+static inline bool snapshot_encryption_enabled(struct snapshot_data *data)
+{
+	return data->aead_tfm;
+}
+
+#else
+
+static inline ssize_t snapshot_read_encrypted(struct snapshot_data *data,
+					      char __user *buf, size_t count,
+					      loff_t *offp)
+{
+	return -ENOTTY;
+}
+
+static inline ssize_t snapshot_write_encrypted(struct snapshot_data *data,
+					       const char __user *buf,
+					       size_t count, loff_t *offp)
+{
+	return -ENOTTY;
+}
+
+static inline void snapshot_teardown_encryption(struct snapshot_data *data) {}
+static inline int snapshot_get_encryption_key(struct snapshot_data *data,
+					      struct uswsusp_key_blob __user *key)
+{
+	return -ENOTTY;
+}
+
+static inline int snapshot_set_encryption_key(struct snapshot_data *data,
+					      struct uswsusp_key_blob __user *key)
+{
+	return -ENOTTY;
+}
+
+static inline int snapshot_set_user_key(struct snapshot_data *data,
+					struct uswsusp_user_key __user *key)
+{
+	return -ENOTTY;
+}
+
+static inline int snapshot_store_encryption_seed(const char *buf, size_t count)
+{
+	return -ENOTTY;
+}
+
+static inline loff_t snapshot_get_encrypted_image_size(struct snapshot_data *data,
+						       loff_t raw_size)
+{
+	return raw_size;
+}
+
+static inline int snapshot_finalize_decrypted_image(struct snapshot_data *data)
+{
+	return -ENOTTY;
+}
+
+static inline bool snapshot_encryption_enabled(struct snapshot_data *data)
+{
+	return false;
+}
+
+#endif
+
+#endif /* __POWER_USER_H */

