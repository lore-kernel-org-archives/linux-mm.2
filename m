Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BC8C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0490D6B00F1; Tue, 14 Jul 2026 11:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CFC6B00F3; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51886B00F4; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7E7C6B00F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F7931403DC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:22 +0000 (UTC)
X-FDA: 84987730884.06.D586428
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 581A840019
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XySkOPXc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3hlJWagcKCN0UHOHMRGFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vipinsh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3hlJWagcKCN0UHOHMRGFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fk6o2vphXfQkoL1z/+pIbWzomzkKJfAmoavVaL/E+Fg=;
	b=y65i/KyKT2vMalF8lZMO93MP4MLB9wWi5Sq8SY1HMZw8wtNxuNPppAKTpAHm6gP+p2/Rbc
	rGaFlAlpZSOWbufhmLJwGjedqj2tiC2e7F6Q5aCQpwSMjWQFUCni1OENEe+xwbwckkODOD
	NR1VZNgYEOnuQAqBi3brT1Yvehm43Hw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XySkOPXc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3hlJWagcKCN0UHOHMRGFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vipinsh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3hlJWagcKCN0UHOHMRGFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042120;
	b=mxZpwWdkq7f3NHee/5jgpc2mOW92biWu4vEeAxGdJHGqpI5aVYT2KVcPQkeBWZBv1YgdKO
	o/m/zbX/fScdpV8JPznwYEU1UY/AZ7HBCjhZDYq4VCpYmr63F6yd8Q86X0Yen685rPITwO
	XXwL06+LMD0A75a7WkpvJwlRjKRhTFM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-38e095fd889so2136728a91.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042119; x=1784646919; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fk6o2vphXfQkoL1z/+pIbWzomzkKJfAmoavVaL/E+Fg=;
        b=XySkOPXcMOJRrP+xGfnnuMyb3bbMRmAq6Xo1un+y0VmO3WBCt1gPHWqjUOCujg2uHG
         5x07koNRNvhv2cHy0XCU6g+8jftowd3CZwCVhxt0bWktXpspoI+2fnb1u2llL4j0dpdE
         2EoZANEAsL8ZXquGJYS/bALMMye3tb/cN4pURVQWUUtSZ04xXQ+YqLPA+SoEKFlmHVJ5
         tYFW3wWHWO67LjLSHUHwY4lerLipdpdueoUUkUmiQnYhoZXcwCnKyXHt2ytR6nZ+oiZv
         hApxR6YV6B4yvrGdE5D/AxHFo8iL6jdIQPQvAga5C1bvF6I226BsIbuAxZAhyF4lMuYD
         MXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042119; x=1784646919;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fk6o2vphXfQkoL1z/+pIbWzomzkKJfAmoavVaL/E+Fg=;
        b=ec4FjNpeRLm73i76ymbT7b3UAku7wrWzp/oTge38eetLqkvglAdlrS4SLPYAAhB3ff
         /QmLNT/pNfUAyHT+v4QTAAr+PryGzJipjh/Qfj1WToyZ04ifb12rLZNhxDa20Plo0geA
         Trc+emWR2rRgpCUSXcVYXAx+J5GeCwrVlY4caVywMjmh2Eq5ICTh4fw4n/kLftEPPrO2
         BX1KYconjU6/JOoNm91OiJXdzrFfGVimGclENjvfKw5cDY25Op4x39cx/CvYnzs4p5Yb
         MjbUZCpz5aQ3yjcZnqgKHUq8zKKcpRdGlNPNiKiTVBmyyUd0GhX3R0ujPLm37AyZ1Zxe
         fj3w==
X-Forwarded-Encrypted: i=1; AHgh+Rro+6KMjYqtAORnFyhTfB3rYJEokkuNdC6g3iaPx6ld0PvxjlKVYazxJ99BaEt5Y8EBIjTArfUsNQ==@kvack.org
X-Gm-Message-State: AOJu0YxKAdUkUEieLZLPHOAXgP3M3hIqNOX2pKnQMqTOye1SxApPKRdG
	AKG0T+1QzrZvOscBvQueWyj2xWQ9SPYmqLZBkXO4fczo5ktX86a9X9KTaliHtxBVTcUTjerJrn1
	jGThX4MFfLQ==
X-Received: from pjyu5.prod.google.com ([2002:a17:90a:e005:b0:383:f7b7:fb7])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc9:b0:381:528a:808a
 with SMTP id 98e67ed59e1d1-38dc7735977mr13456012a91.27.1784042118892; Tue, 14
 Jul 2026 08:15:18 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:54 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-10-vipinsh@google.com>
Subject: [PATCH v5 09/20] vfio: Add API to open cdev device for Live Update restore
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 581A840019
X-Stat-Signature: c98cf17brnma9zyrrhaf4b3qun7a88q6
X-HE-Tag: 1784042120-488019
X-HE-Meta: U2FsdGVkX1/lMPTUlVL+cNsyV2JC1YHAV+muHi8GfIRukC+od6LzehvfpU4wYAKNGfpbiZbeGMGBVv+t6CkE7z3lnwyrdCVOyqq8Upbjihj8jkGzCZctRk8UfE9FTna2T0UiSwUaq/psq3sl5WTTH5b66MHUYL7vLLqAFxnpoIj6t9M0KS+8am1v3sjBrXPKe9Rwc4uhIceUhmLD13ETyktps9Vz/3OOSxdWOflLZOqayP9ZkIOkoFDIgZ9lqhg+zNu/JzupWAhzVwknpeLvg0MnS1nc294DAsIqRdOJ/xtrBZjxbTKOMBqRg9gzZqGEvaKd1m7BAdtIPGNA7319bnKTN/qkoTe7aDtXfT1YdILsztcdlQ2GBc7rmrUdaktUxspcMLeMnmqQkHi0Nwf6Zp3HtyC+nSJULDbAoRncVYoLl5OLhBW7kSkzluA0A1kDHPiNVSHDDNKPOdS8p9rrvq/IUnEcFR8HXu4iFTU727MrOQ3hZTHu28ZdPHtP3xdM6IM5qEWzaE9yZTjLEco3RLGWGhz5uy4FLGpRPnSEviPXkIR9cBsmTvje/NYznB0kE8SGhRd/z8CIpgSDodk7XVB2XVAPAVUk2yRa4CACt412WQnkurRumKqrxPNkxqr8xwfIUSYKrnvSy4NepTeDWaVzzsdYkwlyfGkdidU6bUvd2ttZEZYeaR/QOn/qVZgPSVIGMFDBUOjwwgGZy265EPSDXYnBzluSNzm6xv/U0SEOWtmSaQeXb/Oxpj7ht+SRK1burihO9nOo4pHEgPEfQWwTRemZPK9t48fxj2brGJ2BGVUtBfvg25ziOUG5p21HWMUJUb1aMM5NadAM3QQGFwAe9wc6cxYTrzR70clNlJpWhkqpZVJ9e8jjzquKAwgsB4AIfNmo+FbgnH5PkSWhyU8MZLeZz0ebTYx+4Y4CiqylZ14Nt++g9jtJCi9gwnFRdWwFehbnSTIEfIjnJPT
 8wA3Nbpv
 5+czSLGSPRmEEyPDTiEk6EQnEqN3QAuG+vidsKqoZdQTafxFCVCf0ZPQGMYq8CZQ2wpHVNW9HqrAJmLIZM0+G7DblM3ZLaawk4/9Kjn8eJsMcUyXDTOaiZf07um7UbaHUjgAeB3i6Tdd58dIXBp/JxZgjBnUXriIMWLhV2s9DpanLgzwln/voSHBj2dD62h/S+7VWdkIXLQuGgdD75U/Gw+y4FNXzNIFKQFJ0boXklOCZI8dXBTLM4Tkb61ehwZ1vICQO2tl/Bg/eSmdWczQtlmTYw5prGcoYa31JXoeb2Aw3phgFCLcQqHaFbB4rPVdUihSqNAnRTu1BIBWL8uhZCclJiQzVimBkpaIRGdrFOddQR7Z7hI4Et5A+5W3D/Kimn5zXQ6KElz+VdbWFcturXKwgyA4BwUxa4rOvyjXYN/dRbQyjkQ9cS16YauW6FUqL775qzB9sjBTq+yKkPSN5wFOhzzXHAEHz2EZK+JhWiYCjkydjp13ZJ8djgJY8cPYpAU8o+5/7ZiNEWZrRDWtQkS/CY15NyC0ac4gjiSp1oGC5s+QIQaExbcWPJBLSFTn5vq2SkCTeU2r+zEwMmWRbaE7wIm42rm3N9msBou3eMPV+v6cE9IWOMW2eyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During Live Update restore, VFIO PCI driver needs to recreate the device
file context that was preserved before kexec and return it to the user.

Provide an API for VFIO Live Update to get VFIO device file. Use an
anonymous inode when creating the file, since the retrieved device file
is not opened through any particular cdev inode, and the cdev inode does
not matter in practice.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c | 39 ++++++++++++++++++++++++++++++++++++--
 include/linux/vfio.h       |  9 +++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 2231423fe56d..970932f22ecb 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2023 Intel Corporation.
  */
+#include <linux/anon_inodes.h>
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
 
@@ -16,9 +17,10 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
+static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep)
 {
 	struct vfio_device_file *df;
+	struct file *file = *filep;
 	int ret;
 
 	/* Paired with the put in vfio_device_fops_release() */
@@ -31,6 +33,24 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 		goto err_put_registration;
 	}
 
+	/*
+	 * Simulate opening the character device using an anonymous inode. The
+	 * returned file has the same properties as a cdev file (e.g. operations
+	 * are blocked until BIND_IOMMUFD is called).
+	 */
+	if (!file) {
+		file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
+						&vfio_device_fops, NULL,
+						O_RDWR, FMODE_PREAD | FMODE_PWRITE);
+
+		if (IS_ERR(file)) {
+			ret = PTR_ERR(file);
+			goto err_free_device_file;
+		}
+
+		*filep = file;
+	}
+
 	file->private_data = df;
 
 	/*
@@ -42,11 +62,26 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 
 	return 0;
 
+err_free_device_file:
+	kfree(df);
 err_put_registration:
 	vfio_device_put_registration(device);
 	return ret;
 }
 
+struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device)
+{
+	struct file *file = NULL;
+	int ret;
+
+	ret = vfio_device_cdev_open(device, &file);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return file;
+}
+EXPORT_SYMBOL_GPL(vfio_device_liveupdate_cdev_open);
+
 /*
  * device access via the fd opened by this function is blocked until
  * .open_device() is called successfully during BIND_IOMMUFD.
@@ -56,7 +91,7 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
 	struct vfio_device *device = container_of(inode->i_cdev,
 						  struct vfio_device, cdev);
 
-	return vfio_device_cdev_open(device, file);
+	return vfio_device_cdev_open(device, &file);
 }
 
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 42c3a9ae3a85..b896c64b11da 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -430,6 +430,15 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device);
+#else
+static inline struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
+
 struct vfio_device *vfio_find_device(const void *data, device_match_t match);
 
 #endif /* VFIO_H */
-- 
2.55.0.795.g602f6c329a-goog


