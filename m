Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C8BCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78596B0026; Mon, 24 Nov 2025 12:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29396B0027; Mon, 24 Nov 2025 12:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EBF6B0029; Mon, 24 Nov 2025 12:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0636B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:27:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C87DB9A9A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:26:59 +0000 (UTC)
X-FDA: 84146180958.24.33067C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02970180007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:26:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pW+55qDi;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764005217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94O3an9nOgsnKXvHPPK5p4wHfagVZQQYqMGt2j6Il08=;
	b=Rni8GnkOrwSCO9ck/aituUEgIME7V3t4YJfeLahvU74CBnF0wj106DE8HJDgKFjgXxqtoV
	P8YbinFdrGS5j3c+klisrYhP4s8n0R6zj08Xu26YwKTqGZUHw83iSM9rTbRzZUDh7g47IU
	Og/Y9Kp3XSyTFdBx8cxM17BvxyLClos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764005217; a=rsa-sha256;
	cv=none;
	b=UN9mo6utFRn5UvZ37rdk1D1DG3NhZIphIQt0KNZdZxCMfmrLtdQyFkDsr/nIXCg9CfziW7
	4V4oqNSFnN0qWe0R74h6OHAXxeHQFFZBCYzP8PYuPzsiwwIGnspVQ3teyNPiUkPqhuxCeX
	mUtFvBVqLrtYLJkV2cIAHuKQuop/jI0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pW+55qDi;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6F53443DE
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC09AC16AAE
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764005215;
	bh=o3QYy8PXKCPbevvyhJWr9cqo/9R/juzI3S1NZfJymb8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pW+55qDiLgm54WhrAwepe94SAZNjjirpxqbS4tp5CGDuo9fUI+XmKgR3cNuRsOMmh
	 uUVP+TnYgAoI61HHsahKhCJ5oCAd624ferkytLnugibo4D9ii0CzRWAacpzQpxKwbk
	 DNXw2gmgyYBtJO1RGVydmxuXMAWY4lxmx/EYEI+fq5oiDS5fr63VW7iSJIHJjIbuKu
	 b1RB/tMoO8uO+T1ti0dy/sXhXtZNOJR/LIhMZOc8N68iFX08IZ+i0Bg/5qfn0TvfwZ
	 7/XYosdSU9ZcTOfMabIiMYmN+IwNEvUt13+DvO4AETwLqyiBHG70Otx7XdCSGgEWSl
	 RHFM6an3Dra2w==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63f96d5038dso3904580d50.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:26:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYhd2cstuFtbLWyN04ewteRWPDcllrss3H55j8zdu0s9etYPPeOpQ2bXLPd5wPDAzKNz2DKDbJiw==@kvack.org
X-Gm-Message-State: AOJu0YxMf7Z/qpnCB1hEdo8Lg6AxALBbusL2CeWKYGHEljLpElcQTBh0
	5hdMrvWajrn3guDgSCYaOlufJiEcY4Wk75CylAp3SrZ01qnafrZBQOGLJ9yStIa4wy5D91RdYT0
	ptOa+jw73fZHKgE1kqnx7Zf45oMHLpxvt5dqae3dODw==
X-Google-Smtp-Source: AGHT+IHF0zu9Ji+cnaxy1Di2h3pDLF8Br8onGi8N85twvOLZvqKIBaLlJztkOOKdRtz59ku/zRcaNbwC+c1wGgRDPvo=
X-Received: by 2002:a05:690e:98d:b0:641:f5bc:6973 with SMTP id
 956f58d0204a3-64302b069b1mr6673011d50.79.1764005214784; Mon, 24 Nov 2025
 09:26:54 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com> <340fd55d9d7d9436f18205bb458e9bd469b36c6c.camel@surriel.com>
In-Reply-To: <340fd55d9d7d9436f18205bb458e9bd469b36c6c.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 24 Nov 2025 20:26:43 +0300
X-Gmail-Original-Message-ID: <CACePvbUMAi-v0Xmw8-GCiYuP=smmtxeVQ3VS5S4mWcVirDGPSw@mail.gmail.com>
X-Gm-Features: AWmQ_bkmdtfmoUHfy6mMFototbcECVEGwpc3KlzTB-BCo5Qr7Mco8JBPY7hcpS0
Message-ID: <CACePvbUMAi-v0Xmw8-GCiYuP=smmtxeVQ3VS5S4mWcVirDGPSw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x5997eckamam3k1k4cm48w1tw9x6j9ux
X-Rspam-User: 
X-Rspamd-Queue-Id: 02970180007
X-Rspamd-Server: rspam01
X-HE-Tag: 1764005216-604338
X-HE-Meta: U2FsdGVkX19W5VvWGpci/TZP3n5utrKxecDusr3h7ullpOcwMX32baNECwu2eXnQY9RDpSbJ2vTHOw8AaXcwaUQOxXHUKq3lwC+Zmnh/PNNdGHPJhG6rPWFwNG91BjmJsBCH5fHwBVsZH8mOnG5/S/ZjtWpWGNfPaZzkQ9chqG/8r48OdooEo0yUnzZcuKXHEteGE2J78z3LXe3zsa94kMHDkLIfx5us90xU6se31bE2GLkpZj6/2YFT4OUwKbyy3qqjNQJasSQ7e9D2XiroPadWAtwqs5/3GmvqttTxr1gTcD9dtRJ3vPRLkoQE+EOMezjBWfkk0y2ldbhR20IJm4jZBOpCxe4lxER2kbxcpiSoxv6Vq5SIgSx+k8Fae6w2tdgZiNAVRNThzyqER4OPtXpHOTiLV+w4A1Sh3VTUT0iSW5uUYENxw+Tr8z8k+1K7eQUH4+XJYAI8a6i4hlG90Cn4LrTduC3SlCCYnnI0QjvCn5Vgx8sHkfIKmNV3bMORxkkwrqBKm1eS/S9ZAsI1YzJfVZTMFE9OX11H9C9FEfyPoRLfuiKw5nvBkEEasvC18/JiwnOAbDmXIPcUi6QATp0P/8lkDaz9+tkaNr0uIlLSsIEFqibTzAXQroFbAe3CqAwVeUIs1ZBm+eyLrLzJc+/iVWwv3VohmAWuiyp8LFu1YO3rFVGG0NZP21Y80ZcDhD25uF21Hztx8pu1Ifmc8QgSsms7LHEnzLnv6jZCM/yum3XGc1BuNPBXmG3Gy3AcxedEMS/SgBF7FSzEP1GUcUkIKaE37vPdjN+xrTxFAIc3e+UvX7pksZuCKi16vJDOTw7icQeOGUwsWKECDxUqV3+RxkTtcHhvrArVbrNRQXber4uEVz5K4SKxqr6TATCqQFyUnqFbzV84m2yV7OtGWGSNcwr6buuLA5py6QwQUUC/PPjxiQfIQQlika8HijyKk8yJKdMSIIUxVk8yx9h
 fMNY5FxE
 ifpqUR9oU+4PDRR9Lx3Lcp0G7DVaA8bMFFIZt1S7dwKRdGW9UomMEELM1MQR5AlenkSqkHkQtYxwIlLVxxUfKWbpTcokCAtQNxw6oUuBMOjYV5V4owtdWV0CENdI6CKHQ+J1mMZs4eji1MvTgzvfXT0WzJiEPdjxZ08PvQM951GpQA4PmCFEGLEh+7uQO5wNf49E41Kcr9+nW4rrQSEJuCDCqeJrmOz8gH3D/+mHj5P+nCyRuS3VrD/9bKe3zTWF6KyJqrzVjo5i4ESYSPhemeuE155dr+CZGv8gXcFbjWZB5WM+T1o1JJDQvcMM7xsJaPZTW295jeIFMx2Te4uqQyh8C9IedFauiiBk0sJvNgPvg0btcmYtDRHGgvG4U/joZ1X73w/7ajbkyFi8SPl2BSzfj1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Fri, 2025-11-21 at 17:52 -0800, Chris Li wrote:
> > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org>
> > wrote:
> > >
> > >
> > > Zswap is primarily a compressed cache for real swap on secondary
> > > storage. It's indeed quite important that entries currently in
> > > zswap
> > > don't occupy disk slots; but for a solution to this to be
> > > acceptable,
> > > it has to work with the primary usecase and support disk writeback.
> >
> > Well, my plan is to support the writeback via swap.tiers.
> >
> How would you do writeback from a zswap entry in
> a ghost swapfile, to a real disk swap backend?

Basically, each swap file has its own version swap
ops->{read,write}_folio(). The mem swap tier is similar to the current
zswap but it is memory only, there is no file backing and don't share
swap entries with the real swapfile.

When writing back from one swap entry to another swapfile, for the
simple case of uncompressing the data, data will store to swap cache
and write to another swapfile with allocated another swap entry. The
front end of the swap cache will have the option map the front end
swap entry offset to the back end block locations. At the memory price
of 4 byte per swap entry.
This kind of physical block redirection not only happens in more than
one swapfile, it can happen in the same swapfile, in the situation
that there is available space in lower order swap entries. But can not
allocate the  higher order one because those lower order ones are not
continued. In such a case, the swap file can expand the high order
swap entry beyond the end of the current physical swapfile. Then map
two continues high order swap entry into the low order physical
locations. I have some slides I shared in the 2024 LSF the swap pony
talk with some diagrams for that physical swap location redirection.

> That is the use case people are trying to solve.

Yes, me too.

> How would your architecture address it?

The cluster base swap allocator, swap table as the new swap cache, per
cgroup swap.tiers and the vfs like swap ops all integrally work
together as the grant vision for the new swap system. I might not have
an answer for all the design details right now. I am the type of
person who likes to improvise and adjust the design details when more
detailed design constraints are found. So far I found this design can
work well. Some of the early milestones, swap allocator and swap
tables which already landed in the kernel and show great results.

I consider this is much better than the VS (previous swap astraction).
It does not enforce pain like the VS does. One of the big downsides of
VS is that, once applied to the kernel. Even normal swap does not use
redirection and will pay the price for it as well. The pain is
mandatory. My swap.tiers write back does not have this problem. If no
writeback or not redirection of physical blocks, no additional
overhead pay for memory nor CPU.

Chris

