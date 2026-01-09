Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A34D1A613
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 12:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34C56B0088; Fri,  9 Jan 2026 07:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB87B6B0089; Fri,  9 Jan 2026 07:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A216B008A; Fri,  9 Jan 2026 07:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B63E26B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 07:52:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55207140670
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:52:16 +0000 (UTC)
X-FDA: 84312413472.26.B46E688
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 838A320007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:52:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=T8cuR0KL;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767963134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46UrRCa2hJN3UJYlUqO5N6NJpGB6QqfxbBViMJhL3+Y=;
	b=W+NNb6dMMdD9lrPsRlNCW1HU6/HuqpgxXQYsvj7L/sPbsKxEoMTU2aiXSlUdWoHJHcr407
	qO9eQA8YBcjYDtJTJkHd2hsB7anVA80k86bK/xcAjPAkJOfZ9hcDRmvt1Gg2Nv7BDQdtwJ
	0OANfltrmtlpno3Ni+/QASDu4a70tHI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=T8cuR0KL;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767963134; a=rsa-sha256;
	cv=none;
	b=kXadA6EymsqIEuZLMU2/L6LnQzQnq+hRZ/j3guAjoCru4JXTGNaQhZmz8ak267Ck6oqK7C
	0goGSX8MYKDaRFZvbxguDMiEgQ/g1I45JurV18ByY83br/YuExj7gD35okcRmZiUjJZj+0
	nPJ23JKDhFJF25ZJPwyA+Y5OgCGSBjA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C3986017A;
	Fri,  9 Jan 2026 12:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4608C4CEF1;
	Fri,  9 Jan 2026 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963133;
	bh=B32i7GJ92mYBZxOHPnrrUKJP01RIpzSAhNnVAGL6mkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8cuR0KLxOJyhGnsj9MagmYiF0Rqo4cmXFnOBr+6FxHpMxDRGPoU2QyxJBd+YLG42
	 6eGyCZjF6cmwiB3EPuS565tYkikemzT5t338Qco9e3T2x8SmAEY/UD+YPV1MTr1CDW
	 ythBojpcpM+/Gr7/jip10C4DiFwXFhxwCQEis+hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	yuxin wang <wang1315768607@163.com>,
	Marius Fleischer <fleischermarius@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.1 609/634] x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()
Date: Fri,  9 Jan 2026 12:44:47 +0100
Message-ID: <20260109112140.546075285@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mnmcfkeuyaxg7zn6ak8ons167wgj4nrh
X-Rspamd-Queue-Id: 838A320007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767963134-750525
X-HE-Meta: U2FsdGVkX1/Wu5mOc1jxYgqXrQfIKCiqHbLFtC2z3shfIpwTnbHT/ZRb41sgc6fz5cJxYD4jHXrNeFy8Vj4EN6zwrchWWHxkMaFfll7p6Vh8Sdr0o5Y/IK6l34cr36IddgNPeQPM8lKYfnp8iaKe/2Kfoc4AFXMKs6yA1f5Sz243ygcssqYhIKYx4BsmCZ4uMsbo0d4i0a/eZZBKbwJZEeM1VLW7zJYJD8n3XpXQV7SAHUV5iKmXfgeUL5yQF24YBok+zhkuDfSyXZRwc7RSjExj3U8pUR8vGdiNkrN1zzvfRyFnj24UH7CylD3EATzxLPtyjkIPH/Rmsmmt1DR70cd7clcRq/wcXnI3PDdtocXcm/2RDyN5rVkcX3b8Xik+8fwDbgn2iwLcAvIcySES8N2/UQLAQi6OFcQNe8bM89/1shOTRePsqvzcjsemx8li2fBaTRyP3WJmm+i9zX6o16QLWaVGnv5JOx3lnZaJLYEDq55X0ttgKAnho/yiQcsjBf4Nn6B/iGoSHDGElaVKAfkvHGrnBwWxG/WX6h8EOTDJOS9aBeGyg4WpO9tcZILQRRxmG7hIa/3vk05Rei5C7kdoQwBXCaYlHqtFcDvKXrZ8iqGikqvJ8yG0E4vPqCVt17OPK6JU512wJ/Ru1XIlDI84BrDkhPBA6HgvBZo0hvL3UbMeVzna+A0QR7516U0LoaTGjRBty9LC5+G2nMqcoybg0HDe5sBw067zWSHNPBr2emp6vwNdrfc0JuRLaNmSb1FY6TOVk4NPU2SDjDXjB3liu1Q5P0V9S0bCizDPNXmSCwnq3ILvcok/k0JMl5TpB2FhXvq9XnoBncqsCU00mIvAjr77XYPoonIKvNP+UQNQ9kgPJSIygepPcH10vrfWGxi//Csyzx8NV0uJLVZWFqMTU2YVWZyOViTsnr2kQFL/pkullc8WnVwIWS3949nGkMBuw8LeoKP8iZPuySd
 UcWe2MTn
 JIMH1XhZEWAKWYX9d+MnYiftUfq9DifW5ViGwRYJ5Ze0lzUfysDG4qk3aOrwqb3imk+1Z09+XG3bX4PVpLD4D5OWessFSc28L7sakpYrKB1LDRKs7eSvEdoPBPi4y4AcORYv3bsPt0STbpew29RRw8EcJe+BH21XOs5PTA2Q4XFyFdYy5BE8XTx9dxJSk8FzKqEOnA3TBad/trsEg2lVF7d2i/GWu+K2jZWQnpiLVM4drZCrHRwgl/91w2ifuTKYiOV8qTW31gr0vl9pgZCIf1LjjAMWSWuMRpEpXOgpBMfyUQ4ymyIMs4DsLcWLWcBglw5TITWqHDHk6S2BipDdh6hmt1gdjm28BcsqAJMhcjDLX2PGLRFgbSWhBICQJc/6AyC21UR35O+FRdGNYo5+zWSVl6p20F7GprH9+J1e3WDKs7hekpKlTw0g5rRZMGkuzvkGDrDMnQbarsFSpvvGfrk/cd/q8vjVRZclk5KpwNLmnjd/umC6k3DK5vU/AGlveKIJOkidDAGFkafiq2y8qeyjdVF9KTHnVSodtdfxv/awMCW8APL+cp1Hi9T2b8Fi1z/s4Zozr9MTkN6BkEtI24K3FMPCLPrLmHg0Grs9OPGNUk65kpKyFjIZMPjwLhBY5qaU19Tw7eLGUgbcH6WpIap2+I29KVEg8aypyZBSznQuPkB5qJ9TbRlHLh/ihqDC3VUySBJxKRriwBObvTeZw7wD4Om/5TiDDxeyMA5sFinCpZ/NGmfqunRYxNcQpzwXfMq41fiKbco6JwKo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 



