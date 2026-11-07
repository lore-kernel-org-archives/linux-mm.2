Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A977F606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPUqaHF/
Received: by kanga.kvack.org (Postfix)
	id B68FA6B05B2; Sat,  7 Nov 2026 12:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19F36B05B3; Sat,  7 Nov 2026 12:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FC56B05B4; Sat,  7 Nov 2026 12:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5056B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:26:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F221A1403C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:26:39 +0000 (UTC)
X-FDA: 85409002518.21.9B87FC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56E8F40006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:26:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QPUqaHF/";
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794072398;
	b=tztgDVbSrcAqyW1GpZYq4EmYczccJ9+Fv5MP8X7zoTZDvZhBDbd6IgieJHCnNQ+ku6Qx2j
	yCHh+5c+t+vnRNAYFGhLbXR+KtU93c2lIhyjI2xajcZH947m+GY/dDtyc4Pb7Pgn2Qhrq5
	WJumFYnr3yd163d4FJXZfkaa/hr5610=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QPUqaHF/";
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794072398;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ry+MkwlQ/4sA2zfKwfD6o/IbNoH2lui5rOOvBIVk4/s=;
	b=NtVd6vBE+V++6wtXknvBOTHAlBthSYx10xetNOQES9Y/rKzUmCUX8qkKvq8qNvCaNTVIq6
	wjC4sAnw55y+Lv5qtVufGDOiYdiHdgZ/e8fs+vrVgkPSIuH1BV05ltWBXsluFFz9yQyMnj
	+b77E1nxX3Ty476WozTqiEvKKWFgRDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FCB041A9E;
	Sat,  7 Nov 2026 17:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412B11F008A2;
	Sat,  7 Nov 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794072397;
	bh=Ry+MkwlQ/4sA2zfKwfD6o/IbNoH2lui5rOOvBIVk4/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QPUqaHF/RY/FvNLc4H3/JmhJCaEb8AL7k8ox/OVtFHCRzoyRDusjxLv6pPEGphQtF
	 x9HB2QiorCor4QVg6qvvYM+kAVWR8sGIOAJMCmy6LK0Vq7z390PQhQ4AspdA7rmJj4
	 nAApng664LIps1HTdzOsl5ubD//tAAwA2fOzatRTvBJBUmg2P0Ew6A3rg0YjFjs7Eb
	 A2oTszvImvJmhQeCFk9id4dMjWTLxganIhDLiiFnngGNif/OuShi3t0o2mX9cxiuUc
	 WU52DAzfp9KZ1AdlqDDI4knAc9vH1oRe6Hh/KydCFTeWRfhhWOys3G0NzAJRBvo51N
	 AsSJtthhj2t5w==
Message-ID: <sashiko-outbox-203102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: consolidate promo vs. high watermark
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: "Gregory Price" <gourry@gourry.net>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 17:26:35 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56E8F40006
X-Stat-Signature: f3ww4au5mqukzcxpbne5yxiq9z3whwj1
X-Rspam-User: 
X-HE-Tag: 1794072398-68508
X-HE-Meta: U2FsdGVkX1/y583RyLicn1b/yo6/CXkSnznaww1RAoWvl3pH4G32LLddW8IOho8bOGJtU/ghqCtTz1aCzESsh1zuRHRqtsJDFEGMKWouZkbDk4LyOKK4OlSqv4SsqBoGdtGdfDAfLAHBBQxdZEL1XUH41iOhZIfU+Y1t8DBOpqeT62bw0vPLaVHfE8/5v1W+/7cF9J2KDOzTqKRTZcWfGzAN47spXmfQZ3HYyofBC9iwLbZhlFZmnaCCBq3xNHRMyb5MfGFVdjo9NRQvcEv7tis2+V6OEVU7rs8rbS0DKUGsvf9kYdgrVAtTw3udmTvfpQZx9Q39oh8qx+h4Zxedx8yLsSE0TiCa/jFTtVKy9N3t9gzSKdjJgNg54/y8XjldmNOP4r68HmRP5IB9DzlzvQNxdKX9o9Ptw6zJarmHSFSHmv14+OkAK40cxdP8sYMCfLleJJm3R8ecewFKxQKSOoIN8NwU9AQawI9D0wSIieB9ygxqJXC7uY3X6BZJ/adKaE8jXvevKGIuStoDJSd4y3pNaf2NMNegn38PIN46xLj6qidozCXD7EhxA7D3f1iImfshhiq9XtJx5Fsi8bK+2RQiHdKm9YBqencgwYNJ4LQVLGe5M5054Q9uiKyEzFEjAqvePiP51cIZJtUJvPd0jJOt/N823eM9YmQMVI/rCOpSzT/1l7YvH9JRkPFSnoGKRic4m2uwRYt9tEps2v1ciff4SQu1wcPucxrf4HeTuUkiBntHVdeXDcWcAwVnnlE06eOwI92aJEpZmzhIs2IzJ3Wdj998P8oJzerBfQCA0+/4Gk59JI0m7hoY6tLsDBT3f7okq9P1yzEkgquPAv40ejY768rXmHOD/eb/XoUz0paGk22fz0NVih8jPcuuKdV0ykYhEiY6jWYakw7kioaoUH6u2Fv8bHuFdSUydaBut/A5S5xbJJAWMWN0DNELUEFf5wFiMARQw6AKdkqLFVP
 3N3zFBhM
 q/iTt+WeeEQeaK0SOMTs4Ao3pdVt3LbiD2nX+08GUJnq6uBm7XtNNMhUM1D+NCHZtvuTVGw+n0OsbGH4bnDY1PItMhX8bCvzRIs3Ea9qF5nimRfDCod0FMH8lUxGgcX3KlVkq6qNR5FZZbQovru704Vh7qonM39PnbpJCKCgs1g/F0QI7s6DEvaV2HVkAZbU2SLeUHGbzynsCJUx0DEZBFofhX0rdIZmfhM+zA/Cn88UllDdclfy287XO2cz+uJF6QKFht+RMe6d7VMYzYyZWedDG7QgBw+4bCTtBk7tdsSaixmNAVw3PoJdB9dxzpJB4nW5HpPFn/zMYfzlzEe57Q/85woK+DeOW9mItFKHusJhkgL33QzcM7xeWYH/Z14kvKNxuPitTmGdO1HBmn9NMsGT/dzUEiv7y4PsOwy26hTLBzpRVDtsN3Y/fQt9/yic0pZ7QJYiQkRvCDA2Xw2FLeNvewU8rSYZPWQB4aIPsGkLKlaF76rwzdWQnxEFlrrj7t73Iv4nSXo3MxcPuC9QoNlKIxOa5qZup6qcFSEzf4DljPgGqh5liEy/wE8lQMD3+ToaOPt58U4fEBvs2yyWAPh12hgarTbo0n1g7EzyrPkEWLoVgz10fsuTP4s7/suXgQYK0KDp0dQuyYFYL2yLI4VvBBLtNDD2JTlUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] mm: livelock in throttle_direct_reclaim() [1]
--

commit 577a3c6c5ce30c67e4a789965d099d1ca4f2b341
Author: Joshua Hahn <joshua.hahnjy@gmail.com>

mm/vmscan: consolidate promo vs. high watermark checks

This commit introduces kswapd_wmark_pages() to consolidate the promo vs.
high watermark selection in should_abort_scan() and pgdat_balanced().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 071a6eaef1a1a..97c5843e14f15 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -6966,10 +6973,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int o=
rder, int highest_zoneidx)
>  		enum zone_stat_item item;
>  		unsigned long free_pages;
> =20
> -		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> -			mark =3D promo_wmark_pages(zone);
> -		else
> -			mark =3D high_wmark_pages(zone);
> +		mark =3D kswapd_wmark_pages(zone);

[Severity: High]
This problem wasn't introduced by this patch, but can pgdat_balanced()
livelock with allow_direct_reclaim() in throttle_direct_reclaim()
[1] when a lower zone such as DMA has free pages above its watermark
but no reclaimable pages while higher zones are exhausted?

allow_direct_reclaim() skips zones that have free pages but no reclaimable
pages:

mm/vmscan.c:allow_direct_reclaim() {
    ...
	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
		if (!zone_reclaimable_pages(zone) &&
		    zone_page_state_snapshot(zone, NR_FREE_PAGES))
			continue;
    ...
}

When all other zones are exhausted, allow_direct_reclaim() returns false
and throttle_direct_reclaim() wakes kswapd and sleeps on
pgdat->reclaim_wait.  However, pgdat_balanced() does not skip that zone,
sees its watermark satisfied, and returns true.  balance_pgdat() then exits
without reclaiming or incrementing pgdat->kswapd_failures, so
kswapd_test_hopeless() never triggers and direct reclaimers and kswapd
wake each other in a tight loop.

[1] https://sashiko.dev/#/bug/linux-b88b79bf-7e7f-40df-b7e7-7afea197c220

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106172620.3181=
13-1-joshua.hahnjy@gmail.com?part=3D1

