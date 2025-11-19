Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4CECF58E5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 20:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0206B00B0; Wed, 19 Nov 2025 15:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960BB6B00B2; Wed, 19 Nov 2025 15:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FA16B00B3; Wed, 19 Nov 2025 15:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72E2B6B00B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0238289985
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:45:48 +0000 (UTC)
X-FDA: 84128538018.23.ABB9AEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FAB840012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:45:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qlv5a0X0;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763585147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRGtIuXoaVyPZwwwJp6A530OStpFSjyfFejKKpi1H4Q=;
	b=F4405DTWSV+h26NUjNdQyOaiyIPzpBhU0CPtQ1DtLtNAkOx+TeE4WYpvUGB0uvpppOdo2V
	fadq96EynMqBRzbv8sWOQjmyD1x2AJUM0wrTCVXUw8+ZoVmste4pFzCA9ZTTwA5Rl91idZ
	GoavlUxVrh0WkTDQoJlUC8PxQrEWXss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763585147; a=rsa-sha256;
	cv=none;
	b=ihZ6xzsNxtKeIs4RecbWiaMHCVmYp86OQqKNwLvEhkty34kwoi1xl1cHeGmuy7ak9SqPb0
	l71ijdGSqIggYSRxZdHWdBY1BrX5HL+vxqAKAW8WHNL/pI54A1yiG2p4MCoegVe1BwLRDo
	Gg/SQhUoCUcxVWsEjeUYHsAjU9uuAPM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qlv5a0X0;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 441AF6000A;
	Wed, 19 Nov 2025 20:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F3FC4CEF5;
	Wed, 19 Nov 2025 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585145;
	bh=5rI8lrrVbFn1InvbQielmCucdPk01bWsAxmwyIxRJJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qlv5a0X0ngRKyFh2JKVmpc2TkyYK/DU2m5BSvUPEl7BnF5Z4h3h/m+RqO7z1bx61m
	 rbyyfMoS9aqKBh0aUmaaII2BVk6WpQkAzGGpg1rUG+s8HZmAW8WSgoYrh4VjU5XyVE
	 cn3LgrCO1dpfJBw5cCJ/USdlN3JLkb+DpB22klLCEqHAbG4qjTuayYPjr+pzzDi4EO
	 R0Qx5aJ2BOOXu+TPpbSpmwtVpBrFTUylK5laErKZm5ellYru+TJRCMyV7sgWpV4Qxc
	 Y4Mw7ZQsZniCIYFf6yWIotwra9fYcCXVMUXRBjbCK8S0k+X0tqBTMuTL7f8E/JttUG
	 kQjOcbKaf5FSw==
Date: Wed, 19 Nov 2025 22:45:41 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119204541.GN18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
 <20251119133529.GL17968@ziepe.ca>
 <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>
 <20251119194506.GS17968@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119194506.GS17968@ziepe.ca>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FAB840012
X-Stat-Signature: 43gfjf3m57chpx3mamrwwtbkcjr11ac8
X-HE-Tag: 1763585147-772309
X-HE-Meta: U2FsdGVkX1+S1Seehtn/hPNRj59goakORReiS2JlAW3CKCE92IF91PcIoQEhK2v4NC5koISoI2HsVhSqZ7iyOLnAjwdPxofuxy1bNPISbGZUvaNGy2OXcCi7N3+6FVm7l02/H7RelRsXk1Y5T+6nqKlySo3I4fUhwqdgdUFC1BXyroiSs+uZ9r17hAmCg+6DQNXL3MBy9vlYlKXEdAWUPbFLOKjOTHLBU0ezIWlSvy6g/A11FV3yqDrZPilDXXqNm84JqGM23y2O2gxvvqsggfvazkuq8/GQvSk1fmcoxNknCu+ck3Cx8a2fRlXyrCWGbeL7QhVVHWlWP/g6vwhkFNa+v7sRJYVmGFGiLH1N928H05PpQ+d66Rdy6d6xfqCxqmfJMpT207rFXms6MuTtjY3VjRf6HkKnQa4hRJ8Y1LDpvYKUze4lTKVJkxiLyOQi9HbPf4HK2FP5TcAbdjB5+EDeF7iUbE0RX9SIIqEckbPnRtOoQiKWSUdGgvXu9Kx54DFDB466hm4WTGvGNlB2cRCHw4jyJGulpok0Gg1Wdj7ffMuPN3DujDU8rXvDI288Ly4YA6c0tOUVILsvfOCf2iRyQU6m0q3Nb3gwYY0QmIevN+vzmfnjITmuGvw6xWHAuV+hn1YhYFl/4Qt7YbJ1FEqJoCd8x8yeY+QZ56Y5x/hFgIA0O6owVKHlNGl1rgLBl+mQWW8ItDEty4qghm2dUsM5Z9PeROYEfgV6r+bPXSmP+fx/z6PPyV2SmVQ5cztVgW8KmQyKsgqEtilpsxIcLbKIlyFMUNRsBT3eyzcvWANbOPZFw3ZG5CGui7Gmc4jJATOjMPyjhBUJfmGWLOmjsPOmh2eD/UrZEScD+RFO8NoUv40OTHPpolVZADxKeXWza0X+F6mnRIiSJEyKNExXF1bAYU2WHy0YfYYZ/mG2snjgDn/op0RNFVoPNdRDFlTwWL5yve6Zp0h7iJxhZ+X
 YxEgQ3uv
 9m8SF9qxmcgTRfqRM/yj9tIgiqla+BcaF+Oe3VH9K7H2+NPfskvZiE0mgna5tticKZ96dKpggeMJn0J0y6oNNLX7oZp1f9SVXSOXA1jJwBbhAFfyLEP0JspZaOezlxObDF60ZIR4oG+26LDYggt//rgm2VffkpUk8/GkQzjQ2PWsct3lSSgmJpDW54U7EYXpuWIFUH+M0d2OVnrg6c+wOfY9M0qBsqsZYisgs6d+uW/XEICEozjd/QIvjygTnicJjXstDDVhUUiaLrmrZScMbccl7yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:45:06PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 03:06:18PM +0100, Christian König wrote:
> > On 11/19/25 14:35, Jason Gunthorpe wrote:
> > > On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> > >>> +As this is not well-defined or well-supported in real HW the kernel defaults to
> > >>> +blocking such routing. There is an allow list to allow detecting known-good HW,
> > >>> +in which case P2P between any two PCIe devices will be permitted.

<...>

> > The documentation makes it sound like DMA-buf is limited to not
> > using struct pages and direct I/O, but that is not true.
> 
> Okay, I see what you mean, the intention was to be very strong and say
> if you are not using struct pages then you must using DMABUF or
> something like it to control lifetime. Not to say that was the only
> way how DMABUF can be used.
> 
> Leon let's try to clarify that a bit more

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 32e9b691508b..280673b50350 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -156,7 +156,8 @@ Usage With DMABUF
 =================
 
 DMABUF provides an alternative to the above struct page-based
-client/provider/orchestrator system. In this mode the exporting driver will wrap
+client/provider/orchestrator system and should be used when struct page
+doesn't exist. In this mode the exporting driver will wrap
 some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
 
 Userspace can then pass the FD to an importing driver which will ask the


> 
> Jason

