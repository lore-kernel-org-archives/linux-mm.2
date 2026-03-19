Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E101091903
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A346B0095; Thu, 19 Mar 2026 14:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51F16B009B; Thu, 19 Mar 2026 14:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67C56B009E; Thu, 19 Mar 2026 14:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B77946B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:09:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 837071A0687
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:09:13 +0000 (UTC)
X-FDA: 84563599386.22.F6DC4C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC67820002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:09:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX+5ATXa;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773943751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0/Rtf4mdU/0HDs0A9SNaDuzgSU+uL/VU12OEEC0CB8=;
	b=vXvP2GjsK8ThL3yy3n3keClM2JCa/uGk6wH0Whndvnn7yVyksqw17n/n5BJdwgq84VMgB2
	l4zjcxb/uFmRWYbTSyuO5auD+RXErbP2dyaSwmZDo8RI5Uh3BKLQVpqQce7lANG6G9u2oz
	8ms6z1j+Tv53uN9c/gD6+AqRengzdFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773943751; a=rsa-sha256;
	cv=none;
	b=bY9ge/O8eIjTVBe6hwDdEGRIIVgGf6mfBWPOWE+j25UmcSqbf4CH/GnCtioyV2AKAYSuu9
	bgvzIv5csl7Cw3euVHQEPNxSETa2Byp0K+ZNprem3A0Y/3hC4MHyNY9JfzDxK3um0FHJFd
	HtbkntNmTxw6ZMsauszAkHsR/EaJpCs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX+5ATXa;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52D3B434F6;
	Thu, 19 Mar 2026 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957E3C19424;
	Thu, 19 Mar 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773943750;
	bh=6e0EEIIbFUQq892CEmzGoS89gmnjToRL3GjT58TAgu0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qX+5ATXaTeCVWnoq1pb3+DCvmHvgnPIAYR73j5oOUNNdhwJKMvxcxvMznp8qHd0GX
	 xv9Nr4ET8PVsG4aPWJihjD17Yv4iSbwgqNwABsBQW9fob6yyIX9OL4T2HWsZX6uCus
	 TFTxhLxBv3my3hJsS7WCE9HsFSKoBMrCM00nIZRsc3Cjm5vt8s5urJsnDYrzNSpl5W
	 iLWAQ195xdMWcV+3wWlfcPK8SqBN9pQvzG7SgVOkmXFjAbrbNl7km4EVw8CntlIph+
	 dgN4D/4rF2yXtEVk2ehm0cNMmvNiiHv2w0hPJ/ndW32TV+0f0DlGB7PdfcvTzv01cO
	 LSmnz5V9S1qOw==
Message-ID: <e166588e-036c-4fa3-81fc-d7aca9f02c29@kernel.org>
Date: Thu, 19 Mar 2026 19:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
 <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jdh3i95enxowxypgitgazjqjyczx9e63
X-Rspamd-Queue-Id: AC67820002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773943751-886835
X-HE-Meta: U2FsdGVkX19KWWheQdQ7hu32ajT5z82ALBDVx5k3V2o+14OKZVLNOdGBDzvo4rgzkiwzmNKLuF1ifouIJXYlOc8HfU12PkiTw3R1WMHJmIGxykLleZM87ZiN+uWgAH1Uc2BEA7moWkh1LVqk0UFhp9qACGTbTPjHfFmSbEQ7Ubv4sXNvZhwrzLkLNGMv5BWFgdjkLLsmm50Ofozv+iLsj0KIQhDPKtDmwLvgluU5QK1e7yys4Se3AwNDR1U03omkU0v6tZDKiT1tv2HtSbtPFxI0CdxXia/M00VkyjjYsG9dw7ZrnlhmKdA3/FjiixA6cZeoePcOPPghyReo6eMbALOjeW+f++pRKxlAptded0HWIZ2jclskQ6UJdslG1O0X7wC0zVARuicA6m2oGxpuRbwyTgKWu71x8C37sVEXHnMQjTtiHhl3AT+X0XAB5bGWbH6yI43hZUY2mRlUPQXy8zHVkvevFEqzgwWANFQaNEssv55t6Ce3z3kcM4GzeqByWIYNDF5kD6vbQHsq8F4Hk52iLWdaaW47L59aGRlAfl29z+JPnGOWCr5ZNrd4AHWNelsT7KnyuJn1WQgDWjSQeQfmizM47R2CM1hCR7iDPSCoOPBdTSaCPD3VNQ+yfC4eQfan2Db2QDKC6oGaXUBIQ3icRJqAcb+KO+wEEZWJjinCoAqgdKDajJT7LQepNza/1ZAUH2uZ9xV4ygQQTG71LNIDC1xCAnbeW9fQoeyWP2AQddTTZ8SK9kWZk9C4fzQB+wJKYIwbx7wkd0Xe0j0bJbFGdmkFp4JL6K96ZhTSyb9CODPEy77AQXmlJF8GiH6HHUPF/pLEm5vJ7x6xIGlGNuiiyy7vQoIIYwqskWdbXNnLtoNAIeHvBVgJAAWDWTLLyMN4DvNGLw8K3Ko9citj4GbLGPxFu2kkw7hj8POx/vdVXjXrGaA+sx9dc3EuGNNNQvVdffU3deh+kyVTBbG
 a7NKFwKs
 SfO9tm9TmjPJxqIj+2LM3zkICmK9BW4EkhLoFFQHf/n++zE+M77SBykRPP/rmU8w1r8kcNeS4dz2nDhKRLQwgclJmx7dFDu8JZNZBngxqYfo+zXJqHU4BS+6iQVGSvLH6NuewsSrPk+q7l4MWinh6Uy37jDXANUb7fwT7syOOO8g004eqVNyFh4VqFfHkVAG9EDdJs0YXrHqe8jHxPjI5d7L3OEKHBEnTR/VlQhMcuWSHWpMwpXd80khetO6r0uJW6JxLR7QI6ivsub+EZICWW0DKISdONFhqGhLzCVLTJg+vOv2OVNAS1Zn0y2h15YaPkGkv3kbP8bGd+eEDf7Prn0aw6C+SHd4e0QmwohZ3dY3esuCX63f7R/Ercx9iYpur7MuHO+nrjjeD+eRdUo7zo/B6mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 16:24, Gregory Price wrote:
> On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
>> All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
>> select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
>> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
>>
>> For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
>> and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
>> CONFIG_CMA and CONFIG_COMPACTION already do).
>>
>> We'll clean up CONFIG_MIGRATION next.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> HOTREMOVE has long been a thorn in my side, I appreciate you cleaning
> this up.

On a long cardrive today I was wondering: do we still need a separate
MEMORY_HOTREMOVE

Now we'll have

config MEMORY_HOTREMOVE
	bool "Allow for memory hot remove"
	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
	depends on MEMORY_HOTPLUG
	select MIGRATION

I'll try to get rid of that HAVE_BOOTMEM_INFO_NODE shite next.

Then it's really just MIGRATION and some sprinkled
CONFIG_MEMORY_HOTREMOVE. Not a lot of code.

-- 
Cheers,

David

