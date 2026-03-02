Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF933EB3636
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CFE6B00AC; Mon,  2 Mar 2026 16:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F14A6B00AF; Mon,  2 Mar 2026 16:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507436B00B0; Mon,  2 Mar 2026 16:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40C466B00AC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:31:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03B3D586E7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:31:46 +0000 (UTC)
X-FDA: 84502420254.01.5071A6F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1309140004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:31:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KbBqwX+n;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0JnYb95iDChj3/nA5mqzcjZo5gKvv6WEwEzSfKKmoo=;
	b=3ZouAthpVljXqStQigGBSsrwI7kR1Utk7GUiMnBMzt9IPw+1fEwJaFutJpBkIRA9D730xz
	od8liSYJz+Yg//QR4RGnuJuS8o9rRqVM3ohok0dXbGcWD9Oj07gkPje39dM9AtJQgNt10c
	a04sJY/esK3PRj4WVOdfu0oMkjmv3Zg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KbBqwX+n;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772487105; a=rsa-sha256;
	cv=pass;
	b=Dii4xsHp6MQG03Bp74wOgzbftHILZXXcj8vfLpCsbZjgOuhlkxDPJHK/b0dIIWjBBqGAXQ
	bl87LLEF0C1WeKF+y5ooPo7HL17Ix9aDgAqr9Irp8k8DibrLv3zXKI8SaMqsDMl7ApTu97
	Wy+dMkDX1oXQRZucghJKsR0suCxKYY0=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso1316866f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:31:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772487103; cv=none;
        d=google.com; s=arc-20240605;
        b=FcANuWkYpufj3hTw4oSFPouo/HdAZ6sBjwXaf3+qIfSPBYrDxgZ5cX82q9PmUh80cA
         58C6Jpibm15hX68PAQ7p1g87FX5rtfO6OXeAu9OYIElDKMdpJxkerSYFyYNb28e1m8xy
         zr0Ev2DT4cz80SklgWrP2zwCbwwaMl7cGeVriwzH9UmbE3op3O7O0dHtZKBhKu20fY81
         tPZLcD652xd2mho/UKxm967sztXZci0NjEXVR3OiG89pq4Zbl8mH604JtfmydzCAZ9LA
         J4O64k4xqumEO6qJXIy7P4a7iQ6HIvD96NRr74MVnSLSGOdlDHwZPuJNHEP1oMaDL0m0
         qQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T0JnYb95iDChj3/nA5mqzcjZo5gKvv6WEwEzSfKKmoo=;
        fh=0IVw7DATfKGhZGEJnW9VmPI6sml5Zv3V+8Dqt0XDkcs=;
        b=eBhNYxHuIbHxDy9NoxpK0gDg05N0xsveuGkg1qSOwDDCERFcG5ipYfS7Xv7s1d3F+c
         rD0h0fGtPGZkL8X1cWYaEeQ1Qgfd7nPtWicrjtCZ7hiLda3WnXgADwhcKAoys4QnANdo
         w70sO155X3hnh7DmElF4cSD9YWCVIfKd3l3pwjWAJl0o8rbAQbVUCJG6opnUxoIvHNix
         115i3jnsOduOu8SjAXxUCOgNTv30hICQWL4z51fPiPaqJBZRp1FVolnzlU/fQD/IJsPW
         yF+Rt4QTwSjTgiZ8LillrduxPlUdaVZMMxusUB20qeSdVFjwddEq27E8BFfBBo15pZiA
         n7gA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772487103; x=1773091903; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0JnYb95iDChj3/nA5mqzcjZo5gKvv6WEwEzSfKKmoo=;
        b=KbBqwX+nBW5hFjqfLt0Lu4RbKuAXwrS2+uqhZuBPFK7/9Nrj5cdYr5ZwrtxWe62QP4
         8Trpi7+mcXTi3RitvphBELdM9NERPH/8LI0GtF44iCS34NLaONPiL/wm89pM1o7uVJKF
         qMgRgTuDmgVZxatWvihCgwlhHjQPRgkjPfyg8uyNjWQF141BSpXdWYpx6MXDyYcEgN0H
         mwGeNmJ8xkpCPWw79DsMm4kn5u2nrRT9IA+d0M3p8u1K+f/uguSQUVfYK5wBEblGJpaF
         wHTT8Gk3Yc9pTJBZQp9yJmhcuDLPlUfDP+JM07TNCnpig5Nz8HnjyvzukGnBNeKV2DXz
         s1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772487103; x=1773091903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T0JnYb95iDChj3/nA5mqzcjZo5gKvv6WEwEzSfKKmoo=;
        b=W6OG9bcKuTdTidi6MFRpwiYw6H23OxTykUrRXRxnBbiBvieb9hCIXl9/53tUs1hInk
         2OFOnhnS+UwYKXexQP3BKe6kXUk9Apo1vakZrnJ4Sg7DuF2eZ1Modk3FKvDLcZrffMIY
         6Yw5ajeYQG5oetG0KBtHtSQkfec31kZ75DpcT0ulZWSxVKp5M/3RdfOobIjkcLiQhFHN
         eyZS18C88uBz4+pp0ZATiXtelY5Ij2lX3WO9SGy+Ngj5ckvbrATHfN5AxGxfdmEXPLdn
         oYynZDbgRe8k6BBMP088khjPqwiVPMuK5tanf+KfNykFAeT11Jf6kggQCZmhI1BynboE
         iSaw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ2cdrxyFGUfhnwj7rqfeGxRLbP/7crKLCMH16Vn3QAXLI6BhFCRgCIoTn3N/k6znFqLsIPBJVnA==@kvack.org
X-Gm-Message-State: AOJu0YxMen/OoCJWxsxDfs38XCgsplG7YWQ6I6Xc/2lGBkEgv+UDjwHu
	HwbQxq6Y/+s6CfWjJLX3yGBZCCbd8G8+Px+QC2ZBY5mdpE+huA4Bz3/M5gZhlHUTvkHeHxbi87I
	u0CTK8B1yxVfeRDdHHUB6KgJtMVpabIM=
X-Gm-Gg: ATEYQzxr2xCVhenRWR+G1V6TJzZt42879L4p0GOP8roTWnVZ8W6ot0nND/Y5pP8BVgd
	vnxX7YueuJ50K6TGtyKKhL7fGiKBAMQzG7j064aA6Y0DVitLtDLx/uTwB2QoavJb+VYOZ67/RiN
	XVFGqfJRYQUBmQem3zumNZG79a2LUOufXRTyhB1rx4hdYyJKEmAhnBrJEpuewlZ1bqXRT9faX9i
	heakvAkkmWKgJL/tPIAU32I4ZANowPP/pOD0tPArSqetXWGR9lFVPtccvDWKGnhTonGOazK0pGj
	SdlWC/ae0wM4RsksnzKa/ogKLVTxuflnpV7G1t8=
X-Received: by 2002:a5d:5849:0:b0:439:b636:1fa7 with SMTP id
 ffacd0b85a97d-439b636204amr12010712f8f.54.1772487103164; Mon, 02 Mar 2026
 13:31:43 -0800 (PST)
MIME-Version: 1.0
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Mar 2026 13:31:32 -0800
X-Gm-Features: AaiRm52AZxKxWz3NtbrxL6r9gkN1ice4-5rGfwkRSmDsEXhIUZmBNUwDASkb2Ic
Message-ID: <CAKEwX=N-yzg66Ge5YgDNG7nh3ues62fSjmi6oGq1B=gkz6e2Uw@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E1309140004
X-Rspamd-Server: rspam07
X-Stat-Signature: c47binc3wy4nfkm4dmgrsjn57pii3gy4
X-Rspam-User: 
X-HE-Tag: 1772487104-51735
X-HE-Meta: U2FsdGVkX18NKWfN3Ot8CEQJqx0H6wPSWKdvwAIGOZXiC3J/50ua97GiQGym2y7ugnR9YkcpxCYAV4weEp3iyU3gmNbpzLCqPnlIRWtWS7otB3GCSUPCI50L6eFfPQpvlbfFM1DX7+7OaZmeN+YWVF5SQSYBhW8BtBuDlx899iM01s38EOKR07Ho9IPpwKvrMV9uGgxZsRwo4IParxxgbeUj7q7hLOOhBcRIaBFrBL98B80N+Hj0Ue4pVTrSsQFv2f+12Sl0nVj5AyAaBxbZevh3gyzU7II1ufu/OS3TbZDDfev7S8xd/bQC4enYivJU5d0ik59mOxrbsVpneMj0B1A6iDR6Bs8DodcQP4NtEf4Vhj+LCGfeMUwZtIx/EdPAsh1KylGZIkPkQjHXWtP95Mo16KcsgAplu9NZqn6/4urhEB5mnFDQAf/0BrAjIyEuYgrT0zZDM6FIsGk46ZOldIthqDEvdiA6fKvmJmM3wam3vYzjuPYSW6s464u/8/M04L4gpL0HtLivtxmbS8os51qtbVDJZs+C57AIiMUKXnw8iUVba84rElx1o9/MPD1+oz0YJJgdJoy3ftgD3NiidcKMzsdafuq6Np3MdEcKMpjKtjWtN0+J0ZBYPVKltK35qFgNhFHYnvDZfpRR9tm3MS/NPd/q6XtzF81tzwd6Yl+h1zisPuv8miYpFf+sGGFGe7Otl9Pl5KB5WxlkfEXfEaLAeidcehr3FH2NoV8eVy+C1JZVZDNLVVLNbChPwezoo+gL05jMzf/DSEOVx0EvygDu3clV9WGzQM2zgX8zkT1N5wntLS9lJLiugBMb9vwjFKpCcokfpHphLdon8Cf5Bekn/RtnX2QH614VLZ0hUuLj4RnsfttiY6S0LEPe0huv9O7ZsRzcOZDMCUc8t6iyXFuM3MIbn7+/WAKunJMJSogpl4Xv4KKWSgJCjWZIh5P7Y5/KfYXWyX5f8gBoZ5I
 XOubowpx
 xk86i5QdDrz671xMLeIueCAXNufBlWS1MoRkMOKYSegJdDvPFNSL0BytYNbLlV7oKyVqzKAMPfl6aazqYyQMnwgAOw0VpKPtyvTFQQIlGExEiHGN54XcsfPvAsCXiw/7srDk2+BlaM9B+ue1SW8jlH4EtblkG4GYH1yfVKsdn0U4fujDloSjnC3wZkS8AerDZ0Fn4II7459clq6qZTkn31pLS14m72pLFXoTJ2yzOhZc3V58tPFqekjdckeyhfNjMsZV8s8xVPfL9OVJsQgcQ1hb0h1yBIWUiPkbH4X0CELF2cIMwCXLcmTY/XLJvzK8wYczOJNnmKzbdM3l8su1Q93wrM8OToaD1vWhBZq5PQGauGtF7x0z+71GQY4rjX0Wz23WwE39Q4ZJunfUVCNPTu99TwkC1piJKlUwaCn4rkbUEwuaVbBxRKIHS132o3BtgwX1kIXNkHmepoFrhOV0sgcIWab5YtLQGTMbpG3y/C0uOEz+cm7Lk/opCbm/MMgvh96bP2dAXMcMyiml4qycENN61jsO0ld1sKw+an2ZQSg2JPpLYTBdR7MER+WY2oQrdF5mHvS5YkCIi+/qKjFrSoldZbV8Pl9IQDRE2qhcl2GONAKDcA2Hti1xbfXQYDtvolL8GdOAyxjEqRS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 11:29=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> INTRODUCTION
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The current design for zswap and zsmalloc leaves a clean divide between
> layers of the memory stack. At the higher level, we have zswap, which
> interacts directly with memory consumers, compression algorithms, and
> handles memory usage accounting via memcg limits. At the lower level,
> we have zsmalloc, which handles the page allocation and migration of
> physical pages.
>
> While this logical separation simplifies the codebase, it leaves
> problems for accounting that requires both memory cgroup awareness and
> physical memory location. To name a few:
>
>  - On tiered systems, it is impossible to understand how much toptier
>    memory a cgroup is using, since zswap has no understanding of where
>    the compressed memory is physically stored.
>    + With SeongJae Park's work to store incompressible pages as-is in
>      zswap [1], the size of compressed memory can become non-trivial,
>      and easily consume a meaningful portion of memory.
>
>  - cgroups that restrict memory nodes have no control over which nodes
>    their zswapped objects live on. This can lead to unexpectedly high
>    fault times for workloads, who must eat the remote access latency
>    cost of retrieving the compressed object from a remote node.
>    + Nhat Pham addressed this issue via a best-effort attempt to place
>      compressed objects in the same page as the original page, but this
>      cannot guarantee complete isolation [2].
>
>  - On the flip side, zsmalloc's ignorance of cgroup also makes its
>    shrinker memcg-unaware, which can lead to ineffective reclaim when
>    pressure is localized to a single cgroup.
>
> Until recently, zpool acted as another layer of indirection between
> zswap and zsmalloc, which made bridging memcg and physical location
> difficult. Now that zsmalloc is the only allocator backend for zswap and
> zram [3], it is possible to move memory-cgroup accounting to the
> zsmalloc layer.
>
> Introduce a new per-zpdesc array of objcg pointers to track
> per-memcg-lruvec memory usage by zswap, while leaving zram users
> unaffected.
>
> This creates one source of truth for NR_ZSWAP, and more accurate
> accounting for NR_ZSWAPPED.
>
> This brings sizeof(struct zpdesc) from 56 bytes to 64 bytes, but this
> increase in size is unseen by the rest of the system because zpdesc
> overlays struct page. Implementation details and care taken to handle
> the page->memcg_data field can be found in patch 3.
>
> In addition, move the accounting of memcg charges to the zsmalloc layer,
> whose only user is zswap at the moment.
>
> PATCH OUTLINE
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Patches 1 and 2 are small cleanups that make the codebase consistent and
> easier to digest.
>
> Patches 3, 4, and 5 allocate and populate the new zpdesc->objcgs field
> with compressed objects' obj_cgroups. zswap_entry->objcgs is removed,
> and redirected to look at the zspage for memcg information.
>
> Patch 6 moves the charging and lifetime management of obj_cgroups to
> the zsmalloc layer, which leaves zswap only as a plumbing layer to hand
> cgroup information to zsmalloc.
>
> Patches 7 and 8 introduce node counters and memcg-lruvec counters for
> zswap. Special care is taken for compressed objects that span multiple
> nodes.
>
> [1] https://lore.kernel.org/linux-mm/20250822190817.49287-1-sj@kernel.org=
/
> [2] https://lore.kernel.org/linux-mm/20250402204416.3435994-1-nphamcs@gma=
il.com/#t3
> [3] https://lore.kernel.org/linux-mm/20250829162212.208258-1-hannes@cmpxc=
hg.org/
> [4] https://lore.kernel.org/linux-mm/c8bc2dce-d4ec-c16e-8df4-2624c48cfc06=
@google.com/
>
> Joshua Hahn (8):
>   mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
>   mm/zsmalloc: Make all obj_idx unsigned ints
>   mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
>   mm/zsmalloc: Store obj_cgroup pointer in zpdesc
>   mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
>   mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
>   mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
>   mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
>
>  drivers/block/zram/zram_drv.c |  17 +-
>  include/linux/memcontrol.h    |  15 +-
>  include/linux/mmzone.h        |   2 +
>  include/linux/zsmalloc.h      |   6 +-
>  mm/memcontrol.c               |  68 ++------
>  mm/vmstat.c                   |   2 +
>  mm/zpdesc.h                   |  25 ++-
>  mm/zsmalloc.c                 | 282 ++++++++++++++++++++++++++++++++--
>  mm/zswap.c                    |  67 ++++----
>  9 files changed, 345 insertions(+), 139 deletions(-)

I might have missed it and this might be in one of the latter patches,
but could also add some quick and dirty benchmark for zswap to ensure
there's no or minimal performance implications? IIUC there is a small
amount of extra overhead in certain steps, because we have to go
through zsmalloc to query objcg. Usemem or kernel build should suffice
IMHO.

To be clear, I don't anticipate any observable performance change, but
it's a good sanity check :) Besides, can't be too careful with stress
testing stuff :P

