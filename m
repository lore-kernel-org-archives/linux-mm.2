Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3780C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972B16B00E9; Tue, 30 Jun 2026 11:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9230E6B00EC; Tue, 30 Jun 2026 11:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811A56B00EE; Tue, 30 Jun 2026 11:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7756B00E9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3C321681ED
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:40 +0000 (UTC)
X-FDA: 84936943560.29.632795A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1A5F1A000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KvdC8rCC;
	spf=pass (imf19.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832898;
	b=y4ap6UTOu19cuxx9xse22qGZvCBkwiWNE1bDSea1p+F28zNbz9DWoBGSgGFyhkdkjCwEAZ
	sHMQ6r6sSd4Ds6X+X+afjRBqmDQOVl6DV7ZAsH2MAImU1S2cyfyIjcQJnHr7JFq0y3Ofcj
	rLxfNv9rouau08DknVT/QikEQtbDrH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
	b=ekOYPUEBEIJDlbTQ1AoNhkkk24MGQN8C/xF28XnmIwRWR0BuyCpI4PZghMJvMLJZZ0ecLY
	EDifzP9tQ5Oip83zmsZ22dKeYoNiIUBAjUXyzsYPs6fxfGeBV1as+4RkspTVZ19X3g1rjW
	8UKSnD4/mBqdqpJ+ry/zCnVtfXtR9JE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KvdC8rCC;
	spf=pass (imf19.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c82da9504cso14025415ad.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782832898; x=1783437698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
        b=KvdC8rCCKUCf1c0Q0QZGvyQt65VEtJtaTKdED8F6mm/tR2ywD672x0grCOS6WFzsVn
         qJQYdYfxI0CCMDJwQ5zyKUMsBGOOwx7XNq8lfksw4DCtywzj+H+Ob+3+v4UEeN1zTKqN
         31X80zzPKu6OYhw542us4rByyyoMzlzWoyiNCuiEiUvSyOtjznReytARKKrgQw5Z26dJ
         3nnm7AqddON4byabM0UUdrrKwdQzL9nCV7iEaPBDoL6dYTs10PxLyagbZIxLybGIMKpM
         lAjANLrOZ4EvCGpJKa525XS77u0LfZUba9Sri38gNbT06WHnrktWUj5nfRL/6JjjRA7h
         YdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782832898; x=1783437698;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=urGGI+UABys1blw899nvFkhAmcNFFQESIMIpWL4Nq+s=;
        b=OCVS2KZTtM7bK/EfZ0FfsLGDGxywD9LovC6N5MTjeu4vr/cySD/eBPYjbh+zQCRyaL
         RczVHMeJxZwoM0p8QX2MqcpPxSU1er9dyzGQEumy4kl123dFEQCNAtP5sIAbUoBiGexO
         ErVss+YIi5myxCd51gKYzNX4l17a5imykVhu63ddgFXb+elqweGF8nXcZqiWCiZFtogP
         IIuMqdYnVPh86Q0zp6abMJJ+3R+WGmk/35SCPWrRqZO78Hd0EMA3FI5bvJ4/hqj75OPY
         VRvdZZPdWavmoE6RUeSUlBgtbWWtWpQQoHsV2LjMVWIlaD6JHWBZde0iWElHdV2h4AMS
         0iIw==
X-Forwarded-Encrypted: i=1; AHgh+RrOIVWNY28cy4im6ikmDZ/V/SCipl/3IJzrBDjrJhOZOkzH5Y3iAUEBm5GegsIQ7HdFFjqwrv4Jhg==@kvack.org
X-Gm-Message-State: AOJu0Yzk+cPdhnD3tts4rUhVc7y9Wjvx/0fmnIL++6mSPRfFVPc54dLF
	8MaBdg3yRRy+kRoBIVBKK+gtOONOtD5xgExV6m7s6I7cb/MOD027Bfpf
X-Gm-Gg: AfdE7clm/81Dj74MSkuTIbfl/FctnB1cnyeY2iXgJI+e2h6qM5u7ohzViyWqHqGc75T
	HSjJ74DFNNMKdplLKNFHTtzky3cHxWOb9/YJknXbfBOPkhCW8OJJ5RJeOLtTpswswfeJs2tflsz
	TGO/GXVQwBhWwEoFqw3GtOhCCH+1ct0GpXk/walN6O5VcUvabLGQeTn9XFwEbzVXiLSG4nRh/GZ
	SzB2HqJ4bMIn3UtU5HMQp6RRvH1ysRDVZoUoCW/gTBMY3DRrlQh39IJmIyFj4MM7N/nN1DFujYx
	O72DSZqBx3w+2ZYWuXZsPD8tYdhCxalyr7mF3R5RvYp8ysOtZR+GZDAxAVXIwr8nXQml+OC+Yla
	WQKSRSqyWg3ittiEvLRoHXM4slPP+WQZxBjW91bYZVWNcNiMQTENx0DTPsKtPHHyxqfCEs/xLXt
	yVtX/VpNy7UefoggYW3/53lj3LcSi6K5RKBDztF3h0o2Y9l6fjnBe7D9AAOes=
X-Received: by 2002:a17:903:41d1:b0:2c9:9927:a060 with SMTP id d9443c01a7336-2ca2ed3191emr33053075ad.24.1782832897702;
        Tue, 30 Jun 2026 08:21:37 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca382abe74sm17189685ad.60.2026.06.30.08.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:21:37 -0700 (PDT)
Subject: [PATCH v4 2/3] mm/hmm: add hmm_range_fault_unlockable() for mmap
 lock-drop support
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Tue, 30 Jun 2026 08:21:36 -0700
Message-ID: <178283289607.183052.18369876552581006066.stgit@skinsburskii>
In-Reply-To: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
References: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hw1rt3bgxhc8s8z4wtr6nkhx9zwcsuqf
X-Rspam-User: 
X-Rspamd-Queue-Id: D1A5F1A000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782832898-150867
X-HE-Meta: U2FsdGVkX1+Jk1dI0SiqSI3S1ovd64eDjOUxLHmhFLV5CKrGPoSoP2bxfcTPdOtxivzdGtoIlxHc1MB+6DPuPxfMFMO1Wbw4JxYOZH6WGchQ9TPolqKa8EcDUGswDLD6k/jy3Q2YqiGogvcUYEvItVy0C5ZF5bi2pIhbIm+yP3otqL8hsGL2wmpwp6X+SdEZlLvzJyrGX+CDsjpEqudLOMjK+70gkVElVy0RBxEvEBgziiTv3J4VaANhb6IJ1JwIrAEM/F5xx3uRyz6gEdhRF81twW+lMNCQKcIFulnCC3Zm0K5yUsV921JVbgYMAl2NLmIx4NMDpuF3Asdgu64t+2GR/hm3lIzpPsTOz+RFqWCRk2JHLtKqXehs4uiECspBuZgwpQZ+1B2ZzkM/2uqACcOzztw7xsifnsDxOUSov3R+wk8ij9e7acUSyilIjsvQGI6YurrS6C1j6nemGby8Y7UUhi3j/5Iv3vzG1KrJmmaaPyEQ/XHk5KVHPpqkC8kNoebuJlCWZh0uVveQQcWtbAN1N8gytR5hsay6FzROEvm0bDLj6mNBMF5obHGydJmQWGWwIOE8tVKacTAMYvtateJsWDV65OyDCyRnhLZgeYDSDblRazQ+gEePJuLktN5CdJ+nhYG3dZ2I/tvTko12WzfOXb5bNBDY4PLpm1DLmzIYssWxpf4eQpIchnwmZjEisaFP6lWnr0zMxGvnsKClm1Sz/qmfbvCyGzZ7kUKkjYeRXGZGkXSR0HwaelQLZcz7wacJNKb8xY+aPVgpPTk21cIOEss/xhje2+qJSTWRFgKGNb65cdbPc2DV7kfquDqeXdnW6/ccRFzoGtkh24kSTj7RCfV1qsUv0SU8btFo+jQE2KYljTuj1OspvNZLqNsz06feYsXtJ3fpwHdkcf0pIVjgClvZKYdamNZkNuj3TEzOuB5MU70PFsRKfmMW0gEQnKglEpe3GvGYbeBlT4T
 Ma/wxSVE
 l110MsEFEG7YCqFfYmQsCAJ+Q9PE50nrzVbQaDVWBl24aQ3xbJAZBCIy9szDS8VuwBFlwlqOIW7uuW+TLN//gTALhOEZ1F/0AfTxzSqOGwEF9jAdElAnLzfZKHAlGmFuwUhgXisW/a3k8b7HD5fU63sX2NJPp56xWTOZOExBaOBUQxG7NNJubgLE1eNiRUle71KoLVM3cgfmt0dSvhDQJd9tzXuur3617X1And1C2NUFkz/5b8P68nBVx4kaSEXNiMYyaiWePLhtVka2atDUvl5t/34q7jj/4sBmIHXQQUmHDMhxO9ZwQwre1PrktGl35J04WMM2gJD+OrMoaBev1opKdXQCa/2aKtInKKvo6VW6rcJwOTl3myF8KARYrM0O0gEkH5JVmyayrTu2eYFpjJORLI3P8ai1v0BfyBI9wGDwKZdfRLjskiKLEeSPf7SQQsOjHJPEe/MRTIab3Z4NQWrySlKwR3zaPsxqLrO1ac7D6UwZMqA8o+MiqVNjofT3RbTznSGOJz98xyDiTUkwDEtunnzP1TgeWhhEfYQx9dxCpZ7lzzynICE8bmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

hmm_range_fault() holds the mmap read lock for the duration of the call.
This is incompatible with mappings whose fault handler may release the mmap
lock - notably userfaultfd-managed regions, where handle_mm_fault() returns
VM_FAULT_RETRY or VM_FAULT_COMPLETED after dropping the lock. Drivers that
need to populate device page tables for such mappings have no way to do so
today.

Add hmm_range_fault_unlockable(), modelled on the int *locked pattern from
get_user_pages_remote() in mm/gup.c.  Callers set *locked = 1 and pass
&locked; the function may set *locked = 0 to report that handle_mm_fault()
dropped the mmap lock during a page fault, in which case the caller must
reacquire it and restart the walk with a fresh mmu_interval_read_begin()
sequence.

The implementation is local to hmm_do_fault() and the outer loop in
hmm_range_fault_unlockable(). hmm_do_fault() conditionally sets
FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE when locked is non-NULL and
translates VM_FAULT_RETRY / VM_FAULT_COMPLETED into *locked = 0 plus a
private return code consumed by the outer loop, which in turn returns 0 (or
-EINTR on fatal signal) to the caller.

The previous refactor that moved page fault handling out of the page-table
walk callbacks is what makes this change small. Faults now run after
walk_page_range() has unwound, with only the mmap lock held, so dropping it
does not interact with the walker's pte spinlock or hugetlb_vma_lock.
Hugetlb regions therefore participate in the unlockable path uniformly with
PTE- and PMD-level mappings; no special case is required.

hmm_range_fault() becomes a thin wrapper, preserving exact behaviour for
all existing callers. No EXPORT_SYMBOL behaviour change for
hmm_range_fault.

Documentation/mm/hmm.rst is updated with a description of the new API and
the recommended caller pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 Documentation/mm/hmm.rst |   62 +++++++++++++++++++++++++++++++++++++
 include/linux/hmm.h      |    1 +
 mm/hmm.c                 |   77 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 135 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 7d61b7a8b65b..a9309023ec23 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -208,6 +208,68 @@ invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
 update.
 
+Dropping the mmap lock during page faults
+=========================================
+
+Some VMAs have fault handlers that need to release the mmap lock while
+servicing a fault (for example, regions managed by ``userfaultfd``).
+``hmm_range_fault()`` cannot be used on such mappings because it must hold the
+mmap lock for the duration of the call. Drivers that need to support them
+should call::
+
+  int hmm_range_fault_unlockable(struct hmm_range *range, int *locked);
+
+The caller sets ``*locked = 1`` and holds ``mmap_read_lock`` before the call.
+If the mmap lock is dropped inside ``handle_mm_fault()``, the function sets
+``*locked = 0`` and returns ``0``; the caller is responsible for reacquiring
+the lock and restarting the walk from ``range->start`` with a fresh notifier
+sequence. When ``locked`` is ``NULL`` the function keeps the lock held for the
+duration of the call, identical to ``hmm_range_fault()``.
+
+A typical caller looks like this::
+
+ int driver_populate_range_unlockable(...)
+ {
+      struct hmm_range range;
+      int locked;
+      ...
+
+      range.notifier = &interval_sub;
+      range.start = ...;
+      range.end = ...;
+      range.hmm_pfns = ...;
+
+      if (!mmget_not_zero(interval_sub.mm))
+          return -EFAULT;
+
+ again:
+      range.notifier_seq = mmu_interval_read_begin(&interval_sub);
+      locked = 1;
+      mmap_read_lock(mm);
+      ret = hmm_range_fault_unlockable(&range, &locked);
+      if (locked)
+          mmap_read_unlock(mm);
+      if (ret) {
+          if (ret == -EBUSY)
+              goto again;
+          return ret;
+      }
+      if (!locked)
+          goto again;
+
+      take_lock(driver->update);
+      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
+          release_lock(driver->update);
+          goto again;
+      }
+
+      /* Use pfns array content to update device page table,
+       * under the update lock */
+
+      release_lock(driver->update);
+      return 0;
+ }
+
 Leverage default_flags and pfn_flags_mask
 =========================================
 
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..46e581865c48 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -123,6 +123,7 @@ struct hmm_range {
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/mm/hmm.c b/mm/hmm.c
index 446dd0c39b3a..b9ced5003e16 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -32,6 +32,7 @@
 
 struct hmm_vma_walk {
 	struct hmm_range	*range;
+	int			*locked;
 	unsigned long		last;
 	unsigned long		end;
 	unsigned int		required_fault;
@@ -44,6 +45,13 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_PENDING	-EAGAIN
 
+/*
+ * Internal sentinel returned by hmm_do_fault() when handle_mm_fault() drops
+ * the mmap lock during a page fault. hmm_do_fault() sets *locked = 0; the
+ * outer loop consumes the sentinel and never propagates it to the caller.
+ */
+#define HMM_FAULT_UNLOCKED	-ENOLCK
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -639,6 +647,7 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned long end = hmm_vma_walk->end;
 	unsigned int required_fault = hmm_vma_walk->required_fault;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	int *locked = hmm_vma_walk->locked;
 	struct vm_area_struct *vma;
 
 	vma = vma_lookup(mm, addr);
@@ -651,10 +660,20 @@ static int hmm_do_fault(struct mm_struct *mm,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
+	if (locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		vm_fault_t ret;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
+			*locked = 0;
+			return HMM_FAULT_UNLOCKED;
+		}
+		if (ret & VM_FAULT_ERROR)
 			return -EFAULT;
+	}
 
 	return -EBUSY;
 }
@@ -677,11 +696,53 @@ static int hmm_do_fault(struct mm_struct *mm,
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
+ *
+ * The mmap lock must be held by the caller and will remain held on return.
+ * For a variant that allows the mmap lock to be dropped during faults (e.g.,
+ * for userfaultfd support), see hmm_range_fault_unlockable().
  */
 int hmm_range_fault(struct hmm_range *range)
+{
+	return hmm_range_fault_unlockable(range, NULL);
+}
+EXPORT_SYMBOL(hmm_range_fault);
+
+/**
+ * hmm_range_fault_unlockable - fault in a range, possibly dropping the mmap lock
+ * @range:     argument structure
+ * @locked:    pointer to caller's lock state, or %NULL
+ *
+ * Behaves like hmm_range_fault(), but allows handle_mm_fault() to drop the
+ * mmap read lock during a fault.  This makes the function usable on mappings
+ * whose fault path may release the lock (for example, userfaultfd-managed
+ * regions).
+ *
+ * If @locked is %NULL the mmap lock is never released and the function
+ * behaves exactly like hmm_range_fault().
+ *
+ * If @locked is non-%NULL the caller must hold mmap_read_lock and set
+ * *@locked = 1 before the call.  On return:
+ *
+ *   *@locked == 1: the mmap lock is still held.  The return value has the
+ *                  same meaning as hmm_range_fault() (0 on success, or one
+ *                  of the error codes documented there).
+ *
+ *   *@locked == 0: the mmap lock was dropped during a page fault.  No PFNs
+ *                  collected so far are guaranteed to be valid because the
+ *                  address space may have changed under us.  The return
+ *                  value is either 0 (caller must reacquire the lock and
+ *                  restart with a fresh mmu_interval_read_begin()) or
+ *                  -EINTR (a fatal signal is pending; abort).
+ *
+ * The caller is responsible for reacquiring mmap_read_lock and restarting
+ * the operation from range->start.  See Documentation/mm/hmm.rst for the
+ * full usage pattern.
+ */
+int hmm_range_fault_unlockable(struct hmm_range *range, int *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
+		.locked = locked,
 		.last = range->start,
 	};
 	struct mm_struct *mm = range->notifier->mm;
@@ -704,8 +765,14 @@ int hmm_range_fault(struct hmm_range *range)
 		 * returns -EBUSY so the loop re-walks and picks up the
 		 * now-present entries.
 		 */
-		if (ret == HMM_FAULT_PENDING)
+		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
+			if (ret == HMM_FAULT_UNLOCKED) {
+				if (fatal_signal_pending(current))
+					return -EINTR;
+				return 0;     /* caller must restart */
+			}
+		}
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored
@@ -715,7 +782,7 @@ int hmm_range_fault(struct hmm_range *range)
 	} while (ret == -EBUSY);
 	return ret;
 }
-EXPORT_SYMBOL(hmm_range_fault);
+EXPORT_SYMBOL(hmm_range_fault_unlockable);
 
 /**
  * hmm_dma_map_alloc - Allocate HMM map structure



