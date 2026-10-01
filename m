Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6023CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 05:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02276B0088; Thu,  1 Oct 2026 01:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B32D6B008A; Thu,  1 Oct 2026 01:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9786B008C; Thu,  1 Oct 2026 01:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0B46B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:58:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1FB4A02FC
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:58:02 +0000 (UTC)
X-FDA: 85273001604.19.71A3CE7
Received: from mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF70A1A0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:58:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hY8nET0W;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.49 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790834281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giVtiDELSgAkXNs7XlYfwu7HaDHpb0q96ZHNarUH7ok=;
	b=hrsc4qTcuIQe0LkjzL/TtB0tGSfQ+yRAp4MIo+CACzna5qLbIbGS06E5B6LLk0FhI2bMOc
	ZffKJC+d8TwuRRY+Hl60mHs2xVjq9Xjbv7G8up1FEJjo02vO1Gl8jErxCT4XXvMUWJQJYK
	QwmWIrPevVzKG4K0H3gX9ePWrtuFJac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790834281;
	b=uJZ519y9HXYv6lCTK7AgEQ+BzgQu3zXwk1Vs1aThQIUGbVToEZAjP8URf6NL2hLDDS4Vis
	lh5knsZHgFquErNK0pNtBi5TTgjfsbtgqh+3pek+lLY48eAu14B0Oo9zc9n+TzrGQggvUm
	kp6k6PY8VqPVwkPnHWMV55dEfXdsiyA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hY8nET0W;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.49 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k+5EwW1tfy7CuX+mU/60zb86Q3x+eOGt8f79gc1ysI4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790834279; v=1; x=1791439079;
 b=hY8nET0WZa50lHGk55aBYF2RB3IiYqeZPzLLTqGxXNPqz3y+tuaIpplNc2lETAL4P7iBcbaU
 K07bdUdow2NPb3++6Pm4XPCbhqcDWSQG7CXjUVMaxil/hlb3gPUCSwDvNB3qhiRrk7fvKG3Va3R
 DNwhWgVQSImoNoqmDmtIs834=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2c64a44a8353d810;
	Thu, 01 Oct 2026 05:57:58 +0000
X-Mizu-Trace-ID: 2c64a44a8353d810
X-Migadu-Flow: FLOW_OUT
Message-ID: <aee7af40-3da6-479e-8e0b-881497df9c49@linux.dev>
Date: Thu, 1 Oct 2026 13:57:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in
 __add_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, osalvador@suse.de,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930160432.5564-1-lance.yang@linux.dev>
 <d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF70A1A0002
X-Stat-Signature: gaxdehuw8irniezyuxk1etkab6mgjxeu
X-HE-Tag: 1790834280-696493
X-HE-Meta: U2FsdGVkX18EufcqnMzJAoZ0oo8tlmWTfJ7h2s8sCPio01Sk+3jChZEKsqoafhEbWcoGlTOEsJI3M5BXwKftw5TbzC3u1OKmZuuWoO4bzepWoTsB7c0DoQBP/yQEhwmJiJS7Saol4KpRi2HdhyF6vb06WXxoFb1SYmDUXE5rwbXCOK3ozeNOWBj6Qc1BZoPHTTCc5erJnReBSzpDk/OAD1DxHCaG1jCPiriRryl3lMeAhX5bVxTXZuHQ0u0/EImteJEmwpUZsmN4FXGJiSltqEw2lUjS3Dgc0nqud9k9KqQKknaY2/DoxIb+h32P/wT8EGgMLuP8v/7E+dyQykqArSBxnFpAoFwZJBknopYuuy+yiSbWZgkXo5kxTJKLnWhmpCPID8QXLWq+dsXYTc/wbcQypZDAiQZeJPYVEttasySTl8b2BE2lV9CO7ILnzkuydJz08vCslunEQGR74GhDhwVXN91vHvVWUZHDnuD1uczTkq7svWiC3wgyOYqsfIHCvgURejXSrEjX+csa51J+KjzuGMci4QJhhXqKR2SDnAH7N+Kq5y6kjSlPbHzb7dgL47oLLBJ8c3tYq8hOXSZ9YS5Ly2sqd4zx+gpIxymEVU0wE+ZZtA9BFGKGHOlPv9TQHoby3TV2ottW//IRrgkvgoGWnldOeFtYP8A4fP9ffreL2DsEukkEtZBFY3h6ZnwftTaGFnz3BaFj6Dder2EkhcpOirmAeTx5leJIVXsWRatdGiXFRg9boQVLto/afD5cG8n9l5le9BfIcd3bgOndNymsgPRqiS+gq1pqKa7lR4id3falpAI6xeLzSd3PH3Ek3A14p8StcDi4lyUVNsGCfECYe/WRxk4mRhMbNtY2MNTYgCqu0KU3xHgo8h7aZv9hbQPtwGF+Z2IxabtiguwNubItZsGAxLUJwOphjJnDXFEGtQG0PLmrkEKJDHKeJSc0LnVF9tYfPJF5uz4xR1J
 /IRKxR7K
 l8WbajbZt+2/5bwsAb6bncbkZpH9IAu65hSAc1GaLFOJjo73Ly7MrMwfgeNFR7CrhK0IJair8qO8TIoNI6c5U2RQy4b6TpX6lUl+cJ6XxHEE435X6i4JyuFmi5eax69S6lJYfFY2gcrg9OITymGsCa1mMouqzZpuJ1fXvOwsDigEyapPbfj38Y1VM5lkIxFYoVSyb3HqvQP46HYxsN059QOaivQFgnkKCySf6j0XSnQCJUxP8hVsxztm6+v9PlS9Zo/VOrT+naYrkcpqN5VBbrQ8Xn6cHOt9/3YtRxED0VUWGHq04dbB2Yp9g1st+t0l6VFLy3lHM3nqN0fRWErY5I2qEtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/1 00:46, David Hildenbrand (Arm) wrote:
> On 9/30/26 18:04, Lance Yang wrote:
>> __add_pages() returns on a sparse_add_section() failure without removing
>> the sections already added in the same request.
>>
>> For memremap_pages(), the failed range is not counted in pgmap->nr_range,
>> so memunmap_pages() skips it. The sections already added in that range
>> retain their vmemmap mappings and subsection bits. Retrying a
>> section-aligned range can then fail with -EEXIST.
>>
>> Save the initial PFN and remove [start_pfn, pfn) on failure. For a vmemmap
>> population failure, section_activate() already cleans up the current
>> section, so the rollback excludes it. If the first section fails,
>> __remove_pages() receives an empty range and does nothing.
>>
>> Link: https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev/
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> No Fixes tag, as I couldn't identify the commit that introduced this issue.
>>
>>   mm/memory_hotplug.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 796af1028ee2..ca4656698148 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
>>   int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>>   		struct mhp_params *params)
>>   {
>> +	const unsigned long start_pfn = pfn;
>>   	const unsigned long end_pfn = pfn + nr_pages;
>>   	unsigned long cur_nr_pages;
>>   	int err;
>> @@ -413,8 +414,11 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>>   				   SECTION_ALIGN_UP(pfn + 1) - pfn);
>>   		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
>>   					 params->pgmap);
>> -		if (err)
>> +		if (err) {
>> +			__remove_pages(start_pfn, pfn - start_pfn, altmap,
>> +				       params->pgmap);
>>   			break;
>> +		}
>>   		cond_resched();
>>   	}
>>   	vmemmap_populate_print_last();
> 
> Makes sense and LGTM.
> 
> Do we have a Fixes: tag? It probably dates back quite a while ... not sure about
> stable, we never saw this in practice. But if it's easy, we should just do it?
> (not sure if we ever had __remove_pages be limited to hotunplug support)

Hmm ... I'd leave stable out for now. David, could you add the Fixes tag 
Muchun
suggested?

Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")

> I'm planning on picking this up and sending it for the next merge window (so not
> as a hotfix).

Thank you ;)

> Looking at this ...
> 
> x86 does not really expect add_pages to fail:
> 
> 	ret = __add_pages(nid, start_pfn, nr_pages, params);
> 	WARN_ON_ONCE(ret);
> 
> That's probably something to clean up as well?

That would be a separate fix, I guess :) I'll have a look at the other
architectures while I'm at it :)

Cheers, Lance


