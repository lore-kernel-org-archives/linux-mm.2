Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0582C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640B36B0093; Fri, 18 Sep 2026 08:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0A76B0095; Fri, 18 Sep 2026 08:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB996B0096; Fri, 18 Sep 2026 08:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16AF76B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:53:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C27BA067A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:53:55 +0000 (UTC)
X-FDA: 85226875230.12.B4FFC58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AB3F220004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:53:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B49Uh3Cd;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789736033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dbs08/A+XvCDpL5h4MU5xGiV5LRs9ka5cIBpR6cLUDY=;
	b=8BpCIbTNCivGu4oqHVk8tjzrJkFvE+U/tRHOtES4G1yvfn/Rc5EqqpsYBm4+NdRqDdH0tB
	Xf/rzTe+Rr5ZRdmko6ZMzV77Dc89O2eiKiXojpEl0KbJIHyS4pUXt70uQI+em9VaXU4LxI
	cytn0sT6+vo3G96l3m5bKcUVKp19YEA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B49Uh3Cd;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789736033;
	b=dK3ZT0hNH6h263DtmiP7aaLhzil4/qLO9Lgez9yurqYMbG6CqyhQddA0Cp7zTSmMJ3GQx3
	emhtbAkzIXywQ4N9RAkvC9Jqbw6YgkTusAFoNVp7U3O+SuwRrDzscdzIbzq4NQgLqShWBt
	GQzlZGpWg4V0wgxco7bgE2DlVNKx/74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8F97407DA;
	Fri, 18 Sep 2026 12:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345271F000FF;
	Fri, 18 Sep 2026 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789736032;
	bh=Dbs08/A+XvCDpL5h4MU5xGiV5LRs9ka5cIBpR6cLUDY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B49Uh3CdTwH2qKAns42Ip8iKqyCjPEdloHz0n+jRSN7+O1sIvy7f3CLHy1SjhOYGk
	 eIqIv8OJ2wVNUaG32CP6itIinea5R+yzRUbSJd9ls+bzpMbaeQ91FxYMMgZvnf+Zo8
	 3tGIa/xx+5oU1Wdxd8L66mnSsZ4zInQMcl82yjpWEwXcP73acZ0zglQ9TrZGYbi1kS
	 4ygVUXXKS2Wg+Rh78bKhCBxgSxfxV6wL987mcKbmiXROVD0u6iiS4KeDreELvMUtvV
	 Y8bibuk7UOMdfFlZ1OQvWSDSQR/mavrqbec14C9LkZKbwj9UpDzXWzOPgg1fvK9GEC
	 E1nuX99QFsDkA==
Message-ID: <41b46756-ed02-439c-ab72-e32a84fc7f17@kernel.org>
Date: Fri, 18 Sep 2026 14:53:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
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
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911001826.2109390-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tjczcoimwe1mfhcux9otkif1a1fjrjyk
X-Rspamd-Queue-Id: AB3F220004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789736033-625932
X-HE-Meta: U2FsdGVkX19g+YVD8hp4RLZdeeiyat7qM6nDgT1HmdBT3OEP4BUn4udoPuN6VyIZdhoY9T7wobHGXKcwbqVwkcTQ6+4u5jWOxSf2Nktk+PvX0OBo0/9olLyWk5HCVtkvlQmhvqwonndGGoXl9TRuTfdoCqRbxM6A1jt7NLDfc0xIsqgsN8n7Z6s8uMtjBV8+C4L2rxOn5dhBQaBO8/+l03gpLfDgfnyAUnluPfsjjna6u3FCQ84MaCIlGc6n+n3pVfzbQXg8yj6YbXM0u+i4dbIE/VTq8Sn0IMZBr9Bv1HSShh7Gh3bSE+KmhiMF6MRbYhEmwYOSTsXQYP+69F02GVrgB+YjTNpNh/ho5H8FYfJ2CIvYbfxSI9zVTuh4KlG6lL4kv5kej41JEq1Xi4dX8s3wpFKr9JjmtbaNbEgmlvUUWz6idCdilOQneyLsXquKMgxIGU5ioPkxSJpm9+NFpalsyZH7/bxl+jjc1KfV1uD/tpfJxg4w4oLhuH3/Sfv+EXfs/mFsHiduoAWeY+kuchCp8oYbHCkCXj76BdvD/WmV5cu7GhEK5pxF3m1NZgrqz/ayjmz+2M6lGNZyOuS2fwfLCod24wD4K9Qfcrg6cg84vXMa1CtVLyBVac0665yFubv2hyBbFY6v2kzhfGukn557eJaibB4fBpVy8fy2se7pFz5M+phh2/xrY3YkpJOG2fm+sLuTN5bhKJdHBiH/+L4/dbAWrfm8qN5aPJ1s+oZS8+TSZ7ezlUNZDvWgdhv+bWdPV634yJUbaremQw3sl6ZqQ2jvHtV3BcXhNOyoSd2FMLccXfJqkK4svIuB9qHZNa5gyFeb1HuB2voMJCjhtXChi+K108D+ev4U5UMb9iD7P9rF8xWLDL22VLWGXv9QlEJ6szkN6tpp8T3W586SDP6KF/G8QyEzi7CJgrADADyzF6BKtWwxytIoVNVVauvT2mS9tob2IAZQf99CDxf
 LptnssW0
 OpDvd3exKpPKY6j2voIrnlz7d8MMRGT42CC1Cfnv13EZmGDtpfKJB31kr79q2llfApZbSZgIxnmF1jxc4Lf/fEZgFju7aDPpcmTi39IKq6y/CJzC/HrvzsasXkwXO+hOb63fKSGYSluilx/5VCKzylZYUwDfNo1LMSpwcZhTtJZUqOMg9YaR2FHeeQSYv/KXjohKoVjkKLQk6pRO1tCvyXM9DkbvSy9am3En+LBW9PgrtunH0oqXlqG1GW4LNdle8/yrqjAWC7Kotxan0N3SYbC8TToWLxWKo5bWAyFmppyU5tES9pger//q+Jmrp73D0L+GHWgtKQ76HQ8Wxdb5/45YCqa37e+A/R4CxK8bpKywajmmiM1YLse1xzxRXUDNahABWaCRhSMNOjNBYn1OCwpa/fESl1eNLXlrCS6JwoRN7x1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 02:18, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> NUMA balancing rejects shared copy-on-write folios and executable
> file folios mapped by multiple processes to avoid placement bouncing.
> These checks also block promotion from slow memory.

Right. How to we know the direction of promotion vs. demotion, though?

> 
> Allow such folios to participate when moving from a slow tier to a fast
> tier. Keep the existing restrictions for ordinary placement.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 8 ++++++--
>  mm/migrate.c   | 6 ++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index a082ccfa09ec..19b599bc2dd1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -863,8 +863,12 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>  	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
>  		return false;
>  
> -	/* Also skip shared copy-on-write folios */
> -	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
> +	/*
> +	 * Shared copy-on-write folios are poor NUMA placement candidates, but
> +	 * a hot folio on a slow tier still needs a hint fault for promotion.
> +	 */
> +	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
> +	    !folio_use_access_time(folio))


While I understand a "!node_is_toptier(node)" to say "this is a slow tier", I am
clueless about the folio_use_access_time() check.

Confusing.

>  		return false;
>  
>  	/* Folios are pinned and can't be migrated */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a369d0c95c38..afd9c97d2389 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>  		/*
>  		 * Do not migrate file folios that are mapped in multiple
>  		 * processes with execute permissions as they are probably
> -		 * shared libraries.
> +		 * shared libraries, unless this is a promotion from a slow tier.
>  		 *
>  		 * See folio_maybe_mapped_shared() on possible imprecision
>  		 * when we cannot easily detect if a folio is shared.
>  		 */
> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +		if ((vma->vm_flags & VM_EXEC) &&
> +		    folio_maybe_mapped_shared(folio) &&
> +		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
>  			return -EACCES;

This screams for a readable helper function.

And my same comment for folio_use_access_time() applies, completely unclear how
that fits into the picture here.

-- 
Cheers,

David

