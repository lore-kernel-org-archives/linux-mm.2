Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4049DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97AF6B013C; Wed, 12 Aug 2026 12:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B486A6B02C6; Wed, 12 Aug 2026 12:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10E46B02C7; Wed, 12 Aug 2026 12:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDCB6B013C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:31:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F354F120417
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:31:35 +0000 (UTC)
X-FDA: 85093158150.20.326DB16
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id F40CC140013
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:31:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/khMMTe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786552294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
	b=kcu8ZO+15mfPWi8kUns2DSi4wlM0c9U+2n02PuqVMDmT+ePJB2DpQxlSWGPEpAUgbqk8RB
	1bhFUjzwUpoD69JrV9bBTogHd7tKHJ1e5cA1LBflTTUJTUujUC42X73yM41jmBnPEr23Xh
	rPqN0CEUSYThjAqZWDEpwHqEny19h3w=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/khMMTe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786552294;
	b=EW4slP4gtqEvjPOthhva03edr+6ymK7h88zep4v3EyZAtLnlPm9DhzrPv3x89y1BJbWZw4
	DbMQ8IdSkCY9Zy4vrOFiXlq0GZ5kO4VT9bWFfX1T2Ugub7XeVZZSygRQG1m+p9cHp8d2wZ
	buKxldX2TzA5OzVNvU+zw/n0JRTenFM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso695160f8f.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786552292; cv=none;
        d=google.com; s=arc-20260327;
        b=Ua7K5Li0BUb3x7XR9UKhIyQ5Of/FC0kjUP+ySrFDXlMjLizOHXLJi8UvXQ3/YjW2Dt
         ETKtGrM5nr7sG+11HljCAEcRs8GEsPrzJiuxsk9rJWViUZGFEPS5oE2Lupn9o2v2tQ1x
         LgmAWudTSO0kRYnwMiXqmybgNZjYSKcMJ0oBDPIj6KPH1io7AP8h1Bd6zYSCHBtwBxZF
         TNKYqIqfdDlWUNEgzyjPODVzq5biVQAlN7Re+s/hZAk1kNQtNU3Mgm1GL7EI7P0H5E36
         8MG9pIJmxGPiHbexDbZI5EjpSXvp9uqRgTXjf7+rYwLsYlNFvjxxKuUf1Y9r5al2Oi6f
         ifNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        fh=DjRXffLACezBquG6QdWlBYgZBEQYeJqbaEmu03JK0/U=;
        b=jCi1qzsaIp4AUkAVXwZOEh6Pb1Uz9SNYU+8RJ5v67nAKlc9BesoshkjrTtJi5iRp/i
         QOJ9ommTDZPAzNtSRfUeRv9DT4EU9H4krg7HBVE227+RmfYDe9ZSfSribAYREzY8gTRl
         6BrRjbS3+pjBNyOkuPPlQ1J+kPYU28hWR5X0PjK+VtLiRbDiINyKASnzAiQc1pAnNLqF
         +i8yXd1cc+WVEJzHfMZSqwVy9gdgLJBGbx2oBl9E8oUwebbnRMgW3WDaKUD4xtJkVyt+
         686+n0ngiIFGtNfntzet/eumxDr5mnmn4KFiiGFCgaoUufft92bmXdtwK3YCSx8Tf4wg
         P7yA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786552292; x=1787157092; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        b=k/khMMTeHbx1TxFZv1XK5bxrbUHrgxG7EpMStjEN1VkfLXKHoYggIpjVF/W+bDumA2
         4ZdaIaLxAs7sU4yvlscR6RUrEwpn5AY9kZwLicGBEEQmji2dty7bM3SagXrwsgZHbPZl
         5mhcF8T7H5VT334+giXNJLJJi6fAunCROpO597RKiZs+V8ba7hWFjSdbMoSpeUYMRy8Z
         cHEsSfPU66GFsPO0xP6RWWKtYxliGOM+i5jVJDAdHhtOWEOlTKWS1pVOHRutA2ZrmGGw
         5w/zz1YHOy4TwfyzodFB7jlshZjtj9u9BjYCqWEsjBg9d6q/VhDhOkqqLu4+o8a+9eLs
         Iu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552292; x=1787157092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        b=LWfeUuVtiIX1Fqw23v9qdsZZXV0KuHi9SwFKtSruQ9DB1QXINIIq98dVsvk9D7WSaH
         2mqtUZ/QBJbs1ClMX9AqmIqITUISaIcUqwtByrh6bbax6dMKwbrV4qbaQWcqRhkoc3aU
         NyF3oz/hG3WVhUhcPsuxZj4MnAeIqK+tcC4LhxQgNiZFP0eWHo0HW5AgNOifM/oJlFQM
         GMpRfDXMH6McfHOEyafecIWOTCx+I26iFzyY8VH99Puxb+XjUczEODMKy4AgujmBT5kk
         xMX9b2j24CP+iLU1/hTE0QEnNIPsGwhhvAIyd/25cnGdfDxT1bRg6Silzld+CeSOr4qk
         wMUg==
X-Forwarded-Encrypted: i=1; AHgh+RpSGFvi9V6lKgpWyrqr+TzxiyNGqoVryjbkBcm6tEYGJjmHRqbpvaBqsN//Vz9N8Vi5YZFxJ172SQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/F4n1hIZHOK+mksEdJ8VzFS/C9ojC6IsiRDOm8WbmlVhfLsrn
	j+3sip8ktI/mF4XNCbITpXqFVy3H1La7FU+HmTwbmshFT+/KghEjLv9ofI7O2oDNlxqX6r0f0eb
	fNQ6GzlafC2wl/KaZ6GkvI61D0UP5uEg=
X-Gm-Gg: AR+sD13fSw/opqw9V7VAmWDRH/SUJTOfbDmoBbRAi+h/AHPyd1geiIGNw0bZZH6HLtq
	bGKQ/WLPnlJmU2EzwCFL9uhHwRP/35Rtss+xISNjWtPNfQS+wirCImWuXp8iwLwfBp9puA1l7aK
	cZ8Y8b/aBJMbJ0x2qlq3KsFek67z0EhttespxdL93tatlEzIr+VtcVj5dyURA3VKh+NMQC7IWv0
	PmOnJj37KXpGAqr0wtdVHrc6QOsHng0PHLgmgpRkfPWJj4y8OpirBPIEeGamkvZITBaBx2kDM9j
	vMWLI8Lb6ArzR2ZujY4ZxZO7QZq6QDUlBwFdu+0hF3E1JBPu6tWXo1EquysyfFYZ4mqQ+feU5L8
	+
X-Received: by 2002:a05:6000:470b:b0:481:5657:5299 with SMTP id
 ffacd0b85a97d-481565752a7mr6852007f8f.0.1786552292251; Wed, 12 Aug 2026
 09:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
In-Reply-To: <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 12 Aug 2026 09:31:20 -0700
X-Gm-Features: AUfX_myNxWLKbey6UqnimGgaytWlmCtyk7j5TdlPuoAnbTv6EzNqg0hpri4e0do
Message-ID: <CAKEwX=NNVshitZv+zp6ONVDku4JWcwGgZ2-hSirsKfa-fs6D9w@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] Virtual Swap Space (Swap Table Edition)
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8rdacbdgyrje9iandc4icnq9th6ahtjq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F40CC140013
X-HE-Tag: 1786552293-16990
X-HE-Meta: U2FsdGVkX1+na/xU+834/uX5/4yLJ070qcHrkuCIk+Q284tKGJ7D5BlfYve0f4qucz0+bkWwUjX9DuFZ11N9He8tcDSs5BdcpA3lyCxpHNtFYsNm1kDVQo+0QamcSEJuZOwU/T6JzhYPoEWwgN3puW9NSx+zjwNbmW5KJs/l8fNtcw4mx1TDTyG205fL0q7SfZV7lHKWsF2bKPt0ciQZABli2FNUTIS0ej8t1hOzuWPWXmaqUNjbX+R6vIcNkbX4ptFWCDwmlGHdzVEeGWtKDp/i5iPOiey3lnfGkpdtZopSnu8u+YiB3BUW2RX0uWeogeLrw3MV5UNKd6PFW0eZOF2/14wCuQdJSGit1qWxYiGuP1kmqjDUqPPbmnnxxEhiLvgFB2D54oAwmKkTVHcot2KQeEHURaiwQHUehE6LARZ7Z2oq2kEmUMFWyqGUaFwZ7AhViO0t0Q1K0BVfkeO3JiQB2WEzFebXdOTV4DB5IjCjmf9h4tKo7r+Vk42VoO/eRx5/x/r8weS+ucy/iwt1iWVNrffP3rLTsPi9gbY8XXRSKCB6ei+WfGnQRp8SxRIUNwPLHepBQygLIrps3B8bFIJiWdtmvw78tf3yfbwstDgUcV5c5dLnmZ3+NcAVC1pBDZoI1OSQNbwAyc+uO6t6Uy/xwL3mQqwcRSeKJ81J1K9Zf2vk+ik8HGnOqSmTeJU63WTEkypJ215zzU5lfliOvKoEIf08thMBA2hdJCh+aKtyalR9i7vNtrByeEIlRhz3+WRRnSbPUB1VWzpGFGhdk3IfxqYNqxfpMd3hNdBWhw3zgidd4DJQZog2N0J69r0YCLuJoxDkFQAg55/1jPujbCl8lS0hJeciuxT3+Yn/30Uudcwxv2FLPArHnAN9ROrP3//c/bRly1AH4Em6Hn58nPD1IfpJ/QwUprAaEoq6aUh9VOXnU1W45Xx5zXQKq3P1Tt/wTrSyP0OiTPx08/z
 DqTIjm8E
 goIwoT8Xpo9EJa+1dcVJB4r//uFPYKzcue8ZBIEaWxzCt6faABkcC6KZCR/pm4kK8JAINUhGoQFCKALo1LI53Vu58OFUuTfhBUXdeyJkqXUKahfiTuwsMQZw4kndgGyaO83Z19Om3psWPsUJdx132whs7q4Xl3831aZWv7a7qwa9ZfLPrJnpuy9PmccIbIvuwGVfounHY9qemh7VXO6wUorcaFdZUPXYvov2pPZW9V44zy2XJAh8nPTz42sWzWms/I9KFnUlHI3+UkrR7N/WUu61SUzKIoJec6UKMS/eZa3c/HLkTEkfKSOmpwTZ+8PXJjwj+mxlMoV5fgJokylZS3fgGq/l8ih4kvkAWUlBkk+ZjaGouRKHwVwY/p1+Qo+H3E2lFgQdR686JY4mSX/zJmY1dLI8/LUSL1GLxiCZxw18jQ1hs8CiL3Sx1IlmTX/w8RyO8wOtzhGpZniY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 2:07=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Nhat,
>
> First of all, thank you very much for addressing the feedback
> regarding the swap metadata size concern and for stopping the
> punishment of zram usage. I'm unsure how to proceed with your earlier
> VS series (before swap table version V2), given the previous concerns.
>
> I was a bit nervous when you reverted the swap table and replaced it
> with something that performed worse in earlier series. I'm not
> attached to the swap table. The performance regression for existing
> use cases simply doesn't make sense to me. Thanks again that is no
> longer the case.

Eh, I'm open minded. I try lots of stuff - I tried the swap table
direction twice actually.

>
> On Thu, Aug 6, 2026 at 11:43=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > Changelog:
> > * v2 [v2] -> v3:
> >     * Rebased onto current mm-unstable.
> >     * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
> >       to gate vswap allocation.
> >     * More cleanups and small bug fixes.
> >     * Split THP swapin enablement into its own patch (patch 5).
> >     * Add production workload benchmark results, and drop RFC tag.
> > * v1 [v1] -> v2:
> >     * Rebased to a newer mm-unstable tip.
> >     * Fix a bunch of assorted issues (incorrect zswap store failure
> >       rollback, vswap_init() failure handling, rmap-encoding collision,
> >       etc.) and clean up the code (rename a bunch of functions to
> >       more closely follow existing patterns, etc.).
> >     * Some more code clean up and simplification: some renamings to mor=
e
> >       closely follow existing patterns, move vswap backing check to
> >       __swap_cache_add_check, store zero state in the swap_table for
> >       vswap entries, etc.. Many of these are proposed by Kairui Song
> >       in [1].
> >     * Defer memcg_table allocation on physical clusters until the first
> >       vswap-backing slot installs. Saves ~512 bytes per physical cluste=
r
> >       that only serves vswap-backing slots (this is the new patch 8).
> >     * Widen swap_info_struct->max and ->pages (and the swapoff unuse-pa=
th
> >       index) so vswap supports ~8 PB of swap space (this is the new
> >       patch 9).
> >     * Split the physical-swap-backend patch into three for reviewabilit=
y:
> >       the core backend (patch 3), zswap writeback to physical swap
> >       (patch 4), and reclaim of cache-only physical slots (patch 5). No
> >       functional change.
> >     * Add kerneldoc for the vswap API.
> >     * Add some benchmark numbers for zswap case.
> >
> >
> > I. Context and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > Currently, when an anon page is swapped out, a slot in a backing swap
> > device is allocated and stored in the page table entries that refer to
> > the original page. This slot is also used as the "key" to find the
> > swapped out content, as well as the index to swap data structures, such
> > as the swap cache, or the swap cgroup mapping. Tying a swap entry to it=
s
> > backing slot in this way is performant and efficient when swap is purel=
y
> > just disk space, and swapoff is rare.
> >
> > However, the advent of many swap optimizations has exposed major
> > drawbacks of this design. The first problem is that we occupy a physica=
l
> > slot in the swap space, even for pages that are NEVER expected to hit
> > the disk: pages compressed and stored in the zswap pool, zero-filled
> > pages, or pages rejected by both of these optimizations when zswap
> > writeback is disabled. This is arguably the central shortcoming of
> > zswap:
> > * Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
> >   we size swapfile in the order of 25-50% of host RAM, depending on fla=
sh
> >   availaiblity. This is a lot of flash for a fleet of our size, and
> >   with universal zswap enablement, most of this is wasted for zswap
> >   entries.
> >
> > * In deployments when no disk space can be afforded for swap (such as
> >   mobile and embedded devices), users cannot adopt zswap, and are force=
d
> >   to use zram. This is confusing for users, and creates extra burdens
> >   for developers, having to develop and maintain similar features for
> >   two separate swap backends (writeback, cgroup charging, THP support,
> >   etc.). For instance, see the discussion in [2].
> >
> > * Tying zswap (and more generally, other in-memory swap backends) to
> >   the current physical swapfile infrastructure makes zswap implicitly
> >   statically sized. This does not make sense, as unlike disk swap, in
> >   which we consume a limited resource (disk space or swapfile space) to
> >   save another resource (memory), zswap consumes the same resource it i=
s
> >   saving (memory). The more we zswap, the more memory we have available=
,
> >   not less. We are not rationing a limited resource when we limit
> >   the size of the zswap pool, but rather we are capping the resource
> >   (memory) saving potential of zswap. Under memory pressure, using
> >   more zswap is almost always better than the alternative (disk IOs, or
> >   even worse, OOMs), and dynamically sizing the zswap pool on demand
> >   allows the system to flexibly respond to these precarious scenarios.
> >
> > * Operationally, static provisioning the swapfile for zswap poses
> >   significant challenges, because the sysadmin has to prescribe how
> >   much swap is needed a priori, for each combination of
> >   (memory size x disk space x workload usage). It is even more
> >   complicated when we take into account the variance of memory
> >   compression, which changes the reclaim dynamics (and as a result,
> >   swap space size requirement). The problem is further exacerbated for
> >   users who rely on swap utilization (and exhaustion) as an OOM signal.
> >
> >   All of these factors make it very difficult to configure the swapfile
> >   for zswap: too small of a swapfile and we risk preventable OOMs and
> >   limit the memory saving potentials of zswap; too big of a swapfile
> >   and we waste disk space and memory due to swap metadata overhead.
> >   This dilemma becomes more drastic in high memory systems, which can
> >   have up to TBs worth of memory.
> >
> > Swap virtualization is the answer to these issues, with three propertie=
s:
> >
> > 1. Decoupled backends. For zswap in particular, this means we eliminate
> >    the unused storage space, and allows zswap to be used in systems tha=
t
> >    do not have enough storage capacity for physical swap (without havin=
g
> >    to resort to silly hacks). Zero-filled swap pages and swap-cache-onl=
y
> >    folios also benefit here.
> >
> > 2. Dynamic swap space. Since virtual swap is not tied to any physical
> >    resource, we can make it infinite and dynamically grow it on demand.
> >    This massively simplifies operational provisioning, and increases th=
e
> >    utilization of compressed swap backends (zswap). Dynamicity also
> >    reduces overhead on unused swap capacity.
> >
> > 3. Efficient backend transfer. The virtualization scheme should not
> >    introduce PTE/rmap walking overhead for backend transfer. This
> >    is crucial for systems that want to support multiple swap backends
> >    in a tiering fashion (for e.g zswap -> disk swap).
> >
> > For more historical contexts and references, please take a look at
> > the cover letter of the older vswap submissions ([3] and [v2]).
> >
> > II. Design
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > When we compile kernel with CONFIG_VSWAP, a special vswap device is
>
> Does the CONFIG_VSWAP only make sense for zswap right now? No other
> swap usage can benifit from CONFIG_VSWAP.

Good point, yeah.

Maybe have CONFIG_VSWAP depends on CONFIG_ZSWAP, until another use
case comes (I was thinking of discontig physical swapping, but this
damn patch series is long.)

>
> > allocated at boot time, and all swapped out pages try to allocate from
> > this device first, falling back to a physical swap device on failure.
>
> Does it create a new user visible behavior change where users don't
> need to swapon and can start using VSWAP for zswap?
> That is a user-visible behavior change and we need to be more cautious ab=
out it.

Userspace behavior change *is* the whole point here though. I want the
users to not having to specify a static capacity :)

Furthermore, the implication of not breaking existing users'
deployment is that if users want this new feature, they have to change
their existing config. It's just about where it makes the most sense
(a compile time config? boot time config? runtime config? some
combinations of these?)

However, I absolutely agree with you about being cautious with the
exact API. I'm still evaluating the best way to bring about this
(perhaps a boot time parameters is better than this runtime knob, but
let me prototype and test things).

>
> I think a system should not use zswap or any type of swap if no device
> is swapped on.

Why not? If we don't specify the size, and just want on/off knob (say
at boot time), seems like an overkill to use this interface. But maybe
I'm missing something.

>
> Have vm.vswap_enabled is no the answer to address the new API change
> because existing distro that use fstab to control swap will need to
> jump through hooks.
> Previously, using fstab to control was at least consistent for all swap t=
ypes.
>
> > Routing can also be turned off at runtime with the vm.vswap_enabled
> > sysctl, which defaults to 0 unless CONFIG_VSWAP_DEFAULT_ON=3Dy. It is
> > allocation-only: new swapouts go straight to physical swap, while
> > entries already backed by vswap keep being served and drain as they
> > are faulted back in or freed.
> >
> > These swap entries can subsequently acquire backend on-demand, such as
>
> What do "These" refer to? Are they entries already backed by vswap?

Yep. Vswap entries

>
> > a zswap entry, or a slot on a physical swap device.
> >
> > We repurpose much of the existing swap_table infrastructure and
> > swapfile allocator for this new vswap device, with two notable
> > differences:
> > * Clusters are dynamically allocated on demand and managed through
> >   an xarray. This in turn allows us to avoid static provisioning and
> >   let swap space grow dynamically.
> >
> > * Each cluster of this new vswap device has a virtual_table that stores
> >   the backend information of the entries in the cluster (see below).
> >
> > Diagrams:
> >
> >   Case 1: vswap entry (virtualized)
> >
> >   PTE                  swap_cluster_info_dynamic
> >   vswap_entry          +---------------------------------+
> >   (swp_entry_t) ------>| swap_cluster_info (ci)          |
> >                        | +----------------------------+  |
> >                        | | swap_table                 |  |
> >                        | |   PFN / Shadow             |  |
> >                        | | memcg_table                |  |
> >                        | | count,flags,order          |  |
> >                        | | lock, list                 |  |
> >                        | +----------------------------+  |
> >                        |                                 |
> >                        | virtual_table                   |
> >                        | +----------------------------+  |
> >                        | | NONE                       |  |
> >                        | | SWAPFILE(swp_entry_t)      |  |
> >                        | | ZSWAP(struct zswap_entry*) |  |
> >                        | +----------------------------+  |
> >                        +---------------------------------+
> >                               |
> >                               | SWAPFILE resolves to
> >                               v
> >                        PHYSICAL CLUSTER (swap_cluster_info)
> >                        +--------------------------+
> >                        | swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Pointer- vswap rmap    |
> >                        |   Bad    - unusable      |
> >                        |                          |
> >                        | Vswap-backing slot:      |
> >                        |   Pointer(C|swp_entry_t) |
> >                        |     rmap back to vswap   |
> >                        +--------------------------+
> >
> >   Case 2: direct-mapped physical entry (no vswap)
> >
> >   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
> >   phys_entry           +--------------------------+
> >   (swp_entry_t) ------>| swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Bad    - unusable      |
> >                        +--------------------------+
> >
> > struct swap_cluster_info_dynamic {
> >     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
> >     unsigned int index;                /* position in xarray */
> >     struct rcu_head rcu;               /* kfree_rcu deferred free */
> >     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> > };
>
> No a big fan of this two personality data structure thing depending on
> whether it is VS or not.
> If ci is the common part, I prefer to keep it separate and leave it alone=
.

I don't get what you meant. It is separate, and alone, no?

Originally Baoquan and I were thinking of shoving the virtual table
into "struct swap_cluster_info". I tried prototyping that one out, but
it looks uglier than I anticipated, so I dropped that approach.

>
> Also the extension is too vswap specific, it does not apply to other
> swap device types that might need their own private extension.
> You can take the VFS layer as an example. There is a VFS layer generic
> inode, which is common and shared by all file systems. And then you
> have filesystem-specific inodes as extensions, e.g. ext4_inode. The
> ext4_inode does not contain VFS inode. You don't see VFS having a code
> path like: if it is ext4, get the inode this way, else if f2fs, get
> the inode that way.


Hmmm, I'm not an FS expert. But struct ext4_inode_info does contain a
generic vfs inode field ("struct inode vfs_inode"), no? That is
actually more analogous than I would think: we have a vswap-specific
cluster struct (struct swap_cluster_info_dynamic) that wraps the
generic, shared metadata struct (struct swap_cluster_info).

I also never claim to re-implement vfs for swap. We take inspirations
where appropriate, but we're just writing our own thing at this point
:)

>
> In the first swap abstraction LPC talk, where I co-hosted with Yosry,
> I talked about the alternative approach: "VFS-like swap layers". That
> is exactly what I have in mind. We are getting very close to
> fulfilling that promise via swap ops and xswap extension interfaces.

I remember that talk. I don't remember how backend transfer would be
implemented in that proposal.

>
> I think implementing the generic interface first is simpler than
> implementing the non-generic vswap interface, ripping it out to
> replace it with a generic interface, and then putting back the generic
> modified version of vswap.
> If the two personality vswap xarray lookup gets in first, it will
> ultimately take more work to achieve the desired VFS-like extendable
> swap operations.
>
> I am happy to spend some time working with you to discuss the generic
> adopted version of vswap, if you are open to it. Or if you don't want
> to waste time on it. I can have someone else or myself come up with
> the generic adopted version of vswap for you to review, which I prefer
> less.

I would love to hear more about it, but so far I haven't quite
understood how it's going to achieve all of the requirements vswap is
trying to solve.

>
> Another piece of feedback is to please come up with a plan to submit
> your vswap changes piecemeal rather than as one long series. There is
> a lot of change like swap charging, that deserves a separate
> discussion before it gets merged. Look, the swap table changes took
> four phases. Each phase achieved a smaller milestone, with four of
> them ultimately reaching the finish line. I wish vswap had a similar
> piecemeal plan.

Lemme think about this a bit more. But in the meantime, could you at
least take a look at the general directions? For your use case (zswap
as the terminal swap level), I think the first two patches are the
most relevant, but the rest is crucial too for a generic use case.

