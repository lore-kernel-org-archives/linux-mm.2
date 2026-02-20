Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A066C5CFE6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F407C6B0005; Fri, 20 Feb 2026 17:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDA06B0089; Fri, 20 Feb 2026 17:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9886B008A; Fri, 20 Feb 2026 17:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B73426B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:09:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FDEE1C298
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:09:40 +0000 (UTC)
X-FDA: 84466227720.08.71342EF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5B43440011
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:09:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GTyA4VOW;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771625378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMcpQEUmQPBfSHE/XsFFGAO79A7tRmTzeXgyD6t0vqU=;
	b=Cu58ByS04gb+DDNb5YlcW1UUOjEOzbrjy9Wiz44zNq5pGiA4csqzCrJ63gG+7MP5INFzM3
	MSQLsZ34db2k0UFBsBfWcgEG69S6/vmxiWbnsVhcfGnezcLX8KSmGJ7cF3JUKBxS3oz2dL
	003A/B0ppq956A+H4tou3A30y/WksRk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GTyA4VOW;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771625378; a=rsa-sha256;
	cv=none;
	b=jEmDYbxABjLoysx9HQ32Cpw5BSnpoGnoRQdD5lmkZ0Uv/kpxJ3lczMq1GtU8CmH1YeOcNo
	kr/m37Rimz9JwNrofOk0czDZ6krKHE+PxmhZZyfCDwrybtquYHnngesA1fqWStD3JD/Y9w
	XIyU42CntX6IHsrluOpJ3KuP2YZMn1Y=
Date: Fri, 20 Feb 2026 14:09:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bMcpQEUmQPBfSHE/XsFFGAO79A7tRmTzeXgyD6t0vqU=;
	b=GTyA4VOWkcp/D3+UgQRVXcg0nUbDJZuVwMWrhkq8xt2zoFpEYEYArzx40OrtD3f+yFGrSu
	q/skB1MhRSv5lfsszeTX172W2sdttYgXZoh6DGEM6hqJMHhzotH2TexkLuio74cY71uc32
	ctHmYlWTLWgvZsdzpTgRLwORojKBBLo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZjaxAi-AzyOYzNT@linux.dev>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5xia537hy11h14xepwrmot6qeknmmjkp
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B43440011
X-HE-Tag: 1771625378-694441
X-HE-Meta: U2FsdGVkX1/1tVK96Luj3kTbT/2uU99k9q11Gd6tAFFIGVVuZIRednGIFV08EpJkV4mIWRiS23+jP11O31JKsIS8o/GDhn2SjIb2aQpPlLbAdXkw+U/7COROe9GlD1vhTOGwo33qJhEcz841EDqyICXilGDDuX9UrdH2GlZdNagA+jqA8LYGccvCczChfWG7m3OeMJlr8yVaZB/jie8rkm/Z4CuP1jLtsj3TAxTCmZOfhJG4eU9v2FM2CyAPS1FSn/ZC4hOoArp5zPJg8cyfa94ypyWbugsz+jQOAtfG09pNRyURoIxHyGHmD5NV+OCc4aF/8h6xSPFDld7Cz0FCZDKn2C9sEgUOLmZWmtRs7kndrK4vFkISqYrfUVnWmbyGLgZGyiaBFBf7vAZy/KLjeGzry/g/eG85DpJDRqrmnokVX0PTNEytvC4A8SJuWsSQqAanjBONfWNfeBI+Zx1lRFj6wfmDpsMqpCb/PbHVVnjyUuOz1upmZFXQRhols9TxqDJQ1odpPB6E6Mj3NT4NW8U/NfzM6bhpnlR3FAuuvUg1IkNSFrIPQA5qyj2/Dgmp1NqRyRkdOrPzQ2Gk13ZisblVvOZRT4WlUygK32neoVk7FEO5xwuavawlLrTBK+5DsOrzrf0bUlz5Meen+tsH6ARDKep9K9qjMxQ2J2GOTt+AGs5bQBxL3UpO7a6edp2yvFwWzaedU0Dio9gKAkXW5Zke1m+Ys4haZlAdQ2yQHpa+MpnQKZo5P5ugwpE6eyKvI6ooIJmw9KTbJXCeIPtcSGcLYiPevYncu72IcbAyM1u4/184BBk+nJAroiuXQ21Nqk4UANX5mdvsPluhtEhB017Fv1npS7xq/FAeb+GmY1SZ2tcSaWkwoe7FWRTjPpug+Mda/xKXhqdyHj6APsVcgug19XiRIWe3Zwec4V+54ZtHr0SYcNz0d/LZ7E2rLWmF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
[...]
>  static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
>  {
>  	struct rb_node *n = root->rb_node;
> @@ -3463,11 +3457,11 @@ void vfree(const void *addr)
>  		 * High-order allocs for huge vmallocs are split, so
>  		 * can be freed as an array of order-0 allocations
>  		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			dec_node_page_state(page, NR_VMALLOC);
>  		__free_page(page);
>  		cond_resched();
>  	}
> -	if (!(vm->flags & VM_MAP_PUT_PAGES))
> -		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			continue;
>  		}
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);

mod_node_page_state() takes 'struct pglist_data *pgdat', you need to use
page_pgdat(page) as first param.

> +
>  		split_page(page, large_order);
>  		for (i = 0; i < (1U << large_order); i++)
>  			pages[nr_allocated + i] = page + i;
> @@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	if (!order) {
>  		while (nr_allocated < nr_pages) {
>  			unsigned int nr, nr_pages_request;
> +			int i;
>  
>  			/*
>  			 * A maximum allowed request is hard-coded and is 100
> @@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							nr_pages_request,
>  							pages + nr_allocated);
>  
> +			for (i = nr_allocated; i < nr_allocated + nr; i++)
> +				inc_node_page_state(pages[i], NR_VMALLOC);
> +
>  			nr_allocated += nr;
>  
>  			/*
> @@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		if (unlikely(!page))
>  			break;
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << order);

Same here.

With above fixes, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

