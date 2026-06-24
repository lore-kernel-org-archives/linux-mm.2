Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBE4CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9358E6B0088; Wed, 24 Jun 2026 18:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5F36B008A; Wed, 24 Jun 2026 18:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4646B008C; Wed, 24 Jun 2026 18:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0D76B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:46:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDF761404AF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:46:24 +0000 (UTC)
X-FDA: 84916291488.21.2F918B8
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4BF071C000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:46:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OVBfjWm6;
	spf=pass (imf20.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782341183;
	b=n0UScFzvjynut3qYNZFwsxtB3oWx5EwLsFX6Y6LmHb1OItJk2dPugSaZ8yqo0gni3dgWZ+
	NTuE0AuAYI8GHCiNfEcCdKJ+zvsAI4GXC+NUvGvaNxwh4MP56iPwsfhk8naShiey1egT2D
	yGXrYCccyEYTW7GRihBeyyUA/F0F6cw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782341183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WSGY9dLQqNnAkibDsXbEsLCclNK7cqzQS11//tCqts=;
	b=gg7s7R8GbbsUQEhxhqMTO9jMeNnJQemNcccZdXYFUxktP0KMvdRO6SSKv54ZCOkTt2XYZn
	gIBsoMIslgQG06/GG2qy04Wwqm7qajIRmgK+7Jdc3l7jK1eCvOkNltTUsXKYZuXAi+ttLg
	rxMIcHrCFQmseHUEPe8DGK8crozXPdQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OVBfjWm6;
	spf=pass (imf20.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c49b1499-6aa0-4e17-8385-cd2bcd2220cc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782341177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WSGY9dLQqNnAkibDsXbEsLCclNK7cqzQS11//tCqts=;
	b=OVBfjWm61Bc+yXLepbLjwQPfA3qFP8rMq8DkKs3GXVAh9Ey29S8biSK5f8/BfiPVrDlPAn
	iBNooDbv4hvTX9pTW2u5Dxp+1BQA0dCnHq9yAKkqZbtZcth2iItIUy05fJrpW+Hrl1sW+8
	t1VBV1v+HzU8s1z0BJlnqa5NqceWHrE=
Date: Wed, 24 Jun 2026 15:45:15 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrey Konovalov <andreyknvl@gmail.com>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
 <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
 <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
 <87643862-e32e-43c7-8c81-7186f30059ea@linux.dev>
 <20260624025732.GDajtHnB1Jc21kQnl_@fat_crate.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260624025732.GDajtHnB1Jc21kQnl_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ca8b6q64c7isr8s537ykeezni1p9m6cp
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BF071C000B
X-HE-Tag: 1782341181-612385
X-HE-Meta: U2FsdGVkX18lj2kq3/0c35X5062ayj1Tvf42QvYHhoLili5hhI+K2eg/rtk/StCAY0xqiQgcDrhzeDPXOuoWbHnAcX14/xL77KVEqFrvy4X7hK5dCakfZ0o1SRBgo2DGJa6awiNhEv03J1roiAmo+BdxgZ4Qa1gWTnnR+KgYv6e/959fC480mWoF/TUIecbD38Kz08w3OpPNIEQULC2NQxo71/4A1OeC514QsBA7LjRP6EUCchFQ7SXeLUYfuRZCYSQZBzn2qohv9acwwuZeMEKJU9ftkrS3gbd4WRlRmeDwUMSKnlT69BPo/hD5BoRJSN8Zv9UQ/VVtwHGg0Z84s0UjRVRpBLTiTr6x9UuEk1yQGtV92/RLKTVnDjqkrrjBazKMTUudUc3hBVHyakf6F9OhmEoUXQ9O5jYiOiBG7yGpJq5CNK5hLM6UkRsHXVdX6il+Q7Uu+wmwp8ruvX+nlnf+YIw2S8X4QJvJsrZ8X9MZyaPj1eWj0mgPrhJI7+jrVEQaxjC8sEgPuncTy/CA4eh1E/zRLeKpytxMAmf9JiF4XaYqffPnot2GGjttH4N0M3L4oP82yMWQEKla7U9eccVONtyFBal/+fZOd1P1TlPzEJG05d/xuP/+UUd2hJxgHeE19PFsTQ0XpjABt5d6uBrR2wUPEBoCJyT4Yrsuy36YHtNFgnL4/a0oheI1t+QF9E/IEpSz2x61EpLOvegZczPOv0oPsALohr4rLJmKzeai7Cexq7Dzx5thkfgPLnC6p6WzqSkLUGrpqxjrg8zo4T7CCFsYjZ99AEPs/dcXva4kJ1TForBfMRY+x0CAAk1voy1ujGskcji5Dli/X3HtG1L1bGNJ5TgtjEIaGPzaCmzK0f7vHom9i1i+t1G5eIzSVOdJSbVqamWtJ3b+cM7tTvk/ClFyaEUQSC7HO97CKxmzLJk34Rzn3hIzW3krYs6Y33yyiDSdpoxGytBg5n/
 +LUvP9zg
 g1oNlkKGGzQPVmm7inyaN2W6SNHqgzxlKvvyJg7a43AmVwwuJOYc6134Gu5G8hwXQjHCJ/X53EJeiHhWg7+YHbzSsmCX8f4Y15ROL6EYG8sI3tGI/+u+ec9XZbhMPV1Z4L0ZfhW44rwo3BD28VMMqSRUFR9UwdHcimfZfVjkz+R2W2dp+ZyxlQ7cs5OeCIbZCtQsAL/tbkX094+FeacDrs7smif5/BDMHQuj49w8QfVYEcAJY81s4EsXR4qBcx/8AMejqN39kHvEeBcsjOtXbtyAtUi7BMxeefCRU13gkAylqH6YD32VJkvE0uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 7:57 PM, Borislav Petkov wrote:
> On Mon, Jun 22, 2026 at 05:29:12PM -0700, Ihor Solodrai wrote:
>> On 6/18/26 11:38 AM, Borislav Petkov wrote:
>>> On Thu, Jun 18, 2026 at 11:12:09AM -0700, Dave Hansen wrote:
>>>> On 6/18/26 10:09, Borislav Petkov wrote:
>>>>> On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
>>>>>> So my question to maintainers is what approach seems best?
>>>>> The CPUID stuff is being rewritten currently and it should address your issue
>>>>> too. If not, then we need to rewrite it better.
>>>>>
>>>>> Can you reproduce with this set applied ontop:
>>>>>
>>>>> https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de
>>>>
>>>> Thinking about this a bit more... If Ahmed's series does fix this, I
>>>> think it will be accidental. It still uses identify_cpu() and also does
>>>> a memset() of the new c->cpuid structure in addition to the old
>>>> c->x86_capability structure.
>>>>
>>>> I'm not knocking Ahmed's series by any means. It just probably won't fix
>>>> this issue.
>>>>
>>>> In a perfect world early_identify_cpu() and identify_cpu() would either
>>>> get consolidated into one thing. Or at least become two discrete things
>>>> that initialize two completely disjoint sets of data. That way,
>>>> identify_cpu() wouldn't memset() anything.
>>>>
>>>> Isn't that the _real_ fix? Instead of trying to hide the inconsistency
>>>> when good data is blown away, we stop blowing it away in the first place?
>>>
>>> early_ is only on the BSP and you want to scan all CPUs.
>>>
>>> AFAIR, the last time I was looking at how we scan the CPUID leafs, we do have
>>> cases where there's blips in time when cap bits get disappeared to be
>>> rescanned again. The toggling of MSR bits which control feature flags is one
>>> thing that comes to mind.
>>>
>>> But I'm with you on the consolidation approach. I think this is what we should
>>
>> Hello Dave, Boris. Thank you for the input.
>>
>> I tried a slight refactoring of the identify_cpu() machinery to
>> eliminate the memset(x86_capability) from the boot cpu, and it fixes
>> the splat that I reported.
>>
>> identify_cpu() is split into two parts:
>>   * identify_cpu_scan() - the top part, up to and including the
>>     generic_identify() call
>>   * identify_cpu() proper with the rest, no memset here
>>
>> Then (gated on x86_64) identify_boot_cpu() *skips* the
>> identify_cpu_scan() call, only executing the bottom part of current
>> identify_cpu(). We can do that because boot cpu already did the _scan
>> part in early_identify_cpu(), when interrupts are still disabled.
>>
>> One caveat: get_model_name() is moved from generic_identify() into
>> identify_cpu(), otherwise it wouldn't be called on boot cpu. Same for
>> c->loops_per_jiffy = loops_per_jiffy; - it's moved to the "bottom"
>> identify_cpu().
>>
>> The behavior for secondary cpus is unchanged: identify_secondary_cpu()
>> calls identify_cpu_scan() then immediately identify_cpu().
>>
>> Please take a look at the diff below and let me know if this is a good
>> way to proceed. I don't know exactly what I'm doing, so concerns and
>> corrections are welcome.
>>
>>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index a4268c47f2bc..4a655109cacf 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -1978,8 +1978,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
>>  
>>  	get_cpu_address_sizes(c);
>>  
>> -	get_model_name(c); /* Default name */
>> -
>>  	/*
>>  	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
>>  	 * systems that run Linux at CPL > 0 may or may not have the
>> @@ -1999,13 +1997,12 @@ static void generic_identify(struct cpuinfo_x86 *c)
>>  }
>>  
>>  /*
>> - * This does the hard work of actually picking apart the CPU stuff...
>> + * Rebuild capability set from CPUID and re-apply the forced-cap overrides
>> + * through generic_identify(). This *should* run with interrupts off, otherwise
>> + * an interrupt handler might see the capability bits cleared.
> 
> And yet it doesn't run with IRQs off. So that comment doesn't need to be here.
> The point of the whole exercise is to not disable ugly interrupts in that path
> at all.
> 
>>   */
>> -static void identify_cpu(struct cpuinfo_x86 *c)
>> +static void identify_cpu_scan(struct cpuinfo_x86 *c)
>>  {
>> -	int i;
>> -
>> -	c->loops_per_jiffy = loops_per_jiffy;
>>  	c->x86_cache_size = 0;
>>  	c->x86_vendor = X86_VENDOR_UNKNOWN;
>>  	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
>> @@ -2028,6 +2025,19 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>>  #endif
>>  
>>  	generic_identify(c);
>> +}
>> +
>> +/*
>> + * This is safe to run with interrupts on.
>> + * The boot CPU can run just this from arch_cpu_finalize_init(), because
>> + * the scan part already happened in early_identify_cpu().
>> + */
>> +static void identify_cpu(struct cpuinfo_x86 *c)
>> +{
>> +	int i;
>> +
>> +	c->loops_per_jiffy = loops_per_jiffy;
>> +	get_model_name(c); /* Default name */
>>  
>>  	cpu_parse_topology(c);
>>  
>> @@ -2154,6 +2164,17 @@ void enable_sep_cpu(void)
>>  
>>  static __init void identify_boot_cpu(void)
>>  {
>> +	/*
>> +	 * The boot CPU's capabilities were already scanned by early_identify_cpu().
>> +	 * Here identify_cpu() only finalizes them.
>> +	 *
>> +	 * 32-bit still needs the full scan here: it sets X86_BUG_ESPFIX (via
>> +	 * generic_identify()) and the no-CPUID cpuid_level default, which the early
>> +	 * path does not.
>> +	 */
>> +#ifndef CONFIG_X86_64
>> +	identify_cpu_scan(&boot_cpu_data);
>> +#endif
>>  	identify_cpu(&boot_cpu_data);
>>  	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
>>  		pr_info("CET detected: Indirect Branch Tracking enabled\n");
>> @@ -2178,6 +2199,7 @@ void identify_secondary_cpu(unsigned int cpu)
>>  		*c = boot_cpu_data;
>>  	c->cpu_index = cpu;
>>  
>> +	identify_cpu_scan(c);
>>  	identify_cpu(c);
>>  #ifdef CONFIG_X86_32
>>  	enable_sep_cpu();
>> -- 
> 
> Ok, thanks for that, that's a good first try. I did poke at it a bit and
> here's what I think should happen:
> 
> 1. The part which initializes struct cpuinfo_x86 up and including the memsets
>    should be one function called init_cpu_info() or so.
> 
> 2. Then, generic_identify() should be merged into identify_cpu() basically
>    turning the latter into a single function which does a generic CPU
>    identification both on the BSP and on the APs.
> 
> 3. #ifdef CONFIG_X86_32
>         enable_sep_cpu();
> #endif 
> 	that gunk should be stuck into a function called identify_cpu_32() and
> 	you'll have at the beginning of it
> 
> 	if (!IS_ENABLED(CONFIG_X86_32))
> 		return;
> 
>    and then you call that function both in identify_boot_cpu() and
>    identify_secondary_cpu(). This way you streamline the paths and drop all
>    that ugly ifdeffery.
> 
> 4. When you do 3. above, you should be able to move this gunk
> 
> 	#ifdef CONFIG_X86_32
>         set_cpu_bug(c, X86_BUG_ESPFIX);
> 	#endif
> 
> to it too. And now everything is nicely encapsulated and straight-forward.
> 
> 5. The above will allow you to have the init_cpu_info() only on 32-bit.
> 
> Oh and, looking at the ifdeffery on identify_cpu():
> 
> 	#ifdef CONFIG_X86_64
> 	        c->x86_clflush_size = 64;
> 	        c->x86_phys_bits = 36;
> 	        c->x86_virt_bits = 48;
> 	#else
> 
> you could probably add a identify_cpu_64() too. Or maybe the init parts should
> be called separately init_cpu_info_32() and init_cpu_info_64(). You probably
> need to see how it looks like when you write it.
> 
> Oh, and each 1., 2., ...step above is a single patch. This'll make the review
> very easy too.
> 
> How does that sound? Willing to give it a try? :-)

The instructions are quite detailed, thank you.

I'll try it and will send a separate series as soon as I can (likely next week).

> 
> If not, I could try to find some time and do it myself but I thought you might
> be willing to try it...
> 
> :-)
> 
> Thx.
> 


