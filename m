Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A37F9D0CF
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200E76B0088; Tue, 14 Apr 2026 09:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFF36B008A; Tue, 14 Apr 2026 09:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A02A6B0092; Tue, 14 Apr 2026 09:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDC236B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:24:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F048C1C9B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:24:28 +0000 (UTC)
X-FDA: 84657230616.05.7F5C73E
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf23.hostedemail.com (Postfix) with ESMTP id 456DD14000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:24:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=X6A4tqU3;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf23.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776173066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMPO/P6ZptnY7PwA9Kq6DHiKsIFPvqoz4r+zqZlAlBc=;
	b=tGBJ582jHc2z8Gk1qBWivOO0XMRFO28Zo7qIWayYcsD5DA1g76nGBZ7PkSf9F0m6R3YfTv
	hh/5hKszVcoI8mDPLT6OUeChPMLG7FKBOiy8Vq7abU93XKQ9g83PdumrPskeKrP4JiCnFD
	QF+a9KMPcSVSOnDvbBBzcLD57l9iRAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776173066; a=rsa-sha256;
	cv=none;
	b=xxxsYjbzHEXwa/U1nM9iuzjTZVsd+/dS3hS+u4hpAmzm+QxCdtBO/eGsVHWSVHcmkpiDrk
	bFG8g0lFykkXRjsdavUivnGxMpDkH+Skzh/BR1D9Rj9hyo4vV2+GzjA0ddxojF+LWkUdk8
	t9ARE2wH4dJ01lQU5yfTUG+Z44TZsNs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=X6A4tqU3;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf23.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 49A624E429A0;
	Tue, 14 Apr 2026 13:24:24 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 15A6960410;
	Tue, 14 Apr 2026 13:24:24 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 91474104500A2;
	Tue, 14 Apr 2026 15:24:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776173062; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=cMPO/P6ZptnY7PwA9Kq6DHiKsIFPvqoz4r+zqZlAlBc=;
	b=X6A4tqU3MkoqM6hdV2BYcurk14+6JZDEN/gbqla0kWX1zkUOVhzepr1g+eqrPNbNUv/huV
	YvRVcaXQMDSoKNvHHEev5avgGrcMFEKbpEaqiYiDYgm7Bt3jlvoqJQ5ERrTOmbM6hkpZ4c
	lSZlrap8zNk/UzuRZwSWbVolH6CoRl3/X0CCVwBfc1YF32vGuKDzOTtnFMST1koqfhy2JQ
	FHgxzpJuT7y8RT0NzKx5KsKEo6MlgAJgguOw61CCS91aw38/mmn96yQctauQKN1Mw/26EC
	Mku30aEpcpuqoVCUdGMmoRzHpFjahdvvfYrXfOquex2Iaj6Ff2PksIHe5lfBCw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2026 15:24:14 +0200
Message-Id: <DHSWSSYRPUVC.2W3G3OU27L3HG@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
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
 <20260413-kasan-v1-3-1a5831230821@bootlin.com>
 <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
In-Reply-To: <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 456DD14000B
X-Stat-Signature: zrs3r4e9xp35h3ncsfk9s8b61owg66kz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776173066-21553
X-HE-Meta: U2FsdGVkX18nVRAhqEaPAPTRAp3J+cMO6/QFHG4VmkMKRDgy6AWzijpd1+9Nw2QyfU4fi7O9YyccBs57sPI2tVchx5JHX53zlA9JRCQTLXIv5QNDD61XArINj0PDLYRO9/pPnHO+PBrwkfa0bvpVdt8i9trxiqzo6kmPejFEhNwLq3i8R0Brq/wJB4nSa2S340KDkEgrPtIpE2wjAh1jgnpgU5qcQwdkILo8EnGGTVokkfmfwynYqu8FuOpD9XMgZb8av1eYxJNEVO+rbiJv4rno33N/wCfb14vKt9la6wL4AjqLFCF84ibfJHk0KQcHMfB9wonPS0Ssk+ORELivyMzGiUVeYW9Y+xh19cD3ohJsHhSF+ME2VQF0QwbZB3AoMcBJhU26iY9WYx5I7xx9fZGH3VgeOban2tB+6uaW3hlm73UhiSWwLSDIzAnP0+0lhsVLjgLh6akAZMCOqV8j2QJ4X9uOSertYsYtHptwyRZQ6avsWBf2Xa427RVtYyYsGKGzKfpiXY49P3+TPHRCaIkYRucCZGrWztJje0Qka/hbxHOpi1/29F3rD9+NRvW3zVObws/1Na3zMIt/nzeaOu9/vThRRQXyguilXou3N7VKMb/PwBDtROklNyMo24ZIAcBPYcr276icL8Ja0DGGgfj4EwT2kLUxpHKOI+qfGzIX/kQ92n7T/C6APd+gL2cyxfqPCxdhafH1clQqp6W7EIGYHocBriWe3QV/RVEdYUp8VKc5I5wdrGLRqc4TiIVN3o8U7DLvx4JzlLADTgcwenKkNU3v9Chcq4J6waDpU/qW9TiFGEigh3epyKYOFzHiSemXM9PbO05RcGuPsskiElniloaRuz5/lkGheyGAFLHSoUU3c3iQgDdfADQFbyS7SlzaCzZ/UgI5ApzDY1lRG+nDye3aJCpjYWeLgAHseO+zoUKXVIrAYDJO937SjxJAlCkzeWEDkHC+WtKriwE
 ChpuwVHV
 1LH396BUsQlmu9WVOEyP91GvSI0k6UHJWzOsEK0zW6ib+0BW/4sV2RUqXBWjoibQAyve0RqDjUFPHzlrURevetYfgVi2wpdbjB0/TRrtuXdIWCKcs9k48ZwQmsiKWUt0pw799vdfrLHCi+CfrLAiylm875iVqJmn49l/xCC3+d6ajr0scWk4WUwx1+jGeV7p3E+R6KwHxWVf/wCm67bncooY8hFdk3CUB5taYwIs1CjJYdq46zFmblAzbGZYWoUgxwHD1MSJ9b1Jb30ZvfCL72gtujqTGruQiaWvkTYHeIVSdM/Bv/mEjHQvMniI2E8mKO15L36oJrtJqR0/ZHxZP0e3TJHlMjgr/mQnIT7lStf2EgU12qitPDuEhsX3qwZKxvXaUNX0TEVw7bc7hAFBnzNCF0MUHzjJOfM5YOuT4WIvpJSx8IEN83FMVR/of/N06XJaiU0JMmqFgMjIY2kcHu5OYS8N6xNkg3QX4c1AXUFwgC/PnawTLPqoGUwJDA1pOBr6WHroUGipaLHMDW3JEgiumW7r7kNaXnCUG
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
>> Add a new Kconfig option CONFIG_BPF_JIT_KASAN that automatically enables
>> KASAN (Kernel Address Sanitizer) memory access checks for JIT-compiled
>> BPF programs, when both KASAN and JIT compiler are enabled. When
>> enabled, the JIT compiler will emit shadow memory checks before memory
>> loads and stores to detect use-after-free, out-of-bounds, and other
>> memory safety bugs at runtime. The option is gated behind
>> HAVE_EBPF_JIT_KASAN, as it needs proper arch-specific implementation.
>>
>> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boo=
tlin.com>
>> ---
>>  kernel/bpf/Kconfig | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
>> index eb3de35734f0..28392adb3d7e 100644
>> --- a/kernel/bpf/Kconfig
>> +++ b/kernel/bpf/Kconfig
>> @@ -17,6 +17,10 @@ config HAVE_CBPF_JIT
>>  config HAVE_EBPF_JIT
>>         bool
>>
>> +# KASAN support for JIT compiler
>> +config HAVE_EBPF_JIT_KASAN
>> +       bool
>> +
>>  # Used by archs to tell that they want the BPF JIT compiler enabled by
>>  # default for kernels that were compiled with BPF JIT support.
>>  config ARCH_WANT_DEFAULT_BPF_JIT
>> @@ -101,4 +105,9 @@ config BPF_LSM
>>
>>           If you are unsure how to answer this question, answer N.
>>
>> +config BPF_JIT_KASAN
>> +       bool
>> +       depends on HAVE_EBPF_JIT_KASAN
>> +       default y if BPF_JIT && KASAN_GENERIC
>
> Should this be "depends on KASAN && KASAN_GENERIC"?

Meaning, making it an explicit user-selectable option ?

If so, the current design choice is voluntary and based on the feedback
received on the original RFC, where I have been suggested to
automatically enable the KASAN instrumentation in BPF programs if KASAN
support is enabled in the kernel ([1]). But if a user-selectable toggle
is eventually a better solution, I'm fine with changing it.

[1] https://lore.kernel.org/bpf/CAADnVQLX7RSnOqQuU32Cgq-e0MVqyeNrtCQSBbk0W2=
xGkE-ZNw@mail.gmail.com/

>
>
>> +
>>  endmenu # "BPF subsystem"
>>
>> --
>> 2.53.0
>>




--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


