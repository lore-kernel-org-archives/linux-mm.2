Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26AF3CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1147D8E0006; Wed, 22 Oct 2025 03:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4F18E0002; Wed, 22 Oct 2025 03:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1738E0006; Wed, 22 Oct 2025 03:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C266B8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:08:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84190BB27C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:08:59 +0000 (UTC)
X-FDA: 84024873198.28.F70812F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id E228240002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:08:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SdNtRvN9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761116937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9tFlJ2fSBgWVG5dQp+BqV6oOUweYHcntX3sRf6YFKM=;
	b=3Xg1G9FttW/6iTuGx+HUfDRiKNI0KWKkU/WqMsmfRRVDlyWtU8saHkxFbORn7LqQ2jI27/
	/9Pk5rodlqJLzWcZd5E7ticZPnWdT5nvfkpU+UkNx+bdjo22RllSH6OtWBE9EL9skYexin
	hjmWcnIIivcp9zp0rksT9m77NxjqLnQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761116937; a=rsa-sha256;
	cv=none;
	b=XDmRBDjRcmSfm7IqTqVd2WbcK7I5vBJ2UZf0Q+qmcG4GuLvY4dBrL3JKd891SRNOIC67iZ
	W7pAgc55SwHKLedsyxarYxjk0ROFB3HWv3NHQrDb0WaLYQatZFLNxIFFf90lWUJzECYca2
	lqwcKFj4l5DGMD0MuMjlJwbV+RG6Jcg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SdNtRvN9;
	spf=none (imf01.hostedemail.com: domain of BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v9tFlJ2fSBgWVG5dQp+BqV6oOUweYHcntX3sRf6YFKM=; b=SdNtRvN9ECbH+6Wq5VOUBng1tV
	rbcoTW7YrrfUGP/4J4whwouG1kDyvf3Lmdfi7LbnRPq89BMYv58xbUTBmXgSPXZVYRb6mJhJAPQU1
	ZIA0/wC+S1RJMhiGYJjhCAdfm4FEwCrzY3g3l4cgwQjuPypeTpyBjpkFiGnJ3/MzMXNCCwCjSZrzm
	n6BBFOL61exQBTv/xlQB1DwMELcEAU2ArzUgD/NYvkI2kZUkmNNPseZu9Lnk8f+brxHeHjW+o2OQa
	50dWmbeHSHNr0vGLwBLSjUlfEwJXoZAmppaRqh0WNeM+hhzaF/nXElPtxtD2OmafhI0Tejkvpb775
	0PevGOYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSxk-00000001oCQ-0f7W;
	Wed, 22 Oct 2025 07:08:48 +0000
Date: Wed, 22 Oct 2025 00:08:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <aPiDACJHZY7Gu4y1@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPHjG2PS5DVgcG93@infradead.org>
 <20251017115524.GG3901471@nvidia.com>
 <aPYq0jQZOrn-lUJW@infradead.org>
 <20251020130855.GM316284@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020130855.GM316284@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: nty6z9b8oydtisi45wa7pa8yhe5c4fso
X-Rspam-User: 
X-Rspamd-Queue-Id: E228240002
X-HE-Tag: 1761116937-688321
X-HE-Meta: U2FsdGVkX19vEYnGrY7m2HRlAej3cFonjrRk6COBD1/gaqniLK0YHzSSX0NnLlfDGHO8b1W7lkiQPBs/M7WH5AGz31weTZLfcbMvUvvyzo1nCtnlIxgwVy/BGFO0jvWsNpUaU+k7CxxoYWVAYiwgvY5owHeVRDWo8q/P9hrLd4BJA3yAZE4hnuQBmTyP1YbTRd1+Tj/vzcQRq+Rwk02vS0l6frv+KmMl5ZoODccfoY3hoNzn0cJCM7ZbAuE0i0nCz7A1wUCINXpmKUMdvX0UC/SHp1xhYG+7rMPHWPvv3DS0HTNp/yjaOy/ZFFpu/F5EF+cPAC+ybWHo/lYyc78v14ZJnxDM7agwP+zL7wJYKdJGLM47jhY5T/qyTw2I25Gj74PHoPOj4VNjJ3Yk+vgeGg46Qe0+wDkh3Yu67N65sTAm5lJcnaSua87PBk/1/ktDmG/hN6oI8kULO7ZbSfU+qsxki1wZpaLnvJfecRKRfRgojuMgDZtxew/tsl2hQhkJPtaDnwgsAlNE9ktWfyqmdkqeUo9N1Hzj87qh9phDRx3aLwD8fuSk4dNejw85MJ9EtTn5+QXJazgNW7sEaEQqSgr4tHkVjNKuAhkVuW95ViPTsi1OMs3ttUvc6lBDd7quZj/0JKilVfETeR1U0+FhD01cgXfa7OrEtzy4/VShVi9TxqlJiCe7KgLxDekQiLnxCEYl2i2KsaDD95HD2XrdfJxT+gpdFeJdSFFv+FnSl1wgWYnJ4zzD4/lhWk+lBCAuVSoU4Kh5EBx5TCz0fOQ3Cnx6GkoBoWGXfGaKqoumQrQ3h0jE/cGtkDYaErSUNBI7li5bcG0rxEZDY4PJNf6gqLN1T5wwEUtyMtLN+q3eDFctYr5hMXxkSTo3jlhLmdN9tzbSb2IsJTj+PNOksO0Q8ZQk/4/IZNX718JawtyA+wAZQ8ULN/Ag5xJLhbk8DmaSmqGObmA/KLexHc6PwXl
 K3QKsTJU
 ldChYOlFPCoVLyaWJeAOW5RWZGdGydu5QClW5cK0FDWQh4zn+Ma6uGkBhc7nvcyEQrLMYbHvDWfdg4f4Z4U82HU6Dfr2qQCNV+qZ4meoxRJHj8VHjC1cFPP6pzbAvUWiriROeEz/s3eQfWzCPMOldTntkmUHbiexdDa7ZnKWgT/VEpgjSggw/HsVMaB5eTQzsC0G+q8TLIrMKiAMbOwi8CoSdmpQmcU8PMsVkfbT+uy20eHgrifJmsbXGUYHQa/fz8t4radACI9I/zKxNZ2wjyQHk9m2iYr3qCIB4mTQiNxahWdXcM05x50pPf3AxPSHGuZGOuA2NhBDcczkXal0M9/7Zu1d+YTlPUbZCkoC8FYlF13SGa3JBGsJNfe9XbqPsviR7i4qmehvvrPFcYIGgj8dxfhL5D/PmIL2NStLR3T2ss64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 10:08:55AM -0300, Jason Gunthorpe wrote:
> Sure, but this should be handled by the P2P subsystem and PCI quirks,
> IMHO. It isn't VFIOs job.. If people complain about broken HW then it
> is easy to add those things.

I think it is.  You now open up behavior generally that previously
had specific drivers in charge.

> IDK where Intel GPU lands on this, but VFIO has always supported P2P

How?


