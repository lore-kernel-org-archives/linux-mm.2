Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCDACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7856C6B0111; Thu, 25 Jun 2026 07:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CF46B0112; Thu, 25 Jun 2026 07:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6999C6B0113; Thu, 25 Jun 2026 07:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 403646B0111
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1C911A061C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:20 +0000 (UTC)
X-FDA: 84918219120.12.21E40DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DFD5A000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CfttjH4S;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387079;
	b=w6oqP4upOKefAcbVpu8ixDhIg5I1bVKcl6IDQRxltVV/8PmlGe1cC2DvRk8o1ogYdLhDgf
	QTT+C0NqVpqPGP2pLHkvfxLI3vA8/X7qSrEGA2jGb9XTWjZgdvkj31agMHEeZZDCZJsW1g
	rV9WYguGY1tNXqjTj6AYHqyd6aKSkbw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MD8BWDDf7riSljuyaMow1GMntkPzgOjCcKldflS+cNo=;
	b=PHr1Ye6i+I17q5KmvbZnmIcYpKm6BDxVABhKOasR3Oei7dQv073Wg/fjYDe03BDPO4TApg
	pIitKHuTBVzk35NusmKwBAK4lA2pYsGwFIvJr2yf2AfJh58wRK9mcAqVpOJ+pOCKrpfz6I
	P+viQ7q7SovJmXTnvuFWaE4TS1vTRQE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CfttjH4S;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A0FC40860;
	Thu, 25 Jun 2026 11:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FFF1F000E9;
	Thu, 25 Jun 2026 11:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387078;
	bh=MD8BWDDf7riSljuyaMow1GMntkPzgOjCcKldflS+cNo=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=CfttjH4S0+tOLThbenqQITZILSVF2S5jjvy94VMgfyDtM4LJLVlgYp5rrtymM0QjX
	 GSqLsBWAyltBFga7sHDqNuRBX1zmd8TWs/t8MeMnpCBdPNnL54uvFHGaH66xQfoLfm
	 KbqhWmXJT9IF1FFt/RhX4Gv2+sddzucT/fFoc7FA=
Subject: Patch "mm: set the VM_MAYBE_GUARD flag on guard region install" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-8-elaidya225@gmail.com>
Message-ID: <2026062548-vegan-budding-bd38@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: 3e17dgooitcddjp8cs83ux5miutnqmpm
X-Rspamd-Queue-Id: 0DFD5A000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782387078-511422
X-HE-Meta: U2FsdGVkX18aVpHmaKO3/ZWMCdI64l3Ch+ol5YvdzyEqheia+4AxSY3Xu36iLlpSNx8EKRR+SzG9C9IZLqXRHXzd79++QpZ8aRFEE6y4wWd/V0BV12Wa0FqpJh1fRT1VEPywfon9+bBZ09RTdtuFkHRzgD953DaQ7Yq/atxisF9tv4daOhepWqZpiTQJsu/OqZyIj4hswguQoXze2mL+j2S7zXCRLqB7sHGpV5DNKrwpUYokQ00Ayb4T1uXgiEZtGKewj4DZiNcu8ythzEHdSeXWcfvv7/oQvlrvPpA8esVdK8+4pnfS3Ky2O5qVk8ybleEBPsK7ODkfMbAicI77EpUulKEzVtkU6M9qUN1ABw6+wCB+oET6GNaPbJWjztS6uWBgIgPSrj8uY+hdGDE/WbGh004d/jWuhglA2UNLaGXYUaTQ8I/411EiKbad6nRxDBa5ygeHmZ9OEC/ryuvBnsgTwJeM06lLNPxqkfg9ib6EsVvLXxjpYLv6GnXashjN/CEvWbD6wAyVkcGB1nJX5Zm2Gu4xeTrbzRHGvZJpH/r1JMHmxxnARr/+cBcUwSri8SUKsgwsFiDusqvskJI6T+Ok8QyrPj6m70c6719747llbfxNiuxxD1TGQW6YLHNmqli71/u9fvaYH08ppDla2We3F/opjr2tYSfuWF4aJy2ZMrHxxnuYFKyx6NFQ8y3j6VLVu3NnA8dYtld6o14CbtA0IY9Y0wYHV05pE8hAgD3h8HoU+M1Bm5KC3Bc7mbOfdyZlgo+E2rvuocRtbEayeG/5MUzbYPV0VGNDaSLw/LMEeyEguL6E79Ta5PbHg0l4M2+KX3s6vDqWbIAOoX3WYchoERXjDWAfOO0SKKmAgKyyhk+Tyu3MCNsOx06GgSTPVud3xgwSNRHoeJVCVNXpj82+pMGsfE4tborW76CToOq6N+EWsouwCpb5PAfu8azORocpjXjJJw980IlmxRG
 BRa7noS+
 kTdx7MIlvBdlJ9fhtyGXUhhgN0Ks5McK7kFAcPncehllhNmX6we/WJSaN+Kr9Wooq1A2VOq8yXZMRDIAUipxtCyowtsuoVUi7bRmHTfLsTd0jdtndku154dVun38nPIgY9I7TXYg2sfKpRaO59WW1m3GIuP/hQJSRSqenmlFod+Hti/AxTg2Tptnz3Zjb15b2SiRSFjrZ6dmdYgDQKKQkR+Gx+gQnZtywqRDjldMWvJOYR4MGNJ1uh3ufEpYSPs0sDTTPm17mmO55zDb6o4bNH1Rw72+lF1HCuG7YCfvTS3MoJpdW+qg8OLcYwEKP/axv/oCMROXSkQzYQnQYILQW1IY63M02yCDA/Sh8IugkK9Ki1Ully3skeJr3+UIQxDylg9Hmc55iRb1dIpnZ/XbRL7t7AJHuK6ss3o70sTpVqCNaWQ45P/lLEWPrWP5zvmNwx7qhFgQocI12OCB9uyIX5rot0PAOpkq7hTQpHLCwAAVhJA30MmCTgJjQbhyPqiqubovkyprYUHrBvT6U64nYgnq6pMA+fwuyOlckuzE1g1dz7FRUgT9CMZipY5DaBAY3H2y6e5JkCbJUUDjCPApuiHeAxdDj1hXuV241F+4xcq2HP2GCPqV37daqeqBSRwppQf8y+qNYqAHD5Glkvxr1FlH8AvsRMI80PvJOt+QZPqP/+7MJS0ZkARuw4c5UL7hq2muFrmIaNtn/u8Z4eb1/AiRAkhIlxmxv2lcwOwzeDxBhEni5SZ/MtbrPy7sWmbDK3LWUjDZNe+PA1Ehs9620jsMwgJ7VSC95bh0xUaCOHLkbHjzJZQp6MI/eihd16p3QDbTcrGvFlr5KYbhVPhNZmdL4lhbcHJFfg+sTstUSTVcCPKgPvSo5GJqTwTaVoU+NW0u4HcPveq2pRPS+ylvFutkb5gNfDFQh8a0hwB2opcYgRV6CphpZ1wri0BDLtsMfsBqCP6gU8OtGFZMAOJUZHaAmsVKi
 W7j7TlFr
 cl9q/gX8W1DsuJDmri75+94AWDxYbgwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: set the VM_MAYBE_GUARD flag on guard region install

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247753-greg=kroah.com@vger.kernel.org Fri May 15 14:05:57 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:16 +0300
Subject: mm: set the VM_MAYBE_GUARD flag on guard region install
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-8-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 49e14dabed7a294427588d4b315f57fbfcab9990 upstream.

Now we have established the VM_MAYBE_GUARD flag and added the capacity to
set it atomically, do so upon MADV_GUARD_INSTALL.

The places where this flag is used currently and matter are:

* VMA merge - performed under mmap/VMA write lock, therefore excluding
  racing writes.

* /proc/$pid/smaps - can race the write, however this isn't meaningful
  as the flag write is performed at the point of the guard region being
  established, and thus an smaps reader can't reasonably expect to avoid
  races.  Due to atomicity, a reader will observe either the flag being
  set or not.  Therefore consistency will be maintained.

In all other cases the flag being set is irrelevant and atomicity
guarantees other flags will be read correctly.

Note that non-atomic updates of unrelated flags do not cause an issue with
this flag being set atomically, as writes of other flags are performed
under mmap/VMA write lock, and these atomic writes are performed under
mmap/VMA read lock, which excludes the write, avoiding RMW races.

Note that we do not encounter issues with KCSAN by adjusting this flag
atomically, as we are only updating a single bit in the flag bitmap and
therefore we do not need to annotate these changes.

We intentionally set this flag in advance of actually updating the page
tables, to ensure that any racing atomic read of this flag will only
return false prior to page tables being updated, to allow for
serialisation via page table locks.

Note that we set vma->anon_vma for anonymous mappings.  This is because
the expectation for anonymous mappings is that an anon_vma is established
should they possess any page table mappings.  This is also consistent with
what we were doing prior to this patch (unconditionally setting anon_vma
on guard region installation).

We also need to update retract_page_tables() to ensure that madvise(...,
MADV_COLLAPSE) doesn't incorrectly collapse file-backed ranges contain
guard regions.

This was previously guarded by anon_vma being set to catch MAP_PRIVATE
cases, but the introduction of VM_MAYBE_GUARD necessitates that we check
this flag instead.

We utilise vma_flag_test_atomic() to do so - we first perform an
optimistic check, then after the PTE page table lock is held, we can check
again safely, as upon guard marker install the flag is set atomically
prior to the page table lock being taken to actually apply it.

So if the initial check fails either:

* Page table retraction acquires page table lock prior to VM_MAYBE_GUARD
  being set - guard marker installation will be blocked until page table
  retraction is complete.

OR:

* Guard marker installation acquires page table lock after setting
  VM_MAYBE_GUARD, which raced and didn't pick this up in the initial
  optimistic check, blocking page table retraction until the guard regions
  are installed - the second VM_MAYBE_GUARD check will prevent page table
  retraction.

Either way we're safe.

We refactor the retraction checks into a single
file_backed_vma_is_retractable(), there doesn't seem to be any reason that
the checks were separated as before.

Note that VM_MAYBE_GUARD being set atomically remains correct as
vma_needs_copy() is invoked with the mmap and VMA write locks held,
excluding any race with madvise_guard_install().

Link: https://lkml.kernel.org/r/e9e9ce95b6ac17497de7f60fc110c7dd9e489e8d.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   71 +++++++++++++++++++++++++++++++++++++-------------------
 mm/madvise.c    |   22 +++++++++++------
 2 files changed, 61 insertions(+), 32 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1715,6 +1715,43 @@ drop_folio:
 	return result;
 }
 
+/* Can we retract page tables for this file-backed VMA? */
+static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
+{
+	/*
+	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
+	 * got written to. These VMAs are likely not worth removing
+	 * page tables from, as PMD-mapping is likely to be split later.
+	 */
+	if (READ_ONCE(vma->anon_vma))
+		return false;
+
+	/*
+	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * the page table because there may be pte markers installed.
+	 * Other vmas can still have the same file mapped hugely, but
+	 * skip this one: it will always be mapped in small page size
+	 * for uffd-wp registered ranges.
+	 */
+	if (userfaultfd_wp(vma))
+		return false;
+
+	/*
+	 * If the VMA contains guard regions then we can't collapse it.
+	 *
+	 * This is set atomically on guard marker installation under mmap/VMA
+	 * read lock, and here we may not hold any VMA or mmap lock at all.
+	 *
+	 * This is therefore serialised on the PTE page table lock, which is
+	 * obtained on guard region installation after the flag is set, so this
+	 * check being performed under this lock excludes races.
+	 */
+	if (vma_flag_test_atomic(vma, VM_MAYBE_GUARD_BIT))
+		return false;
+
+	return true;
+}
+
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
@@ -1729,14 +1766,6 @@ static void retract_page_tables(struct a
 		spinlock_t *ptl;
 		bool success = false;
 
-		/*
-		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
-		 * got written to. These VMAs are likely not worth removing
-		 * page tables from, as PMD-mapping is likely to be split later.
-		 */
-		if (READ_ONCE(vma->anon_vma))
-			continue;
-
 		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		if (addr & ~HPAGE_PMD_MASK ||
 		    vma->vm_end < addr + HPAGE_PMD_SIZE)
@@ -1748,14 +1777,8 @@ static void retract_page_tables(struct a
 
 		if (hpage_collapse_test_exit(mm))
 			continue;
-		/*
-		 * When a vma is registered with uffd-wp, we cannot recycle
-		 * the page table because there may be pte markers installed.
-		 * Other vmas can still have the same file mapped hugely, but
-		 * skip this one: it will always be mapped in small page size
-		 * for uffd-wp registered ranges.
-		 */
-		if (userfaultfd_wp(vma))
+
+		if (!file_backed_vma_is_retractable(vma))
 			continue;
 
 		/* PTEs were notified when unmapped; but now for the PMD? */
@@ -1782,15 +1805,15 @@ static void retract_page_tables(struct a
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
 		/*
-		 * Huge page lock is still held, so normally the page table
-		 * must remain empty; and we have already skipped anon_vma
-		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
-		 * held, it is still possible for a racing userfaultfd_ioctl()
-		 * to have inserted ptes or markers.  Now that we hold ptlock,
-		 * repeating the anon_vma check protects from one category,
-		 * and repeating the userfaultfd_wp() check from another.
+		 * Huge page lock is still held, so normally the page table must
+		 * remain empty; and we have already skipped anon_vma and
+		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
+		 * it is still possible for a racing userfaultfd_ioctl() or
+		 * madvise() to have inserted ptes or markers.  Now that we hold
+		 * ptlock, repeating the retractable checks protects us from
+		 * races against the prior checks.
 		 */
-		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
+		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			pmdp_get_lockless_sync();
 			success = true;
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1141,15 +1141,21 @@ static long madvise_guard_install(struct
 		return -EINVAL;
 
 	/*
-	 * If we install guard markers, then the range is no longer
-	 * empty from a page table perspective and therefore it's
-	 * appropriate to have an anon_vma.
-	 *
-	 * This ensures that on fork, we copy page tables correctly.
+	 * Set atomically under read lock. All pertinent readers will need to
+	 * acquire an mmap/VMA write lock to read it. All remaining readers may
+	 * or may not see the flag set, but we don't care.
 	 */
-	err = anon_vma_prepare(vma);
-	if (err)
-		return err;
+	vma_flag_set_atomic(vma, VM_MAYBE_GUARD_BIT);
+
+	/*
+	 * If anonymous and we are establishing page tables the VMA ought to
+	 * have an anon_vma associated with it.
+	 */
+	if (vma_is_anonymous(vma)) {
+		err = anon_vma_prepare(vma);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * Optimistically try to install the guard marker pages first. If any


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

