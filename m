Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B334DCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F39D6B00B7; Thu, 21 May 2026 11:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB966B00B8; Thu, 21 May 2026 11:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1F46B00B9; Thu, 21 May 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0FEF6B00B7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABB791C0508
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:45 +0000 (UTC)
X-FDA: 84791746410.21.28FFBF9
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id A043AC0003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Hpthu3i2;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZKSDVbt2wf2LKZOjAtZQ3O/kSTJ20V0dNfrjFrOApYE=;
	b=g/8vbdUmzLFok50obwSOylBP4ErlmpP88jk2iSX1hkVujh+GmPJX01NMSXQx6WbRudZfL6
	edann3sE/LuR+zFzb8ZupkoIX+6KqpSfe2X9ZVXxHqshThnz813tY+KyzbEQmyv+fSgHNZ
	VLUJpSKxaX6Inj5hus/THM6jY4tSI/U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Hpthu3i2;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375824; a=rsa-sha256;
	cv=none;
	b=HJavnfnu+InQaCylcbdjgbwg4KI+RWAg5DfN19mzAZMPcD0mPUmPT5X6a2t2DhjSjP8m81
	gA+NkAJbvmENYruudOgjvgtcPiRAxOSKCAs/U59vGzxJfDLL4Pz29vxqlHQrCSDkW+/e/B
	XtnxacdrWKA2mZV03BeUiO4pnwZbU6I=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3697f25d26eso3208111a91.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375822; x=1779980622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKSDVbt2wf2LKZOjAtZQ3O/kSTJ20V0dNfrjFrOApYE=;
        b=Hpthu3i27uAHmkeQmlmRUQyEU3OR7xLbuKHYdfYobvvdIc06WtenhTT/xEjPWgeCEa
         6+/Z0I7tUib4YyeJY2zWBdvOGAOcgzklPwHmqmRclQOdrUPQxbceIiIIhTHUTKck7eNw
         3LPfu4hzOX26EtbR/eYPTMUE6ZYgPMOd3Gkp/AOUSfs33cwbVZRDyYTePKFhTIGz4UoW
         HgwVrUOth/ijghB1TaSiXEN3oV3ZEwZwNx/p02t6Qd85+1B5BbRtsK/J1bHdCUz/1D56
         Jq+ekU1vP8qq+mJaUBN0YUgFMqpxFe8v/Adh6BpX93qoVvH+nwrBKcMY3EUuc7eG81fi
         b5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375822; x=1779980622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZKSDVbt2wf2LKZOjAtZQ3O/kSTJ20V0dNfrjFrOApYE=;
        b=iLieFnv29ceK3wZ3pGyEJkhwTVpf6aJVA9gPgfLMGdFtVEcZU0+6dmEdUGZk1vdSyZ
         k/UtirkxkgHGshfVdtLOrUwg3s4uSvcEp466tyV/8Va76RBskyuIT42gEP7bCs5kGb8N
         n1tNyKnnY9wdFTDPu1+O2PrNumQe9IDIURH4O5Q+wOwMbgnP1NJwmStqJaM0Ms7KSwkG
         LuKknbpepOe4YGP7C1IDfCxoxmLlxLZeLib1NfkefpBgFmPPuM/Z8PPnniLGPojc0I69
         myvobOCDFLEoOMe6fFUUMpuJHnbh6WJz/Jg2Gj9bep1oMiKVyuzDk7JfqvcMXsRRSN/W
         CNTA==
X-Forwarded-Encrypted: i=1; AFNElJ9G+xRSkuKTqjXnsxj/KhYjngfxt7G0KuG5hwwEKgyUKhArd0Cl8vBfSMsTuoM8u8D90ODl+8YBqA==@kvack.org
X-Gm-Message-State: AOJu0Yyw0scGtMujTGDnIEcWUvBXzvTN918S4ELAEF0MCYEuGqgXeJU7
	9/yik6oYXIv/zB+C1Gzri8HCg4K+FY65bmBbRhHJLkOC3sh9RE7xxJTtc3COKWyg/BM=
X-Gm-Gg: Acq92OE8P23BwQ61V22pLT6xIZrXVnCUjGaKKYEv/XFAGPbR4GzQ0+PXAqX8R8pITZe
	p19qHn7ZAWD+OYkfMflZOHGBELwKg46M9OnKGvveaptohmuaq5TnhrlN/2Q6X4wz6dU3HTED+T6
	nnTztgVxaF+SyfspKzJnTTs38K+LSwzHzd4GXQGAH+OX4aYI0veNyClhGDeZaow/hHUTS+DoA7o
	K7kAy1vgtTqsYqGB3/eK/jafcBb7iQ+7YTfShd2v6sv/EER6MR429BdT+2tnRUNdos7zTs7ulyv
	iznCXflnNseEQ0gQp5I00GVyAO7K6rg9RhHbndCysM3hDSsct0HkTmKcD4PIWPSexvgHaAKCXId
	USDQmhb1klKUDx/aj8eNfg0+afNH/Vo+T2ff2JnbPim3GjVsRatGz7Qk4Po3xkjSqKEirtxteK3
	syG0TLQs22HBH6z/ysakyjva1djWO+7oEt
X-Received: by 2002:a17:90b:1348:b0:366:7dbd:cd50 with SMTP id 98e67ed59e1d1-36a45c6950amr3585113a91.27.1779375822054;
        Thu, 21 May 2026 08:03:42 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914abcbecc4sm107501985a.43.2026.05.21.08.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:40 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/8] mm: switch THP shrinker to list_lru
Date: Thu, 21 May 2026 11:02:06 -0400
Message-ID: <20260521150330.1955924-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A043AC0003
X-Stat-Signature: 4nek4jurccnd1q5n5osymaxubztrzqqi
X-HE-Tag: 1779375823-25641
X-HE-Meta: U2FsdGVkX1+gFL1bUj32fUNCMqYq9YWUMPiQ+kALY3z1NQXheLRl94Nk457HHvvFSBizez4SqOdCw+5biEtBo5zfV9eny37AStqzGUdLn3WEAQZSTgZFiIflOrGPUxQCENncDFTeMWWjEEVKAvqU8pitVoFJYh4j9kCWaLPmQZPoNMke/u9Un8T3Uz317SWd6kgmefC3iiJeY+kvnxKyBV4DQEa4ZFLvTzq13NbS/OivmBBscEjNNTYNw8moSZRSWFlFPOm/S4TqaHKHW/bHI9gzHhu8hgssB69pl5DGhGUm3U5cKsBzJt/gI3nO1/o/EYCs3R8DgHHctgJMffzbJAzJ5TTQjYJ1FOF8rQnef6DDPVFAVewbss9cOZ+1vs9ZElTJoWxnOc24QmTqGnhNSyxByosQMmX8mJiCotx7oPs7F5rnCIMWgrncQLFBqEu2+eNWFcvf9xOCLjxLFzy63MHBYz7EfXeYPvEOYfWicjGD0ku+wQZQPRjozCbQukHgsWzwb0y24VA/JeaCOKt1ieXTMaU7DBhMgclDkko/M0aiX3KTgHnTpRcKLJMCKQmP0TnMBZlMJ3o0QZ2sdz8C9+1pOVXFCulJj4lxBKP00aJAjHzc+roOTDDZoHUOpY8GnUTf/4poqOcozCKsKX2z5A5CqRzJAS6siHpJsyG3K/GWO8EK2kbimIklSW4rSK4zpOC83Zz9SdSoeGYDcWjQB6tDAXV9iHXj0OtlOsvXmQ8MKYRSfg3bE6t5mjlzjgI1purZp47E66hIVxVQr6xoO4e28svdw4ceHtkOLsBg8fB8mdgI1+VS8gL6JH/Z+L+BRV2j8WmvXYOXzlGtt4Ex7Sj3PwsC2jxtba/nPyzkIzHSpyERHbWIrHuy7DqHJAopLx+eGCQsDNEgbfifbatAAUbh7jMK4vPB2+j6f+j5VPOQp186KQCozR8cNMaCKt/GUW4nEh9yktCMb/+P2oV
 AS/LAGmo
 KEEmdPynTuWzQ3qtXl5S9Owf5Ktd/0x3vIYvn+RPby8hfj/EuXgOdkrOVku8mfLLvjUe/J60guskYsR434wpzcDRfWyPYJP2DwvrX7OrB8G3BqUQakjE4eG7OoTZvbhFj5PwP0bdsOmvr7sO/y2EPqrUQxtYYvFEjurx4fdLwSpJy01zlRxCIjJW17SpnWQsNooNrh8Y4hJaVvxwMwYI5JWd7Ej+3FI8pcjYLwKtC/PK/qtQyoK+GzONQ3Mrqxf9kZ6g9YYeI4GKihPJN3qrf/7T5Q1OjqeswxzZU5V/7oHOn8qJa44Qg59pNlv/3qW2FexBnG7yy1cYuDkRuj8sgQw2oIGyhvX3pVv4mUk8RO6CmxigPuJAzpZqZJG66al8X16EWJ6R9lSm6nomRkT3xwFQbH8wIo7QAMTLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is version 4 of switching the THP shrinker to list_lru.

Changes in v4:
- guard folio_memcg_alloc_deferred() with mem_cgroup_disabled() to fix
  NULL deref in __memcg_list_lru_alloc() when booting with
  cgroup_disable=memory (e.g., kdump capture kernel) -- reported and
  tested by Mikhail Zaslonko on s390 and x86
- flatten if (folio) branches in alloc_swap_folio() and alloc_anon_folio()
  in a prep patch so the list_lru allocation additions are a clean minimal
  diff (Lorenzo)
- folio_memcg_alloc_deferred() moved out of alloc_charge_folio() into the
  anon-only collapse_huge_page() path; collapse_file() shares that helper
  but its pages don't go on the THP shrinker queue (David)
- guard folio_memcg_alloc_deferred() with order > 1; mTHPs below order-2
  can't be queued on the deferred split list (David)
- make deferred_split_lru static, hide behind folio_memcg_alloc_deferred()
  wrapper with GFP_KERNEL (Lorenzo)
- rename l -> lru throughout huge_memory.c (Lorenzo)
- kdoc for folio_memcg_list_lru_alloc() (Lorenzo)
- list_lru_lock_irq()/unlock_irq()/add_irq() irq-disabling variants;
  use list_lru_add_irq() in deferred_split_scan() (Lorenzo)
- reorder shrinker_free() before list_lru_destroy() (Lorenzo)

Changes in v3:
- dedicated lockdep_key for irqsafe deferred_split_lru.lock (syzbot)
- conditional list_lru ops in __folio_freeze_and_split_unmapped() (syzbot)
- annotate runs of inscrutable false, NULL, false function arguments (David)
- rename to folio_memcg_list_lru_alloc() (David)

Changes in v2:
- explicit rcu_read_lock() in __folio_freeze_and_split_unmapped() (Usama)
- split out list_lru prep bits (Dave)

The open-coded deferred split queue has issues. It's not NUMA-aware
(when cgroup is enabled), and it's more complicated in the callsites
interacting with it. Switching to list_lru fixes the NUMA problem and
streamlines things. It also simplifies planned shrinker work.

Patches 1-4 are cleanups and small refactors in list_lru code. They're
basically independent, but make the THP shrinker conversion easier.

Patch 5 extends the list_lru API to allow the caller to control the
locking scope. The THP shrinker has private state it needs to keep
synchronized with the LRU state.

Patch 6 extends the list_lru API with a convenience helper to do
list_lru head allocation (memcg_list_lru_alloc) when coming from a
folio. Anon THPs are instantiated in several places, and with the
folio reparenting patches pending, folio_memcg() access is now a more
delicate dance. This avoids having to replicate that dance everywhere.

Patch 7 flattens the folio allocation retry loops in alloc_swap_folio()
and alloc_anon_folio() without functional change, in preparation for
patch 8.

Patch 8 finally switches the deferred_split_queue to list_lru.

Based on mm-unstable.

 include/linux/huge_mm.h    |   7 +-
 include/linux/list_lru.h   |  68 +++++++++
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 355 ++++++++++++++-----------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   3 +
 mm/list_lru.c              | 220 ++++++++++++++++++---------
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 ++++---
 mm/mm_init.c               |  15 --
 11 files changed, 374 insertions(+), 376 deletions(-)


