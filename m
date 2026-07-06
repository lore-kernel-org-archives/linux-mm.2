Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D1FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5416C6B00B4; Mon,  6 Jul 2026 13:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518876B00B5; Mon,  6 Jul 2026 13:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455E66B00B6; Mon,  6 Jul 2026 13:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 151D26B00B4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:54:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A9B0401C4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:54:58 +0000 (UTC)
X-FDA: 84959102676.03.98EB702
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id B730340004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:54:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jl/J1BQr";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cnwJHJEouqLhDU4VS1gzSe1nEPe1/QANOGjZf+5gN18=;
	b=gZW89F1A0XLgK6sFpGpVaswK/v7QQlEpko1i5km5D0y4U2l9PrTrXEASbH+LlUvn2DW2g+
	fS8NB5CojF52Nnp/i5NS2hY+SY2c/3FWXfgFt6U8N2hBKMOV5KGj3w/q0dCN3GVHkM6AAl
	Zs3W0vaHcKcwqhDQvahPEhTaixsU4xw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jl/J1BQr";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360496;
	b=RFB0QFBE6Nr8iyU7C7B6Vz+Oe1u4wGFBlwS9fLwm3+80LAVu11Wnigb6YUgCkfgu0mSxFz
	re6uZTyXW48xWWfQKJpx8pEFMYvgDSCt73Pfy77rOv4Y9NHSxN9mH7GmCYEBA76tZcJJs6
	nO8ZDHLuyWQgmJH708aWVgEzZllXRNM=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cad8076b01so43000485ad.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360495; x=1783965295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=cnwJHJEouqLhDU4VS1gzSe1nEPe1/QANOGjZf+5gN18=;
        b=jl/J1BQr0BHorwD9HcyW7FdnkdmJ4a6/Pk/vnyqIDdTCCgIoi0GXAuYouqMRkBwXGz
         l4J5HggMBRYMapc00P0VBAyQ7cF6+bCEyU4U84muxdE1/s0w6BEvI097Mv3dPp+KF9E5
         7WkCeJhmiOTx2dZA//m/lBPJ/yXz+HrsCrB0cheJNKzQWNIJdwdjy492YxGOCNtCcVCP
         uftLCePoGwQChnM0ocGeuYPl2vxOIRg/E+W7eXAK0Vd/TLJnrFscvRsjPaPLef4mjKxY
         9Oyg31HOkuIZZtqUSMZo+GqKcjy+V4KDebXaSEo9b76aUT7n1/RwwgBfy7bsJNxr3tQt
         tbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360495; x=1783965295;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cnwJHJEouqLhDU4VS1gzSe1nEPe1/QANOGjZf+5gN18=;
        b=kFHs8XAn0IQy3Sgx20hA+aDRvSMwgaGcjga6SRYNGlLKw4bwJRYeBPKFNDedhLWvqp
         hEA4CxbvxfJc+InTny2DAX8sw9thSwqW+IGSE5bqH9Eve5VKKPAcGXGdTliw9UdqMtxr
         9hmPtg5gGlLD0APdREKhLY741Am6rb90TVNba17wBdxOAWZHdjE0qqGfTADkiqBRBdxj
         oPos/manUculfspw/FgVQLeWoiEL29jtxq6qOH+RLF7N1Lt15D/1hTi+jNLPtba7GoKm
         1mzhKAZnJ32a1WCRacV5VJMg4Y9/pj8IW3uLWjqK5hVmiYTa4OIIOiEHAJfpJb+dnCQL
         9cWA==
X-Forwarded-Encrypted: i=1; AHgh+RoEunyGfIGg3MbqYsvImB8oOjC09W588eo4Yg6eum4blavfKWSX87Y+yBhPYZNOG16E9iGsMF6W5Q==@kvack.org
X-Gm-Message-State: AOJu0YzEd/t3k8ZYEIc2mlnNPizeStIVeKCqrBv1x4TumWUMbnn2HDzv
	qdyKChePMeRm7Tjc5TOWw2nMoTQP1yc+Wga43hmbRScmljSkeokm0pgE
X-Gm-Gg: AfdE7ck39On/CjSeywst8KGu+ae7OlTvrFLvqFVkQJtBKyMH/58YK7p0BrrVRc54lpt
	HjqerhTl549UU0by8870MqIhdyITHQWeIEv5HPH+W0W0E2pI8eY70CY8Xnq2x5JGqiFGgbxFgq1
	D87LoXoamnPPxvxlbtsgFlvqxGlWWHS8BQESzmMrK/x7JpH8PsQ+CVk991odpYxf3mSQp/zUU3t
	tXkwbQi85J6N4mmVHKyk3AD7P/qWKqkoVnAZ6vjVrmvB0HBfZIacT+uJbY62qkHg0jFjectAW5Z
	WW8uwWiG86n/C2UVV70HyJ5xJfStIpAcr0dP3k7VEXA47Fw+TDwlrfqW+91uWk3/R+QAZMEWGFA
	mcqZDJZIYt+5iiLNZotWFISsYTizIyoZ+HUu+OqtvzfxZBslDdAdjTTWRITQqtoPaxO1ldAHmQ8
	vG8NS6xpoP4jcNdpGfXSdjgd+OPhp8JF74pJEjGx/xSUOjywJwTeXW+a2YdXw=
X-Received: by 2002:a05:6a21:485:b0:398:9b42:69f7 with SMTP id adf61e73a8af0-3c08eed6b41mr1940825637.39.1783360495452;
        Mon, 06 Jul 2026 10:54:55 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e927a1152sm6529965a12.29.2026.07.06.10.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:54:54 -0700 (PDT)
Subject: [PATCH v6 0/4] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Date: Mon, 06 Jul 2026 10:54:52 -0700
Message-ID: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B730340004
X-Stat-Signature: qooheju5ou3hasqhffp6g9xu1zfexa5x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783360496-462235
X-HE-Meta: U2FsdGVkX18nhL+fbrklLGWRC5aNXgM0Ee8DD4nrQUrgB3DXqyyrYmAaVyX/YVOHiGDRqqoPktf+oalLIDwnAYk1vk+ZKv+VQUc5Cvjjl7Fhdc2zF0obKg5XkhbSJKQSM2SEuuCKf1VuJn8/UYQduiht0rCbsQ69ZobhEp4RAMgNSCkjqCZj8jr2HrN/cvJrtFDY5DlQmKqACUcGIA9wGcYJB9p5ZgaGCl5xo+JczTA6SSdoPrhOURGAlZc7nqmKnENFm6d1VSXZhVcMUBJF2bBgmb8FIwpIg4vCt/1451A5JWxSvnUFzWc13S+5nz11xzdtQGpdi7+oWNmbdWvbwxZV+/VbLYn20WAj23/jLhN42dR+pKqpcKd6MMsj2konztIpWOYxdODTGvswN9plWCRuTrp2btWwxk6XNJMfPbpqrqdShTdSOf3fw4S3kfSEaus8FtPdSk5WbAsu5Um70iNeTyhOXPm9uQJajRqV6FuKb6djN2iVqZrn2xgrAFvjz/9zXot8eCSP72RyplnREP/4TcepwVJlgXjoefQR1re3PriQzBtuTTZRQ3DIeZl9IYqtbOuT0pFoStO5BzrnM2D1Sk94nt3aAsaT5AngMoYNDmoSfMgSPOcU2f3lpPJOq+UBeUXzfYmCMHwj6KJzI0D1tdY3CDEGEML5QSOzKDApGuKceJNzVBEa9uCYRwh/1WuXffeyoIOkn9Umo1MEQaN5sFKr60xFxXh735ufXVSaYKepYURUJNB3u3KKBSGP7xha7y2wtfxKMDe7uGvZungqblyycggzPQKXclNhSb75ZjtawcdZpKbWmur4LJhHPJ0B6Std6TOZ7yOpcqy4RKfJhYyBdPYkFLOkCQOwgbA7IYg56Z2tCd87wubQsPimgI6gjw/HSRdRTuhvUXdCCPCBf29GVf3QjrjUgEr/ExFyUoNF9pP6ltdB/XVj+VWkoOdWs5aWsojO2mvEaAx
 wCN/oRWf
 akZrfLol5QK2YcsbK8bQL45yzfV7Vz5HEEwJTfxFT8GjvXCGwv/zHSN0uru79pe8ubzgZ43TTPjpdGZ/Iwdgrn/kdcwYvyKT7cA2KeeFKfG1lz7g7bplqqoKqxkkyiQR0UxLQjh23n9BzMpSFYJTM56WLvLc69VEXcGUAVPWgN82/RKqam55cA8h9IvHVDhVJI5EolxIcJycbf0TTCHZb/bUvBU08GSprfIOcJgzgIrxK2Wv0BKsBjocd3JTq6Px3ocZEfKH/RHA+imgj9D9I58tfm+GyQGhbhRwHZM9sOslNcnkNRjmi6kf8ihmvVmdKxvcHadBmE9pMZ7s7VCWzQgBTDUzubUtNJCTf3qFuFI+kCIWueWVe3o5hCMH37LSN3ZN4H4ff9Cy6hAZZbDxxsVGKxjvJ9luEUvlkprc/9PLyIFl3FZ0njzSEb183u6Spth/d0BU/TUQEpeYGHjS4DuSIIg3O1BJ72DLpUJwVpvvff1NxZi/MA3BBwXMcqY+FUL5i2mzDmYJ5SjcqigB+2xPYcIlg2sKZyV4Ca+BSS1QnHGg=
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

Stanislav Kinsburskii (4):
      mm/hmm: move page fault handling out of walk callbacks
      mm/hmm: add hmm_range_fault_unlocked() for mmap lock-drop support
      selftests/mm: add userfaultfd test for HMM unlocked path
      mshv: Use hmm_range_fault_unlocked() for region faults


 Documentation/mm/hmm.rst               |   59 ++++++++
 drivers/hv/mshv_regions.c              |   14 +-
 include/linux/hmm.h                    |    1 
 lib/test_hmm.c                         |  114 ++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  223 +++++++++++++++++++++++---------
 tools/testing/selftests/mm/hmm-tests.c |  149 +++++++++++++++++++++
 7 files changed, 492 insertions(+), 69 deletions(-)


