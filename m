Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BD5CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C158E0088; Fri, 24 Oct 2025 08:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63E48E0042; Fri, 24 Oct 2025 08:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA12D8E0088; Fri, 24 Oct 2025 08:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B83028E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:17:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7697F49865
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:16 +0000 (UTC)
X-FDA: 84032907672.30.E4596A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75DA7180006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YioWD/IqA/1JOGO8+Y7wTQHhF26d2UKTg8w6nlGrrCI=;
	b=JkojpO8YPXIXC9WdYXtO1UZ56sjTWSbV+HypwHClbHqbQ3F54wuHaonMI0K0ZGlmgG/w1o
	+RB9G+NeMRqzfL1C2LX515w4BqOkAS3aFOhhum0fvb4Ru9Hp34COHZO3Hub4qwq6i6TICO
	e8Os7VmGTI0MW2Lz+uINwN4HUFRTEVw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308234; a=rsa-sha256;
	cv=none;
	b=KtJA9asSuHZLVmmoxK90U0IoT6FR6tddJbxfVv47s/HplCGMp5l/Df0c0GoY7AecbLxJSR
	QDi3goxR9o6kkrCA69Pg4JqRN2rJFNIQJtOGgaEQeQ08T1t0X2cHtc4V56K61ZvDBy4ZiG
	UL5Us9yrOHCXdbdwljSRtKSgy5Bwkg0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F3401E2F;
	Fri, 24 Oct 2025 05:17:05 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 881823F66E;
	Fri, 24 Oct 2025 05:17:04 -0700 (PDT)
Message-ID: <ed949468-5425-4f82-826b-249c43a0df05@arm.com>
Date: Fri, 24 Oct 2025 14:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/13] mm: bail out of lazy_mmu_mode_* in interrupt
 context
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-13-kevin.brodsky@arm.com>
 <28f2ebe9-cfed-41c3-803f-8756dca0e300@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <28f2ebe9-cfed-41c3-803f-8756dca0e300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 75DA7180006
X-Rspamd-Server: rspam03
X-Stat-Signature: itwpigt6c1b4o8xurogdozpdjpj6y8m1
X-HE-Tag: 1761308234-920418
X-HE-Meta: U2FsdGVkX1/AYc0sGLl2iV0tDLfBjeOa1W5Ky/kdz7ocYaU42u5NEh5oLXvWhSyR7Qk5MLVGcVq5rujxSV7/jXfhND+/Si5jMpbGptnz4YcsAjW39mBUJpjU3D4WHLYeHvDgLlMR9UrWkIf8t5yIL16Va2jHSNaVtr6QI/I/q3YRtPLCUAXo3ZYGzjQws7ribXSPFbSUni7w+cr+aVvpgnSYHzRWdcFGUAhNlp4qTjP90tuFjDks1Jr0mj4D1EmZd76N1FXvmrF6MqX8jIFan5d8v/Zdf2P9pGdBPd5HqBDrLnNND0TAJrInp12Nof8kE/wEERUMhlUeyKzgh2nOULec2i+1tzY4O/BY6fWIRWpeaKbdlwpPJO7ru4EercSLcAxkdhfH0H7SPQjATUFanQMYkqQR0UIa2gEgOR/D2SnCDJZ7bSLn5l/PgW/+ZylGX1eEYWYbmsBTEAX7bfIaRqUgFaaoZmw5GXL19dg/mVYDaOJRWCQNkZnUsEWwpEe24V7Op9Fn5O6Z354xFJEhsuAaT/LOuuwdXTMhJkCD7geSNsVFILoDBXJwfMItk2lEblD2NuqXA/zopN+A/X40NkqqnXQ6gIRcHpe02xV841E2coN1gs8Rt/fTnXKxgqi0gQPRwRVvvgxrUxJUmdlYe9xnRK98L82JA4dX+MWyWzSaPKbyHUYRF6T5VKa/aQfpsEzWz31XMPdHcmqd18rkRBJQv9KnfmcJ/mtQzTZjy2I71PomjOzBGfA7D1yrLnKYNSgnYERHgZohdnvD9sTOGqwvxyBLOK+WEV8iRr5iEoKuQ4pZJUzt6Yih9VfeBWNKXv3oFmJeiHelRXhqDqvjimcdoShHBcu5XpGjnJomVmDRQQ4knZzKHOBob6pYIi6FaG1DxRE+cSOxcPClXoeC5bLvzo+QJZ5LOLsBsUR0M610dToC/hs/bvrIgn2/QZX8Xdg0MEI0C9AgrQaeW/F
 9GmExDPz
 l1iNqRmoRWQVvszx3RG/SYqwPGRPUGOddoCyrULq3DIrnWhtL27W+4bH8mCgKhsNRDulrykwyv7EFo/JCPX1Fnv0Vy2/QfZvslFRGYw3PNwpO/luc5zaS7SSNEQ15PdD1e2kq+3Ex1F1WjZbrh1S9NpvUiVVk2L7wYqZ1jnaItw6xvS/AbssPZm6yLa2gBUcH0XVjFdRl/kO5IYVwj1vOPNBPs8iPKHndfZ4NeVw5bhIaRa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 22:08, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
>> The lazy MMU mode cannot be used in interrupt context. This is
>> documented in <linux/pgtable.h>, but isn't consistently handled
>> across architectures.
>>
>> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
>> interrupt context, because such calls do occur in certain
>> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
>> batching in interrupt contexts"). Other architectures do not check
>> this situation, most likely because it hasn't occurred so far.
>>
>> Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
>> disabled while in interrupt mode (see queue_pte_barriers() and
>> xen_get_lazy_mode() respectively).
>>
>> Let's handle this in the new generic lazy_mmu layer, in the same
>> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt(), and
>> have in_lazy_mmu_mode() return false to disable any optimisation.
>> Also remove the arm64 handling that is now redundant; x86/Xen has
>> its own internal tracking so it is left unchanged.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 17 +----------------
>>   include/linux/pgtable.h          | 16 ++++++++++++++--
>>   include/linux/sched.h            |  3 +++
>>   3 files changed, 18 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h
>> b/arch/arm64/include/asm/pgtable.h
>> index 944e512767db..a37f417c30be 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -62,37 +62,22 @@ static inline void emit_pte_barriers(void)
>>     static inline void queue_pte_barriers(void)
>>   {
>> -    if (in_interrupt()) {
>> -        emit_pte_barriers();
>> -        return;
>> -    }
>> -
>
> That took me a while. I guess this works because in_lazy_mmu_mode() ==
> 0 in interrupt context, so we keep calling emit_pte_barriers?

Yes exactly.

- Kevin

