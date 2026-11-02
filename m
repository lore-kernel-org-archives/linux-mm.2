Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2845F606BA5E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g/gSVra2
Received: by kanga.kvack.org (Postfix)
	id 72BED6B0648; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666666B064A; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A776B0649; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8ED6B0620
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A61881A0190
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:12 +0000 (UTC)
X-FDA: 85390582704.11.0D74F3E
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id EFFBD10000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="g/gSVra2";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Ja7oagcKCII1ovotynmuumrk.iusrot03-ssq1giq.uxm@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Ja7oagcKCII1ovotynmuumrk.iusrot03-ssq1giq.uxm@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+ppaxYmKgFAGGAkOJ55j6j/Hm1uYafLIHrUuvA3BIk=;
	b=Jszr1ZrJqn8T2MrP3feX2t9y06H7UTfRLhqSgO1nLbkuCrzgMDlCblGYmZu2ql7PTWhf/U
	ANH4EgLNx0M738tO44aaM5p2U2OTy1bN7mYd7FziY7DLnxiRniDSfiky3JKjf0Wj5HTn2r
	/MwPz6+1rN6qbFdLZP0QUI+E5bElLK0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="g/gSVra2";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Ja7oagcKCII1ovotynmuumrk.iusrot03-ssq1giq.uxm@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Ja7oagcKCII1ovotynmuumrk.iusrot03-ssq1giq.uxm@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633831;
	b=ivOcUZTc7BUicFHIDKYbpF5q2r3fKZXeXohM5oay9KSrCthNACy0RHN1ACQjM9cnrGoIvl
	N4EGH2+qbtrED90Ic3OOgfDy8iNemwb5SwTVX5mGY6wzdSRejoqzwkFt9p0TYxiPhqnNI3
	vdqFxDhfx43xtjJSecZhkG1Z8eNWPSA=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e987ec84afso27012415ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633830; x=1794238630; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z+ppaxYmKgFAGGAkOJ55j6j/Hm1uYafLIHrUuvA3BIk=;
        b=g/gSVra23igXu54lUT4CaSI+bQTDIV4ZCY9ThzFoi1258HBAt1ei1irA8Xzt7RsaH0
         iN47f9+n1dVMtLu7RiHXZlHt5AAQwfkmWcWSHVJ9IE0xXIvrr286uOEDQkWsDDzkVVHR
         GwvylTe0G6Md88B9A7STOp0AIOGB8gVYvRNep4XtS0v8kNMBocc+eK5Yg+/xvnIOgBnP
         16j0cH5U2HP3A5NdGE0MhtvrfXM1ZtUZuMJ88fgmKt808e8DygGC11w38P+BU6SfKY6Q
         1qzZCxoJeUaVfgIKNuuKkW1pPSN8+SV/RXzP93/Wnd+ACe1flx7Sw+Okh7qEptUR41ik
         vNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633830; x=1794238630;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z+ppaxYmKgFAGGAkOJ55j6j/Hm1uYafLIHrUuvA3BIk=;
        b=sTqNJNgDGhhAEC2Xv8PkbQuDdCX0oGjaiIxT0OrmRNxSQyZoC+Xs6AheyeyRxwzGF+
         SpAZaaRK/h5trHoYFGi17N0qAW3siyP68MyqDncqvHzixYNOz4/mt9SvojXoSmKdu25H
         N61tiEqLinZEJ3lL8oOUqFFtheZlHWPMGwSU/5XBstAnU3kJPgBMo3BL5F/rgrZ+RYSD
         tl+1njc/ym2FyXLnsOis5AwriSVQFjLfxBHkl6eaBRDmFhXBwPjsSvaeIUXsl/5fPxDf
         JjAnKErpLTyaeyxsdDV7tamtz+AEHa7Z9RomFS67l05mlt1Dz8fubOoGE+74XfzG0ooP
         6hEw==
X-Forwarded-Encrypted: i=1; AKwUvBz6hwGtaBA6soMG2+lGkD+P45pg487gT7xNMCqwBx2mJ89mJ06XbuMrsUnG/2rHDypZssSufdCeeA==@kvack.org
X-Gm-Message-State: APuU4Z9TiEDoukjmvk4+wZZfhLD1zQt2SnPZWz4rTASkMVDbFI7yIm2O
	RhiriCn8pJlXOzCBnRTONJVKHkpbWouz1f+v6esBcQXD8IU2w4Qfe6USjXKc1Up/8otN7Yz8ULO
	Cxmn6jzeZ0w==
X-Received: from pgca18-n1.prod.google.com ([2002:a05:6a02:6392:10b0:cd8:b247:58f0])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134c:b0:3ab:9c73:12f
 with SMTP id 98e67ed59e1d1-3ae897ee533mr8958349a91.24.1793633829608; Mon, 02
 Nov 2026 07:37:09 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:38 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-10-vipinsh@google.com>
Subject: [PATCH v6 09/27] vfio: Refactor vfio_device_fops_cdev_open()
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
X-Rspamd-Queue-Id: EFFBD10000B
X-Stat-Signature: tcf948rhc1hktpb594iqe7i1ich3wgqa
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633830-949192
X-HE-Meta: U2FsdGVkX18LXk69q2xqPc6Ojhdy0k3poxg2S2nhWZYgNHOWgQn+z58nD6oG7k20Viw3Jo5+0+jPWTSYUztOTgzb7cZ2bRNbj0xrlKOVrufmp5V6fSVmo4EMadjOT4z+Gte0nhxjAPsXDKlqykXsg+tHlhJoFOrI6OVaoB9DXgYZg4Vq0QANGcD+IaXerQEW2ebzvccWCJMalp+ik5yeO0jEigvp8DRmTkPvaV3koSLIId9Ch50CaBEscDvp5JfOLExvRSioWOXpMCNyP+AfsbCCgOsC5Zhj/JWGXAgGuizfAzTIEJNCZLKx7GBQZOZe20Lb1COOr4EdoOtKbPtHFOorsS+jCreFs9CK6k0rrVKuAsAGR8my4MBg3tpZqKwu4+RogTiqc1qk9TFbhvgz7MMCKGnVeopTEwVzKBCb6knpYr50lMITnFr8v0xJqh//rrX6GkG6ROTvhMi1PuWHvLUixGof9TdVQ4bEJfPhmCfSqY/pp2FzmhAzXmqHNdpneGgZ69DbKNZky95PqNxVE9VLab/GFcsaheqT0CxsclJDpZf+pONGCvpc0N1Yl7rRE+0deV6M7WENgyG4H5xL0Z137MuPn08PluLNl469sxIgiiO7h6y9OHIdI2OlzGQfbpHmDe5lVLp/1bRr9dvCLZyGz14jfRiytrBBXeLgs2YUFaYXEncBm2RqQnDhyVmOWEYcDfSpVfughbhGsyPaC3XeZLUzKxEXNyQb7WWyep4jXcp0KcL1j+bgOoHwwbN0a3GEwhBHeAm5FYCrpafcBjDyIMO2B0cWOMe/ugC9JgzUQofMSQMktxedAOKb4thAOtUByyKS+kCaB0ZRQ6DFiPR9BW1siM6NsI08kkyuLPoRsRMVIlyOD04ngyYgf2BY+r//JxwQx1X+vWQiilaXB2ycuCbji4rrCzwJ5gEV1pW19anAE4O2ubU3swAFo9U/y8FtZd3WxWUVwmvbpvj
 /hwLpKki
 aVy1pr+cDP55cWcCq5Kquw/W68ntCdsNL1q8bO3rXX+T7HA4dk4mkQo9Reza9fKdR8cbGLkTgNZhrLL9B6jU3qNjkwyObJUxtotvI8Mg/M8rGhi6WImdmu9U9gGLjVpx+Qz5QbaVTCnkcMM5ZHEo5j9NnGJ7vz+GZGHdfGw0ku6AFyo8ntRseIle8tTzIkK+WYPFMcknDx0GtdOVMbhXb/W5OMwGd/KySPsVuUAzUvewbdYkcoIV3fxoqeKs/W7PH9M1Tl+4ZeDHSuiK/n0vgxmc2vMXDa8AEr2NLS6D77Y8S3hoJgStvHUntCOTTfMs84kL8JElCYPioAZV4oBRU894K/wf4l7oieqQnhzOGL+FwxYxzJFFnqKLd1lvK1jkDF+slEF/aG71j0ZLORO8mDYHsCSEP2hxuc42kUIEqYzi4JDey4fxF7puVvtnrvSDIlyKHJyTEqWJBtXjCM75ynNBl4Jb4Hy9wYV+S4CsEPpEMpp6rbPas44sDiMWsZUVB4gpplGkv6k79tV82cIqYXGnTBeADbkunZiXopqklFRbjV0WMNeWzMf5mkyx9+BkMZdCH4Nfr8SbM+9BYZbYQOtLwHjyLTRDVYhF8z0hyua02tVKn7Z59WT17oniYgE4/GFHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor vfio_device_fops_cdev_open() to use a static helper
vfio_device_cdev_open(). This helper will be used in subsequent
patches to support opening the device file during Live Update restore.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 23b229468151..d83e99137e1a 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -20,14 +20,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-/*
- * device access via the fd opened by this function is blocked until
- * .open_device() is called successfully during BIND_IOMMUFD.
- */
-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 {
-	struct vfio_device *device = container_of(inode->i_cdev,
-						  struct vfio_device, cdev);
 	struct vfio_device_file *df;
 	int ret;
 
@@ -46,14 +40,14 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 		goto err_put_registration;
 	}
 
-	filep->private_data = df;
+	file->private_data = df;
 
 	/*
 	 * Use the pseudo fs inode on the device to link all mmaps
 	 * to the same address space, allowing us to unmap all vmas
 	 * associated to this device using unmap_mapping_range().
 	 */
-	filep->f_mapping = device->inode->i_mapping;
+	file->f_mapping = device->inode->i_mapping;
 
 	return 0;
 
@@ -62,6 +56,18 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+
+	return vfio_device_cdev_open(device, file);
+}
+
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
 	spin_lock(&df->kvm_ref_lock);
-- 
2.56.0.317.g454f8302e1-goog


