Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C12D3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5B76B0416; Fri, 23 Jan 2026 01:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC46F6B0418; Fri, 23 Jan 2026 01:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE206B0419; Fri, 23 Jan 2026 01:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0C26B0416
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:54:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A81AC0232
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:09 +0000 (UTC)
X-FDA: 84362314218.15.E85C170
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D0FF20006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7Imrx2RQafs2CP6MR8fcwa6W5Q5qaE5LnHmXENECaQ=;
	b=ZcgloNnXMByf6Hp4a5wySwy/o10LWg67EYHZEmvx7l329DOzbsBd3AyVnblcCPqcMEqLxf
	7RfyorjTO9BJTED0Ndq69PIa6HFdMrx59I5Uvqj9bNUorU0pHphhTi834opz8B7u2cGeNP
	6N73ZwXbrPm0VuiFoNfyD0zljpX9+WU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151247; a=rsa-sha256;
	cv=none;
	b=WjDsmqJQmYmNTvaR2QE4npixK2qJRYIteKcoseLCrK2NWQrMHA7eswYE3XoFCAqnM2hfI5
	9+zRNu/eef3Oe8zfHofd2z75jYrhg7qQJEO/ax3vINuFYjZd4EVInZFxQsl9eFxJ07oW/g
	X91PtJsTbrZ/djfWBRO47Ez5dcMYAt8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44A415BCD6;
	Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F91B139E8;
	Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kNVqB9cac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:57 +0100
Subject: [PATCH v4 19/22] slab: update overview comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-19-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D0FF20006
X-Stat-Signature: i1x6eo5chwgr8h6nhc6hr4hrugrgok4q
X-Rspam-User: 
X-HE-Tag: 1769151246-876914
X-HE-Meta: U2FsdGVkX187uixf15aB8MtadWBK+PAd8fnNucFphuj/VC42AB4w60WHNmnxHWf4449RlN7/qVURKiURoHhpxXlU9zIn7FzAGPbb+wu9DeCBlTREosENKnRiVMjVXThGaMq6Hr5me+tucYUJqfthCbvtx9ahravHjDThvU2zK7podWVb1owCJkFjPf9xplzhLKP7BfkZ8shCOC6znHYjbfrBGOhyXobXrCT+D1RBDtga7FsgqBBVk9NSdYaMV0yrbqnXAIgp1LnURPavJl42cvsgjn0iX2hE2LXXJMmRQxoUk/yn4KxELYLDBTcqMv7ycjNQeD/mU/7/aTkOk6ouJ7Xj5dWyfPprIblZgraSuH/Iv4/p5QUz6HkjLkrCp/OTXBFCD6M8s1S8O6IljMIZI0hO8rtmfguAPoUlSOfMv8US/npO1tTDz2Pve0efKBQFE/HRUGnegcjrOHO64EQYnFu8g1zvESPFpKSaNzH/nndLGPPNvhzbWc3/LcLE5dUj3ciDbfR25M44EuinxMWprNhNVh4k/qi0p+eDfYqAAX3PtYn/n5w7nw79iRrN2EjUeIamAfmtdf28LsnrZthPTiMylcMZboUKrI6KCYWhP8Yx7lYGD6t/4/J2F9RJVIhgsZX5OUTutMyZrVWrCpjEN1JJ6nkjBZaFIaNurw1CKG24hHxJtkVFYFc3U99f+wmUwKJB7Ul4j7yO4mRsYB6LkQ5QWdYHUXmI5Y9kPrLTx7dH04o3Nh/veOZbrGX1PyWPCtqSRvB2P+3PL8rWxuWscXTgQZz5JRxEa9epOTqTCNzpEh+6WJXzVMPmVHZinlTwGd5Asyd6L/0dqDsQCyncy4DqWZuVArWnMP7vyyS4+sGwlWS1XZ1YQOA8xcuxOpAGbYAdoXjGp9ThNn0nryqOFRzDmWmBWoByg2e0AhENCM+1UeU2ABFyzZcDsUQOUa7JJOeVLyHzIXoljP1acXn
 wUpflRXa
 4HRmooshzNEetSI+HsJm7hXib9QLg0tjfSce35mgFqgtk3hjVZlRNLRMEy3VLcF5GWa0GJYcK87u2OsC9kqK1CWY4O1cLHX9G+DUsDX6YkiKAsLjqGJPlZLX+D3CtghaOh4y0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The changes related to sheaves made the description of locking and other
details outdated. Update it to reflect current state.

Also add a new copyright line due to major changes.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 141 +++++++++++++++++++++++++++++---------------------------------
 1 file changed, 67 insertions(+), 74 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 540e3c641d1e..d9fc56122975 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1,13 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * SLUB: A slab allocator that limits cache line use instead of queuing
- * objects in per cpu and per node lists.
+ * SLUB: A slab allocator with low overhead percpu array caches and mostly
+ * lockless freeing of objects to slabs in the slowpath.
  *
- * The allocator synchronizes using per slab locks or atomic operations
- * and only uses a centralized lock to manage a pool of partial slabs.
+ * The allocator synchronizes using spin_trylock for percpu arrays in the
+ * fastpath, and cmpxchg_double (or bit spinlock) for slowpath freeing.
+ * Uses a centralized lock to manage a pool of partial slabs.
  *
  * (C) 2007 SGI, Christoph Lameter
  * (C) 2011 Linux Foundation, Christoph Lameter
+ * (C) 2025 SUSE, Vlastimil Babka
  */
 
 #include <linux/mm.h>
@@ -53,11 +55,13 @@
 
 /*
  * Lock order:
- *   1. slab_mutex (Global Mutex)
- *   2. node->list_lock (Spinlock)
- *   3. kmem_cache->cpu_slab->lock (Local lock)
- *   4. slab_lock(slab) (Only on some arches)
- *   5. object_map_lock (Only for debugging)
+ *   0.  cpu_hotplug_lock
+ *   1.  slab_mutex (Global Mutex)
+ *   2a. kmem_cache->cpu_sheaves->lock (Local trylock)
+ *   2b. node->barn->lock (Spinlock)
+ *   2c. node->list_lock (Spinlock)
+ *   3.  slab_lock(slab) (Only on some arches)
+ *   4.  object_map_lock (Only for debugging)
  *
  *   slab_mutex
  *
@@ -78,31 +82,38 @@
  *	C. slab->objects	-> Number of objects in slab
  *	D. slab->frozen		-> frozen state
  *
- *   Frozen slabs
+ *   SL_partial slabs
+ *
+ *   Slabs on node partial list have at least one free object. A limited number
+ *   of slabs on the list can be fully free (slab->inuse == 0), until we start
+ *   discarding them. These slabs are marked with SL_partial, and the flag is
+ *   cleared while removing them, usually to grab their freelist afterwards.
+ *   This clearing also exempts them from list management. Please see
+ *   __slab_free() for more details.
  *
- *   If a slab is frozen then it is exempt from list management. It is
- *   the cpu slab which is actively allocated from by the processor that
- *   froze it and it is not on any list. The processor that froze the
- *   slab is the one who can perform list operations on the slab. Other
- *   processors may put objects onto the freelist but the processor that
- *   froze the slab is the only one that can retrieve the objects from the
- *   slab's freelist.
+ *   Full slabs
  *
- *   CPU partial slabs
+ *   For caches without debugging enabled, full slabs (slab->inuse ==
+ *   slab->objects and slab->freelist == NULL) are not placed on any list.
+ *   The __slab_free() freeing the first object from such a slab will place
+ *   it on the partial list. Caches with debugging enabled place such slab
+ *   on the full list and use different allocation and freeing paths.
+ *
+ *   Frozen slabs
  *
- *   The partially empty slabs cached on the CPU partial list are used
- *   for performance reasons, which speeds up the allocation process.
- *   These slabs are not frozen, but are also exempt from list management,
- *   by clearing the SL_partial flag when moving out of the node
- *   partial list. Please see __slab_free() for more details.
+ *   If a slab is frozen then it is exempt from list management. It is used to
+ *   indicate a slab that has failed consistency checks and thus cannot be
+ *   allocated from anymore - it is also marked as full. Any previously
+ *   allocated objects will be simply leaked upon freeing instead of attempting
+ *   to modify the potentially corrupted freelist and metadata.
  *
  *   To sum up, the current scheme is:
- *   - node partial slab: SL_partial && !frozen
- *   - cpu partial slab: !SL_partial && !frozen
- *   - cpu slab: !SL_partial && frozen
- *   - full slab: !SL_partial && !frozen
+ *   - node partial slab:            SL_partial && !full && !frozen
+ *   - taken off partial list:      !SL_partial && !full && !frozen
+ *   - full slab, not on any list:  !SL_partial &&  full && !frozen
+ *   - frozen due to inconsistency: !SL_partial &&  full &&  frozen
  *
- *   list_lock
+ *   node->list_lock (spinlock)
  *
  *   The list_lock protects the partial and full list on each node and
  *   the partial slab counter. If taken then no new slabs may be added or
@@ -112,47 +123,46 @@
  *
  *   The list_lock is a centralized lock and thus we avoid taking it as
  *   much as possible. As long as SLUB does not have to handle partial
- *   slabs, operations can continue without any centralized lock. F.e.
- *   allocating a long series of objects that fill up slabs does not require
- *   the list lock.
+ *   slabs, operations can continue without any centralized lock.
  *
  *   For debug caches, all allocations are forced to go through a list_lock
  *   protected region to serialize against concurrent validation.
  *
- *   cpu_slab->lock local lock
+ *   cpu_sheaves->lock (local_trylock)
  *
- *   This locks protect slowpath manipulation of all kmem_cache_cpu fields
- *   except the stat counters. This is a percpu structure manipulated only by
- *   the local cpu, so the lock protects against being preempted or interrupted
- *   by an irq. Fast path operations rely on lockless operations instead.
+ *   This lock protects fastpath operations on the percpu sheaves. On !RT it
+ *   only disables preemption and does no atomic operations. As long as the main
+ *   or spare sheaf can handle the allocation or free, there is no other
+ *   overhead.
  *
- *   On PREEMPT_RT, the local lock neither disables interrupts nor preemption
- *   which means the lockless fastpath cannot be used as it might interfere with
- *   an in-progress slow path operations. In this case the local lock is always
- *   taken but it still utilizes the freelist for the common operations.
+ *   node->barn->lock (spinlock)
  *
- *   lockless fastpaths
+ *   This lock protects the operations on per-NUMA-node barn. It can quickly
+ *   serve an empty or full sheaf if available, and avoid more expensive refill
+ *   or flush operation.
  *
- *   The fast path allocation (slab_alloc_node()) and freeing (do_slab_free())
- *   are fully lockless when satisfied from the percpu slab (and when
- *   cmpxchg_double is possible to use, otherwise slab_lock is taken).
- *   They also don't disable preemption or migration or irqs. They rely on
- *   the transaction id (tid) field to detect being preempted or moved to
- *   another cpu.
+ *   Lockless freeing
+ *
+ *   Objects may have to be freed to their slabs when they are from a remote
+ *   node (where we want to avoid filling local sheaves with remote objects)
+ *   or when there are too many full sheaves. On architectures supporting
+ *   cmpxchg_double this is done by a lockless update of slab's freelist and
+ *   counters, otherwise slab_lock is taken. This only needs to take the
+ *   list_lock if it's a first free to a full slab, or when a slab becomes empty
+ *   after the free.
  *
  *   irq, preemption, migration considerations
  *
- *   Interrupts are disabled as part of list_lock or local_lock operations, or
+ *   Interrupts are disabled as part of list_lock or barn lock operations, or
  *   around the slab_lock operation, in order to make the slab allocator safe
  *   to use in the context of an irq.
+ *   Preemption is disabled as part of local_trylock operations.
+ *   kmalloc_nolock() and kfree_nolock() are safe in NMI context but see
+ *   their limitations.
  *
- *   In addition, preemption (or migration on PREEMPT_RT) is disabled in the
- *   allocation slowpath, bulk allocation, and put_cpu_partial(), so that the
- *   local cpu doesn't change in the process and e.g. the kmem_cache_cpu pointer
- *   doesn't have to be revalidated in each section protected by the local lock.
- *
- * SLUB assigns one slab for allocation to each processor.
- * Allocations only occur from these slabs called cpu slabs.
+ * SLUB assigns two object arrays called sheaves for caching allocations and
+ * frees on each cpu, with a NUMA node shared barn for balancing between cpus.
+ * Allocations and frees are primarily served from these sheaves.
  *
  * Slabs with free elements are kept on a partial list and during regular
  * operations no list for full slabs is used. If an object in a full slab is
@@ -160,25 +170,8 @@
  * We track full slabs for debugging purposes though because otherwise we
  * cannot scan all objects.
  *
- * Slabs are freed when they become empty. Teardown and setup is
- * minimal so we rely on the page allocators per cpu caches for
- * fast frees and allocs.
- *
- * slab->frozen		The slab is frozen and exempt from list processing.
- * 			This means that the slab is dedicated to a purpose
- * 			such as satisfying allocations for a specific
- * 			processor. Objects may be freed in the slab while
- * 			it is frozen but slab_free will then skip the usual
- * 			list operations. It is up to the processor holding
- * 			the slab to integrate the slab into the slab lists
- * 			when the slab is no longer needed.
- *
- * 			One use of this flag is to mark slabs that are
- * 			used for allocations. Then such a slab becomes a cpu
- * 			slab. The cpu slab may be equipped with an additional
- * 			freelist that allows lockless access to
- * 			free objects in addition to the regular freelist
- * 			that requires the slab lock.
+ * Slabs are freed when they become empty. Teardown and setup is minimal so we
+ * rely on the page allocators per cpu caches for fast frees and allocs.
  *
  * SLAB_DEBUG_FLAGS	Slab requires special handling due to debug
  * 			options set. This moves	slab handling out of

-- 
2.52.0


