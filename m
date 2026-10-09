Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588AFCA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAB06B00A3; Fri,  9 Oct 2026 16:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2456B00A4; Fri,  9 Oct 2026 16:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA736B00A5; Fri,  9 Oct 2026 16:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1723D6B00A3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:38:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8763FC04EB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:38:35 +0000 (UTC)
X-FDA: 85304250990.07.71FDACE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8E5C180009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:38:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvqHjuD7;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791578313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/LFL9/taYy2cwYsCSPk5V+auF0O2Bb7JZnwWhgA5BM=;
	b=ihYtekiWxqXXWyVIg5SyMZlDhnWnGahLFm1F1t9D0DGXxS8LbNsdLp6muIWSKKIN2JsBaU
	ugI4NAcn2/HH8xI6fUTR8Kirp/tgCNOinwIvFjAdV9cPpftSw3+nzNAs3eH/ytgK9Z3ugX
	feUJjAUmCF2vyFSL1teMOB/01zWPut4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvqHjuD7;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791578313;
	b=G7OXv7RmEDWJgtQkuzin1Ky/mj0MQrbJTtjWbE+tjxRBd+9TBJBfxioVVdK833gwTEJKUJ
	GtKlbz82MbuCMn4Lk0LH9wCuPxbw1lj5kTUSXizrqU3uVXV19u9WiOtSiCBims3Yo4YQxD
	IBtnZAJTBb3CVTrCcENgrbHfJKyABiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68D6960200;
	Fri,  9 Oct 2026 20:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BA71F000FF;
	Fri,  9 Oct 2026 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578313;
	bh=y/LFL9/taYy2cwYsCSPk5V+auF0O2Bb7JZnwWhgA5BM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SvqHjuD7DSfowHNh97rZu6v7FwWPLex9GA7soWzWsQyNKB3v+LPC7fwAAR3ezbMLl
	 erYo4mOcocXZC5ZmtfEJaN41zkSVTFR4PlQmnVVNWNDFcMC12BAsjhJYonIvVvu14L
	 VlwHac6QlAjyMbDCg31XU03b5H1B/dLLPYc1U+rhhQL/sRyHgK//6KHAmxvyEgyZGm
	 2h5t1E1zdqHKyBlZJSr3+zRABa6ESRxS+W2CUpWtixr9tF3hZ5jrpm2HsUWTamEqBu
	 3yusekEt9FrzHkzQMrrH/q100cNJnk9dmxr/9cVSMVjwqE/VO9+dJS/7jbQQhpfhmu
	 myCIGW/rN3tkA==
Message-ID: <32191a71-b5b1-4913-a631-968ec299b125@kernel.org>
Date: Fri, 9 Oct 2026 22:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] riscv/mm: fix missing destructor for hotplug PUD
 tables
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, osalvador@suse.de,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261008073021.2512665-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C8E5C180009
X-Rspam-User: 
X-Stat-Signature: kx6syn34q3m4onuimapajy78tz7a437c
X-HE-Tag: 1791578313-255168
X-HE-Meta: U2FsdGVkX1/8LEoe+58GyQ/Ld9C3/IWPv99fCyUbq0lDVCTjNiEUermV/Cdg+d4HUec14hayyNP7xyxh70fj8hM88qyRzOEFdcLe9MOC6isl92z/Mdqd6DkSx6PWwABIVA9bshp4k403Z40sNaIBCTKbZfevznrPyFBz1HyDFsZK0BczldZ0Dj1sI4zzyqETl3JSLZyy2MZPTqwhLaNeJBra6wa5XU/8n6gzWVv1l21DfFMwqY1W6s9e2Gjv+g7GBLjiQVCUEJX4Xj7ujnWEuvwdbpcCGUIno9F9qJ8nQaWUBpBa8Bcmhj1D+012iYvZK+ZjQcYCEWi+Z0hzB+zhcGDzDAQctY9EZL8CHSEQz2kwDQiEW9608zYL8IGpC08O3sSxm1TxqKolYXA6e3pcPWo8JYeEBNeMDf2lRugufWjct7DJ6Cs79Fk+TLS+DeFniqX5/+kfcKxXBFeRINkJ8zBeM45LaHxOFG+EVuJ+Mnc6cqDywgxftIYmYmsTX5VfakLfxCHtmpIpgf+K1nUtkZJsYmCiyxhmVVoKn5iFFOrLMk249LScgC1j8ludzgDlkeC+sTEIxMXCvpbkFBjzBlPHK1DSoHIRFOEiXuszpBUKZ+aBck1N0IOiOhCKHFv5ZqAhQLxwPagLUrDTzMsmoU+oeEUW4Ak9+NGwboCgMHUchpcvHzqijjHKhBWpNPjSJJ0qZnkWuy4aC+sFXMs/L28uGCF9Cu5jfpx/zxyOL8MoVCz0a8xO2/+7fttpEo45alwe3AipYiDwhhkDtOakUTEf+rT9aCaMS3XA/OBH4rP80aeZ4cgsM0WsvuoTF1q4xCrsI1IfDVLxYUkZzdP7+2O0fa3ehY4VcUiQ9GqHvHBrL3NS0muE3w+UrSl7uZZ2WlRonclw49L68hM1VlWFv3rQSaJbKGR3x5vNrmuRq6aa+HH4VUl7uD54uBcvgbj3MC0G+ZJiGVpB5o7QDc4
 Ct5RLU2x
 GHg4wTYFTNe3rQCvace+w6wrG0q3kbt04Y993ge4uTdXZvemDMnRhtjHvPamJ0JNyxSbYwfsKYhQ0/A2tHJRod0Shn3UO+bD+rg236fA5M9lNQjkn7ovaxn6DScf6GpXzXduKKcTohYreHo/HjPbsAU+17YXQaKDrzzFmO+vgspt3tUQdb/5GX/hYWvbHwDSqL5KDJHKIYL7N9nW4bVUgGFXj+SwK17ru+2ThsVZa+/YHJcsS1nmsUNnLP0j+32C9UJVHTttrZK+uchZDmlpZ2wBv2P27Zf7oI1lGaZnlUshaObU+1Q9eV6d7dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 09:30, Muchun Song wrote:
> Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
> pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
> However, free_pud_table() still frees non-reserved PUD tables directly
> without decrementing NR_PAGETABLE.
> 
> Free PUD tables through the common free_pagetable() helper so that
> constructor-backed tables run the matching destructor before being
> freed.
> 
> Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/riscv/mm/init.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 429a0b015ec1..62077539ee78 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1540,10 +1540,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
>  			return;
>  	}
>  
> -	if (PageReserved(page))
> -		free_reserved_page(page);
> -	else
> -		__free_pages(page, 0);
> +	free_pagetable(page);
>  	p4d_clear(p4d);
>  }
>  

Routing this through a single helper looks correct.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

