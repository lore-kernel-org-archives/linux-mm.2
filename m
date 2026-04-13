Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D21F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245966B0098; Mon, 13 Apr 2026 14:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFAC6B009B; Mon, 13 Apr 2026 14:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096D16B009D; Mon, 13 Apr 2026 14:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E77AB6B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:39:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3C83E01F9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:39:49 +0000 (UTC)
X-FDA: 84654396498.02.330110F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC78E1C0007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:39:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEDQuqIW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776105587; a=rsa-sha256;
	cv=none;
	b=gautWlPiVXBCzijzOKLS1X+bnIaSSEwbcfI0qxYc0P6NDlWB4gu7DqqA+9d78CbSc2gW7H
	9gDE7hznL4SEn0MBKJXJYkxJhKmYPQ1c6l/TCOhl1JsMsVcj3A/DvvnPRsypXMk0tNPre7
	YGc1jZndx9I+LT2l3D3Yw5K2USr1g5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776105587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/hrFqndwJtN2pq3357Wgsw7hOLsXaP6RS7BTWcmses=;
	b=O8O/sYs5HTL2hnpoKd/sAwdj5mWiy4tX9mFnqpKwIKgxpC2NT1gWZEEv09i8UoHL4NN3kG
	xfDvwP4QYZhDs3h3JZ8iPqJmH1HO8xLPS7+Zzbj+H2Pudedhqd3ciVKQteOQTofRZSDbE/
	mgpJRd2w9aW2RztFrmf+c/8/SceWOus=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEDQuqIW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 393256183B;
	Mon, 13 Apr 2026 18:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5133C2BCAF;
	Mon, 13 Apr 2026 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776105586;
	bh=RLos5eu/k4OkgzYUfoZ0rIuWLWwHtGR4/FZoPNAg1WQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AEDQuqIWbNe2wApXlo2hjS3KG2iI6BUI+d43CmYsPxHWaB0Xp8Q1CmWRyCuOn8AOR
	 W80aa/DJ0JML556anny4PaJf9/qzUrMUVKV9x0G1GtM/65FxhvZ0/Tbzegg01cq40G
	 Tt9HzrLP+eNfs6t5Z6lhSxABkcKSOAV1G7nUqN2Us5kpYLAonYwjinOGRledZE+tMI
	 bncp1C6Hpjq3PX0gSCkdiWcgJ1HKr+CKtiDQG6H3UhpmJCLRXy5NOGIPXNUVq2sxcY
	 eSp629TYMGMXrJJ9oEibCVRH3n47w9cuFeSL7xNReoqqr2qoGyLd7/tbatyAz2KaDd
	 3RJ8Gg4R8bbsA==
Message-ID: <d44ff75a-a1bd-4a28-8e8b-0b008d24d41b@kernel.org>
Date: Mon, 13 Apr 2026 20:39:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/49] mm/sparse: fix vmemmap page accounting for HVOed
 DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260405125240.2558577-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC78E1C0007
X-Stat-Signature: a338jwccntobrm79pbr8wqbhszh46x4n
X-HE-Tag: 1776105587-27980
X-HE-Meta: U2FsdGVkX1/wo9QrcnbcBrM6AZ6wBPyqbBDbwNPB4p2D+XNvZuzpRrVNx/1SP8Fye90A/ckbMN6RTgweOjSBG5iQTZV9shqKqhVg1Gzx3rwx8vJo+NtkHR5sF6bcK4W1lHzKqPp2c2rgsu8MRyhlp0T1aFgIGVkJ4Vsh0t7CVlH6PMzzKBPLbsA8xqZAhCZOzCRRyXdx0PQfx7HjxgsmOPShpcJ2VxwrOhkSnNPDGaJ5A2Hi7cb4ssre5Pd63aEHutdEmFtVxqXLK7Xg8t6PsWILkZq7O7sgR/4EoB5H96MjmdM9OpIdhhr8Ljy5XQhLWXKCI3D0QhZz3K3nWtXwKyMv44RfdrIQgfyo1fZuZr+Hhvkl8LkURvQAEAcg7jHM41ADJe3sX9M7+nxbtHmAPzcdH5iF+34h4wMFPIadTwQEzHxMQ9hIQ8nLmJTaaw00vTS1o8S0cFrzGBiaJO3Np/Obvi4k3123DzbvnUNp4Z3aVHN23zhaldeQ6toUa5ITWQ+XKYom71G8L7imGSi2XKxbeFC1Ry6/MJS+SRZ8VAicoHm6kQGOO4/k/U/jFSacGmznqD6q5QjNLSwt/s1n/Jf1oMPHNk85jLLM5+/qZeDc+EfCbSRKBPNYsLEhi/mphhEXk/SEi8wiB3SMWcqPa9RLBLo3U/K/cO1P4ANZdrunzv3JVNfFBK00Vy+a2haTPxNBGkZpCAutmbHV+wLzalzET0DX49+QPBPVgEuv5TzZiD1/7d3jeLS1kBnzw+acG8X4WflZZLD8r682vPIdAXQTtsLaaOs+vngDeUuzLscVbGBmJEdoJ00H3Veb3DFWrd/HfPmbtO7nJWEJclEeIPqgrRGbmi/y80mQZ3ugLQScZu6UO0HpwW1amDpkyi7TM77XcLJXtafL4j+BLrSDMgP1RrcTcqC8XH1Q8+xGzCtyDyM7M+ySHfR5rhVq9O+P1N7TWKtmjL8TJKYH5h5
 /jUaSd1I
 16ETcor8vdcP0bXIcgzUY/dJ31H6910mWM+D3gx98IXNoZNuO8V3yv5f5pLfMfzqQAWW/XWV33t3M6MoMmuP8Cs9Cj0tBvnwhY/J6EP1/5sr/usUJp+s4LEH4kvywly3UJYvZWpJO/hQM0yMvTAa9EmgGpi5GWPyIaGBKXh63+v8uBhACDSN1J8WJwG7ID8kkoSSIE1MtSFem/vsySDi4HbrxV4YDaqwIDYhEJ9BuOvxWCZKCugPQ6fo5uw1XVhHKMbrVzlrRGR7EwStp2tNU+ILuXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 14:51, Muchun Song wrote:
> When HVO is enabled for DAX, the vmemmap page accounting is wrong since
> it only accounts for non-HVO case.
> 
> Fix the accounting by introducing section_vmemmap_pages() that returns
> the exact number of vmemmap pages needed for the given pfn range.

I guess only the accounting in /proc/meminfo is messed up, correct?

> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")

Similarly, please send all fixes out separately.

> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/sparse-vmemmap.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 7aa9a97498eb..0ef96b1afbcc 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -724,6 +724,27 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
>  	return rc;
>  }
>  
> +static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +					   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	unsigned long pages_per_compound = 1L << order;
> +
> +	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
> +	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));

No new VM_BUG_ON. Ever. :)

VM_WARN_ON_ONCE() is your friend.

> +
> +	if (!vmemmap_can_optimize(altmap, pgmap))
> +		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +
> +	if (order < PFN_SECTION_SHIFT)
> +		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +
> +	if (IS_ALIGNED(pfn, pages_per_compound))
> +		return VMEMMAP_RESERVE_NR;
> +
> +	return 0;
> +}
> +
>  /*
>   * To deactivate a memory region, there are 3 cases to handle:
>   *
> @@ -775,11 +796,12 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  	 * section_activate() and pfn_valid() .
>  	 */
>  	if (!section_is_early) {
> -		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));

That's nice to be factored out in any case.

-- 
Cheers,

David

