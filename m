Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF66CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC4B6B0005; Wed, 27 May 2026 01:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD6F6B008A; Wed, 27 May 2026 01:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BF26B008C; Wed, 27 May 2026 01:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4607D6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:36:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6B031401D5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:36:18 +0000 (UTC)
X-FDA: 84812089236.20.DD4E681
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17A9B100006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:36:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lerc1n1X;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779860177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLJ6b9yM21+MjXix7K5zrKSrk018p30gsVTzb1+Fwio=;
	b=uoWr5rWUrHD0kwkIEckfzLbC0X0w8d+qR6Bera75Idht57J+5isbPL2n1EurG0zR4wB5WB
	DGSGdRby+WfQ8QIcK3/TNSmwW12VRqiikyy4N0lvKzOfyvyRn/bSg6QmJq96FSZ5LP43GA
	XCLvc2MZ/r3zQPxhLvZTyS1b0yHLBDw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lerc1n1X;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779860177; a=rsa-sha256;
	cv=none;
	b=EEbfi9N1XUMKJP04Nb/3i1XE0Vf/hSR80u98pDa8ua3tJiFIBfhgp2dxZLg8oQ29hnXrEn
	7YE8qJ7dW+p3s+MiLVMMQmrTnh8/pxVUKEYL+97su+5CcvpFUNxQfIhndNcxG6zgjt9mt1
	DPCnj46nOk/fPbjIrrPqoASMr9Zjn4o=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c80170db7d6so4501234a12.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 22:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779860176; x=1780464976; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cLJ6b9yM21+MjXix7K5zrKSrk018p30gsVTzb1+Fwio=;
        b=Lerc1n1XQGmrphbIdvYNV4UMu3bODWCggL0XKDwswhgLwM3KIPreYptOOgGecJ+9Vo
         HJ2uBU77CjkxxMWwWRk0CuNfFdE/ZGc8wS1r0l35wBlZAANjnQSC6r5K60SvuW9JwhfM
         MVmTlVHFOjZhr3YU6kLCV617ls6CaCCSpwKnoZQbYZWDkGqFmpHxNxA6UVNDcroTB0oM
         oBtjdQ2MWXRx0t/Fsqcif3A+5QWhm60UBG32cE71KawYxoHNMNypz7lC/4kWmbSh16gL
         uVw057BQSVpoCfQbfCnfQjc0LVV4yhJa9mdDkyP/I1FXx3Nj6w8qy9Ktpic7gQuccMzZ
         LG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779860176; x=1780464976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLJ6b9yM21+MjXix7K5zrKSrk018p30gsVTzb1+Fwio=;
        b=m8/X6MhUqmkvJXQdBYI9dtJnqA0ZYO6de693n3bWFfgVx57oxASSAqW48Hnb9jtdOI
         fuczZi+GEjzJ9fRJzt4z80scUMxrkv6e1LLaZUMgZeOkaSdY7Z5RkPFaNtrtp/xc3Sg5
         k/hhOSZnrl/YDkylbrxaDZs0x+y9fSRApkZloy5YYWFnk7m9K88BuXmlB/UO7Nwk91Au
         PL2yDr04i1eUreJGbLDML8QM4he68aCL/qN8ULxSNlL7YMveqlG4oEq4CcBHQC5rjOD5
         yKWGCJ0e9raHolPqaos61oraF2zpjqrX3HWdWtUoL+nMOZhZYPE4INf7NZzelO8u3+IJ
         PhwQ==
X-Forwarded-Encrypted: i=1; AFNElJ939fGrRKJRKG3+Hst8IJWyAf3uJkTdks+eIuXdJ9dehS3AHmBoP30ZPxFMJb4e0C6Lvd6FH/xfMQ==@kvack.org
X-Gm-Message-State: AOJu0YyX03EdMEcSclcvUAeVfwbq8QrdmvQvDlsHVJaxvXDKHLNx3VyA
	VWn+GDtKK5TFN4w/CJDo+mgZFIZdJtqpwe5xSZGUl9c7WfmaRiLqFhHB
X-Gm-Gg: Acq92OE0PiBL8m15FKeTWFmh3yIEKIt1FxSmI+3i/DPTSGEHUM4gN58ggUY6Bhea32b
	tZ3zG/u5WXNT2I98w2gUrR7TccPluC9Xg+9nbJXqGBBzUO1Ex86Hq9ydJZUWk00gAyOulusODrX
	TKTUF+W10LlwiqK0Rs2R2OVrd4h4tzY4tK31kOigStXL0vmpuPmdklD6ODCSIjcIlyiVmTMiszB
	+Fohx+S7nnqN81jW9x1oLmJ8YymSNmN4Rt8bIKSI7pZ4Ou+AuMlJtDA2UavQ2Sk8tdvEUew0MhY
	ouxY671gB3qcqoTW2UDAeYBkyYA5n4a7DN/xavIFqXNvLIwOayp6XfDhEKS9etjX0mS7yIeZLFC
	LxdgHxK3Qrqu5LYHGnFAXjie1M8+DKzm2d8yJUOgXljCXyrIgeYLxvhIFNki6G9Z0eS8EeUFqAg
	ruHL6HD+IO1ev92/r/sTCqK//YI6q384XB+JVM7CMONWOf3mj0TCk2nuTk1Qm7Fz3bPVKyb5wBg
	uhv8/s=
X-Received: by 2002:a05:6a21:7105:b0:3af:cff3:b347 with SMTP id adf61e73a8af0-3b3293ab333mr21369088637.36.1779860175627;
        Tue, 26 May 2026 22:36:15 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852054dad7sm11586337a12.17.2026.05.26.22.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 22:36:14 -0700 (PDT)
Date: Wed, 27 May 2026 13:36:06 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <ahaCaP3b0ojBtCsR@KASONG-MC4>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <agH7qYcyFgRzkQDB@linux.dev>
 <CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
 <agK-rkIIZlwBiMsv@linux.dev>
 <20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
X-Stat-Signature: wg5g6r913d67ahpujoyzon8hbwe6ntri
X-Rspamd-Queue-Id: 17A9B100006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779860176-574143
X-HE-Meta: U2FsdGVkX1+qQ8J3r0kQZi0PR+hkcYwKblOEwsY0QBijPy2zzuCZVKVO20O0mkliyMtEETTRfewyGKWfPZn0VT/N5HLNtxm0JVstSSijOkIqJwGxvt7NT0A8UfLTHirukizpLnA13A/wpk3KRz+yepwZwnZrL6+2Km+iUPVpOC9ehUmBSNzCha2aUKYBLiw5iikcAdPVY/1D9xBCG7dNFsW7zyK/Cw8O7iWHQvhsA+GqHp/kFNFdZv6Kw3eHVNQCfTves3fS9/fvPngw3l+lKoPd7QobwvvYRTX1nLXYR5j3w3XlxR9Y/5ME4tKsTzt+GwFnHR8fRTM1a/qj0bS/+dQdrNS1yzF3jPteHSIUhjMNLzwoGOhP5kzMpXfieGWdl86OUKp1vhLzR4rRsWi70KzBzetVHfmGjrI/QAzT1QU8N0rMUwO2Tj/tWDEq7qVQ0nVRuIWOyNNOPYIuJgVB6yOVdF6YmBHgF7TrY+BE8fvVTSeE7X7Z7disJHdW4i0w+QCPYnTMVgJpF4YPNdYO4UnF3PgqlwNz0NhX0nn0lsRoxmA3mx0GfNmjhaHFeHlhBkpUsAKdjzDguoiZ6pmQjCxKd2Q40NM8/Ls0moZvcNu584NJzM4Tb008vJTG4RFdr+V5Ha1SstzRmUhMmTRvouoBFInXquc6vzx0QL0lhYVJXnZOk8BIkTuSZT/gvoVwi+bj8+a3wZwuNd6fQz3Rw1i0i2o5YWx2JIpsJSvnLRG89/uqRRAc/wPBKhpqyW3PIB5BxLPJjnA2tY4GHXJRU7CL427VmiSfziZWLPqC3SS25lCkEEn/vDJz7YHNWdK6JeSwNsfpJUBeH+UTyWqCr1n4NJ28gv40UJfYYeVjhR7DRrOcU78znPKfGyqZBzbACqotQ/8RLDLOjYrP0dfXDyiNIDR6KhqlW7UdFE/X+pOuxf8BGECtAf6nAIPZYTb/7N2rkeeQb4tUm2+CGHJ
 IiUYQHce
 AT8u9DtyqHzlVM1MN02yzwFzmf/mS7mZdUmpfhO4IPnMEDK2EqHJndXWpSqtaqS3GYojpl2HY7WP1CehV7IQI++Ba/I7r0+SXKRn9wHC1W4Nt1jGlWPMShQJddOH0o5mRftwyLSsyuwda77DNmBjuV0+Hod/4XduPMJfv1fbymdgfqh9qgo/vTDEbIDa9b3gCrzAQYhqZqKVl3vHXL0WvgklcbEvr0qSVWUT/9ehapmqTi12/IRo0SzKxY7YfvQ+dpplRoMNIjsEx89N6Zq//6Vh2k0X7qabCwgr54Xvr6Ljop6Q21gUBBZvqFI+1oR8S5dLicZAkIstHs1HfyaJx0Sv2es1kuVvYF+DVFTjbJ9iwrm0i+F6+Lxzgb45eQhsHRbO7DH2uHTW1IE8QayX251LI5rIiSSqli5p4p/YcVsfAK5FJhScT/apor6XkftWnyXfUa+ZYkdmDT/jBfBLlmV49sdTy5m7dJFfBi44x6d6ZR5QuHOI9EGkruw4lendUV0fZKDbOOXNIsT9JiDWCSjf4EuiBVoSTJR23/fQ8qJIDm8+iaNIE7ICnYINyed9L58SlmJPZvuFuBQfBM/2yZtmu/ueSdD6Pc1Zb+mYGr6XgDuzHXQu1SGMIoYbJvidpeFYDKpsxhddUl7ehX1TeplVHC4ykL59LwGP5LmvklL+nGgSRzEs/t6QD01rlmYLE+Z0tRKwFx8dTZA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:35:06PM +0800, Andrew Morton wrote:
> On Mon, 11 May 2026 22:56:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > No worries, we have couple of weeks before the next merge window, so no urgency.
> 
> Well, no, not really.  Some schmuck wants to get our
> stable-non-rebasing branch into upstreamable shape well before the next
> merge window.
> 
> This series was issued a month ago!
> 
> Sorry to crack the whip, but let's please all be aware or our
> upstreaming timing.
> 
> > I will go through the series in depth, hopefully there will not be a need for
> > next version and in that case, please just resend the cover letter with the
> > information you provided below and don't worry about the length of the cover
> > letter.
> 
> That's a plan.
> 
> Happily, MGRLU changes are well-isolated so I was able to trivially
> move this series to the tail of mm-unstable.
> 
> It isn't a problem at all for me to defer this until the next cycle -
> please let me know.
> 
> I'd like to know this as early as possible so I can hide the series
> until after -rc1.  We shouldn't have "not for next merge window"
> material in there possibly invalidating our ongoing testing.

Hi Andrew,

From my side I didn't see any major reason to block this. There has
been plenty of review and the series has been tested many times. I
also re-ran with more rounds, with CLRU baseline, and the numbers
are very close to what was already posted.

The CLRU baseline can be useful as a reference. CLRU is unaffected by
this series as we don't touch it, and the comparison data Shakeel
asked for is on lore alongside the patch link. For that reason
I originally did not think a refreshed cover letter was strictly
needed.

But anyway, looking forward to Shakeel's review, and here is an
updated cover letter folding in the additions. There is not
much change: refreshed numbers, an "MGLRU disabled" (classical LRU)
row added to each benchmark, a short note on why each benchmark is
used, and three extra Link: tags. No code changes:

From: Kairui Song <kasong@tencent.com>

This series cleans up and slightly improves MGLRU's reclaim loop and dirty
writeback handling.  As a result, we can see an up to ~30% increase in
some workloads like MongoDB with YCSB and a huge decrease in file refault,
no swap involved.  Other common benchmarks have no regression, and LOC is
reduced, with less unexpected OOM, too.

Some of the problems were found in our production environment, and others
were mostly exposed while stress testing during the development of the
LSM/MM/BPF topic on improving MGLRU [1].  This series cleans up the code
base and fixes several performance issues, preparing for further work.

MGLRU's reclaim loop is a bit complex, and hence these problems are
somehow related to each other.  The aging, scan number calculation, and
reclaim loop are coupled together, and the dirty folio handling logic is
quite different, making the reclaim loop hard to follow and the dirty
flush ineffective.

This series slightly cleans up and improves these issues using a scan
budget by calculating the number of folios to scan at the beginning of the
loop, and decouples aging from the reclaim calculation helpers.  Then,
move the dirty flush logic inside the reclaim loop so it can kick in more
effectively.  These issues are somehow related, and this series handles
them and improves MGLRU reclaim in many ways.

Test results: All tests are done on a 48c96t NUMA machine with 2 nodes and
a 128G memory machine using NVME as storage.  Classical (non-MGLRU) LRU
numbers are included as "MGLRU disabled" for each benchmark below; see
[8] and [9] for the longer write-up.

MongoDB
=======
Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
threads:32), which does 95% read and 5% update to generate mixed read and
dirty writeback.  MongoDB is set up in a 10G cgroup using Docker, and the
WiredTiger cache size is set to 4.5G, using NVME as storage.  This is
close to the case we observed regressing in our production environment:
mixed read and writeback pressure, so it is a practical case for
evaluation.

Not using SWAP.  The intent is to isolate the file LRU writeback path.
Enabling SWAP would just add noise from anonymous reclaim.

MGLRU Before:
Throughput(ops/sec): 60653.502655
workingset_refault_file 12904916
pgpgin 165366622
pgpgout 5219588

MGLRU After:
Throughput(ops/sec): 82384.354760 (+35.8%, higher is better)
workingset_refault_file 7128285   (-44.7%, lower is better)
pgpgin 113170693                  (-31.5%, lower is better)
pgpgout 5639724

MGLRU Disabled:
Throughput(ops/sec): 93713.640901
workingset_refault_file 15013443
pgpgin 85365614
pgpgout 5866508

We can see a significant performance improvement after this series.  The
test is done on NVME and the performance gap would be even larger for slow
devices, such as HDD or network storage.  We observed over 100% gain for
some workloads with slow IO.

Note, classical LRU is still faster for this benchmark, MGLRU may catch
up later with further work [7].

Chrome & Node.js [3]
====================
Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
workers.  Many memcgs each applying roughly equal pressure exercises the
LRU's ability to detect/protect each tenant's working set and to balance
reclamation fairly between tenants, which makes this a meaningful test
for the reclaim mechanism.

Fairness is reported via Jain's fairness index (1.0 means all tenants get
exactly equal allocation, lower is worse). Under equal pressure, all
memcgs should make roughly equal forward progress.  See [8] for the
longer rationale and per-memcg breakdown.

MGLRU before:
Total requests:           81898
Per-worker mean:         1279.7
Per-worker 95% CI (mean):       [  1259.0,   1300.4]
Jain's fairness index: 0.995893  (1.0 = perfectly fair)
Latency:
      Bucket     Count      Pct    Cumul
      [0,1)s     28392   34.67%   34.67%
      [1,2)s      8022    9.80%   44.46%
      [2,4)s      6130    7.48%   51.95%
      [4,8)s     39354   48.05%  100.00%

MGLRU after:
Total requests:           82901
Per-worker mean:         1295.3
Per-worker 95% CI (mean):       [  1265.3,   1325.4]
Jain's fairness index: 0.991607  (1.0 = perfectly fair)
Latency:
      Bucket     Count      Pct    Cumul
      [0,1)s     28128   33.93%   33.93%
      [1,2)s      8756   10.56%   44.49%
      [2,4)s      7028    8.48%   52.97%
      [4,8)s     38989   47.03%  100.00%

MGLRU disabled:
Total requests:           62399
Per-worker mean:          975.0
Per-worker 95% CI (mean):       [   941.9,   1008.1]
Jain's fairness index: 0.982156  (1.0 = perfectly fair)
Latency:
      Bucket     Count      Pct    Cumul
      [0,1)s     20051   32.13%   32.13%
      [1,2)s      2255    3.61%   35.75%
      [2,4)s      6149    9.85%   45.60%
      [4,8)s     33927   54.37%   99.97%
     [8,16)s        17    0.03%  100.00%

Reclaim is still fair and effective, total requests number seems
slightly better.

OOM issue with aging and throttling
===================================
For the throttling OOM issue, it can be easily reproduced using dd and
cgroup limit as demonstrated and fixed by a later patch in this series.

The aging OOM is a bit tricky, a specific reproducer can be used to
simulate what we encountered in production environment [4]: Spawns
multiple workers that keep reading the given file using mmap, and pauses
for 120ms after one file read batch.  It also spawns another set of
workers that keep allocating and freeing a given size of anonymous memory.
The total memory size exceeds the memory limit (eg.  14G anon + 8G file,
which is 22G vs a 16G memcg limit).

- MGLRU disabled:
  Finished 128 iterations.

- MGLRU enabled:
  OOM with following info after about ~10-20 iterations:
    [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
    [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24460
    [   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
    [   62.640823] Memory cgroup stats for /demo:
    [   62.641017] anon 10604879872
    [   62.641941] file 6574858240

  OOM occurs despite there being still evictable file folios.

- MGLRU enabled after this series:
  Finished 128 iterations.

Worth noting there is another OOM related issue reported in V1 of this
series, which is tested and looking OK now [5].

MySQL:
======

Testing with innodb_buffer_pool_size=26106127360, in a 2G memcg, using
ZRAM as swap and test command:

sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=sb \
  --tables=48 --table-size=2000000 --threads=48 --time=600 run

A 24G InnoDB buffer pool inside a 2G memcg with ZRAM as swap forces
aggressive eviction of cached database anon pages, which exercises the
LRU's hot page detection and the eviction path under swap pressure.  The
workload is practical, and the pressure is higher than what we usually
see in production but it is intended to expose the extreme case.

MGLRU before:   17313.688333 tps
MGLRU after:    17286.195000 tps
MGLRU disabled: 16245.330000 tps

Seems only noise level changes, no regression.

FIO:
====
Testing with the following command, where /mnt/ramdisk is a 64G EXT4
ramdisk, each test file is 3G, in a 10G memcg, 6 test run each:

fio --directory=/mnt/ramdisk --filename_format='test.$jobnum.img' \
  --name=cached --numjobs=16 --size=3072M --buffered=1 --ioengine=mmap \
  --rw=randread --norandommap --time_based \
  --ramp_time=1m --runtime=5m --group_reporting

Random buffered mmap read on a ramdisk strips out storage variance and
stresses purely the LRU's ability to evict and recycle the page cache
under heavy random read pressure.

MGLRU before:      9033.91 MB/s
MGLRU after:       9065.72 MB/s
MGLRU disabled:    8254.54 MB/s

Also seem only noise level changes and no regression or slightly better.

Build kernel:
=============
Build kernel test using ZRAM as swap, kernel source on tmpfs, in a memcg
with memory.max=3G, using make -j96 and defconfig, measuring system time,
6 test run each.  Building the kernel is a classical mixed anon + file
workload (lots of small file reads/writes plus parallel anon allocations
from cc/ld) and is representative of many real compilation jobs.

MGLRU before:     2823.13s
MGLRU after:      2801.26s
MGLRU disabled:   5023.50s

Also seem only noise level changes, no regression or very slightly better.

Android:
========
Xinyu reported a performance gain on Android, too, with this series.  The
test consisted of cold-starting multiple applications sequentially under
moderate system load [6]; this is a real Android user-visible scenario,
dominated by the LRU's ability to keep the right working set resident
and re-fault launch-critical pages quickly.

Before:
Launch Time Summary (all apps, all runs)
  Mean 868.0ms
  P50 888.0ms
  P90 1274.2ms
  P95 1399.0ms

After:
Launch Time Summary (all apps, all runs)
  Mean 850.5ms (-2.07%)
  P50 861.5ms  (-3.04%)
  P90 1179.0ms (-8.05%)
  P95 1228.0ms (-12.2%)

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com
Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-1-02fabb92dc43@tencent.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb [2]
Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/ [3]
Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [4]
Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]
Link: https://lore.kernel.org/linux-mm/20260417025123.2971253-1-wxy2009nrrr@163.com/ [6]
Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/ [7]
Link: https://lore.kernel.org/linux-mm/CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com/ [8]
Link: https://lore.kernel.org/linux-mm/CAMgjq7D+4QmiWe73OPFuH0s+ZKCUJoo+MfcWOdJcV+VO-T2Wmg@mail.gmail.com/ [9]

