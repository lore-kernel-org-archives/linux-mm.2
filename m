Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A830ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50458E0107; Tue, 14 Oct 2025 08:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00958E000D; Tue, 14 Oct 2025 08:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0308E0107; Tue, 14 Oct 2025 08:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB5D98E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:25:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BCE0C0914
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:25:27 +0000 (UTC)
X-FDA: 83996640294.17.7664CF6
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60940120005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:25:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A8XfJO2I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760444725; a=rsa-sha256;
	cv=none;
	b=1LhjCMEi0/asmodRJ8c+DLdL8g9zsCBHlHpfO7dztC/WRQfGf3a+bIxwabJdWodvtMY/Ai
	P9HgU7EnFDM2e6tDga7rX7yzXD+RCHA0lKq3umX2xC9Ha2f9t16a01rBfwX1ilQeeoy7K5
	emV2hzYiLHZ0GqhTDgc1GvisRD/+Si0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A8XfJO2I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEyKC0rXBxwWC68IHciD57Sf1EbPHHc3LfBBqhTpsxE=;
	b=UuW0dPKW1uR3y4kWWLjDd3fRHJJH81/5hTSelinm8RlLDRCnaMSODO40/7ru/7CQUCew4D
	0HU5s+bmD8BR+fzio+DXNCZomh0VoQ6OgwvtdqmZy+DjRnFHDzcRLjlCLla7EJMt/ZJap6
	hfJ4wXchEk79RNhwp+Y9k/SQOyf8AgQ=
Message-ID: <d1cf240b-6e2f-453a-9119-23cfe5480f84@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760444722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hEyKC0rXBxwWC68IHciD57Sf1EbPHHc3LfBBqhTpsxE=;
	b=A8XfJO2IaHs0uBIzI1sOG5BrgAcC/xVeyCtYb1cJSlO53QVE5Hu99nfMcQOO9jsHYLFeKP
	HAWri20mPdxvd80KXySc9d8mZZLTAUWFiNulkUNM+i0MC2J0mLe8yF2/y2UGGvLLIlwbo6
	FzInSHzUp00rt1na9sF4jeqlMoaiz7c=
Date: Tue, 14 Oct 2025 20:25:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, peterx@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org
References: <20250930081040.80926-1-lance.yang@linux.dev>
 <91c443e1-3d7d-4b95-ab62-b970b047936f@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <91c443e1-3d7d-4b95-ab62-b970b047936f@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z36ads8a4i6bos1yxecr5e9oycbn96ec
X-Rspamd-Queue-Id: 60940120005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760444725-714722
X-HE-Meta: U2FsdGVkX18D76U7GLF+2RVTfEq1SXe8rHus6uBUK6SNYO7vJer3AaRvyC+NBHRywEeKSVB2qx5Osv3fVYfInyab55jfBygfL7WbvAG3zn/sAOXueds6wBmDjRRFAWh9K8ced60OC5qxJR+7ueqfuFs8Cb6ZWbEEbuNx5aiVrO5J5Oj4gWgUQ2BKE+6Ric83aCu0jHQ2KTcPwT+AChbd4zr2pm97Ll03G8Tm56sIdN2F0aRsUIw/PDqB2IqhujPm8EaSKhPERHkKNjuH2BPuLnpba/NRskcFNEpGqT2rJNe/AMmEz4BL5G4tsTXIbRoQiDW599xzTsJTtkrh/wwKPS2gHLXneG0iOXPCyy5OCOn5FNjOUGHKo4/Fxd5e0OU6QGfH/77JWFKv4JjNTDk2PoFjSdsuut8HREOqFN5g7mNJ3Vk3WmOPRCkq0Fd+sjV34a7Xj4xSxrPU9wETLkrZJMfUUCQ1+/QASGE30V+sJnvhJ00wQFdxKVggqPzRHLnwWAmsF0p7fbaDSooQHaTJFDnZeiWGZf/vKjvRXkRb6S4tmZ7QXgi/NP4FjoEdVGqSPl4yd62kF5XqKs7Gey34HTgL3EVmtHrMo7gHnkIwYnAF2rhEinYHOolA5VXIW7YcqMrzZzs8olkVXMYilQ1a89hFKC+dlbLNvPZd/LmQnHMVceKY2lGgBm5RJ9z8QJgFD8ANzr5lAsNP15wv2yd3CsS8zuhdrNYBBLDWxTln0GZpHmGnUkM4PxUK/JidaFeMeIdcNbUVyY77p7NI7kOjioHiWhU2hGQbPGsaRS4qq1itHbX9T94pwHB2+THPLH3zOBOpiWnSXDQDjSztNBa9kilcvRtC+glTqLVavZoNlpiQwk1H5wm2CTI63vGRWe0naUsgKEVYw0Wq3gGf4pmh7k9tdu4XGlnfzSfAt+2Kdmxqi5sHe7bwyF1gP+7GzpmwHbP2eDrYT15ST2gZdTl
 qj+V3xn9
 H6ZWPOOZTWVOAaT+J6WnFn7Ym0UVQTZEk+1mOqMOSil4gtCuzDlf/hB6vVbWl1eH4ax6kkgS5JOdSfu6OfXP03tM5qKECN1NxJWbMhp8TtBDrlu5N/o5H32WRY7gRH9lvdqfDsuU/q/NJYfAGuH8WwxQKRvybmGcajBprItMmygy7GJW4V5Mvv9zJ7mcU1TQf7RWNVJ2cZI3IZb2ZaQWrQUkU+c0PZZr+DBbq6pdM4mKPgvDv+EhFslQjvLjOjgIhlo1KIRJCMQUT5/Jy+Qofy9HCnvpgnAt3Ems5aBqiajTH9RHTzyYEdVSw1CLnEPJm2Ig0DnKOXOwpJyUgDd2WNvXEj9EC2pSkyKYLfV2sxqwdeZuiQUkuM1RI7tBFRo3V4xoPtQ8k2UW8Tgdbitjj3XBLUq9IqFZbu3mc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the super energetic review!

On 2025/10/14 19:19, Lorenzo Stoakes wrote:
> Feels like the mTHP implementation is hitting up on the buffers of the THP code
> being something of a mess... :)

Haha, yeah, it really feels that way sometimes ;)

> 
> On Tue, Sep 30, 2025 at 04:10:40PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When splitting an mTHP and replacing a zero-filled subpage with the shared
>> zeropage, try_to_map_unused_to_zeropage() currently drops several important
>> PTE bits.
>>
>> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> 
> It's slightly by-the-by, but CRIU in my view - as it relies on kernel
> implementation details that can always change to operate - is not actually
> something we have to strictly keep working.
> 
> HOWEVER, if we can reasonably do so without causing issues for us in the kernel
> we ought to do so.
> 
>> incremental snapshots, losing the soft-dirty bit means modified pages are
>> missed, leading to inconsistent memory state after restore.
>>
>> As pointed out by David, the more critical uffd-wp bit is also dropped.
>> This breaks the userfaultfd write-protection mechanism, causing writes
>> to be silently missed by monitoring applications, which can lead to data
>> corruption.
> 
> Again, uffd-wp is a total mess. We shouldn't be in a position where its state
> being correctly retained relies on everybody always getting the subtle,
> uncommented, open-coded details right everywhere all the time.
> 
> But this is again a general comment... :)

:)

> 
>>
>> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
>> creating the new zeropage mapping to ensure they are correctly tracked.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> Overall LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Cheers!

> 
>> ---
>> v4 -> v5:
>>   - Move ptep_get() call after the !pvmw.pte check, which handles PMD-mapped
>>     THP migration entries.
>>   - https://lore.kernel.org/linux-mm/20250930071053.36158-1-lance.yang@linux.dev/
>>
>> v3 -> v4:
>>   - Minor formatting tweak in try_to_map_unused_to_zeropage() function
>>     signature (per David and Dev)
>>   - Collect Reviewed-by from Dev - thanks!
>>   - https://lore.kernel.org/linux-mm/20250930060557.85133-1-lance.yang@linux.dev/
>>
>> v2 -> v3:
>>   - ptep_get() gets called only once per iteration (per Dev)
>>   - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/
>>
>> v1 -> v2:
>>   - Avoid calling ptep_get() multiple times (per Dev)
>>   - Double-check the uffd-wp bit (per David)
>>   - Collect Acked-by from David - thanks!
>>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/
>>
>>   mm/migrate.c | 15 ++++++++++-----
>>   1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ce83c2c3c287..e3065c9edb55 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -296,8 +296,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
>>   }
>>
>>   static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>> -					  struct folio *folio,
>> -					  unsigned long idx)
>> +		struct folio *folio, pte_t old_pte, unsigned long idx)
>>   {
>>   	struct page *page = folio_page(folio, idx);
>>   	pte_t newpte;
>> @@ -306,7 +305,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>>   		return false;
>>   	VM_BUG_ON_PAGE(!PageAnon(page), page);
>>   	VM_BUG_ON_PAGE(!PageLocked(page), page);
>> -	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>> +	VM_BUG_ON_PAGE(pte_present(old_pte), page);
> 
> Kinda ugly that we pass old_pte when it's avaiable via the shared state object,
> but probably nothing to really concern ourselves about.
> 
> Guess you could argue it both ways :)
> 
> It'd be good to convert these VM_BUG_ON_*() to VM_WARN_ON_*() but I guess that's

I agree.

> somewhat out of the scope of the code here and would be inconsistent to change
> it for just one condition.

Since this fix already landed in the mainline, just leave it as is here :)

Thanks,
Lance

