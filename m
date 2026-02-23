Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16649EA4FD2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BC46B0005; Mon, 23 Feb 2026 10:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A086B0089; Mon, 23 Feb 2026 10:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BAB6B008A; Mon, 23 Feb 2026 10:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAA56B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:12:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84765C0BE6
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:12:55 +0000 (UTC)
X-FDA: 84476063910.05.B17098E
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8401DC000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMfnDH13;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771859573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztMTHoPevsynxwNBJLriX2EMDeNpsudFj4ZJFPjQr+o=;
	b=VXYmojXqUmqtsNoSMZtpQmD27hRMcXekhNc5kN08hO6Nng7t3uvHMHmIJGgn2o0CCAPuKj
	evsAO9K933Wyqlt2tpaYYSiEeyV1bANSWHtge/Z3fyKFCQVDjguzyzoxAk/grTQMrR5j/q
	LfToaB5f3QjXQNHf6P8zNhyDIsDmzrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771859573; a=rsa-sha256;
	cv=none;
	b=uc6aqvPzoleRDa5Z3oQ7pMHTzxYxy4N4SrIlqNASeHMra4X1+jNKdyqnJ7RphvB2lt7uno
	s8N3ie8TQA25o8hTCVrgmGq0Q37cGyjs5DB0Z+0ccdLhJMdXeKlpdjIBJkQRzb/8CeOsvn
	dp4nlHtueDoQw6tRQDk8+P4HYqpWZPs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMfnDH13;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59de66fda55so4989975e87.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771859572; x=1772464372; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ztMTHoPevsynxwNBJLriX2EMDeNpsudFj4ZJFPjQr+o=;
        b=QMfnDH13ulgWM63xEn3tMvHA+wf2Hk+COEem2NtPYiTfoxCjGOd9DHlFSrlJ7cXpFL
         IUIIyEFhJnnXMhho7+jwXV14mRBxHCI4pgLrSIhIIfGRTaaSN0WCW6mzL5lFNTnkNZhJ
         eu0Rv5PJlAzBQHvRPhrmklk19nI96+V7Hxg0E80dH743ZiSV5ARGGO8eOwrrf6SD6cZ5
         wAL7Ma2trCJuOFqRR+DizaCbrUOgzpeW0c1YPfhjatdq7E2VMC1HQuNQhmd7B0nj3nHD
         olI6d0Y5zEBxhxatlFX9IdkWaIP/r2r5QKWWMb32nxFpYzknrZneKmlmPAZn97J6nj18
         ww+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771859572; x=1772464372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztMTHoPevsynxwNBJLriX2EMDeNpsudFj4ZJFPjQr+o=;
        b=fouqznpNSAl54ncKpjx57cK4i6wXeVDs8vvLNZFJcRf+qqrUzLc+X/xp6FLdShMy7L
         Jb280TxeeQgrGglBmRmmeNQ72auQAbiErD+yK+zOIXJxTpPb+jTnmrPzcoq4ahtHmn8O
         /g0eTVWCsVKhMStE+L/buOceKScCpLeBAnGEPvHiDSfeU5FuvmqpbymcExmRxeI1krcY
         nafbdLIqlo20DQO7EqwgNSxvafv1pVhO2Yja4+WnJrnC5L/YEWZOxu0TN3XETJcLPzLm
         FL0Lg41TqBwOgbA+nE0CPd5BuBGcd5ejiqqUWyOVGS9cuGZqorXpLOLEX6a5FngcSGVS
         dV6A==
X-Forwarded-Encrypted: i=1; AJvYcCUBzmp9bDqhHvkRGoj2/4BuarBgYnuqE2AfrGt8REtFau+BaSqu6hag5bSZCrmKbOx7CHw+LOSCbA==@kvack.org
X-Gm-Message-State: AOJu0YyBD5Zh1k7Lxmi+6KhXsQ/jNftJKDrFjDBtMFsJqGV2rGHPf77L
	jFXKmpp1FJAoC9Zug4kntnP5ouDOCgzmPzeONeerPBukfoqkRQzcLQUy
X-Gm-Gg: AZuq6aKwqi+petmxUcbkpvLS6X2FncY6vqz415B7yYmuUGVQj4qOzUzV04rE9MIXiU1
	JsKCqcKXRVzNlWjR1OzoHDodmRnNErf8Sud3a6Hh+7FrNGnNo3WOtkIM+iqJXNlXE71bnFVDhSY
	raPgX7udueOkkO/q8uq18sqD0JXAPgbKJxuAYrE6P73o6IK/nsR+NOeBGOycUFYu1dQeJghbX/k
	ZPPWdxcrC+o0HUYqAoTLvobEoZm6ENI2xfC3RzPwAnscJbnxlF0/Waa6V6NyFkKD/wC54NZj/ah
	Y6odQ0vPuhzs89D8xC/pHeZBYE+mS6DncSz5DPeSEkxoLlmAPK+eiRcbV70KGLY1lvpSLOxvHl4
	lMqjXhtHsHBU2CwPNUQa3gBOIkRLhn4m75x3jsMGxchVcsMgs7TE6vvvqEbDtGuz4zre8RkVu5n
	SRV8EojFJRQxa7bZGZURsWbrRfI3jmRP5RhCxQt1a7JLEhA09z+Au0
X-Received: by 2002:a05:6512:3a96:b0:59d:e589:c973 with SMTP id 2adb3069b0e04-5a0ed9b038fmr2771294e87.48.1771859571444;
        Mon, 23 Feb 2026 07:12:51 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb458bcsm1610898e87.62.2026.02.23.07.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 07:12:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 23 Feb 2026 16:12:48 +0100
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: switch to native NR_VMALLOC vmstat
 counter
Message-ID: <aZxucOEcpJDzSBgg@pc636>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <20260220191035.3703800-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-2-hannes@cmpxchg.org>
X-Rspam-User: 
X-Stat-Signature: 8d4c43fzgtz1db8c6bueoc5nyr5eoo8q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8401DC000B
X-HE-Tag: 1771859573-240838
X-HE-Meta: U2FsdGVkX1/X6Zc8VLNAVkclWuZtzq3DvpH7fjBEoe4N+xCW2yExVq2bbkoMm2u4F2go43dLrcb8qeE7i+z4qwnS+tkTSh/XlJqav/IvKpCIk+Q3iwhXnIGpTrMbwvrRetT5AysMSWidVpl3KEdqKnoHMfcIjMYhGH3KI6/4NcueYa9j3x534TDKYllubfRNwZ7oU6hYktBcUxx0gAEvqv5vRXlHKYGuwhY1x5TWPVyOn0AgmlS8jwPamZu8LuC7m4VzMxKNHpyqSXJrGZ3Qq8abv1rzL+dhVtPuVNQ5G1iCkerSd/BwCiaWe+Z3UdPx+GQpSp+KO+h7pyqwYI5EK4q3Kd89aNtDvjWkW20hmkhG9U7PIJAhz3d/RPdpBJxv3GYq3r+GMlHE3T6ImJfTGHCv3Ikc6iRLeXx6Fg2TTdYsgFnvzgVpG2vx+xO6s1NbfwJwrgrvTVDD/vvUdAtOMbDiur/lzVC6zZ2TuaiMY1ZJFHNkEURy+phki/nqhoiCnD65aKL0lIPElCdxZZWBHl9C32kZijBsV3Th2eNVjlEqFlfbbQNgXfkG+qNRznQypviRmQzSuaWzDkbu720ktW2BroNR2IW0GSXc3mnYN/LlpREIaSSY4t8LWbsmKYJNdVoF/xSpmuFzMe3hPZf4qoYq4MAp67lBAZxLT4UTkWedl6INxQzIfH5wHOHz80SteJnLIrmGlONBhiaWnldZ1LQ2ESEIawAsb7tM8w5kriHPZTBQSvefNhLr7nj7IYnjEa8HaR/IjdR4GvB+G9CcLLvw3VJ+vb4GIpX6wfXJFk6lUUKNo+s68JFuDj4THsRu0NsUeE99UjpIY1EdwJiWgh+MHhwCt/AR7IPEdNpNq30/6jTyVSL/bzGsXnXHEj3j3O47jeh5TdbJeGHdmHLmF/8i4XaxAk3LQumFzzWjkfPbkK6VNaVNmC/8iMywkR5CfyiZ7ZRh5WjjsvI3BT6
 7hsp+Zvx
 9X+1g5hotYGuY3Y9uMLT8lhOQrZbrD0EI10YqRc7fnBtR5B5y9Y3DLlEGZhe/+qeikiNAF0POU4XoJnP2kXzAUUe9rlJz6o7sa6bholJZKdGW42dhbVL4NOuStF0Z5P0TmsvfsNEqnnQYrcF2Cc3ba2A0827VWuPgGBAotkRF0iQ4ey7Ni47gd4/tlQhILJ+9W087Edj5rYIjI8z6JgB82ndksiQaekJxguHMZnV8U4mSjn3Ct4y47W3RczlKkRVz/iux89zacEV2xX6isXiPTdxPxlHLoK4MZ0HHhD5pgzQpWN6+BF6AO7gdgxw66WOFTgfwHWiptF0JtR/rct2q4II2sfGr2czYA3LXqm0PUKY8B9GBeobBEGdJPGl7kwRotQQoKo7sb9PLD0/CgX456LkfYvrb7FNjRcmLueO27AI3M7ceqK39XKtA6PpKmApUzoGR+gZ+7LipcCN9iWwFexx2xYmpEHKpHJGIhwvqiymkznKZC7HK3O1uNYE4VwU4fEql/9d1QAQx6Q1nPv8GYGzF5hU49jIohaHXf2/a2pmCc4c5HpNrrWqTkBIELLeEjusDO71INHmWd6sA0TirPC6LTVAs5wrWl2KrtfrN61forUbfNRpmuSKb+kkhLSJ5kapZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:10:35PM -0500, Johannes Weiner wrote:
> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h |  1 -
>  mm/memcontrol.c            |  4 ++--
>  mm/vmalloc.c               | 16 ++++------------
>  3 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 67f154de10bc..c7cc4e50e59a 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -35,7 +35,6 @@ enum memcg_stat_item {
>  	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
>  	MEMCG_SOCK,
>  	MEMCG_PERCPU_B,
> -	MEMCG_VMALLOC,
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 129eed3ff5bb..fef5bdd887e0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -317,6 +317,7 @@ static const unsigned int memcg_node_stat_items[] = {
>  	NR_SHMEM_THPS,
>  	NR_FILE_THPS,
>  	NR_ANON_THPS,
> +	NR_VMALLOC,
>  	NR_KERNEL_STACK_KB,
>  	NR_PAGETABLE,
>  	NR_SECONDARY_PAGETABLE,
> @@ -339,7 +340,6 @@ static const unsigned int memcg_stat_items[] = {
>  	MEMCG_SWAP,
>  	MEMCG_SOCK,
>  	MEMCG_PERCPU_B,
> -	MEMCG_VMALLOC,
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> @@ -1359,7 +1359,7 @@ static const struct memory_stat memory_stats[] = {
>  	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
>  	{ "percpu",			MEMCG_PERCPU_B			},
>  	{ "sock",			MEMCG_SOCK			},
> -	{ "vmalloc",			MEMCG_VMALLOC			},
> +	{ "vmalloc",			NR_VMALLOC			},
>  	{ "shmem",			NR_SHMEM			},
>  #ifdef CONFIG_ZSWAP
>  	{ "zswap",			MEMCG_ZSWAP_B			},
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a49a46de9c4f..8773bc0c4734 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3446,9 +3446,6 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	/* All pages of vm should be charged to same memcg, so use first one. */
> -	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
> -		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
>  	for (i = 0; i < vm->nr_pages; i++) {
>  		struct page *page = vm->pages[i];
>  
> @@ -3458,7 +3455,7 @@ void vfree(const void *addr)
>  		 * can be freed as an array of order-0 allocations
>  		 */
>  		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			dec_node_page_state(page, NR_VMALLOC);
> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>  		__free_page(page);
>  		cond_resched();
>  	}
> @@ -3649,7 +3646,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			continue;
>  		}
>  
> -		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
> +		mod_lruvec_page_state(page, NR_VMALLOC, 1 << large_order);
>  
>  		split_page(page, large_order);
>  		for (i = 0; i < (1U << large_order); i++)
> @@ -3696,7 +3693,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							pages + nr_allocated);
>  
>  			for (i = nr_allocated; i < nr_allocated + nr; i++)
> -				inc_node_page_state(pages[i], NR_VMALLOC);
> +				mod_lruvec_page_state(pages[i], NR_VMALLOC, 1);
>  
>  			nr_allocated += nr;
>  
> @@ -3722,7 +3719,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		if (unlikely(!page))
>  			break;
>  
> -		mod_node_page_state(page, NR_VMALLOC, 1 << order);
> +		mod_lruvec_page_state(page, NR_VMALLOC, 1 << order);
>  
>  		/*
>  		 * High-order allocations must be able to be treated as
> @@ -3866,11 +3863,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  			vmalloc_gfp_adjust(gfp_mask, page_order), node,
>  			page_order, nr_small_pages, area->pages);
>  
> -	/* All pages of vm should be charged to same memcg, so use first one. */
> -	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
> -		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
> -				     area->nr_pages);
> -
>  	/*
>  	 * If not enough pages were obtained to accomplish an
>  	 * allocation request, free them via vfree() if any.
> -- 
> 2.53.0
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>


