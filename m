Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4322ACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EE66B00EA; Wed, 27 May 2026 10:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1D86B00EC; Wed, 27 May 2026 10:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6D86B00ED; Wed, 27 May 2026 10:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3036B00EA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:07:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D5351C1D09
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:32 +0000 (UTC)
X-FDA: 84813377544.21.996120E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf23.hostedemail.com (Postfix) with ESMTP id 82354140015
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890850; a=rsa-sha256;
	cv=none;
	b=PQlXa5R+Va5miK5VK4Zlo4pIZHhWbDYDjzPSK8XgXD+3nURcu7PFqGgoxTq6K9gk9NZC4t
	L7nBNvWNlGIQauL1LrsooPQL34+xZcSSZQYFLRKZdBku2JoDtObIkhgXNmql0opMfrXL1y
	5mhQJHX4LD0GMM+kCk0rjzEpa6fTknM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9P3bt+99QyzFOs5QNosrvIZUpWtVthkYki4xICn/P0s=;
	b=VrYj72P5ruuuGFhCvqvtw6hHmW2nKBS2MT09FZa3FS2OPrsplcshI7WAK0E/PrD5nycA8i
	cVsBlxWHKDVcGtlGJ+UWzjiBodOgZjO4Nz5wGkmbjTgB5AywOpWulF+vJcC8iTcPSof/F1
	L4T2hGfPfKB7uXrHenituLzSftgLi/w=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8156068C4E; Wed, 27 May 2026 16:07:24 +0200 (CEST)
Date: Wed, 27 May 2026 16:07:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org, Matt Fleming <mfleming@cloudflare.com>,
	kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <20260527140724.GA13256@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <20260527070239.2252948-2-hch@lst.de> <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org> <777c7229-4285-4c7c-9340-dfaebd2ab291@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <777c7229-4285-4c7c-9340-dfaebd2ab291@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 82354140015
X-Rspamd-Server: rspam03
X-Stat-Signature: 4dcjdeq44aoi7iakq3hi5ce36uq9afxr
X-HE-Tag: 1779890850-674930
X-HE-Meta: U2FsdGVkX18MkVpiDx7ie6MBAHW+1ePh08j6zmc3bnHCeYboQrCLP5MhGxB1i9DN7YrBlQWa+Q/CF4yd9Ez3CZWf34tFS50ikxDaDrTMtUzRvj58kisTq6xA3QBqM5fsQ8P31T9im6cvly2tJqsonfzq5a/2Sg3FS0V/yaDt5gsDydgOu3cP9hsFkJkckUILZjJp2bts7ES1jsGxa9RCQT5e5JZ674ewhHIyPD6EAi/oJmTmkWaVX0QBeJeZhXnulEH9vRQL0boRfPlI5Qur2S1MpsSO8HLjWzeVxVXlbOA+RjJUhfVLcRK5tnDXp43weMiQFd6/sXrerq2UWtU5uWTuDAE7BQDZefB+bDQRUfuyue1PCtyAt7JF3fc+RRlO7AocuOWgRupoFgaEfSCiQ9vKJbVpvjNSnL1PUfKoc6BHwvC0QZzuZLLmunZThZKXvE5R5c1p8048MG2LELqwCuTyyq6Uy5Qo1/YxbNmsYgdpY0ug7tmzMG1Xw9Yxk7AtK55599XXPUjPOzgmifycdEDc78CenWxK4gQuS704aUOv2otOvs9wkCsqaOPB6m4jSnRdAQQLsdmCF+5Ew0Eg/+ACY5SOpnSNZ0O5rCmoyVf8VPdjGfJC9gv7/jUVmUKDrmGFb4DGVASBDBNsR3ykjC+zN1rfE4aZdwFzNUoIlrVKf2GGMh8ZZOM4gK1gp0T6ZvXaH9Qzd9VMj1NN2DXqEm3sgYLpthau4U134FMK4SU4d/THb5/qTGOAnBT2MGE4SXL20xBJ+4AyVqwVJrL0gyeP+nqaWI3teo1GbjqV+Ln6vc2ofCk0wZz5NsXOg8Pzy5rc059dM9bxH6OWm2v1W0YFWiQa2VIKrVJln5lqnrwWqt5/dZtJGjR0ZQGjcMoH/xDxNaSVHoawJLIGqCJdOMZpAVXLs9q0TKBRIxFzsCzj1qXqKrh+iIQd8qlpz/QlhAoqMHBeWRzBVKKfioj
 29SVcTjV
 S/T4RlSIVOfO/hDX5tOpg4/6qobMDhOmKAFyXvGQlBWRIGDiajhdgpRfh58IXC8cLAGbWXHwsCVU6fMAnm5Ny0WEAXIqpUjz2qjXUEg+mmKzk3PBv30yOqSc2/vzEbaBbLCMKFoMHdL56psUahLhIPU60JUz2oFz2Zjc0lQgq8B1VVoBvnb3U53ZLU6euBf4QH1wPykorWgMx848=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 03:56:38PM +0200, Alexander Lobakin wrote:
> >> -    n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> >> -                   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> >> -                   n - nc->skb_count, &skbs[nc->skb_count]);
> >> +    if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> >> +                  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> >> +                  n - nc->skb_count, &skbs[nc->skb_count]))
> >> +        n = nc->skb_count;
> 
> kmem_cache_alloc_bulk() allocates `n - nc->skb_count`, but here you
> assign `nc->skb_count` to n.
> Ah wait,
> 
> n -= n - nc->skb_count
> n = n - (n - nc->skb_count)
> n = n - n + nc->skb_count
> n = nc->skb_count
> 
> Correct :D

Exactly the steps I went through when writing this patch :)


