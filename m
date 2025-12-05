Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BF1D3749F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C2C6B00A9; Fri,  5 Dec 2025 15:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC7E6B00AA; Fri,  5 Dec 2025 15:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D393E6B00AB; Fri,  5 Dec 2025 15:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C25046B00A9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:44:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60F1FB7BA8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:44:40 +0000 (UTC)
X-FDA: 84186595920.27.34186B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C0EF0180009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:44:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GR9nhZsD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764967478; a=rsa-sha256;
	cv=none;
	b=4spYQJQEZxROvo70AUZdZn60dzavxrrKDPVdH1IbJ9XDYNj/AafTQzHkKgbFX+4IuyVHJG
	R88yaN0b5MgWQWeQiaOrZMI2L2ZF//Kox3Ji13l93ImAAKYeOFixRqYzElzjkC4ePPiNlC
	SzPy3kFujYBagDTpLZumSzEfAHrfTng=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GR9nhZsD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764967478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLLKlZs3PljxutFFTRrEVOHA0X+yqKEE6coeSKfplLs=;
	b=tqxMFn8l8/balmNl7dnSE5T53C7Ma2Sp1C0+7u8T3oLX1IqcDJfTB1ZBaoCkWRAu6i8uXn
	nSQT2laWHkhj5XQiBlEdXjKkKU025yLDY54gPHkNxMi1qOQwGwIDNL8ZH9OSFVO3qYIGl3
	yU3fCVUvCBjfSfOuFl+NBb+XjqCS5PY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F6960138;
	Fri,  5 Dec 2025 20:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD96C4CEF1;
	Fri,  5 Dec 2025 20:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764967477;
	bh=pHz5hkhQL1nyO2Xo1UP+jCYA8k8KmKAPUsw1DEwwuH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GR9nhZsDiAIoBkK8RJlqM8j3WIVzPu/DIos2PlJB8FUZa6IwT9sVMHNf+DxXGJRsl
	 TVljgZJpbw3njRaecgfLMH7L4FIS8PLfR7+oQ7gtzwr5ynAMtxVl2qyuNyy3ucr/bA
	 49yp8XMXYF2hP3iBADES7sZ+1t2cVQnAu0wCieoJu4ZGESqNyMW/nP/yypr2PSolxY
	 IMKKsy/NB2B9akd1Di06yKTiWRKK16gU9BSDWGKEq56yNliolY325xpLvfuuNnKghj
	 Nz1XqYsF329+1CdOAzPQN+IVvvDotUvyGd3+03Bv9pU36ouCZy3jFwmAy4NAfbCVoE
	 0VgDjb1aiyL4Q==
Message-ID: <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
Date: Fri, 5 Dec 2025 21:44:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xez4m5pw1crx3tkmzri16betgucbpy9o
X-Rspam-User: 
X-Rspamd-Queue-Id: C0EF0180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1764967478-460374
X-HE-Meta: U2FsdGVkX19rjrdafuk3jikrD2kMxKU1FZPMFpaT2vpEKVZAD125bjwrvdYxTqigZbLSB4moC1IVsqYMn3OZIv/QbUSxmsLisQmtBM3P+K0y2e44q1L3l5NxfR3qw4GDTWpc1+ez1BO7XEY0IJBfyTZcEgnDJng6EZQ2fDANtVTm9cyP7INqzPXR7xAKn9j1dM9K47kLIHdok730y3K7MlSjGEgT1rRHcfAH6oA1YL5KAJodC5udswy9aAqvXrT3tQOYc+g026II13QS14qOCGqW1Z0usBS1WCvqvopVc2XCWztzaPpCNm7WBVbvUPfYvuFVJAes/lI+MkSgPJBsVO10HnNNzHdutPZWklgh0z+uHJ8y6lB90PTSr+G7Z7AxLv8vjDXSLqIRvoP/jTs5zIs7wOBqIXEWEu8z0TfTtGsLDG8FrbnpkiSPj6PSizGkNMZ5nWXUkbY8SDtkHEzSEZqSchuvbbrKgePDg22d9z/KFT4XlSzaSgft7avXZkwEtFVsynrwxT9J9s0XG7kAnanmjwssd3EFibVHp7c4WNPiVUbxWaYHwezH3Hgkc3eHO0kIgDEyvlXI8sMy8Cp++AFeAzS/mZHkpY4Q23rVBNaYq4o8wavQ9XwCPdExMaGxlGZO0f49GJZ1tTlSqxce9dsAY2xDX0eGbbAfKq7EeHu0UYHLVXWrLkhtv75sZIXh3BQYMyrhpHkmqY/9H+SKNx+4w7dwE7DnFTnxNXlgU8bTiQYqKzx03yWsRTFOwF/4MIlyYwnOi5ETr+kM+eTzI72Oht32JZiRWYHoBcIU/FjS7r8xaYofvMIYWB8T7d9Jho+6VkLv+juWuFKFG8cGwBly3wQO8Qz0Q6C4Ako9FMYNRQb/Ia07t5jZyb+RlR25nfgltX4xZYpgCzuDSnQfFV41wTvZSKew5nS2BCYpCwfeMqgzwoBI/8eGNKDDGHUpXSLDZzbQENg0FcJ7Zl8
 aSnMfIVR
 yyg2fgYOiEnN67wRXya66b3ljCd4/zkNLGIv8zQA+Eezd72R3wHJMMoQ3toLNI3njRwa0Opwf4XQS0DkeDt8YvBVOH0b375t0ltUTaIzlXeZtWn8H/06JrGTTvoJ7ugOB3MQf67BKOqMfHTQo8PdACxKRkjbHWj5VrLASqmWpWqeoN8+aqC03m7IczgBIwQzHKUHl76uiiVK1TxLmcqBkctRemkmSs77oAAd/NpK7+Dg6ZbI0BZNbcts8v4KuLbSa7eZ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 21:33, Kiryl Shutsemau wrote:
> On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/5/25 20:43, Kiryl Shutsemau wrote:
>>> This series removes "fake head pages" from the HugeTLB vmemmap
>>> optimization (HVO) by changing how tail pages encode their relationship
>>> to the head page.
>>>
>>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>>> hot path.
>>>
>>> Background
>>> ==========
>>>
>>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>>> and remapping the freed virtual addresses to a single physical page.
>>> Previously, all tail page vmemmap entries were remapped to the first
>>> vmemmap page (containing the head struct page), creating "fake heads" -
>>> tail pages that appear to have PG_head set when accessed through the
>>> deduplicated vmemmap.
>>>
>>> This required special handling in compound_head() to detect and work
>>> around fake heads, adding complexity and overhead to a very hot path.
>>>
>>> New Approach
>>> ============
>>>
>>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>>> common case), this series changes how position of the head page is encoded
>>> in the tail pages.
>>>
>>> Instead of storing a pointer to the head page, the ->compound_info
>>> (renamed from ->compound_head) now stores a mask.
>>
>> (we're in the merge window)
>>
>> That doesn't seem to be suitable for the memdesc plans, where we want all
>> tail pages do directly point at the allocated memdesc (e.g., struct folio),
>> no?
> 
> Sure. My understanding is that it is going to eliminate a need in
> compound_head() completely. I don't see the conflict so far.

Right. All compound_head pointers will point at the allocated memdesc.

Would we still have to detect fake head pages though (at least for some 
transition period)?

I don't recall whether we'll really convert all memdesc users at once, 
or if some memdescs will co-exist with ordinary compound pages for a while.

-- 
Cheers

David

