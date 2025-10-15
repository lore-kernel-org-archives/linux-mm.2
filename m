Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F341CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62558E0007; Wed, 15 Oct 2025 02:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3ABE8E0003; Wed, 15 Oct 2025 02:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A774E8E0007; Wed, 15 Oct 2025 02:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9573A8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:36:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48FC813C156
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:04 +0000 (UTC)
X-FDA: 83999388648.22.7E7B7B5
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F0FA140013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gW1ZJQJZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=chYLFKHOenLcAoAbuxLeK+xLyqa/SWaDhpi/ROUy1lk=;
	b=Uq0ik9ZT1Y9t46G4ZURFIjXeM7vvNvBh++hbuzyKEbLGiCujgHUDPdoaLl6w4YNYnY5bO5
	RQEjAkEywlc+4BSYwc9/oiJ42A5kNx6aSVmXIV3i459myqDZTytsvJySdecLEVqsdJ1Hfp
	4AcRR+JuZaCdkeAGvvT0jB3qkTe3sZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510162; a=rsa-sha256;
	cv=none;
	b=K+l8ms4Zp2uzITV0VaROjwFnmFoccPOmI6VmYkD32mfCkXnOv/QOytjRDLwwgjW8u7L/kh
	tDitKcFyA1Urr5n0OvEWq77qgrWAT67rzlZCL9Yn5398ItXPgyrJZkNBIb+p/3iYSbLsdl
	4mpiQXtS0LJkW2o+T6Ct9jmQYNBakjM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gW1ZJQJZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760510160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=chYLFKHOenLcAoAbuxLeK+xLyqa/SWaDhpi/ROUy1lk=;
	b=gW1ZJQJZl6v8GMrG3KfidtB039hu4hUhUhzri0l/yhaXnna1qQidZc0XD/jGRYbFQtRCzw
	aB9eQg0iDSgvjDMbpeQuRMWioTMBQ5BV9CMA/jtqZyesZZxFbMU2ohM6tb9oK/z6EPo01b
	Ac1TrRvDLNTWSmbXBBvR/uyfrrQiODo=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 0/4] reparent the THP split queue
Date: Wed, 15 Oct 2025 14:35:29 +0800
Message-ID: <cover.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: kw3enprbbymwppu3y19mxn89neqsgzka
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F0FA140013
X-HE-Tag: 1760510162-750526
X-HE-Meta: U2FsdGVkX1+Wq53VOLS1qZ3T8RYi8f1fl1QiMZGcfbJ3OdQd302LV0rsZlq3Lyw0JCJDTct3xGc7RgzP6c2yDdXJVY1EP4k9wPzAAnf+MYulAWuBeq6IZc3Zspht+X+ppwwBUYXzSX705ZerYHlZhpse8rbIKGST7Vo/C/Pe3wnnrjOn+IKgRsi+eHIcx23dK0eJrWr7RLacl//XJ+EAPyAyaBRxOQkDQJ+5eR5nJiSTz39QImWuIQqowADfI5TbEVDmzG7IOUFEA96DlkUoTLpQ0h/6VJhLbKi5esjr/X7YMysuvrAzgIxE13omPCLWKmfZsr+JNzEXTgedAMJQ/S+UzDJ7RtWyx9nVBgG5fKEY8GZ94lI/YQVnHXBXsBMaDygcla+NM3030PZ+aaOt7fd6K0d6jDgru+t57SlAV3vwbiX0aXpLHhctiw7+gxw3fVuatPG2E/8qiGJHraWXIfT5A6UMholzVn6nPOebAuq15d+WRBI6QgpXBRx8Yi9vlFlMVQfeOc3YGKxWg10O8k5tH4FFREx8nYsig2wWB6cjXxDhMB/ZTBbTqShWm9GjbMNSFBsBnHOKIO59wGdAzdnlbHEJh0g3VOM9YRBYMz1MIHN6rYbPhjlh/dyfhqD+zYPzZ9M/1rde4FdZ8dyC7Qtu96ksZhmLh7J8cyguRtOarvxCCh5eOapbpUj9hbNlM5u/7G56PO/Sivjj0T9goFJpzzHYjZAkACupbKQU2XyS7fg+LTk/NkGr7bLRy2m0Beh3g7OemOaBeanlHxGkPjzsltPoIuyKzjmdyGVqtfcMttPa55rbRdj/HZhCGqCQ11uSa7neGHHiXmZcFvWn1SBPtLfhZHsy6Bg36FIIEfkxENH1oVn+HIZ5KYQh6Zy7JGz2RyDMaABX+cUXya5HEdHL3pqtbpPISpQpaX3iLje6h/WYwd74jYRAgxdqgubYDxFqUWYW2IjCSknz0lM
 +Gu5Y9V/
 5G+9db1XiVtPrZkKE0gnkIgk9kvH4bS9e/IszCI3cA4jMNW9V7d01PfACK5eSAoLmbImd/qYZdWYJ6Y807MbwUUrgd+j7vNCPqFoeQID1PakMHYsMajpytcMXLY97tsM1TiOcxYNGP8ln94x5KlZ6GmYE22gWyQPMdSD/xaKZ5MnA7eoGh5LApe0MTrvFZwxbBJrhsgiTeASOT6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v5:
 - fix the softlockup issue in deferred_split_scan() (Zi Yan)
 - modify the commit message in [PATCH v4 3/4] (Shakeel Butt)
 - move memcg_is_dying() to memcontrol.h (Shakeel Butt)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20251014

Changes in v4:
 - add split_queue_lock*() and let folio_split_queue_lock*() to use them.
   (I have kept everyone's Acked-bys and Reviewed-bys. If you need to discard
    it, please let me know.)
 - let deferred_split_scan() to use split_queue_lock_irqsave(), which will fix
   the race problem in [PATCH v3 4/4].
   (Muchun Song)
 - collect Reviewed-bys
 - rebase onto the next-20251002

Changes in v3:
 - use css_is_dying() in folio_split_queue_lock*() to check if memcg is dying
   (David Hildenbrand, Shakeel Butt and Zi Yan)
 - modify the commit message in [PATCH v2 4/4]
   (Roman Gushchin)
 - fix the build error in [PATCH v2 4/4]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250926

Changes in v2:
 - fix build errors in [PATCH 2/4] and [PATCH 4/4]
 - some cleanups for [PATCH 3/4] (suggested by David Hildenbrand)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250922

Hi all,

In the future, we will reparent LRU folios during memcg offline to eliminate
dying memory cgroups, which requires reparenting the THP split queue to its
parent memcg.

Similar to list_lru, the split queue is relatively independent and does not need
to be reparented along with objcg and LRU folios (holding objcg lock and lru
lock). Therefore, we can apply the same mechanism as list_lru to reparent the
split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and preparatory
work.

The last patch reparents the THP split queue to its parent memcg during memcg
offline.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm: thp: replace folio_memcg() with folio_memcg_charged()
  mm: thp: introduce folio_split_queue_lock and its variants
  mm: thp: use folio_batch to handle THP splitting in
    deferred_split_scan()

Qi Zheng (1):
  mm: thp: reparent the split queue during memcg offline

 include/linux/huge_mm.h    |   4 +
 include/linux/memcontrol.h |  20 +++
 mm/huge_memory.c           | 250 +++++++++++++++++++++++++------------
 mm/memcontrol.c            |   1 +
 4 files changed, 194 insertions(+), 81 deletions(-)

-- 
2.20.1


