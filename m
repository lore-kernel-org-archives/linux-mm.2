Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DBACF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65036B0093; Tue, 18 Nov 2025 20:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15656B0098; Tue, 18 Nov 2025 20:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03DB6B0099; Tue, 18 Nov 2025 20:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8B4D6B0093
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:32:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56C8A1A0271
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:32:23 +0000 (UTC)
X-FDA: 84125631366.13.4B88A91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A015DA0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:32:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTLr6arQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763515941; a=rsa-sha256;
	cv=none;
	b=fXsSO0tlY4OYpNUZcrgRDIcePJ94ZuB9f1OcJtrq24/dr4FpeLRW6kwZMe7qdnR5frnXW7
	esCnNu0nqZeEU3KGu5VX4ioTopTjhuKQg6WAJ3Iqw8Nlr2LQxK5H+59e8nrLtk+VV7HqBH
	r0ItJxZ722ush5I3Rji+8vtRlsudWDQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTLr6arQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763515941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZrXv22yZG7sVPhByoDXK8OCLilh3g6vvb2HAZceF00=;
	b=JI4Sb3cKe4PUE052irCzHeRYwk3I3m0vRaTPURqYmG+2dI6LZzfXD8fYPdceeMlMYtbfLd
	aBFFQVyjWXxl65A6Qm+30SsHojB4YYzKHxABh/ubSsWFDxVNbR8zZu0WaVDAk06KjY3C53
	d+2/xzjX0rkQvieDgqDEOkOYEFMbWqQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E99040DCC;
	Wed, 19 Nov 2025 01:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09263C19423;
	Wed, 19 Nov 2025 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763515940;
	bh=g/GSHDcuXKB4Hww2s39FmtkTvNado/saKz5/DQTC3ug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WTLr6arQogzsOkCJPLHx8qeqiPps7HWjRidq2Z4GhS0z7VJoR7ihKZ6VfPIlJ4ygb
	 rnZVz6f/fEjS/LWwMW3d797NBEXc6xxJ3A4hxRB148xvDXpoT1QaBjggIM+xUSph7I
	 YcsOBy0QpExhTPDx6rkdGX73bTSgjJne89j7bCRlm73QIZUqAnQI9UJ2F7rymXh/qt
	 REfj/9GWvHjI6UeKYfYdQ/hD4EtKZwV4gSoC7VfnfxaPi2cJguZolP+obFMeMgfxdL
	 JRizWgguJV0WDCRm4gE4JQHA4+A+VlFR6DzOaFAi2vvHOSHRb8LWMxwGX4Yw6htybU
	 ByhPhw14D630w==
Date: Tue, 18 Nov 2025 17:32:16 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
 asml.silence@gmail.com, alexanderduyck@fb.com, kernel-team@meta.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mohsin.bashr@gmail.com, almasrymina@google.com, jdamato@fastly.com
Subject: Re: [RFC net-next] eth: fbnic: use ring->page_pool instead of
 page->pp in fbnic_clean_twq1()
Message-ID: <20251118173216.6b584dcb@kernel.org>
In-Reply-To: <20251119011146.27493-1-byungchul@sk.com>
References: <20251119011146.27493-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A015DA0005
X-Stat-Signature: 5arcfn8ew9aqmtu1byo8rt138c6bxu5k
X-HE-Tag: 1763515941-121167
X-HE-Meta: U2FsdGVkX19oHjDXgHZfEjx68d0PrT9TgagtPZz4SaMm4k6jzSNuduwHfdryh2vUScMs25jk2H0N47t7glV9xjZ68CiXMHQjhqA6Fe5XCF/TaX1E/M8a+wKmL2z9Il+oXxhbrNQ0lafOCOZQdvlU1Zv0hJ4K2rpWZXBxx3fKO1NrL4Pq+EB9bnELWu5GfNJawBCSJ6Ci5IPbIlrJ9tFpK2yLXyNj5IR8Ov+NS05d1QgqS647RfL8nu90hKpBX8dq6k9e2+4ZRRCZL75CkRykRdwiH3ncuUiX22gJBfwURHfr+DV4H620OOCQeuZDfs9Wm6DFOSg+kgZUeq9o00M56FSITKYI06zIaUGvhIUca2J9JXFwTas+EdQjaEul9nU0OFoer+Fljbqp91qQuTWIN5LGsd06hFywlZJSKQtar/7MKVmS6QPg09ePOff5FIgkpqp0D0cXMs9mJ7TmlZNFXxFNC0m0gB1dbHN/vrDvSH1ZPAMr4CrsPx+87N/BSsb0YF5xZe1WMfqVZ3Q+3318sDzAT6TXAzfZNdjRsPwTgBH4Ar/Lg57LuSwebtDKF3jly5nQZ8SY+BA4A1mAASDlTnyDvmKDDGWN8ItfV+qVLklA7q5+orqW5jtG/HNSxzxWvWw1p/u7aTTUjtd+pYu9O4LPuq8i4o7j15WEivgXOPqewdg3tibDPZkn8ul75sZW6FluVmHbQha9ExGBv7/h62m0HimrvN4PHlWHM/Qd6GTSfJHBTDNT/ixKp0hBG3xEbTYDnlWTG8I388jiOupfs7+j1xpUgT+1u0J+Kqj/0nM0VB+Bv6XP89u21NxbaJmNx649H9nvNFPffXTvVd05kvPD6nWty7fKEV6tK0TlBmIol136yhLBcfuCM2rMa039dHwz5S7yFL5FTKwDRebs1I5lbs/fcWnVDJGfPQ6JbUEhucdgaPfmoxLuPy416/cSJNZE9R9hEQkQxGmp93V
 E/e5EM4O
 QzpArh+Q86CgOYNBoNQT2cRnSoaiB1ijpitXM2Cs+fX7r4O/mnsKqO6cgvJTZ3CIsKPR2igUBnXVKVHeKd0o2Kt6SoZnHo/QttBbkEsS56+5mDXb4L4aRvnonFXJhD+0l8rQr9oeGpw2mErasGQAYg9/b7xVtmFkaMFHjCrvorUFCbPXcYVLQs2ltnzjxEWoZq4IQEc2FypTIEV9yrtPdPeViv4atiyREeasaYw07VTqZ1m2s6GsvaqVkrmZzJDz7qELZFPm6G+juv7PoyrJrAJgWV5sim2kUBLz7B36DBuZVx2iMi6vI13SIps+pBO/9xRiDH1uO13bTb73I9/4tAABfUt1pgSk5jwkR5h2lo5xLxPczJqo3Kh9GJ+MwbVcBf+lGeKqCXH8Ff1uLAr+PWhmbD7FS7Ovmq3IBh9RO5zXiL9CNFF3EYNh/6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 10:11:46 +0900 Byungchul Park wrote:
> With the planned removal of @pp from struct page, we should access the
> page pool pointer through other means.  Use @page_pool in struct
> fbnic_ring instead.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
> I should admit I'm not used to the following code.  So I'd like to ask
> how to alter page->pp to avoid accessing @pp through struct page
> directly.  Does the following change work?  Or can you suggest other
> ways to achieve it?

@ring in this context is the Tx ring, but it's the Rx ring that has the
page_pool pointer. Each Rx+Tx queue pair has 6 rings in total. You need
the sub0/sub1 ring of the Rx queue from which the page came here.

> diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> index b1e8ce89870f..95f158ba6fa2 100644
> --- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> +++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> @@ -653,7 +653,7 @@ static void fbnic_clean_twq1(struct fbnic_napi_vector *nv, bool pp_allow_direct,
>  				 FBNIC_TWD_TYPE_AL;
>  		total_bytes += FIELD_GET(FBNIC_TWD_LEN_MASK, twd);
>  
> -		page_pool_put_page(page->pp, page, -1, pp_allow_direct);
> +		page_pool_put_page(ring->page_pool, page, -1, pp_allow_direct);
>  next_desc:
>  		head++;
>  		head &= ring->size_mask;


