Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868C8C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4A76B008C; Tue, 21 Jul 2026 03:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385086B0092; Tue, 21 Jul 2026 03:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250546B0093; Tue, 21 Jul 2026 03:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86E06B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:34:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 542BEC03D1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:34:08 +0000 (UTC)
X-FDA: 85011970176.19.78E0C71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4475180002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:34:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn5uZuhU;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784619246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3R7KAsu0U4XgVmb0eI5AipfVCOnfpS7yGck+kGJcP6c=;
	b=0Z3uNxcCs8qW+ErShGz0QoO6AW9mpr6aX87YCH7qh1DFBT05DrpTU1evbUG2B5tKpZ38fw
	3BJasohyjn5A1MOdocutw57UtLpr87FNjfSx4fdlSMzYV3ShyIZtwe1RMyDIVronuavzEh
	y2gf7eLxZMTxTlYGgDfoqd9cGZbFD+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784619246;
	b=j9ys+ZCk1NLnVNCj8SOOoO5hop+NDaqTxE+f+BQgIOX+WCgloMxIA7asID7Mg0zCFndrzz
	vB5QbCG/Q1o/sHR3z1sKcBj4z6zBHj2tqtq/jhH8uDErVkAjKwUY97jruuJcnAMMp5ryTN
	znD4/KtUHePTASwccv8npVFxhiqEzx8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn5uZuhU;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D90E460A97;
	Tue, 21 Jul 2026 07:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D681F000E9;
	Tue, 21 Jul 2026 07:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619245;
	bh=3R7KAsu0U4XgVmb0eI5AipfVCOnfpS7yGck+kGJcP6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gn5uZuhUpXzP9VigOESWPHGxXoZ5RZinv++4S35D7dxPQwaPB2DJAqvIz7cSnT7GA
	 4LgPXNxYrhRNw6829RNDPTllKQz+pCYGK3D4bqmtJWqNNobD+XSRmS2GT8nVB/fQJ+
	 SpPBFKeIKyfbfHSzTASJp1DxuRpYyp9Ln0XQh5cafRg9/SO7i2bLMSAPOPXuuGVDS7
	 2yj5q9Qamzuhz9BgwLuE90A9knKqMBMtwxivdKcqW0DP8RyAvaRIWJHzKm/4aMFewh
	 4kGyEqwghU9lKYEYw3ZYtRMgwHrAs+YoxZg2bfGxDGEKmiP3ZEjmmm7nOsQZPza84F
	 siW62n/ym6rSA==
Message-ID: <01ea11f8-65b4-4941-adf7-423c3f000292@kernel.org>
Date: Tue, 21 Jul 2026 09:34:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ozx589tmsbuq93wx67xrsjtykfbo8di
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4475180002
X-HE-Tag: 1784619246-325334
X-HE-Meta: U2FsdGVkX18VNL1inbKY/umPJg2rkLvLRBBKbNTbOYVsZ3RzgA77yy0jEQ2dGYWut58DIc901Q0X/qVh4LuNR2TLeUUb1LDQ0gN8HcfBmUupiYIEVp/jUXX1nM0t2nxZdSmBObWbtUPsi+s5mpEsNPGeemqjlpANcoiXOGEPEkwpzZrK9q/MhibNcKKbsk+5KbMoE4pTcpZC9XdPVpE4F/8GTvQqfsfjOW+nuPhMeSE/eDLs3Grxj633A4mSi9GPPls+J0Hzrzd5BE1rRJtD49fUhChHmDKGTSb8/0+SLZEBvjz93/teaZE85DsnmnRVe+acVU1nw8eCXItEeH69QtJqKK7CUqs3HTnpN26cw8cfn0A+WN0COhrv2FPcY/XwILeoUfHBRqkPKRtWi2TCG3RSCX1LKvOWFqlRuKGT9EjOoj78OGIWkj4XCHzQpvaR9Hqf09gYUBWObSODie4tkH8hyCyPIpm7mkhnzbpHLvCOYYePlSs8fb5VTbo2iLCM7ISJNWa1werrQYd5W3kiEyayWG6rvK2yy+QFvkhkYmhZK394qH2Fw5PkUkX8TGDIq8XI+QJVhNQ/HdgCGxIEbmutaWKCdGnEfRaM/C3472J25vO4qdjCay9J4/wnMulhodbz52CYzH/0S9Vf83cfCk2seVuv8yfu8nSXpBu7kWz0AwLXIuEQJ59t99LQDa3vIu2fn7fDNiPyv/YSh6ZW4ltKORM3rH8BVZQ1RlP4FGGyPb1w35oCq8hfIYwRA1AF43No6m/1cyihYsrHgijTp234INWKog757mvDTDwzDzDeC88bKs3jHY2/gOn+McUKLPve60qCQFx6/7iL8Ujs+gLw5sOxwkK2soEGANtYillN2dsbj/9jX52U/kxG3nX0tOI9YDmWmdS7LFU7SXnziVFCo35sX2jnAjP1399hD3nAA43Gkw7vKRaTYfPAH5cVy6vyflxB38un5/x0khF
 uWDfPH8S
 aI/0snLQhnz3B3eLP3p7sqKsqpu0Rj3XhwkSW7OdyPrEU3FIpJFe7NyPa7ZCcxCrn1TBC8QlboWCNrXyNzTGjs+gzdtOKMZu726R11vISyvHJBdGNnXuj468oWpN2EO8m/UCh43ChF6/v7XWgJXajz0RErrRaF3Uz9ozaFIL73kLeQPU7Ls5wUsJAttReBgfMe155ARdw7hU39gzuTjpiHwlX8QiBqBJaHsHBVs9XB21F2qcaqmbbIFK/N/a2Gj7n2ZJsKRMAsxFhjrxSy21zZUv5Fox3nue4A+m4TT5WeQX5mHd9y0uumGHP18+fk1ZjQ9FZRi4gMP/Dk5/H8V7GU8t+3JasbF0RvS5GjgJDGuA/VVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> placing it in the barn. Without an explicit restriction, this refill may
> draw objects from pfmemalloc slabs and consume emergency reserves.
> 
> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
> because this refill is a best-effort attempt and failure is acceptable.
> If the refill fails, flush and free the sheaf instead.
> 
> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")

Wonder if 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with
sheaves") is a better match. Until that commit we just didn't care, and it
seems like this is a case that commit missed?

> Cc: stable@vger.kernel.org
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
> Changes in v3:
> - Replace “normal memory” with the more precise “non-pfmemalloc slabs”,
>   and add Fixes: and Cc: stable@vger.kernel.org, as suggested by Harry.
> - Link to v2: https://lore.kernel.org/all/20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn/
> 
> Changes in v2:
> - Add __GFP_NOWARN as suggested by Hao.
> - Link to v1: https://lore.kernel.org/all/20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn/
> 
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 53b4976d3831..357b7522c817 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	 * simply flush and free it.
>  	 */
>  	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> -	    refill_sheaf(s, sheaf, gfp)) {
> +	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>  		sheaf_flush_unused(s, sheaf);
>  		free_empty_sheaf(s, sheaf);
>  		return;


