Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D325CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62568E0013; Mon,  8 Sep 2025 21:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19798E0002; Mon,  8 Sep 2025 21:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01D88E0013; Mon,  8 Sep 2025 21:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC0188E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C2A81A037D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:23 +0000 (UTC)
X-FDA: 83867905926.11.7330381
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC81940008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W9KKdp/X";
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIvN7gEFDj+MX9N79cOcDUYPJnyqb9DQof2cQsOTIWw=;
	b=Mik9jf43KknvB64L7MsVgtAjhgK55QvR4H7p6cZd67W/lBFSEa3T8oILUTLQQZil1ixlrE
	rh60m9B732sYcnu58brQK35fm9WH/KRKSoXjiZPzI/7u01VsanJMiXACCzfCeo49s/7W76
	9yE7AL8gY/MJapVyQL7trr4oiXSJuzU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W9KKdp/X";
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379621; a=rsa-sha256;
	cv=none;
	b=DGbkGNaIp2+DK1szTqGZEcjmGhcLjNe9ozBoTgSa6PH09rIjfFaO71QI2ZPpbFb/57/gsd
	NhnJqaXNIawUfG8dS2yJ5lyylNZ1J/+yPS07kwJmmkyWz7xhoErKrlg7aMBMdSXoUUMIwt
	WhHuY6ri7D9VeukIMgYbdr11fuGwScU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77287fb79d3so4057655b3a.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379621; x=1757984421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIvN7gEFDj+MX9N79cOcDUYPJnyqb9DQof2cQsOTIWw=;
        b=W9KKdp/X+qUjmO11y008L0c5uZu6deDyB0a0S8G8k9AvkUg5k5IDe2U3xX1xRbmVRi
         2sQzUSP7Z0lXEREGd7PqmTHRj0aEKHmuoTktOg0ESAXybEYXhZ/mu8dBvA5R4Z/U4Wd8
         rBZfXIq3Z0TYp2wjqDpSaDT/EZu5ZL0ZXoJcYmaITSLAFs1ZW/DfAvWzv3ASHDS2aH42
         7OessCQIpgnugM7eKQi+gwV61+AYC7wJx2of+2D9u3+/2dN+NJX9RuJv31mdn7SHmiLd
         LyJO6VMaq64s1ICcCglwTzxLMBeMpTa7+Q/JdRPS1GizSyGpNq26JeR0c3dBpu605nVH
         f1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379621; x=1757984421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIvN7gEFDj+MX9N79cOcDUYPJnyqb9DQof2cQsOTIWw=;
        b=TVKxf5CwXUFLrx03sovxdmUpSm25BE59GXFjCeH6QhvbS7HLv9b+4uZWCcpqvjYyjr
         TdTGD4gxdUyXTRxvw26VrwHCTgmATDT73JCmN/S1lSPtiDLfB74Na1TxhLiiz0/FTuP3
         eZ8eR1Gv/zYY5W4KGmGTNUCY0x+dCLxW7SLDMPngadI7WK9ckUX46xbH4R4BzOuj0EKp
         rEj7qE0ggfLDfCLU/AJfAcLKezQ6bdqR6r0DPKBHNP+3aA1aC+XT/6S0sicUkh3YBbsp
         JNr0P/YJjo+ej0eMZsEEjTY+wjJ8d46BP1fbzFCAboguDZKVwrI99mWWbfD4vHV/KH92
         aFRA==
X-Forwarded-Encrypted: i=1; AJvYcCVk/s9Du+zXD3Pvgx2lEoyfybdPKqlINodk1cpUAhvw6YGmTPD63lSS63I7ci2BZ/fD9ah73dZQhw==@kvack.org
X-Gm-Message-State: AOJu0YwWqczYRvxgDlKiXZoIIvHag2+w1jie+48AV4xIErgHiZWhz7Qc
	pdibEdD4uyDcF0E0s+adjpvVNeHIGMqYwWTPaoN2UcH4jhCiWny3Ir8q
X-Gm-Gg: ASbGncu4Peafwv1dfd+tIRuKo4/461KSRQKMizFUky5IvNN/Qw9cjdzAGXN5gM5+ecB
	bcNpF4kSXQxlgS/fGEMpmuUP13UNz2b0wPJnTtcX5NqwETh290Qz6Y5hrvi6VSmxtQ63+z/qHC+
	bl1xGsE4/DRdxgEd47d6Sqlf5V7SoO/SkWgBKzYH1M4FMBXBhi3iQp2/tAmeHxMbfdKeofKvgvc
	+HBDztHgxvjPnzCxjzxkxJc3NLTfZaWFubdWVyFtQrVcDEhbtZfBZPugKpKuUUEJ5uKh/kaejpt
	1SCTAe+gd/nchW/ue6O5GbhzWmOk8e5mB76rXukO5poni19Vypz944KIzZRjSHEp9W6RuVtTZOS
	IU4BBE0F6k4jl9Vg6pP6AvzL1fSFPmyOR4NiX1SIblgaHw0EiiO/ES9OelnROYjo=
X-Google-Smtp-Source: AGHT+IFZUeoe6fBkWDULTMp8LjubHq1BmCo/G40/7pgpBHQ8AvM+nhqTLUrWBmOTwtVm5kzmDZuCtw==
X-Received: by 2002:a05:6a20:939e:b0:24e:e270:2f51 with SMTP id adf61e73a8af0-2533d225f82mr12211294637.16.1757379620658;
        Mon, 08 Sep 2025 18:00:20 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4f9c35f391sm15955890a12.25.2025.09.08.18.00.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:20 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 4/6] slab: Make slub local_(try)lock more precise for LOCKDEP
Date: Mon,  8 Sep 2025 18:00:05 -0700
Message-Id: <20250909010007.1660-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC81940008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 861gx4qix91gn4ryqkk3q7ck7jryyczq
X-HE-Tag: 1757379621-280442
X-HE-Meta: U2FsdGVkX1+hqfeyszt9XDqmKqtFCNvse7P81kfBNWhS0D53onPbuL8AD22PBEDUhFS1qBBqWWQlckH+VG/M7moNivXast8wR0aKMGaZ8oZWOYnzAEeSeSMldaYL1YCSMPPDRMw8qf5QF71kEjquaSUCwMqjmCzF5GKIHWXPTx73tnle+7N7pEW3QsUhGhT2jCRHcgPTw1D+mOAxizBKwfFhM/YuMagY4CxCri60zFGVelV6WIg0ia3G1Q/pqE5nsy/1k0QIPri3JDTh8Am6b/nebNxWldOlwX1ds+Rpd5YXsMnjEi+a3H5UkVnCNOUyEi5o0JLL/rVMDkRu7qdNnfsfjdzW6jchqqkyLnv/yWAkV81wdorQfR6SUO1xuQX3DFc7DQgp42Kkx8eaFtf+gkuogha1SdC4xVIYwgNz6HVSoEQb/2P5Xg8rqNbVKzwx9YGK6t6V8Ny1xxylG2HTn+DVSJqg5GEk03CrS4+8CGP+X8XNrROgkhc8YDF4jNSizk+V5C8DDDjHgDUV2UE0uGTZ0CBCYouddFAwU1gl+IazEnvdqlOYzcEaHl8xTTSsTDBcvZY4qBfC1IFGIon09ABGdlsEPBonn3QnMNVmNNcUt0aTHpf+0kH8pRcr8NB/Ey3kDR6JT+3fyraaVzg3TfiyxVkVXWv2twwg14G+BbI/c+93Vhr8CPoDM6WLmbqRXw7yaDJKRwGXo154RCfatUmcTsKxoHlbvZ35zul/gsLQ5YTN2sRL1quBV2hDgtDQxFL1s0wh3ln30jnBR6bNkRoX45xoSGR7YyMMUidet0iH8C92loexvGvU/yJgKrDmaseu97+k7b67ef8QYbrmSkSE1mqYMFWkRtPD7ABNY0jjO+vY3sdcCbYtkWjcxVQBvLRXiSKS1AhaQf3F2+lJ5P/9/4Y5rQWgVKz4hjIDFPbMWF3c6tuAlYxCS3b7mm9B0eObRl04DmXX4/f7/6x
 jgEogEzS
 pTXsnOscHDsJ6PViaNzykY6TbKAChAG7lUWCC5ZgVXOofdI5+JSeRNBjfuaaBGiCUymrNG6TRPxWNeQNOSpWJ5HjXANdCapDgzi6uy2s8qLGlUnDfAWx5CpClqCsy6ZBtfY6/FgzLVCuvxl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

kmalloc_nolock() can be called from any context
the ___slab_alloc() can acquire local_trylock_t (which is rt_spin_lock
in PREEMPT_RT) and attempt to acquire a different local_trylock_t
while in the same task context.

The calling sequence might look like:
kmalloc() -> tracepoint -> bpf -> kmalloc_nolock()

or more precisely:
__lock_acquire+0x12ad/0x2590
lock_acquire+0x133/0x2d0
rt_spin_lock+0x6f/0x250
___slab_alloc+0xb7/0xec0
kmalloc_nolock_noprof+0x15a/0x430
my_debug_callback+0x20e/0x390 [testmod]
___slab_alloc+0x256/0xec0
__kmalloc_cache_noprof+0xd6/0x3b0

Make LOCKDEP understand that local_trylock_t-s protect
different kmem_caches. In order to do that add lock_class_key
for each kmem_cache and use that key in local_trylock_t.

This stack trace is possible on both PREEMPT_RT and !PREEMPT_RT,
but teach lockdep about it only for PREEMPT_RT, since
in !PREEMPT_RT the ___slab_alloc() code is using
local_trylock_irqsave() when lockdep is on.

Note, this patch applies this logic to local_lock_t
while the next one converts it to local_trylock_t.
Both are mapped to rt_spin_lock in PREEMPT_RT.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/slab.h |  1 +
 mm/slub.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index f1866f2d9b21..5a6f824a282d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -234,6 +234,7 @@ struct kmem_cache_order_objects {
 struct kmem_cache {
 #ifndef CONFIG_SLUB_TINY
 	struct kmem_cache_cpu __percpu *cpu_slab;
+	struct lock_class_key lock_key;
 #endif
 	struct slub_percpu_sheaves __percpu *cpu_sheaves;
 	/* Used for retrieving partial slabs, etc. */
diff --git a/mm/slub.c b/mm/slub.c
index bf399ba65a4b..212161dc0f29 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3591,12 +3591,29 @@ static inline void note_cmpxchg_failure(const char *n,
 
 static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
+#ifdef CONFIG_PREEMPT_RT
+	/*
+	 * Register lockdep key for non-boot kmem caches to avoid
+	 * WARN_ON_ONCE(static_obj(key))) in lockdep_register_key()
+	 */
+	bool finegrain_lockdep = !init_section_contains(s, 1);
+#else
+	/*
+	 * Don't bother with different lockdep classes for each
+	 * kmem_cache, since we only use local_trylock_irqsave().
+	 */
+	bool finegrain_lockdep = false;
+#endif
 	int cpu;
 	struct kmem_cache_cpu *c;
 
+	if (finegrain_lockdep)
+		lockdep_register_key(&s->lock_key);
 	for_each_possible_cpu(cpu) {
 		c = per_cpu_ptr(s->cpu_slab, cpu);
 		local_lock_init(&c->lock);
+		if (finegrain_lockdep)
+			lockdep_set_class(&c->lock, &s->lock_key);
 		c->tid = init_tid(cpu);
 	}
 }
@@ -7142,6 +7159,9 @@ void __kmem_cache_release(struct kmem_cache *s)
 	if (s->cpu_sheaves)
 		pcs_destroy(s);
 #ifndef CONFIG_SLUB_TINY
+#ifdef CONFIG_PREEMPT_RT
+	lockdep_unregister_key(&s->lock_key);
+#endif
 	free_percpu(s->cpu_slab);
 #endif
 	free_kmem_cache_nodes(s);
-- 
2.47.3


