Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB13CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B39B6B0024; Fri, 28 Nov 2025 07:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AE96B002A; Fri, 28 Nov 2025 07:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8346B002B; Fri, 28 Nov 2025 07:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4D66B0024
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:03:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 203D489F45
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:03:44 +0000 (UTC)
X-FDA: 84159881568.27.8E046E4
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf09.hostedemail.com (Postfix) with ESMTP id B77AB140026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:03:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=T8jKQgdU;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764331422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JX+62Pp8uju8BDAawX/OvVTdkdk/Op1RBKURLR7P9E=;
	b=FhE3mXI773TbQ1xF0H/n98a9u+P+HP4dbu+W+DTnOSdzPSAfP3lUgMWeSQ1JLiCmbLMqDU
	yvhAq7cnoDpmss1UaBzHB/Hx9fSIyBX40+uUvVV3Sw2P5SVRaHo35h1dgis23NDv2o+Yn0
	V1NdXnuRueeOnNJFYwr5FIL23OhYcKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764331422; a=rsa-sha256;
	cv=none;
	b=PHm95Pr7C+i2XcWo4AdUfLnghpN6C2CvvulRE7qzoigeGzvNJ5XNTGeV/b1DkcbNOEb0n8
	sA3gtuPexhQ358L0h3SXa4bZ2QRY1jN28WCJ4JVi8i31cJLQ91FZ1+p7SX+ASAf2jiF/u+
	daxXopLLp+j32oJSrMuBwYj0Vcbv4so=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=T8jKQgdU;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=0JX+62Pp8uju8BDAawX/OvVTdkdk/Op1RBKURLR7P9E=;
	b=T8jKQgdUOojwZ57jCC6fGrfjMfjbJ1bUfWVkfdddJU9mts0KXWNl0SPe4yMyV+hE4QvHMzEsR
	Tag0V+kEBMrJ3vg2K/jFbTKgHoRy5XAWAj5amy4ta+4qVWckj2iitOol5zP8XByvimTHI+W8xjQ
	WCpmiGMcXvi7SIc+oslQCgs=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dHsN56YbpzYl6fH;
	Fri, 28 Nov 2025 20:01:41 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 20:03:33 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 20:03:32 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <zhanghongru06@gmail.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <david@kernel.org>, <hannes@cmpxchg.org>,
	<jackmanb@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rppt@kernel.org>,
	<surenb@google.com>, <vbabka@suse.cz>, <weixugc@google.com>,
	<yuanchu@google.com>, <zhanghongru@xiaomi.com>, <ziy@nvidia.com>
Subject: Re: [PATCH 2/3] mm/vmstat: get fragmentation statistics from per-migragetype count
Date: Fri, 28 Nov 2025 20:03:28 +0800
Message-ID: <20251128120328.8693-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <780ded63aca04eb513d6e7e2c8862e6972b84b45.1764297987.git.zhanghongru@xiaomi.com>
References: <780ded63aca04eb513d6e7e2c8862e6972b84b45.1764297987.git.zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w011.hihonor.com (10.68.20.122) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Stat-Signature: ib9hua3s3aoicauebmk5yozqz36myn44
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B77AB140026
X-HE-Tag: 1764331420-982986
X-HE-Meta: U2FsdGVkX1+ybJxtBSWzdHFqyTMhIwvBjjKnFBCdOEwPv4Nd07xq2Xz469K88UXyt51biYVDScOU3GwB3R0zOjHUdMLA3oSFvO/8fSUYf+A4chGYTYi3IHX+0aKwcYmQQCCxDk7Qnx1TBBydHHXXGVMpXqBCZbYY2kSP+4/sJVldS+rv+oDehZQRmohF9IHm7946tN12nSyxxZImbfI9NwD5M39ntpOCMwMOVVfIt3oTZExBheLYXCA1DfLcUEERhJ7aqBke9TZLypPnA60CPiVIIzq9tylDDHAO6g1qBoGThowI7vDT8CgoG48esHLanKGbzO+MQIcmy6wiuDbn3YjiSjRS4badiitUXZwhvIIxkJW4eG9o/dQCjhF16Cpm+hOt56Q5PzMEsRsbKXv2u89n1ndtieTkx6qZECYO5yxe213QKPmd/4MjfuVJ57zrpgQxakeyMg0j7ooNZZQdAA33IUgyfBQu05x7Q0dM/SI/O4XXEcf5zJBxd49LKNqQMZOZFCJNInxc7GxJkaOabiBzdLCoBsmrSnR5K0pOHrYUhWZ+y2cPbkeaqZd0JWQM7ZBxgRKEvaM4ijCZWbbPkn4Jkgz+el3+yw5NlZhb9S+MErw8Od3Xsu53oG/FfoDKn1zb8881XF2bWHin+u2w2clNk0lObGixcVwzuUG1tWx2fcX8g5mtbTpnIES/2cgz14odvHQgx34UvqjvGe2GMWzZ872T2J5eIuD1iRHUZQy5HpNxuo/SOjQ9CVqdddrwRV7nBpIanYM7A9hodFF0H7FyUDSFD14LipW/KbM5XkeFPTNdPeBaBha7Ii1QDZWV2fZuixMa5nQFpiHAVDtSnwEiPEVRLJEdJhLqsBcXBNKQU3sa9/ttEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Hongru

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9431073e7255..a90f2bf735f6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -818,7 +818,8 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
>  	else
>  		list_add(&page->buddy_list, &area->free_list[migratetype]);
>  	area->nr_free++;
> -	area->mt_nr_free[migratetype]++;
> +	WRITE_ONCE(area->mt_nr_free[migratetype],
> +		area->mt_nr_free[migratetype] + 1);
>  
>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
>  		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
> @@ -841,8 +842,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
>  		     get_pageblock_migratetype(page), old_mt, nr_pages);
>  
>  	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
> -	area->mt_nr_free[old_mt]--;
> -	area->mt_nr_free[new_mt]++;
> +	WRITE_ONCE(area->mt_nr_free[old_mt], area->mt_nr_free[old_mt] - 1);
> +	WRITE_ONCE(area->mt_nr_free[new_mt], area->mt_nr_free[new_mt] + 1);
>  
>  	account_freepages(zone, -nr_pages, old_mt);
>  	account_freepages(zone, nr_pages, new_mt);
> @@ -873,7 +874,8 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>  	__ClearPageBuddy(page);
>  	set_page_private(page, 0);
>  	area->nr_free--;
> -	area->mt_nr_free[migratetype]--;
> +	WRITE_ONCE(area->mt_nr_free[migratetype],
> +		area->mt_nr_free[migratetype] - 1);

It doesn't seem like a good idea to use WRITE_ONCE on the hot path.

>  
>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
>  		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..9334bbbe1e16 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1590,32 +1590,16 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  					zone->name,
>  					migratetype_names[mtype]);
>  		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
> -			unsigned long freecount = 0;
> -			struct free_area *area;
> -			struct list_head *curr;
> +			unsigned long freecount;
>  			bool overflow = false;
>  
> -			area = &(zone->free_area[order]);
> -
> -			list_for_each(curr, &area->free_list[mtype]) {
> -				/*
> -				 * Cap the free_list iteration because it might
> -				 * be really large and we are under a spinlock
> -				 * so a long time spent here could trigger a
> -				 * hard lockup detector. Anyway this is a
> -				 * debugging tool so knowing there is a handful
> -				 * of pages of this order should be more than
> -				 * sufficient.
> -				 */
> -				if (++freecount >= 100000) {
> -					overflow = true;
> -					break;
> -				}
> +			/* Keep the same output format for user-space tools compatibility */
> +			freecount = READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);

I think it might be better for using an array of size NR_PAGE_ORDERS to store
the free count for each order. Like the code below.

unsigned long freecount[NR_PAGE_ORDERS]

spin_lock_irq(&zone->lock)
	for_each_order
		freecount[order] = zone->free_area[order].mt_nr_free[mtype]
spin_unlock_irq(&zone->lock)

for_each_order
	print freecount[order]

> +			if (freecount >= 100000) {
> +				overflow = true;
> +				freecount = 100000;
>  			}
>  			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
> -			spin_unlock_irq(&zone->lock);
> -			cond_resched();
> -			spin_lock_irq(&zone->lock);
>  		}
>  		seq_putc(m, '\n');
>  	}
> @@ -1633,7 +1617,7 @@ static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
>  		seq_printf(m, "%6d ", order);
>  	seq_putc(m, '\n');
>  
> -	walk_zones_in_node(m, pgdat, true, false, pagetypeinfo_showfree_print);
> +	walk_zones_in_node(m, pgdat, true, true, pagetypeinfo_showfree_print);
>  }

