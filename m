Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F39EC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059746B00A1; Wed, 23 Jul 2025 09:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031346B00A2; Wed, 23 Jul 2025 09:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB06F6B00A3; Wed, 23 Jul 2025 09:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA73D6B00A1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB7255A95F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:31 +0000 (UTC)
X-FDA: 83695543302.30.30B382F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 159B3140002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORtsZg0P;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CSyLUOwakucaJ1yO2MeiumjIZyLma9ef3zSL0qUy1s=;
	b=ATYIsugD1TXSu5R7GvbYIoQfGYEJC+j50dV5owI9IqOSot+h38r8u7zUKWGfLJS86FkUq5
	dbKehz6Y8KUIYxTP3c1d5FCQRo6tJf2dUXTB/Ay8Ib2au+9ss2BAyVoI6dS0NWBAAJTkIb
	t2brSPSCjytibrWrXZ+ZmYlm0KtNRiQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORtsZg0P;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275750; a=rsa-sha256;
	cv=none;
	b=aOB1rtG/Yl9nA11iEZfj5hXlglZjGUbC/KNjCpLoRvijX40TiYMiCFf5CXzrjnWqa+tFU4
	ddcNO3Oe8gcNwD/rx+NcgvsEGNkNdwQ/RSPw/g38jvtHCogzXKXWWldrLHsT3r5jdYUQ1z
	2GkbBkFXzojurKfnTzHMxTq/RKsD5A0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 971BB601D7;
	Wed, 23 Jul 2025 13:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9858EC4CEE7;
	Wed, 23 Jul 2025 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275749;
	bh=7Kcn9ETUYUd7AsaGO4xG8HMvQRFSS/0rTVnJwHyaiSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORtsZg0Pr0EAkwLD8inVYan9Yg3EV9m8dNuCQ9Ux5gvKaOk5yZ6TjxaLF6k6sc0vG
	 YMBPpdNF8O0Ok8SDlkDBaz9S2q+nXrhcV/rnHwNZ1OHWD9ijib5veFrX3/OrVL83Ok
	 GRO1DlD2baQG8S60057KIoBaj1Kf3s06ZAIJKc93i+oCl+L1Z3prFNTNLNw8TfCAOv
	 6D1qkdw8RkO3tXPvgIdL8vnxk5O76IvcDBmcOCsncwrfQZMZqYa9y5IBKvJNrfRrnw
	 HoX26giRnsA3Fi0l93YwXsppFVJesaZamwYT9P1qdg8A8iTpLcGFykRtCddZAfq7aU
	 ss+vvycNBLTvA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 09/10] vfio/pci: Share the core device pointer while invoking feature functions
Date: Wed, 23 Jul 2025 16:00:10 +0300
Message-ID: <19f71a0f4d1a5db8c712cb4d094ccf2f10dc22c5.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 159B3140002
X-Rspamd-Server: rspam06
X-Stat-Signature: p1amtnq1jjjejc6wmbq81bi9r5pardq5
X-HE-Tag: 1753275749-68373
X-HE-Meta: U2FsdGVkX19RYVBiHikg51Gb2BewyOBfGd/g+bCcCRfsN5gEtKlBzIDZJBTMvL2+Qk7/IrG6vaVacBf5qWvO158D1neXjTRnYRa3yULtUlS2qDvFzEYNVgRz86MUKj9zBUEuvPjjZ4rQ6Kaku+TO+0I4W+Kjo6WuOk+QTwEBL8qBxswpHEUq44tTIAG6lb50CJkHIQKROVYEqtnpjrBoS3RKN+jv+T70UADytJxzqzRm1XRw9Sa1zd83a08IfaIvFFeiQ0ABkoE4GJDvZgBDOD708+ILM6N8TkG1eGmssTNUbR4IwDvpIF9MIIzuICzL2iLPKdQhKVJ6VjOOUgTL3OgwJ6WzOu8OOHJq09tUaqHZwEOtEv3mjB+o7744cMZrzPdSRf1IvZ3suuGiEvp6aJAt8mbd6DIeoYIPlUYgkC+lwoMdR0DGRJW1j/8UXT8RFQruwBzWSg0z7clx86DDor1asQslSplbRLUENkmTlcSE5uzQxUdLTp6t2TcubsRR2qMlO8OfKrTwOgu/KjugCObASRf1uK7iDLrtplp5eAZaqTJuL2Xc4WQZN6eaTzuiWwiUhmDQQoq9gdjJ31/6RFU86o36sHa4LIRLUXX8pMZE6xqH9km4pone7xVgbg/+vwXCI+RIStXwhbqiQHzY6Tc/gX8rE+H1SPZA/4rI0PXwcTkeKn/d1G4koxWm8ANHL5H786nwGZoY/NYvobFuIJmUHidL3YejamsclcQaZoPOOCU/DHTiUhyBch7/ZWrDOlo1xsRWNnCbOaSCZP3FJHiqC1JZh4cp3A2abL9JBGhdWRONbTrItN/dodl3mcTfBuRAhD9siPzn9d7PZ2HTO2RjmxKDQAstkc8n3gj6gRuoUSwqksMi6bSK4EhNjPEciNcvlNOa1yM9j1TU3hHIpgjLQ4cV/lOvyt6wznwTUlX4fECFOeUtmNnTslhgSPhheS/y5qFjll7h232kVZS
 sKeZXSTi
 5QHMpFzlLGEYPNllT0DdAdEmOHh2QHhwNYcj0HdJDH8jIJJ92dKzAY933juReWaQpK10BvDdAeqsw3POAkR9PL3ZjN1yt7oeGl+SgwBZg1sBOnhoqgUYvBpQPo9D87DS8BGZulqEc9s0dK3a9EIzJ35ehNULQY9dWq/xu8vCW9fqofmPtz2nPDuJztpdPX+pus9wwM51sJPh4czKRbAavtEsaZIky/0w2XsJwNKSdS/R7S5eQdpoN1JRodA==
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
index 1e675daab5753..5512d13bb8899 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -301,11 +301,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
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
@@ -322,12 +320,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
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
@@ -378,11 +374,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
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
@@ -1475,11 +1469,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
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
 
@@ -1506,16 +1499,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
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


