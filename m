Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CF6106F2F3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89AD96B0005; Thu, 26 Mar 2026 04:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B5D6B008C; Thu, 26 Mar 2026 04:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761C46B0092; Thu, 26 Mar 2026 04:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 647956B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C50FB5C2B4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:44 +0000 (UTC)
X-FDA: 84587487768.05.145DB79
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id F1B132000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A5mM2ZJa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3ienEaQYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ienEaQYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DpXsG0Sw3JfIN9g3oAH6M8VS1bS1PNOXhE36FO51Iqg=;
	b=UGwbMqmnJC5G5lzs0v6PEY+sz2TQzs86rrDIubzslKZv0Vk9PN3T7/QH8oWvRI4D2FUayx
	76kkSj+wRJr/4EBVdCqJ7zAmzOhEebKutvKJCts6pMjMGR2i4AIPQ/AQ8tGZIdzxBGhHy7
	vh+R9hds0/uyQpOw1Dxar11pN9Y1SIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512523; a=rsa-sha256;
	cv=none;
	b=wAw5i8qGwNSV/Gc+5hvjPqZhEzyOhkuCNUaQMcc941K1KdaETbgSgKG3PKROaXcYTvG+el
	MMdLUUyQpAYSM561ZTilLVzm3uaNvEl5QXbcLvPensgbCPAn+DBeADUf07GQDvItRExDyK
	a72Rp8gmEuPPKrRg6YyjYdp7cs6sTW4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A5mM2ZJa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3ienEaQYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ienEaQYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1279caef718so663651c88.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512522; x=1775117322; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DpXsG0Sw3JfIN9g3oAH6M8VS1bS1PNOXhE36FO51Iqg=;
        b=A5mM2ZJa5bAwtIKNX2YMITp7laVe2O7PQU9fpB0RAfdft5K/Yh6pGiOYoSyndT3V6P
         npy8brvDoF4LgvvupNOkRJypp8dQo1+rqIusRneWVNFj+n3jSVZezl86/rmLaq+MLy1r
         X7RpMvRRvf/1G7qnAY6+3c3ptdloRkKOGi7F5wpufmO55ncUG6kt4O9iZgN3FY/Es9QQ
         EYkfejvnSu+P7A36ovtVWxMKtQrbCm9ojlbzCjLfYRs1LutBt4C4YEYZ8Bfk/m3YCB7o
         PxQ7CFE85qgfsLj/wxJSUi5OhwjHFm8TR8shEIzzgm7v4iWuvX8zu0oce9KpzR9ft4ZP
         PDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512522; x=1775117322;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpXsG0Sw3JfIN9g3oAH6M8VS1bS1PNOXhE36FO51Iqg=;
        b=nno6O3EXMQ3uD/PXYRp4x5qYMg7bmPxOS20i1ib5rVKRRdGufJvrrkSMX4RS8gvNF/
         ozGbkfpu+LVbPRBkCb4MkQlvAtDFdCEv8H+Z7Sk5mAL1FlZH2XwSvAW1rSDJX94ElIC3
         jwweIpvGpaOvcjjz52gQeve/G7Za0cnloCeVAcY1Mzak3/ySzz9lC8ShxVrWIkqTkzbO
         farTXkt4KTwGas+aaAXP/7QK0VYMJz7uUecrmU3VT8cCS7r6Yb3sVYYscFKnW6kzUTf0
         EbvAHWWrMdBvZBSBnAnRDqKHLAa4JkqsqqDHHCDH93NqzrZinmaAdm/kUE0iyPZlTqCF
         5utA==
X-Forwarded-Encrypted: i=1; AJvYcCWr35JpyiFY7R6Nkx85RKntSABZE4QmYQSAWfL0P/mv2S09NSabqE9T+XL6/W7lph8wVy9pDLLQLQ==@kvack.org
X-Gm-Message-State: AOJu0YwmSxYCKPX0q/oUytTopPK3ZnGpFFhdfCVrmS/NiQaLw/QMt2Jf
	PDC+v0nBmoTplU+04HzwKF+s6OKnQVLEjOmL+Pn4xqm+zzr3BLJXXpj7wNbstz3pbGtBIcVbQF1
	vND5dsg==
X-Received: from dlbuy10.prod.google.com ([2002:a05:7022:1e0a:b0:12a:6d14:dfd9])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:eac3:b0:11b:b622:cad9
 with SMTP id a92af1059eb24-12a96eceb8emr2826837c88.21.1774512521385; Thu, 26
 Mar 2026 01:08:41 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-1-surenb@google.com>
Subject: [PATCH v5 0/6] Use killable vma write locking in most places
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
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F1B132000A
X-Stat-Signature: udaczapi861qmozkaa3m4perm4py844j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774512522-843928
X-HE-Meta: U2FsdGVkX19oQBWUfK8o9mVe5sXnLaGZmy4cufRX5or9nEylXlaZS1VVtNsnKka37VjLU8ScjyB5EBM3TqNcPesApx1Q4YMijli2IZXUb5EOvT220mkMQ7HiePlnj6IEX/KkG6CZCr8gkbA5Tb/sFX3Yh9Glxy5r/GJ6dOdMnnBpf4AQNwdkytNG4Jyxe7rO+SUPpOlX8Rih+qFcMZcpQmqb0z7XwZlilmuEKjCGTxEXOE+yPLMUG3lXVbSaOsHEZZq97XcZwnHgB1i6cvc55A+dX2r24w8el1uXHVpMeNamjp+NVH26LzV7mBRnyA52usmkRz18doF6mEli6aB8Ktttny5bND5gyD5DOg7h8z5kWQs/+m5Sy1VZRYBaoWGbb15JfjRlQ/5GJmh5ZGrluVq+h5lLBDt0hjYWvvpAi9JdRR7WgZx7MJqmf+Od8GfLZ9yXvraejoS2xwU53/lzyTUJT5VALI85+EUzXZ019D2iNV5ADVtUVB+tDkF4MJUiXhkpuOZGQ3tRklTWu89sLCC7ILdWYYZ6j6WVKyf3mt6cvfvYlxX95eGITwftkVhC3zYOaCI0EENFzY0sHF+Wop4tKYs0Op4IrZwZkPeB/+xk67fdmT38VBprzHO5WW91MhSqXyrnX25DaeU5HWXTb5JU5cpsZyEU2u6meRV81VHJIWA2GFDGNqOt/IdZviQQkltZclAnKnHXstgKIA+WVg2PwYCRknTIhj2F8m4pcQQ4MrYeZ26lWx4hw9C5RRWfNOCP+B5ySbI2CrgIj20tE858V4nFtvm5TesFjm/gy1pf528PWD90Gr7gkr82MTP5lvy7q5jAQ4CvYdmEaz8C/tkaJ0mR9cxPKaitA4XTV3SeT0XfJvQbePDyh8W0kt+n/i6ao5Z/ptv3OXdT2wgU/OHuIrR3D8gTybeQ2TgyGRmItiHLbsDha7Xc5DKaj36pD834iFLxr1b/5AFx4Bg
 D1j5IJQV
 9DOAwREJIoIR9l0pD/ccKk2Q6Wg1CLtIpgS+u+CwKF3cmbM8EgT2T2rLt/qu/MnMucULMy8Rk6zedMnlse78JaPMleJFNFshcdCwlY7sTOdQrh7WD4ORf9CDBF8IkTFD4mARm3k5YDXxSIgQk/KYfvmflMiMHlwHQ7ow6YexsWc3iiPnmp+ZLQ04i/opm6flrFnhcvQw8OfdQp+C/Tf6/d8GexXCFdHKxDVtWStanslnPor86ud9Lc2d2XoNOA66kTULJrlw3bQF7U5LM8UB11luTBoeqHDpZ/u6CCKxOlYKW8FpGeJ5IQdtlqNYYtrbDQbl4PFFRYvFMQ05BzrKfAheT1YLUyaNPnXkiUWJ6b1HQmUID+7af93sOfSQklIyapyCeLsI4NRMXxAMW/yzgbUQEjqdqJ2HRLrCkJ7kW/qNwo+BFnePZGWjOxjndEe8+wMM88gFjbtDYL90FfMfkwwzZha6ceeM+Xz7nGGLxTqY5w6ATBdIogkY8ADhm9c1zBSm2ivvPTG+LMvzWd+u7FohX/Uus/6zs6WqlUZgONt4hx42imYJE4ny99RNzi6+a3YuPYYL+3RpIXQ5ki/x+TOXq2zUWR/z4HOGUrIF5xzU2THZB+7dOKo8Mmw2Wp2HyanyMOi8xsmGTqa7NydV8/TejvlryjA/QfJ8EpA81xHUEKEmkucZtkMtP+WU1HFwXJ8OZSsQhowUDIU1f/ugptSH3qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. mpol_rebind_mm() which is used by cpusset controller for migrations
and operates on a remote mm. Incomplete operations here would result
in an inconsistent cgroup state.

4. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

Changes since v4 [1]:
- added Reviewed-by, per Barry Song and Lorenzo Stoakes (wherever the code
stayed the same)
- split patch 2 into 3 parts, per Lorenzo Stoakes
- converted vma_start_write() in mseal_apply(), per Sashiko
- changed vma_start_write_killable() error handling in
set_mempolicy_home_node(), per Lorenzo Stoakes
- added comment why mm->locked_vm is fine even when we exit early,
per Sashiko
- moved vma locking before vrm_calc_charge() in move_vma(), per Sashiko
and Lorenzo Stoakes
- set give_up_on_oom on error in vma_merge_existing_range() to propagate
the error, per Lorenzo Stoakes
- moved validate_mm() out of the error path in expand_upwards(),
per Lorenzo Stoakes
- dropped the patch changing S390 error handling, per Sashiko and
Lorenzo Stoakes
- reworked error handling in clear_refs_write(), per Lorenzo Stoakes
- uninlined process_vma_walk_lock() while changing its return type,
per Lorenzo Stoakes

[1] https://lore.kernel.org/all/20260322054309.898214-1-surenb@google.com/

Suren Baghdasaryan (6):
  mm/vma: cleanup error handling path in vma_expand()
  mm: use vma_start_write_killable() in mm syscalls
  mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
  mm/vma: use vma_start_write_killable() in vma operations
  mm: use vma_start_write_killable() in process_vma_walk_lock()
  KVM: PPC: use vma_start_write_killable() in
    kvmppc_memslot_page_merge()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 fs/proc/task_mmu.c                 |  12 +--
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  12 ++-
 mm/mlock.c                         |  28 ++++--
 mm/mprotect.c                      |   5 +-
 mm/mremap.c                        |   8 +-
 mm/mseal.c                         |   5 +-
 mm/pagewalk.c                      |  22 +++--
 mm/vma.c                           | 146 +++++++++++++++++++++--------
 mm/vma_exec.c                      |   6 +-
 13 files changed, 190 insertions(+), 70 deletions(-)


base-commit: e53c9040ab1b738dd2c83b57558f141902caaf4f
-- 
2.53.0.1018.g2bb0e51243-goog


