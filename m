Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2B8E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF776B00A1; Sun, 12 Apr 2026 15:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FD46B00A2; Sun, 12 Apr 2026 15:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED73A6B00A3; Sun, 12 Apr 2026 15:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D82286B00A1
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99B348CA26
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:45 +0000 (UTC)
X-FDA: 84650820450.11.38E705D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F16571A000D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kMfyBNro;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSn6Iznpv35AAcHwaJh0h7oONdIlCmd8XBQxjXwXoGg=;
	b=3uWoxbC6feJhwU/wEz4GSQLi6TZu6+Doh7pf5FBcfb0BQ2BKnO1M38qviV9Ohi4S1m5ALK
	Baajm+mt59m7fsg9Yb0lhhxbCUnH6iXXxsXKwzIdf2yt6SN/KbfabgXpWHfCQGrz4uugtn
	N1j/I+5vAnCTIhcSCdSpsQgyt/6p1sc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kMfyBNro;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020444; a=rsa-sha256;
	cv=none;
	b=S6uuL0AXw5sDi/dyJi/xgTPa7ZOtbtdsZOBnJI3DDY0AlF+UWpglgCp2UZIxA1pObOi1Dj
	tItiKYn+LyeFFj7Raa8zfdQInZ0FXJeiPTHYJaE2yAabJdPDfI5AceyikTSL2CB6I3PpBt
	5kKeUbADqj+iwYALGrKJMIosmI0t/nQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67C9F60142;
	Sun, 12 Apr 2026 19:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6710FC19424;
	Sun, 12 Apr 2026 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020443;
	bh=R0nTOV0e4UXBnZHM/i98LWNnXx5at53ZamlgFkrFi2Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kMfyBNroYJWH/YPTOYl5elR0tf4Rs5AsOvgIhJPsdx4c/rWytCnMcYpidevEi986H
	 I0JECN9XuB5EeJr+vo4nq5yL+wFW3ifiGqzUnNMWhYKXd4Q8uB+XSPcmQ6JPSCSgtZ
	 vVaHvJ/FqgM4RGvgHymqoGgMhMnnNnnh0R/3AxN2q8822NmUTd1Bha9nME7SYspi/U
	 Yb01uIHY0jGNZZkNKXwG640IjlQ9QVNd6YjMdWczHjVntXqOCq/iMnMs0XwXo4GMkO
	 /49DR1TGLhIiV+N+dVOpQGPvZ36yM5l/s6+PkXfLhMG787YSyUbs7XiHCbcve9q6/7
	 cUsuIIWre4Zyg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:38 +0200
Subject: [PATCH RFC 07/13] mm/rmap: remove CONFIG_PAGE_MAPCOUNT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-7-05e8dfab52e0@kernel.org>
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
X-Rspamd-Queue-Id: F16571A000D
X-Stat-Signature: 1mtt5ygudr1ctfs5kkky9bhr8hxr1sqq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776020443-723568
X-HE-Meta: U2FsdGVkX1+ZXH3/hh6O5UKqLHg6yAaVGTHy+hX8HOvFbvZRH8s67tLhimo6rq2tZV9me2DBH03x+LtOy5wZ3oKN0V3AjzKfDs+LLncIUN4yw5ACyyWHkfMl0pQCnCIWCbaIS1i5ucgEcAMOPFTKM9yrCMnS/y6T4MwjQcF6d8/xTpflz5mcmoJU9W/OocTKexmFmhQGQi2Ke+QGOczfAH7Fj3HvA3fLOeSwTFZbpdPBx7pefBrPm6H6lJdjez0E4CzRtlmBtx5hKltG0Fxr9wGc/AVxx/njUa6UKqMIlMyf/UTnNmpY8jAFLJ26XZBLZ89whjd1CaZrHc2GocqkCMH/MKz33A8M07Coq46vSCZtER6Qwwf9Iaasstx+MCq7Pr1/da22vdnkmXTFQVXrSpzJivaaHW3azz+F3BtTrnCk3fkDFujf71U6/QO9PumUcIxOXt79FI52Ir4HcKUKkc2M0x8qc4XWR9rQxopUVstXNWFQhvt5jo++le6JVSa8A5MteEduYQ+eeqZairy+cugW0xi4l+GcbHReuK8PstW/BVFrtYQFaMdM9smqKExV1nweUREhh8m+EMiAHACPeBmtsN2sMO3i6NxqEzmQC8WKP6fS6uwBSWtFkehQPvGilH3sUMbo15ceaZ8ZLy5OhEMHT4xblv1DF8vjBzo5sOkFTAjDe1fqqPYmWmGbMZkaDBCR4HwTFGK0HSPiM/eiFGxHTdzYZYyBy+nOQgJzh55T9lOHW/oK7pIUUAliiezMy4BeltzKmBcXz0P7CSO/L7ocjIc2VWwC9BuoqzrYlF5qrKBB4fPTZLiTAhAT3ncFCnb6H7FgIDhIF2CLmSFZkM9KtKDpTiU0aD61T6DC309e2FC1ZMaPe9f/+1FLPj+rlFQ8QFFXw4pjacOyBLTw2cRqji5JE8ZE92eR6nBAoWWgYmb+ibpuWYmPnYdXEUjgeeoDBGa+ga2JBkRopuz
 2jpDZQ9H
 yn5N4nrWNePsrnVCMXmEgLMFGrIXvDqT2XfgwXigJxkl8/Yi6Z4nF2V8/TBeaJ/CKUmQNl8Q4CdCNsxlCoqfl52M9OIi1D9rih9HZuXI9QMq/qS4x8ZzYKvxC3GYK3bcvmbB8+AM+mMAOHXiOl1d3ypOSyQTuh+toKGuamWyPE53lOoTkfvKqzDY2fZISI3fIywkwtlfo6ZplEIUFxE1j8GsniZYpnY7qQKoJJAzGjig25/Eii3Tlr7kWZ3wUyen0FCattvKx4ngG1nmh8RWL5tLVP5/LDPKplyOrdEUgbp6WC9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->mapcount is still updated but essentially unused. So let's
remove CONFIG_PAGE_MAPCOUNT. Given that CONFIG_NO_PAGE_MAPCOUNT is the
only remaining variant, that Kconfig can go as well.

We can replace some instances of "orig_nr_pages" by the "nr_pages" as
the latter is no longer modified.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/transhuge.rst |  3 ---
 include/linux/rmap.h           | 11 +----------
 mm/Kconfig                     | 17 -----------------
 mm/rmap.c                      | 36 ++++++------------------------------
 4 files changed, 7 insertions(+), 60 deletions(-)

diff --git a/Documentation/mm/transhuge.rst b/Documentation/mm/transhuge.rst
index f200c1ac19cb..eb5ac076e4c6 100644
--- a/Documentation/mm/transhuge.rst
+++ b/Documentation/mm/transhuge.rst
@@ -129,9 +129,6 @@ pages:
     corresponding mapcount), and the current status ("maybe mapped shared" vs.
     "mapped exclusively").
 
-    With CONFIG_PAGE_MAPCOUNT, we also increment/decrement
-    page->_mapcount.
-
 split_huge_page internally has to distribute the refcounts in the head
 page to the tail pages before clearing all PG_head/tail bits from the page
 structures. It can be done easily for refcounts taken by page table
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index e5569f5fdaec..4894e43e5f52 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -493,8 +493,6 @@ static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
 		enum pgtable_level level)
 {
-	const int orig_nr_pages = nr_pages;
-
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
@@ -504,12 +502,7 @@ static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 			break;
 		}
 
-		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT)) {
-			do {
-				atomic_inc(&page->_mapcount);
-			} while (page++, --nr_pages > 0);
-		}
-		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
+		folio_add_large_mapcount(folio, nr_pages, dst_vma);
 		break;
 	case PGTABLE_LEVEL_PMD:
 	case PGTABLE_LEVEL_PUD:
@@ -608,8 +601,6 @@ static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		do {
 			if (PageAnonExclusive(page))
 				ClearPageAnonExclusive(page);
-			if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-				atomic_inc(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
 		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..576db4fdf16e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -948,25 +948,8 @@ config READ_ONLY_THP_FOR_FS
 	  support of file THPs will be developed in the next few release
 	  cycles.
 
-config NO_PAGE_MAPCOUNT
-	bool "No per-page mapcount (EXPERIMENTAL)"
-	help
-	  Do not maintain per-page mapcounts for pages part of larger
-	  allocations, such as transparent huge pages.
-
-	  When this config option is enabled, some interfaces that relied on
-	  this information will rely on less-precise per-allocation information
-	  instead: for example, using the average per-page mapcount in such
-	  a large allocation instead of the per-page mapcount.
-
-	  EXPERIMENTAL because the impact of some changes is still unclear.
-
 endif # TRANSPARENT_HUGEPAGE
 
-# simple helper to make the code a bit easier to read
-config PAGE_MAPCOUNT
-	def_bool !NO_PAGE_MAPCOUNT
-
 #
 # The architecture supports pgtable leaves that is larger than PAGE_SIZE
 #
diff --git a/mm/rmap.c b/mm/rmap.c
index df42c38fe387..27488183448b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1354,7 +1354,6 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 		enum pgtable_level level)
 {
 	int nr = 0, nr_pmdmapped = 0, mapcount;
-	const int orig_nr_pages = nr_pages;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1365,14 +1364,8 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 			break;
 		}
 
-		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT)) {
-			do {
-				atomic_inc(&page->_mapcount);
-			} while (page++, --nr_pages > 0);
-		}
-
-		mapcount = folio_add_return_large_mapcount(folio, orig_nr_pages, vma);
-		if (mapcount == orig_nr_pages)
+		mapcount = folio_add_return_large_mapcount(folio, nr_pages, vma);
+		if (mapcount == nr_pages)
 			nr = folio_large_nr_pages(folio);
 		break;
 	case PGTABLE_LEVEL_PMD:
@@ -1518,15 +1511,6 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
 				 folio_entire_mapcount(folio) > 1 &&
 				 PageAnonExclusive(cur_page), folio);
-		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT))
-			continue;
-
-		/*
-		 * While PTE-mapping a THP we have a PMD and a PTE
-		 * mapping.
-		 */
-		VM_WARN_ON_FOLIO(atomic_read(&cur_page->_mapcount) > 0 &&
-				 PageAnonExclusive(cur_page), folio);
 	}
 
 	/*
@@ -1628,14 +1612,12 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		int i;
 
 		nr = folio_large_nr_pages(folio);
-		for (i = 0; i < nr; i++) {
-			struct page *page = folio_page(folio, i);
+		if (exclusive) {
+			for (i = 0; i < nr; i++) {
+				struct page *page = folio_page(folio, i);
 
-			if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-				/* increment count (starts at -1) */
-				atomic_set(&page->_mapcount, 0);
-			if (exclusive)
 				SetPageAnonExclusive(page);
+			}
 		}
 
 		folio_set_large_mapcount(folio, nr, vma);
@@ -1769,12 +1751,6 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 		if (!mapcount)
 			nr = folio_large_nr_pages(folio);
 
-		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT)) {
-			do {
-				atomic_dec(&page->_mapcount);
-			} while (page++, --nr_pages > 0);
-		}
-
 		partially_mapped = __folio_certainly_partially_mapped(folio, mapcount);
 		break;
 	case PGTABLE_LEVEL_PMD:

-- 
2.43.0


