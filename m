Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052D41094461
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 08:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10856B0088; Sat, 21 Mar 2026 04:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99FB6B0089; Sat, 21 Mar 2026 04:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B616D6B008A; Sat, 21 Mar 2026 04:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A16A66B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:03:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 288FC13B0C3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:03:20 +0000 (UTC)
X-FDA: 84569330160.18.2EC4053
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D68CA0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:03:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=orhgD6jj;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774080198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HppVxiNzSUaNaCzAFZZIV4GLppBx1jzldRjeOTX2Aw=;
	b=iFMt9s7HAdBVuSl3i/T/I9uObR+SzpIpv4OYQBUhGs9XfoQoPRACXY62xwoHbGj55bNrdS
	7hPnK6nWzL7ohroiXTap2gDP6YumQvsmyQRONRBCTFkDK4DMw62WoYsrPEmrJcRWvpGEOx
	S0cwG3u4UXS1Z6X9qLU3EzlZXtDbmjg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=orhgD6jj;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774080198; a=rsa-sha256;
	cv=pass;
	b=Vk3f9HZgCe1fIMUSJ5s1+8/SevwNLXHiKYuKyPllfZ0p96B5h8bgui7SG9IFKSjruXbFnN
	U2Qzst/4l9uOvCXMx535nm4etWH0ApLMilJeP2MfOXrJR8zZipMkc8rkBNJy3oGniP38cY
	RLhpUpp+nuPCJtyBmPwuIbP8lMjqNqU=
ARC-Seal: i=1; a=rsa-sha256; t=1774080180; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Lw1WIqFK2v+7A3cgw0XmvE0F88G1PGxVPFdNhfTHVvnVIkWbu38yzXNoTF25KorKHnBBUTQH0yPQ9XvInDVvT/xn92TBR14QN59U0uwvqPiNFP78vletlDCw2HRcom6a2xjqRbWkGbhKvxqh9SrPC9dGL09f0BA+Seg8Jem60Y8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774080180; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7HppVxiNzSUaNaCzAFZZIV4GLppBx1jzldRjeOTX2Aw=; 
	b=Ki6Ufb84aI0NKdvObFbH9J9GJk3OTxHMcVzTxIHe2GSx1PhRyjDx1MrBp9rV3wex8Itj0ZrVupzBc/bqEAKW+XdROmOx7EYgOIJ8SmF4/s0Uqj2pbZHHla0LoKiamK/jLw9eUIRb7w1phG9ZQe6Lrh5a+twXTXzHZ1K/a0OU1os=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774080180;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7HppVxiNzSUaNaCzAFZZIV4GLppBx1jzldRjeOTX2Aw=;
	b=orhgD6jjVxKApYs+tOoUmVJhww/M2GaEA45Ppp0Phm0KzdfY4z2XARMFlOSCe/90
	9Cl5+xL65cSXXuOUNHK5lDegG/tuwQBq2tqBzQ0ZfegWO1RRq5Zp4kFUQbNeZPUlxgm
	KK+3J39PTWZ8u/C+enLk/MFKleDtDCEg9DjzdSYo=
Received: by mx.zoho.in with SMTPS id 17740801786561013.1548982206217;
	Sat, 21 Mar 2026 13:32:58 +0530 (IST)
Message-ID: <39ac33c4-e107-46de-b6a6-fc8bb6c44df6@zohomail.in>
Date: Sat, 21 Mar 2026 13:32:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
 <abrmgwxireNnqra6@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <abrmgwxireNnqra6@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D68CA0002
X-Rspamd-Server: rspam08
X-Stat-Signature: 1sddcwfexstw6bdkw4e36yqa8kdu1dtk
X-HE-Tag: 1774080197-233554
X-HE-Meta: U2FsdGVkX1+TYK6J7HK6/8NvmszhHmwmBmGpmiTwQE1qH0XJ3Q04z+FYTifLe8INFt32vWZkQOqk34KVN5Ycngt9wXgFUjmTNZmRS0Jdl06vZoYioAMZpWwaA8nw7YI+h/QAj9MBSLeC9rFEOfMiniFO09pU4AKxwjuWnZ9lsgnjXMwpZbrlOSTIz4V0FBuUErhnk5eRMtU3CabNcsh8z3K6DRD40O6JrQ3wQnJn09/QEgQuaNWNDHhHzxoxLK7s7ERjKeqouvFWwZVT/c/uwhPKeA1pm2qTNsesHeIo4I0RgKF+yjwM7vihEQs3912djLPL3uhPxGpAvSLh6IhYfrIEgb2uB4F0lWam2es9k2zw7kWgbXVAIOtDhIkar3BvuwIAVNY/R/0yo/cnxk77GoE8ghqRQo/+7vXSFKNdXOyD6APPDUfr+31G8wTYJkwALyA/OhcCBcliXjhnllViOY0udR9ohTAGfhQpvjptF/2kaeqlBmnD+SByzwRPdxl/1Q6LKN186VeRq8O961j9rtjkHzX3TgbYEX2DjTJICCEar1tv1qwQ7DRdv00nnZEUtDJklPU0Nsgdaq/fmNoBiv+p7MhjmeQaSdEGj6ig/U2xiNMabaegjn9qHuyATDOeTRrhLhEARRmiHEzX7hCJ3nKkHBwSaNmtKI9/zkOIJ8sd6+eXauBcDnEvbOayXUj02B81Woa2UvB4eHXXkZFTamFF+z15mfLfNHfyOLGXgh0J0Qo6fa9NjOiLxgcRRJdrsbLgGJ2QQUh8pHmg2mpMBTrN9HnV39s5sQAUBu3UdvJ/16S8Tw3/UNDJiA4UvJyotgaxaHEDKVNThxZ5IZyzLIHE/0OjWi4GBS6lAeAch7QCofkHC2yHEJSM7rmH5+VVHV22tdRCFmHuClrX3tTinjhyPTzjt7aBNQdC64en0TiOAaIRFfnneqBmN37i1d4Z4hVRXAoB1tv2bvHICYH
 vHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/03/26 23:23, Uladzislau Rezki wrote:
> On Tue, Mar 17, 2026 at 01:47:33PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> Extract the page-freeing loop and NR_VMALLOC stat accounting from
>> vfree() into a reusable vm_area_free_pages() helper. The helper operates
>> on a range [start, end) of pages from a vm_struct, making it suitable
>> for both full free (vfree) and partial free (upcoming vrealloc shrink).
>>
>> Freed page pointers in vm->pages[] are set to NULL to prevent stale
>> references when the vm_struct outlives the free (as in vrealloc shrink).
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>> ---
>>  mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 33 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a..b29bf58c0e3f 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
>>  		schedule_work(&p->wq);
>>  }
>>  
>> +/*
>> + * vm_area_free_pages - free a range of pages from a vmalloc allocation
>> + * @vm: the vm_struct containing the pages
>> + * @start: first page index to free (inclusive)
>> + * @end: last page index to free (exclusive)
>> + *
>> + * Free pages [start, end) updating NR_VMALLOC stat accounting.
>> + * Freed vm->pages[] entries are set to NULL.
>> + * Caller is responsible for unmapping (vunmap_range) and KASAN
>> + * poisoning before calling this.
>> + */
>> +static void vm_area_free_pages(struct vm_struct *vm, unsigned int start,
>> +			       unsigned int end)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = start; i < end; i++) {
>> +		struct page *page = vm->pages[i];
>> +
>> +		BUG_ON(!page);
>> +		/*
>> +		 * High-order allocs for huge vmallocs are split, so
>> +		 * can be freed as an array of order-0 allocations
>> +		 */
>> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> +		__free_page(page);
>> +		vm->pages[i] = NULL;
>> +		cond_resched();
>> +	}
>> +}
>> +
>>
> Since you will update second patch, probably you can also improve this
> one. To me start/end variables sound like a VA range whereas it is
> indices in the array.
> 
> Any thoughts?
> 
> --
> Uladzislau Rezki
Oops, replied to the wrong thread! But regarding start/end, yes you're
absolutely right. I will rename them to start_idx and end_idx to make it
clear they are array indices in the next version

