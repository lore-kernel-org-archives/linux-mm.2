Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0020606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVsQQo/B
Received: by kanga.kvack.org (Postfix)
	id EED4D6B05B9; Wed, 18 Nov 2026 02:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E3A6B05BA; Wed, 18 Nov 2026 02:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5446B05BB; Wed, 18 Nov 2026 02:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B10996B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:40:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B85201205C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:34 +0000 (UTC)
X-FDA: 85447442388.07.638CE6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C435FC0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BVsQQo/B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794987633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NO7BDo+P4bguxhOf8l6doBU3I12qHv10RKKucCA1O0=;
	b=3Po/ZAG2T+PSuKR6GGgw062kkUJoT/AYMobxMibEXgtxqXVVzfX/i5W6qn/idruva9G2hj
	wiYLcCEN2btp8ueNEioL64qqpRmibznHQU2K69h8sbkmz8eupJwFMVlZXCOVnohUfp7tRJ
	zQvfF14CO1gS5gZcxfvBAASAGWZCYC0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BVsQQo/B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794987633;
	b=gkJaX0K9uBiX0tpsbhnpXJAZuuWrb0IbAWild1NuGzsR99sg6qfCtrrqZOqFhJJ+Iir5U8
	OLOUZD+3DBue1jAdhXO5YTSmh59DHDhB1edjR1cfyLYlXJ5KnR9kydoAloRD7N/2NFf0PX
	sqy/G4lxhTKCEPbUt2Zn9vHqX1llhzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 486AC44D1C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DBA1F000C9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794987631;
	bh=+NO7BDo+P4bguxhOf8l6doBU3I12qHv10RKKucCA1O0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BVsQQo/BOpYlS5nuNpobghJdfS2nQvqJanM8P/SdMM8px83LV194QwEVyng2Rfjsf
	 vSs2PB2CO/umYB8ekgGnyqsYFy9mERoY7pZ6tqAU8IYR0RV5WJCxcWL6RUysGb0Shq
	 mJj0fc/JnKGTqTWihY5oQdwo36yck7J99Eumom8LBSa4O3B5DTAFjtWAZkvv5nzXys
	 nimpCc9wzS1QHpTRUiARxy13Trb6E+GFcDjJlkN00mPU9/PbrAudsyprHfIe+o2I4q
	 cW25PzbqNIkXmjvQEodQybim/XotsvSmA4AT/Sn8xeG13oA2SCearvXgvKB7ued+uG
	 Je4HJPMmH/ojA==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b88b74e54eso536399a12.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:40:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGlLukiti93BkQIrWtZOEktW9u6PfXj/Y5FVc7z0HgEZIKgipQlBMV1l811DNnNkiqb3VdXZp7JTg==@kvack.org
X-Gm-Message-State: APuU4Z8SXYKUnQm6q5TdySNDQ4gnvUVLCHlfSmfMxLVH72WiOjeLdUbl
	H7PTvVwE8J6Fcd41X+1m+uZ3xqtl118CJz7s48KsaQ27MGAgY3Xj2+kXCogIWsD7cOmNLW1s0Pq
	/2GGWqCLRImAUzQvkWXCmOYcFjN+FYWM=
X-Received: by 2002:a05:6402:2707:b0:6b7:ce4a:7d0b with SMTP id
 4fb4d7f45d1cf-6b887e9855amr1039376a12.20.1794987629740; Tue, 17 Nov 2026
 23:40:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261115095503.2922598-1-chenhuacai@loongson.cn> <sashiko-outbox-216668@kernel.org>
In-Reply-To: <sashiko-outbox-216668@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 18 Nov 2026 15:40:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H75pFts2FxZTzrJP+T+M3m3AFzF6pqc5WK_fR0=u-PCeg@mail.gmail.com>
X-Gm-Features: AclHuK8Di8CaNXtvY2DxNQUZd0T7YfZm_H-Rw4Q8hcNhOtGVQFiP0BTeRQ8jeuU
Message-ID: <CAAhV-H75pFts2FxZTzrJP+T+M3m3AFzF6pqc5WK_fR0=u-PCeg@mail.gmail.com>
Subject: Re: [PATCH V2] lib/smp_processor_id: Don't warn if there is only one CPU
To: sashiko-reviews@lists.linux.dev
Cc: Huacai Chen <chenhuacai@loongson.cn>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: juuyw5w5wrbytjtop1oofismftrpg4uj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C435FC0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794987632-166153
X-HE-Meta: U2FsdGVkX19Ru5C/IpdHaQqZaw6rltBq0TykgxO2U0XIO84INNpbicDlm3QFx8Q+xoDeZsE5bkIrWQvZs644u05nAznzGzhggAoW+dfmbe73SorB6xxt8eKTjVjsp+ipp9IP7jgOgupKFTTGIHgbLiHKriVq5gSxZLndMcfbTn3K2aZ8h46Gg2mLIK3VB5sQ3//dgp3DgFmY4QstJYeS/xX7w8nxTDbSXfda2cbJwwLhwfXtUy8xoE/7zf7vDewJnmf6vN9AZyEMz+L1t7Z+w1IZklA8Skj2QyqcrrgQLHxE8aPfI3r5Pcc6uCkb6wmzeQAyqBSOAyMmjkhs9/baqQDsrNsu03fQQS1doB/PxvUVc3AdVXbEsx6Q641oc4qCQlAHaJxiKGaF5GW2F9Taq+qhSkoUGeOveO8iE7MZouPV6xTiexmjdA252VqZoAkFb0ZR75DFgtdJbtNyirLurXbQJhtWX1BhYjdkdcWRIDfvaLzoP7fGHO9//lxJQvlGeotgva9AQRoHbC9bj4E3xPmzqvY7LuhyGS9CkUqe9CN5CTiWQZWNUn8dvKAaqdXJ4cS9IK5+JZeRsDXW52vHqAfJJMxx8VcH5u1KL1hDj6+AjjeYYXHoZd/0bT1uwDv0ty+4a/JSZePH9CpEDJeOtuBksrS3+ZPZXEJr110jcbIkS3VbAMGkbJJ8zIW3bCKBtRNCDfeTYj05BNrMjUQVtJdMnFqSFYv/U3xLrh06H2CQFEhtYliXR5MF1ICz+TdpWphd3+BB7zHxZZ6D+VGiKxu9oG/FKlOd77g4XjeO6mAID0p8Tp0/d4vjU6rL55NEGGbK1lXVBgByOBdvvtYE6yJ/w3UWt/8g+VarDcNUFjLC4kncNUJt/RmDphChIgokEYNTRHfuA27gA9d6HZs5FJFtDHFeQ+exp2z+hhf0SFv+uczaJn3M1dGbKHgY4iL8Kg/TAnouvhQxaYQmhoe
 kQw5sBuF
 Y+Tsa1qvf7ruY7dBENhBWcEEKoHUU4ViJa7isNPcuSKNeDosqk8ZwM6DVr7uXSZ3Yr0fWPqJtnXYZ/5zQcahV8HmGnL0IYIFfi5sqA1G9x2k8DCHSsnBFatlrHgJ6xB6kk0D2wG7zvzMuyRPpKZglqKiqgqmjUOu598eAbEFE36CefdGBy2QzFfSFyC485dvU+BAQW/TSJZ/cg5Ye48Kwiy+EFS4eNVsuZ3pSZD5UsagylSRE+INAii156jzAS/kAjMCREpm5iO9vnFfeoNLKICCw9nMxkrqhMqSJKOMCzZ9AaaEo641Y2HHBkMiI0UVJa/F3yyYDR1q9O4qDWioBo7Z4cd0wSshE+kgzGAbp/2GmJdLdjk+DLegvCza/DXnyvVMOezJvsjkhXCd6q1Qbww+jWGKpqQbj8Dg4nMxswbwAh2bBTzArzXeJyYjUzAqwYW/wg22sl5kccNPgOmWlGb6SnJSxnsQyxIY1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Sashiko,

On Mon, Nov 16, 2026 at 5:55=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] lib/smp_processor_id: check_preemption_disabled() skips
>   checks on !CONFIG_SMP
> - [Low] lib/smp_processor_id: missing Fixes trailer on stable bug-fix
>   commit
> --
>
> commit 62cd1e08e5d017184a1415887d93a1188fd3f001
> Author: Huacai Chen <chenhuacai@kernel.org>
>
> > lib/smp_processor_id: Don't warn if there is only one CPU
> >
> > When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> > calls to smp_processor_id() in preemptible contexts trigger some false
> > positive "BUG: using smp_processor_id() in preemptible" warnings, which
> > are harmless noise because the process always executes on CPU 0 and CPU
> > migration is impossible.
> >
> > Here are some of the trimmed log messages:
> >
> >   Call Trace:
> >   [<9000000000d33e28>] show_stack+0xf8/0x1c0
> >   [<9000000000d2fdac>] dump_stack_lvl+0x4c/0x78
> >   [<9000000002456fc0>] check_preemption_disabled.isra.0+0x100/0x110
> >   [<9000000002456ff8>] debug_smp_processor_id+0x18/0x40
> >   [<9000000000d31118>] init_cache_level+0x18/0x90
> >   [<9000000001adbe2c>] detect_cache_attributes+0x4c/0x640
> >   [<9000000001adc44c>] cacheinfo_cpu_online+0x1c/0x310
> >   [<9000000000d5ae04>] cpuhp_issue_call.constprop.0+0x94/0xd0
> >   [<9000000000d5b278>] __cpuhp_setup_state_cpuslocked+0x208/0x320
> >   [<9000000000d30148>] do_one_initcall+0x68/0x200
> >   [<90000000024711b8>] kernel_init_freeable+0x1fc/0x294
> >   [<900000000245824c>] kernel_init+0x20/0x134
> >   [<9000000002455b54>] ret_from_kernel_thread+0x24/0x1d0
> >   [<9000000000d31650>] ret_from_kernel_thread_asm+0xc/0x9c
> >
> > This warning only exists for the !CONFIG_SMP build. This is because for
> > CONFIG_SMP cpuhp_issue_call() invokes callbacks in cpuhp_thread_fun()
> > which is a percpu thread, but for !CONFIG_SMP build it invoke callbacks
> > in the init process which is not a percpu thread. And there is such a
> > skip condition in check_preemption_disabled():
> >
> >     if (is_percpu_thread())
> >             goto out;
> >
> > Since there is only one CPU for the !CONFIG_SMP, we can simply skip the
> > warning if (!IS_ENABLED(CONFIG_SMP)) in check_preemption_disabled(). Th=
e
> > effect is partially reverting 570a752b7a9bd03b50 ("lib/smp_processor_id=
:
> > Use is_percpu_thread() instead of nr_cpus_allowed"), because now in the
> > UP case nr_cpus_allowed is 1 but PF_NO_SETAFFINITY is unset.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>
> [Severity: Low]
> Since this commit is tagged for stable and addresses the !CONFIG_SMP
> behavior changed when is_percpu_thread() stopped unconditionally returnin=
g
> true on UP builds, should it include a Fixes: tag such as:
>
>   Fixes: cac5cefbade9 ("sched/smp: Make SMP unconditional")
>   Fixes: 06ddd17521bf ("sched/smp: Always define is_percpu_thread() and s=
cheduler_ipi()")
>
> > diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> > index 94b3f6b195388..be079b9085045 100644
> > --- a/lib/smp_processor_id.c
> > +++ b/lib/smp_processor_id.c
> > @@ -22,6 +22,9 @@ unsigned int check_preemption_disabled(const char *wh=
at1, const char *what2)
> >       if (is_percpu_thread())
> >               goto out;
> >
> > +     if (!IS_ENABLED(CONFIG_SMP))
> > +             goto out;
> > +
> >       if (current->migration_disabled)
> >               goto out;
>
> [Severity: Medium]
> As reported by Peter Zijlstra on v1 [1], does returning early on
> !IS_ENABLED(CONFIG_SMP) disable all CONFIG_DEBUG_PREEMPT checks in
> check_preemption_disabled() on UP builds?
As I said, the effect of this patch is partially reverting
570a752b7a9bd03b50 ("lib/smp_processor_id:
Use is_percpu_thread() instead of nr_cpus_allowed").

I think 570a752b7a9bd03b50 is mostly optimising the checking of
CONFIG_SMP, so partially reverting is acceptable?

>
> check_preemption_disabled() also backs __this_cpu_preempt_check(), which
> guards non-atomic __this_cpu_*() read-modify-write operations that can
> still race across same-CPU preemption on a preemptible UP kernel, and
> suppresses warnings for smp_processor_id() callers that would be broken o=
n
> SMP.  Because !IS_ENABLED(CONFIG_SMP) is a compile-time constant, this
> also turns the remainder of check_preemption_disabled(), including the
> current->migration_disabled check made unconditional of CONFIG_SMP by
> 2885daf47081 ("lib/smp_processor_id: Make migration check unconditional o=
f
> SMP"), into dead code on !CONFIG_SMP.
>
> In the reported trace, init_cache_level(unsigned int cpu) in
> arch/loongarch/kernel/cacheinfo.c already receives cpu as an argument but
> reads current_cpu_data via smp_processor_id() instead of cpu_data[cpu],
> while cpuhp_issue_call() invokes the callback directly in preemptible tas=
k
> context on !CONFIG_SMP.
Yes, cacheinfo.c is just an example and can be fixed in other ways,
but that doesn't mean this patch is unnecessary.

Huacai

>
> [1] https://lore.kernel.org/r/20261111170600.GS1779021@noisy.programming.=
kicks-ass.net
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115095503.29=
22598-1-chenhuacai@loongson.cn?part=3D1

