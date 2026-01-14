Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C439D38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C346B0089; Wed, 14 Jan 2026 12:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9F36B008A; Wed, 14 Jan 2026 12:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC776B008C; Wed, 14 Jan 2026 12:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7966B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:06:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E96E51BDB2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:06:02 +0000 (UTC)
X-FDA: 84331196964.07.160FF30
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC70C18000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:06:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Y4aQ+j2;
	spf=pass (imf06.hostedemail.com: domain of dvyukov@google.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768410361; a=rsa-sha256;
	cv=none;
	b=DCRfII/u7bJv0z3nBpducxM1UvvWd+kXEqY5p1Ek5ChrAutYOnmmcVYfsH1Xos5t1edjeD
	K/53ojcDA8Ii7Xm3YvlnR8/i3kMMOvTUDeH9qJih568AeYz2FtGTS2e+k7wFXLQUkm4E4x
	ISrTC0Z8kwHU5e0GZubrcac1UcB5P6o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Y4aQ+j2;
	spf=pass (imf06.hostedemail.com: domain of dvyukov@google.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dv5tjTUfiI4JlWSuhQK59vgicN+PdzE1nv2bTUvvvzw=;
	b=WRWl7ti5hv+zxurTCxZ+wbwdlcekk9Ccb18LJPY9hGo30T/fvYuWNRRXN0qDQ3Iv90akE6
	QAMG9W2oHGyxmFuCdSeKbDteK4tH8/+RplGv1BEMWmYvaVQtiU1r+eeOv+eRKQVWxrbgRH
	lM3I/RdHOlfIX88wOcK3KSfDDgVFNBg=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-382fd8aaa6eso31091fa.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768410359; x=1769015159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dv5tjTUfiI4JlWSuhQK59vgicN+PdzE1nv2bTUvvvzw=;
        b=1Y4aQ+j2wNVQUwsXFcDAnlP8qGgzTXm9F5Uh2cxeKuJfMCJ6dhVn4u16z77xJdE3XZ
         H4L1T8OhwAi3IiH7maBOxnV8epSjZ8V0n/Hxfz3cyHvQmyvVixdYMA2hERRXMPaVuupm
         h1nxPExak0BYGrvI1S62nmkZOuS+8NKWXBdFyT2Axw3arnFvz1RdXzLgEznOyGeVUbpu
         yWXveSXBUGUg7vbhRDhqSrPpM3bolIMXwhmcSGPZ5eJNVV5ITvuOoI9/4e1J7oR7KfWh
         ryLS3BSQjoDNkIEXItZMy9Vtj1woHrQ+sId3OACfPOX2Ru9bNVNYAe/Nc1CeCgaSUzPl
         0QVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410359; x=1769015159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dv5tjTUfiI4JlWSuhQK59vgicN+PdzE1nv2bTUvvvzw=;
        b=U7oVQMPNrBeKRfYass/wIAFrZPdpnVBCW1vKSrKQfUiGhfkyYVIgbAlXtuH7X4340y
         748eRVGI3CHYoQivVbXbz+Nl07b9Lv6EpK4uxF1eP2AgpW4VAq7uQYEn4A/qI41rGTVt
         S6buFg2XOw8kDn7i7sGMJoMduxtiD8EK7GoiZ8lUGZKMPQH2HplLcMV/kTk456+gcmQI
         eDrJyD6b/ftVXG8OjwFA4x8PHWpvAi0H/kBGHunob4uReOdYren5LRfG973/bUHPTpAI
         Ne9JWX5U1EUuDqaXJn/+fhNmTa7VPIEh+QDEPRlPVF3XeqagdAJjxS51Xsv1BclG4r+O
         459g==
X-Forwarded-Encrypted: i=1; AJvYcCVi5eRPOrillxhATYVAywfWXpZLMrQigc8BJy344pY8+oDtG6WRIpQGbwtwxa6h/tCDpr4P1qGwxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzai6VpEP7UZERjkkB9Owmd3dHJBms3els/cGPzZpGHA4kcC2AE
	AGiIiaMtf7kkWay7Ua4mqj9KYfJTw69GBVITCoM0G06FEEKp0zQbraa9+3kOt6DhNdN1LNH/K8W
	hxrxNW5Y9gkCTXTH5TSDPIRnxp/HBLLVI7rXOEZqE
X-Gm-Gg: AY/fxX6R5MDOiBMgp4KUwAGiJZqH90uE3yWO0t3dGPQq6qGqCfkOFff/jbQXiTevKgR
	T/A89WINUIfOTJu8X+hpcW8UkSUys2RwGFJLjKEs3xCFLPRNEhjgFo8FIcCgIU+GV52Jw9lKjfF
	fD573fiTzNIiQMh38K7smDHnvepMST8zZjcqYBVSUcaBw7JDHof7XkRZ8+fyC1JVtrP5vke4alJ
	WmgAdmPOXA18QPpBYjXAs+j7sUqToQCalqS0qYd0yfITA9o3N20BL71l4ldoqMZSVbCTzeAbVkt
	CG+Nf7VwHmpU+KnxZHTmegvapLXp
X-Received: by 2002:a2e:be06:0:b0:383:27b9:caae with SMTP id
 38308e7fff4ca-383606fba6fmr10870901fa.9.1768410358591; Wed, 14 Jan 2026
 09:05:58 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
In-Reply-To: <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 14 Jan 2026 18:05:45 +0100
X-Gm-Features: AZwV_QjOBRPvGB7Yf2IooLGf2o0OF1qO0XiTW2JS5vcU24zE6UxEOJXzBn4paQU
Message-ID: <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Jann Horn <jannh@google.com>
Cc: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9fjrjzsj9d8q9ep41igtoh8g5ahu3oyw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC70C18000B
X-Rspam-User: 
X-HE-Tag: 1768410360-566043
X-HE-Meta: U2FsdGVkX1/vQ0ukg5AuJeZwgFNndDzocY01gcQkbcvxqyhRARNe7UObrjmCNlOCDzakiFTv6tzJFaSMHWxLUU6D3/j79QVEFAMvZhsJdtaiwwIB8CIlgU553gRzmvkPPbmyTObrAAI+pjjLidyBl3ayWH51wtJVoj5Nsxqw7Jl7VlEj9QZJKIN8vg0IU8Re9RtdLqDpq1ASVFJCV7qbqpHYrR8jjuTosOWY1r9m2ngat9cPB/5LgX4qBbctEAzGyhCv+ot1ZLXoRJ0fZcu19Pavdcj845cxMAQAUvzExS3azYRRTuZODodUf9TWsR+1qOfxWP6gdqJ8pXWsS8exvYF49GZRhITsL+M/Z+0SkdomYMW44u0OpF2qVTxdxmteWqjrmrQ4FrdPcGcp/VnUTSat1YTjzgbnQ5jX/B9eR95Ev2jLsU4Sp8NkFENxFjT6j33z4kOfKGGTp2MjVQx7T7U+1CbWRFsB0N8I3tICqA2hknb5kr6BsqFop/QSFanqXSq5MKQYB/GE+6sAW/QJ3cLDy+N8aTRJvVM/hVLq/QAF/nRif96jP7h2CcZTrbGTHknVhrMkGTFSmHt/m5zx1kQZ1xcG7Ca3twHsKUnMJ7/spzsaF+O9Y98Yc3YA1FsJyQJHxED4ObLlxXVzNGgy0NB/X/YxCPcLeWk88mY9PFOd4bDKnxykzJ/l7tAEm79cj+0D3jfp3na8/5FJ4kjKVyuc7oWpe8CqoBUjkPpSf84DGtckDKO5SQ5TAqDafx7mpb7oR028FsuIhJjoI8mVjtxkhO6KwHX/rvYw3gCeaZc5WKAuU0tr24h9CyMiSgQknfw+5XDjgNCihqGSXd38VTvaKzHL+b5q1vwQ+lyv5N7RtCCjZ7coKplcbobC3djT0fb1uYFfkrbuu7ddUPN143mU6L88hvr4wrgaaIeouJiP0HbhTsyw2LjaQjKU8o3/+/kk3DBNn2hYEGckjyd
 M4HE6x9D
 7rskLXE3M3ge08PIJD6QRVi+B4YNg4w5IPRuvkHr5A0rm5OkzUeTSU7OLf06CtFLhh9LDYmigr5RzD64+852dKpTdyQikgZn2gIqlHZ/XQAXKi+nSwYg778vwcVF/CB5vN6uNWtDTFZWyszKS9cMCfRjlWl2MC5sh/nCWsvdyXJ4bhDUN52PvUUxC14x4GQeVZb+rgGfcnETXlaYjfQ5RnV3ISIOzT+B+eoYRn0AyCFbx22LqyCEXW7gA7jQ+3wqXFzvT1FlbPuacnlzWZTg3Se5S4GGTEuY0gOwv4GSWPsgoq3OxPnmXz/Y6f93BpC1jTSiTve7MoIRT2fguWA34zb3YXqhWa7UWcoiqZRp7exljvqFWOqXTe8Kd8KrMNXxQ00LeR3weLW0KAL3B+cKe5ptYIfFmevQD4nidLxZKARXvAaTLPpRlW/mhIK0davM8eySksqlxOACRsQnSvdFkxnl6ag22prnW0ZTuXb4reQcy+ZuEwfVUBd4v/vJPy+IRtnHgOyoqkr8Fi0dIfL6p2qGBKyEIkeS3L4vs2zZ76UGd2jWj+oKi0K2e8pTc9/gD1rg1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
>
> On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyukov@google.com=
> wrote:
> > On Wed, 14 Jan 2026 at 17:32, syzbot
> > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> > >
> > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> [...]
> > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> [...]
> > >
> > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > >
> > > Reported by Kernel Concurrency Sanitizer on:
> > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W        =
   syzkaller #0 PREEMPT(voluntary)
> > > Tainted: [W]=3DWARN
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 10/25/2025
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Hi Harry,
> >
> > I see you've been debugging:
> > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.co=
m/T/
> >
> > Can that bug be caused by this data race?
> > Below is an explanation by Gemini LLM as to why this race is harmful.
> > Obviously take it with a grain of salt, but with my limited mm
> > knowledge it does not look immediately wrong (re rmap invariant).
> >
> > However, now digging into details I see that this Lorenzo's patch
> > also marked as fixing "KASAN: slab-use-after-free Read in
> > folio_remove_rmap_ptes":
> >
> > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.17=
67638272.git.lorenzo.stoakes@oracle.com/T/
> >
> > So perhaps the race is still benign (or points to another issue?)
> >
> > Here is what LLM said about the race:
> > -----
> >
> > The bug report is actionable and points to a harmful data race in the L=
inux
> > kernel's memory management subsystem, specifically in the handling of
> > anonymous `hugetlb` mappings.
>
> This data race is not specific to hugetlb at all, and it isn't caused
> by any recent changes. It's a longstanding thing in core MM, but it's
> pretty benign as far as I know.
>
> Fundamentally, the field vma->anon_vma can be read while only holding
> the mmap lock in read mode; and it can concurrently be changed from
> NULL to non-NULL.
>
> One scenario to cause such a data race is to create a new anonymous
> VMA, then trigger two concurrent page faults inside this VMA. Assume a
> configuration with VMA locking disabled for simplicity, so that both
> faults happen under the mmap lock in read mode. This will lead to two
> concurrent calls to __vmf_anon_prepare()
> (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
> both threads only holding the mmap_lock in read mode.
> __vmf_anon_prepare() is essentially this (from
> https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
> with VMA locking code removed):
>
> vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> {
>         struct vm_area_struct *vma =3D vmf->vma;
>         vm_fault_t ret =3D 0;
>
>         if (likely(vma->anon_vma))
>                 return 0;
>         [...]
>         if (__anon_vma_prepare(vma))
>                 ret =3D VM_FAULT_OOM;
>         [...]
>         return ret;
> }
>
> int __anon_vma_prepare(struct vm_area_struct *vma)
> {
>         struct mm_struct *mm =3D vma->vm_mm;
>         struct anon_vma *anon_vma, *allocated;
>         struct anon_vma_chain *avc;
>
>         [...]
>
>         [... allocate stuff ...]
>
>         anon_vma_lock_write(anon_vma);
>         /* page_table_lock to protect against threads */
>         spin_lock(&mm->page_table_lock);
>         if (likely(!vma->anon_vma)) {
>                 vma->anon_vma =3D anon_vma;
>                 [...]
>         }
>         spin_unlock(&mm->page_table_lock);
>         anon_vma_unlock_write(anon_vma);
>
>         [... cleanup ...]
>
>         return 0;
>
>         [... error handling ...]
> }
>
> So if one thread reaches the "vma->anon_vma =3D anon_vma" assignment
> while the other thread is running the "if (likely(vma->anon_vma))"
> check, you get a (AFAIK benign) data race.

Thanks for checking, Jann.

To double check"

"vma->anon_vma =3D anon_vma" is done w/o store-release, so the lockless
readers can't read anon_vma contents, is it correct? So none of them
really reading anon_vma, right?

Also, anon_vma_chain_link and num_active_vmas++ indeed happen after
assignment to anon_vma:

    /* page_table_lock to protect against threads */
    spin_lock(&mm->page_table_lock);
    if (likely(!vma->anon_vma)) {
        vma->anon_vma =3D anon_vma;
        anon_vma_chain_link(vma, avc, anon_vma);
        anon_vma->num_active_vmas++;
        allocated =3D NULL;
        avc =3D NULL;
    }
    spin_unlock(&mm->page_table_lock);

So the lockless readers that observe anon_vma!=3DNULL won't rely on
these invariants, right?

