Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B18DEA4E3E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADB06B0005; Mon,  2 Mar 2026 11:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B6E6B0089; Mon,  2 Mar 2026 11:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A006B008A; Mon,  2 Mar 2026 11:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82B156B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:33:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 195321A021D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:15 +0000 (UTC)
X-FDA: 84501667950.01.C185F45
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47D07140017
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MPht9I0C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vZIGt91sZdinZKTw2B89DN96+kaO2jn/5qbxRwh01CE=;
	b=I/xUKezHlAAAopAKo9b1bYR0a7Nd9d6KacRdzgknbNxF/V4+lEYDmoJwBeuIrpYuActEof
	vZcvJYYL/ZIRZYGIm5yuFxo7WESS9OIdeAeJPzWm2C1TRISh2VM94Aa40yeib0in2SodVW
	ExiSK6TrCV/mk1xCbO/thQ1i+vefP4A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MPht9I0C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469193; a=rsa-sha256;
	cv=none;
	b=QVFsUtBZzsZlaM0UnOeXCxToo+Y1CTGKb6XoHJF8h1vGDQjFNl8Z2G0bPWdfrv+GoHDyrt
	07qKqYk1uWQBqPVAFOdljw4/nG0WIFya3NH54VaE2mL613JAdENcMx7EAYNG4oJRFEKnhu
	8EKg8Z9sYfQhvqNnCFFlSo3xe3rnjfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772469192; x=1804005192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kfMIc0OUpsgkTCkMzSFFXGItn5Z0YPAU5KqBEO/YCjU=;
  b=MPht9I0CYGF5rKhVJNMAuvNHirMJK1yIDjR5NVz2KuKzvUi9Suq+puXn
   BYg3OUjJvidGl0UcbnPs11bCCvxvZ64h6ioIYTF7MAyfjYjQcYyB8sbs6
   JuEshh+1yyiWT0YuIijhgfQCYznRJ2KT0E4x6dBeZZiAWNYjaBE06yj+/
   obfjhJF9I24szyZDW+ay0Qmfe4017BDZzL3zaW6m9G8pUiW90KAX23rqO
   MzU8qqG1KW8Qvk6MY3PL0FJNzwoHFAjYra3XondLzuJcOtppQwSVf2N9w
   PTE0ClvJJPd0UFT23INyTAq9uLQgH9fXJs9t83DJZStqqQbQKQ6SUGGAM
   A==;
X-CSE-ConnectionGUID: 9q8Ch17YR0q/jxRQWGJG7w==
X-CSE-MsgGUID: ybrqGuSJQZmYTNv03zCr8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73447810"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73447810"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:09 -0800
X-CSE-ConnectionGUID: vr/4G302QFOqlxJOv5pghQ==
X-CSE-MsgGUID: zDQUWEPnTW23jzI2q1uvMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255564508"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:07 -0800
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
Subject: [PATCH v2 0/4] Two-pass MMU interval notifiers 
Date: Mon,  2 Mar 2026 17:32:44 +0100
Message-ID: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47D07140017
X-Stat-Signature: uhxhk317u6yce9xkftn1j3nk7aacuhy8
X-Rspam-User: 
X-HE-Tag: 1772469192-156069
X-HE-Meta: U2FsdGVkX191ndBV+eNPzhRhXNN7imx0HkjeXQnbFOv0U+7U/h6lfwdzvkzAELZPG9g4cMpbmEp7BsAXV+J+EyrTQogpK3FtLY6cz0dxkVnLkC1AAq8RvjnLEpVCrNtwHMELW6b+QN2i0VSXouEAoVCA8liEruWwjdd6qYeCieLWSo2LTMktl0S0DpdAQAVNPNRIQ8QB9lyyFoqRbk7v/1fifkjACuv9F5JyfHdjJu68KqzZA0Vwp8gGDBhD483LyrxilICsY6Thlpd3nFMpqjLGE3wnCMPG7ZL+LVQ50Y8YRjXv/pfg90Pq1oF302x/QJ8CFvPNmXbqLiHnkoo6fGPOuR+mJ8+hr9+yyXf84asy2kZNagjLxhsZJdy4VPlAjHkDZ1jRQTZgdsY1f7xb8eODf/90GVEl59nJKzCtBQ3zXCksT5M6ZLlkLq24gdwjiErCjWO6EqOK4r5oOK+limlzEEfibO6v1VTLCMDnWhVEe4/ni+l9wkWWQ+5sCPrbKVnE4ywGs+mnXMmNxm7bOoh5F0iKKMkr9gD6c1/ksxlD1dtRgjHTPXOVYg7URebqNatxnc6VQ6yn9kqbdQ+Cc9yfOywC9CDdiydwmOf6ShHeQy5sPtZUfBko7kSkYXb8LjqQS8jVEqfvQKrJdx8JADWaHdzGxJqXEPqZEDbww0zmZTNfX5KBao4jH53sBIUebkvRgcICjmjhPJfJM+s2fr8TAPwbPM0x1wf0CRzHQ36O8fuNBLRoNKtWTjjDjUpnFa3FK94TTmCQXxWGJuFI6zjR7XzWCyqDg47XlvalES3PZTQxISoCT/JlayA9Sj/U+lbJInWAdyz5DNpJ/BZwZ3MuRC/UgmrOoUnlkH7ZJFxqSn2oibg1UEjNyBbbcQW7bc2pma4Bt1/tv422M0Kt/Aataz4zqgK+VwTkrHGas+9QA/7Z4r2yA07O+oqMdSksRLYoMeizt99kd/M4oAz
 bghDkpND
 y56PHfGQeMer+CtVaHIgK8+z6Tvpl8gPKb8OKWiQz2VN22mJlTsGaWbWV00Z0ECKSKs6rFkPq4dO91VRH7YOlwnjfupfvfvxgqmbr59nC6mH6qxx4BeLy949NvB0PDzj9Cp0UUCF3zHhfWUFibRNKf6gJrVGaJzRPX8t1CBXAMhiOvsL/mNpaTHE/OSZx862uCFtAyB3CxqDM8SJe0B5gR8BVY+IrwsF24QIeG7YG26QzD3j0hq5THj+4Bl5u2CijOi0Gw2vOhV7S4ZNz/CzsD266dRWGxJaB1Np4KzXcMXTuy5tZty6mtlMv7wdtvbWqv7HfU5e+4NOUKhKZtEjs5YtOmR+lAKjDyuMqAXXE7Q0bXjOjuz7dLYBGsIW/bX8+aWL39VHhe5SMwVGoKmWVhKCWGiZErXqr2Yn2MDufw9RHBMTZ4kZHpmr0UCGLxxt3uyajk+VWWhX7+eKGacBFXos9NH4g6XxIjDskY3oRQNUhL2i/Alk8uvIGbf9RJ7LhNALcHZCKAU31GxrMDhaqRjpAux+CNMpPGbgjYx2+Jk1+meU2zIAe1EDolUePFjgld+gMg/wERM/1AzBMXyPd7ZVRlVPxbW2TYDctuSA5iSOwzXE=
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

 drivers/gpu/drm/xe/xe_svm.c             |   6 +-
 drivers/gpu/drm/xe/xe_tlb_inval.c       |  82 ++++++++++++++
 drivers/gpu/drm/xe/xe_tlb_inval.h       |   6 ++
 drivers/gpu/drm/xe/xe_tlb_inval_types.h |  14 +++
 drivers/gpu/drm/xe/xe_userptr.c         | 136 ++++++++++++++++++++----
 drivers/gpu/drm/xe/xe_userptr.h         |  32 ++++++
 drivers/gpu/drm/xe/xe_vm.c              |  99 ++++++-----------
 drivers/gpu/drm/xe/xe_vm.h              |   5 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c      |   9 +-
 drivers/gpu/drm/xe/xe_vm_types.h        |   1 +
 include/linux/mmu_notifier.h            |  38 +++++++
 mm/mmu_notifier.c                       |  64 +++++++++--
 12 files changed, 389 insertions(+), 103 deletions(-)

-- 
2.53.0


