Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB57D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB19D6B0088; Thu, 18 Dec 2025 08:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92886B0089; Thu, 18 Dec 2025 08:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87AD6B008A; Thu, 18 Dec 2025 08:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B892F6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:08:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6069BC011A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:08:21 +0000 (UTC)
X-FDA: 84232620402.27.94E92F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9162F1C0010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:08:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQ+66Ylx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063299; a=rsa-sha256;
	cv=none;
	b=iNcoURUB+YuyW3CzFVgIPEf0suTZtXzzTNkL9defOcR3YuCfdqjHRE8LJqebFUnGHQb0Sy
	8rKnB5cjWjEvXUFheTTDWs5EL6R96WDV9ec6oxijPW58yIRekzFyAkIm/E3bzgjRy6LHUO
	UW+WUpZSL+yGLyXa9hqTxMT4chveT4k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQ+66Ylx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CsbQhbcGFkSMNoyzcNw+Q2/IzHj8zTOliIUFlrk3M4=;
	b=fBnDubG6v+g9frDxzBriA85/SvyAQ3vfgo25uTZxOcH66/PdEUXp/dYNzFKlyf+C08koVP
	1AoKcIjJFdkDWRP6G5pf4Jo17O48igIhEWVUNh7vSB+Wr5kzunku4qDqcuTiUC1Dn8b1VJ
	NZn++zQUQLt/1jmumeNn8nMjBdf6Po4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B89AD419F2;
	Thu, 18 Dec 2025 13:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC60C4CEFB;
	Thu, 18 Dec 2025 13:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063298;
	bh=xGSeZoo8A4otZiM+Me0157v7z6QWInhRsz4o+w4d45E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KQ+66YlxanK99AmGFS+hJoQ0JNeSpw9MPMZirOXFW/OpdDAd+sh93g+L4GQS+tWLH
	 nkiK3IdUgd1FfMP1BU59L4AERAy1K8TK5wGG48+tgvAawKgdlVwHF9/VEOhGT8HN8T
	 PpP+oi058arCeHD6iSJy4aRNuJrpIsVh7Rl6OpDpp5OfpM2/zaNwX3GEdyfx9n1cNO
	 63LWQAa1NjHuz26AGjgsJxZeqgDBdA8o6/kF6rOThkruCypAwDTTCVqBmHi3o2grIf
	 qaUzDtiSBioKw6iSWz/1xoDEV0V20uyOZdDJL14ew5bp5R9wwlQMYVJIXd7xbHLsx3
	 69ENOKt+sXqrg==
Message-ID: <c36501bc-2690-4ed2-b85e-13e64c41baaf@kernel.org>
Date: Thu, 18 Dec 2025 14:08:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/3] x86/mm: implement redundant IPI elimination for
 PMD unsharing
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-3-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251213080038.10917-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9162F1C0010
X-Stat-Signature: w1cthna4s41k7iwpm7g5zf7xqkwiaann
X-HE-Tag: 1766063299-997950
X-HE-Meta: U2FsdGVkX18D2n8nD/tkV9HmZbweLh2sV7YP6dVJyRXdQMAG6sLVgdfriZa5EUWgjL6CbEGhm5ZYBpnjZnelexQwnHqLN0YLjwRjsApBVo5/3bfjx1f7Opsvulqmx2YIpjHMyF8iQli5bQb3oxKwIC8i00cVZA1DYd4ymD4k2HTh3fTB5a6Vit1Hq7ClABEfzW04XgIPlrkYIAGqtJklPpDIEbEF+Y2PkexJP/6P8O0M82I0m+Sc4DdryFusPDPnC1sJet3d/n7AK9PDZaq99lzv1mmFwDezSU3j6Z/R4T5BMhc9qnD8TD1L5DUkJ8dS3nJz4yF48mnYdVNUSP4G/NdXIQK9V9Jws/td2+RfvNKuktl0RtMcW2FJrVW0ZuvTgmim+8ko416+pweeqGlhwyZ+nPIXaw1zDxHmBtVQqAezXlxvetWVOEaWoyICh8sp9Hk5LjwcW/TS1XfcXsfxgn38mGcyZ8OEMVGQ1aY6jQpCnOZMddOE727M4wMl3cR9Atwjogx34cUcYP4mcB/pfcsEduFWOQ4MPEAUlci+PZsp558ielLilfrJFwXjmnIWcZvbeUSgIXq6pNPmSoqEATgLh2dglkPHor4ZCcAp/yH5iC+Ma3UkGhSPkDY4XuWr8Wf+DjXFfQk2Nl9ZoTn5PWrtPCGLwEEn8N92wZBCxBh6v6XgkfiuCdWmR3auBuaKBvDxmRl+Tf4opnaHuauqBYV7e4biz9YbqR5NukZfGkfxulvZ5rql/7LJfjJ0LQc1NtBtP3oYJdds+dK6fT0jpuzQQyAZW+zESSM7Y1GWCxSIFrXiTti6VU3zwCX3Yh63vDyU6baNZzsaJ0OyNeERkvuNOT4PPj3ScrKtBiWYOHzH8B7JHo64PAYNhl56ysmmlop4cclJJsFatZgDBOvinz4TkWm5IKp479ZLpovGAUTBohpdARv2C8gCY2V1Lv6mxhHTxRh+KoLBEh5Y0oL
 RzGu/ZpQ
 v5ahSFNvop0IkTPSrrR041F8W1ZT1ILb5Z1zNiR2o6O6KI9VFMb01pqTFAegtTV51g1bnZ6dbmNeRzACaftuU/n29H6aY7sVJF6w1JSqAuxIx7LdXracQMNGRjBU/osuRteHFeoLv8v7VSqKXNEwxZLuTdAmlVdGg1qwQr/UQKBydFP2B+j7WiypCuICzJ9DGgx8n2Pz9dL2K31DwYLGslFvdZRnaOBtewMSFAFhDJ34Wg4/ApGrtQzwj23NYIOxzPiv5e/XRAW+hdgMjoEfnv2xEOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/13/25 09:00, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
> ensure lazy-TLB CPUs receive IPIs and flush their paging-structure caches:
> 
> 	flush_tlb_mm_range(..., freed_tables || unshared_tables);
> 
> Implement tlb_table_flush_implies_ipi_broadcast() for x86: on native x86
> without paravirt or INVLPGB, the TLB flush IPI already provides necessary
> synchronization, allowing the second IPI to be skipped. For paravirt with
> non-native flush_tlb_multi and for INVLPGB, conservatively keep both IPIs.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 866ea78ba156..96602b7b7210 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -5,10 +5,24 @@
>   #define tlb_flush tlb_flush
>   static inline void tlb_flush(struct mmu_gather *tlb);
>   
> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
> +
>   #include <asm-generic/tlb.h>
>   #include <linux/kernel.h>
>   #include <vdso/bits.h>
>   #include <vdso/page.h>
> +#include <asm/paravirt.h>
> +
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> +{
> +#ifdef CONFIG_PARAVIRT
> +	/* Paravirt may use hypercalls that don't send real IPIs. */
> +	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
> +		return false;
> +#endif
> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);

Right, here I was wondering whether we should have a new pv_ops callback 
to indicate that instead.

pv_ops.mmu.tlb_table_flush_implies_ipi_broadcast()

Or a simple boolean property that pv init code properly sets.

Something for x86 folks to give suggestions for. :)

-- 
Cheers

David

