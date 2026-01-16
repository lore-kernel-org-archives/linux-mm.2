Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FD1D47CA3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBCB6B0005; Thu, 15 Jan 2026 19:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A4D6B0088; Thu, 15 Jan 2026 19:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B1B6B0089; Thu, 15 Jan 2026 19:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 165156B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:59:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFDE81AE65A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:59:00 +0000 (UTC)
X-FDA: 84336017640.11.29C03FB
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B59440007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:58:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3eJkz42Y;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768525138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OX6+5iR9Ja/KZhCm1yrNNQ6iTqrRjS3opVxY4WCyYuU=;
	b=XDTPRCyIpsMI3JjgORwbX2ke14uWoFODMHLDs8E26A4JP3vDjbohrF4tB86ZgSTCSM8Lxm
	aIdfEaSSvJ0NDWyEizTW/F8dp8z+5gBeiT2ROAd6P5dqsR6TY6X22J77Z6YDoKdEKZe4Pr
	n2I7FNlA8C58hazmbvhHm5jWOSZDAD0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3eJkz42Y;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768525138; a=rsa-sha256;
	cv=none;
	b=oh/90ATNSrK/kwy3dvE6W1xMfrlU2GZQ8w/i2sX777EJbFpW5b9XoGndX92qHb+OvDdknR
	UY6kFz6/hZqhUVoklD5A+OHgztd7kvhTsJDCYD3Q/Yawg/VnYd3YBGbJaykpiPC+1Lqo69
	D/ugg6SahT8e0b8KSJ8knbxf3IiZPBQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OX6+5iR9Ja/KZhCm1yrNNQ6iTqrRjS3opVxY4WCyYuU=;
	b=3eJkz42YgfDarheQVCNN7L6m0/IEb6aWm2MOEcfktiqXvI0+61mYQt5Rbp/w+Hf2pf/WMhm5y
	rtbiAUPHH8aEnWtSVa/otdoNyyG1zlxcVlVmQmspsKiZiqhJHMs4lVtKze/H0WQwWXvbCEn3CF0
	Qxrs6jOd8tWRS43IOnzIPng=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dshGW3bY8zpStc;
	Fri, 16 Jan 2026 08:55:15 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id ECD6D201E9;
	Fri, 16 Jan 2026 08:58:51 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Jan 2026 08:58:50 +0800
Message-ID: <da4d80b5-339a-400b-8e1c-c758ef56c460@huawei.com>
Date: Fri, 16 Jan 2026 08:58:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: hugetlb: optimize
 replace_free_hugepage_folios()
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
 <20260114135512.2159799-1-wangkefeng.wang@huawei.com>
 <20260115144228.4b103d0b37b0f3fd017a4d9c@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260115144228.4b103d0b37b0f3fd017a4d9c@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 9ffgcyn3sxh1s94898ko4t88ca7upg7z
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B59440007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768525136-464182
X-HE-Meta: U2FsdGVkX19RyYvk+0QZg7BoiLFrwhcA3+5BBt+Y+yx6LRNY2aC7rTFpvaga7EzZOWsWQNeruTY7Q673RmDqDGP7ePWHUslg+WgvimfKZiRSNgjw2p1CEC+apMiunowlGg0JgdHSL2OXm1hrIC8zX/pPHhSfNwEOef5jFZ8g4PuKNQoTQVoMboF85Ernjy++dniqhaO0aab12ig+QKZiWLrKfVeGjo4ex8isKLw2/RzcL9JX7oPxvk18iQn9L24c82R3R5BZGIrR/b7pFjrOhhaoaEIPmkKCy08AM1gxbGAa5hjUErByl8zK4lclCS5maFEPtbMqyEfiJAP4PgLtAHqTh0OvevQF+k1lznM5twn779hgdbQO534nhmGeEReXP093R9/ZrGPJoGQUL58KvMz9hyLSgjIwhadhJdKjtgiDfb6v/loFVPhOG3OZm3DBnSh8iaKfyqQh88dn6IjU7f8VBUUojVC6rut48ZzbUM73aJzM5XLo1vqC4Kjc/wU5DD0/9a9C5ZhVEP0TwzDK8C8g859GLCdgLKfFIIEQZnd3j2ivT6WlpxjcCzZ7YBRoSx/pmV299V+R2yohJOrbJ6ZkTciaFNLFHXKo44O7Nk4kpWLldT30pcLsmP/xwmA03C3oyPojd4VoX/22XXWOxhO9QbzoCGnW+YnT4QBSsaUbt9kf9m640BCL9Xp4mHLzuvKqpF1+KrKSEtir9bLwBEtIzyNvt3pa9EVk0VWPiIlAVT3mvDCX0CJEwg3iEDwyuw7TDwPkvZRozJ9Hs9y9zCDvKpTDaAnjDIFNZBAlxB745YpFBO8TTWW0Qe9nzDS8j5IkpxVkMbmVqRyKY0bb4Zk1NGryrGw+yeKmVAOZmDVxiz4Tpw/4xrSW0uEw74J7Pk6qj+rCQMegP8Jre4snvoHq8A0ApTJ3H+xX3NskPPMttHhRmr+m7WE7qPiMXF1KFiJPoh7iQTQwTHr4mc9
 SCCkQRhG
 4iYbxG6e+U2oWdECkDsDE2tMt0AeAt8CtBQ/euafDKH3Mq6r63HMYFf+Ip4jMtfbTKk+ejI4MIbaBdJwAijpMwTDjbUnmlBkd+ZQIkMD1nmlAX6t2dE3jwg8ngLXZo7Vz+cdOpizMuc3WRzr2aEDgY5m7hz4dTmgKbum3cNFAf5UrX7qO2DAWBCvilWgdfjZXa1v8ZBmXgcFnpaWeYp1ccooBl8HZMmAufK0zgnbtKUKAeW2qzCSVEkvVQ5Cwgf5ix7VFztpYgZi07n1RLIKhIJBLYEh/3MZhBTkHrduMIXuaof11xUkIIOyDacgGK8SVoGEJvJgnfcS18V6whDcR3u+Qfx0eLc8NvGuLeqjKrYC7MhrqZZ0IdT1/m8g2CnDq81tOPyc+u+DoByMLarziXyq8m3skipp6xu6mEH/8acKrzZrNr/1wgySOGsaZ3wrINjGblM2oZmD2en3ZMvrCrpJEWavmcKWjJ98WBIm+tnundZWK7439g+gORkmApaogQNa2y0jgejynkY9+jeESI0xNbj9L3jd2orls19k3m/xzdqd8+kzPYxdvMWLfwxWBFeUoi0MKaB15EqMDY1BFvkjXwPIxQvOGzB9s5Ka4PETVxSLuHWOeOOyGs3yqnIvRQCdFepk9YhS0dILnPENPIOmMRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/16 6:42, Andrew Morton wrote:
> On Wed, 14 Jan 2026 21:55:12 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> If no free hugepage folios are available, there is no need to perform
>> any replacement operations. Additionally, gigantic folios should not
>> be replaced under any circumstances. Therefore, we only check for the
>> presence of non-gigantic folios, also adding the gigantic folio check
>> to avoid accidental replacement.
>>
>> To optimize performance, we skip unnecessary iterations over pfn
>> for compound pages and high-order buddy pages to save processing time.
>>
>> A simple test on machine with 114G free memory, allocate 120 * 1G
>> HugeTLB folios(104 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>
>> Before: 0m0.602s
>> After:  0m0.431s
>>
> 
> Thanks, I'll queue this as a -fix, below.
> 
> nit: the function has become rather a jumble of bailout styles:
> 
> :				if (order_is_gigantic(folio_order(folio)))
> : 					return -ENOMEM;
> 
> This could have done ret=-ENOMEM;break;
> 
> :
> : 				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
> : 				if (ret)
> : 					break;
> 
> While this could have done `return ret;'!
> 
> Single-return-point is preferred style, I think.  Mainly to help avoid
> leakage of resources and locks as the code evolves.
> 
> How does this look on top?

Hi Andrew, I'm fine with it, thanks your for the update.

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
> Date: Thu Jan 15 02:34:07 PM PST 2026
> 
> use single-return-point style, tweak comment
> 
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/hugetlb.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
> +++ a/mm/hugetlb.c
> @@ -2834,10 +2834,15 @@ int replace_free_hugepage_folios(unsigne
>   
>   			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
>   
> -			/* Not to disrupt normal path by vainly holding hugetlb_lock */
> +			/*
> +			 * Don't disrupt normal path by vainly holding
> +			 * hugetlb_lock
> +			 */
>   			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
> -				if (order_is_gigantic(folio_order(folio)))
> -					return -ENOMEM;
> +				if (order_is_gigantic(folio_order(folio))) {
> +					ret = -ENOMEM;
> +					break;
> +				}
>   
>   				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
>   				if (ret)
> _
> 
> 
> 
> 
> 
> 
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
> Date: Wed, 14 Jan 2026 21:55:12 +0800
> 
> Turn back to use alloc_and_dissolve_hugetlb_folio() since Oscar pointed
> out that the return value is different.  Then adding gigantic folio check
> independently, also update changelog.
> 
> Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/hugetlb.c |   10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> --- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2
> +++ a/mm/hugetlb.c
> @@ -2810,6 +2810,7 @@ int replace_free_hugepage_folios(unsigne
>   	struct page *page;
>   	struct hstate *h;
>   	LIST_HEAD(list);
> +	int ret = 0;
>   
>   	/* Avoid pfn iterations if no free non-gigantic huge pages */
>   	for_each_hstate(h) {
> @@ -2835,9 +2836,13 @@ int replace_free_hugepage_folios(unsigne
>   
>   			/* Not to disrupt normal path by vainly holding hugetlb_lock */
>   			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
> -				if (isolate_or_dissolve_huge_folio(folio, &list))
> +				if (order_is_gigantic(folio_order(folio)))
>   					return -ENOMEM;
>   
> +				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
> +				if (ret)
> +					break;
> +
>   				putback_movable_pages(&list);
>   			}
>   		} else if (PageBuddy(page)) {
> @@ -2851,11 +2856,10 @@ int replace_free_hugepage_folios(unsigne
>   			if (order <= MAX_PAGE_ORDER)
>   				nr = 1UL << order;
>   		}
> -
>   		start_pfn += nr;
>   	}
>   
> -	return 0;
> +	return ret;
>   }
>   
>   void wait_for_freed_hugetlb_folios(void)
> _
> 
> 


