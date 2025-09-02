Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4732CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 06:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F179A8E0003; Tue,  2 Sep 2025 02:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6758E0001; Tue,  2 Sep 2025 02:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB55D8E0003; Tue,  2 Sep 2025 02:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C882F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:52:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59BCBBD4D3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:52:24 +0000 (UTC)
X-FDA: 83843391408.19.88EE6C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 420B5120008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:52:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7gFHxYF;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756795942; a=rsa-sha256;
	cv=none;
	b=jIjZFD6JczhG1ZSNWIUZUFC09vx7+JwTYZK64QzvQkRRxPSXgy7TkRgACySw5lpRFN6Axh
	npow+ffysxAdAVyGIMgeRy8UsPIxB+hyeDM6M2E0fTa9AlnM6V3HYObJl6XDgI48ZBUTYa
	AWFhE0RldCX3+b/H3xYwaa4mNQpCNMY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7gFHxYF;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756795942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DWKgFI6fKONtfjhCnTBOTxTb4pPDjleeoPeM758QIk=;
	b=yzW50fssDyv1LCHS+/O1zXNwOewOJmcUtO9y+OZR2BYJhkjcQrNnLgRjRZCAU6tEQtKTlc
	NDVXIIh9/MSQSLmgyGoXseq8e6ywHgND8uU8ev2b3r4/n0StC8kqN3gl4t2UYjnRYJzdt7
	H+aq7iduMS0O8UC2M4NeEZJsIHkBHAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDD3F44939
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A409AC4CEF7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756795940;
	bh=6wl6cmFHceRAAEs+T1LUMeqQQEIvnM/lh5zH61vEsBM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=R7gFHxYFb053AS32peRwBAjn8ZYeNhT0a6ZCC7OAfM+cQKJEvC8k8w4A/VNn8fnTr
	 hSudmvEhdmAJC37voINtF++4d2V38su0rlaC8xt5sPEdFDcgehI8xVTa8mTuR7XD2k
	 zweUMNMiN2TQq1GQUoI1cE/GhlzMzrjRWjaJTsJo/cQanGJyCZvyUPnmT0l+bYh6jd
	 LUzdNBDUy0cmWt3TiPfQjfVc77qazmEXKW0qZ5NqrprLpQ9ImUxyg52Luud+AB+3HW
	 uI4RjMXF4UWd9397WFoLug+cNDHO5AJwOUuv8dknyjqAG9Wff/NXIgxRJxeRj2bX+z
	 XERzxjlT05UbA==
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e96c48e7101so4356015276.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 23:52:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCvMcjN7v91HnM4OyaZPzhxMv5EFINh9RVuuVjxPZ3MVQ3BiFSNSuWOU+G/eyD8B35iV6AkAxoww==@kvack.org
X-Gm-Message-State: AOJu0Yy0I7TElMcYwKBcQw6Sgp8vw2x+cmhIbmBHL6aL4OWxrSZSRCed
	3GrP73w18jiGhCcgJcYBppXnW2hvK+pHWAerqirRYw/pQjqDIn1tBo6N0EDe4XfGE+4aOHlh9QW
	QWiH/6VarGNkEnpGqOgDTHf8bFMWLYMQTQylq3wa6cw==
X-Google-Smtp-Source: AGHT+IGzRpgkehqNIOLRAMXCcfmGGF3mxatyKy1pNHfvYlAI6JF4EfIHPF8w6zxyPs3mXt6v7TcBX64xqhBWpaUj9OU=
X-Received: by 2002:a05:690c:9c0f:b0:71f:b419:8f6a with SMTP id
 00721157ae682-723ae3b3444mr4530277b3.38.1756795939830; Mon, 01 Sep 2025
 23:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <CAGsJ_4xoN35Av2H70o+dwGzhKrAnm7gppEseG0MgAUPQt2TygQ@mail.gmail.com> <CAMgjq7Au2n7PO6yb7wyCJbvFceGj6cpQCp+kVTewPjU=WhmXKQ@mail.gmail.com>
In-Reply-To: <CAMgjq7Au2n7PO6yb7wyCJbvFceGj6cpQCp+kVTewPjU=WhmXKQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 1 Sep 2025 23:52:08 -0700
X-Gmail-Original-Message-ID: <CACePvbXWSCm0M-c085ss=ys9XGePQTHocFGfUSm_ZUbemAZwOQ@mail.gmail.com>
X-Gm-Features: Ac12FXw1E3Nb8_UZtKM2TaG5JnD1427eK-n7xw8pepASNKmzu_t-q8VbeCXEYYM
Message-ID: <CACePvbXWSCm0M-c085ss=ys9XGePQTHocFGfUSm_ZUbemAZwOQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 420B5120008
X-Stat-Signature: q78bs3mm551f7aetixmoogig9bcicux1
X-Rspam-User: 
X-HE-Tag: 1756795942-374416
X-HE-Meta: U2FsdGVkX18qeCckXnFG3mAjhMcIEsoeb5NWsRPqWD/VlWRA2g9lN8axxZv+PTs1C8xo0JDMscaNRl2al4gqYV286DNYpr7zNvRQH1a+djovbCHCy7PxPYCbqPxhIdtR5fJt0VtOHWPAfYEdsGc1MAqd2vROYUSgaqsG3KTs1zs6CgYlWRW/oijkZHyc3T+2vvil8zKRUf9GrbYJFzqMc2Vbqf+HT4YgA2hj1/kR9X78aoATxSnieu14aQ87ITrLR4RB/sZxQoQC3PFtkvMg2XD6S/yfulAt66wMwEh89afjDkgX8CNNf3UVgN3S2ViBdBgF/IAyZsRzGBk2FLP9QinFQz/w22CM0C/d6OSKpcFn5NGFw8Ur8TVMdxiIBA/vO4Eq3cSJQ24zSI4JsLddUz9WY1yW9leXhswkCJtqng+zWyRCtjacQHV3r/HOkDzz11tvm1lsWHO24k7IAmlZ31RTacYI6dQqPTo76xVz92Gaj5l820Zi3EpulHKyLpQbpqhDgfazaSUfblTrXWigRVJchKf+HeFhytPqNkkP1wQG4I4CDOSWkkoaNMhQwq7S1/J6Tw7yVlEAZhMJy4lTzFpwTfQWlkZxBnyIFPQuSx4mcIDeOexHlJpSszFrZIBk5c0lYHfF8RghQ6bWxHclWKysKGXs9L2I5cu8jzH2/8qfqljvwosPq47tC6Erve37agZtjz4D0hWX2SB2KklVmZZeg8NHE8LHgoffO8M3J8PGMuJnLaozDybqG8X7/x6aNAHg4nRBGVARL5BYWhBhErvNY/ZFvbCk/l9uBAKKC/quG7zEcNSW9FRfLeqOOfEyMgVninhnwyTJVnGyitHMwir6Lg1TM0JeTZevJNeUYdIEvvg/+lE5K2zqSzNBm4Xt+z/PAVUCdwiW61mkCNobjR+vGXs6lHM1x0FEtKYcQ+u+rOGU2BGLdt0waGlie2Xo7eILX5J+0a3cJiaJbY9
 ZxGBIt4W
 1fBbl1ge66fLrcdWSXwPZoKcd7S9gzTiXJFmIclMIFSntF5Ph0wxswXt+zlv4/Y1WTCYb+SluxNhC6denipZEU4UU1+3kThStaVGj2dwfIxg0HZ1xqjGk3yF88DcYIeJ8QYz/f/1tsHnZS7hJq+pKcdyjGJ7skfMo4htM1JsFti+U5DDqnS2rDYy1xtsVYeMK3pUNqkvUFtOLL+ekPa1Cl3o7Ysmz7j2MjfZRl8dkRp94vYnzbw0aXyw6fEHux7oKWoiAbDt43RvZE6spHXjFeruITTwqvR3Vaxtq8d9s3eYbmUXHzzSsvJiLWKAA/xxD/y0OflXsOJ5kXnG3VZbx5kDujzpBAUW5q0hK6ilyXLE8KMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:13=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Sep 2, 2025 at 9:14=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Sat, Aug 23, 2025 at 3:20=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Always use swap_cache_get_folio for swap cache folio look up. The rea=
son
> > > we are not using it in all places is that it also updates the readahe=
ad
> > > info, and some callsites want to avoid that.
> > >
> > > So decouple readahead update with swap cache lookup into a standalone
> > > helper, let the caller call the readahead update helper if that's
> > > needed. And convert all swap cache lookups to use swap_cache_get_foli=
o.
> > >
> > > After this commit, there are only three special cases for accessing s=
wap
> > > cache space now: huge memory splitting, migration and shmem replacing=
,
> > > because they need to lock the Xarray. Following commits will wrap the=
ir
> > > accesses to the swap cache too with special helpers.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> >
> > Nice! This has cleaned up the confusing mix of using
> > swap_cache_get_folio with VMA, filemap_get_entry,
> > swap_cache_get_folio without VMA, and filemap_get_folio.
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks!
>
> >
> > Do we have any potential "dropbehind" cases for anonymous folios?
> > I guess not for now.
> >
>
> Right, dropbehind doesn't apply to anon yet.
>
> > __filemap_get_folio()
> > {
> >         if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE=
))
> >                 folio_clear_dropbehind(folio);
> > }
> >
> > Can we mention something about it in the changelog?
>
> I can add some words about it in the commit message. One can easily
> tell that if we want dropbehind for anon, swap_caceh_get_folio will be
> the right place to handle related logics.
>
> Now with swap_cache_get_folio being the only place for swap cache
> lookup, and in the next phase we'll make the swap cache layer the
> unified way to do swap synchronization and never bypass it, maybe
> dropbehind will be easier to do too.

Thanks for the cleaning up and unified swap cache synchronization.

Really appreciate it.

Chris

