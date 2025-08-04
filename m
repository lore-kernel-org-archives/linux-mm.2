Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DA3C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9FE6B00CF; Mon,  4 Aug 2025 09:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333586B00D0; Mon,  4 Aug 2025 09:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACCF6B00D1; Mon,  4 Aug 2025 09:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2A326B00CF
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9725A113F72
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:35 +0000 (UTC)
X-FDA: 83739086550.02.0E4DFAD
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6BF3A001B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XV0KBsfI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IErJ8hwikziaycARWGjLLogs49kSud96aBa4aP3bWGE=;
	b=1nhk39BdRALdruM014kRxwqyCt6Yj8s/MMAKS6c+UMKldfQit7IJzBQkYYVSKlTI10AImC
	gTlhPdXPadYaNp/23BNll+szQQWPWPjClpFtOhEm8kkYgsPeTclQOtAmj7SdsT55BXutAW
	3NVO7cCoryaAVVTO1fFod95UUvwhevo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312493; a=rsa-sha256;
	cv=none;
	b=xgALbXGD73gtD+nHZoRewzH5dM8Jx2qqCBkAihb3w3Wljp1FN1AE/MVUEYl0bncGcO6ZZF
	6KYhVSyUdps1bbjqa43jJk/kdG2OcN3iUl8FkAiK9OHUOq8Gh0MMm3/JfLCWvoZXbt8GV7
	a6O19pvel9JeUIXBhSfex66qhv7mzhE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XV0KBsfI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 06E595C5F7D;
	Mon,  4 Aug 2025 13:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39D9C4CEF7;
	Mon,  4 Aug 2025 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312492;
	bh=AHA0P/Nm3MFlnlKkj5r4HoWHOsf2P08Te2F4iJNPR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XV0KBsfIDTwl29M6z0s95tJW+KyseHoOT1FtNUuA7+11uf5VFDbx4XPmvH3RAay7j
	 3b3OY9xdFfQUubLEg9potVqnV8ZKrMGzGBVFuIaRSis5iYds7HEscoEET3vt3b7aVW
	 Wb38mBNWStwtDdLorcaxEqG0WQSUSVGINJzOWhmBCdnBoA7d7Xfu4H5E4hUzOLw63C
	 r6gwHS3+Lq7ACSqM34Y+gkfNfz+uK6NdX2FoWlyLjJ6zHmsa9rTHKU5zv0X/4Tpr4A
	 JC0D9dUw8ptcgXALHLLrrV41fRYfElFDNWoO556VbtcsivLAvssORg5yGwoFwfHtWv
	 +yzapMQI/iTaA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 09/10] vfio/pci: Share the core device pointer while invoking feature functions
Date: Mon,  4 Aug 2025 16:00:44 +0300
Message-ID: <cc1b626e148e626301637b5872567c4e36d84ae0.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6BF3A001B
X-Stat-Signature: gq5eox9w8ow4cefw7kd3nnfo3aopimhe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754312493-644810
X-HE-Meta: U2FsdGVkX18wRohtfFmxxAcJE5odC3aSWFCmkaErAcKT7aEm6MBysO8WVOdqUQR2lwbxZXRgowCNcHNw8i0aWBNskGRAQFZ/QSWdhOb0sz/3LEkq/CpZz2MnEqlM2Uw6qTMRMuqqgfw45pZjR6MRirIP8iZUaWJJrUIk9niHcg1cVSmgEFOYmFXK+zDWfgGo/bH6Sx/BdwTPZ1Hdy0JWM2rMfmm62pJHRGDtYe3IPizuWjYnUJiyY+MhFx7Z7Iefr1rVV9/BnPqSZvc3r8dUSDe2oZzLP/HpZrBlWt06ucNFvsL9e2IT/ax+G08gciOE88L1+np2H/fF2O3gkNDJx8PEgslKF0xe2qahlpBq5zG+XL6S8rT/bYPZDS/vjiN8K0Mdj9vWb669aBxuKtOWVlf/r0TENMjQvKngUfoeIHTDCCyZ449Wjz3D2ahXkWI+WleZlQO5PThorm79WghNsL691t/5Bsc0iz2jPZT0rzDMhl5cnVvlPezId6Y28GL2KRUFXKy7TM4Kb0ZWWmZYMLkE4S0RNg0p/EK6qpgZNveH9u7Lxb3BoWXYEgAzY/acgI26x8AncFOepng+9vumCqwYv35BJsdiqLI9BTqonxNZ9NKzP4NwNDtup565TZXrk/uhBpVYac4F9D2lJVNz5312hGGAf1uIzU3c+bAaJPuOIp5PDFqtNjh8zwQXqVSy1/mHrhVhD+VDWOxmRwn4Lbqz/d8W45USl7rPsg6CddzPKOTSQ7mnbOIIiWp+H3+/Pc9iSxht/nw2pjfZIUw6myLHWz/8rO8AT1G6b3BnWu0VpSevXPq/OkMe55Nw/WV87P8ajbXwOYRglCqWI9zOAmngS0txMRYkIExCCGJNtIeNtkqmO6pXfKUw/3EgMYAjHYxVhtRUPj/LrywZeVkBVoon4+eNkylW/YlAxQMtv8fE6dHURCF4lQZ/ZqgSBhc9zYM1EHLQuWwfIrl1Nju
 Hngbo6PV
 BaQm8IW0WDybQ9Yb8mdP32QpQY7h23W8Fsl+Cy3Vs9DFq9kKsWemhYMT6B6JWXXDdrpRnlTLwNhH51/FEYMyWo+JmWyvkF71cPMrYjTE8yfysIw6N6FtIMzuL5h5QxG/XRYXUPF/z493C6PjvdVOdyNiCyfBdpQRHNEeEFqjMaK/MChMe9rdVatZ84TOYARxfQUNRE+ezH0NDubhK6LIgY/nXB4+Ck4RFVWEcqY8CHmMw94aya1uxwn0Y9mjpJtXPR2Q1zdzAAAbdaxBt0C/e11mOM3ZjSNotUg7q
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
index df9a32d3deac9..b1863d84b11aa 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -300,11 +300,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
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
@@ -321,12 +319,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
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
@@ -377,11 +373,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
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
@@ -1474,11 +1468,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
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
 
@@ -1505,16 +1498,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
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
2.50.1


