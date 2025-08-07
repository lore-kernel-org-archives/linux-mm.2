Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EBDC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9E76B00C2; Thu,  7 Aug 2025 13:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969266B00C3; Thu,  7 Aug 2025 13:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886346B00C4; Thu,  7 Aug 2025 13:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74D6E6B00C2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:23:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA6A91DD965
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:23:39 +0000 (UTC)
X-FDA: 83750633358.12.D54CECF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB9BA8000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:23:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZbzgDWhD;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754587418; a=rsa-sha256;
	cv=none;
	b=8EI4LKSG+tdQk2KrnuvgvkushGzWe2EKnWcY8CHmaEG9hd8l2A/S8TlRfG34mVaGbrUDck
	nDy6UBb7iOxeixlcnhmpull4+WytYD03/5PYXSnldJBsGVS67v3TLWliuPqlQDPkUkqrBF
	WBDslcr4mnuqyqbqfn5esCue1pqm/KI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZbzgDWhD;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754587418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+PEcY5X38+TutgVZ5B3E+Djvpy61amQcaiukWSfVUw=;
	b=eL9HJ6cGDUQE8+F2CXMDwNBleoHgBJh9tYfT5YrVyVL39X9r2D74E2FGjoC7m8ZX45vpqk
	pOrTr6qAozmV6SNxR8OYEdDPK3yFIfEobaxf9zCI74sP+A5De6JLiGulBcPgYfiQIylTQ8
	ipiTqO5nmoHOyE6Lz4pZR8Mkq6di0A4=
Date: Thu, 7 Aug 2025 10:23:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754587415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+PEcY5X38+TutgVZ5B3E+Djvpy61amQcaiukWSfVUw=;
	b=ZbzgDWhDhZpua1Eh3FH4y0TFiu+V6ZI60Ke3j9V/xYLECXyms2lUrRHDP3+4PbvDgbWGO8
	0wxWxcOtmDUUJn/y8uVR2nOEutAvSMcs8sd39chu4PPbLREkQ/0BgfvYPSjYH2sYXMDkLk
	cGbHSChsn9yzopP/a8Ft8CpsrHITjCI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, hch@infradead.org, wqu@suse.com
Subject: Re: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
Message-ID: <ytwxjnw4ioieognqrxlyuppbsndge4q4huyjdkdfo5rj2s36ny@oumr35d336vf>
References: <cover.1754438418.git.boris@bur.io>
 <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB9BA8000C
X-Stat-Signature: amgfx8kp8k8fjjnow9d9b1ewucq33s9d
X-HE-Tag: 1754587417-730710
X-HE-Meta: U2FsdGVkX19NHbi8EAh+Gqghi4xX3Gt1IbumuE9UV8+icQ+cOqmi2aFfFwpwK5S/IJ9LEC1TWk4DahiHN5RxKBvf89maVItv0/SZAbZBC56DmuaPod0emFsza0tl9x67+sDOj6yow8kPXcEvJjZPAfwyGKAqltY6f29K2wt+8K/kzapJ0MRf4k7LXqw+6Pmex1BP6pDeVYTdfdN43WqnBEBpaqn/VXJ4GCjgjubATq1xp2nBN4wD0qavriGTbGwTWAMncy5owH6s1yBbmvHhgxDZFnEs2kwSjkuc1kiGTxOvM5UUVJyoYBOJyx+jFuoJxBS75JuH9a9fcAQPLHL2R5Sa+3SZcF5AaTyucq9cxMG4rd8MXutRieKLb9pF6PmHQd9DboZwJvly5QpeNu6lRVvpOicMWOh6tCPXr/EmYBLVQCLT4iT7c2Y1oHF92VG/WHGcml1Dzv485C7UQVY5z0Q/eZHYWjnOyYZblncNYf7PU/+nf6CPRkuEJuNlGnen9IlrbQGMdrPtNnQSn53jknWzpq/dLisfVlLgX/xJKHt2l0HM7NHHq4b+onabH5a28ldXvc5k6QWxryC5Pbh0LnP3DpCO0QMOpWegyduCwzOrsj/b0ab9TL02c2L8CPuh6gswSoMVJHT2fzZ2XIYunO8xm0JMDJz1OS6CnqyXP78ZsxgzmWTOAd6uEk74pjxzHGXK/JW+uLqeRTD10cRsWHCL8+5w9HYcbA7/Pq61+0m/E9aKAw9dnLOOTZAdFtRHLDAF/cPHQlyFNAcTT9dxRLdPrEK19ixuXp9V5pB2ys9uwyLNQl90gRAVpEr17auEEp4QaNLQ4BUMIdeZlAdNjkTQzSbDXL8L1GlGmfSh6nCMEnsjqAEAFKlJohNMz+rHQZiiauckXYj7pPthEDxXU1rwbOqN6W1FspiySR9brpUU+8FROOQQRU/X2X6aLp3wMNy6fyaSm7xsojzVjLm
 6LDlqIg9
 1VJE9yFqmxT+V6Cv208jO2r3I3BGHy+s+rrq9X2I7f2mJ+tBvlqsGSMpCfrWHULTWyWkC3Cv3vQyE3S6LEWGydtq8gEWWeVxOVqLyopnQbRTSUw3hlm4P/rJSyI+9vy4hZ/g1fEyZgKc3YYn6IFXF0h0kNhWcD/sNU7/Hk0/UqZpty67O7Jmn8imfG13c/fdnyHDtG13iG4L6/jcbkdmuq6ygRYKUV/f2LXO3b8TADw0PQj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 05:11:49PM -0700, Boris Burkov wrote:
> If cgroups are configured into the kernel, then uncharged pages can only
> come from filemap_add_folio_nocharge. Track such uncharged folios in
> vmstat so that they are accounted for.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  include/linux/mmzone.h |  3 +++
>  mm/filemap.c           | 18 ++++++++++++++++++
>  mm/vmstat.c            |  3 +++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 283913d42d7b..a945dec65371 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -241,6 +241,9 @@ enum node_stat_item {
>  	NR_HUGETLB,
>  #endif
>  	NR_BALLOON_PAGES,
> +#ifdef CONFIG_MEMCG
> +	NR_UNCHARGED_FILE_PAGES,

> +#endif
>  	NR_VM_NODE_STAT_ITEMS
>  };
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ccc9cfb4d418..0a258b4a9246 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -146,6 +146,22 @@ static void page_cache_delete(struct address_space *mapping,
>  	mapping->nrpages -= nr;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
> +{
> +	long nr = folio_nr_pages(folio) * sign;
> +
> +	if (!folio_memcg(folio))
> +		__lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);

From filemap_add_folio_nocharge(), this function is called without
preemption disabled, so you will get lockdep warning from following
chain:

__lruvec_stat_mod_folio -> __mod_node_page_state ->
preempt_disable_nested -> lockdep_assert_preemption_disabled().


