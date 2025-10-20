Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F212CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A46E8E000F; Mon, 20 Oct 2025 08:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654E88E0008; Mon, 20 Oct 2025 08:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544318E000F; Mon, 20 Oct 2025 08:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4E58E0008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:28:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD1E117053
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:28:09 +0000 (UTC)
X-FDA: 84018419898.17.2C99D92
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4EE68140003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:28:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bBc3P6XH
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760963288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ETt/cIS7y36wzPdSWatPH0bjRaT9Kgy267Fn9GummA=;
	b=DhXkXtfARiEJ0BRGmtSWWZJlcVMhNt77kI20mLPjoHmEOFVQ0CLhEYNlboWm5uovqwCj3f
	lK3OK0DYfrM19ylCiiKVjcl6/Kro490GY8fMuTcu2wIslhEyJX1iYhjsWbUYw21gBOZqEQ
	Kv06PCqJFslpBcMkzFHrYKG6alP8+mQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bBc3P6XH;
	spf=none (imf09.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760963288; a=rsa-sha256;
	cv=none;
	b=1bZV7EGvFtwGNDVoFXmFhF3/mviq465iaiyBMX8u/ASyzOmhiXzzKf8nD7Fc3zjgkNcT78
	zMryUT2sNW6XEIUiBIYejNwQsf0JYba+UddFAobE13bXANY1Gny6ORVxjrfoyoFTTg3qvG
	i6SZ6uA4NbB5mA5D5pKgtEZzAmO6zQY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7ETt/cIS7y36wzPdSWatPH0bjRaT9Kgy267Fn9GummA=; b=bBc3P6XH7OO6YaM6cL+h/RmHiB
	pDsB9AwmEla0WgHxgeNIiwwubVzoGXiigjeTvvej2RHeBXuzYAo99jNSU/Y44MSsDSW2oaom1jTJS
	yiWdm/IfNyvT3pB0m5irfyIriyKYefci4PDagpdEftDl1FFqk7mB/Y92Cb+ziu1dqwrNVNnTYbHE9
	BemCDU97SZrbmKGLwQHL7UIMD1F7tJWpFBNqWqCpc+wmV4bhsvaJiPHQ5CvZ1lcFlJVQfSSyFfMLS
	AkcS83i+dBFyjGqtFgcCKRA/A/MjU/IhUJR4CHIoZ2HclrlrsHruKWu6PFSUYnL8P2+TyEfe+KXQU
	DQeNiswQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoza-0000000DPeN-2I74;
	Mon, 20 Oct 2025 12:28:02 +0000
Date: Mon, 20 Oct 2025 05:28:02 -0700
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
Message-ID: <aPYq0jQZOrn-lUJW@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPHjG2PS5DVgcG93@infradead.org>
 <20251017115524.GG3901471@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017115524.GG3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: fdum1t4murx1dhhrgwsa4u8cakmw6h4t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EE68140003
X-HE-Tag: 1760963288-993090
X-HE-Meta: U2FsdGVkX1+aoWTzJecljDJIqZFOkX4fDS0mMZlAAITHD7e9moyE4CnleIMFnBfWBnCtdmMXTdoGjVxK6JM26/uj2zVUHoepRJytN35tPfSgzTfOLnof1KCj9F5pfyuVEIcjGbZJ5RyDkO+k24YQHzIZ5y8gHKr9CnPGqxzSqWXlEtG5YLlDQxVQZmSxC+6fpb9LW7WbkA4KWgxaUs9eyetX6tV7zJDWwjP1mL8NVJZIfYpSXYQoTSn+4T5HldunaoChvYhlXZKhHgtrR3zA2LnXdL8aRiabfdv41P8rgWezarLc7Dj8++JBqwfsrtIIVYZPeR5lHLOJkTBQ2zFojhJrVea25ABdNO4mLkUy23H4mMLGoBey/G0jzqcrLyU8u4cSk3tYF8b9XwOYZBSza5LtUZwx4/jdqOd6PHcTiWAvpNt0z8AMUsJQNwcOYgsJdBvz3fGJ5lO3sDKpWjSL1Vs90tfvBp0jkfPEn1viJwUc01cL8SRGyImE2lMKo5mKLw1tojDt+MixUPNmjwagMWVVN6YcxxNkyNX7Qpt89NB3NMZzkw/QRdNphjCsrmDwlviOkxTQ2R7C9XWhpTd45lk3AM0Jkyb6uXiDkf05yIHpwryTCr1G8A8up1cjEAO11xlqRNu1L8ti4k3sOjMhd6MOgFS9c0UyJ6b8UO+e/ouuJRmLUrhpNiw84hT+9OdyZVwwAeHFUiaIXB128p8mf2hgpKUw9+ai8i6O41WnVil7I/kinRUmufbBf97gdxKaGnLuSQDtdi+PaGHfNLZQR89OJ0zPL9qREiyoIgpekEcd5BgLBwfzWprDk1F6tESm2eAWqdps2KBKxKfh2gL0MY+yb2THauqqJ/FUj8us88m5cU3pgYh4yW9srk9h/RdoAfb42BDalrN0dJX9ZGzbrYuv5fuQ7i8p6S+qfjMWl0NwEVlaP7AYCKPzqC6711rA6jiZ7fRm7TeMAgspja0
 Vh6iAWJL
 +vB+WltzmsiLboLALtnQTL2ZieKjFuBPJ4F3++o7ba1DyJiMR0o57ovCOTEqx7Fdl1dC1rjTyqpqTscT6xPA/Jdn4GHroxDPCgZCcG58lfQD2eGx+oG9f+d0hA6t60Mmw0VdrukL9onE67TKWnHJ7V8pVw6DkJrhB85HrFu1l8Rh21a5uhVGkCB3DEJB1lzAyBFLti+3T7VeGTYqMDtyzdhNMP2chuCiayn4axWBCTPrMMhHCgwA4AmRIx6p0A0XxfRdcosi/Q0q9E17xzeTCggB1BPjfcMxZrQz/j2ksZzHjUaFdRN+EsxEWY7pEy0H9ll0172TwcvWQ5zaKZysZ0M738MMI1eaWv77IWLlVH98l3Ks0FMsaRMmjEAjMQEbvXqTI5fhXsQgti2oPT8TTkOm3K5qIgrrkYcsUhayCpckAo0Ia9rldB+C10/iJRtdBd4vSwQOWohKp8kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 08:55:24AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:32:59PM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > How do you know that they are safe to use with P2P?
> 
> All PCI devices are "safe" for P2P by spec. I've never heard of a
> non-complaint device causing problems in this area.

Real PCIe device, yes.  But we have a lot of stuff mascquerading as
such with is just emulated or special integrated.  I.e. a lot of
integrated Intel GPUs claim had issue there.


