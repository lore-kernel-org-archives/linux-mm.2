Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D22BC982C5
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1BD6B0093; Tue, 15 Sep 2026 11:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5935E6B0096; Tue, 15 Sep 2026 11:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481A06B009B; Tue, 15 Sep 2026 11:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16A886B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1F2CA56DF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:28 +0000 (UTC)
X-FDA: 85216340496.01.62B9CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCD75100009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z1EaER/S";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FQyRlZ0UvZmjUJGZrgdx1MulAISXCuq0/0m7KgjD6U=;
	b=qUUtrTCCC2CWrQass68dCOXtLjqMqmVW5ie2fzsj18h512Ctd7006zhbLoWIfumgmcvahk
	bIZZIo2PFrXJ6s0x/yVdXMLd7QhGOZUQdx7yT+AIvpluwWW2q9u/ETSn1GLNvNjiQzdwtv
	IQlxkUHaJBmpIs0GFfxVSYsld/PLvr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485206;
	b=RXZa3zY8ocdPuaa096FR+fAoFEv8dHt837fxOHdZ/S/yRd4Vww/cVHQEQLWQ0W687sVwno
	12x3ya4TuF1vD6BnBhrjMQw+yawkD4oVrYFhv3IjTiwTlrrKRm3ERm2P8CFCDmqAhHfHQ/
	wA+wwl+oqzcZZyHWrN5KaP6964zZCto=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z1EaER/S";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6867C600C8;
	Tue, 15 Sep 2026 15:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26AB1F000FF;
	Tue, 15 Sep 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789485206;
	bh=6FQyRlZ0UvZmjUJGZrgdx1MulAISXCuq0/0m7KgjD6U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z1EaER/SWYCCHFBk3GNhoS4X4mE45Xgbhpb//M/IHlMZzn6dbX5KwvJVMRYoYNqY3
	 NjbfB/V8oucZ6nLvPFoHr5orfY0O8MHhV7sgkpW+OhnWHp6hJVjgHtKxRau9WGAGj/
	 zFcpuZa10eEL1h1lZqvtFqxcqvEuWZsA1OX8Zw8tQ+85CczzVbE412Xw3b3IfwuP/k
	 PkulbebjUPE4mbZY9wLk1Jh2NuPv57sQg4KzyLt0O/LMN+YV9pUG6p1kOPYychJGBh
	 35TBtCFealrESuuWcINsCD54o1giEXLqJXysk9cw+IKnDDaC9dwcp5pdSRgQWuX3wT
	 SjePHgUNzM9Hw==
Message-ID: <83a1287b-8589-4408-96f4-4f78dfca1bc9@kernel.org>
Date: Tue, 15 Sep 2026 17:13:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org,
 surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260913051942.40889-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913051942.40889-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: egoir49ffyxcgfwhxnne9uczxspu7jga
X-Rspamd-Queue-Id: DCD75100009
X-HE-Tag: 1789485206-234269
X-HE-Meta: U2FsdGVkX19hl1ERPpnpPm6QysqgGmgcES4ic6MEej+KQENHc6Nbceb0Q1fcz2N/3r0h4mH2qTf2WxAlzvDZSpo/6m7rVPvS/A8mRv54Vr81FkSu+SKG0Kl6bTaKuGmrqp5qQMaox/U2sSRg6lzt9285Zwn/5eDE9wOpJ9HJOv7DdZL2EJcmXFeRnudwgWob0rYEcTQ1x3Sg0/xClIJAw0wwIJNC6FuFi+Vxsbv6+5FX+JraQkUm6wuj1bTvvQpOiRDgltkJtYD69HgqTVR1QJGmIXRTHeOiwFrScyXe9shIP6H3/GnacQC6apisKrziHS51/YWdzMUpTK6gWrMpDWoE/dZyEj4/eFL8m+NHFvN2cTIiI4xtsF9XpDjDfQb/1J/2VsfTYfmrROTexehNnNqt7yoeTD7EGNo4mviFLQBycdaak6GUPiD/+qh6meUrkcT7nscaUhylnu4/gKOpqa7LStCO2YIcMe8yZILv/Y2OI7B3bOhUObUFlXwXA87FRHBF+SI3mph/G0rABZ9yUqgfzu8r/FeOtts3FGmICROtywgCArwLSGSggQ9Cw4g0A4kRyVZ0Bo0LkhEPaa/diY5Y8kdEsgBI6tagYDGoJ7xFUAupsicZGK4cDCKuX6JM8F2o/xpTD3MkSIiGW3bM46th7Li/o4Fs9VGJ06LbUaSHLcCyWtnhLKh4NgcMFvivOeVaPnsMtDZgCyBQbT+UTfG7ShVWlvflfmhXp4FHrioX2HbQXUG5QhPgkPmrKVRIA65MQsr5FsuoeiH9bGpJwKm3MLS/0uUxbbldglES5OQhg5BMsUKybxQ08A7pwhrU/v34wJcx9fSJIqF5Efk5C234UmoKMYyRHBWPeM3LxrdTd6+cb1DDZzBLJyXoCeEkIUfOjGa4bdXfR0R2ggdzbMOjwDHHcO/M1FWz5lDbldvamZdUKMhon/H2xFDt512hisl+HOBjC3ILZVeylBW
 ApCBiAFE
 A+t+XZbieH31wyHTd5XGBS2zJuUUNXBaN1Aj5YNxRuBpA9B+hm+8ap6tl1nTVPl0iT6vK7QTHiGlOGT24q90wE3gm6pePZq1O6zJOCtioGhgtWLRxtPfNJzEjK/Cx6mkOJxlfyWPgDOFYhD2Dwh3naIFRiTRAY4RE9WgyXd4NklXntxqUSfpPMlc84pjrW0k3hj9pdK5dubhV1121azO/v6yVPs5MxmL06q16NI2iGgFYz5TQsI1sxyFOkH5oQdJNu6aivm+cdo/coK2ParELNFzqlRWI7X/WojD/k8xh6zNgwAKHhcreYaU2/NMcsDT6JIKEnaZBezvHOLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 07:19, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
> PMD has a deposited PTE page table. That also accepts raw PFN mappings
> of huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page
> table on x86.
> 
> Zapping such a mapping would call pgtable_trans_huge_withdraw() without
> a corresponding deposit. With pmd_huge_pte(mm, pmd) == NULL, that causes
> a NULL pointer dereference.
> 
> Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
> page tables are allocated, deposited and moved.
> 
> - For anonymous page faults that install a huge zero PMD,
>   do_huge_pmd_anonymous_page() allocates a PTE page table and
>   set_huge_zero_folio() deposits it before installing the PMD.
> 
> - On fork, copy_huge_pmd() allocates and deposits a PTE page table when
>   copying a huge zero PMD into an anonymous VMA.
> 
> - Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
>   vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
>   which deposits a PTE page table only when arch_needs_pgtable_deposit()
>   requires it.
> 
> - Moving an anonymous huge PMD preserves its deposited PTE page table.
>   move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
>   both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
>   deposit as well.
> 
> Keep arch_needs_pgtable_deposit() first so architectures that require a
> deposited PTE page table still return true regardless of the VMA type.
> 
> Commit d80a9cb1a64a ("mm/huge_memory: add and use
> normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
> in zap_huge_pmd(). That check skipped the huge zero PMD deposit test for
> non-DAX VM_PFNMAP and VM_MIXEDMAP mappings. Removing it exposed these
> mappings to the incorrect !vma_is_dax() test.
> 
> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6895b38e4704..0ed997a97416 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2529,11 +2529,11 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
>  		return true;
>  
>  	/*
> -	 * Huge zero always deposited except for DAX which handles itself, see
> -	 * set_huge_zero_folio().
> +	 * Huge zero PMDs have a deposited page table only for anonymous VMAs,
> +	 * see set_huge_zero_folio().
>  	 */
>  	if (is_huge_zero_pmd(pmdval))
> -		return !vma_is_dax(vma);
> +		return vma_is_anonymous(vma);
>  
>  	/*
>  	 * Otherwise, only anonymous folios are deposited, see


Ok, it's really only DAX and anonymous VMAs that use the huge zero folio. Other
(module) code would have a hard time using it, as mm_get_huge_zero_folio() is
not exported to modules.

DAX uses dax_pmd_load_hole()->vmf_insert_folio_pmd()->insert_pmd() where we
deposit a page table only if arch_needs_pgtable_deposit().


So I think the rule is simply:

arch_needs_pgtable_deposit() -> always deposited
vma_is_anonymous() -> always deposited

?

The trick is that we don't have anon THPs in non-anon VMAs.

So could this be simplified further or am I missing something?

-- 
Cheers,

David

