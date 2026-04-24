Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B255FF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F9C6B0005; Fri, 24 Apr 2026 19:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850056B008A; Fri, 24 Apr 2026 19:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EF66B008C; Fri, 24 Apr 2026 19:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61CD16B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:31:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB7284015A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:31:51 +0000 (UTC)
X-FDA: 84695049222.02.A1B4CEA
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id D237CA000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:31:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FWyOdMQC;
	spf=pass (imf15.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777073510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyUuyE7w6pvvtI2U755rVQDGqOG1TjZmAAoWkbcJ3pw=;
	b=VAwvZFSqkFsI/48CwdbyDkMAwDyJKbpLLy1065vml47jAZCB+CibcoJAkbU8j+Az6ZCD68
	G+hCSjg9KJM6khnsd7C0Wpr9afjhseZN9cdZkPoqup9tBANiFvPWYzPt9p66zYdbmKWVsg
	PPtq0C3gUDWZ/VLG7/DV9GkbEh6DER8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777073510; a=rsa-sha256;
	cv=none;
	b=ZeW+e9JXyHQ8N0dwZ6yD4DNux69+/G8aR1s2U4zSrFh3oHKwr7LJRF7KRDuYDfj2VEKCbd
	VMUSrSkV5CdmVPDCHL/M5DNcge2E9dAzwOpMOSI5YQmbqNJ0R+OOJdheEyvYjQycz3wq+/
	+V64XQBvSBMX3bQWgmTRgyj74cqSZxA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FWyOdMQC;
	spf=pass (imf15.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d8fccecd-5418-46ff-8e9f-065d1dee6d98@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777073506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyUuyE7w6pvvtI2U755rVQDGqOG1TjZmAAoWkbcJ3pw=;
	b=FWyOdMQChNJACKlHSUigRbF+UkaZINGXAnfgG0l27LLGRf/hYjHu/Lxkyy0R7Svov/3cgV
	ca7lKrp+oJsiAffpgj9aIdrEaU8SwwAp8RbrsigFrfnx1EjvABSU63IFjcjHzxaGMsifyR
	FfCrsxV2p8KUbJc33PxkbcHVFDmYG7c=
Date: Fri, 24 Apr 2026 16:31:29 -0700
MIME-Version: 1.0
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrey Konovalov <andreyknvl@gmail.com>
Cc: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org,
 Bastien Curutchet <bastien.curutchet@bootlin.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Xu Kuohai <xukuohai@huawei.com>, bpf <bpf@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
 <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
 <CAADnVQKv5y+gq=TnOAEXSqgBRpmHNjwqCfxpLaw5XkcbQ+23bg@mail.gmail.com>
 <CA+fCnZe-b0Qqbo5gGv3HN20twquQETDfYYkE1r9tPr9zUFbW9Q@mail.gmail.com>
 <CAADnVQKuptG_opA12O=Xb9_+cHf3f=ycAZdfUp17P2HBYQzdsg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <CAADnVQKuptG_opA12O=Xb9_+cHf3f=ycAZdfUp17P2HBYQzdsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D237CA000C
X-Stat-Signature: wmzuw3d49jyhd4nqtfxgd1n7go3fq7uf
X-Rspam-User: 
X-HE-Tag: 1777073509-583222
X-HE-Meta: U2FsdGVkX1/jfd4sIYYvimQ63zWj5Ac+lq0JHAEWuzQ3EYpnxXwpiSJ8L+z+INp458GmVYKcOl0z5Oio2jMqH2+I/V7pac+vosvbVedBFUOFrHoQnNB6uIwiPL6f6S6To3jqLEBUxUkGGS2ftC5eW8cIUGFuL9QLQIoJ77r+6qcCn0KPFmqP/Zt5f0Sa2mGRaadCM+XRxzG5gVVo6AlfC2gd6s5f7hQpQJZPkdkAhv1WlXolyGjrnkyeASZAiINxf+gc5Tty/dBXKnutyk2CNTD1WinvToQ453NS5+p/Xw3AKS4JgX4/qwGA8vuZukXdEf7DrfZzcb4ByisVEuX+TZfTaMG1h/ajheO6FGXSyiERWDI/Nkuly0Hjv+wdVkCIA5DvVk7KO0pjAEV3DuYvOxmx13Oy6NicoV0/BoeejkyJkGrEFSuNyd79SBDEHk6FvVNZnT3LFJwcRduUkZU6H4QZQWK0qaxlzW9ejjVt7kpST7ZacuIPBHFgkOUmMRSoiVFiiVVKpF61evIQR5wdAGekg2mZ55qCZHI8W444e0tNXWAYrYXAaXJL4Hi050t23dbxtGI1vpz+uFg9c2r/7gTsptNU8W7AXcot3p73KzbI9S/UBugKH8W4Z9aAQH1AHwhC/eiqTo5YZGrR/DO2Jj3iboE2PH81Y71opoHIF79qrVGS9n1zKDUxfW4aRGUSV6RI2+aHyfO9EMejW3PZ+Znwr7Qm0fW67gMwdQVba326/GwnzXLDJtcuTIyY4Sf6iUlogu1Vc9GNa2pT/XNhDdGrqvByw5ImD2nf43R+GG3uAc0027bF9m1TQrx6ImXmNxO4iUmPC753KMmNbvTlcr6QyeAQvpacyrVQKgIIfdeBLbt7vmn9KCwZRVYmrsHmBH2gi17tnMIOiMRd0hniLuDOIDzLJuLD4qh+5TTnKXDVw469J5OuY1D/Cw9Aztz4u+/NBPYSsYHHXEZ6cjo
 UZYQfhzE
 Nr+oKXW+bOsw8/BR//V7mxyQelE2/bkUdGnZIokNa2vpjFwwiaUGXHqnDo200/Yta990S/mEAueG0M5jmCdEm6r7Gp1RQPMKypRH+Hsu3adjTy0zB0+HXqL05WH+zNNipPdGXSvavRmC7jzNprjGtgz587LIbsDd1vIi3y9rh1u4O7FviYo/rr4rQPPlR2s6JLUXjO1UtLQe4NkaFP/TFtYajo610u3hjn1syJ9HVhgXiESep50K/7pIt4u1mTFPP3uZ9gtC1m0H70eTMHIPEQG+Az032kbd/p7gf/5QZvGVR06uh9AGeX210H4AHk1nPIk94kQIXcmTFUfmLkQPg6jXWcGZzuD8ytUxirnlG5pRYk/DfBzAFe9NCqI762gD4K7V/aj3+7HzuaQDnWfpRNyQZNpxiFeOAAMVIAnmMxLTQ8IfHBsTerKVdTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 3:51 PM, Alexei Starovoitov wrote:
> On Sun, Apr 19, 2026 at 2:49 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>>
>> On Tue, Apr 14, 2026 at 5:58 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>>
>>> I think we're talking past each other.
>>> We're not interested in KASAN_SW_TAGS or KASAN_HW_TAGS.
>>> We're not going to modify arm64 JIT at all.
>>>
>>> This is purely KASAN_GENRIC and only on x86-64.
>>> JIT will emit exactly what compilers emit for generic
>>> which is __asan_load/store. This is as stable ABI as it can get
>>> and we don't want to deviate from it.
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
> 
>>> The goal here is to find bugs in the verifier.
>>> If something got past it, that shouldn't have,
>>> kasan generic on x86-64 is enough.
>>
>> FWIW, I suspect HW_TAGS KASAN already just works with JITed BPF code.
> 
> Ohh. Good point. Looks like modern arm64 cpus in public clouds
> don't have that enabled, so one would need pixel phone to
> catch verifier bugs via hw_tags.

This comment got me curious, and acckktually if we *really* want to,
we can get some KASAN_HW_TAGS testing for BPF already.

The first option is emulation, since QEMU supports MTE [1], e.g.:

    qemu-system-aarch64 -machine virt,mte=on ...

This is of course slow, because it runs in software, so it's
infeasible to run this for every signle patch on BPF CI. But we could
run it on schedule on the base branches or smth like that.

[1] https://qemu-project.gitlab.io/qemu/system/arm/virt.html

The second option is set up an AmpereOne machine on Oracle Cloud
(assuming they are available, haven't checked), because apparently [2]
those CPUs run with MTE.

It's a bunch of infra work and spending, but it is doable if it was
a priority.

[2] https://arxiv.org/abs/2511.17773


> So we still need this x86-specific jit kasan.
> I guess eventually it can be removed when hw_tags support is widespread.


