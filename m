Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70389CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 07:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D496B0300; Sat,  9 May 2026 03:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7A26B0301; Sat,  9 May 2026 03:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F146B0302; Sat,  9 May 2026 03:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 616DE6B0300
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:50:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9C9DC1F76
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:50:22 +0000 (UTC)
X-FDA: 84747108684.30.1B5D7FA
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf06.hostedemail.com (Postfix) with ESMTP id E92E8180004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:50:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yY3DlLcS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778313021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=og2YnmuyeOWIYjCeR6b0Icao3q7h85tzyg8TQlVWZ6Y=;
	b=QQApORNpb0KzK8Ymr/wpAIwOMqrgDfLMvSLpiKQv4q/3nBbUKfLadP8piR/HAjTfSP884K
	dW200NT7VxE+iMZSYj6QBN9IfMcVcOU/TOjSeXLlsqOmW2y40F06JR04lHaI373r/ENPqm
	pjTZfJGoqfA43WSDRr7FlJA8QqeGKg4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778313021; a=rsa-sha256;
	cv=none;
	b=voRcVYXaEd0JqYRYky4aX/uBgt8sL+51CQc4CC2wWLFp3hIEwqYf+0b2bkQoJz4BJhbZSe
	s9iOm4WNF7Ojxn7Neat0Z0tN3yqs7qHc9n0QMhIRXPv5TPUpW8pNA+oRIthXRUjR/IglEN
	1aXmqQSyj75I+sPRo3bCj4W7IQNxkic=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yY3DlLcS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778313015; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=og2YnmuyeOWIYjCeR6b0Icao3q7h85tzyg8TQlVWZ6Y=;
	b=yY3DlLcSWMXMTgmHyB/ZnIl2wMloXap8TPXCTOHtmEgHeVXvPOJDrgLbjoO67fH0PhA6KDx52knI2nR3wZRbT1Y9BPU+pko+bKnSNGcuCBDdnLpjWhCkjso0vHRfa1EzLAbRygPMkEWj67GnJJj2ivHdgXiDeL3S6ATaOOdHH4A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2Zv8Qc_1778312997;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2Zv8Qc_1778312997 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 09 May 2026 15:50:11 +0800
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
In-Reply-To: <c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com> (Shivank Garg's
	message of "Fri, 8 May 2026 18:04:34 +0530")
References: <20260428155043.39251-2-shivankg@amd.com>
	<87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
	<152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
	<87mryaqgwg.fsf@DESKTOP-5N7EMDA>
	<c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com>
Date: Sat, 09 May 2026 15:49:56 +0800
Message-ID: <87cxz5rpi3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E92E8180004
X-Rspamd-Server: rspam04
X-Stat-Signature: 8gditupddktdwa9kuf37neurm1cdo43x
X-HE-Tag: 1778313018-748228
X-HE-Meta: U2FsdGVkX1/ZsQCXR0BZUiDZmhzjwnjD5/yDucRzhyd5IAMR+/OW77oAZvN/ungr2M4LKsyDJ46tf4b+5eMmOKcts9ZkDLCZwVSjpsUUX2bl6RnCXK3DA1EiqgqHUjmgDHogMw3rWFZxeX8vn15O14vKA6VLD/7TahSZwNa1c8JZ6rlRAkDp6MjFEKKDrAWM5P9aUhbLoE4d+2A9nPiYhLqSbgcrfi9K7zh1xA0u5cbNyxuXbZNbz73kdjRhzCVPpvVR5Xi16lnRw/VdS87xdueRC88JXF2150RSXzyNU/tvspUt5bfGX7H2BNRNFwKdaFfyiDcfuTevSK/J17qRJ99HGsRurYkCMlAZtorIlBht8c03scmUUpUgLiHGH0k06BxgnBWj5ahBdhmq0YCYn6MRFAS08EsIeDnaRvB2QgqMYSc2HN0LYcgA9ef8DPFcX13q44Htknh6Vgt7jWNEyDJjsgR/98AnBeiTTqtOHBsEZPlgI3EzN+hcrswbe+LDZKNzfRJoHVJJ6FLvoaqOjqAJOk1pr8FHvc0NpSWUsFSSbHVqjN8NIjx8hlQSxC7bV2yXFeHNJxW2MtZkkQq/HecU55k3aAD4vZkqvQxWGyG0bzDWN7F8j+cGTes4kkKLUC/RVENDCZyZ4e/Lgozb2QEaxnwiAt0g2W39Skghasybur7+fGkXWmU+4L0wB5+N+abQ72j1+AUsJGWXx/UqEucrmxcWtm3DbACTJpgH1V2h+B3RMfkC4WbasV1mU/JiMrWmozaBZVbQajKQbaVfSWlFuzGGHaTZoI9N6j0dgNIiS0ay/KZrBc2qjVtJf+NPwrotHT+uN/Z7OedbWhnblJLRgiNnUq8C6/Fj9iK10LhN0vllAbNPia9WoWV04VNBVaUTn3SXTaC56LL+w42PU+NZlMUpLrCEvF6Mzz3Y7h4SaCssH2MvdYNdc73vsi78LMNtugSr08yN88zeIp+
 sasB+9KF
 +M4owiD0Mx34UVtQ7FhMZLlBWx5Rqf6ZmotE5wlYROw0mKH9skwOSqRgLvmXFJazh5fgXUUFaHD1vGalgWMeezlvmL/HDjKfWcF5n620AQ2isfC28gIl9vArtLesUjcR1KvtZXrZRh/ghZaY3F1QUvSSAkLF4+W/NiaLf1PGqT2IkRjE7YdwT1zH7K5ILz+ir793HCHSnAUXAwWa9CTJ3U3w8MUsec99OOeQVRdFpSWQ0iKrlAOQNVs7qVdSptPAuwXNsKlfxiXS9GHAUBVjLJD3aePfTGbMAsKICUNsJU8NCwVNZWpCICVtACEcCLHz/R+2Ic9beqvlDbmjfLNJowV9ywfg+U1OmEV6FXvG1/yz/JfGwRI2BnipixA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

> On 5/8/2026 4:58 PM, Huang, Ying wrote:
>> Hi, Shivank,
>>=20
>> "Garg, Shivank" <shivankg@amd.com> writes:
>>=20
>>> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>>>> Shivank Garg <shivankg@amd.com> writes:
>>>
>>>>> PERFORMANCE RESULTS:
>>>>> --------------------
>>>>>
>>>>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>>>>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>>>>> change in V5 alters this picture; please refer to the V4 cover letter
>>>>> for the throughput tables [1].
>>>>
>>>> IMHO, it's better to copy performance data here.
>>>>
>>>> In addition to the performance benefit, I want to know the downside as
>>>> well.  For example, the migration latency of the first folio may be
>>>> longer.  If so, by how much?  Can you measure the batch number vs. tot=
al
>>>> migration time (benefit) and first folio migration time (downside)?
>>>> That can be used to determine the optimal batch number.
>>>>
>>>
>>> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
>>> 1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hardwa=
re.
>>>
>>> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>>>
>>> 1). Moving different sized folios such that total transfer size is cons=
tant
>>> (1GB), with different number of DMA channels. Throughput in GB/s.
>>>
>>> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
>>>
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>> 4K          | 16K        | 64K        | 256K       | 1M          | 2M  =
        |
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>> 3.31=C2=B10.18   | 5.61=C2=B10.07  | 6.66=C2=B10.03  | 7.01=C2=B10.03  =
| 7.13=C2=B10.08   | 11.02=C2=B10.17  |
>>>
>>>
>>> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
>>>
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> N channel| 4K        | 16K         | 64K         | 256K        | 1M    =
      | 2M          |
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> 1      | 2.16=C2=B10.14   | 2.58=C2=B10.02   | 3.00=C2=B10.04   | 4.56=
=C2=B10.28   | 4.62=C2=B10.02   | 12.65=C2=B10.08  |
>>> 2      | 2.68=C2=B10.09   | 3.69=C2=B10.15   | 4.52=C2=B10.04   | 6.75=
=C2=B10.06   | 7.19=C2=B10.19   | 14.38=C2=B10.06  |
>>> 4      | 3.07=C2=B10.13   | 4.62=C2=B10.09   | 6.47=C2=B10.56   | 9.22=
=C2=B10.15   | 10.24=C2=B10.47  | 27.01=C2=B10.11  |
>>> 8      | 3.43=C2=B10.09   | 5.40=C2=B10.16   | 7.67=C2=B10.08   | 11.25=
=C2=B10.17  | 12.60=C2=B10.60  | 45.62=C2=B10.52  |
>>> 12     | 3.50=C2=B10.11   | 5.66=C2=B10.16   | 8.12=C2=B10.10   | 11.97=
=C2=B10.19  | 13.43=C2=B10.08  | 61.02=C2=B10.92  |
>>> 16     | 3.54=C2=B10.12   | 5.79=C2=B10.14   | 8.50=C2=B10.13   | 12.59=
=C2=B10.15  | 17.21=C2=B16.40  | 65.23=C2=B11.70  |
>>>
>>>
>>> 2).  First-folio latency: Instrumented with custom tracepoints to
>>> measure latency per migrate_pages_batch() call.
>>>     Result: throughput (GB/s) and first-folio latency (in microseconds)=
, median of 10 runs.
>>=20
>> Thanks for detailed data.  Per my understanding, the run time of
>> migrate_pages_batch() may be not good enough for measuring first folio
>> latency.  IIUC, the migration procedure is something like,
>>=20
>>   for each folio
>>         unmap
>>   flush
>>   for each folio
>>         copy
>>         remap =3D=3D=3D> first folio migrated
>>=20
>> Some tracepoint should be better to measure it.
>
> Sorry, my earlier write-up was unclear.
> For first folio latency, I add two tracepoints: one at the start of migra=
te_pages_batch()
> and one in migrate_folio_done().=20
>
> I agree that the user-accessible point tracepoint should be right after r=
emove_migration_ptes().
> Though, migrate_folio_done() runs only a few operations later, and will h=
ave a constant
> offset, so it's unlikely to change the shape of the trade-off curve.
> I'll move the tracepoint right after remove_migration_ptes() for new post=
ing.

Thanks for explanation.  Trace point in migrate_folio_done() should be OK.

>>=20
>>> A). Vanilla Kernel:
>>>
>>> Here, n =3D workload size passed to move_pages() in folios. Move n numb=
er of folios with move_pages().
>>> NR_MAX_BATCHED_MIGRATION is upstream default value 512.
>>>
>>> --- Order 0 (4K folios) ---
>>>      n      vanilla/cpu
>>> (folios)    GB/s | first(us)
>>> --------------------------
>>>      1       0.04 |     24
>>>      4       0.16 |     25
>>>      8       0.29 |     31
>>>     16       0.54 |     27
>>>     64       1.15 |     68
>>>    256       1.86 |    162
>>>    512       2.21 |    264
>>>   2048       2.62 |    208
>>>   4096       2.74 |    182
>>>  16384       2.73 |    173
>>>  65536       3.28 |    166
>>> 262144       3.20 |    167
>>>
>>> --- Order 9 (2M folios) ---
>>>      n      vanilla/cpu
>>> (folios)    GB/s | first(us)
>>> --------------------------
>>>      1       7.05 |    194
>>>      4       8.78 |    186
>>>      8       8.47 |    188
>>>     16       7.20 |    193
>>>     64       8.23 |    191
>>>    256      10.51 |    180
>>>    512      10.88 |    173
>>>
>>> Takeaway:
>>> In each migrate_pages_batch() call, folios are first unmapped, then try=
_to_unmap_flush(),
>>> and only then folios enter move_to_new_folio(). So first-folio latency =
is bounded by the
>>> per-batch unmap+flush cost, and then plateaus once workload is large en=
ough.
>>>
>>>
>>> B). Patched kernel:
>>>
>>> Here, N =3D NR_MAX_BATCHED_MIGRATION (in page). Total migrated data is =
fixed at 1 GB.
>>=20
>> Emm, so NR_MAX_BATCHED_MIGRATION could be very large?  I think that it
>> needs to be bounded.  If it is too large, too many pages may be in an
>> inaccessible state for a longer time.  That will hurt the workload
>> performance, although it is optimal for migration performance.
>>=20
>
> Agreed, it must be bounded.

Thanks!  Could you retest with bounded NR_MAX_BATCHED_MIGRATION.  If the
upstream default doesn't work well for you.  We can find a better one
that balances throughput and latency well.

>>> Change N with a knob to measure impact of different max batched size.
>>>
>>> --- ORDER 0 (4K folios) ---
>>>      N         offload/dma1          offload/dma4          offload/dma16
>>>                GB/s | first(us)      GB/s | first(us)      GB/s | first=
(us)
>>> ------------------------------------------------------------------------
>>>    512         2.13 |    639         3.23 |    290         3.27 |    253
>>>   1024         2.17 |   1261         3.44 |    582         3.58 |    536
>>>   2048         2.01 |   2769         3.09 |   1360         3.45 |   1083
>>>   4096         2.10 |   5059         3.13 |   2737         3.58 |   211=
5=20
>>>   8192         2.21 |   9320         3.17 |   5015         3.75 |   361=
7=20
>>>  16384         2.15 |  18689         3.31 |   9623         3.87 |   6937
>>>  32768         2.12 |  42692         3.38 |  18893         3.83 |  14255
>>>  65536         2.09 |  81956         3.38 |  38556         3.64 |  29003
>>> 131072         2.02 | 169563         3.22 |  81082         3.63 |  62236
>>> 262144         2.21 | 318424         3.12 | 170174         3.50 | 129413
>>>
>>> --- ORDER 9 (2M folios) ---
>>>      N         offload/dma1          offload/dma4          offload/dma16
>>>                GB/s | first(us)      GB/s | first(us)      GB/s | first=
(us)
>>> -----------------------------------------------------------------------=
--
>>>    512         11.66 |    160        11.68 |    160        11.65 |    1=
60
>>>   1024         12.16 |    310        13.67 |    275        13.64 |    2=
76
>>>   2048         12.30 |    613        25.47 |    290        25.48 |    2=
91
>>>   4096         12.48 |   1215        26.19 |    566        42.59 |    3=
35
>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |    4=
70 *
>>>  16384         12.61 |   4839        26.77 |   2218        61.94 |    8=
96
>>>  32768         12.60 |   9667        26.98 |   4422        63.75 |   17=
48
>>>  65536         12.63 |  19318        26.99 |   8838        60.66 |   35=
43
>>> 131072         12.64 |  38935        27.02 |  17935        61.06 |   71=
78
>>> 262144         12.66 |  77694        26.85 |  35871        65.06 |  141=
29
>>>
>>> In the batch-copy offload approach, DMA copy phase is inserted between =
unmap/flush and move,
>>> So larger N increases first-folio wall clock latency. Throughput improv=
es but with diminishing
>>> returns.
>>>
>>> For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=3D8=
192-16384,
>>> because a larger batch allows the driver to distribute more folios acro=
ss available DMA channels.
>>> This is where we get most throughput while keeping the first folio late=
ncy in check.
>>>
>>> This optimal batch value is hardware-specific. Other engines (eg. SDXI)=
 and memory tier (eg. CXL)
>>> will likely have different curves.
>>>
>>> Does this approach and experiment look good to you?

---
Best Regards,
Huang, Ying

