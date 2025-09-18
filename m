Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13075CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7138E0142; Thu, 18 Sep 2025 10:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CED38E013A; Thu, 18 Sep 2025 10:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4DF8E0142; Thu, 18 Sep 2025 10:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2E28E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:16:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F39011401E8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:16:03 +0000 (UTC)
X-FDA: 83902570206.01.5FE8D24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFC3210001E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:16:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IDKOmDGdu4sjB+ajHbqv5oUDzo9Irz8OQyk6bFWkfJU=;
	b=l9wlgdtQyXUz2Tlcu8iVteJ8HyPRKjWyrJFmse+WrjqivT/BSW1n5qQHdodJCGyD+rFuSC
	V4aOxSXj7BIbs8Pj8F8ATJWVIUhHGIV60hYxXe0TmJ71Y7UafxxkwVSJzfANgwQfLsYpze
	154iozJQyB1ceMAo2rBeu3lzNqiKio0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204962; a=rsa-sha256;
	cv=none;
	b=oxgJmUnpvpyKVlG2097r3DXprTczEN+atolcLfMLF1ZtnXjdQ4nN9aXgNYkvnyxT/kMF32
	6YYbPZBGdY4w2upmI76keJIa/PXx066GJ0Y5G5LP9tbNaAwOwlR3C/JcvxvI/Kw/70GEHs
	y3aoluOLOEfMRdTFnTKAT/iWjJQdZ2k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A88C1A25;
	Thu, 18 Sep 2025 07:15:52 -0700 (PDT)
Received: from [10.57.71.56] (unknown [10.57.71.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D05013F673;
	Thu, 18 Sep 2025 07:15:54 -0700 (PDT)
Message-ID: <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
Date: Thu, 18 Sep 2025 16:15:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: Yang Shi <yang@os.amperecomputing.com>, linux-hardening@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
Content-Language: en-GB
In-Reply-To: <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wsrdnpgmy3zwx38emw1sj7ryibdakxwr
X-Rspamd-Queue-Id: BFC3210001E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758204961-251345
X-HE-Meta: U2FsdGVkX18qKw1n6UrhAUm0QuKMBoWZPbF/Y92IxWE6sCSKsjbo3HStnKSf1tWIxpNYChHao2UTKSbRDIfT3xEIyfHdh/g/ParLSNCFuvb2CNfEa1uhR8W+YIiw3Nk3oD2h4N6HVMOa7Z1zd022OnclejY7aWOb8P4YIgME4aTq+CimfxZVLmeDCRvLaJqYHnQc8YDuED6WnVxEkN52SSSf+7SLwJcZglRApvGbr1wtxa/ai9NltYxSjPrb3Bt3mFsHZ9S1U47aVvMKKG38V9e4ldgmQfkC6Zczg50lx4+Q3FfJozRI10Iayh6TLldD1qIYFrXrIHcUdaBI2QRiBEm6ywb9vwH8pGr+a0QOdwyeeNgD0VRf0oi81dCgc3LANd883PmxAIo8NoBjpn+WxN2gHbTJmL32AitOSlL0mB6kXRc2Et+9yZHIe5+KHfQbznomigVo0/c+S0QCLkPqOEPOgM0SeI/hk9yKJn5inkFKyoLbk4Dmc/2BOAJHU0uANWlkTDTiC0OMOsdc6/Jv/xoiO1EaoE/ALxCbUjyYRjTggqC1iWx4hYWCm8IKFTsEa36Vh4dHooQX8olBZrIOJ6SKPMbu/7NS5CQrFwuMS33EOdc59ugt+DLPUvR9k2En8kGCLRdNkW0ugGcrkqqq2jlT7qv0QCCydBRefcMUj0kg/tBiy2BvvNxr+JV3meTos5cFgQrs5joqRMzlYOTMlcoF+kqKtEkvuA27OIBwfNLLoiCCiUDkf7/9hRiqfyx+Q2h4UbbislCTk9w9JRNqyLc9LT/dQeMIq3Jdgg4sVhgqDMovbfyrQH/d1fW692jlY33+ohMzqb8NCC6o7CBy0fyoimwynItjwS3hdcUfvW+LSPDVWn9ri71J5lzUOYMUdGBA/eZHJozTSYFPFO7bS5YU+WIpOjF7KXfxe9I1Hn5sjVv2IfnEvM1CMzERSLDVz17NWR05hKs3jWTBPW9
 JZ7NForN
 +5Sk3dSMlBLb8SFmGqgXJ+CVO6a7DyJBM3gtpidazrgVBBMiPzbujYRRnAyGwktm68NaYIOwYNYCJ8WnyKAbomGCsheg2T5GqbzfrC1M01UfPO7xnYmYFPhMEB3ghe3thOgS72U3TX9m5Qvr1yhpL5mgqv8r3NjxdJSGbc9wKxXBLjXBEUnC/fPxxWcNWzZlj8D0+W8UryHOW6bGvdULvI+Ambm43PVLbp+jOZYGZtYW6CG19wmelXwLxQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/08/2025 09:31, Kevin Brodsky wrote:
>>> Note: the performance impact of set_memory_pkey() is likely to be
>>> relatively low on arm64 because the linear mapping uses PTE-level
>>> descriptors only. This means that set_memory_pkey() simply changes the
>>> attributes of some PTE descriptors. However, some systems may be able to
>>> use higher-level descriptors in the future [5], meaning that
>>> set_memory_pkey() may have to split mappings. Allocating page tables
>> I'm supposed the page table hardening feature will be opt-in due to
>> its overhead? If so I think you can just keep kernel linear mapping
>> using PTE, just like debug page alloc.
> Indeed, I don't expect it to be turned on by default (in defconfig). If
> the overhead proves too large when block mappings are used, it seems
> reasonable to force PTE mappings when kpkeys_hardened_pgtables is enabled.

I had a closer look at what happens when the linear map uses block
mappings, rebasing this series on top of [1]. Unfortunately, this is
worse than I thought: it does not work at all as things stand.

The main issue is that calling set_memory_pkey() in pagetable_*_ctor()
can cause the linear map to be split, which requires new PTP(s) to be
allocated, which means more nested call(s) to set_memory_pkey(). This
explodes as a non-recursive lock is taken on that path.

More fundamentally, this cannot work unless we can explicitly allocate
PTPs from either:
1. A pool of PTE-mapped pages
2. A pool of memory that is already mapped with the right pkey (at any
level)

This is where I have to apologise to Rick for not having studied his
series more thoroughly, as patch 17 [2] covers this issue very well in
the commit message.

It seems fair to say there is no ideal or simple solution, though.
Rick's patch reserves enough (PTE-mapped) memory for fully splitting the
linear map, which is relatively simple but not very pleasant. Chatting
with Ryan Roberts, we figured another approach, improving on solution 1
mentioned in [2]. It would rely on allocating all PTPs from a special
pool (without using set_memory_pkey() in pagetable_*_ctor), along those
lines:

1. 2 pages are reserved at all times (with the appropriate pkey)
2. Try to allocate a 2M block. If needed, use a reserved page as PMD to
split a PUD. If successful, set its pkey - the entire block can now be
used for PTPs. Replenish the reserve from the block if needed.
3. If no block is available, make an order-2 allocation (4 pages). If
needed, use 1-2 reserved pages to split PUD/PMD. Set the pkey of the 4
pages, take 1-2 pages to replenish the reserve if needed.

This ensures that we never run out of PTPs for splitting. We may get
into an OOM situation more easily due to the order-2 requirement, but
the risk remains low compared to requiring a 2M block. A bigger concern
is concurrency - do we need a per-CPU cache? Reserving a 2M block per
CPU could be very much overkill.

No matter which solution is used, this clearly increases the complexity
of kpkeys_hardened_pgtables. Mike Rapoport has posted a number of RFCs
[3][4] that aim at addressing this problem more generally, but no
consensus seems to have emerged and I'm not sure they would completely
solve this specific problem either.

For now, my plan is to stick to solution 3 from [2], i.e. force the
linear map to be PTE-mapped. This is easily done on arm64 as it is the
default, and is required for rodata=full, unless [1] is applied and the
system supports BBML2_NOABORT. See [1] for the potential performance
improvements we'd be missing out on (~5% ballpark). I'm not quite sure
what the picture looks like on x86 - it may well be more significant as
Rick suggested.

- Kevin

[1]
https://lore.kernel.org/all/20250829115250.2395585-1-ryan.roberts@arm.com/
[2]
https://lore.kernel.org/all/20210830235927.6443-18-rick.p.edgecombe@intel.com/
[3] https://lore.kernel.org/lkml/20210823132513.15836-1-rppt@kernel.org/
[4] https://lore.kernel.org/all/20230308094106.227365-1-rppt@kernel.org/

