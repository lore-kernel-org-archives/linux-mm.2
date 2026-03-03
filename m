Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22DAEC1447
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DFD6B0194; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB3E6B0195; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD916B0196; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 798176B0194
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8A7A1A0176
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:34:59 +0000 (UTC)
X-FDA: 84504847518.18.946C82A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id B640380013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:34:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZP8bR6GR;
	spf=pass (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772544890; x=1804080890;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1GaiZTuDfVhGhx6tbOxiTmG3pWXdz7+ENfgkY3MPElM=;
  b=ZP8bR6GREUFfVsahNtJTy7EJ8s9gokYfCa2KQ+M9YYqw/WzQf+NF4jwp
   lyrbqmj1sgmbtodAomJR8AEYLZF/TY1sFVwe5BnLY/hd8DXXF5g5/0Gec
   N+h/txFBgt2wDKfpG9kqZzOkISo10A0tUN8EhGKjxsWzA3A3h2/LyjwXy
   LgFCKoySJV92qrnj7xv4HK47QPkys3JAGugKJOcndo3se1iN4JN7RCBaC
   SpMZsVmBAGeBcW8bLErshX0YoVmka7Vf++b6zm7ZCklomci+vbUoXvdEe
   vRgEp2U4NOWPMaP03C9C5Lw3FjoQ+bfV8Qo/kDomHhZH5/LFnlwBhmuA7
   A==;
X-CSE-ConnectionGUID: ISEhj/PjTS2UqvKXGrIwuQ==
X-CSE-MsgGUID: cBbhi3nOTb2JGYN2/M3omg==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="76179715"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="76179715"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:43 -0800
X-CSE-ConnectionGUID: HGe6hFJdSSOzeCRHBtNHNA==
X-CSE-MsgGUID: PxND/fVURbyfhiOrm2gSog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217947861"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.243])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:38 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v3 0/4] Two-pass MMU interval notifiers
Date: Tue,  3 Mar 2026 14:34:05 +0100
Message-ID: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B640380013
X-Stat-Signature: sxsy4n46trp63rdkkuespf1f147s11du
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772544889-63546
X-HE-Meta: U2FsdGVkX1+Ogk7HvHh7YeIgJvJCXQUJaJSnrSYRRa0noFrucEvnamtNxOzCJhOvpOoBtvPRkUZ6IKUYFMgeGZwTOu05u6WOQKI85umarQgcM5unkSawFTAzaSHM0b94ogb4QsqQogLbMa9pxdvOcdD1Lj2/8ops9EqYUYVT62LpLlGgANPmyT7MzQpei4xe53ocC6RvHBPsQfYatBSww1kutCMpQ0e3o9hnayzBJvWp3H8DglOXqBTSgRMLSD1Ixwshzc6SczYoiiIXMG0UQeJnbqrBrXiSjFG7Y4t8B2NdbOKbGv6CMq6WfvBki2hCZWPb9VHE078fllqZrO4Sx5Gex9+gwpmjVlYOFjq4LvCCWhxgwx5lT2fHJa/yQIgWnYnbafBnpBmUN8cE/w2DNRxcKlPX8EuFa+LAfZqAdmkGG7CD9ZzFfFSsTFfjnCsG2IMBRGHo/hZqZoQZ5r6dnpMrMFYJ0IzL+xT7RBZjECoQ1082h/0tyB7FXIHT+boeI7B/aTGm/94SmhoyFweWFoRxahj6bW5BrFOI4h3FQlA4tp8E0l/Ru1OvfKGm9+HEt3sjV2gLtEw0tdETjE3NU9pLIMgUMJT9tUItrbJZXElvuaCBvLWahLtpNbuKeJcbLJZ6QwV1nvVJmTJRpvVBaqvGgnu8g2JyDzo/5d47yQKpdC0c8U/g2ZzGY2RqOvds5b69U45jun+ytA/gQaJptR7+V6IJiUqDaJZ1qggrxn3FamQ3Z1vLSvtYyBvbvRQYijt5SfW/TH4irLFtFSl5z0PUWwSn7k/sWkDMwxlPFWsgFSYRg5e+uyDOaY+aFysF45UgvEynXAtypdfw0WSuu36sBdETFdiM26PQfGy+VP2DEJvZJ1/U3xjfxNHpgDaO/63l+eFyW80Jb+dj6HxUq6iPiCYtLqqSy2O9R4gDntoBsOR2Bh6Y4z0OUzynivzfzWyn78MPFHLW3oiNpq5
 miA2vyoZ
 oM4AGYL+beDumCHC3F2eXdUBLtmyeMCusCDBuoujzutoTx/HxwZ09WOcBz/vo9LIPcWB2GYDntQpYTzVRZElTkM1+F98YwVX7+BUlpJaPG1xwaTCN7WvsfTOBncYZdbz3T50mkZiV6A3Qo0NtVUlx5ZhrtJsIIaUODoxQtwFkkEqFIjDJiaXvnn9+DUlkZ1bqdf6U6vdgFMHCiOPAaEAX07rt0pxcMz/QNT1mgu+DwNkFw0AQ7eVbtXal3wMK1Z6HDy/bYCIke3yA4FVU9Rryn7Dl2UaDKNKkKAJbN9jD3ctH5NzhganXWdo20dMteBFB69Qg+N6LETBTI1/RJaNl1HmPHK4MsX5KqTdhDIg0DOsb5Fd8rIDpBY7szUJMMO/s5bF/tFXkee8UZIQP7iQYys5uSuTkxOmiSsQkoH/gmvhwQGCpswIyuEr2SsbFtX8pvfAiOzReQQx1UpfEdqFqRWNvrseslguRpsOi/IuIwzTTbC7lMgE8oCLpBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GPU use-cases for mmu_interval_notifiers with hmm often involve
starting a gpu operation and then waiting for it to complete.
These operations are typically context preemption or TLB flushing.
    
With single-pass notifiers per GPU this doesn't scale in
multi-gpu scenarios. In those scenarios we'd want to first start
preemption- or TLB flushing on all GPUs and as a second pass wait
for them to complete.

This also applies in non-recoverable page-fault scenarios to
starting a preemption requests on GPUs and waiting for the GPUs 
to preempt so that system pages they access can be reclaimed.
    
One can do this on per-driver basis multiplexing per-driver
notifiers but that would mean sharing the notifier "user" lock
across all GPUs and that doesn't scale well either, so adding support
for two-pass in the core appears like the right choice.

So this series does that, with pach 1 implementing the core support
and also describes the choices made.

The rest of the patches implements a POC with xeKMD userptr
invalidation and potential TLB-flushing. A follow-up series
will extend to drm_gpusvm.

v2 hightlights:
- Refactor the core mm patch to use the struct
  mmu_interval_notifier_ops for the invalidate_finish() callback.
- Rebase on xe driver tlb invalidation changes.
- Provide an initial implementation for userptr instead of drm_gpusvm.
  The intent is to handle drm_gpusvm in a follow-up series.

v3:
- Address review comments from Matt Brost: Code formatting,
  documentation, additional asserts and removal of
  unnecessary waits, as specified in each patch.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Thomas Hellström (4):
  mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers
  drm/xe/userptr: Convert invalidation to two-pass MMU notifier
  drm/xe: Split TLB invalidation into submit and wait steps
  drm/xe/userptr: Defer Waiting for TLB invalidation to the second pass
    if possible

 drivers/gpu/drm/xe/xe_svm.c             |   8 +-
 drivers/gpu/drm/xe/xe_tlb_inval.c       |  84 +++++++++++++
 drivers/gpu/drm/xe/xe_tlb_inval.h       |   6 +
 drivers/gpu/drm/xe/xe_tlb_inval_types.h |  14 +++
 drivers/gpu/drm/xe/xe_userptr.c         | 155 ++++++++++++++++++++----
 drivers/gpu/drm/xe/xe_userptr.h         |  31 ++++-
 drivers/gpu/drm/xe/xe_vm.c              |  99 +++++----------
 drivers/gpu/drm/xe/xe_vm.h              |   5 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c      |  10 +-
 drivers/gpu/drm/xe/xe_vm_types.h        |   1 +
 include/linux/mmu_notifier.h            |  38 ++++++
 mm/mmu_notifier.c                       |  65 ++++++++--
 12 files changed, 412 insertions(+), 104 deletions(-)

-- 
2.53.0


