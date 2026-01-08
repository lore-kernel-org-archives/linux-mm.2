Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58B2D185F8
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2901E6B0095; Thu,  8 Jan 2026 08:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AE96B0096; Thu,  8 Jan 2026 08:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A426B0098; Thu,  8 Jan 2026 08:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 061606B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:37:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7D3C1A8A45
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:11 +0000 (UTC)
X-FDA: 84308897862.21.8B74D4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FD30A0003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CknTidsu;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767879430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=r7hx2LSVaiRTIijxY93kRLaC5hLJG3kptctZAOE2Gt0=;
	b=y4YSl8ExKbqwKsc1PU/uYYuq58OzVk8V8Z+kp6NEuLX8WREFbGCHlXS76cg5ptXxvzx3m5
	NRVDIc24BBJbtr86tR0XYxKRzjaz/llaFWforXf/dIgiGK6hQV4k7cQQxvM2rPBvn7As0M
	0yZVF0EGeIsGIYTxqxYjiqn5az1BOkQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CknTidsu;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767879430; a=rsa-sha256;
	cv=none;
	b=oEu0kWsMeyery0UFX5mjSGwfDh6fR0sVFAt2SLUYyaHLCHkhMerbsXEe7MeYV8CFSqunqq
	cvkn6XG2OQi5Qlqe2iJ7fIQpPLdntah7plmpwJt6Z1FJePnGxcrtAVdAB5jQ5mY3D9a1ed
	4LgVISbj89WzhSYYhieHYWPrfV7Odv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C188443E4;
	Thu,  8 Jan 2026 13:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ADBC19423;
	Thu,  8 Jan 2026 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767879429;
	bh=XA7kFe2HOETvrPUaA3hJiZ5csAt9ej1ebhIicsP5rBM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=CknTidsuS6Lhz0URy2a0IvHYwzHlE7HVZnwqg1S5aqEBH0Ez4WweaTBhKC/BdpQQf
	 D6DyNLzoTXqQnfajBtabbKr9eML9poQZkCXldwC38Q7kR8mgH8Zs7vozM8QSkFPlDc
	 O/LQj0+1TWy+T3lxnjUKq/BAZ7gXHR4d6Spxn+H0=
Subject: Patch "x86/mm/pat: clear VM_PAT if copy_p4d_range failed" has been added to the 6.1-stable tree
To: ajay.kaher@broadcom.com,akpm@linux-foundation.org,alexey.makhalov@broadcom.com,bp@alien8.de,dave.hansen@linux.intel.com,gregkh@linuxfoundation.org,hpa@zytor.com,linux-mm@kvack.org,luto@kernel.org,mawupeng1@huawei.com,mingo@redhat.com,oficerovas@altlinux.org,peterz@infradead.org,syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com,tapas.kundu@broadcom.com,tglx@linutronix.de,vamsi-krishna.brahmajosyula@broadcom.com,yin.ding@broadcom.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Jan 2026 14:36:39 +0100
In-Reply-To: <20251224102432.923410-2-ajay.kaher@broadcom.com>
Message-ID: <2026010839-revisable-pasty-a219@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FD30A0003
X-Stat-Signature: 5717t5etw37nzsf5eaffxttdh57c897j
X-Rspam-User: 
X-HE-Tag: 1767879430-42340
X-HE-Meta: U2FsdGVkX19i4Lk0ex020iq46lm9t92GkfiCu7EaUtJxuLpxreWyX2kvo+kLwkANTGlOqBvHAKw/TVDthG4IxHMf5ytZkjhkGnVtTc1i7Ycek4lghT9WpXinZK4WfYriIALbAI3EU5L1UZ3kt2OzC21NaF2YYOLuVvrtSk3wnw12scHNn1tlyWQy9IL9SnOnMuw3OxRrFZ5hvyvYnZqtDqpCL+MYM1DxDMXswTR9za6rOB4yQ3TgixYuzLPFoQHO4ONhQQLj6FXoIuxh4rIGGC9CDMYFHITKMZS/UOhoLznye4ajan3O4qBZJvTutdUO0XhwmEKjOEoEx1oN9h9ciwG2tmrTJz2AFAzPjYtnvcHsOfY/akK889II4PAgO/qADfY9dF8kuT6gX8qGVKCabHUeZdNL7UrCZskU+XdF9bkTCoXCE/CGxhGl0nkyAqlKI+yDaa8NOFxkpdThxAgYPxhh69uksIShagRoGhVSZCNK3XELWvqqfAloq6hcESrATF1qieDt1C7n9g0SqKx+YEWSwUDZynAlbDUIQCu16/Ytij5kC/Wesy9zsbNXpAxwx+fNABNUyH3QDifb7uql3ujt29w+QKBcG2/6buNaLv+6hROBKDiigDjcKlwV1s23J3OyVX+3ZGKf6cT2wiFibWV0LL4X3/5A2ESaZ7247F6RKM2KwfXS9n+pHC208KfvVihvRr0UTRcjzctv2JPIr4SL+KdwC1i+2gac4Ie0AGn96LE6Q8mQ4ZFj0sGkpXI1TtjYEaVSWPWeO5mDVAVzGPv93wppBuCGNAsGE0hI9XQy8BaMf7qq7ZEY936H3KIwKL1/u6MhguL0SsrlCjP/QDooKEDSAoi09botn2IJNgZxEeEfJPRojWsczSY04kWziOG34QvMQAzsFH70p0BN7iM3ZtkQ7jVVGbO5gViwBtbtG8k0ZduEhqoTVXdCBFGhJOxusVxixbH/cXgh9y2
 Gqx2YdUi
 C6L1+SfuIqj6HZfKck8Jl6GHujy/uihzNicGbwL8CBzBFTfiuT605w35yuMv6wxQ6WVOx0qT7s+MuLyR1et8VWB7RsbGfPpDRmroZONcOEHDY8ntJqfA+MTmAO4G3UxXxoEW5KjUskdjgprZs0IwdSyFCpkiMgjapBpb6Pb4DHtg2nCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    x86/mm/pat: clear VM_PAT if copy_p4d_range failed

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-203368-greg=kroah.com@vger.kernel.org Wed Dec 24 11:43:39 2025
From: Ajay Kaher <ajay.kaher@broadcom.com>
Date: Wed, 24 Dec 2025 10:24:31 +0000
Subject: x86/mm/pat: clear VM_PAT if copy_p4d_range failed
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, vamsi-krishna.brahmajosyula@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Ma Wupeng <mawupeng1@huawei.com>, syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com, Alexander Ofitserov <oficerovas@altlinux.org>
Message-ID: <20251224102432.923410-2-ajay.kaher@broadcom.com>

From: Ma Wupeng <mawupeng1@huawei.com>

[ Upstream commit d155df53f31068c3340733d586eb9b3ddfd70fc5 ]

Syzbot reports a warning in untrack_pfn().  Digging into the root we found
that this is due to memory allocation failure in pmd_alloc_one.  And this
failure is produced due to failslab.

In copy_page_range(), memory alloaction for pmd failed.  During the error
handling process in copy_page_range(), mmput() is called to remove all
vmas.  While untrack_pfn this empty pfn, warning happens.

Here's a simplified flow:

dup_mm
  dup_mmap
    copy_page_range
      copy_p4d_range
        copy_pud_range
          copy_pmd_range
            pmd_alloc
              __pmd_alloc
                pmd_alloc_one
                  page = alloc_pages(gfp, 0);
                    if (!page)
                      return NULL;
    mmput
        exit_mmap
          unmap_vmas
            unmap_single_vma
              untrack_pfn
                follow_phys
                  WARN_ON_ONCE(1);

Since this vma is not generate successfully, we can clear flag VM_PAT.  In
this case, untrack_pfn() will not be called while cleaning this vma.

Function untrack_pfn_moved() has also been renamed to fit the new logic.

Link: https://lkml.kernel.org/r/20230217025615.1595558-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reported-by: <syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
Cc: stable@vger.kernel.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |   12 ++++++++----
 include/linux/pgtable.h   |    7 ++++---
 mm/memory.c               |    1 +
 mm/mremap.c               |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -1137,11 +1137,15 @@ void untrack_pfn(struct vm_area_struct *
 }
 
 /*
- * untrack_pfn_moved is called, while mremapping a pfnmap for a new region,
- * with the old vma after its pfnmap page table has been removed.  The new
- * vma has a new pfnmap to the same pfn & cache type with VM_PAT set.
+ * untrack_pfn_clear is called if the following situation fits:
+ *
+ * 1) while mremapping a pfnmap for a new region,  with the old vma after
+ * its pfnmap page table has been removed.  The new vma has a new pfnmap
+ * to the same pfn & cache type with VM_PAT set.
+ * 2) while duplicating vm area, the new vma fails to copy the pgtable from
+ * old vma.
  */
-void untrack_pfn_moved(struct vm_area_struct *vma)
+void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 	vma->vm_flags &= ~VM_PAT;
 }
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1214,9 +1214,10 @@ static inline void untrack_pfn(struct vm
 }
 
 /*
- * untrack_pfn_moved is called while mremapping a pfnmap for a new region.
+ * untrack_pfn_clear is called while mremapping a pfnmap for a new region
+ * or fails to copy pgtable during duplicate vm area.
  */
-static inline void untrack_pfn_moved(struct vm_area_struct *vma)
+static inline void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 }
 #else
@@ -1228,7 +1229,7 @@ extern void track_pfn_insert(struct vm_a
 extern int track_pfn_copy(struct vm_area_struct *vma);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
-extern void untrack_pfn_moved(struct vm_area_struct *vma);
+extern void untrack_pfn_clear(struct vm_area_struct *vma);
 #endif
 
 #ifdef CONFIG_MMU
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1335,6 +1335,7 @@ copy_page_range(struct vm_area_struct *d
 			continue;
 		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
 					    addr, next))) {
+			untrack_pfn_clear(dst_vma);
 			ret = -ENOMEM;
 			break;
 		}
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -682,7 +682,7 @@ static unsigned long move_vma(struct vm_
 
 	/* Tell pfnmap has moved from this vma */
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_moved(vma);
+		untrack_pfn_clear(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */


Patches currently in stable-queue which might be from ajay.kaher@broadcom.com are

queue-6.1/usb-xhci-move-link-chain-bit-quirk-checks-into-one-helper-function.patch
queue-6.1/x86-mm-pat-fix-vm_pat-handling-when-fork-fails-in-copy_page_range.patch
queue-6.1/sched-fair-proportional-newidle-balance.patch
queue-6.1/sched-fair-small-cleanup-to-update_newidle_cost.patch
queue-6.1/rdma-core-fix-kasan-slab-use-after-free-read-in-ib_register_device-problem.patch
queue-6.1/x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch
queue-6.1/drm-vmwgfx-fix-a-null-ptr-access-in-the-cursor-snooper.patch
queue-6.1/sched-fair-small-cleanup-to-sched_balance_newidle.patch
queue-6.1/usb-xhci-apply-the-link-chain-quirk-on-nec-isoc-endpoints.patch

