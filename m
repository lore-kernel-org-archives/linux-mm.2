Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F383C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 02:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF7D6B008C; Sat, 29 Aug 2026 22:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949B56B0092; Sat, 29 Aug 2026 22:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F4F6B0095; Sat, 29 Aug 2026 22:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 578326B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:44:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA496140229
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:44:14 +0000 (UTC)
X-FDA: 85156391628.08.C0EF01F
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FCE1C0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:44:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ew6ndIm+;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788057853;
	b=XkpAYSwkxv7BXagVq7ibVnMeq4+e4J2tx+4ADGr2RJwRGgDEKifl83i7JTcFEJB953Wy42
	zY2o6nS2L34NJBP/+IJ5MAKNpMuP7LjHbgRmLhAS5lhQMk7xRgv0P+snOGilvN0kGRbOKH
	ndVHMpJNfkTPjTFFNu6VTOpWYGNq3bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788057852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/TzCfg4eQnZBBqVNb9wcZBTlkXaEMXu1hm5uznR21c=;
	b=4+eWwyFKPSE6fRb+uXaXTEQBkbV1BtXUk5whIqbJUpkOo0DeUp7tX+V1GmItDgcz+uuDHn
	WusjLvydUZiXyBAwYTYYCnm0DASckLn5xb4ixHxFzODI2pGk30GRdMnaenUIXHYRO/Y2fR
	prqOmxsvdf47smJm8E7mIFok6hP/tdM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ew6ndIm+;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HMrK2tewBvrIMRD/RpK8lBB2m3OiLHhGTVVB+J2XoD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788057850; v=1; x=1788662650;
 b=ew6ndIm+3T/64+6WjO/CQoJGGdwtkPgLsa20gsbinzE/3n4pQiVBU8GjCkv+3DszSy55U3gw
 hYqsueezzZlbYuLcJGYmLOjPcmOpmS1uh8ych6700w+9Z6V9z0tK+Wn/XTpzObQkUWkbqJexmFl
 K0HH/wiALxQLjkApjOoCvbGI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa0b8e2f78cb6e66;
	Sun, 30 Aug 2026 02:44:10 +0000
X-Mizu-Trace-ID: fa0b8e2f78cb6e66
X-Migadu-Flow: FLOW_OUT
Message-ID: <af26ac3d-30cb-47de-a295-6f9b4f2e2c32@linux.dev>
Date: Sun, 30 Aug 2026 10:43:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 lianux.mm@gmail.com
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, stevensd@chromium.org,
 wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
 zhangbo56@xiaomi.com, Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260827234704.63163-1-baohua@kernel.org>
 <20260827234704.63163-4-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260827234704.63163-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FCE1C0008
X-Stat-Signature: r3ppm8sfyf6ud98ya5fper68zse84963
X-HE-Tag: 1788057852-146219
X-HE-Meta: U2FsdGVkX19S88NhQJP3kRFNZ/nE4oBrodSq6DV/46qLkepKjPbwUB2NPsVqNLPb7d+ksiO9vtPG9zpocuINzAMplpxAQUHWIMKuygesyzMMg8ao1PZ2GGfW4zvGQKiOFHzS3tD7kZF/V3QaeDVrkZFbcaXS+YSlc+K7di08GgZdFaL/xz1/xJqVPVMMzvPWneOMTbklZILEJCWwh1jSaVbadZROkkKzxeLzSsd6RU96WYDlhAXo27gqB2IxDBRKJieOx50UmA+L+Q8osFcvd5PSFaBJca2/ARJDxYXhvCZ53A3M4T8mBFn5DY/yk2nscUnGyqPrjHhBfmlfvZ0r+JLPILXr0Psj0dzp6ayxhDwR+15WVMIbG720BKmUaWd4lMeuB4rU1viOgBkk6sy+VJOOttbj5jW5bEg52KzoemN7rNE/x/NIO2moTA+4BSnkHweyVpVQ9Kght2aJfKUh5GtMSiqDImsPEMoDWqJ07Qn7jt9P05aL62qheDhw3/ni2fTbZHvinYwdDVodNZF61reaT1KjmIsBZVWpc6W2NGuExGc8y29jnymnMt8c4+Egsv7enTXRfXvQdDrd5edlAt8aolDdfRFdqdVB5pctPcLkUxl01GP7oaHVfqskEmKO04fwJEiRqx1OjPKBlGbbg7EuDsqIXjnN8jNyAuh9gMOO5YHJ1sgOnTJZ4Q1otitdxJSB49LAEn0wGMIRtD9QozJQ6oQlpwxwozxQGIk1RPqpfn/FZn2mmJJ4MMQ/8ArgUabjzh1Ai7LN12+FnLZkoDdrmKYYwDDxrAuusYvav+VeUVuYLGEBxADuFzQTk9IapLkPwerY7iw3ueV0zxnPS1xVVrO4C7a09FjfOcac5/PhEs9e3R7xT+wY0rjS5mPAQinTS4tA+MkKyM5xr4q/wXYRrNvVwXxn7EMSTGpPt3lG0tg5s1HNMfG/mb4s/tKC24HNp2ZYMWVKdQGYa+2
 V016MQQI
 WCC//i4VcXEnUfx0EImTFlxypvWUHAy3zVHH6FYZptIVFhJuocb7R3u1HLu2E6mM4ms+G0+yLHAzTS9wZw5YO+ffWegx7M/ZV+O2T7784ffjDHAdDjOa+2l1VCXS7uVM55eVCCCcwYUIfrYlL9dCoooLICljn41wCZrGT+FtPrEivRyBsjtf+M9N+3aWzV9rtrI8GaZHaeDVMdR9G1J0mtZe335JYxYQVY8TrxHvH5l8gp9SsGeEuQasvNLrIFI0R4a1FMUSx9tu7srKVG3BTN1T4W7I5qFwLlLpWVleWADrj+qyCLNXgOvnZZi+JhiigAqmAX2fo2ZTOYYaZkw3Q87iQ0c+DEXNYur4MR9hnRI1LEcborzEJ0pu/ySiA+QBNIxprSnomK47vkAuQAKZqGR5e9ykMQwoJuqPhUaXvqjh/+MdEH97zEXVin1bau5/7idpacwiyRJtljPFTWOtoXD7snA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/28/2026 7:47 AM, Barry Song (Xiaomi) wrote:
> During aging, a folio's generation may already have been updated by
> folio_update_gen(), even though it has not yet been moved to the
> corresponding generation list. Such folios are hotter than those
> already in that generation.
> 
> It makes sense for inc_min_seq() to increment the generation of
> folios that were never promoted during aging and move them to the
> tail of the new oldest generation. However, folios that were already
> promoted should instead be moved to the head of their updated
> generation, just as sort_folio() does in scan_folios().
> 
> Otherwise, promoted folios could end up behind folios that were
> never promoted, effectively inverting their hot/cold ordering.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>   mm/vmscan.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 07c22d51debd..b10d1703d907 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3949,9 +3949,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>   
>   			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
> -			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> -			if (gen_increased)
> +			if (gen_increased) {
>   				delta += nr_pages;
> +				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);

Nit.
This is a bit confusing to me.

When I read the code, I thought this implementation contradicts what the commit 
message says, which means I thought that we move the folios that have been 
promoted to the tail.

> +			} else {

Maybe adding a comment would make it clearer, like:

If gen_increased == false, it means the folio has been promoted, so move it to 
the head.

> +				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +			}



>   			/* don't count the workingset being lazily promoted */
>   			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>   				int tier = lru_tier_from_refs(refs, workingset);

Overall, looks good to me.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong


