Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0E4C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7596B00A6; Mon,  7 Sep 2026 02:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF036B00A7; Mon,  7 Sep 2026 02:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDF16B00A9; Mon,  7 Sep 2026 02:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 002536B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DAB61606C9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:33 +0000 (UTC)
X-FDA: 85186015026.10.8C42B69
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1E0514000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtSTq4qt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3IlyeagYKCK8hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3IlyeagYKCK8hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRgAJEesmnVK4x+kJuwts5FXMtr9BAdCkMEInHLpvrU=;
	b=MCEP6kwjE7Dekyq4dZob0gXutyO6Vo5I2lnygvKUb8wgJfdJFzuMTLTPS6CtEJLikELIzv
	QhS+pC9ev+43rR0hKg4jb4XCp5t9941aOgvfEFOZI4M6ctQwZTNn+2BbVUI32UKAZcoY1C
	oosV1AP/JqkSFI29VhmFpavCE7Zxmsk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtSTq4qt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3IlyeagYKCK8hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3IlyeagYKCK8hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763171;
	b=IL/Ss4kblLDmQS4iDWrg6KbjAO9oZseA/Zqtna7ehdrmaYiQ+EgHQjB2S8lfEykw/rylBn
	jqQiXwbDVykCQxvbheS2+Fi4ahf18onUsQO18nX2b+uzQ/D2GQ2vfW9+QlEveGy/wgBT0F
	18R2/wX0UQf/lC/YbGOOUQeWAtAI/3c=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39906175917so3558819a91.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763171; x=1789367971; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hRgAJEesmnVK4x+kJuwts5FXMtr9BAdCkMEInHLpvrU=;
        b=OtSTq4qt4TVLbEWd7KzvCg/R78NZXtX6FhOaJsThq3eAlZPaFxFZkLT9i68HR4ztRz
         vsgoh+hyUCA/Y03GakUz0l8a21DYXJd8ODPOFMuCOxTEGz8yG1i4M1yRJN0yEnc9u/0O
         nJJTT/1bQVgDd1CvRC8z2tbhKND2SAGzkVR/3XL4vqHSRospJmM0DfYJScQ7TY2Npz+L
         A8gB7JfNJQ7ekuccpvh4wzzTxE3vucjmAC82Xg9mtCbYP/FlqGfCL/DwHkfS6pwqVEym
         1DMYK3KJwffS0JFvTjfPJGerMm+pfCwVQLODb5aP4/CL1H6J3LxsTS7a+wtpXdx6/ciP
         /LXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763171; x=1789367971;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hRgAJEesmnVK4x+kJuwts5FXMtr9BAdCkMEInHLpvrU=;
        b=rxJkv4U/pjXRiKWOb0Rc4F60Q4vyivdwOVKCXmzfhh3vcfCvpft8PpLLq9hgz2bS5j
         x/3zD8rSXzebrcZsn/g0FUsvxKcD/nEQUnngO5JkFNXHjZOIR5y70awftr80Q8Ymkr+B
         Wxi1ID7rYTM3KkzLREaPBj8tAgzEtvNUJN0CtvNsfkuuXghuQYdSbb9lVpiJJADZ3CYk
         4ZR9yG62zl/zntI2RTMEqnMns3m3cx6wa/IB0CbPnufr/agNhbuS7Tyte4KhI4MXFgfd
         xpzOY0xO9dPeAWfCopJgugx8Y8fMqJ1oGIUaq3D1Jhu1XKlmJyHUfqnyVXpObSGKoFH/
         /D3g==
X-Forwarded-Encrypted: i=1; AKwUvBzGTSJY4m1aLOXaThfW0tPwPlF+rnA33BHwD51DK/y7FsygNUvEOYnvjFVCY71FGNh/pOxKmnJgeg==@kvack.org
X-Gm-Message-State: AFuF++lvNOWltyIdczVD1qhOuW1x8qdMeFE5cpNyfjMt8tktwAuBi0Lm
	qskob5XJQf3nV50CZYmoOpT4Bh+ML2al40WtUb1ppt60yZUZKxHgSJ5TwDf5wstIs7LLIAkMJiD
	iIrOFvA==
X-Received: from dlec19-n2.prod.google.com ([2002:a05:701b:4293:20b0:13d:2ef5:67a6])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c06:b0:396:b98b:a3c2
 with SMTP id 98e67ed59e1d1-39b26116d9fmr27528420a91.8.1788763170216; Sun, 06
 Sep 2026 23:39:30 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:17 -0700
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
Mime-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-5-surenb@google.com>
Subject: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hqip696xghtrdudgzh7k97wijur7j7ou
X-Rspamd-Queue-Id: C1E0514000F
X-HE-Tag: 1788763171-311658
X-HE-Meta: U2FsdGVkX18FdALTirsxjVzCLp7uapIwejZ2k5OiizfL9CRmY6ojH5C55cSoliLlLJsJuj2ZIGtUVtSw1F+q3xRQBzwqRkb/2XINEpO2ceu7HzKoKVN5HQJ/kPwa9PAN1fD2heQ6o/gUHTlmsMAMrRmY486MA5hNhJZGtOx3aTt2pjpI03SBi/PauX03H4A6dlrBuDZEboqyaGM2g2fqiazqs2EtVuyoSwWnZCWe/9c8394rKNZVZxY+j+IyB4v3xJIejN5d1zgCfy5zAoDojhPbnxOROxoD8lQk9p6bquKXt0HYfIwCBHwK9tB9bi88tzKOj+D49lQZA2Vuc8Qese3pFBorDu69PcLtUjkDbsYc+FDyroS8DPGOftykZx/3iPvsSpmKU7ldXnqei55XzfhAYrhaswZXPV89V0tpOhJxqlrnDRQucBzT6lC6ot+r0je7paUUC6ezI2ilhRz3sNZoWfSh8iL/k/RDd51iaBPDhs03oWNJ40nEHs2WAOnOh4IuIMpnu3AeRokgfYArP0TwHV2SEmi0MKDlgyajbh5yylZJjFYUq1/h/M6JO06+yMaywZgbzyFmqtP3SrRaxqexC6ZtbaNgoopRPbOIaQWDH74QU8W3Oqr9c5XPOwdNf2ICvWbElA/iJ1iPG/KPg7GsEYnQV0moJYRh4z1yi5DqDPnLc6ihGgXtIiN/GouBoTraA3KHKIM5Kuz8WTy+NuseTdYHzvoNu1dgOSzL/5IHAxt2z9IKUGJKxeMgAiRQennloGP8G0GzOUEQMXqvV+nshR+GunoKAi+/ZVWX2YB0Dd5OuYFkYAcNf0B5QrCZfMjBysjs4RU5EmWx0+SHBDCfv7K+vnAiYTG0MmatrFmFdq22HjyT/tApQ5EtwKnpFz6bnjoToQS1JhOLjT7Sm/ahtIhyCIn8T/mLzb80pp+GETJV3d0t5iWSzlD2s8yBcODYaa2JjVn859wSctJ
 UwZx4Vyq
 yk6p0ywFiP/k4l7kYqzjbejPJiu+zP+cg7JgHSjU5sC4VGmUVVDTw3myjP8UiB6uHEENzl4mt1eiCFie7hlf/xOdsFhw1rUri15f3hDrlkZ6kz0F2srioCIWIixw5sw7a7rdraaI/CDT0YTv7xBr82cjLPrh0dludSUJ8iZUgGq2Q4Ir20QUDPquHxkwzs9mg51BamcL2mWKy7i8iHnmB10zPmCO+3Lb32Hcp3iSArZacoGwy6VklwZs8YNRrfFyBKOy88KWow2W5/cAZPWJ4mOKl350F1NAo3UyZfBlTsRFyDgm0H9Df0hhpXWvwjeqJ7G1mYohrJ/r4KbliK70ftf8H87ODTYFJoBgABTI+V6lSNHlI6F7mxrE0nMDawqXEvtt1CSf2yDXxkZ5jvTOz2gLGg+kNvEq1SL8rQPsHOlzfZe2eLrXsl+/QaPsTWJ1BUDviklCw06bxOoghRBJ7j5zhM19AqyNNGSPjirBs7w1GMBfTXmeZRDjlHqdv56jtumzdLQ7OFNnNl6AQSDriwqDjKZSdQblckxxtL3FA2Neh96lJRm6kCm+nYeqlIJgpKcNJ9G8reVrLQL6l+3uhEBBUxpx7f6Wdn04ZgjZZHyqnG9WXWufc7d5NrzMJeefBO2pwCgihsoxwsTNc4+UPYhVljQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc/pid/smaps_rollup can be read using the combination of RCU and
VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
required to safely traverse the VMA tree and VMA lock stabilizes the
VMA being processed and the pagetable walk.
Note that we have to keep the logic to drop mmap_lock on contention
because even when using per-VMA locks we might have to fall back to
holding the mmap_lock.

Running Paul's contention benchmark [1] shows considerable improvement
both in median and in the worst case latencies:

Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
--busyduration 2 --procfile smaps_rollup

Baseline:
   Median   Minimum   Maximum
    0.174     0.161     2.553
    0.174     0.164     2.663
    0.174     0.165     2.664
    0.174     0.166     2.679
    0.174     0.167     2.691
    0.174     0.168     2.704
    0.174     0.169     2.729
    0.174     0.172     2.741
    0.174     0.174     2.745
    0.174     0.174     2.755
    0.174     0.175     2.790
    0.174     0.177     2.809
    0.174     0.179     3.096
    0.174     0.183     3.144
    0.174     0.184     3.158
    0.174     0.185     3.175
    0.174     0.185     4.568
    0.174     0.198     4.821
    0.174     0.214     5.143
    0.174     0.251     5.220

Patched:
   Median   Minimum   Maximum
    0.007     0.007     1.952
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.957
    0.007     0.007     1.969
    0.007     0.007     2.065
    0.007     0.007     2.075
    0.007     0.007     2.146
    0.007     0.007     2.195
    0.007     0.007     2.223
    0.007     0.007     2.259
    0.007     0.007     2.488
    0.007     0.007     2.562
    0.007     0.007     2.599
    0.007     0.007     2.697
    0.007     0.007     3.030
    0.007     0.007     3.075
    0.007     0.007     3.145
    0.007     0.007     3.225

Remove now unused lock_ctx_mm() and move unlock_ctx_vma() next to
unlock_ctx_mm() as they are logically related.

Remove a long comment about 4 cases that we handle when dropping the
mmap lock in the middle of VMA walk due to contention. The first 3
cases explained there are handled naturally and only case 4 needs to
be handled in a special way, which is done in smap_gather_stats() by
gathering stats from the portion of the VMA that has not yet been
processed.
For posterity, moving this comment here:

After dropping the lock, there are four cases to
consider. See the following example for explanation.

  +------+------+-----------+
  | VMA1 | VMA2 | VMA3      |
  +------+------+-----------+
  |      |      |           |
 4k     8k     16k         400k

Suppose we drop the lock after reading VMA2 due to
contention, then we get:

	last_vma_end = 16k

1) VMA2 is freed, but VMA3 exists:

   vma_next(vmi) will return VMA3.
   In this case, just continue from VMA3.

2) VMA2 still exists:

   vma_next(vmi) will return VMA3.
   In this case, just continue from VMA3.

3) No more VMAs can be found:

   vma_next(vmi) will return NULL.
   No more things to do, just break.

4) (last_vma_end - 1) is the middle of a vma (VMA'):

   vma_next(vmi) will return VMA' whose range
   contains last_vma_end.
   Iterate VMA' from last_vma_end.

[1] https://github.com/paulmckrcu/proc-mmap_sem-test

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 153 ++++++++++++++++++---------------------------
 1 file changed, 60 insertions(+), 93 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3351decd1172..641a155b0c61 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -130,28 +130,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 }
 #endif
 
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
-{
-	int ret = mmap_read_lock_killable(lock_ctx->mm);
-
-	if (!ret)
-		lock_ctx->mmap_locked = true;
-
-	return ret;
-}
-
 static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
 }
 
-static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
-{
-	lock_ctx->locked_vma = NULL;
-	lock_ctx->mmap_locked = false;
-}
-
 static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
 	if (lock_ctx->locked_vma) {
@@ -160,6 +144,12 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 	}
 }
 
+static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
+{
+	lock_ctx->locked_vma = NULL;
+	lock_ctx->mmap_locked = false;
+}
+
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
@@ -1376,12 +1366,14 @@ static int show_smap(struct seq_file *m, void *v)
 static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
+	struct mm_struct *mm = lock_ctx->mm;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->lock_ctx.mm;
+	unsigned long last_vma_end = 0;
+	unsigned long vma_start = 0;
 	struct vm_area_struct *vma;
-	unsigned long vma_start = 0, last_vma_end = 0;
+	loff_t pos = 0;
 	int ret = 0;
-	VMA_ITERATOR(vmi, mm, 0);
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
@@ -1392,89 +1384,60 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		goto out_put_task;
 	}
 
-	ret = lock_ctx_mm(&priv->lock_ctx);
-	if (ret)
-		goto out_put_mm;
-
 	hold_task_mempolicy(priv);
-	vma = vma_next(&vmi);
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 
+	vma_iter_init(&priv->iter, mm, 0);
+	vma = proc_get_vma(m, &pos);
 	if (unlikely(!vma))
 		goto empty_set;
 
-	vma_start = vma->vm_start;
-	do {
-		smap_gather_stats(priv, vma, &mss, vma->vm_start);
-		last_vma_end = vma->vm_end;
+	if (!IS_ERR(vma) && vma != get_gate_vma(lock_ctx->mm))
+		vma_start = vma->vm_start;
+
+	while (vma) {
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto out_unlock;
+		}
+
+		if (vma == get_gate_vma(lock_ctx->mm))
+			break;
 
 		/*
-		 * Release mmap_lock temporarily if someone wants to
-		 * access it for write request.
+		 * If after retaking the lock, already reported VMA grew or
+		 * merged with the next one, smap_gather_stats() will gather
+		 * stats for the remaining portion by starting at last_vma_end.
 		 */
-		if (mmap_lock_is_contended(mm)) {
-			vma_iter_invalidate(&vmi);
-			unlock_ctx_mm(&priv->lock_ctx);
-			ret = lock_ctx_mm(&priv->lock_ctx);
-			if (ret) {
-				release_task_mempolicy(priv);
-				goto out_put_mm;
-			}
+		smap_gather_stats(priv, vma, &mss, last_vma_end);
+		last_vma_end = vma->vm_end;
 
+		/*
+		 * If the VMA lock is not taken, we hold the often contended
+		 * mmap lock. This can happen if we had to fall back to the
+		 * mmap lock.
+		 *
+		 * To relieve pressure, check if it is indeed contended, then
+		 * temporarily release it.
+		 */
+		if (lock_ctx->mmap_locked &&
+		    mmap_lock_is_contended(lock_ctx->mm)) {
+			unlock_ctx_mm(lock_ctx);
 			/*
-			 * After dropping the lock, there are four cases to
-			 * consider. See the following example for explanation.
-			 *
-			 *   +------+------+-----------+
-			 *   | VMA1 | VMA2 | VMA3      |
-			 *   +------+------+-----------+
-			 *   |      |      |           |
-			 *  4k     8k     16k         400k
-			 *
-			 * Suppose we drop the lock after reading VMA2 due to
-			 * contention, then we get:
-			 *
-			 *	last_vma_end = 16k
-			 *
-			 * 1) VMA2 is freed, but VMA3 exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 2) VMA2 still exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 3) No more VMAs can be found:
-			 *
-			 *    vma_next(vmi) will return NULL.
-			 *    No more things to do, just break.
-			 *
-			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
-			 *
-			 *    vma_next(vmi) will return VMA' whose range
-			 *    contains last_vma_end.
-			 *    Iterate VMA' from last_vma_end.
+			 * Even though we previously fell back to mmap lock,
+			 * we try taking VMA lock for the next VMA, since it
+			 * might not be under modification. In the worst case
+			 * we will fall back to mmap lock again.
 			 */
-			vma = vma_next(&vmi);
-			/* Case 3 above */
-			if (!vma)
-				break;
-
-			/* Case 1 and 2 above */
-			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, vma->vm_start);
-				last_vma_end = vma->vm_end;
-				continue;
-			}
-
-			/* Case 4 above */
-			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, last_vma_end);
-				last_vma_end = vma->vm_end;
-			}
+			rcu_read_lock();
+			reset_lock_ctx(lock_ctx);
+			/* Resume from the last position. */
+			pos = last_vma_end;
+			vma_iter_init(&priv->iter, mm, pos);
 		}
-	} for_each_vma(vmi, vma);
+		vma = proc_get_vma(m, &pos);
+	}
 
 empty_set:
 	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
@@ -1483,10 +1446,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	__show_smap(m, &mss, true);
 
+out_unlock:
+	if (lock_ctx->mmap_locked) {
+		unlock_ctx_mm(lock_ctx);
+	} else {
+		unlock_ctx_vma(lock_ctx);
+		rcu_read_unlock();
+	}
 	release_task_mempolicy(priv);
-	unlock_ctx_mm(&priv->lock_ctx);
-
-out_put_mm:
 	mmput(mm);
 out_put_task:
 	put_task_struct(priv->task);
-- 
2.55.0.979.g7e5102b832-goog


