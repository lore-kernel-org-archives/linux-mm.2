Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76240CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 13:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9138E0016; Wed, 12 Nov 2025 08:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8D38E0003; Wed, 12 Nov 2025 08:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B705E8E0016; Wed, 12 Nov 2025 08:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1058E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:34:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47E534CC7D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:22 +0000 (UTC)
X-FDA: 84102049164.23.43D7FAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DA701C000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T1mKYxic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762954460; a=rsa-sha256;
	cv=none;
	b=qdzch3FrS5ri6mFqT4fwFf1xr3L1fLJ6iEdmtkbSWU0RjTCBmor6VB38ywNtn3bc4RT3/Z
	fAhU1wU/xaqTDtiIIE5Jea1XfFi14ELDaeG3PrXUz1jLmGR434nC3COrCcxaolNEVIaK37
	+EwAQW9QRNXM6pcr35HBTvat+IaaYEY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T1mKYxic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762954460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8pojkf2oSf397gRv/dMr6UBgsvVtpSWpI12ijCCsZk=;
	b=B7Xzjsi8ZxKC3IfjMSpNi+YWZsCRtlhZBoWxTXf9YDnoZaMPAhD8EFvSRS/4E56KOOo5rz
	4Z+nrr6yoeaB/iv23B9N8ClTfKyUw/qEysX3RIRRHZA1cQfSyFzR03OaDTOatXqSCq4x8T
	sq55T587jH46JJJx6NC7CHAa48IVKV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA6B341B66
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E5C116B1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762954458;
	bh=Iswk76xrOcOZ+ghm9k0OtsD4f3QfWzKcacySZovmqZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=T1mKYxicQ+6tpOfRaAIAPqujTeqhQJD18UzbUO1iZFxuu0CWr10BxHaCRBRykXWtt
	 dczZmh16bxdPvcVVcMF6ZCInAatDsMKC9GgVd6eJD8yCOyS8OXO+/s6PWNuKLsw0Fb
	 tixmu+5yaGtHM2aTCtf6X8tuVa/POFYnSUs3oF7dPVqE43Z9YGuVXUr8nqXhS9W5xl
	 xom2POa9uH16lbin+g8shvJZdKxnntyPZ3Dq6Ti/F7YwndnZhroDyzDImbc7jy/qPN
	 7i7kqojbXwdfuQknAviBfiDwlDAr8DfBqd+uJF8qtvtRqybIfALzpU2eXOyq3KopKS
	 MMCKCJju+OEkA==
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b38de7940so461100f8f.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:34:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWZBXcWuhgZA/fQ0ptHyhc/cYZo+BsJ1n+rwMYeHwcvjMPjyUb242WaG907n/EU6J+kTtP5uvmsRA==@kvack.org
X-Gm-Message-State: AOJu0YzZXK+1Zuo7vBBcQ2H+VD69M26nJO8R9oaOXixqdngj/i89Tyk6
	ZerO5Nc/RrBkCanTFWSbnwbDSQ2E9Z/1F84UCwnQxMXOHBA242KMno5RlP4kiiglrGc2pCnquCn
	jv9USTdjNujPr8OHzgwUrypWoJ8gbOjZQVsR2Hd8gLg==
X-Google-Smtp-Source: AGHT+IF9bcWOvDByXeJcPGdpBQ62WykCFYRS8f6AjV3YIWckQFEoXL97S1nJnKOvcUbeL/OiU294pxGnu8ThdwoRQ1E=
X-Received: by 2002:a05:6000:4210:b0:427:8c85:a4ac with SMTP id
 ffacd0b85a97d-42b4bdb4cfcmr2474633f8f.47.1762954457534; Wed, 12 Nov 2025
 05:34:17 -0800 (PST)
MIME-Version: 1.0
References: <20251109124947.1101520-1-youngjun.park@lge.com>
In-Reply-To: <20251109124947.1101520-1-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 12 Nov 2025 05:34:05 -0800
X-Gmail-Original-Message-ID: <CACePvbV80ZtC2FL6Z-Y4Rg=5bzdi1O8zqQSMEGuxqhj5P0txsA@mail.gmail.com>
X-Gm-Features: AWmQ_bkQL-nIO8ItDYbzVpVznojBy7HPNB9u7fXNkmn_UNYWv8e_ajah8xnS1QY
Message-ID: <CACePvbV80ZtC2FL6Z-Y4Rg=5bzdi1O8zqQSMEGuxqhj5P0txsA@mail.gmail.com>
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3DA701C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: k6n5b84xsrcafzybfshsn8i859tpdk5i
X-Rspam-User: 
X-HE-Tag: 1762954460-420053
X-HE-Meta: U2FsdGVkX18+5M4xf0Ldgjyp4nlDHBqFEK+Nvp6zhGQV0903osJO3HTHiXS8zMa2u/mMeJIZJMPEtqFtZ4VEzTONIPRUcEmJj/he82rs6u2rPvIFP5rk9dCBxLUhdHAR+ah8zzp/WaZKcslz2h+qlplyH7SliCP0FwWTgvyZMj7GV8aC7ZQ4+cv/L5r6PRy0+EBNRSBlXyGjen3qsjhMQJRAkY1sWm91/TIkD58WU1G80a4dOjF8gODyFONeoGHa5k2R357mK6uly53Xai+KxYPHYRHNsQ5L4q5srYm/hLsAf/Bn/usxpj7dfHhOJk6n6Sv3XM2OHFv8dv28KRbENKln0PQNN5Rsw4rJyWShsi5lNTys429qbJccKVNv4LIVVrVl08a2HYIB6IiDvDqDJepqk5nZ+5u+NHqf7Bp+F8EB/kfWxNS65Ds/rWNK9kN2IJeKUYyBcUNWnzaG70erS0Ng+3WGf9di4K0QPxySBIxtTCQHoQVhH3w+67rweUMkwpVrroxRmjVwoJA82+dZHnTaqaZA66eTdcmPzMPK7mLt/T6IlBCVljVQKjsd6KuikEN9gIYpHm3eooV0iGZqvg9WvA7gFtBvYhQyUuLkcYHMg/IEwEBAP7AWdsGHyIEHNABsqObAAC1J08Bp5CMUvsxvJ3p5ap9nZCsnEiEEDO+BRVTjv3/w/yqbIyC26hIl/KDam1RPdtX6loVGTfMyNntMHXvAFhx7tpSrP6P44Urusp/9zuQBg4fRGYkp9SaSFr2OJZ6SD8H34fIU8y/IahJAUrL+gYY+tp1TbD31CG7oVoyC877eQPCJPfMXNdW0YtDqVfNuVdmt7NNoGKm7mVYMNPawWOhmCHZ9DWpJGu7CjH/0PNxoVAMieSWAHrzVDFEEQ3PY5CJkUQPgLr6mTRnTHDokxPDjrOsxN18glkU+TWKtDTMzz+iiPZ9tWOsLoN+N+p3eKgVrCggPGwS
 MiD3EYEs
 Hb/5piCztyYpDAZIGAu/g3+RFTciGR21I7Jvpa6a3QK6yuQcG+Oa/Bj/0Xu+qi13ObysWoRvZdtCeunDyehd3CywVjBVF6xDTWXgO/8kP603v2jEqWrhT9ofpVIvl8SvD3yoLTYziTIvvtqtdQh8VZIkrgexLd1OdYQWfm/DZcYpqXwqR1bIecECwSUq2uWU0SYvj+sc7sqPUtOfvLfLrXhgoqKYChHYQAX1hz1aA8AJIsFQD5UgAL5AxS8k9AIjFiRFfJx2UP6kF7nJvea6hkeZGoRlTgq/KOlmIJ+DED7ZcXWwody+oH74fPXS5Y1NGQfJE/iw0mp34U63GCiFlS1sJySDSFkiEeMh63TmOc70aRA4ZVQG8pcPb2mXJ+MBKTzFK51RjHz0VbNNUvx33k98zairgYnhdy4YWB2ulrv3ts4kD6aBHsqx41PaRaC6blk5TR/sEMQvxtpnhGwNXopqacw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

Sorry for the late reply, I have been super busy in the last two weeks
and I am still catching up on my backlogs.

Thanks for the patches. I notice that your cover letter does not have
[0/3] on it. One tool I found useful is using the b4 to send out
patches in series. Just for your consideration, it is not an ask. I
can review patches not sent out from b4 just fine.

On Sun, Nov 9, 2025 at 4:50=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> Hi all,
>
> In constrained environments, there is a need to improve workload
> performance by controlling swap device usage on a per-process or
> per-cgroup basis. For example, one might want to direct critical
> processes to faster swap devices (like SSDs) while relegating
> less critical ones to slower devices (like HDDs or Network Swap).
>
> Initial approach was to introduce a per-cgroup swap priority
> mechanism [1]. However, through review and discussion, several
> drawbacks were identified:
>
> a. There is a lack of concrete use cases for assigning a fine-grained,
>    unique swap priority to each cgroup.
> b. The implementation complexity was high relative to the desired
>    level of control.
> c. Differing swap priorities between cgroups could lead to LRU
>    inversion problems.
>
> To address these concerns, I propose the "swap tiers" concept,
> originally suggested by Chris Li [2] and further developed through
> collaborative discussions. I would like to thank Chris Li and
> He Baoquan for their invaluable contributions in refining this
> approach, and Kairui Song, Nhat Pham, and Michal Koutn=C3=BD for their
> insightful reviews of earlier RFC versions.
>
> Concept
> -------
> A swap tier is a grouping mechanism that assigns a "named id" to a
> range of swap priorities. For example, all swap devices with a
> priority of 100 or higher could be grouped into a tier named "SSD",
> and all others into a tier named "HDD".
>
> Cgroups can then select which named tiers they are permitted to use for
> swapping via a new cgroup interface. This effectively restricts a
> cgroup's swap activity to a specific subset of the available swap
> devices.
>
> Proposed Interface
> ------------------
> 1. Global Tier Definition: /sys/kernel/mm/swap/tiers
>
> This file is used to define the global swap tiers and their associated
> minimum priority levels.
>
> - To add tiers:
>   Format: + 'tier_name':'prio'[,|' ']'tier_name 2':'prio']...
>   Example:
>   # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers

I think a lot of this documentation nature of the cover letter should
move into a kernel document commit. Maybe
Documentation/mm/swap_tiers.rst

Another suggestion is use "+SSD:100,+HDD:2,-SD" that kind of flavor
similar to "cgroup.subtree_control" interface, which allows adding or
removing cgroups. That way you can add and remove in one line action.

>
>   There are several rules for defining tiers:
>   - Priority ranges for tiers must not overlap.

We can add that we suggest allocating a higher priority range for
faster swap devices. That way more swap page faults will likely be
served by faster swap devices.

>   - The combination of all defined tiers must cover the entire valid
>     priority range (DEF_SWAP_PRIO to SHRT_MAX) to ensure every swap devic=
e
>     can be assigned to a tier.
>   - A tier's prio value is its inclusive lower bound,
>     covering priorities up to the next tier's prio.
>     The highest tier extends to SHRT_MAX, and the lowest tier extends to =
DEF_SWAP_PRIO.
>   - If the specified tiers do not cover the entire priority range,
>     the priority of the tier with the lowest specified priority value
>     is set to SHRT_MIN
>   - The total number of tiers is limited.
>
> - To remove tiers:
>   Format: - 'tier_name'[,|' ']'tier_name2']...
>   Example:
>   # echo "- SSD,HDD" > /sys/kernel/mm/swap/tiers

See above, make the '-SSD, -HDD' similar to the "cgroup.subtree_control"
>
>   Note: A tier cannot be removed if it is currently in use by any
>   cgroup or if any active swap device is assigned to it. This acts as
>   a reference count to prevent disruption.
>
> - To show current tiers:
>   Reading the file displays the currently configured tiers, their
>   internal index, and the priority range they cover.
>   Example:
>   # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers
>   # cat /sys/kernel/mm/swap/tiers
>   Name      Idx   PrioStart   PrioEnd
>             0
>   SSD       1    100         32767
>   HDD       2     -1         99
>
>   - `Name`: The name of the tier. The unnamed entry is a default tier.
>   - `Idx`: The internal index assigned to the tier.
>   - `PrioStart`: The starting priority of the range covered by this tier.
>   - `PrioEnd`: The ending priority of the range covered by this tier.
>
> Two special tiers are predefined:
> - "": Represents the default inheritance behavior in cgroups.
This belongs to the memory.swap.tiers section.
"" is not a real tier's name. It is just a wide cast to refer to all tiers.

> - "zswap": Reserved for zswap integration.

One thing I realize is that, we might need to have per swap tier have
a matching zswap tier. Otherwise when we refer to zswap, there is no
way for the cgroup to select which backing swapfile does this zswap
use for allocating the swap entry.

We can avoid this complexity by providing a dedicated ghost swapfile,
which only zswap can use to allocate swap entries.

> 2. Cgroup Tier Selection: memory.swap.tiers
>
> This file controls which swap tiers are enabled for a given cgroup.
>
> - Reading the file:
>   The first line shows the operation that was written to the file.
>   The second line shows the final, effective set of tiers after
>   merging with the parent cgroup's configuration.
>
> - Writing to the file:
>   Format: [+/-] [+|-][TIER_NAME]...
>   - `+TIER_NAME`: Explicitly enables this tier for the cgroup.
>   - `-TIER_NAME`: Explicitly disables this tier for the cgroup.
>   - If a tier is not specified, its setting is inherited from the
>     parent cgroup.
>   - A standalone `+` at the beginning resets the configuration: it
>     ignores the parent's settings, enables all globally defined tiers,
>     and then applies the subsequent operations in the command.
>   - A standalone `-` at the beginning also resets: it ignores the
>     parent's settings, disables all tiers, and then applies subsequent
>     operations.
>   - The root cgroup defaults to an implicit `+`, enabling all swap
>     devices.
>
>   Example:
>   # echo "+ -SSD -HDD" > /sys/fs/cgroup/my_cgroup/memory.swap.tiers
>   This command first resets the cgroup's configuration to enable all
>   tiers (due to the leading `+`), and then explicitly disables the
>   "SSD" and "HDD" tiers.
>
> Further Discussion and Open Questions
> -------------------------------------
> I seek feedback on this concept and have identified several key
> points that require further discussion (though this is not an
> exhaustive list). This topic will also be presented at the upcoming
> Linux Plumbers Conference 2025 [3], and I would appreciate any
> feedback here on the list beforehand, or in person at the conference.

All very good questions. Thanks for preparing that.

>
> 1.  The swap fast path utilizes a percpu cluster cache for efficiency.
>     In swap tiers, this has been changed to a per-device per-cpu
>     cluster cache. (See the first patch in this series.)
>     An alternative approach would be to cache only the swap_info_struct
>     (si) per-tier per-cpu, avoiding cluster caching entirely while still
>     maintaining fast device acquisition without `swap_avail_lock`.
>     Should we pursue this alternative, or is the current per-device
>     per-cpu cluster caching approach preferable?
>
> 2.  Consistency with cgroup parent-child semantics: Unlike general
>     resource distribution, tier selection may bypass parent
>     constraints (e.g., a child can enable a tier disabled by its
>     parent). Is this behavior acceptable?
>
> 3.  Per-cgroup swap tier limit: Is a `swap.tier.max` needed in
>     addition to the existing `swap.max`?

I really hope not.

>
> 4.  Parent-child tier mismatch: If a zombie memcg (child) uses a tier
>     that is not available to its new parent, how should this be
>     handled during recharging or reparenting? (This question is raised
>     in the context of ongoing work to improve memcg reparenting and
>     handle zombie memcgs [4, 5].)

I really want to avoid doing the reparenting.

Chris


>
> 5.  Tier mask calculation: What are the trade-offs between calculating
>     the effective tier mask at runtime vs. pre-calculating it when the
>     interface is written to?
>
> 6.  If a swap tier configuration is applied to a memcg, should we
>     migrate existing swap-out pages that are on devices not belonging
>     to any of the cgroup's allowed tiers?
>
> 7.  swap tier could be good abstraction layer. Discuss on extended usage =
of swap tiers.
>
> Any feedback on the overall concept, interface, and these specific
> points would be greatly appreciated.
>
> Best Regards,
> Youngjun Park
>
> References
> ----------
> [1] https://lore.kernel.org/linux-mm/aEvLjEInMQC7hEyh@yjaykim-PowerEdge-T=
330/T/#mbbb6a5e9e30843097e1f5f65fb98f31d582b973d
> [2] https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.pa=
rk@lge.com/
> [3] https://lpc.events/event/19/abstracts/2296/
> [4] https://lore.kernel.org/linux-mm/20230720070825.992023-1-yosryahmed@g=
oogle.com/
> [5] https://blogs.oracle.com/linux/post/zombie-memcg-issues
>
> Youngjun Park (3):
>   mm, swap: change back to use each swap device's percpu cluster
>   mm: swap: introduce swap tier infrastructure
>   mm/swap: integrate swap tier infrastructure into swap subsystem
>
>  Documentation/admin-guide/cgroup-v2.rst |  32 ++
>  MAINTAINERS                             |   2 +
>  include/linux/memcontrol.h              |   4 +
>  include/linux/swap.h                    |  16 +-
>  mm/Kconfig                              |  13 +
>  mm/Makefile                             |   1 +
>  mm/memcontrol.c                         |  69 +++
>  mm/page_io.c                            |  21 +-
>  mm/swap.h                               |   4 +
>  mm/swap_state.c                         |  93 ++++
>  mm/swap_tier.c                          | 602 ++++++++++++++++++++++++
>  mm/swap_tier.h                          |  75 +++
>  mm/swapfile.c                           | 169 +++----
>  13 files changed, 987 insertions(+), 114 deletions(-)
>  create mode 100644 mm/swap_tier.c
>  create mode 100644 mm/swap_tier.h
>
> base-commit: 02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> --
> 2.34.1
>
>

