Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96824606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3dPwe1/
Received: by kanga.kvack.org (Postfix)
	id 830346B0843; Tue, 24 Nov 2026 13:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807746B0845; Tue, 24 Nov 2026 13:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744B96B0846; Tue, 24 Nov 2026 13:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54CAD6B0843
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:57:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE750A7F35
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:57:05 +0000 (UTC)
X-FDA: 85470920010.18.15BA434
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12334C0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:57:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D3dPwe1/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546624;
	b=gnedwjUvnG7vUH8ShrY7frb3dS121tKj3aD0BcE12ZPQudIRuEQr2VcHY8Xnn/7CbubjWm
	pedkJJo9TVkMVMBXdBE13nhRguEjysRELaIo/sbDA3Sr3o8nYTG/SNal8igxyKhrUSZxBX
	bDKVldk8dxb8nLtAJcltGRXWG3UFqMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K75Fomuhl/TeDSAhojtFFsF9TENIiJs0NQdhbNDZn+8=;
	b=h8miCT5JOORgcvyMBabhpVoLTMtYMUXzenbVxP4wer36UsmihH8mPLNBBAUVwuRz3uT2Vf
	X/lU0wUo9RRyLSS1jBwo3D+LaZuWPXXun9mm7OL0P425i+ttoCteAcYcG+6w9hVxIuV6Uy
	RncCfYQvGe0ZFCasUWTFZ/uZVDxrqgA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D3dPwe1/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30C3C41948;
	Tue, 24 Nov 2026 18:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6135A1F000D0;
	Tue, 24 Nov 2026 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795546622;
	bh=K75Fomuhl/TeDSAhojtFFsF9TENIiJs0NQdhbNDZn+8=;
	h=From:Date:Subject:To:Cc;
	b=D3dPwe1/1qD1ZZgtB2coXTHOK1EaWGzIMeeU4TukjN+rtf5chKTy+Br7BuJctDfT0
	 dLN89Kpf9dQINhB28PCvc3lQGwlyGRmczLhATl3VsJJZ3iOY+zjQw6K7rBE0BfEt1z
	 6lm7b0KKUpb7LZU2EWw6/e8NGK9eeV49VpzAEJQlkbwsI+gKa/6FsDVYHiXUW3ioGV
	 mYeTqpbEYFNeAiDKNnjwLMvuuaycvPu8y9HD0sEJDAkIMsw5sQDP1Q6BndT0MCnzOG
	 qBVhPcG1CW9fZlfUJUzoiMEM8cFz/ibu8WSjYSwDNERaJFTeE0BfIkVH7fcUELy/MV
	 rrANpkd8sVdPA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 18:56:46 +0000
Subject: [PATCH v2] mm/vma: drop mm asynchronously in vma_start_read()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-vma-read-lock-mmdrop-async-v2-1-8139b5cf24bb@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/43NTQqDMBBA4auEWTvFCVrRVe9RXKTJRIM/kUkJF
 fHupZ6g27f43gGJJXCCTh0gnEMKcYVO6UKBHc06MAYHnQJd6juRrjAvBoWNwznaCZfFSdzQpH2
 1+DIVNdaRJV9CoWAT9uFz4c++UDCG9I6yX69Mv/oXmwkJdd34tvV1TY4fE8vK8y3KAP15nl9ea
 lnIxQAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5425; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+GlkRGCdNbNl6lPRsAZ0GstxY0HQDDSVM2C8Wjvm9gk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZ735h09sQtFmBeXrXw5mxXfOCP9XkSc/Y/p157addx
 rcdv0u96ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEhBYyMixZuUTd+eS+hMP3
 MzaI8sfytiYvrJHZLFhgfmyNeOSdxMcM/1SkTs3heCliXSxXf8zjqcvU6wsXyalc/jT/7WX2aeu
 kVnMCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12334C0007
X-Stat-Signature: 9ag7q7hxorpsdhbb4c4phb1fseapxe79
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795546623-305844
X-HE-Meta: U2FsdGVkX1+9cz5iQSsihDqiflrMFBVn3/aVqq7d5ldZyIwzAbkeym6qd2yhpLfc2hNqcJpLLHhmfTWxPNQ4HhUQ7ESMBxna2x4aj4CVPY/pi8blfbeyTzDlTYx8E4Mkn+kc86sm8Xf40S2RsqXAHNkdCTUqC1RqKeSjkKTLP7bY1anFCpIVKqZPxXoJ8K5NWd6reKTJb8CcFOXKgMWKVDd7s8HVXHXQsFHF00JyZxl5FD3wj1uUeFc0aVC+TKyS2ZLyR6vsOAq8v6D/z7axyZlUsIVtshOhmCW4VVRtlpUQY1tPWnJ16hzcruHLK+SKUELOgZPnou3JthCG0WHZJQPtG24HCtsPia1F8OhLb44XJ7VdgZcPqbrL1nWfAt5wonHHji1PylCnB+vde3H9vw/gjseCSz2etv38ynIStKYL3DiV98zE7/Xr98iuJN+trAViPos3DQfKWT/FHXPvcfh8eVBilWL+d2L06gn2TgSoFafFxxizkpqVZwbJ7WRbkWFnhQm/LSDLhLRs4zi/pOIbmQtztYBxVIqE0MsjVBOTxUil3qbwO1LcTpRqHUFgEScH6gwenqNASGpML9IxS/SfSOGlKzJVsJiSuJGpDjjDyP2Nwc01aHLmA7C57E9At+OifgdylCHM97IVL8YekJ8rKuUidtRitF51exN8KNADOaIjzAqTYYp5j/SQl/2ndZ0eS6eWuHecE2qAFnU/YFX2PjPHG7IgTD2N9bmLUi+Ghnx2qX/LNI9lGDBD3QMwzENZmK+htVli9iHqo3GG/w1XAzmnRZf4atExdo3xHITNnjispXFGeV41Jj/DZmo0m2aUtKRq+TludJ0tdJrG9GR988GmQKx9ayTKcwStAi9coRdqmRhMxbL11j4tkpNjCSkPrCK5Wxn7hybfRlUeBO0zfrbMymiG1/xhotTiuy2Zu4hn5Za1yka+M++kD2XnGhpmuVp+sBxk08cWQNK
 cMmR3THN
 S67SYWBRrT7vgEcCSz9zE81okRAkBiYjkj0wstLuBKwMYi0w1vLB4Cf/9fxkCaujQAS7fjacNB8gnAWrGCFevLPSYyoodX1HIkeBusgeEGkl2Bsm1pstw8U7KdnXKU8+O/I7kPPavm9bIWxdKz/W2casjNdzAVI/pRWwqqXAm8X4CW9OTq4zUVHFlQBEdmKFlsfr0kweRSjYLKHaIzG+U38YR6KzexLELJv03YtzbQ1XSZkBr2obYbssQxosaXfk/x5O2jAijisQH6HmGvEu94zg7E79I2glDqTP3Pf0A+1fdRyvcLrKupUWJ36Jz0x3+OejILDLaeY1ceXe+KwbRBolqhanbo4YWOgKDkq3eCuy2EG5Vhn1yLZyCdve2fvmS6vMYrGeWYjxVb0qVYZAUmev676rxNagKcoHImK5hhGLTYIiK2B+appXSeKXouN24dXzbo5PsfdvkkqIrxDGQUFZsqdOdoi2I0N4v47TG3btsp2M3L/kgZrrNxAZk+ORCxswNs4LNzvXMDOiJSNPuy4qFnQtzsIJjZmrpKJHhQCfVLLdcv1eoz34ue2XjcL1lOaaP
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

Remove the now-defunct comment on the 'heavy operation', but leave
examining that to a follow up.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Put the rcu_read_unlock() back where it was, a follow-up can address
  anything else here.

v1:
https://lore.kernel.org/r/20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org
---
 kernel/fork.c  | 16 ----------------
 mm/internal.h  |  3 +++
 mm/mmap_lock.c | 19 +++++++++++++++++--
 3 files changed, 20 insertions(+), 18 deletions(-)

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
index 073c5125b424..d28bbc3ba734 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -306,11 +306,10 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 */
 	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
 
-	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
 	rcu_read_unlock();
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
-	mmdrop(other_mm);
+	mmdrop_async(other_mm);
 
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


