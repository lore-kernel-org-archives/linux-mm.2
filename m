Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61243CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49AA6B0005; Fri, 12 Jun 2026 06:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20BC6B0088; Fri, 12 Jun 2026 06:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936356B008C; Fri, 12 Jun 2026 06:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8332A6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:44:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 358A41C255F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:44:02 +0000 (UTC)
X-FDA: 84870925524.07.F20BBC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6879E20002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:44:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MTS1pZp+;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781261040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQbMfs73vXY/1+2J2uFtoNyupZeXRCVPTMVFi6cnBn0=;
	b=P+EspwEPW5qB4Y0lghfujwi3a/enqpa6TxB0M3OB/pzjgCfqRYvT/Y9j3daQe5AY1QIqUp
	ufRK5FOta4w8sxXbwVfNS2DEs+aiF6qdkYdO9Vq6Ap660QRq2HgvO/W8wxhdtVTqLfrXQf
	0ptIqpTlZh+BdV98w6NPqm2cArEobHE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MTS1pZp+;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781261040;
	b=ZszBVGqfLPcW+R2QlBMm42U2dPz9lUKWK6A5+7lUpjiw+40Ayzq6vJFYg4B+Ib8kDOISWh
	dA5+Zk5K+biKqh8fUE0O/SLomLnuC0xoeYGN7JXQ4KsQTqeNVGqswx23jXghnMSyjCQUUt
	djahNe5/uDbes0LQi0U4dr4x1k/dNL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79BD044217;
	Fri, 12 Jun 2026 10:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4871F00A3A;
	Fri, 12 Jun 2026 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781261039;
	bh=jQbMfs73vXY/1+2J2uFtoNyupZeXRCVPTMVFi6cnBn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MTS1pZp+MgtFarJjoaODYtqJTD6oynJhsyOMuc+MlcUGcmNU+M5S7ZybnIg+MOewt
	 U8HZ2sxOv5kBe035B/q574gj3t2fnqqEVegQdPSmXnqOMjBw1bx2LEVTCXsxCg9BCV
	 XV4r1Y4me1T8E9H492GZxHXDJO+xOmmW5YXsmGQHg5aN/fQgRFClzJGXzpCFVnmWDW
	 CmlGrQiR3qFdkp9iLmTGISabOwkGbblLhQt2QI2CqYSRxqAm2wNpDzTYU6r5ob+HIX
	 2p1H6uecUzD3WaORSYsCPqw1agz24LpYSgDJ7qRJTFHcv0enzoEAkjPHmvWztbgImt
	 k23jfN2US+GZQ==
Message-ID: <cc490279-9a28-4d94-b66a-d529af66cb20@kernel.org>
Date: Fri, 12 Jun 2026 12:43:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHYzXSBtbS9tZW1wb29sOiBVbnRhbmds?=
 =?UTF-8?Q?e_CONFIG=5FSLUB=5FDEBUG=5FON_abuse_and_switch_to_static_key?=
Content-Language: en-US
To: "Li,Rongqing" <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
References: <20260604110318.2089-1-lirongqing@baidu.com>
 <d06d13c4aebe44a2abca4aee0083644f@baidu.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <d06d13c4aebe44a2abca4aee0083644f@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6879E20002
X-Stat-Signature: 1h9hd4hyjdjgjx683ctpszxudwgio6i4
X-Rspam-User: 
X-HE-Tag: 1781261040-81812
X-HE-Meta: U2FsdGVkX1+9qPj7q4l5zqzuOzqT7kPuhNEkyzDfoqb74Q+G7UefGxEN2JJZx7zmrNcvD03z6tJwIMkygLwexgdLazpS0ohORblhjw+vAS6FYFrW6FWnY5iU3A3U+r6Xucvs4lPnYuC/iatupC/DAa3wJ3f0lgOG/JyNoCHMo6vFJXFEyUP25jzZcmFPt13tlRZzzYdmTIAQhjIY+l/nF9fNTUdc41dJqgUeuIrS/5mxkB7pnfYzPMORYTA+/ruMa+Ux99SI6hde2o1Y8JYlo5cWpIVVo70nc/INWUQF+MzYZxzoihw5Ikphy7WU+cuZbpdtWMKNQ8gNTQCkCEojPNRcZKB+2q0IHbAtCGy+YKI0TuR+UYclGWAVipc5rpNHLkfzTOe0M9ZWQs+wInJyDOFAYRduUruKWE1ShGtRgBICC9FoTiyVbyYsg2f/HN0vvY4q2/1dJoMeGtldToBp9caJZkhZySKV13clJcXMc9HEBndw02CXW1teR4ocofHUrD1ZFXsk8wdTTuN10HRgDh7xR5TNak4RwjyuWpFCJKB1TA6QNHmj4qZpt++EdUtuErhXBTOMWJqXEv/Mi9Np10N6bPkjT1k/gzRved6qyx/bbB4VIPSsUyl5erjmt+JaidDWFkVcHXCpl7GikvN0U5ZaYXPMQr0L1P0b5uH+8RcwXUTtmMfGOKhrhgpPXCO91nmdPuLnH89u869cKjpBS/jyQanKWxoLf31JppR7OcJMjPh6oUCrLHzLvDK6m6X4EBRgfWDo7h9hgrRQEC7uQ0i+3hFnSOTHs1L5xg4K/ZoGdGZZBsI/JRHEgkQfHgEW5Wke7F7lCRqgX0vOU6G47gMeA6OygUpf2cDReoXumMd9DszVWF171cD2jG6lQLMjl0B/O26Y0EyPmB7IoNFD86joGEKx3QttNBGkPYTWSQY3WIwVrXVpQ9kIzzKufJX7KAgz4nJNXy+XPNxCljF
 Jx7YiOo1
 fGLe4uhHlqmh1uezJzEguf7XKS4A8jgw8BAgLeBtG+77nOFmEZeVPmpo+pGPd+IUzZwpd9xPz9BM2zbnnD1sIbqxdPs62+/JDLlOE4E88NSwLxJBb49yxJvJIWRt1fsZoR3a9v87aup9dGfvhWt5JtL6WRWzzz/pD2TBpif06r3xQxU72XqhyR2z1vrXVIEZqjZNfPhS4lAVoLLKZKUkhdoJCOdsQcaUdTCzW+STldxQbQyqaXQTOHJjrL1tP3AV4XIYPjrdoZ33b+rjr7q0tjQC3Jp8E0iFxGU+kvf17kFHlmXFJFANgc8utMVOaxEardXn2t/QkJWT96+R6JP4XijUXpdQR8qpA82RysUUtMuCK/HbiPVjd+ujIgrs4Xt93k1ji8x4k2JDqjsEtlZuTCnVgKipErDkv0T4kTwE/ultxAqNwqRCIU7jvI6Jp1OqxNzk/JtjNs7hG+nGT3/gHjs8zgZ5Vr4dxyl5FXnCVDnKpJl+LSS+r2ZcF7vxzhNOaCLARXyRfBXGBLzpaghF0PuokWpnNQWO8edyg9tqqGAcJxAamuVgpFIwhEUh0LQccXa47G2sFMqKxAQhhe8L0BfP+tDu4/2bNdmAZQPoCOHp0LtLwyZaCAvP8aFx0RzIQ3duBtfi+L/+pAXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 12:12, Li,Rongqing wrote:
>> 主题: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse
>> and switch to static key
>> 
>> From: Li RongQing <lirongqing@baidu.com>
>> 
>> The mempool subsystem historically wrapped its debugging logic inside an
>> merely defines compile-time defaults for SLUB and caused two flaws:
>> 
>> 1. On production kernels where CONFIG_SLUB_DEBUG=y but
>>    CONFIG_SLUB_DEBUG_ON=n, mempool debugging was completely
>> compiled out
>>    at compile time.
>> 2. On kernels with CONFIG_SLUB_DEBUG_ON=y, mempool debugging stayed
>> active
>>    even if a user explicitly disabled slub debugging at boot time.
>> 
>> Clean up this mess by removing the #ifdef and switching to a runtime static
>> key (mempool_debug_enabled), allowing mempool debugging to be toggled
>> cleanly via its own boot parameter.
>> 
> Ping 
> 
> Thanks

Sorry, missed this. Since it's just before merge window and it's not
critical, will queue it after merge window for 7.3. Thanks!

> [Li,Rongqing] 
> 
> 
> 
>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> Cc: Vlastimil Babka <vbabka@kernel.org>
>> Cc: Harry Yoo <harry@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Hao Li <hao.li@linux.dev>
>> Cc: Christoph Lameter <cl@gentwo.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Usama Arif <usama.arif@linux.dev>
>> ---
>> Diff with v2: Move the check out of check_element/poison_element Diff with
>> v1: Rewrite commit message, change early_param to __setup
>> 
>>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>>  mm/mempool.c                                    | 35
>> +++++++++++++++++--------
>>  2 files changed, 29 insertions(+), 11 deletions(-)
>> 
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt
>> b/Documentation/admin-guide/kernel-parameters.txt
>> index 642659b..89b5994 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -3980,6 +3980,11 @@ Kernel parameters
>>  			Note that even when enabled, there are a few cases where
>>  			the feature is not effective.
>> 
>> +	mempool_debug	[MM]
>> +			Enable mempool debugging. This enables element
>> +			poison checking when freeing elements back to the
>> +			pool. Useful for debugging mempool corruption.
>> +
>>  	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
>>  			Format: <integer>
>>  			default : 0 <disable>
>> diff --git a/mm/mempool.c b/mm/mempool.c index db23e0e..dabe05c
>> 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -16,11 +16,28 @@
>>  #include <linux/export.h>
>>  #include <linux/mempool.h>
>>  #include <linux/writeback.h>
>> +#include <linux/static_key.h>
>> +#include <linux/init.h>
>>  #include "slab.h"
>> 
>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>> 
>> +/*
>> + * Debugging support for mempool using static key.
>> + *
>> + * This allows enabling mempool debug at boot time via:
>> + *   mempool_debug
>> + */
>> +static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
>> +
>> +static int __init mempool_debug_setup(char *str) {
>> +	static_branch_enable(&mempool_debug_enabled);
>> +	return 1;
>> +}
>> +__setup("mempool_debug", mempool_debug_setup);
>> +
>>  static int __init mempool_faul_inject_init(void)  {
>>  	int error;
>> @@ -37,7 +54,6 @@ static int __init mempool_faul_inject_init(void)  }
>> late_initcall(mempool_faul_inject_init);
>> 
>> -#ifdef CONFIG_SLUB_DEBUG_ON
>>  static void poison_error(struct mempool *pool, void *element, size_t size,
>>  			 size_t byte)
>>  {
>> @@ -140,14 +156,6 @@ static void poison_element(struct mempool *pool,
>> void *element)  #endif
>>  	}
>>  }
>> -#else /* CONFIG_SLUB_DEBUG_ON */
>> -static inline void check_element(struct mempool *pool, void *element) -{ -}
>> -static inline void poison_element(struct mempool *pool, void *element) -{ -}
>> -#endif /* CONFIG_SLUB_DEBUG_ON */
>> 
>>  static __always_inline bool kasan_poison_element(struct mempool *pool,
>>  		void *element)
>> @@ -175,7 +183,10 @@ static void kasan_unpoison_element(struct
>> mempool *pool, void *element)  static __always_inline void
>> add_element(struct mempool *pool, void *element)  {
>>  	BUG_ON(pool->min_nr != 0 && pool->curr_nr >= pool->min_nr);
>> -	poison_element(pool, element);
>> +
>> +	if (static_branch_unlikely(&mempool_debug_enabled))
>> +		poison_element(pool, element);
>> +
>>  	if (kasan_poison_element(pool, element))
>>  		pool->elements[pool->curr_nr++] = element;  } @@ -186,7 +197,9
>> @@ static void *remove_element(struct mempool *pool)
>> 
>>  	BUG_ON(pool->curr_nr < 0);
>>  	kasan_unpoison_element(pool, element);
>> -	check_element(pool, element);
>> +
>> +	if (static_branch_unlikely(&mempool_debug_enabled))
>> +		check_element(pool, element);
>>  	return element;
>>  }
>> 
>> --
>> 2.9.4
> 


