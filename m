Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D13DCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C97A6B0005; Tue,  9 Jun 2026 04:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A936B0095; Tue,  9 Jun 2026 04:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7C96B0096; Tue,  9 Jun 2026 04:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8626B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:49:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 882398E0C5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:49:15 +0000 (UTC)
X-FDA: 84859749870.18.6B4FD8E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id A36D21A0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:49:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994954;
	b=nKr8lnyo4sLGam+U26FFBfc8Gp0MT9fRFNQ/C7DNLFIfxPIXZflj9TMr05by4YSableS53
	xeZbtRmTKjRUe3b62aVHmg//5C/3MV9iM1ACU9dpv9T0lmix6KRNOiOHVafTCDtZ/vOTAp
	kkOD6P8YwjNxrZPeCj5rNgaL2VAlIh8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CUt2avdTk8/Y9zQJRvwkjFtF4Atz0QcnLZptk5BlEC4=;
	b=jTcszIYgIlC1ILo2lsP2JiXsWtIplGm7DDdkaqh35+TPj8WwL2MW/G3bfrLxYxdxeXnC/e
	FMkeJ8u2Ved9iCVBs78/2XoWoRISwLv5OvZlMDruLAjPpckcan4XyJKir40Vjg48EMGnL9
	zi/Uoe7+SAkmPznQLSoYckBl8lgEDN4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 201B768B05; Tue,  9 Jun 2026 10:49:10 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:49:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org, hannes@cmpxchg.org, david@kernel.org,
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	ljs@kernel.org
Subject: 7.2 candidate? was: Re: [PATCH 2/8] mm: merge writeout into pageout
Message-ID: <20260609084909.GA12512@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-3-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A36D21A0006
X-Rspam-User: 
X-Stat-Signature: s1xf4o4rj9ttxannrb1m4p8d84odoxt1
X-HE-Tag: 1780994953-777503
X-HE-Meta: U2FsdGVkX1/pOYQ/+7NHNz2hdNG+Qi5RrFaJTD6waeyuaGvbWthIPjc9wYrusREG9rIk5V8yUQTG9yXv6RmGENtLGppH5c4GqPX3Edz30lWh+UsQGg/2+Z+V/CviugHJtv0nL8dgMnCUoymM9D55qlAe8nNkp1fN8nBO6X0TCz0nGJ24wtEGEgjOqK2C2GNtcolSMZB7gk2sMKcYpn0A7o1ZF2tV+tU3PxFv+m+dRjU977MVcaAMw7mPdri7V1if4Dj4RfWStZsv26ZJuGAS0kI81e7IxD0TsY7fJEDajogviGpzKshEVtE8eYIlv7pQdQvynhOvbS70P4+FkBj5RbClo1ZXg0eV3XkBrHdZqxNjwVvZLJ2X0cn1wrBiHXeziAuNq0oBvsXQyQlVEz+uOetCQ0HC900KWWRfq5Uir87FnXyJ0WmGZ7GpULjMp7OGXcI8SKHsz1XHTL5d1EVPRSI5eAAieBhwr9tnhCLKivLHYGqCzMJCB/IITGYDW4Huo6TMpCNltlcQJMlFAs49G9fxzNsMP1HcOKYrWysSogxD1jEAtrz2OKqSrE5H8MIfN9eGwm4dMf7fqSq3VeUGMu3xjeYxXIomK8Oyc0FP87PQwSShVzMu0MwUuGkmB/uA/a7s+aHTv1britRjM794deCd+x7QsZzHQLj7O4gm6k88c+U2P+goFeUyhQcf3+suIviLXJyMobMFYkCQFJ5pdQixh+1XLE+ezp/jZ1wCMGcqobZHZJo+xlkgWu1xN8V8CLpCzXA/rK8I7BkDDYrhviKtO+tslpEK7Z7qutfBjnnxof0KD/wsUTxosluyvswe8+OutlTUmYaMJSkUv9JUYvfsnbS+W7UlgNJXZrlGgff8XnAIdoLJIwgNzeI8AZ2L3vGpe7wZE289MvYpe5t4wFzYTdYvQmbEO34ni7Hp44AwBFTHbDDIANX4PXFnlPWKDwIyNODfYOrst6ed/gR
 090M9V4G
 qZbFgoBeZG+Wnq8ko0+9rFnnds22WO1hE11JZWHzw7wr2J5It3hh1g5+ifL7qoFJ8CQsrLasUlrx8wVmeyNSr2kTo9FOBsDqxhok/gym66Elnq9F72cg7wwpKL97wSmWYbnpIr8NZzNEQy/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Can we maybe pick this up for 7.2?  It is a trivial cleanup that would
be nice to get out of the way.

On Mon, Jun 01, 2026 at 01:34:28PM +0200, Christoph Hellwig wrote:
> writeout is only called from pageout, and a straight flow at the end, so
> merge the two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/vmscan.c | 63 ++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e8a90911bf88..d7303eea1265 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -612,45 +612,14 @@ typedef enum {
>  	PAGE_CLEAN,
>  } pageout_t;
>  
> -static pageout_t writeout(struct folio *folio, struct address_space *mapping,
> -		struct swap_iocb **plug, struct list_head *folio_list)
> -{
> -	int res;
> -
> -	folio_set_reclaim(folio);
> -
> -	/*
> -	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
> -	 * or we failed to allocate contiguous swap entries, in which case
> -	 * the split out folios get added back to folio_list.
> -	 */
> -	if (shmem_mapping(mapping))
> -		res = shmem_writeout(folio, plug, folio_list);
> -	else
> -		res = swap_writeout(folio, plug);
> -
> -	if (res < 0)
> -		handle_write_error(mapping, folio, res);
> -	if (res == AOP_WRITEPAGE_ACTIVATE) {
> -		folio_clear_reclaim(folio);
> -		return PAGE_ACTIVATE;
> -	}
> -
> -	/* synchronous write? */
> -	if (!folio_test_writeback(folio))
> -		folio_clear_reclaim(folio);
> -
> -	trace_mm_vmscan_write_folio(folio);
> -	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> -	return PAGE_SUCCESS;
> -}
> -
>  /*
>   * pageout is called by shrink_folio_list() for each dirty folio.
>   */
>  static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  			 struct swap_iocb **plug, struct list_head *folio_list)
>  {
> +	int res;
> +
>  	/*
>  	 * We no longer attempt to writeback filesystem folios here, other
>  	 * than tmpfs/shmem.  That's taken care of in page-writeback.
> @@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  		return PAGE_ACTIVATE;
>  	if (!folio_clear_dirty_for_io(folio))
>  		return PAGE_CLEAN;
> -	return writeout(folio, mapping, plug, folio_list);
> +
> +	folio_set_reclaim(folio);
> +
> +	/*
> +	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
> +	 * or we failed to allocate contiguous swap entries, in which case
> +	 * the split out folios get added back to folio_list.
> +	 */
> +	if (shmem_mapping(mapping))
> +		res = shmem_writeout(folio, plug, folio_list);
> +	else
> +		res = swap_writeout(folio, plug);
> +
> +	if (res < 0)
> +		handle_write_error(mapping, folio, res);
> +	if (res == AOP_WRITEPAGE_ACTIVATE) {
> +		folio_clear_reclaim(folio);
> +		return PAGE_ACTIVATE;
> +	}
> +
> +	/* synchronous write? */
> +	if (!folio_test_writeback(folio))
> +		folio_clear_reclaim(folio);
> +
> +	trace_mm_vmscan_write_folio(folio);
> +	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> +	return PAGE_SUCCESS;
>  }
>  
>  /*
> -- 
> 2.53.0
> 
---end quoted text---

