Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6D9C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68EE56B0256; Thu, 13 Aug 2026 05:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666036B0258; Thu, 13 Aug 2026 05:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57EFA6B025A; Thu, 13 Aug 2026 05:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAF96B0256
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:27:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DF8EA2992
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:27:32 +0000 (UTC)
X-FDA: 85095718344.01.0275298
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F40801A000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:27:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKKP0aaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0WfG9LtUU7qIATkbY9c7VbNU4tFX7Iam6iBGsEbqBM=;
	b=M4B6djPJvVOlkSgF3+y4NFubD8SfDYMvmMHY2SUsi9sy6uAwiNfkKj9j3Ikg+MfDNW581y
	7NBZ8LhssVrrGIQSEh6k+9er72hmPrey0ohxJqUpHBtxPbynaLMMFGg5Nf68voe7qpGNnG
	PoEdtID9NXMXyOJZ3qPpxRBzTpRGVUk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKKP0aaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613251;
	b=T9tgCWr0B/epsBdcxd5eAynBtdUHHBn2OkREv2mzhI2y/a6734ZdLC6fAMuEcd9kykphAr
	7SHjgaSsqjBdKc/+wAfySuzIWWnNvvlJ8wyEMyfyegMMzcuYVQ+ietW/Rm4XOcHn3wgj92
	nr3MjxZemN91jIeab/l+xY9LtoKQhmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34B194126C;
	Thu, 13 Aug 2026 09:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3771F00A3A;
	Thu, 13 Aug 2026 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613250;
	bh=J0WfG9LtUU7qIATkbY9c7VbNU4tFX7Iam6iBGsEbqBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fKKP0aaflcesVE16gmCdIUQZXRadXKPNnorPID/XlTMeQNeLHsIR28CRvP+c6tv0J
	 GiCgXFFIpH2jQffDALJEoRKtEpNvFEK/wsgTFqXso/t6JYdOaw2xjsePWdkwspBvrk
	 LAcdnbsVjFw2Rq9h4BiQ69Sk4X/EaJA7hQhJhbvTOuMR9DA8JqwLBB99tjjrjz34o6
	 D8XYz0iZ4U515IRFaGmbyVSZ6WyRGrmMhaMfYv25FKZTceSb2wGwabvOSN6HmubtGj
	 ND6iPTXtl32xcMeLHue7tZns05qcKFHWgznrw+8cFKUft+K5WGYP2xuRtxkRyswykU
	 0DapLWAEcv6qQ==
Date: Thu, 13 Aug 2026 10:27:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <an2HYmJ57BCY_Zwt@lucifer>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
X-Stat-Signature: h4erzbz9u6fnc1zied1ik47wbd91qfog
X-Rspamd-Queue-Id: F40801A000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786613250-892680
X-HE-Meta: U2FsdGVkX1/j/rVzmqgt+YeH/hd7f0UHBnkfGf7FghHDDkGL+8fPMc3B3HbWqWR+eK+MmE1QQZYODL7fRGVwxLj1s2lll5DAIyQ79Ino6Ysr/CTNPyc/aG7EhxNsBsOLnA6OUs/CY//K0au5+uFy1JaXY9mVyI02/GIWD73fA+gsrTyGojqOKM6UBZy2wp/yGYIIkGG51DhC4E3uwezVyfU+IyCZne0CEtvy9/Fsr53Gl73w4NJ/+XBvhULBuVIXSvXh3zrWmBJDrFJC7DDIVGZhZSlt+AuFm01f9crchv+mAo1dad33INBCXNFN3mQgCr/io8ROoKLHass4MkbQFNGZ2Hi2YD8ZHjFzaMnLsNJcV9xxk4LLOvdbp5spyM73Yxa9jrbWtW1Gau9wKSHjtBSI9tyH/AqCIEc4hVtecQcXLOfkHobNtTcgMRsmIZexoZ3eOzs6Y99w2z06mVeaB5RK1ofisa+fIsgJrLh8w7jOC798DPz0DS4App87d5dZ2FJ7jR6NSLZNgKX5G2yq3++c5Gk4BjiiAw1EIjv+XB56LOXUjMbSdXEx5or1/vGv+shDceiKYeKGfTJu0PcDau/s5m9804jEI01kPxPUW5xfVrFPzWb8FSO3d9zcOxo4qLxNU1bcFxRK9+ZQJOOzShcWKIPDiHGmLWUAbwvWKGe2oqr++07DpKXLLCMallt6eWMFdxotPnn5NjhN1XOkSpPN8vl0uCqju1MjDgYXz8Cleq4GaR2Xa6qzxe0qDg9sjebRDSgw7wEQsuc8evHvCS2xaTcFo9iwbM/2LXVVCXa0gFdDoFcPX3uqc0ksj3aPk7Qhp6WRVG2HlIfYWK6aB50I3qkVTwpfTM6gLFjo7/nZ0e2xoSlhklG4nq9uFXRZghrWBdcy/QtPqtnF0AkVq7/3IhJsStsIUiyWsaobDzAGHzOB+NRr6ouX0RRU12G4qvTHiMmCXV0s2gWGqRT
 LvYwZqwj
 03KZx7H54m4iNL4PNENKIlSGIgJUcUkcEZXKYP2uOQOrivC8e/em5+Bz8MaI8RiRVERhQptoyUpx5n57mvngJ5WQz26swENsZ2DZeyn8fmBvKwG2zl0LgwhsPWunNZE/D7hTBIrFtfKzcQoXWP79SBhCpQxfrR8YYRycQ8k0qj1FEmDe0jOBavuTVop9/DdhnCjcY/Aw+Jv76f206RHFfEoyIBDbkyBFTDU4Gu0PX9ohJvb5LP7JGyDkuLKaHLpjoHrVtZRf2Af+5OzubhFhGfEAh3dmWL8Xj2xzs9OVxlHfwe+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> target memcg set, and thus the only way kswapd can reach
> lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> reclaim. Do not reuse for anything else." comment and a priority hack,
> and it simply never got taught about MGLRU.
>
> Rather than teach it, let's delete it. The v1 soft limit was deprecated
> in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> soft limit"). Nobody has reported depending on it in the ~21 months
> since, and v2 has covered the same ground for a long time with
> memory.low and memory.min.
>
> Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
>
> Shakeel Butt (9):
>   memcg: make the v1 soft limit knob inert
>   memcg: remove v1 soft limit reclaim
>   memcg: remove mem_cgroup_shrink_node()
>   memcg: remove the soft limit reclaim tracepoints
>   memcg: remove the soft limit rbtree
>   memcg: remove lru_gen_soft_reclaim()
>   memcg: remove the per-node soft limit tree fields
>   memcg: remove mem_cgroup->soft_limit
>   memcg: simplify v1 event ratelimiting
>
>  .../admin-guide/cgroup-v1/memory.rst          |  49 +-
>  include/linux/memcontrol.h                    |  27 --
>  include/linux/mmzone.h                        |  30 +-
>  include/trace/events/vmscan.h                 |  14 -
>  mm/internal.h                                 |   4 -
>  mm/memcontrol-v1.c                            | 435 ++----------------
>  mm/memcontrol-v1.h                            |  12 +-
>  mm/memcontrol.c                               |   7 +-
>  mm/vmscan.c                                   |  96 +---
>  9 files changed, 66 insertions(+), 608 deletions(-)

This is a gorgeous diffstat :)

Obviously not my area but looking over it, all LGTM so feel free to add:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

To the whole series!

>
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

