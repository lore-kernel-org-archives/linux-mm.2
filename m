Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAC1C88E5A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B4A6B00A5; Fri, 11 Sep 2026 15:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC4A6B00A6; Fri, 11 Sep 2026 15:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8399F6B00A7; Fri, 11 Sep 2026 15:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAF96B00A5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:41:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64A87C02D7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:56 +0000 (UTC)
X-FDA: 85202501832.15.E5BBDCA
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id A021880007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=shgirmiv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3gVmkagYKCCIQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3gVmkagYKCCIQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155714;
	b=8SswFpjlMgD0pV7il5WayG9nt+k/jE62s0KsIYGv1wj3VTXjHs/TGFRRLOEMpx0cdtYjP4
	in0bt2/mQ4BgqNCW1mBf0/3Io2SkzjMDT0s0p0FJgRCTM6sITg8Vz5oCNw6HtpUoVSwL1z
	vdCCbvmG2W20/uxf6zj/OeLj7REWNQQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=shgirmiv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3gVmkagYKCCIQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3gVmkagYKCCIQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YI2R/SdoKPqweMYYzjbXGeDWKwn1DHCKfjSC8BU4ikg=;
	b=NHDorE3DyOjcud1dh5iOpi41tuZ2onVVwUSyUdcZC4TleON2i1F2Jd9iRXwn+N0t/d9mnx
	W0Zw4Z/drS0n734ur4fCfxtWG62Iz59WqRc5cLpi7yIUw/udCzcv7cpjMxxUpg1zd1Zx3/
	lX6Rlevflaz6MieV8JPwvVeCQbQKvz8=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2db050d469fso34567795ad.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155713; x=1789760513; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YI2R/SdoKPqweMYYzjbXGeDWKwn1DHCKfjSC8BU4ikg=;
        b=shgirmivoUEGMsoTdZmYZRmCkZkMVTSIDsV/l+H4usIboaAQKRycS3Ka7zepNvP4W+
         kQ9e4gK5t8V5oMknQsAd361x7LDagOp/CveT82xFEeJ7DvIa5lfR9Ru/gFOdCvpp+XBL
         8eQb6Cc8EArTWZoInoqnXtgzTmurK4u8niXJAN0ai82J6mkzb40p/DFPvy15XWm4zmLy
         SFAjTtt8OCzo9JYrNR03epgmoHwkt44Z+WiT2twQ/bArhD/JJOybcnUjsL8RHV5nb3uE
         7opmttzEwc38wJtcY4mKyToV1DEDYmRcVdj7P+miXOVfwactwX1EeNbRFv9FvkgQoZoa
         nwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155713; x=1789760513;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YI2R/SdoKPqweMYYzjbXGeDWKwn1DHCKfjSC8BU4ikg=;
        b=bTaCf+Q69Yeb4wC97EJTqt3UOaTkZUS+sMMvoBT7yger/o87ytXjF6mT/djMylf8vm
         7fGM2dXcYXHqOp4Va/0O/7ag4qOOjQwwOo8KcS3SaUFIWy4HGH01yF0SlBlqXMEINaQP
         /fzFfZr8AY57hxZMYyifaXr/VKyMxrB2G8MmKowyDJVrZLrVTahFe6beRV4BmVjR+P/C
         LTxfqKx0xZhCSO3wjl6do2gNoYi7u3xKl/NIT6q4vBEx442t7wblY3QD4ZhlAtnbsqr6
         NHYIJmn1OoFwRVX3q7bN+rkvSENpQ0PqwlzGiljD5nX8nYnHecN44c7uR/K9VfzZwKq3
         LdhQ==
X-Forwarded-Encrypted: i=1; AKwUvBwolY3Uj7jAp6rWHb+9gS9ERkzPPdEpcuwMAvCOB3TyZcNTB4oINVXp1eaaUiEwjpVeb3MjQOWwbA==@kvack.org
X-Gm-Message-State: AFuF++mumgyRY3H8zMac7bXIkuRKamqXeBOfvOQvvWeGorVYr3/itn/V
	IZc6YYgZkrgZJcQprecUiAw4c7hnNnlO4yn+5HpVG+USrBAiRrtqhfts5RbSxWb+rqoN9qmYi0/
	ivIdUyg==
X-Received: from dybrp10.prod.google.com ([2002:a05:7301:460a:b0:339:7bd3:e896])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:38cc:b0:2db:3734:cfa4
 with SMTP id d9443c01a7336-2dd0e8a0ef6mr117429835ad.5.1789155713246; Fri, 11
 Sep 2026 12:41:53 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:40 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-3-surenb@google.com>
Subject: [PATCH v4 2/7] proc/task_mmu: remove unnecessary inlines in function definitions
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A021880007
X-Stat-Signature: sx7gksf6d53muwjfng65mcxt6sgfdqhj
X-HE-Tag: 1789155714-557279
X-HE-Meta: U2FsdGVkX1/62oShtZuH1hIxkIPASUFkk4iMoFSkq6nB9zqWN7oiyhR7b+bXklqimatOf+EOcR50D8/cSE0c+916zTAXps6pme/FcyvqqeOATMHREFRMDLdP9mHqkmhMhFj2Xulc9/cscWkUlqzExPD9iJM7tV1zAxCc2CWNj40SgWDGWE4e0oemQEw8iDehqz/9ZT8OshSu5ymdvTLroD5hv8CUFOz+sMTexWdNhJU0MwC8ensjbPW6aDCdJMECaovOiNuBxMFBdP+plncnZaxzFvTQyPpkpKwjDTgTB9l3k6SfkG69F+WaV23AEGI8r2n0IYAauL0oNFC+CGEiPijXidWxRMassy/Pt+i62aqJxLUUR9Ct99/HyqSCbDiAucXMsUSyqCzDkAuJ9YrYS9sCUBlOFD6T6sl4NhjnRb5mJ3xz0Ca54QAf6BUHG2cp8fFuydi0CbW81QM1XCFnS0QXXv+TMx6cgjXFrLNJWyPN/obBb1RTMX0wBvqahzk0DdLsdGylGZKYUSViIHGHRxpn87JugDW5Xsmy/JhosQ0QabLqQgLodSUNKrHajROY0l0/IjLBpShazF4EQHqPCFcoxDuQyvMXwQ4K0G/yrgU9N76zZoRXd5RxXYI4cg6VvOZEe+kPrlr69aIew+zp25MEYt3+mabGjvb0ebZY6LMYuGIqdv1OBPHFEeOht3mxp8mC4icZZYlajjqfOeAHDv2QBJkjpaG4zXRfNMNAj9ROUxpr+Gsqkj8xcalERtn6z6SCiv63EziXLVmm8J/n6aVIwFwXwFei0eDm1ziaGrKnyx0q2kqueszYFBGicqzkEl5x6ShUeIUXyj18LAHNUmQ6Jhd1DfOZtjoQoKRyPCRjh6CVa+Uz6C+U4wPNUOUiFSP/oMjLr6AlKRluAklPT6nVf9v/Z2tdnf1g/EedBvUzwxIRUZQcD3gWnkPYoqWtYEUIV/BOXnPGgwIewUA
 yi45YuTe
 KTva33l9auj8Dvp9vhTz9vkueO9ZF8VuwZ9j+IMkClDBPV7xH+o+nty33tAvKyiX3N+x1uJJq8gD1eTTA4bdHHtDad6i0AQLeZ/52f0h1ZP7pD/Y3Sy83AcWkJsSmiTDqI65F+dtpxCoLhc17Bp9fhwuMa0FLKWdhqMwLaphCjuceUF7OSUgTYTrr6RL1CYuHFWh4qG35CbAXKlujK3AsGqCYnwVsVbVrySo1aAvdMhDZhbt7mmobI/hIqf9PcPpKZQXRsw1/T5fr/HvEJpsynwtXLKR5d5a0W80cZg6UhBf7ouaUyLDTpeff3dTtG45jGTHNA5ppOesprxSZuEbCmdw7AiBp4xRKuhkWNOFM0vkVU8L6qi+sJSZO0+SZFMWGsp/IK4/MNMccJucI+Pw8WP53PF+ey0d04OCl8RgEl1VAMNS4Z5tkyKVwTrF+TA+zT1YMGVpdLMIcRs6mror+358izC/Eptt1ycJ4RNwxTeJAL3cXLcvG903tse2iZvAixSBJIBKBmDH6K7iaWeTZlp4u23HExByEj+wR5aDv4ww9HMI82iwVct5TZcu4++T700sWiEeZNMI2enn7w1Jy9OBXyRR/STTdN2PGC0t7MWlwiqwdrmjI57D3MN/CETjf8Mhw6y8mkwdolMcRaANXGHPtmhD9dOH1iNKi+KNJ3jNdS6wvjDKtJLYOrMcYQ9gaQjqiPqH6FQU3bDq1OUZkWBOsSHSk6E9FySeGtQRhiKd0x9xB5WjrFzQ86g==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


