Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069E1CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CD26B0088; Mon, 25 May 2026 05:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDB86B008C; Mon, 25 May 2026 05:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBF56B0093; Mon, 25 May 2026 05:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB386B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:05:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4CC9161AD6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:05:38 +0000 (UTC)
X-FDA: 84805359156.14.C5E18B0
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 812372000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:05:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=Fx+Uvlj9;
	spf=pass (imf13.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779699937; a=rsa-sha256;
	cv=none;
	b=lpDFtJiN27jGdOxAKGMlVEColX2BsuQSjsuwUjn7O6a/gWTmyJeIv9okFa2WyvlvskrONV
	MVjox4t91jcgiXBV+ZNfr0m3hw9Sc/tI0S/43a3HHIc6rBOX22qaRsFeGEpYFrndMA3ZOZ
	ueUD6mjFFNDw+Bib71/9M3Rm0WuYGxE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=Fx+Uvlj9;
	spf=pass (imf13.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779699937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbTl273WowpTVFd0f4oge0/+s8K6R22iN2Gqank6L1c=;
	b=pbnmmbSpGOdD4YWPpCuH9wXxcaIR2I9t/AG78iui3+LEOGRPkkx55lna11ttO+hSVnQME2
	zLiY0uOqb+ocu/xeAdt81moD8MIcX5+oogREl8cmoLGevj/4S68Dm8uVsqt3HmwJCpJNlh
	UvjI9lCctiAW+ccRBWSS5WZ2NxPI6zY=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 92C751A36AE;
	Mon, 25 May 2026 09:05:34 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 54B44603DC;
	Mon, 25 May 2026 09:05:34 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B71FC10812103;
	Mon, 25 May 2026 11:05:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779699932; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=EbTl273WowpTVFd0f4oge0/+s8K6R22iN2Gqank6L1c=;
	b=Fx+Uvlj9hDV8t2hT+BbSnAxNsdOpOaJIechqvnvpMOkSitZzXRjbsdPmMEWqyKUFfSsFqJ
	09p3+5rjCc8SD5giFz2CNAPnkmaK402kZ1+6NUodo6410UYt45sJg+eUEcarYV6jiVsG7K
	3r7plioTNGCAIgXGCNJ+2+ZTHyduDJ07uQslX/NevZyhzexSjWxmYTd3uD3CWiJVY0Dx6L
	1Io8kWVF0On9LOxU2++gFB1HzzqUg55GF2+VuffbtA126LB+ZWF26BfdlTvZICqiAoOO3B
	zd+yqqxctwthai14JAAAUMFcgFwq3eBOVqm4oxh90R+vs0N3KX+iOH5nwmbVzw==
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 May 2026 11:05:16 +0200
Message-Id: <DIRMYUXFYOVY.1LQV9E3OHGGBK@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "X86 ML" <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, <ebpf@linuxfoundation.org>,
 "Bastien Curutchet" <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Emil Tsalapatis" <emil@etsalapatis.com>,
 =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, "Alexei
 Starovoitov" <alexei.starovoitov@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
 <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
 <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
 <DIP9O3BEWG3C.2BAHKYUIA4H4E@bootlin.com>
 <DIPDH3PCUDDG.EGYL0SYSG1IO@etsalapatis.com>
In-Reply-To: <DIPDH3PCUDDG.EGYL0SYSG1IO@etsalapatis.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 812372000F
X-Rspamd-Server: rspam03
X-Stat-Signature: hu8wbjeo7edgesoziuf6q1hatbg968db
X-HE-Tag: 1779699936-390406
X-HE-Meta: U2FsdGVkX18pTqHsQXTydHI3J9F08XqjXTlPrzYxUSBhuX7LePNYS36YGwSESKAzPe05+K70/YhPfA//BL9djReG0Kj4QWFeSnGDvdSQA6u3W+KLa1iDg7KYHA29eO/y0krruHChEesZHwhpFvnhqR+R7c2cdyyElvCZvm/aPqliMWPFW6H3P54+sa79NGU7JqvbRDHESazPutl/cKSGJ9SjU2DnkoJnSPaSSBRMET2lGfe1P5dqqB7i3v4fKbikhDjwI+feqkz141TaRnbCaLHrc72gw74ESpeW0/ySycynb2pVm4V38kr1C2XYEM1n3t543cJqcG3eO2WcosFhhcpo9qABynGe4530fYSIeN6eFJQIjDwM6M7o+AWV+ZkcPA4EGtTHY+vmijY1MujS2QNfR2UIeMpCqdAlpoOILpsYbKkrYBZss6GLpAZnb+arbZFNppxNxbYwtZKcFs4d9HCcG/9ftPIV4jK5I2zvoYMGllcPJCCVWQX23sieZDVXWbKOp/rQIchsYz1A5sFCwWs0TJR3Zbh708o0TCVEKz5aAeP+hIhvIVpYI2QUBx4fP8/kaW0cMY2UTd74HYqzSPEeCOZ2sTMWLNVR05vRSNnyAtpvTSUQs+mJGEBM/WOhsiNf0f/PuoTLLOyEYvzDZx/EBe3enlGiZfOaBV5wlQrgBst+Umy9+CMd2UY60MeRNWWMDpatI0gAJ6oSxKBhJ8/fKDTqLFJGZIFtKKgiWvVupS5ewWKL8PsL0Q90x7pvQi0njBcP/vtKgWmmZc2oW3iiI37TzTyiC4wU8bJfwGmBk6vFh6Q9wENIoMc7e1AzRss1lpP2cAreugwf43WHAw8CsZbuY9JspvdiRMzzi32PuAMEXnHL9n6S9vtnJeonDDZ1VOBQh3ZEQ27Rrhu0BlliRoL3SNxf0GvctqRKVQYV+IPG/2q3QUGR8oShecL+c66AmNEmBK9GUNViJ+y
 rDjMesq6
 3Ll1pvOn6iRMGAj2R6Fe5bKpnvUNE958VS4+wotwPys7ShVPvdiSijEnHyBKkyYEcxpvrqqDJV0BL1Y5TKqW1nlxSX+PMqy7rlhs/CGSTe43T4nEOYIime3WhBUUp7fInIUMq01G1qFxIZjJA60YPJv+0trvY0FutIAEEoKzrxvI5prDUSQSfAdSucDZXkRL+jMC/Xr0I+pEBbxJmxQQQ9rOLi9x3I2oeqdGhQIDq+E5CgqW6SUU15Zqnkxr0As+nXQe1Atg1blEj9qsG5gtVsP63B2b8JeHLOQidC9cQDL4ji2snk24EJyImRRYUFc9eVfMBi5r+sLRvkd7O1DzcXdz2I8xRiOtlsICzuNrVXMz5L6uXQZZFzt77PlI6ZAHk9lgfFCPGGH0AlyPp0ANYqG+xRd1ltBq+lnmnUeUEzPRp7sXm30EnZYZIRcuMr2SpzzxYMvjmeRSLjNKEtGvjXYfYVXvc3N0eLoLOkgTkeX4fzEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 22, 2026 at 7:13 PM CEST, Emil Tsalapatis wrote:
> On Fri May 22, 2026 at 10:14 AM EDT, Alexis Lothor=C3=A9 wrote:
>> On Tue Apr 14, 2026 at 4:38 PM CEST, Alexei Starovoitov wrote:
>>> On Tue, Apr 14, 2026 at 6:24=E2=80=AFAM Alexis Lothor=C3=A9
>>> <alexis.lothore@bootlin.com> wrote:
>>>>
>>>> On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
>>>> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Fo=
undation)
>>>> > <alexis.lothore@bootlin.com> wrote:
>>
>> [...]
>>
>>>> >> +config BPF_JIT_KASAN
>>>> >> +       bool
>>>> >> +       depends on HAVE_EBPF_JIT_KASAN
>>>> >> +       default y if BPF_JIT && KASAN_GENERIC
>>>> >
>>>> > Should this be "depends on KASAN && KASAN_GENERIC"?
>>>>
>>>> Meaning, making it an explicit user-selectable option ?
>>>>
>>>> If so, the current design choice is voluntary and based on the feedbac=
k
>>>> received on the original RFC, where I have been suggested to
>>>> automatically enable the KASAN instrumentation in BPF programs if KASA=
N
>>>> support is enabled in the kernel ([1]). But if a user-selectable toggl=
e
>>>> is eventually a better solution, I'm fine with changing it.
>>>
>>> Let's not add more config knobs.
>>> Even this patch looks redundant.
>>> Inside JIT do instrumentation when KASAN_GENERIC is set.
>>
>> (with quite some delay) I think it would be better to keep this new
>> BPF_JIT_KASAN, because aside from the possibility to use it in
>> bpf_jit_comp.c, it allows to update tests affected by KASAN
>> instrumentation in a nicer way. For example, the test_loader subtests
>> that monitor JITted instructions are confused by KASAN. I can either
>> skip them or make them smarter when KASAN is enabled for BPF, but in
>> both cases, it would be nicer to just adapt the behavior based on a
>> generic CONFIG_BPF_JIT_KASAN, rather than sprinkling some "if
>> jit_enabled AND CONFIG_KASAN_GENERIC AND ARCH_X86" in selftests. That
>> still does not make it a config knob, that just creates an internal
>> Kconfig option that is automatically turned on when KASAN and JIT are
>> enabled at build time.
>
> Having a togglable config knob gives us the option to set up KASAN for
> the kernel but not for BPF, and I don't see why we'd want that. Imo we ar=
e
> already paying the cost of KASAN for the rest of the kernel, there is no
> incentive to not run it for the BPF JIT. Having to eat the complexity cos=
t
> in the selftests seems reasonable if the alternative means a cleaner
> interface for the user (preventing them from choosing an unreasonable
> combination of options).

Again, this does not expose a togglable knob, this is a purely internal
kconfig, automatically enabled if CONFIG_KASAN_GENERIC is set and if the
architecture-specific Kconfig defines HAVE_EBPF_JIT_KASAN (since we want
it for x86 only), and there would be no way to enable KASAN for kernel
only and not for BPF, or the other way around. What I am proposing is
just an internal, architecture-agnostice kconfig to avoid conditioning
some selftests to any architecture.=20

Alexis

--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


