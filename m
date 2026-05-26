Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C02BCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30DF6B00CE; Tue, 26 May 2026 09:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A086F6B00D0; Tue, 26 May 2026 09:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1116B00D1; Tue, 26 May 2026 09:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 720906B00CE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CB371C02E0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:48 +0000 (UTC)
X-FDA: 84809593176.01.768A7C2
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB83E1C001D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D 2ONIH5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AI9sqdoF;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800746; a=rsa-sha256;
	cv=none;
	b=LqzGPy0BrR0FJucoZ4x2W2WamCIWxadQwqW/ngN6FjlcvwHmSeGcqx1n74puMbSqhf9Wbb
	RynsRJVtvzE5cHgIJpxlcFacgHRXNDbzu0bIZ/uO6AYTvEtO6v9+hRebjjQsov+LTBeWt0
	qDSNhWCrlpNz9PYlRiOIfvAA1QxItNk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D 2ONIH5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AI9sqdoF;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j03dxXIoPPLNhIhpo0k2MB+X17HaXKXBfH81OzyW818=;
	b=JsD5OoIECSlfT7TzqP3ONeFBnUpY1WDENVYX8WmAvkaRvX/NkcoFOfvg0y4GO6A3G6sKQe
	6i4U3TT6rz79iGjBoh9dNsUX6K36jOtep8I0Ptg+13BZDF+UxZ2I/wRA1jqtof/WMdxSOz
	FaSsFO5SdwzWkJaNhuOJhirLfr8W6KI=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B51C87A0194;
	Tue, 26 May 2026 09:05:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 26 May 2026 09:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800744; x=
	1779887144; bh=j03dxXIoPPLNhIhpo0k2MB+X17HaXKXBfH81OzyW818=; b=D
	2ONIH549dDqPoKLCH2SqV4XoXRZhWHVz9mJ0dALRHUsvoI25EVEa/s6H73rFJQjN
	2lA/wAlveDgiR1bj2XRPM/xXDNo8nWVFNzAW/mH6P4jnpAkrvgmf5dEJh7kdbRHB
	D4UM/w2VqacpAnebW23xFTQ+3mHRiq4eS14/gc472WWFAK/JJnSaGsNcws+1fJc0
	58UKRYBZKd7nQ96kcSnTj2gPg/wCs06HkVSLKMnNQ9o23ebOMA2sOvFgOEqGWE8X
	UTEZHExPfDOO5Woy40apquzowcbah+q3ci2VfSfmk9Hipk/vHMnshj+SkanM/wD7
	iJoKrGwl2sHJcxTdjqn4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800744; x=1779887144; bh=j
	03dxXIoPPLNhIhpo0k2MB+X17HaXKXBfH81OzyW818=; b=AI9sqdoF62XRfOE4t
	HbX0LA6um6oqfLz0y1xvfU5RsoDYya6HO8NNdpP7LEMK+NcNBUtphll+fasUbQT2
	2CDQtLzO+DjNzzKC1523UpDLd4xLCk0H3c27PUr9NkqX4El1UTqkNpvbjg+cQen6
	wkK8wWKYRdk6jpY+WriXleXUHbRplZY3mLw26i5v/jjEW4yEkp0UXWRe0Dnky3k7
	s4sQcexFjx0qwPDqnIozBW4cFKm4ghsOo48Rc9M3NMAXtZOdZQG2zLxzkxi0wgyB
	tkQFnRYGrCd9c0qeSt9lkUijArJVxfbXsJxU6a9PFjApak15NJXi9d0xSLLmTDDr
	M+QgQ==
X-ME-Sender: <xms:qJoVatah7jgeCmkwFDj_KgBx_Ho-dAsnsHbcTZZr-LIDZngdSj3CLQ>
    <xme:qJoVaoVzczZbsg1RK9sGTulCrJ4k_5dLzVWCk5Vq2UuOf6rEJDmaEvck8gzit51n2
    i9aMqZJCRnlkTb80tLSsK_zwKoT-eYeRIyu-X3WYiVl3hd0CtBaE9g>
X-ME-Received: <xmr:qJoVaoftSgbjgARH-htJ0d18iRS6dZMxqelX2zUP3WaoQpEu_JkoqBMJqZP4qA>
X-ME-Proxy-Cause: dmFkZTEzvHlPzLECdN0oUl9WQMczFzDev8cDOIvkt3PCDzQa89C+VcBR0fT+neHr0xDY9c
    E1lOkYShDM7gHuzaUAspxlre/K2WW5h4tu6mCemqBiOx7uwiffptB4TdA8xuvPKf4dxBnE
    WSPJQeaUZcATVIs9WpM4Lq0pXLUv11mhmVsjvHccpZr574YSM6zwnvi2MhP6Qgfrqof+PU
    WnHYhz3eTCLxCEvF1VP7IHBalJXjAemgrxDvmw6FXhGxcXv6+EErND5M/zCAozlc4WhfO8
    SwiCJMPqgAdL5MNEfaXozXy3ufcKsgNIf65DdMVl2QuP2VseNZF1YZ8iQpqEWb2i2OkeNM
    9ZMIUpP+i2jRT6kBd2/5FHIHXR7BHlaByqWJylR4AwxGyk3M4E0x3SrqkeBxLVqmAAwq3N
    TGDj+OM9HtHZXYJzi3PxTofYvjGwAPVpSfMhEBPvL1UUK6FQUSf/qxSrnukdtQpqeaV84K
    wv6RcDfroEbwO+Nu0ruZ8WIRUJk+QDswvzasGU0fe3+6WgU2FLtlQkGD+b4p790z+wzzlb
    9J207ka1hyy0Yauj728Vx57aOKD6GqNOCePSZLLbAq0zwcS1qXRr21otyW8b0uWEy/v1UV
    BsQjXv9qC971sHL9Nc5zHo1wc4ybg9NDOC6+PQB2drz9m6jq6mVN0S9T60hQ
X-ME-Proxy: <xmx:qJoValN9nnvp2vNYcVvMCu7hAgfbxac9EH9yGHP2Dhg9bO_z4b9W7Q>
    <xmx:qJoVagJBYFgDG5AT3NZ0P-85cHMWfu72xUw7Swo3oJCPWjuDw3mxOg>
    <xmx:qJoVarmLhMS9js6IwxeHLJLcF7DjYD5PBkHWvKIaufBWfdVbIm5GJg>
    <xmx:qJoVavbZdE4IX938OUQpbGUezdwqxc1sqzRVKf7iP6SwUXj9jMeUsQ>
    <xmx:qJoVal3o8gxJ-YnfWhvjfTHm3l5arBi02NX6fSo2rnInrxpvV7oyKjBv>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:43 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 10/18] mm: preserve RWP marker across PTE rewrites
Date: Tue, 26 May 2026 14:04:58 +0100
Message-ID: <20260526130509.2748441-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EB83E1C001D
X-Rspamd-Server: rspam03
X-Stat-Signature: 1tiyamwpzrqyf1799nzpygqn334iqsga
X-HE-Tag: 1779800745-395529
X-HE-Meta: U2FsdGVkX199N2Z29Wf0iMSwtfqNmuxqN8YNMewsUNryJse/y1TGd+dIGdUwGk1iAj5y+A2tzTiSTKBNchZmrpHZ6uHj7al0LK3eYDMTN1mdMjX7qOTL1CiUllRn1+ChDpqBH9+0ycThe8j5RMT8Nqq3rM/bx96+du8DKSqgrCEYFq0NfAhjvw0afgvawyL3WkkqJNzhQrKUHPkXMxVTl8MDsq/UUWUaROEUT78RKh8+VBiMT1haVLWdKdWrGtSQ9toz+FqXxEk4EWSNLQyOpV6fTMKyUT64wDORIKQD3PUwxQ5qxt+vRtAwfOVPcsZ3vqaltgsZwSLjd5hSjYT/y494xBCWT/0CnXbwMHOg/G4ziqN4BqLQ2Qrkmbna8zaHIJP4tbHCnX43AZ+URihEfKDdxyuzpCQZ/2awIT06uqmW3nmoa+EagBuU78Vfl2G36oaRQitGbLsbDeWCMPGD573mmM8YO3CteT9WVD7UbVU1MtThCUbsUbTW0HV+MfzaSjP9LdDHiSwj5Y+/7qpF5fquAJG26P9WTzCiBI2vZSC/sZJDOAbTI4aGUHnNXDv8txdsoMiswfH/95OYYwaEe352mr06FZ4j03TieeaSbPDZBpk3H/YBoSh0ltoTe5jxl56lKY4LzrqcRT8oVlbmamv6CC04EFUJOVCGi78Y5/cmZdBEqu+Bpi/PaqospC8wWtBqtkPhUjjUkJDlJJrJ37NUTWAyQIMEI6dJb709uv04DHHJqP5UtoaGPkbu/2ti+cvaZ88MY9d+KAtN/+PKKqLRLwZCjn9YkmbQzE3OhyZJye8arEI4CQBHNR1L+uHFdNFzAB81kObV7AwgKKnJ0o6vKk8xM3GxzOrlRBNTvGFzczwWdulzKwQvnkU6m+dTYo6gH/OiiLjyhLIVzCqzuseuR/kiCeklGL6o+IjST+T2EJCaQuL71BIigsOfUnVFOmvNG7FcT9nHPMYA+sQ
 wbGOzDEo
 3mGDoGAP87PnrzqgWz2n1EF1wNHnxMLFcrp9uuiFfipxQsid8jN0+S1EF+C2OOgCNMai8pyVNjtexLYzpiFzPUB53YyJdPPUPUWecq44LPvXOZdQDLw0DcGmT3VSjujxwJuo4Zl5B2RaXiLPwjhBZQQGGHiSiy+N+sM2dQIl41A6kcFJOzTZvefn1xkqju9EkURYKMlfcUDDUlkR3FlDysAEbZTQFwShBxB1RsRxC3SzmpMhW9TjKRa/Hv98qIElFvqymv759L/rtQ+hJfGKp/aLGrbsuQvB/TlkcNTv5bE9+CuEsSCWn3Z+SkahjUT0VI0VzGaOwnO7/0ulNHk/a0wb01JefjEbpQsczn20MGHv+SH9zublvsbF0XQJF56gOiKO0VsCMU1bTgOk/PAWOR6s2pvwSisSgSYpgRi5ScdP12yj3YC8sN/rTSJ2cxv0CFfXwoi1ELKG3rQUd0oFCJKg3rirSQsJ0Eptr4dZl1oFJ3Ec/ApR22lvxBYT4+f0k5mUxKMlJmAGe4rK5XbWtTkEtgV9WhjamJZcSDUkUYf/upSXEI/PREuNdQt9kdqN+wk6DelI5YxzlEjrxo/+gDLnYELZzTZMoJ2rQm/2F/kQ8eHh0ZbCO7KxgJqQTniMU/6kD8TAo2DfBt+qTU6jkhaNeaiz0OzG3HeLP
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
 mm/huge_memory.c   | 47 +++++++++++++++++++++++++++++++++++++----
 mm/hugetlb.c       | 52 ++++++++++++++++++++++++++++++++++++++--------
 mm/memory.c        | 49 ++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c       |  8 +++++++
 mm/mprotect.c      | 10 +++++++++
 mm/mremap.c        | 13 ++++++++++--
 mm/swapfile.c      |  5 +++++
 mm/userfaultfd.c   | 17 +++++++++++++++
 9 files changed, 181 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f79801816f32..9e62946af654 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -672,7 +672,8 @@ enum {
  *                           only and thus cannot be reconstructed on page
  *                           fault.
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
+			 VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40c65bf2d6dc..6417d883d2e4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1943,7 +1943,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 }
@@ -2038,9 +2038,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -2626,8 +2632,16 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma))
+		if (vma_has_uffd_without_event_remap(vma)) {
+			/*
+			 * See __copy_present_ptes(): normalise RWP PMDs so
+			 * the destination starts accessible instead of taking
+			 * a numa-hinting fault on first access.
+			 */
+			if (pmd_present(pmd) && userfaultfd_rwp(vma))
+				pmd = pmd_modify(pmd, vma->vm_page_prot);
 			pmd = clear_uffd_wp_pmd(pmd);
+		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
@@ -2766,6 +2780,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 */
 		entry = pmd_clear_uffd(entry);
 
+	/* See change_pte_range(): preserve RWP protection across mprotect() */
+	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
+		entry = pmd_modify(entry, PAGE_NONE);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2933,6 +2951,13 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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
@@ -3109,6 +3134,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
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
@@ -3383,6 +3413,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (uffd_wp)
 			entry = pte_mkuffd(entry);
 
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && uffd_wp)
+			entry = pte_modify(entry, PAGE_NONE);
+
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 
@@ -5055,6 +5089,11 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
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
index 4d75b69d4272..0d8d39cd8888 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4843,8 +4843,16 @@ hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long add
 
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
@@ -4917,7 +4925,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
@@ -4931,11 +4939,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
@@ -5000,6 +5008,16 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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
@@ -5012,9 +5030,6 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				entry = huge_pte_wrprotect(entry);
 			}
 
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd(entry);
-
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 			hugetlb_count_add(npages, dst);
 		}
@@ -5060,10 +5075,22 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 		huge_pte_clear(mm, new_addr, dst_pte, sz);
 	} else {
 		if (need_clear_uffd_wp) {
-			if (pte_present(pte))
+			if (pte_present(pte)) {
+				/*
+				 * See __copy_present_ptes(): normalise RWP
+				 * PTEs so the destination starts accessible
+				 * instead of taking a numa-hinting fault on
+				 * first access.
+				 */
+				if (userfaultfd_rwp(vma)) {
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
@@ -6515,6 +6542,13 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
index c4fd5cb4a08f..06473285c0dc 100644
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
@@ -1041,7 +1045,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				   make_pte_marker(marker));
 		return 0;
 	}
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pte = pte_swp_clear_uffd(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1088,9 +1092,13 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
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
@@ -1100,9 +1108,31 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
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
@@ -1112,9 +1142,6 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd(pte);
-
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
@@ -5041,6 +5068,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (pte_swp_uffd(vmf->orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/*
+	 * A page reclaimed while RWP-protected carries the uffd bit on
+	 * its swap entry. Re-apply PAGE_NONE on swap-in so the first access
+	 * still traps as an RWP fault. pte_modify() preserves _PAGE_UFFD.
+	 */
+	if (pte_swp_uffd(vmf->orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
 	 * certainly not shared either because we just allocated them without
diff --git a/mm/migrate.c b/mm/migrate.c
index 4bdb5be7afbf..8d7fd0b056b6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -329,6 +329,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (pte_swp_uffd(old_pte))
 		newpte = pte_mkuffd(newpte);
 
+	/* See remove_migration_pte(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(pvmw->vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -394,6 +398,10 @@ static bool remove_migration_pte(struct folio *folio,
 		else if (pte_swp_uffd(old_pte))
 			pte = pte_mkuffd(pte);
 
+		/* See do_swap_page(): restore PAGE_NONE for RWP */
+		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+			pte = pte_modify(pte, PAGE_NONE);
+
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4a6b35482aee..e0b5fe7c66b2 100644
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
index 15fdca2da1f7..27cc299ead9b 100644
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
index 9d74be69873a..e30878e4e00b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1285,6 +1285,13 @@ static long move_present_ptes(struct mm_struct *mm,
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
@@ -1366,6 +1373,9 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma))
+		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
@@ -1392,6 +1402,13 @@ static int move_zeropage_pte(struct mm_struct *mm,
 
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


