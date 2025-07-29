Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE5CC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DF96B0093; Tue, 29 Jul 2025 04:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D06B6B0096; Tue, 29 Jul 2025 04:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7974B6B0098; Tue, 29 Jul 2025 04:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2B16B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:45:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 126D6B9E3A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:45:35 +0000 (UTC)
X-FDA: 83716668630.16.532E069
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf30.hostedemail.com (Postfix) with ESMTP id 81B1A80009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:45:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mtjx7aNo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753778733; a=rsa-sha256;
	cv=none;
	b=huz0cTpeww5asPmPRjfYrpCCaVbOmPbBPzvaEa2cfyYet/NN6glsPOzaSU/ofyOEf2Ll1z
	wUe9nOqD/ZcrJWBK4hVGNqUY/gzXRoJWFjln98xb+yQ2ji2DMxC3G9Vg7Z+YfvxMzP/e0N
	fY1/gFgrjKBPQWgoGyAWU1soNtrHXns=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mtjx7aNo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753778733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aft3AoxCvpZFJwasgjTSp3keA2dC2pabzNFVmd45jnA=;
	b=PKJbl/JczLR6V89RMnPTF6NrS84VgZRvsFmDcaEZXLKRpCqOcJh0rcaHvI6BoLSq9kf1jB
	kuy15wNiQOUwrFZumvxixGeAqNQxQa1PqD3rz+JmOVTjZJYbtkw9LfutH6M7ElZ/d17NWN
	d22TAPQLLTa8yznqB9aH/qu3J5IjmRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id C4605A54C7C;
	Tue, 29 Jul 2025 08:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFDBC4CEEF;
	Tue, 29 Jul 2025 08:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753778732;
	bh=jkDZ+7UedrBceUBz8tlmLsJhxKV0IBvkz5SAqWUmQpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mtjx7aNoJVq9DvGD4ORxhlZmNSbDYw4VpIt5G+1PbR6Rre8lAWRCRQDkAz4KTJ/bm
	 BxOO9PzCPjXSeWidky8QMCKZKV2QSFneK6+i7wXzmhFeCMmGPsUu+Uy8H23JTs1bR5
	 SBAPBVl6JzLSEXRQh+LZJX7ikFN585m8EXq0Nqd8+eigGIwYYpnp+T2AW9EPD5Qm2R
	 IQhv3G+CGzUj9jLEaAYGbBzjIi0YUwqQckxK9Csm1y+KGwG6KpqkBl4LHIvFc569cc
	 xXopr3S7OAVJSk8wPuanNo4rGMQEBZyFc3yISHfeC6xtoUaght3ICDAFyg47naXy+n
	 xTgrSU4QNB9rQ==
Date: Tue, 29 Jul 2025 11:45:27 +0300
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
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250729084527.GF402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <20250729075230.GB23823@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729075230.GB23823@lst.de>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81B1A80009
X-Stat-Signature: x1cbtzjogh1ej167ukxnkc1q6dfrijq1
X-Rspam-User: 
X-HE-Tag: 1753778733-240107
X-HE-Meta: U2FsdGVkX1+/MJdQyE1dUHjBkItioghjAqY/oUhs4kgBebgZ39lxvNBd89wodrWBB7gOdunYDLMNUf/AHtvfNw04prqimdPiTAX25Lxwb7m7R6Io5t67r5VDFpjwSBJvf7iE6JxT+y7L9TohD/ipIaRZh+QJJEuJSzsUHkUgOleDhF4haqRIhYepm1pjDZEw4fw0nV3IkH00X3M2EyBrcabYpJzfuSHO8sDCFJFOMfmn6nL2XN+zxOlcbQe2n9DSBeNbyJRpu5jlms8sIj0cW+x/YlL7aNq6PBkpP1XQq/6uoY5AE8X5bIs8ivJnusgmSS79S9SC4KS5EOTyigvgJ6Ej53PJrJuB/eac2TO6BunMSVGcXWBYDV8k0c9Htr1hywfUOPpMmfdFIfUCWlpXMYQN6DKdQLtjvy7ljfbPIExg0jHMkm7c8J8ZepEvZj4CVYM2Ta1djGbfUwbyqHgiH+wNnXXVS92eehqNVupPSmIkpEHsgpfdFvr/3a/kvdxu3Uypdtcyc1pX2iWN9PnciK+Aj+nT0sWATlcTNMLtW8p+sCR/ifDng/aQ51sDsp0qaMTopUb6BRPAac7iKT7fB1XRh/Q79c2c5uEUgdOPMA3Hr/TWwuOrsS56Lc/9UBtGVDPwHnhLON2M3vhKgys6/0ddpcm7zQXJerRklE6TbMrEHwuZADh44Jx0+bxLOblLUtFJT13dJyEteQwHjh7L2lmia2OsPurvA/7kNcEBixH8MQQmzBE68yBwhZVYdlxf9BmAXoVI/DObZQubW7oU3QCJWxIBXvfxC1dU3HwdDbZ9CBkQTGBuQL+1bUW0xwNWosTHlC2HXA8vsDLB2oUaH5bopykBxkbJNlYYf7lxKizcL6Nm9T5U0CyAvvCtASOLU+34tkouH/0ycHOzUi534QfM8sCPKwAtauO5MuvTq8yUTp7mzDn3z6ohI1YXrGpcbJ/Vg6fxf3lErjy7p17
 QpfMU04k
 J8DnsKdSvwLt1w2fBhmwCbJFGX+8GNv3Pdew3pnoF7Zq3/F75bF+UAHS/c7N0DFI37efZBHI4LDqqAcOyOjmePT2FWCpCqkOpt/u5S6yGxaypt8qbBak2KI/xFonsHl86phZxuEVOMr2q/94Diyg9vbxSUga8vLyMIUtYOJzVwRwQ0aB8zB4/RAhKkUNoXvrbvJwunQoLofq3ocXz8s0l4gqTEeXN+KDxQTOFGGWb4olwL2iqNVwQvMjNlrJ9Q/cEobQevTE5ocRCzuFboncAfrDKIlqT3nCLIq9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 09:52:30AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 24, 2025 at 11:13:21AM +0300, Leon Romanovsky wrote:
> > On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> > > On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Export the pci_p2pdma_map_type() function to allow external modules
> > > > and subsystems to determine the appropriate mapping type for P2PDMA
> > > > transfers between a provider and target device.
> > > 
> > > External modules have no business doing this.
> > 
> > VFIO PCI code is built as module. There is no way to access PCI p2p code
> > without exporting functions in it.
> 
> We never ever export anything for "external" modules, and you really
> should know that.

It is just a wrong word in commit message. I clearly need it for
vfio-pci module and nothing more.

"Never attribute to malice that which is adequately explained by stupidity." - Hanlon's razor.

Thanks

> 
> 

