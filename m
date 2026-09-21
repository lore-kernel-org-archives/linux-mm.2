Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9FFC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294356B00DB; Mon, 21 Sep 2026 08:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B246B00DD; Mon, 21 Sep 2026 08:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8F06B00DF; Mon, 21 Sep 2026 08:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC3136B00DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:46:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4710C12017B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:46:21 +0000 (UTC)
X-FDA: 85237742562.03.0144D6C
Received: from mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCDC820008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:46:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=umnMpXgT;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994779;
	b=A5MdTmkmAJzkRUoQa0WS/vlfALO5WbtPTcATbLQKNqCClMhiCYEoMJnAHuLvQ1T+CAW/rP
	dD1YD7blnE5tNsMLsUZG1PxwEWk4ct4eZOvv7sGlp0XFXwTRYE/YLIsFt5gXcrXJsUmiJc
	xxLO7i2v2nZwI+9d67dCojuBUgNWmAY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=umnMpXgT;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYocrc2Re+1wBSTGGtCdSEpnadReNsxjtc7YlAT/WUA=;
	b=YS2Qu2SfqgUIuRLSFW3ASJUmQ/wKIViD7deH4xTf7huduSCcVSFEmGCMUQzubmb1RjPNju
	y3fHHh4+ae6YHMc4Dhotz+54RwiKTxDu4GMxTuoW4NZOmWua5ajeWLDzaxRB+pcacYsw9a
	c8DCb6vA1HZR5oqUJgWtTU7AnolobmM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LLPYJqhe9zU7AnAPCVJgKLTWemu4LRRS+WljudQLQgk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789994777; v=1; x=1790599577;
 b=umnMpXgTjbXYF6lHWE9otX4Vk3FmE64g9bw5gCf9HiEE0U8msUoDgMA8Vrqp5bGw7HJnPjMq
 3DcOoZMPwTjXYeE8rsXcwZNSGM4qQwb7Rx92wiR+iBGIaj/b2Oa+CQJSBuKFcqF11N3Hee/YpPU
 yJo4e1YW9uAXej0QI9QTAT38=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 24ca413fc12d1e0d;
	Mon, 21 Sep 2026 12:46:17 +0000
X-Mizu-Trace-ID: 24ca413fc12d1e0d
X-Migadu-Flow: FLOW_OUT
Message-ID: <f27df91d-441b-4b40-abce-ff786b8c89e4@linux.dev>
Date: Mon, 21 Sep 2026 20:46:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BCDC820008
X-Stat-Signature: 1hn3yhep7hmddg9ebutado4naydirpzg
X-Rspam-User: 
X-HE-Tag: 1789994778-474745
X-HE-Meta: U2FsdGVkX1+00QmGDpEOBEd3Vsjc9iQEtSJaBu9n61kXdU699/AX5IjnZ2PU7e99nvmEbBNjOPTGQivPsFDJdxPEKluPpObgQ4o/p8F+LboHuGAJlSRlOJz6rUaKmLc94as5bVSHBWjYeeah+k3H5HlreEnzAKlF0FXt0gyr4Ejj2CUdDQktuGcyRP0SZEiLSZlscJVk3551Y3YD8Y+IU9W1tqjZU+xs1HpFgKWblAefQ40ktHRfYA+SIoKDP3qHENe8NieaoLgXyUMdmlPX6urjHUqi38XbkgIoKcbhUlxC3/E+BLbuyqG05AY+4OjxcCE994Q2P/sa7OmwOYQAzyIlmN76BbYjm/2+h1AzNL84IBC0s2BAsDzhMcWfk8C77XxQLsT9FzTu5kWZQFT+pgfGMLGCjmXTrqoMW5TQoAWVKwJL6at4BPPoyafbco4Div7CMc8wkFe59ZeBAgTcatgGUxid6Tq7tZt88zenhgj/FxWQ2iia1648+MZVvZIOnZ2p8aJ9+2/EQFZeagQB+je6MkN+JXUNZUYmV/WbbyetWe7AQY81Znvd9fLmHxHDzEbHS/kceJE8+INVPdlXu2xQjzpDdxDOxhIZ1JGZMmZzMP0g7dqlTSPf7Vpi4pBWSwXwDjAzOsTePi4zi4ILYKgmUTYOOzv0ODq3hIGK+72nmNzi9luAuFI+E/GmzI28HYvMEhFEwHAmTnRE0QsqUGYCLcsBUuqOVtq0lb28LUWtid8pqWVOVhG03iLIeaepkiIzvmTP4WDmFd7ADPXAyFNiiCS2F6vlPxoAXl1bo46Tfqy22OBhbTu34qu6E9Md6WkYR09hSnDdPTO5gfZZSrnUJuWHsPfir4Aixh0o3cw2TVaWNs6kKRHXwESAJ0GYteKNHjOhlGGpVBlJndufaskyemAQ5aZOdhP9jJcMwAAIVb+S/XL+h8XXoIF/X7cLOxHbNIq5ZwXTo5EfxCo
 Q4ZmDLEs
 gjyRzT12jmL9SSJ+xBnnS/xaKSTXc7QtvBDOQEBMBPvhjjL2cHa01z89SYr1rKtFlngl6bFHOxNhoMRfWSsvLMj8SWPMZrwnxDao0Bi7Jyozp3w4/QtmITrPnIk3zqGFRhNJlbyHEdUgQYgNtH4dte8LXMoA0AxKvOGFD4qdhBkwC1lT8RMdeulkpui9mdhXG0TuxG85nLVuKerv637nua0u92keaGbjcVBm5UgLLyUXUWiJCdqTT16sNTjS0wODcWWuUcrBzb3cWBnYLRJuyRtsMd9Bny0jYDHBY9VIR/Bwk9DM76m074K/Al5IodQV5WYluXVkYjTZsnH05sqz8i6w7OZDy/jMpDD/xiORDJpERapWpXpG1bzNe61bAlKVCr6yIUzmlaFU9DxMgYkfWP0PfQ4zuCqh0k3zYIUh0NiwPxkePs0zunDqKW9hQG4ipRwweWpxE3WHRlJmt4qbEMUilaxjTazP00FBtCqjdbg7ZB3QNhGVWeEHMUAbAicin4xbWrpXG7+bZJSgKHOrfRrZU4Hf/FcchISYnE3f5Kjrv+xm8w4HtT7efyeLL8Rp37nd9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 17:57, David Hildenbrand (Arm) wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric. Keep supporting the traditional behavior where users specify
> a pages array but don't set FOLL_GET.
> 
> While at it, don't return NULL pointers in the page array,
> as this is really not expected for GUP users; instead, just fail and return
> -EFAULT.
> 
> [ david: support traditional behavior with no FOLL_GET, extend
>    description ]
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Reported-by: Anthropic
> Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
> Assisted-by: gkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Tested-by: Lance Yang <lance.yang@linux.dev>

