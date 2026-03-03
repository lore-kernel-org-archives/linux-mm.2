Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26CEEC047B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4B26B00B7; Tue,  3 Mar 2026 04:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC136B00B8; Tue,  3 Mar 2026 04:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9996B00B9; Tue,  3 Mar 2026 04:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8E36B00B7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:24:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 941E413A9DF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:24:01 +0000 (UTC)
X-FDA: 84504215082.01.19F5D39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEF91180003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:23:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6A+XVLc;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772529839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKhWq+Vg47a7Qiv1rxwgFevaIwLKiIbn8Uncz/IFrqo=;
	b=I4Cy/uG1YdhyKMpp07yzsci/Ivu3we81p2cOhGtbZvkIqXe3Aj3k7taZJyxvGnaa2Mo0q8
	uWlllhL6F8wFiBnvXVTx2lXgRdNRYx0bjmRTw00eiZDDevrvGha2btWUV5BvZ25tQd3XzF
	aDHg7uNkOBBvhdYmnyRJGGscjx2rQHM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6A+XVLc;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772529839; a=rsa-sha256;
	cv=none;
	b=RHo/hhKCJ0CSx5cYDyERGArxYCSlcCYQqexPWsDy6CMFborbc89pqBAnPZ2RnTnKioCdJP
	1zjvunJSgU0+Rw1yA2L3JZu5mhLpQcCGkD+dSGNH4CKX5GR4xrdMxK9IBn090xkEAiaGR+
	0nwYXmSHagHbAvX0vb/QxUGgKNvJCns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C98E243C12;
	Tue,  3 Mar 2026 09:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A19C116C6;
	Tue,  3 Mar 2026 09:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772529838;
	bh=T5SIuOMiWFmjtgV2QvoBtw5OpiYnIs1FtaXsK/C2OaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e6A+XVLcPNLMwESEyueodgvH20aogrinLt8IHP7JLiav1mjuv9iBK3j3H+gsaeGEA
	 TRHUPeZiKGnnckMPa7m53eDQEVXJEAKC7ZIZEmtxf4eHcQiGTQ69SeddnpJmBr2NSa
	 juD5lEYubD370CxevcqTNgL03R8fCaq1acShGgrgw2RlXByQYpFykeXFoejKIMotJc
	 hNWChV2ja9ceDUXUxsN26VijxnczwFfb9pD5NhfWbCCn4frwFMC7qOINrvTDtbEKim
	 0W5RWX9q4PQ8g0yQsx2uMKwC/hoH+7G73p2EwAghfx6hR+lVOE+fiSpbFXYuTU2WzF
	 63nghwL5iIpPQ==
Message-ID: <e30308d3-b70a-40f9-9c4a-b3a777bbe45a@kernel.org>
Date: Tue, 3 Mar 2026 10:23:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <jweiner@meta.com>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302195305.620713-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BEF91180003
X-Stat-Signature: gcfkpteakf5rcaahjsemu55ker5x9s3x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772529839-507146
X-HE-Meta: U2FsdGVkX190hWPdLOM45Lo9GNY8VxitCenkST8E7Aldlcmzw3LZl3i+TQVxS8yWDZjzNPrDRzOr6RabeWyflRvetEqS79HzNQTwaUZTdsncVYQJ/bYID0dEeYzgrmFI6GoL/uAnP1VAdrxy3nxigwgCjcbXzbyiFh0eFuzweIkqICxpXW/xzCayUKmtfWXKhs+AWu6tH3/rr8gXJ1SXqES2AVC1WzNoHUrTXXytyFA7fR3Wy8bhRlTD/d+W/m+SJcN9UlYIBs0/xLJ+pDrOUaMf67XJz+UgI95M+UcUp3aeBd9T++iR6xlYUgrlmwCv5CZsuUWwZDlT/vG4doLH10W/pBZpW6dapiCZpR5tUuuBLKkftfWR9/K6Xt+/giZhrFiOcECjboEweZ1fjpbA3uXrUeqCEZ8y/rjA/eQpd0JBt5/V1lBEZpThn0S3LgP3OQTbUk8k3ZlYpzyq2j8kLV7q0VLe8BWDUjBPGWsoo81t6jz2EvUH+Nw6P7D3Trvu6/21BMZMLGzCifE4QqkWVG9lHoQyADBjMV5yglvUu26aQqkxhR00N08vyfVdA7ZGRap6NgWY8w8P9wewiBLDd1zTeLZrJAVuTovmSCVo39mWyb8LOBHrsg3M2oEVnjwUtcsa3tBsTzYWeTjZ6doK3XFblHbE55vSSxNz2/dHGxY2wT8r3RV70pOKYdAqWghNtHuOXjgfRD2+/mVw/EnZD97AWMLMESP3hEAbgfnLXQ7B1z0doD0C6m59i3NyQRnBu+2jXGCLvakFFOow3g5OB/Q9fAzCl9qvCefpKUFVhLpjUIYf+bKwqCjiZOTljGW+PlarUSWgGdiaQKwxFeLqDZIdvy8qlQYE+VfNnhziGR+/u4AfI1gjURZQ7YzUtevbJXIMnvInyxyJZuL4nJRdym824y7sb4WH2g/cNmJJ6899oNVjR7DeyGhq9dqCtmdIepeEY9NAwYTTv5OOiX8
 9mFT9YIZ
 7qNFGjvZ5p8x9LwRKYy13TNbCZgLjAhy0uMJjrj3u6oxQnXK0U+udfO66H7JCA5MzKeJHTP/LCjJcj6Qw3FL0Nfl+QFrWDDlKXKh4zCoDGqKBE4d1CzLWPvboY5qmmbRsDMnlwk3OTsFZfNRW5jkRBktgRUF6xaFpw0BrKr/prV47h0AAZvZ+D4Wwf+HALTQDfzrTH3AWQ3MkJR7RtSfwp0U/i/rtkwvhCR9yQAOOivnlwaCttrGI/06DJTTI65NG/T/Ws8r5w2ryLENmwESe7sjs6Ktdgf3Tojjq7WithzTba/9zAaEKipbVfatO3czoIursR9VkruzyKbZfLIUEC2Xc7hhmTIToVBUx3daPnnQsSst2/PERHo7IC8gfU4eCYq4/z3qsl2DeSzAM63wXetYC7f8oMFBbHlzNNvtd9aSMTbITtV9MyGyur5d5CH62M3MI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 20:50, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Consolidate the local lock acquisition and the local stock
> lookup. This allows subsequent patches to use !!stock as an easy way
> to disambiguate the locked vs. contended cases through the callstack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

nit:

> ---
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 753d76e96cc6..a975ab3aee10 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3208,6 +3208,19 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  	obj_cgroup_put(objcg);
>  }
>  
> +static struct obj_stock_pcp *trylock_stock(void)
> +{
> +	if (local_trylock(&obj_stock.lock))
> +		return this_cpu_ptr(&obj_stock);
> +
> +	return NULL;
> +}
> +
> +static void unlock_stock(struct obj_stock_pcp *stock)
> +{
> +	local_unlock(&obj_stock.lock);
> +}

Could have added inline's there. The compiler heuristics can be sometimes
unpredictable.


