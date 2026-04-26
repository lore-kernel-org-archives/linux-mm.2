Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A95FF8863
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3176B008A; Sun, 26 Apr 2026 02:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AD66B008C; Sun, 26 Apr 2026 02:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90846B0092; Sun, 26 Apr 2026 02:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6D766B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59C90404C5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:27 +0000 (UTC)
X-FDA: 84699725334.19.FC5B634
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A1FB180006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pu7nqP28;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3S7DtaQYKCLgqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3S7DtaQYKCLgqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777184845; a=rsa-sha256;
	cv=none;
	b=rgRmNb8zrlFcOW9R3K5rM2fq7zAIWFYNYwIqKpuX4chD43oyyY9FvGIDpMW7ViF0x6QvS3
	1BtYvq2SuR0qAuYkLZ0zuiIXMuI0ko/wzF4+zUbRbrWDhnBdaTC8jA+34zLE2iVzqgQ2/b
	LUGWe5DjAqcEADdm7AprpgMMSP4El4Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pu7nqP28;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3S7DtaQYKCLgqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3S7DtaQYKCLgqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777184845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BL+hMAWdT+RqZveIZy5/Nl5gkg1RzorHCaohLNV+HgQ=;
	b=ZDikUHsRZp/CJERdpsbIKFC3Fj4vQGkPNhdxwyxKDdbJgu9+OyhA6EgA8cAY0AAR8qOZCH
	HVHOp1Yr9GiEyYbjQkc7piVzkrNXcnJhCfAYXxNS6T51wBTFAtfWA/5XtmmkYb44VuoiQl
	Z2Zvj8wtQLxwr1oa14IHz7606VEtqN4=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so11621505eec.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777184844; x=1777789644; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BL+hMAWdT+RqZveIZy5/Nl5gkg1RzorHCaohLNV+HgQ=;
        b=pu7nqP28h2JeKRzhKEmHK+pi6X6AoiRX8sP0MRxFBE0Jwv1s5i2SfXNfvkpynrRP+G
         QAtaZgp6xGaUzK8DZZ8DJj1OsxrUapWh4/qJ8Plnxu54vZZbSu3fD5jjHxOeNgE+EIdU
         u36KsQkgbwSE7qmdqaVxvQhzOr9J9TBzr0gWub3aoeu2OYVbg4kiu3/c+FYIGXxMxScf
         B1+pZ4J+KNJrvBIvIIpnEu/2wlg18gzABNyV5rCS/Ib2jRBP/K/6eqt0Bx0Js3GR4siK
         p6YnJJTD7d9PijrhPuDAQvnKfPzLXu1/uPNpFJ3FMqwU2j6fuDH1xM7p9HbpazGYsTD3
         Wg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777184844; x=1777789644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BL+hMAWdT+RqZveIZy5/Nl5gkg1RzorHCaohLNV+HgQ=;
        b=kIfn1TayQLK0df1QYbnRylpRsKIYzXHRjAV7v6pGAdAy/TiQXE0tCT5SlaCn+C5cKn
         xpMFl2nU5q2X7ZJa6v5l5lAddZiYnSmX4B78yLwNOyNi7eycTV0CFpdnVeiGe62BcetI
         nIYIl0MDPORayXxbkDt8CV6Bb40tcJZc8MehZChKm07jHmTImZRvsSKJqeRt+AW26xiy
         5opWDwBzrDUhR5sJ7ncH3n2HWAspzKa1fKlDbgLiWjNIWXQpaNJUXxsl3JhIGKqLIIK1
         Mm4oRg/9FKoe/YjFUzWbMqstk8ulqhEJlQm/cYtQY8+to9Ogmc3FhedVjXrdJjdne+Rx
         9UhQ==
X-Forwarded-Encrypted: i=1; AFNElJ+m6uoU1FVGQNLy+cR4oYa589zGIpF880KmQ/Fdc2GEZXQpB452M7TYLWWpPPLJC3Lq75NgoePIrw==@kvack.org
X-Gm-Message-State: AOJu0YxeVnxsl3giMQdmL/ptNO0Nw6zBfeoSMavN8RTw8Y7v3c4qa20G
	9Of2pyy1VPUI82afPUIkZMArEqsgGI4LWE+3gqooe/ceSshagM/39GHWDKPARO1tr7TrVX6u+iO
	8+8zaow==
X-Received: from dlaj2.prod.google.com ([2002:a05:701b:2802:b0:12d:b3e9:aad1])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6606:b0:128:bae0:e044
 with SMTP id a92af1059eb24-12c73fc621dmr20116534c88.30.1777184843993; Sat, 25
 Apr 2026 23:27:23 -0700 (PDT)
Date: Sat, 25 Apr 2026 23:27:16 -0700
In-Reply-To: <20260426062718.1238437-1-surenb@google.com>
Mime-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260426062718.1238437-2-surenb@google.com>
Subject: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zobgm46gsn9qza5rwfbdm1y7w6gon1x5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A1FB180006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777184845-134965
X-HE-Meta: U2FsdGVkX18YVOp5A3K/huxlOe6FNFnN4Z4v9TRInB017mZEMKeFQJucHblT7EcDM84bldw+ns+JRRYZKy4AgA8NLp55CMXzXIKj0yCZhP4QDGbPHFUdwGvC89juxP/ngjF+y0pZmxeVjpezanWB09NqupXdY2n4uKdsIbFQNisGO4qGstsKje+1TxcqwQ/KxuvxQL9LuDAdmsPfZXR/mJDo75AG5cKOeaz+8ARNGWqGfl5TD////dhNtVtP0BvxyPEfb2Dy66ZzqRzIlA5a8WtaLweBpXT3khGy5lx9oujmVyBcAbR0Phintin+In1ZwIXYDyOdG1INuX7Yg7sYnosvqWOgcvk1y25J2WAp9s0k22m76/ZOW+JWEpYWtaLh8PTVBetyQjhYt3jiadbV0I51YemleFkswuBbOAtf3xtDADrUhbVIGG6wQobqWwOcNeWwLCacMtFBmQkQbcGyZ/jEDTh2l3w8tKoLmblOPqMBbCIpkNaRHM+XfMdX4rp6huF5kIa/uTzpNCicOS2fN9Cbd4PtpIAX3qvphOVp1nPwAba8i2g2J2285kB8ath0Ppf7+4GRjZEIhqp0PAhXJy8GdsDbq8fLD20z8G8ua9GB3JL2QjIhq3XjGaPl6VGGNow+1HEUvnD9EoRgUsbaSAE4WoFwNPgDzoANUadKngoN+22c23Y1dWRUwINM+5UAfVyNbjaXedHsTbUKqfSLMtC+6sIzA8Pc0e4n0mru3vMlaePyyMZ129VuVqXGr3qJtNjjeu25yKCR5cWq94wOaFzTP8ZnkzIVjySBO3BoXjGxEP1qkXdbHCDwXsod66bbHZVdUw4rijlaHE9NLXMyZMJTS37Oedb3mr9gOpubG8tzSAeJLL26AIC/5cnjmDzRSmwu63VeEES36Vq9YspKqxDozyd7feBqxCTxlULdwwC4vtYKo3aRXzJmBAwLAj/qzmtLYyl9pjfUHrL+Vn2
 a5JPaKcT
 02dh7BDPmBh288n2LBHQoj9uiJmIGejA/M5+Yj+Eke25KJzduzzOTEs0CDXeF3rRSpR0lPCLR5FV2zdhHdzg8DyQRDfxMsAMi7eqM0hvL/gA2z6H5AS57djdWCF7yuoomFufM6SsCVA0mkaRws5cwFYmw1w7MgKMytAObhCHlBGG2He2LxIb6kYSEJsmy8bB1KMEGanvx+0wSGJNF91vGOniQ+0+POPwvXadZ1xSZWqRT8h3L97AB8LKJnJ04hE/DMBywLXM0dxjMd0CQKS8qpLhZCfkVWANw7zv7yhxvTDVWqhPRoXJcQfiQc9rVtlVZVoVyYmS62SnTok2WV7uEnyqqn9ehyqNWO6xPjdCzc4meQvdMPZshgSouxEOWgtJ3nLZdwr60tgumMdPpO9Y32FZKrlu5Vl0kkwn+zwuRF5Iw1zdtYiDz+NINshRKyI5n9E+HSJXyFTMNsd2wCYdG4+u3POFVexFrxt8B3Bp2bxmA0D4BU8XD48j08inp+wAtotLEckzrgl6PxZ2IPtd6dzQ1jMKlHkFtqe+mJ7sBUvrFlH4tZfaT551w8bO1x4BUAXCj07A79cHUnKVhdGnMa2Ggh77sBEf2nMzX0UaNBbmgtx5yiglo1f+i7aHJfpB7MYj4wWYEDBc6lYHzIwqVeIYArjHYkzUn9Thr3nsD6i0ZTJZvUiQ/UKbV1GamPkQ6mug8tUXg/8jdMrPIwsszAnrR8U57Wlk0nZDEtMiZP52xbO+c2u4GQ0wJ6qJR/6GFt/yEkOUf+Br0qTiCZ4aHIfCgUaYFle7NilCnfSmnrgoUIlI=
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
Reviewed-by: Liam R. Howlett <liam@infradead.org>
---
 fs/proc/task_mmu.c | 195 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 156 insertions(+), 39 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751b9ba160fb..1e3a15bf46f4 100644
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
@@ -1280,21 +1311,75 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
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
 		return;
 
+	if (vma == get_gate_vma(priv->lock_ctx.mm))
+		return;
+
+	/* Might sleep. Drop RCU read lock but keep the VMA locked. */
+	drop_rcu(priv);
+
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
 		 * For shared or readonly shmem mappings we know that all
@@ -1312,15 +1397,16 @@ static void smap_gather_stats(struct vm_area_struct *vma,
 					!(vma->vm_flags & VM_WRITE))) {
 			mss->swap += shmem_swapped;
 		} else {
-			ops = &smaps_shmem_walk_ops;
+			ops = get_smaps_shmem_walk_ops(priv);
 		}
 	}
 
-	/* mmap_lock is held in m_start */
 	if (!start)
 		walk_page_vma(vma, ops, mss);
 	else
 		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+
+	reacquire_rcu(priv);
 }
 
 #define SEQ_PUT_DEC(str, val) \
@@ -1369,10 +1455,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
 
 static int show_smap(struct seq_file *m, void *v)
 {
+	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss, 0);
 
 	show_map_vma(m, vma);
 
@@ -1413,7 +1500,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		goto out_put_task;
 	}
 
-	ret = mmap_read_lock_killable(mm);
+	ret = lock_ctx_mm(&priv->lock_ctx);
 	if (ret)
 		goto out_put_mm;
 
@@ -1425,7 +1512,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss, 0);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1434,8 +1521,8 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
@@ -1484,14 +1571,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
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
@@ -1505,7 +1592,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 	__show_smap(m, &mss, true);
 
 	release_task_mempolicy(priv);
-	mmap_read_unlock(mm);
+	unlock_ctx_mm(&priv->lock_ctx);
 
 out_put_mm:
 	mmput(mm);
@@ -3291,6 +3378,31 @@ static const struct mm_walk_ops show_numa_ops = {
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
@@ -3335,8 +3447,13 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	/* mmap_lock is held by m_start */
-	walk_page_vma(vma, &show_numa_ops, md);
+	/* Skip walking pages if gate VMA */
+	if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
+		/* Might sleep. Drop RCU read lock but keep the VMA locked. */
+		drop_rcu(proc_priv);
+		walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
+		reacquire_rcu(proc_priv);
+	}
 
 	if (!md->pages)
 		goto out;
-- 
2.54.0.545.g6539524ca2-goog


