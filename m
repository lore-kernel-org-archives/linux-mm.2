Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF9BC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 16:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00ED76B0095; Tue, 22 Sep 2026 12:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01AE6B0096; Tue, 22 Sep 2026 12:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17A06B0098; Tue, 22 Sep 2026 12:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23956B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:39:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39E19120558
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:39:13 +0000 (UTC)
X-FDA: 85241958186.25.17C231C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 462A9C0007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:39:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="AYzw/dZB";
	spf=pass (imf28.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790095151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MF5k+yCsNWsAGZ1KhS9rt6SbP8uOUPLPOsvvu94PzUI=;
	b=CTYrZVuApApszLrXIu1y3jAysGA5gxnubTxjZbnbQWKU8fmCQZM8qr0GoimuyizUKUU55M
	/h/NX2IBLaYz8r5TjjsMY+0L81Mvn0yqUJQa9pw9ICw4BxtXg+zkolwuD9AZNVdowNlgrY
	Ki8EODEGyIpKpPbm9MVbTFHgANIj+n8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="AYzw/dZB";
	spf=pass (imf28.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790095151;
	b=JU/fWpRua3eIDAKpaVNzjYenAxMrnNyfBSG8ujOxL7ISof/jwhxPRboQWv0SQdmWx9iuOD
	w+l+/8+Vv+DnhD6kkTgigtviwtPOdonaDqpYALqXJ1UYp5gHuep8iDslAvoVW1ZayZH1xu
	bDYgppJMvPtY+JI6xxhSXJ2cV80Xuhw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C0461576;
	Tue, 22 Sep 2026 09:39:06 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3D7A3F632;
	Tue, 22 Sep 2026 09:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790095150; bh=YQf4ZF9UrIZkju53+FMc2/Zw5dM/iafRxTRYEbJms0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYzw/dZBDBEYe9/IfefTSuDA9ATgbB7Dnmm7bUOXpXYL7xrhaOG6WNWM89zKFywgX
	 Hca5ai3qk4fYLZscOfPi0Qh5fdm128r5ziOOA5TBgZtWFVOg+iJJUHDyzqYjkftVAr
	 3sHOOYEiFcjjnuFpaEP+biIIhTBY6lijgPOKAanM=
Date: Tue, 22 Sep 2026 17:39:04 +0100
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
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
Message-ID: <arKvKME-_wNeW7ea@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-13-aneesh.kumar@kernel.org>
X-Stat-Signature: ns9muz4nw61bgx89ucdihm7116a3hooa
X-Rspamd-Queue-Id: 462A9C0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790095151-992306
X-HE-Meta: U2FsdGVkX19rnFPLpZemD/Ij80be6+gx3KvtSimOZDgxKJebDFHQVgCY1kdPSc3b2FWzwFaH4+1ZmI2cG2+iOuz/PYHby3wvyjTwFGiAwiB1oymHGoca2vJ1GS9rsloN6dj8oGP3M2/h2aSEJW3HlPC4beYrHCocdtLi+esaJqBjNT7Mjg8G2O9cV8BnkKl56N0YNPdgUH0V5un6OkDCNQLzUlf1r9dTklP5ytPHP447xkBQd327dKJLFnU/z9YS9KGq0TUtxKGH2sx70HAXJ5g4vMJhEsfEVfIm1KP+8TYMZHzYHqEpMKwMFwrxFTHw6ukLQY57TGciVAUzIcGHKCLB9pPI3mPv6gXK77hkPlt8B01jDfwy805RxXVs85fBstrNe0p8qdSUMNTeWt18NEo2A6DNHmJCgDvf49yDE4bB+yEt9gHAgsbebggr54LlwFnkUgIJR2F4+8ste1YyqWOj0McFcL1wyaiGXgwRo/JcEYAk9D2a9jRMgosNLY40Y0M7gUnDTtItHTLxL7dPVenqIi+GvCXzeFkCrMFuL9W36oJvD6D+cFiE+LcMKlLuHFGnxQSWqD9KvCiyhvXimF3WiUoifcEgm7XQCgu4lg3tux2SLaIBlaCL36PSdc+gflSw6UP6VsI/RR1vOtrcAzs2RswCLc/pW0eKpikydMq9k/iLv7U1q1pygelUCmuV1BK26Yqonhv0gORlJZzDOprRJymtGuq2zVcoUf5sZU15o5olHDwF+1YP35ljnws3piLAdmgrvi3btLCEdwHHk1c61XElrXDSsiyIOdIsAx3a1CkNjtn97wqAgnq9OOpkCY2Hu1e7Cb+OocJT5R16ClD519SFp5Mz440OZjjBEQhSjcBrBmvJAsggQn3OhiXBFiSJPRtZ68cxrV04yOGN7aJzL4/ZIhFsMe7QDmuFSE/dY5LvmoiWVh5htIFOJXS18lYdb7oAiVHT1yUn+TI
 DMjuFlhP
 XK/KC8trOno0LVr1oHgNU2d3koSu/tPd2pDWmYO6UrJKzOdbD8wfRGVWi55o9rpyEH2Jjnur0xBef6hlrMv/ab7LBENmnNUQIsOobzxcNmW0NOO6s1OSCZT7zERyImvjWBzg9xBbSTtYIhQTqK8HQfdZ0AAFyLhWIJIMnlkAfmGalWkgMwXF5q2EWMqnZFJIiy8Gb7TzTbx/JEujQduOTaLM1K5EU96r3DpsnIGK5keLCJHoDp1zzEf7Ovvh7DaiNnnFRm4Nh+D19V8dotaGk/Nvz6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  {
>  	struct system_heap_buffer *buffer;
>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct cc_shared_layout layout;
>  	unsigned long size_remaining = len;
>  	unsigned long sg_remaining = len;
>  	unsigned int max_order = orders[0];
> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  	struct page *page, *tmp_page;
>  	int i, ret = -ENOMEM;
>  
> +	if (cc_shared) {
> +		ret = cc_shared_calc_layout(len, &layout);

You should not override 'ret' here, it was set to -ENOMEM for a reason.
cc_shared_calc_layout() succeeds resetting 'ret' and some further down
allocation failure, goto free will return ERR_PTR(0).

-- 
Catalin

