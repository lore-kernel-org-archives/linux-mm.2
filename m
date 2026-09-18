Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A87ABC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDC36B00A0; Fri, 18 Sep 2026 11:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5CD6B00A1; Fri, 18 Sep 2026 11:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177046B00A2; Fri, 18 Sep 2026 11:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9056B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E057A6211
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:36 +0000 (UTC)
X-FDA: 85227277632.24.3BEB535
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE02140008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=htUzGUVf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3zVmtagYKCJIEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3zVmtagYKCJIEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GezTlyn6XHQWhl94S93tdh+KQwNw767Wgp9o9ICsVJ4=;
	b=VInp5jXg/z/4HKKso2bYJUDG0zK4XC/fW726+6QQ2SlOndPrl6coSRw6xJuLSgcGtNLSOw
	qns+g9RyJsYvdD7TK9INzXTXE1So6GWWLx4AbzvwcbKdvc4f/auZSLa1gosN7NmE/Xb+40
	eaYISB8eiUdqjhyOZhGV7ACfGpQfGzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745614;
	b=qOxe4he39YPjjCISxTdkzEdOdgZnTOS/N3kDDAB3d2R6cU7AWr8y0jzug+AqQyp+hp8q4p
	mcDUWNItJuIvK0LxBO3sEWt/cIBJz6T7oJHkZeea6Ibz1eG0Jp+fyjxivZ3zQJ5OPhe0BK
	6tEgz0df2+NGVhUYdGhtjAT50Uz+hl4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=htUzGUVf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3zVmtagYKCJIEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3zVmtagYKCJIEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39deda201bcso88493a91.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745613; x=1790350413; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GezTlyn6XHQWhl94S93tdh+KQwNw767Wgp9o9ICsVJ4=;
        b=htUzGUVfe2B/TkwFLSwnVrz1nlzIg7VWedDVVBeIrZU2yUKwoEj32r+9cs11Vnm5W/
         CRy3BCUds3GK+Qnpb+U7Hkwk1A3Y0/TO92v0tM0pFfmiH/kERjfEmJRakX8t0Z6tiBIE
         vTfjpieV6KnFMkYEj+gkW71SMwbQPkT2XOk03ndd1vuqw57l6/QldVyvj6hXs1lKk42m
         YstM8gjuy5B9wZxECfS4jQY4PIF6pcIdVUaZ/X6VUg+CKANr2hMnNDL88R11exdJtEkW
         Zt4SHJkESlwNM4R7xvX3jPu+1OoPP+osfzWIldc5ZfLMkLBzsh+CE7uD+SpkfAVCOC7S
         ycGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745613; x=1790350413;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GezTlyn6XHQWhl94S93tdh+KQwNw767Wgp9o9ICsVJ4=;
        b=UfT8HxGLVn2aggTlmTlpftau6xly3eWh8/j4LNi11Z7uR6Og3ge8aOZo+YpqUuqDSn
         EmlRHnNpEkfQOvP3if4JRpswHVekZyEZug2ZYamWooGObsgiKB40h5irS3eQXt1kil8W
         0EMbpMJKRMI5ghd+ABf7aBkt/hMXBcwTU2fW0gqUW/xNEgT3xQ9OcjgQS/C2AyLhYIzC
         ar66zdubYP0tt/e+sykucFPBxPdP8ZWtw1zt0XNtn0vHkmoNRU0GFt4VO/ZgSPE0dXkN
         2qVGjRdUMr/OcDGMtfaprJDS34VwdNxE9AweFBkVR/ARQ+XLgIHWRGQp1AUkC57pjNx+
         Aptg==
X-Forwarded-Encrypted: i=1; AKwUvBy6JPwNQaj58zbak//a3wJaLuwUSyChPlx6E7ZSShD+thD0yZvAqyvbnNOPxv4k80dC5Mf1UoPoAQ==@kvack.org
X-Gm-Message-State: AFuF++lje6Jo18rMf8igUpfCtoD2JBBIEx5TNNBmsVTbVQN/Dks78B8w
	iI697cbd4KerwAI3Z/y6kO1lI89djIPT/p43ZkS0+aYfa9vXM16y6AZVeakhv/HmSb9ZAgONSJP
	Sw6uzEQ==
X-Received: from dldyr17-n1.prod.google.com ([2002:a05:701b:4511:10b0:143:7976:20e7])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d91:b0:39e:6c68:c782
 with SMTP id 98e67ed59e1d1-39e6c68c9f1mr34046a91.56.1789745613433; Fri, 18
 Sep 2026 08:33:33 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:17 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-7-surenb@google.com>
Subject: [PATCH v5 6/7] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE02140008
X-Stat-Signature: mz8gbrsxrjcftuh8s6rp9dszdh6enw3o
X-HE-Tag: 1789745614-607915
X-HE-Meta: U2FsdGVkX18VKS8+N9BNfA/jy4xJ1NMeLhV64jNz3ZVO/vPj6AwQM882x4GI/ubh4CO6Cj/KEjOtMhhFt911KlM6h2dpU2CjHresT+QDIdh9OvGC6KGazMSGVl3s0QtSWOrXTYYwQB9iw4xG0Wykt7dfGEnDhKzUAZcs2fdwuk76xe6PphgCBgQXZgZoVtYb3ojQKgYEXQdVxwIU/c6Wxbkka5Ov3/Irg3fG/eqLB5fmzi58zKGSikclXM8gHnD6g/FiEjBqaTIFD5ODcs0yPJAhjgs1KJo9rPfBjZ++lbNr1xQ2DyqmQ/KtCN+e3CPkP+CACmrx6U6pauPaR2DZKdDgXcm3aY3uKVoz7g/d0g86+6oALiCBu60YSLj2KXQ7r7nLQ66M7GkgJxbGOpJfkZsHJIX86r6D1B8t8ZAHmME6jY7UF8SAEYn/XfbgN3Foj2hFwGngWAPeLQoayKAAMR+Kl/khCVJV94jhyfvn8x3I8/wJ2Sq5sGxRwJzpKnO2tZgZ5Kv75o3u8VxCP2BQlXf5r61ZEmEA0PVFfbKDcXfn27TMGuZM+Ku+9yN3dOqxVL1lCaQsJmfraZTICjg5pz/eeAi3ebbK1N5rDuDLOrbbV4uEjKZYfszMsHzHmJqEBSk5r2/r8tFHzfDVVR26850UNAq7Zi0WgJmA4nXXJLSCWeotfcARtSNwKGVYSmZXQaTQwUosVI2FPojWEVxGJFwuQNnzUQRexctVNQLrPW4v95HAJ8taJAJd3rSSmdHresvMtGWaK2Wetv5obd4mR9721L7DAHDJqrjiuI8xgtGYlUE2tXALqTg/g4o8qEoyy7Y3/eRO77bTwENLRMbaiTu6a82G1Rsu9CJhPTAerOJDITzYLjncNWUZFfqD2N9VQ8nNQVDJeBv0NOP31M3HmzdkATJ25TgdoK9fFfxMzllUYoHiuScRgJNLwzG8cRqu9sQHRP6Q/Rc5swZFJjK
 DjXHSOGt
 rH4zGdXDu3eDUFp05e6gTuTxBuy+5WVCPDPALjUa3xEyMOROycedytfj0X9Ycu23VPPXXFadoMqdTfuaBR+zmE5h4wy4RcoDGDC3L7X50lFCcsy0F3IkrOi7Jd1lj+9IOu6s0EGKparO3XqDmMYHgVPubYCFOjyk7lZEkVeQWX3yVMcrp/SBiFwOILe++KHa/0gTVlrPJHk2i9o9amK3f639O5URqKS7VwaMmy34mFm40X7eBanyZbDn8zln0ravFar8r2Dp1HBKH0050zT44WoFVmEeIyjuo6sP2t2I8CIH7jwowRmd2dUSsaivmyKNjaX/leCgBEpsbU0nYu09d0MNVOeDwQwpdhv83MJP5Cq1Nik2xiOp1nKdtklhLKwPCiUr3nfvJ8wafzrzhWCtW1xW+uIcnuWZCr3wvr2LOjchfKxDI42AGrhZ2w8BHhkMymxrdL3swaCpSHhbek+1SZO8g620vJG9u7keKgiBpoQFV64KPZdhVvck680Y1JGpX/GAxdlFHFgEnsMNqMZjPAt0KRDCnCd8cIRXQ50nbXG8nrltkB4e4U/jwQbcqKmt9IU9N6FKpEe17z5uT1qkko+fa6y2CJILBQ/gTPp0FJoqd28lg2jXqLUk6iixY27yYYq86FKY218sxENzKCNe+OUcSQweJ2QQDvGXcAUc0NXKMx/5R4HKUpvOXs/+gCqX8iRUAiUKH4Xycq6GtTfKpE+5dbg==
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/proc/task_mmu.c | 159 ++++++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 96 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2c90b91d271b..c0d228036b8a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -130,30 +130,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 }
 #endif
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
-{
-	int ret = mmap_read_lock_killable(lock_ctx->mm);
-
-	if (!ret)
-		lock_ctx->mmap_locked = true;
-
-	return ret;
-}
-#endif
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
@@ -162,6 +144,12 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
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
@@ -1406,12 +1394,14 @@ static int show_smap(struct seq_file *m, void *v)
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
@@ -1422,90 +1412,63 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
-		smap_gather_stats(priv, vma, &mss);
+	if (!IS_ERR(vma))
+		vma_start = vma->vm_start;
+
+	while (vma) {
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto out_unlock;
+		}
+
+		if (vma->vm_start < last_vma_end) {
+			/*
+			 * After retaking the lock, already reported VMA grew
+			 * or got merged with the next one and we found it
+			 * again. Gather stats for the remaining portion by
+			 * starting at last_vma_end.
+			 */
+			smap_gather_stats_range(priv, vma, &mss, last_vma_end);
+		} else {
+			/* Found next unreported VMA, start from its beginning */
+			smap_gather_stats(priv, vma, &mss);
+		}
 		last_vma_end = vma->vm_end;
 
 		/*
-		 * Release mmap_lock temporarily if someone wants to
-		 * access it for write request.
+		 * If the VMA lock is not taken, we hold the often contended
+		 * mmap lock. This can happen if we had to fall back to the
+		 * mmap lock.
+		 *
+		 * To relieve pressure, check if it is indeed contended, then
+		 * temporarily release it.
 		 */
-		if (mmap_lock_is_contended(mm)) {
-			vma_iter_invalidate(&vmi);
-			unlock_ctx_mm(&priv->lock_ctx);
-			ret = lock_ctx_mm(&priv->lock_ctx);
-			if (ret) {
-				release_task_mempolicy(priv);
-				goto out_put_mm;
-			}
-
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
-				smap_gather_stats(priv, vma, &mss);
-				last_vma_end = vma->vm_end;
-				continue;
-			}
-
-			/* Case 4 above */
-			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats_range(priv, vma, &mss,
-							last_vma_end);
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
@@ -1514,10 +1477,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
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
2.55.0.1082.g2b9226bbc0-goog


