Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85134E937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F284B6B0099; Sun, 12 Apr 2026 15:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED80B6B009B; Sun, 12 Apr 2026 15:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6066B009D; Sun, 12 Apr 2026 15:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C68B46B0099
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EE6313BF9D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:39 +0000 (UTC)
X-FDA: 84650820198.24.FCEC03B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA32380011
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iTsB/BI+";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfN8+U1+D/caXcRuMuDwIGeDbCUHLRkNC9EbatHo4jM=;
	b=pGub7xwhnLq1I582dcntZLKMV8OSZOSU8urNNk2NCOq4wKcTkdznQUjUSgaCZL1/OoNrb/
	hzKoJ+bi/jHYe4An0iPkn/GGlUtNuhSdoSuoeRY0JW20o0oeiu8/gptyzwgRlVRDw7BEX9
	Gcwp/gidBdsAgtEdR4Z3gsvqbisEqyw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iTsB/BI+";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020437; a=rsa-sha256;
	cv=none;
	b=bkC3UJmX4ii56jUB+pIbu2NbyMYCdlHjERut2eX+P3yRPrdFvTTxIjFK4B4KbQ0OTGtzsO
	3oNgXs5UbYhquJXkbw9fAwQcN7oVx4YE8EHesNK2Dxc3yIWxG3c303thBbmRYWDw1YJdiO
	pvsZAF8rrwNmsYvY2YNt5JBIEpzIzlc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29DA260142;
	Sun, 12 Apr 2026 19:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED343C19425;
	Sun, 12 Apr 2026 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020436;
	bh=yNYLmrGnpm3rDeYHInOzSns7YDbk74L5kqWxpI7DVEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iTsB/BI+9t8dv8YRegNzIFDj6lZbfvFhThQl3GygHLwVFFcVrbNnKBLtHHTlU0Yop
	 0Rq3KiQ6pes3bAlsSXwy0EZ2vDPhF6Ao4JXwRDLtfkMgjzhRquU0XeVGJd3T2/p6uY
	 0mnNmS8GKRKu/juwS42BHymY2DflXq4l4XqkLUwVrPV0CoImfO+/qOFjsjODXrM3Kt
	 cXUVOiK5oIvq+lJRCyKYgUXC9eOOUMEtfFfdGEHikDD6aV9V/3Bk0QoBuwSMBaiBj1
	 eNESRFfFhUvmQSrl9fuuwnDdmGmRKkZ+xKefgyLG0OyI/5koKXQoXD3QmkOwJmsZor
	 uK8YHFqXWjsjQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:37 +0200
Subject: [PATCH RFC 06/13] fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT
 handling in smaps_account()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-6-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA32380011
X-Stat-Signature: du7wjemm8uz3din7z9wmrm3onyxch4go
X-Rspam-User: 
X-HE-Tag: 1776020437-476959
X-HE-Meta: U2FsdGVkX1+yXk9AwObdjY9euKC2aIcgftPn3YvaCN3z+/Lyql+H6ajjtVnZjsD56Gums4joHLdpMVXW0CDSczz7jGQ0SMmXw8XgQiQfmNXM26kjQsgM0fSzkq9oW6rxXXksItYS2woNWHnF7RJPJrJ2tMlOSlrc2QPxc6m3znrnsancoTvFSaImGW8b01JuQGiQIMkPF6hQEoLkoPbzR+cYiVA1T2XUZLhCNNy4yrK7YR8Ai+z9Oprz5LAA03vKcuBwM4xdhR1BaRey0hcywHI02Kdwefyws2OWkjdmo8v6YqlcWHT0jsMnn1/d8O6uBYyBl2pabqC5AJsJdkcNMTibaZX9FshIIdvLpy+64Om0N/pH7sdJs8iklS2/nCKpqNu77JdKfQOy20KhItgXPqSXtVGbNxrUwB298dnyNxZoesoX56WQ1ELeXxjBuUZKnsv5Svo4ISgqXto2G47dJAMd1OkNgSfZj2eoE2BemEOcWm+oVAsmrxOqAs2nCx9Od7pLiPwU8KKbDbCRRlwATAphtcd1QeRlvzgKXreuhn7/QNYBScLGRrF/dr/Qscfh7r6hq9a/pFmuqY1mMCVVNJAOvszBg6kP4OuZvrSQujs5dU8A0jf28r+QeheF6RMX+xKc7Vdhd5w/IOJ5aqTWSTS/dLe/X5Fhh6L6mV9d2s7K7eGF+9dhCg6dA1n1+wljU8TOFrCSCQke0WOBIh8jANKclKMwpxMf83TqpISX+0WvddRRzozZZLniakYcYtVcdGQzKX+24HXvQV3zhEzCBBoahwfjCaz9a4PTrqJGaqOB/qNwVZM5bjiA0KKS6nFUZapeOcb8nR1m2sydsuC+ATqLi59rP2BT27+V0ruEJaUYORJ7G5UgPOY5QrbYVQVx1xzzOJVTaVy3nK90tW0D0iUSuifplhqUiUcOPeBEZxP9CBC70i3ubPT33ODmoxQ9Ez7g8AClqzOWqlfY7/Y
 QjxC81FQ
 PldZe9DYkgNY7NPaF4AejbCb3OgAYssYICFf7NeZmtFuFSvx4BLj5Vt9RqETFmAfYe6IHC3FT6nlZQ7CUdsyI9Ssjsm8mEzgAjiiBhBGnEONMF4irCe2JvXLWNAvrbeSMU8XpXWvrdqMQrCoQ+e3330kzz0tCdMMK/id1tWDCmjt7YvBKIC613qXGiOsCvSrESLThOD9NE3IOJncUY0jaGq69HM8sWNRY/oDKlEpjJU8WC9whfYe+1PzzD4Cl6Obmhhli3kvZWC1m1VFNdtP8EBAtIziPPgMIUIId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing CONFIG_PAGE_MAPCOUNT, let's always use
folio_maybe_mapped_shared() to detect possible page sharing for
calculating the USS, and use folio_average_page_mapcount() to calculate
the PSS, like we do with CONFIG_NO_PAGE_MAPCOUNT.

We can now stop looping over all pages. We could now also get rid
of the "folio_ref_count(folio) == 1" handling that tried to avoid the loop
in the past. But it still looks like a nice and simply
micro-optimization given that many (small) folios only have a single
mapping.

Rename "exclusive" to "private" such that it directly matches the
parameter name in smaps_page_accumulate(), and cleanup the code to
only have a single smaps_page_accumulate() call.

Update the doc to state that this behavior no longer depends on the
kernel config, and simplify the doc a bit to mention less details that
are hard to follow.

We can now remove folio_precise_page_mapcount().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst | 33 +++++++++++-------------------
 fs/proc/internal.h                 | 39 ------------------------------------
 fs/proc/task_mmu.c                 | 41 ++++++++++----------------------------
 3 files changed, 22 insertions(+), 91 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 1224dc73e089..d2264240e43f 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -490,27 +490,18 @@ in memory, where each page is divided by the number of processes sharing it.
 So if a process has 1000 pages all to itself, and 1000 shared with one other
 process, its PSS will be 1500.  "Pss_Dirty" is the portion of PSS which
 consists of dirty pages.  ("Pss_Clean" is not included, but it can be
-calculated by subtracting "Pss_Dirty" from "Pss".)
-
-Traditionally, a page is accounted as "private" if it is mapped exactly once,
-and a page is accounted as "shared" when mapped multiple times, even when
-mapped in the same process multiple times. Note that this accounting is
-independent of MAP_SHARED.
-
-In some kernel configurations, the semantics of pages part of a larger
-allocation (e.g., THP) can differ: a page is accounted as "private" if all
-pages part of the corresponding large allocation are *certainly* mapped in the
-same process, even if the page is mapped multiple times in that process. A
-page is accounted as "shared" if any page page of the larger allocation
-is *maybe* mapped in a different process. In some cases, a large allocation
-might be treated as "maybe mapped by multiple processes" even though this
-is no longer the case.
-
-Some kernel configurations do not track the precise number of times a page part
-of a larger allocation is mapped. In this case, when calculating the PSS, the
-average number of mappings per page in this larger allocation might be used
-as an approximation for the number of mappings of a page. The PSS calculation
-will be imprecise in this case.
+calculated by subtracting "Pss_Dirty" from "Pss".)  In some scenarios where
+larger allocations (e.g., THP) are used, the PSS can be sightly imprecise,
+as precise information about how many processes share a page is not available
+for individual pages in such allocations.
+
+A page is accounted as "private" if it is currently *certainly* exclusively
+mapped in this process, and as "shared" if the page *might be* mapped into
+multiple processes.  Note that this accounting is independent of MAP_SHARED.
+In the past, pages that were mapped exactly once were accounted as "private",
+and pages with multiple mappings, even if in the same process, as "shared".
+As this precise information is not available for pages that are part of large
+allocations (e.g., THP), the semantics have been slightly adjusted.
 
 "Referenced" indicates the amount of memory currently marked as referenced or
 accessed.
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c1e8eb984da8..a5908167ce2d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -161,45 +161,6 @@ unsigned name_to_int(const struct qstr *qstr);
 /* Worst case buffer size needed for holding an integer. */
 #define PROC_NUMBUF 13
 
-#ifdef CONFIG_PAGE_MAPCOUNT
-/**
- * folio_precise_page_mapcount() - Number of mappings of this folio page.
- * @folio: The folio.
- * @page: The page.
- *
- * The number of present user page table entries that reference this page
- * as tracked via the RMAP: either referenced directly (PTE) or as part of
- * a larger area that covers this page (e.g., PMD).
- *
- * Use this function only for the calculation of existing statistics
- * (USS, PSS, mapcount_max) and for debugging purposes (/proc/kpagecount).
- *
- * Do not add new users.
- *
- * Returns: The number of mappings of this folio page. 0 for
- * folios that are not mapped to user space or are not tracked via the RMAP
- * (e.g., shared zeropage).
- */
-static inline int folio_precise_page_mapcount(struct folio *folio,
-		struct page *page)
-{
-	int mapcount = atomic_read(&page->_mapcount) + 1;
-
-	if (page_mapcount_is_type(mapcount))
-		mapcount = 0;
-	if (folio_test_large(folio))
-		mapcount += folio_entire_mapcount(folio);
-
-	return mapcount;
-}
-#else /* !CONFIG_PAGE_MAPCOUNT */
-static inline int folio_precise_page_mapcount(struct folio *folio,
-		struct page *page)
-{
-	BUILD_BUG();
-}
-#endif /* CONFIG_PAGE_MAPCOUNT */
-
 /**
  * folio_average_page_mapcount() - Average number of mappings per page in this
  *				   folio
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 55b037768c60..7b212fb6ae6c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -918,10 +918,9 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool present)
 {
 	struct folio *folio = page_folio(page);
-	int i, nr = compound ? compound_nr(page) : 1;
-	unsigned long size = nr * PAGE_SIZE;
-	bool exclusive;
-	int mapcount;
+	const unsigned long size = compound ? folio_size(folio) : PAGE_SIZE;
+	unsigned long pss = size << PSS_SHIFT;
+	bool private = false;
 
 	/*
 	 * First accumulate quantities that depend only on |size| and the type
@@ -943,13 +942,6 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		mss->referenced += size;
 
 	/*
-	 * Then accumulate quantities that may depend on sharing, or that may
-	 * differ page-by-page.
-	 *
-	 * refcount == 1 for present entries guarantees that the folio is mapped
-	 * exactly once. For large folios this implies that exactly one
-	 * PTE/PMD/... maps (a part of) this folio.
-	 *
 	 * Treat all non-present entries (where relying on the mapcount and
 	 * refcount doesn't make sense) as "maybe shared, but not sure how
 	 * often". We treat device private entries as being fake-present.
@@ -957,30 +949,17 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	 * Note that it would not be safe to read the mapcount especially for
 	 * pages referenced by migration entries, even with the PTL held.
 	 */
-	if (folio_ref_count(folio) == 1 || !present) {
-		smaps_page_accumulate(mss, folio, size, size << PSS_SHIFT,
-				      dirty, locked, present);
-		return;
-	}
-
-	if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-		mapcount = folio_average_page_mapcount(folio);
-		exclusive = !folio_maybe_mapped_shared(folio);
-	}
-
-	for (i = 0; i < nr; i++, page++) {
-		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
-
-		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT)) {
-			mapcount = folio_precise_page_mapcount(folio, page);
-			exclusive = mapcount < 2;
-		}
+	if (present && folio_ref_count(folio) == 1) {
+		/* Single mapping, no need to mess with mapcounts. */
+		private = true;
+	} else if (present) {
+		const int mapcount = folio_average_page_mapcount(folio);
 
 		if (mapcount >= 2)
 			pss /= mapcount;
-		smaps_page_accumulate(mss, folio, PAGE_SIZE, pss,
-				dirty, locked, exclusive);
+		private = !folio_maybe_mapped_shared(folio);
 	}
+	smaps_page_accumulate(mss, folio, size, pss, dirty, locked, private);
 }
 
 #ifdef CONFIG_SHMEM

-- 
2.43.0


