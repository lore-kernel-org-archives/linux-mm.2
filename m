Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2737AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50156B00A6; Wed, 30 Jul 2025 05:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B261A6B00A7; Wed, 30 Jul 2025 05:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63256B00A8; Wed, 30 Jul 2025 05:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97B6C6B00A6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:32:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19DAC140333
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:32:24 +0000 (UTC)
X-FDA: 83720415408.16.B136E11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FC8220016
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:32:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=re3qBfXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753867942; a=rsa-sha256;
	cv=none;
	b=M5AGO3l4jIzkJcBFlp623PJKb9Vgv7FA1115+IIudsolkwXbdnU+MJdvIP7+B6ole3up6y
	twZC5EGrHOYxvO6CAhUUrdvUcq1R7OoA0uKjBHIo7eQl69G6ALFV8FRmpJP10dP+Td0YHq
	tZ0NBixjfbQDyN85i41pXVInJ8NfzwM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=re3qBfXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fikmEd70FKPaaMcxLrMaJ8SYn/Gv9pNKS/mXcFtd7c0=;
	b=1bdBOhXoiW4IWPtEmppdVkYCzVkZ5NUlW8cLEsTGqapFO7oOa99byJ/W3uM6hWwyRWqZtP
	IBswVja1JK69a5IqNHpbuBeG5DLb5/Cu9Q4w4xuHa5dC0s6q8qJOdKA5ypPac61nlMQUe2
	FQgAGXRUFcbW2N7IQ5sXYSunFBQdtQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CC2445B43;
	Wed, 30 Jul 2025 09:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5ABC4CEE7;
	Wed, 30 Jul 2025 09:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753867941;
	bh=4W4puONHgBcGHwoNV0CY3xma0bboz0RMz11XR/y9JNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=re3qBfXG4XyZtA/RqPxafo444qv+5COTZZvAJcsIAudJvNJ5GRUrGxzmLMht7qn04
	 hwCyO3Hzt2ruEpZEzwjjG5TqM57jCt7NS/wTLq9A4i30flu1luxSTT3gmO7ssNsvS2
	 Lb5pXFUz6XiBnwlYG8HhanlHIjmJFWfrePje/Dln8nbnfZZITOpG3X+Mc4VYGCgMtY
	 LtRFBtuou9BEeShW+H/gLAcqTOk0FFSJQaVIa0Z6ohVZeUE9/L2qylX3UiuRgQ91sw
	 bEWg/OKcbPZyTRB/9hC19ZqDyhbFiEikEPzuwYdJ2SVd4jtrfVeKeJap5nBj7dN4c4
	 1MrJJzfkPtKTQ==
Date: Wed, 30 Jul 2025 12:32:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250730093215.GP402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <8f912671-f1d9-4f73-9c1d-e39938bfc09f@arm.com>
 <20250729201351.GA82395@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729201351.GA82395@nvidia.com>
X-Stat-Signature: spwawsd1eh8rqz1pyqbmbjaceau5yxkw
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FC8220016
X-Rspamd-Server: rspam02
X-HE-Tag: 1753867942-680433
X-HE-Meta: U2FsdGVkX1/8J+fhZRGVJaCBKsTXTg8llAVyNnfVLAEwV6BlVlhuRwYVXbw8iriQ0h8Z2xZ0XGCATPHEClZnueJXazypxpffCZgO3NY7IlBP61Fh0F6R8TTWMCLZxN/uGKAa+t9PUo/agsNtqtji0XmGPhEGMw6nmCZDzEzDGr0tdjmDtWuUjJO/xb+JBdtBoO5+67VigJI9ii9dUPfZbP0hjCrw/DkuVsGtd3GGSEyzxu2ZkcN6zI7tABlri3nTScrXSFQxTUrS86wv65U0Pw5ooh/cEHJc7Mw+YfFBqPndN0agLIdYyhk39CGJe4yarLA4I2tSiG70ExXJC9IHaq8W7XBKKPB8hWXJW0kebeZIFx1YTbYm+a6Qa38bl0oy5fqfyBv4EiKqUSTF/4xkoXvNDb9e9LE1aWpgJcxAGB6yiAqbvF/aaD0rOH9YMLPu2XphOG+HjBZ2p+uGBQjWvASZb6cl7tHIkzmn+FLTpNYiGznpKBJjUmewW9cTAnYwCIUJKXxjpGROYWRpSXC2J6io2NHhD2cX282+7FRcwYyvc3o4GK2/pOJlE0Kst7+ED9tpyfKoOyh49Q7Sdnl50dtoq6GUtQoPkKtO728rICOQGyG7mpUELncQBZt77mfj9Pr7LDI1YjbK3KP729OvpfAfdDTjXuP7qqamX7f2U++XZxUvTlctYPaT/zAqUZaw9CoXcTtU9q8rZjbHlaIdva1HWmVQYpL06lZjjfGv/jHpf3kwQKTak7f2Nu/6zwJhcSEKd7PpW2X7J5Gysf2TMzXdFOxeI+zd8sPSRhEeK9g2z2oG5Gdqhyyc2+EAGeQDQlI066zhP6yb7TiEX8oKpqUnn86YZdQ07MaEMF+WW5r9fzHS8ZfMUUrxwnt202kAj2cM9oSpby3fuPHu6DxlHn8fK+3Xc0q4yKj4CIkCau6MpjA+u4y9fGBA7nq6+kWosf23udrdSH0JZcnZe1m
 z6wyAs4K
 IG/C1CZT9d91eJOQQ5V64KnoRkkUDG1OFMBoXxDdF11LCzP6MhVST9cAehio2svnFh+0aETsHn0y/6aegP+0a7zTJSvZsBhGuSbFgUa0gT0Y+ExnC1faryEMbyXEXOpazKkACQRhwguccE15VzY3zB28zywhzkldGPm9Mxj7TvGXW81v0CeiYUUMV2yxqCYtLQgrUchiGFKvZ4WT/UMBawtiGdFIOZRziTZJJPZHZuigBKNAtBSIudANajP+RkIgZQm+M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 05:13:51PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 29, 2025 at 08:44:21PM +0100, Robin Murphy wrote:
> 
> > In this case with just one single
> > contiguous mapping, it is clearly objectively worse to have to bounce in and
> > out of the IOMMU layer 3 separate times and store a dma_map_state,
> 
> The non-contiguous mappings are comming back, it was in earlier drafts
> of this. Regardless, the point is to show how to use the general API
> that we would want to bring into the DRM drivers that don't have
> contiguity even though VFIO is a bit special.

Yes, we will see comeback of DMA ranges in v2.

Thanks

