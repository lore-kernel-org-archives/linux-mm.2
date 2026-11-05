Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085286082BFB
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CD96B05B1; Thu,  5 Nov 2026 10:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE6C6B05B2; Thu,  5 Nov 2026 10:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6556B05B3; Thu,  5 Nov 2026 10:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4CF66B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:50:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F3961A0AE4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:50:44 +0000 (UTC)
X-FDA: 85401503208.16.BB24CBD
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26BBE12000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:50:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6VvAd2C6q9L0c6ZHWIYU85EEyIr/xJdmiDJqZZrUbaA=;
	b=ZpL3kT6tmJheHMzgyTvvq5qT1iWPq9LfDU3MmPaakA5WULYH+YEdsHZNkA05gjt4ewYhJo
	4tvJ7U5ljUJn9+URz5N+PQob8VknbRZjPeIw0B9IooVesWmb/Kywg/9nxMXVGt52YTmvbi
	kgk7HwFan1Blc3Ob1gu0urIU59YzzJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893842;
	b=v7E4QKtJrtb+cQTyPxmonxSUXeoyE7bsyGQXGAGz56FoSaYP9V5uGphUnxhx2ZV7+aff0w
	VM9N5GETrz6otHd+YT5jeKJ6+GOPp0TbwqKZS4JfKQU33WnD6tKfMbDociOEHe9PsBSk+/
	Q+71Bw8HrDPhrMQPNVOnsA836YizDW4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 99A803ED17;
	Thu,  5 Nov 2026 15:50:34 +0000 (UTC)
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
Subject: [PATCH v2 0/1] mm, swap: only prefer nonfull clusters on synchronous devices
Date: Thu,  5 Nov 2026 16:50:16 +0100
Message-ID: <20261105155032.240457-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTE254WFeUBZNzyFDcG8WpBR+MTxZeLStc7bGzyDg2x6s+gJUsC3gFmc98hZ2rE3AhBrTRk09vonYEfqg58KXfuKzwuM+NCKIn9qYiAFFwam9elNd2Pf4Zut0PjNkDOsho+MqFKIFhvr7tJzwtC7WawQnSvPxPQAjWNXX3gwg64huH6BhdtE8wHyzGqmGB/4LdOzKSdB4Vn08iiC6PzLm5+8CjFislUvGbRGq5dsP8ryb9VszPJAgZ40sazxbIHfeirESRma8ru0Oej8L22+FU3oGVXLev++teqrquEva6TKlEBifh0DsJUntrBSkK3vw2plrDE95L8jkw0ktfNL7rTTFxMSO0fUaxmDJn+SURROO7nsqvp9EFNJjD4+EJP7JTVvXEY3Oo7wXEFjgfPOpbz3LI7tUn06UtCEDZjkB9mOmIWZ67xRTCObhZtyKuS53HzKfyswzeWMka7PwWYz5jk+bJKpPDPsbHsc+aAP1DTAktbCfgKR50GQRt6u7uiKGKCgVAF0BR36sJODpHbBgEsUqpQHB2s8wnCc0ZhvxoOIymVZgpnermDV+ed4a6p4c6pbRWyTt8h18ihZoBcfiEXDIg2Fat/ZS7uuLRTbzq0GvHK8TydwaaacmbX/AHcf1zZKCqXGZ/p729HNE+9Od6N7vTPoz/X6rRREqD3vdYwjtA
X-GND-State: clean
X-Stat-Signature: 58jc9mmuex8zkxye663eqbqpu748rokh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 26BBE12000B
X-HE-Tag: 1793893841-926335
X-HE-Meta: U2FsdGVkX1/mAEx5+usEYkzWeyKAy+GSY9A6cmiXCfAryKWu30lDdeZwYSzQJx/44DW/hHeABJ7t2lTQb+Do9oxc+fpG7LXZkX6Q7q3i/H4xh6J6L1H6zQbC9U1IkgusUjFUaWtueuFpnMNg14b9tnZswFNUv8mOvqOupjkTHjDWSzTuFW9XJTZ1BNUg127mk2cBjNz+33kQi2/ZlZK9ckIn835Fy8qRZICg6Dr+xObkH+K3fk6xAyW4ZpHnJDsomMo8U/TlW3r54OVywV8LyfgnhrHUzf+1eaE4t9u5F5+FAbTeqMoOw71TfJ0XwEKdWnJK3fknCjJ00KvNO1FKOGI/+PzqCNa6EN2jaJCYlNevyCPF+8JDgNJBi1O2qEFKzdWfKleIyuFnCcEZHI4U4GPDNcsWI/yC/cnwOCqjdMDegh6dgxG2Lo6b+RJUN7QyvnVntpvt0IsJITYyGm8/KbyLkp7qd2tM3XsVKD8CpleXjYEYDitf2JKchhVMCEMd/jV2xqCUMGHloVFyhLMaNl2aC7KpJGXI4U2F+RoHw+JZbqggt907YCKXodWs/RqBCIGTLiH/II0QymqdKzsyXbu6rSHSZQJrN3lurKde2jCBJjHfJgRWLbKJxwbxtDdZS0gGQox+pfPFjnVtid82aBUZoCpcuyv03VOHio/FaC9hu1eY2YN6Ku8fGa4OcxYubFTMJMmBK3Thk5A3rPPQTveIJspscNEDxY7uEFS/7yK0wuQVlYYw2alaJeEPsTcvh9AsRbEzp2Uuu1WL9W6YSmyAs7eManX68CrTBk7crtKyPcw3Mlf9Cmo+ZF8WQpKbxd2NgwmvXEyxiybI4seikPbXKWMgMOjS5KuII6lGRjd8IGXAtQn0OMjpsa2FUeIsourFcy7Z3gwPykvC0c2GY75Rex52zeqFoYuF+jnmAKUjXjZWpW+pH7KUYfJkex4QGP/uzMamqn7OGL4th2x
 8t18GHj3
 T26dUCGgnB9ildjGSzJ69F8HbE9ffiAn6vVqWWSD49Ocqz5xLt1BMQdoxPw==
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
  in 6.18, makes allocations fill the nonfull clusters of their order
  before taking a free one.

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

The RFC [1] listed three fixes, which perform similarly:

A. Revert 3cedb745d354. This keeps the slot on write fault, but undoes
   the intent of that commit and keeps swap space pinned under dirty
   pages.

B. Below 50% swap usage, make order-0 allocations take a free cluster
   before a nonfull one. This is what the allocator already does, at
   any usage, on swap devices with discard enabled (swapon
   --discard=pages). The threshold is arbitrary and it stops working
   as swap fills up.

C. The RFC patch. Reclaim tells the allocator how many pages of each
   small order the batch is about to swap out, and those allocations
   then follow contiguous free slots.

In the RFC thread, Kairui suggested another option, which he prefers
[2]: keep nonfull-first only on synchronous devices like zram, which
don't merge I/O and where filling holes first keeps the free clusters
for large folios, and go back to preferring free clusters on every
other device, as discard devices already do. This is what v2 does. It
is a few lines, needs no information from reclaim, and performs as
well as C.

Same workload as above, each fix relative to its base kernel:

                                              RFC (C)      v2
  device read requests per transaction        -12%         -14%
  device write requests per transaction       -36%         -48%
  throughput, iocost off                      no change    no change
  throughput, iocost on                       +41%         +33%

Changes since RFC:
- Replace the batch-aware slot allocation with keeping nonfull-first
  for synchronous devices only, as suggested by Kairui.

[1] https://lore.kernel.org/linux-mm/20261022145615.2184343-1-alex@ghiti.fr/
[2] https://lore.kernel.org/linux-mm/CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com/

Alexandre Ghiti (1):
  mm, swap: only prefer nonfull clusters on synchronous devices

 mm/swapfile.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a

