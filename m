Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94538C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5A86B0092; Wed, 26 Aug 2026 04:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D346B0095; Wed, 26 Aug 2026 04:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A34A6B0096; Wed, 26 Aug 2026 04:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6986B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:57:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD208802CB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:57:01 +0000 (UTC)
X-FDA: 85142815842.04.BE8F8C4
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id B41DA160003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:56:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hd0S+ReH;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787734620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ljEdKiKTFMoEEsFwYaCgxbY6K+4UZHQXLxdbUWz+kY=;
	b=QB+5AjFy9hrMrnub8j37K0dDdS3uagnXzEUI1atwawTn8nRTaD8UKBOskBus/JgoKtjRx1
	AeplWgn0BLjMHYkitRQGvbBD6Soq5cBGB/WpI+jJvSQCVYraZjkUdwTrS0ufKqUGxLLrIh
	bmRoPhvWMLlq+0iY4rWrbeSJX3CwHJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787734620;
	b=FhcFnCFKY2c96QG3S3H4PiR1GGi/nlv44Z1fgCQG0NmT9ShkPo7WHVoiU2vTPAVbsRPbA3
	TU7S4ZPP7CY03uysg/wDQdIOZcN4445EqhUN15O6jSx84jBjdrnTksdPJYsISPxhBjv5f9
	rWhbdUqIbQXRuL5iYgyPMeLPCjflu1U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hd0S+ReH;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YvE7TMRi8YUbvrIcqXRmL+ykNziy5hMN0bDbJpNCV+8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787734618; v=1; x=1788339418;
 b=hd0S+ReHrtZAQjA1R7kX0pxmIJugVw24d/M0aOhbST6Kuyvi5A3dDkgyYb+9x+nAJG347Z5r
 YPi63Hain4f10CcyX9HBzKGcZg/SaN3Fh6lpnHbHgZv511VmCs4r2jhxTahv7GV1L0hfSWPIhqA
 4P4yDWoi2K2d9kI2fXNhMJ00=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta10.migadu.com with ESMTPS id fdcb0e4ec58e3f29;
	Wed, 26 Aug 2026 08:56:48 +0000
X-Mizu-Trace-ID: fdcb0e4ec58e3f29
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:56:45 +0800
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
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
Message-ID: <ao6qTTtk2xkkeKob@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-4-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-4-baohua@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B41DA160003
X-Stat-Signature: ukaumfkdfzt8zqewszwp5x9sbgtcb9ma
X-HE-Tag: 1787734619-648151
X-HE-Meta: U2FsdGVkX18yu2KcmJcRVLdi7QKRSsIUGdx/OBj58L2I7I0DaBbLzqHywykLETKlbgo8s4S/PtTj3dYELzbTlND6Hlo9lGycK75pdVghcTTGUfzDsJVidH7ClbtTNTBiFymEh4pIA0n/3yFPkU/Whxb18/Ov5XMdQkdnUHGS7QwPHpOT0BNSeymm9LKarEjAlkv4HIuFInAcRTgrmOzS9pLbvqBEGSGVqAZ+xWdnc7WhmIPtDZ6bwVv7w77/QzscrVi8dSiFYrFFWxzC06UQEMWfmcJsGNpdQj6fhLEYzwQaahaacc9C4LemOH4cJ9FP/zArkZmnWqd3hxNubAAeLRtgoJjA2cBD6cH9ztfYrGiTPDuzbmkc4fyPlbVnj0d9FZFYidH9pO+WYKmamg9vlLEr4fWbAZusknf6TeT35VnMEuQxjaE14ufyU6hVt9Wce3mKnwdaIY7fk5w7k0hb2Pvhr98FgX4wDyDxZ6MyN/xsc9lxNt13iagckqPzLUYLz1riO9xWuW+1LfOGxjNJHV6mb4xvxolcsaeDW6DZt2pTSzwUdbVmsQO70x+QxTzOu8lZRS9HL1ocCvdKtfuAoovCrYH2tna6NY4JFg1KWioSLhFsMFaxSK5ev16sXns298UtOAuZ+MrtnAjCrCjY/75t+wUmyOnGzoyvZ/zto8cxmRhnjLL+OzrowzVIL2D5yFAoHE7BdQ7OYY/U61wmEFN2iTl0lowxA+yVbdvPvrlLZYGFvz1h54iUYkQJDN2mRFigQsOG7DSimXicBgsybReB8qZLlIyDWtQkLc6V+arN0iuHujW+IALr4LTGHss/GRS6Rq6oL6Iq8QoK8Gnvxe8ZO9tfZXwnYCWTn73BEhUV+DiXB/ernh7Z/b1UfqPFlSDUFuJcM/aB/I47EFWVqh0lsxXsqvQC1xn5YX74uLj26lqJyt5HdipOiM9Dm6WyC6ZBIvUUSavKaai1e1k
 mNxlKNZK
 xkOxYLsuZmf8lSsMkB9cFT78XUPaZJeaGZyvZ8yB3wxtiSHkp88SneSqweiq5bJXMefGggHEFkFEW044WwdhEw6BdHVVGtBPmODc50X7UnoxIOL9LzKLgp0CQphgtltG9emNwrd1hwwQbHUiwwQHEc3U0UhFB4Zo96+V/YBluxEI9dgbdOS0tV7C2cFyKXPnHZ/GkejZx2WadJV85UsPwYrUYJXYyP7YyQJFKn+hdsxUKI0jCRE8QcnWU8shSBRlGLVmucb5JQxNSRUXUGYkfgRq/hSd/lAzkQCwjM8X5e8ShwP0GoanG1GxF1ZOx+Yv6QlOadvJjWP85PjbUNbZqdSktyTdtd7Uk+32AfeY60V8NSpnQNJIwmK2VgoZ36rdtaQ/z0ubyOBiDTb/mN7T+1KWYTh8WCobRWmvbLaKcc3jzIJIGKlSzKfLZj2CdE1WA3mHI8NTPvfI418Uzf+IHcPZHEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
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

While sort_folio() move protected folio to the head of next gen too.
It only moves ineligible folios to the tail of next gen.

> 
> Otherwise, promoted folios could end up behind folios that were
> never promoted, effectively inverting their hot/cold ordering.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 99ee3c833d54..3b618a51cde2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3946,9 +3946,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>  
>  			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
> -			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> -			if (gen_increased)
> +			if (gen_increased) {
>  				delta += nr_pages;
> +				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +			} else {
> +				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +			}
>  			/* don't count the workingset being lazily promoted */
>  			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>  				int tier = lru_tier_from_refs(refs, workingset);
> -- 
> 2.34.1
> 

