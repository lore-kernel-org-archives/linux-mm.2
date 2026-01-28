Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F20CD35660
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 02:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC6E6B0088; Tue, 27 Jan 2026 21:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A2D6B0089; Tue, 27 Jan 2026 21:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C046B008A; Tue, 27 Jan 2026 21:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5896F6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:07:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E30FE13AD55
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:07:37 +0000 (UTC)
X-FDA: 84379736154.10.DAC5523
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57B00120003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:07:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3HQOiCH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769566056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4t3b1mOfPtHigPq6Z2WHKbf3iNBrW17rXF/iuZKlWU=;
	b=jx6L2bU+bCZuusFYMRpDhKHgysB+MOeF8BniKN5yEaiIGt2v7dD4LlIaHUY8yTNtMg6t+x
	Ngy9MiS6ocsaw2y43Hnep8vjUA+SnaAbWME+9bHrn7MXNayDF9ToETwC+6iVQACW3yDI6H
	lvhkWYOyOAS+JI4OVMyy7Fg2Z/QzXGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769566056; a=rsa-sha256;
	cv=none;
	b=pzYIlAhxPGg56wl8sBru6Xqgxk8uIAGBX86Y6xI7Jw1AUQyztUdkUEXyLw9EGnIaEa++BN
	XWURT2nMtj1T2zt8S4Yoda4awniS5RtzQN+xPD1SUKBm1I+F557pORDvUe5xTjf+Fp/pi3
	YP6gW+JOlDAbHIslIbxWDuvtbs7y21U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3HQOiCH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <4c171a25-e395-4f83-b767-18525fffbee3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769566051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4t3b1mOfPtHigPq6Z2WHKbf3iNBrW17rXF/iuZKlWU=;
	b=I3HQOiCHRK+ra8CKqHdI7J6UYtfRC6z7IH9vbCxNEd8HoqK7Tyx5NW2XzLCUbSdOwtEHCJ
	PrvEUB70GyyRlx7g5xA0Csz7PDTqbdzG32WNgMGufhfuOIaPPVRKNpL+JiU8gfGGSpRv5N
	IuXL9L87r74XS+4rqkFgpDIaGTmcayA=
Date: Wed, 28 Jan 2026 10:07:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/8] enable PT_RECLAIM on more 64-bit architectures
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, andreas@gaisler.com, richard.weiyang@gmail.com,
 will@kernel.org, peterz@infradead.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, dev.jain@arm.com, ioworker0@gmail.com, linmag7@gmail.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <20260127124642.480123beb01ebb487f986a09@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260127124642.480123beb01ebb487f986a09@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 57B00120003
X-Stat-Signature: 74e6pj1a3yy1j45jh7doad7qs97r3bbt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769566054-589300
X-HE-Meta: U2FsdGVkX19BDksoXhzHunVbS9R4JD4MWOI1GFIQe/NgbKHfbClSRMWbitS/tpb/l8cpAX42aBSTNYtMKdFiKZRR41R3OEnBd4+WWoDqi1b6YgXuzxPGDlTe0kl/zpnPoZfZXxn4keyTGfI6/lIy3ucMkSN7jSwoHDfu+qHE29pdoIFf8Yesi4Klsea/M94QXPT2eAHPUqT76YXiboD8+I22Mee6dwimqzYVLkrvRsz8KQ26bBv31Gun/337DH+e+h6fjpTiNiQn+YP8fF/HgbK5YqMiYuu39+LaYdDadVOu3q9Qonxc9EbvZ84Gj7etjWXKlRYWZMjZi2XY+glglpWONtCfEhlylgk06WFS2WtwILa3Pr/+PyBQjHEtH9s1cTxqqbmo8w5cJaBH56egLd9adYTr/30u7ToIehhZxHKVwLzRdYoHy4T09t9DEXPiZoL8YrmdGZWl0wq4+tJHMrgD6/v6KYD2UTtfnj9BYRX6OMJjnYEsMvRR1HgtDI7RacJMpWNYhUkL1Ljbf8frVV/5hPpR39oFMTIQiqxlDsGyVEV5eBkXw+thxJHa1YKqFlm5Ayn3HsWdGbXz1CfnFLAKG7O+jQc6oOf1dsP75B9MWqA0BBcR9QhLuvNL9Cy6ZitMVA53Hv2naJbLJ2Mzh9xomhrhJSdj+YGrEzqj0jRMQGX7MCvhHcx1K6iIofjvw94kuPTKDTBYovKlNcU+Hs4WOoKu7ZvDJ4HOncWpSVPlv0RF8N/3m5nQOhRclXR90O3SWSVUjZUIyQrnz1apz14ffJFbXAJp6+hGTBocbO9U9eZhO52t+r+r5dxqZ5yyjK9cyx5uJ9huIEH+EYXqupgBR8QP78o07X35YA9f9pyEENfFRBCbHzprMSISQ0k9Sn6vo6Ul+pjXcnOByoYh3yT2j05iHeG1k1RcXPtAv4sjMyjHIuZ3S0rzA+Vj1z7HxOB0GPH2nRn2SPIdaGy
 aEEiyOVj
 8xGnDO/VNHuEHzY772CzmgAATWKliXybAeS0DtYI0c9DHFZ5GyoOdS1t7WWwC8Wu5BbmCfRQnUy8Yj4xzRPHE09ca0uWCp3Aj1hzxQuW6gE1BoRNCok77Qvu1a2phCHj1r2o4o+YV1WMuIG67DWUqEPqfNuI5q4gfabK1VxRD6S/sODOGSQixqD7z9TVaqKL4mwpV66+faTntVs790J4vmfNBvV9KC+b/QekmX2421yeKJi9tmFmI8mXBaBrZFfquB7gsARZkfCtDITJ7Krq2Te79pSPJzoH0KvIFLbih20uvUHeVp4cRWrthJ8o56Y0xuFWsCLZb9c2jhYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/28/26 4:46 AM, Andrew Morton wrote:
> On Tue, 27 Jan 2026 20:12:53 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> This series aims to enable PT_RECLAIM on more 64-bit architectures.
> 
> Thanks, I updated mm.git's mm-unstable branch to v4.
> 
>> Changes in v4:
>>   - convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
>>   - fix a WARN_ON_ONCE() on sparc64 (and on ppc)
>>     (reported by Andreas Larsson)
>>   - collect Acked-by (Hi David, I've kept your Acked-by, feel free to drop it)
>>   - rebase onto the v6.19-rc7
>>
> 
> Below is how v4 altered mm.git.
> 
> I'm not seeing the WARN_ON_ONCE() fix.  I assume that was due to the
> Kconfig alterations?

Yes, sparc64 and ppc will select HAVE_ARCH_TLB_REMOVE_TABLE, so
PT_RECLAIM will not be enabled. This means it won't affect
sparc64 and ppc, and will not trigger WARN_ON_ONCE().

I don't have a testing environment for sparc64 and ppc, but I
expect it should be able to fix the WARN_ON_ONCE().

Thanks,
Qi

> 
> 
> 
> --- a/arch/powerpc/include/asm/tlb.h~b
> +++ a/arch/powerpc/include/asm/tlb.h
> @@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather
>    */
>   #define tlb_needs_table_invalidate()	radix_enabled()
>   
> -#define __HAVE_ARCH_TLB_REMOVE_TABLE
>   /* Get the generic bits... */
>   #include <asm-generic/tlb.h>
>   
> --- a/arch/powerpc/Kconfig~b
> +++ a/arch/powerpc/Kconfig
> @@ -305,6 +305,7 @@ config PPC
>   	select LOCK_MM_AND_FIND_VMA
>   	select MMU_GATHER_PAGE_SIZE
>   	select MMU_GATHER_RCU_TABLE_FREE
> +	select HAVE_ARCH_TLB_REMOVE_TABLE
>   	select MMU_GATHER_MERGE_VMAS
>   	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
>   	select MODULES_USE_ELF_RELA
> --- a/arch/sparc/include/asm/tlb_64.h~b
> +++ a/arch/sparc/include/asm/tlb_64.h
> @@ -33,7 +33,6 @@ void flush_tlb_pending(void);
>   #define tlb_needs_table_invalidate()	(false)
>   #endif
>   
> -#define __HAVE_ARCH_TLB_REMOVE_TABLE
>   #include <asm-generic/tlb.h>
>   
>   #endif /* _SPARC64_TLB_H */
> --- a/arch/sparc/Kconfig~b
> +++ a/arch/sparc/Kconfig
> @@ -74,6 +74,7 @@ config SPARC64
>   	select HAVE_KRETPROBES
>   	select HAVE_KPROBES
>   	select MMU_GATHER_RCU_TABLE_FREE if SMP
> +	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
>   	select MMU_GATHER_MERGE_VMAS
>   	select MMU_GATHER_NO_FLUSH_CACHE
>   	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> --- a/include/asm-generic/tlb.h~b
> +++ a/include/asm-generic/tlb.h
> @@ -213,7 +213,7 @@ struct mmu_table_batch {
>   #define MAX_TABLE_BATCH		\
>   	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
>   
> -#ifndef __HAVE_ARCH_TLB_REMOVE_TABLE
> +#ifndef CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
>   static inline void __tlb_remove_table(void *table)
>   {
>   	struct ptdesc *ptdesc = (struct ptdesc *)table;
> --- a/mm/Kconfig~b
> +++ a/mm/Kconfig
> @@ -1448,9 +1448,12 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> +config HAVE_ARCH_TLB_REMOVE_TABLE
> +	def_bool n
> +
>   config PT_RECLAIM
>   	def_bool y
> -	depends on MMU_GATHER_RCU_TABLE_FREE
> +	depends on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE
>   	help
>   	  Try to reclaim empty user page table pages in paths other than munmap
>   	  and exit_mmap path.
> _
> 


