Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C06CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8A98E0044; Thu, 21 Aug 2025 07:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF9B8E002F; Thu, 21 Aug 2025 07:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5BF8E0044; Thu, 21 Aug 2025 07:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABA38E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:46:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7C56C03B0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:49 +0000 (UTC)
X-FDA: 83800587738.25.A635C5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4622AC000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SdWjF+Mv;
	spf=none (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Cy9IphRlaVKs8ACpTE55DSwvKaIO3X3WyLNJ7AogJ5w=;
	b=tQxoKCVjuYyixOOHuRBiTnDHaltDpgpZ9zscOziUJnDatPLqoqs6iBfdyiRJNeXtvkKkcx
	MP2Ov6IDptChCZz4T6TDPVX6ULPP+8cJEFOFA3PaeUAgaEL7EhxYwxU60yZEUZ9TcgEK1k
	JBA0agzVIaOiWqLmI7kLpmg/Geqb4qU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SdWjF+Mv;
	spf=none (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776807; a=rsa-sha256;
	cv=none;
	b=K4zUWhH9AYwlEKkzUDuEokVQYY8egA/r/d07nNwEDIBmn1eadpzqJtgkXH1bVaOBFtyZ2B
	IsPkeKP1t0F3cllB+3gstAcewwo7ZtGnpbLVR24aytZ4bAcnHovEmIUsfWtJ0iorQbmCP5
	J+o8GJ8TcMj7bxEouKXYX4kFIiYadZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776808; x=1787312808;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7uXfokjMPHH00LPtHChffrlYvCk5IWl4R1qCTaEowDw=;
  b=SdWjF+MvzSdARgf7+uj+IpiTVlWtybYUH3o4rVHgOGP3060/GwiLpxjj
   BToDRxbZYgPK+UNUEePZCy/JUGU0u3X1kBuSZAd30fZG5P3wrjY3sDiui
   c7jP6Pwk8oY1/7zwoQwDNAYQnGyedi+/WrEpOyiIzMHji1inTgOFCU1/s
   DeVFXZXpbqJdTg7Wd2zl2qD89XoNk2wUr64FaPKph3XA0Yc+7LLmoEnoq
   BryWbfWiT3fHN+2fvk+hxGXqEmNQeaiIBvVarqtZzT+s3a6f+4mZ/npdM
   gejKTdd2cQwuYqHPlXhDbqBWAHD3li5nAmqSmvGOObyGRQeaMVdstsxjh
   Q==;
X-CSE-ConnectionGUID: XSwJ9jyWQjGY66q9SYY8aA==
X-CSE-MsgGUID: tmexM19JSSSSwzilsfo1Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989429"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989429"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:46 -0700
X-CSE-ConnectionGUID: Y8pJ+9VwQ6G4Wx9YReIMZg==
X-CSE-MsgGUID: MvxPC/g/T2aAKS3JJBXqIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613623"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:43 -0700
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
Subject: [PATCH 0/6] Two-pass MMU interval notifiers
Date: Thu, 21 Aug 2025 13:46:20 +0200
Message-ID: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i5dbjf1zkigca3xoutzowkeryfq1titp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4622AC000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755776807-789525
X-HE-Meta: U2FsdGVkX1+4QvrMjafXdb/y8E37puurOItPr91YuAJW5pC3hQ28qdQezrvWwXWp/she20R/CrMcUoi40trec+taP5waJHURoTa5OM3QZ3GxTWO82O0QmtCCMsydvKYgf1CaB3wmPI6J+SxKvqOZHxibRRM7Ain6G95wSOEEDzDivwTxb6P8XjE6qw2mrYuHxw8c6Atq6WBHGiRMOOFj90L2RQoXlrihUcLpImRAQIIfNJqTGX5pNopHM6XlrsrgcqKh5w7N+HcildxPydJ2naIsPXFTG7ONghRHyKQ5oaQCEHSGKjO9MBBPc/i/Bzdx23JbMulMDMav0ui+WE2le8qEhdbUkR9ATDe1l2/nOXCZgA1DcQyww4H7GMhklCs+nXqKpdJXWfqm29mVl79PgHdQpY5+eocxyuYUnjU8hamsRmtEuF7RKwlKnw5rDZ5iE9oNH2YuUdw/uTO0GTwxIld3sfcy7EmXVuaXK9+f5PQvuvJpSVsogm0QtAbKv5gsfzw4ikYFKQQ6lc/vdNA56IMIjhx/ybad/9mxfIgwrPZW1LB9JbCTjVhLih9p+FThZ4ceH9idlWcl+in4hMra8u/m6VH9ZR3zQJ3ZKRRX6WBD5Qg0GfSws8J5Nqu0sFWfKhFCUCBczbCBBsQUP73LkT/No/JFxSaoKpGCFDy/+c/kthCSsX7Zw/qTje/0Wcfe4JKIlHDefuC3lOoe0TNaKFPpTEDbtYrh/D1Ys/das0cLV/Eo2PzV+N6/cdkGNzMMGU81x3AxgYP5lzg4g+jHtXz6XV0c9JnreGc+hLAbYCYNWTokYWnaBY3efNCHgJWs3jZI0Yzo8H5YQJg10rCWP9LHH8Q3j51XSRi+1F+hdFOKc9DhriCwomLzZFCaTHZv3FYvxsJixK9JdFMl2GvB0F8pPuFaWzYeqrn4vFpd+honlMn6cR2PdV8F6Q0jyO/INq5WMg+dnPyprrFjTZG
 s2HmXka7
 EkYHhbGLQzpbdvO8PeqyTNtQ1hAgvxCi7zbrrDI9eUTx32dSvrvQrrB0QCHXgT2LU4tcpBZn1YOz3tVhxETY6VuTSI5i4FAyjLKzSflbcgF4bJYRxe96CrBDlxBYWnoNHb9jvEDmi+Yx+bqCqvJkk3WO0ALaY7K7Vx8fdZ3OSG9SG+ZpsXh6iOxKVTHWKyZ/HJGNjI8sP5MLcWP8vy/hyiYTBMYxqqQynogzvDrZeOoT+xD1e4oxI4f1F502MFPsu5Bh6etcnBbqc6VlD3g1JHdXdiLlh9aQKalkBJXUYgTuJ4fnozNoAI9kQ/vA9AFvzrVU+etdY0fsu6afvnob9L+3ghwX7/K0FJDMooc22BswwlY3cEE5z+FdnkaqG/Vos1EvddxfLzYyKhTb3aRgbzIOadsdY3CookNMBcte1Q3g/uTL9lBqEIu7SpRP1XAJ0eXZhC/dQQNZniC7GAJ6crj2rfucUOCPpm0aouSChs2vflDiqXeGAILbm/arzRklTWKzvm2/zP1hLv+9oo2XB3vDlE7KFg9IzqSitglRHw5SglYc=
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
for them to complete.
    
One can do this on per-driver basis multiplexing per-driver
notifiers but that would mean sharing the notifier "user" lock
across all GPUs and that doesn't scale well either, so adding support
for two-pass in the core appears like the right choice.

So this series does that, with pach 1 implementing the core support
and also describes the choices made.
The rest of the patches implements a POC with drm_gpusvm, but this
will also come in handy for things like userptr where waiting for
bind completion, starting of preemption and waiting for
preemption completion can pe pipelined across GPUs.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Matthew Brost (5):
  drm/gpusvm, drm/xe: Update GPU SVM / Xe to twopass MMU notifier
  drm/gpusvm: Add drm_gpusvm_in_notifier_* helpers
  drm/xe: Skip waiting on unarmed fences in
    xe_gt_tlb_invalidation_fence_wait
  drm/xe: Add fences argument to xe_vm_range_tilemask_tlb_invalidation
  drm/xe: Implement two pass MMU notifiers for SVM

Thomas Hellström (1):
  mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers

 drivers/gpu/drm/drm_gpusvm.c                | 18 +++--
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  3 +-
 drivers/gpu/drm/xe/xe_svm.c                 | 83 +++++++++++++++++----
 drivers/gpu/drm/xe/xe_vm.c                  | 26 ++++---
 drivers/gpu/drm/xe/xe_vm.h                  |  6 +-
 include/drm/drm_gpusvm.h                    | 33 ++++++--
 include/linux/mmu_notifier.h                | 42 +++++++++++
 mm/mmu_notifier.c                           | 63 +++++++++++++---
 8 files changed, 224 insertions(+), 50 deletions(-)

-- 
2.50.1


