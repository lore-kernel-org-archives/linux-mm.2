Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D421D606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MP/mu4Hg
Received: by kanga.kvack.org (Postfix)
	id F065B6B05B0; Mon, 16 Nov 2026 04:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8F66B05B4; Mon, 16 Nov 2026 04:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDC46B05BB; Mon, 16 Nov 2026 04:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B689D6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:56:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44906A6821
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:56:00 +0000 (UTC)
X-FDA: 85440526080.17.7373830
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6B1AC000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:55:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MP/mu4Hg";
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822958;
	b=gHpfWY9lqxXaT4GB2FBa40YRKR3FdwgsjsoKplEM+7QQbEkx5HtcKJNKvnZgJglfsMqB4Z
	RyTY4Zdy+Abu49DhPD61GqJ1+TBqcUk/LQTvSl1+dhMsvGEElx+GZVVlQUFQl/rMnLd5GR
	lAmgfgkcAzdgkwX4dOJKncT/aLmK4B4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MP/mu4Hg";
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822958;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whHoRztwZjb/3Caxzq0M8bzF4x8Q4EWlbXOfbOCEks4=;
	b=8IN1ARB1baMAVCWzu9KyOY7Sk+BTTLfU/9euuOYVvu+572FoyYcv+VZE02jh3gDRD9ONEB
	tWnCcMh2ztf2UXDpycLhCK4DhB/J9AWO3E/sKB6YE6wZ15WtyD36D2lbCFgXt2uPsfB8s1
	qEIidy1/q4dhStugxi393n/dob+gB3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4146D6284F;
	Mon, 16 Nov 2026 09:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AC51F000C4;
	Mon, 16 Nov 2026 09:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822958;
	bh=whHoRztwZjb/3Caxzq0M8bzF4x8Q4EWlbXOfbOCEks4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MP/mu4Hgbaz7UH0W81VWdv6nza3CIfh5e7JdPxf4D4BbTMH2BJYKPc4h/Sj57UUL9
	 WdETvhJLkQJt+WMBZ+aIyRs+Da7P2QHHXa9DcrYVX7L/6bn+Iub84FtTPwF7Sf0qfc
	 /PlpLcqthB2h+4tXr0TvBg2UhkgO9by2XTYJ0oZ5GuvakT+coBRjKviFDV4g8BbkEU
	 j0f/l1Jnw492u3M2r66TYHoq3N9dDyvFCYEEfdAlTgG8yoTcp+OVJ7+f3NXvFSjk9W
	 WSlKRbV0AocB6HEGUqk6WCT62SNbbxelqzo0uMUcCma8qSfh0tGQbRjQHinsN/kB4t
	 esCPwgAi0BvGQ==
Message-ID: <sashiko-outbox-216668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2] lib/smp_processor_id: Don't warn if there is only
 one CPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Huacai Chen" <chenhuacai@loongson.cn>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Huacai
 Chen" <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org, "Tiezhu Yang" <yangtiezhu@loongson.cn>
In-Reply-To: <20261115095503.2922598-1-chenhuacai@loongson.cn>
References: <20261115095503.2922598-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 09:55:56 +0000
X-Stat-Signature: 8otaehkyao7q318ff6md8drxftu4jti6
X-Rspamd-Queue-Id: A6B1AC000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794822958-795336
X-HE-Meta: U2FsdGVkX194RVP3IZEVlTlOfn0mWHO/sM19RxOFHwbRtQ8NRq1OmxhxK1Utk7FV9R64fQIwQiCayhSkdLyjHYKqVOQWf6TxxmFfTYFpfhOZst4wwoO/ju3tdayzKDHvy4HIccxxAyfHifl/4R3VZqLhf15CnfidwjVkikHNxkAqYSc410XYLKIij2Nh2sLIOshL2Q29VhrCnpykjWHJB6xixEa3eYU9ImhFozlkqkNNA0FbE5X08w75TLMj8R6sU9Y/8ka8QksQ4Of+547QMl5kgEqKyA46uBsmgXNqcLejFkN5EmDZTd5h9ADDKMxa6S7kY/W/73tQfy8cBhSIpq2Vo020bWDg1ksj+TV0FdEDLShioU35XzQwmsVPof88Ar7NL6E58t44Qy2S9JE4zPcmybaJcedkW7XHUSTf9ucu1K2i0bXdI1iH9JO1gge5gtD2aHgF8UnxnwkgWunKH+N97GclJ/u87BbPTAcZ2c06dlu6jA/iUFWvKCV0OWWcDUODLV9x1scIAGjRP58oQurkA6oHW7c+/FBB4BErufIlBMgfnpCYXwdH1fWMolo2PmBD5do3W455nY/GivEOsG0kXpVs+uglVGJ2tMJoUFTilWjU8wAxpGR+gGR02iGkGHAPjYoEhSMs2fCfvnwbs0cQTY+QX/yEbWE8JdUwGBcZqO2l6ZSJoBdquTexIrTWtl9app4qFXNA0onHTjp372i15VqRiZvSmcf0abhN4dsL3Z0usd5/qY0G4y3TpR+24AC8dxUuqOklWIGyEYclYEGINrnXF9cI8d9qw9yMjsAZicFQ7+Pi7GJEikD2mhB1oocS4r6EMYWNA1bJ7cHCGmbXocVx3/XNUxVbw9UeGBfEYzPBlb3KCdHgzifnuFN+HGHNL5OO1FcEj2sJqI6ZBnG8EIDrFrQeL60KJIMMcTqPz9nl7QzP1HtsQb7tPydu7Pw937Dy/CD/hkCC6KO
 IR1OelzT
 V9AykL/EH9cTHlxzQTvsmyDqOGlv36gamN9HFa53d/yrNqGGh1QmzCof551hsIe3Hio6oYNQkLE5tvxvd7vdah55O6W/zusrb9PpWL/GqdC2d1FwMHEVYsHQW218ViTXe1vP+wY3/QNgIIF3aRp8+oFpvBNfwD97rfzP8cHQYDsmyBaSI09219ahSwhNPOxcd9WalhWJdIf9jd2DSLfv0tTdNdI3G/kk62HlTbYI4qvQYNM6Kxnd7LK3DLyZhFYN5iMbgjRZrtoa7WpCqljoQDVQuzQlBrcN8ncSRm4ndeW1CNxZZiGsqskw8m7GQGDoEjgIGTeUcwvLYN/L3z2EwsLb3ZYYua6c1Z9sQo8lMgHfvy8gwJxIyRHPtPQVdsUV4UxK7Zp4/VsA2laPYnRy95uuSKGjs8L7uAV1kDzfxgI9pHT9Nor5Huf3Qso8tkqwMQG8GPTjCsY86pgn/8Sihc4hZsIyWCIA7BobjICDhufSVus2tghrYfHrvZn9I78xR8SVMH9+yibtoJDgPGXUDqIPQbal9Moub6yFTRzIzjzXk+/roFFHjR2TPBsJpCcJN61yQdLOSM4RzSePhU9rTcZijbFOrKYV31STIU4gcmlAw3yi+WLU0n+/yUbth3BhVi0WSmcZaZwW0+lJtsvBTJDDxuV2v2rUhcnWKUgHuwqbmyjAudPMq12fZlTdv1rpb3Xsj
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
- [Medium] lib/smp_processor_id: check_preemption_disabled() skips
  checks on !CONFIG_SMP
- [Low] lib/smp_processor_id: missing Fixes trailer on stable bug-fix
  commit
--

commit 62cd1e08e5d017184a1415887d93a1188fd3f001
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
> warning if (!IS_ENABLED(CONFIG_SMP)) in check_preemption_disabled(). The
> effect is partially reverting 570a752b7a9bd03b50 ("lib/smp_processor_id:
> Use is_percpu_thread() instead of nr_cpus_allowed"), because now in the
> UP case nr_cpus_allowed is 1 but PF_NO_SETAFFINITY is unset.
>
> Cc: stable@vger.kernel.org
> Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

[Severity: Low]
Since this commit is tagged for stable and addresses the !CONFIG_SMP
behavior changed when is_percpu_thread() stopped unconditionally returning
true on UP builds, should it include a Fixes: tag such as:

  Fixes: cac5cefbade9 ("sched/smp: Make SMP unconditional")
  Fixes: 06ddd17521bf ("sched/smp: Always define is_percpu_thread() and sch=
eduler_ipi()")

> diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> index 94b3f6b195388..be079b9085045 100644
> --- a/lib/smp_processor_id.c
> +++ b/lib/smp_processor_id.c
> @@ -22,6 +22,9 @@ unsigned int check_preemption_disabled(const char *what=
1, const char *what2)
>  	if (is_percpu_thread())
>  		goto out;
> =20
> +	if (!IS_ENABLED(CONFIG_SMP))
> +		goto out;
> +
>  	if (current->migration_disabled)
>  		goto out;

[Severity: Medium]
As reported by Peter Zijlstra on v1 [1], does returning early on
!IS_ENABLED(CONFIG_SMP) disable all CONFIG_DEBUG_PREEMPT checks in
check_preemption_disabled() on UP builds?

check_preemption_disabled() also backs __this_cpu_preempt_check(), which
guards non-atomic __this_cpu_*() read-modify-write operations that can
still race across same-CPU preemption on a preemptible UP kernel, and
suppresses warnings for smp_processor_id() callers that would be broken on
SMP.  Because !IS_ENABLED(CONFIG_SMP) is a compile-time constant, this
also turns the remainder of check_preemption_disabled(), including the
current->migration_disabled check made unconditional of CONFIG_SMP by
2885daf47081 ("lib/smp_processor_id: Make migration check unconditional of
SMP"), into dead code on !CONFIG_SMP.

In the reported trace, init_cache_level(unsigned int cpu) in
arch/loongarch/kernel/cacheinfo.c already receives cpu as an argument but
reads current_cpu_data via smp_processor_id() instead of cpu_data[cpu],
while cpuhp_issue_call() invokes the callback directly in preemptible task
context on !CONFIG_SMP.

[1] https://lore.kernel.org/r/20261111170600.GS1779021@noisy.programming.ki=
cks-ass.net

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115095503.2922=
598-1-chenhuacai@loongson.cn?part=3D1

