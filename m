Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0EEC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701666B0088; Thu, 30 Jul 2026 04:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B27D6B008A; Thu, 30 Jul 2026 04:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8636B008C; Thu, 30 Jul 2026 04:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35FA56B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:53:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC82E4094A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:53:15 +0000 (UTC)
X-FDA: 85044828750.25.7254F96
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf18.hostedemail.com (Postfix) with ESMTP id B19F01C0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:53:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EbrwOxqU;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785401594;
	b=PbOWRCp+dU9gmFV9SFzWcT2PYGReKbeVtoI5atCvfCg7TrMKWVtlITQDPJAXHo9ZEzim1E
	gfHl4rBzCBM8vpzhLjODMeNioOJH7pkG0bIaYzMwu4oXLvoga94Xq0LmVxwVk82jZSdcYX
	SQKIAo8L4LYcgFI+1X/cuHUqz7sjm18=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EbrwOxqU;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785401594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERcnZ2qpNpaOjrBgMSH3eFGiTVKcJAovZR3Gp8QedMQ=;
	b=MyU15fRqckDkX40V8hrpVUZWfAWbebqrM2Y9jZLp3V2HhpZ7Yv7wrOEyK1UhjrHCZSzSfU
	Yc9oAyyWWg8hmWk5fbN94ApcXAV90G3YxtsodSkEZ98OPqbm9DdsFlquGI4LGxztVu0Q7w
	O+VRJdvHwDyTwyXaThLEv8n8bLbxnPQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ERcnZ2qpNpaOjrBgMSH3eFGiTVKcJAovZR3Gp8QedMQ=;
	b=EbrwOxqU1XiEkqlwd/0Bv2pEY2zBh2KEdw10tgNDskWAts8UFwjcCepahypMyfBb5Ia0PtKWv
	QbV99BcUA/XZetrEOZ93st8f6N9NJKyCOZGnW3z8ZZIxLYdpjClyQuXPDOQ4M+zOTrODWBI7Qsq
	VVtX+DTXd9UTqvc2BL/AVaA=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h9jQv5xBlz1T4Fq;
	Thu, 30 Jul 2026 16:43:35 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id B7D1E40537;
	Thu, 30 Jul 2026 16:53:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:53:07 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:53:06 +0800
Subject: Re: [PATCH v7 02/13] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, "Jane
 Chu" <jane.chu@oracle.com>, <linux-mm@kvack.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-3-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ecd8dace-8bcb-67b8-59a7-809cf81c3b93@huawei.com>
Date: Thu, 30 Jul 2026 16:53:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260728204409.3396238-3-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B19F01C0006
X-Stat-Signature: 3irxxahncn6wu1fd6t7tj14emtb35m4j
X-Rspam-User: 
X-HE-Tag: 1785401592-197343
X-HE-Meta: U2FsdGVkX19JOm0Ch2b5ZZtpvcPR9fMESEB7wNz8UM8RBnYnMOt+Xt/goWyTtfEQXBr8xP8yyGxgAnvJ329Y3CrQ+iXpcBJERVNxRqSNI7uOV7ZMpy191fb2BZHRdpXyHPvJ964Q4/eWQL/vT1TiM6XsIPhgHRl/PQPOQtnKQeX00gs8+cdDHRcGnh/uTjsQWilGv5gk8sUc5RFEJgfBM5VJ1OKhsL2qD/P37ocpOEAyorSUy552zXG9XyFUM0750Mf2HM48K2od22EwiZY4upZaJqbboaTqxTkyVs8jEGsgWnlEADvvgN5/mROCIz5H7IMdGWWL31EC2hW31Yf6TNARKpwL7orQognwCW5WT0ewGizfTmWIUDmVdoc3/osBkuUqS1/Sc6zzRzYYyHTkn0NLEIMwUZ/4HDnF8XDKNoY1Y6fo1LXmcO88u7FEjMMbnsfe1LXLENFu+DwtIAD1gcbt6tWoRPGGyPhQKzhm646t0l9itFVBIIknR97wTDI7Hq++yeRh61FmvQzWJZbKYh4aQyZXfCYnnQEqwNelFh1qsRJF6uj2fCUsmV7ST2vdUMKhgI455VFdI2RU8PzqfLG7RD6UUraKooIZa9cm0ECzDBTW9ORuIzfvqD1MDraU0zGv/OUT4+oi/Zm64wNRpN0SaU+yNJorPVtYzZfboAjmzZdwCtUkHJOzSKsctHwJnEJ7hQzuOkMWa7wOFvqAL/nSlAXEJKYYwBfkMGBi7cjeuU27FCpMXHBl5O53+/bVLuz8hCjA9O9u6k3JY11kVFHjA2KYY4JDx2TSHjtourwJkV0CSIQLFi638EbBqnXiiHAABdQVfl74YAiPYV+b6pJkq9ksP6iHbkSnX/sg2casn0Kzak0TwLAsg+UJIPBGHxtlZJvQfYSXYT95awU4wahuMHW3ZM7VqkeDAv2X8pfcfnj/u3HvCCb7rKWdCm2QzT1gqBkI+/DNz0Fplh0
 GaVOvhJe
 HXwneRQSn5lY4uDZ9PEymyAhiQtOMJzGZT0E49FVGM427SEdKiT9OilQ/Srf4lmYvAWKrPzlip2+/feOCsPuTDovKEGY07xk6onqDDpDgh3gfGRZxCX3QgqLaw3mWPEEuO8NfL7kHZubkZBxUm8eaIeBt9ClRfmLmThOPtlEfc1ziQefWoPgOco6I85mTvT5mKUecOpL4IXhHu2QtAmgvH0vRYFaD3FnQYxBI48TW51FSqwRaTWANs5hYN3tcPaoJ7jjqZucDUhWfFHvqUhcl8cYHtaCf9GyP+6xPdGMklVywNWYAxi0ivFv9n/I0l9J0UQkbbLOiBY2sO2an/FaRP9NmMEQGgpvmICQscIm9Tvrb7KuT+3WOVQwcD7cc1EqitZNuwC184wjbCD7y/WdoobNHqqHJG7xfT7kO5XKdIiWDHHwokIsQEq/S50+ZW7MhDLTU/ZwejCA5VmUvztKlBWxtqbFZoHksJOwZ7bOWKQhihRKtTHjy9X6pSBuUlTYv0Yp1/ED4iUYPL4TmNHbXU9PsWpMf7+H+k9I3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 4:43, Matthew Wilcox (Oracle) wrote:
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

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
> 


