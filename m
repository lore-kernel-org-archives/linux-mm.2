Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0698DCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A9B6B0099; Thu, 18 Jun 2026 08:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB306B009F; Thu, 18 Jun 2026 08:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4366B00A0; Thu, 18 Jun 2026 08:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1DD76B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:23:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3EE2C22D8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:03:24 +0000 (UTC)
X-FDA: 84892747128.21.FB98C16
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1738BC0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:03:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781780601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qfZg4IdiCCqmmbvHg/CtckauMtp6qN4haN0bX7CC/9w=;
	b=2qsL6h7R6pwe93bcJ4fG034/PKPQPK8cri+odAVP7mgoa+0zKjtHd4oDQRMiu7NjMIYQq1
	gdO8Xcz4wmbbsxaV8/wL1O2HrMexAH/3PZsrjbEISo62CuTHTq3Bq2P38lsqrkjdqVFI3a
	yQWXBssvbSjJba+9n14dIZ7cnoTtoY8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781780601;
	b=1nIgdEmZR8p4EfU51txftKtu5FaGNQajRq/sMCC/Bp6HDJ961aV4iRW1QsY1D4XTwK/0Lr
	fNbTUM7HrNO8MOrCeXh6uspSrckiLCHGbunRhXg44qkzTf/EXxTh7ioDo0MucfVtibAyT0
	kRBAcmibc59I2QawibeHyIJXQhu4jXE=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ggyW25LryzHnGdy;
	Thu, 18 Jun 2026 19:02:54 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id E4B9240584;
	Thu, 18 Jun 2026 19:03:14 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 14:03:14 +0300
Message-ID: <552e1d3a-3c60-4110-8601-00cd9bc7998a@huawei-partners.com>
Date: Thu, 18 Jun 2026 14:03:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM
 SPE feedback
To: Wang Lian <lianux.mm@gmail.com>, <sj@kernel.org>,
	<akpm@linux-foundation.org>
CC: <npache@redhat.com>, <daichaobing@sangfor.com.cn>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <kunwu.chan@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 1738BC0009
X-Rspam-User: 
X-Stat-Signature: nxgqz7dpjygqwzkuotguoxf7kw19shyi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781780600-773945
X-HE-Meta: U2FsdGVkX1+OmOvmsz92fz4VNRUXpBBEynT93xJ/WPZVOIEy0275bT+dkbZ+oll6+G/N8fnuHbfMp0+v6K2sb6bazJYduxuG6tETgEOAYmWs9GoyMtiIhNWV+nbzQzYSRBfgeCVsA8tpGR/fqhG3DBL64rVdrfTuPPw9i6h3llDYOKYgtJTTLUkH/99KQiS1XyrHwEeAEvVPy6UxMzH4VRV1VD1NABrsJbk5wULus1ZfivNJDAHFRNdgEpSDwq1RSXI1paGNFDgDunBxkNyUCUCuLlZev1lVJSJOrVh5wp6bp+AB07DD5zp21ae9icjEzObksg8RPS32IDe0iG9+hBlSy3Klb1J0EFFWtKrJ/yi9b7wHHmqzknE3HtQxy9Z05RY1Df1gYeokRPlwVW/Ctn9Vlc0+JrkM+vMm00d8K11m7Tu2SGcyvK/kChxqRRtbD5Pv5Lky+ZXHEtg96cpQhKGe9VgI28woElOMGc7C2cgGu3Z0y7MgvQWSRzKxMO9IA/CkEkT3zqanbbUgtr64RDpIZOxPfcOJdGCBxCSdaYNAY44v5CSSYSu4GysJpZZPpwDMvCaz4WmR+2t80eIAAU2Xm2TWePi7xbciGIcR5zKrOs1l4mAfS/cf2Vet3Hmg1oCaGrO/P5+rBRdhOA/b3KxRvxxgsUgGHN+sq9JQB+6pJGh1r0cnanDTwtNpszg+AMoejxUMlRkbkofbVORWdUtYrtlGc6FTKOdxxqq0M1Dspx5Tb8CYQo9GLCb0mpFHJ2y0Eh/Tu13iL7Edislz/DIEFpVe/2SdBRYcWubrVQPd67VFXvoYzuTRXevm08cRhL7ux4lBVFYyuv66d2ZPMjEolHVyipIYokZ9k+zlp3WDH9SgU+fluP50//WblM2OU/1ZLFYFRQj79PFDqjCiS4sOUXDRE/zHuFGV8gRbac9dD7k9OdDT4W1HzPARTUcw7fWrFVXkCG0VTD9spAb
 OOTDheXn
 QfRxziSu8ClMjE0zR4MF0FPWFeeVXAAM2KlD0xtoNy/sWTDZeaQ4LNiZUw2dOUT1f087G23APQghZuoSf0q5p9fEp72wh1H/qnl8qji0vK1dvu0ZA6jEX3isBc12b3m8tvp4jyOI94F/f8aEXhRKsThlvdmzy8466paI/iON9mn8yryf9RKehWJ1aVV7C0JfxS3uZ/hQsKicI+Pear8u6Mmhs3Uy3c8mnoELlqdhFUCWfslSqWJCGH+pHw7DfKJ2wCsMB5/gj+haTxf+lnhOTWgvG0AG6hRC48jSTJruF46sFzBagyTTSTvgveP4LcRAuRUO4BrfsG/OLZAyC70eHpsluxxiArHf9zPSBdAjDQa82gMFDRZJXvOoH7MeqQ3eCxdrzA5Goctj8apCRRBaaZBJHE4FGKwUAMUzNtsGyg9Xy8ZmRJnMKYUGVS29EQ+g55hEBf5ws2rfkKeF+oDCr5flFy8Rkc9mLW7Wk2X+P+MpbSY2NOJ+2pcrHTvztciHOMseccu9fLR0au4AaudUN6d/zsKv4VUXIgZXGCFsAqqHejBucN4Oh+uMH5pIECo3/QHsHSfgN+CvDvrdGSo89Y0ULJKd/LKwYltB4hgHajERNqEpEgIDy9NxD2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wang,

On 6/18/2026 12:48 PM, Wang Lian wrote:
> Received an off-list report that DAMON significantly overestimates
> hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
> running Oracle workloads.
> 
> The root cause is structural: a PMD entry covers 512 4KB subpages with
> a single Access Flag (AF) bit. When any one subpage is accessed, the entire
> 2MB region appears "hot" to DAMON. On ARM64, this is compounded by the
> hardware AF mechanism -- the AF is only set on a TLB miss. Consequently, when the
> working set fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB THP
> running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes completely blind to
> subsequent accesses. x86 is not subject to this specific blindness under similar
> conditions.

Have you tried setting the minimum region size to 2MB?

> We reproduced this memory inflation on a Kunpeng 920 platform using a synthetic
> workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually hot):
> THP=always causes DAMON to report the entire 8GB as hot, while THP=never
> reports only a few hundred MB -- a 512x overestimate relative to the actual
> 16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM SPE hardware profiling
> independently confirms this asymmetry: out of 2,005 THPs sampled system-wide
> over 10 seconds, 97% had fewer than 10% of their 4KB subpages actually accessed.

THP always will just collapse the entire PID into huge pages anyway. This
is outside DAMON's control.

Have you tried setting THP to never and running DAMON with DAMON_COLLAPSE
action?

> To mitigate this, this series extends the existing DAMOS_COLLAPSE action to be
> mTHP-aware via a new target_order field, and introduces a new
> DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD THPs
> into smaller mTHPs when most subpages are probed as cold, and collapse them
> back when beneficial. To resolve the sub-PMD monitoring blindness, the split
> path can incorporate fine-grained hardware feedback from ARM SPE.
> The hardware feedback loop (damon_spe_folio_heatmap) implements a two-pass
> signal filter: it first identifies the peak chunk access count, and then marks
> sub-chunks with >= 1/10 of the peak count as hot, effectively filtering out
> SPE sampling noise. A configurable hot_threshold (default 30%) controls the
> split decision: only folios with a hot fraction below this threshold are
> eligible for splitting. When no SPE data is available, the infrastructure
> gracefully falls back to explicit PTE-level scanning via folio_walk.
> 
> Currently, SPE data is fed from userspace via debugfs (e.g., perf script piped
> through a histogram builder into /sys/kernel/debug/damon/spe_feed).
> 
> Collapse path (patches 1-3):
>   DAMON scheme action=COLLAPSE, target_order=N
>   -> damos_va_collapse() -> damon_collapse_folio_range()
>   -> collapse_huge_page()
> 
> Split path (patches 4-5):
>   DAMON scheme action=MTHP_SPLIT, target_order=N, hot_threshold=M
>   -> damos_va_mthp_split() -> damon_spe_hot_fraction()
>   -> split_folio_to_order()
> 
> SPE feedback infrastructure (patch 6):
>   perf script -> spe_hist -> debugfs spe_feed
>   -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
>   -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision
> 
> The userspace helper tools (including the spe_hist histogram builder and
> validation scripts) are archived at:
>   https://github.com/lianux-mm/damon_spe
> 
> Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, base kernel
> 7.1.0-rc5+):
> 
>   T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely within the
>      L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using 512MB
>      with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB reach), allowed
>      DAMON to function normally.
> 
>   T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
>      THP=always: DAMON reported 8GB hot (512x vs ground truth);
>      THP=never: ~245MB (15x vs ground truth).  The THP-induced gap
>      between the two modes was ~33x.
> 
>   T3 RocksDB: Fragmented malloc allocation prevented THP formation, and DAMON
>      behaved normally. We could not reproduce THP inflation with RocksDB.
>      The workloads fundamentally vulnerable to this structural issue remain KVM
>      guests, JVM large heaps, and PostgreSQL shared_buffers.
> 
>   T4 min=0 deadlock break: A 256MB THP induced the DAMON blind spot.
>      Triggering an unconditional mthp_split (via nr_accesses/min=0) successfully
>      shattered the space into 16384x16KB folios, allowing DAMON to fully recover.
> 
>   T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% hot subpages.
>      A typical trace showed PFN 0x820db800 accumulated 39,794 hardware accesses
>      concentrated across only 3 out of 512 subpages.
The SPE stuff fits SeongJae's goals for DAMON-X, I think. Maybe this is something
we should keep in the user space and let the kernel provide only the API to add
different metrics, including PMU and SPE.
>   End-to-end: Verified hot/cold discrimination. The SPE feed preserved a 90%
>      hot THP intact, while successfully splitting a 25% cold THP into 128x16KB folios.
> 
> Known limitations:
> - The full KVM + Oracle production chain has not yet been benchmarked end-to-end.
>   While individual component verification is complete, full integration testing
>   is planned in collaboration with Sangfor.
> - khugepaged may aggressively re-collapse the mTHPs that DAMON splits. A
>   coordination/back-off mechanism is required to avoid ping-pong effects.
> - SPE data is currently funneled via a userspace daemon and debugfs. Direct
>   kernel-side perf_event sampling integration is planned as a follow-up.
> - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are empirical
>   defaults subject to further tuning.
> - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing hardware-MMU
>   characteristic, not introduced by this series. Setting nr_accesses/min=0
>   serves as an effective workaround for the split path.
> 
> Reported-by: Chaobing Dai <daichaobing@sangfor.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> 
> Wang Lian (6):
>   mm/damon: add target_order field for DAMOS_COLLAPSE
>   mm/khugepaged: add damon_collapse_folio_range() for external callers
>   mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
>   mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
>   mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
>   mm/damon: add SPE feedback for sub-THP split decisions
> 
>  include/linux/damon.h      |  18 ++
>  include/linux/khugepaged.h |   3 +
>  mm/damon/Kconfig           |  12 +
>  mm/damon/Makefile          |   1 +
>  mm/damon/core.c            |   3 +
>  mm/damon/spe.c             | 505 +++++++++++++++++++++++++++++++++++++
>  mm/damon/spe.h             |  62 +++++
>  mm/damon/sysfs-schemes.c   |  96 +++++++
>  mm/damon/vaddr.c           | 118 +++++++++
>  mm/khugepaged.c            |  39 +++
>  10 files changed, 857 insertions(+)
>  create mode 100644 mm/damon/spe.c
>  create mode 100644 mm/damon/spe.h
> 
> --
> 2.50.1 (Apple Git-155)
> 

-- 
Asier Gutierrez
Huawei


