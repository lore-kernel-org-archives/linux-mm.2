Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACFC606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3CZxphp
Received: by kanga.kvack.org (Postfix)
	id ADC276B05B0; Sun, 25 Oct 2026 06:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D0C6B05B1; Sun, 25 Oct 2026 06:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BBF6B05B2; Sun, 25 Oct 2026 06:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7A76B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:43:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9A15A8025
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:43:27 +0000 (UTC)
X-FDA: 85360812054.17.0B8124C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 337DC40003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:43:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3CZxphp;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792925006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xffbGi4hUQ429LW9ZUeZF1+LfMimB5aeJ4CZmOxEQtg=;
	b=4WaGitfuMN5FPRzRINFaWhI9A9OxmeZlwXzh8eZcMD3HwTpXDmzQAtVVn9FCbTLNSTpk/0
	nboe2hmwV5WjxOvPxX7Ug1PQRL2sw5Yqakgu/BAQt532TUN/lbbllOF9jwdw8VvGo1bQE1
	Mlm29iacD4MbN2XlY36nc7hJa0SITqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792925006;
	b=5eih5hXYplsA4ngoCMsss9jmQaylvH4mGHekJ7SJLxDCATrThEEES4pnO6c/oqZddZFOqQ
	k72YzkO/ieDpqzCS0PpZI9ayH9uXyMcXyf7Jhz1/nRHbUuNC/J3H+H/eiAHUTGdoy/xSrK
	XYUdmh3lDFlShmi/+0e9NKJOup2yBvM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3CZxphp;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59AEF600D4;
	Sun, 25 Oct 2026 10:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E301F01825;
	Sun, 25 Oct 2026 10:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792925004;
	bh=xffbGi4hUQ429LW9ZUeZF1+LfMimB5aeJ4CZmOxEQtg=;
	h=From:Date:Subject:To:Cc;
	b=C3CZxphpHiOCi2irZ9t1RK88ap4g9olyDyjP3uYu0WM9d4OtT/espqfINf9Qx9H0w
	 313KkH1e9aBAT4z5/YiL7r+OgR2LN+V3kkQkJmKnG14ol71LD5d3wQc8EqiPTY2llh
	 rZgtXvymLvCLLs9aYG6U10xFzbDSIWk+h3XxNGSRVeQzdBhm+ALKdkcHYbSFv2cgJK
	 7O3IZJkaX7rCajaIYqmJMt72m+c8jqpIkYC4GSwpM9jUj+hIORpPHW0v+jOBPrO96y
	 mNbEgIEKNB/L2LvX8QbkwFcIMH+BKhehktcis66kajgbLrAnig320ne26MAlUoLO3v
	 9JJHzlklOpcZA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 25 Oct 2026 11:43:15 +0100
Subject: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
X-B4-Tracking: v=1; b=H4sIAELd3WoC/yXMQQqEMBAF0atIrw3EgDJ4FRFJ4p+xBTWkVQTx7
 mZ0+RZVJwkiQ6jOTorYWXiZE4o8Iz/Y+QfFfTIZbapCm1IFxG6fbDfZIMrDOg33qXRfUkpCxJe
 PZ9e0r2VzI/z6f9B13TxBo45wAAAA
X-Change-ID: 20261025-per_vma_maps-ceab0eb860d5
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10280; i=david@kernel.org;
 h=from:subject:message-id; bh=My3G5nJK6ccCcdRGF+U6MrgVdMR5IQxU02L9thUNN84=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu3nXbJ9p91kJ2zh89bk89RpcgXWuHB4vcWb4XH278N
 OvOqfaJHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkvycjQ3PZsS+LV/MaNYZk
 feftblJeqCX68JJ8pVtN1/JbDl+XODH8D9tr5BR9rudPnmzwvjdB+ux3cz+GFM5bcfrDow9K9w2
 2MgEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 337DC40003
X-Stat-Signature: sqwaxeh8ns3joc7kmqmi4r1qmfs8s8pg
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792925006-46814
X-HE-Meta: U2FsdGVkX19kE1IyErJ+UQ2xsT7iyRsu1gfOPQvbZQ/tl0eaaFbNh6QEmQbMR1F0hfMGeutY/BnVGEW/EzXKGH9bfn9/r23g7kf41JBBiRcHJtDlswRg1uBPF08xb/ioL/lg2rjeFKpiRrieIhXNps74NOn4EzeHX961Yqdf2dctw8VwfelbVLY+ALSeTH7OD/6VX0u2tklTXakFyf8el+dakI1Cq9GwEfoCPT9ilcSW0kRJUztNKvHDBF/ufrx4RXEnTyNAxPe5nstV8JkRpco5wVLNzhLFi6dVyT2iPuO68VVOqTijDelCNYNvevCHA3Gkb9VtzmL6nPHIAczC0rgvBjMxVEviVDjZ4G3i08GCKyhYZKNQAsXOoxHpgj08b/gD9S3yMhhKwkOTMm4ALzG1H6G3E6se7PofL23jLGRh6rKqALFeVCgpY+7eqJHZjTmv1vuRdBo0lVOasA3/hTZ0ZmhwZJ1JUKUGWZh8sxIJISO8dQRVOk8BcXqm5mEEGeq+1Li2395Yjjf3JUXoSzqGfnRsoNA4yMYjcRTArzEGMqPeeFzhyxx2lEIn5f4HHXdtk6lliKn+UAoJinQZsVT+Py1pThyJh7dmhZai5vU6kllCl+cdva/K3VapczYsZk6AblO9+avCiT7wA4qeVHFWobcdbVoz7zLAsppdvr/eNq/Iiv6IkdMpl47Vb+Rv9lRH0YGVkPndnEGAxnkuzBgudDJg3evxtWV8cmAZSxEr+IWG4HqHvV7ao58eDAWKAuJSjLbFwLF3wIlT1LGqTYcv3R3puKpGzwwp6vpsWR4W4dx1pH0/bvE2uTLXLSwt9wb6zF3USN5KNNPzjVCtSlYLn9Fm5k2SyVwbzxydFuGzF2g+rreZuIVVsIt0OWBq4l3Ev+eE58ul/ZjAsAQzQqrM2Jhtbn6+cJZPTi6UezYU7mqtnHoi6qCT2gNb837CHcFrnKgYHG0n7JyxM5A
 NUS/Tw8r
 RIatE+PIWI+T0lWDqVHO5QHzJIgQBbX1PwH648JxZNlHy8DBwAFxbBShXfr3uRPXvGgEQgZQ0Wl5AGtu40DI+AaVNGPTcrltQXnbvOvT6zhKoE55FkkUeoqiQQFT+NQKds8K1YJaD7snZi2+hWxDtk2BzPU0Ye+hyQQA7koQiniGjzTgaVEX+//rjW5YB8Zz8+BAzmyDCAsNjaDffQYmA6+klrhAsHfRIGggu+BPXcVF7CBi7jaISME5X8rckfN/EHRptcDfREKD3brfZOjOGt2sqfzRmuZtAtPnF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reading /proc/PID/maps under per-VMA locks can skip continuously mapped
address ranges during concurrent VMA splits or merges. This violates the
guarantee in Documentation/filesystems/proc.rst:

  "If there is something at a given vaddr during the entirety of the
   life of the smaps/maps walk, there will be some output for it."

lock_next_vma() reuses a tree iterator across calls under RCU. The iterator
remembers the range of its last entry. When its node is replaced,
mas_next_slot() walks the tree again at the last index of that range, then
advances past the entry containing that index. If VMA boundaries changed,
this can skip a range that has not been reported:

 - A lookup finds [A, C), then mprotect() splits it into [A, B) and [B, C)
   before vma_start_read() locks the first VMA. The reader reports [A, B),
   but the iterator still covers [A, C). The next call starts from B yet
   advances past C, omitting [B, C).

 - The reader reports [A, B) and unlocks it. A concurrent mprotect() then
   merges it with [B, C). On the next call, the iterator resumes at B - 1,
   which now belongs to [A, C), and advances past C. Again, [B, C) is lost.

Checking the mmap_lock sequence only within the next call misses writers
that completed before that call began. Also, a NULL result is currently
accepted without validation, so a race can terminate the walk early.

Even a fresh lookup can skip a mapping. Suppose it finds a gap before
[B, C). A writer inserts an adjacent VMA at the end of that gap, then
merges it into [B, C), replacing the node. The lookup resumes at the old
gap's last index, now inside the merged VMA, and steps past it. The
original [B, C) remains mapped throughout. Repeating the forward lookup
is insufficient: another merge can make it skip the same mapping again,
returning the same later VMA or NULL.

The fresh-lookup race also affects /proc/PID/smaps, numa_maps and
smaps_rollup. Resetting the iterator after gathering each VMA's statistics
does not prevent a merge during the next lookup. Fixing lock_next_vma()
also prevents omitted entries and incomplete rollup statistics.

Keep a saved sequence in the proc maps locking context and validate it
before each lookup with mmap_lock_speculate_retry(). If it is even (no
pending writer) and still matches, reuse both the iterator and the saved
sequence. Otherwise, restart at from_addr and sample the current sequence
before looking up the VMA. Only refresh the sample when resetting the
iterator, so a writer between validation and the lookup cannot go
undetected.

The smp_rmb() in mmap_lock_speculate_retry() orders the previous lookup
before rereading the sequence. It pairs with smp_wmb() in
do_raw_write_seqcount_begin(), which separates the sequence increment in
mmap_write_lock() from subsequent tree updates.

Validate detected gaps (from_addr < vma->vm_start) and NULL from
vma_next() against the sequence. If there were concurrent writes, use
mas_walk() to check if the writer could have interfered with the range
of interest. If the range is not empty, something interfered concurrently
so we retry under mmap_lock. Checking for empty ranges avoids taking the
mmap_lock just because an unrelated writer changed the sequence.

Original fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock")
Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I neither understood nor liked the original LLM generated fix that was
provided to me, and I (and codex) think it was incomplete. So I tried to
come up with a better fix that avoids additional fallbacks to the mmap_lock
while trying to keep it simple.

I won't claim that I am now an expert on the code, or that this is the
most elegant fix. It is quite complicated what we built ... too
complicated. So if this goes into the wrong direction I'll be happy
if someone else wants to take over ;)

I reproduced the races with /proc/PID/maps, and with this patch they are
resolved. I did not manage to reproduce the races with the new
smaps/smaps_rollup, but the races are slightly different and harder to
trigger.

There is the issue with seqcount overflows that Lorenzo is tackling. It
probably interacts here as well? Likely, but that's an independent issue
to resolve.
---
 fs/proc/internal.h        |  1 +
 fs/proc/task_mmu.c        |  6 +++--
 include/linux/mmap_lock.h |  5 ++--
 mm/mmap_lock.c            | 58 +++++++++++++++++++++++++++++++++++------------
 4 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index df873df9afc56..f3e846b574d79 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -386,6 +386,7 @@ struct mem_size_stats;
 struct proc_maps_locking_ctx {
 	struct mm_struct *mm;
 	bool mmap_locked;
+	unsigned int mm_wr_seq;
 	struct vm_area_struct *locked_vma;
 };
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ee9fc2fd2b2fe..dc3adcffb6d9c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -148,6 +148,7 @@ static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
 {
 	lock_ctx->locked_vma = NULL;
 	lock_ctx->mmap_locked = false;
+	lock_ctx->mm_wr_seq = UINT_MAX;
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -160,7 +161,8 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 		return vma_next(&priv->iter);
 
 	unlock_ctx_vma(lock_ctx);
-	vma = lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
+	vma = lock_next_vma(lock_ctx->mm, &priv->iter, last_pos,
+			    &lock_ctx->mm_wr_seq);
 	if (!IS_ERR_OR_NULL(vma))
 		lock_ctx->locked_vma = vma;
 
@@ -523,7 +525,7 @@ static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ct
 	unlock_ctx_vma(lock_ctx);
 	rcu_read_lock();
 	vma_iter_init(&vmi, mm, addr);
-	vma = lock_next_vma(mm, &vmi, addr);
+	vma = lock_next_vma(mm, &vmi, addr, &lock_ctx->mm_wr_seq);
 	rcu_read_unlock();
 
 	if (!vma)
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 28e3696ce9ff3..e33d15ce6a876 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -511,12 +511,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
  * Locks next vma pointed by the iterator. Confirms the locked vma has not
  * been modified and will retry under mmap_lock protection if modification
  * was detected. Should be called from read RCU section.
+ * *last_seq must initially be odd and is kept across calls.
  * Returns either a valid locked VMA, NULL if no more VMAs or -EINTR if the
  * process was interrupted.
  */
 struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
-				     struct vma_iterator *iter,
-				     unsigned long address);
+		struct vma_iterator *vmi, unsigned long from_addr,
+		unsigned int *last_seq);
 
 static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 {
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 2f94ee0fdee2a..0f3a4e0c5520d 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -400,21 +400,50 @@ static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm
 	return vma;
 }
 
+static bool vma_range_is_empty(struct mm_struct *mm, unsigned long start,
+		unsigned long last)
+{
+	MA_STATE(mas, &mm->mm_mt, start, start);
+
+	return !mas_walk(&mas) && mas.last >= last;
+}
+
 struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
-				     struct vma_iterator *vmi,
-				     unsigned long from_addr)
+		struct vma_iterator *vmi, unsigned long from_addr,
+		unsigned int *last_seq)
 {
 	struct vm_area_struct *vma;
-	unsigned int mm_wr_seq;
 	bool mmap_unlocked;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu read lock held");
 retry:
-	/* Start mmap_lock speculation in case we need to verify the vma later */
-	mmap_unlocked = mmap_lock_speculate_try_begin(mm, &mm_wr_seq);
+	/*
+	 * Restart by address if a writer could have changed the cached range.
+	 * The retry check's smp_rmb() orders the previous lookup before reading
+	 * the sequence and pairs with smp_wmb() in do_raw_write_seqcount_begin().
+	 *
+	 * The vma_range_is_empty() checks below avoid unnecessary mmap_lock
+	 * fallbacks.
+	 */
+	mmap_unlocked = !(*last_seq & 1);
+	if (!mmap_unlocked || mmap_lock_speculate_retry(mm, *last_seq)) {
+		vma_iter_set(vmi, from_addr);
+		mmap_unlocked = mmap_lock_speculate_try_begin(mm, last_seq);
+	}
+
 	vma = vma_next(vmi);
-	if (!vma)
-		return NULL;
+	if (!vma) {
+		/*
+		 * There is no reason to fallback if there really isn't anything
+		 * in the remaining range.
+		 */
+		if ((mmap_unlocked && !mmap_lock_speculate_retry(mm, *last_seq)) ||
+		    vma_range_is_empty(mm, from_addr, ULONG_MAX))
+			return NULL;
+
+		rcu_read_unlock();
+		goto fallback;
+	}
 
 	vma = vma_start_read(mm, vma);
 	if (IS_ERR_OR_NULL(vma)) {
@@ -442,15 +471,14 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 	 * it was not shrunk after we found it and another vma has not been
 	 * installed ahead of it. Otherwise we might observe a gap that should
 	 * not be there.
+	 *
+	 * If speculation fails, avoid taking the mmap_lock when a direct lookup
+	 * confirms that the gap is empty.
 	 */
-	if (from_addr < vma->vm_start) {
-		/* Verify only if the address space might have changed since vma lookup. */
-		if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr_seq)) {
-			vma_iter_set(vmi, from_addr);
-			if (vma != vma_next(vmi))
-				goto fallback_unlock;
-		}
-	}
+	if (from_addr < vma->vm_start &&
+	    (!mmap_unlocked || mmap_lock_speculate_retry(mm, *last_seq)) &&
+	    !vma_range_is_empty(mm, from_addr, vma->vm_start - 1))
+		goto fallback_unlock;
 
 	return vma;
 

---

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

change-id: 20261025-per_vma_maps-ceab0eb860d5

--

Cheers,

David


