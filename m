Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B9AC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3746B007B; Mon, 10 Aug 2026 07:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4640D6B0096; Mon, 10 Aug 2026 07:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379376B0098; Mon, 10 Aug 2026 07:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171846B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:24:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD685A0307
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:24:46 +0000 (UTC)
X-FDA: 85085127372.14.6CF757A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2454E10000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:24:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGGCHlV4;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786361085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqy591bSdqJfZU1CUf17dSEwotSknUKpk2/rMLFaYV0=;
	b=hxrcLBAShmjzMhxP0kOYf4faOClVA7kVkM68yhDCb8yx1w/n4hwnLOjPggmRgNDuh9Jk0K
	E/F2A69M1QDzidPh9ZZrhM4Rz9pviDzk4AhhvKRO//spHacWGXP2iESXtgJRhtxpmPx+FG
	4isvvAAFTn+6izGOHAnD4OJbYmnlJNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786361085;
	b=p+tx3kzGIBsu96kvBPsnDJBggECyLt4i77WzfdrV77Vxzh7zvR4jRyIR2hyCAuf3QDCvO/
	dFuKWVfi4wEuEy/dkulzRgebHtn4j8Kh9L7E/2jkx+llw/WKF3ZoS5u1n596sQigit+gJ7
	r/lnjNwQDqde/ZvyU9xx4T36CqFPrDg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGGCHlV4;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF277600DA;
	Mon, 10 Aug 2026 11:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53291F000E9;
	Mon, 10 Aug 2026 11:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361084;
	bh=kqy591bSdqJfZU1CUf17dSEwotSknUKpk2/rMLFaYV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WGGCHlV48DTyVindebrMZ98u9y6jHtZgG1J/EhwrsMZe/DYstv3JrOq1iRBCKNzbR
	 OmQ2Wr2ClN+rGOG0H5ajhmhIfPI/37pPABDH9xX/AlwBHSJIkdcXOAZudNltniPWEj
	 nMqBlmfRwZFb+dVnG2aBeNE8V7yLyGx7DvCzIi28Nv9HLK73il4frNbe+0n5YzQ5Ml
	 +lXjN5zHzLw8JGXvHE3P156tFDZTNyTqCiIU9/pxDwE2ARBjOdvwHdxJUTz6H/HdOY
	 Wa/Cw2tz+RzngYoi9UpyqXKjUgjb7W1sAa90XtbIlxp4WyxpsaRpkOD15+ySWurx6Z
	 IQxi0yJPv4lHg==
Date: Mon, 10 Aug 2026 12:24:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/cma: remove stray newline from auto-generated CMA
 area name
Message-ID: <anm0qh6936hMmjgp@lucifer>
References: <20260810093215.91419-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093215.91419-1-hongfu.li@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 74wiumm5ugxysccw5bctokt5py4xzhy5
X-Rspamd-Queue-Id: 2454E10000B
X-HE-Tag: 1786361084-913011
X-HE-Meta: U2FsdGVkX19zwj7LGVnc1E3CKPxjoJKdYPNGSRvBO3de1PlF26zzhlwvd47kbKd0lAMJ3TYrpZuD3utsdJ6ICseDoLdaDaeFDAYzjq6gPYaq8EBnwzytYnful0S1M7A0mmgBJy07UlQJqZxOoKXPoOw395dJ6ZwSVjzjE1p6UdrJEPl1o8dozz5L5S8iusxkfWU6Y52uyCxLKgm4Zp3YrQ5uBII8IGYCX9jZv16Coq5e30S4SeN8XtqEZjEaUHR8CKKMLsEWQvWPZTw2fUKHHMwgUtvm9Y4tfSc+iu+QgI3j98V6ugOjz9I6/Er+cV1jsyrV8zZrSVVt8lTFMK1RKXAgULLwhSdTKfMVx+XZbsNjXdhrf/R2TYNhsMQUp0PSk92K2PPhmYGr/9gaRoT1AfTo19cRGhJgAqf4O5RX0vsibHVVG+DSbuaNLtyL9xocIpR+O/JDgXKY9TGHNbSxuIEXo0+AeXgABG8C7Se/iLkq8vCKK2g64urj3kt+vrKXFLqJsc4O6+pnlDlnugmxNMx8wRmJpPkdorD/S6rMapOY+sMetC5jTV5ECxF0jnYYEgg1q0sKNNe/LjgZ/ZUIyVmWZM0v/komqjjnJL4yGMKdgFCs85OS3Uupp2iT8k4NZmDGsLH9CM6aiXD5EEyln6RyZ9erdsviZdG/j5yKIu32Mz0S9sjMgXZcYtnsA81AJoGuAaHj9yZSjf5d/obP1BCSP40cN2uX8Wi4775zij/EtgYKMaAEDSXmDj63VjfvOgF7eG1mvwWKJ+TMAlCE+Tl15DQnd2dPNr3YsA0g/Y9Txp8CNEsZeUd22QFFEUE7JAtGSgdja8w3TW89XD/XID58snRe0m7m9GkIqhD1RdVOYnD39fuw/ijzETXr4F+zAbbC/R49E6lP1EAVG7pol88C9lcwSxnBTZJdwUV+AFet48o512kSqHWMJG0+SLWYh8kUqXzym/0SJfa25xe
 z5Q5+Yu0
 hMSmzJCaU3FHmk0yWGE+c2JTCznRcAiPUmW6J+BO794kcQ4MDqBm5OKORmJ9ZcfAFEpVpmezD0ikA54CpfOUhGyCKi5f1NJpKMWKI+JGIL5uTxylx9HEUxEh3btDAfwT5OYyfWgKsm21KRI5Gv6UC7C0lqP2RH0hYC0cEPpYJnZPIgntjIQKtVEpoxkrXkxlwgVmZosB9SW/qz7X3TsfD5yZVnk+NHvYlyV0UhQtj26VNh2KlOhesVKoN2OIfyjWTytkEuXrdomJUMW4BragkVp2zEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:32:15PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> When no name is supplied, cma_new_area() generates names with format
> "cma%d\n", introducing an unintended newline character ('\n') in the
> CMA name.
>
> Most CMA regions are created with explicit names, so this path is
> seldom hit. The newline only creates cosmetic noise in debug logs,
> traces and debugfs with no functional impact.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index a7929c758df1..a10ea37a261d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -242,7 +242,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	if (name)
>  		strscpy(cma->name, name);
>  	else
> -		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
> +		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);

Ha :) I think somebody typo'd this on muscle memory gained from printk :)

>
>  	cma->available_count = cma->count = size >> PAGE_SHIFT;
>  	cma->order_per_bit = order_per_bit;
> --
> 2.54.0
>

--
Cheers, Lorenzo

