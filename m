Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA55CA5FA7
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360666B0096; Mon, 28 Sep 2026 11:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAEE6B0098; Mon, 28 Sep 2026 11:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA526B009E; Mon, 28 Sep 2026 11:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E64CA6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:24:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69901140253
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:24:51 +0000 (UTC)
X-FDA: 85263543582.29.7B677E0
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9551B140007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:24:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="isxV/hz0";
	spf=pass (imf23.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790609089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6Pp7UXENL802jIZX5zKHy4TP058XOOA4yzitIGnZCM=;
	b=T0zmmADjQhSYs6tG/NU2FvBnPwLYEE6VAXnBV+uF7VLanHgwci2WlR/VM/kguBB2Z4lHFd
	S8/dRvxAkvpIvyWatX5dl/Nwhzx17vMy9gZMVmpAEAAuF09kwyz4WBi20CMkmEnXtATNK6
	MGaTSKpOonKvNBs4lRDagseCsZbJDss=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="isxV/hz0";
	spf=pass (imf23.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790609089;
	b=rcpZl4w90/NIWjVYUx2qi4H2HtPe/qRpbujF3Im4YdCrx+pbTgaKfY3FEJttamTCnIpJ4x
	d8DDimEf9+YQZAeg5J+jNDW293YF9isY373NbTYLfyN0vmOPUDHyC7zkbcqdaysTmjIriN
	sxLE4i2FzSIXfzF+v3PpADijLDzB6ps=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d91ede8035so27688495ad.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790609088; x=1791213888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C6Pp7UXENL802jIZX5zKHy4TP058XOOA4yzitIGnZCM=;
        b=isxV/hz0yykyFPh0KCBH7D5xr6/sCnHERrCuHVwJwnCGjaGROvLAeN30lnI1m51+Et
         2oJ7pbaqL7llK2yd8P391s5OkPsoMibKjvfdW8sIl1F6UcuEQhT1ADg2Mt+I1vyI+pm4
         tJ8bGq4jP5saGxozU06jJ6q3IecwUVENS0zAVeBWw3jIwWT5y1dCHBGQVkogN8CSy7Ww
         jOaWackGEu+ozN7yrOO6vwBXKPcv4SMUNOUJydLDUkRTo1QsPdGmn/x4Lzdz3JStAPzw
         HQmbS+/VRyNhVd4MyQ0n9kTlOP+UCpAiv8wpl76h5coOVxm5DfiFxD0QJ/of/QGkzR4j
         xO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790609088; x=1791213888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C6Pp7UXENL802jIZX5zKHy4TP058XOOA4yzitIGnZCM=;
        b=SHOdln2FlbePyrAmpiwfllJKayWp6mUsIuSrqxusd/WUzZ2HduSpPst/R5t9l6/2lR
         pfBzn3gr0+06sWCcMEEFVDS635uq6ZWrZA7hfkMRm28Dlfk8WdXNyC22LU++b14n74Lz
         7Lk+mtcI1aDQMG3pJFlT0HNc0t8f3j0qRrd7JtmeBSAYPj7kDQeEvG5j43z3+4160yxm
         cH2YlHfdpEJNJ0IKFaXHCa3byaGxu4w8D9YqWdCUnACRHBYIHPocH18fb+u5OH7tgiii
         QiGRIBCsLpglZtCHr1/t5TfsMKtweSJN4kLKm1rEvU2JH0F0GqK/HsC5JpIH33LXj34l
         bgOQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJGyGuubnwd5P2dfpu6TbfsSoVdMrjQIy9OxMB2WEATwoKuTVwHsb9eos9QKyLM+SZrX5YBi1Rmg==@kvack.org
X-Gm-Message-State: AFq9FYKyyhSrI/92oKUBVGiQirv8644iESNx57G2XBatEAIdf4YtcFCa
	WguFxQXjct2GR+m4l6IwajDW3VBnTX4L4ifrSDKxJOZZR5GO/NkSswDU
X-Gm-Gg: AYBFou19FHjWN230kdnNLNFB+v+KV+VkMCPIn8HNfPN2Fm4z2CHxVqhjIpYZoP9+gP9
	EFTOfGZVAhF5JsQx+db9nSrDJtDDUWP8LIcKPiJl5Bl/8nwBUrc6Uz6IyGvOU1nw3rVkwCqo/pq
	GluAZ8c66aL+1txZMjQbc6ilriTMmGOLvDIYYfJ7MBY9wWOBPyzG4X+wKTNaOobeACByU+/Yu81
	o+aUfuQPPT6UmvHZX5yAmf94HeQJRL+Tz64//TaJF+TWxC8+zibM56Ol7/YcHlW2ig2Isj9Vbte
	gl1hN3a4RGEAoT4tpfhr7MwnVdCF9EG58auiq0OsDkQguTcXyX1P33Uo4s9CLG5TdgBO92pM5BF
	jXkt3E3e33Ibl9+YYF0ibSdR5SFO/Enfs7SKSvLscjsV7jbCz6qndNpEXtn+7ObRF207KA4ecyr
	zrML9K/mNApDdAoHYTUFvTMZAMHUISksYkuJP+jdYnyHfMhudHQ2ajaS/0U9erby2fWAuVD15xr
	b2rvtypTzQJFsmDZSFMv3ZNImcJzqlVMtBVz6T/yCzdmHeBB05kICfyLUkBTtzBgBg/SYd63QlB
	4vgP3NG8KX6LIOpHnJyo4xAiZt9XUIhyNZkkJVX1BQ+AE3jPjzRFT0+DkN0=
X-Received: by 2002:a17:903:2408:b0:2dd:c100:9435 with SMTP id d9443c01a7336-2df94c1bc19mr71037265ad.51.1790609088305;
        Mon, 28 Sep 2026 08:24:48 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dfafe765cdsm25166465ad.33.2026.09.28.08.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:24:47 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Vivi Rodrigo <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Rafael J Wysocki <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:24:38 +0800
Message-ID: <20260928152438.2694783-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3FDF3191-94A5-42B3-A33E-12021344D7BD@amacapital.net>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <3FDF3191-94A5-42B3-A33E-12021344D7BD@amacapital.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9551B140007
X-Rspam-User: 
X-Stat-Signature: 6sk4s7g1jp3dfkxehgxe38ifhshe7rby
X-HE-Tag: 1790609089-621064
X-HE-Meta: U2FsdGVkX1+489EL1LRYPfVC84VKZalRb5AuKAz9ir5t2LT6hDpt4YI7awCeCu1JzrFA35f7dF43UAgDfY81uTPDzLXAb2uz20+V/5YqBruWc8S7+RjTc19+jA12FDOlIGVXYWCWqC6h7biK7hAIr50ypmx6EXx+7Ldhol9PA68F8LQ2Qsj4N5ccWEI5DMa331h1NbSf0JMz/rJcgzg/N8Y4dwVwfjSWPbT7gsDTDvR9kYmlAt/B82c8ZGpDZ3pgoSWvJDc/60JMAQ/OvvvbKIaAs8R54IbpuA6yWPmuoARDrigMt9IjzESlDAg9ZtiUIaGusvzEITBlRJizRdnKJ0K2FBWh///umhpVPNr+rx/kA/7YvnkcolUk53wOMpBLQVIHt7YzDcvwWs2uEk7wNH0fNaqEPqqHLCgDxpoXfej4WQvrKNpsqroWXv/yOWgL6oxAS0n3ShrqdhbE0DHTLw6L3YPe71eBViUJtFxdm/NN1VOf7h77rJUGMYy5dQj1EhxFdQQyKaoAFiBnLBCoNt7ROk0t82vY0d7YyedE9sHMPhxC0tBgp0IW7l+pcHVYe9QeZueZTg/+3ZUKkLjxtX2QbjDKgZK34Bcyxaxl6SZNSYUa69dBTXOkUiJoUjv/Bc1jREyG0DqzR7id6Yc/n3vmWSomkQPUHmv+IJ24stopJtgd/uiXkErMJaY+RIjm7e64wc8wHxMM+qd9WfmJL3Xedk/vCQNKvZT7g9YVc20Z4NU9jvVnuGxsks/3j6fyanobJ5At1uueHuWe/aYtnG9tnWhP5nhrUBdZKUjW4G7zmUVYy41D+DDu5H8Lh0uAugu6lLlzolJufJ9TlH9zcuJEwyEVbuX8j814VYI39+c9lvdW73DtTssQh34rUTmGnFZ71vyHGXmhpbbO6KAuNHKE52levu0r/CAuKf/nWFIP52iAqHreXZe9u3tI3zBlcfa98JZ5QihCHn9VkIR
 n9Lpkqbz
 Oaeva+ai7oLng2tfFCmGQJnyMlbZGNMoNKEXaJkVShN1v3VZAPjQJ3v1nFX7fW40kXL2gSg+D3KMS+X3g8SRpPipNPTnsUy8JcJMqvLCAH6astkr0AF5o+Q5xDz5hi0b3ke5p10LZghYd5kjLzSWbZS/07y/ca/iphl5qIpdxbrMCSOY4YJWWjGp18niHsCgnoxLHh6jPsFuPNROvs1uS+E5bB9UPd7atKbIG5jpyy5wYeEU1JVzLp72I1Hg61FtqrUCQw76Q3phuJROFjnINIs0620KoKsQARY2gI4LiZlNppf4BrVBsLrmnpagvLQSJf7+H7+QRYnD5iTteKX47CY8WD/j4hPYzIchnTHYObaRwMyGZ8PWx3nSB1WFic/7fe190+hlfsOUZBHla6n9zMfDhFseXie1TH/sm3MbQxXWbVvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

Thanks for reading it, and for the direct feedback.

> if the system is under overall memory pressure, why do you care what
> triggered the particular swap operation that is being processed?

You're right, and that question gets at what I actually want better
than the series does.  The goal is: when there is no memory pressure,
swap-out may do more work, including allocating memory (compression,
copy-on-write, filesystem-backed swap), because moving cold pages out
to make room for page cache is what swap is for most of the time.
Under real pressure, swap-out must not depend on that.

The RFC was the smallest change I could think of in that direction.
It used "who started the reclaim" as a stand-in for "is there
pressure", and that is wrong both ways: memory.reclaim during global
pressure may allocate, while kswapd with plenty of free memory may
not.  Building on Kairui's suggestion in this thread (swap tiers), or
on virtual swap, may well be the better route, and I'm looking at both
for v3.

> Why can't the kernel figure this out itself?

It can: the backend knows whether its writes may allocate (zram knows
it compresses, a filesystem knows at swapon whether the swapfile is
copy-on-write or compressed), so it should declare that, rather than
the administrator setting a flag.

On the practical questions: v2 does nothing to balance fullness
between areas or to empty conventional swap, and does not change OOM
selection.  Those are fair gaps and I'll address them, or say
explicitly what is out of scope, in v3.

On the recursion question: within the reclaiming task it can't
happen.  memory.reclaim and per-node reclaim both run with PF_MEMALLOC
set (memalloc_noreclaim_save() in try_to_free_mem_cgroup_pages() and
__node_reclaim()), so an allocation the backend makes in that task
never enters direct reclaim; it either fails or, unless it passes
__GFP_NOMEMALLOC, dips into the reserves.  Two things do need care.  A
backend allocating there can drain the emergency reserves unless it
passes __GFP_NOMEMALLOC or fails fast.  And work the backend hands to
another thread, such as a filesystem or zvol worker, runs without
PF_MEMALLOC and can enter reclaim itself; that is only safe if that
reclaim never waits for the write the worker is meant to complete.

> The remainder of the writeup is IMO somewhat incoherent.

Agreed.  I cut the v1 cover letter down too far and lost the
definitions it depended on.  v3's will start from the goal above and
define its terms.

> Adding "eligible" to a bunch of calls does nothing to explain what's
> going on.

It exists because v2 made "how much swap is free" depend on who asks.
Reclaim itself checks free swap before scanning anonymous pages
(can_reclaim_anon_pages(), MGLRU's get_swappiness()) and before
allocating a slot (folio_alloc_swap()), and callers such as the GPU
shrinkers check it before pushing objects towards swap.  With an
offload-only area, each of those would otherwise count space that the
calling reclaim may not use.  In v3 I'd keep get_nr_swap_pages()
meaning "usable by ordinary reclaim", so those checks stay as they are
and only the offload path asks for a different count.

Thanks,
Matthias

