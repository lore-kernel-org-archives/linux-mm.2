Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A43C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9736B0095; Fri, 24 Jul 2026 12:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1186B0096; Fri, 24 Jul 2026 12:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7E36B0098; Fri, 24 Jul 2026 12:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2532A6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:54:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1088A1232
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:54:09 +0000 (UTC)
X-FDA: 85024267818.18.2C1C5BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19D4B180009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:54:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yxe39jIv;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784912048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNcmPxfRJQMtu5X0pj3wcAJCBsBKUUg7nsN4VhDio8k=;
	b=PA/fmgPw35dH6av9RsD894q3iLTjrkDf3zZHEUlX3La211Tkk/QXy2A72fRtsC7tLaKNv0
	Z7YF4RpAtIzRWBD9WiErE0/AzHm08LZL+HdMr0TX316OyRmNkheZbdLyw5oLze/5tjTBF3
	Y0V1Wimi/JgOSkxHlO8f3i1SZNHk5H8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yxe39jIv;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784912048;
	b=dI/NLJ/5NlyXDBL1/zFIb20m5FaLbU4D5Rq7baLXc5pbBuINmPbmDuTU2Hy3FhPn48Ti0z
	UQLkmpcNHbwsEBtSI0Ih9h7t/7PUviAPy6unf2APRF5xjcZGx62b+QIhFWgNyO4R2bFo25
	serPMVFCSwDJulbXj1QIkonHr+68n6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D536600AD;
	Fri, 24 Jul 2026 16:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3291F000E9;
	Fri, 24 Jul 2026 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912047;
	bh=uNcmPxfRJQMtu5X0pj3wcAJCBsBKUUg7nsN4VhDio8k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Yxe39jIvTCcqCfDHGXA9bJRbgJwrAzkgmnmNq/txHjKzKdJSjcqFSGp338WI2WcOh
	 JNM+sR68lVt7AEID/otkdwv/7fK5enEazDCwQqgMvQu0QeqMQiZJtcvoR2/st3Edco
	 78otWKQOtrReQtPWBgwpIcXClrZcLDljk/tj+K87zZ5NRnnmfEvPQ5LIQfYHrQ7ROo
	 64pkPRyj6JlTsIhc3wZ5VF8fEXVcGLPfmOf2OcVEfIq3mwYE8/xQG5k6oQg7dKcN5G
	 xDc1jiT20zPWL7YRk2QWS7ZDVheuKx9TJek4/5v7B/sZHnsigg74iCzNYEJ6ypoETW
	 gCPLpM5dpaxlw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/21] kho: extend scratch
In-Reply-To: <178410811939.820181.9175877917181976639.b4-review@b4> (Mike
	Rapoport's message of "Wed, 15 Jul 2026 12:35:19 +0300")
References: <20260709173821.429921-1-pratyush@kernel.org>
	<20260709173821.429921-19-pratyush@kernel.org>
	<178410811939.820181.9175877917181976639.b4-review@b4>
Date: Fri, 24 Jul 2026 18:54:03 +0200
Message-ID: <2vxzjyqkgwgk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19D4B180009
X-Stat-Signature: t1wkp3ozgitfyzkpy4s5kpd4cugocbdp
X-HE-Tag: 1784912047-702307
X-HE-Meta: U2FsdGVkX1+XaazeA5i2TvsfX7ClviQg7vuqasUeGQ4k8JCb1rQW9PxWyOrtmQp6e8MPSw044Bf3Z5bn3aRegm/oARUFndNToevZo73R03/tCnw5u/AmxIrIt6rFRVs03CN9p9x1+UtfCn8LbzKgYkgXa92Zt9ISHYbjtn9IgrxFMlWoR4hfxyR+768AE+yrVXnvN7HSXeO2WKt8fnZQ73zjQH0sqq7hdeQVR2qMBLNyHL30YNAQBHWORZA3rTSNyYUYv7JgPvW1t1+oX6xbg9uKt73mSi4YfrcYp019uw30IM1bEx7q4X9IYm+VWrT48E1wjangE5ATzbtFoV4VX8iZyywcKv/u8x5Wq1tPiOhoYeijSUC2gwysDOaxQYcrvcGy/uSE9XRsx2P92wYs8bFszKRkCMFromwcZZ/oN0g01Jgd91vXo+8XQEXWf7crDXmIO94/SbjIgnfNTotXRgDDMgnJcNy3DTy5PUtJa/mCIBrvt4+ntY9dvLMSndohBd2oxX5ouva1OGFTFQwW6SBeQVrWrms1VqOV/9TZzan0f283iqdMaxmeNVefXHUV/T5sWQohZj4EGECuumddOtdRn7dqs+V7aRfhUfVQDBaOVadKWI/7sKedpFhSp/NKp5R11Bqa8n0mEDCI+rMqXHIv7sHHCY0gi02wkXV6+vqcxi9u5GMSX/IAeUf1ReMEkyeS2AEwGw+93sakmjIYhlnydM8JKIHbJiAMP6fEQc3oGtahb2qKFjHleXCL92uGjH+d69RuLaRld/lJWa0FnBnGFPz8Cn3UYshMtQrDwfXohhbcagNXnm+bztNdXnVJmrkS206SJHBu2zZx5MCMdJkMsHhiaj9XE8Zs1ZE4O2+N6PKjfHIoHKX2Ufy6oxkO6Idg7NlziuCFj+gZWhkUllQM19u5TuGfigseqi7l9Y1Pxtr0UIc5mG5Trhn/viEmRZPdMOrblqcS0KsoQIB
 y7Ieq2/h
 /Fl8whE4niJGAsDzN7JzeI1R2shj9epL5h7Obol4HmEekSGBwzFQ4ZN84AQw2UnI0e0ih3A0OO6E4+d7c7NnjuOMc2ss0CQRQ9LVWV7Mu8zQA5N9LjRZNwe7qoyiC5GdpKT6BMGmQTaAupOKkxShQMUzxmch63+9S/evyPgJ3Ff23YUyK0xbhhVhRv+YeqrkvSpghsccKpDEeNOgC1GVgxQx2qZJX6p3YHVr2SZRklUuMDko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15 2026, Mike Rapoport wrote:

>> Motivation
>> ==========
>> 
>> The scratch space is allocated by the first kernel in the KHO chain, and
>> is reused by all subsequent kernels. The size of the space is either set
>> via the commandline by the system administrator or by calculating the
>> amount of memory used by the kernel and adding a multiplier. In either
>> case, the scratch space is a heuristic and is liable to fill up and fail
>> allocation if a kernel uses more memory than expected.
>> 
>> In addition, gigantic huge pages (usually 1 GiB) are allocated via
>> memblock, and in a KHO boot that memory comes from the scratch space. In
>> hypervisors it is common to dedicate a major part of the system's memory
>> to gigantic hugepages for VM memory.
>> 
>> If this memory needs to come from scratch space, then scratch needs to
>> be greater than the memory needed for huge pages, which is impractical.
>> In addition, hugepages can be preserved memory. Allocating them from
>> scratch violates the assumption that scratch contains no preserved
>> memory.
>> 
>> Methodology
>> ===========
>> 
>> Discover areas that don't contain any preserved memory at boot by
>> walking the preserved memory radix tree. Mark them as scratch to allow
>> allocations from them. This makes KHO more resilient to memory pressure
>> and allows supporting huge page preservation.
>> 
>> Since the preserved memory radix tree mixes both physical address and
>> order into a single key, and does not track table pages, it is difficult
>> to identify free areas from it directly. Walk the tree and digest it
>> down into another radix tree. The latter tracks blocks of
>> KHO_EXT_SHIFT (1 GiB as of now) granularity. Then walk the digested tree
>> and mark the areas between the present keys as scratch.
>> 
>> Performance
>> ===========
>> 
>> The discovery algorithm traverses the preserved memory radix tree
>> exactly once. While it does use memory for the digested radix tree,
>> since the blocks are split by 1 GiB, a single bitmap with 4k pages can
>> track up to 32 TiB of memory. So there are likely to be very few radix
>> tree pages used in this tracking. For systems with all physical memory
>> below 32 TiB, this should result in a total of 6 pages being
>> used (KHO_TREE_MAX_DEPTH == 6).
>> 
>> An alternate way of achieving this would be to call kho_mem_retrieve()
>> earlier in boot and mark all the KHO preservations as reserved. But that
>> can blow up memblock.reserved with a bunch of 4K pages scattered
>> everywhere, which will reduce performance of subsequent allocations.
>> Since the free blocks are tracked in chunks of 1 GiB, this won't blow up
>> memblock.memory as much.
>> 
>> There is no inherent reason for using 1 GiB as the discovered block
>> size. This can be changed later if needed. Currently, KHO is mainly
>> targeted for server grade systems with hundreds of gigabytes to
>> terabytes of memory. So 1 GiB is a reasonable granularity for those
>> systems. For smaller systems this doesn't work as well, but we can
>> arrive at a better heuristic when we have concrete use cases.
>> 
>> Practical evaluation
>> ====================
>> 
>> The testing is done on a x86_64 qemu VM running under KVM with 64G
>> memory and 12 CPUs. The machine pre-allocates 50 1G pages.
>> 
>> Since the performance scales with how busy the radix tree is, tests are
>> done with 2 preservation patterns: first with two 1M memfds, second with
>> two 1G memfds, both using 4k pages.
>> 
>> Test case 1 - 1M memfd
>> ~~~~~~~~~~~~~~~~~~~~~~
>> 
>> This test case has two memfds with 1M memory each in 4k pages, plus
>> other preservations from LUO core and other KHO users.
>> 
>> This is how the radix tree stats look like:
>> 
>>     radix_nodes:       0x13
>>     nr_preservations:  0x214
>>     mem_preserved:     0x227000
>> 
>>     per order preservations:
>>       order  0:  0x20f
>>       order  1:  0x4
>>       order  4:  0x1
>> 
>> and this is how long it takes to extend the scratch after KHO boot:
>> 
>>     KHO: KHO extend time: 47 us
>>     KHO: KHO extend total mem: 0xe6c17b000 (~57G)
>> 
>> Test case 2 - 1G memfd
>> ~~~~~~~~~~~~~~~~~~~~~~
>> 
>> This test case has two memfds with 1G memory each in 4k pages, plus
>> other preservations from LUO core and other KHO users.
>> 
>> This is how the radix tree stats look like:
>> 
>>     radix_nodes:       0x28
>>     nr_preservations:  0x80816
>>     mem_preserved:     0x80829000
>> 
>>     per order preservations:
>>       order  0:  0x80811
>>       order  1:  0x4
>>       order  4:  0x1
>> 
>> and this is how long it takes to extend the scratch after KHO boot:
>> 
>>     KHO: KHO extend time: 22514 us
>>     KHO: KHO extend total mem: 0xd3f200000 (~52G)
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index b400976851e76..2c48488746290 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -84,6 +84,23 @@ static struct kho_out kho_out = {
>>  	},
>>  };
>>  
>> +struct kho_in {
>> +	phys_addr_t fdt_phys;
>> +	phys_addr_t scratch_phys;
>> +	char previous_release[__NEW_UTS_LEN + 1];
>> +	u32 kexec_count;
>> +	struct kho_debugfs dbg;
>> +	struct kho_radix_tree radix_tree;
>> +};
>> +
>> +static struct kho_in kho_in = {
>> +};
>> +
>> +static const void *kho_get_fdt(void)
>> +{
>> +	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
>> +}
>> +
>>  /**
>>   * kho_encode_radix_key - Encodes a physical address and order into a radix key.
>>   * @phys: The physical address of the page.
>> @@ -895,6 +912,128 @@ static void __init kho_reserve_scratch(void)
>>  	kho_enable = false;
>>  }
>>  
>> +/*
>> + * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
>> + * with large systems with hundreds of gigabytes of memory. It will work poorly
>> + * on smaller systems. The algorithm itself doesn't depend on the actual value,
>> + * so it can be changed to a different heuristic later if needed.
>> + */
>> +#define KHO_EXT_BLKSIZE		SZ_1G
>> +#define KHO_EXT_SHIFT		const_ilog2(KHO_EXT_BLKSIZE)
>
> Nit: EXT_ what? ;-)
>
>> +
>> +/* Called for the KHO preserved memory radix tree. */
>> +static int __init kho_ext_walk_leaf(unsigned long key, void *data)
>
> I have to say this function still confuses me :)

Honestly, I think this whole tree walking API makes things really hard
to reason about. I think we should replace it with something like
kho_radix_for_each(). It would improve code readability a lot.

I plan to do it at some point, but not as a part of this series.

>
>> +{
>> +	/* Radix tree tracking free blocks. */
>> +	struct kho_radix_tree *tree = data;
>> +	phys_addr_t start, end;
>> +	unsigned int order;
>> +	int err;
>> +
>> +	start = kho_decode_radix_key(key, &order);
>
> I would add a comment here, that the key is from the memory tracker and
> it is decoded to an address.

ACK, will add.

-- 
Regards,
Pratyush Yadav

