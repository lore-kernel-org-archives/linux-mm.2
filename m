Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69309C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5978E004F; Thu, 24 Jul 2025 04:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97076B024D; Thu, 24 Jul 2025 04:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACA58E004F; Thu, 24 Jul 2025 04:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBB6C6B024C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:13:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A71A140305
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:13:28 +0000 (UTC)
X-FDA: 83698443696.04.6321B0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9D7C180008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:13:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GZij/Khf";
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753344806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1lh4D7ByKQ17nloH+sYRn/tzYx1k+qXbegq4ryI+hfg=;
	b=Ni8q/SxmDy2DeR4aMpco1EfJgMy9g2IED6ap/841qcS0zsjb7HY2UjG0cQptjxdMaEoZMT
	fLEAe5/9CwyzDVuS8oF89YgDrv8l7ZTbiQU5KVu/LZwPYer6BnI+DvCysJ9Icxznnxtdj1
	MSQmS8ndPfe1PI6KDpja5br4WTxlLJ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GZij/Khf";
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753344807; a=rsa-sha256;
	cv=none;
	b=jxJQV8YbLGusu6aItO1qsjMcyvGwGTggJ/nHCrCKmELDGUEfhZQnNfREspzUfjTjukwz75
	GnJUKj8sKKc05t0cOitQTjRgyM2FPc6+GUndTLpAdtECO8/rqJkYXTqSHx8gutgHna6iK0
	T0AWjehWDxhtWwnKWA49mxIwlf3JkHc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FAEF601EE;
	Thu, 24 Jul 2025 08:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259DEC4CEED;
	Thu, 24 Jul 2025 08:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753344805;
	bh=TMHBNschFRg/EXbokl2TnOo376mtUvL9vCgJ968zWc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GZij/KhfBIUnbU4lbHxjP88/lDFzJVzpN+LpEfBwzehWsDkUfges9TR5IyiZTnUhz
	 OadLn/vpSTN0knIfMqxk1/W2CkIVAi3gxUO12Curbh72sdoAFUoZHMoQdkblwXYtCK
	 DBBS15tXdkII8NQBEHBXo5TqCjHgGsdp0FLQhgc8yB1hMi8M7wr3Or6XwNhMDDmE5z
	 Em/8soyscY18uKVRMTABiIjE1R3FnnTzVaf+jWOosD8zdiT3uo+rw2d6i+cCw9KzmJ
	 6lq4oh/7XQmhm5eJkFy7pTkaIXNXQvR9uEMZs2rWb31Otvoz0nnuBSZNCxcv8TqFNT
	 vTyCJMK4plyfw==
Date: Thu, 24 Jul 2025 11:13:21 +0300
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
Message-ID: <20250724081321.GT402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724080313.GA31887@lst.de>
X-Stat-Signature: k8pi8bp6ad9k5cqg8rcsgnphmz7tw4qg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9D7C180008
X-Rspam-User: 
X-HE-Tag: 1753344806-43726
X-HE-Meta: U2FsdGVkX19vKQ9TPBjLybsAPBtugtTc/oEDJAAyjtTBgCm+1FQCb+NlAIJ+3s7w9j8aaosq6zkZy3MKjtQlXfPp9VEKXcgIruEDzINzGxSfidvUYFkjJ/2UwPxhyYxakGzlIworM0UB2xWDM0G3ocRQKvqdmN3dEKk56RZs2YgMUmyu7JUhgyKL4lA6FF59d6/Abu9kHJgvtFw+3rDlc7JC5NE/oGk8R89odB1bwgiFVKWc41eyptjcBGtt0mdqjkIcZngDBGATIlbktNKt0FDXLkxaFtMYOPwmiwD3D3RrehzAawjC5hct6M9omaFDImndaoRrh1weOECiaGN94CxlwcR8Ea4sKD8EgGHeh1SQhcF7PvzGm5guRdzmiZHzbu3NpU+uZOrqPJOQ3oH0Og3m38D7HH+aJFBJXVKi4o7n6jCqggZDt56jDdwsg4+uaZjRAjtpwMOQ7KtIHkkMLdKcRUnIv90M0lTFcqDIG3eMUZsqFs45SJt4iWNC3yDGfKdyQBiEWx1KLHg/OmUBzAw67zcCpO8vZ4PWvL++y8Fm5A4b598h4yZZl75C7XJCMaZ9DpVvQ7sLGTF3ckmzECH4AlRx6ocibvUtm9kRzL3QF/lWJCsnz+MskDs9RHKd+4oIE2OEbYpqEuwB24VaNfuDEziEQXKIGJ/C2CTKsD1gfVm2KSeVg78M6k4I0jXRq3nAkgYYG5QxlpzLj0ztHOdmPyhWW/rCqM+4Dced8CdYu1VVMw8tpa3pbxYhc6aT924tWgu5GFZhD93aDGMtwrDotODzIinqMzmH4ZFL5YBUyq9CMC2+zGCgyQGpss3jD7Fdvs9pIOF+N9VS9WiGJz1lm9NH2oWGMLy8YIwsBTf8c/SxgzTWX0avSRxjeLe4f7TLtrjugJ57S+9CPFdn3oKJGZ/PW+4f4bKTp0CRDKhUvAKQq09jI6iLFhHtSFTTQ2544bDFKA4jEHeWoNL
 mU4jvopH
 W3oJbeBNnNnLe20HTHTf8UoOpgvemcxe9sQjN5j5xoJyK3Y1PAUQm21ONzeTpxoDX/ySgUlsTEgWM55ze/tUsjyUNFryUMCfa/Qb2MnN0gNARb/Ulo12LHxQ0koqWkG7uA2ZfXCfLY6JlU2eszpwIsmrYYB8PLm2Njh13P2gSfmYCjF88bj2/Rd240W17f074SoKRjZNnOIQJSdj6PuaJvNEFFXeyEO/ETeYAzLs+gimTuXWuq5KaHMIg8/XmHfrpnZQcKL7ppbOCyu4q79rvdTnaX478DoNjZ+VpqJ9oShaHjA1qzrUpRZ6X2H/ctwPQ34GmdqpHFdlphdU2Xc0sUhsYhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Export the pci_p2pdma_map_type() function to allow external modules
> > and subsystems to determine the appropriate mapping type for P2PDMA
> > transfers between a provider and target device.
> 
> External modules have no business doing this.

VFIO PCI code is built as module. There is no way to access PCI p2p code
without exporting functions in it.

Thanks

> 
> 

