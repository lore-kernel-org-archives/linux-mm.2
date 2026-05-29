Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6F5CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126446B00A5; Fri, 29 May 2026 16:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D90E6B00A7; Fri, 29 May 2026 16:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1B66B00A8; Fri, 29 May 2026 16:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46956B00A5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:24:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83E891C0D92
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:55 +0000 (UTC)
X-FDA: 84821586150.20.C775BB2
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76A52C0004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWMEgG4J;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086293; a=rsa-sha256;
	cv=none;
	b=PKdSqhCoK8V8VBtASvJC0feZG216aXP35Y5hqPXYQuwIDMxogM+sM/HSIWzSf+CZ1EmrDq
	3fMBNF4megDChXOSFxtOwoxCqtp6X+MBAPtAX5aYhhIPxungKrhSonUeOKgVsHPalRqYkk
	EH/lSAFW/WiqDUqpGKoq7XV0Ky9BN3I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWMEgG4J;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVrpqGmEiWBuOQWTjR2xy5ugwejIq1bcpZwr0MBnA/M=;
	b=plCZ7sIzeEl6omNcLgoUMVkdU17coCRSMEyws+71pSMnUt6emTguuY3ml6EzA1s6fD0cGy
	4n4FpsSNaDpzEHCf13J0lSHHYFagwfxpVk1WFxzddZECSPyyQtArPsPCHtqJPfSAVcwnDa
	MkmTpyxhlzWFRtEbjeHgAf1uLRtA590=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36bcf3d2565so551038a91.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086292; x=1780691092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVrpqGmEiWBuOQWTjR2xy5ugwejIq1bcpZwr0MBnA/M=;
        b=rWMEgG4Jzz/cvUZAH/OCrBrMqaPiLldStKGNVKG+Lg/VryQWq/qXnXTakAf55g1kaE
         NxkWcZPNfdcVA6/KaiLh5igvb76skniOVPOIts/eLvHDIP62FfJKnVYvPGmf6/g80wlD
         OQI9yjY1PjKIl0Suu0OBP+VXhIdQ/Z5voJTXWHbIX+i9OD2ekWeEwMCpxvOz9pvc5eHu
         TvbP3lVFUFB/xHqflMkAbdEoauDFEDF9PVFcE2EX5wucvMBSySK6y0QdfPI8vyqOXiTr
         C8qao1rDjR60OruBaw3Q/lU0uYsR1qr9FKV0dmR+Rvp9LrnAkHjw4ZVM2ALCxabzxsbG
         lYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086292; x=1780691092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sVrpqGmEiWBuOQWTjR2xy5ugwejIq1bcpZwr0MBnA/M=;
        b=L8/ep674xQBDW4UGjlzejO1/5k2HmBfR6FAPFFVH6LBSXRY6mFTnKCXhFTY+p4C0nM
         9u+c2V3n6ex3pMGfkHhcPjQZ5aI9uc+PtALCjCWCRWqfyCp0WPNMdmdTEypUm4X9SyPV
         AOQvPJcQ13Kn1kNPKhEAqZPmugTqJp9NTghxPTRFCu2Et4J57UkxLUTavyIdQy3vUUY8
         0IhM9tXqCXsYatNKH68+RSa8nsDbHx6z26VjLfly7BP6RvdkPYIJWIhG6vX+5WpmPWfz
         42xWum7GgPMJDfsBvgN6i30qN/5reExguqa/wTHKzLXpJUEnjFnaGKhmMjxaGQS38re6
         Czeg==
X-Forwarded-Encrypted: i=1; AFNElJ8a5aHMghC5AXAW/XkYdy3Hc4gCuGs6yMdTmaSDX+fSild9kpt2vfAiMFtKaUZHXv/nllGwPfSrrA==@kvack.org
X-Gm-Message-State: AOJu0Yx8byPEFBmPqL1KNnDHEB8/z8cTjiA4QURrQSzPLWG7zfFF8Uio
	+yuXo6ZTIf9g+Fotcfb8UbVLbU+yNcv9imuhYlFnE2yEYg+afgSttBli
X-Gm-Gg: Acq92OEnV5hCr7J3aGDHQPiOiLOLFyTttq4Z8zpzV7YYJIpEsuRFqu/qAqbQmYbXhf9
	SVNfMj3PEz56t9UzLh982+N9bWsB9kY3H8TeweWHHo82TQrbN5SBmAAnY+BxWpezyRmK/8nFOOU
	g6MrWV+ucMfb5N1VSidEJlI6yjH/hzuFUY+W7yeWh9dl78CEvxKFbBpOSwC91IDzRUMA5kqd0D8
	Ju9jCrr8lGwQMLV775Zq+6jbScPToB9DbBS7+sbnceh96yF+C9CWanjzLOFxSTwyA9Bt/yhMVdY
	iy8JOnMbsGJVvQ8ejfIXJgygpPXFWgIeH/tRo7PlFQ1ZwysRfMKa/ouu3gI3iqvPkoaIN70a6qf
	d5F7e2JDzHzO2gePcd5jaaecp5ptTn2n0MkKdNc90sX44UAS/EwBlyaGdjtCVsVNIZJ0DpdUgrF
	NSKJ96jjFQoYzq7bCO5Vrx+715tSCx1AAZCcC235ZY7JE4Arz6UVsciYm/xmz6Gmx1C9EUY17Oi
	J9BaOQA2oIxcPAdFqssyhbVmlkgFxcf5OxNXlrxh5vXET2ecwIBLEQ2SqwR/PxHdLtbD3mp
X-Received: by 2002:a17:90b:3dd0:b0:36a:c4b:76cf with SMTP id 98e67ed59e1d1-36c68479f0dmr654337a91.23.1780086291817;
        Fri, 29 May 2026 13:24:51 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc660d647sm3569182a91.5.2026.05.29.13.24.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 13:24:50 -0700 (PDT)
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
Subject: [PATCH bpf-next 3/4] bpf,slab: Add slub-backed allocator for bpf_arena
Date: Fri, 29 May 2026 13:24:36 -0700
Message-ID: <20260529202438.16408-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
References: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 76A52C0004
X-Rspamd-Server: rspam03
X-Stat-Signature: e6wdms54gyagd8yrhwicdjxwzp5xdk48
X-HE-Tag: 1780086293-40955
X-HE-Meta: U2FsdGVkX1+SGcOntwrQHbBmDZEtA8O/9iZ1edv1eLK60EXetZ6Piqqogqhxcax3d0p0p8iJuAAzhYG6ep2IHSRWex4oMMUvtjOLW6ZjSTb014giwBYKm45VDnQTwEgpGwVDd2F8UVodWfd+jOdQskaDWyxwC6wnnDEYU4It12kAkdVAg+SOxuaNi0bQnGfwaEhdCTcSAFKRSG4P5OVX0h/uHmZYb6Q6efVpSVwFarKU6bpyBsGeCO3rqmY9CUyLAm5ECaEDh3n81oX4Kwubn0H4hXVOoTw2HVpfxJrPS9m2wKsc7LfQx6PmZeEi/lQ3ddERzBVG3NMs3B2N95mnm6PdYZfkWw5fHf+PD0nHfbXq6kyKb6IrM+qpiZTdeeHBHhyylopw78enDuZG3X3lIasaYehxlABwrQUzL24PHb2BjMamkebLobI//JHK4xSV3BEVuTYQ3gRXL8MM+egOXsmduwPPDc/7Q0bbWDVtu+PYEIcGj+hmF+umNnfMwKTWAhOb7SUW8YWHfYTC4dKhBRjtGhEFofcUP6j0huDPq82WxqXctZkittKxrvyRIdq9Rz9cUjOUVGDqkId/nGRP/0Aw4jnL7dTNXk0OveCxWDl2eTPR9ysfdAQHZZFMPAUcbrXLiE2nGr38/ptkf+SWiDhpgCP6RQ0zMx2a+zVx/E4RS1KUnNAzeaJAlf+KTBdjfnA/1UM+PYe+QBYU6K3b+YSuQbJtTdCGRkCzOQEzxjY/jzXhQfT45V3mtJ3yGCuFDZZO19oyZiPoWlEjEg15PDMLdroBdM3MDa8is1PsmUr7TkueeUox03mpN3QCvfWQ4x+KvtESi5lUmfD/UOrzsJi5Is5ZuvTy7+0/REcR4vG8cKtXGOfcWUQJ86lJDrD5eFwXGpLYtSXCMFsyTtI+Pa9ptKMBRmVyuVzttW7c3brzQd4L85CcmNw0rmWvX2meCYaVlIqJZW9LPovswSL
 mEbC8eth
 ZxpXPuAOmoH7oEjGgdVkDLKrYY8WaQWgmdcwofsQnGduhC6op1RG7rz/F1FzC9r51F1P2SAiZhFSANQZeA/cMEv+nlpuEkWJXl78myADU4/eQyU5OOjryap8Lnah/74EthXvuER5pc08VBXW3+jpyAb5tFsIB9HkV8Drq2SJ08XbxyP5DoKIuZ0Aw21ExH4kMQlC9qfD/JAFUF1X7xY+9fJ/I64yvt7J8BnKSwi9W+Gjn08FF2TmQLHpM1WLE9sxPpDHEg16YjvAZ0HDXDZuwcWKyGyvQC3hJ7RFVs5SrdqRpsFFIzNiZa/HZ+xw4yD/KVDiil1MTd7lGuk3A5ASkcu5MI7HNwZXgFfvJOfLnvE30yBlUswh8PdHZy5tbuw4VEF/25WgAv9Zmz9X3sI4FJdge2UHjb/iPAVLwGGQz+F/GpDxLhBF1xXD8XwHlmEJOcgJG//Vdu4DOyRaPBs9AfeXfMI8MaMGgp4aTEIim4tTfqppgmSQ7Rs5+K5OIT8i9gCtZ1Zledgf1u3UDrXmRXSQ26wRbakVsNRTATza2PCs7L07BBLePurguolhEa03HcQeU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Let BPF programs allocate typed objects in a bpf_arena via a
kvmalloc-style API: bpf_arena_alloc() routes requests up to
PAGE_SIZE through per-arena slab buckets, and falls back to
arena_alloc_pages() for larger sizes -- analogous to kvmalloc()
choosing between kmalloc and vmalloc by size. The fallback page
is stashed in arena->slab_pages[pgoff] (without PageSlab) with
page_cnt in page->private, so bpf_arena_free() can recover the
multi-page allocation from the arena offset alone and release it
via arena_free_pages().

Each arena page now has two kernel VAs that alias the same bytes:
the page allocator's direct-map VA, and the arena's vmalloc mapping
at kern_vm_start + uaddr32. slub uses only the direct-map view --
slab_address(), virt_to_slab(), in-object freepointers, percpu
sheaves, partial lists all work unchanged. BPF programs see the
arena view via kern_vm_addr + (u32)ptr addressing. Translation between
the two windows happens only at the bpf_arena_alloc/free kfunc boundary.

slub side:

  - get_freepointer() clamps the decoded pointer to the same slab
    page via (object & ~slab_mask) | (decoded & slab_mask), NULL
    preserved. Worst case under BPF corruption: chain aliases within
    one arena page.

  - arena_alloc_slab_page() stashes uaddr32 in slab->stride via
    slab_set_stride(); arena_slab_uaddr32() reads it back via
    slab_get_stride(). alloc_slab_obj_exts_early() is skipped for
    SLAB_BPF_ARENA so its own slab_set_stride() doesn't clobber the
    stash.

  - Arena caches get percpu sheaves sized by object size like any
    other runtime cache.

  - __refill_objects_node()'s trailing freelist walk is bounded by
    slab->objects so a BPF-induced freepointer cycle can't loop
    forever.

arena side:

  - Per-arena kmalloc-style bucket caches built at map_alloc cover
    sizes up to PAGE_SIZE; larger requests fall back to
    arena_alloc_pages().
  - slab_pages[pgoff] gives O(1) page lookup, and also anchors
    fallback multi-page allocations for bpf_arena_free().
  - bpf_arena_alloc: kmem_cache_alloc_nolock -> slab_get_stride -> uaddr32.
  - bpf_arena_free: slab_pages[pgoff] -> direct-map kva -> kfree_nolock,
    or arena_free_pages() when page->private records a multi-page span.
  - apply_range_clear_cb() leaves PTEs of PageSlab pages installed
    and skips __free_page(), so bpf_arena_free_pages() on a slab-backed
    offset can't free a page out from under slub. The page is torn
    down later by arena_free_slab_page() after __ClearPageSlab().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_defs.h |  13 ++
 include/linux/slab.h     |  22 +++
 kernel/bpf/Kconfig       |   3 +
 kernel/bpf/arena.c       | 366 ++++++++++++++++++++++++++++++++++++++-
 mm/slab.h                |   6 +-
 mm/slab_common.c         |   2 +-
 mm/slub.c                | 155 +++++++++++++++--
 7 files changed, 543 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf_defs.h b/include/linux/bpf_defs.h
index 2185cd3966d4..e271ae78c4ce 100644
--- a/include/linux/bpf_defs.h
+++ b/include/linux/bpf_defs.h
@@ -6,14 +6,27 @@
 #ifndef _LINUX_BPF_DEFS_H
 #define _LINUX_BPF_DEFS_H
 
+#include <linux/types.h>
+
+struct slab;
+
 #ifdef CONFIG_BPF_SYSCALL
 bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsigned long fault_ip);
+struct slab *bpf_arena_alloc_slab_page(void *arena, gfp_t flags, int node,
+				       bool allow_spin);
+void bpf_arena_free_slab_page(void *arena, struct slab *slab);
 #else
 static inline bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write,
 					       unsigned long fault_ip)
 {
 	return false;
 }
+static inline struct slab *bpf_arena_alloc_slab_page(void *arena, gfp_t flags,
+						     int node, bool allow_spin)
+{
+	return NULL;
+}
+static inline void bpf_arena_free_slab_page(void *arena, struct slab *slab) { }
 #endif
 
 #endif /* _LINUX_BPF_DEFS_H */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7ce9125a6a2c..6c6f1ba83c7d 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -62,6 +62,7 @@ enum _slab_flag_bits {
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
+	_SLAB_BPF_ARENA,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -248,6 +249,15 @@ enum _slab_flag_bits {
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
+/*
+ * Cache is backed by bpf_arena pages instead of the page allocator.
+ * Slab pages live in the arena's kernel vmalloc range and are visible to
+ * BPF programs via 32-bit arena addressing. Freepointers stored inside
+ * free objects may be scribbled by BPF; get_freepointer() reconstructs a
+ * pointer that is always within the arena's 4GB window.
+ */
+#define SLAB_BPF_ARENA		__SLAB_FLAG_BIT(_SLAB_BPF_ARENA)
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -372,6 +382,15 @@ struct kmem_cache_args {
 	 * %0 means no sheaves will be created.
 	 */
 	unsigned int sheaf_capacity;
+	/**
+	 * @bpf_arena: Opaque arena pointer for SLAB_BPF_ARENA caches.
+	 *
+	 * When non-%NULL, slab pages for this cache are sourced from the
+	 * arena via bpf_arena_alloc_slab_page()/bpf_arena_free_slab_page(),
+	 * and freepointer reads are sanitized to remain inside the arena.
+	 * Caller must also pass %SLAB_BPF_ARENA in the flags argument.
+	 */
+	void *bpf_arena;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
@@ -963,6 +982,9 @@ void *kmem_cache_alloc_nolock_noprof(struct kmem_cache *s, gfp_t gfp_flags,
 #define kmem_cache_alloc_nolock(...)		\
 	alloc_hooks(kmem_cache_alloc_nolock_noprof(__VA_ARGS__))
 
+struct slab;
+void kmem_cache_force_discard_slab(struct kmem_cache *s, struct slab *slab);
+
 /**
  * __alloc_objs - Allocate objects of a given type using
  * @KMALLOC: which size-based kmalloc wrapper to allocate with.
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index eb3de35734f0..42ef4fc3a6bd 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -34,6 +34,9 @@ config BPF_SYSCALL
 	select NET_SOCK_MSG if NET
 	select NET_XGRESS if NET
 	select PAGE_POOL if NET
+	# bpf_arena_alloc()/free() stashes uaddr32 in slab->stride which only
+	# becomes a real field with CONFIG_SLAB_OBJ_EXT.
+	select SLAB_OBJ_EXT if MMU && 64BIT
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate BPF programs
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 1727503b25d8..807d806856d7 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -10,7 +10,9 @@
 #include <linux/btf_ids.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 #include <asm/tlbflush.h>
+#include "../../mm/slab.h"
 #include "range_tree.h"
 
 /*
@@ -48,6 +50,14 @@
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable);
 
+/*
+ * Per-arena slab buckets. Mirrors the kmalloc size classes (powers of 2)
+ * up to one page.
+ */
+#define ARENA_KMALLOC_MIN_SHIFT		KMALLOC_SHIFT_LOW
+#define ARENA_KMALLOC_MAX_SHIFT		PAGE_SHIFT
+#define ARENA_KMALLOC_NUM_BUCKETS	(ARENA_KMALLOC_MAX_SHIFT + 1)
+
 struct bpf_arena {
 	struct bpf_map map;
 	u64 user_vm_start;
@@ -63,10 +73,20 @@ struct bpf_arena {
 	struct irq_work     free_irq;
 	struct work_struct  free_work;
 	struct llist_head   free_spans;
+
+	/*
+	 * SLAB_BPF_ARENA: kva <-> arena offset translation at the kfunc
+	 * boundary. Forward (kva -> uaddr32) via slab->stride; reverse
+	 * (uaddr32 -> page) via @slab_pages[pgoff], sized to max_entries.
+	 */
+	struct page **slab_pages;
+	struct kmem_cache *kmalloc_caches[ARENA_KMALLOC_NUM_BUCKETS];
 };
 
 static void arena_free_worker(struct work_struct *work);
 static void arena_free_irq(struct irq_work *iw);
+static int arena_init_slab_caches(struct bpf_arena *arena);
+static void arena_destroy_slab_caches(struct bpf_arena *arena);
 
 struct arena_free_span {
 	struct llist_node node;
@@ -143,6 +163,7 @@ static long compute_pgoff(struct bpf_arena *arena, long uaddr)
 struct apply_range_data {
 	struct page **pages;
 	int i;
+	bool set_page_slab;
 };
 
 struct clear_range_data {
@@ -166,6 +187,13 @@ static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
 	if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
 		return -EINVAL;
 
+	/*
+	 * Tag PageSlab under arena->spinlock so a racing bpf_arena_free_pages()
+	 * sees the page as slub-owned (apply_range_clear_cb skips PageSlab).
+	 */
+	if (d->set_page_slab)
+		__SetPageSlab(page);
+
 	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
 	d->i++;
 	return 0;
@@ -179,9 +207,22 @@ static void flush_vmap_cache(unsigned long start, unsigned long size)
 static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *data)
 {
 	struct clear_range_data *d = data;
-	pte_t old_pte;
+	pte_t old_pte, cur;
 	struct page *page;
 
+	/*
+	 * Skip slub-owned pages: BPF must use bpf_arena_free() for per-object
+	 * slab frees. The PTE stays; slub releases it via arena_free_slab_page()
+	 * after __ClearPageSlab(). Non-atomic ptep_get() is safe -- ptep_try_set()
+	 * only fires on pte_none, and arena_free_slab_page() can't race on this
+	 * offset (range stays allocated in range_tree for our walk).
+	 */
+	cur = ptep_get(pte);
+	if (pte_none(cur) || !pte_present(cur))
+		return 0;
+	if (PageSlab(pte_page(cur)))
+		return 0;
+
 	/*
 	 * Pairs with ptep_try_set() in the kernel-fault scratch installer.
 	 * Both sides must be atomic.
@@ -290,12 +331,25 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 		goto err_free_scratch;
 	mutex_init(&arena->lock);
 	raw_res_spin_lock_init(&arena->spinlock);
+	arena->slab_pages = bpf_map_area_alloc(attr->max_entries *
+					       sizeof(arena->slab_pages[0]),
+					       numa_node);
+	if (!arena->slab_pages) {
+		err = -ENOMEM;
+		goto err_destroy_rt;
+	}
 	err = populate_pgtable_except_pte(arena);
 	if (err)
-		goto err_destroy_rt;
+		goto err_free_slab_pages;
+
+	err = arena_init_slab_caches(arena);
+	if (err)
+		goto err_free_slab_pages;
 
 	return &arena->map;
 
+err_free_slab_pages:
+	bpf_map_area_free(arena->slab_pages);
 err_destroy_rt:
 	range_tree_destroy(&arena->rt);
 err_free_scratch:
@@ -347,6 +401,9 @@ static void arena_map_free(struct bpf_map *map)
 	if (WARN_ON_ONCE(!list_empty(&arena->vma_list)))
 		return;
 
+	/* Tear down slab caches first so all slab-backed pages return to arena. */
+	arena_destroy_slab_caches(arena);
+
 	/* Ensure no pending deferred frees */
 	irq_work_sync(&arena->free_irq);
 	flush_work(&arena->free_work);
@@ -359,6 +416,7 @@ static void arena_map_free(struct bpf_map *map)
 	 */
 	apply_to_existing_page_range(&init_mm, bpf_arena_get_kern_vm_start(arena),
 				     SZ_4G + GUARD_SZ / 2, existing_page_cb, arena);
+	bpf_map_area_free(arena->slab_pages);
 	free_vm_area(arena->kern_vm);
 	range_tree_destroy(&arena->rt);
 	__free_page(arena->scratch_page);
@@ -461,6 +519,9 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 		if (page == arena->scratch_page)
 			/* BPF triggered scratch here; don't lazy-alloc over it */
 			goto out_sigsegv;
+		if (PageSlab(page))
+			/* Don't return slab-backed arena page */
+			goto out_sigsegv;
 		/* already have a page vmap-ed */
 		goto out;
 	}
@@ -625,7 +686,8 @@ static u64 clear_lo32(u64 val)
  * Later the pages will be mmaped into user space vma.
  */
 static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt, int node_id,
-			      bool sleepable)
+			      bool sleepable, bool set_page_slab,
+			      struct page **out_page)
 {
 	/* user_vm_end/start are fixed before bpf prog runs */
 	long page_cnt_max = (arena->user_vm_end - arena->user_vm_start) >> PAGE_SHIFT;
@@ -633,6 +695,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	struct mem_cgroup *new_memcg, *old_memcg;
 	struct apply_range_data data;
 	struct page **pages = NULL;
+	struct page *first_page = NULL;
 	long remaining, mapped = 0;
 	long alloc_pages;
 	unsigned long flags;
@@ -647,6 +710,13 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	if (page_cnt > page_cnt_max)
 		return 0;
 
+	/*
+	 * out-path rollback can't undo PageSlab on prior batches; restrict
+	 * set_page_slab to the single-page arena_alloc_slab_page() caller.
+	 */
+	if (WARN_ON_ONCE(set_page_slab && page_cnt > 1))
+		return 0;
+
 	if (uaddr) {
 		if (uaddr & ~PAGE_MASK)
 			return 0;
@@ -665,6 +735,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 		return 0;
 	}
 	data.pages = pages;
+	data.set_page_slab = set_page_slab;
 
 	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
 		goto out_free_pages;
@@ -695,6 +766,9 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 		if (ret)
 			goto out;
 
+		if (!first_page)
+			first_page = pages[0];
+
 		/*
 		 * Earlier checks made sure that uaddr32 + page_cnt * PAGE_SIZE - 1
 		 * will not overflow 32-bit. Lower 32-bit need to represent
@@ -720,6 +794,8 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	}
 	flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
+	if (out_page)
+		*out_page = first_page;
 	kfree_nolock(pages);
 	bpf_map_memcg_exit(old_memcg, new_memcg);
 	return clear_lo32(arena->user_vm_start) + uaddr32;
@@ -758,8 +834,8 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 {
 	struct mem_cgroup *new_memcg, *old_memcg;
 	u64 full_uaddr, uaddr_end;
-	long kaddr, pgoff;
-	struct page *page;
+	long kaddr, pgoff, i;
+	struct page *page, *fb_page;
 	struct llist_head free_pages;
 	struct llist_node *pos, *t;
 	struct arena_free_span *s;
@@ -778,6 +854,21 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 
 	page_cnt = (uaddr_end - full_uaddr) >> PAGE_SHIFT;
 	pgoff = compute_pgoff(arena, uaddr);
+
+	/*
+	 * Drop bookkeeping for any bpf_arena_alloc() fallback pages within the
+	 * freed range. PageSlab entries are owned by slub and must not be
+	 * cleared here; slub clears them via bpf_arena_free_slab_page() when
+	 * the slab page is released.
+	 */
+	for (i = 0; i < page_cnt; i++) {
+		fb_page = READ_ONCE(arena->slab_pages[pgoff + i]);
+		if (fb_page && !PageSlab(fb_page)) {
+			WRITE_ONCE(arena->slab_pages[pgoff + i], NULL);
+			set_page_private(fb_page, 0);
+		}
+	}
+
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
 
 	if (!sleepable)
@@ -952,6 +1043,135 @@ static void arena_free_irq(struct irq_work *iw)
 	schedule_work(&arena->free_work);
 }
 
+/*
+ * SLAB_BPF_ARENA: per-arena kmem_cache buckets backing bpf_arena_alloc/free.
+ * Slab pages come from the arena pool; slub uses direct-map VAs internally,
+ * BPF sees the arena vmalloc view, translation happens at the kfunc boundary.
+ */
+struct slab *bpf_arena_alloc_slab_page(void *arena_p, gfp_t flags, int node,
+				       bool allow_spin)
+{
+	struct bpf_arena *arena = arena_p;
+	long ret_user_va;
+	struct page *page;
+	struct slab *slab;
+	u32 uaddr32;
+
+	/*
+	 * set_page_slab=true makes apply_range_set_cb() tag PageSlab under
+	 * arena->spinlock so a racing bpf_arena_free_pages() can't free it.
+	 */
+	ret_user_va = arena_alloc_pages(arena, 0, 1, node, allow_spin, true, &page);
+	if (!ret_user_va)
+		return NULL;
+
+	uaddr32 = (u32)ret_user_va;
+	slab = page_slab(page);
+	/*
+	 * Stash uaddr32 in slab->stride; allocate_slab() skips
+	 * alloc_slab_obj_exts_early() for SLAB_BPF_ARENA so it survives.
+	 */
+	slab_set_stride(slab, uaddr32);
+	WRITE_ONCE(arena->slab_pages[uaddr32 >> PAGE_SHIFT], page);
+
+	return slab;
+}
+
+static u32 arena_slab_uaddr32(const struct slab *slab)
+{
+	return slab_get_stride((struct slab *)slab);
+}
+
+void bpf_arena_free_slab_page(void *arena_p, struct slab *slab)
+{
+	struct bpf_arena *arena = arena_p;
+	u32 uaddr32 = arena_slab_uaddr32(slab);
+
+	WRITE_ONCE(arena->slab_pages[uaddr32 >> PAGE_SHIFT], NULL);
+	arena_free_pages(arena, uaddr32, 1, false);
+}
+
+static int arena_init_slab_caches(struct bpf_arena *arena)
+{
+	char name[KSYM_NAME_LEN];
+	unsigned int i;
+
+	for (i = ARENA_KMALLOC_MIN_SHIFT; i < ARENA_KMALLOC_NUM_BUCKETS; i++) {
+		struct kmem_cache *c;
+		struct kmem_cache_args args = {
+			.align		= sizeof(void *),
+			.bpf_arena	= arena,
+		};
+
+		snprintf(name, sizeof(name), "arena-%lx-%u",
+			 (unsigned long)arena, 1U << i);
+		c = kmem_cache_create(name, 1U << i, &args, SLAB_BPF_ARENA);
+		if (!c)
+			goto err;
+		arena->kmalloc_caches[i] = c;
+	}
+	return 0;
+err:
+	arena_destroy_slab_caches(arena);
+	return -ENOMEM;
+}
+
+static void arena_destroy_slab_caches(struct bpf_arena *arena)
+{
+	long max = arena->map.max_entries;
+	unsigned int i;
+	long pgoff;
+
+	/*
+	 * Drain per-cpu sheaves of every bucket before walking slab_pages[].
+	 * Sheaves cache pointers into slab pages that the force-discard loop
+	 * is about to release; kmem_cache_shrink() flushes those caches back
+	 * into their slabs (and frees any slab that becomes empty), so the
+	 * later force-discard cannot trigger __slab_free() on memory that has
+	 * since been recycled. Frees triggered here go through
+	 * bpf_arena_free_slab_page() which clears arena->slab_pages[], so
+	 * those entries become NULL and the loop below skips them.
+	 */
+	for (i = ARENA_KMALLOC_MIN_SHIFT; i < ARENA_KMALLOC_NUM_BUCKETS; i++) {
+		if (!arena->kmalloc_caches[i])
+			continue;
+		kmem_cache_shrink(arena->kmalloc_caches[i]);
+	}
+
+	/*
+	 * Force-discard every slab page slub still tracks via slab_pages[].
+	 * Catches orphans not on n->partial (trylock failures in __slab_free)
+	 * and BPF-leaked slabs with inuse > 0; without this kmem_cache_destroy()
+	 * would see n->nr_slabs > 0, WARN, and leak the kmem_cache descriptor.
+	 */
+	for (pgoff = 0; pgoff < max; pgoff++) {
+		struct page *page = arena->slab_pages[pgoff];
+		struct slab *slab;
+
+		if (!page)
+			continue;
+		if (!PageSlab(page))
+			/*
+			 * Leftover bpf_arena_alloc() fallback page; freed by
+			 * existing_page_cb() in arena_map_free().
+			 */
+			continue;
+		slab = page_slab(page);
+		kmem_cache_force_discard_slab(slab->slab_cache, slab);
+	}
+
+	/* Let deferred page frees from the discard pass run before teardown. */
+	irq_work_sync(&arena->free_irq);
+	flush_work(&arena->free_work);
+
+	for (i = 0; i < ARENA_KMALLOC_NUM_BUCKETS; i++) {
+		if (!arena->kmalloc_caches[i])
+			continue;
+		kmem_cache_destroy(arena->kmalloc_caches[i]);
+		arena->kmalloc_caches[i] = NULL;
+	}
+}
+
 __bpf_kfunc_start_defs();
 
 __bpf_kfunc void *bpf_arena_alloc_pages(void *p__map, void *addr__ign, u32 page_cnt,
@@ -963,7 +1183,8 @@ __bpf_kfunc void *bpf_arena_alloc_pages(void *p__map, void *addr__ign, u32 page_
 	if (map->map_type != BPF_MAP_TYPE_ARENA || flags || !page_cnt)
 		return NULL;
 
-	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id, true);
+	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id,
+					 true, false, NULL);
 }
 
 void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 page_cnt,
@@ -975,7 +1196,8 @@ void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 pag
 	if (map->map_type != BPF_MAP_TYPE_ARENA || flags || !page_cnt)
 		return NULL;
 
-	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id, false);
+	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id,
+					 false, false, NULL);
 }
 
 void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32 page_cnt,
@@ -987,7 +1209,8 @@ void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32 page_cn
 	if (map->map_type != BPF_MAP_TYPE_ARENA || flags || !page_cnt)
 		return NULL;
 
-	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id, true);
+	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id,
+					 true, false, NULL);
 }
 
 __bpf_kfunc void bpf_arena_free_pages(void *p__map, void *ptr__ign, u32 page_cnt)
@@ -1023,12 +1246,139 @@ __bpf_kfunc int bpf_arena_reserve_pages(void *p__map, void *ptr__ign, u32 page_c
 
 	return arena_reserve_pages(arena, (long)ptr__ign, page_cnt);
 }
+
+/*
+ * bpf_arena_alloc: allocate one object of @size bytes from the arena's
+ * slab buckets. Returns a value whose low 32 bits are the arena offset;
+ * BPF programs use it as a void __arena *. Slub gives us a direct-map kva;
+ * its slab page carries the arena uaddr32 in slab->stride.
+ *
+ * For @size > PAGE_SIZE the slab buckets cannot satisfy the request and
+ * the allocation falls back to arena_alloc_pages(). The first page of
+ * such a multi-page allocation is stashed in arena->slab_pages[pgoff]
+ * (without PageSlab) with page_cnt in page->private, so bpf_arena_free()
+ * can find it again from the arena offset alone.
+ */
+__bpf_kfunc void *bpf_arena_alloc(void *p__map, u32 size)
+{
+	struct bpf_map *map = p__map;
+	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
+	struct kmem_cache *c;
+	struct slab *slab;
+	unsigned int idx;
+	void *kva;
+	u32 uaddr32;
+
+	if (map->map_type != BPF_MAP_TYPE_ARENA || !size)
+		return NULL;
+	if (size > (1U << ARENA_KMALLOC_MAX_SHIFT)) {
+		struct page *first_page;
+		long ret_user_va;
+		u32 page_cnt, pgoff;
+
+		page_cnt = round_up(size, PAGE_SIZE) >> PAGE_SHIFT;
+		if (!page_cnt)
+			return NULL;
+		/* sleepable=false mirrors kmem_cache_alloc_nolock() */
+		ret_user_va = arena_alloc_pages(arena, 0, page_cnt, NUMA_NO_NODE,
+						false, false, &first_page);
+		if (!ret_user_va)
+			return NULL;
+		pgoff = (u32)ret_user_va >> PAGE_SHIFT;
+		set_page_private(first_page, page_cnt);
+		WRITE_ONCE(arena->slab_pages[pgoff], first_page);
+		return (void *)ret_user_va;
+	}
+
+	idx = max_t(unsigned int, fls(size - 1), ARENA_KMALLOC_MIN_SHIFT);
+	if (idx >= ARENA_KMALLOC_NUM_BUCKETS)
+		return NULL;
+	c = arena->kmalloc_caches[idx];
+	if (!c)
+		return NULL;
+
+	/*
+	 * Use the nolock variant so this kfunc is safe from any context.
+	 * Skip __GFP_ACCOUNT because memcg charging already happens at
+	 * the arena page level.
+	 */
+	kva = kmem_cache_alloc_nolock(c, 0, NUMA_NO_NODE);
+	if (!kva)
+		return NULL;
+
+	slab = virt_to_slab(kva);
+	if (!slab || slab->slab_cache != c) {
+		bpf_prog_report_arena_violation(true, (long)kva, _RET_IP_);
+		return NULL;
+	}
+	uaddr32 = arena_slab_uaddr32(slab) |
+		  ((u32)(unsigned long)kva & ~PAGE_MASK);
+	return (void *)(clear_lo32(arena->user_vm_start) + uaddr32);
+}
+
+/*
+ * bpf_arena_free: free an object previously returned by bpf_arena_alloc.
+ * The arena offset's high bits identify the slab page; slab->slab_cache's
+ * bpf_arena hook confirms it belongs to this arena. The kva handed to
+ * kfree_nolock is direct-map, so its virt_to_slab works normally.
+ */
+__bpf_kfunc void bpf_arena_free(void *p__map, void *ptr__ign)
+{
+	struct bpf_map *map = p__map;
+	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
+	struct page *page;
+	struct slab *slab;
+	u32 arena_off, pgoff;
+	void *kva;
+
+	if (map->map_type != BPF_MAP_TYPE_ARENA || !ptr__ign)
+		return;
+
+	arena_off = (u32)(unsigned long)ptr__ign;
+	pgoff = arena_off >> PAGE_SHIFT;
+	if (pgoff >= arena->map.max_entries)
+		goto violation;
+	page = READ_ONCE(arena->slab_pages[pgoff]);
+	if (!page)
+		goto violation;
+	if (!PageSlab(page)) {
+		/*
+		 * Multi-page allocation from the bpf_arena_alloc() fallback.
+		 * page->private holds page_cnt stashed at allocation time.
+		 */
+		u32 page_cnt = page_private(page);
+
+		WRITE_ONCE(arena->slab_pages[pgoff], NULL);
+		set_page_private(page, 0);
+		arena_free_pages(arena, arena_off, page_cnt, false);
+		return;
+	}
+	slab = page_slab(page);
+	if (slab->slab_cache->bpf_arena != arena)
+		goto violation;
+	/*
+	 * Reject arena offsets that do not land on an object boundary. Arena
+	 * bucket caches have power-of-two s->size, so a simple IS_ALIGNED()
+	 * suffices; without this kfree_nolock() would set a freepointer inside
+	 * an unrelated object on the same slab page.
+	 */
+	if (!IS_ALIGNED(arena_off, slab->slab_cache->size))
+		goto violation;
+	kva = page_to_virt(page) + (arena_off & ~PAGE_MASK);
+	/* nolock free mirrors the nolock alloc — safe from any context. */
+	kfree_nolock(kva);
+	return;
+violation:
+	bpf_prog_report_arena_violation(true, arena_off, _RET_IP_);
+}
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(arena_kfuncs)
 BTF_ID_FLAGS(func, bpf_arena_alloc_pages, KF_ARENA_RET | KF_ARENA_ARG2)
 BTF_ID_FLAGS(func, bpf_arena_free_pages, KF_ARENA_ARG2)
 BTF_ID_FLAGS(func, bpf_arena_reserve_pages, KF_ARENA_ARG2)
+BTF_ID_FLAGS(func, bpf_arena_alloc, KF_ARENA_RET)
+BTF_ID_FLAGS(func, bpf_arena_free, KF_ARENA_ARG2)
 BTF_KFUNCS_END(arena_kfuncs)
 
 static const struct btf_kfunc_id_set common_kfunc_set = {
diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..2b0272c3f5fe 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -248,6 +248,9 @@ struct kmem_cache {
 	struct kmem_cache_stats __percpu *cpu_stats;
 #endif
 
+	/* NULL unless SLAB_BPF_ARENA; opaque arena pointer. */
+	void *bpf_arena;
+
 	struct kmem_cache_per_node_ptrs per_node[MAX_NUMNODES];
 };
 
@@ -414,7 +417,8 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
+			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE | \
+			 SLAB_BPF_ARENA)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8b661fff5eed..c9eb6daf649a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -49,7 +49,7 @@ struct kmem_cache *kmem_cache;
  */
 #define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
 		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
-		SLAB_OBJ_EXT_IN_OBJ)
+		SLAB_OBJ_EXT_IN_OBJ | SLAB_BPF_ARENA)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
diff --git a/mm/slub.c b/mm/slub.c
index 1daa89105e04..1a2e85605ab9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include "slab.h"
+#include <linux/bpf_defs.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -531,11 +532,25 @@ static inline void *get_freepointer(struct kmem_cache *s, void *object)
 {
 	unsigned long ptr_addr;
 	freeptr_t p;
+	void *decoded;
 
 	object = kasan_reset_tag(object);
 	ptr_addr = (unsigned long)object + s->offset;
 	p = *(freeptr_t *)(ptr_addr);
-	return freelist_ptr_decode(s, p, ptr_addr);
+	decoded = freelist_ptr_decode(s, p, ptr_addr);
+	/*
+	 * SLAB_BPF_ARENA freepointer slots are BPF-writable. Clamp the decoded
+	 * pointer to an s->size-aligned address within the same slab page so
+	 * chain walks stay on legitimate object boundaries. Arena slabs are
+	 * always one page (order 0). NULL preserved.
+	 */
+	if (unlikely(s->bpf_arena) && decoded) {
+		unsigned long obj_mask = s->size - 1;
+
+		decoded = (void *)(((unsigned long)object & PAGE_MASK) |
+				   ((unsigned long)decoded & ~PAGE_MASK & ~obj_mask));
+	}
+	return decoded;
 }
 
 static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
@@ -543,7 +558,12 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 	unsigned long freeptr_addr = (unsigned long)object + s->offset;
 
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
-	BUG_ON(object == fp); /* naive detection of double free or corruption */
+	if (unlikely(object == fp)) {
+		/* BPF double-free of arena objects must not panic the kernel. */
+		if (s->bpf_arena)
+			return;
+		BUG_ON(object == fp); /* naive detection of double free or corruption */
+	}
 #endif
 
 	freeptr_addr = (unsigned long)kasan_reset_tag((void *)freeptr_addr);
@@ -3270,6 +3290,9 @@ static inline struct slab *alloc_slab_page(struct kmem_cache *s, gfp_t flags,
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
+	if (unlikely(s->bpf_arena))
+		return bpf_arena_alloc_slab_page(s->bpf_arena, flags, node, allow_spin);
+
 	if (unlikely(!allow_spin))
 		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
 								  node, order);
@@ -3493,9 +3516,11 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	init_slab_obj_exts(slab);
 	/*
 	 * Poison the slab before initializing the slabobj_ext array
-	 * to prevent the array from being overwritten.
+	 * to prevent the array from being overwritten. Arena caches
+	 * stash uaddr32 in slab->stride; let them keep it.
 	 */
-	alloc_slab_obj_exts_early(s, slab);
+	if (!(s->flags & SLAB_BPF_ARENA))
+		alloc_slab_obj_exts_early(s, slab);
 	account_slab(slab, oo_order(oo), s, flags);
 
 	shuffle = shuffle_freelist(s, slab, allow_spin);
@@ -3538,6 +3563,10 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin
 	__ClearPageSlab(page);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s, allow_spin);
+	if (unlikely(s->bpf_arena)) {
+		bpf_arena_free_slab_page(s->bpf_arena, slab);
+		return;
+	}
 	if (allow_spin)
 		free_frozen_pages(page, order);
 	else
@@ -5442,6 +5471,32 @@ void *kmem_cache_alloc_nolock_noprof(struct kmem_cache *s, gfp_t gfp_flags,
 }
 EXPORT_SYMBOL_GPL(kmem_cache_alloc_nolock_noprof);
 
+/**
+ * kmem_cache_force_discard_slab - force-evict a slab page from its cache
+ * @s: kmem_cache that owns the slab
+ * @slab: the slab to evict
+ *
+ * Removes @slab from any per-node list it may be on and then discards it
+ * (decrements nr_slabs and frees the backing page). Intended for arena
+ * teardown: arena owns the page-tracking array and can enumerate every
+ * slab page it allocated, including orphans not on any partial list (left
+ * behind by spin_trylock failures in __slab_free()) and slabs whose
+ * objects were never returned (BPF program leak).
+ */
+void kmem_cache_force_discard_slab(struct kmem_cache *s, struct slab *slab)
+{
+	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
+	unsigned long flags;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	if (slab_test_node_partial(slab))
+		remove_partial(n, slab);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	discard_slab(s, slab);
+}
+EXPORT_SYMBOL_GPL(kmem_cache_force_discard_slab);
+
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
 					 int node, unsigned long caller)
 {
@@ -5589,14 +5644,19 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 
 			n = get_node(s, slab_nid(slab));
 			/*
-			 * Speculatively acquire the list_lock.
-			 * If the cmpxchg does not succeed then we may
-			 * drop the list_lock without any processing.
+			 * Speculatively acquire the list_lock. If the cmpxchg
+			 * does not succeed we drop the lock without processing.
 			 *
-			 * Otherwise the list_lock will synchronize with
-			 * other processors updating the list of slabs.
+			 * Arena caches may reach here from kfree_nolock() in
+			 * NMI/irq-off context; trylock and orphan the slab on
+			 * failure. A later allow_spin caller adopts it.
 			 */
-			spin_lock_irqsave(&n->list_lock, flags);
+			if (unlikely(s->bpf_arena)) {
+				if (!spin_trylock_irqsave(&n->list_lock, flags))
+					n = NULL;
+			} else {
+				spin_lock_irqsave(&n->list_lock, flags);
+			}
 
 			on_node_partial = slab_test_node_partial(slab);
 		}
@@ -6666,6 +6726,15 @@ void kfree_nolock(const void *object)
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
 		return;
 
+	/*
+	 * Arena freepointer slots are BPF-writable; defer_free()'s in-object
+	 * llist chain could be redirected. Route through __slab_free() instead;
+	 * it trylocks n->list_lock and orphans the slab on failure.
+	 */
+	if (s->bpf_arena) {
+		__slab_free(s, slab, x, x, 1, _RET_IP_);
+		return;
+	}
 	/*
 	 * __slab_free() can locklessly cmpxchg16 into a slab, but then it might
 	 * need to take spin_lock for further processing.
@@ -7181,16 +7250,22 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 		/*
 		 * Freelist had more objects than we can accommodate, we need to
 		 * free them back. We can treat it like a detached freelist, just
-		 * need to find the tail object.
+		 * need to find the tail object. Bound the walk by slab->objects
+		 * so a corrupted in-object freepointer (e.g. BPF arena cache
+		 * where the slot is writable from BPF) cannot loop forever; a
+		 * legitimate freelist on this slab has at most that many nodes.
 		 */
 		if (unlikely(object)) {
 			void *head = object;
 			void *tail;
-			int cnt = 0;
+			unsigned int cnt = 0;
+			unsigned int limit = slab->objects;
 
 			do {
 				tail = object;
 				cnt++;
+				if (unlikely(cnt >= limit))
+					break;
 				object = get_freepointer(s, object);
 			} while (object);
 			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
@@ -7763,12 +7838,21 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 		return 0;
 
 	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+	 * Bootstrap caches (kmem_cache, kmem_cache_node) carry SLAB_NO_OBJ_EXT
+	 * and are created before kmalloc is available, so sheaf/barn setup
+	 * can't run yet.
+	 *
 	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
 	 * have sheaves to avoid recursion when sheaf allocation triggers
 	 * kmemleak tracking.
+	 *
+	 * SLAB_BPF_ARENA caches also set SLAB_NO_OBJ_EXT to suppress per-object
+	 * extensions, but they are created at runtime and want sheaves like any
+	 * other cache, so exempt them.
 	 */
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+	if (s->flags & SLAB_NOLEAKTRACE)
+		return 0;
+	if ((s->flags & SLAB_NO_OBJ_EXT) && !(s->flags & SLAB_BPF_ARENA))
 		return 0;
 
 	/*
@@ -8607,6 +8691,27 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	s->useroffset = args->useroffset;
 	s->usersize = args->usersize;
 #endif
+	if (s->flags & SLAB_BPF_ARENA) {
+		if (!args->bpf_arena)
+			goto out;
+		/*
+		 * Strip every SLAB_DEBUG_FLAGS bit from arena caches.
+		 * Masking (rather than goto out) keeps arena maps creatable
+		 * under slub_debug=... cmdline.
+		 */
+		s->flags &= ~SLAB_DEBUG_FLAGS;
+		/* Non-debug knobs we cannot honor: refuse the cache. */
+		if (s->flags & (SLAB_KASAN | SLAB_TYPESAFE_BY_RCU | SLAB_ACCOUNT))
+			goto out;
+		/*
+		 * Suppress per-object obj_exts for arena caches: accounting
+		 * already happens at arena-page granularity (bpf_map_memcg_enter
+		 * in arena_alloc_pages), and per-slab obj_exts would cost
+		 * sizeof(slabobj_ext) * objs_per_slab of overhead per page.
+		 */
+		s->flags |= SLAB_NO_OBJ_EXT;
+		s->bpf_arena = args->bpf_arena;
+	}
 
 	if (!calculate_sizes(args, s))
 		goto out;
@@ -8623,6 +8728,17 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 		}
 	}
 
+	if (s->flags & SLAB_BPF_ARENA) {
+		/*
+		 * Arena page source currently allocates one page at a time;
+		 * force order 0 and pin s->min to s->oo so allocate_slab() has
+		 * no fallback path and get_freepointer()'s slab-mask sanitize
+		 * (oo_order(s->oo)) always matches the actual slab order.
+		 */
+		s->oo = oo_make(0, s->size);
+		s->min = s->oo;
+	}
+
 #ifdef system_has_freelist_aba
 	if (system_has_freelist_aba() && !(s->flags & SLAB_NO_CMPXCHG)) {
 		/* Enable fast mode */
@@ -9628,6 +9744,17 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	struct kset *kset = cache_kset(s);
 	int unmergeable = slab_unmergeable(s);
 
+	/*
+	 * Hide arena caches from /sys/kernel/slab: shrink/validate/etc would
+	 * BUG_ON on BPF-induced inuse underflow or corrupted freelists.
+	 * kobject_init() (no kobject_add()) keeps the destroy-time
+	 * kobject_put() -> slab_kmem_cache_release() path working.
+	 */
+	if (s->bpf_arena) {
+		kobject_init(&s->kobj, &slab_ktype);
+		return 0;
+	}
+
 	if (!unmergeable && disable_higher_order_debug &&
 			(slub_debug & DEBUG_METADATA_FLAGS))
 		unmergeable = 1;
-- 
2.53.0-Meta


