Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEC9CD6E43
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7926D6B0088; Fri, 29 May 2026 21:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CDB6B008A; Fri, 29 May 2026 21:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD3F6B0092; Fri, 29 May 2026 21:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4957D6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:13:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B7EFA02BE
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:54 +0000 (UTC)
X-FDA: 84822314388.29.B75BB0A
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3AFD280003
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TzukZV2v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780103632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fynmi7rwIFSu+oBdSJtvFLSS5oGz3SZ+v13+iDre5xg=;
	b=akTWvoQYMURJ3NRb1K9427UFPOhL0tGRHIxO4/yqjj751gLHYtVYN5pJ/8h+xHQS2xLvgX
	USjIHX6YyN13V6eM/Drv7LK0j9qC2D6meWiPIDTB3Pxu9gK+JLdsWI6546vQiZLKw4wkPZ
	tAlz9hAOS7lHkhH+FDq4U1/uIOkySgM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TzukZV2v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780103632; a=rsa-sha256;
	cv=none;
	b=EwZeX+m5XOQC5uufgRZVOAYmS9WFz8eBvDWbT5yB9E8W9HpsNnsjnG9ZdTdt/LEJ38jGa1
	BvHa3smUs7myoTpac71aiLiDkOQnp5q12c1ZFlHhgGGdu/WJFYMXQYUylQlDKLIIi4xVPU
	2blIeCsMnuD0LvM0ApkIlyHZw35NR2k=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so95357a91.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 18:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780103631; x=1780708431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fynmi7rwIFSu+oBdSJtvFLSS5oGz3SZ+v13+iDre5xg=;
        b=TzukZV2v6VqV6bbH5f+zZRAaJZrDtRrub7JJUhC/oQW+SQX/DjMu1OIo5GptnlY5e3
         oq1kdt3W2/Eb7NG8JI54tzMiBkAY/B91VVbRYUrCFaRInzzUY7dPuamb0wA9VFMe35p3
         q7+PfaxaSLfgCtF1XPgTUFTQWe2eYDwzrmaj7VFfigrQnlRuYaXfhkeOr6kcQnYH4CZN
         JHeMJ711p3XScW956+nwYQHB3ll9LEIgj7hpL0iNMzlJu4WR8ymVVqq7pnw0xB6tvj07
         S71PydNFQX3PumD+MLAf5DZ3gO9mU5ZdjfGdyK3r0MhnS65mib+GEtI/+kMh88EQ86Be
         ohQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780103631; x=1780708431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fynmi7rwIFSu+oBdSJtvFLSS5oGz3SZ+v13+iDre5xg=;
        b=nktrWwr1Bz0FWmuxQv/Iu0nxAFulaxRxOcZVRgTz5F0LqvK2R8ubFnvsvtyLFvtpA+
         WmR84bPmF/DsfxBLdPUL/2QV7Uw+pqoIQ3qywMUOLKpXOqyDW3Fv7u0ZK2jRXztRoDQl
         IqMCznmdeZLZ9VEdysrt2lkMEFQjjGdt0ESEqMH7j6IFtgiEBP8ykzh4K/Rc5E7Vwj+t
         lkXw03vYZG+mvILnrgAlKBIQ2YITLilt2Cbkf9IWpNNtAFwEpRK57xKR8XWWBkwKheXT
         YoAFU6pADh3oCjttvNC39YfMBTnKvoKWj/IMepogekg5XrxAaOaAtRbo3uS6GvBWXSL/
         zLMQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nSNrS1gmgEl9/ftq92o9DnIhe9DJKoQg99/6CsNxEXEvdn2q/BhIlogxnsXb2hMyNSMvPQJyJtQ==@kvack.org
X-Gm-Message-State: AOJu0YxjZ7oF+lW/mzAWXXorW3G4yivlNAJaN0AOvVmYY0ydx9Orhd7W
	+6EkA0pQsrXby2W/4Pbcjq7dIccpjDwYvmHTyFep2rKdJ6YAzy0KgkEqoydjVw==
X-Gm-Gg: Acq92OH8uPVtIV6fzLDm5WhCx7tc/qk/FAv4FHcH5u3gmMawXdGufLwFWkbX2jxczNr
	bkCMsQNveObM4NbSIj1J98OLx8/nZjA145ScpNJUTdX2LQwODOp6wrBdprJV7U7LUW4SbDeg011
	8BnP46h/HqCP0AZkNksORdPCiR8KiVNH2WuBaOquZxt/6DOQz1aFQ/YTu2uv1c/SUipfsdTlowp
	6c6cRn7/fwuIuUpw98452f2tQrkHpTlLM0joVvbUCdddDsmnUKGwabeWIW03I5rxy2NM0EoQR0h
	IqUHREiV+xmqNwmZ10d7GR+YTxfWuzp+HcyGVBIO7AsyKdmPp/tcNpQN3xRMNww5yt86+Ex+Mpx
	BRxrtqWj+xRaW19A/3oj6kbVTxGydvyvcKTrtB/3fSqIIGObL6S5T9eRS1ryG/m0THYavIGWxa/
	+GxdAtFcuTUZSDlxDo847rxWrgm6jyuO/jOWjbfb3+buliVj3lZzRSE84Gff2N9s/faB3aRqrwk
	k3T43LKZqqnXYjyxpLgvbg1z8RmyqPTLtS8PafsPrAgth3FKxsugen9qWdWYQSn02TMl0QozQec
	2WMlRC4=
X-Received: by 2002:a17:90b:5383:b0:35f:b6a1:8d27 with SMTP id 98e67ed59e1d1-36c501ea53amr1511150a91.18.1780103630850;
        Fri, 29 May 2026 18:13:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6b4865csm3012878a91.13.2026.05.29.18.13.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 18:13:50 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 bpf-next 1/4] slab: Introduce kmem_cache_alloc_arena_nolock and kfree_arena_nolock
Date: Fri, 29 May 2026 18:13:41 -0700
Message-ID: <20260530011345.99342-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: osugfmtw17g3ixudobdr5gkoqbm6upak
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3AFD280003
X-Rspam-User: 
X-HE-Tag: 1780103632-570927
X-HE-Meta: U2FsdGVkX18ttrvH5jcHUIqHhCrneGjeHbj1HMNbEjBYW2J59sWMDCufUA+R2e9+R490Om4npRe85B1Noax5fRQaZZHNROJEzg4YgzaaejrwXue5LdtFl70NccyXCTppREXEHXbSCvHNwXNiv8FkqEcpvVXLJj1bHKRCrl6TEL8CKsWBwSYS2iFKELd0wP3MHSx/n2ztQ8q64omvktudxzYP1tZ6dTBOHFeOZH1UOlJ/cwAlfk/1EW+aiW5y4Gz5+UCZ47+b75V5zsdZ25Clk7LZQ1+ZZ+T4opEa+SnOjPuj6ppD0HaJLX3Pf9b0ZaSolc/x3csRkLemSKXOO+ZqcJqAtOmknitowXYqjCiVxphyLUUJahmM2jLMoTqdyLVlxx/fhkQHT8dBY8c0pC4nIB6MD4BUxDbbhCsWnRaRR7OgD3ymQUwf10soDAas1/AXmtEhqIILVJxoymGLBG8PDl32tgXR7ZLpMHTdFx5U8Mw9jzcX9rj8ZPVSvfq6bL9lvo3hrNzwpYn8RpUDJwcZuH5hAxjg8mps3tD4wA5RDdB8Q+K6OA1gFn21o7IESTvaQ92WfS8nOOQs9ZhSK1LE4H0xpkQIjoCBGGosS7OSs9gKXHnx7gHp5OzJmTCKB5SUa0SxZTvFgOTbaOvamb5ra6E+7SvVFQklOg1o7tfq0wMRvPmNpuLTTz4yE9ZbrK+MBqq61Hry5tH4ask2am/RpU39e4SOF3PVrMKVKTiGHo21WY+hiFyDhWfhisKmL4GRU3wyRUJ8DEvoYBxHAAivjDKcRCRcD1S8EX5M0piB4JzPpI5qvCuakW2pxZ+y6r/WAZQp79n7Dht2JHzL+852oPOYit/VSRffR3o98Ynq4YBxN9ylCcOl2smp/8MAFjUqqgfsUmJ40WFWqWjJLvL/nKZXheI2/wqR/2wFbYRAd+6Wi4VoQox4LQbHxBGgItyOZAYAtHUBOWULSCciHO6
 EOlWYSSa
 TVsD/tPEvyc01ElO/d6slZd+yN18PajtArPzk/UqfIBHy/hkKIQ7LgC1LgOXfVqloXyW7OXKYG8hDgDz5Q9Og9FVJ13Cvz445DYs2inxY+p5rIksyujb6ffBeuzxwjhhdXEugaBWge0NFRmZAsoZVidD68y4pZCu/46PdHmdlbJwvCyGfqiEYvXqlrU8N3RswxXP1ZmxOcb/E4VlAQTQ/gjxmy9LT39nuKWXk80CnzT8Z1Ubu2lYzB5HxcUs+hk9D1d7W29mhyu2qXbDubTZcFTFNam3TIjdWIEw6JqJJ4RpkfhmrST7xAZ1Kc722ELSGHC2MoRmIXblGeFn9pBYVc95uK+XQJYDud1UBHVIZPTMX+T6fJDCCZmtaGq4rB6g6Su1vMA6kg0o5qevs/S/fD1ruUkNBV1POdvJxhmCcHZKCKpQQL/NIFKM+jYNMjLqPLpCOOiQrdA8xeis+CA2oyHNy3yZLDTAUNKeB5SqIwXerQvnCgcwy5jO33LnemO6M10EjBtEOKcDn17cSXxtsDkE5ZfSl1B7QoLjb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Add kmem_cache_alloc_arena_nolock() and kfree_arena_nolock(), nolock
slub helpers tailored for SLAB_BPF_ARENA caches. They mirror the
existing kmalloc_nolock() / kfree_nolock() shape -- safe from any
context (NMI, IRQ-off), NULL on transient trylock failure -- with one
deliberate omission: the KASAN slab hooks are skipped.

The skip is the point. Arena objects are owned by untrusted BPF
programs: a BPF program may free the same pointer twice, free a
misaligned pointer, or otherwise misuse the allocator. The arena
layer detects and reports those as violations through
bpf_prog_report_arena_violation(); they must not surface as kernel
KASAN splats. Skipping kasan_slab_pre_free / kasan_slab_free on the
free side and slab_post_alloc_hook / kasan_kmalloc on the alloc side
keeps KASAN's per-object tracking out of the arena cache entirely,
so the BPF kfunc boundary is the single point that classifies arena
misuse.

The free path routes through __slab_free() (not defer_free()) since
arena freepointer slots are BPF-writable -- defer_free()'s in-object
llist chain could be redirected through a poisoned freepointer.

Used by the upcoming SLAB_BPF_ARENA kfunc path so arena object
alloc/free can run from BPF program context.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/slab.h |  3 ++
 mm/slub.c            | 82 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..152ed0aefd89 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -512,6 +512,7 @@ void * __must_check krealloc_node_align_noprof(const void *objp, size_t new_size
 
 void kfree(const void *objp);
 void kfree_nolock(const void *objp);
+void kfree_arena_nolock(const void *objp);
 void kfree_sensitive(const void *objp);
 
 DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
@@ -958,6 +959,8 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
 
+void *kmem_cache_alloc_arena_nolock(struct kmem_cache *s, int node);
+
 /**
  * __alloc_objs - Allocate objects of a given type using
  * @KMALLOC: which size-based kmalloc wrapper to allocate with.
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..c3899cc1dd1d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5402,6 +5402,50 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 }
 EXPORT_SYMBOL_GPL(kmalloc_nolock_noprof);
 
+/**
+ * kmem_cache_alloc_arena_nolock - allocate one object from a SLAB_BPF_ARENA
+ * kmem_cache, safe from any context (including NMI / IRQ-off).
+ * @s:    the SLAB_BPF_ARENA kmem_cache to allocate from
+ * @node: NUMA node hint (NUMA_NO_NODE for any)
+ *
+ * Counterpart to kfree_arena_nolock(). The slab_post_alloc_hook() and
+ * kasan_kmalloc() steps that the regular alloc path runs are deliberately
+ * skipped: arena objects are user-controlled and a BPF program may double-
+ * free, free a misaligned pointer, etc. Those must be reported by the arena
+ * layer (bpf_prog_report_arena_violation()), never surface as kernel KASAN
+ * splats.
+ *
+ * __GFP_ACCOUNT is intentionally not supported. Arena pages are already
+ * memcg-charged by bpf_map_alloc_pages() at the page-allocator boundary;
+ * adding per-object accounting on top would double-count.
+ *
+ * Returns NULL on transient trylock failure.
+ */
+void *kmem_cache_alloc_arena_nolock(struct kmem_cache *s, int node)
+{
+	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC;
+	void *ret;
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return NULL;
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
+	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
+		return NULL;
+
+	ret = alloc_from_pcs(s, alloc_gfp, node);
+	if (!ret)
+		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_,
+					s->object_size);
+	if (!ret)
+		return NULL;
+
+	maybe_wipe_obj_freeptr(s, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kmem_cache_alloc_arena_nolock);
+
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
 					 int node, unsigned long caller)
 {
@@ -6635,6 +6679,44 @@ void kfree_nolock(const void *object)
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
 
+/*
+ * kfree_arena_nolock - free a SLAB_BPF_ARENA object, safe from any context.
+ *
+ * Counterpart to kmem_cache_alloc_arena_nolock(). The kasan_slab_pre_free()
+ * and kasan_slab_free() hooks that kfree_nolock() runs are deliberately
+ * skipped (see kmem_cache_alloc_arena_nolock() for the rationale). The
+ * memcg_slab_free_hook(), alloc_tagging_slab_free_hook() and kmsan_slab_free()
+ * hooks are skipped too: arena pages are memcg-charged at allocation by
+ * bpf_map_alloc_pages() (no per-object accounting), arena objects don't
+ * participate in alloc-tagging, and kmsan tracking on BPF-writable memory
+ * would be meaningless.
+ *
+ * The free is routed through __slab_free() because arena freepointer slots
+ * are BPF-writable and defer_free()'s in-object llist chain could be
+ * redirected through a poisoned freepointer.
+ */
+void kfree_arena_nolock(const void *object)
+{
+	struct slab *slab;
+	struct kmem_cache *s;
+	void *x = (void *)object;
+
+	if (unlikely(ZERO_OR_NULL_PTR(object)))
+		return;
+
+	slab = virt_to_slab(object);
+	if (unlikely(!slab))
+		return;
+
+	s = slab->slab_cache;
+
+	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
+		return;
+
+	__slab_free(s, slab, x, x, 1, _RET_IP_);
+}
+EXPORT_SYMBOL_GPL(kfree_arena_nolock);
+
 static __always_inline __realloc_size(2) void *
 __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags, int nid)
 {
-- 
2.53.0-Meta


