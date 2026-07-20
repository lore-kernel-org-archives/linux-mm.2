Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01118C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3AD6B009D; Mon, 20 Jul 2026 08:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53DD6B009E; Mon, 20 Jul 2026 08:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D126B009F; Mon, 20 Jul 2026 08:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8380F6B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:45:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1377FA0120
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:29 +0000 (UTC)
X-FDA: 85009125978.28.D8F9760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40B2F40008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elalmCGf;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cHnkwuF4ro5MWAVdkxVeTaPPjiy6r7D3W1H7ywzkOZw=;
	b=0vMiXWF7H1s9YDEW4nra+Xahl/Sji6E3vtmZ4L62qCwpqVXOTmchzu8yJbGKJ4ta5xn6Dx
	FuaQ43nZh1lzEX8/n8ZK7Gbuiwq8emS5rUC+GUMmCxSCtjWvs1PejKNhH5JfG4adjTZH7f
	SsP3i1FTg2T04hrWRh782RfSmq2mbh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551527;
	b=gNT2254Fl2sWn+Z241snqHcJm5lzBytt+HvfW2guxa7GNnOabmYUK6ZRqySobukMtoJIjM
	ZbRvo60/1LvpNO8AydAun+rcoYux7we8Ofquh8ScxAwM+kBd/FZ2jp8xGCBlWtwLehcg0s
	V5pPpQmqr51bJDM5EX0lB1UQ0fCU81w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elalmCGf;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 374AE40E2B;
	Mon, 20 Jul 2026 12:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074431F00A3A;
	Mon, 20 Jul 2026 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551526;
	bh=cHnkwuF4ro5MWAVdkxVeTaPPjiy6r7D3W1H7ywzkOZw=;
	h=From:Subject:Date:To:Cc;
	b=elalmCGfKU6Scaa0WjuyVgxFjvxeImaVPJlPR6SEJ3rRQSMcEbhKP0fOUvx2nNuAz
	 rcp72WWZ96bhEOI19PtSZYjo8ZGaZASN/1W/HvBx6u4hrKzBPgOJByMvN+UCjSqlLM
	 eBdLhpGcQShwtfSTINUgMn7n8uobXulkEJTAEHAAE+qTygGGrHSWi9sLr7vXNas+08
	 451gUP5S4vq8KF2TioxhxgUdBW9Q+5gZ5sXLE1p0AjCOGo7+tdYpjrhOF8xbnEETx/
	 URiWR9cEYR764ZxldO3d4d5JQAU7fUrtVeqyBxDYWa7yk1SE2rsG6hhfNykzkIGxMv
	 bS6f7eA2iax4w==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH slab/for-next v4 0/8] mm/slab: introduce kfree_rcu_nolock()
 and improve slub_kunit coverage
Date: Mon, 20 Jul 2026 21:44:29 +0900
Message-Id: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQqDMBBEf0X23LRpdBU99T+KiNqNBkNSNjZYx
 H9v8N7jY2be7BCIDQVosh2YognGuwTFJYNx7t1EwrwSg5KqlOUdxaKZqOPx0zlv/bgIQpQKEet
 aaUizN5M226l8QrD9cNOehaNthTbFswmr5+95GPOz9N8dcyFFJXssdF5VOAyPhdiRvXqeoD2O4
 wfJ+/qIwAAAAA==
X-Change-ID: 20260615-kfree_rcu_nolock-e5502555992f
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40B2F40008
X-Stat-Signature: 615zd1hycnsfzbyxzczixkchoanwh1og
X-HE-Tag: 1784551527-595287
X-HE-Meta: U2FsdGVkX19HG2E1/kIvhkT7WN/Xqwbwdb7fP+Th/KYgI0rWtnSy7kSjwGTtJRNChCQ49MzRzCRGeWzI3twfFOKyRq2Bl5Uebs5maxtL2iSp/NAMrI+MdMiO6WgOo/A+cEaH4JFYrUIoEQis3Qe3EKVTnFIbJ6dG8gNqhCS9Y4068cUk76asQV6uy3U0ogBVovGfXsXa67flaMkDjBfuGCQQKz733wnR9alUJHgEoFzXmEK1c+aCtliA03S0iBe06tid9Af3ZqamZY40VjyDkAzuaIR18FoUxhXkfk02MJYMm2kLDftrTtnWf5rgopPlepbUFYXl07GYc5iVxo3HBn86AUNoKartoIPeYgYwWi7pQqbFNjPAiIuCICufvF7I2Aq1Tm3zPRaC/zA82NaTyHncBmp+0hLaVZEgLvLzWEc1SbeESVNZrmeD35U1wYaXJ0CnWx4nAXCVsPpspFmRa2eabTAlc6aHHkkviQPx8/6wLMkta2ZMZN8Ffj2dWLS+2OktLrc0Wj6PmIN27JfICKgVaID0hyV8/zNGeah5zPYUIvb8+yAIwZ7indCmw5/rX4tT8JlecN5XRdkVehTawkxEZ28G5g6Du3lKSopkNgrwhu3YfvV/AM4PN2+AlsIxLOf70yL4981Cw3mAdL8d4MSUhvfVivNNhJD95e1zEsEh2K9blIaZsLJyFgK2Hl+MndNT0FjfYCWW2T1WT9GdB00/VxOPWop3G/a54ZN7KHAAYffpVGgDSb+jWPhvAnuR/5oQynQZZ+dmn0H5Br5q8SXyuX9J++h2VK8nc2NTN++zcoEORRrtj6tH8VMG6t9xt3MpzSfFNu+Vts1pkC4Rvms7zwnkukpLNXwYF+KpBTBm390CO8t3yXGltT9KcQJSIPNre85sd3OVJfEbhcgoDIcmB0DAbMhdRM8KU39KD3AsWyLPBETZdbE7N9fjAS+tvXLBBcUxX0CN4Nk+w1d
 Ov0BaQMq
 n4SWboJch8oDI3blM0FC5kL5qcSSLLZhM04+FIdcwqPGGEFeo55p67OWpvlrBTN5GUcRvmALUBWNodxZ1cLRk7Al5zIEdWiL7IiYSajCKeQ0aWr6Rqt9w6RyeB7fXAVhasHlWhCXNbHZRz6/V3y4KV5MjNRrp/FUWBDixtU6gDsppjPIBqjqnvYPh4RwueZcYvNq36kuEzT85U9H4wyU2MMv+cCsqNoAaEMPJBQzcYEAbhCAW5655+4QknRPY8IA/1ifKvuXQS6XjLLidX4vFT5qp4S/OEMk4HM90LoeFvkgqZ5HazTkN38/33oL7Go0DCHd+AGTMwxk8mdJ5aMTgBZtkfWzDS9Gh2hu2IdOs3GwLnEv/vFfNZKEkrJET+DVEG3y3qnf81pkQVA1VT4a1bK7DOLir0a9u1rZLnvnHmc6oa5vlZQOTYOhKbgZXnUL8Vcail3pXVbGFyxLz3yoRlwNvqunzS/LhnU6ufKeUXYiABXtooBIzxcbxE2OhaT11F4KTtwd2HMOElqAmGCsPTgt0/PYySOh41i9O2qs07aLgws6QOf2QTPfA0o8MS0ZGMEVoKXdyODw1JE+s2QQ3nK58QDFg8yMUjY2q+MaIbmMF6J1y5c6llZilsvYnAUFO3qCwi7cNyqzw5+5iSB/AIXDwPXQBZiOGf/+jp0W4fBmHGnt9subuiKuPvHK0YfibUGwa2O/sJDN3UKCkSt4dV4eOv/14QW/ecUgmHa2+mmjkP1KRqqiRGmYS4+BCKPE9wQndZaRz2P2gFVw/THf4DU3yOxQC+dCh1D/l9NTDblSaLAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on slab/for-next (56aa9b819edc), and is also
available on git.kernel.org [4].

Changes since v3
=================

kfree_rcu_nolock() now falls back to kvfree_call_rcu() via irq work
-------------------------------------------------------------------

While revisiting making the fallback path use percpu lockless list [6]
(as the fallback path can be triggered more easily compared to RFC v2),
realized that we don't really have to reinvent yet another mechanism :)

kvfree_rcu() batching now uses kvfree_rcu_head internally, while
the API remains unchanged for now (to avoid making the series larger).
This allows kfree_rcu_nolock() to fall back to kvfree_rcu batching via
irq work and avoids additional complexity.

Minor changes
-------------

- Added Acked-by, Reviewed-by from Vlastimil and Pedro, thanks!
  Oh, but I dropped add Vlastimil's Acked-by: on patch 7 as the fallback
  path was changed a bit. See above!
- Was Patch 1: Dropped SW perf counter fallback in slub_kunit test (Alexei)
- Patch 1: Explain why we don't test _nolock APIs with kprobe on !SMP (Pedro)
- Patch 1: Make kprobe and perf tests independent test cases
- Patch 2: Introduce SLAB_FREE_* flags instead of passing allow_spin
  (inspired by Pedro). alloc_empty_sheaf() drops __GFP_RECLAIM w/
  SLAB_ALLOC_NOLOCK
- Patch 3: Elaborate the comment on !irqs_disabled(() check (Vlastimil)
- Patch 4: Explain why it is tricky to implement kvfree_rcu_barrier() that
  works on a specific kmem_cache (Pedro)
- Patch 4: Use llist_for_each_entry_safe() instead of llist_for_each_safe()
  (Pedro)
- Patch 7: Fall back when NUMA node doesn't match (Shengming)
- Patch 7: Document that kfree_rcu_nolock() supports only objects allocated
  via kmalloc_nolock() (Xiao)
- In this version I didn't adjust Alexei's comment on bypassing perf
  event throttling because my tests complained that it's firing too
  fast and sometimes it exceeded test timeout because of this. Need more
  thoughts on this.

Git range-diff is copied-and-pasted at the end of the email.

Actual Cover Letter
===================

This series improves kmalloc_nolock() and kfree_nolock() coverage
in slub_kunit (patch 1) and introduces kfree_rcu_nolock() for
unknown context as suggested by Alexei Starovoitov.

Unknown context means the caller does not know whether spinning on a lock
is safe (e.g., a BPF program attached to an arbitrary kernel function or
in NMI context).

The slab allocator already supports unknown context via kmalloc_nolock()
and kfree_nolock(), but te slab allocator does not support freeing
objects by RCU in unknown context.

It is not ideal to have completely separate batching for unknown context
because the worst scenario where spinning on a lock would lead to
deadlock is very rare, and in most cases, it is safe to use the
existing mechanism (kfree_rcu_sheaf()).

Since most part of the slab allocator already supports unknown context
and sheaves support batching kvfree_rcu() calls for slab objects,
implement kfree_rcu_nolock() with minimal changes by teaching
kfree_rcu_sheaf() how to support unknown context and making
it a little bit harder to allocate an empty sheaf, instead of making
intrusive changes to the existing kvfree_rcu batching logic.

kfree_rcu_nolock() tries to free the object to the rcu sheaf if
trylock succeeds. Once the rcu sheaf becomes full, it is submitted to
RCU via call_rcu() if spinning is allowed or IRQs are enabled (to avoid
calling call_rcu() in the middle of call_rcu()). Otherwise, call_rcu()
is deferred via irq work.

When there is no sheaf available, kfree_rcu_sheaf() falls back to
defer_kfree_rcu(). It submits the object to kvfree_rcu batching
via irq work. To do this, patch 6 converts kvfree_rcu to use
kvfree_rcu_head without visible changes to the API for now.

Unlike kfree_rcu(), only the 2-argument variant is supported.
This is because the last resort of the 1-arg variant is
synchronize_rcu(), which cannot be used in an unknown context.

As suggested by Alexei Starovoitov, kfree_rcu_nolock() can be used with
struct kvfree_rcu_head (8 bytes), which is smaller than struct rcu_head
(16 bytes).

For more background and future plans, please see [5].

[1] RFC v1: https://lore.kernel.org/linux-mm/20260206093410.160622-1-harry.yoo@oracle.com

[2] RFC v2: https://lore.kernel.org/linux-mm/20260416091022.36823-1-harry@kernel.org

[3] v3: https://lore.kernel.org/linux-mm/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org
 
[4] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kfree_rcu_nolock-v4r1

[5] kmalloc_nolock() follow-ups, including kfree_rcu_nolock(),
    https://lore.kernel.org/linux-mm/esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3

To: Vlastimil Babka <vbabka@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Hao Li <hao.li@linux.dev>
To: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>
To: Andrii Nakryiko <andrii@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
To: Amery Hung <ameryhung@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Clark Williams <clrkwllms@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Paul E. McKenney <paulmck@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
To: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
To: Joel Fernandes <joelagnelf@nvidia.com>
To: Josh Triplett <josh@joshtriplett.org>
To: Boqun Feng <boqun@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
To: Zqiang <qiang.zhang@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
To: Suren Baghdasaryan <surenb@google.com>
To: Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-rt-devel@lists.linux.dev
Cc: rcu@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

1:  d9a08a6baf2f <  -:  ------------ slub_kunit: fall back to SW perf events when HW PMU is not available
 2:  eba4a1d7445d !  1:  a16d94ea7d79 mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
    @@ Commit message
     
         Register a kprobe pre-handler to invoke kmalloc_nolock() and
         kfree_nolock() in the middle of the slab allocator. However, do not
    -    register the handler on UP kernels [1].
    +    register the handler on UP kernels because that use case is not
    +    well supported [1] in the kernel.
     
         To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
         is held, add a wrapper function for lockdep_assert_held() that calls
    @@ Commit message
         away its callsites. Otherwise, the compiler may consider the function
         does not have any side effect and remove callsites.
     
    +    Compared to using plain kprobe, this has two advantages: 1) it avoids
    +    hardcoding function names in the test, and 2) it can trigger those APIs
    +    in the middle of a function, where the lock is expected to be held as
    +    annotated with lockdep.
    +
    +    While it was proposed [2] to use kunit function redirection to test
    +    this, it is currently infeasible as some lock helpers don't have
    +    symbols.
    +
    +    Factor out the nested loop that calls kmalloc and friends to
    +    test_kmalloc_kfree(), and call them in
    +    test_kmalloc_kfree_nolock_{perf,kprobe}(), each being an independent
    +    test case. During the refactoring, drop alloc_fail handling as it
    +    doesn't provide much benefits.
    +
    +    Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
    +    Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
     
      ## lib/tests/slub_kunit.c ##
    @@ lib/tests/slub_kunit.c: static void test_krealloc_redzone_zeroing(struct kunit *
      
     -#ifdef CONFIG_PERF_EVENTS
     +#if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
    -+#define SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
      #define NR_ITERATIONS 1000
      #define NR_OBJECTS 1000
      static void *objects[NR_OBJECTS];
    @@ lib/tests/slub_kunit.c: struct test_nolock_context {
      	int alloc_fail;
     +#ifdef CONFIG_PERF_EVENTS
      	struct perf_event *event;
    - 	bool is_perf_type_hw;
     +#endif
    -+#ifdef CONFIG_KPROBES
    ++#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
     +	struct kprobe kprobe;
     +#endif
      };
      
    -+#ifdef CONFIG_PERF_EVENTS
    - static struct perf_event_attr hw_attr = {
    - 	.type = PERF_TYPE_HARDWARE,
    - 	.config = PERF_COUNT_HW_CPU_CYCLES,
    -@@ lib/tests/slub_kunit.c: static struct perf_event_attr sw_attr = {
    - 	.sample_freq = 100000,
    - };
    +-static struct perf_event_attr hw_attr = {
    +-	.type = PERF_TYPE_HARDWARE,
    +-	.config = PERF_COUNT_HW_CPU_CYCLES,
    +-	.size = sizeof(struct perf_event_attr),
    +-	.pinned = 1,
    +-	.disabled = 1,
    +-	.freq = 1,
    +-	.sample_freq = 100000,
    +-};
    ++static void test_kmalloc_kfree(void)
    ++{
    ++	int i, j;
    ++
    ++	for (i = 0; i < NR_ITERATIONS; i++) {
    ++		for (j = 0; j < NR_OBJECTS; j++) {
    ++			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
      
    --static void overflow_handler_test_nolock(struct perf_event *event,
    --					 struct perf_sample_data *data,
    --					 struct pt_regs *regs)
    +-static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
    +-						       struct perf_sample_data *data,
    +-						       struct pt_regs *regs)
    ++			objects[j] = kmalloc_obj(*objects[j], gfp);
    ++			if (!objects[j]) {
    ++				j--;
    ++				while (j >= 0)
    ++					kfree(objects[j--]);
    ++				return;
    ++			}
    ++		}
    ++
    ++		for (j = 0; j < NR_OBJECTS; j++)
    ++			kfree(objects[j]);
    ++	}
    ++}
    ++
     +static void test_nolock(struct test_nolock_context *ctx)
      {
      	void *objp;
    @@ lib/tests/slub_kunit.c: static struct perf_event_attr sw_attr = {
      
      	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
      	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
    -@@ lib/tests/slub_kunit.c: static void overflow_handler_test_nolock(struct perf_event *event,
    +@@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
    + 	kfree_nolock(objp);
      	ctx->callback_count++;
      }
    ++#endif
      
    +-static void test_kmalloc_kfree_nolock(struct kunit *test)
    ++#ifdef CONFIG_PERF_EVENTS
    ++static struct perf_event_attr hw_attr = {
    ++	.type = PERF_TYPE_HARDWARE,
    ++	.config = PERF_COUNT_HW_CPU_CYCLES,
    ++	.size = sizeof(struct perf_event_attr),
    ++	.pinned = 1,
    ++	.disabled = 1,
    ++	.freq = 1,
    ++	.sample_freq = 100000,
    ++};
    ++
     +static void overflow_handler_test_nolock(struct perf_event *event,
     +					 struct perf_sample_data *data,
     +					 struct pt_regs *regs)
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_nolock(struct perf_eve
     +	test_nolock(ctx);
     +}
     +
    - static bool enable_perf_events(struct test_nolock_context *ctx)
    ++static bool enable_perf_events(struct test_nolock_context *ctx)
      {
    +-	int i, j;
    +-	struct test_nolock_context ctx = { .test = test };
      	struct perf_event *event;
    -@@ lib/tests/slub_kunit.c: static void disable_perf_events(struct test_nolock_context *ctx)
    - 	perf_event_disable(ctx->event);
    - 	perf_event_release_kernel(ctx->event);
    - }
    -+#else
    -+static bool enable_perf_events(struct test_nolock_context *ctx) { return false; }
    -+static void disable_perf_events(struct test_nolock_context *ctx) { }
    +-	bool alloc_fail = false;
    + 
    + 	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
    +-						 overflow_handler_test_kmalloc_kfree_nolock,
    +-						 &ctx);
    ++						 overflow_handler_test_nolock,
    ++						 ctx);
    ++
    + 	if (IS_ERR(event))
    +-		kunit_skip(test, "Failed to create perf event");
    +-	ctx.event = event;
    +-	perf_event_enable(ctx.event);
    +-	for (i = 0; i < NR_ITERATIONS; i++) {
    +-		for (j = 0; j < NR_OBJECTS; j++) {
    +-			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
    ++		return false;
    + 
    +-			objects[j] = kmalloc(64, gfp);
    +-			if (!objects[j]) {
    +-				j--;
    +-				while (j >= 0)
    +-					kfree(objects[j--]);
    +-				alloc_fail = true;
    +-				goto cleanup;
    +-			}
    +-		}
    +-		for (j = 0; j < NR_OBJECTS; j++)
    +-			kfree(objects[j]);
    +-	}
    ++	ctx->event = event;
    ++	perf_event_enable(ctx->event);
    ++	return true;
    ++}
    + 
    +-cleanup:
    +-	perf_event_disable(ctx.event);
    +-	perf_event_release_kernel(ctx.event);
    ++static void disable_perf_events(struct test_nolock_context *ctx)
    ++{
    ++	kunit_info(ctx->test, "HW perf events: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
    ++		   ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
    ++
    ++	perf_event_disable(ctx->event);
    ++	perf_event_release_kernel(ctx->event);
    ++}
    ++
    ++static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
    ++{
    ++	struct test_nolock_context ctx = { .test = test };
    + 
    +-	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
    +-		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
    ++	if (!enable_perf_events(&ctx))
    ++		kunit_skip(test, "Failed to enable perf event, skipping");
    + 
    +-	if (alloc_fail)
    +-		kunit_skip(test, "Allocation failed");
    ++	test_kmalloc_kfree();
    ++
    ++	disable_perf_events(&ctx);
    ++	KUNIT_EXPECT_EQ(test, 0, slab_errors);
    ++}
     +#endif
     +
     +#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
    @@ lib/tests/slub_kunit.c: static void disable_perf_events(struct test_nolock_conte
     +		   ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
     +	unregister_kprobe(&ctx->kprobe);
     +}
    -+#else
    -+static bool register_slab_kprobes(struct test_nolock_context *ctx) { return false; }
    -+static void unregister_slab_kprobes(struct test_nolock_context *ctx) { }
    -+#endif
    - 
    - static void test_kmalloc_kfree_nolock(struct kunit *test)
    - {
    - 	int i, j;
    --	struct test_nolock_context ctx = { .test = test };
    -+	struct test_nolock_context perf_ctx = { .test = test };
    -+	struct test_nolock_context kprobe_ctx = { .test = test };
    - 	bool alloc_fail = false;
    - 	bool perf_events_enabled;
    -+	bool slab_kprobes_enabled;
    - 
    --	perf_events_enabled = enable_perf_events(&ctx);
    --	if (!perf_events_enabled)
    --		kunit_skip(test, "Failed to create perf event");
    -+	perf_events_enabled = enable_perf_events(&perf_ctx);
    -+	slab_kprobes_enabled = register_slab_kprobes(&kprobe_ctx);
     +
    -+	if (!perf_events_enabled && !slab_kprobes_enabled)
    -+		kunit_skip(test, "Failed to enable perf event and kprobe, skipping");
    -+	else if (!perf_events_enabled)
    -+		kunit_info(test, "Failed to create perf event");
    -+	if (!slab_kprobes_enabled)
    -+		kunit_info(test, "Failed to register kprobe pre-handler");
    - 
    - 	for (i = 0; i < NR_ITERATIONS; i++) {
    - 		for (j = 0; j < NR_OBJECTS; j++) {
    -@@ lib/tests/slub_kunit.c: static void test_kmalloc_kfree_nolock(struct kunit *test)
    - 	}
    - 
    - cleanup:
    --	disable_perf_events(&ctx);
    -+	if (perf_events_enabled)
    -+		disable_perf_events(&perf_ctx);
    -+	if (slab_kprobes_enabled)
    -+		unregister_slab_kprobes(&kprobe_ctx);
    - 
    - 	if (alloc_fail)
    - 		kunit_skip(test, "Allocation failed");
    ++static void test_kmalloc_kfree_nolock_kprobe(struct kunit *test)
    ++{
    ++	struct test_nolock_context ctx = { .test = test };
    ++
    ++	if (!register_slab_kprobes(&ctx))
    ++		kunit_skip(test, "Failed to register kprobe, skipping");
    ++
    ++	test_kmalloc_kfree();
    ++
    ++	unregister_slab_kprobes(&ctx);
    + 	KUNIT_EXPECT_EQ(test, 0, slab_errors);
    + }
    + #endif
     @@ lib/tests/slub_kunit.c: static struct kunit_case test_cases[] = {
    - 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
      	KUNIT_CASE(test_leak_destroy),
      	KUNIT_CASE(test_krealloc_redzone_zeroing),
    --#ifdef CONFIG_PERF_EVENTS
    -+#ifdef SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
    - 	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
    + #ifdef CONFIG_PERF_EVENTS
    +-	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
    ++	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_perf),
    ++#endif
    ++#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
    ++	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_kprobe),
      #endif
      	{}
    + };
     
      ## mm/slub.c ##
     @@ mm/slub.c: static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 3:  b6661675c309 !  2:  b33e9d9e4028 mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
    @@ Commit message
         an empty sheaf because the fallback path will be more expensive than
         kfree_nolock().
     
    +    Now that slab has internal alloc_flags to describe context, introduce
    +    free_flags analogously and convert free_flags to alloc_flags when
    +    allocating memory in the free path. alloc_empty_sheaf() now strips
    +    __GFP_RECLAIM when SLAB_ALLOC_NOLOCK is specified.
    +
         When trylock fails or the kernel observes non-NULL pcs->rcu_free after
         lock acquisition, free the sheaf instead of putting it to the barn.
         This is rare and not worth complicating the code.
    @@ Commit message
         Since call_rcu() cannot be called in an unknown context,
         kfree_rcu_sheaf() fails when the rcu sheaf becomes full.
     
    +    Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
     
      ## mm/slab.h ##
    +@@
    + #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
    + #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
    + 
    ++#define SLAB_FREE_DEFAULT	0x00 /* no flags */
    ++#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
    ++
    ++static inline unsigned int to_alloc_flags(unsigned int free_flags)
    ++{
    ++	if (free_flags & SLAB_FREE_NOLOCK)
    ++		return SLAB_ALLOC_NOLOCK;
    ++	else
    ++		return SLAB_ALLOC_DEFAULT;
    ++}
    ++
    + static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
    + {
    + 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
    + }
    + 
    ++static inline bool free_flags_allow_spinning(const unsigned int free_flags)
    ++{
    ++	return !(free_flags & SLAB_FREE_NOLOCK);
    ++}
    ++
    + void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
    + 				  unsigned int alloc_flags, int node)
    + 				  __assume_kmalloc_alignment __alloc_size(1);
     @@ mm/slab.h: static inline bool is_kmalloc_normal(struct kmem_cache *s)
      	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
      }
      
     -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
    -+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
    ++bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags);
      void flush_all_rcu_sheaves(void);
      void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
      
    @@ mm/slab_common.c: static bool kfree_rcu_sheaf(void *obj)
      	s = slab->slab_cache;
      	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
     -		return __kfree_rcu_sheaf(s, obj);
    -+		return __kfree_rcu_sheaf(s, obj, /* allow_spin = */ true);
    ++		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
      
      	return false;
      }
     
      ## mm/slub.c ##
     @@ mm/slub.c: static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
    + 
    + 	gfp &= ~OBJCGS_CLEAR_MASK;
    + 
    ++	if (alloc_flags & SLAB_ALLOC_NOLOCK)
    ++		gfp &= ~__GFP_RECLAIM;
    ++
      	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
      }
      
    @@ mm/slub.c: static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf
      static unsigned int
      refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
      	       unsigned int max);
    -@@ mm/slub.c: static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
    -  * intended action due to a race or cpu migration. Thus they do not check the
    -  * empty or full sheaf limits for simplicity.
    -  */
    --
    - static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf)
    - {
    - 	unsigned long flags;
     @@ mm/slub.c: static void rcu_free_sheaf(struct rcu_head *head)
       */
      static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
      
     -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
    -+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
    ++bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
      {
      	struct slub_percpu_sheaves *pcs;
      	struct slab_sheaf *rcu_sheaf;
    ++	bool allow_spin = free_flags_allow_spinning(free_flags);
    + 
    + 	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
    + 		return false;
     @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
      	pcs = this_cpu_ptr(s->cpu_sheaves);
      
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
     -
      		struct slab_sheaf *empty;
      		struct node_barn *barn;
    -+		unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
    -+		gfp_t gfp = GFP_NOWAIT;
    ++		unsigned int alloc_flags = to_alloc_flags(free_flags);
      
      		/* Bootstrap or debug cache, fall back */
      		if (unlikely(!cache_has_sheaves(s))) {
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
      		local_unlock(&s->cpu_sheaves->lock);
      
     -		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
    -+		if (unlikely(!allow_spin)) {
    -+			alloc_flags = SLAB_ALLOC_TRYLOCK;
    -+			gfp = 0;
    -+		}
    -+
    -+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
    ++		empty = alloc_empty_sheaf(s, GFP_NOWAIT, alloc_flags);
      
      		if (!empty)
      			goto fail;
 4:  7ac83bd3f701 <  -:  ------------ mm/slab: use call_rcu() in unknown context if irqs are enabled
 -:  ------------ >  3:  b4e3709e745a mm/slab: use call_rcu() in unknown context if irqs are enabled
 5:  18d3f7fac0db !  4:  a4f48243b29f mm/slab: extend deferred free mechanism to handle rcu sheaves
    @@ Commit message
         deferred free fallback so that a full rcu sheaf can be submitted to
         call_rcu() via the existing IRQ work.
     
    -    Since the deferred mechanism does more than deferred free of objects,
    +    Since the deferred mechanism does more than deferred freeing of objects,
         rename the struct to deferred_percpu_work and adjust names accordingly.
     
         When a sheaf is queued on an IRQ work, it is detached from
    @@ Commit message
         CPU before calling rcu_barrier().
     
         In the meantime, remove the TODO item as apparently there is no simple
    -    and effective way to achieve that.
    +    and effective way to achieve that. This is because, unlike sheaves,
    +    kfree_rcu() batches objects from different caches together.
     
    +    Reviewed-by: Pedro Falcato <pfalcato@suse.de>
    +    Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
     
      ## mm/slab.h ##
    @@ mm/slub.c: void flush_all_rcu_sheaves(void)
      	rcu_barrier();
      }
      
    -@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
    +@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
      	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
      		rcu_sheaf = NULL;
      	} else {
    --		/* call_rcu() disables IRQs to protect percpu data structures */
    +-		/*
    +-		 * With !allow_spin, we might have interrupted call_rcu()'s
    +-		 * IRQ-disabled critical section. If IRQs are not disabled,
    +-		 * we know that's not the case.
    +-		 */
     -		if (unlikely(!allow_spin && irqs_disabled())) {
     -			rcu_sheaf->size--;
     -			local_unlock(&s->cpu_sheaves->lock);
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_sp
      		pcs->rcu_free = NULL;
      		rcu_sheaf->node = numa_node_id();
      	}
    -@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
    +@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
      	 * we flush before local_unlock to make sure a racing
      	 * flush_all_rcu_sheaves() doesn't miss this sheaf
      	 */
     -	if (rcu_sheaf)
     -		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
     +	if (rcu_sheaf) {
    -+		/* call_rcu() disables IRQs to protect percpu data structures */
    ++		/*
    ++		 * With !allow_spin, we might have interrupted call_rcu()'s
    ++		 * IRQ-disabled critical section. If IRQs are not disabled,
    ++		 * we know that's not the case.
    ++		 */
     +		if (unlikely(!allow_spin && irqs_disabled())) {
     +			struct deferred_percpu_work *dpw;
     +
    @@ mm/slub.c: static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void
     +	struct deferred_percpu_work *dpw;
     +	struct llist_head *objs, *rcu_sheaves;
      	struct llist_node *llnode, *pos, *t;
    ++	struct slab_sheaf *sheaf, *next;
      
     -	if (llist_empty(objs))
     -		return;
    @@ mm/slub.c: static void free_deferred_objects(struct irq_work *work)
      	}
     +
     +	llnode = llist_del_all(rcu_sheaves);
    -+	llist_for_each_safe(pos, t, llnode) {
    -+		struct slab_sheaf *rcu_sheaf = llist_entry(pos, struct slab_sheaf, llnode);
    -+
    -+		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
    -+	}
    ++	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
    ++		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
      }
      
      static void defer_free(struct kmem_cache *s, void *head)
 6:  e7e9c9c8738c !  5:  d343d20115a6 mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
    @@ Metadata
      ## Commit message ##
     
    -    As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
    +    As suggested by Vlastimil Babka [1], kfree_rcu_sheaf() can be used
         on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
         This is because local_trylock and spinlock_t are safe to use with
    -    trylock variant as long as the kernel does not spin and the context is
    -    not NMI and not hardirq.
    +    trylock and unlock as long as the kernel does not spin and the context
    +    is not NMI and not hardirq.
     
    -    Now that __kfree_rcu_sheaf() knows how to handle allow_spin = false,
    +    Now that __kfree_rcu_sheaf() knows how to handle SLAB_FREE_NOLOCK,
         relax the limitation and try the sheaves path on PREEMPT_RT as well.
     
         Keep the lockdep map on non RT kernels. However, do not use the lockdep
         map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
     
    -    Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org
    +    As pointed by Vlastimil Babka [2], on PREEMPT_RT it is unnecessary to
    +    defer call_rcu() under IRQ-disabled section or raw spinlock. However,
    +    let us avoid adding more complexity as the scenario is not supposed
    +    to be common on PREEMPT_RT, with a hope that call_rcu_nolock() will be
    +    soon supported in RCU.
    +
    +    Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
    +    Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
     
    @@ mm/slab_common.c: static bool kfree_rcu_sheaf(void *obj)
      {
      	struct kmem_cache *s;
      	struct slab *slab;
    -+	bool allow_spin;
    ++	unsigned int free_flags = SLAB_FREE_DEFAULT;
     +
     +	/*
     +	 * It is not safe to spin on PREEMPT_RT because the kernel might be
     +	 * holding a raw spinlock and slab acquires sleeping locks.
     +	 */
    -+	allow_spin = !IS_ENABLED(CONFIG_PREEMPT_RT);
    ++	if (IS_ENABLED(CONFIG_PREEMPT_RT))
    ++		free_flags = SLAB_FREE_NOLOCK;
      
      	if (is_vmalloc_addr(obj))
      		return false;
    @@ mm/slab_common.c: static bool kfree_rcu_sheaf(void *obj)
      
      	s = slab->slab_cache;
      	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
    --		return __kfree_rcu_sheaf(s, obj, /* allow_spin = */ true);
    -+		return __kfree_rcu_sheaf(s, obj, allow_spin);
    +-		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
    ++		return __kfree_rcu_sheaf(s, obj, free_flags);
      
      	return false;
      }
    @@ mm/slub.c: static void rcu_free_sheaf(struct rcu_head *head)
       */
      static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
      
    -@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
    - 	struct slub_percpu_sheaves *pcs;
    +@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
      	struct slab_sheaf *rcu_sheaf;
    + 	bool allow_spin = free_flags_allow_spinning(free_flags);
      
     -	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
     -		return false;
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_sp
      
      	if (!local_trylock(&s->cpu_sheaves->lock))
      		goto fail;
    -@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
    +@@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
      	local_unlock(&s->cpu_sheaves->lock);
      
      	stat(s, FREE_RCU_SHEAF);
 -:  ------------ >  6:  5e34a69a743f mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
 7:  883f26a02d3f !  7:  428e78b8b089 mm/slab: introduce kfree_rcu_nolock()
    @@ Commit message
         now that kfree_rcu_sheaf() is available on PREEMPT_RT and
         __kfree_rcu_sheaf() handles unknown context.
     
    -    Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
    -    the kvfree_rcu batching when the sheaves path fails, and falls back to
    -    defer_kfree_rcu() instead. In most cases, the sheaves path is expected
    -    to succeed and it's unnecessary to add complexity to the existing
    -    kvfree_rcu batching.
    +    kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
    +    path fails. In most cases, the sheaves path is expected to succeed
    +    and it's unnecessary to add complexity to the existing kvfree_rcu
    +    batching by teaching it how to handle unknown context.
     
         Since defer_kfree_rcu() can be called on caches without sheaves, move
         deferred_work_barrier() and rcu_barrier() outside the branch in
    @@ include/linux/rcupdate.h
     @@ include/linux/rcupdate.h: static inline void rcu_read_unlock_migrate(void)
       * In mm/slab_common.c, no suitable header to include here.
       */
    - void kvfree_call_rcu(struct rcu_head *head, void *ptr);
    -+void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr);
    + void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
    ++void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
      
      /*
       * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
    @@ include/linux/rcupdate.h: do {								\
      		kvfree_call_rcu(NULL, (void *) (___p));		\
      } while (0)
      
    -+/* kfree_rcu_nolock() supports 2-arg variant only */
    -+#define kfree_rcu_nolock(ptr, krhf)					\
    -+do {									\
    -+	typeof (ptr) ___p = (ptr);					\
    -+									\
    -+	if (___p) {							\
    -+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), krhf) >= 4096);	\
    -+		kfree_call_rcu_nolock(&((___p)->krhf), (void *) (___p));\
    -+	}								\
    ++/**
    ++ * kfree_rcu_nolock() - a version of kfree_rcu() that can be called in any context.
    ++ * @ptr: pointer to kfree for double-argument invocations.
    ++ * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
    ++ *
    ++ * Objects that are not allocated via kmalloc_nolock() are not supported.
    ++ * kfree_rcu_nolock() supports 2-arg variant only.
    ++ */
    ++#define kfree_rcu_nolock(ptr, kvrhf)						\
    ++do {										\
    ++	typeof (ptr) ___p = (ptr);						\
    ++										\
    ++	if (___p) {								\
    ++		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >= 4096);		\
    ++		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
    ++	}									\
     +} while (0)
     +
      /*
       * Place this after a lock-acquisition primitive to guarantee that
       * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
     
    - ## mm/slab.h ##
    -@@ mm/slab.h: void __check_heap_object(const void *ptr, unsigned long n,
    - 			 const struct slab *slab, bool to_user);
    - 
    - void deferred_work_barrier(void);
    -+void defer_kfree_rcu(struct rcu_head *head);
    - 
    - static inline bool slub_debug_orig_size(struct kmem_cache *s)
    - {
    -
      ## mm/slab_common.c ##
     @@ mm/slab_common.c: EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
      EXPORT_TRACEPOINT_SYMBOL(kfree);
      EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
      
    -+void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
    ++void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr)
     +{
     +	struct slab *slab;
     +	struct kmem_cache *s;
    @@ mm/slab_common.c: EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
     +	slab = virt_to_slab(ptr);
     +	s = slab->slab_cache;
     +
    -+	if (__kfree_rcu_sheaf(s, ptr, /* allow_spin = */ false))
    -+		return;
    ++	if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != numa_mem_id()))
    ++		goto fallback;
    ++
    ++	if (unlikely(!__kfree_rcu_sheaf(s, ptr, SLAB_FREE_NOLOCK)))
    ++		goto fallback;
    ++
    ++	return;
     +
    ++fallback:
     +	defer_kfree_rcu(head);
     +}
     +EXPORT_SYMBOL_GPL(kfree_call_rcu_nolock);
    @@ mm/slub.c: static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void
     -	struct llist_head *objs, *rcu_sheaves;
     +	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
      	struct llist_node *llnode, *pos, *t;
    + 	struct slab_sheaf *sheaf, *next;
      
      	dpw = container_of(work, struct deferred_percpu_work, work);
      	rcu_sheaves = &dpw->rcu_sheaves;
    @@ mm/slub.c: static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void
      	llnode = llist_del_all(objs);
      	llist_for_each_safe(pos, t, llnode) {
     @@ mm/slub.c: static void deferred_percpu_work_fn(struct irq_work *work)
    - 
    - 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
    + 		stat(s, FREE_SLOWPATH);
      	}
    -+
    + 
     +	llnode = llist_del_all(objs_by_rcu);
     +	llist_for_each_safe(pos, t, llnode) {
    -+		struct rcu_head *head = (struct rcu_head *)pos;
    ++		void *head = pos;
    ++		void *objp = kvmalloc_obj_start_addr(head);
     +
    -+		call_rcu(head, kvfree_rcu_cb);
    ++		kvfree_call_rcu(head, objp);
     +	}
    - }
    - 
    - static void defer_free(struct kmem_cache *s, void *head)
    ++
    + 	llnode = llist_del_all(rcu_sheaves);
    + 	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
    + 		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
     @@ mm/slub.c: static void defer_free(struct kmem_cache *s, void *head)
      		irq_work_queue(&dpw->work);
      }
      
    -+void defer_kfree_rcu(struct rcu_head *head)
    ++void defer_kfree_rcu(struct kvfree_rcu_head *head)
     +{
     +	struct deferred_percpu_work *dpw;
     +
 8:  c467c0a3cdfa <  -:  ------------ mm/slab: introduce struct kfree_rcu_head and use in kfree_rcu_nolock()
 9:  d4cdda36b1c3 <  -:  ------------ slub_kunit: extend the test for kfree_rcu_nolock()
 -:  ------------ >  8:  f5c8670195d4 slub_kunit: extend the test for kfree_rcu_nolock()

Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
Harry Yoo (Oracle) (8):
      mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
      mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
      mm/slab: use call_rcu() in unknown context if irqs are enabled
      mm/slab: extend deferred free mechanism to handle rcu sheaves
      mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
      mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
      mm/slab: introduce kfree_rcu_nolock()
      slub_kunit: extend the test for kfree_rcu_nolock()

 include/linux/rcupdate.h   |  29 +++++-
 include/linux/types.h      |   8 ++
 include/trace/events/rcu.h |   2 +-
 lib/tests/slub_kunit.c     | 190 ++++++++++++++++++++++++++++-----------
 mm/slab.h                  |  48 +++++++++-
 mm/slab_common.c           |  62 +++++++++----
 mm/slub.c                  | 220 ++++++++++++++++++++++++++++-----------------
 7 files changed, 404 insertions(+), 155 deletions(-)
---
base-commit: 56aa9b819edce4acfa879728af56534c951d1818
change-id: 20260615-kfree_rcu_nolock-e5502555992f

Best regards,
-- 
Harry Yoo (Oracle) <harry@kernel.org>


