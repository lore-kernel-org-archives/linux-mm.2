Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E00FC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB896B0088; Thu,  3 Sep 2026 12:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64BA6B008A; Thu,  3 Sep 2026 12:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06856B008C; Thu,  3 Sep 2026 12:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A94036B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:45:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36C99A0615
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:45:49 +0000 (UTC)
X-FDA: 85173027618.11.835B2B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62E4880003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:45:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SR7TXHUz;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453947;
	b=a9gHRRPhVBfUi4i5X/I4zEIeR7YEILxq6kO8p+vcY2/6XSviIW+rp47xDhov6ErKOMq3b6
	cFzoRcB9p8gsgJgfOBpvTIfcPEKRjY9ZtAaTqJOxxuDR3Jih0VOauYGSxL3tvvxIxOj0xx
	Nbsqj+AmsPU1h+6IXCGnNjWzDedUBRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrUmjCwjo5DIxJ+vg0Sk0kvs/Wk7ygJAVHNpsizTEFY=;
	b=pVHzSqxdz1P3e19H3xA/TP4aLIFdlV6YWsAw+77xEux7A4g6L2H7jCKgxpHUH/u39mnCZY
	ouWLOU4D9e/+asbeKaguk/8PKet0pcUOtCJiN/55SDys2Btg4JSIrYycOXWBhCU6sXrjsi
	MSs+o7tGPvNLme23q1X2HJr8FsSkxC8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SR7TXHUz;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9D931596;
	Thu,  3 Sep 2026 09:45:42 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FBA83F673;
	Thu,  3 Sep 2026 09:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453946; bh=/CRbtrA+vjZ5tpi+PPVd9H6w5y8wPTba5LjyadUSSnA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SR7TXHUzQxDvckWQXIc+kCOdTYGWt1Gaj//NszCiurRY4Z6SAdqDJlunSvSprXTnD
	 G+ho6hqXrCwCQrp/yne6kVlqaExRdp+vclcF/zIL/zaHD1NzPhiw1MEKzTFaOYDgfu
	 46QXLVXyg1Xi5s2nfL5Qn/gtPRKd+Mye1S/UAGRw=
Message-ID: <139b273a-d868-4d82-92b6-cccfb0048c44@arm.com>
Date: Thu, 3 Sep 2026 18:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 08/25] arm64: Initialize POR_EL1 register on
 cpu_resume()
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
 <20260818-kpkeys-v9-8-743ad31b2c8f@arm.com>
 <apkMDaRKqX3TTINV@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apkMDaRKqX3TTINV@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62E4880003
X-Stat-Signature: gqn8cmimuaa3xq7964d7rr7wm9xpkd99
X-HE-Tag: 1788453947-397721
X-HE-Meta: U2FsdGVkX19THjbbpL5lUdw9rZ4FseUJKldY9b/AaDNo5hyY14+gkACl1b+Tm4nHUYPYjSRBlqceTf+lA/1HJbaCThlbP6JBV5mSRTByGC2A040WGzDLzttRVwL8T7FMP5hRpXkEaFBnBIn7juEiXP+wvN61p0ipklub5L9hIhpvuJeNJGJARme1sC8SmAQ1HvM8qRFNVOTNQZZld7cySCROrKyJ6RfihfQzIkHQS6qcbNcj0FIGOQwY1sLVPgYHKLDdXW96QEuId3i1GW0pMEZ4NI9c6vrw4As+psndW25f1vNOpPdDyZvIHlfGSXWPRo8KRt1Zr4vPg+FdQjhZwmKyFGmMyxbxn8Y0N2e3PkxuCXbe8VtdZOlzI3td7L/+cCAXPTiAtKMgXN9a8Dw81lznoFqfl3p2POsioKzc9zY3RCiLTq8eMtHFsP4a1AAsfWZDU5NiFkKWg+mHGkxp4wDmiLQ9fJ1lp56dooek/TSVUlN+NRjgq2ZjpYjT7dEL9pqDxzUlzycMU3xlMGHunVQNbLfAGwd5zPgT+L2zA0Gi2X4xidygqwZu/Abyi7uP8d3PlNK2S6SIcE9SGl0OTvVt74owQ2Vzyf2Z2jtux452NtWDJme/CzDzCH9SQF3TY106mr62YzQTv5VxTD6koAJ9QDaH5fhe3CQOFN/hFwVQk+i/GWFtDk+h/LA1odwheKp315eMzwjtSfkOjX7amb72aTRUK8ZiPJFEnVdkoHSzE+D2cPo7h2XfAiEl01p9IwcYrZejPRmZQg0KYg7KUnVn36kFZ3ADdIjJMihA888QHJbyJFzQYIBL34DJdOtLz6XG8O5wj8obQQrLrPQQ7P1hgEXQPg9Jl3mBctK2rNm1hmAiVTOe49d0j2qn6p5S7RtIsHcJxQIoES3/lO4QgKFSk70LSjsBqApdISr6bivJLZhQw4vvGZMDHVUjZ5hHjBa1EIlET6snrqwsecO
 ZeHeIKTJ
 UXKoKr3hkkajGWLF2u4NG8g/fkCp+hSpzoP8vhYe8/PvxfnrFgYecrraBrwzblUFpzarhrqTHjiqbPNfqHC98a/yLQBCgpi2a4zWX5aJczoooGUH62VQzcoCxWsj+ejk5+kmnOq6+Kzs0BGnVMsQ/vHjYza51jE1pWSH9+JJYINCneKKYr6egQD/NX9Jn43jNavnMisFzd+RWEPkCqcFlLUJh+xug9UVuO2vcew/V2qMz7+jJc53zkFXaJZ1UD6gpakzUNzfD6715afFnPdFE/i2k5bsAoHKLiazNLQo4YqHJwfEnNy2vCquP5W1bl0mi2s1YLrWh9kQV8pRhSdaZDevbX425yTArlx/vgWusFIJLrhO45E50Rtimpb51AiUyDPJd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 07:56, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:50PM +0100, Kevin Brodsky wrote:
>> From: Yeoreum Yun <yeoreum.yun@arm.com>
>>
>> The POR_EL1 register is reset to an unknown value after cpu_suspend().
>> Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
>> initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().
>>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/kernel/sleep.S | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
>> index f093cdf71be1..e0a6ad85cd24 100644
>> --- a/arch/arm64/kernel/sleep.S
>> +++ b/arch/arm64/kernel/sleep.S
>> @@ -3,6 +3,7 @@
>>  #include <linux/linkage.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/assembler.h>
>> +#include <asm/kpkeys.h>
>>  #include <asm/smp.h>
>>  
>>  	.text
>> @@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
>>  	/* load sp from context */
>>  	ldr	x2, [x0, #CPU_CTX_SP]
>>  	mov	sp, x2
>> +
>> +#ifdef CONFIG_ARM64_POE
>> +alternative_if_not ARM64_HAS_S1POE
>> +	b	.Lskip_por_set
>> +alternative_else_nop_endif
>> +	mov_q	x2, POR_EL1_INIT
>> +	msr_s	SYS_POR_EL1, x2
>> +	/* isb can be skipped since cpu_do_resume() will do it. */
>> +.Lskip_por_set:
>> +#endif /* CONFIG_ARM64_POE */
> Would it be better to move this under__cpu_setup ?

I didn't think about that, that's quite neat as it avoids having to take
care of the resume path separately. It also feels fairly logical as
POR_EL1 should be configured very early (since it impacts all accesses
once enabled). Will do in the next version, thanks!

I was concerned about accesses to POR_EL1 being trapped, but in fact
there is no EL1 control to trap it so no concern there. I realised I
forgot to set HFGRT{R,W}_EL2.nPOR_EL1 though... I'll fix that up in the
next version. (This has no effect when running at EL2 with VHE so I
didn't notice that beforehand.)

- Kevin

