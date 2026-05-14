Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C941CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 18:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2B86B0005; Thu, 14 May 2026 14:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C4D6B0088; Thu, 14 May 2026 14:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C8D6B008A; Thu, 14 May 2026 14:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18D616B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:50:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 970C11401B2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:50:47 +0000 (UTC)
X-FDA: 84766916934.16.6410B09
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6084C40006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:50:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jdhJs3d9;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778784645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/OwFqVBmvwA5Q3NZqeMmnPyQd1KkmyRaKCgDtkDGnw=;
	b=7ofxyDXLkb46eyHMwt7BV8fDRUL64wy3NnKRoMrCe21KP0zaC2kBka5rv0fXvUzyzTHJ9L
	G55MsEdEDNS906O00e4BuxbAA32TdSNWJ3uS2OdyHAyUENnuNWe2SLlIb4VAVD9bzhiw++
	QT9kdhQ7A8RIOBgMXm2YxjI0xWO0PKI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778784645; a=rsa-sha256;
	cv=pass;
	b=6bK+5AcQhk8eVJYp/FlnT3sIhILkJ1GLceaRNM3nInPbhZ/9yMIFbC8QjJmnyTEtJk9icI
	O5yt7rXKQHDd5ugNDXqkeJo1YkIzoAq+Z184++PjqlcmAdnJ41ymJYwOQEIkl/4XILJY/o
	hzHNPNtDml12yALxGIaftZtyyklj6pc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jdhJs3d9;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67bc6098640so13661034a12.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 11:50:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778784643; cv=none;
        d=google.com; s=arc-20240605;
        b=MUbZkddwdyspmhIiSHgpfzWqrNiyXwI0m8D2pErcaTyvKEZmi7NhDp318opUrgypBw
         /y8K4MzLyvNfaFY6yJR6AFtJSDGPUW3NQGn35N7QIr25ncH+63XLL8pHHybj7Vg7gddp
         W9bUWqlpK8qGsseQ/XgzZ5lHwOAO6OdAu/GcTeebqruDZ4sbEDJRQlkHvnJtgKmKaq2R
         pSEVScTNCRyRojDvCvKSMXvyLdezXkJIqvajlrGuu7wvoCPcD4qXWeFXRsZVgEebjC9x
         TYWBEVv8k8BUcYs+uPXPDCWJM8RA90J/c0lwQplXup78skMpG1PrPZnoKxcnLttjTky6
         QmzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r/OwFqVBmvwA5Q3NZqeMmnPyQd1KkmyRaKCgDtkDGnw=;
        fh=mDDNARty5ma9b0Il+TG3M+t9hjM0vLH1LEsLCsyXYMc=;
        b=dTW3x5dCmyWu3yG3lQt2Nf8FaHvQxeS6ZUgeKTVBcYAhUq/Co+s1VhmjXtrPd4APUC
         1V0yvhvTcKtH12NnXLu4l9VlsFEKgX1/If+6FMtNO1abHPiFY1mvP5vANqHSELauvbrF
         sPNOMEAjQh2iWweQF3VCDkJFtf+uUutEfkM2mxKFwUHWwWFjZKw6Cxo9nL1A0TR5E7+y
         VbfpdTr5urVyecULtaUpWrDFqJhQD8i6lNoyNoTojISMligA+jtf4yDCb7djF8Iec5N0
         BMfe4d8nto8Q2canUhk24NJIqr+UfYY2psQio5o8vc0l6AQRr5uvcIdTHtntXuCXVxsa
         HuCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778784643; x=1779389443; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/OwFqVBmvwA5Q3NZqeMmnPyQd1KkmyRaKCgDtkDGnw=;
        b=jdhJs3d9TLxy4VhEt6wNBqkNuFVh5xNYNhgycvqwkFP3hoAdyIZ9cyZzsMaa6PdAAH
         UqMzsLdEdjxgJgPKMGJ1yzh1ANgFOC7AFuK/Jn/4tYEutK6Z7fA5WqcCtp3vcNMrZH6Z
         /L3TfvVAManJwbxjewcjiSNuU9q7GMZzeNPe/KAQd1kHTaWIzjnNuIbuB5Yj2q1kq0ai
         nEfICNN0N4NEdJ5+aHebahHql+1cQmPerRj9Qk272BRV6OGqCKjgpAqReUoKkULAtEmo
         0ViUM/tAOGws4ipAb5MspqJPeso+jqTqwliJoKFBQKJTgJOYt3MAUvW47t3AEFHVHi2n
         qRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778784643; x=1779389443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r/OwFqVBmvwA5Q3NZqeMmnPyQd1KkmyRaKCgDtkDGnw=;
        b=ByK3cM6hoeO1kOS/fxRPPURgv36SdGCqBHSxJ9ndsRiLiZb+wZw+SSgMkSnwT+MC4B
         F4M055wMq1k+WxCz0VSeZzcPj/SD+LdBq1tGzVNpxli5CEknyhsS1m5k4luglhW/mbHg
         A9XiYCNyr/SkU9J1cDwvbl35rzFNtjgqkmRZIdjpiHbw16TeTucEgAVCTUf8pHe/BO6B
         DSnXXM2uYdgtTo5EchU5xGYt8s+3Z0GyMVRr1CXpYa5OJmPuO1gn5LZ0Vx4D/KG3fi19
         9vRmGISWjWlnHyJVKlUrLy1bFuJMfuIlzKiixaxZxIKhZ9vAOI2wCluKB/8ODcxl6nfG
         AqfA==
X-Gm-Message-State: AOJu0YyskPpQeKPegsJ044KfEAY9fIT0D8oNGgO2AjnBZzTBxptwd0UZ
	GyjMi6P9uKHCaGTLjeqx6gYL8cBEEI/4+LmiqhUnCNNeB42uqqHefTfEXzl777BTeXyu8MPQBk9
	hmkcS/A024jWNe63jvZk6n6WEtVPruQ0a/KKOLJNL8g==
X-Gm-Gg: Acq92OF5dHoSSBou/EFv8y2LmQBnTl6S7H81uUqO8FCPcTt+IKyYu/kBrp1McNorhUp
	Hb7HFwVVMcWA8cIETpORveFFwFOrVHNJpxWEf2XlU3F8K6Dd+F6bDtZnsNFaIE9Hd+szdORE767
	sJEghKcT/2vmO+ZJ4qbnknV6VNIefMZVqkgiwsFCeUQPAy4eGMyJxwYBlXxbZPa5RWxwWiQB6xA
	E5kYHiR5MEAivGTt9Pl7LOhAgAJQnGI9BIPts12c3aC2RzS4gp02A/6j5tu0F4vGtAW9B09wou7
	g0Y6vY6KTzcw3zRopvRu10cHibs7h532NpoZ6Cgc
X-Received: by 2002:a17:907:e158:b0:ba5:3e3a:81ee with SMTP id
 a640c23a62f3a-bd517a98db2mr19416766b.39.1778784642942; Thu, 14 May 2026
 11:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 15 May 2026 02:50:05 +0800
X-Gm-Features: AVHnY4JgcpgEitMvOajf9_WOJH7EPRkMRz9w7L1YaVMc3eNh_GgloA2su9xYb-I
Message-ID: <CAMgjq7D+4QmiWe73OPFuH0s+ZKCUJoo+MfcWOdJcV+VO-T2Wmg@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio handling
To: linux-mm@kvack.org
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6084C40006
X-Stat-Signature: 5ta151wnhcdhf9i1hjncwuhwsjb6iahq
X-Rspam-User: 
X-HE-Tag: 1778784645-782444
X-HE-Meta: U2FsdGVkX1+ezEuQtX2S/GI420DSkm77rHlha313dlLwVM+gsn+9Y5y3aAtMfrZ4JjolXucUZHEAs90ypq4+bj5OJ0QLgeDQHozIHGKSsXQnGR5Z3sXCmLk+1WgL8hZyLua9FnEfD+zDurhx/f0MKXRisj0+a8kOyQn6KATtKup3PRZBvEw2pS7z+HPndSTSBVgOMbNwQ0jB/b01albghOWbmFoahQ7OqP+bvEInsT4ui8M5cT/BABR7IsR/Zm6oXJXaOTzXsl9aikVA7qr3XFFqwBdL89gSXmXbOqqrTeoPIVcROzIghsmf6Kv5EYErjS/sXkr5MBi5OnwvUlkrx4pbcZPEXKX1jAEVjdW9m8XcJ5h+3lgvmuykVnQoxPd0UBrp4sp/X9AdnETIgPYJ0BbGlltp/m28maXfKAQn/kvxJRy+ZtyRNMmbYyWJSG9F1ZtOzXLBxaldOiPlgzu4c5po08d614sYlI52lLXnkbRGL4iuLJJyq5rDyMdulppWesY3JkEG2jMqioG/vC4BNKWiFYBgCtJDDTDnFj1Z/eK7QrIXHu0D5XVQGg0A8tJ/vLdP4cU9gxtsYEv/nP5gchyVWooRcIdGgszBiqyU0Smr4zEeU+jPWJsOcdo91E1lm46t+hEzK6+nTXGTLcdtF1QaRrIkvPqViuoKibKyttWHWjd8LVmieK0W4cE/gr6ciQF6Fz1Z0w/d6P7TIJ5zpPKU1b35w+HK97agG2f/zEL/unApp4xlaX6679pZaImJLGrN5BQ2qz2RwnRVoyEcrCMHTIUycsEZCNX4SeYIC+qXohnmsT6+irbk8ZZUhq/2Nv3MGjWZNma53lpywFJRr2snb7jy+yeNti3BXlKd+RA+NGTpG0j/23zozrCZ89VYz58OMx5soPQHtuf3nmR8P1Ey8NzT+Wz30770qkMnm/WfKpBDgmlJAc46w5t4pJ2JQv8vSwKQJoksWsDS5De
 fOTeRwWE
 wzsKWbZu2UDbTREGgDRUe6ikYgqX2pdntgjmlYAtEMFWnDQWtoypFSCS5waAI0Aud5OPHvmnlm8EnHnvTCY7j1NVPaR/H1AykA2IM/f+X8dVDbFVIMabayvEmQe3wmImEa9TIZaQP00lfFogBA1pSYCgv/vgRuUfBpvRAx62R+BaSuqwGr/2dYHGHYzMy1j8y3BzN1fVQYgSty1mmWmDqivV5dfc8lBrN6no4moG5kNsoKedvlMfW68wiGc7Qz5UnpMQryGjLeCQ9MJTKiWPx435mkka6om03V8/e3orSbsPDvap03Pdgkrn6kJaH7UgQplImMv7VoBxWz3OuBnAd++51iXBYeunr2dcaRNZXqE2wZYbwiMJaMfZZa1WTQsELz2kOEPfupEbV6+eVCZqXKhzcJjkSx+MQEueZJbRSR2Kat3hpTik0pRZgJk8mxyrGyP4q0b2t84bNOUfSPmjQ3v4TQi/soQHHmchc7M2f7MNPmt+xTJoPgDEqSjwHCkVBUG7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 2:07=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.
>
> Some of the problems were found in our production environment, and
> others were mostly exposed while stress testing during the development
> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> the code base and fixes several performance issues, preparing for
> further work.
>
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective.
>
> This series slightly cleans up and improves these issues using a scan
> budget by calculating the number of folios to scan at the beginning of
> the loop, and decouples aging from the reclaim calculation helpers.
> Then, move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
>
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and a 128G memory machine using NVME as storage.

Hi All,

This is a supplementary test report and explaining why we are using
these cases. All tests below, unless explicitly declared otherwise,
are run at least six times, using the median result. Some tests are
also run against MGLRU-FG[1] as a reference. (MGLRU-FG is still under
development so the reading may change - hopefully for the better).

>
> MongoDB
> =3D=3D=3D=3D=3D=3D=3D
> Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> threads:32), which does 95% read and 5% update to generate mixed read
> and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> the WiredTiger cache size is set to 4.5G, using NVME as storage.

MongoDB with workloadb has mixed writeback and read pressure, which
tests the LRU's capability to handle writeback flushing while
protecting the workingset.

Using the same test setup, I retested everything with Classical LRU
included (which I will refer to as CLRU below, open to suggestions for
a better abbreviation :) ). I rebased it on top of the current 7.1 rc
with a clean test environment.

CLRU:
93713.640901 ops/sec
workingset_refault_file 15013443
pgpgin 85365614
pgpgout 5866508

MGLRU Before:
60653.502655 ops/sec
workingset_refault_file 12904916
pgpgin 165366622
pgpgout 5219588

MGLRU After:
82384.354760 ops/sec
workingset_refault_file 7128285
pgpgin 113170693
pgpgout 5639724

Before this series, MGLRU lagged CLRU by approximately 35% on this
workload. This is the case where MGLRU has historically struggled the
most. This series closes most of that gap (within ~13%), and
MGLRU-FG[1] will close the rest (within noise). The trajectory is
clear and the work is ongoing:

MGLRU-FG:
92930.697550 ops/sec
workingset_refault_file 10775748
pgpgin 98558215
pgpgout 5736764

It's very interesting that MGLRU-FG and CLRU both have a higher
workingset_refault_file, but lower pgpgin, I suspect this could be
related to the slab (inode) shrinking balance. I ran into the similar
issue before [2], which can be looked into later but I think that's
irrelevant to this series and we are definitely on the right track.

The test results above basically match the cover letter as well,
reading is a bit different due to different test environment which
isn't a issue, so I think there is no need to update that.

>
> Not using SWAP.
>
> Before:
> Throughput(ops/sec): 62485.02962831822
> AverageLatency(us): 500.9746963330107
> pgpgin 159347462
> pgpgout 5413332
> workingset_refault_anon 0
> workingset_refault_file 34522071
>
> After:
> Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> pgpgin 111093923                       (-30.3%, lower is better)
> pgpgout 5437456
> workingset_refault_anon 0
> workingset_refault_file 19566366       (-43.3%, lower is better)
>
> We can see a significant performance improvement after this series.
> The test is done on NVME and the performance gap would be even larger
> for slow devices, such as HDD or network storage. We observed over
> 100% gain for some workloads with slow IO.
>
> Chrome & Node.js [3]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> workers:
>
> Before:
> Total requests:            79915
> Per-worker 95% CI (mean):  [1233.9, 1263.5]
> Per-worker stdev:          59.2
> Jain's fairness:           0.997795 (1.0 =3D perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26859   33.61%   33.61%
> [1,2)s      7818    9.78%   43.39%
> [2,4)s      5532    6.92%   50.31%
> [4,8)s     39706   49.69%  100.00%
>
> After:
> Total requests:            81382
> Per-worker 95% CI (mean):  [1241.9, 1301.3]
> Per-worker stdev:          118.8
> Jain's fairness:           0.991480 (1.0 =3D perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26696   32.80%   32.80%
> [1,2)s      8745   10.75%   43.55%
> [2,4)s      6865    8.44%   51.98%
> [4,8)s     39076   48.02%  100.00%
>
> Reclaim is still fair and effective, total requests number seems
> slightly better.

Chrome & Node.js is very common workload for many users. Running these
workloads in different cgroups can apply equal pressure to all cgroups
under a global pressure, hence testing the LRU's ability to detect and
protect the working set, efficiency, and balance reclamation between
multiple tenants.

I'll post the summary of test result since the raw test result is way too l=
ong.

CLRU:
THROUGHPUT
Total requests:           62399
Per-worker mean:          975.0
Per-worker 95% CI (mean):       [   941.9,   1008.1]
LATENCY DISTRIBUTION (all workers aggregated)
      Bucket     Count      Pct    Cumul
      [0,1)s     20051   32.13%   32.13%
      [1,2)s      2255    3.61%   35.75%
      [2,4)s      6149    9.85%   45.60%
      [4,8)s     33927   54.37%   99.97%
     [8,16)s        17    0.03%  100.00%
FAIRNESS (per-worker total requests)
Jain's fairness index: 0.982156  (1.0 =3D perfectly fair)

MGLRU before:
THROUGHPUT
Total requests:           81898
Per-worker mean:         1279.7
Per-worker 95% CI (mean):       [  1259.0,   1300.4]
LATENCY DISTRIBUTION (all workers aggregated)
      Bucket     Count      Pct    Cumul
      [0,1)s     28392   34.67%   34.67%
      [1,2)s      8022    9.80%   44.46%
      [2,4)s      6130    7.48%   51.95%
      [4,8)s     39354   48.05%  100.00%
FAIRNESS (per-worker total requests)
Jain's fairness index: 0.995893  (1.0 =3D perfectly fair)

MGLRU after:
THROUGHPUT
Total requests:           82901
Per-worker mean:         1295.3
Per-worker 95% CI (mean):       [  1265.3,   1325.4]
LATENCY DISTRIBUTION (all workers aggregated)
      Bucket     Count      Pct    Cumul
      [0,1)s     28128   33.93%   33.93%
      [1,2)s      8756   10.56%   44.49%
      [2,4)s      7028    8.48%   52.97%
      [4,8)s     38989   47.03%  100.00%
FAIRNESS (per-worker total requests)
Jain's fairness index: 0.991607  (1.0 =3D perfectly fair)

In summary MGLRU performs very well, both before and after this
series, across throughput, latency, and fairness. I also tested
MGLRU-FG, which yielded similar results with a per-worker 95% CI
(mean) of [1275.5, 1333.9].

>
> OOM issue with aging and throttling
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> For the throttling OOM issue, it can be easily reproduced using dd and
> cgroup limit as demonstrated and fixed by a later patch in this series.

Skipping this one, aging/throttling OOM is an MGLRU-only issue, and
is fixed by this series.

>
> MySQL:
> =3D=3D=3D=3D=3D=3D
>
> Testing with innodb_buffer_pool_size=3D26106127360, in a 2G memcg, using
> ZRAM as swap and test command:
>
> sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=3Dsb \
>   --tables=3D48 --table-size=3D2000000 --threads=3D48 --time=3D600 run
>
> Before:            17303.41 tps
> After this series: 17291.50 tps
>

MySQL with sysbench is a standard database benchmark. The 24G InnoDB
buffer pool inside a 2G memory cgroup forces aggressive eviction of
cached database anon pages, testing the LRU's ability to identify hot
pages and the eviction path's efficiency under swap pressure.

Here is the retested result (average of 6 test run):

CLRU: 16245.330000 tps
MGLRU before: 17313.688333 tps
MGLRU after: 17286.195000 tps
MGLRU-FG: 17225.123333 tps

So MGLRU before/after/FG are all doing well with this one, ahead of
CLRU. It seems very slightly slower after this series, but this could
be noise, and I think it's fine to ignore. This series has no
noticeable effect on MGLRU for this kind of test.

>
> FIO:
> =3D=3D=3D=3D
> Testing with the following command, where /mnt/ramdisk is a
> 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> 6 test run each:
>
> fio --directory=3D/mnt/ramdisk --filename_format=3D'test.$jobnum.img' \
>   --name=3Dcached --numjobs=3D16 --size=3D3072M --buffered=3D1 --ioengine=
=3Dmmap \
>   --rw=3Drandread --norandommap --time_based \
>   --ramp_time=3D1m --runtime=3D5m --group_reporting
>
> Before:            8968.76 MB/s
> After this series: 8995.63 MB/s

Random buffered FIO read on a ramdisk basically tests the LRU's
ability to evict the page cache efficiently. Results (average of 6
test runs):
CLRU: 8254.540000 MB/s
MGLRU before: 9033.908333 MB/s
MGLRU after: 9065.725000 MB/s
MGLRU-FG: 9067.105000 MB/s

MGLRU before / after / FG are all doing very well on this one,

>
> Also seem only noise level changes and no regression or slightly better.
>
> Build kernel:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> using make -j96 and defconfig, measuring system time, 12 test run each.
>
> Before:            2873.52s
> After this series: 2811.88s

Build kernel test is a very classical test for us, many performance
test use this as a standard, it is a real workload and stands for many
compilation tasks.

I'll just post the system time for more direct comparision, following
the setup as describe in the cover letter:

CLRU: 2760.50user 5023.50system 1:51.89elapsed
MGLRU before: 2924.41user 2823.13system 1:28.09elapsed
MGLRU after: 2938.42user 2801.26system 1:28.10elapsed
MGLRU-FG: 2936.42user 2781.65system 1:27.84elapsed

MGLRU before / after / FG are all doing very well on this one,

Testing on disk instead using BTRFS with a 3G memcg:
CLRU:
real   1m51.325s
user   37m16.586s
sys    11m20.294s

MGLRU before:
real   1m49.649s
user   37m38.325s
sys    9m0.360s

MGLRU after:
real   1m49.223s
user   37m15.546s
sys    8m46.135s

MGLRU-FG:
real   1m49.908s
user   37m22.696s
sys    8m53.138s

Still, MGLRU before / after / FG are all doing very well.

>
> Also seem only noise level changes, no regression or very slightly better=
.
>
> Android:
> =3D=3D=3D=3D=3D=3D=3D=3D
> Xinyu reported a performance gain on Android, too, with this series. The
> test consisted of cold-starting multiple applications sequentially under
> moderate system load. [6]
>
> Before:
> Launch Time Summary (all apps, all runs)
>   Mean 868.0ms
>   P50 888.0ms
>   P90 1274.2ms
>   P95 1399.0ms
>
> After:
> Launch Time Summary (all apps, all runs)
>   Mean 850.5ms (-2.07%)
>   P50 861.5ms  (-3.04%)
>   P90 1179.0ms (-8.05%)
>   P95 1228.0ms (-12.2%)

I've seen many reports from Android that MGLRU provides better battery
life and my personal experience backporting this series on my phone is
quite positive :). I currently lack a standard environment for Android
testing because I don't have any Android vendor support so I'll have
to skip the comparison on this one. And I think Xinyu's original
numbers are good enough for this series. (I remember seeing community
reports and historical reports in LPC or LSF/MM/BPF all look good so
far).

I've also posted other tests previously that all show this series is
behaving correctly, but I don't think we should include all of them or
this will be rediculiously long:
https://lore.kernel.org/linux-mm/CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=3D2sydok0hFM=
=3DMYL7VC1YYg@mail.gmail.com/

=3D=3D=3D=3D=3D=3D

In summary, I think these tests make a lot of sense, and re-testing
with CLRU in a row indicates that MGLRU performs very well with this
series. In most cases MGLRU performs much better. MGLRU suffered the
most during the MongoDB writeback workload (YCSB workloadb), and that
is exactly what we are solving, and gap is closing with a clear plan.

I can fold the per-benchmark rationale sentences and CLRU baselines
into a re-freshed cover letter (no code changes), or should we just
add a link to this email instead? The existing cover letter is already
long and sufficiently supportive IMO, and the new test result matches
what we already have.

In any case, I think we are headed in the right direction.

Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@=
tencent.com/
[1]
Link: https://lore.kernel.org/linux-mm/CAMgjq7BsY1tJeOZwSppxUN7Lha-_a7WLfhv=
1_bxTuU4EuiQyVg@mail.gmail.com/[2]

