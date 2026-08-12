Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEFFCC5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954A36B0088; Tue, 11 Aug 2026 22:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904FB6B008A; Tue, 11 Aug 2026 22:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4B56B0092; Tue, 11 Aug 2026 22:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 509A76B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:29:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2ADDD402FB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:29:47 +0000 (UTC)
X-FDA: 85091036814.17.01663C5
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0AAC1C0009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:29:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OawexQZn;
	spf=pass (imf21.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786501785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbgtKbyUJOoGrSRo0vdiM7TcGb2+835RiKKqbSe5RYg=;
	b=rmIGIqzowonqx+UQsKRU+pfx5EeRh8tRB9TVtV+81wOo+8K2Hd+0402c5YjX8p8QiQKB4j
	R0OW7z9RftQQ5v7jQOpMS8aey33jNA6eSayOvM1P9Wmh9d830lkrsOk3AEWK+EP05m4kc+
	vMdzR/NoHLR2Dr4/c9Io5hVIdLzH3hU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OawexQZn;
	spf=pass (imf21.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786501785;
	b=6/HMfHpzmFeOBrjont0Zlhkp3RpBPqoWjaFkX0/abueos8+7xu/M3PM2GsatDA6D1jyZqy
	P1thtvaXJKe5BZn9y8UoT5juYC1cAkh5b3aGXuR7eHZv19AcprHlqCMAaITYT81GFPUS1T
	Otw743MuenLFgRO3vKLwcV6FIwM6reM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nbgtKbyUJOoGrSRo0vdiM7TcGb2+835RiKKqbSe5RYg=;
	b=OawexQZnUrmJU72zTx2o9jTyrlxX84LbEDQ8kunP2nTQnwfvjM6xC6WJBv16P4/trwqMwmJ9J
	/a2pfzFt9pKbTuuP51F6Nsl4wvXnwEIJAZV3WmBu7O8NrXCgx3/u3A74X4JSb2vS514Jq4SUR+9
	02Mk+ggaiN6GWft3+WdqaM0=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hKXH31MyFzpSvD;
	Wed, 12 Aug 2026 10:18:55 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B2E340537;
	Wed, 12 Aug 2026 10:29:38 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 12 Aug 2026 10:29:37 +0800
Message-ID: <ef7a72dc-fc5f-4b08-833c-05c4ab416605@huawei.com>
Date: Wed, 12 Aug 2026 10:29:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>, <zhangqiuhao@huawei.com>,
	<wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio
 scanning
To: <akpm@linux-foundation.org>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
 <20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D0AAC1C0009
X-Stat-Signature: 3j3fa45ft3daeiopxf5wa1a7pejm55er
X-Rspam-User: 
X-HE-Tag: 1786501782-796014
X-HE-Meta: U2FsdGVkX1/y7DrJYOFNwJbuX48n33pimO2McE7ikRzn85w6MawdYV5VjbjmUcdMmwUbgkHxhS6smXwJ/ZOcKh6IRcnMiirvlkl0MGPuEVokbi1qmRBdO02aTSBzORKaLgJOWnCcBcY/cCgD8JjKxCF6U90l7HX5vBvcCcF9vRR/P6iSRxAnB/mbGcwLDtKyfAOT4jrtD6SnBuns9+6yqXYUDFAEXr05igODt0MqC5+arcz4Ce5JvTYVIcHVlfJ3lsp3QSEbW11M1hj2vPTE5sc/cNDSAN7NE0VXyeV4XPnDarJLWd7/ma5JAfdYnThoB1BofNWLCx/KmqtwHTM8K/fMpaV9DbN+9IGxlk2EhV/uOgHFtbVkONqPFxVkpl+OGgEW7pKi+3/1oVXi6ow74Z7oA1CZpys7zHrg12DPyZ0iE9awpfp/DU5DUkbOkJ/sq1ZOECL3AEXS5AqVH2cKiahL0FVmgqP7DaxFLMNT4FKdqAhrc6AB3fauX8ua4RLp14sl5XucqyO3a1OHineAJfipSoNULERbL7lfgCNbE7SU863eK7nJoG0EH4OF6tl/xOTb4VZuJYsN4IyBb1mH5IXgzWGQLyaZN4ZeFlvqmTWUnVLY8laOxBhAkZU55OyBSiFYBpcjQBCpp1Nb/UKf/axRbVElUWVW/kJL4wR3+w6qhWdEF1TpcuDekZOf4P9Fbg+ZL/MLGcIaTQJUdgawlZR+LEG8HmP8FZkDtURIqitPlLYspMR282KlNyqbzPT1ahYmEAUyD/4TzWFrcx5zhryALeNFBGa8LkCkfOyDhPWUttXNK8NjR9TCGRT3wOgqlfcLaSYLIbJKk4qHLo35kv5ac1vLDl97FgJdDxP/Zgw99n8KLn1B44uEt9DwAz/6UIKOhNoy3TcpqzHpAzZQG+Z+s5lmomfulDZTKiShDV7r0aGyqPos19AcTHIm8RQuQmeuJaThnDbx7mk9kg1
 nexsXlRs
 xJKNFH6hItUoP2wscPVtjcvwrrIU4a/88vWRaQkjLaJ1kc+DAh6Rvk+T3eze7+iPddTXzepgr8R8puwqgbN4xQMfvr770eS03s7zWvwN4CSSE/rk4EYyJb2BlYaXRNuB0K8FkP7UOh0AugT4q0FbfU5GXMwAiHn2SikjdA0mYw5mAET81jDZS3m0eka6mSNpU+Cc5hfAgEJrpSwc/egY/gfZFDOnh8AYyUcqL0MxXbUY1NCkCOn7/zVOHIYg361Md4euCxwGEjLJnUTvpih+wzVgHzwARq2D6WBUJ/q740D7f4gW9RmXA/rw3/0W0w41hordwGlzsPY0tKmrS0EAzqou9WCKWAYYaEh2DJi8EsrGdEsTxucZIV2xdzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周三 2026-8-12 09:42, Andrew Morton wrote:
> On Tue, 11 Aug 2026 15:08:47 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:
> 
>> shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
>> isolate_lru_folios() may scan far more than that per call on a single
>> LRU.  The excess is never charged back, so shrink_lruvec() keeps
>> rescanning the same folios round after round.  When reclaim targets a
>> lower zone, the same scanner also keeps walking zone-ineligible folios
>> that can never satisfy the allocation, inflating nr_reclaimed into a
>> false progress that delays the OOM.
>>
>> This series fixes both:
>>
>>   [1/2] Charge the isolate overshoot against the scan quota so the
>>         next round skips already-scanned folios.
>>   [2/2] Stop scanning once too many zone-ineligible folios have been
>>         skipped, instead of force-isolating them.
> 
> This all sounds fairly bad.  Is there some report?  Real-world test
> results?  Laboratory test results?  Something to help us understand the
> impact of the issues and the situations in which they occur.
> 

Sorry — this background belongs in the cover letter and I left it
out.  Adding it here.

## Situation

We observed slow, unexpected OOM behavior during extreme stress testing,
and while digging into the reclaim code during that analysis we spotted
these latent risks in isolate_lru_folios() — the overshoot never
being charged back, and the force-isolate path on lower-zone reclaim.
The concerns below are the ones surfaced from reading the code, then
confirmed by constructing the situation deliberately.

The problem only appears when reclaim targets a lower zone while the
LRU holds folios from a higher zone:

  - reclaim_idx points at DMA32/DMA (the triggering allocation asked
    for a lower zone, e.g. __GFP_DMA32), and
  - the LRU holds folios from a higher zone (Normal/Movable).

Normal userspace allocations go to the highest zone, so reclaim_idx
never points below it and the zone-skip branch is never taken.  It
needs a real lower-zone allocator to drain that zone below watermark;
that is also why it went unnoticed upstream — the 1c7b17cf hard-lockup
fix that introduced the force-isolate path was found only on a ~1 TB
box running DMA32 module allocations.

## Impact

Reproduced on x86 QEMU, 7.2-rc6, with a kernel module doing
__GFP_DMA32 allocations to drain DMA32 below watermark (LRU folios
sit in Movable):

  - A single isolate_lru_folios() call scanned 32794 pages and took
    25 (32769 skipped): 99.9% wasted on ineligible folios.
  - Across one run, isolate was called 339 times, 140-165 of which
    isolated nothing (taken=0, pure empty scans).
  - shrink_lruvec() charges only the 32-page quota per round and
    never refunds the overshoot, so the same skipped folios are
    rescanned round after round.  vmstat on a memcg OOM path:
    Δpgscan_direct / Δpgsteal_direct = 2836624 / 112719 = 25.2x
    (isolate -> shrink_folio_list returns the folio -> isolate again).

Once max_nr_skipped hits SWAP_CLUSTER_MAX_SKIPPED, the current code
force-isolates the remaining ineligible folios.  On the inactive LRU
they reach shrink_folio_list() and get reclaimed though they can
never satisfy the allocation, inflating nr_reclaimed and resetting
no_progress_loops in should_reclaim_retry(), delaying the OOM.

## A/B results (same .config, md5-identical)

| metric                  | baseline   | patched | note |
|-------------------------|------------|---------|------|
| empty scans (taken=0)   | 140-165    | 0       | stable across runs |
| isolate calls           | 339        | 7       | 48x fewer |
| total pages scanned     | 343711     | 3140    | 109x fewer |
| single-call max scan    | 32794      | 3104    | |

Empty-scan 0 is the stable evidence (holds every run).  The
Δpgscan/Δpgsteal ratio is volatile (baseline 56-26675x, patched
65-1324x, ranges overlap) and is not relied on alone.

## Caveats and reproduction

  - Triggering needs a lower-zone-pressured box.  To confirm the code
    analysis, the situation was constructed on a small x86 QEMU VM
    (1500M, CONFIG_LRU_GEN=n) with kernel cmdline
    `movable_zone=DMA32 kernelcore=256M` (DMA32 small, Normal empty,
    Movable large), then a kernel module doing
    `alloc_page(GFP_DMA32)` drains DMA32 below watermark.  LRU folios
    sit in Movable and are zone-skipped while reclaiming for DMA32.
    Observed via the `mm_vmscan_lru_isolate` tracepoint and
    /proc/vmstat (pgscan_direct, pgsteal_direct).

> Thanks.


