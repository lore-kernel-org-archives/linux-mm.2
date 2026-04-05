Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AFFEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D262E6B00C4; Sun,  5 Apr 2026 08:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD7A6B00C6; Sun,  5 Apr 2026 08:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14516B00C7; Sun,  5 Apr 2026 08:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B28926B00C4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80D6E1B8EF8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:15 +0000 (UTC)
X-FDA: 84624500310.28.ACA4E58
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id A40171C0003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OZKVnaVn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393773; a=rsa-sha256;
	cv=none;
	b=3PFVbDZIlrjlN+ddvy8mKBHf+9gBbIeATzHSktz/CiHFX1N+51/qtZj/fGg5Q0FABuPePL
	e1vJ2xRBCKVuI6D6X9b1JX5tYJlHisXasjwTCskTGA6PLZw3zdFBCQHjrczw5d5MCz8+hi
	aOsQ9yf8gW80j9Wzk9ED838XHIpnIlk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OZKVnaVn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEDM6s7dxdsKjdGxQjN87sllzWekchktC1ag1ZZ29CI=;
	b=V9Vdl1sNJFV5P920SiXAdiIkfuilzyd+G5pFuwFn+PyjJSL8xZ+lO7g8mTzZkGWOkliz8p
	8JR/SrbYE+98H1nxugZr90Hb8mcrjWxH+weKn0IigC9YxhioprXe5Ua7DDszvfTS7Zt5rO
	juM41IZWesH4oeDZVn9BQIpFAou2RTA=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso2819091a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393772; x=1775998572; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEDM6s7dxdsKjdGxQjN87sllzWekchktC1ag1ZZ29CI=;
        b=OZKVnaVngVXvUt8vlCub0JH5hW2ve1cDM30ZLi7IakYgtXaehK12ekyWfFFoIUbboh
         8wYiCv8ogx7SE4HW6Yq2vLwdSBYi49U5saiBTPU5kZa08GTNSOT9LFW3Tawjp3G5XIpY
         w/VCoWwSsY/wL4yyxH4eOe8NzYe9aXCoLAgw16ngWgayxH+FRIA5RQMTk9E63UzK8BhD
         VDh0tyMIpd76+LsB60E9nI+QcwcsgS/ARgj4hfrEx7iL/A6nsf4T4ZtDPkLtWj/Q0Eu1
         jehg/7FJqkHdIMAO44c3vMASXPksnPG7FYKWYy/PGziinQrseuyPV47/tkFiwm/DmEJG
         ld1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393772; x=1775998572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CEDM6s7dxdsKjdGxQjN87sllzWekchktC1ag1ZZ29CI=;
        b=Vs6vqRC8xgl0poWaIZ8WDjJRNWTVs/um1957Kjdqt12odTu8GUgE5KEt+uC/Rm2vj6
         fldou09WBrcOTxyRCVm5gJbooIzeCi6Bfw6FGpddj83hf85gOQfUBnJdI54+mIt6WROp
         NnMoK34gPMYWsmogFkb897MUIoEarpvoVajq5zfvL5OlfaWEO+WquyyH4QyqMuJgnYjI
         I7wMHWZEdS3fN2n+itjtmvfHbGQPcm6iuUHhHcE9o7lL2Xgty9SejBkZLFbA3LbUAY0P
         LSs0b5e0+abEdsxGmY6jR8KhghzcnrqWzOuGIwCKMptSptFq84Tu/4EOK2xd+k5VSyNN
         Vj+A==
X-Forwarded-Encrypted: i=1; AJvYcCX3HQvnuMhX7W7etB1lxt3dz95pqvt6j1JLrjlBaDXsTqOLcFCzmxjz7jctQYwKMHEDeRdL4XEFwg==@kvack.org
X-Gm-Message-State: AOJu0YwgEBqKDLK33LuWoR5A4f/RtB2tqOxjeF9cpPTk/yZYyaTfPGMs
	bO5N7zLZxlqZ1xeKtJN97lkqychZQHkKRdm7M2fYZRGnAXcIAOm12Tv9Q2e5nCpoZPE=
X-Gm-Gg: AeBDievwJ6K+H5u3KYm3Ekq92kL+i9zwRC7BJPt3Z3rAHKwu1PYfxIu5vV7cL2aF1Vn
	4BIqaoHwxMyyAOSRMZW3GwHcbeN1hZ0emZxjj+ZyI6l18wyFKC4W/thWFUuOmRQqQp1agfHGwVT
	oWqN0wMsLwq8Ep8YE1S84BRFgEWYCDh6QKlHp7HCvvUZh9VMQ1s32gTQGsQwZcE7Wvq1AO1o0aZ
	XG1LjfnsntluTrt15oMyfJ6aEbZ11ODUP7XcY9j8JMd+HgKZKe6WesXNEFKky/66J/LTDIVmnEw
	rENsSfhItr5AvImsfuNSpJWx5JN+aYQia3+6iTavyh3fKKTlApslrXhan0dGZjaFzVBZZGUeo5C
	XL0Cm51CWxD0htedqTkkmzrUtr2dgK4qJqfvyCLAOfRqPBKSgMTUwnSstNVIuPHtuwYz+9pDr/4
	QvvTe4nscLEqv8O3qLL67ZFJHBVI3fVJFg4/xBX6c+2rU=
X-Received: by 2002:a17:90b:224e:b0:35b:e56e:a17e with SMTP id 98e67ed59e1d1-35de68cf52fmr9251356a91.17.1775393772471;
        Sun, 05 Apr 2026 05:56:12 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 26/49] mm/hugetlb: use generic vmemmap optimization macros
Date: Sun,  5 Apr 2026 20:52:17 +0800
Message-Id: <20260405125240.2558577-27-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: chte5smrernw96moc8cswg5gk63yirhz
X-Rspamd-Queue-Id: A40171C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393773-543583
X-HE-Meta: U2FsdGVkX1/VjdbZUl7WRaBJ7odTJcx1V2g+2BBUoXKKzKd/nP65K01ayFvRNhMSTa0vjhJxdkxUvYiMOtDksFYZ7Nf3ZK340bNF0s6sh0oprEhDHKBfyRsnkTLgaBSMtFpENWuync9I2rlEIzSNny4ZK693z8WvtrtDBnh3dmkQWs3IY4fInaGzzNqgG5pzA4zKuXnOEiQDm0fxlZmog7Uk3myceWiqipAqZ+3m/aqJJ0u6r0zrPJzY1tsd4fIzozWtujJsISJyH/C+SRWT8F5+rGFki6zzlzanTbY8aBE5dxgBSryTw5lIeHd5IPyw9pStF5A7/gUHD5QpS9KwQloDBxD2gJwOmKnMxP8TzGk+AfzYKc/DbtPW5Q+U6uYp6Wa2GoCQt+X6PK+ZPTSGQNApQxQmeFesaJDw1AF1fDdTkg1VVtzHPGkRuCSRBJHs+SH/UqemGIepmPdqYskY8SnaYXyBHv3hdn8aEj7+rFFvOf0pmMkaRIts/qlNG6b6Uhhizjt0qu+Kp1ADdgH4vpsllHuuWPFfWoN8D8YbqBBYI16u03azTpMasABu+RZEnKZalUD1wdKA3lUUBZNmGprNKa/aHuvTkzzuuNteS9AMs9tDmsfSNbj+3zautIFDrhv6HEctevfF4bviKUr7+gvLoA0gfc8KvZYha+K5Ri7yJfdXYGM/bUgw+awE60TInq4yq1fz1chE9CAjxx8ujQYGA3EciMLIEEM66smpkhh2e4OKjns34hIYXhWSlrvPvLyfZqlAWkeRTahf7Tnv0NaRk8iUYvoDWaaiczxVrx0/xPiT5Fe5XeRFytYbMhcFjM7rwB0q3FOE27kVtAvPL5bt+bQUX1PuTBIxkFBVzJTXhm4UQGv5cVO0RWH3lZpGomDC1pNFrryv2gAr4GOF7Cph8qw1nLi1hUVoA2vN0AqNoHCO3LV5HqSMR8TrU7IFuVIiy7jbQg1N+bdkH6H
 yJwnF6Zm
 foSRTAtU8nOe1gny20jOpnYLpCSwjhv8fEGAWSj3itg5LY74OeFX9VcaM3tTYlSvhHGkiY+H35L0uTVdCp5peS88gazAJLdPHtPyj/Hq6SqDlAaVtSaryqBqLX7P1Gfy9EIGPSLfhYKVvS0YJc+mOyUgovZYbaGvTYI8tVq9ymKuW3idGn8hmQPua3UqtH/LsP5oSB0+ojdrDuvkLBwyMi0chtD2jJxPs+w81SNA4PC/v1RkHibUUW0gBmZ9eMtMIEZsYJ4DB1+IRQaBief40Q59g50meMTAuuZy0wrp2ZoaSATtupWsmrdk4VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the generic macros OPTIMIZED_FOLIO_VMEMMAP_SIZE,
OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS and OPTIMIZED_FOLIO_VMEMMAP_PAGES
instead of the hugetlb-specific HUGETLB_VMEMMAP_RESERVE_SIZE and
HUGETLB_VMEMMAP_RESERVE_PAGES to describe the vmemmap-optimized folio.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         |  4 ++--
 mm/hugetlb_vmemmap.c | 14 +++++++-------
 mm/hugetlb_vmemmap.h |  9 +--------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a00c9f3672b7..a7e0599802cb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3241,7 +3241,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3280,7 +3280,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS);
 		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d6dd47c232e0..0af528c0e229 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -407,7 +407,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -637,10 +637,10 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			spfn = (unsigned long)&folio->page;
 			epfn = spfn + pages_per_huge_page(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
 			continue;
 		}
 
@@ -791,8 +791,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		zone = pfn_to_zone(nid, pfn);
 
 		BUG_ON(vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					    zone, HUGETLB_VMEMMAP_RESERVE_SIZE));
-		memmap_boot_pages_add(HUGETLB_VMEMMAP_RESERVE_SIZE / PAGE_SIZE);
+					    zone, OPTIMIZED_FOLIO_VMEMMAP_SIZE));
+		memmap_boot_pages_add(OPTIMIZED_FOLIO_VMEMMAP_PAGES);
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -824,8 +824,8 @@ static int __init hugetlb_vmemmap_init(void)
 	const struct hstate *h;
 	struct zone *zone;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* OPTIMIZED_FOLIO_VMEMMAP_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS);
 
 	for_each_zone(zone) {
 		for (int i = 0; i < NR_OPTIMIZABLE_FOLIO_SIZES; i++) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 7ac49c52457d..66e11893d076 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -12,13 +12,6 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
-
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
@@ -43,7 +36,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.20.1


