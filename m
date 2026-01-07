Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9C9CF6BE3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2EF6B0095; Tue,  6 Jan 2026 21:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9801C6B0093; Tue,  6 Jan 2026 21:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C156B0095; Tue,  6 Jan 2026 21:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 761386B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:48:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33C748E9A7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:48:11 +0000 (UTC)
X-FDA: 84303633582.20.D44B51C
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B2D5C0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:48:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/QfcK3/";
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767754089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFZrV5kmQftGED1K5FteX+JpgExPrbIhIEwJ9SC4Xfw=;
	b=vVFWaF8+bq4NLthMVt26Ftr9aIRYNwPh4deVyyInHi3Y0szi7xddVuJrOZTQeV8j0Jkq/g
	TD3K69L5M04BMfIupHX7G5c3i42PwAjX9tCadT+6xnsWyBb210abGPAnajXbWrwYqYF2xm
	QKhO/FPTz+t7TrpP9TB5kGUH3q7ytws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/QfcK3/";
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767754089; a=rsa-sha256;
	cv=none;
	b=VoFg+svcaGU9qKFwiNicb7idElUifZA9jPF4QEpwIjQQEwpqcKaMhVq1ZVFtYu8+zCMPDO
	I4x2bk9wWKeSD4vzm4u+Lojb2NTK5pNTIMXVfrtBEGL1WsGoYbS0nG7m3u8asGDZgzYjYN
	hMNsDckBUccjTp2wSyqSfpuLNlo7pC8=
Message-ID: <2adc4355-f1e2-4355-b04e-efae4425a3d3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767754086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AFZrV5kmQftGED1K5FteX+JpgExPrbIhIEwJ9SC4Xfw=;
	b=Y/QfcK3/W+rQd+sxRh7PqPbB7Fy49kzT7B5aVJ2cZbpERAqVDPfd1qM1b/TlraC47629jf
	RM+lT+TuFXRJPR0nzpKAcNg9sVx5vSid6LIqjBtD288mC/4iDei3J2SKN/lTaoyxvO0Ejz
	CTPwD00Qi+CedL5Kcx28Z30m1Wz0L58=
Date: Wed, 7 Jan 2026 10:47:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, david@kernel.org
Cc: dave.hansen@linux.intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, akpm@linux-foundation.org
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <a20ab449-e6b4-45c7-86df-bb194304503c@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a20ab449-e6b4-45c7-86df-bb194304503c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B2D5C0002
X-Stat-Signature: 8w5sof6dx33ar8hw7njg84cqjhxnimkt
X-HE-Tag: 1767754088-305976
X-HE-Meta: U2FsdGVkX1+1d/qgEs16q64By8MdgB8z/oCc2ODoYeXhRgP/Vc2KKRkZOXTtlRrABQhOfuK/7NQRD5vaSohyloyCHfwy6IEPDJpEuiBrVg/X/05g9T0FGts6RObgcub9f0HhWzvUtBkc3mj9l/KEFRPJbfSCHjeyvxGq4nOM/vBVAkDUpD25i/KjAf5aEY01t2t3jM+aXvmIIgo9hYPnuG3KZ6Vq1lbqzicQtdj/O907ahQH03/qZlZe/QA1FcqOU/8c1h8K7J53nsBuxf30hl/Pusv716wA5TqTeurSc56gi0ZQbMAgooqQaUzrLY5GaRkWPgLm6C3o521V8g9sl9K8cSfABrcSF/+Z4M+Opcyd2wji/FbcX9zf5CflfNFnK5CU56xnVo4MAeFC7DkJiU0J8GhCIFqCdEt+3mFUBKEzPMFh9L6WyhA2tljsnttbew0+QAoKnfs696ZdO1uFv+RN3a25WjSdNB3tQdyHyoIZA45bBbNoFZAPPPNVjKqq9swf3jR4e5O6PbU5wZf6cQMaFqsbQotBKGK4gZi8AwGPmgWlObvAKcj4E+yb0lJVtHZScaDSah8s5rZqbCHvq5P0gc9WkzX2rNLB7vcRc79AQCfx/XUzMi8COhqaPz47I1tqzTJHSpau0tUMM7DjXZ+e0p7dCOnYY00UnfGyfg5lcMgSRDzYHh+wBs0sSZ6o0rySxiTM6R37uKQhEjy3ZTbh5zFqXOeF9vpEZ86t1VmjSLT+gRSa1WfATEGInRioCtwS7ulpl/fW7rqyNzDNMDyglkmgHgXivafhx8YrQYdYAt5LWzUjy842XCsZsbAJGcgrYblwL+uGF3moD6J2GdomiV+12sCqK5Oer6GjoHd9SXxQ2cGKhZIHkAb28e4INXatGJwENUvrkzAAJqMOh1m4AkrixodEClIXq+g80KrP8FDv9P2TjlGdeYXC07f72e8wUZtFJHdgGHV2ATD
 8qpp33EC
 8+BNYiQNkqQDH2YeM7yDUDWy6nVBGVZ1rxEoyFbTGeOWEqTMzLPGi+1vtLuWTX8IG57rtya39S5gcWnDTMEl+2COkyGLpdCdx3NL1ziruso11YzwCLvympvMw24A1gMgDsoNVxw3SHeLeu+PaMvt+UjOiS2IRw6JjcuxcY6uWY0zZRFxn3/u757+XwZijRL9TVxW7y6ehb0hWKKQPEvPhD+AMEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/7 00:24, Dave Hansen wrote:
> On 1/6/26 04:03, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When unsharing hugetlb PMD page tables, we currently send two IPIs: one
>> for TLB invalidation, and another to synchronize with concurrent GUP-fast
>> walkers via tlb_remove_table_sync_one().
>>
>> However, if the TLB flush already sent IPIs to all CPUs (when freed_tables
>> or unshared_tables is true), the second IPI is redundant. GUP-fast runs
>> with IRQs disabled, so when the TLB flush IPI completes, any concurrent
>> GUP-fast must have finished.
>>
>> To avoid the redundant IPI, we add a flag to mmu_gather to track whether
>> the TLB flush sent IPIs. We pass the mmu_gather pointer through the TLB
>> flush path via flush_tlb_info, so native_flush_tlb_multi() can set the
>> flag when it sends IPIs for freed_tables. We also set the flag for
>> local-only flushes, since disabling IRQs provides the same guarantee.
> 
> The lack of imperative voice is killing me. :)

Oops.

> 
>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>> index 866ea78ba156..c5950a92058c 100644
>> --- a/arch/x86/include/asm/tlb.h
>> +++ b/arch/x86/include/asm/tlb.h
>> @@ -20,7 +20,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
>>   		end = tlb->end;
>>   	}
>>   
>> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
>> +			   tlb->freed_tables || tlb->unshared_tables, tlb);
>>   }
> 
> I think this hunk sums up v3 pretty well. Where there was a single boolean, now there are two. To add to that, the structure that contains the booleans is itself being passed in. The boolean is still named 'freed_tables', and is going from:
> 
> 	tlb->freed_tables
> 
> which is pretty obviously correct to:
> 
> 	tlb->freed_tables || tlb->unshared_tables
> 
> which is _far_ from obviously correct.
> 
> I'm at a loss for why the patch wouldn't just do this:
> 
> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb);
> 
> I suspect these were sent out in a bit of haste, which isn't the first time I've gotten that feeling with this series.
> 
> Could we slow down, please?

Sorry, I went too fast ...

> 
>>   static inline void invlpg(unsigned long addr)
>> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
>> index 00daedfefc1b..83c260c88b80 100644
>> --- a/arch/x86/include/asm/tlbflush.h
>> +++ b/arch/x86/include/asm/tlbflush.h
>> @@ -220,6 +220,7 @@ struct flush_tlb_info {
>>   	 *   will be zero.
>>   	 */
>>   	struct mm_struct	*mm;
>> +	struct mmu_gather	*tlb;
>>   	unsigned long		start;
>>   	unsigned long		end;
>>   	u64			new_tlb_gen;
> 
> This also gives me pause.
> 
> There is a *lot* of redundant information between 'struct mmu_gather' and 'struct tlb_flush_info'. There needs to at least be a description of what the relationship is and how these relate to each other. I would have naively thought that the right move here would be to pull the mmu_gather data out at one discrete time rather than store a pointer to it.
> 
> What I see here is, I suspect, the most expedient way to do it. I'd _certainly_ have done this myself if I was just hacking something together to play with as quickly as possible.
> 
> So, in the end, I don't hate the approach here (yet). But it is almost impossible to evaluate it because the series is taking some rather egregious shortcuts and is lacking any real semblance of a refactoring effort.

The flag lifetime issue David pointed out is real, and you're right
about the messy parameters :)

And, yeah, I need to think more those. Maybe v3 can be fixed, or maybe
v2 is actually sufficient - it's conservative but safe (no false positives).

Will take more time, thanks!

