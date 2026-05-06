Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B341CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B756B0005; Wed,  6 May 2026 05:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4166B0088; Wed,  6 May 2026 05:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A746B009F; Wed,  6 May 2026 05:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61E486B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 205488CF46
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:13 +0000 (UTC)
X-FDA: 84736514226.29.AEDCD7D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6BCCA40002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OeADSiwf;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/K/gtma5aX4GCLJVPPp5+vskpB42p8S5e7DyPLEgMo=;
	b=VPms0novq5kvUqxeP5vLyYdIYgUsxPhZ9qxqgr+DaL6fJf8BCGazojYLm7vIHkkMk4pdGX
	OH+36nlmk402LKPKs7F3EH8isjmDXxdzhpdgkZQZGLP5NUQzxT2rbUZGzpYtPb8H/2Z40h
	aiR0FNW2MDsclDqHKivYudE3LXgc4BE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OeADSiwf;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060771; a=rsa-sha256;
	cv=none;
	b=C0iaCrDb6QRH3MTKwlT3ulo/Z13l+5aQOvL1Nv1jWivJiCdcgNX8dGoOR9Uh5MRgBzUUrt
	dXBLdgnIcCOOsrsubePnCIULf3AOruA7+gAa/NHc+gERoU5TnGFfAQoGR6j7SEbvUgfLuc
	zYflihrB1E7lukGQDNoaMWFVBpd38NQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20DD41AED;
	Wed,  6 May 2026 02:46:05 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9219E3F7B4;
	Wed,  6 May 2026 02:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060770; bh=lHY2l0/xocHky2BKTnqlwct7+gkWQSoxn85NyNv6yjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeADSiwf6zbxzH7ZU6UXWQNT0MbjoWHMlLISm2s/ti4sHlhLslh6le9RR8OAj61Jp
	 9pDYPxfCQCEaSs9OWvhk+NzgjW3mJZlrRTL/Zez+xtizSOSzpep+Er9MUxH9+B7xPV
	 jz1ucIckm41bUG72Xqkv5RJnGJky1BSEomZHB8kc=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 6/9] mm/swapfile: Add batched version of folio_dup_swap
Date: Wed,  6 May 2026 15:15:01 +0530
Message-Id: <20260506094504.2588857-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BCCA40002
X-Rspamd-Server: rspam06
X-Stat-Signature: kyxkettdg89fw8xpsg9aw3sr1fnu9hdu
X-HE-Tag: 1778060771-331464
X-HE-Meta: U2FsdGVkX19JSuJlTkBdl4uGNT9AtLPnKx8INZFjll6jsnXY/9GXswO0V61KPA0tkWVLUCyK5F9Y4rNXnSnozOd080tVr7Vp+4QamAHxDSjUYELSkHKcRibcdFPXLMr6LYDmOhUKsw3w7WOR9gOpIZj7pEKmWgywwP3WO00X+5JqzVMrW61uqH53cjWKevEFyx02/8r2A+kR2TZbyNLl0jqLVJU+guHMz7YyI3rDAmF6jQma+BWUfCdxNf/F/E2bBcxIfMRSnX26aGK/VgbuRDifkAYbIu0teRwuT5pKQRULAVhmncPAEIp9tct0yhNCux1kMq1GwdyMBu7o4VqW1G3apB3H8VHgRJ4wSZ3vtYi3l9RvRuSwnL38It76DKuF7Xc3IEsxR4A6e+RvxpjV8eTPWrLbYoDVU5ZY9+/t0KmBsSggBcU3qTGZYzZPB1yZr/ZoQoUnm3yvwkXEqaE2FTGc8oXv+Ezqulz3/J9cFGC3G5nV3fM5j/owZctrhO5YNS3F0fbONM+fIb1Lm+zeR/Wpp8V+xva4+PzKbRYD32J49tB+a2aJp3VCyP4ubNpk6cTkLWDlrlqYVX0EfONhZuQWsHn5aIVimdyXrv+ul7jV7jFWbVlOzREOII/6m6hgZ3X53Pjl8kpC+3LcP4av18r64W/yZtVlVZJjnF8feksoOJzabDHn15kVFKxnJ4JSI7w1iey5Fp9javt/2IXBF+fzgM/KLR/yjIdZ6g0viLQovSMZAWp1w+tPcqim1HPjQrPCQMmD5ZY+zF29uZ5qt45F5mBQfz6Xsh/Pa+Q3dYoZynSBaQJWphCwcFjqdb3mJH989VySKWAL13jRrVIuqpUdHvZy0HOr4ET4P/Im9C1x1sPnxhB/L7aVIUR/AQMsyUoR+lsfP8UpsfiN9m0rFDjF+GnJ15g/3+4H7kUQ09e1VflblSeXASmveVlQTB/KIKDa7zg2dWFrxwCQgSd
 LMTsJNy8
 3v88VvPAxo+E53NAd+2y7j6bbctsGELzYxn3mEdboR0CMLxhT8Rqlq70iKfM2oujcZo1pltCR//uiS7PfxD1/OiBPQUMfi8xtIpblwto469H8fLWRqRHVisqbpxQsa1JdQX2mt6I0v+txLbkEa9lBvihmf8BsHSd3ZYRXZaMfc3zI/nW3qud8rcphJ8VVyhU0Sp0uCIwj0fWb7c69iML4snh81Rz8Go3iDdn0yHEWvutyJ7v6uo4g9XZh2W/YewJfJ2hx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection: the caller invokes folio_dup_swap_pages() if it wants to
operate on a range of pages in the folio (i.e nr_pages may be anything
between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
wants to operate on the entire folio.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 12 ++++++++++--
 mm/swapfile.c | 20 ++++++++++++--------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 25813e3605991..352ba77d90f67 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2314,7 +2314,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
+			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index bab3529af23c5..5e4f521399847 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b9..3c25f914e908b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -206,7 +206,9 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+			 unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
 /* For internal use */
@@ -390,7 +392,13 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap(struct folio *folio)
+{
+	return -EINVAL;
+}
+
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c7e173b93e11d..28daf92839e77 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1740,9 +1740,10 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 /**
- * folio_dup_swap() - Increase swap count of swap entries of a folio.
+ * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: the first page in the folio to increase the swap count for.
+ * @nr_pages: the number of pages in the folio to increase the swap count for.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1756,23 +1757,26 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, page);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
 }
 
+int folio_dup_swap(struct folio *folio)
+{
+	return folio_dup_swap_pages(folio, folio_page(folio, 0),
+				    folio_nr_pages(folio));
+}
+
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
-- 
2.34.1


