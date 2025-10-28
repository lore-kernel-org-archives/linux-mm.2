Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22713CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8148014C; Tue, 28 Oct 2025 10:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741D88013F; Tue, 28 Oct 2025 10:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609AE8014C; Tue, 28 Oct 2025 10:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 490D08013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7B32494B4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:04 +0000 (UTC)
X-FDA: 84047686968.10.668E6C7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 944234002C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tv6x6GDA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8HLDo8n6coWUrWdqlQjN8qAiPeJQK26USUMmC8y9OKQ=;
	b=Ydv5nsRfqrKyF8v/Ol78O9EmlMCMcW+giPhdzj3Dxis6JfiFnlvMzCrW2ygJNxZXs0DH0C
	pHNgsYGSnhBCMU/lsdax1g7spvLydqdd6ObgNPxnkpI5zWw9ok8gZOOTHPifcrklrUFgVY
	FVWJldv2DcCW5MXoEZNqhxrOzagvZvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660123; a=rsa-sha256;
	cv=none;
	b=Z/kf/r0bF7li0AeBjWOQtAs2dGriBOTzcBtUIqeFPbkSmV55/8EPflyQRGqhTcxh1js1j5
	vbDG0OJ0P7oGkaEQEmGEAJJncFheuNCJd5DbNKWulYy4ednZCprhOIQBeKqCOY5BAgHeVH
	LS0SdxqzwlZr30d6fc1vO9jWAgfqDVk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tv6x6GDA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8HLDo8n6coWUrWdqlQjN8qAiPeJQK26USUMmC8y9OKQ=;
	b=Tv6x6GDAu6ty+Y6P8qlVzDiLQ+tdMFZ85wcxZ9qX6iiFWS45iB+Kt4UVSDQZ3CRi6wczLH
	oaPoIRqMaIdEzYwyyNDfYz76VUSwt+xk2zKcS/ug38emiAeNnfsuzEisrQ2i5P5VbVkVvh
	gV18JBY4odaD6/ihxL5yuVChikMG1KQ=
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
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 00/26] Eliminate Dying Memory Cgroup
Date: Tue, 28 Oct 2025 21:58:13 +0800
Message-ID: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 944234002C
X-Rspamd-Server: rspam02
X-Stat-Signature: j4ojfi8sae5ihxbpcczzzfo6dhzwhaga
X-HE-Tag: 1761660122-204739
X-HE-Meta: U2FsdGVkX1+ukTqZMFhtCtFQzhwoHG1C8z54WfbX91PU7TmJniZWFpkv4JFgMYR0bdqN3CyzQGeGvQHjTYVZGWO9a99BgHFLRlyQw2Ufyvet0/QQir1iEq3CEzLriQTcLjsOEQuCLcThgF7dFoUKHIyNaN36SkPPrQIH/YpZRNuvoSqWc8vb3V8dxc5pdxtiHkS4IhjRguxJ3siruDhXvkKrL1PR44L95iuKJOkqqTF3Iaf6aiT9+s8VMKmSRXoY9KOV7egBhCq95h/g8OLgcGiED3KMGYczRZ1B1nvHQoVuTP9oLZv5k5xm9XC+6FKOvMSzc/k/6xsMrwMuaNXTG/+BFhPoiep31cY2qTmtsE94j92qLyjHrwxJgivZu73PDrdLo9ebA3cFpoACarQn1bLG0mG4HudCfbT1fhlvOhJBLM8G2r6Ibkwtq+7wrj1DajWAefy4v6Er21/HHl85g/+LhkgxbzSTLRtSQ07MbEDd8rToPaCs28sPbGMvvjRpTLRFF7L+vyD4GIUOqOh24XSXCbQNLYEG0LloEyf2u5ibHXgfMzXgYD0cM1em9rrEDzwifZUPJjsd+XNzMYSpcS2cj0xrHx+2n25vjO4q+qSzMSR13qnGH5QOvvjyPyBY6pn2eSgVUCqXvIJuOuYIwHPK4Mr7kwbxOVuKDclH+toIC2p1hOvO02Nz0hVjCGC1G69ERl0/s/fkTqrf3+r0Pe0csZfC95Lz/JeTqwRJHjztqqTCaMhKtKZ/qr6KNKfWrFCeXdoZhcY2GLFdcmdd8IYxqYmknI1v7OX97VBxTs6aH0aYCJ8kMmGkfP180+jNRmpY08CxR3ZNADBEw3WCx6A4MKNpFOyum/cD8eRPPqIF7x4ZVIW2OYmsy+meptnjsHffpE3CHSOqTz/NPbpZHDr4DTwGMGZzF7IYWO/2qdxTgNt+9O3Wl6lMrR0ibRUN2wlyv/NIkigqd96b+SO
 P4UVZQ36
 SVOVLNiHdG0GlnhMRzomcszpSFX9gBayx7G136G24UOvedri0sMeOH89w3E4fZ+X90W6/7Vdgks8mT3qiXQWH/TEG5ohrAdZZTjBE/4LCyu8S0w5HOhwfqggh9Z9sgsVxaHXMS50SIGQBUvrg67hiyxcqrBiKbLuRCRFC6qwuYd74qnUZilj4sLZJlsjAId+JSE7XSyO36itF2S/7Wv9qRGXExkXm3SCd//beDWO+VEZ9sIl8iNODTYm7pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series aims to eliminate the problem of dying memory cgroup. It completes
the adaptation to the MGLRU scenarios based on the Muchun Song's patchset[1].

The adaptation method was discussed with Harry Yoo. For more details, please
refer to the commit message of [PATCH v1 23/26].

The changes are as follows:
 - drop [PATCH RFC 02/28]
 - drop THP split queue related part, which has been merged as a separate
   patchset[2]
 - prevent memory cgroup release in folio_split_queue_lock{_irqsave}() in
   [PATCH v1 16/26]
 - Separate the reparenting function of traditional LRU folios to [PATCH v1 22/26]
 - adapted to the MGLRU scenarios in [PATCH v1 23/26]
 - refactor memcg_reparent_objcgs() in [PATCH v1 24/26]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20251028

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/
[2]. https://lore.kernel.org/all/cover.1760509767.git.zhengqi.arch@bytedance.com

Muchun Song (22):
  mm: memcontrol: remove dead code of checking parent memory cgroup
  mm: workingset: use folio_lruvec() in workingset_refault()
  mm: rename unlock_page_lruvec_irq and its variants
  mm: vmscan: refactor move_folios_to_lru()
  mm: memcontrol: allocate object cgroup for non-kmem case
  mm: memcontrol: return root object cgroup for root memory cgroup
  mm: memcontrol: prevent memory cgroup release in
    get_mem_cgroup_from_folio()
  buffer: prevent memory cgroup release in folio_alloc_buffers()
  writeback: prevent memory cgroup release in writeback module
  mm: memcontrol: prevent memory cgroup release in
    count_memcg_folio_events()
  mm: page_io: prevent memory cgroup release in page_io module
  mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
  mm: mglru: prevent memory cgroup release in mglru
  mm: memcontrol: prevent memory cgroup release in
    mem_cgroup_swap_full()
  mm: workingset: prevent memory cgroup release in lru_gen_eviction()
  mm: workingset: prevent lruvec release in workingset_refault()
  mm: zswap: prevent lruvec release in zswap_folio_swapin()
  mm: swap: prevent lruvec release in swap module
  mm: workingset: prevent lruvec release in workingset_activation()
  mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
  mm: memcontrol: eliminate the problem of dying memory cgroup for LRU
    folios
  mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers

Qi Zheng (4):
  mm: thp: prevent memory cgroup release in
    folio_split_queue_lock{_irqsave}()
  mm: vmscan: prepare for reparenting traditional LRU folios
  mm: vmscan: prepare for reparenting MGLRU folios
  mm: memcontrol: refactor memcg_reparent_objcgs()

 fs/buffer.c                      |   4 +-
 fs/fs-writeback.c                |  22 +-
 include/linux/memcontrol.h       | 159 ++++++------
 include/linux/mm_inline.h        |   6 +
 include/linux/mmzone.h           |  20 ++
 include/trace/events/writeback.h |   3 +
 mm/compaction.c                  |  43 +++-
 mm/huge_memory.c                 |  18 +-
 mm/memcontrol-v1.c               |  15 +-
 mm/memcontrol.c                  | 405 ++++++++++++++++++-------------
 mm/migrate.c                     |   2 +
 mm/mlock.c                       |   2 +-
 mm/page_io.c                     |   8 +-
 mm/percpu.c                      |   2 +-
 mm/shrinker.c                    |   6 +-
 mm/swap.c                        |  20 +-
 mm/vmscan.c                      | 198 ++++++++++++---
 mm/workingset.c                  |  26 +-
 mm/zswap.c                       |   2 +
 19 files changed, 612 insertions(+), 349 deletions(-)

-- 
2.20.1


