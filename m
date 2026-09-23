Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06BEFC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE3C6B008A; Wed, 23 Sep 2026 03:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8603A6B0092; Wed, 23 Sep 2026 03:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727D76B0093; Wed, 23 Sep 2026 03:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBCD6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:00:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB9FF1404EF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:00:52 +0000 (UTC)
X-FDA: 85244129544.26.CC2F709
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C088C1C000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:00:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuGgxUdI;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790146850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCQN40gpWl4KlONMsfIv5Q1s2Cplx4oRk8E/qqjTVqg=;
	b=MKitGqZxMgxMlrCJRVDtqN0vTaNdRmfrEM/MAg5lm9KjViQ/gCcbQ1r5buC6xlaWkxEp3+
	1hAewcpKsjsSK1xbfYeDHnxZNXdOBkAaOZdsu28jeMHt/hy0onjQMiKHBEbygzKggh4H7g
	Z9uzcIrdtqzPXJhLhwsuBliOr9HZ5RQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuGgxUdI;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790146850;
	b=rs2AzaEChFf59e5azYo5V3ufvXpaIAX1GCmoHhdmSYka9ZzmZEdFTjGAnaX0yCrg4KOfQH
	jw4mUd9HWeUSVg2t5ljTfUKDuGmlUv7Ixt1Hrdjw+sqRkUA6DKUGvnnqFQqMPwRM2X3sn9
	729ko4V7WOuLsAgDvUNY7g7uTBJfxD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FD2344887
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ECE1F00904
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790146849;
	bh=lCQN40gpWl4KlONMsfIv5Q1s2Cplx4oRk8E/qqjTVqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MuGgxUdIOC23Am0lCqXeku8DEsnnCt1yl3RWtWDI7hbJxBPJHEkP4chf7CUhyAJec
	 Fb7pJ8u+WwNqxj5W1gcmmm+iWMlF+aN/N4VOWBTR+VNt0K1T22HbnQEcD4K0laMnfr
	 VvEdPkVMqw5Ck76BL98HKW8/9sq8zan06nWRUti7boVVNJ6FmVGg3VstsQzti37524
	 mQwZ53x9xrRJS0G7ttB80RSRErXxUXmB4t+bd6YUb0wCvkWh9KeDpguAU0F7kO2AHg
	 +kLtqfXcbKbM/db1BKYGK3CZxsL4z3F9Huq5AV2s7D2yDmXSBzZX+fpKzYZAzyTijm
	 O4prJqEQV8Dag==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab20a33so655447d50.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:00:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwCxiAutGmCtgIazl3nTsHPm1nymyPd6oNahyn59eFSl/Utr4cOwkyeV8hkKK+O8kdU0mxLy4FhMw==@kvack.org
X-Gm-Message-State: AFuF++k1YTiXPJ0bP5M8iU+k03e3rou46Fa/ggWur6SZyGzxn8++1gZN
	1PBJhWAu4Z51e6dHA+RohfIHlEFseBtk3dX8tPuLHapKzZPcobKLLxZ2C59d8MuTZNty/Iq/WZ8
	Gn+46Sly5/Gni5y7EQv7tr/9imjKX9I/Br1gKG1nS5Q==
X-Received: by 2002:a05:690e:1343:b0:66c:c7f5:df48 with SMTP id
 956f58d0204a3-672d5737312mr802920d50.1.1790146848099; Wed, 23 Sep 2026
 00:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
In-Reply-To: <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:00:36 -1000
X-Gmail-Original-Message-ID: <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
X-Gm-Features: AcwNN1XT6dea5Ukn40MXBsRA9i8L-35_Qe0P1p4ktS2PPdbOhpSXJI25FuwqsFY
Message-ID: <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C088C1C000C
X-Stat-Signature: ehe8j7mua6h9ym7iomkpn4b5ijsh8ba3
X-Rspam-User: 
X-HE-Tag: 1790146850-730267
X-HE-Meta: U2FsdGVkX1+4ZIVznrI/9U4rbecQ3ElMABGJTPYYCOLlqxVfIfSyFGpn2TZus3pJOcc3a9fuVRdM9J5eF6ZTjpLwlOoX0OdBoSqxblwy+uHGC31/VOArMv6szY1lW3M3MHlpz8xaWTYuYvDxbMEBSGM8hLqd0qogkW0jS+OFhaEqfPGDcWpc571E28mBcDjm7OflSXT8ZOfpg/WzR69T0dbU7QFOjnpj0JlxvKHjg/G6zFRnMqh1aRGXRqWrwnMDjTDlMT5z8s8XLyg8zyFuSKrHu/Hq2n52hVshfezmm8dHRO8EofqLuChWCB1ef9Vp2cmhdEtTseueBZ/5GpxzA856c/0BGmZnGVPgT0eH0LAQjpKZDns4RHcDY/6dYGLgKzTqDBmNF5Z11y0asgdUGBzqcDJO9AOtOig9ixzx+oCohvxdIfUKtvGMX47sNvFjgeSVQt9Gwem3HG8AezAr3sZxMRa+2TroP6beYcum8vKtpvyk/cGdP/UNYRrdbcrh8OijN3xmZwWmp5I2q2qOfw31hc8MXiBwCQB5cjgbTmsS5ykkf5D5WJzWQ718S5qAOHvKkJr8aHbCdkJX7BHk0g9eSjRmCrHWU4niDoWJhA8eh5kcW5LH+iXIktYIcqq05kcMkhlvdv54YQLllp2SAXIj1waI+fLr0vKY8+eViRV71ykSQ3k1V15wksYyvfUDe0+S1Gb4s2e67ZpTXw9gArcjU/7q5G14HrjAw53wey3kJTZ8WzSgxFuNT3O2bakvcFm+jEclq7OsOYci3ZASkqTZCuqmmgTFafjFo0yIQ0hqPqR7V0XW3BsJ0IOtobp2jsAD8AxuLfEysA9XzPZnqpe06e8te82rrC19UcoMI6L2PqFUi8QhVMPnuWYNA/gu2pn7Qp+QxZTfgiQ2qfq/37bK05gU8tpjFE787mBVKcdes4VwsQj3ALkmLxQLdnJEaw8ecUPNwkvhGODWrMJ
 ibXNgtj4
 xXZjxxzxjcjtNokY0hU/6W6UT1U8Z/NAhGtvlxEbKhLz8fqHtDOiPRjQ6KZhNSJbi8YYBju6gHIu+7au+nEOsTITQc6PZkigfH9E2iLqNVZ0EruXaqWYmCTZ+JK61dtshfk5tuEAKGWks+00qTX53VhFt5S+ECiKw5hn8QkHDTJzuGqlXNULI9r/apEBwCRpgOSlYnFl0e9cLl/+a076tt3SOgqcujzYBFYns5WCiIsG/G2oaFMn2FHsS5MyYbD7vcD/lZe1wMAg5dSjvY6VDsCkSEnX/ZAO3t9hw8xC43ft+ncDkTsq05gHZXuANyaa1Vgiss4XcsywFJJ9uColPBP/vWK0Be3qh+9ItYmGieQsrAQ2dgzCkQyQgCD18lQjEnyFgcXqIVwHUvcsaUljgjJ9r4UWYRyPqBYGpEHiGz6AW6Uc6aj3KQmOZI7pv2mGYFU0R7ZfXGp0omDcSX2CuBwiSqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 5:49=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 05:23 -1000, Chris Li wrote:
> >
> > > > > > > Zswap:           8812236 kB
> > > > > > > Zswapped:       24927876 kB
> >
>
> > My original request was for the whole system: what percentage of the
> > total system RAM size has been swapped out to zswap.
> >
> 24.9 GB out of 64 GB is 28%
>
> That is how much application memory was swapped out to zswap.
>
> 12% is how much system memory is used by zswap.
>
> Those are two very different things, and it really is not
> clear to me which of the two you are talking about at what
> point in time.

Let me clarify: I want the ratio of memory swapped out to zswap
(before compression) compared to the total system memory.
Give me the max of your fleet is fine. I have been asking this number
for your usage case for over 6 different email now.

>
> >  My observation is that, even with zswap, when 100% of
> > system RAM is swapped out, the application suffers greatly. There is
> > a
> > reason why we only have 7-10% system RAM swapped out.
>
> You mean for your specific workload, you do not
> want more than 5-8 GB out of 64GB to be swapped
> out?
>
> That is perfectly acceptable. You should be able
> to configure that.
>
> However, your configuration values are not a good
> default for my setup.
>
> I believe we need to set the default to something
> that accommodates a diverse range of desktop and
> mobile users.

Act. That is why I am asking for the maximum percentage that
represents the upper bound for an actual usage case.

>
> Most of those users do not know what they will need,
> but they will know to close a few browser tabs when
> things get slow.

They don't need to know. Such a bound exists naturally. We just want a
safe margin. You say such a boundary doesn't exist. I say that
boundary exists; that is the main contention.


> The companies running thousands of servers that
> are carefully managed, and which overwhelmingly
> have the same configuration values deployed to
> them are more than capable of setting the dozen
> or so config values their entire fleet might
> need.

I agree; I wouldn't want to configure each machine differently all the
time. In my mind, swapping out that much system RAM to zswap already
results in a very unusable system. If you haven't try that, I suggest
you try it before suggesting a number > 100%. At 100%, it is not a
usable system, so we don't need to make a default for that. Defaulting
to 8PB or 8TB is way too much.

Chris

>
> --
> All Rights Reversed.

