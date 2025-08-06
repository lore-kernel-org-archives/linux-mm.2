Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B52C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24538E0009; Wed,  6 Aug 2025 11:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5648E0003; Wed,  6 Aug 2025 11:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4118E0009; Wed,  6 Aug 2025 11:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8937A8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:59:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37A2F1405C8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:15 +0000 (UTC)
X-FDA: 83746791870.16.89C7746
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 376061C000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JVpGwly4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 30HuTaAYKCGERTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30HuTaAYKCGERTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmeTFm5IfPWrfl19FRLhdX2A+KKvy2/5Athl1bFbaAo=;
	b=ikF0EDPEGLby0SCgv1agw5omAymRQWQ3WCXS5Mrs3Pzq84MOEsuTd4noeHHHA0B9m8g7K0
	4P6+U4bexaMXQNa7VDljQcJwQDgQOk8/7LJ2M4L/sB8FuW6CigwngCdZpuNOXxrygfYedW
	Xmhc41SkuLBx0PmcLaQJrq7PjeqN96E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495953; a=rsa-sha256;
	cv=none;
	b=51HRAq14hCDG9RfZBDCZp12cjQ1/BrS6ReAuHgzQgkpf0JhsnYmc23nw1NWXJaso5Wf9yD
	apeMIRbzu+FYajaIbjGE8UKDaa0qrSxdtPVYokgQfIyxxcHO9l3ZjtU78V/JffCuRooz/u
	fNVVCjnQihMjevtL54XXZ3feavoosq4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JVpGwly4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 30HuTaAYKCGERTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30HuTaAYKCGERTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31edd69d754so96440a91.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754495952; x=1755100752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OmeTFm5IfPWrfl19FRLhdX2A+KKvy2/5Athl1bFbaAo=;
        b=JVpGwly4zCka6bdElkqIN3EaYYcTt5EwwGpI56VnSXj2ex9bGCAEAbUrUe+w4LAbTB
         NsBwU2DrzmcIk3QA8ccZgUbSsxEKf08yPG9WGGWocmMWiaZ3XlPNX6ZunXoi90ymiocq
         R9KT6/yaVfX9fU3EiXu5useyMrl8breq772DVXCb6Hb/08cW3U29XzbZLKB7vdAvIZfM
         s1j/XZ/rbd07mftn7XHxZAfo8/E7JGymveDBPlEcAQD0wUajQ2oYnMhBjfj7Pu7rVGN7
         IXIyMpRZF7UjuSwPAG+4npWZD9nisLGjam+2oOgE2xitlix+qNqJH58Q0U73600icLEw
         PXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495952; x=1755100752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmeTFm5IfPWrfl19FRLhdX2A+KKvy2/5Athl1bFbaAo=;
        b=YvPh6Uj14unmKM3SaSfS5OtMW0kLWFu8n62wyEJ50X+wk+YBRn6H/ya/PqkM9onLjY
         OP3Pt5PDsW4+u0G9pMDSl2UUKdmxzzM3Msno6ayLyfNKoBmzV8/jeAOhxPXCq+pUT2aJ
         8A/EkT2GjGOuBUbK/4DAekNWvzO+hhbPvRHzr2PGxXQxGHY+9OJLIUWCoRU5fdGcuD1H
         3oIFePm1G7ozqtKzVjiAfUypg2Oj7QmTXI8wj79RD8FrJyWrNx0WWWf/wDZvoLtzYFe9
         2601M8PRCrC1JhI1dsOEzC+8FXsRXAxkS463OlQ8cPlbP2/fYxZerUUeyw8nCp6NWv88
         I3RA==
X-Forwarded-Encrypted: i=1; AJvYcCVkplqjIhIGOrpA5nZxjX+EVO+W3t5C4DQqKXTlRPxbbPAFKw/lHB5EURAygZ2AfKyR9c7SqCdhLw==@kvack.org
X-Gm-Message-State: AOJu0YzBdIQ53iRR0UZvIpgmr0f0Igy6kqC+aOAQR/lX/iwO/d3jPISS
	/x6PUU2BRU9KJZ6jlmYKAwJ5o+6LyMawGxRHQ0D6KXnz0noDTwV13f4GbWYmQcdtmrjbdSeenLN
	10tqeeg==
X-Google-Smtp-Source: AGHT+IHypLIFS0bldz1JBYWo4PWfSWusTsYByh8vtqV4CTtvef/tfbbsrJZ7GVJlV0SCUzRbeil7HQOczFA=
X-Received: from pjsj11.prod.google.com ([2002:a17:90a:734b:b0:31c:bdae:b22a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc7:b0:321:2160:bf6e
 with SMTP id 98e67ed59e1d1-3216759164amr4291303a91.24.1754495952108; Wed, 06
 Aug 2025 08:59:12 -0700 (PDT)
Date: Wed,  6 Aug 2025 08:59:03 -0700
In-Reply-To: <20250806155905.824388-1-surenb@google.com>
Mime-Version: 1.0
References: <20250806155905.824388-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806155905.824388-3-surenb@google.com>
Subject: [PATCH v3 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
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
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 376061C000D
X-Stat-Signature: eu6xmybdasretbsr5n46wkj3fqwsrhgy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754495953-967912
X-HE-Meta: U2FsdGVkX19rvzWzS/lhH3dXs4d7WyLiBNnw7/9BUUAWg6Oa/AnQxG7k1QzSC4mrlQWJwZxtrv6wDwMKycB/bAsNea83eKuZa79h8up/58MwfZcRYRKu9oysiBDuQavnFsz63bed2rlIoF6FVr+lWNDszwhJqxAVUbfS6Io5jnYPzKAYyplr9PSYK/tJftlHKYVxc4RGsyU2dlz0sWLRJJv+8IoWj+JDnLKUGu+1CVJv3kIGUFT9EB8rYnj96kXomb+TBgNWNq3DeBP7Ans0pcoSt1ilX1UX65O5+jjWKPgclyrrPKv4fprIp3Fs06AHAFLoKgxYx+g5ChHCRVzH/MJAOf7ih9aj07m1eHnH7grsUMTlrkOzp1VcuZwLEwaU7Rhq+rtFfz7KaTAlyLHhdGAmGdPVyf0uJwXh53BKFkCALc1+vaSnhCBHfB+kMnWOhsOejtJhdIb/NQ5uzNHdpQ/cc5RkYRaJX3O7Yb7geTc3C42WYKujihJGUsdc3B48O1sM2bl2AAMhqjJ42kZeOZ2+OlbUGjR4eDC5MUwMAEqVWMzxNtP2JKaOBlgG3rZBYLWghbcIPgGSY9DhoMmh1Ym8eHqE8BIqX1W3prSJ6Nb3wkLu1F72E2gle30ZdfirELmNfOoWqKGQEOreeZF0dMPyteK+yUddw+KUYyoNLjj5etdC+07QYGjJfXym5a7jYkEx/9Z0EWhChWsnfTHMtrGrrYXmLCJN4VdrWx8AYgxNOtu8Yh97M3mQrXscskpNjWUln/Zb7pLdnCskx650CmQ1sNRzKVKu/C4phNdgc8ahTYPnCLVtVslxP+//LBtfcwaxU13/oPXp66oGXMNMWdfCDPp2WxaFakexGUOeNo0/cvcJg0mVFUBjUPcw1xMWLHUEabx+w5S3i9SPfkGShcnKx3CP1p3eB6D5ePhGnfOO8J/Tb8+0Kkp4qDD8BqWTZcQ5Uf2r/DOK3MClmfF
 7beBOQTS
 DKBiMh9kGIcaLk0qLdpKCykWK3nRRyJQOoYq/buMpiUdDmPHzzaiVU09PR2zR0e2VXHNy6rGmhoEpnCL/DlXzP/hq5bwMxxHXg6tKOY5ebagRDOa3XH3vDpzieJ5NhxLNlBIPfyFBLBZ6b3/jKSbtD87WcdZhMASnCawXIS2J+sQg5OWolkrO9aC6NyUNEdKgSDDHTzyawJuaVSQLvlTBNxj9AZo6QV0KC5yZd+Bjpg4XQ7p8k0aawrdhxFGZKb65+7Zk1L21hqlN7PbDFNsZ5myxeJjKU5Od5K7aMSwxKoUOUUN8hUSyEC5x60i8lTKg+7/5wVdFJfPSDkaOy461K7M0Jlqi3IuRhqCzJzhmS/xMpDrsGLA29uemnpnLu/7xSjueWPuKPG0KG5VEDNBRa5QOOmDf0vUMqq/Xcnjak+cMWuKo8lU8IG3T6Yote9/DN5coEE1cst/rJ+36/elcgyxKosWhMSDnOIl1LBgluiiqTPuZMipbX8V54aS8ZpzPfYmGOP+d/2xadv9GPzYMDER3UJE0HehfSMPxLmu3Ss/XfmJNZPt/rlEYYIl0oICKplXSVTLXUS5qNvOjec30lyNKaI5pEn7M4ITkrtRHNOQSMfFkZLqPWL0Szg==
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
---
 fs/proc/internal.h   | 15 ++++++----
 fs/proc/task_mmu.c   | 70 ++++++++++++++++++++++----------------------
 fs/proc/task_nommu.c | 14 ++++-----
 3 files changed, 52 insertions(+), 47 deletions(-)

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
index ee1e4ccd33bd..45134335e086 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,11 +132,11 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
-static void unlock_vma(struct proc_maps_private *priv)
+static void unlock_vma(struct proc_maps_locking_ctx *lock_ctx)
 {
-	if (priv->locked_vma) {
-		vma_end_read(priv->locked_vma);
-		priv->locked_vma = NULL;
+	if (lock_ctx->locked_vma) {
+		vma_end_read(lock_ctx->locked_vma);
+		lock_ctx->locked_vma = NULL;
 	}
 }
 
@@ -151,14 +151,14 @@ static inline bool lock_vma_range(struct seq_file *m,
 	 * walking the vma tree under rcu read protection.
 	 */
 	if (m->op != &proc_pid_maps_op) {
-		if (mmap_read_lock_killable(priv->mm))
+		if (mmap_read_lock_killable(priv->lock_ctx.mm))
 			return false;
 
-		priv->mmap_locked = true;
+		priv->lock_ctx.mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		priv->locked_vma = NULL;
-		priv->mmap_locked = false;
+		priv->lock_ctx.locked_vma = NULL;
+		priv->lock_ctx.mmap_locked = false;
 	}
 
 	return true;
@@ -166,10 +166,10 @@ static inline bool lock_vma_range(struct seq_file *m,
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	if (priv->mmap_locked) {
-		mmap_read_unlock(priv->mm);
+	if (priv->lock_ctx.mmap_locked) {
+		mmap_read_unlock(priv->lock_ctx.mm);
 	} else {
-		unlock_vma(priv);
+		unlock_vma(&priv->lock_ctx);
 		rcu_read_unlock();
 	}
 }
@@ -179,13 +179,13 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 {
 	struct vm_area_struct *vma;
 
-	if (priv->mmap_locked)
+	if (priv->lock_ctx.mmap_locked)
 		return vma_next(&priv->iter);
 
-	unlock_vma(priv);
-	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
+	unlock_vma(&priv->lock_ctx);
+	vma = lock_next_vma(priv->lock_ctx.mm, &priv->iter, last_pos);
 	if (!IS_ERR_OR_NULL(vma))
-		priv->locked_vma = vma;
+		priv->lock_ctx.locked_vma = vma;
 
 	return vma;
 }
@@ -193,14 +193,14 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 					 loff_t pos)
 {
-	if (priv->mmap_locked)
+	if (priv->lock_ctx.mmap_locked)
 		return false;
 
 	rcu_read_unlock();
-	mmap_read_lock(priv->mm);
+	mmap_read_lock(priv->lock_ctx.mm);
 	/* Reinitialize the iterator after taking mmap_lock */
 	vma_iter_set(&priv->iter, pos);
-	priv->mmap_locked = true;
+	priv->lock_ctx.mmap_locked = true;
 
 	return true;
 }
@@ -210,12 +210,12 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 static inline bool lock_vma_range(struct seq_file *m,
 				  struct proc_maps_private *priv)
 {
-	return mmap_read_lock_killable(priv->mm) == 0;
+	return mmap_read_lock_killable(priv->lock_ctx.mm) == 0;
 }
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	mmap_read_unlock(priv->mm);
+	mmap_read_unlock(priv->lock_ctx.mm);
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -258,7 +258,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		*ppos = vma->vm_end;
 	} else {
 		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->mm);
+		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -278,7 +278,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -318,7 +318,7 @@ static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 
 	if (!priv->task)
 		return;
@@ -339,9 +339,9 @@ static int proc_maps_open(struct inode *inode, struct file *file,
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
@@ -355,8 +355,8 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->lock_ctx.mm)
+		mmdrop(priv->lock_ctx.mm);
 
 	return seq_release_private(inode, file);
 }
@@ -610,7 +610,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->mm;
+	mm = priv->lock_ctx.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
@@ -1311,7 +1311,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->lock_ctx.mm;
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
@@ -1456,9 +1456,9 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
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
@@ -1476,8 +1476,8 @@ static int smaps_rollup_release(struct inode *inode, struct file *file)
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
2.50.1.565.gc32cd1483b-goog


