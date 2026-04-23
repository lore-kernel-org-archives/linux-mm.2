Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03168FDEE29
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3472A6B0088; Thu, 23 Apr 2026 13:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F80D6B008A; Thu, 23 Apr 2026 13:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6876B008C; Thu, 23 Apr 2026 13:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 078516B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:15:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9620214038D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:15:21 +0000 (UTC)
X-FDA: 84690471642.18.533531E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54ABF10000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:15:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IWyrGBjX;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776964520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFftlaJQns74Njz4lBEQZzjlwXSymXeQGxv3fxsHDy0=;
	b=HttCYeOUFjtFCpqlSDBWB1a687hFJZW63eJgNRkDhVZWulPG7qTbDCn5clfy8+uM3Brcsv
	iE6bZNlovSYoETqSJ3EFaXOQ1b/ot2l29RsG2CNfMsI4eaRF8OsM6oH0KlHTH0yAl59pJv
	ua1rWV3QWv3SOqx2a++bNhtLSVBHpYc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IWyrGBjX;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776964520; a=rsa-sha256;
	cv=none;
	b=JwOQLwFQoi5vcaGLn7RiK5WNyKiiqHrJ3ANxZRLrAzQSrpyvD1qqZEMRCDXZHl+R1jvi8e
	DXX3pxRxOKPbblJGLuthHZlXO7g96stoWPwANZrmKzb6uo3v7JdTf6GaHWYGEJJde1s43n
	gQI1A/wbBlfpvrPL/dTUXP50nkGFOu8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DFftlaJQns74Njz4lBEQZzjlwXSymXeQGxv3fxsHDy0=; b=IWyrGBjX3QQb/kuGhdQ9SF9tUA
	UyiHzbtFTvSQcC4vmEx12CvFU7wYB5/d2YoBfTA2IXn5cX2dvBk9OXbEvqTgmysugmKVjqYGs/wpE
	f6Co9AV1AU9Su2qSHiBaie7loJt6lH9SaPVJUqZztwhSVwCS5Z8ZBJZjUqOUlkwqs+a+bx6svuMoi
	oOfarXxZNTAQfanvLbA/Po+tGSK8kL7/UMmIEpUNa8XCDXrdlE6ZtFxzFaIqrg/jWQnzMMEYCJNRp
	MV5xwSgLfwZ8bpffbhj/ygmw352fOh1zV0wPe8w8O6QaLx9myZlQvIaJu1HsTIgOVz+Ks1L93myMN
	DBCtp+cA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFxds-0000000Dmh7-1YQV;
	Thu, 23 Apr 2026 17:15:08 +0000
Date: Thu, 23 Apr 2026 18:15:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
	mhocko@suse.com, hannes@cmpxchg.org, shakeel.butt@linux.dev,
	riel@surriel.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aepTnIu1WiyyHNJp@casper.infradead.org>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423164307.29805-1-jp.kobryn@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54ABF10000D
X-Stat-Signature: 9bmwp377c5rrbypqojk7yiqcakpukyrn
X-Rspam-User: 
X-HE-Tag: 1776964519-53440
X-HE-Meta: U2FsdGVkX18UbJiMVBdfDn1bDW+EF94TxD634xCymT/huTvmM+801CgMiapcCNgfzXAYI2d+Y8XZwUw5ndWzSvwufirMOqP3W2tUX874Q3iNsNe1NZauztgJGnFRqj5PPrpT5bzQa5WNKYshZO5juLTZwcOqEGC3deKs5JkPNUEMwznlTgTHnnreCWHcEgxNbZJuBRF/+1IeGNwIHcxvfYEHfu1K8wZzl2imFtrfWFk8t0OzfS9humK0aZNt6mZD74jUMhUkJpQDR3BRp6l0pOSJZzbLl7Kd6eUB4lxTWoiSozCAS4X/Nn+NVfQFg08jzOouRBwWxEsqIsOjOdlFLY/WFgIu7jUIuTa9Kvp0dQFRNUHn9TijGBBQaZg7beBPqj6FQ85V0xhr4zzLo+sVQtnXyY+WdaqWbMZS40+Y0T794cdCgN/dAjJKnkVownFf4davbVb9dTxx3ynY5nrqXPyrLwHP1DNIahDPmz2mLx1gl6DwLPOXHI0wqsu/y2EwSQH3BBYU0sZDvHBk3pq28CmepvavE2JV6yIGdeQdK1NJHNcOAZs2yFl199fdquL5oj7rziDf7b1vnU4foVkORkh1BBdSIiDKUNVz0yjuAEyT1ZAbHm+swoJBLrfFeqFjFz0MzDwVhbwMYH4zb+l1BV4NSX2VH1Tch1bPxvZMwlQPSn/J0u7525BaAMwAJKWBhmQhVFwoq+kGnFwL3G8MDrGSTgZd8JKqLcUBVgUlA4EDxakEQtMx7wdvEp3rCkFLE0N+uc2DGYzz/Ou55SZRDaRcKlsUgNpxtBv+8tqEMm/x5Rywgldeh44ddMj0GllkgVw0ep+T+ktZrM2APAVaYNvPwTW3bRynpU+XQgXXdMQbYVhtDqwx2Vb+bi0bXlqUApjgMqBfxt/ZxQtBpnVacDK586Iopk+uphcNvuzrmp/vKyzhdJrjN6D5koTMvq/biIRJ2RS0jWd0OY1CDGX
 pW+HfvfH
 MVHnhudy3SgZy2KUJ8I9WwS+JldnZdECwFsflVXMs1NLkbLG2VQbIVq9QkrE5/6ymYSNub6d72m2VRE9hSJtt1lNYk9sZum278p5K5URBLGXs2xrXZ+hb7LHfYnEIlDwFFB/dHx74/DOZUNHoNNTPlz3qcdL37r8AvcFJUmiG0ts69WBNHUjLODNQYzATpbdzNW+rpeLV5JB8RsbdE5Ca7pQyzOHtpRVVKrvKEhEHrSgcoPQwlE4V2mah7o30h+vET/3Pi7ULjTpCXAjrC4VmZYnBhfhV8p9+9CPamadLuuBy6fVCRLG5cfYfHOjJ89t4wSdd+cKARPjsIuTCCfXbqYb5MRJhdlyxLGDb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:43:07AM -0700, JP Kobryn (Meta) wrote:
> Of all observable lruvec lock contention in our fleet, we find that ~24%
> occurs when dead folios are present in lru_add batches at drain time. This
> is wasteful in the sense that the folio is added to the LRU just to be
> immediately removed via folios_put_refs(), incurring two unnecessary lock
> acquisitions.

Well, this is a lovely patch with no obvious downsides.  Nicely done.

> Eliminate this overhead by preemptively cleaning up dead folios before they
> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> remaining refcount is the batch ref. When dead folios are found, move them
> off the add batch and onto a temporary batch to be freed.
> 
> During A/B testing on one of our prod instagram workloads (high-frequency
> short-lived requests), the patch intercepted almost all dead folios before
> they entered the LRU. Data collected using the mm_lru_insertion tracepoint
> shows the effectiveness of the patch:
> 
> Per-host LRU add averages at 95% CPU load
> (60 hosts each side, 3 x 60s intervals)
> 
>             dead folios/min  total folios/min   dead %
> unpatched:        1,297,785        19,341,986  6.7097%
> patched:                 14        19,039,996  0.0001%
> 
> Within this workload, we save ~2.6M lock acquisitions per minute per host
> as a result.
> 
> System-wide memory stats improved on the patched side also at 95% CPU load:
>  - direct reclaim scanning reduced 7%
>  - allocation stalls reduced 5.2%
>  - compaction stalls reduced 12.3%
>  - page frees reduced 4.9%
> 
> No regressions were observed in requests served per second or request tail
> latency (p99). Both metrics showed directional improvement at higher CPU
> utilization (comparing 85% to 95%).
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> ---
>  mm/swap.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de9877..71607b0ce3d18 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -160,13 +160,36 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
>  	int i;
>  	struct lruvec *lruvec = NULL;
>  	unsigned long flags = 0;
> +	struct folio_batch free_fbatch;
> +	bool is_lru_add = (move_fn == lru_add);
> +
> +	/*
> +	 * If we're adding to the LRU, preemptively filter dead folios. Use
> +	 * this dedicated folio batch for temp storage and deferred cleanup.
> +	 */
> +	if (is_lru_add)
> +		folio_batch_init(&free_fbatch);
>  
>  	for (i = 0; i < folio_batch_count(fbatch); i++) {
>  		struct folio *folio = fbatch->folios[i];
>  
>  		/* block memcg migration while the folio moves between lru */
> -		if (move_fn != lru_add && !folio_test_clear_lru(folio))
> +		if (!is_lru_add && !folio_test_clear_lru(folio))
> +			continue;
> +
> +		/*
> +		 * Filter dead folios by moving them from the add batch to the temp
> +		 * batch for freeing after this loop.
> +		 *
> +		 * Since the folio may be part of a huge page, unqueue from
> +		 * deferred split list to avoid a dangling list entry.
> +		 */
> +		if (is_lru_add && folio_ref_freeze(folio, 1)) {
> +			folio_unqueue_deferred_split(folio);

Would it be better to do this outside the lru lock; it's just that we
don't have a convenient batched version to do it?  It seems like
there are a few places that could use a batched version in vmscan.c and
swap.c.  Not that I think we should hold up this patch to investigate
that micro-optimisation!  Just something you couldlook at as a
follow-up.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

