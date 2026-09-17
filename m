Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2311DC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5D56B0095; Thu, 17 Sep 2026 19:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86686B0096; Thu, 17 Sep 2026 19:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CF56B0098; Thu, 17 Sep 2026 19:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 926DA6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:49:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0487160353
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:48 +0000 (UTC)
X-FDA: 85224899256.14.2995FDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18C5E20005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sid2cVmU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688987;
	b=Z+CEdTRDkSBj3VhujvqRP4KC0yQqse3TTYcBBs/vNDxcww5I3M3s7hfSiBrERYuS0NsvJm
	utBlrFuGJkHRZR7+ENHotyhwcteVfexdLkXzMNEFR/Ir9NH328/6cWelf0gNf7esescmB4
	UQ+jFAYCWuoyOVMExG7tb8WtrfWgPc8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sid2cVmU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VagvpoC7o+wosB0YXPDcway2+++m7SLZ0SGSIXuxt28=;
	b=vjsRn8eIW2ifuBQk9ba/37ponsBpxcQhTYlNdc5d6DuElYANAR++Nbd2Fcc1PaLFxUe0/a
	Sfv1Mwwb12KUrY6Q5Qo2Fy7RNwLz9GJyEtW0sXTP6pphT4wsiyNeW/Az991EpkDzX/mb3j
	rPOtnppOHeQ1S2Q87YOdwg4ewS3rm38=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 687A943604;
	Thu, 17 Sep 2026 23:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B18C1F00893;
	Thu, 17 Sep 2026 23:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789688986;
	bh=VagvpoC7o+wosB0YXPDcway2+++m7SLZ0SGSIXuxt28=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Sid2cVmU1ZbtiuT3X5ebKPtdM5I51CpdHzOKq3i8Sa6KdONiAu2+FHspXKq8qTeFi
	 AHMgWRPeQjgxmTgMedZHl8WTJU6PdpogC6cC1/4jI9XyDAx30LGLbGQRlbcbQR2EtF
	 8bmpFCotLNRiV8D3Tioi5ZSy55Ogl1f7PJ+u2ua+INItsM8xQ8Tn/syOTgYXmUBMih
	 3d6HrqedJuV71adSDpMa0kTisM9Dss8KECIhFxV6N8kIb8EhfMVJmYF03tAjLSBVP+
	 AS4Utm9wRcS6ppkwe631Ape4mh8LlfgZ5Vc8ejcg1vdFCZaa4zVRwjcbGrYFpHHgMD
	 kyVN/mD+lgU4g==
Content-Type: multipart/mixed; boundary="===============8739673785949913501=="
MIME-Version: 1.0
Message-Id: <a9512df5e75c264e0f20e8e61da2e3d8b2c7e6e5212217490acb7a94ed609bda@mail.kernel.org>
In-Reply-To: <20260916195203.1099646-5-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-5-ihor.solodrai@linux.dev>
Subject: Re: [PATCH v3 4/5] x86/cpu: Move 32-bit SEP setup into identify_cpu()
From: bot+bpf-ci@kernel.org
To: ihor.solodrai@linux.dev,bp@alien8.de,dave.hansen@linux.intel.com,mingo@redhat.com,tglx@kernel.org
Cc: ast@kernel.org,andrii@kernel.org,ryabinin.a.a@gmail.com,akpm@linux-foundation.org,hpa@zytor.com,andreyknvl@gmail.com,linux-kernel@vger.kernel.org,x86@kernel.org,bpf@vger.kernel.org,kasan-dev@googlegroups.com,linux-mm@kvack.org,kernel-team@meta.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 17 Sep 2026 23:49:45 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18C5E20005
X-Stat-Signature: cyswwx3tag89d1dfoqe1f3o5cykxehg9
X-HE-Tag: 1789688986-739185
X-HE-Meta: U2FsdGVkX1/xAFp6PlFF4GH3vCSucQqLlKvsE0pCLrsSPj2Zm7NtkYKz+ebup0CYSMYx6NbduqKoZ6hnSBunAkwpG7/AVd6fN8Oj9I5M/US0e5yLRYWPilR3vq8tQalj/sK/NVBfjmh/68pOnZm2FGA/RNO64Ft4rqmVVtnkjdF09ltfB63VffTVoBvsPeK4/vnC53ZmoAaki6R+cFQ33Lx+gjkWdQTPNzS5znrZGpFHIckn0YJ+rozdAwBV0XGAB+426xWMOQdQTGXcukNhVYsY61YYkO29zMOQUw2PH0+sL7t8IQ4GHvXViO4xEJFg4+Pf8f1X5xkQRh93/wtI7XUKGGLAlSNECmUxsRxfVhkL1Pz8akWNx9BUdjyxY9UceP4mNlX0LBwKIBGuSY9oQnw4XDwDxK4QwmfCkw2f8mm9PRziylxWG032kp1ikO7b/FXfIADBcu1Jvb3/Af22tQYTe6tO2xh2ICcSfk60rZz0Yg9MKsw+q+CXK9udS/oaThEFszKmM7gHzHrNfKtU6dsbVtQs1yHGHm4mA1ijuDrybs9QajjfPZpIo9cDZDmvPHW3hTnEQP/pNjjpxCU3N9z9tmHbKY+N2MQwF6D9dUPjFm/BpKl8jhp3M5klwW3JD+5Eae1cxvMo55d6dhvVl4V1uLBVmBY/gTexjFACqDIGs+6ypBz9HDo6fvpPvGbUBzHreYocnAMpMgCl2tWovDrFk7s8gT+6vVJUY15dkB1YADxwJXypOqHcz0e/7QHEDs4TvzUmvBxxEnHUokr1NumWw1H1xAgG7nDcTi+jJb6wfukTdsRgwRAjhulJ0iU/e0lXbfCMUDFNLbAPuzhfIYsDz0Frz+kNuJoF2YuFyKWOtDiBgPWkTTutkxjwvvdqlH5tQQuTU8SHn5+jRCmTPC/2M2zHFrvrLPIqTQAt81Jo5FAnoY/uT6gQSumXa2BmeUD5y+u7NublAIyS7va
 0+8ARQTo
 oTvT7E9IFbWSSR8Xt9k1KmmOSHN081bnZAd+iPT+W24YoYkeIr7+9JUuLNRKVBVjgp8Lb00mnJQtxhjmdFRrP98v2rQ9uTMU3dkuS164Z3dvhGF18b3dvlWNutoRrMdZ6hOyg0gGEFcYxeWoBEz7nySUf8aSN1PlF/JlJFoG8wpspxRwRK8vKxI5iIJY7L4lggWE+2q824o1LlNzIEkC3gj2KxyF+t6727pPT1f0V2qyOWgpsLvi0/BvaEqjzc6oSQRdOWgpjHVIDScybTtumBbx+Z2g86X2AnEItMzt4Vwshz6ll/LXrOOQGoI7k9z3fanZ+S/rXbLZ5o7yviWZFV0H64oVZkh9LaP0lwUNKU6+8rNNCNFRklAyXu+M6lPQfLL3diFZ8PML/d/akJ84JSzcEfiUldQJ667NvEZTCBQtHxG7I9POxK/Uar3gf3LXJ6aUhQJpcVi6E3RlzKCfSdwQbc4/v7dUHecaG6IfubTiwmbvomMxvw8VxtIly//v153Mkn0f7Mj2Qh2wIzx02+ZCqUIpKogBkupZW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8739673785949913501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 2b2a4c40ef76c..83d613d07997e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2126,6 +2126,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  	mcheck_cpu_init(c);
>
>  	numa_add_cpu(smp_processor_id());
> +
> +	if (IS_ENABLED(CONFIG_X86_32))
> +		enable_sep_cpu();
>  }

Does using IS_ENABLED() here comply with the kernel coding style?

Looking at enable_sep_cpu(), it's declared in arch/x86/include/asm/processor.h
as `extern void enable_sep_cpu(void);` but the definition only exists inside
`#ifdef CONFIG_X86_32` in this file (arch/x86/kernel/cpu/common.c:2138-2160),
with no `#else` stub for 64-bit builds.

Documentation/process/coding-style.rst explains when IS_ENABLED() can and
cannot be used:

    The compiler will constant-fold the conditional away ... However, this
    approach still allows the C compiler to see the code inside the block,
    and check it for correctness (syntax, types, symbol references, etc).
    Thus, you still have to use an #ifdef if the code inside the block
    references symbols that will not exist if the condition is not met.

The symbol enable_sep_cpu() won't exist in 64-bit builds, so this seems to
be exactly the case the documentation warns against.

In practice this links correctly because the kernel is always built at -O2
or -Os, and both GCC and Clang will drop the untaken arm of a constant if.
But it depends on the optimizer eliminating the dead code before the linker
sees it.

A survey of other `if (IS_ENABLED(CONFIG_X86_32))` sites in arch/x86 shows
that they all reference symbols that exist in both builds, making this the
first site to rely on dead-code elimination for link correctness.

Would it be more correct to either keep the `#ifdef CONFIG_X86_32` around
this call, or add a static inline stub for the 64-bit case in processor.h?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35285131592
--===============8739673785949913501==--

