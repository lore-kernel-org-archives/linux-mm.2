Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EE5606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODYY2RNK
Received: by kanga.kvack.org (Postfix)
	id 72E1B6B069F; Tue, 24 Nov 2026 07:26:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B80F6B06A1; Tue, 24 Nov 2026 07:26:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FA66B06A2; Tue, 24 Nov 2026 07:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA176B069F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:26:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B28E81A0B44
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:34 +0000 (UTC)
X-FDA: 85469935908.23.957398F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D43DD140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODYY2RNK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795523193;
	b=0chYF/aT2TaTc3u8X7kMSlAXkVIHhGh0driurCQvn/J3znIBjOX7aiEFnvS5IM2P1EwwvJ
	gys1/II7wdkBybVsqvFzxNTdLHx3yisoejdME3/FJoKkuwGat21BMsFkh3UzOqjEvj7jkB
	VkIPmK4o9vm/20+UyXhDnvt0MsaXYYw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795523193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hFysRZm2paHUdFhCRfxcIIS3foCC4VVjBtTGE4wazrs=;
	b=f1Se4BMFUgsTPtGZcNThhUNtDqV766t7u5LAcqpohIg167g+uM5v100jDjwoLOW4wKS4Qx
	PI1JAq3zF58kiW8MHCYBENSq3j+er2u/i4G7GvNbW/HoMj+EFYU1Ps6OtAkyDO+uSmokSh
	CbN25TRFW1ikuXl6c7UVSjSx4XIzFKs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODYY2RNK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72784399F;
	Tue, 24 Nov 2026 12:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE851F000CA;
	Tue, 24 Nov 2026 12:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795523191;
	bh=hFysRZm2paHUdFhCRfxcIIS3foCC4VVjBtTGE4wazrs=;
	h=From:Date:Subject:To:Cc;
	b=ODYY2RNKjzu8jIgwkOLEBWkI77tStWgeqsEe6+Fug+OOqm4I+MnvOdewXjZ01AdNR
	 rGEacdmM7g2Rlh+Khr0lENI7/5lPw4OJS0sA0ukU8opq2iSTzH6quEaYJvtwDqD5kZ
	 y7LLmpFR3CsNqMKxwOs7tdDfQ/nV0TECOu02fyC0A63QUMymFsXJhZj4k0HYTJ9rhv
	 Jfyrw6b+L90rtNr56yIATV4IGxnIO+5TiOfNIXy/cm7cdrbt1mSNMBCjiqTrHyrQjW
	 mIu/dw4Ql2YSTDmpIjwbcsfUO0STGJV3EaqfK9LUKOQmG8Bhu5HMuU6DCXj44bZYc+
	 oDW+jQbBuu2Ug==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 12:26:19 +0000
Subject: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3MUQqDMAwA0KuEfBswRRz0KmMfWRq3sLWVFsQh3
 n3gO8A7sFtz6xjhwGabd68FI/AAqG8pLyNPGAHDGGbmMNGWhZpJom/VD+WcWl1J+q8oPWXimyZ
 WXkYcANdmi+9Xfn+c5x+YxNA5bAAAAA==
X-Change-ID: 20261124-vma-read-lock-mmdrop-async-ba417cd1c1f0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Puranjay Mohan <puranjay@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 ljs@kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5120; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lD6iWKFGqf6N+AjnDoi6ykJCOhX6nhAXibYpUbFGOlA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZmwq+8LBPaZ8ZXcf0QiFoasyWXyqcPqelREUYmqR/X
 GOa0WzWUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlYtDD8FSnwOv8uqWPe8S+3
 k2wj+dmmn2Dma1u98+IJB/+w/TXnkxn+GcvvdDoqdXSTtEcG++foH9Ps7i7NuesU9U2U5+3JZcr
 tnAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: D43DD140003
X-Stat-Signature: 3fgewjf8mkq9j5mdt9bon41c1awkerhe
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795523192-962526
X-HE-Meta: U2FsdGVkX18eEv1RhOufB7q0EBttihodPcbzn5X1Bz8wO7Ss6Wh8wPzZ/s1tIO+bpEZo4YnYYbSETCfswBzWDMvya87iooXgpruSj5oA2aIxByktFNVrkJIObNVzbOBbyvfJtDEMUNBkUh6QuH0OmEuTJZjFfZP5N9mKXrrYz8e+t+PfJiOBBwbz3ecI/RnwyFv2E6SW6WJLeDcUis3GzFpcxTcPGoMjvA53qTC3nMrrcDi58A8yGMbxQngNtnFCQGjd2jVSjClxvOTmXRQSFImcL11PNpr7FjjppniRHzQoybaNcQ37Fsli6OhK2PIcjXs/lWeIgKZ+D3TZankgfRAhyfnCytvcHTLp9USh8T/ePulDe9IFtFszCffaZkqt+5lVXkhAAV3TfJ4yeLGF98iDDfSySpm3wG754YfR+DutYxHkCQ7ProhwasMBDbVeAZ5cSAq77mh3IdImPLe+g44RgepyCF5wNuCjbagoIXX3GXD0mp75p7xCRCYHOgZsH+RZMwd+Nt0OOuQ1dEeZ6rmlGHSYn4OrlH7RWXWOGvto/VBS+iF4ogjQ5KpSIOTfTjOCv5V0l0kHk+0Gn3/av/KDhe5JwzGwmxY1eLsSAztv1S6snEAbZ8CMp0ofN+JjaOkksH+EVZePDrKWj1rKggu+oJHwJD7gXszjURnFuhWsE9fGu99F+0ceoE5xTuBpk9UxGD9LMkqnpehX+61Yztj4cFk4dyQ0M2+9WwSkzWaXlB+uL8+asDS3L3XAlLhU39MkrV1KugBCw5ok3evLYf+idE11FVjHujf6P4f152iPzLaCIRHvBBLSyudpWcRzz78xZ6MttXH/WhGeyDuEJrtlMr2zNNZjLkhyCAPXX1Gl1eD5x03/djvo5S5Z8UUbsZmnI6MBwdmGtiEK3I49p+klXXNyOqKo/My0gESNPDxJjBJiwWebEy77Ux2rcfuwZgH508eP7jXAlfS00Mo
 U2KSYfQU
 SaIXnoot4n0iMeAzfPuoEBYubV36A1d0QXR5GCZng4sJyaNXeQiJfAoLVndVCF+D/bcG9N3BNCZCcTgNEUviDWpHqrQj3V9izxh6yS/6aonBnN2hgYgoDCEvMTPJ1H4cPk+Yt040/nx/P9dhHg6HOargHgIKrb6SAiTB09ZCDBNrxsgmOzJy37pDKf0bd0FJXsLzwRmXw5P8cHofVa2/L2izPzG5TGemnwfqq/D5DSnb2ZUjKKkc/PZvPjeunDw5WjQx8lfXK4c6BTeM0GuLxD/anqiF7wLZ+WqKzgSSPIDD7mYxjB4PTy1IpmTFUL801wNiWYNkhKS7Jvj/lGNHhPah1jvcJWxY7v9gex0xfvZhJ0H5VNDEv/64J2zvIktpk5fJLRWZVa+XeFSuTZoiilhgliRqbVIp+eEnnbNavX6PfpuyYvEQuN1t8ixQewnI2hGHYgTWzVuxTqytPzLqWR9cPGH0zLuVCn8RIKVKcv30mU9vtuVNdiHIia9B0EjJap4mvnI4S9tNWWYRDVoST/0ClUpAytYXydsqJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
per-VMA locks") open-codes a lock_next_vma() implementation that does
roughly the same thing in bpf_iter_task_vma_find_next(), only without
fallback to an mmap_lock.

This is because bpf_iter_task_vma_find_next() can be called from
non-sleepable contexts.

However, lock_vma_under_rcu() gave no guarantee as to which contexts it is
safe to be called from, and indeed it turns out this assumption is unsafe.

Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
vma->vm_refcnt got dropped"), this call chain is possible on x86:

lock_vma_under_rcu()
  -> vma_start_read()
    -> mmdrop()
      -> __mmdrop()
        -> mm_free_pgd()
          -> pgd_free()
            -> pgd_dtor()
              -> spin_lock(&pgd_lock)

Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
called. Since bpf_iter_task_vma_find_next() can be called in softirq
context, this can deadlock, for example:

pgd_alloc()
  -> spin_lock(&pgd_lock)
    <softirq>
    bpf_iter_task_vma_next()
      -> lock_vma_under_rcu()
        ...
	  -> spin_lock(&pgd_lock) [ DEADLOCK ]

Alexei Starovoitov also pointed out that a BPF program attached to
trace_contention_end() can similarly cause a deadlock:

  pgd_alloc()
    spin_lock(&pgd_lock)
      queued_spin_lock_slowpath()
        trace_contention_end()          <- pgd_lock is held
          tp_btf/contention_end prog
            bpf_iter_task_vma_next()
              lock_vma_under_rcu()
                vma_start_read()
                  mmdrop(other_mm)      <- last put takes pgd_lock again

Resolve the issue by having vma_start_read() use mmdrop_async() instead of
mmdrop() so the work is deferred to a work queue.

Make mmdrop_async() an internal mm function, defined in mm/internal.h, to
avoid abuse elsewhere (kernel/fork.c includes this header, so still retains
access).

Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
failure") accounted for the fact that the RCU lock had to be dropped for
this operation, which is no longer applicable.

For the sake of a backported fix, retain this behaviour, however drop the
RCU lock last and remove the now irrelevant comment.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/fork.c  | 16 ----------------
 mm/internal.h  |  3 +++
 mm/mmap_lock.c | 21 ++++++++++++++++++---
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..4d5866c83481 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -744,22 +744,6 @@ void __mmdrop(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
 
-static void mmdrop_async_fn(struct work_struct *work)
-{
-	struct mm_struct *mm;
-
-	mm = container_of(work, struct mm_struct, async_put_work);
-	__mmdrop(mm);
-}
-
-static void mmdrop_async(struct mm_struct *mm)
-{
-	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
-		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
-		schedule_work(&mm->async_put_work);
-	}
-}
-
 static inline void free_signal_struct(struct signal_struct *sig)
 {
 	taskstats_tgid_free(sig);
diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..cc95019c7e4b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1671,4 +1671,7 @@ static inline bool can_spin_trylock(void)
 /* char-mem.c */
 bool file_is_dev_zero(const struct file *file);
 
+/* mmap_lock.c */
+void mmdrop_async(struct mm_struct *mm);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 073c5125b424..28b387fe543a 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -306,11 +306,10 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 */
 	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
 
-	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
-	rcu_read_unlock();
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
-	mmdrop(other_mm);
+	mmdrop_async(other_mm);
+	rcu_read_unlock();
 
 	return NULL;
 }
@@ -560,6 +559,22 @@ void __mm_reset_vma_seqcounts(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(__mm_reset_vma_seqcounts);
 
+static void mmdrop_async_fn(struct work_struct *work)
+{
+	struct mm_struct *mm;
+
+	mm = container_of(work, struct mm_struct, async_put_work);
+	__mmdrop(mm);
+}
+
+void mmdrop_async(struct mm_struct *mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
+		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
+		schedule_work(&mm->async_put_work);
+	}
+}
+
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
 

---
base-commit: 913390e679e23e3a45643028ee7f992889094051
change-id: 20261124-vma-read-lock-mmdrop-async-ba417cd1c1f0

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


