Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBDEEDF154
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 11:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D7D6B0089; Fri, 13 Feb 2026 06:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7766B008A; Fri, 13 Feb 2026 06:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721466B008C; Fri, 13 Feb 2026 06:57:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1AB6B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:57:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F14151404C3
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:57:54 +0000 (UTC)
X-FDA: 84439284468.15.F8D5D22
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92DBB1A000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:57:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/Mt+SCO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2kiSsHYC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgToGAir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vdFk5YxQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770983872; a=rsa-sha256;
	cv=none;
	b=ZAKl8V8HrevT1QId7QrRZ5s04bgxf5AqrqpG3zrQWkttiz7Corg8mhSPFO5mjibcjX7ODK
	P/0vRrGdF22Ijnmg4uL5S6KxLOiZWhK4UyQN0LGFoA33K8/ITrQivimRYj1E6bMfAdY4kw
	FMcJNi4d53Y2GiAdtv4g3SZEY94NFAE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/Mt+SCO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2kiSsHYC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgToGAir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vdFk5YxQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770983872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GampDPnGWIaChU0udZ1qo56iYJM/N4DhLcbf1/WI91Q=;
	b=OHt5VOodn0NDNFEpxKYOj3o5iqk8V+oGWhJuttJTT1+UUbF3nDOzbWcUJLzOWDFMStjtdj
	aIgaElStv04fvNo2UbUCpmrympuZCSwz71NYt2VWWSBEl9zjPIeYljX0XVz4X7lEHhZPZN
	jcq5xQDJAWztoZixF4SEHREQsWUNQEE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6B693E6DD;
	Fri, 13 Feb 2026 11:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770983864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=GampDPnGWIaChU0udZ1qo56iYJM/N4DhLcbf1/WI91Q=;
	b=v/Mt+SCOzTk848StB4AYtJAJ8PYYbgl3y/BCo8R1rx3EMc+nTfySl2iJnNWtGnN5z2l4bl
	BdXJf80OZcDFfgRn77jTrSR/xqae8NUNfG7zOJkQ7lLPzzevIo7OerRmS9eaLdsU+/A+mA
	dUJoIuQaxqxGP+DSPqJyPQN8fzJ9bj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770983864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=GampDPnGWIaChU0udZ1qo56iYJM/N4DhLcbf1/WI91Q=;
	b=2kiSsHYC/TENmCMDxfU3cZWO+cIwDCUQZ2tJE1giM3HNElNBVPKMiwhfLehh32GfcZ5zMU
	6qnFW3AuCG2PX2CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770983863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=GampDPnGWIaChU0udZ1qo56iYJM/N4DhLcbf1/WI91Q=;
	b=zgToGAirWw8OUfDccOLgiYrXqqRxehtWlHG7GeZlx45ucycnSkY90YUCYsEMF6bOhWDvyC
	QusNbmVLEyt9dN7LFapbuBk3YrmlAUttsRUXCM8HsskssrSXIQaNTyNTsfBtV/Uq8lqYnz
	5N8uWQFbHCIFr1lJek0IAkpF9mzoq3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770983863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=GampDPnGWIaChU0udZ1qo56iYJM/N4DhLcbf1/WI91Q=;
	b=vdFk5YxQLcZr/VEb3ELYZF3FKDrW9E+2JiBqn2qGmHqunadlm912fk8bJP9P5jkfjLrMfz
	+/0rQXxlyYwCfCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADDA23EA62;
	Fri, 13 Feb 2026 11:57:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hz+oKbcRj2kxFwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 13 Feb 2026 11:57:43 +0000
Message-ID: <2b68dc0e-91d0-40b1-8313-63ee0c827ce2@suse.cz>
Date: Fri, 13 Feb 2026 12:57:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
Subject: [RFC] making nested spin_trylock() work on UP?
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Waiman Long <longman@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
 Matthew Wilcox <willy@infradead.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92DBB1A000B
X-Stat-Signature: nduueeeme4rso8zfkpkiea4w4ypm7fp8
X-HE-Tag: 1770983872-119390
X-HE-Meta: U2FsdGVkX1+hxybSfU0Zd3Cw8+TpxasRqt3scnUra1qiOGgC8g2tOzwuTSnrOOPG5yi2ryXJjBHjjfg6hAJZIgGmcVTaVb7ofVpNmcD8zyEbWyVTtzNe2TXQAiJ732Kvp/G970ccuu88D/ZPbAat2jZXwntPFKW18+HpjA5Z2kn7hxvZWtR0kTS0NAj0lTkq7CTfI/HbvmGZEKe9gwRUfT9YPq2wLP0+qfW/elLhc7O9lx6GvDns7nPIxqBLz5XDRm5rlvCtVhZejRj9mNfX7t1dP3ru8CTTTDLdtpMWPYNqIwHgrWvbg/9K3Pdi52L8GtGAvC1CxZacG+YhBX0Magz7oh2cRS8//aSMUv0VnbbLHvupyOLIwqfbU4FzPE2CQhkP0iDZhY06CQdf+RB1WAIJhhGy8CIm45lXjaeIcTQBsUhuLPe6FGGgApTHAn6zvKSECkOZCSZnTyMB/IWwWt3oR+WS/ne5RCjnqdaJOLRkhN5Whhj3suCriMtdptcPEggvQZfD3oChBko9rVG+VbWebIENbyn13tm4aHnGS8uYefPxqwNuvQEp2aIAf5+fbnn6zNrvVo1Hbtr3DnoIV/p2MxWMf608pP7+41gGdu0ME2s0klyIyZsEZs3X8cizlulCEBt0I22hekrprdE0no1F7cjUsiubK9AOLQGqSeP8M2ZsN3WUluj++cPTw0o/FTfHY8Kyoy2KrroOyvetNkXlZZJksXpaC1x6yyPM1YsuLkeHmhX6DXw9ivTqVxQzFOAwDiw+/bNkGTCcvW5HaWI/ZxcoPvVHPUv2IVCgLpPD8z6PbmyePFjFtyKVGaIzgyi8FLPixyG6qPErfpa72gbQC4SztmNv/Ps9Ew++NiThy6E160F9uOjJX3lVsA8auZ5iWSQNOF5SDRiAEdiBgZuPTkL1Nq2HkCxd1u11YUPt7CffpP7i0IdOe8n3w5to/mvbabjW74cVqOq6/zg
 1lcBXVWq
 KFKc9o3lmvoh+0/IKFiihzWSPWJFwaXSyigcbDnykWYrA14ArkOXVDgnQkjpWWuZ+80D0gpIvAsnwnqEk0GrdbdQ6HvPcCAFxQAPSTf5wspxEgPIpEgvu+LA2G5iQdvC25Z50T+QsNPFWVULwISFe/10BioLp+YTCTdz8A2MMGOwTqY/NJmQjIKBcGJU0uQSjmfkZzv1Htcxv2cnVWDcIWCQ/Y7q1eAp+UgIQ5AQW5UKLjD3csyruTk2cX/US8iI7J5kmZkDEobP/qGR3lki0IHtvEa+ollUnoOPGwfKkKDkrVRlEEQr0Vy7CT5kjAot9iQfDH0uN15aOUI2jBExvNN1m1OHeDoq8BPe1CPpiaogdObclGUV91slWH5Y2q+Sr0ANhrGok0nwNrrc8gbVRl7gN7kAAGe+GiRRg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

this is not a real RFC PATCH, but more like discussion about possible
direction. I wanted to have a patch at hand, but the layers of spinlock APIs
are rather complex for me to untangle, so I'd rather know first if it's even
worth trying.

The page allocator has been using a locking scheme for its percpu page
caches (pcp) for years now, based on spin_trylock() with no _irqsave() part.
The point is that if we interrupt the locked section, we fail the trylock
and just fallback to something that's more expensive, but it's rare so we
don't need to pay the irqsave cost all the time in the fastpaths.

It's similar to but not exactly local_trylock_t (which is also newer anyway)
because in some cases we do lock the pcp of a non-local cpu to flush it, in
a way that's cheaper than IPI or queue_work_on().

The complication of this scheme has been UP non-debug spinlock
implementation which assumes spin_trylock() can't fail on UP and has no
state to track it. It just doesn't anticipate this usage scenario. So to
work around that we disable IRQs on UP, complicating the implementation.
Also recently we found years old bug in the implementation - see
038a102535eb ("mm/page_alloc: prevent pcp corruption with SMP=n").

So my question is if we could have spinlock implementation supporting this
nested spin_trylock() usage, or if the UP optimization is still considered
too important to lose it. I was thinking:

- remove the UP implementation completely - would it increase the overhead
on SMP=n systems too much and do we still care?

- make the non-debug implementation a bit like the debug one so we do have
the 'locked' state (see include/linux/spinlock_up.h and lock->slock). This
also adds some overhead but not as much as the full SMP implementation?

Below is how this would simplify page_alloc.c.

Thanks,
Vlastimil

From 7a0f233ec0ae46324b2db6a09944e93c7cb14459 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 13 Feb 2026 12:51:02 +0100
Subject: [PATCH] mm/page_alloc: simplify as if UP spin_trylock() was reliable

---
 mm/page_alloc.c | 111 +++++++++++++-----------------------------------
 1 file changed, 30 insertions(+), 81 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d312ebaa1e77..f147126b6c06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -95,23 +95,6 @@ typedef int __bitwise fpi_t;
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-/*
- * On SMP, spin_trylock is sufficient protection.
- * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
- * Pass flags to a no-op inline function to typecheck and silence the unused
- * variable warning.
- */
-static inline void __pcp_trylock_noop(unsigned long *flags) { }
-#define pcp_trylock_prepare(flags)	__pcp_trylock_noop(&(flags))
-#define pcp_trylock_finish(flags)	__pcp_trylock_noop(&(flags))
-#else
-
-/* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
-#define pcp_trylock_prepare(flags)	local_irq_save(flags)
-#define pcp_trylock_finish(flags)	local_irq_restore(flags)
-#endif
-
 /*
  * Locking a pcp requires a PCP lookup followed by a spinlock. To avoid
  * a migration causing the wrong PCP to be locked and remote memory being
@@ -151,48 +134,22 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
 })
 
 /* struct per_cpu_pages specific helpers. */
-#define pcp_spin_trylock(ptr, UP_flags)					\
+#define pcp_spin_trylock(ptr)						\
 ({									\
 	struct per_cpu_pages *__ret;					\
-	pcp_trylock_prepare(UP_flags);					\
 	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
-	if (!__ret)							\
-		pcp_trylock_finish(UP_flags);				\
 	__ret;								\
 })
 
-#define pcp_spin_unlock(ptr, UP_flags)					\
+#define pcp_spin_unlock(ptr)						\
 ({									\
 	pcpu_spin_unlock(lock, ptr);					\
-	pcp_trylock_finish(UP_flags);					\
 })
 
-/*
- * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
- * a potentially remote cpu drain) and get interrupted by an operation that
- * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
- * spinlock assumptions making the trylock a no-op. So we have to turn that
- * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
- * remote cpu's so we can only be locking the only existing local one.
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-static inline void __flags_noop(unsigned long *flags) { }
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-({							\
-	 __flags_noop(&(flags));			\
-	 spin_lock(&(ptr)->lock);			\
-})
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-({							\
-	 spin_unlock(&(ptr)->lock);			\
-	 __flags_noop(&(flags));			\
-})
-#else
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-		spin_lock_irqsave(&(ptr)->lock, flags)
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-		spin_unlock_irqrestore(&(ptr)->lock, flags)
-#endif
+#define pcp_spin_lock_nopin(ptr)			\
+		spin_lock(&(ptr)->lock)
+#define pcp_spin_unlock_nopin(ptr)			\
+		spin_unlock(&(ptr)->lock)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2583,7 +2540,6 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
-	unsigned long UP_flags;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2603,9 +2559,9 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2622,15 +2578,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	unsigned long UP_flags;
 	int to_drain, batch;
 
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	}
 }
 #endif
@@ -2641,11 +2596,10 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	unsigned long UP_flags;
 	int count;
 
 	do {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2654,7 +2608,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	} while (count);
 }
 
@@ -2853,7 +2807,7 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
  */
 static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
+		unsigned int order, fpi_t fpi_flags)
 {
 	int high, batch;
 	int to_free, to_free_batched;
@@ -2913,9 +2867,9 @@ static bool free_frozen_page_commit(struct zone *zone,
 		if (to_free == 0 || pcp->count == 0)
 			break;
 
-		pcp_spin_unlock(pcp, *UP_flags);
+		pcp_spin_unlock(pcp);
 
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 		if (!pcp) {
 			ret = false;
 			break;
@@ -2927,7 +2881,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * returned in an unlocked state.
 		 */
 		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp, *UP_flags);
+			pcp_spin_unlock(pcp);
 			ret = false;
 			break;
 		}
@@ -2959,7 +2913,6 @@ static bool free_frozen_page_commit(struct zone *zone,
 static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
-	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
@@ -2995,12 +2948,12 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
-						order, fpi_flags, &UP_flags))
+						order, fpi_flags))
 			return;
-		pcp_spin_unlock(pcp, UP_flags);
+		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
@@ -3021,7 +2974,6 @@ void free_frozen_pages_nolock(struct page *page, unsigned int order)
  */
 void free_unref_folios(struct folio_batch *folios)
 {
-	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int i, j;
@@ -3064,7 +3016,7 @@ void free_unref_folios(struct folio_batch *folios)
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
-				pcp_spin_unlock(pcp, UP_flags);
+				pcp_spin_unlock(pcp);
 				locked_zone = NULL;
 				pcp = NULL;
 			}
@@ -3083,7 +3035,7 @@ void free_unref_folios(struct folio_batch *folios)
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 			if (unlikely(!pcp)) {
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
@@ -3101,14 +3053,14 @@ void free_unref_folios(struct folio_batch *folios)
 
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE, &UP_flags)) {
+				migratetype, order, FPI_NONE)) {
 			pcp = NULL;
 			locked_zone = NULL;
 		}
 	}
 
 	if (pcp)
-		pcp_spin_unlock(pcp, UP_flags);
+		pcp_spin_unlock(pcp);
 	folio_batch_reinit(folios);
 }
 
@@ -3359,10 +3311,9 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long UP_flags;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		return NULL;
 
@@ -3374,7 +3325,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp, UP_flags);
+	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5062,7 +5013,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5156,7 +5106,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		goto failed;
 
@@ -5175,7 +5125,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock(pcp, UP_flags);
+				pcp_spin_unlock(pcp);
 				goto failed;
 			}
 			break;
@@ -5187,7 +5137,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		page_array[nr_populated++] = page;
 	}
 
-	pcp_spin_unlock(pcp, UP_flags);
+	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
@@ -6144,7 +6094,6 @@ static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 {
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
-	unsigned long UP_flags;
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	cci = get_cpu_cacheinfo(cpu);
@@ -6155,12 +6104,12 @@ static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+	pcp_spin_lock_nopin(pcp);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+	pcp_spin_unlock_nopin(pcp);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)
-- 
2.53.0



