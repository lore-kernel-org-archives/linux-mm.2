Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36947CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947558E0002; Mon, 15 Sep 2025 11:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DCE8E0001; Mon, 15 Sep 2025 11:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AF08E0002; Mon, 15 Sep 2025 11:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73D618E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:25:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41D2516049A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:25:55 +0000 (UTC)
X-FDA: 83891859870.03.2C8E383
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B4EB14000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:25:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VGnwQE7e;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757949953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twOjmxypi8F5/wktXXyH6UWMyBziK0bLBGe5jYGqXDA=;
	b=XTh8cZteWsP6yFBZtqKOQXsiV4q8yDW7Gocs3nzayB7FNXpBb62RFqguqKAjGRxqDXCSKZ
	kndMKWxJTxHH6iKQNPJ7GKHUINzcOQ5KO+7LTcSrItbUmC0hXXQ5kewNTrjhJd0TMJNWSs
	lzF9E4OGlMoSI1Qbh2Hu2ZT8QkjTITE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757949953; a=rsa-sha256;
	cv=none;
	b=vDBLJ4qY+4wU0GRDyQpDdtDoUO4upQ8ISEimx8sXD9FK+dIrMuFhLvpOi78khqYDNR1ryy
	ERwOl6k731d07gIs0KmjTLC8pbLtpzHTZbD24O0kBPjRuJ1rU1N61rLosmHKAUwHA1dzkR
	AhL3KjrV/r91/KJ1F4Kj6BdR0d/ipRU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VGnwQE7e;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b5e35453acso54698321cf.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757949952; x=1758554752; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twOjmxypi8F5/wktXXyH6UWMyBziK0bLBGe5jYGqXDA=;
        b=VGnwQE7eou8N2y+e3awLYngq52jI0VJK1dc+Xp9G5Hkl+7sAyAqZpWaF9bhBagoATf
         UWMDVEPM4rMpMnvEoNJC0zR7FSN+nbElM2zJ0oBayDBBcCDQxo4tKXH1aD1VqXT1R/+O
         TbWX8g5C6UBLaEiUWSnwsv7bLPstEzuq6gB8Ge6P7ZjLcCJU6TaL103/53Z03cz8xRAC
         DhfCPYo5mpsvBx6fb5hZrxiU52kGbn/YQhZKCy4Xr6iebhCYQ2A90skDMpPzR7J3/YQA
         X9HHh9AqBYIGtgIVlVgVjdh2tgvVpSBJ2L7ozGLfcREaTKNV2Ri0y2NFeCdOWcy+jL5X
         xhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757949952; x=1758554752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twOjmxypi8F5/wktXXyH6UWMyBziK0bLBGe5jYGqXDA=;
        b=GqQ0cU48gCLXrThWpEcFHWfcUB6Kiv8VNfmJRX8xC5z3zQbTK8IM3puZrmSGMel+HK
         249BPXLa78ZYP2EgZkpEnddBJiERTaC0P5plg+prNe0sI5Sru5IPDt7UQdfU1zpoUzTn
         hR2E3tqD/Ywwbdljuzh5dnF90/mntIFyLZnyXPwWT7zYKuH7kGcSTg26WVFd3TX6d+nN
         IYkS9aMeWa/TXUWt/ot/09Npzz66L569bNNQvtxQAbR6PcnZ4iYMKq+6fEfhcnlj31zp
         HGcGN3vVPIJPPCWEGB5a5pi4KZJdefHmfDmyxHO7ChO6BG9VmCeXVEnNaeOsfKUfWUjG
         LmNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZGnVYScbwq7LBHZXE8T8KptqPsOUP+H49wPRc80zPAZvcrmbtIlRySSPpgMfr6F7ZbJAVcK8/7A==@kvack.org
X-Gm-Message-State: AOJu0YynQ46ASuNR6Xw/BXoM6FI0fUODBSufKcBmfDJ80winJQefkKPL
	sPj6ykLzdSnL3h0NYXJWThHmqZontsQoADNYjQLHguSEZj+oJHV2j5r2m2goECCdeKoL3lyklo7
	iubDQ24FVrcVP4wUqDbq0dmiIgmTjPyY=
X-Gm-Gg: ASbGncuO7JMhjuHayNU/VWuKWJ6K8i04jwiGoRosm4VI2f8cXjTZKWbRLCk0yMTkzD/
	8YapOV8HdzGYNeGSiI8QUWxmPoeYPDhHtLXE5+XljuL3sQ97jHhesbAh/rfX2Xizchb1Pr0mIox
	iAcj7RHSzzx+aAQ4YpIsoVVMvhcQ6AAn/jIQdcIM0edH69eoxbmwxiPlh5w4HzSv9Xvh8rgFEII
	HX1VJ1Yoa6TvS+ldKgDWSLFVt4AGRKnYDscRxU3VOS0XKv3mDI=
X-Google-Smtp-Source: AGHT+IG0lj4OHOWbpCyzpHkhetLcDU4pJdQ9spR9svWGOUH3xKPwb7pLVnXSJvywltfC7gPj6m2GvwN33sLw0OSiuQ8=
X-Received: by 2002:a05:622a:a19:b0:4b7:9f68:52d6 with SMTP id
 d75a77b69052e-4b79f686bfbmr58374191cf.9.1757949952122; Mon, 15 Sep 2025
 08:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250915015807.101505-1-sj@kernel.org> <20250915150851.1508878-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20250915150851.1508878-1-joshua.hahnjy@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 15 Sep 2025 08:25:40 -0700
X-Gm-Features: Ac12FXzQhzLPiwahg8l4GbB3zTsY9ipEubXDL1xh87e6emG51matFCCQ0FbehiY
Message-ID: <CAJnrk1ZHdt-sj4n2VigW6u6bnd-gX47WpUfaHDxqN1BH4JGUXw@mail.gmail.com>
Subject: Re: [PATCH 0/6] mm/damon: misc fixups and improvements for 6.18
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, damon@lists.linux.dev, 
	kernel-team@meta.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: crm8bqko1p4nythruphf5id49k8ee3uf
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B4EB14000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757949953-912847
X-HE-Meta: U2FsdGVkX1+OR+/NplLcAgXaMgF+MKJ3vnobKKSkUvjNB85+Ttv08jbjNl+iT9I0yCu9AzPgjsFyLlUflukZ581OBsLmDlF3x7tzMGu2faUiBzOBscIreqkncvwW0RTB0xoX49pvhTc3ISwiYjJV5WkdOcL5SbqrFwrkEHwVculDgw7d/hOEMNyjU62BTOtdczW9iA8stIVRKa/3drhfp7o6XrqipWGS4Ky+SFGgOtZ/YWGXybo/a8+bFsb2nvr0At6svUGdp9eS3R48/ikqhT2a+pahcJEYZnL5Svg6ivvs9RxtUvzBjqbFc+Ktr1E7+Gpd+AZO+Z3U/OQfegSoqSkjn6nqAH5dItI6TRyHCEzVKhsntnfp6OqjTXBpM0/BfOR/FX5IM6c/MZTyNlozWx2i2qD57W1FRRuMN9ZQs0L4GjcrSEt7DXOM+dvGrEQRRgDOCg/jpn478ulGfXc3Ti5RB2L8qd5h0zQgtURr5nKP3sJx8SmH4WXJorkn43YO0L12OLpMwTkNqWfOgCHSVc2tbFt91sh0CAuVYINPQNIgICriATipllON9u9XECcO63LrH0EcKAJWBbalKIsyrIsZyx2cbE5Sw2F7QTg1YacMQe2wkL0NcJtQLu9CxVrtdqTE73ZVpPowyj0kym3wE2ZIHmtMGEqeP2KlOtVNGWsUcz/N1fl+8NgMq+jjiLRURuJNQTjMmVo5gH/v6Sv5sgOFmOVcGA3UTDCXyEuEsYVDEQ7wDj4c//aSb0pa5KqKERMaLt22UDVfU17WvQVVy8IVynqOaMAYXH8OAMNOuueBnSWyzUYPcVuRJoRwI5Y5bYpo/Ek/WC1/2GNaFA50QZ7eXcrEDYTm/597wAU0aAKO3IZQ+41CeqVejyXDuGHKqfYPDHDRsQ2BbmE3EoWk41xUY+GZB2fxp2WHlvuAaN+dy3pmx1+dZ14ne+iG5nVEB8qkBopqIX4/QbjrtEr
 NmPWh93G
 gX8ncWAX8/GS05fNFs+magAtjNbSvFY0vWHKA8fzn04Jgifv0vLQVd+7FdbRdQL/URPRHnHVdvvHbA+BGd71KxZngd4qkjI3WOJ3ZKDY+ChBx2yy571+y2Y9Hqy+JdI/YLXAAPKp41xaj/xzGia6TKuewGrwUZlxd3RyaqVwszToQzrCDs9LB3TeIkmzg0mSXaIG5V2kGd65RrgQPlEQcIkzHvrapEu8XEdavBCsA+/BF0SaeEa90MXNU9wsh3qXQ/ZW6P26l+ofPW5voKlDAYoFdIJFEZQxjiIWT+iww/hE4IdGVa7No1oI282hORBWtGOyD+/SXe4rRXkMbVvw6PA9NmvHHiCb0uGJQFzIi7D958mhgI6EIsBf2KCqKxnWCZTrSx8TBVzWW+C3+jhGqamSo+YMpJuGKKQI3RQ1s05HoHVbduoIPtZqzzbuOjRUCL3UyhQOiZsUo4ggyGNtHy2iSGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 8:08=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Sun, 14 Sep 2025 18:58:01 -0700 SeongJae Park <sj@kernel.org> wrote:
>
> > Misc fixes and improvements for DAMON that are not critical and
> > therefore aims to be merged into Linux 6.18-rc1.
> >
> > The first patch improves DAMON's age counting for nr_accesses zero
> > to/from non-zero changes.
> >
> > The second patch fixes an initial DAMOS apply interval delay issue that
> > is not realistic but still could happen on an odd setup.
> >
> > The third patch fixes wrongly written code that doesn't cause any real
> > problem but could make code review confusing.
> >
> > The fourth and the fifth patches update DAMON community meetup
> > description and DAMON user-space tool example command for DAMOS usage,
> > respectively.
> >
> > Finally, the sixth patch updates MAINTAINERS section name for DAMON to
> > just DAMON.
>
> Hi SJ,
>
> I was unable to find this sixth patch on the mailing list. Maybe it got d=
ropped
> somewhere? : -)

I'm seeing it show up for me, this is the link I'm looking at
https://lore.kernel.org/all/20250915015807.101505-7-sj@kernel.org/

>
> > Changes from RFC
> > (https://lore.kernel.org/20250909034353.7064-1-sj@kernel.org)
> > - The RFC was only for the first patch
> > - Rebase and wordsmith the first patch
> > - Add a few misc fixes and improvements for 6.18 to the series
> >
> > SeongJae Park (6):
> >   mm/damon/core: reset age if nr_accesses changes between non-zero and
> >     zero
> >   mm/damon/core: set effective quota on first charge window
> >   mm/damon/lru_sort: use param_ctx correctly
> >   Docs/mm/damon/maintainer-profile: update community meetup for
> >     reservation requirements
> >   Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example
> >     command
> >   MAINTAINERS: rename DAMON section
> >
> >  Documentation/admin-guide/mm/damon/start.rst  |  2 +-
> >  Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
> >  MAINTAINERS                                   |  2 +-
> >  mm/damon/core.c                               |  7 ++++++-
> >  mm/damon/lru_sort.c                           |  2 +-
> >  5 files changed, 15 insertions(+), 15 deletions(-)
> >
> >
> > base-commit: d245e17d619ea0336d50b0a6c914f5701d1b0e53
> > --
> > 2.39.5
>
> Sent using hkml (https://github.com/sjp38/hackermail)

