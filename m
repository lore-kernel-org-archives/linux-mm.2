Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A80C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BF06B0092; Wed, 23 Sep 2026 05:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C656B0093; Wed, 23 Sep 2026 05:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7B86B0095; Wed, 23 Sep 2026 05:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33E106B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:42:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF4CA140731
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:42:48 +0000 (UTC)
X-FDA: 85244537616.08.D51C7CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE11E140008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:42:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EqrxHpMU;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790156567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQU5pR+SfoNYpqsu1yMb6Y4AvkPOKGuTiJW7N1CVBjQ=;
	b=wkYrGtWzEc3kxFJUDtSyxdsUF2w8Yn1szyT43m4hA0uy2sEbkvRilWDH09YxzfFvuZt9O2
	5oqFIt8IGzlzZeaH0iRP9GE+J4277ca34doKXnyAXCywZbtm+vcXVR0xf8yHCcVOr/E2z3
	psbKy1F8q1hXtWKnLXrBMRGB+s3sYo4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790156567;
	b=xWwAZ7bzGVXgsVPFUzKQnRSvvacf6L5n0xHCKM1MeXVYwE15006O0fVIrywLipkw7fGRtn
	qbfO+CaPkEZgLDmKGtLTFhTLbAu6lT73QPJ2aM3VAIUshxwSrmiKZOnpf07xsIkcIpcsnu
	byU3pJiUhcge31fYA2cyEEACBWvhXYE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EqrxHpMU;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17E0A1516;
	Wed, 23 Sep 2026 02:42:42 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 890353F86F;
	Wed, 23 Sep 2026 02:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790156565; bh=ovmViFUKy6MLk0NrlYXc5n5zxje+qUS5YdjUVeCmo3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EqrxHpMU3y3q09p7ZwC3F7pnYhUAukhhWF6HkPPmq/150OiZcTwdjrlGOeBN8pNBQ
	 ViYlHj7XxBiCoU3LYoeEyZ1FOUfVcJxbQ/TAUCtCU/Xb1Gv0B6KDlzCogBgLoCrn9N
	 2KeYP3En8k33E1CffATf2xeYK+Rk4KTPNkAHQoT0=
Date: Wed, 23 Sep 2026 10:42:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arOfD6syXOgQhZYA@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aik3w344o.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE11E140008
X-Stat-Signature: 191cfdfx38z9d99xk6rd3rb6rt95yx5n
X-Rspam-User: 
X-HE-Tag: 1790156566-591361
X-HE-Meta: U2FsdGVkX1+g7l5ADqNhEPdMEGXGd2MqMfvoalV+ZMf8FtE4TuWwJTS97HCw/KeQmtDoCTCVX0cCPk9G/uPI4WTgc1q9djO0o/7xA6+4KX/rkzSST1P40ovaoZd/LWZXQ8g2NI5TXQDXg/WLlysT0A4yEkKyTsYhcSlpuyzP0lZDGtf1X+vEwO9gdVlr+K+D0SoT5atOkRQKrquJqyMw/X1SNV/NZQw1v4q0pvMic8lZ2cZVzInPAcWcBZE7sadulApc2Hc8nxEiEHmjFzRl787t2RuPkea1eLPuJSt1p1FXAfGm9TrH7ssvI5YbL3QhDqz6xwWDND/hjgZgUIaVuopmamfvSsP7Z7MeNvffiHyfY031qL+dVCYglWM+5b0p6DAkRPyCdQU2+XSh69E0pkTqtf/6TkUXKgfb38+9Q5x70GFPwJ1liNC64nc1tIIkB4DbRlkbtmNwB5yyT4SzSH6FG3ctDM6dV3bAGRNV4iZIxWR+uWNgK7kGDyqACJaOXGiHlRAqEDKaQBfsG4O3ctpQzBmMXz9SPrKUzRMMk3ic3FGWvDXpKIuAxRfdrUaUM4/I4eLxULTE3lPW4jbO5FEo2Kjp+ewdlCxitz6c4MDaIz/DX3oq41agQx0FozW9xuH1Fr1ZH9mOPOjjyuNrGRhRcZZ3L4PQT7khO5tjb7LveyEty48pPwHX/prOSolijMjS/XMr97/M8giQCdvFPmHqffWABwiSD4ZqfLPh9HS8x87qerQ5c3JB7wWevLnHJBp0bwaDdrTHjdTtbu0AQwwvnToRLLT+wqVmvoQApDOgd7H0Hwow/hHIx2MAGV+gigBNfaoubftUDB3EHTlpocuYzJJk4duCdW1+MZLQTua8GFmfwPzGl8XJmAqHscuKjy+z08o8IbweNYNaEn5aFLoE5qV09RMw0mD9o2PLg8NU7mFgEbPvvvF1mt2d4JcZMsEu9B4flZLtJ5WGZts
 ghX09I1j
 d/X2IPwEAr1lgl3aWxX68aNiXKX9UZ9kmFxJG9JggKtBPWr9P5Xgmb3gSESS1hGnccIptAO26vRkE4Tj5bzOYoIJOfV5KGegwlkKJSKCQkcKXCwV76UwD6pmURFrtC/NS2fijzi58yDkOZj2FD46hmBgxEOgz8VKtbMUz342qODngchBtKT9yj6kZ2qTPzhDZzBhli/nA3rAWqFpTseSCIkmpkDpJAcDOlu1IVWqA3Pw9RIGjEMjyaVMwcmjEFhJs6nXi7wQEcVH9GStF+H/1Ur07AIAnM9WkDvz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:23:27AM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> >> +		size_t requested, struct cc_shared_pages *mem)
> >> +{
> >> +	struct cc_shared_layout layout;
> >> +	struct page *page;
> >> +	unsigned int order;
> >> +	bool zero = gfp & __GFP_ZERO;
> >> +	int ret;
> >> +
> >> +	if (!mem)
> >> +		return -EINVAL;
> >> +
> >> +	ret = cc_shared_calc_layout(requested, &layout);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	order = get_order(layout.shared_size);
> >> +	if (order > MAX_PAGE_ORDER)
> >> +		return -EINVAL;
> >> +
> >> +	/*
> >> +	 * State transitions require a linear-map address and may modify memory.
> >> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> >> +	 */
> >> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> >> +	if (nid == NUMA_NO_NODE)
> >> +		page = alloc_pages(gfp, order);
> >> +	else
> >> +		page = alloc_pages_node(nid, gfp, order);
> >> +	if (!page)
> >> +		return -ENOMEM;
> >> +
> >> +	ret = cc_make_shared(page_address(page), layout.shared_size);
> >> +	if (ret) {
> >> +		if (!cc_make_private(page_address(page), layout.shared_size))
> >> +			__free_pages(page, order);
> >> +		else
> >> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> >> +					    layout.shared_size);
> >> +		return ret;
> >> +	}
> >> +
> >> +	if (zero)
> >> +		memset(page_address(page), 0, layout.shared_size);
> >
> > Does the memset() post sharing logic work for pKVM as well? If nothing
> > clears it, we have a small window where guest data is leaked to the
> > host.
> >
> > Is there a case where we *do not* need the memory cleared? If not, maybe
> > we can move the logic in the arch set_memory_decrypted().
> >
> 
> I don't think every architecture or platform can unconditionally zero
> memory in set_memory_decrypted(). Some callers may need to share valid
> contents with the host.

Is there any? That would be a bad assumptions in the caller. Most
set_memory_* backends don't preserve the content as they change the
encryption key. So properly written code shouldn't rely on this unless
it knows specifically it's only running on pKVM for example. The only
use-case I see to avoid explicit zeroing is when the caller doesn't care
about the page initialisation and wants to save some cycles. The
encryption key change would take care of the security aspect.

> Also, if zeroing is added only to the CCA implementation, the allocator
> must retain __GFP_ZERO for platforms such as pKVM. This would cause the
> memory to be zeroed twice on CCA.

What I meant is that we change the set_memory_decrypted() contract to
always zero, assuming that all callers need to zero the pages anyway. If
we do have cases where zeroing is not needed, we could make it explicit
via a flag.

> How about extending cc_make_shared() with a flag indicating that the
> memory must be zeroed, and passing that requirement down to the
> architecture-specific implementation? The implementation could then zero
> the memory at the appropriate point: before sharing for pKVM and after
> the destructive transition for CCA.

On pKVM, we want set_memory_decrypted() to zero the buffer
before the host can access it (I guess currently relying on __GFP_ZERO
allocations). Since no cryptographic encryption takes place, there's not
much point in memset'ing again after the operation as the content was
already zeroed.

I don't think cc_make_shared() has the right information on how to
safely and efficiently do the zeroing. That's only known to the
set_memory_* backend. So you'd have to propagate the flag down.

-- 
Catalin

