Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90FA606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YEc9uOwK
Received: by kanga.kvack.org (Postfix)
	id 0846F6B05B0; Thu,  5 Nov 2026 03:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034FE6B05B3; Thu,  5 Nov 2026 03:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66186B05B4; Thu,  5 Nov 2026 03:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2D8A6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:19:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C26B2807A0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:19:07 +0000 (UTC)
X-FDA: 85400365134.15.A14A66D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7B7A180005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:19:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YEc9uOwK;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793866746;
	b=BR2EP6sVcJ2GcfOS0gqRnNv4FGjNn4OiD0kwMjvCJ0a83NHWONxNJu1mJzj0m0NTrKH/7p
	PMwmZpNM6GlrPr3P3KP0ELVuuB4DKmjOJVV7Zx7MEBoYHhXmp8X02f1U3W6n4z6cnKKgVh
	DT2IqBzoA/aNiYNb+kOuqHoW/XmTnvc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YEc9uOwK;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793866746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voXWE43TKZzjj6nJV8gFDultxRVrBwVOyi5RshFaUXQ=;
	b=OW3rVBP2olBDZIHwiCVerV0tuW+2xaIaDVrys+Z8FFa7rloxD+uHQ/SKCoGlAkT7orE4Tr
	TJ/7IADNJGKEmz7WN1c4gWGMBU8klvrROpWyL4EkRJ+hpH9ulmNH5j5Yb833f+2fiHQ06V
	PsShUus3GW4IEIxHPF/oXvxBBOR4qMI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63EAF15A1;
	Thu,  5 Nov 2026 00:19:01 -0800 (PST)
Received: from [10.57.17.66] (unknown [10.57.17.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D64D83F673;
	Thu,  5 Nov 2026 00:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793866744; bh=bTT01ldQJro64DbDN3GZnqw1GrxcI2GgeVkpWVQKF/w=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=YEc9uOwKpkG3VIo8BNC1Jc7JWkHGwFeOGrZAhgcSe9JSpicwMRNHh7/SpXxFugEKd
	 E/6WcZEpwSmKf6a6pwXYQ7KDsDvx2WH4QQu0QPTrI2+4h5in1ky6m7xvJKypoPzaYn
	 wAB7G83GeLBT0zBXUpBtBuY78ekPLBN/1DQrDT3s=
Message-ID: <d0e63c8c-ac81-4daa-b359-622f16e91d67@arm.com>
Date: Thu, 5 Nov 2026 09:18:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 08/25] arm64: Initialize POR_EL1 register on
 cpu_resume()
From: Kevin Brodsky <kevin.brodsky@arm.com>
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
 <139b273a-d868-4d82-92b6-cccfb0048c44@arm.com>
Content-Language: en-GB
In-Reply-To: <139b273a-d868-4d82-92b6-cccfb0048c44@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A7B7A180005
X-Stat-Signature: xn11sggyf3fuprto1oxf8eyir5niexqp
X-Rspam-User: 
X-HE-Tag: 1793866745-979175
X-HE-Meta: U2FsdGVkX1+Jn2rnBr0d1bbmoarKNXCEcS5fzkVpt6lyWynGlXtng8LxUiBmytoh79yrEXvneDET5dgeM+C6TmehoSvc7cLJ1ofJQX85uHIsL6QfvO7cg45yHbSYjuOVKLDfKVSSky21vyceQIir/Z0akNXgQgYyLIaOhzHmqq+ZntEEooreAjk+YM8RTUcRfWbTd2m0ZOa8fX8bwBhFUU9EYMyp+7MhxQCbC9OUkO586W6YptKnApZHL4aZ321NjRH/4TNIn8jnw/AYgwYhNFQrNXwIe8VO3IDeFGaLzWtGkM2WquaUbp4bxu4s3iE5e9P5ygfsDXahnAdX9NNj+Nug4+mbNDFgN3GzOflPIC5lSf5w2hwTGhtOI9vj/Zo2oeYrtvxV1kT2zW5KoNWO0hw5qT8kQv4W1fnYYUsMr5yNZmA6jl3gxGUzJaqDKZQD40BJdcKlfaLCy2zbWW3bq259rexdbXsEC52Mrc3SBQ5sUDbNc6XF2fIxqkRxAasFN+3eOImcSMetyWS9f9684G043NLow90wFeX6obFOGHwMnVl/EcH55Og1o6yRY/BaBOrC1w8u0RjyFXYahDjZifZ/emd4Lb2G/+po+M12lnxKbClTuSFGBlFt5YO7KiM3HMkp0Xnau9uf6GOt8z3BZ+5Ik1Y7TgeNk0JL/vmjkzpk5QtpMhrY8epctIqJvu+bpK4cAGlzORgnrmStkhC8tHvxgyb6yK3L9kti1Xd5Bx+a9gOaP4M+EmbtaoW0gnn3B4OuDGHRrh96WRkqvwl3poGmMGZUKYoii1N9QUWFoa60fVYOJyTPYlllokaGu50TO9yFjYgsnFCIBqwz1sVQVCtWqyunxFDjGj4JALbBxHxDN3LBpDgdkIalWqQrGeTDg1Bl1VzvLWYF4xJCH35VxC9ewIVWkMWsoJuN/yKjIEKv27sYgknKR3Gch6xcrSIZZsd+3I4bGNuW6UsJkBG
 GxC5gfR3
 Ffpy+sA+c09NQsnw8hN8UgZeNm+A7XdmuerlcSkGidfr5rB0RE/UuNIE3sBr8rnnpSqD3Zof9TIPk0V7qmMipeowyWD9rTX7XA1iy4zxksioYN6//ekrWdZ8FaIhTUxbqNnHgV79zSoibZmUWLL13G7/1lk6MJh9INxqSZld/4QsdwYP/KMfndZsYAObWWYaltrCK6u5NeUreZXnffufIG6pBFz2UPh46FTfQfPOJTZl1ZSe9raL1Cet40Eav3ZjOHhORd8/sja6z8GUEt6lCbJ8rpwRJnR5I8ZOcWZdMEbZqDumLiFDAhkVgKJn+DrEVsboxq98XvGJ+Wk7Sjf+aTlKzPrzz+7mOndYlTFI/7UlEAcPbYsLV2Qo4n07zc8E8RX7a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 03/09/2026 18:45, Kevin Brodsky wrote:
> On 03/09/2026 07:56, Linu Cherian wrote:
>> Kevin,
>>
>> On Tue, Aug 18, 2026 at 03:08:50PM +0100, Kevin Brodsky wrote:
>>> From: Yeoreum Yun <yeoreum.yun@arm.com>
>>>
>>> The POR_EL1 register is reset to an unknown value after cpu_suspend().
>>> Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
>>> initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().
>>>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>>  arch/arm64/kernel/sleep.S | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
>>> index f093cdf71be1..e0a6ad85cd24 100644
>>> --- a/arch/arm64/kernel/sleep.S
>>> +++ b/arch/arm64/kernel/sleep.S
>>> @@ -3,6 +3,7 @@
>>>  #include <linux/linkage.h>
>>>  #include <asm/asm-offsets.h>
>>>  #include <asm/assembler.h>
>>> +#include <asm/kpkeys.h>
>>>  #include <asm/smp.h>
>>>  
>>>  	.text
>>> @@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
>>>  	/* load sp from context */
>>>  	ldr	x2, [x0, #CPU_CTX_SP]
>>>  	mov	sp, x2
>>> +
>>> +#ifdef CONFIG_ARM64_POE
>>> +alternative_if_not ARM64_HAS_S1POE
>>> +	b	.Lskip_por_set
>>> +alternative_else_nop_endif
>>> +	mov_q	x2, POR_EL1_INIT
>>> +	msr_s	SYS_POR_EL1, x2
>>> +	/* isb can be skipped since cpu_do_resume() will do it. */
>>> +.Lskip_por_set:
>>> +#endif /* CONFIG_ARM64_POE */
>> Would it be better to move this under__cpu_setup ?
> I didn't think about that, that's quite neat as it avoids having to take
> care of the resume path separately. It also feels fairly logical as
> POR_EL1 should be configured very early (since it impacts all accesses
> once enabled). Will do in the next version, thanks!

Turns out there's a complication here: __cpu_setup() always runs at EL1,
even when we will run with VHE at EL2. To make that case work, we would
also need to amend __finalise_el2 to transfer POR_EL1 into POR_EL2.

Overall it doesn't seem to be easier, and my impression is that we avoid
handling registers in __cpu_setup/__finalise_el2 if it can be done at a
later stage. I'll leave the approach unchanged in RFC v10.

- Kevin

