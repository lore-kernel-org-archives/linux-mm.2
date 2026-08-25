Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855F4C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4AA66B00CC; Tue, 25 Aug 2026 09:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3E46B00CE; Tue, 25 Aug 2026 09:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C1A6B00CF; Tue, 25 Aug 2026 09:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC626B00CC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:43:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3DBC4035F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:43:01 +0000 (UTC)
X-FDA: 85139907762.27.3E8E58C
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92ED2C0010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:42:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mT2IUX3K;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665380;
	b=XlmGIwQvcoE8ItESlDv1//4D8ECiq25Hdf27yESV7VKGDpKzZZK7F9rwbsX/Ghv8QqIQqQ
	PrV4Y2j9CVGwAi/fnXBU+RA154w/6dSbxqZFyXnQxc5JXjyaAMzaTDWXM2G7mCR1HgrTP3
	sgoS4UYSQndogmAvCHPsUwjJXgh7HT0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mT2IUX3K;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdHF2mFt+hNfOQQjf3NwqAsnZCfSAX677V2FA9NTOMY=;
	b=j8WLCKMByRw7amcmEGbqb4kE91O5VIwG+1H4e3+6Lai93YfobJ0bgtz9XSubDZebw20Yuz
	ExZ+ztrITA2CqpIsTswyHPk8lsFS9m3n3+zsc4m2ewR7goDt5tgoAcFoZgjd5kUoIXxoWD
	btGvyP1z0ghF3ZPvq1dP2cFZPOqvRMY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FfZDNuOqOdy6idQcHsHOcRGqdcW1dVvnf7/eAaFIrq0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665378; v=1; x=1788270178;
 b=mT2IUX3KOhNWdf3sv5YkZjo/qRolzKHmu0ai+tkVUGE+c/NbpiiQ8jRRh37VW/0Nd72EuvCf
 5cuOAR/cIUS0iu1MIFslJbG/atm/JLg77NmfkC8e2DK/YtpAkC50kyjx3IZFk+rwdeOw/1Bww1S
 agfNNfXvwP7Vg3ZJWtzZV9cc=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id f72d55ae91586379;
	Tue, 25 Aug 2026 13:42:58 +0000
X-Mizu-Trace-ID: f72d55ae91586379
X-Migadu-Flow: FLOW_OUT
Message-ID: <cccd0211-6fd8-42bc-aec4-fb7d643e415d@linux.dev>
Date: Tue, 25 Aug 2026 21:42:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-16-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-16-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 92ED2C0010
X-Stat-Signature: kyha5cs8xqghxt6g3ffzyko753sadw73
X-HE-Tag: 1787665379-945835
X-HE-Meta: U2FsdGVkX1+dYbsFlxhlh27ybe5N8zx8GME2UWiFgcJq5Zs4ydLAvr+2kKyvBnx4DjDTkBSm51LkoqRRuY0a26qzSb8GhXpIefgLCAkzWCQK3/hIMU1O95dzI7AaXAU5NlIJojXSAA+Mv21HL35+yLdtcKpk05iKuqPoHohOuC6cfiS0VJ+aEuk+4I8gzcm8I7BWF9XuGIawYOeTSD1GaLjrEB42vGnrcwyt5BM/S2/XKC2AxcLjfTXG9V14lhgDTWGZB1iCmQIGULkVNcg+RALOLW6QBklpimaqoB5V0VvlniKkofZtQWaydVICUcqnvyyM1gAFTJuVWVMBGR20Ft1BD5wAcA+MpJMw/yeDJVEnIVtRUx8F4UWMLoRI2/Bm5J3TT+LRGwO333cYgH4EINAKbhUJKV+JQqG9J3fBnAf41Zbfx/DL9zPPlen9dPWN1eGYgNCcFCuaCvnO1rw6fcCDIqy/+99NEskL+hSqHXbrmuCSG++Z6Z1Tfyh3mIuD4oFjB7VXQvmxCWA7FiYQwzaY7h7tDOiI0Rdf9CS73xNtTT+sKQ9UVh2OFNRTQjlslbnxuJkWSdAtyF6gVTPXvO2Rji/kuGarnaBp+IssgjeULj4VXYJRQP6Vg7pmJce9LUuKoYK5ihJQpltXbMLd5L5fpzBZhFRBgfUg4eMdlBGI6rZ8Zccu7LkrpntfBHZjdBOjexbcDo46GFiXqoJx+GYAfHZqmWViAz30WB9Ae05/znE1k2J/WUnv7oZqoRKcvZ+FFYXOOaTwS+LiBIYtz/BUd+11FDqf0ql0esn03JnN57Rx0wV1eEYRYwQBtEM+lX2vIT2CYmVwH5jTcDxzKgO0L6hQiYjTmpsAlncZ3R0Ib7EEnXAr3AvzB4uv9DOdz5TbkdT72D0fcCa1cSVP3kg9B6Nw87RbQ8yUMmJAq4a5K9d0FJL86AHByJcf2/qRHe0bHTW9c3WuqhZmf1W
 bV4Vg1fz
 CwUN0GM/W23Fv4SDCpAIrNehYCXWfUUrVPs/+kFlp+sj3AO9E5ATocVZRArI8lwfOPaODljs1/ta8LAIxQOP04CnBme02Rd3/KAUNvy3CCP5ZnXyVcPKRXtoLGbehffhPaGxsXCH3iW71/vK/M1QIgrBY99a/53SsvEgKEn1UpgGj3O25prAw46w2YwMRYNG56GhhGLRdE+OJhu06hb0Sj77mYaCLWxzQcJxb732FoLXqNj8d7rtyaXfcAaCwak8q1DSU2l0/lrFZj1c7IPmt6W7J1V3puJkCNlYVHRJP9I+REFWg9Rjvtkeax2vseN3kYmdZMCSaoRhDd5hyCcVeYH5XBskQshtiadFpLQ5nVsVjUTmFPNzKy0VB2Nca4jd2rIJlfThkKhEExqLeSrk6DpWyCN7cDMR/u6JDBZIMyjwiYzLMaBIAMlyl3Px4NWjbiyRR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> Track early CMA hugetlb pages from the hstate instead of storing a
> redundant bootmem flag. This removes the unused helper and keeps the
> bootmem metadata minimal.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>   include/linux/hugetlb.h |  1 -
>   mm/hugetlb.c            | 14 ++++----------
>   2 files changed, 4 insertions(+), 11 deletions(-)

It looks like this patch is unrelated to the rest of the patchset.

Is it just a drive-by cleanup?

Anyway, LGTM, so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 3559041a5a57..255a258f11d1 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -676,7 +676,6 @@ struct hstate {
>   };
>   
>   #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
> -#define HUGE_BOOTMEM_CMA		BIT(1)
>   
>   int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
>   int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4bb5a25849b1..6822fb4159fb 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3122,7 +3122,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
>   	 */
>   	INIT_LIST_HEAD(&m->list);
>   	m->hstate = h;
> -	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
> +	m->flags = 0;
>   
>   	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
>   	if (!hugetlb_early_cma(h) &&
> @@ -3198,11 +3198,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>   	prep_compound_head(&folio->page, huge_page_order(h));
>   }
>   
> -static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
> -{
> -	return m->flags & HUGE_BOOTMEM_CMA;
> -}
> -
>   /*
>    * memblock-allocated pageblocks might not have the migrate type set
>    * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
> @@ -3293,9 +3288,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   			folio_set_hugetlb_vmemmap_optimized(folio);
>   		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
>   
> -		if (hugetlb_bootmem_page_earlycma(m))
> -			folio_set_hugetlb_cma(folio);
> -
>   		list_add(&folio->lru, &folio_list);
>   
>   		/*
> @@ -3306,7 +3298,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>   		 * For CMA pages, this is done in init_cma_pageblock
>   		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
>   		 */
> -		if (!folio_test_hugetlb_cma(folio))
> +		if (hugetlb_early_cma(h))
> +			folio_set_hugetlb_cma(folio);
> +		else
>   			adjust_managed_page_count(page, pages_per_huge_page(h));
>   		cond_resched();
>   	}


