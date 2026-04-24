Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8A6FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59D46B0005; Fri, 24 Apr 2026 19:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AD16B008A; Fri, 24 Apr 2026 19:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA796B008C; Fri, 24 Apr 2026 19:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABF06B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:29:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D109A017B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:29:12 +0000 (UTC)
X-FDA: 84695042544.20.B522699
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1DBC81A0004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:29:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QFfRuqZp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777073350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahCy8rxOvixjX2FA5ApDynwuvYGvOS/2mqLtTRZIyI4=;
	b=v6/fCezUlMWPk6Dgxy+nI2nrkAZ1GPRTqTfyG26Y89b/u6ZK4KC0RMGz8uJxZsPU/DUDBH
	6CrM0AL3yAxjuK7x5xvcCMomtM4EcuWWqvZWqlO28eIkYm1H96dc/Y12XQOxdAwER7lT64
	T47lzghhWJGN9SQTSxEsuy88mh1T9Lo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777073350; a=rsa-sha256;
	cv=pass;
	b=Y8pGebYRXzI/l34UODJ1PQ93BYFNTs9GZfVm5G6+OI2GrjfZehyhBywZX8nDtWqC500JBd
	hJ+/Hi6Nb+2WYWK5g8gNAlbPR24+xcHYV3/6g2HP3qmDL6e87KbrDzLbsRMDFb8hdLsP7t
	d66QHWHAKOMTHVqq5XzyyqWKX0m3cmM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QFfRuqZp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43fde5b81a1so6240106f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777073348; cv=none;
        d=google.com; s=arc-20240605;
        b=SyBpSP/z/eXDH4Cye/yzePWWU0oGYm4zVro3BpKr7RgSrNqecd1T9gS1zUe+CB6ybB
         t5Qo2avtiwwuUzVXFnfaUZOVxq0DpN0xoQ195CrOXn1cNVziGDuQHG2gVWbb075Ni7yW
         x3E4UO38TNWHMUzhgmogOeUDH267j3zZBKLGhWr3DFtjCelspJZFdiRmeoenEbd7xL8/
         sWpGxWY53hEL26AuZwIzu2vTj0sN4nWQabwUy05Oc4mMtRP3btdp2AOA3jALF/IdlUmR
         1q9YejfsJskCItDbR0aesutUZdGdvOGxlF9b6UrdGFhp+LvMeJ+SF5KpJ4FkpYhWTbU4
         hYaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ahCy8rxOvixjX2FA5ApDynwuvYGvOS/2mqLtTRZIyI4=;
        fh=Jo93dTzJLfJEl+kdwyZaoyMCwQvgLGdyHNU6Lm2KkRo=;
        b=bVhCvMdH7SFYsVJTzmr79EIObbe0xLsNNg5DLsDX3yhN2M+MP/dtaXtilngYm8fobr
         7b6xwv8qFqlX//XEX/HR60dUyuwfMRI06A4JrIrdVFtF3Njxs9JrO8VYz6K3vr7vajEE
         DrqLV6nmnAq4WyXBgpWd9+GBCGW/Fl6lV7G8bQgjKFH5mcPG6xLf7CK7HAw02RqHllHe
         lRBx5J4ok/2i9rekem1aHjMvaV2HkP58s8mAjTUc9a+7EMEm+xVFFuBsDksw+T/79+/t
         50PtsdLPqMls9in6jMk/WAUH5Jt441+JijeVKCl4wd7wtMyDrYyQT+tSiLX52fyyml8h
         l99w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777073348; x=1777678148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahCy8rxOvixjX2FA5ApDynwuvYGvOS/2mqLtTRZIyI4=;
        b=QFfRuqZpa38583SofeOTArPVkw/XylbutFYiS4kW3aGUc1XItxaM5mIt/u4zydMt3M
         FWJZ0q0u86y9akOUwb4zxwJGmBXvuVb0OpmTYFdL1/eOvIG9408y++I+6BsTOsKTHGzS
         hy2Ro2WgM2nTcMi+dw4mked7FXnJ5oEjr7kZc6C3ScrxoaDuZVNgTaSlUgDtqNbyLoLg
         mYhbJLC9sQcvNGW0TzMWtacNy4JwitKYIBlZcT9nbIRiw3mMA5D7jNEl+v4p+7r0Mfyi
         NloYG0grK35amG8sUY3tPhAXpuDzR+KZCJla8mnnAyGOk2SotLZpcUPDem39u2L5LSVl
         3Ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777073348; x=1777678148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahCy8rxOvixjX2FA5ApDynwuvYGvOS/2mqLtTRZIyI4=;
        b=fK2L258g3hSP/xCxw+cl4uA6uUUMuUsdc4ycg9H7oiMoye48x+oMrHVuyn45dx5U3m
         gp30BbXl1Y+cWoaQn2bthsJMTuoHWWV/e7kLGTkqpZunyFvl/NpVT+NRxGCuYTQD8PiU
         P512hUmJE2pFuI/Cro6IOilRt/5UZ70SGoGRGyR6rLEtIVr8lmFbBfKtn7jM6lvCNkLz
         bnOxilxeJ4+bFuSezioiMFnm7gwE8rFGLYY8LHzTQzyfp0oZqzRkoC5ze78TGSTvF1J6
         NmkwEA0y90YinrsPFuJEEZcxQGyUOqaPcomUWoCpZYj78bIaf/rOyhDc1eHZnVPti4WO
         6rKw==
X-Forwarded-Encrypted: i=1; AFNElJ9ABSttpLL1muj8aHq0pC5ZwcQXfDdVzqHAOUcXF4noLK1zdVvEaAASXxCC1+axw4QR66nRbyLlbg==@kvack.org
X-Gm-Message-State: AOJu0YxRZaC/VMz4R3podmV8lt6zfi/0it7jD7W/J7FP+XCye9pLSlTW
	HosI+Hlh38uIYMh45FatTwv50c86yQzah3s/4ehwRjmzfe0lVL3yz/AXhPctdCLP01ACndRGfAw
	ULfZ8YngVFotT2naFYEB3QJj89DXfnHM=
X-Gm-Gg: AeBDievb4//fFYFP7RxBwhBCd82LJWeWN+VNB9vMW8bYLp3imh3ZgNBDhpqH2DdJ2rE
	Jgjqj6kcUAix+v0tBDHxrrqlnDMPF5k05qskyozTqXITeZOtE81qFODE02d/wxsCSZ1Up+XvPtA
	cSf6kWZqhj8BivtTGD0raNt9mzByfGWxJOIydCZUFW2xyIIyd9rgtCFgFe9cv4m85/KC8CXMr8b
	DAwrKtcEaokhzvfNd1632knjEFWMXa1RkwiKs9sTr8Gg930EImuVdVW7NnJuvv+SJRRIgawL1LA
	GrXlIrNGmgpLbZlfquIiTepKb5QB2zKylk3idAAJbpEE8F0MUuje1mwSbFU8P+ObpbckHsQralL
	WnHXt6AVvdPy5ecLYyPF7FdPftF1wFHq+5Z5m
X-Received: by 2002:a05:6000:2c0b:b0:439:beb9:5a96 with SMTP id
 ffacd0b85a97d-43fe3dfbff5mr53034945f8f.31.1777073348360; Fri, 24 Apr 2026
 16:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
In-Reply-To: <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Apr 2026 16:28:56 -0700
X-Gm-Features: AQROBzB_ndIthouIQciueRLu_dMM7bcPcCRP_ecesud5fA9xG1Ica2sIBP2K-bI
Message-ID: <CAADnVQ+ytaX5oq_1TjKC66dnjd1-yh3yjmPrP-kEg5wEvX643g@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/8] bpf: add support for KASAN checks in
 JITed programs
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	ebpf@linuxfoundation.org, Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DBC81A0004
X-Rspamd-Server: rspam04
X-Stat-Signature: j7xrtkp7fury5sd1k9ok3z6143hcf79r
X-HE-Tag: 1777073349-546111
X-HE-Meta: U2FsdGVkX19nCS4odVcXRa25NbK0DFfFUV9EIcgh2GqBY8aHeaTrZePk7ftvhOlTuUIIuLsfogWVV0LJXwHS/5p9S2NlHoNd/yceid55OPoTY5e635zvtKFX9I3qOnMSZ+N+c0t4bQVS8WrgsTKJPW3tIvoLMfplZXiE4AU3P3X32I6a/SDKijrjjAziFh4PK762yi7nve3Uw7z2UU3P3x+I0m9+Inn9pLqv4OT3inlVvXLeMs2P0aYN1x3kzomQu+kHgu9qWbC7sQRUjha8tWWF+IXBaz+bS6UjGCD72upxmFYSZlIA68B/E7NCs5GD7sakyQTSpLfX9O7gtJa7hCtzPRQHw16guIsYLAoKuVCwyt5B7WE5yyBvxPR+PoV+XzcVcBBrXlWinaTsvcpIE47TwI+EFrFBcmsMKL3snCd7xV8DaLQNliEV+1IBvpMjDoACO9LpQzZdoJT6XGcesgldGD8XpBHSL0sMZxrowb76AT4bLWaPsWuqZEoqISHT7N9qbPRNAHSxnu9nRr6mG+zcx6PAkJ0PMrx/pQSarmL7yDvYJU+vrT1AFlLI3a6Buo2/DLcaqTTnUQtjXME5ALzGdgcUNFFl7lMAIqh19Py4HyOHuuMvyHZS8/gtmFmtZoDwAoKiKYddoMJBIy60m4nGH+rJKu0DXjY37oe+4eCJD3TaihzAiGMojGC0Hvl6If362exAMS9etaVbesaDlP6b3/Wxd44bf4TmM4IsDfjCAJ/Nai9G0d4aMF75D8NcRaZy2yMOoUzvDxZirJNOeA5Bjq+34DLI5H/cF3xdlfBBfTYv6VX6JLDy0Z2pi00G+lg7NVYBmTPRPCglmhhBst84zuJrE6KqSolkQeThH0MhG1ach+4ULdz1zNt0JzoNz/qtNxugus5eh6hagMNTBLLOEiAxLzFKh2MYq32DW+ug11Bm+/h+Ne2ogeUnT2CklwI7FHTEl+wXu1r8f8F
 9FGFdv23
 A6lF8wvhkURqIR1GP/ajELRZeBYD5idwu4XD15sRshxZolIrXzVMQGpSCWSKk15SerwrITT4aKqwPpKoaeC1gS4VWviUevTNfgoI7ZstqJcuhhdQTX73vnye/JYlb1YxsTdNuOaExvbpgAJS1ZYSaWzMLoYLgGNztQ2bt7j9E/YSFLQ9t6Lyr1dewNgPTq4WqbIrm+w2SQMm13i/ofLNGHSTilj0/3CRjrpRtvm+FC1YLQhFoJvfgs+RZDj4wnCNpQHGHNAGASIINpsealuD0W/7h9/2hzj1r0A3sojTKFz5JiIlfXkDp6o3/RVxGuPe0a8xKvYOxe5kxNmtLAiuhKWGlgFJKayLg9wCrdhEW4vgtptrITKqmMM68Gex+LJ7egH+OLCkl/thT5VxbXE6XeJZCM9JtCWgJ2U64xLeHImjri9azZkT8iAuuJSzPfLsqR+xXWAaZ4LvJLKzmVQD9qNmOCIPNzOKY+33jnUb6P/FdyHf9M8g0OFvkeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 4:10=E2=80=AFPM Ihor Solodrai <ihor.solodrai@linux.=
dev> wrote:
>
> I wonder if it's feasible to implement KASAN support on the verifier
> side in post-verification fixups. AI slop for illustration:
>
>   ;; Original (1 BPF insn):
>   dst =3D *(u64 *)(src + off)           ; BPF_LDX | BPF_MEM | BPF_DW
>
>   ;; Rewrite (~7 BPF insns):
>   r_tmp1 =3D src                         ; BPF_MOV64_REG
>   r_tmp1 +=3D off                        ; BPF_ALU64 | BPF_ADD | K   (ful=
l address)
>   r_tmp2 =3D r_tmp1                      ; copy
>   r_tmp2 >>=3D 3                         ; KASAN_SHADOW_SCALE_SHIFT
>   r_tmp2 +=3D KASAN_SHADOW_OFFSET        ; shadow address
>   r_tmp3 =3D *(u8 *)(r_tmp2 + 0)         ; BPF_LDX | BPF_B   (load shadow=
 byte)
>   if r_tmp3 !=3D 0 goto +2               ; BPF_JNE | PC+2
>   dst =3D *(u64 *)(src + off)            ; original access (fast path)
>   goto +1                              ; skip slowpath
>   call __asan_report_load8             ; BPF kfunc
>   dst =3D *(u64 *)(src + off)            ; retry the access after report =
(non-fatal)
>
> A sort of inline kasan directly in BPF.
>
> There are plenty of issues with it: instruction limit, exposing asan
> API as kfuncs, etc. On the flip side we get cross-arch support out of
> the box with no or mininal JIT changes.
>
> Honestly I'm not excited about this approach, but curious if anyone
> thought about this, or maybe it was already discussed?

We discussed this.
It won't work because we don't have that many temp registers for once
and second it has to preserve all (both callee and caller saved regs).
This is arch specific.

Second, we do not want other archs. This feature is x86-64 only.
It's being added to find _verifier_ bugs. To do that one arch is enough.

>
> > - not all memory accessing BPF instructions are being instrumented:
> >   - it focuses on STX/LDX instructions
> >   - it discards instructions accessing BPF program stack (already
> >     monitored by page guards)
> >   - it discards possibly faulting instructions, like BPF_PROBE_MEM or
> >     BPF_PROBE_ATOMIC insns
> >
> > The series is marked and sent as RFC:
> > - to allow collecting feedback early and make sure that it goes into th=
e
> >   right direction
> > - because it depends on Xu's work to pass data between the verifier and
> >   JIT compilers. This work is not merged yet, see [2]. I have been
> >   tracking the various revisions he sent on the ML and based my local
> >   branch on his work
> > - because tests brought by this series currently can't run on BPF CI:
> >   they expect kasan multishot to be enabled, otherwise the first test
> >   will make all other kasan-related tests fail.
>
> AFAICT this can be trivially fixed on BPF CI side, we just need to set
> kasan_multi_shot for the VMs running the tests. I will do that, your
> next revision doesn't have to be and RFC.

+1

> > - because some cases like atomic loads/stores are not instrumented yet
> >   (and are still making me scratch my head)
> > - because it will hopefully provide a good basis to discuss the topic a=
t
> >   LSFMMBPF (see [3])
>
> Apparently, KASAN reporting routine takes a lock [1]:
>
>    __asan_load()
>      -> check_region_inline()
>         -> kasan_report()
>            -> start_report()
>              -> raw_spin_lock_irqsave(&report_lock, *flags);
>
> BPF programs can run in NMI context, and so it appears to be possible
> to get an unflagged (because of lockdep_off() in start_report)
> deadlock, if an NMI fires on a CPU already holding report_lock.
> Although I guess you'd need two KASAN bugs to happen
> simultaneously for that to occur?... A rare event, I would hope.
>
> It could be addressed with either in_nmi() check at runtime, or
> forbidding kasan for NMI-runnable BPF program types.

We don't need that. If this bpf KASAN finds a bug, it means that
it found a verifier bug. All things are out of the window.
kasan_report() splat can just as well be the last thing that users will see=
.

