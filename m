Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EA8C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364066B008A; Thu,  6 Aug 2026 01:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315286B0092; Thu,  6 Aug 2026 01:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204716B0093; Thu,  6 Aug 2026 01:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDD3E6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:33:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F065A06B8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:33:18 +0000 (UTC)
X-FDA: 85069726476.30.201A0AF
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 817E340005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:33:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=emfkjzHO;
	spf=pass (imf01.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785994396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl3alXpFjFFuxxrmtd+49K/xtJFFT0bbuqMEq9NuLoU=;
	b=TgyZybHHGFw5nP+upr3y7+YYdDBxrODknyzFQCqkxtqO3aTOvYhIeLBwXYye/cUhdxUVhG
	XMEIRC95107nbAdx1wsPh5Ahzlyokc/ss9DXmHJz5R/I6E79ClULH67ZxU7e7cRWo9m2/s
	5OyfbWtrr81+428DPSQsxMSGp3Hw0Gw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785994396;
	b=kt8Yn0aWBjT5M3EUbbEQIVhWuyj+nkkrs8gXhP+l6oJkR3pelIZXZLt+K6WyGg2DM7fXAH
	e+owzrCu4OvmWZAsGIBbusfFW4IfYxecfIVz1xJ1WxIb+vsS66eUim2o4VMQjx19aize2L
	YIpxhh22DjW2lJikICxuYhfeR2dk8qI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=emfkjzHO;
	spf=pass (imf01.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso4602e87.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 22:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785994395; cv=none;
        d=google.com; s=arc-20260327;
        b=O0MlFqHOMLEY70dZz1wHep11c324hW2yMLUScZDdvs0kMZSxP7rHj1JA71oGH4sxjy
         IgM9Hq43F34pg82OidRhVQTdr84nPenXXdPHtCG0uqut2qY8EyqloBUpnN9fbua43h+0
         tXMZWwoNEmqbg1chW/E7YP3U/6vsl07T2qx+Y51yMV6UgxvWux7dYbs7XyM2FUCdyeNx
         6gmyprpi1tt8rUbIgcEjXO0UgCgBUCHHlkRGz8nJiBRqIgOmvZsm9PLjC9RxFsnJe+kc
         pQcT9XK0+zAGAS+6PtCSURfnNBAw59gUzOGPsmOcVd4vwiknb0fViwVBjRqX9aaXLE3k
         jSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xl3alXpFjFFuxxrmtd+49K/xtJFFT0bbuqMEq9NuLoU=;
        fh=ZsQfKWsYk/cNSbzc9WH2FCuxTen7NF6i53K4cnrEL6c=;
        b=hoosgSFH9xnBB2ALEUfXSQcaoc26GYlII4+6RDRZ5h5FSTVoxdBOtHImqH8+I4JFMY
         pKzCkdIrwacwepWlzF9KnajJuJDsYgwa9xef3EFx16MA7f8A1qRwl0I9qq1wdyt0+S11
         jZGkGu2M3o/C+0hOz2hfdn+jTR71GryO5LyDpV5ZRTBIGsXAERRw9Uz6KhgU3oC4yDBY
         n+5der+49pATaDMLaqlimC3xZ791AvaQx3VOyYL0U6Ka2rPQFiHS/JfCCWWbXRBVWEtJ
         GYugOP6jnS+koc2Bdf0ezfeajSANatfTPjiU0v+fwhOol5wmpghynw/2aiYGMDOavsoL
         behQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785994395; x=1786599195; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xl3alXpFjFFuxxrmtd+49K/xtJFFT0bbuqMEq9NuLoU=;
        b=emfkjzHO/slsySiS9wkaVjTei9qaubN/jrztfvx0z6ubh3huDLcWg42GfHGtpaeEKQ
         z9OxHIQ11r7TxXzExP8yu0qRMk8789xVNl5PzAHQ5WeJ8lyRNEKV/WhGAFrpFPq+LR+V
         TPGvhAW9gKJWbLW80vg7ImK21x9qWM1apu8YgBemSXWAtvn6FRZQSfC5yNRoyFQkRe0G
         M67TdS0Kkim4uVhd0xLASsrWjcFFCO0rScghA14CM7WYPmWd5v8hc81EOkJPxWOIdEkm
         UwRJkJ00XJtvsdssVgvqu7WVX9H6RH1N31zInqTvpwTT7cX3MccdYzJSPyEztdvvwCqW
         5Tdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785994395; x=1786599195;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xl3alXpFjFFuxxrmtd+49K/xtJFFT0bbuqMEq9NuLoU=;
        b=GMucgdyLZqgHM/aejW9hWKXBceorVqf+A4/7PyQ/MKZ2CWClXBM7ExZzqCtn//0Rl5
         PqhUyGmexhQBjQKNS7UchXHk0SSARGQREdQPZUgNmAw55rhMpPZmu83HkJBqGnJA4Z97
         L1Vwas2p5ueGc6JGdlJG625dkIEqpEZU8e4m9q8EvnmLtDWHnjrZDauCl15ozMcpmF7X
         fcKjh+xFe4h8vWXDPDl13gvvc7ZmFoy9w61ZQcIoX/RaF+TFsKb9MKkhPg+rC00tKpym
         YgjIwKXC2Q2zCNBmlH2pzwucafz9VWkF21nu+vvu2EA+siP9wfXM66BlNmUZ3zslLqfi
         gj5Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro9Gsv2gMrKjhn1ncthDEY3NbTt/XpXoRLxGcXaYt6alaTkRO3G+VaXbuNniryyccd2okvFwDoztw==@kvack.org
X-Gm-Message-State: AOJu0Yz5M5FTpY9LJKPzzRRQVuTIWHnFEchOJ/8d+gx2yl0nrgw7zKIy
	wbJXOz86hZufJdaDx6cTZea45Wc+uj1mrxwDCAH/o0dpiWD0ficMxsvtab8JsmzSQOAiAvwA5FN
	Yym5q7zRIVmYhVUpHXXOyy2CiXKWpErkpd9ZgiCbb
X-Gm-Gg: AR+sD132ROruZqXYRsvi7o94ZKWYYeUzVBB03KnrHDpc6eync8p+IAhfqEw9GeWgaNt
	Haq7rzR6e5dH1R5pJnnkhUaZKe8P2DdtwGjLjQCH1FEMrHQmjv9QLcr/zUH5vRx54B3V68xF/iN
	U+ga5rvivd1O1QR+H58Fv44EeGBfT+/Exd5V3itpbuub79kxjBmoIkphEz7PIvW8EVrVI5gXCAN
	u1DC+OHaE51lDgyhb0U+5NiXjRM9zgfxULeNKeUMAcYQat4JPsDci0Mg9ZzePchOpVlJ5734yXT
	tTxmlmzVBUrxarL8bP67zFTRDQ0F4rNdlvK5CAkxpZn30ss3mFf0StVWoyBCW5C3KDJy17InrWs
	n9E9tbmvt96JEkXdvHeEQMc+Fzn/oVGvicPpcJeqivo9o
X-Received: by 2002:a05:6512:6894:20b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b30169e3b8mr36954e87.5.1785994394411; Wed, 05 Aug 2026
 22:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev> <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
In-Reply-To: <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
From: Sourav Panda <souravpanda@google.com>
Date: Wed, 5 Aug 2026 22:33:02 -0700
X-Gm-Features: AUfX_mxr_6_qXO5hEheLH_T8cV2wjrkCDG9KMG0fIbDK1NvEaAqpmuNHgEf1sOs
Message-ID: <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 817E340005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nqyo7ghjgha5nkykfuhxs54h1jgmuk81
X-HE-Tag: 1785994396-403039
X-HE-Meta: U2FsdGVkX1+69YIEeIiVYVzBFM3jBfXTIei4ZAud1hOp22lgNnUkA5dykaSyXZO6NkuGisuqB5aTV/G7zoFBdPM45KkAbS5QVFsZYA15kk3De34IFn6Fh+NLJqG5pAYDrKNBa3Pw0aP9k2Uo0Nv6o91buRYkNJgmcFd7In7ZBlgqF84X/wch61OFuOUqlpypi/f/+2sCwQP5TkrbduiglejS619e/R4FeaPnvtEARlbICG1VD+P0+UFy9Nb3VVEpLc+alPZrV62PmEshzCZ/PheHPtbieQxlQNi6s/QBelzmHZe1freC3vXstdWeEv61ngrPyZOzMmy6Gap2VT2hfA/sEH5VuEqeyCqdTOCHkAiClFcSQxK2tIES0UcOaIMvj4tHQX//kcsbB9RNOvkFJJ84WCPUCZVUWXeD8fF+vTLmbo80H7dR2zinWrp4+FZoSMczGtUB8Ms1qVh3o51x5/CBb1e9hiwZyoZeTTbTKfF5grSc5+ABpTXnK6Z49KqlambvRhzv4Ts5LfjykeTEfd6oTHrJjPg0f5fV0ING0bAkmWOyga0kAGa6tt1gasQdVy8h0Uq0JWh4YOSAAmie6RpB+FwyxPxFBYbmejkAE3i625XoUrQVS7pHkl5Tk3ZvfG3ApYkyUr/2dXrnqbXP9p38W/e6P5KspnQex7e3xdPGNdY+HhgL3wZSz9zlPqGU54gFjlnPykV9e/HAKXWDS9//JoQpUfuNKkyqAjxut5xgCH3vR3JtMWW40P/1klGB6YsFwPKlJOr5ctcrirzOpG0rO+ki1HWoStxKqFFoXZmMDim3adO4/wdux7U9HhK5eVthcVydYWpe4REU3xrDSVjIo2D/O2V2jk9hWzdDeu+CmfShQH4TU8kaRIfPXA/vSVT65L89MaAMubWJ74ATGDJjkCXNXzg0M/fIbf8aA0nQl/gl+XyKAFdTlpL6LXyJrVd4RWba7OIksddOlOP
 IY5EzD6Y
 H+yTmcWEDes6WsJyDfNvCR7imoS9a4vBInIQS9ApkcOIUYj2cxp3MGg/zkecRRxCFCDOxyut2HzXShqB0YI6Zc1RWHcJ2VFlVUGvhi/YjH3y69pk4oJrvisQ/nqtOrA+l05+axaodvUnnia9UZoCvFF4YmqzL3nlI6y8wjchGmAGpkJ3U/KosksLwC3VKfV3Hv1nJgzErM7AcFSv+FyzYKb6qS58u3NfhcmcLtP/EmTlTnKYBiyjkfTr+KWK4SJilparmlOKyreaNtlP2c/VXtVmkBLOfJ7rwxDLwR0DYxEZJAbm2oxBr/w0WnW5hsreYQKsuwJp2k2ztmqIog0FNu4g88QXU+nYqTvTHNT7ROh2xoY+xGqjEjHPURJ0x2oWj4LmMiw0bY/k4buI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 7:47=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
> > On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com=
> wrote:
> >
> > > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > > alloc_gigantic_frozen_folio().
> > >
> > > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > > leading to a null pointer dereference kernel panic.
> > >
> > > Fix this by checking if nodemask is NULL in
> > > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > > back to any node with memory, keeping behavior consistent with
> > > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> > >
> > > >From a userspace perspective, this bug allows an unprivileged user t=
o
> > > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > > configured on a subset of NUMA nodes.
> > >
> > > This can be reproduced by booting a VM with two NUMA nodes, restricti=
ng
> > > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > > hugepagesz=3D1G hugepages=3D0), and running a program that allocates =
a
> > > 1GB hugepage area without reserving, restricts allocation to Node 0
> > > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > >
> > >   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > >   unsigned long nodemask =3D 1; /* Node 0 */
> > >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > >         sizeof(nodemask) * 8, 0);
> > >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > >
> > > This results in a NULL pointer dereference:
> > >
> > >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >   #PF: supervisor read access in kernel mode
> > >   #PF: error_code(0x0000) - not-present page
> > >   Oops: Oops: 0000 [#1] SMP NOPTI
> > >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > >   Call Trace:
> > >    <TASK>
> > >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > >    alloc_surplus_hugetlb_folio+0x6d/0x100
> > >    alloc_hugetlb_folio+0x3c5/0x660
> > >    hugetlb_no_page+0x3d9/0x650
> > >
> > > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugep=
ages")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > > ---
> > > Changes in v4:
> > > - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach f=
rom v3.
> > >   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowe=
d does
> > >   not prevent false-positive allocation failures without complex retr=
y loops,
> > >   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() alread=
y handle
> > >   NULL nodemasks safely internally.
> > > - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_foli=
o()
> > >   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> > >   HugeTLB allocators clean and consistent.
> > > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-sourav=
panda@google.com/
> > > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-soura=
vpanda@google.com/
> > > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-sourav=
panda@google.com/
> > >
> > >  mm/hugetlb_cma.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > > index 39344d6c78d8..5744de0ceeb7 100644
> > > --- a/mm/hugetlb_cma.c
> > > +++ b/mm/hugetlb_cma.c
> > > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int o=
rder, gfp_t gfp_mask,
> > >     if (!hugetlb_cma_size)
> > >             return NULL;
> > >
> > > -   if (hugetlb_cma[nid])
> > > +   if (!nodemask)
> > > +           nodemask =3D &node_states[N_MEMORY];
> >
> > Hi Sourav,
> >
> > hmm what if cpuset.mems only allows allocation from node 0, and hugetlb=
 CMA
> > is only available on node 1. This will no now allow allocating a gigant=
ic page
> > on node 1 when its explicitly not allowed?
>
> That's fair point but should not the user be also responsible in provding=
 a right
> nodemask containing CMA memory if it prefers avoiding node_states[N_MEMOR=
Y] based
> fallback mechanism in kernel ?
>

We have precedence for three options, which makes selecting one difficult :=
)

1) nodemask =3D &cpuset_current_mems_allowed is currently being used in:
       only_alloc_fresh_hugetlb_folio --> alloc_buddy_frozen_folio -->
__alloc_frozen_pages_noprof --> prepare_alloc_pages.
2) Some places use cookies with cpuset_current_mems_allowed to prevent
torn writes. But this adds complexity.
       An example would be dequeue_hugetlb_folio_nodemask()
3) node_states[N_MEMORY] is sprinkled all over the kernel (simplest).

> >
> > Would it not be better to check cpuset as well?
> >
> > Thanks,
> > Usama
> >
> > > +
> > > +   if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> > >             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> > >
> > >     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > > --
> > > 2.55.0
> > >

