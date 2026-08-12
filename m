Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48389C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116516B0157; Wed, 12 Aug 2026 09:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDCF6B015B; Wed, 12 Aug 2026 09:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AA16B015D; Wed, 12 Aug 2026 09:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D76376B0157
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:36:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C05B160373
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:26 +0000 (UTC)
X-FDA: 85092716772.05.0CE26FB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD460140003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gg2fF8Zo;
	spf=none (imf09.hostedemail.com: domain of BATV+a752a25d958bd821a097+8389+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a752a25d958bd821a097+8389+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnJETK1+o9oP+uK3aPBFgY1q4H/u1vtWfML0eAyTy4s=;
	b=vMixFvZ1bkX7O1OHwIJbTQ/1nS2zB7gIsgzVOPH1csP5yt3Wy20Aweu+5TSRng/wbLSUPV
	UU3T2dLOh9FeKUVC79PZxE7hVP7QWW4cDS7DC41gNZs4zt6UbkncURQFnvb8oSHYWfNimW
	4Epes7SoB3bBmf5NjrBQP4tz0E+DGqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541784;
	b=ZNOpUd2Nkied81ukpUsT3CBuVUigm/joCfk2DVWA3ZzXkJkLFp54F45JybC5jUvKLJZWsZ
	7plK50JypW01zbW0zRfI0m9G5suMWnj+at+PBXrUfat/AQs8TGrYUYjo8SM8imPFOSDCmf
	Y0PdP9OTm4QIO5ls6OO/sCpRPkjMXjw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gg2fF8Zo;
	spf=none (imf09.hostedemail.com: domain of BATV+a752a25d958bd821a097+8389+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a752a25d958bd821a097+8389+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YnJETK1+o9oP+uK3aPBFgY1q4H/u1vtWfML0eAyTy4s=; b=gg2fF8ZoPDj3hwc3z+I8OA+N+D
	bHqO7CfLgwyPS34s4r6tGLLAH+LSmHxt+LSoJA2WlKdGB2BGYUq81oq6Dt+957rFdQVx3XZRCyDmi
	NRNhL8F7QwKfSSlrmApJpmhIjewcRvjhkrFC+sq1ldbUAXdEVm91z/xWqsY+8nNQQq50y91DiR9MF
	kwgeU2oNfnIRCXeaaJ1gqfX+ngxJlxsMPsIMvmJPo7S9dBShUDAXb3ZbSc+aWuts9+araTqXoJDUi
	j/vqL8br2ywOb80pO7g2pUPe+XHyWkAjMqSXhmas72pDSWyZNFzvLygvdKcJafscXtEMhdRmxKGVL
	UoSlY2OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu97x-0000000GIoc-3Z5t;
	Wed, 12 Aug 2026 13:36:17 +0000
Date: Wed, 12 Aug 2026 06:36:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <anx20bxfhD05jeuM@infradead.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
 <20260810161404.GA1930@sol>
 <anoIiy0V-m-05yZc@infradead.org>
 <20260810182215.GA270444@google.com>
 <anuCcb-Cma6JOAb0@infradead.org>
 <20260811210338.GB1905@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811210338.GB1905@sol>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: yg6ruxdgeeh3jrae1d1j7d5dbduqs11t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD460140003
X-HE-Tag: 1786541783-599263
X-HE-Meta: U2FsdGVkX1/+UiTVgvtVe2v94/Dwx84VjSnD3eaKm0bg6G6tyY97Y7Qzy7HPeO4cAYeeBwu8FRHbHyf0/pvbHtw48kP9bCCm6OLSe1lKdCqw4Lrg4S1kziwUCSBRv+I6I6bqzvtACZqxtZ4Wmu6g9sOybk7Qptk4Gti1NCH7CPCEzpi6+rGGxfmdfKNYOOXFbwLsVUNoAKUeiiEAhL4wLNn7TeFLT+Aa7idZWkkTSDGhWNE9bNUVTEkcafWAyUZbEg6CMQuw4X9otnSwQ4UYnfa/esoUGhCkcNQOVePPaF1j5JK2M41TDGTDh8vBlf+RtngfKzPjEpVohQjU32MhXwR1NuFyhbmHFcXA5sJI/LRgKmjxWT2wY07e00WqE1eawdc8gFT+P2kdYPK8tn5SoXhCOa+GdyKvILpawfCbcCV0IA6sjz9GU7AjTYgkgzEj2JjJnRXFdexcy+8e7yyyijx/HCGUEfbnAUN/RjPyTYI4gLxPC4acDVveJIAI2zy93R0uyvBE7kIMmYXUxLs699KDzQ3tmv5NjyxtzBwuQbPaW3ZwTz2GoC1PgeePJWQ65lTYLJ0EWRRZvJVmDNcF+IcU/p54qqNsIp1zzdiUGIR/eQSoecF0gXOEAQYRhb+O96yedqAg8H3aI/VSbTomHIiVBQLKgWBsk2xYTsFYwFYSbdzNPbfePV+D2X0RZq3K79hkgnuAWWxxJA59KgRBdl9XVJ4+3zcLyJ5TW5woYZ2YnDc5lJ/O0iXd4ts97nL6K2tvqNInyEADnSCJKbGYGTW8+7QNqzzS6n4YfqXwB1qvX+9Shq9M9GpA7s44IZy6+hw2m1YujmlgZKCCbM/Z1ObXYhaQg39NIGPKDM/x3HRlfMiI2RyqZC3+Zd486WYzMvTJeZ7Nt7N45SbYd9GJLo/KRRo84boB+pbdaFQPAjWzL0T97bY3tE2HNF6cm1rgoZijcmT60pjmsv1seA1
 /0D83NoS
 Qwy/T88AWJnFWE04ZnoKmutZkS4pSZ6Lpx51JjkhAHrXJrdVz9bGTLCdRoT/V2VPo6YPwXZ9BfSIGvlkItquBlP+BMD9aUuYCEo+8B5ZiB9o7ak8Iw4CFmxDzyW2zRuE4Fw9ALolNa09ReQrk834ML1h7aM4b1yWgfpl9gOYTHwMFHovFY8hRGzmnI+exH23B+11XQhbiyNSmQrRe4Ni5cF11/Acw1b9a39A5rOM7GmAAtlEWy5hS8Fs+XgBlEVJJjF2nxEZas+qX2jQ6oQD+KDRWl1QL54JviNPB6ialVSaOr9+e4VvdnXicxBbBQS4k4chydYmP6K32BNP8OdvGrM42+CK9Ri3iai8Uw5tgMR0BOCvOoMsos4GxSijDt1fF4znVw17RFl8wEOVXcbp9G1HYqOd1CaoNIp/2MymcG5oxn0d3+N54ZyQelfNo/ttX4zs1QFb9JS7BP1yTX0bVc1qF6DWTjMfS0xTqvWCFbtWo0rxjwmyMLUKYnmQe795ukRSdx1pWLJxiaY4vEOVCj/OUJmgPOhsQhZIAyWFBcA9b1zwNH1bG0vEiNSiBN3ahN6FsA9w8lAZwZgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:03:38PM -0700, Eric Biggers wrote:
> On Tue, Aug 11, 2026 at 01:13:37PM -0700, Christoph Hellwig wrote:
> > What is actually efficient is do skip the mempool entirely from the
> > original submission context and do a non-mempool GFP_NOIO allocation,
> > and only in the extremely unlikely case that this fails fall back to
> > the rescruer thread.
> 
> It definitely is *not* more efficient to fall back to a kworker for a
> small task (removing elements from a mempool that has them available)
> that could just be done synchronously.

That is not the point.  The point is that mempool_alloc_bulk frequently
fails to allocate all pages, and just filling that with a plain
alloc_pages is way faster than calling into the mempool code in any
form.  The case where we actually need the mempool entries is extremely
rare.


