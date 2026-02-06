Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E265AEE2084
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F0F6B0089; Fri,  6 Feb 2026 06:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CEE6B0092; Fri,  6 Feb 2026 06:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415D96B0093; Fri,  6 Feb 2026 06:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 309416B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:14:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6BAC1607D3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:14:17 +0000 (UTC)
X-FDA: 84413772954.09.2DC88D0
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B974100014
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:14:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RaPi3BqZ;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770376456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t10+cy0YbJp1qzuAruOEDHFVPEgf+sIN5MYp954+hik=;
	b=qhpeVJO/BQ3oAebpl2UTroWiUU2GCxBsjsnfQUJLGQml+j8Dq3lF0SESgThOeUJl7XONqe
	IE+59NRQgnoemIN4JNie8wPFxVvrO0h+UH6jGzuKD7TURXBGs6PPkMg1YL1HqDQf5ELfwg
	K/F9MNhZvs0b0CttOcP1XffxUtP26OY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RaPi3BqZ;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770376456; a=rsa-sha256;
	cv=none;
	b=D9+tPBq50v+JdKkgrBeEy/u3oeqEK+O6iwJc3RMehv52Opi9cBYTIDsWPtuZoDbSwsNOdS
	Idvq0YwfA7Muay2dG0f83Da6uK2BlLjRV4gOgumdIQy2zi6dC3or/R0LfALxJSoKVlL6ad
	lS2jHf3aV0aznzzmEnbp5daqH9Yeuzc=
Message-ID: <1663ae90-3247-4e12-a25a-049fc3281e19@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770376450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t10+cy0YbJp1qzuAruOEDHFVPEgf+sIN5MYp954+hik=;
	b=RaPi3BqZPsLqUSHKWvjkyZ/Bf9ppgLwDMnRp3djinkfcParF3X0U5UOMZXVjnrIIj+XKGG
	qik03O+yZh0BczTm4tqsQ4ypqJYxgFR02cW1b2w7PUE2iHSCCwxRYQBdSb0+Sx1HZWERjm
	cI4FFTRQSuQeqxHQ+OOhNwrumpE+hso=
Date: Fri, 6 Feb 2026 19:13:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
 CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
To: "David Hildenbrand (Arm)" <david@kernel.org>, andreas@gaisler.com,
 richard.weiyang@gmail.com, will@kernel.org, peterz@infradead.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, dev.jain@arm.com,
 ioworker0@gmail.com, linmag7@gmail.com, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
 <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 4xbp4imfrcoojahmy76k431fsest4o3c
X-Rspamd-Queue-Id: 2B974100014
X-Rspam-User: 
X-HE-Tag: 1770376453-290607
X-HE-Meta: U2FsdGVkX18B35F1oRV3clba4PKrizzdLNPbo8ieQ6/iRXXtFDn4UZW3a0LsT6ptC5cfHya6RDrufjJzTvfwfkDxsbCZLD8B41c8T95UpKV/A6hf4R3VteNrY0xluMXbfheo0MFBILPLCtY6HFSKnPHJ2gEpfA70rUN9SI36XdKcdC/vpDB/m0fNbAvZkQSOxVMxNUR8n+O2gKkjxp9jyG9wHnjug21+3oZM6x/wY8O5NE+jkIHVX0X9QeglJp6tsQkbbNPADow/FS03CiXaJT2SkF4atoTD7tVTbviie/kiwBdO1W0tp+iPwfrd9L9JL5gApRf7rrQqAAm1TztQeIho1cOLC0tSK4NpTZjHQzSG7SvIba7K9oYoP/lnsu6VhE4W4Qwj6+LQygg6wwNsdwkTTeLHif6HwqVin7LbmdqBZGaIACsIACtsNgowVhPMnjLO/62+MKkVHekPCle3ZMJlfSIGlNreN+Eej96SpzrZP5XJGI3+dekwOnuZ6aZ2YjhKmAMvP6NEAxAkFgEfyTmrr12ByiAvpodU/dZVGHV6tk7ZT7cZAAYs5H27wtPhsykQeZ/Ghs3eLWpj5yLDaVhJeRPCPOTPsUm6OPTVWouJ+vD9tZmsAvXC89WPC4eJXoUrHLPOgu1kv+LSroRVC/S1sL1+7PHSbAfgT1Kj1b8Ve+WF9NaGCwOb90aFB72RKiRCx110TWmncia6H5gIgPanta/XOUQS+N8yJpiu7JSPKlqQta+Xg4LUS3jWbmhWG0KM1e3cN6BK+XDkbLliiak/rGS39lblciw+ng1v8tJLieiwXVl+AjgvLYHCz5QsXK4usUS7BGPKKJcazd8hZlLWctXFYx8RoPIK6Qlg9GmCTMka5Wf4DPfraE7C6HqSBDqEKbc3mcK0g4Dj/b51HcRant0prJJMiE5vLldBbyTcYVYITOnHAU9oHsSfCHb7PehfYztki5xksKMDhJA
 F+wc3E0j
 7wGTDiKXm0z48yi9OgKETaOVyHEIr5dHG+yqRQna66J8R1rHT6lspXK73h49n+NUiyrihK5a/ayQVWVpXVdDhWE7muDanBqy56QaGU7qR2K7PE1wpF9zWldXubFrDhQ3nVpFSuQA9P4okkzvucq2pQb6VZYFiTQI7o2cUOAcMU5mNlBqMxKGtaZ3BI1YZ6idhF8qENR7hMhFKnn731onIAvwJn9hc1fS1VOArjBw6DXVEVAwYhYxE0dY6GpvlVUVowxWbGl2z13ydc5j9JrrRK7f+yjlGRsT/v0O47aW+WZy1aM99OzLu1yNqU2PaFi6ShpI+h8x7xt+N3D+jKCj2fkIb7lwlTMPZayqBsPJ8i+F7J7OpYnATXKKJVBhX8E0cjfSOOS9BwrqICUdloi/PeFsIXUcJpa4DZYUS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 7:06 PM, David Hildenbrand (Arm) wrote:
> On 1/27/26 13:13, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> For architectures that define __HAVE_ARCH_TLB_REMOVE_TABLE, the page
>> tables at the pmd/pud level are generally not of struct ptdesc type, and
>> do not have pt_rcu_head member, thus these architectures cannot support
>> PT_RECLAIM.
>>
>> In preparation for enabling PT_RECLAIM on more architectures, convert
>> __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config,
>> so that we can make conditional judgments in Kconfig.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   arch/powerpc/Kconfig            | 1 +
>>   arch/powerpc/include/asm/tlb.h  | 1 -
>>   arch/sparc/Kconfig              | 1 +
>>   arch/sparc/include/asm/tlb_64.h | 1 -
>>   include/asm-generic/tlb.h       | 2 +-
>>   mm/Kconfig                      | 3 +++
>>   6 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 9537a61ebae02..b47aa8fd62742 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -304,6 +304,7 @@ config PPC
>>       select LOCK_MM_AND_FIND_VMA
>>       select MMU_GATHER_PAGE_SIZE
>>       select MMU_GATHER_RCU_TABLE_FREE
>> +    select HAVE_ARCH_TLB_REMOVE_TABLE
>>       select MMU_GATHER_MERGE_VMAS
>>       select MMU_LAZY_TLB_SHOOTDOWN        if PPC_BOOK3S_64
>>       select MODULES_USE_ELF_RELA
>> diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/ 
>> asm/tlb.h
>> index 2058e8d3e0138..1ca7d4c4b90db 100644
>> --- a/arch/powerpc/include/asm/tlb.h
>> +++ b/arch/powerpc/include/asm/tlb.h
>> @@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather *tlb);
>>    */
>>   #define tlb_needs_table_invalidate()    radix_enabled()
>> -#define __HAVE_ARCH_TLB_REMOVE_TABLE
>>   /* Get the generic bits... */
>>   #include <asm-generic/tlb.h>
>> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
>> index a630d373e6453..25fa2908d6152 100644
>> --- a/arch/sparc/Kconfig
>> +++ b/arch/sparc/Kconfig
>> @@ -74,6 +74,7 @@ config SPARC64
>>       select HAVE_KRETPROBES
>>       select HAVE_KPROBES
>>       select MMU_GATHER_RCU_TABLE_FREE if SMP
>> +    select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
> 
> Why the SMP? At least in tlb_64.h, it was not protected by SMP IIUC.

Ah, It's just simply aligned with the MMU_GATHER_RCU_TABLE_FREE above.

> 
> Apart from that LGTM.

Thanks!

> 


