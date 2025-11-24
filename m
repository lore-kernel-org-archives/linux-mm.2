Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FDFCFD341
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828236B0012; Mon, 24 Nov 2025 12:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF996B0022; Mon, 24 Nov 2025 12:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D136B0023; Mon, 24 Nov 2025 12:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 617026B0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:58:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07E37160450
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:58:22 +0000 (UTC)
X-FDA: 84146260044.06.FBCB79C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 06ED780009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:58:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RblVIfxd;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764007100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GRJworpX70LhvXCEDMAVCfv38gGetPAC5HM0YzaWf8=;
	b=KaZI7+DuXrHD4Niv4ZKjRYDemTmeyTWr1caUwHdx/Humbwu5pVzOsdThpdx8870VCQWyUX
	MWGaqF2wlpbjHKL8s4QJAKLTLxOK67S6KQJ40bZDorEnQSbiyYZpeB131mRssx4NeMyZOX
	vgNRRdCMBeu5JMl+qlUuPjudWZb3QBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764007100; a=rsa-sha256;
	cv=none;
	b=5keMXHREjDSZdLsnGdOw+a3CEGCPcjoTNk9cAI0bOKARf3GEgb6dex1V7oB1Oa2h78LLQx
	YVkZN8Ov1uiWT7KFrHxkLN0cDlzq1T+wqwwQUxvH2iszn52cLUspCvXntILZfdu4TDE6IF
	8+tcuRe0sXmif4nRX14C3rqb0JnvDLI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RblVIfxd;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E028743F27
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED18C2BCAF
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764007098;
	bh=9GRJworpX70LhvXCEDMAVCfv38gGetPAC5HM0YzaWf8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RblVIfxdLQAPsnWaWeLMq6k6R58uqGjM9slnx3gU4nUCGtqqBx8xBcp2w1eYkBa7Q
	 0UIV9LRcR2G7CZdbWNeEdkBrDg+I9mxtI2lkbj61yBzNgHUZGiFeiRHQl8M6prsoUJ
	 cX7TLpVsB8bWzfOcoAnwjgUhlzNyslWUZarXt1wiNtjLecpNsuRqSF8nN46G13ztnZ
	 00k/x3/rTawW+yyc1IsYOKv5iQxyBKdyUc58rjhA6eZlHFoDNblxs/1Re9lPfidMoH
	 yy8ZLMmJt1MpaDy8mFJfMZVoyEPr4Q0T4Jz+YXji//RihsiINdA1on8F7sMdVDrO4P
	 D3ishNsJ+nqeg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-786d1658793so41731707b3.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:58:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX2IY43zPqUK6ztKFZmOkMPjMIGTwgUp2l9PpWBY3rdbx3G3CoBxweWLlKcktuxGovhZvJQgasKVQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+u1KnejbYs3OBeffzC14MPgOvxllq9xYL87vu8RIs9v7j69tJ
	nq1JayELxhyStQqWDll5Yo3ndzfjNtvWCDln2s0pasrJlwQ3sVipjvo4s6S0MiCwbdb2fy2WUtU
	DNh1jbZxPObT2TCm3WJJugcRRmo4WpsZN4qE63RbsKg==
X-Google-Smtp-Source: AGHT+IGXorSv5Um+cR1+lenY42eed2ebLOlJgSwbpEqsHnKruwYReO9AmRBUE6yUxF0maExzml2w3AZSbCWBupmizIQ=
X-Received: by 2002:a05:690c:998b:b0:786:a774:e415 with SMTP id
 00721157ae682-78a8b551916mr196544807b3.56.1764007097874; Mon, 24 Nov 2025
 09:58:17 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <340fd55d9d7d9436f18205bb458e9bd469b36c6c.camel@surriel.com>
 <CACePvbUMAi-v0Xmw8-GCiYuP=smmtxeVQ3VS5S4mWcVirDGPSw@mail.gmail.com> <86fa3bc129bbd0e0da9d118ca6441e34a389fd2b.camel@surriel.com>
In-Reply-To: <86fa3bc129bbd0e0da9d118ca6441e34a389fd2b.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 24 Nov 2025 20:58:06 +0300
X-Gmail-Original-Message-ID: <CACePvbVcq2xoWkbWBxpOUz0QTgTaQ7C9rAGUtAOWJQhH+wm=Qg@mail.gmail.com>
X-Gm-Features: AWmQ_bmrZoz23TED4gV9xQ4fZ4JznNcqeY-FePY2JXvbgdCy5-DuWDOcXULjPZE
Message-ID: <CACePvbVcq2xoWkbWBxpOUz0QTgTaQ7C9rAGUtAOWJQhH+wm=Qg@mail.gmail.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 06ED780009
X-Stat-Signature: eco57r4td4rnjt915pdgr34q9pm1oe8n
X-Rspam-User: 
X-HE-Tag: 1764007099-939626
X-HE-Meta: U2FsdGVkX1/epFmQc7G1xyLKH6p+9EEN21/B6s59L53NBEsh4ZxvJ+7rktQGiuM65l/3hdD4eQ5HthAa2NvmgLwQw9YLZf0DxNfGYsvmdqxFSH8lRtdzN08d3L46zKDOa14vHRQfDE1yTkNu7R7nrZX+vy2VcZCtAP1/ZbD3Ti5zgG8WsTKHIf0/8pRbyfI1RZFPjeu1Fv/XSEvMX5qEZlyNcpwGJJ5fHFqEk673hLKq+GxENx6s4FwMR3CdGx+m0bk7K6ZDbif8mzaw5OKwX84Ee5cL7f/UWqEfzu7Wekg7dinlPa6l3tVQjjSwalfMkBT3HBKOsjDOjXbR9bifM1dLKccArupOkmhBNMqKcdAysUOiDGwQrNrmYtfjpZp2VjP/h42fo5ID8nrgkgS/Axyy6LTK9L6FQpR+tAXY1De0NX1O3JZ581qgM8EJRib6ui0GDIgmOmSfAQs0oFfEQHuWzUS7dDGcVvny8prBt2l9Y0IP4uKDfaq2uKdumjwHPeI5neb4VqjrFDNxJSmgQgNmE7sJZjQWm8do5FeftR5PyTbQ7WgdWaJWZyGsUyv6ZOdOY/CFpe0yP63QqnrzfjmqS4wIZIZ9RJLS6ev8pFcbzluUAU/TPCe4/2phrB3Y9CY5Y57/e5ih3LHmIeTV7m3C3zKw51lXaarejnvvrPT21skRYgmxQ+tHeYtkNxOXc/SuZEydHb0CjGAa3GxClgGHL9D04S0DuTSJFfWHBJlO3UjoCj88ZCKnRLNrcT6hHf5AdzNdeDNg/qHs5U99SafTB0PYnuo0mcbQKLS+rEh+SifWcjxoWLF+X3GNU2wtQB2KAUh214L5ATBTF1oF9OHo8CU3v9/V100bN4CV+Udj4PSqLph8ddVbda3zogcZqfa625R2AbW+HvVmCNFMgne01AdMFUZEqLXq1q9cilFQ5zooIN59OTrVW2tpMTclXzoTrCLIAcdSQcDFJ1+
 B4qcVXjn
 B7MLUNGPRWpIbIVeFmQgmFdIYAk8Ll+VSlXo3iPANFOJs4jOd9fsCJ1i+XPddYIeXfMa5q7e4U2vSJmNBy6kI0SB9ZYSLVaZxTT8MZ6NVm2p+GnSIyQKlywr+ZC6rwcxMkKa4M/iwK6hvg+ev5Z7PzenPbJifbZEyiX45pFDSQoZcod+t6YM09Ea83xHX/ctlQgZgY2KA2GS2EY9LwhKAUiDmgnevmFHzaw4XzrGmbsdI/GohEx/do2k4RCcnEjjcdjz2jZQ0+3PzjWyIMji0qjG6bindB0zo+l5nhU0HfxqcPad7qXR07esgF82Ctb078Xyzp0hzgL9Zkv1FqSW6KufQVbUdHIFAxi0OyOLu7Tcru6mccLzSVJeBNyHDAojKKuQIERmCr3h723J/KcaNadEY5VFGOgNptxaQBMeZ1e9UHOhPpAQ5+fsE2YmMNUYDXJBN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 8:43=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Mon, 2025-11-24 at 20:26 +0300, Chris Li wrote:
> > On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Fri, 2025-11-21 at 17:52 -0800, Chris Li wrote:
> > > > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner
> > > > <hannes@cmpxchg.org>
> > > > wrote:
> > > > >
> > > > >
> > > > > Zswap is primarily a compressed cache for real swap on
> > > > > secondary
> > > > > storage. It's indeed quite important that entries currently in
> > > > > zswap
> > > > > don't occupy disk slots; but for a solution to this to be
> > > > > acceptable,
> > > > > it has to work with the primary usecase and support disk
> > > > > writeback.
> > > >
> > > > Well, my plan is to support the writeback via swap.tiers.
> > > >
> > > How would you do writeback from a zswap entry in
> > > a ghost swapfile, to a real disk swap backend?
> >
> > Basically, each swap file has its own version swap
> > ops->{read,write}_folio(). The mem swap tier is similar to the
> > current
> > zswap but it is memory only, there is no file backing and don't share
> > swap entries with the real swapfile.
> >
> > When writing back from one swap entry to another swapfile, for the
> > simple case of uncompressing the data, data will store to swap cache
> > and write to another swapfile with allocated another swap entry. The
> > front end of the swap cache will have the option map the front end
> > swap entry offset to the back end block locations. At the memory
> > price
> > of 4 byte per swap entry.
>
> Wait, so you use the swap cache radix tree to
> indicate the physical location of data between
> multiple swap devices?

Ah, you haven't caught up with the progress that the new swap cache
does not use radix trees any more. It is using swap tables. It is a
512 entry swpa table array lookup, no tree lookup. Much faster with
less locks. The swap table commit shows there are about 20% difference
in throughput in some test benchmark workloads.

> Isn't that exactly what the vswap approach
> does, too?

Except that I purpose it earlier.
https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV=
8jKoEJwig@mail.gmail.com/
That swap cache physcial entry redirection is my original idea as far
as I can tell and presented in the conference earlier.

> How is this different?

The main difference will be I just get rid of the xarray in swap cache
lookup. I don't want to re-introduce it again.
Also in my swap.tiers design, the redirection overhead is optional. If
you are not using redirection, in swap.tiers swpa ops you don't pay
for it. Just like the ghost swap file. VS it is not optional, will
enforce the overhead as well. In my design the memory overhead will be
smaller per swap entry because it will be integrated tightly with swap
entry.

Chris

