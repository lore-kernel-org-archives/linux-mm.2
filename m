Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C36FCD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B026B00DD; Sun, 31 May 2026 00:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1150D6B00DE; Sun, 31 May 2026 00:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E9F6B00DF; Sun, 31 May 2026 00:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDC906B00DD
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:24:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 607EB14044A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:09 +0000 (UTC)
X-FDA: 84826422618.03.D187495
Received: from outbound.mr.icloud.com (mr-2006g-snip4-4.eps.apple.com [57.103.70.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 662811A0005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=j6v92sp3;
	spf=pass (imf19.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.47 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E8WdjNOls66S20g/c+qMGPBkpLZguCRKlXTYItbtX2Y=;
	b=rbrTdM8oT9BklPM5naRAjh38mFXGspPgo5F9ShQQZp2OUD9hMWrv0kbFW9ZwQued+PgbiR
	rHfStdoOGPMMraFbFRLJckHOyfAAr6U3EQVj/7XNnOp8jUV1bGAlFIO7O2Qgo82Fu2uC+k
	4mvD4dnsPffy98FBum8yhSw+M7zPq7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201447; a=rsa-sha256;
	cv=none;
	b=zL5ayRwo/qewOhg0TkFsX58lgoki+uLrksDooLDCIzSwRFCSWGvzEDbIfudubbnv/nh1Yt
	hKZEudlqjl0ZPKdsfj6vXCIevG8OVaDE+h1t+ulGqA4Ccy9CfjoPseZURWQCHShLCG+E3D
	UWkfp5jf1H+O7JTqyTY77ZjQtUJ1ALU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=j6v92sp3;
	spf=pass (imf19.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.47 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPS id DCF6E1800115;
	Sun, 31 May 2026 04:24:02 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9AFB0ECw8IAEAKTQVfBitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201446; x=1782793446; bh=E8WdjNOls66S20g/c+qMGPBkpLZguCRKlXTYItbtX2Y=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=j6v92sp31u8Kw26lWolH5PXKMi5LHpgcJh1Q+yYkCuu93A9v1YlrLAtau7kQubWK9Y9O4i3qZkmLZEOGqf1GRWfjJ+yqsEy+qDcf0d8wGaoBrmCVBvZM66XoAUy1eAWg0Ph5xzsVmJrTr+oZFJ/BRU93pDiJIf0XTaXqj7T9HJPVznV33yu7S+WEEDmrI3yjqPhhTwNTdOdYKZIG5j/0v2AZhjP0UNlBWGApP4HMXG8ZtNVpSjkHvAd3VVszm2rntH8Zea9R0hTk6X2cNZQt3DHYcaUcGQ0Q8xYGhxWUTu2zXmMPVF14N0FLyEZ0BKw/HIQYPBFOJNV450x6fuEm6A==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPSA id 8ABA01800135;
	Sun, 31 May 2026 04:23:53 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Subject: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Date: Sun, 31 May 2026 12:23:48 +0800
Message-Id: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrA3E2CrxKiKicTQjEkMmloJ49
 8a6fIv/T2AMhAxNdkLADzHtLqHIMzB2cAsKmpJBSVXJdylFtL43+7YNnrG35KJAo9U46VdZ6xp
 S5wPO9P0/2+4xH+OKJt4juK4f7PekxnUAAAA=
X-Change-ID: 20260530-thp_collapse_hint-ec92bd943797
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201432; l=7268;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=ITwVpGnFllNUNNmdzsS7+Wks5AE0w/8QyFWXf1B+9zk=;
 b=2wHGvP3eRvKNVGrjHk7HxPxxv8msdNLJZkycIEXP6grVeytddrR8eo2wvZuMh/InkhLXkdVTn
 6ceIWuf5X0pBZ1EjqtNTwJoVIQFpFFqHTGjFOFlNWq0FDiwj/0TMKzE
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=YqcChoYX c=1 sm=1 tr=0 ts=6a1bb7e5
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=bbyK-OfsBG3tpf3ilmAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6qEX7tShdJEhiyayywZDXy6QlO_Zoyuh
X-Proofpoint-ORIG-GUID: 6qEX7tShdJEhiyayywZDXy6QlO_Zoyuh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NSBTYWx0ZWRfX/yYzAsFQGS71
 CwI4G5cHIQIGhocA7cU+fFRMctUv04O3s6YfpmgSW3f+Pd6K6yIt19YXg1ZLCM4b35k7IUihyOM
 0c1Qde9u5GHQyU/4ZvK8bFrvfazVyU5xlC65KJSA0hStMc1chvWGjeOkhfuNS4kYyOGwOnW4mMh
 ZvAbbpHjgyfUMeTop6OpGRFddrgsGkpBCwB66AirdB1gl+LuAkbvgeCWsaEiamrWdLQ5ayUENaA
 CE2ku8mVgZAA7+Op1ED51id6OB3xwqBFPaMVovdzan6jd87EmU98wgVdDf59/7mdXqRgWw/UJcI
 fZ896c9vt5wlH+Ui8k1wAUdPb1rgir2KvMIFd18lhBwjmt/6JVrMkE2UBGnZKY=
X-Rspam-User: 
X-Rspamd-Queue-Id: 662811A0005
X-Stat-Signature: cdtsb4hnfufuj7ih9o1hdk9nq778xhyi
X-Rspamd-Server: rspam06
X-HE-Tag: 1780201447-945240
X-HE-Meta: U2FsdGVkX18fbu/hGYM5ujsFdwpjKenFT/vRKX5KVK0By+9hs639lGs6KZoOtYXG580Uyg7qdoAJdkooe0xDUqD179ng0lh+AhHMTBHzENQZxrOPWZcp6XHalnS0bOoZVLlB2bcKWT0QsUF0i2hegcbzPk8MH7iWBVXbb6uj1G58Vsz7ulHcurnGRpr1LMXTxCq/iGnACQ+Q1J0uOd4ZiCL/ZlWtH+4nR2YjwhKzJYKL17bVf5wC7Ztf2M8WrvJ337lumKwThWvh7cfIa2nlgfdbKLAUjXpa383iRK4ykwCmn9Dd8YDhIyJMZAIjiFtesGX904isXoBDBA+egM0OEjZWyVHS0idKitT0Dd3z8NH6ui1XRRKY+ayHSUreLCjs92GOx3Fx6tpLTuwXd6QxiHZfgeyXW4MdSXcMR86SeW2NjpxoOIFrgEehLI7jsdqci8fKZTltjK4Yv3WlZPfVn4/4HFkH5OSBm44325ic3OSsqm1CQEVk2jL9eTeTJXeReTa23T299cg98WgqN3Rc6x5tJo+1S537G92+K5F7mI9w3g6uLH76KahvQK3zPpEhsEhkSsCbnQWhblF9J8nbGmvYtYlBqBeaULmXLC6fj6EtYpslWIfn0iHu69Tn/HUtlCYlmqsNccClFnTeBi7Cpfn0rFvkYeG2Q34nsKkKK/F6UatxIyuLB1bfPUtG2b+Hr0oscbe4OiVWD38wAGuFYIQwQApohO/BNpQpnfYXYiu+VSmGO5kE7C00twe2D/rwdoGXgaEs9eC91uRBZo5Qq6nHWLejRBSviA8l3GnQKZisyY/1Ahotuw76ZYoZw2apDqULvZVow8DOIkCbEriG0oR8TEM40Cj3a4wc1tmBezLg4x0DJk17izSMkc7DUuY+4C/uqEwqpvBktGW1ertU/OzweLy0kBW3EVe0tazLIEIZAVhqBMMkqhx2ziqs2/lPoi3ROt/u85IaAB9QNrV
 j0acCY1n
 P/5l5a9v0B/E6ZLY3s8RXfCXtmFnqEdnlBSUozvO3nRcoeLU53FgtHlzwsw4Tzj6RYnujnQACty8BYo3Y9AsdVgEp9Nq/JLu9pu9rUQ16Jx4txeyGhE7cszECY9uL50YCdwBm9GoGzjrJpRdbWotBXtLkNv97IDlvtMerSiZtc6er6c7DkOjGdHVKEnnhw/hHDRUxvOZCJ31x/O4S1SMvBGXbKgFwb0csr93e1vPtmwSv8Osl0CXJKRaZlxFJ81VUsboLTFTPeADvcEdTwnUXUROm1xo87gtXBTT32ruoqsUiQWCJs1bnK1PlFVCIZbtmDG7KUUDgympfACRalBC0dB/ALpdrzZQHyYk2FoOIrfdf1Rs5i9i0BzhI8ovIKx3ep/gFy4SfofF1QkZt2r1CphWKjb+nS2ALl+zNV/kuWQFbho0T/zvig37poQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Khugepaged is a background daemon for collapsing feasible pages together
into a transparent hugepage in all sorts of orders up to PMD_ORDER. However,
it doesn't have any preference in its collapsing and just iterate through
all the qualified mm_struct, and scan their page tables from the beginning
to the end. It is quite inefficient especially for large address spaces
considering how slow the khugepaged can be, and may waste many hugepage
resources collapsing memory areas that are seldomly accessed.

We would like to give khugepaged some preference hints when we found
certain areas are good condidates for collapsing. For example, if some memory
areas are frequently accessed, then we know that it's valuable to merge
them into a bigger folio since it will reduce many tlb misses.

For example, MGLRU has walk_mm() and lru_gen_look_around() that are used to
scan frequently accessed areas to save some works on rmap walking and
generation elevation. By the same time, they are able to find those
hot memory areas, it should be valuable to merge these areas into folios.
MADV_COLLAPSE can be used, but that will cost too much time and will
harm the performance of reclaimation and slow down the process that may
enter the slow path of memory allocation. So the better choice shoule be to
tell khugepaged to asynchronously do it.

We add a khugepaged collapse hint framework in this patchset. The caller can
call khugepaged_add_collapse_hint() to add hints for khugepaged to make it
prioritize collapsing these specific address we found before doing Round-Robin
scanning. Each mm_slot which belongs to a mm_struct in the previous
mm_slots_hash is now a khugepaged_mm_slot, it comprises the old mm_slot
struct and a number of NR_KHUGEPAGED_PRIORITY_LEVEL struct
khugepaged_collapse_requests. The request struct for each mm_struct will
be put in the global struct khugepaged_priority_queue with respect to its
priority when __khugepaged_enter() is called on this mm (we give each mm request
structs for hint dispersion and balancing across all the mm_structs that will
be added in the future patches), and all the hints will be put in these request
structs. Each hint will have the target address and the target vma struct. An
example of the framework is like below:

global collapse hints queues:
prio 0 ------()----------------------------------()---------------
            mm_slot0(process A)                mm_slot1(process B)
               |                                               |
           hint0---hint1---hint2---hint3       hint4---hint5---hint6

prio 1 ------()----------------------------------()---------------
            mm_slot0(process A)                mm_slot1(process B)
               |                                               |
             -------                                       hint7---hint8

The khugepaged will try to scan queues from highest priority (which is prio 0 in
the graph above) to the lowest priority (which is prio 1 in the graph), then go
through the list, and check out all the struct khugepaged_mm_slot (which are the
mm_slot0 and mm_slot1 in the graph above), so it will start from mm_slot0 in queue
of priority 0. Then khugepaged will scan all the hints listed in the slot (hint0 ~
hint3 in the above graph). After handling one hint (no mater success or fail on
collapsing), the hint will be deleted. If one khugepaged_mm_slot doesn't have any
hints in it, khugepaged will skip it and scan the next mm_slot in the same priority;
if there is no hint in the queue of prio 0 anymore, khugepaged will scan the ones
of prio 1; if there is no hint in any prio queues, it will fallback to do Round-Robin
scanning like before.

khugepaged_add_collapse_hint() is for adding hints, and it only gets called
by walk_mm() and lru_gen_look_around() right now. In the future we may
call it in more scenorios when we found hot memory areas. For example: in damon.

We tested the performance by using valkey-server (based on redis) together with
memtier_benchmark to simulate a gauss distribution on the get/set operations on
a 160G, 64core x86 VM. The dataset is about 3G. After preloading db, the testing
parameter was like below:
memtier_benchmark -s 127.0.0.1 -p 6379 \
      --ratio=1:1 \
      --key-pattern=G:G \
      --key-minimum=1 --key-maximum=3000000 \
      --key-median=2000000 \
      --key-stddev=150000 \
      -d 1024 \
      -t 1 -c 10 \
      -n 2500000 \
      --pipeline=32 \
      --hide-histogram

Since we wanted to see the influence of khugepaged collapse hints on the reduction of
tlb misses, we made khugepaged do scanning every 1 second, and used the userspace
interface to do walk_mm() for the cgroup which valkey-server was set into every 2 seconds.
We made sure the server was all 4k pages before we run test, and only khugepaged could
collapse them into large folios. We enable the anonymous THP of order 9, which is pmd
size in most setup. We used perf stat to monitor the tlb misses statistics.

After repeated tests, we could see dTLB-load-misses with a 13.50% reduction, and saw
dTLB-store-misses with a 5% reduction compared to the setup without any collapse
hint. The final throughput for the memtier_benchmark was about 2% to 5% improvement
on average, which was not that obvious compared to the tlb miss reduction. We believed
that was because there were too many factors to influence the final result of a random
redis test, so the influence of tlb misses to the final throughput were compromised by
other factors.

Patch Details:
========
* Patch 1 is to add the basic khugepaged hint framework like we introduced
  above. Details can be seen in the commit itself and the comments in the
  codes.
* Patch 2 is to add a slab_cache for khugepaged_collapse_hint which can
  improve the performance of allocating and freeing the hints.
* Patch 3 is to add a deduplication machanism for the hints so that we will
  not add a hint that points to a repeated address.
* Patch 4 is to add the accounting for successful collapses initiated by
  hint or non-hint.
* Patch 5 is to add the collapse hint in lru_gen_look_around() and walk_mm()
  of mglru.

Thanks for reading. Comments and suggestions are very welcome!

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
Luka Bai (5):
      mm/khugepaged: add framework for khugepaged collapse hint
      mm/khugepaged: use slab cache instead of normal kmalloc
      mm/khugepaged: add deduplication when adding new collapse hint
      mm/khugepaged: add accounting for successful hint or non-hint collapse
      mm/khugepaged: add khugepaged collapse hint in mglru reference checking

 include/linux/huge_mm.h    |   2 +
 include/linux/khugepaged.h |  20 ++
 include/linux/mmzone.h     |  17 +-
 mm/huge_memory.c           |   4 +
 mm/khugepaged.c            | 460 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/rmap.c                  |  27 ++-
 mm/vmscan.c                |  33 +++-
 7 files changed, 549 insertions(+), 14 deletions(-)
---
base-commit: e1af79f3291a268adf4e149e1faba3052743e898
change-id: 20260530-thp_collapse_hint-ec92bd943797

Best regards,
--  
Luka Bai <lukabai@tencent.com>


