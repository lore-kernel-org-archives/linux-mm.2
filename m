Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091DDC4450C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF75B6B00F3; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A815C6B00F5; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9495F6B00F6; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58E0E6B00F3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 529421A0430
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:24 +0000 (UTC)
X-FDA: 84987730968.03.CEDD701
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 63B8B40009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsDFluis;
	spf=pass (imf01.hostedemail.com: domain of 3iFJWagcKCN8WJQJOTIHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3iFJWagcKCN8WJQJOTIHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042122;
	b=LCkd2P8+3i2ibgiiCYWLpZv8z4qrL/VFikab1Qy7MG7YbVBXj5+NEIYtAJrDMkcoEOt6MF
	UiZNVfpXX6W+UQYrcDvbpLvSs3nDw1UmKUFMG44amN8nSWdWWFGL0DiQY4NAF55ebIkM0c
	cdLefCF6tCngU6UkmpGnFMTcMql4S20=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsDFluis;
	spf=pass (imf01.hostedemail.com: domain of 3iFJWagcKCN8WJQJOTIHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3iFJWagcKCN8WJQJOTIHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHOmohYTYSD8/2ryEq7eNVyF04S9VyCIkpjOIEDjYJc=;
	b=nvyX1DHQHsWMyR7eRT/cpMowAy6JEIifI6yPMQWKVQ1uTcPOIkWAT0qF6EJ8PvZs6SdzW5
	Bd8sI44LGcrCu6wgracrtoImKXOHwSt6/gPoSCk/kxz3MkiAuiDheAly0zbnSzbCC6ilUT
	AgVdHsYVXUT7M7Ch+ZC4M3I0BjJQQoY=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-847a00bcbd0so5876553b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042121; x=1784646921; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DHOmohYTYSD8/2ryEq7eNVyF04S9VyCIkpjOIEDjYJc=;
        b=YsDFluisqg5rWrsVT2GxgZVbSw9tYfnOdGh0iNZe1wekPq/ZQcvuexMgU0/0DpslDn
         Ld5qf5ZAlFq9ffUBc8rjAbFfDDbk9QPweOIO7uAi7LyUtTj+Ng3cy14jsxgsP576RW0O
         a4r5RdA3nEI6Qq+WHTpSw5daiKWMVl1qeydmLaV8DaFy0ipIUWSOZODeOhdSS1eo6Pc0
         WYIj2yto6e/NBG2dGz8fR9GOC6YyaSWeExId5PP2+Al1ZzKQtfS8TKfgZGwh+AMVf/4a
         pIVnPwrE3owj9rmXzblFQv1t3/pM6amkO/5LakKT0VmKlXeVCXXMvfJeshAdHZE2Oxj3
         E7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042121; x=1784646921;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DHOmohYTYSD8/2ryEq7eNVyF04S9VyCIkpjOIEDjYJc=;
        b=RQIktianDn9wN/5CpHkGJjQA1CNAerxvhvJEKyXX1jH0jitP9dAIWbXdF4thWxcbKS
         3CgMwtVFzKRSZs5o8ZUA+hMAUjcSlICzPe1g5QvkhH9itXjYICUP/1gTwvdd3l+5qUVX
         VTg/TdUbBj8uaSiRNgXaWvyEOp+/+97/DBxQlUU1izd7c00KIWOblnR4JyPKQDGy27gQ
         tJl6oUYOOWmARsJLWgz+A/0qtyr8jc80Wnxpgz67QPYgFxUu/1eVPuB1U1ZXw/l5Uw1J
         PAGhDEW/aFRiKUB8wXWJGrsTHEyxaoxWWKDqWeJoc9G5W+CbZWwlEcWxxiZ1RxT3+hMe
         4bkw==
X-Forwarded-Encrypted: i=1; AHgh+RrqcSIemiOiw9gRc74sKj+pMKXay4WxNKPsOUr5akBZO2OdqB2qx7Wpx0H7pX2Bxpc40BsRjf8EtQ==@kvack.org
X-Gm-Message-State: AOJu0YxCpbYAZq5K2oMK8oP/FJbvTWrMoxbziOeWtjb/cFQ76ZJrFMvW
	2kGt1EccicWyeMS9eOawFB8oR6EowsIQ1Djc3Sq2sIUXRj6oIa3/3TOtSzxn98bvr31Fha+p+SX
	yEmQpKcLCMA==
X-Received: from pfux16.prod.google.com ([2002:a05:6a00:bd0:b0:848:8b16:23d6])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d19:b0:848:76af:db37
 with SMTP id d2e1a72fcca58-84889611b82mr12946882b3a.7.1784042120956; Tue, 14
 Jul 2026 08:15:20 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:56 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-12-vipinsh@google.com>
Subject: [PATCH v5 11/20] vfio: Enforce preserved devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63B8B40009
X-Stat-Signature: jsz5tta5p876ryai1aaowxon5qkcdwjn
X-HE-Tag: 1784042122-715422
X-HE-Meta: U2FsdGVkX18QxjByNKukNLSqbOqV81L4/SfZIYn6MKdori0D3M6ArBAm7pvXZ91qjAh2AQYS62hz6jrUIfJJ/CENjJE1qsZ/IA49vaUfRtl6AauaZgMgcco4tXbTz6pUksZRAW5B6ttT+iAvnKFJAb8GVhLmKkJcSi3V/Ec8PIAuH2KvN2kH3K3gsU/JcCzYd5MJk5dJqBl8BrmESQ3LjiOHLFIf2cNTektnmO0UmWI3n2XSJxIsROoXMBqIX6TEfrMHIXWDdZMYd9VceYnAhsiEOvqxwCedxfjWSHassO1Pdw/1R5SpMg5AbQi1l6H8m0Lfyqg3Isbkj3VaAPwQZ24xzrPjPsOyNdIGBRyCPOM5d7NmHIPVGDR5zbXeCl91e3upokRZUnF4i/CjnfVms/mf5oIWXC3dr2ZkIPJmuSHKE2oH80MZtVQDj5imy4UnS+djS6VLwVFTA0Y6rTZ/WUUTl48rkRpgl1Gjc2O9x0RjW6wCtrbCP32S8j2WnPYatneYqcOBDDJCaXZ2wmkTOGHdenRY1biy4hySbK0Pz0hSa5Y2oUPhosZRGAe4UMKVfgUbJs+OrNb0/kCVVtBAPeO2bcWkr5awSa1Ny0r+alkMujOkSMNZSC0FuW5sgmHs7F28z3v1vrG1orZ3/JZ2l5N8QpQm6kmk7KJl0y47ImvtKGo4TZiBDcnhe8AdVn0g9nXlG/aZMQLvvNTHgr6RfwDLUl6ilvITr1e2xFQCceZBTkIanqLwcOc3OM6kizESuit31ryNEBlQAuKo11/FV3KHGzuV2+JSzN0OHNhJbuFEA65fQODli16fNHUKhSZfkNSdbwJGennMCIVwNVuXN0BMC+1EGyv7L7qHTsV2AZ0rv5ijeRwUj5QuEXeBqGcF9nv0c1a5ooh8fpJ3AppRLDs1GdqsX8j3cw1ioPq7NX6D2o2KjT89VSXdZ2MEAypsba6QAbmLe/yzzLCEEe2
 VtxTlY11
 MeCgBJMygX9NUXeEq8eI1sljYQuBnf15/niOBm2S4Eb5Sj5iDAoU/Lk+TJtzI6qIdsQ5sR1Qm/DCOQX6qO98FTqHMwLZk2PBGvCnvMeND9plmBYRv3EFc1VSAYxJksZ5/B1Gze1I6VOzmqM7ZqvJuRv5gLVzxqhRQttRkgQCm4AldS4Qkf8hEZVqMs0Ns8SOc4JS7SHlSs4HQcns19CyWZFeCQ8gnCe1/69xT9RZATwXG7cSw+qCpReJMHfmz+KHhHe8xcCPfVpEQHM+r0DesgEOrXYb0d3MLCXAw0rw1BkJ0jQOesr7HmEPOqb6lLktGZf11+vFOqEBD+V2JhksTq7RbA7GOP0qa5s6gXIds2Hwdr7XuksuVRqu/c+mYYvhlxFnJfOWTWthLDVhIJOUDh8yi4dZk1deb1bH1lrtOM3ZZg5ylVBv7oAyauYdW8X9NhAPTRwTH3cRhY+zZKxTmm9x7D0fvuUYbt0NjSRUA8L4Kc+s4AGbx6VKJ1kb9Ejm2JDz+IMDUqcyIUJUs+7jn0vupHud4Uaqw+46LDWaFaDmOMXdQCOhdhKeFbzdMUUwY2/zZRhILpo9G9pHijuMdd+BxA3rusf5vkyu5akdQYeVHhPTUnWjx+ykt0g0UcKfck0LY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Enforce that files for incoming (preserved by previous kernel) VFIO
devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
opening the corresponding VFIO character device or via
VFIO_GROUP_GET_DEVICE_FD.

Both of these methods would result in VFIO initializing the device
without access to the preserved state of the device passed by the
previous kernel.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c             |  8 ++++++++
 drivers/vfio/group.c                   |  9 +++++++++
 drivers/vfio/pci/vfio_pci_liveupdate.c |  6 ++++++
 drivers/vfio/vfio.h                    | 18 ++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 970932f22ecb..0050f0fe456b 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -49,6 +49,14 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep
 		}
 
 		*filep = file;
+	} else if (vfio_liveupdate_incoming_is_preserved(device)) {
+		/*
+		 * Since it is live update preserved device, it must be
+		 * retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD instead of
+		 * opening /dev/vfio/devices/vfioX.
+		 */
+		ret = -EBUSY;
+		goto err_free_device_file;
 	}
 
 	file->private_data = df;
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index b2299e5bc6df..62b4eaabc829 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -316,6 +316,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	/*
+	 * This device was preserved across a Live Update. Accessing it via
+	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
+	 */
+	if (vfio_liveupdate_incoming_is_preserved(device)) {
+		vfio_device_put_registration(device);
+		return -EBUSY;
+	}
+
 	fd = FD_ADD(O_CLOEXEC, vfio_device_open_file(device));
 	if (fd < 0)
 		vfio_device_put_registration(device);
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 4baac80d03f0..f0ea37d98696 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -47,6 +47,12 @@
  *   ...
  *   ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
  *
+ * .. note::
+ *    After kexec, if a device was preserved by the previous kernel, attempting
+ *    to open a new file for the device via its character device
+ *    (``/dev/vfio/devices/X``) or via ``VFIO_GROUP_GET_DEVICE_FD`` will fail
+ *    with ``-EBUSY``.
+ *
  * Restrictions
  * ============
  *
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index e4b72e79b7e3..496180950eb6 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -11,6 +11,7 @@
 #include <linux/cdev.h>
 #include <linux/module.h>
 #include <linux/vfio.h>
+#include <linux/pci.h>
 
 struct iommufd_ctx;
 struct iommu_group;
@@ -461,4 +462,21 @@ static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
 static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
 #endif /* CONFIG_VFIO_DEBUGFS */
 
+#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	struct device *d = device->dev;
+
+	if (dev_is_pci(d))
+		return pci_liveupdate_is_incoming(to_pci_dev(d));
+
+	return false;
+}
+#else
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	return false;
+}
+#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
+
 #endif
-- 
2.55.0.795.g602f6c329a-goog


