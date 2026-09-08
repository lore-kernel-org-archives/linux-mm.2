Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F8DC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADD26B0092; Tue,  8 Sep 2026 08:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E8D6B0093; Tue,  8 Sep 2026 08:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8755A6B0095; Tue,  8 Sep 2026 08:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605B36B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:18:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6D461405CB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:18:33 +0000 (UTC)
X-FDA: 85190498106.08.7E2B76D
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCC61120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:18:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tLj74R80;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788869912;
	b=7QF/aoB9zg4l9fADBrFUfPZxDjyZhCpweyDIdQyZ7KcqLwM63KoiSYfqDVFJmE9fMijGp5
	knRSMZknjZsG33flTqBacaxihlUk+QxoOd+gP0lKYW1MTLy9DZyIDjZ0Uw19hGBLDSlaza
	+zFODeRnUem/2zbl7bw214VQBYlo8D8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tLj74R80;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788869912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymu30IFequ9j8mwpIl1fqgOuunAR0A9gnw/b4W0QRgQ=;
	b=377WhaSQXh3lzzRZRYMYiUW57Lf+vKP/BdkRzRXw0EVk5+UWyDsZxt8sXwQAGO4K+ywZ2y
	F3O5sN7JKzAG1hAKu4/EF3qOGdY2oQgLwWr4y07EcLgW1FiZ1bx/akmoIX2hfO9WJcBeak
	/ny8bwUlkKF2YCbYumxYFV7NP5eblIQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ymu30IFequ9j8mwpIl1fqgOuunAR0A9gnw/b4W0QRgQ=;
	b=tLj74R80BzjABZm0VutAzoakmtJkuevI6rCYwabEuTFLDXgsbrVrO3rjC1plZB+JxSK5swNTT
	VFuKA0pvqJ+UxMGDZNYm1QOBGAxXScKmM1V7CKO+aMjBPoNiYLtMQSRWq9HJaIG/6sHeAPNT5+K
	8vUnrj07jeUrKI+b/zoFozw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hfN3m6SW0z1cyVf;
	Tue,  8 Sep 2026 20:07:32 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 07FBD40565;
	Tue,  8 Sep 2026 20:18:26 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 8 Sep 2026 20:18:21 +0800
Subject: Re: [PATCH 15/25] mm/fbatch: remove shake_folio() shake_page() from
 memory-failure
To: Hugh Dickins <hughd@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry
 Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, Christian
 Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, Christoph
 Lameter <cl@gentwo.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, David
 Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, Jan Kara
	<jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
	<hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau
	<kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, Leonardo Bras
	<leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti
	<mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman
	<mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>, Minchan Kim
	<minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, Qi Zheng
	<qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Shakeel Butt <shakeel.butt@linux.dev>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, Yang
 Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, Zach O'Keefe
	<zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, <linux-block@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <213f92b1-7ac2-189c-4656-ba7d00cc7666@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1563bfbb-0596-1217-b407-2d1504627bef@huawei.com>
Date: Tue, 8 Sep 2026 20:18:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <213f92b1-7ac2-189c-4656-ba7d00cc7666@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCC61120004
X-Stat-Signature: 45oa1b3uur3nhgbktaj7qbs4iao57cf5
X-Rspam-User: 
X-HE-Tag: 1788869910-764156
X-HE-Meta: U2FsdGVkX1+Lkv2gCOw/Shvx4QFP78czDK9SZ0ZX1fuUn5s2wiQWy8i4ViIGlIyAKjn4j2OYvyuaNyiA5XCysdOlwNlEE3DSGFYS4n1O2GRbTLIrRneGkHD6iOI/asQxgbUq76Wr7POs/8cOEv1JEnKbFROSD84V515CsAMZmnReiY5kJuVUQBeUixg5uobAlBwpmWmfirGJEPFG7eLabVyHtA0qOULpqSAM+Tzwe5SNeOZ6vkI8o3g3p1ND1/vVvnQ6JyPbPpdxmes5cLX9hkXhJPR3hSXAxhAwHrsR7P210Kpw9nzWxuEM0g6ICQlasYcDHw88/8WmEyv/2AdmZL61BA0ZL7u87njWzzLbMencBO1PSmH2E0+qP2Zv/7Lms3w0nHld9lnVywoclgf0J5PNtSLktjEYjJ+3mPXgyCTLJcj4vfbUz4vFJkY5mdNAMGo6aMmLjG2uMcttnCp0FO2lCGd+4FDglG/fvLj/rnZktaX/PuhUp+zNek64ISoTbHbanez3mS5RIGVZyIehAa4ZD8/ZadeGQLDxdkAl6Pfw5YRa1/l+qASzFPRhSS7pgPFZdkurPnuHNFulnIQMo7J1yiWm2PpKuXF/Uq/Pblhd2nB/UnZT673PYVUXvgjGt7kv9Lfw0nEE+3RGrHWKhLil0h7cNfbznlJimMQ9PHbqSnJvvGk0s4HyCok8u52/PwjMOpVQ3Zen21ltJ973sIq1VKOotyKJcZ+AeFdyVT58oXAG7+M85gyWo1YblgC0udV+zR02Plos7O0VvcYfZaSUFx0Cej1hm4g0+fwRkvvKcwQunVVTHobFeWJdEsmFipo0sLuwVYiwMV5vSQ0oPwfsojG670EwnC98d1V1wt5v1/BsqlUlK/bb3rBk0d4+ZpAbfDoOdG0rLdFey+LFKYWe13xqpqU2WYXz0EXJuAKM4+gAnL1wByhxpFFbSQY3BtJOP+q/Q3uf4IQH+9O
 00ed/GFx
 AYG0yvfIiVSOpmLPXDEJ4yAAZmHj/3J+dHsZ9gpmKfzQGD/Yb5Yclv69j7jU9nrGl0kOupW0yoRO3cEdJ2wgk1boLqTrPjgN7bMkFUJSIkzOEIMUyPLmfUTjXzT2TdLLE5HIfF4TTSYHcTQWPr/WNVlEUzIr9+d8dBFNH0HHdw3lxikQrPRg/14RE/ZHrzRndUbZxw1kvdXA2p8zhJSOh1KLqcIyShVzNYFZ2Ux4jLe1eYV7R9ep2g4gPYC7m21DsYu0qONBGUOllXQdEgv1fplYhxKX7S4ElyM1TfGTvnGF5iVTDFafwS6K2vjnAAPP6/5jMoMBcqC7xCGPTjkKtacp/suNVWQzBqH3dNjA2DUDnXvGS2N1VYfnoIe0PNDuTwP+VlcaP1bs7AJKEvxFVZMmlHG/QSScw8AMgi9hU6QTJCuZMB49GwYlBj9FhsqkHd4PH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/24 22:27, Hugh Dickins wrote:
> shake_folio()'s lru_add_drain_all() no longer serves a purpose, now that
> the per-cpu fbatch references are gone. Are the retries in get_any_page()
> then still useful? Not obvious, so keep them.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/hwpoison-inject.c |  1 -
>  mm/internal.h        |  1 -
>  mm/memory-failure.c  | 38 +-------------------------------------
>  3 files changed, 1 insertion(+), 39 deletions(-)
> 
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index a11222572f97..9eab4b7d25b2 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -118,7 +118,6 @@ static int hwpoison_inject(void *data, u64 val)
>  	if (!hwpoison_filter_enable)
>  		goto inject;
>  
> -	shake_folio(folio);
>  	/*
>  	 * This implies unable to support non-LRU pages except free page.
>  	 */
> diff --git a/mm/internal.h b/mm/internal.h
> index ff4bd3a14539..9a25552cbd83 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1140,7 +1140,6 @@ static inline bool node_reclaim_enabled(void)
>   */
>  #ifdef CONFIG_MEMORY_FAILURE
>  int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
> -void shake_folio(struct folio *folio);
>  typedef int hwpoison_filter_func_t(struct page *p);
>  void hwpoison_filter_register(hwpoison_filter_func_t *filter);
>  void hwpoison_filter_unregister(void);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index aaf14608b30e..2a6a01e260ed 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -310,30 +310,6 @@ static int kill_proc(struct to_kill *tk, unsigned long pfn, int flags)
>  	return ret;
>  }
>  
> -/*
> - * Unknown page type encountered. Try to check whether it can turn PageLRU by
> - * lru_add_drain_all.
> - */
> -void shake_folio(struct folio *folio)
> -{
> -	if (folio_test_hugetlb(folio))
> -		return;
> -	/*
> -	 * TODO: Could shrink slab caches here if a lightweight range-based
> -	 * shrinker will be available.

I'm not sure whether we should keep above TODO. Anyway, this patch looks good to me.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

