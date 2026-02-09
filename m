Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9106E94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5436B0096; Mon,  9 Feb 2026 17:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0962D6B0098; Mon,  9 Feb 2026 17:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD146B0099; Mon,  9 Feb 2026 17:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5FCF6B0096
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:08:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 938381A0300
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:08:56 +0000 (UTC)
X-FDA: 84426309072.01.9CF7E5E
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id B912480005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:08:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3lcFIHmy;
	spf=pass (imf02.hostedemail.com: domain of 39VqKaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=39VqKaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770674934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JnRS/eBggwfyKbmgq76fGd1D8MW17NObeJngFpCnif0=;
	b=UKc9qsIu9LYFxdntsLtCmbFAabeRH37keQp48ZE+zPpPHt9MecsHQm17qsl4M5/PxVkt9V
	YzKjcgWxJX59ub+1HmzFuSKTNjJWG9rS4fDJA4F9l7JH4s8TYW6QN0rBHbMAMq/VCUtVU9
	xUe4YBPssLR0J5oBNuz/lDHN78N2Vmk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3lcFIHmy;
	spf=pass (imf02.hostedemail.com: domain of 39VqKaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=39VqKaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770674934; a=rsa-sha256;
	cv=none;
	b=TAsQejlou5h3q2N/jlQX3YluUscP/tr/VZHVIZjzVpU59rnh2302Gfzyuqj9RnX6RI+O07
	Fdt8ROhSey9zs/F7ZjoYZqdCwFiEFdBSFQW9JkQHOTrWt4K421Igk2kqLIW6VLAL+O9yp7
	Ir/wYbjG1xMS8rU/P3Zqr+NZWfVWPXQ=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba8a461dd9so244769eec.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 14:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770674933; x=1771279733; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JnRS/eBggwfyKbmgq76fGd1D8MW17NObeJngFpCnif0=;
        b=3lcFIHmy6dv+EwDbXWUMELLk/l3bQmkYPU9W04VkeI4w4kTy8UwytERlTCx3Lv4+KU
         6TQ3d+T5c4sOCdzOJjbkVtj+kebg4u3q7A0t79QeIAXlKmRliT8iHEpKI9OK/GivLPUW
         1xXlukSpuXiNbfG0LZDaQpzXD/EFzIGdtJd2U+qBfp7BDw35dsXX0dijGxQmIKDi08lp
         FBOKWkXoLSVEvGqerpF+jilZyLy3eNU02vS/O4USwZcQWh/ej0VmkmDPUKIGuH7CfIce
         BB4QHBOImeGQoV9ZWNpYKuhC3wNbPFhcUNKMKCUWZSUTkOhkGz0TvQbe0R0//1xNnxCx
         mvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770674933; x=1771279733;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnRS/eBggwfyKbmgq76fGd1D8MW17NObeJngFpCnif0=;
        b=tMn6zyFBeCsx22L3VacUeGQ65PHJgOdx31f2wJlzBt75KtPN9/+LS6IxIjqyvhy0r6
         LgfSyMrF76EItYgEqPvov65+KTPHk4EpDxCL2U+AY0edbHisdFR4/sQlKUC/oNpM6fd3
         d1jZKoi+l3HX25g/5znOKNK4sRhgBcPPtTvopAnM71+Xzw2cGpdVwI3ls3e16Gm/RZw9
         B4CoAIGIUzJkzcUmtT+UqzUM4uSaRWD86JQSyLSUVtizHo7harbsNe9aX3RKDJU0Y/GG
         pjQkf4smiaDcMtQBDILFZRxIUYkmd+edfmAKH6Ya+AZH+2RlysE4MhgjlDE4qFJj9uEq
         XxRg==
X-Forwarded-Encrypted: i=1; AJvYcCU0I2xRcNJCtD21JJrm3dPu/0kvkEFi5n9gFY04SWEHBOiawZjSxGkPhr2VPDNQYG0wAmwppzJHmQ==@kvack.org
X-Gm-Message-State: AOJu0YwR0/SFFfFqU1REmxWyvO3YmV7eGBTvH575+WNwddasK9tI4yXy
	jjij0wXkqFutHWrj1jCf8LuDEgyDtNqQHYDoqTkhTRtSYp720kEAwpV0S8U33K9Uv4JTVyC7Q7A
	MJBAC4g==
X-Received: from dlbrb16.prod.google.com ([2002:a05:7022:f010:b0:123:3409:1518])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:1687:b0:2ba:7717:2bdd
 with SMTP id 5a478bee46e88-2ba771732a0mr1454182eec.27.1770674933227; Mon, 09
 Feb 2026 14:08:53 -0800 (PST)
Date: Mon,  9 Feb 2026 14:08:49 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209220849.2126486-1-surenb@google.com>
Subject: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 9ddinomqkfnfcebwhh6awriy748wsahy
X-Rspamd-Queue-Id: B912480005
X-Rspam-User: 
X-HE-Tag: 1770674934-62178
X-HE-Meta: U2FsdGVkX1/x6RL492s6nayGLKncGW+odtZyXfzeNzJUpIlNE1Ft3Py51ErarcxtgBtICH5PbBHQ8tD3rXzApT+AsjRdXLjLGV2akySC8wh3IdaJc1m9iKtL8X16JM1Y2tjH8gtogkXJzP2UkLiBj+807vj2gY8HCWEv9E+FyseZxKX4BrGyknfhmKiRZv0c7phwlQTXApzyzUrA3HS0hfmJAk8vhOdQ24Bn+qIrTjB3JGNepO5uOCEV1Vrk5n+u6fVftCFQNZFzQDgZvO0HW36afoOG1iBY0tB+nnNHJ+kD3AW/gVqerbikK7CGEo3GZTJp0eR6DXkYCKCBTEX2cI/HQNuf52D6ZaxbKbitAkm1OEwu/zcPsNaftAXUyjrLypZvTZRcpgzf4R3LXLdvsTW+Mf/P86U4U3Y40K5s0r14EQRDPZ+SDv7BqD0hqMKcdPHcrQax95DRl99f9kCimRWfUbgb5Z3Hx/h+5lEs09nKHAcP3vKrqyRetNfdON3Hr6YScLsXXFfvsQa46xY+nx92domdccT8XaoV6ooIaPt7YUyE0a7/6JLwmaWG5rCqKhU0eIPCs60/OA9dm1WwThN27Auk3pzlskhmatzEoYf/XgYKwolhOWqvK7dqnoe0aw6HIEs7jMQawPG/Oe/LlMjpNmF9KN2MnibQkmpS8kHaW+RlFgBpiyJ8T8MA1n3Q8zhERqgcws3mlk1k2X0Oi84HTonEONtFjyCVmu7OsYsZw4CaBjxdgfRPdXXRAHvndHw7BmPDMkg97573Y3mHEKGxn0PmztLCwqkXiS5Y+6c4yHmmd15ZkaAvA8dC5WHV0D1LGiYzJaaQf0cgjCDCmX9ynqLYa+FEMG4zCJj0B/AmXboB6FFIZ92dZcl0pMr72m6ZkUYWMAHbaDYVjbuPmgAZamojDqD428RKFjreKsBsGxlt8gExtTotbKUdCA5kd2HoxgFeHHc9R9gkWLF
 Imangsru
 wyM0FjWJRveV8qGe1keLOzB/9ebsrt9C5DSULbCZlZXFb7SKdm096ivEaQ3vUylzTte5wJAxh/DeckG2rZK0qWxO2bzGcCWmqR2S0RpQRXVmbNCYWtOnDl5xMqTbNujbDXWWZeYE+7bUrgQEXJLYvk3oLouIp0mCKb5iC/ahRHt0r38CVf9e9Sbb+W8eXCr5p7LFXyDwwV+wQtv2Qnh98svY5/ao4bf+yon7+7BASfAP1kVf4WzRmzGTH0qY+p7LDURTeh1pb5V5HPxiazAYn8MXXOSyv005ZpzNmDJYst4ewx3yNzsjgjPHlZEK1AXm0tFWYOSZvE/ba7i5f8NI/1W0NGXEzXubwnmF4UbSZYUDS/uPhVqONUuYuw1zzdb2JRCaguORCviEeVS5OtnDuTpTudEPeJfX004tJKqa2+cat8pF+wKJ9RUoSn3hoF3ilLRHXnVX6yZaLbJMUSyxmwn9OQhFKYJtf3oKGxlvXgmEmHZUiGdi5hhGYuiBPTYqfU/lKPpX+THtrxIdsW24XshDNO+owFOqrSzxXVo2xasD6qU5O7cFo/QLxNCu/qRg6gbK8N39MYTtDE3S3OB5YrzyDNTMVbu4MivOkKfj9UROEESIalFH4U/C4uPn2lbb4RZb7OvnNb2qfqB7k9lr4Cvxb12+U1XOSOFSJ0img7GGF2PTpG2JoDsRcYbYHV7Lo8olKrD2Xdkv8vj6tg0LNIl66MdmPdPoWiTHE+V/iVsmgCy/A/4ye9xxPWN6665o/7KpQmh/6IqR5s0PHcT2+J4aTPr+qKAPI1RPragQiw/y8trQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patch:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
 include/linux/mempolicy.h          |  5 +-
 mm/khugepaged.c                    |  5 +-
 mm/madvise.c                       |  4 +-
 mm/memory.c                        |  2 +
 mm/mempolicy.c                     | 23 ++++++--
 mm/mlock.c                         | 20 +++++--
 mm/mprotect.c                      |  4 +-
 mm/mremap.c                        |  4 +-
 mm/pagewalk.c                      | 20 +++++--
 mm/vma.c                           | 94 +++++++++++++++++++++---------
 mm/vma_exec.c                      |  6 +-
 12 files changed, 139 insertions(+), 53 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 7cf9310de0ec..69750edcf8d5 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0fe96f3ab3ef..762930edde5a 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,7 +137,7 @@ bool vma_policy_mof(struct vm_area_struct *vma);
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new);
-extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
+extern int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
 extern int huge_node(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
@@ -251,8 +251,9 @@ static inline void mpol_rebind_task(struct task_struct *tsk,
 {
 }
 
-static inline void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+static inline int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
+	return 0;
 }
 
 static inline int huge_node(struct vm_area_struct *vma,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..392dde66fa86 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1150,7 +1150,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
diff --git a/mm/madvise.c b/mm/madvise.c
index 8debb2d434aa..b41e64231c31 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -173,7 +173,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset(vma, new_flags);
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
diff --git a/mm/memory.c b/mm/memory.c
index d6d273eb2189..3831e3026615 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -379,6 +379,8 @@ void free_pgd_range(struct mmu_gather *tlb,
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * Note: we don't use vma_start_write_killable() because page tables should be
+ * freed even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index dbd48502ac24..3de7ab4f4cee 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -556,17 +556,25 @@ void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
  *
  * Call holding a reference to mm.  Takes mm->mmap_lock during call.
  */
-void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+int mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
 	struct vm_area_struct *vma;
 	VMA_ITERATOR(vmi, mm, 0);
+	int ret = 0;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 
-	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = -EINTR;
+			break;
+		}
 		mpol_rebind_policy(vma->vm_policy, new);
 	}
 	mmap_write_unlock(mm);
+
+	return ret;
 }
 
 static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
@@ -1785,7 +1793,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
@@ -1808,7 +1817,11 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 			break;
 		}
 
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			err = -EINTR;
+			break;
+		}
+
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..2885b858aa0f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -420,7 +420,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end, vm_flags_t newflags)
 {
 	static const struct mm_walk_ops mlock_walk_ops = {
@@ -441,7 +441,9 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
@@ -452,6 +454,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		newflags &= ~VM_IO;
 		vm_flags_reset_once(vma, newflags);
 	}
+	return 0;
 }
 
 /*
@@ -501,10 +504,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out;
 		vm_flags_reset(vma, newflags);
 	} else {
-		mlock_vma_pages_range(vma, start, end, newflags);
+		ret = mlock_vma_pages_range(vma, start, end, newflags);
 	}
 out:
 	*prev = vma;
@@ -733,9 +738,12 @@ static int apply_mlockall_flags(int flags)
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		/* Ignore errors except EINTR, but prev needs fixing up. */
+		if (error) {
+			if (error == -EINTR)
+				break;
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..49dbb7156936 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -765,7 +765,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error < 0)
+		goto fail;
 	vm_flags_reset_once(vma, newflags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..aef1e5f373c7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1286,7 +1286,9 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 		return -ENOMEM;
 
 	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
 
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..dc9f7a7709c6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
 		mmap_assert_write_locked(mm);
 }
 
-static inline void process_vma_walk_lock(struct vm_area_struct *vma,
+static inline int process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
 #ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
-		vma_start_write(vma);
-		break;
+		return vma_start_write_killable(vma);
 	case PGWALK_WRLOCK_VERIFY:
 		vma_assert_write_locked(vma);
 		break;
@@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 		break;
 	}
 #endif
+	return 0;
 }
 
 /*
@@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 			if (ops->pte_hole)
 				err = ops->pte_hole(start, next, -1, &walk);
 		} else { /* inside vma */
-			process_vma_walk_lock(vma, ops->walk_lock);
+			err = process_vma_walk_lock(vma, ops->walk_lock);
+			if (err)
+				break;
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
 			vma = find_vma(mm, vma->vm_end);
@@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (start >= end || !walk.mm)
 		return -EINVAL;
@@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(start, end, &walk);
 }
 
@@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
@@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..3cfb81b3b7cf 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -540,8 +540,12 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
-	vma_start_write(new);
+	err = vma_start_write_killable(vma);
+	if (err)
+		goto out_fput;
+	err = vma_start_write_killable(new);
+	if (err)
+		goto out_fput;
 
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
@@ -574,6 +578,9 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	return 0;
 
+out_fput:
+	if (new->vm_file)
+		fput(new->vm_file);
 out_free_mpol:
 	mpol_put(vma_policy(new));
 out_free_vmi:
@@ -895,16 +902,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	}
 
 	/* No matter what happens, we will be adjusting middle. */
-	vma_start_write(middle);
+	err = vma_start_write_killable(middle);
+	if (err)
+		goto abort;
 
 	if (merge_right) {
-		vma_start_write(next);
+		err = vma_start_write_killable(next);
+		if (err)
+			goto abort;
 		vmg->target = next;
 		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
-		vma_start_write(prev);
+		err = vma_start_write_killable(prev);
+		if (err)
+			goto abort;
 		vmg->target = prev;
 		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
@@ -1155,10 +1168,12 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
 	vm_flags_t sticky_flags;
-	int ret = 0;
+	int ret;
 
 	mmap_assert_write_locked(vmg->mm);
-	vma_start_write(target);
+	ret = vma_start_write_killable(target);
+	if (ret)
+		return ret;
 
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
@@ -1186,17 +1201,19 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
+	if (remove_next) {
+		ret = vma_start_write_killable(next);
+		if (ret)
+			return ret;
 		ret = dup_anon_vma(target, next, &anon_dup);
+	}
 	if (!ret && vmg->copied_from)
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
 	if (ret)
 		return ret;
 
-	if (remove_next) {
-		vma_start_write(next);
+	if (remove_next)
 		vmg->__remove_next = true;
-	}
 	if (commit_merge(vmg))
 		goto nomem;
 
@@ -1229,6 +1246,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
@@ -1240,7 +1258,11 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(vmi);
+		return err;
+	}
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
@@ -1430,7 +1452,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			if (error)
 				goto end_split_failed;
 		}
-		vma_start_write(next);
+		error = vma_start_write_killable(next);
+		if (error)
+			goto munmap_gather_failed;
 		mas_set(mas_detach, vms->vma_count++);
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -1824,12 +1848,17 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
+	int err;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_start_write(vma);
+	err = vma_start_write_killable(vma);
+	if (err) {
+		vma_iter_free(&vmi);
+		return err;
+	}
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
 	mm->map_count++;
@@ -2211,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (vma_start_write_killable(vma))
 			goto out_unlock;
-		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
@@ -2549,7 +2577,9 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 #endif
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free_iter_vma;
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma, map->hold_file_rmap_lock);
@@ -2860,6 +2890,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
+	int err = -ENOMEM;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2904,7 +2935,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		err = -EINTR;
+		goto mas_store_fail;
+	}
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
@@ -2924,7 +2958,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -3085,7 +3119,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSUP))
@@ -3122,12 +3156,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3156,6 +3192,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
@@ -3170,7 +3207,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	int error = 0;
+	int error;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSDOWN))
@@ -3201,12 +3238,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto free;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3236,6 +3275,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
+free:
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 8134e1afca68..a4addc2a8480 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -40,6 +40,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -55,8 +56,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * cover the whole range: [new_start, old_end)
 	 */
 	vmg.target = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
+	err = vma_expand(&vmg);
+	if (err)
+		return err;
 
 	/*
 	 * move the page tables downwards, on failure we rely on

base-commit: a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5
-- 
2.53.0.rc2.204.g2597b5adb4-goog


