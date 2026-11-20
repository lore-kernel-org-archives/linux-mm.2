Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B2C606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPYT8FF7
Received: by kanga.kvack.org (Postfix)
	id 805BC6B05B2; Fri, 20 Nov 2026 09:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F876B05B8; Fri, 20 Nov 2026 09:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656D36B05B9; Fri, 20 Nov 2026 09:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4143D6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:18:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDB2640F39
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:18:27 +0000 (UTC)
X-FDA: 85455702654.13.2403442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2488012000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:18:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPYT8FF7;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795184306;
	b=kzQr57sHniHuwFWLLkLAlKSiCjFg6jDlyOt9y25tZGjA2XytATdTqd9k4bIWhkaXDyN3zy
	kjATI79HmK6gub7nB9OxetjMmarDqTnNBulYcsdtiHWjS7wn/IoM8jamBt6ewAi5EOFjjq
	NVi+W0fjHqSnfmqW6jOwTs9lgGFAmdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795184306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+kufEY/E+bsc6xg+Ks+M0qb/1tUkGUpCidjOKTYsjs=;
	b=rBDMGntfgv7JbxSPWfXZax14ekvE/0jo2r5qpKe2Z45Tg3IVGr42FsuphUOb8K2b6m731m
	uJe3pRk1O+zGrcwb+p/F/43TsHshZikbqwSphKDY1M7+ztxHrUpq6AVZqQK93m9Ct3rj0j
	U0paykCQ4pX2tmHugj5eB9TygZdM6jI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPYT8FF7;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51FBF443AB;
	Fri, 20 Nov 2026 14:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB5B1F000C4;
	Fri, 20 Nov 2026 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184305;
	bh=R+kufEY/E+bsc6xg+Ks+M0qb/1tUkGUpCidjOKTYsjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hPYT8FF7iduFPkJ4iHmWTYzFOXIDVjVzsgEu+b+PIaVxd9rAbDZrkqDn0kvaYa7CN
	 TS3W+Fq7q1SDsZlwymg/X71NkiB0i0GAuYomWvK9HHLnEpKBVxyYJkjNCh2By1iSbO
	 0BtO1ijL7q3ouf7vvLuY9IcTbRVjJ4u6ueLEGNarQU/g+mvyQVKhaMHy/0Ep44opf7
	 JXOGp5ka1d+UYKQqTGGI/z4Y/OX3i2Wm5IDwZgMeNY/u5r8cW98mbVVeu3i49CXM7a
	 /DdbQ8Ua13zkOR4LPXDQFcKeYYXccQJ+ogXOG8CW1kI3GdMEK7Oxd5II8oOmlPAuVQ
	 RcfxGTUxzc2qg==
Date: Fri, 20 Nov 2026 14:18:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Luigi Rizzo <lrizzo@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awBVBqaPDmKXXHom@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120135013.GO3115493@ziepe.ca>
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2488012000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: sjnfsr5xz3cuijq349m584xh1xr1nue7
X-HE-Tag: 1795184306-967615
X-HE-Meta: U2FsdGVkX1/CE5SKQPzqMSgNcfbID1E7swiLDsSw3ZrmeARevLNGE0qv8mK0T8xWHlf72nbMayY/tanFGjc7ss1bvOF4i9bIT6+KVBPFi9yONwBlEGNwIs8dgsnY9I7ywV0vxB4GGvUMxeWAa8S0WD4ZefyNkv3TYCr8/8FL+aVAxBhsvjUJKaBzThLow5qBLjyjDiXX8wPTCQfLBWml7nRcezbc+BIJJsTO7CF9Ww9KmxCkHVXxvTJmkFvN/YdvYInWMT+7O0Ono17SvT0WX+Zw0MsF5mO4ZhSBOYyqKT5kXz6yDEFWgXUJP90FcQ5GF/HqNvUvwEzkIgiSKmuTlCFZLoguQ/cUImogVCzJNfQc426LAKfe7a759JqVy6tuO2sR8twLsXCMRbbV5di5AB46W+DvwsiVbVuJXv1ZZiN8Egw/0xXGtc1m1lN7NFug7PO4tvQ8ctmUWzbcVafQ0xesGecu1g6nNbEh2VJLfEENnXH21zUgZb3PPfytBKXC9YVf5/r8NJvdBisd6gl/9bUd4hlrLsAeTIevcctaXvyd8eBPUz/Bsa5tw2QN0oGHMldOyTI/DPmNIq11Av/Dk7/8JGABz28fvM2I0HuC43lzsL0wXn5JGxsCXZjitmEuZ74NBr2i47CO6q4VYcG/sRT5hfyS8XDIx+xlvg+tvoXulF5LD1EhbHXPysPyJ6GWUAjoLCUAachI2IoDN8f34AlQP1gvTlxpQfVRVD3mkaD/vUG+fi0mSkjyBiZMCwlD0JbReDejfjFKolFU0qYZZllf3jJpa0qSUXrFqS8maHjwRFMYfyIjCjs2GdOcOxNNt7dKcJEGvAm2kOap8M5ltK/pPByxVei9QHQ1y/Ng2r5D6u2Mg4EAn8zi0CFYOlHI2ZdoL3qwRZd8Sq2JVhlJivDJz5ZuUKMIigtEf24smGn6S/1gt2kTLSdCtNe32YfQalfSUqSBewxyL4jZrl5
 oYLm3dnO
 /TWhAZceRENbn/Zp/c0fBCZkaQA5nSUqcHXu2KWqHLbkaFnjgOcy7IhFnicqM+3ZGpSgB6Amd9+3p67d6wTlYJSL6TkVrFT6gv3QfQkP0tvdLajE44GJX7QAStuveUlvlnzMU/7ZBMZ2N4swMEWK+fPjpeip7SJ9vM74NUBbupjnEkz4C7suX6BSIVTL0LtmhFeo1iJYuwygqjVbFur32cQG9MKeTt+CuZBvYdkuN1maq5xuQxvrb4Y7I6Bp2icNeL6ho+7VxmDaDTUnzBImHXGhTRqWVltQHuwVyJQKtG5pNCxrH8Z9co5y270yF+wqTMl4/5605mK+iCp/O7K6cPifeWwI63DLIG55Qap33pvr3Zl1x/ophGI+WdWDrf6VpiA6cF0feKLaaIl8R4JneiEu0xj70gqCE4S2jQ7FoxVopMPLpEieMe8q3c38QN82Qw3yOtDCvI4h00lsWucVnsh1pZQtJIzAJ5lV24C8FWgiq4Ssiw1JJZYlJ6wfbLdTXQyoEqd20ha4r3KNsaAcVVvSXVimx5QhvyTd4CgPM++rlqAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 09:50:13AM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
>
> I thought the conclusion was to just do this stuff in netdev pagepool,
> now you come with an enormous AI series spread across the entire
> kernel?

Welcome to 2026 :) It's so exhausting.

>
> > - Needs bounce buffers: in Confidential Computing VMs, PISA allocators
> >   pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.
>
> It seems this was ignored too. We want the bounce buffers in CC. They
> serve a security purpose. You cannot loose control of the shared
> memory buffers have have them leak into SKBs, user mappings and so
> on. It is not secure.
>
> I don't see how any of this is valuable or necessary for CC,
> especially when we really don't even expect to have an vIOMMU for CC
> very often..
>
> Jason

Agreed, this whole thing needs to be rethought.

Will reply separately to the cover I think :)

--
Cheers, Lorenzo

