Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275E6CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F292C8E0008; Fri, 12 Sep 2025 02:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB25E8E0001; Fri, 12 Sep 2025 02:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A148E0008; Fri, 12 Sep 2025 02:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C19C68E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:01:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6632C14067C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:01:03 +0000 (UTC)
X-FDA: 83879550006.25.4E11BDD
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA19940003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:00:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WHVBi7EH;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757656861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLsF7+Q1zrfHEs5l04CnhryOY9ONAIlweBy7g0bkxoM=;
	b=v19oRA39BvAm+EcSxsqTNjYItN0SCNi55nCxL3JWHayjApY289lLzgj1mfMNEcoengV+Ie
	1xde4K3t77tFmRlXLrh7IOSpGoxxVFNyU0dkrjNj2MxVlOpqXVPZ9FR7lQvIx4skxZ80VZ
	lf7RYWYI7lpaoiPY29ywPQB2/B1j6bM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757656861; a=rsa-sha256;
	cv=none;
	b=DS0r/dljL81v4LrhMOHrJSKDAqJjRYBTEIDc7jvclyS4t86IfgOyGZJvtWzlAexCXnaB+M
	QSc4sHLYc8wn6YtPdGPkvr3pogSCyxGHcvakMFS4/7LActmm+6k5aJuO7j61rY6QT824Yd
	YIUjflVFEJoDeQFfW95ckIIDfuTVXuA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WHVBi7EH;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757656856; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KLsF7+Q1zrfHEs5l04CnhryOY9ONAIlweBy7g0bkxoM=;
	b=WHVBi7EHzWVroIFd4DW8M/GZPdh3TndKXAtdn7RkK4sGV+/sZdU0gprwpViss3bBb/m4zsZ6ueIyrKpLfpTrUKzq+K993UDgTXIj2p0/pBjDqL2wlxl8BC1zYhFp2ZelWBQVcaKgY/OcatOseyNkntathmb3/14l79DQ9c5XiJU=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnpfSP3_1757656855 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 14:00:55 +0800
Message-ID: <2e2dd208-c3f2-4d44-835e-003af2f019bd@linux.alibaba.com>
Date: Fri, 12 Sep 2025 14:00:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
 <20250911063034.uafc5mmnf7k4d7km@master>
 <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
 <20250912002854.plq5uhy432xq6puv@master>
 <0D6DB0F3-A893-4B60-9939-FF4575FEE3CB@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0D6DB0F3-A893-4B60-9939-FF4575FEE3CB@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6y9scdmkx3kx5yt4s8kn3h1ichmzdiwz
X-Rspam-User: 
X-Rspamd-Queue-Id: BA19940003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757656859-4215
X-HE-Meta: U2FsdGVkX18XHP2hIrngFJJSZcL22Pt3yrolLMC6ZNkg230qgkcX61QTly6HMaJ4o/P71aAjQbYM7Sjfowv4COOGQ07xMsEZWytVu9UaH/gzBoLDEkDE1t8zBmi438RY0PoRnpqwYn6wrI68u3kImAi+DN9KLzbgqc4jnqSlR6Bxwd/jp0nGQN2hzi8WqC17rmAIrTzn8eehkIAIbri9IgGp1w7S08vwrP74dFVlalcX3wPx+Ns8kFVH0PDudCOjpiJ9Uhd0KUkGUM72Ta9Kb2wAYhxnUfStKNbheDeKpp8j4M37wfmFJJcxGpHWnSnHKEfqQeOJoHufBudS/IL2rQV9BBTk7h7lIe8KMP9bA1eBJTmt0uqWKDZ0M3ZcT3Zzr2v2msyuba4jjxV5jSrSfobDsu2cB27otaTxDHyt99P9FrU7P9Z6RlLnEIhiVnSfq7R/PE8XY9S0TheUHdkWmy9x9WucI95450yZZaPYYGzg4J9orinnL7U9jjCpX4RjroItkP9BDQDsEEPUpkrnY9AMxrOHYGtXy3q/g3cf/uqcEC89gnUSl38a14KadETqD6h0k4dTgAOqHuAKmeNP26etOCiJafI0mwZjaNK462LOLuKX5Df/dFUUuchhoZWhwkWH2Fd6oMHM6Vo3ukygYD0wpuGgRgw0IhZbd7FaX91XU5D/BggBM9UrCjBofMV8NuPCt+9TmdzDRB678rAHVn2h0CClTGkv59bjGrqAIAWJgocFhI59KWxxQ/EmXNghzUFXjeXrtSHYGIFmvYWDJH1WU4VCAXuARdRT9mYcg+KeFANMhytol0iqx9+BSivZ9tHzHtEz+/gUSy2ceg1AREWiuJS9ucMlN5l3ydnbUs4VB40bTUC2UjL0gAfeeoRSdTjcps9Y8lrIyeE54TPtJVd8cXdIXk0xVBJDxP0mCr54FTojdwlMCeVmVPCp44geqLZuBV2XbiMYgLIghPF
 1NAsheVc
 GTLiZQ5PTByPjPc4/7M3/z6EOmjnii1xm73lE1uHr95e6E9Pw19UqeMhzI6f0ZLW91ZIoG1jgsCEWSfggbXtGYdSp0mKWo8dN9wzOyP+uqp2R9eGi4AFeAmy7X6Q190UPwAO1PbfeMQD2M8+wN03+JDicmgJ6StFTV2axNwaCx6pMHsmU7+j2/UPXBhaD3wcNfVmRCrK2iDGXQwwX6kTWJpH1liCFfYkbWgPOsaRXkS8dkeKZRqXe2tJM3Q+Hawzu+ErJqFK6Rf355tkVylYGRMmGFU/+0VYZNbuwbu0KwwpML5SaHJAhF8TjACFJb6Pfn07lUHazMha7EeNNRAy4KtoLa8E82JEm9yAOskNd1Bp3d+u/apj3x/TDSkI8sFilKjk+3zU0M2h+mm+mMQL3M+dLXTpVOZdAmlBN/Kf5QRQ5Hrb7NO3bKMTwsH/XvIXiUY35B5UGxHrlOM6tiwZbHR9/HHwosVzwM3bN+v2Dks7nhEC/lS00sjqQIxfix8XPL7fVs83TqkqNrUtwmKc/xaTWng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 09:13, Zi Yan wrote:
> On 11 Sep 2025, at 20:28, Wei Yang wrote:
> 
>> On Thu, Sep 11, 2025 at 12:28:24PM -0400, Zi Yan wrote:
>>> On 11 Sep 2025, at 2:30, Wei Yang wrote:
>>>
>>>> On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>>>>> On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>>>>> On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>>>>>
>>>>>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>>>>>
>>>>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>>>>
>>>>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>>>>> isolate_migratepages_block()") converts api from page to folio. But the
>>>>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>>>>>>>>> to head page.
>>>>>>>>>>
>>>>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>>>>>>>> which means low_pfn only advance one in next iteration. After the
>>>>>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>>>>>> folio_nr_pages() always return total number of the large page. This
>>>>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>>>>
>>>>>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>>>>>> migration, but finally find some range is still not isolated. And then
>>>>>>>>>> undo all the work and try a new range.
>>>>>>>>>>
>>>>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>>>>>>
>>>>>> This behavior seems to be introduced by commit 369fa227c219 ("mm: make
>>>>>> alloc_contig_range handle free hugetlb pages”). The related change is:
>>>>>>
>>>>>> +               if (PageHuge(page) && cc->alloc_contig) {
>>>>>> +                       ret = isolate_or_dissolve_huge_page(page);
>>>>>> +
>>>>>> +                       /*
>>>>>> +                        * Fail isolation in case isolate_or_dissolve_huge_page()
>>>>>> +                        * reports an error. In case of -ENOMEM, abort right away.
>>>>>> +                        */
>>>>>> +                       if (ret < 0) {
>>>>>> +                                /* Do not report -EBUSY down the chain */
>>>>>> +                               if (ret == -EBUSY)
>>>>>> +                                       ret = 0;
>>>>>> +                               low_pfn += (1UL << compound_order(page)) - 1;
>>>>>
>>>>> The compound_order(page) return 1 for a tail page.
>>>>>
>>>>> See below.
>>>>>
>>>>>> +                               goto isolate_fail;
>>>>>> +                       }
>>>>>> +
>>>>>> +                       /*
>>>>>> +                        * Ok, the hugepage was dissolved. Now these pages are
>>>>>> +                        * Buddy and cannot be re-allocated because they are
>>>>>> +                        * isolated. Fall-through as the check below handles
>>>>>> +                        * Buddy pages.
>>>>>> +                        */
>>>>>> +               }
>>>>>> +
>>>>>>
>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>>>
>>>>>>>>> Forgot to cc stable.
>>>>>>>>>
>>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>>
>>>>>>>> Is there any bug report to justify the backport? Since it is more likely
>>>>>>>> to be a performance issue instead of a correctness issue.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>> ---
>>>>>>>>>> mm/compaction.c | 2 +-
>>>>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>>>>> --- a/mm/compaction.c
>>>>>>>>>> +++ b/mm/compaction.c
>>>>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>>>>> 				 * on the cc->migratepages list.
>>>>>>>>>> 				 */
>>>>>>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
>>>>>>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>>>>>>>>>
>>>>>>>>> One question is why we advance compound_nr() in original version.
>>>>>>>>>
>>>>>>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>>>>>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>>>>>
>>>>>>>>> Not sure which part story I missed.
>>>>>>>>
>>>>>>>> isolate_migratepages_block() starts from the beginning of a pageblock.
>>>>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>>>>
>>>>>>>
>>>>>>> In addition, there are two other “low_pfn += (1UL << order) - 1”
>>>>>>> in the if (PageHuge(page)), why not change them too if you think
>>>>>>> page can point to the middle of a hugetlb?
>>>>>>>
>>>>>
>>>>> The order here is get from compound_order(page), which is 1 for a tail page.
>>>>>
>>>>> So it looks right. Maybe I misunderstand it?
>>>>
>>>> Oops, compound_order(page) returns 0 for tail page.
>>>>
>>>> What I want to say is low_pfn advance by 1 for tail page. Sorry for the
>>>> misleading.
>>>
>>> OK, that sounds inefficient and inconsistent with your fix.
>>>
>>> While at it, can you also change two “low_pfn += (1UL << order) - 1” to skip
>>> the rest of hugetlb?
>>>
>>
>> Sure, glad to.
>>
>> You prefer do the fix in one patch or have a separate one?
> 
> A separate one is better, since these are optimizations, whereas your current
> patch is a fix.

I'm afraid we should not do that. Because the order getting from 
compound_order(page) is not stable without lock protection for a 
hugetlb, This is why we add a sanity check 'if (order <= 
MAX_PAGE_ORDER)' before advancing low_pfn.

