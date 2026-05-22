Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9CBCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0FA6B009F; Fri, 22 May 2026 10:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A176B00A0; Fri, 22 May 2026 10:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202176B00A5; Fri, 22 May 2026 10:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 070546B009F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:15:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2ED3240778
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:15:01 +0000 (UTC)
X-FDA: 84795252402.18.FFBF7D6
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D94B1A0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:14:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=y5oLDx4M;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf19.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCr0vkGm9xcy3EIrUUYMtpoAG6We8dBTUowneJJEzqk=;
	b=xi3PqQiBq4AiRaCal64cuwQB6CaYni8QlQcjpUkq5BFs1XBxmQY84HZ++hc6UPVOWJ0sw+
	FCRf2mwslBfxSKpJMI7zPOGPlbjOkGbIWItYVgS5egh1cJtVBXLUTNb8ILH4SqhiWM9v4H
	m3c19mkdkxzVNLBCft1B83OyciXwMuI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=y5oLDx4M;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf19.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459299; a=rsa-sha256;
	cv=none;
	b=VveGvD54JXdppveoWrPT2XS1azbmpOQ7U+FYMeOIZTuSzGuWldUsQK8UCEphIW6evT0+uJ
	F5IeBYcCwF1ukMXt/zG4rWd5kxMjVTEgZkiNUr00LBo4DAhcW7uFoMXTF2u/l1oUfNU2cg
	w9PN60y3d8IrZf707P0K57u8lVkg9FY=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 435541A366A;
	Fri, 22 May 2026 14:14:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 02B006003C;
	Fri, 22 May 2026 14:14:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5BB6F108114CA;
	Fri, 22 May 2026 16:14:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779459294; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=MCr0vkGm9xcy3EIrUUYMtpoAG6We8dBTUowneJJEzqk=;
	b=y5oLDx4MGy2qc7YsUG7iHN1xn8YtdnwJTaS+MweXzZYeTNKztTrSK6FkTS5hegoJZRjtx/
	+KPJ88pozLnoBFId69yh0BFSmYr2Oid0fQhr2rdZXSEViLMGh37HZ3wFYq3sXIwaltcL4H
	Ru8nuWXTFrJ7XB1LT7TKvjf55JQe+Wwr57sEwswqTCVrHvSyCZl6RSGSFe4rzRp/5LcBlt
	U9OC+4uUcAsfHb7a6LexLMZh7y7JlLFFF5SVyh2/PQsumMTUzuN7QBIlOn2LRCblqP/6xx
	dRGN6BEjblEu7ydOpdyrpOiH0emrXZ12KjrfkRuxO1yuH60EFy2zP3F5X5BPHQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 May 2026 16:14:38 +0200
Message-Id: <DIP9O3BEWG3C.2BAHKYUIA4H4E@bootlin.com>
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
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
 =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
 <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
 <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
In-Reply-To: <CAADnVQLj=UosnsC-4V2+mN92Fe0-kW++U+m-O9c93kk6BwiXgw@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Stat-Signature: 9ukd3oi3uh1mawem8xw4xcz6dsk6cbot
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D94B1A0005
X-Rspam-User: 
X-HE-Tag: 1779459298-364140
X-HE-Meta: U2FsdGVkX1/rWVRWMy6Lkarlh20sdofXFHLYAAeMqTscPsWmvg90vDknQNbfNbj04/dVgxQI9cKTBin7TG+vNaT7Zc4anEAjbGk7scU5+y1k0lDrJIhTmrvlpnJRx7OJmHjbxn8aqI4B5Q06RWHPwuclCNYrVVIG80CGn1u0ooyCzRt3QrNr0IGtZ5EXGHWNglx8iwtPLqS/GfYgMJ8PVUzIl22TR9nM2Rl0jtaoodCns238d2lDpLOUocLRo8CRfjaWMmHCTYRYjJ8MSsE8OzvMA4uaMKQMM4kbszZT2QjFYF4fKfsS8xDOym++zgZWVP7qXlDbh2SDC4+fH7er3LdwNGdP4VtJisC5CNcwNKZ7xKTCtU0+ySgB/Bc7G/Jz+KkfTaeZR+b4E802JlcoOTAuxfyulFZoA3Wd7Hwb1mmuN03a7WTiuYcWkd2pUnoeD68/rGUgYJ6Znd0Qf/SJK6exrxOTwO8l8a4zqb9GVVVQkKRwW2DWJwvN9b8VwtmaT8nNsRq2jycUoI57pdvFFuV88mHUlq3Ca5N5u4bKXONU4NQzW3cXXJju/qNFHS2gRgQwo0W8uxWSDFEIE1gUK/CRHFRlAaj3EQoIS1PNnv4Pc755nCFD06zpkhR5tH5Qzsb6HJw72oCvL/XrfSqHLLWVbmHRyby/0u218zRwxI6TlYxLB4AU51r7GU9+JBf2OSpmyqqTeHeYMxRlXSuCz30YmCKGMQhIl2QZOr1Z6f4ittNB1q5X+u6FNGTOzhIkUL2bLCa7q5U5IRn2IRmcjkEk5E5BZLbEj2bX6b/c/vh7RLgqH2V7ew2CqPRI6ctzLtbf3LMLyHvSYYchUL27Lb9KJ0SM2CKG3yPB9/8FftyigaISiJErJBKrRlVg6mRQO2gcOWot7J4ZE3XYicBo3ytlD5bugpNbwy78zF91NZl2uGOliZypIhmphQIO4+Y7/0MCkKfOjlUCwGHveV1
 /dcdbP/i
 AWgbfpDXUL5qy+F2v3kTiWPEuUY7Pl/PMBM32G+duyrCfAHEoQ0JEAhxwRUNx8NEu21Li0V45C5gflNgCWmDgEz+gQ2E6sJp8ey+ABjSZNSmZ+WwiAy1+8YfxjlwPSpUaLmlOd/jxvKSJDKPEZhc3nAiAd//GQUqnqLnyfxdF2TDnGY0OUN9qRvBwateMi2kPBQlINwWruMpZ3AYVHNXv5sbIkE0Nzl87u2xmxONgrbBVPnzDf7hzBVJjCQSX7fAsJJ/qnbGk7c4Ukx2hdJd5zxjFeaf9WlBFc9nZIb9hvRnpH8iPfISipSUtOExEEPBQ861Zm3BjBWXDfEMGPWJYdtIIn/UZ76Pqc2Ur7iGiAxBQIUiuod0Fjv1iQu+ROErrpm6/SfqewturNoSiux/ZUqMsJlvYTwR5tYzE65ba1v3jS0w9uYznw7dJsovDI92y5RrYLh1kWbhvCu11PAd5b8gdHkCkfR2kt2hHwIi6eM+pwpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 14, 2026 at 4:38 PM CEST, Alexei Starovoitov wrote:
> On Tue, Apr 14, 2026 at 6:24=E2=80=AFAM Alexis Lothor=C3=A9
> <alexis.lothore@bootlin.com> wrote:
>>
>> On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
>> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foun=
dation)
>> > <alexis.lothore@bootlin.com> wrote:

[...]

>> >> +config BPF_JIT_KASAN
>> >> +       bool
>> >> +       depends on HAVE_EBPF_JIT_KASAN
>> >> +       default y if BPF_JIT && KASAN_GENERIC
>> >
>> > Should this be "depends on KASAN && KASAN_GENERIC"?
>>
>> Meaning, making it an explicit user-selectable option ?
>>
>> If so, the current design choice is voluntary and based on the feedback
>> received on the original RFC, where I have been suggested to
>> automatically enable the KASAN instrumentation in BPF programs if KASAN
>> support is enabled in the kernel ([1]). But if a user-selectable toggle
>> is eventually a better solution, I'm fine with changing it.
>
> Let's not add more config knobs.
> Even this patch looks redundant.
> Inside JIT do instrumentation when KASAN_GENERIC is set.

(with quite some delay) I think it would be better to keep this new
BPF_JIT_KASAN, because aside from the possibility to use it in
bpf_jit_comp.c, it allows to update tests affected by KASAN
instrumentation in a nicer way. For example, the test_loader subtests
that monitor JITted instructions are confused by KASAN. I can either
skip them or make them smarter when KASAN is enabled for BPF, but in
both cases, it would be nicer to just adapt the behavior based on a
generic CONFIG_BPF_JIT_KASAN, rather than sprinkling some "if
jit_enabled AND CONFIG_KASAN_GENERIC AND ARCH_X86" in selftests. That
still does not make it a config knob, that just creates an internal
Kconfig option that is automatically turned on when KASAN and JIT are
enabled at build time.


--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


