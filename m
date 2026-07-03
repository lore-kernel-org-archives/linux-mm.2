Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF3DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0030E6B00D0; Fri,  3 Jul 2026 09:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7FE6B00D2; Fri,  3 Jul 2026 09:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96746B00D3; Fri,  3 Jul 2026 09:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971E26B00D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 139B8165EE7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:38 +0000 (UTC)
X-FDA: 84947565276.30.49FFFFB
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf10.hostedemail.com (Postfix) with ESMTP id 143B5C000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b zEu4wP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=nUmfjBH8;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085796;
	b=rJCTIQMa5yUSgYRsQ67ZrQRKrotIzrgauiOe2HE9YUqk4zvF+VXcO+rI9po0NN7NJU52f+
	FZ44rP3ZECth2S3piWPUCRFFqCvDpJmV6xPXWUCBz/5a7zt5uWouVK8ROPS/+n6x2IrfLa
	XseisMyQ+eQniQ5ViEAPL3T7FgnMQI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kwZ9VIKx9z0IS8jwVBFwzJMwlfWORNZbbRCrQx/2uc=;
	b=igsy/HTr7EMZIBmNCrBoRW7yAurCewsofFIk9bP+5eEUdCgQAAT6j6/bf/glA3cQDGG4Ir
	b6nuLixCLG9Q46HjI0LYpss4aI9ESpIi+rUGQCbLX71i4hLV7f1d2SmyGY99VVY4reRBif
	pQGBytN8KhVfQl8DlKWlYd4siuC5RuY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b zEu4wP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=nUmfjBH8;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E408C7A00A7;
	Fri,  3 Jul 2026 09:36:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 03 Jul 2026 09:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085794; x=
	1783172194; bh=2kwZ9VIKx9z0IS8jwVBFwzJMwlfWORNZbbRCrQx/2uc=; b=b
	zEu4wPvXFoR/Krg8RXIEh5gB6JkP3lX3pY1RiO0LoVk1HIias8mbInsRNoxZYJTw
	lmx2yfcHZ3SbDsSUhXfohjXUROwPnycjZ5clBa5sqQabNYH1uwNynJhz0pNvJXV7
	HYSZtGIJfXFvA7n5AbqwewQgWSsSU8mUeT9QzsBy6DsYBO5NQ5LVLvNSw7KPGsk/
	A9timR5lSF8RdJ/6BrysKclsydLbQ2RwcqwiHmjGW7MAodAXIqbHSFqT5DX7Tq4S
	HI70XdJs0MD+FDrjP4SN0vQX0ZLoXTu+HPuCdSxt3ZsluihFzSuJHOJlAjd/Fbp+
	1ao9dwoqvio/ceKbfIg5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085794; x=1783172194; bh=2
	kwZ9VIKx9z0IS8jwVBFwzJMwlfWORNZbbRCrQx/2uc=; b=nUmfjBH8JSUUv2Afq
	alcL26D8iakP5csrCPV44ioIGtmCKU7mIxDYjYFhmuOxLyMlJ9uJNgQNruVxsg6N
	FN7c3+lf4s0Pn3OuUqidlJ198aNN2yQ3Al0Ct5JXcFTDwyrgK5tOOYzQEJ+yL3tr
	ojJDV/pLdBiUudAl9QPwV/bClBPRMR8bqLLe+YusGc2Zop9xAknt4DGI1CZGQ+P6
	cb7/b/LF3LzA6QApTBxzMAzDz/SUVeMB6zSqDvvxyQBfBtHhjGkhvgaBbcBWpKFa
	TDUqA6nyFAd4plTPWyN2IbIFqUPQVcMLa0SQUipJVU1l1Io54vpAi40tb37VjEen
	uY2cQ==
X-ME-Sender: <xms:4rpHar7_teLw9X0fC3TQEdEKkQYYsEQmq6aTG13RPjNz_9x5-Ky3oA>
    <xme:4rpHaszXJ9sGn_ZeFvAHY8oEQb0IsNA1jVCKMCtG9J5SRqHO0WonQhgBX39_UOq0k
    WkgsfeoUAc39l0CD4eUggZhaCDj_gksISkMINy6QIniJUeHkEtUT78>
X-ME-Received: <xmr:4rpHarQ6xGVpQXA_OT00q7E91oq9nBrOI-hpuxFEC8j3XWe2ixWfEpE0CkituQ>
X-ME-Proxy-Cause: dmFkZTFQDL0sPRW30T/r8/WmDkXdFgjoaIX9vLNwohRjptYUed9306bo5V6gIx9MoEqVUL
    DOWAtjg8MmvSrTWg8GgGs2eP/FFDGLHYqX57o290l8bdH3IY0k+xW1ZYR304ONNSUwYaQK
    Bo4+Emve+flZyIIVzN32HB6G/Lort/YA8L1H1gsxabb9oSnL9XvWud+W3vggQeX1PoJ/lr
    b3eqT2nN+Fc3cRZtM5ggLz7p6oZndcDaRsjYfSAitKmZJei9EqcM8LdM+VCLGFHLAlSKAA
    8tPrvpHjoO9CczAcEbCuu4vVAaqfuT+lM6L0awrERU/Twntj2KE6oGoO3CSAB1ADqLwybk
    clFC2m3sjFxCPEwdzWavSrdnBzBtXTZ8tjrGm6bTikgbOPzleQxrbdsTcKKoAMj4JHCE9I
    LR6WutlBBFZ62lma5seN9wlLVaqYqCOzrfhKkxqtNvqixixJbk/LRexhVZZzRkzftaGvll
    bkrtbqZXgBcCNnPqWaug+c/z05wh6fhE72Z9EMer7nC845lJwMTkxLXVfVvTWJn0iHo+Se
    71UpfZU3tDJ+Ly5NkR4WqdMPM8ZhgFYPS+tekaFagO+nD1dXWpI3tMlobxcGzn1jGdRg9J
    /jYNikL2gYc7IAR/1BoZiZeZklglBjmR/pXd2pYzKUl6bxIg1rNhx5n+zTIw
X-ME-Proxy: <xmx:4rpHak8JA6aQ_4C6chDcts8poc8craoR8vclh2hmQeEKuAst-2SrkA>
    <xmx:4rpHaoICxX-W_FBP2EF3GQmHSMzXgQQ0N35IsLyFg6tob5apSq0q5g>
    <xmx:4rpHaosD7MJtXPUL7oE5uWBoVLlroZQ4LkPkWYVDkl-zs3nFybbCmw>
    <xmx:4rpHahmTcjDvlJf2xa1NqPxhDeS-PcuG_AZcPiIoHa_tgRM55iIDMA>
    <xmx:4rpHaiJZd8ieYoyNMGb55n--G7VCI2zQFC7GhjmFsuM0r78Qyc9S8UFh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:33 -0400 (EDT)
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
Subject: [PATCH v8 07/15] mm: preserve RWP marker across PTE rewrites
Date: Fri,  3 Jul 2026 14:36:06 +0100
Message-ID: <20260703133615.1039465-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9zaw3uw7tstqe5jtzzayezcfmtqw6uai
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 143B5C000A
X-HE-Tag: 1783085795-771655
X-HE-Meta: U2FsdGVkX19IWYegsxP2uaMHYZQsD9RxMRHeuMZiiu/Lu/cFIK6v1SGGF19ZcNqoQJCmRgFBvcN/v09Y+kTixxsQ73LY9JCQjltxK/fJpRSi98XNrRsS+Cf2bQ5UsrDuT/P4STD/VnPP6Wy+tYy0EcXcgx2xshCuDLB9GRWTOSj1nD6YvcgFZALIp4PkrDYtH3wA+g7WV+ffuNI/qrxo+l5Fa7O+aWMtnaiqK5/52Iw0rbTzsmudx3xiQn7XYj827ubdD7d0v4nXIBr50P8bXnMHIlh6w1v2fpHnqWgEE4/I6fly5MyKsXRHv6G6t/gpmAgtOLSMkrUr75+lBcdc6SFEuzfLpnUJPyqOASgbAwEf+ga3l2ga5skyWFRag4sgi2cnSxi/9Abl6iRJfoLFyPkNo6sLT9OW9KmAgSPGAP47yAHGmIrUWE2/gqj+IOU6sbBC5Ff2hD/IzzuTz2+fUQNd9YH+RqrS5/T2fKduXgf/NfIPQWA4AI7yNpIBqkSZ0IQ6nhRkZAoHOmxf2suj2QgWKrWw89k0atDcysqRrz1F2ylUMqdd4qhJ4whXcelkiLCdrqRxctml4kdoDrmNzEbmnTWXaXiKJmlgQp90ISb2tcdBIJAh4khK1pysKUMhcklhUQQ9Gcojp7QR4Yj7bcDJBKeo+DKOWHiubi3KonE4k0rmTxokdX6kVLgYLuQpDrmw1QbOosohq4NrBXnzlAcMBVme6olX56P+sY9sbs9DP9ZwAJXi3QOah5geGqnOhe5/p0K70S2asOZQiT4mdEDrhpFy7f+BgqCVNkcBAO9/uUFg+57xSKD1wKI0wKKbA7jGh/vx1B3KJUJiNX8RVSQk0AZPi/WkJ+YmZdGI37DE65P+2S8ZWw03f6SuiEb4chg37GqTEHC21saaY1sWtcVLvJdJ1vnLNWk/2as5T07GOsrO8BUy6ibuMBOkZoe5aGkMiOrtckTuWCZCHcd
 km7iUplZ
 h+zbesPfnivn39uBV0mHgq+4rp6rhSEE8fKORUmtW8eMspyxTKMpOTfxDncN4f+gugMWnKUQrJCHqBtM5YKZnvNv/eb+R8IfXdJSOQurul969XogZGZKbqw9sKFSNNZZ8ZZqBpgYmmFhnLSxovvz+fG3CIAB5f/JJLV00nqoS4/PtSzFLr/56a97OFkLcwKlGeruHwA0HAuGcqFWBJwE9/7PlNtbFT1YrWUrCMxCHyT4UyrumSdCG8z/B+fbKFIyGOjuRmt7r3GEd7FX48UhmzpUuhS+A3WuwWYVZ788ipnubmHAYWdx/E8CtzK182oORDCmJTwHemi0SfZXF/1O4EymjBVDqgHt0XE/AXS28xpCz2hqRzxHNKNQwnmzmzvTnptTxaxfLwBlXC/7OpyzInyIfh8CAo01oYqOoGDCLG0CBeq5CNrny5a/HjDxxo0cWCFXDP4EYL7WbFj0=
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
index b352b0dfe1ba..ddf8d2e49c12 100644
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


