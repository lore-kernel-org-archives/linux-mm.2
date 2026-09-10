Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62278C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1F26B009E; Thu, 10 Sep 2026 19:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654346B009F; Thu, 10 Sep 2026 19:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C8A6B00A0; Thu, 10 Sep 2026 19:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 117CD6B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:48:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FDA5160653
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:59 +0000 (UTC)
X-FDA: 85199493078.10.122BCB5
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5F711C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RaabRf5S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3rEGjagYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3rEGjagYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RaabRf5S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3rEGjagYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3rEGjagYKCBkHJG3C05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084077;
	b=duR30sBBskcg7cXlOjlFBmthLEisnCYb2jl12bxSd1Nvtn9dJeXgye3NqEVuPbnXJO9kpW
	F5bJ6gJmhalTBDbinbVZADsEY+5zArXksir3k6PRZoRhgYOxInG6I+AzICv0QqsKaQ4Rqa
	85Ojn2EIAROEHYec7fpJK1uvnVDERPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UPlg4KrV740Rib8wJaNrr1K8hSvsKhdw/jziCdqQZY=;
	b=dPaehhVIDQtscv3t7DZnGQDcLyoNoyq1gLGiSTZvYuO1lvmyuCVZLWh9d1DfTXKfdLX/8T
	mS+K/yRIx41azgahLmxbmNHniE+ZgQH9eSjcsNWZlU5JOrOmTXqVxAw+uY79Hh9ItTRy0l
	4uYeRe52rAjO4A9a1t+b6Wug7WhZM/M=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dff6253so17343095ad.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084076; x=1789688876; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8UPlg4KrV740Rib8wJaNrr1K8hSvsKhdw/jziCdqQZY=;
        b=RaabRf5SWxtpr2khTU2N4m/YXY5EoadBu5OY5eScA/IPPdx+VX+bg2DrPsjv2AwEYJ
         bMoWwZ/xZF44z0m69p+nMmpKGqET2/MUS5xoubnKtfdSe+sPt6YgvpLs+WenhqQnhzsq
         dJAWPHFDYcLe1w9bqMZDOPExgD0SyvUAx8KYpYN1FbujpWSAbAd4Q2pavenMEa5VxIKz
         B/4yoTWsANSc9Oyq7w9D3sUF6h8FytEkkSA5hKmK0+rpIYxoewZdhh1BJrGd2z6cmiRG
         yL8rDZgiubnKREoQRguGCwuYmlbpXapdgMdEBUdh7F2JkfB9Cia90QAkKmwjACqdMMBy
         IuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084076; x=1789688876;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8UPlg4KrV740Rib8wJaNrr1K8hSvsKhdw/jziCdqQZY=;
        b=EHkkzZ89/NiKR4060HHv3NnJ4upZNIBAB+YsDfdMM/9oOE7H2HJiMF/uPqQbnD2sP6
         wgI0ZBMN4wOr/H4PVeKpjL/sz6wX4z6UdoBP8XX8He754PspcSchCsKqZI0RVDa5oM9a
         xgfjIasd7FxAZyZc8/HGjoHcJ/aVKx8bXdWbXCqo9+iRPDf5RLMz8SuvgwPWe4rjjN9N
         d/fCcJ6N+rFCt1st+O2KrMM2rhZDvLb54YhwMo8izgtA8EUU46EVAkpkWkYq9tsz8oKY
         0yZOny7rxBWLSlkwNStEfgo5x2xTNtpUpxiCCUvmYYv1KfEevMsuAOXlpl8zdeG8jo5i
         ojmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzp90jVik/2esdMVPQjp7PoIftnSxTuEOi+2BPcim/inzMaLPAXAIgydezv+3CJIklCKHYOV/LkTg==@kvack.org
X-Gm-Message-State: AFuF++mVjjuPMOF3S9rYWCBSSVBoQJSBc2thpapT0jlCGwYvuP2p2rFS
	fo8uvGkxCS6VL6GCjwChr2oHe8KEwnduqIvgy64Z1OwalQ3db+GCEhFYVSWkDbqnAsJvnraDAXw
	cyib2eg==
X-Received: from dybdo17.prod.google.com ([2002:a05:7300:bc11:b0:339:79b6:13ec])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288e:b0:39b:5622:d645
 with SMTP id 98e67ed59e1d1-39d9782102dmr1952912a91.0.1789084076389; Thu, 10
 Sep 2026 16:47:56 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:36 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-7-surenb@google.com>
Subject: [PATCH v3 6/7] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C5F711C0002
X-Stat-Signature: z6admj6nc64dxqwnrxwzrp184ihkyjof
X-Rspamd-Server: rspam01
X-HE-Tag: 1789084077-604232
X-HE-Meta: U2FsdGVkX1+JR5DT4eX2QwatbUfUW7R0NZfpvlf3XUwcPOFjO7j1gaNjm7V3bXD+bv2DCEjuQ/ye1jn8ytFQmWuoiqYtPC3kUwJpWx9UV9UfUVF9CmLIiMu76iVhjvjNE9OrkAzZWpbA55fDHZ+XBWZZZVdXbxIlWUW7G1eD1r31oEuLBo4eht/VzVeO6UG9p3ULxckB1x9dprfSKXgKlN6reVsokRRBLcP5TEqMeL5g2mkcpfPTA7XBuELO8OV5Oh62jg+TBEygdyxI9Zb+8MrFW3/NOVv6XaLT6yzF23mKz+5KdmNaOKcuLM/VuK5TPN0YJcuEAEDGH3Nnq4P6lkOBVeHb6caHSxIP3zyWoHP3NENyq43hncxkrWP+v9Pt1ZMBNC9DxzbgTnNj471yg/3ahctsF/uCknlq6D1McLVIhWR8tIQ+Jmks0avcMnUXR+lgKCejXlAjknsYLJQ+VMvMHZYMWIuEMb5dIQd1b2fAX3T9UTse9sRMDIt4pvvJfCBlz5U86Dn6vbrcjbbwqhqFZSHC+tVgX5dWxrVbhCNp4bArt7DmsiQJUZcY4WSOL9Py8cQBHmW4FRlAmpSqS+e23Nq/ZGwaCgTgcw5jXyvePgO1sBzJ3WO85KKdUSuzYq5KdIn8eHs6uv+Jy3V76Y8wynMX/gfUD0n8wtLQ771vgtytZ1FhvAF49sgwEG6i8dbXLUpLf4cPTy44h8eU35DUZoUTYCaFjWhMK2J5RbonMEyj0LKFGCzrdu+cBPCDc7XshpYVuo7qnKQmPQNcP9sTEzERj8F6y+1kLHUsKyqDcXSftV2Ujmvk+E8qJfhw2Ict998WSKYZs2XcKNLfiURikIXTcxMdxEjkqSnxwgeGFxoB8ODGQ6tmL8K5eZJkYvUBZNXCwyVnQNUVcr881hmsGW4HX2Krj2cPIjHoZBLmt2XaecJWXBEENCn+5MFnv5fH7jLyOMghdlR8k7K
 ZAqJFt3z
 5QysBpSfx4l9MNO2oKnlYI6QSetWSn7lKvnCvyk0CiR3M6gPBzBY3XnddwtQBT2YDOGpPRkjTJQiv9OVHg8bRb3bjuPSmcaLMrIDrIcdm+l1BETsZbkCv5Wv7Ck5ttylfz7MEQR1iml0hvmGYqNs9GTN4PmzUjcKe5KOWHDXGRWRZe/Js8czDX2hYyrs8cvb3sye7NzLs2hxwUAO7F88h5D3MWEJ1opsPX6t7iUITXc1rinf3pHtvySLwPbvFQig+TWaLEAcWUq/X7RJRTsX1WWPr3IqBzM5B+IBUBRxgUdmUqqzVTP/sBoaaYIESVYXjtIO5WW1maVOYDf5t5+C/sqcUV+c2ypzwqM8ebIS2JAb6db8UGRn0ckQ6hdbV5LRdgtdT3qiE5+pyOOfX6lYmgTnMj+oIkuzOERTgYfEmseTImRkpWsSFM4b+aFkMLIQnTfF/j3KSsMH8H2uxORugscZfm/6OMAf/1uKMW52g0lfqfzhXcuBW1lo++/Efzh9y5RdOyUPNaLcgNY3y8iPx8AU0QtgKrlN5MUrfhjmhSxci7lQRdntfsM0r7yIw5EjX+V5HnyQrD5GxMerVD0ax50freg2HHogc34sJLwPWPo29vtOhP0u6Y/dguP0FW2D/JY3Wo4+rkiLrB3XA2qXRDGfWNrI7xTygSnCSc5O9TexkquYmGBCAW5wwgQ==
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
 fs/proc/task_mmu.c | 159 +++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 93 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9a3c996c1d61..6fee40bdd736 100644
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
@@ -1384,12 +1374,14 @@ static int show_smap(struct seq_file *m, void *v)
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
@@ -1400,89 +1392,66 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
+	if (!IS_ERR(vma))
+		vma_start = vma->vm_start;
+
+	while (vma) {
+		unsigned long start;
+
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
+			start = last_vma_end;
+		} else {
+			/* Found next unreported VMA, start from its beginning */
+			start = vma->vm_start;
+		}
+		smap_gather_stats(priv, vma, &mss, start);
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
@@ -1491,10 +1460,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
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
2.55.0.1007.g17ff1f9808-goog


