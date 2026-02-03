Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13ECE8783D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1BD6B0098; Tue,  3 Feb 2026 09:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F366B00B6; Tue,  3 Feb 2026 09:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BEA6B00B7; Tue,  3 Feb 2026 09:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA5D66B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:35:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E734C1D48
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:35:22 +0000 (UTC)
X-FDA: 84403393284.24.D37717D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5B21C0008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:35:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ckCF3gUV;
	spf=pass (imf28.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770129320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tllAnUT8mlRJORGwuMqeNqE59/4Exx2o4EGdpPTdzWs=;
	b=PPWr8Hw4f3UTFA6isiFjYfg852F9EyFgipKHWBmuj3SFiM9VO7WADkbJO6BYZlL9JC9eQL
	NGCvk31KRYcbEcwl6h3tL5WdSXrjYe257PSXsdGTJtDrz51y4OoraUudxTjCuL9BAFFbBs
	iTQ851zkVD7A85OGpu5bm1gF6VmRgD0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ckCF3gUV;
	spf=pass (imf28.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770129320; a=rsa-sha256;
	cv=none;
	b=hOgyd4afFWqnHGCYN03rPNdf3ebYoKLgvyOa3NYLePNy90XKT2UYoD6lX+MZhuuA/Md/u0
	J5n3vQcRpt6OI2gqSkzlfQEq1YxVHOdMB21HZZk80k2lnzLEgYbevZzp+OAxIyn0mQJ2FN
	85lStRjjS5zb7w6Dq/ZkaLqg9i1MGvM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770129320; x=1801665320;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gHhxN6CXwkf40kYnaBa2r/QM0E1cp8eHB6SFVk3SDEs=;
  b=ckCF3gUViI6BlpuSWfhqgC+TNg7LkTu41jCGAxPmAGqfwGMzIgF7uoCC
   muA/Gq/JWb9KDVqXY82Kri9pk8u2BjPgWY5cHsHdfIZha6NRYvsRYYagw
   98YGwAu2f3V/m7/A7sSbVxMjCaTQNIAF1bIsJPLXdC3kSKlQku4caFsM8
   Cic3iJUWgsAxx4SgurA8olFGBpfXdPYcPT4da+dPWB1Fcu6pbgxOrLGCG
   04IlMvd8E4MND8DV+ap3ZPN8i1shX/Hi9LZ8Hx0xu1waDGyeCF4j6j0Q9
   fHMwBlgVSlt0vZe7rZ99TMwDDe/N1vgMETJT+BQyFX+0er183xpm/+MUS
   Q==;
X-CSE-ConnectionGUID: ntICuo4UR/CQ6pw+8oSuYQ==
X-CSE-MsgGUID: yaEbKj3kSsiiCsx/PSONkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="88722756"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="88722756"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 06:35:19 -0800
X-CSE-ConnectionGUID: ZwOGZvpDT8mZPEX1B4OqYQ==
X-CSE-MsgGUID: lxzhFc3nRnyKll0zH2HsWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209574218"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.55])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 06:35:15 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org
Subject: [PATCH v3] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue,  3 Feb 2026 15:34:34 +0100
Message-ID: <20260203143434.16349-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: hfgatjh6e4na1rykkwj8zu33g6tc4xh4
X-Rspam-User: 
X-Rspamd-Queue-Id: D5B21C0008
X-HE-Tag: 1770129319-489894
X-HE-Meta: U2FsdGVkX19JSYRqcnUCgYiVxbjlVERK5tIDxASL+a9H2H2sSBBBKRKnV7R7tukKum8K6YRrG1ei7D0bozLk3JaDmD3T/to/JdGwlbCfoCBjNOkDdE0mX9Cg8gz7jm2kANKWVBIbQCWZLnFZiPWP+TETwAgIF9PCh4hoiuJHWn2DLcoSHNpzn2s8kKTFb0k4zbsWb91g3jKqpn6ARL6/ITrOJMOKAqBqid89zrpVtEErtcPKtJRgcDMonQHeiobqHesSU4auxGe/FkQob3Tkkx0PPsIGmz51wmow7pzFSpA1EZJr1wPeVbZyDIdsuNDmsykqmvwpI2bYqT0lli1Jza1XQyGD7Q0M79m5QBcHmX3VejN2vd8SLUsye/4b4uhYWzj19JsHqSLI0Tec6VSye04EjOQ2jrlP2QTU0JjPfkuuDphMr9hfnCf8wmtAOQAxLH+sPJFh7W8OXu/wbMrRJYponSZexDz7aqwZ4csxfGPejmqPCVmre05QsS7mQw2U4rr88+lSoeeEOqAZdmZxvKfVRAfmqJuRbD15vDhUQj0UIRBkT1vuEditoNjL3NT6z6ntKS3+8FHFMjdeb4XH7CrQNHVvu3aF05XMvg3lWI6+vhrw96Tu/vsdUPSHcGN+WjYhBOepJn/VgGWOUaAkg5VPjSczjzDnKNdoZ1QBUUzxxp4yVHm5hzVUIDyR1J0Y3EtUiULNrj9uT5wlWYy5HR9wxkaOc/01be4QC/ZUOaUHyCjRVj+cdZ5teIrV2f69HzpaZE2ORX4nHrEdUN4JqvT9HxAb1ke0Qm9Fx4Poi1AhOjNqMxqy6smhX0LbNsY4yaobBOfJl+RePrFErRf3q0MpMF0H3OUW
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

Resolve this by waiting for the folio to be unlocked if the
folio_trylock() fails in the do_swap_page() function.

Future code improvements might consider moving
the lru_add_drain_all() call in migrate_device_unmap() to be
called *after* all pages have migration entries inserted.
That would eliminate also b) above.

v2:
- Instead of a cond_resched() in the hmm_range_fault() function,
  eliminate the problem by waiting for the folio to be unlocked
  in do_swap_page() (Alistair Popple, Andrew Morton)
v3:
- Add a stub migration_entry_wait_on_locked() for the
  !CONFIG_MIGRATION case. (Kernel Test Robot)

Suggested-by: Alistair Popple <apopple@nvidia.com>
Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
Cc: <dri-devel@lists.freedesktop.org>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.15+
---
 include/linux/migrate.h | 6 ++++++
 mm/memory.c             | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..800ec174b601 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -97,6 +97,12 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
 	return -ENOSYS;
 }
 
+static inline void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
+	spin_unlock(ptl);
+}
+
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..ed20da5570d5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				migration_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret = VM_FAULT_HWPOISON;
-- 
2.52.0


