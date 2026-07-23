Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30072C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D35C6B007B; Thu, 23 Jul 2026 13:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5843E6B0088; Thu, 23 Jul 2026 13:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473516B008A; Thu, 23 Jul 2026 13:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 126006B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B093A0115
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:47 +0000 (UTC)
X-FDA: 85020746454.20.4CCB1F8
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id B092940009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bXhKliwi;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hxuraTQgEZqYbQmSAqLAHqtM6r0YcdQGYrnF3lC7WW4=;
	b=SgPILKQT56T0FpaO2fRbwfxWPg+Q1JO090KaPiT32Ar+/IqpLYtFkgYIFdZ0peHBqX5GOw
	WBhIlir0ZjDhYr2YwCHpi6XQMYktJcfen+ufLsVL17zbJepBU/Yp7HrTBt3HYetHA0W1tv
	YeXcTUJeCA7slEPACQd2A5HJP12bH4Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828205;
	b=3nxb4jg1ae3KwX00AAu9EGIFeb84o2nfHnMGiPt718OrUZUKXi60yWc5M3/oS05tZ4jmzV
	3RtlDaXUIOznd1wjHg3+6RTgwGE2g4MWXFR03YbZGZFpX48LSO1a4sF5kPKVyYoOSlCfM3
	G3/tPHe2Abvgafp1CF/NpqTs5CSRdBQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bXhKliwi;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8423f236418so772571b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828205; x=1785433005; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hxuraTQgEZqYbQmSAqLAHqtM6r0YcdQGYrnF3lC7WW4=;
        b=bXhKliwih9q4ciUhA12e5bF3ulfnNX/Q54p20TNN5CnsWhATiUj5qci7r2c2rhBJdf
         B1MAXMpcgX2/J+Q1XFSZIl3nlQhaae1Kl0LO/FlB/WJEEzefz/np0VI3g2m+0qFeJfzk
         motvErYrS70QQNBVK3uD622IlFYW6DkuKn2MlDcW8iewyof2rbhcVPv2fx6DsW9prbZv
         2b+p6j+sRN/fjoBxaRnWD+pFxOUpx9+01Y/Yz2SbbrKhyF7S1PvScjHs9kOl3qp1BKZR
         sxpnEqxRsSPk4LDd/1+wWDDXhZwWPMjhIH2RZlwsY5QDkmnWnnYrElD+dt4X/ozShcQH
         B7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828205; x=1785433005;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hxuraTQgEZqYbQmSAqLAHqtM6r0YcdQGYrnF3lC7WW4=;
        b=WaToblVfLHNwa/1Ks0dPPGDMYjDTrEUaKTEePcg2FF6lp6OT8k53SJCm0X4g1iDfW9
         XxuOgL5+ALx1m64QKfodm15MmyLmo3OA6JV/Sb1nDggDKTpHiuYHobrWHSUxU1iNg3Nz
         Dyb1bYsk+DBSlYAhuglkH198npiUGeDaFihd98jRC+wPFrlVEwtxqp6w5arkblkhWpxi
         j3tWzngmlx+YS90cWeNJ01tQP5GoNjQlCq4n+mDLmA6Bnth5b8/fspWOCkaa94XMTPgt
         uH4FUluVSUXHU86Z5mRDvAK2kkzkdA0P2tjCekF4hXQx7NRZ/5xH3/LQmSwG/+W6LE22
         JnQg==
X-Gm-Message-State: AOJu0Yz5jxZnlR1dznYz8BmRT4xAALi0+SsfTQIs5WCBcQ8vTzA5UZGq
	s/ywAEZBVqlkAwy++F5pwInxLGlk19ICCj6OxyAH0UFp5FoSblGjZJDP
X-Gm-Gg: AR+sD10uO5Y9IWZvQvmZxzMt899vAuKiTKvC6b8kpw4itMuCUceGvRAN2dyhh9EMv+a
	mVpkCa5GG9YLG3G9sfY+jlv6ydiVMVMzbgcJTVvEKd2ahsHHSNFBgEb++tLa1GSo8Fki7tglmcH
	YLvBhuShgDzHvHi7zVqx48asG/3eFLEVKS1EI4J55fGwuN5EN299lF21S8oWVvWj6GYkYHLIhcu
	H0NggXoXk3vZAJ+gaJHWZ4m3uLNMSehhEhwxAfj2KmvRGoE1x0zyP0XUMd12DKe/vZdqt9svans
	DUwgIfWohWf0HjareiFeC6+MV7IqBb94Wil+ZRvdjEnULaOx4mgmS08KwFsMA/CwE8fAND25iT/
	IEoYes9ejxOFP/QuGayx2v6NglfTCxrha2dcszzeQU51aG6OI5jzmCR7ZudJo/NrCzXWrNkkvu9
	dUB8ztJDmdlG5wlAAzBMzQPQGZhgZM7bH2gumkfDYcO9TtPuOd
X-Received: by 2002:a05:6a00:c81:b0:847:7a61:e68e with SMTP id d2e1a72fcca58-84e2b8da6e7mr4786213b3a.31.1784828204458;
        Thu, 23 Jul 2026 10:36:44 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:43 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Date: Thu, 23 Jul 2026 10:36:32 -0700
Message-Id: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIACFRYmoC/2WMQQ7CIBAAv9Ls2TUsEoie/IfpAQqWTaQ1YIim4
 e9irx5nMpkNSsgcClyGDXKoXHhdOhAdBpiiXeaA7LsAKaQWRkqMKWElgUYa76RzZ39S0OtnDnd
 +76vb2Dlyea35s58r/ez/oxIK1EIrrbzXgux1TpYfx2lNMLbWvmvz8dafAAAA
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=9167;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=5RWy4Wkr5bgViXPrkI5IwkEQLLeakvDDFGFaJWM2Tgc=;
 b=DsSTuR1DRqaS/DIFjBB8yCQcyfhxOja730tI0RS6QEUOq4R2IPDJiPT3gyE6F9ZISrvwMWuad
 bA2XAbxJW9GACTx9F8w3yQ1BguR31nmSesivxAsNeNCUTR7S8vF+PaT
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Queue-Id: B092940009
X-Stat-Signature: jthu8wpmtw99ew7yhjbucuc4rifazhcm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784828205-699532
X-HE-Meta: U2FsdGVkX18b45GfGUPJGCLRMcvZFDQRAK9OE/gv52tk5gLz1pnlbqnpe9X7pKPesA3fR/p3zCRSx6mYa+/TnhxvkCtdUsrfvywIjVN0UoE/htZhvGfm6N8UcexmdqQPn1EmjUkeNCTvDiDbIfNbONueNLONQYN8arIt1b6JnKhMrxtym5HPyxdBn+uARUFDrZnNBu7zWyW8LxG10MIflWM/e/aumBJmE7WVma9vTEwh0VDPSFrs6CGcsVGiYKNN6xkHLwMnKpe9ihhgC+wDGOF5cUnwjk2RivwoXOUxFOPF5+skk4FTj71NionuOA3enl72lEHto4E9glpgQcTB4iM1ZM+ATx+pvMskvwWUcHmIuk8niGqMNbeKIPzwGwejp4aEp3U3JF5Zew4poeqaTrd/skG8r3XbNmpb+JGiE6uSBUIwd6J5N5tkUBrw9kz9MDJIgUKpMg1oLD1BOt+PZQR8eJLPEmBK4c6FMeXfw67j0vBaHEqxTdIr+BwbFMXHC6JP04CXXBC8QJv8dxphJa+qRc2+00gwrCAX8AeJg5vFzl6wSLJmvuR92Gs35ABFyBR/LGITSUkbCYoiWJMP0GBAc+uIA6jHe1NUb+Xj+N3sP5mwq9C3Tpfjp1oV3CYBOE5zy6QcJMKc1+r/ljr0E1V8rEkBgHLG7T2zp8Q2x84sK/JIXm19DRwLoEI1kfcuWtGmxtXVWMUxI1WHoxn/GK8bjo5CMiaS2ocgFUQB1+t0iAeKBAn4rgwNdLXavZhV5WWt3XAopb8hNQdWZ3z7qkaY+Ohi//mOXdsohJRr4sDYLCnxUTgh5FnsJOjJsfekj3YBVqRz9nxU95zz1b+VqyMFaQ4m07A6gviyL8cVhtg9d/3aCL0ddfTjpc5UGItkhIE2ycG/GKAraODGaXE4TcJxK8kNoGc3i+9NDFKr5GIMid4qDZxQIenQVpwROP6jq0UlZ4PxVCgdVZBLomg
 8qDm0Qup
 112XekCvbxGQIN3SA8DCES7BsuTlmRgtfm/4zXjyx0Rrs+5UL5gIzPEvUO9Hhrs4C1CXizbcHCDOPGpZ2PM046sqrxmkmKFoFJgY5Ypjkczgj+nCzmXNELDm2Ae7HsFCDCOzpR3HpxiLQTNxHB902FgDAo0R3OClCgzyo84njivICzBaQJgh2peKmmfS8M6cRBt+Wc8yTaAPLnLqCqu7BHTLPhuwE72hE0ACTgWljLCpPOdHwhz744E5o5eR0p1NkriOdbfl9Ge6xUowPukx7Hl5yrOf5uN3lXs+1laJUI5Nv6JnFijTe4jR6F/JkcD3zfPWDPxFTg7h/lW1idKWAh1IjQtbezjCYVeYgNMReh83ZtP99gcNsJkS8Brpkp+oMBt8VyFljeZOrf0mA9flc5sO/YsvkGEy8lfD2O3wWpr8TFe8ku1HnK669r4S64GUYZb+WmTRiRN42Y3k=
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

Changes in v11:
  - Reject unstable address spaces in hmm_range_fault_unlocked_timeout()
    after taking mmap_lock and before walking page tables.
  - Compute the remaining HMM timeout budget before the time_after_eq()
    check in drm_gpusvm_get_pages() to make sure it can't result in zero
    and lead to infinite HMM range faulting loop.

Changes in v10:
  - Included contended mmap_lock acquisition in the
    hmm_range_fault_unlocked_timeout() retry budget.
  - Dropped the redundant top-level fatal_signal_pending() check in the HMM
    unlocked retry loop; mmap_read_lock_killable() now covers that path.
  - Restored the absolute outer timeout in drm_gpusvm_get_pages(), since it can
    run from GPU page-fault workers and must not rely on the worker task’s fatal
    signal state to stop invalidation retries.
 
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

 Documentation/mm/hmm.rst               |  79 +++++++---
 drivers/accel/amdxdna/aie2_ctx.c       |  23 +--
 drivers/gpu/drm/drm_gpusvm.c           |  60 ++------
 drivers/gpu/drm/nouveau/nouveau_svm.c  |  20 +--
 drivers/hv/mshv_regions.c              |  54 ++-----
 drivers/infiniband/core/umem_odp.c     |  18 +--
 include/linux/hmm.h                    |   2 +
 lib/test_hmm.c                         | 107 +++++++++++++-
 lib/test_hmm_uapi.h                    |   1 +
 mm/hmm.c                               | 262 +++++++++++++++++++++++++--------
 tools/testing/selftests/mm/hmm-tests.c | 150 +++++++++++++++++++
 11 files changed, 557 insertions(+), 219 deletions(-)
---
base-commit: a4271215228d2bd2a50eea03ab0a948b36036948
change-id: 20260722-hmm-v10-727db2bb9d34

Best regards,
-- 
Stanislav Kinsburskii <skinsburskii@gmail.com>


