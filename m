Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBEDF588DF
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5640A6B0005; Mon, 20 Apr 2026 10:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514966B008A; Mon, 20 Apr 2026 10:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40AD26B0005; Mon, 20 Apr 2026 10:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F91D6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:27:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 005E9E57D4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:27:37 +0000 (UTC)
X-FDA: 84679162596.21.AE55A7A
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4759180012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:27:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=cQx3iAWh;
	spf=pass (imf06.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776695256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iZB9lVR4tjlUQWISf4C9RaUtnMV6A5tolEZjLKPmq0=;
	b=UNlz+vNCy5oISP4peuDahFlFBaVkjcfOLB0lmHcGw6Ashq1E4B6Suoun2LOwJyfL1IFP2m
	UdUya1Rr0bV505ihHZUMU4fgXDMFmG5BYzSkU4fW9jYl5qn5nNIRF6tjzHHVIXARrArM+1
	GNvDgxnlOV4ewkyxo7m3oilgP0S8AWE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=cQx3iAWh;
	spf=pass (imf06.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776695256; a=rsa-sha256;
	cv=none;
	b=gohEiPRIilKDC3+KM4rsgHtaH6YZmDg01OgQRpwKFFpGXgg2Jj7BBvORonPyO0ofBsaEi9
	rT1keDmo4SdUlxStgLfZBmG0l+ZltmGxyWBNdCEeamrhllHsDknvgcfofI7ECbqGxhR3ML
	/J6IC0j/BmAA7B0ESbYDffWODIax3Nw=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 7518B4E42A74;
	Mon, 20 Apr 2026 14:27:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4520E5FFA5;
	Mon, 20 Apr 2026 14:27:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D76FA104609E1;
	Mon, 20 Apr 2026 16:27:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776695251; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=7iZB9lVR4tjlUQWISf4C9RaUtnMV6A5tolEZjLKPmq0=;
	b=cQx3iAWhs/KPT6ZKsayEJ77QUJ33XBAG/t0wnqcTpu3msayl+KXgWefDzyP6FHZbfakEkZ
	mUR9idudII95auF9BStFdEyg/ZfrWZJCELMf6aEJ9nJnKcF3lYW4yWiIbwvmeXqGWTpGmf
	6EF//PlEz9TgQjwnfV7Im08Tdi8PN2MJhTmQrHK3ZcYqVN+h4i1NR1PcJfySN2cwnhClDq
	928UAmnD/sIgSbP085aDV8aYk/2N8juRaUClIP5Mya/PjkZy+fiJZcnNXxg9mz4R2m4w41
	IRTL6ZhZmOioqx+JmCYgjuunP3yDG68/rxphRxpBvUN8z7Kr2df9dCBqhog1xw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Apr 2026 16:27:19 +0200
Message-Id: <DHY1WD3EUHEE.2R8PQXVKW6FO4@bootlin.com>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
Cc: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "X86
 ML" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Shuah Khan"
 <shuah@kernel.org>, "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
 "Alexandre Torgue" <alexandre.torgue@foss.st.com>, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo Frascino"
 <vincenzo.frascino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <ebpf@linuxfoundation.org>, "Bastien Curutchet"
 <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
 <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
 <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com>
 <CA+fCnZe-b0Qqbo5gGv3HN20twquQETDfYYkE1r9tPr9zUFbW9Q@mail.gmail.com>
 <CAADnVQKuptG_opA12O=Xb9_+cHf3f=ycAZdfUp17P2HBYQzdsg@mail.gmail.com>
In-Reply-To: <CAADnVQKuptG_opA12O=Xb9_+cHf3f=ycAZdfUp17P2HBYQzdsg@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Stat-Signature: x138c8iokugi9azxps3hrb8wpqwhus36
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4759180012
X-HE-Tag: 1776695255-886
X-HE-Meta: U2FsdGVkX1+PDcPVYCjE0HT69xjCkyGNljSpYIFxLIyjSBXWki8G5zttruXObP87ACqU65Q3AJ9DL3RrX5byVm1GJq+k/3Vh/iM9dBpcZQIinI/dvkacrOmWJt2nJVBVUvHfgmm/mexBV4QN2xDveHk6WllXIUxhW00XzbUiqmmIlH8m6+OwaHlBlP35kUEfNEbEe2vB0E+7HraZkC3WOl9MlI0GMDTclOoTnsI3nKaXMOxyUdp1Ibk128aEmor9PFvbRjIq4t6z5N2gpicha+KFTCJ9eMVZX1maIBqP+rksZpQbUMweWnktQdYah8lB3axK8321Pti4r8S4xVxr8P/VKXSRMPe4J7byA3IWZvFyMArS4Z+rt+B9QVBacRtW+KWI4aT6EPtk5Rdjd9a4X7UYBDGJpTqkSZpYQdvB7102qk/j1tURxQUghwj1tbHVLqw1xOp3whRrUO7ipnA5ySJ/scRGp2bFbehuypO3lDtEoP5LtFT/Y6Pc1y6jmy07Rl1+hUeylPCTcyBjjvmh8yutdPmCLwHTM1V+mhupE08sEI/aK3mqry321J1cnfDas8YbVviq92/S/JBPTYUpWpgQ4cctnpcOSiNc1AFAXEws2/H2ETO8P4kYuc1VzO0ry91npxZT+B1Mq9Iji+kGZF0ioXQEtNtWSJ9jNW6nNJujGjWSxXFqAub+079fmMnvlDfRhmGEzbZWcbAjUVamE3Wk/fs6scPkoXelJvkRRA1b+2FDkM4bqBv/ezWFqWiYgtv2NdjtqeZYR9MfxUmUoAIg+MQL17VOqC147zDoddCpp80RGvjHfjnJVlG+HIlv2CmBuhfZ2na0JFGj9OZXS1dBkgCjvBLUeoF/tkZffipnXJ9DPlRVbR54U0sxv13lGYEUQ8h92k6D5MD/nudEz/EM4TcqQ/uVtF2KAwgPm/NFgQlULOLE4a0pyi/Z4qjzYSZpvSsYqwlpAkoVD4Q
 rYY1qmyg
 LXhcKMClHtIx30jChwMpiz1A2jVS0opnECLkj497wvND0hGtY8y3JMfwiz8c6wh7CcGrnKF1qo04p792bpPxIO2BOFNDRtMkB9P0v8fwNGRHnHJV0Gtaf15m+JXozBV5uKE46jthptATefdNu03T2kVI6VYvvVQDjxNrWv53s0fOrqWW448nmGsWuWftoCNXc0DkFeVSFD5Px6v7i2dp0GerauJYNxgngZNHkRharQpKisbHbDz4/AQnrKdUxtvwjTFk3oU3BafJu9ohUut7Ep7CQfp9eylfjx3HSC/k1TDp3BITxKIZdvWFzXa9bemSg/p/ml10PtLH19R/mhLAtEgyLmuty760BAb6MlylUTbwHoYEWxlYC1a9psVv25rYfR1rfySaG/bWvUftf0nY/YoBc13+f+5QajFhsZfoAu8Eijjk8o2NMTSIDx2nLcc6+cEx4LGrSMrEBQxjHJUMgXdyxoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Apr 20, 2026 at 12:51 AM CEST, Alexei Starovoitov wrote:
> On Sun, Apr 19, 2026 at 2:49=E2=80=AFPM Andrey Konovalov <andreyknvl@gmai=
l.com> wrote:
>>
>> On Tue, Apr 14, 2026 at 5:58=E2=80=AFPM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> >
>> > I think we're talking past each other.
>> > We're not interested in KASAN_SW_TAGS or KASAN_HW_TAGS.
>> > We're not going to modify arm64 JIT at all.
>> >
>> > This is purely KASAN_GENRIC and only on x86-64.
>> > JIT will emit exactly what compilers emit for generic
>> > which is __asan_load/store. This is as stable ABI as it can get
>> > and we don't want to deviate from it.
>>
>> OK, I supposed that's fair. You did throw me off point with your
>> performance comment. But if you decide to add SW_TAGS support at some
>> point, I think this discussion needs to be revisited.
>>
>> But please add a comment saying that those functions are only exposed
>> for BPF JIT and they are not supposed to be used by other parts of the
>> kernel. And in case you do end up adding a new config option, guard
>> the public declarations by a corresponding ifdef.
>
> I feel concerns of misuse are overblown.
> Being in include/linux/kasan.h doesn't make them free-for-all
> all of a sudden, but if you prefer we can just copy paste:
> +void __asan_load1(void *p);
> +void __asan_store1(void *p);
> into bpf_jit_comp.c

That's actually what I initially went with when working on this, but it
did look a bit fragile, and suspected that I would rather be asked to expor=
t
them properly through a dedicated header. I'm fine with putting back the
manual declarations in jit comp, though.

>
>> > The goal here is to find bugs in the verifier.
>> > If something got past it, that shouldn't have,
>> > kasan generic on x86-64 is enough.
>>
>> FWIW, I suspect HW_TAGS KASAN already just works with JITed BPF code.
>
> Ohh. Good point. Looks like modern arm64 cpus in public clouds
> don't have that enabled, so one would need pixel phone to
> catch verifier bugs via hw_tags.
> So we still need this x86-specific jit kasan.
> I guess eventually it can be removed when hw_tags support is widespread.




--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


