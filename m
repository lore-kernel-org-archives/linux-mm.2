Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E21C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4A58E0003; Fri,  8 Aug 2025 11:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226A98E0001; Fri,  8 Aug 2025 11:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115138E0003; Fri,  8 Aug 2025 11:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFC338E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:29:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1EF081517
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:29:00 +0000 (UTC)
X-FDA: 83753973240.27.3B55A5D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id F29A680008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:28:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mlU6IYQr;
	spf=pass (imf02.hostedemail.com: domain of 3uReWaAYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3uReWaAYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754666939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaaNxrFIYW8u5Zqt1umxh8jF3epFz2+2Ag+pI49sCxs=;
	b=AHSxcePTP3EMmoNFXplUGC9Nm2a04EvWO5JZwPE3Md4nK8GTLBgF9+Vq+KxNgw2Gy6F0b6
	tksfgCz5Vtdd+7TA7GZyCS4Kyimpgh5of6PYTBBFNYNEqNMlihPrqazCaDlXiqa/lQtnds
	/LiyxurWm1sIWnCRb4bQ5yZjTYm/SwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754666939; a=rsa-sha256;
	cv=none;
	b=d8FCEIt6rMVlWakb8TOSDCD3Or+5dFe0YVlbAV3FjD2Cz6lYKauB4toJ4FZBwGe9ZRU8qm
	lAWTfsD8GEGLP93ZsLIiA2HjmqAch3uIjM+qJxzwFCx+3J+PTwGUZrEIXCZddNu30UHGq6
	GUOO0PTkVd/lQLD488ESgjgvTZGZxAE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mlU6IYQr;
	spf=pass (imf02.hostedemail.com: domain of 3uReWaAYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3uReWaAYKCIw8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fe98c50daso19002625ad.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 08:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754666938; x=1755271738; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oaaNxrFIYW8u5Zqt1umxh8jF3epFz2+2Ag+pI49sCxs=;
        b=mlU6IYQraRh59vEeDntkvBjhSkRk0tPOcRmVQ9icDh1PibzZ6jTRobsrOtuzSzN1OJ
         /EUv8nLIAiDCq2oqzliLRT+SuxuELB4qcgpuwvJaZzunUw2jTGscp1KJvmcIZIkkelEh
         vTzyeIQ5MgdVi+hBGHJqPE/kxUFH8LiD/2BRQfQt/G08VSRnA5OTjG+ENTq7/CSVM5jn
         t6BQQ7GFIItGnZIgTcK73DIF+SAuJI65czoa5DkBxp9CsdDzDWVrIBz2Z8188IPWORwU
         SjmIAmMq4A0iJKDghSeqTx2hthS55uHv12UBUymfPqv/c/V0CW0pF/+aLjiYYjsJSjdK
         MyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754666938; x=1755271738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oaaNxrFIYW8u5Zqt1umxh8jF3epFz2+2Ag+pI49sCxs=;
        b=gY8dvkzp8Xtyv0Z1880cOXz+O5QgexIqbSDw8lWn8Vz4c8yTY1QkaddGYt31dSV/SL
         Fg8Aj9syuF96n9R6sy9wv6a6Gl53YadCEwJufCatNtuF6He8qtHw3rmd+lr6OUWRVZML
         LGqHMjeVeSl4QoTKzhW6nGIDFW3PEBssMGZdUmuoJp88L1iPHHuXNcmI7uIf8xpU+ffB
         xCjoWqOwv2LqdLk/ktOpCW9kA03fb7B6ylDUjr2pb8XEnde7h5fNe743V4OhIdX6m3G+
         XR4XH2G3esLuSy1ZnrTMERWW11OO/48aqebiYV6fcBdywDXk4dSa1WvQNt4EyYVcoDHo
         ZvLA==
X-Forwarded-Encrypted: i=1; AJvYcCWk7qRJWGq1NCz80eTt+JPwNHShkHESorChAIYdjpae/gPdGQZRblzgxEqThL1FQD3KDbIEdPgPhg==@kvack.org
X-Gm-Message-State: AOJu0YwkZ0DgW/Wvc0SmO7BL10+AZwJsOYuu5CslZJqov/eJlD2GfrYv
	mF4SilX0gLGvVJkpkIW3JF8wol66pvPXxhA/Rl3m26QggzMvo6BRvX/FzZRVUdGMFxM/XdCTy2O
	qWHgB+w==
X-Google-Smtp-Source: AGHT+IHE0hHtw1Xg0PUR8LXW1OvNYnxaIuDbWWkKp1lBoeFA09FI3YbrJczkDR7Cbe5a+Wuqw/7opjyJj9c=
X-Received: from pjqs17.prod.google.com ([2002:a17:90a:ad91:b0:31e:eff2:4575])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64a:b0:240:3f39:2c73
 with SMTP id d9443c01a7336-242c19ac4f0mr49253725ad.0.1754666937755; Fri, 08
 Aug 2025 08:28:57 -0700 (PDT)
Date: Fri,  8 Aug 2025 08:28:48 -0700
In-Reply-To: <20250808152850.2580887-1-surenb@google.com>
Mime-Version: 1.0
References: <20250808152850.2580887-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250808152850.2580887-3-surenb@google.com>
Subject: [PATCH v4 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
 used by PROCMAP_QUERY
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F29A680008
X-Stat-Signature: wmtf1wfcqd6d5stwqsuhah9q17otbecb
X-Rspam-User: 
X-HE-Tag: 1754666938-491161
X-HE-Meta: U2FsdGVkX1/Xi85+tRPWYbX/T6S6JF8y3hf0wcOrkf/7elvt4pmKUSH8ua9g9j7Jkk9nU4YqmtL4mgXo7W4jTbyY0gzEb+2JB7qLd+L7FQlywE5jCUbT1ERNU70722TEUE066RW7hBLali2LUSBwGkdiTl7EKys5quhe7XpsPB2/HpDgxRHM2pzHuCRSryNBcaefJ3DOxnjpoziyuXd7TgXbAgWIWxwQZyJahX1c+xliO84WwBLTtXuLyYUL58kk1Z59RtoVFydakrKCYb6/WL4GiLIUoNpWN6TQjmktvAXFo07vrT2Sgs4LmZTZ8nIclECIUXjXShyHbQvJZzx0Lve8PRu+ocVO4oXJfzxqVq82eE9eFSx8Ul9lbWQghP4y0e4m25VdkSZu3qu07BRV3U/Os/5QOiabE/F6e/WJ+zcFiuLKCZkZpbvO5QykRthKoA5AkbxC55c9dm9tKgL9T99+D5l1f34yjSno0SEEp2lFVtXAEpQPPoJ+34YRgbELWEoPNPTB64aP39t0z5RQDtVoOCUB9R7HA7wUYemThBb6WbfYMDDWs7hQF18uR0415eAM8D3UmaXNEySD1lgqBX01AdncTWJhFrDqUoOnFBjvdXnAQo7y+XtgsT7188HgL6PddfZwgS0O6ZEQh9vxIMLHhKTHp8sPbpDio1IoJKi1LFNO4u/Qv+jigS+BBp4baYh7eZ+u1sKoaHgGpi4wn4C4StstB+DQArHsZtinwpShbT5lAJjRKuRdvCiha97D6BBSY74pE3hvwLoFYEuA3ofn5RPDeDf6l3Pm2vc+nH4a+6iV/tsQQgh90XQYSC1E8pdQ+qFkib8MVfvpIaIRPPvZktu/ccoxlZvA0WuMIeNvtI3s2mggHO3PkgpqxitDKswM5IPAkiFxGmAj6R5gz9Vi2G50QXcZ9/bDC2L4zv+1OACWST0Dc4XXrdRBpPdTod8yuzrEL4vIEBlRAwc
 7ZMX+XON
 OAuTmNkD0nkSkJyo86UiynR5TArhfOfilDhvYagtgcuRXaBUBiUrMXtDKQJ+g+/8rhhmOsZyWB1ZakCA/lliANKu4AeTrNDz5gKU1yNvf21FZqwPm5Y1ahN3CQGya0iVHBrAcxYyxT4crby1KqnAB7AYUXcV2P98eVQ1mLimUwmDLwvZnVm/Z+rh3AN8pRq/+4PC0Gm3KgQdDiCSOV526crTyOBJ/jHByAMBP+0ZmCSIOW26Yg4MxLADivFYgYck4xi6rF6Psrt7I4WcfpDSrUTL8DWDW7WU0Q6kb8+6a/+4elWsOmceqPGzgntDMU/NCbXDZqwwzq1O+fnc5hA+ilUKxMzO0UlKceEosRmRPLiZarC3cXSDnm7jPooCwuB5gTorIhapEb/igU6O2EbeevgrBkLjfwqVHKqLcsYFI8vvbR6qEbIiRJog9ueFexAV0sPT4gieLOzeFe2r8s9hnKCAb7AaNuRMUBpbso8+klI9ezRAQQWBDSVaz2ouJGXc/YbbQBzv8u8jNuuYB8Fin5XA9a/8+6gVoJRJTSopu2cYldXL+ra3ETlMxT5VZffObMlM/syXkEop0MQqiZcDEPs0+cu5IVqV72e1U9D6ksUabquEKCFRDN4tBo5koHPvhCssc7KG4Jczcl+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
ioctl are moved into a separate structure. In the next patch this allows
ioctl to reuse some of the functions used for reading /proc/pid/maps
without using file->private_data. This prevents concurrent modification
of file->private_data members by ioctl and /proc/pid/maps readers.

The change is pure code refactoring and has no functional changes.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: SeongJae Park <sj@kernel.org>
---
 fs/proc/internal.h   | 15 +++++---
 fs/proc/task_mmu.c   | 87 +++++++++++++++++++++++---------------------
 fs/proc/task_nommu.c | 14 +++----
 3 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e737401d7383..d1598576506c 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -378,16 +378,21 @@ extern void proc_self_init(void);
  * task_[no]mmu.c
  */
 struct mem_size_stats;
-struct proc_maps_private {
-	struct inode *inode;
-	struct task_struct *task;
+
+struct proc_maps_locking_ctx {
 	struct mm_struct *mm;
-	struct vma_iterator iter;
-	loff_t last_pos;
 #ifdef CONFIG_PER_VMA_LOCK
 	bool mmap_locked;
 	struct vm_area_struct *locked_vma;
 #endif
+};
+
+struct proc_maps_private {
+	struct inode *inode;
+	struct task_struct *task;
+	struct vma_iterator iter;
+	loff_t last_pos;
+	struct proc_maps_locking_ctx lock_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 29cca0e6d0ff..c0968d293b61 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,18 +132,18 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
-static void unlock_vma(struct proc_maps_private *priv)
+static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
-	if (priv->locked_vma) {
-		vma_end_read(priv->locked_vma);
-		priv->locked_vma = NULL;
+	if (lock_ctx->locked_vma) {
+		vma_end_read(lock_ctx->locked_vma);
+		lock_ctx->locked_vma = NULL;
 	}
 }
 
 static const struct seq_operations proc_pid_maps_op;
 
 static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_private *priv)
+				  struct proc_maps_locking_ctx *lock_ctx)
 {
 	/*
 	 * smaps and numa_maps perform page table walk, therefore require
@@ -151,25 +151,25 @@ static inline bool lock_vma_range(struct seq_file *m,
 	 * walking the vma tree under rcu read protection.
 	 */
 	if (m->op != &proc_pid_maps_op) {
-		if (mmap_read_lock_killable(priv->mm))
+		if (mmap_read_lock_killable(lock_ctx->mm))
 			return false;
 
-		priv->mmap_locked = true;
+		lock_ctx->mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		priv->locked_vma = NULL;
-		priv->mmap_locked = false;
+		lock_ctx->locked_vma = NULL;
+		lock_ctx->mmap_locked = false;
 	}
 
 	return true;
 }
 
-static inline void unlock_vma_range(struct proc_maps_private *priv)
+static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
 {
-	if (priv->mmap_locked) {
-		mmap_read_unlock(priv->mm);
+	if (lock_ctx->mmap_locked) {
+		mmap_read_unlock(lock_ctx->mm);
 	} else {
-		unlock_vma(priv);
+		unlock_ctx_vma(lock_ctx);
 		rcu_read_unlock();
 	}
 }
@@ -177,15 +177,16 @@ static inline void unlock_vma_range(struct proc_maps_private *priv)
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 					   loff_t last_pos)
 {
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
 	struct vm_area_struct *vma;
 
-	if (priv->mmap_locked)
+	if (lock_ctx->mmap_locked)
 		return vma_next(&priv->iter);
 
-	unlock_vma(priv);
-	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
+	unlock_ctx_vma(lock_ctx);
+	vma = lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
 	if (!IS_ERR_OR_NULL(vma))
-		priv->locked_vma = vma;
+		lock_ctx->locked_vma = vma;
 
 	return vma;
 }
@@ -193,14 +194,16 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 					 loff_t pos)
 {
-	if (priv->mmap_locked)
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
+
+	if (lock_ctx->mmap_locked)
 		return false;
 
 	rcu_read_unlock();
-	mmap_read_lock(priv->mm);
+	mmap_read_lock(lock_ctx->mm);
 	/* Reinitialize the iterator after taking mmap_lock */
 	vma_iter_set(&priv->iter, pos);
-	priv->mmap_locked = true;
+	lock_ctx->mmap_locked = true;
 
 	return true;
 }
@@ -208,14 +211,14 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_private *priv)
+				  struct proc_maps_locking_ctx *lock_ctx)
 {
-	return mmap_read_lock_killable(priv->mm) == 0;
+	return mmap_read_lock_killable(lock_ctx->mm) == 0;
 }
 
-static inline void unlock_vma_range(struct proc_maps_private *priv)
+static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
 {
-	mmap_read_unlock(priv->mm);
+	mmap_read_unlock(lock_ctx->mm);
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -258,7 +261,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		*ppos = vma->vm_end;
 	} else {
 		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->mm);
+		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -267,6 +270,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
+	struct proc_maps_locking_ctx *lock_ctx;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -278,14 +282,15 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	lock_ctx = &priv->lock_ctx;
+	mm = lock_ctx->mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return NULL;
 	}
 
-	if (!lock_vma_range(m, priv)) {
+	if (!lock_vma_range(m, lock_ctx)) {
 		mmput(mm);
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -318,13 +323,13 @@ static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 
 	if (!priv->task)
 		return;
 
 	release_task_mempolicy(priv);
-	unlock_vma_range(priv);
+	unlock_vma_range(&priv->lock_ctx);
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -339,9 +344,9 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->lock_ctx.mm)) {
+		int err = PTR_ERR(priv->lock_ctx.mm);
 
 		seq_release_private(inode, file);
 		return err;
@@ -355,8 +360,8 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	return seq_release_private(inode, file);
 }
@@ -610,7 +615,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
@@ -1311,7 +1316,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
@@ -1456,9 +1461,9 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
 		goto out_free;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
+		ret = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
 
 		single_release(inode, file);
 		goto out_free;
@@ -1476,8 +1481,8 @@ static int smaps_rollup_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	kfree(priv);
 	return single_release(inode, file);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 59bfd61d653a..d362919f4f68 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -204,7 +204,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -226,7 +226,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 
 	if (!priv->task)
 		return;
@@ -259,9 +259,9 @@ static int maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
+		int err = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -276,8 +276,8 @@ static int map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	return seq_release_private(inode, file);
 }
-- 
2.50.1.703.g449372360f-goog


