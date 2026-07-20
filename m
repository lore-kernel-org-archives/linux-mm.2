Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0B4C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC6F6B00A2; Mon, 20 Jul 2026 05:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F4D6B00A3; Mon, 20 Jul 2026 05:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CAD16B00A4; Mon, 20 Jul 2026 05:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1436B00A2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E82F140762
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:23 +0000 (UTC)
X-FDA: 85008639366.21.FB9980D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 23F24160006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ME1F3E+m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+FzYBHgL+IKE5/vY4Q2WTb8Xgc0rS8reYNZSakryMo=;
	b=GX0V48hGJIfE+/n5wPX6CPa2YDGSOvtNODjjPvfHEC5sTD45qJqo0Rflo8eRuwI4ub7Vsj
	utbO+wxZnElroC0GRTfY75hY4lUDTEoBHR5iyJUcOuPvcJHQ1ZyYR/sgug/xzM7cSrkPAZ
	erXqF3ciymOOkSYteWklKZ7Tksu9peM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ME1F3E+m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539942;
	b=SWCuP6nzD5fUAtK+/DVF6vLaDYW8OGbr+/fezmYWPLIJ2oNa+ORddEOLLzbA5DB8FXL48f
	pc4zZ8+JbBEmVFWbROiDniQUuJVjCUCIt1vfbz89s3ntidZCqL+S7vTViCnJKY5dNb2drf
	E+x4WKOQo6sj1jPvfIfuIutfzv1BO50=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ccf2360620so57774585ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539941; x=1785144741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j+FzYBHgL+IKE5/vY4Q2WTb8Xgc0rS8reYNZSakryMo=;
        b=ME1F3E+mUvpM8mSgaQra0QDg+5yrSGGUaYidvvezTH8JSW4rgc5bH3M2BOwcSutBOm
         9rxL4zmX3O9syrqykJYDk0e9zRyZo0QxaEE7jAixhthGy11DlYImxjmcB6vV2KPrQEIx
         6QsAOlsdyIb6U3ynsXuSOFA7MZShdfmmYE4mVMvPQlk7PYILCKgSNvsB1ioJ6ZvrdneK
         +Z40B7Z+X4GOvbK8B+fNCWPOVpivWqYjIpZjrw9vTjGAHxC9znW2uAWA+CuJi3j3CSjr
         QkRJYPHCg71uo0jowiWLjaQopW62A5uc+r/yqsnXCZA+Wq8JhzJvQkgti/zxRkCh3b6l
         e0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539941; x=1785144741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j+FzYBHgL+IKE5/vY4Q2WTb8Xgc0rS8reYNZSakryMo=;
        b=XQjkn3IJL6vNtKfAZdPUlisF9gl+BIisD9gKszAG0DP9FEM7XIsqdUU90138B8XivK
         a80g2jCwuF2VdrYP2XVv0VGfz6aao2zkrF8xikRzKLO5loR/G1/mUB3Pu2H2p3wkyEle
         G6geekF+kn0NFzJ3L3Hs3PyJL8fOpTyT6XT5nBuF/MIx4ACgNw9knjcQk54414bGS/Lu
         GlTZUCSGr5nfh7CUNguKQFJ5aJP/xEAz+X8FAKqlCslhryxAkJRNVciiaLuXciMRfbFk
         AUhkJZygZCvJuAcRmj6Z1grnJFRv/CnMp7LF6HWTyz8xMjdVhBlDsqiURecU2McMhvrw
         jOpQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrn27Y8zwZCQSAf03OgwEgeaUr8Tl2iaL9be+cq5cwLyCRBWQ/z/nTeEYXIpjBa9nbmX5fa9qItkQ==@kvack.org
X-Gm-Message-State: AOJu0YyO7tVKmK9FKGsV8LOpt8o5Cg6lSGdTb4MqSJ+0lcbGJjYvTpqP
	e6AOYfMAlCLEbwt6u/RAxrhwzeEidShRiAn75xsyB7VM5X/6ijQHjwLI0HL5HGWe3V0=
X-Gm-Gg: AfdE7cm3M3zMACS/zFCaxvRmr1C5qHyvzPuYgsaaCQmyLT+PBB5vJ+z1zlThDgWd1oE
	vR1VvTECH7yeOxaZdOFm1T2jr/04aYdlQG6gH+uraQ9xoROtf84UF+e2N72W7BUlMbopgo7xVFw
	FpVJRasuQPReELuaInhNzNzJnraxozH0XTNhPh9AYaG1vB0V6teUygOj+64dbj+aMl9SjHAATod
	Q0vvNi2lprs5+lxMo0ruQig52531GZZpqGSVE9XCEBL7WmfBqhoejZLTyZj07ukwfY5LCIrYd6V
	B9vPUAC2o5MCNe1HNdTHjFlZ1da5NK3Bv7Qk6xvTSVuUSSmlAKbsnaEfVHiCDRHMR/7aHuyWiKx
	kfTKjeBXeJdLUAZ7dKy5dt46xdWswYM4SgJx40q5agW6o7E21dRWI2c8B2gKo8hByOScYJsfDFG
	WqN/lu/Uk4GXNesU2mB40brPdAJzEykga3hw==
X-Received: by 2002:a17:903:a8f:b0:2ce:a600:6022 with SMTP id d9443c01a7336-2cf34850c21mr145375985ad.7.1784539940962;
        Mon, 20 Jul 2026 02:32:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:20 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 07/17] mm/sparse-vmemmap: move vmemmap_get_tail() before PTE population
Date: Mon, 20 Jul 2026 17:31:17 +0800
Message-ID: <20260720093127.540540-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cj8weo5r6xj5b4tqr1q8k3ed3n4yzxao
X-Rspamd-Queue-Id: 23F24160006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784539941-368833
X-HE-Meta: U2FsdGVkX18s7ugoIQWwb00GjYTiiwjm1s2ry3BibyNktFQhlG3kEuzVJiaZlGz+AqwntoPkRZGkrLMYPkdH7ZkPl9RcudTEByTOEoQx+5trOq4mSSY3fcySydprHTuELeVZwvo/fvFUQMtlr9dDCclCyFQT9TAq5drPntZL3CD4/mQvIaeZk7SzDvxAv3b/TflMmHWIAjEl+21WxrNjmzHsNs2GU17G/+VVwf5Yp/xi3nL0muxoOyidLR/z+WnMDEWCT2Ee3MaJXCcBt7sS/nVbW3W3W9oKHYMjfMnrnQTLb5gmAhLLel+wECoUfVlA4LZVV1ejwASz1LfYkNYxieiaQdkafalyOAQEuNRLb2MZY8nfZGmBqMwdMPzI1Y+R9Mrws3lQvcUQG+clv4/ERa5JxD6wKhBb1Ul2h+A70Iypt2gBXO/zASsKFkmzhlADbReJcjkG2iruem6vWL+5Wagl422tbPKqIMW3dv2ebwswbUyfXOOe9dnC99ElASS7in+H2NOTS/aMa7ctR0TiOvNdVicNG1jlnRHH50ZieDny6lRjL4WqPIxkTHbbQwG/JZF68hxrdZx8zuTx47KGtBKgZYoDxURf9iVlOrzW9m5He0rfV2B86yOK24hLG1aSWE7YKdB43D5eoZUin/pcuRTEa1kj4RXmR4r2S10TFv/yFxwzrsmVFuDRu2+E+BwHU+XLiqx9LslIykz4/Vo23ZdC5E4LbQEdFGrSfQio6jbrygl+bRQaJSPmUxPDnjQvYgCtemOM+/6PMVbMIPfxzukLofITy93VUD4tEyVKLJZC3jNc3qJYafqYz/z06m0LjKGTwO76YVMho6ZkKfnYS2Vq69RqZaXH3eP6+uHKSs+X6eglvF35mt8xYjbw1IbNyzqmRD98u0D3No2H3rEUUH0oQFKsr95Ak1eWVrclj50jVM6kOs2c8kpEuE1BXQsTK101JhJfXsqxqky+bxI
 k9g6MtMt
 BLr0pxSY4L8OKgTVDunITFf11ZnUfNof9+0KvMo2cp5cAwMB70s2AY6Bad1xRCEx2OZqL/1f/CqLhOetOxTpbmdCp8G4H0FhShtJoLWVxO12pY7IvXrZ9ShCIG42qfJttoP/RRpblMR/dKw06qIUehdZQO3c+ylGIdj5bs4iJrlKdPFe/voZscpl0cbW8npHzh8/djoW6I9/lDPAJl4Jd0oyJ5Cj6lLQGmxdCrO+btwFf80gkV38DsXMSIYlSnQgMySqOV8ew354uyPjvN2Puo2d5TRycCB0x5Kh1TEWqMabdVkchcQ72DiUTjoJzcdIlXHXRMgdkTOJ6eYez6FqwAJdgt++qixn6ujBKCb1VlI91pZpqfOTlJYvEuxdoMC3tsADj4WJNql6B8G23CXs3BSTj4gIVWwo8IMXFKGpMlTrlmehgj9Okokc9sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A follow-up change will call vmemmap_get_tail() from
vmemmap_pte_populate(). Move it before the PTE population helpers to
avoid adding a forward declaration.

Move vmemmap_alloc_block_zero() with it because vmemmap_get_tail()
depends on that helper. No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 78 +++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b7abc5494bb9..b770fe2428fd 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,6 +148,46 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +221,6 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +352,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
-- 
2.54.0


