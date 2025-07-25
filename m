Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8D7C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CEC6B008A; Fri, 25 Jul 2025 14:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDA76B008C; Fri, 25 Jul 2025 14:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3786B0092; Fri, 25 Jul 2025 14:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 924846B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:54:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 402C4113BC5
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:54:09 +0000 (UTC)
X-FDA: 83703687018.29.8A9C2C3
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 975A54000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:54:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2ubIJ87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753469647; a=rsa-sha256;
	cv=none;
	b=kTqOYQkMSdDRsy3btG13sALxj9vYGQU+r+WV9vynfnE/T6pw0TlYOjRzmbvAO8NzFh0ckN
	O4OjXRMLXdqNcIdkBDItpox6agzz+9FxWMX69hX7J3TXzkMh9xKaw7M2yKffBom6wwSnE9
	Kr9Pa555rewrtx2ed3mycfEkXF4JEpA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2ubIJ87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753469647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ci3V9rQeA1kjjw3auDWTz1IQ4zqovrPqQ2QT9QhGoa8=;
	b=1KsjsszA3m9qrs9scxpmjH/GHBc82yUiLYX/EIkePf1dD+sPSSyrVaHBC+9c0Ag0BVFs2i
	m/K/d/i6ZsMul/ivjjO75QUtQIkJlJzhom50s+cfDCvWFjz5Zh6GWXJM09a4noEL5IL3Sa
	VP3RYSN4IcUrzu97LtnBYIKS6aRQFks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id DCA56A566C3;
	Fri, 25 Jul 2025 18:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD2C4CEE7;
	Fri, 25 Jul 2025 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753469646;
	bh=igch2/Ss/D54GGpcC/mqrvyLfhLMkygOnI5MXjmAMDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2ubIJ87qi+xxbcVIPpnJmq41dKhjQJt63te5mxsuN+D+u3uTt6SDzjPKEApLaF0m
	 M+4ss02eJ1sKTm+IM2wtDSadbEpdxJWPu3JT5UWSN1SsfnLBwiz5/0SysDkUehZ9Oe
	 ZyYDXvuCB4uN9ueMrFqDj6Efdvfcu2tt1/iKKIFs9MPGEofYVOtBWne7JY9eYjl+yk
	 kD3GlC1WRNwoIP394nuY7rGTter8zQVf4ItGOtklcJiCzD7GvWswGgmUIQ+47m2dfP
	 h6z/KX9nBHx/erCsMoi3GS1JfKYY2Yp2uZC3rkuLFmN/1ml0hRbHiwRp9P95+2n831
	 jW81KBhbVrGuw==
Date: Fri, 25 Jul 2025 21:54:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
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
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250725185402.GU402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 975A54000D
X-Stat-Signature: 4yztceg1kzp8g394f57u86uthyy6qrbs
X-Rspam-User: 
X-HE-Tag: 1753469647-296532
X-HE-Meta: U2FsdGVkX18JQCDMjL+M+4PC+j+diLJB/VqTqLhZuhYVo7k2XmSVv3f4HWp7MJs7L/Ok1oTMju1J+9pWeYqPXivNLMgJQgv9qrUMPNxva0MYiF9CuydVbQcCBqQyunaB+qlp32o4iiASDH9Rwyb6N3lsrM9S2AWbdXr0kRlKPSpNfy5cyg2PPXcsWjzdv8+g35Xe9UA5hGcU2QLa3YH+pos1O3lxoimj0+6jDu2z2NRc+jcsy15fy4bYNUbag/ygLoz4tCzvTQJQyFqvphu+ucsbXR6jCLYZn0OMq4Kfy0cq2+V52oDSVjZ9Mxp+Nt8tDcnbTrAYTEaMMysyi4egF6KDCtmsRTOohemYveje8JTqYFKN8DUZXMV7C82K0graAmxlBNckWNSyDmZIyyvgvq1Ncpewf4oBdQU52UqFph1btwWxllu0ahJwZ150BE09LO2tctGsT36JmQ9AuGrMdz37xSBEbvjiXCdURlt/D3mWZLmvJaP7wJnpJEWRvy1Xc+y2vGaoT/L6HzhOvAy9NuIG2hTv38jooer1KcrK6TnwNShBbNaYU8jwLbln/VxxYJZXZ8r96isT/xsZLOH6EL+DF33wh+8GaKPaCvRygX7hR5cpWMZe9wkLy10xs79+6iK06WA0A1M5DBFmSHlP2YdbsjZ2kU+hzCb99xgICOIRmxdS1ZXUukVd9ohBGEXu8kxN9B4QhNV2IdcFzG/dv98va27jjARRyXfwaedOqa/TbTZ6bc3n0FukNIOBwSwpNoP5quampoS28fpI+zFSBB8frnnAF2BmzwvnwxFpNxmjzPpmGTuDHqp65FoAAGqqMTC6SFsMuJ8y5qsPLeLltwVFNlo1ROAIEFGPWIvhq4JrWZJQP9uRMiXPldepY+Y2pwWTcbYs04q6zg+2VqDmjYgprZmh7Hn7G8fZR/jZZPanTUs5wNzLSa9pzEh10AA0IjoXgOQHK8/v7q0tNoD
 XxTiuVqO
 OpoCt16DWb/mqI2EXwjDy2ck6jBjon00u3MBcb3AseLPzjB+Mvx7afC78kLkIep2o72CgRDP+qebtNq7WIGogjtKQcpjFmCcMe4NYu5w8mWgtUDLcDFVU+ZeE3mV4ARjAvVcw0tsFrZb+ZQcouHaMPuskxVz04SILTix+VPSbL4U8RCK+8//rJBVRr1I7WbWU1ncjximxkOpBIMjYFsJJhL6pR6B9GriL30+kLdmNp+YPP2Tij2Hkadfsazv6UeEZZ6s8X1nygE+KyHcF1MQAx50Gh+BVB6hEvPtHerPMPujAAz+DXHSneSuLmO8vr5YBoQLA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-24 02:13, Leon Romanovsky wrote:
> > On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> Export the pci_p2pdma_map_type() function to allow external modules
> >>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>> transfers between a provider and target device.
> >>
> >> External modules have no business doing this.
> > 
> > VFIO PCI code is built as module. There is no way to access PCI p2p code
> > without exporting functions in it.
> 
> The solution that would make more sense to me would be for either
> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> P2PDMA case. dma-iommu.c already uses those same interfaces and thus
> there would be no need to export the low level helpers from the p2pdma code.

I had same idea in early versions of DMA phys API discussion and it was
pointed (absolutely right) that this is layering violation.

At that time, that remark wasn't such clear to me because HMM code
performs check for p2p on every page and has call to dma_iova_try_alloc()
before that check. But this VFIO DMABUF code shows it much more clearer.

The p2p check is performed before any DMA calls and in case of PCI_P2PDMA_MAP_BUS_ADDR
p2p type between DMABUF exporter device and DMABUF importer device, we
don't call dma_iova_try_alloc() or any DMA API at all.

So unfortunately, I think that dma*.c|h is not right place for p2p
type check.

Thanks

> 
> Logan
> 

