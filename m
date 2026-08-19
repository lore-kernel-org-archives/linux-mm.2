Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8237C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA666B00A7; Wed, 19 Aug 2026 05:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072DD6B00A9; Wed, 19 Aug 2026 05:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E562C6B00AA; Wed, 19 Aug 2026 05:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDF316B00A7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D848140499
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:28 +0000 (UTC)
X-FDA: 85117556496.19.31F9BA9
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5A1E810000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UlLzOVGn;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
	b=UorNEt617Zh9A/e6hGfpmGlxedLsUmfElu8KYaAGMjXz1NtAIMNgiAodSMVBHI2scHQOG4
	+QDP2mRudUgvYpNt7jaSRsdYLDtFH40mXmD8FUkfTvSV1Z1MF3PMPvZUW8URRayDP7ndAy
	V6Kn+zJzmBNfK5+pyWURT5crElxGLG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133206;
	b=FeikMmiNw8wsEwVh9twSrRyCN8ZWwRMGKtFR38pFLke8KyGOxtC2XSt/oW0aDsvnFvU63r
	gPWgPKLyflk3vUUbJXr//Ob9E+Tf0MpckQout3T32Lgm9+h2dfMHqIkE8BG3D+dkxadtqw
	BO2ZsDAZbrLE+DIJfQngGJbTWJwC7M8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UlLzOVGn;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ce98cb8165so6258355ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133205; x=1787738005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
        b=UlLzOVGnUzVYpOBEQc51hCsT4Xvxb7RT0q7bPNZa1s7XsGpESFMMuoFSESZHGVI4OY
         GuIlgp3yVWXs5uyQA3aYbqtoShSrGdTo7swpxC8ycHaBR4nnk7X/QMvOekqCJV4cI8ZT
         82eBpCtlZ+/IhQA539LevVFrYJ8EuQhPfdf67Yuebca4zYc10qy0GPOgPyDyNJ4P7CgA
         7CgfMPil9kv0nRUtD4gvwUjiQkYtuidy3ED5JjT2vO/SyziMs1iX2Z7kIQapdy7W2lNd
         /0gLO5RPzd7vLMBGYuLtHc6IG+IPyeakXb4x9SK2E+0TAMOMe2UQZwJZ4X+PO7TkRzLc
         ERxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133205; x=1787738005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
        b=Wl1Jq6SQP5IFzhHN5m9fcvQh5KPDGZ4DZM/DltKD2JH7Qz3PaylaPTHGfIn4DvHkCo
         1eKGUFIegphw/Io4M0GT5JSOHa7rwa7Q3nnNVr4JWDykdZ6ptHVMe026Qrq/rnvtVyb0
         xIM8tUgpqyK2O/bdW5WLQH3ATEr2fJ1MPl1JBK018981Fwrpl4Yvwagz2N8lpQ/aYOl+
         haGjn0VJJNspZ7wV6uihB3UEOVsovNS88XeYNME83cs+uZ2+wlRoCm6I3yc9+Hu4YZ8A
         3UCBM6XUXxWZJ2EHAwLpQVbIRjBFYhzdOMg/gweIChXSAKjw5yWSVCNdXgeL/w95JO+a
         yp3g==
X-Forwarded-Encrypted: i=1; AHgh+RoHwQkblgUSnJakVhNZ5q1YxhTWz6kGuZzYUhnzekVDdB+MnirmYRpn6Y9Kml6sZ5Cq1bXVIC5pnw==@kvack.org
X-Gm-Message-State: AFuF++nQdsaLMRXCBJPQ8E/eDs0aY6VY/upKmymRqHotHyeUS/Y0AWMT
	v5jB9KYp9FE8kVECCz79cgv1jIajHIzN+BCTFYth6lqgncaJveZnON6KUbl0gMegpQ0=
X-Gm-Gg: AR+sD12HFtfcKsTu+LUwJ1NA3jSf3URsJt2L3P7SOMqpGmaGc+OUiZPeZiHeGM9fzJm
	pq+oh9i4Ct9Xe/PMZspS0npKkeXenRAdaSRan0r5co3OPaC/uV9aUxt58Uwj3fPZQgz2fLpPpxT
	+E5en8f2cYqUu0GuEOhe53Sb5tz+cCGtvR9qAI2KbHqHxRVjQ95GDKB394RkuirJAqTWVFA+Puj
	+GVwYUqwxzeGsKmg9JS95iIHjSF8UUcxRg9AWdmhynupJhbb1Wuikk7gieLeaEvrGQkzbGhhuzm
	vT0ByVnKynUNwRiVWvashZU1i7UUmh6sqj0kyGTjOqMOTDC7GosqtIarpvuPOqrpJJyXvACya14
	aXzZgk446f/PPvQrl1iY9jshk4G0Z/osAW3W4m/5GRIucNBQ5Z5fxoF5DPPFq1ANQlLgO6bJ3wY
	dW07vE/nqh5zJ5ojWkL05kilFDnky6sA4b+EdlxadtmWjYZO5mDoTOdRNq1RD78KCj3qnFCVQU2
	zw1qsVtQRcQ6hdQRQnB92htkg==
X-Received: by 2002:a17:903:15c8:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2d5fc8c65a8mr41853765ad.3.1787133205195;
        Wed, 19 Aug 2026 02:53:25 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:24 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 07/17] mm/sparse-vmemmap: move vmemmap_get_tail() before PTE population
Date: Wed, 19 Aug 2026 17:51:29 +0800
Message-ID: <20260819095140.17252-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1cesaf7d3b1o9uar7xi5rbd6paxuceo4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A1E810000E
X-HE-Tag: 1787133206-413266
X-HE-Meta: U2FsdGVkX1/96av/mmeS9hm7g2kHMnVZ7MegmgJzxshOKZbywATm5ons2yynNlHhC1puLqfH2GfEbfP327HQPvNF0HMVP3ORqWJoEpZtohnj0s++/YN/D7da4brdZ3JFQQ269O6//tuLgCFnm/uz3VBMTexy/s4ituRQNyAtvS4Evrk0bGygnSHwNsfWYyk1ECi5RoIZBiwfaVElBzYTEi2KMruLdRMyfnMyzIIJZSRxP2wHQlGC+hAjuxKkECV2GXjQqhuLPBjg7F3Nc/IZqZJxWQKOHJ/erhRN3WPxNHtfsm/Z9HPIvybqwf8SW1AhqPPhkuT9LOKtewFqNT/XatHyPB2wSn7MnPxsQ8Xd2OpfMeUES6tOlnkitbCGtuJLKr7CzCT6zb0bGqCuuW3KUGAqhgR3EMbmLK7BInZdBg2Pkactn3OWDT9+v3Mod5a60WqSSnZ9w1uyVsGkO08m4iaVEYJcBWYs+sLPTBY9SZS9nuCAreLtqjwdV4x7MArYOAWWF6iRHFl+7rRuQQ0LvSpv6KU0AP9Yjh/0kvOLhSaPyaAClBZzRAhDdWXAtEPl6NFie3NU22fzQYcoviFqNh10tVW6yh+tfcwkZJVOfbgy2jI2Gn/gYDSfiikScuAGgAzBwqmTSVbyN7FUSazA/E/iaONVs+Yq7C2pGlytTIDY2RuW29Tdr+c16BxiHGjoUOZ6ZNC5eMu0XinOcwvNupp41YVI7SOAtTBt2IyneusWdcx01zM0mDW/nxOrRPmLoHgT2wSf7sFSilhDhJ5H4ulFM7LV5zeL9S153ONzqTFjq/ZTi1wo5WK4u/H7b4rn9T7BFwJbi34/xVc+esTKdodiUV1rTMNn5EHXENmaDoJoh/pOSTkk3ti4yqDsuwHXNGQAu4I+ok27NwpuMeBywQaYQV43FgC9k0lW1SrCd2qKYqcS8pHYew012c3yiS7erYmnma9MCAS0wB6bQ/n
 ynH+1k4y
 cqCv92rk0QkJR1tFELnwLkFzEEWni8WpkNaZ46YadXsdXpOKQHO5ZU11Z2BNyz3HT8IlyuHJ4hKH0nOFxhe8ufWZGgEr+LYFI0ldKevUZBCWhyvWw9RZiyEnmQU0PVtysVyJmAkYTkN7dYxFRMguRCXQ4z+BgyrQHbyV0/pF+NT4ogApx/DJzuKmc+LqaICJ0sMmvFet6fjj/mqZJXX5dYNNr/Zm8zemUjVAcvchWF6+x4/KassBraAwlTL2BSqJytHsFdfLGgIeXpD7U38vWpTAm07N/aEp1UwsSrAO20srgAP3F8rrN27vhofH88T/RVYDSBdnbsYxVNxe/UQtVwqhD58Rbr1yJvrsC7d/rgl0c0STqOjXgFUhf4RwC1jN8Kc9/nj1SpfHxDJ7S2pAlfHpXYmzmTDfXhzfXxIVL17i9PLPdL6YYaZ9hMw==
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
v2:
- Add this new patch to move vmemmap_get_tail() before PTE
  population (suggested by Mike Rapoport)
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


