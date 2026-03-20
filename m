Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CA0108B8E1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CF46B009F; Fri, 20 Mar 2026 05:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FE96B00A0; Fri, 20 Mar 2026 05:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D016B00A1; Fri, 20 Mar 2026 05:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D287D6B009F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:42:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CCCC85C34
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:44 +0000 (UTC)
X-FDA: 84565951848.25.9A24737
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63762100010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=YIXX2cDK;
	spf=pass (imf05.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773999762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OB3YoTdrDCAMXSJR+6ZepFjxsrtC6b8BDyR6wJNfCjY=;
	b=OaUsosXI4IePgfuE6cLWts6BeBP5vYGQ32IA0PjVPzjog8JquQKehpAavrnheCeLEix5Ld
	aFQfnylZUF+w3VRf04gmBlKk74pNqg0BpltmyvCmvsXDwQWuj2SgSqsw87JQ0Un60i3eRx
	s5Q+r4qKXsWihLGcVpvFqqlh8KV7tEc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=YIXX2cDK;
	spf=pass (imf05.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773999762; a=rsa-sha256;
	cv=pass;
	b=FPZ1q5+hpah11Yyebjlmf84r2naEPggvdnRu92yG7vw/jIUhrxHjPWzj+Fet4d1K2bhewu
	EIDb6BfW8bRIT73XuxPINCJKpS/UzOvezDXZl16sxiOPfW+3jFIHzgBPAYmyOKuNQOEv0+
	cp6KddYy3kY7vy48EZBse0CAP1AXw60=
ARC-Seal: i=1; a=rsa-sha256; t=1773999736; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=DdS+z//jvmh9e+43zUYqLINeJCDkelyhfO/m0194ocTXnxM9ITP+6smUReTht1MGZ1EVxIOCXDfwkvTqiLxbeI6xv34KP8cyYNLNT6/XPYRmznFHqmZN6q+AW/p/RSh+Pd2xBapBCBbgFcbtvfXl9qBuUfD5sYq+5RVS+S6f24o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773999736; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=OB3YoTdrDCAMXSJR+6ZepFjxsrtC6b8BDyR6wJNfCjY=; 
	b=Ii6memtcJQCBjcK5nH6HqOghAeKDPNr4KxcQjzUVQ/HAKSfmHxoHegXFsNxY5LRd0+Y4nQaxrCHKhzhFEoe/j4slZ1kk0GxKGAHS2jkPGuHcpuIT/d0BmBT4kI3WtxLlTTHhRUEahpjIcGl57KUiCF58uEef59nvEkNf0PLyGRg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773999736;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=OB3YoTdrDCAMXSJR+6ZepFjxsrtC6b8BDyR6wJNfCjY=;
	b=YIXX2cDK+Ad2AsPhxYRPLtUOqiFhCu6QM1onBEaEOM9FaYtTIZ0RIL50oVj9wpn/
	RCo0FEWmCSZxXOl59f++qTD0cEmNpb2iy/wlH6f68wERGG/zgtGfrwRAW6oG8YnWwoT
	TX5NzpR/eo6rjEqMDPaa4Uap5CtLfUEmijbjgj0w=
Received: by mx.zoho.in with SMTPS id 1773999734359768.9876083817296;
	Fri, 20 Mar 2026 15:12:14 +0530 (IST)
Message-ID: <13a8ebea-849e-4e08-a742-82cb74f910d8@zohomail.in>
Date: Fri, 20 Mar 2026 15:12:13 +0530
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
X-Rspamd-Queue-Id: 63762100010
X-Stat-Signature: ocrrcpzsb91u9cfb99u1prdipu38dje8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773999760-458855
X-HE-Meta: U2FsdGVkX19Mh9i4cawCSN/lbxQ8CXecSZZrGOkfRAgtZuqFJiEGnY/HyZCM3LwA+09xkNipkj+NLpop38oe91GjbcjCiCmOP4RGGp3INkqTUuMzvRdJHXwAwSXHj91NqWKkTzEqOLxQRH0B7fdtjCwBbzOwcJi8/hbrXtcQON2fTZI6UDZ3lh48YbVgOVXUO4Q1OT9EEF6CdUTresZ7MK4145oT+ZF6Nax3oQXz2+RID+u0LozHvl0Y9KZuiPF81ZNSqSuEc+gh2dXIf+yXkvynvSvC657W2YkrT5WQoX8sugH32JwrHdX3nKLMgVmGMqcEnZOKE10ui02Np0mzAWyRpX08LRaxwL/gR6EdpgZjw4nmvouZvZMdoFS/FXXq+IFL/f592bwuWcUN2RzNWhP1kLQHHP4iYdQ5SNn3efE/l7U9ujA/bELP3uz92fh3vSzER6c9DAiGfVfE4N0xit/JDlAy3ynjKXMHmUc8/pc+e39MXWv+quqePmSfbq9z0+L+ck6v+ozTf54LMCUi7y6n7UJenlf7n5B+8r6VnPjbCxKGLvbYFUMle58ddvrzMQHIFdkwSqRIz7iqrG0rZrveJJ8o8oFKwCeOWQZUVQI22whCV2ooWFQoozhKVSs7rpPJJMggg7yigLui8AGFpf2hBuuinoNnVAGpjXH1sd12opJFiiitWWp/4+zsVkfJ24Xl/yXtaxZSyXL+W/KBHE+ohoYFKslI8lIbiVHMzhxwh4UPVuxtFDo8XfbH4NhGaANH5gurqaqufFRB8zvpDK+Bbbnq3TsxX+9vRXle8JWENIYWoVcBTZPeUaMbfExWH9yOwNVQX/q1RAv0Em43uqbqRHzto2lXdM5mzDYiR2HMtPb/9xYvhvFDgfE7XMqIdR3DsGi/HKiGl0481lcSxgg0eHjI8+g7OqOIosPLuW1qisMUQewA3j5GcUT7BOGG7YkO20i7Mnkn2cjg73s
 Q38vn/Xu
 ECaX9n+75BTR3Pzv69SgyNFtMvAos2r9ZiM90fSVFVCLKXCAXN4a9fxpdrqAdcwa3wHBBc74IZ6tfkjhGvjGkX4f4juWfkfOFHvSn5NmHa2RN9wwr23WTKAfqgiB6tbBxndf1UqGryzYE+++9AGg69X0tLLnarl0JQPPUZnzkk8tmQJDayEWr50VW8ihD37zGvEOnukjsn5+ffGcDXmW5p299omxp2+sVvarkKFMVnOj/Len+Gs+h80Gppass+TBgSKSopCfuNvYj0/VualN+bJrXFG1+DRWJv+kY61G4EpVytGGJieYUmsgsP2eqLH5v9xwsqXRmeKyLRbf5leJlFMHD948jfV782jXlz4Upo4S1vbMpk0lQFG29aj6x1JxqHQvFVbDzeerwg8bqk8j6O8rpjw==
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
I see that's where the confusion began. I have a better picture of
the situation. Will post my questions in the RFC soon.

