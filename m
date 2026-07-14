Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F82C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381416B0005; Tue, 14 Jul 2026 07:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3596D6B0088; Tue, 14 Jul 2026 07:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248AE6B008A; Tue, 14 Jul 2026 07:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D972F6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:29:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D48D120376
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:29:55 +0000 (UTC)
X-FDA: 84987162750.03.1ADF088
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F124140004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:29:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="hK01EC6/";
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJOi5rEy563Y/DC2Gpf7vppljoWhPl3nNbGQu7+o5Dw=;
	b=XZHraPNYoIs+CP92aaVQALCip3SFa9Uz8wdMkilRR0IuHQPONLwfd3NHSCOlwHvbgtpIso
	n4QHbPeC62bHZqkSxJmhx/w5pdFg69W7w43KTacuTCsNUERFb9fMlD5xx38xhGJXXzZrPf
	QG8eiP7dLsApUkEiteRsFbTAYj98UZo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="hK01EC6/";
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784028593;
	b=v9JsoPLvTx6jfhn4C2qsMFMQuAzWR43Bpd1oyALR6WANwuTfEQHoqzmItXdL0aA/8RlHe4
	WZjH7YjM3dbGSlxydldnWwgBp8yAjREP4nV8E9WjOA31uGcbv1MFD/lT40nm5LP5JB5+Zl
	RWDmYrdvlCHD6X9xS+996TdOa9Izenk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784028587; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=bJOi5rEy563Y/DC2Gpf7vppljoWhPl3nNbGQu7+o5Dw=;
	b=hK01EC6/n9U8AgbYyqMD9psAZYzL9j1VmXp8tBqmPCGTU0NhNkcg6YSdHJVBPTRXJELiJBk6LAqXbmdrjiBzBc0qtzl7//u7a8nsEIZLnrwfA0EzN1ThKS63yejz1/yKDvDuBoSylQ6v+9nlczAZ8SPYqQn0naR1NDOPCG3N7qU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=46;SR=0;TI=SMTPD_---0X74J2yL_1784028582;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X74J2yL_1784028582 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 19:29:43 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  "Alistair Popple" <apopple@nvidia.com>,  Lorenzo
 Stoakes <ljs@kernel.org>,  "Liam R. Howlett" <liam@infradead.org>,
  Vlastimil Babka <vbabka@kernel.org>,  "Mike Rapoport" <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  "Michal Hocko"
 <mhocko@suse.com>,  Karim Manaouil <kmanaouil.dev@gmail.com>,  Frank van
 der Linden <fvdl@google.com>,  Teja Vojjala <tejavojjala@google.com>,
  Pravin Tamkhane <pravintamkhane@google.com>,  Kinsey Ho
 <kinseyho@google.com>,  Wei Xu <weixugc@google.com>,  Matthew Wilcox
 <willy@infradead.org>,  Davidlohr Bueso <dave@stgolabs.net>,  Vinod Koul
 <vkoul@kernel.org>,  Bharata B Rao <bharata@amd.com>,  SeongJae Park
 <sj@kernel.org>,  David Rientjes <rientjes@google.com>,  Xuezheng Chu
 <xuezhengchu@huawei.com>,  "Yiannis Nikolakopoulos" <yiannis@zptcorp.com>,
  Dave Hansen <dave.hansen@intel.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  John Hubbard <jhubbard@nvidia.com>,  Peter Xu
 <peterx@redhat.com>,  Rik van Riel <riel@surriel.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Tejun Heo <tj@kernel.org>,  Fan Ni
 <nifan.cxl@gmail.com>,  Jonathan Cameron <jic23@kernel.org>,  Aneesh Kumar
 K.V <aneesh.kumar@kernel.org>,  Nathan Lynch <nathan.lynch@amd.com>,
  Frank Li <Frank.li@nxp.com>,  Dan Williams <djbw@kernel.org>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,  Mike Day
 <michael.day@amd.com>
Subject: Re: [PATCH RFC v6 0/5] Accelerate page migration with batch copying
 and hardware offload
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
	(Shivank Garg's message of "Tue, 30 Jun 2026 07:28:36 +0000")
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
Date: Tue, 14 Jul 2026 19:29:40 +0800
Message-ID: <87wlux6c7v.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F124140004
X-Stat-Signature: 3jajmsf88715sok7b1n7skrhgoh16uyr
X-HE-Tag: 1784028590-558060
X-HE-Meta: U2FsdGVkX19ZVJGYVqaHLsL1CekjFHsSYfJ0N4CTzAMjOlCAfHNlvwszTqUzSQTuLnDo5Jwxuo9AozgSnWneUW64tfSsk0Rn5vaAcRXw/3ulBYHs8ks4tjs4sxijMRxTqIGxBceGP3nDiFaffZ3RRrNSHxBdR02vLzUVWeaehEDAElzUtIUOWUtXlOgqWsya49sT6A7DURdhtoGBW1BId+wHZaHk2D7ETFaORmxueBf2UekZcDklcKFIMbyaqe73+gemyJWlDlOuDQCe5jn4DSmRWxr87qvWdCiyMT4lci7qnwaJObwsZINpG8sY5iWnJYgnhIQI6F6+vEhFaLqJZY6LHhY/Qd0i9zXko2ILk5rrM680XabEoVhBvh6YxoNZHb1M6+Mc6T4qeidnlPRytH6KLF1MZnN+gHgUtJZ7pyXcqArJLaJ1Ksu/5fwj5/UAxMbpUtaiEH8Tyh4brVHl2e1oHtIEMQfLjGvQhh9S244dG25WexCZ50hh8Rruiod1wgfEP/lcgQBfWp0v+FNZ4lHCP7I77w9wmTJQDX84cTkUzk75mDy9GsdZO8JvfA9OQjCb3TyyB7jK/JhqG2slfHk9hqyM4fwMWMez3emh1cLQNtUVGQ6Fi55iLptuHa6U+Hml+UHLHDUxYFT0QTIKRqWeKJpkoo5ZiVM85SCYFRro69jNTE7KA7cUNh/kj6/NelIx6LCWPXwJjLKgoPuB4oP3n5iaCU8xZsC/Gc5NBscOiyxq+qpXDE1Mzp07jTgnMgSsg1eJtlXCVuM3Jw9KP91OPmpRVPH3Ihq7SkPAMxkSweGhQzZOEOlEw+CD0o6ZADvakEM4VZsVAOS7jUSJlEnFGy/O3UP534J8P/bTjgIdVOsv0DGCma/mLCQ+I9XKmZqo6WIT0Zxg1Ebk5xilATXpdrMgxkEuvFLz2g2O6YHrA4dq7ppNSuY6zcEJD7tXmmJlPpzLt10qw5zv3Rr
 79R13G2K
 hprCRG+D3F9zBvK5EqBVFrpDFdSPmC1l6OB1doQ41zq3aDlgO7s/+03hm4FW+KI4ZKaWAz0hNss5aqFBcDNrgBab8hlLmTrA5g/c07xBbFnGkXfdPd3dt+L2D9Lj1scLB1XwQoZQ6zV9XLiMT3JgnMdZhTmd1d35l1yp2Sev0wxA/ujAgG+b8zSzwMyz/6Uawn92SdGUyVgJRBgVr+xQoQNGBJu4FL7lfrP35s4QKNi1Wpzu42BGTUdCvtdM1eniZLRMaUb4DnZ42DI3OTUDzUp1oKD4hdG8SaqFS6xzfZgpI07b8q2GvvsucNhZTB4dFewNz2Iguqt/dSRzCTaH3B7jgaThBWQXbYxp+zvzU2ol4cWeeRnACWE8p2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Garg,

Thanks for updated patch.

Shivank Garg <shivankg@amd.com> writes:

[snip]

>
> PERFORMANCE RESULTS:
> --------------------
>
> AMD EPYC 7713 (Zen 3), 2 sockets, 32 cores, SMT on,=20
> 1 NUMA node per socket, 256 GB/node, v7.2-rc1, DVFS=3DPerformance, PTDMA
> (16 DMA channels).
>
> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>
> 1). Moving different sized folios such that total transfer size is consta=
nt
> (1GB), with different number of DMA channels. Throughput in GB/s.
>
> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> 4K          | 16K        | 64K        | 256K       | 1M          | 2M    =
      |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> 3.28=C2=B10.14   | 4.98=C2=B10.18  | 6.19=C2=B10.08  | 6.77=C2=B10.08  | =
7.02=C2=B10.11   | 10.80=C2=B10.13  |
>
> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> N channel| 4K        | 16K         | 64K         | 256K        | 1M      =
    | 2M          |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1      | 2.38=C2=B10.17   | 2.77=C2=B10.03   | 3.21=C2=B10.03   | 5.00=C2=
=B10.02   | 5.09=C2=B10.64   | 12.62=C2=B10.07  |
> 2      | 2.87=C2=B10.11   | 4.06=C2=B10.05   | 5.09=C2=B10.04   | 6.97=C2=
=B10.08   | 8.43=C2=B10.06   | 14.32=C2=B10.10  |
> 4      | 3.32=C2=B10.07   | 5.30=C2=B10.06   | 7.21=C2=B10.09   | 9.69=C2=
=B10.15   | 11.36=C2=B10.13  | 26.98=C2=B10.19  |
> 8      | 3.68=C2=B10.09   | 6.28=C2=B10.10   | 9.16=C2=B10.13   | 12.05=
=C2=B10.16  | 15.33=C2=B12.80  | 46.06=C2=B10.55  |
> 12     | 3.83=C2=B10.05   | 6.65=C2=B10.17   | 10.00=C2=B10.16  | 12.98=
=C2=B10.18  | 15.87=C2=B10.19  | 61.31=C2=B11.28  |
> 16     | 3.94=C2=B10.09   | 6.78=C2=B10.10   | 10.48=C2=B10.13  | 13.48=
=C2=B10.20  | 16.90=C2=B10.24  | 65.06=C2=B12.46  |
>
> 2). First-folio latency: custom tracepoints (in migrate_pages_batch enter=
/exit,
>     migrate_folio_done) measure latency per migrate_pages_batch() call.
>
>     Throughput (GB/s) and first-folio latency (us), median of 10 runs.
>
> a. Vanilla Kernel:
>
> NR_MAX_BATCHED_MIGRATION upstream default value is 512.
> --- Order 0 (4K folios) ---       --- Order 9 (2M folios) ---
>      n      vanilla/cpu                n      vanilla/cpu
> (folios)    GB/s | first(us)      (folios)    GB/s | first(us)
> --------------------------        --------------------------
>      1       0.03 |     24             1       6.86 |    204
>      4       0.13 |     30             4       8.68 |    191
>      8       0.27 |     27             8       7.92 |    207
>     16       0.43 |     34            16       6.77 |    234
>     64       1.12 |     51            64      10.44 |    179
>    256       1.67 |    166           256      10.43 |    181
>    512       1.98 |    255           512      10.55 |    179
>   2048       2.38 |    233
>   4096       2.42 |    168
>  16384       2.72 |    167
>  65536       3.00 |    156
> 262144       3.10 |    151
>
> b. Patched kernel:
> N =3D NR_MAX_BATCHED_MIGRATION (in pages), Total migrated data fixed at
> 1 GB. Change N with knob (just for testing) to measure impact of
> different max batched size.
>
> --- ORDER 0 (4K folios) ---
>
>      N         offload/dma1          offload/dma4          offload/dma16
>                GB/s | first(us)      GB/s | first(us)      GB/s | first(u=
s)
> ------------------------------------------------------------------------
>    512         2.21 |    628         3.29 |    275         3.25 |    245
>   1024         2.06 |   1271         3.21 |    601         3.36 |    518
>   2048         2.02 |   2646         3.00 |   1388         3.20 |   1110
>   4096         2.08 |   4832         3.17 |   2514         3.41 |   2175
>   8192         2.16 |   9253         3.14 |   4839         3.62 |   3592
>  16384         2.24 |  17543         3.23 |   9680         3.58 |   7144
>  32768         2.22 |  36408         3.26 |  19301         3.67 |  14524
>  65536         2.12 |  82572         3.24 |  38091         3.62 |  29835
> 131072         2.08 | 153669         3.17 |  79744         3.48 |  62157
> 262144         2.05 | 332297         2.97 | 175315         3.33 | 134774
>
> --- ORDER 9 (2M folios) ---
>
>      N         offload/dma1          offload/dma4          offload/dma16
>                GB/s | first(us)      GB/s | first(us)      GB/s | first(u=
s)
> ------------------------------------------------------------------------
>    512        11.74 |    160        11.71 |    160        11.75 |    159
>   1024        12.18 |    310        13.82 |    274        13.76 |    275
>   2048        12.39 |    612        25.55 |    290        25.69 |    289
>   4096        12.54 |   1211        26.25 |    564        42.36 |    334
>   8192        12.54 |   2421        26.82 |   1111        51.85 |    485
>  16384        12.61 |   4824        26.91 |   2209        54.26 |    925
>  32768        12.62 |   9652        27.04 |   4404        54.72 |   1942
>  65536        12.64 |  19287        26.95 |   8835        57.30 |   3535
> 131072        12.64 |  38824        26.95 |  17900        58.58 |   7747
> 262144        12.66 |  77610        26.95 |  35743        66.31 |  13801
>
> OPEN QUESTION:
> --------------
>
> The best batch size depends on the hardware, and bigger isn't always bett=
er.
> NR_MAX_BATCHED_MIGRATION decides how many pages we move at once.
> Higher batch size can help amortize the setup cost of migrator but
> increases the first-folio latency (the folio is inaccessible for this
> window).

Yes.  This is an important parameter for the batched migration.  We
really need more information from people who have workload information
to make a decision.  Can you try to reach them?

Also, can we find a sweet point where we can archive higher throughput
without increasing latency too much (e.g., < 1ms)?

> Goals could be workload dependent, e.g. higher throughput versus
> same throughput under a bounded latency.
>
> Should this be tunable to accommodate different hardware and goals?

[snip]

---
Best Regards,
Huang, Ying

