Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72A41039893
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE576B00EB; Fri, 27 Feb 2026 15:33:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF146B00ED; Fri, 27 Feb 2026 15:33:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF416B00EE; Fri, 27 Feb 2026 15:33:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE236B00EB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:33:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E56FC140860
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:33:08 +0000 (UTC)
X-FDA: 84491386056.23.B58D637
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B89D40006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:33:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EyjNx/Se";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3uekEshW/xKjXBEvusLeqL0JjgByGtsyP7Oc65umvMM=;
	b=R93Xk+ml/oPYjpXkyfYYP7CEWGdSPizteDEwwRhkSp61EP/xnU7tcEW14QAI0RbQuVJmEO
	Om0c55KBx2sDii9JY3sDcjy9b4siapltV6jES/15qz3Zn1Ekqv1mespU4TA3J4eBzobCvy
	pvvd58QrwNG0HsBhxX+wz3/qqkczq0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224387; a=rsa-sha256;
	cv=none;
	b=02nrm8PNDyI9Jy911M4Chq7C5CBCGCBjdZevCtwUPaRZSTm4nSsU6Vby3cz6Ooszt7FiqH
	pBadRrIDjfTrWqGBT09XIcDaTlpiYUogmvgbeThcOK8SgFaVghnkA+4aTKlUfBsG582wHL
	tg4qrs3GhhpzgUditV0RqFpbEku4UqU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EyjNx/Se";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C576E60126;
	Fri, 27 Feb 2026 20:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51087C116C6;
	Fri, 27 Feb 2026 20:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224386;
	bh=slkBastChf5NkGimBBG2KdI1m6NFtJss7zAk/GegKbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EyjNx/SeP9lh/TRrToS5vPssRYmhM4HT9p1ZWZKlb0Bfps1aFY3b6ChEAluMcTyYq
	 3U7EZvChT5nEPWS0froZu+zHpL2hUzCG/FRr3PUBmoB9hGZ+YSbEGTRqSbtjDbJpoX
	 /q2y6uMhPIYlb3FKpC21qDfAUzWgYxPBSAGneu3BwiVDF0rAUAepOiivNkEZgeF8bk
	 H0PnBeZPd4QvyYlIqu6qNM7d2zO6ovfkzqhykvPKdrvRNoo7J2XfX8F28TnEEU+D/C
	 9R/34qGAr4DTM2s/ktGhTON2adcaeWy8ZP9XdZsQzKLrxC0ocrSkeAGoh0kjvh4544
	 vm2RDzb9nfguA==
Date: Fri, 27 Feb 2026 22:33:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] mm/hugetlb.c: Use __pa() instead of virt_to_phys() in
 early bootmem alloc code
Message-ID: <aaH_fgdQB7gm9XtL@kernel.org>
References: <b4a7d2c6c4c1dd81dddc904fc21f01303290a4b8.1772107852.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4a7d2c6c4c1dd81dddc904fc21f01303290a4b8.1772107852.git.riteshh@linux.ibm.com>
X-Stat-Signature: ajfp6yxatk789kb8mgm3k4wcaz85eh98
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B89D40006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772224387-719332
X-HE-Meta: U2FsdGVkX19nYdNveJwW97iGShvsti7sEILslk5+HQyc32pHIKH4FQUQLIdaNZEXJnmY0EeoOlnMjUSrTqIdGsrSb3KoBfJ4p5A0BbbvS9EJX1JkO3BXJGF0BLhDJVMbLoxoQ/+Z6Rq4CBxfxrvdEAcnMGQtOMhaQ6YL59H9rdb0cm0RWOD9JwO74lbpW5whNZWi5bKYjxXH+poj+PHdXwLXJF/Hki6jLkjJ9U5dxJK0m3zotBCgVrKcXz7xGRTsPpeFafT+qKxWhd2SNAkdW/ZQW5pKX48ZNKt6KVwIQAydz7wOrQzxoOn6CBoeCz7G9v8zxkttsRAoyX/b6wakuIvCBjfletr6OfdvHHVwq1TxXBX9SdTzATCKhdQqPlW8at+4vxzub2Uf2KBB3rwwvYhpTQOdlqplEh3vHQVpXrcj/8tBgvAfrR1tmcI+a5aaVVLyJemFdL58Z850MU4msuiSVgAWZkETvR4ALxGtEOBRj1XUaW171uf/QUK7dnAmFhsrPkPEjohC2tZbzTUjxRQfjKgDM2wEAq4p9eS6mzWKagP/oRo9OG8L9DBYbrRYTfr5rZyoVvmlC5Ot1wvDYyXtZlhlqo/tgcV0DXxeap/XXEtmz0Q/tiGPQ3DDvdkMp9DEpkfNH3eVlQ+RRX60X1XAO9f1K6VT3MrNwPwO+x8cXrZ7Q3iI5SSStmk0BofPEOyrUWi2Z3fRi/XWdxjQVe5aOjHW7kDHRk49C0clGfLRXuzvLuwDiETsN0mqeKSYg9y2clrQSpsJRWVCILICslBQy4L7nT/wl0uPw7q2v29VubhXF566dUTjItA/ace+6Hq3tQQ7KG7uokgxomw7McuRzNIV8mTlI4RfpXm/BtiSCnPIHoi6fna7Uo11k/XIacSDbyCyRZ7L3p2P0J+spfANKTbq6/weA8R8iVmQ99FQBbx3y53MZsY6+xCJWWfYpZYV/ZqWfF5Kro0/rEF
 MKZ3Z/jO
 b6n6CTLq9JGmAgxmwL4yKPgSKyCw1FRwQed4bqsULvcp+ceXwTzKZUDR274a7YTEMyUMjatHivUvDRfUIuhPrz3uUT+xZK0nhio4A/yqPdSImJq2b7zk991GZ9u11U5ItQtyDeCkhVYaarJxSqob0Qpp3nJ4KjBRthh32LRfrwRJbzequmTAU/4IderDY58iPzdN6uzvoW0y3h3Cji+Iow9h4eIPaO7EaKj/Bet5KWkWJwajl2Uyg0hCWOryOM2XSKD9SCHK9WEIL7S++giorZd+nvFxuloxwmRCRHEUQpZxBzqyQFPsPB8WER4sEPa19OfmlaBgTPq9+VA6nAV0ziiKiHfanQAD3iSJxjwQSEz5pP8UDj+/BMJDQz81+LbKiZa64mZqcqQVmAO7lY8z18AeXr9q5LMOAaVRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 05:56:30PM +0530, Ritesh Harjani (IBM) wrote:
> Architecture like powerpc, checks for pfn_valid() in their
> virt_to_phys() implementation (when CONFIG_DEBUG_VIRTUAL is enabled) [1].
> Commit d49004c5f0c1 "arch, mm: consolidate initialization of nodes, zones and memory map"
> changed the order of initialization between hugetlb_bootmem_alloc() and
> free_area_init(). This means, pfn_valid() can now return false in
> alloc_bootmem() path, since sparse_init() is not yet done.
> 
> Since, alloc_bootmem() uses memblock_alloc(.., MEMBLOCK_ALLOC_ACCESSIBLE), this
> means these allocations are always going to happen below high_memory, where
> __pa() should return valid physical addresses. Hence this patch converts
> the two callers of virt_to_phys() in alloc_bootmem() path to __pa() to avoid
> this bootup warning:
> 
>  ------------[ cut here ]------------
>  WARNING: arch/powerpc/include/asm/io.h:879 at virt_to_phys+0x44/0x1b8, CPU#0: swapper/0
>  Modules linked in:
>  <...>
>  NIP [c000000000601584] virt_to_phys+0x44/0x1b8
>  LR [c000000004075de4] alloc_bootmem+0x144/0x1a8
>  Call Trace:
>  [c000000004d1fb50] [c000000004075dd4] alloc_bootmem+0x134/0x1a8
>  [c000000004d1fba0] [c000000004075fac] __alloc_bootmem_huge_page+0x164/0x230
>  [c000000004d1fbe0] [c000000004030bc4] alloc_bootmem_huge_page+0x44/0x138
>  [c000000004d1fc10] [c000000004076e48] hugetlb_hstate_alloc_pages+0x350/0x5ac
>  [c000000004d1fd30] [c0000000040782f0] hugetlb_bootmem_alloc+0x15c/0x19c
>  [c000000004d1fd70] [c00000000406d7b4] mm_core_init_early+0x7c/0xdf4
>  [c000000004d1ff30] [c000000004011d84] start_kernel+0xac/0xc58
>  [c000000004d1ffe0] [c00000000000e99c] start_here_common+0x1c/0x20
> 
> [1]: https://lore.kernel.org/linuxppc-dev/87tsv5h544.ritesh.list@gmail.com/
> 
> Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/hugetlb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6e855a32de3d..43e0c95738a6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3101,7 +3101,7 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
>  			 * extract the actual node first.
>  			 */
>  			if (m)
> -				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
> +				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
>  		}
> 
>  		if (m) {
> @@ -3160,7 +3160,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
>  	 * The head struct page is used to get folio information by the HugeTLB
>  	 * subsystem like zone id and node id.
>  	 */
> -	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
> +	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
>  		huge_page_size(h) - PAGE_SIZE);
> 
>  	return 1;
> --
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

