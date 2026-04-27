Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D3FFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138526B0092; Mon, 27 Apr 2026 07:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F876B0093; Mon, 27 Apr 2026 07:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C466B0095; Mon, 27 Apr 2026 07:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E862E6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:43:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2316C05D7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:55 +0000 (UTC)
X-FDA: 84704151630.10.71B32E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7D0320010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQW9hfF6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iIvsKUSLPSqOC7LASd/blaVCoWcBvdh9S05e9HWDX4=;
	b=2jk3nI/PJXFtUrxXtpZhR9jhMcACO/iSj3fzbxP/Ff5RMUOQdxU9z9cbs373pWZNQURB0T
	Z0917TARK1cqMPkdYPL6vQdsEr2Fwe3BtlvGbby7+UhY3i2oZhu8vDDtEdEh5qugP2kogg
	VyKFhVp5FJ6VfU0cm0qNhXRB3LsaISs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290234; a=rsa-sha256;
	cv=none;
	b=43rh5RRBpFpJmKuF9zFKChPoZGX1egpWZCBMvN2fEwOOJB7d47aTh39zYSKszuMAMoSZzf
	tLIjWYXwC6j8m7C6ej6BrnvQa0OEVQrvbnt6mDvzqrqK0u4Phw4TjHC+LpY82/aUav9pJh
	ULKxhzS3tIAdchXjYEhX8h5mGz1JA4U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQW9hfF6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DFE1437E2;
	Mon, 27 Apr 2026 11:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9269C2BCB4;
	Mon, 27 Apr 2026 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290232;
	bh=pUuKH5IboberfrNDLhIOBfcC/4kG/ZkfQ05hwuIAsi0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DQW9hfF6jbPLDZeRU55aAhUUCT+ODmFhcz+2ZZizkNRvhXKvkqWrj2dXV0dCgyT6W
	 WmHOUn7XStj9o+DVmnTv9Wt9Zuky4P03OyheRANyJvSyV6Nn0sfDb6nFmAY4pf7Vhs
	 xdIH43SfcwV/iFb1pUqd3/tkCNUlwR1iB80R9wYWRb871lwJGAkb1nqcsYSU9PqGoS
	 kDpNwk8LJ4Y7KiS5Lfaq7zig8wnCe9GcbvkfrYJ3OcafuKDgfhqvDU/R1HACev+TFT
	 p8om3koW4hnwmMScX8R5DXYYF896On9OeeQBo8nKhJWIF0pdQjGYbiLfAKZrNXunWg
	 RloiRLMR5QZQw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 27 Apr 2026 13:43:16 +0200
Subject: [PATCH 3/3] mm: remove page_mapped()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
In-Reply-To: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7D0320010
X-Stat-Signature: diieeg9ymabmofdgxgeqwu7jm8sshncd
X-Rspam-User: 
X-HE-Tag: 1777290233-925900
X-HE-Meta: U2FsdGVkX19w1cCbbemZbMDPhP/5cweqxBc3UoaJQrmj/pne9Dwckz54pSrEYYqnk4kt358Z7x+xHZygn4sJjTNn66IZJOOR6k7sJuPeSzbSYKlQgdF0siO8R7Spp0YYs8OTZtA7khZq3r/WH8WY65pWHizamWVmipYPBLVgaC9a07t9eCX8t33XdsOK1YcG7PB+TrNBazFEgoT9ULxrkvEZoAwVAPSOT3/m7rdasQmMrYXKVxkaqKwBAF5jhfatHkzzboAOEEcsds3BBkfopNITwHPF+AiPP3luI3RP+DuepgFjCOy0Dr3BpZcYr+8wptbT++fO7KjnSGRDMrYvPTgYCv6edV7lX+vn9pMNQ+kduFoZp1zEaSrGxYGApqpmhz9QpinyD72AUCxoDF9LlFeYQEuRAGAj+T6fbJ+axRNmXM6z5d5A5RMJf+B0bOH9Ie8a0auwaCqm9ZMPXPgbkxkw+5WZhMQteItSBsNWo4l3x3Y0QdmNFqK2rihPt2eU+o3h2DLT+rUwWqJQzj8/j3a7kxmEPcX9GD2BSbBa91qeTLHAicK1nluYGXIrA5QnjH0sBqDvf5RGbybXrQXN+QhSjWxIJk/HK/8os/j8/wkHnCBWYlwgtZD6WpRsL8d4kErVxYhC7PKNnMya1JqB4YWKg44GqWLjWBs7zhiEz1YUdHtKd4KhVpyjAg6wcMYZQs+C/cBnnVHNVspO2r+CwPeu+lkBHj2QH7M3Anwlu9qfq8m6QiQ6IreDjNYhhNp9Y478hwHlZBlO0NgzlPgoCjxAzypntBjPDhaN5hcsGCWv8Iyl/jpK0anOAoGWP+Pi0vZDZ+WsC/wrT53wuo0sgVo4kbMcDbcVjhtPK/r8Z1P5eNIponc3VFUIzZXD7muPE7481Nu+6f/aNnQBajqIhFWncGFy+eQma+DFc9xzXAAihw4jKUHHD2u3mpj/HcHLE87EJw4oGeR9lukXchC
 m12vIdhA
 pwWR7hsHbEuDEMpfTucnNM0vhAR4dWzgV0BWu1bvQLQTORmCRUrCQPD3cIzLJFsN+wr3rViJcouoCSo9ZOyC3fahPxNY7UwwgZt9NtXNqcm569P6DcV5+Xg6wp+pBW4zQYTRPLPiAwUMwtmDWoThgVQPRU3V3S7PMPnHK1SSjQre5UKPQV9IGuaKFJQDBHD9hPsV4XdRsPO0hFP+OpuWq/M7NzhcxDyXmc2hOCcPA8Dw+nBZq0uQmijrnVdic/1tKegZSjcdxGI76lrwRLD5H58BF/Lj0RJu8TvzMEOlBrPji2zw2Cwe7c23mnV9KaVrO0LGqnha5wQbISx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's replace the last user of page_mapped() by folio_mapped() so we
can get rid of page_mapped().

Replace the remaining occurrences of page_mapped() in rmap documentation
by folio_mapped().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 10 ----------
 mm/memory.c        |  2 +-
 mm/rmap.c          |  8 ++++----
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..87fcd068303a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1888,16 +1888,6 @@ static inline bool folio_mapped(const struct folio *folio)
 	return folio_mapcount(folio) >= 1;
 }
 
-/*
- * Return true if this page is mapped into pagetables.
- * For compound page it returns true if any sub-page of compound page is mapped,
- * even if this particular sub-page is not itself mapped by any PTE or PMD.
- */
-static inline bool page_mapped(const struct page *page)
-{
-	return folio_mapped(page_folio(page));
-}
-
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..99854e6a2793 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5464,7 +5464,7 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	if (unlikely(PageHWPoison(vmf->page))) {
 		vm_fault_t poisonret = VM_FAULT_HWPOISON;
 		if (ret & VM_FAULT_LOCKED) {
-			if (page_mapped(vmf->page))
+			if (folio_mapped(folio))
 				unmap_mapping_folio(folio);
 			/* Retry if a clean folio was removed from the cache. */
 			if (mapping_evict_folio(folio->mapping, folio))
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..fb3c351f8c45 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -571,7 +571,7 @@ void __init anon_vma_init(void)
  * In case it was remapped to a different anon_vma, the new anon_vma will be a
  * child of the old anon_vma, and the anon_vma lifetime rules will therefore
  * ensure that any anon_vma obtained from the page will still be valid for as
- * long as we observe page_mapped() [ hence all those page_mapped() tests ].
+ * long as we observe folio_mapped() [ hence all those folio_mapped() tests ].
  *
  * All users of this function must be very careful when walking the anon_vma
  * chain and verify that the page in question is indeed mapped in it
@@ -1999,7 +1999,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
-	 * try_to_unmap() may return before page_mapped() has become false,
+	 * try_to_unmap() may return before folio_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -2426,7 +2426,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
-	 * try_to_migrate() may return before page_mapped() has become false,
+	 * try_to_migrate() may return before folio_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -2927,7 +2927,7 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 
 	/*
 	 * Note: remove_migration_ptes() cannot use folio_lock_anon_vma_read()
-	 * because that depends on page_mapped(); but not all its usages
+	 * because that depends on folio_mapped(); but not all its usages
 	 * are holding mmap_lock. Users without mmap_lock are required to
 	 * take a reference count to prevent the anon_vma disappearing
 	 */

-- 
2.43.0


