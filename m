Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11AE606D838
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=T3IUmmdY
Received: by kanga.kvack.org (Postfix)
	id 6D7966B05CC; Mon,  9 Nov 2026 04:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B06A6B05CD; Mon,  9 Nov 2026 04:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F5B6B05CE; Mon,  9 Nov 2026 04:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 376446B05CC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0CDAA0629
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:37 +0000 (UTC)
X-FDA: 85415131074.02.484C39E
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D86D1C0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T3IUmmdY;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfA30H/txJV+HpefZi3v7n91I++R4neLp2SsCFAx8tg=;
	b=ma+e7hR+5XVvBvBt3OTZ1KMAboD6erp2Xs7N/RWO+J7tMdw9db2FnVyHyamGi07bPdCZEl
	GhZS5BKZ+I2gdyZa//VWRVzRYed/eXa1N3ki/DvYNRylT4PuXKLubzAmJdUzhLDNyVizUr
	U7UXeNFBbHNzGLEhe7znYv7z+cWFLWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218316;
	b=C3huurrtPi+V3QuhpB+1SKV0xaXw2MBz+4XiXUbgtATuL6l/yxTZnnOJPeCaSIIbUJlUH5
	qIqs8SnPo9/5RI/nXFiOrx4Tpmmn31vtoM68kX/0VIF3lcPDvIO1s5VB2I6GG6l6yPaVbL
	ZB/mdzkVF0o9SVEhvVfAVv+kCEByLL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T3IUmmdY;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-170135e43c7so949623c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218315; x=1794823115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NfA30H/txJV+HpefZi3v7n91I++R4neLp2SsCFAx8tg=;
        b=T3IUmmdYbFlsEQmgvnLEQu6mNm/0PE/jwV9nfskQ1KbO7bGGCXOwKpJlTgUxRQsshX
         tS/jsuae0czTspbZWmocC0P7mU+i71q7Y64TkyN+gvwE8z/sooQ52SVfE6Ncdi7mOWB4
         OkoXcidbIIGi2CR4KFXtOvGuImJNYA2frZfsoAVK/mO9L8fsQqkW1beGE8ZS9kprx5pF
         GmlLq3817r23zQhNACc6mIJtfdaeV/KKlZYToWmdvDNq4y/8lYgdbHOw9PUIuuB3u7oC
         1IWBCvEaXODtY5/U9nCGHX+f/htt82Co9MM9EjmrzeKeSsTNUum3bG6c0IJVx+N5x9C2
         7ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218315; x=1794823115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NfA30H/txJV+HpefZi3v7n91I++R4neLp2SsCFAx8tg=;
        b=lguHYDxfAYXhxk1vvSBJMfxMTSYUYCjL/9IqzEp4dTdWA3jorecNPvaqP5tX77nzb8
         eDyrYadKVFrfP/DCehq5e0H72+u9NZ9RUYsm3N88PYDUJTx4envBXKEUykmVkfH01y9b
         drHChapcpgYHYM4ak8iOTbZaEaugaLfG4dhW52Us5qaSvA3WIVjJOxeD4ynBBA1sItPa
         P2xCDOmu/8v92ncxCPrnrCADoqHu/JW8lsGCeuFfQ3CwHvW/cbxhQG1JJBfbzaEYgIGn
         Gjlsi+SmkdIQ869a1MAhJXQZfv4BLFufo4XEE6/ga9DYUf41yag9Mf62eTmYKVO2+jEi
         Ghyw==
X-Forwarded-Encrypted: i=1; AL+hErGsM70cxgtGHPHv8mOKNCQA3mpjg7D4vQH8UUhheG7cWWPieZvSl+bZRGJ0MuXwUI/3LonvimAdgQ==@kvack.org
X-Gm-Message-State: APuU4Z8kO0A0ZVA2dMYcPAefDmYEjUJ+VzlzqgXNB1aWySVmV/rkNkeC
	BwH3TqmF4TukasZwLFDaJL3mFpT9TOO7Xo7KA7EMlIaWFytzfIQ9t/DS24AiARS/ZReV3lzPgmu
	mTmT+YFM=
X-Gm-Gg: AYBFou3Fh1R42bsf9qwAmDFTskU22vKjqADtlOCJsodfo8D+Irb+RW0KPxJTHmqf3RA
	+0RByE2CPgNSdynvuRj7+4j//aCGXYiPuoruvwrpkB1YK+eds/iFtfyxDxu1a5jc6l/0zQLB1/w
	UkHuOoZ8AZmkXRij+WhGo7VgMVY8uNVsXIgimObYkM/dyZUaWgvWzJOxqnHIGAbpcGlMNAnMMGJ
	cNUzZIFSpKQSBH/JaD6I5/OSPvAG5nr1VfQp7EqJj60W3K/rKz+EjWTlBo2FeV1tJkMdP6L6Mb8
	IJCPnbGKk45rOH1Efu2NAUxS0Mks9uzkXHzUaLpGqfUSNafmaP7xq2lnsq8kmji338djb7PuaTl
	egY1EcpK3x/qw6I55VROEaFSCpzHCdkH71sNVzAQdwmt4Ucb01g/nKhYsW6EUcUxzp4eOfGB7WW
	wzB8hZToUt+j9w20REptQNFLAhaP0d18z+5FFI+5em1hRf7CekpeRC6j4jz4WdafOzKBhWBvwAh
	flqH98oBMhU7BGCsRiRpL1G0aGMS+Te2FpyYGs6f/oo/wpfO7KKkJ42Cct1Etumkl8b2nuLL3gX
	6c62n7Z1VtZrFnNnWd4zjVhbq18fy7ZK4Hq6ppVOoTLE6JCQ+BA5zjII7XwTnQ==
X-Received: by 2002:a05:7022:ea8c:b0:1ab:faad:cc9 with SMTP id a92af1059eb24-1b39fec8ff1mr6278580c88.11.1794218314588;
        Mon, 09 Nov 2026 01:58:34 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:33 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 04/11] mm/mm_init: factor out frozen compound page initialization
Date: Mon,  9 Nov 2026 17:57:59 +0800
Message-ID: <20261109095807.41547-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: okpk3ep5c4bnpsd74c9pftqhwnj8wita
X-Rspamd-Queue-Id: 0D86D1C0007
X-Rspam-User: 
X-HE-Tag: 1794218315-96263
X-HE-Meta: U2FsdGVkX1+8W9+Ap25ykbF69tEwNxLGZGTqOGiOM2YLfKJxHDm2WFAxm7VOP4WmN3CfNjuj6zRz5G9kCOGHGsHoNndBZL4RQvNLbKrULk9H7Zwhqj7hKNHv+gr+I2O0JG12SxMrearmwyW6X4Xxf420WTtWCDYe2dyhqdSdeTyIEHNmnOTTq7y4Yda/zH+KIkJ9PSy+vx6+oHziOuAmHbeT128iZS0oIV/k4rbrK5l1EFcX4OTwA2pk5qI1I4YRtVQh4x70r9VfC0tXmDBKTLx/nw4hHlKclEy2McHJye5CrV8ek1/v3TTzTJIgakCM7MVE7ueler3PT2CxieP1xoP4ITJ2tnmIPjE/dQnoSBkGUc4TYQmCCuzL2eDB3Z8GVm4tkua1trfpakF/KI2ajwhWM4HN1MnSVHt2hWMFTMPfBy6b0HsHgOpbtM/krgl+jT6Rd9OcbTTwGH9ndqyp7Kjx7FQ2MaXRwJ1DgAkCNAHCpeD8Vgl73WI3NhVjDyqHGg55LIPljnpic4rKhkdzO4ENxPZ68wLGdHyTHSa0tBmOt91dOo6jlpOC+M3cn0VVzm2yPPAdH0FLhRwlc2CNQ/nlBBg3jADnvA+wcaCGQ6/A0Wf/8A+BslxmQrTDSOaJPUYTI9QYXeczi1Uw8+q79YgCV1rJpL/yucsDH//z+A54l8tqenycs8HnE29D/NNmlwfcDbRMrQD/OSmvwGDZ7sMo9SwGZDiIbJME+EFTPle+i1fuzRr465nZh2BgjehelFy2fiosayVOTECtu4jU82xDSuIxdjuugVH8NXgKpxALhna2iS+Ch0vtK+gapxYe/k85FuxXjed2EDV8Hj6gG8A4l8Hu1ycUZWTu3xvRb2vsb1mARL+09eR8zEL/PLPbZiePOnkTt8hUVn7JhYt1s2+jzwcCGd8bnmtXdBbrioXtk08mZ2K+rPp73ODrpPTA15obqhaz3YtT9y5CEQp
 ZHBYTefx
 WhNiSZvqQQInFq6km9Ybjw3O5W+rAoi659ktk+h9qnJ5z86V6iRqM8KSQo6qQXuwpqsqufhZgAR5uTzjDN3BtW5cX9ptBa48BhH/5xpNxmSb35swyAk/X/NkFzJAa9tyyAYGr/LHagSUmH0uMwJExCUt3/ldmISPQXkHY5Twx5MRS+xzcRjWyGgxUMDfLtaJHmvlR6cqZXPt9+f9X7o8s3PmZcQlD+c+9hOdAAk5BCaXiiMB6jwCxI6aWv6ZUHNr+V1lpgFCDGOpy/4NJjwsW8oiiOzF/OAwQAtrHRuN7owrXATxwP6/WCx5JJDen11k6j+4WwDmer0vSM1gdWQ3dOfPY9gOZ1rfNVlKyl3/OypnF0p4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE initializes compound struct pages while their refcounts remain
frozen. The setup is open-coded in memmap_init_compound(), including the
per-page initialization and compound tail preparation.

Factor the common setup into memmap_init_compound_page_frozen(). Keep the
pgmap association and MEMORY_DEVICE_GENERIC refcount handling in the
ZONE_DEVICE-specific path.

This provides an MM-internal helper for other early memmap users to
share.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 137 +++++++++++++++++++++++++--------------------------
 mm/mm_init.h |   2 +
 2 files changed, 70 insertions(+), 69 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6cf74f6840de..458496271a44 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -719,6 +719,40 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+static inline void memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, const struct zone *zone, struct page *template)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone_idx(zone)))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
+}
+
+void __meminit memmap_init_compound_page_frozen(struct page *head,
+		unsigned long pfn, const struct zone *zone, unsigned int order)
+{
+	unsigned long nr_pages = 1UL << order;
+	struct page template;
+
+	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
+	prep_compound_tail(&template, head, order);
+
+	/* Initialize the head page. */
+	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
+	set_page_count(head, 0);
+	__SetPageHead(head);
+
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+	/* Initialize the tail pages from PFN-independent template page. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
+	prep_compound_head(head, order);
+}
+
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1044,56 +1078,38 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
-{
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-	vmemmap_optimization_verify_zone(page);
-}
-
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct dev_pagemap *pgmap)
+static void memmap_init_zone_device_head_page(struct page *head, struct dev_pagemap *pgmap)
 {
-	const struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
+	/*
+	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
+	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
+	 * @head may be a stack template, while init_page_count() expects a
+	 * memmap-backed page.
+	 */
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&head->_refcount, 1);
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
+	 * and zone_device_data. It is a bug if a ZONE_DEVICE page is
+	 * ever freed or placed on a driver-private list.
+	 */
+	((struct folio *)head)->pgmap = pgmap;
+	head->zone_device_data = NULL;
 }
 
-static void __ref memmap_init_compound(struct page *head,
-				       unsigned long head_pfn,
-				       unsigned long zone_idx, int nid,
-				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+static void memmap_init_zone_device_basepages(unsigned long start, unsigned long end,
+		const struct zone *zone, struct dev_pagemap *pgmap)
 {
-	unsigned long pfn, end_pfn = head_pfn + nr_pages;
-	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
 
-	memmap_init_page_common(&template, zone_idx, nid);
-	prep_compound_tail(&template, head, order);
+	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
+	memmap_init_zone_device_head_page(&template, pgmap);
 
-	__SetPageHead(head);
-	/* Initialize the tail pages from template. */
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
-	prep_compound_head(head, order);
+	for (unsigned long pfn = start; pfn < end; pfn++) {
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone, &template);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1102,16 +1118,11 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   struct dev_pagemap *pgmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
 	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
-	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
-	int nid = pgdat->node_id;
-	struct page template;
-	struct page *page;
 
-	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
+	if (WARN_ON_ONCE(!pgmap || !zone_is_zone_device(zone)))
 		return;
 
 	/*
@@ -1129,32 +1140,20 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
-	memmap_init_page_common(&template, zone_idx, nid);
-	page_folio(&template)->pgmap = pgmap;
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
-	 * path. The remaining ZONE_DEVICE types start from zero here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	if (pgmap->type == MEMORY_DEVICE_GENERIC)
-		atomic_set(&template._refcount, 1);
+	if (pfns_per_compound == 1) {
+		memmap_init_zone_device_basepages(start_pfn, end_pfn, zone, pgmap);
+		goto out;
+	}
 
-	/* Initialize the head pages from template. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		page = pfn_to_page(pfn);
-
-		zone_device_page_init_from_template(page, pfn, &template);
+		struct page *head = pfn_to_page(pfn);
 
+		memmap_init_compound_page_frozen(head, pfn, zone, pgmap->vmemmap_shift);
+		memmap_init_zone_device_head_page(head, pgmap);
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-
-		if (pfns_per_compound == 1)
-			continue;
-
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
 	}
-
+out:
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
 					 /* isolate */ false, /* atomic */ false);
 
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0df0644c703c..1560ac9e9286 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -113,5 +113,7 @@ void __meminit memmap_init_page_common(struct page *page, enum zone_type zone,
 		int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
+		const struct zone *zone, unsigned int order);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.54.0


