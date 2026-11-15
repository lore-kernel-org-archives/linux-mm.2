Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC32606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dGY+3TkQ
Received: by kanga.kvack.org (Postfix)
	id 99C816B05B4; Sun, 15 Nov 2026 09:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974286B05B5; Sun, 15 Nov 2026 09:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1786B05B6; Sun, 15 Nov 2026 09:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 577756B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:39:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB5FA4077B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:30 +0000 (UTC)
X-FDA: 85437611700.11.3489D93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3E87100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dGY+3TkQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753569;
	b=wYYO+nbp03x0pXmPXHynRJDC/zXQaOs8EgjlPCWlZtLlDzgQEyM7G9XXolcBDT1S5lAh9a
	phsPy756q/Fcu/Fvx0KWcmmM0FKhv9Ok2fnS0CGkVEi71oCwMZrioHUYjiyMoqj0Xvaf5r
	IS20/LgmEb0bzHCZzTjxnD7RFunrEII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TskDAOAWXEo8flmJwWvmjXmj7YUn6WxOmJxYrefk24E=;
	b=38cN75Gu+h+ZWkWajYrNk5jMpj1m31ClsDR2PhXbkPQHW/fg+HSw0BMOg5rX9x5bt+2oVV
	Mz6VOPSu8bvAkPpjTC9rPKN6fBNodS/Cy3JEP35x0MoM4vS8XsYUg/ieIY0zhZMeb0JRBm
	s6w1NtJHoIebU8b5glzza+YwWKftaZU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dGY+3TkQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88F71476;
	Sun, 15 Nov 2026 06:39:24 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1063F3F85F;
	Sun, 15 Nov 2026 06:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753567; bh=IRV0Se7ac+aPU1wxdxXwDgPgVOJdcgTy6K/y0/wG5B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGY+3TkQ+VgGngptslyasnoZpm9Yj8NS4w09ek+LZL0mTIqzRaBpDUc5jGG1Ed2DJ
	 sK0OjKBZDEwa/YRcNoZGJYHYfM12KtRPersett9Qx4i6pCmZCotZU5wPk66mu+m+no
	 xl6d9kcEV3X3vFYAMzmNuk6f62viZZPOPADhEKpY=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 1/9] mm/swapfile: add batched version of folio_dup_swap
Date: Sun, 15 Nov 2026 14:38:56 +0000
Message-ID: <20261115143905.3045084-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3E87100003
X-Rspamd-Server: rspam12
X-Stat-Signature: tj6ir1o5ygzkuru3yrknzqs5smmmcziw
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794753568-387461
X-HE-Meta: U2FsdGVkX1/Hk4Bls459tfmDZPQVquLI4sWX/aSuzK7Z2x8e6/0Bu4vmisOefVFvqgcG1oG0DRo8iJjykSixNCKY56dG1PRClVw6kJgPGRZNSF88qd46LSu/S6tlfqKowIEHNbL8OoEUIbD02k1mIA3nJMKO/2REnHmzwfqiPwQscNrtHbazH28P2K/9Rul8yg/VusSYrrM7cqE/q7FxA4vRQmc0JHjvzlx16lCjMwbzxJwS7TdhM4RhjMWtcXct5Bzd/MUOcNbXsu32xFkkPo6Pc27szorieSG7+o1yoou5jTvsAx+O3kmk7ZmmCYQFsC5zjD8TIfI5/9jiQHlGaGL0Iiqk35q8VKvHvZzPFQwEXAVlsITOZmQLBs7K1WDY4NOJlvL1un53h25m+XZfL+LHgVTg5FOBizzr5JckdkgoChYeLoaNK30V042nABNJIDMoKBl3mYiwH2hTl5GKWWvmPq7pjsJIqPtBo/AW2nRjSXcnLUx0Wx8CDc6Ix/0anPY5f7CX1pSF8RrfoM+WeHlwVtxs0zsqgKJ4ur+IJVcmQ4AYftuxTreUbNfYytOEMYk/GsJBAW0X5xypKcnTh22Yv+nlRmdaPPgZNHJRBv72XaWEwGUQnpANvyguTWvHqEFArCZoezOAjTSMNqs97092IkVInEc+/5NS5KX4CzpwuTZKD+/KH4Hh4D4WnOvPS2Wwth8N09s/rKHlwlS7tIVhjSxDnpl+FIB/5+/px4V1gMMom2Kw6gcVqLH3TP8P68VoX7iBS8EWXlxyKQDdQGoGp4T75xUl8dwQj/uD2CIPIywWB28Q6g07BrZZpgTtkA5jUcqUoPVoFop/bdZDv+iXSEosAXHKewCK2NqGkMkAfX9gKOJO17iXuOp7VA9wM70CVNcZg2xOOgxMf5xBR4We31DldtfDXXbU9uEvMlOybogbbna668xOkcOq5ljOauEZ8oYZgdyS+5D68C9
 0u2bg2sn
 nkCrAnSPZ+PU6C7OB4I9r5C+DpcD3A3UXrbpE4Hf3KCqhyR9JIJqLc0J8894RoNjCo/QuOvLUNxT6oiu4NrwWXxos7QpgeTIJbdFxrY0uXU+UHZp9PPcJoLCn6gk65ubQPbaL5OOqqJ015pS2KXND9RMarJsJ+cgM5tEPJeY9bJd16NhscbKBeps34alPXEexuzBsb90oj35N8ozwhlU+Nrp4vb/rli/gUTDDcyQABO6wuYMM2v0Yqxgd/otnF6b/mvJe0ZzeBK30qKZySvjvv/FsuRfSzboYeZxAwZ25CE4oFaRfAs9l/3sZ3hVFcDk0iilzrJ7F03ojlpt1ixcb8YyKOVv4xnybO3nmNW66/7cXsQAcDHYt4SHKsdFoC29Ccd+UJVNbfnJ6YEH2CoWWzdSeJayL4W0IDg0G3ne2fchcjgXCR+SS24TEjkWmK4hIhd+jzUQH1jOm/hcpv/I8RoR9E46NXFk53wwNMGgaGNjfW+o=
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
index 0faef46806e5c..512a3a1c63c73 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2165,7 +2165,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (folio_dup_swap(folio, page) < 0)
+	if (folio_dup_swap_pages(folio, page, 1) < 0)
 		return false;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 4686875a3adde..e3db6e45cae0c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1958,7 +1958,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		 */
 		shmem_disallow_eviction(info);
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index d488a69c28091..cbcfd587aac1a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -245,7 +245,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *page);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
@@ -387,7 +388,8 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
@@ -489,6 +491,18 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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
 static inline bool swap_cache_folio_mappable(struct folio *folio,
 		unsigned int nr_pages)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fcda5eba17140..d46cb1cf6469d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1860,9 +1860,10 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1876,18 +1877,15 @@ int folio_alloc_swap(struct folio *folio)
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


