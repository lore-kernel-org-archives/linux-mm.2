Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33123CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745E28E00A1; Wed, 17 Sep 2025 22:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6B78E006B; Wed, 17 Sep 2025 22:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C488E00A1; Wed, 17 Sep 2025 22:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EAD98E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:59:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4C3B874F1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:59:49 +0000 (UTC)
X-FDA: 83900866098.18.8064671
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06770C0004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:59:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Us+isbJ2;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcKW5Vz9+O4NXqO35+tX18KtIiANJDc+I7FuiS+m58c=;
	b=m2pw0SNDqwBmk2Yo9dFVC/TH4Rl+Rwbq3waFjD/Rm2kC88P2JVaWAdxcZZeo/oNImlG0qU
	oPore9kwsGGCuTvAS6nQfo7NeOJH8dzOYUhk05sV0kNKvxqn9XwRqJikrdKfIgN2QEzak3
	FcbnE0Brzwp2GmqFJWoYEVlwpHMOVHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164388; a=rsa-sha256;
	cv=none;
	b=yyV312B6U+IhQ0/cLKgoJjJHGnWeEGPajXJ45z5nD7vcMbYVJBPsU8BMrGfedlRKwHqdLR
	qzafawCWLJkTm4gJp0zd6RK9bFvfhrqFA02ja8IAhjCN/bUSInT+MYupp6CKWktxxGwo+O
	U70B1VqXr2Rog9lmLVGulU8LLXBsZa8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Us+isbJ2;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758164387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OcKW5Vz9+O4NXqO35+tX18KtIiANJDc+I7FuiS+m58c=;
	b=Us+isbJ210KvTVg22lgbf3k5dXwWNvMXeR7ExOngUuj+KWB1EKW8H3QPom/0LXSt2QeFA9
	E9xJCcEZwuTOuOWqvo9of8ytQJ1qRuDwgLUJrl3r1MJ6f9bhk2GdqgYVAbuMudu0uczige
	e4bNT7dYAoxoxc0sYlOeyhv1dE25Nus=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-Ki7YPC2oNNW4rsY61BHysA-1; Wed,
 17 Sep 2025 22:59:46 -0400
X-MC-Unique: Ki7YPC2oNNW4rsY61BHysA-1
X-Mimecast-MFC-AGG-ID: Ki7YPC2oNNW4rsY61BHysA_1758164384
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 970491800366;
	Thu, 18 Sep 2025 02:59:44 +0000 (UTC)
Received: from localhost (unknown [10.72.112.180])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B2A91800447;
	Thu, 18 Sep 2025 02:59:43 +0000 (UTC)
Date: Thu, 18 Sep 2025 10:59:39 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 05/10] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aMt1myQHpxit3Zbo@MiWiFi-R3L-srv>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-6-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-6-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: s5xrrfz8pmckkq8cramnugpmk8iog67z
X-Rspamd-Queue-Id: 06770C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758164387-281016
X-HE-Meta: U2FsdGVkX1/iacf2PmIXmhk/5B/8R2bbsOHO2CDn2+pcXmnk9PU160R19GVcTU1M3aL3o0iF6tHIbgirxXWgENGoLUj8b0nXEOYwtjRTJc8NHX3pj4161wFKJze9WVUM6t4crbS4QwnuSNF9cE539boYsR7s1DvgoD87xvDGSAwlx9UzVQmuF7Do9ebJCoj4FvDcMNoQUaZLXAWD9KLlAteodFeLZslvku1g24o5Owa8MttFbZ0InN3H04L50Oey1Moz/aTjtZrnsd8viIjhIJ38mdCsJLOl9pVvYx5aGXcUH2k2fZiRRyNtHRxANBvlxKE/KHwKM4NybZkE/dMlZShL1ICYdBgq2p+nX1PVt7UZGTlkjswsMteZqBbXxsDJdsHdT0jkURVWcvrwAzs6CGWxAQdj5o5JoVwclA0G5XNoOyHrP+P5JCR3Vu7DgpOTHxgXF5hCSSdOXBw01yHeD85g3BolBnacBYgnl9Uvhda5M+qqhe1kP+Qk6s7JxcH7h6akzoJg4agEI2j9QcrvmWEvYL8t5JI7XuQmBeJebCXUZUhNxuiEa6DSD76HZz4XnuDbo9tlw+0EF/amKCIYzy1mdPHqaXpLYHHSHnKwygmthfAwksRW5z/aqOLbl0tlPWvUmRW2GVXLmouWbn2JAhQHBj5uQCmCo3Mv0Ndk6VI//JCLhjrS6C94knCRhuF4yuzB7pZyhjq0pbzdfF3f2T2QDMM9EgOFgCat7fabfz0+VkU+so5HEJ8VtgaVI+m6fPpzHr20Dke8uzL89NCW4Og0f/DsjZbjQuLCjQXFns+tNNNpE2LnWCkCk3arlXqyB7X+DNz2ADEpJrBZGfdJrtVvHJfLcZuuBPNN6tKHeYukJWyE22d2sxKstvGhIFMIUdROhrfI3Pojm9Cp0IcI04B3PLwlJs533B9jNWLsGsyu0vOo5Pngu1A5l+53UXuEdIs6iAsCcvYkD8be3pL
 XhtB3lgJ
 nmdW4tf5iO46LGojQxbxGCOUrYrpXxy3JR7olU4a0uuZh5U0DTw9g5AF3zdSBGlUP7KCvYZ/q+B+5u/NmUdALXyDlbpWnvLwVXuZkOsmKrd7DVzdzLsfKDB933mQHNf4eea00BVJK4Y1/7Vde52R9twkn/Dxtt5Zim7ooFyeyJQ/Q6Cn4t42fmg9LtaT+O5aT/CVuAuiybaBhBQUphRMnagJ9SXoRTpwqeWyEcNykWHyNkOAIt1RrPEw76X1JymJ8WcQgtS702yKGYa26cclVw9zJ8K2CFlkfhn/h+moxrr0X6NEX61YxvY7OdSkRq0rvbDQZl/eAWlIoJOo1BNXzny9TM7es0Wak3hUXSHssPiCa5nZ7gs9UNAUQhvjaddqXMQOWYrND1wEA4Hn87FJMFh4fnIiqWIRoDVDEeV3yyFKJV3dlFp8rrY0st+HDOLzpwJqjuCD0pHv9rjw0Q/ABG+4kFEoT1KTDWR93RcYh4cdqNbfsZtzkE5UPyvhpa+i1z1+U+FaloeehW36YI7Yg0Uw3RbS6VGJiSoqd4WHQ45nC2+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/25 at 03:40pm, Uladzislau Rezki (Sony) wrote:
> __vmalloc_area_node() may call free_vmap_area() or vfree() on
> error paths, both of which can sleep. This becomes problematic
> if the function is invoked from an atomic context, such as when
> GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> 
> To fix this, unify error paths and defer the cleanup of partly
> initialized vm_struct objects to a workqueue. This ensures that
> freeing happens in a process context and avoids invalid sleeps
> in atomic regions.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  include/linux/vmalloc.h |  6 +++++-
>  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 4 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 2759dac6be44..97252078a3dc 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
>  #endif
>  
>  struct vm_struct {
> -	struct vm_struct	*next;
> +	union {
> +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> +	};
> +
>  	void			*addr;
>  	unsigned long		size;
>  	unsigned long		flags;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b77e8be75f10..e61e62872372 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3686,6 +3686,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	return nr_allocated;
>  }
>  
> +static LLIST_HEAD(pending_vm_area_cleanup);
> +static void cleanup_vm_area_work(struct work_struct *work)
> +{
> +	struct vm_struct *area, *tmp;
> +	struct llist_node *head;
> +
> +	head = llist_del_all(&pending_vm_area_cleanup);
> +	if (!head)
> +		return;
> +
> +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> +		if (!area->pages)
> +			free_vm_area(area);
> +		else
> +			vfree(area->addr);
> +	}
> +}
> +
> +/*
> + * Helper for __vmalloc_area_node() to defer cleanup
> + * of partially initialized vm_struct in error paths.
> + */
> +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> +static void defer_vm_area_cleanup(struct vm_struct *area)
> +{
> +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> +		schedule_work(&cleanup_vm_area);
> +}
> +
>  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				 pgprot_t prot, unsigned int page_shift,
>  				 int node)
> @@ -3717,8 +3746,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		warn_alloc(gfp_mask, NULL,
>  			"vmalloc error: size %lu, failed to allocated page array size %lu",
>  			nr_small_pages * PAGE_SIZE, array_size);
> -		free_vm_area(area);
> -		return NULL;
> +		goto fail;
>  	}
>  
>  	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> @@ -3795,7 +3823,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return area->addr;
>  
>  fail:
> -	vfree(area->addr);
> +	defer_vm_area_cleanup(area);
>  	return NULL;
>  }
>  
> -- 
> 2.47.3
> 


