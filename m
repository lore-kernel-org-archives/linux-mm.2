Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D15CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D726B0323; Mon,  1 Jun 2026 07:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2DE06B0325; Mon,  1 Jun 2026 07:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CA36B0326; Mon,  1 Jun 2026 07:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCBFC6B0323
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:06:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 928511C1BD9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:06:36 +0000 (UTC)
X-FDA: 84831065592.06.CCEA520
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1EC2A0010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:06:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6m577Xd;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780311994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QmX1T5Z1Z1Mon9lysEvu1tgyuq7ma2gqfZkpuoX2E4=;
	b=EYId1Y4+qrqA2Ux0HpGeya8RhTHfeXq/M+Qmr9KUqslsh2X7+gDkcFsstVbrWJuuOTDVze
	BIPiH5+kwsj35X+momq2JRN5HdZzAm1Zv78qdhAif0l++tT7n2CQMTn3wKfN25Jwg3FC25
	H4wCB8tqIdvRS8PCSkaQRVBDyFdM9ro=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6m577Xd;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780311994; a=rsa-sha256;
	cv=none;
	b=U+x7p0NSLeDDKEb2EPngOJvNJtHdJI6hzX4ti1/q+tVfhdIU3O3sCxATmDwu8nizMLOR+c
	P5qlew2RPVxWIccPRdQr2dj+k5yHVXR112QML+BHnHE6/+yX6OYYUfupKp98bLtsxXDK0b
	AvSk8pKuoGFE8cXFCayQeLlqfHv8m9E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 064561E7D;
	Mon,  1 Jun 2026 04:06:29 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E1123F632;
	Mon,  1 Jun 2026 04:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780311993; bh=rIPCRJlF3C5CGybciFVEHG8kM8P9Y/ochm5Nk/iXQLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l6m577XdcFp83GD11AjZtBk9/x8HVwX6Ol04tR2Bdgz1+7hCiLXGiRbqT8axEXbFf
	 kE9xwaZFqE+GQKddJq6yGwpqqS2+dXTVbFKMhcxwC5PZRCgArJ1h64IlrNE8PUE91X
	 p06wQOo7mkNU7qeLlwGG1tCmc9n7PCivgQLkKbA0=
Message-ID: <2000d7c9-3188-4539-ba9e-654d6460e21d@arm.com>
Date: Mon, 1 Jun 2026 16:36:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 13/14] arm64/mm: Add an abstraction level for tlbi_op
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-14-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260513044547.4128549-14-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5rr3zjdymz3izymsr5rqyiriwwnqicfy
X-Rspamd-Queue-Id: C1EC2A0010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780311994-741318
X-HE-Meta: U2FsdGVkX1/EcNxrvMxyRJ2w612LtQonqBIklR13/OmMwsplx4S3pFpVl6hUh9V3vQU9rKAPhyFryMysUIiqzI4pl9TLHXH9vwT094JtZTsl+R8jm4V/DcDI5TDkaefbkMd6k1Zup05rTfbwrA+i8g5VnaAtduqo4KQ3/+jVRBBBazTLgFucrQqjNgHwUhf7BFeSjvX9Nw2ZtRgyzGBRdAp/mRchENPQ8W1DySzYCNaFgd2q7jkohCevy4a1T4xnGV844JyYp5iuVRDLbufLV4eCImZorg8BxHZe5Ukd2sAatUjMOPAGuk7gkV3XB4Ay+8ul8t9s8oW+HxXsmW5VsYb8Qx4OhmOg2T+TJohfjbJEL/rolb4lNT2pvNRm55NWHCCMtdfE1Je/oiy2X0YXZ4QIJVNN2XbQQ1t1F2ab0WBY3fo+FdeFD0O7mEzv8m3hvFe5vzxksjNjGgXE5FWl6NU1oJ9CBsuUZfhHmkRLjI0TAbNKpOJUMl4kRYjwkbvS6TXtTMmDB27IrKmgR4SXoOKn1p96w9maxPd9IsAcYVhk1bMYW5XX77m+MmEqeW1NnB/T16wT4J2MjAaR5trwTTx/Xnk3QT6dU6VrWygwW3aVsNq280NqYUGvoCL3mM9RoiX7SPpa+DetcMDeGYT/KxV7MV3ujM0/uN7YsknNueml8DrLvgVphigQdK/wGkPoGVK16UAKxQK1sD/WAmB+v/csEZrIaWdHxaLaMSiBJ2fJ5VDtxZsutJ/Z3M7O7dyCAAjXrKWZx4qjBaLTduyO1EwBCxTUv1Zgam1KBXi8u1VCLBXIPKQzny6BgPO/wjmcMdlKyxBiwIXV01AXESc8qt/B+tX7WkiQ3qKhSsxTu2qFn4HEF6Fwfl8T6MnZtucbxFLJITBRM56g8LafIT71SR/D+kSW67y6WCNoav6zl0+fMLU64io3lUvemcPwk97XCAwMmgKwS7AZgJ8VBRE
 Nh3ublky
 QPVnIsj2LcI/E8BLFyeQ3RFLtSF2rj9GiLTA5F8XzdeJGu2eZnpyGQ7aU+hQPqS0J4WWEAG43J9JoNiMqj7JrGi+HE/sgib1j2alhHyK6hIZm8/cvA/mpeHQAJI7ZQdg5ZJTAZcZevMXgRfLJgPgbdeL2XoifSA6cVjeif5LrofhfVZ5TdFTR2oKSRDfoYdGGWc9E9Z6mfeYdRFqb1VbrO0uAjNqG1EoXWIVHny6A5/iQwCNzlOYKZBmEEA2baSBp+fJI56t2oJjsPoaosGNrrvaDHv0pvx9k6DZ1KazKBEAn9GlPN/JCqXEZmaz3BJFCy5IASqFmJKnR5Ww6YtRUogzjkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/05/26 10:15 am, Anshuman Khandual wrote:
> From: Linu Cherian <linu.cherian@arm.com>
> 
> With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
> range operations which has an argument size of 128 bit.
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
> +#define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
> +#define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)

The suffix "wrapper" sounds weird. How about "emit"?

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


