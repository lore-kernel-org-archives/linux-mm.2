Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A9BE6BF13
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137E96B0089; Fri, 30 Jan 2026 09:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6046B008A; Fri, 30 Jan 2026 09:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09766B008C; Fri, 30 Jan 2026 09:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFEC86B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:46:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71263C1B9B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:46:03 +0000 (UTC)
X-FDA: 84388905006.18.B339D9C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F301180012
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:46:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O0fkowIi;
	spf=pass (imf16.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769784361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jdtZ3CrFCUwNzoo/461chti8/RrK+3UlPc6ItYoFBZc=;
	b=Gf9McnrOO7KpvZHjKNiXD3hkFy1Yrc2a2HSxm1m/YCY8pJPEu79F1UQBpo6CG5vRuldKVL
	/THHGikgR992QCLP3t9fgVPzXgJmBK135ZQnAwemJOWbMY4/XsXCiAMoGhOJK/FUazQA8x
	kbnGqoqp29HGdiwk49ZHMlcwLDBIJNo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O0fkowIi;
	spf=pass (imf16.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769784361; a=rsa-sha256;
	cv=none;
	b=ukR/3Y2kynU6DnTLi+YHLMucyHaZUsxEm7lx5tqUZBiqYeFrAjOeUJw6wCbOVaq2hr0wBr
	K8NUGBayUfIdPJQNXTePsZhDobdkXgfprH98VI56xpbB/U2ObYPgtYuUny053t521SlpV+
	Sz7F9NRQSujRh0TVaNTdIIYO27CuI44=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769784360; x=1801320360;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=15Hl+K7cKkodTSwPvhoZK9Gww0RwmQIdjPmcrj08khs=;
  b=O0fkowIiOLzysmm1Vos6EacA2gn2W0zDL54lIFnawwn+sPNyrI72AMGP
   4BrPB5bUFZq8angbAOdzhjsKgq2lIoWatgLY/KHABUzCcAQETSv93A3iS
   xyrbzfp56MzKSVDfcxgomu5t/R5l3Wte2Sp6VzpJLm0DYYFH+TSH4MCub
   txLagF1Vk7cVSJoqFPXV4QiSFGK3qqonLMVwudhbkLDS3D2EJ18mSPDT6
   s+eWa8AeZU7ir0UD8rpr/NRT/eU8mt5r6uzzQSa/jdIn5IBlKAT4cUSQ5
   5Ko8XtUnrhTVK1YkcMOf1AyBWfUZjxW0ztLKvavaTLRdrZEVQjsE84Jzv
   g==;
X-CSE-ConnectionGUID: 5nqJ/jcDQXWYxtG1EEbHTg==
X-CSE-MsgGUID: aSNgkiIwRL2IRC73lhD6CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="96495808"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="96495808"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:45:59 -0800
X-CSE-ConnectionGUID: XMz+iAomQ36BwmT6wZEAQw==
X-CSE-MsgGUID: dqWyryrwSxaMxaCisrfI1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="209224967"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.13])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:45:56 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation problem
Date: Fri, 30 Jan 2026 15:45:29 +0100
Message-ID: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F301180012
X-Stat-Signature: 66uequs47nxkudgnn7thhb8itgr74muf
X-Rspam-User: 
X-HE-Tag: 1769784360-233135
X-HE-Meta: U2FsdGVkX1+GjKOaYJaHLkd7jhdjm595ewEt4plqX0q83R7qD0+3pUBqmcDtbS8VsBdlCvd00MiNMO3dyqWsvESy3abzag6+K7u7rRKAePc05vtk4BW6v7cx9/oJXZC8T5uEiCn1C4mI+RdKjobq5WNQHg9ZypfERvMzTxtMTvQV9f3bkDYpjnBBxcJw3IO1I2NhHh6zwBslEKP+Euf9V0uNFdbtJ9UI9wHxXBdaqot96Ma0sCc1h681iDnnM04lG2q6I+Lv3yF1x2+TqQ1r9z2AS8lgV4u+LI+8+kIOd9rAlVWcZ6RDhGVik8z+BnX+T592A1ZNZmJdU6yN/uHq3JyC5yQvPkxKOV6L669In/sVpBPbX9HIMoxDeGYHqkdx28NybMSRq73jMCI9dsqffC6a/2IIDlg4GaNnOOfQ5LcuN7FwpdJfGOuyUkNFGR5MZilSFclZlebPsLqsSQkyieNkkix43jK9mehpxZym3NMDwLQfe8mR1i+M6FnMk4GBU6eqDSC3/dfAtGLFAt6AAbb7nEnRG4fAY73vpCX6RKQ2G/Dpv/smQ7O70zGmJ0X+cV7j/VJthuMZYuZWR90aeHAavANuzkIi/W3iJ3lVy5nlF0T09hhrzWo0bpfg71vay7S9o+Kw2g8/sNRyy6NBWW2sxwoY/AOvJbS9M9h/6/L8JwYYVVUVUX7lv559pUCNwXmaI8OxPiGO5zloyrx8JwwbEH+nhLH8kVGkzlbWWXioduevl4GNY3triJeyKGnkyDDPq+jTSCUaDgXeS+mGUy3YQgZpGA42hs6FKDfY7dGXjbx2WOTnW3HRkFMe/g2XzbRKe7Mc5Sk43EYqp9lbV2JgCJ4Wcflb7M16q1eDuTKoX5YwaIZaBeQ+XvrQ6iMcnzZc7bNPPji2aTaPiIuyFM493kAM8fPL+Znmf6SHjsSCaS9ogZ9xsrjUbgodSXoD8hLOMiOaEOAvwmL6UVZ
 L9qitUWw
 oTUINX0LNTpfYQNMAkv47tAo5k+KMseZQwkDBz0B3kSDla9XVVVzfWGawVMDIKFZez5SL6r/nF+lgeJ5WsuM/cJSjsJfkZ1bAgOVrtr9AUSgzfQ9Bu9qoocgqtTu2mLBOcqwxfTs5OWaaBJEud8JRYJITbQcmLz0JOIbHsBBv2kqRa0nqzjFQAYiebLq23owP2Di/FNi3L+JCnK6oTSB1a2Dedka9qwQiu41vX4rx1PrfIaGmTV7EHw1nm+CAdrPllD3mec97sbgtcQsCKYjU+fdqgpHXlHBxuX5XZk5N5uep4ooyaMU+KeUlumXfOKJTKa/BXtmEK0RmFfRnLcr6tlhJKCJFHA5F46lkjg0CblMhhgh43RO4vI95fBF4BW6u+z7i9B2CQqBxSZEZ/kAAtQ19gnHrh+TUrAWE57fWzzVU9l6cdaA/U2nwM5jZg1x88qHmfND6ZA9x9lcRUZ/59bBfmrDa2yZKcaH78IBRQT3uN4mY6svPwGfdDClIFSPFamqY8NaTwueW454BEC/TtoxoI1FQVtdK1LhhA+ZpK1VM+CmaCeAQTUa1WzJfd1c9gYaGNwLo2KEsJVUNW8G7GhfBB+MDvlKGm9hgVIDIVgAmme8/roHygb5bj7DiqXWRchQDRbpP5Lc8pOx3M6itI2fnvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If hmm_range_fault() fails a folio_trylock() in do_swap_page,
trying to acquire the lock of a device-private folio for migration,
to ram, the function will spin until it succeeds grabbing the lock.

However, if the process holding the lock is depending on a work
item to be completed, which is scheduled on the same CPU as the
spinning hmm_range_fault(), that work item might be starved and
we end up in a livelock / starvation situation which is never
resolved.

This can happen, for example if the process holding the
device-private folio lock is stuck in
   migrate_device_unmap()->lru_add_drain_all()
The lru_add_drain_all() function requires a short work-item
to be run on all online cpus to complete.

A prerequisite for this to happen is:
a) Both zone device and system memory folios are considered in
   migrate_device_unmap(), so that there is a reason to call
   lru_add_drain_all() for a system memory folio while a
   folio lock is held on a zone device folio.
b) The zone device folio has an initial mapcount > 1 which causes
   at least one migration PTE entry insertion to be deferred to
   try_to_migrate(), which can happen after the call to
   lru_add_drain_all().
c) No or voluntary only preemption.

This all seems pretty unlikely to happen, but indeed is hit by
the "xe_exec_system_allocator" igt test.

Resolve this using a cond_resched() after each iteration in
hmm_range_fault(). Future code improvements might consider moving
the lru_add_drain_all() call in migrate_device_unmap() out of the
folio locked region.

Also, hmm_range_fault() can be a very long-running function
so a cond_resched() at the end of each iteration can be
motivated even in the absence of an -EBUSY.

Fixes: d28c2c9a4877 ("mm/hmm: make full use of walk_page_range()")
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org
Cc: <stable@vger.kernel.org> # v5.5+
Cc: <dri-devel@lists.freedesktop.org>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 mm/hmm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index 4ec74c18bef6..160c9e4e5a92 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -674,6 +674,13 @@ int hmm_range_fault(struct hmm_range *range)
 			return -EBUSY;
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
+		/*
+		 * Conditionally reschedule to let other work items get
+		 * a chance to unlock device-private pages whose locks
+		 * we're spinning on.
+		 */
+		cond_resched();
+
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
-- 
2.52.0


