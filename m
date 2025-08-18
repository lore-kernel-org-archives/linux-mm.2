Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA4FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 04:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B213F6B00A1; Mon, 18 Aug 2025 00:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAA26B00A2; Mon, 18 Aug 2025 00:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9997D6B00A5; Mon, 18 Aug 2025 00:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82B3E6B00A1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:35:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0098C5B37A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:35:30 +0000 (UTC)
X-FDA: 83788614462.19.C549B3B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9E78180005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:35:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f5So7M/P";
	spf=pass (imf24.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755491729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Qr7GKeY7iraK1JMYtgr9HkjBsEWy/WVlfeLC9I+VeY=;
	b=GEVoayqVZHoFDABmIuo4LyevtYjHTXudO8gWkA97I4S12OtrrwRYzKRX+BsWvlNDYEAWTK
	1+6qeqxnT6/8P+ra92wbWGBogsTOXWbSqw1PZj2Vzx5B9q/zNB75NMt4nqC8ZSyLGEBfBf
	dYIpxx/E6ULOBPWKyF8giiuZuRC3nj8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f5So7M/P";
	spf=pass (imf24.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755491729; a=rsa-sha256;
	cv=none;
	b=Su6jR9GLhvnnGy4U3i4YbC2SVyJeFUb1ylW3lpfGwfmbOH48esqtywJOARu/uWLsjWv6E2
	hpI5uDaLdI69tL3gbbH5aI85QvueeHYmfMXfpcdTsy9kZ9qYdmzsdNZqdX5229TVSV3M2o
	N7H1CSb2O3OUBKjOGpPTpsijHWG9d94=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755491728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Qr7GKeY7iraK1JMYtgr9HkjBsEWy/WVlfeLC9I+VeY=;
	b=f5So7M/PBQXUcFwPHSZ3tE1ebkWPdyZbOtcfqaR1xQOYhwhwb3yEt+y7+gnKC6B/f6wxEx
	2S/RSywh/ue5WtTfj8iJvgest6oYmzZqfuCiWL8uiXjDWS5uSW4FiRWuwtv/CUB0qVphpx
	U+W1COXR/VguMtGqGMfeirCmisoox2U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-oewtGDdxN-6hnhgvIdtzNQ-1; Mon,
 18 Aug 2025 00:35:24 -0400
X-MC-Unique: oewtGDdxN-6hnhgvIdtzNQ-1
X-Mimecast-MFC-AGG-ID: oewtGDdxN-6hnhgvIdtzNQ_1755491723
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EB9C1800289;
	Mon, 18 Aug 2025 04:35:23 +0000 (UTC)
Received: from localhost (unknown [10.72.112.210])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08347180047F;
	Mon, 18 Aug 2025 04:35:21 +0000 (UTC)
Date: Mon, 18 Aug 2025 12:35:16 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in
 __vmalloc_area_node()
Message-ID: <aKKthIZbD4oNywY4@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-8-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-8-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9E78180005
X-Stat-Signature: 54on8nnpgegtbyo5iksmqjgkac8q84y1
X-Rspam-User: 
X-HE-Tag: 1755491728-262580
X-HE-Meta: U2FsdGVkX1+h4v6qY/5YrbHvlcZyfJWJgsG5mSTMBxU/E9E4VIKcBsII0ZaLiWtIxsDajAFVqEeKqHJEqCT+xr0A9yEDW8zTusxO5xQ32Fc+vFsiZbuRpqTmx4HcnBPk8jwYoXGc4M6zV2LmlW68X4vKsM522uC3ok/kAZI8Kua7d6cZKcVkLlxxNiPZN1wQ6Z8DnXOSDkjeFJ38EmsFm7s4Vyjr0gnJzaRaLWeG13HXD0El7bFW64mvzdcohSq0RPrHXDym3TPwzqRdxmMpa2oZ8gphLJMpBjx5Yj6ddLPogYGuQyjVlRBvBge+KnNSqCTtg10Pigu2ZjskFRTNWFcrxU0DE5F0tbLyIrB1yhcNZrpO5IvfmKQpw+IfsphIOVnNDq+tr7CKAaQxSJWbWUvqHzKDgcpIeDPqZvCKq5UMj9N9o59w8+R7qlIuzTzFZMy1tzm2HlaCxOLeeCH7Y5ZvKlhtZfN+fmWMHNDlntO0WPD5L7ua3DsASHqfz4Du2O1VDCNtujK4e7Pz/1fh5HP9H2yj/CCkbhmcLkyU7rKx5WK90UmRaO+ZOJUkNt5EadMQr+A7CXz7qfV7wBiqSxbWj8hY7GqSm+mXKNuN+KzUPl2z5Rqbo8dWAi4qpVFMANgtRXjX+tFjjmNO86SZ+HU1bLR4yAq/bywGvD9RbVayQa9+fxh53d1glThwBHlu+wVNVxDfSRTrbairo3/0xlSVnjhikh35vyd1QGK78EOX9YXyKvyDjOf1TVKo7X5rX84kjCKE3nzdJtCuuvfiU43tAOXvXAU4c8uXT6aMvQeD/SO+xvpvmUF77RfLxB1aIE+vc0diq4ZCInp1go+X5GuffKvKjOcLWoddKzfz3YfYHzlRSh00W0kdnieGRPNCNudazO3J+F0OJO/4gPTW5aOn37867+RbGW4xZ6ULk5IbyC8mUY+A14I0s4jYnNUfoPDaKZXkUrmHH0eDs9O
 TLda7Y5v
 nDkva9zUTLdAUo3E2iZp2SniiyTFpCC6K7lVde0cib653BzPWb5TdZHG5OojcMN550immSNIhfvLZAyrmcZt62mdCoOLVX3jg6PekiDuqO/o8OO0LyZjssYW+F1C3aM8KzOj85g5v5CtqiDQ5iLa7LmoFY8KZ8NLenzgcLeT13mm+QaHZnuDv7ryK2vL7g80pUN4U0WUITjBV7WrTa0atmICrgPO5o8YjcAZr+YPo3J0y2Knjiuij5KmrYNrAj4358z0dhIjm9j3zA5RkeW2kTXXvSWQXDPveR2v4IaH9iRatbOPXaXpdigUuWMo0fuS28b0qkkXEF3fRplXmL9ewgU80V7fL1zpCC1UNLGqSJDNpOonyOXNqxmojFUTvKlZXqojJXyYrz4d4d0RGMT32X23hnO14xtet8dpMwHXQlDeR9uvIn+1iauLZTNSWkC5TRLIqdxaJi1ey3ul8KcBgoAQ26A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> This patch makes __vmalloc_area_node() to correctly handle non-blocking
> allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:
> 
> - Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
>   if there are no DMA constraints.
> 
> - vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
>   to avoid memory reclaim related operations that could sleep during
>   page table setup or mapping pages.
> 
> This is particularly important for page table allocations that
> internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> scope restrictions are applied. For example:
> 
> <snip>
> __pte_alloc_kernel()
>     pte_alloc_one_kernel(&init_mm);
>         pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> <snip>
> 
> Note: in most cases, PTE entries are established only up to the level
> required by current vmap space usage, meaning the page tables are typically
> fully populated during the mapping process.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2424f80d524a..8a7eab810561 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3721,12 +3721,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	unsigned int nr_small_pages = size >> PAGE_SHIFT;
>  	unsigned int page_order;
>  	unsigned int flags;
> +	bool noblock;
>  	int ret;
>  
>  	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
> +	noblock = !gfpflags_allow_blocking(gfp_mask);
>  
> -	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> -		gfp_mask |= __GFP_HIGHMEM;
> +	if (noblock) {
> +		/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
> +		nofail = false;
> +	} else {
> +		/* Allow highmem allocations if there are no DMA constraints. */
> +		if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> +			gfp_mask |= __GFP_HIGHMEM;
> +	}
>  
>  	/* Please note that the recursion is strictly bounded. */
>  	if (array_size > PAGE_SIZE) {
> @@ -3790,7 +3798,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	 * page tables allocations ignore external gfp mask, enforce it
>  	 * by the scope API
>  	 */
> -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +	if (noblock)
> +		flags = memalloc_noreclaim_save();
> +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		flags = memalloc_nofs_save();
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
>  		flags = memalloc_noio_save();
> @@ -3802,7 +3812,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  			schedule_timeout_uninterruptible(1);
>  	} while (nofail && (ret < 0));
>  
> -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> +	if (noblock)
> +		memalloc_noreclaim_restore(flags);
> +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		memalloc_nofs_restore(flags);
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
>  		memalloc_noio_restore(flags);

Can we use memalloc_flags_restore(flags) directly to replace above if
else checking? It can reduce LOC, might be not as readable as the change
in patch surely. Not strong opinion.

	memalloc_flags_restore(flags);


