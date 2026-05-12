Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75579CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB096B0088; Mon, 11 May 2026 22:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C436B008A; Mon, 11 May 2026 22:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B1C6B008C; Mon, 11 May 2026 22:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40BB56B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:15:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2DDE1C0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:15:38 +0000 (UTC)
X-FDA: 84757151556.20.B94E5F9
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6CCAA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:15:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SLjWCvVq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778552136; a=rsa-sha256;
	cv=none;
	b=julqa5YJsDC0sHDcEOx6A3LXagTilWNRIRmjGJhdBQAhDgtRxMIVSlBUQVfojX5jCXMdxR
	ItJ0g4RaON2kNxyiMYh0NSSVv7p/90XaXNx9e52WwFdboGpqX5gp/AAwto79ZDlCYEzdY2
	uiE0nEr+0fh+H0lru8ol9QwJZbyp1aQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SLjWCvVq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778552136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x589uaHNb+WI54NKbeo3IlZRhBFZ8rhkOgGZ83wZkJU=;
	b=QT0xBMhWoGKup1pTeac5ozCUDePjFuxpYODWLReHLhlpdYhZPCVw9qqtsunQFb8nabjuTt
	4sWkL4D1mtKFOiyRJr/G8tApHZ1t6KEsGMLUEWy5O12Wt/x6ESN4v3ESyc5SYOXBg9LJFz
	GVi2JsQlg+erWp9NAARSgeHtIaWc+4g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778552131; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=x589uaHNb+WI54NKbeo3IlZRhBFZ8rhkOgGZ83wZkJU=;
	b=SLjWCvVq9fkEgfKoSPtXwhDojDnBxZU8ZnbQ25GoVHlw0wA9TNxTIt1EXqA6BiHlkJI9PedTkGUI41N0UkVKz8DOViNB+gE4OcpMv7VrmeQBYnCDZ6kS51VIel3oHhPY8urlcb2o7z8A/RdVxN+jEE4bFVt4LQnNpOR6s5101BM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2olcqX_1778552127;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2olcqX_1778552127 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 10:15:29 +0800
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
In-Reply-To: <22157c87-1465-46de-8e1c-5d99a90152a6@amd.com> (Shivank Garg's
	message of "Sun, 10 May 2026 20:33:47 +0530")
References: <20260428155043.39251-2-shivankg@amd.com>
	<87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
	<152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
	<87mryaqgwg.fsf@DESKTOP-5N7EMDA>
	<c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com>
	<87cxz5rpi3.fsf@DESKTOP-5N7EMDA>
	<22157c87-1465-46de-8e1c-5d99a90152a6@amd.com>
Date: Tue, 12 May 2026 10:15:27 +0800
Message-ID: <87a4u5weyo.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1i1gbzf6wa8jz96qed8ywouqy3ze55w8
X-Rspam-User: 
X-Rspamd-Queue-Id: D6CCAA0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778552134-925679
X-HE-Meta: U2FsdGVkX19tnWjaQCinBFjcLyOjgvR0qvdXaP/8vn6dNfJ6DfYBb+QNzwrNEG0hqyCp73s62YsCAR73SlAjmHpexoX7GWu3Z1FwliJou5PZh1yGQvYMCYGbzLnnKPZmdrVH6laOJmzCukV1Mj5gHpgrH45AU2GFle4QQbtPbwDPfZef1GRAkXsE0fX4mR+EclOs/9nQTjhaonZYhyFe2krmIhb+a3/7klFLpd1pY0dbYE7D2EHtiFyEIvaFnJHxzMEnwhznayoz8LvYtIEubYOWanmb4WCEHmIfAEfeBpfv52YK4Opq9Ho8kS9d9iCd8/ZE1L82tDxmCH6weqlrlP4bpH2wTwIlKuPCnotsUMdW8Gf9spJXjX6hbRJUgUbnymir1MJEp/URb8FvlexIpC+HECC+1UvxkUqopllAIzt5ybZayBHJ5ItLI8ZOTFHVBaOp90bp9/c02aaV7P70DBlETdkIM5Ifutenk70N89lqfIj3vbyMo8tw8+dpLvLlJxwfvgJVOMYK7IkdWgPD70KHSL7h60DQqAVGWu0t0xl5skx+NpnvhrFBss39+i+LiFNYolZPR9gmG9YEqG7cx1tqSXm0uTi/+vCx+ZAXAbMyoftbXZbzlN8k4hOjEKYR/quG19A9nxShAaV9O8k2LOOqbiWKG0CtmgXMOh+fthaX+FtqZFcmXzTypSUXUGX/d1zpHPBo6ncJSBBNINXRltJ4DB+Iv+tokAhrOFE7ErNKNTsubAnQvxKavhzSlfZu/rd6y9AuNzsp34X4g4VBsDLGgQoukmhg3XML8tLnFeq/efYKhhoYyFnQeZe7lpw/Wk84KfRuX2zLYTwhpGY46OCgP0pUEh+xVOINBnIhPxOSCu+N3He7/c/SXVjOF9ZFozxo2ByK0mxfE5Cs2frvKpZDM5G/qH7b02O80KgpnM5xENmdeUSlevPDMVA46JfhoXDfwWMEqs3DmuxYGcU
 XWyTSKZ9
 cJPTFT7VNOB12lpaK5XkjI2/wSTgN6U5wdggBRiobeHdbGffB/E33KMB5TovzWnRauuI+EqiszzSVV+G2qgS3WiUlDWeoLG3Ev2hhPQCcYrKjJ11hHF682eQK3h3utw5tZid8QIe8G+ifUVeJAHe6H3Az0XQYi3xfEOsXUpoeuDaUBkx6jcL6tFDCFKDCsSb/pA1MT/lybVFubnakNTpX9wVjNnjOickbs1DcXGa+Ag5rzgzPF5SZfS1rQN9X/CDJ502IAaCoZqOopjZjeM78nuG/PybmF2NWWA0ezVbWgrBwyL2PmM/jG7UGSp1ggnHCTRqn8JCawgjgOg90unv3kqYN8HrzLRHRCCsj2RmfVUHnXeVkUM4M3SWR/O1uQ5mtmt7lgF40T+WojeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

> On 5/9/2026 1:19 PM, Huang, Ying wrote:
>> "Garg, Shivank" <shivankg@amd.com> writes:
>>=20
>>> On 5/8/2026 4:58 PM, Huang, Ying wrote:
>>>> Hi, Shivank,
>>>>
>>>> "Garg, Shivank" <shivankg@amd.com> writes:
>>>>
>>>>> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>>>>>> Shivank Garg <shivankg@amd.com> writes:
>>>>>
>>>>>>> PERFORMANCE RESULTS:
>>>>>>> --------------------
>>>>>>>
>>>>>>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>>>>>>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>>>>>>> change in V5 alters this picture; please refer to the V4 cover lett=
er
>>>>>>> for the throughput tables [1].
>>>>>>
>>>>>> IMHO, it's better to copy performance data here.
>>>>>>
>>>>>> In addition to the performance benefit, I want to know the downside =
as
>>>>>> well.  For example, the migration latency of the first folio may be
>>>>>> longer.  If so, by how much?  Can you measure the batch number vs. t=
otal
>>>>>> migration time (benefit) and first folio migration time (downside)?
>>>>>> That can be used to determine the optimal batch number.
>>>>>>
>>>>>
>>>>> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
>>>>> 1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hard=
ware.
>>>>>
>>>>> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>>>>>
>>>>> 1). Moving different sized folios such that total transfer size is co=
nstant
>>>>> (1GB), with different number of DMA channels. Throughput in GB/s.
>>>>>
>>>>> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
>>>>>
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>>>> 4K          | 16K        | 64K        | 256K       | 1M          | 2M=
          |
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>>>> 3.31=C2=B10.18   | 5.61=C2=B10.07  | 6.66=C2=B10.03  | 7.01=C2=B10.03=
  | 7.13=C2=B10.08   | 11.02=C2=B10.17  |
>>>>>
>>>>>
>>>>> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
>>>>>
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> N channel| 4K        | 16K         | 64K         | 256K        | 1M  =
        | 2M          |
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> 1      | 2.16=C2=B10.14   | 2.58=C2=B10.02   | 3.00=C2=B10.04   | 4.5=
6=C2=B10.28   | 4.62=C2=B10.02   | 12.65=C2=B10.08  |
>>>>> 2      | 2.68=C2=B10.09   | 3.69=C2=B10.15   | 4.52=C2=B10.04   | 6.7=
5=C2=B10.06   | 7.19=C2=B10.19   | 14.38=C2=B10.06  |
>>>>> 4      | 3.07=C2=B10.13   | 4.62=C2=B10.09   | 6.47=C2=B10.56   | 9.2=
2=C2=B10.15   | 10.24=C2=B10.47  | 27.01=C2=B10.11  |
>>>>> 8      | 3.43=C2=B10.09   | 5.40=C2=B10.16   | 7.67=C2=B10.08   | 11.=
25=C2=B10.17  | 12.60=C2=B10.60  | 45.62=C2=B10.52  |
>>>>> 12     | 3.50=C2=B10.11   | 5.66=C2=B10.16   | 8.12=C2=B10.10   | 11.=
97=C2=B10.19  | 13.43=C2=B10.08  | 61.02=C2=B10.92  |
>>>>> 16     | 3.54=C2=B10.12   | 5.79=C2=B10.14   | 8.50=C2=B10.13   | 12.=
59=C2=B10.15  | 17.21=C2=B16.40  | 65.23=C2=B11.70  |
>>>>>
>>>>>
>>>>> 2).  First-folio latency: Instrumented with custom tracepoints to
>>>>> measure latency per migrate_pages_batch() call.
>>>>>     Result: throughput (GB/s) and first-folio latency (in microsecond=
s), median of 10 runs.
>>>>
>>>> Thanks for detailed data.  Per my understanding, the run time of
>>>> migrate_pages_batch() may be not good enough for measuring first folio
>>>> latency.  IIUC, the migration procedure is something like,
>>>>
>>>>   for each folio
>>>>         unmap
>>>>   flush
>>>>   for each folio
>>>>         copy
>>>>         remap =3D=3D=3D> first folio migrated
>>>>
>>>> Some tracepoint should be better to measure it.
>>>
>>> Sorry, my earlier write-up was unclear.
>>> For first folio latency, I add two tracepoints: one at the start of mig=
rate_pages_batch()
>>> and one in migrate_folio_done().=20
>>>
>>> I agree that the user-accessible point tracepoint should be right after=
 remove_migration_ptes().
>>> Though, migrate_folio_done() runs only a few operations later, and will=
 have a constant
>>> offset, so it's unlikely to change the shape of the trade-off curve.
>>> I'll move the tracepoint right after remove_migration_ptes() for new po=
sting.
>>=20
>> Thanks for explanation.  Trace point in migrate_folio_done() should be O=
K.
>>=20
>>>>
>>>>> A). Vanilla Kernel:
>>>>>
>>>>> Here, n =3D workload size passed to move_pages() in folios. Move n nu=
mber of folios with move_pages().
>>>>> NR_MAX_BATCHED_MIGRATION is upstream default value 512.
>>>>>
>>>>> --- Order 0 (4K folios) ---
>>>>>      n      vanilla/cpu
>>>>> (folios)    GB/s | first(us)
>>>>> --------------------------
>>>>>      1       0.04 |     24
>>>>>      4       0.16 |     25
>>>>>      8       0.29 |     31
>>>>>     16       0.54 |     27
>>>>>     64       1.15 |     68
>>>>>    256       1.86 |    162
>>>>>    512       2.21 |    264
>>>>>   2048       2.62 |    208
>>>>>   4096       2.74 |    182
>>>>>  16384       2.73 |    173
>>>>>  65536       3.28 |    166
>>>>> 262144       3.20 |    167
>>>>>
>>>>> --- Order 9 (2M folios) ---
>>>>>      n      vanilla/cpu
>>>>> (folios)    GB/s | first(us)
>>>>> --------------------------
>>>>>      1       7.05 |    194
>>>>>      4       8.78 |    186
>>>>>      8       8.47 |    188
>>>>>     16       7.20 |    193
>>>>>     64       8.23 |    191
>>>>>    256      10.51 |    180
>>>>>    512      10.88 |    173
>>>>>
>>>>> Takeaway:
>>>>> In each migrate_pages_batch() call, folios are first unmapped, then t=
ry_to_unmap_flush(),
>>>>> and only then folios enter move_to_new_folio(). So first-folio latenc=
y is bounded by the
>>>>> per-batch unmap+flush cost, and then plateaus once workload is large =
enough.
>>>>>
>>>>>
>>>>> B). Patched kernel:
>>>>>
>>>>> Here, N =3D NR_MAX_BATCHED_MIGRATION (in page). Total migrated data i=
s fixed at 1 GB.
>>>>
>>>> Emm, so NR_MAX_BATCHED_MIGRATION could be very large?  I think that it
>>>> needs to be bounded.  If it is too large, too many pages may be in an
>>>> inaccessible state for a longer time.  That will hurt the workload
>>>> performance, although it is optimal for migration performance.
>>>>
>>>
>>> Agreed, it must be bounded.
>>=20
>> Thanks!  Could you retest with bounded NR_MAX_BATCHED_MIGRATION.  If the
>> upstream default doesn't work well for you.  We can find a better one
>> that balances throughput and latency well.
>>=20
>
> Thanks. Below tables sweep NR_MAX_BATCHED_MIGRATION from 512 up to 262144=
. On 2M folios,
> 16-channel PTDMA, the knee is at N=3D8192-16384 (=3D {16 to 32} * 512 ).
>
>>>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |   =
 470 *

        2048         12.30 |    613        25.47 |    290        25.48 |   =
 291

IIUC, N=3D2048 already helps dma4.  And, the latency looks OK too.  The
good batch size is hardware configuration dependent too?  If so, we may
need to add another migrator callback for that.

> One thing worth flagging on the "bounded default": at the upstream cap of=
 512 pages,
> migrate_pages_batch() receives at most one 2M folio per call, so PTDMA ca=
n only use
> one of its 16 channels per batch and the offload reduces to vanilla. (DCB=
M offloads
> one 2M folio to each channel).
> The larger-N rows are what exercise the channel parallelism for PTDMA cas=
e.
>
> "SDXI"[1] like memory-to-memory data movers should reach good throughput =
with just 1 channel,=20
> and thus may not require increasing the NR_MAX_BATCHED_MIGRATION for good=
 throughput.
>
> I'm not tying series this to specific perf default for now, the design re=
view (batch-copy
> path, migrator interface, registration, static_call dispatch) is the part=
 I'd like to converge
> on first, then tune the threshold after it. Does that ordering work?

IMHO, we need some performance data to justify the added complexity.
So, threshold tuning isn't the goal, whether we can get better
throughput with some bounded latency is.

> [1] https://lore.kernel.org/all/20260410-sdxi-base-v1-0-1d184cb5c60a@amd.=
com
>
> Best regards,
> Shivank
>
>>>>> Change N with a knob to measure impact of different max batched size.
>>>>>
>>>>> --- ORDER 0 (4K folios) ---
>>>>>      N         offload/dma1          offload/dma4          offload/dm=
a16
>>>>>                GB/s | first(us)      GB/s | first(us)      GB/s | fir=
st(us)
>>>>> ---------------------------------------------------------------------=
---
>>>>>    512         2.13 |    639         3.23 |    290         3.27 |    =
253
>>>>>   1024         2.17 |   1261         3.44 |    582         3.58 |    =
536
>>>>>   2048         2.01 |   2769         3.09 |   1360         3.45 |   1=
083
>>>>>   4096         2.10 |   5059         3.13 |   2737         3.58 |   2=
115=20
>>>>>   8192         2.21 |   9320         3.17 |   5015         3.75 |   3=
617=20
>>>>>  16384         2.15 |  18689         3.31 |   9623         3.87 |   6=
937
>>>>>  32768         2.12 |  42692         3.38 |  18893         3.83 |  14=
255
>>>>>  65536         2.09 |  81956         3.38 |  38556         3.64 |  29=
003
>>>>> 131072         2.02 | 169563         3.22 |  81082         3.63 |  62=
236
>>>>> 262144         2.21 | 318424         3.12 | 170174         3.50 | 129=
413
>>>>>
>>>>> --- ORDER 9 (2M folios) ---
>>>>>      N         offload/dma1          offload/dma4          offload/dm=
a16
>>>>>                GB/s | first(us)      GB/s | first(us)      GB/s | fir=
st(us)
>>>>> ---------------------------------------------------------------------=
----
>>>>>    512         11.66 |    160        11.68 |    160        11.65 |   =
 160
>>>>>   1024         12.16 |    310        13.67 |    275        13.64 |   =
 276
>>>>>   2048         12.30 |    613        25.47 |    290        25.48 |   =
 291
>>>>>   4096         12.48 |   1215        26.19 |    566        42.59 |   =
 335
>>>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |   =
 470 *
>>>>>  16384         12.61 |   4839        26.77 |   2218        61.94 |   =
 896
>>>>>  32768         12.60 |   9667        26.98 |   4422        63.75 |   =
1748
>>>>>  65536         12.63 |  19318        26.99 |   8838        60.66 |   =
3543
>>>>> 131072         12.64 |  38935        27.02 |  17935        61.06 |   =
7178
>>>>> 262144         12.66 |  77694        26.85 |  35871        65.06 |  1=
4129
>>>>>
>>>>> In the batch-copy offload approach, DMA copy phase is inserted betwee=
n unmap/flush and move,
>>>>> So larger N increases first-folio wall clock latency. Throughput impr=
oves but with diminishing
>>>>> returns.
>>>>>
>>>>> For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=
=3D8192-16384,
>>>>> because a larger batch allows the driver to distribute more folios ac=
ross available DMA channels.
>>>>> This is where we get most throughput while keeping the first folio la=
tency in check.
>>>>>
>>>>> This optimal batch value is hardware-specific. Other engines (eg. SDX=
I) and memory tier (eg. CXL)
>>>>> will likely have different curves.
>>>>>
>>>>> Does this approach and experiment look good to you?
>>=20

---
Best Regards,
Huang, Ying

