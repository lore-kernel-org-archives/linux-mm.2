Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF98C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398806B00AB; Wed,  1 Jul 2026 02:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370566B00AC; Wed,  1 Jul 2026 02:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238E26B00AD; Wed,  1 Jul 2026 02:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC9536B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:39:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A697166DF2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:39:07 +0000 (UTC)
X-FDA: 84939255534.30.54FD9B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E000640008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:39:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDgHPV32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782887945;
	b=TnS+H6piwoJH/fQ5etMUSQ+TUNPTUwOU6RjdZ7QNwI2fryVJvLtXtL5H6K6quBwddjZWpD
	9H2VLmMgkX5XilGXeLb6YVsiwAeUlMYi6y8xeT0WhZnbsbDrSe2ilycB+Cy+5YkenKlUoX
	bWhbPRFlREwnlBZaRZD2NBpYGAYzhP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782887945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvTLplorYjpSosfCkdCvJzwq/acoHPalJN2rlKGRoVI=;
	b=HnYruEY/EIxsRvfqeMvk5lWsdMPaL2rjhl6dx25etzp8SmHPfHimhTEkI2Yjt496oyCn6b
	ZR7c+l71tH/ow2KNc5zhWEidEHl1QVxZoQRaRWepHM2kLoNxdAHCVeEJx4Q6n7SrRt2XXV
	3wU4EvGcf6qkHkOOd3lnpzsm8bv023M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDgHPV32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B663600AB;
	Wed,  1 Jul 2026 06:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4333C1F000E9;
	Wed,  1 Jul 2026 06:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782887945;
	bh=BvTLplorYjpSosfCkdCvJzwq/acoHPalJN2rlKGRoVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bDgHPV32AfnOA8tw27tWvIXqOB1SK0Mw1obz6QAL91FB2/8WIiMsDeDPTFHflGYUO
	 Xxl+HpJeRej3CgZYBbGb16a82nK3zijlC81Owhxp5XPLUfPbPqQv+TXDnMpGPN7Rdg
	 acW+rs3XGOZ9cUEr//0lg7VzCTCiAE9zWoBZeBwHyl8LhZ7hFkC3CjGDKyMnzP0T6m
	 Nd8I44uarM0v19lVNo9c+B1+rDl4uJGAJnTA3P+soFHqiQig6NsUavR7C+sFNCadZ6
	 vdL01HrPpO7S7FdmiNm153lHhg1cITFA2OT7wtFGnbfd5pDQsu7mtowRMdCFXQgV39
	 pURQxKVwWgMpg==
Date: Wed, 1 Jul 2026 09:38:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
	osalvador@suse.de, akpm@linux-foundation.org,
	mgorman@techsingularity.net, hannes@cmpxchg.org, vbabka@kernel.org
Subject: Re: [PATCH] mm/mm_init: handle alloc_percpu failure in
 free_area_init_core_hotplug
Message-ID: <akS2AYLzOzlJ8tIO@kernel.org>
References: <20260630214039.2263562-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630214039.2263562-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E000640008
X-Stat-Signature: g4izjcb3q4hhnzjyohpycptznxrkptod
X-HE-Tag: 1782887945-915053
X-HE-Meta: U2FsdGVkX18WNMUbrySV2l4CoN2n4kP9d9lBhBI1DaPl61RFQW/FY3Vhhm51nConxIEbEUFGdFqOLYNFLyAww4/1FqdIun+OG7l5+cTZgeOHwiWcNlXihsBd1LTqz976KGR5KIvLc5VTrSOL5wME0V4v5XnZ3lEOHVxMQ+k4NNHUHc0uFwGHCZgilkHF0is98p/w4S+0gqAYmF2bOcloyrbz8/i0Ybd+m97j6lk5qOw7vOvRnQ3rzP7b7kblDydwadNB6TfBJvOYDbTJTYsZmdVJif6vxwHx6hY+4X84WAAcUK3ci1FpK5T3U7d6zLLhkAeQ4bK8eJaklKP3PNYtEzUrUVBB3VJC955z2PvqCqAV2qAdmfpIDGhtOdUcRGuzWM7Jodb+ab+Uhj1pNIkK8MOHP6SkKbD3Ajw/ifiGmyDF0vTPPhmdG3d6rkEOdF6aWE0a1cj2NeZhkW8IeKZCpdfhwc/44auo9LRXEiTWe1wcsJBa0D6eLx+ZzuFP/7A0MqBR+ghCoKp7ZCFaU2ipcF90lebOaSTCdm7k75nYBJR60wIWhzwQwFVycZnoN88B5ywiAr9a0Oe9kqZn41I4tfRbdLUmOrVWzwtri0+5EgmTceIBoYk2uxAngpOVBY0ZVD0jJLeAh5p5h1AX3VIeP9EON2oE9dc5wc4QnBlVerhFJeWEDftHFO0YNGVCVSw9XW6yqFfMiCspjo+hnEbdqXYdDSfTQPc0mGuVjX+oBsZU8/yU0ZQ681A2vkSQp1ikaf57urhQMW8g/5dRe+sIgJnFANjSiYBdRaLymLV2s/8pdTzmmHmWyNxvbbpEtMVRup9nOYxyRMzNFQadTD74+PEfV++QBkvuEpiFTME77RdofSDYGowFoCC1PFVNvMHe4kSqbqrIo5/Bk/rYEHO3EneUvQjzgI+k/zFpd40rHxWwpjPp0/12FqAxmYmRUCYudaFj2PgBFfmUdyfd5hJ
 JWaw8ddb
 7h5u5N0FkPxRA0uNneD9Rt/oPkcZUErwTbx4SjzUCwTfZeZaOgvXWL1habqYSpXDjl4SDpHuRmn00aDUY1q1VeM5QgdesWd94tZ0hh3CqenrcZ8r7geHXNyOVfmA682yor9QPTUiDi5Rxz+Zd59wwWUqmH+cTze9hFfUuY8Ozf5P1vFDSuzvKjAz1ktgF2d0HMvorkBnY0Wz17Th21M6Mx1vCKGh8jh6pCuReKY21p5frSo84yxGiC7zEsjKTNejNcz/VTU2/2OfpZO5mSobA1OubfNPdXkTwOs9FYGBvIAm00Tsp/H41TGh5hUFIEf8YhwoPURZWOAGJbu8Oh47FmjAVkU0GkzOS9iKwe3frgihNqZC/OkkykWJjsOroP6GFL1P6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:40:39PM -0400, Gregory Price wrote:
> We miss a failed allocation check for pgdat->per_cpu_nodestats, which
> results in a NULL deref when we offset into the per-cpu area.
> 
> Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing
> at boot_nodestats so a later online can retry the allocation.
> 
> hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
> already maps to -ENOMEM.
> 
> Assisted-by: Sashiko:unknown-model

I suppose it's rather 

Reported-by: Sashiko <sashiko-bot@kernel.org>

> Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/memory_hotplug.h |  2 +-
>  mm/memory_hotplug.c            |  3 ++-
>  mm/mm_init.c                   | 14 +++++++++++---
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7c9d66729c60..f04b915678db 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -289,7 +289,7 @@ static inline void __remove_memory(u64 start, u64 size) {}
>  /* Default online_type (MMOP_*) when new memory blocks are added. */
>  extern enum mmop mhp_get_default_online_type(void);
>  extern void mhp_set_default_online_type(enum mmop online_type);
> -extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
> +extern int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);

Nit: we are trying to get rid of 'extern's in the headers, even though it
makes the declarations inconsistent.
Can you please drop the extern since you anyway changing this?

>  extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory_resource(int nid, struct resource *resource,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..8b137328dcf0 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1263,7 +1263,8 @@ static pg_data_t *hotadd_init_pgdat(int nid)
>  	pgdat = NODE_DATA(nid);
>  
>  	/* init node's zones as empty zones, we don't have any present pages.*/
> -	free_area_init_core_hotplug(pgdat);
> +	if (free_area_init_core_hotplug(pgdat))
> +		return NULL;
>  
>  	/*
>  	 * The node we allocated has no zone fallback lists. For avoiding
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 306ea5c13f54..37fd64ce144d 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1536,7 +1536,7 @@ void __init set_pageblock_order(void)
>   * NOTE: this function is only called during memory hotplug
>   */
>  #ifdef CONFIG_MEMORY_HOTPLUG
> -void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
> +int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  {
>  	int nid = pgdat->node_id;
>  	enum zone_type z;
> @@ -1544,8 +1544,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  
>  	pgdat_init_internals(pgdat);
>  
> -	if (pgdat->per_cpu_nodestats == &boot_nodestats)
> -		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
> +		struct per_cpu_nodestat __percpu *p;
> +
> +		p = alloc_percpu(struct per_cpu_nodestat);
> +		if (!p)
> +			return -ENOMEM;
> +		pgdat->per_cpu_nodestats = p;
> +	}
>  
>  	/*
>  	 * Reset the nr_zones, order and highest_zoneidx before reuse.
> @@ -1583,6 +1589,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  		zone->present_pages = 0;
>  		zone_init_internals(zone, z, nid, 0);
>  	}
> +
> +	return 0;
>  }
>  #endif
>  
> -- 
> 2.53.0-Meta
> 

-- 
Sincerely yours,
Mike.

