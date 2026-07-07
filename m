Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81983C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDEE6B00A1; Tue,  7 Jul 2026 15:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6766B00A2; Tue,  7 Jul 2026 15:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495B26B00A3; Tue,  7 Jul 2026 15:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D13A6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:46:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F2501A01E3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:52 +0000 (UTC)
X-FDA: 84963013464.13.D561D40
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id D4EF620002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gC5f/4bq";
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453610;
	b=27yJJXGbLQZLYcn62fAhtiWMA+MJ0/5bTD937U5LUGarzfbMBpTVHpQ1BnK8GdE0owAEVZ
	KTVVZTIw+zAPHHH7cuvAzZisTU3Btp3nGjCMvbL84yG+kF/bxK0Snlo3adS5nGkfTzzAnD
	oNH9YG6JHNWtwjzU6Jj+Nw7PtBCS5TU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gC5f/4bq";
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mr3RDiBFqeIYTx2r/qE+kwdslKLjgblCNaiBX5VWqtY=;
	b=oVUAAKsFUu5Bjyj9Do2e1b+EoewpPvKb01weJwrPmZOGA18F3CmH2JMlDFskSWVjqpMOXw
	vyH//+MDQx8e41Qxwm0pQ0puHVmFqLVolNcm4KZYV+j0EEgD+dEYan002rtUtDyENsZmPN
	gk345SCMCOMybWg+eRPGrjApgUUJzkk=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc97653887so31020915ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453610; x=1784058410; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mr3RDiBFqeIYTx2r/qE+kwdslKLjgblCNaiBX5VWqtY=;
        b=gC5f/4bqthWeLEZccJhts8z8gSlL/krrD4OFig/f4Q04bULvYYDNSzhrEoEZE2n+23
         bixXbbmM/z8xvzBkTq+krfA41abqY8ntQ3Ky6N/uBjYQ0VuQ9hlaqCbFkevDXq+HsXD8
         xQIYXcrLE20t/ln8DiZS3BM/iUxNdQUcuGC4/IGP0QK0JcR9JrlWOkdg6m/30SQe7H9y
         XRCYbRUOLcWwJVLUeyEqZ6QGPTtvweGuLaLDbT7Gu/vhkf0rrKz0yMgSJRXPZKOHKfLK
         Am6jeRHJcOkaMrr0LtAfy/NHX05M/yvNw87kffY+I197SczRVaq4IQ3a0H5EW00YkWGy
         wI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453610; x=1784058410;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mr3RDiBFqeIYTx2r/qE+kwdslKLjgblCNaiBX5VWqtY=;
        b=C2m0/TdC42YXmjBLZtcz5cgLXAckaofW3W9mZ6j/V8jaEk2rESHroq/a219Ypyp7m+
         MjNtEh0W5oN04g+sHC5VRBTqdiR+dMEQEzhLO6c9YuTAe9t1n2Et3cn1xB06hcHYse04
         +lvXhovpmuDWMwkhrsdT39p99PK32L3q5vGH6mI+YOo+yRxydsYi2TXsgK/ekrNlstTH
         +c5I36C4xyQMMM39i4ZPcg/UxzfxLc1+UeqMhHMZz+RSim8EbeV+cFHmDweNcEB2urry
         4Ri+9Lz82lV7fIbb35BkdsDsWyNgPxULyQe8/Q1hd9lY92W9NFK6dRiJI3xFbLD3EHTG
         SSaQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro3OcMjttPhkZe0ujyYkjf6lQRWDVt5Gm0t6Zh7IbHYkY4w2Ozi58ny+Y5JfISNmTMF+Vo/GglnHQ==@kvack.org
X-Gm-Message-State: AOJu0YzsjV0wYRKk5b7thB0rA/PG3gG2n8JdSvxTFjkRodd0MjKaxnge
	UiNE5+IF3RMXSFRmxVDgS8CpRKjjS6Dv2Q1VciVGbKKJErbAI1itLCV4
X-Gm-Gg: AfdE7ckIi7raR5jrwUnG6i26G1mAsv733LHccizMbsWTxMh7UVgqOoSHoLUpARC2hNo
	mGH83BS4bjThsxYM1GepqFkcck3E63evqFsDeYux7oMIhtwATMsFmFQGkhB/1+EuTnUcTe/xWlp
	hGt+ZBTSvwViTNYczOpoStJPanJeQSXEfsiXHPFQl82JdWHjGliINuO3h2GGmH9AF2+JcodM8hQ
	jFx6UBdrDYaOfSmWrSpAwXu6aRp7UwR1lrZfxo0mbIuhQ+X64vcAH8gu73jjkoR9A7wwFrkgR80
	v9l21IZwRMfDS0HgshGPWrN+QgG6MWviwkTLRkXtSWRM1lVumUj3bE90hsUJJ90hhi5ojPgDyoD
	b7ftHqNB8SGWjPVFgkzBW8TWDj0yLvlydCL28/DkcCs/ggsDvgHqz05PqAXR0DhYc0mqRcOHLvY
	1GEDPcHWBMR/HFuN87jB0kPEHfLQ4EbhiOQ2g5MBTzXVjgsvcU9nyximpl8vA=
X-Received: by 2002:a17:902:d490:b0:2ca:ef4c:e553 with SMTP id d9443c01a7336-2ccbe40b1d7mr62952355ad.3.1783453609639;
        Tue, 07 Jul 2026 12:46:49 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb86bsm17316425ad.11.2026.07.07.12.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:46:49 -0700 (PDT)
Subject: [PATCH v7 0/8] mm/hmm: Add mmap lock-drop support for
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
Date: Tue, 07 Jul 2026 12:46:46 -0700
Message-ID: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4EF620002
X-Stat-Signature: c53hxyz4xtgfjw45pz3ytph7bag7haf1
X-HE-Tag: 1783453610-698094
X-HE-Meta: U2FsdGVkX18YJ8yzYfgKiUFwNmVEj6uyFCi/FVJ7AO2Tpth3QdQWVn5VDSQKRZ2ygaDRNP0CQBVyzeyQJhOZmwZbdXFj64siCyV3MvmJhYtihokKJfx3kSouzz5vaAPjmQWWFtUqnF3V6gae9+o7+S77rZ7BrT6NjNYnYvzWPzwoFLiY8S09rL9Qv9ckRJOy5vZSFZKfgvfFnkf/qkNcDZpNcm/+6cdn/QQEd5zwvnh4aEIDtPrzcO+rV8wSaqlDV3XoOhGfrTkIUMK0MyQoQVZ54wbr88UysErm0fOYXjA2lipTYlQXXQ5KcU1NBvZjS0VFd9sm+lTkTIFAGEO4t5cbQdK8yFNLZylHcYccQjN5IxMpgauqKHA1V3y9DxbsJDAGSYzxOFQmzY2OnhxwwFt1tZOZNIokHbDzcKzy2MKgWoKm7HXd9ZKk6/JUoY3N53cRnif5dFqQcAMGUm2sQrBEoSLR5FQoRkqGaxlIFmNgPs3ZfL0abI9qnV/kY5iUTOCDb3W3FEejL5pTOKe/QgkJuAQU2EkvR+h9A0oAe29IRcjSWzPWvuoeA0fAMge/HNm6cvpH1zGPlK8lmD9ro25JRUsIPIPTu9m7HSPxyS7i/UAO1k9xi52QcwwtFAH11mth2dbxj1b7kGn0AcrI27pqiAfHJ2+OZGsk+FXPy0o0J2wyioktpMAUS7M73OQtzcHNVno537i2KjEPhXuhPUE0/DW8UpZijAGmmrGfefcDweUwPEmxsQ6tr/ou8yE5hz939S8r9HOabVGn0sQ5UOcDQ+UoOcJ6RAjtCxThj4o5rcSQa5fphk8nTJoq/4SKa5ZAQMOJIVZhIFPmx+KozvM192g673XfatfebQpdiEEqB5HUZborWt1pv6QrKa+hJ56VcFsj5/HRkMVHn/P4ZEr0sCypsTYlNuWQ5wquyqscpM4T0RCQzFAz/+n1MYb1YFgcPeWA9eIg0VRyohP
 1YS/gZJm
 w6QNFBtVsyGmyi1L0PFGJ0gvQquaKSH5cVMRDQVwfuiVTUVI0ZMThP2/KsSWKd2SjO0Q6TaSXRfILaE3oYRyYYQBzYGNiFfgqIta6cj/d0zWJtRmWsR8R/5zkBEhg0WcikoKvcOkhPF4Ap4I35HWlayJ6rUvt+EHkU+O/3XfoapjeZFE6vMJmGfIr+SEUMGI3MBa/wQ4pyQRp5djIIlonWaCNurFafHvjrqVnACWufB/+oQ7rY32B4NRB6OefI1hasu10QZB++Nr8C67/3SF7WnrqBxY/Q4HCoADzI2H/WGj0DnZTimK4IqiAUaHtwfIL9iqKlO+iZK9uEw+2wNEGVLbQoZxHtuUdDGxHf4puHHyooSbKQWxw2bDfQVlVuqjIEdNlaR8+rQc611zh5XL17T/gfHFaFm9UgfheBl/G5+bPVZH+ta+9MMqmk0RbxtO5BrCEdETHjxdsenqDYGa7NQT81gQOAQC9aRtDivyDBduWN/IR2yvuSzF52Fg21hL2fz1hZb1Pe17333w=
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
      selftests/mm: add HMM tests for mmap lock-dropping faults
      mshv: Use hmm_range_fault_unlocked_timeout() for region faults
      drm/nouveau: Use hmm_range_fault_unlocked_timeout() for SVM faults
      RDMA/umem: Use hmm_range_fault_unlocked_timeout() for ODP faults
      accel/amdxdna: Use hmm_range_fault_unlocked_timeout() for range population
      drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for range faults


 Documentation/mm/hmm.rst               |   63 ++++++++
 drivers/accel/amdxdna/aie2_ctx.c       |   17 --
 drivers/gpu/drm/drm_gpusvm.c           |   52 +------
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   11 -
 drivers/hv/mshv_regions.c              |   54 +------
 drivers/infiniband/core/umem_odp.c     |   18 +-
 include/linux/hmm.h                    |    2 
 lib/test_hmm.c                         |  111 ++++++++++++++
 lib/test_hmm_uapi.h                    |    3 
 mm/hmm.c                               |  246 ++++++++++++++++++++++++--------
 tools/testing/selftests/mm/hmm-tests.c |  220 +++++++++++++++++++++++++++++
 11 files changed, 613 insertions(+), 184 deletions(-)

--
Signature


