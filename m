Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3492BCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880AF8E0010; Tue, 11 Nov 2025 04:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830CE8E0002; Tue, 11 Nov 2025 04:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746DF8E0010; Tue, 11 Nov 2025 04:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 656278E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CACE1604D4
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:31 +0000 (UTC)
X-FDA: 84097876422.08.E278D16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7134B100003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSGkFCpi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855109; a=rsa-sha256;
	cv=none;
	b=SgYhx1w5SN21jVwXNKPUTn8FOZSuEsNnqfKjY/bSFAzafPgMgr8egZ54ArFaqIUg9wBZKL
	GgpPpFkRVMv+bHbA4erBZ/WfHBxlvRB449874dJua2sPM28J7oxTEAz6q5HctCKF5fpQRm
	8+HzzPSQsIpl7m31P3hdNW4ZlXi/iFk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSGkFCpi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WInXgELx+FTcB6ExpPv/f9NvbmYZnjNwRsqqPwtH2eY=;
	b=21u8aURDDo8JWq0eIuMhDEqZxjVGMx+IyEwkgLXXpPThYbZ2PPPlgdV5qrB1dS12ulfrSi
	r+RMGt7bHv/0k7i/ENCkQG7sp9qwwRMxk7IqnOvK0dgmqpz0QT4UEk88YrjL6JGjMl1jKq
	FEEUuV9fJMbbItC+D3is41FAlhhqVuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F4CF445FF;
	Tue, 11 Nov 2025 09:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7531C116D0;
	Tue, 11 Nov 2025 09:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855108;
	bh=lS6T58DHt9wPHQS8Kvm1FHiA6t+nNSAifcX8vWpYDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSGkFCpicG96X7vFHZ5HW4Mj4KH+4wNi8vv62J2wwznZbavZISMCBFYMiLkxE8Qog
	 p5+D5op+BLuvmHVeA5srt6cx6kBCmCWG5wPGnbpF+s+OAeWTWHcdKqhqXmOnXupF/Z
	 zZkWyEtZ4m78eIBLUOCYHfT45soSCLSjLPWME7VcYi2qrCugpb+mJOGRhMFRhZSVUP
	 nLGy6c7uz2y4sbDJjZf1D6fVh5t0FVp2YUBrnBHxyQkR4azdQUrQet3SSYzjJhhsfQ
	 lWELuAq0eowmi5gpESSKJX7udUguoqXdF+AkhwPUFixtr5vAQP6y0hVSMLTfElscDl
	 SLLFX+cN0GU4A==
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
Subject: [PATCH v8 08/11] vfio/pci: Share the core device pointer while invoking feature functions
Date: Tue, 11 Nov 2025 11:57:50 +0200
Message-ID: <20251111-dmabuf-vfio-v8-8-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7134B100003
X-Stat-Signature: 4mxbh44cqbn6zgizbyo6qc5rzh6tr96d
X-Rspam-User: 
X-HE-Tag: 1762855109-720012
X-HE-Meta: U2FsdGVkX18PG8gbDbw9+TpKLohghFvVWVQCOoznAYtaUaGkpdLB65yZbBDL8Q5JO4Eovc4RFIVtsptlvERLBpyz1NrOhQi3XsEANMBWQ6aalDwdUErg1KKlnUXKD8T9CPMLQuJSpFhNOGpwZk88BfFrndykCGsCTjR3hdkgrYjGZd5kfzvumi/yhVXRFOksYJvaGIMLUPaX7Zt0L83MoJ6PpCXfnCVTdUC/Nt6a+Ox7nut9MlsO1YinGRLrg9j1JjH5BH4CwrAzn3oe8pP5pFwZvuUP/yeqsJFjGBOFm6/t7z7sus2wgiVROI6Y/OXmzPafmKwKC2U1jWhKZqRZ55VIek1cJOAcKhR17wdlZA3TJoDGR2xGaKIFUxpyWUdLOFxfG6AJ7N0A8057HVNpMDKFkJUJWA9hoYn5QwHf82eQ0EpCNvHVxdWCHzw+vcJWZHhSvWA8CzCXzdCELz9ZhM9uej4yz7aE0tbWI6Av812KW67W/hWDBngJPKHaUsxs/raiMy/ggLoclN7lAqeJoYwZfe3oVQ7DCpC464jY0vRhpWJ+VuIGxo0nAKUpDps2m+0finJuj2FOGR9cGdRYGslRJxXl4sZYO1P9MFyHV+fsgo2fImE+ihIIN2cG5NlU6PSCiIEWORyRUeX91xqyndmfzX7FuclKdiMt43zJBQ0CsgSSGJEPetcNqbUGyYBFVlBQ3ekmS27nDN7d9vawgR5Fi34C/lC2Ltm4cOBCaslqZGwxlgZRP0W+LTDtV7yxlLepapip5TR7TQjmfelXTGSX7kIRLHiftLRVlqHtNPXAxtDpfiWzsRD9aOvwc8lP17JM00ev2USg9/Yy4L74g9KlydfRVpvDVYIugzenHeQIItAyVLPTbmK7IBrQB7xx/Os2ys1Y/olYP9qk2QXaQfU2SxS9/3aYa49+GkgM+CXrWWAVf5jPafL81zjg0z6KFCkFuNWjgtrbjRF/i/Y
 ObOvgz1a
 CbzEVdtcLICriw/6XetRyr8krBkuVhZ2Td/S34eA65FEa/NY9Qz2rYAW5gkczw+IFKgchOSiXcp+U/n2PfHrL3XkCtPRuYmc4TaMZikhBq4E1ePhQhh0Vg2Xv+qzJ9cHDkbOiR7m4hMDdDBV9P7isaytx3KFhoVdc3vCe98LaiXX/jLu73j4QGRxiCovAz+rB+nI3Pf7VcYRtUuofV2PDx/ThUOP0RwlKLa5FeZQ14Otps57r+Z68KpLLI105VWXXQE+caf0fh8JBJP+UxCWOiY3u2VL1zxh9bUX+p3o/iLvjfSo8S5ER77vORIIJ3VXzooQtBNrv/RE5iSzGOTI4g84Vyl7GeSMTxKvh0xhTXt7qC1pZR4Z2Yf8SPw==
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


