Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD56CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D611E94000A; Thu, 11 Sep 2025 07:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1198940008; Thu, 11 Sep 2025 07:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1ED94000A; Thu, 11 Sep 2025 07:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A70D8940008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69FE5B98DE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:23 +0000 (UTC)
X-FDA: 83876761206.22.BC3384C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B19388000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FcCIpgx1;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsF5GOob/YSyhfaLR09/3AbntwoC/IeWxTkKcL2tHo8=;
	b=HewsQ6U4rkbLr296pVHVNGNHMvHUyk70Tmp9+qhRKIjpLtP7IXy1oLgiNWxJAo93pvjAg6
	u1VmI24DMCupFwPSQF0hVqFyqNXCRrd7oHzNxz6kdfWrlVqb3MkVkvncraiewt6rgarwCM
	/Cwq32xx5HqZjYqymZu7sNgDKvtxbNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590461; a=rsa-sha256;
	cv=none;
	b=wu3ayeG51cLvgUooYkN/td0xMaITinu2qNcmNA1x811b0FF6c7ah84z/8IofrljCn1GpNg
	vzz4jvJXJZhOjscU5MFA4KTqtKAuZzHX/uyzL2/+wWErSZjS3Z662o3rWr5mbJT8I6Yns8
	4iowD8F61oXVE1FQ7O40JHN95Yk4RAk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FcCIpgx1;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D02A40295;
	Thu, 11 Sep 2025 11:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDADC4CEF1;
	Thu, 11 Sep 2025 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590460;
	bh=XSq9qJYMvX5x9A0SGQeu7EMmnMC35VY7+EoC77mNcp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcCIpgx1TGJzgCnTTyX04qdN3KJuBsYXSa7nx1A97dM6JDTKSa7vSOTcrlywPw/RK
	 j6Q2+da3LkTc0JLLFN7RXuuddjf/pO748HsIAGrYtGTaSWwXDUfkuMFkUpEC1GyoUE
	 KAzfYSvAugjo33qgsLYU+olcxZ2CC/wK2vhXE100SDMKeY3fuP4/DIf4p7Sfenvrsf
	 S1zK5DHFSU9rAKdaQmrsguSZa9YX1MSt5vEm3aekow7rKQYhZisWrtcyh2/S3QcXE2
	 EI/UNKaITwMMvqy4rQTsUooBHxHVPZCCm9NogXe3bIjrzIz42RCjLe9etIoffJodGs
	 sWAeOerEN0Jmg==
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
Subject: [PATCH v2 06/10] vfio: Export vfio device get and put registration helpers
Date: Thu, 11 Sep 2025 14:33:10 +0300
Message-ID: <7b1739e21959ccc56c86658ea3516bd0d989ab86.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B19388000B
X-Stat-Signature: tcru9uzbxhr3i5anmw75xa58f9o6t73x
X-Rspam-User: 
X-HE-Tag: 1757590461-993313
X-HE-Meta: U2FsdGVkX1+f4JsxwrUOd6kpXQz43B/Amiwa3EVYpcKtnYZnuLYU340aDZkmEpBAKXIVTxwu7rnMk+sheoql8yiiqaEXFpwsKkKHWv4N2NrYtOlXjYyRu/48DDOBF3PNFfPQkAAsSJ1c+DsiODO1oc+WoLubtwmkZQO4I5389S/eVjjECydpPSIHAxK9kVjFt4NMYLVrcP0w3mySiaOOnhLnPaE/ijBr+SqZX21Ba8mxE/UACHPgExNj4fPYMStMOd8S/pGMdLaJSB3WCAhvJeGXnPM+6+1WBlrxOf1RXxIe7A34pW7mqNWPfLLNX84b+uhx8n03aZy1WcpkecrklpWD82bnQc+YI7t1WFve3td4QroDP5moWiqkhyVl6SY30FznQtUNz2UupUQCAZcNtc3Q2THPPQacVITtMS1sOxDM8HKcIevUh8mf5c8k+E1wRL3c45xky6Lnnjr17ss/Sfe2ARFXoINRERg/x7/0qfFxBckFOHu5AU8gX/DLZ7uFFm+28RtT5NgLSml8sJroGHnssvSXyNgRkfV7b30xdLnqIdBsXmvgXRuoaWfGBOY4VhSzuIdaASwtAS28KOdrTgVQ2m/lcr15IT/eEKwGDyORj7GYYCWMfItlAIuJtPqwYQjvKWo4sNmXhxVkU3dKD7wpYr81JTDFGUorXhW9YooHBUsSmMs7ryBTSN/5/BKw8lFH+3FdjmdTSaFMNXU+yeNO6YVuRC/fwmd/Xu0nye/TcdJMwGzvVDAHR3igwIlrwkvIUV7QRKa7YN5Wk86oFrAIZOcrII3ljbUW8L1IzBF5R+7u0hMUZutr/Q6m5G2r3sPU6O3CbCXJhNq1qBNpkej7VjrNTAelGxwVy3E/j+AMe8OdFqUh5Y3Rm86nmZPDTUXOxNz+JrZ8Dk416/YEIbu5hCxnR3cendUBMOjUCcQV8GipVUHuo9tObGgw9T1JkfTG0uqBiABQTkejWBn
 Kjb3fKXK
 s/zOySA14zaSBKxrOxzFyW82BZVmg34iWDmMIAKztYc7wEpNlO2CciTD9bUpKXjjGLVwLDZ3jtyGQey0/ULosW8NerrslG3nZKLEJ7DdWVbZrOJq7jHavoBCvg7HLUnWuyXTOTxMQ3Vo8yXirr0ESiMYzEg7ZbGspot9XqlNiyfLjMonVpT1UezCDdY9UankNa0QRWFy042WiQnmJgJdFflpjtEzJtpWlvrB1CsiAJqGd3L6s8imQbjlBTssYm7EQlRKUhKsbhB0ICCykxylDzvVfSSdj8LkydoWH
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
index 5046cae052224..2f0dcec67ffe3 100644
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
index eb563f538dee5..217ba4ef17522 100644
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


