Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117FEFED9E7
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE096B0005; Tue, 17 Mar 2026 12:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5956B0088; Tue, 17 Mar 2026 12:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB366B008A; Tue, 17 Mar 2026 12:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF006B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:01:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 986BBC08B1
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:01:46 +0000 (UTC)
X-FDA: 84556020612.02.F7D16BF
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE6FCC0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:01:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Pi2RQDfW;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/qezJdedyicFyU39gXGiWz0G+fIamwdZ3Nsd6RtN5k=;
	b=p2/7X/J2ATSLUcoTVzwJJZYte7Z2OwhsKRwXbldIOfY9gTd5NH8wW3LJgzejJxFgDwit14
	YMD5B/46Y6EhnGSdL3QTdKHtXSpdFMl7WZAmYxvy8Ya++wLh6loEGlSl8mWsmd2xxL5sk7
	XJ2YgE6LKWtwN7Ko23u4E8uMOCD6+tg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773763304; a=rsa-sha256;
	cv=pass;
	b=8bMx8h6/jQ/ApbzaR/SP4BfH0W1IlO96yfmR8QjH7taoOdFh6oV6T9URtaAPLyFvqtZOn0
	MKsBSB+yQ6MXycWdIuFvTWbo5GoAX/wCgkqCgcX6QUUh7Hs/Ry8OXfMdjGpdCTyuJQKJex
	zUIBe7kiS9K4dB5uxsZfdShIBFHtV3A=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Pi2RQDfW;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1773763285; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=cVr5FdcXLzQOfGxFSD1bMs2Kn38LsAfsbGTz4FF34a9YcdGh8nHGj7JXNMDqLBsOU6UUxNakUhg6vr+GchxisdRthMKuwleDO+VOTSgzQ4WydHDGNCc12LVI4jhEVDXqMIwZf5tsup6l39fiOz1UJmxObs39rjG2Rdxm6+ThIng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773763285; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=C/qezJdedyicFyU39gXGiWz0G+fIamwdZ3Nsd6RtN5k=; 
	b=G3g077z+xDDoF/lQ/2Vt5aMitowVPHAh18b6o5A2tZ3kOhzp0mQ3r9PZNYYetz7czXugaxL7suC9eAPb8SLTcvQ/7hJbphqhb+I3+xBhNaXl93OTxG0heFNruHafs72LhMRtghWPYfp/bdUuIC6KYCNs+xAm71MsHQLBI6eK3ok=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773763285;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=C/qezJdedyicFyU39gXGiWz0G+fIamwdZ3Nsd6RtN5k=;
	b=Pi2RQDfWn3uaEXwXrKiO0ikDBNLzY207R3Hvkr706DYGI6H+t5vMR65/OTR980cH
	bG6TsemaorvWWEciufeo2INkfNpROzNM8Cdm0hrjljTaXvkVBaKb9tGBRfj6j40HQg8
	1df3wuddfV3D2sA8BLElHBKOx0SdKKuCFt0aNvpE=
Received: by mx.zoho.in with SMTPS id 1773763284887524.9112366256481;
	Tue, 17 Mar 2026 21:31:24 +0530 (IST)
Message-ID: <e4b04f7b-e423-4610-b9d8-a94213dc3649@zohomail.in>
Date: Tue, 17 Mar 2026 21:31:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
To: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <20260317-vmalloc-shrink-v5-2-bbfbf54c5265@zohomail.in>
 <ablnha2sgGUMO96d@google.com> <DH54ZZSBOJ0D.2PR3WTIRSH2OW@kernel.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <DH54ZZSBOJ0D.2PR3WTIRSH2OW@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE6FCC0011
X-Stat-Signature: i1zhntmfff18kmemjsr3xouj5eaiouij
X-HE-Tag: 1773763303-814952
X-HE-Meta: U2FsdGVkX1+APND0LIRMtVVthahuwgdjd4C18LY1RE7r6LVPwx1DjBt+IyOIH72taZwvlhbWnHveXjXQPFLC1eTgq6o/WuDfsSCQhNFQWKYxreZrPjvBfeXbV9uE6NR18UflUUubTq79lbt0aQ2LgcUlKgOSATxawS7L3h7AreKZCs+km1NKzOH8lLNOqHA/QpUU+M25bScsekCwrnx9UtlCwxi54GJnpDPqrG1x8u2V6imq6d/18MvfyP/cnAdDS1pLf/BznIgFdxrF42sLz3p0VobAl/mxzG+XuFpu4nzQqA7crZZLUpa/XXPKZr2JOXzjLfPeTUXINekvhf8WcZ9RR9mwEN/ip4Vs24i1sEezmGHmTXJIQ0fDdYAsi/AIUtQmhXG11NZVujxXH9y5gCQaiQifQdUOZuZYPRkE6Kvygtb5Lq8Y1szvckg9AnSatCZHB/MAF0YqzSBWGPq1Yf4NuTtbxANtS2EMXxt94qWTuYyCE35ZN94ZLWlmY5lQeMrQgjGd3K6dI20rLgc54rdQokcy6fPpJFORwv5ZXPgrpQds0IwJQQo7FMUCGk0/7RUvBAupVQd1nBVvl5rvI/GvMrxzSBN+avReF5zDMwp1GabfliMam6JhQGhvBwEyYGlwKjKFXE+jPBAwyv32cGxioWAprDLWoAyPAm26bamKSaBaok8wfTpzyGg/JPpyLhTuSLnCX2YN+PoeKTzEIXZ5llw4yBYCFcqRSDoo2coxkURqJLEGDUk/RGJ0MXaLaaPg9K11VnVi19g/esJlIFqnSQU6I1229639/3ysxuLjWEfJJIHqHn8rirSo2OQyK/1/ybGbcnk7Hexh2ZN4SsIBheTBwR8J571JQjzcAap+eKv2bFpPOkfW1Pi1VgXM5mRcZ0dF7IV9dYxTihUVnoo1UBqqiOSkOpUUUpfY51ABpTdgQSBSn8Gqjr9zvcrCn7y8KnjhjzR9L6z4aeG
 po+Ren+s
 vBLchdemtK7voBlR/W4Iy0rTxo2FmkcjcCAfQ+48pTMnfzhs9h88q85awb7pVXXuWFmeThSeUTKyKqooJNx7++a9pdzx8y735+qG42XD9H9J1FDHSmLJGYnsusayRXQ5Ra02kdJepdOCDwkmQPbvfAGI24D4xGUOE5ffoh4DKgS5ytF4PENUpv4hFmia5K6CH1BghzkmibpAf0PeiVAnwYsDpsqPf6ntcpsUaZuceVzP17f/QTYme8nA89XRV/YAbkmnGiVHZ8zzXse4FOLIAxRDW/aLsmvta5ak0VIQp/BgvoHOPvyhBJCWkfcMGzzD1RMykMH2OfvOBxtM7sz2WHNv4lroaNBWnB8cEBa/Xo6+DLkY3xDgBJnbxdrDsbNy+bYKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/26 20:15, Danilo Krummrich wrote:
> On Tue Mar 17, 2026 at 3:39 PM CET, Alice Ryhl wrote:
>> On Tue, Mar 17, 2026 at 01:47:34PM +0530, Shivam Kalra wrote:
>>> When vrealloc() shrinks an allocation and the new size crosses a page
>>> boundary, unmap and free the tail pages that are no longer needed. This
>>> reclaims physical memory that was previously wasted for the lifetime
>>> of the allocation.
>>>
>>> The heuristic is simple: always free when at least one full page becomes
>>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>>> freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
>>> are also skipped, as their direct-map permissions must be reset before
>>> pages are returned to the page allocator, which is handled by
>>> vm_reset_perms() during vfree().
>>>
>>> The virtual address reservation (vm->size / vmap_area) is intentionally
>>> kept unchanged, preserving the address for potential future grow-in-place
>>> support.
>>>
>>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>>> get_vm_area_size(), since the latter reflects the virtual reservation
>>> which does not shrink. Without this fix, a grow after shrink would
>>> access freed pages.
>>>
>>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Feel free to add
> 
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> 
>>> ---
>>>  mm/vmalloc.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index b29bf58c0e3f..f3820c6712c1 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -4345,14 +4345,24 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>>  			goto need_realloc;
>>>  	}
>>>  
>>> -	/*
>>> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>>> -	 * would be a good heuristic for when to shrink the vm_area?
>>> -	 */
>>>  	if (size <= old_size) {
>>> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>>> +
>>>  		/* Zero out "freed" memory, potentially for future realloc. */
>>>  		if (want_init_on_free() || want_init_on_alloc(flags))
>>>  			memset((void *)p + size, 0, old_size - size);
>>> +
>>> +		/* Free tail pages when shrink crosses a page boundary. */
>>> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
>>> +		    !(vm->flags & VM_FLUSH_RESET_PERMS)) {
>>> +			unsigned long addr = (unsigned long)p;
>>> +
>>> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>>> +				     addr + (vm->nr_pages << PAGE_SHIFT));
>>> +
>>> +			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
>>> +			vm->nr_pages = new_nr_pages;
>>> +		}
>>>  		vm->requested_size = size;
>>>  		kasan_vrealloc(p, old_size, size);
>>>  		return (void *)p;
>>> @@ -4361,7 +4371,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>>  	/*
>>>  	 * We already have the bytes available in the allocation; use them.
>>>  	 */
>>> -	if (size <= alloced_size) {
>>> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>>>  		/*
>>>  		 * No need to zero memory here, as unused memory will have
>>>  		 * already been zeroed at initial allocation time or during
>>
>> Hmm. So what happened here is that it has previously always been the
>> case that get_vm_area_size(area) == vm->nr_pages << PAGE_SHIFT, so these
>> constants were interchangable. But now that is no longer the case.
>>
>> For example, 'remap_vmalloc_range_partial' compares the vm area size
>> with the range being mapped, and then proceeds to look up the pages and
>> map them. But now those pages may be missing.
>>
>> I can't really tell if there are other places in this file that need to
>> be updated too.
> 
> This may well be possible. I remember that when I added vrealloc() and looked
> into growing and shrinking, I concluded that it might need a bit of rework in
> terms of tracking the sizes of the different layers. Unfortunately, I don't
> remember the details anymore, but I'm quite sure there were some subtleties
> along the lines of what Alice points out, so I recommend to double check.
I will leave an update if I find some issue.

