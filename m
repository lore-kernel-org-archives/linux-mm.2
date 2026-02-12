Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A06EE3697
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5A16B0089; Thu, 12 Feb 2026 10:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACB66B008A; Thu, 12 Feb 2026 10:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423276B008C; Thu, 12 Feb 2026 10:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD626B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:24:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 017641C0C7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:24:12 +0000 (UTC)
X-FDA: 84436175544.18.070DEF0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2BC3160002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:24:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lytg6Qp9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4C9R0cYy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lytg6Qp9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4C9R0cYy;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770909851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4SLcQ4z8GXHuyKxamRQrFsRBxtsMZ9MpcvRbYRiuiA=;
	b=NPIAI+fBDFT8botE3vHZBpuhsPQr41Sknsi82PDNHt02PaghYdXyMpPXcOv0xGHOAeqEd/
	QcmvRB+eJfoQraFRcljYtJdKAo+nObqK2vYRuLO3WWhrTfM/XRORZalcQGHcUizMKCMHcJ
	aZlbUj58ssoA1zB0z7obZFz5/cDUHSA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lytg6Qp9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4C9R0cYy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lytg6Qp9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4C9R0cYy;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770909851; a=rsa-sha256;
	cv=none;
	b=hH4Un8t5ipMkCU5AwwkNJMc7Z+DZwHi2o+5MUminQC4dtOPk1LZw9Tdf7KE2fxPg5oEnYO
	XoyXtg2xMLggBcAPdpxEZVktJI/K6p3ExjcFAZTFKSQ40rwks6QdqEksPeejjwlVuiygLv
	0vR5g76aqjEL4w5Ur/35wmxpgg7M3Ow=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20D905BDB6;
	Thu, 12 Feb 2026 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770909849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F4SLcQ4z8GXHuyKxamRQrFsRBxtsMZ9MpcvRbYRiuiA=;
	b=Lytg6Qp9fMZWWfA68K6rS0nZ9tB6WIjlKhzihmPwAsKyRLUNufE6+vXl258+/L/nuGNOZH
	78aldcGJAIFPKUG+7Uzj0Ta7yUYceS0fiVjxX08JE3G+X3v5v4TYJyB9HGfq1t0BZzeM7Z
	k029c8F0mBtir5mOsrgONpZSDT7CRx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770909849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F4SLcQ4z8GXHuyKxamRQrFsRBxtsMZ9MpcvRbYRiuiA=;
	b=4C9R0cYywZzIR65rDSkiadbU1IYj33vAQw5u6/iQ6GolOz2eyv2lEEopqBUzsY14vfU//u
	6xMMLyDPayt0OMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770909849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F4SLcQ4z8GXHuyKxamRQrFsRBxtsMZ9MpcvRbYRiuiA=;
	b=Lytg6Qp9fMZWWfA68K6rS0nZ9tB6WIjlKhzihmPwAsKyRLUNufE6+vXl258+/L/nuGNOZH
	78aldcGJAIFPKUG+7Uzj0Ta7yUYceS0fiVjxX08JE3G+X3v5v4TYJyB9HGfq1t0BZzeM7Z
	k029c8F0mBtir5mOsrgONpZSDT7CRx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770909849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F4SLcQ4z8GXHuyKxamRQrFsRBxtsMZ9MpcvRbYRiuiA=;
	b=4C9R0cYywZzIR65rDSkiadbU1IYj33vAQw5u6/iQ6GolOz2eyv2lEEopqBUzsY14vfU//u
	6xMMLyDPayt0OMDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9C533EA62;
	Thu, 12 Feb 2026 15:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fhAMLZjwjWkeMQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 12 Feb 2026 15:24:08 +0000
Message-ID: <96b63efb-551f-4dd5-b4a2-ac67da577431@suse.cz>
Date: Thu, 12 Feb 2026 16:24:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Content-Language: en-US
To: JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260212045109.255391-2-inwardvessel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2BC3160002
X-Stat-Signature: 1sqy39afoxrwo9j5rwp9bp64nnf8gotp
X-Rspam-User: 
X-HE-Tag: 1770909850-369903
X-HE-Meta: U2FsdGVkX186Eg1tyXszkUrKFk4G/zFtYo059Hl6a3FOCb3MZTscjmiT0bKN+ykprhVcuf4VDEJbEorGczJIg7hFR3BUDPNVVB4ULShyETphkUhpKu/TOA+cW/JbD2nvMdXQ2UMxbbt1Z4KQs5dsKEKpWNVb319yfhAaqBEQubWCM7lqmeNeSjmdqhiLfBloFSs2gUXckTIckCaU5q/uAKJuTHqYd+0EwmI3k1cXnqV3eJneovHXSb5aOMGlSrMDs3v1QO8H1CLbPfT9yG+fOnkFSzDkjztMffL9rDsIXfYEgy8XS7jhYy4qAGLBFysXng/TMP8ytKZtCnyVUxZnTSTjlpyHu4oZnAo7KKnOvs8BqzzGstOJsbeXGREEhXbB/ZCbhDeKQ1eM8ZViWSpKkJek2UhFfqKJP3OaGe9wpwODkeHy8T1ngafIhx3QYnV3FNecrsbFNvQbvFg5Gpv4lU/femKFzd2pSjfdEr/Wk9l+/nhPEB8n21+1DU/VQFgVUiX3hD09f0v+97rGWVaqzn9pixmo2wNsXxlMyGrO7Wcs+aNyg2j8lQs/LVqQODXRmgV8PVoXYSk4NluZiGJ2CgMkE9Tv9Pf8OJUOYC6pr+wCJ4q2wUvotVzsMSc0lxjv0GiIurFwM8i3vHO3L3OVDmZpUtGDOPfVuy79ucl7esLsg+5T2R5BdT5sZRtsozJ+BlDBMoL2zEBMVJWIkoAZyHiZm4XKmNsch5vW3qqpyM+3S6ze33SNlX5PgNHRbYpx49f2Wk9asUmvN0T6KDuFoROO5d77pWEEfQanYWByFOvCXRLOQleVnSDuLyuTPKHjVJeqAD4BuT39uIqSGchWYk6GXuKei1tQd35dzUyUQJN8cfgfqK9dKCYwggubJIDmZR8XeCGyCvgrDA2z3GKa978AqucaFObENw9Gst5YNTCopdszJGZruSCi9o9Ns4vWhJq6R/GZPT7lnd0nOks
 3El2Enug
 xxnFVS+mszd3uQj6a+DpGQs5isH3KDB9Ut+Qu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 05:51, JP Kobryn wrote:
> It would be useful to see a breakdown of allocations to understand which
> NUMA policies are driving them. For example, when investigating memory
> pressure, having policy-specific counts could show that allocations were
> bound to the affected node (via MPOL_BIND).
> 
> Add per-policy page allocation counters as new node stat items. These
> counters can provide correlation between a mempolicy and pressure on a
> given node.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

Are the numa_{hit,miss,etc.} counters insufficient? Could they be extended
in a way that would capture any missing important details? A counter per
policy type seems exhaustive, but then on one hand it might be not important
to distinguish beetween some of them, and on the other hand it doesn't track
the nodemask anyway.

> ---
>  include/linux/mmzone.h |  9 +++++++++
>  mm/mempolicy.c         | 30 ++++++++++++++++++++++++++++--
>  mm/vmstat.c            |  9 +++++++++
>  3 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index fc5d6c88d2f0..762609d5f0af 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -255,6 +255,15 @@ enum node_stat_item {
>  	PGDEMOTE_DIRECT,
>  	PGDEMOTE_KHUGEPAGED,
>  	PGDEMOTE_PROACTIVE,
> +#ifdef CONFIG_NUMA
> +	PGALLOC_MPOL_DEFAULT,
> +	PGALLOC_MPOL_PREFERRED,
> +	PGALLOC_MPOL_BIND,
> +	PGALLOC_MPOL_INTERLEAVE,
> +	PGALLOC_MPOL_LOCAL,
> +	PGALLOC_MPOL_PREFERRED_MANY,
> +	PGALLOC_MPOL_WEIGHTED_INTERLEAVE,
> +#endif
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..3c64784af761 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -217,6 +217,21 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
>  		new_iw[nid] /= iw_gcd;
>  }
>  
> +#define CHECK_MPOL_NODE_STAT_OFFSET(mpol) \
> +	BUILD_BUG_ON(PGALLOC_##mpol - mpol != PGALLOC_MPOL_DEFAULT)
> +
> +static enum node_stat_item mpol_node_stat(unsigned short mode)
> +{
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_PREFERRED);
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_BIND);
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_INTERLEAVE);
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_LOCAL);
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_PREFERRED_MANY);
> +	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_WEIGHTED_INTERLEAVE);
> +
> +	return PGALLOC_MPOL_DEFAULT + mode;
> +}
> +
>  int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>  {
>  	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
> @@ -2446,8 +2461,14 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  
>  	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
>  
> -	if (pol->mode == MPOL_PREFERRED_MANY)
> -		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +	if (pol->mode == MPOL_PREFERRED_MANY) {
> +		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +		if (page)
> +			__mod_node_page_state(page_pgdat(page),
> +					mpol_node_stat(MPOL_PREFERRED_MANY), 1 << order);
> +
> +		return page;
> +	}
>  
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> @@ -2472,6 +2493,9 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  			page = __alloc_frozen_pages_noprof(
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
>  				nid, NULL);
> +			if (page)
> +				__mod_node_page_state(page_pgdat(page),
> +						mpol_node_stat(pol->mode), 1 << order);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>  				return page;
>  			/*
> @@ -2484,6 +2508,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  	}
>  
>  	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +	if (page)
> +		__mod_node_page_state(page_pgdat(page), mpol_node_stat(pol->mode), 1 << order);
>  
>  	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
>  		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 65de88cdf40e..74e0ddde1e93 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1291,6 +1291,15 @@ const char * const vmstat_text[] = {
>  	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
>  	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
>  	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
> +#ifdef CONFIG_NUMA
> +	[I(PGALLOC_MPOL_DEFAULT)]		= "pgalloc_mpol_default",
> +	[I(PGALLOC_MPOL_PREFERRED)]		= "pgalloc_mpol_preferred",
> +	[I(PGALLOC_MPOL_BIND)]			= "pgalloc_mpol_bind",
> +	[I(PGALLOC_MPOL_INTERLEAVE)]		= "pgalloc_mpol_interleave",
> +	[I(PGALLOC_MPOL_LOCAL)]			= "pgalloc_mpol_local",
> +	[I(PGALLOC_MPOL_PREFERRED_MANY)]	= "pgalloc_mpol_preferred_many",
> +	[I(PGALLOC_MPOL_WEIGHTED_INTERLEAVE)]	= "pgalloc_mpol_weighted_interleave",
> +#endif
>  #ifdef CONFIG_HUGETLB_PAGE
>  	[I(NR_HUGETLB)]				= "nr_hugetlb",
>  #endif


