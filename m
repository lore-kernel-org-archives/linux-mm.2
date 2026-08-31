Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14610C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133F06B00A3; Mon, 31 Aug 2026 10:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4B56B00A4; Mon, 31 Aug 2026 10:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BDB6B00A5; Mon, 31 Aug 2026 10:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C29396B00A3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:35:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 457761A0166
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:36 +0000 (UTC)
X-FDA: 85161813072.03.BDB8381
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7B7B24000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine);
	spf=pass (imf27.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Fk9r6VICudALutPJi8lzwEAoopugiNoG3mqsZtKzW5Y=;
	b=C1ymRce9oY6f2MTX0DJUpvcJqpNZWPusf7OXzmFFniHKN2HNPwiG101S9mNAskT2IO0Vj7
	TRHs9qyvs4ich8VJPxgFcTjZ+iBnfqbAujoME7xr1s0u1901Cz/znfK8Lvd2YvPtuAFDxF
	R1GR3CaUHJ2s5ESTbhhiadRe+ifVFWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186934;
	b=GbcENULp+Vq2pi3PahFwmRiZllI1U0iesziXEfV3es8etRei9t4HEE1sFCnZd09VPVSHvB
	q/uee+LxhKgrAVErNvegxEj0vcWk/1F6CHE3oLQp7j/90EVWMkJD7GgOFn0YbJoka0S4lf
	Ek5xHyyxTSdDs5GlEwgLhT/Yv0cGJwI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine);
	spf=pass (imf27.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org
Received: from firstfloor.org (c-73-11-123-161.hsd1.or.comcast.net [73.11.123.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by one.firstfloor.org (Postfix) with ESMTPSA id CC20D5DBF9;
	Mon, 31 Aug 2026 16:35:31 +0200 (CEST)
Received: by firstfloor.org (Postfix, from userid 1000)
	id 68D9A162257; Mon, 31 Aug 2026 07:35:28 -0700 (PDT)
From: Andi Kleen <ak@kernel.org>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andi Kleen <ak@kernel.org>
Subject: [PATCH] RCU safety for vma maple tree walks
Date: Mon, 31 Aug 2026 07:35:11 -0700
Message-ID: <20260831143511.1133029-1-ak@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qqehnnxh9gdh47okrsc3wthmm5m9djzu
X-Rspamd-Queue-Id: 7B7B24000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1788186934-654946
X-HE-Meta: U2FsdGVkX19ezrrTlncvKNSyTQuZAg8MEK14ViKxXlP7gszJuPTQd4wZTfN3Ay0kqtgZMSYbLiBh1biQNC33oZZaGikniwDFR6MTJkJVwaxkxgbHYWPi3yqOEwsCO6nnUP+glvBO65Z1f11U3o122qaGe2uVYuXRvAA/1soY7QJEUcfszP5cbUZZ4GH/HuX2KOLPd7CAi5LSYaputSxdh+2b34tsE7ynhbk8RSrVfS0E3Wi/PKp2RExZ7Y4qxSRispsbrH0vwomQHWoLkWCdJU6wnJrP0F29tWtFNCJo81rgOQoER8tb2jaqUBaF4E9UuTzwTrlbv9BZsmhBIHbHyEBhzDPWrX9kTdZbP2pL8crx5pEtLLr8JbMRO4Xk1Nd2iaL4vXokcTQ/lxaeCNVcNWDTOSAWG8KyMlpotj9PFiyQ+D+mVsJdfZH6N/ArV0A+hgojb9lFVPjZvLVS7RKEHm2548CtO/hr6onfCRBucsToml3SElmyD52CbOZIUTcoDzVUyukj7qTQYu/ynbQfNFj52xjWzcwBmm/2Aihd3R3COZdUdkh8Ulx8kep7lUn+GlI9BUssJxeSPGnAu2mKMrGxH+ygCnuETBffH1X8BpKMzKeZywENgMduSJCsAl8H/qRNDy3YB7w9m5tNb2m0qrHzR3cMaxIzgxO8NB8SDM/E4eyXLf8X8Kzp+kH1sbBZOXs403OK+e3cJcAue6moB7O/mCPfPJtvOZLNi96YE6SGBTM87y3KC1zSj6C0Rv5NentYfkW0xXkb95lkeDOu0mwTS4Ybu7C2GN+okMFCU5iL96noNLKTXdxuZ0Q13bvf1hmqv/nt6OsdMnpfAMBIn25i6g7K/Kcaq3wQh7mhNt858HjX6u4xJIVukJprtaYeIAuL7BCoE1jpZSUBAC6xrRufVIYLrvQFf8N/lTBdj9fKOZWvuqDW0aTyxi/M5asAnzXK5rbGmJWAlGcTEw3
 /qI29eDx
 +kjZc8BId/+FL3TsWWiEmN8WH2yBNPEwAKw5jIAcDszl5HFFaezFniz4D/pNGOxEqeykbZfMYqBe3dKLKKXYojh4kJ7If6eTmPkg0mLdDDZnKDGwHXFbvxfW1HOf8EXuah2gzOy/qGCobP3V9uuABUC2G9swLlaHOqiKQBuKM0Lu0WMrWNiIAYVdiI3CSMUSS4FmIkZii9sV2gidJeGvrmR/31fY94AkQRiS699CNS/VTLjDz3UUuDEQgF072LJ+PebbXhIvdqG+NFjGMxUGKzKfJZri4O8hSvFkDWx1TQ97/oQC/dI14BLJzfjBj9nXBzpDK+w7oorFMLz9G6H7l24bdjHbZF4EfNgGmEbWGHAJaRcpGjjYYXsTdmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I ran into the following scenario in a slightly modified kernel:

 1. vms_gather_munmap_vmas walks the unmap range and caches a maple node N
    in the maple iterator.
 2. It triggers a __split_vma to fix up a range and during that node N
    is queued for freeing with kfree_rcu
 3. There is another __split_vma that allocates memory and sleeps due to
    memory pressure.
 4. During the sleep the grace period expires and node N gets freed for
    real.
 5. The iterator still has node N cached
 6. When the iteration continues it accesses the freed node and KASAN
    trips:

BUG: KASAN: slab-use-after-free in mas_next_slot+0x1e95/0x2860
Read of size 8 at addr ffff8881160bdc00 by task pool-e/5770
CPU: 1 UID: 0 PID: 5770 Comm: pool-e Not tainted 7.2.0-rc7-1-debug+ #106
Allocated by task 5770:
  mas_alloc_nodes <- mas_preallocate <- __split_vma <- vms_gather_munmap_vmas
    <- do_vmi_align_munmap <- do_vmi_munmap <- __vm_munmap <- elf_load
    <- load_elf_binary <- bprm_execve          (pool-e's exec)
Freed by task 25 (ksoftirqd):
  __rcu_free_sheaf_prepare <- rcu_free_sheaf_nobarn <- rcu_do_batch <- rcu_core
The buggy address ... cache maple_node of size 256
freed 256-byte region [ffff8881160bdc00, ffff8881160bdd00)

There was also a more complex scenario when the node was immediately
recycled for the next split VMA insert, modified, but the access by
the iterator for the previous walk saw corrupted state and triggered
KASAN too.

Basically the problem is that any sleeping during VMA walks breaks the
RCU reader guarantees for the RCU Maple tree iterators. But sleeping
is unavoidable for various reasons.

I hit it with a kernel modification that makes this more likely
(It can do VMA splits on exec mm teardown)
and also in a very memory constrained environment (4GB guest running a
stress test), but based on code review I believe it's a generic problem that
could happen in a unmodified kernel.

That said I wasn't actually able to trigger it in a unmodified kernel
so far with stress testing.

The following old unsolved syzkaller report has a similar signature,
so maybe it was already seen:
https://syzkaller.appspot.com/bug?id=4c5268fbb1d6d508a4c34dc425e2693d1ff9911a

I guess in many cases where it happens for real you don't notice it
if you don't have KASAN active.

The patch fixes up all callers to maintain the RCU reader lock
regions correctly during the VMA walk. If they cannot be maintained the
iterator is refreshed by a new VMA address lookup in a new region, unless
it is proven safe not to.

In the cases where there is no sleeping it is strictly not needed
because this scenario could not happen due the existing VMA locking.

But I fixed them too to not violate the maple tree iterator
"rcu read lock or write lock" contract.

The ones that do not strictly need it are: count_mm_mlocked_page_nr,
remap_file_pages, range_contains_unmapped.

The ones that may sleep and clearly need it are: apply_vma_lock_flags,
do_mprotect_pkey, remap_move, mseal_apply, mbind_range, userfaultfd
register/unregister,
mwriteprotect_range (doesn't sleep in the walk itself, but uses iterator
after sleep)

In principle it could be optimized more, e.g. for example only do the
re-lookups when actual sleeping happened. Some of it could be done
with a new cond resched variant. But I tried to keep it minimal
for now.

The patch survived most of LTP, the kernel mm selftests and
my own stress tests. I didn't do any benchmarks.

For when it was introduced it's a complex area, but I believe the patch
that originally added the problem was
commit b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
Then
commit 17f1ae9b40c6 ("mm/vma: change munmap to use vma_munmap_struct() for
accounting and surrounding vmas")
extended the pattern to more places, and then later it was copied
elsewhere too. I'm mentioning only the first below.

No cc stable so far, needs some discussion first.

Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
Assisted-by: omp:gpt-5.6-luna
Signed-off-by: Andi Kleen <ak@kernel.org>
---
 mm/mempolicy.c   | 13 ++++++++
 mm/mlock.c       | 13 +++++++-
 mm/mmap.c        |  1 +
 mm/mprotect.c    | 29 +++++++++++++---
 mm/mremap.c      | 16 +++++++--
 mm/mseal.c       | 15 +++++++++
 mm/userfaultfd.c | 86 ++++++++++++++++++++++++++++++++++++++++++------
 mm/vma.c         | 13 +++++---
 8 files changed, 163 insertions(+), 23 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3498a5651d50..7ffdb930b60d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1062,7 +1062,20 @@ static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
+	rcu_read_lock();
+	/*
+	 * The modify might have invalidated the iterators when
+	 * sleeping happened. Do another lookup
+	 */
+	vma_iter_set(vmi, vmstart);
+	vma = vma_find(vmi, vmend);
+	if (!vma) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
 	*prev = vma;
+	rcu_read_unlock();
+	/* Iterator still protected by write lock */
 	return vma_replace_policy(vma, new_pol);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..ee5c0347129d 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -540,12 +540,15 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
 
 	nstart = start;
 	tmp = vma->vm_start;
+	rcu_read_lock();
 	for_each_vma_range(vmi, vma, end) {
 		int error;
 		vma_flags_t newflags;
 
-		if (vma->vm_start != tmp)
+		if (vma->vm_start != tmp) {
+			rcu_read_unlock();
 			return -ENOMEM;
+		}
 
 		newflags = vma->flags;
 		vma_flags_clear_mask(&newflags, VMA_LOCKED_MASK);
@@ -555,12 +558,19 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
+		rcu_read_unlock();
 		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, &newflags);
 		if (error)
 			return error;
+		/*
+		 * The iterator is always left on a life node, so no
+		 * re-lookup needed after sleep.
+		 */
 		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 
 	if (tmp < end)
 		return -ENOMEM;
@@ -589,6 +599,7 @@ static unsigned long count_mm_mlocked_page_nr(struct mm_struct *mm,
 	else
 		end = start + len;
 
+	guard(rcu)();
 	for_each_vma_range(vmi, vma, end) {
 		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			if (start > vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index e10412160b32..dfe5c51dee98 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1184,6 +1184,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		VMA_ITERATOR(vmi, mm, vma->vm_end);
 		struct vm_area_struct *next, *prev = vma;
 
+		guard(rcu)();
 		for_each_vma_range(vmi, next, start + size) {
 			/* hole between vmas ? */
 			if (next->vm_start != prev->vm_end)
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..53e4fd45d39b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -941,6 +941,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 	tlb_gather_mmu(&tlb, current->mm);
 	nstart = start;
 	tmp = vma->vm_start;
+	rcu_read_lock();
 	for_each_vma_range(vmi, vma, end) {
 		vm_flags_t mask_off_old_flags;
 		vma_flags_t new_vma_flags;
@@ -984,29 +985,49 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			error = -EINVAL;
 			break;
 		}
+		rcu_read_unlock();
 
 		error = security_file_mprotect(vma, reqprot, prot);
-		if (error)
+		if (error) {
+			rcu_read_lock();
 			break;
-
+		}
+		rcu_read_lock();
+		/*
+		 * The security hook may sleep; re-lookup instead of
+		 * trusting the pre-sleep pointer.
+		 */
+		vma_iter_set(&vmi, vma->vm_start);
+		vma = vma_find(&vmi, end);
+		if (!vma) {
+			error = -ENOMEM;
+			break;
+		}
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
+		rcu_read_unlock();
 
 		if (vma->vm_ops && vma->vm_ops->mprotect) {
 			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
-			if (error)
+			if (error) {
+				rcu_read_lock();
 				break;
+			}
 		}
 
 		error = mprotect_fixup(&vmi, &tlb, vma, &prev, nstart, tmp, newflags);
-		if (error)
+		if (error) {
+			rcu_read_lock();
 			break;
+		}
 
 		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
 		prot = reqprot;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	tlb_finish_mmu(&tlb);
 
 	if (!error && tmp < end)
diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac9..c8589c699515 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1903,6 +1903,7 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 	 * with all VMAs in the input range [addr, addr + old_len) being moved
 	 * (and split as necessary).
 	 */
+	rcu_read_lock();
 	for_each_vma_range(vmi, vma, end) {
 		/* Account for start, end not aligned with VMA start, end. */
 		unsigned long addr = max(vma->vm_start, start);
@@ -1911,8 +1912,10 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		bool multi_allowed;
 
 		/* No gap permitted at the start of the range. */
-		if (!seen_vma && start < vma->vm_start)
+		if (!seen_vma && start < vma->vm_start) {
+			rcu_read_unlock();
 			return -EFAULT;
+		}
 
 		/*
 		 * To sensibly move multiple VMAs, accounting for the fact that
@@ -1940,12 +1943,17 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		multi_allowed = vma_multi_allowed(vma);
 		if (!multi_allowed) {
 			/* This is not the first VMA, abort immediately. */
-			if (seen_vma)
+			if (seen_vma) {
+				rcu_read_unlock();
 				return -EFAULT;
+			}
 			/* This is the first, but there are more, abort. */
-			if (vma->vm_end < end)
+			if (vma->vm_end < end) {
+				rcu_read_unlock();
 				return -EFAULT;
+			}
 		}
+		rcu_read_unlock();
 
 		res_vma = check_prep_vma(vrm);
 		if (!res_vma)
@@ -1969,7 +1977,9 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		}
 		seen_vma = true;
 		target_addr = res_vma + vrm->new_len;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 
 	return res;
 }
diff --git a/mm/mseal.c b/mm/mseal.c
index 7a8ac66dc215..551b5ad52f4d 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -22,6 +22,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
 	unsigned long prev_end = start;
 	struct vm_area_struct *vma;
 
+	guard(rcu)();
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_start > prev_end)
 			return true;
@@ -43,6 +44,7 @@ static int __mseal_range(unsigned long start, unsigned long end)
 	if (start > vma->vm_start)
 		prev = vma;
 
+	rcu_read_lock();
 	for_each_vma_range(vmi, vma, end) {
 		const unsigned long curr_start = max(vma->vm_start, start);
 		const unsigned long curr_end = min(vma->vm_end, end);
@@ -51,17 +53,30 @@ static int __mseal_range(unsigned long start, unsigned long end)
 			vma_flags_t vma_flags = vma->flags;
 
 			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
+			rcu_read_unlock();
 
 			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
 					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
+
+			rcu_read_lock();
+			/* The modify may have slept and merged, so re-lookup. */
+			vma_iter_set(&vmi, curr_start);
+			vma = vma_find(&vmi, curr_end);
+			if (!vma) {
+				rcu_read_unlock();
+				return -ENOMEM;
+			}
+			rcu_read_unlock();
 			vma_start_write(vma);
 			vma_set_flags(vma, VMA_SEALED_BIT);
+			rcu_read_lock();
 		}
 
 		prev = vma;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 23fb68fce000..464570b15d4a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1134,6 +1134,7 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 		goto out_unlock;
 
 	err = -ENOENT;
+	rcu_read_lock();
 	for_each_vma_range(vmi, dst_vma, end) {
 
 		if (!userfaultfd_wp(dst_vma)) {
@@ -1150,14 +1151,18 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 
 		_start = max(dst_vma->vm_start, start);
 		_end = min(dst_vma->vm_end, end);
+		rcu_read_unlock();
 
 		err = uffd_wp_range(dst_vma, _start, _end - _start, enable_wp);
+		rcu_read_lock();
+		/* The iterator is still on a life node */
 
 		/* Return 0 on success, <0 on failures */
 		if (err < 0)
 			break;
 		err = 0;
 	}
+	rcu_read_unlock();
 out_unlock:
 	up_read(&ctx->map_changing_lock);
 	mmap_read_unlock(dst_mm);
@@ -2324,9 +2329,17 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 	if (vma->vm_start < start)
 		prev = vma;
 
+	rcu_read_lock();
 	for_each_vma_range(vmi, vma, end) {
+		rcu_read_unlock();
 		cond_resched();
 
+		rcu_read_lock();
+		/* The cond_resched above may have slept, so re-lookup. */
+		vma_iter_set(&vmi, vma->vm_start);
+		vma = vma_find(&vmi, end);
+		if (!vma)
+			break;
 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
 		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx &&
 				vma->vm_userfaultfd_ctx.ctx != ctx);
@@ -2355,6 +2368,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		new_vma_flags = vma->flags;
 		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 		vma_flags_set_mask(&new_vma_flags, vma_flags);
+		rcu_read_unlock();
 
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
 					    &new_vma_flags,
@@ -2368,15 +2382,31 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
+		rcu_read_lock();
+		/* The modify may have slept and merged, so re-lookup. */
+		vma_iter_set(&vmi, start);
+		vma = vma_find(&vmi, end);
+		if (!vma)
+			break;
+		rcu_read_unlock();
 		userfaultfd_set_ctx(vma, ctx, vm_flags);
+		rcu_read_lock();
 
-		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
+		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma)) {
+			rcu_read_unlock();
 			hugetlb_unshare_all_pmds(vma);
+			rcu_read_lock();
+			vma_iter_set(&vmi, start);
+			vma = vma_find(&vmi, end);
+			if (!vma)
+				break;
+		}
 
 skip:
 		prev = vma;
 		start = vma->vm_end;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -3808,16 +3838,26 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	found = false;
 	basic_ioctls = false;
 	cur = vma;
+	rcu_read_lock();
 	do {
+		rcu_read_unlock();
 		cond_resched();
 
+		rcu_read_lock();
+		/* The cond_resched above may have slept, so re-lookup. */
+		vma_iter_set(&vmi, cur->vm_start);
+		cur = vma_find(&vmi, end);
+		if (!cur)
+			break;
 		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
 				!!(cur->vm_flags & __VM_UFFD_FLAGS));
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_can_userfault(cur, vm_flags, wp_async))
+		if (!vma_can_userfault(cur, vm_flags, wp_async)) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * RWP uses protnone as an access-tracking marker. PROT_NONE
@@ -3827,8 +3867,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * mprotect() must still be unregisterable, so this is not
 		 * part of vma_can_userfault().
 		 */
-		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur))
+		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur)) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * UFFDIO_COPY will fill file holes even without
@@ -3839,8 +3881,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * F_WRITE_SEAL can be taken until the vma is destroyed.
 		 */
 		ret = -EPERM;
-		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
+		if (unlikely(!(cur->vm_flags & VM_MAYWRITE))) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * If this vma contains ending address, and huge pages
@@ -3852,11 +3896,15 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 			ret = -EINVAL;
 
-			if (end & (vma_hpagesize - 1))
+			if (end & (vma_hpagesize - 1)) {
+				rcu_read_unlock();
 				goto out_unlock;
+			}
 		}
-		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
+		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE)) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * Check that this vma isn't already owned by a
@@ -3866,8 +3914,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 */
 		ret = -EBUSY;
 		if (cur->vm_userfaultfd_ctx.ctx &&
-		    cur->vm_userfaultfd_ctx.ctx != ctx)
+		    cur->vm_userfaultfd_ctx.ctx != ctx) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
@@ -3876,8 +3926,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * into the other mode. Require an unregister first.
 		 */
 		if (cur->vm_userfaultfd_ctx.ctx == ctx &&
-		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
+		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * Note vmas containing huge pages
@@ -3887,6 +3939,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 		found = true;
 	} for_each_vma_range(vmi, cur, end);
+	rcu_read_unlock();
 	VM_WARN_ON_ONCE(!found);
 
 	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
@@ -3980,9 +4033,17 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	 */
 	found = false;
 	cur = vma;
+	rcu_read_lock();
 	do {
+		rcu_read_unlock();
 		cond_resched();
 
+		rcu_read_lock();
+		/* The cond_resched above may have slept, so re-lookup. */
+		vma_iter_set(&vmi, cur->vm_start);
+		cur = vma_find(&vmi, end);
+		if (!cur)
+			break;
 		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
 				!!(cur->vm_flags & __VM_UFFD_FLAGS));
 
@@ -3991,8 +4052,10 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 * the one used for registration.
 		 */
 		if (cur->vm_userfaultfd_ctx.ctx &&
-		    cur->vm_userfaultfd_ctx.ctx != ctx)
+		    cur->vm_userfaultfd_ctx.ctx != ctx) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		/*
 		 * Check not compatible vmas, not strictly required
@@ -4001,11 +4064,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
+		if (!vma_can_userfault(cur, cur->vm_flags, wp_async)) {
+			rcu_read_unlock();
 			goto out_unlock;
+		}
 
 		found = true;
 	} for_each_vma_range(vmi, cur, end);
+	rcu_read_unlock();
 	VM_WARN_ON_ONCE(!found);
 
 	vma_iter_set(&vmi, start);
diff --git a/mm/vma.c b/mm/vma.c
index 35e7a64855fa..e00b0cdc3d83 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -614,10 +614,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	validate_mm(vma->vm_mm);
 
 	/* Success. */
-	if (new_below)
-		vma_next(vmi);
-	else
-		vma_prev(vmi);
+	vma_iter_set(vmi, vma->vm_start);
+	vma_find(vmi, ULONG_MAX);
 
 	return 0;
 
@@ -1573,7 +1571,12 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 #endif
 	}
 
-	vms->next = vma_next(vms->vmi);
+	/*
+	 * The loop's cached node may be the one a split's store deferred.
+	 * Continue from the range end.
+	 */
+	vma_iter_set(vms->vmi, vms->end);
+	vms->next = vma_find(vms->vmi, ULONG_MAX);
 	if (vms->next)
 		vms->unmap_end = vms->next->vm_start;
 
-- 
2.54.0


