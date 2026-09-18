Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92260C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC4F6B0098; Fri, 18 Sep 2026 17:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C146B0099; Fri, 18 Sep 2026 17:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C2D6B009B; Fri, 18 Sep 2026 17:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5628A6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:43:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEED0A07FA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:43:52 +0000 (UTC)
X-FDA: 85228210704.21.BA219FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F70BC0006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:43:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbh9lqzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789767831;
	b=Czft7GHnw6MnH01emwpVnxvDL7VGcym6d7R1CscjZod9yLqEfH+A8zOhhHBAjLPJrzbZTh
	j62IrtqKwNP66BrcAmRO1kNqtDAoGBALdsl0QuSolCIoSUz2lZyqL27zAdHXItUnqlRktX
	WKfWehQwwijYJ4taFkzU5SuTRm9Wk1w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbh9lqzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789767831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyzwFKPJourgRKTcGFA3EWni7XkDQAYvyS2x3+CNIrU=;
	b=UcBY7kaEsah+CkNFJnkaOO8NuuAA2i7IhCa7CpaRsyzN4eW9oOSTYR4Getr3sySQa8piiX
	z/866xpG2AAHpt/AtG3Ztj7X71fxOB2LKTAA8nuGXKEg94G5zppZL6q6EYX4k3ikdzDMkG
	+d8wMlq2SHtf70pwzXlYO+5nA97WbE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B95D43352;
	Fri, 18 Sep 2026 21:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBCA1F000FF;
	Fri, 18 Sep 2026 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789767830;
	bh=pyzwFKPJourgRKTcGFA3EWni7XkDQAYvyS2x3+CNIrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dbh9lqzjyuPXUx36JmC4YeTrWPPZZXDxvb5p7cPu5iGXZQXq/FGsDmKIEqgYF4y3m
	 lxFg0pkcL5SiGKtmMeJENal6UQhw1bRA5D7lKDoDxr7wFeaCyLsRl87EIwL+Kw9vah
	 orKjKBTIIXdkgQ4xU12+8xoBddCbjppv9y/R9Peex1utE7RIE0yvFaETnYnobGH3PI
	 nX56coSlc2B1nlce36AeASlcUd4E7y8yGdGuH61xy2SUnPuvoyA0IyIffmUEFk1zo3
	 +xB7sL7Ax5eItSNcXX+bsvC9nL3JeBVocjOPomO3GYXgDhbQkWfsMGfaoNFrsG/K0+
	 tgpQ2vAKSbllw==
Message-ID: <0df7e349-9d11-461f-8b8b-68bbddbe1f3d@kernel.org>
Date: Fri, 18 Sep 2026 23:43:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 07/29] x86: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-8-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-8-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F70BC0006
X-Stat-Signature: gbcymf9d33kfp8b8p3if5fdc6sqxj75f
X-HE-Tag: 1789767831-989156
X-HE-Meta: U2FsdGVkX1+7VWIlHpVJQ4q87gwvxYSfU6GyXHVbhHnwgH8teLKgY8OJEH1v0hvAiO+ESkdJNVouEh8M1QWYTLw32GOjjBtxQRLt6EQUO4hlRQVpPYuRuziwDghtqr4Lnc1dVXJXJbe6B7PIPq4S3zYCJTsAH/p9CZ0lJxAPtyl0+bqvXIQoDmeyeGWFLDEaDxrysGS6SrG2TjmYafpef3/h0Z62AmAuULMtgchZRsHwmTRSL4zEuYIXJqYGY6SPhnozpzpO8TIJODJqWYsmORBZ733yxYs5BL2FHKgVPdd56Vcd2m8D1foWJ++bRSME13JCRmTcCNuNppsUorGwOnyRx6GReloA9lAyaf7mKb7nRD3O3MEIbR88TH5CMdyxOEms3AGj3nv94BnlNime0ROxFaCL9y68w1+ki2BX3aEyt2fkMYMXaNQS4r6EgUH2/7DbFDlVbBP1PDZj73MDHTbbl0yTspwZ9MqUIOIL7CInWF3CVo7aNGiTd/1mZq1psQJfPn60PX+risnMk+IAO/W/MczVGjs3UdM8kgeHvvlO0ToZU37K9nS/ola0jZfPb+pRxM+w96kKQQW7XCPf4Z+QDQFMo+f/8Xp0Ts+BLnvFEXYohq/jC76PD0jJq3/zKK5CW2R3qwJuLbMJgypTGkeTuAxWW7SEbrxMXuUXuK/YIKXtGic/UINoKOAAskPeMJFguZkPSG+rPS+5UqD/UTvG5xxKRWeC/zspIgqwECzmS7vk78L8nwVsLrDgmh+5/e7cmSrEhfjqAoH/O7d6+hEWx1ai41M/BT2Ch3N+++aRdRdbk11ZYxYKvc10jnRZQ15V1iIADFzTaXTog8iViIQ4nl/0JSpY4rG5kDVARl/iiYijFU6yyHicP/etwJWCN2s1IxBQ6EwCe3XcBauijKpqn6ad+Q6WDLGtXLbQlknUNUGVaGaFjC9Bn6PKx5HSfvj/rykWCeHdJU2kjXS
 4IMV93AN
 SODPdv1a2DqfIKk4qWLc+gj36z/asov9ZKgMPXHjb92i0vNPNX5AHg40UkIrfWUHjE2ae3F3JJZCMAVJeExcxvCIpXDDa0HyTPDswsYlNdReby3lalnsEKTdL39hMMyTPEhIUxpsNDEfasKdbPwZujBLK72qIj0qjjsSonSnpyT8vMNuCperAPSkkNEcD9astc/mLF97KuFR8WvKhuXxChmMO9Crp4VBbbF6rMCtMk5QmpP+CvNtX/JlXSyaDyGrb7Zhx3XoeYFiTUo8ttHr+Qe6mdRRXxIHWlpEjnaPxo9ng0QvNbeRwR3nX1xKoAfEw1LR4DWrNHX/YCCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the

As a general note, we try not to talk about "this patch" or "later patches".

Instead, just say "Prepare for X by doing Y.".

> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
> _PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
> for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
> not select ARCH_HAS_PMD_SOFTLEAVES.
> 
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/x86/include/asm/pgtable.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index d551120a7c889..a2d1cd03cba23 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +#endif
> +
>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>  {

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

