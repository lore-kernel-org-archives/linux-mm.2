Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399EB10BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACE26B00B4; Fri, 27 Mar 2026 02:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5847E6B00B5; Fri, 27 Mar 2026 02:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1356B00B6; Fri, 27 Mar 2026 02:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8916B00B4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:38:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7C7B1403F8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:38:02 +0000 (UTC)
X-FDA: 84590888004.09.71E9AF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1EA2AA0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:38:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Twq5MyQS;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774593481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C0BskMdb6QU7c2Fzq/WYU03nVIksMh1AjYePrppYnA=;
	b=sNBBlv9LRh5sgC/1RrBbut8HeH/7IW7soTZuCAX3oN05RHXUKLBpXySj+on+dJu0XRMZYO
	p6xb3TbAB5PTnzTta8i5vghm4BlPPnVvW7qnZlI2V0GIpT5q0uCcNNfIRhYd9sEynK/9aX
	LQreVKzWNGJqfeQ5EIyBv8ShlJ7SSDs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Twq5MyQS;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774593481; a=rsa-sha256;
	cv=none;
	b=xi2aqjCrfCWVFngqNpPegh5eTBql0QrNTzslycxKGabvY5AiojgBDhe8UCgYDUJAdSx0P6
	RXUL//jXpHVdWNb3MrC1PWeMxRFT+SZqIV6CKfTLKmS5O1/IEGHBLfs5eWn0qbPVa1PyAl
	RRmttttMZqa2m78zcZX7m10CO/vVKRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2572D4054D;
	Fri, 27 Mar 2026 06:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE55C19423;
	Fri, 27 Mar 2026 06:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774593480;
	bh=HrnmeLkD5wmpSf6twO0rfiroXmNXU6y77468epKlJM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Twq5MyQSg58Egx5BZr0+ls7uvN84oPSehGSSuE46oaLtK6++g3ZwUTDbAWifQ2nhI
	 T0nNCPjQv9YHvL7DPx5j7x/EZt0sWxlkIZYMMlAp+LOUh0ItzOQw+izPoZZaXQVTf1
	 eFeu6hWYJStwAzWoRWfoXr7jXAPHaqv8FCIzMKRyGh8x3huVr4rjPvmIg2qXzWREua
	 oTiRVKin9vO1RSpt8Fn3F/BWKxaYHEsvKGcL+sa9Jvoh7IMbk8Z5IvACVidC9qR9Xc
	 uh1Jz7g4P0rnvKOBPzenGEDoAjJq6cWrTspuTVxyBkj3J/p1BA8n7pAUdnLCej1qJ0
	 21z2oGIdTbSlg==
Date: Fri, 27 Mar 2026 15:37:57 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
	Jeff.kirsher@gmail.com
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Message-ID: <acYlxRBhSMcwBnja@hyeyoo>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Queue-Id: 1EA2AA0007
X-Stat-Signature: 6113ob848pd5t8j4bah1piruajs3rud6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774593480-833984
X-HE-Meta: U2FsdGVkX1+2mn/uxy7HCJCFc2Z68EzkQW25UNOMWSWNRz3TQ7O7IpnwTvSJ9dSYUZzvT+Glhqm1c4lZ2oiZk6D0oILBfO8BP0O+9sslCAur3G65m7OGPrUm0O8DbZ/P15Wsfkgk+bGzDqYTNMtPAzVFW8YMYAxUlfRo0K+zrcYO3VC/kjCFr2lP7H8eA1UQavXpIt7qhApqQOjigUUwXq3hG4+s5Yq5NUMq0lRPoEHkJoQW3+18g23z3y+afa6zp6zYrLYRsuN94fFun9BEFhwHVcbPDZjl+v18HX+2eku5i8/bxxyfZURZBDJrdLcrmt0Hn05RAiOy/oA0SAkjNMlCTbKc9XFuOrG3FruPanG1a/YLx4Ia+r/Olzo5D6zsFQBm6muqqebNq38//ZzsxSprj0eb+yc7G5avhtsSlAGsNTKaiVyFxUpgw4w0Cd39p5ub/MRPzUiXrUOeS44yrcTYNATwix5zsVDZk/sxipugDtVp3lvie0ggoXEbHCs3WZTAPrdRIpVA1sECbPLAvHwX8TEtv/qxc6yCbU7YeDZOFR+mCFI/Qe0C2xZwHWKVoLzlXesISD28maUBJKL+qOcambI4L5Hls7jHsf1YfqQMUXK3kUXQHHZSqUfGZlts1nDoheesDWyY55gsQgtfQ2BY4rREfhb248V01TAMxrM3LicM4V0rNcObMto0D0LUAjYl9KsUDtH7td8uV/GPhuRnrNgfLnatftIs7kjfu9pU0MY3PvQpWXiQduuUwPV/iUC+UmyYpy9Vh2Agk0hToSbgUSkcnnxZTN5udY3ySTfNw8Y8AyGRqp1qi1ZdCMtVcdt4JmMunuHEpPR2yvCqi5zTvPDX48lDczTf+JesRQuXyUrYoHYboVbIB5/Zwz40mR81dDmvIKXs5IJMHSxQV/vZb/8hDITifdlbe+UpaPBUkOMinXDhaaovv8kvPWLjd4cSCIJ4KYx71Pg+69T
 Ak5WMFkl
 SzNZbEKUzm0KpavoHeKS9ONBu9KnYBahotTbj1IXnw/THUbCOt4oLXTglIluh9n4inBeYBMSsUk+79CxFCwJbO4+gg6p90Zqxj4E6b+Pe9T3jiz6c57sSS73KbCkE13M6vHvg4hNpOvimMVcGKtcjOTnmtRBA0Ka/unvUArIkIV/pqOLaSzxzluo0GU/QmiZBJ1b53TXFOrj2GCcGNxgiNXXShvOHrB6SGAEQvNpHY606RPfA5MqDeOtqpDB4YQtFwfAs0BgYGmVDC85rgLaEjKt0vNiZTlDh+YqaDreWdmBz6g2a2Lsr+bCQj9eJjPokC1DZsFkR9/un2KUDFwm9x2PmmCLQCURNE7enwjVXpG/tj8Qps+7MAoL0hgYMlKLd30OYTMhb0aWa+2Euv6b5WUuMDzZceTilRWK+djMkzwbtuEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
> tracks active mappings per cacheline and warns if two different DMA
> mappings share the same cacheline ("cacheline tracking EEXIST,
> overlapping mappings aren't supported").
>
> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
> hub driver) frequently land in the same 64-byte cacheline.  When both
> are DMA-mapped, this triggers a false positive warning.

Is it feasible to suppress the warning if dma_get_cache_alignment() is
smaller than L1_CACHE_BYTES?
 
> This has been reported repeatedly since v5.14 (when the EEXIST check
> was added) across various USB host controllers and devices including
> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
> 
> Raise ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES when CONFIG_DMA_API_DEBUG
> is enabled, ensuring each kmalloc allocation occupies its own cacheline
> and eliminating the false positive.
> 
> Verified with a kernel module reproducer that performs two kmalloc(8)
> allocations back-to-back and DMA-maps both:
> 
>   Before: allocations share a cacheline, EEXIST fires within ~50 pairs
>   After:  64 pairs allocated, all in separate cachelines, no warning
> 
> Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Suggested-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Jeff Kirsher <Jeff.kirsher@gmail.com>
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

-- 
Cheers,
Harry / Hyeonggon

