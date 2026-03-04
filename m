Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4156DEB7EB4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E126B0088; Wed,  4 Mar 2026 04:07:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08036B0089; Wed,  4 Mar 2026 04:07:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90AB96B008A; Wed,  4 Mar 2026 04:07:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8086E6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:07:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B1D6C1EFB
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:07:16 +0000 (UTC)
X-FDA: 84507801672.02.D68A289
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D76C160007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:07:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KE067Ue8;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772615234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpP89tt4PiXcT/4IvUtniIHQSdbAeCSJqbhbntj6lzA=;
	b=U06yFkWQ5rfUqbTpzmBFTh/24fqyf04lUhz4d+dBThoGzbySBHVZdQpuOB1WkZYD3iZh06
	yFREpLegg+W18HZQjqxTnRLrAOBEnEGpnJgRjeL9PuISkn9lu1M7DkP9qhu6U9ocCajx5k
	jJXhRvcdEr4Kx5Ttw1CcPg9dOA2pkBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772615234; a=rsa-sha256;
	cv=none;
	b=2mPE0B0nNGT6FjNF9z7Qr0xikxSApOaqT/StcayTzFGxNpWI7z+qzQ5tAGxSnR4oYO2YZF
	9/ctu/97d7Ob3helHwaT2Av/GuoAQWvVE/2uZkXn9gSyVut4y2oAlALIrBuOHQveoMQiac
	5p3GvZxe52ne9pCkAHefPRxIDHhJN3o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KE067Ue8;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4DA0600AD;
	Wed,  4 Mar 2026 09:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8865C2BC87;
	Wed,  4 Mar 2026 09:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772615233;
	bh=672SBC8u5t8kVDzclxxnrDVmy/LpItQTIInLTSVSKMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KE067Ue8IQa38GsVrb+1Gzf88w1P2fwUwi7EKw1JCf286er+sYOtKcXDSqYfWk0yb
	 h4tjHeqdRrTL7G113O8dNSxk7PC3o7Jy7kejiE7m4cjsemm1CeBoCo66AgqEaVWrSI
	 3uzfSbZ4vMGHJ35K+1uL5xee0KwB+Z2bUA4G/pGC8y0ni9MH7bsJ0zuPFvbAq6ec8P
	 BtQOjiwyYjJfCzXJFTioUfi7DIVzEeouh8srKFMiGlkK5sFWhMFJK/Z5cQq41VNpGe
	 b2g5X2MCH1eZyY1oyCwn+mK+u2BZsCTGgxd8I6okSpcZG2a0cmqMq+9LhD1+OnNJa+
	 tc0D/CbEQJyhg==
Message-ID: <77e64962-7c01-4f1a-8c15-e7a966741833@kernel.org>
Date: Wed, 4 Mar 2026 10:07:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 09/10] powerpc: book3s64: Make use of H_RPTI_TYPE_ALL
 macro
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <3fb34ebce6a92855ce6c20326c1f7f99097227e3.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <3fb34ebce6a92855ce6c20326c1f7f99097227e3.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m5w4u5keuyfyndaaa5wqjk6du5az6i73
X-Rspamd-Queue-Id: 5D76C160007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772615234-705748
X-HE-Meta: U2FsdGVkX19Po3FH4VmF/SgTQXMLuT8Uzn2Cj2KtrD7I4rPGEhg/jEeBde6f5Q2ln3FuLN3IGeCkV00lqAnCYxV3BHOHkg/61YKrM6oG+m5qY+nYk04TEMP/7Sb37u91OTxD14tbwKJaHeEi20MrcZKj6h5LLBKEIf6iQwAyVv6baHbP+dWYJv4gox6twgpx6DAH91/92sn5IcMFVgabNJ41HxByhE8wqrZKNMvGJuEKvyetpbM3lRja2O3/FVk1iub4PUaaJdpSIE8SEtoAWh5Ws10F68JR6T/g21or6/omPY5u+8XLQSVv0maXhd+4rg8V1opA7WJlKztB9ccVfg6AVtaEICiD0UAfltgmV7QZ//SfkkivybDxj72SqU794l++Ov8WCaCYlhYKPode0Wo+Fe3W3klXqScZRG4WJeaI5HFMfWmNqgXgnoNYphJNfVl6gnx5CFatcoT9+GB8ABVxyWWzJzhD/WMuaYikvK85iEQKHQhRh0vwxlG4QnWRQtrfvgNSZET8UFM79lke2zXZPIXoY/3Cl43a4unfv45FfehUspKiC4YRdwsEC9F0X/muzTJ1a3fZBG/I1NndUKLkVQgOrKI6m1yjNhT6jJFd7dmb++GxptUgdAxpO4hSfpp9AZcVsoqX/UQbHIFUACuCpt4rSxD2D/Myn1JMxJl0nYhmmT296/ywTFhUoCSNQZyuujgYWAE0xx1GcdVb0SFLb63gSjrN+SffHzVPkwOntYH0KR7dyZ1JUH9iwHLRmT87+XwhHO+R7CYEK3B2C4EyWbjXh1cA/S1JGP8aNAweCEipyVdIpPqaGCrpuNqxlbzZUWXWSSmzb3+JLgn3GLEx1xiVxKXEGfrD/Vnd/ZIwa5eCFmTOlOBwVhCLO2KLgJ7c6QQoE8NvnIiK3MLyQTZ8HL5bB1iGZseBAyg4iHn4VampXNXt/LEsORiDjQOo7GIxzvM2kl8YKW0nWwq
 lkb6wQCv
 XRBz7t+Sp6BUqtuHJ7rbWYbk09QL5URQRK51lZjBasqZqZie8rMWucauiXmXJnZ1P9YNi657QEG/frmnKAb0EopYfD7z+2Orj/PR/KyQpVtjClsFjpv7BtV7k8BdoTDdu/RdHTQCa6JKRFizaMtciJ8DECeNCGhprcMHDDnptZ2nNOVQgXVK0CYXJKhMo1aa6bEFUHLMXS4U+Gsin2Yn25cpTZJshP8uWK5IQrMwhx4qAI2ZjE5fRwLCKV1deu0XJxqa3Cl7axdte1TWoUClPllOT5FOs45UFfBNVKuP6s20dn/avRqZI5pzMhY14raepAIdNJo3odMqYBb9HSEWU2YMr39cEpbdDZcjKbGXDNKDx8Ow/ksh0SQvWBZYiqrDAy6kbGDKTo9rXRSklvSqvF/NQCaoZgbbvt57KcNbGwOp3cT+cFrmUYeSK2kqP75ypR5E+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> Instead of opencoding, let's use the pre-defined macro (H_RPTI_TYPE_ALL)
> at the following places.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/book3s64/radix_tlb.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
> index 6ce94eaefc1b..7de5760164a9 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -885,8 +885,7 @@ static void __flush_all_mm(struct mm_struct *mm, bool fullmm)
>   	} else if (type == FLUSH_TYPE_GLOBAL) {
>   		if (!mmu_has_feature(MMU_FTR_GTSE)) {
>   			unsigned long tgt = H_RPTI_TARGET_CMMU;
> -			unsigned long type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
> -					     H_RPTI_TYPE_PRT;
> +			unsigned long type = H_RPTI_TYPE_ALL;
>   
>   			if (atomic_read(&mm->context.copros) > 0)
>   				tgt |= H_RPTI_TARGET_NMMU;
> @@ -982,8 +981,7 @@ void radix__flush_tlb_kernel_range(unsigned long start, unsigned long end)
>   {
>   	if (!mmu_has_feature(MMU_FTR_GTSE)) {
>   		unsigned long tgt = H_RPTI_TARGET_CMMU | H_RPTI_TARGET_NMMU;
> -		unsigned long type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
> -				     H_RPTI_TYPE_PRT;
> +		unsigned long type = H_RPTI_TYPE_ALL;
>   
>   		pseries_rpt_invalidate(0, tgt, type, H_RPTI_PAGE_ALL,
>   				       start, end);
> @@ -1337,8 +1335,7 @@ void radix__flush_tlb_collapsed_pmd(struct mm_struct *mm, unsigned long addr)
>   			unsigned long tgt, type, pg_sizes;
>   
>   			tgt = H_RPTI_TARGET_CMMU;
> -			type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
> -			       H_RPTI_TYPE_PRT;
> +			type = H_RPTI_TYPE_ALL;
>   			pg_sizes = psize_to_rpti_pgsize(mmu_virtual_psize);
>   
>   			if (atomic_read(&mm->context.copros) > 0)


