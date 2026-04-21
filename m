Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438D0F8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762C36B0005; Tue, 21 Apr 2026 09:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7134C6B0089; Tue, 21 Apr 2026 09:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602EF6B008A; Tue, 21 Apr 2026 09:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 501636B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:57:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E74901A0E0D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:57:13 +0000 (UTC)
X-FDA: 84682714746.04.C56E632
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39CE940008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:57:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCiSy1UD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776779832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSX4nLaWDBfaJtqJhCGys59Aq5TvpeG1TVtW+cQrUeE=;
	b=xs2tzmlNXZRQE80Ez+2xr5jgKpB3iUkQtzKiHOZegF5V47/GKdA6ZbFWcbYCegeRH0EpVt
	caMnEeBeWaG5u3likT4Wn9X/DoBCD7dfrBydrUW6hchbxCqRfTCOy5Hs1Wf/Li74Jc7M5z
	/xrnOKC7MuN8xR5x5+tH5BLHs+QEL5A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCiSy1UD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776779832; a=rsa-sha256;
	cv=none;
	b=NUgLf0w1tmqYppDBtYBPn1Non+cOQfglU6lo8n7LUtd65QqWh14U8o0y4OtqfH/Oqe0x/P
	RQ6Fw4PJd7lh9axL6n9b023liIFJjqhk05F+/0oMTjC174UVO5BsfPCZrTMmz3y8VEOQJC
	LwQSAGanbc7puM3CmRYC8g5Xk9sumqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84A5E60123;
	Tue, 21 Apr 2026 13:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45468C2BCFD;
	Tue, 21 Apr 2026 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776779831;
	bh=dHSSxhVkg9bb3OFn8crTULXaFwNtsY6qMfn9yU6Cs9U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nCiSy1UDJwK/BAgBOZNPukrXxRM6ZUA3u3iEBLaMLMwOUFGZnWfr+DGLlsi/9VubI
	 tsvG9oZ6Owq5xwdgKbAFbBPO0l5ZOY6xJ4R2ZL4Cuw8JnalH+0GSQfJUTnJWUQrOpy
	 SOAaEFGCmL6hxLA0ytJN6bb/8QFE7zPyMLq/qOyvr7Yho0Haqk5MQpT15EPdzL17Rh
	 ZgjEufjSXeDFnqDtwtKraONH0pcwKca9UX9L44VOrP+0uAcIDnBvN0eIK5xjdwvfNt
	 dUxF5y9iWuiayI28SvB8L1cjSjkqGnivM0aiLFfQfwgzStwQRmfQM9luuw75ghxkgp
	 pjXh9AcQ0cBdw==
Message-ID: <a6182e60-9b81-43cd-aa25-09e54d20d13f@kernel.org>
Date: Tue, 21 Apr 2026 15:57:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: Zi Yan <ziy@nvidia.com>, Hrushikesh Salunke <hsalunke@amd.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rkodsara@amd.com, bharata@amd.com,
 ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260421042451.76918-1-hsalunke@amd.com>
 <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39CE940008
X-Stat-Signature: esnja5xj8a8f4tiydu8caycjqq8bsq7d
X-Rspam-User: 
X-HE-Tag: 1776779832-842745
X-HE-Meta: U2FsdGVkX1/GxBdr9h+yzSJXfwWes/P//xqvrJzBQ6TjhubKi3SXgmWcbUlK8ro++v5ELzGOiKdSlGgaFQhjKXjihUkto5nU7ujmyJywjymbj/FBG3RwkAcN6sIWbwswKaFBFroteEfGUCqVdHDPSqhg7u8UCseZxbtqf3wEJTXT3DT1F0a3O1lBtWaTCJ6w5D0VWkfG3iK4Cl4EWUo0RG5Fcq+4MdcM9O7SRlKJL4PLpYqMXoFAxPhiF88PyjA6YP9iajTVtmCi2VeWu2jSCr6vol8QEnQ0fXG/10P9Y+dpyFjSL8MiWD9KxmWAc7YXVfNYDCdWf/BKrTlA4yUQqKldoGINkAJcBVsFy21HW2+V2LYfAzUVqNuvt0QTsuM8ZQ1ddp8LsiCXIOOILOB4xhht6Vz6r+GhksOXCEHmTbUFE1RTw604QZtPAadS6gLA3ekozcIx4qhT2eufgTYNsXJ7uIvBYLjx8GiGasnEWbbN/LyCR9XbxYhX19vjkvxhlx4IOUJThXyFdbtQr+z3ONnLSdHID+XH9WO7Y5ndTU6Wi9WUAYVaIJkRhkOhtlniZWIN9GVibDLCIs+9I4lGUSXuxhIblskYVNwy5GKAucrmKs3UN7WFbZ8u4gZmS5DljDxp2y0ZFQApfqdIRsOevaPJ+omblc16YTNL9ct/85ub9SBqUSlIdB3VssFnHsLIo1QY8xgtBM/yxdKAnvs25MvGlU+Y3C7C5p6LTwN4sGI8XluWpEf4kpFQFmM3RVAAonGyohFfR9OKDzs7pbTTzO3GFd1Ito5XxV4jcLoq+FRctXQQzf8cUWduqXr+WP/F8JVyJ8NPvP7U9Cave8g0Wh14E6RnFTgcVxpGFsjOLRbCE0Me8fzBD9Vca+jZTyeN3VlqOe1WrwLrkDntFSzYmT7v3FTTyhjxUX2ZSlVSUqE8kBbREi2dsDuUBZopl0xgEOcs0td0+m3iDcF+TZP
 81dsCpGM
 x7pE22jqkyNw1Cn8/OZ3SzQYGmMHPttsMc2pvJI5nGfgprSF6+hoLyR6qx+WDAZA457FJlNpX//HJFfB0G1w0DGrfIvq1yI5fS7qr6bprd4C7brjbIrVsf7nefzL1JMjybH32PIY5cBieHooeyg1Njg5lr6UJqdpaLwZ0CVK1neRxJXkoYq+mIQ4eKDGCieQ9gRiBH9tAe4uk78Yj1o7azhyRf/ny+B/9WGrv+Qz5zoPvi11oZWI+cLZfDl+B7Nqohj1qR3ul1UuPc/ZegYaPr6y1sc7KsUz3yafRz3sloi/1ozFkAjaB+P47x8Y7foMKPLMP4U6ciIc60M8kkhTX3xjdz9Vlt+f2fvCT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 15:44, Zi Yan wrote:
> On 21 Apr 2026, at 0:24, Hrushikesh Salunke wrote:
> 
>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>> clearing primitive from operating on contiguous ranges.
>>
>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>> clearing helper that calls clear_pages() for the full contiguous range
>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>> a single invocation of the arch clearing primitive across the entire
>> allocation. The HIGHMEM path falls back to per-page clearing since
>> those pages require kmap.
>>
>> Use it in kernel_init_pages() to replace the per-page loop.
>>
>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>
>>   Before: 0.445s
>>   After:  0.166s  (-62.7%, 2.68x faster)
>>
>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>
>>   Workload            Before       After       Change
>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>
>> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
>> ---
>> base commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
>>
>> v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/
>>
>> Changes since v1:
>> - Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
>>   kernel_init_pages() runs inside the page allocator and can be
>>   called from atomic context, making cond_resched() unsafe. The
>>   original code never had a cond_resched() here, and the
>>   performance gain comes from batching, not rescheduling.
>>
>> - Moved the !HIGHMEM/HIGHMEM branching into a new
>>   clear_highpages_kasan_tagged() helper in highmem.h, per David's
>>   suggestion.
>>
>>  include/linux/highmem.h | 12 ++++++++++++
>>  mm/page_alloc.c         |  5 +----
>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index af03db851a1d..ad0f42d06ce6 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -345,6 +345,18 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>  	kunmap_local(kaddr);
>>  }
>>
>> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
>> +{
>> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);
> 
> kasan_reset_tag() here removes the tag from page address, so that
> clear_pages() can use the right kaddr. I thought each page needs
> a kasan_reset_tag(). No need to respond here, as I am reading
> the code and trying to understand how it works.

It's all confusing. But we really just turn the pointer into an untagged
pointer here, once.

So I think this is ok.

I do wonder, though, whether we want to move the
kasan_disable_current/kasan_enable_current into the
clear_highpages_kasan_tagged().

-- 
Cheers,

David

