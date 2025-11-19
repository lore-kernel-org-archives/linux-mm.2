Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5ADCF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98236B0099; Wed, 19 Nov 2025 08:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70736B00AE; Wed, 19 Nov 2025 08:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86256B00BC; Wed, 19 Nov 2025 08:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955996B0099
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:37:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5527E59188
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:37:13 +0000 (UTC)
X-FDA: 84127457946.21.2D2B3C7
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BF3810000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:37:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=LhAIGvHR;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEA8ekCp1nrcWXcrdpDKlGp67cbKmmAmKoKYvVWnAsI=;
	b=fH9nSznJ3Eg1je2SPOsMfZB0BbVLZ15aPGY8gIC+4SI49st/Gxb+FrvKVg4tpfE/xmUc0c
	hc0tY7nr6XGQX/rZ+6NKy6y8baBanYzraI7ZtjPE8//gHo4/I8nmQFNGRSUdc37kMIv0u3
	I/xizhyXsVWTW9QePoJr5iNn5gQ9/g8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=LhAIGvHR;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559431; a=rsa-sha256;
	cv=none;
	b=NFHDsQaUwPyE0KfQxDeLesgarUYROZxKR8+NI/sIJ4JdY3Ogv8JnaAu0+CmPjLhuJLds/m
	A/dES07CTpEsQuv8Z0vA1nDzNG1qcSJuqw4lpUE0uiRvAkQP6j+NvT5rxdXCDs/zZ4y13t
	QNpIRmmVI3X2fGA/72UqRX9mj2eC/wk=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88242fc32c9so73877676d6.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763559430; x=1764164230; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEA8ekCp1nrcWXcrdpDKlGp67cbKmmAmKoKYvVWnAsI=;
        b=LhAIGvHRiAQue8RgH9j7rQrEx8xWYjs+wRHAR9uF/AtCM/sV7PE+t2UWU9B8B6Q46R
         7r8Tvk5yyqom/zpg5sEJlamxTNpBBmvnmZPwlq/lgfNf7tA7SZ06snWjpS/fvFyOT7Y6
         ScupM6fOY4a6S6CeLn6l5ZDRFiW3jJk8WYIzJcjH6c2WfcoWx3SrYq0rhKTxUtfw6VrS
         oShtAfKbX51soUx/JmG4cjulm+X31efC4EypFke42hfvUgKcOePMGwleJFvh9G/midm0
         UEKxzdkuIFwNBc5jN4clFMvbh8FD9IokY4w3Gg2TmDI8kcpewfFogDxaNcvMIleGpRtc
         KvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763559430; x=1764164230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEA8ekCp1nrcWXcrdpDKlGp67cbKmmAmKoKYvVWnAsI=;
        b=k1im4ZKsqzK5XGH3nWGcBgUEuUdHLJrFFficABkLTNJSfMrNq9LuLYLPPjQKfoHZ3h
         FpUOoi2Qz03Doc2/hTFqPUZbipK00U0F+DjX7xDlPvzKCBfPK95hc8sEYOrqApl6Hql8
         S0s0mHQ5NvJswQDKHYlBL4ntp0qS/IHeAoR8PNRu/vLA6GPaNcYuceMFrALqF8WzQKhw
         Vez4R53AtAtuSgHuOr9QzZAFbQvYGeBHEVOPQx0VkqoSwMN2ee7bY73/Z1PgeRfpM08B
         we7fHPhQTk9xNgxFM7aERCpBWptUH+G4/HcqIVHYPWXwHHGCQPew/IUPnXicwkrtSGsY
         bWVg==
X-Forwarded-Encrypted: i=1; AJvYcCVskNlVMmAe7kKpqsG62w/UHooNqHnennF027TMhOJ+U1wajjY+GSeOjVDHG77zGUnZ+Z+yPpyfRg==@kvack.org
X-Gm-Message-State: AOJu0YyAchmxH5kLNMiWT6EG3AhmRANYLNS5G2dwLCMYAQ9M1ZIewri+
	32dhjaxvp244Hgxaa8J/uzFfmn1TQ7VoA6wLtVqM1OW0vu8+w1fvf5+aLPqLo0hVhHs=
X-Gm-Gg: ASbGncvu+w6fvYFBjVxvu6O+OCGw4GkY9UKJuZAS3vGukI1xZWWwu87anFrRZLg/hX9
	j3cLL3lHBJoPwyvXLPn9PWkAmcEEaZqGIml5fQfO1IP68iFeVQZa4qAwfmsxOnVffi+LkQgTF/u
	nANS+XMCcM7dhDhf91grkWw8w6f/DTX67/grpYj0LYI/VNs6hEEWDdu63RJ5+2DFrqQBD6OrQ/Y
	XQ/mjm6l809t7v0ufNwauIsTQBoFDdNsW+q3PfOAOWT8ayCUh4KVfJK0kd7ciIRB/Dk4w+7KIzW
	wG2MaYk38KWlIcHovdv5ScRaHaFuaSrZx02ylQgEcELo2gonsqqLYtW9eV/9F4qPgCCWntakUEX
	BUC0dm/3TzItL+VFGdMpJG4mttInJksJZBLVocD/j7hN6XQKpxR3MiVM6YwGLYGeLHVzKPlqq0t
	lAJ9rSXaMjoiyBKqZStM7u9A73ZPygurVvys4o3FcFOQ7S05ikYxf/FUgDp18IfBHUNm0=
X-Google-Smtp-Source: AGHT+IGopBrMkEkq4/9KDO3x1qdzFmkcFO+Cz6Is5DlvxN8PyWRrz38DMZOLki2k1pBf80D+Z8AYkg==
X-Received: by 2002:a05:6214:419f:b0:880:22f3:3376 with SMTP id 6a1803df08f44-8845fc3e0f0mr26190076d6.10.1763559429603;
        Wed, 19 Nov 2025 05:37:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828613962esm135128356d6.0.2025.11.19.05.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 05:37:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLiMu-00000000ZAY-2EdI;
	Wed, 19 Nov 2025 09:37:08 -0400
Date: Wed, 19 Nov 2025 09:37:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251119133708.GM17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251119133000.GB18335@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119133000.GB18335@unreal>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BF3810000F
X-Stat-Signature: 44536gpwjijidc8erogri8m65u1rkf8c
X-Rspam-User: 
X-HE-Tag: 1763559431-145977
X-HE-Meta: U2FsdGVkX18AhA9xPHZ8jXXSLnOboGglPqw1+y2O/AaLKh1yvtUm8aTc00oqoCMeZpPrX8aDjwQn7YalxgAYnjK3NpHhlktJ/WV4o+1OHoWFaBkKYWJpFpyvh/d8J+b2JGEb1FNRTvH81z2VaN3Rg8hBlW0oW9lSpTeAE5mTACtwmT6EX79CgUgAzIw8da4b1rUmV2PC4cov6eQ9Ao1x7gmCvdkDMKVvXSJLuw3YUEPNHetklaBa8ty4rapQOakJB894MVEbTGHTjqkjbjFQj/1lZFF2z9XNNTdJcer1SS47+Zyftgt7dNN3QsQtL1O6JoAbWopiezARtwqu1HYtoNEFz/Dr/ICoMJMeOKNayUvZ5DuRz7YfoUHwZ+rWyH/Ud9DpnfB3JUh3QFxcamO9i831aYA4wy40XptQirXXNG2DZ6Yme8MsGkYXTb1RHPEuctBGBRNB9PfCCNq5pSxaQ0v7Tqtj01NyitC9YOOb5L+XQdRjZCbU0KWXoah+tl+Ubsk8mR8EQ7VGoBD02w08QG4QcNNZSwrhikfNho5NwJ+EEai82/RYzHec8sFL7rFtv1gDXudEjEITlEL8tbHIllaoY/p5F3Qztn5BSXfoV4vTjqfsDNhGHXLPB5+NXZFRRlDWS2iPI/APQ4xDe/sgnkx1vLkLB+2GNetHGzC9+WM7qcI3/waZrA2Fk+cZfSG1p3WA6UwS/GCck14stdM9vtPDeO6EeUiHUdOvt03De7VOcnxdHmMk2NaVO/bR+Gax3W20963HfYY7gVbp+uMxo2NCnN/RWDrhK16AczPfttEZXvL1PQDyCuSaIqdahY+IdLvDgkb4Uyok5GzmroIeuzg3wHbHbe01otGKJJe6tOtd8ilYwb/95dXWAzwBcTtvAZCTwB6AUCFVZ6YG1ipVy3JsZM37T5eceuzn/1NWjWiYw3CyvLIaBnVcDZhPJWisxFrUZ9eeZFku15mrq24
 b0f1k/Se
 KjvSozXKMyqAnForEPJPljyzKjCsbxaFJBJ4DOEXpguYLKl42lB+Mqbxy3CDHG6GJoWLP8bwpx+p91j3wt32y+zAtiLtF/Zn0r5rBTSd7/7bUO1NgZSSRap2btZ1rfi93rXTxmcNieGHU29pX8UnkieXI+VRovBqBZGc0UtM/ZaCe8zvYGyV1kraJY9nVaCM/v0XA1RZDxa2yENhMj7LoYI0PPEvEEK+nRD42aHbVdI8Bamv25/LbEis/Es5SI/T61ioUxaH+ilYbsHntj5Sb1TqbkEDrBEQGtyOxYnCPFXqP/FY3nwzNE3osfH1juQzVGuEHzXES99zyIsehifnxGuSvc8H9C00T7kgs+pKBIDUEAm9BZhd1jlIDmHOK8j2qAftqm0fIgYFp74o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:30:00PM +0200, Leon Romanovsky wrote:
> On Wed, Nov 19, 2025 at 05:54:55AM +0000, Tian, Kevin wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, November 11, 2025 5:58 PM
> > > +
> > > +	if (dma->state && dma_use_iova(dma->state)) {
> > > +		WARN_ON_ONCE(mapped_len != size);
> > 
> > then "goto err_unmap_dma".
> 
> It never should happen, there is no need to provide error unwind to
> something that you won't get.

It is expected that WARN_ON has recovery code, if it is possible and
not burdensome.

Jason

