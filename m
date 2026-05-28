Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C85CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988816B008C; Thu, 28 May 2026 06:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9655F6B0092; Thu, 28 May 2026 06:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D9F6B0093; Thu, 28 May 2026 06:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78C546B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:34:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 257BD12079F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:34:02 +0000 (UTC)
X-FDA: 84816468324.08.80DA08B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41DF480003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:34:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WrQtffea;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779964440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9PYvt3JwwPNYerWVYVdCS35JrCkCHXUQJKIbp7gJyU=;
	b=YeG39UlG8lI6SZuzgLRZX7Qi30WBs1j7kyQVMf510tBbkilvi1R65Oxe/A0D7QxZXAYfZ3
	KTIHYlf4DxTck2chl7zxcV7TwuiL7RlsXP8Rcgvk+vAzBFadr1l9hvt0HpDafaC0SH9cu2
	yvsiijX5AEG2clOFaXQ5bc+EE4GjwnU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WrQtffea;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779964440; a=rsa-sha256;
	cv=none;
	b=DQRk/1LkUZfdgnptgANdoy49qPFTybRdTsM3iYKjFzrmlxkjYyRXwVtoE26Awt/lltwOmG
	eB2LGOZSKhg5BgpvmD8cti94g7kru5hmdSMG/Y4cdU76A76nSiuCOI0X9p5UOxBKHPzQE9
	iacttKgTPA1JvVKyKLej/AxhJhvhtDE=
Message-ID: <ddb499d5-6821-4fa7-9fec-563bdfbc8cbc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779964438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9PYvt3JwwPNYerWVYVdCS35JrCkCHXUQJKIbp7gJyU=;
	b=WrQtffeaYoBmjfv2xZDFN0GJ1sqxUc/HlP+t5t++0IDzezsB2TGDKJErFtcwNQvQJHglGZ
	tXwOutqy1FwhOUBPx1J2QL8t980Zm5xd5E3iOvJyF3ZidpdQHP+iSPolW7wvUNPcPGOeMt
	QZd3Wn7rWyqJQPeGE6jbOTEv/8V8kTA=
Date: Thu, 28 May 2026 11:33:39 +0100
MIME-Version: 1.0
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0gbW0v?=
 =?UTF-8?Q?mempool=3A_use_static_key_for_boot-time_debug_enablement?=
To: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <20260527130337.983366-1-usama.arif@linux.dev>
 <fcf5585aba18414cbd0ab01935eeb1df@baidu.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <fcf5585aba18414cbd0ab01935eeb1df@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t1xjejnrn7qxjyddyijwwh8w3yf59h7c
X-Rspamd-Queue-Id: 41DF480003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779964440-802645
X-HE-Meta: U2FsdGVkX1+xJGEmm93lbC0i7Ia1JmMdPtiSKu+pGhv0JrrowtvApCjsu4oMkceeGbjwtZX9uOaXTjFAbNY/DYFctqAyrB+vroyClSV5nbcA2DjprkOG0oDD87QFR4THC4ypCtEkXrzum4B/bUOcQz6eM7AW68dwGQBVQAEssPrxOnr2LnT4kigPOrjC+Ib5gpmrA1m0PUaZWtv3+d7eUEYZuXIkFqhgJpcugAOVOodkBa5XLZVG47yrGn4DAndWleetdlZ8yR8kXiwuaUw0GFSDJ5RkK6Yi9D0UPMEySuvScX0KO3xT6ufVJRktQ4fV1mpLIH1BRk3EutV9Ltvb+uXXqAqjxOd1NJZKH5TDlzudrxk0PKvoq4HOAIr9YHzrTSnDcBLtfC70pwQFBGBM7P4LUuzWB0ba4unDHJxmnjcuGuFPX2GNfaUE8Ahlhu+mIulPciupglWKtcfqnmzxYNYr6qSoXQ9EqV3Zfa84Vu8u8jJyLsJE7RsbVZfhtFAradlHbemWfa+Y76HL/qjtNcgNwyqLtc7bHmKDF4xN3bPdfGKpqv5aFzTOE6LT8ZhCrQkbnWlrQQyr+a+LbJj48XuzhEHIsT5ktBWNhv/jJ03Z7ekKWRxdnDUzHAAe7tNHysuo2BVqpQMFbhlZ89lHNpnCYX2xze/GXn29kzpH5Vp9BEn8esxAMG/pabTvdM/H4gh0RZ8ZfPL162clWP2N9UhB+7DXQPgyy0MhT0IUvU5R5mgZ9P5IptmrSI5ic1k+NG/LAVMcBdCwCWvQfOmRLU/S1RcehotMXrK/s2qRaIoI/exYsrlS5hbMVN7r59OmbMOlRDxU92LamzohSIG6U0GJgHX382fD6YGc8op1vJMAB6jVaKrRBY0sM/WztxIVQYzvQ4D4879NTQwvbSPAf9/54P7HcGZ+q3+PrI+9ibZTnlhZVQld1FoZ2CwthddEeZR/EcRuFuJHCau2HFK
 RoxvMBGQ
 a+f3EYjod5cOSYiLzn/VQAXkufeT2/0J6nOrC3puMWfmOQ1ACG4i3mP+3leXS76elMVKT3KJIrC2WtdJuwLZXtZlCPIoFxFfj+400m1MwiVAaBWCRsdqqyxQ5Dv5rycr62NZrlaIw1WexeufoXt05b9AyGOxzEKbymSFVYFdRB+GtDtglW6jiy+MxuW3+2evXmY2rOSDFiafgZcKtBt2FKs/JeboVxQHGjbfstMHPBadGAsOI3GhM1hlMUghYCiX3js+6jbExpH+N9lBhcmyp3In3ST+RJgjaTwBIdTMCEtlODmcFmTugnfdt+nI9wJE+0Mtk8IrXFFqZAvtiu6ljPw0jKYgsYVeyngKCWznW3fW+jYqBrDUVcNxdXgPVhJSVLOOMIKbAYRbD3Q/jPExZCDMfwhf1YrAvr50RI+Ok/ysdpO9DHXXT1FLjLncy+qEYv5wtTiykmJd2xGR+wh/zGNOsTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/2026 04:00, Li,Rongqing(ACG CCN) wrote:
>>> From: Li RongQing <lirongqing@baidu.com>
>>>
>>> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
>>> static key (mempool_debug_enabled). This allows enabling mempool
>>> debugging at boot time via:
>>>
>>>     mempool_debug
>>>
>>> Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:
>>>
>>> - Debugging can be enabled without rebuilding the kernel
>>> - Uses standard kernel static_key mechanism with minimal overhead
>>>
>>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> Cc: Vlastimil Babka <vbabka@kernel.org>
>>> Cc: Harry Yoo <harry@kernel.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Hao Li <hao.li@linux.dev>
>>> Cc: Christoph Lameter <cl@gentwo.org>
>>> Cc: David Rientjes <rientjes@google.com>
>>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>>> ---
>>>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>>>  mm/mempool.c                                    | 32
>> ++++++++++++++++++-------
>>>  2 files changed, 28 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt
>>> b/Documentation/admin-guide/kernel-parameters.txt
>>> index 35ed9dc..5a070e6 100644
>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>> @@ -3998,6 +3998,11 @@ Kernel parameters
>>>  			Note that even when enabled, there are a few cases where
>>>  			the feature is not effective.
>>>
>>> +	mempool_debug	[MM]
>>> +			Enable mempool debugging. This enables element
>>> +			poison checking when freeing elements back to the
>>> +			pool. Useful for debugging mempool corruption.
>>> +
>>>  	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
>>>  			Format: <integer>
>>>  			default : 0 <disable>
>>> diff --git a/mm/mempool.c b/mm/mempool.c index db23e0e..4f429a1
>> 100644
>>> --- a/mm/mempool.c
>>> +++ b/mm/mempool.c
>>> @@ -16,11 +16,28 @@
>>>  #include <linux/export.h>
>>>  #include <linux/mempool.h>
>>>  #include <linux/writeback.h>
>>> +#include <linux/static_key.h>
>>> +#include <linux/init.h>
>>>  #include "slab.h"
>>>
>>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
>>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>>>
>>> +/*
>>> + * Debugging support for mempool using static key.
>>> + *
>>> + * This allows enabling mempool debug at boot time via:
>>> + *   mempool_debug
>>> + */
>>> +static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
>>> +
>>> +static int __init mempool_debug_setup(char *str) {
>>> +	static_branch_enable(&mempool_debug_enabled);
>>> +	return 0;
>>> +}
>>> +early_param("mempool_debug", mempool_debug_setup);
>>> +
>>
>> Can static_branch_enable() in mempool_debug_setup() run before
>> jump_label_init() has set static_key_initialized?
>>
>> Looking at start_kernel() in init/main.c:
>>
>> 	setup_arch(&command_line);
>> 	mm_core_init_early();
>> 	/* Static keys and static calls are needed by LSMs */
>> 	jump_label_init();
>> 	...
>> 	/* parameters may set static keys */
>> 	parse_early_param();
>>
>> This will trigger the warning in include/linux/jump_label.h has:
>>
>> 	#define STATIC_KEY_CHECK_USE(key) WARN(!static_key_initialized, \
>> 	    "%s(): static key '%pS' used before call to jump_label_init()", \
>> 	    __func__, (key))
>>
>>
>> mm/dmapool.c registers an equivalent debug toggle via __setup() rather than
>> early_param():
>>
>> 	static int __init dmapool_debug_setup(char *str)
>> 	{
>> 		static_branch_enable(&dmapool_debug_enabled);
>> 		return 1;
>> 	}
>> 	__setup("dmapool_debug", dmapool_debug_setup);
>>
>> I think you can reuse that.
> 
> Thanks for your review!
> 
> While this boot-time ordering used to be a generic issue, it seems many
> architectures have already aligned or fixed this internally. For instance,
> 
> commit ca829e05d3d4 ("powerpc/64: Init jump labels before parse_early_param()")
> and commit 6070970db9fe ("m68k: Initialize jump labels early during setup_arch()")
> explicitly relocated jump_label_init() before the early parameter parsing.
> 

I think 32 bit ARM doesnt? 

> Furthermore, leveraging early_param() to directly manage static keys is still
> actively used and accepted in the current core kernel. Some examples include:
> 
>   - early_param("randomize_kstack_offset", early_randomize_kstack_offset);
>   - early_param("threadirqs", setup_forced_irqthreads);
> 
> The primary reason for using early_param() here instead of __setup() is that
> mempool allocations can happen extremely early during the boot phase. Moving
> this to a later stage like __setup() would mean missing the tracking for the
> most critical early-stage memory pools, which defeats the purpose of boot-time
> debugging.

Ack

> 
> Therefore, I think using early_param() here is the most robust option to
> ensure full coverage of mempool allocations.
> 
> What do you think?
> > Thanks
> 
> -Li
> 
> 
>>
>>>  static int __init mempool_faul_inject_init(void)  {
>>>  	int error;
>>> @@ -37,7 +54,6 @@ static int __init mempool_faul_inject_init(void)  }
>>> late_initcall(mempool_faul_inject_init);
>>>
>>> -#ifdef CONFIG_SLUB_DEBUG_ON
>>>  static void poison_error(struct mempool *pool, void *element, size_t size,
>>>  			 size_t byte)
>>>  {
>>> @@ -73,6 +89,9 @@ static void __check_element(struct mempool *pool,
>>> void *element, size_t size)
>>>
>>>  static void check_element(struct mempool *pool, void *element)  {
>>> +	if (!static_branch_unlikely(&mempool_debug_enabled))
>>> +		return;
>>> +
>>>  	/* Skip checking: KASAN might save its metadata in the element. */
>>>  	if (kasan_enabled())
>>>  		return;
>>> @@ -112,6 +131,9 @@ static void __poison_element(void *element, size_t
>>> size)
>>>
>>>  static void poison_element(struct mempool *pool, void *element)  {
>>> +	if (!static_branch_unlikely(&mempool_debug_enabled))
>>> +		return;
>>> +
>>
>> Before this change, building with CONFIG_SLUB_DEBUG_ON=y compiled in
>> check_element() and poison_element() unconditionally, so the poisoning and
>> corruption checks ran on every mempool free/alloc.
>> After this change those checks are gated on the mempool_debug boot parameter
>> even when CONFIG_SLUB_DEBUG_ON=y.
>>
>> Existing users who relied on CONFIG_SLUB_DEBUG_ON=y giving them mempool
>> poison checking will silently lose it on upgrade unless they also add
>> "mempool_debug" to the command line.
>>
>> Would it be worth defaulting the static key to true under
>> CONFIG_SLUB_DEBUG_ON=y, for example:
>>
>> 	#ifdef CONFIG_SLUB_DEBUG_ON
>> 	static DEFINE_STATIC_KEY_TRUE(mempool_debug_enabled);
>> 	#else
>> 	static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
>> 	#endif
>>
>> so the previous default behaviour is preserved.
>>
>>
>>>  	/* Skip poisoning: KASAN might save its metadata in the element. */
>>>  	if (kasan_enabled())
>>>  		return;
>>> @@ -140,14 +162,6 @@ static void poison_element(struct mempool *pool,
>>> void *element)  #endif
>>>  	}
>>>  }
>>> -#else /* CONFIG_SLUB_DEBUG_ON */
>>> -static inline void check_element(struct mempool *pool, void *element)
>>> -{ -} -static inline void poison_element(struct mempool *pool, void
>>> *element) -{ -} -#endif /* CONFIG_SLUB_DEBUG_ON */
>>>
>>>  static __always_inline bool kasan_poison_element(struct mempool *pool,
>>>  		void *element)
>>> --
>>> 2.9.4
>>>
>>>


