Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8C7CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6402E6B0005; Wed, 13 May 2026 03:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3166B0095; Wed, 13 May 2026 03:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E05F6B0096; Wed, 13 May 2026 03:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4044B6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:53:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 072E61A07AC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:53:16 +0000 (UTC)
X-FDA: 84761631192.13.D197219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BC391C0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:53:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EniW94al;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9gZTHWhXfURTiXyx/iVEAhtT66SHZ7+aHM9YjVAGE0=;
	b=JQAEvxT0SVzVjv+wODA0DaEFLZ3SXGlOw4nbgSF9HdrGjpuPXI5OPyu+Fc0YcXj43ViR25
	sti46S4dq65/cKBlm6lqedZRiM+4qqcusd9iv4gH2lz206VytuihPxTExxzUMdMojv5MKc
	VcOIwNJrp/ttg1tldCI2Y22bx3VSFrA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658794; a=rsa-sha256;
	cv=none;
	b=PqQz8RDZ2HgcA845G+eznPGxDl4fmZkZ5EcMuFM9TYdESZAmU/Bqdt0guXz5sZOwK/kic9
	yxMNETFAlACBbPDxme3cg8+xVc0gjJ8ILfy43S1OO4Fune0/Fq639iG3yss6HyU7ZCizsi
	j9IEshGFDUPz1JcXadyZvL1eaoIrkdg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EniW94al;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFD5740ACF;
	Wed, 13 May 2026 07:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE31C2BCC7;
	Wed, 13 May 2026 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658792;
	bh=6iyqWy4rHTiKW7ZdrWzQSt3Q4mjVireoFhoNPjhDEfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EniW94albia7ugNShZyT9/dAuvZIgetNjErVBCbjIB737fV64xbAQle1UPDQ0Njuy
	 s40Kg7V+FglbWMBWGiHXYDLZj+yd7neQL5Hg4bu/d9GTMzBdg0vcY/F9TeFES/TRcl
	 hUc53o7ShxTY6xMMGneDENZKlfefYSrrWci+Z7ByZutENRYyKtvSi55dHbMpYf1u69
	 yjFRily+Y/yCHk0DQO9t6cYftG4sje3NGlKQfQUjP/aMFENy2D4gNAqsxkU3cUzlLz
	 zt/ashq4JTa+THVzpTD2aA2qKMtSsJczJW5xwn4WDz+0btToJ7dj6NYLNJlsGkQXym
	 6pwY1/HPRnqRQ==
Message-ID: <a577d4d1-dcac-45c3-bbf3-67d30f71bc67@kernel.org>
Date: Wed, 13 May 2026 09:53:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-1-183012ba7d4b@debian.org>
 <9504c193-8c01-4d03-8f62-c50fd7fbdbc0@kernel.org>
 <agMj4ukhj1PkXXrN@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agMj4ukhj1PkXXrN@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BC391C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: washnicxbarw83f3dmacfw83u8eqyk9k
X-HE-Tag: 1778658793-360925
X-HE-Meta: U2FsdGVkX1+h7XvsGsd8jWzgLkA3Ln1jJty2F7Rysc6BXJ7hwsdscwScPyAxiHnPORLTK4wcWl8+7kJsZLN/6gWEpPcX9SKiZypty21FE0JEp41XvHoVN9g/n0oby3fZfvNxMDAHX/VuLPremyQWD+uN5emKhXvj2vjgTvzZKS0D1BsLKeQXGHfZB8xTbKFgcCzBou/Ekn6psrI6eBD5ciC+xE8euDfvgeAu7Eu9WD+UizZ2rbjvj4a8+CUm6IvsJjXxHb81e0uaL9KUGbO1MPi3vIkNuWbeMEtcxH9AqC1GRHi62cNgoAHLnslD9FnhB/Dfn1OpcqQYtn3lJsJe2kCXsE0FsVMZ3Ngcmjhp1iY08sOLg+s5wSBIdEyXi6EDMuaUwchb3Zkrp7wH0i+TShciPyaDPPu5nSPcmhyMQoQIDM2P7GI+AKMbfFxI3hYcwrUg3C06TI1NxxwrfcjC7u8pnRBGtprw2K3cBkbHvTEmF5NsUUauRexiiFU23yWrHXxHqoNLMqrW/xPDA8BlAUIj7nkh70KUKcJgbsWwXodA+0LrUfUJkoZBabbieS7ky8DM1K2CJB/IPIexGU48IHcszW8vfgnLpvyh4HQg4mX2NlWyEdfp7isiN4xWRvHqVVIdPtg0fHXSF30OA/ZvipORDPsQ3yrvEdURRiVgtGLrHFVM6y1mxf+qh2Wen/ffppWcJ6udxMoeYH2NrndYwncArafUXzQsPf9AncOHezWhWKjXRVJJ7t65ecqa8uteaICHYbGhIhqHNgRivhdFXUuShtWu5Q41yWxj0FI0WhadI0f0zcXqN3jKk3tBPmxabRAbIhITPO70OG7oBHeTDqvfP3KxTmAXmla0gAqpKdnM7Y+we+VlLIU5nMkIZM8birmauQ9oWuRDcfGF9xQojjD6yPa5/kiJAjwCYgUwn1wg0Xz6Krtww2Ra4Yryvro6J2S2kVIuo4D6tDFf3qe
 48Ry5oFm
 PObGIxTg9P79tn6DoeYMSlZYl1O40udIbiFeF0KCFr53MO05tAjS5/nYtIpZdG/GH2/eNVz9at01bkJYYYp78Ifn3HgLme2t78BM/NCk5YF32Sfxg2oal6jqw37IgI8XMTyJncR/QWxoDMjduP33T4rrrDgkQzXozJAAwFFVtIDaC2D0wTBGAwV8XW4X7S4oe5y0ylukv1FEbRLQKbn1PzYzmZ1d+cZDxnGySzdwv+rXhqo+H2aQoyEsmGrGQy9pHlCCqS5qHuXxPRmVv1TP9+C/XaZpQPtZMyxFXh6lhu8lXyRMLYcCEhd8T0/u/UuZiMd7y4QgXLAST38GC+jHhf1XsfTF/DI5rxoaPxEMbiuRjIMGJa6sc1cinPcZbFHec1QgwCTnpwE17ErvCdMWTmDzRtHIfKRBI+3peYMSgqOFNDGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 15:04, Breno Leitao wrote:
> On Tue, May 12, 2026 at 10:17:00AM +0200, David Hildenbrand (Arm) wrote:
>>> @@ -2348,6 +2348,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>  	unsigned long page_flags;
>>>  	bool retry = true;
>>>  	int hugetlb = 0;
>>> +	bool is_reserved;
>>>  
>>>  	if (!sysctl_memory_failure_recovery)
>>>  		panic("Memory failure on page %lx", pfn);
>>> @@ -2411,6 +2412,18 @@ int memory_failure(unsigned long pfn, int flags)
>>>  	 * In fact it's dangerous to directly bump up page count from 0,
>>>  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>>>  	 */
>>> +	/*
>>> +	 * Pages with PG_reserved set are not currently managed by the
>>> +	 * page allocator (memblock-reserved memory, driver reservations,
>>> +	 * etc.), so classify them as kernel-owned for reporting.
>>> +	 *
>>> +	 * Sample the flag before get_hwpoison_page(): in the
>>> +	 * MF_COUNT_INCREASED path, get_any_page() can drop the caller's
>>> +	 * reference before returning -EIO, after which page->flags may
>>> +	 * have been reset by the allocator.
>>> +	 */
>>> +	is_reserved = PageReserved(p);
>>> +
>>>  	res = get_hwpoison_page(p, flags);
>>>  	if (!res) {
>>>  		if (is_free_buddy_page(p)) {
>>> @@ -2432,7 +2445,11 @@ int memory_failure(unsigned long pfn, int flags)
>>>  		}
>>>  		goto unlock_mutex;
>>>  	} else if (res < 0) {
>>> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>> +		if (is_reserved)
>>> +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>>> +		else
>>> +			res = action_result(pfn, MF_MSG_GET_HWPOISON,
>>> +					    MF_IGNORED);
>>>  		goto unlock_mutex;
>>>  	}
>>>  
>>>
>>
>> It's a bit odd that we need this handling when we already have handling for
>> reserved pages in error_states[].
>>
>> HWPoisonHandlable() would always essentially reject PG_reserved pages. So
>> __get_hwpoison_page() ... would always fail? Making
>> get_hwpoison_page()->get_any_page() always fail?
>>
>> But then, we never call identify_page_state()? And never call me_kernel()?
> 
> From what I read, it seems that error_states[0] = { reserved, reserved, MF_MSG_KERNEL, me_kernel }
> has been effectively dead code on the hwpoison-from-MCE path for a
> while.
> 
> My v6 patch relabels the failure-path output to match what me_kernel() would
> have reported anyway.
> 
>> This all looks very odd.
>>
>> Why would you even want to call get_hwpoison_page() in the first place if you
>> find PageReserved?
> 
> Are you suggesting we should all the page action as soon as we detect the page
> is reserved and get out?
> 
> Something as:
> 
>     if (PageReserved(p)) {
>         res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>         goto unlock_mutex;
>     }
> 
>     res = get_hwpoison_page(p, flags);

Or you combine this patch with the other patch and let simply
get_hwpoison_page() check that, and return an appropriate error code for
unhandable that you can process here?

Like, maybe, returning -EIO directly?


res = get_hwpoison_page(p, flags);
switch (res) {
case 0: /* Success */
	...
	break
case -EIO: /* Unhandable kernel page. */
	...
	break;
case -EBUSY: /* Race, try again? */
	...
	break;
case ...
}

You can add more return codes as you see fit.

-- 
Cheers,

David

