Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E223CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACAB8E0009; Wed, 12 Nov 2025 05:42:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84A48E0002; Wed, 12 Nov 2025 05:42:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1538E0009; Wed, 12 Nov 2025 05:42:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBE2C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:42:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76E734CA06
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:59 +0000 (UTC)
X-FDA: 84101617278.20.DAAD657
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B781240007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nv/j9nxi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762944177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGaFCN5CKgxuaG6z+iLvH2r3cN59Hy2iR0HpF/xgCDI=;
	b=ZSh2HECVujjmPFX7J1RnM6MVUEeLlwcex7CLMNIwHgDZZ0NnEtVr21PnldJrYAddOOx+18
	3OqyGOYUmDWerPB36elw/5JSnHa9s9ms7BH8Jm4vdltZBTK03BiEKRe7eWFqkb9O3mryXb
	ym0halUPO19ldX/qNk5Ukr+EBW7Ynxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762944177; a=rsa-sha256;
	cv=none;
	b=axEtoyusp1F0NX+6B8iEBuIcl0z/Hc59Z1FjHGpimHVzHyMQ6WUsjSVtDCZRCTXwZmMGaj
	umAAE2lqoWXAN99AOdbDOxUCgsHuf0wAHdagJkEHZ6YVYH9fP6elw5kgXWEkwm0YkfcJ4m
	yhODZs1zGOUU8C+A8hz9HDI7QDTb+kw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nv/j9nxi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BE960224
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB8FC116B1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762944176;
	bh=yd524j2UYdF9T60dZKoUWbXfiU/+4GqqehDLlNYZFPQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nv/j9nxiepBqtVQU8PK3bUIFsPYEb9kXlebOfV8SEtbg96Lpxb1gK5sI80MAYGaub
	 moDxcoLxZH1q2BvPcTPyr5XLwe3KSmDmLjtiKRYXFGZiw/CYrWJFbvngwJRUUzGLAA
	 9s8+xOZdHeOShR0y/1BKdDAuIm0c6ESTgFXnOM3/Lqu6nMvja67LtVc48sV3CjcnXT
	 O/4hs4fo3sgK9YkY00Qyu8x9Mdb4z7FxmSso8ro5o75o9LDy5DtmZ4nYNM45BbSAJq
	 Qm44CO9X0KmtX9/IoJZMYsAhnFXz0WFjT7eeCAqhi2MRb0ZwsOCEKxgSB9n+SAmuB2
	 J6yTWlWqf4tJg==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-63f95dc176fso615201d50.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:42:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXOccunq3W938wK5ahKR+BeEy+SH9vHoxB8AdlKlyMIr41Bol5zUPQOhvwKYFp3PEhKgTddS3rdpA==@kvack.org
X-Gm-Message-State: AOJu0YywQxOcyl73ooFvF16zHADokof3Xd+8xrY0OwzWDiY/FpHT/Efv
	NE2jCn29R5i1sb6gVol3F6Ed/IXinY/a9XOk7yGn8qiHoR9PzFQ7eVIrU1Gv5On1URfIQyVzkhv
	oVb4317r2t3igU+pAhxDWasH7D5iLuceIVN9JK9gJpA==
X-Google-Smtp-Source: AGHT+IGpzC31MKqwjg37OYzkgE4JfNhCv8x/koPXoGpSYX9bTIBUawoA0Cj3921m0wicSy1w8LKVD7CXORcIJ008s+A=
X-Received: by 2002:a05:690e:d4a:b0:63f:b9fc:c65d with SMTP id
 956f58d0204a3-64101a34891mr2438331d50.12.1762944176056; Wed, 12 Nov 2025
 02:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com> <87ldkchv4r.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87ldkchv4r.fsf@DESKTOP-5N7EMDA>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 12 Nov 2025 02:42:45 -0800
X-Gmail-Original-Message-ID: <CACePvbW+WT2obgoKs_ZPoMqnyCzO=_ir4uKX6xxY+rk_+=Zrcw@mail.gmail.com>
X-Gm-Features: AWmQ_bm5A-7V0WTqXR0dV28f2BzUEkhRXXIItSKog2jneau9hBijp83WKJIbfs0
Message-ID: <CACePvbW+WT2obgoKs_ZPoMqnyCzO=_ir4uKX6xxY+rk_+=Zrcw@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6knkteyyi4nht631jzwp95n78ca1ypcf
X-Rspam-User: 
X-Rspamd-Queue-Id: B781240007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762944177-400505
X-HE-Meta: U2FsdGVkX19AwWnDC2N0mX4qZV9KaNty4iLFtEjlGs58baJu14ZvxdDaO4/YxBMOJRzBX6kpuUopSdR7LuKearR5+BBsKCCAE/vVNLNwSJPYav528ixUgxFmzDjrjKVl0xE8cBWsTwTQz3J5LfAlkPJ1B9wwNda/DhgergPIihTu5BN8nENV0dI2DR2K0wEL7hyNGegpa48Ln7Tw3S6icsV+/rq0aYpzzY0raAEYUq6cIE7fVlsmjWypll5TGijwKBzZwx6LE/dyTfE1vVmSQt7Vq2IdjOZnjBtGtrTsKueN/ekPTraFBTsHd417hNvAoI2iT/YUJN84c/LSGg3pWuwqeUkGctGCQamD3qZI1SB7VbONO0VTah+0Zd7hcLJ0dlmnmBPgiKEWXzrgA0FTwATRKfc2WlaWIyWvTEAwIQeaowXko1pnCBlDhTjlSrbSqTezgIzAmbcXOa6JqoszQhTD0Rws9+5jwY2Ze549VVr66k7OAmbtFka3iqiEwjjXWdOcAUdnYKixk3OxIaHi1zaX1QS7fKrLsfWBP5KV473Xt8oL8apfhxUYvi6rRG5GZRwqPegqNi+zLCNw8nLMigQ0aHNmAFUQok8vTBng/VAwDQwXkLztAuOJoCD9htuinQh5iYmD8c/0zmEk+nZlY232FMYMQTMMTbuMV4QxFWqnw2LG53rbafgSx8dgp0gSE9TcywZWyO3G1V0mgOGkMXI1UMZYC0iM5vveE0GEEizqyeDe0D8ZcEp88ki3lA58h7ypSIfkabOtXFgyrYPUG+TvnpofHRJC0mD3cqJU0ROqJkp8iNqWcaVxUvQZcqFBADqvwGh6ApaZzKULsB+ZENHNPEiyzNkanALxJExFkAUBFccPGr0sNJmxSyYVFeH9NeRQBRVtKR0DVngJC+y+KJg6ZpkpZxLrkjtFv7hOKaZzw38ou7OCtl2NTZxGUVsHcTJMUSlYgEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 5:56=E2=80=AFPM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:
>
> Kairui Song <ryncsn@gmail.com> writes:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
> > pinning"), the common helper for allocating and preparing a folio in th=
e
> > swap cache layer no longer tries to get a swap device reference
> > internally, because all callers of __read_swap_cache_async are already
> > holding a swap entry reference. The repeated swap device pinning isn't
> > needed on the same swap device.
> >
> > Caller of VMA readahead is also holding a reference to the target
> > entry's swap device, but VMA readahead walks the page table, so it migh=
t
> > encounter swap entries from other devices, and call
> > __read_swap_cache_async on another device without holding a reference t=
o
> > it.
> >
> > So it is possible to cause a UAF when swapoff of device A raced with
> > swapin on device B, and VMA readahead tries to read swap entries from
> > device A. It's not easy to trigger, but in theory, it could cause real
> > issues.
> >
> > Make VMA readahead try to get the device reference first if the swap
> > device is a different one from the target entry.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> > Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> > Sending as a new patch instead of V2 because the approach is very
> > different.
> >
> > Previous patch:
> > https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-8831=
3f2b9b20@tencent.com/
> > ---
> >  mm/swap_state.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 0cf9853a9232..da0481e163a4 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t=
 targ_entry, gfp_t gfp_mask,
> >
> >       blk_start_plug(&plug);
> >       for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> > +             struct swap_info_struct *si =3D NULL;
> >               softleaf_t entry;
> >
> >               if (!pte++) {
> > @@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_=
t targ_entry, gfp_t gfp_mask,
> >                       continue;
> >               pte_unmap(pte);
> >               pte =3D NULL;
> > +             /*
> > +              * Readahead entry may come from a device that we are not
> > +              * holding a reference to, try to grab a reference, or sk=
ip.
> > +              */
> > +             if (swp_type(entry) !=3D swp_type(targ_entry)) {
> > +                     si =3D get_swap_device(entry);
> > +                     if (!si)
> > +                             continue;
> > +             }
> >               folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
> >                                               &page_allocated, false);
> > +             if (si)
> > +                     put_swap_device(si);
> >               if (!folio)
> >                       continue;
> >               if (page_allocated) {
>
> Personally, I prefer to call put_swap_device() after all swap operations
> on the swap entry, that is, after possible swap_read_folio() and
> folio_put() in the loop to make it easier to follow the
> get/put_swap_device() rule.  But I understand that it will make
>
> if (!folio)
>         continue;
>
> to use 'goto' and introduce more change.  So, it's up to you to decide
> whether to do that.

Personally I prefer it to keep the put_swap_device() in the current
location, closer to the matching get_swap_device(). To me that is
simpler, I don't need to reason about other branch out conditions.
Those error handling branch conditions are very error prone, I have
made enough mistakes on those goto branch handling in my past
experience. The si reference is only needed for the
__read_swap_cache_async() anyway.

To it to the end also works, just take more brain power to reason it.

> Otherwise, LGTM, Thanks for doing this!  Feel free to add my
>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

Thank you for the review.

Chris

