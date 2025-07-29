Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E175C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCFE6B008A; Tue, 29 Jul 2025 03:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE5D6B008C; Tue, 29 Jul 2025 03:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3EE6B0092; Tue, 29 Jul 2025 03:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD80C6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:52:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 437CC133F9C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:38 +0000 (UTC)
X-FDA: 83716535196.24.D66B673
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F9B0100003
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753775556; a=rsa-sha256;
	cv=none;
	b=0CGeMt/PU5v62zm4lXh3FrBxG0nxJlMn8VK1nJvmfiK/YEPpGqjwcn+Pni1qZz+ph/V5Bl
	cRPDUf1uIeHKIhp3laeJWqX4bMP9yImzPQ3vPk/ZH34bQJeoIROu8OINMQW9xuNNK/3mQF
	uGPGynlofhspP/e6AQZXkOkDVpxLrlQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753775556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/wzwzzoteYB1YbMyEJV3QKZSz6kaf6sAskgHEMM1H9E=;
	b=v69Z6oSKm7ek4/kVwNyiivnZKUIhpdPe/Lg5uQmmmWY3r19sovhYZksQOaUi8oj3XUb9ST
	rbUei+ZyHhs1+Qz3X8ZkUCiUR+4coqx+FzkRYf9rDMoPc1cxUST1AZBdj+l+TZUaKEb9q3
	BR6Bz7/VgqIvOs4C3w+F/tkhboK7rt8=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A57DF68BFE; Tue, 29 Jul 2025 09:52:30 +0200 (CEST)
Date: Tue, 29 Jul 2025 09:52:30 +0200
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
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250729075230.GB23823@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com> <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724081321.GT402218@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F9B0100003
X-Stat-Signature: upky5noje38kh8p3wqy5tzs3aihwro7a
X-Rspam-User: 
X-HE-Tag: 1753775556-720693
X-HE-Meta: U2FsdGVkX1+A07SWI5nvRnsaerOpF/rL8WZJ3UHPZXmgG8kyrJU8xHnAFN3aXB+CEl5JN8kjk62LBTjeWpTD5NM+CDPsrtUQ/oYEIM8U1Tnq3ZEB+O8SKOeYeiW8jpBhsKaZ0wSwHhHXzi9+Wco3oerhmYk6nsdl8lxwpsaMz7ht8B9AwN9JEBp+DAAoheXYWBFVCPyLbbMFavK5almuAKirfCHDv0oFAEp7tZ/UCllAkDc9sDywGIwwwOBJf/yc+kQ6BX9RL+3uaagGw3Gs/QaN4PEZiX2qQziCgF0esfuEvYWqLoZOXiKLxyhNtjfjdxq+TAA4UgFMi3c7odT191sFBRjyJjSF41MgacbSDeRmI3js3nIkUDygll+DCCLCYV27VMlyx/BQNf1w7lmXTr2LzXTUikMDz+03RT6uxkai9oznCgdQk6Zj6iohOLMhOqkTEhUVUoRMKDADAdrs3qbSw1Pkn/3dSvDkvQztouPXhST0iukzlDnl+GynVIdkcna2f+bhuTF2sdwFbP3MRFc3Cewsdhr6sdDooaODlr9rtifAsTa/0SAHFoYxvgB7x32IaieZLJ45sIGtoTJVmJm2UJTrqK/nIEGdSSxm/Xb27zhsqLPyN2/6Yb0b6WyEqXBFrHC2uV0jntrMbvr2KDli5oJ2jRm/nSqaZais+fpHeoEOfUJyJ5vViwHw3i5bnS3XWeVB4ne/yXmN6T37JmB8CWXnQlQl1T3TVqYkMv9P5edBShGF3v7semx0sXioId9hxS+ojpAyTmgvN4GYiD1bdjWsciKjCqSF6v12jNqTNoo6F+3JTCRzEjGdAbQTNEn7bxBcmQFJrrXp9nRArCWBkP6R9X7krf412jOJq6Iptq2J0ENWixBwu4KRD5iyGBhsQgdXJdhpgeZA9MxQMjwaW9yVLU5UYUgaZZk0t6Li6LO7aMZDRO4FpXGGCpsTfmSe+qwwT1SRruXDuGk
 XgyMsWNo
 F/lEFg/bHfFNAFVcQl+oNXX1+AFmsZtDtft00ZvfMdEPaD7ofy52ZY/4GdV6XJ5tQWuWMC3a+TcXxlU1i5aP2c5SE68h12tmCPSt6pB8ayrpZEw6zZ3sjco4COoZs0RRk4v9QeFZD5OATKl3sROtskfGbHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:13:21AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> > On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Export the pci_p2pdma_map_type() function to allow external modules
> > > and subsystems to determine the appropriate mapping type for P2PDMA
> > > transfers between a provider and target device.
> > 
> > External modules have no business doing this.
> 
> VFIO PCI code is built as module. There is no way to access PCI p2p code
> without exporting functions in it.

We never ever export anything for "external" modules, and you really
should know that.


