Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BD3C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECC78E004E; Thu, 24 Jul 2025 03:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D038E004A; Thu, 24 Jul 2025 03:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB42F8E004E; Thu, 24 Jul 2025 03:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB03B8E004A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:55:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B98CB79D4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:55:40 +0000 (UTC)
X-FDA: 83698398840.04.1D1D64D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id B52DFA0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:55:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmgGnxFd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343738; a=rsa-sha256;
	cv=none;
	b=ugqAEbJvSDDgcHbk9teJUwqb9OZTtxLr2b9qK7ItiEE5APbGY9Xrnqi3KzHCwfxlfEN8ZT
	FjHrnjP/TaeVraFqL8IaEaTB4mLd7oYLmRhxvrq1IYvz35TwpLxJQsSlESnkHBY9FnaFRV
	F0UO0OY7Rfb0JHODc3jslCGurSb8btw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmgGnxFd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb4rvwNa9OT74ZOIbDP5RGE7ncyjc9iz68ESZSJnBcs=;
	b=vmBIFOk0GccqUeB+YvOhhVb/Y1TxHz94PkCeOAh64EJpaUsAjzDIRvmuNFwms2qXLnpUHk
	/GzPH6z7GS2gzcoISFtKjXtFj93n+sHziG73seQOuoBFD00QSDDUTBb1xrZOD1kCZSX+Wa
	LGtm4hh/lzMjhYdwxRMXD42evgV+FBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 0E728A55FA7;
	Thu, 24 Jul 2025 07:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01868C4CEED;
	Thu, 24 Jul 2025 07:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753343737;
	bh=RejzoqE1QxLnfVJEcMygPRhvHl4TUui1JW/EXqf2Ekw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BmgGnxFd0m0ax8BCXu8Z23nkYEvrbYb+kfQKhThhtk3fHD05jyqUumNras/XMac1K
	 fNsR+wJhnDxgDW3B0m/HYoEQYDy1trcfoIv3oJ5G6lK6WxOJgRTPmYPyorkEbtucoO
	 lstjt+ChPXcIFyADPo+xmzPFYCtn+am83vuGKyQI9REWZ+4QOBGiYXPyVWpj/Mf6Qq
	 1sj2VY/rutJ5LfhdVsfBdfsSZKWAiRCmF5WPvyewWqqP7ARQWZMzXtSEGh/Zr+/bJF
	 bksCHkNXFT6a8dFppzN/TYVK3Vt0jyt6BKBOSqke/cENn8f6Uq9rDv+qbrJJvq5YYP
	 D7SDuGtahnLuA==
Date: Thu, 24 Jul 2025 10:55:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <20250724075533.GR402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724075145.GB30590@lst.de>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B52DFA0006
X-Stat-Signature: jkdpy5gij5x74f3fxbr8b5qzixocbkjn
X-Rspam-User: 
X-HE-Tag: 1753343738-927512
X-HE-Meta: U2FsdGVkX19hxsvLXTJUeVS4MoqIHN0epulEaBy9iKh3fSSyBfvseRIi6AlOnSM+na8LwQtIq1yFX7FI8rimgPhoD2YnGxp3BAhWtJI5KWsPyUGu3k3jypYhQSXJQ4P0bPwD+AJCjnBtUG+s+vnJm8eg3v0dCLYYidjZekbw6yf753z5BjKWt02KT1YnF09UVYlLCNl04gb3GqySo/2DAKX7ilUfRS3cVdYMa4AgsGvdYJ38pUm81XBHIaIn4Ovztaxm67l/jz237P/qBIAnICATFExNLLl+yJT2ubXsAFUs3GhfeYdrOLGQkTg/f6cHl4hDrQ/0lonTBWeknzWnUKk4Wg1fBtrR63Yh8y9vjZxCIvrEYQ+SDyI/px0VnEXnHeHnLqW2Z1J52mOURpo9mqmXRgdfB5sRizdnM6ZEUFRtXndWu+gT/LciLKZYUMxD2kwAkteDMpDC6b6KC5zoGsEqye1CQFrfJ0V/g7TEilDg+vI43wQt3S1E2gMEkYjMASOIeH1KV0WC3FyZOLloPxuMpmUK8YsCCob0h1M4uPLQqMa45lQTv38oHGcR9qvWIKmKXISwisMGQ4FE1KHLoEzq4rW0SWdjwLz0p+8YB5DMQATjF2ba43p2drsTP71ijnMPxEdMNHLQn080ehTmqYwOrbBX8Addl8zMcfSxKrZBN3hDyiYaad68wEU0cvmzvTeMJhsutse26C3NC3rJSHu55PYN44iTY6B18jhdQeQc4Qtu8CWXYszsmpqDBCNjqa/Cjp09G30uILSZFHfNQta54lGedSHe6WZEtJ/y8dx+Y5ZyiqVP8XoFivu7MtsLsEyw5gWZBhrImMgFBIydcjeJAe0GEf2GRv41Rj4RptRyeNoCc9bdQpXfFGIjsfUPjxfUlyvlRhPIQeZXbiCqLBaUM+bRuvgFaSu/K8zaMIFE4rR6ogOK8HaJfOvs5WqkMvsAIXatxfs87IwPZJ4
 WZUqaD7D
 /bFjx9SsD4RcdxZmX9tCfA+3ApkJIBcumRGacCdQ7pJeIayw8Kz+z91hSBv+XiAGfB4A/RqEhgcd4bIu6R/Xe8uRck1ymtond9Vh0X6w7Cyq8pPFWahuhKljKFfH0+pwX/vThAQ1gQiNkED+/2G/GRZ5XcfqCZxALtyWn7jAzrV1qJNssJ/kb2J2BHwClvkDU3hXREWLW0ExPqYE4loYoe3cV2quNX1RLTUrv1SInjXuybbz6ZRa27YroVgsjLbhQOeq57Xm0U9lo3ehIU4Uu6HznFUQWDrE8IOuSJLs4mCtCbK+4mCeZFDszG+WN96CcjF9uZhRv/HMspVqwLIYyKGXuxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 09:51:45AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 23, 2025 at 04:00:03PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Extract the core P2PDMA provider information (device owner and bus
> > offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
> > This creates a cleaner separation between the memory management layer and
> > the P2PDMA functionality.
> > 
> > The new p2pdma_provider structure contains:
> > - owner: pointer to the providing device
> > - bus_offset: computed offset for non-host transactions
> > 
> > This refactoring simplifies the P2PDMA state management by removing
> > the need to access pgmap internals directly. The pci_p2pdma_map_state
> > now stores a pointer to the provider instead of the pgmap, making
> > the API more explicit and easier to understand.
> 
> I really don't see how anything becomes cleaner or simpler here.
> It adds a new structure that only exists embedded in the exist one
> and more code for no apparent benefit.

Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
It gives me a way to call p2p code with stable pointer for whole BAR.

Thanks

> 
> 

