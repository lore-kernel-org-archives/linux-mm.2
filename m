Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD4ECF8855
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241BF6B0022; Thu, 20 Nov 2025 08:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DF46B0088; Thu, 20 Nov 2025 08:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12EB76B0089; Thu, 20 Nov 2025 08:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0050E6B0022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:20:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77C611DD747
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:20:50 +0000 (UTC)
X-FDA: 84131045460.02.A91CA05
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71CCD140015
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:20:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=gy6DDeua;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763644848; a=rsa-sha256;
	cv=none;
	b=oZg/se5FEKP4JaXhke+iyvBOAYr8FabU2+lOSc2Ng12zUSCnn1B6jpXc7jqfual2rvC2U7
	s4CAOj2UItSGv5rtsJGBqsGEUyDqnYT0Gq4mUg45TPDEmUxsd+UQ/yWAm9LGcisFSIMqqz
	sIK8BIqr/DQl6Yedg7zu5riI05hsO7U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=gy6DDeua;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763644848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaI8T1P9V7HUSR5GC1P83jhUObFww+4fRanAKkUJgJM=;
	b=I3s93PuEo7IkVnVdsLUmRcWO3NyTjf2g4/oQZZaBSLmf9l3uiJ+9OHehKe6gOVqHaWZp26
	QpeRxo6ayyZIQyf3/zbNUdOm/JR4amWFVkVNnzbrao6cbcfLVVeQQaf401WCSwNnVk1EbY
	mhQAmKNtN+2c09v1PUVc1V/Iv0NByXs=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2ed01ba15so72054985a.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763644847; x=1764249647; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GaI8T1P9V7HUSR5GC1P83jhUObFww+4fRanAKkUJgJM=;
        b=gy6DDeuaGX6pLrlVo6eBF3Z4WV0On52R3CrgchMwEX7ll0ZEnWjbLVnCJafe+lGBLP
         Jo5xFqKYZE7bRKjur9YCejUp4hJfQUoI8P0XwJyima5HzN7lN5oj/vgrchLOxl63dDah
         t2FrWmYLOjq5Byj/0unCEENt3C89AHH+rXztEAT6pFK+fyBmg5WO3StAE6U3wjMkogs1
         ugmlg1enrmAkwLFtBMYGQtK0MQbn/Ts33XKvGBOjSqTCR7PRpeP+P6EY/sb5iIOdIIeV
         Qt9pekOlRiDAE1YzwANzSIbXI1446uBoXWPz0H07A3si5URUplnARRqb/7ii3JdZKrJp
         61Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763644847; x=1764249647;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaI8T1P9V7HUSR5GC1P83jhUObFww+4fRanAKkUJgJM=;
        b=TZG48maJgloDpomxE/Nae4TyOooxMPYofsAaeN3pJpd6cl8ujHaWrIfWThG6rPtoUM
         BHCkbn3SMeyPgPV289mycAofVcypxziiOimybHQJsX9VewWQBEztHU37Pv2sXsg4SGfF
         9LeWxWi/ncswuPfq6Vjjk+hh3dPwjwFjGMrm+nVlGlzCviBE0wBmimSjGql9g8tRhz5R
         iyUZHblPjbNdPoLS40tqyvfCb9QWdoGq8V3n7UpggUrxX2gr3r2ZTJT/9VeU0LQMb7AF
         YV2DYQkbdlxs5tXJ9UhJlEU9jqCq74/7R1gOs73tTJhFr9cW9/9BuYwIkm5c38F70IlE
         hB3g==
X-Forwarded-Encrypted: i=1; AJvYcCVXD7o3ewwP4X4ny95a4uO+MwvJOKxQ3JBBAkXDa2anoJ3en/Wyc/Ougp2Tqd47M+XX9QM75igdmA==@kvack.org
X-Gm-Message-State: AOJu0YzwezTJELVsouXiOv86xj7HSTxyu3Bvl3SXXKz9pMvE6l8soCaL
	mWSqAPbT1z7qry2bnGVon5qlcfP4w/yfQmB68rxA8y1qS5C3E8ZzLPkWYhEfVMgZUFs=
X-Gm-Gg: ASbGncvBj6Vq47KvzFSuIjd7TbGCtEL7J4OTUHassijr//mLl/PvGby63bfi566kkP6
	ngDNnARsKocmdPutZCrji4x+rgdtEsGMq+jCpIL8AEGcNakCW6CH3Sq5oFUpCNci8L2GPFkmWEY
	D+3zISmRQxIIN0NyGwrEvLyLxRLjQAvopkcpJk3UJm3RephAILdGxCnBw8A5VXrMbP7af+DANqV
	eZ6w5esYgggkWm0ZCr9RfPY2Rv1pgaVFjYjHkth73M/70bscrnaG3VXV5EJ7uax9pMpAiaHx/Ln
	yafg0p0XkMTGvFePyi2ABrkNUz2clQC0Jd7FvCHUHvr1bf7Qtq52hlY7FP+NvaTehAU555o7Ecl
	9ZtqWi1Rp1mATdNeod0lTkbH6G/bEIOaIu3lRDJOg/SHptp1ezWvvTFo4WcWCbFMeN67NfpK7X2
	YhZQrMQnHWmDZ034jyPBzWaKORiuKqdwBR1x0RYCy4O20qYwByGOfBPJvE
X-Google-Smtp-Source: AGHT+IHQ4fmxCAI4/D2tK1B8sYqUFbudidu6PckWMercsX/iRS90WBjHNHkg95yPWC8b179KW1QKQA==
X-Received: by 2002:a05:620a:318a:b0:89f:27dc:6536 with SMTP id af79cd13be357-8b32a193b85mr303322785a.54.1763644847316;
        Thu, 20 Nov 2025 05:20:47 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295c13ccsm148498285a.26.2025.11.20.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 05:20:46 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vM4ac-00000000gLM-0tBz;
	Thu, 20 Nov 2025 09:20:46 -0400
Date: Thu, 20 Nov 2025 09:20:46 -0400
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
Message-ID: <20251120132046.GU17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71CCD140015
X-Stat-Signature: y7gijcc3ctczuunnw5q3toke8e4sqgah
X-HE-Tag: 1763644848-983977
X-HE-Meta: U2FsdGVkX1/jf2c2u5vjwJtWWBrHS+T/Un0Dka/fiP9njM00aJzNLsuaIPLJIKT0GOvT+MkxHmDnfqxJrAuPnxfbvyfH0eBiTS+3vJq7CWteilTl9NtrCy0NdsbvCf5GwqcZqAI42cIxFIp8YPdno1dhmf3xeAZIIc5CNSOQTua4IGy8JX/5ApfwUQGt5C8mvpcVWMAJpBCfADTtXXUepGgVaNihFwB5+8j8eQgaJUoEZEGLYQLLQRjHw8FXXmMXJayR9ZpYnvIuIWY8jMsdRtBdQHD7rKQ37q42mtS56gILc8i1JETBrF4+9DfrR9d6d4rz7+g6A7StPH1E1g+NegKkAevnDv6oc+tAB0E83E+/TmyBssq7ATz3Fcnbi1qCQtyADu1pwJ1DBU19jaXX1HVWeesQRQ433QzvJHEP5gqehYxxl5HiqTLee5dbqJ0L24j1aMNzd6r/G65wEbzlFN6/bkhPp6pA71y2lMEKQJ8Omd7aNm9kp/r5OJ+TsGfriO9OzS1PwE2SUQKjUSdso8TuOtZRyxLUZmSz1SA0xUQwZKsDtteqtibAiwd6FZ+9qXPjEGGcmTaFjvoPmQe4Q3+Uk5uXpEMTi5Qfb7rGu0aORLyb3asMr/MUZzj38XQ877f5skX1vi10dh5ajszo/OEcZ6cFwgZoz9ecDn0tlsqFt+Y85z5H47Bmio7p3NhAN+N3tWAot6YvKxA+7YJePORoKdLeUylMhJ5El7oE8EV20b8XLctvW9l6xa6PN2xOzANfrRWbVUZzlB2kFOSrB9t+70R8RfkP6C971FyiTUIKmkoEjOoWDbo7ow94odgFA8JCApKgPu7htU9sWfVU8B0LjpiHMJjOoYak1Bg7ZWY23FEoT46ubD7tDd9aoTyOMOPb99P/PCd9mKs9I3DsT+EiX9nNcvUK8XtRCEXjAg7I1kMGh0MWZYl1DDKNARGN/9CWsEDO6/UgoOKWCTH
 GcCWNy9L
 pdsOL9tHSPZUAeTKfJPpl0WaSl5Q+TfZS00uWnoIpzIIy2mgnjZLNOHS26+i5akxGpZCBOY6iyZ4f/RMoajg64muVhFk67QNA8xzAJDQ9Bk4B21mje6h9W0DQhEurVaALCD0BKbnJOo5UUd5LORgf60+iaFSw0HuqfBBPgNHri34kSEQGsc8EJJbI9aHd6BqPqYDqOONphGvVENVI3SDkFnseYJmuG368Jx6EOh723SdOVnaYe0+h2WRZQzp7PvwW/1oGnG2faqxI/Q57Pq9U4UziG4L7+FHLpEM8BdX0F+OW0CydiJsfKEvDszTidrEmXD8OEVWq+1RepjZz9PRs7YoPTtQqz850RHqUzSy+guVIoU++UTvlpvv9dgPlDQb5WKtN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
> >> The exporter should be able to decide if it actually wants to use
> >> P2P when the transfer has to go through the host bridge (e.g. when
> >> IOMMU/bridge routing bits are enabled).
> > 
> > Sure, but this is a simplified helper for exporters that don't have
> > choices where the memory comes from.
> 
> That is extremely questionable as justification to put that in common DMA-buf code.

FWIW we already have patches for a RDMA exporter lined up to use it as
well. That's two users already...

Jason

