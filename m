Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AC6CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32B56B008A; Wed, 14 Oct 2026 04:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3586B0098; Wed, 14 Oct 2026 04:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2066B0099; Wed, 14 Oct 2026 04:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7326B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:04:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 056F61C385D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:07 +0000 (UTC)
X-FDA: 85320493734.12.2DC7292
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38BE418000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai0tDpZ2;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965045;
	b=MejtEgIVaPxAmERssX/g4VomYCj71dWMvfbl+2fxudY1eaVU0gZKRpnBu3/QSxd23lJJC0
	K5ijJ9KenwRCI8kYzPbYSyTtJWCHNHgIBNSu/r1GVOiSRPH/kF6lRTLc96ZeynltYHCbwL
	u9IZsXarzUjOnRaXpAeic4Swmbt+0Qg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai0tDpZ2;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deXI1eiZdMA+rkrnahrdm835ND51y4e0N1ut/tP+PjI=;
	b=3bccXDaEgGI6DiSdNGX0TswsCfWDj+UQxEDuMOjYE8zhpEoVx1sbrTHo/Dmqs1bp8luir5
	NQMg3MFkTlyfW3IJhElT4jKU6IR8R7LW9t015GVbZ4OilKNl3xqok03zyEy/50FRhN7Uj0
	FendANoWZ1Y6vN/BcfVwlo/zbEAajx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 482C543E0B;
	Wed, 14 Oct 2026 08:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354451F000FF;
	Wed, 14 Oct 2026 08:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965044;
	bh=deXI1eiZdMA+rkrnahrdm835ND51y4e0N1ut/tP+PjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ai0tDpZ2EZeG/dvtP+1wHIwzOW7ilCIq0udzFFDkI0sYJoRsijgr1TvQleV8oIaA3
	 +AI4sbxOlu2cs0No/M/Orymgt3KpM7nYldonsRcxk44/NWct60V6MuWz6ND4fAuUnX
	 sISzo56gQmTUvPta4zKqa+EuKemlpuGcBCG25RAs2jAMRa+n+p2jGXFTk97c7EvyIT
	 X4av0a3nGHqCNa0X2yKZLUtU05RfHB3YdjPAAXtwOoOYWpFg3zaEH/pmgFDqMTRkTw
	 9nDmaCaukYhgpG7j6rNBn9ByTlt8hoUYpH72HtL/HUqORiIi/+NQOY7NPFlAIGmU3R
	 7KqMMan2HLljQ==
Message-ID: <8d5bbe19-710e-4488-901c-22263ea6797f@kernel.org>
Date: Wed, 14 Oct 2026 10:03:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: Barry Song <baohua@kernel.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4qKLx_XwQ6qY3p@thinkstation>
 <CAGsJ_4y5j+p0-VdEzpnS-Q31vhvBZRa96VJtA6+HyNj=+r+Ufg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4y5j+p0-VdEzpnS-Q31vhvBZRa96VJtA6+HyNj=+r+Ufg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38BE418000C
X-Rspam-User: 
X-Stat-Signature: p111w9ksnb8jxosaxnocrdf8bxii6ab3
X-HE-Tag: 1791965045-12507
X-HE-Meta: U2FsdGVkX18uJcnyklUHpJwfwda90DzwEX5R8eoESnM3QuMl/y26gGjUEA+d+zrbDcsUHwXi5+zOfy/sxmDXNY1P0OldvnOCFmQqpcUbla6TOw48ofYDlNmLl6nCB3OuJmIxf+O02i37gUKuYTMIUpKwZcPkW1gJnsz07wU4bNFgKNW2XJzYWlPCsBJCLxyFIBm6M81LhHPmnRUg04hzUmDRfqbU5itNC/dBEhRPnLQ6WmlVH0yahCtfTwQpFsTqZGiaKor2rAfrpyvjsC3YUmvl/uRZxAKohS/yvCtknomVYvC3m5x/nQ8B8CioZrGTKY8uQNhNL8MRtJrn+sYkmBgNlrM/lJpt0h7/btLcHqkNaLbstoXoiKZ5GHXA/cbJhXSIF6DiftqtSawALjiH8zGVydoj8/Ko5RJuI7aGmMK58oMwTSyT6euzSsKxQYTIXjxLsk6wlqwsToefKcHkTnc+lMc5IAajYheTHblWKzepitVWDRxkHYVZBUBXrSC+exUuMddxhErtuzwC3AFdIF9GuhHeqyc23sAG9th+UmDpTVWo/QdDWOWppZwf1IFO81yuyMD3+0Q77liputCxzwpsxjz+lzGawC9ck7yN79dJNjB1qNtQ05htWB6oU7uTIzFhIzitvT18vNP7j2pBhO/hfccdGgBVi2fDWSinCQ+MxU5GAzW8Dhwkkr1vCr1s95NcFrxgG8fvUZaijOVh12EMJVyc9K3i+7rRa5+arYLTysUU2G7UsIPCOWziPkQWP1W8bvchtM7qgTqUCKGRlWOGHdDTf/ZZLVBRMHcEMzcCP1q8xmYbryAYTevzLgzuz1x/FcsWqKQlP8UY2wCbnxQogF4EZ3cmcdweCD589r3DP8SFtLytWee/7fEs7IEMprNvCvnuKfn1baUpQkO/tG//BVAIOtXWXB9+bSe3lIThujb9pE176wsgGKICubVUqIbSBRag/b3gxbzWVrF
 F5Sa8lIq
 GzEwHBIlvU3eyd+/IQX3sntAv+W140sI+E8NzUrxebK8H5SlkJi5Ep3uCTNPFHGEVxsDcQTBWvyk0rXJ+cUYyo5jgCBglsaGT6ntz1BD9Ew7fP4nD0A78rBstqZ+gcUvOkkVobMoGXsY92iUrQSUKty/c0Za7xyJ757QVxvHn2YTkjE/jAegGpYjaR5VJ7XCuZMM28Otok0nVq5MAHnQ1QXqZY2ZU0KcltI1TkVTgW1wmIdM3k38UBmmD8r9Hl5pb/6sPqCpz6gh/WGv02EsVhu1Q2vDsjlkptlafh+/UU+FFUXq5F25hCJz9tINQ1TAX6tlGr8ZXbyig9mnFPexup2n5oH2YasJ3B2jgM/OZJq5j5r/jkqFL5ig5D4HoW6QcB9dQGgGMh7d0tpAYzMIYNN/yNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 15:17, Barry Song wrote:
> On Tue, Oct 13, 2026 at 8:57 PM Kiryl Shutsemau <kas@kernel.org> wrote:
>>
>> On Tue, Oct 13, 2026 at 02:30:37PM +0200, David Hildenbrand (Arm) wrote:
>>> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
>>> generating an address wraparound, crashing the kernel. All that's required
>>> is to map a tail page of a large folio close enough to the start/end of
>>> the address space to e.g., make
>>>
>>>       unsigned long addr_start = addr - (nr << PAGE_SHIFT);
>>>
>>> to wrap around.
>>>
>>> Let's fix it by providing a better helper, folio_pte_scan_range(), that
>>> takes care of staying within VMA and page table boundaries while
>>> handling possible wraparounds.
>>>
>>> Reported-by: Kyle Zeng <kylebot@openai.com>
>>> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
>>> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
>>>  1 file changed, 29 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 1f5d5f7d39cd2..a3823010aa981 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>>>       } while (--nr_pages);
>>>  }
>>>
>>> +/*
>>> + * Get the address range in which a folio might be mapped, assuming its pages
>>> + * are mapped consecutively and the folio page at the given idx is mapped at
>>> + * the given address.
>>> + */
>>> +static void folio_pte_scan_range(const struct folio *folio,
>>> +             const struct vm_area_struct *vma, unsigned long addr,
>>> +             unsigned long idx, unsigned long *start, unsigned long *end)
>>> +{
>>> +     /* Stay within the page table and VMA boundaries. */
>>> +     const unsigned long pmd_start = addr & PMD_MASK;
>>> +     const unsigned long pmd_end = pmd_start + PMD_SIZE;
>>> +     const unsigned long lower = max(pmd_start, vma->vm_start);
>>> +     const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
>>
>> These -1/+1 gave me a pause. I guess it is for pmd_end wrapping to 0 in
>> the top PMD? A comment would be nice.
> 
> Will pmd_addr_end() make it better? I mean
> 
> upper = pmd_addr_end(address, vma->vm_end);
> 
> nop?
I don't like pmd_addr_end(), given the weird semantics:

include/asm-generic/pgtable-nopmd.h:#define pmd_addr_end(addr, end)                     (end)

Even if that doesn't apply here, I much rather spell out the boundaries clearly.


-- 
Cheers,

David

