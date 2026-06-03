Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F1DCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2A56B0088; Tue,  2 Jun 2026 22:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563D16B008A; Tue,  2 Jun 2026 22:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452326B008C; Tue,  2 Jun 2026 22:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 329366B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:21:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB719401E0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:21:32 +0000 (UTC)
X-FDA: 84837000024.11.BFC677C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id E13BF180004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:21:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PGn608hg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780453291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MJOr97mrATixEW5kehH0DvlyrDDJP/7LhB74lpVfHs=;
	b=cmNAbhhmQ5wA1oZT1DPUp8cMlhIi9M//xguiMjm1mLwyTP/YDYByE3d5w0QMo/KqibsJVl
	FwxY7jIyxnsTTQKYb+y8lvs7zdiZxNbbQ0lDftwWXSCJQYiuQpk74MZeaSyu6snDeQUxV9
	3+iMyY5IqLtFBnaOueSaFs9YPQtwUOw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PGn608hg;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780453291;
	b=nEySLdgmudS8rU6J98ajt3KkzJsUSbc4zPcQE0IZxISugKZsSoI4kqH8m5qwP1EzMNrThl
	RrV+J7qoIvruCfv/UwiyLSnqD3F28FXIKKsCTrnFiAPdwbfwC0NyiZwaejzq6CDt9HLKsT
	DY+Bf3NfhQUa+sajO7IQDGe248DZyNg=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51775f2473aso4877841cf.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780453290; x=1781058090; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9MJOr97mrATixEW5kehH0DvlyrDDJP/7LhB74lpVfHs=;
        b=PGn608hgQkHcuqA2aavUl696A+6qocE75aOkp+Jzo58r9nSwWgA3KWmVu+KXpJQuVg
         qYbA1g8YjkZZvaanFrm2wEnB3hPIhUchU4MDm4pfTiTQj0ApYd35Qo8Lq9SV2AmxzTkY
         ZvQr/vF5AHJk5j/ZR7xLtBTNMKF4rc8uLaAP1JNWxpLlpwwpILJXbp73i22Q9bkqyiCQ
         9/Al28pIjbj/ntZSmdzaOYQI78A2FHoDIUxSK4SawNYWC7fGZHPqeq73Za35kSUGX1E5
         wtwboVlvGiPskYct7txkCj0reUI3z34x0WHGQusXsv/sVtQj3d2GDp63BkW7CBqL6ti+
         mz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780453290; x=1781058090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MJOr97mrATixEW5kehH0DvlyrDDJP/7LhB74lpVfHs=;
        b=r8BTPWky0CcxiG+kAdv22L5Q38FJgGBr+lUuziR6v0ForL61lWQ/g5aHS5SQXatuuD
         sAxhCbx9xMK+qgTmO23hHXG+fdt5BxozbucICtkmmwQ4Qx6YhCJzcQPPXKtcPNu7GH4d
         ZLdFrtn1yNawzBMSRQwRcgz7lu0A8kzyKj4sUK+IAKFZ2moJFfwMOEVYnX9RqFeZCqTM
         Eey6ZXwwwl1jThUxN4UZqLAjXlTThw+0xFOmGnJv7syP0iFEXWvIW+axCuWDFqc5wkbk
         3xknMdNoPgqP632unZRVteLtIaNk+tY53m05LODTwrK2aU+ke67fFa9rmrcLVg4wxqNz
         ld0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8UbPvf0BzsgGD4XIV1YNt3HIW2Qcn+al/dQodp+kQ140k7GRGA4NAhWqn9F44H4zOceohfNzH88Q==@kvack.org
X-Gm-Message-State: AOJu0YwOYOrdP6g2Uz1l+ceglEwSqERKNXlJbAe7+oqKrvRxVAz0SxkC
	2oydbmTLtXd79tPNXeuZYYfejJiOgFvVJTRIaTE8H+I71aiGrEZNww44gwRKqe25TnA=
X-Gm-Gg: Acq92OHEBN30Eiak5lDFuqygZm59nGayYLVTlTxstw/C/ean59Gsooh8FWrOpB7Yzi3
	a28C93dl8VrhwL8g39uL3VdCAbKHU3rh6A98lR15LLTcbIj3DhLhQ8w4Z8DV6yYVLSyBptX9oyR
	TtWqHZz7PFubxR+rOOBnSSQKlUmyOuuqnWOn++ThZ3SEZu3K3kynTnt42XIkZ4Dt9N/hZwm2Nf0
	6oi1pdGFAI8CKMkliwTfKe8SWRwZ2LC1kmC8lfq38zykQvfu82AutFB+e7frZmgwHx9SzWjX/gO
	EOsenu4a0ZYN+M4p5XA0yYFMJGdg3KC6KQgNGkWsmIigLxx2IpwjTAFRlYwbHmIp/i5FGTrkGeR
	JKzrL4D7+n9aG2rnUobnpN6c28xSL7/c1PvDs5Q20GcacjnGXK3/AZkf6FOcoKsCbBbvjpcuHip
	b/u3FtO8d7H+FFoDwMTQLvgIhJGEiXreR6vXtkKZ2GeX6IJWuyLFHq+8QrBgo7kw==
X-Received: by 2002:a05:622a:306:b0:50d:9e8d:9837 with SMTP id d75a77b69052e-517785adec6mr26502311cf.11.1780453289820;
        Tue, 02 Jun 2026 19:21:29 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd06d600sm8167806d6.35.2026.06.02.19.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 19:21:29 -0700 (PDT)
Date: Wed, 3 Jun 2026 02:21:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 07/13] kho: add support for linked-block serialization
Message-ID: <ah75uAV8uPtS0XNj@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-8-pasha.tatashin@soleen.com>
 <178038801491.119771.18384706761138506132.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178038801491.119771.18384706761138506132.b4-review@b4>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3nfryzppmz3aa9bz81mrc4o6kgkeii87
X-Rspamd-Queue-Id: E13BF180004
X-HE-Tag: 1780453290-229788
X-HE-Meta: U2FsdGVkX19bzxxs5beOIZPYcqtmLMQLSHKxTe3EKj6B8qpgnh3FGQwz3w52QBSrQ61vvqmNncs3wX2hpIf1XccWhWBKg7VZJ+561W9Faf5KEVBDDG+f4vmPtwt+VglnewYyfgyTj5iRvxmUJ2AvP5xpKRLZ0L/44Im3WJrsxgYK2IaS8Cgm2vVc2c4S0s5b4apMZLOGQcEoJLFYDzk+Q6LXG9FRdzizyywsQ4r943sTIIukiIO5Wk8ZuSaECrHZFU3CA0jKsH3s03ceZDfD/I6EIZDj6JVPf1mZSWElNitRYAVhtU48pRYasPJ+IuHjfuSU1Dz8qyO7ShPO0J6x8TeXNLCXW0XXemqP8VS3T7kNjbO3zTP/iYEKFYYyMxTRJ7jJcGVeYiT6b8J8qDTU8XRep8elS7jhknyYc4ZdDsTgJEyOeQ4APYtLFDz6UNA9bFABruBd0+n4P3za03LT644KoH/UWnxTk56XzqtJsDTeu2bVVdmxNtCumhtj7ZZhazhKpGtPABIAzztul++jmDEIIEfUeLJ7bCcF7PPUxqLUS0pCK/2MZH4UdHvs9fqm/a8DXUBo8LfNbicI8Ut6vXv5WiGR1919M46M3rendnzBbqDoDiuQcvrvVSx/Tf7xiN67Abgd2ky1M8mOPvKbTAcQBtfpJb/5q1DUqyiQ0BZwoeVHwwsnxnEaDsr/NHaotdcNrJy4JC1P7Rt8zTQug6a1Kma98cUoT1a3AjzeGdl3njmSspGGF2SguSCHis77FXlmCtZ4mJyzAW4gowOInhL9DDYXpRLyuw/ZhJDW7i4RL6v1CJj/lLLuEKnjfyqA1l9VHa50+wDYNOxi4oxBZhws+9RcydUogC/6aupbtT7qX8sUtP5vMQ+NltrbuYdA/tgmZbv8sTzarf0by8hp/5Nz2E4mSs0Us1eQs+TgG3IzXYIKVcGnn6qDEb1MB0VyoakVHqN3Ig8LbvmryLn
 O1MJPb4H
 NBaoI1Svl/CEs150RJApFJYeHRk/KdK3p7BCoLVEEzLudAd8NVDypdQu/iM/tZah0sOiCzfSXP1i/4PK51MEBJSwN3XBlOjXnqOPcAM8Xy3p4qENEL51SoHNbqWEPTVdg7SQm4zd2bB1PosftcUlycjxK7Mxc1HqD+8Cz9UcNN/QL1u0vWq8ixNzDKdT6PtJCzLpGUoUOA9GdqcEEtYgYOYTDUjfPjfFo/QvC6mEXEqdu1CJj2NG2GVYyc9o3+4GJ1JxpKH78dZJTdTk+yhiEQ84aKZgozhoEyfrCWYhm6K5kslw1N9er3JYJl+Jsb21p7DQQ1+lZf1cnVb12ywj+t3FyFZyk5nj2TyUs5aU/OfoQytTJA3vdkUi6d86mshEoe1D++6zXZOYk99gHCKVY/d4BpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-02 11:13, Mike Rapoport wrote:
> On Sat, 30 May 2026 22:19:32 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
> > new file mode 100644
> > index 000000000000..5e6b87b1befa
> > --- /dev/null
> > +++ b/include/linux/kho_block.h
> > @@ -0,0 +1,79 @@
> > [ ... skip 19 lines ... ]
> > +	struct list_head list;
> > +	struct kho_block_header_ser *ser;
> > +};
> > +
> > +/**
> > + * struct kho_block_set - A set of blocks that belong to the same object.
> 
> "same object" sounds off to me. The blocks belong to the same module?
> user?
> 
> Thoughts?

user and module are not descriptive, as the same client/user/module can 
use multiple kho_block_set for different purposes. I suggest:

"struct kho_block_set - A set of blocks containing serialized entries of 
the same type."

> 
> > + * @blocks:          The list of serialization blocks (struct kho_block).
> > + * @nblocks:         The number of allocated serialization blocks.
> > + * @head_pa:         Physical address of the first block header.
> > + * @entry_size:      The size of each entry in the blocks.
> 
> I think it's "... entry in a block"

It is 'in the blocks' (or 'across the blocks') because a single  
block_set  can contain multiple blocks, and they all share this same 
uniform entry size.

> 
> > [ ... skip 42 lines ... ]
> > +
> > +void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
> > +void *kho_block_it_next(struct kho_block_it *it);
> > +void *kho_block_it_read(struct kho_block_it *it);
> > +void *kho_block_it_prev(struct kho_block_it *it);
> > +void kho_block_it_finalize(struct kho_block_it *it);
> 
> These operate on block sets, should be reflected in the names.
> Can be kho_blocks_ to avoid too long names.

We have already started using kho_block_set. Although it is longer, I 
prefer to avoid kho_blocks/kho_block because the subtle difference makes 
them difficult to read and prone to typos during coding. Let's use 
kho_block_set for operations on a block_set.

> >
> > diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> > new file mode 100644
> > index 000000000000..a4e650af946f
> > --- /dev/null
> > +++ b/kernel/liveupdate/kho_block.c
> > @@ -0,0 +1,384 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/*
> > + * Copyright (c) 2026, Google LLC.
> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > + */
> > +
> > +/**
> > + * DOC: KHO Serialization Blocks
> > + *
> > + * KHO provides a mechanism to preserve stateful data across a kexec handover
> > + * by serializing it into memory blocks. This file provides the common
> 
> "This file" does not look good in HTML docs.

Fixed.

> 
> > [ ... skip 15 lines ... ]
> > +
> > +/*
> > + * Safeguard limit for the number of serialization blocks. This is used to
> > + * prevent infinite loops and excessive memory allocation in case of memory
> > + * corruption in the preserved state.
> > + */
> 
> Can you add how much memory it is and how many entries with, say, 4 u64
> it can accommodate?

Done

> 
> > [ ... skip 13 lines ... ]
> > +{
> > +	if (unlikely(!bs->count_per_block)) {
> > +		bs->count_per_block = (KHO_BLOCK_SIZE -
> > +				       sizeof(struct kho_block_header_ser)) /
> > +				      bs->entry_size;
> > +		WARN_ON(!bs->count_per_block);
> 
> Don't you want to set count_per_block in _init()?

Done.

> 
> > [ ... skip 29 lines ... ]
> > +	if (!block)
> > +		return -ENOMEM;
> > +
> > +	block->ser = ser;
> > +	last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
> > +	list_add_tail(&block->list, &bs->blocks);
> 
> No locks?

Linked blocks are not internally synchronized; that is a responsibility 
of the caller, similar to linked lists.

> 
> > [ ... skip 12 lines ... ]
> > + * @bs:    The block set.
> > + * @count: The current number of entries.
> > + *
> > + * This function handles the dynamic expansion of a block set. It allocates
> > + * and links a new serialization block if the provided entry count matches
> > + * the current total capacity of the set.
> 
> This is a weird semantics for a generic API. I'd expect _grow() would
> add count - current_count blocks.

Changed the semantics to use target count, i.e. "The target number of 
valid entries to accommodate."

> 
> > [ ... skip 25 lines ... ]
> > +}
> > +
> > +/**
> > + * kho_block_shrink - Conditionally destroy the last block in a block set.
> > + * @bs:              The block set.
> > + * @count:           The current number of entries across all blocks.
> 
> Maybe 
>  	... of valid entries?

OK

> 
> > + *
> > + * This function checks if the last block in the set is redundant based on the
> > + * total entry count and the capacity of the preceding blocks. If the entry
> > + * count can be accommodated by the blocks that come before the last one, the
> > + * last block is destroyed and removed from the set.
> 
> This should mention that it's the caller responsibility to ensure that
> entries are removed in the right order.

OK

> 
> > [ ... skip 49 lines ... ]
> > +
> > +		fast = phys_to_virt(fast->next);
> > +		slow = phys_to_virt(slow->next);
> > +
> > +		if (slow == fast) {
> > +			pr_err("Cyclic list detected\n");
> 
> Maybe "block set is corrupted"?

OK

> 
> > +			return false;
> > +		}
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +/**
> > + * kho_block_restore - Restore a block set from a physical address.
> > + * @bs:      The block set to restore.
> > + * @head_pa: Physical address of the first block header.
> 
> I'd mention that the block set should be allocated and initialized

Done

> 
> > [ ... skip 10 lines ... ]
> > +	bs->incoming = true;
> > +	if (!head_pa)
> > +		return 0;
> > +
> > +	bs->head_pa = head_pa;
> > +	if (!kho_cyclic_blocks_check(bs)) {
> 
> if (kho_block_set_cyclic()) 
> 
> reads nicer IMO

Sure, done.

> 
> > [ ... skip 87 lines ... ]
> > +{
> > +	if (!it->block)
> > +		return NULL;
> > +
> > +	if (it->i == kho_block_count_per_block(it->bs)) {
> > +		it->block->ser->count = it->i;
> 
> Why iterator updates ser->count?

The new name  kho_block_set_it_reserve_entry()  clarifies that this is a 
write/reservation path function (unlike the original read-only  next  
name). Reserving a slot to write entries naturally implies 
writing/finalizing the metadata count in the physical block header when 
a block becomes full

> > +		if (list_is_last(&it->block->list, &it->bs->blocks))
> > +			return NULL;
> > +		it->block = list_next_entry(it->block, list);
> > +		it->i = 0;
> > +	}
> > +
> > +	return (void *)(it->block->ser + 1) + (it->i++ * it->bs->entry_size);
> 
> In a month we'll need an LLM's help to understand what it does.

Good thing in a month we will have even stronger LLMs to help us :-)

Anyways, clean-up ...

> 
> > +}
> > +
> > +/**
> > + * kho_block_it_read - Return the next entry slot for reading.
> > + * @it: The block iterator.
> 
> And what is the conceptual difference between this and _it_next()?

This was updated :-)

> 
> > [ ... skip 49 lines ... ]
> > + * @it: The block iterator.
> > + */
> > +void kho_block_it_finalize(struct kho_block_it *it)
> > +{
> > +	if (it->block)
> > +		it->block->ser->count = it->i;
> 
> So, it looks like the intention of _it_next is for write, and this ends a
> write iteration.
> 
> I think the names should be adjusted to make it clearer.

Done

> 
> -- 
> Sincerely yours,
> Mike.
> 

