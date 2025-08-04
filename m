Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EDFC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38EE6B00CD; Mon,  4 Aug 2025 09:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2896B00CE; Mon,  4 Aug 2025 09:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1A96B00CF; Mon,  4 Aug 2025 09:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A096B00CD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27DD4140327
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:26 +0000 (UTC)
X-FDA: 83739086172.22.A2417A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B60080017
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPXz+dDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MO6eLjL42aYFudp7WEupsk/zOS7JRiEaRHYrsoPtlwA=;
	b=5FwF7l7nncPEHhzVx6CVnvb2OlAGqOrf2OADC938QO5Xvn1wTjOxPfHjivRpYAPAk5BQlx
	seoYJgJZqPpFxY/bJ/6a+ObvTk8BxsxBbFnbtasxcUL/phSIPMKsJ13Y2ArmHKoVjXweL3
	7lcwZMATer7g1aoSKJv4Ioqx6JviPFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312484; a=rsa-sha256;
	cv=none;
	b=V3mlRi4hdH9FzmK3v9UHnxdhGBnsUvC1982ul443gz79bPBDtAmz7RWpj0f6/UtdtImnVW
	Nr3AKWjZ+8nSsUI77vEwJUf8zXEtWG5lmbJNW6UORnV5DsPraVfcaIFOKkW4n34mhqkO0k
	ThnJT/h4pLjb9qCC97kBTP+/hHlQ1Z8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPXz+dDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3389945B8C;
	Mon,  4 Aug 2025 13:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999CDC4CEF0;
	Mon,  4 Aug 2025 13:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312483;
	bh=SvWpwCR2Wh2zkNow/WohcCYMP4E/fUfFI3S/vqkvZcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPXz+dDMAvSwAXGZh2jpBdnIGjP5/4P1Bi7fU4KjhDdrrUhmuS+1iwLBL5/Ch7nk2
	 yoSNA9Nqk0pwb6Qm8dTt9S7pGFBR7xRykO/XC8Uiyvhy+ynoAVH44BcG/ZX1xrgjRr
	 f7S5ch72l2xHSj/6lT+whhxF9B5bG6KmjYJAO73Fmp1/WoQ2Hb4aL4bB9D78/irFGp
	 JphMh1g0mUZplgv7y2OWfetRViBhbKCFDEAjIP7BKLkCY6NDnd1IpcspTkDAVZgS2T
	 un44QqqeeEqeR3lnRp4qaCLGlduD6sBnDTc2o9YBKANnMf+gPZLqYcG7UViKXRPDgK
	 quBdiV2/cmkoA==
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
Subject: [PATCH v1 07/10] vfio: Export vfio device get and put registration helpers
Date: Mon,  4 Aug 2025 16:00:42 +0300
Message-ID: <c511efff1d080b1ec97fcb2b095571a89e8d8996.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ezsg81rfjkipjjiy8fftbjpwufhiu1w4
X-Rspamd-Queue-Id: 1B60080017
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754312483-964806
X-HE-Meta: U2FsdGVkX1+VXd+7Ume5vrPa9C9EjIri0yNhAqPn72NCOoPeymweIlpMYNKKi2JGBUAxyb8jXZIxDFgngtvYYQQzXQjrXjSfTGEb6eG+Ed2PxpYmIdkdiitrTfgTuH/yFm23Xtm96GvdQsutu8aRxwI33+5hZkO5oNNb9hggfJ31Q0gNpOG1o9/tg7sT/Hdpf0GxqMTLYe+WD0Rqn9GfHXwFKc5/iu/KU7X1bJhzXTas516xFzsK6H96Niljfjy7a0YFa3Rk4YCK2LMxS/SQrAV5Xyp4aF9o/OQnc9cu0+E6v5prbG38MWvaxHZGE0JcE0kPlc6r+RhnvRuAeC+UOPOy6EJAHzHZ/fY72WeOB3t0DTdec2I58qdnFl78G58E1VAWftW6+QLlhmSGV2E7gnkuedwRdxTh9DNuKwWbUsTdiOGKaj9YhCKQv5MltGeMJgUT8VwUZpyodqCTs2qzNy5Ov9wGieD4bz/6cKqef/5ZosmrXLUF6FWktwwZJFvX8/ezCf8sXJqinWN8YtKiKw7n2l94PzOfhYfax4SlGExA2kfVWOZSYyPXOaGeebOPsN+VRTxxsT9KO3W3LvD1eN1dkBam/Oy3Omd8rb9zsseed9zMf3/Sk0GzACcead4XWOaQhp+w1uFqP6yb3+KGEz9q+Xzb+UT4lx8NqkqfJr1DQFqkY5kXltZqi6pOjaT499/ToHqXgPO2Ugy8EY7prg3OWi8+t96r7eAFUl5MY/KOgUOHYdSwvuafztmqYE38ZOQyM9RGKJzrRyQCPLlfjtPQDyUP132nKehmv3h5q0uXwJqJhhyJD5yHCWi5+PR3GMzJAVhN9GLUOH4ii11GI3p9DJyB0FEyjq+WmzktV0z4Xh/PXWxclXGvnpRwrqFOO2BnBVZBIUeD5EiIFNHXEOL60lgK4vaNFCHbQGlviUdsM4VqcfzH9EvMjd6Nj1JXkKpg8qoEJgUgf+8VsT+
 M/eeC96i
 hyXJHRG6OqjgiVQ+8RA9EbOk4L9TLSubRs+RLvCb1PaRguPCJTlfr3UYAJISIG9hUfIAwedeAxBsJmDTCrFR5b1rWjSgvX53R1FMoj0rc5pFlXXpocmgKyNi26wABCBAFmqs+rzcXVkM+s7STjSMgVYFiy8aVSeyKhTgVZ/rwc5Zoi5Bnr1ykNpIg8yJABDlmOZLh6akccIr2DJpApdScoKU6zUW3Xs3rrz0hYrnpRr8osot4DJjLYB/8tsBvTd6vqjgi3lsPvkpMc8uKtlgEQRnNSB0aJB0IDks5
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
index 1fd261efc582d..620a3ee5d04db 100644
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
index 707b00772ce1f..ba65bbdffd0b2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -293,6 +293,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.50.1


