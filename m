Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439EA606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A0F6B02DB; Thu, 22 Oct 2026 10:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB7A6B02DF; Thu, 22 Oct 2026 10:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4686B02E1; Thu, 22 Oct 2026 10:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA936B02DB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:56:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADFC916014F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:56:24 +0000 (UTC)
X-FDA: 85350563088.17.8C031E4
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5E2F180005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:56:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792680983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Bo7M4JhjEAp6ZI2fBYkRnkPkrD1NgLG4BN3e/nf8n7o=;
	b=1Juq+pfGUiro2yBeoS2YmKn/lA3irauCrRQ6saOOYNdzHQNPI9LGhw69O47tyQlDWBePpr
	src5v1PkAxAFs62wJGCN2jukBmt61hNnz/aK7Hw5FB5iTZiJlACb8YH4AQJhTn+gFtrDYN
	f3Z6pcsOQG2U7HCYDY5yHLAk7EJcTT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792680983;
	b=T9+QGpIRFHZyCeu4omYHP7IKFutmIlgkJ5EnrCKlQgjLIyckoD9OSfqXEtJBrZbYQqYuVt
	F5uzQVH7sVE9Xhg6216j1Hkt33r4BkERJV8McjWEF7+noh2qmK+ewxBDtRUFl/+Ca4tdSb
	6RxDhFX1axXYZ64nVZrKk+SBvUNLIYM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id A80611F6B5;
	Thu, 22 Oct 2026 14:56:17 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
Date: Thu, 22 Oct 2026 16:54:45 +0200
Message-ID: <20261022145615.2184343-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTFMd1FM7BbvTA8TCUewrtd1V/1uyK/ULWQ1OY6oegAXsYuboL5juFNAuEozbSuWxXyn3ZpEs16OR9scsQhOOe6quwa1WdK/TeAxD6GuZOyA6DNtoYHmF8D8DQxn9aIPXvLMkYPIijfcxdlh+riLJ17Z5xMNsJE8uI7naZ1//WmJe79ty0aZtgNSYkgOVgzRxsZcG8ooR1CWTdmq0tI6kLAS9IYVEwke3c/ljUJMWmA8Cb4eHcYrdXkpx2GQCMhiLkbNIrJS+QvZwx6jNUZwFAvRhEwazrbTDy8O89f62t7puuFBdjN35sp683cCxJypVYs3+s3TgIL1JAy5SfM4uXWhm09ZV6FSy864o32f8ey/ZG8SCtQ9+huwsXEMSyBZ9m4vSMkWZxph9IOZf40yMeyPT0C300GGC9BsQZrKrKXJC1KVFNZOWMf/RBPBrdrIIY3fyV2x5BJCY5TR8sevFUfnTD36G22WlmSnbUyblF276ven69i7LLHaXDNpHbScQGkvDV53qaFQqTUdFQG+OwHNbB8NAn3QbzlW47jWDJI4LCtmSCcxHw5AnxhgUZ7Fc7cExO/3Fnai9aCA1gqZBXJ0YTtugdctUpaHKlHXWRFpUtGZ7wdDsCaSfWBH+whL4Mi7m3ytR1yPyNFvZpHTWnPNroDuzmMl63Uw58ESCFcaNA
X-GND-State: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5E2F180005
X-Stat-Signature: efwdof8yfo4oxe33buxd47moaiy745bt
X-Rspam-User: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792680982-682053
X-HE-Meta: U2FsdGVkX1/+Ny9eobWPNUcE9ncCCTwJK45gav30n9ndbKynL0hSeFZqbF9XF+I4iVR1CysMBux5rPyiB8ULvc9D/Lz536jBafWQaVeMfoJxuA8AMOwwW+MIPrAe0vPnF1wmPIAIvVLbrcXS8v05LZ2XHiuYfnp4J7IyI9pYcMeQEG/BnEoU5K8NpJxs/uI6x/rVMRSSsEkFYCf3mc+60Iw0GO2ZjB8ELUNTV7hATKqD572QkFKYegnZSclqvS6JUu8uNY6HqYBKdbuPV3JVr0IckNNqFzC2dmQXoAp04It/fLnuUEkICk6piw9L9G+FHW83AZAyIovusZPG8y0spmLi8DPKmJgvQt2h+Ba7/i9rmUlqBejQaGfzA3HL9pRSA5OL6CEjy3qYk40CrXJaHDGx+z8ohAAfyJWrdJe/bjmXH4osImgWs/iZoQffMmbZD1/XgJjbQy4qaBHIJEMUvRNqNa4SP231wLtlAkqUlV6VJ1Yb86+mgF6EHrCpphrXX8xXi3wP7i4RMvdxmN9l2wHWivTRUWcPsW6lqb8A0enVwYy0lUhenIGC5IvNQjeUFD7kTEQ81hSuqSxATSkWT+lDuROXFmjRi6O1slmh4/KlTJumfQOr3wd+jRzXXVuLuDEa/qk5tIbnbKPkISzgm/8tYyMQh1QRFh+iHx/GddVRDKi6X4aQ32y3pLuMrFPnFg37bWcR6qjjr0jLpwFad3Fc6ezaQEhjt8IxtErYOfkXum0aMyb1J/5LI5/0xexpX0x39Ay2YB9zajQxSAiJzSTEPIrSOKG27mGT4JJaVsrYpOfys2HU9QMIyVOGdeE3fPUy/fLtaMGqPm5AqisRFI2DxxsDhvHFDnftDTDUr85psmUWyuy7x9U3YOORlOm4VmWyjjnqlszNZa4QZfIV2hbPtotLQjEgNVoE8CaLaXSJYN6+iJ3q5UZNIY9whOqiN8sLbQCQHHquYn/TM9v
 6tgiBvTc
 s0kHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

7.3 regressed swap I/O: for the same swap volume, a workload that
rewrites swapped out memory sends many more requests to the device.
mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
compared to the previous version:

  device read requests per transaction        +59%
  device write requests per transaction       +27%
  throughput, iocost off                      no change
  throughput, iocost on                       -19%

Two commits interact:

- Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"),
  in 6.18, makes order-0 allocations fill nonfull clusters before
  taking a free one.

- Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
  do_swap_page()"), in 7.3, frees the swap slot on an exclusive write
  fault. 7.0 to 7.2 kept the slot, but only as a side effect of commit
  4b34f1d82c65 ("mm, swap: free the swap cache after folio is
  mapped").

The freed slots leave holes in full clusters, which then go back on
the nonfull list. Reclaim allocates slots one folio at a time and
merges the writes afterwards, so a batch of LRU-adjacent folios gets
scattered over those holes and is written with many small requests.
Readahead later finds those pages scattered as well, and needs more
read requests to bring them back.

I tried three fixes, which perform similarly:

A. Revert 3cedb745d354. This keeps the slot on write fault, but undoes
   the intent of that commit and keeps swap space pinned under dirty
   pages.

B. Below 50% swap usage, make order-0 allocations take a free cluster
   before a nonfull one. This is what the allocator already does, at
   any usage, on swap devices with discard enabled (swapon
   --discard=pages). It is about five lines, but the threshold is
   arbitrary, it stops working as swap fills up, and it applies to
   every order-0 allocation, using up the free clusters that
   nonfull-first keeps for mTHP.

C. This patch. Reclaim tells the allocator how many pages of each
   small order the batch is about to swap out, and those allocations
   then follow contiguous free slots, in a nonfull cluster if one has
   them and in a free cluster otherwise. Nothing is reserved, there
   is no threshold, and nonfull-first is kept.

Same workload as above, 7.3 with C relative to 7.3:

  device read requests per transaction        -12%
  device write requests per transaction       -36%
  throughput, iocost off                      no change
  throughput, iocost on                       +41%

I think C is the way to go. I just add the patch to this regression
notice so that we have an idea of what it takes to implement, the
implementation may not be perfect.

I would welcome other ideas.

Alexandre Ghiti (1):
  mm/swap: allocate contiguous swap slots for a reclaim batch

 mm/shmem.c    |   2 +
 mm/swap.h     |  10 +++
 mm/swapfile.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/vmscan.c   |  11 ++-
 4 files changed, 229 insertions(+), 5 deletions(-)

base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6

