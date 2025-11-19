Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5EFCF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA606B0089; Wed, 19 Nov 2025 08:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1CC6B00A5; Wed, 19 Nov 2025 08:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8216B00A8; Wed, 19 Nov 2025 08:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3516B0089
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:35:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AE24B9BC4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:35:34 +0000 (UTC)
X-FDA: 84127453788.12.AE10551
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E9F52001C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:35:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R6T9HU2q;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559332; a=rsa-sha256;
	cv=none;
	b=Oo9Hw7a9ug9q2DfzxGiWGEPzUnzqC3jvMqVZ1ZM4qiAlRaYcR7kVh807XoVi4Lcb5rXfTm
	UcV67Uea5uzhVSpEgFtvBpod3e8WACFaNgEk6DPhUIHIXluIXTfgyqTLsd51F5JpXldMJ5
	NwjzwAjl6fh2p5Wmwp14V2RTJJcGy50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R6T9HU2q;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72A2miNlT6HYTvn6gfrMP1LsN3+/rcjlJPwocEiTvrs=;
	b=RCR0QnMNdK7fF1Oc6aX9Rdx/n20Syn4XFG15kHVjYfd0Qk3tuI99REv3bRawt3BVSfjARR
	ThpyvgAPpcijCHfsYasnO+kIjKq4ktXXYdC1NkLYfgm3Tpkfk7KcyQAEu9zRnd1/uR3jnk
	wFkgXBD4bv3q7971SXBulL73IeZZbRY=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b1b8264c86so659641285a.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763559331; x=1764164131; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=72A2miNlT6HYTvn6gfrMP1LsN3+/rcjlJPwocEiTvrs=;
        b=R6T9HU2qGEbtJJGY/7zo52zLF0t4ujG6Duvkb5jI/QjbnuPScRqBxEp8xvnMfgVeF0
         d3fr0NVqMxUPqweEOyWEWP+jh3tkvDyBZzPLZY8iDi2zrCSP+5O92EUMSH53q6Pb71o6
         7xsCeNQc2NFGkx+b51RIqTXfWBmgxlBKwXRcVgeWpoC5nEdcGer6NZHSFuI3X4rT4kTt
         BhEeYHhobeWFppqExtDkPouECSKPTi9CXhRZIP/TUeYahccFr37QXxS4OxVdNn6mnP1+
         htS8IYDI67MDCkz1P8+sNAId1Vjs4/ozCDNplstheg4YJd1rngSEVDc8Ht8XfaqvZFIr
         V3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763559331; x=1764164131;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=72A2miNlT6HYTvn6gfrMP1LsN3+/rcjlJPwocEiTvrs=;
        b=eHa1KZjh3jHU+IYROHWpwnyNy1NGvXtKa0Jym7IWJahZNxrM++lLNfLbh6VY8Y6GGH
         JUG64pXO2qhUPuWvEZAceZdX0qEwahmkGRQiIxtYJzCXsqNr8xAqGHbhJ209Zk0xfBRB
         vSFElXPv3G4WANhMFj6Y9rnDK5wmO4X4biovPw7nB3rgwdAY3zW8ekjTO5/QyXKROF8L
         FEE/a9TA7ZKeyLnP/dhpxFCy/D/4ft7PHEVKmTD6WuUjzu1S8O9HgUdE1qpw/FNksmy+
         DIqQC5pmaHM/WJEmfD7SPu9+44SllRHu9R7sSx8tnm9aJha65AvTh5xQLteiHsno9KiP
         HPqA==
X-Forwarded-Encrypted: i=1; AJvYcCXkJtY9g2oGQG6+ppdz7CyGx3vBbhpVF4En/pFuFiVjsc88FbFmizITV3cxQTyqo2D54S24TicLig==@kvack.org
X-Gm-Message-State: AOJu0Yz9sCfLwp6o/We97/KHqzeuVM9I88ZKyS28/PBG4AQCYGjzWBAG
	RcTc3aaTi5v3u4bQ6v3s0MiN6rSEUJf6pUsBbjrOiUVz9FoZ6FH0RFPL7dYUZbgUkGU=
X-Gm-Gg: ASbGnctFstr/NyZ+QA+843/Yj8vPtHf/mgaOAlFGYqZl/QHuqQ6XG7JluJ+fzs4+fE8
	Edkk776pLVcuYHKXYsQf4uMMHh/efxrlRA3xu3UV23N/Gf1ewf2CzF94ZG3o5rRrxr+SGmfj8YV
	NqIJrWMHllD1vRZ5LZLCQn9kv4cluCokPaiY9oyia6d4vj+H7qka9LlzxpmRv9ESECcchp0sTEZ
	a1oOAM5f83kZLIR7LLd8s6v+a7VLP9lu9nRx4uAK8Z29XweU5RwQ1174Btds+2v8mRac8UTAqCj
	TijkawXTZH9oSjA8UNvGCXI0qSZ8Kka4zpxZMoARnHYHj9ZtEmDf6QMl2H6uGQMEf0QGBDlVg8Z
	Du462mb5Q+OV2rWZPEwPgjvNIGZJSsFF+LDM+0ramzIfuAgXnKvzlxcmlqhrVoSRaOPVvwYn0KG
	+Hdtz4uijuxKV07hs2NytZYMA/fE3ZsZrxZLJaYQpsd/JirUokPGIWCAFM
X-Google-Smtp-Source: AGHT+IE7dgToIwQMvgHU78QddWp+ZiJRe5Ch8SPXRMVN2DOwf2T1NT7zeC+YapS6FYUcpx8f/T/2tw==
X-Received: by 2002:a05:622a:256:b0:4ee:16a8:dd0 with SMTP id d75a77b69052e-4ee16a8d595mr193299331cf.53.1763559331028;
        Wed, 19 Nov 2025 05:35:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede86b376dsm127986771cf.7.2025.11.19.05.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 05:35:30 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLiLJ-00000000Z9b-1C3G;
	Wed, 19 Nov 2025 09:35:29 -0400
Date: Wed, 19 Nov 2025 09:35:29 -0400
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
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119133529.GL17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E9F52001C
X-Stat-Signature: yxf6chcraqss5xiddtfdu7ksxrqi3egy
X-HE-Tag: 1763559332-539689
X-HE-Meta: U2FsdGVkX1+zpZD4gPDePGPdY05xgxhlbR+1PMnAecEqo1A+cXWvIYqihURMUfYqLu0cIe1vD+zH+JQuaW6ma+iJsztb0TcPtSqeYn23hesygaCAyV0ry2xcI7fi6bF3JZpGiRaHKf02+JFBZef0kbT2D+ZsUGz8WakTsXK46/sJ36riUQwBo7S7bVSEeMWxrTGL7pvyWSbM8EGNTjRRg7zicUyNkPI2e/FmT8G/bGnIyfJ4NOICxkc51UZ8cRExIjDrqxSLYFm/+zxnlBoOOj284l46a+Ic538cB8PhclywOp/YqxPo87/4SxpZWsk4Fl69boXZBXxU89wl8JbUVXuA8ElvCtiW7ZeIjz5YX4ck1tM90HPkxIk5s5832EdWTnsGsBs3oA8tbqAPbokKP3TlN/oSTEinS8aW3rWjxIXMxgFKOA242ryi66BvHQAMvmes6Hu+PDXVuW3txZEKrM8po0D9ggGcyTFCNaF3LFVTxNQpockHXsmGGQZ60IQaJ4Gn8tHlMY4UtUlVWejvgO7XOI7tcx5rRViecklFAuA4F5hmYIDR/H0tERkIF/p8YNoL8QWe/vwuq9+4etc099Wld19zOk+/+ng2YOudAMjnCHbXbt0wGTTHTFBqhQUHwFfN/GRrCgnin1fTmh3gQ3sGm5vNQThpeB1iL9HhDEYRhpSECcaxEaIut47cj4PrfWM6xamAGKAXouR1UQvR3hrphzE3irHkrhGImsE0498oywoxeS3T+2tcZWd1sAOrnBsTCecLLqDF5173qgtsFJA/66Pjg947gEH+0YiZZ0EkcCvTOISPa8yl6CWpMoEQL3902SqgNj9Mz3Zuox7AuHjrV+i2kN4/KZW4kqSaT990FLB60vp7F8s/7SJgHaZDmkWgT4+ZCugl8SyM6+NDalJkuwrTlGRVJTH73f583vA1whESbHJMirOkQ9ObMMrTICFWojcJo+6BZ0sYoMs
 Zg8TOhlA
 wGENhHzCtoIOU5rHTHgK7ZvLJh1EFUr9+tlMxg/GCrgYB5vqi9RT41y+X6V3ZMJGnZbX82Zva2eex/YpqqaDGZ45mlO/sE3u7Nm20JllEVuQXzx8FVy67K3QymglRw+eb+ebCYF0U+mnabjbXFIryOoZpYyxrH4bVM2MjnxO/xIQxGRiINvkr2DY8pK/AwBtPVXhXkimGMse/ic24e/68sGsWxHI+R9RVK/sGgmf5iGzn2bElhM3ENBSUqbayNE8+bTak2KYXSSpG1pZax4+I5OpQ/sPVSw+VGqNWqguZL2NitX8WE4YT9L3c4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> > +As this is not well-defined or well-supported in real HW the kernel defaults to
> > +blocking such routing. There is an allow list to allow detecting known-good HW,
> > +in which case P2P between any two PCIe devices will be permitted.
>
> That section sounds not correct to me. 

It is correct in that it describes what the kernel does right now.

See calc_map_type_and_dist(), host_bridge_whitelist(), cpu_supports_p2pdma().

> This is well supported in current HW, it's just not defined in some
> official specification.

Only AMD HW.

Intel HW is a bit hit and miss.

ARM SOCs are frequently not supporting even on server CPUs.

> > +At the lowest level the P2P subsystem offers a naked struct p2p_provider that
> > +delegates lifecycle management to the providing driver. It is expected that
> > +drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
> > +to provide an invalidation shutdown.
> 
> > These MMIO pages have no struct page, and
> 
> Well please drop "pages" here. Just say MMIO addresses.

"These MMIO addresses have no struct page, and"

> > +Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
> > +pgmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecycle of
> > +pgmap ensures that when the pgmap is destroyed all other drivers have stopped
> > +using the MMIO. This option works with O_DIRECT flows, in some cases, if the
> > +underlying subsystem supports handling MEMORY_DEVICE_PCI_P2PDMA through
> > +FOLL_PCI_P2PDMA. The use of FOLL_LONGTERM is prevented. As this relies on pgmap
> > +it also relies on architecture support along with alignment and minimum size
> > +limitations.
> 
> Actually that is up to the exporter of the DMA-buf what approach is used.

The above is not talking about DMA-buf, it is describing the existing
interface that is all struct page based. The driver invoking the
P2PDMA APIs gets to pick if it uses the stuct page based interface
described above or the lower level p2p provider interface this series
introduces.

> For the P2PDMA API it should be irrelevant if struct pages are used or not.

Only for the lowest level p2p provider based P2PDMA API - there is a
higher level API family within P2PDMA's API that is all about creating
and managing ZONE_DEVICE struct pages and a pgmap, the above describes
that family.

Thanks,
Jason

