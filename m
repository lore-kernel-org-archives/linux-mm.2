Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AE0C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976E26B016C; Thu, 24 Jul 2025 03:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D2B8E004A; Thu, 24 Jul 2025 03:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8638A6B016E; Thu, 24 Jul 2025 03:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72C416B016C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:59:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16DF0130D10
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:59:30 +0000 (UTC)
X-FDA: 83698408500.16.F8A5047
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F503180002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:59:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343968; a=rsa-sha256;
	cv=none;
	b=Gh2eF4hnccxyJjzxWeCNOLgfOwc0yHDq1oBFrcGcWcWsJ8nCKHn2NzonWHEZcB3T7RfLA4
	qONgevvv8HpAV+KLGBWE5LEfL6sXwwv3OnJBWlWrODbhgoAjPV+0cj4RTqRwdELoKWk09Q
	smtP/IsNuNDHk7bNiVIleFjZxro1vkk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n44rD4yY7nUE3NWEI2Wb4R42wOyK5apFO9EVQeumBtw=;
	b=eK1Ei63huga+PAIy6j+YG29CMknqb3xGpK348svG84su0LbaPdzv1HVh56bYjuc4qIv0qh
	+/wJVtZCYlcZImatZ8cdM1jxczOkn04ys67xSxOCCNQxFs05bJ8ocoRIu4vgTs+Uwy0g2i
	mzhkqNsAmUfJxTnlLSX9VU9RpO+4c8g=
Received: by verein.lst.de (Postfix, from userid 2407)
	id B200368AFE; Thu, 24 Jul 2025 09:59:22 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:59:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20250724075922.GD30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com> <20250724075145.GB30590@lst.de> <20250724075533.GR402218@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724075533.GR402218@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: nn1bqk3ujkptyzy4drnyhnwxy8nii16k
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F503180002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753343968-600430
X-HE-Meta: U2FsdGVkX1+XgmROkgboU7zlT/Ib/1ZHfSQxS6tufatt+2b1FYg0EkTPSJHWVF8nwTEBqYxNeWot4rR18RsqlLMHOru0zkCi9HurpWKr4avlsw5w3KoJ4Jz9NNrCDdfdK/RG4WSUl8rEVTC6NJK4wnGLmRTPLexdKCU/8CHbcq/SDWxQmDMunAJH+IYfsNWwh26bGiiQntz3wRDZ4X7XNClc50Cn+o5Sn2ckyBoIpId1TuYppETHe9rhS7bF+M1YESk9lvOEPg5R+lZyK5cfNHHIwOst0WOdZrfTxfAu174C83+wKdnDutp2q4tAgIYDO8vZuqVK+HHHIT36AAntnDi5jWVA1y+QccL4UaMIX6FP0uZiTQWwy4Ybet80Ho2KKC6ZFAClMern71RremSkgoL5qN2i/MLzsJUJ0zu49UNFwcx9YtMzBVVwN/uauEws2njXGyxCxzjcuNjMKGDFmOtC0IUruyefB0MK6rXKZbDl8G0KZA48B2T3tU1lWz1hjT4MDXhqOtNF6QDncECSc2mGxilOocUaqQd3cNr7MI56wWcS+EyGR3dIDClvLAc6RJk6l8viIlqFoB/cJIwrBmUwcaUQF/cqC1A4kq6FFeKYNfOAT0i60g3tawuZkYCS9NSPcs/QDMCvYndpdnhi5BL0qIAWEHrEcJbBeLKizzOqq0CaGvifLSxFfb83ZtboyrU0G7jCB79O7wt36qnOsSNV8dAEmy3/ls30h9RLMCtGy+Si4WBe8KyZ/jQM11uoq9pyaPlCSp6x48Xe00BJGEIYA5BApQfp21GyxijlspNb7kvCCxncgxGMiB6IhcWLb3L4i9elMx1HStPov6vsJ1ZR82jdswmgHytyBwWYyboWJv5p3/CHle+tdyM804WRiX1b2DqnPGpLi08piTqWZ9azUaDl1ZaIzykMkIaBwiT6LBu766HR8kHcWxihH3iyazabEhUUGcGif6QJeP+
 x9DFY3b/
 AOwGlgWGP27MebYDGDR6ri4TMZ/eUE801hVOkD3wGt42LsUmq0a+W8rmdZgVCeLDGqj5w8izE1lrRWcu6yBMzyH8UiYL5TCGL7cKE0vWM5rqS1zD6p4ZvUvBJlVkFJLLCbPQvLjjkJcw5oWdQCpcb0JPYQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:55:33AM +0300, Leon Romanovsky wrote:
> Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
> It gives me a way to call p2p code with stable pointer for whole BAR.
> 

That simply can't work.  So I guess you're trying to do the same stupid
things shut down before again?  I might as well not waste my time
reviewing this.


