Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F8BC87FCC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 08:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552678E0002; Wed, 30 Jul 2025 04:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504458E0001; Wed, 30 Jul 2025 04:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4408A8E0002; Wed, 30 Jul 2025 04:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7228E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:03:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A97F160365
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:03:26 +0000 (UTC)
X-FDA: 83720191212.15.09503F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5A5B160013
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:03:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Phq6ne8j;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753862604; a=rsa-sha256;
	cv=none;
	b=wok7RAMxHzYZBo8cRFfef40VxYLwXr16hyBFuQ296k7evqUNFU7texLN5YCZ3NtRGweMdE
	PaZTsyC5kqTmIzDttLvuQ0lN1lCmUD6L+EvoDOHkb57PxxnP0l8DgdAcOdoSeiIzrdyiJo
	17XR91UVdcqS65bHw1eKWJFiZsJCO6o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Phq6ne8j;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753862604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xatzGkHff3a+VG8MroN4dKCni5BF8oNRuK/K4ftkf9k=;
	b=tK9gKd0SjdcznxzPP/Vmzai6o1CDCyoRUeWcuXqdfsKM9419HxYaqggOao2pWMjosL0X0+
	T2bPnB7pAPoJwECULbCs4TTFNfvIw+mEj/bHWXN9BNMdQr5eWO5r9dAhhZ9rJaG3oUsIQn
	+YesBpWt4UMSAXSVqKwjGIeMEuyfNq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CC0543D89;
	Wed, 30 Jul 2025 08:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C439C4CEE7;
	Wed, 30 Jul 2025 08:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753862603;
	bh=HEgPRodovJalgZ/g1kb94tmKLk2QtGEpj7zW37uzKec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Phq6ne8jeiHRh+g/jyaIbVu24BslXtOFr5jlNeVkeq5Pd4JP4IP/urevgfTH7y8Ng
	 IM4N1EVTTw6lIyVWLMQ5K0tdY5QpmQj79Qaao8gIoOMRohyP/vZ3M9ekEqXib6GZL+
	 Vd2t51G/uWQd6oD58QoSzV0VWLuJ8QqSIDQStXuXWQ5G8gEHsTZDXx81LTTpzH1daZ
	 ezVZXuukAwl9TGk23btBxOterY1GjPt8BN4i8ULPTxzKhdnMZ1IhejtxHnXHMC5Wo6
	 rXCmw6UrvY7ectigm1BvmYyiZfOF9dlvJf0mlr92yHUxxT/i06Xv2nhdtuZ9olDn3p
	 c3RNuuUGIqBAg==
Date: Wed, 30 Jul 2025 11:03:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
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
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250730080317.GO402218@unreal>
References: <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
 <20250728164136.GD402218@unreal>
 <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
 <20250728231107.GE36037@nvidia.com>
 <f332e2b9-151f-49ca-ac0c-8c9494c38027@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f332e2b9-151f-49ca-ac0c-8c9494c38027@deltatee.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5A5B160013
X-Stat-Signature: 4gogs5fi1dmnqopcokwbiair8ctakmea
X-HE-Tag: 1753862604-86386
X-HE-Meta: U2FsdGVkX1+RoMSX3hNc8Gofk6O4qLQj6zon7nGb7HvVPofbrfuPJmqSYDbC7ad4R1ubb8gcyr5mTWF15rzvLz1G/hqLsaLt8k/3p64mgMzPUCGRJ2FGl/akJ/25LvCJz5yCI/P7E63dq+oBO0kkuxEX0niPvbGkeBTj3aIlExArkv789LNvQJ586sMEY6WXaUascaioN/wdAo8h/C6TNO8yE9heFxdjykqFftlSGqrgc9BacPoDCvw6kqt2fXQEuH6X4tZo0dapsLuJF7412WXyCUm7tZmu0pUnQraeZvzCCORB/lhNczx5ZkbUqlq4ObAiCeT5D2TmqojPEKiUNGYc1s3p351zfcNDB2fTVxP+E8mMpv6ka9kfkinqPgOBHCAH7/cs+MHaugz3+WGiArFhAkKIHpLg7YnAygA+WeS5GmPBxb08Km4pYTwPNA8khMA/TQrh8+Ll4QjNfdqniShtrPS4kUdzyD6bPTFFJURxHKpGA/uy6NdGbjf8aWBmoLKCqLTkeADIQ5l1Vu1qvpVFLh0z53DhfZOacx3nJI0nJRneptfMUTyEYmgRCgJHr0e4KuPcUn4+w9APeZvGKPUxledOd7ZV268VBRTSj3PwRVi61mdccQSfTtoAaitMuWbHZByDtJ6BTO7H6HxzdaYwMwQ8d95zXf0sEV60HA35mc9LMfAvPkSyBg2cujV/J/DAbov/yFEQOQ/CgdGiO7bFc1v8hcED7BJ5aRJEZduHK+uGwMs8WkaUNGEH/CbOeJmkUrl0FzZiwoP6Xloc+dHZIaCGP8oMiUxIMhM/0o1hPTpEGmmLPT74rLuFi2qYvLC0tFBgqraXiIB2931q13sLwe6XzYrfoJ8r3d68FBM+xqBt2lfmwYbASc/Eux/M6/9hD7gyHPK507j2Q3By7wlL2JcfQj0e1+sceWNVzkUaVRHK4D6qxkeHDGL1urcyu4fwr11IQA8Hwnxfb9B
 fMJz+mDE
 AAwFkd6yX0/z0luaFSami+Bo6S3jB1fGgOlXUdSiaqCSpH5CoaxFdZ95Uiy7yZshKrsQJrtHTyu+BRl6F1HQkOY4Zrv3B8a46jkntzHje/uXVnjmOHD2n12x1kChmPCPhUMsPmpSJs1EfxOytV6gVb1+2FnVeiQc+cblBkCwlwuhgWwDy24WpvtJN57Ts62Pp+GG4GqMCWlstwl9Dp5rXB9opkdrIoO92/HCdDdiV+qyzmmKCpfJY90jGmExlX3MDH1Aja9bn98sq6XjZkkOrX1x15xMk4xkNwoOE+62pmmsD2k0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 02:54:13PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-28 17:11, Jason Gunthorpe wrote:
> >> If the dma mapping for P2P memory doesn't need to create an iommu
> >> mapping then that's fine. But it should be the dma-iommu layer to decide
> >> that.
> > 
> > So above, we can't use dma-iommu.c, it might not be compiled into the
> > kernel but the dma_map_phys() path is still valid.
> 
> This is an easily solved problem. I did a very rough sketch below to say
> it's really not that hard. (Note it has some rough edges that could be
> cleaned up and I based it off Leon's git repo which appears to not be
> the same as what was posted, but the core concept is sound).

I started to prepare v2, this is why posted version is slightly
different from dmabuf-vfio branch.

In addition to what Jason wrote. there is an extra complexity with using
state. The wrappers which operate on dma_iova_state assume that all memory,
which is going to be mapped, is the same type: or p2p or not.

This is not the cased for HMM/RDMA users, there you create state in
advance and get mixed type of pages.

Thanks

