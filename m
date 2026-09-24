Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91002C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7D26B0088; Thu, 24 Sep 2026 07:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B4E6B008A; Thu, 24 Sep 2026 07:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABC16B008C; Thu, 24 Sep 2026 07:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34AB26B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:59:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7603C026D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:59:32 +0000 (UTC)
X-FDA: 85248510984.14.1E22B50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1CC8140007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:59:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b553tbGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYbZw+ir6uobcOE1VSF37VlhISIRM2YlLsW83AoBJJo=;
	b=SYUVtWvZG+YJFOtm7OK1qpRgFZv/Tt0hgrSpbLc1EB9jEzicfmi/rJncIocUpxOg3RYP7u
	le3+hAbep/GKbEdbfjFtAxSu7XqH1/tsQzve1DB+43xKcAtPXTdLkstpStzWBoS9XzHIqn
	iMQof4826X6VSfgNmSe/IDzq6BFiFOg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b553tbGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251170;
	b=nuAj5FC2SoSUHRCVv4dA7p7wXIgJ+dgizUUOAocGMKJu3CMUH72hJG5NKtwjbFCDslPNdw
	6e5s5STl+9mw/pZKKY836hfmKXzwI30l7HL7b6rxgjX3wmk1xnSA1n+igJ3VzLpKLbJrGu
	fR5NYuKx64r585p1uFX1gJne/FyvNK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D3D0601FE;
	Thu, 24 Sep 2026 11:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E131F00893;
	Thu, 24 Sep 2026 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790251169;
	bh=eYbZw+ir6uobcOE1VSF37VlhISIRM2YlLsW83AoBJJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b553tbGmDz2Jw9XkJ0OT+1EdcJLLd1xe2ZQrvmCnRAvkOHHqa1VPRKhSphRq9kKgT
	 sh3Bmb0sRbHxO+iKdVUxoxhV5lkVt7Vg31zid1sKVYWKsNrD1B6G8/jcPJtQ3jA7rb
	 jVVJF/xQTvoePM0y8Zm1lu5Ja+UFQYpSD9b4LfB0VwUwkrSbAU8vvVMacZKthNTQ1v
	 VWIU1SdvduxYqXTwnA5G4k+dze/zEz6Tcc6mUIk5DZrQLZ111ViHyIDG/DaPYQGOFc
	 CiNf8Ho3CO8Vj2IA0ceBvvbr1WXx5hOlAE6xesG8PGgpjD0NdcpkHu/YN0d0hdT+3k
	 zo2sIkJZsfltg==
Message-ID: <f0cd5c54-deca-42e7-bc85-1838dfa917f3@kernel.org>
Date: Thu, 24 Sep 2026 13:59:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] mm: allow shared folios to be promoted to a fast
 tier
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1CC8140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: n9eqy4asspzxpyeymiwfd4cxafs354ha
X-HE-Tag: 1790251170-649675
X-HE-Meta: U2FsdGVkX1/BWSSBMiqjbT97PwTS+TfKRthsPvh2Sw+ZeuBjofTOS6t8/k7IeS3PVMeCpskFse/epRq41w1IbwGlkNqoQu9V0mcZ6CdL/+Xr7Btk/23Gx0Dm5lXMi5GvuUEmNlaQ4SoBgjDkxmX3XG5hC9IBmOg6e0UwgpFF5FmreYtLkluVtePm0lDrsdgKlD6FSlnFLvDrO3Iw4hOCKNYUFhVXp+Xg++ul5lB/zb529FPeaAr+RcB1CNxSOgHcYaLv7mEVMc7524IpCpHLO1Pue/+BQhePhdBj+S7nZKL+Hvp6jGgCsjigFwViSwAtNC0eZhR8KvoSDXxBieL9XU9FELlpfUn3bKP77LVL6qiP9U5IAquLFJEbxVsP6zuxUh3eXjzkceDKUL/dK4RamvA/IbjDQv5gY5BWSQC28IEBgoSCesiybpYx5NckLN2IzeANSr1K7jyw++HOEDGFB+86HvHxmy5QZbdHbJq2viCqZ5QPl15+qmA8zyEwWZXRKMGBnj7qxDQevdOtrgL+xNqXo6hSRkUKk+t/13UmkYq4+QxpgIAtvnPREXluCV5tQmUh5kQ9WJrcn1n6GAaEFB5dgoSWU3s0I5KiqWNrv3GsOfMa1jqipdSkqayGeq9ZTW7rF5IcKDnPelmXP1AV7Vcc3VVE5ihZKwULuYyEyaoD5PvSeB3/Tj31ymaKwEue4zBhZIhJh98VApfvM9A4OKu9P2zz3ZrA/Yy1QrriIlPMcn0XKz8oskQZyS6WG5WJjirxAVc8Oh+Cy/8vo3g0S1KD5ywsNsSUStsrlS5mlOaUAvNhs+n8g4oP3jcRw2RJxNFK1H+VxYBO6LzCbnkWE2W9uIrADzjM4QlmcBMQ7trJKVuEA2dGIX2G2oDccm0nry4fPfwk2gdyaW21t7u9ec2pbXxGzgTm4mDUq+4oqr8wBmb8jws4JCM2Kg/7xtl6oo1gfB3wsYcSzdfvIi7
 Hji/Gh2c
 2VdTC/W/j5uXuKfw1d8LNrWwHHP+JMk94Cm3z3UcUgKF1fACR/Rp1ZDzcnI6El3X9nghVuIuCk2Y35SGUYEfCx1nDCx3J6hC6YVsAkBtJ15AHeb5TwviVQHC5yWkzJDW5CVUHnRrSSfO4ZEz8/tb46q3OJpPeoF5jXew0lDV+sVdnyRUN9vc+XrHYm/83tAg6h/12Wrmu1gOFEQybsATmD3yy57VddigaPmkpzfJcjxwbowkclX7r6Us37ZKu/y2lBqllavYQGxEKziaYC+SzUJAbxDWny5UPq05bpf+NbRd5gB/MGOA3xBg41p/x0rIXmoPNprQy8QHishLFZ7hgdzPD6yuhfQdX03frR4Wo/cqiRmWpMzMGjQEs0kOYUuI7InBhn84I+DscaoE1JWyHeyAGQX1M7ceV0N5JPPX/ifS84NHqAPkLLcQVqihqYnKpnTa+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> NUMA balancing rejects shared copy-on-write folios and executable
> file folios mapped by multiple processes to avoid east-west
> migration bouncing. These checks break promotion from slow memory.

Makes sense. So in general we're happy to promote if there is no chance of
bouncing (as would happen with ordinary numa migration).

> 
> Allow such folios to participate when the folio being migrated is
> a low-tier folio and the destination is top-tier (south->north).
> This allows promotion, but prevents east-west or north->south
> migrations (north->south is handled by reclaim demotion).
> 
> Keep the existing restrictions for ordinary placement and for
> migrations that are not slow-to-top-tier promotions.
> 
> Rename folio_use_access_time() to folio_in_lowtier() so the source-tier
> condition is more obvious (timing is the mechanism, not the condition).
> The helper retains its existing behavior.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/r/DLHS4KFPQ86I.1J4LN3352RI71@nvidia.com
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

[...]

> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -53,16 +53,19 @@ static const struct bus_type memory_tier_subsys = {
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  /**
> - * folio_use_access_time - check if a folio reuses cpupid for page access time
> + * folio_in_lowtier - check if a folio is in a tiering-managed lower tier
>   * @folio: folio to check
>   *
>   * folio's _last_cpupid field is repurposed by memory tiering. In memory
>   * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
>   * record page access time.
>   *
> - * Return: the folio _last_cpupid is used to record page access time
> + * If memory tiering is disabled, then lowtier has no appreciable meaning,
> + * so we return false (the folio should not be migrated on this distinction).
> + *
> + * Return: true if memory tiering can promote the folio.

I wonder if a better name would just make the comment above (about memory
tiering) implicit and make more sense of the sysctl_numa_balancing_mode &
NUMA_BALANCING_MEMORY_TIERING) check.

	folio_promotable()

	folio_is_promotable()

	folio_numa_promotable()

etc.

because that seems to be what we really test with both things combined.

> +++ b/mm/mempolicy.c
> @@ -864,8 +864,13 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>  	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
>  		return false;
>  
> -	/* Also skip shared copy-on-write folios */
> -	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
> +	/*
> +	 * Shared copy-on-write folios are poor east-west placement candidates.
> +	 * When tiering is enabled, folio_in_lowtier() identifies a promotable
> +	 * folio on a low tier, which needs a hint fault for promotion.
> +	 */
> +	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
> +	    !folio_in_lowtier(folio))
>  		return false;
>  
>  	/* Folios are pinned and can't be migrated */
> @@ -891,7 +896,8 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>  	 */
>  	if (vma_is_single_threaded_private(vma) && nid == numa_node_id())
>  		return false;
> -	if (folio_use_access_time(folio))
> +
> +	if (folio_in_lowtier(folio))
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>  
>  	return true;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7bdcdb57652f8..6a08690cfe219 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2694,14 +2694,20 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>  
>  	if (folio_is_file_lru(folio)) {
>  		/*
> -		 * Do not migrate file folios that are mapped in multiple
> -		 * processes with execute permissions as they are probably
> -		 * shared libraries.
> +		 * Limit east-east migration of file folios mapped in
> +		 * multiple processes with execute permissions as they
> +		 * are probably shared libraries (limits bouncing).
> +		 *
> +		 * If this is a low-tier folio, only migrate if the target
> +		 * node is toptier (this allows south->north migration while
> +		 * disallowing east-west migration between slow tiers).
>  		 *
>  		 * See folio_maybe_mapped_shared() on possible imprecision
>  		 * when we cannot easily detect if a folio is shared.
>  		 */
> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +		if ((vma->vm_flags & VM_EXEC) &&
> +		    folio_maybe_mapped_shared(folio) &&
> +		    (!folio_in_lowtier(folio) || !node_is_toptier(node)))
>  			return -EACCES;
>  
>  		/*

Sashiko has some comment about anonymous shared COW folios. I think it has a
point, but didn't look too closely.

-- 
Cheers,

David

