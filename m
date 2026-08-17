Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09515C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4B76B00B5; Mon, 17 Aug 2026 05:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17586B0630; Mon, 17 Aug 2026 05:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF036B0911; Mon, 17 Aug 2026 05:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89DCE6B00B5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:03:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1943D1A06AD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:03:54 +0000 (UTC)
X-FDA: 85110173988.08.E07D7F2
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91879100003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:03:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSpBKF3J;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786957432;
	b=DOgK2tBZWzASOTx5uxYs8J30gWnES4aBentEtXe2tE99BFkODJ/V9u0lhYX8RYrXSzEkcv
	Dz2Qui5/jN5b9o6TSjJxJxd/ZFsU7gLjIJVZTNf/JnGnrMqap4RPE8Dhfi86pz8VYsCVwo
	8atEOUtI1MN9R7dHpOSgxJWDt1sHR9g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSpBKF3J;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786957432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J+YC8AfXQb9CQzr0TmDg6PXrV8b4l0gk5qTznpe9zjY=;
	b=dFYV8iAZa3af4RY5pcg1pkS0fdIWYlz1wWRKdWa0xQ0BfwXc6Ky32xYG8JRf++d0i/uHSF
	qSz8Yd9J6yl+VgMsqBlkxzrf1zOP7kmIHdGdEPSygKqHt6xmdeXbVpJ3SWsf1kKXDSlaf/
	tTNX/iysDsFUfnTeMWOtBmiE0pXH5Sw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XzgGDt95Ipn1L8wXhdHD0C7oe53dd7o0MUGLso4B9JU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957429; v=1; x=1787562229;
 b=lSpBKF3JovltINNhdlyBHQjQpmDZC7EaVo3BtitgSMa01vBkZhvZx+btVWx/rCbVZ85GneFG
 1XPdIGQ/Y+G9MCVyaK5sdTxtUqT+fI3chAtFa62CbEatmKJbYdh2l92SChE5HV9z9Tv88wLjI0G
 rBXcfzUI0otCFiI/zglAPWcg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (221.194.171.228)
	by smtp.migadu.com with ESMTPS id 62ddee2e1f4fc43a;
	Mon, 17 Aug 2026 09:03:49 +0000
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 0/4] make unused huge shrinker memcg aware
Date: Mon, 17 Aug 2026 17:03:24 +0800
Message-ID: <cover.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91879100003
X-Stat-Signature: d8cnxsgfpq3a9c3hdearbjmog8w77uis
X-HE-Tag: 1786957430-456785
X-HE-Meta: U2FsdGVkX18vY6faBnuoclXy+OJf52suVUh+wSmdzDbYcLgtUB4R0VkLMSKwKMo22NqV4wo3mnlbzYhVFVeShMk6MvFH7d6bBoNJNNjwzFGO/EOgr6fwHpCP7C25kyc+Mj1hFmL1fQRhCj0pn+053jk1aZkN9sxSX5kMPiVkHNhpA+20JlBUEz0T1UMBsCOgp3k4b3bp354t2YBHNBGKRJg4KNpU3KC//q906zJ0N8e9kmJ+Uv/dYxo2hz7nTRFCZjZEO5NOBdXatjvgmgFssTupYh1AldXltppcYrWrR8w8m/VhCqcRSsgd8qXrAxZSsPOraSmMmlvttrp/AF3JkcKsZ9Pp23AJFCqafDSxreZT119po+6AkcwLMcVNK82RWfDTNwVw5thOw/eQeH4xwNP/LDGuoNs/qCzu8DbmfxBKu5Ak5e7DJUtbjsYcPnB5GEqzkNjCq7ZwKYFRJ3p94rOmz5qpEJdfcS3JGAJXOzc/UlHXcuzphmlp5fdFQTbEtA0iZQA36GdvGARqN1JOcflesFMrqjiPbNILhgWk3J7BBjnQzPV/NxehqrzpP8eAov21ZtHZMcd+SdCV1lqHqqJLbfJfEA50BCAp0Ae29t0T/8cdZb5oDj996Fbh5vnLW51iTuY9syFlDsMNHn4NbzJ6wWLbHX7kzs5U5yXXMZ8Fk328vXCRczGC0gJTFWMwbQ0uqn6pthUQucf+rps9k70v+4xuBVxPTUyMrunT73fPoeB7JeKASmpYJBGt1FSv1FjMvs+01dG1jybEGPIou0r9WNIAdqcLYGLtqFmEqF7cq/vztp6dH0tbR6M9UpBw09MlAFpWxVPvn1hng2R9N0l9BW5WWzzptKc1IllidSn1U9qFOJrSQcUHzSLm9uB3F/RV71hhkn8qVUVoTeaFok/W7ile80v1/9CtCS50Frxz2BntdP/H8HOo4/SkFcGp1H8Ns/T7xv6bC6Blky/
 BPRoAdJ2
 qQ8B9zvVTMeBiuzupWP0vFXcEo1W1TU7YYBEMUCMc7ZLnfTAwenNE//nsrgrVNeRT2bgzot3fReFD7HR9JvYtjHETNkwPbiEgJhGxGrLurN9O5RiT0YmUtxOZ/Z66tB/p/VrFzQUqJUr62HszvofiyW4tmeKhzb1yWUD/1eU9Slp2hBX6ExQMlx2uwZcFswlNwq9GcnK/qK4+VMz0ypRDnu7gIWl8PqFBvn3c/2Td8GqyyLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v4:
 - add [PATCH v4 2/4] to make obj_cgroup_memcg() handle NULL objcg
 - store obj_cgroup instead of mem_cgroup in shmem_inode_info to avoid
   pinning a dying memcg through a long-lived CSS reference
   (pointed by sashiko)
 - fix is_shmem_unused_huge_match() to always check the NUMA node for
   shrinker reclaim, not only for non-root memcg reclaim
   (pointed by sashiko)
 - collect Reviewed-by
 - rebase onto the next-20260814

Note: [PATCH v4 1/4] should ideally be folded into commit 0ef8faff490be
("fs: push nr_cached_objects memcg gating into individual filesystems") in
linux-next.

Changes in v3:
 - add a fix patch to fix missed removal of super_fs_objects_eligible()
 - move the original shrinklist addition logic after all checks are completed,
   and split it into a separate patch. (suggested by Baolin)
 - simplify the shmem_unused_huge_requeue() (suggested by Baolin)
 - keep the move_back label in shmem_unused_huge_shrink() (suggested by Baolin)
 - rebase onto the next-20260731

Changes in v2:
 - temporarily add the dependent patch from Usama to the series for review
   convenience
 - remove shrinklist_scan and shrinklist_isolated from struct shmem_inode_info,
   and re-implement the logic by resuing the same info->shrinklist
   (suggested by Baolin)
 - add more comments (suggested by Andrew)
 - fix missing initialization of info->shrinklist_memcg (pointed by sashiko)
 - rebase onto the next-20260717

Hi all,

The shmem unused huge shrinker maintains a per-superblock list of inodes
whose tail huge folio extends beyond i_size.  Because this list is not
memcg aware, reclaim triggered by memcg A can scan inodes across the
entire superblock and split huge folios charged to unrelated memcg B,
causing unexpected impact on it.

In the worst case, memcg A has no reclaimable shmem at all, making the
reclaim entirely useless and incurring unnecessary latency.  We observed
this in production, where page lock contention during split caused
multi-hundred-millisecond stalls:

  tid 11340 comm scanner locked a page for 182264 us! kstack:
          unlock_page+1
          split_huge_page_to_list+3135
          shmem_unused_huge_shrink+767
          super_cache_scan+329
          do_shrink_slab+291
          shrink_slab+533
          shrink_node+400
          do_try_to_free_pages+206
          try_to_free_mem_cgroup_pages+262
          try_charge_memcg+591
          mem_cgroup_charge+136
          __handle_mm_fault+2431
          handle_mm_fault+194
          do_user_addr_fault+462
          __do_page_fault+176
          do_page_fault+48
          page_fault+62

Usama's recent patch [1] prevents the shmem unused shrinker from being
invoked during memcg-level reclaim altogether, but this is overly
conservative: we can do better by reclaiming only the shmem charged to
the reclaiming memcg.

This series converts the shrinker list to a memcg-aware list_lru, so
that non-root memcg reclaim walks only candidates charged to the
reclaiming memcg.  Global reclaim, root memcg reclaim and shmem quota
reclaim retain their existing global semantics.

To avoid pinning a dying memcg through a long-lived CSS reference, each
inode stores an obj_cgroup reference instead of a mem_cgroup reference.
The list_lru add/delete paths resolve the current memcg from the objcg
under RCU, staying consistent with list_lru's own memcg migration on
offline.

Thanks,
Qi

[1]. https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/

Qi Zheng (4):
  fs: fix missed removal of super_fs_objects_eligible()
  mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
  mm: shmem: move unused huge shrinklist queuing past the truncation
    check
  mm: shmem: make unused huge shrinker memcg aware

 fs/super.c                 |  18 +-
 include/linux/memcontrol.h |  11 +-
 include/linux/shmem_fs.h   |  12 +-
 mm/page_owner.c            |   2 +-
 mm/shmem.c                 | 382 ++++++++++++++++++++++++++++---------
 mm/zswap.c                 |  17 +-
 6 files changed, 315 insertions(+), 127 deletions(-)

-- 
2.54.0


