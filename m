Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C64D64082
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED616B008A; Wed, 17 Dec 2025 02:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDDD6B008C; Wed, 17 Dec 2025 02:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED886B0092; Wed, 17 Dec 2025 02:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEAA6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:01:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55AC8B67E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:01:44 +0000 (UTC)
X-FDA: 84228067728.19.5B48175
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA3B3A0011
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:01:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VkISLN4f;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765954903; a=rsa-sha256;
	cv=none;
	b=oqr0CD7/PxI+EiDxRTXY0ITx3/RhKGWSTN4dicBWHTCYXxX9rK3Mz7PrrtDjfpU5HeOYQj
	db2PzVrAOoSbAzJLQ3Wb4ZoAa/+5dYh7NwhHssKYo6+zEMKQZuJIZNZ8ON8JzNwGY7+pyI
	uGyeqaVTGZEVsBmnDGqx+B7V3npfPUM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VkISLN4f;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765954903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tV/MJk6Zfx2O/Rhft4sIpW80RJW2v174K97Jttoa3Q=;
	b=khsZqSR3i+2pAqNH/54qH9jDO2feUQdhoNRXyo2NwBUANmPPcVGg+zdEjrF+DHY5su+5I3
	6WsqxuBmsrns16OQjdu952TAKJ76dZT9WY6tKtOlcJyFkTLZ1weRFETn3CNKZClfyzUj7M
	rO/s+wrASf2Z4WrAH95BDNF9OLPuHkw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3tV/MJk6Zfx2O/Rhft4sIpW80RJW2v174K97Jttoa3Q=;
	b=VkISLN4fnJ2/4fsJ4fXfjr3SgmzQdM+AxW8gnGlSusZd7Za04Az4Fn5h98G1D1epV/NbXEZhn
	jPLhtoBJAAE3FwThHI0POsRRlbpxD2jyZA6Q54q719jdjOO+ue0iVJTxVj0C4rG2OS1XWRGLXFn
	/fKFYzaPjzGnhsBquhsDmjQ=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dWPlZ6LskzLlVy;
	Wed, 17 Dec 2025 14:58:34 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CEAF1180043;
	Wed, 17 Dec 2025 15:01:36 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 15:01:35 +0800
Message-ID: <2b19e44a-2562-4ea5-b52c-a216f565d734@huawei.com>
Date: Wed, 17 Dec 2025 15:01:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] mm: page_alloc: add __split_page()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
 <130003EA-0DFF-4C32-ADF3-DDB800494264@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <130003EA-0DFF-4C32-ADF3-DDB800494264@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: AA3B3A0011
X-Rspamd-Server: rspam03
X-Stat-Signature: jnqsxyq8uey6gmbhzd9fahjrunrjfiag
X-Rspam-User: 
X-HE-Tag: 1765954901-478409
X-HE-Meta: U2FsdGVkX19i+KFqfKm07370xAjKri+cYg67yAznLayjPv5mM2CRWfxJd7sBxfqWQL3PKym8y74pmTRsqCNHVUtO7UKUcTAzu4krbELTeH76clRvng7TufevXMa9jl7KPNox1PuprsCXdcAgTjqLiSBr1a7QI4QiVuSM+b9dB68fZfSKYP5z3wn1d4eLBZSknoCVwtvN+sd/Fw0znfZfeze4CTOKBYClzRngi8m4l7BCbhd/LAJ2jDKroEQjGDMWDMsO3daBLpMQddY1qwmvcRAipH0CUnVYvA3S7su4imKnJqYQtbkGGCr6drDFtyxGBwUGe3lOtW/3yF/xeVt2yqeR6LCOZEH52iyz6UbEy4rCDXN2QjK/Ss6ecFfmiwYL87oBnqIrseUM3ox0cHLjS3WL+RmVC4vdlYRM8cLavehg2tE7YYfZGW7l9NRJLGv/8styx99j2A6OfOMYYYBQRyHzaysOzhX5gyYzkbJqJTxA9BWKF6RJmA5UQ7B3uy6P0vUd0c8GCB24/EIzX6kXiD8QeVddvec8w81xvODV8yJ1BRBkZw3LpyTO5bsay/pp8mqocjFMYA0dcBdVbeEJkZG79OEKWTC4LI2fICwjGPjqwhmTfvfMHXtgIelcAWiLaNsWBtstEMXCs5efl039lMNlMQ5nGIVb2sqN4bEDsaBBC1uZWXp9OFSn2r3B2Ft+N8TNMRdNt2Ce1R2L6ESiyowXSgNsGHwbVK+yAEILal5wxhhg9JplIknGRPjym14ctHgTIKw6+emqLDojlT1kIaILpsfKL0320wIsOfOPvMGCC68NO2h0YYtCuS8xu1nZ5pOxdi32VUXiCwWiEqGD/DScRarDWhwzP+XaZh8dHKrreAj4P9PTUrYMQt6BmF8EJSy+gPZVPGbSnxii6DyFPMMGl5R5URNoKF6OMORpDJjknPR0kiAbseitV28wKJkPJlCd6dBlcxw18QO+4ad
 Gx2Uy1Xk
 y52e4whu2d3G0CE2EYmhgyhx0zcJEEhu86YU3R8qZdQctTj4brlSLmzN6IMD5H9WkEtfavt0tUCpe+5X1vRS4knz1vpzTxyyjIIiWprGGWXJQu2SnXr8rF7WIsiqkZJgBZ7Vc1n4R5Bd5gZ7j51sxQH4u7m+UbJ6kzTq9d38yw+zAaCXglAbLkE+aN3UWteI7mekaxmte+bNPw6oRYWZYF5OJLpb0ohVlzMOFX7D2iYzJLa6SyS1VEhYqhmQ79qPuOUWkvw3lJkxhdH6vcZTN9fkA3Df6rJpNiXpxIyrH8apptiKX10zQoxB0fo9PnlbSMia+LitRbqiaQldxf62SV+cHczPfwfYhklgbJ84cP4wASFVX5gDcaIL8wqdqVHN+9suzFwHStwC8xlMqutzTPcu792/aa9bm6WAFD8x8d6DqFAsExgcsyIwFbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 0:21, Zi Yan wrote:
> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
> 
>> Factor out the splitting of non-compound page from make_alloc_exact()
>> and split_page() into a new helper function __split_page().
>>
>> While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/mmdebug.h | 10 ++++++++++
>>   mm/page_alloc.c         | 19 ++++++++++++-------
>>   2 files changed, 22 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
>> index 14a45979cccc..ab60ffba08f5 100644
>> --- a/include/linux/mmdebug.h
>> +++ b/include/linux/mmdebug.h
>> @@ -47,6 +47,15 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>>   			BUG();						\
>>   		}							\
>>   	} while (0)
>> +#define VM_WARN_ON_PAGE(cond, page)		({			\
>> +	int __ret_warn = !!(cond);					\
>> +									\
>> +	if (unlikely(__ret_warn)) {					\
>> +		dump_page(page, "VM_WARN_ON_PAGE(" __stringify(cond)")");\
>> +		WARN_ON(1);						\
>> +	}								\
>> +	unlikely(__ret_warn);						\
>> +})
>>   #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
>>   	static bool __section(".data..once") __warned;			\
>>   	int __ret_warn_once = !!(cond);					\
>> @@ -122,6 +131,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>>   #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
>>   #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
>>   #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
>> +#define VM_WARN_ON_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>>   #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>>   #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
>>   #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index da32397b4313..aa30d4436296 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3077,6 +3077,15 @@ void free_unref_folios(struct folio_batch *folios)
>>   	folio_batch_reinit(folios);
>>   }
>>
>> +static void __split_page(struct page *page, unsigned int order)
>> +{
>> +	VM_WARN_ON_PAGE(PageCompound(page), page);
>> +
>> +	split_page_owner(page, order, 0);
>> +	pgalloc_tag_split(page_folio(page), order, 0);
>> +	split_page_memcg(page, order);
>> +}
>> +
>>   /*
>>    * split_page takes a non-compound higher-order page, and splits it into
>>    * n (1<<order) sub-pages: page[0..n]
>> @@ -3089,14 +3098,12 @@ void split_page(struct page *page, unsigned int order)
>>   {
>>   	int i;
>>
>> -	VM_BUG_ON_PAGE(PageCompound(page), page);
>>   	VM_BUG_ON_PAGE(!page_count(page), page);
> 
> Could this be converted to VM_WARN_ON_PAGE() as well?

Yep, will change it too.

Thanks.

> 
> Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> Best Regards,
> Yan, Zi
> 


