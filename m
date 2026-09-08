Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA41C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF5B6B0095; Mon,  7 Sep 2026 21:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12946B0096; Mon,  7 Sep 2026 21:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00D76B0098; Mon,  7 Sep 2026 21:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A348A6B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:49:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CBC240361
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:49:46 +0000 (UTC)
X-FDA: 85188913572.03.19D11BD
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 95958180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:49:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Tc0UhNC5;
	spf=pass (imf24.hostedemail.com: domain of love_goo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788832183;
	b=CFGvJyyymqN5fo9lKq3aIYVLVyMwH7ocAeub28gFHjaRclBzcSvvmlM2iBOjyrqWLy7p5M
	d1IqNAsXLYsgwiMaUsEVsej8XiittHGjAzc+YuzFUgePqPx9HEdPGsRO8VZBeWPz/ANdme
	UEakfg2QoqSh7hPxVv91pwr9AuvvWMs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Tc0UhNC5;
	spf=pass (imf24.hostedemail.com: domain of love_goo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788832183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrOK81VCA7fdgvtJBnT3Cwz5ib3t+eGo39+sr78CpkU=;
	b=kOxFfmg6dfprtstuTgtFJa5RfP+p5Z25Gmw+t9SoB/au2cCQKjSBmq7pTzMlbq50KqBsVw
	ovfzdnqqwFtcQ1gv21O+VBcEk5BdFJE/ZgE8Ttj626UeOsRGx7HutUFnPF1FO0+i7Bqi6f
	xBrW2bYBewk4CQzyAgYtOOHfee9cefU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=HrOK81VCA7fdgvtJBnT3Cwz5ib3t+eGo39+sr78CpkU=;
	b=Tc0UhNC5hIH1d5x7kg4j1eB92e1Sy1vrQ4jkFv7NMJIYzpyHb32lvmm8iMKepU
	WKRoyUYEvjgLH3pazYKaYBMmyoFeAQsLj4kk40+RD8f4p6Nj0DX7hu/wAbCnaxbq
	E7naBSIa3JoNN9TOsqG/iDimM9pGLf5x5QNQOB2zdsqvA=
Message-ID: <19023334-9550-478b-bdce-3631de0b1d78@163.com>
Date: Tue, 8 Sep 2026 09:49:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend 0/2] mm: vmscan: fix scan overshoot and ineligible
 folio scanning
To: akpm@linux-foundation.org, liuye@kylinos.cn, hannes@cmpxchg.org,
 mhocko@kernel.org, david@kernel.org, ljs@kernel.org, hughd@google.com,
 mgorman@techsingularity.net, yang@os.amperecomputing.com
Cc: zhangqiuhao@huawei.com, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Wupeng Ma <mawupeng1@huawei.com>,
 mawupeng1@huawei.com
References: <20260901084706.3784449-1-love_goo@163.com>
From: john <love_goo@163.com>
In-Reply-To: <20260901084706.3784449-1-love_goo@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXzN+ZaZ9q03CQBQ--.21762S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGF1UCFyfCrWkKw43XrW7XFb_yoWrKr43pF
	ZxGr93tw18JFWayasIq3W0gFyY9w48GFW5XF4fWw17uw15JFyI934DKw4UZFWxGrs8uFyY
	qr4UGwsruF4UJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UrcTQUUUUU=
X-CM-SenderInfo: 5oryvsxjrrqiywtou0bp/xtbC6xoDO2qfaZq2mgAA3j
X-Rspam-User: 
X-Stat-Signature: t6i4hk58797xcgyqungstjr9yabkyib4
X-Rspamd-Queue-Id: 95958180002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788832182-563992
X-HE-Meta: U2FsdGVkX18Y0H7kdxxA7Za/ggVKuApzJtIU/3xetXrx2nQrtrOpcYpvayY4+sANJAuMTSq/lBbnvWRckog9B1MFO02H3DHt+QYy5MFIE3nkjmcRTkQm9FymsGQYD5DveVL2tJ6FaqTxrrL7m47Dn63+D8peZrcLhVGoXbzC44uYzGBdeWWKqngUdDd13IEXxEAkZdscD3IwxgK7x1N4aUF98MeBKswOkDNBNcZ5KLswnU0xX1mAT+e32lXGa8OrQavYuxR/kYtseXOvDQ0KH2jlyzvNtUbzjDU9g2LDj9Y08UWib2REF/4VJaF5GPVDZiNlbfBshY0Qe3ADaUclMIlzomy/6NI35qgfbwmyJZs//0tSh7n3amvJ0iTyKaKcdNLfqnPc18JtITYnTz6/chzPFpLLqCpFQHNV+HQuA4JV6a6cE0niqXse+A6m4WW445MQI2Zjvn3jDPs8I2DUJiCQw0gvYCUg2kjfMLmZI4JvoU1OGixc687Z8IY9zcimf34530weZQrh2k205pHZ1eshBcSGCrxxX++IdRn6TW/3ZVDFs2DUeWy6Zxy5Voa9saL294E/o9IPW34+K2KD94RbzCGA2Nc3i2x+JA++BZuEI/Ibw0ATI71e7uI0KyhtWAQLdfusxuZ6cvWXCT/7pOJm/DsP+lA3EGjpoxcJAxF3gKhNRw+nZrnU1OSRw+YeOJ4ruDYCzZpPV/hj6SdYe6C2Mg/kfhtukzOGuWMty4Mj+EuBJS23j8GhGI286xsu18oPa6IHHqQ6/AVDaQ+vR72rUmWVqGOJBw8VuTyomBFqNrYKS7NQl45GpdMjdB8qenUuyPQYZ5IhaunTa14+hmxXEDZV43yR3VOwQPCpAg4DOKNNUPp/ETaB/Q6JV6H9/KbpXk0Ss2xqhL8suE8ZLn5LPAg/ji73kNUb9jYt9GEELlT1Teg0DpfzmnNpRUjHnUZ5OH+wIujlS5j34pn
 5IWJhkZh
 MZk92UTsDgM0fNJHD4KbjxjpAgKipijO/FTokZ87/pxMQt2KB+thpoBN81KR9D6RVH/Pt7+wBWJvK3qnOgnX4RsWM4doJgefnELQRmhwOq3sVa6ICWl4RKo+yXquPXVFeXfw0u60jYPXLVvF6ElB74wVa/uHrTyyvJLTE+6XZetLBWl/v8/UNJXL2KyZRdSJo0z/+dCNVx2L32GV/hpTsM0O9/Y7bAx0/Q4GaAbHu2IRBl4vXw/yzqXO2ubwwp+W/jsaIXpJb+4WCkbolB2rrah5c/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Maintainers

   kindly ping.

在 2026/9/1 16:47, john 写道:
> From: Wupeng Ma <mawupeng1@huawei.com>
>
> Rebase to the latest v7.3-rc-1.
>
> These problems only surface when reclaim targets a lower zone
> while the LRU holds folios from a higher zone.  Normal userspace
> allocations go to the highest zone.  The zone-skip branch stays
> dead under typical loads.  Lower-zone-pressured configs (DMA32
> module allocations, memory-constrained devices) hit the issues.
> They inflate scan cost and delay the OOM.
>
> shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
> isolate_lru_folios() may scan far more than that per call on a single
> LRU.  The excess is never charged back, so shrink_lruvec() keeps
> rescanning the same folios round after round.  When reclaim targets a
> lower zone, the same scanner also keeps walking zone-ineligible folios
> that can never satisfy the allocation, inflating nr_reclaimed into a
> false progress that delays the OOM.
>
> This series fixes both:
>
>    [1/2] Charge the isolate overshoot against the scan quota so the
>          next round skips already-scanned folios.
>    [2/2] Stop scanning once too many zone-ineligible folios have been
>          skipped, instead of force-isolating them.
>
> Background
> ==========
>
> We observed slow, unexpected OOM behavior during extreme stress testing,
> and while digging into the reclaim code during that analysis we spotted
> these latent risks in isolate_lru_folios() -- the overshoot never
> being charged back, and the force-isolate path on lower-zone reclaim.
> The concerns below are the ones surfaced from reading the code, then
> confirmed by constructing the situation deliberately.
>
> The problem only appears when reclaim targets a lower zone while the
> LRU holds folios from a higher zone:
>
>    - reclaim_idx points at DMA32/DMA (the triggering allocation asked
>      for a lower zone, e.g. __GFP_DMA32), and
>    - the LRU holds folios from a higher zone (Normal/Movable).
>
> Normal userspace allocations go to the highest zone, so reclaim_idx
> never points below it and the zone-skip branch is never taken.  It
> needs a real lower-zone allocator to drain that zone below watermark;
> that is also why it went unnoticed upstream -- the 1c7b17cf hard-lockup
> fix that introduced the force-isolate path was found only on a ~1 TB
> box running DMA32 module allocations.
>
> Impact
> ======
>
> Reproduced on x86 QEMU, 7.2-rc6, with a kernel module doing
> __GFP_DMA32 allocations to drain DMA32 below watermark (LRU folios
> sit in Movable):
>
>    - A single isolate_lru_folios() call scanned 32794 pages and took
>      25 (32769 skipped): 99.9% wasted on ineligible folios.
>    - Across one run, isolate was called 339 times, 140-165 of which
>      isolated nothing (taken=0, pure empty scans).
>    - shrink_lruvec() charges only the 32-page quota per round and
>      never refunds the overshoot, so the same skipped folios are
>      rescanned round after round.  vmstat on a memcg OOM path:
>      pgscan_direct / pgsteal_direct = 2836624 / 112719 = 25.2x
>      (isolate -> shrink_folio_list returns the folio -> isolate again).
>
> Once max_nr_skipped hits SWAP_CLUSTER_MAX_SKIPPED, the current code
> force-isolates the remaining ineligible folios.  On the inactive LRU
> they reach shrink_folio_list() and get reclaimed though they can
> never satisfy the allocation, inflating nr_reclaimed and resetting
> no_progress_loops in should_reclaim_retry(), delaying the OOM.
>
> A/B results (same .config, md5-identical):
>
>                            baseline    patched
>    empty scans (taken=0)   140-165         0
>    isolate calls               339         7
>    total pages scanned      343711      3140
>    single-call max scan      32794      3104
>
> Empty-scan 0 is the stable evidence (holds every run).  The
> pgscan/pgsteal ratio is volatile (baseline 56-26675x, patched
> 65-1324x, ranges overlap) and is not relied on alone.
>
> Caveats and reproduction
> ========================
>
>    - Triggering needs a lower-zone-pressured box.  To confirm the code
>      analysis, the situation was constructed on a small x86 QEMU VM
>      (1500M, CONFIG_LRU_GEN=n) with kernel cmdline
>      `movable_zone=DMA32 kernelcore=256M` (DMA32 small, Normal empty,
>      Movable large), then a kernel module doing
>      `alloc_page(GFP_DMA32)` drains DMA32 below watermark.  LRU folios
>      sit in Movable and are zone-skipped while reclaiming for DMA32.
>      Observed via the `mm_vmscan_lru_isolate` tracepoint and
>      /proc/vmstat (pgscan_direct, pgsteal_direct).
>
>
> Wupeng Ma (2):
>    mm: vmscan: charge isolate overshoot against scan quota
>    mm: vmscan: stop scanning ineligible folios after max_nr_skipped
>
>   mm/vmscan.c | 48 +++++++++++++++++++++++++++++++++---------------
>   1 file changed, 33 insertions(+), 15 deletions(-)
>


