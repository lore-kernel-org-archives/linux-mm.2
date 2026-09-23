Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4382EC9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620126B0095; Wed, 23 Sep 2026 08:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F83D6B0096; Wed, 23 Sep 2026 08:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EB66B0098; Wed, 23 Sep 2026 08:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30DDD6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:24:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5D7C80798
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:24:15 +0000 (UTC)
X-FDA: 85244944470.14.917C7BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6DBB40003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:24:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcO6poHv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790166254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz7wnacojcCCtGK9ldyNPikquj5YfjQzpeki9G2X8DI=;
	b=wFn73TB4mbYcs7EWYg/8AGMhtQrijScYT262S6PgnR0ecOwihbjn8IklfZFN7f7tps3+lN
	m0/a053OoDMwBlzZ9wvJE74/8F1kBN27E9a/SE7CErpzdEN5rp3FHDprSLscb1cN+uHEvg
	lzmVE4OdapxS6jcukVfIo8DSRnGNjU8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcO6poHv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790166254;
	b=dEdRBBlciB/qSyafo+PelSV+pzucJdGmUc7BaxYwcj7i7GS6DqZC5zsa/FHRFnS7R6cSZw
	34/+dyPHNrVsWAU2InPfSbHgaaFJByzhDESzaXQ/Ma76uyOIF2VyMnhU3dNxbIB/b1RQYk
	ptUSoQslNPt4hPoefdNkbMtCGLDc7us=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06907400AE;
	Wed, 23 Sep 2026 12:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F01F00893;
	Wed, 23 Sep 2026 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790166252;
	bh=Fz7wnacojcCCtGK9ldyNPikquj5YfjQzpeki9G2X8DI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HcO6poHvX+9qlNd1qxKmYnGXiuf9GFggnkCljgozbVFRxRyTBLJG0U7eTh5rZxKze
	 aVNJliJp+v7IBHUnr9hS+uzT7jnxsG7FVQcxPdoqH/67j71dEZK5oNsFx5k7U7secu
	 k+2nWm9wFzKZyzJHySiZXiEUpKcbB+Dy4YVtvbJVoQQUmUDrhtZsHng+pTepwEkdRR
	 m2q4EKP3fXaHsYZ1I+wKuAwAzAPLk9En8BV+BJ2JwEeUPrcqn6YLB/ea6e2sE0cif6
	 a0QPuavKg4YY6UuunaYulXXyaKh6k23jJMSaiR6UGtOXbNKdKIz8dRPuEbUgmwArME
	 Gasc4NMMkitrQ==
Message-ID: <2add40dc-6541-41e3-8233-521cce7e0d33@kernel.org>
Date: Wed, 23 Sep 2026 14:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/12] mm/collapse: state what a collapse may do in the
 policy
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
 <20260916093145.4022188-6-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260916093145.4022188-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6DBB40003
X-Stat-Signature: k51pmoua5ssqpwp4swp1roqo8yjnfauf
X-Rspam-User: 
X-HE-Tag: 1790166253-198127
X-HE-Meta: U2FsdGVkX18QByccPPP9PXxntry/0Owl3Ybzhz3HFk6vckV4mpr+foEHJp+18r6JmTX4BM7f4CrBLldeLjQn+Gqo1+WdIScbqq3r/ijfS9O4StVLGPS8DButtkXA69E070G62Fs2bB36eLHzrNz1i1wXJU5/vLmt7LkeTUo4en3G6lnbWeXyMNDUEzhESYDcUhHhgYut+BNx/LPjrnk97wmnqwjYMGDygPN1IqgHp8n1sdKhwu/jF/IZMmezmxUMLgbbE6fyHuQUXdlY6EG5wUspXQLqsEaWSEqW/joEKC9zUPQl9cPmcvyj+e8MzWmUGtmTDCMUxTwkFCL6lv2ZntLusmsK41fbVYhNDCvaMcriwT+xOasE0bmuXM+hnvtppQ87hY4uMDL1QX22yiMGbi84Yk44gVHjdIVWWeXfEZWiVRtXw6ElN4hGK4NqqbVwDa07d8LIbRzItsZntwYkRhyW/blOXEKCaTKWdawd4SRgAsArKTLWlQ9U3FwZr69BoF5kLf9pYMVfez0UEbWEqK2RbktfS8iTgNd1h3NpfSpAj/bwuRJU3EFmkTK3iMhBjLcTPPku+zxKP7W70Vf60G01TmttWumUd05Hjnqwk/irgB8HMpjZ/MzrJkOGBpJLZtDi4RGKlND+2F3ks4EuD1JbeOMeLYHUkb4kfHYZ9y+qnbtZc5RKTmFajTsZQWsN7fsjpGEqiPUTMrEK+ym0nF/JZ2vY6d4w+gsQA/AC+jJMnJGMJyJiuHw3rNfuDEAfkYTfeoBisn/r2Wcfqk3rq/h8Wu/7eKGQWLxp8WILeb+8Z+cIJXgNU79VPO5XMKzmmbKwDmuk/BKNqGQR7nriqgRb3rsPjVrmDbJTraqPoXGD4ubxJBHhDeikWKbVIRqcvrvS+wg0W6KUaNYbz+SI0SoaZwYe1CHSpWKIVOUuDORgOwBdg8xilc3sA2TDM3WONZpXdyS3ioYozIp9Xzw
 dH7AwACQ
 HTwMJ74MuRfNsIKunyjdKVKzgUuDGTQnHBml/Kys6yYfA2Mpq8SG0neBVyiqhvgGLfhFQuSq+7vqRDO9rZC4ofpKA5Xor8GWiCiroXxqWN053iDv3UQs0z/a8nadrEknpA82wkInmtwqFFbSZCfBWw0KOzM/G4NwXGqkDYHhvKIquq/ZgwU6Tmuce+aB70jJzDKjYy0TCv3Jo4f21rAuT3ZtDL2yFcb+ArikXQ5UQGddvH9xUU6EXYN3Z5RP7N4QK/Iy0ZPNVCJ4tdTJwIVFt1M402l12Sewsv0j1vzrfGeE/LL9/RRD+KYAWrEId49ODac3DtMKN+d4gZyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
> 
>  - which VMAs are eligible, and how hard to try for a folio;
>  - how many empty, swapped-out or shared PTEs a window may contain, and
>    whether a sub-PMD window is held to a stricter rule than a PMD;
>  - whether a range has to look used, and whether a MADV_FREE'd page is
>    left alone;
>  - whether the PMD is mapped as part of the request, and whether dirty
>    pages are worth writing back and retrying.
> 
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.

Agreed. Removing plenty of these is_khugepaged checks is nice.

> 
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
> 
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and the
> defrag setting behind the allocation mask are sampled once per pass rather
> than on every table.  A table scanned early in a pass and one scanned late
> are then treated alike.

Fair.

> 
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereferences
> cc unconditionally, so the check was already dead.

Worth putting this into a separate patch? Likely not.

> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  31 ++++++++++++-
>  mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
>  2 files changed, 93 insertions(+), 52 deletions(-)
> 
> diff --git a/mm/collapse.h b/mm/collapse.h
> index b115034d9018..7044dc71c7c2 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -45,8 +45,37 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
>  
> +/* What a collapse is allowed to do, decided by the caller that asks for it */
> +struct collapse_policy {
> +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +
> +	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
> +	bool strict_sub_pmd;

Reading this variable name without the documentation I have no idea what it
means. It looks like the wrong abstraction.

Maybe you instead want to split max_ptes_swap and shared to a PMD and non-PMD case?

I am also confused why you use "strict_sub_pmd" in the collapse_max_ptes_none()
handler below? Something seems odd, as it doesn't amtch the description here.

> +
> +	/* Leave clean lazyfree folios to reclaim rather than collapse them */
> +	bool skip_lazyfree;
> +
> +	/* Refuse a range with no sign of use */
> +	bool require_referenced;
> +
> +	/* Map the PMD over a file collapse instead of leaving it to a fault */
> +	bool install_pmd;

Confusing.

If some of these policies are anon-/ file-specific, the name should indicate
that, so there is less head scratching.

> +
> +	/* Write dirty pages back and retry once instead of refusing them */
> +	bool writeback_dirty;
> +
> +	/* How hard to try for a destination folio */
> +	gfp_t gfp;
> +
> +	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
> +	enum tva_type tva_type;
> +};
> +
>  struct collapse_control {
> -	bool is_khugepaged;
> +	struct collapse_policy policy;
>  
>  	/* Num pages scanned per node */
>  	u32 node_load[MAX_NUMNODES];
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8889f75cf45f..cb08789b2d38 100644
> --- a/mm/khugepaged.c


[...]

>  
> +/* khugepaged collapses on its own initiative, so it obeys its own settings */
> +static void collapse_policy_khugepaged(struct collapse_policy *p)
> +{
> +	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
> +	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
> +	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
> +	p->strict_sub_pmd = true;
> +	p->skip_lazyfree = true;
> +	p->require_referenced = true;
> +	p->install_pmd = false;
> +	p->writeback_dirty = false;
> +	p->gfp = alloc_hugepage_khugepaged_gfpmask();
> +	p->tva_type = TVA_KHUGEPAGED;
> +}
> +
> +/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
> +static void collapse_policy_forced(struct collapse_policy *p)

Why are we not calling this collapse_policy_madvise to match its description here?


[...]

> @@ -2943,6 +2952,9 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  
>  	lru_add_drain_all();
>  
> +	/* One policy for the whole pass, so every table is treated the same */

just drop that comment.



-- 
Cheers,

David

