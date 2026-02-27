Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A4DFD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9756B00C0; Fri, 27 Feb 2026 14:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9319C6B00C2; Fri, 27 Feb 2026 14:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807236B00C3; Fri, 27 Feb 2026 14:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65E906B00C0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DDBE1CC1D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:18 +0000 (UTC)
X-FDA: 84491260476.08.6139504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1832140005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZTsD8nv9;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnN40ZnqKJJ5gv4Vyh4oOqoQu8mQOg8wC/Auhlap+Rc=;
	b=g/tzDisV5onUP2g+2a+wpOIMXGXdvnX5mWm0vsd2vEK+OczmxMpHa9t+CswEF0DBirjmFY
	i4w8aE0lFQt1Ve2aOvBr/yJApZTkHEkNcE5ruMHn3oqW0YB7mXASWSTcgBY1TMUm0+JRLe
	Qo0ANrsDaFMsp4aBAQJ0zJbBF1/FLQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221395; a=rsa-sha256;
	cv=none;
	b=uHfp/JxerMZfhrKY8D7oO9fTz8qLy9+Aiw6ak/7wlGS/TMRr9AJ9gmR/szIu62ifoztnw7
	hODXQrSQO0U21nA7HCXv/v8/Ql5HPgyWAtPEGUD/YNbVE8kYwTuZnlh9M03akTfRnjG3Lg
	761oCUE0xldXmkvGg3UWsNGl0hnp8ws=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZTsD8nv9;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0E734456F;
	Fri, 27 Feb 2026 19:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE2DC19421;
	Fri, 27 Feb 2026 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221394;
	bh=Xoy0vcEmhS4Ump5td/QMKdt1xxA3nwm83XumwZ2X0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTsD8nv9e7Kt8UrhBPCzB17QBeTMnPBvrz9MUiUetJ2WcyLIV05G8wkc+avr04MbW
	 yTVHMUBVDhBAYrxmRNWjAsIm1rsEqwwBmEVrhCmaPKcfNStj5mOn4p8/3vCU7kC1H5
	 B8I3TuEpmOJsMUh6FLFJIjEyJd5JuFNvRcyytnu86q+YzK3oZrfqtbfYMpKCf9oy1/
	 6SRi2UtNaKnCgZtcblcHnMgm003bduLe1rr1WdBzgbBHV1yJpTKUXAAR3JKnxcPhIz
	 +nWujUS75hMG1xu6NKy5qPtHMvKRdqxZRmZ8Ebfd/2Isk5rtJG7jFuGaao02sDywbg
	 Lc4Z1+t/ar2xA==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 06B99F40068;
	Fri, 27 Feb 2026 14:43:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 27 Feb 2026 14:43:13 -0500
X-ME-Sender: <xms:0POhaYqF889zif5CE4hxOIdTK8Ql5-N8GkkSJQxQJEbjFthzKWjs3g>
    <xme:0POhaX3hkmsMnvEgjGMAKksg-mJOEhvanU79k4Zd2422RnWR3mrlhwYwfF6DjyYHQ
    PsuSjmlrnQLHiXEK9-Qy1fUBB9UWzLI7uilH5V8UTAPWdrvqZ2QCoU>
X-ME-Received: <xmr:0POhaXUxCgf3jL03NSOh6-rHjSENhpsRPXqUnE9VOMQtNiLgiP0VFLKO_98ikQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:0POhaQyAxXKFOpjLRWxvBuYK6xzEVs5A6S-TpBcLmLZlbJ0bOTkNIQ>
    <xmx:0POhaT037aYaeNW8j3RUtbdYCnqeq7-9qycjy5nrL5wnF_vRtWVjww>
    <xmx:0POhabvWKIFeC-aSkMZhTolcZokbzvHroDqK7I51ECamtt-onMH3fA>
    <xmx:0POhaXXXGPrPvmmNTEakX0bj_m4t0wAmCRs0ZwyV1RnDLo6S6DJsbA>
    <xmx:0fOhafu6ClIdpDgZrssoBF0OxWWBPPhTMQuiQPV3D8gQ7Ob9JuUezyn3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:12 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 02/18] mm: Change the interface of prep_compound_tail()
Date: Fri, 27 Feb 2026 19:42:40 +0000
Message-ID: <20260227194302.274384-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hgwuq5agwzb1d83jhhikryqy5oz7a5o4
X-Rspam-User: 
X-Rspamd-Queue-Id: C1832140005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772221395-345813
X-HE-Meta: U2FsdGVkX18VvBq15ANkzXmSgRDe+f9bN7aet3TF3alQFtbeiN6f3fmNLWcEg+tdxJICUzpwPd47Np06akjVcnO+R9VAbwItZLBAyTbgtUlonRqdBXx5Kwt8XpS1sYeaOXcLQ/QKCYsg8qCyt0J7l2S4TF8NqTIktG/ryfLG5n44Ulh0sarDx7FmYKh+O2OUAz7QjADj13JNrHJRfVfTw2HhQdKNLT+k1i/ru5qL6hxlC4NVeqOFIyEzwUCcFnQtAJoGG9UaE/m/jXzy79GsPcHlqBLyj+pALp7eqfu/hivi38eduFMIsUOYny7NxV2AxdlJdnCClmlcu6OiM6hijoCYhMCDCSxWT8GgWFiuFRQXZSbtIeyK1EXSx4FgLC9Pg9l7OkCS+8yyahJT+/6cvCIRFggj/aY/h2JsrWXE1JtyNZy3rlkaDxOccU+fO5yov1XtX0S+Mr5jG2b0zklApbIxzdEcjnB5LufurnlfMCVGTP4wKw/7+NQRImaz6sX01LfPyvjJO2FgYvRBvp7TJAltoeWhX78365Vu56RLH6R7YqaSmVmKDPLpxnMBKSAXBISLlb+PxNFkloNiikVLH770rXJ2pMZ6TOk0Vd486c52Cu1M1zao26qKE/wCgEC+656IkYkYvxVEaQHRn0+OYtywgWgHW5VgxMwM6s6+gxDUtP4vrTE1+sEFivTUtfBiupQhcnL7arfwOjSENjKN9TqspkMlGbH66ZwdXEcmhY5VrMF2JzMuXpBMsnL6qOzKLEMoa5Rz2v4qFKl5WyRnE/ot7ElhfhhGJ75zOF0vZ6/rAkdSDiH6dO+nXdSGhAMHuby5KHr38jS5KFAgciM8n/I+Qp9s/BczkQwfxheDQrsXwvEWDRd39L9+2oCpJ0gtoMZXaTPBCXDIBjIrBauBewLwMgfJEJIO25gkfmPNwxFmF7CfLhDyvayPfoTzVssQyBbQMTqFte6aHamxshR
 x/YqyTZ3
 zg9FLJeRiM4GqB18n+QrTUV3GmAZb1Ivo0myAd0p1Z1OmNtmbOX3OhVM/UVS1G+yblHJ+Un05XqXsQhnH6+cVIa9YUFwsYtf7P2pIwlA4pmquIcbzsihuPsQP0d+9OyVE3mx3fTH5VuVQ+keifdCysYN191gWLBTNyP6LGWckDmSZN44atLiELCofXcafpx/pz9dR8HNcCtNGfOCi6bAjyZ7yIRxOXSFp3pj9tPV1XEDCAXp4aSHCoscmTvODfZ+61dfAUnlFqN29I6niJyj1LUB+JDTqoCPeAqDyowQuU1mtS7VkxXqB+cJjwbmmklhT23YSkVBfTcl5xFI=
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


