Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A647CC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94EE6B00AD; Fri, 11 Sep 2026 15:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D3C6B00AE; Fri, 11 Sep 2026 15:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DB16B00AF; Fri, 11 Sep 2026 15:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB746B00AD
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:42:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CC7E40308
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:33 +0000 (UTC)
X-FDA: 85202503386.14.C8D702F
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F2EB40009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vMdCjenf;
	spf=pass (imf17.hostedemail.com: domain of 3iVmkagYKCCoYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3iVmkagYKCCoYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3NQAYtt8jxExfRNC6GxDvVWEx4uiZRxod+0H4r29Lo=;
	b=BcRfDKfjcz4nWMV8zu4lt8lv1s+HMZO1im98PXcdjZ0fhiLHoY8LkFUqIhsFtIqsGRv2St
	1dl24fsOtrX54R3/4yuiWctU4d1HcRlNIm+zFQGCDhlrZPai7dD8e1irpPNlZUmmNga34g
	J7/3fFG28sOpHP0IxrkxllYZjC34JXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155751;
	b=kFqEomuO9D5IeWTf6y70IwmdsyyU4pDfChSJK8yCICcY4HVqM23LGWv5Tye5Qg/AaojjSc
	vHYVuAVJkcq97TDl0y75xU73n9OKrUgiNy7ZAhojEy/S4CXz9ayyaknyRf3NCvgmTRNzYJ
	1PVv1XDkY0GsQeKLdv95svJsGpdEe+Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vMdCjenf;
	spf=pass (imf17.hostedemail.com: domain of 3iVmkagYKCCoYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3iVmkagYKCCoYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so2124325a91.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155750; x=1789760550; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G3NQAYtt8jxExfRNC6GxDvVWEx4uiZRxod+0H4r29Lo=;
        b=vMdCjenfEbtCjTBKC8o+n+8ufSfAWKt4RL78MppSJLwsxRqFSBjSRuch1YbwI+NPTN
         kUmuYq5rdvGhI2FEHIgOTxr38bsrHEe1ALqIkVGsVTgWuZ/J/pA3oGWujhme+OXPwYMM
         o1d63COgh9VPQ89NiqZTWVVVc+pxjd7QCY6NKwmPMTYu3u+E8zIl0liZpsDuWyI6cXPd
         GLCPOs3Nt165G+r5vBeseb87HvV7JgSmqf4aogfKUQwEkX3diPiTC0+WibcEu+7b+UC1
         TyI4vg5jqEwc9PkQQbPa1EBK/Vf6bcU14KCERuTpDFMV2ChrffDe5XmuGxG+UA//u3Ic
         OioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155750; x=1789760550;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G3NQAYtt8jxExfRNC6GxDvVWEx4uiZRxod+0H4r29Lo=;
        b=hAOKjDYAa+BCvKTjzJch0UNg6bzOL78ZdA1Ddw4FZlcxeZHeBFmBak7s68so7ipaQC
         nzC8jZktzFB/NvOYbZJSA899sCscm0etd/O2QEAgZ2rz68sSgj2yMQZNFoEkWXyOwkCT
         5J6g/k2NWHbdMo/G41RoLW9TYgs/iVaEyi/NpBffPdXFvMzPBQxZpW7BBbIhOZUx5Zp5
         Um4PmKC5Qh3x/sb4Af4tvY4cv1B2kh8rzbFFpuPv7qiytSxCJZ3CdiVSzoIGMJOK+V8e
         mEuV4BSsvJksNfiZu8ee1SaMkXW0D8Bb7XbesKM8bEhnvIQkCsJbYF5EoIsvjubXRoRk
         Y5ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzT2/08SzRpLL/dThsrDQSZKFSMIJP0LsFAIQOPcB4bmoXFgJZW/v9LLPtgT13oYPDdl11y+Euo/A==@kvack.org
X-Gm-Message-State: AFuF++lH8/3OrDEM26GGxbaLo9TRGqN/4oOT46uwrxxVgzGUL3HMCnDI
	UuRQZrS32AZ1oravjUHTGCebVfdBDZEoVKpzmJBjAT8OkrbVguGf8KsOXnE7PVYhLLx+Y0KRLBw
	XoVQQyA==
X-Received: from dlbrl17.prod.google.com ([2002:a05:7022:f511:b0:13c:fe05:89a3])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558c:b0:39b:29ca:3d23
 with SMTP id 98e67ed59e1d1-39d9c345ddfmr10081715a91.17.1789155721097; Fri, 11
 Sep 2026 12:42:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:44 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-7-surenb@google.com>
Subject: [PATCH v4 6/7] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wgejnm5m41hjwtdhaj5unbcpfnc4ta9j
X-Rspamd-Queue-Id: 4F2EB40009
X-HE-Tag: 1789155751-369985
X-HE-Meta: U2FsdGVkX19twfqvVZrGs3YXFTl8xp7SVLiXabzQncaVaN6Cr0K9TkvDuuFQeGLP4XR9toS4mcUdoBvsgji2U6o3lTKYhX6Y3vzNbfqOY9koeKZRrx4bzkTfGGbxX9P8xGEugKR4B7RtsO9NYZPTAgFDvDu55VXvzGT1+F6xn/CCvpeECDrf/GBMsp4q/VEvF3qAW7YpLtw+SF1WwWByXaMAkO8rCj4CeuNv1gCnhLsBbGnjPI5xiuWY/cR402D79mbtTtyPdjy8Acd6BygK7nlKPYWpnP1dEMkyJH4QKsKl23t+WVM8gFlZ3fa0h4Ur7jQsx46ulovZpzLlXIU6/CUARq/hzetzQ8uqmYBRmRiqS+DD6VZonqXbXpQG9p4ELq2e6ndFYKINxas9fN3wCNd1sziHBexYocJrRWzqhci5F7yidkPRAocz5b4TFkOxktuM+nn94F9OZq4hv0ELnvJG2UopCZwP+T7qVwXGY8TY6pGZBgHojdV7zNQVhwvoQzDuH8xzulodX5RE+AQcRAvsrzyr0c97e1t94cxsyNdlcgDnACz++7YcoUvMM0+OJPVk1m0zORXiHkKk8Bpcjr3rYGxG5eSpWugQCAfSpZfKcgdWgBWAEfMkHc6831+uHxGx8gZ8FJ8FlT0lMu69ay8n6Rn4cNt2e23gfg8DQe0bNYH8mpK1cJoMdbJYsxffY6uaBIBRFpVwjZVpnTx/p9h9y3zWPoeIW/hdpg//wJhA/C8va3B7WifiAKms8oUa9z4HY4r1RISfShoZvOgYnuiauqFpC5NeQVtKMTZYh1BQD4ANXRMMD3FR0jRTScHmRwR3MxD/en/zAVqPwSN7rSL/dirSbOF04IWmtqyQUp60AAyqasFQvCCQhVe6Sp+vwcvLimQRiGkEmEyxqx1TfvA/3l3oNwhWqj59hmoyODVaYqe3RkfSLTj2zzAcB14wB1fwcmrzaEEFYk0HHNf
 2lmKzGQz
 +G5EsCyTxU/x4vF1sJYHjjR76uOtJhMbHyIAKtah0OGU9xQ059HkY8RAwnHjCtYcNk/E3dr/SkJuuuNq5Qxwq8WTRam5hvk/rRsAl/okbJWvLEo79TkuY0cvBDxPKZ3WTIRK6YPuLaT4y3QMRbMB3PBLBWpCF9eFqd8CUEjU8SxWG9IgB/3CNblAuwSoBNsojF8vM1Yd6FEakOCZL96MqjvUQQkfjyKEivLLD0dm3iT9u9U1KS/po3nw6K/s4Wclkotr7c3trV67tG6NDf3o+7v9EzVaX59onLjFeRTbJPlt+dIQ5CrhAP4aSaCIQ/DrJSSMsLGQ8AxuEcmT8TkhUCQ7S13ppt1hl7QjRZKSu0A3cVibGZA4j3JhVduuMcPruVdgpsuIz3xnEj+JqGgzjj1ZdkkPiJfXfEFXTZ0TEi8uWmV0xHHRERFvgkPHAvYT6XUCh1VG+NbA07Icic8f/TzcGBlMotbN/iyO/GUVEno/9i3+CYCoUaSTxjQQ60g/WZTjlGLY8GSLtpC628Ib3ksPLSUTIlQGrh15a/FpsMvFd/mbHIOw1z85xihx8nRyg6hIfIzi3fweCMHmMDDImmepWMbKtQc5gxVS7Y2KOp4Q4VnOpWcjfE/JZQVeO8hGQ4vWMgNFRbMp0oJe8E4KJUgzDAOEPrTVsrW//d9QJuqMKdeU5cX6WgbG9LdBfEzbeJS4Q7pVJ6kKGG32dWIaGQ3TeGA==
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
 fs/proc/task_mmu.c | 157 ++++++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 94 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index aef7ce659889..24425e230895 100644
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
@@ -1402,12 +1392,14 @@ static int show_smap(struct seq_file *m, void *v)
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
@@ -1418,90 +1410,63 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
@@ -1510,10 +1475,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
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


