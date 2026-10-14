Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC1ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35236B008C; Wed, 14 Oct 2026 11:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C576B0095; Wed, 14 Oct 2026 11:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49446B0098; Wed, 14 Oct 2026 11:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B74536B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:43:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12C411205FA
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:43:02 +0000 (UTC)
X-FDA: 85321650204.18.C559696
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 738944000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:43:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrjPYeeo;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5flC3L20m+iLt4xEeRpaLTdVCyzEflv5E4h1ZeBXs4=;
	b=ZvZSgYPXPOF4I5WmQmkuhZrRu8P589WVvopwnPPWQVRCaTUDuO/H3RRb6QkajodtjcCPX7
	m4rrDNkPiGZ/4u0iZM2hHSkf88kp/PHBNMVUwpit83JR9OpnRxA3i9u7xDV8uWevasnQ0e
	RRmt3X0u8AOR1t3VAyN+15JOAovBvko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992580;
	b=NoF07zylUFlU5FoTbAn2bNhT1l/N/eWENiEz1amib/55NyeGH94PZTcj35/9AtroRgGXxt
	J72fr1CAG3qICZqgsAQyJIB5DUANurahmlRPUKAHSsohW9HxS+EzQys4ZP6BqUicJ73ix+
	2xA+KK2Ejqb4fZg23jdGQlpmOxus02Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrjPYeeo;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBA5B60229;
	Wed, 14 Oct 2026 15:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191461F000C4;
	Wed, 14 Oct 2026 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992579;
	bh=x5flC3L20m+iLt4xEeRpaLTdVCyzEflv5E4h1ZeBXs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YrjPYeeoYntaT08ARzU9b0Pbs4033S8tl+zqqJfkVR9SmHq6tep9wn/bN+e8dmId4
	 j/Ub7bQiOEsOq1Vk4gYOQbq7Xdm14IoxOCxQAzKFGgHieHy2nKx1VjkWfjC6wS4u7+
	 JrIm4p/VrMHAOPVk6VA8Ypz9nsbNWdPrVA8DjRUmKNrtubtDOfOmthw/QHlWnc9Jgk
	 P/xclEupRT/t60X7JZasdjWrginJzHVLppkwQ4J7IMO2oh30MCgulPbOS3WK3+lBuy
	 inE4EgVlTw5ebQJU/dAR0cCIGxpwceXM94z9C6nm4DfB8wuPbaaHkro0XHwNv8qsKQ
	 zR4fp5qBo5bvA==
Date: Wed, 14 Oct 2026 15:42:57 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
Message-ID: <as-izeIj5bP01bna@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 738944000A
X-Stat-Signature: jzabiqpatsxgjmb8wni4bnbi5ebqus87
X-HE-Tag: 1791992580-789814
X-HE-Meta: U2FsdGVkX1+nwtXcZAHVlE6DfL4sG4InWU850eQYeWMwKt4sqda8V4amyhwzwo2AGZZKyGrnpbWSmgaliUwpAJdefBH8ZHg0C61MFuYAGgc0uVdiULa9eMK+EQOeAkY+cE9Mh3aT0+B4/UGVdokAJcmu6Od5Cy1F0ou+d0vtvId9JRh3Q8d6yxQrO4ds0nVuGmPGweDf4A34LMxKz3+5wYYbDU9qqHMHFyw945+TGlFsCn7ZC0Oo1c1xPyhxQuqV3nrhuYsa3wpI9c9PftkkGQZfum7Lo4XBw9/24rKNAj/l2LDHQtAaxKE5A3aF8jHJa7D/upfGMZSb5lTrgXfG/iF+LhEiiRLj63LF9NHdIF3UIPnGdxceXjaFamIGw2y6UHGqYZXAHGG4MTCht1K90e4tSJvGYvYnzSJGia9g8aKeriWnF4JN/ZUR0ParZsHN3nAtgrdiZf+BZn+VGYYrndBs11FJ4PiOqNgYa8Ytgj+F/WyONxTc4uDwck1I1IFpt9DlY6DdSWF3jR5LZLRZR7fnYY6cABUff6IqCfbN9Kjr11rlBx7RzUxxPlFVQK25HE0yCySfpi54MZQO2r2cu/duoMrFGl4Om3s9Y2dBulubrI9PkF5jv4paoLHDe4pRzRZDha3X9PxRPnxnt7BxbIKy65c24lx+99luncOS0/amI/gKLrwMhXzC9PS8+2ZzllMvhH5zQrULXLmP8qTiPcpJk5jp7LNlqSZD2l6mdpKYwFnnXPeEAB+EAYDf4riQOS0nV9IfEX/twNgjQb5qnaP9xLcY/ZDHTjafN6r+ZYt6SSO9HPmmITrLGVjYdXtn+0P+9lQprJ1rX61OWn34EN6n8LvUnSvdOO/j7alTtPTYgwUehn9ykUjntc5siUF9kNAh28W5MHmzshyvB+hELoHyOb6jIhjQ8Erv8RLh43UUzDUVM3J1R7YMNyfHqr3rpHs6whjxkNDNYvDmz4U
 apwbHCII
 gGwTAXccz2SheaZMsMJUt5aCPHCLTrnfd4shE4YpmZrpV3HJtgD8W6MPdctWHeiqmLYLPqw6srBlHyC1VdVUTFdRH8e9HXVUfNJjnbw0wWBo9WI0h3hHu0urN45FV0tabm4XsDykbXfVHtSgONekj7grfx87K42Kb1ck3WsTKcnQK6MfIzP1aAUG13Nx3PUinvd+ZBlBcAm+yX5JryyBXeGbyLWqG82a0XeLrJomEWufhJLpH6crSSU8NF24JdhkiXtmfIeX+Nx3B3xUPx5TYLW3Zl924wUOCywYww/Vgp+g8j+ZX5cSMiHh3KrPRZLT51ktkktHeAe5HNCK99nIVkc3yroq8udK5GV+LV1PF78IIxXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> Place and align the members of struct zswap_pool and struct zswap_entry
> such that members used together in compress/decompress hot paths are
> able to share the same cacheline. Minimize holes within these structs
> while doing so.
> 
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> ---
>  mm/zswap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8ae67fd10522..ade84ac4076e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
>  struct zswap_pool {
>  	struct zs_pool *zs_pool;
>  	struct crypto_acomp_ctx __percpu *acomp_ctx;
> -	u8 compr_batch_size;
>  	struct percpu_ref ref;
> -	struct rcu_work release_rwork;
> -	struct hlist_node node;
>  	u8 idx;
> +	u8 compr_batch_size;
> +	struct hlist_node node;
> +	struct rcu_work release_rwork;

compr_batch_size is added by this series, why not just add it before idx
to begin with?

>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>  
> @@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
>   * nid - NUMA node id of the page for which this is the zswap entry.
> - * pool_idx - id of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> + * pool_idx - id of the zswap_pool that the entry's data is in.
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> @@ -214,10 +214,10 @@ struct zswap_entry {
>  		bool referenced:1;
>  	};
>  	int nid;
> -	u8 pool_idx;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
>  	struct list_head lru;
> +	u8 pool_idx;

As mentioned previously, this needs to be packed with the length.

>  };
>  
>  /*
> -- 
> 2.39.5
> 

