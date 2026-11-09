Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4A7606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMOktpQ7
Received: by kanga.kvack.org (Postfix)
	id 1C15F6B05B2; Mon,  9 Nov 2026 09:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1720F6B05B3; Mon,  9 Nov 2026 09:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0610B6B05B5; Mon,  9 Nov 2026 09:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D58DE6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:26:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C3B0120656
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:26:18 +0000 (UTC)
X-FDA: 85415805636.07.7E7D840
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8511214000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:26:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMOktpQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794234376;
	b=N31osXMxasTArJEPfr9B+tOftd4acz3QG5Ix+rZh7M5PA2FzBieTkCmfvJDCORN6wJF2vU
	hc+H1uT76RNP+/xO/bAjal+jsmZw2JDmxFY7O5tWLrSndDwPuBAw/bFlhaYQpZ4gTYE4GX
	wFpHt7HXwcbUag0Gutgeszp2hYBlyyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794234376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9llKXUjtBg6NYHrvZa2RZ0JKeiVE2awkqQc7/d86Ts=;
	b=VmDWuvlgY65nCUOFluIYnNbPvhk+MytBMtDKTvhA9clx58VyLrVQVOzNbbk5KVgRwrstRd
	F0Gdj4UWqcAOmDAgpz1zId5hO9vY/+9LvkhrIN4Wu8xZiio1O6bF0xO5+3CVHnwLxsuz69
	ADDEylUX1pJc5VKvzI3oi3Xl7XkojVY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMOktpQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E039B406FA;
	Mon,  9 Nov 2026 14:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7199F1F0089F;
	Mon,  9 Nov 2026 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234375;
	bh=B9llKXUjtBg6NYHrvZa2RZ0JKeiVE2awkqQc7/d86Ts=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DMOktpQ73zOGC8v05iI/+U/1YfqHpq9vNS608Oycv4UNs8X1mYegSrCtypjvxWnF6
	 L4DV3s1GLDSfcLfCzBFgTmIIEfFwCXb5WYu+pWDZsjFgBHslsKmwVy831p+zDvPFnU
	 zGRlYzuxhnJnMZ2V0bJYk3maeqoanOEScQayztjdOZsLdbkhgHFf1RXkus0Vpczaft
	 mGnaoV5SYoXQUWqb4GQ+UkRlNz0iMVjc9vlSolytFBzEM6yxdlx12vvU+ctoUAKATB
	 +9Wc5UDGNQzrPuPHc2NvGxxYeTpI0F7H5ZizL2UrMXvVw4NIfnZ7n/opOWFU9rjEu4
	 8qPoSrS3USUTA==
Message-ID: <788856b1-754b-44cb-a5ca-676400d29a76@kernel.org>
Date: Mon, 9 Nov 2026 15:26:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: free unused page table allocated by
 do_set_pmd()
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261106153414.2938216-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106153414.2938216-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8511214000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 813dp1g9zikgghnwccosyzzr3hnbqipb
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794234376-423166
X-HE-Meta: U2FsdGVkX1+P6p2wE3VwwYk3bGG2BKAEX0Y2QCCRjPVnBg9ceIn3M9KqDz9qSB76YMp5DHYho4GhBtHv8NzGTE1y8kf8Qtj9C3Cn76lPeNdb5RAzjso6b0ujXykjonZtZsfvlIjkJyyOP9WUyRCsr52ikrJa+t/PBELymxs14+XE0X8kf3nPhAStrf9DEPhQ7wh9JUm/LHuiZ4tw9ndyYn+J9ZAVFOgsb/6A2nPsRceIsFNgSw9D1mzEbEFTLTaVIuRUBUiSQ/WobIbLciTQ6o8IvH9bZfDYpTyqY9blhaKk3/WI3EXd7Qf/pnTd8uuTDkAEt2KFzRpInlxiZL/o9RPaIVoHfBDHCu6uHNUSvDt87Chu4pHJ6MlP/p4Vy7+FSs/HS20AM1yjmnKTxgAQDvklkN+UROqAJO4yeqcGuycnXc1RtEWjQMGAvkJCGkVS/yOPofFaMHYM7eQZD8CMDK8Ro0FWpyPo12rfdWJ0Dm2QeNpztrs/M0/3gb6M8KQMzpgaZEDVtnhs5yu5R2crn1g21BMblF0vHUgSRCCaXpjRNpzUuIFGOw1QZ5Y5w70qalJzvsdQfLoJ+gddypL9tg+bzfiWuNtrTIhE1e6sgH5T4+bMhHw/uJYbeRrwITfJhDQoGvGZMmrt+rYf0bm7Ib2gElCPkPj+1Vmoksbwr+gv+0rLJgV3/TNpiRzS9pBkd1F6kJsjnr9jPg2RX+Kr/XeNdpZjFqdPpL03ooWy4Fd5xDyUDeQ6GAyEB8/ZZH9BBiKW21GwFbNCd+kCruGdGFXW2nFUWLAzu5db3Qz3Rk2/xmMabporgy90ZJGVY78ZufBpsr9x9XuQTPRws4PEd9hJL29oAjg+CrVU7shy6vGw0C61XV5JvK1jFggIkabzG3sKYLI1s6Iea+L3dfXECYviV/Hhj32WPetYXnS1dWjRu8csuVrr7yz/Ye+de47VMYCzSEIeM0JXIFtMYmI
 02f0XoM1
 O8eTBS2Ml/FbXAik0vpeTWr5wit/sVQgOXcPZvTQrUp0YFXBn/Lnv8PnwrlbPmlmuS1YMzDo4foXYsg0/JD9cNU0F8vz6oNAcnZM54Uu1t1w103gM7jlQAO0fN1U75sK9IngiPLsEWqYVYBLfMJ+2gzgskPyHacN1qaDPylBPv8EtrJdrmucCoAIza2N6ON/QhQ973coe/Hs/BgzuJ2N04FVY5BDYajv/CmRcFU+TpCniqLR4Ll4u5beyKcj1hyPHI1NT8+V+JvEIErGCrzCVmwDYX8F5f8sQM6xKHRQY3X1sW14KlNt/BwKVNnWIWApOiag62x49p3/TNc8EWneHjpA8NiZiGeLYPUlGBeJ8u0NCttlfka8NMFPqnp9/ij+J4nsAPnMO6g2bnsie8aCPMf/hG7QZhCENXUERijmt7IXO222oYFmSlHhrAXhI4lFr/HSQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 16:34, Usama Arif wrote:
> On Fri, 06 Nov 2026 13:36:12 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
>> deposited page table, such as PowerPC with the hash MMU. If the PMD is
>> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
>> without consuming that table.
>>
>> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
>> userfaultfd operation can install a PTE table before taking the folio
>> lock. If that races with set_huge_pmd(), the unused preallocated table
>> is lost when its local vm_fault goes out of scope.
>>
>> Track whether do_set_pmd() allocated the table and free it after dropping
>> the PMD lock if it was not consumed. Preserve any preallocated table
>> supplied by the caller for PTE fallback. Successful PMD installation
>> consumes the table and clears the pointer.
>>
>> Returning without a preallocated table matches the existing behavior on
>> architectures that do not need a deposited table. All callers
>> already handle that case.
>>
>> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/memory.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> 
> Reminded me of lazy pagetable deposit series :)

Not just you. haha :)

-- 
Cheers,

David

