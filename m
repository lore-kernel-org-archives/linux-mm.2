Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751DBCF8550
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6606B000E; Thu, 20 Nov 2025 02:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE956B0010; Thu, 20 Nov 2025 02:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4056B0026; Thu, 20 Nov 2025 02:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D04A6B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:38:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED574160774
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:38:17 +0000 (UTC)
X-FDA: 84130182234.05.8A434C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 570251C0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:38:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fk1GOwXX;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763624296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0G1Ae5IK+maf2+uXJx03bPDhMdkXz93wlmlod2j8AhQ=;
	b=CYFNrUplWv3ApN4mdRtMSABIv5MuvlSb/isngAaJlCaLTPhZe77nUkRYI6XSF1tOMZ2LXK
	il28evNuxggEPA0h+O4CCEEiH/pWLXqsYqGik6dxpjYcvKNaFAwnz3D6E/aP2hlb+uga6N
	CR8hmCeCOuT9siuzGfQJyKy3hYndlbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763624296; a=rsa-sha256;
	cv=none;
	b=aOJp784nM741ZNGDeQeuMYl/UmnJUdAHD/7A/zCVVpQ8l1ztxR8IPewt8eQEh4Pf5U/tkd
	U4mK9epINgi8GTO5q3uaus4ooPIV+ukTtAwWvmIUNGsQ8loa0zNFRNb0o9BFie5rpC9Dcd
	fkI6Xnzo/No0oa/SDV5tIDPGjXegRxA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fk1GOwXX;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32E2D6014A;
	Thu, 20 Nov 2025 07:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2CDC4CEF1;
	Thu, 20 Nov 2025 07:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763624294;
	bh=TBmcKl0VoEim/6SAhgGNXn7s3ldHbwABAdg4lb6XQUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fk1GOwXX+8I2wrjVFUFCs8eOHzSYMIpbSRNsybaaYnqmR1hvk8o1qyzeHekcACEa7
	 0yEVvvcB58TVkvjvuQ+g/DQOgZnEaPJs34D8Vdf/e9Zwg/WSSr8nANTFzZTxu1EY4w
	 f+G77YPyofCyVfOqnqhJ1EEumdeOwl1cYYCiSj7kjTatwWqUljRJ6vu6RxqRHEAEU8
	 HRAo+V91htNpmPP70IHNTW6yrAz7B8PMq5q1hNDWdzinzbtY3bxLpPYfEP2VVI+Xgm
	 NiTNPnC07XH/GYQn22i+8qeLjGe/j0I0H3GmLnYmVwrnbgDp8dKA8f5MMMocC3fZuC
	 Xf3HRBvJIpyCw==
Date: Thu, 20 Nov 2025 09:38:10 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251120073810.GQ18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
 <20251119145007.GJ18335@unreal>
 <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>
 <20251119163326.GL18335@unreal>
 <3053398d-94d8-42fa-aedc-927746375521@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3053398d-94d8-42fa-aedc-927746375521@amd.com>
X-Stat-Signature: c4aeekiabwjq3cr8dqmi9sfhxat1axno
X-Rspam-User: 
X-Rspamd-Queue-Id: 570251C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763624296-200887
X-HE-Meta: U2FsdGVkX19V4fq6t8VqRpU1FpNwvPM5Cow/5yQfqXXLIk1vxBdMqUIvUkSl0D1tgv5ZbjxXmUnA7ZTeaFZR0lfeAV1DtDjtS7GQSl2Aoe4h5z5zCGWRCTYQu21vBHmpz9h9lYd1LFlKH6/qNhxft60+hLn3b0Rq5TfDnICHqpfMSFB8pL1XGKEpnvFFjGNHe2GuZMBja7YTZrzWNf8h0WdbhwvAUvGtdF6bFUHC8k4ThyhRkYvk1H8f9e6gK1EykxroEMZJ5c8ic9kSiaea/UZ7RqPbwTD2DNP3SslxOQ+bC6X2xHzhbcWYloIoRUSN3PJ4AGgHF5J3W4mt52W/X4c9x0whmHKZOPGmTGIVyjacssxNinjfeHzOlOJphgczHcdEbhRuPogqHp//WlQXe0L1AvDKunAOHFJCDHBMKXetKVW6d23TqHPijqdey/23oxs7I5WJKKD6gIeJZBIxXljQabDL8Hzk2nD+GLlWDX0u9Mer+qbAka8PVbpdZrT2oM3zJFVWmRIKcF9X7pWKOpf9lEOzsgz/ELkhHTPrVaTFG18a8mm6OaPWOVGV+nZEWd1zwp/eu0fSCoj6WAUPQpGwPcieWkXskB3FjAaPcKpzGULc0KW0NrRICl6Io10wEIay7e6vLVR47EoQCduAxZZW4kgeq840BhhMlZVwM5QpdPOyCCvbPjwS3NhkMNLu+T5fYEa+9M86eol3WKql0G1bV6L9uIGw82pNtJWUGHfWJDsSvvqAj4bTV7E93PE0MbcWx+fk/Zp6viw7cG6MndKSqx3ee3CL5A1H2JzHkN1zczF8nF321M1DQbsh9GDi2WytCZsz5BsL7F/murUpcOxdyO01QqJS2Yu/S21yvjrJEmvzUZFYXTzCjblsNcxD89V81GQrNSsV+xn2gQDZikKRslkHfgV+VmFbEBPZ6/cFMtfpNHTY4QrF1sbhSnN4iIhJUVsBLohcetW7J33
 TxyN2++q
 g40jDZoQpHAlGtXCqA6afdpYUY48FrZ+Mn9sagcfH5K2qkh67amihTfYwXjekhFKzmk9fIdhLL0ZBs0w1bGlU1Ztwv8oAK9biXoQZrXL7IQBA6GZuKw0eqEnYn07/MmKBjxQeSqN/QGJ4Xwsaj59wJId3LtHFRGRFnSgAY/yl6/8oe8XlBtWdcSXBAyYc+S278cm0By5p5LMLVBw/e0xAeXiQqSzacw567mBJIgOt62aeenQ+X2Szikgi9shY5XTS+qpxIX2ns/thf9cuyUXxEuG1eVrVLy5UqhJTtX7notdXMW5Vpq6g514ymp6XzIeJZj9qKGpb6wCz4k3GSPzO+7eO/m+msyRyWQKDdvK0oLylX39f00RI0WYZIuWlhq0tfX9CRfrWV4V/06fZKtDZ7o3W2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:03:09AM +0100, Christian König wrote:
> On 11/19/25 17:33, Leon Romanovsky wrote:
> > On Wed, Nov 19, 2025 at 03:53:30PM +0100, Christian König wrote:
> > 
> > <...>
> > 
> >>>>>>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>>>>>
> >>>>>> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> >>>>>
> >>>>> This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
> >>>>
> >>>> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.
> >>>
> >>> Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
> >>> file per-your request.
> >>
> >> No, just completely drop the term "mapping" here. This is about phys_vector to sg_table conversion and nothing else.
> > 
> > In order to progress, I renamed these functions to be
> > dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt(), and put everything in dma_buf_mapping.c file.
> 
> Yeah, the problem is I even thought more about it and came to the conclusion that this is still not sufficient for an rb or an Ack-by.
> 
> A core concept of DMA-buf is that the exporter takes care of all the mappings and not the framework.
> 
> Calling pci_p2pdma_bus_addr_map(), dma_map_phys() or dma_map_phys() from DMA-buf code is extremely questionable.
> 
> That should really be inside VFIO and not DMA-buf code, so to move forward I strongly suggest to either move that into VFIO or the DMA API directly.

We got the request to move to DMABUF and agreement a long time ago, in v5.
https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks
> 

