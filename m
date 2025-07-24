Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEEAC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2775F6B0249; Thu, 24 Jul 2025 04:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5878E004F; Thu, 24 Jul 2025 04:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C594A6B024B; Thu, 24 Jul 2025 04:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23E076B0249
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:03:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE370111E1C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:03:20 +0000 (UTC)
X-FDA: 83698418160.23.D677D66
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21FDE1C000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:03:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753344199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pphLpZQBM1FB+eB5IO2M5MevyRelWmIUkDJtbfDmgGg=;
	b=i4X9SiNMVXwKFyMq3FbI7KogBVu7AvuQ8TLuCnQQe3JUE1hZ8UVJ0PycO5x7/FHoflRYUB
	y7SuyGxflY4OLfNuJ2u0gzbnbjU4cpH4zQSgGtFcBV+kO2g6rdTwvlt/Fumwk3VUnHlDxO
	y0aSfCrxTLjfwEYYF9u64gMyVIGKeFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753344199; a=rsa-sha256;
	cv=none;
	b=j+h4qKQFCacf2Q620kHBbg2oENB/xPHBrBg1UH96AXgvPClxmqYkvZMzkEZ3YDk6tkMPj5
	g/vpzxg7f9mjKmPMqRzs4iB+a2vepMh3uN0hqzQ0HOz2PSXHXpWe5yA89uEunZKQ27+2im
	mRSVnmd5T7rHsxmzTUyoJ3sPmRMbjTk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD46068BEB; Thu, 24 Jul 2025 10:03:13 +0200 (CEST)
Date: Thu, 24 Jul 2025 10:03:13 +0200
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
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250724080313.GA31887@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 21FDE1C000A
X-Stat-Signature: erji6fcr4u9g113h1r74wuiyx4z4sxgd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753344198-751916
X-HE-Meta: U2FsdGVkX1/2iTXcrolj9A7Os6JhC7neEv00v1O0Jy+0YLhcds80WGw0jzB7dnHLIQYV3tOu2xl/K2Uzk5KAqMyGSTQ0OeaZNEyrqOnIf8hd2rRYptqtlqVPp4kk6QnseSGu1ow2QS3mX5bv8f/88iPpvtdiP701TZl8kgsHyJKK5jyqTVyn4fX9XDW4sPQ3aUd3u6DDckiXFclFmRQcZyr84g/BL8DFjQLDaXL7jLPe2zweANOAPANA0rz3C4VntARVpeaBT2I22Jplgh9sCwUIvcZgt01cow6LTlwojqfzVtPiZyPiSxklvGRin7Eg6gQ1jWpeKRWbgmccmgeZiqo0KbFcV1XuB1NKeChlA9ejlL1RH7WZBEf7AMrv/RjM/gibXJpxgfDCHv3ze58C5U7EQYutJqBfYKJbzE8D43KII2aRbAEeA17k1fusVFwp7YzDVzHp77aROK/68YJhWTf6yBOehSj2euJxujd0jmu5XamQPxPf4nl+c/mM+1NRC50SC5RfTdmsCrueeBz3e4X9wF+3LlwfUyuSfyyB0+8zJdzEEhc7MjCKGRO4+rfNimCPj9ZQTXEy2tnDA1gbCwrk+rHlJB72RggyRpfYgEe1+ey6QsFlFqEx/IMEenfttgEKvoc9TqBuvB8N4VMsBd5uSeAXaxQFbWRHddpXstdFo1CaNxtrUP4CS8bvDm1lPQENR7/ksJZf9SfcWYocjvYCH2a70KaIlgoCK4rKP29Txc8jp6ZBDxq9e9jhelwjzOHX4LPlyzqRydGBQLz78ump0+z69zkg4u2BneyT+ecPIgnQJn90o6ouKPPWtYHPS7ZITXDeXNfhw3pYWlumtaEe2R769N+4Cy9MpCrtGmdOn+z8i7jpDib3zBinCU7iqMKWFLktJbVvPmsqpSM/g7NTQTOgTVp6rN0pbJCopDEOB/nvWV53qfTAMw8QuhQxuGNjMuIr096axABp1ZS
 W6zqZRjD
 ENRuODLdO4uU/8ytJtK3aa4knhYk1zPwZbRr9wJwfsmNu04b7kQXfXPs8nBDMlPIXxCeRqx/0ONCZJp4C4RWsx54HwPspWMvH42352/odK057TWVVTmbHZA/I4zdzCw99a8zoJXAyX58oQa2HENghulWIUUi+p3hN4D1Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Export the pci_p2pdma_map_type() function to allow external modules
> and subsystems to determine the appropriate mapping type for P2PDMA
> transfers between a provider and target device.

External modules have no business doing this.


