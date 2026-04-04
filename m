Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EF1E88D80
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 11:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EB76B0005; Sat,  4 Apr 2026 07:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF926B0089; Sat,  4 Apr 2026 07:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15436B008A; Sat,  4 Apr 2026 07:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92CD66B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:12:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 357D81A07DD
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 11:12:03 +0000 (UTC)
X-FDA: 84620608926.24.D252C46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A37E918000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 11:12:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIv6D33+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775301121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BadJi0nidtwgCNaokDKKZKawBS5mJDPenXLBKBjTJpw=;
	b=JceHAP6ig1ugLqPFq/K5Gq+6KFe9RsfbCMp3+Y60y9tX5g67Nznf+Zbi76DgsfUYFnhZzD
	uybiDMSP/aZNAsapjIDqCjQ7ueRTGBKY2EerbvsqEu+ceq+fQ2k/Hvx9US303YcaAEnTS2
	yI2Duw9kYRib8RIUZuZZc4HOw7ZJQzs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIv6D33+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775301121; a=rsa-sha256;
	cv=none;
	b=eX/tFi4IfhUgIhoiCUz6IckA7jM+k8AeNYDULrKa5jI7iRjGP3crMjxppGQWF46GCwtzs5
	TGj6ZS4PvMZxImv4Hxhh+v2iczVHp9ABemexXXAOAsSswQ50rXd9ZpxF4RIe237lsWOrhJ
	cpVXZI5eTdHD5BbPOSq9HXP7SwJvHDQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CA9460008;
	Sat,  4 Apr 2026 11:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AF1C19421;
	Sat,  4 Apr 2026 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775301120;
	bh=upjC2amcChzNkJvjB78yT+nyj/Ctg5hG5pkRSw8QFPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIv6D33+nZsaQW3qEMSmPdTuvPhm55MyusGZPe/mhf/rnqzMA+MK7R4UzVn2B6N2d
	 a4cg+dLsOjHKVSZm6DutiPdxwf8DNHomGOwnwNn5CKkM3nReXQcXy0M+eLcXJbNTmf
	 rh1FY8NhGEw1N9imYU0e8VuxM8iU2h7g+qY0oyJ/FL3LTo3gSxoTWV5buDGi0gGWtB
	 UiaLZes5ET1xmmU0qWqgsqVSZ+J+r1B0yBTm7nl3WBy/03F2aqknMed2OMulnloMG+
	 H5e4Wv3i6bbL4aVl3U4XbrRBhgXSn8A0x/L/0l4pZQpjjtSPdAEk7pa0484KSIsg8U
	 yUfZmXg8pEWEw==
Date: Sat, 4 Apr 2026 14:11:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <adDx-FYHY-si07mW@kernel.org>
References: <20260401070155.1420929-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401070155.1420929-1-yuan1.liu@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A37E918000D
X-Stat-Signature: bdhw8wae8fijfuquhubsjacxtwgymk18
X-Rspamd-Server: rspam06
X-HE-Tag: 1775301121-864692
X-HE-Meta: U2FsdGVkX19HSTVxHM7pnIaknVCVSHKgvykOenHApKEOwGqaBg3m/+ROLcY4/GRfBCIvLRrCyuAGUB4mqfdxBtxsqCECf7QqffforniNuSR/iZTN2/4BZone/UgA7yrQzoI4VeKAw5bKFCxDWbkS/hsgSkJ6vwNkGpizGC2vRuWgJUxWaiBWZ4NcEk4hOGKPwq6oZHuMVmO0o3eeAxh5rHuB4p6z5DG9VoStP8qRFnjsLUKK8bn5XVW/UP+G6KTvgTOpOHGCl5qAjeyeI3zCr04Wn9/0fBGrVSL+fKgTOeJg5cGwam9JgMapkAPF/PPWeFDGxwjo6eoDlheHIiAL28sYUVYO0UmjoOgspHYxzVWAbj1B+TnNWJekEDlmsTbVxiIgbikdOJJvHqjInlGtHWKBpM3njCq61n3aM2B77vYvMROWNN6k/OBwp3NtOz0kQq72r1Q9lH2H8C7DYWqAPL34xPustzL8Vfn+X5IsB2uclTWtnvk+uruxapdcXQFiYsWoXIQFsdSJOuFGkymuA0AAzAdw1j5iYJslO8zKJHSOQPdC6slryGWuacqID+E6hmhCK5xZmpcVmlbOtoac5jDRy2E0+FzBJc2dGlkIcD039ogOa55uS8YLa8BF7O/EKWpFvvZmkni3yI+c5dIu6351QS6zZM8mVYhftGuxaprX9vJhkHr/JtVd73bqFS/Czy8vbbucxQDUyAqv2e9NvpDCX4OnYbNUibVeKZ/ooaaOrZwwb5YhslIBGfvJl9Z2eAuALB5cHOyGsoTUeH//VP6Krp2h5NaCzfBHpgWzBDu0sw4RSqlKWOrXYX1+UnF+42sE1aP0QMLsIwil2dYTtirMLBNvDWZc5Hb/N0USF0qseMRzov+eLViIa1idW286Fx2tCjJfWg69lyVjs6j2E5ylxvW+idMgEn3gtxiS5mQ/KcxtUYhXAbq/qt71XnfkAikbts9+aewqadNpD1A
 1s9ETQLH
 IFoDdMzyeNMMYWW4o4ZdM1l9bsIu1RnOkH/uhwzrmt0aqncOgXJvzxXkV0VfDKdV837ZTqZADv78UPtdo24KQEL00Gdka29Zjy8eczRXmigpp5PPolRONA78KxTzkgGlSVSa9j3YhWieTkWdVCkxgDiAEooknF7KOECG9GQJoRJ4J0jFB6JNY22X2aPPbNt4zuaWst09gXBsG7Zb7qf+PrL90F6keY8XTyDun0uVUUP5TV7DZtYSnc+gLFrtFh0fIwCTbGiElvC+lzr8Y7ZACnn6yuM7eWRbNzBq0fwMteJcfy7doTO0OT5r15NGXYf12Z2cp65MzNDjfmLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:01:55AM -0400, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> to rebuild zone->contiguous. For large zones this is a significant cost
> during memory hotplug and hot-unplug.

...
 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..e47e96ef6a6d 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -483,6 +483,17 @@ General
>    ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>    is initialized by ``calculate_node_totalpages()``.
>  
> +``pages_with_online_memmap``
> +  Tracks pages within the zone that have an online memmap (present pages and

Please spell out "memory map" rather then memmap in the documentation and
in the comments.

> +  memory holes whose memmap has been initialized). When ``spanned_pages`` ==
> +  ``pages_with_online_memmap``, ``pfn_to_page()`` can be performed without
> +  further checks on any PFN within the zone span.
> +
> +  Note: this counter may temporarily undercount when pages with an online
> +  memmap exist outside the current zone span. Growing the zone to cover such
> +  pages and later shrinking it back may result in a "too small" value. This is
> +  safe: it merely prevents detecting a contiguous zone.
> +
>  ``present_early_pages``
>    The present pages existing within the zone located on memory available since
>    early boot, excluding hotplugged memory. Defined only when

...

> +/*
> + * Initialize unavailable range [spfn, epfn) while accounting only the pages
> + * that fall within the zone span towards pages_with_online_memmap. Pages
> + * outside the zone span are still initialized but not accounted.
> + */
> +static void __init init_unavailable_range_for_zone(struct zone *zone,
> +						   unsigned long spfn,
> +						   unsigned long epfn)
> +{
> +	int nid = zone_to_nid(zone);
> +	int zid = zone_idx(zone);
> +	unsigned long in_zone_start;
> +	unsigned long in_zone_end;
> +
> +	in_zone_start = clamp(spfn, zone->zone_start_pfn, zone_end_pfn(zone));
> +	in_zone_end = clamp(epfn, zone->zone_start_pfn, zone_end_pfn(zone));
> +
> +	if (spfn < in_zone_start)
> +		init_unavailable_range(spfn, in_zone_start, zid, nid);
> +
> +	if (in_zone_start < in_zone_end)
> +		zone->pages_with_online_memmap +=
> +			init_unavailable_range(in_zone_start, in_zone_end,
> +					       zid, nid);
> +
> +	if (in_zone_end < epfn)
> +		init_unavailable_range(in_zone_end, epfn, zid, nid);
>  }

I think we can make it simpler, see below.

>  /*
> @@ -956,9 +986,10 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
> +	zone->pages_with_online_memmap += end_pfn - start_pfn;
>  
>  	if (*hole_pfn < start_pfn)
> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		init_unavailable_range_for_zone(zone, *hole_pfn, start_pfn);

Here *hole_pfn is either inside zone span or below it and in the second
case it's enough to adjust page count returned by init_unavailable_range()
by (zone_start_pfn - *hole_pfn).

>  	*hole_pfn = end_pfn;
>  }
> @@ -996,8 +1027,11 @@ static void __init memmap_init(void)
>  #else
>  	end_pfn = round_up(end_pfn, MAX_ORDER_NR_PAGES);
>  #endif
> -	if (hole_pfn < end_pfn)
> -		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
> +	if (hole_pfn < end_pfn) {
> +		struct zone *zone = &NODE_DATA(nid)->node_zones[zone_id];
> +
> +		init_unavailable_range_for_zone(zone, hole_pfn, end_pfn);

Here we know that the range is not in any zone span.

> +	}
>  }
>  

-- 
Sincerely yours,
Mike.

