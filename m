Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B143FCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE916B0088; Wed, 24 Jun 2026 15:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D086B008A; Wed, 24 Jun 2026 15:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E8E6B008C; Wed, 24 Jun 2026 15:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5DD6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:10:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 872E5A0401
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:10:47 +0000 (UTC)
X-FDA: 84915748134.05.D9089A5
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id A6C792000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:10:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gCDig9RV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782328245;
	b=5UcV0D2b2+Lhbyr/rSs2RkO+4PdwcWyNNwvaiPyxzFE53HWtGOzE8pIOD04iIu0JlPLdQi
	GtENyDDtNNGHt8PfX1sXNaN3qa6/nVKu+PAVoriuhqujU2hnkKx0sUiSS/GUTAEr87l7NH
	XvhztO0BsFoiHMPUiE4PEJrSoWWPkNM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782328245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeRIelXWCkeQ/dWoO1Ec0xhONeA3LFt7A97Ox2lp8yI=;
	b=WJ7afUa17fhbe4kDhPdrPyYbwtWV2tAgHypAnnOz9kvb+dlyxIPD5kxhwJAWpoKv3xGOL8
	4c0NJG2tvCu7iKkIvggfe5Y+7HVastp913dOcu6Iz9M7fnYWCvDyV/C/lzxu9ZPsvCPF1m
	cQx+KI6x8BoNJVssOybnlSPd78qbpH8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gCDig9RV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c73cefe192so8945ad.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782328244; x=1782933044; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zeRIelXWCkeQ/dWoO1Ec0xhONeA3LFt7A97Ox2lp8yI=;
        b=gCDig9RVD7r1Nx/VWvCq3FMjYFcOzKQ4eqolLPmRsmCsZQCjLdj32+PWKrcrrcDEJ/
         TdQjKyWDB/+lxZ9uYLtdgkyq5+lNOiogU9KE7xPAMhxC0WMMklvnzYN+IgMDA2pXX83s
         rZzk5kiNsyi2K+bmhmOPNpGD7Ww/2JqUTxjaOvpnjGETfCxJ5IyB9ZKyLNYs0f3T77t7
         DA+dOdPkB6QjcBpkLDNX4l4nS6PYZ78IER/ojELcenqukLb5iOahq9g5fYKRRx1ObnIS
         bxCivuzD3+10OTxerONDoeB+o2C/uY9jMnxfI9ROPueXPU6sr242LFD53LIpK7l0EGoe
         Ai0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782328244; x=1782933044;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zeRIelXWCkeQ/dWoO1Ec0xhONeA3LFt7A97Ox2lp8yI=;
        b=hSoXHejgzeN4etaPc9hZvBnaxPVm8Q2fcbGWKONtTbPsSVCkdQ+2+KzZmRYKZUQUhl
         0Zclhn9qLbgDk3Q99rSkmUmLUZTZQ+DYLk3khLQ+XF5EhKm0yeTkMD1sSK51FwN6QMhQ
         e+/H8C0x6oZBrwFLoR9PVFE5bn2/ZjXRyWCv4pRqnAAO7Si6FE9/M9oIdyOZKP3UIKKM
         ltiEUmylp5XZloUfGmMYFFW0cU+ViQZDfppVCarRUhu4wooUNVmeN8lm6jOvs/vZzH3a
         FPJDIFgCWpe/Is1/M7BN/s2CUZGYHQ49TgkAhj7cmBFtxJGjO/98aqqK3M6b1bgkNGi0
         a7KQ==
X-Forwarded-Encrypted: i=1; AHgh+RpC5N2oH+1aYV8zuFQz/ox2tOEERvn12uhtenneWGJ5+SXmWFPk5SpvlnEtgsztv3n7vPj0kVNcxg==@kvack.org
X-Gm-Message-State: AOJu0Ywcs8e2xQihUqolgONmT6ZjPrOTKi7kmIWtrAEZNq4n/GfeLh+W
	xd3Zvj7u7RE3DcLc0BfJLRhBM1859taGCAHNB2J+vjX8+hV0kd9zTAoo6X+Kthpuag==
X-Gm-Gg: AfdE7cn466ub0eHiypRq77giE8DY0Wxy3OnPuaqZU7AwKuYyuJVtyAOkgXefJyPvYRj
	A9dLWAGmc6KnhaajV3HP59Oxe0DGLrJjCS9vy15UzyuY9/j4hYwAUyxs4y/KPEQe1JWfV2zbcbp
	3BM6ThbzuDMnGJG2MzRM1Agewl68jokQYndiuLsT1FGPqH/EfIxhE9PdamDnL0qghI1J0rIq8Nv
	H3bhCh0e5+0ouwWGTwY4AMFzjEPaIwZGWEwEI9AhnH7fndz2WesuxwiU1soNYbvtbY+jVjKg4l/
	wMD1xEw9LAY18oyMb6do8nmNVT4PIq6rceoe54+ERFJWUOCfmeqft3KNEqu4P+Ov/z1WoA3U1xb
	zIEjTx0xHh3w1weCs7DaU2DI9Uyp6k4PPHQsl6HUHnvkj8ZMVPeetY+cqt2fMqiEKoRBIdSjNKq
	jAvufZrPVHQkV9x6YUyWBFaIxp2JbV3Yn4Ld7W1dqolsW4cCvrh/gkX/tGR9+flgUgr/miEqEsK
	r6Q7eaS
X-Received: by 2002:a17:902:d50c:b0:2c1:ee6e:be1c with SMTP id d9443c01a7336-2c7f78d26e7mr319365ad.26.1782328243785;
        Wed, 24 Jun 2026 12:10:43 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40ee417sm2715140b3a.40.2026.06.24.12.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 12:10:43 -0700 (PDT)
Date: Wed, 24 Jun 2026 19:10:39 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 2/4] dma/pool: Add an API to check if DMA allocation
 is from pool
Message-ID: <ajwpcdIXEeFj-uUr@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-3-skhawaja@google.com>
 <aicFes0uxUFQAduC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aicFes0uxUFQAduC@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6C792000A
X-Rspam-User: 
X-Stat-Signature: xrnw1k4xki19ikdkpz7ngamccz34i4pw
X-HE-Tag: 1782328245-829440
X-HE-Meta: U2FsdGVkX1/4x9NL8mz/mpuXKfGS0ubCruiveXVQ7cy8kWHezYlZfwn6JeTyiXQhd9zgk1T9MMICAX1r+kEScAFGjXEH2KGmperzICfx/j+Yy/gr96vcnx1S3lNMfSNwRDtbn/7oDJA0P573KrCbGE1uOxZyVu5lvbQ+rzzPTQGaahxj0a8/jXI1Ze9k61E/sqPHGaFQlxacqqxax8zuvUE69VVWIfFaxJ5nEWnOQTxWFW9tpFxlGROtoM/1OTvTfBVbeBmMJeGnxFaQZ3Qk2sf8+xELNGKLXl3bFlgG443fNo38ywk39t3TrJiN3UwR/g+LGZGW25Ew87aajWl0yphXX0t41+C637SccLKK3yzK9Z2a40rP9JiC51dQTnwqoTj8vBpUyKCiaPb3lirkVPR1p3INwQ0k2w0Q9h/jjB+KVoDtzBSazpFCJrfYs+68R4q8Ifqw0X6yl2ysHORANPiQSDjvYw3rF9rU1Ta5a0ZHBeMwCIX8fduD1+vqUJiYGyBp9eC3YcB8fSfSd+q1YLzwd8zOuVIFRZldjmU4R3vANceGTHH7GZ4uEtK3dXZPrlnRhb0uFZTl71AQ1O+XMrX4VSDm7VEjKv39H+HSti3ijxcQzb1ZWmgYvVEtiHLB+0etukkHCZt/tK4R4Lt8qZ6uAgc0x06iKfdt3RJanKlcyATcnhjtk+pAhW7AXw5op/vPcFtBxOy6u8RZaEmeWYS99hVN141xv1dbeFXSwOmB30z/yvFZgiDqJhigQdPUwq4nf4ThLjUjAYFcNib40rNqR9mSGTcJKZXfISbORMrZZSjGBEDDGIhwaMaUukUlMdJTCBJfwHhRpS2X1nKwSjR+QxASEuGoWNl1qWNCneCJu9/2hpvY8LCVBQuUdtPxtF8JHgjUVVVGPMPfz1pPa7aDdp8m/TFbiLePxJAhghBW0ajZ5KTpCrInJl93udXMMozcvy7B88uHrkfZ1fF
 PogZqrPT
 LUeZT14Y2VpgB/VUByiTmm2l0/AL+/r1Y24WFYIiUAc/AVIu90MLqJLpkORFueOECW4INO6pnPD/aXUJX+cSYnGk6eybzn2xPT2GjcQlq/pwQvJUqbR8fLVOCsHA47BwwQhyn2gZwjfAAc+nW+xmwWBuuHKuqV90m2VNd2Jf1OCl0o5fpvl2XSKRztO2H7D1WOfVf3T1nPiBr+DouvG1AFZebw4ofy+8GLqg6mcwioIhFN5kBfknPlzewVfL0dOf20xF8D9AGpunjqMT+g7MJM6iYCDaNbQOttCkdNGI950TNJbpjkMLcIJ1xvu/aESORTsDzwEICIxFMszFvoVYwE29TBqMds3sR5o7xeHTgYCYSk7564smIn1fA078pIjORYrjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 06:10:02PM +0000, Pranjal Shrivastava wrote:
>On Tue, May 05, 2026 at 12:27:35AM +0000, Samiullah Khawaja wrote:
>> DMA allocations can be done through DMA pools, add an API that can be
>> used to check if an allocation is done from a pool. This will be used in
>> the later commit during preservation of DMA allocation.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  include/linux/dma-map-ops.h |  1 +
>>  kernel/dma/pool.c           | 13 +++++++++++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
>> index 6a1832a73cad..6a0bc4ea2467 100644
>> --- a/include/linux/dma-map-ops.h
>> +++ b/include/linux/dma-map-ops.h
>> @@ -216,6 +216,7 @@ struct page *dma_alloc_from_pool(struct device *dev, size_t size,
>>  		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t));
>>  bool dma_free_from_pool(struct device *dev, void *start, size_t size);
>>
>> +bool dma_is_from_pool(struct device *dev, void *start, size_t size);
>>  int dma_direct_set_offset(struct device *dev, phys_addr_t cpu_start,
>>  		dma_addr_t dma_start, u64 size);
>>
>> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
>> index 2b2fbb709242..32ce4d6d7683 100644
>> --- a/kernel/dma/pool.c
>> +++ b/kernel/dma/pool.c
>> @@ -307,3 +307,16 @@ bool dma_free_from_pool(struct device *dev, void *start, size_t size)
>>
>>  	return false;
>>  }
>> +
>> +bool dma_is_from_pool(struct device *dev, void *start, size_t size)
>
>Do we need struct device here? It seems unused?
>
>Nit: we only ever pass 0 gfp_flags to dma_guess_pool, should we instead
>name it: dma_is_from_atomic_pool() to be more accurate?

dma_guess_pool() goes through all of them when passing 0, look at the
prev logic inside it and how it is used by the dma_free_from_pool(). But
you are right they are all atomic, but semantically we want to check
whether it is part of any pool so lets keep it as is. WDYT?
>
>> +{
>> +	struct gen_pool *pool = NULL;
>> +
>> +	while ((pool = dma_guess_pool(pool, 0))) {
>> +		if (!gen_pool_has_addr(pool, (unsigned long)start, size))
>> +			continue;
>> +		return true;
>> +	}
>
>Nit: The loop looks slightly ugly, can we have:
>
>struct gen_pool *pool;
>
>for (pool = dma_guess_pool(NULL, 0); pool != NULL; pool = dma_guess_pool(pool, 0)) {
>	if (gen_pool_has_addr(pool, (unsigned long)start, size))
>		return true;
>}

It is a basically a copy dma_free_from_pool() without the free part, so
keeping the style consistent.
>
>> +
>> +	return false;
>> +}
>> --
>> 2.54.0.545.g6539524ca2-goog
>>
>
>Thanks,
>Praan

Thanks,
Sami

