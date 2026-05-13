Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2B1CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323436B010F; Wed, 13 May 2026 09:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4076B0111; Wed, 13 May 2026 09:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9B26B0112; Wed, 13 May 2026 09:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CECF6B010F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8FFBA0128
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:35 +0000 (UTC)
X-FDA: 84762461070.25.2BD6D80
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B0D410000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MmLXxaua;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2kKgj5K23Ztq0NiYkfPLR6EY3A9OUYR9zP+JIm9wZc=;
	b=0Repjn1LBpkFwB8asrxCW26NDxEWAxLfR3b4uWVrMZLzrNzKtYXyCGm6ZqRzkNqZ9fjINS
	9khgS++AXLRxBu97+fFTyVZ9ma0LYOtVIPszs5frPHvbGybxXQZX93pu73/7CjpsM+CjTS
	cI4H1ckJ6KepxKBSFm7jwlr6qseU8cw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678554; a=rsa-sha256;
	cv=none;
	b=n0nPOxboYwzuXREWymoiOA65SMcYXVAR99yg3CeCqqFupqm51Z6BDXiSUKgZCabz8AjnCN
	UxmOc0Jrsz3IUlbfCXsp6+G+FCRvoSF7fonivJjMWa6yls3p+23V52pIgK0QV0Qj5rbvAq
	fZ+OEPiCgsmFf6DXQS6WbETE3jzYapY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MmLXxaua;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-366070f71adso6068681a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678553; x=1779283353; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2kKgj5K23Ztq0NiYkfPLR6EY3A9OUYR9zP+JIm9wZc=;
        b=MmLXxauaMZR5qlrfkN/uqu+P31lNLn0SV+LF//1YxD7PKWSHG9zQeD9QG/tE7rqnwp
         QHWFpKEM2+mOL+QHiOlttJgkzQPRlOorUnar7JzMHRVZkBCuR/3uXxqDOLBVBC1x+u3L
         J0Ud8aHC7DoZ6UjCVB/TC8tg51NtoBaReSHm2jnocrjwpCLG5uobHd4BF9aA/9eRMXEw
         9EGoBmZ9e6R2PjULLcha4nytdBsI8UGUsKaZl067YxKFmCmuh1Onx1IHMVxkvLZ0NFj/
         vmhyY2/LpREXloG09m8ffnqcdVUyNssj+ZjgvBdxU2S/V8U9N65rPzVDhZ/LPJzHX0gL
         G0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678553; x=1779283353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x2kKgj5K23Ztq0NiYkfPLR6EY3A9OUYR9zP+JIm9wZc=;
        b=oXm0TfNF42t8E4WhA8SDhOHSpho0vSolG88jTCGWfwuLPG57PTW+CbJt/SScU40B8V
         Xpdedi9NkKVrYqOf5CeaqFndpl2YdNTMZVawDWfDpGdR7bV680nWFvmb9if68iL0s3cA
         JppmzvMPJWX9ZUVDE3thC/FYhucxrdt6XFneV4dhD4OjB2tTWtKBxkQCnf60LRWOyR0o
         ApzINS412ZmqtCQU3xaXESoJYHELf1YHjszHzGhKUV8Kot+2gLImNMNiggrSXkBQPfqo
         uIs73YxwB9bf/C+1MNswA7rW0tV2IU5WKTUtTPESxHZB1FEjiDPguJWVQJn2BkOD9AAc
         lKhw==
X-Forwarded-Encrypted: i=1; AFNElJ/SvpKfigc0rtKI9YHGjoYXB8aYDfmfZWZK/QN+KXEgty7gt9N3bAsYO5b4dai5EuKP8L2leu7NOg==@kvack.org
X-Gm-Message-State: AOJu0YwFoXXoWZHvU2OYLEizbsjxvpoHgOxgR4U3lo6rBmuUIcrYIvwA
	pvPPw17jruy8GbTVUIo78Oc3MSFBbGFdj78HiFmceyLNIjImNtxXHag4a2lnnEat77M=
X-Gm-Gg: Acq92OHt3njN5nBZLuaUAlaxCahEOoOXtEc/CGzybct/ZsgYbiyEtVyTfMu+mGkryK2
	+q/cCVxcGCEaJrpNgKjXX5w3R16MkLHWk5D7G2WcNiutl4awSMoiyDIdCo9KcVbbftYGUq3O3pC
	xgMwJgASy59NKAnnQGWmmHyjn8SWhuh6nit+RFcSk/+k8R4nhjFQjE9DlkE7oBDEY7PqVWt7U8S
	UOYADIXpd//79Sd0MXUnGQygjxMPcjLHIHcF+3BDo7JQ9Jnd5EswHdIBOS2QOR8FItCabXe1cJv
	RByuzK9n1+riCfrV2VZZIK147IuC/WjRZ/KPCjbp+7ITB9ACOYkjUL5diVnRZ7rXFfHeLLywfB8
	ElHwcM/GZ4Gy7ZoVNOkbNa/3O5bdQgu4i4Djb7PWZdAS69cLjPuKPUhXlnbCOI8Zk6TCuRPRoyb
	cMtg/8kP8trSBRwDFC7AIydoAKQIK3m6kSLsuLFdKVVEO8E6XT+TfHRtojgFSL
X-Received: by 2002:a17:90b:3d44:b0:365:7e4d:bcb8 with SMTP id 98e67ed59e1d1-368f77f1013mr2804387a91.1.1778678552706;
        Wed, 13 May 2026 06:22:32 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:32 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 62/69] mm/hugetlb: Simplify hugetlb_folio_init_vmemmap()
Date: Wed, 13 May 2026 21:20:27 +0800
Message-ID: <20260513132044.41690-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B0D410000B
X-Stat-Signature: fhrmndzu8dttqhynbdrimd7gxzrpmmck
X-Rspam-User: 
X-HE-Tag: 1778678553-968596
X-HE-Meta: U2FsdGVkX18RySFsixUxzvCsbUwADZQGbWalccdw5mA7knHnXR4f1xIgtwyqPJo+EBUdFI/Eh9JfJwu5+kQ0M6R8iT91py/TbP8iiWeLuxyAxeEpKX8MnipivmTzPLHuymkVhDNp8RavsQSQQuZYsg9ychW10zPe7vmf4846aNzrGDx4aiezvapXZ9NhgVWyykh8XiGSy2id+2XSY3PApOm511t6qnmzdZgZGamaiTdE5qBBKUHsGsQhAJd3riJp0ZH1jwhNaaLtTLE37V6B+Vl+rZBmPjvtiUYcI5YutZARGKufWFHn9kgcOR8us+3o1xK21IK2goWsY8hf1cRSWtnVlsZb9rVNPjR+loq2EvNItHUxmmPSzLttrc+cSKzhmrybcy3yoGOhYylBFHtVqQ3XzpnQtUfGwPaPkSAW8bGX8LnvbzBGgVChmyxBWuQF9e4g3pgYZ9Ai9MuNNypHqc04Hno45AHvQnvZNUpA8UT+2Dg5tM/M8zf91GXaP7U6uPcsbvWkJpUGYIIPtzag7f9Srje/P7P1Wohh3mpSBdzpZ3S3vZVbL2sox6NnZJP2uM6eCZ0vVYVuHGWtT9rTv2DP9HnS42LV8jvBibMSmw2C5gab5i3b2+ytref4gEUR7ZDVq4X2daXvVn9MO4UsmXnLil4aIH6n+Qn3zbQiX70EPQ9U+Y/kFFT8ak5rYgX9W7l70KZzTcys+ToJKGNGmITA5KHZjBaXNXhPd+0Ndg7vzl66gRuC0xqc3Yy4QLB9iJePRtNlXS+LaaijBX5nI8ZohOeSjG2bwHJ2Lhe3wrfnO9pIdoy/Ll9Q1dyiSdCyTdJmsfkF+uknlj7sPDhYrxNK0HdKm8PwPEW2MHYYvCBrJZ9SNKZ5Cuag4qbqjsMLPF33y0pH4BCutm3HiAqBHY4D56DFm7nt8cESgyL3IOYI+43PYqza004qXq8+u8+r6vvy8Kbffboy0zzxyHE
 pxHD2Afi
 Tfv3x+FYD+V3RK5VUzzP3/P4wxHs7iuAHwvumMPzVDtpGva+dZ8QxSU1P8NgufSCp1ceua+95z7MPuIiQphJtMV1FlV/bdoiqa/M6Bx9m384NYPN9YQ35PTbn80ibHSE3D9CNYZe0uudCrGH8tB8HE9bGzDDyrCidPrL2vY5rd/oNP69IR2RMCP9L5C/eMauLm9pLqw183PUm2+fysBJl+BVZfBQUzJB9YRw4Zw17TVexC/4qh3fdIUOWfCuYNJHArg4pEP9mq63phMK/rcn/S8JwfXY2yC/kRaNy+FIeHlIL5e2VgG3wzo8RT0PxQwGVnnruUoqPgoa7Wgiy8XTup9/pWrqI1Zt5dv7Y/i9f1M2Esno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_folio_init_vmemmap() currently splits the open-coded
compound-page setup across two helpers even though the tail-page
initialization is only used here.

Fold the tail-page initialization into the main helper and pass
the precomputed page metadata in from the caller. This makes
the initialization flow easier to follow.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 50 +++++++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3cb8fffb9e3e..950b0fa3bc27 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3126,33 +3126,8 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
-static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-					struct hstate *h,
-					unsigned long start_page_number,
-					unsigned long end_page_number)
-{
-	enum zone_type zone = folio_zonenum(folio);
-	int nid = folio_nid(folio);
-	struct page *page = folio_page(folio, start_page_number);
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	unsigned int order = huge_page_order(h);
-
-	/*
-	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
-	 * we must initialize them ourselves here.
-	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
-}
-
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-					      struct hstate *h,
-					      unsigned long nr_pages)
+static void __init hugetlb_folio_init_vmemmap(struct page *head, unsigned long pfn,
+		enum zone_type zone, int nid, unsigned int order, unsigned int nr_pages)
 {
 	int ret;
 
@@ -3161,12 +3136,19 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	 * walking pages twice by initializing/preparing+freezing them in the
 	 * same go.
 	 */
-	__folio_clear_reserved(folio);
-	__folio_set_head(folio);
-	ret = folio_ref_freeze(folio, 1);
+	__ClearPageReserved(head);
+	ret = page_ref_freeze(head, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+
+	__SetPageHead(head);
+	for (int i = 1; i < nr_pages; i++) {
+		struct page *page = head + i;
+
+		__init_single_page(page, pfn + i, zone, nid);
+		prep_compound_tail(page, head, order);
+		set_page_count(page, 0);
+	}
+	prep_compound_head(head, order);
 }
 
 /*
@@ -3226,6 +3208,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 		unsigned long pfn = PHYS_PFN(__pa(m));
 		unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		enum zone_type zone = folio_zonenum(folio);
 
 		h = m->hstate;
 		/*
@@ -3239,7 +3222,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h, vmemmap_nr_struct_pages(pfn, nr_pages));
+		hugetlb_folio_init_vmemmap(page, pfn, zone, nid, huge_page_order(h),
+					   vmemmap_nr_struct_pages(pfn, nr_pages));
 		init_new_hugetlb_folio(folio);
 
 		if (order_vmemmap_optimizable(pfn_to_section_order(pfn))) {
-- 
2.54.0


