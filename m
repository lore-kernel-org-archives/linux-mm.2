Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF53CF58C9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BAB6B002A; Wed, 19 Nov 2025 14:31:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63886B008A; Wed, 19 Nov 2025 14:31:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79876B00A6; Wed, 19 Nov 2025 14:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6DB66B002A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:31:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B8551A0628
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:31:19 +0000 (UTC)
X-FDA: 84128350278.21.A79A50B
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39E274001A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:31:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hUNPHTZE;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763580677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7MnLKcAx1SQL4BtR2OdhLpsdZ14wJj1fNMBVXMaHpI=;
	b=tzxYlCrQHS6BZqGB3xIqo/bZdhRMBW5P7L6xrZ5BAmk/ga/V8q1OvGywMGhiU3mOkGRdUF
	p+x0oQy7RFpwND3JubwAkkzWgeiicuXUb7jtGI6Z1WcjKypAYYzOvHkPnDFa3GtxplaHio
	PSKW4d0HUaCFH4IH85suIs6itr1wzPQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hUNPHTZE;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763580677; a=rsa-sha256;
	cv=none;
	b=tDrFkwskSM08zlxCcN1uuHzs05w9cUF6HEApEFllFXK8c0UIzXDVX0PaWFU1LVTQbvW9fe
	kv8ztagJ7+3k8p5rPS+6FShuv1K25ASms2fGsCUeE9c3ywgfQGHcCyGT1rUZkaIDFIKeX1
	LLM58zHwqrBKUwfoxEhlymfhfhZ1jFw=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so806831cf.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763580676; x=1764185476; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h7MnLKcAx1SQL4BtR2OdhLpsdZ14wJj1fNMBVXMaHpI=;
        b=hUNPHTZEm8b8uylRHwhTAGn150u0/Shv1N+L/cFyt8G2r+7+JxQBp4KJGJWMQz0N5V
         7+JDZzaSpRMoR5fR5fhrM28Zx1gonBKEILM4eV2ST2iXl/bXw1KJ2q+fRbY4lgtsgTtt
         uD12cIswcLVDo9GKbwtYgEKl1KIy6HlsnVltYJHYsGFRbWHOt/3wnD/tP/BBI5akW+2m
         mwqCX/aYxvLcva6pMealmplUwItXGxlH+puv5sTAUhA6bU6CQPN/h6ZtvSl70Jbd51Hr
         bjr507yG16Wz7h+vtik7FimYLGMIT29vlOxWBJZF5F2UFR451B1J0CxYfQICU/zMowHq
         u/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763580676; x=1764185476;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7MnLKcAx1SQL4BtR2OdhLpsdZ14wJj1fNMBVXMaHpI=;
        b=s3GO928mRaVNVGuafOcRWVgaZTWa5/DNB3vpW/66fZxfRBzptTB6OlRwy+OhVEwtcZ
         Y90Rke6eSHza2lBLfHp0cHmD5ALMxO9CnNJQFSo3s5igAhkXGPkrvfkwGU3Cidl0v0yI
         SfDGJbwi8T1zAkcCWdy+0m+H+xhGgq+a52ZjBc4yqkNjY1WBN6VK53knta7n8fmLzQ2p
         ip/uLH1kGLgrgb2dYUlQvy15iY8gTPIb32N6uWGoyTvpd5LkA5jmQcsHXWtArh4ZSLjO
         y4lSe0GVFx1YQMCBs2AGtEgRsv/HHSvmAb/M5pYY2ViL+iLNDNI83aoOwnkTVrpBI1XT
         q44A==
X-Forwarded-Encrypted: i=1; AJvYcCVdeVZXjJMS/4ftIj7FPv8Ln3jVU2cOCEgDbMgLDgmaylQIPn6L11cuZAC1oVYBNdKdkZQ87FYesA==@kvack.org
X-Gm-Message-State: AOJu0YyquuIpmCzjeSk8iZStGI33smt9UDZ+AXO3a0PpcRG86jgulKhd
	iE5webKsvzvfPQMyzks2nqOza58Jxqei6UMd5Br7nihJ992GV1LC46v1yY7zaxzkLaQ=
X-Gm-Gg: ASbGncsAt1GvnQk70ZNubcJNnfu++mZ3yKw4ZWBjDbayJQzKnPfrLnimivbP/uTIW4C
	L+cwc5FD98IYIGRFq/Msf1kGabZOE4uYYMhiaplx+hyKw07mlIH4udsLCmHUlrs3Yt60KffzIlK
	8OXbsex/c/jOOkwU9iRrHvceAr3I6JQSTm5GWw2kJsJXL91IF4MkN8NoVA8tBG8dpfKBHvJuoR+
	dZ09DCzHor0xqrugbRwvdyvZX2DG96JoDtforz74m0hAM1B1q4rwfIquCdXx/NjK4UBoLWf/IW9
	pB8s5GNi7FisZdi1Ld61LwHmDUrdmyCUVjGPvnx9g8XtAUZngYyQDH3RKeXydSYKPo0+CHYRHTU
	vvfienJx+45D6wy9RRnpZYNzhiI54hvaVvv1RjQ9GGuJZ/x9JXXIYoiy/7zISYxhxE0ybGnqF4/
	Y5pSrSIf5D5dZnkUq28xbbgZd9ir2jF9k3VRHKEEo9frCSx/g+MRutTH8O9kfwpfejzvE=
X-Google-Smtp-Source: AGHT+IH0hpvR5twkqRmVGMRtAcrCxesRIOb4Xizv2z5I0TXHRJV8nSPA0Y9PLt873fJAl178vHWixw==
X-Received: by 2002:ac8:7e4c:0:b0:4ee:4a3a:bd18 with SMTP id d75a77b69052e-4ee4a3abe64mr1136891cf.76.1763580675980;
        Wed, 19 Nov 2025 11:31:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e46ed0sm2807721cf.20.2025.11.19.11.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:31:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLnta-00000000bWq-3r3x;
	Wed, 19 Nov 2025 15:31:14 -0400
Date: Wed, 19 Nov 2025 15:31:14 -0400
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
Message-ID: <20251119193114.GP17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39E274001A
X-Stat-Signature: tkrh71hpmqqcz5nxd5c7y7mfiwh6mrkn
X-Rspam-User: 
X-HE-Tag: 1763580677-367360
X-HE-Meta: U2FsdGVkX1/oADsI3IPtFXLLkO5ytgpRPFP16Jg1ui6ByKQtGwaocLRSb8nmm4oBGnUqHA3ZyDDcvAIKRLFwVLt2cQIPrIcD96XmS3kC6odu8NI9B3H44yT0tfE84zpdyPk8dhlOuu/oFG5K6fsi7Me5Um0zQBTpTa+50mDVGCfeKr41EiaZEjIi1t2vwYPta+AaXrEax9+6MI8KnbOKz93pEwSLUqRdAilTTqqhJPLuzZB0VGMxl9WbIDj0mlxzohsdnHm/zlx6e6zcljWXee5HrxterZ/NE9QV8t+sYRz25NSiLbxSGqs0GUPb2kcqbfJMrF9isRw+e9WtCI4V9BsjcbnVFNMDmVRjMwJ4+3lzOADVcSeM8JhA9mKY94NjSY2IvuBiwQ6sO9gf4RLOX0WBvWr6cl+ZnlGJIEx0twDadyaLmiy1GgaTDtksWc6Xva3TY+xVPZuG5XZEcX/UjgqAt6yzIosKI5TTv1vxwDHPZc8k/P7MUj0+TFWFLQEOZEtxpl1n8lIuW1OMHlkdUD5kXaudlchY9HMaVHDm33SiuqeeXhd6NYgtnJWFz9kL2lBvsACkJaS8ViIzEf3LfMtg5GeYveo7jSAD1m6lcEYrM8p/ZmJLgZsnkD/4cG5J9WVzF1PimccfBTYIoFb0izyJJwfggdIsGbWSWjOYBzRjJr4Pa6K98WKtQiWEPgW7x/pouZuXTlSRj36VN30ghIgxTbIkp5UFHBDrKrhBZAMn9FdSegTkRijVA6aF+TQRAKNRoZAA+loKh98nNvamfXlMq6ld8A2oLxGjScxgl/bR3A1EJMKeMmujQVayjOZuDcpYNdllRmzcBojdqFBGuhbHnNy3Uczbp4tc3wBRtMbLQYjQtzQkxz5OW0biMbY3PDSe605+DAqpSZmhjG0Jh1zXTFSy05QTT/CAlDG8KBq/zWTNzfLIC7dSsymBhsg/n5J8qpaC7713h7Zdfwz
 BR0DxuJl
 E+l6cl5bNV0cEaCMsR6hmfSic8B6DdDeKx/L9VP1vkX19WJTQVL4UcMZVZchaILVx0lm9RozYQ3WouBIiUdG6edvfIWnRmzZepmph8uanChIJ1ioJnvFet7FPJksYqJymMzJ9qF8NgZAbOiy/bd//1WebnzPKKXcUSfOZ7oynu5mBh5S0Vn1WogXvCsUdIyYmNXQsQZtTICUQDUWs4tPuGkm89S3i+R5TNwy9op0EHpkh4m3AEcRC8uygQ7hq2Q1CHnzddAHct9IzwDiksR3nyRzYmkbBkeZ65Z0GzJcvpydNKVxUtJSmQHQ9bhH+WNee44nxGYkIudXVookhqfzWu3LY+1MKWRAagBUMHaznGmO9rQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:

> >>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>> +		if (!dma->state) {
> >>> +			ret = -ENOMEM;
> >>> +			goto err_free_dma;
> >>> +		}
> >>> +
> >>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>
> >> Oh, that is a clear no-go for the core DMA-buf code.
> >>
> >> It's intentionally up to the exporter how to create the DMA
> >> addresses the importer can work with.
> > 
> > I can't fully understand this remark?
> 
> The exporter should be able to decide if it actually wants to use
> P2P when the transfer has to go through the host bridge (e.g. when
> IOMMU/bridge routing bits are enabled).

Sure, but this is a simplified helper for exporters that don't have
choices where the memory comes from.

I fully expet to see changes to this to support more use cases,
including the one above. We should do those changes along with users
making use of them so we can evaluate what works best.

> But only take that as Acked-by, I would need at least a day (or
> week) of free time to wrap my head around all the technical details
> again. And that is something I won't have before January or even
> later.

Sure, it is alot, and I think DRM community in general should come up
to speed on the new DMA API and how we are pushing to see P2P work
within Linux.

So thanks, we can take the Acked-by and progress here. Interested
parties can pick it up from this point when time allows.

We can also have a mini-community call to give a summary/etc on these
topics.

Thanks,
Jason

