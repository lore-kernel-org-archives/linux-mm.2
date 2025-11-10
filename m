Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F82CD1297
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E570F8E0005; Mon, 10 Nov 2025 15:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F698E0002; Mon, 10 Nov 2025 15:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44248E0005; Mon, 10 Nov 2025 15:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C39158E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:42:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50C521A02AA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:42:27 +0000 (UTC)
X-FDA: 84095870334.18.FC5AA25
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E882C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:42:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=htuAqLZ4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 1pcFNt";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf22.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762807345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqeX2If3HYh30yCslpotpD1eSH8ukdg4bxJbH47uciI=;
	b=FCJJccNFF80wq+W0lQM9COZ4/ODTFNmmHHIE+kWfbYeYQo70fEtSTdh+KtarF/uZD7Juum
	8t6JCYLekAy3zElQiLjmKRD9ZbJRfsCH14Uig0RET5lDorAk3QflsciJD4ZBz0JFhet6AC
	KtIkqakmWxsPO//JuCA1VSC17A+hE1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762807345; a=rsa-sha256;
	cv=none;
	b=wp/+l8CC6MwkgmB0U1MuFEWD3mCYyMy2/9ulHZHA1tn2UvGx11Vw/cp/as85MYeeMljD1Q
	SAzOrLxjIt+WunNBLnK2aWwzWI7CCf4w1wyFL3LG5EVC/PDtKbreNZ+AN9dZP2cVvXdpwa
	MhhonMGkh+f+hXuucx96LNdIeWFG5Ww=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=htuAqLZ4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 1pcFNt";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf22.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id C4D701D000F8;
	Mon, 10 Nov 2025 15:42:23 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 10 Nov 2025 15:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762807343;
	 x=1762893743; bh=gqeX2If3HYh30yCslpotpD1eSH8ukdg4bxJbH47uciI=; b=
	htuAqLZ4SouJYoITuzsRhJjEXMvYg51jdhYpfuNbonoAiCijob/69evbidTgy+sh
	iRd/focxifhKHG29GSovKjpd+ZahK1KX4u/ZS5xwu1cwXqVC/UCcfTwYH5JPDv12
	hGHLp/nV+WavmCJRl9wTrZikJq0k+REA/xuHpzuBgd81DF7sIwQG9Nn6LXDccuBp
	Kcbv2MQHhh0bNcI9y7090F/H/ONHQBQn0M3YoNGcqHaUJhgJYpUOx9LyevwJdnFy
	Ict245DxpPf6jiaMEQZaHVfubTy/2FN5JOeKQcWBk3z0YAlBC9LITZ62vdXk1Y/c
	Rd49/UzrTC9Hg0y+GBi9Hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762807343; x=
	1762893743; bh=gqeX2If3HYh30yCslpotpD1eSH8ukdg4bxJbH47uciI=; b=W
	1pcFNtXWP9fMq2c7Go8PGx8HwIWpuPF2lBF5s8fzNuWqlubpSf71I4RGXc/+pwcE
	wq+IM4acQDpUfJS8lOK336Hg+6Yhp/JfxC5SEFBEOLYskuuF1zMvdgewgnWx52X/
	fNOBJyzaAv96LswEo/scIGTSRxWJi2ZUU5XAvFuOshhDJGBo38Xa+K5zj1omajl4
	9Nzw2IiBoN/XHZmZW4L1O2XuQ5m2ygcV/Ej73MJG4tl8Yp+XoKJ+BgkgvopLu2GH
	obrv7xcViS0KT+tbc+wUE4u16+09BsabKp6VUrTPLyomAqmaiXC7s3Fr/VvCaEMh
	I3yt1TVyxJAxtgG24ZoJw==
X-ME-Sender: <xms:Lk4SadPf7Z_61ugy1UZG-S0z50mLGWjkeWFW-KUtptz0WE1qSwYswA>
    <xme:Lk4SaWQnTbNosFeU6S8-IkOOxvD-vMp6PSlA7UVcS1gFInm63zNeLDUnY47L26hp1
    UJx5XZp5pVS_p1iGPb8C2-PW03MLsP60V0ld5GGp6ghlpo8mHKR>
X-ME-Received: <xmr:Lk4SaSQT-qKgrv4djpFBdctnnMfQHHqqcvgPYrMcvkpGGEF5Ve9ebvTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleelfedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Lk4SaXAf2U3xTIUQxs8i0IsnHoTy1Jl7o0BH0TlVy7zhF4WWB901JA>
    <xmx:Lk4SacCXUZGgOPwzyeCst1KYlCMu_DTngssMm-yanfi8GAiSreZfOA>
    <xmx:Lk4SaYxVBS9qwrWpCA566IQDcrCbii10ahjD77GRLJBh3SrN6LWZAw>
    <xmx:Lk4SaejgdRKg7EjLQE1Gk-cfpzoWXZw-pFjsodEgU8MMWqFzLPeaiQ>
    <xmx:L04SaZr36QwMGCQIKH-kIOIQH3332nOSuBo78ltSYdTNpyhWUvhiqLCC>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 15:42:19 -0500 (EST)
Date: Mon, 10 Nov 2025 13:42:18 -0700
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
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251110134218.5e399b0f.alex@shazbot.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n8uax3jpfetq4txxhi9kp3q7zoujpccp
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E882C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762807345-274693
X-HE-Meta: U2FsdGVkX187A0T+jhO/qCtAPfpD25iIUA9WZGYrg4fMmq2NrkQiQtGnFktJj7nSoKfSsRXxtLaE84R+oplSXN2Gck3/v8Sn8T5GZl6ZI5RXIEAKYH6jNt1brS3/IQ1mIjIhvpSVrK03UwUXpx9fOsNr9MyiwRaE7GJfFB5X9TzkIM4jFYX2SG6WK4x+bn2Tm0P8wKHodke0/rpfzicSjkI6hOfgKQUywMXGTFYl1Icur9nnthd8DHS5JaKJZ4HtDf/p7+K1h3N4GRECXl+VO+UBYLwk+iV5MeyXNkST4/jWzP+93nWnReh47ZXDY3ysndi1gbtnFo2zMMUmO8tGzdNSPL9AxEf2gfzG3D5w1veIs49I9+X+WcRsxsXrE3lD3lY1snDnY2iHJXXMo3FbKn37+hccWRIwlKNGvwICTj9/oRqOjvgN0Q75rWOJ/n9bFoSdiGrr5CRcNpknT7Bk1lqsaA7RH1s4o0fuCFCCDqz6D4idlEnJfSqCDNew5gR0tzbVtweJ1lkS2m0kiHP5Z9u3U7i8N4Upd0vjtGY9+0M2OquYifR1CjZ8fhlhJQ+J0LlvHR6mmPzyh19AURZFFYQ0neGut2Hna9nRiZ91FzDZwGd1G/J08krgL8pytgygyTDAEl4lnifAPYqSa9hSfcNgNXtdfRgfy3wi08Bs6LRS8wHKSwAud8frM5aG9IHdVCdUZFcVn9Ny6wacN/ZC/oMGS5WEG1uA3woc7tWgssd1vfi8FuyZDVxr2QvaEO1yZzjvQlhCjj/PFFUXAEtkbQaMGu3vlJZLO4O/Ifs2UOH013KK9bTXkqP6hnzZgAkHvaGNJGOtsVd0yGkb2nslEfoiDdeY7AJ44RhsbJdBeUlPero5umEfefiMxcqzRzRWaU7bfDb4d+5+/ATtfgROZe8nTnjton6DYSVa+ePuLH9AZTPPMbjId6C41s5ZSl69viHa4YohI2QPzBL0xkU
 NlWjbshJ
 mGbTc4XgPWkPjtAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Nov 2025 16:16:45 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> Changelog:
> v7:
>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
>    to reverse loop.
>  * Fixed spelling errors in documentation patch.
>  * Rebased on top of v6.18-rc3.
>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.

I think we're winding down on review comments.  It'd be great to get
p2pdma and dma-buf acks on this series.  Otherwise it's been posted
enough that we'll assume no objections.  Thanks,

Alex

