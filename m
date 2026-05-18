Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BC8CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6406B0093; Mon, 18 May 2026 03:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296CA6B0096; Mon, 18 May 2026 03:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4B46B0098; Mon, 18 May 2026 03:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0546B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:14:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEF9B1C1DE5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:14:34 +0000 (UTC)
X-FDA: 84779677668.05.6ACB5A9
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1908C20010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:14:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZTZLi9dy;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779088472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hejV/tmqwLHbKahfMWeS4MTA8R3C7KzYBatO1tjh/8=;
	b=xZvUUlCX0+JMP/b0ls0hePuUA36iZGwJK7JNxJTlxwymmBgOHVVmsh12EJQqEKofrTfGCy
	A7t77qMsetru0mQ2tsE1uBsLtSFnBURfUoL4T/T+EXb0UzzKtvZHO6VDDjM3WXfzcT0U4L
	JCYRvD0AaQWvQxBBCsaM7kNSNFJA3io=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZTZLi9dy;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779088472; a=rsa-sha256;
	cv=none;
	b=MUIoGl1Tb0+teAvVeLnkj513pr/dgIS/unKbZfNtwMG0rkUh76Fy+iI6MVm8O/7IyWfn8J
	pzAXmaVRSz6dPQeXEw7PB523aGEsLgrA6CQ3FYAyWDA7VRnieYrqUsT9b5jE/IPmAVllIc
	vKHACPkx65ueEpUqpao4r5owx2xlRwQ=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260518071429euoutp01292d91ed614c5d2b3b9cd1114f1a771e~wl4mE6PCm0358203582euoutp01f
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:14:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260518071429euoutp01292d91ed614c5d2b3b9cd1114f1a771e~wl4mE6PCm0358203582euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779088469;
	bh=9hejV/tmqwLHbKahfMWeS4MTA8R3C7KzYBatO1tjh/8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZTZLi9dyAQO5VE/UmH63k0mnt+MOcLYIJA6f7KdeRjPPnpbzlNP9445pRkI2LohNe
	 8DuOSm43l9ZjBiftP/QYR5DClExjL7eZpb/FXq/0/1/fd68rHh2HgkMkTNuZhKOY3L
	 qfU7sft8X0IXgsIkXAmZWKwTKKUuCmhHoTjzX7Ec=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260518071429eucas1p1bda81655e398737dab2d498abf9abfcf~wl4l1YZO31335413354eucas1p1h;
	Mon, 18 May 2026 07:14:29 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260518071428eusmtip11d1413a3932c737e1c2a98b0435599ad~wl4lMCr3l1755917559eusmtip1n;
	Mon, 18 May 2026 07:14:28 +0000 (GMT)
Message-ID: <0da45751-e4e1-4c98-91ba-08340723ed95@samsung.com>
Date: Mon, 18 May 2026 09:14:28 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v5] dma-contiguous: add kconfig option to setup numa cma
 area if not configured explicitly
To: Feng Tang <feng.tang@linux.alibaba.com>, Robin Murphy
	<robin.murphy@arm.com>, Ying Huang <ying.huang@linux.alibaba.com>, Andrew
	Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, Christoph Hellwig
	<hch@lst.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
	<will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260512085509.83002-1-feng.tang@linux.alibaba.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260518071429eucas1p1bda81655e398737dab2d498abf9abfcf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260512085518eucas1p15d8e1a1173b398b496936d96aa29378a
X-EPHeader: CA
X-CMS-RootMailID: 20260512085518eucas1p15d8e1a1173b398b496936d96aa29378a
References: <CGME20260512085518eucas1p15d8e1a1173b398b496936d96aa29378a@eucas1p1.samsung.com>
	<20260512085509.83002-1-feng.tang@linux.alibaba.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1908C20010
X-Rspam-User: 
X-Stat-Signature: 565iaaf3rb4bxbiqwp9cn3manp5x8kr8
X-HE-Tag: 1779088471-44791
X-HE-Meta: U2FsdGVkX1+YSQplpu+9kc8JVCX/dMUyxkMLaj7Y/HE6NV+7Ej8cMtORrmkX6NGnSuY49C4Ns6Ut6T+oeVyRu+XdL1Lrwm30ADMTFM0vcr1cOHzL6oTpg5bhczXoeB7Vwumz6MG6GK1ymsAHfcfsqpZLvOOEmvqlcbNaNe50/bFE1REkkShFsnkEfHR68bjYCTH3OMVJ+rujzYtoo/Nd+eTJFpCtdSByG6tX+Cl79Duil+zH2R+oXyRiRcCVpt60vNJ/69VAg+m3EZzGJj3J0HB0hHKDhGw7cSozxsGE/e7e4sJuJpHTHUd8BYKql0QVuAQHsOqQfawR3Q1w4iJsm3/TSb5ou5SbzEXCwoGnzmFSYuvUTFMR2NKG8fQmEYIshOaeqTZVb2Vq5f586vxjGwW8hPWp6Vp4OpBI5i9FkDZN0ilKt163RxmMPe3DOaQfieApwKOs5RT0QXd/nSn0ZVH9k1RgBqC1fZDNvGQ5ZjmVdt3IMbZVSBJ6cYyvDqybqTmF0vW+WR0cR2m1rF2X7x1CCJeR1sz/wQ8NZ5ZDOhqhdJu9CB+lWcahE2iyKq5OnQcxF0uEBVGuPa38d94pXnxdnUF+DXf87W2dN7FkhziEHou1Mp2IExg39YA5s9wi5F5g7vACJ1Q886vxSVHBn3hLctHtzBahWnYenz4ghJElY01+DxuFOxcBhbj8RHQTV860Vczd7U8NYVUWe+vjb1a8Qe7HiHj+NXb4PsYDrRb+wPU+TqHw5ljaVofRRck0r9a+L/3q9A64KxXHV2tVgKLc8p7AkP886eg1nwpvmJ7XswER0SL+sEzOXJBQ+Ya8m2BCBewf0ztPLrpKbOcw5h1PgCXKeviwZfKWWH2L+zCbfLqTx8XWrFdj9eIdkg0gZOVg9HNXLzv3UVxkSUSKTRZFsDvjMHaYiRMwmxVJHiEwIba/6kpEtnnm8ZEgP42GYVdTUOrMltQiqSrNWd4
 88yQOgdP
 vjocfcP3qtziTcRmoO2m8fKNcQ/WiyRGESEh+aoMVJTsTvZznt+6IzXNgvTTjsW8I8QkrbjetAoem8nCvSDMcIpqjVrvH+MrqiKTGeFtvlcplTpAJeU43Un+S/p6LxpGybFWf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.05.2026 10:55, Feng Tang wrote:
> There was a report on a multi-numa-nodes arm64 server that when IOMMU
> is disabled, the dma_alloc_coherent() function always returns memory
> from node 0 even for devices attaching to other nodes, while they can
> get local dma memory when IOMMU is on with the same API.
>
> The reason is, when IOMMU is disabled, the dma_alloc_coherent() will
> go the direct way and call dma_alloc_contiguous(). The system doesn't
> have any explicit cma setting (like per-numa cma), and only has a
> default 64MB cma reserved area (on node 0), where kernel will try
> first to allocate memory from.
>
> Robin Murphy suggested to setup pernuma cma or disable cma, which did
> solve the issue. While there is still concern that for customers
> which don't have much kernel knowledge, they could still suffer from
> this silently as some architectures enable cma area by default (not
> an issue for X86 though, which set CONFIG_CMA_SIZE_MBYTES to 0 by
> default) for most Linux distributions.
>
> One thought is to follow the current cma reserving policy for platform
> with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
> or 'cma pernuma' method) is not explicitly configured, and the platform
> really has multiple NUMA nodes, set it up according to size of default
> 'dma_contiguous_default_area'. This way, the default behavior of
> platform with one NUMA node is kept unchanged (say embedded/small
> devices don't need to allocate extra memory), while the general dma
> locality is improved.
>
> Add a new bool kernel config CONFIG_CMA_SIZE_PERNUMA to control whether
> to enable it. Even when the config is enabled, user can still disable
> it by kernel-cmdline setting like "numa_cma=0:0" or "cma_pernuma=0".
>
> Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
> Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>

Applied to dma-mapping-for-next. Thanks!

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


