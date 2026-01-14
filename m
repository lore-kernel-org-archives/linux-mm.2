Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AE2D38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B716B0089; Wed, 14 Jan 2026 12:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD176B009E; Wed, 14 Jan 2026 12:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7A66B009F; Wed, 14 Jan 2026 12:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B86CA6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:00:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60DB813B4D7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:00:19 +0000 (UTC)
X-FDA: 84331182558.22.FF0F0CC
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 523751C0012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:00:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FpvOdGlY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768410017; a=rsa-sha256;
	cv=pass;
	b=1b/eoLUN3WL4pZDI6TJs5xp2326ZC7gKhO8wfS226dcS4+FI1395v3nxuO570I0kIPRSK/
	xJNG3MjvLJVXXbWwjCDE7G40WeKkDYQUn6i8Sf8ckOlEd0zeKQ0fPkchSRye6a9rKBy94i
	Q4rEjZ0vXlQ3xGQBlv04E3vuh6mJMwA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FpvOdGlY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Itqn0cgqnumzBUE+aB9fi684t8xo7k7qc6WYDXYVqsA=;
	b=3OLFOtQ3+SIkOvfLk+uiCYQBtt49fZVdqB6E4Oas3c8KBDu/yApSddbpSjyUgOO37TeTXk
	gmF4mq2MJ/b+ClcTvCS/vb9uTJrc7mhIGp/gDKmyNVo84UxHKUJI9OiEZbSwx8nbWq3mIQ
	akgQUFBrNYSX39Vws0YAr13Sl3+GU2c=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso9658a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:00:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768410016; cv=none;
        d=google.com; s=arc-20240605;
        b=TBQNwyR0UaegFi7k0pHrQ4EUg48bvJO2Ltu0CG1Q9b6yX1d07uHzbXvP1IdTIdbZSM
         4BVXq/Eyg/7SWWdDB2JJgZxKqgeI6ldUkFiMVYY9+i1qyzdl9ZBXpboZUC508IMjnroM
         TW3ytEYrLBt7CNzVECIl9JpOMKuQMXpCCpzQc1Ee+086dnLvaBcw5rwQEEYO9uRQOxF5
         KBZyVwOGgJ1pHm8MXQHP1imp81HYG4Qvt+kP8B4DbJjJG/BJlUtAZo7t8SIdqle4QeY2
         3NvTk6/+g1500fGII+Q6Q8TjdlLeDeHhJ+TxsoZIVE9J4oBF+ME6n+bYiaCv+H0bkyL4
         p+Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Itqn0cgqnumzBUE+aB9fi684t8xo7k7qc6WYDXYVqsA=;
        fh=QEVKrLdpVon2aOL8tbDO6sLOpVeHAaiDOFC3Bl3BUno=;
        b=bkT+2xCMOLMWpn4slNHk4mKn3JdkfZb4X3rNTHnS8KMD26vRTvTYnL78X55ANHXaAF
         dHH87n45Cctu/Xalpix2/tGnt3ef0G8789qzF1w4dopbOoanz2rQVRBpqfyd9mMt2g6R
         zLFHgO36jZ+KivZ91VNl8DZ5cnPetvtLzZzpEXMCtKtdTNJp4ykwdsoIt1qvkIGYymgF
         bpNb6k44o9kPs9BnGmmlYMTAVu9aepayJXElgyK2ou5kuH3lVIEQyT9npJwynx8zt/sX
         zmhETnqbtbLJ0owoWsMISyDW1JcZOYzlPUimZmcjgsX/u87PXgXh3kAx1qc1YfUzNfM/
         pVZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768410016; x=1769014816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Itqn0cgqnumzBUE+aB9fi684t8xo7k7qc6WYDXYVqsA=;
        b=FpvOdGlYjZJvFMv+yDsq7p+CCSv/4dIg9YUkg/rsni3Gz3kIPyXX9GwDr535HvdVkt
         CLMtMis464chVCq9zqyUt+kuGMGimRGapSFerdxf9uc2tDq2Px4Mh5EzJD3sz+S+ragA
         7AWX4/h75MiFMs3yd8wt2D72/e7PttfdzG/iWhcY82SR1iAfOdK/ugaDmIqD09E0qXUX
         TxAN08tIrm8Lx7SKyfzBtTgi3krmuwmFdeXDfnH9buZurCadbY6kIvNrrG12uSROaWtw
         b2VtGrxTam/brNmMF7QHGmvXN+8JvrC3+JiYv2mnVBqpEHRHtSrgDWu2g8xJuqLx67RX
         KSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410016; x=1769014816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Itqn0cgqnumzBUE+aB9fi684t8xo7k7qc6WYDXYVqsA=;
        b=Tf59AFAbh1Cy2vdS/b3uoLYZHzHS1W5mj+v2X+MufveiozY/kAVGDnxDCderfJt/bf
         uHhvcLDg7CJktb99xxMouVVmaM2FA7QXp741BhKPptG7vHQ90olO1WpwX2l6O3WjlwzP
         jvNBGd99glbvUECNh8ufeWQYq8NazTlZU7EMtfEnbttS/3ShZLOeV5Aujkka52T7pRpL
         U4dHLZC/GuE/W6+CkXcCPpC93pLLmi89542LgubBXkhzGNJ0p9VnnCuNSFw5bpLY3APH
         w54CL2TTvdGURablP55DD9Csp4y9ETxCRIDKKk9OT7rN3yfnBOKfVwPBY4c7gbAgsC/r
         q+fQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/UwguP4JgSjnE+zLDWPjICFvUyT1U/p2m1XfXs8iiWK8x4oORweAURzZEmPQpdgDX+1If++Wnog==@kvack.org
X-Gm-Message-State: AOJu0Ywupgl1mcd9xEH44GqlAmvZjq/ba+mYPVoN0yPxR/Wo4wyeseSN
	fWW1zxdyOE9FKeMVz23uGJ7e51QYiLf7B4ochJpe6ua/PHZwrqoJhteX6t5zfpa/eJUyk8X6p3W
	pc+Qg0kuBiSfmaOTz10xqNZVbwlYSkSQafTnUVRNR
X-Gm-Gg: AY/fxX49mAcEwdxikGMZd/5Ug0yedxNm1XLtW2ymXW/6Ysvro1gxhYULAVFwOoxG5g8
	Xu1H2hCpI0ERtoi1n2q8gx0joFU+bWyeUkBVokjCcBNhkC0TR4IMXbfUua9czeXpUE9Vl2R5nYq
	XEKIjI4dTgL6x//Jr22YgJo6m/7w92vykGn1CWPrJoLuo9Ka00fQ3nimiAJmf76drUZGqGaXvqa
	nhGNnSJLXY8VzqXmT+BbhblgxC84HXm3ymrc5Hp+YcQxS91C3UzF32ZyVEN0iU2z84yr1QaZkf2
	96S6mZGK/aWMWia39Vqzc90WQQ==
X-Received: by 2002:a05:6402:713:b0:645:21c1:97df with SMTP id
 4fb4d7f45d1cf-653ebe0e2c3mr47396a12.16.1768410015391; Wed, 14 Jan 2026
 09:00:15 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
In-Reply-To: <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jan 2026 17:59:37 +0100
X-Gm-Features: AZwV_QhloNxzW9C1Kehm-DrZ0SBDjNSqoZSYt43KV2JsZwQIamKPe0EzZLleKtw
Message-ID: <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fwgbz3g3418demky5z56p9zwhr8yifsg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 523751C0012
X-Rspam-User: 
X-HE-Tag: 1768410017-34130
X-HE-Meta: U2FsdGVkX19TqTtT/aTnvvPKnbgtV0Rl1IXk6++7LvhvS7xkI9B6CTFTS12/jbcj/JHgCcyEDiRazAxV2ThzgvfeZURqbFaNyFEWYWDPYLhkCVcmR3dtjo5jkygaw0gM7Ux0vOykQ2hBOAADfWe0tYKEoLWZAxz9gWYQm619ndx/gr3Ln9Ldd7cF/M96dmWZ/AWFMDEMfwoscIuH30audLFHGB2zfc/do1OuyeegNgHxhO/nmgB6i1ajxSzoyVOP3140rYXBCJNk21/H6E7di9+cKWnLX93JUixTrZCpXbOCOetEwaeLg6+1/INGCBZYMM/Tgcf9NeUvnYlUqmJ3IWT/gX2nuLryUPKTQFo+9TVqEMJpmHb8YS8A87QjM+XMPsqm/tVj5lAR8o5rfJAYu/iFZq1D7p85S9hAyGgpqyu7543ZKedJak6ojnmcYKH2uhVDlM5YtB1QvjnCnaopRZVbhv1HNn+xJh3ocG5PicsbJjXHj+xQInxUeaXlMiQHbR0vhqmamzIRLReBpPAS/FvtwIWt2lZJOHVzEZsDW1IpRalf4JR9D2TrAv+RzaSOPsi9hN4kvca0ho4WO2L4My0VJVbHAtB0IfZTTJCaWSUSCE2bYJYf+iVJVJ15QFuevPgjfEJnFngvsvhPogviAcaodTiArb/BhjIpBi0QR5cHVL7hZnWuw7nqCnMVAsiuRyZNtFKEjJsfag/BkqvwgLIhLA7SYVEaZuc1u6MDyP9XY6gaJXGuW4po5iQDbzRFXcBggb/kIBbn8O1XhDZpxD9PHqvAyIoDhS2iLQ7sR26xng9IlOwVWGp4QZheOAZ/OppxXOa9G94GvEfjce2U1lMV7Sxvff0ARv6+1t4cCIMojSPY12TvgMP8ouJ8y+RuCPy+Cx+BCQX957LB8kNAFzKcKPs/6/2zlfkpjYx9Ee7ZrpY9V7dRBg09p5rnf8mCCX7yxunfaN0dhRSRUoh
 HN7qdBXd
 TgjFzYaNylz8bae9uQdvYnWe3FQ+e7Z2fAb8ZZ9UyAxwvfZsp1B7lBtjg/2SJqSAmqKSZEU+gRKk1ppokT0THRyz38HVZNPZj1ARD+bGv4Tuw7dZWhal5prs3TZ6CcAsOi3wI0XVNVe6V3n9Bmtly+dpPNfs0I9v2uwcJnVURsZbcaVR3Lm50jRD7V6rVYitvEFzJhHavNtZTWOgnc8/F8gSLe3HEdFCeJF92ghV7259vhaUpc3dBE7ThygYiKKwBvi30rIPyLOIwi4roTCeAU4gwxJqiGASbPTypraIFVGphAAH8R/49X1+1LIloc4xf4PFdfrleykNkdrzPsdGtQ0T6iUTAPk8j+SfySIskg4cI0U1iLMMpoKnuubzN7U1gBbqo+adyxURIP8E4pwA+IEAhpsd6k567ByTS3C4FvLDb3eQqjOqUH7ommVpoYuXuS9q5aa2PiZN9bz+2Hp6vE+3nbL32ceE6Avoy9WIXMC9IXTLKBRn3xseafVMHG5U5sKjGamIO7tfcjO8gYkAjMY+kG42O+DqPv/Wg5BTJiFXHyX5cTzQpvjwrUyU52I+3QP86RbBHOek7oqgleWMaKnshZojYXqpUcdtc+MfbYkJu8biXXnjdOzHfyJO55dbFpN3duee4t1X4l87Roj3vDWgDuO8Ij0Pyk8LGQYehQEMkhjz4jNKRGvuUaRRM29PgMdnJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyukov@google.com> =
wrote:
> On Wed, 14 Jan 2026 at 17:32, syzbot
> <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> >
> > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
[...]
> > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
[...]
> >
> > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W          =
 syzkaller #0 PREEMPT(voluntary)
> > Tainted: [W]=3DWARN
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/25/2025
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Hi Harry,
>
> I see you've been debugging:
> KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.com/=
T/
>
> Can that bug be caused by this data race?
> Below is an explanation by Gemini LLM as to why this race is harmful.
> Obviously take it with a grain of salt, but with my limited mm
> knowledge it does not look immediately wrong (re rmap invariant).
>
> However, now digging into details I see that this Lorenzo's patch
> also marked as fixing "KASAN: slab-use-after-free Read in
> folio_remove_rmap_ptes":
>
> mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767=
638272.git.lorenzo.stoakes@oracle.com/T/
>
> So perhaps the race is still benign (or points to another issue?)
>
> Here is what LLM said about the race:
> -----
>
> The bug report is actionable and points to a harmful data race in the Lin=
ux
> kernel's memory management subsystem, specifically in the handling of
> anonymous `hugetlb` mappings.

This data race is not specific to hugetlb at all, and it isn't caused
by any recent changes. It's a longstanding thing in core MM, but it's
pretty benign as far as I know.

Fundamentally, the field vma->anon_vma can be read while only holding
the mmap lock in read mode; and it can concurrently be changed from
NULL to non-NULL.

One scenario to cause such a data race is to create a new anonymous
VMA, then trigger two concurrent page faults inside this VMA. Assume a
configuration with VMA locking disabled for simplicity, so that both
faults happen under the mmap lock in read mode. This will lead to two
concurrent calls to __vmf_anon_prepare()
(https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
both threads only holding the mmap_lock in read mode.
__vmf_anon_prepare() is essentially this (from
https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
with VMA locking code removed):

vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
{
        struct vm_area_struct *vma =3D vmf->vma;
        vm_fault_t ret =3D 0;

        if (likely(vma->anon_vma))
                return 0;
        [...]
        if (__anon_vma_prepare(vma))
                ret =3D VM_FAULT_OOM;
        [...]
        return ret;
}

int __anon_vma_prepare(struct vm_area_struct *vma)
{
        struct mm_struct *mm =3D vma->vm_mm;
        struct anon_vma *anon_vma, *allocated;
        struct anon_vma_chain *avc;

        [...]

        [... allocate stuff ...]

        anon_vma_lock_write(anon_vma);
        /* page_table_lock to protect against threads */
        spin_lock(&mm->page_table_lock);
        if (likely(!vma->anon_vma)) {
                vma->anon_vma =3D anon_vma;
                [...]
        }
        spin_unlock(&mm->page_table_lock);
        anon_vma_unlock_write(anon_vma);

        [... cleanup ...]

        return 0;

        [... error handling ...]
}

So if one thread reaches the "vma->anon_vma =3D anon_vma" assignment
while the other thread is running the "if (likely(vma->anon_vma))"
check, you get a (AFAIK benign) data race.

