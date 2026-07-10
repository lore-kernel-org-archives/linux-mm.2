Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7913C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5ED6B00AF; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDC26B00B2; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3EB6B00B4; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 673136B00AF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8EBC1696C2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:25 +0000 (UTC)
X-FDA: 84974150730.25.ED83FF4
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C0E540009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cbdcwiaT;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wQ4/e++dwiJ2hODy08BO64CkfLW5GsFjzHevL1ATi0c=;
	b=4V0lyahF+GyzZPRmqxWLuDzwvYc39/nACCMldtH+o0ycaxn/FEJ3D1GjsX3Vw4YXRqMASE
	i7JgXbYICLJYF4xPEGG7xigNePAL8czrANdbg4X3u8ZywjPKsO1UaXpjRLdNkLeEZez19b
	Ij/WvNOrRKBLVe53h6GU6L0pSFla6+Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cbdcwiaT;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718784;
	b=rZoefYReiEaXmLWSd4pUMECzSWLMPVpKeDP4obOnuE5iuQw53AlLKiHLUl4NNk6PXmhnlb
	s3gukcqtbeUclcatXJYbS3/XRQzN4T18TOyPAqHKqWW1g0Iuf0EPkkvGpjVM/Duv4Z3xxu
	KwlnKyxC6LPdK8cSB4lCiko4sWWSnkQ=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc891373e0so13354845ad.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718783; x=1784323583; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wQ4/e++dwiJ2hODy08BO64CkfLW5GsFjzHevL1ATi0c=;
        b=cbdcwiaT+pLik/aVDfL7odGh7R0erPTGZoJdcbZI8WDwwAB0KUfrDg8dU/OKETH7hL
         xDd6v7QMpT0cEUFf4hxfwdy5XZmawRlP2nJ54mffl1h5HhDEz37D7C80lTNrXGSTeFCY
         xs89UvI1Da0fMWCIoHXcCTPap2TNzqvyf09dKAvybMV4BTUfQN1SceS+NOSwNoiyNA0z
         Wdy/67XFJHDYsC8g1W23yaIPSVZhlr1WLyiskWseH4WOjzrAH7tzFA5yOZ4RNBxtpES8
         hQhKvW4vaAsLFrLzDtWbR90Pm23O1u22R6o6yQQ16a5G1bbhPMcl/9Bih+lyaXEzJhC3
         IW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718783; x=1784323583;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wQ4/e++dwiJ2hODy08BO64CkfLW5GsFjzHevL1ATi0c=;
        b=Dv16sQ4GE6hGwOIo6Axyo04gd2a0+2WEgVxYJc9SBFsJGQgPMAntz5rMW0hekY212I
         VFRjg18Gpp9941PnpYjeWmzhRvCm1yDmXFphlmBqWhNDhUR2ChKfeNwzpmCTbMHmi0Kt
         nQ92elNr5K4VKYd71T8NSj57nvMEb3FpZxhV6KmzJpGak3ZMX3+Yo0YHAYlUgXwGfb7J
         33hNdoGftWflz4ZEejX8oT8Bdfna9JylVi+hYDBvguvwxTDCyFSxCLJHYZjduzhBrkxh
         eXw9hoGIq0u67EosaUKJWF0sEGI4dkG080tVNIA8Mt05y897kdHGg8hiaG+VXqZ89ITx
         mfBg==
X-Forwarded-Encrypted: i=1; AHgh+RoCCDaLJ05BfrulkYQzxXaFcdSFa2LZpP4W/bo3gZbLztRSRL/wIm87lGFzncAYVrkSQ+meaCUqjg==@kvack.org
X-Gm-Message-State: AOJu0YxN8ZctFYKCwGUAVWppV9t9tVCFaKke/HJw+A6bI4fcEbC/o/sM
	ohwd6K78TS470QYzmI+EfvEgmnOo/wbR523fTfYNnAwW0AF+P/tPv6Gi
X-Gm-Gg: AfdE7clPJgfBp6aLK4BLIHn7bvUPpKbvkkyFAuKLWYHNsXBJh7H8FMeXgmzUSRGvAgX
	02toXjoPvMU2ad44yH3DkopXi/xwEs64a19RQlPC3gAgGumRMiMRvhlqryK9qmVOGdO/D0GCe+c
	hAEApzQBxkZqvqIwF8LJsTJ9IKfkN4VMa3PaDKT5XumWiK6meHqtxxMO+U5iswdS5fiaV6S0nmd
	irXP7TG48nRmqv6kmLpoEVgt8e3lG2jlSt7Z4lUspjItjTemqmbgqTUbjIVTavbbLCyl5qw48b9
	039uEnCTyzUIVPKAWD1G4fm+6pzTq74zCK9+gzbpvheqpb8F7TWOQhVRLqQ2249HtHzClB/I3pL
	B8iv3zkSipiUf0mWq3WPzK5dcenxcfju+bFqKhI8KEiCEoD2h2VNwPymsot5tCIl+GauXTvmcMo
	7DC2voNjXpzPFmtsT5mxgVHT/cLIxQypCyqshumB3+5Yo34vfoiYtabU70zWk=
X-Received: by 2002:a17:903:1a0c:b0:2ca:6c8:abde with SMTP id d9443c01a7336-2ce9eacd763mr7143275ad.18.1783718782878;
        Fri, 10 Jul 2026 14:26:22 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1e28fsm67098765ad.43.2026.07.10.14.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:26:22 -0700 (PDT)
Subject: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:26:20 -0700
Message-ID: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C0E540009
X-Stat-Signature: 59nccqj337m9txht9ox3hft75f36yejn
X-HE-Tag: 1783718784-462094
X-HE-Meta: U2FsdGVkX19jOq7Kl0R+nyPUHvuySAywRX+ATidWHSyvwyAKFPVZ2Mjv4VsMdzRNFS0lUvedW3vYmZJznxnJdQo58KYjAS1UYHpUiHYW+swKE3eq1bhPCDpqi2S0vuixXOzrSV+DVAWVtTBVMNe3CxzQ8WhJ2sf2Tm+Ye6WpZLfMpEfpPl3rm3nW7/AopUJr3v8YHLaRQxT7BCGTq4S/4NV8Wp3VP6oTkZz6+JDwfWOSDyHfPqsukJF1LNeMRFDfiSzPTEfHE6dYPRJFAvTtJsMRN84JLFfaWPk/kz3P6XTFEKfPjytyVwnLZrn+NJpnVsLrJm/FMoW7mw2EKexagJc9l/mYDZzlq5q1hm9Im6a+ruGjlXNjAPHUD2ujiKEyKVxw7VKD55nWyZowRf/TLD/WkTl+915O/sITbHGQmztN9CyqSMCxGlKCyAgTJbwqGDDl2gwKBcvLwcCTwNeEbKtrND6F5aI+mpi2e5KSmIhk/IeDmhZbsB8RuLAfpA2/zFy/EPl5lBSoZI+tcMm7JO8uHi161k8Q9Kx79sgGLgzD9wj8KSDgT80Ese3fEo5hl4txk12Yjn1I7fZ0dL/U80DKodwO1Mi7SGgDSxwzJYsUGwnoy9LqkYoGU6Ddn7Vpx5QVdBt+ZLtBuJczf9n6qfPlYv+TGd1+2TQFDWBtjUwiktndi8YdNNqpo+aSL3kaLmOduGYLGQAVZvxhWwFOy6KCuniuwsaBZwd7vyYXJ3+/00iWl8nDvrJkGpvlOdUqxE5rfEyQzpVvkqG8JPJpPyRj/rlq0ys2Saq3bqLiiaatXJ9jVrKdhhjyS65PRoiwC6dvsfBukHLHkRuJsHN/uoj2MXnhLNNbNE1xH83GHleeLFTeutewHnGPj3WmcTS2DKpsmboiPLJRniZuJYw7Xs9+a85DnUjq/pxTQV4yVffr46AkY7UljFnF1UQ0LNCPsGkyf/kkVdf4QO4DiEn
 5V2HAxEA
 0n0pq/WMqTJW3shUhkeAg/23dt2MqB0Gxf7MvIYlLgDsE99Bk1GXYA61IvIi5XmoP0yAxWI7dW3ZdLJo5USMIaRwLxclArkwxckahohyHqzn5OGcW5oYbCZgWDqPfOwfF3Xoe4ye6Wud2uxhelXQHzA51hY3LbbBrB3vQKBAOzb73lYR6FQxNBmu9zZYAqpmV7tdrVlaoLU4r9c9gdE2WBbsWMxXZ+oLQxub4O5udcgcK5Orydekdxfc+DmC95B7In/s3pN14ogzvsQxu+oqeU8BizUDH8GRPQDDvcmAR0beqGnC/dCWacAwrS/BH5ENiVRLcuO6wTLNPg1TOmHNtZC3ufO/HWGOHZiLeRmCCQNvhImuLVPoSFBdfeVxOt/dDPb93b/1kJk6h1fERv1z8PxyuFYABggYLxfzF3CYH3c/IAZUNSBtSnfHxBoLqrHCZr+hN3dKwoL4OKU17Jsr1jZtM5Tj8QVBp0cuAsdh4ekXgGIhqJ0uBQV/ML4rIq1cF/BdWrK0gxX9oCPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series extends the HMM framework to support userfaultfd-backed memory
by allowing the mmap read lock to be dropped during hmm_range_fault().

Some page fault handlers — most notably userfaultfd — require the mmap lock
to be released so that userspace can resolve the fault. The current HMM
interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
in pages from userfaultfd-registered regions.

This series follows the established int *locked pattern from
get_user_pages_remote() in mm/gup.c. A new helper function,
hmm_range_fault_locked(), accepts an int *locked parameter. When the
mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
the caller to restart its walk. The existing hmm_range_fault() is
refactored into a thin wrapper that passes NULL, preserving current
behavior for all existing callers.

Possible approaches to lift this limitation are documented in
Documentation/mm/hmm.rst.

Changes in v8:

  - Make hmm_range_fault_unlocked_timeout() the primary documented HMM
    range-fault API, and move hmm_range_fault() into the “use only if the
    caller really must hold mmap_lock” category.
  - Clarify that the timeout is a retry budget for repeated mmu-notifier
    invalidation retries. HMM does not interrupt an in-progress page fault
    when the timeout expires.
  - Restart the retry timeout only when handle_mm_fault() dropped
    mmap_lock, because that indicates a lock-dropping fault handler such as
    userfaultfd made progress. Ordinary -EBUSY retries keep the existing
    deadline.
  - Remove the attempted timeout selftest. The remaining selftest covers the
    intended userfaultfd path by resolving missing-page faults through
    HMM_DMIRROR_READ_UNLOCKED and hmm_range_fault_unlocked_timeout(..., 0).

Changes in v7:
  - Replaced the unlocked HMM API with
    hmm_range_fault_unlocked_timeout(). The helper now takes a timeout in
    jiffies, with 0 meaning retry indefinitely.
  - Moved -EBUSY retry handling into the HMM helper for the unlocked path.
    The helper refreshes range->notifier_seq internally before each retry.
  - Switched the unlocked path to mmap_read_lock_killable() and return
    -EINTR if mmap lock acquisition is interrupted or a fatal signal is
    pending during retry handling.
  - Removed the redundant non-timeout hmm_range_fault_unlocked() interface.
  - Updated Documentation/mm/hmm.rst and kernel-doc to describe the timeout API
    and the intended caller pattern.
  - Updated the HMM selftests to use hmm_range_fault_unlocked_timeout()
    only, including coverage for the finite-timeout path.
  - Added in-tree users of the new helper:
      - mshv
      - nouveau
      - RDMA/umem
      - amdxdna
      - drm/gpusvm
  - Preserved each converted driver’s existing timeout convention:
      - unbounded retry where the old code retried indefinitely,
      - HMM_RANGE_DEFAULT_TIMEOUT where the old code used that budget,
      - existing driver-specific timeout return values such as -ETIME.
  - Used max_t(long, timeout - jiffies, 1) when passing remaining time from
    absolute jiffies deadlines to avoid unsigned underflow while keeping a
    minimum one-jiffy retry window.
  - Left callers on hmm_range_fault() when they already need to hold
    mmap_lock across surrounding work, such as drm_gpusvm_check_pages().

Changes in v6:
  - Reworked the new API from the external int *locked pattern to
    hmm_range_fault_unlocked(), which owns mmap_read_lock() internally.
  - Changed the dropped-lock contract: hmm_range_fault_unlocked() now returns
    -EBUSY when the mmap lock is dropped, and callers restart with a fresh
    mmu_interval_read_begin() sequence.
  - Kept hmm_range_fault() as the locked variant for existing users, preserving
    its caller-held mmap lock contract.
  - Added an in-tree user by converting the MSHV region fault path to
    hmm_range_fault_unlocked().
  - Updated Documentation/mm/hmm.rst and kernel-doc to describe the unlocked
    helper and retry pattern.
  - Updated commit messages to match the new API and return semantics.
  - Kept the userfaultfd HMM selftest using the test_hmm unlocked read ioctl
    path.

Changes in v5:
 - Rework hmm_range_fault_unlockable() retry handling to retry
   VM_FAULT_RETRY internally with FAULT_FLAG_TRIED set, matching the
   fixup_user_fault() pattern and avoiding repeated first-retry lock drops.
 - Distinguish VM_FAULT_RETRY from VM_FAULT_COMPLETED: retry faults now
   reacquire the mmap lock internally, while completed faults return to the
   caller with *locked = 0 so the caller can restart with a fresh notifier
   sequence.
 - Document the two *locked return states, including the -EINTR case when a
   fatal signal is pending after the mmap lock has already been dropped.
 - Update comments around HMM_FAULT_UNLOCKED and the HMM fault loop to match
   the current hmm_range_fault_unlockable() implementation.

Changes in v4:
 - Rebased on 7.2-rc1

Changes in v3:
 - Return -EFAULT from dmirror_fault_unlockable() when the mirrored mm can
   no longer be pinned.
 - Add an eventfd stop signal for the userfaultfd handler thread to avoid
   waiting for the poll timeout on successful test completion.


Changes in v2:

 - Split into a preparatory refactor (new patch 1) that moves
   handle_mm_fault() out of the walk callbacks, plus a smaller feature
   patch on top.  Suggested by David Hildenbrand.
 - Hugetlb regions are now supported on the unlockable path; the v1
   -EFAULT short-circuit and the hugetlb_vma_lock_read drop/retake
   dance are gone.
 - Distinct internal sentinels for "needs fault" (HMM_FAULT_PENDING)
   and "lock dropped" (HMM_FAULT_UNLOCKED).
 - Outer loop now re-walks after a successful internal fault so the
   faulted pfns end up in range->hmm_pfns.
 - Kernel-doc on hmm_range_fault_unlockable() and the
   Documentation/mm/hmm.rst example match the implementation.
 - Dropped the mshv driver conversion (v1 patch 2); will post
   separately.
 - Selftest converted to drive the path through test_hmm with a
   userfaultfd handler (new HMM_DMIRROR_READ_UNLOCKABLE ioctl).

---

Stanislav Kinsburskii (8):
      mm/hmm: move page fault handling out of walk callbacks
      mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
      selftests/mm: add HMM test for mmap lock-dropping faults
      mshv: Use hmm_range_fault_unlocked_timeout() for region faults
      drm/nouveau: Use hmm_range_fault_unlocked_timeout() for SVM faults
      RDMA/umem: Use hmm_range_fault_unlocked_timeout() for ODP faults
      accel/amdxdna: Use hmm_range_fault_unlocked_timeout() for range population
      drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for range faults


 Documentation/mm/hmm.rst               |   76 +++++++--
 drivers/accel/amdxdna/aie2_ctx.c       |   17 --
 drivers/gpu/drm/drm_gpusvm.c           |   52 +-----
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   12 -
 drivers/hv/mshv_regions.c              |   54 +------
 drivers/infiniband/core/umem_odp.c     |   18 +-
 include/linux/hmm.h                    |    2 
 lib/test_hmm.c                         |  107 +++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  259 +++++++++++++++++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c |  150 +++++++++++++++++++
 11 files changed, 541 insertions(+), 207 deletions(-)


