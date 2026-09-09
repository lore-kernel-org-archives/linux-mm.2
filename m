Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9A5C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 01:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7C26B008A; Tue,  8 Sep 2026 21:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78686B008C; Tue,  8 Sep 2026 21:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D7E6B0092; Tue,  8 Sep 2026 21:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71AD56B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:37:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA03A807A9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:37:37 +0000 (UTC)
X-FDA: 85192511754.29.7547315
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 095F0A000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:37:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n5kLNgGa;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788917856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCl8v/e1Ribr5OQ7F4L+L+/USm7rKZv5e/AFPktfvKU=;
	b=pT+jZhYLrcnSrBokkpkL9LelElmFr5JMrMdsCRsjqWylwMEX3jMVCoCOjEiFOWVrGSE00n
	c60/AvyGij2PEpgsrVuBvENG3LBn+qLynQFQpVuVYaQUm37GteBizR6ks1ZnfZ/ITVZ5ow
	FKuy8KLjuB4wKfwqCNDeTq1znCxGLyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788917856;
	b=uL0d0oL41MFTalEKLXs22kpBEDG85YocsTl6ux0eKKF9jNO8qkN1g9ITN8Z46/UiMdqexR
	a1uDfAaqab9wtFJQuqMEPVON+a0hWvSPfS3uaQAdXpiQrNaNoRSHRUuZx+g+yQrQ8cRJjE
	L2My4Q0gzWxuJVG7XZ3ZmQU8VJJcZrc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n5kLNgGa;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C28340BCC;
	Wed,  9 Sep 2026 01:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1021F00A3A;
	Wed,  9 Sep 2026 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788917855;
	bh=wCl8v/e1Ribr5OQ7F4L+L+/USm7rKZv5e/AFPktfvKU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n5kLNgGajilivzKNxr6qpSIgTRetxyb3x1+BtrqXUEygI/I48nTe9K8FN47vE6BPq
	 l8cyhTCo38RYUFtxqC0HV7fQZFi9cdyBW1Bi79JzbR5/zRai0NsGs9IfChmrGG928h
	 fo/AjnTJ+Bm2lpDcwwzrX3dydmVtfdPEu6j9I9bY=
Date: Tue, 8 Sep 2026 18:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v4 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
Message-Id: <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: on7qzr8xn7hebb5a1m8zkpadwkwrob4w
X-Rspamd-Queue-Id: 095F0A000A
X-HE-Tag: 1788917855-373481
X-HE-Meta: U2FsdGVkX18ZmBHorrG6KI6qxrhrE7nnxvrJofDgaf4mACWKEYeVvvg26dp2/MP9PDDaLuwvmiOOjoU2g4xVNKyTaJyEMM47CDOARq0C5rVzYBtlMBnN/XWTEIxDYa14002llbGw8WWkLzkBxeTWfgo4wsw6mcPKbxIqNC3oDYD9OMHFmx59bM2TJCJdRrz/zwhA0rYnvfB3TxBnm9b+qTaD0gTnKm/MKzztARNIvvgp6yYdMhOujoBpqbiR+ndcTxB4HYBJyHRVU3HD+rIyeg5NSNXJ9f2hLU1gj5znNB2gPG4kuzqHhbYDmEcNU8gx1iJDVfwSssn2CU9hCQYGfjiGF9M1HTtL0z10AnkGe60JDOpUHT05CP7zU8TiEmiA60hGKdsBMHEM8IFRAt39dvn09c+bQvbm4UF3iyk+MxHthOh5x2EtoBxpFbs9u66MWkFLkWE1iVWrMnjPr2KuAN8sfDorwzoBwG00C5qpxz23GbObl97go3/S1J1A+HCw11hNGAtKn03RVlyc6I2Ej1xoAH5fL+JiiDMk9x4h+REBQqPxaweV/6ObOZk64/8EXHT2XwrFmgh0xylU54arCrDgJ92DtXAVJ+suyxFH2u3HZDcNivmKftxBBO7vXKozbv2z78jNOuYcOU5rXZKQy0jONnuE0+4ohsmEZMEZylYyUy+xoCuu7lKL+se59KlQS9nOBd0Ipw7abNkK1kE7glh7BYXIiSxqRJ7Z6aK4lBq+pvUWkl4MxFn/KUquCaEMqHU6rmKS//akQXNYBGpk4TPh8hv9nWWdDEUheSzKx2Zvg0/1rd2KLRtXtZYVhK7D5YHY7uQsCTg5gCpcKqPuEZPzUvDeSQNT+8y8LPa7gDOUiDDRjrAJ5/rj+Gd9DJasRkKF1/Kga9mpDCRBcRKCclzqBX5FA5PI22HuMLzjA5LoAq1a5682CxNSZ7V0R+Wxgv9sN/JED3E5yffi2rT
 BNam8gtC
 rYgU1PNdCNkgWM/f3x3DqWU/ImXMuskDsdphrkwfQelj1eMpPu9jlokZrv4WiYfKl2yD9ma+HStWXk+yX1kZGTsUCpTEG3yEUYVhjlVgmr+arGNNzA2NI4Rhs5DGhtb1G+6PnuxPf4FC+bi6kf3e3UEmBQ17x9JRyOrOpCG45t9l//YSS6tzljwG9H1LlmmcL8xLzNBshsZPDqaHjvbpdJx/rY6+5ofjtcgUX9KpNUMiUkJDevhSBWm3Exgaa/W0H4kUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 11:41:10 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.
> 
> ...
>
> Performance testing
> ===================
> 
> The test script and the raw results are available at [1].
> 
> Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
> configuration, medians reported.  Workloads:
> 
>   w1-anon-churn: single-threaded anon fault/charge loop in a memcg
>                  (MADV_DONTNEED + re-fault, no reclaim).  Every touch
>                  is a real fault with charge and memcg stat updates,
>                  so it stresses exactly the fast path patch 1 changes.
>   w2-file-churn: file read loop under memory.high pressure
>                  (reclaim-bound, noisier).
>   w3-reparent:   reparent accounting sanity check.
> 
> w1-anon-churn (pages/s):
> 
>                  classic LRU          MGLRU
> base             4393028              4377122
> patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
> patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)
> 
> w2-file-churn (MB/s):
> 
>                  classic LRU          MGLRU
> base             8277                 8226
> patches 1-2      8226      (-0.6%)    8123      (-1.3%)
> patches 1-3      8157      (-1.4%)    8294      (+0.8%)

Am I misinterpreting this?  This difference is probably within
inter-run variability?


