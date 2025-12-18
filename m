Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B213D6D237
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833206B009B; Thu, 18 Dec 2025 10:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EBF6B009D; Thu, 18 Dec 2025 10:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7347F6B009F; Thu, 18 Dec 2025 10:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D95F6B009B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:41:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36D59160265
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:41:27 +0000 (UTC)
X-FDA: 84233006214.15.DB171BF
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 316A52001E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:41:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IbzQqjBQ;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766072485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQYFHEK9Tm8YWqymq5JN++Nt0lXCgB+FVI1O7lCYYs8=;
	b=gmspwEATge2iPugElJJ7WqQ0YZ48KSJmHtsh4pG1SzdAd46Lc/s6xQpTBgc7bStWDGHKWl
	r0aqynb2HGwqMCjmg2RseExoiTr7Yo6Bb880BSBT6Gifx9FHWPedmKbX2e0/BY/bqh+hy7
	Ae3tLOFXZOKetMNISy2ihM/ife4Sl7k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IbzQqjBQ;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766072485; a=rsa-sha256;
	cv=none;
	b=XOFlL/svesKK4xJAooFHor4JY+q0JudFRMAMd9HA0NeAQ9Hh41AXTZzhI2H8FklDhVT8YE
	s/fHvp/2VH3xGeQVfauEOpUo6MGNziWDPNks6fc8NJ8vm0k11CEjEskAdFsouj30lY6JS8
	33QcqlzHnbfL1Y1PhnD4ZbrpZt9Nk3M=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a2b99d8c5so5394166d6.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766072484; x=1766677284; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQYFHEK9Tm8YWqymq5JN++Nt0lXCgB+FVI1O7lCYYs8=;
        b=IbzQqjBQK285kf8A3Lig1S2ZO9vW3VPLWY5sW4ve2xrns0dwxQaoIxBgTgNZ7tYu08
         04Oo2SrNp+2rfs86QfpVILvJgVwBV82cqLxXCbZ/mk+wXR+js+bq9t7w3vzQ0JU5eLC1
         kPnFhKSeEQpSVzhz8k6H4+Z5AELbD+Y0k9nXancTp/8qFUUdzBN+K6KqFLh40pSH3lIs
         c6ohuD6qjTl7BsB3p8b+V8JvUinxRFMiO7p5Kcc0/6AyuPGnctiK4EdZAtVn7rE57Hri
         K1/b68LfFQse/VFlOvYpTr5Pz7BRdwFwFKHUFu8VNwQknoBBPj/D7jXmHvPbX8VpPfb/
         sRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766072484; x=1766677284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQYFHEK9Tm8YWqymq5JN++Nt0lXCgB+FVI1O7lCYYs8=;
        b=rRbnbK/icf10eBZ0UQORKa7uEGU8Bil7VvtmG3VfiOah776+cqdDmqFK19nA5opgy3
         2gF9h6cGZCgm8JlEgQ31K3RDEXSC8ezHSmeoj+yBdLoGNgjML86/DhGRNaNC57cklivH
         uyzAknAputvqsU1nCqPmWPZUNr++PuXFwvoNTs8EFzJl/vSToPdhVs74L0TYeWRHVTw6
         a/66qOnn39tU3EOj/Md7fr8uAwByu1lCS265TcOO7hcbupEUEJlRuGfAfsANn0zUnBeM
         U0/BvhUBcruRId8BwvdShKOzTjTzC0hHCZxbLwx8vQeygkWZp3/63nxQbioxdJnggdeW
         v5BA==
X-Forwarded-Encrypted: i=1; AJvYcCXThgA1OEmXOUJl6nil51GQdzaURRuTNnw5/EL4v7zaTwjOWasn6wNX4ags7Ytfm/jUEH4f51hXxg==@kvack.org
X-Gm-Message-State: AOJu0YwxkjrGg9JS9NqazZb5qvEsxH3bOfQ6CJ30mbqLjm3fuYuzvXVM
	WIBg+bz+N8PhHBAez6otRgKYg2H1LKYLDIZfAe2m720yHO7gxOfC7Bovg4iM5JgC7HU=
X-Gm-Gg: AY/fxX5Nu7v2xAoXwup2Jj/l9l0Ogl0Fo0Fa5t30Z5YBnBAcXQkAA0G/aMQwD3RMkuj
	JFkyWSZLNqjHCElsAFoM5nFB9fvbk67nR31dumsvagxB59sxIZEJp9cQlEp6vDNNIEqcMhX6M9S
	YfZwBbGQ20MI9bNoXRyHOVjRPcouIicF3NX/tPu5+8GoZZkDzeceWnYAw7yJBq93qFzKqFcGfYr
	5pcrAz7VlnyjXoAeaY1eYQqcJPTFAmsL5RwGHUtg95ED6yeZtUcJrwwDF+H/iuP4MGSTLEBmheP
	M+WApmArCZh32uwRUQPnHWPcJduRyT4LKKcUYMWmYNhSNd+6/q1uNrw+iyh9xow8WssfrSgYAY+
	ZuUA3w/qnJIR/roXUJWjyzhVfre0X6ERDGrhGhuqjcWLNbharahhGbqOFvSJKU2OFZN0IOckHOw
	PD8JpluAcNRmvnZUQjsz44A67c2xcOx9lSQiKUHq/HEQVvgRDEcO63eQUyKVDDwq20kRn10g==
X-Google-Smtp-Source: AGHT+IEhf6FIJBZ7lZJmuG8C+UcVaOo2SfADiXXl3E8f8W7HlPmfbAUOtA3YMxUDzV/Kzt4JsHqtvA==
X-Received: by 2002:a05:6214:c2e:b0:888:8047:e514 with SMTP id 6a1803df08f44-88d81278a7bmr1222226d6.5.1766072484119;
        Thu, 18 Dec 2025 07:41:24 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6089a329sm20455596d6.33.2025.12.18.07.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:41:23 -0800 (PST)
Date: Thu, 18 Dec 2025 10:40:46 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, x86@kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUQgfgWPq4ppMw9r@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
X-Stat-Signature: gpfy5hbui7j7mefmiku39x1omugb8dcn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 316A52001E
X-HE-Tag: 1766072485-591925
X-HE-Meta: U2FsdGVkX1/jtu12hMGcFGHfKZEuXlC/cuFfPKO0mCpwu+n/VDEdJ3wxtmKBtJevoIqwbXdLvGl8kLVPkUpK48Do7crwGoPWPQd67lZDW+WWiNCEexdb8LrKoqYXXKaMEfpqkmgN3fO+T0R32f8eRxSd5M06IeiJojCCbRrCM6kWGGl7qqbtvJ0Iwx2kLtSEAmMyEQ4eqgJ6MkFYNEGQaw1rdLaOmXnhpU/LdDUNmYqYK0nDnPSQdfcd3JBTTLZc6d1zs+LvLLtUpfQ7BTe2yxzvcb6oq1Zd/Cy73QSNr6DYBS4wUtm3n0Oi5R60aSjVi9jdnD+E4S3s7CXHzBGiH4HgJAt75rUfTikYKW5ZddmdW4JRPtUr54aITxIA6tswz461pFlG5RaDYGInvcKVux1d/ShSoPSJwznbhI5RXdM0OMOO4yoRV8qmOK6IA5mFEQ7mAdSvOgC+5tMuQ5/sCNgH54vQz0vj/CMQi6nGCi44QTYJhK4+6Gwqsn8pp+YOD8Tpsmx7sPvOU/VhNoV1YZDnMK5bHiZygBcfS2ETegC3FAlQ0q15ELNVML6RvoQacl/bVq05fIrdz70XiNbQzv3Ct371L+Cqq4q/Rww7VEIcwW/JnUUF95ruQ/A8bUeGINNW625cqmcu6i+a0h2uDns283DPNNh7hWFgTTVJrA3SXNCJ92Qo+bneK4Q15/1oUsuPydsCsV3UcMnaAB4jidZw67J+AiZTxPqeIwEhVbMabrlZUq3M2fk7jUBT28q78C0kn5M3vNTfYo2vITdRHBtVtiaZQ09y6dn5o8ZQAdb26FUGc+hrR4272/VdFvfLz4YmG+EMOKlzitP7kljYcUj6xDUIp2MhKcEzkZbJhbNFnDmMLwGIoO1Bsbo1CgtRHayRmdb++Yj8rUjFth2bMSnZnWoZWrp4K8C8qFuS5oUjleku94bKONBoqGRb3dJ2tu+F7pR6jKCEPgY9tVN
 yi4toDo/
 c2Rzah97Um9gbUgRwt0+PAY3EscThLtgbN4Ouv/LNtCRWZpu+IpAJtDdV1EqGdlGqfTbkD53ny+OvHPikaNWsAKXdMhVD/YR3C8w+zkdY+yXuPgkaXfRjI7FHlp1UfXCGXWn2tA3EV2mM+ROkyybHxxLI900xeJOi0bnF9Je9fRnd0gu/e4KaNK96iSrdkR0h1ZO24Eaq9GbIaQdRCqgWmqfrlbdSR8Jf83eNbcCNn9bv4rM6o6TvR5kiog9wEk7srFCAIjGN3Kyo8L9MTRzsCmi38VBD8h96Vwp7MnDooSQCN6ZjYTPm+eBpKX0xnqViNlHMtQh0CO7mkKihrgq4XBO488Lh4n1Zix1oDyB9Om8aFWCg2Prr+70s5OnYmlLW54iLaNA/BVqsaEB6YofzI+nO+RRVZ2UmE5E4h1UXbes43MqnAHLAFNxrDwRjuWo/8hxgLp8o2aVzhhlwkl1c2qBCj3mmsMVG2Wg2+iMFl00wzpfyJGvWcEfBmumNX7SVgf8q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
> > Yeah, the function itself makes sense: "check if this is actually a
> > contiguous range available within this zone, so no holes and/or
> > reserved pages".
> > 
> > The PageHuge() check seems a bit out of place there, if you just
> > removed it altogether you'd get the same results, right? The isolation
> > code will deal with it. But sure, it does potentially avoid doing some
> > unnecessary work.

In separate discussion with Johannes, he also noted that this allocation
code is the right place to do this check - as you might want to move a
1GB page if you're trying to reserve a specific region of memory.

So this much I'm confident in now.  But going back to Mel's comment:

> 
> commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
> Author: Mel Gorman <mgorman@techsingularity.net>
> Date:   Fri Apr 14 15:14:29 2023 +0100
> 
>     mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
>     A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
>     taking an excessive amount of time for large amounts of memory.  Further
>     testing allocating huge pages that the cost is linear i.e.  if allocating
>     1G pages in batches of 10 then the time to allocate nr_hugepages from
>     10->20->30->etc increases linearly even though 10 pages are allocated at
>     each step.  Profiles indicated that much of the time is spent checking the
>     validity within already existing huge pages and then attempting a
>     migration that fails after isolating the range, draining pages and a whole
>     lot of other useless work.
>     Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
>     pfn_range_valid_contig") removed two checks, one which ignored huge pages
>     for contiguous allocations as huge pages can sometimes migrate.  While
>     there may be value on migrating a 2M page to satisfy a 1G allocation, it's
>     potentially expensive if the 1G allocation fails and it's pointless to try
>     moving a 1G page for a new 1G allocation or scan the tail pages for valid
>     PFNs.
>     Reintroduce the PageHuge check and assume any contiguous region with
>     hugetlbfs pages is unsuitable for a new 1G allocation.
> 

Mel is pointing out that allowing 2MB region scans can cause 1GB page
allocation to take a very long time - specifically if no 2MB pages are
available as migration targets.

Joshua's test demonstrates at least that if the pages are reserved, the
migration code will move those reservations around accordingly. Now that
I look at it, it's unclear whether he tested if this still works when
those pages are actually reserved AND allocated.

I would presume we would end up in the position Mel describes (where
migrations fail and allocation takes a long time).  That does seem
problematic unless we can reserve a new 2MB page outside the current
region and destroy the old one.

This at least would not cause a recursive call into this code as only
the gigantic page reservation interface hits this code.


So I'm at a bit of an impasse. I understand the performance issue here,
but being able to reliably allocate gigantic pages when a ton of 2MB
pages are already being used is also really nice.

Maybe we could do a first-pass / second-pass attempt where we filter on
PageHuge() on the first go, and then filter on (PageHuge() < alloc_size)
on the second go?

~Gregory

