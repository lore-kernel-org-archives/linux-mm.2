Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E587010ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3BA6B009E; Fri, 27 Mar 2026 10:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574346B00A2; Fri, 27 Mar 2026 10:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A956B00A3; Fri, 27 Mar 2026 10:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37FFD6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:42:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E2B11B9830
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:42:07 +0000 (UTC)
X-FDA: 84592107894.18.EB95A80
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79CBF40010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:42:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=f9GADw8e;
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bk0dNR0zbUSNuzz8HU1AITn/eIsQuxRxjKTkb9qTHA=;
	b=SFCPTyRIxBsFTLsjwE5Hko6b1GZukCEcOrz+ZolpnV+7swBx+JqA7cP5AUiP+STek+Qzjk
	SL/DJZWU1dxI+eP0Htynq2VeZpPXasYUNffn+aY8ukbKFzhba6wKLci8YqJwAMwJreaCoh
	uybOgrLwrOfwhPw+1dKhdm+cr3v3/iM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=f9GADw8e;
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774622525; a=rsa-sha256;
	cv=none;
	b=vdmY+ZLS17/B4EpbV0szYZoXYPN7pvux9EP6WHpc1yMZ/IvG1fT+TGs4ihx6b4qETdKfJI
	LXoRh2uA9oqy6hcb9RRc0mhONeRpyGLGC8tc59DCBILDXrTlkhVVpGZXhO29h7asoy6yRg
	noNc5bExKEKmI+ITsmeEb52TXFYu7+o=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260327144202euoutp025973e1604532a7483810d2e0ee441af3~gucgZM9Fy3002730027euoutp02H
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:42:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260327144202euoutp025973e1604532a7483810d2e0ee441af3~gucgZM9Fy3002730027euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774622522;
	bh=7bk0dNR0zbUSNuzz8HU1AITn/eIsQuxRxjKTkb9qTHA=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=f9GADw8exPA2pVqpc0qboQT+Sy/jnB8ErnC5Qxv0djC6GCim3q4etY2PpzH24UY8O
	 7Qep4pkrHEwLMs1ACeuzsMQ+fh0iZ+IbqDSH3iKHqqqJLg/2MCUB/uj6DQCJzOZpm3
	 rD07b3C5yrAHKWmF8/mfyXaa3FgFSCYIyPSQnJ8E=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260327144201eucas1p2fba2f0b4d62780ba545ca81d1e42397f~gucgC2W412070520705eucas1p2u;
	Fri, 27 Mar 2026 14:42:01 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260327144159eusmtip22ec2e6c7eb865005539396807c731900~guceHbtB72669926699eusmtip2n;
	Fri, 27 Mar 2026 14:41:59 +0000 (GMT)
Message-ID: <455f1419-77ed-419d-b53e-e787dbd638a8@samsung.com>
Date: Fri, 27 Mar 2026 15:41:59 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, "Vlastimil Babka
	(SUSE)" <vbabka@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, harry.yoo@oracle.com,
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com,
	hch@lst.de, Jeff.kirsher@gmail.com, Robin Murphy <robin.murphy@arm.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CABXGCsNDfuLQ64r=sMyJ0UYbzZT_j8xsH5h0gpAGTPwV64Qp2g@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260327144201eucas1p2fba2f0b4d62780ba545ca81d1e42397f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
X-EPHeader: CA
X-CMS-RootMailID: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
	<CGME20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39@eucas1p1.samsung.com>
	<acZ3ZUXhFHpSXzYS@arm.com>
	<d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
	<bfa5ff0a-8ef9-46cb-8881-396f71ed5be0@kernel.org>
	<CABXGCsNDfuLQ64r=sMyJ0UYbzZT_j8xsH5h0gpAGTPwV64Qp2g@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79CBF40010
X-Stat-Signature: u786rmf3dg5petgni4mccxtax63kfoqw
X-Rspam-User: 
X-HE-Tag: 1774622524-14554
X-HE-Meta: U2FsdGVkX1/10ieHgASWrdpuN5ijn6PFfUMzUlxYzv2ap3WFxbuwpRq/Bn+RadPpm79Fj7dhDTNbYa2o0yztqYk4QbUj8n690/mH87CvUfq5QfX6Zd+71QFus9Jc1kvqMTC4jCQ1GBVmHTonBSzZqfZHgurAUH4eCDsDM9bYo7GFGWjYghlNVyAo5YySRJw2AjZdieqcFaNV0nPF1qM93+kO+wsfU6Ps5ztDLRn+k8goWTZS1IfecuRjPI01q8RK9EeEdpcmB/u2UI26rg8hRh72HHUrbwGJBT4gCvZyuPe8qR7rfy3TtiXmJSuUZ8bmBr1WAPAW4w+kvrWYOy8Mj25ssyvre/f7LyQURvkd3UrvLZY3ZYAyGHA/68Av2jaQaiX5uO0X70p49qDjj5C3ehDQSWQ/lLuarAkuuwq82buZ3OvL0RM3jvv3mVazE8sgwOkjIcPLtjd+rA9sUBb4ji7IJwENjO7VFMxAADGBUyzTy5OTM8aPeJvfO5bQbtz51UOONDf3L+rz3T25T6g6cUM6V+4IsW1QFSWMy8T1WbkO53nzZ4Hd6iuV4UK2G1oh0DItq7u6mhTSMGF1X8QNWnyEHjOiiaSxVBmmRteQoPun+IyT4X2OtC6PKUmKP/lQgC66/qKhxsmM/oYjb+Pwohuieh6fSm2DCsxuKzkNN/8dTX5/MFYzX7g0VrYysdxYLMxi4D6QwQkwIAzHwIioG+j+sot6CKHawvJH0RvlhBjJ2FCGCnBsM8kHubhzvIdr99l0vUkOJZ5UMqHKX+ZctmJIC657XyUk9jv4UtY4TIK0SSmSepk2exLrKUVXYYjZoyJGcfpxdgVRHFpAd3JPBRrfI9H9VVc0oXOjdlEa4x6781ZiOH3rTpNAL75zTYiIrpx/YYehHz9uc6EJo3fQ9Tb70/4G11+rSgQ8Mk0DAI2TJfm1nScKU/D1+40INcAADkNp1/fUMkPAZYgr83k
 Pu0QwBnf
 tPNoo4KUJFWA4aESO9zukLMgPA5MgUl5KvE3ZQvH2lW8iAsowoUrkYFzOSc3NgpjdMqYRX1UdG0TawQ5kzFrR5RaFzbDLVz0nWe5F2yQIsvtC7kllTMop4alZQBnKAdKftbwaAgPdL623dMf25I2K4pprIvIy4SV7dxLw6ORh5qgV+oXQpelLHA7eloQkF6t1E6JFfvPoWsDhrz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.03.2026 15:37, Mikhail Gavrilov wrote:
> On Fri, Mar 27, 2026 at 7:30 PM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> So what about Harry's proposal [1]? Mikhail seems to be on board? [2]
>>
>> It seems it would achieve the goal that enabling DMA_API_DEBUG doesn't
>> change the kernel behavior? But I don't know this area too well so
>> maybe there's a catch.
>>
>> [1] https://lore.kernel.org/all/acYlxRBhSMcwBnja@hyeyoo/
>> [2] https://lore.kernel.org/all/CABXGCsO_C8%2B%2B4%2BoPfZ%2BbQyrBnEGy5JFpXHkGNpfy%2B8%3D5BvVNfg@mail.gmail.com/
> Hi Vlastimil,
>
> Yes, I've already sent v2 based on Harry's suggestion:
> https://lore.kernel.org/all/20260327124156.24820-1-mikhail.v.gavrilov@gmail.com/
>
> It adds a dma_get_cache_alignment() >= L1_CACHE_BYTES check in
> add_dma_entry() instead of changing ARCH_KMALLOC_MINALIGN, so
> enabling DMA_API_DEBUG no longer affects allocator behavior.

This looks like a good fix, but let me think a bit more about all 
possible cases.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


