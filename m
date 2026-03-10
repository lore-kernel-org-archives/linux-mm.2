Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EA0FD2D73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED4F6B0088; Tue, 10 Mar 2026 09:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5046B008A; Tue, 10 Mar 2026 09:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD16C6B0098; Tue, 10 Mar 2026 09:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8086B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:00:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DA28138DBE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:00:10 +0000 (UTC)
X-FDA: 84530161380.12.8D52BF8
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46BD1140006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:00:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CU4iyxRk;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773147608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RftT2Y3IHSXVZYJ/UW0Tv3eAsLcm29Tj9tutyIZqu1o=;
	b=qNReTS2BeFLL9B7ogMHGW/qBHJyv5mgGPGqM5UiLIwx6A6/ASq6MFS/RKqGeV06O1mGKNY
	Hkpxtkq0hAskmO77JYcMLCk2rRoM+Netvk4cIwe46hHMdzauZK+tRAoA4MQ3SiFAgmQZHn
	glmlqLavlCZjqX83YyKq/e1m1g4Ua/s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CU4iyxRk;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773147608; a=rsa-sha256;
	cv=none;
	b=SUTdmmVmJisAeUIuttlMEbjGm++Ful+RqU3FmAuHP3mLwUEsHCFRdvACtfTUqDUzOTHGGI
	EnXQa7dHStjzjC1XlMMsqs6y6W9tAddIy8uvibQdpuZph9ZtCNmXEsOe0vl6BHp8h4IWr9
	XgZVvl9B4ngn5NUEhNqzekyhRub0tfc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773147605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RftT2Y3IHSXVZYJ/UW0Tv3eAsLcm29Tj9tutyIZqu1o=;
	b=CU4iyxRkqkOC9/RWtWv+LAXeUNmQxDABlgtj4YJbm6UgHanX2RC8TMubw3qTTXydh02zku
	6CI+w51oyp132mrx6nNaEog5MHpNDZFpwyNJcwjN1iMFnEqSSB2q8AhbsiZdTJ6v1HYvFI
	2KD7n6dcSjrzxsZPydIqyn5R/lh+p88=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	david@kernel.org,
	harry.yoo@oracle.com,
	hughd@google.com,
	jannh@google.com,
	kas@kernel.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	pfalcato@suse.de,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	vbabka@kernel.org,
	weixugc@google.com,
	willy@infradead.org,
	youngjun.park@lge.com,
	yuanchu@google.com,
	yuzhao@google.com,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 0/9] mm/rmap: Optimize anonymous large folio unmapping
Date: Tue, 10 Mar 2026 20:59:40 +0800
Message-ID: <20260310125940.39707-1-lance.yang@linux.dev>
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rp6ea4en398hnjbg9ttajhicxo5jkq1u
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 46BD1140006
X-HE-Tag: 1773147608-803823
X-HE-Meta: U2FsdGVkX1+1jqUcOBdGM2xx4v4m2spIL/4kQR5WZpo2oT0shMKgHmCUN0xmEvISJjs6FL8yE+2h0DuNCr7jLGT09KftynjQTfyIo1mpkMHMV7kHD+MSkj171nbIlngFcjPZ3QdTMkKGjXaXOd/eLPlRsCk1EEjTtIbpXFBsm5gTos3rEonIsI023UfjqOmSSQgwrHu9LyHJ7eVNHQ2IdBRTHLDvbrV/0L3FHmTTeZDsaLjB6R4u41fCzwZpI1qrO7vrT9k2k7P1s+52GGm3t+drtGxYhJaWQXjJ+az0A7UtCA76BmvNUFbON8yrfvhNnx+WaeRAANamSIR4rsJWf5XTFaH4SheVxyx4wTntYPP5VBrdhYNBxnc8HwMtsX5A+yBalhHE7M7ta2dLlf++0jb6vwrK/PfQpRW8Z9Mqsg2sM3AzNPvRed6Jq5wqFE3dr1GY7iK2bNw8a/X4XA00SwE2kcDB7v5IrthpuER2EBRJMSGEhDI4U518LOie7pv+FJgMm08wy3vH50OuGsBlT2SErNFfZ338tauH+gB0jq2MotD1PuJF3VwPw858nRXCH4krs5h2mDmqfQUUw4LI5XwNp5Rszztm2xl2c0wvmaWkkrvees7OT+yl15CCgaOaSIJH2kKUIL72mnftk4pAsZNyoKFz9K6ySCDHIQqdgXpRSIBgrEGnjgrwIuyxk39plByFxnsx9dUUV3Mm8ym8Wsb+0xGca5hwxAhsrZjONI5EKmW9Nb42pG8EXvDstfS32isVt3lg8LtbnrL8sSDGbJjZYx0vJVdX097AubGVd9DdWx5T5CpDasd6IZmBoWkRKyq38bp4dIiwjb8u1IM+G8KVKFKTpSTd3USub/yWZoUClYPHtdYujFaz8MworervfFqSax7/LW7XwDhyZBnmqeGM1zOfMHSc7HGJ4LgpylHDp6l4d3rJm5bf2t5rcgz2TQZry419uVLQU6/W3yL
 lu63ikE8
 gp/D3ZlA0p1XATCew3JOjIZS+qTvLnQPD/aqyFFCn3wWxWPrpQQEV30ZLDKDmf1871lwjDO2iisRHCL6PhTtqr9cOxqFGc2IB11WFOKnJAcU9BFe8lWW/Bj0Y2e+bTES9p5CEIVHRrkKtmkft7yJbWD5s7OScCHtRFidIgO9Lzffnw5k0j7DnO5UyaBwBo88rR/iMB0zKfQWKV3bTkYoPQrddAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Mar 10, 2026 at 01:00:04PM +0530, Dev Jain wrote:
>Speed up unmapping of anonymous large folios by clearing the ptes, and
>setting swap ptes, in one go.
>
>The following benchmark (stolen from Barry at [1]) is used to measure the
>time taken to swapout 256M worth of memory backed by 64K large folios:
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <time.h>
> #include <unistd.h>
> #include <errno.h>
>
> #define SIZE_MB 256
> #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>
> int main() {
>     void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     if (addr == MAP_FAILED) {
>         perror("mmap failed");
>         return 1;
>     }
>
>     memset(addr, 0, SIZE_BYTES);
>
>     struct timespec start, end;
>     clock_gettime(CLOCK_MONOTONIC, &start);
>
>     if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>         perror("madvise(MADV_PAGEOUT) failed");
>         munmap(addr, SIZE_BYTES);
>         return 1;
>     }
>
>     clock_gettime(CLOCK_MONOTONIC, &end);
>
>     long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                        (end.tv_nsec - start.tv_nsec);
>     printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>            duration_ns, duration_ns / 1e6);
>
>     munmap(addr, SIZE_BYTES);
>     return 0;
> }
>
>On arm64, only showing one of the middle values in the distribution:
>
>without patch:
>madvise(MADV_PAGEOUT) took 52192959 ns (52.193 ms)
>
>with patch:
>madvise(MADV_PAGEOUT) took 26676625 ns (26.677 ms)

Good numbers! Just tested on x86 KVM with THP=never, no performance
regression observed.

Cheers,
Lance

