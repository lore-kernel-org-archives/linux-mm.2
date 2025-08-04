Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A30C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4588E0003; Mon,  4 Aug 2025 10:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E748E0001; Mon,  4 Aug 2025 10:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736158E0003; Mon,  4 Aug 2025 10:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9838E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:18:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B84D459B86
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:18:19 +0000 (UTC)
X-FDA: 83739279918.23.7F21269
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4DBB100010;
	Mon,  4 Aug 2025 14:18:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcZdA0LS;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754317098; a=rsa-sha256;
	cv=none;
	b=4fqbnwA4mJ28oSpyDwZzQKardtoD7AtSVdnhYCgp5b06wT0W7yZvtk+nsLRnLo0ZtAmLqd
	I6IETzaC8+Ove+kyYZ/CtEt7/NyWoWWbb9CfcFOavahx8KQLRedBhMoG8bPmAXjrIZaOnj
	tUA4hh9A/ESFHfFKTCESQEP00y0JEjI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcZdA0LS;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754317098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBGemonBUIhP2P+1g6qjR2CC8Rhb2C6+b5JiBzSqy14=;
	b=sQ5oTQqy6wMEof0DaPInOb4KRrBW5/xmgOLkjxMY5egbf5shKxcCur/MVGrOr1WT4/+B3t
	pZlyLf7QIV2cGvR6ynEL/i3s8WmIcKqldlu0NaR/xZs0xqiI8TlA4lj86pyv7+Xrdh74OF
	1k+IMq4qzKLhpuABCaEkNNIBM9otwZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AF9BE5C611E;
	Mon,  4 Aug 2025 14:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED16C4CEE7;
	Mon,  4 Aug 2025 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754317096;
	bh=Zr3kPkorN9J0wHoU77coJxVhd5vO47zAf6WxVna9oFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcZdA0LSgVnIJ/ja+rzujOZjYxEuQpnBSSJNlhmM+uIS36PMWIvxGnxJBKVGS0y/k
	 vBjKAwytVDKvxwg3o4C9JLt2cc5Xf3Ulyggy/L7MyOHzWrqYM35ShQ8xJDtl2YOAB7
	 3wGRmkXADNX6dFnB5tDVmYtUzfYrZkmqh/fAJX007BI21XLotatJs14FAYy7dz2Pqv
	 Eb7LFQAA4+jV/XnEzEvrRUpolhq+I8mzh+IQZcnXLb5j7+5cmwoKzIv7/4Y2lgrdRR
	 b8oxjcA0vaYNH78RQuyAh19r+u1Tc+UWreSga05cOcSy8fmAwfSkJk+8HgQjXZFhcc
	 /nh+mNJsc6Ehw==
Date: Mon, 4 Aug 2025 17:18:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
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
Subject: Re: [PATCH v1 00/10] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20250804141811.GT402218@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <20250804141032.GA30056@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804141032.GA30056@kvack.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4DBB100010
X-Stat-Signature: re8icqydm783z1q1pkgt3abohrcwbm65
X-HE-Tag: 1754317097-975283
X-HE-Meta: U2FsdGVkX1/rfiHSbMSgRkX2BECkgq/3XFapkK18s9WI4GZSpgvRR3nNReJXf7eXScHhyWaAxUUaNsR22vWjNDNJetT7cVurVw3i8LxVDSqJ541JB61EuANEwU+xyENQdQLxHRMizt0BIGwswyGsFXOEUvtfHEMUsEc5JICOzfEctFTbGGd3amlY4x4hJvqFMP7fHmlSiKSX6g5TsYDWW4M9jJABliyn3aUkAFi2tqxBfeDcEYgWEY5BQq+Z6EWahtYpbwiVU2lI2c3OPEXn8w911IE3OoRqF4U49iOHK/iTqywMgPB1BKph2ODBFgpxdZ/8eYP3BACg72wJvvZNckV2wp9KUC+ycYIqChinOGssvJ2IhliepMDP8cKYApNQwEkn/BRlJHm3vv8U0V47/c8ZB4LZBEJT0kHUDFulhiWu1Gc+zS2Fm72eavwAWJgNzjCSbq9bXmc2nZ9Rma7m+gaD+6W0fWDAUlwvpXf6UejTHA+1C4HNXL3UOgBDCoQzozFh4T7r2dENlYMlY7PX2kajrgBn6kkYUo/2Yb6aX1BaA2cFkL4uLjwSeEViFuY/lrlJyop9fglgfbsYYENNONBBcvCPmWvH5T7RJEqffmXcUQ8HGiqwRc48clu/tjNDhc3ZaFkS339RCNDPuuwvfG2ZY17Uzwyf7dpD2cQJwWbPn244IjnaZzvcX70NkiRG0nLGIvbD13d2QnBJkpK8ad/3IiLfNdXSqGfBQX97nRrsqnui8eYTf8KSFitglyJ5EZh2H1iX83Xi5zVQ1CyVIDo4T47hmyd9FZ+i4XebrDcTBUkM24uqRW80/ZbZ4ZEbmIgbtfoy9K5P5EDNnUoI5ZHcivc62oQaucGqmn+YmkyhR8dFo222trxyGg5OEojNeiRXIGj8EP0ImYYG+g4MChspWdLfjAtqBxNf51lu0Z0NYmjnZ4s6HGThjnlYZZutXN0Rf4HR5WwF2cQvPQ6
 Fm7ifnZZ
 D1Q+1owi8H9W4yBy9HwJ7S6zAnNsYJBs9ma5jUGvJr5yVP8h92Ixpx78dmuMueMrC4UKft6+iZM2wJ1nbkedqWMv1vzMlRiOhQyRrqdY5Yz5rUmRCiQ8C/HJCPytJL8pHuFh+9rXBF8eBzIk0xT/Y1tC9NrbhYuBDz9XlXkY9DuHbO7etOXMgzAsBFMxdrjeia1A4CGhDLQ8hMp6uV9E+NRVuOBwVk30+HTrbZ6y8rRohCYcNwCViysJ9wotvVbmTZzozoVC3RNpmr1biuwatrQ9KtUliOjRYp3MTPyH/pTnf+/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 10:10:32AM -0400, Benjamin LaHaise wrote:
> FYI: this entire patch series was rejected as spam by large numbers of
> linux-mm subscribers using @gmail.com email addresses.

Thanks for the heads-up. Are you aware of any issues from my side?
I'm sending patches with git-send-email through mail.kernel.org SMTP.

Thanks

> 
> 		-ben (owner-linux-mm)

