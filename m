Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305CCCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC616B0110; Mon, 18 Aug 2025 12:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C7C6B0111; Mon, 18 Aug 2025 12:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BE46B0112; Mon, 18 Aug 2025 12:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77FC76B0110
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:02:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90AF613937C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:02:55 +0000 (UTC)
X-FDA: 83790346710.27.DAAF40E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id B5850A000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:02:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755532974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4QNxJ3AwcrmxWJXei7lx3D+jrxggbeNTcJnx6MBtMsk=;
	b=yBhvsMl+Dqnc6ghorCWoUn9hI/mlya3LBv/qQzObJTPwh7rJnEcnf6dARAjQ5vbemzGz2J
	67lSpMLEv3rVJwsfGFnJaQpdtvWmBcj03Ib4GZd01BgykGEqLyLFvhFI6pL2HtNHs5O/CF
	N5UOTbJd7Uj/OL+UTguS9/kyqeOIUmA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755532974; a=rsa-sha256;
	cv=none;
	b=RuY9byWebwvuwGbAMeNqnXbOzGBPajmfS2st4eYBZP5J1OCbquJHa3iKf+zJ50yqSI7n1m
	N1J8QKGYTai7SmzoQMQugsfkGPfjp5hU4EddpK/vf3dE3dxq9AVrTCBWcTqL5neoTfhAEA
	iduPFtfeKycXQMYGduNVSy/F+KmnMGM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ECF31596;
	Mon, 18 Aug 2025 09:02:44 -0700 (PDT)
Received: from [10.57.58.12] (unknown [10.57.58.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB0343F63F;
	Mon, 18 Aug 2025 09:02:46 -0700 (PDT)
Message-ID: <b6579c2a-2262-4279-81a5-8235092bea13@arm.com>
Date: Mon, 18 Aug 2025 18:02:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 13/18] mm: Map page tables with privileged pkey
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Cc: "maz@kernel.org" <maz@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "mbland@motorola.com" <mbland@motorola.com>,
 "david@redhat.com" <david@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "joey.gouly@arm.com"
 <joey.gouly@arm.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "pierre.langlois@arm.com" <pierre.langlois@arm.com>,
 "jeffxu@chromium.org" <jeffxu@chromium.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "kees@kernel.org" <kees@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "jannh@google.com" <jannh@google.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "qperret@google.com" <qperret@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "broonie@kernel.org" <broonie@kernel.org>, "x86@kernel.org" <x86@kernel.org>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <20250815085512.2182322-14-kevin.brodsky@arm.com>
 <616011cf17f1654ac3ad8757f0f33425b3af1ddd.camel@intel.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <616011cf17f1654ac3ad8757f0f33425b3af1ddd.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5850A000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jpzidqjx75ut5gebiteewadqjuthud6k
X-HE-Tag: 1755532973-46280
X-HE-Meta: U2FsdGVkX1+zB8mwdfnmh0Wqtu+DhygbJcqbqNTYZRqu5gs2MF7V87TjMvc1Lb0WTrJyl1HowAwsNUfcIcjPqQSttfTBECLPMDLcmAclLflswJj+lJ5SbenyVEjFSyF3ZHwxtDOZEuGv6Wzvz+ke3ruGz5xGavT7WE7oURcIQCKVG/qlZY06tm/zjeySe1dK8asxGVVPkiAiiBMkM02IvaA8Rw6w5C8Kp2O5ZXO+95b88Df5bx8YDFRKzhDvXDeUauOSTUxAzvvEn37OAob+/y8em0lxF6KwWswAGXWriU3ymXb7wp7obF3xkFPsDOZHXNEwjNaPSPDshfnCQie9e6lJvSlG814Dj0mSvZ6HqfUSB93SE3qfUUG1al7PX7x5mdcX9Drf4arLC4D4heYNL5qIIp3xP8uwP9DfbqSV6TXZGZhellDl45xSrBHCR/UlUYu5Of47UzkN10S/e237NkhIlQ3az7Tajj8FGeOsmhSRTsk6itzoXrZt00WOY/6oGYNMxroFJG0dTMcjlQScv8wiu3rg0SsDr6nkJc3FpfajPA6DvzTly0FIkw41nw1Xld9hShxA7+ZkJgUsLf4HY0FoLe0/u5hZJTd4PbtXs/FdF1S5hhMIcGxQ9QC4FGiGect1JWwDBZOP1nS383l6rfoLcXsNudcR5CoryjzEbzBb05X/nGcUcWvaBlStFZH5nM3CSxV4RCM5ubqYTr5l90DmVe/IExDdwxscv/ZWljHlpplog9cUFGTV9bGgOmQnlFUNpZOyokch2kXCzAYkLLcX4625OjUh/zX/gtHHtk6zUe6qXPOuaWbL9Dk77ARrl9LwLkNk/nbkS8rf/C6pgz/p/gtRaX0cWCs/6t3ib4upMZ+8JSdVfg9Kg6xar46AX3KLtWAGCh6hc9lWs6ALa2q84/ZpJPwSlgfrpZfFazCVHByftJDo7M1UBtYgLg6ucMbceaB/ZqE1/SMZGCh
 CA+dtLI5
 RMgOwPXvaumH90Ys+gHT5JizIqyn9wviHoctG2Hh6IwYqv5b7DBnbQBTWqhw6aDAMBcthnmNd47I4MCw7fMAVA//mLGbWX1r7TsoFTmxxNaTrTq5pHafWNTaOJYAQjL/3gGeDx6J2zRtW60Zkpdoo+3Tr9ich4SsnXzdJBgZWqXemufJtav01XxJO8pEEM+7sOhVCFy+40k3ftG6ct8R6X87EIr7n9McGG22Ro8uyHlHjH2sw7Se7VXmu1yFr8KIoqeb7a2gC99Mpn+OH5/rMwjnt++70ABxkkDK5Qw5UxaGKR7mQc4oPNlPBSUEwzqOtU4Ja1zzB5yRR6CXJCO1f9NmOg8tcQULfaaBEoVh9w3+r//Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2025 18:37, Edgecombe, Rick P wrote:
> On Fri, 2025-08-15 at 09:55 +0100, Kevin Brodsky wrote:
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index d9371d992033..4880cb7a4cb9 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -34,6 +34,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/cacheinfo.h>
>>  #include <linux/rcuwait.h>
>> +#include <linux/kpkeys.h>
>>  
>>  struct mempolicy;
>>  struct anon_vma;
>> @@ -2979,6 +2980,8 @@ static inline bool __pagetable_ctor(struct ptdesc *ptdesc)
>>  
>>  	__folio_set_pgtable(folio);
>>  	lruvec_stat_add_folio(folio, NR_PAGETABLE);
>> +	if (kpkeys_protect_pgtable_memory(folio))
>> +		return false;
>>  	return true;
>>  }
> It seems like this does a kernel range shootdown for every page table that gets
> allocated? If so it throws a pretty big wrench into the carefully managed TLB
> flush minimization logic in the kernel.
>
> Obviously this is much more straightforward then the x86 series' page table
> conversion batching stuff, but TBH I was worried that even that was going to
> have a performance hit. I think how to efficiently do direct map permissions is
> the key technical problem to solve for pkeys security usages. They can switch on
> and off fast, but applying the key is just as much of a hit as any other kernel
> memory permission. (I assume this works the similarly to x86's?)

The benchmarking results (see cover letter) don't seem to point to a
major performance hit from setting the pkey on arm64 (worth noting that
the linear mapping is PTE-mapped on arm64 today so no splitting should
occur when setting the pkey). The overhead may well be substantially
higher on x86.

I agree this is worth looking into, though. I will check the overhead
added by set_memory_pkey() specifically (ignoring pkey register
switches), and maybe try to allocate page tables with a dedicated
kmem_cache instead, reusing this patch [1] from my other kpkeys series.
A kmem_cache won't be as optimal as a dedicated allocator, but batching
the page freeing may already improve things substantially.

- Kevin

[1]
https://lore.kernel.org/linux-hardening/20250815090000.2182450-4-kevin.brodsky@arm.com/


