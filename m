Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5FDC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9CD8E004C; Thu, 24 Jul 2025 03:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7912E8E004A; Thu, 24 Jul 2025 03:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7758E004C; Thu, 24 Jul 2025 03:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 544318E004A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:51:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAB22140289
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:51:52 +0000 (UTC)
X-FDA: 83698389264.23.1C21D7F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2436840003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:51:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343511; a=rsa-sha256;
	cv=none;
	b=vCemvymXSsaC83tX+d9ZIzoR0WHd9VY1fIENUkLhlkI5kBrgNdq6aqkznGTs8m7cwJym5L
	7d6gk1FBlDjtgGFEq7oFR7zF5UojpyqS/7uJo7pehMpetZhZjqHAihwpWIwtiMqn8AsFBU
	DQMR9ECn/G8XYoDU62MU0cbez6Dnbu0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+4P+uyBJN5Aqh1cfM+cPvIONMb2PCATczYxz0+QPlTI=;
	b=1fUv3FxdUj2yIbmWIp9p6XmoYzdU9FMgHw2VaB0oSrFKB0FQCfqesfm2TttGwd062N4Jo+
	CClBa1JBucL3yG8ulUW1DzJ4oNN1Y0haN90XG046lyet+cS7H5dNrXOUfaxDINAgFOLnQn
	Yz43wv0O5HUUZ7/KbIJjf4lMh3EbXvk=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 662E568BEB; Thu, 24 Jul 2025 09:51:45 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:51:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20250724075145.GB30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: gg391ddayfhm1yosr9jfz784eqcoones
X-Rspam-User: 
X-Rspamd-Queue-Id: 2436840003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753343510-695383
X-HE-Meta: U2FsdGVkX1/Iqn0IhgwE+8d9hMr0SaNcvLCFsxwa1lf8xowWKCFs5wKduApxfryJW0tq83NJTCtRoR0jb587C2e9LFupTtKlbyGvz/D62vdVfG98nr7oHfVKYdPC7bK2bmA9RXvmeEUdJ8d1PKBEwyHXilfIsEp9meil85GNAzzIIGZva08GfUffCAGJGGhv7J+9rG/d51IXouJDJABqrBni9NcBG7pnos8X9SLZBOBT1o/mer2u+MGJq0CS+b13eOWjQSvjA6peGdyJp0gi9XHvEm1I1Ts6wcTuIphQfFw4L1tw9GCH+eyCxFAc/YdDqR+kmuKwG0duf/G2elZNPI0SSUkTYVg5k+fXhif7flQTyaUVuR9g74TvCvrquzndEp52bBHop4u64Th4BRLNq/aFRKyM3j86AQrclpGFXgiUZC1vAszpC4FgykBsGnLWaQNhYtNkhbshBQt5dlDIznpVZpZz6hN+CV/orGIRSf+I/1crmwEwHcA95VmW8b42aDg76DwcoCjbUJzLa7p6pIDmyNhiuJeVAyzcXhqQGbclt1KCPCs2W5C+3JkIqhxbscIKNHeBaQYBCfFdw6cQjtHH4zt5msh/HZKfldt/2MM17VvpUhLfLza4T1EjPLl56H5h/AEXnMT0C2c42flaUmmyAdLcVFt3UqsGuAn4BkReiRlC2SBqHwWYEIRD0QVSr9922y3ccqYQaWWZmPFEWr50zQe3wTY4shCvuoXCPNi5f6FvWQUBr87n48p5Sw/66mN3dw6cgk4Y4JVazYT+LIGMLgEXqtRpxb5gRql0EI0PwxSnKZVcLzXy1Fz9TyNMXE7b86b8ffOa8ca9z+jEWDJzs2qA6RNUwR2Yudtykg8jwIaGXHuYULE+tU3qCfRjMV5C5ORD8Oyf5MxCvjKWbRZcrGsEnhIce0LHllbzueOemxzT8RarLYlB7eOY5+yF0t1PB+vRiC2/rPjR1sJ
 wNgZOcZW
 cq8cqNQ4LIlJ4wF5Iaw0UWBI4G6h6thtHG+U7/zQQKejOLDd8KcCZpXM79mwsmmX/0hWnPRRvCMdrKPpTpOP8sPOmjXOpl7IFM/VPXs6UNrpKcnuTWIMUsHD6KSjfhoDJF2Pkorpqpe64jv2agPVHOMNhc19TwBO/bgy52fK0jF7a13V55leSfzb1472m6SWBuGKM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 04:00:03PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extract the core P2PDMA provider information (device owner and bus
> offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
> This creates a cleaner separation between the memory management layer and
> the P2PDMA functionality.
> 
> The new p2pdma_provider structure contains:
> - owner: pointer to the providing device
> - bus_offset: computed offset for non-host transactions
> 
> This refactoring simplifies the P2PDMA state management by removing
> the need to access pgmap internals directly. The pci_p2pdma_map_state
> now stores a pointer to the provider instead of the pgmap, making
> the API more explicit and easier to understand.

I really don't see how anything becomes cleaner or simpler here.
It adds a new structure that only exists embedded in the exist one
and more code for no apparent benefit.


