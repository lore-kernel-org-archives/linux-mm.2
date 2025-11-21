Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F73CFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A435C6B0026; Fri, 21 Nov 2025 11:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B876B0027; Fri, 21 Nov 2025 11:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930766B0029; Fri, 21 Nov 2025 11:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDF26B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:24:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AB54C033D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:24:29 +0000 (UTC)
X-FDA: 84135137058.14.E74587A
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf01.hostedemail.com (Postfix) with ESMTP id 63FF040014
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:24:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=iVYxelnp;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U vzaBNS";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf01.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.149 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763742267; a=rsa-sha256;
	cv=none;
	b=PoSoOmod7D/jjaxXX2pyAJ6N1fn9SkovD1l6ycBd+WtzkDzi1kEhcbVnTSf1Dp7nbK6D+t
	LrSV9X4SrnDADbepESCMEswXcw6qejoUkEO5v2DuPKhfr7ZyEtlgXN1JHHXixWQSq5yT6C
	MDZL6OY7JYG0tIOe/Q8566nB6WZa4NY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=iVYxelnp;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U vzaBNS";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf01.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.149 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763742267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9sPmO9ctPmEofVcJL2ve0sLdAoEmPz/dsTzOswFhgc=;
	b=WC1sNs2nKxkji1zABGhTTVoDdeS34h+TNFYbmJ8ntbtSltSCM/ezPYCqC57y+UVh9lpvY0
	u4MJTXqUzIlfCv0W6R17dIwdYrUu6BMmO7ZsEWcv0gvZI7gaT23mpMzJhKo6i7qfsNuwTq
	M2evkvk8r58Ke0aOv6vyZW6RYaasTNw=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id A04FF1D00156;
	Fri, 21 Nov 2025 11:24:25 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 21 Nov 2025 11:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763742265;
	 x=1763828665; bh=y9sPmO9ctPmEofVcJL2ve0sLdAoEmPz/dsTzOswFhgc=; b=
	iVYxelnp6m8nPDJCJD3pghiuY0JnfpXoWiKDtyC1ZfTMF8fUQtXTaMX5yXfbLont
	ST9OiZCOgXI8ULRFc6aFOTV/tf4SKt4W5wcQbP9AJZVnFKNBeKTXaQz1YXBFdesO
	ngWnz2nFnL1qztTi6xyP0b4aSzvPm+uN9ak+bIptT2djVNAQLdqCmwibU9kE5Aby
	VpAiSzJm+BAVU4pwbqnka0BeOqzyT0bMUyCvk7dAaYRepF8yb8plimv6meD7DiWX
	p8wl94vOATtCxVWlASjaMB/2zpgiQXfFwIjaAR+tnZBqkJApVj4qwHk4EVRiCEnp
	1g+zDY1l5gB38/tTHqvG8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763742265; x=
	1763828665; bh=y9sPmO9ctPmEofVcJL2ve0sLdAoEmPz/dsTzOswFhgc=; b=U
	vzaBNSi3AV9eHP0xV5OI+fIMqpbdDdLZSjxGvsQ1T9RKmeLAwjextymi2cVXU8uy
	Be6PO+J6KI0iovHc0UiFA8B7rQiJTAIxOd4DhBWcsamEOEW5kjFnqKsB7FIrhxeQ
	GuiIAMeDF55zh/ogS1yglOFCO/9flUPn1HBDtkEepyUIH7oJ3GvW0fdgq2cG3HNt
	Rreb7R/CH8xTdpLKWo0BA9gScPfpMk/xxjgIGSyYgTlnJbiy/QOWhAmLxQpYZ6V3
	7/Vl+Dl5oQsAGlnSZbuDQqBdTTIF2o/fTw+PlG/91H2n4QIdikT7RS5D+uM/ue4F
	NdHheTOKT/rjN+6DYqXNw==
X-ME-Sender: <xms:N5IgaVaQZaAe5t79XnH1rbSJrYlQplMMYdp0M6-Mr3uWvt823MEJDQ>
    <xme:N5IgaSsBncHkvTAX8k6pT0FvMeuYcjAGM09pjfPKAWMwiWFbRzWYD5L220C8E6Pk7
    g55i_BbOAKRyF9cw6sEpexN2O8LimadQjIefkoeLiQUv98iWdUI>
X-ME-Received: <xmr:N5Igad-WFs5Ve-cFz6F4xXvv1f14eMC6yGbsbN7RyWZyEu__tXqKIFcs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedtgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefhedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:N5IgaQ84u-HHIf2TcQNYp-qQlqRMCjkmlLokOX6AO2UGzSJhrElRBA>
    <xmx:OJIgaXPtSD_NpuOHdtKoNjoojGX18VUQEBCkvknI_2nnhJz5NPrx0g>
    <xmx:OJIgacOkV7PC26nL5WPRH0i6onKjj8iCzVuttmRsX2N7uBq0h1DUmQ>
    <xmx:OJIgaVMFYRWTlkUhXAgJS6FxtMLkh8eI-ToaCrmBZCSefA8L7jXnYw>
    <xmx:OZIgaTGK97vls5JNSW_jGH-7CSY683IBHOHRkaC1YrXeI4xtr5m3V3e5>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 11:24:20 -0500 (EST)
Date: Fri, 21 Nov 2025 09:24:17 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v9 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251121092417.7a6eaa2f.alex@shazbot.org>
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63FF040014
X-Stat-Signature: nj3kcwtph8uhda1rnzpjsr9s3z6pxug4
X-HE-Tag: 1763742267-376014
X-HE-Meta: U2FsdGVkX19wuLGFeTisKgLLN4LJ9siZhtev7EOBvykMz365ChVTBmodi9i+Wr9jZxBVLpMvND+NizVGFXP5i6j/QGiHsEtcqP24l16M4vYHmtEjNIZZorBwYGyoI1SJv4GdiiXwt1pnmKhMxWGCy6pBTSG0lVbsbSs2nsP6gGlAqjmev2xgR7uL5w7hHv8ljjM/CuWCAV9aF24MtJFn8ze+w5ptrZVHYPqEfZTyVMF/8PdF9VhavjbVuUcd5xR+nVZ9yQ3/buYrxw9M1A51xgFylAHjxhk5DDaWOFT5v9c/qHQHfbh4X8epqnhv9ZFJxcYMQYBD/0teYW+g0tVwu/z24c5bk2ymz11oHOxFB+f0BbwWJJmAVAmXIEdX0DV4+k60iQ31XV7CkIVM1YuDKCR9LKx9/fJiei7DLRUQ9Zqtw68tce5ffrPC1GiLSX0yfLhRoB25kMslJH8mUVrFI0qf0RRvH+gBg4SmqFkqnHwVPp4lEMDXD2C9lay8R0Mz/lmSu2xXtl2DxNbEQReCJOy979KyGGjjvdCI72nwUBYK6MukIX8WiUOuqxaZTnXeQzXCKxyCp+w1tG6qGbVVIXnsTK9j4E+OMune63ACMzC27k4DH35qyGnLTHTpyVCj4ukJwG/D0b3AzyyrXxLJaQq4BR3KmGWQe2UD6er3iup+NjwU6knsf51FG7z4YOL+nhRXosEJRiO4MKSTg6e9T7/7Y/yp6OcEd1wvg9ffr0KR6qipso9J6tSE6oIaPmb+3Q+U8lllXKuIlwdLuYimKl47pZIkX1CF2qBol/+Zm8u83nrFPHmLd+EREUTTYHFLV2/9tZaLG2D+xU5Q43KUhHMhYWjDEzoZ9ngCvssEp8VrDKLWAysJCd90j8mYwAHIMeHTU3WGGCgdgPazo+syDvvyZSPSnQTF9/qkSdvgaapdrEtRBN4Rv0rrSMEy1FtDdFIMfqUyM8eMzuVr11H
 ASii2UjO
 8NIi+cOzauzzEPfgWe5/fWjDWnkl+HwItyXachMR1WndNd+G62Y3STN002A5QTpYBualZrbJDNpy4TkBVm7ZdNBvDfW6pck82F11vMtn3vQ+JJ96hohd5kp6YJ3r4g60hTnF7uJK5ySnAVeheTGme5NiXoLcrAwHpbkfrsPmfDv8HtyoBAeEqumQEatVv1S79rM1zS/u+kZR47ahy4M4R4TMJVdxpA8Qt10NDly5xIvqNG0nmw81FpqhwLEwio76e+iphswuutegDqu4jqJhBMtv02hYyuJXKKACO5RH4jd/A45c0Tk4HLAhaSwWALuFOTwH3Ob2ubZALFPUO+JDo6Bc6kVIZlyXuMTdPmaAhS9EWxvaRy4oyPCRIPfCCNdUTzwH+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 11:28:19 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> Changelog:
> v9:
>  * Added Reviewed-by tags.
>  * Fixes to p2pdma documentation.
>  * Renamed dma_buf_map and unmap.
>  * Moved them to separate file.
>  * Used nvgrace_gpu_memregion() function instead of open-coded variant.
>  * Paired get_file_active() with fput().

Applied to vfio next branch with the fixes discussed for v6.19.  I also
pushed a tag, vfio-v6.19-dma-buf-v9+, for this work.  Thanks,

Alex

