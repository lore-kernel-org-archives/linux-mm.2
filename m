Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E5CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B576B0096; Wed, 26 Aug 2026 04:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13BE86B0098; Wed, 26 Aug 2026 04:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004946B0099; Wed, 26 Aug 2026 04:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3FDD6B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:57:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1873EA02E4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:57:57 +0000 (UTC)
X-FDA: 85142818194.23.493672D
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2BC1F80002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:57:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vJIOXXPY;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787734675;
	b=EU5BG2VanZ8OC16kDpI28VAGuVVFbZUJlNd9PeX5SjzO85VTpflmUpOoztJ/ZLGaBKr0Zm
	f+P8uVaKWdbxHfpLC1oceBAew/F0p5hfF55QZ3owNt5HCbCtr5QLRHUcX5cNiAzmnA0CdR
	RDxByQhWfxKtI8UmRQQxFKmqCpBArBc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vJIOXXPY;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787734675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzFhBrtf6Mm9TEs5D/JwWb7/bwN0jr0NI+NeUh2pXzs=;
	b=GOZtqSn4zCXegt+7fTumbp5bZ+Fw4cwKRgWGRG16kdY2K7+2IbnI4TDr9v3ha8lNnSreVO
	60mkCGpA7IIxpFZO91LQGhSItS+v+Lv+WA/wYTmODf9ZTrjNAM+tq/ZBelNqs+N0WbLeSi
	ieTwz0II+L9Z4Xc17/HcNRAVLvyrxHo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ulkf/t7OJ7WGXCfgEhtP/r7bS9OB9yLRw7ZeDCQeDek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787734673; v=1; x=1788339473;
 b=vJIOXXPY8eYJB+RKVWaPWzNBvyFoLDOZxd1hRviOdO6YdLh8dmfkXKXJI0KYedDZMDGKypnu
 27lMv45PJFh3+SsxzSR3YUEr3B9AHJfH63k38eDU22kfGDrZOzPJpbl60DdSHX0nbQzVJ0yA+Ju
 cp4KifaUNaHGh+1LWqsGzTi4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id 984b0c1ee52124eb;
	Wed, 26 Aug 2026 08:57:53 +0000
X-Mizu-Trace-ID: 984b0c1ee52124eb
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:57:50 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 4/6] mm/mglru: exclude folios promoted by aging from
 protected in inc_min_seq()
Message-ID: <ao6qjkV2PwWVE-sH@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-5-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-5-baohua@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BC1F80002
X-Stat-Signature: dx73ymejbmugxyag4pyu5917bi7449yw
X-Rspam-User: 
X-HE-Tag: 1787734674-419394
X-HE-Meta: U2FsdGVkX1/pYNxIzQBAREizFE4A98tBP6a9r/iLbDc7QClVWXA2459a3iRdqylVIYSGguavm1K6NVzUzoJLUMcxMV2/2W5mqjS406bUy+HcEapL3mI45tR2fI9LD3yNj0vbhfzAm/x7T1lPf8QYF+j0C+gv0EEICEqmZmTQto5BdBA6idF7PEinXT7xbtQDISAFO+Gg+NydN7eynqD7ZcccO1pGTpOaRr8VWTPerQMsLN4iDLysyJSfntQ97GHUCakSnZr+MgHcjSEM4JPnPGkWdAUYlr1wGoA22R/jUDB3JCmvTSA3EJbQgwLz4DWeFsem4gY+iJpMeRunA7XD1MAAny67JtDWY9qhus2KNZSl4NzLRguMtktz65/dSm7BhHj5mz6gUbBa4bqF58WQpzx3Eq+XC1ISdbMYBbWi7FHnH3MT5WOeFO+Mx1RqoVruRh3MQBwPZQyjZswIAm2WS3BYVikuM5oLto0ICCmuk+lGpQhjzdnGyR9AtQ5e1SirfvidSvbsYJcj6rPpVnFSiVWVLRwscMg4PxERktGT060RDuMYddzhjkgyIfKwBQ0EaRVIIkW+zpLG7emL+jSvNWynABMEUIdZ6POME6ZoukNF7842SMTutvV37ZM7VOv0U81x9W6QqiTxCpUXSp11CCrt1OfzBjNBcfgXlEsuNfY/3SOXk2cX2DLIj80uujGmtgfqPDku1O9/ziZVVuFKAUIgI4w5p/gM06wghC8957vTOs5MciOkQ4qGsAMDBMGAUSDQ+4ypXzEKe8KcQ3mYHzftoxf23ANFhajHaHjtaj0XVSUG3nKt1nbIwdhsYgdXSdugwBej41VdKdI1NrPAowRD9cuPPN4OYKULcqk+FgDEGaw2fMi8Ccv3KjHk9Y6KxZ7Xad067atwSoSwZTCWHi0ObsdktvcMKnD0yAAkQiYMsicfy5UeAoXi3xEGf8RZjSWZgGlJskCelB8kp8Y
 PiCFrv5/
 LPPNdJmRm+8zOF+sZPr16yU71NW2wNL/K6aAKwqscLJRtDcX62JOMDZkUub5DXKI14UEaCVQnF82OdUogCCIScQPhVFCAcTg6e2tt3doH+B+QlhqQjmKER59j2NCP5raOcsO1N3IRrH6ez0IpK7qfue9CYlhJis9Di4hzIoXkURBMgGKe4GyUZX2oyAGVZ0coO+xTq0t5IN9SdvEcVppFuoswpE4awQgppSFg8aYEOH6GFSqcaXk5CxVZQ0iN9HLuRFUewQbEWcoLn4m6xiJpWbZs9vgZAmeU0QHBZeCJromb3jjWhmWpagA9pfhar94WRogIJLBlYtKxLdx3c0FRMNMLf29bXbMl4YLp5adf/4oHSSGqB3KYLg2DOvePgT9V22XPOwPGdpQQE58at9vHoWjn0GJBR+xvJL/U2XijNORSPNot5l8eDJt25hstaHF8JR0g7m4crTJevUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> Some folios may have been promoted during aging, so don't count them
> as protected, similar to sort_folio().

Makes sense, the change makes it consistent with sort_filio.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3b618a51cde2..7bd01875fade 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3949,16 +3949,15 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			if (gen_increased) {
>  				delta += nr_pages;
>  				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +				/* don't count the workingset being lazily promoted */
> +				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> +					int tier = lru_tier_from_refs(refs, workingset);
> +
> +					protected[tier] += nr_pages;
> +				}
>  			} else {
>  				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>  			}
> -			/* don't count the workingset being lazily promoted */
> -			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> -				int tier = lru_tier_from_refs(refs, workingset);
> -
> -				protected[tier] += nr_pages;
> -			}
> -
>  			if (!--remaining)
>  				break;
>  		}
> -- 
> 2.34.1
> 

