Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A8EC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6656B008A; Fri, 18 Sep 2026 16:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDD56B008C; Fri, 18 Sep 2026 16:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D44F6B0093; Fri, 18 Sep 2026 16:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5BE6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:57:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68A0B1A079B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:57:48 +0000 (UTC)
X-FDA: 85228094616.09.322D1C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0E1E1C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:57:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LiNGzVg9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LiNGzVg9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765066;
	b=WgJvg2ppeUzIeqDX1NAnNTgYcfA5RZm0iuoPc52vvaPDUEV/lWvRwHVBx6hetEx0w+DhRu
	mVbQgT1yROr1RNvqjyybtUHGB7Zp+pdO6WgyWW5Ie1xzZfUh7BCm8KJayg+7bq/PAz851z
	cl52tl4eySo7Gy+8npJf4qVb1EPV3mk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTvDbpHGwz41hI4tEXIao9b++DHImUq9L55LLHiycAs=;
	b=JcCtKi8SzKZaqbALsxjka52AhhHMD2Qg++FZz47zcaPqrC45skIK93RkY1+4BVTGGhrVuZ
	pSLR3lFoYknNK7yKNTLAenUJ334swdlHfQK7pPBFE2LIpX/w3dPiRFcQWTJjXEVJss5Goc
	vkWD5zHzM1RnTCKH6nbMTJxefcOubfs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03FE36053B;
	Fri, 18 Sep 2026 20:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA31F00898;
	Fri, 18 Sep 2026 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765065;
	bh=VTvDbpHGwz41hI4tEXIao9b++DHImUq9L55LLHiycAs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LiNGzVg9jugn7smtpY9auGemG6j19buqYhv3Jr/kXT7z21SCPrhtCwdZ9itQRtorJ
	 EzS5THerKZc54qlYXrtRYeoaQfsPGSCTyXsGqurpVZg+YtzB1MoOmiuT+m0fLFVOmY
	 G1lYG2NxFAIGphGDbg5vB+7WIdt0h4wA7MYmszFLuHRJ+nzy21QgDaTmBqqTe9MB6g
	 7jVWXOhjzZ9UJqmipXaCaFLBCBl649B1aiDygUVfDQIzJSl1vdu+7vyeNtBcOEi/J7
	 6GvOpUR9Puxl6EzHbJR96LhN/9/hF+T3Z1wF09S5uOMkGdpE1PpYeFYvBjTx+v7giZ
	 KkN2nF0vciFdg==
Message-ID: <be8a8cf1-32ce-4219-962b-c0ec47580afa@kernel.org>
Date: Fri, 18 Sep 2026 22:57:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] mm/huge_memory: move filemap management into the
 file split helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-11-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-11-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B0E1E1C0002
X-Stat-Signature: 6e14ryrht65etrjeooedfna9gz43dc6w
X-Rspamd-Server: rspam01
X-HE-Tag: 1789765066-526964
X-HE-Meta: U2FsdGVkX1+l2JQScEiZo/eG+ZuQk/Ys/qnyd5wiZfypXGS4proPtKDZ8cBP7PJ2smybGgXnxYoI2WX0SXpjFxzFFqspucoktcYNkXMd9rhRvXscU0YWbHIOIcH3SFEt6S4ntzBsB6rhi4DLGI6w2rc0DC9NUuxVxQPw3GM7Xsfej8jsllnyq/ET2yDjPePYjFErWY+gMQmEDX0arZVTcZnBXkqilzhMbW0Bw/Fq/s9KtdqEoZVole+ruhy+29LdU8k6wRBVzO9zAvr/qIbliw0E9ghGts5ScTjGWm7DmsY17uQcZqQwg3UeKvWghIxtue1f0aHjob5kQUn/L57MsxFj3qE2AJ8FlN/DvNPespnnwjLICx8SzlDS7OpkdHD4JB5gybC2o1OhMcgipdK845G8mb0Z3xYy5HoQLUFT0NAdm3SwlZ3vnfZ++4edNmilkhnVJvSj0jrmCqlsYzQMa5swXxAGwzjeyget2WkLoo+VF1h/7k0e6AbdPk7nBKsDu+QmlMS3Jppf/1DkLUdszMwsZ9g6aAe5SB+BuaQrAOHchiGaXA7zKNToL8/RCt6O/uX79F9+QhAtU49myQqcHje8EfcPczlKIZM+z7rgwB4mrexTMm1+5HOmhUNe+BOsjR16+3gB1mlb1+XSwpSbz2TCthVxV/mI0md6crEvzSQOmNSpcgBK/LsGQwOdrOCPJf/gFmiKfK/zOhyHgt00jBkfMgwnjCkizqGAEG99YzTQr3C/gRpIreAeN169vkLUuZjyN+eIqeiE+qqPM/y8Tp7rFhxBCqa+uoCMwOYgitBWIzpd8S5D1Cp5ZEkpI+RNxBQDMSgd5XpfjASygIrqUHoZRcB1OJzIHhwIBWU7ztdMsUX0bknXPnrICpzO8vNhH1nqTA7TZr6dp6tL3R7G+1k5Q5iar/D/2Ujan6JLfjMu3l79HZ0115twQKAsFxXGmZNkHAKsFGUjMDcuhsc
 RlWFsBkb
 bHsAokl9VfFiva42X29umx7C9LxD3toSx9oDlrAC0MuQuirIBaNF/JJvO5jZmMlCprhtS9hF4qQ95NCovkrwcTMd5cnJc0ghkPQtYG6pSpFgXzKY0E9/GM+WTvhCvKer4LkJjM6fKRkOEpyNSnoSzumRj3nw7YY1HYT4sQJ1sH3tptd7+v8ZzXd/ejTBJkErnB2t6oslO4DWhospab17q/BGmEx5MtnSFaT4wcgDwHfAQX3k+dVntQ8RNB12snQvHFbbfEhhRqyfa5QPvMymW5xl4AYJs0eHPiijVjWGoiCEiDI6omyT+zKT2ACyrLmN4octVBrYaBRMWfFvS2B25urOL+thbnEpfHMiLavC0wrNYrlJOLWyr2zUP/jFQfIywgnKE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only file split needs the filemap and xarray handling and related
> variables.  Move them out of __folio_split() into the file helper so
> the helper is self-contained, and simplify the parameters.
> 
> No functional change.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 102 ++++++++++++++++++++++++-------------------------------
>  1 file changed, 44 insertions(+), 58 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 859aefda7356..8fc1dd5b8354 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4107,16 +4107,42 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  
>  static int __folio_freeze_split_file(struct folio *folio,
>  		unsigned int new_order, struct page *split_at,
> -		struct xa_state *xas, struct address_space *mapping,
>  		bool do_lru, struct list_head *list,
>  		enum split_type split_type)
>  {
> +	struct address_space *mapping = folio->mapping;
> +	XA_STATE(xas, &mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
> +	unsigned int min_order;
>  	struct lruvec *lruvec;
>  	pgoff_t end;
> -	int ret;
> +	gfp_t gfp;
> +	int ret = 0;
> +
> +	min_order = mapping_min_folio_order(mapping);
> +	if (new_order < min_order)
> +		return -EINVAL;
> +
> +	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
> +	if (!filemap_release_folio(folio, gfp))
> +		return -EBUSY;
> +
> +	mapping_set_update(&xas, mapping);
> +
> +	if (split_type == SPLIT_TYPE_UNIFORM) {
> +		int old_order = folio_order(folio);

Can be const

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

