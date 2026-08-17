Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CAFC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050E26B0920; Mon, 17 Aug 2026 03:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001336B0922; Mon, 17 Aug 2026 03:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59B56B0924; Mon, 17 Aug 2026 03:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B13086B0920
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:15:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 294DE1A0710
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:15:10 +0000 (UTC)
X-FDA: 85109899980.06.F7DF410
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id A310C20003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:15:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=X2YMVezb;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1LdzvO8YItiR+BdAiOLPMa7pHh1+EdgmMC0VPZv5PE=;
	b=XUx60gqTwJsR1Wf1P9TbhLf+IEJ/tcyVLukuJP58l5dYreAbpqbdwdWqQo9tkyjCnHYtxL
	cBRDI6q0JuPr3qr9+v8PIcyyg5Ygnn3K49yYANIj2eYQTVYd7WT5hKAFSZPjjbenl7Fgzp
	zIaUxUc8T7e4UrGkVmaxS5nYtBOHU0Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=X2YMVezb;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950908;
	b=o8Do9kQML1+BFKrfwUYjnCn2qt90mqSUW9zOuQwRt9SBzLKGFAx+aBiC6DmELp4DvKnjB4
	KIE1Dm782CC/JyO0bMtSKkTPtVaZZhny4WOV6ADMDAg1bzFCQan37yM5gcSOxuMSP5F+LD
	L6M/opjAxjwDgpZ00Rpha8/9m2GkdDY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786950902; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=N1LdzvO8YItiR+BdAiOLPMa7pHh1+EdgmMC0VPZv5PE=;
 b=X2YMVezbEfr6weHo6U4VNjvJJpHkvj0OHP8qA0iUPlLj3qGpr5pr0qyOg9yN67oyz78yxC
 rMCCxDJOT3XGg0yfzgbzhCFKskeqCmlJhQFJjwhx1cK01aXvppLGR0FPD9bXpeDw90b60L
 t7cPj+u/kClDERT/mcGI3u5Jvtc89ZdNveabXOcxmVhzyEHN7G3A0etuabAls0EuFtnatN
 x/8MjrJO9hrT0iMP1J3nmXuaVLzZ893h7vZSENxT06HtP3dxGy3kqhRiDEKxKy0F1WVeng
 jzAZa0/RPhIgO/OFmhZTxav7QBA/ONS6ZK7ZpqrgQUwssRMu99Cxx+elp9d4fQ==
To: "Mike Rapoport" <rppt@kernel.org>
Subject: Re: [PATCH v10 4/8] mm: add a template-based fast path for zone-device page init
Message-Id: <0c23c111-bf5b-43f5-a541-0345f10db25d@bytedance.com>
In-Reply-To: <178688187038.2799959.7142225711373927632.b4-review@b4>
X-Lms-Return-Path: <lba+26a82b4f4+da5669+kvack.org+lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 17 Aug 2026 15:14:38 +0800
Content-Transfer-Encoding: 7bit
References: <20260810122057.30447-1-lizhe.67@bytedance.com> <20260810122057.30447-5-lizhe.67@bytedance.com> <178688187038.2799959.7142225711373927632.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: A310C20003
X-Stat-Signature: x73nzb9b4e4noybyfs7mt33iqt16h5ez
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786950907-478532
X-HE-Meta: U2FsdGVkX1+QDzr1cyflN3D1prqrHwjj/XtfALf7AaE264nyMYTEzS16C00u02ArfmJ8ts8Ba6FBeWyndI9w3wMr9fBAmXaOeTuZrH+SgKUM2QM2amEtVSb+XOs1wBl2TRAxi4svbs5LAjPqSm+38NTEZqaVhRBuzCE7Yx+EJJbuH3B6bVmnhB4bn8i+vU3XGlvr360xe6hUfPpPhPJvFt+uuOOOElBZGu3n9xgp2Qjx8O0qbvsf2zAGZSYjcbogooacYhrb/7RZ2JfjG+h8AZXdcgpeI1dklvT1wWr9gJYQliei4DO1XBULJ+MmxAmsaOaSVaCr517Rs6k37PSDUhbbs83a1DgrvS/XL7Pxwz8IMEybTfw+rx+fkXNFU6FM7puInV4uJuF2U0Os7Q/Yf5GqeQDiO3D+AANxuNiLHEYl4+lE71L5bl3DkKxniDGgmAEMfPfRWLCIRT63C+/ZmFRiLwyVk6nwD0gODkSlb+aEvZWaTvb8uyqQ0YaGxUl+CNhhLWp8YjcrptcCgXtW9/z4x4YgA9FWwLLaErkXL9NPcq483V0LlRQ7RgEImptymugZfu1QybeWzorRVP6ZTK98AmdSF2o1+dOq+kaKUaZ4xqOiG3qYcH4l1HIxNYaJlbiTyJ2mZUzzrtIDkF0zhOF9jjIBrw64Br87WJwFNHYbhHex+EKGytnkaH8yjDlrcA0g4TttVYWyr6hk4irazDsT99uIC9vFRfCeTS8IrSx+ZCA8C9oVOVypCHtfNAyR+SxhjKKsCr9u19uXR5rbB2/AUEJLHRHUDBKcWovOAEBP+LQSbXiyVFDc8vb8bsJpifcFwHzSEIdjz+sTrH0otIns6rHlgNQrOZpD9sjnP9GsmVDTISgAXLLeYkEs2eefN5BLfm0dp99lf/aGr4/R+QKncV7D7DxSIROCXlQZPdQmWCeormdXZDeglVfJu4+u9JFiZMs37UwcnOSO/6q
 ppjuyoc0
 2vT3Ao4X5F3ckBxtgK2ogk5AllAX0FdMcwTpEhc+a4gXsCzdJ2cNnyueF5kF5x30D0IOA0txXBM9HygLhsfEhGCfz+pixPuSrYHzZRBw3XOxiijvpzmzx4BF9+aOplbgu1JvIUDIqMXtYhzZQ17avk03NePGTbahdBDdPd3MSt9ZLTXZ2079hZl02cgkm7xct0PgMwHZD4qj+6U3c8XdeQrVeJNwVe1rhxlADEBLSSXKy2I/j+EAjUC/Vf5wJCM7hhyTd9kk9QtDOfYlhU9SWrktHyyM+hucfYnCgXUz2UHdLXmQjcZGVzWjAvqKCBIsXKJFkLNeGurLWV+gjIE39vMT38tW0rBxJBrPi0gxZp/gXr50of3pqGVbDj73n9Ond4F6L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/26 8:04 PM, Mike Rapoport wrote:
> Hi,
>
>> memmap_init_zone_device() repeats nearly identical head-page
>> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
>> template through the existing slow path, refresh the PFN-dependent
>> fields in that template before each copy, and memcpy it into each
>> destination page.
>>
>> Use the template path unconditionally. The page_ref_set tracepoint is
>> primarily a debugging aid, while this code is still initializing struct
>> pages before they are handed out. From the perspective of users of those
>> pages, the initialization-time refcount transitions are not part of the
>> observable page lifetime.
>>
>> This means page_ref_set will no longer observe every initialization-time
>> refcount assignment for copied ZONE_DEVICE head pages. The impact is
>> controlled because the final initialized struct page state is unchanged,
>> and keeping a separate non-template path only for this local tracepoint
>> observability would add complexity to the common path.
>>
>> This patch accelerates head-page initialization. The pfns_per_compound
>> == 1 case gets the full benefit here, compound tails are handled in the
>> next patch.
>>
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
>> path (pfns_per_compound == 1).
>>
>> Test procedure:
>> Rebind the nd_pmem driver 30 times and collect the memmap initialization
>> time from the pr_debug() output of memmap_init_zone_device().
>>
>> Base(v7.2-rc1):
>>    Average of rebinds for nd_pmem driver: 244.28 ms
>>
>> With this patch and its prerequisites applied:
>>    Average of rebinds for nd_pmem driver: 215.55 ms
>>
>> This reduces the average memmap initialization time measured during rebind
>> from 244.28 ms to 215.55 ms, or about 11%.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index a70acb7431a6..56a36a71ba89 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1065,6 +1065,35 @@ static void __ref zone_device_page_init_slow(struct page *page,
>>   		set_page_count(page, 0);
>>   }
>>   
>> +/*
>> + * 'template' is a reusable page prototype rather than a strictly immutable
>> + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
>> + * the current template, but section bits and page->virtual may still depend
>> + * on the PFN. Refresh those PFN-dependent fields in the template before
>> + * copying it into @page.
>> + */
>> +static inline void zone_device_page_update_template(struct page *template,
>> +		unsigned long pfn)
>> +{
>> +	set_page_section_from_pfn(template, pfn);
>> +#ifdef WANT_PAGE_VIRTUAL
>> +	if (!is_highmem_idx(ZONE_DEVICE))
>> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
>> +#endif
>> +}
>> +
>> +static void zone_device_page_init_from_template(struct page *page,
>> +		unsigned long pfn, struct page *template)
>> +{
>> +	/*
>> +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
>> +	 * page. Update the PFN-dependent fields in place before copying it
>> +	 * to the destination page.
>> +	 */
>> +	zone_device_page_update_template(template, pfn);
> Looks like it's the only user of zone_device_page_update_template().
> I'd just fold it here and drop the comment.


Thanks. I will fold zone_device_page_update_template() into
zone_device_page_init_from_template() and drop the redundant comment.

>
>> +	memcpy(page, template, sizeof(*page));
>> +}
>> +
>>   /*
>>    * With compound page geometry and when struct pages are stored in ram most
>>    * tail pages are reused. Consequently, the amount of unique struct pages to
>> @@ -1127,6 +1156,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	unsigned long zone_idx = zone_idx(zone);
>>   	unsigned long start = jiffies;
>>   	int nid = pgdat->node_id;
>> +	struct page template;
>>   
>>   	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
>>   		return;
>> @@ -1144,7 +1174,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>>   		struct page *page = pfn_to_page(pfn);
>>   
>> -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>> +		if (pfn == start_pfn) {
>> +			/*
>> +			 * Seed the reusable head-page template from the
>> +			 * first real struct page. This initializes the
>> +			 * first page through the existing slow path and
>> +			 * then reuses that final state as the template
>> +			 * for subsequent pages.
>> +			 */
>> +			zone_device_page_init_slow(page, pfn, zone_idx,
>> +						   nid, pgmap);
>> +			/* init template page */
>> +			memcpy(&template, page, sizeof(*page));
>> +		} else {
>> +			zone_device_page_init_from_template(page, pfn,
>> +							    &template);
>> +		}
> Why can't we init the template for the first page being initialized and
> then call zone_device_page_init_from_template() unconditionally?
>
> The same applies to the tail pages initialization.


The concern is that this would initialize a stack-resident struct page
template through the normal page-init and refcount helpers.

An earlier version did initialize the template directly:

https://lore.kernel.org/all/20260527033636.28231-5-lizhe.67@bytedance.com/

but Sashiko pointed out that this is unsafe:

https://sashiko.dev/#/patchset/20260527033636.28231-1-lizhe.67@bytedance.com

For example, set_page_count() may call into the page_ref_set tracepoint
path when the tracepoint is enabled. That path can use helpers such as
page_to_pfn(), which only make sense for real memmap pages. Passing a
stack-resident struct page template there can produce a bogus PFN and may
lead to a kernel panic.

That is why the current version seeds the reusable template from the
first real struct page instead of running the normal page-init helpers on
the stack template.

I also kept the first iteration inside the main loop because Alistair
previously suggested avoiding an unrolled first-page path:

https://lore.kernel.org/all/akxpS3WOP7oUBNKF@nvdebian.thelocal/

The tail-page path follows the same pattern for the same reason.

Thanks,
Zhe

