Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7B9CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41008E0010; Thu, 25 Sep 2025 09:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA228E0001; Thu, 25 Sep 2025 09:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9948E0010; Thu, 25 Sep 2025 09:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894728E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:19:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63CFF1401AA
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:19:02 +0000 (UTC)
X-FDA: 83927828124.27.E4C466D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A206D10000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:19:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPRxNcAE;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0f7RnSIIHiN7nmuSadp85YscNFoMKwcadRscFC2BPk=;
	b=6aP7G3LBhHziK1Z+fAIu1Po1297E/BVMuIGtJD+D+hV1+jvXRPD3zgbdzZj755PcZUX1L7
	kCp+UI+ZqG2r4fjZTQQ7aDX8lMLAW/wVSdeg4BQO35IZT1uLGJfsVn1ulg8HpMLf848X1X
	r0Y/46i534nrKJNcU6VyUl90VRSZZwo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPRxNcAE;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806340; a=rsa-sha256;
	cv=none;
	b=bENQLl5hIu4Axv+OqOlJ7kXUJ34RQwJGyaHJHHQyFeZhCuEhKm1OfRY4WS08SGelMiNRt0
	1elY4UqALQcQKP+gcifFA7679DwmJ6xOvSvLMdQcyEKKsOrE+hHrnVlWY8zagEsDIDwzPl
	HfuH+ggOhz0WVEVkcSZKS517as6s+Mc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1D99435BD;
	Thu, 25 Sep 2025 13:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE2C4CEF0;
	Thu, 25 Sep 2025 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806339;
	bh=iaKDo8+GXeu4wXRq9Qaze1AB6MboGJIHM+btEoU720U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPRxNcAER0sBWU04ti7ERNNBjC4G0s3V1tSjBJcRkLsU27oCADu167yr+SKaKuJsV
	 3cxMTsFtjpObe+gkW2NlpiwqylI1bAjB+9UeAFjc120uXcKXRhetP6xq7q74RVf87B
	 y46YRc12SJmkX26594tJiP5IyYUGlZwvCeM4FSHaS3WTlN6BlhzMoDMRVpdQQ9fEvL
	 ZgkbbZHTmFBDD1WwZiK6z8vmuNgMg3D/DIvKBXsp20NSTz83EptJGRfomKMu9xlX7a
	 cd8k2BAfxMFUmK37XcjUessk/YtP+t+hk5M03BU0Jx4lRwIemZaMzOvNCUKt1Hhvzu
	 TuQn5w2tocV+g==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 09/10] vfio/pci: Share the core device pointer while invoking feature functions
Date: Thu, 25 Sep 2025 16:14:37 +0300
Message-ID: <6bf5ecfd312ba0f2e71873322def45c7e42a1b1d.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A206D10000B
X-Stat-Signature: bfntnqzpbr9bgzoj4sfqbcz1ytfrxyod
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758806340-481714
X-HE-Meta: U2FsdGVkX1/4p/Ty6yZEzqWJjkZaIdFYF6t++z6jLIRU3JipRTe7cm1cUs6FKeOhFd7XrCm/nAdRtaVycJ9O4Nf2MiBxvQK4XnvjJPFOHt/9MCtq3sP2XKrNLSn0oP0/qLoqN/qwOQtyk2t+RNxz1XaStqS4quIQ/35zb3IdMGgrGXiFIbYMnf+jmkOq8eiEMpg9Rn0ukpJMXJNQIMk73rsLcqEx6yfjHUueJ8aJh75ZY1QFxCRvmnElltmCk4RAG6pD+5zsyyhStXfyPFcmpJxGPwwLH0GqsPltokMl8oFD+AomE2cCtfoAq0sa5Bq38BmpdV6Ej6idcMTzZQKFIV43dmM/m/eQLXCFSrto6rXQeF8YXNnMmidIaLiMNuSlD5ebIo0ogRruR9lvhmm+s/UuYidnSgnT8TEV0UTp4ieZjhCyYl7BOKASFktRQ9Q3rMLanso5XO4FUeFtccwrKyastzusNjKgsfvxoZ9MEYAsBPx1zIeXQDR24mn0awMPDV13jFESCtcY9gbxx02tf2B8GDKgKXaxbkMHIg0EhjugZ3Xyy113402trdAJREB4JDdAKFNv6y5h2C9i4Er/g7RS40zz8RdcU57Kd53/LnoPTmPI8MbckYXOH5nFEusdsxn5Y8o6VBwYgGbsHuZewYaHZeLQnD6Jq8NRyT8NwA8I3m0LrXRkTeTmiuKfEgHFnRrH1Peyjsg/x98hLAPDrgrAXmOMvqRdkiUhBTZl8a3+IzAwvwBh36Peo0coOOOPscW+G5jbMQuIFCvmVUyT5x1ofkQN9GIuSsGRYy+sM29p0CLwR17FuoCreAgB3rW6ns/ikVBiG5sP7ZT7BGwVeiWfZb/n3j2GfFB4GPxiImjyPnkr2/7BG7ktAIxT2rJYFc7PzyjZRlDui6RuH0JSF93fqth6EEKcoE+blna800/cltNhC7fdJu7gMsE56okUkve5vHK1nilUWYC1lnm
 02lS4eE3
 BoqLN6XpdCiUxGiz1gUfsiejsCyR+IkeKs+aQD3FMtBYPXWapWhSMr8jC1fODAsZACU3DcnqMx2L9ysId391IXDak1x7mkngwL8h7750RC99grPH8AZOKrp7BYS+CpD7AueD287TJ4GCvyyTrDKOyG3nu/Gny5FpL4TEz1bPVw3Qu5RZ5D/aWncPj8/Qy84hSybw93pIqu/trxKaRpDaUfTtHHQf0tZzji7FgvBDRClvfTmKkpBWnxl3ybeqa0cZuLjde
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

There is no need to share the main device pointer (struct vfio_device *)
with all the feature functions as they only need the core device
pointer. Therefore, extract the core device pointer once in the
caller (vfio_pci_core_ioctl_feature) and share it instead.

Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 356a0e2fd3780..17bf711a929c4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -302,11 +302,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
+static int vfio_pci_core_pm_entry(struct vfio_pci_core_device *vdev, u32 flags,
 				  void __user *arg, size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	int ret;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
@@ -323,12 +321,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
 }
 
 static int vfio_pci_core_pm_entry_with_wakeup(
-	struct vfio_device *device, u32 flags,
+	struct vfio_pci_core_device *vdev, u32 flags,
 	struct vfio_device_low_power_entry_with_wakeup __user *arg,
 	size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	struct vfio_device_low_power_entry_with_wakeup entry;
 	struct eventfd_ctx *efdctx;
 	int ret;
@@ -379,11 +375,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 	up_write(&vdev->memory_lock);
 }
 
-static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
+static int vfio_pci_core_pm_exit(struct vfio_pci_core_device *vdev, u32 flags,
 				 void __user *arg, size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	int ret;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
@@ -1476,11 +1470,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
-				       uuid_t __user *arg, size_t argsz)
+static int vfio_pci_core_feature_token(struct vfio_pci_core_device *vdev,
+				       u32 flags, uuid_t __user *arg,
+				       size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	uuid_t uuid;
 	int ret;
 
@@ -1507,16 +1500,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
-		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+		return vfio_pci_core_pm_entry(vdev, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
-		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
+		return vfio_pci_core_pm_entry_with_wakeup(vdev, flags,
 							  arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
-		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
+		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
-		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
-- 
2.51.0


