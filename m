Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF8CF4BB8E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 21:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242CF6B0005; Tue, 24 Feb 2026 16:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0F06B0089; Tue, 24 Feb 2026 16:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C62A6B008A; Tue, 24 Feb 2026 16:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E37586B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:57:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91A11C1437
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:57:08 +0000 (UTC)
X-FDA: 84480711336.23.006B9DE
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0902C8000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:57:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BG0WJzs3;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771970226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddGmIXOQS4WxUyRIColh1lekBcQxaYW9LRSLHl/Pl/w=;
	b=49GB4jVRevc5gH4PFcdktru2yzlhfwzMibrx1R9dVQozuRvLB+olcxHM/6eJAs79UG89kh
	Mm11oOfRnu1eHEES2hDraRJya0T1eiGdYiYxsE8XkZMlWIzVkVsbZHCssu4a4jSEZlFsvM
	A8w1iPzugGoY2ogTcpagh/f3T3c4t1k=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BG0WJzs3;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771970226; a=rsa-sha256;
	cv=pass;
	b=R7lTSTwoSO4EK77hDMk0VbgtX92chTJ5ADVChfUu9eN6SeKAjX9aN1W/7vJFvXYO/Bgagf
	YyLsQyruG0NqBlumnksJmddqHWpC4NkJLjgO0vdCqH8nYbqJ8cYO71tJtz9Ou1eRAFdg/u
	jN6hiryl+HOKNy0yLNi1adESnYP7M5Q=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4327790c4e9so4556784f8f.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:57:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771970224; cv=none;
        d=google.com; s=arc-20240605;
        b=OAIsgVH0KYy5kdGNEbA0HBMRK2XIPbfJTd+oNMyZvnZQZ2s0mqR9rdowlFt6aL1sHw
         LbBX50gbSYlF0FlhED3btteRWyOHPFisXoSgfTvlTInC6jZfObmNgOVX5MrhPn8LY4tL
         82ISLFN2SLIgAKQpCzY9EHVgnXiW+opZVM2whSZQvoFugOt+C931gvobXN2xG1XXthRj
         23SAQOLF/GH4x1C5q2f3holU6mRQLmUGD+2EuulA+QpdRzcDxg2X/FXOlnA/NFYzU40f
         zJsHNTLlQvcvoyYTmvbxzpRI8bM+3rGLDzirDV/tfl9FrSTPU0qJ+L9aC8pjrXXC+zO3
         NyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ddGmIXOQS4WxUyRIColh1lekBcQxaYW9LRSLHl/Pl/w=;
        fh=i+mafN0k5y07gaWaaB56IgVOWupfPJFkrrUDC66I8bU=;
        b=WSdNQXp3ykxxJYBqy5gcT8baWwUFs0u9QqX3dIf8p9MyKI5dvwbJgowlkDaUPRYiuy
         ghSL98BCPHXvLeydk4nHpBtqj93vnvSIGF70A5ZpdNCuOcCX9EwfA7vaIVb4fltDQAKc
         xGGn1jphzaFQ/O+l/kXSVXx0ouoRrVLmZG9wbXhTP47aCcmJDbnVBjrQN8SjFDpW5x39
         1GIF63cvVSQLPqG82nmgLMt/wxOYT46uHThrhZmQib5XfSr48jA/qNc7P0FiDGxnKKuq
         cxCfXbyWr6ERxFlLx93qXjSaztQCmvl9duNM2ocbZjJJI/MfdPTKTEsnzFZQbibWTN5O
         UcYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771970224; x=1772575024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddGmIXOQS4WxUyRIColh1lekBcQxaYW9LRSLHl/Pl/w=;
        b=BG0WJzs36S4pBMtLIHd4cEPGpMr+OU46yyaYGoRiSHtinfb1bLytXxfQLYTmYYVTII
         7hC5lBHi5b/JOgI2jNtU2NAVgLc/Aq4NyJ8ySA7cWqj1GVYq4U8RVldUQk7bEAmWerso
         x3rv7nIM/LUsZPlG5JKxqeFCQxSYGaSl3tZstd66X1zUZNC84QQAjCBkcDCXkCGehPTC
         ZeIAzUwVR/BqBRHF9eL4Qdy2/A2+z2tZP0RnfwukdeYtXEtrQp5y6S9PzqiFmai8BEdP
         t2S1dJ/+agzt0ctJl2+qcLy7tltxzloeHO6TZSRLmwwbaEMHRRAMoakweO8WruQ6zMHd
         Vvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771970224; x=1772575024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ddGmIXOQS4WxUyRIColh1lekBcQxaYW9LRSLHl/Pl/w=;
        b=urH7ABaO5f9b4I+nf0gCfu6pevIfsoeA18uO1R34Ri4qnbggO1R53rTKGgXgOqtl5H
         UlHRnOk2PH9gaZVUyj8TKhb5CwrgSg070uLsjhBjnXMbr/moky1ZpiHVZzB6AUAheG3L
         j2B24kO6jKWOmp5jlSzforWdAbnnRhn+g13CE0erDbGhhQs/yVU4EOrYC/V9N21S1c7j
         Rb5bLUlsoSAPY/jF++IfYOJqcpxfF2YG5hk6oJAEywIa/ehkxTPrctxt0ugKpY5PuI0l
         DZy16sWkxI3tsaTSOkyLdOiz5YDzXc8ThlYTC1VozPcNKCd4qnAeqb+RTZ+5xO2ma6JS
         kFCA==
X-Gm-Message-State: AOJu0YxYV6MhgLrNcqk2NwBI35UeIDihzUa6+o8rMDMpXl9DmANQKGXm
	tn4ANhiA1IHaN7f3dgAViEm6Q/7GsYURKK0gITSh7sjKxIhrYdZCBD5932uVtW1jIQLRDlztMRm
	a6G4y0u65I1ZEWbXdwjLWTdpdZ/OgEQw=
X-Gm-Gg: ATEYQzydsnuMKkylglrCvWqRzJpsS4K9ViYe0oNtoBiR9f5yeVkHg0+BOvV0FKEqNKA
	wVIrTCi+uEuQRFwGk0dt2Ew+3sw2VYeM3USL1kDvLJaj64CY0K3vlkEOL8eceiZrk2kdl+/I6QQ
	igpBmNeuHJ3v8mDrBFl32+a/N3JZl6dOqsxXonSrdI2KuC5t6HJ9KIbO8WS1Uwm6GmAIg49pHxU
	X/YxE0XgK33MzYlKssN/1KLhVLnPqwr4KC4jpT8OnzljF+7e/6M1/aoDXuZadMVXGQ174J31d74
	++REgmCiQKLaR9vAb3qq4ZFK+HxQrlFCpXP7TcG+Cm7VJPaK3+5tcE4=
X-Received: by 2002:a05:6000:2086:b0:439:8c7a:247e with SMTP id
 ffacd0b85a97d-4398c7a24e0mr3553389f8f.36.1771970223993; Tue, 24 Feb 2026
 13:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <CAKEwX=OaDKQwanaYm=Mt+mWAKjaqXPdiScF6NB=TZYx1B-Xo8w@mail.gmail.com> <CAMgjq7D6n0H2=di0SrMQbJ48cVeKhGeQMH_mY0y-au4OJbE2GQ@mail.gmail.com>
In-Reply-To: <CAMgjq7D6n0H2=di0SrMQbJ48cVeKhGeQMH_mY0y-au4OJbE2GQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 24 Feb 2026 13:56:52 -0800
X-Gm-Features: AaiRm50Ta_rou9OyJpASA6p0OEDH6ol87emnfUMH-qXSb2kAWVnEHM7JVmtlFIs
Message-ID: <CAKEwX=NjRGxjQuvAnRoom=Ac_YptspMk1pwoq-2on46f1meuyw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0902C8000D
X-Stat-Signature: 6s5mi35c88fu59ws46ow6dr7ximqf83y
X-HE-Tag: 1771970225-751433
X-HE-Meta: U2FsdGVkX19H2dxReovId91D/1KbWapItblK3azqCIof3lr3BqtoNKy9GfM75ePtuWGLcrwB8Pv78uMfUzGDavqta3ik4dfbAB6GR3ByRJGEY7S56FmySDvdpTsH+BxY1ow5aqDs8XBAbDQ70rx3OySwec0up7/Ltm0eB59n+maFLCSG0meHwJKC41FbwXZtdWdc5xBrQyc4GzLk6LIlwcq9+LC87m6sHoLL/yH1wUb0S+lm/rdxSA2rLUdlCXGZ2HtZrN91fyCEKJdeAhmNyE5TaESgN7oU8tTo8N+D+X4uzLcxxsYWRtvMhWW7WYZXbp17afN2ZLjk4iCgOJvD7QWRS0MptzDxr4Aj6ihKb8U6JN+sFjlMwT8iXr+J5SQc37Rvlb54Q3OQIik3u/tFn71kx1Rqe9kbxqQ91zMdoi4rGrTQyBXkoEUQYP/MxVuaHFxxBicUZM4eUfC+Ux49c3Aqjj4lyOqWoemYuua7rGfygjpPS38ZnyyDc01OMoWb/x+y5IdC/TDY2GY2r0Aq2j3OBslujLl7zJQEsBkFQBV5d+iCZljsp7iGXE2BSWZqOG7Ay7+1bn1IdtL0QObaLsmNpS/8VOfC1ZD105SSQf4GbHymY3MvB3KRH6nRL9JkmtjOta0/MkHdG7tgzw1V9bOISl0dM0OYi9vHBkG44cTg6WMe+PO4aESZOvdRZVRunqpgTLpEKXTczKQmht83I1kttpNecNT4jkLB+EgsRtDKflb83ZUEMDXNxI8AMrymwZ0yNm/YMVwLyvatooeEOWo5jyoOxAX6mWJVjsnxWn8kN9bW2DzDvCIeI4y96hn1tFYPRIv3Y3X2R2Yl7jLr7r5kpkbwHdGQtVM9OsW04F7cZfJVDdMuPWKD+/Ya+D2mi2dxmHyXfHiaxyZgBEfVLI1p2qeJuzDX5c7tmkv/Gfcp4A9DraWRMUsWLJteGc1gXeNDF5uRXJquJJfVIss
 hBg7iIFu
 BW2qyBDXOzuZAN6mguIPeE6ime4WIvtEO67GO1HnTAeCuxT1Asc5iS1P+xcGSWyM3bbhd1/pX7+eLSqqpW0N7lp2Pse2aMRaqnxFj/0e58zVRBbQlEsaE8nGYju/J9ZWMGWJ0XXeH3lfxctfSjupw064AgKk/MLB5HRHxHDc1k+8GTy2a3/XSCxsOGPiApdjTfM4rUHKmFbnzyFoBgxdH82CoS+OJ/TNEiOfUiJo42eBu4oen7HVj3hAojbea+N7LqvdKAxenwpixWwDKKCUrVpANG6EAXl5SR9ojPyfkAS4SNUxbm9CYOMFFufovHGx7UOGhvcOl7CQZPisoyWF2HQ4G+cPIoFqZYzfrnTKybWhPzIMDV9Gmq0jBYPa812M7QoVnPniEwBzdBO0ORieql3O/6QDAip3UnxkM9ptDA89Mcy4nxKiIy9FKOz5faUT6GpXyLVSE/nVi7Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 7:35=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Feb 24, 2026 at 2:22=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Thu, Feb 19, 2026 at 3:42=E2=80=AFPM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > > Huge thanks to Chris Li for the layered swap table and ghost swapfile
> > > idea, without whom the work here can't be archived. Also, thanks to N=
hat
> > > for pushing and suggesting using an Xarray for the swapfile [11] for
> > > dynamic size. I was originally planning to use a dynamic cluster
> > > array, which requires a bit more adaptation, cleanup, and convention
> > > changes. But during the discussion there, I got the inspiration that
> > > Xarray can be used as the intermediate step, making this approach
> > > doable with minimal changes. Just keep using it in the future, it
> > > might not hurt too, as Xarray is only limited to ghost / virtual
> > > files, so plain swaps won't have any extra overhead for lookup or hig=
h
> > > risk of swapout allocation failure.
> >
> > Thanks for your effort. Dynamic swap space is a very important
> > consideration anyone deploying compressed swapping backend on large
> > memory systems in general. And yeah, I think using a radix tree/xarray
> > is easiest out-of-the-box solution for this - thanks for citing me :P
>
> Thanks for the discussion :)
>
> >
> > I still have some confusion and concerns though. Johannes already made
> > some good points - I'll just add some thoughts from my point of view,
> > having gone back and forth with virtual swap designs:
> >
> > 1. At which layer should the metadata (swap count, swap cgroup, etc.) l=
ive?
> >
> > I remember that in your LSFMMBPF presentation (time flies), your
> > proposal was to store a redirection entry in the top layer, and keep
> > all the metadata at the bottom (i.e backend) layer? This has problems
> > - for once, you might not know suitable backend at swap allocation
> > time, but only at writeout time. For e.g, in certain zswap setups, we
> > reject the incompressible page and cycle it back to the active LRU, so
> > we have no space in zswap layer to store swap entry metadata (note
> > that at this point the swap entry cannot be freed, because we have
> > already unmapped the page from the PTEs (and would require a page
> > table walk to undo this a la swapoff). Similarly, when we
> > exclusive-load a page from zswap, we invalidate the zswap metadata
> > struct, so we will no longer have a space for the swap entry metadata.
> >
> > The zero-filled (or same-filled) swap entry case is an even more
> > egregious example :) It really shouldn't be a state in any backend -
> > it should be a completely independent backend.
> >
> > The only design that makes sense is to store metadata in the top layer
> > as well. It's what I'm doing for my virtual swap patch series, but if
> > we're pursuing this opt-in swapfile direction we are going to
> > duplicate metadata :)
>
> It's already doing that, storing metadata at the top layer, only a
> reverse mapping in the lower layer.
>
> So none of these issues are still there. Don't worry, I do remember
> that conversation and kept that in mind :)
>
> > > And if you consider these ops are too complex to set up and maintain,=
 we
> > > can then only allow one ghost / virtual file, make it infinitely larg=
e,
> > > and be the default one and top tier, then it achieves the identical t=
hing
> > > to virtual swap space, but with much fewer LOC changed and being runt=
ime
> > > optional.
> >
> > 2. I think the "fewer LOC changed" claim here is misleading ;)
> >
> > A lot of the behaviors that is required in a virtual swap setup is
> > missing from this patch series. You are essentially just implementing
> > a swapfile with a dynamic allocator. You still need a bunch more logic
> > to support a proper multi-tier virtual swap setup - just on top of my
> > mind:
>
> I left that part undone kind of on purpose, since it's only RFC, and
> in hope that there could be collaboration.
>
> And the dynamic allocator is only ~200 LOC now. Other parts of this
> series are not only for virtual swap. For example the unified folio
> alloc for swapin, which gives us 15% performance gain in real
> workloads, can still get merged and benifit all of us without
> involving the virtual swap or memcg part.
>
> And meanwhile, with the later patches, we don't have to re-implement
> the whole infrastructure to have a virtual table. And future plans
> like data compaction should benifit every layer naturally (same
> infra).
>
> > a. Charging: virtual swap usage not be charged the same as the
> > physical swap usage, especially when you have a zswap + disk swap
> > setup, powered by virtual swap. For once, I don't believe in sizing
> > virtual swap, but also a latency-sensitive cgroup allowe to use only
> > zswap (backed by virtual swap) is using and competing for resources
> > very differently from a cgroup whose memory is incompressible and only
> > allowed to use disk swap.
>
> Ah, now as you mention it, I see in the beginning of this series I
> added: "Swap table P4 is stable and good to merge if we are OK with a
> few memcg reparent behavior (there is also a solution if we don't)".
> The "other solution" also fits your different charge idea here. Just
> have a ci->memcg_table, then each layer can have their own charge
> design, and the shadow is still only used for refault check. That
> gives us 10 bytes per slot overhead though, but still lower than
> before and stays completely dynamic.
>
> Also, no duplicated memcg, since the upper layer and lower layer
> should be charged differently. If they don't, then just let
> ci->memcg_table stay NULL.
>
> >
> > b. Backend decision making and efficient backend transfer - as you
> > said, "folio_realloc_swap" is yet to be implemented :) And as I
> > mention earlier, we CANNOT determine swap backend before PTE unmap
>
> And we are not doing that at all. folio_alloc_swap happens before
> unmap, but realloc happens after that. VSS does the same thing.
>
> > time, because backend suitability is content-dependent. You will have
> > to add extra logic to handle this nuanced swap allocation behavior.
> >
> > c. Virtual swap freeing - it requires more work, as you have to free
> > both the virtual swap entry itself, as well as digging into the
> > physical backend layer.
> >
> > d. Swapoff - now you have to both page tables and virtual swap table.
>
> Swapoff is actually easy here... If it sees a reverse map slot, read
> into the upper layer. Else goto the old logic. Then it's done. If
> ghost swap is the layer with highest priority, then every slot is a
> reverse map slot.
>
> >
> > By the time you implement all of this, I think it will be MORE
> > complex, especially since you want to maintain BOTH the new setup and
> > the old non-virtual swap setup. You'll have to litter the codes with a
> > bunch of ifs (or ifdefs) to check - hey do we have a virtual swapfile?
> > Hey is this a virtual swap slot? Etc. Etc. everywhere, from the PTE
> > infra (zapping, page fault, etc.), to cgroup infra, to physical swap
> > architecture.
>
> It is using the same infrastructure, which means a lot of things are
> reused and unified. Isn't that a good sign? And again we don't need to
> re-implement the whole infra.
>
> And if you need multiple layers then there will be more "if"s and
> overhead however you implement it. But with unified infra, each layer
> can stay optional. And checking "si->flags & GHOST / VIRTUAL" really
> shouldn't be costly or trouble some at all, compared to a mandatory
> layer with layers of Xarray walk.
>
> And we can move, maintain the virt part in a separate place.

The point is not that it's hard to do. That's the whole sale pitch of
vswap - once you have it all the use case is neatly facilitated ;)

I'm just pointing out that "minimal LoC" is not exactly fair here, as
we still have (in my estimate) quite a sizable amount of work.

>
> > Comparing this line of work by itself with the vswap series, which
> > already comes with all of these included, is a bit apples-to-oranges
> > (and especially with the fact that vswap simplifies logic and removes
> > LoCs in a lot of places too, such as in swapoff. The delta LoC is only
> > 300-400 IIRC?).
>
> One thing I want to highlight here is that the old swapoff really
> shouldn't just die. That gives us no chance to clear up the swap cache
> at all (vss holding swap data in RAM is also just swap cache). Pages
> still in swap cache means minor page faults will still trigger. If the
> workload is opaque but we knows a high load of traffic is coming and
> wants to get rid of any performance bottleneck by reading all folios
> into the right place, swapoff gives the guarantee that no anon fault
> will be ever triggered, that happens a lot in multiple tenant cloud
> environments, and these workload are opaque so madvise doesn't apply.

I somewhat agree with Johannes that the problem is quite academic in
nature here, but I will think more about it.

>
> > > The size of the swapfile (si->max) is now just a number, which could =
be
> > > changeable at runtime if we have a proper idea how to expose that and
> > > might need some audit of a few remaining users. But right now, we can
> > > already easily have a huge swap device with no overhead, for example:
> > >
> > > free -m
> > >                total        used        free      shared  buff/cache =
  available
> > > Mem:            1465         250         927           1         356 =
       1215
> > > Swap:       15269887           0    15269887
> > >
> >
> > 3. I don't think we should expose virtual swap state to users (in this
> > case, in the swapfile summary view i.e in free). It is just confusing,
> > as it poorly reflects the physical state (be it compressed memory
> > footprint, or actual disk usage). We obviously should expose a bunch
> > of sysfs debug counters for troubleshootings, but for average users,
> > it should be all transparent.
>
> Using sysfs can also be a choice, that's really just a demonstration
> interface. But I do think it's worse if the user has no idea what is
> actually going on.

I think the users should know that virtual swap is enabled or not, and
some diagnostics stats - allocated, used, rejected/failure etc.

But from users perspective, the other traditional swapfile states
don't seem that useful, and might give users misconceptions. When you
see swapfile stats, you know that you are occupying a limited physical
resource, and how much of it is left. I don't think there's even a
good reason to statically size virtual swap space - it's just a
facility to enable use cases, not an actual resource in the same way
as memory, or disk drive, and is dynamic (on-demand) in nature.

