Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8815CF2560
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 23:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD47F6B0030; Tue, 18 Nov 2025 18:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84866B0093; Tue, 18 Nov 2025 18:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CF96B0098; Tue, 18 Nov 2025 18:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFCA66B0030
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:02:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 592111A0195
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:02:58 +0000 (UTC)
X-FDA: 84125254836.26.F25B40A
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7589340014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:02:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=E+jLdciA;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763506976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9774m00qC+l22EqhxH404c/5WuwECoHlv+7tMAloKg=;
	b=xNioyv/5BkBsTk1jYdcL+vMAu5TUBHqv9tSAdX1sEx8ZcD8JWd377X+P7OcC82cCVzyvaR
	vgFtsnpgnn4Bk8aoPvt/rvDNDipQqDq05JLveS3rZ+vh+GvWigpQIrzMQDNLp4raOX7YRj
	s2+kHUKuJERC4qbzOgqBCYT/fNt2tcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763506976; a=rsa-sha256;
	cv=none;
	b=R1biakLjkiGzsdofpStG+RnkFjPqwmD6ym1VlCIDwkM3ztsY474eYO/cMXdSWN3e+ZsBeW
	1XZpF0XR/PNi8jcYfczTSR4XrQO/yduBzg5KKJ+2OmmBJuSvy5oc5tz3UxvExYhdhX/wOy
	BuiFzLAfFuQoZwDcTf3qYPw1lWa4Jeg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=E+jLdciA;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b2ed01ba15so233886985a.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763506975; x=1764111775; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9774m00qC+l22EqhxH404c/5WuwECoHlv+7tMAloKg=;
        b=E+jLdciAGHnyGkdMU7bEE9ohAGZYwHbjsBSCVh0UCMMmAhcBofwdWlJ1OXPb/xXbNy
         qPw2+csBgYuSDC20ZSm75gqPk88fTLBjPKvbhbRs/ouLTroXYmOG+1UTnUbdDldHPi+3
         stViBhg8+CQpFTeTYH7ZhG4y/pufr5BTGFGX/juDAkEwlAYj5z9QVr6/JOijX7IlguIV
         vJl2TJDG/CAjBwFrFZZchNg62r+rNEjwJJdAdVO5KltKwogzDE2AwGpzq/D+eTbKDYcp
         pZykd/uGFJbts/EOjxTM7HgaWmBSMLH9vU+ERne7DbYOBnTzohIxWrlEfcoX7TpvPR7v
         3pEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763506975; x=1764111775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9774m00qC+l22EqhxH404c/5WuwECoHlv+7tMAloKg=;
        b=CspFZ8u1h9V32S16aqLF3KYPk0xbkt0fbRRJKGRczClKKzw9bZHZcfdABksUnqerHx
         5ClDWR+yRfZJtvEzhw1iTJOvX5mq3C9MRwD3PK+697H2E9o2BG1OytT2mm6RRRFj0efJ
         DOK6orImGgaAk3xyispAXfjvh+coSrzyu1c07AMrHZ3F56HyVEy7jY6HHMMKcdygQf3u
         /luggAeqLsDAkOAsNiVo9uFJGlgXCYIDy3HthZWnlo2kJ6IBLr6piKnPnRFW013zuvQ6
         VN1MTwGnK+XYt3lwF57egIG4Y5T8DPUgJQUlTKpYGyYBJzbJfVyEoMpSrJUgbnvxTfjs
         48gQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9KLB66OAJhf5Pn7YcRCqBsNNQfqJuGHlJzf2/OgZCL8URdmFKzhVS4vK5W/O9G/ZNXNZz5rRRFA==@kvack.org
X-Gm-Message-State: AOJu0Yzae3tN+JahrAelRR8HKk0/GW841cSu2n9316A0SxYjkIGLn9ol
	IOUTG3tdbWns5mt5mW2nEEIehPtLHNmt/fQ8B8EdBvX3zPHWBXPPkL8TGru6nhx+GI8=
X-Gm-Gg: ASbGncv7xE84WwhCgWKPY0qbpJ0BmVx3O51SDiWoo/9g6+EKRnHyAM+CWtaHhBCilir
	JhPAXuw1nS6sVh51hcdt/4QfZes7K2ICwhT94tdHjhKaX6bh7Sl0+AZbAP5Lx4Omjjkz915mf4P
	nKJucImBfwj6hPySUr36QpwJzNzFrMtAGWFbpqvI7OdpUv5dK1U8IZbDXsO0vD09L+5kj6W5DKj
	XP+nIhQ37JqlLnneRCmbX1ilTYQD7Rq7Ae+67LAY1bpKTBRYMK30GvIDiit5nLR9i5B/uXT2JRr
	Tn9Ubw5V6GOFizehIux8tUC80+pLnj8R6BqjFFdseF35aFwoIM6mh3zzIBJ1xFLjgWGJbp+9Nac
	bEByRo9qJ7bUs8aOHhUZV7u3AceHcZTBiqoD/CuFp74BnwBxnS4iuE9tqsKaRqu15G4fNQx7jM9
	2Efg1e8qrjZCCcOKiVUmRs4T8SBfMdQOrW/PCP0kxG+0jPdDSHC6xnXLih
X-Google-Smtp-Source: AGHT+IE7qxNdGTB3O4Cyd9l/l5kqP+7hVSaobWOJQOGThUG/TNMz01RlkEIy242KlmPT6y0A+36Y2Q==
X-Received: by 2002:a05:620a:4454:b0:8b2:eab0:629a with SMTP id af79cd13be357-8b2eab06506mr1265910785a.70.1763506975311;
        Tue, 18 Nov 2025 15:02:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2da3e4cf4sm883665285a.10.2025.11.18.15.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 15:02:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLUiq-00000000W6g-43N6;
	Tue, 18 Nov 2025 19:02:52 -0400
Date: Tue, 18 Nov 2025 19:02:52 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
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
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251118230252.GJ17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7589340014
X-Stat-Signature: pexnwnu6jg9tr53m8dqoyi4hbihfn3on
X-HE-Tag: 1763506976-331565
X-HE-Meta: U2FsdGVkX187va+8OWuIRvy797GiNWH2YPh7CHH1qR5fJw98sxMvfdNXe4XeFWr+Jghy8+pXlfOn+1f+cnwiB3aInr+bI+bSrK7zOt+HI6DaHuloBUlaWjQIqi7sU6U1q18vHjAlRMk8K13Unztj8JAx94VzhyzeqkhX7sD1AxrBtcbW6fJCtwVlzSVTIBuT/N6GQ2DNvTZEtz78mFK0dt7VsWX5GT2xLleWufBWtnJU0KtMeB+ZqLZyfNRP6f+OQhLPMoJWiLzDh8uNko/fzMssicvPokRn6SvTTBU+X1GWk/7LWfq2h4Ow+EMfgYr5Z6jmXwKLOALdw/WwxFy2Lfm8gNjGJSapuWbaHzOXm+U2jVnd03nLih9aYZHGWTxKuMKcF80+aYHU3Qwj6h8Mr3gYSX1jjtsCAf7nXFeFuTGWe3yzpF5aorN49j0wvOIzDJT8NPOyKqx76g/qR14pmvwCITrewu/x2LOKxjcHMmyea35hnRPj144FsXWndND/GO/hFFTr95CKyrdjDKGmj4JZL1tpPB8KJ8VKAE8HWB/jdq0Hk7t6aZu/tf9wXDqcbo/pzEUX95wIy1ElPc4kIcwWpimn0Ebyz0jHZPqic5TJdMh3FaoXlZ7bggFnM3cv2fHhkDSbIr2rtLKP8tCXXUXNEo+pssTBCJ6l1QX2C1ejuI/u2Ktafsll0RxMJvf/In9jG38b3SmcwUlt6C70kSY5ebhbyHCtZsrZ0FMk+nYpUc+D+pWYlYke+lm0mEHypjxW/5lGRXEPiDTmzkudvh8IY5UoNz0/3vFszhjrNhdIpqxif44zYLsBSYZdIbgB6Ok7cS/ZBR3r/PBJ7lRhTx119wqXuttLnu9G1tZmVWOA8JkTmHeKCaEtDnpdiR+yaUS19kjIj10H7iUv+UwBZXfB+/oli/6e1ywuuBCB4RnLBfxBj52COC4aEZdl9O2JVhoboGVGs7Djw4hMIVW
 lg9oBhtz
 tnz3Npi55xEs8a4mJCn2Gwvz1EIw8RnSZ3rGX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:57:48AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> MMIO physical address ranges into scatter-gather tables with proper
> DMA mapping.
> 
> These common functions are a starting point and support any PCI
> drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> case, as shortly will be RDMA. We can review existing DRM drivers to
> refactor them separately. We hope this will evolve into routines to
> help common DRM that include mixed CPU and MMIO mappings.
> 
> Compared to the dma_map_resource() abuse this implementation handles
> the complicated PCI P2P scenarios properly, especially when an IOMMU
> is enabled:
> 
>  - Direct bus address mapping without IOVA allocation for
>    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
>    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
>    transactions to avoid the host bridge.
> 
>    Further, this handles the slightly obscure, case of MMIO with a
>    phys_addr_t that is different from the physical BAR programming
>    (bus offset). The phys_addr_t is converted to a dma_addr_t and
>    accommodates this effect. This enables certain real systems to
>    work, especially on ARM platforms.
> 
>  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
>    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
>    This happens when the IOMMU is enabled and the ACS flags are forcing
>    all traffic to the IOMMU - ie for virtualization systems.
> 
>  - Cases where P2P is not supported through the host bridge/CPU. The
>    P2P subsystem is the proper place to detect this and block it.
> 
> Helper functions fill_sg_entry() and calc_sg_nents() handle the
> scatter-gather table construction, splitting large regions into
> UINT_MAX-sized chunks to fit within sg->length field limits.
> 
> Since the physical address based DMA API forbids use of the CPU list
> of the scatterlist this will produce a mangled scatterlist that has
> a fully zero-length and NULL'd CPU list. The list is 0 length,
> all the struct page pointers are NULL and zero sized. This is stronger
> and more robust than the existing mangle_sg_table() technique. It is
> a future project to migrate DMABUF as a subsystem away from using
> scatterlist for this data structure.
> 
> Tested-by: Alex Mastro <amastro@fb.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/dma-buf/dma-buf.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h   |  18 ++++
>  2 files changed, 253 insertions(+)

I've looked at this enough times now, the logic for DMA mapping and
the construction of the scatterlist is good:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

