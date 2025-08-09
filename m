Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB75CA0EC1
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FCC6B009C; Sat,  9 Aug 2025 09:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27B36B00A0; Sat,  9 Aug 2025 09:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D1D6B00A1; Sat,  9 Aug 2025 09:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81A486B009C
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09276160236
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:15 +0000 (UTC)
X-FDA: 83757358230.06.D287167
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9344EA0003
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d2SI9ItS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747533; a=rsa-sha256;
	cv=none;
	b=ZM0C8Omutcv1ocsFyyJzsQxcfBNntkmXjzKczOBWLUi/qt6FMs4/D7zr/+d/DtwbASyS6+
	7WCCRmkVefTlcrcu1Bh1gf4kQd/RGfNuNpBclEk/h6j4sW67t7oAmcKulWcpFGa+k00qGZ
	GnVsserDjeq+jqsna7i1gxuJCu+CJoY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d2SI9ItS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YWMrDXmZCMI4d2cS+nPZVvxE/SwrYSCjeGzzWjJl+qU=;
	b=HKkrACU+k9QbM3Wzungha35oCdGsAt5vyLtknmWq3hygq+fUqAHbBgCe2/drXZbhpvQ2NY
	2vKvbzv/prJTCmYx5Bby2Qbg97I9gNA7ZHPDcQgFPY1h4UX0ICVx3j2x2Bzq2RG/SeqQ3z
	/IpW6Yu7MdMoseZQGgd39XbA25jYb9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747533; x=1786283533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q1E+6movKrkbWWn1YIxowCcpYwpJzZ4S/2KgkpxsTZ0=;
  b=d2SI9ItS7gmjCq1NdbcdLmhr+sz3lOpVR7i/5K27JS6jVeb6k1GzSmZb
   3Cncr8kXquBcmxvrg1Jnti8jpxRPh0StbF3gFxYcZNDXg3zOZsENRqBYF
   xYMUergeUG+z2o9ezlYxr/UZt+D+ayvdFhEOk9iGFo07d+S1zhDTHS9WY
   syLd62xQDavqf8am0cvokGAtY8mz7sWn/qT18z3WJBY33xjwlfN4S9VMc
   wGrlLirT4+1fT/aPUy6zZ+9Bu6BZCLXMMr8Pidl4JOBxcJqDQ20b6k7td
   z0ux8Nam06fRtviV/SsDBWeZXI/LwpmieAr4AEryiHTm32052wYBzEbbb
   w==;
X-CSE-ConnectionGUID: Kjo1p6sHTeqDweWBjJS+zw==
X-CSE-MsgGUID: 7poo1CDcQIudx4c1OZBLwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153534"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153534"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:11 -0700
X-CSE-ConnectionGUID: 25aNQBvOS2m/jcr0ygh+aQ==
X-CSE-MsgGUID: 3sTbtFcQRkOaj6hFjq2FBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903733"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:09 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [RFC PATCH 0/6] Multi-pass MMU interval notifiers
Date: Sat,  9 Aug 2025 15:51:31 +0200
Message-ID: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mfzemkug4qk5919tbptk5g4wamz4bwjj
X-Rspam-User: 
X-Rspamd-Queue-Id: 9344EA0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754747532-722694
X-HE-Meta: U2FsdGVkX183uN9vgUIOrTRerGq/2ZTKGydeOzyxkVyIwqt6DJF/GDEX9kcqbWbWxpYLrrVZDrItBqr1eJPOCgUaTBXIbKxgWAOJgYJ4/iplwmxgR7op3aeKB/+hjVjnjd104nVwUQHU5kWzZGEB44pqI4zqs8NIQg1yMZaE7U62EHIZv0nxYkqkg0CFgm+B05uxSAYiy1ZYIM0fHSs5GNQmnXVb+Fh7DwO0PrHZmnocjpidXaf8hF2CO0Qz3sf//VpY3YQG1vYd05UxuErg1bAyFqwmkW6/EThKfICOIKcl+trRkvjTTE98BvvP/if+LeSgSgSEXH+YJkRodxMxADJkaDd/WQhEftTd9LB42bYNr49Fkbzpq/rr9I2/VtTqIvOIVhAejfcWTUfE5ftvXqqUjuOlXYY8toYWfSVIZwJR4ynNcCKifRP8wK56BPAhOQaaoqTXa5odaxEWgUPkuboCEUhi67zjzv0YpZLIIVmr91Qqiw94q7N7lVPvQ6h5aWBs5qzEa2Znx2dQmN0jr0BoLN8h5Lz95mS3eiJNPrB3MDquwdMfrffa+YJcEUCWUGq0ugpnSoQDnBZXE63Dpt1s8Hucop47LBwB2KkQZ9+UMSenXvQkt/BhEvd2+ApMveQVzdsUIYeTJnU0U5LRXJphTSNFN1um3VK9fTqJU9OnmIJvSbO6rqQXkIVRp6/tBiacS8NRbEevkDWcytFveYWySeR2WjRbDATT6veUv9iCQFdyYxx5pVPgziU8wNslpPlU23/JphjQGJGcPJiM4TFOnapM28GGr3uqOc7UBoVzWC7zuB1sYQI9tLHfdO7Y3ap0KTojzpX/V2fuHbLVtzBjmt3w955mj08atC0tbH1IlFU8GjOUgsG4x++1R3ScbLXan3zKVdJTxJQJt35nckap63mi2wjRZ/DQ7mE96PSCMtf5xa+16Y5nnUlcz0G8PCepFkBfduIIeC/So9R
 R8zOW4su
 Ptz9OXldb1G9ukj0hGq3GmbWcPXhRXghiIfCE1LAOHEnAdNuqMiMmIqW2f4rzusNeTyoVg57psFe4p1EndeN7VFnztaNyLqzRHdVsbD+B8V1CLguoIv+ZxeA7Uq0yl/gjE8fqWWt8guysgxDd8yPJbwCP7g3Q4esAZWlP14Cg5L7+P4NjRJFY8Qas39ASLMrhwehYdgVX4y9feMUmSMMsJw90TUfDtUzPNNP71/dt5b9iWwPKDRU2fJ7IOojtzUjbDOi3a9l55KI755a6yD/TY2HazPuOieudFTiOTT7YTAADPSTr3gkh7ditetc5QdeairaTk9w1x6K4ZH5F+3ORgCkhVTBkLVGZ104QvPvCubCHV80nAF2Ohoh4UzB6d0p2MvxiePcHw/GTfuUYdXQOgnxfFLtorY50bv3CqdeqdW858KSoQWPPfjjWkP9xRDHUOoAStT60XX7DjnhdgavVpMCk0lHi3WQmOa7SvBPztzZJNy9B4Bd45CxQZxFOILSVepfyD3lWxRZaoetEn/YoG4xJqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
for them to complete on all GPUs.
    
One can do this on per-driver basis multiplexing per-driver
notifiers but that would mean sharing the notifier "user" lock
across all GPUs and that doesn't scale well either, so adding support
for multi-pass in the core appears like the right choice.

So this series does that, with pach 1 implementing the core support
and also describes the choices made.
The rest of the patches implements a POC with drm_gpusvm, but this
will also come in handy for things like userptr where waiting for
bind completion, starting of preemption and waiting for
preemption completion can pe pipelined across GPUs.

Any feedback or suggestions for alternative approches appreciated.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Matthew Brost (5):
  drm/gpusvm: Update GPU SVM / Xe to twopass MMU notifier
  drm/gpusvm: Add drm_gpusvm_in_notifier_* helpers
  drm/xe: Skip waiting on unarmed fences in
    xe_gt_tlb_invalidation_fence_wait
  drm/xe: Add fences argument to xe_vm_range_tilemask_tlb_invalidation
  drm/xe: Implement two pass MMU notifiers for SVM

Thomas Hellström (1):
  mm/mmu_notifier: Allow multiple struct mmu_interval_notifier passes

 drivers/gpu/drm/drm_gpusvm.c                | 18 +++--
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  3 +-
 drivers/gpu/drm/xe/xe_svm.c                 | 84 +++++++++++++++++----
 drivers/gpu/drm/xe/xe_vm.c                  | 26 ++++---
 drivers/gpu/drm/xe/xe_vm.h                  |  6 +-
 include/drm/drm_gpusvm.h                    | 33 ++++++--
 include/linux/mmu_notifier.h                | 30 ++++++++
 mm/mmu_notifier.c                           | 67 +++++++++++++---
 8 files changed, 217 insertions(+), 50 deletions(-)

-- 
2.50.1


