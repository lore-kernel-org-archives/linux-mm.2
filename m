Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE30CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A41E6B0147; Fri,  8 May 2026 07:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1559B6B0148; Fri,  8 May 2026 07:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BB76B0149; Fri,  8 May 2026 07:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E891B6B0147
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:29:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1C01A08B0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:29:08 +0000 (UTC)
X-FDA: 84744031176.18.B6AA85E
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C9A8C0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:29:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KwQ2f9oJ;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778239747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqCelfOJlt6r/lw4wZWiqyGU+r2itL3NtxrGfJxpY/k=;
	b=Jl9xe2hNPlGKFBzYWUZM5hyrNHDhtOFflFk3BqdEKWY86tfa+74uYRk+lmmB/46wzMN41r
	fNdOmXtZ8Dq3dzCvyK9kHH0ykOgf51c4oup9hVgXDv2b6pgXkXKqnSi9aK1B38Su0x/mi3
	MIscfkbpWjTMetuSplw8FUVVIMC0MFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778239747; a=rsa-sha256;
	cv=none;
	b=VgmGEEd94QyAyPE/qyZYYPNcgEI5iGm9cyvpJfujs1FQXoTlgsO2to1CUE5KT5nRF2aX5U
	HZOBYg+E0o+idewiaDzpGqVCXLWZHG28FYCK7Z2Hbxdx1iilVW8sqa9Umqdgu3LSa9mOvL
	+a3oz9TLpNSqCo7JatvjHC8AtOVicPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KwQ2f9oJ;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778239740; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=tqCelfOJlt6r/lw4wZWiqyGU+r2itL3NtxrGfJxpY/k=;
	b=KwQ2f9oJ4cwnu9aPN5TUHFw8mxM4qTSPchmcmnzCRn9p2NGbiI2iGR14t9dM8Juqthio4LLRzwfcgwqe7m2hN6FV1/pwddPcnYF54DGZMnjktegH9BLk8hbw2WIHXAJ7zc4+Ym6bpw6EUqrf0uXbat1stKYQUw52HUPN9imGOK4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2XLfiQ_1778239728;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2XLfiQ_1778239728 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 19:28:58 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  kinseyho@google.com,
  weixugc@google.com,  ljs@kernel.org,  Liam.Howlett@oracle.com,
  vbabka@kernel.org,  willy@infradead.org,  rppt@kernel.org,
  surenb@google.com,  mhocko@suse.com,  ziy@nvidia.com,
  matthew.brost@intel.com,  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,
  byungchul@sk.com,  gourry@gourry.net,  apopple@nvidia.com,
  dave@stgolabs.net,  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,
  vkoul@kernel.org,  bharata@amd.com,  sj@kernel.org,  rientjes@google.com,
  xuezhengchu@huawei.com,  yiannis@zptcorp.com,  dave.hansen@intel.com,
  hannes@cmpxchg.org,  jhubbard@nvidia.com,  peterx@redhat.com,
  riel@surriel.com,  shakeel.butt@linux.dev,  stalexan@redhat.com,
  tj@kernel.org,  nifan.cxl@gmail.com,  jic23@kernel.org,
  aneesh.kumar@kernel.org,  nathan.lynch@amd.com,  Frank.li@nxp.com,
  djbw@kernel.org,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com> (Shivank Garg's
	message of "Fri, 8 May 2026 16:34:22 +0530")
References: <20260428155043.39251-2-shivankg@amd.com>
	<87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
	<152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
Date: Fri, 08 May 2026 19:28:47 +0800
Message-ID: <87mryaqgwg.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C9A8C0002
X-Stat-Signature: r3pckwuyreeem5bhk1y7mp5si57mr57g
X-Rspam-User: 
X-HE-Tag: 1778239745-400041
X-HE-Meta: U2FsdGVkX1/H2D/ZRFhC+Tdp7teov10lV5pSMKoy0FDk1jVEt/xykXXxCxbh1yD1O0my2JTMC+odqLnJNqpC+8pkjMmNgJd7t4h0zBW6xAAR357TZpDJcRZjoSirIlPZvCbfuEqunXL3WtfwLYaAQ6wDZb9mxTXQQBHMOkHUPFNsQLq9I04QpWeCM/Hs3Id1bBXu8gWtPwcyBI6UqfcxvO277Y8eQzklAw1h+yFxttYL2RoFUMqMF9H4QScfFYRWapOcBWhjKjlUcfvm9Z2rAwT3IvH4lfL84V7c1QFnUYLyv+zzuCsC6aXHE6K2isnJrQtqltnmEB9yV/IH7BtDtjPWMa5rHV5PJDz58RbwZ7oMY0xlSjVCcAxbIzjFSeGygzu8bt8Z4XtGZsXExIwdLK1a/rfntFtnaLAhGkJ5sEKuZeyltOTyZ60JZN6Ra5mmqNjNBhye6PoNPhzSO76/UQF/orAuqyKVYjk5CBICxg3Gl5Xv8vw06WE1g1sBcgOHyTxiqWuFm9hItJJJZ5O3Gh7sG7W1vp9b/QHM93zA1HVf4Li/8EYVkk7pd0rszyTmmLJGUR/usjY2jtp6K8asiIOn9fOwX64OamFBL3+o2u13owDrKfcPY38tIXgaojhheONbEQ2TD35lw7BngUW6s23kfCmyktKNLmNa2QWT1DDdN95r8fyXonzYxLMixMka1AXe6i/20HVOvm7zG7ngczokdViNwIxjS0IaqegEdmEJxyclyu56CyOcwMQ8dvzAY9hBZbp1ibELp/bVg+jxhk2mAUt93TWvKzhBo0/+QdsQxHOC1YNBM4W5JKCHNJpBIE/MoiRVw/Gtc25vzlYIBC6oZvEByHMKc00LbVkLQAWGVnoczjNwtIkTvGRi+I8pOoLsvegLKxRofThw+IuSHJHdReDm/fUROxvIvef2xHMzk3Xxlj2gqi2BirgrmXwjT16UL+8wpHMUXByZ809
 6+uIuL6B
 1UCn3XSHbWrlFCsw0nXBCh8zVWCTql1v2gFwnYjC1vAi3w+sGCvibdNjxeXMszxD9Ky7x0vZVvN1q2vsEQlXuDWUrmMPcBRjULzXZ2yZBMmE9b3ggww+uv5R/dQ6umQNw8SnYjAKNfzqJ7stM1Dd4Dcj+TzBSQNzGJkoJhG1gMSIgVYnVJo4WmkFV9VWL9X6rOz8xb4o1UjGsgeQreejW7VgOkRbVgh76/4eUyuQGwAcwxhNF7uYOYFw9HxBUGr+P295zTx7qHqOgcVNiZ8OktR/44eytM1zh4x6jHJks/Wdm8K07VDIJRghX4qXKAa5pDCpHTVKMihptXiEmkfa/Zn7Vq50ZUH0ae1a9wbm5OWcYOS1OVebaUYHrDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Shivank,

"Garg, Shivank" <shivankg@amd.com> writes:

> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>
>>> PERFORMANCE RESULTS:
>>> --------------------
>>>
>>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>>> change in V5 alters this picture; please refer to the V4 cover letter
>>> for the throughput tables [1].
>>=20
>> IMHO, it's better to copy performance data here.
>>=20
>> In addition to the performance benefit, I want to know the downside as
>> well.  For example, the migration latency of the first folio may be
>> longer.  If so, by how much?  Can you measure the batch number vs. total
>> migration time (benefit) and first folio migration time (downside)?
>> That can be used to determine the optimal batch number.
>>=20
>
> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
> 1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hardware.
>
> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>
> 1). Moving different sized folios such that total transfer size is consta=
nt
> (1GB), with different number of DMA channels. Throughput in GB/s.
>
> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
>
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
> 3.31=C2=B10.18   | 5.61=C2=B10.07  | 6.66=C2=B10.03  | 7.01=C2=B10.03  | =
7.13=C2=B10.08   | 11.02=C2=B10.17  |
>
>
> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
>
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
> 1      | 2.16=C2=B10.14   | 2.58=C2=B10.02   | 3.00=C2=B10.04   | 4.56=C2=
=B10.28   | 4.62=C2=B10.02   | 12.65=C2=B10.08  |
> 2      | 2.68=C2=B10.09   | 3.69=C2=B10.15   | 4.52=C2=B10.04   | 6.75=C2=
=B10.06   | 7.19=C2=B10.19   | 14.38=C2=B10.06  |
> 4      | 3.07=C2=B10.13   | 4.62=C2=B10.09   | 6.47=C2=B10.56   | 9.22=C2=
=B10.15   | 10.24=C2=B10.47  | 27.01=C2=B10.11  |
> 8      | 3.43=C2=B10.09   | 5.40=C2=B10.16   | 7.67=C2=B10.08   | 11.25=
=C2=B10.17  | 12.60=C2=B10.60  | 45.62=C2=B10.52  |
> 12     | 3.50=C2=B10.11   | 5.66=C2=B10.16   | 8.12=C2=B10.10   | 11.97=
=C2=B10.19  | 13.43=C2=B10.08  | 61.02=C2=B10.92  |
> 16     | 3.54=C2=B10.12   | 5.79=C2=B10.14   | 8.50=C2=B10.13   | 12.59=
=C2=B10.15  | 17.21=C2=B16.40  | 65.23=C2=B11.70  |
>
>
> 2).  First-folio latency: Instrumented with custom tracepoints to measure=
 latency per migrate_pages_batch() call.
>     Result: throughput (GB/s) and first-folio latency (in microseconds), =
median of 10 runs.

Thanks for detailed data.  Per my understanding, the run time of
migrate_pages_batch() may be not good enough for measuring first folio
latency.  IIUC, the migration procedure is something like,

  for each folio
        unmap
  flush
  for each folio
        copy
        remap =3D=3D=3D> first folio migrated

Some tracepoint should be better to measure it.

> A). Vanilla Kernel:
>
> Here, n =3D workload size passed to move_pages() in folios. Move n number=
 of folios with move_pages().
> NR_MAX_BATCHED_MIGRATION is upstream default value 512.
>
> --- Order 0 (4K folios) ---
>      n      vanilla/cpu
> (folios)    GB/s | first(us)
> --------------------------
>      1       0.04 |     24
>      4       0.16 |     25
>      8       0.29 |     31
>     16       0.54 |     27
>     64       1.15 |     68
>    256       1.86 |    162
>    512       2.21 |    264
>   2048       2.62 |    208
>   4096       2.74 |    182
>  16384       2.73 |    173
>  65536       3.28 |    166
> 262144       3.20 |    167
>
> --- Order 9 (2M folios) ---
>      n      vanilla/cpu
> (folios)    GB/s | first(us)
> --------------------------
>      1       7.05 |    194
>      4       8.78 |    186
>      8       8.47 |    188
>     16       7.20 |    193
>     64       8.23 |    191
>    256      10.51 |    180
>    512      10.88 |    173
>
> Takeaway:
> In each migrate_pages_batch() call, folios are first unmapped, then try_t=
o_unmap_flush(),
> and only then folios enter move_to_new_folio(). So first-folio latency is=
 bounded by the
> per-batch unmap+flush cost, and then plateaus once workload is large enou=
gh.
>
>
> B). Patched kernel:
>
> Here, N =3D NR_MAX_BATCHED_MIGRATION (in page). Total migrated data is fi=
xed at 1 GB.

Emm, so NR_MAX_BATCHED_MIGRATION could be very large?  I think that it
needs to be bounded.  If it is too large, too many pages may be in an
inaccessible state for a longer time.  That will hurt the workload
performance, although it is optimal for migration performance.

> Change N with a knob to measure impact of different max batched size.
>
> --- ORDER 0 (4K folios) ---
>      N         offload/dma1          offload/dma4          offload/dma16
>                GB/s | first(us)      GB/s | first(us)      GB/s | first(u=
s)
> ------------------------------------------------------------------------
>    512         2.13 |    639         3.23 |    290         3.27 |    253
>   1024         2.17 |   1261         3.44 |    582         3.58 |    536
>   2048         2.01 |   2769         3.09 |   1360         3.45 |   1083
>   4096         2.10 |   5059         3.13 |   2737         3.58 |   2115=
=20
>   8192         2.21 |   9320         3.17 |   5015         3.75 |   3617=
=20
>  16384         2.15 |  18689         3.31 |   9623         3.87 |   6937
>  32768         2.12 |  42692         3.38 |  18893         3.83 |  14255
>  65536         2.09 |  81956         3.38 |  38556         3.64 |  29003
> 131072         2.02 | 169563         3.22 |  81082         3.63 |  62236
> 262144         2.21 | 318424         3.12 | 170174         3.50 | 129413
>
> --- ORDER 9 (2M folios) ---
>      N         offload/dma1          offload/dma4          offload/dma16
>                GB/s | first(us)      GB/s | first(us)      GB/s | first(u=
s)
> -------------------------------------------------------------------------
>    512         11.66 |    160        11.68 |    160        11.65 |    160
>   1024         12.16 |    310        13.67 |    275        13.64 |    276
>   2048         12.30 |    613        25.47 |    290        25.48 |    291
>   4096         12.48 |   1215        26.19 |    566        42.59 |    335
>   8192         12.56 |   2424        26.57 |   1118        58.72 |    470=
 *
>  16384         12.61 |   4839        26.77 |   2218        61.94 |    896
>  32768         12.60 |   9667        26.98 |   4422        63.75 |   1748
>  65536         12.63 |  19318        26.99 |   8838        60.66 |   3543
> 131072         12.64 |  38935        27.02 |  17935        61.06 |   7178
> 262144         12.66 |  77694        26.85 |  35871        65.06 |  14129
>
> In the batch-copy offload approach, DMA copy phase is inserted between un=
map/flush and move,
> So larger N increases first-folio wall clock latency. Throughput improves=
 but with diminishing
> returns.
>
> For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=3D819=
2-16384,
> because a larger batch allows the driver to distribute more folios across=
 available DMA channels.
> This is where we get most throughput while keeping the first folio latenc=
y in check.
>
> This optimal batch value is hardware-specific. Other engines (eg. SDXI) a=
nd memory tier (eg. CXL)
> will likely have different curves.
>
> Does this approach and experiment look good to you?

---
Best Regards,
Huang, Ying

