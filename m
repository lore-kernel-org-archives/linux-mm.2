Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8AB1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDCF6B0093; Tue, 14 Jul 2026 09:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486F76B0096; Tue, 14 Jul 2026 09:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AFA6B0098; Tue, 14 Jul 2026 09:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F03BF6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:47:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78408403B9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:47:14 +0000 (UTC)
X-FDA: 84987508788.21.CABA60D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D6AE4000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:47:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LB/8CSbN";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784036832;
	b=sws6SeiWtej/LM3khn0opNvEhsdmS5fNKC1nvxx38JzamBWKlzNGniTiZL9Zy2BoBFfv0B
	JEmHO4WRmGU1nPEh7UdEKKpnLs3gDJJc3e987KLMkRT0N6DIGL6+ldH1Nzh4KSw52gPCFw
	Hlvm1e01caluoWjpY/OSXDE3HT/zi4Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LB/8CSbN";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784036832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVXdaK2c8G8evNsHKw/C2JRPENt3K5Jpb3OpKjeLkUA=;
	b=WnbDn1Ylnl2ARRnpU1EuU7hrHPdoC56j/D1L0h6uoa9G/zboaH3xQOjsH0mvBZ4zVUAbUR
	V0Lps+qewk/ZheH1NoNsKnRtqxhfMIqVcQZEKP2S/CEWVz6q5BWcCqjTGr8o0GAHiZ6oRa
	vKdh+l+lcDCC9Cn18US9gm7yL51+Rx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EB77419C2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A1B1F00A3A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784036831;
	bh=LVXdaK2c8G8evNsHKw/C2JRPENt3K5Jpb3OpKjeLkUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LB/8CSbNgC0TdnmxsKyQrPpzOy7HzaXj6/F3Ax7OgH4RzmEEObjOVZTder8OBvXEV
	 8tePK/5pGDcD3kJW70FwgGZQZVHwsuIAoVor3mapUe9ypgEZNHpPn4WCxgQ8t/iyoi
	 4I0O/uih9TREsTxiL0Duh+RDatUe/xyYUK0M5T1VMWyG0wvh0yrD5x3MekJp+XCea2
	 Ac+pR/nzTlsVNdDilXaHxyLY4QGDTPPzVjEuXIzMpxG/4OV0aQaq/XHZDhbUIHry+w
	 pDhKwuX7VB/BxNPlOTfcXOfesziaxjVuO2YzUwWbb7PpMc6AYW30RV89P00FYgx7GX
	 b6WVxYPJD51jQ==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9217d13c276so277199985a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:47:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpNFB050WoXVYB2C02v78gKFdkP1FYq4GlAHY186pLjKOO0/4MBASxSxMsCfZz+YwQHroUWSKt7qA==@kvack.org
X-Gm-Message-State: AOJu0YyNxrcnFVQxyVaVym2XHy6+WL+UrDktjHE8eLPZom0g947y+ReI
	fukoCvcoeCqyXNDJ1IKIWZjzx8XbkOnQPsd2YUtqQefnh7tnDIUhaTqMO9Dd0YkEHldr9e6O3TL
	gWfNZDSUoUxcyeRbR0P6b/ktFzjXzcPc=
X-Received: by 2002:a05:620a:27d2:b0:92e:efc8:cbcd with SMTP id
 af79cd13be357-93083c766c9mr310969485a.34.1784036830770; Tue, 14 Jul 2026
 06:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev> <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
 <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
 <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev> <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
 <bfb1cfa1-691a-4bac-beb6-caef9b3ac4e8@linux.dev>
In-Reply-To: <bfb1cfa1-691a-4bac-beb6-caef9b3ac4e8@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 21:46:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w8P8ERoXJY70wXf71MYEA16vX+JMAaE4sfB4=OqzN_Pg@mail.gmail.com>
X-Gm-Features: AUfX_my8Wy9WuK8pVudQOCevj6gZzWFIrCPc6vkC_rIS3KHDzSv4JuNzHZriO3A
Message-ID: <CAGsJ_4w8P8ERoXJY70wXf71MYEA16vX+JMAaE4sfB4=OqzN_Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D6AE4000B
X-Stat-Signature: 53pw4jouq66sumuqi9jo4ck3745y8y63
X-HE-Tag: 1784036832-643018
X-HE-Meta: U2FsdGVkX1/f7EKJVwCN5j0hCn3vVz0JsfPtWhMsJXH6RZTK3QWu2Gk4CbTYZzs2+seiqwtACbj1aQXHunvQXA/pL/ilC3QECH32hV6gMdpW0SLMoDUFfZS485ogR4n2Pfn1IAWmlZMbFD+lMJ5EPJL9zlqtTrSYUcpNk7IkIT05EyXAWgpUW4rciG04NGoC/Wd/lgkBPSZZqHr/EIrzVEa/x1HNJyBsWrgi42gToOOVbmQawc8IpAmp3QMG8Uy4QtI+vUM6Hu9j5SYYbkea7GFTpC0gvJh+3o8BObgrL/9eswrTjNxEXv/n1ClCsS6lSEHAnOwlZa4DDRE5pINdyokLMDanLqguiuVBjJVqBW6tGrX0wi4cFYZ4LkXlCX7FANpKkEw8ZnQObgYEAHLaFreEZhUwzxs7IPofTpVbZYvZ+aSYwTDiEuMdhRVubtfdZpmUAPB6YS3k8RmzsUFuKMvgKjK6l4YKhpQEiXEHkTICULeLyHlJhlok74VJ85hNvHrXq9gmvKOE3JU888X68rrkG5v3b+4vqw9hqcne/zUj6Fn/9EGEtJuGrzMbCYOOcy/td3JTPBneQ19XEPrg5z6oIagwDrUGXhgWFzWxK27m4A/p3Cre7grWf3vOK4333sT4/9OubqfwWqvEwi4dp6ML0Y4rb52crQcVfTjQ+rGbXhgrbNJp1sw2bz4vF91lir5JUFTn5x7Nlp0dP1xdN9xqyNv3Yq0Di9Gd8pnc3WC1ZlB1ZMa2xkuzCvX8bjaFMSlmUbFTSOx4DmGUNXRQ2nN4NKDbxKe+axCV8uSmnmC7cv2/qpme8wd7tIIaAKjp6zkHU8AbMGQwjraI0yM9RNdNAc9MjcXD2jT5D+IwEPtIxa2vK3m38U/+gGdldeCL4fS4AmYDLg+euIA02Y7k9zC9BreiVx4BdUnsLlvD4GtUr4zbzaVEu7Ez3kUPxJQt/mt8ARa/r9M4gNVRhYE
 NCobkL18
 Yd7BpyyX16807/XXC2iiwT6C+CxtOTsznHMhjUAs1/epemr9m1ET1pVe0hOIJo+BHXBOB2JrOKYSX/cjwio3E9v//3An/Gg+3QRssSkUQuiOfFNJQh6UmY0hlJvycjLhxcfvWAK2CQm6I48E8aNyxiEqTg0tY6nzawPuxSHXFIweFM/CCdD4xCOM/Frd9TXPU8Bjd6wxvQ0gwrGlpOyx/Bh/EGWgfSRZu39YKiNcjL0Kys952MgKyUXhOsRozxDlFtP/tg6XQB5WlZN2ICF+HA+3LlP/q3vlXsSrxS5vT2g2TEDvUD9mUsXB1JazNaqc+K4IJke3UwsykbKRByJWkAO/nsXvWuaVoqEn7lzafX87bX0VNINvktUGvGnW13dLO/XfF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 7:31=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:

[...]
> >>>>
> >>>> If this is the case, it still seems better to keep
> >>>> extern int vm_swappiness in include/linux/swap.h.
> >>>>
> >>>> Then we don't need the comment:
> >>>> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >>>>
> >>>> It also makes it clearer that vm_swappiness is an extern variable
> >>>> belonging to the swap module, rather than the memcontrol module.
> >>>
> >>> BTW, if mem_c_group_swappiness() and vm_swappiness are only used
> >>> within mm/, could all of these be moved to mm/swap.h and
> >>> mm/internal.h instead?
> >>>
> >>> We are making a big effort to move many unrelated things out of
> >>> include/linux/swap.h recently. Could you check?
> >>>
> >>> https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-l=
ru-cleanup-v9-0-2bc72b4f8730@gmail.com/
> >>
> >> Good suggestion. Moving them to mm/internal.h makes sense. Will update
> >> in the next version.
> >
> > Either mm/swap.h or mm/internal.h.
> > vm_swappiness probably belongs in mm/swap.h rather than
> > mm/internal.h, right?
> >
> > BTW, I am not particularly eager about this cleanup;
> > it could be done later as a separate patch.
> >
> > If you decide not to do the cleanup, I think it would be better to
> > leave "extern int vm_swappiness" in include/linux/swap.h rather than
> > declaring it in include/linux/memcontrol.h?
> I noticed that some swap-related macros are already defined in
> mm/internal.h, so I'm planning to place the code right after them for
> better grouping. Does that work for you?

We also have mm/swap.h, which is dedicated to exporting
swap-related things. Is it a better place than mm/internal.h?

>
> ```
> ...
> #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
> #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> #define MIN_SWAPPINESS 0
> #define MAX_SWAPPINESS 200
>
> /* Just reclaim from anon folios in proactive memory reclaim */
> #define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
>
> extern int vm_swappiness;
>
> static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> {
> #ifdef CONFIG_MEMCG_V1
>         /* Cgroup2 doesn't have per-cgroup swappiness */
>         if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>                 return READ_ONCE(vm_swappiness);
>
>         /* root ? */
>         if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
>                 return READ_ONCE(vm_swappiness);
>
>         return READ_ONCE(memcg->swappiness);
> #else
>         return READ_ONCE(vm_swappiness);
> #endif
> }
> ...
> ```

