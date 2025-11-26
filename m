Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85DCD11181
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275C46B000C; Wed, 26 Nov 2025 11:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24CF06B0032; Wed, 26 Nov 2025 11:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163666B008C; Wed, 26 Nov 2025 11:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01E586B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B431B4EF78
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:08:51 +0000 (UTC)
X-FDA: 84153241662.25.BF3AE93
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf02.hostedemail.com (Postfix) with ESMTP id D65378000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:08:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=CATY9ftr;
	dmarc=pass (policy=reject) header.from=fb.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=74256e3cee=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=74256e3cee=amastro@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZmYh6YpHcTCE9H3NEMwSXw1R9ZP1diRqyx6ns/UxKM=;
	b=a44GI0952K9UVJT5YSeXmPVCHSEHM5eLDY5SJrauQySeOlXVDXtq3t99WKSQszcT+IwBrj
	x+s0LwMZIRQtQGO4UtR/KymLRtcOKrNNx6NgCs5HFDi/K3QauULSkE/RGN6O2Md57wHxe3
	VQrb9vR6MWpj3nY+PYBe8oEyztBR3qk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=CATY9ftr;
	dmarc=pass (policy=reject) header.from=fb.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=74256e3cee=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=74256e3cee=amastro@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173330; a=rsa-sha256;
	cv=none;
	b=rNF8sDFPhsUk9fCoACtK4Qj8MsRx+rty2TQguq7atMq2ekSQtz2yDqdtdyFsBi2QkgLWyI
	YmSIDGL2vtfjHjpTL4jnuCfoqgindBUJHwl7VuVhtTV0CfLzvk2BVc/QWg+9iB7yAzYgGY
	PLBc7Nqgk4uUeHvwnfhVrjyrr5ODrcM=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 5AQEPbd43733913;
	Wed, 26 Nov 2025 08:08:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=oZmYh6YpHcTCE9H3NEMw
	SXw1R9ZP1diRqyx6ns/UxKM=; b=CATY9ftrmS7XqrrPh2Kw2+U4yOLTDIOhQo4t
	fT++bE5QnXUTTDj1SISKs+UQWWlWXESUt4Vk/Uw4ZSdu3sXkySe9GBFHO/GtOEWQ
	411l/Uycz4QsElZjqmNLTTOC03Bk3xrahRxGe2dTAYG3Xw8/u0qaXvlwf4Qf+gzA
	RQRz/m6jwIWn7OkNdO9JgYCJ3G1u1eeNgwfmMCUjXO0Y/Z5VrkUOlbGe0Sigp71N
	fPi2jhyinHmV7dk2u+LQ68tQs+O+aJ2d0sCNzYiAXKyb0pPsIXMYGocj6ADUHnCK
	VMnCClf+dI7uC/6KbcFfIu8b90bADDeEXqso0Amh6UxzsGo6vA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4ap3a78uqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 26 Nov 2025 08:08:31 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 26 Nov 2025 16:08:29 +0000
Date: Wed, 26 Nov 2025 08:08:24 -0800
From: Alex Mastro <amastro@fb.com>
To: Pranjal Shrivastava <praan@google.com>
CC: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
        Robin
 Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon
	<will@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jason
 Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan
 Corbet <corbet@lwn.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kees Cook
	<kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ankit
 Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer
 Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Alex
 Williamson <alex@shazbot.org>,
        Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <kvm@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
        Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <aScl+LCPN2TiN7Pd@devgpu015.cco6.facebook.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
 <aSZHO6otK0Heh+Qj@devgpu015.cco6.facebook.com>
 <aSb8yH6fSlwk1oZZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSb8yH6fSlwk1oZZ@google.com>
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzMiBTYWx0ZWRfX3bFJkIqQfPcn
 LWbsluc+XiO7FtO07pm/tzene/bBlAJbYXetaCM2lBsQPJ7MYrk9CERNphaL5xKMK0Fnvy9OfVQ
 Y+bU9q7WY0Uh4Ys8J+otFMneIfwxv0xQluXqaIjHKTPEMVRe0iLSwQwQAHlspppJcXBPJ55pvJz
 JZGujlxTRi2Y6L0eYmj2p7cT3nMIZvFmJX5h1nMX2rkgpOumcUuD7Oe2fNXk47TY9k+6i3mWPRm
 +1gsqEAXdsAGhXv5RuZTmDTEo722fCpYhIfmTOQnzXGxfUvfRTUYuIHNc7jrvUJJ3yy8os7MmWa
 fQzyxL3akPGWodtrtHsYmp6smX1T/MBPHuER3U7LA5bJUfQjB0xkE91sw0JPQLAlnjtXtOu0oRF
 6D5ufStP6OnrcDNfC66Kegl4bp3vwg==
X-Authority-Analysis: v=2.4 cv=AJKKJ3lP c=1 sm=1 tr=0 ts=692725ff cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=B5NVPXpBE_52QoX4XTUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: jOyqyM0SasvNGLs4etkYDuX4vfn-Z9b2
X-Proofpoint-GUID: jOyqyM0SasvNGLs4etkYDuX4vfn-Z9b2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: D65378000B
X-Rspamd-Server: rspam11
X-Stat-Signature: dd1gx6mw9sg7uoj8bhbhjg5oihjjd8hp
X-HE-Tag: 1764173329-720970
X-HE-Meta: U2FsdGVkX1+L/+R36NPfoJKe/aW+elBAxg2YTDGVIJAq5+okCsvjzIGyl6JDGKA/GU6WLknQH2TLGw/mrnHvRz3NGiJ1RMST4mmjQ5NMl/Sq2HNiVcmDPWoOnddo0RnIrjon15UwMxIiVRyvA8YpJYlOlnWnWzm0r/2KgaxooDoD+CWqdXBERRrZFXOKOhK531ITaSeO5wruFXvoWb/rV0rFVJByU7DTNo5c2wPgTR8oXIu6te7+An840FkmqfsROJNSvhorAVQiOMofhDcHdSD9aTZTNZaB3bAZKDJ7LCBQUs+JZKJZMpT94GYRVfqKxtTjJmqVJC/FTRIT0ovP+6CteB1DHX3dXCefm2uYHTH0iStdb/QbWg8mHx8NiovPe7WpvX2zdp+8OwnH/ZIqnLrt1XsmO77CjnNADJKofN7LSna4/GGnk6ORip5IjKUna0C45sbFyTFOX3pQ3JoIokxuGAPqboKzYGVMqN/tA8sIgtvRBVRdcrH+azpqamG00YtFf3HRdzDUtsFGg2bGU+/dl7wZF1c4C43jl5Fsnq46jM5mGDQ8vaAGiW56H/9SP8mqDSmsltt5yPl/+y1tHJSqr/h7VjGntq7wMXQaALADynKlEMSdA6rcxkIl4KqS/61HqQU9PEAuZxKNtk4jxoxjUlzFbOgr3GhFpd8xmY5zj4XzNFVyuDlVBZDqV+Y5eOJanlkmTAw0Muv3ZIjf9MQocMZHytXuaR73YJxSz1yeCDn6YQwft+Nve9jofvgs+5kkU9M7Z14kLm3iGqax8yHHdcg9VlO7rjbAJ6FtoiRFpEPfoe7eWorkmmcUMVsgaYQnTJRE0Zfr+nM32XTlYIcb8deHSUo16mUjB7VXOvtO60aakeuOmNef65XBA2WPze8pTbNZdqN8oa4F3DBWhNbDAUOLSr+XBLobQXySeD+cDoXmB+xZXXK4ycMFbpWysHZ6CU7fqtFRc09INlo
 1245YXIj
 8vHTX+/Wg7O8EKqhMM1b8e1lHm1fFlGZtuqcPGsDGUFaJPy2FJbAEs1QCpwkbuP4PaQqLG/VkAv/lCAaCXMdMEaBn+TEhUb4qXHOFDHDfh+c6irdpga2lYMC2iyklTb07eEgFFlfTKgwQ2ws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 01:12:40PM +0000, Pranjal Shrivastava wrote:
> On Tue, Nov 25, 2025 at 04:18:03PM -0800, Alex Mastro wrote:
> > On Thu, Nov 20, 2025 at 11:28:25AM +0200, Leon Romanovsky wrote:
> > > +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> > > +					 dma_addr_t addr)
> > > +{
> > > +	unsigned int len, nents;
> > > +	int i;
> > > +
> > > +	nents = DIV_ROUND_UP(length, UINT_MAX);
> > > +	for (i = 0; i < nents; i++) {
> > > +		len = min_t(size_t, length, UINT_MAX);
> > > +		length -= len;
> > > +		/*
> > > +		 * DMABUF abuses scatterlist to create a scatterlist
> > > +		 * that does not have any CPU list, only the DMA list.
> > > +		 * Always set the page related values to NULL to ensure
> > > +		 * importers can't use it. The phys_addr based DMA API
> > > +		 * does not require the CPU list for mapping or unmapping.
> > > +		 */
> > > +		sg_set_page(sgl, NULL, 0, 0);
> > > +		sg_dma_address(sgl) = addr + i * UINT_MAX;
> > 
> > (i * UINT_MAX) happens in 32-bit before being promoted to dma_addr_t for
> > addition with addr. Overflows for i >=2 when length >= 8 GiB. Needs a cast:
> > 
> > 		sg_dma_address(sgl) = addr + (dma_addr_t)i * UINT_MAX;
> > 
> > Discovered this while debugging why dma-buf import was failing for
> > an 8 GiB dma-buf using my earlier toy program [1]. It was surfaced by
> > ib_umem_find_best_pgsz() returning 0 due to malformed scatterlist, which bubbles
> > up as an EINVAL.
> >
> 
> Thanks a lot for testing & reporting this!
> 
> However, I believe the casting approach is a little fragile (and
> potentially prone to issues depending on how dma_addr_t is sized on
> different platforms). Thus, approaching this with accumulation seems
> better as it avoids the multiplication logic entirely, maybe something
> like the following (untested) diff ?

If the function input range is well-formed, then all values in
[addr..addr+length) must be expressible by dma_addr_t, so I don't think overflow
after casting is possible as long as nents is valid.

That said, `nents = DIV_ROUND_UP(length, UINT_MAX)` is simply broken on any
system where size_t is 32b. I don't know if that's a practical consideration for
these code paths though.

> 
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -252,14 +252,14 @@ static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
>  	nents = DIV_ROUND_UP(length, UINT_MAX);
>  	for (i = 0; i < nents; i++) {
>  		len = min_t(size_t, length, UINT_MAX);
> -		length -= len;
>  		/*
>  		 * DMABUF abuses scatterlist to create a scatterlist
>  		 * that does not have any CPU list, only the DMA list.
>  		 * Always set the page related values to NULL to ensure
>  		 * importers can't use it. The phys_addr based DMA API
>  		 * does not require the CPU list for mapping or unmapping.
>  		 */
>  		sg_set_page(sgl, NULL, 0, 0);
> -		sg_dma_address(sgl) = addr + i * UINT_MAX;
> +		sg_dma_address(sgl) = addr;
>  		sg_dma_len(sgl) = len;
> +
> +		addr += len;
> +		length -= len;
>  		sgl = sg_next(sgl);
>  	}
> 
> Thanks,
> Praan

