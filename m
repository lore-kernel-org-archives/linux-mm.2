Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79519C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494816B0093; Wed, 23 Sep 2026 06:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C056B0095; Wed, 23 Sep 2026 06:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7E66B0096; Wed, 23 Sep 2026 06:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D76C6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:35:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB5C9160785
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:35:53 +0000 (UTC)
X-FDA: 85244671386.05.BFC635C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF3A4120005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:35:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ewmaVXkx;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790159752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLOUNMxbH4leB6t2EuFHXMPMUGDuNnfudM9PRhQyXZg=;
	b=4UlI67vonAO8p/tHXzL+9RSD8C161DWtmlisaxfz1aPxLwrZk9ctf0sxtOyhwTYuDzi2nJ
	E+IHaaV4MLJpxZJY+vL7TDXE6kErIzw3yJDOIazKvf/hIYF3znB0iry52s4ZNuIzbY/yqj
	UoS+ZkNVppupo1kisybNJbFkxAMJ4Wc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790159752;
	b=beMo9hLTklFD0x++5T/cZMsedCw5egvn3vhr/3eNGScZSl/NTvoEtbLjOGO3S3rWSHTiJN
	cjBus8+8ZqjzNoW6dJN8CmJYxsUX0h9XplOtwHnmgr2rVonAGj4lhC427jBbTg6O2oPg2c
	qSJnC1YbY4KFzEWCBe4i8ZJrXs5OLbk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ewmaVXkx;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 451161570;
	Wed, 23 Sep 2026 03:35:47 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5ABC3F86C;
	Wed, 23 Sep 2026 03:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790159750; bh=v9G6lJSh6OMVo7mppK0Hk+jifrbC6I47Gu6icD1n1fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewmaVXkxLy98D6T0jp9a151FmO0Op77gHcimtZp1SgvTUTUKuJQ5luNggprLpjZMg
	 JZOuDeYoO+3y/I6Omc7mGGCSkjuReFAYGypqx14TBycfBylH51cJ9b2S2q0oi4rNBO
	 xrDH/ShQcUVeiWgWolvO3OpJNpP1DHa8nrUOGvJA=
Date: Wed, 23 Sep 2026 11:35:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
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
Subject: Re: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum
 alignment
Message-ID: <arOrgRfi1k12clT7@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-7-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-7-aneesh.kumar@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF3A4120005
X-Stat-Signature: qrphzbfaiumh4bh5qhj18xf4511ojcth
X-HE-Tag: 1790159751-928814
X-HE-Meta: U2FsdGVkX1/eFyfNyixcie7WK+QZCkrYW3plObJZffYYVtYuf1i1Qdq/OkNaFIf9pbnAYXQN+uBJ/32yBrPVxihWjOG7qb1BjTMWD3PsrySh43iZUoFeyoUZBdvZFmnsgLmk8TS+1MZW/ZtV9ymOAy0h2/5n8pGHbWLbBpxwNu+qnEEPfogGow8mQRXvjMkRNxGpvWjxImGGIBkEGOKd110TRDoOQCHdz+rYGkzgIzD22z+U3s5bDdIwMIqHfT1+OqbspYbrGTo+UkoQyDuqJqn67kWCutE+5otv7C14R2JKwVM2gVVJuRZkSNFMOIZ4kzvWd7kZmdke0tVNwOjm2fTSzJFYfpIPb0oxYxRVSOEGoPwfHC8DcjFHrBbVyi9QAju7mQfqxfwi8ZiN86m70tcbPzjnHVTZZJSE54QfZCvOrsIyBkLHklEyKnODkefFwK3+ScJNzl3+DSou3xwLFsRBHoaOe+X2uPjzYKBI/hZiH5TvbVmHjxGXIgTPkEy2hrhv9pJA6uEeefY5F91QO1DJ/YcJi0l+QwGmgbjMhhFDjQURXUvKVOnOPsfC1vWT9mYJj0nFT/bx1BwMOhAFL58sP5uGrrNVOBbaOQCNyUjMghM5qDWndvJdVYxNj+KagniS+CEVBVa5rX+JprS7OQRtGh/UzYy19cCZTh3qGHyT7J3mLidn7DE4f5Jp2sKUQeCdNYpjlwG4AVsoR7o0tmeI+fhgbLHacXLxhWpOnr6W3KQ9HOwq7UTsdgQrrYEXOU/FTi6q1wyEHrfqZ6iBk5PS/n3XH0OhZcBEFTiqu0ORb305KoLcyoZqo3HNEwwt3TrIiSimY9y49qChGrC/fo6VYt5A4inh1hU7XkXPbovJZ6J80cCx5jVYqXGU/dG5W97eY/bMZTm0ZYbNvkDP5AsLpXSMxkytoQOEM40FLeS8rs+KjnSoA/S2LytVBavHBW0v+TZ2ufVgNrQZHQe
 nkvsfADf
 SVUjGTmiigPwV8vRJOsbw3XlEtA+c7v6wpW6DKyjLROOZIi5+h1sW//Cjmj4pAvHRhn9ABGN5UkBWCD86Y1FB9PlVLGawaQxNkILgxQSBqe+Bz+TFLvjeWDmPBZTB1hv8lwMaNpQTTIWTW/LFc1vwxTc6iYf0JMQ9GOJoubSa0IzVA/RQ06ff7qiIoxCI2l7yh+5+EevGhTrBSdwRx5upQTkj6O9atr19Lz4dcHpxYQncluo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 08:18:40PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
>  	return -ENOSYS;
>  }
>  static inline struct page *dma_alloc_from_contiguous(struct device *dev,
> -		size_t count, unsigned int order, bool no_warn)
> +		size_t count, unsigned int order, unsigned int required_order,
> +		bool no_warn)
>  {
>  	return NULL;
>  }
> @@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
>  }
>  /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
>  static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
> -		gfp_t gfp)
> +		gfp_t gfp, unsigned int align_order)

Can we not just bake the alignment further down in these functions
rather than getting the callers to pass the {required,align}_order?

-- 
Catalin

