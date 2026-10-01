Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B905CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C40F6B0092; Thu,  1 Oct 2026 19:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874F96B0093; Thu,  1 Oct 2026 19:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C456B0095; Thu,  1 Oct 2026 19:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4C46B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1C5DA05B0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:28 +0000 (UTC)
X-FDA: 85275583176.11.1EA31B4
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB61AC0009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GRnb20Jj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3gea-agUKCKYVXGGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3gea-agUKCKYVXGGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbwONChgIm9toIIBcyyDgkpchsmR3qTw1sfEfErlET8=;
	b=j0JT6pUwRI29ApJYinNTYFX3CP45MrWfd1R2m2p7KbAbbai51Xx4bwakWNbC9k3lWah268
	rb1EKmtAyrGvEttK2u7bxkflFphcKSb9cxfRPCISVFFfqP9RUCZx+8zIlZ5kTopdsy/X2p
	7LBgfJxnF9RlEmdV/WlZdcLOzCLB1W4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GRnb20Jj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3gea-agUKCKYVXGGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3gea-agUKCKYVXGGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895746;
	b=ovG+1GefPd48vh4Yac2i6Ka6MMjGgXI7GYBTEMo4olVJ/cl8RfJt2+OiiasULbaFfpEU+6
	QkZpcdWNpaiN0UWr5u8UXhSwlCLxqGaaXI2kYblUztlPWLIke/rlrQmy0+vMhlgtEP6/t5
	SHVYWUIO4lIBKRpgLH+1AhgBGrZY6+o=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc73895c7d5so8478410a12.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895746; x=1791500546; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EbwONChgIm9toIIBcyyDgkpchsmR3qTw1sfEfErlET8=;
        b=GRnb20Jj8a3nO9OFiWCrIgyXvQBOV9Y+eelAV73sw8tB2ke9D39H51CpBpuBicEfIE
         Uyy33tv+QBXtxhF6GacsvHhInt1IZUxpNqsBus1t4VcuBaWtyOeioiTY6HTGcXS23i5j
         IgR/0wcL+XY+rzOJK1kK+e9cO6mst8WYD0dMJetuc2Bij1Mgw9SAFGTIlHN2T/k8Ccqc
         y5ehcOGvPKZLyzJIodVvYMnv6OJW3P/LK2ToDzUS7NCIjdwuskMqto/PgivsUBWA0kXg
         Jl6zJNEEhbF8dqsYAUKljDrfB/1k1Rcgb8cV5BYyK09L6fTVfYWGI9l/5ni6USs1WvU/
         zuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895746; x=1791500546;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EbwONChgIm9toIIBcyyDgkpchsmR3qTw1sfEfErlET8=;
        b=xeDwhhmRP1Le6EblFf/GeFzv1ByBrWkOq5ht8hfuXR6kJi4xv4acmvRDeA8ZDWNYq3
         PxdaOnoJ06LUHj/ypkGDAi4XjoZ+1Efk368JR25CI45uL/jgbaNtLmZg5f07640HLqYZ
         s4OAqfLhQ6Pg05f6HME/glYbafAcBCfbhV5oqC4AwSTbvlYhd//2aIvYxrCqSaCh5Wgv
         gUPxhizZf3iEVgzuVmfkCZYPrdIAGGVipGa5uz7IMclZyChRmm79emEVcU96EN0di4y2
         T71X59rOJBeGrR/Z05UZDOZpOmAJvgx5Tgl0ib+LutPSAHU0UBjgVujBVw8gweBzZ8qQ
         ZxNw==
X-Forwarded-Encrypted: i=1; AKwUvBzpnt8SASsuXx4ihd4suaqPakK+FwX/IxUmUGScbissRQL9cmkOtGYRMusmiDYyVJaldFtO3su/VA==@kvack.org
X-Gm-Message-State: AFuF++lzNn9JSgVDOwgH76siK0Ghq/GqE8B1MSsDidAhJIisXOxKjFuJ
	DlspxlKx6J1ddN8b3IkHfz7hZ7bMvDaMZXmkeIMPzow6nLlBhVcq0bLBgNxMw/V29U3SglDCR03
	tZA==
X-Received: from pgbcr6.prod.google.com ([2002:a05:6a02:4106:b0:cc7:b09a:fe3a])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5491:b0:3de:140a:3e31
 with SMTP id adf61e73a8af0-3e0bd228817mr867758637.49.1790895745421; Thu, 01
 Oct 2026 16:02:25 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:15 +0000
In-Reply-To: <20261001230219.818128-1-praan@google.com>
Mime-Version: 1.0
References: <20261001230219.818128-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-2-praan@google.com>
Subject: [RFC PATCH 1/5] iommu: Add reclaim_list xarray to struct iommu_domain
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: md43nn834dt3ckgeab3wdajw85j1txax
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB61AC0009
X-HE-Tag: 1790895746-688286
X-HE-Meta: U2FsdGVkX19IziqMERfJWj5uiRsTQ2gU5TWjZmXv19bqBkzcNGmi2ZCuLj8mQ9DENLpnZngeakwLLVFFLO3yXa2lt/NQWP8ee5XI7/d8GNCp6FzGmrg/LvZDPpwt0XhHPADEez/gaQLnz49VzOzmTvoheSsDJ7DX8kncmFA5d4Eiwrx8y8TuY89TwUyDrWm3viqsZ2Q0N7d7dLsH0htQKvrBSTVMhrbXbqWe0NNihPDk9c7qPnbJvNJU5cqSqQ1/YSPO2ke/sBxZ7GCpZy3sY9+GqjzgTUc4T1jBRPfH9eq96205ZsSmAkomIIv8zaCsG1sbfjtzQziNMN9h2SUOOBidEbf2qee+WXoBqx68Ve/UvlKKyyjjxwVrCLypCz1Anwbmt0Dgvl93JeF0bWua57aqyZrPk8ag3kN4+D1kwWiRd9Sjg5+0tH8uPtfQQAQ5YXUsby2xBCrRqgzVygGBJqQlBpKrbNvvx5OLiMaPXdEt+mjZhcbxr0+C3Eh6jIdg5mPgTBJgBEF5OGC8Iku91v2E2zdCJChIteEvL+KYxIIUAWgpdQMsa9Z09xDA5IvWD4AXFeJFUrcufi5cfJ3/yjxID63o8ryq+ycKrwq2Xwl7DvfSnA1MyTUzITy4QeAufCfrMehaSB5AVdTiosmwFdOMCn+EJkgBZMcs4r/1YnUdYM5iF2ZnHXjeSZ+8aP4NLJ0jqIvlQ6Lj1ns3DjMvpZRYB2szKO3O36aD5iCga+ZO6jNBEesrV04nnhCwH06fhXE6V5A605zhJjpPgyrquH1HolDm8XX4dvFdh7sHvdySvLtYyZnBH7LBeBHgEFIl0d8/f3sPjskniq64mWwlE7mccfPVkDLu6qE0OiEJQGkdjp/zkfeu0bOMt1hWhfY2Ahyfo5pyp5UFoygK3cVJmLc5mD7NlBUTClLsrOlBV1moXGbnC5Tu1aV8xvjn1ivmDPQ3On2uDNI9AFmjeOw
 k7K/SZde
 wBwOEQesLX9jtZ46fZFeAiMp26Z+xO73YmrWMjmn1uIHKz77ap40TKOjoM6WV2lY0zGj7GSH92rRip/88tQ4+ra+gMlMG1kJmzGd0YA5Yjacyf56dxf4CU3rGVZnvSZuhLtdklmQnDM1DuKoxz1YjRPGN0sxJ18OOI8VTtDtxjhrvMPwtu6f8R5OmDstF8BHec4pmPOrMSaKmLAChftREEQZ4PzR8m4W0vpzjEYTIOJvqfBn03k1SgHNJ7gpm8uQPKhewaRrhhUywdzqdWH0EzPCeiXTmE2LjLFQywJWrXIjxVWs+7Gy1Wv1h2hPH83lFFTUhMkfUhtIB59JCRr33kbnHsJcAf9SvXFnPqASLwW2wDx/sIqOALxPrrxMkayUVg6geHbiqL4V0CgW09n45Sj/vyKOiWhpRPuQydWn5m03ESKOV3onndFDF45JMPOxDsZu5GMauk28/qYokWDy2/MeR5ugGhCa0/FKb7Onb8O6rsgzwOM5aNrqc2WGsYcko2EeM+H5WtYa/PNaSfXGSot16/hjsPH3S7DVzdVVC3tMhYwnyYAiq4MwPoAcruI54XgPrLBVOLvxf2toU+krOWuZft1bu9yMoqMCyXOPoGQOJJqhdO79yg1JrXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce struct xarray reclaim_list to struct iommu_domain. This will
serve as the O(1) storage where the fast path stores empty directories by
their associated IOVA. IOVA is required by the shrinker to perform a
top-down tree walk to safely locate and prune the parent pointer. While
xa_store requires a localized spinlock, this path is only triggered when
a directory reaches a completely empty state, keeping the vast majority
of mapping operations lock-free.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cd1bca7ede9a..5d814854d825 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2074,6 +2074,7 @@ static void iommu_domain_init(struct iommu_domain *domain, unsigned int type,
 	domain->owner = ops;
 	if (!domain->ops)
 		domain->ops = ops->default_domain_ops;
+	xa_init(&domain->reclaim_list);
 }
 
 static struct iommu_domain *
@@ -2126,6 +2127,7 @@ EXPORT_SYMBOL_GPL(iommu_paging_domain_alloc_flags);
 
 void iommu_domain_free(struct iommu_domain *domain)
 {
+	xa_destroy(&domain->reclaim_list);
 	switch (domain->cookie_type) {
 	case IOMMU_COOKIE_DMA_IOVA:
 		iommu_put_dma_cookie(domain);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ac43b8b93f14..b9611631ea80 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/iova_bitmap.h>
+#include <linux/xarray.h>
 #include <uapi/linux/iommufd.h>
 
 #define IOMMU_READ	(1 << 0)
@@ -249,6 +250,8 @@ struct iommu_domain {
 			struct list_head next;
 		};
 	};
+
+	struct xarray reclaim_list;
 };
 
 static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


