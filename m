Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57007C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DFF66B009F; Wed,  8 Jul 2026 05:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6CE6B00A3; Wed,  8 Jul 2026 05:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCB06B00A4; Wed,  8 Jul 2026 05:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D58B06B009F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:00:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B86C406DB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:00:07 +0000 (UTC)
X-FDA: 84965012454.30.5F68311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A36A8000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:00:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHtmHf+W;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783501205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42ENaxlVxio2+AeXpLQCCBY5AaY42vaHQtw8IyJI7n4=;
	b=d05hUxHAwP2hzHT1BaDIskvnuBRTZrChf0YDEj2NmfXmNVTb7iKrnf6roCIYvg34XCp8H/
	srOGsRmc4D0MtVI1eTvp0M2u20z/KJSRLFnzI5aDQC9tDTa0st73ys3w1ilFlRcNiknQhp
	g6UVmkoIlxiPlQVVg9h7GPm85HYEr0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783501205;
	b=ROjde8FhUFsULhLexXMk2vWhqNQWzomHm50FBdEwhJhBCdbrIb+HBc2NutIFD0DpzMbjUZ
	+/h7aTi5dbOaG9LxVCnRfndeOJyxOWJiFCwt4sp+vAEewiTky4s4mE4Y8JSQb0mndG3Sg1
	B1tM7FM6NOQfkQeXeWCuBr1QIKk4qt8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHtmHf+W;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E47040498;
	Wed,  8 Jul 2026 09:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88291F000E9;
	Wed,  8 Jul 2026 08:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783501204;
	bh=42ENaxlVxio2+AeXpLQCCBY5AaY42vaHQtw8IyJI7n4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iHtmHf+W92OnzbuIGI/2kRlZExBywlAzkyUDXMC6Rjv+NJD7rS2O7NEduy2egn4G7
	 TKjsBbmYtkGtNyvRhzZnNvUK2kcWhL+oPKetwYOGs8n79NmwgfBymXAI2yeQLHqR3z
	 MrJjwMra9aWFMHaLJZBFIIPGAJYZBb6FFWpTBlDNOhJIAme4maDHpuOMLuMr8jQH/W
	 Dzp/KsdaILh+27RGjHZK71B/vovDbAdEX05hoarii4XhLvaBDQxMxOMKE7jTeRYltK
	 ldw1+1HAHXHEh8oSVliTo7a8sMzMXQj1l0+oQMVe2k7shpGJ+BJsGcdValVGj/F2lU
	 Sqnt2Ad8FzbxA==
Message-ID: <b1c1693d-02b4-4c5c-bb0a-1c2d87258d30@kernel.org>
Date: Wed, 8 Jul 2026 10:59:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Sowjanya Komatineni <skomatineni@nvidia.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A36A8000D
X-Stat-Signature: kkatzq667h58b4kx47bhu84o7s3xmrz8
X-HE-Tag: 1783501205-301153
X-HE-Meta: U2FsdGVkX1+b5rBEaBlPYqLkijQBAAdmjuwen4dOf7Jft7dqd7aiMxgaWfYQbVMGyK3mDQibrGNl8FILupW23ZPImjAdOA+H1FXXDNMpdB6HD5EasHOY4Fu/2ZO9heir+rNtOxP6B2/hQEmqZCh1HKouNhj4cs/2J4+RJdwDfwzUGmqM3zdluKnf9c1l9phcP2z7PPyhyRt/GsplW7aQQqc1BYQyfVVBFuezFkp1mzJHu8KUWKvdZN0lDyWc4WNcIWj0AIbAZ/0FxejPOqJ8s/wTQCXM1D71tyhEiRzf9BgvDD1/NpI+0ZKtuw8tlsMdCsy4mZUzadhiVTUPkv8X3JRb4JT2xzvpJtstNDkgEvF1qBGOncfvCP3TRBp90X43voaOllp8tzEqHzC7vDNdBM96WCqjQB73noAQ83/XMIlrGdNvrhQbSOWR2qjzYYilBVM1yJwToeZKA1VxqQuldInMrzGUDASAsJpT3B1pzByrY6h0EvsGR5ZNVQy2ABNXMvOmOQpU3lr640tfD78tEC7iqkJJfU+0OMErAOqViNKhxZuvjicVRPUtacENemB5wel4tvWOxpcjhx3u9ESe9JBriAwwXKrMDhpJ2EFzUJweRQUib/bXrpYFsaVYoSbUrwXSRjQ4FapLKFOICiE8zN3C1KOL6XIgYV/5pOdzOVKogAZiDPRfg/Py7Pkhn1uHRm50VaJ3T8UFeuv/G6L3HMhwYDpmNqZKqd2ex0ibp0ttDCB/Qh0htdm5j4IKBHFbl4xov66hY1AmQqM5NXTp3Kq+ZTvkF1io75P3ZzV7uG9re6YLZPYCdpX3+3YkN99z0kGtS9/gHgm66qy0IFShw9VZgDq+aiCVpoYZjxE5Wfm6IcvFbL2n1U7tV2z23QBxdCAOAvb+8Jc9KQQjSJwbg5f4UMs0qc/tLsTFNNsPHA4TRGN4VOg8i/LHDFKyABCkv+ZI0Sumpi4dFmyBLN5
 ta4Wmy2f
 Xb247QoYjytooXIqX1vLdP/GBat2pd64Uzd52DpTvSv/VjqnkRdNyKPH6V39gMNl84WDeia7Ysit6+ek4H7g+U9KDljVjlVNzZdsaxwMUMzwfJ4V4EXWei64GVzK7zpIk6qEDqna2uGDAWn7iO8v6qsfDcpFuTCA5UhUUfOlnK2I247XQuiWIdvkTOjyOf9uWek2sBqjYokhEZ7YFtRv4W0H6PWETAbHrf9fLA0DLBzP76lRfseBL4K+SLXLG71lLTOuQc9UkH2qRYyZQOWvgQVqCUjAokNX41Vq6D8gmD3HL3O2tPV6u2wA74rO3Y2eqRf08GaGoKx5C6Wozn0g69nLhMAAgKsY8Hec1tUXMdh0jkZd5DYzs796PPBNFidrW6X5oUTniG9PAwGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 18:08, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.

I'm confused. We still allow cma_create() only during __init, right?

Would we expect callers of cma_free() after __init? Or at which point?

> 
> The static array of CMA areas cannot be replaced by dynamically created
> areas because for many of them, allocation must not fail and some cases
> may need to initialize them before the slab allocator is even available.

We can start with a memblock array of an initial size (like we do today).

Then, when you need more space, we can double the size (copying content and
exchanging the pointer). Either allocate from memblock or from slab, if
available (slab_is_available).

memblock does something similar, see memblock_double_array().


-- 
Cheers,

David

