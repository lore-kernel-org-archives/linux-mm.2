Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170D0C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52456B0098; Fri, 18 Sep 2026 11:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A283F6B0099; Fri, 18 Sep 2026 11:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917B36B009B; Fri, 18 Sep 2026 11:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAE96B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61AD51C2F94
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:26 +0000 (UTC)
X-FDA: 85227277212.06.87F0ABA
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id A36B8C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UdzrL2SE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3w1mtagYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3w1mtagYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UdzrL2SE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3w1mtagYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3w1mtagYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745604;
	b=DfTqEx3f0bt/TEAXA353XBubnyCZYAvL8Lk4DlZZXNhGuwc8Qj+oTAqr1vDyPw+h84TMK3
	2Q85c4Ldt5NsaWUfyx5y2+1qT/TnzMvyl4G05LYgp2bbfE3r5Rk7WQ9VvMDc9GPya+BCwm
	nhMmH7gimDzV5+2k93xVh/rkMJh0cBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G76+KNo+7dCD80CEXVYRdrJvlcvMXRNfZh0Z210UNpw=;
	b=751BNXWT3DyXjIIzAYzopMOiyKvIz5ziln+0zc6DSsGmtnlZXuFpeD0RxRPw+9tzX+3UHK
	mjF9jjjuCXXbEnA1hKpfsg9MheYI9bV7hKvRkjUwchd9jvDhcCgqIq3rOjTlBYOqem9XTC
	hVmLd049AXBI92kcecqz2oe+pnF3RRk=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1297375a91.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745603; x=1790350403; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G76+KNo+7dCD80CEXVYRdrJvlcvMXRNfZh0Z210UNpw=;
        b=UdzrL2SESt+r7wlWnsRN8aY40TKMi/sCp6LMlSKvp/8zhJzGUkL0DmmC1+hnERr7+v
         qW/J7WWjHB/we7BJUquYI7a8c06HPZT0iOaFEP+eYSFGwzVEknxTw28GtIHx/UNG8bz2
         Zk5Mo/BiR8m7Ww/DdBpExwiDwc1msEAB0qilejpjMC2Z1I1ko3p/RrvsAz79ZKaGEQdA
         wTRMbNeP+i4wKTNZJX74f2I1JAZUQhbfoNsOnox93dWtfLp3pwyGxSjukhfoaJ8DAy2A
         YOBi2EGIXakv3VqWXjulERO0Tx5YFnk7akkEwSnp/7mMxizk2XfLtUNQBi6lfKEqrV5O
         maTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745603; x=1790350403;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G76+KNo+7dCD80CEXVYRdrJvlcvMXRNfZh0Z210UNpw=;
        b=2G27AqmfcLMU7h61PwcbXnxvzFOl6TO3OodgFiNOE7IeHv/LOBffFlz2RDBx/jjGLF
         PV/psX12fuF4IOtOcfCtqY040HKQK1BCTOnvWuSqkIyZ/Rl9c5SsPSsZDFgHej5flEhi
         J6s7zKQzINPRGf7LPO9TYAtmYVNVUsknG4t88kdJcyRarrN/bhlcc8TfqwtDLr4bCMjg
         xY51/E+glCq93yvzlWVCIiFLKSazPgG39exWeBMYxsF7w3EI8zxAg3DjHHphlWKLnlde
         E6tWZAronCr7EX9X00Qg4vgjKc18J+/n5AF0b233pUeuZTs/eY1m+3Cq4B0qFjBqZ++L
         iIfQ==
X-Forwarded-Encrypted: i=1; AKwUvBzgCI2lVPX4bRPmBtoUNeN03qk+aOZ5J7IYnDYazv+tpyTNLGBhtEuJOAeLquwBYzx22LuN7iFi4g==@kvack.org
X-Gm-Message-State: AFuF++m6RWgBrusdy34NJCFK0oyR1unTtZ12kcsGxkrjefxp0+NIPnkQ
	SnxdAhhgY+lhFMPZDVIvmzPnM8AjwFv5ACVhUPxT3LWxPR7tQ8EnndV+eY7fbtNS5pCwE3m+sQ/
	3d09Qcg==
X-Received: from dldd2.prod.google.com ([2002:a05:701a:c902:b0:144:d109:6356])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac7:b0:39e:6c6a:4b6b
 with SMTP id 98e67ed59e1d1-39e6c6a56acmr25332a91.53.1789745603281; Fri, 18
 Sep 2026 08:33:23 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:12 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-2-surenb@google.com>
Subject: [PATCH v5 1/7] proc/task_mmu: remove unnecessary helpers
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A36B8C000B
X-Stat-Signature: x951oyg6t1zx5hmohmwmqrbia54f3xss
X-Rspamd-Server: rspam01
X-HE-Tag: 1789745604-855378
X-HE-Meta: U2FsdGVkX19M63NEx9yLma9gWwnKH+8zlnoeTCUfG6yS3QAIiBLlPwX4bOi+ho5hVdhS30dTjAR/2h4UekQyz5piMX2bzJ3ZkjMWfSvrgcoRt1zgqo9cAZVVW7wvsGIJ4erz7T8vwxry3Vyb6L1i7A156BECZ6/3XV4NkXCaz27zH8q0+5HHRhL1XnJ3nNByZyRugL7HZdOHCJOxQWsZpNz4cW8nlV6H3Sv/ChFpeKGdjqbqpMWaa+sNCVCo+Q1wrM8dGTGb3/cAGSKxBN+pKZAY+LrpkuO5ztKC9lCIahsGgUMHbOAxY+ppw5LfBQ/+al3F18N+F/pF7kMAZfFSh6PEHba1vQXAIYP6SK1REaf/IOEEaUvn5JmNyHI2nn+Ra1ospidtLh7oG0DoqHHMBpl5eMI3XA+U5dCYqIN2rj18Mh46e9JHjQNXd+zcoG7vcOqene3E4sdNSffw+sWakPG6AClPdvxII8HNUOo8K3vURejsv1tACVkiStv0sDrhbitljGCNGrbnioZ2gnCv4XV4WTmmog/wLPJaa4/EVb473IMpVGD8+edNfv0smF90uZZ/VuRAvOQe1lNywTy1+ISU/jQEr819BDM08h/2U8eT3rlxbqpe7o6dreP4fsq/hvAR7uYIBBqp+iC2zv3z+gCDeGR1ellw9eG4XQycGac2x+4GpjIOI4Ihbv8MuWfCBIi7m25+/HNVc6SNtNYLIUec9JOSEm2Uh7r/QgH68pbfdCl3I6eJOjCDIv7lo7uRWdjEs61c+ZMgbNKTyTPB8d7mNl9wLS8Tqd8GnPSV0u0F+ATCrhwK7H7TCbzJe5KdA0uew/Zgy8QH1DoZHZrx9iC7E0D0FYF/y1rKYM1qn5ExPJgebKVZZuIkH/YoG1Y3+NYo+YJthUpFDVejdwWwl6Imk7l2TtoMtV3nHUlz7b4P9M7q//u3Xyfd49myMrdKTZam7Ug9oHYk2qCF92M
 4FqQIg3S
 r+bipiNHJ58Ucg7VFl5AePeh3LII77wIkjs1kG6NWo3UWTVKc7T0tgRW5g/FSCmfTTOVGK/kqyLTaB7U5L7pADxP5CDZiUW74kCufy9AlklJG+woEv8I5QfDmrXwHWno5MrqjEpXFRr5XO7kF5/t8pNdhmNjngLZF/cpGJ4ALTTw2epC3IYOi6w2pEVwuAGaVX/YUaPFl1qBWKgW1O6CYcnhTTHZknoM3Fcjcz+gfO8o4WujdPHU2R4o66YFU98xYe4fIbEDEoct6YC2OKnc42Tm0Zru0hwBUj5pKexd+fkkRrYrgh4G5H9gAqFsg5e817l5IMybknyJbfWYcSwmOBS98dPcAAN/WvPrGXm5Ow5SCyASYcobTcN0mdMr0hTRz5r1PVYJoFYFnzVyBW3vgASYpHPsoiQRDJb+P8A6b85eZpiaz3qoHzD0ZYjOsE+JWu1vOy6XVXHfsak3LWHG2uZ58PguUz/31uBPY4dInuqnagcxWaDjx1SuHk/UDpYScUQrQDzPCx870bT4YU0isjx97+VVDeEaOaZmlabgcaVCeMKxibAPjIdQ9pL4Be/rbKtQ+vIemfwiwbjTjpy8RbqojgzLeH6dVusxCd2h4XWzIh7NracUdPBO58b2Gnf44SijL1EtXVRKlBDZI2MIkyPn91XpBbIHf/ki5+0JIOQTaH4WT+pFhAh4sgItcHco7FyvICPNXk7ZGtAd1wMYgLozDFFnpe33ffmnk+tUjSdsp5hGXaMFWZIq2Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When per-vma locks were behind a config option, a number of helper
functions were needed to simplify the locking code. Now that these
locks are universally available, we can do a little cleanup.
Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
query_vma_teardown() helpers.

No functional change intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 67 ++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 50 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 052e8dc796bc..191a054d7e40 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -160,25 +160,6 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 	}
 }
 
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
-{
-	rcu_read_lock();
-	reset_lock_ctx(lock_ctx);
-
-	return true;
-}
-
-static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked) {
-		unlock_ctx_mm(lock_ctx);
-	} else {
-		unlock_ctx_vma(lock_ctx);
-		rcu_read_unlock();
-	}
-}
-
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
@@ -286,13 +267,8 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 		return NULL;
 	}
 
-	if (!lock_vma_range(m, lock_ctx)) {
-		mmput(mm);
-		put_task_struct(priv->task);
-		priv->task = NULL;
-		return ERR_PTR(-EINTR);
-	}
-
+	rcu_read_lock();
+	reset_lock_ctx(lock_ctx);
 	/*
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
@@ -325,7 +301,12 @@ static void m_stop(struct seq_file *m, void *v)
 		return;
 
 	release_task_mempolicy(priv);
-	unlock_vma_range(&priv->lock_ctx);
+	if (priv->lock_ctx.mmap_locked) {
+		unlock_ctx_mm(&priv->lock_ctx);
+	} else {
+		unlock_ctx_vma(&priv->lock_ctx);
+		rcu_read_unlock();
+	}
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -518,21 +499,6 @@ static int pid_maps_open(struct inode *inode, struct file *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
-{
-	reset_lock_ctx(lock_ctx);
-
-	return 0;
-}
-
-static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
-{
-	if (lock_ctx->mmap_locked)
-		unlock_ctx_mm(lock_ctx);
-	else
-		unlock_ctx_vma(lock_ctx);
-}
-
 static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
 						     unsigned long addr)
 {
@@ -653,12 +619,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(&lock_ctx);
-	if (err) {
-		mmput(mm);
-		return err;
-	}
-
+	reset_lock_ctx(&lock_ctx);
 	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
@@ -732,7 +693,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		vm_file = get_file(vma->vm_file);
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 
 	if (karg.build_id_size) {
@@ -773,7 +737,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(&lock_ctx);
+	if (lock_ctx.mmap_locked)
+		unlock_ctx_mm(&lock_ctx);
+	else
+		unlock_ctx_vma(&lock_ctx);
 	mmput(mm);
 out_file:
 	if (vm_file)
-- 
2.55.0.1082.g2b9226bbc0-goog


