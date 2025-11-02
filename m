Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4ACFCCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197438E000C; Sun,  2 Nov 2025 03:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149848E0002; Sun,  2 Nov 2025 03:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A18E000C; Sun,  2 Nov 2025 03:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDE1E8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE4E8C084A
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:39 +0000 (UTC)
X-FDA: 84064922718.20.1B125A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DCDE220005
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJUIKTi6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070498; a=rsa-sha256;
	cv=none;
	b=jX0V0Mm4J6IyYULu6aS9PzcbZlGFMh0P+kHb9L4Sb1N2GkbhmjZ9wNlC8vLGAUQ6idmh8E
	g2EYC76Yqk4PcJgud/XqvAak8nuxSlhFTBxxGBKkv5jvdV3HjQCZt5lFggN28U4Qv53LMt
	97NTKy5+qOLzTYLd9uacF6eioV2LHXk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJUIKTi6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d03z8PmtrougYvCYBi87t/0b452LDO+ayVMxh0b5S4U=;
	b=Ddb5uoXSzOghOkHKp/UBC/XvNhQpg97xXf0gyWtJ/pMKBT+IGiho2bm5IqSBJTi7VUOCxG
	+8eh6+qDPaf2eFpJ1PMp7q3rMWRZeGF3ZRSS9p45O4r+BhIiSUZHgXsVqsDnRgYD/duXu7
	apNlRpHLx5AMBu3ETh6F6HHyqoAFOe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0244E445D5;
	Sun,  2 Nov 2025 08:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C5C4CEFB;
	Sun,  2 Nov 2025 08:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070496;
	bh=dlJDZuIUPdYxcsRxWAdBRAuyHBpo2K29Gx37eGDRDtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJUIKTi6tWLzuTQ+8t6twCDK/tg7Lk2+AhK4dlUnKfYy3x/Um36xaiXcqTuy8wU/r
	 Rk0ZRClC4Mk1jO6S1IJDJwXuApMNam8YEtAanosZCNY4KCRDPmw5iofo2xMr/ILulp
	 XVBGNUpppvdiGCvb6kpVjwEzEXCuCGGMHQPcPWgy/RzO2mBrGyf7tcakOjogF4ecFg
	 b5KTUhOe1dl4hkBx0/RsPmFR443HjxsLhGJPvucnmHB90Ac4sJ3GkbIHWEVfiYn0t9
	 iBDGiw8OJQSjm/HLG7rNsTbPVBTDxPrgol19j5RA6hb+fpdao44SQaBHpBOYH61drS
	 S3RgXkEOCsmAQ==
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
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
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
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH v6 08/11] vfio/pci: Share the core device pointer while invoking feature functions
Date: Sun,  2 Nov 2025 10:00:56 +0200
Message-ID: <20251102-dmabuf-vfio-v6-8-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCDE220005
X-Stat-Signature: gesjynd1c79igmzeiez9xs6i4ybnue6h
X-HE-Tag: 1762070497-539146
X-HE-Meta: U2FsdGVkX18zGfLVMDwXHyuLy1klsAdNSVvDl0EvtIzkDUtvUPwOj2WNa3lPCyWlNt3zRnfjY1z2YOMTV5gYuKqZcIOkNTXfdkMtzlez3vSmdnvZ/W1lklrpmDYkDgN80r+oxj3lRvdnMLrNBvVR+2UlSGwSdGeoAnkMa3RBZvEuWUh9X3zDrm5lFu+Tdd7pw+bWaFg/NBeBpEmYxZIIsHykOdFpTur3x/cmfV4KQatx/wePCUk2mt5DmDDk/M/YiRD8a3ZQmK0K4GD4eVIlkUzc3D3QlYWLHSWKz1gt/Uo5a17YYwAkgKIpHL6cD8NRwXDOzpdZvIdgai9p1anWPT5weLJWZqKYc2wtrSgwGBnDsRwlJZ5H/U3wQAG2aDNxjo2AkegfZSH1FHMG8Z8/pplt7hWNCkEhinoM8GUN84DTz8kAvv5ssuegxnwdZ+bC7ZNATrjH6u52UGLoPEf+PRQGvnOE9pGYPTzwqxxzM0fdG/Cj/orZG2Iml9lFQ7JQJBR/Q93RAx9YYt+XLG/3aCGEGuBhkgMh3AETgBcZS8eta9s9MjxOOORANOV3ym94gOcQ4w7AuWWxcbTziRCmVMKsHRnxw7fYEqmZEKUklSLlQ/KTCZxW3Y7vbvb4Z0rqfadB1uCEQbT0qhA81SaoU7pbj8tiqz1sTjk+L/T0aG60A3fqKiu9q1gcs4tiMIGEWOBh3FClHMmWLsgkXdMP81Sm0y7CKO5pCrINHWVcTFu9oMQo9hEse92fAq17W8R0KDtCu5u4TfkUk0J4fr2PTdVnmNZZra5gDbCSeY5RK9TnVccD8udNl3RAmttiMgnbq75bfhMqu1A3y1i7vhGW97SOWI1DQrMTT8bKIdtbN0NZkhxyPJ787MofOZtTG3nXhe8+Xoq8ay1yq6pMn5wqXzFPpIWBbEYZ1JxAPRB1fhfAylsTpZSRuth70er9yJUfZQX4RKGl2pP50Agr/Tl
 aiLaKV/9
 KbD/a86jwqrC5v/es9lj+n/uArYOWeocV8zQ471o/ldHLScirNZ/VXn0oL2n/911yDQ+Uwk+cjK0anx8R8ddgfi6iRHE3fyuDoSxec0gVH71QTpGZJzl+JS6Wa/oCuNNSM96CY87hz8lYdwv8uXClS2N/ztqW+x8oKXGvqDCnqCuNvNDCnjpL8tfAarpIqUtXGAOtjFetqVVBPOdWhX5y1qXccwNVbrcFjmHE
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


