Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A91C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94616B020B; Thu, 24 Jul 2025 03:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45256B020C; Thu, 24 Jul 2025 03:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B016B020D; Thu, 24 Jul 2025 03:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1D9C6B020B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:50:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1924FC01EC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:50:25 +0000 (UTC)
X-FDA: 83698385610.15.FF52F4C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1DFB40008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:50:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343422; a=rsa-sha256;
	cv=none;
	b=frDUJj4gg8zMA8vuIyT4xaHMv24TJ3PGsc2zQ1eaTx6KcZhQlshVYgicgoIAX6YNSgCg/c
	BbCP6vkNMx9gpr8qxYAW7rRntrF6+zA3MTlFYAN9Ss8HN2xAmPcNVpKe5PraRgjzswMwp0
	Zs/DwihAMYex8K/EYZwURNcguBjyKis=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=zlEgHagyP3aZP13LK6e6zhLFxvZzq8vZwCnG+YxwfZZF59EL1O6ilFsv5BrWw75NvE8aGE
	Nz6ac3wO6YbCjL4f7GsbR4frO+xmR+07pS6CBdTneIjXf3a9cWzlClezMHa+nyIuRqCWDF
	BRD+9xLyqBjoyl96iXidJnIhe1C+vRM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 593F968AFE; Thu, 24 Jul 2025 09:50:08 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:50:08 +0200
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
Subject: Re: [PATCH 01/10] PCI/P2PDMA: Remove redundant bus_offset from map
 state
Message-ID: <20250724075008.GA30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c1a4acd69e040fc2cc7e552849f4d922f5f66325.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1a4acd69e040fc2cc7e552849f4d922f5f66325.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: A1DFB40008
X-Stat-Signature: yiniw3kopw784yoozucedpcx83k7151j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753343421-333814
X-HE-Meta: U2FsdGVkX19pOL4mF2kjecloV39YS4aLWpNBmHop5vxYHO75d0cXfHvv6fMe1UmQ3amo+A8QWYtHL+09To0ITjq5Lt5UCGua+Xopn+PAmVU0W2Jo9+gN6Hkmk2mbF0Zsfs2K/6CEdkn7bSZgnajw0oyzD8W+ESRWKFpF1YROa2mI6zl+3rYbzk0SHgKysvxH5Jdu3wOGrV4HzADY5TkDw5mkBV1G4kR4FR3mhjXYVH8dRdRi9nwYarkiirEMKFWfvPG5VlfHO+sQ1ASsl0FnZ39PZixpviWE5BA/BLDiBp3Mw/uk4iv1lYDoCIej6OsBu/nhV07Tnq+y3ELLK/8XuHvHZgc3aYexGeGP+IkW6OLOKVpb+x/gZal0ccq8bq9oNJMNtUIf5IVvmsIWX3mLIghinOcb7ZrSVNtdKRp9P0Y3nAGbe8sloVcJWC0OZzrOEghHLIAPaPlzAeRHLCEHTJvNbYvcIIO9tUUpjqyHjt5pxEzpltAP3cbV3uSNSTIHO4/QMDT3SnOh6WKEumZ/mV5x8lFFCjuAB1t46ZjRJLMJCE1geB5irC3Ku1n1SFKFqj7KNBvV6ZRx0z6vYGDeHOhkCyLApLLmedOIEsFozihssMsADmesdXHv0SgQeZBrQg6j+DKUs0U+74s7ZWBBna84ngUdla0cqzcYD7CErTvRfe54lSZpNv+rO30lFyP5FOzl9ExV8dN9k1RpcEsp79YW8/0gRBmiArbaRKAuOY1v5KOQoy5bCFxvivB67Cra+IpDtq51RLfjXaf1mDPgNbOM3LVPts5qxRsbpeOPOKsOAQ0PZKb0wTWSmmlH7CVKIhP5xunF0BaV/uKLXfdWtCusySxA+f0U+WgzV5ThSOjtskp/JPP4mpTmlLsLUVkOeraI67SlNR6hQ2nmbkdDMhwjg6Ud5iQBZ53O24Mnh+BkLZkDeotL4pDso1ecYdGcvi/vK8l4ddRdqPBoCzM
 KAkP6Uj/
 PUivK1Kf4/m+uFjSW6cWzB2js/uK5OsgoaVPvHis2w9ESe/sOrsxEVfX1c64CjWxanP3M9KqhDWHqDoSOFA4gEf7RKkoxCn/sb/xdA2udXSw4ctnoKODUA2A+KZyWWc0dnoi0AyTB3nOH7+FilgSpaxsWjXA5WGSP9JA6RhyZaup0SwSAs+rjVuv7nfOJqiDsOPt5nBwy6QQbMbwujBXJoOYR/gopzFKLMwaOr0csLLkPE53ekC/QiV5Rhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


