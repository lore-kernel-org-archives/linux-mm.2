Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58DF60A2602
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA1C6B016A; Tue, 20 Oct 2026 11:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0F06B016C; Tue, 20 Oct 2026 11:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92DE6B016E; Tue, 20 Oct 2026 11:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B23016B016A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:22:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E9871201B5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:22:50 +0000 (UTC)
X-FDA: 85343372100.03.CD1A0F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1C3D2140004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:22:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792509768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NxIFDVsD5axqabICLrNLsV0/HgE+/FfIy2AFMMdvPg4=;
	b=Cbrp564z9Uo+DVIydFF7o3L3jsDBfWSdY/NowuhIxxgI5UzCbzM+YpHELmdonOq0M27svX
	ZrOoxf1rXQg3Folq34L3ktzcZamGvVXzSZ1zb51wJROouH2zC62UMDKmdWmQXuob4N48+c
	Ka96FE2qoglbv/XcBchNqMVk/mnqDdg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792509768;
	b=jrnDtKSlFMPEWuwJzRR5EJn1DOUoz9MbuOc5u3Y7Zu1P6mbjjO7DH0iE8RhWQ/2zwvshD0
	/l5iJK4KFI2yVCI9kfo9vTp8/EbkfN6sla6u0+2pKzlKAOxao6zryjFzGuU69PJ7A1Re6r
	8DB7xXFbCqgNv5iANgVTvLQnDz+r+KA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B040601F9;
	Tue, 20 Oct 2026 15:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ABB1F000C4;
	Tue, 20 Oct 2026 15:22:43 +0000 (UTC)
Message-ID: <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
Date: Tue, 20 Oct 2026 17:22:11 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 mgorman@techsingularity.net, jiang.liu@huawei.com, Bessel.Wang@huawei.com,
 stable@vger.kernel.org
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-3-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261019172346.3344005-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C3D2140004
X-Stat-Signature: z3653jink8egbiuipym5sjfxra5by94a
X-Rspam-User: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792509767-93694
X-HE-Meta: U2FsdGVkX1+FcS9bkgkCGv2epIB0q4v4YoYLA1kWHhdFmxVQVwR/vVoH12FwQNakt80LRwZ9jgRed1vWEhM5i9uQK87MwXgCscN+S2tozWI3BagfUSL7OpstAAmI55MnB4Yp9CuEGPQH2E0Q+rmQm9g5Ov2g6Y05M6XifeyZ01sSOr2s7l+FieQrmODS62MYOHcY9aZeQkYSqFFXykAfgQ9OYAfBtgU3tDzOc/T1husZtVO6Azga1trzm/RKpZQT89WoYxB+xNlV7+9BmhsaZKy1MVIUsoydBQSyF6oUKTI6wY5bYZN0WtqcLJlSXXCtO2C+uHDsBlkZHl2VxkZRY2C310WUVZDrpRBnKIZ4++//kJinSoLWRlhy0DSAHs4MdFX5HdZ3E7G7ClzYsid6TNFGkq7CyMbVZUX4sd2k0APvKgCkE5oLiFpwIs0vpws3C6mEW4h+cC4DFJnerrkJq+mhFT4Tq8Mz2ZAexid8b5PafJeBb4KRYdhDkNzK+Q1IcBIiNB6EyhTKioO8N7ij/VGpZqcA7rWV9k4AcuOOBAmzS/0Q07v8YzFC9n0If7ALQzL1nu83eIZg5lUeZbGarBkG5RFoHaKnQ+YSqCv3v4tvASfSH1qrMs0rE3MC8aw7fpzapr9cm7M30FcRl3m1odtOmAJXZJmoWnht6axC4kpV6T/Vsz+GcnJV0RyCSuIAPwFZ0WqtQc/rn6EAwm3IIcVo3FO9Fgrac53Zdf5/Z0eaVwJOC90PqYKQdIB7OKU/lkhsBAF6KnZBpTz5zgpVhb5eSrGvO9NSCjwN5TqlQ2mnVIYRj7/S3oCPoq7nNaJBFbtRxUOxJ/c6G7W3DBjr5KL0cbzqPS4ok7kLuJxrvG+IoQmyOiKIy0NFtkPO9ME2pJ5S5AyGz/UfTUt8Qia1MCb9dY4lpco9QNHyNm8Ac20aETkE3XrNxDY7DFDzv5RV0Lgb8X6N0iQvyBW0bmJ
 s700Fxre
 VjwWtFxL3z5oRzl2UcgmFUCK+zP4UZzhbWiR85iZK6PzSpPKp/AbAmzzzJ7yr3uUv7cQGIW7/efaZkL1M71HgGeW9By1tPZnc37qmLl1UsiTtG4tolzrxCSkGpJk3GO5nKNzW5SqMW6OXV9SH+WjNi3kGLmyzwEVSv3uvFf8AUHXjVBBuNxaEgtwVbqp3Jt7sGpqL9YaTZYHNqK21w06hKadrxbj60ZZN55fPkxkuU4zGQBgKHLiWO+icz3JY1cHAffC6bACH08PxEWn8cmbMugPDAVdAXqrrGnmudS2tr0HLJZxsazn3j9UZUcmff6pA0cGQl1cIKHg2PHOa0VuRy+P+IQaOUxpy6vooZuRcq1O2CPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 19:23, Gregory Price (Meta) wrote:
> Onlining the first block of a zone rebuilds every zonelist in place,
> shifting the slots after the new zone. An in-flight walk can use a
> zone it previously filtered. e.g.:
>   - a GFP_KERNEL request can land in ZONE_MOVABLE,
>   - a node not in the nodemask can have its zones selected.
> 
> With kprobes holding the walk across the online, I was able to get this
> zone/node misplacement to happen consistently across hotplug events.
> 
> The iterator approves a slot by its zone index and node, and the
> allocator then loads the zone pointer from the slot again:
> 
>   CPU 0                             CPU 1
>   first_zones_zonelist(nodemask {1})
>     slot 0 (NORMAL1) approved
>                                     online_pages()
>                                       build_all_zonelists()
>                                         [NORMAL1, NORMAL2, ...]
>                                         -> [MOVABLE1, NORMAL1, ...]
>   get_page_from_freelist()
>     zone = zonelist_zone(slot 0)    /* MOVABLE1 */

Since the zonelist_zone_valid() checks you're adding happen before the
"zone = zonelist_zone(slot 0)" part, I don't understand how they can be
helping here. Aren't we just reapproving slot 0 when CPU 1 can mess it up
between that reapproval and load? Am I missing something?

Furthermore, since we have the zonelist_update_seq anyway, wouldn't it be
better to use it to avoid these kinds of races rather than the more tricky
way of relying on what exact updates in what order can derail the allocator
side and trying to protect against those specifically?

> Every later step of the walk filters and loads the same way, so a slot
> approved for one node can also hold another node's zone by that time.
> 
> Recheck the loaded zone against highest_zoneidx and the nodemask in both
> allocator loops, and skip it on a mismatch. Hot-add only inserts zones,
> so the zone that was in a skipped slot is still ahead in the walk, and a
> walk that runs off the end meanwhile is retried by the zonelist seq-check.
> 
> The recheck adds about a dozen instructions per zone visited. The two
> fields it reads share a cacheline with zone->per_cpu_pageset, which the
> pcp allocation path loads anyway.
> 
> Fixes: c33d6c06f60f7 ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c7125f6693574..aa3cd44fdaa5b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3784,6 +3784,19 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
>  	return ALLOC_DEFAULT;
>  }
>  
> +/*
> + * The zonelist can be rebuilt in place while it is walked, so the iterator's
> + * filters may have passed a slot that now holds a different zone. Recheck the
> + * zone itself.
> + */
> +static inline bool zonelist_zone_valid(struct zone *zone,
> +				       const struct alloc_context *ac)
> +{
> +	if (zone_idx(zone) > ac->highest_zoneidx)
> +		return false;
> +	return !ac->nodemask || node_isset(zone_to_nid(zone), *ac->nodemask);
> +}
> +
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate
>   * a page.
> @@ -3812,6 +3825,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		struct page *page;
>  		unsigned long mark;
>  
> +		if (unlikely(!zonelist_zone_valid(zone, ac)))
> +			continue;
> +
>  		if (cpusets_enabled() &&
>  			(alloc_flags & ALLOC_CPUSET) &&
>  			!__cpuset_zone_allowed(zone, gfp_mask))
> @@ -5236,6 +5252,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
>  		unsigned long mark;
>  
> +		if (unlikely(!zonelist_zone_valid(zone, &ac)))
> +			continue;
> +
>  		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
>  		    !__cpuset_zone_allowed(zone, gfp)) {
>  			continue;


