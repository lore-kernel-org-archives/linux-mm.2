Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81F2D1171E
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 18:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7186B0027; Tue,  2 Dec 2025 13:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF156B0028; Tue,  2 Dec 2025 13:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B9A6B0029; Tue,  2 Dec 2025 13:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 117156B0027
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:19:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C47B41A01BB
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:19:13 +0000 (UTC)
X-FDA: 84175342986.20.D0E2197
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 063EB20012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:19:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHm4J6ut;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764699552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMrddpcTDtwocZJ9fUSQyABVSnOmZLLLX1hidIEy4Ew=;
	b=Wgt3vAb4NCBy8EEDG/oqdsjkOnENH7EKATf0PV/RCe9aJZ8HiWuCTfitK4C+xWN6YVpNar
	shW+GTP9VkBOoCiVfyGKCk/i5jxhaqsUTA1huXJfNj2doMZNn3EF3NkHg77daPRbUO8+9U
	eUfxleF/AWVS+ZeUiLv3PUvty32+x34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764699552; a=rsa-sha256;
	cv=none;
	b=gvlS+4y8cRsKSmvhYHRsTIpcRTLZE63sHPVfKVq27OFxGngpNhWPNorSdkuMwNssW+yZbo
	1iEDFhVr2CT8hrWjxwbRiNbKhr5kC1yRr4q/G/TIhh36hvsBRP9MF8746R/4sWSpHOm92x
	Ld+St3LMk/tA5Al6MJY77svZVjfbdJE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHm4J6ut;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42e2e628f8aso1297159f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 10:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764699550; x=1765304350; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMrddpcTDtwocZJ9fUSQyABVSnOmZLLLX1hidIEy4Ew=;
        b=OHm4J6utzkp8joMC5BGlBk4qu2Yu5+j6Aoyio5De6ZSZSVu5+bMfmM8jHWNLUIsDjj
         GwnY63MtepfqO9i2aCoY+eR97XikmtBn9hYXSmJS1TDtYL4hwICKVkmW5XNBCPzcKHc2
         vrSayP0K5/j9xyNbi9es0szFr/Ia4dSOEca4JubAbRJmv0B41R0cxhQEzM7of8M+yqzR
         cf/9DzljIUWRhcxo7Uon/n0m3ppejHWc7lmkMPv6qo6dRtzWYpy0mOqKlBEo2CCSw1sf
         QnU5wY8yqNFHwmmfdPzHuPfCULjx9EkeNOxL6kzI6qP30YxtkuibUwM9ZRkxQ2gUYoFe
         eA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764699550; x=1765304350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMrddpcTDtwocZJ9fUSQyABVSnOmZLLLX1hidIEy4Ew=;
        b=PVsg/0+Om81YyUMjlw0Mh6Duw0bcd5VZZM5oSdQCu8v3YkaPpPoBlbN4an3640TEh/
         1JaP87Ge29KKMV2YNDJJ8drhDDPJUYm5GAxnen3ImGHl/8srNKO6/jUfwH1Y9lHiwKSS
         3c+q//sWlgyEzGh4R73ByWHMw/5w+BHyiLb2fJOOjX+OHq9NWUS6IbwTsds+4UqeZUsO
         8QCjuvrtcyy7pqNFsQsDj47RRcYTLOFyC56PSO3jYaPIACHyxSBwnEeEhroCMKWqb6BX
         wkJ6dRrr43q19JjDByi0AfqHtbnE4jpqIZiFUe/fJmWZm3rq09A7jhhSug7U+gydfPuS
         lcwg==
X-Forwarded-Encrypted: i=1; AJvYcCWhMuuRJy6ajmDQCsMlxta5RwENPRka/q1IIqcD5pzxEAZOgHZLaq9vVDnrQfUgQDHSqJ7V/6+I+A==@kvack.org
X-Gm-Message-State: AOJu0YwAP/3ytPXviYazwtXEWWfDAyCKD5nUC91y5UwxyfpzsnELawKc
	nIwhDWsWRTfUCJghykyny/ckFMtBEU1XmxvKSXKfrlt7xQTde1cnAUjL510AyWXzN3mgkbWpGUb
	5C8PJk1OxqRJ8BApspaqnuYesJ+fpKAg=
X-Gm-Gg: ASbGncsWP9JXABa/DLvR+q5B7F0HCuWKrHgTIbEF0VzDOR900l4I1b3eaXXGi5vlyaP
	7E+bXyg21fzbzBl23yF1UTT0RBs52YgUf6TMQNKAqnZOXiPkjXPLYiARAtKkU6GhCNIwon49KVW
	Ajv9FB7vzZZDWez24pabMAMLgculYIuNY+QgRf/6b7jEtMwib7e2edOdfXyOxcqIQs5ItTgyfjc
	v13sKIP9HMlNmnndGwV0SU1mKbhJXR+ul8L7qE7wjJXnsop0b7OdBj69xskATvDiCdndf4=
X-Google-Smtp-Source: AGHT+IGB5bKNTzV+KOUNQ109gTZSRx849UVsYDFxuQ5iaQGOrsSfFQqrKQeouttpoHwnm0ITuqT0GGlO+rN6YhzNAqY=
X-Received: by 2002:a05:6000:1886:b0:42b:2dfd:534f with SMTP id
 ffacd0b85a97d-42e0f344720mr31125125f8f.34.1764699550287; Tue, 02 Dec 2025
 10:19:10 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org>
In-Reply-To: <20251125213126.GB135004@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 2 Dec 2025 10:18:58 -0800
X-Gm-Features: AWmQ_bnzSSyGA_zq5uTxbLQma8sCnY8_UkBiLcp8Yhjqk3bb8O3gopvPpZcvsss
Message-ID: <CAKEwX=MgJPFJNFuj7vQ+RjuJQiC+dOeTTEBLv6=Dna=MNFubJw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 063EB20012
X-Stat-Signature: zkqrbo9gogt8ozeubtpk18sx6qu7czt8
X-Rspam-User: 
X-HE-Tag: 1764699551-840551
X-HE-Meta: U2FsdGVkX1/qkWSKu2brhaMinqaZRMzVSRjvOSJ2yVyk0B99Xu33ysm94txOpa6gvaaISPl0OqEcyywFoRym4K0p39YPydkYm3/6cyAseHfMB9coRX4q8R29Hbh7kNmH0tseJ2ZGsfeuB7UjC90edrYokHpQlaKptmQavw14SRflKVTUY8FFWVYITLtoW1W1NPJNkfTo+bgBcuu2Wb7yW/DOITis7TvEHkxaZMTmn+rmcON5RHuxlo0/MNAwZHVeW/rqItLtsEpqVa8y8dpqZGM51z7XfJZ5Hs4eM9aL1eSh/7j0+LkgA2ltoo8t9/Ym8zVhFyUrs0o10sJWPooo0GAbbtsnnHkJ14YkYiu90EsOIf2PCdaKSLpG9ZrVDLMR59X1ea4+Eudj/A5CzghCfJMBy4+Wh6I50HfAIpIumK+9amX6E2JoYs3WP+iOJJkjaSrx7fUJqK5whvOsAVbMmEnQ5XZ35KDDROc/FbSlVzYMH/T3fDin443+OxTwaNe5hTr7bTqPlWB52/EDkKseN7GEj6zFuuIhoCKDQVh/mG+lNOBhImuAw7bWCfRjvFWUwlYD2vkodKWsPJ8NXmujp0xNLatjorsQ6SwslNNq9tqSgQRtfGflhQ61iQgpzk6Msj/TxbXQHfoIliBOhCB4NdNzK3pOnihkRoRi8yaIvQje9u63s+7xBQsaepGkeZWSJMf2IUV8ReNqs6LFUbs7uq0DtmkIl9DZ2GWdb1+5goQdBnQUjzHlHNygKo7NMmKqW+V7egKPiiyXxBCs7NGByjzM5nzE5eN+oFkQQozwiwW6UGfPo8yP7/XCvM93H0CCO7QKCAd1mLqvRZW7EtIGYOwxRZSf9txMA5CByahvtE1KZjn5coRk5cTm018P9t6IfpmdHnplA+NXspvxBlrxtvQgiLPqspbCTRsU6/kGWv9x+PtZ/VunA4AGeNqqhSV8LmTRrzO8SW9JLQDJ7cQ
 SjF79anI
 at1agCCCdcEfp0j4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 1:31=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Nov 25, 2025 at 11:27:04PM +0400, Chris Li wrote:
> > On Mon, Nov 24, 2025 at 11:33=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > > > > Do you have a link to that proposal?
> > > >
> > > > My 2024 LSF swap pony talk already has a mechanism to redirect page
> > > > cache swap entries to different physical locations.
> > > > That can also work for redirecting swap entries in different swapfi=
les.
> > > >
> > > > https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTo=
x2e5kFOV8jKoEJwig@mail.gmail.com/
> > >
> > > I looked through your slides and the LWN article, but it's very hard
> > > for me to find answers to my questions in there.
> >
> > Naturally, the slide is only intended to cover what is in the current
> > swap table may be phase VII.
> > But it does have the physical location pointer consideration.
> >
> > > In your proposal, let's say you have a swp_entry_t in the page
> > > table. What does it describe, and what are the data structures to get
> > > from this key to user data in the following scenarios:
> >
> > Please keep in mind that I don't have every detail design laid out. I
> > follow the first principles that redirect a swap entry page should
> > only take an additional 4 byte per swap entry. VS blow up the swap
> > entry size by something like 24 bytes?
>
> Nhat can lay this out in more detail, but there isn't much new stuff
> in the virtual swap descriptor. It's mostly just a consolidation of
> state we currently track elsewhere - swap count, swapcache pointer,
> cgroup ownership etc.
>
> The actual indirection is just a word for the backend type,offset.
>
> That indirection is the tradeoff for swapped pages. In turn you're
> getting back all that other stuff for swap slots that *aren't*
> currently used. This is a win for the vast majority of users.

I will also note though, that we will merge the zswap tree with the
virtual swap descriptors as well.

So for zswap entries there are actually no extra overhead induced by
the backend indirection pointer :)

IOW, overhead for zswap-only users (such as Google) will be much
smaller than what Johannes is describing here - pretty much
non-existent :) While you will still gain all the other benefits (swap
space dynamicization, operational overhead reduction) of swap
virtualization.

