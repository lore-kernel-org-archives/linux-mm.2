Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1326F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V//olND7
Received: by kanga.kvack.org (Postfix)
	id 320366B05B3; Thu, 12 Nov 2026 04:24:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D09D6B05B4; Thu, 12 Nov 2026 04:24:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C03C6B05B5; Thu, 12 Nov 2026 04:24:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8CCE6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:24:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E11AA78CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:24:58 +0000 (UTC)
X-FDA: 85425932676.29.1A0F687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D210280006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:24:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V//olND7";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475497;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkLpjqN2cmVM0+UHmNR+PdZ05HFeKD5qDle9ys44moo=;
	b=50dwUPr7okh2/AjGe80WxQ5ntLtRziMte9C6Bkck7z5F1HXUffq5hpQXlHbosCIhHTS9/f
	LNjqnm2QS16ERO4PsR2OOhKzATJha85Q/sqcQzVXuK6hbp/41hLq7oOT9FucROC1YVnJXR
	4JXG3q//mmj7ATSLwjFcXs1lSzE8qx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475497;
	b=wmqvgS0rLuKKnMcN0tjFbGBPSJuue7rtY7zhOzymo6BNAhui9ZHd6075r/7FEo9eBvuZFP
	yUSz2QKYfjeUCiNqDVuhqdAg4X96PpO1c/8ZaCIgP16/Rf+NnWPR0wIk+CHgmbnNEOE/L8
	ZKRqIoS21RqPYoaqohgzzuaQ32W6lAA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V//olND7";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1119641893;
	Thu, 12 Nov 2026 09:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE21F00A05;
	Thu, 12 Nov 2026 09:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475495;
	bh=HkLpjqN2cmVM0+UHmNR+PdZ05HFeKD5qDle9ys44moo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V//olND7eoKwNm+BDFcrlpJGqzqPc6PFEAru83yQUAVNgkWOzOwzCLv/V63KCp19c
	 iTqpWpBAss3ehii8RhRCobeP7QDCXhwxnGz5RMRhQKxc576x+g+XlIb+/cP2GdOGfV
	 S6CajcLlMCNYtBsjB4p9xTZYvDbXz+YsIemOt78DAZSaONiA5fKqRuifp3axLVPj3o
	 /xyLNnkH7DFe/tktfE4QLPIzFIprrcuf2wh3WsnFX7LSSGe6RqG8+hRI/8toItNcr5
	 zWOFiSbmaOGb7CgT/Cz1GMpPt0w8FGhCJ5x2CVPHdgnb6f2xmdkSLrFldQad2WnH0H
	 wniIZ5nv8fQ+A==
Message-ID: <sashiko-outbox-210873@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one
 CPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Huacai Chen" <chenhuacai@loongson.cn>, "Andrew Morton" <akpm@linux-foundation.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Ben
 Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org, "Tiezhu Yang" <yangtiezhu@loongson.cn>
In-Reply-To: <20261111092421.3771992-1-chenhuacai@loongson.cn>
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:24:54 +0000
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jqm4t9pwmk5ta51hh7shygad95611g99
X-Rspamd-Queue-Id: D210280006
X-Rspam-User: 
X-HE-Tag: 1794475496-425243
X-HE-Meta: U2FsdGVkX1+6qIkz4x7xiXBUqn8MmmBOnppQbTMu3ZAhPaBn9jPSOSZnOdxqkcGOH9fFvmN+GIQSgbuMeBiF4D7PepbRfKlt0Y6r+gtgsGqFnqdY3zIpPzXL63BDlaGc6CJmXyMR5XmizAVLNDawdChihRrD29UHPmt9VZQ4/3tooF85fV5a98Wqy7xS6sQ+ghSQq7QD1yzd0QHRT161lmuNhpeIxwous1f6sVHGIIhc02MyubaC2qhNRtLTYJfYwcYFkXvnf3uINm58SmdqDdv072DiFYd461/7QL8mxfQ7KWKtq9KU6e3+Z1XMJwZo186vC+RAIKoXNA3bdzohCpYPrDsFJb/BZFbnrAsumMNUWLsRGY4qn8lXW443ty9dQIqhkZZEpdQ1t+7iHD6hKfEGL7MIBHkUxq9OnPAzk72Y6OKW8lX0ZPtYtuncxTpz8u0c08UX+23YtHzzYRfLHkv8VMc7nVu/71HPVTSXSQNTB/wBo90KpfxVL0JeMITxCuVxkdd+lHO4bczc/eKFvZODUB9vtV6nuKjzzGSzDvA89aTNYfn4pmV+EoX/dNif+GR9YPMTkuBbLWwZ9GvkaJHzCrpUz946lPN46jvicaCOZ3QNmRrS0LxynI3vN04CCXbphRtqXwfypH8LZ/E4a3hmepQ4jGHddZCfqP8YR91pST9rSYH/2ZYr+9padryEesKe0po4k9JtFyvG7ul7fMVF9CBhrqw4oIFWekudFKlyKuZw7ITxu7ph2b/tbX7TOrALd434thw18qbOKjwQDPfOOuT8ljwYh2ZQhBLVqu2Yc/koNUvb144g9GXWHndvN0Zrp2ZZMvAkIUWNzCSvro75dpr0+TB11uAa822HjUsy9LRAsHEGQzqavR8H02tI29Vblf9pWoswZ9TrhAszQGWrIrrwHjMkIgWq01Py0aaFUF79ZvNgCuTmXtzq7bzsR8ZuymzWwpuKzCywl3m
 W7ZBOXKm
 4UTVuvFL3PTnebDbhQpMAAq2Y3oCIhWOa6ElMPJoDFoiw77k+u0KxLp23732r88vOo72VmqzpDsASJd3QJVWdtmqDmKTT6OKXAezcnuIrJ7HDW3428Nq1WhPOV+DItz6w5deR2hEc6qPyRWrPW9pKZ5zmHfCb4rlrsGAu7vksX/X0uOX6jY9xPWk0MGNhXpvdNUjmv3+9lirZmcUi7FkPbtk/7/LUqT/TOeYh4G5vfIQEXujxxd+yLsqNi5Vqv/H1fJbz9jerEGWzrjM/jdrWH4ouVI2hna8Kexw7gyD117blH0yI+ZfslYMNNj14QiBj9cJTiUfiBqvztrVBQXFYGldZ/4E4Lslr7NrKw+26fJYFcacfW/o6GuMHnTj3W+H7luofcmAOfwlBCb+9xtfypfPKnZeUZUskivuhoa/kFSmzuq6JDrAtdQbTf4wEiaKEzfNjZ92N4bri6+eDkPMP6D3a2drqojq32rCXQ8Y0qQtzbAJFs4dtVpQkOTnfh5tg691SA/4ooVLbq2jTAyWzTXlCCCaUkwfEMfUhGXvmAReJaydRMlx/fhRWp8jbV8Ms2JefI8Ajdi6ep+nx7RBR5+4d1+ZP5DzecULyz7iBFa+DyxS4BphlSvUNFg36MeH3EXuHJJhQhklZ5lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] lib/smp_processor_id: check_preemption_disabled() disables
  checks when 1 CPU
- [Low] lib/smp_processor_id: missing Fixes trailer on stable bug-fix
  commit
--

commit 0181ac5af2fbbf50ee4ee229425b805d588cbf1c
Author: Huacai Chen <chenhuacai@kernel.org>

> lib/smp_processor_id: Don't warn if there is only one CPU
>
> When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> calls to smp_processor_id() in preemptible contexts trigger some false
> positive "BUG: using smp_processor_id() in preemptible" warnings, which
> are harmless noise because the process always executes on CPU 0 and CPU
> migration is impossible.
>
> Here are some of the trimmed log messages:
>
>   Call Trace:
>   [<9000000000d33e28>] show_stack+0xf8/0x1c0
>   [<9000000000d2fdac>] dump_stack_lvl+0x4c/0x78
>   [<9000000002456fc0>] check_preemption_disabled.isra.0+0x100/0x110
>   [<9000000002456ff8>] debug_smp_processor_id+0x18/0x40
>   [<9000000000d31118>] init_cache_level+0x18/0x90
>   [<9000000001adbe2c>] detect_cache_attributes+0x4c/0x640
>   [<9000000001adc44c>] cacheinfo_cpu_online+0x1c/0x310
>   [<9000000000d5ae04>] cpuhp_issue_call.constprop.0+0x94/0xd0
>   [<9000000000d5b278>] __cpuhp_setup_state_cpuslocked+0x208/0x320
>   [<9000000000d30148>] do_one_initcall+0x68/0x200
>   [<90000000024711b8>] kernel_init_freeable+0x1fc/0x294
>   [<900000000245824c>] kernel_init+0x20/0x134
>   [<9000000002455b54>] ret_from_kernel_thread+0x24/0x1d0
>   [<9000000000d31650>] ret_from_kernel_thread_asm+0xc/0x9c
>
> This warning only exists for the !CONFIG_SMP build. This is because for
> CONFIG_SMP cpuhp_issue_call() invokes callbacks in cpuhp_thread_fun()
> which is a percpu thread, but for !CONFIG_SMP build it invoke callbacks
> in the init process which is not a percpu thread. And there is such a
> skip condition in check_preemption_disabled():
>
>     if (is_percpu_thread())
>             goto out;
>
> Since there is only one CPU for the !CONFIG_SMP, we can simply skip the
> warning if (nr_cpu_ids =3D=3D 1) in check_preemption_disabled().
>
> Cc: stable@vger.kernel.org
> Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

[Severity: Low]
This commit is tagged for stable backporting to fix the !CONFIG_SMP warning
exposed when is_percpu_thread() was made unconditional of CONFIG_SMP.
Should it include a Fixes: tag such as:

  Fixes: 06ddd17521bf ("sched/smp: Always define is_percpu_thread() and sch=
eduler_ipi()")

> diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> index 94b3f6b195388..64901d33c0eee 100644
> --- a/lib/smp_processor_id.c
> +++ b/lib/smp_processor_id.c
> @@ -19,6 +19,9 @@ unsigned int check_preemption_disabled(const char *what=
1, const char *what2)
>  	if (irqs_disabled())
>  		goto out;
> =20
> +	if (nr_cpu_ids =3D=3D 1)
> +		goto out;
> +
>  	if (is_percpu_thread())
>  		goto out;

[Severity: Medium]
Does returning early when nr_cpu_ids =3D=3D 1 disable CONFIG_DEBUG_PREEMPT
checks across the entire kernel on single-CPU systems?

check_preemption_disabled() also backs __this_cpu_preempt_check().  Even
with a single CPU, preemptible code using __this_cpu_*() or per-CPU state
via smp_processor_id() can be preempted on CPU 0 by another task that
modifies the same per-CPU variable.

In addition, nr_cpu_ids =3D=3D 1 is true at runtime on CONFIG_SMP=3Dy kerne=
ls
booted on a 1-vCPU VM or with nr_cpus=3D1, and on !CONFIG_SMP builds
nr_cpu_ids is a compile-time constant 1, making the rest of
check_preemption_disabled() dead code and undoing 2885daf47081
("lib/smp_processor_id: Make migration check unconditional of SMP").

The reported warning happens because cpuhp_issue_call() on !CONFIG_SMP
invokes non-atomic hotplug callbacks directly in the calling task without
migrate_disable(), and init_cache_level() in
arch/loongarch/kernel/cacheinfo.c reads current_cpu_data instead of
cpu_data[cpu].  Could this be fixed in cpuhp_issue_call() or
arch/loongarch/kernel/cacheinfo.c instead of disabling
check_preemption_disabled()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111092421.3771=
992-1-chenhuacai@loongson.cn?part=3D1

