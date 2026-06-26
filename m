Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABDBC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 20:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E736B00B1; Fri, 26 Jun 2026 16:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016926B00B2; Fri, 26 Jun 2026 16:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F796B00B4; Fri, 26 Jun 2026 16:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAAF46B00B1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:05:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A3C8C2A54
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:05:48 +0000 (UTC)
X-FDA: 84923144376.22.2637BBE
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9576180003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:05:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=VOPeM6D4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.45 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782504346;
	b=NOx11l8Gm6/okwAoQz7Jbgejooc7XuSlMX+QN4wG+sWVsVNXHBcD0v4IDmDY7h9NN5ZjIx
	hujhKad1tk7QNYCzLvYm+WtESxIg+GXDAPGZSFKarL52nwdiqIU1IbR0iv6RJO3dkCMbRC
	Y1vGGxPxhmUDbHpJo2kBCtBAWyWHfhE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782504346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Sr1Voge+YPmaHj1KHoOulPw7Fr0ziUVv0mpLGt8YA=;
	b=Uusrpj3R3Lmz+Bj/dIazH5CJpAwiLasbioUaDLgSgcxwG7Ym2PN9Q1ActP5DeLXVuYSiFn
	SAeiP2+j1mHFVGJecSZlK4WRMq/dMeILdYZDz8Vjf4Fc+3JyiErQALVNgY/Ny2lbwvGbYV
	1GSgTnCfc9lc8LgPrZhrrHPLuMGkgVI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=VOPeM6D4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.45 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37e00ef16ccso1173483a91.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782504345; cv=none;
        d=google.com; s=arc-20260327;
        b=OTLkHuAJrUTFaL7xqzTVyeR0gL1RAb4ZxspXOP5yJGeFJsM2dsWI8zhdFvsAjdLuyy
         UTR0t5tR42p/wcOVS7hi7xbWHVyYjW3pzW84Lx4eauqzfnlErvTvDLZuk0I6GcjZ7zkY
         DmoyL5ZoiqL1OGW2q0Y9WE9mHYg6dU9Hb4od247fmHkZzAaXjQfezvT07umyOJAQ5QTt
         oWW4YoCdZ4gs5pE549wAHn3s+n+xSABb3UHvfZZ/vPUw8G6hN9VFOjei4JB80CkCamqb
         DsjQsx0hY7VHpJDtx85FnT0luyEhV5j5R0u8Ep+/CemUK541hfEOKgLtoZ1pxrWTgVRf
         WG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P2Sr1Voge+YPmaHj1KHoOulPw7Fr0ziUVv0mpLGt8YA=;
        fh=5DNLuMYwAy3zCbnJY9WF/GZ5AjygtUvf5LIXlkV4BBM=;
        b=V9pCEqJN5hbuBCxY2Wv6Uou3pxxbC+CyuZiv7Xg6fSGwel2p9pljQvNLltlo3nbW70
         7RiVkRrxWNRuEIg0lQ0M0oFELdzJ5e9m4BTT4IY6opBmYNxmX/c/e+hYgrCrWrwTqe3A
         xsz0XCZhQfIWNMUqVfLBa0nV1dQWcdc6djfrXI5113uc/XY2VOIIsqSViBgeR67E6n6P
         vYugO1tJA3bsv7CtgZz7gcp5s0bDzScl77Zut48RUspqtzHLjCdaoXoP3WntIE+HK2Uh
         lAFn6w0clcmNOVSH8+aqFUdIGTUD7IEl8sth1lU4AK0NjnjhKwtu+CwjcewIv0KIk8wi
         jynw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782504345; x=1783109145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2Sr1Voge+YPmaHj1KHoOulPw7Fr0ziUVv0mpLGt8YA=;
        b=VOPeM6D4eGYTZML59luh30fsSachuAAXnRUn+TiLy20xG28qDyWtU79wToqcWLcTJn
         37NujbXok0n8pOPwcrQnWKNdoWtPt5bLlObg9Qa/9q+qliQ+blUpJD/QCd6xDmjcRviu
         WnS4ox/qP7C9q9pl0I/y99g0/JlbJyC/6PVnuyTSd8qXi2s7JIh+p74Swbur2Q16gcpT
         mhpqx/4nKU++SbQJO8ljO6d8zSgPg+hVcG+oohQPIW5XfKtbvAeG2oL6wcV07yUUpFdV
         AMf4Q+UdB3Kn4s5k1V/anWPiq3UQ868I2SdlCr125IfLWdSzeVS1tZar1ceHpX6enp3u
         UOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782504345; x=1783109145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2Sr1Voge+YPmaHj1KHoOulPw7Fr0ziUVv0mpLGt8YA=;
        b=pKsAiOibT83Sd23dkfZq9vgnSixYvKw/fuQuH3IxumWptFVhedpNeurR2rDPIk4uf5
         t4oDGG6aeJPPR6BhniD1EmM2cxh/vx9QBAT9d2sYgFZ04qwvdpAhv1WfRM4aKB1MMDiw
         8Jm1tFAtdLyfrtiUS9jI5V3berAbdSjA7jywDd8UyuouGpMJPjTzMkNOREPR7/b65HLj
         DMHdz+IfB44oLSpI5KumpUjH84IcIs2UGrgY4DDGy7yq7A5PMR8TBVf6fFEn0OjYaJV/
         beCr8xV2BjlDDvgDDN0l87p5txmC20zBO5Mdi9GHdKnGrqOrAAPrFrzcsLs9ReIAy/ou
         gR5g==
X-Forwarded-Encrypted: i=1; AFNElJ/XCW2nj8kDu76jYyRrx0dSQwcb6YQ/l2DILh3hAViHzJiKc1wqQt/Vw/AmcUX5E8tw+LNd3bnOSg==@kvack.org
X-Gm-Message-State: AOJu0YwmZaavStXuJIg9eQPHQZ8xlvow743vg2DOXoL1yScojH4ymt4k
	lwWydaEKr8EJjSEIm2If8RjE1MovqZVQ2g7224DnP4NyB6KuABnVfjsFYYH/dnoHaxserFlQHoi
	kM7BZoRCi9ZIm+NVlWMBh2UFfc4zrqgDc/QYBUtDY
X-Gm-Gg: AfdE7ckrKgTlLBBjB6dNSsPRkAKoQL5sEHSINQrmgmJDADdNNuKkMlcDUYikPGAQdh1
	hDVwpQf0CW1aQclQMbfwzVcukwfJ+j3ykgrxkce550p3Up24O7oOOx8EPt7nwJxMNn2vPcwYiq+
	AagCjctms0J6q09NvdygMbJbyMZPddFKwPpM0MMblTmmLJuUn9oR4bVQG5eaaVbUaZoNmAJKuE9
	NpJuIzhPXXBx5bYhiqPf68nstWKRLp4iiYSNbQIVjjicPtFroGcUvqc010+RuZBtzY9Zsc2dT/c
	e/OoAPb6LZgHSboyT5AKCiGcSg==
X-Received: by 2002:a05:6a21:a38d:b0:3bf:6c08:fb9d with SMTP id
 adf61e73a8af0-3bf6c091486mr1297599637.49.1782504344619; Fri, 26 Jun 2026
 13:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <aj7UNceukU9zYeGH@pedro-suse.lan>
In-Reply-To: <aj7UNceukU9zYeGH@pedro-suse.lan>
From: Xiang Mei <xmei5@asu.edu>
Date: Fri, 26 Jun 2026 13:05:33 -0700
X-Gm-Features: AVVi8CfdLihLYVRtAh89OO3_pCn0nmJaCpMOZTZHdN5ZsIoEpOA4Iy53bZxlagw
Message-ID: <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Pedro Falcato <pfalcato@suse.de>
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
X-Stat-Signature: tthk8tpa3jdk17hbnbqkjfa9yqfot3tp
X-Rspamd-Queue-Id: E9576180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782504345-362270
X-HE-Meta: U2FsdGVkX1/Y7jYrtzVS0Z8CkpzZ741fvrafo1Cx2Pmow6JGROLWrOXUr/S500expQ5W7vp1YxWgsT0wiA+o6+0jYoNV+tw95wtPzAFl8f4zHKi5lGQ8qg7vdQPKqEAcVl7d8uyvsGncbtQoxlL0CajG0G938PCDsT/VYSLfvpUZKbYqkWkpMr5ceAQfi1Ld9arrV31Jf6cagUUElhYLMLAKwAz53nsu+xqFY+WCZBa80kE493gfof7dVytvnhBjdMczPxn84UN3cJBJXn2sk3bAaVzWitzkwNfZj3M7Aiinwk2r4QRcN1njWidxxmsIpi0t/Y4j/EYz6U6Nvu+3m5PpQ7oWQfYNz9ItLbv6++Vdsue1peGqfo0ChoGkC1+A/zc3wgWteK33vnPJFKyT7NukFRTGPWmfgv/vAfsJIPu2G6EppMUZ4a750syGLr9Gber9+Hk94mBs7rAQHLpFR8ODlTM/D6mDYbpKUxrNazf+vS+28Um2fG0jkiTfg7YHvVCfmN5ueM1ruQxdTx/SR6v+xzsBuO3xhlZqp9L8yx8rvL6VdX2hpW80enVy1mNDLgHqOruQ2qmxkPOJILfx/JtaC0CMZNO8O9oDEm/CtAHw5VeHJwI9weGjo+hSTLLowsLIpTKRl/KgTCHwCgF9fo1FyWh1uJRnzxVi0/BHZTkDg51VKlWTPQ2C4NZhNzs5VYrPeW/8b7F4vAaisWfKijKIO2b0GcZmDq8yOFcStYtCAnIU/JPDtxPp1ASVtDwAC1BEeqnOR6DKOnrx8LyhbrNts0gfO06FW5MzLsNU0mJJVYrHtt4cyyqtRHM3ar7zIe1pn7pzzsAQL6oaf2SrlKu44mScAG/kehE92LXpMbkPWZpQujtkL8z7fPLfLs036Po6Fp3KUbgqoTWQJDA0vpp7tmAez9uNuA9GIfFyxI0UnP8AWT/kIE8ZWswxDi9xBbvHpX+OVKAB5XR77Sb
 XyhzYTpQ
 VQUq8vMbt0KrzlIeVMYjTULZfXK1ntNII8S5F6xWS8rWo8G5jjHqGN+StD1iYbvY105ic5F5S7539ENP9mJukrCsreMFDPllnilgIUiL4PRRG3JaZytPJOp3otzIVfmSuHIVK0MoDcYq1R4tZhxu9y+tB7Q8dkkKJZfa4r0sMjesaWPU5lePHTBwZSQbYMuiAJtmT4bHB16hKm+Lh2Mi7ubfLryVF+Q420CwHaOZyy62+D/6QzDPoxeyEMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 12:39=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> On Fri, Jun 26, 2026 at 10:34:44AM -0700, Xiang Mei wrote:
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
> >
> > That is more than enough to step off the current stack, across the
> > one-page guard, and into the adjacent sprayed pages. When those pages
> > contain a return sled feeding a ROP chain, reaching any ENTER gadget
> > (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
> > control-flow hijack into full ROP execution without any register contro=
l
> > at the hijack site, making it a one-gadget-style primitive that
> > significantly eases exploitation. The pivot happens after the control
> > transfer, so it is not constrained by CFI (kCFI/FineIBT).
> >
> > Widen the guard region from one page to VMAP_GUARD_PAGES (0x11 pages,
> > 0x11000 bytes), which is the smallest whole-page span exceeding the
> > 0x100ff-byte maximum single-ENTER pivot. A pivot off the top of the
> > stack now lands in the unmapped guard and faults, instead of in mapped,
> > attacker-controlled memory. RANDOMIZE_KSTACK_OFFSET only perturbs RSP b=
y
> > a sub-page amount, so it does not change the required width.
>
> What's so special about enter? Why do we need to design our guard pages
> around it? FWIW, I can't find enter instructions in any of my kernel buil=
ds,
> nor can I convince gcc (on godbolt) to generate an enter instruction.
>

Thanks for your questions and attention.

1) `enter` can do big enough stack pivoting (where we can't find many
`add/sub/adc/sbb rsp, ` doing so)
2) `enter` is not rare since we can take part in the instruction.
Therefore, we are searching for `\xc8.*` (lose upper bound).

Take its subset as an example and perform the search on a default
config kernel, we search for gadgets and filter by `grep ": enter
0x5...,"`
```
0xffffffff853d9c44: enter 0x5157, 0xfc; mov eax, ebp; pop rbx; pop
rbp; pop r12; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff85514c34: enter 0x5e9f, 0xfc; mov eax, ebx; pop rbx; pop
rbp; pop r12; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff855d2034: enter 0x52cb, 0xfc; mov eax, ebx; pop rbx; pop
rbp; pop r12; pop r13; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff8589e155: enter 0x5c41, 0x41; pop rbp; pop r14; pop r15; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff85d1f06a: enter 0x5d03, 0x41; pop rsp; pop r13; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff85d51a2d: enter 0x5c41, 0x41; pop rbp; pop r14; pop r15; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff862e8d3c: enter 0x5822, 5; jne short 0xffffffff862e8db0; add
rsp, 0xc8; pop rbx; pop r12; pop r13; pop r14; pop r15; pop rbp; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff863a551e: enter 0x5c41, 0x41; pop rbp; pop r14; pop r15; pop
rbp; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff8658b134: enter 0x573a, 0xfb; mov eax, ebp; add rsp, 8; pop
rbx; pop rbp; pop r12; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff8658d434: enter 0x5717, 0xfb; mov eax, ebp; add rsp, 8; pop
rbx; pop rbp; pop r12; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff8679fcd6: enter 0x5d5b, 0x41; pop rsp; pop r13; pop r14; pop
r15; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
12:55 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": enter 0x5...," | wc
     40     672    5269
```
Each of them can be used to perform one-gadget stack pivoting for a
Control Flow Hijacking primitive.

> If it's just "this is a single instruction that adjusts RSP", why is e.g.
> sub imm32, %rsp ok?
>
These gadgets are common, but most of them can't skip the garden page,
and the operands are less than one page.
On the same kernel, we found 0 usable gadgets (pivot the RSP out of
the current stack frame) for such gadget family:
```
13:00 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": sub rsp, 0x....;"
13:01 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": add rsp, 0x....;"
13:01 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": adc rsp, 0x....;"
13:01 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": sbb rsp, 0x....;"
13:01 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": sbb rsp, 0x"  | less
13:01 n132@p1 /home/n132/kCTF/fx0
% cat ./gadgets | grep ret | grep ": add rsp, 0x"  | tail
0xffffffff86864d99: add rsp, 0x60; pop rbx; pop rbp; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86864e85: add rsp, 0x60; pop rbx; pop rbp; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86864f7b: add rsp, 0x60; pop rbx; pop rbp; jmp
0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86865248: add rsp, 0x90; pop rbx; pop rbp; pop r12; pop r13;
pop r14; pop r15; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86865fd2: add rsp, 0xd0; pop rbx; pop rbp; pop r12; pop r13;
pop r14; pop r15; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86866fcc: add rsp, 0x68; pop rbx; pop rbp; pop r12; pop r13;
pop r14; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86867463: add rsp, 0x90; pop rbx; pop rbp; pop r12; pop r13;
pop r14; pop r15; jmp 0xffffffff86869bf0 <__x86_return_thunk>;
0xffffffff86867944: add rsp, 0xa8; mov eax, ebp; pop rbx; pop rbp; pop
r12; pop r13; pop r14; pop r15; jmp 0xffffffff86869bf0
<__x86_return_thunk>;
0xffffffff86867b8f: add rsp, 0xb8; mov eax, r12d; pop rbx; pop rbp;
pop r12; pop r13; pop r14; pop r15; jmp 0xffffffff86869bf0
<__x86_return_thunk>;
0xffffffff86869b7d: add rsp, 0x80; mov qword ptr gs:[rip+0x5001490],
0xffffffffffffffff; ret;
```
> FTR, I think it's fine that you're proposing more guard pages; virtual ad=
dress
> space is virtually free on 64-bit architectures (apart from lower page ta=
ble
> density, which may take a little toll on memory usage and/or page table
> caching). I'm just wondering why enter is being used as the concrete targ=
et
> for this.

Thanks for your feedback. We are glad to provide more information and
its practical success for real CVEs.

Xiang
>
> --
> Pedro

