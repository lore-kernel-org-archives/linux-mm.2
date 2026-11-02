Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8DA60EEC09
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IMmG7miY
Received: by kanga.kvack.org (Postfix)
	id CAA2D6B0645; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C2F6B0646; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3A06B0647; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9FE6B0645
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29FA240172
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:09 +0000 (UTC)
X-FDA: 85390582578.01.736759E
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8152540004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IMmG7miY;
	spf=pass (imf11.hostedemail.com: domain of 3Iq7oagcKCH8ylslqvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3Iq7oagcKCH8ylslqvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CTI6wZf9fmjJK3hlmivlOQee38QTMnwowyyRsW/zh4=;
	b=rDDkryUcxvn2ygqZ5CBYw1rhdN6HogcCrq0jL5NVHYp7JMLZ7DLU8XVBB2bFLXbXdcFBHN
	j827htyVT947Z+MLty7YBYibzn6W2442zshDg+bTciKUHAGdsVrVAdIv0e+ydxQxHMUBWw
	eypapZVMqrxT++Oi3A7TxKQhi9TRzUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633827;
	b=VHsOhZjkGy+lstoux9M5le+AGAvg5wzQ/VmvMY6DQB9x53bgzU8slnZ4LgT5kqfx3a9v0e
	Gt+e8iDJeCMzcnAPUFAKTeDnFZBtvrr/mViEEPwVIQT3hMvA12bHSWZaIkTivIiqcXCxXs
	g1HC/AlrEIzwsbH/RgG4vpwXPcM2hE4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IMmG7miY;
	spf=pass (imf11.hostedemail.com: domain of 3Iq7oagcKCH8ylslqvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3Iq7oagcKCH8ylslqvkjrrjoh.frpolqx0-ppnydfn.ruj@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e93f266d20so51211935ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633826; x=1794238626; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6CTI6wZf9fmjJK3hlmivlOQee38QTMnwowyyRsW/zh4=;
        b=IMmG7miYuwvCXOWGnrlNvu9ehY2bLY6x/y9v2lHX4Z5o2BfKugTq2yf6QX/vWkOci6
         PRApnrdOhh9LuMjydLEAB418tN37XPdMN1L0LrRysyslKHanoDIFoQtEGgjyrtc+QZEw
         3GMu2s/X+myrx+3bMMsvE94XhabHpqnTygPdr+HLv0B0We4lu+4D0CLTN7YGFaCARXH/
         dM4TVXywWgrmymqQvYwf1UHewTmDcr2Q95UYgDA70dxqzMNdmuqpxDG+BROKg5HTQkYT
         11nwJwZHvLOR90GngkxOAKr+LXecNMpC9xuea+4EJUWZpgzCaiOJGVcDJicysq6U9m8l
         SnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633826; x=1794238626;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6CTI6wZf9fmjJK3hlmivlOQee38QTMnwowyyRsW/zh4=;
        b=sfZDnlRPUqkTQdwkcJ4u4zywqGmFBMRZiQ+9Q6x4CPHPyLg9qU9MR2UbBQvVNDCWB1
         Kd2R4XtLCEfpCAMnVMzAru43AUG1lG/jwMGalBHRKQhrvbjwJmer4zpFeWtu8Swxfbit
         7hTxNaSlzsqklyoKnf5GlvnZHQbq8eWHi3jB3gA33BipY72/jfWcEt9uw7v7DVfzVpEm
         iDXm4M4OXC0cn5DEly2LhLEhfFrOnQZitIooARXRfzcg9ojqDwt2P2qfyS7hb3cRZUIT
         n2FXulsqqrMXldtWeZcRy5R0kz//HhC3OCgWqfUkbL5ysn+J8XYKmXPYyuxhk1q4EciF
         KBRA==
X-Forwarded-Encrypted: i=1; AKwUvBz4OZEF92uMc3Um2yt+Dvg3ZKpihixehyHJkQzH1tfA8ETayAxWYHN8TaupLgb8JeCTLLI9wUw3Hg==@kvack.org
X-Gm-Message-State: APuU4Z8w9dKPGNxzP8gFrMdw8rD9/lp7IbU134MVY/AXjVr9pUTPaDZL
	v5XG8up+zwgsDEb4WElgCra5wRJ6TWAPYL4x2/g1PPTdhwbyORdQZI2WtEb1xHa5AvQv13ncX1T
	vmo3ZXneD1g==
X-Received: from plct12.prod.google.com ([2002:a17:902:d28c:b0:2e5:712c:5c7])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b2b:b0:2e9:60fb:5e2b
 with SMTP id d9443c01a7336-2eb364e5a41mr100336855ad.44.1793633826227; Mon, 02
 Nov 2026 07:37:06 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:35 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-7-vipinsh@google.com>
Subject: [PATCH v6 06/27] vfio: Add helpers to identify device files that can
 be preserved
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8152540004
X-Stat-Signature: 951ugzid1tdcpagciq91yh5hxbu14pue
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633827-736147
X-HE-Meta: U2FsdGVkX1+byPucuiXqZ2yRb/PwQsdtxpCEhPULXFa4YaNOmrCYkpoQCbUESScAiBXJTuijOzMRvWafgH5skqCq3dnDPZNH1UwjCU3VT6hstKoNSlbLLzh5sMJq+XaEpyYKSavlUzu2Cdj4/N3TfNMXtATJZuxkByyuXz2P81fWwsBkr2406XQ9gvuRUNHYu667xiQjT9lkV/fzCaSojnMgGopnMBFcf3/7F/IOrk6geXJ6Z317QScL0ReR9gJgiEdDsCOeo4CdU3AeOuQAliYkR5JjfMEDk2zKjliKCZ1xSIToZLaccTuEdQnhU71AEwh+4KKUFStoKPg2M5f+Lhpe2/2xlAeYrj3f/Q6w50FH9j6AhS2IO/2rWJX9t18pTBLE8oefa5NAfqGaOgraXFBnuLPG9So0ejes80ntGijujpoXrjHnKHUJF/YvVPCC07819inDCJAg/7InrhR4V+13WX9tY4BzQvMz+Dim6vcZlXHndvxvSHOA6PaxrKRBWymlwuhGfwm6C0v8tpWmRDRXrYLXZQbJF7MIlLVBlOWqPmjLIDhul6YiMKuVfmJNKqkizoi8SGSiN+ZYNIbSIiiXci98HuEKogA0+x1gFc3mwU7AKbMEwqAIjP07xNcsIJqjt9eiwCeVT63irxipUmPaHD8O/nShkKUWDZkIRReJaeRKvOwTzu0Gzau2/k/02WtYVFZaHVJbRoFFQSq+SIcTukH5NZdQWjeT3xjP4F4AeJMWzoJjMlmJnSYDrNKEl+w7qw6cKbNTRxnIXAGSbVZ0WoJi0qLsEyOzKw9yhSy0HPcL2px0jDZROAzu7uUPVO4pgxYCOQxJ66sFmsKa45wdDhHezaWB2104R7JNI3Z6G+x6CYNrxEWtUo4gOTtfDMVx45y2oOwoZeQqZ22Z90jhN/MA/Rv6U3zMk/LQNCEF9gP8TGIyaYsgf+Sw0Jbyb8tgOEbnhR72w8bxM11
 +LerZnhZ
 rgYhXCyL0qT8zCgQmIQmIQvZKJXTWpVv/IJCU0TzrpHFeiQMOMX5LM+E0OSgcy8EyCbYp1MEh3GFJe6learndovNTRBQ/bp1oogdAqLt7NrJB3oQcXdP3Db9J9U5blCS03+iuXStdDrcgmRQkDKSyII/UxDLmoTs3fKp6w+ykU8BXRVwZZ3Xn6otcJ+NqEOR1J8/sddZzZQJ6Jj8WzHipzUGYHy44jWjjuDkGj0ssXhT4PyHiN/sQWV/VR66lolMplE8jAChj0fTupI2WAKSJ475/DR1ydaP3CVh+ErHO9BzFROOqVW/yuI/vuWMUgRlHp70QE1UyzVOviH/46tZUHkRnqdyMHG9q0TU0oNmTTVJWKRpv+4Y3FqD1CtPa1o35DI+hZEDlDlULy9JQzWGTAy/Fd9Yc1GjL+ZjwpJ9+ARYpvoTz2+5CPYAYhUwLbVEXfgl0+1y16R8m2ryQp+y4CguO2iaGlUZoPtz1qC982Sw+MvQqxhfv1W9vbU5WORsx6DN3EOCFlI/ct8xLQuieAqT4X9Gb3Ycrl+bFD+zjL7YgFIe2tkj/vDtRMPE263GNzEhhx8/uNBSAx9KMUEFDyWc35Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add two helpers needed by vfio-pci Live Update support:

1. vfio_file_is_bound_cdev(): checks whether a specific file is a VFIO
   cdev device file that has been bound to an iommufd. Only the bound
   cdev file keeps the device open; the device-level cdev_opened flag
   cannot distinguish between the bound cdev file and a second, unbound
   cdev file opened for the same device.

2. vfio_device_is_noiommu(): move the existing helper out of line and
   export it so vfio-pci can enforce that only devices in no-IOMMU mode
   are preserved across Live Update.

No functional change intended for existing callers.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c | 20 ++++++++++++++++++++
 drivers/vfio/vfio.h        | 10 ----------
 drivers/vfio/vfio_main.c   | 18 ++++++++++++++++++
 include/linux/vfio.h       | 10 ++++++++++
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 1d9515c967b0..23b229468151 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -200,6 +200,26 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 	vfio_device_unblock_group(device);
 }
 
+/**
+ * vfio_file_is_bound_cdev - True if the file is a VFIO cdev file bound to an
+ *                           iommufd
+ * @file: File to check
+ *
+ * Return: True if @file is a VFIO cdev device file on which
+ * VFIO_DEVICE_BIND_IOMMUFD has succeeded, false otherwise.
+ */
+bool vfio_file_is_bound_cdev(struct file *file)
+{
+	struct vfio_device_file *df = file->private_data;
+
+	if (file->f_op != &vfio_device_fops)
+		return false;
+
+	/* Paired with smp_store_release() in vfio_df_ioctl_bind_iommufd() */
+	return !df->group && smp_load_acquire(&df->access_granted);
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_bound_cdev);
+
 int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 			    struct vfio_device_attach_iommufd_pt __user *arg)
 {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 7728bc99b63d..12557d45dfee 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -185,16 +185,6 @@ static inline void vfio_group_cleanup(void)
 
 #endif /* CONFIG_VFIO_GROUP */
 
-static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
-{
-#if IS_ENABLED(CONFIG_VFIO_GROUP)
-	if (vdev->group && vdev->group->type == VFIO_NO_IOMMU)
-		return true;
-#endif
-
-	return IS_ENABLED(CONFIG_IOMMUFD_NOIOMMU) && vdev->noiommu;
-}
-
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 73a5c4f3751c..291460102cd1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1507,6 +1507,24 @@ struct vfio_device *vfio_device_from_file(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
+/**
+ * vfio_device_is_noiommu - True if the VFIO device is registered in no-IOMMU
+ *                          mode
+ * @vdev: The VFIO device to check
+ *
+ * Return: True if @vdev is registered in no-IOMMU mode, false otherwise.
+ */
+bool vfio_device_is_noiommu(struct vfio_device *vdev)
+{
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
+	if (vdev->group && vdev->group->type == VFIO_NO_IOMMU)
+		return true;
+#endif
+
+	return IS_ENABLED(CONFIG_IOMMUFD_NOIOMMU) && vdev->noiommu;
+}
+EXPORT_SYMBOL_GPL(vfio_device_is_noiommu);
+
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
  * @file: VFIO group file or VFIO device file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index de3fa6e6bf2a..3cfbf1d73479 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -380,6 +380,7 @@ bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 struct vfio_device *vfio_device_from_file(struct file *file);
+bool vfio_device_is_noiommu(struct vfio_device *vdev);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
@@ -431,4 +432,13 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+bool vfio_file_is_bound_cdev(struct file *file);
+#else
+static inline bool vfio_file_is_bound_cdev(struct file *file)
+{
+	return false;
+}
+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
+
 #endif /* VFIO_H */
-- 
2.56.0.317.g454f8302e1-goog


