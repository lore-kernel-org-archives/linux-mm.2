Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF783C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F316B00A1; Sat, 26 Sep 2026 22:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10936B00A2; Sat, 26 Sep 2026 22:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25796B00A4; Sat, 26 Sep 2026 22:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6E366B00A1
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94A831A097B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:37 +0000 (UTC)
X-FDA: 85258026714.17.170B9D4
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id D599F100002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dswX/z4w";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDyOFF6NxHUIale2EKP70eICKc/klrg6ENuabN+7zVI=;
	b=I4YZk2vjJWJqV5J2QN6HPjAiiX+bB8IeQwzue0MoblMeePI16YyewsO/CN+nK04QV4MwU0
	pKnUzEpobQ/if0ozSfSMWJwnDItO+dV5DBSTjlp9KDWBmeDEXtq4nTqCKtr9TDNZ508GMB
	AdQ7bZLRFoaqo7zXbVhbxCArfcYlYV8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dswX/z4w";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477735;
	b=NN6Lp8H70EyjinPPEnBCS6TB6UlyXsF2WP2JdEsDOUgiHsurBu9SKw5277w1kykQNv1G7j
	5Wsas+GyNh1TWpD9ZaLQHB2Icr6vY1JewZUmIVeX740SZ6P6xRPWvWS+D77F1F+JD725uZ
	ikTBwu6Hsl2TXGaQxfOC9nXPU9pHmCM=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba91so947871a91.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477735; x=1791082535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vDyOFF6NxHUIale2EKP70eICKc/klrg6ENuabN+7zVI=;
        b=dswX/z4wOJLq17FXN2tpKMyB2c44ellBM5nFr51hbbC0CF79mo9N0dH2YPfMlg9Ws3
         h7yrV2SJzJCZ9ANgaILEpWNYtoTp4QkYZP4UnJNDVR0OD/miXPwZuswzZMWiTTZYf2+B
         aqBaHmLQpG7K9L64weRYIktrEu8pEssvZNnB9sm8EgBb6ZY3UZIl7DXpW4JnmrcYiNTA
         99WWdTImG9ht9pjAobhQMkeewu9VZULU/vKmaI98JmaPnxqTpu+mSgRA6CWSFyrbuxYA
         rI8pzhzEzLeU0gP+iS+bm9e+VLAhljUfVdwHSrZOb4XCuoYibS6x90sOITbsDwypTa0m
         AapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477735; x=1791082535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vDyOFF6NxHUIale2EKP70eICKc/klrg6ENuabN+7zVI=;
        b=YhwWGxPBdONKkgQrAiFVS0F0glmz7RcXsPXiDb5n6rWfAb5h6c+aeAU/YuN0qCAkir
         vJM5PiG6UMdB+guZDTkC1ahy9/lk4XjiACHnihzfFz6L5NrkiGd1wZWj+yJ60+kBka9+
         +2eyazhlmTL71X45ziFuKaXoPNWdGG/GricJjNnFXmUuur2buB22zo07JZdhTsXkO8pV
         vnQ6zfDtEqxs7QG2DlBHh6Dp+1BVU+eB6KpI3ukbgrIU0hSN2Ek5xkHoxhk9TGF9FJe/
         FkeTnXJGLNMe006IrY02FEnVFP4B9rg/pAlkZEmkdY6D11BEcT6ogLhsiSPXGEzliLUu
         cpiA==
X-Gm-Message-State: AFq9FYIFjKQauEhMUktHiArtPUSX/8dXzlw9RmSa2bGBOMSU0GMI5hFY
	Ge8CUxl4Go4BQbEHdt0kdYUDZCkjkpgRcD94MbQe09Mlqy6cgbVkC460Ctysh9dxy10=
X-Gm-Gg: AYBFou1rjVIf/YrzlJCG6CWV3wY840zUhMeZHgo838orj68fATLt45Yr+J7oWbRaPl6
	wvYCJWAQ4mjNKIuG0WSxZLNs+Fuiq4D5G2o7tiKwf6SQA5pFhQdT0sWGr0un/uSWqBONi50ViSj
	TZ6d01wC1KsZaauzabtDs5uNnCCaWDzKvzRr06aFY6E9ahSyLRntcNickV0xwbC0ZprbLA1o8LD
	CIavU7S/24iI7C7/8h7JN4ORElVW0z0wapraEz2BAV1hw32rCXK+IkGSIodwBxjO9jzt4g+2rFG
	dwjCGnx5OLPE7eLv8lMgmDqMoclVf8Sfk5jn5hJNbDzncFCbrwAS4GmbKNT1ke9um7JHIGaW3Gd
	2jf+yH54LlEfPLnp+JDqPEEfxDPzXC6o/GjQGVcuIVggG7up7c0jpIqALVHQi16Wwq5Rnx600QW
	s9EdC+OXsVRIk3JhRBZmiOLIcQN6hjsOrFIROU1Q8k5ko4TilvmCs2aQLdRFaX6laL+MXIxPi0n
	fQPlPmpy4c5jNIfWYWb
X-Received: by 2002:a17:90b:51cb:b0:3a0:516d:9f87 with SMTP id 98e67ed59e1d1-3a0985710a5mr8073880a91.13.1790477734640;
        Sat, 26 Sep 2026 19:55:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 09/12] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Sun, 27 Sep 2026 10:54:38 +0800
Message-ID: <20260927025441.741633-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nffadio49qisx6ncmyewakqyop6fmowx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D599F100002
X-HE-Tag: 1790477735-784550
X-HE-Meta: U2FsdGVkX1+QX+49/lKeGbKPVj5yEvwmf13mfleY8JrQcu+r26DD2YMcFR/8ImMQqaqEmzKQtzP4KTBwT/PXWdDa9MGxSmiEgwWJx8liNEWxRCjeSpYBLGjYsHts9jw/mvynfMV1/Yjf3XzGPxKQsvtCS3zcvvP5gPgEyU7ivwOqp5PzZnoQcA/5HTDWLv9a6WlfmzDXafaRok8kLaYJgmjKpVQZpBrMtI+55NOw8wIt+TDz5hkv4kaBChuBzVeYowoIw2TwoEAFYLonYavoztQzJm8ycWGt9tKDzqNzesWI1uly64bRgGfWIkDTa5Vii9euVPNuIiL4ex3ZDyZR778dLpjgA2GKkhLxN3+dsQQ53Onbz1F3tpqpMPUGTyr/ZeTdsko1+qmN9RnWRSanecTjpZVldVbf3GhbhCvqWU4vhKgn5uxvwju411kyeUH15TIVPgxx7fijj16p3loxIoHyURSmzyEKMyuF672s5qjp1mjE8NrIUhiEV/QDWcAoBYhOrCJ82oqQuWR5SXvB0tt6VsbX9Zf+8yL+FuZY1UNAcOMIzR85vO5OPOMidn9fKuvtnEfi1lDiQrHLlhKpH7mN26w/5iY/0ysB/5+muX+VA2PybSRtpVShG6iVaCj5Zq/YuI4Cv9mSg5em/iT0Rs5FxuNF9h+sKm77CJmNj1bmSybOIPLvOpP+73kSduCdGMWP71UCjz5m9gTztIX7eFcqKPxxpJYHnaOxOQsAL+YtpGVEiDQYq/16Hi1ckFtsch6AB7TDtCcT0AGpsbYXgxB+Cxndl0Xe/1GfJisciOkmGEjee7ko773//fdXZv2xN1ob7Ud0XonlOUwBKyH0y+WhU7RVM7LLkKw/fAi3wzLyidDvNf2rlT/jdZXDNsJW+TyYSOmUfFRcnKZB9pAwV9MS/sTYNW8C2F1ixULKFBaOnEJ3xYgHuArbGIqvohhVC5dfackz7oQR/9ioZ6L
 E3H0tWqS
 j4TPWnPcQPcUd83w9YLHQtbQQ35XLp/cg348WDR1jC9pKet9+BJ4ZMSc4Q0SpPD1qIpU4d/hUUjaG7GhQMuxedWTotMUkGToC+03buIWfRDp4i6KpQQ6E7ZXGQqYD8xafHpOjfMusI9mss5OUHlW5ogcjtXNW5U8+BHLEpnGnw5A7bKOWSlBD5LqRZHt5lFb+mxR5F2BJp7g9/O19iDfFG7pU2sitJZYhV+MXn6WYUI/sgGmSYJryFb3vD0EZ+q0FUPkKKL2CO+a5U2cliePYbPOZc3FNQLQ9XEaHQiErIFV5jnJvEmeOGfLhEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The powerpc radix compound vmemmap population path still finds a reusable
tail page by walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared vmemmap page directly to simplify the code.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the device DAX vmemmap optimization path with HugeTLB.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 80 +++---------------------
 include/linux/vmemmap-optimization.h     |  6 ++
 mm/sparse-vmemmap.c                      |  6 --
 3 files changed, 15 insertions(+), 77 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cf692b2b5f7b..ee068f24a79f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -19,6 +19,7 @@
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
 #include <linux/kfence.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -1250,59 +1251,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1268,12 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
+
+	tail_page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1349,10 +1303,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << order;
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1330,8 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index bd0974b262a4..fa9e9abd6656 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -83,6 +83,12 @@ static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
 }
+
+static inline struct page *vmemmap_shared_tail_page(unsigned int order,
+						    struct zone *zone)
+{
+	return NULL;
+}
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
 static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 2bc78aa053a1..4309f8b626f5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -236,12 +236,6 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	return page;
 }
-#else
-static inline struct page *vmemmap_shared_tail_page(unsigned int order,
-						    struct zone *zone)
-{
-	return NULL;
-}
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-- 
2.54.0


