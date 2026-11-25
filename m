Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26761606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PA4vCVY8
Received: by kanga.kvack.org (Postfix)
	id 01CB66B0993; Wed, 25 Nov 2026 05:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FEE6B0995; Wed, 25 Nov 2026 05:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25E36B0996; Wed, 25 Nov 2026 05:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A24336B0993
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:17:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1816A406A8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:17:01 +0000 (UTC)
X-FDA: 85473238242.07.09CFD76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C16E1180007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:16:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PA4vCVY8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601818;
	b=B2+Dy7HJcUF89LCvrA2FVkyiTjUnLZmdX1pbUPsoGd5rr+yNheXuMH4an+chV3DgYob2sy
	eW7R+aFqH7h0iuR7Xx3jZhM/YrPoDANy53JPbyafD7S753ORy6YhoeUbdcoFBEpB4FVF/k
	LRxK9NilEEyuEdeQ6wZCt0PofXOtax0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n8ZrqtxlZkHZpLWE48kD5XtJASweu6G+n13pUnSr/c=;
	b=rW/EuLg9WaheCsl8Y9dUzn13EKRADGtNhXX4OvJ+n8kCotWXsllHo7BHfwPtj/+enGWX/4
	KUnyvLeJwLl8DXEjpqnfvP0efTy4//4RyZqRdH3HBIxUkfWdBxHg1/ugb/v4iirAyeBsZ6
	WLHZ79OGg/SI/YjK/fsIoE4j4kuKpYo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PA4vCVY8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03994400B7;
	Wed, 25 Nov 2026 10:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123F11F000D1;
	Wed, 25 Nov 2026 10:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601816;
	bh=6n8ZrqtxlZkHZpLWE48kD5XtJASweu6G+n13pUnSr/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PA4vCVY8BiPA2XPSip0zFHGOhURNTa3VIBRn1zN5/U3irjDoM8OaTqdSiYVbpnbUb
	 QeTPWdYQGhRHUwDTiIUejzz4jz1QMGhweo5zTYaDfi+WZtqqNjI7KxlbNN2Kw+T1Jv
	 4hMbreJK9Fb6SIAIikCiaV9sSjRS4VP3E29i4X8YzdG2/smoWGIUG8RPBPTQ1pS+t2
	 NCk0y2EJWKC6wyQMyR267sll6zwHu/MVVnD2GBPR6x2Z410V0hkMf0wxI3LT9G3lQK
	 ackPlBbCZTa5PycOASqx4rzcpRZfJ056ZocGTo17KNbNqITDLHM8VSTHeSNsqSIlLd
	 nwFHnRs4/OJuQ==
Message-ID: <3d9d914a-4288-467d-8d25-4a47d62d23d8@kernel.org>
Date: Wed, 25 Nov 2026 11:16:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/18] mm/damon: convert to LRU refs based operations
 for MGLRU
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: C16E1180007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: m4qfo7gbkhynq6i9k9moaewykciog791
X-HE-Tag: 1795601817-278327
X-HE-Meta: U2FsdGVkX18TApAB7hNugAxMMMRKBf6uXQ6G0LWd4AkLo0YcZgYJLwF+Ndwt/QhyHuJAO/5yoEkq2N9LSIM1wZ6zN00srv2o9hnkTwZn0cwvWUbXLQs3ud2/74hYtMIprcPMcUlzDoEhWCbdL8kBXaw118sVHUNDNx3ZD2zsqrvt9rQa4iddx4n8AIGwPGmtjjAxYd8Dp7m91oyCR9u1dgcVroLFWeBB5qWN7sA/wUtFgIGihnE7lH27nljIz4jngF5O/aotVK3j/Mvp9TejCgHy8lwTuCaLdLTK1mgy30p2ecBD8r0y8+3ND/WNZ6vR+gaXmNna5BS3hes87fNH/Sn2gKyYZP7xo123KnqcKD+9190JyEpdEwX/B7rVSneGgNNkw9I2Tsu+dopAphbWPJZhtOQmYDXztT/DQEb+/39uhuBKd6L37X7aZYTI2Fd7NZ7W3GIib6pbaZNTMbH154hO8n5baXXtyntqvcIaF4XzuM8jP60DwVRjdRoMp5UA8UmSCaUEHXrM8Gl6m4Hf8GAMxHcd6vqqizZxbjPUwqxCoz1doxf6oUvQcWDjfDlMWe6Ofs9UKBonkgyF9zv2w/N1txpSm/w3aIJKhWKPnbZxqw7G+w/iNcoG5KUgwOqmqJUNBrrTazDgC7FezcbNStCs21XYJAhD1+ju40dRoG9yOEsrLahrLgmyj8tWLOFymS+2ya0aYMlyInjqA8dNGv6kczxwLZUh48Ryh6RJXVVUZ527yLTRt7X+BQI3+rUaJtRze0LZ/ay6tHX6EaSq7FZJvrHyMsxweyc9ldwFEasiyz5/31IZ3SzegPhDqCtkGBa6rgQKjq+hR4yYW+AgQj6fO+vgrBQoSWlNrtGyMUF3lGKrhmAO7cC4KpFEpy2OZH69ly7MWMqXHH2mxOS/N2MeyqNKPQ4rhzrcZOG2FMy0PEScHMWTWk6GnkvyoV+gm63qNpjqqpSH4pPIfqf
 CPdgyZR7
 o623MjYIXO7g//mafX5yaABpUlg/OWlQ2Jmj6QvdnZsQvLKpiPdgRLd1p+adcwwhNFOgyaPSu3TZOxTYhOpNxLfULO0g+0GYHu3CpYWh5yFBlHhbPgcjcpTMs1THKE3aU3UyVha6ykxHpK0TA4XdXw9472QusDYxFWKcD7/ANcQqoNAkVpXMa2wuVArIQunelZof/mOzClRTgJZ1YJYtoHP1S48wATM9jbJl/8WhU30QS4jEzjMefOdaLnvSrlHDtX1YEOUhWnO3BKLmH4RgpKZi+feNjonxlKFXPUjXP2MlGSOA4J7k/cn/sLV2Gg3B9/WFH1Zs2N/aNhRQp3g+Ov9tVWt816coW+cbRH77+sfexQQEyFqoXpzAMcl9WZ6oc8xceSb3WjGhHISzibjRjx57Viw8QePNdFenxLHd07YFO6nFRwZG3T5JtkDEcnMsJQsRI3se7aVXCx9zHmoKbPE+8LQOWwueYQ/cHExTH+BRxf1h8t05gn4o9uW70Ai1WWMmz+5JaeTHSW3U/fkASOTkVLd7ey0rVi8dUOZsEof8k+5GEp4qhrm5YxuSlFWECUs6ETHtH+jFEZ9LMQQ/3mP1boFhCkU+LrOPCGTTzySKfisDNIMhDAap+iMygzL0xt21jycUTArgvXoj9L2x0gUB236KbLDILLjIwDhxXPEOyhqtxwtTuh2lby/7YYXPqIItR9hg75utoNsrNERELiujQxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
> corrupts the folio's refs count. That flag is now
> bit 0 of the count (LRU_REFS_FLAGS).
> 
> Reset the count instead under MGLRU.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/damon/paddr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e89cb14ee17b..411e1d557ba3 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  		else
>  			*sz_filter_passed += folio_size(folio) / addr_unit;
>  
> -		folio_clear_referenced(folio);
> +		/* The region is cold, better drop the hotness info. */
> +		folio_clear_lru_refs(folio);
>  		folio_test_clear_young(folio);

I also wonder whether both operations here should be abstracted, such that MM
code doesn't have to worry about the details of reclaim handling.

-- 
Cheers,

David

