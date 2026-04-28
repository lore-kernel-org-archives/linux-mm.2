Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76804FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 04:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AFAD6B0088; Tue, 28 Apr 2026 00:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FF46B008A; Tue, 28 Apr 2026 00:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675D36B008C; Tue, 28 Apr 2026 00:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 554396B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:25:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2059402C0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:25:09 +0000 (UTC)
X-FDA: 84706674738.22.7F459BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B79694000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:25:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+6pT6om;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777350307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUCTbNwUZ9GHObfHhdooXVBij6FjdWB/a/8uLBz2CUY=;
	b=1qSRaUhrhLzBtV6UwYzd8RWBVnvkf9G9MNnOgRs6iLCLS0o+/QF69LgU6EmNHcmfy8vzOD
	JgRYBWndONHMTX515krBcloOiorHv/kpRUpfpI5DPAiGSlBGqVHT724tyqISRVJZS6iNeO
	RmHLb7Il7LLzmSZoFRugaKFyeqV7NOg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+6pT6om;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777350307; a=rsa-sha256;
	cv=none;
	b=lbvnxK9LKG3sR8DQ67WzZHWx4rf6g4LSoE6iiFBOn+cFuYGbBRNeXtE/2jFRizBhbkTJWm
	BwKVDHocXPn/+hfY4AH4lHJWWkFuGY6mKY39vJS8IZ8PxSy7j5GSxFVba5ABebiJEe/vZJ
	cDAuaxtIDfM2UEwi+yfpdhx7Dznahgo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AE0A4381E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BDFC2BCB3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777350306;
	bh=hppCw2rvush86fXRd7YnBCE758CSe4O+k+/Xke+pojY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=e+6pT6omnU9vi7eiW5h/DB5WI76kY6WhQj/gZs73KUD5K35N59J7b7PhvvnV6jLuS
	 v+U6z4LgUOhhS3f7HnERxVDDwWEZZI9kJMhVCjI/dTkOOnE6W5AGnHUk5UNvx93kR4
	 aLudXZxSyJLjvMdHxBijlofswtVt61n8l21s+AHumpzegVqFIwLGa/8ldtTERgApgB
	 SlmaVnIbJZ8FcUWUVZqDESijKffNLvdWyfZytR96uiDAQAA/EDCGW8wynS5CJjZ5YF
	 ODmTzVd0sOwxo/izQgW+w7pHgrajFl7BDpK/tJ5M7umBaQZQ72Mw+tFcPqJYZfFrQW
	 wLENTrL54OO0w==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8ee62a19730so665592485a.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:25:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ZhWBpdwA53yCofZ46CxsoRbRm3WoDKaBSVhmjR3LbGu4p/ZTqIbD3B8N76B2RO7Kho6hj/dJCVg==@kvack.org
X-Gm-Message-State: AOJu0YxMOf0WzCyRHl7jYFNZVmNmUKa3OuMl8EonC4d0WiH+NrrhbQkP
	846bSE1P432e++PhTXPkPFmbXj1d5Q+/43/jDxO32J99TvzTb/TIorxtR8yCcM6UTgWpuluLvKU
	AMYN6Kq78HJWyGupUcNYPBQbbpebTzSE=
X-Received: by 2002:a05:6214:4588:b0:8ae:652b:e3ab with SMTP id
 6a1803df08f44-8b3e31cbe69mr26493796d6.51.1777350305631; Mon, 27 Apr 2026
 21:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
 <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com> <ae91A9US6ybEzqM2@pedro-suse>
In-Reply-To: <ae91A9US6ybEzqM2@pedro-suse>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Apr 2026 12:24:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xP9ZOxqr7-Dj8A6Ec_Ud0rbhkK7NhC2cKQo9p=hUqzhw@mail.gmail.com>
X-Gm-Features: AVHnY4I3BgP6xE-NWgyXh-qQEKvWjkrlxr6kQdEPVJ_gaQfKYoGQ7NaVbYLFEgY
Message-ID: <CAGsJ_4xP9ZOxqr7-Dj8A6Ec_Ud0rbhkK7NhC2cKQo9p=hUqzhw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B79694000A
X-Rspamd-Server: rspam06
X-Stat-Signature: mmp16zs9ukwkd3dxzn64t9siaj35pmey
X-HE-Tag: 1777350307-593858
X-HE-Meta: U2FsdGVkX19JcQbPIs/HjLy7qNstLVLxaErkUTunYdQ/AOrBwyh14tg/38o8LBYT75e/ZB/pkr79jCQCND3xL1L2Fyblq9xxXJtVuMPaF6ijuNKozMlJCFVRYZ1J1TyxNsf3jhHWAmW22USvolOk0XJUIaMlob6LscEAAQjkatSCS5zFVZvEGsrmHzbOdeo4x6M307A/Irv7V6bFrA8iHoQvBkJ70FM95JtkBGt3S0hl5grWohtdTFLQqdVj29CPouJGFZktHWB00tkqBUPjPaXfdbWfNt2TUpPiWhyRUZQFYuKt+f7vBx+UwbFuoUVJPm9lnQGCdiWE4mS3Q7RApNZ7icJTD0zC7R6NF8YXXwo1/kb8nQ+tQWaVPeoF3eIUmI6iVScgEpsvPSs4x1josgRj9z7zfj3HOE99qucjl8yMnj0WJDAdE9S7SgAbr5OEKc/RefZOIpbvbXm1HoWQzHLz+u4pvw+ZLe7I9YOjJBVV7QkLc9pYinHBQflrIqOP11pIN3ml15Ryb4hrB9drYkdqR6EMtcDdeLi8ptFK60ApHqU2mkyLsGmKGpM9/1Pyt+p9Wlk61dg0fWos+2TXSGNdZgEXrFhHxR0ZAkML6D5ByUmbAzbz6IyDtMiWFrsaXEw3NCGBjic3TaamY2fvKLU/aEmborNvPKh5UVM3UfhCwkDFR9DdecuP855FemBLxZmtQh0aCDbN0dG40C9d2L0gN4yVKCn0CrI1srRnt1oldwSQf6vc99EvUVZq7sk2N9jBx613byeXz25EhJhqfiVpET7xNWt0CLwJgO7YjzYv6RrkhSjgN1d4F6kZ/5vOzn7kR/iuvcCEDOaXHO98XNeZbsczDAGikQodbs4vqvAuLIwUdadcuVp8QWeF43RW1LnXcpWZy2MgfWeCDYeDFbs+7m1ahzz32Fwd+ang8a7+lO23YzdaQIQwCnX7c8okMcG4qmkSy+aK72GequT
 IREeCVE2
 mJzV7VMxJm8/F72YBnhZH/DJz11tRoqfDBo+HXyTJdN2BxfYHh+izlRhf1PfZm84hkZEIo+TBdrn63fd7GmgB2Z/APisqzIN0YfTEE5KVzdvYP3aVg9mO8wqWos7vRcmv1eCUAAaku/3XLqkys3HQC0rDE8RrQo+NlZxdpfHgZCubROVhFZwkewPy98HPdUe0Po3IjLauS4vKI9b5lTeY35JhacXyTBsWr8TyhEVsR8ZOaRQ8+tTfdMUPdFX+5qb4J0Eg261ktK6sbYxEX2TAdIAYeGlOkQP+LlpUp5Awr9yu5WSSNRreb/dwtBjQq4G1/NE2GekXg8U1L68v6U237rFy0wRxkp4mIK0cWRWW9S8PmjmO1MJIcROvFTFEvGsCEkVgsOHLgYL93EaFmM1J0Y0xAc9gp67C/zUwuBsEmkEMhxz5R0VaGNxjh31dP7zKOGdV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:46=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> On Sun, Apr 26, 2026 at 12:35:46PM +0800, Barry Song wrote:
> > On Fri, Apr 24, 2026 at 11:19=E2=80=AFPM Pedro Falcato <pfalcato@suse.d=
e> wrote:
> > >
> > > On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> > > > MGLRU gives high priority to folios mapped in page tables.
> > > > As a result, folio_set_active() is invoked for all folios
> > > > read during page faults. In practice, however, readahead
> > > > can bring in many folios that are never accessed via page
> > > > tables.
> > > >
> > > > A previous attempt by Lei Liu proposed introducing a separate
> > > > LRU for readahead[1] to make readahead pages easier to reclaim,
> > > > but that approach is likely over-engineered.
> > >
> > > Why does this even need to be kept? I'm not sure it makes sense
> > > to even mark readahead folios as referenced.
> > >
> > > I'd suggest folios should only be marked referenced (or even active, =
whatever)
> > > when they're mapped. Anything else is a bit random and is hoping you =
are
> > > eventually going to map them in the future (which is not true for, fo=
r example,
> > > anything in an ELF file that may be readahead but not mapped, like de=
bug info,
> > > symbol tables, section headers, relocation tables, etc etc)
> >
> > The patch targets the mmap readahead path rather than the syscall
> > readahead path.
>
> Yes.
>
> >
> > With lru_gen_in_fault() in place, it=E2=80=99s roughly equivalent to
> > the mapped case, since readahead is typically 128 KB while
> > fault_around is 64 KB in PF.
>
> I'm not sure I understand. How is 128KB roughly equivalent to 64KB?
> That's almost a 2x difference!

For two reasons. First, we have moved those folios out of
active generations, so they no longer significantly occupy
active space in MGLRU. In any case, they require a real PTE
reference to be promoted in folio_check_references():

        if (lru_gen_enabled() && !lru_gen_switching()) {
                if (!referenced_ptes)
                        return FOLIOREF_RECLAIM;

                return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE :
FOLIOREF_KEEP;
        }


Second, 64KB is effectively similar to 128KB when two
subpages within each 64KB are used by fault_around /
map_pages.

Of course, we could move the setting into multiple map
functions, but given such a small gap, I do not think it is
worth the added complexity.

>
> And readahead, as of now, will read beyond the VMA's limits (which will n=
ot
> be mapped).

Folios beyond the VMA limits will not be promoted in MGLRU.
But yes, I like the idea we don't readahead beyond vma limits:

https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/

>
> Really, it's extremely unclear why this adhoc heuristic is here. A folio =
isn't
> active just because you started readahead for it inside a page fault. It'=
s not
> even necessarily active just because it's mapped (although that is more
> understandable).

Right. And with fault_around enabled, I don=E2=80=99t think it is
correct to set the folio active when it is mapped.

>
> And of course, because the whole ordeal is already extremely simple, it t=
urns
> out that in_lru_fault doesn't actually mean "we're inside a page fault" b=
ut
> "we're inside a page fault and this VMA/file don't have any sequential/ra=
ndom
> annotations".
>
> I would really like to understand why this is here (and this is true for =
the
> various odd heuristics mglru uses) if we ever want to have a chance to me=
rge
> the two LRUs together.

I=E2=80=99m probably not the right person to answer this question, as I=E2=
=80=99m
sending this patch to change it :-)

It might make sense to promote PF folios directly if there is no
readahead or fault_around.

Thanks
Barry

