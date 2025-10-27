Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9253ECCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 13:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29D980051; Mon, 27 Oct 2025 09:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA208000A; Mon, 27 Oct 2025 09:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFA680051; Mon, 27 Oct 2025 09:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAE508000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:14:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 416D213B46C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:14:49 +0000 (UTC)
X-FDA: 84043939098.28.2F06F5A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4927D140009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:14:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761570887; a=rsa-sha256;
	cv=none;
	b=01W36LsKRa8oVPIMKEqUFs0/2VGU+w1iZwBp0Ok2aCgUlIGQlPnROur56eSNnKu5VjXgvV
	eZTD9fvXz8rl7+2V/AiM/IxEs8LE8VIgIAH7e/vpnFTQ0bylbNy0k0eumecXmqUPQozEqS
	7eao4DVJUYseGsqAB0eFUHc9k7EUSTQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761570887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nvzXeJXc8tOnrhhKkXfN+20PVy5pTVhPY1emcEaZmTo=;
	b=P9gD+JPS1Q+n8rMjgcXGsxjinDuMxXVenVCR8QWiB82IQ00jU7kGTMYmy7l8SzPrVxTipn
	UgpIetKlj4tk7n86qslVEKVZOtuhmVkgv4VfuDdKhGRxWbfqw+cmhtyAVa+siDhsxdSemY
	PwORXwprQdMWxhqXmJMlMAR9y9ojDlM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 867B6227A88; Mon, 27 Oct 2025 14:14:41 +0100 (CET)
Date: Mon, 27 Oct 2025 14:14:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Message-ID: <20251027131441.GA26554@lst.de>
References: <20251023080919.9209-1-hch@lst.de> <20251023080919.9209-2-hch@lst.de> <aP6QX_gNpY9UDtub@casper.infradead.org> <20251027064728.GA13145@lst.de> <aP9u8lFBvzEzmuHh@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP9u8lFBvzEzmuHh@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: awcwfar34drkjjorb5izbtbjcy4gpxos
X-Rspamd-Queue-Id: 4927D140009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761570887-67196
X-HE-Meta: U2FsdGVkX18PPkLnA+zG8uMzhDc90rbbZIh3e7+ZEpORQZRM0//OWflr+W+iz6BXtEYm0u2B9y6QzAozv2cZCm56cBsfmGPWmcRh7yPPO+48JDGqFLwbKrtp6QBIHqMHjRUy2tg1YOQyC3xD40SNSTUDA0MyEkuG1pb138kcZ1te9pzwI4dNq3IZMg7qiNARXJClDs9VIfvfdOnvlfw9Uo9/Ffrd9WWfKcgAOREyfK86xFGzp1sXIit20ojtZs7U37ZQkfACyHdIkz8mcTKScEyIofD57X4snSna0dADTD/wuelUxD764gKye6rGWwerf1B8P6QPDT5H6Q8TDRIMma3z6JQ4iukvO5H8wt6m5KaS/4b9xug5O8B3vQXCvoN6wlBEvdYno39TrtiYdvJUCZKJOGQfs6VOmLhhpKCE5FfdZBUGzvTfoLbX4YqEs7wa5wNr+z2qGpxQw1zYM2GTdNUjTrNufbPGz2j5v0UqHNK30Q2q5rUIdW6kXc8tYVBUlOuY5EeHmT5eT+xIq/ECreZBHakr+5bZUsCpMgcgyZPK/qg/ViudDk29mRBI0ejXy6eGCxcJAPgf/dlv42Acx4nmYjKri9lp9VScOCNh0yACRGVsYnBPOZ1uo1qybdyD2IxxQRvIxfiTy/jkXB+JAm0WEsJOYsV81VwQd2Mg/CnyCM/4y8KXf2Z6jnz/Tf/wINUVuAsxUr+tyFXOt5E0Cc86J5zCLLOxw+/YAjllWb73POCS9Lxc/iqSS37kS0+0dFhs8F8KBHO5TlKiWFptufE7A1pAtgZB7l7ppDs+Ty7U7ZQVBNG5jYfzazPj2MlNAOy9K3geg9N1gBUilJOuOCbX+8F+ubzNxbnt/dzntih1DNeBGQv7m5XDGPUccMivvEfm3LyvZ4pIn1ccwy4Y2qG9S10jUoQBoW7iQ0JRqj6P49qOEeBNouMiulUpJRdAhOmHsotOhN7WB5LWvR4
 DgaJdCkR
 TLVi5leH5JhAvbb+Hj603GzKnFLOFoOegLkXzRRS3X6uUh+3AIrOUtwz/7LaIJ3Yg8vxqy4HVVPERcYvOm1QeyXkpySVU+KRF9ubAiujDhLSIaMHswmN24gf5q+Nbjus47/m1bgl9fMNI0io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 01:09:06PM +0000, Matthew Wilcox wrote:
> > > Is there a reason _not_ to use the kvmalloc code for bvec allocations?
> > 
> > It's using a dedicated slab cache, which makes sense for such a frequent
> > and usually short-lived allocation.  We also don't use vmalloc backing
> > ever at the moment.
> 
> That's not what I meant.

Oh, not the entirely kvmalloc code, but the helper.  Ok.

> What I was proposing was:
> 
> +static inline gfp_t try_alloc_gfp(gfp_t gfp)
> +{
> +	gfp |= __GFP_NOWARN;
> +	if (!(gfp & __GFP_RETRY_MAYFAIL))
> +		gfp &= ~__GFP_DIRECT_RECLAIM;
> +	gfp &= ~__GFP_NOFAIL;


That's missing the __GFP_NOMEMALLOC from the original one, and also
__GFP_NORETRY.  So it'll be pretty different.

For now I think I'll just either duplicate the logic or keep it in
block code to get the deadlock fix in, and then we can spend more
time analyzing all the flags and documenting the ones needed in
various places.

