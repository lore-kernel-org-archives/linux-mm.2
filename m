Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CC2CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310186B00B0; Tue, 19 Aug 2025 11:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A556B00B1; Tue, 19 Aug 2025 11:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0A56B00B2; Tue, 19 Aug 2025 11:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034876B00B0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:52:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA5A3B363D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:52:26 +0000 (UTC)
X-FDA: 83793949092.04.610E0BE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 03DD78000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:52:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tuUo7puu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755618745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUyQZ0m8A6iLfxmAVdslQ43LODUJGixdQfETEo6Xkas=;
	b=UCo/WL3XmHg9/4ia9c5QEDCcFPu1hcefY75HWIApiJ+wVOm07qDglCWNGCW2J2A1VADbhG
	8lyNscXY2JE4HjXMomT1auqab5qTZdJqW9lI2ssIju1Y3DBlhXfgkNldnxiB+aLXN6uWZa
	Awz1kDEnmMms1hlIxrH4oBXTbdPXTSk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tuUo7puu;
	dmarc=none;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755618745; a=rsa-sha256;
	cv=none;
	b=f2ynvUFoBXxXF8oVzMUav5mHQ5qcjVx83x+Srw+W/I9yxxK7Vuf02fxBVm5cqYqo/UGEMf
	rnIprD1bIYh0MbD5Iwm25o7fYz8jLiXMjvPVXX8dK9O027gu/RsVNoR4HznXqfBwKPDnYP
	9l8j6ycIxc9fVO9iC9BN9V9kIUxI7Ck=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uUyQZ0m8A6iLfxmAVdslQ43LODUJGixdQfETEo6Xkas=; b=tuUo7puu4ksjcET55wZXSooC2Q
	HAaT7944dHXz6b7j2nwC9awn3TQn2t8p+kAnU31weAq+3FuhuwiSzTDnFC391ptyaxRiDzjbwZpHt
	PmERAR4bQzCLZL/tfCreYq8nlYvXlUELIgCwZY1goY0wBotDUiC7O69gP2T8qcGx4OOS7qu7f7cxd
	wp6W+CSFJGJbVf0CQhm5NuWpcYyHRrBzRd5ESDOIPdae2pYHes2UBGrqhoI9amaXn0gpMwAFvMp4p
	xTvrCIX6M7vpc3Rw0Etecp5yzOnIw+cc2yaWLR9bL83VMhTuGOiCqixP7s+PBB6qmfgdKJknmqco0
	r9bcdotA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoOdF-00000007smZ-03QH;
	Tue, 19 Aug 2025 15:52:17 +0000
Date: Tue, 19 Aug 2025 16:52:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: fengwei.yin@intel.com, akpm@linux-foundation.org, david@redhat.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Message-ID: <aKSdsH_yk69EvkMX@casper.infradead.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819140653.3229136-1-tujinjiang@huawei.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03DD78000F
X-Stat-Signature: fyk7guugcncai4szko1zckose6ajhx3n
X-Rspam-User: 
X-HE-Tag: 1755618742-378984
X-HE-Meta: U2FsdGVkX18DkktgYvQwno5hJAwSqECu0M+JC5JDO3gd9WVGmxV7L2mYhd+gKXPSVITLieCYj7TSzCgZqyFWHQLSGCzuitjT0DrRmHJQZcbyeLE+cnOwtqXDThj2As2tjr5oSfViabROMYhjfjczvg7PuIDLJ9uiCFxm+/2GrBuIBTrsvsCmam06GPEW2o4Jm4hbcEFLVAvTWKWUES/mzXOW/1erudh9HDfxbSjXBL3DssA/aZg8rqJCPSfArcH5ZxHEx88+yR58YgwxUxbqRFvYpa6COp14eb4BHVEnPqJzjjFB50h0nTy/0mCQYxoJxVmEkTxFs4aULw+zltY7wMvooLJZf7rSTeJ9ul+j2vEbs7bL/sLunFSIXVi9XXMnbPXk+kINATwtLISdA36TiFLM1qQdxDs81nEgJsyXVHaC2INqsEzD+t+g8Yb0OOSaVh9YIVK/5y7nJyN4/88yKsICDJAIy884ieiRIcPqiuVh84Q619j4XoIJtcrRP1v8Akm7bWNKaMvQWnNCaspPfhNCb+cE0bK1Cmva9hXSJE6rvhwqWQanEVa8dj15/UKEb+HcqJxZ33big0J33JbvHyoBFwbFVgzbIcsPGM8938tCRHBwTL/9p+WbJR5gyaJkWBtkMkLapEyzDlLcD8VAMi2LpUUTyhDHt6JxPgGHu/vuyNtT2ZWl9+U3nXr8udNWjJ1I30+/ySHK+k+CsQygIfSAbG9hpDP7sveBqYE94czQnGotumSs5uI+8A/IcdJE24G6qtRbnUV99b0NdJhJHZFP9zcqWtE7oclmESKJJxLHVpLLgcBfBkaU1ehoqhH29QWLys1z4y3wpksiJmNKCKep2WNdTYaS7vg9jDC2KNFwVtiM9J3HxyIAXQOYJEgFjKgSgqKQlhQxRaybyW3Uawa4blNkWaad/iVMxAmuHbNojiOVaO3syAgYh3zWPWN+RFnr1hq2JFYlBEkLSQp
 oKzFaPE7
 GsNTnRDktaNvKQ0Fv34hgTz+dQx6X56V2xCP8x0OaSIkFOwwaTYOisUzQl+K1+mUmk1jTn/IBhJ2+YL3xiIKjf5M5DOgQnpfYe7JPrvrlfu1li648Is96QZ4DVo2LKlIFOk05oEsoxis3fJO8Ahy4XrnAiopoyPiSUJR6j7P8Ulh0LNxG/S36JnMne3H6IWEC/q2XAY+a6sG2PDr2iL1thf1Z5cBtGWihWgibg2UxLPpbiosVmiU/FQqwYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
> There are two meaningless folio refcount update for order0 folio in
> filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
> after the folio is mapped to pte. And then, filemap_map_pages() drops a
> refcount grabbed by next_uptodate_folio(). We could remain the refcount
> unchanged in this case.
> 
> With this patch, we can get 8% performance gain for lmbench testcase
> 'lat_pagefault -P 1 file', the size of file is 512M.

You don't explain why you move the folio_unlock() call

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  mm/filemap.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 751838ef05e5..5de52deab138 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3693,6 +3693,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  	}
>  
>  	vmf->pte = old_ptep;
> +	folio_unlock(folio);
> +	folio_put(folio);
>  
>  	return ret;
>  }
> @@ -3705,7 +3707,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  	struct page *page = &folio->page;
>  
>  	if (PageHWPoison(page))
> -		return ret;
> +		goto out;
>  
>  	/* See comment of filemap_map_folio_range() */
>  	if (!folio_test_workingset(folio))
> @@ -3717,15 +3719,19 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  	 * the fault-around logic.
>  	 */
>  	if (!pte_none(ptep_get(vmf->pte)))
> -		return ret;
> +		goto out;
>  
>  	if (vmf->address == addr)
>  		ret = VM_FAULT_NOPAGE;
>  
>  	set_pte_range(vmf, folio, page, 1, addr);
>  	(*rss)++;
> -	folio_ref_inc(folio);
> +	folio_unlock(folio);
> +	return ret;
>  
> +out:
> +	folio_unlock(folio);
> +	folio_put(folio);
>  	return ret;
>  }
>  
> @@ -3783,9 +3789,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  			ret |= filemap_map_folio_range(vmf, folio,
>  					xas.xa_index - folio->index, addr,
>  					nr_pages, &rss, &mmap_miss);
> -
> -		folio_unlock(folio);
> -		folio_put(folio);
>  	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
>  	add_mm_counter(vma->vm_mm, folio_type, rss);
>  	pte_unmap_unlock(vmf->pte, vmf->ptl);
> -- 
> 2.43.0
> 
> 

