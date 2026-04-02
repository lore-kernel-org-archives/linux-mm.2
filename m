Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D137DD39426
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E8D6B0089; Thu,  2 Apr 2026 10:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398836B008A; Thu,  2 Apr 2026 10:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2130E6B008C; Thu,  2 Apr 2026 10:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 100A16B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:16:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 877C21B8851
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:52 +0000 (UTC)
X-FDA: 84613817064.04.DE90975
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 403EA160008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775139410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzVKzHT2p8fRxlicUECUCdtcTbPCIPI5qsyNT9fVVBs=;
	b=TyUYKkCeXJDSSKXw632FuGShBTrxGno0ulA/SjXwTAd5mCVuQQfnFZ5EqwGpDjOV4OsCtc
	seNahazr4afZUu2r1ehtCoRM+r6pizqqUQ9bCimuPhxCNkTdnrVnBi/tvzIPh4+4I+76+q
	dVmiKPc8OR/NQAsstghMhjGXcu+OjoQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775139410; a=rsa-sha256;
	cv=none;
	b=HvabU6TAw/DfDOo+0gwlvJtrVM1p0fQkHBlhOtKBv9usoxaOCbHNA7eouDFjYDY2KKx1Em
	jlzU3jY1Y6STgYkGRFFAX6Z78Eafk/7+/Ohk3QLGiUgKbVzMiacTPTubwadeVY8QrdfmPl
	C59txdX1x5rT7U9qmJH3if1CfWuQpcE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC93F5BDF8;
	Thu,  2 Apr 2026 14:16:48 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 109BD4A0B0;
	Thu,  2 Apr 2026 14:16:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UM2lAFB6zmlQDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Apr 2026 14:16:48 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] mm/mprotect: special-case small folios when applying write permissions
Date: Thu,  2 Apr 2026 15:16:28 +0100
Message-ID: <20260402141628.3367596-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402141628.3367596-1-pfalcato@suse.de>
References: <20260402141628.3367596-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 403EA160008
X-Stat-Signature: ktnp9gqyf369bd367rpkt1ur3r61wh8q
X-Rspam-User: 
X-HE-Tag: 1775139409-118327
X-HE-Meta: U2FsdGVkX19rVva8L2uUaJMq+ZoxEA7+qWPRaNDLfys6k1xeBwblA/UDvTHwhSvbTMNJTNu3YXHypw2tK8N2GsxabETjHVAI6aRhtjwl5VSnEudiF0X7zoGuJweEpdtBpEiTPD8ktf/hgNuU6NbqmvxURnFE1qDcvlcFZNtLpb1weiftqFIBF0TwYXe8SO3Xl6EIX/+aEckhf+n/55yWP7OWqhx0VgbKfhI8akkQMZtJOZY6ysdi4zcedrpnDl3m2Yj+zO/EueqM+6KcgqG4zJ5bPylZjdvuHQOwr9369y7wdtPEZOk4Y5xn0CdkYqmG58I/Hb+v+73NQ1R8q7WirIl+8TyCqLUFXgjZ9SRSm6W41v09fHk7kbetQKhkHig5Vw7fw6Hu5zXK7/7xR81x3eLRYS2sfkAqk14KFeMKsxFqrKonDAyBMyQi6CjqnpiHBpIXlTg9PHpxPGnr8wpdQ3xqYvZf7xF7dX1A88ypGbgh5szsFxY8v17fNMgZWWvVw2qm/p7q5NsTirRuuQJZrUICc9+du732Lyco6SzDATrF9BsarDzNhQIonPu64oGCzZdSgsDBgw/iRx2OPM4orRIWDyDnMbcyXsegnM5bsal7N7oq22//vtE2Ce0eoBjZncN00BAFwbP7XoFknHXVWtE5Pxh+m/q8QdUpkRkPrlZeRB8ZSoWVewqBw/pcWbdQUzyvXOg/qxt50bDailadZR6lQBOIpYZEzHu/NkmafuSblZXaW9Nvv869CCInXd/hKeuADYAAOW0jEdmMeE+UGzcEfmvMEmAztsYxJMph8G7bfYPjeyIauxLPvFY4Z13K50ci2piPJ7GiWuc2coguKiC7bncrBamGQFjUuAKXheKDclhE1sD9hSeecr5O0dxAtx99O0K6zCNiUzEH8i8N2csQCeAIJgivFORZmr6jmYn40ckfz6QWqbRFStGJCOh+6bbetfwyN8hi0W/khnH
 L1ax56Xq
 q6hKppm+1qW9OSgJXa/d9bXLD5NRcwX/oMcBJhq8Sv1iTCn4HcfZDr27LFK8RxLQo4n/S68z9P9xQ7qEdlTATksob+4bhFgiTNpxStLllA2KsiOYMyrGqx48gvsGgoRDAP0EGdor6ikreuVaC7ZEu7BDnI2K61rrbjVMT0vbQurycq9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common order-0 case is important enough to want its own branch, and
avoids the hairy, large loop logic that the CPU does not seem to handle
particularly well.

While at it, encourage the compiler to inline batch PTE logic and resolve
constant branches by adding __always_inline strategically.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Tested-by: Luke Yang <luyang@redhat.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 91 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 34 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 5929ce792c7b..98da856e3a52 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -143,7 +143,7 @@ static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long add
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -188,7 +188,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
 	}
 }
 
-static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
+static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -277,6 +277,45 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 	return 0;
 }
 
+static __always_inline void change_present_ptes(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		int nr_ptes, unsigned long end, pgprot_t newprot,
+		struct folio *folio, struct page *page, unsigned long cp_flags)
+{
+	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	pte_t ptent, oldpte;
+
+	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
+	ptent = pte_modify(oldpte, newprot);
+
+	if (uffd_wp)
+		ptent = pte_mkuffd_wp(ptent);
+	else if (uffd_wp_resolve)
+		ptent = pte_clear_uffd_wp(ptent);
+
+	/*
+	 * In some writable, shared mappings, we might want
+	 * to catch actual write access -- see
+	 * vma_wants_writenotify().
+	 *
+	 * In all writable, private mappings, we have to
+	 * properly handle COW.
+	 *
+	 * In both cases, we can sometimes still change PTEs
+	 * writable and avoid the write-fault handler, for
+	 * example, if a PTE is already dirty and no other
+	 * COW or special handling is required.
+	 */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
+	     !pte_write(ptent))
+		set_write_prot_commit_flush_ptes(vma, folio, page,
+			addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	else
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent,
+			nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -287,7 +326,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	int nr_ptes;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -308,7 +346,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
 			struct page *page;
-			pte_t ptent;
 
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
@@ -334,34 +371,20 @@ static long change_pte_range(struct mmu_gather *tlb,
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
-			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
-			ptent = pte_modify(oldpte, newprot);
-
-			if (uffd_wp)
-				ptent = pte_mkuffd_wp(ptent);
-			else if (uffd_wp_resolve)
-				ptent = pte_clear_uffd_wp(ptent);
-
 			/*
-			 * In some writable, shared mappings, we might want
-			 * to catch actual write access -- see
-			 * vma_wants_writenotify().
-			 *
-			 * In all writable, private mappings, we have to
-			 * properly handle COW.
-			 *
-			 * In both cases, we can sometimes still change PTEs
-			 * writable and avoid the write-fault handler, for
-			 * example, if a PTE is already dirty and no other
-			 * COW or special handling is required.
+			 * Optimize for the small-folio common case by
+			 * special-casing it here. Compiler constant propagation
+			 * plus copious amounts of __always_inline does wonders.
 			 */
-			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio, page,
-				addr, pte, oldpte, ptent, nr_ptes, tlb);
-			else
-				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+			if (likely(nr_ptes == 1)) {
+				change_present_ptes(tlb, vma, addr, pte, 1,
+					end, newprot, folio, page, cp_flags);
+			} else {
+				change_present_ptes(tlb, vma, addr, pte,
+					nr_ptes, end, newprot, folio, page,
+					cp_flags);
+			}
+
 			pages += nr_ptes;
 		} else if (pte_none(oldpte)) {
 			/*
-- 
2.53.0


