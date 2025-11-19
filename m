Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09506CF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBC56B00C9; Wed, 19 Nov 2025 08:25:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC756B00CB; Wed, 19 Nov 2025 08:25:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D6F6B00CC; Wed, 19 Nov 2025 08:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0AB6B00C9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:25:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9B25C0472
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:25:15 +0000 (UTC)
X-FDA: 84127427790.28.A5B9CF2
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3B9240014
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:25:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jxJTJR8P;
	spf=pass (imf12.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FcA8gVt6NKvMsMWTMSBQuU8SYBlABMNBdbtn9F9iv8=;
	b=r9TqB/uL4BI/7K3os4vERmQq2TlJIHWXk/sa/upAkyYuUf1yih+ruttOrgMU/0ikcIwk2J
	QQDWqeOFQmbWRDIM2BNmQ8zoAGGeuhRI3OYdVyIYXoEd9qK975NrciK4FqoEHg016blrI0
	aiXgTgZb9Yzf0nNwPqd3EcBQ8GqVHEI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jxJTJR8P;
	spf=pass (imf12.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558713; a=rsa-sha256;
	cv=none;
	b=0FelV6ntYOK5l7ZLbyWS0mOUGwMKPoTZO4j7g8gEO8TwIeTSIDrgXUBamRqNtdzpGvNCJU
	JX/ljMdrvWz2vJbHgc4VXKTDUk/jlDnaolcx6mfn5D5oZNX+KYG0/sUvtYRO7FfP0+geIp
	cycvNu19mzzoIwUiMY/vmEoF1PSnsDE=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4edb7c8232aso94334741cf.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763558713; x=1764163513; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7FcA8gVt6NKvMsMWTMSBQuU8SYBlABMNBdbtn9F9iv8=;
        b=jxJTJR8PETv+H8SnSn5JaT5/YuZ2JV/vcdrMtIhvgZNCrBfqzvfqra5kJB56QCNsW1
         ORO2TUSggiYNDdf65IL0oWhSVRMr4IjlsidCtFmeANX3N6lz0rxhspabmrJN0U2e2xh9
         f0+uSeQ5KlnLdwQhSbUewnLvVMPX+SEfR5Aj37iO+zXugbG1LYeQYcZ7KpA+7MEBSHrA
         NJQ+EigIT/4MO3NgGBbRFKh3jtz83vrDnU4SLisODqejhmVtI9oGjh2RPw8CiBbQD0fm
         voUokcbuZWGuuhBhXyamcWwxypNGoxFgcGHeJpoZV3NjzN6KBLeYZ27MmNMCH4sTOqaA
         JIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763558713; x=1764163513;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FcA8gVt6NKvMsMWTMSBQuU8SYBlABMNBdbtn9F9iv8=;
        b=GqmUXy/hL5bCpBC4QgrPrTjprkWzqgPfEclRV3lcR1+6Rt5uojuT8kkvb+oX+Od1GX
         0nE7KMI9wRrA4nls7jaspdsC30Dkm3z3azcVjOusjS55uJ14BDzAjbbtzeOKMHJ49Vgj
         A4neJdOgrQaq8ebwzwoe0R8KijAvp7HTy2/FeYryglo12HyLm3NpIMVgSZnfKAOs+nCs
         sI9iTuHeJYs56ldU72WfMVPMzESwe1mjxqyOEHTrrhnhNx2YXQLgm/H5FGksTL2EIzfp
         zypPV12oFrMQv5UbR8z41iKJmZZAKysNEEYAN3sv6ygj6Xu5XaoOh5jq+fnPskSrhvPU
         kr+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0EPjKV47xMwJkfdR9jB0GMSWpPsYhgZnDobmstOKP0IWqI6tpzxx0YbtEe7pwpdi8WXKArCVlrw==@kvack.org
X-Gm-Message-State: AOJu0Yz2IvNbbsujan7vpPJS46Hb/x8fztkn1dDu+mFVTuTiYduFjKeo
	V5Q9Em5FuBb5vbne6bPfgZpkQ8gEdILTMGaKgNohnfrznnff9aZYkK+nik2RCW/aVHY=
X-Gm-Gg: ASbGncuiEn8TZdJF8DVgH/vAr80NLxZEfAZ3CQYZ4y5ULZ0BjDYqFVbRhifqiq6h6X8
	R+G9/bLcj//ciAzYixPuZ31UtFV9M68wDhbdm8A4Nja6rv7s2adAD3c3ia/UHBNYeFlV9/f6y79
	UvSae+GhZpLsWpYfnLVU7NrCVsaplENlE9Ak1i2kfmZt0L/N+pf9CTOGOyMMTw34SBWksfZGqeA
	XOEzxPfwnSIuHmw6JOHbfAAVy95JQSuykng8pJpxGsXYXduibkRBCRIVVjWr7qSHlhUY0rJMpYW
	RCawX7Y9oldIUfYcFb6DTTx/pnk1WNRnrReWm93BaVfNsgLmH++ChydOLDadqDnbOQIqOgPE20v
	3AeEih1+IihxcTulBuXvxhD/EhFecY9Y4h+zUZEmoh21cnLzsujo8d85RBhTyFMJyYMWiZZALBW
	liIabtQdACo1SkF1xPpN2pgYEXWY5OXasfVEQHgwvx7sUiq6WsTlCQc1K7hcCDdFGPexAW7ykWb
	GU7YA==
X-Google-Smtp-Source: AGHT+IGcHnQoF5t1hy3jZRVLXrR3AGxUUwufE8qFpbPEJxiBipRIqKgpWukFR+qkVncUWaOAApoSpg==
X-Received: by 2002:a05:622a:1a8d:b0:4ee:219e:e66 with SMTP id d75a77b69052e-4ee219e1ccbmr140009891cf.83.1763558712629;
        Wed, 19 Nov 2025 05:25:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88286588be1sm133530266d6.47.2025.11.19.05.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 05:25:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLiBL-00000000Z6L-0jbP;
	Wed, 19 Nov 2025 09:25:11 -0400
Date: Wed, 19 Nov 2025 09:25:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <20251119132511.GK17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3B9240014
X-Stat-Signature: sw4e3yepm5cg473tghjm16pkkjuescni
X-Rspam-User: 
X-HE-Tag: 1763558713-857919
X-HE-Meta: U2FsdGVkX18+IlWY8shCMe0XdvXuRN57NRiHq4HW0dajEfi4/3lEECLPJEXY4b66Rz0HENM7DwFOwmyt5gNQgBFkcbDPlTF0jej5qmlHoK7t0eaPTkqCFkZcVTWaFkZdeu7St8NX8CoXVg8AIRyH8TICmL1tncJemOhWF48mckPNUk3pC34b7f/RnquPScX53wNF2vkX8o92nzpA8oeS1keq58oiiVpPSMiNfF4CPpjtY+zlVeyvX/dePZp34fFyJWZm9VSr/ufchtsLeQ8iJyId2lsEnBVqNbZXVf0xAmLRru2LFQ7oenWyK309KTgLV+vVpvpQunYYw+hGrXsuo7jkjGdu5Ju4mSnW6NXUjPmukvJwbf2PrhS01kVj+agOOQWEnQeIAEbYsaYygpMjQkXPtgTBL+qxeaopsTjW14jfI/HbqqlXRgb17IMUz8hH6zwlxN/Sj9aCSTnU6JXUxMLNKwccFmfF9IQgYIlEYQkFjBq5qLGSdEHcgRsLf+SPvhhxPDxLmYW8NpPM5vAg9l9Kp8aft+AD/B2B99zF8dNPpOVCk7TZwycS3LeXshOnXgt2aSfCBjh83wxgykABN4wLHHog73Wb55A4vp3yB2KCRPfECbC7dAqw9G2/0xTRRixPlzOjb8xY9L7DAUo1JmNxu+gWf3XoTuYYNXCZXPAdS4JHc/nlfhWmhFJD94qvydFHkPe6+nQFZ9eoDE2nD7WxETVfS5MGC8ox6AedrQqO/VbGHyLYaIjUFdIU2CgXTSlay21eVGp7iYqP9/17rNY5B68h7r+1M7+yOrEjeyVnxh1N6hZSEIg23WQqpbv8FGaJ+9nuHajJJQfsVde10yfkalLuQpsA6v1rQitsT/0Nrld1qIyJUzBmW6+iOqD5HHQ+C4/sjIdWvMBiBrvpuP2dQVxJNST/9kclM8BrXS1sQqdKqrlFbXyfff0mOERwFWFliNu7e39EiE/akFg
 GfoMwWlu
 XoKssGgcvrLBzoP5vNrbI99G9L4TU6LZtWVzYSYO4oRfA54Nv+4LmJBIvMcz3ozjdaLRoQ/VNDAzsP7dqaJKBkdsFHBgg/1k9Zq4l1mQjg+oC+qd2hxw+juBrHSoMfSo6oPIbzHcoYtGFsj8vc/ZpNqbDzmlTsZG820750sJ36QjSlPhu5qRNBcU/2aRzTm6U5p2zHw/CJMOGnDRe/Ekjp2MpXvP171J5S7YrkZyeDopV+e13GMK1N5wR7zifTG156lIolMM8OcGYoPgUlwA3bKBWZ23tpq492vDXCGqj/HntGlf7d0EXoFgTteYKXxzsfhNj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
> > +/**
> > + * dma_buf_map - Returns the scatterlist table of the attachment from arrays
> > + * of physical vectors. This funciton is intended for MMIO memory only.
> > + * @attach:	[in]	attachment whose scatterlist is to be returned
> > + * @provider:	[in]	p2pdma provider
> > + * @phys_vec:	[in]	array of physical vectors
> > + * @nr_ranges:	[in]	number of entries in phys_vec array
> > + * @size:	[in]	total size of phys_vec
> > + * @dir:	[in]	direction of DMA transfer
> > + *
> > + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> > + * on error. May return -EINTR if it is interrupted by a signal.
> > + *
> > + * On success, the DMA addresses and lengths in the returned scatterlist are
> > + * PAGE_SIZE aligned.
> > + *
> > + * A mapping must be unmapped by using dma_buf_unmap().
> > + */
> > +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> 
> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> 
> > +			     struct p2pdma_provider *provider,
> > +			     struct dma_buf_phys_vec *phys_vec,
> > +			     size_t nr_ranges, size_t size,
> > +			     enum dma_data_direction dir)
> > +{
> > +	unsigned int nents, mapped_len = 0;
> > +	struct dma_buf_dma *dma;
> > +	struct scatterlist *sgl;
> > +	dma_addr_t addr;
> > +	size_t i;
> > +	int ret;
> > +
> > +	dma_resv_assert_held(attach->dmabuf->resv);
> > +
> > +	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> > +		/* This function is supposed to work on MMIO memory only */
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
> > +	if (!dma)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	switch (pci_p2pdma_map_type(provider, attach->dev)) {
> > +	case PCI_P2PDMA_MAP_BUS_ADDR:
> > +		/*
> > +		 * There is no need in IOVA at all for this flow.
> > +		 */
> > +		break;
> > +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> > +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> > +		if (!dma->state) {
> > +			ret = -ENOMEM;
> > +			goto err_free_dma;
> > +		}
> > +
> > +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> 
> Oh, that is a clear no-go for the core DMA-buf code.
> 
> It's intentionally up to the exporter how to create the DMA
> addresses the importer can work with.

I can't fully understand this remark?

> We could add something like a dma_buf_sg_helper.c or similar and put it in there.

Yes, the intention is this function is an "exporter helper" that an
exporter can call if it wants to help generate the scatterlist.

So your "no-go" is just about what file it is in, not anything about
how it works?

Thanks,
Jason

