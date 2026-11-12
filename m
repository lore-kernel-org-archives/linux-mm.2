Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F91660A2610
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PWFGoF5c
Received: by kanga.kvack.org (Postfix)
	id 8E3556B00EF; Thu, 12 Nov 2026 02:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D2C6B05B0; Thu, 12 Nov 2026 02:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735246B05B1; Thu, 12 Nov 2026 02:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC346B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:15:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7C061A052A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:15:50 +0000 (UTC)
X-FDA: 85425607260.06.592C874
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3CCFF1C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:15:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PWFGoF5c;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794467748;
	b=0e6ZGVlUe5qq+uhUU6bUWnq6eFneWRPKW2auT52Zj+PvZMTIASR8WxVc2VUKe6m1TAuScw
	Z2ycO7x2R2o18yRlpMngWZEwfH+r0Q3o0VBGOHUCdYZVP5DGujsx8MaqILal2f567gkduO
	N/T/xS8G9jDu7/DtZq2uvKiZ3tDIw8g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PWFGoF5c;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794467748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r9XXFTO8ZQmRlSOe0BepTMvXqZOcL+GZ1GXT5k3Ep8=;
	b=PeYDvrxxyMmW4aOG7qMz3lb0RJHY1PM6l21HBaXI6fOsePM+RKx/9R47qzsVX3EXpOPnIe
	FDV/5kz6+wdqHL5gdhm54mnB9HmYTujYbrIKiYbJmGOrfchYLSFbCP5n3DUkY9VUQ7KBMS
	CMje+k50PFKuLyPrH12mGGtMg6FQO0A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794467742; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4r9XXFTO8ZQmRlSOe0BepTMvXqZOcL+GZ1GXT5k3Ep8=;
	b=PWFGoF5cnjqGeA7lczyyZ5NPyzyeyZuU8Bh1KwEdFsfvos1tLTR3rwhHyI2UAYl+zcT5OwG0KZP2vxuygprSTrBMnZQSHeTjQY/+l+wEGXMq33ZlOXey3bUPyvoVB9rUidzgyUnf0TNjlsamEOFTL08sXdvUi0FeX9uRv7ZtloA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XEbBYxb_1794467739;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbBYxb_1794467739 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 15:15:40 +0800
Message-ID: <df38cd19-9554-4183-984c-70287e821de8@linux.alibaba.com>
Date: Thu, 12 Nov 2026 15:15:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Barry Song <baohua@kernel.org>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
 <20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zf43sd14es68rjzyq8qibpycxs739d5d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CCFF1C0004
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794467745-497951
X-HE-Meta: U2FsdGVkX19yrz2Zaal9xKNKRJV2hJTn7iT/SUPXpS49uc2uOJxHzdf4dPkDe7Ea3ValGyh7vIm7ZLcYrFvX5jZ6L2SRi1lz+1Ax//NSoRpJzikXzfjBDiHYK3afrtsXnBk4JJ6GPFUlDUgZLEpDBFMuhMfcXydFv483L/YzZnplfN1ERmn3CKR4WNbvzXkS95xqsGVzB8dd2cg7GweuIWMejuc7kQotjOUZXWDmyL4LAvmEv6EK/NbcRi/satT5p3XT9j6Uicwt6XeWysQT2a08MnXruqHdp9wqiudxVd/GD2TwQf6YX/yxrpX2KN9bVLnx2VD3uyxh58CH4sTHa5gumD0wZwFjRSg54aLmmhK5bXzb/qgA1uPYRyuqBLY4c28h8z3wQDK8R9ElShbq+oyIIGhJ4gmdbVdP10xEaOAoZOYOgXvvBAOlXi7Xhdv5OSsVbykk0LeVawhgD0hZnXLOt1Zf3Qr889FMtwkEfh2yqEVJuIPq848c3fbQepfC2wAX0LxOk/WhMzxjUf6WzgOz3nk7CEKarOD2qnGBbTKzcbDJ8DMCcMwkVgAlLkCZ1XybcxjgeXWnvS78liryCKInTUONtLSXEb8rmZHkDPOxWp5V35plG08WAb7im7Bryu2wONTf1Vn8htpvXbMkJq4pSsWdIAmF5XuirsWREFX48gEzYQxiBYOmSzfjG6CebRHSaQk/l8+z4/YyxuJaF3vAzFCIdgIUEyCDx+ZbmgiP+wiuhG2RsV1qDIiHNby3doYJo8uusRuqsfJolmKo1teTPI8Tu434J/OYecWZ5bc5kEcLn2Jso4NIAGXI9iRRkrHSpj0yuJigkvYs+WPa1ou8hPeNjjXzLE8hJtxe3NDppg0d3AgV8gK1P4t1OjC3yI0lsiHN+vYrFoBceGaIUl9eCwACAJr5SKbiHH9PImjfe6lisV7CSABxj+/DMQ9sE19VvKg/dM0w1EP0Lij
 FfVPlfJs
 kbpZUeWdC91n6TMF1ztOTs6UpGaBqeyXEcNHoHuAt2inAvbhQyHg9Gg8L8Znk411hFS2MUpKH9QOUDJw/Oskgkr2GLcKs4hoW2zPsIGohDTiully094goO8RdcCjQe/FKGvx54h80O5RtCOo1KOAuHQXges5cC1NBq+rZeuvK2VH2BbqZKlJvL0ZYaLlFyj0HhWRge6FkKjUwIIAi4Ig6X1jdxzq6/ZhzRYgP2fcPCLDwImGJ0m8/nIYWPrRBZQl4ZH0MdWr6OX57q+GvVf+hEBLvzLkwgIvep/Mq/MJb2cTkrUmPGmz6v8y1zYN5h6WC14uy+02sBt8UQfVtAN6pphgZJp2vVPyI2VYuKPlaAmemqB9rZqJpvG8v9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 5:59 AM, David Hildenbrand (Arm) wrote:
> With a folded PMD, pmd_addr_end() simply returns the supplied end.
> move_present_ptes() can therefore walk past the source or destination
> PTE table during UFFDIO_MOVE.
> 
> pmd_addr_end() is only intended for page table traversal, in patterns
> like "next = pmd_addr_end(addr, end);". With folded PMDs, a higher level
> has already clamped the range to the PTE table.
> 
> Folded PMDs are uncommon, but can occur even on arm64, for example
> with 64K pages and a 42-bit virtual address space.
> 
> Extract the calculation from folio_pte_range() into
> pte_table_clamped_end() and use it to clamp both ranges. This preserves
> the wraparound handling from commit f681d4580d5c ("mm: fix address
> wraparound when scanning large folio PTEs").
> 
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   include/linux/pgtable.h | 24 ++++++++++++++++++++++++
>   mm/memory.c             |  7 +------
>   mm/userfaultfd.c        |  4 ++--
>   3 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b7..66d369870a740 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -12,6 +12,7 @@
>   #ifdef CONFIG_MMU
>   
>   #include <linux/mm_types.h>
> +#include <linux/minmax.h>
>   #include <linux/bug.h>
>   #include <linux/errno.h>
>   #include <asm-generic/pgtable_uffd.h>
> @@ -1518,6 +1519,29 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>   })
>   #endif
>   
> +/**
> + * pte_table_clamped_end() - Limit a range to a single PTE table.
> + * @addr: Start address.
> + * @end: Exclusive end address.
> + *
> + * Only use pmd_addr_end() when traversing page tables, in a pattern like::
> + *
> + *     next = pmd_addr_end(addr, end);
> + *
> + * Higher levels already bound the range when PMDs are folded. Use this
> + * helper elsewhere to clamp the range regardless of PMD folding.
> + *
> + * Return: The exclusive end of the PTE table containing @addr, capped at @end.
> + */
> +static inline unsigned long pte_table_clamped_end(unsigned long addr,
> +		unsigned long end)
> +{
> +	const unsigned long pmd_end = (addr & PMD_MASK) + PMD_SIZE;
> +
> +	/* Compare inclusive ends to avoid wraparounds. */
> +	return min(pmd_end - 1, end - 1) + 1;
> +}

Thanks. The helper makes the code more readable.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

