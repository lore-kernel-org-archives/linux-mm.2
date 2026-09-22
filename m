Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27D8C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 16:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6426B0095; Tue, 22 Sep 2026 12:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66746B0096; Tue, 22 Sep 2026 12:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A546E6B0098; Tue, 22 Sep 2026 12:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8C26B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:26:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CB70C0551
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:26:07 +0000 (UTC)
X-FDA: 85241925174.13.E601845
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 077C714000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:26:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vLKpHlXy;
	spf=pass (imf26.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790094365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58sXfyb0nX377cUR/X5f1yC05yxG1FkjjSAo7vPwMXU=;
	b=YjtBzF0Bsog72o1L8Y8d4yjDK163GJfULoGiwtQAnXKJQSrOIGdwxIhaCDdm3CMkxPPx+y
	YqW+9vx5ueJZVlE+8TrUB8S9YYOYI8f77cFEvLy4yh/bXWABaJBlpDaHZIZ45iD6eblqVo
	R3Ruj7GS20msHG0HjcPyz0eoQHjs5sc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vLKpHlXy;
	spf=pass (imf26.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790094365;
	b=3+5CR7eJwsMvin/qPYsI3reLNLE5v9oYMtZHVJKjzHu5GsqkfVG66Kr0EFFeOhfEacpTu0
	mzUwZvTkR9OhquJWQeFzj7A7YQ+O2Ns7IWTyRqX37t9z66dtFjeyZOC4g1V+lyKdU3NNsR
	IEwQ2SJTIVOQLiYCwLpn4QJgaJhW6co=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 177FF1576;
	Tue, 22 Sep 2026 09:26:00 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06CF23F632;
	Tue, 22 Sep 2026 09:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790094363; bh=ayic+nVzRT7jF2h19D33qb2NxY0nfyFpS1c2IauCEkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vLKpHlXy9TeAxplzn8LuOxnhs+NZZT08I8jSb7+j1I6L64gZFqCGnchXfZ3Dqibh8
	 eQMv80pCWNlnv73z0GmxiYSywlJm2UuyVrhWN9MyheshF5MMnKprwZkReiNsEO3hTc
	 KddnGGEGanHe0MFeVvE3aGvk5G7QNuyyTWu9q8xw=
Date: Tue, 22 Sep 2026 17:25:58 +0100
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
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arKsFofudnTYpXj1@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921144847.501151-3-aneesh.kumar@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 077C714000F
X-Stat-Signature: sy5e4no4wx9pwi8uua38bboezh44ycfj
X-HE-Tag: 1790094364-976424
X-HE-Meta: U2FsdGVkX19kOzwkW8OYWrC3LrElFTr4TsQsqkSnI7pfp5EZlZGJBKP0yIGlWcDt+ehQgF0DfsZwP0OIm9Pt6bvhJ7/LvTPtrBtlieJdpd9DE4YsCD+pYAXPP1mOobGqqN/vy3Fmn1Kp1SupbSi/nH9t7+VIMLEocFfobtq7oFYdsmD6j9hCrBiRyKmXy89jrKCfMukwNJZyO1D+3uoS/YJvOg+1n98hH2LoxspvjnZGPxvH/eMwqs9ks4MyuPst9ZKgwqV41TOhU+EI2Wd5uqRm5BMvcOkfs+MM6uSXl4UPNc/OJcdTUUPYEYjFWRLbkJlcLcJfoGGvC2/NelhcWXZwJbRg49yyKGW1ehq5o+nUN+3eP4dIoV6I245fq/ouJQkZ/TkXXpaYWM7N0h+oxDUC1tIvTTC2c0obm8au4SxwlCmL8+5P1W7xBqpLzeYQGSTi63qHxzZaSC+PHE06Y6walIXTX5nxZIZJALPjk6NlqBVz3Odz72XR30IvuwoYQu0MUEEezz3Ck2VNFwgqoCvQ9oFa6cU6ycS/iE7T1vb10GlMmzoKRbfMwajPBS1PfLkTHeXvZw0MCSqIwFeEsKZMDk2I/WTdTAUP9N38yVzTPN+jlb/YFuycl95ZJXlldVZ8sPrbF0zUY4/2PCgxCTzfryhX0JN6lR513//5gXOwp+yYQJeXnIBOk5U4i8GqwOdmQIVUttD3LnlZK70qU6do0zXw6er13QY623HnPMoRm1+yJ3jBK7Gl+guyzKGTPMz1zycs9tSKhf+Sg3dknPbpuO5VTvUFmqsTYcw9vZwDX+1Y7XZ99qM4GKyKfLfZDzZFARUZ7/KMXkUGqNZgvonef5NInZe6HlSEynO7L2SgnxZKYRUwi/fJ8YiURs0RbkH6vaU4pU8+D2ys92jIQ5vxIbXTUtVXkRP+K/p2n4oRdQDQmtmBj5WtOD49USQcF+U/56XL5MT7TW9C1aJ
 b3zXfVo8
 FS+nBw1Z9gTk5WKuE3Fff6q8NLgs6TQALgLkELnW7b7adJSlcu6g1+navyU836P6fzKpLhLZtbsgO6WqIBKHzMVsn2Ehn8Evi3MRvb+1oea6N+WuA/5t31uxS3fW2w6t5O6MoetrBdPgvcfSn0XrfZAOnwnm2BV4dHFM8JJr6Hp2W83BjSshsnXhoqP7QFNjknOEzOI9YK4wfXOg6Z3ZEGAhzc9iFIDHyAHurQd7Ht99U34I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:
> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> +		size_t requested, struct cc_shared_pages *mem)
> +{
> +	struct cc_shared_layout layout;
> +	struct page *page;
> +	unsigned int order;
> +	bool zero = gfp & __GFP_ZERO;
> +	int ret;
> +
> +	if (!mem)
> +		return -EINVAL;
> +
> +	ret = cc_shared_calc_layout(requested, &layout);
> +	if (ret)
> +		return ret;
> +
> +	order = get_order(layout.shared_size);
> +	if (order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +
> +	/*
> +	 * State transitions require a linear-map address and may modify memory.
> +	 * Allocate from low memory and defer requested zeroing until afterwards.
> +	 */
> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
> +	if (nid == NUMA_NO_NODE)
> +		page = alloc_pages(gfp, order);
> +	else
> +		page = alloc_pages_node(nid, gfp, order);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	ret = cc_make_shared(page_address(page), layout.shared_size);
> +	if (ret) {
> +		if (!cc_make_private(page_address(page), layout.shared_size))
> +			__free_pages(page, order);
> +		else
> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> +					    layout.shared_size);
> +		return ret;
> +	}
> +
> +	if (zero)
> +		memset(page_address(page), 0, layout.shared_size);

Does the memset() post sharing logic work for pKVM as well? If nothing
clears it, we have a small window where guest data is leaked to the
host.

Is there a case where we *do not* need the memory cleared? If not, maybe
we can move the logic in the arch set_memory_decrypted().

-- 
Catalin

