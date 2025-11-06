Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CCACCFA1A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5548F8E0015; Thu,  6 Nov 2025 09:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504D48E0002; Thu,  6 Nov 2025 09:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD438E0015; Thu,  6 Nov 2025 09:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 299E98E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1CAE5A8E1
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:44 +0000 (UTC)
X-FDA: 84080385648.10.91858C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E812140014
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbWrLmrR;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WInXgELx+FTcB6ExpPv/f9NvbmYZnjNwRsqqPwtH2eY=;
	b=BfZo0QMVZttAvaSY21U+O+te7vEuwL37HZo3YRjBew9+r3MEsGpQFD8n4boT/0w4c04A4b
	+7UGvrH7frdSQf+jlKQWXnLTcLbxW64WfiObUg/ntwH9uK6eFfjiSxE3UvLEV0er5I3ThX
	RESLRrYPK1+hPgEpPk0rZ6oLwr65CEU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbWrLmrR;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438663; a=rsa-sha256;
	cv=none;
	b=wdOVXZYXzqG0q8Y7/PFGVeRiQIDINXNjqhbnbZe7YgV1vMtyW44t2hi9e/SBXuS2Gl4t5P
	vhTCTDh3jOE4LSYM863a1zHr/qaurAigSfJqZzVU/VYSQZ9VyNXpjVebMLJKS477cAqHnB
	Ud1pzGt0MflFas66XVzcLVftWelnyaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A635F601DA;
	Thu,  6 Nov 2025 14:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E996C116D0;
	Thu,  6 Nov 2025 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438662;
	bh=lS6T58DHt9wPHQS8Kvm1FHiA6t+nNSAifcX8vWpYDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbWrLmrR95yRGwZgQFxyAIvFv+U8of6rXPozSq+OTt7mgQ+V8yiiiv/iHOcNOHfz5
	 XG5xmC2GOlnE9xTiWOM4Bsm6vN7ax5N7AhcRpxeF0sOYPIKv9Wr3kdOzxcWeuR7PBN
	 UWEgR4b4iCbJnkPjehQYkur428/DBrwq0XOBGBzIce5PV6mV6a5/Pfki5dwXnWEleB
	 vVOtrddTtGXfNpfEWlvdaJyfGvmLqKk7mLEzzt9FMP/TIHbZDfqjh7w6YpIB4MHB0w
	 r0pLef7x+OJcZY8BWHtfxGC/d/YpZSnr23DQsQcaRfDCx/2oLe5YZETEI4pg1LLcbt
	 03kBdz7UN4m4A==
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
Subject: [PATCH v7 08/11] vfio/pci: Share the core device pointer while invoking feature functions
Date: Thu,  6 Nov 2025 16:16:53 +0200
Message-ID: <20251106-dmabuf-vfio-v7-8-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E812140014
X-Stat-Signature: 1kcogde77fh336ydrz1yrwmhka6r3nd7
X-Rspam-User: 
X-HE-Tag: 1762438663-771060
X-HE-Meta: U2FsdGVkX1/JltHc6KluPiK7478k7vY+sp/0gRi4i2KqDY53PjMjjuvPoqP9cLPFnXaqcI/Unvn6CZ6qei/BItnryFsVWMtXJfn8ZQfBSB+URRGq4JfUTZZJ4s0InhIvKwuqZYDg6zkrWwOSjdA3OIGohCr8GPCiTLJaBISbHbNFs0XIGRLy8kidYDpuhIM2l0VUbfCrAKfkp582aXo3jue1pWa502S+00bcLJZ4eHqGmeIJ77bsoLJ8mcvw6uS/My50j/75ZYhzWH5VOlT4ti6HjwBirGT8U25WvD8D1q+rlRwzctVoLPCaTmovDEATKdQ2GlIlZSQjf2JZxuad/AarCth3fW4TFK9Cd/tKVXBiKsBRlenzanb3RbM4j0ZjPPCuLX3vmXSyTBARo9xBZKQjmeETczcUhvKIClKr9WrYQGzk0KIlSy6PnPf8CZGnnwuQPxZnXK7iGV9za3vvXQjrr9YzWQRSqy6agfrdI26URnqWPkPqWi0pHWXI7Ax5cOIYWVkaausRP3E68RyUMh4U45+sPMy4mqerXIyeSurdec6YTrmi0XLh+QTtyQIhYZ+nJ2ywRsfTJUL4o1d089cONoraJ6gWh92r04+Eb1HOTbySKHrvBpRDKkKzVpOsQR6EEwYOU1qArTSMdagRofN7V9gjAEM49IK8W22mQcaBM92cXidWNWzT9+lEEIKz7+nRsrku2FPSbyicOFHKr5SqVarVOvAx5lzT/ghEh0S+koTAMlWYrhV9hnySxFMSuTHbDK6mON2Qu0oTaVkMzRYTWk+VX3LL17qMrTTf/GjnUGJrzKMzlyEWSPQMQ7FZbNn3BHigWRQPhcd9ACGfvxXkzpOixZUTsmYS/DOxI3sOYwCB2giCQq5+bIRL5Zwq0p/W0mDlK/Jhup2txG7n8hbLoSFGPZRBtciIQX/SM7X6WtTel9NoRjVwb/DVUXWEXOGNRt5XHIHWd1CjgID
 mK5LhBvj
 DNd12fzI239YuNpjzT50bsXbKFkS9PoVKYM/6SvO4RCHgwQ+AKqWMpmcfujNtBh54Eyk5VDoXrG5ToW+hB9F/SBCcK/QQoiWQ3psv4AwUlq5ZG8RnHbv4cNMyqBHbRoC9c6lktogQivmc5tLpO8tcPmEvvjRXkNhSIBEbjq26/ge5rCCLkbTPH8K2iIEZbhFAhW06NMkL5kP83Gpw72lOLJmML62kdY1WFQVv4IMBmK6kNiqHqd39zRVx7SEBEEtb+o+S
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


