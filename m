Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F070EFB44C2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB3A6B008A; Fri, 24 Apr 2026 03:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2EE6B008C; Fri, 24 Apr 2026 03:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4539F6B0092; Fri, 24 Apr 2026 03:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3261A6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:03:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C90091A0ADC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:03:00 +0000 (UTC)
X-FDA: 84692557320.06.51299DC
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F4E61C0013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:02:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wl1J/XHJ";
	spf=pass (imf20.hostedemail.com: domain of 3oRXraQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oRXraQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777014179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKagbOC73AJ/9NwYWLL6SuYKvFB16xXT/WyLTw4llzo=;
	b=e1J3xfNOBvdw/vsW7T2RC221E9ej2wh1ge/3iRbA5j9CkvwLcEvkMQzjL52tDwKLsdJUvw
	BBSSziVi/4vh/9TE0Oh0PinTk5Ae5Q1nJZDfwNpdqIQ2DSOMGa3vQSKfbbj5GM9W4Sr9+P
	/Gpmp1sEdKrpOuW9tAdewRt76HSUBkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777014179; a=rsa-sha256;
	cv=none;
	b=SRiREEtHgwBv2TkQ/SDZwsmhMhIvW1MNBgqSCKmWuKhSxf07R88jum5G3NigEGZ/SJ2Pno
	ZuzZEkmIOowNSKNvNphoAw6GWhjbZfFw3h/P6u4QTsd5KrAMXptHdD/5uJAJHNj9iSncd2
	GJmleXxIDJVuuzN/g+RhAg7wCBIcukA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wl1J/XHJ";
	spf=pass (imf20.hostedemail.com: domain of 3oRXraQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oRXraQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bdf75bc88fso9643127eec.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777014178; x=1777618978; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PKagbOC73AJ/9NwYWLL6SuYKvFB16xXT/WyLTw4llzo=;
        b=wl1J/XHJ3M+/rR0/t0UTSjokY9yZZ9HQJjBbgIW7yj4LvwbAOVGZeqJ/Ku+h0f6EVQ
         8LvsDCmLQB4fLoy3Sj6TykpocCXkHqDfVrbMc11Cj6TkH/gaz3w0Va0sQ5eUEGyqioJe
         6EIll0lln6ZoiYTloBmSkdNuf1Ud+QyjPZUML4rf09Cd8XqeKqkZCMSoedkdS6rr4am9
         XDMVwYI6IbUnI/91mWOGLW87kA1idFH4NfMt676+TTfgMe9WDdsPPA17XO4qle6gYSFK
         BCFZi8vtA6ReEJ/oadnnbxR04AAzq3xxVQF4gN0Ufly0JamkjSIYe0GPbrcPKcWAIT79
         zpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777014178; x=1777618978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PKagbOC73AJ/9NwYWLL6SuYKvFB16xXT/WyLTw4llzo=;
        b=MbBNwvM7rkGH1X/dg4nPm29xxpZ6CA/zDQMdbXmEkIHAi8Wz4iWmpBO2zeX3qcb8IN
         GUx8MMSaspN8JZ8bvMUXOe8GKJ8wci5zGvRDyzSdWrl+wPvRRHV0v5Xp4QJZmqgsPDQN
         NmmBdroblpa5rgOntf3PbccRi47eNIosB1J8uRCJUpHwLm6AQq4/YsIBqiFRz1i2Mt8J
         6xqatXjImY0UYiLaOF8A09jaICzeTbr2mHALhFPvDKmsgChjNl3a7Li2Jxva73m5fBj0
         96BWcquWzypyqgRxE917ivC5ky2nldQciml095ZXBm9T3vYoOta01DBJmrHKU8tL5CZc
         73sw==
X-Forwarded-Encrypted: i=1; AFNElJ/l7eBI+nOq1M442GAZxpPq8nus4mn7oDtVlyKHWCY5EK0plEYrcINb6pwgshMUPbQKI5Ny6H+OMQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9XjJwocBhmZ03HvR16Yg/DynRYwKhFN1c16CZRcDibVWuCIUW
	xQZvxPQh1IhuLKf4sExSvO3A3DjfMgfoEFCaHJqMWmxZfql/IEwXPluwqiTiY6gMCyCq9/iXzPN
	vh1eGCg==
X-Received: from dlah23.prod.google.com ([2002:a05:701b:2617:b0:12b:f569:153f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1282:b0:127:366f:8bb7
 with SMTP id a92af1059eb24-12c73f976a5mr12956509c88.25.1777014177368; Fri, 24
 Apr 2026 00:02:57 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:02:32 -0700
In-Reply-To: <20260424070234.190145-1-surenb@google.com>
Mime-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260424070234.190145-2-surenb@google.com>
Subject: [PATCH 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: osx9j3py6my66serr6kujrx8icncgitc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F4E61C0013
X-Rspam-User: 
X-HE-Tag: 1777014178-478120
X-HE-Meta: U2FsdGVkX1/FWW66Pw6/CGM1pwyPhlYqWtiAhlZmddOhTf2YlItQtcScKlgzaTkH7ygseVNCVNy1LM6WBWM+lF+LGfR2w7VBSANuHtDuV+2yw6hLokOnzegEFk1IiADR5+wANeA6OrTVylvo2wE5gUlnsv3Vpc/kS8+IoR945LBiZR9o1cJglH+c66mbqZdPgjGRe9Mwvyq7yusVvwLKXZqzlyMKV4OxRTAb43aFGwv+77UwGq2Zki0lEBbVKsx15pexkBYOGwcu7axg0exUBI5bRfJ9mnNTZmsumykmktMuDrX1uJhSRVMpqGy0OWdBOeMQ86bANoFADLyCS4nJ0Kjiq2+DqgbnsDZ76hqqM2R3U6LE4Uoz37apsRIrBTX+d9BtCYdT7btaHdqnEx22RzhYWl+N7qVeGDgz7hcSqUrlrg0pjiW4AuD/QNhg7ytU72I31OOlqFTqWYD0zVdYTMmcY8bgPS+TFKGQ1IuO0SUe0/VIy1oEBqYS1J5+Zv8BOEpPFYPRIjcm4v5j9gU1+JMGq6q+Q6biS31lksRNh5OHwozDT7F4gII/5feVU8668I3TurbsqoNeLFdTHfj5ae6As7h1cGs6o9pXEb5R0Pl+yEUiD5anB73h1miSQj1mzjj3G0AnoLOHbjWDY4jcTjbEeittnAtzhnb055z2jsJHgrbxDf+UDiCW3g/wvuhaSPNpsZ8Cp5V2TmCkT5d+i1JiCa9aDz7/Q3vlHuEDP3z0Lv+FdZAdfxyEzMlf/7YAxuYANfNxFyTiDJCzZYlSQ79DIGRtHErzKlTxwO4jXw6ooNx8U+wpFwzBr5wRmR3Fx05UpvtMhZRcqyO8ZfyXJmfKWVUGW1bhEh3W8M2vebXn20+XcBy4mDKk5aAMHDFXHYmXsZIj555O70UaglUUXhOqABYzASVddr9sForr5pCkhvRIm4lxm3h/fuJabcRMrwYvVQrYiL2AC/d6byU
 VoD1AcMW
 HeEnlTh6WYb8wbvrWtqczl0pi/xECQcwhIc4ypsL+vOglkv0/+E64a+bAZJXcupwl2cd0Z2+m96wQRs9KjQxXyopts8bw2b47xPUTDMIsFFKrrHhyUUT6UWCbSc2Kc3ab0ApvHdeC06t4qYfa0bkJJxLl29mwpO1/v21cNsxpy4N9LK+V9fOW0OuWN04JuELjyCOyEwIzDH8v87XZPiuDO55/Nlw8uj06tQ1SXDDrRdgYxY7WyfDMuJlwyejXxY/AIfrR+pqD3PWHfstALQGAoA3f6pOjzJmveQkk6aybFnWDdoqDkWAHUjOsBsgZe3RG/GvXKqKU5ehdIS1NLiK7ZO/y0esQCg/sc3zGg0f0f28vsHaYz5NXW+XH0bnZBrJUZJAj+FqbhjcB6KzpCWYQ5mp0NXCiaIu4x2+/LisJHEkMvikGTymTax3sYE/Yi/tb8nhHQ1p+kKroSTWJXr44V9W8jQ3+wiVTii1yb8lySOi+sgTzMjx4bOeImGmSiEUGLXopS5fmrK8a9jcewXmkaIbjFkD4tDETd88zB5rmodc0MyLs0JoixcPHAEkwA5Iy5lo1DTyvXgFP99IQFlpX+OmVQalIFbuQQySdnrYVSmENuvcy9Rgas3PAWHD2K2S6B6O6XoVLrKqe+9VJN96Efu7QLmVK2sBujcyNLoOkVCpM1Qqzg6I5oMljWjW/sPuPsMIBA1zCpoVMkh2jvbWocbFd7WY/mZI7W7Uh9viuWRJxSP2hramGwrSzbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc/pid/{smaps|numa_maps} can be read using the combination of RCU and
VMA read locks, similar to proc/pid/maps. RCU is required to safely
traverse the VMA tree and VMA lock stabilizes the VMA being processed
and the pagetable walk.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 193 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 154 insertions(+), 39 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751b9ba160fb..96cfea252db6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+{
+	int ret = mmap_read_lock_killable(lock_ctx->mm);
+
+	if (!ret)
+		lock_ctx->mmap_locked = true;
+
+	return ret;
+}
+
+static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+{
+	mmap_read_unlock(lock_ctx->mm);
+	lock_ctx->mmap_locked = false;
+}
+
 static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
 {
 	lock_ctx->locked_vma = NULL;
@@ -146,25 +162,11 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 	}
 }
 
-static const struct seq_operations proc_pid_maps_op;
-
 static inline bool lock_vma_range(struct seq_file *m,
 				  struct proc_maps_locking_ctx *lock_ctx)
 {
-	/*
-	 * smaps and numa_maps perform page table walk, therefore require
-	 * mmap_lock but maps can be read with locking just the vma and
-	 * walking the vma tree under rcu read protection.
-	 */
-	if (m->op != &proc_pid_maps_op) {
-		if (mmap_read_lock_killable(lock_ctx->mm))
-			return false;
-
-		lock_ctx->mmap_locked = true;
-	} else {
-		rcu_read_lock();
-		reset_lock_ctx(lock_ctx);
-	}
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 
 	return true;
 }
@@ -172,7 +174,7 @@ static inline bool lock_vma_range(struct seq_file *m,
 static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
 {
 	if (lock_ctx->mmap_locked) {
-		mmap_read_unlock(lock_ctx->mm);
+		unlock_ctx_mm(lock_ctx);
 	} else {
 		unlock_ctx_vma(lock_ctx);
 		rcu_read_unlock();
@@ -213,17 +215,45 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return true;
 }
 
+static inline void drop_rcu(struct proc_maps_private *priv)
+{
+	if (priv->lock_ctx.mmap_locked)
+		return;
+
+	rcu_read_unlock();
+}
+
+static inline void reacquire_rcu(struct proc_maps_private *priv)
+{
+	if (priv->lock_ctx.mmap_locked)
+		return;
+
+	rcu_read_lock();
+	/* Reinitialize the iterator. */
+	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
+}
+
 #else /* CONFIG_PER_VMA_LOCK */
 
+static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+{
+	return mmap_read_lock_killable(lock_ctx->mm);
+}
+
+static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+{
+	mmap_read_unlock(lock_ctx->mm);
+}
+
 static inline bool lock_vma_range(struct seq_file *m,
 				  struct proc_maps_locking_ctx *lock_ctx)
 {
-	return mmap_read_lock_killable(lock_ctx->mm) == 0;
+	return lock_ctx_mm(lock_ctx) == 0;
 }
 
 static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
 {
-	mmap_read_unlock(lock_ctx->mm);
+	unlock_ctx_mm(lock_ctx);
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -238,6 +268,9 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return false;
 }
 
+static inline void drop_rcu(struct proc_maps_private *priv) {}
+static inline void reacquire_rcu(struct proc_maps_private *priv) {}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
@@ -538,12 +571,10 @@ static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 
 static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
 {
-	if (lock_ctx->mmap_locked) {
-		mmap_read_unlock(lock_ctx->mm);
-		lock_ctx->mmap_locked = false;
-	} else {
+	if (lock_ctx->mmap_locked)
+		unlock_ctx_mm(lock_ctx);
+	else
 		unlock_ctx_vma(lock_ctx);
-	}
 }
 
 static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
@@ -1280,16 +1311,64 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
 	.walk_lock		= PGWALK_RDLOCK,
 };
 
+#ifdef CONFIG_PER_VMA_LOCK
+
+static const struct mm_walk_ops smaps_walk_vma_lock_ops = {
+	.pmd_entry		= smaps_pte_range,
+	.hugetlb_entry		= smaps_hugetlb_range,
+	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
+};
+
+static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
+	.pmd_entry		= smaps_pte_range,
+	.hugetlb_entry		= smaps_hugetlb_range,
+	.pte_hole		= smaps_pte_hole,
+	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
+};
+
+static inline const struct mm_walk_ops *
+get_smaps_walk_ops(struct proc_maps_private *priv)
+{
+	if (priv->lock_ctx.mmap_locked)
+		return &smaps_walk_ops;
+	return &smaps_walk_vma_lock_ops;
+}
+
+static inline const struct mm_walk_ops *
+get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
+{
+	if (priv->lock_ctx.mmap_locked)
+		return  &smaps_shmem_walk_ops;
+	return &smaps_shmem_walk_vma_lock_ops;
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static inline const struct mm_walk_ops *
+get_smaps_walk_ops(struct proc_maps_private *priv)
+{
+	return &smaps_walk_ops;
+}
+
+static inline const struct mm_walk_ops *
+get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
+{
+	return &smaps_shmem_walk_ops;
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
 /*
  * Gather mem stats from @vma with the indicated beginning
  * address @start, and keep them in @mss.
  *
  * Use vm_start of @vma as the beginning address if @start is 0.
  */
-static void smap_gather_stats(struct vm_area_struct *vma,
-		struct mem_size_stats *mss, unsigned long start)
+static void smap_gather_stats(struct proc_maps_private *priv,
+			      struct vm_area_struct *vma,
+			      struct mem_size_stats *mss, unsigned long start)
 {
-	const struct mm_walk_ops *ops = &smaps_walk_ops;
+	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
 
 	/* Invalid start */
 	if (start >= vma->vm_end)
@@ -1312,15 +1391,24 @@ static void smap_gather_stats(struct vm_area_struct *vma,
 					!(vma->vm_flags & VM_WRITE))) {
 			mss->swap += shmem_swapped;
 		} else {
-			ops = &smaps_shmem_walk_ops;
+			ops = get_smaps_shmem_walk_ops(priv);
 		}
 	}
 
-	/* mmap_lock is held in m_start */
+	/* Skip walking pages if gate VMA */
+	if (vma == get_gate_vma(priv->lock_ctx.mm))
+		return;
+
+	/*
+	 * Need to drop RCU read lock before the walk due to possibility of sleep.
+	 * Note that the VMA is still locked.
+	 */
+	drop_rcu(priv);
 	if (!start)
 		walk_page_vma(vma, ops, mss);
 	else
 		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	reacquire_rcu(priv);
 }
 
 #define SEQ_PUT_DEC(str, val) \
@@ -1369,10 +1457,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
 
 static int show_smap(struct seq_file *m, void *v)
 {
+	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss, 0);
 
 	show_map_vma(m, vma);
 
@@ -1413,7 +1502,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		goto out_put_task;
 	}
 
-	ret = mmap_read_lock_killable(mm);
+	ret = lock_ctx_mm(&priv->lock_ctx);
 	if (ret)
 		goto out_put_mm;
 
@@ -1425,7 +1514,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss, 0);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1434,8 +1523,8 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		 */
 		if (mmap_lock_is_contended(mm)) {
 			vma_iter_invalidate(&vmi);
-			mmap_read_unlock(mm);
-			ret = mmap_read_lock_killable(mm);
+			unlock_ctx_mm(&priv->lock_ctx);
+			ret = lock_ctx_mm(&priv->lock_ctx);
 			if (ret) {
 				release_task_mempolicy(priv);
 				goto out_put_mm;
@@ -1484,14 +1573,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(vma, &mss, 0);
+				smap_gather_stats(priv, vma, &mss, 0);
 				last_vma_end = vma->vm_end;
 				continue;
 			}
 
 			/* Case 4 above */
 			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats(vma, &mss, last_vma_end);
+				smap_gather_stats(priv, vma, &mss, last_vma_end);
 				last_vma_end = vma->vm_end;
 			}
 		}
@@ -1505,7 +1594,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 	__show_smap(m, &mss, true);
 
 	release_task_mempolicy(priv);
-	mmap_read_unlock(mm);
+	unlock_ctx_mm(&priv->lock_ctx);
 
 out_put_mm:
 	mmput(mm);
@@ -3291,6 +3380,31 @@ static const struct mm_walk_ops show_numa_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
+#ifdef CONFIG_PER_VMA_LOCK
+static const struct mm_walk_ops show_numa_vma_lock_ops = {
+	.hugetlb_entry = gather_hugetlb_stats,
+	.pmd_entry = gather_pte_stats,
+	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
+};
+
+static inline const struct mm_walk_ops *
+get_show_numa_ops(struct proc_maps_private *priv)
+{
+	if (priv->lock_ctx.mmap_locked)
+		return &show_numa_ops;
+	return &show_numa_vma_lock_ops;
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static inline const struct mm_walk_ops *
+get_show_numa_ops(struct proc_maps_private *priv)
+{
+	return &show_numa_ops;
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
@@ -3335,8 +3449,9 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	/* mmap_lock is held by m_start */
-	walk_page_vma(vma, &show_numa_ops, md);
+	drop_rcu(proc_priv);
+	walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
+	reacquire_rcu(proc_priv);
 
 	if (!md->pages)
 		goto out;
-- 
2.54.0.545.g6539524ca2-goog


