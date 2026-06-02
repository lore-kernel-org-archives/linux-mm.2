Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BF0CD6E65
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7C36B03F8; Tue,  2 Jun 2026 04:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC156B0401; Tue,  2 Jun 2026 04:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A021E6B0402; Tue,  2 Jun 2026 04:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9416B03F8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:13:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35451A0857
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:56 +0000 (UTC)
X-FDA: 84834259272.12.1DAC7CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8439A14000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WfMh9fz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8677rqzPwCK7BT2bqGJkDF7s4XcZqoB/M7pK9qZ0mPI=;
	b=362bgp7TTjGB50TvJl1SyqrmwDn+NYDyneW/dp10VyqjnO66Lxa6tE2mmU2e9Oy6ThD1ou
	cDBpoA/0JJVorO0vDxzhMhKdqrQVqh4sfVoSnp3xUMs1zCsnjcyW7H8NkAEJkyDXEAIg7m
	PNcpo3O+g2KfzxdD4RiQrW9q8Hw5FSk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WfMh9fz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388034;
	b=lSurHeIiHFb71aaLISMaYUBHOp1ft5RsIWrIjzvhejcuWdppyioiDsPr2t8irm12kiU//3
	L0+x+kX2oH3VH/J2WPtRPLrURh2lqYUx3IlogJqSX5btlopkjmOPs0H7qLD9YDMOBNMoqi
	tuVV2XFkpT+MGU1SIx3qi5hZVhC9UHM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EF6343952;
	Tue,  2 Jun 2026 08:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363D11F00899;
	Tue,  2 Jun 2026 08:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388033;
	bh=8677rqzPwCK7BT2bqGJkDF7s4XcZqoB/M7pK9qZ0mPI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=WfMh9fz62CnhrepjlqZLoJaI2CY23PyiNds+OHaCi+8uuAOcT1mIy0T88mUaIDRN7
	 VEo98JrsdK7inKt4bTisyphkakz1/LUWeVEjGVxnQnzEQh30te7NE/d3u5dUKCU/Sp
	 wPGEPy5r5+gvz8EDne4kJsLtakhboDBaUh9HH1h/fzo6YBwPyIwDq8hTnkE7Abl/rW
	 rBRG2hDPLmDXN8AO9LsNJFSIriipy2mQ7gvrB5+sk5Ok3qhVEOZATuI9HYuHoPu0nm
	 BX4SXyAoytHokJpp16Qsr/aKFFNQWEC6fE2YyxvOYDXV6suIcEVxlYjw3EVHnzoZj8
	 HqwZWBRf5O/oQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 07/13] kho: add support for linked-block
 serialization
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260530221938.115978-8-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-8-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 11:13:34 +0300
Message-Id: <178038801491.119771.18384706761138506132.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: iqzej45okhmhae7sfc399ew9eoon6zdj
X-Rspamd-Queue-Id: 8439A14000A
X-HE-Tag: 1780388034-362034
X-HE-Meta: U2FsdGVkX199xJTxgkJLjvkklGiPSoNFuDYaj8FuNBi4Sv3jnFaMqYMYzYpP4pR+i+xogob2VLUxKQhXR2xHywVNmkVtZfe53r10oO51m/V1s+9f/yiTa+zeRiZioix1fKe8Rf34aJXny0+o28OfigUXJ6PLNaALfk60xxCKjtfKpl0AYqwibq1Ka+v/CR3I2irkfzrgXyNI9aZ3eh3D8coB8wlJMPMiTdN0q2hsv1f4ncZ5vtoCF+PMK9jiZfjJsckutKF1R81w3PFOH6wMhHyfQLTdjH75kUONkp00bgJWJpUjTfkX6/ROGWSaDbvtulkn2hPBbDuvmnJb30AeuhBgOk/wmx0Ar9WHEHXMgx43JfywN/DdpYFDs0cT4T5pZCXuoPJ7C09Q41ZTSKpMUxq2gpKM6nuWKt/4R3Uqw7YOkXcrCynt3EU0rhZ2wCcowFLXzN9cqKfJ604b56uKvi4dLV6/xBRPEm0xbeob2l2QQ8Qz0D607NCNXkPnDcXmkjgSGA5XceTkmUz4eryp99sduqU32A5SpxtHSH6ZgyyNBzqBLOu+hcJbHIwGOQsQ9cDMt9GMvH6FGel2qlVAvurQ8o3C1/k9zSsvef0uVzSnc92KXa19BbJHTU9k8HSaZtfFe20npAX6ZJsIJaOQJuvMI0P9OoIVOh//WrUHxuPzRQc1ajMgALg+ulUbhSw8u3H/ln3sXRJAs1eYNUMnU0dZTMzNXjnYzCFTISKvSWiNDp9TlmQnbt2mKgMtI+/zAVaqZitzjcfpucCzTTU5sbBgWSVUAXm7sw2+Pttmfcr45NWWH0ic5oBzuSm1jYx5Hf8/lqhMxzAY6Bn+yxzOhnDywcd5m2JDDmLGY8u7V39+YwA9w8XwxX4iCnwE0l6wjZzfkmPOGJ09TM8KofxR50Ry7TdKLhvHYKky+xwhY8E+0p6zgHugDDV8Cco5gZmniMcOLQtpPstLNSLRroD
 7o99VNeV
 GY7alTCkOI2Mv3+dDPGsitWtbi8AmGYx7y7yv1lo8pIADe1ULNLfz7lv+dh0VyJS0DWwcYPaTvKziq5ggmERrv5NiIjj3GIIDALR+iGzieNPn/K7nD++zy4mRuQl+I5WVcFIFDtGqIYe6hjk5qS9rDFE6s7Yfo4xojyhYzv6mZGevTfEoJLV5Z5IGwyjFAaV3x+hXMj3klYOHG15eHUGpiu53FD06blkaVhE4F5kpQllLgc6n6WPB7cH5LJbIknYVARzpgXXGLwezOQsClZNxhy/tJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 22:19:32 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
> new file mode 100644
> index 000000000000..5e6b87b1befa
> --- /dev/null
> +++ b/include/linux/kho_block.h
> @@ -0,0 +1,79 @@
> [ ... skip 19 lines ... ]
> +	struct list_head list;
> +	struct kho_block_header_ser *ser;
> +};
> +
> +/**
> + * struct kho_block_set - A set of blocks that belong to the same object.

"same object" sounds off to me. The blocks belong to the same module?
user?

Thoughts?

> + * @blocks:          The list of serialization blocks (struct kho_block).
> + * @nblocks:         The number of allocated serialization blocks.
> + * @head_pa:         Physical address of the first block header.
> + * @entry_size:      The size of each entry in the blocks.

I think it's "... entry in a block"

> [ ... skip 42 lines ... ]
> +
> +void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
> +void *kho_block_it_next(struct kho_block_it *it);
> +void *kho_block_it_read(struct kho_block_it *it);
> +void *kho_block_it_prev(struct kho_block_it *it);
> +void kho_block_it_finalize(struct kho_block_it *it);

These operate on block sets, should be reflected in the names.
Can be kho_blocks_ to avoid too long names.

>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> new file mode 100644
> index 000000000000..a4e650af946f
> --- /dev/null
> +++ b/kernel/liveupdate/kho_block.c
> @@ -0,0 +1,384 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +/**
> + * DOC: KHO Serialization Blocks
> + *
> + * KHO provides a mechanism to preserve stateful data across a kexec handover
> + * by serializing it into memory blocks. This file provides the common

"This file" does not look good in HTML docs.

> [ ... skip 15 lines ... ]
> +
> +/*
> + * Safeguard limit for the number of serialization blocks. This is used to
> + * prevent infinite loops and excessive memory allocation in case of memory
> + * corruption in the preserved state.
> + */

Can you add how much memory it is and how many entries with, say, 4 u64
it can accommodate?

> [ ... skip 13 lines ... ]
> +{
> +	if (unlikely(!bs->count_per_block)) {
> +		bs->count_per_block = (KHO_BLOCK_SIZE -
> +				       sizeof(struct kho_block_header_ser)) /
> +				      bs->entry_size;
> +		WARN_ON(!bs->count_per_block);

Don't you want to set count_per_block in _init()?

> [ ... skip 29 lines ... ]
> +	if (!block)
> +		return -ENOMEM;
> +
> +	block->ser = ser;
> +	last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
> +	list_add_tail(&block->list, &bs->blocks);

No locks?

> [ ... skip 12 lines ... ]
> + * @bs:    The block set.
> + * @count: The current number of entries.
> + *
> + * This function handles the dynamic expansion of a block set. It allocates
> + * and links a new serialization block if the provided entry count matches
> + * the current total capacity of the set.

This is a weird semantics for a generic API. I'd expect _grow() would
add count - current_count blocks.

> [ ... skip 25 lines ... ]
> +}
> +
> +/**
> + * kho_block_shrink - Conditionally destroy the last block in a block set.
> + * @bs:              The block set.
> + * @count:           The current number of entries across all blocks.

Maybe 
 	... of valid entries?

> + *
> + * This function checks if the last block in the set is redundant based on the
> + * total entry count and the capacity of the preceding blocks. If the entry
> + * count can be accommodated by the blocks that come before the last one, the
> + * last block is destroyed and removed from the set.

This should mention that it's the caller responsibility to ensure that
entries are removed in the right order.

> [ ... skip 49 lines ... ]
> +
> +		fast = phys_to_virt(fast->next);
> +		slow = phys_to_virt(slow->next);
> +
> +		if (slow == fast) {
> +			pr_err("Cyclic list detected\n");

Maybe "block set is corrupted"?

> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/**
> + * kho_block_restore - Restore a block set from a physical address.
> + * @bs:      The block set to restore.
> + * @head_pa: Physical address of the first block header.

I'd mention that the block set should be allocated and initialized

> [ ... skip 10 lines ... ]
> +	bs->incoming = true;
> +	if (!head_pa)
> +		return 0;
> +
> +	bs->head_pa = head_pa;
> +	if (!kho_cyclic_blocks_check(bs)) {

if (kho_block_set_cyclic()) 

reads nicer IMO

> [ ... skip 87 lines ... ]
> +{
> +	if (!it->block)
> +		return NULL;
> +
> +	if (it->i == kho_block_count_per_block(it->bs)) {
> +		it->block->ser->count = it->i;

Why iterator updates ser->count?

> +		if (list_is_last(&it->block->list, &it->bs->blocks))
> +			return NULL;
> +		it->block = list_next_entry(it->block, list);
> +		it->i = 0;
> +	}
> +
> +	return (void *)(it->block->ser + 1) + (it->i++ * it->bs->entry_size);

In a month we'll need an LLM's help to understand what it does.

> +}
> +
> +/**
> + * kho_block_it_read - Return the next entry slot for reading.
> + * @it: The block iterator.

And what is the conceptual difference between this and _it_next()?

> [ ... skip 49 lines ... ]
> + * @it: The block iterator.
> + */
> +void kho_block_it_finalize(struct kho_block_it *it)
> +{
> +	if (it->block)
> +		it->block->ser->count = it->i;

So, it looks like the intention of _it_next is for write, and this ends a
write iteration.

I think the names should be adjusted to make it clearer.

-- 
Sincerely yours,
Mike.


