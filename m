Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C2CCD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5F46B0088; Mon,  4 May 2026 12:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE346B008A; Mon,  4 May 2026 12:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA6F6B008C; Mon,  4 May 2026 12:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9096B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:14:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0430A01FB
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:14:48 +0000 (UTC)
X-FDA: 84730235856.03.3125416
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0225B1C0011
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:14:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777911286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1P9yye2AacZGkFluFiOG/ZeUZGaSHzB0JR5wv/9XrM=;
	b=iA0cFDvGKD3shwhKbDuFvAKVwOPKQb18GLN/BmaRnfCaa7kIEkd1UuUiCrtaX3H6EZFIY7
	3o5oYiv+/gkEEl6uY34sPTW54C5DAoEoXa0FzWAkaLe4cHHf6SOE911Lt+1nZCE6Q2dFwW
	4qpPShwVkUJICpksLdnJMjpSpMwtPg8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777911286; a=rsa-sha256;
	cv=none;
	b=SzUIJ9bY7eCYTtiSj/GZPtQaCP/THImdkNsZU+cq8kxxV2brlOt5yzZ3wgjNpi8P8pJycT
	6S08nYfe45JANSMPzEtYQAZuEgaHfGvmowFHW+0mDSfS6F43tFQsp8JnWOv75ZxQWoSPDU
	annqGDqyAoKAkXfZpxkvj2s4pFgfp9o=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g8RYF5kG5zJ46XM;
	Tue,  5 May 2026 00:14:25 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id CAA0E40572;
	Tue,  5 May 2026 00:14:39 +0800 (CST)
Received: from [10.123.122.186] (10.123.122.186) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 May 2026 19:14:39 +0300
Message-ID: <616a62b0-680f-4a86-8ca9-75bba10684dd@h-partners.com>
Date: Mon, 4 May 2026 19:14:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: drop page refcount zero state semantics
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
CC: <david@kernel.org>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <gladyshev.ilya1@h-partners.com>,
	<harry.yoo@oracle.com>, <kirill@shutemov.name>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <muchun.song@linux.dev>,
	<rppt@kernel.org>, <surenb@google.com>, <torvalds@linuxfoundation.org>,
	<vbabka@suse.cz>, <willy@infradead.org>, <yuzhao@google.com>,
	<artem.kuzin@huawei.com>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9fd8ebbc0f4f45be611bae0d03dd25dd994233c0.1776350895.git.gorbunov.ivan@h-partners.com>
 <53FA8505-E7C0-404B-B7F5-3EBE89B64E0C@nvidia.com>
From: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
In-Reply-To: <53FA8505-E7C0-404B-B7F5-3EBE89B64E0C@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.122.186]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0225B1C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: dkubqt11awuiwendnxwopakefgatbg1g
X-HE-Tag: 1777911285-17252
X-HE-Meta: U2FsdGVkX1/KUbDD0515Bq8bO9bRrgLB1ILAobTUOwo0mYyKm/ExpRpyzp8pcgkQm7jh1oTEUAVT6uD+axqfxa1Eg1g0RF+qAHeXJd760Akv3pjehPxmyjky0uxNRLtmKYktjCIL78xw8kQ5htIdnq8UcwZRiIv7KPtfc66lWhcN4wjO/cMsKn5k/N8y61Om5faEoxVrWWfsxU+hpvz5Ty9gPb5ijkkIisHI0WsmhGWoSGAjo0bVdU0G/bVMFTn5cYdfVQ2+BrKLubfajVBMedn7VsVzLhJiq63/CEsEBLJdQN1wlxgWSpkuKorSYT8ICyrE3jwZdgE5GjWKo9Hl4IkOwtPmZbhx6KJGjqB42EGAQzx/BQlIqfDsfdXzpZwWSqAhvLpKtuJdc2335P5gaCvO+gA7va+K/SS0LXvYIqT106uehmp3PA6kh8SrL40R0jMXth9hmqFhi1kdj9Inf1EhPU30QGiijfJIE0PPKon7GAHW7dii6jVZQbBhqECR0zexz0J0izRTJKgIl7eKrAIJe1+v3OG9TKTs7QWq2V1lPRDc9+9+m+rW0TlG01CcKuJR5Nh2cY3YJ5IfKKmqx/xXI2y5PAJoNLySXO08QttwncHrJcpD4nir+itqz9/gSiFb0y4r73MpJdZq93z5tvWVIbhQY0er1N1J5bzjmKhIVAGSMbV+DV7GL34q37Tg0z4GAoJXsGZw8WK6iWmbWh5bZzF1kpivoPIaeI8GF4EDlYbhkQelN/FjSP6SuW6mQmvrnXfcVHdbYdYXWX8N6vMTRNZHPqbup37NmtsotEaSGwKzRe84UcaHHOCMy3tQJBUPNjUH//MoRYmCUaqAdsYf+wiLgRSBknskGwdtJTXynMNJdD/xW1ImqFoogQ195y7RdpuHDkKPX/c/ZPjNnZmre863G1E7t5xryD9iEqIGE3+gKTyJp3UqYuIv9Z6FMo81P6pq9Q9fiU9cSHB
 tcYXdiTI
 gVvq9sUr5FsqzE02bQU7NUee3BPCwH2sv2aaMdokbWzcKmaNLLBFhzzO94gTxfv5rc8GG/YSEMoPhuJx8kGrL/q7/dAdPjasUYGqzU6Ojj8Fe3WmRMkpoH1V2fJ0jAubp+wdwJlAv8PQioF6oF5KSM7iA45ECVOSE+1dd0L7pT/WCwlFz0Laq/YOa7AhR3JtrOIps13m7Cx3ptL5UFu2Mg9JAvhm4Nxx1aYor
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/2026 10:32 PM, Zi Yan wrote:
> On 20 Apr 2026, at 4:01, Gorbunov Ivan wrote:
> 
>> This patch proposes 2 changes
>> 1) Deprecate invariant that the value stored in reference count of frozen page is 0
>> (Getter functions folio_ref_count/page_ref_count must still return 0 for frozen pages)
>> 2) Allow modification operations like page_ref_add to be used only with
>>     pages with owners
> 
> Should we also ban calling set_page_count() except init_page_count() and
> set_page_count_as_frozen()? So that no one can manipulate page refcount
> randomly. The same applies to folio_set_count().
> 
> All set_page_count(..., 0) are converted to set_page_count_as_frozen().
> All set_page_count(..., 1) are converted to init_page_count().
> 
> We might need an init_folio_count() for folio_set_count(..., 1) users
> and folio_set_count() has no other use.
> 
> I see set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1); from
> mm/page_frag_cache.c and it could be converted to page_ref_unfreeze(),
> since above it there is free_frozen_page(), which makes me think the
> page is frozen.
> 

Overall I agree, but this is out of scope for this patch main change. 
This could be handled as an independent patch later.

>>   static inline int page_ref_dec_return(struct page *page)
>>   {
>>   	int ret = atomic_dec_return(&page->_refcount);
>> +	VM_BUG_ON(__page_count_is_frozen(ret + 1));
>>
>>   	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>>   		__page_ref_mod_and_return(page, -1, ret);
> 
> VM_WARN_ON_ONCE() might be better?
> 

With "locking via dedicated bit" patch modification, any function which 
drop reference counter to zero changes the behavior of 
refcount(page_add_unless would succeed and etc.). This could lead to 
hazardous results. Therefore, we decided to prohibit that completely and 
make zero value only possible as middle state during dec_and_test.


> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 65e702fade61..27734cf795da 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1639,14 +1639,14 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>>   		for (loop = 0; loop < nr_pages; loop++, p++) {
>>   			VM_WARN_ON_ONCE(PageReserved(p));
>>   			__ClearPageOffline(p);
>> -			set_page_count(p, 0);
>> +			set_page_count_as_frozen(p);
>>   		}
>>
>>   		adjust_managed_page_count(page, nr_pages);
>>   	} else {
>>   		for (loop = 0; loop < nr_pages; loop++, p++) {
>>   			__ClearPageReserved(p);
>> -			set_page_count(p, 0);
>> +			set_page_count_as_frozen(p);
>>   		}
>>
>>   		/* memblock adjusts totalram_pages() manually. */
>> -- 
> 
> Not sure about these two, they freeze p and p goes into buddy without
> unfreeze to refcount==0. But at the beginning, you said there are two
> states:
> 1) Unfrozen page which right now has no explicit owner
> 2) Frozen page
> 
> 1) means free pages in buddy. But the above change brings frozen pages
> into buddy, mixing the two states into one. Is that intended?


Since state 1 only appears during dec_and_test, pages in the buddy 
allocator are considered frozen. So there is no mixing of states.

