Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E55C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371476B00B2; Wed,  1 Jul 2026 12:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3225B6B00B5; Wed,  1 Jul 2026 12:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3756B00B6; Wed,  1 Jul 2026 12:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62A06B00B2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:42:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DDF940450
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:42:21 +0000 (UTC)
X-FDA: 84940775682.02.62C6875
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 055101A000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:42:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gob2BKBl;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782924139;
	b=mW+6COCmV0feecPtZrkWp/6n/Jz1aCdyZQ4LwH/WwG7GBaaKuuVyqwvt/dgUiyh51l6hLG
	rj3Ra0XvnFS8rd5krRfUE+99v7U42UTbv0EuAjQBxF6+OtqLkr0wnfF4vnc0iv0Bg8UoA7
	RuFEL808xntnLMgHsuI1aWQfNHl5BaM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782924139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+2gpszS6w1yPKfdIUMLb1Oz1PqSPFzVoqNJzo8qoik=;
	b=3Hx0lHa1udsUY/YK+SsGNDM4idoGDuVrJER1/ujwQwNWCfNQRQt/iaCn6CP4ux39+ryVeE
	z4jgEq4KM+JdpjWe6j8IKMTsDZBuTpmYPPCqeVs9Ma1dWHjVz3SJmlDWqtKm4MBRyNfo0X
	AxajKjMfw3fwX6ptQmeGLRIvR3t5TGQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gob2BKBl;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a953f120-6e81-44ce-a542-ce42c1cff747@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782924136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+2gpszS6w1yPKfdIUMLb1Oz1PqSPFzVoqNJzo8qoik=;
	b=Gob2BKBl4xI1NuEjSX/JqK/ZTWRbrSC78wZVvwDeHm7rMYcEjgQX654mowJYjIDp4/2X7Y
	fFCksd0v4vcM9WNyEkD1WOxXaV37inPDU5Spax8knAo8OFESpem8NpvkG+c05nK1fd2ES+
	DJrmMEPCzsrhiRYGoE8G3U151/Sw1/I=
Date: Wed, 1 Jul 2026 09:41:08 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 02/16] mm/page_alloc: some renames to clarify
 alloc_flags scopes
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: idkz48ifeoyjxfg9f73sgjwanyndek4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 055101A000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782924138-676887
X-HE-Meta: U2FsdGVkX1+NijzZ97lJgwfx9FXa148ZmfIUUt/fYC+CwumUStnd2zNKTsUd+Vj5nPKkdgJaI3HHeGqtHGGZU5FYQnmVsYOfwZfz92Kqi/L2pN9yt/JGtGYVoD0SrmX/IoE1NHypx7e+H10UjH/W4S/P7BS+Ig3/ICv4vbhSKIzuilbPE4UBcY0whTPIpcu/dWKVtma7cbLsZTPVVQDklaJCNLzfTwaxt9+OxMtAXEucHvWF8NNX/tY7ercKpB31vrUzCcaFFI7Vi+MVJXi1xp3GT4gfM6l+7mn1RUQ4ms4zLbTc/8kS7biZw/+Szjn7/irtCrwp6lIJz0K3Gi7EQBS9WF1OAo6noSocF9FchKMd/tf6rOQDwKTUg5m3i/aIpGaVnjOar0Z10ZVFNdz0YZbVr5617Qdvr909wFkE1Lc3J4cQ2LFWQBGRhHIR4pmVB5Jq0QH61nFLgOZRoKYzlh5AGiJC7jlYjPwAe3CumX8ufU1rkq8Zfs9RYuntk9d2575E01SRh3CMS2600xsUmWd2eZaxLn4rQpjnpt42rYujbjn3/0COn/MBWLNRN1MZYOSA++61+/WZQj8xLKyOYsSlHtP5BzwPUIY5MwUH+5FrL6MnOTZQkjXP2sMVp1D4H3r8AidUWbBrOa8RXjEHyY+Q6+6UwrIP3pJn2HkRR+YxlOnxNNVv/ZgQtTpdSg/t1Cfz6DQXwrKluIh9LR/bbNQXe2V771CWHKmTkTNjlbv6UfkzBQ0ILDEob6YSQQfn9h5eHKXDAQFgxZZPdEYIl/pX3/2rbw0BOTX81CDgh9pBMefF+Fxe+NYGFrusJMd79rcwQ9SuJLguGTYcwwVA8YzLjgCf/nhZSjXikF7Wky4V/k+ctsGvGbduGlLDRrlUmWSjU1cxoCosGseljs01/hgUcQzmqGr04dWb7UXhQwjMHoJfzXuyIIRUqOaKjvQG40CpGJPCvJL1OY3jjgA
 9tQelf0Z
 JVYAZvEfZ8239BcK2bPvS8shmVna2W1i+s8EWQTR9qVughinGo4IArJH8ElT/uhGLDdthu7ZmYNv4+Lls0Y06qgnV0K7XbKNQ5VK2BiijjkY7Oju68lfY18AshoDWTWQRBAx7T3JZP8vNd6LKyjp/SIDqEvWVLZTOeq64YNXl+tmGaukNKiwhU8ZtbhUDuvuer7XU0v3r0duSAI2S/8Jp/jD6Q1OtWeI1rJhKSberTBmq2CrV3iuZkjwUenWi4tBy3Wk+fpLjvhIRfazf5EtPx5TfGK3tepqicS+b9RpWH0fkoivBvhCP32dsTJGQxGI2tT8GWRVEIa1+VCwxOKKqgVg5cWDPGOoWEfmIi1RO6Ayr94k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 6:11 AM, Brendan Jackman wrote:
> It's pretty confusing that:
> 
> - The slowpath and fastpath have a totally distinct set of alloc_flags.
> 
> - gfp_to_alloc_flags() sounds generic but it only influences the
>   slowpath.
> 
> Rename some variables to highlight which alloc_flags are
> fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
> slowpath-specific.
> 
> gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
> have perfectly harmless names, but to keep the naming consistent also
> rename those to the alloc_flags_*() pattern (which already exists for
> alloc_flags_nofragment()).
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 421271849f291..6010693861ec2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3774,8 +3774,8 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>  }
>  
>  /* Must be called after current_gfp_context() which can change gfp_mask */
> -static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
> -						  unsigned int alloc_flags)
> +static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
> +					   unsigned int alloc_flags)
>  {
>  #ifdef CONFIG_CMA
>  	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> @@ -4474,7 +4474,7 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
>  }
>  
>  static inline unsigned int
> -gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
> +alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
>  {
>  	unsigned int alloc_flags = 0;
[...]


Acked-by: JP Kobryn <jp.kobryn@linux.dev>

