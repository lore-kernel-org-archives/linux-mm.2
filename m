Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A147CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C271A8E0022; Tue,  2 Sep 2025 08:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB06B8E001D; Tue,  2 Sep 2025 08:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F248E0022; Tue,  2 Sep 2025 08:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9581C8E001D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:50:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51667C0120
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:44 +0000 (UTC)
X-FDA: 83844294408.03.219E651
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CFC04000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBEujoMD;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817442; a=rsa-sha256;
	cv=none;
	b=5wk3W3hxkl3P934fn5HKRjS8BGawsPj33Z6T+5mJQrc3PVEPsoxnYZBRz9OZLgvilIkuNE
	wQpmxrrGG4N0DaMglJPLzFB1qZcdi9s1dzj7IUSClFfggeqbJvg4dlUcX38KoPTr9hThaJ
	e545Kp7BhYpoMSoNXzMidTka4ROOmyY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBEujoMD;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UHY+NiyY4gVCdz6M9f2xN2PNjs2AgATEY4XF7MF98Y=;
	b=bXdvboRFFqhmVcmQhxg9B1ivFi592bdDQ26TUXVAr+vZo4/FMcU36VkP4NPSjJxQjkQy/B
	TP8x599bR08B1h7ahM+OdQA6+yGFMdM4djztYKzZJufM3xH/i3c3zZ/jjQavtZfYDEe8+z
	lNTdjC0gzrqig/lN53eUzX3Q8N1HBLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D6AC44634
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A47BC113D0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756817441;
	bh=qtptNUL8d4rhr8+RJ1neEPE2bGDD2Ksu68uXBEjf0Tg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RBEujoMDrKCKRavtx6n1+N2Md6Yyu0iAykIwwEjBUppN2pstys2YzkyPmf/cUfQAp
	 rq3A1DympA1Okn5Jzv/KQkmbbQo4LVkxSrLxEV/vWni/C/URusk2q4QAEwjOYQaRQ7
	 CNlNwT/oCHzLk4y7hi3rT8vWrj7JHl/JoM/Vbn+Z+xcKuuV704DjNgJWSPre2TjWXG
	 3hVUHgl7xH7IUi8zIM1yfPB6y8T5Y48FnLHHs5dQHXfbwOPGkc2lDyDZC2tBGQDgZ8
	 KtM+nf0bUjh6OgFBhDRkQ/cKgYbwesFtNFMZ9iuefL7zPYIMZjLB8FC84TSkQM6YWB
	 MLp+arQ32E7Tg==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d60504bf8so46404307b3.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:50:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0NzcPx7YTcW3Ugb9iv4bW+XaG7ggshfA1kTX7tVIhg25FIq4FPm+p1kGqdkDgQvr2NDdpd2bvwA==@kvack.org
X-Gm-Message-State: AOJu0YzNMyiehhTWu8ccyIseqTP6Drt3vYncFmVsxHkremblIGa/Rjud
	ciyp2BXx1MUhTDf8j76Zbeu7/rosoeDBmXRaJ5+hc3zL9cYYSMy974eq3fJxUzwFSYnn5nuwWJG
	FhzXOacyZVB5jJ51PELg3MLDM3FfDvyzpHT5zrDO9sA==
X-Google-Smtp-Source: AGHT+IFVXBziZnAXtY7UJyF4jsrXraoffuaNWH6DNadyTShnx/MSIVbICVBeT/+7TTzFGz2dzYpxMqBWI8MahuDUmOc=
X-Received: by 2002:a05:690c:dcd:b0:720:378:bec2 with SMTP id
 00721157ae682-72276511331mr119403207b3.33.1756817440419; Tue, 02 Sep 2025
 05:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-4-ryncsn@gmail.com>
 <ed486d6d-1664-43b6-9d5c-696305f833b1@redhat.com>
In-Reply-To: <ed486d6d-1664-43b6-9d5c-696305f833b1@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Sep 2025 05:50:29 -0700
X-Gmail-Original-Message-ID: <CACePvbV=iR=r3rR8Xov9B9ntgG+XXM4jwy_bhGzUQmi8yWzpzA@mail.gmail.com>
X-Gm-Features: Ac12FXy15-vkRjE13xZWnbwl5FOzZS_8Qv0OdwUQBfi8tnkwI6upzb-z1-HyKYk
Message-ID: <CACePvbV=iR=r3rR8Xov9B9ntgG+XXM4jwy_bhGzUQmi8yWzpzA@mail.gmail.com>
Subject: Re: [PATCH 3/9] mm, swap: rename and move some swap cluster
 definition and helpers
To: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CFC04000C
X-Stat-Signature: nhttq6rjbdmxktbu7ntedw1g1ugx95an
X-Rspam-User: 
X-HE-Tag: 1756817442-841106
X-HE-Meta: U2FsdGVkX1/oSBgm+8ULQYzP9Z4+1IpfHxahdudFL6c8UsB7pbdJ2jzgAHQFMPV+gVeCqIvEwwmeHUfEKoPCYbqa2wC4qiKO4RHSRlFxYddPrNNJgGhn5f2ZsajrGRdZY/1RPTY/TxFEvdBBhoJsuzVRGp0Z9i8CVG3LUfTmbKTsILeR15SW7P/dGJKc9FPy1MmtOy6RH4sKlQ+zPqiT5qnfD0wHCfKYjKSMOnaka8Ix5jbhRs6zB9bZfWppp1r1teOFgZj+Y2iORbLAX4C1aEi+uCHQgEjfHl2nVpSAk3XsEAJ+tfNSEnIlMcdavvHt1F+x7YFeIjY2iCgDie9fHeD6VLYBZuCc+pDTb00FgKOMBzrzr6vWebWseBu8GcT01hvAYYpuYJqmlewCQB9CfdIUG5RwHRtvNOdYIjzArYKdYVOunZbU0PA1lo/c+3ZuKrw244v1sR8fwJjicmYc+4ygTs7mfcr39j4+NgcXoVu5pPeO3UkEWpRtaUDG0f4LMlNvdnkoy8NwryGZYxGLoBJK+IFIi7PncQZEN69bP1JvehJUGrwOYXUZvhW4k9RXbaoxhkKyRvofVwjlbTupViFMG8IM9mcGj0GTuS4JhArR+ytA+M4Ra68RqNChJg5e/6HOxRq8NMAiKOigoHpWV1SRMQZrqhJbYn7rnWK17uiNAKqA/znYp9r+XkVPUJ+7PmewyDLRkC0yVJxFIG+F+KxkCZ0EjSVaDqkuk7SvepihqsvZ7jzTs+2iywTS27ATFTI5swEeOfZn4tES8zd6sGhi7c+VBMhnYdEu4Mhe5uwM9zWTLlxVvf/A69G3T9lCqo8QIvFbaccQUWwFoY7Pcdy94M1XHAbkzyJHlelxvWSuP60s3hWxbnCISyhncccwkuvXK+kJgHe1x+NlTvA8IIVxz109JZ/78NagxbP/HCvIo9/ElxeCAlAkW435Hf6jzlfEQf0I9qqJWav/sAx
 y5fph1gz
 JoRqNq/IqU6FK9pg/6ITjFifOJCG7ONkDn5olFDy6F8Gc8cK3Bj5X9B9nyLKnnFF94kxK5E/HWjDhDCSKVcFFwavASn9VxRmxZ4INrhHtK7MU9rxrt7LcGnOwwrk+GfL4CwfpYLOVIP3SKYN28EhDMWKDcffMKjdMbBAI+7+lyvdHSNr77WLI9HG+njr7z/iGocEy3qsBrvmGPq+ucHY5nw2XjkzLPgBVsrXPf20ruFdQq7PlYR6ctSBvxkqM+m9ptEPrmyb/Q6fG7VfdN2m7bHrxQSdM8G/VPOSHzI1iukbsFvAwbrk+lpkPL/hOLTewrRtabMGip8XVCxI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:21=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > No feature change, move cluster related definitions and helpers to
> > mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unloc=
k
> > helpers, so they can be used outside of swap files.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> [...]
>
> >
> > -#ifdef CONFIG_THP_SWAP
> > -#define SWAPFILE_CLUSTER     HPAGE_PMD_NR
> > -
> > -#define swap_entry_order(order)      (order)
> > -#else
> > -#define SWAPFILE_CLUSTER     256
> > -
> > -/*
> > - * Define swap_entry_order() as constant to let compiler to optimize
> > - * out some code if !CONFIG_THP_SWAP
> > - */
> > -#define swap_entry_order(order)      0
> > -#endif
> > -#define LATENCY_LIMIT                256
> > +#define LATENCY_LIMIT 256
>
> No need to touch that line IMHO.
>
>
> I enjoy the new function names.

I enjoy that naming convention too, wink wink.

Chris

