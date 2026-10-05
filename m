Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA24CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A166B0088; Mon,  5 Oct 2026 06:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB466B008C; Mon,  5 Oct 2026 06:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA986B0095; Mon,  5 Oct 2026 06:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 310686B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:37:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A011E1201E4
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:37:37 +0000 (UTC)
X-FDA: 85288221354.13.57AE042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C74BF180003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:37:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFzxhi2O;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791196655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cByG7GqhBvWV2hjaYwUvk7XARELXPjKV24/eCyNbhZQ=;
	b=1m077cjjL29vvVKve5tACOM6lTQfPngmpTR4/Tnk6Lqnj4nG86TKxTM1QyKN0BjbTVqqMn
	aaGqZfwGqs5anZY6Ml8M5ifaMzv1AlbAJis/8r/53lXvCL1IBF1t2oTgIbvq0LX4MspKjj
	8ZTzIhIFJ/+HSCdBTdwS2ZWCPwa3Zc0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFzxhi2O;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791196655;
	b=p0DT1w1pufH+14H2qeDsh49ib9veirOIG8tQBmwipHnGrmoJH9ceUk83i1x0gjdvl3pWsU
	33VaNLu9DX9M6upXtLtES+drL7zGc2F0Bf0FdkMHZ6M4HFng+kQXjm0wRm17FpgYnyjHaQ
	bX0YHUEa9gNZzf/glkHckKGB00ypTR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B720F415B3;
	Mon,  5 Oct 2026 10:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394661F000FF;
	Mon,  5 Oct 2026 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791196654;
	bh=cByG7GqhBvWV2hjaYwUvk7XARELXPjKV24/eCyNbhZQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UFzxhi2OKhI7lOTnQNuT5HIVGpaxAbS1fgEPpdjeuyurAwRR8AVghIocUlZW6JGwR
	 mnGCuSA4j3JWEpMfC4xPkdvyQAKVzSd/Jkj5tOT+vRbqFF0BcqFAj4HDAiqRyeXpgK
	 rVFOS1s6YKwWKEiM//Z2aU/vsloh6wNr8iUpImltVL/MxI0rmEfGjkQkyLO3tsVRvK
	 npu3l3PXt8mv0PZPj+ZEqOibABFIOqYktx455TvhuC6zXUmzbvs0vEi+sj+Xp5wBKR
	 9N8QlqbV6+nm2AsncAr4ROh3G1k2HdVRDF68iEod47EmNtXDGQTexWFteH0cOtkckq
	 LQ4dPVDY4yBrQ==
Message-ID: <fabd52b6-36a7-442e-9cfb-47a39e4ae3d6@kernel.org>
Date: Mon, 5 Oct 2026 12:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] riscv/mm: fix soft-dirty migration PMDs being treated
 as present
To: Lance Yang <lance.yang@linux.dev>, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu
Cc: alex@ghiti.fr, akpm@linux-foundation.org, zhangchunyan@iscas.ac.cn,
 rppt@kernel.org, kas@kernel.org, andrew+kernel@donnellan.id.au,
 rmclure@linux.ibm.com, debug@rivosinc.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, wangruikang@iscas.ac.cn, namcao@linutronix.de,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 alexghiti@rivosinc.com, viro@zeniv.linux.org.uk, ajones@ventanamicro.com,
 arnd@arndb.de, axelrasmussen@google.com, brauner@kernel.org,
 conor.dooley@microchip.com, conor@kernel.org, jack@suse.cz,
 liam@infradead.org, ljs@kernel.org, mhocko@suse.com,
 paul.walmsley@sifive.com, peterx@redhat.com, robh@kernel.org,
 surenb@google.com, vbabka@kernel.org, yuanchu@google.com,
 stable@vger.kernel.org, pasha.tatashin@soleen.com, linux-mm@kvack.org,
 me@ziyao.cc
References: <20261004030312.90163-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261004030312.90163-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r68jnj7m6mtkda85x4nyhpybihnyhdsu
X-Rspamd-Queue-Id: C74BF180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791196655-842306
X-HE-Meta: U2FsdGVkX19rQmMvEw4JUHOb3a4e/rOnTkhiahRpOdbOddv7BAV79s9+rvm320xfLI+h8lCFGGKTSSOHsqqlecdSKLhY1445Jb1q5uMjnRXezqZYo/6v/Tb3DiWaIG+gxS6AqtSf7anu1Uivj5eQwkJDUN0DFN6XWeDdRyNbDxQW79UguQzjJBB3CHpQj4ZwYGQ84/3tj6HM2vzu/FYCtL2Vtfq4Ltx+uJXsZ0AC8Ya35W32ZzGcRKtbVtRsJ7sT+C6gn+p8HSFC7vwgQEZt5Ia/V2kVkRMAY46O7oUsj1v8r6JeZClusstDCQs1P79UK1Yd0eSFsB1tF3fIWnHRWtrbJcw7vzK9IJ3fkRFTIQ1hbj9KvsohB4SJVut9q2OE9IWmfFYk0PYqSXHJwx0FHCKhnIPr1FWGWgfS7l/G2dNMztD39fVAhPPtiTKbX29mKqW7ZJMWtkBU0OYeA3XnyJDsAoPWoMMeqBfTxgtXvLVmoqFeoeuUJQ/SMazsij7s+UmXpWJxnhmM/b+MA50HwnKD2h0NeEXWBUMjqHEea55OjyR58thguHMa5tBpC0vXEOkEsfyfeebXwURH/UfweoGZqZRHU2/jqWR+frjpzAtJ/SlBIL2fGC2qz1OQNqmVDgV/7VQUT2ltrltQJc/yBZ/xmP4pAncWy3iZhFUZwT6lhCy8lpyXj64vSn4SbCwWWN2OQQY8Re6gMBFp/zzzU/pdmMb+c0tjv5mLwJO1iH85K6y1YagTQN5a6ud+30AxZhXsyWXOxXyz41gfRGVauKkiMH/SO37K0rLqJo414tgO+o8RWsItUixvquCdyGBuMsrWJpC1Vx+iWy9rn0d0wOqbJP+NWGdpbGhQt0ro0B+cCz0ISQXaW87SJdTrZUY1u0+5V16mvbqyFEbyhD5Ajwp1DXq78kKg6jpUdLnZBWa1suCn/VONSJDygr7oYKJcgwUFCGeugSAO6OkojuW
 /4pNUR6r
 O3EXYs2LISzP0cUcSj5y6mhotDJSQpgt+3tgEWMOh/eVAgF4fVhDlXTWy3mG/HXj+4Hdd37cRGQbrUSVysYwL+nBfip01EnCpx2gCtZGNjuuNQMrqGrI82D9K08EJB0tXlyhAViq5aW5TAbKTSUlx6OKdWssc1FNlBDPkgZc+XvK18ePu8l0hbI3LN5M2Nw4hekDYA6Sm4EKsXb+QsdlhRVE1qJdzCXmkvyT8FDKKeHkD4oeQWrEW+K9CRcP7Jsriob9+x2jqL86yNZSXod1Tl49+4830NeovI5rdfIQxUgQsEotBh8e2Pf/RwIwdSlmCM8qLe7G6qYMPQN19UcK5Z3Mx7smx4IaDknIBSx5KZVbX63kwWVd1TcIhoUCPIz6MLGil9T/pSM7C6Fc3jWu8y2jL5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/4/26 05:03, Lance Yang wrote:
> RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
> CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
> a problem for PMD migration entries, since pmd_present() also checks
> _PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
> cleared during splitting.

I'm curious: why do we have to set leaf indications for non-present things? The
HW sure will ignore it, right?

Is this a sw problem? Who needs that?

> 
> When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
> soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
> migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
> migration PMD as a present THP! The fault handler skips
> pmd_migration_entry_wait(), and a write fault can end up in
> do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
> as a mapped PFN.

That sounds bad.

> 
> Move the swap soft-dirty bit to bit 12 and start the swap offset at
> bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled. This keeps R/W/X clear
> in migration PMDs and lets us keep the existing pmd_present() check
> for invalidated THPs. Leave the offset at bit 12 when soft-dirty
> tracking is disabled.

That reduces the effective swap size (and PFN we can store). Could that be a
problem?

> 
> Fixes: 2a3ebad4db63 ("riscv: mm: add soft-dirty page tracking support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> I found this while reviewing Usama's PMD-level swap entries series [1]
> and comparing the swap flag bits with the PMD presence checks across
> architectures.
> 
> [1] https://lore.kernel.org/all/20261002095503.3585565-1-usama.arif@linux.dev/
> 
>  arch/riscv/include/asm/pgtable-bits.h |  6 +++---
>  arch/riscv/include/asm/pgtable.h      | 10 ++++++----
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
> index d5a86b4df3ce6..d84b459e010c1 100644
> --- a/arch/riscv/include/asm/pgtable-bits.h
> +++ b/arch/riscv/include/asm/pgtable-bits.h
> @@ -27,12 +27,12 @@
>  	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
>  	 (1UL << 59) : 0)
>  /*
> - * Bit 3 is always zero for swap entry computation, so we
> - * can borrow it for swap page soft-dirty tracking.
> + * Bit 12 is reserved for swap soft-dirty tracking. The swap offset
> + * starts at bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled.
>   */
>  #define _PAGE_SWP_SOFT_DIRTY						\
>  	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
> -	 _PAGE_EXEC : 0)
> +	 (1UL << 12) : 0)
>  #else
>  #define _PAGE_SOFT_DIRTY	0
>  #define _PAGE_SWP_SOFT_DIRTY	0
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index b644db16bda94..acaf6d3b54d04 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1178,18 +1178,20 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
>   *
>   * Format of swap PTE:
>   *	bit            0:	_PAGE_PRESENT (zero)
> - *	bit       1 to 2:	(zero)
> - *	bit            3:	_PAGE_SWP_SOFT_DIRTY
> + *	bit       1 to 3:	_PAGE_LEAF (zero)
>   *	bit            4:	_PAGE_SWP_UFFD
>   *	bit            5:	_PAGE_PROT_NONE (zero)
>   *	bit            6:	exclusive marker
>   *	bits      7 to 11:	swap type
> - *	bits 12 to XLEN-1:	swap offset
> + *	bit           12:	_PAGE_SWP_SOFT_DIRTY (CONFIG_MEM_SOFT_DIRTY)
> + *	bits 12/13 to XLEN-1:	swap offset (without/with CONFIG_MEM_SOFT_DIRTY)
>   */
>  #define __SWP_TYPE_SHIFT	7
>  #define __SWP_TYPE_BITS		5
>  #define __SWP_TYPE_MASK		((1UL << __SWP_TYPE_BITS) - 1)
> -#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
> +#define __SWP_OFFSET_SHIFT \
> +	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT + \
> +	 IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
>  
>  #define MAX_SWAPFILES_CHECK()	\
>  	BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)


-- 
Cheers,

David

