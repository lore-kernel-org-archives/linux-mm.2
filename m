Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5285C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C402B6B00D9; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16BA6B00D8; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7686B00DC; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 777C66B00D8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC752A062E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:20:59 +0000 (UTC)
X-FDA: 85041118638.26.8C67C72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CDE040003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:20:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG1zfCX8;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3vSNPJgv5E2gYJne+Xd5BiztmXYO4tqiJGpiUuLXKWI=;
	b=wUmxSZpNXzRRb+jX5b+le9GcUqMXap83ZEfiZVLYM5bij3XCewuNhNXCQozPwDxb+o/S4s
	kylfE77IMX749h9EkDc23nRPQWjrFRymMc5GkSw3xW/xNZwthGSPzuQHxKVcbiag2AwKzl
	YGLoGMG3ZSgsQLUUkHnZFdwDRCBh9Ac=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG1zfCX8;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313258;
	b=og8TE2/w02FsQ2md/GLnzeZLEfB5SMGz5yDVhxntfgzgzOwmllOy80/014Ji/2dUw0XAIa
	+eaerOtuFeb4len/GdVai0idqJthEuxiRkMtkzhCdk3UEN3uX87yVj/h+rS0XSXXXKUtET
	dN8x+XmR9hdex0OTPhxz0frN48ap8mQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1500B42D8D;
	Wed, 29 Jul 2026 08:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F3B1F000E9;
	Wed, 29 Jul 2026 08:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313257;
	bh=3vSNPJgv5E2gYJne+Xd5BiztmXYO4tqiJGpiUuLXKWI=;
	h=From:Subject:Date:To:Cc;
	b=OG1zfCX8GKT1rVYX/2L6TpLiHskO5w0F9qcO5PFk360YpfbHnw5sQyEPeBNJ06JpT
	 imJGzW517ubWqJVSI32BeoamdRJVQdqxH/ZPepGsuWMxOte1ciUVbFvWpDGT+ebzdE
	 Zy1aPcJpQRs5EKHQ3hfbM/oaUuwKRaGo+Yo54whanvqIBybz2Eb+ALxC9FEAkasJ6v
	 qJDOGAIUn/huuMXq9ryapg7G6kI34y2ZbBDbk54viNAAKfcE7Rp7MJXK30aduULRYC
	 NUD6of7Uvp99v0Z01xsPpo5IQRwgVZDfCjQAJPf7UoVLWt77NpdckMas7VEUeeCCKQ
	 RHX11eevAUfdA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH v5 0/8] mm/slab: introduce kfree_rcu_nolock() and improve
 slub_kunit coverage
Date: Wed, 29 Jul 2026 17:20:08 +0900
Message-Id: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33NQQrCMBCF4atI1kbSJNNQV95DpLRx0oaWRiYal
 NK7m3Yjgrj8H8w3M4tIHiM77mZGmHz0YcoB+x2zfTN1yP01N5NClqIsgA+OEGuyj3oKY7ADRwA
 hAaCqpGP57Ebo/HMjz5fcvY/3QK/tQ1Lr+gdLigtuRAPaKWOgbU8D0oTjIVDHVi3pj2Ck+CHoL
 FSlRqGsLhqNX8KyLG9XRfOg8wAAAA==
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
X-Rspamd-Queue-Id: 1CDE040003
X-Rspamd-Server: rspam01
X-Stat-Signature: 85qizisa8uzrdfifqrqg5p3sbr6rswai
X-HE-Tag: 1785313257-142602
X-HE-Meta: U2FsdGVkX1++9g2l4HUgOPzsxAk876rOF9mmjeKam5zTzn2FUcIWvtmzRkMosbtPbOJiNK0vRiGQxFa5mU++KWnrZ1aXIgm2wj7o9W1ih9xgqVvGel8v702e4yKkJBrKD5yTxjRVvJIatN0KnWZ81RnrLcTSR1g/3ENFrRqEBJGQa62Tc/QaCVMYN4MbzQenoEj8O3rZDrijQ/NY34u9pgDByhz3nZqezHTmoduZwe3O6R0koYa4km+fktBPvDMqWCMYq2d+5fwg0vFEeAc/DTgCKnWJndGKDYjF3Loc+mP41iIk+O4DCI+P/2TKTGjf8/TrWMHziGx0DTUDbPkH9n3OPZ7Mn257cwG/GKQl+rW0Nd63wjkZXilIE3EJZlcCG9K1EO8lrflxVYjslrPy6G7QDgCwAFuYLZg8etSrgGolUZ4rQRNTW/4AhBr6gcbxL0YuN3ZireI+FCt9T8s4uYcqrkOsjXpokC2Pl0zDWDnCkNdgcyarbAdU59zsWi6zj+2f2ILLP1/XFgpsLjN7UjgjfFVwtr97UQDJEmrk/cSj/dOq9WWKVisiLxSx/DPwrfbrqAySJDOCDf3orvSSPs9Lc5niJr1ghrGXR/eDZ1G1EHiWC8PTgyXw3X2EeWpBu1De9CwrNfgT5+0o+TmPErP+WkQdPJxhgi8qZ5X5Iaf2l9fFfCmS2L3fd+lw+m+J+tj+rBT3xVsrSUA24H8TnfAzpnnzQy5deBXqCYHQCZutDdfszX3Y+s3MznKqWYcG1kPNx0aE30pYs1ljR8QSO2Fbpg3dz09W24fcowQmnMGzIEiCvMIDlvTtAQQ8pGtiSR0xx0ptPj7IPguWaPDZIRcLuj15TzyMOlRuYN+b0cvQ0W7GeMvsTHA2LKv//Od8axN5cSmvrAKVify0Et4kv+FfZmF2FmOlCziSeuqJJ86S7cdUBA2TnLMnkg38ycacxa2YvlQrsZyimcziJYn
 49B72LTV
 gCCBqVPjOxQjvWinTGXZvCsBVproGcFLHVmALB4Sok0eXokCrveAPwWRAos9elreSzg4paoWlCOmMBCAQzY/DMS6mzY85NRRtC5VVxWej868rxC4w/pE6iATM6ChPB53jIYzRTrR7K7KcHxq0DCnAeQh+quqjMpDpbpgnUZVXsROfDLdGo16eMkVeVHXmyU9Eos92DP/5OoPzDXHNPCQ8J1XgeY+M0OB/L6ODx71pnJN1/z3aUdUJGYHdfwziFlia6d9+RrDBlLbelG/jFBiwKg3iZ3i61GdHdAvxnu7F2Vv7J/lMIEVeUF178AsicugrHtZeUhXxcGitBZ/W9muL/oKKHQMSrK+wTmwOjJUVJH7QXb9clc97umFVTqEttw47LHDdVu3kqgI76qBsiIBsJu7AE10smP9IajYsbX4f6wxAel+LqE2xRQIuA861Ezr7kZTDUYu8LVZtzfyTZrfW9ZQtkJeaeD8h53pgWVvuIqRa3vxrimmLP1sbmu3J4VFVI/JHpg4W+vmH2+4qldHQ0RPtxChlutcWf/B0urKSDbbfRRwCeaABCc3+djUKEjsVwCi/23xxO/ioYgk+JakBXb2mGa0DxyP7OU0qbZU04Q43y0tAcvI1mFICE+mOx70xu1aoM1zuPEPhEh3ez3PH/cpBmoYVTgQPvYEr65vtvWzFvA0Zzc80u/Vb1uQ0s3ttnZOZdr3C4g6oyq682qpVKlN4Eg7s8IC+w+232aHWhs5A6xjZLnD7ACH2UmvE6PBISFoFzXgeVHLYZAPSrArMhhfbzuY36fMkVDPkjkTsRQUHRqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on slab/for-next (ffc64805ceba), and is also
available on git.kernel.org [4].

Changes since v4
=================
- Rebased onto slab/for-next (that now includes Vlastimil's
  objext_split work)
- Patch 1: Added Shengming's R-b (thanks!) and fixed nit pointed out
           by sashiko (kmalloc_obj() for void *):

- Patch 2: 
  - do not silently drop __GFP_RECLAIM in alloc_empty_sheaf (Vlastimil)
  - use free_flags instead of allow_spin in __free_empty_sheaf()
    (Vlastimil)
  - Added Vlastimil's R-b, thanks!
- Patch 5:
  - Added Vlastimil's R-b, thanks!
  - Fix comment that mentioned allow_spin instead of SLAB_FREE_NOLOCK
- Patch 6:
  - Keep KASAN tag when calculating the start address of the object
    (Sashiko).
  - Did not add Vlastimil's R-b due to the change above
- Patch 7:
  - Let large kmalloc/vmalloc objects always fall back and adjust
    the kfree_rcu_nolock() kerneldoc comment accordingly
    (Vlastimil)
  - Call deferred_work_barrier() before flush_rcu_sheaves_on_cache()
    for correctness (Sashiko) 
  - Do not use the rcu sheaf path w/o KVFREE_RCU_BATCHED for
    consistency. Not doing this complicates barriers.
  - Did not add Vlastimil's R-b due to changes above
- Patch 8:
  - Convert to kmalloc_obj() in patch 8 instead of patch 1
    (where the type was changed from void * to
     struct test_kfree_rcu_struct *)

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
 
[4] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kfree_rcu_nolock-v5r1

[5] kmalloc_nolock() follow-ups, including kfree_rcu_nolock(),
    https://lore.kernel.org/linux-mm/esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3

[6] v4: https://lore.kernel.org/r/20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org

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

$ b4 prep --compare-to v4
1:  53f9594e54e6 ! 1:  89762887c7fb mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
    @@ Commit message
    +    Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
     
      ## lib/tests/slub_kunit.c ##
    @@ lib/tests/slub_kunit.c: struct test_nolock_context {
     +	for (i = 0; i < NR_ITERATIONS; i++) {
     +		for (j = 0; j < NR_OBJECTS; j++) {
     +			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
    - 
    --static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
    --						       struct perf_sample_data *data,
    --						       struct pt_regs *regs)
    -+			objects[j] = kmalloc_obj(*objects[j], gfp);
    ++
    ++			objects[j] = kmalloc(64, gfp);
     +			if (!objects[j]) {
     +				j--;
     +				while (j >= 0)
    @@ lib/tests/slub_kunit.c: struct test_nolock_context {
     +			kfree(objects[j]);
     +	}
     +}
    -+
    + 
    +-static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
    +-						       struct perf_sample_data *data,
    +-						       struct pt_regs *regs)
     +static void test_nolock(struct test_nolock_context *ctx)
      {
      	void *objp;
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(s
      	ctx->callback_count++;
      }
     +#endif
    - 
    --static void test_kmalloc_kfree_nolock(struct kunit *test)
    ++
     +#ifdef CONFIG_PERF_EVENTS
     +static struct perf_event_attr hw_attr = {
     +	.type = PERF_TYPE_HARDWARE,
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(s
     +	.freq = 1,
     +	.sample_freq = 100000,
     +};
    -+
    + 
    +-static void test_kmalloc_kfree_nolock(struct kunit *test)
     +static void overflow_handler_test_nolock(struct perf_event *event,
     +					 struct perf_sample_data *data,
     +					 struct pt_regs *regs)
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(s
     +	perf_event_enable(ctx->event);
     +	return true;
     +}
    - 
    --cleanup:
    --	perf_event_disable(ctx.event);
    --	perf_event_release_kernel(ctx.event);
    ++
     +static void disable_perf_events(struct test_nolock_context *ctx)
     +{
     +	kunit_info(ctx->test, "HW perf events: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(s
     +static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
     +{
     +	struct test_nolock_context ctx = { .test = test };
    - 
    --	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
    --		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
    ++
     +	if (!enable_perf_events(&ctx))
     +		kunit_skip(test, "Failed to enable perf event, skipping");
    - 
    --	if (alloc_fail)
    --		kunit_skip(test, "Allocation failed");
    ++
     +	test_kmalloc_kfree();
     +
     +	disable_perf_events(&ctx);
    @@ lib/tests/slub_kunit.c: static void overflow_handler_test_kmalloc_kfree_nolock(s
     +static void test_kmalloc_kfree_nolock_kprobe(struct kunit *test)
     +{
     +	struct test_nolock_context ctx = { .test = test };
    -+
    + 
    +-cleanup:
    +-	perf_event_disable(ctx.event);
    +-	perf_event_release_kernel(ctx.event);
     +	if (!register_slab_kprobes(&ctx))
     +		kunit_skip(test, "Failed to register kprobe, skipping");
    -+
    + 
    +-	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
    +-		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
     +	test_kmalloc_kfree();
    -+
    + 
    +-	if (alloc_fail)
    +-		kunit_skip(test, "Allocation failed");
     +	unregister_slab_kprobes(&ctx);
      	KUNIT_EXPECT_EQ(test, 0, slab_errors);
      }
    @@ lib/tests/slub_kunit.c: static struct kunit_case test_cases[] = {
      };
     
      ## mm/slub.c ##
    -@@ mm/slub.c: static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
    +@@ mm/slub.c: static inline void slab_set_obj_exts_in_object(struct slab *slab)
      }
      #endif
      
2:  a1e7b0265e51 ! 2:  025b3ba728a5 mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
    @@ Commit message
     
         Now that slab has internal alloc_flags to describe context, introduce
         free_flags analogously and convert free_flags to alloc_flags when
    -    allocating memory in the free path. alloc_empty_sheaf() now strips
    -    __GFP_RECLAIM when SLAB_ALLOC_NOLOCK is specified.
    +    allocating memory in the free path.
     
         When trylock fails or the kernel observes non-NULL pcs->rcu_free after
         lock acquisition, free the sheaf instead of putting it to the barn.
    @@ Commit message
         kfree_rcu_sheaf() fails when the rcu sheaf becomes full.
     
    +    Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
     
      ## mm/slab.h ##
     @@
    - #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
      #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
    + #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
      
     +#define SLAB_FREE_DEFAULT	0x00 /* no flags */
     +#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
    @@ mm/slab.h
      				  unsigned int alloc_flags, int node)
      				  __assume_kmalloc_alignment __alloc_size(1);
     @@ mm/slab.h: static inline bool is_kmalloc_normal(struct kmem_cache *s)
    - 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
    + 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT|SLAB_NO_OBJ_EXT));
      }
      
     -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
    @@ mm/slab_common.c: static bool kfree_rcu_sheaf(void *obj)
     
      ## mm/slub.c ##
     @@ mm/slub.c: static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
    - 
    - 	gfp &= ~OBJCGS_CLEAR_MASK;
    - 
    -+	if (alloc_flags & SLAB_ALLOC_NOLOCK)
    -+		gfp &= ~__GFP_RECLAIM;
    -+
      	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
      }
      
     -static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
     +static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
    -+			       bool allow_spin)
    ++			       unsigned int free_flags)
      {
      	/*
      	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
    @@ mm/slub.c: static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf
      	VM_WARN_ON_ONCE(sheaf->size > 0);
     -	kfree(sheaf);
     +
    -+	if (likely(allow_spin))
    -+		kfree(sheaf);
    -+	else
    ++	if (unlikely(free_flags & SLAB_FREE_NOLOCK))
     +		kfree_nolock(sheaf);
    ++	else
    ++		kfree(sheaf);
      
      	stat(s, SHEAF_FREE);
      }
      
     +static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
     +{
    -+	__free_empty_sheaf(s, sheaf, /* allow_spin = */ true);
    ++	__free_empty_sheaf(s, sheaf, SLAB_FREE_DEFAULT);
     +}
     +
      static unsigned int
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
      		struct slab_sheaf *empty;
      		struct node_barn *barn;
     +		unsigned int alloc_flags = to_alloc_flags(free_flags);
    ++		gfp_t gfp = allow_spin ? GFP_NOWAIT : __GFP_NOWARN;
      
      		/* Bootstrap or debug cache, fall back */
      		if (unlikely(!cache_has_sheaves(s))) {
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
      		local_unlock(&s->cpu_sheaves->lock);
      
     -		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
    -+		empty = alloc_empty_sheaf(s, GFP_NOWAIT, alloc_flags);
    ++		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
      
      		if (!empty)
      			goto fail;
      
      		if (!local_trylock(&s->cpu_sheaves->lock)) {
     -			barn_put_empty_sheaf(barn, empty);
    -+			__free_empty_sheaf(s, empty, allow_spin);
    ++			__free_empty_sheaf(s, empty, free_flags);
      			goto fail;
      		}
      
    @@ mm/slub.c: bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
      
      		if (unlikely(pcs->rcu_free))
     -			barn_put_empty_sheaf(barn, empty);
    -+			__free_empty_sheaf(s, empty, allow_spin);
    ++			__free_empty_sheaf(s, empty, free_flags);
      		else
      			pcs->rcu_free = empty;
      	}
3:  f63010ae4b65 = 3:  54211dde1020 mm/slab: use call_rcu() in unknown context if irqs are enabled
4:  c7f5ae27c323 = 4:  cb93a68b5183 mm/slab: extend deferred free mechanism to handle rcu sheaves
5:  5e3eceee103b ! 5:  6190f2484d9b mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
    @@ Commit message
    +    Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
     
      ## mm/slab_common.c ##
    @@ mm/slub.c: static void rcu_free_sheaf(struct rcu_head *head)
       * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
       * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
     - * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
    -+ * this problem by passing allow_spin = false on PREEMPT_RT.
    ++ * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
       *
       * However, lockdep still complains that it is invalid to acquire spinlock_t
       * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
6:  a15d4da6efbc ! 6:  2e7eefe35a29 mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
    @@ Commit message
         Stop storing the object pointer in rcu_head.func and instead calculate
         the object's start address in kvfree_rcu_list(). Factor out the existing
         logic to calculate the start address from kvfree_rcu_cb() to
    -    kvmalloc_obj_start_addr().
    +    kvmalloc_obj_start_addr(). To avoid losing the KASAN tag, calculate
    +    the offset and subtract it from the address of the kvfree_rcu_head.
     
     
    @@ include/trace/events/rcu.h: TRACE_EVENT_RCU(rcu_invoke_callback,
      
     
      ## mm/slab.h ##
    -@@ mm/slab.h: static inline int objs_per_slab(const struct kmem_cache *cache,
    - 	return slab->objects;
    +@@ mm/slab.h: static inline unsigned int obj_to_index(const struct kmem_cache *cache,
    + 	return __obj_to_index(cache, slab_address(slab), obj);
      }
      
    -+/* kvfree_rcu_head offset can be only less than page size */
    ++/*
    ++ * kvfree_rcu_head offset can be only less than page size.
    ++ * Calculate the start address while preserving the KASAN tag.
    ++ */
     +static inline void *kvmalloc_obj_start_addr(void *head)
     +{
    -+	void *obj = head;
    ++	unsigned long offset;
     +
    -+	if (unlikely(is_vmalloc_addr(obj))) {
    -+		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
    ++	if (unlikely(is_vmalloc_addr(head))) {
    ++		offset = offset_in_page(head);
     +	} else {
    -+		struct page *page = virt_to_page(obj);
    -+		struct slab *slab = page_slab(page);
    ++		struct slab *slab = virt_to_slab(head);
     +
     +		if (!slab) {
    -+			obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
    -+		} else if (is_kfence_address(obj)) {
    -+			obj = kfence_object_start(obj);
    ++			offset = offset_in_page(head);
    ++		} else if (is_kfence_address(head)) {
    ++			offset = head - kfence_object_start(head);
     +		} else {
     +			struct kmem_cache *s = slab->slab_cache;
    -+			unsigned int idx = __obj_to_index(s, slab_address(slab), obj);
    ++			unsigned int idx = __obj_to_index(s, slab_address(slab), head);
    ++			void *obj = slab_address(slab) + s->size * idx;
     +
    -+			obj = slab_address(slab) + s->size * idx;
     +			obj = fixup_red_left(s, obj);
    ++			obj = kasan_reset_tag(obj);
    ++			offset = kasan_reset_tag(head) - obj;
     +		}
     +	}
     +
    -+	return obj;
    ++	return head - offset;
     +}
     +
      /*
7:  a7e9dbb20f5b ! 7:  c65397db54e8 mm/slab: introduce kfree_rcu_nolock()
    @@ Commit message
         now that kfree_rcu_sheaf() is available on PREEMPT_RT and
         __kfree_rcu_sheaf() handles unknown context.
     
    -    kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
    -    path fails. In most cases, the sheaves path is expected to succeed
    -    and it's unnecessary to add complexity to the existing kvfree_rcu
    -    batching by teaching it how to handle unknown context.
    +    When sheaves path fails, kfree_rcu_nolock() falls back to
    +    defer_kfree_rcu() that uses an irq work to free the object via
    +    kvfree_call_rcu(). In most cases, the sheaves path is expected to
    +    succeed and therefore it's unnecessary to introduce additional
    +    complexity to the existing kvfree_rcu batching by teaching it
    +    how to handle unknown context.
     
         Since defer_kfree_rcu() can be called on caches without sheaves, move
         deferred_work_barrier() and rcu_barrier() outside the branch in
         kvfree_rcu_barrier_on_cache().
     
    +    Now that deferred kvfree_rcu objects are submitted to kvfree_call_rcu()
    +    after deferred_work_barrier() and may end up in RCU sheaves,
    +    deferred_work_barrier() must be invoked before
    +    flush_rcu_sheaves_on_cache().
    +
    +    Since the RCU sheaf path has not been used on !KVFREE_RCU_BATCHED
    +    kernels, always fall back when kvfree_rcu() is not batched, for
    +    consistency. kvfree_rcu_barrier{,_on_cache()}() on
    +    !KVFREE_RCU_BATCHED are moved to mm/slab_common.c to invoke
    +    deferred_work_barrier() before rcu_barrier().
    +
     
      ## include/linux/rcupdate.h ##
    @@ include/linux/rcupdate.h: do {								\
     + * @ptr: pointer to kfree for double-argument invocations.
     + * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
     + *
    -+ * Objects that are not allocated via kmalloc_nolock() are not supported.
    ++ * With KVFREE_RCU_BATCHED, kfree_rcu_nolock() tries hard to free objects
    ++ * without any deferred processing, but may still defer freeing.
    ++ * Large kmalloc and vmalloc objects are always deferred.
    ++ *
     + * kfree_rcu_nolock() supports 2-arg variant only.
     + */
     +#define kfree_rcu_nolock(ptr, kvrhf)						\
    @@ include/linux/rcupdate.h: do {								\
       * Place this after a lock-acquisition primitive to guarantee that
       * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
     
    + ## include/linux/slab.h ##
    +@@ include/linux/slab.h: extern void kvfree_sensitive(const void *addr, size_t len);
    + unsigned int kmem_cache_size(struct kmem_cache *s);
    + 
    + #ifndef CONFIG_KVFREE_RCU_BATCHED
    +-static inline void kvfree_rcu_barrier(void)
    +-{
    +-	rcu_barrier();
    +-}
    +-
    +-static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
    +-{
    +-	rcu_barrier();
    +-}
    +-
    + static inline void kfree_rcu_scheduler_running(void) { }
    + #else
    ++void kfree_rcu_scheduler_running(void);
    ++#endif
    ++
    + void kvfree_rcu_barrier(void);
    + 
    + void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);
    + 
    +-void kfree_rcu_scheduler_running(void);
    +-#endif
    +-
    + /**
    +  * kmalloc_size_roundup - Report allocation bucket size for the given size
    +  *
    +
      ## mm/slab_common.c ##
     @@ mm/slab_common.c: EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
      EXPORT_TRACEPOINT_SYMBOL(kfree);
    @@ mm/slab_common.c: EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
     +void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr)
     +{
     +	struct slab *slab;
    -+	struct kmem_cache *s;
     +
    -+	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
    ++	if (!IS_ENABLED(CONFIG_KVFREE_RCU_BATCHED))
    ++		goto fallback;
    ++
    ++	if (unlikely(is_vmalloc_addr(ptr)))
    ++		goto fallback;
     +
     +	slab = virt_to_slab(ptr);
    -+	s = slab->slab_cache;
    ++	if (unlikely(!slab))
    ++		goto fallback;
     +
     +	if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != numa_mem_id()))
     +		goto fallback;
     +
    -+	if (unlikely(!__kfree_rcu_sheaf(s, ptr, SLAB_FREE_NOLOCK)))
    ++	if (unlikely(!__kfree_rcu_sheaf(slab->slab_cache, ptr, SLAB_FREE_NOLOCK)))
     +		goto fallback;
     +
     +	return;
    @@ mm/slab_common.c: EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
      #ifndef CONFIG_KVFREE_RCU_BATCHED
      
      void kvfree_call_rcu(struct rcu_head *head, void *ptr)
    -@@ mm/slab_common.c: void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
    +@@ mm/slab_common.c: void kvfree_call_rcu(struct rcu_head *head, void *ptr)
    + }
    + EXPORT_SYMBOL_GPL(kvfree_call_rcu);
    + 
    ++void kvfree_rcu_barrier(void)
    ++{
    ++	deferred_work_barrier();
    ++	rcu_barrier();
    ++}
    ++EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
    ++
    ++void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
    ++{
    ++	deferred_work_barrier();
    ++	rcu_barrier();
    ++}
    ++EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
    ++
    + void __init kvfree_rcu_init(void)
    + {
    + }
    +@@ mm/slab_common.c: EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
    +  */
    + void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
    + {
    ++	/* kfree_rcu_nolock() might have deferred frees even without sheaves */
    ++	deferred_work_barrier();
    ++
    + 	if (cache_has_sheaves(s)) {
      		cpus_read_lock();
      		flush_rcu_sheaves_on_cache(s);
      		cpus_read_unlock();
    @@ mm/slab_common.c: void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
     -		rcu_barrier();
      	}
      
    -+	/* kfree_rcu_nolock() might have deferred frees even without sheaves */
    -+	deferred_work_barrier();
     +	rcu_barrier();
      	__kvfree_rcu_barrier();
      }
    @@ mm/slub.c: static void deferred_percpu_work_fn(struct irq_work *work);
      	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
      	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
      };
    +@@ mm/slub.c: void flush_all_rcu_sheaves(void)
    + {
    + 	struct kmem_cache *s;
    + 
    ++	deferred_work_barrier();
    ++
    + 	cpus_read_lock();
    + 	mutex_lock(&slab_mutex);
    + 
    +@@ mm/slub.c: void flush_all_rcu_sheaves(void)
    + 	mutex_unlock(&slab_mutex);
    + 	cpus_read_unlock();
    + 
    +-	deferred_work_barrier();
    + 	rcu_barrier();
    + }
    + 
     @@ mm/slub.c: static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
      static void deferred_percpu_work_fn(struct irq_work *work)
      {
    @@ mm/slub.c: static void defer_free(struct kmem_cache *s, void *head)
     +		irq_work_queue(&dpw->work);
     +}
     +
    ++/* Must be called before flush_rcu_sheaves_on_cache() */
      void deferred_work_barrier(void)
      {
      	int cpu;
8:  8e69c83a1e52 ! 8:  aeaf2ab60046 slub_kunit: extend the test for kfree_rcu_nolock()
    @@ lib/tests/slub_kunit.c: struct test_nolock_context {
     -			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
     +			gfp_t gfp = (i & 1) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
      
    - 			objects[j] = kmalloc_obj(*objects[j], gfp);
    +-			objects[j] = kmalloc(64, gfp);
    ++			objects[j] = kmalloc_obj(*objects[j], gfp);
      			if (!objects[j]) {
    + 				j--;
    + 				while (j >= 0)
     @@ lib/tests/slub_kunit.c: static void test_kmalloc_kfree(void)
      			}
      		}

Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
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

 include/linux/rcupdate.h   |  32 ++++++-
 include/linux/slab.h       |  16 +---
 include/linux/types.h      |   8 ++
 include/trace/events/rcu.h |   2 +-
 lib/tests/slub_kunit.c     | 190 ++++++++++++++++++++++++++++-----------
 mm/slab.h                  |  52 ++++++++++-
 mm/slab_common.c           |  81 +++++++++++++----
 mm/slub.c                  | 220 ++++++++++++++++++++++++++++-----------------
 8 files changed, 433 insertions(+), 168 deletions(-)
---
base-commit: ffc64805cebac330b2a60b2f1f144fcc35b8ab46
change-id: 20260615-kfree_rcu_nolock-e5502555992f

Best regards,
-- 
Harry Yoo (Oracle) <harry@kernel.org>


