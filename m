Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 442EDC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 03:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CED6B00C4; Tue, 21 Jul 2026 23:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7C86B00C5; Tue, 21 Jul 2026 23:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91406B00C6; Tue, 21 Jul 2026 23:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEEF6B00C4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:28:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 136B1802E0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:28:13 +0000 (UTC)
X-FDA: 85014979266.29.640CB13
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97122120007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:28:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784690891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AFpJcjMhnwq/UTMWYcmf0zzuy6n7nRfEQaty6IcZ99g=;
	b=NRBKpht0ASaPzPMlODhhqTRQ0JDcbZZn3sx86/NHp0DSexZiUFgSqafWwR2XzBnHYyox0F
	EW2m6uMe/kgIg3kNecNzwl0vGZl4KjwSdZsRdvP/wqddjTRfmzJ322WyAYPlqYd3pqq7nA
	HK+S9g9jbBoN5iNFJj/AXmjrFnP2J/A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784690891;
	b=5TaJq75zNZ9p7WOmh5wLUlXabZuyWKxVMntEA51/jBTwIuWWUAuNZTqvg9ZU6QIBEjVXkU
	soOydauSMEJfrleyriNP50UL+GZhD7g+dgIwCm8BvaTygcCWCxX2XmXkbRJJtkSDCTmsJN
	D0k5SH0aJyIfXIIjnqVAGhswLUgMZRg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h4fpW4Jhgz4xPSw;
	Wed, 22 Jul 2026 11:28:03 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 66M3RlRs026462;
	Wed, 22 Jul 2026 11:27:47 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 22 Jul 2026 11:27:48 +0800 (CST)
X-Zmail-TransId: 2afc6a6038b44fe-0aa85
X-Mailer: Zmail v1.0
Message-ID: <20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-1-964e03c41a4e@kernel.org>
References: 20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org,20260720-kfree_rcu_nolock-v4-1-964e03c41a4e@kernel.org
Date: Wed, 22 Jul 2026 11:27:48 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <ast@kernel.org>, <andrii@kernel.org>, <puranjay@kernel.org>,
        <ameryhung@gmail.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <neeraj.upadhyay@kernel.org>, <joelagnelf@nvidia.com>,
        <josh@joshtriplett.org>, <boqun@kernel.org>, <urezki@gmail.com>,
        <mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
        <qiang.zhang@linux.dev>, <pfalcato@suse.de>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>, <rcu@vger.kernel.org>,
        <bpf@vger.kernel.org>, <harry@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzbGFiL2Zvci1uZXh0IHY0IDEvOF0gbW0vc2xhYiwgc2x1Yl9rdW5pdDogcmVnaXN0ZXIga3Byb2JlIHRvIHRyaWdnZXIgX25vbG9jayBBUElz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66M3RlRs026462
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 22 Jul 2026 11:28:03 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A6038C3.000/4h4fpW4Jhgz4xPSw
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97122120007
X-Stat-Signature: tboi6w5pj8rtje4bjeyt7fbkb3dz9eh8
X-HE-Tag: 1784690889-836645
X-HE-Meta: U2FsdGVkX196JwiYij/FTAYAanIjS54dh9Q6q6nBjQ5+dDAEWy6ZZSZQAzctImLiw/aDxCE529wBl9BTxWSdbJsuFxBox2N7wY5j2cCImsaoT2sxaRWS0UTvNLKSNL8tsLf25YXkMZbm3C87/CPOjvLR4T1JUzZrOlnjnTbcUVYjDjPfgFhEOLezTBCHLaVe0BTPUKyanMSk+1q0zIbQi9GKtjrRYTyuTtecKSvu944DFrXpL1Nm+ukansTb+g03irSSIvrkSsFL0lx/fFLoExJs/zrDGw9dEcOEPJh9TgQ5B8pRMPNwAQOsiJ98T1D6a88ObZvDaj4TdnbN553gpv2Q80kL167l5LCurMBBMS/yxXRhz93fYaYO2budz5DJdk7XrDdpCda0F4/xPe+aiCrimlxCAdwizDRejuiqwCk3J/ObXQTw3TelXkevG9EAXB9VXRsfhS8UcSge0nP57eUJ5704qppSA2SfJGCCNvaJRZzCqkzug1wgiEOtm1Ft2/gv8UrNqcD6ogzEaCc3ZAT7E7cCGBsDPAzn4dxYFfg4lWzeMrIYOHa7zjg6MKEgawDzPDQNhoT4sr7Ct8n90eH7WO8Uo6/e3Fy6ADZ5tXC8TN/5fj15DWTI06itzkNDZim8G6js98pt2/JNuoutWDZFXTT48CFoNR0+am0JV+lWxU08o42DQe+4vlZboCX9Vk3jPEPC3/gsR6TgKmpzA6P3T4mp8i2jSNGV2zdEV0fNzQrXCAnSJrAtUypwPPnj5oOxXuFgrHlQ2bxx4YHF/n41wCClqDLs155pEeyA3vI8Wtf4C1WwlyG36ak+zulbT1wAk/H7MVeZvmcAuu1DUk3x+GvfchhDfuU0NNY4NgMsA7T3QSGBmtMO0LiY+v5lxXEPFGZ9RG6PRpByO11mzjhPD20hdKM97MESujTLL0AaMPjaPGQ0xGS1agBzcIZHSsYKmbi7/uR0Cl8IBRq
 lLvxBnF3
 AZDpA/op6KRPnh7wRbsxffP6EKf9qKw5Vce2t7ZqN6oTjBu5pWJLawDJZVvtBGGUlLy/ul02XvMhXbWy24UcnCzJBMTGUeluSKVaFn/YS95Hu3p2qeKdvN9aOuWc7YbuSX18AKwo+VVOz2Z79fxvfbSxUSGsoaKp9Qt9TfPukgvovX0GnPQ+gf6WV/Z8e50NytjMUgrTSSVHVuCMPgopBlwI5ZjtC85ZYAMD3aPoE+lkUtD5qMXJ20I/ZuBMLdYstZ+heD6DbEvY/OKeuZ3g7mByhbmiyibL2kLOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
> 
> Register a kprobe pre-handler to invoke kmalloc_nolock() and
> kfree_nolock() in the middle of the slab allocator. However, do not
> register the handler on UP kernels because that use case is not
> well supported [1] in the kernel.
> 
> To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
> is held, add a wrapper function for lockdep_assert_held() that calls
> a no-op function slab_attach_kprobe_locked() on debug builds. The
> function is optimized away when neither CONFIG_PROVE_LOCKING nor
> CONFIG_DEBUG_VM is selected and register_kprobe() fails.
> 
> The function calls barrier() to prevent the compiler from optimizing
> away its callsites. Otherwise, the compiler may consider the function
> does not have any side effect and remove callsites.
> 
> Compared to using plain kprobe, this has two advantages: 1) it avoids
> hardcoding function names in the test, and 2) it can trigger those APIs
> in the middle of a function, where the lock is expected to be held as
> annotated with lockdep.
> 
> While it was proposed [2] to use kunit function redirection to test
> this, it is currently infeasible as some lock helpers don't have
> symbols.
> 
> Factor out the nested loop that calls kmalloc and friends to
> test_kmalloc_kfree(), and call them in
> test_kmalloc_kfree_nolock_{perf,kprobe}(), each being an independent
> test case. During the refactoring, drop alloc_fail handling as it
> doesn't provide much benefits.

Nice test addition!

Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

Nit below:

> Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
> Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  lib/tests/slub_kunit.c | 167 +++++++++++++++++++++++++++++++++++--------------
>  mm/slub.c              |  36 ++++++++---
>  2 files changed, 148 insertions(+), 55 deletions(-)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index fa6d31dbca16..a391467c1aa6 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -8,6 +8,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/delay.h>
>  #include <linux/perf_event.h>
> +#include <linux/kprobes.h>
>  #include "../mm/slab.h"
>  
>  static struct kunit_resource resource;
> @@ -292,7 +293,7 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
>      kmem_cache_destroy(s);
>  }
>  
> -#ifdef CONFIG_PERF_EVENTS
> +#if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
>  #define NR_ITERATIONS 1000
>  #define NR_OBJECTS 1000
>  static void *objects[NR_OBJECTS];
> @@ -302,26 +303,40 @@ struct test_nolock_context {
>      int callback_count;
>      int alloc_ok;
>      int alloc_fail;
> +#ifdef CONFIG_PERF_EVENTS
>      struct perf_event *event;
> +#endif
> +#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
> +    struct kprobe kprobe;
> +#endif
>  };
>  
> -static struct perf_event_attr hw_attr = {
> -    .type = PERF_TYPE_HARDWARE,
> -    .config = PERF_COUNT_HW_CPU_CYCLES,
> -    .size = sizeof(struct perf_event_attr),
> -    .pinned = 1,
> -    .disabled = 1,
> -    .freq = 1,
> -    .sample_freq = 100000,
> -};
> +static void test_kmalloc_kfree(void)
> +{
> +    int i, j;
> +
> +    for (i = 0; i < NR_ITERATIONS; i++) {
> +        for (j = 0; j < NR_OBJECTS; j++) {
> +            gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>  
> -static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
> -                               struct perf_sample_data *data,
> -                               struct pt_regs *regs)
> +            objects[j] = kmalloc_obj(*objects[j], gfp);
> +            if (!objects[j]) {
> +                j--;
> +                while (j >= 0)
> +                    kfree(objects[j--]);
> +                return;
> +            }
> +        }
> +
> +        for (j = 0; j < NR_OBJECTS; j++)
> +            kfree(objects[j]);
> +    }
> +}
> +
> +static void test_nolock(struct test_nolock_context *ctx)
>  {
>      void *objp;
>      gfp_t gfp;
> -    struct test_nolock_context *ctx = event->overflow_handler_context;
>  
>      /* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
>      gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
> @@ -335,47 +350,104 @@ static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
>      kfree_nolock(objp);
>      ctx->callback_count++;
>  }
> +#endif
>  
> -static void test_kmalloc_kfree_nolock(struct kunit *test)
> +#ifdef CONFIG_PERF_EVENTS
> +static struct perf_event_attr hw_attr = {
> +    .type = PERF_TYPE_HARDWARE,
> +    .config = PERF_COUNT_HW_CPU_CYCLES,
> +    .size = sizeof(struct perf_event_attr),
> +    .pinned = 1,
> +    .disabled = 1,
> +    .freq = 1,
> +    .sample_freq = 100000,
> +};
> +
> +static void overflow_handler_test_nolock(struct perf_event *event,
> +                     struct perf_sample_data *data,
> +                     struct pt_regs *regs)
> +{
> +    struct test_nolock_context *ctx = event->overflow_handler_context;
> +
> +    test_nolock(ctx);
> +}
> +
> +static bool enable_perf_events(struct test_nolock_context *ctx)
>  {
> -    int i, j;
> -    struct test_nolock_context ctx = { .test = test };
>      struct perf_event *event;
> -    bool alloc_fail = false;
>  
>      event = perf_event_create_kernel_counter(&hw_attr, -1, current,
> -                         overflow_handler_test_kmalloc_kfree_nolock,
> -                         &ctx);
> +                         overflow_handler_test_nolock,
> +                         ctx);
> +
>      if (IS_ERR(event))
> -        kunit_skip(test, "Failed to create perf event");
> -    ctx.event = event;
> -    perf_event_enable(ctx.event);
> -    for (i = 0; i < NR_ITERATIONS; i++) {
> -        for (j = 0; j < NR_OBJECTS; j++) {
> -            gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
> +        return false;
>  
> -            objects[j] = kmalloc(64, gfp);
> -            if (!objects[j]) {
> -                j--;
> -                while (j >= 0)
> -                    kfree(objects[j--]);
> -                alloc_fail = true;
> -                goto cleanup;
> -            }
> -        }
> -        for (j = 0; j < NR_OBJECTS; j++)
> -            kfree(objects[j]);
> -    }
> +    ctx->event = event;
> +    perf_event_enable(ctx->event);
> +    return true;
> +}
>  
> -cleanup:
> -    perf_event_disable(ctx.event);
> -    perf_event_release_kernel(ctx.event);
> +static void disable_perf_events(struct test_nolock_context *ctx)
> +{
> +    kunit_info(ctx->test, "HW perf events: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
> +           ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
> +
> +    perf_event_disable(ctx->event);
> +    perf_event_release_kernel(ctx->event);
> +}
> +
> +static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
> +{
> +    struct test_nolock_context ctx = { .test = test };
>  
> -    kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
> -           ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
> +    if (!enable_perf_events(&ctx))
> +        kunit_skip(test, "Failed to enable perf event, skipping");
>  
> -    if (alloc_fail)
> -        kunit_skip(test, "Allocation failed");
> +    test_kmalloc_kfree();
> +
> +    disable_perf_events(&ctx);
> +    KUNIT_EXPECT_EQ(test, 0, slab_errors);
> +}
> +#endif
> +

Maybe it would be worth checking that the perf event actually fired:

    KUNIT_EXPECT_GT(test, ctx.callback_count, 0);

Otherwise, the test could pass without the callback.

> +#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
> +static int slab_kprobe_pre_handler(struct kprobe *p, struct pt_regs *regs)
> +{
> +    struct test_nolock_context *ctx;
> +
> +    ctx = container_of(p, struct test_nolock_context, kprobe);
> +    test_nolock(ctx);
> +    return 0;
> +}
> +
> +static bool register_slab_kprobes(struct test_nolock_context *ctx)
> +{
> +    ctx->kprobe.symbol_name = "slab_attach_kprobe_locked";
> +    ctx->kprobe.pre_handler = slab_kprobe_pre_handler;
> +
> +    if (register_kprobe(&ctx->kprobe))
> +        return false;
> +    return true;
> +}
> +
> +static void unregister_slab_kprobes(struct test_nolock_context *ctx)
> +{
> +    kunit_info(ctx->test, "kprobes: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
> +           ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
> +    unregister_kprobe(&ctx->kprobe);
> +}
> +
> +static void test_kmalloc_kfree_nolock_kprobe(struct kunit *test)
> +{
> +    struct test_nolock_context ctx = { .test = test };
> +
> +    if (!register_slab_kprobes(&ctx))
> +        kunit_skip(test, "Failed to register kprobe, skipping");
> +
> +    test_kmalloc_kfree();
> +
> +    unregister_slab_kprobes(&ctx);
>      KUNIT_EXPECT_EQ(test, 0, slab_errors);
>  }

Same here. Maybe it would be useful to check that the kprobe handler was
invoked at least once:

    KUNIT_EXPECT_GT(test, ctx.callback_count, 0);

--
With Best Regards,
Shengming

>  #endif
> @@ -405,7 +477,10 @@ static struct kunit_case test_cases[] = {
>      KUNIT_CASE(test_leak_destroy),
>      KUNIT_CASE(test_krealloc_redzone_zeroing),
>  #ifdef CONFIG_PERF_EVENTS
> -    KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
> +    KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_perf),
> +#endif
> +#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
> +    KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_kprobe),
>  #endif
>      {}
>  };
> diff --git a/mm/slub.c b/mm/slub.c
> index da9efb040040..e32a68677537 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -908,6 +908,24 @@ static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
>  }
>  #endif
>  
> +/*
> + * A no-op function used to attach kprobe handlers in slub_kunit tests.
> + * The barrier is needed to prevent the compiler from optimizing out callsites.
> + */
> +#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PROVE_LOCKING)
> +static noinline void slab_attach_kprobe_locked(void)
> +{
> +    barrier();
> +}
> +#else
> +static inline void slab_attach_kprobe_locked(void) { }
> +#endif
> +
> +#define slab_lockdep_assert_held(lock) do {    \
> +    lockdep_assert_held(lock);        \
> +    slab_attach_kprobe_locked();    \
> +} while (0)
> +
>  #ifdef CONFIG_SLUB_DEBUG
>  
>  /*
> @@ -1665,7 +1683,7 @@ static void add_full(struct kmem_cache *s,
>      if (!(s->flags & SLAB_STORE_USER))
>          return;
>  
> -    lockdep_assert_held(&n->list_lock);
> +    slab_lockdep_assert_held(&n->list_lock);
>      list_add(&slab->slab_list, &n->full);
>  }
>  
> @@ -1674,7 +1692,7 @@ static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct
>      if (!(s->flags & SLAB_STORE_USER))
>          return;
>  
> -    lockdep_assert_held(&n->list_lock);
> +    slab_lockdep_assert_held(&n->list_lock);
>      list_del(&slab->slab_list);
>  }
>  
> @@ -2868,7 +2886,7 @@ static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
>      void *objects[PCS_BATCH_MAX];
>      struct slab_sheaf *sheaf;
>  
> -    lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +    slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
>      pcs = this_cpu_ptr(s->cpu_sheaves);
>      sheaf = pcs->main;
> @@ -3547,7 +3565,7 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
>  static inline void add_partial(struct kmem_cache_node *n,
>                  struct slab *slab, enum add_mode mode)
>  {
> -    lockdep_assert_held(&n->list_lock);
> +    slab_lockdep_assert_held(&n->list_lock);
>      __add_partial(n, slab, mode);
>  }
>  
> @@ -3561,7 +3579,7 @@ static inline void clear_node_partial_state(struct kmem_cache_node *n,
>  static inline void remove_partial(struct kmem_cache_node *n,
>                      struct slab *slab)
>  {
> -    lockdep_assert_held(&n->list_lock);
> +    slab_lockdep_assert_held(&n->list_lock);
>      list_del(&slab->slab_list);
>      clear_node_partial_state(n, slab);
>  }
> @@ -3577,7 +3595,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>  {
>      void *object;
>  
> -    lockdep_assert_held(&n->list_lock);
> +    slab_lockdep_assert_held(&n->list_lock);
>  
>  #ifdef CONFIG_SLUB_DEBUG
>      if (s->flags & SLAB_CONSISTENCY_CHECKS) {
> @@ -4642,7 +4660,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>      struct node_barn *barn;
>      bool allow_spin;
>  
> -    lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +    slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
>      /* Bootstrap or debug cache, back off */
>      if (unlikely(!cache_has_sheaves(s))) {
> @@ -5765,7 +5783,7 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
>          struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
>          struct node_barn *barn)
>  {
> -    lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +    slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
>      /* This is what we expect to find if nobody interrupted us. */
>      if (likely(!pcs->spare)) {
> @@ -5816,7 +5834,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>      bool put_fail;
>  
>  restart:
> -    lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +    slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
>      /* Bootstrap or debug cache, back off */
>      if (unlikely(!cache_has_sheaves(s))) {
> 
> -- 
> 2.53.0

