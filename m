Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B7CC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37AEE6B009D; Wed,  8 Jul 2026 07:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352946B009F; Wed,  8 Jul 2026 07:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240446B00A0; Wed,  8 Jul 2026 07:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA0646B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75951140703
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:40 +0000 (UTC)
X-FDA: 84965351520.09.0D72890
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8014D4000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d au5zvt";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OKpLC0QW;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509278;
	b=jBJcXioHP1HH+rmA17Gnm05KQAL+DG3VCDd9Ql2hpMVJGAqAQRZllZcjGtKjv4YcTsjkgF
	AnrBSnee2rAbVsBROAErLRA9FYALmNCnPMPRDNnRbzIy1k3Baly+EpLlP0NrkcVrfvG5mu
	qbmkeUZonPeieCnNo8YFdzBUCQkSdro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d au5zvt";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OKpLC0QW;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp+Wsewks2v6RX+ku6BeqtejUaKDMSd3VYhwUaGC5xU=;
	b=aNGVVBiqMrBtKN/vt7qgVmIgqu/8dz5cKd6rgHskbPkjwPBZiwNdiIrCjCDWh5chalj8pl
	+zUyt+EULN01NmTJPB3emhaGcqYvoDcBz7rlZkKcGN64qgZYPOmudJSqwNaoT6AJWDUbJl
	8CZU9ZtFWZxlpQXS5AHayxiDE/mwhU8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 619AA1D00121;
	Wed,  8 Jul 2026 07:14:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 08 Jul 2026 07:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509277; x=
	1783595677; bh=kp+Wsewks2v6RX+ku6BeqtejUaKDMSd3VYhwUaGC5xU=; b=d
	au5zvtZ3kfd3Ji8YBgpKxPcGPnSNt7Yn4n37trjq0Auh+oK+5CYDz+2vkTkPuM2a
	AEo9K0j5370szUm8AFUwi0MuAqqF0U4iYY7H2nzOE1jtH8RI9rFdFxQcJLGRkdg9
	+4YVvQ26jnM5thJQqjekC/XnsFNFIl7c5exGNeGwUDEUHKM00Mdm5pNwnddKXx3I
	i0wWIZrMyVaavKXSNd7eEd42Qz/tlzNuPbcqLGBhaERrKin9L9M4lCTLTbLpqr0T
	C8IJ1rDzEv1p60kgF4qgPasSvKqli0g5etVEhZlfchQ2RQbHrhWbty4h8NeWG3GI
	oLIDCmM4MrqIsiddXUhwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509277; x=1783595677; bh=k
	p+Wsewks2v6RX+ku6BeqtejUaKDMSd3VYhwUaGC5xU=; b=OKpLC0QWlgupyzBdC
	K07LhbnCCdJshxRg6bAG8cVahNvyOWBaICcoh9KSlRleYLXNtFgViTAa+lFihdUd
	AF2MT4dGQ8sHplPoYdjidGpqIxB2WRV5Z5fblzwDfBSFcrcpXkMF9LTnZW17abJA
	GDQS4SWIA8jrzzeTjhFTpPhuCDhxyvkrSXZ2R3Z1O5EGA1846ezHh1RKwEmBWa3n
	d/AmRWvVWesi6CbhaWJiC5IwUzZzG0xVcUjIQwvjA2XYY37eyK5iN4wulp7CgVBS
	ydd3QHWvWSx9KMi3Yfme3PlO30c0hYjc7zTtmkFHGzMYDjcxuFojydSdZ99Vaz7F
	tS/qg==
X-ME-Sender: <xms:HDFOapaWjH4324V8NHVNezwUfN_f7Et4PLLre9z-h4fFSrQi8MuAPQ>
    <xme:HDFOakUpmeULLt9qL3fq-CUF793NRReXG44LxdDH9PaOOAf6F2WMH_gnYDYPAd31X
    jJh52TUS6dF-k3HsFWfI9z6Wd9IYqA4NyGp3XmlXZPIyJ6XewPQJuM>
X-ME-Received: <xmr:HDFOakfQo4fyXmaPZ4gy9XiMdc8kS5TVylqwH1AMcBxl_6pecIZjwV3JELYbvQ>
X-ME-Proxy-Cause: dmFkZTGp+lp1jxge+zfWWQDOmFev1Aj93weD2lzg4uPZWx+Z3SZe1CWKpSY34hOQnXWdCH
    X3J4fIJFgTBESvc4xWiwx5/MD14dlgPgF9nEAAA62nAEEbDoeWJIotrsSVP/3RfCG4AL69
    GWjO5h6ISMv13p/WrSnOtYbJToRcDYMu+oxe1Md/9ogUnUkXvzdGTImpAvqmGUHyhNQHgM
    9EFSvv/v+Vr6S4j4lzrtAd/spoCmUPXwfzSzofPeR7pTVQTh2KO7mHNCViFZXuf2LlCk37
    tL6Z2TITbN4EPiDlJfbqtg+HqWMejqgZ48pmgyHt4ULCT1Smmr1CePpfQyTeBk4h4LlJLe
    baZDaB+Q5BfcKPnWnF2hmQGedOgpndarwPK2AoxUnfI4SeZ7zU7sYYCk7500zH2emE7pwz
    KX1SJapmog8U7SfTLkqkyYPLkxWtgl+VBI8w6XqIak67c6KYv0qXsPPyVGcw+b1CJW1q56
    LLFLQ5UWEtBh3BdcCv0wLqMA490Hrlw/6CXLF72eYVvq+24MZMLQMLSTXpk/0v0tQshq4n
    V3Yx4ke5k4CNVYKFqH3hhDl3JmU2kmU88KtmiVwF4d/r9fEytxFF0Zn+Hxag7UY9ZNlIOS
    mX/Avz+S5N/7NsUQamit/xCw6y/FpWYyPDhze2rvJhtn3TO/eFnyQNs4xoNA
X-ME-Proxy: <xmx:HTFOahOJL_MUYYsVrI_wMbqdy4RLpWkR095ZLppZmj1j2tm5Gq29ow>
    <xmx:HTFOasLBsOYOYfc6gqqSpiBFIyidd5vRI-CzT2TAahvqenV3mwHGsw>
    <xmx:HTFOanndd-FeKiogqhjl3AFBUVZg4xt3L7FiSaQ92miXVW_0x8HNXw>
    <xmx:HTFOarYogRql_XTEhQbbaPgN2kS0hKjF46XFzEByiiEeqOyUGYGKww>
    <xmx:HTFOanEDvMbXhFECAR8RgdtBejK19vF1We71dMirrbmlkM-YhL98ZIFJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:36 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v10 07/15] mm: preserve RWP marker across PTE rewrites
Date: Wed,  8 Jul 2026 12:14:08 +0100
Message-ID: <20260708111417.173443-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8014D4000A
X-Stat-Signature: kdkj1hwi8y7wd7uk75xzt6pai793cu8m
X-HE-Tag: 1783509278-780718
X-HE-Meta: U2FsdGVkX1/m1TKah+e4qChaj2eDscEkrF+iUfRhl4UKXDM1DUAqqDraCyrmV/ASPcOr8pl5kZFU2bbHXKt27b8SMI7Qn0Dmw8ebByr7CUn7pQcAbzkTgfPDq7588jiTGvLvesPZY+PcX4LgLz2yraEWdpF7qJeO9K5ff2xgKefUtymxsgShoTjffDnKz8gIodkmEJdHfHS05vu53pvyxtP0QMb/2Ya2JDajqJ4/27UduTZriuALlTdHNHwmbJxSj4NDnRUmRV9iryjd/e+FDFioPivaCCfXjYDeJXvufDlk1i8W295sYhvLV6Wke2BL4HuPXHMUhbsfjO1i+XM/iFXsdR5/tA8fXSn6UN4gLffoRcJNFSlQHhAqGIBYG3f1bwjaaTTOl6HZS2FFVVwmGSONGX0is8mRbX8HkN+JcodP2HQTbDoKyTPvFtwnFZvVe10bW9d+QtClGOIkFQ0X3GEGwnCfkf3v6aeqMuT3Vo5MGjB6+qYnODOgPyLgiR9JoX0H7qdnCghd8nP+A9nv/uOA+DJHKHgvmblBhQVE3ZRuIS7QPRJzcmqaht7u/Yd5dVeNtMsmJgTVuLCXaokxa/pTTPAHeVJkxXCcUuEQPiMQzugP3VoldmwbXytb1Oh3bTmQ3KXye8XTwIIpT3uMscztnkVfiEa4OuW8P3vJL9adqNJg2+sx+rRXjcky6qPL6Giy22b6a5cilZTjQgiy8GXyxEPE/VDl6j3p9GDFWkEP2tn0V5xcIhm5W3sO441KQ82dmKXPioMhhlmiF0h2Oieaayy+zXJWF3k9vr1YO2RrrMPEmQmXSYuV2gnJHF6GAkC2vQ6DOlcwU5VhT1QrRUsHh0aIxyjVcdJaJqDEuRBvipPGZD5bweo+cHkhaMvz8qdmb2sJbTCTDKEg9okntp6F0g0nnUbXURCOl9myeKTLD3mXHOE4g61iOfZj+zEc5vxdrzjGbRYynXFeAB/
 g58rasgh
 fdHoXex9RCd9LMTbKdb3H3h6UyvrwEKkoyR6Y+tSW4s6dJOoPau76XfyGRFSho7VUUdgs2/3NeH84KwBzI/3G+5yhjuoWxSZdF6DGd/KgwyIg3zetzF7TAJ35uT9Db6x4hRlsL/lx6FxI2YRD4eKDBl0OoAxBtn7aSoW/VdoYKmQGfQsH1iItct0YAiVH+HhOc33ZWxux7c+cs5k20ofU8T16MZdqiIs/cjfLH4WZ0+PPZ291cHihHgU3T21QnoQICz2+fMCOdM+mT+QmaYJlPQ15R40DJ8T3qWiW/WJypuFJ2mgo0O3X3oT+TaU/VrtnhmxVdLgZ7Pvya2/7XxjzioHFNcnwrVlkQfPVJ/9QlrMHJ9OLJiTp2Ojq9uRroF4yImy90d32spn5IptANV8Ie4g880dGKfRii1J4IrNaSdJ76MX+MEHOitcinV7hHaFPrGLe3+EGtRQ4icQlLN+JzlQiN6JXGaW/FH3KU3ZICR4OynvN5cXSkLAHlMzeV/QsKBXPgxD1/khnY2COejT32Ix7+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The uffd PTE bit must survive any kernel path that rewrites a PTE
on a VM_UFFD_RWP VMA, otherwise the marker that carries PAGE_NONE
semantics is silently dropped and the next access leaks past RWP
tracking. Wire the preservation through every path that rewrites a
VM_UFFD_RWP PTE.

Swap and device-exclusive: do_swap_page(), restore_exclusive_pte(),
and unuse_pte() (swapoff()) re-apply PAGE_NONE when the swap PTE
carries the uffd bit and the VMA has VM_UFFD_RWP.

Migration: remove_migration_pte() and remove_migration_pmd() do the
same after the migration entry is replaced with a real PTE/PMD.

Fork: __copy_present_ptes(), copy_present_page(), copy_nonpresent_pte(),
copy_huge_pmd(), copy_huge_non_present_pmd(), and
copy_hugetlb_page_range() keep the uffd bit on the child when the
destination VMA has VM_UFFD_RWP, matching the existing VM_UFFD_WP
handling. Add VM_UFFD_RWP to VM_COPY_ON_FORK so the flag itself
propagates.

mprotect(): change_pte_range() and change_huge_pmd() restore PAGE_NONE
after pte_modify()/pmd_modify() have recomputed the base protection
from a (possibly user-changed) vm_page_prot. pte_modify() preserves
_PAGE_UFFD, so the bit stays; we just have to force PAGE_NONE back
on top.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  3 ++-
 mm/huge_memory.c   | 50 ++++++++++++++++++++++++++++++++---
 mm/hugetlb.c       | 51 +++++++++++++++++++++++++++++------
 mm/memory.c        | 66 +++++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c       |  8 ++++++
 mm/mprotect.c      | 10 +++++++
 mm/mremap.c        | 13 +++++++--
 mm/swapfile.c      |  5 ++++
 mm/userfaultfd.c   | 17 ++++++++++++
 9 files changed, 199 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a567abb90862..012dbb7f4ef0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -684,7 +684,8 @@ enum {
  *                           only and thus cannot be reconstructed on page
  *                           fault.
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
+			 VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0e503ab2493f..ce00ef882c26 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1856,7 +1856,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 }
@@ -1951,9 +1951,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	pmdp_set_wrprotect(src_mm, addr, src_pmd);
-	if (!userfaultfd_wp(dst_vma))
+
+	/* See __copy_present_ptes(): restore accessible protection. */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma) && pmd_uffd(pmd))
+			pmd = pmd_modify(pmd, dst_vma->vm_page_prot);
 		pmd = pmd_clear_uffd(pmd);
+	}
+
+	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_wrprotect(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
@@ -2539,8 +2545,19 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma))
+		if (vma_has_uffd_without_event_remap(vma)) {
+			/*
+			 * See __copy_present_ptes(): normalise the RWP marker
+			 * so the destination starts accessible instead of
+			 * taking a numa-hinting fault on first access. Only the
+			 * marker (protnone + uffd) needs it; leave other present
+			 * PMDs in the VMA untouched.
+			 */
+			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
+			    pmd_uffd(pmd))
+				pmd = pmd_modify(pmd, vma->vm_page_prot);
 			pmd = clear_uffd_wp_pmd(pmd);
+		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
@@ -2680,6 +2697,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 */
 		entry = pmd_clear_uffd(entry);
 
+	/* See change_pte_range(): preserve RWP protection across mprotect() */
+	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
+		entry = pmd_modify(entry, PAGE_NONE);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2847,6 +2868,13 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
 		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
+
+	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		_dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
+		_dst_pmd = pmd_mkuffd(_dst_pmd);
+	}
+
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
@@ -3023,6 +3051,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd(old_pmd))
 			entry = pte_mkuffd(entry);
+
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && pmd_uffd(old_pmd))
+			entry = pte_modify(entry, PAGE_NONE);
+
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
 		pte++;
@@ -3299,6 +3332,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (uffd_wp)
 			entry = pte_mkuffd(entry);
 
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && uffd_wp)
+			entry = pte_modify(entry, PAGE_NONE);
+
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 
@@ -4977,6 +5014,11 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd(*pvmw->pmd))
 		pmde = pmd_mkuffd(pmde);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pmd_swp_uffd(*pvmw->pmd) && userfaultfd_rwp(vma))
+		pmde = pmd_modify(pmde, PAGE_NONE);
+
 	if (!softleaf_is_migration_young(entry))
 		pmde = pmd_mkold(pmde);
 	/* NOTE: this may contain setting soft-dirty on some archs */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d9e93d1d80d9..6f753bad8e78 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4883,8 +4883,16 @@ hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long add
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
-	if (userfaultfd_wp(vma) && huge_pte_uffd(old))
+	if (userfaultfd_protected(vma) && huge_pte_uffd(old)) {
 		newpte = huge_pte_mkuffd(newpte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping. */
+		if (userfaultfd_rwp(vma)) {
+			unsigned int shift = huge_page_shift(hstate_vma(vma));
+
+			newpte = huge_pte_modify(newpte, PAGE_NONE);
+			newpte = arch_make_huge_pte(newpte, shift, vma->vm_flags);
+		}
+	}
 	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte, sz);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
@@ -4973,11 +4981,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				softleaf = make_readable_migration_entry(
 							swp_offset(softleaf));
 				entry = swp_entry_to_pte(softleaf);
-				if (userfaultfd_wp(src_vma) && uffd)
+				if (userfaultfd_protected(src_vma) && uffd)
 					entry = pte_swp_mkuffd(entry);
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = pte_swp_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
@@ -5042,6 +5050,16 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				goto next;
 			}
 
+			/* See __copy_present_ptes(): restore accessible protection. */
+			if (!userfaultfd_protected(dst_vma)) {
+				if (userfaultfd_rwp(src_vma) && huge_pte_uffd(entry)) {
+					entry = huge_pte_modify(entry, dst_vma->vm_page_prot);
+					entry = arch_make_huge_pte(entry, huge_page_shift(h),
+								   dst_vma->vm_flags);
+				}
+				entry = huge_pte_clear_uffd(entry);
+			}
+
 			if (cow) {
 				/*
 				 * No need to notify as we are downgrading page
@@ -5054,9 +5072,6 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				entry = huge_pte_wrprotect(entry);
 			}
 
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd(entry);
-
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 			hugetlb_count_add(npages, dst);
 		}
@@ -5102,10 +5117,23 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 		huge_pte_clear(mm, new_addr, dst_pte, sz);
 	} else {
 		if (need_clear_uffd_wp) {
-			if (pte_present(pte))
+			if (pte_present(pte)) {
+				/*
+				 * See __copy_present_ptes(): normalise the RWP
+				 * marker so the destination starts accessible
+				 * instead of taking a numa-hinting fault on
+				 * first access. Only the marker (protnone + uffd)
+				 * needs it; leave other present PTEs untouched.
+				 */
+				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
+					pte = huge_pte_modify(pte, vma->vm_page_prot);
+					pte = arch_make_huge_pte(pte, huge_page_shift(h),
+								 vma->vm_flags);
+				}
 				pte = huge_pte_clear_uffd(pte);
-			else
+			} else {
 				pte = pte_swp_clear_uffd(pte);
+			}
 		}
 		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 	}
@@ -6557,6 +6585,13 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pte = huge_pte_mkuffd(pte);
 			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
+
+			/* Preserve RWP protection across mprotect() */
+			if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
+				pte = huge_pte_modify(pte, PAGE_NONE);
+				pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			}
+
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 			tlb_remove_huge_tlb_entry(h, &tlb, ptep, address);
diff --git a/mm/memory.c b/mm/memory.c
index 45b98b5601f3..c18aa08c0630 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -896,6 +896,10 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 	if (pte_swp_uffd(orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	if ((vma->vm_flags & VM_WRITE) &&
 	    can_change_pte_writable(vma, address, pte)) {
 		if (folio_test_dirty(folio))
@@ -1034,7 +1038,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				   make_pte_marker(marker));
 		return 0;
 	}
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pte = pte_swp_clear_uffd(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1081,9 +1085,13 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	/* All done, just insert the new page copy in the child */
 	pte = folio_mk_pte(new_folio, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
-	if (userfaultfd_pte_wp(dst_vma, ptep_get(src_pte)))
-		/* Uffd-wp needs to be delivered to dest pte as well */
+	if (userfaultfd_protected(dst_vma) && pte_uffd(ptep_get(src_pte))) {
+		/* The uffd bit needs to be delivered to the dest pte as well */
 		pte = pte_mkuffd(pte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping */
+		if (userfaultfd_rwp(dst_vma))
+			pte = pte_modify(pte, PAGE_NONE);
+	}
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -1093,9 +1101,31 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte_t pte, unsigned long addr, int nr)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
+	bool writable;
+
+	/*
+	 * Snapshot writability before the RWP-disarm rewrite below: when the
+	 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
+	 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
+	 * so a later pte_write(pte) check would skip the COW wrprotect and
+	 * leave the parent writable over a folio shared with the child.
+	 */
+	writable = pte_write(pte);
+
+	/*
+	 * Child is not RWP-armed: restore accessible protection so the
+	 * inherited PAGE_NONE does not cost a fault on first read. Gate on
+	 * pte_uffd(pte) so unrelated PAGE_NONE markers (e.g. NUMA balancing)
+	 * are not normalised away.
+	 */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma) && pte_uffd(pte))
+			pte = pte_modify(pte, dst_vma->vm_page_prot);
+		pte = pte_clear_uffd(pte);
+	}
 
 	/* If it's a COW mapping, write protect it both processes. */
-	if (is_cow_mapping(src_vma->vm_flags) && pte_write(pte)) {
+	if (is_cow_mapping(src_vma->vm_flags) && writable) {
 		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
@@ -1105,9 +1135,6 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd(pte);
-
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
@@ -4747,6 +4774,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
 	bool exclusive = false;
+	bool rwp_restore = false;
 	softleaf_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
@@ -5026,12 +5054,27 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (pte_swp_uffd(vmf->orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/*
+	 * A page reclaimed while RWP-protected carries the uffd bit on
+	 * its swap entry. Re-apply PAGE_NONE on swap-in so the first access
+	 * still traps as an RWP fault. pte_modify() preserves _PAGE_UFFD.
+	 */
+	if (pte_swp_uffd(vmf->orig_pte) && userfaultfd_rwp(vma)) {
+		pte = pte_modify(pte, PAGE_NONE);
+		rwp_restore = true;
+	}
+
 	/*
 	 * Similar logic as in do_wp_page(); however, optimize for pages that
 	 * are certainly exclusive.
+	 *
+	 * Skip the write upgrade for an RWP-restored pte: it must stay
+	 * PROT_NONE so the access retries through the RWP fault path
+	 * (do_uffd_rwp()) rather than being made writable here.
 	 */
 	if (exclusive) {
-		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+		if (!rwp_restore &&
+		    (vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
 			if (vmf->flags & FAULT_FLAG_WRITE)
@@ -5092,7 +5135,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		folio_put(swapcache);
 	}
 
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
+	/*
+	 * For an RWP-restored pte, leave it PROT_NONE and let the write
+	 * retry through the RWP fault path; do not COW it here, which would
+	 * drop the marker for a non-exclusive page.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte) && !rwp_restore) {
 		ret |= do_wp_page(vmf);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
diff --git a/mm/migrate.c b/mm/migrate.c
index c7da7da200fb..222c8c15f782 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -330,6 +330,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (pte_swp_uffd(old_pte))
 		newpte = pte_mkuffd(newpte);
 
+	/* See remove_migration_pte(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(pvmw->vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -399,6 +403,10 @@ static bool remove_migration_pte(struct folio *folio,
 		else if (pte_swp_uffd(old_pte))
 			pte = pte_mkuffd(pte);
 
+		/* See do_swap_page(): restore PAGE_NONE for RWP */
+		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+			pte = pte_modify(pte, PAGE_NONE);
+
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ea290f04d90f..dc27bbc1712f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -296,6 +296,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 	else if (uffd_prot_resolve)
 		ptent = pte_clear_uffd(ptent);
 
+	/*
+	 * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
+	 * semantics. If mprotect() or NUMA hinting changed the
+	 * base protection, restore PAGE_NONE so the PTE still
+	 * traps on any access. pte_modify() preserves
+	 * _PAGE_UFFD.
+	 */
+	if (userfaultfd_rwp(vma) && pte_uffd(ptent))
+		ptent = pte_modify(ptent, PAGE_NONE);
+
 	/*
 	 * In some writable, shared mappings, we might want
 	 * to catch actual write access -- see
diff --git a/mm/mremap.c b/mm/mremap.c
index 12732a5c547e..8a46ec5831c8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -296,10 +296,19 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			pte_clear(mm, new_addr, new_ptep);
 		else {
 			if (need_clear_uffd_wp) {
-				if (pte_present(pte))
+				if (pte_present(pte)) {
+					/*
+					 * See __copy_present_ptes(): normalise
+					 * RWP PTEs so the destination starts
+					 * accessible instead of taking a
+					 * numa-hinting fault on first access.
+					 */
+					if (userfaultfd_rwp(vma) && pte_uffd(pte))
+						pte = pte_modify(pte, vma->vm_page_prot);
 					pte = pte_clear_uffd(pte);
-				else
+				} else {
 					pte = pte_swp_clear_uffd(pte);
+				}
 			}
 			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 		}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b116fd8c7d11..72952491e9cf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2559,6 +2559,11 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mksoft_dirty(new_pte);
 	if (pte_swp_uffd(old_pte))
 		new_pte = pte_mkuffd(new_pte);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+		new_pte = pte_modify(new_pte, PAGE_NONE);
+
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 7b2adfc50e47..e14524512a5b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1292,6 +1292,13 @@ static long move_present_ptes(struct mm_struct *mm,
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
 		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+
+		/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+		if (userfaultfd_rwp(dst_vma)) {
+			orig_dst_pte = pte_modify(orig_dst_pte, PAGE_NONE);
+			orig_dst_pte = pte_mkuffd(orig_dst_pte);
+		}
+
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
@@ -1373,6 +1380,9 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma))
+		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
@@ -1399,6 +1409,13 @@ static int move_zeropage_pte(struct mm_struct *mm,
 
 	zero_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
+
+	/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		zero_pte = pte_modify(zero_pte, PAGE_NONE);
+		zero_pte = pte_mkuffd(zero_pte);
+	}
+
 	ptep_clear_flush(src_vma, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
-- 
2.54.0


