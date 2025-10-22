Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2FCCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3848E0003; Wed, 22 Oct 2025 05:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053928E0002; Wed, 22 Oct 2025 05:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85A58E0003; Wed, 22 Oct 2025 05:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D53088E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:18:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41E2C140761
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:18:10 +0000 (UTC)
X-FDA: 84025198740.04.0C3C7D7
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6605440004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:18:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMfvh+GQ;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761124688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhkH+62s9AhGNEt/gcdilWodKjE5uLzcv1BGhnCuNyc=;
	b=I2K9atCNR/f6h4CVuxS6IxZIriwzdsBLx3/URqAavc4K9QXxMOIAMuJZqJIzxVgf1UfDHI
	NMTPsFrA0DDs82t1yBlrdwE3cH11ZV/OhN5hopOVWd4IHBOk3N4toWo3rQpbR+DAPN/vOr
	Y2/L6oC9emXf3xntVbYc2GiubYu28eI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMfvh+GQ;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761124688; a=rsa-sha256;
	cv=none;
	b=etPiwSvjg/FcUdLdUCl1rY3MQRsTR3S6WeUCc75OtQK46VZFvFsnbVtWH9T6HmTxh+wM/z
	y38fvNGOBBAkwD7PPvJdPooS3LhZxsRyslv054WW2jyaWbE7sw2qjP8NeM2aBrUV17xvK4
	Ny18sP3f6rCdQexMwtCjvlYoCUQfMbI=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-890deb84f95so720782285a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761124687; x=1761729487; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhkH+62s9AhGNEt/gcdilWodKjE5uLzcv1BGhnCuNyc=;
        b=UMfvh+GQVidNGVsW+3YjpW6m6TJAAKRSSXGRa7iCQGmcb3aIW35rTMMkfbzpyuxOha
         1sxW70RiCXw8nJb0p90zeJzGgEqqNUue+oGvTT0d1J8SpTW3M3oSidjIGu+nkXfb21rM
         +adPYnveVhiCwQMy2J4QrC9wG7/f+DtQowK0uqi3jEQR2txVtw3RE5vxIOlhLU5GXzeD
         lhoJmqtBbnzk/g2ZcZ4WO7xtBIm6gdl6WRTnBmJtjLd1BWW7voZnH57M3xFwvy5+NK4u
         LrXgl/5KNdzTsTXsDBbwPF9Y9VbLA708NRxdpXquFNnXPnJdKZqwD89k9qRaShdJ3Ll4
         TpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761124687; x=1761729487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhkH+62s9AhGNEt/gcdilWodKjE5uLzcv1BGhnCuNyc=;
        b=GdYCM4HkfzPJUK73TrYkjbDaHdEc68yX/mvHzcSbIOI1+bHZOOKMbi4M65TLjbAOU6
         0jC2sj6J+72D7ueBe8Xh/Ce1V9M1XMwdVmR42lFqVh7lZK8aiXJ66REp7GVRxds+JyOV
         LQg9lipe9cjDYXw+14Zaf4LOf9C+GvTdJtoJ2WBajsAF04Px6fFYsJestc3jhqkvxdFs
         gzJUqsxnbB9ChOO6x0HupRMR0lrN6qFTstXj2FAuL5+bnDXhZoJgyki+kg2RKnjy2hxE
         bE8+i/BzpP/OFiqXgQ1HFOctxaglNOr8IZYoi7sBC30d63dTb8ARfDjVFhjgWzQx7zcD
         Anjg==
X-Forwarded-Encrypted: i=1; AJvYcCUffpARz8kKTp4Ss1kvRoGh3OcsZD7BgWg3YCTjNJIHgzqZsXIGkeWFiu+lcCG7T1VZNUSh7oPMXg==@kvack.org
X-Gm-Message-State: AOJu0Yz9PZivsvZq1j/lh/o4H6WGfzbkJa29IaUUR1o3xnqYdjMxL50z
	heM4V5AWEQhJB8n5uQeZcgwKSDQ8FYbX9twR78C5yakIS2I6SRk9bBIjfk1uvR1nhbqwD/2IZBZ
	eiPwYEbc2kFX1Az+MA4YxfQJtuYmIxJo=
X-Gm-Gg: ASbGncurKRvWoR9mNBG74GrRoy/ELnKjmLfSOlBogft7NWOpk9bsnfpnpXzqVZ5bezi
	Pl9OJzAc6oiJGCDq/QlnYRPp+LqvB7hlneYdCEGsHEkEMERE03Ycw4ELK4FCo5qBW/1NQx7WmmZ
	apAgn710Kfrs7XTW44R/+PgnSpltDbEco60dVeGfGdp73TrxdVXKZl8aOpevuo3QmQr7jBeulE0
	SBsKpOaXW+fdm+wLaLohbOL1uUwRz3T42SYzve7k0QnlQm/rY3j63Q1xnI2IceUwBx+eyG+5E7j
	0qnfKwAmXWeYBRho
X-Google-Smtp-Source: AGHT+IF8ppZ20Wu/vkfm6iPYBWUkrNxb51/1c5/VT0XmJ/5FqE678G9roI4AMEu38Z7ygSJiTsaYJgwfrr18a9ZMw5I=
X-Received: by 2002:a05:620a:4710:b0:892:501a:290 with SMTP id
 af79cd13be357-892501a057amr1576601285a.86.1761124687335; Wed, 22 Oct 2025
 02:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <871pmv9unr.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 22:17:56 +1300
X-Gm-Features: AS18NWD3ObRkO5HEsMcrxUcjKoB8vtoXwTiGu2WDg5GLSA8-uJXsohVYB76Ay-4
Message-ID: <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6605440004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: byopaojy5yb8pccraxtcbqrjz8fpc91o
X-HE-Tag: 1761124688-822766
X-HE-Meta: U2FsdGVkX18vQYfArcpwubGQ6EC/9q1m36nKiw4Q2+mXIwAOUAY8D4XmAmXpZgb1djjQCuel5MibFFuImQCrxJDYRLGoY9xPYFxBRHNb3SHju5gPWOlMCJ+tlrJXukIBdeNWK7Wbf/ir4As0WvnxqGvbQD88zUh0lQzE7IhFYwTAu+koOqS1ETUiD3HPR594c9RRv3NSvQiw4sf1PqarXPqsNzTHh0Hmt0a4WMrvsu161orzkoQj1ibXw2OtfQJ2vm4zZPqPuAkIdy3dhdTPkW1gzUziRS0bHMTZpGQEZ8LRV/gkqF3PpVth/49BBW7OQoLaRuV/Ktz6N0mXwohZLto/X9KhYNIuDdozVYcyKbtVktXRbBlyJ7/sUTCONxCjREnkbowQ5O4KQUSsr6bLoFzLl4AyHeN7Utl7lGK2gioAVkB+5I8kjqqhKn5UpzISEeptaDLMxA65WXT3HTP/ff/CjCCU/QiBx7KfewK8TLan1y6J+gKrmKzpa7ZvuiBjaMzY3Zg934e2dd+M0dL4evvSUXW1urcy4/5nLTPFuElOFOBR5pM2NorWw6zu4bg2QiYWw7mZiayvDslVheMzeidHHu28vdoH/pP/TbBuQj4SXDJk/v1YKIgURtLPyoWpIxf2sMDQtMiHNOvse5Nx9xlrMXxyCt1MKLG33fm5n9HhgRZd8SprVDl1R+z5d6Gmt3ZibGrE0q/XCPXufyTEH8A0V5NV0YP0vl9kcIbIN71K9Bpq2JKi6i1OHFCfjeRQ3tL3p+GXZIelx/hw2KgqK1SI3ULf8YEucVH5CxL+Z0ve+3IOFcywxY1NbwUdHLQ9UGV/0VOtdxtJwND2cu7cnFEsVSzhA2i9iJQI2tQKA8N3UEjkZFIVw7h2twVWMgspXndmLLnNF4DEpfcDxu/BJ+2eBSTAJqCJFZ6e49Vi8PWXmwr5JQbF6N9wOAoOSxUZu92BJc33XdNebJIzx0N
 11OTbgPX
 IsvWgQVbhf27zDeR80O3dSb/iNLDqi4XUREG0ZtbHr3vjzVedsxjZjspeaYM22hMExQLJjMJ3R5m/3kJqL4m4JKpQlNDjbNo7to8zQXxkuLDE8rtEKpjmFjDNPMDZGmEZljBR1JNZE5RgXDxV3ICsWY2kZUYRhR9rkppDCchflyBHljkyAiwsGXGK3YLtnK6E8O6BbtVfnNKnRuge1YWY4GX2TrUzB0e8vFcmQqmGkkynMZFLnP5/bK4vmKpD3KVebnYoK2ao+mRTrZYffdlyA9fjWieaPkqRKodcMN2vessDSiXSet5hqFnBgrdmLtUwz7+Del60XaCK8EKmNvOIW6J64XWnrpiy30gNBYthp+rphmZcMQ+baZ4fC5UjTEot8qZTvj6iev2ghCC6a7V1/SQPdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 10:02=E2=80=AFPM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:
>
> Barry Song <21cnbao@gmail.com> writes:
>
> >> >
> >> > static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
> >> >                                            unsigned long uaddr)
> >> > {
> >> >         unsigned long addr;
> >> >
> >> >         dsb(ishst);
> >> >         addr =3D __TLBI_VADDR(uaddr, ASID(mm));
> >> >         __tlbi(vale1is, addr);
> >> >         __tlbi_user(vale1is, addr);
> >> >         mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE=
_MASK,
> >> >                                                 (uaddr & PAGE_MASK) =
+
> >> > PAGE_SIZE);
> >> > }
> >>
> >> IIUC, _nosync() here means doesn't synchronize with the following code=
.
> >> It still synchronizes with the previous code, mainly the page table
> >> changing.  And, Yes.  There may be room to improve this.
> >>
> >> > On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem to=
 use
> >> > set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are vis=
ible to all
> >> > cores. If a remote CPU later encounters a page fault and performs a =
TLB
> >> > invalidation, will it still see a stable PTE?
> >>
> >> I don't think so.  We just flush local TLB in local_flush_tlb_page()
> >> family functions.  So, we only needs to guarantee the page table chang=
es
> >> are available for the local page table walking.  If a page fault occur=
s
> >> on a remote CPU, we will call local_flush_tlb_page() on the remote CPU=
.
> >>
> >
> > My concern is that:
> >
> > We don=E2=80=99t have a dsb(ish) to ensure the PTE page table is visibl=
e to remote
> > CPUs, since you=E2=80=99re using dsb(nsh). So even if a remote CPU perf=
orms
> > local_flush_tlb_page(), the memory may not be synchronized yet, and it =
could
> > still see the old PTE.
>
> So, do you think that after the load/store unit of the remote CPU have
> seen the new PTE, the page table walker could still see the old PTE?  I

Without a barrier in the ish domain, remote CPUs=E2=80=99 load/store units =
may not
see the new PTE written by the first CPU performing the reuse.

That=E2=80=99s why we need a barrier in the ish domain to ensure the PTE is
actually visible across the SMP domain. A store instruction doesn=E2=80=99t=
 guarantee
that the data is immediately visible to other CPUs =E2=80=94 at least not f=
or load
instructions.

Though, I=E2=80=99m not entirely sure about the page table walker case.

> doubt it.  Even if so, the worse case is one extra spurious page fault?
> If the possibility of the worst case is low enough, that should be OK.

CPU0:                    CPU1:

write pte;

do local tlbi;

                                       page fault;
                                       do local tlbi; -> still old PTE

pte visible to CPU1

>
> Additionally, the page table lock is held when writing PTE on this CPU
> and re-reading PTE on the remote CPU.  That provides some memory order
> guarantee too.

Right, the PTL might take care of it automatically.

Thanks
Barry

