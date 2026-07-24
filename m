Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8665C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DAC6B0096; Fri, 24 Jul 2026 08:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF596B0098; Fri, 24 Jul 2026 08:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5156B0099; Fri, 24 Jul 2026 08:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC586B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:52:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF628120373
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:52:23 +0000 (UTC)
X-FDA: 85023658566.08.7DD8E43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33756C000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:52:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fIMJeZoV;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784897541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLQ5O+fUlC8SWGd2qEWM0svM8AGuw9DKpa1kqaGNOlc=;
	b=rw3Ov0BhDfLuYKgQ8spvXOPdykZ33vtPPttV6uZZTl6LRwy8jXsJo/iBYJrDQZJjKH8OZC
	tlZxeok6zLC+qhaKgshTOSBz9JrZA68t8d5IEtkUNTL8+Mo/mZFFQVM3pkrs213SiFnsCy
	C6dGm6zqisjCXI7ilibyrBq1p8Jskv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784897541;
	b=0p1hKVrJ1rwAAPwCAAfZPq4f/eF+rNM5WcXvjO5wCgnuKBCJ1cdrQbPWdV0fRUmgUUqWQD
	GEW0hdYIo4OUiHDOhuRk58taJwBk6sB0jV+23LiKshsDcb1tm9U+Kklcdb2i0knAnr6FdF
	wW8OrA6jotBJ148h24FwADkQf5jv07U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fIMJeZoV;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784897540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JLQ5O+fUlC8SWGd2qEWM0svM8AGuw9DKpa1kqaGNOlc=;
	b=fIMJeZoVWYhun3WlUlSAxGVbiTl+hAbuAGp6qpnU1OQW0Wo4K61PIARx9BfIMxp2gVLggN
	RUyBRB+QjLr70hCysu0C50meRFpzKLZogIcWbGRyvJALFmfdKcNy2JnMJnjIAd39kKJRrr
	vhPSou44yIlCLIWH35+ybqukNVUVj7A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-JUxFlmoeOdqdFzgAhpK7Kw-1; Fri, 24 Jul 2026 08:52:19 -0400
X-MC-Unique: JUxFlmoeOdqdFzgAhpK7Kw-1
X-Mimecast-MFC-AGG-ID: JUxFlmoeOdqdFzgAhpK7Kw_1784897538
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so3595895e9.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784897538; x=1785502338;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLQ5O+fUlC8SWGd2qEWM0svM8AGuw9DKpa1kqaGNOlc=;
        b=gPT0PAdXrdguqwpYtWRZVuxD9+BhSiPERxdBiZwV5CiNwy1WWQEf7IIFGGKF57ysN/
         KbwcbIFUB6hRYyI4Khg0L7S7/+63/+j/r7rYEI1SAHWqrPw9WPNG6RWJ3bMB9dbF0B7x
         tyFuIlmrpBoIb4Pi/JFfIy4SaZJL7Impre0QZV+IynWLauf0zvsORScKH6HpeIbgZnQ3
         xJWFfqXHe/L+8R9Ov554pNUEHNl/ERfnWr6EzZNVpDDu3rMaCpY24M2fyEpNeFGvpN4f
         HLq4NUDJUPeJjdDcr3JkJ12ihqrUl6CKyX8sohZ/j+GaymqwpoxqZAOI/dvlAV70OIcn
         L1kQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq43mG1+DLy4HfQ0IxwjCOFYMK1wE4Iy5+mB+U57ZFyFBNXgmoe6PhyfTsGetu+GZyfRBYJthXIsQ==@kvack.org
X-Gm-Message-State: AOJu0YwgIYc4tXH1Ei+xQ996g5x1il/T7Jy1j6oVUPtDvrl0HPx3AJWl
	ydsKbUeKo0vZbf7dxCF7WJIsyM3/P4zXQRbEeVVlHQV8wvu6FokOHVuzQixFTHVfaOJyC37x100
	ScOKLpF+2LJFXiHgiTXyZxwNO9ofOY7Zlv7EFKb5YJyFsTtEnSGzU
X-Gm-Gg: AR+sD11UyR4ZrKn5LHl5tFWgsUz9TdqFcwbYPS0SQuoD/9O/vLD7DXRsc/AwGD8D6om
	6B04EK6Lry7GJraqW3TnAzZFhylhv3j2h4oQyJiGnwJYxzvaXA22L3GUbA/dfn09SPt4vv1kFM6
	O7uQPXC6dbahgcbI34OYMApnuJSTplr4YdHKBeSQ3DFAP7GBdhtlRiGF0/tGbm6WUm617HcWV1N
	FecB8v4oY8RApJxnV7niu+YSbOuHyxv6Q/KxxyAEFr+v6WoIZjo8dBXN1KAAgpV9lQtbWz627ah
	Pl6PCFJCT7M+8v+wTcRzYihkCYw3FvJkD9ovVLHu9LVU8HVmWvrXDe7uDViyF5MMnM595obbBEH
	Ql5Aa4NGxarPTR6FS4Vgi/Q==
X-Received: by 2002:a05:600c:63d1:b0:493:e79e:da98 with SMTP id 5b1f17b1804b1-49573cf1b3cmr56863845e9.39.1784897537746;
        Fri, 24 Jul 2026 05:52:17 -0700 (PDT)
X-Received: by 2002:a05:600c:63d1:b0:493:e79e:da98 with SMTP id 5b1f17b1804b1-49573cf1b3cmr56863385e9.39.1784897537206;
        Fri, 24 Jul 2026 05:52:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-37-66.inter.net.il. [80.230.37.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bfc2ff2sm44919945e9.4.2026.07.24.05.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:52:16 -0700 (PDT)
Date: Fri, 24 Jul 2026 08:52:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
Message-ID: <20260724085124-mutt-send-email-mst@kernel.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-4-willy@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20260723143034.175661-4-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vldeJgL-LjrdINrH5g8ogfvi9xl4_GDenEsScrqETpA_1784897538
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33756C000A
X-Stat-Signature: ng5erabpqtyzf3anusjrwma9m3o7zpny
X-Rspam-User: 
X-HE-Tag: 1784897541-392037
X-HE-Meta: U2FsdGVkX19jrHZ0YKHN+bJvmPXD1aHZNUnR3fADPPcGShAX5dTKIxI/ZqIxApawgRD31VJ9OP/UQBj2l3xepOFxgJm94V/+4DPvtw3y9et5Zgj5JyH8zatTvB9xt1y32lGFDfEoVQWj5vDvpHMBHRxAWQY3LEEbWZ/pZO9iNcIgaJ8wMEc9mTfchVSejNAmzuOpuulWOZH/9LkpZ0FTrxF+xP26JOYPn13nWPbLDZylrfhwoRK8QpcD/LQ1Et0cvCkRi4uJKaVQatqWLnt+70zYGW3NCoh/2dTzODgC5UlWWjJwATHs06pHv0un58zB0BphcOvqd7hcNqNZmkP5VVdVAvzob+hBIAvtsVKWaQNQ105Sa402Wm5iT0grgIMvHBnzNrPGeV0uRaXE0DCn1AShzI9EH5ob1NVRXD9Z+1MSVmVeAVdj9LTTyzmXtFallUspC60f4Qx32/qT8sa6xyx2U3jDjHyKs/1WuAB9xWOe4N6KaX9cxzP47JfTk52Wk8TROj4CpNDFcrq/fZwwIZLC0Dp2xnE+X1eMX1+kRQd1JQroQwnJf7Pv7XMkR2mFT3qU3Dl/u2BsnfJ3zDXoey5x477JVXgYcPqG/VxV3c02NGt8bF4AdlPa9CwP22x4di+WRYkIMtLO55EU0560Cc8ufEDELSY/R9oJAMLPb1zH0FFXZcnfXnGDz5YdqDCFvjpopRRU2CC+nubIUvuTpqtdMXwJS6W390TVddKfFj9WoDC9IFvrsDLU52w6ER9zT1CCBDa+MvJqcDCXc4J3xxQKJ1UAKnPH3B1q25eXGPqnLf98keJ7in1Z/UVL3wOajFbDlumwC/QrRKhZD4UIfyYB4bZ8hyKwHWL74XxkAFhADJrmVSVziCgrL3NPuvAr0xeA62owzyDSJpo/pGeWFHaCEw0JctzSmkkh/HFblVU6nupQ8BlgFGPTrKH3uZLn7kZvXV8chZEPkQ7kHKZ
 n8yJi6/n
 3naaxDy1hwmbu0cfP3azbP6KVvmSFSDb8bpATGEQ4ppSf5mtGgF2Poflu23/zrqM2TVjSe5cloBKpQooq79s62pIVIbkXPal5S5zeOlsKpk4ty22z8dbQUlB6S8h1EU/a8iTu2tolytZOD89ekrThsX4ZVAc+0ELER0V9PORkPsI0ZrHpKW/gvkrv6cJkTfCArAAVEVVKJ6hygdWHvCzVEHSi4BEnUbi8tXD7EJt7LF87cIB1X5Bg3zNVvX8ZeU+CAkAlttnjSZT8ypoxoUau5q9MXqMQDxXg456aUvvxQ6sQJ6texglOfWXIrz00eWmRfUjEOhawRDfuhRfA9NHHabamA8B8wu9utZjFja/vKhtK7/2KtaVsu/Hg3yUhzCjLSoGwScCT8EWidMDVGEZJOAlvqpkGrYOul0ysSUQ6UHefUV/xo2AqlmIrW4OnT+bxXG0mgalwLYEs5O4QER7HyzDdlecepNv40R2c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:30:20PM +0100, Matthew Wilcox (Oracle) wrote:
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/page-flags.h | 4 ++--
>  mm/huge_memory.c           | 2 +-
>  mm/memory_hotplug.c        | 2 +-
>  mm/shmem.c                 | 2 +-
>  mm/vmscan.c                | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..4185a03a45cf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
>  	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
>  }
>  
> -static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
> +static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
>  {
>  	return folio_test_hwpoison(folio) ||
> -	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> +	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
>  }
>

It probably makes sense to document when this should be used
in preference to folio_test_hwpoison, given a lot of people
got this wrong?

  
>  bool is_free_buddy_page(const struct page *page);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..353340309107 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
>  	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>  		return false;
>  
> -	if (folio_contain_hwpoisoned_page(folio))
> +	if (folio_has_hwpoisoned_page(folio))
>  		return false;
>  
>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..33007e8e546a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>  		if (folio_test_large(folio))
>  			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
>  
> -		if (folio_contain_hwpoisoned_page(folio)) {
> +		if (folio_has_hwpoisoned_page(folio)) {
>  			/*
>  			 * unmap_poisoned_folio() cannot handle large folios
>  			 * in all cases yet.
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..492c9bef3620 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
>  	if (ret)
>  		return ret;
>  
> -	if (folio_contain_hwpoisoned_page(folio)) {
> +	if (folio_has_hwpoisoned_page(folio)) {
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		return -EIO;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..70e54ace0e74 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  		if (!folio_trylock(folio))
>  			goto keep;
>  
> -		if (folio_contain_hwpoisoned_page(folio)) {
> +		if (folio_has_hwpoisoned_page(folio)) {
>  			/*
>  			 * unmap_poisoned_folio() can't handle large
>  			 * folio, just skip it. memory_failure() will
> -- 
> 2.47.3
> 


