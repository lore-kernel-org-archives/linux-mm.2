Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37F1CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084118E0059; Mon, 13 Oct 2025 11:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034408E004E; Mon, 13 Oct 2025 11:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E828E0059; Mon, 13 Oct 2025 11:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDCFE8E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 947A987A05
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:53 +0000 (UTC)
X-FDA: 83993468706.04.8493733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3561840009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7CYx+WW;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369212; a=rsa-sha256;
	cv=none;
	b=L5BGjUp866l9g/UNc3ltT09O8MoJ7hJAtJBq394nmwx8WLkYHiIZfx7G6fIuk+zRamRUtO
	60L2nrUQuNaz2QgMM3jeD2SLqCn0RzjEKzU5eejC8Fe3Mc345ITuEfKN91FYrFaAwagq/1
	OV+QAjkTueWbpJahWtvAueEyWzl5ZLQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7CYx+WW;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEWoWLBZTGkJyrBZofnJEqHW+1FiVOJoHq0ybylYBiA=;
	b=hNcQmk+aTkX5r34o+D1cBng/KU8CF7ZbBn8QOP+Nixx0KH4TJaSscrCApYMgdBooXGIEUI
	rMC2Ht+J+r2k7AjW1N2r8D2waBugDLGvInki0IvyGlTzNHEMNowDTW0sJaP4boUO48Uw2f
	NYFL2xqm09rvKmgOA1MiKnFZIvOX7dU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AA7F61DEC;
	Mon, 13 Oct 2025 15:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BAFC4CEE7;
	Mon, 13 Oct 2025 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369211;
	bh=2LvtMGkj2xEU2SPs19hsyJ0hr9Y4YDZsEt9CJ+6Ry44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7CYx+WWgkWcnj30LU5YryYAReZXTnf58IvgTtPQmeCHhenfmd8uS56NQVFUFAQgS
	 kO9fGMTc6P0Hz9U2wvRBD5OA8lTpIKP1Rh6IRBi7gSyth/g4A8BO4P+rJDsltkVTGG
	 qVEMS4s1wF/wPW7Pe/T9N+YsfIDkJlZpDDR2yI2xNFqmqKKsgaTIRawfGb28ojTWtE
	 0CzGrYobUjz/+UiviEUvN1K6abXPLBf5brEhnGHUZGIf/8C+Q/3roR+q6XEuTSfN9k
	 W8+PJehEg4coIqWcZ5Ky9knIcp7ZV11MOoGamqgAEyOinmNOONJlx/zeFINEOs5qQV
	 vxnPxjqDIM1pQ==
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
Subject: [PATCH v5 7/9] vfio/pci: Share the core device pointer while invoking feature functions
Date: Mon, 13 Oct 2025 18:26:09 +0300
Message-ID: <41bd18a3f80873aab63fbf704095d90dff5892de.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bxnacis3ak7xzcta97mitmzzq49oja61
X-Rspamd-Queue-Id: 3561840009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760369212-398564
X-HE-Meta: U2FsdGVkX19KF5/UyHjijgllMBcFNdTWYQdCpftVfwN7mDxylqNT+AHdoa6lEACEgCNF2iGR3csSi24BFtDWjZy1LbHO90z0h6wUdkUDx0xUScxTTK8PqIVtYFQ7KMSai0urCqMqIfGUyuOGCf+b8SFpW6St6Y+kjS4gjMX2nrWhUSwsiJRNP+1JhQh6WF6TuiOAvt2ZwVQc9m5XVF+rdMjgDNfKpKHoiRyKGyRNnBcDjG1/ff49vWQJpquXJWGGQnAiHungoZh1gY1Jg3ClEywA08LamXPiLyhO+y9bEMO0/1Dcp7xgH0c3ufi3Elyr9GkgPHKDD0PDfSAPPajqWT9TC0SXe6TtuJBEaxzvYicnBh9yn/kVo9BWZTMNByrj9NYxLzqgbCqSoWCpsIzeLEIIt6rhWKiXRZj6ox6btjBrFJG7XkPzhQvAY0nLU6ZzAJGXFkEokz5otlBC+8xw/CRyrKzC/CPm9CtS1PPw3xcU4YRWaJECHWxsl4+Nbb5u7v3x8Gzig6G7tUmPbbhkgUhjLcqKZCVGEo8k2/JmlnzTe5eON3GqPvYuieylYSX6C1xuA5lpcLG2aw9Btphivt7Jr02kuewOxul5RZsYyQCz9glFBCzBBgzv2gcYcmdK+3To2qrqvJa9SynQUnx4I47og1fmq+RTAEw4xqntUCxFFvXyW1WCE5/oJsp6mGEqN3ZPVKxg8wWeh9rLNf3STd3N43e4oZzXu6/o81RPAW/wTPdxgxNfuK/LhQG4nVnZ3G4vQ9laPd64Uhm5vvH7wY/hFyDAJTRR6QVI9aTQ4DEJoh2MBjJ24zXGCnDFXCyx5pwCjl8x6Cl9drOWMf8e2TPIFwJRMAxmi4tKp7WdR/vaP2lfHVy7178rp7e/zDW6dWevvyCJYds/7EgAUWtNWtwBbUP/bVzU/jX+i68/QnY2jS+wkIZraw==
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
2.51.0


