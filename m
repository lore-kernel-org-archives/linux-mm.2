Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1353CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5BC6B0005; Tue,  2 Jun 2026 12:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6D26B0088; Tue,  2 Jun 2026 12:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7A96B008C; Tue,  2 Jun 2026 12:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D993A6B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:43:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C0A8140A07
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:43:49 +0000 (UTC)
X-FDA: 84835544178.28.A2ACA78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E24BD8000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:43:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE3InH4B;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780418628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW7guSvt1v56bZ3HcSG0jneWFUNT6pShqr6MCcNCKKI=;
	b=JgTc8iUB5uAR/tR+PK27wsbHBYiOhZB/mBqNQCPsEh4PCJC7H5kM9FRCl7E5+IjD0jyJ9X
	cAmU29qXXQXs5Afii7M6EdN2V07/FzSjcoKKcHOhIqzWVjMYxfZks1SINLTTCfOOMqu0H0
	V02UTrI9d33xWdnRGme8wzXQEz9kgF4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780418628;
	b=WlJXKvllUrTpajJussHYLUdBFXuSO22DmW52+ks7CtppQJoq2WVX1/qpm/4HOWuXqShe6p
	AyVBQhHC9ZcjReaYefT05oOziyf4Bv3am6v7Pzz+kS3axnNT7FUrC7LfoVoZm5pIqw+gNF
	3XGQUSJ5WCLaOPxbyEqWc93g3sNaAGE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE3InH4B;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CE796001A;
	Tue,  2 Jun 2026 16:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943DD1F00893;
	Tue,  2 Jun 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780418626;
	bh=uW7guSvt1v56bZ3HcSG0jneWFUNT6pShqr6MCcNCKKI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EE3InH4Bt9pRWzoN2GzoKpFcCodwaD3ih8vC1w6LghJZfvvzqXFx7RXPXnBeM81az
	 ZC9QYbleELuaPnB2qWI1sQMjc5SoSfrkMPTtvvLpqHKVMghCgBKmrHcitN6FhZuwkz
	 i71gdb9aM+yQZZF359hzV3teaxPSp3dJglRsojVBPlLIDxZYnqKR1q3VM716W/qf6S
	 qOOLPhfa7x5ifxlsK8CjXMk5MUadZz8hPQnNCZY4vF9KRFJ+f64GtQgHqyMXFXNIG6
	 wBeCrvtFlW6x1AVXrT3/tdMxImqCxINKtCMKYoF/qEg4RkoezDVUnXQTNZnT/2ETfC
	 LnXTzdeQ8fUxg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  linux-kselftest@vger.kernel.org,
  rppt@kernel.org,  shuah@kernel.org,  akpm@linux-foundation.org,
  linux-mm@kvack.org,  skhan@linuxfoundation.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  corbet@lwn.net,  dmatlack@google.com,  kexec@lists.infradead.org,
  skhawaja@google.com,  graf@amazon.com
Subject: Re: [PATCH v4 07/13] kho: add support for linked-block serialization
In-Reply-To: <ah2OeTDFltPWwsik@google.com> (Pasha Tatashin's message of "Mon,
	1 Jun 2026 10:37:35 -0400")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-8-pasha.tatashin@soleen.com>
	<2vxzqzmqfkit.fsf@kernel.org> <ah2OeTDFltPWwsik@google.com>
Date: Tue, 02 Jun 2026 18:43:43 +0200
Message-ID: <2vxzcxy8evuo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E24BD8000B
X-Stat-Signature: aumrap947556aixnojbz7uye6agk7aki
X-HE-Tag: 1780418627-326265
X-HE-Meta: U2FsdGVkX1+0d9RpmG2eYWJJm9iZCQxwN5GG3120HNyQodxPnv7bymhffxM/dqZnSfQKHwbErXv62Pi4MVTnvTghFT2V+avUvSMGE0ejRPXrVANJ7MjxIQ/MGmTylfdWvGhs5rl5VRf829YaXqEgcTygZQ2DwaC+RaafAB6RSVKcajWyjhTP9Q/Iq1DqYvL/AzQpGHbV12I4VEHJvI0Cu5MoPHfg0rg11FQqFJ2Ysw7NtOUBzyXkx2chLsFb8UJaetQX0UaH4UelA9IT9rqvB9Ak41y3K5YepnbF8ldTlOAXwffDPX5H6wptZlwLyeJtJpu5Uixp6asgQndbye2WB2XDUR+HZWF5KWnJNCpbP24TgRNOgVRkzH0K8T1op1C/MHT/ucP/z/oLFpgPGbCiI5dvAUV+kbIBcuaMmxX3a0PsM28B1uuuHKYgEa0WGo9y7B9dSfkQhYlljrBjzWHYUJc/Ta2q7cEFlDjCGHQuAmbmUaJ2M+YCZxaTJ/SfPBHr+08m+IpjgnRIif6n4PhRaTS9NOfWEHpDBLAJ54SvR/Clq5PJH/hPlvujx8kyRSDGndysn6Yk1KNreT91YHm3guOuRT35P8TdnjBC2vZIxqZ2yba4lkjSs3kv6baNzkIEgOwIxt4cDull+wFQ4QHExPUyJNLMzkR5E9u9Mb/wMzvJyzaOG4vUmCQzRxiIoB6KOJM8KoBTdZlCiyGTz6s0StrH/geI5idF34No3ytGg1MeadtODuhYa4BngYeFQ4KMi8vE+bWTVB9G7c5jrsmXh4jN4IulgG/Wxrxbcp/MgcsHIBnFATPnozSKQ1gdcOZVHhRTakPVX12JwhO+TPWMlwoTkqEMnxlAG4+Cguajy0cqGW9sv8V2ctz+gqoary4VZyJmGueYwshyWqux11COPpMCATGP0xFoJO1+g+N3hvHA3CKrVyTUrh7U549vPxVUU65qnJaZ2z5FIhKrB+e
 l/TD7Xf8
 K/RvGen0QQdB4yl/FQvYzGkxEMFxtZ8MbV58+Zbd+skzX7C2oetcDB5pbS7yb3TPaqC6eBz1fT0sYyi+Ltx9puffODeyzuGe9DTPNHj4tW2E1+pNZtBTcmbsgEyUqEc9UmjmSGZ13NOS7/90Vceb1yehuiCFbfgGE4Fl6ZWkdD2F8s2spRZiLAzy+NMBKmjzBT+L+oWydVP4/yXedQWdfY7NRPP+3PFGkvuF3ahYn40n2T1ebbp2WqbDYXxKxFTL64f7XSyADAjzdW8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01 2026, Pasha Tatashin wrote:

> On 06-01 15:38, Pratyush Yadav wrote:
>> On Sat, May 30 2026, Pasha Tatashin wrote:
>> 
>> > Introduce a linked-block serialization mechanism for state handover.
>> >
>> > Previously, LUO used contiguous memory blocks for serializing sessions
>> > and files, which imposed limits on the total number of items that could
>> > be preserved across a live update.
>> >
>> > This commit adds the infrastructure for a more flexible, block-based
>> > approach where serialized data is stored in a chain of linked blocks.
>> > This is a generic KHO serialization block infrastructure that can be
>> > used by multiple subsystems.
>> >
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
>> > +/**
>> > + * DOC: KHO Serialization Blocks ABI
>> > + *
>> > + * Subsystems using the KHO Serialization Blocks framework rely on the stable
>> > + * Application Binary Interface defined below to pass serialized state from a
>> > + * pre-update kernel to a post-update kernel.
>> > + *
>> > + * This interface is a contract. Any modification to the structure fields,
>> > + * compatible strings, or the layout of the `__packed` serialization
>> > + * structures defined here constitutes a breaking change. Such changes require
>> > + * incrementing the version number in the `KHO_BLOCK_ABI_COMPATIBLE` string to
>> > + * prevent a new kernel from misinterpreting data from an old kernel.
>> > + *
>> > + * Changes are allowed provided the compatibility version is incremented;
>> > + * however, backward/forward compatibility is only guaranteed for kernels
>> > + * supporting the same ABI version.
>> > + */
>> > +
>> > +#ifndef _LINUX_KHO_ABI_BLOCK_H
>> > +#define _LINUX_KHO_ABI_BLOCK_H
>> > +
>> > +#include <asm/page.h>
>> > +#include <linux/types.h>
>> > +
>> > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
>> 
>> During KHO radix development, I argued for a separate compatible for the
>> radix tree, but at that time, we tied the radix tree to core KHO ABI.
>> The argument being that all core KHO data structures belong to the KHO
>> ABI set. I imagine this will be used by kho_vmalloc, so it will also be
>> end up being used by a core KHO API.
>> 
>> So, do we want separate ABI? I don't much have a preference myself, but
>> I do think the compatible management will be a bit easier if this relied
>> on KHO compatible, especially once kho_vmalloc starts using it.
>
> I prefer to make them fine-grained, now that we are adding more and more 
> features: kho vmalloc, kho radix, and kho block should all have their 
> own compatibility strings. Furthermore, any components that depend on 
> them should include these compatibility strings in their own 
> compatibility strings, in the same manner I have done in this series.

Sure, sounds good.

>
>> 
>> > +
>> > +/**
>> > + * KHO_BLOCK_SIZE - The size of each serialization block.
>> > + *
>> > + * This is defined as PAGE_SIZE. PAGE_SIZE is ABI compliant because live
>> > + * update between kernels with different page sizes is not supported by KHO.
>> > + */
>> > +#define KHO_BLOCK_SIZE			PAGE_SIZE
>> > +
>> > +/**
>> > + * struct kho_block_header_ser - Header for the serialized data block.
>> > + * @next:  Physical address of the next struct kho_block_header_ser.
>> > + * @count: The number of entries that immediately follow this header in the
>> > + *         memory block.
>> > + *
>> > + * This structure is located at the beginning of a block of physical memory
>> > + * preserved across a kexec. It provides the necessary metadata to interpret
>> > + * the array of entries that follow.
>> > + */
>> > +struct kho_block_header_ser {
>> > +	u64 next;
>> > +	u64 count;
>> > +} __packed;
>> > +
>> > +#endif /* _LINUX_KHO_ABI_BLOCK_H */
>> > diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
>> > new file mode 100644
>> > index 000000000000..5e6b87b1befa
>> > --- /dev/null
>> > +++ b/include/linux/kho_block.h
>> > @@ -0,0 +1,79 @@
>> > +/* SPDX-License-Identifier: GPL-2.0 */
>> > +/*
>> > + * Copyright (c) 2026, Google LLC.
>> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
>> > + */
>> > +
>> > +#ifndef _LINUX_KHO_BLOCK_H
>> > +#define _LINUX_KHO_BLOCK_H
>> > +
>> > +#include <linux/list.h>
>> > +#include <linux/types.h>
>> > +#include <linux/kho/abi/block.h>
>> > +
>> > +/**
>> > + * struct kho_block - Internal representation of a serialization block.
>> > + * @list: List head for linking blocks in memory.
>> > + * @ser:  Pointer to the serialized header in preserved memory.
>> > + */
>> > +struct kho_block {
>> > +	struct list_head list;
>> > +	struct kho_block_header_ser *ser;
>> > +};
>> > +
>> > +/**
>> > + * struct kho_block_set - A set of blocks that belong to the same object.
>> > + * @blocks:          The list of serialization blocks (struct kho_block).
>> > + * @nblocks:         The number of allocated serialization blocks.
>> > + * @head_pa:         Physical address of the first block header.
>> > + * @entry_size:      The size of each entry in the blocks.
>> > + * @count_per_block: The maximum number of entries each block can hold.
>> > + * @incoming:        True if this block set was restored from the previous kernel.
>> > + */
>> > +struct kho_block_set {
>> > +	struct list_head blocks;
>> > +	long nblocks;
>> > +	u64 head_pa;
>> > +	size_t entry_size;
>> 
>> I think we should add the entry_size to kho_block_header_ser? I think it
>> is a part of the ABI of the block set. If this changes, we cannot parse
>> a block set with a different size. If a subsystem wants to change entry
>> size, they create a new block set with different entry size, and then
>> they bump their compatible version.
>
> I have considered that, and we can certainly do it; however, I do not 
> see how it would affect the current implementation. If luo_file or 
> luo_session change entry_size, they must change the LUO compatibility 
> version, which would prevent LU from one kernel to the next. However, 
> for flexibility and future extensibility, I believe it would be useful 
> to add entry_size and block_size (which is PAGE_SIZE, but could be 
> larger for some users) to the header. This is more of a feature request 
> than an issue with the current series.

My suggestion was mainly for sanity checking. So if LUO or another user
inadvertently changes entry size, it gets caught. But thinking about it
more, there are a million other ways to break compatibility while
keeping the entry size same so perhaps it doesn't matter as much...

>
>> 
>> > +	u64 count_per_block;
>> > +	bool incoming;
>> > +};
>> > +
>> > +/**
>> > + * struct kho_block_it - Iterator for serializing entries into blocks.
>> > + * @bs:         The block set being iterated.
>> > + * @block:      The current block.
>> > + * @i:          The current entry index within @block.
>> > + */
>> > +struct kho_block_it {
>> > +	struct kho_block_set *bs;
>> > +	struct kho_block *block;
>> > +	u64 i;
>> > +};
>> > +
>> > +/**
>> > + * KHO_BLOCK_SET_INIT - Initialize a static kho_block_set.
>> > + * @_name:       Name of the kho_block_set variable.
>> > + * @_entry_size: The size of each entry in the block set.
>> > + */
>> > +#define KHO_BLOCK_SET_INIT(_name, _entry_size) {                        \
>> > +	.blocks = LIST_HEAD_INIT((_name).blocks),                       \
>> > +	.entry_size = _entry_size,                                      \
>> > +}
>> > +
>> > +void kho_block_set_init(struct kho_block_set *bs, size_t entry_size);
>> > +
>> > +int kho_block_grow(struct kho_block_set *bs, u64 count);
>> > +void kho_block_shrink(struct kho_block_set *bs, u64 count);
>> 
>> These block management functions seem like internal details of the block
>
> This is not so. The confusion here is that they must be allocated and 
> preserved at runtime as resources are registered/unregistered, while 
> these blocks are only used serialization phase, 
>
> These calls are more like notifiers that more files/sessions are created 
> removed, so we can adjust block count accordingly if necessary (allocate 
> preserver memory), and have them available durign 
> serialization/deserialization

Yeah, I got that when reading the later patches that use these.

Perhaps kho_block_prealloc() and kho_block_unalloc() is more clear,
although it does not sound as nice. If not, then I suppose at least add
a comment explaining the intended usage.

>
>> set API. Do we need to export them? I think users should not have to
>> worry about block management. They should read, set, or clear entries
>> using the iterators, and internally the block management should take of
>> allocation or freeing. So here for example, I th
>
> something is missing :-)

I don't remember what I meant to say anymore :-/

[...]
>> > +/**
>> > + * kho_block_set_init - Initialize a block set.
>> > + * @bs:         The block set to initialize.
>> > + * @entry_size: The size of each entry in the blocks.
>> > + */
>> > +void kho_block_set_init(struct kho_block_set *bs, size_t entry_size)
>> > +{
>> > +	*bs = (struct kho_block_set)KHO_BLOCK_SET_INIT(*bs, entry_size);
>> > +}
>> > +
>> > +static inline u64 kho_block_count_per_block(struct kho_block_set *bs)
>> > +{
>> > +	if (unlikely(!bs->count_per_block)) {
>> > +		bs->count_per_block = (KHO_BLOCK_SIZE -
>> > +				       sizeof(struct kho_block_header_ser)) /
>> > +				      bs->entry_size;
>> > +		WARN_ON(!bs->count_per_block);
>> > +	}
>> > +	return bs->count_per_block;
>> > +}
>> 
>> This looks odd. I don't see a reason to calculate this lazily. Why not
>> just do it when initializing the block set, in kho_block_set_init() or
>> kho_block_restore()? And then use bs->count_per_block directly.
>
> This allows for blocks to use static initilziation, I like static inits 
> :-)

You can do this:

#define KHO_BLOCK_SET_INIT(_name, _entry_size) {                        \
	.blocks = LIST_HEAD_INIT((_name).blocks),                       \
	.entry_size = _entry_size,                                      \
	.count_per_block = (KHO_BLOCK_SIZE - sizeof(struct kho_block_header_ser)) / (_entry_size), \
}

Compiles for me.

[...]
>> > +void kho_block_destroy(struct kho_block_set *bs)
>> > +{
>> > +	u64 head_pa = bs->head_pa;
>> > +	struct kho_block *block;
>> > +
>> > +	while (!list_empty(&bs->blocks)) {
>> > +		block = list_first_entry(&bs->blocks, struct kho_block, list);
>> > +		list_del(&block->list);
>> > +		kfree(block);
>> > +	}
>> 
>> Nit:
>> 
>> 	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
>> 		list_del(&block->list);
>> 		kfree(block);
>> 	}
>> 
>> is a bit more idiomatic (and IMO easier to read).
>
> Sure
>
>> 
>> > +	bs->nblocks = 0;
>> > +	bs->head_pa = 0;
>> > +
>> > +	while (head_pa) {
>> > +		struct kho_block_header_ser *ser = phys_to_virt(head_pa);
>> > +
>> > +		head_pa = ser->next;
>> > +		kho_block_free_ser(bs, ser);
>> 
>> Nit: also, can't you put this also in the previous loop? Something like:
>> 
>> 	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
>> 		list_del(&block->list);
>> 		kho_block_free_ser(block->ser);
>> 		kfree(block);
>> 	}
>
> We actually can't merge these into a single loop because of partial 
> restoration failures handling in kho_block_restore().
>
> If kho_block_restore fails halfway through restoring a chain of blocks 
> (for example, if kho_block_add fails on block 3 of 5), we jump to the 
> err_destroy cleanup path which calls kho_block_destroy().
>
> At this point:
> - bs->blocks only contains the tracked blocks we successfully added 
>   (blocks 1 and 2).
> - bs->head_pa still points to the physical head of the entire 5-block 
>   incoming chain.
>
> But, this is a good place to add a comment.

IMO it would be cleaner for kho_block_destroy() to destroy the currently
initialized block set, and then the error handling path in restore path
can clean up the rest.

>
>> > +	}
>> > +}
[...]
>> > +/**
>> > + * kho_block_it_prev - Return the previous entry slot in the block set.
>> > + * @it: The block iterator.
>> > + *
>> > + * If the current index is at the start of a block, it automatically moves to
>> > + * the end of the previous block.
>> > + *
>> > + * Return: A pointer to the previous entry slot, or NULL if at the very
>> > + * beginning of the block set.
>> > + */
>> > +void *kho_block_it_prev(struct kho_block_it *it)
>> > +{
>> > +	if (!it->block)
>> > +		return NULL;
>> > +
>> > +	if (it->i == 0) {
>> > +		if (list_is_first(&it->block->list, &it->bs->blocks))
>> > +			return NULL;
>> > +		it->block = list_prev_entry(it->block, list);
>> > +		it->i = kho_block_count_per_block(it->bs);
>> > +	}
>> > +
>> > +	return (void *)(it->block->ser + 1) + (--it->i * it->bs->entry_size);
>> > +}
>> > +
>> > +/**
>> > + * kho_block_it_finalize - Finalize the current block by setting its entry count.
>> > + * @it: The block iterator.
>> > + */
>> > +void kho_block_it_finalize(struct kho_block_it *it)
>> > +{
>> > +	if (it->block)
>> > +		it->block->ser->count = it->i;
>> > +}
>> 
>> Doesn't kho_block_it_next() already do this when you add an entry? So
>> this seems redundant.
>
> It is not redundant because of how the final partially-fille block is handled.
>
> kho_block_it_next() only writes the count into the block header when a block is completely full and it is advancing to the next one:
>
> if (it->i == kho_block_count_per_block(it->bs)) {
>     it->block->ser->count = it->i;
>     ...
>
> But for the very last block in the set, it is usually only partially
> filled (e.g., we write 10 entries into a block with a capacity of 64).
> Since it->i never reaches the maximum capacity, kho_block_it_next()
> never commits its count.
>
> Pasha

I think we can make kho_block_it_next() always write it. I think it
makes sense from an API point of view, since I see this API as "adding
an entry to the block set", so updating its internal counters makes
sense.

Requiring the finalize will be error prone, since it is easy to forget.
Then you silently lose some entries on the next boot.

-- 
Regards,
Pratyush Yadav

