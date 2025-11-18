Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC8B8CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF186B007B; Tue, 18 Nov 2025 09:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F606B00A2; Tue, 18 Nov 2025 09:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E686B00A3; Tue, 18 Nov 2025 09:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 808EE6B007B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:59:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 364F8BA2C9
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:59:40 +0000 (UTC)
X-FDA: 84124036920.11.A5CFF2E
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3301380003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:59:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kPztAiAF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763477978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zUAnqwUQ7mMEKfAAq0Pm8CCEggD/qceLgK2oNv/WhY=;
	b=rlD1X69zI63b9jI1hwUNXlog8ejiKSL66sq9IkagABg7Wj0ria+bmP+3qEx0nSzKv0biZT
	/73fmaanA884Fmy6K7O1wPhcJ7jYbibQZhq6iv+Koj7vE2fqGryuIJuFxh0g4vjAX1yFMf
	HPwv2ISevohjXQsIgQXEMT5IHjXYXWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763477978; a=rsa-sha256;
	cv=none;
	b=jaXNY9kJs5/rnOBuzZ0Vfv9VecPl+V2yDwwgATQ8dHMw7ALirrakz4G8EWuIW0tCMywsWZ
	SDMdsMAmHcxlPyPLMLZZwwV26KZquAkF8CbLHmih6QVM0fZCrYLEfmgW+nzDNxny2h9bWo
	smCQwal+qlXo6iitr+uVnqe6MdU4gvE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kPztAiAF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4edb7c8232aso80251851cf.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763477977; x=1764082777; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6zUAnqwUQ7mMEKfAAq0Pm8CCEggD/qceLgK2oNv/WhY=;
        b=kPztAiAFh8YFu62sI0YQqs/4InxbbvatYJzCzYBIY2HYM/wJYeGpCobG1KqOk+Hml+
         6i2b+jEj2kV9H8FjTeFjh8eY3+iFXlEhLFon+6gieAaAHHEeKQrQem4tWzpTGNopPJHI
         WT9WaG/s0Rk5q7gnrDYfVkTmennSn5hBI3kJutf2kGeBwJ+152M53e67KV+24zjxp0V8
         oARscJAvXF89irVUgp2NK3wN1Kz54cvlWzYJK+5YLGmTiNqbMy1xBpmk79KQ27FwCN8W
         4lb9I1rfTlXwgQZg82DLiO3Gyn1JHKhlrm5Z+1wWZb1mTZPGHeZuw1sqUpsV4pEBsEY8
         4npQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763477977; x=1764082777;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zUAnqwUQ7mMEKfAAq0Pm8CCEggD/qceLgK2oNv/WhY=;
        b=tAUhqZJrA9F/kjrRXMejWyPv3rXzQd+lkCU8vjTUPrSEDf7aP0BS/L0RLeXSMxfQyS
         QfeDSdhUrITqWKxdRPlset0EyyJHGyKk3En/Zy8hfDYnHTFNhSMLTJy/y5r8wrxGvjwk
         36nWj6tH+KXJfsSzfXdvlzoGiV/qSvcBoLrRWldeMqIqQsx16yZ9b+ZQodhrDDzMYS67
         3SEG0TX2I9OAOoLYcYqBE1mtI4ffH8/Jn2pFgwpi2iZ330e8y39MI0s7dIVip4pSm0gA
         e8SF/M5j7dlkyUjVWHHuZERLdQ7u17aJl1dqjXoHV8AHzSuR5AF8SFREvVWCtwI9OErD
         MtuA==
X-Forwarded-Encrypted: i=1; AJvYcCUwSRVacXCWxYWBg+w5abMl1HfVHXfjcy2NKHrbr+zooaVje4F9lbCzyb+xgSoyR2htxzrCnzA0ow==@kvack.org
X-Gm-Message-State: AOJu0YxDNifN8ZMhPK3V9F4bwhL6BGI1sf4KedoQgCA0oShjiQPcTUA/
	eFsBR2SFXOOhzv56d201uwu/FdnErSpRz56VVVtV5TsyO7wqZk8BDsZukiG0c5BhOm0=
X-Gm-Gg: ASbGncu1gpCuNcJpXIwE8U+fPOh5TmmhzWQ8zgrqQL7AC6/K4vDI6tIyYYR4Bd9byeP
	kb4glzhaSkYS6z2sOGJpyOSBmT3DtutfebSwNv3OmMP+fpn86eValmjjIAUXy5B/3777X8e1r/F
	Xjuxdq6QJHDoEWz5ylEH4cF3WTCQJKhYYKeMf4SG9acQsmu1UK/OfnCWElkMeED4SOrTRb3nkc9
	+eVom2UPYjBJpnOup6k8HncPfYzy/ennCVKvSAuGoV6FDGUI7UajLdiItqVHaVjSvqdhY1VTlrt
	laqP6xu6tSXk3nJVMYm3wiEJhyEQnjxxvC6PFpu9UAFdjLXreQL7j2aloZDnyE7NNy9iiWL1Yc0
	WUSMkE21y0PpNtGRDAK8A6e9n4OANPO6xCAKSzK5FQ6rF5j8RRrreg5wQwEIGROo62WFtylworx
	iMLbgeeybpJJeLiP1RzA+npEJs6BH4x+rQv2v4kxogglF1/E4iJvYkTXyFZlG108LHCKs=
X-Google-Smtp-Source: AGHT+IFmOGfhY23WsMGsPUUjQKfSR05e4XRcukJGt61kp9ViFdOBWiVKVUUuzQ+TB82GrGuUAmTsrw==
X-Received: by 2002:a05:622a:1a08:b0:4ee:1563:2829 with SMTP id d75a77b69052e-4ee15632a6bmr144570871cf.72.1763477977218;
        Tue, 18 Nov 2025 06:59:37 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee275abad5sm34184941cf.14.2025.11.18.06.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:59:36 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLNB9-00000000NQI-239J;
	Tue, 18 Nov 2025 10:59:35 -0400
Date: Tue, 18 Nov 2025 10:59:35 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251118145935.GI17968@ziepe.ca>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251110134218.5e399b0f.alex@shazbot.org>
 <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
 <20251117083620.4660081a.alex@shazbot.org>
 <20251117171619.GB17968@ziepe.ca>
 <3599880e-5b50-4bad-949b-0d3b1fb25f3f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3599880e-5b50-4bad-949b-0d3b1fb25f3f@amd.com>
X-Stat-Signature: efpjmewsnhg1fpqdtazbdc5gkzs3t4k7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3301380003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763477978-460282
X-HE-Meta: U2FsdGVkX18/CN+t2eJLPfM/3kgcQgz0mBGEBQaGZIXgtnAoZFWPe9tm8GiM/LB4Nx+CaHFrfwu+QWdpKVPMdMMzHR2E5ZiI55dkcmlWzjIFqOeq8SoDNy8h3hGtLtQgnj2S/g07C5r7jHh1KFPXSi2CFQc2hOtkUwNE+F/omnbT5S8am+JElr1gvee+1mX+cpIrKUrSHLkxQE1GnjB/u8/qKcj3NJI1DPnVAuW1xkpvhmZBh6OHILyM71Se8TypyEt0rjTbaEJ2/8gn+hQr333ldvCjdTtHrbktDz7gatngWAUCJ0WLtduV+oCufte0fEeZQ9cbUm684KrPoNI4l/IVUlKqrn0oW4Vlb63fUlgbG8UdqWWOgOhW1J3r7i8a5nkfVEj6tKTaUKt6flDLpefYPN24YosZyeoC5s6Sox9ZapolhsjybVAfrJszS1yz7/Xo3iZo4FC+pJrCu/55ZpVFVzSg8sr2LSyuT+N7d4PYzCruy6B4ZfkUHXieNzjyHAo3h+KLXec2SJD+2dDg6s2xR7IHhQ3wUnFXBn9KCSVg9CwyNHJbmHUU0s7iP+gHHmd7oVXHJS25OyhSCoHfoQaCQvd8x/CcmW4OzZUULlhYqCLPW2DJt3j1KFcfLVreY+Me8a6RTJTKAd4HwLZgy0hD9bszgaBANPxXr3Lfe9QixL6pkPDAe2Ru3rKW6GKEjny1xliF4Q6ZzSTVb7PLzqBf+1ftjCn5zya5EfVpeSfiGkc/3ucU8D+ShtYxhtENDecj/e9fT/dO1HW7aOarGorFbYBuQizha5IhPOyodIYzeA/FLdxV0qJkJy/T20OqiP0BLJneZnwG30W8REXFfpVp5/2r7sngZFA+9Vkza/QfpM5wJg3kNGzcEUpesTTlcK/8yvrmJTFRnsjGIlmCnZt/Vy/ZENeSCnWFmv2+LMr4sLCHe/ttw3MkuwOWJw0WsFaVB+3fRnwzvTNSUk1
 SkF0h2WG
 vxlAc9SP+jOV7sALSWxoTWvtlW7GbC52T9PXwC9ouM7YlD9dzMuKtkRKwCh6gn4JOK6jvszBpUYokDjt+ITKie2bVtLbErJeGPBxRMk+F9XpoJlKfrEtIQ7m5jhdTAN1TKYu9ujJIIAXJ67BOzr3epyxhPGfauKn/laDJyoZdJ1om1NM4T5uTK1u7GyidZ9uVsRjTyr19Vm6GpHpNofDtFpzvO9vkL8ER7HSYlGTmtrgkMO8MG5SAfKGF2VE0KAF8h/46DxRTD19QE7auqmXrf5KbWPtl+V7hHKsPtOrZ/CC24u4ajWfOestBoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 03:37:41PM +0100, Christian König wrote:

> Skimming over it my only concern is patch #6 which adds the helper
> to the common DMA-buf code and that in turn would need an in-deep
> review which I currently don't have time for.

I think you should trust Leon on the implementation. He knows what he
is doing here when it comes to the DMA API, since he made all the
patches so far to use it.

Please consider just reviewing the exported function signature:

+struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
+			     struct p2pdma_provider *provider,
+			     struct dma_buf_phys_vec *phys_vec,
+			     size_t nr_ranges, size_t size,
+			     enum dma_data_direction dir)

If issues are discovered inside the implementation later on then Leon
will be available to fix them.

The code is intended to implement that basic function signature which
can be thought of as dma_map_resource() done correctly for PCI
devices.

> So if we could keep those inside the VFIO driver for now I think
> that should be good to go.

That was several versions ago. Christoph is very strongly against
this, he wants to see the new DMA API used by wrapper functions in
subsytems related to how the subsystem's data structures work rather
than proliferate into drivers. I agree with this, so we need to go in
this direction.

Other options, like put the code in the DMA API area, are also not
going to be agreed because we really don't want this weird DMABUF use
of no-struct page scatterlist to leak out beyond DMABUF.

So, this is the start of a DMA mapping helper API for DMABUF related
data structures, it introduces a simplified mapping entry point for
drivers that only use MMIO.

As I said I expect this API surface to progress as other DRM drivers
are updated (hopefully DRM community will take on this), but there is
nothing wrong with starting by having a basic entry point for a narrow
use case.

Thanks,
Jason

