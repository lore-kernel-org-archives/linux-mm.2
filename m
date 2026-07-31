Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1632C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 19:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD7E6B0088; Fri, 31 Jul 2026 15:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CC36B008A; Fri, 31 Jul 2026 15:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BC56B008C; Fri, 31 Jul 2026 15:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 642016B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:13:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2E2C40103
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:13:45 +0000 (UTC)
X-FDA: 85050021210.16.8AC1399
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1525914000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:13:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=khZ82Zzf;
	spf=pass (imf23.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785525222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+/IlSQdEk6FwfnjejmyThzGdDfoncjciaxKcBusmd4=;
	b=33peqyhusQ3iyTpkzllYxUNnyqcSJDo69xzm+siqHB6Us3YqW0m53O0knNrevyd6ohQNmb
	s5d0fbNU0psxeFt3Y+bC95djxrsZNJcZtFDZFoIaeC6SP1pOPqSwYM0Q0nWd1kYPfi4MY5
	Wxrsrc67bZMPu8BK7nL8T3oMDL3NHFg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=khZ82Zzf;
	spf=pass (imf23.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785525222;
	b=sZRTjM/wn+D5hGBG97CNQCPMEoNpTI9IytUslU25nzFf7JoF5T7tvgyehjsgBIRBTwuqkN
	9FJS14lX05ULDczS1ogsgdJeLGW3LciDnQfnEaZsmS9nM/IELTCIClUMkh0pZBf5x94nR5
	oi59xOVJblkyF07iIg21y3KN+hd75Bw=
Message-ID: <7772a849-0faa-46b9-b30b-3523af581d1e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785525219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+/IlSQdEk6FwfnjejmyThzGdDfoncjciaxKcBusmd4=;
	b=khZ82Zzf/raPAkLwtS7hRQZpAZJ1eKcFyqYEO8mr9ToABHzWhXmobe2dLFpQoX2oWHwHQw
	IIyY/T5BVjUSJHV99WiibTSn7LiCd0ceOUBZUVjKKMAJbmwhosrzDoGtanGKCqfVfAEK94
	tx5+oBES1745ltSMA7OWZEYlRmIlRNI=
Date: Fri, 31 Jul 2026 12:13:26 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 5/5] x86/cpu: Don't reset boot CPU cpuinfo in
 identify_cpu()
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar
 <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, "H . Peter Anvin"
 <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 bpf@vger.kernel.org, kernel-team@meta.com, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
 <20260704002046.3859585-6-ihor.solodrai@linux.dev>
 <20260730212613.GJamvBdRJ5H98hTWS8@fat_crate.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260730212613.GJamvBdRJ5H98hTWS8@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1525914000F
X-Stat-Signature: yxaw8uaw4xnoume3zha3pd8jy6c6mxhw
X-HE-Tag: 1785525221-43786
X-HE-Meta: U2FsdGVkX18RXo7hvg6pLchIBAveIGtO3EITQ8cPi9SWMOn/Ktld+NbKeG8VVQr6UrWWS+YcmVxZ6LJ+i6zzerELAkWqkw9pifvZZLYRF8Pd1KXcJ3ig5C+Lbjm3BNUslpa15Gib3yO0ccYpCVZ52TlM9wQFIvJxvIU/NQWXaz4Mk2mTs4473eisGRa9rEC0PLOSFrwXCpwQKZz6OeTpVkVPDmLUtPneZLV8pcEJTr9LU2QQJ0sRQlyE0UCRVmPCd0v5AWCkBHO8Idz+Rw1uhs2X1Qp0onYyD38w1BZbfJK7tZYX0eaBZxmJDNK8bPqB8ai6+eKsdgqyLUNS+MFTrHa7evWyPP9+V6gTAO3/ntKHsbWl4H7Dngx1pP4TFuJlOUzrQjfuxwgkPFK2zavg1xhiNwjMR7vlOVjhESxYR2GJc1ZN/H3FJd2ZyeE3bIvtN82785HLHwCg26Dp3jBj6Ltw1Ydr9UfZK00LyJZHg3dGRki8cx1maes/5El725uIye8XtqrOqSPTzGCHFXM9YWc5ovq87TjCXfLBCbpU1etkcHUtdtOM68CW4ba0dsnvRghsIEraTcyZVsplP2oesYs4Bi8Fj7E+9Umay2FfKxPgbuYXYfyNJ+yRpXBaePmYTgp3yTdWNNWExL9W5iGjBobrm73P/CRatRe7IltkGYj8A15xppzaptwZEteB6JPZNsc5U4JHQmm98gtFGghIN8C+tBOPAse16Wheumzlwkc/0uFF3UVRKibKE0FtlZ/g+8fYC+JS1JeOaQi/YKAIhL93e3bJYG3WgJpf5jMitgFS80FwTN9zAMx3yF1laIk7so8rg8ippJioMYYBHVmLdKCTlk8zlANXFKT6uSxngGCqsZPi2AV6qc3q6pQ2QAiEGKgMh9/eJF+kX19vWUOJi2yGQx8azg5LOhSNE0ZDmJt2kZJ6IK9Q7QscchvxzoTlS50AZyK94PCqWdVkXfl
 w77WE1VW
 djE/cJfw5lpWm27pO2F3TOfcln7miUCu0vFB0EjDVnA2lXoBDxGGTHZnqXPjQKyMP0uEoXidvWt+458w4qz3s2yGqunjW2297eLNYmtzPceDlIjD6vcaN4tzI8quytNrAkQCNlyMJN94Uvy2Y3uu+xTzF5IQKRM+5Au+WehhAF7oxfVq/W1knPzCxKxoEO/IpDpIp6Xt0jMCqlV9FxGvhpwkn5U+vphjKYT4f3K0e5GvrNrYzhdVWduUkjYTjomzKZyIXvqdVvlZQg7amoFRGxK9i9s1AlWXJE5qmdmF0h3SMdng4ckTF6Hac3ImW37DB7aWJTUk+UAAJyBfF/ZDm3p5EYeT7A0VJM3fwqDXZND2Gz64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 2:26 PM, Borislav Petkov wrote:
> On Fri, Jul 03, 2026 at 05:20:46PM -0700, Ihor Solodrai wrote:
>> identify_cpu() used to rebuild c->x86_capability from scratch:
>> init_cpu_info() memsets the capability array to zero and
>> identify_cpu() then re-reads CPUID. On the boot CPU identify_cpu()
>> runs after local_irq_enable() and before alternatives are patched. An
>> interrupt delivered in the window between the memset() and
>> get_cpu_cap() therefore will observe cleared x86_capability [1].
>>
>> However the boot CPU's capabilities have already been scanned, with
>> interrupts off, by early_identify_cpu(). So move the init_cpu_info()
>> call out of identify_cpu() into its callers, and skip it for the boot
>> CPU on 64-bit.
>>
>> Secondary CPUs call init_cpu_info() then identify_cpu() from
>> identify_secondary_cpu(), with interrupts off, exactly as
>> before. 32-bit still resets in identify_boot_cpu(): it relies on the
>> reset for the no-CPUID cpuid_level default.
> 
> Ok, this commit message is all over the place. Please structure it something
> like this:
> 
> 1. Prepare the context for the explanation briefly.
> 
> 2. Explain the problem at hand.
> 
> 3. "It happens because of <...>"
> 
> 4. "Fix it by doing X"
> 
> 5. "(Potentially do Y)."
> 
> And some of those above are optional depending on the issue being
> explained.
> 
> Also, do not talk about what your patches do - that should (hopefully) be
> visible from the diff itself. Rather, talk about *why* you're doing what
> you're doing.
> 
> In the patches where you do only mechanical movement, add
> 
> "No functional changes."
> 
> to the commit message to denote that.

Thank you for the review and the feedback. I'll respin.

> 
> 
>> [1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/
>>
>> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
>> ---
>>  arch/x86/kernel/cpu/common.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 8f093c6c7ccc..cd3d7c37c174 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -1986,8 +1986,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>>  
>>  	c->loops_per_jiffy = loops_per_jiffy;
>>  
>> -	init_cpu_info(c);
>> -
>>  	if (!cpuid_feature())
>>  		identify_cpu_without_cpuid(c);
>>  
>> @@ -2156,6 +2154,13 @@ static void identify_cpu_32(struct cpuinfo_x86 *c)
>>  
>>  static __init void identify_boot_cpu(void)
>>  {
>> +	/*
>> +	 * The boot CPU's capabilities were already scanned in early_identify_cpu().
>> +	 * However 32-bit still needs to init_cpu_info() here for the no-CPUID
>> +	 * cpuid_level default.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_X86_32))
>> +		init_cpu_info(&boot_cpu_data);
>>  	identify_cpu(&boot_cpu_data);
>>  	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
>>  		pr_info("CET detected: Indirect Branch Tracking enabled\n");
>> @@ -2178,6 +2183,7 @@ void identify_secondary_cpu(unsigned int cpu)
>>  		*c = boot_cpu_data;
>>  	c->cpu_index = cpu;
>>  
>> +	init_cpu_info(c);
>>  	identify_cpu(c);
>>  	identify_cpu_32(c);
> 
> Also, when you look at the final version, do you see how identify_cpu() and
> identify_cpu_32() are soo close together so that you can basically move the
> body of identify_cpu_32() to the end of identify_cpu() and then you don't need
> that helper either.

I actually did notice that, but I guess I fixated on the idea that
32bit part should be encapsulated. I'll fold identify_cpu_32() into
identify_cpu() in the next revision.

Thanks!

> 
> Other than that, the flows do look better. 32-bit still needs dealing with the
> no-CPUID case but that's for another day. I can't really find it in me to
> care, actually, 32-bit needs to go away and we'll simplify a looot of code. Oh
> well.
> 
> Thx.
> 


