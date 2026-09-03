Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19974C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2CA6B00C0; Thu,  3 Sep 2026 03:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAA96B00C3; Thu,  3 Sep 2026 03:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407086B00C4; Thu,  3 Sep 2026 03:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 149336B00C0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:42:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A94FC1A046F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:42:00 +0000 (UTC)
X-FDA: 85171657200.27.6740F84
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id A25BFC0009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OXii/lR9";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJA0G2AdZ7eHkFYBQWsG+i0rgrUDfzuyC/WQWTTnqwY=;
	b=RcxRUF1GaxoEyO+eUJzPZLmuUcrq3huPQAtvBnPEBPa15GvXvHVAxvi9Ca4tq6rU2B8x7J
	aiPs/NOgrJqzJP+OpDkGVEDcOnnjE2nYGSgsyQr2x6G6dgePDTkXY7ooH4cO1GYdUdvCVp
	NJieV7BwnRvwEIyCEsFinoNQPk4VQis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421318;
	b=A3ozJg8ETKCczDn/zLB4qNOuUyjvZ62Dx2iTkAYkcHvtzgK6mP5nzjdmjr8/WkB2ek9hh3
	rC82AVwO9fSjg0ReBrsFFHZPpLpv5N0O989ugd09VpJqOE5+YwqfJNxTVvd09rG9IMhm4M
	ZSmRtqB4vt9KCoR7R2m+nQZHpvD9TTY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OXii/lR9";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=r2mySitCm8xZAfu7BGhS1SrRCHq8wTD0UYn0zUS4Mm4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788421317; v=1; x=1789026117;
 b=OXii/lR9UHrPY8uY4GTmcjcxIudOQS3tOGTvevDFPd4vuWFleg4BnVElLPHCSwORl6ywsYsl
 QQxfR7swoQK7olcNLbe9PJHqlEfF7024jn+HWMwdlCdD+jVJysEZs+2iiVPSfh8aY4MJp9LK2pN
 O+1+nvBtvSbWvUzzQQNklRKU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 40945f90da2aaa8b;
	Thu, 03 Sep 2026 07:41:57 +0000
X-Mizu-Trace-ID: 40945f90da2aaa8b
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 15:41:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, lyugaofei@xiaomi.com,
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in
 isolate_folios()
Message-ID: <apkkvyLNEt4_ETiz@fedora>
References: <apjM5ZBOJrdGQM_g@fedora>
 <20260903070500.76379-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903070500.76379-1-baohua@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A25BFC0009
X-Stat-Signature: 8i9fdchieuoqr1eh384wmy8z9kgxsbrx
X-Rspam-User: 
X-HE-Tag: 1788421318-486798
X-HE-Meta: U2FsdGVkX1+xafNExM8DjSu2qhMK4GMiKf06Io9+rL3dTdhSPCfSlW4DQnh7zwKkMMlG72qctn1sC6ZBEQExNZFx3p0qQ5dinn84msPh+SN3d8nGV20bwvEm68lNtz5zMArFpx6Fjhfz5/EKfoQ2cWIyOpPMn3cL6byZeW/dajnQhPfKL9A5EswqYNNlkLoURQQjqeaZtCDTnORrVfiN71S0fddM+Go2ysx1r6yptAXNJqofS1mahASWilfbiL2LzfDbX7o7yn4gj7wK2fa8aWsGZrDCtSLBhLXWtRY5NZz/KWaxOInujRchhMLYx0wMEOU8MW5FXGxGSWTAK5tBQXp3U0d9L9KgQDd3IHQfRxqkRAMhDXsL1Bs3ZC98NEETIzfwPgA02FC8/PkF0gO01SQdtiSl8Kc5s5o2KyksE1lJq3FiT9MCD434UIxVY5t4Hrdz2No1ZfQKXYF378MPdlzNy17+Zn6uDzG6jjlRTcrUCTAtZfzyJNh0RC7Ymz7qvyv5FGPiQfJppVudrLWwMTalxOyiwGfaj0E9Jrf1q2rzuIbWIqvbjPU2Fw9OosMBNY2O3ItEZ1y5dpNM689Uim7l6iEsZop0FA4K7smXXfgLfw/Pe9JY2W/fGlNloiCzk/L8oqSV5uknZTwm2C/PSIpWuvpOJ9py+XG7oSJhI0JDZugUSpWqxsdDqWLxODA1+Zm3MsFqdvFAaMbjDWWsmjSCbplbF/uOwntAiAADcVEqk9lXym7zsPOZOMQ2CqHQL9FF7dgye12rsA/lyCnXWKOJONk/6349PPm1oqRfffZWmbipp90ODlSnNWSZqeH+W9YF+A29qqipO09t4zzrQtPKBf4XzqLDx6jLK3EBQHIhV2ORLqfi06PqtV55Q3oSjPd7I4wvmc9+bu7NDeP7lBSnqDdht4Pi85pFnjFotIKyXmY3pw8TJES7toHOg2oZGUu8K0FruVPjBUFmwf3
 UEtL9Jur
 ie9719EZsJMy9LGPY9Q+t9wicH/B8caDo7t5RISy7xw4BT+xhRAsesyOHJgezFv2l8dGO22iCAa12kGqBbIg8qVvKjEXixL0hBxcHlezTtIfTZBoKuwxsVt+nD4pC+8dYYBusYDWoOepiVAm3wYdk+mX8k1I8JrxLba0HXFUgzPjIL1Npj/S9obE5ZeCeEehgbCrVFpSDsunchC/OGIV2zNBx5pjNtqv8SrzfqttcEeiEP2X+V/T7pPLQOHpvFlVcI23pk4qDEoaRhAhPhrZWWUz7B4bZ3Ldp+jEfvqTIA8KT/CPuBF73bRhaY8kocuHBYXT5h49YM19jVZdiam/iDFFPJIZOsI0WnAXexGyCBzvJTXUk9vhVVzgq4dGAfooCTx929eXSdmY75tym/XZ62kBt8KCCFNM0zVAZZ035TFy6l4cnQHeCcqGU4ZnP0WV3I81UB+fyXu6qLl3/b9tr68mVU2P/jNgP4U75
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 03:05pm, Barry Song (Xiaomi) wrote:
> On Thu, Sep 3, 2026 at 9:27 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> [...]
> >
> > Thanks, Barry. These number is very convincing. The retry for swappiness
> > 0 is worthy. Then the patchset feels like doing two things: refactoring
> > the for() loop; improving the eviction for swappiness 0/201 by adding a
> > retry and this also makes them be consistent with (1, 200). While the
> > cover letter subject, patch 1 and patch 2 feels like it's not easy to
> > match them to the corresponding part. Maybe merging them to one patch,
> > or rearranging them? Just personal opinion.
> >
> 
> Hi Baoquan,
> 
> Thanks very much for your suggestions and review.
> We have two patches:
> 
> 1. `mm/mglru: make type fallback logic explicit in isolate_folios()`
> 2. `mm/mglru: make retry logic explicit in isolate_folios()`
> 
> One handles fallback, while the other handles retry. I think this
> separation makes the logic clearer. Could we keep the current
> separation?

Yeah, it's also fine to me. Thanks for the effort.

> 
> But we may really need Andrew's kind help to squash the change
> you found below:
> 
> 
> From 1fb8046662a8b23be1b87a21cc9964e9ff9e1eb0 Mon Sep 17 00:00:00 2001
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Date: Thu, 3 Sep 2026 14:48:52 +0800
> Subject: [PATCH] mm: revert slight behavior change for swappiness 1-200
> 
> Baoquan's review found that we unexpectedly introduced a slight behavior
> change for swappiness 1-200. We could now have a case like:
> 
> 1. First scan -> `scanned != 0`
> 2. Second scan -> `scanned = 0`
> 3. Type fallback
> 
> Step 3 was impossible before. Let's remove this possibility.
> 
> Reported-by: Baoquan He <baoquan.he@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/apfZQE1X6zGAsBb_@fedora/
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bf2786c7247d..ba7adf36e69f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4939,7 +4939,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	 * We are running out of the current reclaim type. Fall back to
>  	 * the other type if allowed.
>  	 */
> -	if (!scanned && type_fallback_allowed) {
> +	if (!scanned && !tried && type_fallback_allowed) {
>  		type = !type;
>  		tried = true;
>  		type_fallback_allowed = false;
> -- 
> 2.39.3 (Apple Git-146)
> 

