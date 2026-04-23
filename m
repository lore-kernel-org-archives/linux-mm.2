Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007FBFDEE43
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF066B0088; Thu, 23 Apr 2026 14:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380126B008A; Thu, 23 Apr 2026 14:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295836B008C; Thu, 23 Apr 2026 14:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 144E26B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:46:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BC438B9A5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:46:30 +0000 (UTC)
X-FDA: 84690701340.05.6A2733C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B016160008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:46:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=teKKL1k3;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776969988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB6W6hyPcyKqmQvUS+I0KZ5W2s9baEJl33kMKvENrVo=;
	b=tooHFsCHLJwKRaCLAT1U5LHsWzenhyMNZpiiht6XJ64OtwdXTi6vwTQIwYUieuPsia+I0o
	2gYPdFUSoF1Spv+GSDNgnJscUmxgp/90/qOAo/3IfWrloKU3THE/vekrCYHAEvXgvnLZLS
	DuQqpi+l5J4BIR9lNbdkHba1u4tsm/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776969988; a=rsa-sha256;
	cv=none;
	b=TUh8xeuTRqlr54xb0f4E0CHwX+bgGsiJYMVT7ZVJvJrW6ZIaQSwNGaGVxcLewS9XY+pg9E
	HhdJR4HkQf2GWzdcPNxpqRJVBYhLCBzL+DMNOE6mCxKBq4Wmt3zz9Ex2A4ldsY1ARxl8jF
	6WwGA88/7yBGlQ+xEPP8L68Bd1DmPhI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=teKKL1k3;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Apr 2026 11:46:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776969986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jB6W6hyPcyKqmQvUS+I0KZ5W2s9baEJl33kMKvENrVo=;
	b=teKKL1k3n/NP7oWJm4s62DMoOONCrRIv3rQeBFiJ2MKJoSeoIqbA1xxLAG8eFswl8e8rOh
	ZPpSI8TEAFWP0zDc/KVczsP5DAHWPKZt5M+XsXut3sqgxCNYTebY/mAHfxHcOUhZB8iFaD
	PvEp2BC1to6UFnzjKYLC1LZ8fsRRj0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org, 
	mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, riel@surriel.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aepdmTw2tPJ9oMc3@linux.dev>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423164307.29805-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6B016160008
X-Rspamd-Server: rspam07
X-Stat-Signature: xmrs1deonzpeexyxiok5t8iapsjobqe5
X-Rspam-User: 
X-HE-Tag: 1776969988-483672
X-HE-Meta: U2FsdGVkX1/llr+TFkvttdNIOz9GUlK/XLKb8vvIIAHk8thJwIzY2FVTcrWOhLkb/HRNTzb9nwtmzOBEtrKkfAW88+zoPrU/obXNRlD+m03ieWluMNkzu2wWlADROiByaSsaGLwX+xiQF+RCA5znGeWFNsx199x8DfLuZOMz0t0zibG8Itd7s96yg1YraRlJJlxmdUuK/9On8XtHTeXTSF+m3n04iDEXfsBdWXHYFuLXPIvszdQ+0yI0VlAidzOxPH7HLcvrFt/U9BjGNl8xyGf6BLKRe4mcYUS5iyWHQDPu7zCd5rQToYtpMUQ5UfEd/hqf8Xl3m/76hvYH8PDdKdDo1TtYWH8uQz6D4dBCAZ6LtwRifpmNKZ8UciNJwdeHp/BaLnMyqdsdkn0iEruIhPu6bCjE69rhA/ZUkLZxGEr6yZb0VDKsqUayZiK4lKNGITiQOEAAOChOu9QT5EhR67/fmrsWV1OFffwoIUFysXvuKm6le6BbifdSPWaAraHTadKGigzoGyE5dKt/ZPGSBd6KlWGyx4lBI8qifxrgR5gDwB/eSnCDM7sPQcJD8ng4Fa5LcnCoGKKZuzYZtwXqOEpXaAw/B3/Zc2T5X/Mz1Ze77P05QfckCfpL8gsivIFRshsvo3V/aeMNSpoofzE4pXP8ajiMTQC460GJkqvq9ZgZwk9HJxR4VLG6o25GBww8EeZdgph7xMNG4RCt4i+usEUakiVW0w3VevlZPCpGqQCr9/WxKyujegrdwM+phd4JpqsGE9FhP5vA17YoiH4hjitsMeEOO0S9joLwosn/Dc/EvCOSIZkE8foDYGR/lPOAt4jtn2E3ZCNV1jLPEbmeHODWslf3Z6FodEcsL2N11jYbzzqHz8DakE+PkSIjv09X843/jrMiC6gNbGcJSlMyVFXVhIGvVp9AkSVqPbKJaHoC0/tICRlhLvTkzoFQYh6OQKvjBuDpZFhD2MSOn3O
 vnzjMIQt
 8Q4t4w0vKRUrchV6+GuNfs9NR00032In4xx+Oh5yDOVvFXiLA7TVp7W8QXpIaBImEf5n1clRMzc0gOKgZHltrFJyEgjstYU88QH3Vvqmz3/GE6DVvX0dSsrhazJsnPkBcVVfNiuU5wRNQ3akjwZXPt4hY+oa4ntlNY3peOREMt8XwMWbY3F8SDb7NemDemZj2Wr+zVhc1A9hBD847H0PFAUKZDTxnH7kksNrlgmyvzc37Xh2RYLtLG8WpfMgVxbp+D7Ze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:43:07AM -0700, JP Kobryn (Meta) wrote:
> Of all observable lruvec lock contention in our fleet, we find that ~24%
> occurs when dead folios are present in lru_add batches at drain time.

So, when they were added to the percpu lru cache, they were alive but during
their stay in lru cache, they were freed (last non-lrucache ref dropped) or
somehow we are adding folio where the caller drops the reference just after
adding to percpu lru cache e.g. folio_putback_lru() ?

> This
> is wasteful in the sense that the folio is added to the LRU just to be
> immediately removed via folios_put_refs(), incurring two unnecessary lock
> acquisitions.
> 
> Eliminate this overhead by preemptively cleaning up dead folios before they
> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> remaining refcount is the batch ref. When dead folios are found, move them
> off the add batch and onto a temporary batch to be freed.
> 
> During A/B testing on one of our prod instagram workloads (high-frequency
> short-lived requests), the patch intercepted almost all dead folios before
> they entered the LRU. Data collected using the mm_lru_insertion tracepoint
> shows the effectiveness of the patch:
> 
> Per-host LRU add averages at 95% CPU load
> (60 hosts each side, 3 x 60s intervals)
> 
>             dead folios/min  total folios/min   dead %
> unpatched:        1,297,785        19,341,986  6.7097%
> patched:                 14        19,039,996  0.0001%
> 
> Within this workload, we save ~2.6M lock acquisitions per minute per host
> as a result.
> 
> System-wide memory stats improved on the patched side also at 95% CPU load:
>  - direct reclaim scanning reduced 7%
>  - allocation stalls reduced 5.2%
>  - compaction stalls reduced 12.3%
>  - page frees reduced 4.9%
> 
> No regressions were observed in requests served per second or request tail
> latency (p99). Both metrics showed directional improvement at higher CPU
> utilization (comparing 85% to 95%).
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Overall the code looks good but I do wonder if we can add something similar to
folio_add_lru() and if that would be enough. 


