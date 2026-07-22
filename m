Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179C0C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43B26B008C; Wed, 22 Jul 2026 04:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF45D6B0093; Wed, 22 Jul 2026 04:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1C96B0095; Wed, 22 Jul 2026 04:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD7B6B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:32:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3D03803EB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:32:45 +0000 (UTC)
X-FDA: 85015746690.19.90FCF40
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf19.hostedemail.com (Postfix) with ESMTP id 368111A0004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:32:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784709163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOdO6RMgoF9VS6Vv3n8lrROsLZqKIbDNtt7G6Ky0O8Y=;
	b=qW3V8blAjZ6l3kj9jOAtHSUdW4FH+A3Yab2uwKQYZCuk1+hcC9B/QSVSNUUFJ/IIUWLYmx
	DjxZvQns5VFhk05SRU7YlH5+MydN9zd+LWnqwLQA3t8p7ykSKCNlqniNL0b7+27gyxm7ue
	fcUSydbvqFj+wsVOo6bwPl2/nrGL954=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784709164;
	b=BD+LDcorlO+J80YNdNqNjzmjCgBBtXZymHnd/QoLWQN55ZqyoZZVli7Wt/1wJqFW6Fsl3K
	nkcD71Wg4DksjrI27bEArev2wLzqxQzt73TWDIUYyNU3HfOd+vX8zwPIFCcrRGi/1pycFh
	x12Dsdc0bjKRL9s4CQnsdp4TNxSLF0c=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h4nYp2q18z55y2H;
	Wed, 22 Jul 2026 16:32:30 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 66M8WOxP048119;
	Wed, 22 Jul 2026 16:32:24 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 22 Jul 2026 16:32:26 +0800 (CST)
X-Zmail-TransId: 2afc6a60801acda-ec081
X-Mailer: Zmail v1.0
Message-ID: <202607221632263010RKz3KaXP9NUQ9kGPYnU_@zte.com.cn>
In-Reply-To: <004d1215-a1da-448e-bf10-df637c7029f5@kernel.org>
References: 20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn,004d1215-a1da-448e-bf10-df637c7029f5@kernel.org
Date: Wed, 22 Jul 2026 16:32:26 +0800 (CST)
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
        <bpf@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzbGFiL2Zvci1uZXh0IHY0IDEvOF0gbW0vc2xhYiwgc2x1Yl9rdW5pdDogcmVnaXN0ZXIga3Byb2JlIHRvIHRyaWdnZXIgX25vbG9jayBBUElz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66M8WOxP048119
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 22 Jul 2026 16:32:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A60801E.001/4h4nYp2q18z55y2H
X-Rspam-User: 
X-Rspamd-Queue-Id: 368111A0004
X-Rspamd-Server: rspam01
X-Stat-Signature: ztokn6y144w4f7ntrt881w4s7fwjnfrx
X-HE-Tag: 1784709163-164429
X-HE-Meta: U2FsdGVkX18mFROtgoTHMDJynRm4vrFVMY0XLlrQrU4xy1A6iQhTggTid1TN6Q2XguAkHBTMlhfGRYh/9iQo6cO9ya25Z4QC+Xh7D02jljgvhmVdDEgAV5PMW7hjSIg04iCE5KVuCECqyqmpy4U3K8HRoSIa8tPBpbA10xSLEyxUS4YmIax4GGHJhhF6oGeAEiIcyrfYoecFyy3e5wkRVb5WO7Hyg6jLULtC+RkqhG1h27zlC6cLrqQd2FmhfJ1y8JM6mWuUYKxDPC9j9aG4qHGZ1SKhZUzISZlDtli5L/srdUF6m6cyEyBlxGAkA5mb483GWnjtZbDTtSnfZ1yKWGL+ExMqKnm6pnQj8PVlbSdLEQRRPwOAqwqseDNP3eW9+S7BraLjehq8uxS2m0nIduwFN3/p3TKZIr7JsfY8rwKvA+uLGnBThbQYICCajG/0Eih/NAO3ROoL2SKsBJzfDUAAs+LFPR7CVaOhqkX/pPNoGqkpTlT9/BJGKdPIstNrHjWFrVJ5oC/IhUSvt88bMFLci7WYiDiKKyRbQpdr13Q8bV36jhLocMwpz9x5cLHpyhVYfPcvjFh2NwrFAziLRfXXBPERL4Kg28jHj/JER9ktIB4VXHHfRYZFVhItXpj5uU+bTX12sTCCaYP9Zpr+t5FgvQ6HHNoNyUCuS3qECsvrFSkCifDbSznqyB1yTv8XTj8gWJroNcLfXDoIuYKhnZIcdTKEdB3oK5gO+m6fz4KS/xv6VIRfm8haZtBWIjO18/qb72Gyqpq1jJoETnr4STtwoCnJPlIHjD3jXYvCadN14uuO3lUp3pnXY4EhgI08oO/O6FoGmIdDE3xrVtzg736IKjpXYp+cNzB95npHucCLDVfwJwAi2caf6aoQGde3zQCybZ64lNaCeOqt0AirwKErr6tML/66APLIeDCNaSQptfPw4zEyufnwUFrReCLLAfZTtFt3zLRNuH0ssRF
 YyOR77FU
 wDKy/5X+Ycoz7d9PgoK0mk8ODJt8LNWI1lj+LBLvTJ7ZRe+R6OXRvy0jFgoWkbQfrJcheTaKINTSd3/pKCfDLAmDIV2cabOFv7dXeaOmd7thP2JfdgcCRs15sjx3fZid8V2+mVY3I+u52+dAGY2Zhmt2SRD2/t26RA+gzAvycsEjlk30vBIDai2DhslCSiDqqxotR4H+ySPpBxiD4uZasCrzO6/VhCEda4gXdzKOXi7ERf8DxZHLShluElQLEPFGXhjS/aFY2iaXtBYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 7/22/26 12:27 PM, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> >> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
> >> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
> >>
> >> Register a kprobe pre-handler to invoke kmalloc_nolock() and
> >> kfree_nolock() in the middle of the slab allocator. However, do not
> >> register the handler on UP kernels because that use case is not
> >> well supported [1] in the kernel.
> >>
> >> To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
> >> is held, add a wrapper function for lockdep_assert_held() that calls
> >> a no-op function slab_attach_kprobe_locked() on debug builds. The
> >> function is optimized away when neither CONFIG_PROVE_LOCKING nor
> >> CONFIG_DEBUG_VM is selected and register_kprobe() fails.
> >>
> >> The function calls barrier() to prevent the compiler from optimizing
> >> away its callsites. Otherwise, the compiler may consider the function
> >> does not have any side effect and remove callsites.
> >>
> >> Compared to using plain kprobe, this has two advantages: 1) it avoids
> >> hardcoding function names in the test, and 2) it can trigger those APIs
> >> in the middle of a function, where the lock is expected to be held as
> >> annotated with lockdep.
> >>
> >> While it was proposed [2] to use kunit function redirection to test
> >> this, it is currently infeasible as some lock helpers don't have
> >> symbols.
> >>
> >> Factor out the nested loop that calls kmalloc and friends to
> >> test_kmalloc_kfree(), and call them in
> >> test_kmalloc_kfree_nolock_{perf,kprobe}(), each being an independent
> >> test case. During the refactoring, drop alloc_fail handling as it
> >> doesn't provide much benefits.
> > 
> > Nice test addition!
> > 
> > Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Thanks a lot for reviewing, Shengming!
> 
> Just FYI, I'm going to adjust a nit pointed out by sashiko
> that kmalloc_obj(*objects[j], gfp) is wrong because objects is an array
> of void pointers. (which is fixed later in the series)

Indeed, Nice catch by sashiko. :)

> > Nit below:
> >> +static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
> >> +{
> >> +    struct test_nolock_context ctx = { .test = test };
> >>  
> >> -    kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
> >> -           ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
> >> +    if (!enable_perf_events(&ctx))
> >> +        kunit_skip(test, "Failed to enable perf event, skipping");
> >>  
> >> -    if (alloc_fail)
> >> -        kunit_skip(test, "Allocation failed");
> >> +    test_kmalloc_kfree();
> >> +
> >> +    disable_perf_events(&ctx);
> >> +    KUNIT_EXPECT_EQ(test, 0, slab_errors);
> >> +}
> >> +#endif
> >> +
> > 
> > Maybe it would be worth checking that the perf event actually fired:
> > 
> >     KUNIT_EXPECT_GT(test, ctx.callback_count, 0);
> > 
> > Otherwise, the test could pass without the callback.
> 
> I'm not sure if that would be useful though.
> 
> Ideally we want to make sure every code path that handles
> allow_spin = false is tested, but it's tricky to measure that and
> also it's tricky to make sure those paths are properly tested
> (especially with perf events).
> 
> callback_count is not a good indicator to measure test coverage.
> 
> (I use GCOV to make sure we have reasonable coverage,
>  but it's hard to turn that into a test case...)

Thanks for the explanation.

I was considering it only as a basic sanity check, but agreed that
callback_count does not reflect the actual path coverage. I'm fine
with leaving it as is.

--
With Best Regards,
Shengming

