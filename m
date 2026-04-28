Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCCBFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73096B0088; Tue, 28 Apr 2026 03:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A0D6B0092; Tue, 28 Apr 2026 03:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FEC6B0093; Tue, 28 Apr 2026 03:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6CBC6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:06:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79BCBA040D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:06:24 +0000 (UTC)
X-FDA: 84707081088.23.4BD053D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C59838000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:06:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEyfOAJ0;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOJcoG3zvYmum0jODQCqWFsME7nvodkfLEQpQRn1UWg=;
	b=MuTE7Ktn+7zLha0s4PQSzk94Z4jQYjuAQXJ0D3kzWqyRtOZD9LcGCTFlxYQFLUnw31ZpmY
	Q60+F7zojsAAQBzmBURLqmqiWsu7CWJALQGPRhH97VihAkJRfnqvxVMkyRkcNmxSotg84z
	iHRneqZivMSzmicILZWNIhMZzrT5sqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359982; a=rsa-sha256;
	cv=none;
	b=kuVeZzVcmOWaL6ntU+3GpEDVIjoM7Ayhhn3el3Wy2vaIJ/7g8G3CIsplZgIDX9NJCXrdof
	Bc8aL/K4z62r1ZdeI1NBSfK41BSXIKuKO/YAOugjOtjY/4tyQ2M1v0/qqUchaZFZPxeNC7
	AmOtXN1sx8d8GVwDGpN5cvrmbCgBtGM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEyfOAJ0;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5815960133;
	Tue, 28 Apr 2026 07:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765AAC2BCAF;
	Tue, 28 Apr 2026 07:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777359982;
	bh=WMCSp2ANSc4rzWe/QHswbhY2Nx6MR99VRyVaYQXiNX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aEyfOAJ0gD3wAl9oC0a8NTWIbaNvFiVVSppPD+t2m6hrhSKnzBmAIBcBWFxEJhM24
	 moMFkwtxtrLzGEFreyfwnwjsGROFT2hMMf1wFHHKybyhXCJqTMz9Ox+RPVBkeUoxHc
	 8ArQ8tN+CorcLAQVvwhsY2QQ3Wy+bk0kKfnEiK2L88LlOJmKHN253HUYT2HdtuVlB8
	 DO5WoBc+LKdxkwHVV2JEyyZsvozErLyWDK49Vd7JGTqHJziEhrw+cora0uBHW3jgO6
	 biWyUQ5XO9gsCKE8iMnRuQsxsdEbO9dzBOj1etJGvui47LAz/qkRaLXa5mpJZupysK
	 qU2G9oVXQ6l2g==
Message-ID: <b0243130-dd6c-4c9f-bbc2-7458aa0615c9@kernel.org>
Date: Tue, 28 Apr 2026 09:06:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rkodsara@amd.com, bharata@amd.com,
 ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
 <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
 <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
 <f75e03ce-68d1-474a-9b85-157f73af48dc@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f75e03ce-68d1-474a-9b85-157f73af48dc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C59838000B
X-Rspam-User: 
X-Stat-Signature: 9wphfa74kqzyfpcwgfon4bk81r99uqzk
X-HE-Tag: 1777359982-66909
X-HE-Meta: U2FsdGVkX1/vE+uxoUUuHr+sbi/L8bGSI7lbumQYoQyEE4YlpsLnhp3NM3h+NjkZM/sVHW0uB+Btwnvld4Wh3Hd8S1w9YKwk1vh+0zzCUjSc63mBmICqhaQ0TRGRC7ZB+7eFzRggGxckT5zj/BomKMNMVct/XU99SNzhIueHjtCj937Z4/PJXySde1hX3zwnroeGBQvL3heOT8Y6XIltNoi1nlL3CTq7q1u+gx42xpq87+SRzGVxRDhlQTgNdivjn5V1GPmvbkAJ3mgXHmpZneFTDf7IRL9JnEviUbhOz3AXywAfVJBLGMGicvatTQ8XxcKpRWWszETMLMEv95K1YtliCUyTmOlIxpv5EcPCjinBRDcN5/0sqz7HbVG4UduQEYtMvukmdo3THRMoNfNSG/wtLTrkmSNj2O2V1OR4o8RRXtaCijFxGJ9w83nCxqzCOns5RZj3f4WSIa8BpkeRab4mjn720egYtjTltzeJuXuk+QZG/uxncCn7BV8BXlaE6Mk/BX0hdhgC4YN+Xg4GSXm4eoUoS3TiXwaD/MaqU1ONXY1xdBW1rqVpfIylkyQ2MAymXGIe4sha80se1b7T9n5X33o3lw6O68YAXYm6fjWLu/rawzdS25AaOYtzXhWeoni3GDRlaTsb5KWrJ9YdA8nMHDe7FlcNYNPogRwD0/HDKjfHqRrtw5/xQHj6zwxbqLGaQSYHn7FGrzFnH2LPmvy/hNs0rq4eHijM2sT9xCgYfrqFc0T+TwYEBs8PzErdP9+AG5F1Q4tbpincLzkPhulV16mlMHANAPWsqQgfQA8YcAK2XY0ORHSIBpttpD2j+mjWgc9qdnCKgpuXSPiFNhV6cko2RZ343tr9tn4sdDViNebl0tOxjwnf1HeuVuzwNkcmbJRoFACZs+1oWtel9S/F3uSfZlg7/r2mdv29rS4Heoz2BfnNz+EAVATK+31j1D7ht06dByVNyLWL1Xv
 zJ/wRhio
 1J0HVnMmycL8gRTEfwPXbvxZYP2GpQ9eFJ06rqyul3FBXfjBCA5vYouX90dle0NWzB5jgzBnJ2xXQFsEI5UZRkgy1YdaJDk7k9oHX0Q8C5JVAeqNE85GdZrqkS8qWrddRfJwJv0gADmudS6ESTLWcwXg06YRL5hjbb1dHwDAlUcD1+SoZ8PbkNIDgNS0YdJm/vC5xcfCQmjvz1y2Mj/uth0NfeUgeD7CNTtBqHX3JXt/c1lerJiehL2oJz8+deLFuaYnhnDcrMmha2YwgtRDWwOHjgguomidO+DQxPGbng4T0O73paSmmQ0Hkjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 05:55, Salunke, Hrushikesh wrote:
> 
> On 24-04-2026 14:22, David Hildenbrand (Arm) wrote:
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On 4/24/26 10:42, Salunke, Hrushikesh wrote:
>>> Hi Andrew,
>>>
>>> The idea was to keep it alongside clear_highpage_kasan_tagged() as its
>>> batch counterpart, but currently it is only used by page_alloc.c.
>> Right.
>>
>> Looking at init_vmalloc_pages(), I wonder if it could also benefit from batching
>> if we find that pages are actually contiguous.
>>
>> That would require looking up multiple pages at once. vmalloc_to_pages() or sth
>> like that. Surely, doing such an optimized page table walk could be beneficial
>> by itself.
> 
> Interesting idea. For the general case where we only have struct page
> pointers, we'd need physical contiguity detection and a batched page
> table walk as you described. But looking at init_vmalloc_pages() 
> specifically, it already has the vmalloc virtual address which is 
> contiguous, so can we just do following and potentially skip the 
> vmalloc_to_page() walk entirely:
> 
> clear_pages(kasan_reset_tag((void *)start), size >> PAGE_SHIFT);
> 
> What do you think? would this simpler approach work
> , or am I missing something?

Good question. :)

That way you'd be operating on the vmalloc address range, not on the direct map.

Is the vmalloc address range guaranteed to be writable at that point?

-- 
Cheers,

David

