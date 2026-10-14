Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411ABCC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6546B0088; Wed, 14 Oct 2026 02:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0615C6B008A; Wed, 14 Oct 2026 02:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8206B008C; Wed, 14 Oct 2026 02:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C54A66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:02:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4959EA0266
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:02:51 +0000 (UTC)
X-FDA: 85320188142.01.1AD2F1E
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C71F16000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:02:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=reh3EPjm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791957769;
	b=riS4vO6axNPy9hN5ugpx9mnzqWZ7O3ntmHLqtfyruoqXr7IQZvoHxiWOdfMGYIu0AJvO0M
	ZTgtiyTgUa3qEGQykQJH/SGTyjeN1wdDRVrUXlHPmQZbKa+1qqwvCp69BHaFFsWe3waYNU
	/nT3deipyFBFFJ6V/we8EPJ4SLAYwc0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=reh3EPjm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791957769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BIscm2cTTBNlc9P4KV7eUnjnf4F0Y6UQu2TU1+hhSQ=;
	b=1kqNaz18avCrlYB6FxS3yR+4fe64WQdQW9MyD5je+poN/CTjsOMlbwAevIJFEBsHhBrpJS
	Qt+d1cxEcXlAe1mcSdy+TE9XRzd+vst4Gg/MCECCGE4hTjlS/iNoSHBJxhvd/oKUUug4iQ
	Fyp85rj2EKYHypl2gHcctCJvSbAuS/0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791957765; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9BIscm2cTTBNlc9P4KV7eUnjnf4F0Y6UQu2TU1+hhSQ=;
	b=reh3EPjmmP0ATGMx3tdU85PVBPkJA2d9P5dQXJuumoYd0q/MPh+0P7KwswuD3Ik6yrCPdw2zs8sxRDjwrcE7zPbJ7jDZlpb27EWsOSyTxI66EZwrd3P+3sUu4/0D98r8TWy/dreT17pawSvrgaLbMOpYWuIyvHe+8RDo9wS7HKw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XCo3AyK_1791957763;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCo3AyK_1791957763 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 14:02:44 +0800
Message-ID: <5848db18-9de3-437b-9967-162ced4f8cb9@linux.alibaba.com>
Date: Wed, 14 Oct 2026 14:02:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Chuanhua Han <hanchuanhua@oppo.com>, Kiryl Shutsemau <kas@kernel.org>,
 Kyle Zeng <kylebot@openai.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m3ae1t5gag58mdu68iu85su3sbcjqajg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1C71F16000A
X-HE-Tag: 1791957767-43380
X-HE-Meta: U2FsdGVkX19v3vzlMFxbt+ufxzWnUnokHL8r9QOVMvqmCiArqIVLgTp9euexH88nVqhw3ch50jnB0GO3MkYXSRnOKZ4Mxatl///WdbWVjuowq8MzdfOR2PIdfaHRezdabYNIrYbPek0w9tE1yYZKVnln3pm7IJBktRU6e39VHChnS02ocZG25+9IsgvERgf6DGz07xK6xf+YS8FqRRE7XMUFtu4xD5Eb78YXO7OusMBz1mbOGidZ/DF2qjIA+KzoAoAQGnI2+Y9dfuk5CZh7nzFGqgZzLqRsYWjy3RmeIfe0CcMgVyE6s4/L8JqNmRwaVTSDDeWrNX4OVLsTcL0qA0sGAauAy4Dk+jlL7kTWzeSNMUU8aUx5GJEB3knOTLLFr+whj8kDdCMRBaJSnb48gO7p8/oW3EREQGQrrXJCAisLj/CD4uVRI0YcV5OCrDoAhkZGldH7HM/yXG88H9YUlhAxlp3bACLOIFWMU3UMTnIgsHWgj/iOMy9akacH0ggwnamOB/ynveTBDz6mAxROaShGdKJE6Ml+XnRvPKszmBrQpnpVnZgsWWadzN8OQTBTasc8EIvTXkZHA0hQGkj5VBd+xS2lQDYCyMn/+CRnZkjEjFn3cRLucC60KPACGp437U/77hMeRFI/fhtNHDpAOukvvcCts1twmfFc+YiZYKNOqM5+/uKDoYmwxXLvgb2X/5/cXjhGdL+qAcZQXDhRC48maNIuGKcehwM13eZ87lqp08qZPzDguIrpsA8lNTAvTNYnj0lVsBEhFRzo3NTAeRKEWYRRM8g8xmCp6KbKaGJHxJYtbpL46R2jfS/djyMIlOwiXnzeOnkbxffSY6gDL+VP1bz6KArO5OVFsRljjC3O6YOc9YRMPOlzGFig4Q1yZWkGjDJ+Mtr3y2zdl+7Fcag+FTFAWjVIXlZ8MEVWsWzS1zuX00MmbneeHMgshVshIHQZUIg29lIkAqmXJLp
 16hTLgMI
 YgM06/ixUHEKA8y1EpZP5gm67JaXT2r3i6jo9Yh7vs3Q8AxHby9gJbk6axwNm/f5jVkFSRhizPwNuBbFJIZYQxQJHfockJzzPQlNOTCvFYnDyQCR2VNR2rrC9xVdIHmZQnAliHxaqivM4UP+uaH6HssPzAE27dY869e1ia+ntweHi8DibFQRo0r9SZfzDaqarzaemoUCcAQqNfyqLehnrxZlwEocXfXa86q9BG7/PZ3EFGFrogRDrX4SfEvjcRS8bw/5E5HdtEQZDHmcMethEX/L5W++P7/GhB3zIwNPHUjBZJvTo8e7GO+anV5TT4gLDxJjWfP7PGglVgPpgwsja+aZnj6CDpsnOPAOsDme9VJS9wDLREjEFgOouYNjY04R3TNJaILoueduhc55Pi07joNk5wKO33WVbxLFHl8DJg0X9ljw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/13/26 8:30 PM, David Hildenbrand (Arm) wrote:
> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
> generating an address wraparound, crashing the kernel. All that's required
> is to map a tail page of a large folio close enough to the start/end of
> the address space to e.g., make
> 
> 	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
> 
> to wrap around.
> 
> Let's fix it by providing a better helper, folio_pte_scan_range(), that
> takes care of staying within VMA and page table boundaries while
> handling possible wraparounds.
> 
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks for the fix.

>   mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
>   1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 1f5d5f7d39cd2..a3823010aa981 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>   	} while (--nr_pages);
>   }
>   
> +/*
> + * Get the address range in which a folio might be mapped, assuming its pages
> + * are mapped consecutively and the folio page at the given idx is mapped at
> + * the given address.
> + */
> +static void folio_pte_scan_range(const struct folio *folio,
> +		const struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long idx, unsigned long *start, unsigned long *end)
> +{
> +	/* Stay within the page table and VMA boundaries. */
> +	const unsigned long pmd_start = addr & PMD_MASK;
> +	const unsigned long pmd_end = pmd_start + PMD_SIZE;
> +	const unsigned long lower = max(pmd_start, vma->vm_start);
> +	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;

I also agree with Barry and Lorenzo's suggestion to use the more 
readable pmd_addr_end() helper. With Lorenzo's comments addressed, feel 
free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

