Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F45C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 08:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDB26B007B; Mon, 27 Jul 2026 04:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5296B0088; Mon, 27 Jul 2026 04:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22CD6B008A; Mon, 27 Jul 2026 04:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC2D86B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:08:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 386D61C0CA8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:08:35 +0000 (UTC)
X-FDA: 85033829790.10.3B92E6A
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf25.hostedemail.com (Postfix) with ESMTP id C5873A000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:08:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rcW87Yox;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785139712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6HLmhjbpj99T3EygYwInaeiofORC8oNhZgRbwCAD4Q=;
	b=RtgSMqeCrh+oVheW/S20wsKTLK4BnNTC7JlBvqKnde0sfAQKa3oTDDA4NVb5hujLIb9OWU
	f+PzoKwE5RUZaNN/ihnv+cY5y3f4ZhxG7FH0jsu2jl5UYBoHdPM5JuhRQ8+eNZH4IWGzBJ
	0Wym4T0agpRyb0aDGhQfvI9l+4gmFGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785139712;
	b=Gf3q6xlNqdbhQr/+hki/a5sgMw9uKErFA4ntn5Cvq7H7z8mI/X92D1hYuWO3iPP3En4Xe8
	09TqtBEfSnZiSLd6wnLnbZGKWyxqNbylgbb6tunhflquiF1wRwm2byODpLjp/V8zbDGUMO
	4DvLHLxCRZ75Ee5spYFxJrZCPaT1SIU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rcW87Yox;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785139704; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=J6HLmhjbpj99T3EygYwInaeiofORC8oNhZgRbwCAD4Q=;
	b=rcW87Yox05F0nzyZSqKRaboe+8yPYHzubsZud/qW+tbm4b5dSC+kreDPl5tRMS8lFqciuHB1eVhIQxEFCD0nberQXkaqwYYl6yCq9WfATXJx2+Y5Peay4KOFM9RhGKC3G9JVKofXCReTJHhhvETZ2t03WlDXCfV1p96fW8oufqg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X7rqjGN_1785139699;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7rqjGN_1785139699 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Jul 2026 16:08:21 +0800
Message-ID: <fef26b57-1e5b-42af-a311-7a961806a22e@linux.alibaba.com>
Date: Mon, 27 Jul 2026 16:08:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] promote mapped executable folios after first usage
 for MGLRU
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tao.wangtao@honor.com, zhangji1@honor.com
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
 <20260724160000.b4-mglru-feedback@hihonor.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260724160000.b4-mglru-feedback@hihonor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5873A000F
X-Stat-Signature: pd353ngxu9k7jkx416osy6nsnsxsezdx
X-Rspam-User: 
X-HE-Tag: 1785139710-783375
X-HE-Meta: U2FsdGVkX1/NvWXq1dZrwHSjQpdkxHpW+OjmSwFJ3yZ5ffOoOisTVq/NnhsDHMbqHBWNhP3LlDzR/mTQyBFHs6f2QGekjqps3YvJw1txthcD9pvgJmclRQTv2YNSwlhP8fboliijgPjqBFe7s7yNQwRNsgS5dBb4ILgGaHFGykeS0fHLOaB3WK+rNVW4vxEKmbHfTqkaL61yRlK8q3MLS7fHEzwKZK84VWRsu+1H1RWtkdqoJrdF7Pzo3wfPEZZnnnsQYpsFvml+MZdF3+wLPv3yQyXuDpL9679Ti3C3mcZTnhLi/zNREPnRnKGuUCvyqT6tV0noIwDggkSxWM9RY6mBYiFLwqoEkvEo01Rj7xAU1lkv15DYxoq/bwM2vYQsgKBhU66CKyC4MkRd6++uhG200qiInU7lRJNMiYzIvNUIFrJaG/fbSRAmGbuHSw2jdS5sj826/huO93nQWQmbyUNjhuPnp3FwT1ZaW4kzbH4pp5s6EvOVvHImvF5a5FeyMbxPhdXewKmv+29l55cjgPTT0Lx1/r0bw8qvrsjt8mvonEs9HRvNZUoVrTKISaz6sk0KsYZTLazdEZVsUmJtm/Nr6qCNIJZwi7CrF5HsrnrRH//uyXTwXxmzsWT8ZMMps76HWi6Viup5N9eX6w9ZH0RqaBJa3GtdPL7SmPEO83GncLXTuQCfr2wDs2e6mwbuGr0SmTlq4C3UKqPnOcxfyXq62CjVvhnypgG9HfbLTY9PyIq68pf1lFmZBjzgtE72f+BJsJK7FI0DCw5bhsWhoqWjGU5y++no2kJiNJX0UPoAn86LDcHGcx+pG4ap+sE47lFfmQzHd0BUA9pbEifmKvrhweV7ylrH7e1UUT+0sNR6azT1DJgFNBNFsLy2tJzWjSlTNDjewv0b/SY/46oRTmSBhh8noYaTaPtDw46nHuvPD4TFB55M3nIcqHiYwJJd3WBfSH7Q4RYlVeSTfln
 WYVGJRBl
 vrzObAlFpYmDQoKwdKCjLdP2ksgaHv5enVR7cb4+smZqs05unr47BTib7KnisICWg/uEuQmXYhbeB6wcMQ4yG8TCn4fJwLDuVN8TR8QZ6hzD2w5vFsB0Q5P0Jqj6sUlwS+bQiophcNXegRal3xjUmovtZfGuF/y7UDX9PIRvfAuHrxk2qjG8A3bT3mCGfj0PeB2tJANu5gw4TtBhHt1gO4MMXefPXnnqkALLiHAub8oQiqbqcbgBArPf/8xp2W8AkWcWkFB0oV//HIvqK/bPzioArnStMRqAGzJwtPJS9tsIpEdQrHtamKCOTCpTUqFDXDBYR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zicheng,

On 7/24/26 4:00 PM, Zicheng Wang wrote:
> Hi Baolin,
> 
> We backport and test an Android handset(qcom8850, 6.12, 12 GB).
> Patch 1's vma_flags_t isn't on 6.12, so we kept only the core
> check in its legacy form:
>      (vma->vm_flags & VM_EXEC)
> 
> Since this is a backport, the numbers below just show the direction
> of change. Overall the patch does well, and ran for several
> hours with no crashes or hangs:
> 
> Camera (launch + capture, 22 background apps resident):
>    cold-start p50        -6.3%
>    capture               on par
>    memavail at startup   +4 .. +7%
> 
> Reclaim over the same window, as the patch intends:
>    pgsteal_kswapd -46.5%   pgscan_kswapd -52.9%
>    pgsteal_direct  +0.8%   pgscan_direct  -6.7%
>    pgsteal_anon  -13.8%    pgscan_anon  -13.8%
>    pgsteal_file  -14.5%    pgscan_file  -30.1%
> 
> Dynamic jank (cold start + scroll, x10): missed-frame <1% on both
> base and patched; not memory-bound enough to discriminate.

Thanks for testing and sharing the performance number.

> One trade-off, same run. PSI (memory) creeps up on the sustained
> window:
> 
>                    avg10  avg60  avg300
>      some base     0.00   0.03   0.33
>      some patched  0.00   0.02   0.37   (+12%)
>      full base     0.00   0.00   0.10
>      full patched  0.00   0.00   0.13   (+30%)
> 
> and kernel stack footprint -5.3%. Reads as LMKD keeping fewer
> background apps alive. This seems an Android policy interaction,
> not a kernel regression. Downstreams with aggressive LMKD may
> want to retune.

I didn't pay attention to PSI before, but I think this is explainable.

Since we try to keep executable file folios in memory to avoid IO 
thrashing, which could cause more severe problems (such as the system 
hanging), this also means that the stall time of some other folios may 
increase. Moreover, the stall time of the original exec folios might not 
have been counted at all, for example, in filemap_read_folio(), PSI is 
only accounted for file folios marked with workingset, but before my 
patch, exec file folios might not have had a chance to set the 
workingset flag.

However, the overhead of IO thrashing is more severe than the stall time 
of other memory allocations, which is why the end-to-end performance 
improves, as seen from your data.

