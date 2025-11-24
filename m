Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F40CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0546B0027; Mon, 24 Nov 2025 05:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A2C6B0029; Mon, 24 Nov 2025 05:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41A96B002A; Mon, 24 Nov 2025 05:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A09B6B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:42:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AB7F140287
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:42:00 +0000 (UTC)
X-FDA: 84145160400.03.F72924D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E27D14000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:41:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1a2FVZa;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763980918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11ncs05OiSiw0wtTjwKub+RouC1QsmoQDwbSED4/9GE=;
	b=IgwkGQRDH270QaIZrVns2ROhibm6zFgrK/vrr/A7ETRvhWYbIVlDjfaWNC7Ak2Dc1HTJ09
	NEZBQN8NaR7MNDJy06bIeWFPnLmoIs0M/ig6EOGTNtE/7v6c2NYlNh4haT8FZ/7yK89Emf
	Sc6f3BLsHy++M0JFN/fq4ly5KgMgalE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1a2FVZa;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763980918; a=rsa-sha256;
	cv=none;
	b=hzBRlKAd5QXlT7967YkCggIkIkPx/utLre9Syn9t9PMJkYrfP2OXtEeyZ3sRrGsTdgArxS
	kWKXv961WpPSRl/OlgT6JUA7b0CMN7kzOYgyW/ZTIG6Tb9blTVQv/cLb65wGIbUWUBduRR
	thM5gWhG3ULI7Mj3Xt99sLFuYIOQRPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5D1D6015E;
	Mon, 24 Nov 2025 10:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59079C4CEF1;
	Mon, 24 Nov 2025 10:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763980917;
	bh=EO7ufPh1vH3SRe9Uruu6w05UeWYS/8oZujKWXV+wUw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j1a2FVZaR/3FvkhClWt/458UA4QPePGf/qsYhFN6zX0RPzN60AMzud+mRQME82aJg
	 b8jtC2DafmoFfdRpI2Uw+gZb1KZXBPy5VCT+520F6nR+Ox4YpLDVOYKSfp3eSJqgBZ
	 yjIAYPZ08yJvqYOwbngqVPj7MzVcYyxU4pqD2HPvGtkCnJwfwc0V6rI/NEzVna1Hs1
	 NmmZXipWwr49ADt0a9wmw1L3Dj+d25icLtCh2BmwVvuOkhIPchqfzXYDzIv3Q7P7GP
	 T8GPXRtgB3gA0YxGyXBGzgN++WBuV48hbaNoFp2xsrhVEJy0i2w8RdzKGyM3Hnv6b5
	 7g7WSW0+GhhxA==
Message-ID: <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
Date: Mon, 24 Nov 2025 11:41:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122025529.1562592-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E27D14000D
X-Stat-Signature: wankkqk4shkharifwqdcwqyeze4znj67
X-Rspam-User: 
X-HE-Tag: 1763980918-943292
X-HE-Meta: U2FsdGVkX19k8J0B7imAELU8nAYHxivE7HnsEr/Jw20ZCsKh/yo930dnsoFhavZCqG0XHg5icRctb1WVMWoZywdQWStdPLNuGp3nLSH7yCDmzs/XBghNjODQfD+LDVscB1ftGlb1gJiZmDdYKJ3iyp+qa1mdWIFKLZ38m9Ajr1yvrh6iGCaKEUfFOthadXmrlOGUgTkssdijFvJChacbNC7Z6DPULYHi2QUgw9MbAYvgJMlCHzxYgc0ha1ggYH3Q7TGEFnctMCzoaqS9euYIilywjYMGvTHAXq35146TYmagjc6MGn02KT5usz0kp9EZZCz+AhnFUa6N+nbsfikZB/FLsKXUy5owg/AJAQimvLExwMPzuPLg40KIgfpLpmIw1Rjy22ko1OrfysmFoynctmaBz7kfIj8vRG2Yvt5eLOefoCTMAuWPcYofihAU29vgMJ2Y6yUVtLpowjK6qWJWUIeV+gRpBX5XKmFOWo/MO120I9wIYV6OLw3EQdQ8FanJTzwTRZCmS4vLOSu1mz1Y2Qax8CgeDuT9fUeiOAa2v2ZA/2CbS69Qxx2s7VB2JaMYOOFQSIgDfhuh4P3XrW4Lv/g/mD83uN2oI4Ix+z0hQoh1SENpVfYcC4hIprQNUuIoH+spRRyOsC1Y4mk+NI4FHCk1UZksEFFHiKYn9KmmlgDAmUcsNnsmdQuubRPAfUXeL8REPS6hmHqV/oDG+sRvwm8gjjL537ue6Duz3Gp0gO9l5d53IlPBkhJIkSvUP0T9w5CgggZFxy48yj66diQXi7/znBucTl9KyKQ0EkSjvDkfuUU6nC43JrnzvKIQvbAHAjjJXZIkIIR9tMccYHIfKiu+tsJYRAK/OArsrCqh1auprVpkdfaPqBiN39HotPOZAuGsuMoCme7gCH4MmDV/EQyGbeVFC1X2DNraK6gGVKUnSFcM1OAL4SdE7hakeGuyV2Z4z1FV0aX/5RBBtH1
 6CTjne2X
 mFrJ93d9CA8uU68D6CONc+wRiLJVLKZPd4OONQKmk8ByXbjJxUnBoST44uJb66Cza+vKD3nwlhRX2ZjdJh28Y9y0VjtPgbw2yzSD9dOlVEieOjoPap+MJ4z3lNDz5BuAyJxpyXZZo3+1uvmFekGjYZ1ltObRnAld8mTOp9GlShn8rSbnO5UY/mR24OzeUTlr6S4jAM8NKVA/MoZyeJZh9vMp/BSBwc0wPvKlJh+NdpOErd5BOzbumBRt/2j//cMR++i2a31D20saIOj6DFS1Ev4UIYq2/j9xQwO6znJiZDEXea6vqo/dUX7Y385a7N40oUFozMkAYQ5Tyj3MWFjvVNYRvRDUhnvaIV7thihGpmgVwLKSCC9+Lm0BmmSbvJChPZ0PgqSHmNj6/Wiyjvn3og8ZgFUgEp8oTV4ub5l1GpBSE/u6bMv7CD440FT2TVQE0ENfWmwc1TXt6CzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 03:55, Zi Yan wrote:
> can_split_folio() is just a refcount comparison, making sure only the
> split caller holds an extra pin. Open code it with
> folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
> used by folio_ref_freeze(), add folio_cache_references() to calculate it.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h |  1 -
>   mm/huge_memory.c        | 43 ++++++++++++++++-------------------------
>   mm/vmscan.c             |  3 ++-
>   3 files changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 97686fb46e30..1ecaeccf39c9 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,7 +369,6 @@ enum split_type {
>   	SPLIT_TYPE_NON_UNIFORM,
>   };
>   
> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>   int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   		unsigned int new_order);
>   int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c1f1055165dd..6c821c1c0ac3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>   	}
>   }
>   
> -/* Racy check whether the huge page can be split */
> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> -{
> -	int extra_pins;
> -
> -	/* Additional pins from page cache */
> -	if (folio_test_anon(folio))
> -		extra_pins = folio_test_swapcache(folio) ?
> -				folio_nr_pages(folio) : 0;
> -	else
> -		extra_pins = folio_nr_pages(folio);
> -	if (pextra_pins)
> -		*pextra_pins = extra_pins;
> -	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
> -					caller_pins;
> -}
> -
>   static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>   {
>   	for (; nr_pages; page++, nr_pages--)
> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>   	return 0;
>   }
>   
> +/* Number of folio references from the pagecache or the swapcache. */
> +static unsigned int folio_cache_references(const struct folio *folio)
> +{
> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
> +		return 0;
> +	return folio_nr_pages(folio);
> +}
> +
>   static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>   					     struct page *split_at, struct xa_state *xas,
>   					     struct address_space *mapping, bool do_lru,
>   					     struct list_head *list, enum split_type split_type,
> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
> +					     pgoff_t end, int *nr_shmem_dropped)
>   {
>   	struct folio *end_folio = folio_next(folio);
>   	struct folio *new_folio, *next;
>   	int old_order = folio_order(folio);
>   	int ret = 0;
>   	struct deferred_split *ds_queue;
> +	int extra_pins = folio_cache_references(folio);

Can we just inline the call do folio_cache_references() and get rid of extra_pins.
(which is a bad name either way)


if (folio_ref_freeze(folio, folio_cache_references(folio) + 1) {


BTW, now that we have this helper, I wonder if we should then also do for
clarification on the unfreeze path:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0acdc2f26ee0c..7cbcf61b7971d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3824,8 +3824,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
  
                         zone_device_private_split_cb(folio, new_folio);
  
-                       expected_refs = folio_expected_ref_count(new_folio) + 1;
-                       folio_ref_unfreeze(new_folio, expected_refs);
+                       folio_ref_unfreeze(new_folio, folio_cache_references(new_folio) + 1);
  
                         if (do_lru)
                                 lru_add_split_folio(folio, new_folio, lruvec, list);
@@ -3868,8 +3867,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
                  * Otherwise, a parallel folio_try_get() can grab @folio
                  * and its caller can see stale page cache entries.
                  */
-               expected_refs = folio_expected_ref_count(folio) + 1;
-               folio_ref_unfreeze(folio, expected_refs);
+               folio_ref_unfreeze(folio, folio_cache_references(folio) + 1);
  
                 if (do_lru)
                         unlock_page_lruvec(lruvec);


-- 
Cheers

David

