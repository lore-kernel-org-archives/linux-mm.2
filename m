Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2AAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42576B00B7; Mon, 29 Jun 2026 19:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19D96B00B8; Mon, 29 Jun 2026 19:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BAB6B00B9; Mon, 29 Jun 2026 19:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 839566B00B7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:28:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E65D91402DA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:28:33 +0000 (UTC)
X-FDA: 84934541706.02.4583A56
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0AEAC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:28:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=mUa5wC5i;
	spf=pass (imf10.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.182 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782775711;
	b=N+MYmfzfA+PAj4OEGEviJjVJ2JG3EciI1a++mZY/P+/z1LRdCAgL2KUq/Er/Zyl2kpnMn4
	rQ/lLCxXfdMlszWqvFtMqQ6EVa7CyeX2QXLjPoOn47ISLMgl9y4nGwsSgYgZzSyMsIh1Y1
	/q+YrXqtFgEx3I9MmKXXLJi42OyVy/4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782775711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxNwVLEcxtw3ITw0JLgqNmraBcVesmt4fflNScBtpzo=;
	b=dFG0hx8+ze2PLpppKY2ZzW/gFcZs2yiZCOhmMVDFViiTV3Y1K+jtMZv64HoLSROjcAyC3d
	3PbuawVdrwLxwh+fII1kp0DlDbRXGmx9rpy1NHByt99we8FPnRsjbgH0D2KWciuV3x5/b8
	57w9mv2/zpE6yxmp9yhJwT2x+GsHfhE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=mUa5wC5i;
	spf=pass (imf10.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.182 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c82da9504cso11008795ad.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782775711; cv=none;
        d=google.com; s=arc-20260327;
        b=hziywJI0h7+6+p/SKHjG2JacJn06JUETFQWfZn6djwXXy69bXFv5lmkb7qYcc0yjTR
         ieYJ5CsdeUsN/VhGgGfZ2dNyTf/7av2SeSR2t0qkEaKIFe+kUBquHQeqp9phcpz+Ut83
         4FzNoHfb+x5sn+JT/AGrzbp4m50ZQtDSLD6Y/TYvRjux0kYXOQkFj1zN/OSqq5hhjNWI
         U56B+3wTK0rl+WyPboN7GWoUg8FHgm8si9z6ejdoGBSTg/tYnDBzVS5Z300LDWsG+fvT
         xd3M6+uwqrqhzXrLqIOWYJ8MqAuY7FdBzvKfXmnjYWWnpiWy5LPvBLYHyaDzOm0tYVHS
         gtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LxNwVLEcxtw3ITw0JLgqNmraBcVesmt4fflNScBtpzo=;
        fh=qM65e/9p+F9f8fUDqABliccfHeU4gBouEofUpmMhWKQ=;
        b=bhAJnyN/0/4ZkOQs9o072D9ASE6AYTmJSgWCULpwVIWrAMZnOJ+9Yx4V1isA6WVzrM
         6lrPI8u/Sf6SevPPNuhFtASjFfwFYm4eN5DWOh8bV14Ddd/e83j8S4wuoIgpT+ayGABB
         wzZIM1bagBY+vcm4M/6KCKJUrL/avdwZoi1O68PnNzHJFArGa10VeJw0y1rge0mCRZp/
         TOgJNwsUIdM+8FKNi89SoUZmWZzU47VHknP+BsYIdkKaU9ep/gRhaEWWeC+iizwfUSg8
         FkRLYP2ipKHtS7AG+B6ztl8aGlYm4oeCNaHr67DCiVN/bu69qZD7gIMNlXBV4XwzohQN
         EdfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782775711; x=1783380511; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxNwVLEcxtw3ITw0JLgqNmraBcVesmt4fflNScBtpzo=;
        b=mUa5wC5iN/6cm1TM0agJ3pARnCeqP2PNkSxXeLHk+0vCrdzMokEP4ByJ1SRv6YbSi4
         MPaneLxw0cvEzuoNcWrpA6+eQC/YgRT+XwL+LT6/eJ1LbLnYk/WZT2Mg2zVcnGhDjCHX
         XgG+RlZXn+zSv2wLlkXjsfmb1vGmFs5z9B17PgITvJodDpp2AZjuIudSiU+D/FrhcSnZ
         W8L1dEsrmqKkFbvjHOi/K6r7i4TNuv2ds0b/vGnVj0UtS78nkxM96Ucs6IIG2TbZ7JWB
         WaHwk8ejM0jHYLcy4Dj3hb1x6YF+mDk72aHVhNYPDbGmKZNfFyWbJpOYWU5CDBJWfq1g
         lL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775711; x=1783380511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LxNwVLEcxtw3ITw0JLgqNmraBcVesmt4fflNScBtpzo=;
        b=apZwVi+tmJkt5/0Cmz+DBLo6D1gpFBIjst9UunPKTZEusZc20BIRH9MlfueW2sP20S
         tkL3ZsBfriek2a+DYJf4OV7ws6k5EwAVkZhBEtyV8UNoebpHSSIneio+/IQ7Sj/3Ruz0
         t7WiWXZGLjEwCuTYVmTMxbt5j0Ju9Fai9mq9LOIzUvq8lgW7GM5m8hQDnkUz2DUNNewR
         YADS/9JW8VSJghg4y1KBCrsJThqiB8lcPjZdgXt02hRWuyCoP1rG145vPH4R/ZRzb2IN
         b5vDHRJibWMeCiQ+Qpf37rRcZWk+2NXLv92fwmnLpKx2t0SoCEP+sPryT1D0cNU//53w
         hLiQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro4giSrddtUsUxUxm/OQ4T1i/F8NPMX7Cvljk+dnma8n3LvFf6Gnu/Ji6ZEf+XzR55i5RK4sOqx8g==@kvack.org
X-Gm-Message-State: AOJu0Yx64Jwcohv9WvxqPVUUky91L39svKA0pllQvqMghOhFqNc42a3r
	i9/Htk/WXzKSWuupDFY1syMuXuSm7bV2lX0CgPn8QfwRa3s1NAukJLnd0Q/CP/mmmMOrZic1wdP
	wvvPIAVyzTzzkBtylbdQhqbVBH/+ZA6BWrIA9IScY
X-Gm-Gg: AfdE7cntXSkhwAZJl/5ksK2sr+tWqF231hG/c12yq7HH0oj6tr6IOP2+22AKThu139H
	DDb6E+SdCmzvkSE70TBe9qo9027asAj7diZGION1qZhkBd/R8s1Rnw8LIJz9jAcXy9hSXEHvAVU
	0wA11TEHB6jrgMG33U5XZoEZGrD8fMNqfqyBUh8F2ShTnTPiGpFtUG+DoQJxcMxjSJQQrl8XIh3
	uEWHeFin0JZ+lD9AHpt0Ga6PXXjBxEdCuMlHaOsZ8z3fS6L6FICBYTXrJz9Vti3TJa2AdiHS27N
	1UixEhwjrUzXd2UGFcknjUiQ/u0=
X-Received: by 2002:a17:902:ecc8:b0:2c7:d603:117f with SMTP id
 d9443c01a7336-2ca2ed3240amr8621505ad.26.1782775710608; Mon, 29 Jun 2026
 16:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
In-Reply-To: <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 29 Jun 2026 16:28:19 -0700
X-Gm-Features: AVVi8CfuflCaxfF7hmS1_WNIDJ8ZXm1g5ojY_cTwVKflYDavL-nSp0Q_fJQv3jM
Message-ID: <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, 
	Ruoyu Wang <fishw@asu.edu>, Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0AEAC0002
X-Stat-Signature: 1syfb7xa6j99y8f94tjcdcidhe6szmc8
X-HE-Tag: 1782775711-306986
X-HE-Meta: U2FsdGVkX1/MM9ZZkuj8GgaaLn/llXeR3904lSMpC22eNHFouv1jVaSeUgqSFk6WUYotouKqR4HV2gHqyXvam2pGPvWJqi7pIZHKG2RdmLNoP6PhOm2XqAwI1ZBxdkrNfOlbM8LhVIQQa5CXWylT0j/5xhuI4q+8F+86IT9H91IFif7xEYvhhaMcsSFstfyqmyvG6AXuRMrCL4dAioZKSoTmvgEWQ1SXfSI0ey+nZYCw+RHlZjNSEbP3GKBTByvro29g/DZwoqO+8h8eb1cWLrNUQHRoTmCvgrvU5/J/cZEiV/QM0NWyzLD3hDE52qyj1gGQNu588/kQhWqGe6YdGFVe3aUJRcgcy8wMjxMwTzAIsF1KrX2WO4IagwHFYC7msRnyP5TxMeGClD9PreLBeSMbDIBXiLFD6KQxo6glOpXJcistNBbhC6e7UcOTkbp/ir7wkLAtTdio54jQ5O8O88+mOR/8OjcMVVnUZYnsrfFNkaIe5G24bu1iZq9HX5GgBycZTy8ZTdDMahMCVHe8T9CmWhOpAr41e+CqtcbBriSTRzEpreFb1JIcpaAJ5NIAPxroD28oCTlxbn7BMnY7/sZ0mNPtbyXlRNGQZWwhwShaIhE8nhnGEZEM3pT4Tu/WJJvdlxHVcEkipzKV23YWVfuDb+6fmQKLx0OPwvjoIiTVqB5FsFaiXrfnXwlj+oKz+HRy/vojpn7rgbiNGgeve8HoeViGA97Xp8fO49GLXOBTe2X/B4adrHzuyYKLcLTzkKVldut7PWFzLPN/i9blXV5dYnO0PCjodqMG0SDIwb/NP3CzJBkXltiaZ3wqPQ2t4eHpS6N3gOuYr42DcgUiaRxCUm6gSRRWJRJTKMRykrfk5mwN9PYIde73vvvpBSy9L/BlPjvtfnYkHxiwxmUmHeIMZfawXNzsc8PCazmiRMu95x+W6bBbZqARiVUDFHxHSVpuqxhNgjPEVRISXAG
 cPwwN/Wh
 uadRPstY5kDFQNOKz8m7FmdofaIxMowSfshpInc6mB4QWnaEzl+sfKJlRM8CPLslARrdEEg8FwKZ8Vf21i9DNh/gTboiQAojMCjHaJPlOzieDAaFhHe7E4H/FZYXOQyZVmQW5B1kmOAnbqL3mkogkz2kYbn8KfYrifsFH9BCaDugodXEMVmulLzQax36XGOW38DSffOg9RV2aNyS08nSvEW6r3+HQX5rhxNW77ipaiRjk91qumDs90qGTK2UpiSBIXq+n7bccplkc9WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 3:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/29/26 14:47, Xiang Mei wrote:
> > With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area=
,
> > which an unprivileged user can surround with attacker-controlled data b=
y
> > spraying vmap allocations adjacent to a target stack (for example via
> > XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
> > guarded vmalloc allocation is followed by a single unmapped guard page.
> >
> > A single guard page is not enough to contain the x86_64 ENTER
> > instruction used as a one-instruction stack pivot. ENTER imm16, imm8
> > builds a stack frame and lowers RSP by:
> >
> >       imm16 + 8 * (L + 1),  L =3D imm8 & 0x1f
> >
> > imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
> > in [0, 31], so the maximum displacement of a single ENTER is:
> >
> >       0xffff + 8 * 0x20 =3D 0x100ff bytes
>
> This needs some more discussion of why this _specific_ instruction is so
> important and why a good old 'add'. Peter asked about this on v1 and it
> didn't make it into v2.
>

Thanks, I see it; we can also add more background introduction to the
commit message so readers can understand why ENTER is so special.

> I think it boils down to ENTER doing a bunch of useful stuff setting up
> a new frame in a single instruction. That single instruction is easier
> to conjure up from another exploit or bad control flow than actually
> setting up a stack frame.
>
> But, really, if ENTER is so evil and nobody uses it, shouldn't we just
> have an MSR bit somewhere to tell the CPU to #UD for it rather than
> playing these stack games?
>

I totally agree, and we'd like to see such a control. If I understand
correctly, that's a hardware/architectural change, so for current CPUs
we still need a software mitigation to harden the kernel.

> > That is more than enough to step off the current stack, across the
> > one-page guard, and into the adjacent sprayed pages. When those pages
> > contain a return sled feeding a ROP chain, reaching any ENTER gadget
> > (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
> > control-flow hijack into full ROP execution without any register contro=
l
> > at the hijack site, making it a one-gadget-style primitive that
> > significantly eases exploitation. The pivot happens after the control
> > transfer, so it is not constrained by CFI (kCFI/FineIBT).
>
> This all sounds super theoretical.
>
> I don't think we should mess with any of this without there being some
> sign that this is an actual, practical juicy exploit target.
>
Yes, I am sorry to reuse some incorrect comments I copied from v1.
I'll remove the CFI-related content since we assume we already have
control flow hijacking.
Thanks for pointing it out.

> > Introduce a VMAP_GUARD_PAGES knob that defaults to a single page (no
> > change for current architectures) and can be overridden per arch via
> > asm/vmalloc.h, and set it to 0x11 on x86_64. This is deliberately scope=
d
> > to x86_64: the 0x100ff bound is a property of the ENTER opcode, and ENT=
ER
> > is also a one-byte opcode (0xc8) that appears as abundant unintended
> > gadgets. Other architectures (e.g. arm64) have no equivalent
> > single-instruction, immediate-controlled pivot reachable as an unaligne=
d
> > unintended gadget, so they keep the one-page guard and pay no cost.
>
> To even be considered, this series needs to be refactored properly.
> Making this VMAP_GUARD_PAGES a separate patch is the bare minimum.
>
Good suggestion, I will do it in v3:

    1/3 - introduce VMAP_GUARD_PAGES
    2/3 - mark percpu vmap areas VM_NO_GUARD
    3/3 - set VMAP_GUARD_PAGES to 0x11 on x86_64

> > The override is gated on CONFIG_X86_64 rather than applying to all of x=
86:
> > VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not =
in
> > the vmalloc area and the technique does not apply there. 32-bit x86 als=
o
> > has a far smaller vmalloc window, where widening every guarded area by =
16
> > pages would needlessly pressure the address space.
>
> Shouldn't you condition it on HAVE_ARCH_VMAP_STACK, not X86_64 directly?
>

Yup, that's better; we'll do the following in v3:
```
#if defined(CONFIG_X86_64) && defined(CONFIG_VMAP_STACK)
#define VMAP_GUARD_PAGES 0x11
#endif
```

> > The guard pages are never populated, so there is no extra physical
> > memory and no additional page-table population beyond the larger virtua=
l
> > span; the cost is virtual address space and vmap_area bookkeeping, whic=
h
> > is negligible against the 64-bit vmalloc window. get_vm_area_size() is
> > adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
> > callers is unchanged.
>
> Let's be thorough here, though, please. You're arguing that there's no
> real cost to this. It's going to make the vmalloc() address space more
> sparse and put pressure on the intermediate paging structure caches.
> Whether that pressure matters is debatable.
>
> But I do think you owe at least some rudimentary performance checks on th=
is.
>

I'll do some cost tests before sending v3 and the correct statement.

> BTW, this is LLM-wordy. If you send another version of this, please work
> on making it more concicse.
>
The v3 comments would be concise.

> > On x86 this widens the guard for all guarded vmap areas, not only threa=
d
> > stacks. ret2enter targets the stack specifically, so a narrower
> > alternative is to apply the wider guard only on the thread-stack
> > allocation path via a dedicated VM_ flag; we kept the change in the
> > common path as defense in depth for any vmalloc-adjacent pivot target,
> > but are happy to scope it to stacks if maintainers prefer.
>
> The simplest code thing for now is to just make it apply to all
> vmalloc() allocations. That also theoretically has the largest impact,
> but it's probably the best patch to start with.
>
> > While widening the guard, also mark percpu vmap areas VM_NO_GUARD.
> > pcpu_get_vm_areas() and pcpu_page_first_chunk() size each area exactly =
and
> > reserve no guard, so get_vm_area_size() would subtract a guard that was
> > never added and underflow if an area were smaller than the guard. This =
is
> > a latent correctness fix only: on x86_64 percpu areas are megabyte-scal=
e,
> > far larger than the guard.
>
> Honestly, I think this is just a sign that the code needs refactoring
> rather than hacks.
>
> If you go forward with this, I think vm_struct just needs a
> area->guard_nr_pages. Then the internal users of the structure just set
> area->size and the guard size. They don't have to fiddle with VM_NO_GUARD=
.
>
Agree, the problem exists before our patch (get_vm_area_size() is
already one page less).
> > +/*
> > + * The x86 ENTER instruction can be used as a one-instruction stack pi=
vot:
> > + * ENTER imm16, imm8 lowers RSP by imm16 + 8 * (L + 1), L =3D imm8 & 0=
x1f.
> > + * imm16 is an unsigned 16-bit operand (ENTER never raises RSP) and L =
is in
> > + * [0, 31], so a single ENTER can lower RSP by at most
> > + * 0xffff + 8 * 0x20 =3D 0x100ff bytes. With CONFIG_VMAP_STACK the ker=
nel
> > + * stack lives in the vmalloc area, where an unprivileged user can spr=
ay
> > + * adjacent allocations; a single-page guard is too small to contain s=
uch a
> > + * pivot. Use 0x11 guard pages (0x11000 bytes), the smallest whole-pag=
e
> > + * span exceeding 0x100ff, so the pivot faults in the guard instead of
> > + * landing in attacker-controlled memory.
> > + *
> > + * Restrict this to 64-bit: VMAP_STACK is selected only on x86_64, so =
32-bit
> > + * kernel stacks are not in the vmalloc area and the technique does no=
t apply.
> > + * 32-bit also has a far smaller vmalloc window, where a 16-page-per-a=
rea
> > + * widening would needlessly pressure the address space.
> > + */
> > +#ifdef CONFIG_X86_64
> > +#define VMAP_GUARD_PAGES     0x11
> > +#endif
>
> That comment is way too big. What is it protecting? What does the number
> come from? We don't need to see the gory details in the comment.
>
> /*
>  * Protect against control flow hijacks to gadgets using the ENTER
>  * instruction. Those can jump a bit over 64k on the stack so make the
>  * guard 64k+4k.
>  */
> #ifdef CONFIG_VMAP_STACK
> #define VMAP_GUARD_PAGES        0x11
> #endif
>
> Right? What else do you really need?
>
Got it, simple comments and thanks for the example.

> >  #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
> >
> >  #ifdef CONFIG_X86_64
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index 3b02c0c6b371..b8546e519deb 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -49,6 +49,18 @@ struct iov_iter;           /* in uio.h */
> >  #define IOREMAP_MAX_ORDER    (7 + PAGE_SHIFT)        /* 128 pages */
> >  #endif
> >
> > +/*
> > + * Number of unmapped guard pages appended to each guarded vmalloc
> > + * allocation. The default is a single page; an architecture may overr=
ide
> > + * VMAP_GUARD_PAGES (via asm/vmalloc.h) when a wider guard is needed t=
o
> > + * contain a worst-case single-instruction stack pivot into an adjacen=
t,
> > + * attacker-controlled vmap allocation (see arch/x86 for the ENTER cas=
e).
> > + */
>
> Heh, are you getting paid by the word here? These are way too verbose.
>
I'll clean them in v3.
> > +#ifndef VMAP_GUARD_PAGES
> > +#define VMAP_GUARD_PAGES     1
> > +#endif
> > +#define VMAP_GUARD_SIZE              (VMAP_GUARD_PAGES * PAGE_SIZE)
>
> This could also be quite trivially expressed in Kconfig:
>
> config VMAP_GUARD_PAGES
>         int
>         default 1
>         default ARCH_VMAP_GUARD_PAGES if ARCH_VMAP_GUARD_PAGES
>
Good suggestion, it'll be in v3.
> >  struct vm_struct {
> >       union {
> >               struct vm_struct *next;   /* Early registration of vm_are=
as. */
> > @@ -236,8 +248,8 @@ int vmap_pages_range(unsigned long addr, unsigned l=
ong end, pgprot_t prot,
> >  static inline size_t get_vm_area_size(const struct vm_struct *area)
> >  {
> >       if (!(area->flags & VM_NO_GUARD))
> > -             /* return actual size without guard page */
> > -             return area->size - PAGE_SIZE;
> > +             /* return actual size without guard region */
> > +             return area->size - VMAP_GUARD_SIZE;
> >       else
> >               return area->size;
> >
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index b0676b8054ed..9f7262228be1 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -3243,7 +3243,7 @@ int __init pcpu_page_first_chunk(size_t reserved_=
size, pcpu_fc_cpu_to_node_fn_t
> >       }
> >
> >       /* allocate vm area, map the pages and copy static data */
> > -     vm.flags =3D VM_ALLOC;
> > +     vm.flags =3D VM_ALLOC | VM_NO_GUARD;
> >       vm.size =3D num_possible_cpus() * ai->unit_size;
> >       vm_area_register_early(&vm, PAGE_SIZE);
>
> Yeah, I'd much rather see:
>
>         vm.size  =3D num_possible_cpus() * ai->unit_size;
>         vm.guard =3D 0;
>
> (or whatever we name the structure member) in cases like this.
>
> So, yeah, this is a cute PoC hack. But it's gluing about 10 different
> things into one patch instead of doing proper refactoring. Plus, I'm not
> really even sure it's worth it in the first place.

Yeah, I'll separate them into a series of patches. I believe it's a
worthy patch since it's a huge benefit to have a generic
one-gadget-style gadget. We have tested this one-gadget-style stack
pivoting on real CVEs and got the exploitation working without
additional changes.

Thanks for your review. I'll do the benchmarking and deliver v3.

Xiang

