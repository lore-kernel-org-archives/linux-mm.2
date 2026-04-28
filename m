Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6FCFF8870
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24B06B0088; Tue, 28 Apr 2026 03:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5E46B008A; Tue, 28 Apr 2026 03:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3F16B0093; Tue, 28 Apr 2026 03:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8C16B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:00:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BCA9C1D45
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:00:59 +0000 (UTC)
X-FDA: 84707067438.20.A8ABABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 41C1C40006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:00:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu0MbgI0;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcGKtpu0fyaOAxfViqvxyHG+YMJppwl/9j81YaoPJ3U=;
	b=yYr8KptMhwHnt9tBtdXTG8R9rtt3wkFqGY8Rsrv4+MFzKRS+GjBXH/UxR6U92FZfhHfKUt
	PNruE0cj/nCREj9AMAByVOvuSazZqQzITfwATkzglgRFhQY8DP4ssC2NGuNVCXU/xm35+p
	paLCg1/pvfcH/uJLu4CHbHB8WgB6IBY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu0MbgI0;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359657; a=rsa-sha256;
	cv=none;
	b=MNCY3DfWxjAwP2VZpxMosNLo0EBHUPZEKY1Wx+vJ2dDnzz+f+upBTnEutFRKJoHFnWtasj
	gkwbb5hwd327aHnp9LEIYytT9kZnVugG64zbX6t7HuB0F46HUjfKM6JnyXExOxQ5Fm5bMi
	IccKiNZ1xd3a03CLWnr/5gNiu3Utf48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D351417EC;
	Tue, 28 Apr 2026 07:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DCFC2BCAF;
	Tue, 28 Apr 2026 07:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777359656;
	bh=mWEoXCJa0DQnUyfnGxUpu/BTh/Q6nwhBraWSK3o7V/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fu0MbgI0KrRTvZFSHNedTCzJtOXrvcPs1OgaKBd0+wcYOrBjyQo+VmKvKD4FcWAQA
	 QwQ0KD4Ajaedoq7BCTDODk5seEHOdTpXTDJCp9OJdIG2j1bPoVn7WFKPa0B9egllAC
	 ZDVAzFYFmCyk9fxZPLhi7SpC+0vftXWDTwY6RYoTIhB3jCRSbEKetpWc9zQoThNKP9
	 LmBJHH1dSoQAknAAJIyCmyrHcgSEQJHoXPGNs0ujExJST+uaO8NCPcZcNAdZha4v/S
	 nRmLERsJ596VosCsKjG7oSOa/BN5tCKGjVI9DAJx6i12BkbyV69E99gT7qvLTl0ztE
	 e8a88g1KOkM0w==
Message-ID: <5dd84f9c-4ce2-4bc8-b644-e865f0623ba3@kernel.org>
Date: Tue, 28 Apr 2026 09:00:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260426092640.375967-1-songmuchun@bytedance.com>
 <20260426092640.375967-5-songmuchun@bytedance.com>
 <09298afa-9a36-4f29-a8e1-d4750c338df2@kernel.org>
 <C2E99AB4-CC47-4D9F-BF56-F971FD5A3C26@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <C2E99AB4-CC47-4D9F-BF56-F971FD5A3C26@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41C1C40006
X-Stat-Signature: y4obs8nz6zqc8iqwib1u18xrtpeg6orj
X-HE-Tag: 1777359657-564179
X-HE-Meta: U2FsdGVkX1/bXoZrfpihYWpqdqzUBLaer9Zusdhgc0cbbPjORXBxTRp6kA2mOyaid7fay0lF/UBQVvxjLqYIpAawmSjzmRhGajsHWg8sibjFbrvs5QIXNMl+pl6l2eGI3WzBO7VNyEtoeSFFmH/GIF+LHfVfCN3gbVfDkgTuB31oWaMmABf7zWZyJ+VbEtUWZRHO66+bsetCvyQpWxzSE5Tw+kCvBxL0C+JhJneHFMvwF99+En9sh1v2C19O+0j+PNn6P/AKeTIsGL6zErZb17wirpPY4pcB+ckkqH7XNBoNgZT9dv5DOhxx2o+/eN4mCtI/0TtQMEBj+XOTNzh2lPthmdjc5XwKZ0ptS74t1fKyLyK+9X2hqdM1hgdgCkCaPeCfuIfEHl58E9dK87R5lCSXJ6x1GLf+KCEOJHF+UBXdFlS1yyY2DCwbdLJzvjtk8rxEhPM5EvCBK4BOlQAaZUrSGul9zoWacXr0uVVICdwy+BOk3yUZ4uLpAyoMEhXfG2LmuWxhs+tzy+b8WMzmXO/GXRqXmJj2PKgm7569hefH4I9jbRtVIbR18idUA/9De8DBLoyPFRh6dwx/n+sACHzATcvYWc7tIt/rHaT1OWd4i9olK7KqTkoxMAzC4jlyf5TlTtBCAp17xfDe+vZZNDuwb2ANFQOWsUXRGBPkcEZVinyU6xlyOnHt80AI0aG8GdktzTa6ZaLnCJnVpsvmqGlhYZwUyWjlfggZEolOomJeE2Vprw9OqHtFntSH8Hpd2l9Of7RQs2yF20+6KIMhxf0e0hQiH1vY+r+fTGuSdkZJqTDNZaDOkoeT0L778g/aIYlD09PerafqQ+pX+E8HsrtZ44EqD0XZNlYzffWHb+a0ovq2Qlwi/2atZvMc1i2dTO3w5lbTtTG7ukIns7oFdk3el1ZtnndPgtZ0TUyLJBHITHRaa7hS49XhRO3+9gC/ftNVROpF/KI2IxnRM3d
 H+H8cpvn
 QFHugFfz2M2tfvm67nehUNr1CmzfsS7n7H3jo9IAPduwpS9oH4+FrxIZqIYbo67OpO2QTygiK5ZJ0x9x8xpoXCa7ThAM9cblc4YxYAlX8tiZjt0kW+tOm3SKsggfEFgLl7U91zlYYJrGK3VL46KrZABTl0OKCUu96G/MGYE1yqJXF0tcWR5AUkDpZlWVWdU1HNY5uF6qcJeSOBSoWVNaEhL2FqGQ0pqaJgE/P0gnbCbsARNULzJXOlg8eWq5cRBM74UWK/9d8EyJPAYouJeHWKIpcvTWQvQi/lMVtQp0jynaV5Cup5SyDZQAw5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 04:21, Muchun Song wrote:
> 
> 
>> On Apr 27, 2026, at 18:17, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/26/26 11:26, Muchun Song wrote:
>>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>>> counter in /proc/vmstat is incorrect. The current code always accounts
>>> for the full, non-optimized vmemmap size, but vmemmap optimization
>>> reduces the actual number of vmemmap pages by reusing tail pages. This
>>> causes the system to overcount vmemmap usage, leading to inaccurate
>>> page statistics in /proc/vmstat.
>>>
>>> Fix this by introducing section_nr_vmemmap_pages(), which returns the exact
>>> vmemmap page count for a given pfn range based on whether optimization
>>> is in effect.
>>>
>>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>> ---
>>> v6 -> v7:
>>> - Refine the alignment assertions in section_nr_vmemmap_pages().
>>> ---
>>> mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
>>> 1 file changed, 30 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>> index 3340f6d30b01..01f448607bad 100644
>>> --- a/mm/sparse-vmemmap.c
>>> +++ b/mm/sparse-vmemmap.c
>>> @@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>>> }
>>> }
>>>
>>> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>>> + 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>>> +{
>>> + 	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
>>> + 	const unsigned long pages_per_compound = 1UL << order;
>>> +
>>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
>>> +
>>> + 	if (!vmemmap_can_optimize(altmap, pgmap))
>>> + 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
>>> +
>>> + 	if (order < PFN_SECTION_SHIFT) {
>>> + 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
>>> + 		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
>>> + 	}
>>> +
>>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>>> + 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>>
>> I would just have done that at the very top, as this check applies to all cases.
> 
> My initial reasoning was that the current formula holds for compound pages smaller
> than the section size, and we only need to impose limits when the page size exceeds
> it. While the current callers of section_nr_vmemmap_pages() don't pass sizes larger
> than a section, this will change in the future (see [1]).

A function that is called *section_* will get a range that exceeds a section?

That sounds conceptually wrong, no?


-- 
Cheers,

David

