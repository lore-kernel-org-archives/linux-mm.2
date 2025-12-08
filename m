Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE729D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500286B0005; Mon,  8 Dec 2025 04:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B13A6B0007; Mon,  8 Dec 2025 04:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FA96B0008; Mon,  8 Dec 2025 04:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 242CC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:53:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0D91140A44
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:53:36 +0000 (UTC)
X-FDA: 84195841632.02.1BD4F1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB5E740002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:53:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtJQjBeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765187615; a=rsa-sha256;
	cv=none;
	b=23KS0YPZLKfjL4jd3b34a5d8jLsOa8PtwhFnPmqSoCT8qkVmZHZX9cjqnoyG3kQPX5WYBa
	n3xlmjpTmg+MLcRfZoCpAshGpvQoKXIu2cTWAtA6TIMzlkwQbUVOSj1GPrURTHZocofpUV
	01ILLpeZATlR2Sf9gyG6KtqzCG4dlQY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtJQjBeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765187615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+X25QaO7PWy6Y+DN4mxcZWC6UGbziuIwfOYoWZgmos=;
	b=lbe/ZpJy4suNJw5EyRnXArGdx5Yj4QKe2hYBKPwFG/t0UxxLlUfmjtj/7Jo4OurnSKOeYJ
	6IHxfqDSv6iIlVOplJvrzt0aSd29H/eOP5zzsygE4XB95tcXfWDliXCc2LGgFDjLn/9MO4
	GzmPAXSzc8wHA2KYh+S5qT+WjNViqIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BECE540993;
	Mon,  8 Dec 2025 09:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF59FC4CEF1;
	Mon,  8 Dec 2025 09:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765187613;
	bh=hT7K5W2YCnKax0fvHnXRBMbXRa4tpjlXidtYs1BbGf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VtJQjBeTrVApKnn0YxiAsOgWw39ue2X/xghej7XHe66SWnRsdBM+Z92legsDLIfua
	 cKBibEDxdc6uJvCRbQZPlcg5gZMVkEsjo6hHlOE+AGgUygQ+Dd7FoG2oxTpPwcmmD/
	 /L/Q71wP3gU4xjF6fQu7hJ+yB+Wyg1qZo+ZNr0KpDBmDe89RwIsaOaXx2zEPwj1k6/
	 Fjn4V4M/772+MWopwZxXz4i9diE2KPkm3TVPxsoLVKsOWakSYVxoWx3eOr+VNWKZJB
	 NGpgx4i/Z9ng6qjG9XZjn2Drmbfe39UOlD+ViaeYY+R+YcbP65GSG2ip2Fwet+iVTS
	 lQL6H2F4V+jtA==
Message-ID: <66b6e4fa-9541-4cc8-8578-dbffd5f19ecc@kernel.org>
Date: Mon, 8 Dec 2025 10:53:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
To: Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
 <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
 <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
 <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
 <8e59b242-6311-48a7-b9f5-e698c4eccd2e@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <8e59b242-6311-48a7-b9f5-e698c4eccd2e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB5E740002
X-Stat-Signature: rcapjocy8oima5m536e714pocraaduho
X-Rspam-User: 
X-HE-Tag: 1765187614-68929
X-HE-Meta: U2FsdGVkX19Nu1nEbYz/PWRcBCV2J/vMZKKy6qtosZwW9Dq9ZN8vQiy/wgViCpsnP0KRFUCCdOSrlkPOD596L1Pa/nSBF+pVLN0CxcmbSaUiMhDpQVGxwSCLgeu4C1utIytAYV7VADpIzqnIhZEYB95DKbSjEEOhVVwjkcIeFF0VCk7TwgLitf/LK/O+2moy9LjCCb0LxUEf3MoHS9BfPOSOwkx6c+Knw4Nc5DKkPMr0ZS1MY7fioNUWR3vZC/XJw1n9XqhD440Y1y7t6L6XnkxyHavAuvUYE7/eK/Fdw6JQp1jDeCvbbo77LFr9NFl644tgq7PSYGMUEd839F5nCVHkSOU8VtjxhoEv7vxNMXWPM0ykGK4mKhTW4mtli+OTbHN+rjXYqtXo84k2kUXqktVNDHLzvni4MggvGVpxyA+8xnUagf9bwhpSjr5iLkSXvkhjQ0jtlKC/BL2qpWpxxPgmtaaQZlxUNks9tJlQwPdZyxAzRvBtDw7bL9STG2OQD6t5+go04l2bw8d24WTW1KkltGs2j8xrr98PjtvyPJOKv3yxkUVM73XY+Z9/+R9Dp8qu7cFXZZsJYuvMH/tigwvBLaa53A6Sn+9FOsE12uK9nDV79vlha2LxDci93SEgKbEKbuyQeU8FaV0GL2YiFWaSsW9TD4YnhvPaMjVFGPDLvXMkf0iYhijIN5faffVd8bwGnpaIX7bGhd6ELZ5XP+3m+HfI4xsB9KrMDcgo0xvEByPDQs2XONoGr2QKQz+Q0iXAff39eN1ZPixY+qJ1jO1ae4URwEsO334EqhHVaMHoMu7GMXCd9CCmf+SOGDBZ2hkNqG09FInXr+ojhh0KWCqYi5FRr4rLlsbyuygE1KKe2x9wafeZSbWzXZStZNuAy8Fa82vvPNpCl2pAUhusAiT4w8kBdio9vLATXLm//Sc0LZm3JIXgbUyST77h1nTxQ6m7zifDZjDK4Uqfija
 QR53tEYV
 K6vhWeX9OYYtc00Z+jgJvKwEsq19JK+bLKo7rbdnrO3pHtD5ONxvEBbOiRh5UDdPv+ijMB+xjcbbzn49j8egJfsl+LPHaJ/gC92QG88O+Wfap9Fx0b63hPfhBXD7fLZ6JCgUGTrtsijdGBTc0YDk5MGCdNsI1jzZCfU1Xc2DAiWcQBoO1R6NCtvAdmE0jQd+Hmrtkny1jJYUbCgBZLhP7cWkwmSvGZ8z3Q7258fwjng5O8UhiUOQVCSoL7uuaqvsUhWnZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/6/25 18:47, Usama Arif wrote:
> 
> 
> On 05/12/2025 21:41, Kiryl Shutsemau wrote:
>> On Fri, Dec 05, 2025 at 10:34:48PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 12/5/25 21:54, Kiryl Shutsemau wrote:
>>>> On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/5/25 21:33, Kiryl Shutsemau wrote:
>>>>>> On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 12/5/25 20:43, Kiryl Shutsemau wrote:
>>>>>>>> This series removes "fake head pages" from the HugeTLB vmemmap
>>>>>>>> optimization (HVO) by changing how tail pages encode their relationship
>>>>>>>> to the head page.
>>>>>>>>
>>>>>>>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>>>>>>>> hot path.
>>>>>>>>
>>>>>>>> Background
>>>>>>>> ==========
>>>>>>>>
>>>>>>>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>>>>>>>> and remapping the freed virtual addresses to a single physical page.
>>>>>>>> Previously, all tail page vmemmap entries were remapped to the first
>>>>>>>> vmemmap page (containing the head struct page), creating "fake heads" -
>>>>>>>> tail pages that appear to have PG_head set when accessed through the
>>>>>>>> deduplicated vmemmap.
>>>>>>>>
>>>>>>>> This required special handling in compound_head() to detect and work
>>>>>>>> around fake heads, adding complexity and overhead to a very hot path.
>>>>>>>>
>>>>>>>> New Approach
>>>>>>>> ============
>>>>>>>>
>>>>>>>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>>>>>>>> common case), this series changes how position of the head page is encoded
>>>>>>>> in the tail pages.
>>>>>>>>
>>>>>>>> Instead of storing a pointer to the head page, the ->compound_info
>>>>>>>> (renamed from ->compound_head) now stores a mask.
>>>>>>>
>>>>>>> (we're in the merge window)
>>>>>>>
>>>>>>> That doesn't seem to be suitable for the memdesc plans, where we want all
>>>>>>> tail pages do directly point at the allocated memdesc (e.g., struct folio),
>>>>>>> no?
>>>>>>
>>>>>> Sure. My understanding is that it is going to eliminate a need in
>>>>>> compound_head() completely. I don't see the conflict so far.
>>>>>
>>>>> Right. All compound_head pointers will point at the allocated memdesc.
>>>>>
>>>>> Would we still have to detect fake head pages though (at least for some
>>>>> transition period)?
>>>>
>>>> If we need to detect if the memdesc is tail it should be as trivial as
>>>> comparing the given memdesc to the memdesc - 1. If they match, you are
>>>> looking at the tail.
>>>
>>> How could you assume memdesc - 1 exists without performing other checks?
>>
>> Map zero page in front of every discontinuous vmemmap region :P
>>
> 
> I made an initial pass at reviewing the series. I think the best thing about this is that
> someone looking at compound_head won't need to understand HVO to know how compound_head works,
> so its a very nice clean up :)

Yeah, I am also not a particular fan of fake-head detection code, and 
how this hugetlb monstrosity affects our implementation of compound 
pages. :)

Moving from compound_head -> compound_info sounds like a suboptimal 
temporary step, though, as we want compound_head to to point at "struct 
folio" etc soon (either allocated separately or an overlay of "struct 
page", based on a config option). So operating on vmemmap addresses is 
not what the new world will look like.

Of course, we could lookup the head page first and then use the memdesc 
pointer in there to get our "struct folio", but it will be one 
unnecessary roundtrip through the head page.

I'm sure Willy has an opinion on this. but likely has other priorities 
given we are in the merge window and LPC is coming up.

-- 
Cheers

David

