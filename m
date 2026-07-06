Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9990CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D506B010B; Mon,  6 Jul 2026 04:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E216B010C; Mon,  6 Jul 2026 04:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11156B010D; Mon,  6 Jul 2026 04:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A528D6B010B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 308D2120354
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:28 +0000 (UTC)
X-FDA: 84957725496.04.089B2E4
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DDB040003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="w DyTveM";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z84uPpGP;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHfca59rk9HgiAGHoIrkt2dLgWLp+z8XNgIufvmeO4E=;
	b=xEqFtP58MmvNKs5HDaZCHNIkl8Gg4mxNnK1yftqT8qFi2kzHiIPPtIgueds68k7w+YbKz4
	Rp+gUJsVvDVqfOEL++xKl0Cja9VIjp6rY1SvGwM2DqdbiI5CXVdZW58Evde1nA9bxua8PI
	WkgZ4pI6CyrzQfjsRBwoDHkIQ7FZvwM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="w DyTveM";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z84uPpGP;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327706;
	b=rk8coAm8B/jQ9Sfd1gndvVvwsWpf51esZPwn6y27YGW+/x4BiPhl1OXbdtBYmMfEdkJYkY
	UZI16MT1y8xb4Cmcw05Z6v8LBjHt9KaqGcZAoAKaCQFYM3QWvja0ZqrNVE8uDzZGCgVtMB
	KtzeeNodzDgooN+DKhz6ZUhRUTmF4G4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 316D67A00F6;
	Mon,  6 Jul 2026 04:48:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 06 Jul 2026 04:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327705; x=
	1783414105; bh=IHfca59rk9HgiAGHoIrkt2dLgWLp+z8XNgIufvmeO4E=; b=w
	DyTveMR/KmeO55Ri6IrM8L6DZMojEjmI8Rz2k5aD6l5Q+HWLWHCg41O7YEfDkqau
	L2Ujo6GqZiVRkGr/pdHN4d/9yrBoZDF1PfR2FTTpd7d/a9/dOiziTzyJ7aZgLuX+
	8v/GKWa52cG7B30/H+NEUcXswCcZyvgQxF2NjVR05sPIWvIgRbshC9mzkqIjJB/T
	otMp+Q6jTo+lcSZo9O0OC0fb1EHXWoF6cD499HNKG6Bc0yYxrpH3+9ZEkHPXKUZm
	hNdjvYnELHbkFZPHF9iM/8cj3sUuC5eq5r8507O/hQ4Xtd0ZhBucjlCZmPyAbpNv
	S4rfAZ6HOGAG+mcmmOjlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327705; x=1783414105; bh=I
	Hfca59rk9HgiAGHoIrkt2dLgWLp+z8XNgIufvmeO4E=; b=Z84uPpGPRI/6s0MEK
	PcZ47FR9lUT8vghgbS/J8Ex8gimbhq94ZgQkMGtTIv4Xg/Q0ldxbDyf7tuw0y3sa
	PyHtnSz78vbvh9UyHUl3aWGMt+kd5JwBIENWITMLwRgld798/S93i4izPRlNUJNT
	ETyeRqe2AoWoZpqzokweFnPIdk6y4WCBQaZZ6T6Fo4gncRlAgHd13JTRWJEak7aJ
	MVhkEDR6wj4vPK2uG/qVP3wx8Annk/2cbBU/1Wo+aVvM6hZPesT+loFn110laHej
	RmCqXdNFQN2FPJE5MbHei9IY2Ij/BmtGphQe5EmmaM4M82gZguVsCOc8CZ5SvE/k
	RjTKw==
X-ME-Sender: <xms:2GtLalVFki4Rw8h8OfjuTcDlafRlscCD7Gm0p1T342COhsjR1Heg-g>
    <xme:2GtLapgqGK3Q2Ga1fWd-34QATzWl2kIqtWa1by3hOaOVB2DK_qYmqltG1dGvPNxYa
    TUuhKzspR0GGkEB6N7rzyM2eUSGYzDO59X_CVyySSSRtTT1FYm_PBE>
X-ME-Received: <xmr:2GtLap7ya8YsunJc5LHcgBNykOBUBrHy86QK8neOUvXDNnY_IL8Bg9mQdKMcUA>
X-ME-Proxy-Cause: dmFkZTEaPZdviD2XbalDAKS8tszO4Hte+xIg0jgPrUan8C55y4EV/KJ/Eom7XifH61NPsj
    FpHJNCv922yiJ1/uYMxxnyO7ohj4FdG9jlt3xAQ9ulNn8sNn16Di9FfOZz57KTymaDzX0X
    Oa0xwtmkNizaUUH2ahz49zlPrt4p4TivjhaMFb9MByS5fcrdsopAtNxM42z/KLfZEzontY
    dL7oYKud5vnDF47FBpMkQLkbBVAcKZwKKE3gao9aGmCcABxV7K5XPoDt0NUeM7mdB6UBaE
    xlUOaRlAzH3c/cAXi9JZvKpCWHAqobGBBf/9tSV3q5HJYXgQVn2KMNtd8oDpj8yLDeA9Ll
    BrHqBnC77gAt46erGYp/b0L8r2SfmySgjBElMfUGq88ki4kugT/I+wgcNgYKTk0vCLGFmw
    wRso3zmzLC0ltFJN0jHale2MxM1hqy17mS8e1PlzPVMy606+62WTuALf9GXQDPWTghM/sz
    3qVt6MUY+Fuwu5/+ch6R/250UG99rxw4fpUv4gpYLwrWS1X9JyGX50ZQMzjUxjI6XA9ajh
    Gb23RoGNwyXIVFMiy+jgM8uhrqhA4xke9NfcVWx0uQceskOoui2stiw2ot+yBBnPwvvyNw
    eFe+wLZ9949P9kOyMTTpYEKixhpPB9OAbl6989Vm+tkXX4/u2z9SARM8jL8w
X-ME-Proxy: <xmx:2GtLah5SdJcnTd_qpFmFfVeAO0StEYmegJ7nkSx5XiZgSvnJ_fH9bg>
    <xmx:2GtLanE9voR6_fgj4X1JVVrvRKlCKql04s0sCVpB3G_jZUTxhCSJKA>
    <xmx:2GtLavzAqBEFL-eiyZpYGPRUmQ_LGYvhWJ0d4iIeu_rWqAl0l_jt4Q>
    <xmx:2GtLan25feJj7LbZpPE0kNBR8Bc5t7FqvdK9a1b_sS6AzV4dDS08Qg>
    <xmx:2WtLas2LYTvPF3JuCLybJyNW2CgM-pZPPewQSDK8ntwO-K_IBNuP-0K9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:23 -0400 (EDT)
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
Subject: [PATCH v9 07/15] mm: preserve RWP marker across PTE rewrites
Date: Mon,  6 Jul 2026 09:47:56 +0100
Message-ID: <20260706084805.8400-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4DDB040003
X-Stat-Signature: ga5ihcp3b3u5n9nj4mu3e6d7qoxozp71
X-Rspam-User: 
X-HE-Tag: 1783327706-521290
X-HE-Meta: U2FsdGVkX1/jxJlEIZR7xh78MFoaHSpRxpC3L5jty15yLaQiYgsGB3fm3gwlvzBxiUVpf0Dh9zJgTqO0sxyNBTCn9eZGCeNIx8/mbUdKpNmxgiHOzsfRC3KrzoFbhlSB1GKd+/ct9RhGiZMN8y0weUYWzvbF7//ZSe0b09baBrnj5MbsUdeEBNhSWyFotinu972yeS7DKeUnW031qXg1KNh7m5jhT+q/DA35mPogu49032FxeNAbaYPYzlAlwKDLs2VohTOzTWytb4Kqz6+E3VERXvc88m6EB5faMtIefzpumwwgOKF4DntNGR7pgK2fQScXcHSZH91oTHU6gXqxd5x4dX/pf8weFdvg2I7YXEpQhVtZDixvMQv05sR80VsJW/xfEi6cYJR5z5LYfS0YMxyYfnw/Vs7lU9Nw51aSp7uB0Bosb5d6DitpaeycYB/DBMOGTFu9WKzVoGHh45GQv6SY0NpecLugtmVV0uR8PfX7uIJH7NiC4snWtdZ9DzmhuvoDfJNwU10pkx2nBtF9G/sUGhQe/crBgPj2vklWnzcOWm83hn2TbI36V8uD3PMXNQDbMlUIPzuW1pdPBRictcbI0pS2qP0I8Ixzp2cThazrkxUDNlLA9zll/w35ZED7EYLAFsMXZtgXtbL9hSRTH2d/MlBm3cdfQ9QCddFvwJu2aYZFRnDBzFrvNHNuPZwm5m2P61nj+28eMqdX5zDTpaBEoHFMOeSa6WYQxcQQT/P6aIMxH41KeYS0PfDGG6wI+StpPvZGpKqfW6nJnikFTQUbnmHDGCrp5FiaGqFdlpL7dSavBuEmUYdsL5+Bu0J0ylqX0Aq7RLvjGUZXEP0mN+NAvOeCmVBTgd4aC/PS+Puytw9fRJsyEwJ3ZmO639625EI4zEXj7IqYS7VgYP+ibHBomuSilk4omYeH4I5ktKgxywJAbNW6tQ3n63YMHWco6PlnxYIx7SliO4yww/d
 3lmXF8f5
 SGqw2oLOuc09s6cYTZdpEF2AagigDskh2gX+NBCMVoiCVGruGstcJ8XvGk5knv2EkjjtTVS48NnPLJU+WFwqYyFmdQxyKO6KHFreuv10sw0zVfjeOt78wxVKrJV59powgrLFBkmoGvrKNBw0cCarlyEcW3duhZC+wyRGRHoIdf8VugIBvF3F2+lQDbllIooNlhOQA1F6P4cg4u8JWTcMiGmDuTOvLhcdUBNzfvluyJopprVmWpaHBy8cd6NLbDlxbwZSzenzJ8WJqRHgqAF7kLtsU3tIRlNp0was5rjPGWdXts/YOaPz+OPEj9uQ5vT6spBR98SjKiS9cGLXOlwhokRiyF3WH4erf2xBQ+2LgszzHBtMU+5TbEWZp/d58gV8384pcsRei/EmgtUzDo2uChqlyoIm9vq0yWkTjRgNb/l7Z1r/Uf8MJQZdD/Y9VwCQkBsVAj6gGve9uXlSUu3Q5ZcQgsMSQwUd5VQcuJ9CjGKFjPmDB3BPE5bm0yYa4TUxMqekQv8LdtAjvX5W5SsSqiO9t3g==
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
 mm/hugetlb.c       | 53 ++++++++++++++++++++++++++++++-------
 mm/memory.c        | 66 +++++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c       |  8 ++++++
 mm/mprotect.c      | 10 +++++++
 mm/mremap.c        | 13 +++++++--
 mm/swapfile.c      |  5 ++++
 mm/userfaultfd.c   | 17 ++++++++++++
 9 files changed, 200 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87b2fb1e3f23..3d4d5f9a6f1b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -683,7 +683,8 @@ enum {
  *                           only and thus cannot be reconstructed on page
  *                           fault.
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
+			 VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aca2f10fc1f1..7ee7651202e2 100644
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
@@ -2679,6 +2696,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 */
 		entry = pmd_clear_uffd(entry);
 
+	/* See change_pte_range(): preserve RWP protection across mprotect() */
+	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
+		entry = pmd_modify(entry, PAGE_NONE);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2846,6 +2867,13 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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
@@ -3022,6 +3050,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
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
@@ -3298,6 +3331,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (uffd_wp)
 			entry = pte_mkuffd(entry);
 
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && uffd_wp)
+			entry = pte_modify(entry, PAGE_NONE);
+
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 
@@ -4965,6 +5002,11 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
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
index 4d75b69d4272..4d0b6d7d9842 100644
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
@@ -5060,10 +5075,23 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
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
@@ -6515,6 +6543,13 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
index 6b0304caf1a4..c1f79a3dfd6a 100644
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
 
@@ -4752,6 +4779,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
 	bool exclusive = false;
+	bool rwp_restore = false;
 	softleaf_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
@@ -5041,15 +5069,30 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
 	 * certainly not shared either because we just allocated them without
 	 * exposing them to the swapcache or because the swap entry indicates
 	 * exclusivity.
+	 *
+	 * Skip the write upgrade for an RWP-restored pte: it must stay
+	 * PROT_NONE so the access retries through the RWP fault path
+	 * (do_uffd_rwp()) rather than being made writable here.
 	 */
 	if (!folio_test_ksm(folio) &&
 	    (exclusive || folio_ref_count(folio) == 1)) {
-		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+		if (!rwp_restore &&
+		    (vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
 			if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -5112,7 +5155,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		folio_put(swapcache);
 	}
 
-	if (vmf->flags & FAULT_FLAG_WRITE) {
+	/*
+	 * For an RWP-restored pte, leave it PROT_NONE and let the write
+	 * retry through the RWP fault path; do not COW it here, which would
+	 * drop the marker for a non-exclusive page.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !rwp_restore) {
 		ret |= do_wp_page(vmf);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
diff --git a/mm/migrate.c b/mm/migrate.c
index 49a360fbcb87..9516cda35e34 100644
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
index 7dcc94e7bfd6..cc85a8862c28 100644
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
index 9817928c24bd..a6f19759e8e3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2498,6 +2498,11 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
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
index ec1880d18171..4fca0409b7d7 100644
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


