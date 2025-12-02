Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4ECED116F5
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0727A6B000E; Tue,  2 Dec 2025 15:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A5B6B002F; Tue,  2 Dec 2025 15:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA25D6B0030; Tue,  2 Dec 2025 15:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA0266B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:48:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8112A1A037A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:38 +0000 (UTC)
X-FDA: 84175719516.30.B5B9318
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7266D40004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuiBr+cx;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764708516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlLdm0xr33f+uOozOLCJ/7dj6Tplf+NvT4guSO4cLu8=;
	b=3b7THI/6AWzU85UC1+kH6aWghBTN9qelMsIjpy1PsblrZzLQgStzIknTjRaVxo2hJGfWbg
	TFYFEuZHkf+vv5F8az6RsnHVot8GfOPSKiqjGzhPpP2mC1f7WGO+IMgzLNe1sfsdrYE15z
	rFA5i6IWLnCiaT3Z3JKmWsN0WiwPkAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764708516; a=rsa-sha256;
	cv=none;
	b=UUYOEVWyMFqA4KDsZ1SpPvOOPjYTUNmNS168X6Z9027XF3ZvEnb/HOBHgpHENq49Lvt8KE
	MFvWSWd7Da7vVZeNHAQEkgCpIeBtTGR1hhe2Q6q5a7uQ3aWg+dKkQ/yMu79HbtC5SIdQfP
	JrbYtRVgjEXemxKgFxRkRHmkD1+rgyE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuiBr+cx;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6037144421
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CCFC16AAE
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764708515;
	bh=1Lrcev3D+Li1Y6L8NOFU/GX3NfDJn/sKppCSWEsCfP0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HuiBr+cxIJ8nRQyakng4SATH+y2pycoT4pza/69ZmqZaZ7acQ8AbVY15PSlsD2dgx
	 /7UX0PmPfuL9mowL6t4pXN0oTdXBpmXo+Ep+mnlKULJVJmpUAe45mQ00D3KKU1rPIL
	 R3FH810Uyd0ENnyT8mRSqXrrVxQJK9UAo6LunZ0KRm+TBJVkuS2RQkHDQsv9RGlbFu
	 /uXZvlIM0bv10Q3xBvgr1KF3M+dllpWjufS3HZUd1jVJ+jJHOFmnvDMp3Bf5Pg9QEU
	 6TZJORFrq10rLvYEHWjYwKad4q7eDcj/O9XxklVJ3qD5dgWxIXk/e8+DT2YDS21POF
	 1HRb691zsn0Zg==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78a7af9fe4fso54218917b3.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:48:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV3/McuwqQSmvpqNqehUslMwyhWFN+lemFJHhdBM2rgVVicw1ATzyFjPrTdV2U5K4XpaRgOr8DoEg==@kvack.org
X-Gm-Message-State: AOJu0Yx6JB7VVuX4lcAc71aIfs6gJFd8aupIsgk1y7esuutofYFpzlaZ
	EPqh6mXBt+ynpjZN28+K/uPxRP341q+GSdlpuQmLXsITkKR0ggESaYnDfjheCCRCgnbH1zVvRU4
	/Oau+/1YQMdAPwlh7Ma19+oxacgqkq2oYq+Fka+jftg==
X-Google-Smtp-Source: AGHT+IEbd92BVnqEvJim/6dj3oTKmqYqXB6Xts3P73lOk6qTHCE3ZRyxYvG3z8UZomPx5EBA3Q1QwbVyw3c7I1rzOfo=
X-Received: by 2002:a05:690c:6f10:b0:786:4fd5:e5c3 with SMTP id
 00721157ae682-78a8b55950dmr352624247b3.56.1764708514189; Tue, 02 Dec 2025
 12:48:34 -0800 (PST)
MIME-Version: 1.0
References: <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
 <20251201164338.GA430226@cmpxchg.org> <CAMgjq7Ch+M21W0YH-edngSYVfb07-m-bVq=zTenF2PLcAPt4EA@mail.gmail.com>
 <20251202170222.GD430226@cmpxchg.org>
In-Reply-To: <20251202170222.GD430226@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Dec 2025 00:48:21 +0400
X-Gmail-Original-Message-ID: <CACePvbXn3DbFbVSdqk2GUU422HhZN0ALrvsHVeT2B+vMCDgR-Q@mail.gmail.com>
X-Gm-Features: AWmQ_blONYKpzWWmUadgQN1nmeHsxso_pZyvEsMCKa9DQx4-AEYlBBzvV4b4znQ
Message-ID: <CACePvbXn3DbFbVSdqk2GUU422HhZN0ALrvsHVeT2B+vMCDgR-Q@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, YoungJun Park <youngjun.park@lge.com>, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7266D40004
X-Stat-Signature: k9z4ermb39x5kj3gap1y9faec9jfmbgh
X-Rspam-User: 
X-HE-Tag: 1764708516-399120
X-HE-Meta: U2FsdGVkX19bMFVDegNI01i99MO06qS2JneInM+HGT0/eJwl9Mu1PzBnTE6NrikygOSNKBlXjVkWX2/ffBuLgcP7d+EHPuwY43DwxDIitvaNvplUSsVeUT57m4iy2YxfF+l39I0qmbyOuo21XYzxphITvLcKUBLbrA0gT4BH5MNnV0q6MTXRDYwe3kczsw0d1BOyonJX8sNuamicCVM49zuOB8L37qyxdP+jg4/dmIg/dRIzPGvtsA09n2+83VQYPlU2nefEhDYvjjphdfNvCUeKk5tgwJV/mb/FIsPI3Ddi+BJkzhwzHnpEiFVOi97Xolf5bDwbwhkBpb4MKNhGongTDQIqoRwMnl0mZ7IABufxldjTOkyHenl+Nx4VKL64xYElyhKfi/VaxYzgLvTy1VHA+NlW1G4nXRsLa5UeOQj3QCsmpaSBrA00PDDJ7e6qCRMNAps4vkBcO5XBbzVS0E44hpsLozkNM+o00yYK9PkknpzCw5TYt3SvdR7tKMY1zWruezFE30WkjEBKMUh14jit+IFVDCgfHsqFisNFniFwFPVK4S3pHArAvf2pVjy7jiqHF3GpT0RU0+crkTZejoy8mHhjmXwhd+kZp6QdgiUvvCtF1qBqyO3r8ZNFQhijn37RvyXPZwTXGSvdWj/NYuLvSgxeexBobz8+6YqVnhV0pPriCjpJlmzLLBxN8eda2R3uVgx9DMUGDI7G5/KNIaopeAHNiWlc9xPN48ej2lqzLDqNQf+0tTvv0IMG8+hyyyAzq5IYafyeg4gefHyOcMkYqJ5zz3mcSlvYrrg/pLCi2vALJ6mmP/keVAF6MwdWDK9Q9E2luLnNWHhAfGXTLa8l9OAcdTEJC+k5aM42ldZmc0Tb3uHwGtpMQejUB8MQbJrb/igOeHEktEC83Hl/RtISe1YvKOQ8iI9t0TGJYo7ZNC27IAVBkhSNGX4+hVj0Xhf/kdm8i3nroLLDTV7
 xD71qBU4
 ZRDxCzvXWA6pBHeDD80y1roD3ldS8LsCsXZnGXRUqe/27bxn79BQE9sexcJ7QFpF1EZphLz3IyowqoG3RTQLN1Lgp5esdUvNgCEWdcB2Z5JwUJN19LaXoYrHBx6t5fjKqpOuOoI6Ob99neAjDbhiWnoZrnqTufrHKzMmTFabASu/2hv/eDbIM1BrJG6Mik1IVP6NCV4woVNF+Y3G8H+r58LatFThEUh7xwOyBHtFWHJBQKYDVUtnKZpb2SaTvsZV5iHweaTBDGbMTwe8+vQnBS24hbZS4w4Wwck/1XgA7hi+8R+jzUMjMZ9zfcjw7vlF+Pj65arGBRTeo8PUCWDZwfoLS5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 9:02=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
> > It's hard to put a penthouse on a sandcastle, and maybe that's the
> > reason makes it hard to describe or layout the further implementations
> > of swap.
>
> Sure, I can understand that. However, I think the conflict is not
> necessarily about implementation strategy, it's about priorities.

Right, that is why we take the more incremental approach. Cleanup and
simplify the swap code in order to make later stage things happen.

> We have a usecase. We have a functional implementation that satisfies
> this usecase. It was sent as RFCs early on to gain consensus on the
> direction and find the best tradeoffs wrt other usecases. These RFC
> threads are the place to voice concerns and influence direction.

Speak of priority. We have a more priority approach by incrementally
landing code. The priority reflects that we are actually landing code,
improving it towards that glorified goal.

I have already expressed concern and the 2023 LSF swap abstraction
talk the community already picked the winner. Not the one VS is based
on. Rebooting that without addressing the previous concern is a waste
of everybody's time. You basically say the community picks the wrong
one. Let's retry again.

> Both Chris and you have stated that further swap table work *may* also
> enable this usecase. However, at this time, I think it's also fair to
> say that it's more of an afterthought, and no concrete design or code
> for how this would actually look like has been proposed. High-level
> ideas have been floated, but as you can see from Nhat, Rik's, Yosry's
> and my replies, they don't really meet the necessary requirements.

The VS doesn't meet the requirement of upstream and other companies
that do not unnecessarily blow up the kernel memory usage. One fight
at a time, sorry I have to get the VS out of the way before I comment
on other aspects of this patch.

> This is not some principled stance. The virtual swap patches are
> difficult to develop, especially given the current rate of change of
> the underlying swap codebase. If anybody working on vswap had seen a
> plausible way to solve these issues through incremental swap table
> improvements they would have jumped on it a long time ago.
>
> It's more about priorities. Combining compression with disk swap is
> extremely powerful, because it dramatically reduces the worst aspects
> of both: it reduces the memory footprint of compression by shedding
> the coldest data to disk; it reduces the IO latencies and flash wear
> of disk swap through the writeback cache. In practice, this reduces
> *average event rates of the entire reclaim/paging/IO stack*.
>
> These are higher-order overhead savings that are difficult to beat
> with first-order descriptor and lookup cost optimizations.
>
> We obviously want to have both, but they are orthogonal goals. You can
> see how it doesn't make sense for us to deprioritize the former for
> the latter, or why Nhat says it's an apples to oranges comparison.

My advice is that, make it incremental, come up with production
quality solutions.  Adding one layer of XArry to redirect is easy. The
hard part is how to keep the memory usage in check and perform well.
The posted VS will give you false illusion of progress because it
doesn't have a clear way to address the performance and memory usage
problem which can meet the production quality requirement for
upstream. The upstream kernel is not a toy kernel.

> It also won't work for one party to say "we will fix this, give us
> time". Everybody wants to advance the thing they primarily care about

Exactly, the same applies to VS. Even if I can spend the time
convincing you the grant vision and you are buying it. Who guarantees
that vision can be implemented without the surprise black swan
assumption that set us back to the drawing board? So landing the
actual improvement is the king. That is the real progress. If your
team want to get the result sooner, helping swap table landing would
speed up your goal. Once the code base is cleaned up. It is much
easier to move in ANY direction.

> with the least amount of detours. That's where we have to find
> compromise. Either let people pursue what's most important to them, or
> lay out an encompassing design to build consensus and organize effort.

This is just a development methodology, a personal choice. That is why
the swap table is landing as of now.

> And yes, let's please stay technical and on-topic in these
> discussions. Let's acknowledge we have interests that overlap, and
> interests that do not. Then find ways to service everybody's usecases.

Yes, I agree.

> Disagreements are part of the game. There is no need to get personal,
> pull rank, or make accusations to dismiss somebody else's clearly
> stated usecase, perspective, or objections.

Also agree.
>
> The best way to avoid this is to make technical statements, and reply
> with technical responses where those statements are made.

Yes, exactly. That is why I want to get a straight answer about the VS
slot overhead number. Writing a grant design doc is a much bigger
task.  It will put non native English speakers at a disadvantage for
writing the big design docs. A lot of us don't have the luxury of
contributing to the upstream as a day job, me included. We do it in
our spare times because we love it.

Chris

