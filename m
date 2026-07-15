Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9495FC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226B16B0005; Wed, 15 Jul 2026 00:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE906B0088; Wed, 15 Jul 2026 00:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CEC6B008C; Wed, 15 Jul 2026 00:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9F4D6B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:18:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D9191605C9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:18:25 +0000 (UTC)
X-FDA: 84989704170.28.BAFA9CD
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA54C40003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:18:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="Y/wf9sZg";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784089103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlZq5VNM9IveAQcVqRzB2FJ/yvLP/3pgRLHZ2gLJdL4=;
	b=taSne3o9Bj+R3z6YG9dunBE2cOoQb0AD2Lj2zbSzxhOCN2bzuvG5x10u8eemd+L3+7CCZq
	WjBDQuj/Br7e0+f1h2RB+LkdDZqIm+zwInzGAja09tDF3REl+RhuGUDkqag+A8vkIlWRAL
	j/xRq81HisMyqJTYc6541rKSI6mPHg4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="Y/wf9sZg";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784089103;
	b=Ckm6c7t/t6r0tQDC4pBUHI0Jl0fd4v1S5wVtiJQXm8J/e+lb34BZkX/HmCNH5EWuA6JNgt
	R1Zz+sYTNW/dk8H/41CCusPi2GmPU1Efbw/XGcYUeVSioQg75Q8W288AG71uO6xsSuBO2N
	C31sww7YAAhuZBWuXf7znghCKFJMLiA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784089097; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YlZq5VNM9IveAQcVqRzB2FJ/yvLP/3pgRLHZ2gLJdL4=;
 b=Y/wf9sZghBaYe/3v6+fzD7g3VqPtISh6wWAFyypbQaCiND2PkaqVMakErbc7af6sLX3cqZ
 kctbl65fkP3q6XmcQmbXHp2ui0/LGpf4Jt3bXsBYsz52Kf5tv04kquFPyJZkozEmOmm1NG
 CMPKfmKDSDxf0NlG3ARnEAFZZtAEF1YMR0IF+VpUgJ4IRcYmKd8G8Zgs5veqDAFrmC7hL1
 +cldkj5ZNk3tR6IOWK+iltoanUxVWbGq3EFOKwo31Juk47rTlm00akeZMtQyQyJpZg091T
 BVz0oUycp2RURuZR96XtE2R8nZnwxY8+3iW9lT1T1DyVuF3XRR5UOdDh7vlmUw==
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a570a07+73c530+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: "Balbir Singh" <balbirs@nvidia.com>, <akpm@linux-foundation.org>, 
	<apopple@nvidia.com>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>
In-Reply-To: <ff75fd32-6aef-4712-8a4c-4deaeb5c3269@nvidia.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <20260709112520.24857-3-lizhe.67@bytedance.com> <ff75fd32-6aef-4712-8a4c-4deaeb5c3269@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 12:17:54 +0800
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH v6 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <f9c4a3cd-7872-48a6-bb87-7358ad824fd1@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA54C40003
X-Stat-Signature: xz735t7g58mjsk34gano5gayu3cfo47r
X-Rspam-User: 
X-HE-Tag: 1784089102-208328
X-HE-Meta: U2FsdGVkX18wo5PgpmkxGppOTFq0cDsRwYoVWASYm6e1cfSMPmLdApjNHEmVqHdP9U5SxH7AznnH4gMSa0HHmPfxJ8jrhgCYFSPOWFhB6KOUEvgDEjMKciOYB+BmjAkAltj9SI/NqEcwN/cEItTZOZXTDB5QvjYEYiVjgMYYAr9ZVpfJWoKBX7kmWjM0P1sGZJCgZBpzTJqJQiZO9ywvVYKMsh0mE9t1uvzvIXUjvnpsujPicbXMHZN2S5yyL/mZMtJL4R10WPBgzDXVp1peeSQQT/UJAMZQkZdZoRsqW3ExMcFEdQV9criy1i619KBt61mMwAqdCfelcIUmjj49F1rwZ8gCvpO2a6b2Yqlrwl5cZhKuOe62ARizqDEKPeOP6eCwpnjyWAbF4Lmc7J0VJoYGmgfDwGYRFDWfRN9aXPOu6ejTNhesoDspz9+IkmKVz97Hq/QYm94aCmPNBunmujv5o66NHE1u+DLDPgNQYP89C0csGtmepmWapZLyPtS3xcgogaF4eKa5GnC7xiyaqlTY88o4QG4u3De9JEZLJkvfhEHvoOBRKrbNm0Bf8ahO1xKypvYt9HzT7OmkoQ1/Bgcx1pnh/qRw1/YcgUvmFTxWrEOljAtPDdVSBr0C+OlUH4oYsDDL0Ph/aOhpiFDWFQNtftMhFq/0FGLCl6jrqzEWb4CiUhB2ixKLZ8wYKEJeG0OJ/UgQQKN18AaiuvIbWhjhxg5p4P6ArqdCn/R3zB39BZvPnx1Oype/fiWduN5C3YnArrhuudI0mZcgm8CQvVoz2wy9dijhESo21pPk9G6BM52Bkkel2cP+ki6610FvZOt/xr0v7NwOngZRz5euNWsj0obfSs3fVKLnXGiJ1xwoDTgX1m6tdRsfY8C+A9Vt+oZnsvKaCYw3ApZv+RT9IDwMdcWMnRKMfT752epjyDu19fOFicENZrEzRhdgMtJA2OU5wYfvCpHF6Mp+LLJ
 ZQAwcEnM
 lKR48iVi2G1MOdGOyc3Fu8sPlpLTe3DyFQ+3eD2J97xiNOoo5I44rOZMV/LP24hg0e8jIxX4+xactdYAEBnHrIT/6csjw6gd6eUiwd/YRj9EYc0MUy3e3+0MePnGsMQVZ7McVEJiXE0ugjqXXGMd7vluiwDIhvMImpAyk/AMvG/u81CwrsT7zJFLU5wmB4HjQogwX9FkbE7/ZoyB92ksGdV24hI30IGSg6OlFHWMvDeJwOTyAaPCcTCJzgZ8ITfLpSYggsr49E4M48KXkW6lYMFRGRQdeuqBYkR5utFBLcvTePZFZBmZfb6VTjv4he2h+FwDzTzawMWC/tOmtAseZLLawTTLmrHvj2gpH7YWIwP2YxifKs7qnsdHV0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 7:35 PM, Balbir Singh wrote:
> On 7/9/26 9:25 PM, Li Zhe wrote:
>> memmap_init_zone_device() currently mixes refcount policy and core
>> ZONE_DEVICE page setup in a single helper.
>>
>> Factor the refcount-reset predicate into pagemap_resets_refcount(), move
>> the common page initialization into __zone_device_page_init(), and wrap
>> the existing slow path in zone_device_page_init_slow().
>>
>> This keeps the slow-path behaviour unchanged and gives later patches
>> reusable helper boundaries.
>>
>> No functional change intended.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>   mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
>>   1 file changed, 37 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 95808ab5cfdb..5fccfbacf855 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>>   }
>>   
>>   #ifdef CONFIG_ZONE_DEVICE
>> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>> +/*
>> + * Return true when the free path for this pagemap type restores the page
>> + * refcount to 1, so memmap_init_zone_device() can keep the count set by
>> + * __init_single_page(). Otherwise initialize the refcount to 0 and leave
>> + * it to the allocator or pgmap callbacks to raise it when the page is
>> + * handed out again.
>> + */
>> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
>> +{
> resets_refcount reads like it resets it to 0, but it could be just me. How does
> pagemap_requires_refcount_reset() sound, with the value returned being toggled


Agreed. pagemap_requires_refcount_reset() is clearer here, especially at
the call site as well. I will rename the helper and flip the return
value in the next version.


>> +	/*
>> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
>> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
>> +	 * the count again when the allocator or driver hands the page out.
>> +	 */
>> +	switch (pgmap->type) {
>> +	case MEMORY_DEVICE_FS_DAX:
>> +	case MEMORY_DEVICE_PRIVATE:
>> +	case MEMORY_DEVICE_COHERENT:
>> +	case MEMORY_DEVICE_PCI_P2PDMA:
>> +		return false;
>> +	case MEMORY_DEVICE_GENERIC:
>> +		return true;
>> +	}
>> +
>> +	return true;
> Shouldn't the default be a VM_WARN_ON()?

I would prefer not to add a default case here. As David pointed out
earlier in the discussion, keeping the switch exhaustive without a
default preserves compiler checking when new enum memory_type values are
added.

Thanks,
Zhe

>> +}
>> +
>> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
>>   					  unsigned long zone_idx, int nid,
>>   					  struct dev_pagemap *pgmap)
>>   {
>> -
>>   	__init_single_page(page, pfn, zone_idx, nid);
>>   
>>   	/*
>> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>   	 */
>>   	page_folio(page)->pgmap = pgmap;
>>   	page->zone_device_data = NULL;
>> +}
>>   
>> -	/*
>> -	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
>> -	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
>> -	 * the count again when the allocator or driver hands the page out.
>> -	 */
>> -	switch (pgmap->type) {
>> -	case MEMORY_DEVICE_FS_DAX:
>> -	case MEMORY_DEVICE_PRIVATE:
>> -	case MEMORY_DEVICE_COHERENT:
>> -	case MEMORY_DEVICE_PCI_P2PDMA:
>> +static void __ref zone_device_page_init_slow(struct page *page,
>> +		unsigned long pfn, unsigned long zone_idx, int nid,
>> +		struct dev_pagemap *pgmap)
>> +{
>> +	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
>> +	if (!pagemap_resets_refcount(pgmap))
>>   		set_page_count(page, 0);
>> -		break;
>> -
>> -	case MEMORY_DEVICE_GENERIC:
>> -		break;
>> -	}
>>   }
>>   
>>   /*
>> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
>>   	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>>   		struct page *page = pfn_to_page(pfn);
>>   
>> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>>   		prep_compound_tail(page, head, order);
>>   		set_page_count(page, 0);
>>   	}
>> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>>   		struct page *page = pfn_to_page(pfn);
>>   
>> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>>   
>>   		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>>   			cond_resched();
> Balbir

