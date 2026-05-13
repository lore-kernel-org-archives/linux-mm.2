Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06613CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3DD6B0111; Wed, 13 May 2026 09:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5256B0113; Wed, 13 May 2026 09:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA4B6B0114; Wed, 13 May 2026 09:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49A646B0111
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BD3B1A0109
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:42 +0000 (UTC)
X-FDA: 84762461364.27.34EA958
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2583E80005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jK1VmrOp;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JweoZhL4wX+SrFX5pL1+i9XjuzkUT4z611TUJKtW0N4=;
	b=ryM8nCIXlTIe5IDxijbnx2I9Z3yWn+sUrgV7xBHQqApHg6WvgP9/keV54jO4SQT4/3VA2c
	lfjc2qHrSV4uOtDe9B58LQDGSBE1fFzvWOk2knS9DdWoJ+5l25QXOHmwyQKrDDAooreXdX
	7wT13ZRgWjcEOG2tKhO52o53uz+eyv0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jK1VmrOp;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678560; a=rsa-sha256;
	cv=none;
	b=qFHcZiUZ69zborBvY2nHvqP5Gem4PzHmr+jVsSE66a7IDKt+CKMMvvTpRR7RllxppgCO8j
	eB1ElWaHWfTMTP00w7z14krFEwdhj6GojeU8ttyIlSi+NTZN8GqVC+IYGXMQCNGXt6hf/Y
	uWADDBOgZRCtz5ZviDEHjRnosgQIf7I=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-368977e33b1so1928966a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678559; x=1779283359; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JweoZhL4wX+SrFX5pL1+i9XjuzkUT4z611TUJKtW0N4=;
        b=jK1VmrOp+vXpLPBaPHBmtmNIh7xkYKOFWQhe+U0rOEeKBGCTvR68GlOJfoocM7uJxf
         wsmygrVDoJ0O9ZPtu1vms4BLjmeLtrE/6btikQFDiXP3CGu6vWBF+Wbk98JbSUrSRmO1
         ie415CFbNOmLqBLTHC3vmNPz5EnkfzF4I66vkbDiPLwwUuOb+kqgBXxXFFRQX3u/fADR
         NtpL32oj0lxikUienHK9gWy9QkR4946GitiO28m08VDlSWAmf+jst6t7h2nh9YLVHrRF
         uhIkyNzQb4ZvrxEbCvv0Uea1/MkGz2jlssyhLRo6hRquulkLbrpT8TvGuQLvYNDQsSWB
         yZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678559; x=1779283359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JweoZhL4wX+SrFX5pL1+i9XjuzkUT4z611TUJKtW0N4=;
        b=Q2n3TbcBNNlkv93AT0zwXUntLjKPlfnzdGmaq+fK/fP+ZLn4F7FisDzmJ0Hl7iov1J
         iUCeYwtivxav8aDRbJT9HTKOEr6qOHlO4Kl8AxSAXxxmytv+2mnv5wuS9PqI4ApSTpL6
         K9k/KsQKRkrF0kkldJX5onuWrOnB4eKMOIRziGTUK9WQCN6LT7VCC/V2SHFM5iXO4+jS
         pXutBDW4SYYT+juER0w1bimxqpr8hz/qZNYyFHRRvPLS43V4hbYniwMqdARAafUuS+0d
         yD5r+nPnTCAERRDGSS9Uv9qIbG2IJYzFvJTX7VCzEDFM1cSVTCdZIAT3uv/cTEb7Y6q9
         vLqQ==
X-Forwarded-Encrypted: i=1; AFNElJ+bsIaU7ltj58P7/PNfJPJV1MGGYUz66lUskSOyIguAAsxgmhOptgb0vRW7oNX7lrzlaubytiRV3Q==@kvack.org
X-Gm-Message-State: AOJu0YxYLp4MuWx5VvDVbgxK4wtap7dgzT1SynsY4hiH8u8UTMed/U3q
	IHsgNfWCTNeI9nPL+AhXRwzPKTxb1hijE8kWkuQHHSh7aDLvnLnSASZXbNJpkGCpilU=
X-Gm-Gg: Acq92OEfKNAgD1ulN/5UQZKl6KyHQk0QePiEwWBcyysyv4Ukqi3ReebIUgQk/PdE20O
	f7mOM3XJxGdE3/2GUCG9mK/5VoLvPjDMBgAOQF1uhCp97Nwv1U7ChZSQd8+zRqUny49l7jdyIiP
	G4Q7RHjUihPB1JslBv8t+O2bryrPAG9+aCvro+XOkWWpKMCzTvlR1GURlZwuIDaOl1RRrpzQtEM
	9tkoruzkSLnCQDeoOyTPijZOmzmfHL60Cz8g0UjrIbpliFMyFuuoSjjH41UfQ6CRinD4EnwmE4E
	+YI84NHFsB1kmIc7KPLWxf81rN9OCebR1nyL+fFmexZTYiVtGPgeYG7dPY5SelvckcxZW5NPhAy
	gzk1ypbvKVuDK5eUTtnX6IUntPdSMMHnPzE2I1bIcdF+a5FDpyKoNpYE+0UeBsXkl7YEAmM8JaK
	9qrPJIllyB1QWD8C8jropn5FpU7F5T6cXQmsWPWFU+UzBt8/jtrwtOffshh83S
X-Received: by 2002:a17:90a:fc44:b0:366:aba:4c86 with SMTP id 98e67ed59e1d1-368f3e62d47mr4012510a91.27.1778678558803;
        Wed, 13 May 2026 06:22:38 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:38 -0700 (PDT)
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
Subject: [PATCH v2 63/69] mm/hugetlb: Initialize the full bootmem hugepage in hugetlb code
Date: Wed, 13 May 2026 21:20:28 +0800
Message-ID: <20260513132044.41690-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2583E80005
X-Stat-Signature: 8wfu4ut7id7w5d16ginqitcmezxsbcni
X-HE-Tag: 1778678559-747188
X-HE-Meta: U2FsdGVkX1/TM4DH9+AZ/RJmgG8z5lPizdk/9/9WJD4Sbrr0MnY7DIUwg/ecLOZOcmH0n1D1SFbfndHbYVzeMaeg86aRM2b9HoRv9IfEXG5uDl1kSnjTxkdbd4hwh6ptJ/rbNu5SrYtxue92oTbWtiyYYM1pIgdsexrHoigIKv5CIYqUnvKKCY5BlDuUyCxNW+hBkJzZgwHcpw6LmomaFDjpZaf7cZlIn3c/gHs8tABaXibt0FXJNoqC2DE3t/MMaVOpKoaxLm+JxkazCckNKPNNvwEABDKyb/ldXts1qJKqkUCbeLEwoZKzQqnrk4bxSC5cvd5SztIh0GOZLl+Z1eAhLpZG17KwQX0l+CPWmxLhZJ+KUExmmCEQySeaF07l8xnXbrTJHFOCH++xu/El8AFZ9QVeV6XvuEia1D6xp2148Ws0hu6e81qGpbOjKMnyq6hFwaCCPk7SPpLkf0eA7C4JwixmBTTrTtfvEB33f4IB9BQsthXbeT8XOwdVYgTXmPw1VEJkaoKH2YXuHLv0m1Hgugvb/x4Am/giOz9x9tl/x8dO+B6fcrjYZnsLr9EWU42rD2nklrPKFilHj1hBxI82Qu7VRQakt8kepFHs3Pg+NaCQSRcUkf0ILXd3fWLlM7p0C1NGmMRvtMXKcio9Dlg35xSsDhKHUXoo7gF28ZM+0HmkpnHnf+3cxElo0cEupHQ+mr6FBOXtCJ5DruvHi24sKiPYBR7GOUS6ZNC53X7+WJKrla6+vnxSUYbCwil4Qn/gARkehsxug0zZsmUzvmOxgJCMAmqpJkRKQBE5md/x9txpjISg3xmcmRQBHQQK37jgfjkSkxsRkYJfF9kREpISu5rrzkvokQeRs379H5bzhCos/HlQv/V7zFQLvdwefwv6yq27+tbptr1babilwSlAco5Tla9df1yrZJhDeCinDQ+hkx7JSYbxwzdnDfXy9pRJKchIYNyOY6eblnU
 v1OT61Pu
 PI1N8sjRMU/Irff9Rgmt1f2vpy0gqYwRN38XFDERHZNIwNuAIFxNk5FG/anZ/egewFhCfSe/gdIeI6UDLF+Mybg7AFWU0KpEBMM4QJMjfGXOSLM+GOEqcDyCZpZvpZ012uTpiwkue0rYxcFgJO5pZkNSSa0HE+7INtCt58URZgqxddJwueUvZszmLb0av6CIkRBqllmr/O8BgM6qBcN192CJhqyXJTvCuSAo3aI7TcQ594SP3fFSQLc6wytYKfvXF/y7lBvU7JlltEhZJ9BUklym7Cp56SoPqfSRwDraapT7ykrpymVp/J40YR2w9xhQFpZzenRFb+kSdoLQ1gWkmM/plXmNBp9lfa7CJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Boot-time gigantic hugepages currently leave the head struct page to
the generic memmap initialization path while the HugeTLB code
initializes the remaining struct pages itself.

Mark the full hugepage noinit and initialize the head struct page in
hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
is handled in one place.

This can also reduce memblock metadata overhead when many boot-time
HugeTLB pages are reserved, because physically contiguous hugepages
can be covered by fewer noinit regions.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 950b0fa3bc27..10f04fa95d43 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3112,15 +3112,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
 		hugetlb_vmemmap_optimize_bootmem_page(m);
-		/*
-		 * Only initialize the head struct page in memmap_init_reserved_pages,
-		 * rest of the struct pages will be initialized by the HugeTLB
-		 * subsystem itself.
-		 * The head struct page is used to get folio information by the HugeTLB
-		 * subsystem like zone id and node id.
-		 */
-		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-				huge_page_size(h) - PAGE_SIZE);
+		memblock_reserved_mark_noinit(__pa(m), huge_page_size(h));
 	}
 
 	return true;
@@ -3129,16 +3121,13 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 static void __init hugetlb_folio_init_vmemmap(struct page *head, unsigned long pfn,
 		enum zone_type zone, int nid, unsigned int order, unsigned int nr_pages)
 {
-	int ret;
-
 	/*
 	 * This is an open-coded prep_compound_page() whereby we avoid
 	 * walking pages twice by initializing/preparing+freezing them in the
 	 * same go.
 	 */
-	__ClearPageReserved(head);
-	ret = page_ref_freeze(head, 1);
-	VM_BUG_ON(!ret);
+	__init_single_page(head, pfn, zone, nid);
+	set_page_count(head, 0);
 
 	__SetPageHead(head);
 	for (int i = 1; i < nr_pages; i++) {
@@ -3208,7 +3197,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 		unsigned long pfn = PHYS_PFN(__pa(m));
 		unsigned long nr_pages = pages_per_huge_page(m->hstate);
-		enum zone_type zone = folio_zonenum(folio);
+		enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
 
 		h = m->hstate;
 		/*
@@ -3220,7 +3209,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(page, pfn, zone, nid, huge_page_order(h),
 					   vmemmap_nr_struct_pages(pfn, nr_pages));
-- 
2.54.0


