Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660DFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428686B0092; Wed,  8 Jul 2026 19:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF846B0093; Wed,  8 Jul 2026 19:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279A66B0095; Wed,  8 Jul 2026 19:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED3E16B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B9A78D284
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:00 +0000 (UTC)
X-FDA: 84967252440.06.E10D777
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB6A5180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FejxYfbJ;
	spf=pass (imf16.hostedemail.com: domain of 36eFOaggKCEIwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=36eFOaggKCEIwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkcC1WuBJfDnOUDpo4VCYaNuz/sum/AUORjsX5C4m/M=;
	b=16NDqjRGMv3qpJBlmargbc7lhVhiQpt9/9SYM3ronXlInA/mP9tNrJjGWOR9asObiFLrfu
	Gfu+0J73ZIMOB1F00OTBx7BtbdBbI3sLitOjRN3mxTwfW09cnHIk8fKX4WqHX0NS2gMjzf
	4A4OWMOH9mCgL6D/qDpgccfPJibRGuM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FejxYfbJ;
	spf=pass (imf16.hostedemail.com: domain of 36eFOaggKCEIwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=36eFOaggKCEIwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554538;
	b=5tAV1Uy+C79dI18vh0K4a2AOJN1RQG+Aiuh8IjS7So5ckS7zcJdgl4wUz08rgHRR7KUhQH
	K/qajl+5G0Qi4H711LB7wy+ZCAW54efVaXevW0hmRXUF5jjVciOu+yxaThxeVnfV/EI/qA
	0RUfjiKK4rrMomKWslW5uIPd1+OcvZ4=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c88aab7c1d4so1272401a12.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554538; x=1784159338; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lkcC1WuBJfDnOUDpo4VCYaNuz/sum/AUORjsX5C4m/M=;
        b=FejxYfbJ5rMTgvzquNK42iEct5Vi4wmtZ8cE3eL+zTGvZXWb5xcQ4+37MVSyG02U2Y
         zR01X7FeopDQ0WXWr5gaZFS3XA6CKLoghsRYFMbkwJJr90MWB6nfaMFRkP3zeS1MZ7XA
         4ST9QEPRBZSwkBs5v1PvGiqxfpUEx2fanEz6HH0aZuORtssmGhakXKHrZcSlul6gE4ci
         xihhufkjxMrTEXTfqOCip6hkesIE/hHQ70XyUw+EP3DZMK6ewAkPdQnklKEHgAG0FHio
         NwXGEkRgZ04KX9ITk4AD4/Q5Ql8Ybevo+7JELkzBx0xZQgMv2O50Ogu7ECuWc+2l3qoa
         blZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554538; x=1784159338;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lkcC1WuBJfDnOUDpo4VCYaNuz/sum/AUORjsX5C4m/M=;
        b=eM+FqzXgwN2NtH2L3E1FDq/47hbOFVtWll4/F2scAlZIFpT1LChpJnzCmaaFMl+HVp
         xAOdS2GxBlnoWgbBx5LT278oUPXc4gvpBWYTqTKzIkHBYlrgSuT4Y+Y3fLwHEGpGYuZt
         uYU5pSH2YE9R1Plpjw0oMd2FMzv1i0Xuuxy4sy3OOEAXE5S7bGMDcTTZcaWRhMGapbaT
         aoy/ZRipjNsQxGcLgk+xkPklW+SWPqJlAGrPqaxI/TrsQPsPdqSIDQ4F355DdB7FWHt2
         KNzhWOVQg9m/kB/eMo/ymZw04MvZq1TPUjygoOfDMd068BYMxKHt5cWiGzs1fJN07HA+
         OM5A==
X-Forwarded-Encrypted: i=1; AHgh+RpftBA8By8yd0Ld7PK4UyrA94LF4CrwRYDdo8Nlth7e31ljyRxW6vKTzMxDKBj2/8PMW3urVqBBfQ==@kvack.org
X-Gm-Message-State: AOJu0YzvPcJsuTplKq28MJnm0uQgtRHl2tRjV5zP+kR3+Ms3k9a6jbjF
	bOJ0Ac4DeQQmoauT3adpfHMcejoFXtednzGvjgJ4xlQSHGMoK6Hpq2wQKs1n+9q9kml8/0du67j
	JSEc3KnykGbyc/Q==
X-Received: from pgbe38.prod.google.com ([2002:a63:5026:0:b0:c99:aff5:7092])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e082:b0:3c0:9c19:659f with SMTP id adf61e73a8af0-3c0bd23427fmr5506792637.71.1783554537333;
 Wed, 08 Jul 2026 16:48:57 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:47 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-4-skhawaja@google.com>
Subject: [RFC PATCH v2 03/10] dma: contiguous: Add API to check if an
 allocation is from CMA
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB6A5180002
X-Stat-Signature: si8amoux88ywcx6rnj1k5jmbdifgw8i8
X-HE-Tag: 1783554538-539446
X-HE-Meta: U2FsdGVkX1+Bp9+13OY/0QyTNsdwMEOX6q2BnmWpOg7VpShmWS0HTuoHay66C70zUvpLQvBZjovhtgoZeQfE2ZHw/x8IQMfaZcmzkML4rzpJnO9ivc1+4r2foTK6j4qTp9SsLX50DESyE4iCFB0gRS7D81vzxaSzVQZhLsnEtfNb7FDNraZzctsWWAlwIGCTGpUcW9sOc3b4Aa8795Xcq2RTFpeA0y50UA9K2sXjHLbmHazAdxelGMUD4WBbv4eHYrMFdLonuTcsZnxjX17CTuWKtp7VJFvRaXrYcnrEvgWJekq657zOlq7qcI+tKS0tysJmWAoQlwCRfVU1YcntdR7Lnx/Fcr+rNytx2HWdGD3R+41LwshiyDtONKceLVmnATJJhSh/2Ixejn5jjUA+z1z4LhMteBWGyQilazM10eQsyz7UttjHqDMLxdZcuOxm5DCiTapx+w8KcKwQjKruigtRr5aB3lW+5++GiXJ+uQG1yoaZ7BC7+BzuYzqKlhAMxiRHv5u20ulIc0186XJfZnB74+i51ki4JYgcdIaLC6B5TYe8SRrF5z7nJzR7/R+hJqkqn/fH+D81eDm47fhgYlBxNx5ZpMO3BycAIJzT3+8Lh2moIKuqcx4Cc3VjEGQpecpm89GOd8w11aWIC5TJPhtJdWRT52RyJNRRP9o0QJwYnU4S2UpPhYylA5GycErRhjzus5w3dP2Lja5uuJGfY5BzPGJciFK+VOqHdT3+F/GkoUeHa7dJocNKEBgGHmNhWFCrPGHZSk7KOJFWb9rJm1MtggYV3YSODQWiuyIIj9QDvVjBrS6YQWBkf2NAqsVbgNGTofoV1tN5sdHjXSC/b8KPkVl4NqgnTFgJv42IIDg84FZTJWUx/9sHRHHJIsOKOv8quW1qhKqIWfqc8fuaptvYgFnBgcy7FWX/FH3I17k4RgBkKXbls7VsI3gxlH71LFrMFx0OnOivgiPkpa6
 UxjeKCNF
 36enLN6k24yB/h1fejCGJlIxYQQ4tAmE3j0gpcvnR7NIKk6+CrF84QxARkwYPlQZ7xo+qmcw5Grys5T5xhcJ1PsNHuvaflVgXXK4eWXSOKkiuqmbnTnQrWYjQa579uy3iHq/s3ZDmgrRQDU1mCjuaXrKRLzj5mQA0foQfd69WixtXzvoaxCet/9ccKeDx277bsnmk05svl8LOVKDc6FplKKRrCvtFgFcgTJ6xrEtlAGs5fs2lUZoKAF/Eh8sQDrBDOf0gJbIGEI9YCeOuLESnqvhCUNY0u27bJdHhq9MjOONmWJtDwmOivC1DbHSmffSVMvmLQdIh9EQPt+t0SjctP4u+eyXT2DSpMQpQKhGMKkqIaZx0DyTswJF1vRVcBK/yDAgLwN+9VOGwD6aMeqcNTQa1gHERshxKmPA4d1tkldLzMCYed/wZ5Eg8pVlV8Xr7LmwPJN+y5crsFy1yfUJRreyqsayARRtNTpb2KCIltz0wiC5rxVT7jUSksC+EM4C80HDO1BPEIQZo8RAzTjlfkeCgb0/bk1Iuoc+abv5rElDGwNJfnOq1RdUBaW2mSuQ8bHUZMtNgEfhtswAo7vn112aJig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API that uses cma_for_each() to check whether a DMA allocation is
from a CMA region.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-map-ops.h |  6 ++++++
 kernel/dma/contiguous.c     | 24 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 9382785a2faa..9b91c839ceb5 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -106,6 +106,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
+bool dma_is_from_cma(phys_addr_t phys, size_t size);
 #else /* CONFIG_DMA_CMA */
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
@@ -145,6 +146,11 @@ static inline void dma_free_contiguous(struct device *dev, struct page *page,
 {
 	__free_pages(page, get_order(size));
 }
+
+static inline bool dma_is_from_cma(phys_addr_t phys, size_t size)
+{
+	return false;
+}
 #endif /* CONFIG_DMA_CMA*/
 
 #ifdef CONFIG_DMA_DECLARE_COHERENT
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 03f52bd17120..0b1702bf39ca 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -130,6 +130,30 @@ struct cma *dev_get_cma_area(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dev_get_cma_area);
 
+struct dma_cma_check_data {
+	phys_addr_t start;
+	phys_addr_t end;
+};
+
+static int dma_cma_check_area(struct cma *cma, void *data)
+{
+	struct dma_cma_check_data *chk = data;
+
+	if (cma_intersects(cma, chk->start, chk->end))
+		return 1;
+	return 0;
+}
+
+bool dma_is_from_cma(phys_addr_t phys, size_t size)
+{
+	struct dma_cma_check_data chk = {
+		.start = phys,
+		.end = phys + size - 1,
+	};
+
+	return cma_for_each_area(dma_cma_check_area, &chk) != 0;
+}
+
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
-- 
2.55.0.795.g602f6c329a-goog


