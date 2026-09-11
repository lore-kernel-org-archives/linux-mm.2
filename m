Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CB5C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39BB6B009E; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC60B6B0099; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D916B009E; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D23F6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE47A1401B3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:12 +0000 (UTC)
X-FDA: 85201300464.11.F2FA66D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E098A20009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J624UCbe;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/OKlgUtcpCPpbTAiVUkKLACHt907L8XibMk/P+tLXdk=;
	b=n6bH/vnf+U+Fd3qI2NyBFuBCsw6ZhRwvTcBv5BcJayr3uNiQVw7xwNfjpJ++tI4wTotquQ
	407eE9S5fD0dVJtzlyQ0hjRhLA7sRAPG/V764nSm5i20U2mgA4I3UHaTD/oBeJHEoeBorL
	m33XS6TG76tArUO9No6/y/JXsZNFfRY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J624UCbe;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127111;
	b=Yo/P11lDzE9Din7ZNCdx2ZwVKXwIUCOAevzU/EecPw/Ons5stgwZRfqlI1slKQZYbewqgo
	3Dtl+VZHsIcG/MKNXAerFb44Qm0I1H/6bbAGT6jF7WGx2RNdk6tMtld8E1hb+yWVGU84X8
	Ql4O3aJwirXXgGQScMVsmL5J/AxxJ5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0936043D4B;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBC29C2BCF5;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127109;
	bh=KSZuuIXiPvjqtZ1OtLVJ7+BfIdEkVXt8r7rNdgXH3QM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=J624UCbexuVw3kfYfMWa53pZkwZggsHFOdNcy/0/UyJu+3ZD2NBydgfU6kD8o1Uoz
	 AnawEvUFuHcbM66jeuuOLslHMA5d6edZyb1op6/TTj+Xeb5WpIuZwlrYDKNOtyJGai
	 eQDkKX9ekQXRmlA+fiII4Re4csq5Xz+mzlGgu9kF8WUHLs45Sc0JLLg31I/M/xYdA8
	 8GucWzDe5094U2IVMBnx92+a7bDULruJhpoT3tvXb/OyI0UJDHhs5RNouxJ/CNKctD
	 4RNigR51wWvRySbq4nd2hb7Ucvtx5snSWxTGyg0u7YsGJ1a4d3SlU2sAOnBBogx/R2
	 a4vCWolzXeBvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09B5C88E4D;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
Date: Fri, 11 Sep 2026 19:45:03 +0800
Message-Id: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0WNyw6CMBREf4XctTXl8tSViYkf4NawgPYCJVJMW
 4iG8O+WunAzyUxOzqxgySiycI5WMLQoqybtCx4iEH2tO2JK+g7IMecFIhu7p5lZ27GkRlFmRVp
 g1oDHX4Za9Q6qB9xvV6h+o52bgYTbJTvWK+sm8wmHSxzg4C55+ncvMeMslaWsZXLykV8caUHaH
 cU0QrVt2xeZC787uQAAAA==
X-Change-ID: 20260722-mglru-fg-3a2c8574725b
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=16470;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=KSZuuIXiPvjqtZ1OtLVJ7+BfIdEkVXt8r7rNdgXH3QM=;
 b=P+0Z6hHchsz3dmxJzk2l3266Lb6xWYreWFoceVUOT9DMYlauQX+UAe5vtSGQfrz1Pa5P0n9C/
 cAs63vhNZwlALBpoosN4Yn6LaGgoAxbstyACZCfdCjRpVnUNy/ruCjC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: x38b81ha6cquqnzrdune7y5u1fn51wfa
X-Rspamd-Queue-Id: E098A20009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789127110-682165
X-HE-Meta: U2FsdGVkX1/CSeNH+CF1D6KbLJLrGsO1zQcYO1pu9ZdKoDic4+z2LB8LYd2FvlyUDY18IGXFtL4ikVIvUjl8UFDDpYYkVok1ygs7O3fkNl61BlKiXPVfbPMpGNSlVQifz0ZSypbDLHVKypfYvS5v1g40Pti5ZdGEEtMAIbHGxyIBmHHtVBiqDo4ig4cj3bEdDl9/0Abfh8a9G2OWkAA5/fQnGG6HAjijv2c9ZCR9JhjH3gj+zzm6VYQQE6DH7RFWQ2Gm0ofszYyVYnB+WpkykGUzQb6jfrirzcpANeZqUO0CSa5oMblpKf9bGu7jWv+xIK9eRJDJLHqkRZWvdRKnyLzjx2S3WlYOx5+oTIPCQkxWN30ww4E3VQCNFxiEGHi7oB2rzBmyQHoEku5EmD2cTngShUkp0VzAkpTdWahLmaOZ/VJpx8JKtnr7IAYM3f+dVL4Rq/92BTwadKyKYckCh8nd/7wVnu6seeIUhLO3AP7O0q48VHZnINtP4cwa6T8UDIL5eTm873N8I5+bYXCZSTv5HXGrpbtGjPaubgGADAxIymq7lXvO8luV38zTBbyxHyBrqJM28Iu6g74Fx3zlKCdEmxFKa8cEDh1A4uQCIx3E4zpkAXBxmNXfc86YVuwbMa7OrrwMD6af1bHYTqRrYWhX3+0dfBS6zOAkpYYySIKhXrMdFmwWkslCDHabeP54GsfkFsOkWJh8qQiyciEdBNNGcojbaw7LFnA6Z4Zs1g1eIt3b79xhVoxnwFVECtFR6jSS3Ui9XkHoXyADvU5tspBQ9Oe5Lv/xXx0rzU7k6rhSEIX71UTzUVfR1tNv8KQ5DOfggzYAuKq5Wj5Qv6L9nIuQcxppxaggV+4oOWrhIZNxSL8B7OrCD+/5q41T1WHet9jmyaRLa7Vw41lz79jq3uZ4/oXoI3Ip3h+1rXS3ivI7gTYXv7Ty2fJOqrDKHBh3MNK6oD0R2QHLAFniI+v
 W+TR9HFP
 q5vNk7wodJIbGZrkLIofIYyIspDEMLak7Whx0S1Go01LVJpk7iakkfDnTBFKlarsnLlG2s/9qd+pzmnRnFIcjsLTLay3BZ4CWN1WPOeCAC6ERHfqKLvKHd7VZaTG8fDXVKyhBVjr5HGwndvPBFOfhvrhgL7uZmJTPGluXI3LN+ugiJD6LtGYjhzk8F3Mi39ubQDdQjKp2MQJlcuEFA0e7PguWDn9UTKclZVz0G1Y9UnK1JI+A/BAKspOoJ+YGLJLDp0B0HEukVc67BUmVYD6/BeqTRmFJSYjffBoZcHlXP+MisNa+tAjBrMOwrZnyRdDEtwhEwaRPpZWrii27oaVGrjq4oP2AGJmbFgAsnkTge/2/qjBxKIoa/4egYkIGANikU3JG04iqa9vrDO4sDEcqV4BqD8oLvp/tCrF39tI3inV6PlgHxNLxwAyxv+yTJvYggHuXhUiZEJ449PN8gZcZ0gA209cX3j+1nfNczJIGCGyySD+CTsRXKvlTQ1lV0xuqr6Knw+DJiy1zVb3vQStioa1W6ewxiRQRjdXjSR6KYkupiLlbGVYvolWAxTmjmAmCR0HYu8JCJl7LkG8qpKSmh3QUXB1IfiNGjkjVsvoa56jKSP0ZbKGthTXa/kPozhxbiP7cD67ZqNKHrbFgSk6xxVmcgk4ZDqmevvY0WtJxqje/aCvmAhYuGhSlCuW2PNfj8gGKudn1WM7RsHp6V/J0+iKIQUqAd2C2hS/xACNiEdLggZsB829EuWeGQlr53g39eXhDOhY7zUSY38YMz1FBZpvikQ1jtAPRZzW0LE+sVl4AsQk9xtUwRNvPKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is the updated RFC following the idea proposed at LSF/MM/BPF [1] this
year, based on current mm-new, retested most result and they pretty much
just match V1's improvement.

In summary, we can see a 10% - 40% higher performance or lower refault in
various different tests, certain workload gets a dramatically reduce of
runtime, while reducing the page flags usage by 1 bit. The gain here is
mostly from real improvement of LRU's ability to distinguish the hotter
workingset. Tested across multiple servers of different archs, desktops,
and Android, all shows very promising result with no regression observed.

I might split it into smaller parts later as I did with V1, some helpers
from V1 are already merged, but to show the whole picture I believe a
RFC v2 is needed. It's already very usable, stable, and performing well,
but I'll keep it RFC as this is a major change to LRU, including changing
the Active/Inactive reading, in a good way I think.

It also fixes several long-standing issues including under-accounted PSI
and poor workingset tracking (especially for page cache).

Test results (CLRU means classical LRU):

Build kernel test:
==================
Running make -j48 in a 3G memcg, using disk swap and holding the kernel
and build output on the same NVMe drive, 16 runs using different swappiness
configurations [2]; the patched version is better than mainline at almost
every swappiness value, measuring the total average:

        real     sys  pgpgin  pswpin  pswpout  refault_file  refault_anon
CLRU   6m06s  31m01s   50.3M   3.20M    13.8M         10.3M         3.35M
Before 2m58s  10m58s   10.30M  1.60M    5.25M          434k         1.06M
After  2m50s  10m38s    8.79M  1.34M    4.82M          377k         844k
delta    -8s    -20s    -15%    -16%     -8%           -13%          -20%

Same test, RAM swap (zram 4k, 256G), patched still better than mainline
and classical LRU still the worst:

        real     sys  pgpgin  pswpin  pswpout  refault_file  refault_anon
CLRU   1m41s  16m16s   25.6M   2.54M    11.0M          3.7M         2.60M
Before 1m34s   9m44s   12.6M   2.07M     9.1M          477k         2.05M
After  1m32s   9m10s   10.1M   1.64M     8.5M          411k         1.62M
delta    -1s   -33s    -20%    -21%      -7%           -14%          -21%

MongoDB YCSB workloadb [3]
==========================
With recordcount:20000000 operationcount:6000000, threads:48,
in a 16G memcg, 3 runs:

CLRU:          98389.94 ops/s
MGLRU Before:  83700.34 ops/s
MGLRU After:   94951.21 ops/s (+13.4%)

There is still a little gap to CLRU, and this is the only test behind
CLRU, which I believe is related to writeback threshold (64 vs 32) which
we can tune later. Test from community didn't show such gap [8].

Chromium & Node.js test [4]
===========================
Using ZRAM as swap, on a 48c96t machine with 128G memory, 64 workers, run
for 1 hour:
                 Total requests:
CLRU:                     63822
MGLRU Before:            140858
MGLRU After:             210014 (+49.0%)

(NOTE: It seems some recent change broken MGLRU's fairness guarteen and
also made this test dramatically faster than a few months ago, which isn't
related to this series and reading are even better now, but I'll take a
deeper look later.)

FIO cached with zipf
====================
Using an NVMe disk, in a 16G cgroup, total file size 40G, this measures
the LRU's theoretical ability to distinguish the hotter portion, 3 test
run each config:

fio --name=fg --numjobs=16 --nrfiles=1 \
    --filename_format="$testdir/rnvmedk.\$jobnum.img" \
    --size=${FILE_MIB}M \
    --buffered=1 --ioengine=sync --rw=randread
    --random_distribution=zipf:$ZIPF --bs=4k --time_based \
    --ramp_time=45s --runtime=600s --group_reporting

Avg IOPS (higher is better):
+----------+----------+----------+----------+----------+-----------+
| Config   |      0.8 |      0.9 |      1.1 |      1.2 | avg delta |
+----------+----------+----------+----------+----------+-----------+
| CLRU     |  400,000 |  601,667 | 2,074,333| 4,354,333|     +1.2% |
| Before   |  382,667 |  604,667 | 2,071,000| 4,334,667|       --  |
| After    |  434,667 |  669,000 | 2,301,333| 4,800,000|    +11.5% |
+----------+----------+----------+----------+----------+-----------+
Delta per zipf (higher is better): +13.6 / +10.6 / +11.1 / +10.7 %

Throughput-normalized file miss (refault/read, lower is better):
+----------+----------+----------+----------+----------+-----------+
| Config   |      0.8 |      0.9 |      1.1 |      1.2 | avg delta |
+----------+----------+----------+----------+----------+-----------+
| CLRU     |  0.17868 |  0.11840 |  0.03216 |  0.01274 |     -2.8% |
| Before   |  0.18237 |  0.12232 |  0.03296 |  0.01321 |       --  |
| After    |  0.16680 |  0.10994 |  0.02907 |  0.01142 |    -11.0% |
+----------+----------+----------+----------+----------+-----------+
Delta per zipf (lower is better): -8.5 / -10.1 / -11.8 / -13.6 %
(MB/s ~ IOPS x 4 KiB; e.g. 4.80M IOPS ~ 18.75 GB/s.)

On the throughput-normalized file miss rate (refaults per read, the
metric that reflects LRU workingset-detection accuracy), unpatched MGLRU
is ~2–3% worse then CLRU across every zipfian access pattern on
this page-cache read workload which the standard model of real
cache-locality skew. This matches the long complained MGLRU cache issue
from community. However the comparable IOPS largely reflects MGLRU's lower
internal LRU/bookkeeping overhead masking the higher miss rate.

And, the patched MGLRU-FG, lowers the miss rate ~8–14% versus default
MGLRU and ~6–10% versus CLRU (best of all three) while raising
IOPS ~10-11% versus both. It detects the workingset more accurately
than all others while retaining MGLRU's lower overhead than CLRU.

So in summary: MGLFU-FG provides a ~10% gain on zipf access on real
high performance disks compared to CLRU, while unpatched MGLRU is ~1-3%
worse than CLRU.

LevelDB Scan/Get
================

I also retested the LevelDB benchmark from the cache_ext paper [5].
Interestingly, mainline MGLRU already beats CLRU on this one after a
recent change in lru_gen_folio_seq that bumps new folios with refs == 1
to the second-oldest generation. That change accidentally gave random
reads a higher hotness level while making sequential reads much colder:
sequential reads involve many readahead hits, and readahead folios start
with refs == 0, so they're already in the oldest generation, and
folio_mark_accessed() on a readahead hit has almost no effect on generations
in mainline MGLRU. Meanwhile, all direct-hit (random read) folios start
with refs == 1 in the second-oldest generation. As a result, the scan-get
test natively protects the "get" part and sacrifices the "scan" part.
That's not the best solution though. It's unreliable because it depends
on LRU drain timing, and it hurts workloads where the sequential part is
actually hotter (any workload involving a hotter large file and many
small cold files will be affected).

This series improves on that base: it covers ordinary workloads without
hurting the scan-get workload and without relying on that initial bump.

LevelDB Scan / Get, Throughput Total:
CLRU:         4668.8 ops/s
MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloads)
MGLRU After:  5029.7 ops/s (fastest in all cases, and no regression)

The hot-sequential and cold-random workload can be easily reproduced with
SQLite and grep. SQLite continuously scans and looks up a small hot
portion of a DB file, while grep iterates over a set of small files much
larger than RAM [6]:

         SQLite scan & lookup time:       Grep iterate time:
CLRU:                       14.51ms               13281.37ms
MGLRU mainline:            567.05ms               13694.47ms
MGLRU After this series:    10.58ms               12930.43ms

The grep cold portion is larger than RAM and accessed only once per
iteration, so there's no promotion of any of it. CLRU handles
this reasonably; mainline MGLRU has a clear regression; MGLRU-FG now
not only recovers but is able to catch some hot parts from the cold grep
workload. This test is somewhat subjective, but the signal is clear.

Android (Just for RFC reference)
================================
Testing on Android is quite difficult: lack of mainline support, and it
is very noisy to get a stable result. I did a informal backport of the
latest MGLRU-FG patches onto the 6.1 GKI tree just for testing,
preserving the frozen kABI layouts so the implementation is limited,
but the good news is there is no regression, and it seems better in
several places.

Results collected on a Pixel 9 Pro with 16 GB RAM and 8 GB ZRAM, loop
launching 34 common apps and 20 Chrome tabs via adb (a brief scroll per
app during the cold build only). About one hour per run, 2 days of testing.

Despite everything on this platform pushes FG into a bad position: a
uniform whole-roster churn loop offers no much stable hot working set
for promotion to protect, the memory-management stack is built around the
non-FG MGLRU baseline, and the 6.1 base lacks much of the upstream
infrastructure. But even so, FG holds its own:

("Before" below is the same tree with upstream MGLRU-aligned backports
to cancel out effect of unrelated changes, "After" is with the FG series)

median of 3 runs           Before    After
------------------------------------------
workingset_refault_anon     2.47M    2.52M (+2%)
pgsteal_anon                2.78M    2.98M
workingset_refault_file     3.83M    3.20M (-16%)
pgsteal_file               11.56M   10.27M
pswpout                     3.08M    3.25M
pgpgin                     42.91M   39.04M

FG seems to have little to no effect on the anon side, or a slight bias
towards more anon reclaim (refault_anon +2%, pswpout +5%, pgsteal_anon
+7%, but see below, we seems retained more apps). The file side is
consistently better at the median (refault_file -16%, pgsteal_file -11%,
pgpgin -9%).

I also ran the Android Jank test from Zicheng [7]. 3 test run,
no obvious difference was observed between patched MGLRU and unpatched
MGLRU there (chrome scroll fps 101.3–101.6 vs 101.9–102.2), similarly
negligible jank ratio. The patched MGLRU showed a slightly higher alive
app count:

                         Before   After
Average Alive App Count     4.5     4.8
Peak Alive App Count       20.5    23.0

Could be noise, or maybe a slight improvement. Both kernels saturate all 8
cores with no obvious CPU usage difference (both 99.8% utilization, ~517s
busy per 65s window). I also did a test on another Android phone with
5.15 kernel, which has all apps in the one global memcg (this Pixel 9 Pro
has each App in seperate memcg), the result looks much better there,
either due to the memcg layout or non-reclaiming anon shadow (6.1 kernel
reclaims anon shadow). But in either case, the performance is a positive
reading.

So in summary: we achieved lower file refault and lower pgpgin, a
seemingly higher app alive count, at the cost of potentially slightly
higher anon swap traffic.

Others
======

Additionally, PSI, smaps, and readahead should all benefit from better
accuracy since this series unifies the flag usage between classical
LRU and MGLRU.

Other tests such as MySQL are looking fine, with no regressions. There is
also community test report [8].

Refault distance is not included yet, so MGLRU may respond more slowly to
workingset shifts. That can be added later, as previously demonstrated
[9], [10].

Extra note about future development: this series is actually highly
compatible with ideas like workingset reporting [11]. The "gen climbing
folio" design may appear to conflict with workingset reporting's idea,
but it doesn't. The solution is simple and straightforward: once we can
extend the generation number to a larger value (e.g. 64 or 128), the
refs-driven promotion can stop at a lower gen (e.g. oldest_gen + 16),
leaving the remaining newer generations as perfectly time-gap-separated
bins.

The tier count is not fixed either; we'll need to find a way to tune it
if tiers go beyond 4 though, but that shouldn't be hard, not a blocker
either.

More details are in the individual commit messages.

Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com/ [2]
Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb [3]
Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/ [4]
Link: https://dl.acm.org/doi/10.1145/3731569.3764820 [5]
Link: https://github.com/ryncsn/emm-test-project/tree/master/sqlite-grep [6]
Link: https://github.com/purplewall1206/android-perf-bench [7]
Link: https://lore.kernel.org/linux-mm/92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com/ [8]
Link: https://lwn.net/Articles/945266/ [9]
Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/ [10]
Link: https://lwn.net/Articles/976985/ [11]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Rebased; dropped v1 03/05/06 (already upstream), folded v1 01 and 07
  into patches 01 and 04; new patches 06, 07, 10, 12, 13.
- Make folio_test_workingset() itself arbitrate, dropping the parallel
  folio_is_* helpers; convert the last raw PageWorkingset() user
  (erofs). (Johannes)
- Use LRU_REF_MAPPED/LRU_REF_EXEC flags instead of is_fault/is_exec
  booleans. (Barry)
- Fix syzbot "WARNING in folio_inc_lru_refs" on off-LRU folios.
- Account active/inactive per folio from refs, not the gen window:
  /proc/vmstat and memory.stat no longer jump on aging or reverse on
  swapless machines.
- Make folio_inc_lru_refs() lockless; add folio_inc_lru_refs_fast()
  for the gup fast paths.
- Convert DAMON and khugepaged to the refs-based operations.
- Drop the lru_size WARN_ON_ONCE() and lockdep_assert_held(): the
  counter is lockless now, so transient negatives are expected.
- Link to v1: https://patch.msgid.link/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com

---
Kairui Song (15):
      mm/memcontrol: allow update of LRU statistic without holding LRU lock
      mm/mglru: make generation page counters atomic
      mm/memcg: add folio-based lruvec live helper
      mm/mglru: frequency guided workingset promotion (MGLRU-FG)
      mm/mglru: make folio lru referenced times count a generic API
      mm/mglru: move add/del LRU size accounting out of lru_gen_update_size()
      mm/mglru, gup: mark folios referenced via a fast helper
      mm/smap: convert to LRU refs based operations
      mm/madvise: adapt for LRU refs based operations in MGLRU
      mm/damon: convert to LRU refs based operations
      mm/huge_memory: mark file folio as accessed more accurately on split
      mm/mglru: folio LRU refs based active/inactive number accounting
      mm/mglru: make folio_inc_lru_refs lruvec lockless
      mm/khugepaged: check folio referenced state via LRU refs under MGLRU
      mm/mglru: make folio_test_workingset() work based on folio LRU refs

 fs/btrfs/compression.c     |   1 +
 fs/erofs/zdata.c           |   3 +-
 fs/proc/task_mmu.c         |  22 ++-
 include/linux/memcontrol.h |  45 ++++-
 include/linux/mm_inline.h  | 370 ++++++++++++++++++++--------------
 include/linux/mmzone.h     | 167 +++++++++++-----
 include/linux/page-flags.h |   2 -
 kernel/bounds.c            |   2 +-
 mm/damon/paddr.c           |   9 +-
 mm/filemap.c               |   1 +
 mm/folio.c                 |  85 +-------
 mm/gup.c                   |   6 +-
 mm/huge_memory.c           |   8 +-
 mm/khugepaged.c            |   4 +-
 mm/madvise.c               |  48 +++--
 mm/memcontrol.c            |   6 +-
 mm/migrate.c               |   2 -
 mm/page_io.c               |   1 +
 mm/vmscan.c                | 484 +++++++++++++++++++++++++++++----------------
 mm/workingset.c            |  45 +++--
 20 files changed, 812 insertions(+), 499 deletions(-)
---
base-commit: 9958290885035431e2494159f555e332c3c14906
change-id: 20260722-mglru-fg-3a2c8574725b

Best regards,
--  
Kairui Song <kasong@tencent.com>



