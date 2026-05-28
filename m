Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE360CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D11C6B009E; Thu, 28 May 2026 08:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A85D6B00A0; Thu, 28 May 2026 08:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE616B00A3; Thu, 28 May 2026 08:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB806B009E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:59:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1FAA1207E2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:59:48 +0000 (UTC)
X-FDA: 84816835656.14.029CB0F
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id B886314000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:59:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gEgOWBYl;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973187; a=rsa-sha256;
	cv=none;
	b=bsAflLXgkgXkgDCt73ugqfS57whKMhdnzO9OvdRptT/irte1o4os6W0VHXbdyxMl2nnnyd
	FXFMrX4qazGVt+RXBjvSPxXw7igwcg19t40fHHQMh9ixFgf+cZSFoY9Cz7tyc5bLP9xtBl
	NX1NqK2sKUO/AI6MjcE6qPXQ7JW3LNE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gEgOWBYl;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7aIdks3CmcGjyyyeA3kszxapotlnaFMZvWoNmtYiZ8=;
	b=DganNyk01kmhDRAUKCEWXZ+31gFnu9xQa3nBpeOmjogiFYEUUO0eanQDDcWeoXdvg5GFsE
	kULzU3X+j4XczeRttzWv1dENgrrkjPfqKJ9QUzZDmjuveKPh9jmhA33h7ZP2vxBZukLjwy
	4yzLOxvVs2LmYnzMQZfljtetA8qPizQ=
Message-ID: <6ca2af4a-90ed-4d7e-9c21-42ebffddc3fe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779973183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/7aIdks3CmcGjyyyeA3kszxapotlnaFMZvWoNmtYiZ8=;
	b=gEgOWBYleLfJ4o8TSg0b50sNALcy2gCscDl4hn9L3rEguhiBPhziUkl0d99DPhO9vrbiJA
	YW1cr5Ep5I+x6SCOT8z3GK/UPBroP4o1fdzutyJQgI702NZG5ifiEXWxWOJ0OmwG8O9ddc
	PPlposNDvM6/0Ynl+Tvu6F1gAfrF4uI=
Date: Thu, 28 May 2026 13:59:37 +0100
MIME-Version: 1.0
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BB?=
 =?UTF-8?Q?TCH=5D_mm/mempool=3A_use_static_key_for_boot-time_debug_enablemen?=
 =?UTF-8?Q?t?=
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
 <ddb499d5-6821-4fa7-9fec-563bdfbc8cbc@linux.dev>
 <b9d53cb0be024778b09e1bb1ef7d0211@baidu.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <b9d53cb0be024778b09e1bb1ef7d0211@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B886314000F
X-Stat-Signature: mgtraku1df1e1gsuyd1z5ssrr3diok6d
X-HE-Tag: 1779973186-718279
X-HE-Meta: U2FsdGVkX18N+xX169rdk+A/MlNyy70da9BfOlcG63Tyuupugfrq3buErdeIjMBssx/J/nSfLq9bes5PQxvHyZvvUgDNcqwHQuIs7uz4cWZGR/M7q9HDF66DSYQstGxqtWbzmErcknyWQd0x6aFd7iK4vuUGitSZNcf1f1xnuFFSZB9fmK+ftMJO6grDPHf1ZN8Gte5Qm1XfZDXvmcnnEOpnacPC293V44qKIAM/7SoUix7vqWBr9kCiq7oSdzlwOYwCyTMpMAjvRkTczMZxOuxBZ0DGiONRKS/O5Li4s9h+P7p8w5hdV9Ks0/rp01/jTwLL6SU5wpLYeSziE0z/EyaWDC6aQapUnuIEp4ZzlYn7EEjdIBxNvQdK0zqtz9nee3E8Y3Op0/1EsFFK5xhpceMkWe4cqtxJAo0rlnIL1mqp8dF2NgKl7bWBjs35QHxv0lWBDOdX/WDDvekg5oGI8/nL0adfm5pdeowFVBZNIywtc57QCToTHfKVT+8Jg4J2ZGOPYxgHVfBjIDMFDbcAoCEkhn14iDwIEwzbR5NGIcjWpQeZl9bGEYpUkY/lWIXjXOWLi3vgGNItgWDAlMcXwdxJ3pJRKhT+BgckilGt/T3b8ymbvZL3YdNcsRAmn0u/KVsVuzXA0/0/aYjeHSYLNHjqa954bYOiRYOzImW8F+Xwkw5+tKC3izfGWZzDnmbuMxozF0ZDAeADHWLKIfDe01ySQFS54YG6djYZZTAjWxkzSDC/prB37F19MoPZKR92pFaTRrFtIPLiHqSUGC1mDjux+c2W+druah74ltszaPjVcben1ZeODn0QUjBYKxEivh4Pfr26PlScT0OMyAgBLNOiD/mkEw/6dz8FtdDy62T0V5qGV1d/upXc8ZW04i585CJXTX0tRNFNI9Fydgx9FkGgzEsKOPOwG2IyljaXQBZDf/ogVv8T38zQwWhtxEvUONmA38RdZZBtDPM99ZJ
 IhT6S4JJ
 TVX6nY64OY3ugWIosuXJdf27S2fP+qZNGO3ucEHHWp46dhmVUWPkUMHJyU1kNTH7/qPrwaePsuEbxEXVSOin5izDEAmLCUW+vj97pRq2uLhZHf4ehGTL6vi1geypZaw/XS+StP/gjaz7k9WuobcVtUV1Okyowdh64aFq5Vtu5UQ0WWxIEnHyK8aOtJImGV0AtRuGRwK9BtiLJJGEpjktldMOugqYMXjTzntCqly5OYFVL3CobHRVFAUtvn5rBnEGJoWKe3gVIi82GjUsPv4WjVy+07AZ/i4ij9xXhuGAcMog9nYMRYSY86/ikc/vAJtsnZYuW0ODzoXcR5XgLvatS4hd+UNTlRn21x7h3NJ2kqmBeUs0WhIO/MIkjXRyVwihvAEztNM7sDpCWW1nisNXsILzVLfUsdK8NQbS+V0AEp/+TOYlKH1UJsWdHypPVTVvLPNpADOnUoRiw2BQAD5MFwzE4jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/2026 11:50, Li,Rongqing(ACG CCN) wrote:
> 
> 
>>
>> On 28/05/2026 04:00, Li,Rongqing(ACG CCN) wrote:
>>>>> From: Li RongQing <lirongqing@baidu.com>
>>>>>
>>>>> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with
>>>>> a static key (mempool_debug_enabled). This allows enabling mempool
>>>>> debugging at boot time via:
>>>>>
>>>>>     mempool_debug
>>>>>
>>>>> Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:
>>>>>
>>>>> - Debugging can be enabled without rebuilding the kernel
>>>>> - Uses standard kernel static_key mechanism with minimal overhead
>>>>>
>>>>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>>> Cc: Vlastimil Babka <vbabka@kernel.org>
>>>>> Cc: Harry Yoo <harry@kernel.org>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: Hao Li <hao.li@linux.dev>
>>>>> Cc: Christoph Lameter <cl@gentwo.org>
>>>>> Cc: David Rientjes <rientjes@google.com>
>>>>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>>>>> ---
>>>>>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>>>>>  mm/mempool.c                                    | 32
>>>> ++++++++++++++++++-------
>>>>>  2 files changed, 28 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt
>>>>> b/Documentation/admin-guide/kernel-parameters.txt
>>>>> index 35ed9dc..5a070e6 100644
>>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>>> @@ -3998,6 +3998,11 @@ Kernel parameters
>>>>>  			Note that even when enabled, there are a few cases where
>>>>>  			the feature is not effective.
>>>>>
>>>>> +	mempool_debug	[MM]
>>>>> +			Enable mempool debugging. This enables element
>>>>> +			poison checking when freeing elements back to the
>>>>> +			pool. Useful for debugging mempool corruption.
>>>>> +
>>>>>  	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable
>> memtest
>>>>>  			Format: <integer>
>>>>>  			default : 0 <disable>
>>>>> diff --git a/mm/mempool.c b/mm/mempool.c index db23e0e..4f429a1
>>>> 100644
>>>>> --- a/mm/mempool.c
>>>>> +++ b/mm/mempool.c
>>>>> @@ -16,11 +16,28 @@
>>>>>  #include <linux/export.h>
>>>>>  #include <linux/mempool.h>
>>>>>  #include <linux/writeback.h>
>>>>> +#include <linux/static_key.h>
>>>>> +#include <linux/init.h>
>>>>>  #include "slab.h"
>>>>>
>>>>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
>>>>>  static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>>>>>
>>>>> +/*
>>>>> + * Debugging support for mempool using static key.
>>>>> + *
>>>>> + * This allows enabling mempool debug at boot time via:
>>>>> + *   mempool_debug
>>>>> + */
>>>>> +static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
>>>>> +
>>>>> +static int __init mempool_debug_setup(char *str) {
>>>>> +	static_branch_enable(&mempool_debug_enabled);
>>>>> +	return 0;
>>>>> +}
>>>>> +early_param("mempool_debug", mempool_debug_setup);
>>>>> +
>>>>
>>>> Can static_branch_enable() in mempool_debug_setup() run before
>>>> jump_label_init() has set static_key_initialized?
>>>>
>>>> Looking at start_kernel() in init/main.c:
>>>>
>>>> 	setup_arch(&command_line);
>>>> 	mm_core_init_early();
>>>> 	/* Static keys and static calls are needed by LSMs */
>>>> 	jump_label_init();
>>>> 	...
>>>> 	/* parameters may set static keys */
>>>> 	parse_early_param();
>>>>
>>>> This will trigger the warning in include/linux/jump_label.h has:
>>>>
>>>> 	#define STATIC_KEY_CHECK_USE(key) WARN(!static_key_initialized, \
>>>> 	    "%s(): static key '%pS' used before call to jump_label_init()", \
>>>> 	    __func__, (key))
>>>>
>>>>
>>>> mm/dmapool.c registers an equivalent debug toggle via __setup()
>>>> rather than
>>>> early_param():
>>>>
>>>> 	static int __init dmapool_debug_setup(char *str)
>>>> 	{
>>>> 		static_branch_enable(&dmapool_debug_enabled);
>>>> 		return 1;
>>>> 	}
>>>> 	__setup("dmapool_debug", dmapool_debug_setup);
>>>>
>>>> I think you can reuse that.
>>>
>>> Thanks for your review!
>>>
>>> While this boot-time ordering used to be a generic issue, it seems
>>> many architectures have already aligned or fixed this internally. For
>>> instance,
>>>
>>> commit ca829e05d3d4 ("powerpc/64: Init jump labels before
>>> parse_early_param()") and commit 6070970db9fe ("m68k: Initialize jump
>>> labels early during setup_arch()") explicitly relocated jump_label_init() before
>> the early parameter parsing.
>>>
>>
>> I think 32 bit ARM doesnt?
> 
> You are right, 32-bit ARM doesn't. 
> 
> However, the correct architectural approach should be fixing the boot sequence 
> inside arch/arm/ to match arm64 , powerpc and m68k, rather than compromising core MM 
> code with temporary boilerplate variables.
> 
> I prefer to keep the mempool implementation clean. If ARM32 triggers the 
> warning, the proper remedy is a follow-up patch to align its setup_arch() 
> ordering.
> 
> What do you think?
> 

I think it would be a prerequisite rather than a follow up patch inorder to not
break 32 bit arm. I will let ARM and slab maintainers decide on this. 



