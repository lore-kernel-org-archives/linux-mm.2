Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F24D5E12E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CE06B0005; Tue, 16 Dec 2025 06:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B2E6B0089; Tue, 16 Dec 2025 06:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E4B6B008A; Tue, 16 Dec 2025 06:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2F576B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:26:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7899C1339D8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:26:33 +0000 (UTC)
X-FDA: 84225106266.27.9DB92CC
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 957F540004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:26:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mmljdSgZ;
	spf=pass (imf07.hostedemail.com: domain of 35UFBaQgKCL4negoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=35UFBaQgKCL4negoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765884391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krMeQQo0RYkVVveyUInYgEYC1GtxSzSLPYvL0R6jcGk=;
	b=5fk0A6BbcYaJt3nXUj8g40zUwD2bKG4EhtAY1i5HbsVj3etCmYMPt/PKUV5+5pzP5ucQJA
	v7rafZJKoByT8ppN4fyKl/4kJh/XoW0ANph/KBv/mdPWgXPgGAg0ecb/nCQ9ZBdUNRplkX
	Mn1kAzuX9tVnPwMV6wZK1x2H7OV+Jiw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mmljdSgZ;
	spf=pass (imf07.hostedemail.com: domain of 35UFBaQgKCL4negoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=35UFBaQgKCL4negoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765884391; a=rsa-sha256;
	cv=none;
	b=dSR6vDUAZj5jYTeaJjv7tn1Y3bto4C5Hz8aYeg6EuuAJoUlIPeZL4FFTan8WBLw2OKAEoS
	9ry5HmVcx1KxKarixn+1WWYTdvF55mQgAgG7XWucYek/mDQD9Q25as2NgVP66sgDbLBnEz
	giJpyTzf4MJsgEAQ0Ia5lzIy78KMk3Y=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso1708964f8f.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765884390; x=1766489190; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krMeQQo0RYkVVveyUInYgEYC1GtxSzSLPYvL0R6jcGk=;
        b=mmljdSgZPhNwT6iHHZ+aUGfln0osBLt6TzCPUXnCnrTIB1bBSAKsjHSFcDOY0cQ6iJ
         htlgkEFyE7AGf9H6/tQXjqsfKDF54sxM5VZIyRoh4H1OgeSBFGv6F6B58f0d70MPka6p
         7lBo34vJufYsAmwf2EtXFs/W8jdUiWiejSSwAlNUkJMkR962IRJemxKAC+/pRP1a7aLC
         juKSmfx42EzrZSxf2F5xDP37Bgcat4Cwg8xkqGN8fFi7OjwRi6mA7bzPNK0AXNXGFdWU
         VKSjsWmSZhrhDsToFCX/XHRdnMzHZi93eOk8tJ1Bo1CFP7OLjVG5Q3tEPtwqoVfFChDe
         U/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765884390; x=1766489190;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=krMeQQo0RYkVVveyUInYgEYC1GtxSzSLPYvL0R6jcGk=;
        b=nOypd2omJqYUQcEy6m0tGXABbzMe48xmSXzrfYw5Elbcbx2seq8Irp7DTYuqMeSmZQ
         OyJ2zjnLmKIchdW1VEU1qpp7ue9W6xBg++J/H7Q0lV0BCqTojMIxN9VC7m4ULa+cICsy
         ml3OqgPpcKzXnTTZ+tkRUSPgS3g3mc58DAx93xmM0UyVZVFV9duIaN2ZxiN6aOiQ0dF+
         1FPNcqpttaiF8sOQnsses6SJh87KnPX/9dXjcImY70MsVxZytQZnmLsjCeXGm9mUdUQJ
         sxz5LKctCdRvJImpLSbEsTAZRj/ET1C9roXETrA399Hj+zEvFqDk9Tz5I/TtOAadtBoM
         3Hcg==
X-Forwarded-Encrypted: i=1; AJvYcCWExbsLmf+49WO+oKduvudJpmPrerRyo/67B60IZZIJzwgbGmeTMKm9keNcvu3q3KQXzsvj/WYgaA==@kvack.org
X-Gm-Message-State: AOJu0Yx+nhpk9PKn87BZ7S/uxwWZbHMm0JdStQRMEeAShZpQ6e/UTa5D
	HjNPQA3vUa5rNAZG1qmEbSukjed00x4kV1r2fpQw4PUfyspBenagZrBS4GhdVg6Svkjh3NuEBXh
	ptmnV3umhNBJWdw==
X-Google-Smtp-Source: AGHT+IHRBFMdNHijFHNhfpSjk2TQJ9kZwXaGz3RsF4bB/Qt7P2NzdaKmXMouO4czF1ta3V3ssZTXVLAPCUMyQQ==
X-Received: from wrrr18.prod.google.com ([2002:adf:a152:0:b0:427:87c:f46])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:310e:b0:430:fcda:4529 with SMTP id ffacd0b85a97d-430fcda47a1mr7553444f8f.61.1765884389671;
 Tue, 16 Dec 2025 03:26:29 -0800 (PST)
Date: Tue, 16 Dec 2025 11:26:29 +0000
In-Reply-To: <aUE8bwUVa6jSUft1@e129823.arm.com>
Mime-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
 <aT5/y3cSGIzi2K+m@e129823.arm.com> <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
 <aT/WOAr4osoJWaMS@e129823.arm.com> <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
 <aT/drjN1BkvyAGoi@e129823.arm.com> <DEZK5U2YP6I0.27VJHSVK14646@google.com> <aUE8bwUVa6jSUft1@e129823.arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEZLRT59S25H.2YWTZ2G0TN3HV@google.com>
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
From: Brendan Jackman <jackmanb@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, Brendan Jackman <jackmanb@google.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <martin.lau@linux.dev>, 
	<eddyz87@gmail.com>, <song@kernel.org>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jolsa@kernel.org>, <hannes@cmpxchg.org>, 
	<ziy@nvidia.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, 
	<rostedt@goodmis.org>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<ryan.roberts@arm.com>, <kevin.brodsky@arm.com>, <dev.jain@arm.com>, 
	<yang@os.amperecomputing.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, 
	<linux-rt-devel@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: j6y4u6axaj5kud8cp6t53w7s7f6xbn7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 957F540004
X-HE-Tag: 1765884391-684814
X-HE-Meta: U2FsdGVkX1834jNEGQP4RqSsadkMGNZYHfpE5X7bLJWim0qHx6jJZHfGV9e/bfhfwWm0LkuocS3CihgNn/Jkcp8ePbEmhcD0R8YjF8L6mxdLn/PPpm/fdUA/njXBP+GXLE62zp8R6CBcuELfvBcpr3ivcz/aE2r0wr58JSay2HMkl61S8igsZ3mqs2XwihPx0Skhrb9+59TP8WXGLrXI4BGbUr+lA+qzc7TgRtfm2d6qF4qeDh/lt1FBtGhfw4Qwf9Ovoz82bFBCrdlImRSGH1GfVVSq66QPIqwA1wGSGNmSf3DDdm2MHdkBJYFOLAMLv8+oHCfBoJRA+ESeObtEuATDTbAiQbstjnDMRYOWccfIvQ0HyvgKoYpAxzNQDvGW+u+yi/LBweulxsPiTZqEH3bQTkmTr6pNpEWuUkEv0yezXMnqgtR5subTzVUp1q4bKcjl58iULS2+ePxZ1BjAGhkF6cw05PizatScrUNnsmpXqBJowCBsvx7fg8ceQmuzG6YAt/UPvwE5eGJc09mRAoJVn7PbfBNOpC6ECxnd2DQvgq2Z9rParJw7WelcVYlX8PUUbK5ZlVDeV3CtOiZ2K6lOXxbgi4cjtSZOj9A37hQpmBa781+Evi/nsmTQyWrXQhaYwjdyes0z/fvwJh0HbYOP22TWzLKvqBsYSsrveltzbz4+5PQ8FW+opUlNZt+2HL1l7KyMB+vsYNItJq0oci6hmkozodRe3KMsVwD1ijbdO4Mr1yJOm41DsxElfUBDfZNVBN6SboZcf/m6bbQI74GNOERKTrmXpxZE2Tu+b+iylt8wj6B8trun/WTTHVmDkBNlUVbwsmqL5hZcLnhz85IvGkm5kW8RoPVrPM1uSyMuBrJSJr9NfDPSbXZ7l6UQ8qDR4E16170hC6Bx6zbqaTHdianeweKqMwto8unrbV/AlqJpaZ51KFPdpMsY2Uk+0W04u+sWYCvoDFt7Lpp
 cjxWAyzH
 mOQ/w1v+dXs7WkWArUuJL1fEcTmdF/vKRqCPzRQAnHO690XEZlayd7ohykfbNk2GRFqtp+FX1hMlZA64FtB9sU77uG7vlL9WBxfRBiX/5HNlr7qsxOGrVTaA78CDkRmS1hTq7gPiJWqu1znElXTOoKih+EnM5+qLNhC2MwlCsAs05qkdvNopk3EOga1CvgqIg7+C8C2USn/hldvSpnPgkKotJ3KiZNPc3iciZpg2GnCp3grR3k7KvEBrKk1/Up1AcrF4MaaAPRQen3VnrCE5tG9gTNPx3FnSenKsWyOeX2/8YO8AA6TcJhCBiwyrja1BXtBlk8kHYvi+DMsCzvh3xOs6rzoiEvCvzyMrdp2YLP7Th0R/geArDrglG0gF6i637O042oErc8YrphdNkkARh7tQ22my2i3NV9ZNW4+sZaQaH81JHVEDLd+xqk57kHEmCUvwZzdtgxGb3Ak52GDZYupIF8+9mL+9i26gWHx2NtFtZvpkSvmXS9q+Mqnpbm56vrFvrDxJ/juUYh0mI7BIzwsoYaJ6eWiUiWcLT29kxe3orNA1Xen7hFTh+ZGuWM0lySS78xpFxgxCm2YmbbM25uH9lKdH77NnI8fYgH2Yo8ntx0T5q6vuWFk9MZZZ35kSYCmw3YLWvBU24ohigcNyYqFlpn/hjhaCLRr2mCid4MArv0ncQd5D3XSlBeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Dec 16, 2025 at 11:03 AM UTC, Yeoreum Yun wrote:
> Hi Brendan,
>
>> On Mon Dec 15, 2025 at 10:06 AM UTC, Yeoreum Yun wrote:
>> [snip]
>> >> Overall I am feeling a bit uncomfortable about this use of _nolock, b=
ut
>> >> I am also feeling pretty ignorant about PREEMPT_RT and also about thi=
s
>> >> arm64 code, so I am hesitant to suggest alternatives, I hope someone
>> >> else can offer some input here...
>> >
>> > I understand. However, as I mentioned earlier,
>> > my main intention was to hear opinions specifically about memory conte=
ntion.
>> >
>> > That said, if there is no memory contention,
>> > I don=E2=80=99t think using the _nolock API is necessarily a bad appro=
ach.
>>
>>
>> > In fact, I believe a bigger issue is that, under PREEMPT_RT,
>> > code that uses the regular memory allocation APIs may give users the f=
alse impression
>> > that those APIs are =E2=80=9Csafe to use,=E2=80=9D even though they ar=
e not.
>>
>> Yeah, I share this concern. I would bet I have written code that's
>> broken under PREEMPT_RT (luckily only in Google's kernel fork). The
>> comment for GFP_ATOMIC says:
>>
>>  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A=
 lower
>>  * watermark is applied to allow access to "atomic reserves".
>>  * The current implementation doesn't support NMI and few other strict
>>  * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GF=
P_NOWAIT.
>>
>> It kinda sounds like it's supposed to be OK to use GFP_ATOMIC in a
>> normal preempt_disable() context. So do you know exactly why it's
>> invalid to use it in this stop_machine() context here? Maybe we need to
>> update this comment.
>
> In non-PREEMPT_RT configurations, this is fine to use.
> However, in PREEMPT_RT, it should not be used because
> spin_lock becomes a sleepable lock backed by an rt-mutex.
>
> From Documentation/locking/locktypes.rst:
>
>   The fact that PREEMPT_RT changes the lock category of spinlock_t and
>   rwlock_t from spinning to sleeping.
>
> As you know, all locks related to memory allocation
> (e.g., zone_lock, PCP locks, etc.) use spin_lock,
> which becomes sleepable under PREEMPT_RT.
>
> The callback of stop_machine() is executed in a preemption-disabled conte=
xt
> (see cpu_stopper_thread()). In this context, if it fails to acquire a spi=
nlock
> during memory allocation,
> the task would be able to go to sleep while preemption is disabled,
> which is an obviously problematic situation.

But this is what I mean, doesn't this sound like the GFP_ATOMIC comment
I quoted is wrong (or at least, it implies things which are wrong)? The
comment refers specifically to raw_spin_lock() and "strict
non-preemptive contexts". Which sounds like it is being written with
PREEMPT_RT in mind. But that doesn't really match what you've said.

