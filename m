Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47578CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDE66B0005; Fri, 29 May 2026 04:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE866B0088; Fri, 29 May 2026 04:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4A26B008A; Fri, 29 May 2026 04:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA2F6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:25:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3E31A0DB3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:21 +0000 (UTC)
X-FDA: 84819772842.19.B9ED240
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6F28040004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YgZNzICf;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjvwXdqEq/+1DficM1XZTTUKhCSP4ds5mbTs0wcBq4Y=;
	b=bOw+19FX5gwx8eI4deVPVzt4T5nZvBHwup4OL1FllhADoLDilNa4rRI3P6WLlEIM0uxBHp
	QQOhENwyKmNlU4IxSuExB1zhU81MlskKA5/eR0jTFo6zPWb20mmIaqkxAFp++Ki+OzQlFN
	2yMWphuHcVCLAh3AmD0pBBpXVD5vx3o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YgZNzICf;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043120; a=rsa-sha256;
	cv=none;
	b=nEi455ZILx6B1s5LsQlgCVO9lwnt5OGLIvIqbYBBFR/a1lclvWevBjbj9cevR6C8EiyiiL
	7jfpbNksBet0fsB53YJp1GcO7TU5rkki1kVB6MKZM2VSkhx2ngrOncJtE11/A4q21x28Pz
	DRKfDzqzP0cpHuc+G14ZDPOVP3II894=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22C0E202C;
	Fri, 29 May 2026 01:25:13 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E033B3F632;
	Fri, 29 May 2026 01:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043118; bh=fE3yUIKV893yO/tU1IRXNu65M0GI1yHd4oHW0SZSKMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YgZNzICfhAaEewMLd5sYOiMJ/3HYuhCaubt55GtmzGsIIRiS2/eSAIgolKHy6Ujas
	 R1Xu42Al/6MwTK6QYWiT9p5q5f4DsYTTmioLV5ywaNJQ05OfFjqw8JRvuf3tckys1N
	 E28dqI6faiZItNHpvu6iRQgocCCB1jlpG25489Os=
Message-ID: <23aaeb97-104c-4010-9525-d80922c434c0@arm.com>
Date: Fri, 29 May 2026 10:25:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/15] arm64: kfence: Avoid NOMAP tricks when mapping
 the early pool
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-24-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-24-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hw84e6qy8p5ugczitf3gzhih4q7e34fy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F28040004
X-HE-Tag: 1780043119-880223
X-HE-Meta: U2FsdGVkX18+wWaiQvb2ERd+lGzbSerE+C69vO7P+InszVfv4RLhcHmCMLvPGj3mlPseSAkFXqemmyXUgTNj3GbI/+vGdIUKDiAs1KcO9nK+UTHyvciBOi9jGxwEtxqzqK5/BXXERI5Ecj3nN/1bXDRRpo2hv7ilTXmcjS3bcY1bbT5rmjaKU9141RbRIsrcVXRfATwA/m3ENM9C01HpqBYvAkAasWyaAqzgmqY4JFzmuSyyT4TIibcOPP4Vkd25lbk+07b8G3/ulk1UiH6ar7mRzG51LPW/NI4v/640G6QAncTBGmiXQ+/l3fczPfgK4GJtVKS5+A4Sut+Of/rHqWAl+uhDBASxe0ahNaCnHAjgN84auwPLPIAKPIjriHIqvQ9xdUvp536K5pf7La9W1RN/DhP/vivlFpNmP+Bf6UCJYMkYQnMtJrItp7NO9/+ncd5jCDM+B9EzEH7yNpRLK9SJosI/dtmU2ty4shVNqwo/bsb8m5/W+Wi8mvXlKHThESU6Z3tSAnKyI7Z2qAmOBtKz5mFbZrTaCw8P+UuMwnrEK9YI1KaqXUE5n7M/J7liQhaR0thjxk05cCpXhXOe8gUSGxf0IfKOORXLtuCphZN2w4Mz7eRwXV1iJGWtVCQ/NIejpapiOV25nkagIRTGgNmT1H21TS4olz0sEMdrGw3eOjDgAbSyUWQCrgDjVEowUetDLCY/r9nZVcx7wvIqnNsjp4BsoptMIaJ2ptHZRe2tgkuMKILc1xwdOpVWX9nkBlMDt+bPq06jat//ZJyiWuBx+CF37Ip0yIiWaDYR+9BTKfBfNSb9TKZdUNRUXhVLubwcaDATKlEOyVZS/jaykg3b70P9v60NLDQMAGpmD3oWtXQUUhMXjVdYTSgLNmOST2kaMAjXOaAoL/Nq0+LQZDg4sf1aPcwBsxiigyI9qcf4khc8wHJFXH7R7N09LGLWncGrKz5nAwSLml+Z1Cg
 9b3set5/
 t/W1zHdNwmfP7xgNdIhTPTjF2pgxhLcMuFQfdhzmWyW8pDBk3oDj2QFLvTrkgurz+ObpooAi1ghj8zHLeAJ7hg/z4+P+R5/b9FFzntPTE5krZ4DbIlywJ6kblhJTTnwVGhJABW6qVplSpQvKn0fvETtVwu79DPEvpDJdQSNN9AuBCKsvxovyTrgUqxfsoIVfSeGi2EA4AJgDWojzhFE3T/k7TUjkKPlU5duZVPeEjtFbOY1L2fHghhvxTAQEetS2pvqud9EavNTG6RW+3PxIxHpR3SmXXOCxZn+S8utobQJGYS7Eub0tPqWW5CwJf5vnm1TgR0iMoRmv2PGL+WByiE/sUmvVqo3CL0IH6geYwHS8Hpx7zYieLWPaif/JYpdlf33cMxrGCtqjmIGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that the map_mem() routines respect existing page mappings and
> contiguous granule sized blocks with the contiguous bit cleared, there
> is no longer a reason to play tricks with the memblock NOMAP attribute.
>
> Instead, the kfence pool can be allocated and mapped with page
> granularity first, and this granularity will be respected when the rest
> of DRAM is mapped later, even if block and contiguous mappings are
> allowed for the remainder of those mappings.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 25 ++++----------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index d7a6991e1844..55bb40348a47 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1083,36 +1083,24 @@ static int __init parse_kfence_early_init(char *arg)
>  }
>  early_param("kfence.sample_interval", parse_kfence_early_init);
>  
> -static phys_addr_t __init arm64_kfence_alloc_pool(void)
> +static void __init arm64_kfence_map_pool(void)
>  {
>  	phys_addr_t kfence_pool;
>  
>  	if (!kfence_early_init)
> -		return 0;
> +		return;
>  
>  	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
>  	if (!kfence_pool) {
>  		pr_err("failed to allocate kfence pool\n");
>  		kfence_early_init = false;
> -		return 0;
> -	}
> -
> -	/* Temporarily mark as NOMAP. */
> -	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
> -
> -	return kfence_pool;
> -}
> -
> -static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
> -{
> -	if (!kfence_pool)
>  		return;
> +	}
>  
>  	/* KFENCE pool needs page-level mapping. */
>  	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
>  			pgprot_tagged(PAGE_KERNEL),
>  			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
> -	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
>  	__kfence_pool = phys_to_virt(kfence_pool);
>  }
>  
> @@ -1144,8 +1132,7 @@ bool arch_kfence_init_pool(void)
>  }
>  #else /* CONFIG_KFENCE */
>  
> -static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
> -static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
> +static inline void arm64_kfence_map_pool(void) { }
>  
>  #endif /* CONFIG_KFENCE */
>  
> @@ -1155,7 +1142,6 @@ static void __init map_mem(void)
>  	phys_addr_t kernel_start = __pa_symbol(_text);
>  	phys_addr_t kernel_end = __pa_symbol(__init_begin);
>  	phys_addr_t start, end;
> -	phys_addr_t early_kfence_pool;
>  	int flags = NO_EXEC_MAPPINGS;
>  	u64 i;
>  
> @@ -1172,7 +1158,7 @@ static void __init map_mem(void)
>  	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end) &&
>  		     pgd_index(_PAGE_OFFSET(VA_BITS_MIN)) != PTRS_PER_PGD - 1);
>  
> -	early_kfence_pool = arm64_kfence_alloc_pool();
> +	arm64_kfence_map_pool();
>  
>  	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
>  
> @@ -1210,7 +1196,6 @@ static void __init map_mem(void)
>  	 */
>  	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
>  	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
> -	arm64_kfence_map_pool(early_kfence_pool);
>  }
>  
>  void mark_rodata_ro(void)

