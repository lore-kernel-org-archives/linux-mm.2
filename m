Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29948C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 22:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C807C6B0088; Sun, 13 Sep 2026 18:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F036B008C; Sun, 13 Sep 2026 18:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35A26B0092; Sun, 13 Sep 2026 18:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61E9A6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:34:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C9CCA0ADF
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:34:40 +0000 (UTC)
X-FDA: 85210194720.28.BEDA174
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id BFB2114000A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:34:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cnBOn5Qk;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789338879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXQ36z2FmSwis8KLkaw/kb+F0G2d5cEXJpcdmkEhIQY=;
	b=U/F/ib53Dg92EU/AygfE+9GJkIWxbYTefwOZ6tj/vF9XAJHKQDrawkRorLtuXRVteSH6BU
	lxtMde93ZkfRMUEJvVz7NOnmworNXannJQc1EYLokzH1ByRLvgZSDRgARmA3lbN4NToXL+
	lbXiKByb2tjSB2Y2qF9AHlRf+JAev6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789338879;
	b=bcWwhjLq1MeM14jC9PNKfhC0ZHlyp9hcYgIeTQtav0MFpfJkpI+4M/AiI7daYt6Wr+V3+3
	PzL1Q+k79137SmDb7fmMrvalS+e7xuKWTk+sj6tuLlhryELbQ4Bnsncp9EmIlT3o7nRKZ7
	iP/01zRnxKB4aB9ckS02zyUAeNBErkg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cnBOn5Qk;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kXQ36z2FmSwis8KLkaw/kb+F0G2d5cEXJpcdmkEhIQY=; b=cnBOn5QkHzhg85PE9bOpVT7I95
	2HMYhIEabssbaPxm/k3DgvO4iUxqmaWC0jJx1DHGANiaWZ1POZnV419qDgILRyyjVNcIQuEVdFV7m
	bdDvJQsXqe7E6X6OZ1MH+eYAhUDyXb6s2nafxyAuOBTo8bl8VI1ULnmMeCnn3FRiKP2BJWuwUfsEw
	vHkq9YTU25l4KK5LkotAte2eh4oG2xUB+wZwVIdoq4oGL1W62R9R9KTa0IsB162D8b0TbailCIelR
	ITeJ4gWUoJ3HJFZIsYJLev/vk9y5zeURWBrzSi7UQhUT5XdkYgJ4P4uFoUUic9byRrx5VEcxzC5i5
	lRuRrMWw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5smI-00000007M0P-3ftY;
	Sun, 13 Sep 2026 22:34:27 +0000
Date: Sun, 13 Sep 2026 23:34:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
Message-ID: <aqck8rfGByZhdtqT@casper.infradead.org>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFB2114000A
X-Stat-Signature: s84bryz9p3ecsjhyzhra7a1bjyx9agp4
X-Rspam-User: 
X-HE-Tag: 1789338877-394799
X-HE-Meta: U2FsdGVkX19DYbrDYFGbOYb4be97KRmPnn6vl7OevXBgyI+2SSfRhWKIgHZASITSkpeOvcmojFVR446wUvMzHzd3c6mC/mZXr8zGu6YXpu/TC0XszkQfe5P6pjvhOCRKm9WMgQYIzNKP0v2HnCGLvWwB5l685ziug/Z/Jw18YxINUK3cx2B2Z79DUyeAvwE7TH9p1WULb85qxMZRJxJjoKnR1QjHyQJdK5ARQiBRzA3RANWkG0bILIzzJYyJFuaUt3EFpp43LlclHFWrQRykf1gUzoX22XRFhOTgkWut7n7SMp2TNRKgFoEmSpiSOcyFQxz6Z69ufnBMRrmwKisZtdJ91n2tzce4h2zx2SoBdj0HtJd4K7jsbism+Ez1HtWj5xx088Xh9ZOFjZ2gFEL1RoPp9E3Rv3EdJ7V2hHLFouIiV7dtK1Uu2dSkJQGntUBv+4O33J4y8UEAMElN+yZW5zAjRjhoqecPkSxJoa24j6V/QoeS8U19s+kaDClC6isLu5cWfqrYv0Lfj7iJves57R6LWCsJNZ7Zl9ktKwIneD2uBCth8QmOmtg4B00AanpcoaVPv9PTOthpD7HSaheBQFZeU8hOKibLSrbeVZpwJkIwdo0HYcrOQ8oKkPAIXLXj1pEaDDiSj2NU53zpDtTj+I1LDoreHagQ05MCrRHKnlvFvtWCz/HAqoISkrWSRt2mWTqIiu5idecOzZIgNkcUm9WXStCohEX2Tl0GFSAldQt2J5RlfAxeLoGIDrvWj/dmvFayz4bW7Q2Enxb3Bm67kZZesZNe6MxWvWfH7zmviWSFt1NUwBFbtTYXyIQqLu40VmNgH2zTAZJl02uCzj1vXT6TaKRZ8aogQrlzQqljy5bIU7Ml2477Jh96to0TzIQNsGs3axm8gTMoDVWbeekwMteYjS609Don46IHW/y2NC23jcEqFo8U8VDttaPyFFKmOvo6oMmxm5FTdHiZvFq
 ynLGM8+d
 E9z0UhdMpWpx4CMowTBafglXhDa3uErQm9LuRLYM7rxZIj36rX7nanpbdJC7KmV9tQJuh1ur8l0OyT7UHNfPudbLSoX+21yrl/ApKixqUYJi93frEyxBB1OR3nyM9OeGG1ZXlq1+8EC49+53YB1B4fxQhUj2brEODnJbasEiw7D7slwcC80ji74gqASGO4JOs+7Rv+hf3CtFCfsnkzonFT6pSyN5Fe1Cm7itX9MVj5UWrWo8GxIqRYgQFC2gNCwAWC8UXv8g8MQhJxh2aWRp8sATUxDMsge6ueqThzmFMJPbI9TjbSNe+jEn8sfT1/ph4XGpEcVVg3tg2m8m21c19ItuuHUyDpXDt7VyvmJFxMcN80GgwxpsyK/i1ynKI8fbuEmUJNg4/grvs9DE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 11:36:44PM +0700, Nguyen Ngoc Thang wrote:
> @@ -2271,6 +2272,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>  
> +	/*
> +	 * Take invalidate_lock before any folio lock: the readahead below
> +	 * needs it, and truncate holds it while waiting on folio locks.
> +	 */
> +	if (!is_shmem) {
> +		filemap_invalidate_lock_shared(mapping);
> +		need_unlock = true;
> +	}

I'm not a fan of all this surplus commentary.  And what happens if e
simultaeneously truncate a shmem file and collapse it at the same time?
I know it doesn't use the invalidate lock, but does it go wrong in some
other way?

>  		} else {	/* !is_shmem */
>  			if (!folio || xa_is_value(folio)) {
> +				DEFINE_READAHEAD(ractl, file, &file->f_ra,
> +						  mapping, index);
> +				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
> +							    PAGE_SIZE);

Not a fan of the overly long line.

				pgoff_t eof;

				eof = DIV_ROUND_UP(i_size_read(mapping->host),
						PAGE_SIZE);

or we could cache mapping->host in a variable called 'inode'.  We use it
in four places, so that might be best.

>  				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> +				/*
> +				 * invalidate_lock held above; don't retake it.
> +				 * page_cache_ra_unbounded(), unlike the readahead
> +				 * helper this replaces, does not clamp to EOF.
> +				 */

Again, remove this comment.  This explains why we're making the change
in the way that we are and adds absolutely no value to the reader of the
new file.


