Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F35CF9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E524B6B0088; Tue, 14 Apr 2026 09:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BE06B008A; Tue, 14 Apr 2026 09:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F2F6B0092; Tue, 14 Apr 2026 09:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF7FE6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:43:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 680CFC1F61
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:43:58 +0000 (UTC)
X-FDA: 84657279756.30.A240DC6
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2B6D9A0005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:43:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=S6AAfSv+;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776174236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBYaHCpG8hC1NEAoLKhT2eDDnp5ePCFis5i2nukgCY4=;
	b=DcJTZfGbZ1OjTgEcbcg9E3b9vtGe/GSi1IhJPmByhggLgADSZOgXqiitOcd8RufjiNPZb2
	bZ4uNcqiWT4dzzKskDmNmd+tpMNyb7AU6PMfx62wQzOGzTdTplE4dytPAbz9mmmUgpa4We
	VrnPsFOQ9Y+qkxqqcpcxwj3eTnbind4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=S6AAfSv+;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776174236; a=rsa-sha256;
	cv=none;
	b=uqHJpk6V4Aw1ztpY45L07cPF74gF3xwt/aouuB93UyriRUgfxbnykDt9VLpApttgxCeG3G
	in6KFhlsnUbKpuc2gJoyCu6gt785oTvf/4dUWgxav7Sl4VmFmVT28txZTjKCyLdIWD3d/Q
	a+gbcwU/YY2hXRjlZqAtoSd4rSms/kw=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 210641A32A8;
	Tue, 14 Apr 2026 13:43:54 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E416660410;
	Tue, 14 Apr 2026 13:43:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 450DD10450118;
	Tue, 14 Apr 2026 15:43:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776174232; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=fBYaHCpG8hC1NEAoLKhT2eDDnp5ePCFis5i2nukgCY4=;
	b=S6AAfSv+oUeOvIrxD+z5bbdfpbvEOB21uXEtXvB4AqMh4FY8aCuyB3wHwx9r7WuVdHJYL+
	rD0/08M7IBbmkTkrkT4y4rKcwWyqFckHbY0d9PtwNrkx7DaSk7KT0vztBafKaTOmUOws5w
	qAGaNH/SCsFaeSpXq+U1fXnRnSb6RTAFiP4wAme1fA2E/ecJefwxeRaUPgj3ZmXhRt7wxY
	aas0aDmqQnMSQ8xEcyHooL1//5S5S9RSul/ZsJlUWSIBozq2b3PI6l6xl3ldUHUduj47SE
	koioV9P/g0ItanZHdEow/RtOOTONKeljDR3QB5PLNB90x26lfEpu4eQqk7yUEg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2026 15:43:42 +0200
Message-Id: <DHSX7PABLUSN.1VYMRZ02DFZEL@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 8/8] selftests/bpf: add tests to validate
 KASAN on JIT programs
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Shuah Khan"
 <shuah@kernel.org>, "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
 "Alexandre Torgue" <alexandre.torgue@foss.st.com>, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo Frascino"
 <vincenzo.frascino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <ebpf@linuxfoundation.org>, "Bastien Curutchet"
 <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>,
 <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>,
 <linux-arm-kernel@lists.infradead.org>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Andrey Konovalov" <andreyknvl@gmail.com>,
 =?utf-8?b?QWxleGlzIExvdGhvcsOpIChlQlBGIEZvdW5kYXRpb24p?=
 <alexis.lothore@bootlin.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-8-1a5831230821@bootlin.com>
 <CA+fCnZekgcEgsZnRrOB=+HoG=neRg=oLTt2jStyrPJ6mYf2ctQ@mail.gmail.com>
In-Reply-To: <CA+fCnZekgcEgsZnRrOB=+HoG=neRg=oLTt2jStyrPJ6mYf2ctQ@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 2B6D9A0005
X-Stat-Signature: 4n7qfesby3cmnzhkrk6uuh8rrqbi7gmc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776174235-400115
X-HE-Meta: U2FsdGVkX1+3MFvZ8K6sVVV8ZoAVxinuyvyQa3qNO8kUKieN3UWcbeQwVMDub/nEua2X6ELBoSWfO5TE0yNZ8NjXxZFRIaJdfxz43aSyOirAounGKyTUgOn7fyXgTEMAolnnT/chaEUFhADEFGesmYm0Yyyiky5x/DrMA3NbGmARl4T3PAscQbXFcKwmyxwxmeYtQVyfEg1RAPOCpUlIhvIl7s9aw47fnZhI4WSq3/zVl+3LEWIk9YC8KgWFZLoCPqjFUQCb77kTeOloGNmaoyYww9JUyvcK84I5RtBNhSj5IGH8rRlJ1s1k2NP1VYS/FHUaj7XObbMUtIe2Juwy+3jHz5EnM5KrEq45qI5IgGNb+bMyg2qHASuzOWC6ulbW/ub7pxZW0wmufNU9QhwIyW+L3gY47QzfHymufijqb5gGuSwuwDIYAUmpmKvyhS0BKkrgx4a1X11r7JfMCKjpgkOg4XUORoS9qrUgMAlieFHB6H5ZxJtATGOwtZLrMObae7Cec0VJRLQeHYSyGxNQyBil8vcVlQhU48a+sDjo0R2xo4phq4dGb9ztZ/4B6JuJc9t8AupuiN+V3b5daq8p+NYBkhsmlxzI2Vs6QsatV3kvgpIwA1ysfXWliSaJmoz3pwzzQPv1XmX/mwmtH6+0l4CVualJViQlcPaC3hj3CCMCI7FTB8FhjBcqs4iQpM8fAUaXAEqHmyuVzfi6cD+Zr7e7Ka+HeW5SKohmjjNwwZPJP+iCPJz71NdNrWLHON3QedviLLObyrkRPOPt/khj0fYHnBn6qNUwpsL6b06+TAP0w1iEk19wmhZUhhPhOS/JzDr4reL1kKms3kxHasne/IyM0QMWtJYAj9Ec7TwxxkPzobtH7dOZTiBA5g4PKDVsdEmvO5x5uwwxFn6JcwaoKsh2ivBVYeSilqs4z/jBdszqofp5X+JUTd2a5r+9JgH3e4Fexo5ON0SEYD5P7d4
 zX02NqJC
 gRs0id3c87BbC8R+JCQ09POSubLDChjJNbO8t0aFFCoyJQkZV4S9Ds7qWDp8UuiCTFuSfDnBfxhb5UZPSeNjJKt3nTtfX6mfJ5MlpXasPR71wjBt+Sh2aaLpJFHNWMhuR04gFkwcwP1XcOpzUw7YNUBMV3SUIpWnRVdpRPyTfvlUpk1LmPp84FQa3UAHM46Si2q/jHMONGM2nuDlu4t05M8m8LYO0mjvudwQ143zROWFRxbRdwft3+QTMa7cFyBAUDN/+e0hXPm3Xf7VYDqE0b8/dI2CVwljqAs3CoKlTIOGORjI7292FuSp+rs2V7uitwAVF7GNpQSqRoJ7WhVi3x2Pbr05iw2Yr3ZGYTJ3Yz2z86xMmsNv2nFbHwUl0ZGCE5am32vRO8pUQ79gE8r2oK5UgDyXcBcA8q5GAhyKUQvq65F8Rmxs84McDGf4ICucPaTMswl8R5PW5VAR24ZIuEyQNyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 14, 2026 at 12:20 AM CEST, Andrey Konovalov wrote:
> On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foundat=
ion)
> <alexis.lothore@bootlin.com> wrote:
>>
>> Add a basic KASAN test runner that loads and test-run programs that can
>> trigger memory management bugs. The test captures kernel logs and ensure
>> that the expected KASAN splat is emitted by searching for the
>> corresponding first lines in the report.
>>
>> This version implements two faulty programs triggering either a
>> user-after-free, or an out-of-bounds memory usage. The bugs are
>> triggered thanks to some dedicated kfuncs in bpf_testmod.c, but two
>> different techniques are used, as some cases can be quite hard to
>> trigger in a pure "black box" approach:
>> - for reads, we can make the used kfuncs return some faulty pointers
>>   that ebpf programs will manipulate, they will generate legitimate
>>   kasan reports as a consequence
>> - applying the same trick for faulty writes is harder, as ebpf programs
>>   can't write kernel data freely. So ebpf programs can call another
>>   specific testing kfunc that will alter the shadow memory matching the
>>   passed memory (eg: a map). When the program will try to write to the
>>   corresponding memory, it will trigger a report as well.
>>
>> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boo=
tlin.com>
>> ---
>> The way of bringing kasan_poison into bpf_testmod is definitely not
>> ideal.  But I would like to validate the testing approach (triggering
>> real faulty accesses, which is hard on some cases, VS manually poisoning
>> BPF-manipulated memory) before eventually making clean bridges between
>> KASAN APIs and bpf_testmod.c, if the latter approach is the valid one.
>
> Would it make sense to put these tests into KASAN KUnit tests in
> mm/kasan/kasan_test_c.c? I assume there is a kernel API to JIT BPF
> programs from the kernel itself?

Possibly indeed, but I think one important use case will be the
possibility to run those tests in BPF CI ([1]), and this depends on
those tests being integrated in the test_progs framework
(tools/testing/selftests/bpf)

[1] https://github.com/kernel-patches/bpf/pulls

> There, you can just call kasan_poison(), some tests already do this.
> And you can also extend the KASAN KUnit test framework to find out
> whether the bad access is a read or write, if you want to check this.

Alexis
--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


