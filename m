Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7909EC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C2C6B0092; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718C56B0098; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A046B0092; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2D036B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04E171606B4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:49 +0000 (UTC)
X-FDA: 85199492700.22.74AB5F6
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3AAA2100009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qvDkdR03;
	spf=pass (imf05.hostedemail.com: domain of 3okGjagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3okGjagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lxw6b8zPXQDgAgRYnoHPMNyyQwwA39x7dITM8AShmhw=;
	b=mpoMB4yvnM71HeJR6jpC12rvZIN7TvZAARyzEaFymHLuCtutQhmwnjGpPEfx6IFXBmsy4H
	QS2mnxIK9UeQkF1dNTI5rU8/pUsDSUTtE+Bm/BpFk7PDNu9PuBjFKPKGTPVjjLiC+lCT8d
	HhgqeOMYIy8EnBllEUukWNPnrKzLHCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084068;
	b=BGJpjE6BzseabW0Er0gcm0T1on7ulASgvap/xk3GU5LQRRRNPdEgTaz3ab+QAsJFDbepoA
	FbLPbNkXH+rxitOKuouG3UY5rjP6AOooWGH0jJXpuWDOuzDp45zMS1AFLsROsLtHfpFVZn
	ehh9L1rgydxvA9q0i4nHpRLJaHkbmSU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qvDkdR03;
	spf=pass (imf05.hostedemail.com: domain of 3okGjagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3okGjagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so367017a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084067; x=1789688867; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lxw6b8zPXQDgAgRYnoHPMNyyQwwA39x7dITM8AShmhw=;
        b=qvDkdR03gZSo5rlrdC7ICRtQYBS/UxlFm8SZtZpks0vlM7rYzdqhw55OI9zps8rNww
         7zHEA+MP5rDCw6RJ9E69mRQcASVxqz4S3nxoK5V46F864hX8rr5woMdJgP3O3BtXW4Mz
         dtSfDXrCLs49HoLpA5tt2FAIolaG26MyjlhK38XKMl9ELaodY7Ee5auBfA8K3k0sFlWp
         bWO3OVcQVZyysbGCK2XplsG0InBgCBihEKjj0ScTQdzRYBgfmmw/HWIMgP88eqb41IhV
         Sloij6SgV0JBX2cw9WXdeI6a8bL3/qQLOkM0QARy+yzv3zclsaLk0gxKjDAgAMB84eLH
         Gvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084067; x=1789688867;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lxw6b8zPXQDgAgRYnoHPMNyyQwwA39x7dITM8AShmhw=;
        b=Vsgzci0Swg11+5NFPNxDIMg9QGkDMm0/3UUxujWsPi04NVRDE+2WYc0A/FoPy7REGk
         qpPJwKUjO4Kb9c/7i8YQrmjtWxeAcph3E7/tAYnOf+Fq7dyBGe8fznu5of3lZiMagMpe
         RCaJ2fMye6keycnlUsiTtHPYNGfS4pBE5PX6/1QWUIEHKCKjkReV7flS4yPkIDO6oOUq
         ff1NdbBhDF6DvBqXvYGud5bjiTmSAGDsyeeF90Og/QAVHkdApZnD6WGsv5RKLta8hsEN
         3FS/jwF7NEB2/dTkohjke0MPJOC7iqRJ8IiipDP43oCTt3PpdieEWbj9Faqvt7zoEFsQ
         liYA==
X-Forwarded-Encrypted: i=1; AKwUvBzrQFtm4WeW337tjqHw45p0GMy6UfQkuHfgwteoZxgLHNhsKsSZLsnBn8PxMJ+6fhzRZinv+ZVXBA==@kvack.org
X-Gm-Message-State: AFuF++nuapZv7DoeVCQZeV/erT4u+VJDNpEyrK7E1LHQ3o1qVk5QxsNu
	zPlfMyj9yq28uiR88r/KxTsCK2zF8292S4P9NOKEPD9VdlV4ChMt8CYqpk9xX6orCBUscW+tKKx
	9bSIFkA==
X-Received: from dlbbu9.prod.google.com ([2002:a05:7022:2209:b0:140:f8a1:77f7])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:278c:b0:398:e6b6:acc2
 with SMTP id 98e67ed59e1d1-39d9c1b4d9amr1874303a91.12.1789084066795; Thu, 10
 Sep 2026 16:47:46 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:32 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-3-surenb@google.com>
Subject: [PATCH v3 2/7] proc/task_mmu: remove unnecessary inlines in function definitions
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: q5w6wso14bgy1ypm1py6k9bo756se7w8
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AAA2100009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789084068-81286
X-HE-Meta: U2FsdGVkX1+b0KQf+jd2t04+O0gqXvUial5548gDLporQRsSTjlfNe+Imum2iIVZEPO1FzRjt/FroSRRxhOinGvD9/INbj9lVmVxfyrUguHaFBhEZ12qWsR3NtIjUv2fN4QDZyut4Ea6Fb4GBIZJjSR8YDamfVDrkq2uN/7haSTKKSR9CNm78f0vi3mBy6omcJcNBcLL0tFzJxPsRp5k5KR66nmRvrCicUefsBTw/ofERNiT9bASs1BZ2CRjWzxYVcFWsI8d1jFsLu1APEiXtBgZYzPIg/3J57iNupElUjOeD0RBvFzklYTwW/tKTv3YxKg89WJrDkpxItc+OtOGsta9rn9FKvCAsnFO2t2vGunDLgYWGlB1mRxullPlqPF+7KkO6gET8tZZoQ4tWyADGr62gsqziFlaDOhigdM2yOlkKgMALsNbSK6yrdxhevFvzZX1QQkoJXqJtevwhsMj/96swOBf/txQd3ibG9W5EtWNDEgKU5D9yCB0CXUxeKZhEV1KRu0j1mbfTdCPGSvtP7rJUgclmXIkV2CxkFmcEKXVjQ8yHqQuP1P37S6FNfvJpSwm55vlSrQDRIYoyIFcs72QagBlmsSXmSklhmG6UQv8xyPe7o/krWppk0vSb0n5ZFb4H0XbF00pO7xSue6yMY2Z0IUnly1RiqXR9LCqbZ7YBnqY38YMGoA7jBwdpjrQU+KDjpNJB9VwmpXA5eETBgVe5b1t/YR6Y8yqbA7IoESbBz6bzqaRKnUGhOXamuL6M2qubkvK6ZfM/a6/VPuiyb4j6nEzNTWAbq0pvPqAhl8sbeiA6MXmdNObJ75SH/pE++Kdos9nEG3j9xVZvzRrc6TyocI5E/3F9mQqeGnnnZ5PgeiSYTb0C7RvDCff+kejEuESqIk4w5ISLyGOVfshNNcU1bRc9u/YW4+8iRx+yEIbWNzjkxEd7koQX4vNNR8GDScrqxXLnS2tNbysknB
 VU/160ed
 KtEV0eVDszK9aN8xF/1KuVZPM4cgU8TvKaCPsOeLoqbIc5fFej/McfZBg2oILWBnFUh79hPFk6SP6KNV6loBJ6GffFUn9FF7fu32Xc18LbICOnymocyI7rK8N7CeDJt2kEZzvPqe6ird9gEscBDutJVvlj4NUg4vr01q6Oy3HK6ZwJXTrqQQxb5edXZJZbHivfMVrb9a2laqi4chDoZkrzzRmt619vQSR+M6Ogz80vhdnRk6N+10FXvx1mmOs3dKZ7txuvHUL4B3errf3IkM+BQ67usvY39H+8hEI040egqp2k1KlZjsQixCZGfjKm8jk8fCtGkPG6ZW5pakTEdz9HtM2DQyqbG5RIz3jdqB4WphBsmDlwr4sfDXpXJQPb+fD5Fp0xYXCjwd/Q8CUeMB2uQ72QlYPBTMH5uXQn0iLvjUonJjdNpFHQvgjib98YSWrt/NqC+i2KM85/OoFeuo4m3t0ln/EGyoTeBMfCIa5io1zUZykCa/FD7NM9vLTZZe3+z/B6WZce9Ehz4MIWDlCTH27ylUFym7hw2qlzh5H1CD9Xp6YEGYwufoqCuqCgbhRGFsvFn/qtmpy+5lnYRDhnKknQnpFvpV8J4ThZgDwHAN9v+dzi9eulQ3EQawnXTY0PPTHKyrXsJwB6JHHrHEcssFrEa3gWZl4GIfo+eDjiJ3o6JuaNUodkdUllKap7l3dWFZFP/0WsNSGGJQ0zNtEG/VjkvQWIdAW0RvE6eKmJhAKY4xf668pSCDXFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compile
can make that decision by itself. Cleanup these definitions.

No change in the resulting binary file size with gcc v15.2.0.
No functional change intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2f500d639db5..cfc7af1b551d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 }
 #endif
 
-static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 	return ret;
 }
 
-static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	mmap_read_unlock(lock_ctx->mm);
 	lock_ctx->mmap_locked = false;
@@ -177,8 +177,8 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 	return vma;
 }
 
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
+static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
+		loff_t pos)
 {
 	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
 
@@ -194,7 +194,7 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return true;
 }
 
-static inline void drop_rcu(struct proc_maps_private *priv)
+static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +202,7 @@ static inline void drop_rcu(struct proc_maps_private *priv)
 	rcu_read_unlock();
 }
 
-static inline void reacquire_rcu(struct proc_maps_private *priv)
+static void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -1230,7 +1230,7 @@ static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
 	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1238,7 +1238,7 @@ get_smaps_walk_ops(struct proc_maps_private *priv)
 	return &smaps_walk_vma_lock_ops;
 }
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -1572,7 +1572,7 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
 
@@ -1588,8 +1588,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 	return folio_maybe_dma_pinned(folio);
 }
 
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
+static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1620,7 +1620,7 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
@@ -1646,7 +1646,7 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 	}
 }
 #else
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 }
@@ -1846,7 +1846,7 @@ struct pagemapread {
 
 #define PM_END_OF_BUFFER    1
 
-static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
+static pagemap_entry_t make_pme(u64 frame, u64 flags)
 {
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
@@ -3388,7 +3388,7 @@ static const struct mm_walk_ops show_numa_vma_lock_ops = {
 	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
 };
 
-static inline const struct mm_walk_ops *
+static const struct mm_walk_ops *
 get_show_numa_ops(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
-- 
2.55.0.1007.g17ff1f9808-goog


