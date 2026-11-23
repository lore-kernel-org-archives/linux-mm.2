Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3602606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tI1Nu6dK
Received: by kanga.kvack.org (Postfix)
	id 176296B05B6; Mon, 23 Nov 2026 00:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126836B05B7; Mon, 23 Nov 2026 00:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0151D6B05B8; Mon, 23 Nov 2026 00:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6FB16B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 535168066A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:07 +0000 (UTC)
X-FDA: 85465272774.28.56476E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C1D2100002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tI1Nu6dK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412165;
	b=RVN5ltlhOsEUgdHk/9S9D9oMrlt4hebaEF1vFKQ0zKHU2Vno3nsAaik2pKO3DxYGUhnAah
	HhSkOSBTcNHqEA0adeD01PnGidN0L07jnAf9IpkdUMgYIDcDhYNdAPTuw5Cuv8NrJnGqw6
	do1fmFF1Hyh7e+Xl3HL9aQhS6ecOR5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sztOyUtvVwNCz1gvYmQqcZM5lnFUEIW2aEPbQXELVl8=;
	b=ID5dtLziTDugZN+Uj5CWyyU/UgNNGOQafOV1xLAO5alsPyPVafCUE60stKh6QfOl/dbSog
	Pagy4COJEi8O77xp+iFBDJa9KtX9Yz+OSHY6zPkHI0yIWk+wCB/UVuNqJRE9ssc/P7g8eu
	WaYilK5TUi8G7O/SVz3ixzgJO4a+4mE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tI1Nu6dK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71C181688;
	Sun, 22 Nov 2026 21:36:01 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A57D13F632;
	Sun, 22 Nov 2026 21:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412164; bh=gBDzWBJYXCQ1hckvPrejnaqoFVdt4IWBe1N7CMV/06g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI1Nu6dK10FLwU3cJAoGnGK96Llq8wfx2UUIM9qfkqH9XdwK5e38fA4G1Xhr5/pxI
	 hJM9YWoggAA72nMNfdVoc2xON4tS7moYImK40i3b3WZ4KkLnilIinLn9L9xYzEHf2b
	 QItcZU8zNfULgDd0HHwFvruyFhIl/A4L+u1+Qt+w=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 1/8] mm/swapfile: add batched version of folio_dup_swap
Date: Mon, 23 Nov 2026 05:35:35 +0000
Message-ID: <20261123053543.295467-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C1D2100002
X-Stat-Signature: a3dw6kj5kteqogxr9hmmej5qrbshp1mp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795412165-49900
X-HE-Meta: U2FsdGVkX1+NaHtl489Kje0vFPANIdEgWUBOWWOWmz48hi4QvBPjB9LjQBmS3dx/7UlcfcGJUF36wcfPEC0paB1w0n1HXXLdtdAhho2InvB3XDmCwWS/7gK6xSmgXBAWLlvCDT+GmP+NXnG9v2rNyEUdj5umu673miEgQ3ULWyjpZj5QurWHXswNtY2HCcmVTB8h5WKqhUDXi5oeZoXgInE+SusL5++u1F00JF/GBZR4qWpThQiZ5+2ZRc7vmrI0coV/MqChkUDXoYqxvn6Uu9VIR8Zz+OaSnQU6xnB03lLlBL6VLcRtZL04N+EnDU6NfCXAJZb7HtbsFpIlt2KD6UzIbpl0KheL/BuV0fYdos1SpPvvLAtEi0Il2l4yX9BU8MB8WXcC54QhQBZAM0jhSV0SlkUzPGVprgwPNlomo98L4R3E6gCxEiSJ80hJ11UYzGYCfT9weqktYx9iFIg/TONLAS9Tqzdte0etw/vXYjCrxv0hNBC50YOl7kluNsqc/UgJqPF+PV3yWx7vGtB9WHAuQNNlU5scT2geyy4jJHJW36I8/jUGV4PhrdhHKGgKhqLkN+U+QXM/4zgKChpjMpns1LP/ABEYILOI8XgKXC/9TL1vNAWHJxmaaKs/IZPhTAQkcjdLcdvVlTMvt0Uv082TS/G0Es62hqhs1O0vrWxmcm0ThN3LQ0KpLjIW2HQQtOudgRrX4VmPURw5d0dx/j+8JU8Uyv6orUoS3Buz2kDj+iOP8sDTu7e2ldoqYsPVGSTaE4RLihg2DcyBGT0N2nJ333vxqQB7E7IE44C3O57Iz8ttp3xTDfaiLMKUJi0boyoGft4czj/WAiZFBtRfov0Lxy78ld9QtupAjw8dclRvS30/AT9jUtf+Ehc90hR2l34cR1tEuAJZ2R2OclHjHlNVNW2W4vixw6wxmI2wDTYKN5tDhftedh9+pRbaBRKbfo97GY4g+vYXQB2C3Bn
 nsruEV3L
 Y1qn+KG916t9nrxmDLcPbylNm5EYcQ6bPY8O2QGvWbvoZdnCh9PKtzzc9qnw96FXbzMsywryLA60FMXd/g5PmO8oo13N44+fs6fUqemvmAGSuY1nc+ppLV55HVkzFM6kmCFqxNbFYxCgtUBy24dgZ/i5Mcr5KWtRmpgXod8V8AzMsHj1NACxkPXwVMPQsCtcWBgj1wtp1q7rqjHqqSt0hr0QGaW2q66Nj6QjLoj1/T4yp3uvhtyDrY1fnoDJpu9CjNj6FCAAcxDI2/NvOtr9qG06WtQcQf6Wpis3Do92P91TqnxHqymDbXncD/Nv2nbkmsME62TTDGtvCcZVzGyERdjRaNyjDoM2KNjazRjL0DO10DuR/NUMz7rYQlM0vomklFSedDm6wzlwrty0uaTs7hq9WXZpQuAgmtUzSkSylQ/Ss9jhZzgaBsPnLXxMSV1bNCWDh5/2WS3KJ3jozTa+1sXFWLe0ADanjISSJnAg5rN/bUJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection: the caller invokes folio_dup_swap_pages() if it wants to
operate on a range of pages in the folio (i.e nr_pages may be anything
between 1 and folio_nr_pages()), and invokes folio_dup_swap() if it
wants to operate on the entire folio.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 18 ++++++++++++++++--
 mm/swapfile.c | 18 ++++++++----------
 4 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 09c33b9ec585..ea94e69010da 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2167,7 +2167,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (folio_dup_swap(folio, page) < 0)
+	if (folio_dup_swap_pages(folio, page, 1) < 0)
 		return false;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 81c1d63de334..aff46b2508a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1986,7 +1986,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		 */
 		shmem_disallow_eviction(info);
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..ea710cec986c 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -244,7 +244,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *page);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
@@ -368,7 +369,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
@@ -464,6 +466,18 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 }
 #endif /* CONFIG_SWAP */
 
+/**
+ * folio_dup_swap() - Increase swap count of all swap entries of a folio.
+ * @folio: folio with swap entries bound.
+ *
+ * See folio_dup_swap_pages() for more information.
+ */
+static inline int folio_dup_swap(struct folio *folio)
+{
+	return folio_dup_swap_pages(folio, folio_page(folio, 0),
+				    folio_nr_pages(folio));
+}
+
 extern const struct swap_ops swap_bdev_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c2af13eb15b3..a7d7e1f81c79 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1804,9 +1804,10 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 /**
- * folio_dup_swap() - Increase swap count of swap entries of a folio.
+ * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @page: if not NULL, only increase the swap count of this page.
+ * @page: the first page in the folio to increase the swap count for.
+ * @nr_pages: the number of pages in the folio to increase the swap count for.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1820,18 +1821,15 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *page)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
-	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
+	unsigned long idx = folio_page_idx(folio, page);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
-
-	if (page) {
-		entry = folio_page_swap_entry(folio, page);
-		nr_pages = 1;
-	}
+	VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
-- 
2.43.0


