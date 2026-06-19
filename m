Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34ECBCD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1A86B00C6; Thu, 18 Jun 2026 21:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0533C6B00C7; Thu, 18 Jun 2026 21:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83936B00C8; Thu, 18 Jun 2026 21:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B75726B00C6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:52:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 396A0A0318
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:52:49 +0000 (UTC)
X-FDA: 84894988458.27.4009E43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 42CB280006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:52:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQZUmupQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781833967;
	b=t/ncHZTBRSiaI5y4gskN7EPrBg6fYEGXQN8ihVwl+mgiWxo3fnTdN5hXBD/U3HJ7Eq8DwE
	pE/P2UoJr+80QS/gjQ9n8EV5vQE74V2lfjSgEl9S90KuOx7UCliCafBb4OqrQM70JcyNtq
	3kB1y/efmCLm5K1IxssPdV/YTayXRKg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQZUmupQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781833967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ2qTSixByWjQJk/3F+mblT/opWAMFOv/2NZkPQXDWM=;
	b=A4fPnbbjtW/D/97UObvsKvvuu/ZWwdCwJoPq+oLLlfmt7T3U9njcLxK7iR1uuGrDRaMq9G
	Q2dX0GEn00YjS+E+K8oUkJiyAHeoV8P6IderIVBF2rqB4q8695TtGF3EbKb1G9HRZN4gnm
	x+B1u8RVSrjN1Cg5JB8Ux4d+YDZqWEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EF8F4094A;
	Fri, 19 Jun 2026 01:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6361F000E9;
	Fri, 19 Jun 2026 01:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781833965;
	bh=VQ2qTSixByWjQJk/3F+mblT/opWAMFOv/2NZkPQXDWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQZUmupQ80V2l/ML0oH0lCIJJe9pytlpzau+naiisWrC+YRKoAisfNy3MDrTIkm9j
	 d46qjLGDOCLkerarAA/UKGZL2ljFmGxbhZpmGxu8IhymeLc4bpmRoYjZGJDuP0a+Yk
	 IOyyc7Cru8rnqUIWDCto6AGGeIxMPH0vre+v/F6QMy0xTKIfWWyJ9N2OnhdQbB4i1H
	 lJGsZ9CrwMRIGTXp9qP3TMxxuP1FpKu4JJ3ZPPygo+pwonD2SGo+6beUUTW8GzGnI9
	 WWYKVJuJHiEb4EetEodmDZVyEORoQAZLf7IEZk0Cnb9YVyjpJzNzqmBscBiaZB7b26
	 GzTB0Ca63X4BQ==
From: SeongJae Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Gutierrez Asier <gutierrez.asier@huawei-partners.com>,
	akpm@linux-foundation.org,
	npache@redhat.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM SPE feedback
Date: Thu, 18 Jun 2026 18:52:39 -0700
Message-ID: <20260619015241.9432-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <459C0876-AC37-4A52-BF11-6436FF33CA90@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uitc6xsd5qjnkntnw93gzcd377wds7kr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42CB280006
X-Rspam-User: 
X-HE-Tag: 1781833967-471178
X-HE-Meta: U2FsdGVkX1/lJc6wqct7ItWSmlycLvgsVGc6TIlHT5xFB1j61B5iztgu3ImLtiu2PqcsDiApECnxdne4O7u42Rb+HaPBBiFQT5TrNvRtZHjCTA8xxNybt6eoqxWP5fKaDAViTUQ58U39DU6lHAOFLENL1t1m2rje+0gccF5dAnGd/zZer/OLUeApx0ySCMYo/XfCVnW3j9emv/7kL3Fs2dF4UlDWma7QH7nSJ3zph1gBqgPwbF+XGawSICEoMMmsileiNZQDRbxRPf5Oxov7qAozkwpZUBrMlum7ccq86MnjHmzT82J1smVKr1bmpVrACuzBR/EXqrfM9MopQz9cn/1IebPX0oyXABC8UxqGGqstKPW031VxQkUII/3rp50ZUHaQOaMIe00GO7St2FzcFhbP699tvk/Cy6KK0tKMgSS03CSZ4Z7c2FIWRtXLpAoY3y5zI3KR8PSo27xncf0Xz45+qZ8O/feQl9HOcezwRnR9PoQyOhXqkALLHYM0xuyUZstf5RLslxbwSIA34vNy021uc5nHxD1dtiIyjZznSMXLAw0sna/6caoFCX2lQnGnBCUw+9Sry7USFF65dsgZCaROpho//J7VaFVkBcwS1TJC7f89GlHTEp6dNJ7mM3KWKrkP9+4bOT70hCNrhsGugIZmuBQEPgXx1Hmc/SWeFQ+XhORhXHHSOKZdih1q6lfOn9XPygAS858YE+/uJi5PpKrIt4uUR7tyYvyJYKkfLLg+clIMs05N/bs/j2rPjcc23ufxyvKCHx4ikQC0tH5ld65/DGGWWIyOakYWUX6crWLfHCL+mmz5uwpLyPwMnwDpkyMZyA3bq4VRbT+OsyvxRrUZYXofBz6WUADli77YAF74BvBj6mekBComlxWwl7ia8BL4yu0HoRx1uueSUzQ350U51ewutohbZ9NrvmOHXEkVMCnnVr2g0Aboc9vhJYyV9rlkOuV7It6qPOFUI9T
 IomDNMTX
 Ojm94G6Sha4FyfJawq21F5407ZDNOsKs8yz/7N9mEvWNU+n3sArVkJ5zu5ZxETmBMTm+n6fu8VgWRObsjdLQhv2MXooFgH1wgqBx8eDKLcHlDykHS7Xt2GZXn4AhQZSbtcL+nz3GsbpHuwf82CvH5YDtm8WFDQ/0IdOa204yFg6FV1+NqOx+trAAom8mCIuFwfUnOUGTHAa7a4BoPWwG2F3jooqmZ3V3u4OWzxW2uaDL50qahnk73RUjfflZS28/Jgj0NpFYUs8TulDTLKF26PA2ZTevaaP0XqisnZ0yLQLQd1ZaE2h+QOb57gt3wwMtkzP+6syk/Di1QEhUg+MHiZE6lKWoWe9EJV8QZR+h22+DlTXn1NvdA1pE86KGkLWQtI7VMElf/V8viTaTl1eO7M/BGCvkcy/1rijm6jVQPD8WcpY+3+meaOb5htoJKe0+yy7UAnnYI3j2gyNemsJ7y/yWvzVW9uxir+9YcTkrYB5UAsnVCdqgYZ0WNWehvh7Zs5a/r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 21:13:07 +0800 wang lian <lianux.mm@gmail.com> wrote:

> 
> 
> > On Jun 18, 2026, at 19:03, Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> > Hi Wang,
> > 
> > On 6/18/2026 12:48 PM, Wang Lian wrote:
> >> Received an off-list report that DAMON significantly overestimates
> >> hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
> >> running Oracle workloads.
> >> 
> >> The root cause is structural: a PMD entry covers 512 4KB subpages with
> >> a single Access Flag (AF) bit. When any one subpage is accessed, the entire
> >> 2MB region appears "hot" to DAMON. On ARM64, this is compounded by the
> >> hardware AF mechanism -- the AF is only set on a TLB miss. Consequently, when the
> >> working set fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB THP
> >> running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes completely blind to
> >> subsequent accesses. x86 is not subject to this specific blindness under similar
> >> conditions.
> > 
> > Have you tried setting the minimum region size to 2MB?
> > 
> >> We reproduced this memory inflation on a Kunpeng 920 platform using a synthetic
> >> workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually hot):
> >> THP=always causes DAMON to report the entire 8GB as hot, while THP=never
> >> reports only a few hundred MB -- a 512x overestimate relative to the actual
> >> 16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM SPE hardware profiling
> >> independently confirms this asymmetry: out of 2,005 THPs sampled system-wide
> >> over 10 seconds, 97% had fewer than 10% of their 4KB subpages actually accessed.
> > 
> > THP always will just collapse the entire PID into huge pages anyway. This
> > is outside DAMON's control.
> > 
> > Have you tried setting THP to never and running DAMON with DAMON_COLLAPSE
> > action?
> > 
> >> To mitigate this, this series extends the existing DAMOS_COLLAPSE action to be
> >> mTHP-aware via a new target_order field, and introduces a new
> >> DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD THPs
> >> into smaller mTHPs when most subpages are probed as cold, and collapse them
> >> back when beneficial. To resolve the sub-PMD monitoring blindness, the split
> >> path can incorporate fine-grained hardware feedback from ARM SPE.
> >> The hardware feedback loop (damon_spe_folio_heatmap) implements a two-pass
> >> signal filter: it first identifies the peak chunk access count, and then marks
> >> sub-chunks with >= 1/10 of the peak count as hot, effectively filtering out
> >> SPE sampling noise. A configurable hot_threshold (default 30%) controls the
> >> split decision: only folios with a hot fraction below this threshold are
> >> eligible for splitting. When no SPE data is available, the infrastructure
> >> gracefully falls back to explicit PTE-level scanning via folio_walk.
> >> 
> >> Currently, SPE data is fed from userspace via debugfs (e.g., perf script piped
> >> through a histogram builder into /sys/kernel/debug/damon/spe_feed).
> >> 
> >> Collapse path (patches 1-3):
> >>  DAMON scheme action=COLLAPSE, target_order=N
> >>  -> damos_va_collapse() -> damon_collapse_folio_range()
> >>  -> collapse_huge_page()
> >> 
> >> Split path (patches 4-5):
> >>  DAMON scheme action=MTHP_SPLIT, target_order=N, hot_threshold=M
> >>  -> damos_va_mthp_split() -> damon_spe_hot_fraction()
> >>  -> split_folio_to_order()
> >> 
> >> SPE feedback infrastructure (patch 6):
> >>  perf script -> spe_hist -> debugfs spe_feed
> >>  -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
> >>  -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision
> >> 
> >> The userspace helper tools (including the spe_hist histogram builder and
> >> validation scripts) are archived at:
> >>  https://github.com/lianux-mm/damon_spe
> >> 
> >> Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, base kernel
> >> 7.1.0-rc5+):
> >> 
> >>  T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely within the
> >>     L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using 512MB
> >>     with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB reach), allowed
> >>     DAMON to function normally.
> >> 
> >>  T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
> >>     THP=always: DAMON reported 8GB hot (512x vs ground truth);
> >>     THP=never: ~245MB (15x vs ground truth).  The THP-induced gap
> >>     between the two modes was ~33x.
> >> 
> >>  T3 RocksDB: Fragmented malloc allocation prevented THP formation, and DAMON
> >>     behaved normally. We could not reproduce THP inflation with RocksDB.
> >>     The workloads fundamentally vulnerable to this structural issue remain KVM
> >>     guests, JVM large heaps, and PostgreSQL shared_buffers.
> >> 
> >>  T4 min=0 deadlock break: A 256MB THP induced the DAMON blind spot.
> >>     Triggering an unconditional mthp_split (via nr_accesses/min=0) successfully
> >>     shattered the space into 16384x16KB folios, allowing DAMON to fully recover.
> >> 
> >>  T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% hot subpages.
> >>     A typical trace showed PFN 0x820db800 accumulated 39,794 hardware accesses
> >>     concentrated across only 3 out of 512 subpages.
> > The SPE stuff fits SeongJae's goals for DAMON-X, I think. Maybe this is something
> > we should keep in the user space and let the kernel provide only the API to add
> > different metrics, including PMU and SPE.
> 
> Hi Asier,
> 
> Thanks for your prompt and constructive reply. I really appreciate your 
> detailed analysis of the mTHP and SPE interaction.

Indeed, very helpful comments.  Thank you Asier!

> 
> Your point regarding the design boundary—whether this fits better in 
> user space or aligned with DAMON-X—is highly valuable. 

Actually Asier is saying about the perf event-based monitoring extension [1].
DAMON-X [2] is another project.

> 
> Since SeongJae (SJ) will look into this thread tomorrow, let us sync up 
> then. I look forward to cooperating with both of you to refine this 
> design and find the best architectural fit for the subsystem.

As I also replied, I'd also prefer this to be aligned with the perf event-based
extension roadmap.

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
[2] https://lwn.net/Articles/1071256/


Thanks,
SJ

[...]

