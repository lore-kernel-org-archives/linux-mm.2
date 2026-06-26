Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABDEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B7E6B0117; Fri, 26 Jun 2026 13:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC0E6B0118; Fri, 26 Jun 2026 13:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93926B0119; Fri, 26 Jun 2026 13:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949276B0117
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:49:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F313F140522
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:49:00 +0000 (UTC)
X-FDA: 84922799640.21.8C08372
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00216C0014
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:48:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=XP86g+Fg;
	spf=pass (imf10.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782496139;
	b=OFGXHT4dYLjUO99XurcTzwuMnFGCUeOcaxCi6e97ousXkcdr630QeYlSC8+9JOmuaQVLyR
	I4cc+VSb0YX55k9ah/Ntn2v8MzGpA+53HjY0xMLucq85mgOKO6xIe2AyTF/YUyFvgqtg6I
	oXTk1liI4pbatNCjnnx0ortRzn8x0v0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782496139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPiBM+E5Ju94wzqMADw6UMZMV0vo32ARI3eqTrkdDy0=;
	b=a5Zs6QfeMvBXuAnbxVRf0rN5aBx+b1ttMbh53vSrmlVBklvPvgfEMCGTquBCdxzGcR5BBE
	RseVnOSDeB5oTyLp4t3rWR4rLQGEN8z0N3RAS2Jf2B210Ggno3Hq3ZOl3SE20ew38ERxWK
	vocMzuphEVJhItK+6l8hpqW/crVOPrQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=XP86g+Fg;
	spf=pass (imf10.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c99672293cso3388695ad.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:48:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782496138; cv=none;
        d=google.com; s=arc-20260327;
        b=oTq4JPyKd53g6h+LO9wIzrxPUb0L73nWtdkE446pSTlBhwdzIt/Fut644TSPFCLnHW
         U+pPgLWFEzR3QplylhaBUEZY0oXcyt5gY9c+O1qfRiVLjb2VKJOft2d1bCPk8jU1OYIZ
         mv3sBQf5EHsvtT2xZE5sJ0PT8A2AAGGuPKEsweOTWsQ9WOMwJ5LowvGprJGbuU8MPNBf
         GCCZutogMBt+7Aw1Y9wkOzGcRxQWI6fNKRnPcFvJfkIlUtzOgH3esCR8c2fuGNncXz6A
         ngjctPXppvU7w7wf3JjzIQV2cTuHfJnHKw4MBHmAw2d4ZsH9c5C2ku88uK5eZGQQQVEP
         s+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wPiBM+E5Ju94wzqMADw6UMZMV0vo32ARI3eqTrkdDy0=;
        fh=RSnYPUEeAfFtQKkJiLvMvkwioAZdr5jG9xzAs1s2dgk=;
        b=ogF9lEiOs+3TuCKkmT0YqSUqL6cm08jcAC1ZENi6GRTLIsYZINkfMXOIGXlkE9SFm5
         FClgxUktgrrRRsKHrw5FWTbev1XnXQUDH8k065WQD85IUGoEehC0BzYFB7RyAKko6QqN
         n7sKJi4/FC8w21fmpdBXxH41wX6I0Ao3JjYhKG3Y3HqAoQfPLM81TQdEx5i0OdUBwEnc
         HNUipCX4761yVs/SKYjY0HeT6Q+FZZKU9EocytP7elGKoa2PnlgMjoazWVqF+5p2DlJ3
         s/ug1DCjLzo/y5GJYlZshQmU2w5Eh1AZv1hSZHo7c636cUJnrYjqPZlTwLzsHnTupo0V
         Q66w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782496138; x=1783100938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPiBM+E5Ju94wzqMADw6UMZMV0vo32ARI3eqTrkdDy0=;
        b=XP86g+FgzDKozvMbxodYncQ2t7ahGExSgl+vFbv/e9lmOAKxk/phS0wgyGC87riIkw
         nR5wHcMq7wDqStGgIwaCXDIPel199FB20WmHXwgn8280x+OMhH/kOcNP1e1RoxfLBOQ7
         UacGuSdfEFfCQ2lCwjoapGb6O4sg9VMVKjlkOLKmOHW8IxAE0EkUOOnSPW0kzDwlmRE1
         1bGYnGnN2v2n4Ov6RB+BLxs/c31PbBV0wUsjj1GYmKxAnn4cla8o17gfIk3i9SLdfVuS
         cy3p258FlpbSqmdRP5ODFOHgVVNuPkYRIa/VH5zvqVbFvf8+cnK9+DrPoA9U2pl1J09v
         mzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782496138; x=1783100938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wPiBM+E5Ju94wzqMADw6UMZMV0vo32ARI3eqTrkdDy0=;
        b=lncxWqo7TrPExllFTZ6hv8n8x1xz9gSHQJAvDNO74xPp/6yU4mA31EsBsn1smMMqBY
         qMoaN1txQUkEiLYl4wsN34PL06kJvSk9u4wulsXPmVShBe5OUceRMKgA6VRr5zY15qW1
         rlJFey/2VQBTswPe7a89ON96aiRhjc709AAUKa7A2lWaLouRF+A6FMC+cKZ50rT6mtT0
         wR9E07PP8fmpko8kG31HwSd+sooNwPIjBwfg9B6U21NrhFujvMbRyzXIXcsea9i51gYF
         pbDYl60GtprqFFczWRT0bJmFwSggcCike+XnFWavgmfWibcj/AuGrzThH+GFJk0CDuLr
         TPSg==
X-Forwarded-Encrypted: i=1; AHgh+RqierXMzCLssZ5tTkMEldZneh0O7w5/b+DWqUvxV8p8VoRtdFYSXKwyWGhYFrEgdv6iljzg9ZqaVw==@kvack.org
X-Gm-Message-State: AOJu0Yx1njiqrZZbwfT84cEA+vNBDRHagWd5N9kCuTOmxXBxonMi8qmZ
	09G0B1QYjI3bbvhAf5K/hY1ciozxNM1mNgKKfABGHa1vxdyaPfQ1tcsQUinlO3tYOVfmWQAyC6s
	6bmiPvHQv1m6NeeRMTxqC7wQK/srDg/DQTzFn6+Fj
X-Gm-Gg: AfdE7clJUIqS3AXgSmMEb1NT2IEwH/4CrEcg3Fe+uleW5Ka4eYeDrurkNA9W3gIvYpI
	UOgIsMiB2/hymnw8ENmtt2UT4qnbFfYuboYLDtTKW5etU2wWlX6wi0Q9/ZmlqnupCXXQNEJBlVF
	6dAhyDVVoVJax6OtQia6mgyknUvOQggP2lGBS1YD9eiIeJKk1o8y6mLy9fjtX4OiJ37A0/PDOfd
	O2AcBWxDd9Sv86gen9DrQWmouxjz4LM1xlVnhf3jqX7gCTl82/GBNR38/NQ5EpLald1nt1pDHy0
	8gl3FNIRIU4edak83KWZXK23TckMwn0=
X-Received: by 2002:a17:902:ce81:b0:2c0:cf44:3b3d with SMTP id
 d9443c01a7336-2c7fc7579b0mr80875375ad.26.1782496137705; Fri, 26 Jun 2026
 10:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <yu6l7zo4dmqcnho7thkf7sk42lt6xkz6uxxwxmg73x23vihlnp@pe7vdut4o2jc>
In-Reply-To: <yu6l7zo4dmqcnho7thkf7sk42lt6xkz6uxxwxmg73x23vihlnp@pe7vdut4o2jc>
From: Xiang Mei <xmei5@asu.edu>
Date: Fri, 26 Jun 2026 10:48:46 -0700
X-Gm-Features: AVVi8CeGKAZBpyQZXB1HQ0x9CI7wJdF0pT0XJ5Q6sZegQF17kMZVeso3AFwnI0M
Message-ID: <CAPpSM+Qwmv_wsNFnEjtk3GbLdZB_JtH5vW0v-Cj-CyiE8M_UEw@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xtoauesmbwyxoqfi8ddero7cx3nq4y1h
X-Rspamd-Queue-Id: 00216C0014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782496138-466197
X-HE-Meta: U2FsdGVkX1+Q9FcfbiytAkJLKSUVwxEyaj2bGFV1G9w4LqPvU97okFslulHqAA7JbBISX0hPWwaY4WpwKrb6e2mGLrkmIRylTDMIM/DPJ278x+j6J94w1oNOL34Jrn9a4fJhANI8DymtobNiG7ABUkBrTKnTNfMgck4XV0ATwUBfIAIBIiwZ3QKnhTPsI3z+//ZJO3UDrmOppnBzpoH/5q1MRSTfpwECKHNvBTf/a0e0SnV3pu9gKsyBDnAn/WjrOY/DZnhg46glh6Igz8fFPfa1oh3w3Ktdkfuqe3f9U5gD2DmUQOIAu3a+6ZGB329BS9reZiCGSTMkmsCv/N6tKHhdwlrGbxGprXxNUGsb8OyXfHBmaSdsBc831KCfSLnJvWzJNH9d55tyMCFmLcWwLpKo1YpjYaLiQjHj5AiYel9w8VBbtyNRqXiF6ZFk9laFXKFZhk+IA1CtE+4HBuR5P3JjGM5J1XJcK0dpvvXYCxxm59G0riZtxo3WTyeAOAt+dNN25mc1hhSVh2+rb7jGt1EptJq+/bc5lRfn5Duwqt63Z/GzvzIrINI7Q5bxgh3v30r1xa6wcE/oijuUMqP+UUgpI/lp6AKogYk+iTyDw+eBucAid2ywjCxL9GY7JNeEqoGmlbvNNn0k1I93Aut1f6iUXm6CPFuusDF1IOooNoI4i1vsBGkiDOoJEK7/ixhCp3Iw/bcFXedfTEaKv2h7o7XHBpzpZdzdc7T/fk8e4KLsVLfCIQSbdxAcSoDYid7lzj83iNNV7w6jfDh7DwMcWf8/Ie1CvYh5BwAewAQ5Socs4KOvZBrSgmyizJCN9pr/4Jvu7QvSm4crJIu3W30sktSwOW9OH8UWzmAujWVcL34J9IMxvIpzxaC0iRbjx5JzXPT2LG8IoMts66ceJjdEZ7OJpYMMVWAVfRN4994N32q/yP+7RfkMjdwAe/+j60YM3EEG0bbzHvLdXznQWhX
 RdRDtNkR
 PHOhlrqHLdZRYpyVwX8sES6fAQ8Ebeo9RpEMRPssqIvsNrJpFJfIxvOqU9suAVFy1tIU4f+TzCKoHJAD9K4x79kKRJ6hmrrDfpSuVU7d3GBfrUdaYK1EkcC53czaR4MAFJofrFAj26qAtOHKLKobcF9kRdNNIgHSBQ2QcHiXxMOvJwJujraw2ubSNRrU3g/gGK2jYxQxljwIqvBPaVwOX1k2CCfpTidlVOrGFVg/LJrWhcaMyiyl+LrSvNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:46=E2=80=AFAM Xiang Mei <xmei5@asu.edu> wrote:
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
> >
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
> >
> > The override is gated on CONFIG_X86_64 rather than applying to all of x=
86:
> > VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not =
in
> > the vmalloc area and the technique does not apply there. 32-bit x86 als=
o
> > has a far smaller vmalloc window, where widening every guarded area by =
16
> > pages would needlessly pressure the address space.
> >
> > The guard pages are never populated, so there is no extra physical
> > memory and no additional page-table population beyond the larger virtua=
l
> > span; the cost is virtual address space and vmap_area bookkeeping, whic=
h
> > is negligible against the 64-bit vmalloc window. get_vm_area_size() is
> > adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
> > callers is unchanged.
> >
> > On x86 this widens the guard for all guarded vmap areas, not only threa=
d
> > stacks. ret2enter targets the stack specifically, so a narrower
> > alternative is to apply the wider guard only on the thread-stack
> > allocation path via a dedicated VM_ flag; we kept the change in the
> > common path as defense in depth for any vmalloc-adjacent pivot target,
> > but are happy to scope it to stacks if maintainers prefer.
> >
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Jennifer Miller <jmill@asu.edu>
> > ---
> >  arch/x86/include/asm/vmalloc.h | 21 +++++++++++++++++++++
> >  include/linux/vmalloc.h        | 16 ++++++++++++++--
> >  mm/vmalloc.c                   |  2 +-
> >  3 files changed, 36 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/vmalloc.h b/arch/x86/include/asm/vmal=
loc.h
> > index 49ce331f3ac6..2c341f398227 100644
> > --- a/arch/x86/include/asm/vmalloc.h
> > +++ b/arch/x86/include/asm/vmalloc.h
> > @@ -5,6 +5,27 @@
> >  #include <asm/page.h>
> >  #include <asm/pgtable_areas.h>
> >
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
> > +
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
> > +#ifndef VMAP_GUARD_PAGES
> > +#define VMAP_GUARD_PAGES     1
> > +#endif
> > +#define VMAP_GUARD_SIZE              (VMAP_GUARD_PAGES * PAGE_SIZE)
> > +
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
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index bb6ae08d18f5..8bb2b3ef40a8 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned lon=
g size,
> >               return NULL;
> >
> >       if (!(flags & VM_NO_GUARD))
> > -             size +=3D PAGE_SIZE;
> > +             size +=3D VMAP_GUARD_SIZE;
> >
> >       area->flags =3D flags;
> >       area->caller =3D caller;
> > --
> > 2.43.0
> >
>
>
> Hi hardening team and maintainers,
>
> This patch widens the vmalloc guard region on x86_64 to close a
> class of stack-pivot primitive against CONFIG_VMAP_STACK kernels. We woul=
d
> like the hardening and mm/x86 maintainers' view on whether this belongs i=
n
> the common guard path or should be scoped to thread stacks.
>
> The description below is intentionally theoretical: it explains why a sin=
gle
> guard page is insufficient, without operational exploitation detail.
>
> Background / threat model
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
> With CONFIG_VMAP_STACK (the default on x86_64), kernel thread stacks live=
 in
> the vmalloc area, which allocates roughly linearly. In principle an
> unprivileged user can place attacker-controlled vmalloc allocations near =
a
> target stack, the vmalloc area exposes several allocation paths reachable
> from userspace, so at the moment of a control-flow hijack the live stack
> can be adjacent to attacker-controlled mapped pages.
>
> Today each guarded vmalloc allocation is followed by a single unmapped gu=
ard
> page. The guard relies on the assumption that a corrupted RSP cannot jump
> far enough, in one step, to clear the guard and land in the next mapped
> allocation. On x86_64 that assumption does not hold.
>
> The primitive
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The x86_64 ENTER instruction (ENTER imm16, imm8) builds a stack frame in =
a
> single instruction and lowers RSP by:
>
>     imm16 + 8 * (L + 1),  L =3D imm8 & 0x1f
>
> imm16 is an unsigned 16-bit operand and ENTER never raises RSP, so a sing=
le
> ENTER lowers RSP by up to 0xffff + 8 * 0x20 =3D 0x100ff bytes, which is m=
ore than a
> page. A single instruction can therefore move RSP off the current stack,
> across the one-page guard, and into an adjacent vmalloc allocation.
>
> Theoretically this matters because:
>
>   - The displacement is attacker-chosen (via the immediates) up to 0x100f=
f,
>     so the pivot can clear any guard narrower than that in one step.
>   - ENTER is reachable as a gadget, so a pivot of this size is available
>     without depending on register state at the hijack site.
>   - The pivot happens after the control transfer, so it is not constraine=
d
>     by forward-edge CFI (kCFI / FineIBT).
Please ignore this line; it is not related since we assume we already
have a CFH primitive. Sorry for the confusion.
>
> Taken together these make it a one-gadget-style pivot that generalizes
> across control-flow hijacks: because no register control is required at t=
he
> hijack site, any control-flow hijack able to reach a single ENTER gadget =
can
> move RSP into an adjacent vmalloc allocation. The net effect is that a si=
ngle
> guard page is not a reliable boundary between a pivoted RSP and the next
> mapped allocation on x86_64.
>
> Because this lifts a generic primitive across control-flow hijacks rather
> than easing one specific bug, we think the guard itself should be widened=
 so
> the boundary holds regardless of the originating hijack.
>
> We have a working proof-of-concept and are happy to share it privately wi=
th
> maintainers; we are keeping the offensive details off the public list.
>
> The fix
> =3D=3D=3D=3D=3D=3D=3D
>
> Widen the guard region from one page to the smallest whole-page span that
> exceeds the worst-case single-ENTER displacement: 0x11 pages (0x11000 byt=
es
> > 0x100ff). A pivot off the top of the stack then lands in unmapped guard
> memory and faults, instead of in mapped, attacker-controlled pages.
>
> This is scoped to x86_64 via a VMAP_GUARD_PAGES knob that defaults to one
> page (no change for any other architecture) and is overridden only under
> CONFIG_X86_64. The 0x100ff bound is a property of the ENTER opcode, which=
 is
> also a one-byte unintended gadget; other architectures have no equivalent
> single-instruction, immediate-controlled pivot reachable as an unaligned
> gadget, so they keep the one-page guard and pay no cost. VMAP_STACK is
> selected only on x86_64, so 32-bit x86 is excluded as well.
>
> Cost: the guard pages are never populated, so there is no extra physical
> memory and no extra page-table population beyond the larger virtual span =
--
> only virtual address space and vmap_area bookkeeping, negligible against =
the
> 64-bit vmalloc window. get_vm_area_size() is adjusted by the same amount =
so
> the usable size reported to callers is unchanged.
>
> Open question for maintainers
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
> On x86_64 this widens the guard for all guarded vmap areas, not only thre=
ad
> stacks. ret2enter targets the stack specifically, so a narrower alternati=
ve
> is to apply the wider guard only on the thread-stack allocation path via =
a
> dedicated VM_ flag. We kept it in the common path as defense in depth for=
 any
> vmalloc-adjacent pivot target, but are happy to scope it to stacks if you
> prefer.
>
> We would like to hear your feedback and suggestions.
>
> Thanks,
> Xiang
>

