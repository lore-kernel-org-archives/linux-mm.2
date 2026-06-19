Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C6BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3096B008C; Fri, 19 Jun 2026 06:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BEE6B0092; Fri, 19 Jun 2026 06:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD096B0093; Fri, 19 Jun 2026 06:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63B956B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:54:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CED051C17F3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:54:32 +0000 (UTC)
X-FDA: 84896353584.12.85C193B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id D91A5C0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:54:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cQig9C/3";
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rwn20ez+dkw7n0xM3zxrVu1oqGgCVumFyniEBZtAK6E=;
	b=T4+7ey+M8zMhx8OlQV8LYRC8vXD9AAix7EMoE4JjV4ETYKniam1Efd/v1tsT1XfnLj+kjB
	dJK8ITuo91UX2AwKOGJJRY1cAdNt7fKJUm/X+oMKKD9fV41UdV/2FsacQQJL9jUrDfPPLF
	LTviBwVGbHFQmE2KJZuuWkaz/vkO2Wk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cQig9C/3";
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781866471;
	b=S+VCQHDPrFpXu/caIJCFqJyNRkkBr/YDBi/H2PmnJgPtLHRj+lm8pqKEh3Bd1qErBjM/7R
	tK1Uw2nPe64B6edQIUT54LAqrepn9NKafGrVYSSBXTPRXJk+1teaXTuG5P/PHve2MA8Rgo
	apNnEexv3YHm4+l0xfWi75gTsaH8EoU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 038F64746;
	Fri, 19 Jun 2026 03:54:25 -0700 (PDT)
Received: from [10.57.95.87] (unknown [10.57.95.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84AEF3F62B;
	Fri, 19 Jun 2026 03:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781866469; bh=s/f0450p0ipSbzYrTpx30RMlCwIeDpJgQBuLFxB4f7Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cQig9C/3Fs4Qsg3hrx+5xbicCCSIKr5aSxpLihZzHe8fC1h10xTpW06wyAf+FOgzN
	 0VWqHPp9X59AbrLIvGz1bDw0Y4D+QBT9CI4GqxQgwombbv6UYoI/y7JQagrlImv0Q8
	 oradQ4Huu+YwiwBD4+kTthIp6ifhKWoeejJoStxQ=
Message-ID: <666a981f-44b6-4c19-a641-c1eff44fe54f@arm.com>
Date: Fri, 19 Jun 2026 11:54:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/6] arm64: mm: add helper to fill execmem with
 trapping instructions
Content-Language: en-GB
To: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-5-abarnas@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260611130144.1385343-5-abarnas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D91A5C0008
X-Rspam-User: 
X-Stat-Signature: bwj3zctthjrydzf1k75kuis34z6ujkz5
X-HE-Tag: 1781866470-653348
X-HE-Meta: U2FsdGVkX18L/4N72jnBgpiUKSHSHv17TqYK6pr8iVDVGC5skdIYN3qYinnZ+n1ICwlHNwvod8RQAkQYphYFtuDOU3R56FfNCisp7Vcnr+usfCA+Xt8y953+RY/z6wwBigwj4/QLPctq6sz4EA8xD10NOAHqYktwFosz/mbq4WkHEn2xj0Wv0cSwoucmAXNkpPJDdYq13vhHl9/GtvGzpugUvHby27u7INs3DZh6jxrtG5x88874WipBqtKLhSd32eQYMbqQZiq/g7xqvdAxQZWArfRBhqQqjMvmdUMwDZfFbsHqAgDJUB6iXdp+ACNYiKRijR5X0X9VWlYddtHogsuBDbNbNJTZGn1Al3c3uJHfG9VqvYnPH6KXQK6oM6UAMODRkDsmHta5GqrYcS/FGMGq1H6bN5XRr+CG7g9xndQvTu2YNuA2v8zBAp8M4YfzXuGx4mF3QAQk5MG5GsKqti5LcYT2nrB2sBcOYn807B5MVpO+1a98CDU75c5OcOpZHF/K4LgIZ5JNRZS9sBzfQEnqRz5H5eFnkvspyDFy6dRhvIXnWL03ceJsyzNMFMBb4iz1NcWwXF2/F/prs1zsovyCE8eiff1K5rGy5Jg2ch3W7iMApB3RCGigrHx/x4n9N5ghaPeqZ5ku8uXKL9tCr2GutTaxGxrbgrJUJaypRBHprhtD1OPeNRkjM80T1j9EqCYtcLexkMennKvJnoSWazKc9iz0C/nFqctQSP1QmAnMu14H5TsCsYshQptse1CNAnJ5N3i8jAol8++W/gcyctB5n6tzWHjN1s+Q1qD2xefn+QhDfSt9D6LI36Y2KG/G+lfjtmyWXV2tLdMtwtQEeHt9IgWmY7M6CHZ3YTZHj46Mdk7ifGlU25MHM32B3HXwn0B47oUO7kYuCpbTxDhm+bJMoFam67UzGqGTY34YgVig8MUUsr2OKFAX1nGiYZDDR8wJmjFH8j3xtukyvBT
 dLwc4RrV
 Ge1SkGISzOEJd7BOLgyAYK4w18VRHer2qix7Lj5sqiL0sxFnBulI+yUp0mvqoexDkVikLBtTfOKADWyN6d9cWN1E7cTXsS0G9yLw34pFourLd6Jo4KYuy0fBlUyjstALrYvw/Q90eJwS9V6Favu5Hs7txJNVZ4WCDTI8MnkckBAXQVd3MuzqxPATozEBltmBw7yVy9LqoMnufFpx2kSLGe4s5jQeWt9rStPnoMsxAHohxSC5IF57hRj7ajWGwFjXLRT1d/2XeOezv8sHvKu8Sx8cTNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/06/2026 14:01, Adrian Barnaś wrote:
> Implement the architecture-specific execmem_fill_trapping_insns() helper
> to poison executable memory regions.
> 
> When CONFIG_ARCH_HAS_EXECMEM_ROX is enabled, the execmem subsystem
> requires a way to fill unused or freed executable memory with
> architecture-specific trapping instructions. This implementation fills
> the specified region with AARCH64_BREAK_FAULT instructions and flushes
> the icache to ensure the traps are immediately visible to execution.
> 
> Signed-off-by: Adrian Barnaś <abarnas@google.com>
> ---
>  arch/arm64/mm/init.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index c673a9a839dd..71aa745e0bef 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -408,6 +408,20 @@ void dump_mem_limit(void)
>  }
>  
>  #ifdef CONFIG_EXECMEM
> +
> +#ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
> +void execmem_fill_trapping_insns(void *ptr, size_t size)
> +{
> +	int nr_inst = size / AARCH64_INSN_SIZE;

The x86 instruction is 1 byte, so it can exactly fill any provided buffer. For
arm64, the instruction is 4 bytes so we can only exactly fill the buffer if it's
size is 4 byte aligned.

I'm guessing that in practice, size will always be page aligned so we are good?
Perhaps worth a WARN_ON_ONCE() though?

Thanks,
Ryan

> +	__le32 *updptr = ptr;
> +
> +	for (int i = 0; i < nr_inst; i++)
> +		updptr[i] = cpu_to_le32(AARCH64_BREAK_FAULT);
> +
> +	flush_icache_range((unsigned long)ptr, (unsigned long)ptr + size);
> +}
> +#endif
> +
>  static u64 module_direct_base __ro_after_init = 0;
>  static u64 module_plt_base __ro_after_init = 0;
>  


