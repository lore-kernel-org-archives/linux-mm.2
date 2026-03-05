Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A144AF30928
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103E26B008C; Thu,  5 Mar 2026 04:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2486B0092; Thu,  5 Mar 2026 04:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2B66B0093; Thu,  5 Mar 2026 04:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDA836B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:39:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3FAA13BB0A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:49 +0000 (UTC)
X-FDA: 84511512498.30.5193BC4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27AD4C0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZobSPn2C;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gtz0yYZ9eYAJ9ONpuPXOfMMcCOmRloi4jo/wjd0BLls=;
	b=bJHqEIdmre+JlXK2nyDYVAKHXZ0b0pOjFu1URVva2Dqc4f5+32iJ32rC0vpf5AgMHKHVV+
	tnGdhsldly2/ngNWmH4bexPolUmmzXgzSuAoY8HFWOX3OkbBfCsnj6n3uREYjF1cnMMy24
	0uE0lLk/ehuUofjO4cXM+RizBI/pWuM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703587; a=rsa-sha256;
	cv=none;
	b=ra4fEHgaWmybrAe3ziEUHpeVIIzHxpnGERbx4dhhOSPDOXZLihIqd5Plxfuu8+ZOsBQ8c1
	BH4qouURPnK2y451YcaUV3yndIozZ/dBVleVlw20Niz1CAtPnHZbfrHcljt+61TGw9BdJd
	/bC6vEvsOeczU1cpB4ck4GbsDzrp4/Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZobSPn2C;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703586; x=1804239586;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bpL7MiGzLlgeJDkxUeNpB6VxlUDAZkq+QvjkG45XU8o=;
  b=ZobSPn2CR3jFJFh7Fx3WFPFml4eAoFlT+g0CYqNCx0Dxc+uZ/E3jq5dX
   cw4AIoeNwIQif/i7jm6i7RyhTn6kbkQrfmuMcA8DdbZqeaiOXhCdB1+ZN
   /8kF+/2G0M6owNcWGpu7s9R4qhVuG5O55eotbabCUD3ZYWiu3urfA/wXz
   NEOomil+oGCMPTaOGyJAsG64von9uKm8XmJmvD/ChgshnyiQM7Cem3L2Y
   JI8q1tI0Hn2RwertzH7CBr3DtDjgeBT5+46a48bq9p6/2sZOsttbp7DpT
   BF93oHMDijToGokwfY3QGfX8p6sPHS7ED57vYUUZxwHxKtqE8D/vPrmkt
   Q==;
X-CSE-ConnectionGUID: 5454/RIfQ+evh5MptYUb1Q==
X-CSE-MsgGUID: EXbjYv6aQQmc8IhDFJb7UA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84870940"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="84870940"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:44 -0800
X-CSE-ConnectionGUID: XlUf5igBRuegKqAZriXKgQ==
X-CSE-MsgGUID: kIk+aQ3GRXqvHx1gbHabNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="214684973"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:40 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] Two-pass MMU interval notifiers
Date: Thu,  5 Mar 2026 10:39:05 +0100
Message-ID: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rg7tfcs7m1zetw4qt844q7cswfs8tw6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 27AD4C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1772703585-966426
X-HE-Meta: U2FsdGVkX1+w2dfzYNzBTM3yzwExctwrVMt1PZVNbijYTVdqmSfRVAGCCLJPkzx5o7mEdrFsf3fme6FkCVJiJcqHh7Q6irMZwQmOtsExHXqINVANJw4Szr7fU4UWvrsla0I1Sn1NU7DWSzivnG3XQRRR5QryaGo523x/y7jTDx/F6Ufdl+B3G9463fi5mBt8g5OOjxOXgtRCzZ4/ytkssqiiNLbHs1/Mv9VlB/6cabEGB0i2Z0TlkF+fCb5P1uWZco4nFIJ66XFW01dFuR87+FgHPfKGoyAS5I/PPTC6nZ8EvKMh3Q9FjuyNReZ7h1xBpUVLk9fmcxg9AtJnYsMSx5MNTOVB3IFWwCTcg+AaxZhqACwc4yc18uRBmcyDLyDwIRqMC28xyjLTOAyZ70EmYEJjEOJrnVX3FLktApbU2YEt8lusfDkiiCpSq/BC1ZxQk8xg3S64Cobm/C9pq5EFJgrujjzRmdMyAkCRSEAh/FrFkmAm/Q1wg5dX+tr8eEKeQwTJUUsfmycI1qCriv8NUCohKArq1mDkzC0khnzYIJ8sL2Rle6bNJqFCrx6tzga9ysEx1ytsteeDgIoSpv7F0MgKMbe6iXUWteRd8BueztI8dXSFBgUG066iy6aMMjZ/wcUGw6SAmhs3fMlXEahG9ZavpGmVivmK7jYOXDRLdNbwnlfgxNK3EREY6WEIQBsh3YyaU+jry0w6l5ZEQLTFOrQfzdLUlkCyRcFoyRRWzpjzACkDx3SmJIQttdDCsj/31UxxPQJTFcueX4Ulv48Q+1vSdAgpU6Rt5+cImPROWNCGvInFJ7PkoRw8AJRRNp8C4vp2i0vTMZIVR7x3vCuXnk3/7JybUCubhHwJyJgpJ6Qqm0E1nMqPkGDPShcE454/HY5cxNHYNBRb1SFE02BoiKfFkLTq+poq8WsKXEJJIXVxNg8dKzJ+Ehipb+Y9knpYY23aTXChoZidVF56Jzl
 u4+ERhad
 UjNLCpodfPqQz3lfPTAOS3SbXCkXzV6RqG69p+T+KJ8r767a8UARy+c8XNhBgNCWBLJWAm/BUt/fy3p2P10kim+S7unbkS4YOHbdh+SLND2FcTYs1gxkHCkMih2ugsfNN1V0I9vui8c0+rnDYUrWW7D3bG+BekEJoVtrS/udMK7BTtBoCAC1ttuMLkV7X1WKhh3BZjLQO0Xghei0poVyKZJsIQRpYGKG88KU5NcirLRDk4OdKe6ZqZswQLcfIIeHjGBYyQwIEXARa7tXO8YNPTgHKnNNcr3ycixoGboyyq78PfIQtDIfl5YiUCPL+eNZEodDNdudFNpiiWORnvgc33QC7CPJrOq9Mbiarc5axblh22Z+VlYs9SVO00glynS5a7nthab1liceedLjGfxBfxUaqhVqTmH047KvJ+YWxidM4geQJBcOeHI4uTciU2Zox7FxrY3rKnxvPUFWLLN7TSeMUBW+F7hlSPFBWJAvox9YREMFvR8yE9W6JiTB7PxZegCvg4ixMWRLr87bsjGW/BQymveGXM4iW6YA0VN2oQW1YFf0cfsqiXJ+lGMtGSVFh6fXUJIYqU7GlWJIFQSY4vc+NnekhVjmxovR7H+FvLgmNBpDdgsB8crrl0FigTeYl32cQS2SI1yrIv9NeEt38WHsTeZyyzobsOhPAR9hI7MdxHwj2ZLGU5uOpEM2Ipm9Bw2Ho
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

v4:
- Extend to wider audience and add R-Bs on the xe patches.
- Address documentation review comments from David Hildenbrand

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
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
 include/linux/mmu_notifier.h            |  42 +++++++
 mm/mmu_notifier.c                       |  65 ++++++++--
 12 files changed, 416 insertions(+), 104 deletions(-)

-- 
2.53.0


