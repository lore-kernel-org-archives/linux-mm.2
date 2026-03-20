Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 516261099B36
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B688A6B0139; Fri, 20 Mar 2026 14:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40CA6B013A; Fri, 20 Mar 2026 14:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A566A6B013B; Fri, 20 Mar 2026 14:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 944426B0139
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:42:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32E5C8AFAB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:42:07 +0000 (UTC)
X-FDA: 84567311094.16.467A486
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E28DA0013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:42:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M5oOwz0D;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774032125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rN4D+NzQsYNbSxB+JvjqFly7NPVq6QkCg8cLNr+Qzw=;
	b=WBvXZ83R2m+s2AneQzJT3stRt8KODSKT5v/fj6w5J3RE0DpD82FZFTNmN34hf6VVqRoUQ7
	mFgddQt+dz8WOkoBM/5YGGYe85+3ZrVFtoM6ww0EJgyTYObcDASP/F1Iq6GoFv06b55m5N
	5KJ7mM9dkRtBkWhHvaPOMMTiAjiPvXA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M5oOwz0D;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774032125; a=rsa-sha256;
	cv=none;
	b=Br5KdpH00g1TuPjHGLmIfZe+XSitYZem1oYqfS3HquJUDrNXV7pKhkKhoEpb9446ba9vj5
	d+lfowD6rVTza3I8DU8I1mLGV5cIQz6FmssXY2CrgC6S+pDq5tqPkxNV5OvOX/RTSAjuyD
	ge/+RkcD4OS0/ReVP7XQrBMQwfu0VRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9C2A60126;
	Fri, 20 Mar 2026 18:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24243C4CEF7;
	Fri, 20 Mar 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774032124;
	bh=k60VAliyD9e7Jl3y8MTPF7eUTQbTmx5vspuyZkF1b7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M5oOwz0DIXcF++ngTUjv/9dAJbzfA6WH8yBsnWcfBXFBcC2Xt0n2w6+yo+yZf6rmZ
	 oE35H3aTlgNP6bRaw77kuybonV36iYt6+pPb1OWIqvwBK/5a4g8QXFtluy4yO8sDSl
	 YDbGtIvzCYzE8/74q2y5oGgKLqU2dCrgZGqoFWJM=
Date: Fri, 20 Mar 2026 11:42:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau
 <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260320114203.b1d0e565162c68b965aa5cb1@linux-foundation.org>
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E28DA0013
X-Rspamd-Server: rspam08
X-Stat-Signature: zpptqnwtkqt8ou17h1mnjfwdpif3whww
X-HE-Tag: 1774032125-620773
X-HE-Meta: U2FsdGVkX19lvFXpQYNCo5QoTuiVX0k4PdZXlGsc1H1WgcVAtp0mAW6VpyT+I5Tmgba+Jkd2QoCmd2fGXAAdE32YUJy6IZnht2BVHFk6JqJfG4m1cHNEwkBhGsodoVdNItZysekfg07ibj1ZUn6rTR24pcIDMhE03IZlI2XI3N6A0NPiexn1RZQMMjvEZCZXY/i4oSc+kRHJw7JVyxPqiqEkB8WtoRaBpq2GXwmL/uX0JAwxLuuD4v4KB1T/sx+GL15wk1unTmKz/7hRbBxA5HBtYUT+TVj8w7oo6DXtAATYE5T4iRkcIhG23erIuAxZRZT2fv9uqrcwFNnWM4bSdH4Es6T9/A1NU9X5Pv+AFahU8lHnqQqzQEUs6mgKW+cHD8ZXKgM6OqdCP3J9hmq/RH6VYPiS4YU042r2YiQ1c1SWrjCAgne6Fh/FDJ34EwiFRFAiUGz5glZdllLkD1avBEK8JDKKIyy89Z7+FdD2aSZpJsYJeAX91um+N8AhBfUVZwR0cR2LDuHmUx9XAGM6paiHsgrl38QdUmMmHvenBrAGKoibCvkd+PHygirvQ4uJD3nZXsIdh4dUYB6+AkBKszxrS6DDdYYotRSocQ8hCcxgSLsi/YSThZ81r2+zfwOy5FeJNrRjHv9olBXP8PsHEy4JWSeadDkVFvybZ+5XQsrnE5HQ3R/Itu79XBr7IOmfu/A4domB+URQl0n3ib0peBUPVmPwAvrI1+BH/65c7AgEbMlFfWX0OJ69l2lyoCgO6BPAnL57lX/fjj7iPWFGl0DSI6Cs3nzMAmDfqzpFXzpqDaldF6CzakPCo9m/2qdVGvGjV1z09sXFPMeZ6BkMBRruDYR07ItmLd5nRP7Nwze7sYKXiA+TgADArvb8b2meKjycDt9oPWEIZzxMZ0/gwyC+HHSPO5PROklfITmS0/V/FmR5VqeKajlVs/DUZbYHNh1CCkiSbqiztwaJlKL
 dRpD0Luw
 7DDJiUFIhEc3Lyy9mg8K9Yc1IpjZMgyeZzvdWwglwxMIdjDyfAUO9d5ya30Ai/pY18DDOX1de6s9H1Ehk2/2Fe/bur3fsK20cIMGIdpZn534zPErtIeZavPoI4g9zTs74KsJj+ZTxQdOJUl6rbhCK7fI9/BsAUIBNN2yFFonA6OK5O+XkSEoLF2r80bsfKr0K86ti8JR8AGKrd2SY2AzWd222taJcAM1gaDCHkmOsk1pKgyUTUUkxEdc0sB7a0KQB3Z0HNhgSHgfGCTSr4MG83CMrlfdeiZhHpOEpMqjJGqrjmEb25Sb4Oknx24ja2tGagx7v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 18:14:50 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> The zap_huge_pmd() function is overly complicated, clean it up and also add
> an assert in the case that we encounter a buggy PMD entry that doesn't
> match expectations.
> 
> This is motivated by a bug discovered [0] where the PMD entry was none of:
> 
> * A non-DAX, PFN or mixed map.
> * The huge zero folio
> * A present PMD entry
> * A softleaf entry
> 
> In zap_huge_pmd(), but due to the bug we manged to reach this code.
> 
> It is useful to explicitly call this out rather than have an arbitrary NULL
> pointer dereference happen, which also improves understanding of what's
> going on.
> 
> The series goes further to make use of vm_normal_folio_pmd() rather than
> implementing custom logic for retrieving the folio, and extends softleaf
> functionality to provide and use an equivalent softleaf function.
> 

Thanks, I updated mm-unstable to this version.

> v3:
> * Propagated tags, thanks everybody!
> * Fixed const vma parameter in vma_is_special_huge() in 1/13 as per
>   Sashiko.
> * Renamed needs_deposit -> has_deposit as per Kiryl, better describing the
>   situation as we're zapping deposited tables, not depositing them.
> * Initialised has_deposit to arch_needs_pgtable_deposit(), and updated huge
>   zero page case to account for that as per Kiryl.
> * Dropped separated logic approach as per Baolin.
> * Added 'No functional change intended.' caveats.
> * Removed seemingly superfluous, inconsistent pot-folio_remove_rmap_pmd()
>   mapcount sanity checks.
> * De-duplicated tlb->mm's.
> * Separated folio-specific logic into another function.
> * Added softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio() functions.
> * Add and use normal_or_softleaf_folio_pmd() to make use of
>   vm_normal_folio_pmd() and pmd_to_softleaf_folio() for obtaining the
>   folio.
> * Add and use has_deposited_pgtable() to figure out deposits.
> * Added a bunch of explanatory comments as per Baolin.

Here's how v3 altered mm.git:



 include/linux/leafops.h |   39 +++++++++++-
 mm/huge_memory.c        |  115 ++++++++++++++++++++++----------------
 2 files changed, 102 insertions(+), 52 deletions(-)

--- a/include/linux/leafops.h~b
+++ a/include/linux/leafops.h
@@ -603,7 +603,20 @@ static inline bool pmd_is_migration_entr
 }
 
 /**
- * pmd_is_valid_softleaf() - Is this PMD entry a valid leaf entry?
+ * softleaf_is_valid_pmd_entry() - Is the specified softleaf entry obtained from
+ * a PMD one that we support at PMD level?
+ * @entry: Entry to check.
+ * Returns: true if the softleaf entry is valid at PMD, otherwise false.
+ */
+static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
+{
+	/* Only device private, migration entries valid for PMD. */
+	return softleaf_is_device_private(entry) ||
+		softleaf_is_migration(entry);
+}
+
+/**
+ * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
  * PMD leaf entries are valid only if they are device private or migration
@@ -616,9 +629,27 @@ static inline bool pmd_is_valid_softleaf
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
-	/* Only device private, migration entries valid for PMD. */
-	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+	return softleaf_is_valid_pmd_entry(entry);
+}
+
+/**
+ * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * @pmd: PMD entry.
+ *
+ * The PMD entry is expected to be a valid PMD softleaf entry.
+ *
+ * Returns: the folio the softleaf entry references if this is a valid softleaf
+ * entry, otherwise NULL.
+ */
+static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+{
+	const softleaf_t entry = softleaf_from_pmd(pmd);
+
+	if (!softleaf_is_valid_pmd_entry(entry)) {
+		VM_WARN_ON_ONCE(true);
+		return NULL;
+	}
+	return softleaf_to_folio(entry);
 }
 
 #endif  /* CONFIG_MMU */
--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -104,7 +104,7 @@ static inline bool file_thp_enabled(stru
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(struct vm_area_struct *vma)
+static bool vma_is_special_huge(const struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return false;
@@ -2325,6 +2325,63 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
+static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
+		pmd_t pmdval, struct folio *folio, bool is_present)
+{
+	const bool is_device_private = folio_is_device_private(folio);
+
+	/* Present and device private folios are rmappable. */
+	if (is_present || is_device_private)
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+
+	if (folio_test_anon(folio)) {
+		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		add_mm_counter(mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
+
+		if (is_present && pmd_young(pmdval) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
+
+	/* Device private folios are pinned. */
+	if (is_device_private)
+		folio_put(folio);
+}
+
+static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t pmdval, bool is_present)
+{
+	if (is_present)
+		return vm_normal_folio_pmd(vma, addr, pmdval);
+
+	if (!thp_migration_supported())
+		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	return pmd_to_softleaf_folio(pmdval);
+}
+
+static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
+		struct folio *folio)
+{
+	/* Some architectures require unconditional depositing. */
+	if (arch_needs_pgtable_deposit())
+		return true;
+
+	/*
+	 * Huge zero always deposited except for DAX which handles itself, see
+	 * set_huge_zero_folio().
+	 */
+	if (is_huge_zero_pmd(pmdval))
+		return !vma_is_dax(vma);
+
+	/*
+	 * Otherwise, only anonymous folios are deposited, see
+	 * __do_huge_pmd_anonymous_page().
+	 */
+	return folio && folio_test_anon(folio);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2337,10 +2394,9 @@ static inline void zap_deposited_table(s
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	bool needs_remove_rmap = false;
-	bool needs_deposit = false;
+	struct mm_struct *mm = tlb->mm;
+	struct folio *folio = NULL;
 	bool is_present = false;
-	struct folio *folio;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2357,56 +2413,19 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 	 */
 	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
 						tlb->fullmm);
-
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
-	if (pmd_present(orig_pmd)) {
-		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
-		if (folio) {
-			needs_remove_rmap = true;
-			is_present = true;
-		} else if (is_huge_zero_pmd(orig_pmd)) {
-			needs_deposit = !vma_is_dax(vma);
-		}
-	} else if (pmd_is_valid_softleaf(orig_pmd)) {
-		folio = softleaf_to_folio(softleaf_from_pmd(orig_pmd));
-		needs_remove_rmap = folio_is_device_private(folio);
-		if (!thp_migration_supported())
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	} else {
-		WARN_ON_ONCE(true);
-		folio = NULL;
-	}
-	if (!folio)
-		goto out;
-
-	if (folio_test_anon(folio)) {
-		needs_deposit = true;
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	} else {
-		add_mm_counter(tlb->mm, mm_counter_file(folio),
-			       -HPAGE_PMD_NR);
-
-		if (is_present && pmd_young(orig_pmd) &&
-		    likely(vma_has_recency(vma)))
-			folio_mark_accessed(folio);
-	}
+	is_present = pmd_present(orig_pmd);
+	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
+	if (folio)
+		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 
-	if (needs_remove_rmap) {
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-	}
-
-out:
-	if (arch_needs_pgtable_deposit() || needs_deposit)
-		zap_deposited_table(tlb->mm, pmd);
-
-	if (needs_remove_rmap && !is_present)
-		folio_put(folio);
+	if (has_deposited_pgtable(vma, orig_pmd, folio))
+		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (is_present)
+	if (is_present && folio)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return true;
 }
_


