Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498ACCFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8FA56B000D; Fri, 21 Nov 2025 20:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67496B0010; Fri, 21 Nov 2025 20:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D426B0024; Fri, 21 Nov 2025 20:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 862C16B000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:52:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FAAB5AF12
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:17 +0000 (UTC)
X-FDA: 84136567914.10.13C0086
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 620EC40008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kR23cPdu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763776335; a=rsa-sha256;
	cv=none;
	b=6WkDM5hOuT44EtsaJ0e+WP8zK4CgOrRD/msFc3+Cfuzm7RFpX92pbfwNI1iDYFky/HF033
	hNkOs7VCFGgEfwXoSloTKWiN/u1GJ7BH9B1ylAdU0dpMI1BaeweO9wnDVgasuBLNbGW4G0
	87wrTPAt1nNPHAIYnFN3SwNqfPxJTfA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kR23cPdu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763776335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHI5GjxT6zjY2XWBHmpg5SZDceFKfY5ghFp2mXTflP0=;
	b=BBz/bBPeD6mH3jpNQLxjiCvNonWSOHOh7q1EjqQJZL/0aFqcgcQntuDSjaX+GQvJsqOV0A
	mTpKufaRQxTRwscR94dBkXapdZ98dnor2BjiOKv48ziJkUfvvFbCP13eF4WR4Qgmk80vqd
	uFbZ5+tCKbJEgZryZk/CEeDfaGBeTfM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B9A64412F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30908C19425
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763776334;
	bh=ZCn2/MWLUxCncIiNuZHLoRgFDDNHcFoJ7cpYzbunvP8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kR23cPduLxq+NgSZYNVLIxFiNbyJ39EGYuwWUDtMT2O9siK+bmR9CTOo/K9GwGFn3
	 RYfSiTbZLGJCqvUYOBwt6TQ1Z6Jrp4dCOIDjtBod5DTsYnJzUIawIQbnjfUW0wv/ID
	 Z17B84Ke2Y9uyk/3egNAJhBhfCN/94vF0rwYvGb3QxHlGJu7bWQeMEUKlW9nAknIPz
	 QmgW9tplDVZwqKJb7L5VrCOfxbIqOLkuHBnGNprctHjntRu/hjDXab1uWm0OLaIw1n
	 121ANF7K8KIoqMrGInUQ0YOte1v8kJ+YGUbGER3vjmbTztvlJVACkTFj4UhBXYZPwk
	 5d6LeGmtvWoww==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64107188baeso2389818d50.3
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:52:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVgdxmo9Wa9JfvxHj4r754UM9svScRMwq826ffKNOwz/aekltqWIDMZXToUD2kWomMU5Ceoi9sx+w==@kvack.org
X-Gm-Message-State: AOJu0YxUxRLvnMldcgICrQ/2MEk1FCwSK+D9OFKQ1l7drTmxRN/cDxKi
	3KkY3A0EZVS15b1S82FCMcNRIzjuR29MqEp1yiJirJ1rO/FV/23Kq330lLiixnJtV8a9rfH/z4S
	3x/Asl3HFY1mIvjJ+Gk4Q2auriIJjl2mKTg8WGYtZyw==
X-Google-Smtp-Source: AGHT+IEAm5eXaDJA0ug3j6xa3GPN2nQbRopEHhPpVDR1oTbNakWAIQcSMIknmH7nt/ZUFktBvcx18HjwB79oXFw1Vrc=
X-Received: by 2002:a05:690e:783:b0:640:d092:6489 with SMTP id
 956f58d0204a3-64302b10732mr2391479d50.45.1763776333423; Fri, 21 Nov 2025
 17:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAKEwX=PQM_4Mp75R4yeQ=WoqOxj7EJK=FpgcemNSYDS3fLXQLw@mail.gmail.com>
In-Reply-To: <CAKEwX=PQM_4Mp75R4yeQ=WoqOxj7EJK=FpgcemNSYDS3fLXQLw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 21 Nov 2025 17:52:01 -0800
X-Gmail-Original-Message-ID: <CACePvbUxCN_2fHz0Ds=u52mmOvdhonvRgm6mPdcJcs5qLZj55Q@mail.gmail.com>
X-Gm-Features: AWmQ_bkNzFm_ev53Xx68GqfiNuab2jXAtWSl1H7nx4Q5V4oO9OcG31hxT_wmH4I
Message-ID: <CACePvbUxCN_2fHz0Ds=u52mmOvdhonvRgm6mPdcJcs5qLZj55Q@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 620EC40008
X-Rspamd-Server: rspam07
X-Stat-Signature: b34ms5rdqwwtbc5nxnunf1uqh51uuuc8
X-Rspam-User: 
X-HE-Tag: 1763776335-834186
X-HE-Meta: U2FsdGVkX1/r9oBn99KzNpT31RXUE3tncCcVzG/2Nv9ek69KzkRYZ3UzqIO0XdSeVKfQNK3vK/xnibQ8c7LE83e47HZ1UPF8yD/weimW4MjKThxqoaB325v5ZzgmHx7lLNZSbOGv61HfGKtbRl9CYfZnKcP1HE/cm+revnNwsMjrEJx2/jad6vbhwH0BB9cG/HkauAIwCNP8S0jxw/IklXAtGLQE4lELU/aCksKT/tmCbNRSC+uJ7qjy7WrEC7NsXtXS87tjn9MblnTj0y4rTpJWiko+fJwaT3Co0UhoKEDcqEI7qhVBUdSJ4xcowEqWijFtREj4FLgbIKhqHNWqZx7UAJrSjsYOw0MZv3uZSizoxx0itkVAfC/IYdIWMASWejq1ZQEHhXcwjx8vWUrXiBa3duejToEfOot6ficJwlq5E7hjjmOwXa0FOBbF73f5kDXs98kGVrbIZ3GhkEZC+E0TVKGa84/SFRDkEMOrVD09icObkT1Aj/baoQpnZ+tfMebsQUXEEDfr1j1HJapwFhLUstYf8RpNGer+OSCiUUdrLNuMCocyW4jVcPLPP0iuhw3v87dT2/RZGi1amyKVPmIyff2Ojwms9oKNXrE2FikU7ANxqU6rF0ccPjCXT0GClkKFfcw2qemvyArqyXLAnF/Ove/e6VWJnEXENexUEvUAFOozeyha00dlXbPRutss9oKYSyXfhTiCOyab3hv6rk1rDIg84XDMAFVn2hAUFzsvSlfoz4AG0Qbb+6qZooHnu4PPMif2OCtN8MVF2CJs3HzhdimSx0fTaIj6vgFoXrFypPuR8sDcxmYjkL6kjnxjRi3mAHepis86lJ3hU/ZHMBodF4+L5GpswfMLR/Nc/WJc0Iv/SLpEVRpHBV1z+YcX2NfYyEFKz96i4iuc8xdrCIUR51aL7SLilppgw10lggc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 2:19=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Nov 21, 2025 at 9:32=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
>
> Would this also affect the swap slot allocation algorithm?
>
> >
> > The zswap write back has been disabled if all swapfiles in the system
> > are ghost swap files.
>
> I don't like this design:
>
> 1. Statically sizing the compression tier will be an operational
> nightmare, for users that have to support a variety (and increasingly
> bigger sized) types of hosts. It's one of the primary motivations of
> the virtual swap line of work. We need to move towards a more dynamic
> architecture for zswap, not the other way around, in order to reduce
> both (human's) operational overhead, AND actual space overhead (i.e
> only allocate (z)swap metadata on-demand).

Let's do it one step at a time.

> 2. This digs us in the hole of supporting a special infrastructure for
> non-writeback cases. Now every future change to zswap's architecture
> has to take this into account. It's not easy to turn this design into
> something that can support writeback - you're stuck with either having
> to do an expensive page table walk to update the PTEs, or shoving the
> virtual swap layer inside zswap. Ugly.

What are you talking about? This patch does not have any page table
work. You are opposing something in your imagination. Please show me
the code in which I do expensive PTE walks.

> 3. And what does this even buy us? Just create a fake in-memory-only
> swapfile (heck, you can use zram), disable writeback (which you can do
> both at a cgroup and host-level), and call it a day.

Well this provides users a choice, if they don't care about write
backs. They can do zswap with ghost swapfile now without actually
wasting disk space.

It also does not stop zswap using write back with normal SSD. If you
want to write back, you can still use a non ghost swapfile as normal.

It is a simple enough patch to provide value right now. It also fits
into the swap.tiers long term roadmap to have a seperate tier for
memory based swapfiles. I believe that is a cleaner picture than the
current zswap as cache but also gets its hands so deep into the swap
stack and slows down other swap tiers.

> Nacked-by: Nhat Pham <nphamcs@gmail.com>

I heard  you, if you don't don't want zswap to have anything to do
with memory based swap tier in the swap.tiers design. I respect your
choice.

Chris

