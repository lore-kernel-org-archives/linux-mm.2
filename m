Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9733606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Lb4DwdF8
Received: by kanga.kvack.org (Postfix)
	id DF84A6B05B7; Tue, 10 Nov 2026 22:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7926B05B8; Tue, 10 Nov 2026 22:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDF66B05B9; Tue, 10 Nov 2026 22:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABF036B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:15:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B9161A0169
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:15:22 +0000 (UTC)
X-FDA: 85421372484.10.FD3C64F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE72380005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:15:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Lb4DwdF8;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794366920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15rFtJmRbMHnBEJouMfOvitJtkWvgnl2tL0+uVof8uI=;
	b=QEUD+HxGafP3OsG5DfJeTNJidvIy04ruvgdC9Qiirbmu3wQCfk4fxh215O8g5rQvcyLZyg
	/V9MnROk4Hs8iHspzosq5Iw2OoenkVt6U+ehOFwYlEWUZtf5Jjps3CUGCqK2been+g8pR0
	a8K8+muuyabUd9NT3RKR6H7KEn1HhgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794366920;
	b=2V6aZRq8mJk/g0hWudy1tH1nzT5ICOw2D3IhOtRK/JJHJQc85a94lk4+NZKAG9o5XGVFRU
	e71DAnZ8DB/e8TiZwU6KEYV6ThSYyQol5y6QNyHqJuTYd1zXfFdPni1956AL/ljp1wEoMO
	UPjkZiHkOHkMbtcvbIyiQM6eOH1a/ZM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Lb4DwdF8;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794366914; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=15rFtJmRbMHnBEJouMfOvitJtkWvgnl2tL0+uVof8uI=;
 b=Lb4DwdF8QQKgIped/h+QE4Ar81wdi63JIQFPnnVPXD3k1TZMHBKNFri0XePS3dyUzzPi1G
 ZyCSml0waJIbKI1an7oMDhhaEc+UxRm34RLgbgu9J9dj6kCQpwynxKilA3Ua52LTRZVf2r
 9eneIbeYTEflGeLvQEw6RtQ2rQS95snf20UiZNp0hPI8mcxMlBdMLQ/qKbIrLJ61OL0T7a
 WhmQ6fmnq8ZLYwNLmFaGBQ6wvv95gvhW/LJz06w6pNEyy47OKauV3jF7HWclhlz0jS52IB
 zXINOnqqq26QSVN1K6WFqRHrCg5EF/gWMQWCWu660NZtq1ka33rFRDBR9LODPQ==
Message-Id: <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
In-Reply-To: <sashiko-outbox-207133@kernel.org>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
Date: Wed, 11 Nov 2026 11:14:46 +0800
References: <20261110114859.76343-1-lizhe.67@bytedance.com> <20261110114859.76343-3-lizhe.67@bytedance.com> <sashiko-outbox-207133@kernel.org>
To: <sashiko-reviews@lists.linux.dev>, <akpm@linux-foundation.org>, 
	<apopple@nvidia.com>, <balbirs@nvidia.com>, <david@kernel.org>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <rppt@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26af3ddb6+149d0a+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: tby8bz7srar4uj9b1cf5yi5qchbubh4n
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CE72380005
X-Rspam-User: 
X-HE-Tag: 1794366919-803939
X-HE-Meta: U2FsdGVkX1+Fp+RIQSmWhCCl49LRtee89amIV51l8dJzSohpSkWKnaYEIXcSo3EmM1xEjDv54KUqe3EYKGHsQ5PpVlKP1p6CDxeNnoZXR7EdquXzCAXNXU77y7Mm5cNvZod6K7MZoIOTx0xHZw/Abcz+yykk/g/HjD00pSypSNxxiRYc3bWPhh/+tgtjueqB3W/HDzRoZkvSMRkzTSxpIyQpMfMbZ7BBdtL0RU7UOSVAZJM36Kvu1qWfGzj4gqQaFzx3aRgm0pdW6clhy2q2IVexHF/bsDgrgo6Hqa/Bc8DSl6floyxq7O+uHdn68LxCsO6l+UeB2Yl2tC8JV7rbaQRiDkeOR+bLW0jyn1I/fGeAnQ1gCALDj0lPZWCU/erLqExpfqpnD3xLYBiemDXfcun3aXYPDVykesnNvlRfD7NmuSzCmagzu/rt4XwBXsfUBFMqtrJgGewDYDEfJVAU3K7mhWw/i7pXqKP0kHUmc6V4FaMQ8H/FWb/iTJw1ExGefDpmfaaQ0UxRlfl/naT9hZhlQmj2QziGF739FiLIgWKKXnb3NVCl87UfTHawLtApHUUtoyrRhU3OuRevPohwueCASAriv9NddLVGglQ81Ca/+kFVkanPiAq5wUMnSQXymXXKgAfZNPZMPSE8B7ID9jLQsEknHR0HCGWPWgqgN/QPsfGFKmcQcMj9Ye6fA9j4LbLJDXhemP+8+KU9rePVCQxKXc7xWYhKQ9VnTnNf3aTgSMx4tOLAh7i+lWAUDf7HHDneRTyRC3qTDVCMwWrty//eN2JkYz57x+ok/aP8k1QWEN5s8dErpa/WUdWeDvVwoGBJKRqMWXAFavGFVavzKwHgGN8QzgB7OdClvmez4Grd9CuRWeYHXdnConewtkxxw/tyzmVXS/BUqGHxedEqjkjrHrmyvmiRWZu+0gaztjYLDNVBjQqKbZEY7jbwDpRAu+VLXglqVmo3hRtM34O
 WstmMI0v
 ZPxdtrUty+wAhrpGW21WvlBaaAymNI0zyYrOr8xEwVG5ucUn0i/qfEIjQrcWEFJFiaxTLhLXhf6AG739UiP2o+pSMG6nhBW0VA33VZsYc9IgOT0iYEuOMLvMRSPHyUjcGygf91XFK73j5xLsSPQMkBsXqdDBVqCQaf84XJiNjiZofZ54iLP5vg5WEfRIx8gWGnneXR70ErAn1lYtMMQKMUfMXavUhLqY7fXqaEtN4yUvflw8biV2jgtqkHRe69/xlYIXLUXhc5pxVmcCLrVYyZ5MIORg0AojtRTbMu63qg3sNoNN9+/YTCDzaN5RYm8V1m6cv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/hugetlb: out-of-bounds write in
>    hugetlb_folio_init_tail_vmemmap()
> --
>
> commit 5be89b38412d58045fd600596787f54c7559d32c
> Author: Li Zhe <lizhe.67@bytedance.com>
>
> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>
> This commit optimizes bootmem hugepage tail struct page initialization by
> seeding a template from the first tail page and initializing the remaining
> tail pages via memmap_init_page_from_template().
>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index cb2de24affdc4..6ae5d2679e3aa 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>   	enum zone_type zone = folio_zonenum(folio);
>>   	int nid = folio_nid(folio);
>>   	struct page *page = folio_page(folio, start_page_number);
>> +	struct page template;
>>   	unsigned long head_pfn = folio_pfn(folio);
>>   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>>   	unsigned int order = huge_page_order(h);
>> @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>   	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>>   	 * we must initialize them ourselves here.
>>   	 */
>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>> -		__init_single_page(page, pfn, zone, nid);
>> -		prep_compound_tail(page, &folio->page, order);
>> -		set_page_count(page, 0);
>> -	}
>> +	pfn = head_pfn + start_page_number;
>> +
>> +	/*
>> +	 * Seed a template from the first real tail page and refresh only
>> +	 * PFN-dependent fields before copying it.
>> +	 */
>> +	__init_single_page(page, pfn, zone, nid);
>> +	prep_compound_tail(page, &folio->page, order);
>> +	set_page_count(page, 0);
>> +	memcpy(&template, page, sizeof(template));
>> +
>> +	for (pfn++; pfn < end_pfn; pfn++)
>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
>> +					       &template);
> [Severity: High]
> Can peeling the first iteration out of the loop overwrite the struct page
> past the end of folio when start_page_number >= end_page_number?
>
> Previously, the loop was a no-op when pfn >= end_pfn.  Now, when HVO does
> not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
> hugetlb_folio_init_tail_vmemmap(folio, h,
> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
> gather_bootmem_prealloc_node() has already initialized the first
> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
>
> On configurations where a gigantic page has pages_per_huge_page(h) <=
> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
> mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER == 8, and 8 MiB
> gigantic hugepages of order 9, where both values are 512), this
> unconditionally initializes folio_page(folio, start_page_number) and marks
> the adjacent physical page's struct page as a compound tail of folio,
> corrupting mem_map.


Thanks for the report. This looks valid.

I will restore the empty-range check before seeding the template in v3.

Thanks,
Zhe


