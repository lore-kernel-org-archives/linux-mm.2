Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CA1C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBB16B0098; Thu,  3 Sep 2026 12:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACE46B0099; Thu,  3 Sep 2026 12:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ED66B009B; Thu,  3 Sep 2026 12:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE5F6B0098
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:49:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B005A1405C6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:43:44 +0000 (UTC)
X-FDA: 85173022368.08.ADB6B9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7197C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:43:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="usg/2W97";
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Ede0e387x+HQCpBdPP2HNIRIIInugEd1SB3bO3qFo4=;
	b=aYuxlel11F3emUfLI48+bNAffqwvj1I5NmJlrzDJmnyfWKf1g6mqX10io5dczMWjcEnM3n
	p6f3MDQD0xa+nRXlmAdvjSlujYB7hsmoz6otJVYGhBQ5z38EQC7H5Org0nvyG4kn8RDW1r
	DVPXRWLJ9hyixXg/tHsRV0jSaQr4RUY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453823;
	b=ib9JXn/xKZly/VjtD31oG2rJKhS3qTAQ3X5h90qId1vv//xyTxM4YPe884oVpZDvCsotuN
	XGMMPcwG2VgLw9RVxoH8CT5c5zQCd1ZYTQp/V+JCA8lC0WpgNC3sT1MHyVsIh/coIPd14V
	5gF+sU0hGTKWGFpp9cnOwxtVIMA4f4U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="usg/2W97";
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2372F1596;
	Thu,  3 Sep 2026 09:43:38 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C5783F673;
	Thu,  3 Sep 2026 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453821; bh=LGH60093kePcPptb+SpjSkJD67LELfnSlCC5XNQthoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=usg/2W97KxtpPb0rbSiin0EMXPV4w0HH0wivxuLqD9D8WF9a/IxWQbf33irU5NcIs
	 t+AESg1jykQrwQQ+OpEffiAiB7bjQR5A+ro4tLgjh6rSfVCZ3Z4i+icA8eK/ambLRv
	 H3Q/wAzcDeqxVLbywNWPKevYysTO3L1fWzG7g0Xc=
Message-ID: <5fa69046-e29b-43c2-ba8a-97532251e7d4@arm.com>
Date: Thu, 3 Sep 2026 18:43:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 03/25] arm64: mm: Enable overlays for all EL1
 indirect permissions
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
 <apbkLbO40urPNmEH@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apbkLbO40urPNmEH@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7197C0003
X-Stat-Signature: 5g93w7km6fsfinii5fm1t3qy89w84pws
X-HE-Tag: 1788453822-164296
X-HE-Meta: U2FsdGVkX19SiC1tzL8jPhF6D1lLdg1DYaH0ZHvSVGVwJyA6LfAbYaKkGHxnbQdS8c++VYL607CCoVm3ZELq1TWbjtC/i+vFVBQZuVCDr07iVfTFXev7I45Fhy9SqTwaSz+b8Y1ZTga0/NkkeIktSKHaOBVRqseEm+ClB87XstqQb+tnbqY/kkxIH8AVFu4oSIfQewXIjKOsnGbiqrXniJTOxJ/EgomXmIDpTLB7VwjO1t4GtgY+bNtF/2iHAJ8+qUsLkvvLiEtw6PoJ0IcwF2YxYUK5+bmA3VBRTOJZDdONWG+YxMQJmtQZvCWWTH3LIL87KEO5ojZVAbkY4OGlc4YPGxKyFIeatNQRNUu/s9Hm4coH4By5E82sRtUwd+fqXb4KNcPhoaSePTBB1aUEyvTWQjsWYDAz//W0FwfzlKHyfzZ+y+ygeQfcCEEsuwcErFlseFR22Lc4G1tT0mOzpJBCK0jY8WNZ564V2S1taZ8AMqlb8RzF5tpFCvsZoIkK0XEwf/zqd7BjUxMwx7wAdpkZCuowPpjjaGcxsaprK56KLY4C/ZfNtZCJ1HllUSnA63ORgDgClgcFcIo8/0KEc/xWxuwK4zeM/YRTdooSv+GecvWMVITnK2OVa7Gu0D+728GJ0K7XmgdUqFwdFuqmVfhBmZb7itK/Ud1QUFlEHi8wasffYAbTLc9Y6flXf1KPO0yFfWLcIJ4ufpsli3BMamf7LnRFosgEwBF6kcl6xLiA+ZR8Fnu7ekYV/+Qbrh4s2L3NyE83gAb/sE28y1oyfWkv4pQOyEeK1pE/4tKRX4e6IMotxPSJ7izPR0DKLk0pZeFdwsxJft/2oFGCS3NczUaIYPBh/ndzqZEDj5bjcmsySxVMZAmaFosr+bj1i8x5pMDID9ux1niCDoUv5ycU+TMST+cwduG/TUocLltygCHn46Jl1mf7snUnCOSsgkfi1rmtedK3Y17CdrTz3p9
 0ICB8BDv
 xLs39MtfuoHo9lJmAiDOZnvU9NjuSeKUgMZLgEhpeL1Enh3+sRelG9/oINBRhng7AsV1ryKqz9xBysJTWzQFSMZM2pZ+RYKryJH2y/PAUcnRcfmFl5htHJKNCLB3blY087CcgiybbZ8ThV4+bnx5VMarKF0KUHgUwo6cynbz/U+lXaRKRBPyZlX1jAV+AwJKVjzcfTspt3cX51FK2iFuCF0vDpVISxo7YfnewjGE6rlA3mnZmQgjGtLNZkol5JLWzzEVnSXuKqaqfm9v4lrujiqOLjsWBA8fI4BsreVMB5rDSCW+zGc5J8z81lOOXXFL2sVYG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:41, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:45PM +0100, Kevin Brodsky wrote:
>> In preparation of using POE inside the kernel, enable "Overlay
>> applied" for kernel memory types in PIR_EL1. This ensures that the
>> permissions set in POR_EL1 affect all kernel mappings.
>>
>> User memory types must be left untouched (overlays not applied)
>> because any privileged access to user memory (e.g. futex atomic
>> without FEAT_LSUI) would then be mistakenly checked against POR_EL1.
>>
>> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index 212ce1b02e15..d4d45ab86a5a 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
> As part of hardening, should we really add more constraints to the
> KERNEL_EXEC by making it PIE_X_O.

The name PAGE_KERNEL_EXEC seems to be a legacy from the times before
STRICT_KERNEL_RWX, where X implied RW - nowadays it should really be
PAGE_KERNEL_RWX. It should rarely be used with rodata=on (the default),
see for instance kernel_exec_prot() in arch/arm64/mm/mmu.c.

- Kevin

