Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F708C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2616B0095; Wed, 23 Sep 2026 06:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573C76B0096; Wed, 23 Sep 2026 06:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489B96B0098; Wed, 23 Sep 2026 06:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29C4C6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:10:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B46521C2F8E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:10:40 +0000 (UTC)
X-FDA: 85244607840.27.6E0E8B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08CB4140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:10:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3sYQleb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLS6K5yNkNKdGDkQFfdRpx4/MjK91Sar/Xvn4H+27fE=;
	b=oRL/DH8motu8YLssO4sXSZE9st2Iw7btlkIywjavgkQaEfnjJ+G8Ed+QRuX9Gr2BCE4an6
	pxU5XImagIjWbdl9byYmfzs/idIjIH8CDELczfwauj8sSoNDWnl2mbkLIOb9/3UHNtrKZl
	qT4HL//uwqrmtdqgFD+1se54cRF5hBY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3sYQleb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158239;
	b=fp4m5KtRrgtgxUwahgKdkMlJZ3ZfRP1Ta1OvShC+QspguX9UfRMOL+vrvoKvbyp3rhe0/7
	DMIJPI8FTJRdx05WiKqn+ooeAGcz0+Jv5h+iPyMzwVz2VxYeDRpHs9Q2nsP+AL2uOEKauV
	9o3ohiOLQGrdk8iYrrrJl6YwxkHRCIE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8480152B;
	Wed, 23 Sep 2026 03:10:34 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 146163F86C;
	Wed, 23 Sep 2026 03:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790158238; bh=aJd5PwgdVPJ9tE7A7OasMy/wKrzLGbTgJY/jXplpFIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N3sYQlebo9JuaPrX/aY4BYXg4kl12bBh2l+dg5S1TpD/sd1OrXwH32xGOiPW5K434
	 UuBzqurGcjPFaH0amX7WpALPGj4+fE2hTuRxrmfBQJcpZcj2x3NVvhpckvNi+KxnQI
	 AtUULuSivZdyBUiepK0KoTPupOCiWcVRdZmElWyM=
Date: Wed, 23 Sep 2026 11:10:32 +0100
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
Message-ID: <arOlmBBWdZTi8Xre@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <yq5afqz02wtv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5afqz02wtv.fsf@kernel.org>
X-Stat-Signature: t6c6je3sapqs3kqu77pymnfbpmactb5m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08CB4140004
X-HE-Tag: 1790158238-648811
X-HE-Meta: U2FsdGVkX1/jrwm1e+tyq83n4RHtsJkXLcBVyPDNx/T4Bc8oOzNReUZzQDfxygvAekfAwmJMht365m+D+TdQuaY7hANy74Acn75M1oq7DbQda+58pGJWiFZ0PY0+MT+QclSCIQ8+7Oo4KaY59TRIeDFAijiEM5vqdUlpm+HySyvcb7W6G5cCd5OR+L2nsodaBtVtwyodI6+Qf8owR/LmeQ+WwH5SUlsk+GAtw/6olxRulw9d8jYGr1VEVf40KR0R8j+EMdC3VcyJyUi30haf8qg8RuTlgkrEj/7vX3S2M91DDELEjvh9B0m9rHcxzZzebGCK6HeQOSscdQCykG9dpRsTZkw14BTSYUKLNSxYbv2i+RznJIjPW2usOFZUOhQD1FwkjJuVGr/dSl0dgkFr4MaeinDBKnV1gxIibQ3Nn79z2JfIQaxzTJfruE0uMY7Kgth0qDezcx9pSPhydx/78mngT6B1dcFS3kDZ6yVuGD/ROx8+FkYqXKly+SfqpzaPe4ZORjSTyNHNjUGBIbPv+Xk7XlfKn1j7gfIXA+jlAI055Hr7p2tpRRi8d0KZ9kE4caR3T3I7fLniXeYC9m6PrQzZ4ZJqhReWMStjKTZvn+yw02qYh1TQCnB+zXo1EFNmwQbejx5EpiSO9UpkdqmYnc7xfwm1PbZt2EF9CAgrIwNC356M9grMZOv6ScPgEH/kQjBfDqpMOEQz1+GGfDg4x05ROzd+RhKe2qyOzH6mtODtr6xwpgJUH6NOvinIbFGrtblUOzjPRwPHN16nhiLfL4+yhrYoIgUUpDQgFZ3QV6bOZ2R0tiDbl0nfUZPCWgMxcrgd7VejyVG0d82M+0sskI4oEUh3hZAF/St64YnFuUUuRASBFeNfI9nAi1NALVVW8eHQpNzG3Golm+H4RxxSoLCauWJWlXp/tbd9L+HTXEBv0WDDpneKX/U4B4V5IdB7LMVF0Eq6SaqYA3qH6Lu
 JuiGvfNP
 A9Hv9b6bdSNhdpzjtcNI3VXttmrPelIbmj6zRM0AtOwwqURJDm0TXUz9wqnIyFZXTWgvoA2H6RldZJwLkOWZ7UOIpMlcPfcRknc8AngsOYXmn2jIOtxQzf91QCQJ/FoROvaPHwBr7koh+WSjbXbvQLHkI5yvIR/E2s8Beh5czP0nCWciopueTeX8VC8rTYO0G/HzvTivTY+qtDQr9lyDoGhfaEVOyMllL+T7BYpNw6P1SJ6mGGv9dqlPtCrIHfW09wGuH2TxZYyuDxkI8fnnWu54ixo1kOMGeSfZY34iUjiXPs60rvYLpV/jmyeFTzugzD9uYHLdY1Cal5qB3ssRUEYGa8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:01:08PM +0530, Aneesh Kumar K.V wrote:
> I was pointed to this email thread:
> 
> https://lore.kernel.org/all/c25502d3-35c6-4281-a9ec-856f789fb1b4@arm.com
> 
> This makes a stronger case for having a CoCo shared memory allocator
> that captures all these restrictions. It also means that
> alloc_cc_shared_pages_node() needs:
> 
> 	if (WARN_ON_ONCE(!gfpflags_allow_blocking(gfp)))
> 		return -EINVAL;
> 
> 	might_sleep();

I think gfpflags_allow_blocking() is the wrong predicate. It checks for
__GFP_DIRECT_RECLAIM but we have callers like dma-buf which clear the
flag (see HIGH_ORDER_GFP). ITS allocations also use GFP_NOWAIT, so
they'll fail here.

I'd just keep a might_sleep() in cc_make_*() and ignore gfp flags
checking. Passing a no-blocking GFP flag doesn't necessarily mean the
caller cannot sleep. It might also happen early enough (like its_init())
not to care - __might_resched() skips the warning if SYSTEM_BOOTING.

-- 
Catalin

