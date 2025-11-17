Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A78ACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21388E001A; Mon, 17 Nov 2025 12:49:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD17A8E0002; Mon, 17 Nov 2025 12:49:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC09F8E001A; Mon, 17 Nov 2025 12:49:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B17788E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:49:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8DDD12DD9F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:49:34 +0000 (UTC)
X-FDA: 84120836268.13.C9DBD88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F3710C0011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:49:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRd80XJu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401772; a=rsa-sha256;
	cv=none;
	b=mL5VcHJ/M9B3W+wJUVL8YlpNnfxAAKrAypfg/JuSHozekn1E9M7DnN56pXfTqkrVAUjpPd
	in4sXZRE05lBWvfv5nSLd2n2qFnT9jKX77P1C+480CVqxksp+9Yph1OQ04RIvxp1dXfj6J
	8Cj5Acm4UtLEGzMXYwtI07aYjqBfKbE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRd80XJu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8J3279SBKJroVGWVtPnPq6BIgbkbOzXXNhJTme8PTno=;
	b=8RxBpQVp2KLqcbEQ+FBegVSSiuMpizCDtn0LBmoqZ8vGyTAvs5mAbavCD3yWGi96khL/HC
	7dgJ10Sv84LNnFl5EEgUOgFEDeo2WNpNHm6zN2t5vGQDryBs+OpA1MvgGE+Xvd9dU4sKtT
	PA5ZdNZMYfQQ2WhmMCnttRnUnFirBAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54DAE60051;
	Mon, 17 Nov 2025 17:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFF1C2BCB4;
	Mon, 17 Nov 2025 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763401770;
	bh=sw/VEsI4xwBHTiS4b7CI6sSKdSRzzaJkWSJ08JK4UPc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CRd80XJu4jzPfgRemoUpSPvnlDpOt6p8SiVSIodbS0bDi0kGr+YZ5ibn5VdzOaJNM
	 xiAXeBUC5V/lY2oUvsNwb0x0hC1gZFdS5b32Fvuy2m0r+4F3mr3Ug2rYZC9YrpPxTb
	 Z6yLUxIN5yxQylOFZlgX6yUk9ewEqI5oYQIGfmuFmu17ejORnfArdkkjJApftjTFFJ
	 7v0WQCMZLeBOoz20FSd6EaPvcb8VaVCD9jobDAmTk0AXFIkvRIm3ri4nEDcyAwMbGp
	 hkjPUyh+74oprkN24Ty/8egYZiEmmwydtwIdd2O6kCJrEpepuwJHbiGdFZZWK3Gpx6
	 jfq9UNShdFC/A==
Message-ID: <58caeb32-f50a-4056-828a-476d958955ad@kernel.org>
Date: Mon, 17 Nov 2025 18:49:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 10/10] mm: thp: x86: cleanup PSE feature bit usage
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <8dc0695aa1c1073ec475be18e300ec1046344e84.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <8dc0695aa1c1073ec475be18e300ec1046344e84.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F3710C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: jskfuesoxmquoakx86jps4f1bj6kc4fa
X-Rspam-User: 
X-HE-Tag: 1763401771-480870
X-HE-Meta: U2FsdGVkX1+3ZdGF49wHDR2QgUtlPcKlk3ZBsyoFPUCWh0kK/80ZTV1twRq5No+5WU8byKxKkSiPGfsUulgwhwM6S65BQCXILwlQZwXitHeGLTYZAHA0hWlqNoi3O/35Mr1SnJNtCiV/GFGHycnWCH2mAHNgqFrkqPTAEAyrUAYOebpsPfEdlYWWJo99mSf1dWjPGaMHNrWeiyNPsO8hk9SGPS7lJ8X2UOK0qi5Jc+nTFPwQrlEjWoFBOq0U+iyBbPy3vyCf3hADd1LrNIy6z6yqNTpV4lEagmYayZATG1/KUTTqmtMkNoF11h9Fd9n3Cv7DKS72OQS3f7zLKRiuq3AH3VaQCQKnKJ6i4qqO5glbPFFw6cPSJ6TqBkq4RoeDLp7SxLj3Bzb820BrQbgaxsoPdwFY5zkLoCso3X5dadi79JuUKoe5kXhByaGa0aLFRNo8yENaYmBqeG1XUNluWKSF1R3zNJE5DVkOpjnq2tKhn05VM2TSOIn8sHAaFuX9T+mLwVvtSZCKOkGVGYYZRKCds/wXExxkckG8HJeZQSyWmwghG7uLhrkqc1smyFo4896uRiBg2tUvamui8acleO7QF7NF1H7deJP/2D3FGxsGZ/YuAhQH8s0h4LoUKKdKq+VYPtLq855L2Rt+YALsNIRuA28TcfWMy0yHhdFAJQbmDeuWVFknKkccdonSSyNNY7ulGVaquvtUTitK+1X+7cg0tW+3H1UwQbYY21DOO8tdeIT5d447lNNv8RKWtzhnOoBkNR9VP5yk9v+8wQ11gj0DbPbzGRGbMc02bwkSNkvUGpkOe8h/G2NA/vUbRNtxFo6e2psycjmZBz3ZFpY+ahR9TAve7QK2NNpvjpDzLK6q9i1D00iwoV/9rVhvOlk/2tz50XK4x5I6xlAMQzLrtlzgx/Wp6ia1RgxbztuixN8fMW06/dnk3ZmVIpQJXFeBK0yRvngMDZ1ShCZ/Sbr
 /AGUTGVY
 OsFJKW7ir3cbl7qRgb8dul68+NStAj7HRiiSbZQNvYeseRhfpxJ8LtqZcMpMPd6kgQ+iwbJtcKmEhyLaeAAhLTVA75jXmr2Wc/x4H0mLDWQYe+o25sq5OvEJEHpdRCB3QlajozMwu++1PIP0cGuNsJZOURdpnVVAsBKCqoj4L2mFXl1aeREnYtxiDVOhdix5aBnhmL5psaqIl2be+U9OLbudY+lKA0fujAn6tu0tSZq4E+5UQKyLS7/85X86V11gwwsnzBwFvI6XplJzMXHAfNruwqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> Historically, THP support on x86 checked the PSE feature bit to enable
> THP. On 64-bit, this check is redundant since PSE is always enabled by
> default for compatibility. On 32-bit, PSE enables 4MB page support and

Or 2MB support with 4byte PTEs I guess?

> must be checked. To clean this up, this commit:
> 

Likely the subject should start with: "x86/mm:"


> 1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
>     we assume PMD-sized pages are always supported
> 
> 2. Checks for PSE only on 32-bit, using arch_has_pmd_leaves()
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   arch/x86/include/asm/pgtable.h    | 6 ------
>   arch/x86/include/asm/pgtable_32.h | 6 ++++++
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 08d109280e36..55b88de5178f 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -313,12 +313,6 @@ static inline int pud_trans_huge(pud_t pud)
>   }
>   #endif
>   
> -#define arch_has_pmd_leaves arch_has_pmd_leaves
> -static inline int arch_has_pmd_leaves(void)
> -{
> -	return boot_cpu_has(X86_FEATURE_PSE);
> -}
> -
>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>   static inline bool pmd_special(pmd_t pmd)
>   {
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
> index b612cc57a4d3..3bd51cfa431e 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -45,6 +45,12 @@ do {						\
>   	flush_tlb_one_kernel((vaddr));		\
>   } while (0)
>   
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
> +{
> +	return boot_cpu_has(X86_FEATURE_PSE);
> +}
> +
>   #endif /* !__ASSEMBLER__ */
>   
>   /*

Right, IIUC 64bit should neve rrequire this check.

-- 
Cheers

David

