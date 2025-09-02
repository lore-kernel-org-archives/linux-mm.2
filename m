Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C9BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73CD8E0006; Tue,  2 Sep 2025 10:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDBB8E0005; Tue,  2 Sep 2025 10:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECD28E0006; Tue,  2 Sep 2025 10:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 966F38E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:34:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C8C0140227
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:34:10 +0000 (UTC)
X-FDA: 83844555060.16.214F3F5
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 967A74000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:34:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=a64vnD1n;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756823648; a=rsa-sha256;
	cv=none;
	b=NwbMqjmrQgZMSKy/I+ATy03p617CSr6hqY1z9fVDBaFtcT6Gyuck4tAKYJd3uiEsCczrlA
	E6Ex2zTCHJW5XdHI+/Zds5bwSZnDamQAXOalwJMXabHbMGx655UmEwS5GHiIkrMA8v/J0V
	YReLwM0VlDU34mvgtzQT+j8KbjffYSA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=a64vnD1n;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756823648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jml8ElDJBmGpsEO8gZRSuwQYyAaJ8aUmNNtqcGSf0K8=;
	b=tEeoWwtFSHOTrnvcfir4ZY04h0oGreItuLx7mJy8+LeiEnpQNYceDDTsCZQTKeoWImUSRj
	6h3SSNLEB+1BuppJd4VlIV3xOQXrZ8LLlGOeS/mwlGgU3CVfC1MjBvBUi7Axl+8h+rbOgd
	B+jkWj98ujocbqLCOiMHXdKx5neTL0M=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b04163fe08dso420608766b.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 07:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756823646; x=1757428446; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jml8ElDJBmGpsEO8gZRSuwQYyAaJ8aUmNNtqcGSf0K8=;
        b=a64vnD1n1O954rVPTkWJyD1rPFY6EOtgQG474hGAlXDE+u555vn/N0iQFYL7phPJkX
         VkYLIrJBKZPlneF5LpZl7fAl2+KuZlYyU+UUdqwN7ynwugnSmT9IkEuXoiEqa1dCp8hi
         +O/LwBMP83Ac8gB3MV0+vpDx/UsmCS0qN3xytO/kjeSAu/ZuhpV92xaI5Omql06+4GP4
         LuI4xKAi+hFSEC7jueo4gNuyleCqRTkUSPbgTILEy2M7JhggkXYurORVNMoOjfdkaalL
         Zq7IA7rbGv6Ytjgi6Eahzna6VmahwSygGSx9LczOyf8KNMQbYUnFcyv6gnW4c5zZYfD0
         UGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756823646; x=1757428446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jml8ElDJBmGpsEO8gZRSuwQYyAaJ8aUmNNtqcGSf0K8=;
        b=rtUpaRLZAZa38tFRNTVn7qJhv8SeosbNgoYLgER9t1J5tOJ7KFsuUa55ocuUdu6JDf
         Ju848I+W/I9mJZwfm6XQNxr1J05NJ/2IYb82PFYvGQFJTzn+hd2IwaJpDIc3Bl74xV27
         z5kOQH6i7ukieMiH9HZ8hWAI2ye+BPOiP/zzgBRq6GcjTiD+laI/Z9Ht5hs9tlV7NpeY
         17NC1//ambBxMUAOEy4jdoPe4mtsV0WyQHtCOoDnZq5QTbudiROqLiOtOJAhDinBU5d3
         wdTsyRSKojt0lOf8eB59qXeAJz8mKgsefnwyl7Df8MiFILmKlcvJFITlXLykR0Q5YlqT
         1NWg==
X-Forwarded-Encrypted: i=1; AJvYcCWeifV/vkSvczPLT8uED3ebwNQ2bD8uXWvRIi77gjMnZhsHpR2rRZzyasDlrYv7g1ITBaZsl1QA9Q==@kvack.org
X-Gm-Message-State: AOJu0YzMneHqW+1KiLKK9GUgK4uO+khXeutj6AJTh7ySOQSPyawhQg6h
	DRz8DwG12M2VxpthFxAts5yYoo868mmKu04lxpTbpw1E51OX6cx9LbgCUfJF5EoTc24=
X-Gm-Gg: ASbGncvZxd59pfWRxWGVnTtEgbfyYV63gdElz2vWpCHnCRwwEBe5PUM8WBEKAd7yUjS
	AbU5p32vU3WeiBVO9t7xaYDPqvgXK7OuKgCJH2yDDsh3Xf/AelUESB//Y+DEZyKWC5R0MC+jqNr
	VcAFH5lBWNsYBhdoeDTiruji608iwDjpPK/144tYy7uYHJfwRiaI1JzqX7sSBdfHER4bEERgZC8
	/K2cj0LD0dqH35CJznA/M7WFe8dUbBfG1KNqjy0IR5/2jnyFhMlFo98ZanH9IWbMqPsxJP6vD3U
	1Cc+vP1bhZOLcXn3WQLlrn1yQTyd5y3Mg1H6+R6wrPujgCHExWOceBQQsGNieKl7q/eWrX0IvsD
	NGw2W6K+7ot5UiusOamCTt3rCI/ILCZtXd4If8Sk2KLjNxg==
X-Google-Smtp-Source: AGHT+IFhNrqfcx2OD5a7WMMfm9hdvh32RzMT9SwaoQX98MOh3rsjs5bl8ZcPw6ANmXCMAiufhtedgw==
X-Received: by 2002:a17:907:9623:b0:b04:388f:224 with SMTP id a640c23a62f3a-b04388f4a0amr632116166b.1.1756823645539;
        Tue, 02 Sep 2025 07:34:05 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:e14f:ef73:8858:fa53])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b042523ee7bsm575191466b.109.2025.09.02.07.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 07:34:04 -0700 (PDT)
Date: Tue, 2 Sep 2025 15:33:57 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, ziy@nvidia.com,
	linux-mm@kvack.org, vishal.moola@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn
 aligned order
Message-ID: <20250902143357.GA6654@cmpxchg.org>
References: <20250902025807.11467-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902025807.11467-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 967A74000D
X-Stat-Signature: 4cui9ss7rqe8xqdz9fhix7qg9qef4fna
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756823647-398517
X-HE-Meta: U2FsdGVkX1/Yt4EVzikiPTPUoy0JAHbf7lpxiSbRxYDL1K16F3sWBG4qUgfbACQMlNiPByG0PpZ0Nj/LRE9S3a3bmgT3uyuqkYea8D/aZYNvUU8WijqtjKB+rL+tFgofiPZDWpXFIagVvTCHTf2hfn3R++oIMsmmzPnKhCkD2iSc8wmLqV+Ml/twYBiVWnZ/sypLVXaJ3Nnaf5IOdSZtuvmhtcOYQiHjafGIgnVQliviKtJiePNeP4Hay5bvxPd0OMbLvK+eQ7m+5GDSb/r3ajHzOgn4ox9UceuxAoybiaDiInmzkAgyBZGkLOHK7tC9qcVnzvZTWUetl0UJ7jVe6oNAQd/raGkW9CeJgQVOmUcgAnjeobCjAGvcCihlpSMfcda8g9bJwT5rBg4By6nxKmdHXle/QdjtUUP1Yt0WyRWO+0/1gDpPLw1kZiSnNsSWViQbtioPLfgjeWu1WZqKk3D54Na1f+vKRGps7tnMxd5JkFUvC736UqdQm3i939jvMWKS+3li7ewSeo/CRlGTvxnjCRq4+kJJbX620GIM7B9lH3wxQ5Hrff8bTB443NslhoWL6cs5oHJHs/zYQy/wQltGLbWyLXpJxynFR/tQAWbcaeSOFQelKINiPcjHivlw/PyxRIAmHcvSJFxPM93gw1rTKz/HiRMRtB43c+X7FVQ0v4BathJrPtVT42HC0Ygvf2xtQzndY4WtstVrDt3TbgcO4Va3ItPZMdpw7ioPU30eQA0gvLanoKyucXasdJlsAdxDpcupq2YcXlW+pkvxwENXowQKfPlDfWTgnXzR7Ca1xVQ2C6Fk80i4Z63pxMKhLD4wh9uNqlJ1TghzQTbv/EXUS6N42Q90dG8bnsHvgYPbKK/VmElRq1aWPjg1mRHZhYoQAp3XGru9jE3XyKNFE4x42qcJuoa+EGkKgx40K1rczLyxhwE3bF2gx27I8kCuS2LIO4AzreVBkJXkskC
 EVucKbHz
 6XAlvBTnKoBbS8t4AO9ubwEIQpf4snEB1jdA7B+I83hGu5DBQXsZ+LktDqNHBNdqO2PBuBRV9l14G48dMnORC+9NJmNLKULsN/KVKNkzGIWlF4HaXC3TtuTkdx3f3wuihnifX/dIrtjPUdYDTTXt+IO2HDzLH6gIR7w7DAVFuAfdjoHrMF4pNL/s8j7ecKOx4lyahhckKgzMYr6IP5UGKcxOkxxvrZDswFw+mwp5wVYOFMpUzkTzHflDTd+KXrrxtU+BTVlkm/EQkBsghl2hsYe/Johv6olpib2N9QxzLNTQFcbvdVUYTRrH4wC7rMfQdFzH7hEBTWg5O28H/d+JRN8kIxNa5Rbf3ZpdkU08tyJNz8FMBpmYvRyl0dTL5gqY9NY9B2ZVYb5NgaqmIXJ64vG8Fya6zt7T0aX7sm0ab8/SNPHn+qGSIoal+sX4IEj1EgKwdgLfgk4yNMFZ7PoBbKHEcj5k1vNM64OibrULDBVpzASBqopiwBpeIOGWO/cyG5SydaStMps+YRDFxhDnBi7UUjKg+wSq9ogHHBQhpVvgFOeavJbwBTc8bTiVLjCv4v2mK6gzSh6AOJBI2BXodhYFJcJzbyrGxSjF8r2oE9VcQVWU0MK1zO5zBpYAuZ2XTpdvvwhT9RO5X0Q4x9bNoRoeys1FcOc1gEElAR8IiGRQ+ryTicp4dwnp4rshwy8MZti/pDv0orQg3mXsDYzMOOIMrg7S3Jx8uFbJO0VaEsUG2ly9tWRlNrlOe2K05In/F/ZTdrs3xXKoAK9GmDy8YBfqQ0n5OSlbbIhvR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 02:58:07AM +0000, Wei Yang wrote:
> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
> While if the order is less than start_pfn aligned order, we would get the
> same pfn and do the same check again.
> 
> Iterate from start_pfn aligned order to reduce duplicated work.
> 
> Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> ---
> v2: add comment on assignment of order
> ---
>  mm/page_alloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 07d79ae557f8..5d9ceca869e5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2033,7 +2033,13 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>  /* Look for a buddy that straddles start_pfn */
>  static unsigned long find_large_buddy(unsigned long start_pfn)
>  {
> -	int order = 0;
> +	/*
> +	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
> +	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
> +	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
> +	 * the starting order does not matter.
> +	 */
> +	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;

This should be __ffs(start_pfn) - 1, no?

If you have the lowest bit set in the pfn, you should check the
order-1 buddy to the left first. But ffs(1) is already 1, which means
the loop will check order-2 next.

