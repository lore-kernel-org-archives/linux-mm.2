Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A9EF532C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08096B00A3; Mon, 23 Mar 2026 19:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB94C6B00A5; Mon, 23 Mar 2026 19:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59186B00A6; Mon, 23 Mar 2026 19:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE616B00A3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D1D3140DAD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:54 +0000 (UTC)
X-FDA: 84578995788.28.37D5A55
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3C4B140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h4/jHidM";
	spf=pass (imf26.hostedemail.com: domain of 3u9PBaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3u9PBaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310332; a=rsa-sha256;
	cv=none;
	b=cTH6ej7VsHStIvvEj0haXdxEeouAFBnOd8RcSRuLWIzLFpvuI4dA0Rc62AriMAlfDWARxC
	UtA3Ov8CSvlV502Io8AK1PjYUfmM6JumxBPoe18rn+PrU+sdz2x3P4FHolRRpcaQfUUSol
	Ro/TUBPwABzwm7EoJbgMCwuqJ+9/y7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmzYNzW0+Ct+eXaBxLnJaomUJdCksoGs2CQSxI1y3bk=;
	b=GBhZF+zByw8tbjMtMQyiA6FSqEaC2vcQyCvEV2wSB/CZWTxW9XK/mxuA+kfhTpHoR0IlGf
	4Vnvy5WRwSz+uHACsCOmfYQqF1e2d03rJJocDVIykK8qFlG9v6jH05RGRtF+pLL/ncTQoz
	vEnm9z2n3ZqP+GLvmLJ40QQ7+SafkRs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h4/jHidM";
	spf=pass (imf26.hostedemail.com: domain of 3u9PBaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3u9PBaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f058973fso1103377a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310331; x=1774915131; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kmzYNzW0+Ct+eXaBxLnJaomUJdCksoGs2CQSxI1y3bk=;
        b=h4/jHidMbSTaqeACXDQbBzKwDmqUL6W1kUNeXsnWbBWKL2O44Iu6r1+HDSLXt37bkU
         mVjg70VG66jLFVjPNWlSughvrx8JcQyplDHY6yN+sKfY3f5TD/FiFjVfay9sVS75wXLg
         rm0OxCT3uVsnbhComyc2ZgzZ684Mf4L+8Sjphu219MnfAeDhaq0XmZjrlNt0tKyQm8US
         nunzKNo03on//JwJ+BPE1F6u9m08P+/bJiSDmUBKo0ukND5UwNB2DGxifOuBxMYqVMFn
         MC+NhZldaOz646mBuxIsb2pMK4r8cLvVSVNFAUj5iW557LM2I+FxyFKQjGZCD7gf8ZTD
         mDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310331; x=1774915131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kmzYNzW0+Ct+eXaBxLnJaomUJdCksoGs2CQSxI1y3bk=;
        b=IZVqdQ8EVenPvQ0w6VHftU4k81GGK2pAH1/w90q/DMHRQXcwgKITzxEdBDLWvq1gDQ
         2Rz730bZ+55gqse0Ssdugaph1G2CFmXx5wC4iTsa6HuYSFdRrN3YkoLjSAeDs6fbdQXT
         8g8IYN22hAbIHfLArQ3lzwDUhMwxk/UWSGjfg27Ecflz6yTyOcmte/HuDxveih/TsTTs
         UOyqLaQ8Vn6/TE8obDOrE6itcGFIMp2V4kf8NIVfYO3c8MG8xmRNIR0B6tr6F1jmfrsC
         blil475Ys8KZaYVcVYp8DD0DrMgCy2k3Z7GvhC35UEMUZovbCcknZUqq3Xk7T8wJ2R/Y
         bAYw==
X-Forwarded-Encrypted: i=1; AJvYcCWU+bhNyWdwS33qQWKDyQ9wOHmyAQlVpb+48AN1QHkVBnUoSUa5crE9LEfB7AXJv8DlPhKEd11rqQ==@kvack.org
X-Gm-Message-State: AOJu0YxxOH4JuKZtfXV7Otlk9FUUaGXPt4Ph/Ph9G4u+mqlfuOeMR7sk
	PJFbIk+r4qMPbJ483Dtf45ovsB6opsFbPWNJX3McGeB8+E0vIatgCnX/jPbMHD+E8VmaxDELrUU
	vrks9/fpOFyOirg==
X-Received: from pjbfv10.prod.google.com ([2002:a17:90b:e8a:b0:35b:939b:1e33])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:a82:b0:35b:e4d6:73cd with SMTP id 98e67ed59e1d1-35be4d6748bmr4279808a91.31.1774310331243;
 Mon, 23 Mar 2026 16:58:51 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:00 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-9-dmatlack@google.com>
Subject: [PATCH v3 08/24] vfio/pci: Retrieve preserved device files after Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3C4B140003
X-Stat-Signature: 6oge4kbd7cusx4obb9uyan3h1xqgn8g3
X-HE-Tag: 1774310332-359080
X-HE-Meta: U2FsdGVkX18PQFM4/uR8w2uUjYJOiAv5UJTmvC/RoOGtxLh2e2pV0dKvMhITACIkDqZgr4uV0tn1cl0UlmgJF3UfXnnNTopUicni34kcmXAVFt+bvHzpo+uQ0K60eEGVP8ZR0/6pM4+UWaDyqgRIST117TXeo5JHX3xcfc6IhI8vPUzmPwFAUbUojiJ+DqTivO8FCkYV2If/dqTq9YKAEzgfHnmaeoDwu1TFBdMwWzS1EkY7JC3fXvCax9riErSVsvcrxTLSGVQCC5vU4McLG9Irxl5DvHa+KvYrf4MwZ4h5ZJyJcwoGdolI4mzgU+QJnGciat1rIgYDVsCkvIwSrrlgvjks6SySQwlUlIr5nJD85xs6QfBut4uQNHOIsp1pJo5+939wsOP2P7YoF3fC4XnzjWnKtCCGxVH78MrCzEyCtV2R0B1NXiOyNUrytE6EVD0M2bJ1HskeMoaq/+RGlTafSBYnYNSQAY9BSy6NbL+m2OVSrbuFWDyqGzNtMA3US/wu31Ez0ghBH2wTR7gnGCh58Shq25Hx7wOJ6Net0raDOhoa1jW6Q1fm+RzA18qtBqk9Do+0tyIWtXiEk/D6KRBF/7KERLLVj6t0/v/U3fvdhYT5NXHEn0teZO0TwiZ4YfaSde6f/xwCMTCpKDmvRlzpa4nREvpnMnZn3diRC1RmY4F38KTfBc7/TWpyw0/IQbtk3LSaQMXPPagANmGSPRhKe3L8UfgzkdC6/Lt1l3/pWqh0Lgg5gz/SzNmeG3b9i9nAUBLBSOzXB9mC+NzGry7CbV/pVc25jKObNtPM2Mvry4UGRzh3cw+cVhENyqGIHUSyuzSq5M1InxijJbSBO1sxVM+7WvMOlJKUIhxfNjz3fD5+beoUOIdQWtayvApHpaesDbDiIxER7bxT5JRexR3vrKsF38BB5G9634NTQ3i3T7oT9hZgVGtM8qtaHumbLuxgmwhGLi7G4W3eoyU
 7QtXzph+
 DpOj45Q9RrftTrI/sYRiCDPnCfs84O9rjomddzvplLTdPAAscM6pb+xvKtq1MUCxlJWz4gmjXPDTotTmsiPfwOEBwbQPYQpTjbOIoGR5A5+qYC1GR9ShjZXnuw/JtUKD5jBi/YnTEavIZp6E6W/9WUn2dENY7UCCo+AB7sXwYQ8IEwDQ/X/2VhIXrkuhGdn26bLUlvfrPQIiX0BaqhD4cwhWglZkiDXGditTbnOsKSH87DUylApZnljvcLfplv0l2m2YC2qtwHUQ3d0wMvM3V1KU8ys1btWUivBnRI4rCzvzxkOyaX+impEbuqSy0XkUeb6AdcoRfWxUB1rSCFNlsXaICTiItMc8Ndjdm0/POHFTvqCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Enable userspace to retrieve preserved VFIO device files from VFIO after
a Live Update by implementing the retrieve() and finish() file handler
callbacks.

Use an anonymous inode when creating the file, since the retrieved
device file is not opened through any particular cdev inode, and the
cdev inode does not matter in practice.

For now the retrieved file is functionally equivalent a opening the
corresponding VFIO cdev file. Subsequent commits will leverage the
preserved state associated with the retrieved file to preserve bits of
the device across Live Update.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/device_cdev.c             | 59 ++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_liveupdate.c | 52 ++++++++++++++++++++++-
 drivers/vfio/vfio_main.c               | 13 ++++++
 include/linux/vfio.h                   | 11 +++++
 4 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 8ceca24ac136..edf322315a41 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2023 Intel Corporation.
  */
+#include <linux/anon_inodes.h>
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
 
@@ -16,15 +17,10 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-/*
- * device access via the fd opened by this function is blocked until
- * .open_device() is called successfully during BIND_IOMMUFD.
- */
-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep)
 {
-	struct vfio_device *device = container_of(inode->i_cdev,
-						  struct vfio_device, cdev);
 	struct vfio_device_file *df;
+	struct file *file = *filep;
 	int ret;
 
 	/* Paired with the put in vfio_device_fops_release() */
@@ -37,22 +33,67 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 		goto err_put_registration;
 	}
 
-	filep->private_data = df;
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
+	file->private_data = df;
 
 	/*
 	 * Use the pseudo fs inode on the device to link all mmaps
 	 * to the same address space, allowing us to unmap all vmas
 	 * associated to this device using unmap_mapping_range().
 	 */
-	filep->f_mapping = device->inode->i_mapping;
+	file->f_mapping = device->inode->i_mapping;
 
 	return 0;
 
+err_free_device_file:
+	kvfree(df);
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
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+
+	return vfio_device_cdev_open(device, &file);
+}
+
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
 	spin_lock(&df->kvm_ref_lock);
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index c4ebc7c486e5..4b83a02401aa 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -39,7 +39,13 @@
  *    preserved, so there is no way for the file to be destroyed or the device
  *    to be unbound from the vfio-pci driver while it is preserved.
  *
- * Retrieving the file after kexec is not yet supported.
+ * After kexec, the preserved VFIO device file can be retrieved from the session
+ * just like any other preserved file::
+ *
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+ *   device_fd = arg.fd;
+ *   ...
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
  *
  * Restrictions
  * ============
@@ -85,6 +91,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/file.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
@@ -180,13 +187,53 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
 	return 0;
 }
 
+static int match_device(struct device *dev, const void *arg)
+{
+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
+	const struct vfio_pci_core_device_ser *ser = arg;
+	struct pci_dev *pdev;
+
+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
+	if (!pdev)
+		return false;
+
+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_device *device;
+	struct file *file;
+	int ret = 0;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	device = vfio_find_device(ser, match_device);
+	if (!device)
+		return -ENODEV;
+
+	file = vfio_device_liveupdate_cdev_open(device);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out;
+	}
+
+	args->file = file;
+out:
+	/* Drop the reference from vfio_find_device() */
+	put_device(&device->device);
+	return ret;
+}
+
+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
+{
+	return args->retrieve_status > 0;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
 static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
@@ -195,6 +242,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
 	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
+	.can_finish = vfio_pci_liveupdate_can_finish,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
 };
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8b222f71bbab..e5886235cad4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -13,6 +13,7 @@
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
+#include <linux/device/class.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
@@ -1766,6 +1767,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
+{
+	struct device *device;
+
+	device = class_find_device(vfio.device_class, NULL, data, match);
+	if (!device)
+		return NULL;
+
+	return container_of(device, struct vfio_device, device);
+}
+EXPORT_SYMBOL_GPL(vfio_find_device);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e9d3ddb715c5..7384965d15d7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -393,4 +393,15 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
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
+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
+
 #endif /* VFIO_H */
-- 
2.53.0.983.g0bb29b3bc5-goog


