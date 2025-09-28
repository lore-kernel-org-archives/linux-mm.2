Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA5BCCA468
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C38C8E0012; Sun, 28 Sep 2025 10:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AE08E0001; Sun, 28 Sep 2025 10:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D83F8E0012; Sun, 28 Sep 2025 10:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED428E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB0F01154D7
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:39 +0000 (UTC)
X-FDA: 83938947918.23.8109041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 790F6A0005
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q1BG/dW3";
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tA+pURzqrNEZhUDHHPxAYRzq93MCO5mLdmdOPxsOTvo=;
	b=QV1EgGZEiJchJ0AtFCxQzcp4Ui+wldQDyZ5WOQSbbN8X8ftsGRfB6B0DvgR1f4ETD/zIWW
	Q6s6G9J3f3mDgZvUQbWofahEkcdjV378AGT5mh5ydAwPEKdPSKW8t17SQJrmxrrTziSMJe
	yEGBIZbJ4p6FUATyKDhaKJ/4UNDRI1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071098; a=rsa-sha256;
	cv=none;
	b=JWi0OVnUz/alIaeEM3z08XAkqr15yLN2kq49Mn6kqgeT/bBlwfS1u/m9AfcDqNXQzyQdxl
	UmFZX6v6n8va/QKoMImpkuhfYmQJc8xqNZN/pGMuF0O0N9cChvW/7x31XYVJ9X144Iu5S9
	5BbfUHcGeXhKp2/tyEzG+YCUsM2bgbw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q1BG/dW3";
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E64B86218A;
	Sun, 28 Sep 2025 14:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118CEC4CEF0;
	Sun, 28 Sep 2025 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071097;
	bh=isdw6kZ8FFhWQVC3bDpjETrpal4zAOBPlSaTyAj5wzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1BG/dW3MMEpKiBoxWpHfJqeMARlzNFZH44gJGE3WyaIqYUkpbkLrHOlNjgBk8l3B
	 K79RMwWDzKY9rwjxPRcXy+IWOatSDlm0WNCw9SnR+YljlPfMOgczoa5nlI7oUgi7Sj
	 UQAoXR3lLhNAd0YivYU3cm4zqXVUpMn2Y5wPoKBwqj8Pvyo9MmIssqLjzYZbl2Wzp4
	 DMImFauKBxnBz2yeyVgCUoUHvRQWeQqZ5Mfg1IpzBlT0lABuFhG+ttMofLklUfjaoB
	 mOqn1C7RPLvoON1fae2FqTHSG3ZYzdIqtmvqYciR2Ym3gUFFXWQQfLhFTObif1nKU/
	 kgGPoeD+32EDg==
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
Subject: [PATCH v4 06/10] vfio: Export vfio device get and put registration helpers
Date: Sun, 28 Sep 2025 17:50:16 +0300
Message-ID: <40c2a8507c5314f5008e07f4632a7dce3faf69e4.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 790F6A0005
X-Stat-Signature: jdzt57tp6te63oj5zq61yb7xfuo4z17g
X-Rspam-User: 
X-HE-Tag: 1759071098-238842
X-HE-Meta: U2FsdGVkX18yHnc7OKeV7otpURlGXPOZlvo10X8pzXLTJBt+GJb00dHQrE4D4nKBe+9uBtfcUTkugWb1/d5E1TN54/CoxWw9FzUJIOtPCeBQ4R+xrVFVzWrNoyTzDaqXc7QeCap5srKAqBZmk8bjn3oa/s2QCmn+Nt9av4c7GD0EZ+8KpU7CQGtOJ3K6fv2xHsFbhPzoQuZEK/Pg8D1hPDRaQGYmQZJVLYOOR5hl0H4hqd7K1FHmqU2yO4bPsVQ7r+j97KxTWEDfIqHgBJIgn5M0fnka3nLhLb+Cc7df2vpkYxcXCIT0bFO7oW8rB7ytN66Enf5UZmemm9Csk+x4w4sRcwej2Xs+7mitvVYzkImF626e3bOzeQ9Kfg+vHf0MfXmoWnRWI4p3yvdfWbPUmDhaCm+WuvwrYyxxtwX4ikmXlfhhGomtra9Aln3IHbTXK3zOYNaJQBYtEWE4e3k1SFhsCCbOiI2Zod1yLEWlCbKxbIjHLYM6GzAXzxiJFWGvCf7hAHLVHh6xTzTpuf/zr49ZFG6yn3yt4x+keiFdo+ikvEervZpNuqXT7E0/5XMuKfmPtFruv34P3aV5ry3R1jBC4DpPLXrMzdMqe+dMO2POxz2FZ3H5zJOZgktRulPTRjI0pM68Wf5Mlm9hHJQW3ZOVgo7jKZuFNIZc+QbP2cgjQBRQKW0YDm7U2qUrOmpQdF6sb4cB5pKWOZVBn+Nor0wEFKsT9CGPW4Qzmn2OE8M9ctc9NnyDvA0CaptT9LHMu0DP2cIyFDAWSw8QP59vOPmEEGdsdw6+sCFLL69RHukd2ux4bWhT2UyQKi0TqOO2SLhu6OjNm2Cd4PENTxkMfPpUzr2G/ByCCTSaQocM0fVRVmgh9rAunwUGhkrQbtpZ1SEAZBF/IXesBlJWJcBorwGxTawVQBtdbjSs8nmLZTFxIMWqdkikOluU5rrrZ+fOSdZfxvLl4rB5UWdz5jA
 Pb/afXcq
 HU5x7cEiG10OQOMdTnScrgNIw5R3H2c5Mq7mZgg1qAAarmAk17G4/I05/Xikf3xAvgeTMxfCTCR3C9BP5CD5yjCIDsd/Pk2/DcD0gHUBIng5D9DfqZw9U2F5KiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5046cae05222..2f0dcec67ffe 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -171,11 +171,13 @@ void vfio_device_put_registration(struct vfio_device *device)
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put_registration);
 
 bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
+EXPORT_SYMBOL_GPL(vfio_device_try_get_registration);
 
 /*
  * VFIO driver API
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee..217ba4ef1752 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -297,6 +297,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.51.0


