Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C72CF31B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147506B00A8; Wed, 19 Nov 2025 07:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F74D6B00A9; Wed, 19 Nov 2025 07:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28896B00AA; Wed, 19 Nov 2025 07:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0C2A6B00A8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:16:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 264A04DDC3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:16:15 +0000 (UTC)
X-FDA: 84127253910.01.ED8F6C7
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB4A8C0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:16:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AVtUPokb;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763554572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8UxEgfEvYYIYjqonyzaX1YNHYFvCPlixYyfl5K/5Us=;
	b=rbQ90m3saFEesGTU8SLI7qNQjul2EJz9gJ9C7Z6q8iZ+dUBhweUcw8TblY0rF8iPeEeBo4
	uOpCjdJ/0jZi2/RJ0L6MIWYraIhLNJiqwS8wL0ijRyMbwNTSEg4Cf3/xAHXKRgKbC8p5oQ
	5kR8p3ItHlSrB9DfeVbXhF/4S/DxJSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763554572; a=rsa-sha256;
	cv=none;
	b=7AEidEgdk/4Jc3nfVNP3L3qL1nshC7PSTG7iPPEXrvlJh4I9vs8EH65c0mECnf4lV5n0nI
	riMFSMphv+YjtII78ExbZ3sOoEH7i0RO3Qpsz/1igaI4dT7BsopLzLbqBnwUfP/91DHWG6
	qgwB8vVR4PATrOb1KSm7py3mDFG4/4E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AVtUPokb;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6e6d8390-1f9e-40cf-949d-168160fa9a15@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763554567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8UxEgfEvYYIYjqonyzaX1YNHYFvCPlixYyfl5K/5Us=;
	b=AVtUPokbskA2fxW7sCPAzJUrWf8TDNbPt/WdsQfOCSbGOGvqVUig5Chd70lHJMkyln4ufj
	X6Bg1RKVDftg0vFjwYVYCXvoFKw63N958H75bSqPHgoSBbSpEmPqQpJlqP6Lz5U8HFdbCb
	XKACOfahN120NBnxDteAgU+KBrLLN4I=
Date: Wed, 19 Nov 2025 20:15:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/7] mm: enable PT_RECLAIM on all 64-bit architectures
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com,
 linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
 <caacf08b765ef00770b7c75afdb5e5754485b2aa.1763537007.git.zhengqi.arch@bytedance.com>
 <9b55623a-4606-4610-a0fe-55b8cd6b95e7@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <9b55623a-4606-4610-a0fe-55b8cd6b95e7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB4A8C0011
X-Stat-Signature: cd6tdainxw6d7eerajjnnet95yrb3swc
X-Rspam-User: 
X-HE-Tag: 1763554572-218021
X-HE-Meta: U2FsdGVkX18IF75JBioJxkUNMPll3AAYKqzN8eM/4JExEUEr3YwH7rIgrYLQGNhFnsAtQPwPiEGNCAE/l58zO1BIL1ct1kxgTMgY0QR8wPETOLsa+I+PcXZu42tWDvkmJcGqpPKvNGWFfzJzOmZxuSWmQddlR85Z4xNnwbQYTDitvKtVHmcCAbdVvWb0ycvg1LSMY9fQrpvB6yH4a/o8Wva9aqt7kdw4G4+fFLSv7+U8ROeQ8lhiMLkssHuBE3F4JLRxrcNagabjkoeT3WFPGxbocie7yLRQ1DxJqhtfb4G8EvX+HOL2TcYGtlSHXR6fbSQAB8HIYwZBLXuvidABNoh4Mu73DqfE7voVf/+9sMOQXcbBcGERgAbG7f3Oe4DmSJCZBAULgX1xkZ4Aw8H5OuxF/IsH+ko7TlOLCvyNTrW0MgZzHoe2GYUoYBzqvGavH3Bs3jwB8T7HOSFhEBixoJNP3tNlzKWUERo4pFAKmxthtGNIJgYOc3SWlTs4onZoJ6kzAHeJa1DuMfbNLjTdAIrCLLB4z6LGnqtOH6y02BD7TpfuY//4nwkmREd7qR0PIF7um3MRzWLYJk5LzxB/0iE+tkcQc/oUIcNfZ8pnlJvT51rV3WgSI8BQA8QxLg17vJWfZAOAdjCs0cXhHEjORuecJPGfL0aBwQT1viONVA+dOj+iFBUwrXAlUciJ+wRNczfQD3WKznwxWFLjwuFIDtRmRMvLQwjF6tr6cvsJKSIVA2GRyN6/XKCo7WLLwwhjcd7bP/jM2bGD6HhipqDkymDf8xzXavjnZqiGUI25gHw5WVAupwY/OLlnrIU+uL1gsnA1pJwTd1V5fp7uSCKM9Uid/iqIzEm6YR0MpccSm8eyWMupg7IHDQAocDGSR+ST7puRtVrwd/MmTxfkInkKDw6vrMYqyGqahHekUBbenOtpnvwNR21N8cxcMLtgu3xaUgkKbJi6eU5wYWVxAGM
 fQwhsa2S
 dF7rKyZ2nN2/8s5hK74wvrfaLrnRqxoXM+wMQfz2tZunFLKztWUi6FHVmmWC/z+xuE1xFIvj7bB+HHwfpq3FgzBr4oMu7RArgnkkQ9YH5GrkOTll+l3pKGC4nb22qrhihhpTuG439qfwplZR3PG/j6OKT8qI/MnK56h2yP+zMEmgV3wvdeLw0X73zeQoepHmcraePLdD1A/1qv+l0QsJhj4b71TsYCHQ79mxz9PDWTxJOpdh48+BqOuWusAT3Yr3/kdg0mOA+nq1u9AIsmMiLGJvrhkAew9688/AtNaWmNTBbI9URBT85ICuFqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 7:38 PM, David Hildenbrand (Red Hat) wrote:
> On 19.11.25 08:31, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Now, the MMU_GATHER_RCU_TABLE_FREE is enabled on all 64-bit 
>> architectures,
>> so make PT_RECLAIM depend on 64BIT, thereby enabling PT_RECLAIM on all
>> 64-bit architectures.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   arch/x86/Kconfig | 1 -
>>   mm/Kconfig       | 9 ++-------
>>   2 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index eac2e86056902..96bff81fd4787 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -330,7 +330,6 @@ config X86
>>       select FUNCTION_ALIGNMENT_4B
>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>       select SCHED_SMT            if SMP
>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index d548976d0e0ad..94eec5c0cad96 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1448,14 +1448,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>         The architecture has hardware support for userspace shadow call
>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> -config ARCH_SUPPORTS_PT_RECLAIM
>> -    def_bool n
>> -
>>   config PT_RECLAIM
>> -    bool "reclaim empty user page table pages"
>> -    default y
>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> -    select MMU_GATHER_RCU_TABLE_FREE
>> +    def_bool y
>> +    depends on 64BIT
> 
> As discussed in the other thread, likely
> 
> config PT_RECLAIM
>      def_bool y
>      depends on MMU_GATHER_RCU_TABLE_FREE && 64BIT
> 
> Could be nice, and if possible even dropping the 64BIT limitation as 
> well if there is no need to.

I think it's ok to drop the 64BIT limitation. There should be some
32-bit architectures that already enable MMU_GATHER_RCU_TABLE_FREE.

> 
> 


