Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055E4CF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD376B00A9; Thu, 20 Nov 2025 04:29:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CDC6B00AA; Thu, 20 Nov 2025 04:29:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DD76B00AB; Thu, 20 Nov 2025 04:29:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5D96B00A9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E030C1607B7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:16 +0000 (UTC)
X-FDA: 84130461912.26.4688CBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 39E3740003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXL6WcNL;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GACwP4XvkejXRCBquczYVUnYPv2oxK1kBp3KDN89cxk=;
	b=GGAcB14M84hBmwcmKM/LayVAroi/AoGtZym6ENxUONAbhi9C6oKsSNC+hwbvuvcNdRZnN0
	sVi4lNWgrm7ZUw1GmXDHlCousLdjhcigLT054QgwW21ux+ih5lfLkoYwA7sa1bIBuLfpjU
	Z07sHSNT6BsSlwdGjC/ZpzYO4U5KKx8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXL6WcNL;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630955; a=rsa-sha256;
	cv=none;
	b=e5OxTkrW8vUm9h+wC9/e8ocR4K0NJRq4wIxfJbkiqtmPkqxrBvIME+NRs5Cw0JUisn5Zjw
	/63Euf3qpIiJwRHCoexzEVMzuRKhEZH5MCT7MaYQ3BHgr37ELR1KPfZRtbck3mMiHuRokb
	aBtKuiJIKe7cuFlSsEKKiHUKiHNpEhw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A710060149;
	Thu, 20 Nov 2025 09:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2455C4CEF1;
	Thu, 20 Nov 2025 09:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630954;
	bh=Lf+kWGlyk4dILuBBuzgoUTcs6RorNiR6HiVQt7aIne4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXL6WcNLp3wSGx7BunP6AQaMqVtZqsej0m3hOHdrNgJ4QQgo8/zDoo3gLrWCRri6W
	 wwILPPUUVO37MwH7vTnsNXFn6k+q4iVVdaU+ci5zQUpPEYLm5iF7egpO2o7k5u0UJ1
	 HwdB05Nmu4xyC6C1CahNSKAax0BZyPrfGpzvEtGaKqpRMs3PRdusrHsDnp7mWwXAeg
	 gRDgVXrHhrq65be4pARBcEQoAGuS3lo8A1wcdY0jUY4culPV+tRNiDyXsEK0HxjdRk
	 TCB32lrHzKioPUAyhTFfXVvlV3Ph8LK0fyt+1iHSzzxd14qNt31MTNhMf6M6h3HNml
	 +0FogN0XwNl9A==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v9 08/11] vfio/pci: Share the core device pointer while invoking feature functions
Date: Thu, 20 Nov 2025 11:28:27 +0200
Message-ID: <20251120-dmabuf-vfio-v9-8-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39E3740003
X-Stat-Signature: cpnt78jhoja47nsoia1d16j8unzmtac4
X-Rspam-User: 
X-HE-Tag: 1763630955-220442
X-HE-Meta: U2FsdGVkX1/UWSEk0Z5fcsIlUG+F9nAe988/MX1gCHnefwzhXdLnfZfCZTKGr8XrBKyKHM5gfDRAS8DmtH/QRCVaIX9CyLw7dHHIGziilVSGixdlb+Tl8syvdxGnhI3kXnRSm8PkzQezH9/QsP647mF+Zl/qribKLIYlJYdmDfUs/mSiW7yQNW2bDhPQum5oqIPpnPCw1XJa215t+xUt3brD0QPWZOkICUSPRMI39U4a4Pn7SNXQNPtxvw7TcgbgrIMAyJi7IUIUrRPZBLvn1QKcG2/9kjThZtPzbLzGxvyd6nyLXWs8takIExYZlYe+P50T5k/FMuhVsQxND9t81fIHsUwafaKbIWPmK9BE6CVL2vlERRJpygtxIslGyfPYegXOFZYIG365DjeFOZmqZXtLVNjLAWObZd+nl6OL7jcbT2jLuOfAYcPJviy57VDloF/+aoIWXZHugnl+Akn2uT+DypjGGRLSzvv7cCkyff8gyL7O9YjzEsSFJZgBjJRu5l7L/L3d6Ta/9CdXcBv5YGXFAkftCIa4R8Ep20sc1IWzsDDscybm6BVbYATl9umc5t/WsZ0Wi+Dtx/Yh6JnChj0cmu+J82eyv3Hr3QuZKfmHZIQDeJ3L7SD/ocRSfsuHqDQz/Z7dxsr2qnOaPCiU3LlYYdbwakZnMIEl8oqCKc2wwmwVQz07y3IuOh5tdkzeSsBs6l1O1XBS7Vx86ClZmxKQcOiy+gPbGyV0jefOExIfh18QGOcvXzbtTv4wFgHTRK6s3uWB02x/sCMZcw1j+tj17RDMC8gHQD5qKie5hdq1aUZudNvMLwnLAc0pOHOc8vXJ626I5064lR3osqT2G++aU2TzZn4rrfvshZYSf49uDk+5nJnpqRcfRsEnr+IdSM+JvhUWoIfhdLxwlwoAHmOUo9XY/xcNTUPNB9ayUbzMsPKaF/4yI29MuQFFyA+0SxrOEIlGPoaXDuMCvUU
 oxCj8X1e
 hjWIwSJpHfMYXADlfEIbJfZDeaQRD1PDK7ZL/7NjdRmuern0rCCeHZKO8FIOJBn0oaXNBE0M2lg0JxAOqoSwJIdYD6DutJRN0AEJxpVA14XAVJii8juntpf2fGK/8xRmA9R+h+8R0CYjG22GL9/4GCqpS1pGV9eqvXLtMWX4e/yaJcVvTnq+3SbMVM1Yf/TVgBosf2IeIYRcIAtbPWZk9r/DtB3jhKMxRJEsmJwtvgYvWca1qdXx3Vz2EicakfRK0U+0k
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..ca9a95716a85 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -299,11 +299,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
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
@@ -320,12 +318,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
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
@@ -376,11 +372,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
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
@@ -1473,11 +1467,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
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
 
@@ -1504,16 +1497,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
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
2.51.1


