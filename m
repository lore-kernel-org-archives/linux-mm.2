Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666D2C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D806B008A; Fri, 28 Aug 2026 06:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375956B008C; Fri, 28 Aug 2026 06:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B0F6B0092; Fri, 28 Aug 2026 06:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E618A6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:26:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E876802B1
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:26:49 +0000 (UTC)
X-FDA: 85150299738.25.7714274
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1F5B580004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:26:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=efizeq25;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf30.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787912807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUv1RmQ2miGU/9mk3aHLymUw+hTO6Btwj2zASn4n3FU=;
	b=6k8z2ZWaveCKcURHDpl6KUCsBH89G+ib/I0NCk34SGQvJl0uaABDi+sMZJlzM/fLP8Ba6P
	1HVmezsdV5t4l/hknwoAy3QUvRkOTAlSOD0vmdti35iRWY7YPOpodR9rwJME/FI9Sua2Nj
	yIDJvgQm71/fFd0Agr4Ui69Kc3qH8zo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=efizeq25;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf30.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787912807;
	b=GxonBbrowFH9/du7wpsXxzb9TQ5J79c4KMfOaUhLfRFtRTkueG0zH2HhFO+86Lrgmu2Rax
	yd+Ecc6ffGo5PfuXHRNgnXzKx7pMvbtc/V1uDFI3Tt39tgArBQKNsP9wRYdODvoX70tN0Q
	sDkrzq8QZSfBMaKCY9Vk/cOfsZpJZyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787912787;
	bh=TUv1RmQ2miGU/9mk3aHLymUw+hTO6Btwj2zASn4n3FU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=efizeq25vrYKGHLZdcIsmoFj5XUQmuQe8oC+800UdEO0fucC2APEhNYDJkDcvymVJ
	 h4RRBQADGzkrOu373s2lhjrm22RUSmrh4RTOHSsvmsFgiEIrBZKPhuNyf8yK2pLnEJ
	 FCHwtoRhLJnNGjHRakEeNqp3jgB7NS9g6OmfuQjg=
X-QQ-mid: esmtpsz10t1787912769t0a67fde2
X-QQ-Originating-IP: Czl82io0r6bpdd1Si+MKx9FHyKA59c9FLNXUn3Mf4Gg=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 28 Aug 2026 18:25:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4164784022623513556
EX-QQ-RecipientCnt: 44
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Kairui Song <kasong@tencent.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Fri, 28 Aug 2026 18:23:44 +0800
Message-ID: <92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: Ni+h0Fe0GhU9OrMislfLw6gRcSwB/GBHjwS0w9gIdZt4RHeTVwtxYZaP
	n6H6gGK5MpL3SdVUBw9cnN0TTdR6o/AqcnpY0zhobKRfmUrbqi+MvKbFpc3VJlMbTYusBRo
	zoRChF95GtmQAyckeIa5WlhpaoJdq+4YS+QqOxZu4vy9aSMbGAjI6UmOHcB/2BOO4KzpUR7
	RlwjsOngSch4b6+qEWF/R5SWx0J1UvPVPxjuw2blfvSr0E0jIuJ350clLm+Au2SxJ/dVSHA
	B+lZ2n1H9iB5IBYpQ4k+gXQ5ss6WKxFzQm5dAtkSW2yNd8mKkRUhjr0godgE6HIHVME/myK
	ziwJ0dw8IKL9fjqj8lZDoQEEKS4/NM1/POvD1Sx023cDlhbhv9qEC9jA51b31rYkjPVBSK8
	pQXfjwVNLM/RxWZXf2bttH2BY9YZn3bU9IzJE3fEu8lkH7DAgAApiaNhQMUMLomVpdy3HsD
	W12mfDRCgk/dBj6RSSkzGzZzRqsKE5fAHV1NRNNU9/XWB6KhIUDNeDluZEbvy8818bHHUnw
	TylKUegNGyeEyjrpoO1WV3GCeOju4Qi3Dtf54r3yJYpjRChH0d9Go6Ki/0yF3M97VMf9Qax
	W9SUVHmRGQv/Kncwoj5X/RopjKNGNnfVm1+gDpK2twc72YqYQq9HxuDnlSWeUURND8ITKZd
	H1OI0QCJgYrNa+cBQP/zY6WT76GhJeTDfxa1NROz3lCyMU28JquQ4HrIoOpoS670pNrfclL
	p94OXDuyO9HAwgVQK65m6HNnXBQqihC93TJVzQEFHqguUQlgy6tenBwkaCf27rHEa1n63/x
	dfZUl0+E6nlGQHQTFeL6VbilpgJZGiTN855MKEPCXivqk4JhKL+juovYbxuJkrwdJR3LbxS
	psTob6JevAf7j4OAcm7rC2acwBs4XkIxQcQXMKzK3Dyr4gly8EWC6hNXAKlVThy/3fwoBjC
	673buNWMLEOZ9O/c1KEeEPqiym1jXImu7XN6VEWvoNDkjK1/v1RAUCtdD1sJAu7CtZ5oJ0/
	MrhnAF69O/XvqOabEpWK25CnLojtm5eFOX1543mV+5GooWwlXIPqo8PwNH1gzTVwu5z3wOr
	HIXTeIJ8C7IS8l6ySHuHXTHP5X+qD/Gn1Z4D6WndiExNbOrV56BaaE=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 155kdmau4t98ccgmyt74asmnzy8sudq6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1F5B580004
X-Rspam-User: 
X-HE-Tag: 1787912805-521303
X-HE-Meta: U2FsdGVkX19UVgV/13oFsUBLX6eEKGp+2mMWsqTw2BcYctML3dtfqZ+/kfiiG5LpsdYKmbFp0W3yxSQOQOYqZMzUKBtusc4XIMr+kw9dygOWSjzbNfw+YzruYkVGzzPlHwjjfe//lWh7/YvMyBy5Zar5nlzF4Yb9U9rx8nrDRvry/2W30dVNFStM+zwg4WjwlUsqUoVwnmQatfBERr2wgo0SBdWfqsY9ksB7TAcCvet+3rBBCLWpgKTf39AflwyQEjJ4Tfo3Wg5BNvmeuEW789lNukIpVBDWtVzNg+nGoUlUnc6xpf3hnJXuEqueddOtcf2SpOflZ1fiFrZzL0s79k+zwVWm5+dbP/i72d5bNt9eFjeaYjIUgv7FiYd/CRH+3ySgeiUQ8AGqvyPzzBeNBm1GzAcW71MOBKpmxOK9pV/a5/9pu0lQHrp8xlknw1TdflYa0WqfPnTDRHS7CcSofPUdx18qlzrvor7koUYm+lCND5f+c+YwADPSKercfLO5jDUhI0Cj+wjqYZkpbLwZv7b/FkBMVUfYa8BCSkIPIjjdYXww31lEI25vUOvnmDIZ0zVnrUb/DM3f5FeV65uiNejviOx7fTID3FwYLv/C8aKaD2eCdhwMRjDDIqk6dq1wsHkz0hdRCV2/M8xuJPhhHcxOs0gIclznk9JN3XoItghwFvfTe4DiGl6K6bNenz+P7cT32reSiu2LlptIzzOsawuJfgTu5pPmlNBjH23cC5s9fcudjPFv65G/EgK5PNkLA7kjajlhQbI4q8dvH6ritMNKhexwOKZqyFdcdKSOF/Xd7EJCesZaMPsJ4t3fkZJchejgk0dzLUcBZq4GTgQJ5sjpuiKjg8eHc0TEzw9Or7S7JI23ZN/juTdHGnXquUdk4453/3z5Cn1JZcYnUAEmYLTnPK4E0uZEg5sheXlbbYbEmbyGBzdmgj8qXpxozZeZdRyZ0M1Qh82VfI/AvDb
 oF7QYiC7
 v6ZSdqnzdLS66o3JvEZZsCE7/OJx/eEVxWOvBG16gXsv3tHuu3m2+QxcjP6GbZYlTJ+J5Pnmy5AnB9CsGGXum9w4yrbrraR9LWhlAc/GH8SsmsWgaUwkf6AeAQ3Z5hIFF0nIVwthOZciXuZL0WxP+PuKr2VgIYMy++A6Un6g/C4ohMYYXlJVCNqIeqTfW/psf/i3c1d+HltDCb+T8oyvbTCxXwGgcAhqoNJl4opn9P31g53Vw1/ygzaSVhG6OZJxiDalFFsR+DH59miVGct+AO0XzFVLSplCgBIEZaKh+Mn16M/WdnuLgKTP9GboZYrAnQq9DA1Ep9ntoJnwb5GbuN5Zw62mRlFDGY/RR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Thanks for the MGLRU-FG series - it is a very interesting and
well-written piece of work. I ported it locally and ran a subset of the
benchmarks from your cover letter on our test VM. The results are
positive and consistent with yours, so I wanted to share them as early
feedback. I would be happy to test the next posted revision directly
and provide a formal Tested-by tag then.

Test environment
----------------
- Host:    96 physical cores / 192 threads
- Storage: VM images on a 4 TB Netac SATA SSD (no NVMe); VM disks
           are virtio-backed image files on that SSD
- VM:      96 vCPUs, 128 GiB RAM (KVM)
- Baseline: mm-new @ a032d41a86cb
- MGLRU-FG squashed into local commit 9fc6ff682d08
- NOTE: the port additionally contains a local guard in
  folio_inc_lru_refs() for non-LRU folios, so this is not an exact
  bit-for-bit test of the posted series.

1. fio, Zipf 0.9 buffered 4 KiB random reads (all IO through the
   page cache), 40 GiB total files, 16 jobs, 16 GiB memcg,
   45 s ramp + 600 s run:

                        run 1       run 2       run 3       median
   CLRU                 797.64      796.74      800.21      797.64 MB/s
   MGLRU before         766.88      273.75(*)   769.81      766.88 MB/s
   MGLRU-FG             838.16      840.26      367.92(*)   838.16 MB/s

   Median improvement over MGLRU before: +9.30% (cover letter: 11.1%).
   The two marked runs entered an unexplained low-throughput state;
   CLRU stayed at 797-800 MB/s, and a reboot restored MGLRU-before to
   769.81 MB/s, so I kept the outliers visible rather than dropping
   them. I am investigating whether this is related to MGLRU
   history/state across hot switches.

2. MongoDB 4.0.23 / YCSB 0.17.0 workload B
   20 M records, 6 M operations, 48 threads, 16 GiB memcg, 8 GiB
   WiredTiger cache:

                        run 1       run 2       run 3       median
   CLRU                 18695.72    18673.44    18438.05    18673.44 ops/s
   MGLRU before         17517.69    16196.08    18180.28    17517.69 ops/s
   MGLRU-FG             19871.70    19721.86    19321.00    19721.86 ops/s

   MGLRU-FG improved median throughput by +12.58% (cover letter:
   10.3%). Median read latency / p95 / p99 improved by 11.35% /
   12.30% / 26.06%, respectively.
   Caveat: the master DB was loaded with w=0 and stopped too soon, so
   each run had about 22.7k READ NOT_FOUND results (~0.4% of reads).
   Every variant was cloned from the same XFS reflink master, so I
   think the relative result is still valid, but I will redo it with a
   fully settled master.

3. SQLite hot lookup + cold grep stream (sqlite-grep test, 90,000 cold
   files, 300 MiB memcg); median of run-medians for the hot lookup:

   MGLRU before:         277.18 ms
   MGLRU-FG:              13.74 ms   (-95.0%)

   Eight of ten MGLRU-FG samples were about 13-14 ms, whereas most
   MGLRU-before samples were 249-322 ms. Grep time itself changed by
   only about +1%. Compared with MGLRU before, MGLRU-FG also reduced
   file refaults by about 21%, direct scans by about 17.5%, and pgpgin
   by about 15.1%. This was the clearest reproduction of the intended
   protection against a one-shot cold stream evicting hot data.

General observations
--------------------
- No memcg OOM kills, and no kernel BUG / Oops / Call Trace / panic in
  dmesg across all completed runs.
- Confirmed that folio_inc_lru_refs() is exercised at high frequency
  under the fio workload.
- make -j48 / 3 GiB memcg / disk-swap (CLRU side only) completed in
  2h18m59.9s with 20.9M file refaults and 48.1M anon refaults, no OOM
  kill. This VM builds about 13.4k objects and many modules, so its
  absolute time is not comparable with the machine in the cover letter.
  The before/after MGLRU sides are still running; I can send the
  same-machine comparison separately.

One thing I want to flag: my local port adds a guard in
folio_inc_lru_refs() for non-LRU folios. I noticed that syzbot
reported a WARNING in folio_inc_lru_refs() on this series
("!memcg && !mem_cgroup_disabled()" in the exit_mmap path). I am not
sure whether the two are related, but if it helps, I can check whether
my guard's trigger path matches that report.

Because this was a local port plus an additional guard, I am reporting
these results without a Tested-by tag for now. I would be happy to test
the next posted revision directly and provide a formal Tested-by then.

Thanks and best regards,
zhaozhengzhuo
zhaozhengzhuo@uniontech.com

