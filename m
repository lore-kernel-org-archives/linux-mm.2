Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E451C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D763C6B007B; Tue, 29 Jul 2025 03:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26BC6B0089; Tue, 29 Jul 2025 03:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C406B008A; Tue, 29 Jul 2025 03:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2F166B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:52:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00C5380563
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:23 +0000 (UTC)
X-FDA: 83716534608.19.CB5F1A8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7556B8000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753775542; a=rsa-sha256;
	cv=none;
	b=rTHOIvn2O5gfibhBHFWLUmhjTyxd6EGvvAYPe0zSja/ZAiOGW2jOAjzxvF1Vj2wrHsueW9
	wTwN4QI0mdD6J/PiAo3XOsdxK/bbZmhYnuZ8LRRjkKWQZc3ABu+jsGH6r6lMpnpt5K1nsy
	n/WFnOJ7qIBIOnXJUcZ2hv13Eh+h5TE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753775542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4BqNBblvZFw4I2ah0IYwccgOe8bee7j+LEUqsvY0Jt0=;
	b=xiLBbIlKYCswoOFahKo5itStZQYWuwtOFP0IJVMrNPgaMjwcxYwRt+khFfKOoFyaE7rbIL
	mnOqaWz7gt8WeVt1OHEy8UZTDQ4bd4TAq0e7toSqTnDpMumpU6piGOpkjmrGzeYXG7dwHG
	8WesQb/UxLouo61RRTBGSBEJ3/wEBJ0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B85168BFE; Tue, 29 Jul 2025 09:52:09 +0200 (CEST)
Date: Tue, 29 Jul 2025 09:52:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
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
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729075209.GA23823@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com> <20250724075145.GB30590@lst.de> <20250724075533.GR402218@unreal> <20250724075922.GD30590@lst.de> <20250727185158.GE7551@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250727185158.GE7551@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: qsznbt3kzmy3jb9peqt9fdc9m7y9g1u7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7556B8000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753775539-457587
X-HE-Meta: U2FsdGVkX1/X+FkzTDFetQGGUhX7zeVxJyFpvtqjXA3LMM3J2jbJDpsTmn3e8liKHX9Ag9KM1R/JsV8M6Rlt1JKwvI+kA4HfPOe5rRc/IfjBg91dxD5W+jFrdecSuR+fKR3xWVkjji7XBghxtPoYEPlwren1fdkKs8AYi4EDxJ0uFydQ3fu+syp+UY1u0tW7FEB/NGArrNpz16BXiSegi02R8j6gg/6dVzsN4QaWkdOwY6O3SM4jAKO1jZNXB64noQ5Xk0fRSU6G6NOpeIs5Sn8Iwj5B2xWfjB/VnXQnfNwWtqrvjChsf2h8GmHjIp1JX0Z/c5990kVOu69F7ncnoBsckEx58RLcWRBe5V4rgx+aTvQM4LxHZ88GRsEQLeJDk/YbpUBkZrf3zxpmIkHF22KQcfte0pe4jaEg3fLbKauCqzTwU5dgKS28FKqM2LoGIKkal1fxVvtv+sNyK+abSZ8C1LHr+coDt2bsiRkNim95IxEemZXv1/kdnjKLVrqo2DPtEb/z5hvBDIFxmDk6jifY5CS+x7Z1GIzVU4Csehz54pVJQCON8JNO+zHTZDM4AI8D9HLNXjh/ASpXy1KzaZyMjioXq7ZgUAWUAI2LaryIyvveSaLJJIfmSZNgg7sqLQDL9qYqbglga3gZmvRDK3ldxV7ASqPkbbYQoSMooEb3/VqFAGtEwqkhXCtE7AJTR4KTPf6t0yN88TZYsughVGjW90+y9ZK+G5oPhmNy2HfN3wW+vvMUANgfUY/OwgQa9gZAyTV7DTw45XCiEn7OkYkG41FGZM5zXvvLcuocMhYaqgcedvJifdSX62DTm+nz8nNIrDB2/uXzrNfWANy7zMjkXpGXuQx2qrVm66e5lutd7F93oSHzorB1B8Nh1+/fHcLu1s7QQBe67aA4B3XO/AP6Ei0gBlLOlxn5tO1F5O1V3ibqeNlBtZig/Ion8ebAC9W6SsqYKj0Q+Jwj6H3
 wxBPiB+k
 T6Arva5KOAN6dvrmHkXLnBiOkSMGt4cfyC30Vr2Xv9vZapV90DNOEd3AIJRbzJUd2lytoP7IbQ1+iiciPXhYefNWemVi/kG15B30XBdafUZxMzNjsU77CqqyS9L2EPcloGBCqbMHZTOR7GUvUtkNwsCPNbL4h87eUg2dwfO1UpJPrzHcsTDe2PocX+JUa3TwuHDSQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 27, 2025 at 03:51:58PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 24, 2025 at 09:59:22AM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 24, 2025 at 10:55:33AM +0300, Leon Romanovsky wrote:
> > > Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
> > > It gives me a way to call p2p code with stable pointer for whole BAR.
> > > 
> > 
> > That simply can't work.
> 
> Why not?
> 
> That's the whole point of this, to remove struct page and use
> something else as a handle for the p2p when doing the DMA API stuff.

Because the struct page is the only thing that:

 a) dma-mapping works on
 b) is the only place we can discover the routing information, but also
    more importantly ensure that the underlying page is still present
    and the device is not hot unplugged, or in a very theoretical worst
    case replaced by something else.


