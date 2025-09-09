Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C06ACAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6CC8E0002; Mon,  8 Sep 2025 20:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EE68E0001; Mon,  8 Sep 2025 20:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4978E0002; Mon,  8 Sep 2025 20:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A58268E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:08:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 439551195C7
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:08:58 +0000 (UTC)
X-FDA: 83867776356.20.F9DB4DC
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7FDA0140007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:08:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kkZfIhxT;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757376536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fp4mwjrOklNOXxTbWmC667rfKJrZM5GjA02GKAs4tfE=;
	b=7NMJZjggCVYFDpJyz4euTyNlYWcgOYtoyi3Btx+zPWriw9XT3kVP8IXodZ66tL+V2T+qSL
	grFymkU8Wr7OUIN4MXpQvmz3rX7N0/rrIDhKVsPjAtGt6mNLl10rD1maoKhiwVKE39gvQf
	PUpHe1xssaRM2jqpC/EXfV75MO1mGns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757376536; a=rsa-sha256;
	cv=none;
	b=e6PRWmlItPoBLZvEre7Jq0pvN0IJTDUPiAh0VIxuxq2ziRXy58oXxTfTTiyH3hwClqVm0D
	a1YR6FLA2ORYprOc8ju9wyECpby1Si2YfjsegEsjQIDMxVxiHz3+ZIdqU0ZVnvmD6AxKDz
	YqOsKLeVe54Ac1KksvXyH4rS8agxtnw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kkZfIhxT;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso30037665e9.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 17:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757376535; x=1757981335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fp4mwjrOklNOXxTbWmC667rfKJrZM5GjA02GKAs4tfE=;
        b=kkZfIhxTa3M21yReb0HVO53KL6ZoFeZBgi3w1y1IerSd8sr+fKKmNKH0ngldpohI+6
         vVXmPGalJ5sb09D8LJfIMGKDcuUvadmgmVFgJd+Q8NTJHL67iFT9KGCsNZNL6IWmE1VF
         I9Xievkq9hKCgHKQOrVOEkFOD/dnYDWRe9yTcsIXF9H8m+W+cwkBCyp+LTWaxjXcakTf
         ObqFsQ6FESrJeVqB+GzzS7GWHXnDyeWeZxcXk0+DpeCdNZgxCwgovXZcEwDC9hr0IWht
         Ng4x1LKl2lYIyGMuHCZXiQOjcNxQ9vHZH3TDLZi+jta+VC0kF06b6eolcEBOc1WIGVaf
         4XkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757376535; x=1757981335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fp4mwjrOklNOXxTbWmC667rfKJrZM5GjA02GKAs4tfE=;
        b=ED0IfBDzqftY3gaNIH65JkcDQkrcaOJV9xJniF1GTULbaudV/tZTiBamY3ZyeqEn6D
         opn7j8O+iTb94pkT9v7PcNWB+nwAhBC1K6PjmtRMQjQmhidhIxE7lsX5laon03ZXjPwB
         mCbE3Rx7mC0o1/Wj/bl7RgVKJsZVpxoffYehhp2mX9wkxZPGz2svICkvWvyeXlo9gmBJ
         agtwWbvT0raGeSRyb1kOUZpW3hFEER4rVnSl5dEcG01Npt5JWWAX6Zxq8fwUTcnweOuu
         ICMppGS2Bp9AmWAxEmeEC79SXiD40fEmZw/MgmlLvfd0HisFS9MS3DR1y9F4YK1o7VeP
         sxdw==
X-Forwarded-Encrypted: i=1; AJvYcCX7aZK4a2RNfE3aT90zw0HoPD6X8TBAYHvOSwGBeNfsCJIGvyJ+1oZXszycvBqENxfvzYqiV9VGXQ==@kvack.org
X-Gm-Message-State: AOJu0YycE7hoG9YoyJYO+9eyVImr3bpYSCmkZeyBf6QsK3rA82CQ1EF5
	AL67gPrGRBs4dTC8acx0OId0zGRXlvHRh45oWoYmucpBgZ9pOoRLEjdDmtLzW4xN/p0Cha+w8QA
	uQQvM2ALLnu7egGXaoSQM3Qpu4c5WVBg=
X-Gm-Gg: ASbGncv+sjEkTykJScWReuq1yzg9XGBH+0XATAmNr0RoMV8AZkUew+DKS7x0rVu/tsi
	5xwEds8FuucQZfPuyZ0Dxwqsi2BEbMzYqcx5xjlktg5hKylSDZ1NzW+nXJ2KLnvvIgMAhr6lva6
	jIOMxKEREf1Cxkhl4hGmmuvpnlAGubeDd9mjzrGfImaLLlDVYnzCIc6A3gLi/q4D0ThXySakDxN
	VwfXxVW8aKSzU7/gINjr+kDH/FW58FaTJg3
X-Google-Smtp-Source: AGHT+IHxcybvED+0BOKpyGhQK1ngiooddpmdIAtYBYZ4h7rBKcRvSR3lUyUjbfCnGSsSCqWOtR69wvcRqmSlMZdACho=
X-Received: by 2002:a05:600c:310e:b0:45d:98be:ee8f with SMTP id
 5b1f17b1804b1-45de1ad26aemr73438205e9.26.1757376534649; Mon, 08 Sep 2025
 17:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250718021646.73353-1-alexei.starovoitov@gmail.com>
 <20250718021646.73353-7-alexei.starovoitov@gmail.com> <aH-ztTONTcgjU7xl@hyeyoo>
 <CAADnVQLrTJ7hu0Au-XzBu9=GUKHeobnvULsjZtYO3JHHd75MTA@mail.gmail.com>
 <aJtZrgcylnWgfR9r@hyeyoo> <aJt1FHnavjRv5CzI@hyeyoo>
In-Reply-To: <aJt1FHnavjRv5CzI@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 8 Sep 2025 17:08:43 -0700
X-Gm-Features: AS18NWAcrURD6cSs8YFhK6At7ukKcp3fduqIT5t_3BqXOqyQ9qXPkH9La4LpcMU
Message-ID: <CAADnVQ+aLojadnDgnOwJCTAE319can=rW7ELh2Xy5M-d2TWcHQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7FDA0140007
X-Stat-Signature: nmj7akiyq1qakw1oxeycinff6qzyswaj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757376536-429311
X-HE-Meta: U2FsdGVkX1+saU5Jeu2sVEYEsrK9dZ4hWdLYYwzQqUDT6uJoG+tx5R7Mxo5UTEQ5W9vRFls6RquPiu7oYBxIUGgDWAqzHxBDRuYBx1F3j6Tn/5RDs1u9tmnAxKD8zEdViDmMrJ4groEGE1vXRTDHOG+8t3upO0U7luMEqOw8SLb07DikwcEqul3hAppx7JtSM5AYME2kn1E7trkXuXspPcz4Tq/1KYHIMVMfiovoONe7l03r8KeRJYvBWzoNqWksKOs7Bz/B0L2r8cbFTBOjMdGqMk+b4QL9494QhgrjXlvFMXQ8lIF5QiqUuxV+uOj/gPTfnAK6rEbhBfAcImjPBL+GqRcCD5Y88Ve+ZE9yenUOuWazpjLRJ+VGAg6c1wYwMtcpLsDf/7Xw5b63y/FFcfjktrVjCpLFaxooOyNaEaCnhVNxSLqTlVfd11MncitZ1K9x+f+hx0dYOAZacQ9Kr+mGcwWvn+0iP14RbPHoTE2Mhhinrw2cvsv4XuZZ/0NXiIqzUqu9SDfF4qZ9GfFQRUUzk9LKi8THW96CjhVyAR0PiFfvyiYJhb4NJ6wUC3G1Co2WbOYbuYdOkSlmobl3x9LyXFYBBEh6YG/fpCG51jGhp7f6Y/U4QG1ZY0crOsdAJAMZyp25TILBsUrCzeAtOmBrTGcmDRRuZq3uzgh01BAET8eONDKQLFWkuDMDhcME4Sz4f9+V9owErG8sezMBUMB+SwglFBe+KQuswzPx9H6ZFiR90jzIJeP45FjWSEuSp5mBm73dpoTYi+du5lPptz6V5fnFClXAgUz4z08Bll5o0UbtOjY0MxjAWhJvUw80mLgzkP9WWbmnFmLYalCFJ/I/VeC8NkfclWMPfFxA5YDMocI7Sz1JgOtJgzotQFaWRjZEW1gr/rm2IljBmSF67CpyuayQnbjMx10iIWgzHcydAabRLMD8VREoMNvix5/3P7JwRuf1lKjFC7OcS5X
 Y+oeQ1rd
 LOW2xAGuauwVw3DfvCB44toEDPCLaXbH/E9gdbWnvqWvbyyRMbe9PHRpUG9phKBi+Q42GCNrGzKegGKkaxT21/8TD7Lhuyo9ZmsnQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 10:08=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>

Sorry for the delay. I addressed all other comments
and will respin soon.
Only below question remains..

> > > > >  {
> > > > > @@ -3732,9 +3808,13 @@ static void *___slab_alloc(struct kmem_cac=
he *s, gfp_t gfpflags, int node,
> > > > >       if (unlikely(!node_match(slab, node))) {
> > > > >               /*
> > > > >                * same as above but node_match() being false alrea=
dy
> > > > > -              * implies node !=3D NUMA_NO_NODE
> > > > > +              * implies node !=3D NUMA_NO_NODE.
> > > > > +              * Reentrant slub cannot take locks necessary to
> > > > > +              * deactivate_slab, hence ignore node preference.
> > > >
> > > > Now that we have defer_deactivate_slab(), we need to either update =
the
> > > > code or comment?
> > > >
> > > > 1. Deactivate slabs when node / pfmemalloc mismatches
> > > > or 2. Update comments to explain why it's still undesirable
> > >
> > > Well, defer_deactivate_slab() is a heavy hammer.
> > > In !SLUB_TINY it pretty much never happens.
> > >
> > > This bit:
> > >
> > > retry_load_slab:
> > >
> > >         local_lock_cpu_slab(s, flags);
> > >         if (unlikely(c->slab)) {
> > >
> > > is very rare. I couldn't trigger it at all in my stress test.
> > >
> > > But in this hunk the node mismatch is not rare, so ignoring node pref=
erence
> > > for kmalloc_nolock() is a much better trade off.
>
> But users would have requested that specific node instead of
> NUMA_NO_NODE because (at least) they think it's worth it.
> (e.g., allocating kernel data structures tied to specified node)
>
> I don't understand why kmalloc()/kmem_cache_alloc() try harder
> (by deactivating cpu slab) to respect the node parameter,
> but kmalloc_nolock() does not.

Because kmalloc_nolock() tries to be as least intrusive as possible
to kmalloc slabs that the rest of the kernel is using.
There won't be kmem_cache_alloc _nolock() version, because
the algorithm retries from a different bucket when the primary one
is locked. So it's only kmalloc_nolock() flavor and it takes
from generic kmalloc slab buckets with or without memcg.
My understanding that c->slab is effectively a cache and in the long
run all c->slab-s should be stable. A given cpu should be kmalloc-ing
the memory suitable for this local cpu.
In that sense deactivate_slab is a heavy hammer. kmalloc_nolock()
is for users who cannot control their running context. imo such
users shouldn't affect the cache property of c->slab hence ignoring
node preference for !allow_spin is not great, but imo it's a better
trade off than defer_deactivate_slab.
defer_deactivate_slab() is there for a rare race in retry_load_slab.
It can be done for !node_match(c->slab, node) too,
but it feels like a worse-r evil. Especially since kmalloc_nolock()
doesn't support __GFP_THISNODE.

