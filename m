Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C14C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFFF6B00B6; Wed, 15 Jul 2026 14:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7A86B00B8; Wed, 15 Jul 2026 14:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD936B00B9; Wed, 15 Jul 2026 14:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 581936B00B8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81D491C01E1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:11 +0000 (UTC)
X-FDA: 84991815342.19.109C827
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id A140A4000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fgqpovom;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1eUoVHSnHskW+MbFeQBIOVKlHe2gqu47BByG1/mCCQ=;
	b=N+F7o+5U2+JXNV+B9G8ZfHAJR+nW00GlkXBIjgVNvriQhWWSp89OBFa3ZHAQP9GqB9wbCu
	T1qBCNh/xVEi9KAp5C/v68NxWzSOdpBE6+Bms0PhCzLNCl0f4XkR5fODIxe3rbSsksCLnm
	icTk/qMa933TeuyZcpDc+cs2jz7nCyo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fgqpovom;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139369;
	b=R8UWAEPXLrZ1uLPzqveaWXNwuc2PH/50VYpEdTUkeQm8Ej4rtEPxknr8UyM98cqMj0ATvh
	Oc599jp2a8WV2Jmoi4e35KpflQah87OmXS/mOxY4TKweu8oHt9hzY382uw7M9QTXHAeegK
	FgdA1Q2xPKuvbuMPSvMdM+Eolj1Ulv0=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso3345908a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139368; x=1784744168; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=X1eUoVHSnHskW+MbFeQBIOVKlHe2gqu47BByG1/mCCQ=;
        b=fgqpovomeBh5EUkjZwlPLvmlhP2qGOEX43euv6NAUT5w/qvvJMqvaNmfNBJm12jZim
         aaNbZuQ+OO+/c79Kzkn6PoIFxjGaqKBZ0g4QlrAl3SAU/bNa67hPM46ZyPjFppCdVcRN
         mVBeayLzSSomGQS74lQaG5RwX66m4FElRSJ74luOp/DTclz38iKOzQKxr84J25QOpc03
         HcRL1uw8VQ8TTF+TXIq2N76BHB3zmaJdGcdILkPRJQE9Mees99mMn3ZgLyHMyThtropb
         dqDeex4Y8uQeOhrOTmQUslP2fCrvstu7QEb1baQh7PLi2KuIIwVrB1bU6ch6saY8Vxv1
         o/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139368; x=1784744168;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X1eUoVHSnHskW+MbFeQBIOVKlHe2gqu47BByG1/mCCQ=;
        b=ruKc7J1slNRfHfsyNdtu3NyGZDjmDD9zbd8M6/uAawMqe1EMEFV7ZMJmH5dWVEYevj
         67bAMB61CuSKw2V9nrk5iCy0u0wTtV+Xy1cQYYRA0qYgNmvghzi2WWPiOMVpr+GzEZMa
         CJx8tXjMEELz3beieA2JsHQpGAiK85d72//e8LcLyJvDKsv0m1vD+ksg16uyiRfX/taE
         6WFZ8/8RAakHstdnX90rCXMYhVh4StE1tE0rqpWmswYxNR6ayetdp75P1pXqNH7Yl4z/
         cnsjfKpafEacv3kFOwL/hUMFaabFx3mJ4m6GyNaJarWp/fRp7w21TXmh8hjaS6+RV2Jj
         I4bQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9gkppD4nrmjSNOO5hyML/xTOjdQhgCEqt+h6A6x19PA4kfFaYgMSqyE4ceQlPe2KKHG48HiyR9g==@kvack.org
X-Gm-Message-State: AOJu0YzqQtC0H7tr4Fo+zkNWFRL/V7bepy1pq7hWFxYu4CG8OrSiejHk
	BPrxM4/jV3w65i06x04m5uiT0FAHMdePT9YitnVI5gDYSxHyCb9Rijgr
X-Gm-Gg: AfdE7cnjTcdulTK10baz1hWJAnL3AZBaRmYrNoTMnsA1lfRYFvJvXdjoANgOK75G4VT
	HNz8eaPw+JeRjLqrp+yCzXZQE0reMU9WYoM9cm13ZmgDZM9WhX2HOUIoYc7ceIRJfK6aO1Vonp4
	3FsAfl6mwPYA1WLeQAfjHsYTg35ZWf7Xb348FnVjlqsowrDe5p25qBdQQqrdzLAdbvI2Ja+B/A0
	MmiOpd1t8bnSDXrlJSAJnyQdFvBMKS876eMDC3QOcWGC79BzPnZ6NXnEHmvMOgzXjbAyJ+kANNV
	jHqX9EnYGZ3AGwzVq2xlYb3uY2/dTCO195cICLfAJDad86X9qVcwOvsVqI57dfWDh3vw8r8Pi5R
	FCbYP4Z9AieS2Ulo5JS1/wwtg9swiRZbHyaLV/i18I111faRs9ABMT/G8jZfZ2/EVi4Ww/QCRa4
	lF98DZUfyhA+qzarESQNFxXzAKMUkiZNrsG+pkKbzWiqN/pB3BJEm+aOq2Fd4=
X-Received: by 2002:a05:6a00:2e1e:b0:847:95a6:eb7b with SMTP id d2e1a72fcca58-84a67299584mr3403646b3a.33.1784139368236;
        Wed, 15 Jul 2026 11:16:08 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb25902b597sm620787a12.32.2026.07.15.11.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:07 -0700 (PDT)
Subject: [PATCH v9 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout() for
 mmap lock-drop support
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
Date: Wed, 15 Jul 2026 11:16:05 -0700
Message-ID: <178413936536.1155966.8918127042760531802.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A140A4000F
X-Stat-Signature: uoxhcm6ij85urot5wqktikobtycya3oq
X-Rspam-User: 
X-HE-Tag: 1784139369-317182
X-HE-Meta: U2FsdGVkX1/PSekyFv43yx6IbLygF9Y1oI3WTj0qqoxZ6X7bAioMbL0mnjvhPqd9atEtsngYFfVkD8gaa+CFVyhScjExSojwCH3M34j1eu8lWhgHVZvRlTDBcINZiQwf5KQyFoij8gQXUHFEM3Lpz15WssGK3QSpttB6t1yIAQeICk/I3C7SWPeaFTTpnPUgsS8crvMZUQN6TNNxbLCB/lOvY1jDXe1UYKDH1o1gnFNjaE31J2DAdSqcE2Kyu6L3g/yseH0N3SpMxzriLkexNYn6qOQdIStYe+tdq9X6xJqIPfIvg+2rGlTlz/ZoTjqXv40SI1coNkPYbGevNeG/eqx4hX/HnfiPmkXLDAibgXNRc8Ebj5Wvho9PEYB3lULpeGWLoNwLCUkaIb3g6xNqnJ73ocqpcA8zfXICcFYZV4IuPhtNeymE09DCUtBXmGgmnaRDhulSDDNGu7O+iOqH9iUlHOEZt+c+jFnB7eXVqWON8Z3YNJsBjY9Zw8SRTHlpDFipLRLxb17kzfd/ugliIjfzQo1tBZNQtsBELosXL2r9E7uUZTeESgDg0AkPzKrBD4rHZSYdCMZzkXLf9sdXn1XbmoG27n75UimgJu8EpfON2zXEYYTI9muU/iKtQMofhF2IQxPNGprkWHGhitWi0t1pN0O+BYzULXTg2fbGcabJNtJCbcMi/UjQl0/caLFXQafhidBvUVuvQFE0z63WS2eO+3V7c8tjm09kxHtXRxV05AnU+sIi6leG1bmdQo2lwxFwSbmWR334S5/V/5KLg0qVJImjpgfxnVOirT+7yYgeNzrQsyXjVNnFUTErSq2txWOkzzO5fs8yCVb9ScSY+43o2VOrUvejLHjJWcxRigHUNidOqykLxC+bwaNIqLZ4UlzqkWeKrsIEsK0anrNNRNqwdkGR86WeGCgLDokJDtaphRDoAo16tPMqNRVqlg5+wEEMdZjvWycXHWJiPHm
 RYf6Sw7L
 gT4M0IOzBnk3QeKYbcMyZzNmgq0woaWtpHlW4E1eX5uoioBQjusWCnc276vddW6jnrvqA7n659wc3zDViyr/gFiSYMmXdd1cQ84hXiQUS6q/jJBINzF/ieR23l2NnnxwhOf779dFm6xaKAvVCCl05hK2/kKYzHxNWOmSbdZ9uURhYLFfOGu5yhk/yGIzTEIWzslLyS9tR6HeqsN7mH5k9OwwnZTschBIe1hYdrINXDlxIPCuhqpLAVOxigw/AZQK3fYYDHo5C3XPk6yDoxDonI/YOhQXa1z+zzoZPMYlpBl4olCnllOn+NoQ+Pw0e14ycwJosVaYLasLjnUbfDO5Qc/XBvSCoVuMJOm7xYIpW/+PybxZzcD3im+srF6E240yF72gJBKxLc5FmU0YzcLhiZAOC+IY3rsWJ60FMut5USc2gJYk/2x0rOf2a4dKyqVeAOD66i1kScsvxA6s/aRx7CotUHVCpbSDN+6Pv0Mxv0/DUKD9/nw7Pf6qzm8nXrlBDM7eQhAa4p7boBcSUfSURDEJuM03hKIP7xBRO3b5r1xR0GiSwCKdW2RTs9Q==
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
expires.

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
 Documentation/mm/hmm.rst |   79 ++++++++++++++++------
 include/linux/hmm.h      |    2 +
 mm/hmm.c                 |  165 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 194 insertions(+), 52 deletions(-)

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
index bc9361a715fa..fc2e1cd0cb22 100644
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
@@ -715,8 +730,100 @@ int hmm_range_fault(struct hmm_range *range)
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
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		if (timeout) {
+			/*
+			 * If the previous fault dropped mmap_lock, then the fault
+			 * handler made progress. Restart the retry timeout in that
+			 * case, but keep the existing deadline for ordinary -EBUSY
+			 * retries.
+			 */
+			if (!locked)
+				deadline = jiffies + timeout;
+
+			if (time_after(jiffies, deadline))
+				return -EBUSY;
+		}
+
+		range->notifier_seq =
+			mmu_interval_read_begin(range->notifier);
+
+		ret = mmap_read_lock_killable(mm);
+		if (ret)
+			return ret;
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



