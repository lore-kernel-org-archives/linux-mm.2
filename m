Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60524FEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198686B00A3; Fri, 27 Feb 2026 14:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E706B00A4; Fri, 27 Feb 2026 14:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F323A6B00A5; Fri, 27 Feb 2026 14:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB0596B00A3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A16F71CC2C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:38 +0000 (UTC)
X-FDA: 84491228556.07.459B34E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A8EED1C0014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKGYoyE1;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnN40ZnqKJJ5gv4Vyh4oOqoQu8mQOg8wC/Auhlap+Rc=;
	b=RUtirr48Mcqf+BNY5J2cFkNUG76W8LHeumROnJndRSe/Y+JLL4SD362jOq4k2Rb1iNV9Sl
	WZ+hdeSlSLs6eRk9fEWslXS8xV/eI7dbiTLsusBrlZWHM90XxgaDU07TK4/RE+xDEpBrGP
	1ml5TPR6s9r+HBFxkQ1BGxsHpZQDtko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220636; a=rsa-sha256;
	cv=none;
	b=TImeJ7Nv4zx3hFWf5MotqY6/KEI83/DiYS8rl0h0JdYmJdl/M0x7+5N6m3TcZe5UxAC0ht
	BuZpm7wv1Y+R8R7ea+rBoFAuGb8CBsJH8m/AyvGXFvwiH0qh+3bO6tJodGaCPebDqqHjJd
	15tHNzsX8dIb4EHECbAoqa2AYiXG50s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKGYoyE1;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1777560133;
	Fri, 27 Feb 2026 19:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37501C4AF09;
	Fri, 27 Feb 2026 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220635;
	bh=Xoy0vcEmhS4Ump5td/QMKdt1xxA3nwm83XumwZ2X0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKGYoyE1z1XAyMqpa74EsLG6EYVIjUvmiVJyBE2wwI3uUSAvWSB9fdQpDiYyfJIQY
	 J6vqZ17w89iNPaZPP7c1xntSM9O0+E4tMDgM19oBBxU8xdWNbbVyePNbUWpNDfvXhB
	 UfxXPXOS3Mc35i5sohEVZvmMxlSdOR1zbHAU9BYPdzU5vyB+3dpoDtng6m8W2a3Mp3
	 +b1aQpaOlPizvppdGzRcFWMKcALqFOe3gPoHWOPyJr3ORWU85gT7OYSQuSF7juZX1L
	 vQfuZKZTSu+vqzg3ZLsE8ftpovdsymLgOVzFOHG2gHlgKC+vHl9BuLPO3DPu5mS34a
	 TwHNE4OSb10xg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 532D3F40069;
	Fri, 27 Feb 2026 14:30:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 14:30:34 -0500
X-ME-Sender: <xms:2vChaY5L9MjAoPE7z_5dm3UJXhDZStrq_JfeZGyMcBPVKU2PVkN_XA>
    <xme:2vChaaodpNFaxGJeJ_24X4NZQTdGhDqSjaK0a5Dn8QGS4Y-fIA4jgIIC0P8fZ5GS4
    sxgd--XPCUUjJQ45RDDS5WGkR0girTGmdS-3s_wHcd23j9cN-eRP5fC>
X-ME-Received: <xmr:2vChabScNA6RpbAd2yVYF1peZL0G_mi-gRGpMQSUVdEK7IgSpa4IP-x9pV-Zfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:2vChaeseOjl4bgrlZ9mKYudmiKiePRxwh_MMspdVlXkmYfbPJab-nw>
    <xmx:2vChabM_sI-mYTeB2f4DWIApHr5airkQEmEPbTXeHHuIR_8o5iBI0g>
    <xmx:2vChaYUXvF2T-kQuVVKYil2Ueo32Aue08vimp0mY8tluA7eZE-LYZA>
    <xmx:2vChaTiDZuTa6OkhnRtx9j5CnYtwq-G5U_oYcB3AfK3iHD-EAMh83g>
    <xmx:2vChaS3a6mxZM7ovjehfNqKhWWgc8PgFtxY04XvWn6YtrDWI2-dieOGz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:33 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>
Subject: [PATCHv7 02/18] mm: Change the interface of prep_compound_tail()
Date: Fri, 27 Feb 2026 19:30:03 +0000
Message-ID: <20260227193030.272078-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8EED1C0014
X-Stat-Signature: hgwuq5agwzb1d83jhhikryqy5oz7a5o4
X-Rspam-User: 
X-HE-Tag: 1772220636-525538
X-HE-Meta: U2FsdGVkX1+7a0vBcHLQeEjqjrRLMHAMa2YpjzMKJwbHsewFoTjC2I1N7dSiteSgJL4QOLdjBiKpcUTEApnQf17rTipe5p+0BUPjPf9C4GBKiXw1ponjw1wZlIgdlwXJlHhcyZ1MsvVI4XqWeEjuNW6fp+SGgRDTxA/pZzv8s6PCeOCRsCGcc3VqYLGff8gASESxXZ3x4dpt0He7htBHbiNkWFsOkI82VO3gMK4vNYCVY4K6R8R8WzJb7qhoRLf8nuFxbkwSNuH9WX1fk+J9uw57ilYeUWeZCKLqLI8s3vULYd+Hpi7/vMEsA6vevB9wWXPWcRazYpngxbka/GCLSBb2dWxc1MFGU9pxgnexg7jVduUyWSAZTPsq8bDAzqnUOpQW/O/XPfzhc0QIadw8pRcVONOto4CTaqyVOV162+HbDvK5/CiysDYrJ3G8KLHk5wWg1MppyDde9YtR5dDYvjzbSTpV5Ci4V9pWWYtHoDKqott04eOvRpuWvU2F3V8I+mxmgr4oLy0wVwjeE61LQvViLnaPdMFObR99kGXiw7rXM6SiIaEZMsPkzaSVnU6jxQtsgdfhXEFw/WZW9dsPxjRYGAVEwhzwUG7cxg3gOI0q9YB63i30qzY6uEgLD5OcHryRFZpp5lSdsPzsIMxesJW7B5+k/ou4cmSTagwdZBJXjAU8RWq6LX9GRwhbAfAmzczJrdLcgxL6F1Y/biDU0Qxsh8DhIs2JUYHvHapjqvCU+eH5AbTKFHS9oUYnnCxU8zbPCbI2pRsyorv66qtaCNpgeG36kOYT+QKfD9n4RUUIK89Al7FtGvVE1jFDrQYTSzSu971e5B3NczSlrFLTcgcBbkZEovvpq5jwzTaqv1an2wBVZ88MX+o/jKkbS0uUThcWJJ2t5lGp/SN9lqF0aUSoYw6NrrN/mBNfbTqv5nbKYSggwB6l67oogOOSCVc2AYJBf90tuZPfqLQcFIo
 6zOAoeDm
 9SVq2ZffViy0J1MDDNEn14Cmc8gYCjlJU7hob4ECOMSwjgNOx5XvkofMqD6yheLhi3PXYrQJYbt2hgGHs79Ed1s+dcKNlqlFRLUN1Yb772RAIBlXNxXuF5Ek1QEywCRZ8zE6RDLUSCqyvdNdmDjeGaQnhQDD/81hvF2186566px1TxZMuDfk8aknIeItko00ATzAwOpSegY6fSE/d1aoKmldhGEquXP2YeKE00Hz25+dflMvrQkMCbnhd92Hn8xYAQl18TBxn5ydZZXcfM7/peQIg1luLaf//08wKlvKhlDD7SJmSWCTh7embPMyuS0lXpjstvZRrabOMMdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Instead of passing down the head page and tail page index, pass the tail
and head pages directly, as well as the order of the compound page.

This is a preparation for changing how the head position is encoded in
the tail page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h |  5 +++--
 mm/hugetlb.c               |  8 +++++---
 mm/internal.h              | 11 +++++------
 mm/mm_init.c               |  2 +-
 mm/page_alloc.c            |  2 +-
 5 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..5e7687ccccf8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -865,9 +865,10 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
 {
-	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
+	WRITE_ONCE(tail->compound_head, (unsigned long)head + 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0beb6e22bc26..fc55f22c9e41 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3168,6 +3168,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
+					struct hstate *h,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
@@ -3176,6 +3177,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	unsigned int order = huge_page_order(h);
 
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
@@ -3183,7 +3185,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+		prep_compound_tail(page, &folio->page, order);
 		set_page_count(page, 0);
 	}
 }
@@ -3203,7 +3205,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
+	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
@@ -3260,7 +3262,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * time as this is early in boot and there should
 			 * be no contention.
 			 */
-			hugetlb_folio_init_tail_vmemmap(folio,
+			hugetlb_folio_init_tail_vmemmap(folio, h,
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..c76122f22294 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -878,13 +878,12 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
-static inline void prep_compound_tail(struct page *head, int tail_idx)
+static inline void prep_compound_tail(struct page *tail,
+		const struct page *head, unsigned int order)
 {
-	struct page *p = head + tail_idx;
-
-	p->mapping = TAIL_MAPPING;
-	set_compound_head(p, head);
-	set_page_private(p, 0);
+	tail->mapping = TAIL_MAPPING;
+	set_compound_head(tail, head, order);
+	set_page_private(tail, 0);
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 61d983d23f55..0a12a9be0bcc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1099,7 +1099,7 @@ static void __ref memmap_init_compound(struct page *head,
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(head, pfn - head_pfn);
+		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
 	prep_compound_head(head, order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fcc32737f451..aa657e4a99e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -744,7 +744,7 @@ void prep_compound_page(struct page *page, unsigned int order)
 
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
-		prep_compound_tail(page, i);
+		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
-- 
2.51.2


