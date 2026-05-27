Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FBFCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFB86B010B; Wed, 27 May 2026 10:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0866B010C; Wed, 27 May 2026 10:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE6E6B010D; Wed, 27 May 2026 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4B96B010B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:50:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BC9C1405D5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:50:17 +0000 (UTC)
X-FDA: 84813485274.18.3C979B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id F065C20005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:50:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GBpovObz;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779893415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLnZVKfqESsFEaCSgaoUbsX8NkHjUsSMFkaenW2UoQg=;
	b=wWq9DHBy6VgYiD+BAuFH+WMxbRYQ4RS3xEt3OFqgqK0mgjhP0O0yU1HiWQKXGlUKWJS2s4
	kp+eGmo/72GR12hGGGZq9+rwN30p5NSeTXw41PSQCK0qQGtBDlP0VUnAZQHU+lM3URfN1N
	aoCYB0wkhKHemZDD7ckYUPGD0XNX/ig=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GBpovObz;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779893415; a=rsa-sha256;
	cv=none;
	b=QnVJFtnqx88N8tKkYGXakarWSmpyMzLaLy5Z9jtFVbXU6wXtRdnskViXb9q1YHgJMNrjdS
	NIjcJmVso0wWBlFgV/39zkTl9W6ia65jMfBrPyKezuV5nXUT+XMevUMRIXSKOlwEFV02Gh
	ipoxX5PB04ft429OIGtyOMALZLQHyrU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C3A427DC;
	Wed, 27 May 2026 07:50:09 -0700 (PDT)
Received: from [10.1.36.149] (XHFQ2J9959.cambridge.arm.com [10.1.36.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8EF3F905;
	Wed, 27 May 2026 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779893414; bh=7dm+IcWy2GbjTqM6dc0YYdnL44VCkB0uXF4KC7zHDBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GBpovObzipwzMuVhUKwdxq0xb+qG6dGlZTlWziOa4PzM2Gtbk4H7X2unRbm4KEED0
	 Hd2z57o03z6Z1lLdqtPm3oCLclksKwXjm4Z80jBBC0Cj5c+9CnCZ3XAee84XOVk6JI
	 nKXDh2ckmGCYNmYtmQistQyImY8AIfOaJgnlzp+g=
Message-ID: <37917d56-ae26-4789-ac4c-15f8ee12398b@arm.com>
Date: Wed, 27 May 2026 15:50:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 13/14] arm64/mm: Add an abstraction level for tlbi_op
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-14-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260513044547.4128549-14-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xj9c8x6nzqupoa9ubfm7pdakpge88e1t
X-Rspamd-Queue-Id: F065C20005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779893414-54433
X-HE-Meta: U2FsdGVkX1/hFdoIZRydbuMRKUrHmGFE614AAXuGvohjSCHgafbNHMVQtCdbiVGKoWjib2VWQx/kfE+C8BahbQGlmwSshCFx16xj1jH6baN/MCHpgmYeoGC585YEOtp759YEN/zNetXotzGX74EyvUV3YaKsp84eNAoxHn+jN0lXhjuVbPpIAenz60xdD0470uRH53K4Op2GAXRZjwKPC70jxBVZpHW1uI4Id5/EhmJ2yLFTwLOcjvMW3YJ090Qyf/+XMFj/x/o/LOZgNzvXStYeSTCYiNQlpOjKcsLYQSVMdUtFRIAxpkiDwEK5AXJlEN9TE+NYiiiFSYzW+vJOzWIuzK8JrGBKH0Py08ha6PBJvy2TwQL7Cg5sxE4QG4gbkkXsgL1Q/nLTfqUXk/co6p7AKItpvfIGnjgS2E5EXhSVyBaJLQ3eQIpJU9HysSfIE3E0RbZ72d6TcEN5MfFe7I1c/moDeXj18QHRw5QER4xJP6Ym6rAyze4wKT/Aq/rEsXYBRD6+3QdgoECj1weVvX6NLVaNeUZjlR2WJAuTXr/hePBr0SkVzxgwaTEFFwM4n0LJ66NGGm4dB9oA2I2ME37GRM8e6GFVqUShfYFQEv4G+lef9YIKQymp8TdzghqziWnoIQ8VKsoKl0SDSIUM/8XpN87XNttJ7XI7E54JP+3x+/w0CVac2uOFnAWDehsPXF7hfZ0yK+lZGWlXNMdtCKhsXELtIjlsdRpljcsyGz8U4cFwE+eW8GRdRJVcs1yCy2vptsWlk2waxfRlgHgzhneIu2pj3sKuS9VDrN6cYL+k6jCYSsclaYPzlunY5wjFPtUyk3iIaSt4/JFtNH4Y0AETUz4X1P9IOv0kqPhv32qL0cUoLBcwDT/hWwMt7UeOlyADZTngvpHd38T7eTB6ED/iAdpzg3RlJGTiVsDK951rFLofGaQuNO4UEYro8Ko46fokH3Up3XD5Gs+TL5Y
 +Pl7i06y
 1Fvz88NuZrCwjW0CZC6ylV6v3ld06zkWosjoYiMk09UWZrnTtQIQgaNQAkWt9C9Zvf/CcCF2st9iz5804ItcCqJUMOsPyBWd7EEGRbI8A5Jm1enl2jpbZFtGE4Nok5FjRRqSY/3n75iHCsmVKUk/udGQ2qyIGhbh+wDFAyYseO/ofJqjDk3iTIWvFe3odnCRzo0/gt9albcuVdh01RMqiP2MkWaeUWAfwN0tGYKDwmggynaRIZoqyfPmSKo/MPfSXH+CDv9FE0Cr5+h2/5Gpxmn60kfMuIlVdh2a39U2GS0PBqmBH4Z/+GJWbZlwTSKklZS9fnzBCn1alGZqSSULbh1D/ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/05/2026 05:45, Anshuman Khandual wrote:
> From: Linu Cherian <linu.cherian@arm.com>
> 
> With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
> range operations which has an argument size of 128 bit.

nit: TLB range operations -> TLBI-by-range operations ?

> 
> Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
> D128 variations when applicable.
> 
> No functional changes are introduced with this patch.
> 
> Signed-off-by: Linu Cherian <linu.cherian@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index c0bf5b398041..361d74ef8016 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -162,49 +162,53 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
>  
>  #define TLBI_TTL_UNKNOWN	INT_MAX
>  
> -typedef void (*tlbi_op)(u64 arg);
> +typedef u64 tlbi_args_t;

nit: tlbi_args_t -> tlbi_arg_t ?

> +#define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
> +#define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)

I'm not a huge fan of these, but I can see why you did it this way.

Thanks,
Ryan


>  
> -static __always_inline void vae1is(u64 arg)
> +typedef void (*tlbi_op)(tlbi_args_t arg);
> +
> +static __always_inline void vae1is(tlbi_args_t arg)
>  {
> -	__tlbi(vae1is, arg);
> -	__tlbi_user(vae1is, arg);
> +	__tlbi_wrapper(vae1is, arg);
> +	__tlbi_user_wrapper(vae1is, arg);
>  }
>  
> -static __always_inline void vae2is(u64 arg)
> +static __always_inline void vae2is(tlbi_args_t arg)
>  {
> -	__tlbi(vae2is, arg);
> +	__tlbi_wrapper(vae2is, arg);
>  }
>  
> -static __always_inline void vale1(u64 arg)
> +static __always_inline void vale1(tlbi_args_t arg)
>  {
> -	__tlbi(vale1, arg);
> -	__tlbi_user(vale1, arg);
> +	__tlbi_wrapper(vale1, arg);
> +	__tlbi_user_wrapper(vale1, arg);
>  }
>  
> -static __always_inline void vale1is(u64 arg)
> +static __always_inline void vale1is(tlbi_args_t arg)
>  {
> -	__tlbi(vale1is, arg);
> -	__tlbi_user(vale1is, arg);
> +	__tlbi_wrapper(vale1is, arg);
> +	__tlbi_user_wrapper(vale1is, arg);
>  }
>  
> -static __always_inline void vale2is(u64 arg)
> +static __always_inline void vale2is(tlbi_args_t arg)
>  {
> -	__tlbi(vale2is, arg);
> +	__tlbi_wrapper(vale2is, arg);
>  }
>  
> -static __always_inline void vaale1is(u64 arg)
> +static __always_inline void vaale1is(tlbi_args_t arg)
>  {
> -	__tlbi(vaale1is, arg);
> +	__tlbi_wrapper(vaale1is, arg);
>  }
>  
> -static __always_inline void ipas2e1(u64 arg)
> +static __always_inline void ipas2e1(tlbi_args_t arg)
>  {
> -	__tlbi(ipas2e1, arg);
> +	__tlbi_wrapper(ipas2e1, arg);
>  }
>  
> -static __always_inline void ipas2e1is(u64 arg)
> +static __always_inline void ipas2e1is(tlbi_args_t arg)
>  {
> -	__tlbi(ipas2e1is, arg);
> +	__tlbi_wrapper(ipas2e1is, arg);
>  }
>  
>  static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
> @@ -475,32 +479,32 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>   *    operations can only span an even number of pages. We save this for last to
>   *    ensure 64KB start alignment is maintained for the LPA2 case.
>   */
> -static __always_inline void rvae1is(u64 arg)
> +static __always_inline void rvae1is(tlbi_args_t arg)
>  {
> -	__tlbi(rvae1is, arg);
> -	__tlbi_user(rvae1is, arg);
> +	__tlbi_wrapper(rvae1is, arg);
> +	__tlbi_user_wrapper(rvae1is, arg);
>  }
>  
> -static __always_inline void rvale1(u64 arg)
> +static __always_inline void rvale1(tlbi_args_t arg)
>  {
> -	__tlbi(rvale1, arg);
> -	__tlbi_user(rvale1, arg);
> +	__tlbi_wrapper(rvale1, arg);
> +	__tlbi_user_wrapper(rvale1, arg);
>  }
>  
> -static __always_inline void rvale1is(u64 arg)
> +static __always_inline void rvale1is(tlbi_args_t arg)
>  {
> -	__tlbi(rvale1is, arg);
> -	__tlbi_user(rvale1is, arg);
> +	__tlbi_wrapper(rvale1is, arg);
> +	__tlbi_user_wrapper(rvale1is, arg);
>  }
>  
> -static __always_inline void rvaale1is(u64 arg)
> +static __always_inline void rvaale1is(tlbi_args_t arg)
>  {
> -	__tlbi(rvaale1is, arg);
> +	__tlbi_wrapper(rvaale1is, arg);
>  }
>  
> -static __always_inline void ripas2e1is(u64 arg)
> +static __always_inline void ripas2e1is(tlbi_args_t arg)
>  {
> -	__tlbi(ripas2e1is, arg);
> +	__tlbi_wrapper(ripas2e1is, arg);
>  }
>  
>  static __always_inline void __tlbi_range(tlbi_op op, u64 addr,


