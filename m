Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EECD2ECEF
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 01:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E866B0337; Mon, 19 Jan 2026 20:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935E76B0338; Mon, 19 Jan 2026 20:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863076B0339; Mon, 19 Jan 2026 20:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 726436B0337
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:05:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1ED95140383
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:05:10 +0000 (UTC)
X-FDA: 84350548380.13.14458CE
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3399740003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:05:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IgvM1HwB;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768871108; a=rsa-sha256;
	cv=none;
	b=pCefVBZ4IHo6wbNrcNpP+oMImgiOuo/QFpz37Z1tv4OXABZehPZWBSbzFudPR3fdkCivzj
	UbxCXbTfoTFsfojnEZm0NBbMCJxZnlMBLllwe5kBhbme+xafMi0+kf+9OAQUXMDCu4eOYR
	Z3V8TTrRX5AmK2OzGfUZcmmNcZJJNvo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IgvM1HwB;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768871108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BSJ4ovorQomCz+1Da1Tddw6wlufJXzsgj4XlYQhj7Y=;
	b=IDJrZ06dn/Z8KCIfHgNCc7eDySGNZRWuOGd4/VIYT5aZs64r+IwuuWJLWHUBZNy9kIxFkQ
	1h0UjEyylKEl7tCiIMGdwDUsvHj+F8ldmGKyzR+ymAIhPLi61LXiSlgVxweWpJWPHsCixj
	PdRI+NeiHegdHclPjYbjesL3PUJLpew=
Date: Tue, 20 Jan 2026 09:04:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768871104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9BSJ4ovorQomCz+1Da1Tddw6wlufJXzsgj4XlYQhj7Y=;
	b=IgvM1HwBVnm1nH4XctY9W8aWko7pH1DWJDqLyckIB+pfAhPFdJqft+J/D6OvrqCDU789eX
	5LzUDvtEcx6WcECU9yu7XA3JpX1HYW1cR0wHeGIDzJzqi1xYQUtizIGfwSECxxZns6EzBB
	zteRdfKd97NcTmn/QySH9L6M0J6qhXw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 08/21] slab: handle kmalloc sheaves bootstrap
Message-ID: <knn6gyidf6675wzt63hjsoxixqp5x65x3nwqsoi5gizqa76bog@kcvsazfh2lgu>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-8-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-8-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fb1wzob4kyxb897zo51e3aba7hj1fxpb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3399740003
X-Rspam-User: 
X-HE-Tag: 1768871107-248637
X-HE-Meta: U2FsdGVkX1+rHDDDDu/NKIe05OiBb56omcZpKhWY9mZoMNhI2YzxjFLWb2QCSnHa1XHp3dhn/HwM2iqVF4kNUQX5G+CaZ22oOSKAFSkwVuwL9hoOj5j2eiVg6wD/UD+uTqvHd1oBBgwJN1QHSlsoZVnGaZrZ/L0/JW/HSbF9qwpfFIygtzbZqL8GN22RrPsoUdL/x9Iy7FnDPFHNzZ5SPx/GTfSGB3kz1i+CvD3+sdvYEDECNh9tOSkXI8rBkrZbrgdR3A24V2ukWrvvgE+VVxy4ZX38rSi94FtSyWg1z58/hVdq+5zs+CZAXDeA9s+KPHztFKl1XCPfyNK0Ur5UTql90NxrcOQArgnVwRCwYzMwpa+d0LRcTvcAZyegYVzFO2DL27XMT9PxyxvQ/vWtPTWcSD2WfIWlgrQDDHYLVp0T34ylo+Q6yzdAzSIeEPD9FhT0EF6oFLn25FZ6Hi4OOCicp9mab6Ht1KYPs4NEuvXODvn3ycGh05Y5u1n+mxv7o2KUpSPcEBccDw34lOFj5fkU7KDknnnj+lR847A56XiX/+Xv2saHSAw8EJLDkSkRyUtMpYCIx7eqqJTjSLttpili2dHWh8+6o6Jkat34LENq6U93fdnQTdBvlT9ePsPG2g9p4uyJbIJ6fl2PeCycNdMFgDRLexOu8TnGmJeLnYDOK5+r4VFeloFDmSuE3blkee7sTyrH9Wk8rPoWFyitM9zoJeUSyFlYbbqVtP/kIZuruUax3fQry1QzxrJ8sOPZBssx5vqzMUVfZ+aKS3Nx8JW9FRtHWea7F8WoAOjcIubYk82dMA4G+fNkjDH89yiGQuGxupUZbpKiUBbi3bUNzExBQw7us76XvfHS70APOJZ6wV3lCOs3n3fZcS/r8CLcBypBx5/qFcRa63FRomESpQBsqhAvnLq1uyWjB8AVtPQ+zauTnWLoTMLVYQV8syloqOsn/3gaExKkDsaVuVB
 I0tZC1kH
 JNELPRvt0Lb8jW7lFqu1/GgfyhrTD8GNWzBtEoLydd28mWgIczAoVfLGtMqS0OU5lp3BLRt7UJr+8vt7xM6+YlIvMvWComrEe6o1ciMGJj/enwTQwblqnKJJy6Pg4iO0mXdu6GYo9oyj8sZ7+Oq8iwXRn+r0bw866qEZA81EPhSyGpLRSzK9o+6Y/x1JYMyIPjha+73CWtan1swSDYPpIs0x6XW8jt/QJ+d1g89fHF4Ymyeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:28PM +0100, Vlastimil Babka wrote:
> Enable sheaves for kmalloc caches. For other types than KMALLOC_NORMAL,
> we can simply allow them in calculate_sizes() as they are created later
> than KMALLOC_NORMAL caches and can allocate sheaves and barns from
> those.
> 
> For KMALLOC_NORMAL caches we perform additional step after first
> creating them without sheaves. Then bootstrap_cache_sheaves() simply
> allocates and initializes barns and sheaves and finally sets
> s->sheaf_capacity to make them actually used.
> 
> Afterwards the only caches left without sheaves (unless SLUB_TINY or
> debugging is enabled) are kmem_cache and kmem_cache_node. These are only
> used when creating or destroying other kmem_caches. Thus they are not
> performance critical and we can simply leave it that way.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 84 insertions(+), 4 deletions(-)
> 

Looks good to me. Thanks.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

