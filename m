Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173CEC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2C46B0088; Sun, 19 Jul 2026 23:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CABD6B008A; Sun, 19 Jul 2026 23:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3796B008C; Sun, 19 Jul 2026 23:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8AF6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:43:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3A901406C0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:43:52 +0000 (UTC)
X-FDA: 85007761104.13.92C1319
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id C08CF1C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:43:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kx6j5QYS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784519031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lEXVEdljxakidze8KbnFPa4EtaHgiEgN8dn9BC8AeE=;
	b=VTjADHTj0JvWpfsdDjnNRwJ9/DGfyMdWRWMN8A983B2UwP+8AX5lUOgsBYbUf/inPJ5Lxq
	ektkKFEQIHJOhu0fhTLkASPrtxojxjo2ptr150Yfw0OZN5Dxt/6VSmRV1vqDaoq9FVJG6C
	XPcwI5Im0aU0/WK/+pm13zfJPbMHIwQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kx6j5QYS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784519031;
	b=dALbOJ6lDGJMFzSLV19pOlC7Db0JfApwnGixtupC6OT+wwmIf2c/eSS2tQ1+f2/vbl4Bjr
	RbXh9B50W3ix6wwIYhcJnB9dtqbv4Zi+ohYlTRv9dRlbCkJnlK4ugohf3P3z16JlXMemVN
	OwLt6QGjz9ASie96m9F/9U6f2ouMsIo=
Date: Mon, 20 Jul 2026 11:43:08 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784519028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7lEXVEdljxakidze8KbnFPa4EtaHgiEgN8dn9BC8AeE=;
	b=Kx6j5QYSV/p0XFn5ZOQiiievVQthPII5IrKq3y7kWmKFVLly4nN0c870ivFxoqDuqY1AM3
	+CZwG5RGoSTVcKCi9T6Nx8a9BV29anl475Stuej91CBxydN3cNjLmw+rCVtEKa/AJ51DE5
	N9P/qr9jI2MOhFkjDAboZIJYP7579nA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH] mm/slub: prevent pfmemalloc objects from entering the
 barn
Message-ID: <al2Y2YrGJceZ8agI@fedora>
References: <20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C08CF1C0002
X-Stat-Signature: az967xwpen8f4bq7n5bh1ijeys4dzm9p
X-Rspam-User: 
X-HE-Tag: 1784519030-599944
X-HE-Meta: U2FsdGVkX19etuzOvY3XrgTKZeyhkBoOyZ6aDCcNL4FDh8T6gY63ZJqzx96QzvjJiz4V+BSe/UWX2vwyjtDymzq9WEVTisJb60V+lLh5IarfAm9wyXv6HSgdwh4BOCCSXyvc9lsllBt9A0kneKn2Nw/BxFtQ4NHEFCo1dz3UyfdrcqGdVI0/Wh3rUteybMxdlBkoHZSEQ5wrxL7UKBYhWxNI6UiSsux/kWkcigkzITfXOTuK9HNjxifsR1LOTDxpMrhYEetPhuDoVzv9L/0z8B9oaeWPRm+Y+EtpymmQDrk6bCWRR2v6k3bkLpn8R+VH3+gBHk7JguMUh773jxqZLTaJXjnkeLwYecdNdGTyA/DxKSjLnfx6R91hIU8oEADUlrqjNJI2YrqiLf3ttYr0mrg/x4i2GVFy43sr92XzAzOOs0YL/i2wWmQp0VhGYPaY18Bjhd0ck6tUMxGNOZKw8reyFZLsCcCUyDiFmaBTCa1+14RJpQG/ZFZJKCMxIWS2dTHj4Uu+17xlFP59auPZ3SS5Y2vigwsImgwe3wUIeAj1NebaUBhb21Md1eaqwTJS7RrCJSeABF9sfqIK4POsYDpGrDd+W3woP9cGR+nNI2k251AnoOCQBtOCNMOfI/NeyfP8Vt6QJ280Ps00/PlFVTd3whycAi2KdQnMY7wcG6oIf8TfhzZBB9scFJrkLVcK9j7bq1EN1SFQGxMEqakPGRmzZrM3X8wGUqRSviRO7t9WxGiikHUhupKQD8GkjmTA6SGdDcZpChgHgoDekDzqE276Gx836kx7/zCsQbkStXT+ZUzkoiFLnmMmCvbZx7SAR3txWaaUagvP1QRdiBDz0wl5rCCAzSF6UoqRzLREuCkFU0CGRHpKbOGot6CO8CsQ/p44U2VKnrTXfHTR7Y5o7O5a8u7zhDIbFkeQnNk48EUwqH3QQVTPTwDyhnF+mYArN2m4Phzu2gWVf79VwGj
 QbAb+WCM
 GfhrGZeunnMFsOmP7619n9jqbhtUpr6bRMyiXJJbC1vk7uVF22+g4JUDo89Zl2DijUTpBzr2Izs8/c3ZfVsS45w03teMzkS+Hi8+I3YpkAWeBhW2zeIhiXMNPOxbbdoZ2KZV+4BuvAdeTu4U55Awtun3f9ultRanWuIBvryAf1GRip6gTId+pGKMFaQ0DliYpjWHrXT81dbvoWasv7nuVCi0JLcJEicH17WFu+XCiOiLtIPhPzHMX3WA/S/P8kgKzF8hu2jjrk0ISYIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 19, 2026 at 11:37:01AM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> placing it in the barn. Without an explicit restriction, this refill may
> draw objects from pfmemalloc slabs and consume emergency reserves.
> 
> Add __GFP_NOMEMALLOC so returned sheaves are refilled only from normal
> memory. If that fails, flush and free the sheaf instead.
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 53b4976d3831..34f17ecbde87 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	 * simply flush and free it.
>  	 */
>  	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> -	    refill_sheaf(s, sheaf, gfp)) {
> +	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {

maybe we can add __GFP_NOWARN as this is just an refilling attempt?
refilling failure could be acceptable.

>  		sheaf_flush_unused(s, sheaf);
>  		free_empty_sheaf(s, sheaf);
>  		return;
> -- 
> 2.25.1

