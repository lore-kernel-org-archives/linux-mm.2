Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39911606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvWbnqBv
Received: by kanga.kvack.org (Postfix)
	id 130576B00F6; Mon, 19 Oct 2026 14:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1ED6B00F8; Mon, 19 Oct 2026 14:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F128D6B00F9; Mon, 19 Oct 2026 14:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C026C6B00F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:32:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 204A8807C6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:32:53 +0000 (UTC)
X-FDA: 85340222226.08.1BD4178
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D47140006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:32:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvWbnqBv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792434771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kyeVjIMDuAUkHukbsRjtRHh+FleBWBxQgLrgbUvso0=;
	b=fcBU0+GMzA0VN6nr4Xs+hTr7OPA4g80xwqDJLXAjGRrrBFK0jNxVul0x8gDN7YsHLel1gg
	iyJ+5XudCQaWZeNrqRvapgHWUesmwgEF7/bLc6maK8+sRrG/+ulXAH5qOoDW1wepeHqvCx
	XfqO9pN7QOniBbLhzlXWcVXEu3t/Qrg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvWbnqBv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792434771;
	b=oapYtcFlHvfMdQqzQEb7fDJh43CfOHwfctQSg19Yi6iQtNJAdrHrzjP1V60gcY60gCreJa
	tV+jf24PUZhG7J2FORa5Qulu5zME0vkdYuuHn4Lz/38PB/kHt2GcfRuK657ws0Etf2MxX3
	eHp5ihjYJhjw+eIglMKqEyj8tNK8dfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6629E42E37;
	Mon, 19 Oct 2026 18:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE28F1F000C5;
	Mon, 19 Oct 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434770;
	bh=3kyeVjIMDuAUkHukbsRjtRHh+FleBWBxQgLrgbUvso0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CvWbnqBvn4KPVXdHwspTy/yr1yekTD43IcpgzFeqEGO3Gz+zd1jmbPMLMcfqCLWUV
	 4NJGkuHiW9oBS6H3qPoJ3eBhNOHAhp0zNXAWrw0OrKvQYV2YOKwgbjDOp/bLr6hajy
	 CYbyyo4npmh4toEL5d0/Y9nLnGEqOheDLHqnVXZlhCd02mwp6y5rta1EEg5ded7S/e
	 T7sFIUOXaBGSrPHPOy34J8rx5sTTNpem6quXAymBjkuG01+R+tCX5tMMwwLTmOzGNs
	 RiSfHw3yCnOWw2kOMmy46AqYU6WZ35ubaxbzv7RhN4G+FcSm5wuhDZpk1ReskY3b9a
	 dfJsGl8QzojFg==
Date: Mon, 19 Oct 2026 19:32:48 +0100
From: Harry Yoo <harry@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Message-ID: <atZeVV-uZMaLL_Id@thinkstation>
References: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D47140006
X-Stat-Signature: tdb3j41bzke68puij63ac4dkaojsajgh
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792434771-841305
X-HE-Meta: U2FsdGVkX1/dJeohbF08rx8SxfhYPh4b47Mn0ZNF/qcKzlf+vnDkibcxwnCV/8op4rPZVaLukliYuNd/Zqfx48Fuer6tccgPNA+RYbG/Ahisyi0xbH5uA9AzKTdFTwowy0+1cCXL3OHYsyH/9bQylL0ryIqVdZYPGEu/gpAQvNx4J+PCEjadQt8FRKrECJg9xOTejXKz9VrSLZ7KtbdXqC8dV/lg5tEVeHzlSN0Z4H4cxyAZDfZ1mvQX9Q5Qj2OuwRYb9N6StPQsTxxVB1O+iMLJ4uUTIsO+IJnMaFep9yp8YE6YNzAlRIHHPaOfUd+r7ofyz286AU6b/uTysPmJG1Sm7zqmU5P58wDoB8AmgpLDESu8KfHEQZc+7yKPwIynmIOAZcIWtD30HWAq/Oz+V7vw3vGF0m4gE/Az6LfcsSfrLK2WXdYv+X2saGRD6S0mSUbK7HGFdsh9e4Q6ZNdus7L7jRxqw5mO+tgR2HtoiFPaUN164Jrnc8zhpxMqT0xqq9iNMhMBfC+pFyfQOfzALDfQBAFHVS+G9ark6La3UQrocbK1QgP2Qnan3w5IlanxfmWjvY64iNuWxNe8Nmdg2FAias7CKeNbQI62ybYrQNDvLCtf4erFZGeyXZ5j/VUmxBpJNrbcReS5n1AyViPh2LGI6UZ39+lSb4iZ5QfdlDJWdncavVu+cKQsrraNfsxyxNu8sTqjtOIND7wcomIsmEeDkv3A6q93624WO30/RYYUQfE//Y3RfgstaxBSHHlN4czIeqg9oWQXccDXXzgIi7oKuYmvX+V6a5/L0836Mp4CIEuGl6obpi6K25AtQejLcWRblKFiZWHBIV9jXZY0OFHHzLO/Cj2h+n4100Md1T6BsWXY6WuyfwUu62c4DSpewAnwUXBtnrrWfkgsAWwIaOFj9YwdDdQ/yn9golA2Rhwb5fOipkki6xYHjTwlrQhalmZu4jlSbrm4/RGD2tM
 m6Oh8yJp
 1yZZHUWLPp2uW66ra9V5L2V6KFNSzh8JwPKBSWNsLQtfmbI4VAx++1j/N6Seby4N5ekZf9Y5wkUUbtl3y49DFqcMKQwftnc6LJ7vkxsGlNDnwV5rH5lM+lLq/pnTcfds3xnWDc8G2OcFzQEJYnKZi4IZbQR8YVl9bdLS+S/sWc/Cz1dgbK0XrEBpMUoRDUiv4/ETthduuthw30H+Kw7mgmX0xBRfKzj/lgMt/vkTDVWU6I3HBOMZIMo5U7qhsXGsshsgxfqUePS0mucnEKNdzmzzpHb+OHdep5DIrxMAQSrWR4V0kP4xYeJFnBm7Up2VySa3Oi7yRE+lkrF84ZonbgfgJz72FRet1LwjPTgFnsBs4WJqOlVLjef1PsOHszmxXMDP9urHTlCBdNQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 07:39:22PM +0200, Konstantin Khorenko wrote:
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
> it ever charges an object to those shrinkers, plus a pointer array
> sized for shrinker_nr_max. Every superblock registers such a shrinker,
> and shrinker_nr_max never comes down, so a host that mounts many
> filesystems and runs many cgroups pays for every superblock in every
> cgroup, live or dying, and keeps paying for new cgroups after the
> mounts are gone.
> 
> This replaces patch 2/2 of v2, "mm/shrinker: allocate the per-memcg
> shrinker units on demand", with the xarray variant discussed in that
> thread. It applies on top of "mm/shrinker: allocate shrinker_info_unit
> from a dedicated kmem_cache", patch 1/2 of v2 sent on its own as v3:
> https://patch.msgid.link/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com
> 
> Patch 1 keeps the units in an xarray per memcg and node instead of the
> pointer array. A new unit is inserted where it belongs: nothing is
> reallocated, copied or published under RCU when shrinker_nr_max grows,
> and the readers find a unit with xa_load() or walk the present ones
> with xa_for_each(). The units are still allocated up front, so this
> patch changes no behaviour.
> 
> Patch 2 allocates a unit only when the cgroup gets a list on that
> shrinker's list_lru, which is where map bits are set: a cgroup pays for
> the shrinkers it holds objects of, not for every superblock on the
> host. The install is an xarray insert with the gfp of the list
> allocation; there is no array to race with, so no lock of its own.
> The root memcg keeps its units for the deferred work of global reclaim
> and is the only memcg a shrinker registration still visits.
> 
> Measured on a 4-CPU, single-node VM, 20000 tmpfs mounts (shrinker_nr_max
> 20096) and 2000 memory cgroups, on three kernels:
> 
>   base                 v7.3-rc7 with the kmem_cache patch: every cgroup
>                        has every unit, in a pointer array
>   xarray               base + this series: units on demand, in an xarray
>   old array on demand  base + patch 2/2 of v2, rebased: units on demand,
>                        in the pointer array
> 
>                                                      old array
>                                       base    xarray  on demand
>   slab per empty cgroup               185 KB  18 KB   22 KB
>   shrink_slab_memcg(), empty cgroup   1.6 us  0.2 us  1.6 us
>   same, cgroup with objects on 100 sb 1.9 us  0.9 us  1.7 us
>   mkdir/rmdir the cgroups, 4000 more
>   mounts with them alive              same within noise

I think 'old array on demand' is probably good enough, and replacing it
with xarray is not justifiable unless you have a realistic scenario that
would benefit from it?

-- 
Cheers,
Harry / Hyeonggon

