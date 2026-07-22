Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F062EC531BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1806B6B00B0; Wed, 22 Jul 2026 17:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E876B00B2; Wed, 22 Jul 2026 17:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50526B00B3; Wed, 22 Jul 2026 17:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8F1B6B00B0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14075120162
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:53 +0000 (UTC)
X-FDA: 85017742866.30.5474ECD
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 206EDC000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1ldkDwO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdx7YDLo+QMjlb8j72PZyp2xuVmsQJocEMpMp1wNFRQ=;
	b=PsfajoHkSbkqJSiDxmzX1o+qOTS/Y4ZpytkmR8pXI1gId4vHHHuVg8kstdbH/MpVsbytqz
	OvWtirPAKBeBzCtOd+BiBDOeJHcYMpUB6j8LAA0SRWuJyACl4ZLzPBTWp/yRSON07zhieB
	Yiz5ItqhzN0XXwCGbO3t5PZUNBcLaBM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1ldkDwO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756691;
	b=gb9wHZS5W/1scYlRpFYm+WVs3XltzePZ0kGq+q713s9ZIwSuhXPoWjyV0H/Sgo0yD6KpDh
	YE1G7jyKoKMaxhwI/1DAXegPiqPnzaNlvVvGTHCIgnPLXwoJbK8RETM+lGY3aW5Nyw8pWP
	Zp8YgtbKRL4IIXFFcjHrh0yVDM9ejrg=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848761b5897so7298453b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756690; x=1785361490; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdx7YDLo+QMjlb8j72PZyp2xuVmsQJocEMpMp1wNFRQ=;
        b=B1ldkDwOA/6rGnUZAJH1ewsyddzuf3GtkgJyOpEzqvj/FgAGKqv4rTNWlJ7ELc27HW
         T6C7HLwppSS8e4Bc49fM85Vpy8t48FfjcYedXKkoQvdhPN/TgwIwOy/muOthP8Y46+kA
         q9TosAbYKRMbNhEAbvYWg5CKDGeP6PtG5nVFcex/iJVB2w1iXvVbRBHhmZXFRD07WPl0
         QdpydXum0VXkwY9cPwC+sqfoOEp6JbRQYEim/8MeFXfCqRzfllhvzqWTHHvisqZtYLJ3
         ur/5dmeqNoS/DLl8zMqpSDMJEsQn5jE/GdgtGqXpwFn2tCZnxzYJaxFDvT9olzxV7cyz
         lKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756690; x=1785361490;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qdx7YDLo+QMjlb8j72PZyp2xuVmsQJocEMpMp1wNFRQ=;
        b=ZT0BaL49Nvma8X6yxP8TL/rdAK8Gwlj5buM+NI9W3jfU/+cdW9nhF+thFQpMkBP6QY
         bcno1T7frNIfIAupnGZ3j8rn0WrlYs4Md4NHhyrEPAKFOMoPG+deY2p5McZxAS8K3ay5
         xlgvkfKOm+P3a7un+GJARLIB1QD5zziVQeW0cssLiooyMj7cxfgrW8slC45jRplKN+p+
         dLpGHyagQU3xJCKT9BfqnuPVigK3vGkZFuYzvXkYvp7f+RWBbdO2b0hFk6pF/GWePfR4
         bbf1Ux/kmVGkUf4KjF3dLn1I5wrSaMMNFZ3hBXaMqug8OfDhW1+Nhd6vQoMGnKog8qO8
         AeUw==
X-Gm-Message-State: AOJu0YwZrml1DfYP/qKtxvdBo8vVQnedjt94pzmUb4pI5onMeBwpDu7E
	STzMToDEv8nVqgdWYgxXppsVXMkMMCBKaKJEhnv1172NMZn7wZ/VAjI7
X-Gm-Gg: AR+sD1278vAAUYaJGs5CTwcpmyQw9nXUAF+eyvuIdD+N/8h6WrGvGzRw6Ws0LDLeOsE
	r6Fb/q1+FcOyFiurxsD1e9uENAwIKiapM13B59xXR2rqemw4HHvD2uTP384v4tM2a7+3UF8MZqd
	gR3HBK/Vo3I+z+y9nvD0VJhUMDFcT72AIMwsROwBMSjLZms+JhR5+AI9VDzf3kiodNOnO665eZh
	MwdnxAjEjGc80+jLAiCZNFz2M/ncBIt91bYsWx6li6rbXee6hXBDqQw7E2UVcxE9jZj35qps6p3
	Ge1gJO6U53DtARw/NonqglnH/kU0mSQKYKsalSZBVMVDG1IKcC0MSNVwTl8qkPYfiIgIRe2VLdi
	y5OGTcUKWmKd+nong0H2J0ROlj3pttFVJpApejHErRj5rTKVECF41ZCOKD38EuOXZEwXj75z4FE
	KMNOcyax4QnApN2AGmdgp12DvVo5aLUmbOKdiw+S/982VNF/W0
X-Received: by 2002:a05:6a00:3d12:b0:847:98ff:4af5 with SMTP id d2e1a72fcca58-84e2b8c0da6mr711681b3a.26.1784756689863;
        Wed, 22 Jul 2026 14:44:49 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:49 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:24 -0700
Subject: [PATCH v10 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout() for
 mmap lock-drop support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-2-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
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
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=17250;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=phNfi9QTZkEVMxoyJ4Ni2C683NZl0Qp7ozSXMuOXsZc=;
 b=kdDY7nuq9dEb1iZ4WbkS/DHv4ppZRm5lPwJw6yGAjbvELwTl1EY7EymTqTd5YgPoTrv7RCNjb
 88j94dyszYkAJMGpJIEF8Ri3EHQCYEvc2wgoWxeNxsDxqo9XW7LOnwV
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 206EDC000D
X-Rspam-User: 
X-Stat-Signature: 77xcsrh4b8qggamwf9innzifewjcxi46
X-HE-Tag: 1784756690-954380
X-HE-Meta: U2FsdGVkX19ChmpFLCZUf82pAJaZX3mi2qb2YKBDB874ue+bOL6KkOCLUi0qO7h4ayQIGLwuC9V0y9sB84g/fV75UQ729BiuJvvCoOSkZEPodQ539qh4OK+2+yCdMgMFlqNWtKgypwHAyMriVk5AiOysukrJT5LWKSJGQE1YCCQWnEDZUtZCeBke3rNQrvbCrYITLwc4gYEozt6+td0nxPzuUK3jdnGQ/hEAlwem2esWU3huojkusdVTnBdfKdMRbcTE7nz4ioZvYBE5yeSHQc8DXoWW1J2n6QYj86hNmqADX6wOBjr8s3CN2kilgL0JQH+kfs8rcKYCzYp72ux5QY7QctEGm+24IC1QGbMbvkI3+QF+kWKCzNRlpYcpB11NlyfYEx7mPdEByP5t+bLQmAR1qb5bD/1WQUJ8hC/mBPECIsR61HuN4eVsGAZY2KWqf6maIKOkSeGtzhw9HBYfze/9Z4lLfxV0Nf3whigu6ej4YlWswHmzYMgv7yx/0o6ob5hmkxgV7txrmXd7qkyR9rILjkqdqYOqJwQwlxKWAux/Y6rH6WfCN5GsbU4kUM1NHvWMRSQ6Nz3kHEjoj7FiFOBfczM0K8sfQQ1FJRGFfJ1peOUCq2FpzHBsoO+coa24WYH/GxAagFKjetEK/k1h0GL2o3QPc9+RRAYozxLJB82kzZv60PnuABcZWkixsj42elqEj2hQFcML3iIEpO5U+PrpKCK+Dd6zbF9AhibkXQXC1LfJeURMfdwo3KukD3F0fbMUVPE2yuRFMqUqtbjrbmGUo65HdCM+Dmc1VqwjwPCtIRBUXp7SGeSXmW7krVJLycWgHqpn/DJXrDbhv9RX80gO6iAzB4AWCiDVVX6iBxXR2aQgopi1kuBwEFg882aarg8WLXffcQW7R+wS/mJhfX66wPU3ksUXU8uK6Um6553yFINDQNmWRSLudyqknJxHJ6uL/vvNZWPbhFEuQ2k
 bU4Vct3+
 hYYXhlg+/sc672+8aZH9LSCx6z//LTzK/6EVRElYmcPBeQWtOq+npXpnKZ6n2RHeO1wHPfQKhUeFsz4NfI3A+ypz32o3Wdmmg2sP+7XueIqVopJ9TzvCCm/ZRt5wx1HpoG9s+O8OYqJBmb5xSYgtio59Wx3r8p/qzR725GE58ghmgSaYVXzptETwJtXpqG+6vmyAdjjvA2Cr+Ds9iOhfLEIn/LqvybtDWfo0rNLqJV774DnywOuOZIv/aLHGA0nt46/SasELS7gcqKdEhcvxqszvGkoGBoEHdxKp2lns7ZqznyyDpMny8fBzz7P79XjIuVVpUMoEPE3eCTrUy70am9kdBknMfqB81NjcVoqZMhfWuBXdsixzzZnVCS1r9VxS40bXyNepoprujHmoqPUOAKZDMxzsplAoGcIrL9EwNEJxjuC4UqHqb/x9H/ON0gta3cDU0JTLlj92dNqbwfRavX4MNPJ+UuDXFEYBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() requires the caller to hold the mmap read lock for the
duration of the call. This is incompatible with mappings whose fault
handler may release the mmap lock, notably userfaultfd-managed regions,
where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
after dropping the lock. Drivers that need to populate device page tables
for such mappings have no way to do so today.

Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
mmap_lock across any work outside the HMM fault itself. The helper takes
mmap_read_lock_killable() internally, calls the common HMM fault
implementation, and releases the lock before returning if it is still held.
The timeout is specified in jiffies; passing 0 retries indefinitely, while
a non-zero timeout makes the helper return -EBUSY when the retry budget
expires. The retry deadline is set before refreshing the notifier sequence
and acquiring mmap_lock, so contended mmap_lock acquisition is included in
the retry budget.

When handle_mm_fault() drops mmap_lock, or when the range is invalidated,
hmm_range_fault_unlocked_timeout() refreshes range->notifier_seq and
retries the walk internally. If the lock was dropped, the retry deadline is
also restarted because a lock-dropping fault handler made progress.
Ordinary -EBUSY retries keep the existing deadline, preserving the caller's
timeout policy for repeated mmu-notifier invalidations.

The caller only needs to perform the usual post-success
mmu_interval_read_retry() check while holding its update lock before
consuming the pfns. If mmap_lock acquisition is interrupted or a fatal
signal is pending during retry handling, -EINTR is returned instead.

The common implementation conditionally sets FAULT_FLAG_ALLOW_RETRY and
FAULT_FLAG_KILLABLE only for hmm_range_fault_unlocked_timeout(). The
existing hmm_range_fault() path still passes no locked state, does not
allow handle_mm_fault() to drop mmap_lock, and remains a thin wrapper
preserving the existing API contract for current callers.

The previous refactor that moved page fault handling out of the page-table
walk callbacks is what makes this change small. Faults now run after
walk_page_range() has unwound, with only mmap_lock held, so dropping it
does not interact with the walker's pte spinlock or hugetlb_vma_lock.
Hugetlb regions therefore participate in the unlocked path uniformly with
PTE- and PMD-level mappings; no special case is required.

Documentation/mm/hmm.rst is updated with a description of the new API and
the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |  79 ++++++++++++++++-------
 include/linux/hmm.h      |   2 +
 mm/hmm.c                 | 162 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 191 insertions(+), 52 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..e021218ada58 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -156,42 +156,57 @@ During the ops->invalidate() callback the device driver must perform the
 update action to the range (mark range read only, or fully unmap, etc.). The
 device must complete the update before the driver callback returns.
 
-When the device driver wants to populate a range of virtual addresses, it can
-use::
+When the device driver wants to populate a range of virtual addresses, the
+normal interface is::
 
-  int hmm_range_fault(struct hmm_range *range);
+  int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+                                       unsigned long timeout);
 
 It will trigger a page fault on missing or read-only entries if write access is
 requested (see below). Page faults use the generic mm page fault code path just
-like a CPU page fault. The usage pattern is::
+like a CPU page fault.
+
+The caller must not hold ``mmap_read_lock`` before the call.
+``hmm_range_fault_unlocked_timeout()`` takes the mmap read lock internally and
+allows ``handle_mm_fault()`` to drop it during fault handling. This is required
+for VMAs whose fault handlers may release the mmap lock, for example regions
+managed by ``userfaultfd``.
+
+If the mmap lock is dropped or the range is invalidated, the function refreshes
+``range->notifier_seq`` and restarts the walk internally. ``-EINTR`` is returned
+if mmap lock acquisition is interrupted or a fatal signal is pending during
+retry handling.
+
+The timeout is specified in jiffies; passing ``0`` means retry indefinitely. The
+timeout exists to preserve caller policy for repeated mmu-notifier invalidation
+and is checked between retry attempts. HMM does not interrupt page fault
+handling when the timeout expires, but returns ``-EBUSY`` if the retry budget is
+exhausted before a stable range is obtained.
+
+The usage pattern is::
 
  int driver_populate_range(...)
  {
       struct hmm_range range;
+      unsigned long timeout;
       ...
 
+      timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
       range.notifier = &interval_sub;
       range.start = ...;
       range.end = ...;
       range.hmm_pfns = ...;
 
-      if (!mmget_not_zero(interval_sub->notifier.mm))
+      if (!mmget_not_zero(interval_sub.mm))
           return -EFAULT;
 
  again:
-      range.notifier_seq = mmu_interval_read_begin(&interval_sub);
-      mmap_read_lock(mm);
-      ret = hmm_range_fault(&range);
-      if (ret) {
-          mmap_read_unlock(mm);
-          if (ret == -EBUSY)
-                 goto again;
-          return ret;
-      }
-      mmap_read_unlock(mm);
+      ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+      if (ret)
+          goto out_put;
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
+      if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -200,13 +215,31 @@ like a CPU page fault. The usage pattern is::
        * under the update lock */
 
       release_lock(driver->update);
-      return 0;
+      ret = 0;
+
+ out_put:
+      mmput(interval_sub.mm);
+      return ret;
  }
 
 The driver->update lock is the same lock that the driver takes inside its
 invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
-update.
+update. The retry check must use the same notifier and sequence number stored
+in ``range`` by ``hmm_range_fault_unlocked_timeout()``.
+
+Holding the mmap lock across HMM faults
+=======================================
+
+Most callers should use ``hmm_range_fault_unlocked_timeout()``. If a driver
+really needs to hold the mmap lock across work outside HMM, it can use::
+
+  int hmm_range_fault(struct hmm_range *range);
+
+The mmap lock must be held by the caller and will remain held on return. This
+interface cannot support VMAs whose fault handlers need to drop the mmap lock.
+New callers should prefer ``hmm_range_fault_unlocked_timeout()`` unless they
+have a specific requirement to keep the mmap lock held across the call.
 
 Leverage default_flags and pfn_flags_mask
 =========================================
@@ -221,8 +254,8 @@ permission, it sets::
     range->default_flags = HMM_PFN_REQ_FAULT;
     range->pfn_flags_mask = 0;
 
-and calls hmm_range_fault() as described above. This will fill fault all pages
-in the range with at least read permission.
+and calls the HMM range fault helper as described above. This will fault
+all pages in the range with at least read permission.
 
 Now let's say the driver wants to do the same except for one page in the range for
 which it wants to have write permission. Now driver set::
@@ -236,9 +269,9 @@ address == range->start + (index_of_write << PAGE_SHIFT) it will fault with
 write permission i.e., if the CPU pte does not have write permission set then HMM
 will call handle_mm_fault().
 
-After hmm_range_fault completes the flag bits are set to the current state of
-the page tables, ie HMM_PFN_VALID | HMM_PFN_WRITE will be set if the page is
-writable.
+After the HMM range fault helper completes the flag bits are set to the
+current state of the page tables, ie HMM_PFN_VALID | HMM_PFN_WRITE will be
+set if the page is writable.
 
 
 Represent and manage device memory from core kernel point of view
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..6f04e3932f5b 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -123,6 +123,8 @@ struct hmm_range {
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+				     unsigned long timeout);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/mm/hmm.c b/mm/hmm.c
index bc9361a715fa..87952c1259c5 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -32,6 +32,7 @@
 
 struct hmm_vma_walk {
 	struct hmm_range	*range;
+	bool			*locked;
 	unsigned long		last;
 	unsigned long		end;
 	unsigned int		required_fault;
@@ -44,6 +45,14 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_PENDING	-EAGAIN
 
+/*
+ * Internal sentinel returned by hmm_do_fault() when handle_mm_fault()
+ * completes a page fault with the mmap lock dropped. hmm_do_fault() sets
+ * *locked = false; the outer loop consumes the sentinel and never propagates
+ * it to the caller.
+ */
+#define HMM_FAULT_UNLOCKED	-ENOLCK
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -73,9 +82,9 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
  *
  * Called by the walk callbacks when they discover that part of the range
  * needs a page fault.  The callback records what to fault and returns
- * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
- * walk_page_range() and invokes handle_mm_fault() from a context where no
- * page-table or hugetlb_vma_lock is held.
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault_locked() drops
+ * back out of walk_page_range() and invokes handle_mm_fault() from a context
+ * where no page-table or hugetlb_vma_lock is held.
  */
 static int hmm_record_fault(unsigned long addr, unsigned long end,
 			    unsigned int required_fault,
@@ -624,7 +633,7 @@ static const struct mm_walk_ops hmm_walk_ops = {
 /*
  * hmm_do_fault - fault in a range recorded by a walk callback
  *
- * Called from the outer loop in hmm_range_fault() after a callback
+ * Called from the outer loop in hmm_range_fault_locked() after a callback
  * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
  * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
  * framework have already been released by the unwind.
@@ -641,6 +650,9 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
 	vma = vma_lookup(mm, addr);
 	if (!vma)
 		return -EFAULT;
@@ -651,37 +663,34 @@ static int hmm_do_fault(struct mm_struct *mm,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
+			*hmm_vma_walk->locked = false;
+			return HMM_FAULT_UNLOCKED;
+		}
+
+		if (ret & VM_FAULT_ERROR) {
+			int err = vm_fault_to_errno(ret, 0);
+
+			if (WARN_ON(!err))
+				err = -EINVAL;
+
+			return err;
+		}
+	}
 
 	return -EBUSY;
 }
 
-/**
- * hmm_range_fault - try to fault some address in a virtual address range
- * @range:	argument structure
- *
- * Returns 0 on success or one of the following error codes:
- *
- * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
- *		(e.g., device file vma).
- * -ENOMEM:	Out of memory.
- * -EPERM:	Invalid permission (e.g., asking for write and range is read
- *		only).
- * -EBUSY:	The range has been invalidated and the caller needs to wait for
- *		the invalidation to finish.
- * -EFAULT:     A page was requested to be valid and could not be made valid
- *              ie it has no backing VMA or it is illegal to access
- *
- * This is similar to get_user_pages(), except that it can read the page tables
- * without mutating them (ie causing faults).
- */
-int hmm_range_fault(struct hmm_range *range)
+static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +713,14 @@ int hmm_range_fault(struct hmm_range *range)
 		 * returns -EBUSY so the loop re-walks and picks up the
 		 * now-present entries.
 		 */
-		if (ret == HMM_FAULT_PENDING)
+		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
+			if (ret == HMM_FAULT_UNLOCKED) {
+				if (fatal_signal_pending(current))
+					return -EINTR;
+				return -EBUSY;
+			}
+		}
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
@@ -715,8 +730,97 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
+
+/**
+ * hmm_range_fault - try to fault some address in a virtual address range
+ * @range:	argument structure
+ *
+ * Returns 0 on success or one of the following error codes:
+ *
+ * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
+ *		(e.g., device file vma).
+ * -ENOMEM:	Out of memory.
+ * -EPERM:	Invalid permission (e.g., asking for write and range is read
+ *		only).
+ * -EBUSY:	The range has been invalidated and the caller needs to wait for
+ *		the invalidation to finish.
+ * -EFAULT:     A page was requested to be valid and could not be made valid
+ *              ie it has no backing VMA or it is illegal to access
+ *
+ * This is similar to get_user_pages(), except that it can read the page tables
+ * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * New users should prefer hmm_range_fault_unlocked_timeout() unless they
+ * specifically need to keep the mmap lock held across the call. This helper
+ * cannot support VMAs whose fault handlers need to drop the mmap lock.
+ */
+int hmm_range_fault(struct hmm_range *range)
+{
+	return hmm_range_fault_locked(range, NULL);
+}
 EXPORT_SYMBOL(hmm_range_fault);
 
+/**
+ * hmm_range_fault_unlocked_timeout - fault in a range with a retry timeout
+ * @range:	argument structure
+ * @timeout:	timeout in jiffies for internal -EBUSY retries, or 0 to retry
+ *		indefinitely
+ *
+ * The caller must not hold the mmap lock. The function takes the mmap read
+ * lock internally and allows handle_mm_fault() to drop it during faults. If
+ * the mmap lock is dropped or the range is invalidated, the function refreshes
+ * range->notifier_seq and restarts the walk internally.
+ *
+ * Passing 0 for @timeout retries indefinitely. A non-zero @timeout is a caller
+ * policy limit for repeated mmu-notifier invalidation retries. HMM does not
+ * interrupt page fault handling when the timeout expires, but returns -EBUSY
+ * if the retry budget is exhausted before a stable range is obtained.
+ *
+ * Returns 0 on success or one of the error codes documented for
+ * hmm_range_fault(). -EINTR is returned if mmap_lock acquisition is
+ * interrupted or a fatal signal is pending during retry handling.
+ */
+int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
+				     unsigned long timeout)
+{
+	struct mm_struct *mm = range->notifier->mm;
+	unsigned long deadline = 0;
+	bool locked = false;
+	int ret;
+
+	do {
+		/*
+		 * If the previous fault dropped mmap_lock, then the fault
+		 * handler made progress. Restart the retry timeout in that
+		 * case, but keep the existing deadline for ordinary -EBUSY
+		 * retries.
+		 */
+		if (timeout && !locked)
+			deadline = jiffies + timeout;
+
+		range->notifier_seq =
+			mmu_interval_read_begin(range->notifier);
+
+		ret = mmap_read_lock_killable(mm);
+		if (ret)
+			return ret;
+
+		if (timeout && time_after(jiffies, deadline)) {
+			mmap_read_unlock(mm);
+			return -EBUSY;
+		}
+
+		locked = true;
+		ret = hmm_range_fault_locked(range, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+	} while (ret == -EBUSY);
+
+	return ret;
+}
+EXPORT_SYMBOL(hmm_range_fault_unlocked_timeout);
+
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure
  * @dev: device to allocate structure for

-- 
2.43.0


