Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E57CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C048E0047; Fri, 17 Oct 2025 11:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3608E003B; Fri, 17 Oct 2025 11:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630BA8E0047; Fri, 17 Oct 2025 11:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 514EE8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:04:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCCD4140232
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:04:52 +0000 (UTC)
X-FDA: 84007928424.23.E50E686
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id D556DA0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:04:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HgsDgMKr;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760713491; a=rsa-sha256;
	cv=none;
	b=XJYQ6CC8ysZphDXiSVaPR+V5aF3uFsG2MLbbUMcaGyC2zzSySob76UWlAty9cGcLx79mss
	SJfjHldJYEjee8FpDmxzItyz1FQzCKh1PxvG68zrXsAVriT/fyKYs101cqQ6VP2PALAZZ2
	iJBfHaiPvNo+TbKu55rDap5rpFg7yXc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HgsDgMKr;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760713491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ipsUjbeu91dDs7Ml8KfMCH/cB+JE6gc+gafMQFlHgY=;
	b=LnkmuOsNLGpMGAMecYC02/+ABMRFCm2WtkgwkbHf88+oVkZwpaUGqHOUuUXoUNT0Ic7fb+
	KTlLEzLEytN3f+rNk9o2nhMRxG9n+S7/6lWKIkdFlz1XdSRsjY7D0vYrLM8Ee4ceiydJPY
	jZr861Op8TfL4J5/q3JMZRKmjRI/D+c=
Message-ID: <ab724372-8efa-4642-8240-2f28d090d1c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760713488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ipsUjbeu91dDs7Ml8KfMCH/cB+JE6gc+gafMQFlHgY=;
	b=HgsDgMKryhNnwMN/ITSI0mJHUPe1aoHFEettJVOvu5MMft480FW6TcOIQaa72BlvM81e4i
	BRsSKwH5txiZWj5M8cFMRqLtB0rcB4PJCSbMT6s6xtEvdawatH5R4wtdnpJiZ+qC5IIDJI
	GqkU/Enizl55v/oaRojGF1O2kM4n6ps=
Date: Fri, 17 Oct 2025 23:04:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>
References: <20251017093847.36436-1-lance.yang@linux.dev>
 <1937040d-5e70-4d9a-b77a-261bf0f4994e@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1937040d-5e70-4d9a-b77a-261bf0f4994e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: nkqm7geg54jdypaxyh15yjqc7sftf3ww
X-Rspamd-Queue-Id: D556DA0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760713490-963060
X-HE-Meta: U2FsdGVkX18tJg4TjG8Gd/PdE9WUkeu8WWsmrzIc5YrxITSCIuA/AE3p6kAWiWeV+JYIZ6uTryAfx9Vr9Nisx/UCiDMhIiHWdbxDc18aVw6JAXUeRm3Bl6onnseo5crxzt0PExU8TvZDMlcn3T9J7KTT2H1F7EmgMVo1HLACkku3ouUiDdmJbdMf2gewfEu5DNXvXRF+mT3SkaQ1Kk1sUbCr3qQfikW0gKNRZRYPlSFN8XyuJMJNQ8+feZdi9zXTxWqiCb5RSge1jcq/OhPZ6ROJsRR3DzOznOBnHgg2ZK/sz9vQzlDyay+HWjPYH7GZQsD1mtrw1r9pU9Od+pkVUrBG0EBCw4uS6lUnITsrBEQOoAs1FB5WDuglLtcrO4+FOYl6n9+NaTQ4ANOBogQF+qDnAw5cwx1JThmjW2cHVl8FznAakhC5hWNEhn1KyYl9E8ZAmHAlbiFfZqZQg/XjTBh0YfEzO7HCDfTRQDOSRB1X8tQZOWRNNOYaD/bCUubSZe323iN/VCN2C2LHaqO8DBi9ERnNhDXeAZZ7InjH0/BN3GKluVtn/0KWFDiyDM+Ycj7evCeUHdA5axWkKIF2CZeuKDbkDdwQE3uKV9w3Fn6mYn2oALqYS8TUvpO7w07fLDdZsn5m3qRzps+Btkt+xgOaC+4i3Du4g4UVxrR65ns4NLphZqAIkiFpaHNxL35aeCN2K9euaiHKedgqtf0HglQLxBM9b9gMKSDSHGfpn/KxKxtHN9d0M5lh4NbloIQZA+vn5bopZADObJLS2gBnP/VN83TTgj8g53CSwyYsc+K20hS+aIkgUD8hTgsDpeYjbXIqYrdejrA2baUkzjM6adxwc9Fal4zaDHWO3ElMRI5kSppM4WKmw9pdGCgIQgfr89kgOIYSpNxDVnDO9ICgpeLrtPoSPCONzxv+pk/nVe62vwDPYWN6abDlV1gLKyYfpXJPPCZ0eB+9nIuH6NO
 qMPiJJB6
 GdU9+h/dp+IU3Z6Y6P3DYJnsGIgtiLDDSRAaCGzHFb0REWLTlu9BdgDNkzyLtCxHnpjlrKgiXAJPaGunbrsR3yLZx0aINe+LV7T7tQkLmu8cZkYvTXUa6ttwK/IUNlQphID/mFNqsD+4vsg59Cqb2eiygCZ8SlweDfjaF3iEx3UahNX6DHUH+04ayC5UDIoHEiyeTaKnCkFfnR5HIAli818IdgTUjEtx+7TQoSYwQBd4h8tvKTL0Qou2yaFOx+vHhunfjbANh3lmOwlGyzUR9RKhQ4xeyDOK9tU7mizEYi56WIHAz/hPORzVDQqGR68eTJivK5SdNAJiFS6bA6OtzIKVC1KXfef2IzC/+MIZ4jFp3dFS1kzD4VewNHTarskapxQ6XjoaWBMrpM2d5emYU90qyGwED5UGepcIEMi1VeFbe9HR1GPjn3Rlp37sPdkusZP5pH04YkWYfU9AfG9XON+iriz2NCjd3yg5UrhYSTmEB+G8v/97dUqREcw8lvwIm5Yc0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 22:51, David Hildenbrand wrote:
> On 17.10.25 11:38, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>>
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Applies against commit 0f22abd9096e in mm-new.
>>
>> v1 -> v2:
>>   - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>>   - Reduce a level of indentation (per Dev)
>>   - https://lore.kernel.org/linux-mm/20251016033643.10848-1- 
>> lance.yang@linux.dev/
>>
>>   mm/khugepaged.c | 29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d635d821f611..648d9335de00 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t 
>> *_pte,
>>           pte_t pteval = ptep_get(_pte);
>>           unsigned long pfn;
>> -        if (pte_none(pteval))
>> +        if (!pte_present(pteval))
>>               continue;
> 
> 
> Isn't it rather that if we would ever get a !pte_none() && ! 
> pte_present() here, something would be deeply flawed?
> 
> I'd much rather spell that out and do here
> 
> VM_WARN_ON_ONCE(!pte_present(pteval));
> 
> keeping the original check.

Right, it's much better to be loud with a VM_WARN if we see
a weird PTE, as Dev also suggested :)

> 
> 
>>           pfn = pte_pfn(pteval);
>>           if (is_zero_pfn(pfn))
>> @@ -690,17 +690,18 @@ static void 
>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>            address += nr_ptes * PAGE_SIZE) {
>>           nr_ptes = 1;
>>           pteval = ptep_get(_pte);
>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +        if (pte_none(pteval) ||
>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
> 
> This now seems to be a common pattern now :)
> 
> 
> Should we have a simple helper
> 
> static inline void pte_none_or_zero(pte_t pte)
> {
>      if (pte_none(pte))
>          return true;
>      return pte_present(pte) && is_zero_pfn(pte_pfn(pte)
> }
> 
> initially maybe local to this file?

And yeah, that logic is crying out for a new helper.

Thanks!


