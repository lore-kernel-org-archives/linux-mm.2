Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F80106ACCF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201F16B008A; Thu, 12 Mar 2026 12:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3C76B008C; Thu, 12 Mar 2026 12:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110EB6B0092; Thu, 12 Mar 2026 12:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00BA66B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:47:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970841C393
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:47:53 +0000 (UTC)
X-FDA: 84537992826.11.29D8117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA5054000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:47:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sk2jgHEx;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773334072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5rcVNrIGFHHabNrtksNEJRyhpjC7StOpagdUtZ5YEE=;
	b=fr7eWgm8J2IIIZzZUx7Lgb0xCI9a46+NShm61aQCdvgHzI1FA38d611FrY6doVw6/NEe/n
	0CNhzIn916llKKAG5INXwcNu+egm9MheKIwFAzuXGI4XE0IOmrov8HhEf+4wzG3EidVV4B
	J0a2qtiO+/cpX//jgsQXZyG4H3j4QR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773334072; a=rsa-sha256;
	cv=none;
	b=SrRulnIiqqU1edjLL7SY+jBwqBjOfSOI8yR03SClDgleLUzSx73nu5rnDCuJtgHfu76r8R
	ltPeBAylZsdj+hg1eLYwfhrn/LiiC8gb+gFxfzAuXE7tqeC4GIUtVh96gpY132R81DGUJJ
	gxtehgxbFCL8jfO0/HWxX/oW+kkIPqE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sk2jgHEx;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5F2E4403D;
	Thu, 12 Mar 2026 16:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4EEC4CEF7;
	Thu, 12 Mar 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773334070;
	bh=bgaeZYcsitfVCRSp3Rb+I23Wjj9WuTcz7df8k9CxCU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sk2jgHEx9bowGHuBUzaTSIxN6dUlkVZ5hiKf7nbs7hz2diGk+BqZlhbT3RVHASW+t
	 Chek9Pxn+aNegRCgrWLKCc41aGJFNL429DoAlqDkqrfAksE8bx8qjVtW8qPl/E9554
	 fL5fjcd2PTMR53v0L6TdvU2THoyhfWVUwsHZx0z557SH71dZ32MbJ2/ROUh1+f43Mw
	 y2hPlFqV7pRvRCga0doEN8wd1K3aoRv147GHVkDLPuW/0DGR3VKjHMbdgaQXZ1IcBb
	 9xrq+LkDTQ+VuDVm22x3MJM+kg1e5RtiEnHVaUwye0odgqLVuMwo08x+iJeBE7/abI
	 +kiyEnpHUEX8A==
Date: Thu, 12 Mar 2026 18:47:47 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/8] dma-direct: prevent SWIOTLB path when
 DMA_ATTR_REQUIRE_COHERENT is set
Message-ID: <20260312164747.GA12611@unreal>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-5-e00bc2ca346d@nvidia.com>
 <20260312122058.GE1469476@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312122058.GE1469476@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA5054000C
X-Stat-Signature: 88m89c6auhc3oehuxd1quti4n4d7o98q
X-HE-Tag: 1773334071-987493
X-HE-Meta: U2FsdGVkX1/4S9BXH5zVpnevfeAYBS7S0w9IqlmLH+GJ/49ykMB9tzBlrAgZRLuI1+BAQ7o7S6u8CznEHVFOK8U/e2TYMdkFBmGGZk2/AoazyZo6g13GMUVBRCZj6vFgFC06A+Vq5HTktYKnCxvgFbx2/dA7/GvrOWOUA9voCn55BSWGdw1Hj81wEqqf9MZAaBqAGMHnb8uq4piIS0RlsvOzpN4+h/yoluoie5Jda1JX8EcrPt5bUpQSGkgPc+9x80EIFQ0Mv68RgbwhaQeUn1Ko+8vHeSgpAGQEDNjyKl7j1mxd6MowZha5iPtYpZXMFqm0zYLH0ThQ5LXL9RArSe1J0QDYIi8Jk9A2V2ZcGAZJQb5hODJpGIkWkohrrHF3tni24RgBrDlym/uLfgIW1GMl+4YeQwlkrhoNJBszRTUXN9vJYmqm+3iua6Ey3AfhkJjhnKg/CtfKKHE49MP+LmCGhoEC2dx24VYg5mza/Qre5K1s3NN3z+CTU2nVd8oagP+/PAZNKwaP778WRe6YFzl9yhK2HRQkITu7X41/Q2BBPhpmM7Gy/G3ivZXYkJsU+0caoQ5SdVqOJF5HJH3EPH3qKwAACTgu93AOwlaCpVC1aeUOTnujM+u8SeKeKfgerFt/lvAKR3GFPzBRhKb0i7Nb5d6nPCyP49M0ID4w0/BrADrP1iDAOx4akS58TkgVmwEPdOiWQSVJ4ZpB2r54tdOxZHjfsSd7h03EzAs9adHVY/u664vsFWr49acpX/TllHY2AZhNnbuyCSl6IL5i81WMaCPe64SkhYZ2gwfuqF/YDxu0RRexaHHCxceTw9MilXWqZ0OzV/m9UCyh/SWS3KCCzwT3NoVoW9bMrXzEWJYj4158yVhiTO6E1ibJOaFWz1RGxlRbyls0tZmMpUKgAqma7a9V48Ox4Y82LQ9Dg7e4MP7Zddr27dmk2m/fxtWqNWpFKv0pS2I0YPGhMJO
 +tIUTz5K
 ax2kVlMIGoY+i6L2fRf4h+E9iwFOiHzNQa8ltxtbjZD+4f3nYR/j1TRoHxXP760MnlY2Sv7/46MQbwTnw6lZW4PFCfrL/caQZ/a1QIyDQC3wQ4xOWJuefKc6foO415PX0v7+BU7Xo1IQvaFyK1yrpC0AKfSpaqGh9m7m3+okz7qLOz/WEuKxxLb1nOPu/EoVqXCSdcwjPJtJnLtr0IuQ6TxybovhUwXcrNMX6vpXsHOLf2GSScBXfUT0JJne9AVanCMmBXlEA1ZMU1D9c+MyFE9Q4H8cBPEE4RVl8qjhy33MCLZ/+pesJzFxyHdss8cC+DDT3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 09:20:58AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 11, 2026 at 09:08:48PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > DMA_ATTR_REQUIRE_COHERENT indicates that SWIOTLB must not be used.
> > Ensure the SWIOTLB path is declined whenever the DMA direct path is
> > selected.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  kernel/dma/direct.h | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
> > index e89f175e9c2d0..6184ff303f080 100644
> > --- a/kernel/dma/direct.h
> > +++ b/kernel/dma/direct.h
> > @@ -84,7 +84,7 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
> >  	dma_addr_t dma_addr;
> >  
> >  	if (is_swiotlb_force_bounce(dev)) {
> > -		if (attrs & DMA_ATTR_MMIO)
> > +		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
> >  			return DMA_MAPPING_ERROR;
> >  
> >  		return swiotlb_map(dev, phys, size, dir, attrs);
> 
> Oh here it is, still maybe it is better to put it in swiotlb_map() ?

It is better do not call function which is not going to work. We have
same flow for DMA_ATTR_REQUIRE_COHERENT and DMA_ATTR_MMIO, which both
don't work with SWIOTLB.

Thanks

> 
> Jason
> 

