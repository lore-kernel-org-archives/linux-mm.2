Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73943CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F2F6B0096; Mon, 18 May 2026 02:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD00D6B0098; Mon, 18 May 2026 02:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DBF6B0099; Mon, 18 May 2026 02:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3C956B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:23:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A23A407ED
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:44 +0000 (UTC)
X-FDA: 84779549568.24.C502495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F5C8100006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tUEH/P1K";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zosMWXYdseIEDYSrxihbXNIWjHY+0eIGMWhSz/uJqA=;
	b=c3IVQS3OV2W3MR+qw2gCtr90aVm1wn0BUMq+mvL+DSMsya1OpPgV/v+ijO7OSeVaGoFtai
	WxV01mJGkTBWOvZeJCmgGZxH0hwwa7jzM43Fld+UCnFiDXwHTZGn6E7wj0NghyeihzHTSQ
	FE5OTlNNrste93sfDAtLyp0E3lyoGFI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tUEH/P1K";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085422; a=rsa-sha256;
	cv=none;
	b=HR+bAvzrmeKKmR+Ymt2uJd/I8al1uVl30ssL7f8l03Ux8Vis/PLNd0gXZiixlh9hrX9pDh
	3ZgNKPKAPjb+QMSiEWRupOa1qm7VZVqsx3D/eF4sPxu99mxO/Ouj5uwyxiHn8TNG5k3ye2
	lNXeynhW8aJYcIvprcvNagYEm4xVYqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 667DC44131;
	Mon, 18 May 2026 06:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5F9C2BCB7;
	Mon, 18 May 2026 06:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779085421;
	bh=afZ+tMUxJ/YdqFH0mgRBOco1DIIvYJ7z7LVPpWe/EUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tUEH/P1Kx3Q5Wt9ATuJMURyLg7WA6PZzOOyy+9io9nzld8PyN5oFZbFTTUz4qhd2H
	 zbDpALV216Y3Qk++BSUGMrDDiMs/QhoLOA6PxeBZZ4MJ9Eta8Yw/axDP1eaEB0HtV7
	 TQ8sqng3fzi+gkLGjRnCYYaTb1btjqKIx7SJhy+SWu4MLx7OtVTkuZ6l6jAaew9Ycf
	 grs9erXpmzXoNucL6Pbgo08AG/QUjcv7D+2NNesQAV2Le492E4VvnzCm3vie5Ma25+
	 Ewni5Hngd6wrOUzv0G+ZP4OUH8bfxOUpZBEVHDXQIq38UQpqsshbiB0qvxLz/9YXtg
	 QATOLGhAlgijg==
Date: Mon, 18 May 2026 09:23:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, arnd@arndb.de,
	akpm@linux-foundation.org, david@kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Message-ID: <agqwZaEtwXg4-O9z@kernel.org>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515082045.63029-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F5C8100006
X-Stat-Signature: 1p43a8bokcywohdes3i7yq973rhaigat
X-HE-Tag: 1779085422-508328
X-HE-Meta: U2FsdGVkX19d3P6H0i+VqppiKdJpavTHVkIsXvG+Hew0nNVMdPINUB8eELiI63tnUAJgnfU+HHOB01dPKt8ed1yXDGq28GrqkkFg+RKHhm38Am1omD6ZRF1p+pk9706MGoPfINXYfGYPOLmp1QYPJ8skKVkdehPifORasYLXpOROBlFFOdhOIVtTGhM4zr8/l1a0Bb9mPqVZJMm12wVW5XN8Qw0xpBvA+n1XSKZvSJzKxSUV7LC4/2QxqdtX8b6VZpaNLDu7AVdujYUCxwUQ9QeEIdp0X1xRrsTejZQjDNId58k0MysVt2I0IOEh+DfPeRuYmpDjw6i0q4pQXchtbZxUMfRefRbsE/vDbWsYHYrU8uz6RxFLcTcYZpWly85vqGpmmQgCUwH7xWv7dhAuIQdK2zxWD/BfxhhWxerBHr41yGnVUv6uRWqGzIZ4FudIc88Z65ZaSwkjZUReztccPjEX/9akebPklUIbEKJ1TIpeOsHY3uuZOCcpAOlLphGkr404zdL1QLZNia7Mz0aMXiq5U2t9YkoPWyBa/65aly9HTEOnpdosrjxpDo9lBR43Xa2RDCTUDAIrhVdyiiWGj6BrfhWmh3DCB+yJac5Ew28pH9Rcqpnz6QCSTfQUxV73qUhuNoPNRrwxoB9+ouwuJAXf6gTyQiFCwq4HPegri+aCXNoCL7+mL1iguf/Pi78vTq0eWygrSHACWE/YtGyhnT5pQZwqs8TAnRJpXSiQKovzRoYkb7z3qEvGoxZe54NY9QmRHoKLycNwpIcL2af+Lh0JZmSyq1dWRo9iuTmblcowP2Rtnao/WXf7W9VaNCk3w0ktFtT712L55f2CMbte5iXwA+A7VpLd+NqFRP2wZMucF6tkjq7+Sih8Qayk3MQQrrPfL5/biObLFqACcUG0qdd3gpSCVZ3imyeLBf7hCyj0yo4SMNwaNHHMwLw8diSVJcFRiPjrOT0RWVzToAp
 v9anKwsv
 YF7BMEjDRTApEL2m+/cPyN0YWGr85fSn8z4iEt8HZutB0P6JIOrodpFPUe56GrzxiedpjxU9hTUIWSu754DlfrNWk0dhjiwDrDoY3rI3MoJPEkPBfBMT/2+ectnLQ9fdy1mkAKrt+hm9D+h6vKKfuq7NlOaUSUe4Oi+iX9zSreeHX1Kn1u4cZ0UQQz8An44tVsPygSnRQBN9qW2lKpc6PKd86pg7HRL5Uj5a8jfB4dpztLjz6pGy8kSIqVl9KQoUi7dCUUdZ9HRchUE9glAlvDBgIZAKCIkj5g5GJMBoz3XqKBdWu5uRN9ciahw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> memmap_init_zone_device() can spend a substantial amount of time
> initializing large ZONE_DEVICE ranges because it repeats nearly
> identical struct page setup for every PFN.
> 
> This series reduces that overhead in four steps.
>
> Testing
> =======
> 
> Tests were run in a VM on an Intel Ice Lake server.
> 
> Two PMEM configurations were used:
>   - a 100 GB fsdax namespace configured with map=dev, which exercises
>     the nd_pmem rebind path (pfns_per_compound == 1)
>   - a 100 GB devdax namespace configured with align=2097152, which
>     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> 
> For each configuration, the corresponding driver was unbound and
> rebound 30 times. Memmap initialization latency was collected from the
> pr_debug() output of memmap_init_zone_device().
> 
> The first bind is reported separately, and the average of subsequent
> rebinds is used as the steady-state result.
> 
> Performance
> ===========
> nd_pmem rebind, 100 GB fsdax namespace, map=dev
>   Base(v7.1-rc3):
>     First binding: 1486 ms
>     Average of subsequent rebinds: 273.52 ms
>   Full series:
>     First binding: 1272 ms
>     Average of subsequent rebinds: 104.59 ms
> 
> dax_pmem rebind, 100 GB devdax namespace, align=2097152
>   Base(v7.1-rc3):
>     First binding: 1515 ms
>     Average of subsequent rebinds: 313.45 ms
>   Full series:
>     First binding: 1286 ms
>     Average of subsequent rebinds: 116.93 ms

This is really good improvement!

It would be also interesting to see how the template approach would improve
"normal" memory map initialization.
 
> Li Zhe (4):
>   mm: factor zone-device page init helpers out of
>     __init_zone_device_page
>   mm: add a template-based fast path for zone-device page init
>   mm: extend the template fast path to zone-device compound tails
>   mm: use arch store helpers in zone-device template copies
> 
>  arch/x86/include/asm/struct_page_init.h |  28 +++
>  include/asm-generic/Kbuild              |   1 +
>  include/asm-generic/struct_page_init.h  |  17 ++
>  mm/mm_init.c                            | 260 +++++++++++++++++++++---
>  4 files changed, 280 insertions(+), 26 deletions(-)
>  create mode 100644 arch/x86/include/asm/struct_page_init.h
>  create mode 100644 include/asm-generic/struct_page_init.h
> 
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

