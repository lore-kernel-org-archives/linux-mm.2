Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0C1D5E144
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFDF6B0005; Tue, 16 Dec 2025 07:39:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E066B0089; Tue, 16 Dec 2025 07:39:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF146B008A; Tue, 16 Dec 2025 07:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB9166B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:39:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8152459A6E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:39:27 +0000 (UTC)
X-FDA: 84225289974.15.61E56AE
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92EABA000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:39:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e0JeGos7;
	spf=pass (imf25.hostedemail.com: domain of 3-1JBaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3-1JBaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765888765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zl5vYkOfCeh8vzJ1i3gRdGX7RBaO+Y5siaEC/TfzJu8=;
	b=HDXl7ZUZJ5Dnwf0rXwKYVopVfey7Ndrv+zwIwdpYexRDKZPqZ1xGevEchq/HVyZv/Gwp7m
	PZ/0/osa+YH+6LlA97DSCbamdVVZjE8bcihd3z9F+3yaEk4QG26MUQIg/dzNG3jphTEaoh
	IXSW0pGqDKH9t0YK56KadHTfSbmI7Oc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e0JeGos7;
	spf=pass (imf25.hostedemail.com: domain of 3-1JBaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3-1JBaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765888765; a=rsa-sha256;
	cv=none;
	b=DSm8llYCW6jN5NNDS8Ep90rv156icwDic2H9qCdlk5ut0Q9YJuhYklFA0zvy/btRHvUmX1
	1NOmnpdRKLWPmgL7f/0wmoVbN3UYe9RQJXidbChZu//F9Wrib/wS+qE5U5xfJwWpaJ4V2O
	LqklYVz2hWRoHOmRVEmpZD3n73z0v54=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-640cdaf43aeso4088736a12.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765888764; x=1766493564; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zl5vYkOfCeh8vzJ1i3gRdGX7RBaO+Y5siaEC/TfzJu8=;
        b=e0JeGos7iIc7+wWB0W6nwLUczh8MJScgXD/mk3df+wkfFgX8PvFtwI0R7ISZKGTGRX
         tlvMgvmP4ButWKbMCOsnESMhxUiW8ZNlNamTIMt7pckn260aXV6hPMGgp3PI9LTny+DM
         Av8r5hAg7Q4A2a3rBMf1SBL37I9xpQG662MFNR5vECObJz1YG/L6iv4iiykd4NVNjv8i
         jMUluL4jWrDR1F73qNsMUUBQJibm90wkPdVGwNHw5Ghi8RD8utYWaNB2X9umBSSjchG3
         miCxKY2eDmBJpRbOqQ8ptpJmUxWKKxqJG5BgM2YYQ0bY6+Zs5IByjU4xoSOCEazc9WZ5
         Balw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765888764; x=1766493564;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zl5vYkOfCeh8vzJ1i3gRdGX7RBaO+Y5siaEC/TfzJu8=;
        b=qQktcoDNCsJ0lhOmadcajShjNGje5xjcQN+FpnjLELx5sWeooXTFASMqeILuuXE2aL
         JYusGDNIOQjwaAq9LfpdNkiEC2W1pz3WMcVQyR4oFShUdSKRuT0tcIEgSX7VI4cz6mKG
         ++OtmjUaQPYvO7JwMY0t0BsCwSe0VvAKZX8aVVmFvo6bOLyFp2cQ6AaVgyEu8UIf1MKS
         vRZSet1gc5ENqAJ+LohmTF8NGgZ0yN517mxNPVaIQyZlCLhCI1B4Gu2x8fSD8JcCiNF9
         EMLGtzxRAak5k4tDfflVyTmhlSmqwNUe47Fwd4yFOvJH8RYbfXf06eVosUYiqy0/YXmU
         BtlA==
X-Forwarded-Encrypted: i=1; AJvYcCXOrTF9xM6ObFpR+H9qgd7EuW6dJh2kLF3lbS8faG+g+SnbkWxD0/g1AmIh0bP3XsM6NJMIME8J1Q==@kvack.org
X-Gm-Message-State: AOJu0YxFyjvsaURFvtn/VEMR+yq1m10jyUohVpgzho/tlL9FFtqSbQon
	eLrcikIhJEqfbORjgmVVwQJs9qo2e6W32ctU5CuS5dMq7q+MlKajfds0qdPQKVfEfKwrfWzkWUC
	2W7ISQW5EtUAivA==
X-Google-Smtp-Source: AGHT+IHodb6E0igt70QWnGwF16M0BauoX0vq/LCQAwB66mdazNxScaNnSE8J8M2KteYx3re6oS8FbB6Lsn9MBw==
X-Received: from edsk11.prod.google.com ([2002:aa7:d8cb:0:b0:643:12a9:41be])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:50c8:b0:64b:3a87:44ff with SMTP id 4fb4d7f45d1cf-64b3a874559mr607042a12.34.1765888763584;
 Tue, 16 Dec 2025 04:39:23 -0800 (PST)
Date: Tue, 16 Dec 2025 12:39:22 +0000
In-Reply-To: <aUFKAdPY3zTlPmnr@e129823.arm.com>
Mime-Version: 1.0
References: <20251212161832.2067134-3-yeoreum.yun@arm.com> <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
 <aT5/y3cSGIzi2K+m@e129823.arm.com> <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
 <aT/WOAr4osoJWaMS@e129823.arm.com> <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
 <aT/drjN1BkvyAGoi@e129823.arm.com> <DEZK5U2YP6I0.27VJHSVK14646@google.com>
 <aUE8bwUVa6jSUft1@e129823.arm.com> <DEZLRT59S25H.2YWTZ2G0TN3HV@google.com> <aUFKAdPY3zTlPmnr@e129823.arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEZNBMBRM5M2.1974FFAQ13G5E@google.com>
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
X-Stat-Signature: aqiuxk335b7syesjxcgs9sxtciag55ux
X-Rspam-User: 
X-Rspamd-Queue-Id: 92EABA000F
X-HE-Tag: 1765888765-584671
X-HE-Meta: U2FsdGVkX1/wYajuB97YKe4T2ca7z9Brpm8Un94hi58ooq7CndlE6HqihfM65yiJedtIITXmHLivXrk6CA8NVblPQISUaojVncXXTDuk9NLtOwt2UqeRQbkGWC1p7r+4427VrlCMxUSA2P5PXeh1iFCZ5OgHp9GfxUkO3SBhanfbCgAwONZhtRs03ZEDXfh59/MQr3X9EUoovLUh7BnurCEbVbdsi2capqsfN3PBqTrxijHfaHgbtlHnSp8QHAZvwMacKA/MIGxrhSta6ea/X6gQn1rFKp5gsilYnL0kqKRsgxFlMH+boq0MKGGmrxn2i1uMvBv6JBGtTaOJmrQ2JyrPB1DealkUPMhN659dlZjOdMyUOCSjgZEtgMH3byZmmo5HSNSDYSbNbhiwcJFAVKBlUxi/Bs3NACftal0fDOulKjh+dNKW1gMayMz+BKKVjGgLX7QglGcQ8TxVjhAx7TdnpRxPZ/Dqyk8awSW/a+YgPgiLOvu//YLO1zRYr0Bg8yqeSTD3U+RSYUaYuRqiBaG1s/ryjaPP7zhDyAV52HAnqGzUtPyZEkzvucU9QI4iaSVxOctzWEUc8Qw3PnT2KUWB+tkUHCKJ57ozkxwbRNuDaRPBNwI0tDsIQY4go7j5l/5E5enozWJThhsIktDE+2U6ypAQ4xHdH+gn5wgWROOwWRwi7M42NuVsRdF1vNh+nILF6BWLHaaOXBVzPsoHOkW3GYLBZKD+qa3nOMF9oZx256TMm9/ftkhY0Rv2/9lxzpvjoYPNVliYqjw13muIGNU1UGKmytpRx5hYjZuEy14DY9cw1RWL1WlBr42IUYseB2p2ea6fPLg3edneIFmwBja/zg5/njIrNHNUmCN7qfGrjseKbGiRQrwEXGuppZiRcUBOeGdAZuRBWbOzeWbLfn1YzOHoJg323aC/PEiEqAKoqVOks/M/W8zy9MhyIoZIIqLCHMtrtWNE8sCkxls
 KPaCExsx
 3EsgHRiKb/gBzq7Xh7yCQbBrzCimB+jopWjdm+jJ4x27sCqfnEQin5oPIHS8qIKopUUXErAlZouQEIVDMjzkgHsCqMYhAs6tWImS5p965DK5SPWfzgYwqeDedaT3NPn+9ZamXO8Pm0JutyjfcoFfNZDFC5yGWZTqplLgBlAPAMPnwRBdMN0j3N/HI/yin/Ss3MBhXrcgsFkQiXbM5GiBpCOyw7eVk3C6BgRqRYHlIwISpXj4Q/Y3PyRvSkOORMvRy85fhThnWOP8xLCXE5MSoifjaurMLm6VF9rPuiakgWUYmZjXCjwTeEvQnAvLlRL2/EAyyOaR2sBRyv+rJJZKNPonSF1mojlV+ijmyLIqyuXO5UdkuyMZ+ssP8jZFcRlUqsSwntZL1TAHLGU1K2+qa2bRzyLl+LQ2p3aQbg6YbBxAIw6R2yrIdTsauGjLB3uROfkThzaBK24isVP+yyhh/r4V5VkwOB1Z32zBbPthaFEoLhfIkd/YszzVhFZabNJPQU22dQyHPr70jc72aNdOe0fdWKdGvZn1DjRcSXyy1x5wjwbtB/JmQigJQHmmoFFyzUE83xCMFi6KFXwuIkjFFDcYQeRXeYDjVIuzwrB+skQmjthVtk+D5DsgNp0YU0q3rQ24SjQ3jBxlL0Zl7uWOXVJhYHXMOyafwJi0WCUIndqJ7Op//hGG+ErHwxtxGmyQwisoBmGUFUKCNxqhJ47JT3zL+1txUxQ12lb+e6q/3Eo/6JJxvmH1YgM2Wph/pmEdsOS1F+voGEdQ6+etDb+2++PatWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Dec 16, 2025 at 12:01 PM UTC, Yeoreum Yun wrote:
>> On Tue Dec 16, 2025 at 11:03 AM UTC, Yeoreum Yun wrote:
>> > Hi Brendan,
>> >
>> >> On Mon Dec 15, 2025 at 10:06 AM UTC, Yeoreum Yun wrote:
>> >> [snip]
>> >> >> Overall I am feeling a bit uncomfortable about this use of _nolock=
, but
>> >> >> I am also feeling pretty ignorant about PREEMPT_RT and also about =
this
>> >> >> arm64 code, so I am hesitant to suggest alternatives, I hope someo=
ne
>> >> >> else can offer some input here...
>> >> >
>> >> > I understand. However, as I mentioned earlier,
>> >> > my main intention was to hear opinions specifically about memory co=
ntention.
>> >> >
>> >> > That said, if there is no memory contention,
>> >> > I don=E2=80=99t think using the _nolock API is necessarily a bad ap=
proach.
>> >>
>> >>
>> >> > In fact, I believe a bigger issue is that, under PREEMPT_RT,
>> >> > code that uses the regular memory allocation APIs may give users th=
e false impression
>> >> > that those APIs are =E2=80=9Csafe to use,=E2=80=9D even though they=
 are not.
>> >>
>> >> Yeah, I share this concern. I would bet I have written code that's
>> >> broken under PREEMPT_RT (luckily only in Google's kernel fork). The
>> >> comment for GFP_ATOMIC says:
>> >>
>> >>  * %GFP_ATOMIC users can not sleep and need the allocation to succeed=
. A lower
>> >>  * watermark is applied to allow access to "atomic reserves".
>> >>  * The current implementation doesn't support NMI and few other stric=
t
>> >>  * non-preemptive contexts (e.g. raw_spin_lock). The same applies to =
%GFP_NOWAIT.
>> >>
>> >> It kinda sounds like it's supposed to be OK to use GFP_ATOMIC in a
>> >> normal preempt_disable() context. So do you know exactly why it's
>> >> invalid to use it in this stop_machine() context here? Maybe we need =
to
>> >> update this comment.
>> >
>> > In non-PREEMPT_RT configurations, this is fine to use.
>> > However, in PREEMPT_RT, it should not be used because
>> > spin_lock becomes a sleepable lock backed by an rt-mutex.
>> >
>> > From Documentation/locking/locktypes.rst:
>> >
>> >   The fact that PREEMPT_RT changes the lock category of spinlock_t and
>> >   rwlock_t from spinning to sleeping.
>> >
>> > As you know, all locks related to memory allocation
>> > (e.g., zone_lock, PCP locks, etc.) use spin_lock,
>> > which becomes sleepable under PREEMPT_RT.
>> >
>> > The callback of stop_machine() is executed in a preemption-disabled co=
ntext
>> > (see cpu_stopper_thread()). In this context, if it fails to acquire a =
spinlock
>> > during memory allocation,
>> > the task would be able to go to sleep while preemption is disabled,
>> > which is an obviously problematic situation.
>>
>> But this is what I mean, doesn't this sound like the GFP_ATOMIC comment
>> I quoted is wrong (or at least, it implies things which are wrong)? The
>> comment refers specifically to raw_spin_lock() and "strict
>> non-preemptive contexts". Which sounds like it is being written with
>> PREEMPT_RT in mind. But that doesn't really match what you've said.
>
> No. I think the comment of GFP_ATOMIC is right.
> It definitely said:
>   The current implementation *doesn't support* NMI and few other strict
>   *non-preemptive contexts (e.g. raw_spin_lock)*.

But this phrasing sounds like there are other non-preemptive contexts
that it _does_ support. I would definitely read this as implying that
plain old preempt_disable() is OK. I don't understand what those "few
other strict contexts" are, nor why the stop_machine() context is
included in them.


