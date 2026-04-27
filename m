Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD8CFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66E96B0005; Mon, 27 Apr 2026 04:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17736B0088; Mon, 27 Apr 2026 04:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF616B008A; Mon, 27 Apr 2026 04:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 790456B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:45:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11CD61A07A2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:45:53 +0000 (UTC)
X-FDA: 84703702986.26.9DFB7E4
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCD361C0004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:45:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=WJbcAplo;
	spf=pass (imf18.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777279551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enlPWmXbCXiBTtPjtrqyyDQhH4YVYS+iBt6pkMFkQHE=;
	b=Dc4jdXh6Mr3amCIEHJr2b0ShawAw2LcUzxgtWEvEU+X8c3DaelSCzVOvdB4AXSKODtcSZg
	5JxesX5UjGdN97uM1cTXBArcskV1k8wGOXXeIPlc22lP6eRxP/o4bgVjpMrhZ6wkY505D8
	ZmmUMrO360iBUZ1ZM56fUAByUR5Vkus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777279551; a=rsa-sha256;
	cv=none;
	b=nUF7II3tm2tHyuSPnirPWEap2lzpODTV3I46Dkz3igTj0+4EoFyD2vYWaLs0dj7QaeZx1U
	XYpjyqGEPU5+S0jsiqC3mslyHBoS8GiIYkmG1xxp4X0na94LSdtWM3sVEDOZUgXMVjIiAw
	XlAy4/MY/TKGTilAJH7rCBF2W6s/nfs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=WJbcAplo;
	spf=pass (imf18.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id A23A04E42B2E;
	Mon, 27 Apr 2026 08:45:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6D3D9600D1;
	Mon, 27 Apr 2026 08:45:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4E94B10722389;
	Mon, 27 Apr 2026 10:45:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777279546; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=enlPWmXbCXiBTtPjtrqyyDQhH4YVYS+iBt6pkMFkQHE=;
	b=WJbcAploUg0VmF8Pr+sfgdotkcsE+3i3sOgj0VN9GILZjM/dn7k2l6yEnDFaLgNnsHB2ke
	rIiFoGiqvbcbZUtxKswbsaRljyz+xXTtAxqH/KKDTh71KwOwbOw8l/vQCMnSwhlcMo4xCC
	xoIgVMfDds0upX6YXNRrk8BNT5gtD69tE0EPWoJGdDPyPEFVH4WSMc76pnmesP3PyyGxoi
	WSBqZVZb+deNlGfh7SjsbGBSVzPwbj+XpuWgjdaPkUDHoOr+AiZQXiqXcxWBxKDn39Kuzf
	8xtuEKI55YCnUaxvGQOliOLdPRRmK0uaNRPXrzMWGxybldX6FdIJZBopPxlCjQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Apr 2026 10:45:34 +0200
Message-Id: <DI3T0IKVGW9X.KVYWOQJN3PCI@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 0/8] bpf: add support for KASAN checks in
 JITed programs
Cc: <ebpf@linuxfoundation.org>, "Bastien Curutchet"
 <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>,
 <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>,
 <linux-arm-kernel@lists.infradead.org>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 =?utf-8?b?QWxleGlzIExvdGhvcsOpIChlQlBGIEZvdW5kYXRpb24p?=
 <alexis.lothore@bootlin.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
In-Reply-To: <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCD361C0004
X-Stat-Signature: xmbgpa3p9mbb5xeuy1miuaikh3gcfhcj
X-Rspam-User: 
X-HE-Tag: 1777279550-278994
X-HE-Meta: U2FsdGVkX182joeKsQUwQ2lUvu2RXLOycbaM+dq4tHA5wr7OabWCswx+lOfP4RoTOZxMgyUZA3YuoP1lLy6OpXoOXrvYxHAaRedSgzjhQb5anqzGK7pQLHjIrRp+ZJU0yyS6S7ufPAiAR0YsbNN374tK0teK6RTB/MeYVvzI7YCf8N2z0/iz6nED00qLs6taUsYSShKsMrXjfn09TH7Ie29YwJtcd1Z62Ol2DirdA9GMXQot98S4aFfrmTOqfq8zdadd1kVWyZjt0pbeYPPJoMKOWu9n0zv32qvoMrNSqQUNLNtEXr5mcGrTsKOMz7Qe28hM4EEcmYhCD4EsAEXGF0wLIVQfMPEqgq+6IER8CjObfeCfsUoT62URmoEpaarrzEV9HqZxIfOaZSU00/q7UwHOudZCzUkuIaExb86y6EUalegiOwL1eNXO3aGrodUU2fsio94yVWpl3aCHOg3TPVGvC2K82Aurz9nT9qGjkKM8EgNjBIt44KYvEwDA8n/xYmFJpbueBWmIC4+yFn6f5IgH1nIatE61yhHhk8uY72n0i3IGE3evQaHwWrWMC6wVe+yTSHW4v05ISfi3+W5QC+w974HMFSTnT5/o/DR+tRAV71uZnIzPtbK84DXpjhM5X8z0zX6/g6wKeCKspHm7W4lnVM2wt/22GSAJC5sIoyPybcReZR5NGHGcoJwyAMa+ZXyh42PF2zte6UAshoxKnlSn8bawOtb09z4cjzx1YwJ0vea6OprB9YSZ1Ya4oqMzZXjoCDbzRxef4HBP+A3YzH0Hm8tmzfl0UNxIdS+cPJK60+G1LPTElPpApisavqCAFxWAkf700l6ly/4Ndh+nZpSx2LEmjWj2bt4punXBq/+YR4x9xsEsopeGQXYo1OfTWAvsSJ7GZn2u0Ko5qJ0RkmQu4eGdtTU+I+odHUGWvdd9KOAsJJtazdVkC+doW2dI0FnRKMubbrTGEi8Dimw
 8t1zhq0Y
 PSOyK1Qu+8M5giVVojJ7QpQJc/+edXrUwio5RcNH6C9JFrSaFKJwCZvmtIxCI11WU+/RXtz+mxzzxy2ssyovMWBBIFryPk5KRHxFvKtThBazhVqmSOCvBlB2i/PmdhnMAXrpA/GLNDOaE4zZSv9vkY1Ot9lCgENi67/kevxH0TaEgHL2eoWzc/7YfqMnYC0Q9ixLph7xi+mIa6+dO5LPO0xxFHMrTx76S8aCJi5W8ivq9/rHuufmnggMjWG/x8y2uDzzaF/gkBQHmG8tCLsyojBW0n9YXxEgWDpwalYWj7zpgTDsfzUr2JnK+Ar1G3FOWT1sd/Grwp7/hhAFI/1tMLgqoSr6dFh46hTjslH+o9azL7ocVCFfD4pF2VtqL84zAZ3ExGuQ4rw+uQoKQjF+OiSat/cgZXutlOlMgEf9Q1cakYg4yCRCO08rOtR7JlhmiTw9c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ihor,
thanks a lot for the review and help !

On Sat Apr 25, 2026 at 1:10 AM CEST, Ihor Solodrai wrote:
> On 4/13/26 11:28 AM, Alexis Lothor=C3=83=C2=A9 (eBPF Foundation) wrote:
>> Hello,
>> this series aims to bring basic support for KASAN checks to BPF JITed
>> programs. This follows the first RFC posted in [1].

[...]

>> The series is marked and sent as RFC:
>> - to allow collecting feedback early and make sure that it goes into the
>>   right direction
>> - because it depends on Xu's work to pass data between the verifier and
>>   JIT compilers. This work is not merged yet, see [2]. I have been
>>   tracking the various revisions he sent on the ML and based my local
>>   branch on his work
>> - because tests brought by this series currently can't run on BPF CI:
>>   they expect kasan multishot to be enabled, otherwise the first test
>>   will make all other kasan-related tests fail.
>
> AFAICT this can be trivially fixed on BPF CI side, we just need to set
> kasan_multi_shot for the VMs running the tests. I will do that, your
> next revision doesn't have to be and RFC.

Sweet, much appreciated :)

I've started receiving some Sashiko reviews on the series (likely thanks
to some of your actions), I'll take a look into those and prepare a
(non-RFC) v2.

Thanks,

Alexis

--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


