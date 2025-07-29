Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B36C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EA76B0093; Tue, 29 Jul 2025 04:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76596B0096; Tue, 29 Jul 2025 04:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C4A6B009A; Tue, 29 Jul 2025 04:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9698A6B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:53:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06F4A160551
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:53:44 +0000 (UTC)
X-FDA: 83716689168.12.FE0A103
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 61B951C000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:53:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FY4CeHlP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753779222; a=rsa-sha256;
	cv=none;
	b=zHimXkxXgs7PHYlkyXRmpghywTqmMkvdYfbx/ip97FmASrlJiCm6/2WuanzOQYbeXPupDF
	bwWw+tH74enjWU6ynPLjenZZ4x6FyBeWKB4N35BDtWb+MOYhWGtroXx6EDAn9KYDSNENKi
	FDRcHVVw9dxi1qWCt8XLpoIlV+epKY4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FY4CeHlP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753779222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWLCME8JfNHYwjRCr5W5S8Xu6YQ9hEyHd3yfFbiWrQQ=;
	b=XiNXWw3w3S02bi0qvwoauDEs4b7UYejkcJsPM7Zcq7mlbf3ThxRGGIBkABjX/JxLyj2QSk
	eQF4rzd6iYxgtU8Huo4mN9wwnTgTotPObT8DX1CvgkBkOke3CRSMPVWWfG2e7dfSlxHK7j
	KIfr+h9oWW9lzBeCAAt0/E+hSE7VnR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 885C55C6062;
	Tue, 29 Jul 2025 08:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50444C4CEEF;
	Tue, 29 Jul 2025 08:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753779221;
	bh=yu/bVYFPs5NHquFn45Bc9xbptKoY+Y8L/DXBiDm3w50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FY4CeHlPxqEQY3ggQahQUSoRRGfmVjinO49I5sJuOGjcPHAj8mklTAkSCG4Zakzuo
	 CvWjQEOC2+odKsm58x6VrEU4e8noHt+BTQbIa+b8nP0QopI+HxgtYaxzEYSMyMyP1i
	 OBLiuqeEwUGzRceBsbP3L3NpTi5My4ZIkmooTnlb/vqma7yjemisxCsOOiwn0jdZcv
	 57/GCBU5FjqNrGAV4nlmMOjD9QCbx2JTS2GDjEJ1QU42jdlN+Mb3IRDi9GqqvzA6Or
	 K07AZpyONe96SwTYWZo5V9aAQimkHX1XB5pFni7jy4mTsr/t5VjM2AL0Q5t4DXy+76
	 S/PGBqWqDL1RA==
Date: Tue, 29 Jul 2025 11:53:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729085336.GG402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
 <20250724075533.GR402218@unreal>
 <20250724075922.GD30590@lst.de>
 <20250727185158.GE7551@nvidia.com>
 <20250729075209.GA23823@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729075209.GA23823@lst.de>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61B951C000A
X-Stat-Signature: xryxoacxg9k7tijhmqdqk1o5fr8gyriy
X-Rspam-User: 
X-HE-Tag: 1753779222-542334
X-HE-Meta: U2FsdGVkX19MZ0bG17vUyrlfn0hc+QSBz0jw71grkqIzQvl+07wNRKsDYNhbrNPSDqKZRU7AlhH21AH9CKfCqp0f24yCIZTVy0BU0epKcfd4CFYN6pIF2orRbOd+SRSNy1Ug0wmGyGh4rskWRE8C9K7bZ9Xs+2dcFTjJ7J8MdheAyXGZ7kQ+STMPCfEqTSK3u77gwU4KL8b786vlL9Wau4x7J7zYX7iyyB9mA0ASv9jyFhEwcts0SazV1uPc3XfygDK4AvOGkKcjm72A/60djVmQShnJMsSjyq8K8qRsTsJoFhMIcnBUWOcZOw9UT1icpZjZaCVYHHJ9lNssrwX9lWy658ARWh5CuZCYC3YpH9zNCoc0vVlUvI/AilzqoEYCwCJZzbw70o4mp5i+sSyEwmtOOOzloYF3/avYUN8t2OpTp2IoTWQBtW5sUVW4qLnCMZoRsAC1rHGULxKNkV7og0Ha9K/w+t7EuOrsB7SXtfVxo7dxyigJrbs6UwF/oabCJPvUCi+7s2rk9f8oL39rADCx58ZLn9pGjvvUgjfbfGmFJpcw/Cu1b/60m2PE+LV3kSUH3sLcfPYBVWlZ30W+DTn1vMwR9qZ41jW0uD9dVspPlsLPBArKUiEHRINPc9RaagMqMRhUo+doRaf88D3Yrw/ePtEvRQED9dnHh0FFQ/EUnRiMMEGKXOOGrFabXDBDuS4PZllmZaVZgyYHzvRiBFYMsrXEGZWy7nFTkxeDcu0w2rqXtBngUWf2ZsSPfG3CXZZrax3Jo63FUqOzWuREjvT+eTtXrR/DMUmdhTJeV8lTm+3wOmFVGXh0UHvftrEy1tNVRMXEELV5H3UgVagHT9NgWJfvW7B3Dhr6zHpDMzUc2yJ1nx5OXF1tjGzRyUI617ocATagE+C+pXebyBBRCIktgNU+IVYvG2igskulgqJ/Hz9i3OOpS0teObeFHUgyBbIcvI7qlO8NMXU/Qzy
 YYfWseWE
 PboNxexBnBeb/GQK6zfmk8bUOmQDb0VVGWMhYzAU5oELVP8PPvYMaiamuIPQpG5RAXsJ7nA4ceuekvd9HYHTqM3DPSWtAiRdmLA9gZQBIlLkUge1crmBt+FZGa2nkdj+TtOwEMIHsTwF3prfm6sVUtXhVDDRMtTEqogQi+U4Dm59GbtQH/Nbs9deecLBi9+IHl8DyNGsnSb5IABKDi/QPLB67g7Zp81DvuCfNFcVCeMWrD7OQtT1bzY5/83V6F8xa280qcvyY3NJGxVqU4QfUsv9IenVZQTZ6F9Nai3hmSJje0mPFhZhXtrcqaZ1L7m+6DQNES8e2NqVtlzLbRR13UAd+IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 09:52:09AM +0200, Christoph Hellwig wrote:
> On Sun, Jul 27, 2025 at 03:51:58PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 24, 2025 at 09:59:22AM +0200, Christoph Hellwig wrote:
> > > On Thu, Jul 24, 2025 at 10:55:33AM +0300, Leon Romanovsky wrote:
> > > > Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
> > > > It gives me a way to call p2p code with stable pointer for whole BAR.
> > > > 
> > > 
> > > That simply can't work.
> > 
> > Why not?
> > 
> > That's the whole point of this, to remove struct page and use
> > something else as a handle for the p2p when doing the DMA API stuff.
> 
> Because the struct page is the only thing that:
> 
>  a) dma-mapping works on
>  b) is the only place we can discover the routing information, but also
>     more importantly ensure that the underlying page is still present
>     and the device is not hot unplugged, or in a very theoretical worst
>     case replaced by something else.

It is correct in general case, but here we are talking about MMIO
memory, which is "connected" to device X and routing information is
stable.

Thanks

> 
> 

