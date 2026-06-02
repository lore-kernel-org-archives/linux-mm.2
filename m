Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52AE5CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85986B0088; Tue,  2 Jun 2026 11:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34C46B008C; Tue,  2 Jun 2026 11:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4AE66B0092; Tue,  2 Jun 2026 11:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95B9E6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:58:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 460FF1A094F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:58:11 +0000 (UTC)
X-FDA: 84835429182.08.FDDD917
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 55C8D4000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:58:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fvKvJXdp;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780415889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rx+0pE4L3Y8nALJvhY8y9z/1V3Frljdp5XhJ/FJ5LMk=;
	b=XpN0IA6/rVfDtL+oJZbwKGvRHtaNva7bWvt/om7MZs5AyPPNQNK8ECCXRt+PiBAmz0qCBF
	Qp2irR8/0X5VAyp1iWDI29c0CNAlGWbXyZ1f0RrnBigUmrLqc8rRDNE0bAuiik+1u965jM
	0+UUDNBVFixzGt5oFMgryjG1L/kQJ/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780415889;
	b=xSyM6sJVDJyN+Mn//WRJfkRk15inY15Ul0bspOR3LMMAQRiga4jsJMyuH435J+o3bMyn9n
	N/1/2jXAfjb6Doxk19VWqktyYIOcnFoeiTZFJ4a/BKQ7ug0GPm/VDUu2SnrPwYsKfKTW3t
	q95C8Tv67cqynCAhTWn8J66VfzdhtUM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fvKvJXdp;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rx+0pE4L3Y8nALJvhY8y9z/1V3Frljdp5XhJ/FJ5LMk=; b=fvKvJXdp5ZKXNTcHlJD+b/mN5+
	/VukpZDAGqEmxhOYCWsu9X3IR4/SiAXCO0U/fXNRA8mimHrGkxEwvUvKruPPVvVGtP0F2KWeZHkkN
	Tt2L/cYxzF3toCUrpvHgNRtqGPoZg8o2CkVj44ZJcSYN9nGadiJVsFu68R7qIoHznr5Wp18V71JjE
	m5SVebyLMuifZCJwQS+rDhpBa0MxB67yxgJwQoOEkKqqvq+AEw/BYqHDGILpP0GMoC8azOeIFB2gX
	IjI4Y2YHLz3qMlcSdQ33u8nGbImpQEveVMwNtRI5xaCPAY/0IxGcDVI2wQgyySfOtIbECItfKr+Ej
	uV4mo4lg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wURUp-00000002Dze-0XIU;
	Tue, 02 Jun 2026 15:57:39 +0000
Date: Tue, 2 Jun 2026 16:57:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>, Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <ah79c9IIuXt51ybs@casper.infradead.org>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55C8D4000D
X-Stat-Signature: dq68mxsxmr4j8zhcp1mt6fuigqw36zqq
X-HE-Tag: 1780415888-351150
X-HE-Meta: U2FsdGVkX1+iwWKUjhwecvUYOo3gcTqwBa71W37LISRaIj9Ijk4yFkGyDfltaZ9LtpUOIEwJ1Dv5pU2wxk2Xc59ASNQqD33rWOrTfaBjZo7ZKlxC66AMonSeLMXfVUKWVW7DWRNLlm7xGvD3DIydTBsUlo4dhHqyFx+7xNUHiWhuGEVkmJMvbH+s1pA8GjyYPcH5RaqWUUED18H2iSjkW7iOJpua+6VlOglFrxtIvahyHFEiMaXlOM7b3eiJJGDmVrW5xf3qEL/LQdo/2b2XPTx7fF9QdAO+JXJ1C5G+F7g3GDko6x8YtFLermOPyJFFviKZekOJa5A9pHwNZ77hoPvEeWuTRnS3x4xzYlfsn/IQaZ0LnnSkAF5Bh88CI+z0uAYaWvRd8V3Tb5pa7GP77DH8RgKH+zM/RLwGb+JQZ+0rJ6gDro97eNSw+hKNzTEjzu6FKxT8PMsYd4hVqjEOUVmz9YMfobcOAzHf35UVB9qSsvf0vlPsAkkkRPaZ4uhtqBPDvtFtamDF+AdF7rBz6qG84SDRJTktbSlCIteJDuC8UBF9z/GjUEwhpexFnzhfXQZycbMGNKqgq4Tifm+j8C2JhcfYPkE4aLXZ2TEfFhowKbUeFjvnp8jix7lNtADoav4ZmFvxpDtl0xXX6ykFPECqgxPnKvmFVHVsb/5r4aP5wbBRaNt/7SwyrQJxUeGhIvn7I5DJPgRw1FdzVBZ8mA/+FhT4M+rdUenioMjnE2C1RCD+XYxWm8E/l89Kmq1kdN5oFznsXQXR94/uxarioJt3Cv5pJdhoybhkMC0rG4sQmvUYSMVM2V5Nv+st1sT+5XDaSraH/8hZgfrwoiXd870Nvo6g/mnUQsjIV1OynDNBqrG9J+kkYXLJW/DfZxP/l8u1bmHnPeLl+ACG+lM5PTNrFK/QjS5BVNdN23h+zsHdmAZepf7yKXAntRJn6lS81X84BWkwX2gVepBDMeT
 UmVVhKlX
 meiYDM+8BRK9+ZXi1Nz7K/xl9hlkfykAx1Pem5QzzyzcbzeE2mNFgmu/xXfoPC9O7U8qe7Q2nE+lXwr4Ev7TmQdBAPKIbGhKMeGgLanKTo9rOpJGZNGiEG9XS64QM1/tn4+NpiuqBkDXj6ivWbzroKWRurVrtLErG887FkI20ciS0PKp2VRY+VSsKPEGcGGFae3zEfDxYeLjWB6mHJiSyRqQVmYW/BI4pf8zk1VSrBIRC0KXojOOzLu75LlOdhGZCHZMV6b5pDDJSk0F+qXyb7y3YWac37klzoUo70tP2t1MhA44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.
> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.

At the same time, we have Tal trying to split folio_wait.c out
of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu/

I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't simply
have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1100
lines, so that's about 1800 llines which seems like a good size.
There's some functions from mm/util.c that would fit nicely too --
folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()

Other people have thoughts?

