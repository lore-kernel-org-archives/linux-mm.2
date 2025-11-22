Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBBFACFC51E
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 10:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BDE6B000C; Sat, 22 Nov 2025 05:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212F56B000D; Sat, 22 Nov 2025 05:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FDE6B0010; Sat, 22 Nov 2025 05:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02B006B000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:29:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AC3F13BC77
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:29:52 +0000 (UTC)
X-FDA: 84137872224.17.DB33222
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1695410000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:29:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TdopC3St;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763807390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTWso1iGZ2qX5mWvSecQZjpKpJqOUtz83YYYslwTXSE=;
	b=D1FVSz3UU6eRT5AfsKxNUzn+klAzEljTEiwiqn7CVEjiQapU1jWoMReJ7BCZ82DpTbEXkz
	VDeXbJu/ptxmrxJSi7BhFeX0pH1hjYC1DBCWqjgcjZopmIrYHx6cx47J8GiKtkQPEfVXRn
	GTc3YZtOfUKtEKmrz6QdRJyunZwBqno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763807390; a=rsa-sha256;
	cv=none;
	b=sfuSx95IUhLMmhwMEhbd/10yYFeTDpIgR6vvbNcNAANmitpyQF2/MpvL4DxTLUbM3Pf/8d
	BDaBSHlsi1aNKCwxuQqbANEjAoYYPeSes7Qj0iTVzfxcdySn+TmmZkS0g/2MKzqj7piW+m
	07NTtXpeJIoKs3xd/MNCXl2ftRKLx7Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TdopC3St;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b72b495aa81so337543366b.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763807388; x=1764412188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTWso1iGZ2qX5mWvSecQZjpKpJqOUtz83YYYslwTXSE=;
        b=TdopC3StCuse8ygkdXATVEm25O4TrBsupWk5lVGlm/DFtbhObh1nK99ZNNr9VD57Cb
         xVTUQnXh5KX3gypFEzMRHimLsqBORVKVUfq95osBgj1+vMDGMMczaKeEppjQA1tPBl73
         KgsFyfNa2q39sLsaVHq2vKw3i271UiMGTDJxvNJpeEzwQQs6oK5OcezZiKE+VOz0YKBA
         vhMoFVWMhO6AT5SG6NH9uzr6H7BzjX5R47DPFUVCVDTwsrIVDbstCycSLslacPOEutA5
         4Mvq4923MEdhQj0XbfGLZQqa8qu0n0v1vvLuFXp3tIZY/bEqN/ypDccIdXBNLrk4Ldjn
         HWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763807388; x=1764412188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xTWso1iGZ2qX5mWvSecQZjpKpJqOUtz83YYYslwTXSE=;
        b=a4hAwg0DTfj2t3Hnso4vxY53/HwuxaOcW8OkbyPMho8lzRJiAwAkpz4RY30fyn1nBs
         VynNHO94H+4SwK8vU8mwwfCW1k/J5skM96RXn4WHfSjQbAJ8HacuATjYvewf63F5BGZB
         6c2uDr35AyY+aA98PRseyVPfaJjx33XQxjyH//sq/Pn33RbUQNV6k2rWlqlNKVqtzmql
         Cy7tzjCR9FQsVQOEGFdqEEXGv2Yi5iiOJEIwyXfiWd2IYv//rc1F3aw6Ww3kyc+59LeQ
         cphW1ChYvxUT9zncjFFwK1UGwxN6UV60yqw4JQDNtQriV0kX2LQ0oswjeYWGV15B5ZTQ
         rFEg==
X-Gm-Message-State: AOJu0YylPCbjK6YmfJdlCGvsXXzOYtIVqYWeVjU8EqoStpBlgpMNPZHN
	K4JSfaij8yatW5VE1n/BE/k4qsPPsfE2zLFjF+rqWnMslebE7qxJggK1PmyPr3Hu+atwW0u5J0r
	o9jHn7+jzpwjqAg+h9KvG3QYxuYrweT5ineoJYkUvHw==
X-Gm-Gg: ASbGncu7AtZtVdnnTWWUi2mfRUTQs+aTZ8mZM4d8V+hsxdIizIRIi2TWmDDswDsyRfM
	yOzSHQ8QeGv+HPyx9OR4r6QCKjXPqETEfOxbkrCx+dn/Q8JRR+xZNrO1lkqdoY5fsvWinBSyol7
	66Iwsrzg/bjG2Kbm616T+K/o8QAfuvFGJkIQGtGLd0S6qPYjTq8sJ4jTr0q29PGZjrguuTPji2l
	HPHVZsf24awXq8MeB0ZcB2kzScfNnBQ7GAel7ULsoIwh29cgM0e4mbMtBsjH7jQBmCdhaXuqGvt
	8899zL26MTXXmFCvIffKYHzpYN/WSrQ=
X-Google-Smtp-Source: AGHT+IFOnJqwUoSzPKeXQJYQjeN06z0GutN0a3pIbtjNHlMZ0goUeETBGAynNyHmmZ0WB9OpnRFTsQj/80ejN4ZI1NM=
X-Received: by 2002:a17:907:7287:b0:b76:52d3:c870 with SMTP id
 a640c23a62f3a-b7671731879mr612818166b.43.1763807387895; Sat, 22 Nov 2025
 02:29:47 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
In-Reply-To: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 22 Nov 2025 18:29:10 +0800
X-Gm-Features: AWmQ_blINMbGaalByBICysjjd5y3-2Dm5yKKYAaGWcEnNiU6_J7-o7QDpOMDK_w
Message-ID: <CAMgjq7DK7ga5E7vuhE=xV+7oePJQKJOk==+-G22dOKxCcBErhg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1695410000C
X-Stat-Signature: zw3nf9oxquieqz7cnwbj979qacyw8nuy
X-HE-Tag: 1763807389-78838
X-HE-Meta: U2FsdGVkX186LmA10CCnHM7DRvQWjoaZy68JE9NbUyPUcQW6AMrTQcIyescRfzvmRa8eknvAI9cZ26qHfVZ48RfRteJuI8VBenLktJtiln3G6xN0xpvRKBMZRhLci/ysFW4T0hMpxjyjNq3EqmUf9Rxy3GIVvozdNLYZDoZsO39XdB//+35JSPQ7d5MGQfY2lyDmytURTR/FMMmTt0EcYzqbI5S0ZPMKPZi+adgyHQxG3xFXIOpqoUzH5T61KyPCJKMNT75T/sMUldYzq4JktXxfKGA/tP7/gvdMjButvKlHhpYg2sKwpsxddFv4QUl4+t4R93j7FPy+oYNJSYmxyH3J085NiqXkjwYBbk7RL601bY1ECTfGq3ILhhobfgT8RcfAU5Y10PJu1mUlqn4mOtJrCZbWncsFqC3R/Q3O7Yw2Bosj7cv2w1vgg631Bbg9pHb06VYpZF2ezSg2wGQo8rslxDKshDuuXovWs3wbWqUFIU/jBt7tME+370RXQvaYFoz951IDLnOrD7tdXdLHGq1/2SKNqhgjStzMqeF0LuezeY4YtuRAFUP5a8KUz35+rfJqpfpoos+UKpm+wz/8ZbnCB1OR67TYrZtoRXC46AFZEO1j3HzgYJ3TfQdq4guvxqKDlgjdRv5wnHRdDX6IegzdH91YpBNGUv7HEnmPn7KeGSNEe9hUiEiCb5EsAtxmW50+7m676dTe7fBs5YROI1HBHvs5vXkhh/WwtYfwjCqQa0PtHTD5rnwr275qoDlwpdf6btnkGK2NT/wlzBOgfNeaVt6Y2CLyRbXn7TbIBGqPuUmSU4sVmV/NK+hUehwMzdJ7x0Svk8Y29g5ojqD0jKayiJXtEXYCizWLqwtBeJhLv96Be/9WK5m+sic27mxGcve4/hnEwv7Z9ZR7JuFD7jLrbIaH+IJ4VA5fdOL4Y8ICG6DNlNRfvi2KZ4QpVjW+MHMsC9iuWK+YVFqryzG
 +hzu2I/a
 OyUUzu/yA4+byDmDxZRw5WNefa+h3Va04Th4KydYre93fZYomsnl3gUrquGMA1BpCsFgwAADL4m5GIEhQq3UMam8X1s3DOTjD2+c9DdoWQzQFqim9qwU2frbGHC4hjGJ80x+efDZEKsqCFLCvpaVWSnh2GgFMDbeSgnXpH6Airx/+Ww+egfhD06ayt2tepIgglazsNuHCqiTnxvHZd/9DH6dz53mhIB0rMZoKEY3fLQ2viGEq4ipdSeFnuKfMmMbwsNFhSkitQtC1EMTDfqkbf/AxggWnYR1Pkyqlab94RZ9uhsPP7Jl06PSTRex076YPKlAv2VhiYJniQua5RXMEUBvFv4BEHbPmonXsDVLmw8GUzdIpKGPjgPSx1+lS+EleP3OPdK2wG/Rbc0E7Se4MgMLngQobaw4gdzJMvG/B8Wo7QzJZSnSZVqDiPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 10:09=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile head=
er
> > > for zswap. The swapfile header indicate the size of the swapfile. The=
re
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> >
> > Zswap is primarily a compressed cache for real swap on secondary
> > storage. It's indeed quite important that entries currently in zswap
> > don't occupy disk slots; but for a solution to this to be acceptable,
> > it has to work with the primary usecase and support disk writeback.
>
> Well, my plan is to support the writeback via swap.tiers.

That sounds interesting. Have been watching YoungJun and yours
swap.tiers discussion for a while, looking forward to see how they
play together.

Using tiering to resolve the writeback issue sounds like a nice
solution, we definitely don't want to limit the writeback to
zswap/ram-block only, we will also want things like
block-block writeback.

We (and I have noticed many community users) have setups involving
hybrid tiers. We have a internal module that moves swap entry from SSD
to HDD too. To do it upstreamly we need something like the swap.tiers.

>
> > This direction is a dead-end. Please take a look at Nhat's swap
> > virtualization patches. They decouple zswap from disk geometry, while
> > still supporting writeback to an actual backend file.
>
> Yes, there are many ways to decouple zswap from disk geometry, my swap
> ...
> Solving it from the swap.tiers angle is cleaner.

Agree with the swap.tiers part, that sounds cleaner.

>
> > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

I think that's too early to justify. Let's stay open for ideas.

