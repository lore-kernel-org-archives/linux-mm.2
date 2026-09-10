Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A81C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A3D6B008C; Thu, 10 Sep 2026 19:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874E36B0092; Thu, 10 Sep 2026 19:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E096B0093; Thu, 10 Sep 2026 19:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56336B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67620805B6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:47 +0000 (UTC)
X-FDA: 85199492574.14.7ACF4FD
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2351C000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nRGMAQAV;
	spf=pass (imf10.hostedemail.com: domain of 3oEGjagYKCA0574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3oEGjagYKCA0574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084065;
	b=CcU614ye5EwMDf3EwuaXi/qODa+hvomTI61MdAeMRcZUOCzUvqUCL8aqXlTf0XmB0uxlHs
	xJ7mner9jKQd/aDnYD8Eawo6sDlb7N+2ielLGFuDjzoq9iIw/ouXmDZThThGB+VhBeAzjK
	QfQ8tLEnkbEwgKPlvdkTLOC9bmelU4s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nRGMAQAV;
	spf=pass (imf10.hostedemail.com: domain of 3oEGjagYKCA0574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3oEGjagYKCA0574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
	b=Gzs0wIjTqciqeG/BmbyUyDWscOG9Lg2TyrYduQHj8YjiP+QQ/AyGuCqzZgqnLo0sa5ocZ0
	VG1BMCDJLpZ/fWILc48ddeGryxLRU7+l0CnTiEBw8RgZjkY39i1Ea+H+Vyhy4VHZmOSwHz
	6GHN2tENfDrs0ZkhA0jCIKwk7cz/zJs=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4afc810bfso1456666a12.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084064; x=1789688864; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
        b=nRGMAQAV1kSXAhjENMnFbMCLlf0N5wJ6MR8mVaPUrzOUTGJUKeI2xIk0v6YRbgRKeV
         0h+p5zghqzv9TvY3/eHhaIKlueUWE6FQn2hUFFfm5NVJ+UxKRbUFZK08RMRTTWgva+2O
         x5lGQZVdW1Mt2jM/bQn669nE+0rYIoyratcWKCgj9sCKYRumqYq1dxPKNRLicXUYB3l/
         3+xb9g5uGojkWfODKxPNR8YGBCLJ67X7huBVBtUaGHnRFs4ZvSp5Mb8/ugIxmNVKdw0w
         wSDKcamPTI0wJKiqwj5QWTk8SyVFjMiTL1xohUSFXrxxctmKlwgrpBONHSkuNhggbOgO
         6YvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084064; x=1789688864;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOFXyMArwtdLkzPinOADoZdNqvQDYiollRghSoVraI0=;
        b=dTB8Bi/o/0PyX6F1B7NY7m+Mbi0vBlEpcTsXtfV533qZkxI7e2IFmnPQfMxA9cbUJk
         l+S8ftOV6qADyB19Rc3tnC+bagVkIO9hH4a9BOpRgUvVzMIXiciEjLh486lPuilLBuTW
         8gKKd71fLH+fONN2Lq1bOzf55wkK8kJ+T0Dw3thNGMGBGeBtvOTqc/TRhRObWOUe/3Km
         lrTQOtWLEOj4xbLYxZi2VSj6G4k4XGHLmUqbP89rYrgZA9qXrKBkaIpj5dEG+c9ks8KH
         qjgnT5jcnEnjvdOGphCBfvOM1L/QtVLfwM/j/puOlf9XuL1inr1qmiZ/HcAzyD03r9Cu
         dkmw==
X-Forwarded-Encrypted: i=1; AKwUvBz/RlL3NDnKnKURp/sRYcdlNJ4scQeTUeX6jhln6GeWHto+cH/5n8judYKJqfKQDpigvzCkRhYzXg==@kvack.org
X-Gm-Message-State: AFuF++l5xovsxVD3+pPO3j3WgEBvIQx8CKrTVrwUs3c7twA8gSjC9nTZ
	w63fmbgsgtZU6FLr7gl/4gxk64KduZgeVzhhhVW5wRvrLAzPe8Ey4zj2ihy7Fvi5+B3kJv+FNUR
	hz6wBgQ==
X-Received: from dlnn5.prod.google.com ([2002:a05:7022:6185:b0:141:4b41:e0d0])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:bb86:b0:39d:8b8c:3781
 with SMTP id 98e67ed59e1d1-39d8b8c3efamr3490361a91.28.1789084064165; Thu, 10
 Sep 2026 16:47:44 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:31 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-2-surenb@google.com>
Subject: [PATCH v3 1/7] proc/task_mmu: remove unnecessary helpers
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2351C000A
X-Stat-Signature: aqr3jpesgse9ycfwfyz74j37g7sq4o5f
X-Rspam-User: 
X-HE-Tag: 1789084065-525430
X-HE-Meta: U2FsdGVkX1+dPzKHhefMwkuf9/uluq1wlL+PnFq+jE73FCwfU2GHUkPFZJso71NKW8LGc3vzUs7oFOYeiBn9TeWusTM1kYn+E6j7otlM8eI3XKxPXRbQFrJ8NNhYzHk2oQDVf5CNYC2EJOrWzx9m6GfNSaCE82ujvNtCqog+hmD6I0yO3Ly2ZX6albh+1iJ+nNHi54cqPT1irrhs/xNLXVOvxNfUvT+N17YNXwKJyTbX+rjDkrV3iutLuJhrgfOvRo0tGBxLVe4JL5myTUxRoOGRGK3pDoGrfYxiwV8+r1Mf7ODcrljtrK5UY+gASV7xHJsBMZjwLHvgPGoOfhOvzeTr0VadAq8QvbDzt/QPwYbCAsOGgtu+8smM2fGb/hsX6uDf7W7yMdVnQKmqV1Gl+/pym72ZIVSC7hQbp1YuD9Y/yG5TQyTAZpSNGUvyJTluTceSe2+kSByPo/QDGqx2hB3dDloinRt/yA9QJpHVcfIwcIVT7nHzqLBC1GOybPWq2WIwjHFBmDj82bTispWxWjFHW5ACSAmGYseI4mvF3DxZlm+r1yMySoYWNJY7OMptizRC5Cx1YH3GS0lqnHmsQKRsVXXRPpLZFFRmEiP0Pma4clRzq7d9N/b3pwydFTZLUuZDrYqbY9sYrB90m7hH6c+gpJ/phzYMzrLvBf+5Ab7Y6iSrn9b4xWOCsICYzZTBOeiKZkUvHbRAY9uWZz0RKcoLlMbICL0stbeZSxMHlLgB2MY4oXYS9TFOskz4zdQI3VPJx1jfo9nDOYZj2FGT9DdCaulkTwDUvNlWZgCfkHKOb7K9ci7ho1YCBg/0zfUKOPNcPBnWKVMXvf07qby7y5k8boF67qW9JwSBlmeI19RWy/B5SqckcIoAI7jowk0f3S0PU69M4cNir/cl2Qh9DIG6qPQh14qIoWgY7d1llAnwaTqJcpiIrfmfp+s4zGlI5uFEksA49ouqPrzN69Y
 FkEi/2de
 3x9Pc5BBoI+61YnedAj05rpJ8B4e5HoND7HJSQf4PKfQsCnGnEiOHItIrSaD81RDIL5g0g4oMNyOUZByp3PxaGhfMxqmkmNkF/m3DgN6VquAD5paWzaeBuuJZyQFYRxk8zJTL4CY4SJIeeblCwt/t+pFqzvmI9Q7vdMGdlA/N5DPov42bp7GfAXwxUcQzyeSLOurgsJVsPQYGCzXBnPePig/xnEcKOUZhGnelZyydym8PAdhS2XTSps+W9JrET0s57VEvD8McviI6Bru7JTb1AGvmRMmJgfhc9P6B29cDJuXYx0KRj2AjnI2eCSYXQmENSgUrkPV7pDMXHsEsknodpqILu4SOlVt9AxnPgmvl6tMOgafyxofetSBSuQbXtzCJvrinVHyMJ5ieX1umU/avTRNxqbvqK8Y6LhmU9laAA78c6PyMN0QRlGcaz/Q0MVb5a2rfOAbU/VDKdtKOqWeCBTY62GQM+fSooQpkXgOytKvOsRyCW3aHUBGo6ucwcBVNsIfMjL9iswwfNCR0NHZBtWgY5ktzc4HOuG/zRlga8o4Lk9+K4VHMCbMAH/pkeys0CO7np3WNvWRL3p9Mi1YKPl4EB8ALjDQw53kwgYREKm2kXKZmhsJ/AtSnnGbtoklzjIu1LuXAuiAE0bNBoozUPJdksfieqszG0gTQ/4v+oYvbn/Qf1ekjiFM9ZZMB+3PfRelk52tLymOprCipnAhAmmwdd6ACa5tZ2m5WYaV6fcfmCAW8n0N5IdpBbA==
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
index e671b4fd8ded..2f500d639db5 100644
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
2.55.0.1007.g17ff1f9808-goog


