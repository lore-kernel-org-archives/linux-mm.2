Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B5ED185F1
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6216B0005; Thu,  8 Jan 2026 08:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180CB6B0098; Thu,  8 Jan 2026 08:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0726B0099; Thu,  8 Jan 2026 08:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE1936B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:37:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A21E486984
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:18 +0000 (UTC)
X-FDA: 84308898156.05.10B3623
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D1F7920003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=T17QkWsa;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767879437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=QbatRZMAH9Qfbsm2qNwRY8NBU4b+Bzy6no1KBc8mPII=;
	b=LMlybvsFHk57r01agCLFVyxtlaj05IuBa42dP4LVk8URQLgnIpMXYDoHeAoUmKJhBs+qZG
	nGVceURYC+XlWg7yEuX1jr3Bx7IeWoCt9DwOFQOLTTwwZ4hYupaweurAyzhSqZgB0NP4XZ
	UZh+gwt2+C+1LOBk/9ybszILn9vXXb0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=T17QkWsa;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767879437; a=rsa-sha256;
	cv=none;
	b=j5mDZ+muqURxyIP/NUzVg1BKOznxUP03JBicnOeLmRtYJuUhkyaxL7tlU09vuojaP4a0bp
	LpjjpH21wuvTRR29Zdcgp11+3jRLyf58d3PIat0x6lN8Mj6rgzjz7Ol1PcUPd556tdz7Aj
	Mh7drLfGAh5IbbcuS6H8G0pBuUv9iLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E002044423;
	Thu,  8 Jan 2026 13:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F48C116C6;
	Thu,  8 Jan 2026 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767879435;
	bh=Y5lW1b6LjbbkNWQvqRmSHWg6tNBNmdDolIRuxrppI0U=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=T17QkWsamv770l2wIKYAIckSHqgDr9wLDCyvW+ddKidoL0JZKlWj1r+Z+GmQ4raoZ
	 TEXiclavPX3GZhUtCGR5MVRD059YjlHX/O3s/OyLdNbhU4XoQO3wF9yaFI7Qzlhm48
	 CeFbOHxAIgBH+7rDXsjOIqTb0sA5U+/XLnTQdxac=
Subject: Patch "x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()" has been added to the 6.1-stable tree
To: ajay.kaher@broadcom.com,akpm@linux-foundation.org,alexey.makhalov@broadcom.com,bp@alien8.de,dave.hansen@linux.intel.com,david@redhat.com,fleischermarius@gmail.com,gregkh@linuxfoundation.org,hpa@zytor.com,linux-mm@kvack.org,luto@kernel.org,mingo@kernel.org,mingo@redhat.com,peterz@infradead.org,riel@surriel.com,sashal@kernel.org,tapas.kundu@broadcom.com,tglx@linutronix.de,torvalds@linux-foundation.org,vamsi-krishna.brahmajosyula@broadcom.com,wang1315768607@163.com,xrivendell7@gmail.com,yin.ding@broadcom.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Jan 2026 14:36:40 +0100
In-Reply-To: <20251224102432.923410-3-ajay.kaher@broadcom.com>
Message-ID: <2026010839-superhero-comment-cd09@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1F7920003
X-Stat-Signature: sjxozh83p9xioh6zynpdkjhjw5zxgayh
X-HE-Tag: 1767879436-358187
X-HE-Meta: U2FsdGVkX18uHkwkGRD4x1deAUPJASyWnogU7xlBcAji9MVz2TlO9Nz42TkbcQC3Sj1bgdaWw5xsTNsOZSWUCQ2JGdkvi1K3CBcvJwZtIBCGUY2ekG/ATw8sB5imyB2o2CS07fP8s9QDeTEK7ewthHMek8MZ1GBWZ2kNDPvY/U3uuQAHrD2Lb/icE3jL90QYOVJbfR8WCvQJfciIr11xwKhdPce88qPemOCFnPie/DW6mx4cHuUsrk1tX73d80Fjs+QypEamV97psPuFwJAZlJJ/FmLIGDhh8Y7HNopEpbS5oVS845FRQbPkHnnMyzkid1MX68fhKNQPRhat7U97T5y4vfh2mDSyVqUJGiKEAttYgPESOUNPTMcNqrpBWrzdhnuQjcYYIAUU5OJHM+Gb3Ih214GRs+J1MI6XBthOMp3gYXtWk4snNxn2hdYeUNB31pc4agnGwtsdlK01TL4bOdGtlA98zPMdgqjrd01mhrGnpzjmi+JmGN+E8Dx9R0+YvWvy5rYy2eLcVrAdZYO6qUwq9CGT+hBCsTZVw9RKOh5iF5yPDm9wFKLuAWO7c28p3QjIVswUp5pLSeLC1JDUhtoDFZQqI9Iu3NFq2ciQl8oH7y1xYl/OemwCqodA3xwx1Fx2f/JpMXtB9gDyP9mMJ9L2gOWXl181JfxQSD5E11cJllnhfP900La8/UMMIxEpR2x1HOCted6r4oxkMyYbipHk6zdnGZHmw4TVjrsakcwqSacn9oz6qIvl3vY80SRINwDZC3w+Vq2wwJ7Dfo4T4WB2s/8iaM3D4b+MB4b5PNuluPPf1wAyKXvf5za7YRwqb/T18iEUd0GxJVMKhr2F6ubA0XSSAzLENTHFLiBkaPV4NCAXQW2PfJK+NlYIrdQiv0ZzPt5FDiUlDLZOgoA0t156B4/OCwRoa/iZ7MhsBGIRecEGI+JER97KyVrU7TbM0CnAOczHZp41059YyWR
 WaRKpCb5
 C+7A+ahOCAv5I4nKFV6gJ5zKOwBxFL72m9R+TtQHqm9b+I6B5UPzJ3FewNIOcxS6iXZ8KBvE/adnNQlL262CwiEjIzlwF+Cm1IdYebryMmsFsTh3znIJgctnSjxyLippwNQMq0luTZ0MmVn2Ce7GoBhHDlliWizKy80mIjcJ1uyAz9AZWtlP7VPPGCDD5LzEN/1XGB5If0Plgi/nQA4xV0+Mj1yKMQKM2t/WSZ+XZD2ZJx0YU/Qi9t08wCHvxOj64uIosn+wiTCtwgbnHGYZJuCI7BYckq/G+7LVgKbGLvRCSU/1itB9rLJedaFm/DJK5nMSzY8mnrH8+zlULdrvh+glM75uQMA2HgCxR6Az3pD9+Wfl+QTepcernSi7N0yHE7y2LjyUuF+T+LnV5QsPcGl5HEnJZ27TtGzleziU2Szgoz2rI1QR36/ctW1RR3MRDG6nd4a/K+3+PDq6ANcVLyg5xcEm3B7IuKON+RTuea87Y7C1xiOFY6dphVoHdwybNZMgrCySH+wxizoNKoHpNY/H9xktx5RSUt5TKEOFTnf6gB0P6EN/KPS/zDNYeJIUs4XD+jtC9lBB42jO4jmo4GvBr4hzmANVtdFUQz+os3WRYGAbJAKudReJ+3pRJBkjUR0vYA7jH4iwp1ER0qbjjgQ99C+66yCaPDYjGG6eK1OfYG8R4L0sQlvHM+XGsdGIorCoGqdJGDsXehf/0FbsdkJDJ/TduRqxqOZmwPFhKhnQc1cW8posuUhrGB7vKtapJ/T9uUVt6z6/u1Gg4ZNvhtr2Hn9C6buS43dCORPg/GD1BKaA+G30td++BtfP0h8TnN5aHqWZWt1oQKJIC8m/UTrb+/cHV/yc/aUqnhwox6B/+NaqD+52NLqpVN1t7Su0ahIFU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86-mm-pat-fix-vm_pat-handling-when-fork-fails-in-copy_page_range.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-203369-greg=kroah.com@vger.kernel.org Wed Dec 24 11:43:43 2025
From: Ajay Kaher <ajay.kaher@broadcom.com>
Date: Wed, 24 Dec 2025 10:24:32 +0000
Subject: x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, vamsi-krishna.brahmajosyula@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, xingwei lee <xrivendell7@gmail.com>, yuxin wang <wang1315768607@163.com>, Marius Fleischer <fleischermarius@gmail.com>, David Hildenbrand <david@redhat.com>, Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@surriel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
Message-ID: <20251224102432.923410-3-ajay.kaher@broadcom.com>

From: David Hildenbrand <david@redhat.com>

[ Upstream commit dc84bc2aba85a1508f04a936f9f9a15f64ebfb31 ]

If track_pfn_copy() fails, we already added the dst VMA to the maple
tree. As fork() fails, we'll cleanup the maple tree, and stumble over
the dst VMA for which we neither performed any reservation nor copied
any page tables.

Consequently untrack_pfn() will see VM_PAT and try obtaining the
PAT information from the page table -- which fails because the page
table was not copied.

The easiest fix would be to simply clear the VM_PAT flag of the dst VMA
if track_pfn_copy() fails. However, the whole thing is about "simply"
clearing the VM_PAT flag is shaky as well: if we passed track_pfn_copy()
and performed a reservation, but copying the page tables fails, we'll
simply clear the VM_PAT flag, not properly undoing the reservation ...
which is also wrong.

So let's fix it properly: set the VM_PAT flag only if the reservation
succeeded (leaving it clear initially), and undo the reservation if
anything goes wrong while copying the page tables: clearing the VM_PAT
flag after undoing the reservation.

Note that any copied page table entries will get zapped when the VMA will
get removed later, after copy_page_range() succeeded; as VM_PAT is not set
then, we won't try cleaning VM_PAT up once more and untrack_pfn() will be
happy. Note that leaving these page tables in place without a reservation
is not a problem, as we are aborting fork(); this process will never run.

A reproducer can trigger this usually at the first try:

  https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/reproducers/pat_fork.c

  WARNING: CPU: 26 PID: 11650 at arch/x86/mm/pat/memtype.c:983 get_pat_info+0xf6/0x110
  Modules linked in: ...
  CPU: 26 UID: 0 PID: 11650 Comm: repro3 Not tainted 6.12.0-rc5+ #92
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
  RIP: 0010:get_pat_info+0xf6/0x110
  ...
  Call Trace:
   <TASK>
   ...
   untrack_pfn+0x52/0x110
   unmap_single_vma+0xa6/0xe0
   unmap_vmas+0x105/0x1f0
   exit_mmap+0xf6/0x460
   __mmput+0x4b/0x120
   copy_process+0x1bf6/0x2aa0
   kernel_clone+0xab/0x440
   __do_sys_clone+0x66/0x90
   do_syscall_64+0x95/0x180

Likely this case was missed in:

  d155df53f310 ("x86/mm/pat: clear VM_PAT if copy_p4d_range failed")

... and instead of undoing the reservation we simply cleared the VM_PAT flag.

Keep the documentation of these functions in include/linux/pgtable.h,
one place is more than sufficient -- we should clean that up for the other
functions like track_pfn_remap/untrack_pfn separately.

Fixes: d155df53f310 ("x86/mm/pat: clear VM_PAT if copy_p4d_range failed")
Fixes: 2ab640379a0a ("x86: PAT: hooks in generic vm code to help archs to track pfnmap regions - v3")
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yuxin wang <wang1315768607@163.com>
Reported-by: Marius Fleischer <fleischermarius@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Link: https://lore.kernel.org/r/20250321112323.153741-1-david@redhat.com
Closes: https://lore.kernel.org/lkml/CABOYnLx_dnqzpCW99G81DmOr+2UzdmZMk=T3uxwNxwz+R1RAwg@mail.gmail.com/
Closes: https://lore.kernel.org/lkml/CAJg=8jwijTP5fre8woS4JVJQ8iUA6v+iNcsOgtj9Zfpc3obDOQ@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |   52 ++++++++++++++++++++++++----------------------
 include/linux/pgtable.h   |   28 +++++++++++++++++++-----
 kernel/fork.c             |    4 +++
 mm/memory.c               |   11 +++------
 4 files changed, 58 insertions(+), 37 deletions(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -1029,29 +1029,42 @@ static int get_pat_info(struct vm_area_s
 	return -EINVAL;
 }
 
-/*
- * track_pfn_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
- *
- * If the vma has a linear pfn mapping for the entire range, we get the prot
- * from pte and reserve the entire vma range with single reserve_pfn_range call.
- */
-int track_pfn_copy(struct vm_area_struct *vma)
+int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn)
 {
+	const unsigned long vma_size = src_vma->vm_end - src_vma->vm_start;
 	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
+	int rc;
 
-	if (vma->vm_flags & VM_PAT) {
-		if (get_pat_info(vma, &paddr, &pgprot))
-			return -EINVAL;
-		/* reserve the whole chunk covered by vma. */
-		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
-	}
+	if (!(src_vma->vm_flags & VM_PAT))
+		return 0;
 
+	/*
+	 * Duplicate the PAT information for the dst VMA based on the src
+	 * VMA.
+	 */
+	if (get_pat_info(src_vma, &paddr, &pgprot))
+		return -EINVAL;
+	rc = reserve_pfn_range(paddr, vma_size, &pgprot, 1);
+	if (rc)
+		return rc;
+
+	/* Reservation for the destination VMA succeeded. */
+	dst_vma->vm_flags |= VM_PAT;
+	*pfn = PHYS_PFN(paddr);
 	return 0;
 }
 
+void untrack_pfn_copy(struct vm_area_struct *dst_vma, unsigned long pfn)
+{
+	untrack_pfn(dst_vma, pfn, dst_vma->vm_end - dst_vma->vm_start);
+	/*
+	 * Reservation was freed, any copied page tables will get cleaned
+	 * up later, but without getting PAT involved again.
+	 */
+}
+
 /*
  * prot is passed in as a parameter for the new mapping. If the vma has
  * a linear pfn mapping for the entire range, or no vma is provided,
@@ -1136,15 +1149,6 @@ void untrack_pfn(struct vm_area_struct *
 		vma->vm_flags &= ~VM_PAT;
 }
 
-/*
- * untrack_pfn_clear is called if the following situation fits:
- *
- * 1) while mremapping a pfnmap for a new region,  with the old vma after
- * its pfnmap page table has been removed.  The new vma has a new pfnmap
- * to the same pfn & cache type with VM_PAT set.
- * 2) while duplicating vm area, the new vma fails to copy the pgtable from
- * old vma.
- */
 void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 	vma->vm_flags &= ~VM_PAT;
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1195,15 +1195,26 @@ static inline void track_pfn_insert(stru
 }
 
 /*
- * track_pfn_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
+ * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
+ * tables copied during copy_page_range(). On success, stores the pfn to be
+ * passed to untrack_pfn_copy().
  */
-static inline int track_pfn_copy(struct vm_area_struct *vma)
+static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn)
 {
 	return 0;
 }
 
 /*
+ * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
+ * copy_page_range(), but after track_pfn_copy() was already called.
+ */
+static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
+		unsigned long pfn)
+{
+}
+
+/*
  * untrack_pfn is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
  * can be for the entire vma (in which case pfn, size are zero).
@@ -1214,8 +1225,10 @@ static inline void untrack_pfn(struct vm
 }
 
 /*
- * untrack_pfn_clear is called while mremapping a pfnmap for a new region
- * or fails to copy pgtable during duplicate vm area.
+ * untrack_pfn_clear is called in the following cases on a VM_PFNMAP VMA:
+ *
+ * 1) During mremap() on the src VMA after the page tables were moved.
+ * 2) During fork() on the dst VMA, immediately after duplicating the src VMA.
  */
 static inline void untrack_pfn_clear(struct vm_area_struct *vma)
 {
@@ -1226,7 +1239,10 @@ extern int track_pfn_remap(struct vm_are
 			   unsigned long size);
 extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 			     pfn_t pfn);
-extern int track_pfn_copy(struct vm_area_struct *vma);
+extern int track_pfn_copy(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long *pfn);
+extern void untrack_pfn_copy(struct vm_area_struct *dst_vma,
+		unsigned long pfn);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
 extern void untrack_pfn_clear(struct vm_area_struct *vma);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -476,6 +476,10 @@ struct vm_area_struct *vm_area_dup(struc
 		*new = data_race(*orig);
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		dup_anon_vma_name(orig, new);
+
+		/* track_pfn_copy() will later take care of copying internal state. */
+		if (unlikely(new->vm_flags & VM_PFNMAP))
+			untrack_pfn_clear(new);
 	}
 	return new;
 }
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1278,12 +1278,12 @@ int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	pgd_t *src_pgd, *dst_pgd;
-	unsigned long next;
 	unsigned long addr = src_vma->vm_start;
 	unsigned long end = src_vma->vm_end;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
+	unsigned long next, pfn;
 	bool is_cow;
 	int ret;
 
@@ -1294,11 +1294,7 @@ copy_page_range(struct vm_area_struct *d
 		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
 	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
-		/*
-		 * We do not free on error cases below as remove_vma
-		 * gets called on error from higher level routine
-		 */
-		ret = track_pfn_copy(src_vma);
+		ret = track_pfn_copy(dst_vma, src_vma, &pfn);
 		if (ret)
 			return ret;
 	}
@@ -1335,7 +1331,6 @@ copy_page_range(struct vm_area_struct *d
 			continue;
 		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
 					    addr, next))) {
-			untrack_pfn_clear(dst_vma);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1345,6 +1340,8 @@ copy_page_range(struct vm_area_struct *d
 		raw_write_seqcount_end(&src_mm->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
 	}
+	if (ret && unlikely(src_vma->vm_flags & VM_PFNMAP))
+		untrack_pfn_copy(dst_vma, pfn);
 	return ret;
 }
 


Patches currently in stable-queue which might be from ajay.kaher@broadcom.com are

queue-6.1/usb-xhci-move-link-chain-bit-quirk-checks-into-one-helper-function.patch
queue-6.1/x86-mm-pat-fix-vm_pat-handling-when-fork-fails-in-copy_page_range.patch
queue-6.1/sched-fair-proportional-newidle-balance.patch
queue-6.1/sched-fair-small-cleanup-to-update_newidle_cost.patch
queue-6.1/rdma-core-fix-kasan-slab-use-after-free-read-in-ib_register_device-problem.patch
queue-6.1/x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch
queue-6.1/drm-vmwgfx-fix-a-null-ptr-access-in-the-cursor-snooper.patch
queue-6.1/sched-fair-small-cleanup-to-sched_balance_newidle.patch
queue-6.1/usb-xhci-apply-the-link-chain-quirk-on-nec-isoc-endpoints.patch

