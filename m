Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC636107BCF9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 07:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484076B0089; Sat, 14 Mar 2026 03:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B636B008A; Sat, 14 Mar 2026 03:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352656B008C; Sat, 14 Mar 2026 03:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 256696B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:02:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B82BABA8EC
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:01:59 +0000 (UTC)
X-FDA: 84543773958.25.4C76772
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20C49A0007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:01:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=NLdCNhcz;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773471718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FujBmYNvMAEPedux7ov7ZFL8Vc0Zz3qslVt6zYNB2mw=;
	b=CSA28ux/q8U1qT/0Rw2Tkcevt7WovuASTC7Wokdr2UpeEqevNPqg/4cb5gtZTLjsrfkC6E
	C6/agf4UmKN3fKRlmIggiTYWKNS2XDLabl+4iA5HdOePoaRn3+7i5OrW8D04zi5pplHvXx
	ED/WuX/9sdrgNNm2xM2uZHAro0Nk47Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=NLdCNhcz;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773471718; a=rsa-sha256;
	cv=pass;
	b=S9i+ItfCHy6YX+ncuj3v17U5swmkz2/sc367VC9sdNzvXZg7DWYhEkg8cbxCbmgh4m2a9a
	ysXQ/HR5Z1Kl8L4lYA9om1J9poX4J+vVf76k3E6ooiHD4YntyBkDGYPCETTepiXpYR1XZu
	gcM+jrLi9quz200id4BbglCrOB4IUSY=
ARC-Seal: i=1; a=rsa-sha256; t=1773471701; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=f7OL4GQFDaraQl90Tq2rcHx2StvK++LqbdMB+o3hPYaanV8oFMNIZpXE0hfgxA3DQCIN8ioe9j+8Um9IFoj4R1u/1znN+GLMsRGvTU2RtjSM9UtraiMMntIVczDnNM8BVU+OdLjLbPYzvqTa08ARIIJct3TSU7dLgKXIHNm/OJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773471701; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FujBmYNvMAEPedux7ov7ZFL8Vc0Zz3qslVt6zYNB2mw=; 
	b=IQ0Owp5ZBkt+G/Kqo4L9KBPPhispbReRYPNfFyTd9+OZQHxbBJKfM+cK2qAYRNGiQAtYBDRGHKCOr9MwG573Cm/ty0fZieRPWObhviu6kNtT6eWDLtwuWrwcOJ8jyTsE5wiOYnRjLeBPeWCV7DbAz4V/S+mKoxR9/96o3st7TL0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773471701;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FujBmYNvMAEPedux7ov7ZFL8Vc0Zz3qslVt6zYNB2mw=;
	b=NLdCNhcz9qimrQ5D9hwrVv+JN5qDyp/FP1w9sFaKbzWBYbr/kRJM/cepMGNHoGzj
	y0Dbag/lw1Tw3FITWYFVa+WlGk0vn3SBunuNrvNtSA6V0uWBY2YzSyuwSBmcWFmgoey
	gO839xhzKXNc2O/qU9h5pL6lY3HeefelkXQwnkMA=
Received: by mx.zoho.in with SMTPS id 1773471700114560.1800510292376;
	Sat, 14 Mar 2026 12:31:40 +0530 (IST)
Message-ID: <75d6988d-76a1-4f10-a8ed-8704e8f59194@zohomail.in>
Date: Sat, 14 Mar 2026 12:31:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
 <20260309-vmalloc-shrink-v3-2-5590fd8de2eb@zohomail.in>
 <abJydalLnoddywQq@google.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <abJydalLnoddywQq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20C49A0007
X-Stat-Signature: 93kpgha6pz89ygn3sqxf37homsify6ki
X-Rspam-User: 
X-HE-Tag: 1773471716-531227
X-HE-Meta: U2FsdGVkX1/u9VGEaO4pqmMWzsM5XxUDGZIOFDx/Id2aaxB6Wo2CAMwOHw6BfG5yev3hWZzF+cpJFkQJCLvKWj0pEX39/Dd7F8T309LHsoC7wxVeFGgV/aeCPu2ZwE7etmDEUx3INDxD0SINViWvFuRuji3FFLnnEI6GTWyzsa2hY4g58ctQy34XywXnmV5ZfwuFqCc2vdhrbICT1UdB9xWI7Q1NgHl09cswhmejOj51kGko5ttVlJH4PAzRxtw3e1TSkrEn1hrDRhDJYa3UqMrSAs6uQilYL4uUvJsgSfecnxM8aWNpGNCx4dOU6QeSiqMkcswqoMHWsV/foyVNOjf4zaLsbTT/s5ox6gG+8sfL3a1/RLSGNMrr99vAzxO9ymWPUnK/W6unD5LxGL0s3MuQ056fxqVEiGLKvPBqATwFIQttvz5iE8dG0/HfgmzjjqEsJM5LBklAh7jXqTMINSXXFwdWLRIpCRNsP1J3aFiZlHpQzQhsJuEJ86BNKRzhdb9R3vA902bpOTx5tcmxbODtdGbwZny54cN4uExLZEpUN2RAEWdrhbm0oZKq80bQlmLIppilKbk4SCH4f7vJLWlG4nONpwfEgL8lFGtU+SGbKeNZvT43vttm7tGNNhVmLt1cF/31Y0aVgCkrpSGQtPDj8ETlrAs2Irvei0onbaCqjdy0W+tcO18XdNtX4Y7MqQeSjhpjRXDbp3RWl74ipee4BCrGxbJeQRype+0PUAgUTCzIaxtXEJ4HsWqb6/yHaNm/PJ/aCwKIWIaw8XdKGbyHFWDz8U/MI/Pe9zn1xAp4ZqOWJwYLqv/MMxq81Ps+JR3L8qOm7KXtKU2ZiIqSJ2PfKvPm+/y2TbDu9GLiHu3kPSVgS/scba4GBo1xT6j34KVakWCuo/X8bvMGMUK6wCNUBgae4huHFIR/ofA++nivSMj7LyPKAfJaa0y8+p7d9Gzry1hQ2kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/03/26 13:29, Alice Ryhl wrote:
> On Mon, Mar 09, 2026 at 05:25:46PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> When vrealloc() shrinks an allocation and the new size crosses a page
>> boundary, unmap and free the tail pages that are no longer needed. This
>> reclaims physical memory that was previously wasted for the lifetime
>> of the allocation.
>>
>> The heuristic is simple: always free when at least one full page becomes
>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>> freeing would require splitting.
>>
>> The virtual address reservation (vm->size / vmap_area) is intentionally
>> kept unchanged, preserving the address for potential future grow-in-place
>> support.
>>
>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>> get_vm_area_size(), since the latter reflects the virtual reservation
>> which does not shrink. Without this fix, a grow after shrink would
>> access freed pages.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>> ---
>>  mm/vmalloc.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 42ae68450a90..114e0bd1030e 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4344,14 +4344,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>  			goto need_realloc;
>>  	}
>>  
>> -	/*
>> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>> -	 * would be a good heuristic for when to shrink the vm_area?
>> -	 */
>>  	if (size <= old_size) {
>> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +
>>  		/* Zero out "freed" memory, potentially for future realloc. */
>>  		if (want_init_on_free() || want_init_on_alloc(flags))
>>  			memset((void *)p + size, 0, old_size - size);
>> +
>> +		/* Free tail pages when shrink crosses a page boundary. */
>> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
>> +			unsigned long addr = (unsigned long)p;
>> +
>> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>> +				     addr + (vm->nr_pages << PAGE_SHIFT));
>> +
>> +			vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
> 
> This leaves the range vm->pages[new_nr_pages .. old_nr_pages] with
> non-NULL but freed page pointers. It seems less error prone to set those
> entries of vm->pages to NULL here.
> 
> Note that it's not a problem for existing usage of vmalloc_free_pages(),
> because it is immediately followed by kvfree(vm->pages).
> 
> Alice
> 
>> +			vm->nr_pages = new_nr_pages;
>> +		}
>>  		vm->requested_size = size;
>>  		kasan_vrealloc(p, old_size, size);
>>  		return (void *)p;
>> @@ -4360,7 +4369,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>  	/*
>>  	 * We already have the bytes available in the allocation; use them.
>>  	 */
>> -	if (size <= alloced_size) {
>> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>>  		/*
>>  		 * No need to zero memory here, as unused memory will have
>>  		 * already been zeroed at initial allocation time or during
>>
>> -- 
>> 2.43.0
>>
>>
Yeah, I agree. I will update this too.

