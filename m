Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC24606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFk/Y+ji
Received: by kanga.kvack.org (Postfix)
	id A25146B05B5; Tue, 10 Nov 2026 05:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD1D6B05B7; Tue, 10 Nov 2026 05:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB6E6B05B8; Tue, 10 Nov 2026 05:31:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66F096B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:31:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F39C5140509
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:31:19 +0000 (UTC)
X-FDA: 85418842278.23.BCCA0D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4F1DC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:31:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TFk/Y+ji";
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794306678;
	b=G/tT4wDXDYcto13hhnk1oEloyIi03K+twiGnxtAqk7J8fm7TrvsMMxAoszWPxIvuwfxrEw
	S8n933bjxj7SntRxtf1e65AHrPT0eVPMcf8INVAGIKaWXII+tbKjxxuZzFtUzZKEWdkI0L
	99KSRauSTteQUMFlL5dw4S8zqW/fZSI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TFk/Y+ji";
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794306678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlTOvt8xOuSZHY/ZhFJxT3wExaMHYGHsA+ZOjDuv1Xg=;
	b=s4jCkszH24J0tA1Pxvv2TwboSapXbxRl6q72RtcrMwosUCfStg7pWsrF13uru+2lqzSjcQ
	xMd2ERpK+fLwgxgpoxUoU6IR9Rv0pnVH+i/LIlunDsIycNoaZvIUXthLDm56/VW/Z1em9p
	eoLzb/xfgKA/r8Gf9r4/96Y1R3NLxN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22CE1410D0;
	Tue, 10 Nov 2026 10:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C371A1F0089F;
	Tue, 10 Nov 2026 10:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794306677;
	bh=FlTOvt8xOuSZHY/ZhFJxT3wExaMHYGHsA+ZOjDuv1Xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFk/Y+jiK+EeQW5DRQUIlqyMDJ1m7JtpGMtzUWzaNuBXN8NGzSIQYRjDtEsZSS/Lq
	 nTl+qHoUewD+1ZWM6II/Z3cVkeeffvj6N19cFlEpgV0ZerIjvKcQsq7ti5MBhDtgh+
	 Z6ABlVaHvb0obwpM9gRl506tiidEpK9JNBdgYLo2DPwy3DEAR49tfrZAexflUvATq4
	 PHnjleqWVM/ZNUU2TiM+ak+96r+PD/jhhY+YE3XzdHqSnJ2Chwpnp/PtFjfKvZIU1l
	 KGxHtdDHpHj5UenNAe4G4E+rwKnmRmHw6zeYBP8Izh4offkWLE5yQ9MCwbLrz7GQ1C
	 V+XjNaE47uQCw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 84C96198003A;
	Tue, 10 Nov 2026 05:31:08 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 10 Nov 2026 05:31:13 -0500
X-ME-Sender: <xms:a_LyalRqEEi22Zqq6xXTNfIUy1eL86wOL44elLImVT1Lsz4I5o4NDQ>
    <xme:a_LyaofLRkKgdVDCIpLMt-x0w2QBiy6WJ3SG2qd3kB3mLSD0b_evF3p9ohLL5ZLV_
    OfegCXLJf86bDoZm-OFgj4KgF0XOHoCUx3AT3GPPCQ0H9EYcGT2_YSL>
X-ME-Received: <xmr:a_LyahzS7EBQguTo6tQOf3vfPqVyehOAK23g_Ana5o6vWhs_lDY5Dgn7Ycs>
X-ME-Proxy-Cause: dmFkZTEG22a+fWVd70W49sFkRLfWvSfLcWkkA8IdPKW1pytV604LiaaxMHr+3VX6gcn2ih
    GiUPahwkcrJH43OV7arrk1kjGoupNgLdUGWA4rlKrCZdhAxycDsbiIvNnshqWYHI+xLDe7
    dxnOUcGrxdxai4noAKbPqcoiuqTq9Tod3cSSi9wDUWiqFbOM1ID69QdDUWEKVjGm82rvAt
    JR0UnN68vbOUf5D+VOrJZpgRA9Wh8QJ0moenK7uAy/B7MIYsD+VIAyYz7XTWxdZEo9/pA+
    5BRy43Xu6FxuylSNGzBoqk8fdRU/C/TaThdgv/qpGOTUROZq+kPfrdsgaZtu/HQc2YspNq
    EKJ62rkXCupFiccIn7l53OEU9i211HD6OS/YfEOm47OcP2NA61JeSas/jWclFEP3D3DEeE
    efYfWjXpUN+S8GDN/VhSqFSJWW4VuwFgbEpc9uHxiC67VKgTZ+ME4p8H3qec7YdgCKwFWG
    eHP2eUftj4HU/7zaw8vRb54j2/i2x5gwz4FdcwObCwUq/eJ09xn8D1Ip1B+J5u2vN/slUH
    LNLhiJthRs9RHC4IILLJbsnRZhvAVfABd+0fCgi6qFZyoN50GvPmjgxDdz8NgWpk/R2ks4
    VnE/UIouYNnuFUF5IN5hePej0uFfDKFZ4yO3cvK29zLUrxuLXll19+3AYkvQ
X-ME-Proxy: <xmx:bPLyahG7ogfO690v1-QjAH6E3xLHXpH-QYT5DmlN8Q25wNoyJG514g>
    <xmx:bPLyat5zOTNLQyqaeyO7kYwF95OY41Lo4707nSIzHk49ns3u-pP4jw>
    <xmx:bPLyagEiQCloo7AHvZ5xh3p-bgvb-j_epsB5qcDMBfskiHWpaQ2BcA>
    <xmx:bPLyalA3FAEjqpSRI-xagrKLiK1OOBO02b09RiOIh-Zgwo5Bl40rNQ>
    <xmx:bPLyahBlf8mf5Dse7Df3PSCo9B8OPUYJcjcL_9jT9ga7mVAS6Bz3KGF0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 05:31:06 -0500 (EST)
Date: Tue, 10 Nov 2026 10:31:05 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, jbohac@suse.cz, 
	sourabhjain@linux.ibm.com, ruanjinjie@huawei.com, leitao@debian.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	zaslonko@linux.ibm.com, brads@mainlining.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: allow crashkernel to reuse hugetlb CMA
 memory
Message-ID: <avLyOzQMBnHYLEst@thinkstation>
References: <20261106165142.2847916-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106165142.2847916-1-usama.arif@linux.dev>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E4F1DC0003
X-Stat-Signature: 9nm6h8s8rg4j57x5k7oyuu4884gkyh39
X-Rspam-User: 
X-HE-Tag: 1794306677-800352
X-HE-Meta: U2FsdGVkX1/3MZLjIjnfbTkQ3BKBmUfVfsR0IP17QAgjnZnXU8p7ztrKK7sN40h0opl9SBznorFuDthP8akouZB46Y7q2tSJBDEY8HCc1oyCb0dJDVWlH7gsW2v6osrAK4aABBX0AXv2FkZWQ/jKUeFns4vAF54B1uvNzHHZp3LJucBx5SoOKuwRxMxDkMzcja5oyM+p2uhQchqeFkNBdVE1nasw6DHTw66ZXCVVb7tLMYJJwJEl4UQb21VUiMP4w+Trsr+GiuCWKfxIZfsoVLC9+rCT4ziKErqMOfRFIFujOiTajJ5TB0Mdmfj2zsmo76bLxfa6E3vBvbmniR6OnymbWxcuRfQiA0HQUL6vuLFq0nJotqtiHKyWXcGbn8mreiYiociqi/fCl/qfcRuw6A6YY3cXMk+mo2ENeeTnE9IK0qJRwA3aTMqCdboTNvuCbTodWb2UZhutYOxmvEbdNj9rFHLETHrzjMOgC5C/VpFrLxPkCjpgets+vqnAnH31B4PAGgU/JeMuHW/MmJy+OmJnYDfQXVFQ7XoiKfoB0Pkgv4+pgbMKfWtdC3orGosiRuvFNLr+X1agwSX4mnl5ockCWpwcZ5nR2v/heECOPgZfPmRhjZlhhYsxmwqgCCKH0sqQqgmD098xy8D0WT0dS0sP/wnh/TOv23AWqNSVzzxckG93ly7wczcKr2BNAigjUreH1Xawq7PN0BkSxkiVWvne0b+HTk7/dqE237ypmkiNR0cTC4RagpoHueFnFtTwsjZ9PZFEUwg0Y9AMeLwsUwzlunDA3tSxBZHq2qh9GOKJFtXtBUfqARoTBMEK/H9x5CInjkVlq/V9rXvyBw/ZjwR2/lEWP5gxQkSC2wBTBcRoyG1Qm9X30m63nqbEvgwQS1M7stHmxEcWvkxB86cvZEzmqrKjTrRYSkBVcQPhNMoy7pwc7xL4AB4Vym3+cW2If5hD1wWqZ3hhcREN/Gv
 fjpGdmI9
 eGh51lXSR+wIDYpJZvoR3K57g7MYeaXcMPlFBjGXhbm74LhJwYBYGqsDZYP7FGvNeunD1IVLlgw0Q4TR3I12IMlbS4NAsYBf8iIW+JlCqoW5iXxnTzLlTYLaIcTox/Y5knjU7aDoxOyGp7IqbmqyrbKfoR0IDVeDpsYM1GlWRP7eGgbzVFfbs7tR2rj29Umbpg4/K9EqrpciM2nSRE65t3OTyv3P1jCcAUjAStHP90OhyuDVXPVsN29M/isWaD8lMdC0rORS6nDm4MTuMrQ2q/bawt9k/kJvSAocCMJRTdh4Pweds2PcYWuSqw4gUdSPisWNXpoHe68cHu2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 08:51:42AM -0800, Usama Arif wrote:
> crashkernel=size,cma reserves a separate CMA pool. On systems that
> already reserve several gigabytes with hugetlb_cma= (which is common in
> the Meta fleet), the crash kernel cannot use that existing memory as
> part of its working set. With hugetlb_cma=6G, requesting another 2G
> with crashkernel=2G,cma brings the total CMA reservation to 8G, none of
> which can serve unmovable kernel allocations.
> 
> Use existing HugeTLB CMA memory first for crashkernel=size,cma and
> reserve dedicated CMA areas only for the remainder. With hugetlb_cma=6G,
> a 2G request reuses 2G without reserving more CMA. With hugetlb_cma=2G,
> a 4G request reuses 2G and reserves another 2G.
> 
> The full HugeTLB CMA pool remains available to HugeTLB and movable
> allocations during normal operation. After a crash, the capture kernel
> can use the selected ranges as working memory. The conventional
> reservation is still required to hold the kernel image and initrd.
> 
> The ,cma option already opts into excluding userspace memory from the
> vmcore. This includes allocated HugeTLB pages in the selected ranges,
> which the capture kernel can overwrite. The existing dump completeness
> and pending DMA risks apply to these ranges as well.
> 
> Have architecture code record the requested CMA size and perform the
> reservation in mm_core_init_early(), immediately after
> hugetlb_cma_reserve(). The HugeTLB CMA areas are then available for reuse
> while memblock can still reserve any remainder.
> 
> Use the existing four range slots for both reused and dedicated memory.
> Limit reused memory to the page-aligned request, account for dedicated
> CMA alignment, and report any shortfall. Ignore malformed optional sizes
> and reject requests that would overflow page rounding.
> 
> Suggested-by: Breno Leitao <leitao@debian.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

> ---
> v1 -> v2:
> - Use existing HugeTLB CMA memory first for crashkernel=size,cma and
>   reserve dedicated CMA areas only for the remainder. (Kiryl)

Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

