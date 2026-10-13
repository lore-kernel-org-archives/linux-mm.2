Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF62CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A2B6B0098; Tue, 13 Oct 2026 06:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6221B6B0099; Tue, 13 Oct 2026 06:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537C16B009B; Tue, 13 Oct 2026 06:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38F136B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:14:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE01EA8985
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:14:20 +0000 (UTC)
X-FDA: 85317193080.22.AED2F74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 295B8A000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:14:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pyau+2JB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791886459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jaFSNsp/CFGLzl6alv0F7/TLQf1iiNaD/MVLusHMzs=;
	b=XP+36JzJ+iNMFn/ejqM0g1euBQAxQQnzTM+TXUBtRlLJ0UudYjczNs6WKrYD5L8m2kr0S+
	wu32OVJbxytXTYW8RWRu/CqhfCBCuEHvdAIzSPRcknVousmLkU8Jk0dYuznjj1vQZsuT/V
	4fpKKUpM9/FhwpL39FMHQkekKqI/Kbo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pyau+2JB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791886459;
	b=TNhXr0Y57LDhRZViFaypCgfKltDDeeBqQtET6PBTa1bbz6JPioBKwtmEWI1G3vQ7f6hIA7
	scwkp+rRCXpo8juhpk724n7987mPohg7GGxzjq3SqVZ8jo+L0A41V/7kjm8/a+/jULAbJM
	cANUZQrgtnWp6fySOrC2zaJrch8IXW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EA3F60A65;
	Tue, 13 Oct 2026 10:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D801F000FF;
	Tue, 13 Oct 2026 10:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791886458;
	bh=9jaFSNsp/CFGLzl6alv0F7/TLQf1iiNaD/MVLusHMzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pyau+2JBZ47xLEI9AjYwCxEuWFUp6KtSyV6c8/8WT0N4NRCIgNIk3m2zUnq/UELQv
	 KjsUiMlNO+yxD3z4wT+gRyWqjce+x8opkjXeeo8cW7wqadbIJAS1NCiMIFQx8CO0Z5
	 ulJShIemgghxaodPh6CqWYG2YtFAtYtbLo2CmsABAEb9FGXc58la5w9O6mSKkENVo7
	 HibEtbFe6oqdn1TbWpZHHESHkgIE97Bon5u6fh4P61z17grF2aauuVX6tOMWrFEIyH
	 dkHLm0NUip3sgYNpBBeZOx3mFIkikn1/pa7ujFF0hf2ZOUCg7QGpg+ih6Ak0kR5zeY
	 UjgEuD53By39Q==
Date: Tue, 13 Oct 2026 13:14:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open
 code its users
Message-ID: <as4EcgiBH5jjww42@kernel.org>
References: <20261008190828.3221718-1-tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008190828.3221718-1-tarunsahu@google.com>
X-Rspamd-Queue-Id: 295B8A000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4b9bpyarg54tnspfr39h533mhbphujpt
X-HE-Tag: 1791886459-607470
X-HE-Meta: U2FsdGVkX1/dVlP8K/sclUV79ODjI6IHxYNdJy/F5PMlnU2QbKvecK0m56pY/0FIixtJgg5iUmLw9JqrHMmNQqVXw3+lk4Ifvs3ZmlrflHPTmtj+1t9AHQfBfdst6w1lp3ju4TGLyWa9bf5Fvz0bwfqvqiIfwvUC77pM8e9XXHNgQW7C/7FGp5zEvB2M8T5LnzhgA0h5EfEiqQUOLUBcOKPej2BGcLlgqeB4gBT8JepMCtcUtt0lz+K9Fc4oJ1URLLxWXJGR/BnQ14bmp5tdQIH5iMVn0liIX6mWtbZMwcn0026OqcoNRQFbN0RevrcrtghSSKeiF78mcGq5ql3nfG91rUlx5RUob0s0jsn2F6t636O9LGxsCswCJTiFBZk6gXlTdiqg7KS5EATsNe0K3GeuXUVSuA+En0KunS+g5j3MoW9mPjhc5K69snvRO0wLgfxMZb3ZD0+z2IF8SAEpJ+XinDGqK8CpX86+R6VqW45Wqg26SoZH7Y9zCXN532DvdEZmVLs9RcTB4nCOaNz97YQ+THdzQ4JVtI/exLCxPg1TmJy1joWRVHnwxWRYuCQfTHOMQSJ9OGL69ZxEGoeH/odWvXHjiX78k5BpIIxwGs2I4j24UrPyB6Xvaf6/128WcvRn6eIrGgxpmCCH2x6ySZpgyCq+6fJT0gQEI2oQTIwnd9SLMoLumv0LBL7ViLGELMxAmxJBLWwoAH2bFz71+Xf3OIxovHemAMmtkZQL3SF+zzBytNP5Nfuq//Qp9v++E31MsW65OudR6atmBC4ogOVT0TzkLgzZuae7njHGWxcEZG2WKtFdfiyGZmCxKfFI2cSz242cxlUYyQUMgPzCYc83rQF0mj+wYZPLuG8xORkHSVglDHl1ciAIzrE2X8+dcGstMPyJdYpBTJXlIhLld1BHRytflyZTsFlJyQ70WSK6H1a4NSQLPf/SvGs8/90Jb6YPv/EXSMVn0Cts/wX
 Tllkg9O+
 Yn6uLq1JLUqqSpBDgl2v4fxxRq1fKuwKxZzrw72Is5rkCha1hHFsy2OoewkS7p6OnAA4H17CKDX1YgDUsBcBYacUw36PIOej/3VNZ13rFqsYNF/qL1JNrFAaq06gsztBlAdO0K/Dd8Hy843DxrFqH0uF2I9t7Cl84hyIg9GNg9rGEw5x7BgUej8ajhuV+wzXyzZD+jMM1SJz3vCil069tIiFGK4uILGk/kHKe57EYhgCNUYcOmvF8Ky/0dn6X9690VxPPkvCPMWa7BVVaiAtsrJNoav7nwQLhQJCRBp1xXCXP5dC7rvcdyqfu7RVdZY7APlNohd62GwQsd/0ANLkf0OwIMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tarun,

Please for the next time add the cover-letter when sending more than one
patch.

On Thu, Oct 08, 2026 at 07:08:27PM +0000, Tarun Sahu wrote:
> for_each_memblock_type() always starts the iteration at index 0 and its
> body is a trivial 'for' loop, so it hides very little. It also gets in
> the way of iterating from an arbitrary index, which the next patch
> needs.
> 
> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.
> 
> No functional change.
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  mm/memblock.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index f5aaa38cfa31..59dda7d085f3 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
>   */
>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>  
> -#define for_each_memblock_type(i, memblock_type, rgn)			\
> -	for (i = 0, rgn = &memblock_type->regions[0];			\
> -	     i < memblock_type->cnt;					\
> -	     i++, rgn = &memblock_type->regions[i])
> -
>  #define memblock_dbg(fmt, ...)						\
>  	do {								\
>  		if (memblock_debug)					\
> @@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	phys_addr_t obase = base;
>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>  	int idx, nr_new, start_rgn = -1, end_rgn;
> -	struct memblock_region *rgn;
>  
>  	if (!size)
>  		return 0;
> @@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	base = obase;
>  	nr_new = 0;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  {
>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>  	int idx;
> -	struct memblock_region *rgn;
>  
>  	*start_rgn = *end_rgn = 0;
>  
> @@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
>  	phys_addr_t base, end, size;
>  	enum memblock_flags flags;
>  	int idx;
> -	struct memblock_region *rgn;
>  
>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		struct memblock_region *rgn = &type->regions[idx];
>  		char nid_buf[32] = "";
>  
>  		base = rgn->base;
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 

-- 
Sincerely yours,
Mike.

