Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69802CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F768E000E; Fri,  3 Oct 2025 12:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A370F8E0005; Fri,  3 Oct 2025 12:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974148E000E; Fri,  3 Oct 2025 12:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8567B8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:53:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38FD013BDA3
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:53:59 +0000 (UTC)
X-FDA: 83957400198.30.10D18F4
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61AC6100006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:53:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFUg0FPr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510437; a=rsa-sha256;
	cv=none;
	b=uzdtwd6ufTkmTwQPGU7lVUjuDFsq7YpNWzE8Ui0kFAu735UCsZ8bWMksr/ywQ9VTIt6z6e
	df5SjD1yU+ViX+Y/OSCb4SauA/sGETAqNnso/Ij/+S3dVJmiMFWTv68DL/MO8qtB4/MqwF
	uHvsrFZt/5eQZCwYVOnpGeJhROONZ/s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFUg0FPr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xRVhaW2/i9fEx7I+LuZkY7sYjvYyEufnTn/0UGKwdi0=;
	b=eCluVyBhFWEftOZjtipJJDWHpgi2u2jE7S4WCzscWT1tasiKCFNf2kTXixINmd/RVo3xC3
	UWXrqKlrGxgHoC9dtJopyFCLl+SPRYc5qWYIejGHJtwq4ut48gppIXAD4CqIMSeBi56K+V
	guxPk/JtUzDDO577caPcJ/7KxKVdn4Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759510435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xRVhaW2/i9fEx7I+LuZkY7sYjvYyEufnTn/0UGKwdi0=;
	b=JFUg0FPrMvBpqOsOnXFw1DQ5mKTUoNhv4ZasSvNFslafvWH0wPdUdFy4mTg40rMlU6RUKI
	TqBCkuIDs60abnrrtDQxPvU0IALLTfKW0PvrsfomgVv2OVlM2tuRdY9jU2/T4e8kd56sPw
	3WFwXu/A+bbqzgtSp/nWKS3EOza4gvM=
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
Subject: [PATCH v4 0/4] reparent the THP split queue
Date: Sat,  4 Oct 2025 00:53:14 +0800
Message-ID: <cover.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61AC6100006
X-Stat-Signature: m4wkxnoqxrs8if1kf3hnkbh461ny3ktw
X-Rspam-User: 
X-HE-Tag: 1759510437-722270
X-HE-Meta: U2FsdGVkX19gojinn8BXHnv2MfPZiVOdqEvEqB2qBA6S5nxfrv5HuqsM0H4nCwiT3STIJcYEA3LVYblonLj4EkozV1WP+TOHRa9r06dVMHQHqBxtE+E8KkfNqHVX8Q3ABBipLyKi0yb5xymrF02leBOz7aOP1+eX3SXfe+3jO4GkvwaBzNov5+a9Bk4SoKuROLsEVg04fivT9NkNZfnyKxv6Lqkfxirbn/qP5tqBUh2HVUBzMtu3mbniGL+MVBep9aK5SL6sj6oxvCs9v0TbmA/2WxhcKdWYjOsJF0qbLeMJoM/qW4QTa2ZBiHLZoUsyxsa5M6E+Z5k8BAvtZy1GmOLA1Aj3C3PXaRIBx1L2CCdnIHRIIgd3yhrtZwqMC8ECJiZivuAV7+pZnsvyoFVQNJQhclyaTPVajG6HxE/6Khzfkc1z5JhbEFj5ATfueeQA7zEB3Qc6LAWJCEuJvUPkWba7jjcPLzd07NfgbOTA/zKP+pj7RMhvjbdwGUxck8xoYjLWbCbN+SEmnz0R+g2sfTh/d7KtzUgObZI88ChYfeZDFcicEx0OYVgUs38Qq5G+r4LAhdpgY+VmenBBHhyFoNEsVzJLaKsuOmRIOWvXgJEKtHtHe9oWdNtvtNCpera9STy0r7KFBSjux6qDwz12J5NDqwKX20LiW1bdTIIV+nQeGKq/6mNemnpUqVeV/zZxqfkhE4a77sx0pEWcxGZ3m115OoOTFio4B/9BF59E8XiO7WFNFlgu1CjSv7w4OjYa8XltLlpOobOxzhvKhDdbkF60I6aBKTvWk0SXvINY6xb+Px2RJQ8BlHehrwUMAVYH8rhUDrSIuyCoySwU31oouYpca3GqDTgR7OcOmhKewjqSlQ1UgI3ZPCMqEPmCh1nB6xag0c7eAgfV9QQLMqxxD95FP5bpL2wQ2RZHXjWgIpmW/jTI3oJh1Ju/FbD3+1u6dm0RPzw1pK1F4n8iNAJ
 WoB3ZkE0
 uUUhvK+lVohNUdxvM9PK8ZeRPQjNZNoGMARNq7sQHQOuj+q6CV7yDNoEmQjngoG3Zuwi/UOalrLNMVSXpROTjn7Qg33Wg59kG+r9/juYw5aoIU3Yu9oEffJ2EgZHwJEOYQcBc9vbv3FiRyPNJdcgscnDpl8oROBfjOIaYxL2sIfGW69FPQPTVgBaerillF0jPSRJ6i2wwQdUjVcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

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
 include/linux/memcontrol.h |  10 ++
 mm/huge_memory.c           | 258 +++++++++++++++++++++++++------------
 mm/memcontrol.c            |   1 +
 4 files changed, 192 insertions(+), 81 deletions(-)

-- 
2.20.1


