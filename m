Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175A7C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3C06B0095; Wed, 23 Sep 2026 04:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164E06B0096; Wed, 23 Sep 2026 04:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A8D6B0098; Wed, 23 Sep 2026 04:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C4E6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:31:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 718C2C06E9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:31:21 +0000 (UTC)
X-FDA: 85244357562.12.8305E39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D35B840002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:31:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTkYlM77;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxmbCQ7HTgeDaajizNY6/YBNTKC18nSpZXzsHrNVM84=;
	b=Tpp0I+09QDZLu7Cf7eO4EQbgsQvR8xw3Z6RQhpY72HP33Epe4W7aXGYJjy+hp6V3VlI752
	QE76Qb7atY1wqE8JQMaMtLKgZZVRypdcoaHfZN5d1bEe65q0ZUz/+4PRBuWmhBiXr01XvH
	xX9nMzPYxEb+zvi0dm484i9s/lIL80M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTkYlM77;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152279;
	b=sh1wvaQI0dqz1xoe2AG0l8JwGmFTscmeavaOD5KOnirp0laQu7kw8mqEbMvJrHe5RZvNDe
	+Pn9IgWOAA6PwfqEKhYdAZ0FwHkf9+y2pph++oNtGUp4WBkD9vsMwQfZGSsQsUFMKw4CMV
	C83jn0XschqGxZCBePpqHWQYog6cpMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F181B600AA;
	Wed, 23 Sep 2026 08:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62941F000FF;
	Wed, 23 Sep 2026 08:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152278;
	bh=XxmbCQ7HTgeDaajizNY6/YBNTKC18nSpZXzsHrNVM84=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OTkYlM77Ug42qVxwfxT90vI8uqJaGZuINeDuY7JZQ7999GuMgboyvG3xtQK4xUOl6
	 zd/wjFpIioagBtMBTbIRO4+LWzQDIAK3I7vBM0rpdAp3+D48idK6/rLGv/wp810wau
	 kBIp+Yuzbff5wJbTofP8TTmKYmwVjL0T+CpHEPlOh1dCtBCBbY6Li6SfZcSRBy1ZqV
	 6HKD6TB9iq8dr86QgVxPCe/DU6JyTmmONL36429SSJxW5oOsL1SHztUpZ/FQDboYkM
	 lciZ4ZYh3Nxzy1apRUyFKvXJd6RsZiuZRR7Ov/HZwLWG+HsGzKjqSxB30w84hYznIo
	 wOWxilA16da9A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
In-Reply-To: <yq5aik3w344o.fsf@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
Date: Wed, 23 Sep 2026 14:01:08 +0530
Message-ID: <yq5afqz02wtv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bb1ab6i63kurk84fziowxx4dmk4kk951
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D35B840002
X-HE-Tag: 1790152279-692476
X-HE-Meta: U2FsdGVkX18qfvX7kX/ZKt+Jy7Uz0S5pRFcZDygNJnn9XVmi6cJ6CfDzDkW3XyE5CQySHtieQwm1PAhH2Zc/Z+698K1yKHLzYBSEVZOWKepqUCBU6983F0rcQY0m4v6USt6dSdT90oKu0WUTPwoJ39fRegzFtGps2fg4k7fFqCuI9DhhmVbl/ozZZQbHoYKH0JYY4mK7NzEqTMkUQ+l4rToE9+Gq7dy/g+GRKvPAd9TYkeo0ceHNSU/2e6UMBr1UOphSZBRVs+t26Gwn+HAqqSTFRguTcovBLKE3qQjzhn3p6NHju2LTPeHlke0qfWgwOOWGKOhzsobToWD7mdRGqST1RfTsAKysvt5PhvgnW0wW7PchQ49S6b/I0zzm6JrmVlbG9rE/F9e5wQXvc8ise45XZK2j0PjQc8ah64hYZOfqe2JhQKctbDuaT8z34Z1MwxcRBDVdBP1bxwFJJO3dcInJaeAzvM6Wo3nmj6Y1+095npJpuI68War+WPdA2Z632VE6AOeioMa9h1r7PBvSVuco9sILdfZpgYXfQ5fSiFuL/aZ+xq3KyTLFprLU++t1wskXh2gK4vLmbJxP1jsRNHK62/CmkBSRMKYfdxK7LLkOJAXcrJoH4qDYO8hApnSNOfhULTgSCpE7jlG7KdbjlhY5PKdejOldC96iZncReYmd3SE46auuoaECYQXFmI2mt1wr53XAHvmyk+AOJgfoX32MOxxlca4ViTdMeKg0B6VxBwl19Vqb2laruLAHaBVd1+D3yCvuArHUHMd1H8hbgEdeQT6FM/lGeMQitzhMZ0gvv/QNuqPxTNfSplHWHvie7qMmYMFOcwK2AJ82m5PRf0qOBJGYozJYU/jGl9SdtwGXVMcPLF25NqD2KnSmcD4YCEu+W2fGGSnyZziuITdRKcDF75U4xLaVAa7bo/bZ6RrlSP2y1sCjL4/ue5wogrWx6Ae96sxl5YMvHte6SsK
 tZHFlnul
 /hCW0btHKfXNepVK9Gj67UzPnTvQPIaqmPz64l7k9iyOyL0a+jJsx1gLIPl+FtO8FJLzhn8yiEOBUOyDrdOLx2pMnKS6bnBsHFzBuHi4zFfbXfjtvlLci78OtqkGf62mikVbF5ZSxxzbSd5PNCP4HZmSZSfkigIfrWsSLTRXtS0CND7j5dpbfLgQpxtsTnqBAahCJBwWPDcrvdMzyW57fdyuWZ5AfnRvom3zvVjmD8kCcnzlOac/H7SJGxv+hcO0aBl+UXwIfOAhjDWcN7YEF0ImIQ5gCvu1pN5/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> Catalin Marinas <catalin.marinas@arm.com> writes:
>
>> On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>>> +		size_t requested, struct cc_shared_pages *mem)
>>> +{
>>> +	struct cc_shared_layout layout;
>>> +	struct page *page;
>>> +	unsigned int order;
>>> +	bool zero = gfp & __GFP_ZERO;
>>> +	int ret;
>>> +
>>> +	if (!mem)
>>> +		return -EINVAL;
>>> +
>>> +	ret = cc_shared_calc_layout(requested, &layout);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	order = get_order(layout.shared_size);
>>> +	if (order > MAX_PAGE_ORDER)
>>> +		return -EINVAL;
>>> +
>>> +	/*
>>> +	 * State transitions require a linear-map address and may modify memory.
>>> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>>> +	 */
>>> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
>>> +	if (nid == NUMA_NO_NODE)
>>> +		page = alloc_pages(gfp, order);
>>> +	else
>>> +		page = alloc_pages_node(nid, gfp, order);
>>> +	if (!page)
>>> +		return -ENOMEM;
>>> +
>>> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>>> +	if (ret) {
>>> +		if (!cc_make_private(page_address(page), layout.shared_size))
>>> +			__free_pages(page, order);
>>> +		else
>>> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>>> +					    layout.shared_size);
>>> +		return ret;
>>> +	}
>>> +
>>> +	if (zero)
>>> +		memset(page_address(page), 0, layout.shared_size);
>>
>> Does the memset() post sharing logic work for pKVM as well? If nothing
>> clears it, we have a small window where guest data is leaked to the
>> host.
>>
>> Is there a case where we *do not* need the memory cleared? If not, maybe
>> we can move the logic in the arch set_memory_decrypted().
>>
>
> I don't think every architecture or platform can unconditionally zero
> memory in set_memory_decrypted(). Some callers may need to share valid
> contents with the host.
>
> Also, if zeroing is added only to the CCA implementation, the allocator
> must retain __GFP_ZERO for platforms such as pKVM. This would cause the
> memory to be zeroed twice on CCA.
>
> How about extending cc_make_shared() with a flag indicating that the
> memory must be zeroed, and passing that requirement down to the
> architecture-specific implementation? The implementation could then zero
> the memory at the appropriate point: before sharing for pKVM and after
> the destructive transition for CCA.
>
> The allocator could derive this flag from __GFP_ZERO, remove __GFP_ZERO
> before calling alloc_pages(), and let the sharing operation perform the
> requested zeroing with the correct ordering.
>

I was pointed to this email thread:

https://lore.kernel.org/all/c25502d3-35c6-4281-a9ec-856f789fb1b4@arm.com

This makes a stronger case for having a CoCo shared memory allocator
that captures all these restrictions. It also means that
alloc_cc_shared_pages_node() needs:

	if (WARN_ON_ONCE(!gfpflags_allow_blocking(gfp)))
		return -EINVAL;

	might_sleep();

I guess this also requires the VPE L1 tables to be preallocated from a sleepable context.

-aneesh



