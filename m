Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C9B1076386
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9DB6B0089; Wed,  1 Apr 2026 13:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA906B008C; Wed,  1 Apr 2026 13:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC04D6B0092; Wed,  1 Apr 2026 13:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C881D6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:14:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E036AFDAD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:14:31 +0000 (UTC)
X-FDA: 84610635942.16.2680F1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEA1340006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:14:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZBFII1S;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cto4sWJusGWBCK4PX3JhzRIsLBm/2XNz4jQ8FcKR964=;
	b=o+ovv5RwYZ1rZHmE05lGOuaFx8dqxJ4wyhXxzs0I9M8o72Gl9FKuPAOo02kGEW3DNcuG04
	xUPXbn5s4jbWyTxu66ZKVxxyUeU3sFb97BB5+4h5lCYVdHMGLJJqjy55HmH1XgLzn0YpCw
	dGMkpuol3mU6EnORd02+6rcfdFHbSHU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZBFII1S;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063669; a=rsa-sha256;
	cv=none;
	b=SslP53EXHwPDSXJMDSmtIROi1ySfhwScp0TVSkjHtaJfsqq+Z+Sv8HlI/D2HyHt77AZTQw
	li2jEPRWIQSCLCRLZYdnzT1sGKlvHTE37tYhppYfxijs4dzcIsk7fmziUTdQBrouuef1Mo
	dxvYOeHORAKQvLvpunPfNNyf6XCB51c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E18B26013E;
	Wed,  1 Apr 2026 17:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA983C4CEF7;
	Wed,  1 Apr 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063668;
	bh=EvI/mf/p7ahLxwtiTqriQDhtRh6IYTRjLpLevB/oOQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bZBFII1SMDyYkP1Kc6KML2r9asPZ9iCWEIY2JvnWYCtKmV6aVDxOpF85ZoFKVTf0E
	 DDy2SlIvLulZ6RVtRtWIfxBzKtFeqWnRHiw3iAv2peVV6GMI3i0qbSfBp5flJKqKF3
	 J8S82ZSX16VZD4USROgBhxOn4qVp6A3XE0aHCdISrT+jw2Jt9xUeltjdnt7yggEWYe
	 Nfhw/boLIhqTzYgJrr+HhLRqACxQr44ogX3M5z73vKSBs/5faWCkoqZxOn98egwOcp
	 ocnA0cYIO3TmUl1V4wKMtIoe0VGHRCibJlRgYKNmegJjMlLr/Qfgi0EIfm45gmHVc/
	 bUHKdaaL3VHUg==
Message-ID: <885b3c93-32e3-4488-a7a1-891f5ee55515@kernel.org>
Date: Wed, 1 Apr 2026 19:14:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: cleanup flag vars in
 alloc_pages_bulk_noprof()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 89qeuew8fpyzyj9dzjxsamsu799ow9uy
X-Rspamd-Queue-Id: AEA1340006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775063669-44687
X-HE-Meta: U2FsdGVkX1+hYgJJf0tvY2SO+WtEJEx5/sM+lO9xYDjEgUB0l3Y5/fwtnufkuZQeWLQNhI4AWk6CiEsImdCHAp/P03P5X4p7F+98bejqfpc0lC263wzBgxl9e/q83cK4ljSSBl1r27SFIcy+lzpXXAuSIZOOoUUU0vHiyTOkxBrIlEF11uF4HVUjYG2HEwU7VHjwUJHEN8g8Bh4Nu25XdFvEnKLZ25JgNEkKIs/QY9E6IyQ4OHJxFTS6Ghobo65yPEktq0xv2HYT1G89ksiT1jjw5R2EaHK6WwwUffMQsaNfsEdVRb71WERZfoYo0Ee/0Kt1mnsUMigJ933j3ywvfjMnEduFYsoxAGjpLw33NhA8R22ebfxxD6sC4/iR6Xo4xtAAfvm7udfxsV139NlBQBnb0U7azyMJ1unJwiwz1tBngfzi4LqrwgRPu9vzTnvpUTn9/AWrqjTAq3rqiYDJ8ym6NBnOs4NvEupFZ3YEBACx0O6DPYpM4LvI2Nl2bbtYbGs6/u7FIUbyrB8O9Cgpb3nA/HeUjcX7XRqLK5H7osxRgSgTIyGYoQVSooT+AuPEXiylZKtn/laDN7ZGSwjb8HBoZlQOT2PMEmOapS/OTZR3CQ0B+g6U/K1u7JKSYk0EjwEQxI1DBwhfzZrbnpxZUo7Wo3kpYnmwkiUkqO32XDusgrW4weWx2+90kbsAEOQmXSH5+r/C7EXNq4sme18HZmKA5JL51P2vaJisUGpjjZiX+ejV7hnK3APkffeLUOuUmYfhSQ7PVAS/n+mhvh/bHFDMi4jZm81CaQEWFRsPjOk/mDlh+/9STOPH/Qes3SU5yVYsL9OsmAKfY3yGnuv5hqmcIR4eOwuEGUcTO7chr+V/bdrxuWZr/HAHNDsO0UvAfzVdqEV7Y+C5q6CmcrKNBz8vWusZyOUV6aSoA78t+g6cjwR+ETS+OFyCLHtZINbzGqXEcBxC4DdcHYh4R+m
 1vAtvnbc
 kzUqFwBmFLcFIqg4trrrCPv3Mg10P2TF/JLDadN/B+ULogPA9ot5pJSZBSbZ//+31s3432TCitwhDgKd3Ia7ul4XCLOiYNRICLz6OHB5O5kwcNRYDlxAS2twEjMTjPbbdkhExxYChR7ImbCz7v5lzQH3VaIATzqVGHw2bklmABoRMzbYbwD4tzrw/6i/WsDS4cd+yYkofb6g/3F1m2d+1BOSfcrN+osDAGBfKa+x75o4IYMAx260nVdOszwrsUR2Ua6GqSppfGvdcNVjsrZSdjXSli4lQCjHMqsbW6/drqJWdww55S5tOKn+fnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 12:52, Brendan Jackman wrote:
> These two variables are redundant, squash them to align
> alloc_pages_bulk_noprof() with the style used in
> alloc_frozen_pages_nolock_noprof().
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 111b54df8a3cb..5e280ded6e7ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5051,7 +5051,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct per_cpu_pages *pcp;
>  	struct list_head *pcp_list;
>  	struct alloc_context ac;
> -	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
>  	int nr_populated = 0, nr_account = 0;
>  
> @@ -5092,10 +5091,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
>  	gfp &= gfp_allowed_mask;
> -	alloc_gfp = gfp;
> -	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
> +	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
>  		goto out;
> -	gfp = alloc_gfp;
>  
>  	/* Find an allowed local zone that meets the low watermark. */
>  	z = ac.preferred_zoneref;
> 
> ---
> base-commit: 57e5b07deacb0a9bd7b8c9b933ff72e902d4f06b
> change-id: 20260331-b4-prepare_alloc_pages-flags-5bb9a1e04e00
> 
> Best regards,


