Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B99C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BF06B0088; Wed, 15 Jul 2026 14:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42306B008A; Wed, 15 Jul 2026 14:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04CD6B00A9; Wed, 15 Jul 2026 14:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719016B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:15:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D736D160260
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:15:55 +0000 (UTC)
X-FDA: 84991814670.06.4B75562
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 240CE12000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:15:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XyexKePB;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=o8cXs1v6rCZCT506ix1H6vuS6eKjBp0nDmZrJvk5ap0=;
	b=czUF+5KLpf6kGILkUZxjdooChdtYVC+Tp8llWS06boBRXzvM9mzQmMi3dZfmj8G8pLdoC/
	x/jvw/KeJ97ZudsZ8AndCj1GGHn/izPltMAVuSJoFZ4uBJKzGQa+X8iunqXrwFkJ9hN4eu
	Z+g/m/Cbr8pyaQNrYjuQlDFm7MvZLWQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XyexKePB;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139354;
	b=dbW3e1OY5b0KnMt4zrSUTq2zCSxlTHQXOHF5koptfq+wjONWXpJoUDeZK9M9KnMr0zYi8T
	gdBMdXtKbKloQgKjZ+UOhKWgTYSoO7PVdqCkjNm6CSl1f0EZ5ZgAmL8MNBSt/zEmD8lF5R
	IvZodJ5SOH5ZyF5VQiWjSKcAfxjKMWY=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cacf197759so40552625ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139353; x=1784744153; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8cXs1v6rCZCT506ix1H6vuS6eKjBp0nDmZrJvk5ap0=;
        b=XyexKePB4/HlIPUPdL6bCIrtujgh2zUTaZ4b9idkCStJTAJMaTxpFhW6ZCiRiVoh3O
         /olo8U0lyACu3v+PWnRsmBSEogOEXWXuj++16lPhuU69s7u23E1qvAKM/3fNNytbGmDb
         Q//pPPe+RDvq16M9T/60innkS2kBu2NliQI9+oun2Rjsa40tWhpedSez6yINUWMk8Xd8
         ckseaqCVHio8UKwEXTUgSjy8UhbCkr+ssTN96EkAEe6H/9kJNPFlHDtWYu0MJ3ru+fKQ
         fwp4pxgZe4Gfsx7on2WHJ5FCBZMUHGkJEZJ9nUAQy19Y6BRANxJK88FcxdWKMKUv7l3z
         hokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139353; x=1784744153;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o8cXs1v6rCZCT506ix1H6vuS6eKjBp0nDmZrJvk5ap0=;
        b=AMJHV3IC0t9yj0AILwiFJITgJKGUIzgBaGPeD1V7f2bvnrSUMMl4dKbraj05/VOEbR
         zfC6BwMQcn27GK+CHtJmBKfCkFLT4d5tt5A3zxsGX8upxLIvz5BfW8zE8GNruGq5AT6e
         cy5cXEtfPke6f6iIJCi/biKcRyMQ3FpA0ohld8q6qtqulvcxeE5KG8cmbfLqRUGOQhKG
         d6pLRbF/GWDM2lo5rKgY414Supi5W6+/WrmDuGUFbPhXQbe3Rw0QCpZ+OjmwXwQms3zz
         /IoiYIDdWWhfQ99+E/ewUdFlVNMGsUFAOcklAtJHhlp1RHnKlnj5gveIIPe1ISEiuxPw
         cOOA==
X-Forwarded-Encrypted: i=1; AHgh+RpjYfgZB/i20G3ohV5k5WrBhqdtuqF53Dt2brJ26RqGMgkwuO4FA+tk0B0WfNOMMnTqxX2LZkr8xg==@kvack.org
X-Gm-Message-State: AOJu0Yz9mDmCDknjE3w/hYQ0CRl41opHwjYo/h0QTPl/wSCzNd45WKlv
	MEykk//EI3Dpb1PSvedYoM9+yWed8Kmb2Fvtcxo7kf3i4A6DOB+EpdIe
X-Gm-Gg: AfdE7ckFKV4bfbxE4CSiYtFTkpkzRpyKF65SQyKhQzHC7m1uIEj3APV7vAGyTtgTz9s
	XPvkyhK44fmxQ4nVOasXGg0UIwPGZjKManCn6Q9BFIilAmu/pQFVbPQEuWQ9r0aXBUHsfQAclqy
	RZkTIxfK2hzAHfQjTFtQuv8kuFP1RUlYx0IFeg3CJM6sdKL6RYZQN4KCTv6uHiyXn5Q1vpc6TYn
	yWMcVGSj25WeVWiv/qll9VlU1gy0u6emxEuPRoBxn2PElMY4ZkMKEUlrS0MHK58S8aSIFqbh6d/
	9svSD0SXUU54asBmYw4pFpNoxX+yMgwY77oVLDCzciIUoeVfW2kbr+9Bmmoy92COfZYa2XpRThW
	ZxQseJkyUxf3WdCHhgfjkm0cCtB+bAG3weZHjzk/LfyktxkokAQDwZt5y776XBi0he0QEu+eHKa
	2YKke/hSIZrLpM1uekW/tOgfeW1iekltGZ/ovIe8P1FGGmeQlcTsejotHUuJE+LLBC57giCg==
X-Received: by 2002:a17:903:19c3:b0:2c9:97a9:2096 with SMTP id d9443c01a7336-2ce9f05981emr195144115ad.42.1784139352792;
        Wed, 15 Jul 2026 11:15:52 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1055cde6sm6969345ad.52.2026.07.15.11.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:15:51 -0700 (PDT)
Subject: [PATCH v9 0/8] mm/hmm: Add mmap lock-drop support for
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
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:15:50 -0700
Message-ID: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 240CE12000E
X-Stat-Signature: 3rkpnuuftaggsh3hj5p7119dg3o8mkcc
X-HE-Tag: 1784139354-422290
X-HE-Meta: U2FsdGVkX18CQic2TObWKkksA7ZEyr4uaPJzfhcJOMkIl+bJgfkXw9VbAD3DDMqL3+UByea1ldkUULQ6HkxBcPEyTZfi2MzFORd2YUXcsUK3hBcDyFsYEEi8JhXo0m+bGJU8bDkkVZ4Gs9+ns0segQUd/kFBb8JLUZ3P05xEBYCvz+YxqxF5uW/zhKzqO5ESaSNXDHsci1qPgM4JmqG4tuVcvp1ppYjb4y9dyMnyIoupECPeaR0AltbM/nTOW7lW4iHAhGWG0t+923eL2fJKVWTaZtOtNworh85USIk6UhznSmA5UTPxrYGyq6uKkKv3/6zF4diyorQcEb1wlACltcUGN5FQPJXkyirDiL1fHYfDPEA+PNJdZIjB6T+PYpgJN4gFVkITSYQkdZQEel2gtPGV9+Fhvb7p1BnMOSgpgPZVnmRG+M7XB6t40M0OQwnZDmQAJ6iZy3XF9HUyiP8jFVNPgC/N4nc3+gEs1EQp05stWtaqzk4RqL8ZprIAK1eqLtcp3YzZMvlFgcdJ5u5B/xW4/j1186U+HkimDpe9L9Tb2jvI9JlexRVynu5jX8cfqjINe/A0M/S0+co1TtmnGmB6X54GFFoQ6iWx9dcbg/8euVNw9+N1ExAY7azCQf2Cs/sgLyXzjT1pjbXZ8pAQ5VaZnFyLNPlxA+XNuowPtTeALJJi8zLrLZImKyijmZO+exJGFFxTz3xcDjrqB3XSvuNlXvitSzLrrOcjmXDI+Ql+12O8mHnCPvkPWYzwXGbIY2GXhAEvtGkvXU7nVMME8u3JCPr1qEn6oRVdy01cvF7FRYFCHL+SEqlmlxJTxWL9dVDltPkYx/d/uCr07uxvqZy6D4yW2gpqmch4vQP6Wg1zuAfTmsEBqHWM4D3jEcLoGtbpsUNSiHTxRuE3GepeXWuRBFrUT2tt0xjkhCN60vWztIzZiYhxkhdKlxKeOdfk6A1kENtnVGMQTMkaUI1
 9cSixStb
 /PmEPokPVrcol29G0MTbKHXyNj3J3lIhk4tEXBdwJn9wGdo+IEOs+T50fplBZuDXjdyEcmqxyacdi37zJh28zFhzfogoLi+y70mF1epToMRr/mggO7+nZx/XcMy4E5vMPp2VBUz4IeqanVD0OE00dSZjJ1xj7xbgADq6ZZt95GkFoSvDI7pjzijaDOOixezF3d5rM3lGy82yvZfQW1JZxWxweWTZbiuu3ydxrEk7+fwRuJhqSLsWyO8kS1HB/vhlYZDQM7mBSeGlxsTK5j2Do2HY481NrB8UTQ56w5YE+yZpegydE/rQOGYJpHilY8Z89B6jaLuum2zZeFBfIiTs6WNelq5PAd0BWSNMrpyfVrYWun+hbvNHEjavRzYdRrAA+DZeqJL8gWaBZs3ri/Q1hCq0MjEobaDKWrJlMf0XRqlNN5Rv2EoXZJDtXjcnlYEsSf3LPBpAz+cjjFvkZv8z+ntoSlkUq2zmHLDt5GcSLmlwgRviCcfGOQszjjJv9K3OpT3bv
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

Changes in v9:

  - Folded the fixups into the full 8-patch series instead of sending a
    separate fixup series.
  - Clarified that the HMM timeout bounds repeated HMM/mmu-notifier retry
    attempts, with the helper refreshing range->notifier_seq internally.
  - Kept nouveau’s explicit outer deadline because its retry loop runs in a GPU
    fault worker and cannot rely on fatal signals from the faulting process.
  - Converted amdxdna, and GPU SVM callers to pass the shole timeout budget to
    hmm_range_fault_unlocked_timeout().

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


 Documentation/mm/hmm.rst               |   79 +++++++---
 drivers/accel/amdxdna/aie2_ctx.c       |   23 ---
 drivers/gpu/drm/drm_gpusvm.c           |   61 +-------
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   20 +-
 drivers/hv/mshv_regions.c              |   54 +------
 drivers/infiniband/core/umem_odp.c     |   18 +-
 include/linux/hmm.h                    |    2 
 lib/test_hmm.c                         |  107 +++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  259 +++++++++++++++++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c |  150 +++++++++++++++++++
 11 files changed, 551 insertions(+), 223 deletions(-)


