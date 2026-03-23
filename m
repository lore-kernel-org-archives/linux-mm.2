Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E1FEC01A5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10F06B0088; Mon, 23 Mar 2026 04:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8886B0089; Mon, 23 Mar 2026 04:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE776B008A; Mon, 23 Mar 2026 04:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A302F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:49:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 491CC160A95
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:49:33 +0000 (UTC)
X-FDA: 84576704226.28.D73FC1C
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47BA4180004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:49:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qR20M1T8;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774255771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izD245/HWTfY4YvMavmH0UjvQPvQnie+y+bSLStgLq0=;
	b=11hKIIIFH/qQHMbcXncOQoTL5Yjc3u3xE4quRT477DEJ7SlblfTw8kpra+0QNQI4BjQOex
	Xvf4L7x0mRo9a3rbiJ+LJHblBE9BctkGpEJ7S/6sojykXtyoBZYDQZq+qbpJNDrpYEzLCx
	DfXNyd/8qxAdl2y27ZOZKAn7KASe2N4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774255771; a=rsa-sha256;
	cv=none;
	b=6H6FtLXzU5IhXhBf4Ys7+dZ4F2tA4JkIxI05x8xbmfJQ+iYyRUOHOJDoiRPFv+AQ0OWDEP
	MCi2XWptjMXhSZi6bXyXVSI5NIKb1yF6nwnKuPLKwg20ysh/UGO/Ny7/tJtcZ9kH1c+VC1
	pW1XC6dqSTjriSm6dgkvParlDV11zVY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qR20M1T8;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260323084927euoutp02741697b9873d78530075a5e111d0c62e~fbDhQX7Vx2817128171euoutp02Q;
	Mon, 23 Mar 2026 08:49:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260323084927euoutp02741697b9873d78530075a5e111d0c62e~fbDhQX7Vx2817128171euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774255767;
	bh=izD245/HWTfY4YvMavmH0UjvQPvQnie+y+bSLStgLq0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=qR20M1T8vm/bninpWfYJUqD2cujoDpUOWwbtW5EzAYPKXXW/reNN8Na0Z0P22N5Fq
	 KD9VJ2HiMGpMBAqMkrXfK9sxLV95K7db3i4rPSoQsvdHzljE+ooz9t4d3X72LfLXNP
	 8uUHazdKV/PWg9ZWyVALYMO1f3Gp3Q87CRMB/Hm0=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260323084927eucas1p12614d2febd7dd400e32c691c74e396e2~fbDhDI1aS1911919119eucas1p1N;
	Mon, 23 Mar 2026 08:49:27 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323084923eusmtip200157d20bd875804c9aaff92db3a8414~fbDd8kVqg2543925439eusmtip2B;
	Mon, 23 Mar 2026 08:49:23 +0000 (GMT)
Message-ID: <1c4e429b-f30c-42a9-8de1-71cb2cbbc114@samsung.com>
Date: Mon, 23 Mar 2026 09:49:22 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Miguel Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Danilo Krummrich <dakr@kernel.org>, Abdiel Janulgue
	<abdiel.janulgue@gmail.com>, Daniel Almeida <daniel.almeida@collabora.com>,
	Andreas Hindborg <a.hindborg@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: iommu@lists.linux.dev, driver-core@lists.linux.dev, acourbot@nvidia.com,
	akpm@linux-foundation.org, aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, david@davidgow.net, gary@garyguo.net,
	johannes@sipsolutions.net, justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev,
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com,
	morbo@google.com, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260322194616.89847-1-ojeda@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260323084927eucas1p12614d2febd7dd400e32c691c74e396e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260322194701eucas1p1f72625f53e50806fa4f430550f291e76
X-EPHeader: CA
X-CMS-RootMailID: 20260322194701eucas1p1f72625f53e50806fa4f430550f291e76
References: <20260322192159.88138-1-ojeda@kernel.org>
	<CGME20260322194701eucas1p1f72625f53e50806fa4f430550f291e76@eucas1p1.samsung.com>
	<20260322194616.89847-1-ojeda@kernel.org>
X-Stat-Signature: pao3iirndepqg8dm6m7jsy8113dj66dh
X-Rspam-User: 
X-Rspamd-Queue-Id: 47BA4180004
X-Rspamd-Server: rspam12
X-HE-Tag: 1774255770-780222
X-HE-Meta: U2FsdGVkX1/TW2kfwxRRftExPfDubDmvyBonPX8J3jE1Kr/B1g7F8QpnB/Xo31TR5xcWE5zHN54VbgM9ZEb27ahDou2gBklN8/U6PF11SuzMmXiBG3E1NZho9fb8QrzYNvJyo6zaTv8wPVtV5e4N7WD5VbMImxHqIh7x82EKwCroKoQZwcZyZAj+V146wvkHgsLUTlfufhiU1Eq1wEVV0BIhCUilQd7hqeBBfq/f8zkJqJjzkDcDwUfyjIFfXmj81ITjuOCLxSVo5dmXQPyCEHJXjGCErXpHCRWbMlaYkJomCosWRFdQLM07Ib/BDW2jfmWjgQYL0A//rZ/unH26jBgwQozuuDTjB+lMX0xXkGj+A0JllkqzptkU7xLgwSTaHjkxTpknTF23S8+ioiA4lZRTBP0KWfxouLQ7HOal+S3GQMNkDf5fBvHzyGvRSDpz8TDf6p98eMC4lwn51MNLp8Ba63IpypARbpQcVVeJb608GYvcK+Kkb/NJNDPxhilZA9A6l4biV4nEbjSMNKff4xVIkStyDX4VYHraBuoC1/Url2lLuvSYW0Y2iRqRmd0jLk1/rPJYeGsDsGiHyQvWxRKpMDH7g6WWmmKC3UTXDpySPDjLyZEubwOknVMoBpFztXuSOpT3mGPKLan/3rtP2QEM1j/VYPhZ5P+tg4Bga1kn+bx/GxIsbNOX5nowfeG2Q8LpuyMEPv72hIMAISqhLsFqlQt9bqo+mbgXW07OKN0VLIxxPavDfTeyQjVMjOyq22/mLG66l3UzaJLVb0UUiJyZC6fk9Rjfnky0QnpJqQ0/bv0kXSref4+cHaCGnE+2CH80wlNTK1ckoynYsCjynjQrLYFfTW3m5Te5zGNig/lSbkPg3+eE1R/RHNO3ulEshxtFFnNqr+sYt8lHmyx/7jDyoD1mlJw17stdCRzSgahD0sz7CdFSHjyd/75fI4FEwuC29CDkzdLyZIwzkKj
 lrcmOPXf
 pCsHRZ9DT/X6iGYtFYEKed0IkcZyFD4hvNIuQRj+xYUv2+ICoEleoyfwd8qBNLipBpQ9p3pcEFuGNVWpEjyCbFzFCUGKQEz1X8YD8pKmO9BURtHyjasZSPqBuQ6M/qtijPpKVxFZIdAym+Dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.03.2026 20:46, Miguel Ojeda wrote:
> On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>> I will reply to a couple other bindings in separate emails to avoid
>> spamming people too much.
> Under UML, I got `-Wstatic-in-inline` for `dma_free_attrs`:
>
>        BINDGEN rust/bindings/bindings_generated.rs - due to target missing
>      In file included from rust/helpers/helpers.c:59:
>      rust/helpers/dma.c:17:2: warning: static function 'dma_free_attrs' is used in an inline function with external linkage [-Wstatic-in-inline]
>         17 |         dma_free_attrs(dev, size, cpu_addr, dma_handle, attrs);
>            |         ^
>      rust/helpers/dma.c:12:1: note: use 'static' to give inline function 'rust_helper_dma_free_attrs' internal linkage
>         12 | __rust_helper void rust_helper_dma_free_attrs(struct device *dev, size_t size,
>            | ^
>            | static
>
> For some reason, `dma_free_attrs` is not marked `inline` in
> `include/linux/dma-mapping.h` to begin with, unlike the rest.
>
> Unless I am missing something and there is a reason for that, it looks
> like it has just been missing since it was added in commit ed6ccf10f24b
> ("dma-mapping: properly stub out the DMA API for !CONFIG_HAS_DMA").
>
> Do you want a patch?

Yes please, this looks like an oversight.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


