Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF002C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FF86B0092; Wed, 23 Sep 2026 09:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F88A6B0093; Wed, 23 Sep 2026 09:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E426B0095; Wed, 23 Sep 2026 09:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0E26B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:19:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6B01A082F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:19:47 +0000 (UTC)
X-FDA: 85245084414.09.569B4AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D23320004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:19:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i1/H3BIw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790169586;
	b=IpWtmWiJxuA2b7EK7WzIeky0B/Y/OzJptJxYG3T2f8fV2myXOnth7bQzPfHVP+Tpy+piGR
	VyY3FPbKs+REtl6S6B3zKHxVvg+wb3bD6iMk/mlwIIDo6B8tCsr391xMQn8KyR6cOIHL4G
	NvXEjxLxpIIW9dadttIpRYaLzw0nChk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i1/H3BIw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790169586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yeMMNYYq0MjqSUEKuIfnViLoDuHUncMTKA/2pebiVA=;
	b=qfPu3U4ZeOX+DAH+gmdS0xVTei7TtblvuW0SG/QUJtVQsfIgBWV5e3GRpIvdx2pWrkZqCH
	QNynvKCJEHJ2tXoLS6meWs66406/UKFxZtMgMjAqWCzArDkL3cAQNAAgNzlxDUkR66EcKk
	Fc6o/E0VYCr51+r1Jet8Feu3sM+nYE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCCC9602CB;
	Wed, 23 Sep 2026 13:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691C01F000FF;
	Wed, 23 Sep 2026 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169584;
	bh=1yeMMNYYq0MjqSUEKuIfnViLoDuHUncMTKA/2pebiVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i1/H3BIwXC/3FqxM7OhmXImiWOFFXzO19DqjayzdfQFmlHNTwKnf8kEd4Ouqi18fB
	 sQitBw2loeZ18GwUJs7owPN4iXTEXiDzc2I9ck5KYzrNt6VQ+cK/COu3qu+1+fVnMR
	 mgMeReDp73bHZwF8HeiycWMDG44daShEsWqUyfx98HxGZFIcb6ptUVcBPPVfRXQ2mL
	 xyFDkkiIvutmfJeR5AEQG/ZWhqP4kC8weztIKGKg5XnVO6J7Mwnmnpl4ONvhAfF9th
	 zJf/X4dslfJzXVHvTjR1WSlX6y/OpSVHCP6pW/8rRz+/PUByPnUwffhruLZo3qCoQx
	 NJOL7TqR2mNig==
Message-ID: <b5e5e4a2-db9e-4d8e-9f9b-954f3aa3a3c4@kernel.org>
Date: Wed, 23 Sep 2026 15:19:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/12] mm/collapse: work out the orders a VMA allows
 once per VMA
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-11-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-11-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: hjru1szyzropwtei5t4xt6je4imb4ggm
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D23320004
X-HE-Tag: 1790169586-163344
X-HE-Meta: U2FsdGVkX19q7PmiI4jehSJPGqP//KjFV69T4oTs97fs2kOJcYxawbuTEulgETSsEAMj9FW6KuUY374uLIqS/4FcOQ1/hhcIa9dTV5NWs7VXVZbEdyEF0oEXHjg+rk9aJO4xAGGncEcpHV/cqcShHWXD+N/bnnmdL6k4cJzzEPqR85UcXIT+TbAvS1s01I57Lvk7h5WO7zYukheRH98lqK53uLtpvg8/zLepJRA4a+aKH/zglUuqhRn3QG7hjxHNnaLQHQy+oGzlxj5x1lPf11irEo+cYrhaqgcf02kOoXs20nxZ6k7IUTxhBogq7BHP7nZxOLfLllbOknyFtivNGDsqp72VrhqoaejErReEsO5WcLLlubDavPCihZHUAbSL40ZKKe8Oq/omt0Essk4Uyk8obEgumwmSZ5/n5VzRnLxPKpdD+69+N0WMjOgYJoCOCwE4vP2mWfBYZ35RBl1MVEad3krh8KPdxodEEThQ0bxbNWqnPtynGh56qbhn5gQGRbzNi/2lYoYLT03HdAf+vd9E7UTcjGaKZAwvzEqWfWBzgnoTXnamLceePZBBQD9Xi17fS8baOH9X0tIyXzuYpjuLWhRjuNFCTdXttV69nV1XC4sXJK7Q/zqmAQsMu4LLLcCc4PZ5e4x4C6zbIJ/od2rYM6Q27J9mv2nNagodK5NntzYfQo5PbR5lCf9RiL+uknhiObVvkxu1msRgkd5TKIhEDRKKWSwYIuq4SBLbHl5vGqNtWBehx6P6pBkAFxtPOzv21j7bbB+02UTKO640UyD4L4mWetoQCWpnspB0oqT+oLgyCmdOSF3841zwij8Z5NSP8cZV05FthQXvCoi3QO5SRL9TCE/KCYjN+KMsWPQF/9G191Bo4uE8kcXJU+5t4Zg3PFSoz737n15g89cvuAhpd5F13wvknGhgID9Nu9Tt9pI0AYtZlUlh0qkcSrH5Gj9nogztyYsVTqox1PX
 Uvu7NyqS
 iRTG1zUUpe6E3csoDHRI1roHWCN3V6ZpUiQFi8vLxOwHXOAsVyR/z7KuxtSgs1UVesEp29ExaibHyFEnhHtMIkjSU8aJa9Kgv48MtFQZxpBHUxVPL/riFKL38C1y5TXNNqtAMZjDtXFJOigde940V0WTyGT0SzSDF9KscsMzVAaYMx5F3PAlHE/pvk3RlLP3WgxidGXV5L0sJCRaidUxC15lNLb1PXjuM2l8TepcP1n3jjsVEPiZ/1XcMEKPvCnW/P+UpBOmO+X7XWzvbUyHg4SPWyp2SFtFHlvWzvXBo7bjHQhRvtOiZ0gHBeaMsBjfzlzK6r8pkQh+SkTcjvTIcPdqhPPrLk/VUEUxcLCDhCqFU6Bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The scan asked collapse_possible_orders() for every PTE table, for an
> answer that is a property of the VMA.  Both callers walk a VMA a table at
> a time, so let them work it out once and pass the mask in.  It is only
> good while the lock that produced it is held, so madvise_collapse() takes
> it again after every collapse.
> 
> The mask is then sampled once per VMA rather than once per table.  A thp
> enabled knob written during a walk takes effect one VMA later, and cannot
> widen a collapse: hugepage_vma_revalidate() tests the order again under
> the lock the collapse retakes.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9e6b2af6519e..12cb67d8df32 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1549,12 +1549,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
>  }
>  

[...]

> +		/* One mask for the whole VMA */
> +		orders = collapse_possible_orders(vma, vma->vm_flags,
> +						  cc->policy.tva_type);

cc->policy.tva_type is always sattic here, no?

> +		if (!orders) {
>  			cc->progress++;
>  			continue;
>  		}
> @@ -2922,7 +2922,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>  
> -			*result = collapse_scan_pmd(vma, addr, cc);
> +			*result = collapse_scan_pmd(vma, addr, cc, orders);
>  			/* Nothing to do here, and the lock is still ours */
>  			if (*result != SCAN_SUCCEED &&
>  			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
> @@ -3207,14 +3207,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  {
>  	struct collapse_control *cc;
>  	struct mm_struct *mm = vma->vm_mm;
> -	unsigned long hstart, hend, addr;
> +	unsigned long hstart, hend, addr, orders;
>  	enum scan_result last_fail = SCAN_FAIL;
>  	int thps = 0;
>  
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>  
> -	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
> +	orders = collapse_possible_orders(vma, vma->vm_flags,
> +					  TVA_FORCED_COLLAPSE);
> +	if (!orders)
>  		return -EINVAL;
>  
>  	hstart = ALIGN(start, HPAGE_PMD_SIZE);
> @@ -3252,9 +3254,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			}
>  			vma = found;
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> +			orders = collapse_possible_orders(vma, vma->vm_flags,
> +							  cc->policy.tva_type);


That's always TVA_FORCED_COLLAPSE, no?

It's a shame we cannot get rid of cc->policy.tva_type because we need it for
hugepage_vma_revalidate to calculate orders. Which sucks a bit.


-- 
Cheers,

David

