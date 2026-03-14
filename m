Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA15107BCF9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 07:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F28E6B0088; Sat, 14 Mar 2026 03:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FB06B0089; Sat, 14 Mar 2026 03:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A26A6B008A; Sat, 14 Mar 2026 03:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 786156B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:00:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF43A13B691
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:00:51 +0000 (UTC)
X-FDA: 84543771102.19.BE06DFF
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf10.hostedemail.com (Postfix) with ESMTP id 511A8C0007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:00:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=wlEM7+tD;
	spf=pass (imf10.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773471649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9hpBk+CS70G6YuUu0agA+plPZFG12qLu4aNt8KkEGo=;
	b=4Nx/tJ8vQiKYrCRUtwQ7tkBgrs3khheSB8RU1gM+2u/jOGOIrRTLzTs0+r1TkHlXYXmymX
	k4WyZXedeL95vPK52OlDiR9Nn2V/96FenSh5DXxQAMuzFTHN3Y6jXk0Zmdzqj1hGd7+/a+
	INMFW1OxcDTX+/U+4nV7i/GvsrzWg3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773471649; a=rsa-sha256;
	cv=pass;
	b=P6Tl5di7la8qugRSHuCFA0yJcAkOctLS2N3cMrtoAruUM872164WY1+K9mp73p6tseXKlD
	fvt0bhRPcnKzmqQ3cw5/6XVe0iaNWfEjllGhPBhtvMmOkgc+Q5bA+m2uwc9rHu16XERNTq
	ajG8j+f2RYTvd1A7GNEKa6SlradYItw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=wlEM7+tD;
	spf=pass (imf10.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1773471625; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=aVqp8QYSLMTLSpjfRiCsvYNyxgL1XR2DI296Zrpah/vA5U4DgkXheckvSSby0gcACd8DjDG11kJCvw03f3jBZ3hp6aHDpX+oUbz1UQAl4hxGguhxdiNLXfCP8anUR96lCRG3ZMUJTQ7ewA73J/vppq1sdR+mXIfVWJScxB08uCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773471625; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=O9hpBk+CS70G6YuUu0agA+plPZFG12qLu4aNt8KkEGo=; 
	b=DS2vGzcZv0AD5b6Kpbvf4tHN0jxa9brbYNHjVTRRfq9cqc9Nkic8NjBlQRRrEbUEE83t2nc8wrrGhnk23AVDPvhKHgz1GfWfuTG7KJAqviVNOjhafHjy7kHz8y8ZCH8NCJyyUY/+lqIPInpFMz7Vhfv+5VIyfp+bdmtiVF/uymI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773471625;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=O9hpBk+CS70G6YuUu0agA+plPZFG12qLu4aNt8KkEGo=;
	b=wlEM7+tDr7+AxNelVuwGm/5JPmH+8oeFOSJCvxYFwaqPIldij8Xl82LZHyZOXCeK
	mzh04ROZhsdu3MhnGODZ+J2VIK2Kv0JK3j/9un2aquVa2J/Zs0EQ2w/bQLFw5+wvAg7
	iXezcw6dgSDRpNTOghShATvuDnKjiDJmOeSzkvlY=
Received: by mx.zoho.in with SMTPS id 177347162380086.13151303992345;
	Sat, 14 Mar 2026 12:30:23 +0530 (IST)
Message-ID: <5fb3793f-8850-469c-ab56-9bf8719a891e@zohomail.in>
Date: Sat, 14 Mar 2026 12:30:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
 <20260309-vmalloc-shrink-v3-1-5590fd8de2eb@zohomail.in>
 <abGnsSAqxJWqSlXy@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <abGnsSAqxJWqSlXy@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 511A8C0007
X-Stat-Signature: 3cwahc9y4i73tj1pbzy666hwbf8qiyo9
X-HE-Tag: 1773471648-118847
X-HE-Meta: U2FsdGVkX1/DOPGnx4iQlq5gyLWNSC3FEZ7B51O++PriQPN0ISR4fd7ZSmq+xr026ddOZO7/pP2wNdos9HQHhmkHu8WvGNcADy808hE2x40eeH733Ygj+klceY2g/s3wmQUqXuczAzkSljLmwnjE9Ja/EYguBW8LFmYcW9zXqIuXll0bnJX+Wh95Z6Ak8MjnaXNgAoPMJEQYjegczeAs/E2QGdH0VB3jTpUFYfe2PYbLlZ/Uhnn1gnFhNC8XBmsGCbDwNfkOiP5g0xdkSWXVs8OsE/pyfbAS85/mv/AkAj3MY+/GEmclGBk/6ToyeOGxNPuVqq3cb4oAzuH6CEFBQS9JYp/EVFUXISUK0hb4+cfjztCeWiQj3Vn096vB3wL8t9uAnZbI8nF1n7ULkO9bGK1KM2eP+kMH2DYLnpAASLZIfRb2R6/9KPnSQGtowdeyHwCrKNzhcFDdBERvGfk3EyUfvjCRMFbpSt07wt+o7iujnAD3KgrztAntPkT5jH6ifryAC3dE1h5c8p9aVCB+A+b6NnQ2HI5DLUCop5S7qc5krAhkTanKVPD3rPYGUGC3IunEwVRt6imjv+OhaDgbZ0xqv3WAT6vFt/FwPOOB7T9f7/ptnMBstZ08N/Y6qV5R+2a8OsSEADthRGaaHnaBhVxJM4Z9ZFakjCCMv6SwP8ukamfLzjyRbWLMCeVhFI/b26s4Y2dmjIGXbqTNecDeCuS3H2V8tpytZ1UX6Grq2oR52fmexvxb6nY7Wj/ZljYR2t1/hqeofFtWk/1YpU4cBbDesH4f/DN8GsqoTZXwmdhh1c/AX+eUDW6QH1BtykZG5uw/Eiky00YqJRZxFUkMS14yL9dIrE0BxuU5Fe29DS8K4EIM/ZnAvFY9QFobyXujnOZaX0HfHEXBMFiufe79K3uv8Y08Q4+KShnzpVBHKoBdx0MdoHSBDCiRFIBI48S5GAcjJtnhSGCkUFlWZGw
 pGNZ0JFf
 FSg/k0DLQ2iD28VR/8Jlvbr3Bn/99lpJIB/FWCuHoCYUVYBxBvSmHfxkdBGIDYOhIEXPhopisZOG1HCTnJ7YsitPgRcD2lFToHVIJgOHmbYYt81k6+3Y8bD0pL+gIb+Q4F/4aKmQc1n0bM8XATMaSWw8eWO2j0ywl0idupeCz6ySMiv05OasZMzZi2GYOgpgZmOocNN4CchbpL6xP+UgmKUlIpoyiTHaa3QiV1vhjvnA8gRC3WKW4QODGH9c2hmsu6r2gVxImZQvc3a3vq5Q+PC+oeYmQ788aixoUQpoLucMPS8/HVWf8/82USlMog5x2dq2SfmwMEsJlXwFnDN0q3tAXQfiFyRb+KvZh8KEqQOOYTSwSxpyudOsCe7/SjaTvoe3vp2MBMS/HRE02zAzVuQ96Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/03/26 23:04, Uladzislau Rezki wrote:
> On Mon, Mar 09, 2026 at 05:25:45PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> Extract the page-freeing loop and NR_VMALLOC stat accounting from
>> vfree() into a reusable vmalloc_free_pages() helper. The helper operates
>> on a range [start, end) of pages from a vm_struct, making it suitable
>> for both full free (vfree) and partial free (upcoming vrealloc shrink).
>>
>> No functional change.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>> ---
>>  mm/vmalloc.c | 46 ++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 32 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a..42ae68450a90 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3416,6 +3416,36 @@ void vfree_atomic(const void *addr)
>>  		schedule_work(&p->wq);
>>  }
>>  
>> +/*
>> + * vmalloc_free_pages - free a range of pages from a vmalloc allocation
>> + * @vm: the vm_struct containing the pages
>> + * @start: first page index to free (inclusive)
>> + * @end: last page index to free (exclusive)
>> + *
>> + * Free pages [start, end) updating NR_VMALLOC stat accounting.
>> + * Caller is responsible for unmapping (vunmap_range) and KASAN
>> + * poisoning before calling this.
>> + */
>> +static void vmalloc_free_pages(struct vm_struct *vm, unsigned int start,
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
>> +		cond_resched();
>> +	}
>> +}
>> +
>>  /**
>>   * vfree - Release memory allocated by vmalloc()
>>   * @addr:  Memory base address
>> @@ -3436,7 +3466,6 @@ void vfree_atomic(const void *addr)
>>  void vfree(const void *addr)
>>  {
>>  	struct vm_struct *vm;
>> -	int i;
>>  
>>  	if (unlikely(in_interrupt())) {
>>  		vfree_atomic(addr);
>> @@ -3459,19 +3488,8 @@ void vfree(const void *addr)
>>  
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>> -
>> -		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> -	}
>> +	if (vm->nr_pages)
>> +		vmalloc_free_pages(vm, 0, vm->nr_pages);
>>  	kvfree(vm->pages);
>>  	kfree(vm);
>>  }
>>
>> -- 
>> 2.43.0
>>
>>
> I posted my comment for the v2. Same here:
> 
> probably we should move "if (vm->nr_pages)" condition inside the
> vmalloc_free_pages().
> 
> I think, the function name should also be renamed to something like
> vm_area_free_pages() so we align with vm_area_alloc_pages() helper.
> 
> --
> Uladzislau Rezki
We might not even need this check, because nr_pages is zero and the
loop that runs inside the function would be a no-op, as end would
be zero.

