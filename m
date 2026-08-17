Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6095AC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA916B009D; Mon, 17 Aug 2026 03:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A33F6B00A4; Mon, 17 Aug 2026 03:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFC26B00A5; Mon, 17 Aug 2026 03:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7E46B009D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:12:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 957D4140709
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:12:29 +0000 (UTC)
X-FDA: 85109893218.17.D621CB1
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf02.hostedemail.com (Postfix) with ESMTP id D783980007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:12:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RTog4FrE;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEmC/EhsOQJ52Eiw8IEgOG+hTiA5mRLWdEfIjaGYqew=;
	b=0GA72UgE5nxXM+AfisNNrisz9uG8vCOD5kbHzaQCvtp4WGAaa5Qj+iQQGvZKfZKLT7ixTT
	GUIWerF/68hPJF9vmdJcGhna5I1Lbut3LQgFDnTe7zvHSLuOZXIIfuliwVyrLMYu7c1X7G
	edcDiDWJiTB9Ox6LkXPnOVq1thWH8aI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950747;
	b=x8BBNFIo3WGMQLAK+0Yb2tPaWoNeuw291J2GMINU4aFhW+UiOrNyLJmWK7Wnh9/9+EBWvv
	DimDmTKZsL6Cq2tS4Olhq1Y6jZ6plUB4yxEcQvgdBGp9vPK7R+4wRugIODmFCaaTbKgkhu
	2Nx2DBjzOMPD+rwuyTLl0EnYC8yoDa8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RTog4FrE;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786950741; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=zEmC/EhsOQJ52Eiw8IEgOG+hTiA5mRLWdEfIjaGYqew=;
 b=RTog4FrEdFqXQN4hf79GJWgPqw+l52P3rPXcGGKIGLGuSurl2iiePNSZKSjgiV2JmrMOJN
 vYyCw635BkqbabmR76hXeHDRnXwWRVXdkPH4Yp9lXSXlRnlhKYqAFLJLrM8+Lo515MxNOB
 oSBetItuasYL2QqXxUuA87xabBsKOnH2tIEtSm8BszM8w88czHkniU7w9aRBIfHnQFZmML
 5zYhboPmWTS7iU3tsWiNfX/f2r8cVTzOAoTByI63fcCHdzZtdtUTcGRZybo3g6Q06uLz7M
 bjwvi7vVDN20QqlmYxcJFOeeQD+6oGrk0I3eQGrW1Xt+Xg2FcAF/K5va956j3w==
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 17 Aug 2026 15:11:56 +0800
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v10 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <050c317f-111e-4293-aee5-ac8e154ebc7e@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a82b453+57b323+kvack.org+lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com> <20260810122057.30447-3-lizhe.67@bytedance.com> <178688187038.2799959.7900723270155108493.b4-review@b4>
In-Reply-To: <178688187038.2799959.7900723270155108493.b4-review@b4>
To: "Mike Rapoport" <rppt@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
X-Rspam-User: 
X-Stat-Signature: kgx4p3woncqxnnoq4efq8a5x66xy46za
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D783980007
X-HE-Tag: 1786950746-799062
X-HE-Meta: U2FsdGVkX19YaKGZmE3Adal1XjhMI49oYYGNrO5HLBb/V6zWtQIs+ssEfRToSxFqtNY7Hu/kHWFhRHfDojQXbG31v9qyDmsuLtgXFrGV0ob/gXpBQTLJqkPQCTrHp+cCwmKk/YMt98t16cqxg4GCHwz88XP4YaUe5DuEyQ8BAVHpEfKvb68+ylJd4csBr575LD6uNw+sEeJwgcO+fa75sR+YsLz54QNgqMQncGKwWC56Unsp/r/DoYRUJnMpGyzTZ4hYfcAm9RuxLNAgLk7w6/5Gb4F+b7H9qQ4KpXdZZ1SK5MWqfY73gqJYusJY7rV3UWQfVRlSZHc6uh6hc0kZ4Rd+TS+Z/J1/D9NZjTJQbjiUk/n9WjRFR72oLnu8Oeka7zc2gfdMQfshGFRpOtYOJ0M+m975h3l3CXNGv5yzmpTiCzECI0ICRyWyZ75AKIpX4NWmJ3zYCKvRQuWxyt0b/I9Gq4js8VBZ+tnp6+rkuzI9Loz2xHzeNgBKd+dG4WaOdQgjh47UpKwfhanzod3wcwIKP1/g9FmkiQtIhbcvBcSpJGCX0I2R1fGmS3T6IS7pO8t6K+3wv9VJzk+jC8RQjP3kt5X/xr4+ztNT+rJ3aAdvWLxoAoonl9DzrcPcu0ndd/dGh+MjZVv8KXT+CBjfCv1dZzY+hCE0Z7wPW9gLYF0QEe+tEiVm2BAibgfac25m+awhB3vTAFeAPJcAyXE2lqqKiCNv8CqLKNdTHimX7CmmxlsdtWzPcbHnzYR1XImexd5noboHx1Ic5lbQ5615V+AHlSpHLbALE1v1sxBlKBF/eWWPYeyzmdpSOfBILeUXayHYC1+qR7lLoI6SVVgIICLEbqXj6vFn7JxwXm8fDN+2Tntn2ww180O33Y4bznfwOBrjmeCv4GknQy1Y2FgZeKW5nDmsI2cp2rzP6H45UOwlD34QkqG9RJNScusl4KFryNFJ/2l3dWTNRmS6Olu
 2bGM27LQ
 I3UQypyBh5NoZMzrImPwTretU2qHaxtMGCSVcHwZsHFy3eRtLhfRcBPgzWPFDKnekP54IuKbHQMTMx1LuKFR8l9j3X3d2Fdux5fPZx9HAl0HdXQPLc9WQ4txWJH+LQDJAo+QD08MQSM9mQCRRtjB0SPe4Q/pRLNiOudOj55+KoUQ4047Z4H0olBgdQ82kchwFtac3n4qTbh/pudqkTaTJ5d+C8OU3GPGF8Pi9CwwFypMCyhX0Vjzkp3wpo2koevM4loahCEdkFuCzxzg0h1U43E9dlzVqP3DMhUPQuJfWhCpHsbwYEgjutSG53HTT9skhCZE5d44mUCv4+NeFxklOfUo01IQQg4+rZcISG9i4po6By6Z/i8LStCkXmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/26 8:04 PM, Mike Rapoport wrote:
> Hi,
>
>> memmap_init_zone_device() currently mixes refcount policy and core
>> ZONE_DEVICE page setup in a single helper.
>>
>> Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
>> move the common page initialization into __zone_device_page_init(), and
>> wrap the existing slow path in zone_device_page_init_slow().
>>
>> This keeps the slow-path behaviour unchanged and gives later patches
>> reusable helper boundaries.
>>
>> No functional change intended.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 95808ab5cfdb..a70acb7431a6 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>>   }
>>   
>>   #ifdef CONFIG_ZONE_DEVICE
>> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>> +/*
>> + * Return true when memmap_init_zone_device() must initialize the page
>> + * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
>> + * the free path, while the remaining ZONE_DEVICE types start from 0 here
>> + * and raise the count again when the allocator or driver hands the page
>> + * out.
>> + */
>> +static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
>> +{
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
>> +		return true;
>> +	case MEMORY_DEVICE_GENERIC:
>> +		return false;
>> +	}
>> +
>> +	return false;
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
>> +	if (pagemap_requires_refcount_reset(pgmap))
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
> It looks like all callers of __init_zone_device_page() are now calling
> zone_device_page_init_slow() that with series evolution became a thin
> wrapper for __zone_device_page_init().
>
> Maybe we can just rename __init_zone_device_page() to
> __zone_device_page_init() and replace the open coded setting of the page
> count with the call to pagemap_requires_refcount_reset() an be done
> here?


Yes, that would make patch 2 simpler.

The reason I kept the refcount policy outside __zone_device_page_init()
is the compound-tail initialization added later in patch 5. Tail pages
still need the same basic ZONE_DEVICE struct page initialization as head
pages, including __init_single_page(), PageReserved, pgmap and
zone_device_data setup. After that, the tail-page path calls
prep_compound_tail() and sets the tail refcount to 0 unconditionally.

Folding pagemap_requires_refcount_reset() into __zone_device_page_init()
would make that helper include the head-page refcount policy even for
callers that will immediately apply the tail-page refcount rule
afterwards.

That preserves the final state, but I was trying to keep the common
ZONE_DEVICE page setup separate from the head-page refcount policy for
this reason.

Would you still prefer the simpler renamed helper here, or should I keep
the common ZONE_DEVICE page setup separate from the refcount policy and
make the naming clearer in v11?

Thanks,
Zhe


