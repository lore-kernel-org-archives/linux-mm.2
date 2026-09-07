Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861A9C79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF996B00A4; Mon,  7 Sep 2026 02:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3813F6B00A5; Mon,  7 Sep 2026 02:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248CF6B00A6; Mon,  7 Sep 2026 02:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E496F6B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 750D81206B3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:29 +0000 (UTC)
X-FDA: 85186014858.12.78BE422
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id C1AAE40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QLNekSg9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3HlyeagYKCKsdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3HlyeagYKCKsdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAyGHFgPAjMeDjtoxxSVMLam0i0jWSVnA20CIJf1N7E=;
	b=QtqBqHSfoMHAzD8ooaahrc3GW4bOmeTvD4lskpFXAGqgOCmTfQX/8YcicVmuID0ZyrHgel
	snC/truMVbz1+6B1yj30z58JbGU3UqSpDGh1U5JLtLW8wHueXrhX98vuVhg39OrajXmMYP
	3XKUXcZlk2bYNa2NPsKbKnvApQzB6l4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QLNekSg9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3HlyeagYKCKsdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3HlyeagYKCKsdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763167;
	b=Kt4Psa/U7KzjgcojfxeJTzF8CaCQW4WzSVvFGpc90aDiOztM1t4CLM2jh2VZTwyfzEjbJM
	xbsq+G4oitJfVtxXzzKCqYjvKo/L8NWRLmn3hyT5hOdxAYUU2YZAIp48ZIBkd5RImLr9EK
	p3OHvZXECH7fULJLIDqmklh+rbR6Oe4=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398e1fafe17so5222325a91.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763166; x=1789367966; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WAyGHFgPAjMeDjtoxxSVMLam0i0jWSVnA20CIJf1N7E=;
        b=QLNekSg96JWdq/85CrmzGTowlRIWGAFP6l4BWqHDCzM1Av7BsAp0xPhn8XkBcgPSv6
         tsOFkLDKqr8B+OODqyzyd9ZFUXTruB1ZaqgdL58CrmH4nAAGdfNUkov8jHRuIGvK8DTn
         cGS3YkNf8Ztis1aji/exEBpnmCy+5BuXzY+7yYPsB6G4925tyB3YPezo1o4rUgt99BDe
         jzik2o72EDGPH/nmekJgaxVRtCBKUjnIadmRVOrHZY26a+sTi87wF9kvZsgNbvjgHVtL
         0ziggH1S3tbYUWvda1Hq8oBfHMNYF0VsTU3v/eTA6rQZOulhhiD1D5O2MUGPQds3uY3d
         wLhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763166; x=1789367966;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WAyGHFgPAjMeDjtoxxSVMLam0i0jWSVnA20CIJf1N7E=;
        b=HFTOCl7BL/Pe7obPZsw+GFz8gWEcvH53mR2JWzxODRRFKealWHU+0RuumzRcwDDBlU
         A19JB6Lzmbcat36o+5uxbHNq/Yqi8gJj+cY4xKBxSCw02Ramkiyl4HPyGAjmKK6eGXkW
         V1xJ7JZx2vY1yGG15ZZIo19pTDVdA7q3VqOC5Mrzkd6QH8+gBf4n7dpNyGEGv1WHNlKB
         Of/3qI20+ZdjH/lwcCuNW5LEPqMhTNXHKdHAmxWj84o+rd6BiZBgh9ab80i2wo0Qva16
         pajGaMbfPyQnBXiCtedwSrnjU8wq7jqbXa2zOPF+pSPcFaXNixCvYvuqJhnKX0/Kauq3
         gyBg==
X-Forwarded-Encrypted: i=1; AKwUvBxI1+7HZvw65dbFbRZtrMupjWrthBvy5gJPTatJGvmgSGI7gKlgtQ8eU5INJ/r8zh80Zkmr+6oJpA==@kvack.org
X-Gm-Message-State: AFuF++ngxyRhbwkE0dA/wFyUL+PDb0KHiPvJ1q8JY0ozKkn27LhwzXcL
	FoeCCyoShdXTFoZVILwiIMx+UniIAnSgp+wXUSVQDN6HnEWTs0niPDQj9XJb/dg8GrWQu/SH9Qj
	UveSiUg==
X-Received: from dlea18-n2.prod.google.com ([2002:a05:701b:4212:20b0:141:4de6:26b2])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5246:b0:39a:e983:d4bd
 with SMTP id 98e67ed59e1d1-39b262a3cf7mr34335443a91.24.1788763166262; Sun, 06
 Sep 2026 23:39:26 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:15 -0700
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
Mime-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-3-surenb@google.com>
Subject: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in function definitions
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xsgk1krbn3eyonnajxsapk73pfwp7y6u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C1AAE40002
X-Rspam-User: 
X-HE-Tag: 1788763167-803217
X-HE-Meta: U2FsdGVkX18FxORprVO1P1A+gNKRda1dOMrV9+bMCmsuYY8PM+++J4fEPRrtW/X0QVwQFGbo8+fXwF+KBFN5kkBuy/DZpIDfm7Iy6d9eeuPPSttNc+m7Rjtv25anPd7vNl09teLqLRULICAApVCW3X36BGVQmbI0iKe6UonViVlVq2uCf4QfljE5Qqc6zZPy2c5Iee1KCS36yJTBpPjdHfBrdJ4yEVIF0dUKy9vj8gNcNtbOAPQF4q9a1BRnBjbUHn5ib2uU2EZalZ22ydegyIA+LjLfIJ2xGSdfvjNr3kt6Zz7apqU60l5GOYxQHLc9rz5yU33eQxhEts3OJ6lQgc82QmW5Lo018o+oe3hGpT+pItizwsVtIJtly+0Wga+zgzWuBtFZzT5a/XmHmEqBO2RktLjR60cBifS9FH4tog+4egaBSVguIzyRHS/KI+1XA5KUXLJzm7EqepTR+BMG+sJ2SE9xfDFolxP316pJfjdp2hy2+kIUaKQ9t8xc+sNUY82lcSd97s1PWuQzf+bp3Br6vy+rv0IYMm/1VAwWk/zgbQBgXAqZCfcx1u78flal0P/7AVJsrkjFPqdi0265YnpW1h0JBgAwNS2v/xRgApLxHZ9m8BdlWxpif0hRlXRgX++SGcfiaBl50qZbojuzCT5VhgvArmB1yMx0IHsANEvMrNl1qiEINWPaSaQaqqzJFLWwQHyBUTK3vVaP9Q5IcrNQi7rkJ1M24JYFwDdIXEJToZBkF15dubfqjlOOhae5gb69cGb+f3bfwJZMZW4hSO5YLbDq47thRgWmPdfzE0H1bhu0Qr84dVWbfiVJmCn/58GvzX6I8/RMcLxog89rac6bVDdtcAKWeBO6PLdGv/m9fUyTX6dj2ndLKTChUzf2HmQk1uYvZmjNa9aODnB5wr2oIfkGsfy2qibFQKARmFW2Q+LF01MhWBhyT9yy4xfv697YSlRrhdQOwyXhlHH
 m7WdKrhW
 zr6BQPndn9PX/KvDwOlXluRt39EMJR7bqt+Xxikjn+sYDVzQJz+i+V6EL8+1SmhptByLh7Ztk7AmwZwluQk2W4eLMtbv/LFpSAHYIKW2d0sbYi+hVLxc9EY2L9rNRCgsCTYTDZ6ayaTJj+9EhKssRoOkh4Q3HFadzJrf8NzCdhFAz8An0zKvT5pmbaWifrJ6LHfsCBjK5ndxLuAp8GNnq+wrll7kuITV/9dsFgFNcfDzfoTkBA4qAHpYwZtcMDu9iK+r40Et7EQf873HqkEDUKX/DyfBWUiaCm6Q+mJOPxzQfZA8w9/p/U1KokNvTOlxSS30vplUF6QYaLa5m2Z0P+agWNmIxWT0WKhjdVprsmi2B+Kv5vhraAeMxxST4JVZ9/jbjJMJWW6bPH+U3JO2B5ELxdConrvzgbZK/87ugwefwZLfCn62OYBjH81b2bZbjtncaUQZ9oBcCt2MlRopNdfXnrM2vHYn2EmifiXMDkahlRj4/upaXTQsouLFd0qemQZfGaitL7YtvkSveQdq9nTqU4Pn0dz7TDOqnfSHDueR6/iB8IiX8/ofX40qmeZkw/3A6v6VM4g25xbJGc9TME6lEcHpRpIqpurhm0f41iwmP02tcHdezj3Zufyhm3iBBQWru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was pointed out in the previous reviews of this code that many
functions are specified as inline, which is unnecessary as the compile
can make that decision by itself. Cleanup these definitions.

No functional change intended.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2f500d639db5..9908ba32f180 100644
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
@@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 	return vma;
 }
 
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
+static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 					 loff_t pos)
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
+			     pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1620,8 +1620,8 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmdp)
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+				 unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
 
@@ -1646,8 +1646,8 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 	}
 }
 #else
-static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmdp)
+static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+				 unsigned long addr, pmd_t *pmdp)
 {
 }
 #endif
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
2.55.0.979.g7e5102b832-goog


