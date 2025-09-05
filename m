Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747D4CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA378E0012; Fri,  5 Sep 2025 17:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2218E0001; Fri,  5 Sep 2025 17:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD80D8E0012; Fri,  5 Sep 2025 17:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A87898E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:35:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A4EFC0352
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:35:27 +0000 (UTC)
X-FDA: 83856503094.11.9A9357B
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5C6734000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:35:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PNeT/oWS";
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757108125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEZdWRv/z7iciKhuDKF1kowxhp5PcLo5vzJehKUARp4=;
	b=BFH7VvrfGJ6KxqFTrjqZ7ltEWuqLUxA4DTdl9rfskEZjmEcRg9OC/VnDieVvD30h04/6Wr
	H8pXAt89l5ea9WykLliRkYlq6EIPaPRGtOrhz8AifR/6TYlUekahBrzq5706qwanhw7VPM
	hPkCEeAB/FViAxqsRHdm0IT8uBDGHtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757108125; a=rsa-sha256;
	cv=none;
	b=bUHPPy3xL64WggsDiJ5Fn9IQ3hWU3AO9UWNQ+j9SD8Fk/osu9dvLLG/1tMgFFFvQ9zTrz8
	MspWx3m3vW7IXr5uCClfinO9eE7ZsTJTnpCJsY0aLNpYm9Lc6uQ0ABXkfo53pq5ccMtKza
	ktdaMQfN9ayPm0q/ZKtEOXSuoFdr3zQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PNeT/oWS";
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3f663c571ffso26673405ab.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757108124; x=1757712924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hEZdWRv/z7iciKhuDKF1kowxhp5PcLo5vzJehKUARp4=;
        b=PNeT/oWSMj9TiNNf5vbQvmg5CXBV8t63KO+Z0xee1MjNnedGdjcNXZeL7cy9f/OyEk
         wOlkgEfgC872k7F92AzyvT4DS/0rGdx3mPuZRwrum2G+VQAu2z1SEUJxETBdhwK39odQ
         NNAXTbEts4w8mS1dkNusKpAnBITqYbK1y8Mkv993ZqDn6Ilv0Fm0CrdIxV5jYFjoewXX
         5ItG7wovJvtIaD/M9vLFYajvKXwu7YWiJfN210EkIj8UgKe7+NdJyRvVm7gIObSML2H/
         2Ka/EJply6Cp0fBaJaghCzCUAbqIFK0N4JvKuD8qOA9FdMa+pzLkBN/HaVOEN6keDmur
         Okzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757108124; x=1757712924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hEZdWRv/z7iciKhuDKF1kowxhp5PcLo5vzJehKUARp4=;
        b=Rxv5PiywmjuonQuBZwKVk3B1YyHKKHV2XS+6LLbSkabloRXttfp45tfxEsEc7KHHE8
         374UZ/BGLvV4FqE9fJbiCQ42xrOhsjWZVJ5c0/IxUsN3fLFL06Ld6V6beCU9buOj/HvS
         d8DY3lxcaCLtDYh68fumWdQq3AJMy37ZC+t9qtiIM8vFx5YRVF/ghex/DsyjhV1mOD6s
         rJ9ipcfiQh41ACv8T30KEO4Ry9OCavsy4aR3nsHTu3Npo99gZa91cKv4Suvp0IjTPL8t
         1gL384iczc8b2dkd9lyBcJCPjDuidWnqd4zhgtgXw24tmNObgQuJALjNissJLFNDMzck
         6HpA==
X-Forwarded-Encrypted: i=1; AJvYcCVnAlXEtBbOWAqUVXBOgpNtcFZ7y07OWmisbTTelfuYyVQCKkwlN3Uk5fyOBOaRKIf9oTUktKQ39g==@kvack.org
X-Gm-Message-State: AOJu0YymNxRGen6p9QGsR9E6D7ACzTAaUU5SLtA0C/Z3nHJPKe/Cy6Br
	+EbH/65MolLSZYoK/S4tsZGmJ/CmEBRj0xIs12cQ8g2qTz35dfo8ym0cHYZOcOOnrezBNNzBADb
	FTri4nrl73NKFWdaXP0n0NY7FjzMN9I8=
X-Gm-Gg: ASbGncv6T/6OXSUto8abJV8+KmpMV2J1yYN4064yGTuTvLALspKflIt5Tdi3tnsaZdK
	PlaFe4LybwNI/GbNGcFcdA0L9WnL9v2kh7WAF1pA7smFiYdB77jHIAaJzQE2XM1NM/K3d6ut+IB
	7cf0FuGHgGKwmKMXyIFnHV0sbGRXOIRkl/41Wuclh6dpcsf3HqlkAa/eIMWPHCWjXi9cY7NnsuG
	JP/VZEHDYegLbK1hIU=
X-Google-Smtp-Source: AGHT+IF8WVpB/g1JMlOdobaIjwrWwlXDO20YTmdhB82E33R4jbv8LdlESlw9MlPJrT6Dgk8ja2BuPEbvb3+xGqZlJy8=
X-Received: by 2002:a05:6e02:164e:b0:3fc:d8b1:7a96 with SMTP id
 e9e14a558f8ab-3fd8e98d13cmr6645145ab.8.1757108124237; Fri, 05 Sep 2025
 14:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250829162212.208258-1-hannes@cmpxchg.org> <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
 <4vpqew3bfs74kesmgd6kaafgm6nr6zbtt2t3hl2khkc6ds4zep@hllgy77hdumf>
In-Reply-To: <4vpqew3bfs74kesmgd6kaafgm6nr6zbtt2t3hl2khkc6ds4zep@hllgy77hdumf>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 14:35:12 -0700
X-Gm-Features: Ac12FXz1xIEuR5P_UzNwabExfIPEV8sQerJraRtHn2GEfVW4UeX0axaUNE1zkPY
Message-ID: <CAKEwX=P=2cm7X4VMGO==xqmcFfBj4tq_YU9DqCSbyAmCioDccg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C6734000A
X-Stat-Signature: 6grc73fnxzsbn8mama4s8dcshw8eyn64
X-Rspam-User: 
X-HE-Tag: 1757108125-150432
X-HE-Meta: U2FsdGVkX19drL3mpMcaC9fgLW8J7hOBvycnB0tPTr0CS8fiBb9/rjypqR6fDjHGXjuwj3JkZB8M6mxzkCXpvMqZ34HR78ACUXvtHq7rReWtXTb+iDS3wp4oPKyYh5R+O25uckTFm9iDErRtwYAWiJKWsYXcS1WZww7cHlymt7Wv5ZpbDrYr7gk3bQfEbFkZvblHqyPWAjEUgvi9O+LJxmrkHiRwWfB+945LxY582liNoazyapXZTrPRQc3NjGp/zs9066PpQbFOiNIRb714fkLs6s70bVKcSPnx5Uh9YeV7jehR1PXuq0rR/JW8S3TcjEFP8KiTvKxN1zuO3p67LUbBFreUcJEcRvM9iZnFJxuJQ8udkkxVbNR6SlMmniI8r9fqh1/eaX7ifNbTN57YQJVfbwk21SijqS/GZ4q84qVLWaDU8j7Cs1j7HoMKD6WD7b8hK1/AQUW/5+JfJpR5SHjtAjVh4cuThkvkWpBrEY03n+xpa0hz24mrtRbzIpJyWWjJOaODqJxvqSOjs6RC7q3CEsP0Pvcjy21jnylDshsyfPkImut6IU1oegcroKlJi7LuaWwkcU989aJlbvZD0qYqxP/5fgGCJESK7CaYYFD8y8ZnhA98lwKlajPPJZVE2/+Ekfmaiha0h7bV28JJyv+mwA2SzNzpR3p2L9bdXTd2LtRFkqEAt0m11wM04WvUmo9l6QyYo3oxShENJf6lW/611exvfRJYxYQY4VlUV3XpDRJ9rqp83K57rrjyvECS3e72GE/8MJULfQm0aGwmXgz6InqWp3ZzGaJlsAoLtOVamZQAbFLHWTZkghENNUAbPL4anBKtA8I2FEc4pDhGDBmhdUz/GlEjvVErfT4Md6+Tyf1zKIWxdZf8Wp7VVbw/Z5EztfYsK3H2uNqfeZc4XdcFAp6TVw3F+8NMNmE29ttu6IXbcgEyhADo05uyHDCwYFq9nzXmuAiadopPOMw
 7jz11lHJ
 E9faLWjFi1FcuVrdgMN8msyyEdkCoP3cWmK+ecoRHtULjGIuf1uiB4h4/bLGnYnvL/Nocfl7BpQKk8Melt+yRr/b2m3iS47sN4U4KIp5ULuhtKV8Py5m+/ew5zxfr4p7v9pHpTE+1KIU2CsIwibOT7kMNZX3Cpie05eyOrHPUhgY82gTPWVHa0DvYag3AB6/GhKqKrJ47Wg9PKsdcQVMBCbc52G3oHrOkyyc/sY+i8VcFEPn1tLetXLGsVHJJI3rRj72zdi+mpm27quKReXXC2VqGlwNycAa3+izPANSojnRQXUabFzNcdk9POTtt2mjIqwj/MnO7gYGRgdcNPRrYffxFDMlOiwpg6NePDSG8NAlSKRl33rqVPja/8gnyJ6lFSTiD105VeZPsTI46TVJmN2elNxCj2wUlVMDJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 12:45=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Fri, Sep 05, 2025 at 10:52:18AM -0700, Nhat Pham wrote:
> > On Fri, Aug 29, 2025 at 9:22=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > zpool is an indirection layer for zswap to switch between multiple
> > > allocator backends at runtime. Since 6.15, zsmalloc is the only
> > > allocator left in-tree, so there is no point in keeping zpool around.
> > >
> >
> > Taking a step back, even if we do have needs for multiple allocators
> > for different setups, having it runtime-selectable makes no sense.
>
> Honestly I think we should take it a step further and make the
> compressor selection only at build/boot time and completely get rid of
> supporting having multiple pools. We'd create one pool at initilization
> and that would be it.
>
> I believe this will simplify things considerably, and I doubt changing
> the compressor at runtime has a valid use case beyond experimentation.

You are completely right.

And, even if there's a setup where we benefit from multiple
compressors, the current setup is definitely not it. How are we
realistically going to use these sysfs knobs? Change to one
compressor, then quickly change it back? How is this remotely useful?

Let's remove it all. In the future, if we want to do multiple
compression tiers, or per-cgroup compression algorithm, we will need a
completely different architecture anyway.

