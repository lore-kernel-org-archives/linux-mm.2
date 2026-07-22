Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8360DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E790D6B00AD; Wed, 22 Jul 2026 17:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E035C6B00AE; Wed, 22 Jul 2026 17:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4EF6B00AF; Wed, 22 Jul 2026 17:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB2F6B00AD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 028421402E2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:48 +0000 (UTC)
X-FDA: 85017742698.28.7F01143
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F807A0005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRB7JB2M;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aLLCLDIkaVkTiiSr3am1nl8JfcuH2IYbuxdGPPNwyW8=;
	b=ipjHtEsGPCo53aFrAl7nhB+qz+LV6GaxV3p5KJ9hNKW35fpntvSZ6cg7pEQOIfcAFtFbO6
	0A7YJs+kEVAJXf8yWLJD61R6EVXonfKyVWSTx9O+U5rRCku8bTF5QgjUuBXU/4SDKoLmED
	6PRsVoYJoPQv5eKGap0sJoD+vSlQ0K4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRB7JB2M;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756687;
	b=SIKptO6aF3r/OX0HP8A5cs2s4x4oqpXRD0+XNbDflBZUTXs/obXqwg54izhfXZtpikwbwl
	huoof5BRniv+q5CXj6dpnVBWpH9zHNAj9o+cpfqwnEp1W3C9o40vZxc1HxOo8rEa0g5eeL
	UYhhB5tinARGj4BOt5AykbB9i9hkCCM=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84a2dcede83so12909101b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756686; x=1785361486; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aLLCLDIkaVkTiiSr3am1nl8JfcuH2IYbuxdGPPNwyW8=;
        b=kRB7JB2MeudGapZICLt/H9YivhJ39MubdFbLlkKUEpFQDBo/u7NmQaYROWM+ekIMVB
         Gn0Nj/MxRlr80MJOeBi47DsO7sVhdBAyWyrmUoGGMe39tb6djml+E7xU9NqSNIHhvgbS
         jmkeCJVc2Z+7MKGJ0p0BqW9UqM3oMWBj+NCeFi/ZbmwSOWzrN2CF4UYaKFquy2CD4gHq
         tCn0ghKeWyUZbm2ssKPLnIEdvpxPaFjAdPIbXdPI/w6UdU8YwkVNgsylOBQJIQ7+K8s7
         wtleu/RAqqkQTQf948JWESvp4gk6TWezX4m4IUnbocEUCZhEcikTgp4LoCaeRwrdxUmz
         PLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756686; x=1785361486;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aLLCLDIkaVkTiiSr3am1nl8JfcuH2IYbuxdGPPNwyW8=;
        b=knxd/eTg+YlU7GTJYVZCobXl5w+IoUmrcNutmTMVOE7jDpuoJiwOdbFIGPWJ94dr48
         NtruKJknP5bf5h27mWGi96xUkmr1DJSeKMyvkqZKHeBOZc+9rqljLjDC4JxKhNCnpcbs
         6HyMp2jrdyj4r7u+Wa2Rz7R7EOM2pWYBJlwAjtPydStltBAUM/bdRc91gZdgdq9QbzhM
         duYyN+XqQ662YTrzNAUcROnBIPhGpXtBTJMqWKXMALmWEjmQ/x53NywaoFRCFjd3N+9i
         lI16tA01jFJwxXYkzb/ifvR+vlBssKHmAZC1UrgMN05/hn4YOq2ilbUijoa0GyxQSeB9
         rfGQ==
X-Gm-Message-State: AOJu0YxN8MMgrfHsL207KV6KoywfUmMW37Dza5nPLEZNgFlrV5VU6Xqi
	VPFtu2PqpVgG6kSiQXhFYGnHFqhs6ybQZxcWNLSBoZj4CMTn7bFOwBoL
X-Gm-Gg: AR+sD11cL7fYaoNiCQG5PDMq0hVVn0Fqb5CQn8KJZseYEtA4DLQm232oDrp1ae5hE//
	18XJk5OrnYcnBIldTLnsUjVzWXMu682hjTumCWWKePyQ8VUZ+zXP1vBxP+cW7Nu/a2KXFKfR4/D
	wLhcaKEq0ewLkrZkEmMFdxgM+GS7rhorkbYOCGkZ/PieRe/ylOTCJPuHhaSkEdZvSq96Rpjzj6g
	2kVSwYw2utb//05pFz69FCWH08+DTFSS2l8546Hj+EJSUtj8LMlOmoM7wG64WC45AeCi7unkPrY
	bMfQha5DO223grLo2NGwuneOvD8sKrr2KZ9w0qZX2s8QRlDwrA3J7S9w4JHbvOL2LcKdeLadWoP
	H1Lr0faJPbrJzYk4F8tIjd7fzrZxuI0X/pkBzPTesFt8l7lXWTwIJ3r7kZhm02VFh3tumFYRkCH
	BCkCeS3JKyamahafWwFgW4ESehpwIMaIl8mioPmjkqHyiZVLux
X-Received: by 2002:a05:6a00:b82:b0:848:4424:2b8e with SMTP id d2e1a72fcca58-84e2bbecf09mr656348b3a.3.1784756685757;
        Wed, 22 Jul 2026 14:44:45 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:45 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: [PATCH v10 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Date: Wed, 22 Jul 2026 14:44:22 -0700
Message-Id: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALY5YWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDcyMj3YzcXN0yQwNdcyPzlCSjpCTLFGMTJaDqgqLUtMwKsEnRSkAFSrG
 1tQBIaEitXgAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=8816;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=GYHNo/XGeE9xtQ1NfZoCvPIFOUdd9M9aSo+hbXMqC0E=;
 b=+/kQG1iX/yRHeUfcwg6WZMiVcO3TSQDq9pOkpGr0vDEFgbY5Bydw04mNJ9njGp2oykHM0oS2i
 VmnQAUaI/jpCI1GH6nJe6/niHsBdn0yt1UpO4W6lecLt6cy2N4FM3XS
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F807A0005
X-Stat-Signature: 3z6wtryqe9rb9punckmee6wdmgtqppiy
X-HE-Tag: 1784756686-76089
X-HE-Meta: U2FsdGVkX1+TvKew5SoXk/GDEg03vqXbyxXWJS6GWaNxLg3DyNHqMafRFLXEJ84zj55rAiYoyZNMDg2l2KQIvaPmcLjws9cqSkOdSrHPq9K6Va1iJp0r6m2bBqyMAXA0uzf6v4kH77ho/fznwEa6WbJ5yQ6OO3kdX3Y9GSjoRBuOyFWgd0yPCMz17oyihjYSwgkC63AMg72gKLWoK3uqtT219QUGDG1KwzGf/Oc6OufEp+KlVDL9FqNkifaBg0yb8n7WjVbJCXb+y+Rbt80Ta2xUkgQ7wTtVgn2+m0cHggz7GLLbeoPgwlAP7Jj+yliB8DU80dVV+O9zEexOfDRgiE2SNRR2jmH9FzbKIS9qKwQ1XQ0TGSzhDi0lCMwjlp9Y9jflY559DSmmPv3nEQ2Gtk6JWWry774JRcslQSOlp34hQER9KRXHpBLsgtTNbY5Jc5dJnFIeu0nGu/S5dAogHv57G1EJs348mI4dLvJ+iT9jSx+ldVakefYPX45DiTFj/DIKyLYeLreydq9XvCPiu5mFRXs+aiSNuzfSG6B/r6FoQ1/th9+Oik1nqO7lHNSOWpoSTRtslYXfozUBQdITL9wJ7s9dTor/32uNwsZe55EhBhj3iWJ5TqntfefKi61wl1ecfUtUWMfYH2y8jCxhLJVlu3QU93iLlNPZicBIyZmDofWs9kOWojf3RHEvkJM+LwSgqD7D+Y2qu2g5sTHRGteZtovuLmpPOrzRj9+VqDeaBYWIX8anZaBhsljunn1FYLp2jxb3V53O6o0QEwyOBHbth/NZSHefEe8HMudg24I2Ib4IZJf5o0D7LdJ+jjUWwOG5qNjy0KckBRr33nsxV6KsoK99Y006g7Uh0l65CBoAcQdaQXztcPTkub0ss/9LGq1wvtdX6hNd7BjwkxFVGzXQqgMj100SusplO49NtgMiuoWVZYv7WCGnYHSCg3rkS3XFNu8P+jI6bWg/D9e
 zSQFBjg5
 4PpuZjpO8yq9pVzcrPKk0GCxsCzJueS2JL3bEneHgDEZ6a2kEZeQ7J8qKHr7tH0vr18tb83rs4kIypKnUEwuKRmDn+pNsVRbqQiI1NnwyRpgtRpNA1/ry98WFcWg13H10LsZ9vNhevJrAewKTVj0hbvIOURFtaZrq5hTWFA2jjtnity9QfR3qSOlmp9/NZ26tjCOqpYMcW7ceKHKfQ710hgIl/fGlzhzztKa362bdaZcTLqsKPIFZ01qEvpa+DF1Ijyq/VCbUxzj7fwPf8BEkEeRE2GLtz9mHboiN/dKGWYtXnQyYiQYtLsHZZCz4T6aRhcsr1oFCyAbvjwJ3p1NEY8aA5PYGNQdP8sP2AZ7nVYuxKfVrs1zdYz8llCSCasz+Tn6sc/BGUVZVT1HvphfbdAozf0P9MAizF7AiVHy9CKGVd41P4XbbdUewNPuri5RoVIYBhTGCreJ9iFo=
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
 mm/hmm.c                               | 256 +++++++++++++++++++++++++--------
 tools/testing/selftests/mm/hmm-tests.c | 150 +++++++++++++++++++
 11 files changed, 551 insertions(+), 219 deletions(-)
---
base-commit: a4271215228d2bd2a50eea03ab0a948b36036948
change-id: 20260722-hmm-v10-727db2bb9d34

Best regards,
-- 
Stanislav Kinsburskii <skinsburskii@gmail.com>


