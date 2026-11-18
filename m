Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00ED60A3834
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HNQAplAi
Received: by kanga.kvack.org (Postfix)
	id BF4F06B05C7; Wed, 18 Nov 2026 09:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC916B05C8; Wed, 18 Nov 2026 09:59:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A306B05C9; Wed, 18 Nov 2026 09:59:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 912C16B05C7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:59:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 342AA1A07B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:59:57 +0000 (UTC)
X-FDA: 85448549634.19.6823D61
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id D16C010000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:59:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HNQAplAi;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013995;
	b=PDIg1yfPd9Q3/2Y+5AtomyTtqOL19TXEvJn7oAPOpuW3aEfMKmsilBwu5pJLNfxADv3L0F
	JZSQKrayImWdtQqnVwYolNNe6QWfLVqV6uSw7kUuEuLAFp5TuaggZ3ibt7/cpVf2cveFUU
	6MuMzTmpchIP+/ZC8NWTr8DauyJqHBk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HNQAplAi;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHA2gSMreq5NvV78ff3NkuJxnwpR2g2o/LhjS2wMs8A=;
	b=M1UhKp0+sXkxpfABe6qwHx5SGR5ExeWDZ2MRWWS5yPigKpSGV5R/A+yZMJqA67yHCwbjSP
	OiiqNOQdpxcvnhL+ymPXjsNtOxlOkFlhXHJe80PcC5ip+aqNDb1KgteSUOitaJ8nqP+cwc
	1PPOmnpnvUy+Zsw7DnxWu+s/2wwvCOk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A55EC1477;
	Wed, 18 Nov 2026 06:59:50 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66DC33F632;
	Wed, 18 Nov 2026 06:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795013993; bh=YniiAGhFs3f6RndqIyYnDs1IU7RZgamrSEyiFvFrpD8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HNQAplAiLMoNveoYkT2JyRS41v1GiH0guf1kxhNgsdRvvQf0dUA2DKfmDGxR0PNwu
	 FhzNBR1nlLkEfVfyBrjg85ooYVWz1HickJ83DYukJrIarRHYwLEysWl/ynz+SXDJbu
	 7pboArrQDJja4AqSVQAiXmFjvdRYLVxq9adSxc+g=
Message-ID: <b2093f38-e3e3-494e-a27b-afc91c578053@arm.com>
Date: Wed, 18 Nov 2026 20:29:44 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-2-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116232346.788145-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i7ud3msuotebbupag967hsqjsfepdjxg
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D16C010000B
X-HE-Tag: 1795013994-985250
X-HE-Meta: U2FsdGVkX1/XAIBVUIDagH/LG3G6CzcJOVBdw/MaJ2C23Tb70TbXvfyjjXq/HYT+6QBX5AZZeeWplPMrD323rucOhhmLz7FxmvpFurt7nD+toIb2optfmAeshnrXPlk0aj7ijHmVeMDLqRi0CJejHW3HXi5f9vKUDqZ3Y3aEHdYoyjPCPV42Ez/OijiTNQE3LDQUnO9J+O6Zijx5YfFMDfpHq7MQ7CzgftU9GgpP5WiwpvYeDmny7CYdFiVFlo00zVFs8Lq0c7BxRWf1cv/NcBPsyT2tDus3XEkkkgNKyzvWRl6mPiqGPqARShlnO6wn8Jcv6wga5Zbb0GDEFoPtlvQLRgL7Sz2nQBRlBmH3ansxBQ5U8NKrIZK76AEAwS+q3PgptR/bAJLp8HwroueTa4PnysU8OHWftHUZdyyLjtwC1fa86Q/91LAtcSivvj2QwjNiETBZhasup5mZ9K9dE3azQYE6VsZWcu0y9q4qlTWNiwRD00qchoXVqeyiRZsmzDI7zdZzD7DV3tMpamXue5FQDI8kVrHA+yK3aXg5IHrfcTHGwuRzXkXpADZVgyNe+rJDeYfy8tzDBkEl61kGomzgYXfuV/YFpQ8//u2EN1zNpXS6mz5hb/BgUOmi9g77hNVl7bFwhMCFp46bhJPdCfRBNmqK+ZPjycojWB63oHUigrxGcyqNXJwgO7y+JK1tJ3KlMd0py0hSje9r1EUzhK1lKhwR5Lc/YflmGAWTL5jqYubxGw1PLpZH5/EHZppgq9AwPaqi45XaXgQF0LfHWCXeuIjAoKu9VB1wXQ+jq0u1gYnDzddENtas2cmGeyL5WPMdFkFZgbrNoeW4TQBgdYCMGKtA5UDW78GlT7x2x2vrppcW57x2wUdZVThGdwEe0lcvQUhSg3eB02pss4EdkJw/J2+cUATymhkNIiMGJaYEclSRrUTZQYArIIDXv4269c7XyrnJE8Z0K2Pv1dd
 nelsEtOL
 QpJGDTl+vg+CtiONN98u0hOx5K2hYe9QDUIoHsEQJsYrRAXUuzuQgpLk6SQsSK4UV7FYemvnNyPVPSCGocwvzKw9uXtef4SKBrHQkgSZWcSf9F5Y7ePN55x8bV6KUrf9sAz43zBa/4HsL4ohaXNSyXcRW6GPcc7RwmVZU4bmSAaP5UgRvi8DKXLA0hTUJZR9X/KP1SU8xvDhEe/QYnF3B3GsLgkRpJ+x+ntqeChaJxY/TIYjV/ID1z/fD9XqeW2AVRyKYdJeqIVC1nc/l2UnLu0roxObpVjpd6OPR8CfqbWDikyWbU6Gr02dVcNogM52tZbS5X50LXfRMVooB1C1GWskJ+OvGbqJ9E9hC91FTQlIM/xwpzclZQWbikCngVZtrHp+/hZuxKvUo9o6y+DYOOsREFdrWtqo7aYsBBGURwYQqTGog2skOdhAeLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 4:53 am, Joshua Hahn wrote:
> zone_watermark_fast() has not used its gfp_mask argument since commit
> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
> 
> Remove the argument, no functional changes intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Note that this series:
https://lore.kernel.org/all/20261116125103.2894162-1-kas@kernel.org/

needs to use the gfp mask. So perhaps drop this patch? Otherwise we will
just make noise on the list by adding it back :)


>  mm/page_alloc.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9e1261521b6a3..4d829e5eac49d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3675,7 +3675,7 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  
>  static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
>  				unsigned long mark, int highest_zoneidx,
> -				unsigned int alloc_flags, gfp_t gfp_mask)
> +				unsigned int alloc_flags)
>  {
>  	long free_pages;
>  
> @@ -3877,7 +3877,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
>  			mark = wmark_pages(zone, kswapd_watermark);
>  			if (!zone_watermark_fast(zone, order, mark,
> -					ac->highest_zoneidx, 0, gfp_mask)) {
> +					ac->highest_zoneidx, 0)) {
>  				skipped_kswapd_nodes = true;
>  				continue;
>  			}
> @@ -3897,8 +3897,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  
>  		mark = high_wmark_pages(zone);
>  		if (zone_watermark_fast(zone, order, mark,
> -					ac->highest_zoneidx, alloc_flags,
> -					gfp_mask))
> +					ac->highest_zoneidx, alloc_flags))
>  			goto try_this_zone;
>  		else
>  			set_bit(ZONE_BELOW_HIGH, &zone->flags);
> @@ -3906,8 +3905,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  check_alloc_wmark:
>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
>  		if (!zone_watermark_fast(zone, order, mark,
> -				       ac->highest_zoneidx, alloc_flags,
> -				       gfp_mask)) {
> +				       ac->highest_zoneidx, alloc_flags)) {
>  			if (cond_accept_memory(zone, order, alloc_flags))
>  				goto try_this_zone;
>  
> @@ -5245,7 +5243,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
>  		if (zone_watermark_fast(zone, 0,  mark,
>  				zonelist_zone_idx(ac.preferred_zoneref),
> -				alloc_flags, gfp)) {
> +				alloc_flags)) {
>  			break;
>  		}
>  


