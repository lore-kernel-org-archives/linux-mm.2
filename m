Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D633606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z1GRqgVU
Received: by kanga.kvack.org (Postfix)
	id 7CF8A6B05B1; Fri, 30 Oct 2026 08:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7597D6B05B7; Fri, 30 Oct 2026 08:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6208E6B05B8; Fri, 30 Oct 2026 08:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38ADA6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:19:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C09CF1A06CF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:19:31 +0000 (UTC)
X-FDA: 85379198142.20.DA36361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 372FC180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:19:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z1GRqgVU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793362770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEOu/AQvgU0OKb5AZqRCUfaOk8gDp8NvYhcCjCvB5JU=;
	b=01yjLYF8NlTlsxA2u5r43fHuUBQsLQ5NM+JYZ7rS4HMnlGMYjF9z6KCiIXppkaQlchlrep
	Bq0wYUDzupEtJmFw+UJeY0LfsxJ1ia61V7qzBRB99xGfop/P65VUl2bqMy2SQcL7KFzMcF
	AZYFRj99lb2diWmOB/V6hOo4jhwY6s0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z1GRqgVU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793362770;
	b=QtL8EZAd0vgxArI8USKGx2vhXkwXwosWiOO8vwYZBNF7AugCLeHzaM4jSCf9gkCvKm3Pmq
	poQ5mQ9H2ucomNtIXxwIJ172DWkwRP9bYyngGddsAn8PBXNq8sK5yctzprdJASlJ43EUw6
	GlspgZpYBgg9Ih3iubRxHP541LlhcwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DDE7601EE;
	Fri, 30 Oct 2026 12:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBC11F000C1;
	Fri, 30 Oct 2026 12:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793362768;
	bh=pEOu/AQvgU0OKb5AZqRCUfaOk8gDp8NvYhcCjCvB5JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z1GRqgVU4WIj2ovDw33wHVQ50+wcmPd8/iVAG4of6NAt3Rr/AR7PDuT4d8fAQTMtU
	 wXSiDpUBRzGwYOqpuW+G8+Owc6KG88nWoM0t0B9s2tP9+OeTyS8Peqtp9md0yYQYvP
	 d7Q0dFsYSX/Wu1Gd0vyfD8cIc4sNL96m2fr8q7Tr6vc2TlNNvgMPQVwhPnAPZ2qgNy
	 9GdRSJFsFof5PtAPP8aa93iHTxTmUTpJT5ygcEksnW7AFb+PSD7rnPpu9om4ZLsKKj
	 bUNOC/W6HS4UoE600ZsgdUDzGm0y+xdV/sXbDBY2EmdQW1XOZ93Cn2O45iEB5tNixz
	 aN1QY4oHSWwlw==
Date: Fri, 30 Oct 2026 14:19:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Pavithra <pavrampu@linux.ibm.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/mm: fix uninitialized ZONE_DEVICE struct
 pages with PMDs
Message-ID: <auSLSIwUi2xNIYua@kernel.org>
References: <20261030115326.1005755-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030115326.1005755-1-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 372FC180005
X-Stat-Signature: ktiy7aswsfzifdtpnw18485ugeikdx7o
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793362770-486516
X-HE-Meta: U2FsdGVkX1/e/Hz82lHKBTGr00ckqPi+y8l+BWj01Wxi3EVRAUw/J/+1sGIKee5cWBndIYuBiSq2X1k9Qe5/DW4hjRggXwtlTeOvRnmwyVHdKAm9k62z4H+0M79l4oyRu/eJF/Kd20Jry4xCAxCjwiO56j3n+GpHHwksLe7A4azRJgs042GgT0Krk8AjXg7wSY+0k5nf9XmzQneB+DP9End1TGDJ35yFwQjs9fmRpnXqTVh5MgZXIYZ++sdR5zgol5bQqrsXRGcnGcGWuZrnjLJQulcLH6vnpWF1EiWrFnms6pQP+f8IpnGp3+gqjUJEpDqCt3pJu/Emr26LuvJly1a4ad31I9GrFA7oZKHKnRSxdM4WhwrnRt7bR3ywIT+u9H2nbq+RbhZFBuWRDX9uJa8GpMWNn17/Geq2qooyqoymQGx6N85La6D4slwvxH1+ypqpGmJD1azW2XIQm9HWmNVMAXeL5iSSOXRejSIu7yJpi9USa6YT+09tENDCLaZENgw01fvdOtbFseGrOPGtrMlNoC7tUcIh4RxOBuyIP5nxFzynXtffBA/qRajUzyhSgIrBhRL8H/zhIHj4t+6WtGmfKZTgN4x2NSk93jPFVGHZ7Gf1BVBOm8N72xntvOwYC49N73r0qqx6T7xAL6pQxBTfs4CwY8AvS267bI6Vr/Ob8r3CgMBIrtoQA8lFKmoxxjHTItS+DfyL9BI0UysMDM50zdipeUmpTyUq7cfZbNkWb4Fb6zY9mrd5Nh4nLiu/FXY7GrjS8jjlBcgY6+XDhgyXXi/6khJhpt/oS8vKwGonC97UIdyozGFbbIC3UgvTBVUBnmV47JuII210yP/1k8PgfPgAppRf67UiTSJ0VucEs8w81sJ8a6S9wqGG3zuQc9TWvRD2Ir1wWezTOY3AtE6BI9Yjc65CZq85FgtaiKWAPLwwJEAb94N8Ps0UAanqgC4WC2Pqxkw9Hgfpg+E
 bzL4/RWd
 v1WXopo6gyvH6plX4XLLkXp7cv6u6IsyD7HDqx6pzbFfK6zSQDqqntq26TRUhYAZeyrQ8CrlZXksoz6wmaWu1DHTNKn6v+xusg+u2fVXuEKLNvQStvvspKU/wsP3C8OeGdskwYKFwRTfs5vQwil1DbRcgE7W6IzMzxDXyFC/CJ9quNl9llNnD8EZn1tBtzDo2R3HDono+FOL3W1oS6NPZDwJQ0iPvIocVga2P1pt6YmftjT4gxYFahI+z+HSR/SQsDb9xxs/j76yT1pzTnX6qkKtOJVUUZxNTu4YjMB/3zUMt+CpkF/IfU00Xnqz8MppOVI1qixWMANztX2a6pGlGizMEMfEu9NQ2kWsUpD28icYK4WFeJ6yzk+EFuGEYrN4J+TsDC5SEvB6swZHMvCQS+qVEfU5B+dYM+bamEXOGZU6VDuhUzRcjvhPw3rVmJU0N+xpIKNuglxjdGE4xMsUL2g13fBb+X67YRsvp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 07:53:25PM +0800, Muchun Song wrote:
> PowerPC radix vmemmap population can reuse an existing PMD mapping for
> a device DAX range marked HVO-enabled. The reused mapping is ordinary:
> its tail struct pages are not remapped to the shared tail page.
> 
> Leaving the section marked HVO-enabled makes memmap_init_zone_device()
> treat the range as optimized and skip initializing real tail struct pages
> that remain in use. This first triggers a zone mismatch warning, then
> faults while initializing the pageblock flags:
> 
>   WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>   Call Trace:
>     memmap_init_zone_device+0x164/0x430
>     memremap_pages+0x43c/0x93c
>     devm_memremap_pages+0x3c/0xa4
>     dev_dax_probe+0x264/0x3d0
>     dax_bus_probe+0x140/0x1c8
> 
>   BUG: Kernel NULL pointer dereference on read at 0x00001400
>     __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>     memmap_init_zone_device+0x358/0x430
> 
> Without these diagnostics, the uninitialized metadata remains latent until
> userspace accesses the device DAX range and triggers a later panic.
> 
> Mark the section non-HVO when reusing a PMD mapping so its state matches
> the actual vmemmap layout and core ZONE_DEVICE code initializes all real
> struct pages.
> 
> The Fixes target predates the section-based vmemmap optimization
> infrastructure, so this patch cannot be applied directly to some older
> kernels. Older kernels instead need to pass the vmemmap bounds to a
> range-aware vmemmap_can_optimize() and reject optimization on PowerPC if
> a PMD leaf overlaps the range. This reuses the existing mapping normally
> and makes core ZONE_DEVICE code initialize all real tail entries.
> 
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
> Cc: <stable@vger.kernel.org> # see patch description, needs a different fix for <= 7.3
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes: https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Rewrite the commit message.
> - Describe the range-aware vmemmap_can_optimize() fix for older kernels
> - Note that kernels through v7.3 require a different stable fix
>   (suggested by Ritesh Harjani)
> - Collect Tested-by from Pavithra Prakash
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 44868b62b14e..4f75f10ed68f 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -1261,7 +1261,16 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  			return -ENOMEM;
>  
>  		if (pmd_leaf(READ_ONCE(*pmd))) {
> -			/* existing huge mapping. Skip the range */
> +			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
> +			struct mem_section *ms = __pfn_to_section(addr_pfn);
> +
> +			/*
> +			 * Existing PMD mappings can cover the edges of a valid
> +			 * HVO populate range. They are ordinary vmemmap mappings,
> +			 * so the current section must not be treated as HVO-backed
> +			 * when its struct pages are initialized later.
> +			 */
> +			section_set_compound_order(ms, 0);
>  			next = pmd_addr_end(addr, end);
>  			continue;
>  		}
> 
> base-commit: d865f2677c44cb2171b833d6775cf692756fa8be
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

