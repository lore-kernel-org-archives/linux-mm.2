Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F1F606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWVkNKgi
Received: by kanga.kvack.org (Postfix)
	id 3BA066B05B1; Sun, 15 Nov 2026 16:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A8F6B05B2; Sun, 15 Nov 2026 16:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25BEB6B05B3; Sun, 15 Nov 2026 16:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD1B6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:40:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 432CAC085E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:40:58 +0000 (UTC)
X-FDA: 85438673796.10.F4219C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C47A120004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:40:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWVkNKgi;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794778856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/S4safQyKYUMDZEkkF+xHbEVNllVyYJAylyJJpX9130=;
	b=SAHKe4oUo9t7iSlFvNaVMndlQMA3VZqt1G9R22Vkk0dJVEa0COYwrPLQxYMkdKPeimv9wV
	GGfoaZuU+/4KyFOy+EDiKbwmlOYHP7c0NqDWy6+wutQ8RGbFOwiv4b5RT90tfWdaEAptiR
	77FxZvSaA/Sw2mISFVU8QFG5KmGL/GE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794778856;
	b=hk5zqYuzqM6C56CEveukXi7J+bZr/dbdGuJf/o0+hkh/Ck7gYEumwLO02eSvi/hEgMu9oW
	dhIMnLOcrsebDq/tn8uMiIHM6mweUJiFvgnXvJgT84kQqsR3KC1m5Tz/EuEDdzzgyXsWpE
	LViYzm3GBcmtWu8OnrGyM28aS5ca/RU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWVkNKgi;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB1C140371;
	Sun, 15 Nov 2026 21:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786FD1F000C4;
	Sun, 15 Nov 2026 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794778855;
	bh=/S4safQyKYUMDZEkkF+xHbEVNllVyYJAylyJJpX9130=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWVkNKgi4HAVgO8yxvzbUMZttdMuKNSYPsINUauhthdooX0XbZajxOS2XuO7BKuuz
	 il0y12Av6NcQ0br0vqEgBkunDDx2coVcTbzRpofRk6rZLw8+ZkGO8tRv3F4NgkLb/v
	 sSSBlPO/bZPQBEb+mz9xpvDaqZqHwflDT1jNU9IHpJzzxduiWbkzzzBW2JprvhpkrB
	 hFb6BYHi84ggRLqTQBNdj6hNfSo9pKvOqdVnyc9Sk0XuzqDak7mzUqh9E8L+WA21hU
	 +vBhwaRw8u5YntysRdWVzzb5QJRVoBAKi1uTLuEsQ/lmMAY/b0W1XbBE/MQJJ5Lepp
	 TvECQSOXhOyuw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Sun, 15 Nov 2026 13:40:47 -0800
Message-ID: <20261115214048.103814-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215850@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xcndjobd5y8hx5tg348yea7izfensfq6
X-Rspamd-Queue-Id: 8C47A120004
X-Rspam-User: 
X-HE-Tag: 1794778856-995565
X-HE-Meta: U2FsdGVkX19YZOFIR5UckFFMGBQqtjSSfjLHdATCLePfYGdoeFCppIeTh5jjZWuPILM3pFkc8YTYs1DRLSDSSPXyL/VyIhJYYTawAxBrS+T1JaP/iW/teiOuW/GEKgbUId2EfqTnvt/o7AWLvsFvKTi3f9s9o53LyfxZmaG7F7kJuCcJR6CN81FpmP5/UhewD8L4wNeIC2QD5HTij7yfdFXnGANKCK0hG8WSVgC5jqCMvik6b8a1+YD0e4gFB8cX0vB+zDss4bBMqE5e/JjFzGhEuJ4z5zTFlOcBgqV+IikJIPm71xMInmuNRXZN4/7bMasvRVEcBgo0XiR8eGy0b9IoYY0DxO9e8cBBs/FksdmND/VQUXaLeuozKPIH36gi8YDwPvmtSrQiVXpjlJAVvzlvJGVqxQGAReZJntGQ5Rif3UAor1V01QE20x6NJtOb/c/6em/af59tDk3jk/9dcvtXPcUg7hsvsMIwf95aMDeFufxvJSc8h5I/clE8hLnc5LeENXSHXl/d+Ik+uFhm9HFvuum3X29VlG7/a6Mi+Q/NCO8m284QTXOmu9ehDFvFACmZovtpFavybL9tA3UVtX++XezaLmsHxNdIw6itBcBt3ceXBgE1IT/sa2WWZGVJ2kBz8swCGcUhvp+9IhEJlOIShmMEZJT8tDzw+G/qNlY51NRaeiWh7lRW92qKuSebjdsjbhnr9PF7c+dZifSVy7JUipOxBhDyyZURXFZK1nkNvFM00u58BTpEGg7Klpq58enzEY1Xyp70oKV+usxidl+5aJQlvDDGwQGt618y9r/noc+Uv1mrBKN3sdzJk/YCq68DPK9nNpZ33zHtexv4WoG9DTYb1p/NJ9f7jV16H0jDy9Afv3coV5I6z7nqb80ifNiKh/LkovseS+qPZQMnW7WOgxqSFnyMQJIpE0qoV2LePfRLTYYphnN4j2NNpWI8nZY0wSKK6VaNxEN60JS
 JnxB0bDk
 PnNwdoLIIQ65R2TGRgqfELn6bW6XjYN/A+lNNBnum5rBmb1RsFKmwtx3P3uy4XBgFQ51tF4HrRo9rHUaduUYgAyStF2s1Bcu/nUsqyIEMSsQuFqZxumAUCfrEP6k365JYG8laU460vserp3RFFg4K+fAamP2gd09Uvws/dXzUnJ67mCFq/XLNzpRLB++MvS/GyE2NRa0+Nk1aIavmn7UQ1HJLDkUFkRrpGUt881H+xgGpxtb8yW6eyZrRx0N5kPR5DjmfrYlunqpek5HYykCXc1OnuBCDJELPONuf8SlD6YPpIT+bO7DNCia5xbtPrGy3pfCj36V8Wd2DqhIib0sHHwOUsySUN2KmIiHU+VySegZCfWn6UfMrQGCR+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:41:34 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm/damon: out-of-bounds and uninitialized read in
>   damon_report_exist()
> - [Medium] mm/damon: phys_addr_t truncation and unit mismatch in
>   damon_pa_filter_match()
> - [Medium] mm/damon: uninitialized filter->report_type in
>   damon_pa_filter_match()
> --
> 
> commit db7c0b8660ac4e99fdce33921b7535218eaa4dc6
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/paddr: support REPORT_MADE type probe filter
> 
> This commit adds support for the DAMON_FILTER_TYPE_REPORT_MADE probe
> filter in the physical address space operation set by querying
> damon_report_exist() over the last sampling interval.
> 
> > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > index 5b773012a8764..04e95047f8cea 100644
> > --- a/mm/damon/paddr.c
> > +++ b/mm/damon/paddr.c
> > @@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
> >  }
> >  
> >  static bool damon_pa_filter_match(struct damon_filter *filter,
> > -		struct folio *folio)
> > +		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
> >  {
> >  	bool matched = false;
> > +	struct damon_addr_range addr_range;
> >  
> >  	switch (filter->type) {
> >  	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
> > @@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
> >  		else
> >  			matched = damon_folio_young(folio) == false;
> >  		break;
> > +	case DAMON_FILTER_TYPE_REPORT_MADE:
> > +		addr_range.start = pa;
> > +		addr_range.end = pa + 1;
> 
> [Severity: Medium]
> Can assigning pa and pa + 1 into addr_range truncate 64-bit physical
> addresses and miss reports when ctx->addr_unit > 1?
> 
> struct damon_addr_range defines start and end as unsigned long, so on
> 32-bit PAE/LPAE systems where phys_addr_t is 64-bit, physical addresses
> at or above 4 GiB lose their upper 32 bits (and pa + 1 wraps to 0 when
> the low 32 bits are 0xffffffff).

Missing a report for this edge case is fine.  It only degrades DAMON's
monitoring results, which is anyway best effort.


> In addition, when ctx->addr_unit > 1,
> pa is aligned to ctx->addr_unit, so setting addr_range.end = pa + 1 only
> checks the first byte of the sampled unit instead of [pa, pa +
> ctx->addr_unit).

That's fine.  Technically speaking, the sampling is only for the sampling byte.

> 
> > +		matched = damon_report_exist(filter->report_type, &addr_range,
> > +				jiffies -
> > +				usecs_to_jiffies(ctx->attrs.sample_interval));
> > +		break;
> 
> [Severity: High]
> Does calling damon_report_exist() read uninitialized or out-of-bounds
> elements from damon_report_queue.reports?
> 
> In damon_submit_report(), the report is written at queue->reports[tail]
> and queue->tail is then incremented, so queue->tail points to the next
> slot to be written and is never wrapped when it reaches queue->size:
> 
> mm/damon/core.c:damon_submit_report() {
>     ...
> 	tail = queue->tail;
> 	if (tail == queue->size)
> 		tail = 0;
> 	queue->reports[tail] = *report;
> 	queue->tail++;
>     ...
> }
> 
> mm/damon/core.c:damon_report_exist() {
>     ...
> 	idx = queue->tail;
> 	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
> 		report = &queue->reports[idx];
> 		if (idx)
> 			idx--;
> 		else
> 			idx = queue->size - 1;
>     ...
> }
> 
> Because damon_report_exist() indexes queue->reports[idx] at queue->tail
> before decrementing idx, it reads uninitialized heap memory on the first
> iteration while 1 <= nr_reports < queue->size (and never inspects index
> 0), and reads out of bounds at queue->reports[queue->size] and beyond once
> queue->size reports have been submitted.

Yes, I will fix it in the earlier patch.

> 
> [Severity: Medium]
> Can filter->report_type be uninitialized here when a new
> DAMON_FILTER_TYPE_REPORT_MADE filter is added via damon_commit_ctx()?
> 
> damon_new_filter() allocates struct damon_filter with kmalloc_obj()
> without zeroing the union, and when damon_commit_filters() creates a new
> filter it only copies union members for DAMON_FILTER_TYPE_MEMCG and
> DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
> 
> mm/damon/core.c:damon_commit_filters() {
>     ...
> 		new_filter = damon_new_filter(src_filter->type,
> 				src_filter->matching, src_filter->allow);
> 		if (!new_filter)
> 			return -ENOMEM;
> 		switch (src_filter->type) {
> 		case DAMON_FILTER_TYPE_MEMCG:
> 			new_filter->memcg_id = src_filter->memcg_id;
> 			break;
> 		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
> 			if (src_filter->range_max < src_filter->range_min) {
> 				damon_destroy_filter(new_filter);
> 				return -EINVAL;
> 			}
> 			new_filter->range_min = src_filter->range_min;
> 			new_filter->range_max = src_filter->range_max;
> 			break;
> 		default:
> 			break;
> 		}
>     ...
> }
> 
> As a result, new_filter->report_type retains uninitialized slab bytes
> when damon_pa_filter_match() passes it to damon_report_exist().

Yes, I will fix it in the earlier patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=14
> 


Thanks,
SJ

