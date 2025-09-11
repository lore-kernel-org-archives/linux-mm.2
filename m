Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B49CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CBA940009; Thu, 11 Sep 2025 07:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D1F940008; Thu, 11 Sep 2025 07:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1562940009; Thu, 11 Sep 2025 07:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98BF8940008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 347C6C0405
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:19 +0000 (UTC)
X-FDA: 83876761038.08.2E04ADF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C024A40002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLSpR4XV;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lBJ1FTNas5sGSOfpHfjwgnwQtCFa28oFws5/GyDCo0=;
	b=HaLX2FVpTqWu6BQXq557HCO9y/pQby4JMu/gD9jgXIltLg+hJ2QyuVF3G8L5fkaYdprCkv
	Gr7hsBbC4qAfFt+TL/9tirl9h4vyi0AFmTk3ee3PitkTEi2fN+C2Th1vlcV64d99RD5Hoc
	5nbuM85U7Z2S4bqqziyEa0odNbntg5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590457; a=rsa-sha256;
	cv=none;
	b=ZoQ6R77YCydxnNA8mMVLTvxQNJSPrIsq60zbur4Z/wAPZbqIDbzlh2Wt6+cZIDlsdH2X9K
	U+1JmO4RWgXOYD0ZvMLWPTUf+2mOAeQqJo1nWW5onUXV//iqzY1r7j7eba5SA85K1EEdfw
	Zxt/gtwWvCCFGpMIiYfoPt4CoJFZAFQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLSpR4XV;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B8376024C;
	Thu, 11 Sep 2025 11:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E0CC4CEF0;
	Thu, 11 Sep 2025 11:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590457;
	bh=PhzFzXMddFLogzQ1+sfQVWC3D0RD85wz8opxGTisAJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLSpR4XVvlC0nxOFuT0M+Z1GR3TYqT/D+HpYYyivu/WWYvcUm/5eEnYomYc83Baqx
	 vQQV3R3FeX6zD3Ry5O+yt/X0ZZjIVQVhlShuby8ilGZO7jQMinqJ+Y3Fshw36GHilI
	 WUj7T6HViJhrBXcgzduzEdpwFLcRS8UVXIDTFgXRfit8Mt/Cd5jQtt5EwtuuEunebQ
	 d0gwmY0VQ9h9ajQpOvGl+n75fi+NVOHJqgwfzQbBr0uFvzBM2XULSHIOfwMlC5zn4L
	 fnVBkh1D4hX8Qdbik5Gd5J1ZaLgvJfx9iAq6DLIj0tbA4Fympakch3mAwQoo4EWQoK
	 aSe7z0JdO7QdQ==
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
Subject: [PATCH v2 09/10] vfio/pci: Share the core device pointer while invoking feature functions
Date: Thu, 11 Sep 2025 14:33:13 +0300
Message-ID: <fa6ede23cf6917170bb086df13da8c0b5fe793ef.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C024A40002
X-Stat-Signature: p97fcp3c7xtmep3giox3qb91c87kc7qn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757590457-231425
X-HE-Meta: U2FsdGVkX1//nk3Fk5VRIDGDAE4iwbiVmAqkDo24eWXgU4esJOFqj+UoDxLbd4pJtIsrLt+RsdwlO5RzzDhkzx3Lpb7F/irGgu/bV6tDczj5DGCqKtgR+ANdVXeBET35AV4NK2UlCIsaVA+uc82pt6PJ0ttwOf7jxyC2afpBJFAyYzxeDbZj8LxZPoc59QazQZRwNrEdPT4rmCjR7hYw9SRHXCectZ9P4nh960Pt8cGOf8qnWvcBiB80YiMjSyk3j5cfIlRG8QcrG0KNeEmNuoo/hHimIGBIA06L/1sESfUj5PqQc46E1NqjyI5PTzUjLd7MhwOcyBpqx2EljSMLJsUMaUVOD9aZNerUTSIZUJJ4Gnx+siKAAW/6QWY9ctkfSmWfdaltRkLBfexV9dt9EhhHMxcgNbXe9vDrjMCncNWh9PCh0EtGMGLxo3mQEqUQ65k04LgvamQRZTvsKCgVtU7QYnFzIy8EnOnvme16D+IM6nBQDbpnVC13uiQJ7uT4yWydO4dCl8qv+VxLlR+7XcQ0Qp3wI3q/U5UXyOIEnRlNirO8pgxLBGaFIYEyXOaDCFqZSYDu//X/dXqWf14jRojmqriC7rSayP6dLcK6E9/kf9WzPmW03lQ8kVWdfj8YEhCTYBHjl8mMwv2XHiyrA6fLqkTfPc4guwAxfTzmJFUaye2vyuf5+Rf1tmv36hkVjqlKYY6nohfaTcZK1jXRCayeTkiJKFBxiePDBVCzxMs/+lGA27jMDHIbL1qjlnRyBIv+8A/he85V3UZU7WjyEP21NBGR2822xiiD7g3WwnToent0qEtf+8faQy5TdjeFBn79imVHWQkHtsv0qRNRZqm4Hw+ktv4M9ZibqCmblROHsRJ5k1mUH7C1XIYnZMKCOQ/BF2o6xUIH1yz+HUIdgPbWarO5N4QrKrCGxTD7QNJljgrdldR3Hg==
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
index b02dda8c96341..93b6cecfcab49 100644
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


