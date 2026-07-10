Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E48C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775076B00C5; Fri, 10 Jul 2026 17:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725176B00C6; Fri, 10 Jul 2026 17:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AFB6B00C7; Fri, 10 Jul 2026 17:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1324A6B00C5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 757718FBA4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:40 +0000 (UTC)
X-FDA: 84974151360.20.E282626
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 947B5180006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGmG4MNA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqbwRVP/sfR6Y4F4lzaqregK9IVNqigDowAHMdHoVCE=;
	b=YtH0uzZr8YCa5VhyFC57IKz5TU1t1MxgWm2ZK6jk+SyBbl8SWOl124SyAfdceh8i9LRPIM
	HVJ9BHwL2FuQ054X5x/eQd2RyozZ0E8jQC+1xSTBBJL+YwgsINd+67yyRF6hgdROzmamNv
	m9Hgp61z1a0foPlO2ozcrC78vSyJNB0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGmG4MNA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718798;
	b=cUzyfjfuCQtikSUTnS28nFZrpgN36ryHHEm+fQwaA/UNOn8SjmakNRzPzER7YUBfs543qW
	Eg//OBjh6X/e63W97Vmy43lM7pyp9/vzEfIWb8kWHxpEccj3QYKk9DIS6NBM5Em89kqQOq
	bYOMdxy9wDg1Uf+qIOLEWUiLP+ThkfQ=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca88130e09aso921599a12.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718797; x=1784323597; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZqbwRVP/sfR6Y4F4lzaqregK9IVNqigDowAHMdHoVCE=;
        b=SGmG4MNAseKPEuYh+EOA0D4QDlDwmwp+HJVVvvHP4h8awNLHchMlF1RE1ifBFEuJDi
         AM2CoOjle59yViP5xLsqsPIR/CfzfY5JiTO7nKSBs2MqblKS7v5DKKfm3UxymZBqw41c
         cOMsf3rWGvvD2vab34t4mOca+E2BxMonzivGLGSBxSIyoqJAOuo7f71J3lqd3Tm+5mFj
         v1tXfgDXPRLQb3rkBE+E7BEN/fIn4OFd/OoR1swyMPmcLmJ6d3mdrm3FAIv1srRLDioh
         H/fkHAlLxKOIByq5RLpv4LwILuqlkHy512oEgPDwZoq3BdkZhA1T4p+8BpMoYylJHsy7
         weUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718797; x=1784323597;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZqbwRVP/sfR6Y4F4lzaqregK9IVNqigDowAHMdHoVCE=;
        b=EdQqnCSWdfRZE/hJRPBz+DH0c76X+O/EWegZgyMlOk7T6utRMLadvkJg5aWlrJU41/
         t2nG9aoWHauupI+7sDofWROQW+KvaWMagFjv/wBc0VSAUdM7imYkyr+LAfAQXmcWdJDi
         hzviPdHxNYZzdaX5xBd0Agoj65JUoEoh6WYhNmY9h/YY2PA/9ZYxjvPFb2sCpNzjTSm8
         cN2BVHnkuK8MDgRj5Qj650Kygp9DkeUwYSRLOXFFvdiloIzeuVzBiXa9RAFOJ6rqWPGC
         aXBxhj39ILOEhXpDyANXjRMnDAZBCXtPV+WGEiXAT/ySnYGvf/epz/uvUydbnGvxadrP
         vv8A==
X-Forwarded-Encrypted: i=1; AHgh+Rqz+uEdPfAEyMeujQ/vSiIZztA8ag9vd/Ic0/XCQ6BTZ1Ap351J4+UAU/PkpgJqzXNT/JWrV6ybxA==@kvack.org
X-Gm-Message-State: AOJu0YxSG6Iw1JF/aIOTlE4v8vAZuaiQpPkuVEGsukSsNNoQGujWtfpy
	7SMq81UITPIwNXo1odl5KbiS3wPKntI8FduCX4b44Ic+bCMHxWUAgg22
X-Gm-Gg: AfdE7ckdDys3v5XmsquHdB0N6yw/+eF6C0rikozA3FQA0TVwLGGONJYsO4F1oDlEj1i
	GA1FlfNqK6XFzZdB30bznNmjTm1E883zXe1JDlHYZpeaMJxIw5DaIttj0nEhWgrgMqaQo4vcP2k
	K9NFjMHyqzux/K1kUTt28XMz+SF7RuS9AxaQHAk2cjdX0iizGh04pXNS4Sy4LjUUwlJd8tF5qIs
	IVXn81aEp/yKVnVj9pk3Y5YuoW7/pEC0wgNpPOVwnRVKT3iUmKA4enGW3tn/vf7KgLVm77FiKoH
	R3ghFo/Lj+9Jw/S8QTfQdz62M56iwCyPe4UGMvdfymyf9Pf0Apb0hpZucl91XAc8nUArZ6tvrXd
	rz3zO+Ix4gI26b6E/fWz1xj2+u5vBbHqOJIa+X7VN0U9zqo8Uf9QkPCdSCd0klgex7ZUIdNIIfS
	RUl3j5wto+kfYQgDnd8L2dxDIbd7B/kXGlHEHP7aRBdxiGFLNQryjEyczByMfq8TspOSsnrQ==
X-Received: by 2002:a05:6a20:1604:b0:3bb:2200:f67b with SMTP id adf61e73a8af0-3c110cdb319mr625385637.40.1783718797427;
        Fri, 10 Jul 2026 14:26:37 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5af7d58f3sm5552601a12.1.2026.07.10.14.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:26:36 -0700 (PDT)
Subject: [PATCH v8 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout() for
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:26:35 -0700
Message-ID: <178371879503.900500.7148019929226548795.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: akhqt3as6a7z5mxuf5u7cbzs8zt4doqp
X-Rspamd-Queue-Id: 947B5180006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783718798-908916
X-HE-Meta: U2FsdGVkX1/Bjwuhb1W2y3p4YsInb3lmxhtsqQVki+wE/JBo2zKemBNkE9YnHqKw9hTauJoP9B5un2TtM51HYZcmweJLbGe/LhIjkXiqrjcici2YWQBEU6Yc3cEq+KiZw8W13dy7IzyPZORLI0iQuK8SwjPuV7Dl1MXuUfqt6kDoonnBQn5RLcVLJUdeCdtuXWwbznWyGCj78fZVntn4hLZ8CketveFrOeHL399+9NqYToud1TXbUp7G2P3JYWiR7M5y4N9SHQsrnphQe3T93fpK48N3UgJ7qHlGxT5h/ICfdYH7TifEiC+MQQS8qPO732BLSe5u55pCxLMQq7vzpKRn7D3mENfAtmph7OWf0ZFMjzpLU5QYm5bTYoXFjhvNxN+UNV6XtqjCa6QGCpyZtMawBi3/ZxZEAKtkXYXvI7s+K5CCLG0URc6wsyxcZVe/xCwp1hn2sPa5IN89QlFty09EhbEFR1amFvf0YpV/JzFhY7GfgO/YVHXubF/MpKBqi6L4rKChO+CoNIF76YkCPdfI/+N46yQ+xH2AYgxK1cPDR5oUoQX3/eZ3UAP8DddrXlJeB91UDdeC8KC8OktbqeiQcuDVXdONiWDtScUNUqN5V2yY/h41hiFedjD+lT6Bb/3XPaCO1dyIjy7m4VpoLgFadxZnm/Uao/QyPRKYVmi9LAesivK089ltOaLLXbUe71DOCnjg8G2OKFrdNksG3/lD55U2Kw/uMPfdpipq0GwcOmUN+eLUiURt842p7KcimZKI++0nC1CYgZjlnxGEs6fZkDbqZ9oWt48v+EWLpavvnYyh0B7obUAHtDwwyR7ed4wUfDZHshTUZ1c13r2ClaZBrIn7bSV7Mn3BQIBlcorScJEa4nL+KwhIsxaEpzeq/l6ty44CRe0rMY9cEDut4mytYH2MUUhU25B6FaGE4MvilCRTuTtM3koOHGFSfg0TRLwi7LrxMPgp92vum4N
 1hM0EM4O
 pXBTvMRQJ1xgROK/S0hFd+wJgYdgWGZw6rY9hwCrop/K4/t36BCSL5/8q/7+5jvLn6owY0ZBmVNQpwnLXLu5aP8J5UWQFulomO/RyZomRH2l45WK3Y9k5/SlEyZkYd9VbnK5Q7FolOBkIc8uW/xrYlvz1PfANcIvDq/Y4FutRswIPYOjviai64xklpdxbW9Y0Yb4Meqb1i4rBAS2wKK8lGk23ML+MwDt2z6S6aDryJtcmZYm5geN17R9FS/6kZu2BVWXQgMMf+1AxruXkGI+6nh/TV0pDHWqbdHgE0x5gxanoXpW/41fUqMepH6XNjHLtmdeEOuz/+Kq7Hgpo5VkpzokQbjh0f4wD2wJDxFZEVc6MoL17nNyzjk5eJ75UJcKcehruN/XFhTANo7nm7y8mYs8BO4wSM71PyJnk9OEoKfNrcHu+xvl03aYxdFP0OCEOen1aWbUEp+a/AOK8zP+PworYNp91fJtlCSJr6mrEBUvhwJbHtZJtSVFEaWjej/FWjpkRfVHkW7nAFgXEQzvDOJvdgNBZqarHc1x4sDjDp5DCZJYPqVv6UGlkRg==
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
 Documentation/mm/hmm.rst |   76 +++++++++++++++------
 include/linux/hmm.h      |    2 +
 mm/hmm.c                 |  165 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 192 insertions(+), 51 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..4e5a750748ae 100644
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
+      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -200,7 +215,11 @@ like a CPU page fault. The usage pattern is::
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
@@ -208,6 +227,19 @@ invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
 update.
 
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
+
 Leverage default_flags and pfn_flags_mask
 =========================================
 
@@ -221,8 +253,8 @@ permission, it sets::
     range->default_flags = HMM_PFN_REQ_FAULT;
     range->pfn_flags_mask = 0;
 
-and calls hmm_range_fault() as described above. This will fill fault all pages
-in the range with at least read permission.
+and calls the HMM range fault helper as described above. This will fault
+all pages in the range with at least read permission.
 
 Now let's say the driver wants to do the same except for one page in the range for
 which it wants to have write permission. Now driver set::
@@ -236,9 +268,9 @@ address == range->start + (index_of_write << PAGE_SHIFT) it will fault with
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



