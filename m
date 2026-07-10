Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA69C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DBF6B0088; Fri, 10 Jul 2026 10:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11446B0093; Fri, 10 Jul 2026 10:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28F46B009D; Fri, 10 Jul 2026 10:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74286B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:43:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 427D51693B3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:43:09 +0000 (UTC)
X-FDA: 84973134498.26.F5E06F5
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E820100003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:43:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/1v8edw";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783694587;
	b=Lw9pcXY83PMryioofpJ4jC8uwWFtSaHQNewrODQM9TVluZmPKEElNrxU8Laij6gI8IAHCC
	9jR50ZrQBcIyhvDm6oH8fXq5ugDMUFZ0frkA/eJFvUwSPTWXpPfaMtIcz8iG6VEKFp+DAE
	waxktUsEClPTNHZDeywWzDDMyXKz2v4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/1v8edw";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783694587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyGpTvPb66f93Uqv/iJz/Z/N+SYM7wUxzDhPSkjZSdQ=;
	b=CwHZsRvf8B45//7I6a5C1S+nb9Zay+hEfM5KBIF2LNKp3fd2Z1gYS5w4blQPFEDac0l17s
	yCaifJaVWBf0iDJ+3qYxbjk6ylwCpDhbgMkZUktuWcZuAycUiNeWwleqPk5DTK8a45Dot9
	vw0DHcBnY+VdD4njrMTfkSpB0uRpsCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783694583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TyGpTvPb66f93Uqv/iJz/Z/N+SYM7wUxzDhPSkjZSdQ=;
	b=W/1v8edwSzcHhuzaj0ZNkV/hS+CprnI7Irx3HlzgRrEw69bGvoPCSVRb6KQiSbfP4vAMJO
	p2ql8cDU9gIAV+GeoD5NCV/NdLpyuPkFAbRykcB7b5YltvJtHmRv9rrhtFvMo4GuZWwYLx
	1AKqfr9Kze9uxIibs980a2l0dda1itQ=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 03/10] filemap: Remove checks in mapping_set_folio_order_range()
Date: Fri, 10 Jul 2026 07:42:48 -0700
Message-ID: <20260710144248.1432278-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-4-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E820100003
X-Stat-Signature: bsfm317mcaesmrre84gi6y55crmsy7b5
X-HE-Tag: 1783694585-980306
X-HE-Meta: U2FsdGVkX1/pHvsSk1yUHCjrfvT2Fym6GNXwvdTwk5+TMqBH34UnHtQuha7z4QXfSy0p6RcR+0SDqN+JKUh1zkqUWPLNdrkthipFsGQCLXQZiI9uRQzqIXjbBVIIL7QARoma7LXwmH4ETJJu2zQQEVze5kScMgqP4P3jMaSwf9j3GDEu3UztUsGN3qEWOe47wqQVMavl3JIjvh9wE7wSMpKh7EbJgAheaveZz6AXkj3y0HIsm6I74Yyfqo3e+dZpANlrqWHpiiQuQroZng7aZn/HWcpk6MF77nlpONTHeLi1gF+hvl1CASKO+LgwsiSzXzthJvOit66p5Bdwx6aA4q5KauwQLwnjCQSLc5hjmIpVlD9fyc8Un1G2Cxg44vN4WIN3cZyyIV2zwPDJPKh23ZwO5saiBH1vXk7hDfC+Pd/7pZL17mpz0CrhWAVvI7hxBG5oI/3DAPZXoqHDHtPwmRd7ZKGpVbaNaUlS2D/itEAXFuRLMg7A+ForYSIzWqhdhOAWFgnbeVwLTHV1aTo863E7dR8FcjkDTXxZ+31xZBpB6tlWdn+ZcfvZiV7n6fTsNbk7SKiXL5zbRb7TzKOqYB8I+DnmEXlEpg79145dAZ6dKrtiwkN4LVAdHGVulcjgSV5mCJYKTxqN5cU2nlqhN9O/6LTy7vwwj5WwQUZivrtCf9Y/yj3VxMrrRB0LRLwhLduFoFwjjofqaci0RGd8Sv+UAyDUWCGKqSGIkcbLER6LLG1b5UeNgnZVlgk3EunfBFjwLfi0XkWlltt0Yvhl3ZZPTf+4YRlEF2mCfLVNN67O/sVPWRloQ51LYkTQXy/BkxH5//jtZcYRXK6YfWMkM99XU2BarQyqal7OIQARYriIXuIipbbrskwMD8S81H9iFAgGw+CHA0rLHnyzGDYi48Nk0VpH0H625eoI+bNV7X32wB2DGH7i/3G5iqOyG/S4V+v6yi0Rb8bGTB4pjhm
 ahWb8UJj
 izw6SQwZIMnp056cEcjEK0MHDFXli9NZQZIdxb6OMkLz3Pt5ug2bF9s4wZYp002wZDk2IWdC7fDxHMaCY8HOFc+9iIwa5YvycqCRhNcnvw1xlPSNji9++1DRwtiCvQEjhSrVUwpI5CDPl9jUkMbmw9uDRBo7yjSHNfRYDzF9KXhgBRWFY2wk9h6SgIkj8OuCDCGxUsHlsmJ9r5xRycKF0g4/Q3NJXgzpn8qPYw9+QX6s7W8vQ7RfD9+NY2cX3ZzZALJGEmDpF+/3UeKClQY1VuE/l488Iw9tJHPt+OFBAEGCeFQxnqv7Ej+ZdPmkgfHFDdt2yyqvMGJOsoWtHCKsd9MF4fCFVj26k8GVSgv1B2kLQp1sde622MoGmschSXb/ET04wFTEsTnHE8/HIMEkZiMrmeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:31 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> These checks make it impossible to use mapping_set_folio_order_range()
> in hugetlb.  They add very little value and can simply be removed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/pagemap.h | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2c3718d592d6..d0c9aecaa4ac 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -405,29 +405,18 @@ static inline size_t mapping_max_folio_size_supported(void)
>   * @min: Minimum folio order (between 0-MAX_PAGECACHE_ORDER inclusive).
>   * @max: Maximum folio order (between @min-MAX_PAGECACHE_ORDER inclusive).
>   *
> - * The filesystem should call this function in its inode constructor to
> - * indicate which base size (min) and maximum size (max) of folio the VFS
> - * can use to cache the contents of the file.  This should only be used
> - * if the filesystem needs special handling of folio sizes (ie there is
> - * something the core cannot know).
> + * The filesystem should call this function in its inode constructor
> + * to indicate which size folios can be used to cache the contents of
> + * the inode.  This should only be used if the filesystem needs special
> + * handling of folio sizes (ie there is something the core cannot know).
>   * Do not tune it based on, eg, i_size.
>   *
>   * Context: This should not be called while the inode is active as it
>   * is non-atomic.
>   */
>  static inline void mapping_set_folio_order_range(struct address_space *mapping,
> -						 unsigned int min,
> -						 unsigned int max)
> +		unsigned int min, unsigned int max)
>  {
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		return;
> -
> -	if (min > MAX_PAGECACHE_ORDER)
> -		min = MAX_PAGECACHE_ORDER;
> -
> -	if (max > MAX_PAGECACHE_ORDER)
> -		max = MAX_PAGECACHE_ORDER;
> -

This one is a bit interesting, This has been useful to me in the past when I
was trying to [1] use mapping_max_folio_order() for force_thp_readahead order.
On arm64 with 64K base PAGE_SIZE HPAGE_PMD_ORDER is 13 (512MB), while
existing MAX_PAGECACHE_ORDER was smaller and the cap is what prevents generic
page-cache code from advertising that unsupported 512MB order due to
MAX_XAS_ORDER.

[1] https://lore.kernel.org/all/20260601102205.3985788-3-usama.arif@linux.dev/

>  	if (max < min)
>  		max = min;
>  
> -- 
> 2.47.3
> 
> 

