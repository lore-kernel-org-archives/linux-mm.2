Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977F1CF8552
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB936B000C; Thu, 20 Nov 2025 02:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3166B0027; Thu, 20 Nov 2025 02:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8486B0028; Thu, 20 Nov 2025 02:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B722E6B000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:41:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F0455AD14
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:41:44 +0000 (UTC)
X-FDA: 84130190928.12.24D2EFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1B4A4000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:41:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNiHfv2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763624502; a=rsa-sha256;
	cv=none;
	b=RSTckTwV6Bl93Nx4/q+8uJHSE0x+94QLGbxp5QNpPvO1QUWrtjrmkbfUFIcW/mGwHft3k9
	d2yBeWubCku5y8w0c5wHFYv9FfQkcP4DSQ3dOkV56CDb/UUsh2as+HnIM1xYTPz6yQEeT+
	IYBcX4MeLIZuUWrQaiBHhljvbc8z13A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNiHfv2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763624502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfqYtNxij4kuASY4+wMMmALDPNV51BUV6YhNtIIpEF0=;
	b=j9b9TW5uHmjut2SuQLWO93M9BalYm8uuQ2Jy3FsJ9kK+JR4pauy5W4K8O8tvmZv0l9v0ec
	qBqjk87eJTZZWY9wRVazdQA68u72wSIHwtbQS0Mm2AQb+k0KmugR2L9xiE3JzMHvTnq/m2
	aC0Axl4w/8J09ebq/tJPezG/ri2rKk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D72AA6011E;
	Thu, 20 Nov 2025 07:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE678C4CEF1;
	Thu, 20 Nov 2025 07:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763624501;
	bh=RzCrc8OP4MQJ51Y3Cp/KnGNHr8pH8H/uOuzXNgsdf0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNiHfv2SAaFyrrm6ZhCR8ucSYnRrrdzPojcMIcohfbtDqJS/JJSe9Cm0EPsn0RMT1
	 9FMh/DEL9DggTQsNRNFC6ZevNso3DG/8cJnjGqx1F973WBJx3zNUrkfRwIJTDtGniq
	 T1iBja1OPDeFawU+b9NyxYO1eLXP5bDXy+x7TMExTwuaVkaO9yRhyCB63N85FD3fx7
	 OxMoyn5s+7tJhzxI145c0GzmDIWiwooPR63zC0GIQoVhzfmUIy/rjbN0wvDQAasxv8
	 4RKMSzrJoBj9dPKY+MZCCAfPLwtiZfQrtzxCUQWESd/6QU20I/oRvqEOXzQEx5F9s1
	 fwoUvg48Mzzlw==
Date: Thu, 20 Nov 2025 09:41:37 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251120074137.GR18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1B4A4000A
X-Stat-Signature: fxq3i6h5xdys5m481bjpw1ggkdh6xdxz
X-HE-Tag: 1763624502-766301
X-HE-Meta: U2FsdGVkX18r9Xj/AxZvNcrockUL3iwtWIy0u9FrroXniu9j1abF3knNj2wOnTV9UcUfzM5MB4Z5g5zU8bf1vsA3mzaiKYgmelVJ7s7SMqe63odUy4s5uMXOT+RJkmG7UN5C7Thqqx+sBorijD+x7CrWmLeVeXzMNVF19mThv4WRUm8T9NCCs4T/z8UeXD5DoYPkh643lKiumdy1KT5Rma1xnHcdWq+dxigPIobSBZo/8ZoDl1/7x1m6vFTMQb1+4XVPH4VCY8RuQKaJe6BEVlHZIt8No4sMvMap6xd1x1xAzAzmi6EqKY2RPcaWkuquTqX2R9IIpbycjjZ2fbu1R+Sbd4q+qvplojkEBhl5WgX5c8BsFO+tEJ2sQ36mWYWXU7s5mTwLZplDjy8SK4icZsdsqeaQ5/mOUldAxiOheIxOVIzdqNR95hveM4OlC5McUadV5TR3TdZeJMALW6Bf/x+FCyok+nE/NJ9pCHpPFO61w+Cjap6QDcDhxtJJm8RiQ0oM59EBQUEYrySc6XzjozkTDP+Mt2bNFm0IR5L6BWZ4w1q65I1zUH59rExxcG62lcTBydQ3jcT+6NxnzD6NIsm2DvN+znm5ItDCuM/rA75ixOttWpkl2FJD1ZhoPZOOW1m4G4S69Jp8j2w/ZdeiOG/C7vFaauLHKXjUy9xjhiJpJATGkZjOh2evN4v04DvZ0xykdE4aykcj6uSznGoNpKksPucLhWwviH4gYOeQQGK8rctMX0yXT5/PCksZ9gAV5ff2R83wecpS5DXjtJ+qu/Ha//E7OVVZX3B79IYw2tuK9I0qq79h7LpwvW22zSyuwnNDR30nneJ06pEMHU+u8EGHJRyLZu8saZHDin/2smaZQnLrEkPT8rM04jhQIQ7ccB65b6OWi5fjWkGjqQEo9+1SDN0a1w5ujc8RWFtyLwB0DMjoH3VlyF8GLmObsU0RIGm+XoNljp0YX98vCQp
 HFW5wGuq
 ss0QFpGuSqKhCF9sNcoRrhGAaGCNYpRvLWUR479b4cC0v/lSdoG8PpYTNywAEyNVMJL2Lrlasz9x+27EztZlGtw4RHTOWk3Hmp71vdE7o9y2M3Ef3AlHlcCReiT9Eyio6xLtdzCBhi7bG5PgIYyD3QsZehg+rcbrM1WJ0kMsnJPYMGZKWN6EhQu11KbLWbN6qZDVf+YPZFGdxV2gnxF9WyfUNXkQz9EGyePfrr1m/eFjb/QYn47v9HL64efTm5QnOMvtEhQxzL8Vs4pZ0YY+MCbfY6KhYO0juCzHsEVlcjY8286UBasLtuZF4bLu4wPkUbtwybl2czuLTsJtwldv6RY3AavnsQR87Z/SOJaYtQwTwtxGIAq/MphMkejvuZa3a4s6oC+TuuqlFJoV4/oAGnRklYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
> On 11/19/25 20:31, Jason Gunthorpe wrote:
> > On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> > 
> >>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>>>> +		if (!dma->state) {
> >>>>> +			ret = -ENOMEM;
> >>>>> +			goto err_free_dma;
> >>>>> +		}
> >>>>> +
> >>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>>>
> >>>> Oh, that is a clear no-go for the core DMA-buf code.
> >>>>
> >>>> It's intentionally up to the exporter how to create the DMA
> >>>> addresses the importer can work with.
> >>>
> >>> I can't fully understand this remark?
> >>
> >> The exporter should be able to decide if it actually wants to use
> >> P2P when the transfer has to go through the host bridge (e.g. when
> >> IOMMU/bridge routing bits are enabled).
> > 
> > Sure, but this is a simplified helper for exporters that don't have
> > choices where the memory comes from.
> 
> That is extremely questionable as justification to put that in common DMA-buf code.
> 
> > I fully expet to see changes to this to support more use cases,
> > including the one above. We should do those changes along with users
> > making use of them so we can evaluate what works best.
> 
> Yeah, exactly that's my concern.
> 
> >> But only take that as Acked-by, I would need at least a day (or
> >> week) of free time to wrap my head around all the technical details
> >> again. And that is something I won't have before January or even
> >> later.
> > 
> > Sure, it is alot, and I think DRM community in general should come up
> > to speed on the new DMA API and how we are pushing to see P2P work
> > within Linux.
> > 
> > So thanks, we can take the Acked-by and progress here. Interested
> > parties can pick it up from this point when time allows.
> 
> Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.
> 
> This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.
> 
> So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.

It was put in VFIO at the beginning, but Christoph objected to it,
because that will require exporting symbol for pci_p2pdma_map_type().
which was universally agreed as not good idea.

https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > We can also have a mini-community call to give a summary/etc on these
> > topics.
> > 
> > Thanks,
> > Jason
> 

