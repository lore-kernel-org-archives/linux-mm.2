Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77E7CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C6D8E0011; Thu, 25 Sep 2025 09:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECFB8E0001; Thu, 25 Sep 2025 09:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD4B8E0011; Thu, 25 Sep 2025 09:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B99D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:19:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDD84116F09
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:19:05 +0000 (UTC)
X-FDA: 83927828250.24.BB08480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 516BC18000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:19:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sYD5NkY/";
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsF5GOob/YSyhfaLR09/3AbntwoC/IeWxTkKcL2tHo8=;
	b=I9LqQ1h9E04wKWsT02jRK8dU9r0chvn2kE8PjMv1FvwS5Q3X2mzcTYTkdnftyXjCHOgKb6
	aK744rs6eIMWmr6a5wNCujb/Q4OStPeLW91nSK0FjMvVs0bhdvl9ffNcXab/iQxWFk5HTh
	UaX6SEgBR2hBYOV5MYs4iMJPCC5gUDc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sYD5NkY/";
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806344; a=rsa-sha256;
	cv=none;
	b=KqsdErMEOZJng2y+ppP94uMiXYICRpYclT0jW/r2Dxwj3wg2pnEAyFqy783FjNOsGmRTT3
	MJgvMnsOp1AAc/yeBh8DzfKTS2aKh7SXfFgC5gtQRe9rjO3fpGCkdao7DGFX+AIuabUlnY
	THzM9LkgM/BcQ7xWgG1ShL8taXqajk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACE8560586;
	Thu, 25 Sep 2025 13:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D723FC4CEF0;
	Thu, 25 Sep 2025 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806343;
	bh=XSq9qJYMvX5x9A0SGQeu7EMmnMC35VY7+EoC77mNcp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYD5NkY/gt6PJ9290ed0uQCf1pREgS8pIpgHC8i+dKrn31Vnb/TT+6MTBrwxDYuDe
	 N+OmD7Vbe7zFg2ltYJPJHLB7n6ZRqSFnIlER9Pduq8ZdF924/6Gm9GYCiuEBoZmLTA
	 BdyaUZ5sLxNEbSvDiuPsuIu6PK3tpo615K0i2bgIUHcAYTKZ9+QiXnl0x/ly2j2C4f
	 iJwp+JVovB9uxnZalgMBG8t3Y86tYogcTQ4gg1ERwW1S8mGJIhYBNmnkGDfFII5IOE
	 RSK2LjQxW1bymbGPb/UjVBjq7Qizrl0JKsnPhtMe1ys0+dXLDRTFIFAfdc8tQE4KEI
	 iy5XvSaeafdNg==
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
Subject: [PATCH v3 06/10] vfio: Export vfio device get and put registration helpers
Date: Thu, 25 Sep 2025 16:14:34 +0300
Message-ID: <4b6d97b645d7cfeee1f7435251ac87ec37edd681.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 516BC18000A
X-Stat-Signature: g8c5z5oci7hk57twz3fnu4srcn1r54fp
X-HE-Tag: 1758806344-282800
X-HE-Meta: U2FsdGVkX1+W2rBBCJq7DUqmtHg6Iw415i7rcAMmBFBquJhIBniE60XAUq+UKa7LvbubV+WD2/zvQEhGFtrXxH0y3uMCImwRTUJ8LRAEFce/cljqQmWsI1d1/SnohmYFVc2sZiZ+PgEbAuvm3m57xaQDhWd9/u6rnGlcRM3jNxQfWSX7I90CmsGFcBUKsaeROLFQ7wRoiXKr+3LOK/UG3svnvsR3f/Vu1OR8/kL5d5Oz643n1tBhHX12m62qTqmeYjm31LHrKb0mCN2EC7KL0R/lh9/K1aoOBH2Zz0gcgIJyrZL5D4pDOFPnyP0NBeDTUjdsDBEl7TOjbPdSpbB4tRvHj5QFPQGXFSIpU6LEpL9ZpfXr7vKlGrCXsIxGdziEtySuWwSttfNhCeMhPiNE8bz2NKJKajZGurvwLkbgpLy5qidLKaI+mQIFWlEYqGxmBP3IhAFO5oJI8ovj2/9eQf7BdpUoeQLrJDeIV6rNT3rP764WRCngiU0S70+e+4E824YKPl7Z2JKYAhUKzuTSBkAGJjRhAOC6FnMR1l0no8CVgAJtKhELRBohhN3E+eX8jV+tq11MdgpDwcB3OKZv/ZOgb4cW5dZmIix+Q/Y6YH94rdCcGkqungj3FAL/NGzhe35e+6Mvt1tW6LYZkkxELj8bhmTLfHwudZftTNi7+YmiR2Jo6FlrOQpQz2Q9lWs4VyFN//ka0JCO5Aj3WG5ETCGPW5nE3/Mn9QJkXnadVyEr9KwbyE8XfYsEZerywpSvLDjJ9mk5innUrlkd8qInEoglj+ExdGINTp+iUUE8CGEmrLhrirfrqKq38Nd8+Vd+uDIRDd2HbHTX9h1umE5UO5GFeM2GWddao0ggtnqSBsXG6FljqY7Yjdj6vRchAu4ehOg4z0iw0wgtlpcsH6IWJhmrJpFVbURVzd/frD5eE6ccjnpu6Uz9BTTlkjbizTBxvz5ZEBzOeYp0fEQlX2K
 83TvDfd1
 Wbxa6HVzx5ipz0vBUq/Qq62y48Qxu5NnnJyRrLe/u+mWYjeMpJcip3SLTd1ilbavtLU4C9MbniVtBOJXrDEj1CZEcJF3IRZC3JEb3Tj8aRHfjetzywwPGr8bD2UqJg2KHim2HcHshHX0V+dckGMP7+pmiGqVZ8UzNImNPPC3gFd9ebCvs5LhqLOAGhOlffd3aQ4xdQG/npn/7c2UxEFeb/vLbt3G3JIHkvZh2ZCGF8oEYKLUBXeZmiARRKx7YbhWBnkPpFop9unAPgnN1BhizRWF1KMTxrEDX9lTR
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


