Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3C0606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=RTy+8UZ6
Received: by kanga.kvack.org (Postfix)
	id DD71E6B05BE; Mon, 26 Oct 2026 22:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEF76B05BD; Mon, 26 Oct 2026 22:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7E56B05BD; Mon, 26 Oct 2026 22:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 840756B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD0461A0890
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:54 +0000 (UTC)
X-FDA: 85366893948.15.B34E3EA
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30B1240003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RTy+8UZ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 38xLgag0KCPYictgljmsefjglemmejc.amkjglsv-kkitYai.mpe@flex--kevinloughlin.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=38xLgag0KCPYictgljmsefjglemmejc.amkjglsv-kkitYai.mpe@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
	b=EX9Gu1V8skbioH/9S+Kn/1QLsdupSGURamJe7iw1COz92IhIrYgUlT8X9a1r68aDLnb10K
	64y6rQbQBCVcPtn1oEEygzNrplHD06qCFte4eOVil/yaa9EZgSXmhWYM4GfPa/WDIfdjlT
	sey7Kmw8bnh0Xduj3/6mPFqkOW4H+Cg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RTy+8UZ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 38xLgag0KCPYictgljmsefjglemmejc.amkjglsv-kkitYai.mpe@flex--kevinloughlin.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=38xLgag0KCPYictgljmsefjglemmejc.amkjglsv-kkitYai.mpe@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069813;
	b=4dzv7C8WJ6mgXjvV2BIN3/CF3j1qFePCaWMfOjF6AZOHRwr4+42z5pZb+HCiFYlE+Nbbp/
	FjFjqMZr8F71E45cJxndvcb37BTOGzXuJFc6bcIW6sXZZhKzwOaUA1N87rxWUOaWFsNnVO
	dgbYeERsvX4TPXAHjkxQddR8F2XULYE=
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-845156f593bso1940604a34.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069812; x=1793674612; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
        b=RTy+8UZ6ZmbiEruMTmKiNqhz1cnGsGGzXqBsLEd8WunK9+ityc58HChhOASxKeEiOz
         LRVxZxzI+twFcQxbk+qKKtlUL5tXrxUUqTW7no0+xS1J6o3ezeUV0K/iKR3D0MlRCegI
         CjL+KEkOvh51/9LrRWSdKik50CFDlJ3URtcVvmVw2xcDnp3JlY3lgoiE2ecN0LZTgwHe
         SGEMdk+wrtznoU0VUrulqJvTiRrxozWQo4lar08c9peyqkoDh+UhRnx3jVHZlfNmZ3rD
         o+IHngokOL9q6NS6IIgezEIIhUyBC0JV+8d7S2RSW1d3aDEbluD4duSrXZNU3fIrLC8s
         b8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069812; x=1793674612;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
        b=ooOmbtXitYjlAu5KmZJo/nckUs+hB4cBBrKz32t0IEwZ0yPRuzcioEq20Jlg1JcCEK
         96zssj5mvEqOUt3oYhY5ode4PgZ2zazshRhS1jXywPpcNUxpQQ2o1DW0IyJvrgR4hTBQ
         B/YkUJkRgB7bkgpMop4unJPRB0Wu4myhJsuXN1voBy0DTmSdyZD+5hcTWHDz1tdTlUes
         FCXUTpYCF291GI+uCSBJbqpyxFF/GG445xxxYNvseCA+QlqjHaWORnDU2Tp7r2pNDuZd
         JEYLoF9Qe+ULPZUG9kXnWjPkK0hI098IheCSsv0CjM7UqG6VNM+KY2aRAnvU/LOzi7HR
         G+Ew==
X-Forwarded-Encrypted: i=1; AKwUvBzrcgKM3zf6tIK2KZRF9G0781wDDA+kSi3iU6E8aDULBfoRFmTCcnp3eT4+kL/9M40DSqTGviRzEA==@kvack.org
X-Gm-Message-State: AFq9FYI9YobyZm5H6gjzEiB2K0YWSLavPJymvlt3NM2j7LX7HXW9zrxs
	6UKfvHh651qwCCvQa50VT6mkBqRrXGn0fZ49EGaeqqNTEqprqXWsXUVuAPcAZPvqRRDzy9FNzhJ
	YbznldsE/pXLM10JJyUUs9FD3a0uOXyd/5g==
X-Received: from ioaa4.prod.google.com ([2002:a05:6602:2084:b0:9c7:6772:c251])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1391:b0:6dd:25a3:94dd with SMTP id 006d021491bc7-70ba0e5707fmr4813315eaf.41.1793069811694;
 Mon, 26 Oct 2026 19:56:51 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:10 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-8-kevinloughlin@google.com>
Subject: [PATCH 07/13] mm/page_alloc: allow lower-order unaccepted_pages
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 30B1240003
X-Stat-Signature: zokatrc4upbam5kc9zidzkkhjbm7fhoq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069813-212496
X-HE-Meta: U2FsdGVkX1+oYc1FImv6Asvb2QUq1zVrHbOCfxpYPMRQ5Goa7wRjyrKYHU5F5iZBFHcs5gez1hlMAEDZZdpwJ2pKHEBO5XWxi4beAB91uLvBTZEmxNemHw2rPjL6nPAaWC4V0vIPe6BwPqnKXRmi+QI13nPaEt7Iq7Hm3Wttvdq1E2HBTrCh8RIJ+AL6LKrsvsjXP9xt1eKzc5sG5qpqvAD6yqvBS6FjpuGWQCW1nbSfxrDXrECetiNQT91YC5JRtVS7yyHVrbPGQdgHa0wqO1Wpwz8QnTnoIGu/6pBe45sZHjsfAbFw/3J+lavHupn8jSADq/qU6PxTnOvh55NhYml1byUM9o2mXLxC4ItBxnsLOgWHZk8IdfIcRMG2H5Mo+M1edeRv4cOnBpGuIc9yFQEk61hwBm96xPpMfHrANnANw6y/Dx6GL9pzVahZUNtEUhXXYl4wPqsgXKZMNxXzZ8SGSKSAOmhzMNuvtFujyusVNPiix3ErOXBahRFgx7F6fqgfWHnTmLAoxuwf+8Lsoco+IFadLIH81TSj5ljuH45xRPduQPrdahXg3NOm4UwVBc2PzYVDlWZWFiWMUyACQYT6tc297oPerTA0w8pmvH6rdu5TnhQLNCuGAhaB/Nm1z4FNf86bvRJS4Mw8L70OCUiN3V5n6fBAQEd6BiVFHknVa+fiMiK8qwhzvRzRSMu1G/M6jTpxGD23t1QqnMMEs1FIg70NKc/EtN2A/nVaxT9/9ESSoVsJQaH2SfPGivqtY8vDT7lBSEtHXgm+TXM7mFJCfhwtcpdgj/F6ufP+gbxVQNlLDmlxW53JatK8vyixBlZCp26hLjqFUXVya9TnPm3May15BM7bNNVJP2OInjG57v/9By2dDAGdQFqmZVe7+BJoXW5wu6lTYRMGjZycUIfG556uF2g5ra7svr7AIbDiD1KxrTcg3X4zKOfeJVl52RAJ43O1uRt1T5EsDZD
 ZDlREEUa
 xHnk4YJC51Pn26fByVmUE0OCTMvccxjOtbb0PG/viH0hAEV3exnorzdzYwi2kBW3iFzsVlbWRNW1n+ic2/e7ikBegwzcHseRtl5B+ITfzjKh6nWXTa4oOl37zsYL9753b4qF8q1apK4oT6ONx0BK6iJxoMMayPvl5YqXsoshB5oSx8woH3nk/zDCP4k5ovE8PcAskk3T72O3vFkq4yXW0uLxGduzB1TPcXYQX+KjWeqeF5AZPzkjLA0f1AsC0qGu+G67m0kinF+MHukjAWJEZTB95UrGR6Ve6QoHkQN1GsXMqnnPlt7aO3m0A9AUUc4qf6helwQ0ltyIBUL6O3qv8f46WjOYG10asA/s4O4D0tQSm0yGL3qLHnf2f16yyumfpcLhln3MaImJUY14RR8LZiOMqrIhzOX+BrqEpoPma+JWxajWchVt+eJYFVgoObld3IRzjJA0jxTgFQP4XKzQSuzuw839SSkpj5pDIPxkbzXOq+Fpwj/1sqKCZ+FHKM/IOGOqyXbQX8Ba8P0tUjd5GZ74p1KrIf8ug6CIwSOH4gnJo36AeqP1k+usn4wDji8jiEzrXGYVjAUbvB5sNf6mgdTj8yCi7877TAFFAZHN6dQSenJDkpvld1iNYHoFioRm+esh5q25eLHnxm1U2yrWu5KU2biSDSocAuVg/QwwEpDiZioRKsrxC2ZnMqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, zone->unaccepted_pages assumes all unaccepted blocks are
MAX_PAGE_ORDER. However, dynamic memory unacceptance operates at
unaccepted_memory_order() granularity (typically 2 MiB / PMD_ORDER on
x86).

Introduce has_unaccepted_memory() to report whether lazy unaccepted
memory and dynamic unacceptance are active (returning false when booted
with accept_memory=eager), and generalize zone->unaccepted_pages from
MAX_PAGE_ORDER to orders >= unaccepted_memory_order() stored in
page_private(page):
- Update __free_unaccepted_locked() to verify that pageblocks are
  mergeable (moving blocks >= pageblock_order to MIGRATE_MOVABLE) and
  record the block order in page_private(page).
- Update __accept_page(), try_to_accept_memory_one(), and
  cond_accept_memory() to accept blocks of order page_private(page),
  and ensure cond_accept_memory() accepts at least (1 << order) pages
  when high-order watermark or rmqueue checks fail.
- Update prep_move_freepages_block(), set_migratetype_isolate(),
  isolate_single_pageblock(), and skip_buddy_pages() to handle
  variable-order PageUnaccepted blocks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 Documentation/mm/physical_memory.rst     |   3 +-
 drivers/firmware/efi/unaccepted_memory.c |   2 +-
 include/linux/mm.h                       |   6 ++
 include/linux/mmzone.h                   |   2 +-
 mm/page_alloc.c                          | 127 ++++++++++++++++++-----
 mm/page_isolation.c                      |  44 +++++++-
 mm/page_owner.c                          |   7 +-
 7 files changed, 155 insertions(+), 36 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 2e67e8b23a99..e9fb554932d5 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -526,7 +526,8 @@ General
   ``zone_init_free_lists()``.
 
 ``unaccepted_pages``
-  The list of pages to be accepted. All pages on the list are ``MAX_PAGE_ORDER``.
+  The list of pages to be accepted. All pages on the list are at least
+  ``unaccepted_memory_order()`` and record their order in ``page_private()``.
   Defined only when ``CONFIG_UNACCEPTED_MEMORY`` is enabled.
 
 ``flags``
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 128bc1b113cd..769faf430690 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -246,7 +246,7 @@ int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
 	unsigned long flags;
 	u64 unit_size;
 
-	if (!arch_has_unaccept_memory())
+	if (!has_unaccepted_memory())
 		return -EOPNOTSUPP;
 
 	unaccepted = efi_get_unaccepted_table();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27bb40651c85..619c71565dd6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5362,6 +5362,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+bool has_unaccepted_memory(void);
 unsigned int unaccepted_memory_order(void);
 int mark_memory_unaccepted(phys_addr_t start, unsigned long size);
 
@@ -5377,6 +5378,11 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline bool has_unaccepted_memory(void)
+{
+	return false;
+}
+
 static inline unsigned int unaccepted_memory_order(void)
 {
 	return 0;
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d44b04589f48..ae4657dbb5a8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1112,7 +1112,7 @@ struct zone {
 	struct free_area	free_area[NR_PAGE_ORDERS];
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
-	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
+	/* Pages to be accepted. All pages are >= unaccepted_memory_order() */
 	struct list_head	unaccepted_pages;
 
 	/* To be called once the last page in the zone is accepted */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3322f9e75616..46ae8c6f3814 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -300,8 +300,10 @@ static unsigned long alloc_stall_warn_jiffies = INITIAL_JIFFIES;
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags);
-static bool __free_unaccepted(struct page *page);
+			       int alloc_flags, bool force);
+static bool __free_unaccepted(struct page *page, unsigned int order);
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order);
 
 int page_group_by_mobility_disabled __read_mostly;
 
@@ -1614,8 +1616,10 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
-	if (page_contains_unaccepted(page, order)) {
-		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
+	if (range_contains_unaccepted_memory(page_to_phys(page),
+					     PAGE_SIZE << order)) {
+		if (order >= unaccepted_memory_order() &&
+		    __free_unaccepted(page, order))
 			return;
 
 		accept_memory(page_to_phys(page), PAGE_SIZE << order);
@@ -2003,6 +2007,13 @@ static bool prep_move_freepages_block(struct zone *zone, struct page *page,
 				pfn += nr;
 				continue;
 			}
+			if (PageUnaccepted(page)) {
+				int nr = 1 << page_private(page);
+
+				*num_free += nr;
+				pfn += nr;
+				continue;
+			}
 			/*
 			 * We assume that pages that could be isolated for
 			 * migration are movable. But we don't actually try
@@ -3872,7 +3883,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			continue;
 		}
 
-		cond_accept_memory(zone, order, alloc_flags);
+		cond_accept_memory(zone, order, alloc_flags, false);
 
 		/*
 		 * Detect whether the number of free pages is below high
@@ -3897,7 +3908,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			if (cond_accept_memory(zone, order, alloc_flags))
+			if (cond_accept_memory(zone, order, alloc_flags, true))
 				goto try_this_zone;
 
 			/*
@@ -3934,7 +3945,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 			return page;
 		} else {
-			if (cond_accept_memory(zone, order, alloc_flags))
+			if (cond_accept_memory(zone, order, alloc_flags, true))
 				goto try_this_zone;
 
 			/* Try again if zone has deferred pages */
@@ -5216,7 +5227,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, alloc_flags, false);
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
@@ -5225,7 +5236,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, alloc_flags, true))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -7867,6 +7878,7 @@ bool has_managed_zone(enum zone_type zone)
 }
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
+#include <asm/unaccepted_memory.h>
 
 static bool lazy_accept = true;
 
@@ -7884,25 +7896,45 @@ static int __init accept_memory_parse(char *p)
 }
 early_param("accept_memory", accept_memory_parse);
 
+bool has_unaccepted_memory(void)
+{
+	return lazy_accept && efi_get_unaccepted_table() &&
+	       arch_has_unaccept_memory() &&
+	       unaccepted_memory_order() <= MAX_PAGE_ORDER;
+}
+EXPORT_SYMBOL_GPL(has_unaccepted_memory);
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order)
 {
 	phys_addr_t start = page_to_phys(page);
 
+	/*
+	 * Unaccepted memory is tracked and freed in blocks of at least
+	 * unaccepted_memory_order(). Skipping lower-order frees avoids
+	 * acquiring unaccepted_memory_lock on normal page frees.
+	 */
+	if (!has_unaccepted_memory() || order < unaccepted_memory_order())
+		return false;
+
 	return range_contains_unaccepted_memory(start, PAGE_SIZE << order);
 }
 
 static void __accept_page(struct zone *zone, unsigned long *flags,
 			  struct page *page)
 {
+	unsigned int order = page_private(page);
+	unsigned int nr_pages = 1 << order;
+
 	list_del(&page->lru);
-	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
-	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
+	account_freepages(zone, -nr_pages, MIGRATE_MOVABLE);
+	__mod_zone_page_state(zone, NR_UNACCEPTED, -nr_pages);
 	__ClearPageUnaccepted(page);
+	set_page_private(page, 0);
 	spin_unlock_irqrestore(&zone->lock, *flags);
 
-	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
+	accept_memory(page_to_phys(page), PAGE_SIZE << order);
 
-	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
+	__free_pages_ok(page, order, FPI_TO_TAIL);
 }
 
 void accept_page(struct page *page)
@@ -7920,27 +7952,29 @@ void accept_page(struct page *page)
 	__accept_page(zone, &flags, page);
 }
 
-static bool try_to_accept_memory_one(struct zone *zone)
+static unsigned int try_to_accept_memory_one(struct zone *zone)
 {
 	unsigned long flags;
 	struct page *page;
+	unsigned int nr_pages;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	page = list_first_entry_or_null(&zone->unaccepted_pages,
 					struct page, lru);
 	if (!page) {
 		spin_unlock_irqrestore(&zone->lock, flags);
-		return false;
+		return 0;
 	}
 
+	nr_pages = 1 << page_private(page);
 	/* Unlocks zone->lock */
 	__accept_page(zone, &flags, page);
 
-	return true;
+	return nr_pages;
 }
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags)
+			       int alloc_flags, bool force)
 {
 	long to_accept, wmark;
 	bool ret = false;
@@ -7957,7 +7991,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 	/*
 	 * Watermarks have not been initialized yet.
 	 *
-	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
+	 * Accepting one block to ensure progress.
 	 */
 	if (!wmark)
 		return try_to_accept_memory_one(zone);
@@ -7968,32 +8002,62 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));
 
+	if (force && to_accept < (1L << order))
+		to_accept = 1L << order;
+
 	while (to_accept > 0) {
-		if (!try_to_accept_memory_one(zone))
+		unsigned int accepted = try_to_accept_memory_one(zone);
+
+		if (!accepted)
 			break;
 		ret = true;
-		to_accept -= MAX_ORDER_NR_PAGES;
+		to_accept -= accepted;
 	}
 
 	return ret;
 }
 
-static bool __free_unaccepted(struct page *page)
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order)
+{
+	unsigned int nr_pages = 1 << order;
+	unsigned int step = max_t(unsigned int, 1, pageblock_nr_pages);
+	unsigned int i;
+
+	lockdep_assert_held(&zone->lock);
+
+	for (i = 0; i < nr_pages; i += step) {
+		int mt = get_pageblock_migratetype(page + i);
+
+		if (!migratetype_is_mergeable(mt))
+			return false;
+	}
+
+	if (order >= pageblock_order)
+		change_pageblock_range(page, order, MIGRATE_MOVABLE);
+
+	set_page_private(page, order);
+	list_add_tail(&page->lru, &zone->unaccepted_pages);
+	account_freepages(zone, nr_pages, MIGRATE_MOVABLE);
+	__mod_zone_page_state(zone, NR_UNACCEPTED, nr_pages);
+	__SetPageUnaccepted(page);
+	return true;
+}
+
+static bool __free_unaccepted(struct page *page, unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
+	bool ret;
 
 	if (!lazy_accept)
 		return false;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	list_add_tail(&page->lru, &zone->unaccepted_pages);
-	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
-	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
-	__SetPageUnaccepted(page);
+	ret = __free_unaccepted_locked(page, zone, order);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return true;
+	return ret;
 }
 
 #else
@@ -8004,12 +8068,19 @@ static bool page_contains_unaccepted(struct page *page, unsigned int order)
 }
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags)
+			       int alloc_flags, bool force)
 {
 	return false;
 }
 
-static bool __free_unaccepted(struct page *page)
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order)
+{
+	BUILD_BUG();
+	return false;
+}
+
+static bool __free_unaccepted(struct page *page, unsigned int order)
 {
 	BUILD_BUG();
 	return false;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..c85ce158a646 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -165,6 +165,36 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
 	return NULL;
 }
 
+static struct page *find_unaccepted_page_in_pageblock(struct zone *zone,
+						      struct page *page)
+{
+#ifdef CONFIG_UNACCEPTED_MEMORY
+	unsigned long pb_start = pageblock_start_pfn(page_to_pfn(page));
+	unsigned long pb_end = pageblock_end_pfn(page_to_pfn(page));
+	unsigned long start_pfn, pfn, step;
+
+	lockdep_assert_held(&zone->lock);
+
+	if (list_empty(&zone->unaccepted_pages) ||
+	    unaccepted_memory_order() > MAX_PAGE_ORDER)
+		return NULL;
+
+	start_pfn = ALIGN_DOWN(pb_start, MAX_ORDER_NR_PAGES);
+	step = 1UL << unaccepted_memory_order();
+
+	for (pfn = start_pfn; pfn < pb_end; pfn += step) {
+		struct page *cand = pfn_to_online_page(pfn);
+
+		if (!cand || page_zone(cand) != zone || !PageUnaccepted(cand))
+			continue;
+
+		if (pfn + (1UL << page_private(cand)) > pb_start)
+			return cand;
+	}
+#endif
+	return NULL;
+}
+
 /*
  * This function set pageblock migratetype to isolate if no unmovable page is
  * present in [start_pfn, end_pfn). The pageblock must intersect with
@@ -175,10 +205,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
+	struct page *unaccepted = NULL;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
-	if (PageUnaccepted(page))
-		accept_page(page);
+retry:
+	if (unaccepted) {
+		accept_page(unaccepted);
+		unaccepted = NULL;
+	}
 
 	scoped_guard(spinlock_irqsave, &zone->lock) {
 		/*
@@ -189,6 +223,10 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 		if (is_migrate_isolate_page(page))
 			return -EBUSY;
 
+		unaccepted = find_unaccepted_page_in_pageblock(zone, page);
+		if (unaccepted)
+			goto retry;
+
 		/*
 		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
 		 * itself. We just check MOVABLE pages.
@@ -383,7 +421,7 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		pfn = page_to_pfn(page);
 
 		if (PageUnaccepted(page)) {
-			pfn += MAX_ORDER_NR_PAGES;
+			accept_page(page);
 			continue;
 		}
 
diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..e3f3a019b0bc 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -459,10 +459,13 @@ static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
 {
 	unsigned long order;
 
-	if (!PageBuddy(page))
+	if (PageBuddy(page))
+		order = buddy_order_unsafe(page);
+	else if (PageUnaccepted(page))
+		order = READ_ONCE(page->private);
+	else
 		return false;
 
-	order = buddy_order_unsafe(page);
 	if (order <= MAX_PAGE_ORDER) {
 		unsigned long new_pfn = *pfn + (1UL << order);
 		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
-- 
2.56.0.307.g5fe7bd680c-goog


