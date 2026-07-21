Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE55AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6DA6B0096; Tue, 21 Jul 2026 04:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50B66B0098; Tue, 21 Jul 2026 04:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917FF6B0099; Tue, 21 Jul 2026 04:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C38D6B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:06:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2033A0429
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:06:23 +0000 (UTC)
X-FDA: 85012051446.17.503C9E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E93C140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:06:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiSd8pDU;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621182;
	b=OdBhWifWVbrYZwXEh8zYXETw83MRdORNoCastLS4n4JCZkTEm5PdpgnmKtadfabksGZu2L
	nUG/sN53c3xqiE97edpusDYDvNY/VbbfutRsVxL2zPG5wsDZfWJvBMfJSAOxb8rNHBcN5X
	nWwoP3QB122GfFQXSSpBKmlCqGfKrDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiSd8pDU;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROLOrfPqMTfQb393OeJq2htXFD07Htbn862T+F3MXnE=;
	b=ioNA1QRNFgldzWdq/e7C7jgklOn5RihCKMVaJQrL+ljdTtqU6YpfNh8LXMoIoZP2XgL/Yb
	A6M6nRbpB1QMfvO2nEcjPPaCoOmDBz6mOlHJletxhHnzrIUfZFy5NeTJmesDMAH8spKSzd
	14WOhO/LsC2fkPESYn7v/86P4LF+K5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4502C43995;
	Tue, 21 Jul 2026 08:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8711F00A3A;
	Tue, 21 Jul 2026 08:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784621181;
	bh=ROLOrfPqMTfQb393OeJq2htXFD07Htbn862T+F3MXnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YiSd8pDUlnk54p+cGidnrLlHwhi5yZ2AVjrgGHvwLxttGbMXx+XqXN8synT9inFmJ
	 cIT4D3U6E76mBReMbCCip8dEZDv8f85y5wye92oxssvHvJS2q1X33CsKweQ24BX7y0
	 6yEyfP6/h9WEo/imefAHtTQqczYlqlgCsTB/8NIpAmRw9XWmBwkGaG3BSzSrwYhAhv
	 Dkzjr42zd5yQ4LqGe6UHz1Gg7WNacsg3JIdbbt0FCS0w5UZhQu7ZDEr42JFY5aKxON
	 y6orMEYgD3vOBeQLTLGlzzHZVheUtrIxkNtNo5NaoDrWtXB/wr6BRyJVnae1ABeWlG
	 ULhQ3r7gkednw==
Message-ID: <17fe32e3-6761-4101-9d5f-2b22c8a83d7b@kernel.org>
Date: Tue, 21 Jul 2026 10:06:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dazrpzamhmtzkk7w8ta84887jjwz4jy6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E93C140009
X-Rspam-User: 
X-HE-Tag: 1784621181-764080
X-HE-Meta: U2FsdGVkX18hckCXBjY8jSmzlYy8LIkoARxaRHx6AV+FOz42u7yay+GuN0i8cw0zRX5W9DYkxmYYQdb97u9u6QxtW2BWHvMGaht8AIo1St4uJ1E1Brk0FBtlOal9E7ROlYn4HEm4pabb40PWN/lcIBy4heHhunGmmjR8nc5yN+JxNH5tVLomN7WPSZxRSz31/c4MwgzsJyZLcJBycNYKiuGCJsIdfvi3zAc93FU2aZd12cQg8i3zaQJdbrFnheKXzImL4DWE2RW7lsZIh96T3IY5bhR8jfHNkSCMuI76IHqMLtOC8McdG8z0y7wYTdql6Ve2rdlg3BM1O5B/dptnURCK8pfFEFssHExO2qiTcMScwgMb9/5TtpSNL01PIaFiaysO4u6lBUGN0rUr7j3oi7jAr/Fk9/a+7kD4qVyfThsfUD/tiaq8BOufW0/WlkH65jfSuwHzjQHs5kyQ/L3qR0Wi5ROYBdErF5lWKAh+r2sxrppuvsCl6q5Jq+g7I6Ng3q6tFBDIK+kCsZ/kkVBP+GcBYhE9iMJzoqYGyg9frR4g2ApK7H4f2AEu1/LYR0Tw0zhkFO8I1OstmVuLV+VD/Gb00yxR89yh2E3HJTYWENzQz/oJfYQus1fOXyg0BwLAkaSmfmTi6N6Yt7IQ1WT/JUpy/ZlHk1BCoBO8Vi6aU0epBxCxmKuYDN89yFmIUc+xxzVXCD487p5X2rd91kNVDeLDd9lgexFyMkrBsNlpeArY+jbX+cIbEDmob+XYUn+U/x4tuk6GCUCWSSKW58alCU8ZAOE3WVyR/gr75zAcC4bZ/fWO0UzCO+XO31O2ZUJUdydu/FkgZjnYlxHIVIM9l02D9uB4HokRTWDC+tgFlAsn2A0HLo9iQrgHhMSb9L7LuI6LF5a7nkSEeLj4RzPB+KNbZcUXJWC6nTEM2heKjW+7C5bgDUUbyo3i031zus6ZIJAt8bH3o7X/RAAPqiI
 Nly+2ZW4
 dVtJ/r4XgHYQzGcFU2dSN4AbVD/oaQMPXTPe1PPlnZbjai8SamZlELS5QoZPRUYUiM5ICWrSTGubAcAAcgYYfiCAUY7+MLcLjyNdNr7ipWf17MKNZndpTbnFjedSQwUyFplXep2Udw20/MOwfDjgEAy6S08n6hEZ8w3uRupAq+aYxGx9oPBPyklwV0AxAHuFKkHDBx4a4HW7flEkVyaB8bQ4HFWm+fT4GMu271mjlBEp1YeJ5Pcpj4j8oX75lRX3jT2P2dp/xSKeVzOlLnBGmP4Ea3h5gdDLuWSITrsvB+TJJOlyeMTwvVa+XMQkUiKSvVYMgdt3/TTM7ngDdcS5HWPCPVYYOZlLywfwsckuMY97dAjmJ3/mct9h8ysOhxqqTVOssvKDtt04xQCo5FwE6IRO+NMowrqV9tWtfdqoEauyVY7c=
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
> Cc: stable@vger.kernel.org
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Ah so per sashiko [1] we should consider adding also a __GFP_NORETRY to
avoid an OOM kill. Seems reasonable that an API for returning memory should
not cause an OOM kill... it's unusual enough that it takes gfp flags but I
thought defaulting to GFP_NOWAIT would be an unnecessary limitation.

I can add __GFP_NORETRY locally if others agree.

[1]
https://sashiko.dev/#/patchset/20260721084522552ZPa16p1SRj3PYat3sqxuN%40zte.com.cn

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


