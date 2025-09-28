Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAF3CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C958E0011; Sun, 28 Sep 2025 10:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1148B8E0001; Sun, 28 Sep 2025 10:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A6C8E0011; Sun, 28 Sep 2025 10:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65378E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE85D1A0129
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:36 +0000 (UTC)
X-FDA: 83938947792.29.2710000
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 09AC1C0002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UBRwus1/";
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/q/puD8z9+rPZ0inzplpCRfxORdYIOwWjZSQ2//C4w=;
	b=mG0LFSQimIB4wZfbhXX0KuOCVWNXLA4JrqRkw/d5C4HeizvHzdD1w0uLSzkqSgSRu1IP4W
	hh4HedeiHqfWFijBMXrHT5K4D5eYGcWIk+2Lxx9Bwu9eOw/10ohEGo9tDi8k/jgW35w9TP
	uzKGAXJWEP3Q8hc76qZq75TXgFjZ8v4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UBRwus1/";
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071095; a=rsa-sha256;
	cv=none;
	b=QVneXAAEAn5G13O21g5CZT2lWrYdaQbyYmWb3TJV8/KMi9KLwIEMerq72RoFDe5+HnCv+H
	D9N7CudkZCwCEl4U2q8hRm9eyMVIM+paKWeBO+tz1AghY3gc9+4VHg0FG5rK3AQ+Zf3n5A
	+7fnvNYdqdjn2/DtUTJTAxhYKye234A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21C5443C1C;
	Sun, 28 Sep 2025 14:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891ADC4CEF5;
	Sun, 28 Sep 2025 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071094;
	bh=i2Y3vHfToIEFk8anTKMUMMKTS0c/P1FR6mu/WmchJQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBRwus1/5hOpa4vk81wm9MxjKf8WAb0q0h9O54wziTSKlVqUj/C3OYZVG2SnRm8i3
	 QMj5RJDrypo6saaeQTrEKQDZ85SrFP1dONGmajlOskmu2aLJ3Nqlro0gq5rUwcHYmr
	 jD+sJOvqWTiJ/k9/7ySAgVoKzDQL8bfTsckPJa4Ue4JshqoiuqiZKCBv+PkWtu3dPh
	 rNkgNK8Z/J0h/HLqk5SRUEKLzk1PVjgE5dI/8c/cGqgzF3HxzXGYLDF5KIzIvpeTQD
	 ubLhjVgqeo+fXJTdZ30f0d8Dg70rXL/8YrhUa0zRePoFNA+tdy1/t0gNUSBIWxS+3M
	 QCyP5jWuTAyig==
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
Subject: [PATCH v4 09/10] vfio/pci: Share the core device pointer while invoking feature functions
Date: Sun, 28 Sep 2025 17:50:19 +0300
Message-ID: <25c45db4338d9d51294cd0b6d1c4c2cc0e43966c.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09AC1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: p4hmdntdry6r7fj7b8jjk1dwh6994twm
X-HE-Tag: 1759071094-904424
X-HE-Meta: U2FsdGVkX19MyLkDRKlds4zkhgXZifl1uBRW+AizOvkO/qze+ay35Dwh+ODk0/QDnSLOev2n7sO94t3jEOORr1HGN/s/0RLDuTmMMVWYeadkJMXnfKlBDZOeNkbg9nAKKzjCN2w9vrt9ooSlSrbgMn6PpN0iDBXQYa8ae0Vs6rxT/tI+UihhyvRCWKz7jqTw9oBuTwmMS51xOMh3tZMmrA0NSjF7UBgQvNb5LjaVqrwXrJmqRwn4xoe9yX3FB66PX2ooV5isuDwF4ozBTbtwFh8tbBcCk8xqDolluwpzIOnGjsFcXagVicS+Ri5h1/bGoGK0iMa2nZk1pqCSyCTxdwSywWxKqVnY8zLP34MEy4GhsJc1rhWTmXmAScrWkwnv7cpApuWDVYGVfCTJX0mEkVxQ9lSK1qt0OKmxHAIS9QBGXp9C2bsB/IwCXpj3h4Kr3hs7maa+Mc9NvWiQ8qgARzWOQVLlWHaQdPwKx33aYbmHQFCAqSyiG/zgBUi9NOdjawQL9C6N6fzgIVgooDRNZXuMhWIHyyiG0yhd/nHn/t8CemyVhICbxxSDA+svg32vhE7cjFJIb0Bet/JYGA2de6n0o2YTtKu8cxp48DsYxSjMpKaZnfKHrQ+o88KIhb64uv3mlyAzJhOmNWg1PND3UVwRZ5n+KAQYMpkpCj5m4UlQkVyu70qlzizkYb3NjN5+X+T6rNfwbtYs+O59giw669BdYIibtX20XQz2NFuqGrBvfgBHe1Co2o+AdBnlyyuqeo5oSkHMxArMaoy3Imy85Gz7ZI6PIEg6gZTx+wqFJ9cX6yn0N/9IvJu+5UaPnkCZFQezvPRSBFERTT5o0KwZxX04f5iIDNmJAWCQBF5HnqXtN3HA0wqPUwVnjKqjgpxOvbZVPtJP+VzdUgYchNq6cciOxZTFXhEYZ77dtY/3GLr69Auv5O/eOjpy7KB7UQ5zxU/VJnU5eFQUX0xy+qO
 kXzOKBaK
 gAt8K408rKt5yUm2pA2QBls/8gTTdPjg9YwCyLIrEuVwAtVak7Sfx3DbGCHsm+LHSg+haDTBFMdj6VhQV/woOdahRCRBcqUAQNpxwGAxrt6bmf7ZgM02Qm8DDfC2IcrlGBKWf4gYgrkoKd54B46X5rAWiEZh0xWt5O+H9jzq+v6pGgpeP/emLO1PzcM5wS2mtrftyZyY7I7K5YBRkFrTmG9adnTZ47U/5nPY+dViZgzvrf0UyWfzuB2l3htGFtSqshGrA
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
index 608af135308e..0c39368280d7 100644
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


