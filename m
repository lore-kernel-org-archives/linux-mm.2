Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B358CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 10:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BCA8E000F; Tue,  7 Oct 2025 06:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3F48E0005; Tue,  7 Oct 2025 06:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430D38E000F; Tue,  7 Oct 2025 06:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 339EA8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:29:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23BA85BA58
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:28:59 +0000 (UTC)
X-FDA: 83970945198.01.3068B69
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9BC071C0013
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:28:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759832937; a=rsa-sha256;
	cv=none;
	b=FT1APw8x4JENgY4Z3+Q0sVj7O8Jz1GIiWx6sKy5wRYp/kF44ZaKqV/0gqLIWOb4Ui3fxww
	W9C64stfTNbNhQz3+PLRtgvqaIjS6wHbvUgHA3+ktmwUWvhr4b1g9Lik0RQvmtMvDcTJlk
	UMYT2FOLc9LaYasuj5wjq+z2VuEIm1E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759832937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KTG4hbkLcNhKqmnGPmK/C/HVE0My/Rlyvc7dkVFURLU=;
	b=htN4/ikvHMlwJJKtdeRroDr+fKkPIcTjH3ibepYgX2bPbFqyR7xd+ncxJEy1Uhnwrz6ocS
	h4o9d19dgkee0+KFdLCB+g8Yv9FJ7Wvk7+tw5XpRBbnuVCN6YXIE8MMmsROyzJ06iG5XCE
	Jicc9kP5WzWq0emtS6lkQWVAZcwuw7c=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cgsmv6XvGz4xNt6;
	Tue, 07 Oct 2025 18:28:47 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 597ASIIs016509;
	Tue, 7 Oct 2025 18:28:18 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Oct 2025 18:28:21 +0800 (CST)
Date: Tue, 7 Oct 2025 18:28:21 +0800 (CST)
X-Zmail-TransId: 2af968e4eb45fc5-6256d
X-Mailer: Zmail v1.0
Message-ID: <20251007182821572h_SoFqYZXEP1mvWI4n9VL@zte.com.cn>
In-Reply-To: <20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn>
References: 20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@redhat.com>,
        <shr@devkernel.io>
Cc: <akpm@linux-foundation.org>, <david@redhat.com>, <tujinjiang@huawei.com>,
        <shr@devkernel.io>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <yang.yang29@zte.com.cn>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjIgMS8yXSBtbS9rc206IGZpeCBleGVjL2ZvcmsgaW5oZXJpdGFuY2Ugc3VwcG9ydCBmb3IgcHJjdGw=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 597ASIIs016509
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Oct 2025 18:28:47 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68E4EB5F.002/4cgsmv6XvGz4xNt6
X-Stat-Signature: cy7ot1mrb9jxnb1zcw9orze35o1wbfq1
X-Rspamd-Queue-Id: 9BC071C0013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759832935-624381
X-HE-Meta: U2FsdGVkX182NgONkZoEzwhzY95W3zBXK4SPUwza9Cp5rZvEzSNQRDfaoRC1fcXog5/Nt4k9cAIHXdtQ/rWt+e6oWBhs0vZE2nZ7a1scmZ4o61Wjsrg12cgZl38QB8dZZeqmArEknPmecGrV5zOzHRh5MOCKUyiCqhc+UxudDjOYHrJ6VMda6253qiSWO58LtqEr/KtZ1PVMhYdvPpaTOKW8+b9+DLWP06eQPAOwM+jrZHWArsC4rL6sqqvpL+sUj05T0rg40w44YLUThc8eV0jvN+FCJl/eNRcSfz9vCuvccZ6/pZsR6xJt8Rsb/8y+WZtZcIdJxdOekSx0Rvdo38+4nAhZGFzUA/JvTnMwzy9fimwl/1W5yHxweDvDnNF3OsF97gJK1AeIEc6GpVcLNQFgeJZK0PjsslF8Zn6LHQZdiLWZ3SMEAWDSwaclzzh6zKycUTkVW2ZswLormg10RY1WU84EzcHH8IRKD9Dy9c8IOSsjEAtOWWWJT/4mugEgbQZTwo3Y5D5TnULoYwj+01XJgJjEg7jlM6XaAffoVUV/wao4dLLp2eK8JUIMZbODbD+zV4PxQUIFoVeDyR1XdLHV0xZu/JzSH8gy8haGiY2ED91e5XwMjdX9x3Qr1U8mhSFabunlwfQiA7JfQdjRyf7BffGBGI2wWRIV690Q2r9Lcp7E75f8Sp8TaIbx0ugiNFomOqLqACjTbHDy8mZBEUshvNUyqAzh9QXq7DNkK3e61RxoFtFqIiy3Sgu7inPXhWliDBoPiKMelfkoe82AL5Fc1dhfVoF+l6rRJ1lv8ISbXrJdkNaKov4xMDpw3XlDCooe6w1YNO5Eiz5SECR9Bcp6U8cHpYtQ64XphXdlVYxojvtVucr2ZoPs+cuSIH1Qhv4kzuNMIY19gCm+nQ6a8zQB3QzpLTxY7IRc4tuMpTfs2ndHP3KZueJkxpCxtUBPExAkzavFj+OwcqN4+d2
 iPc15sAf
 f0gv+hP2gQ58wBubgYRlQxWz/ZOd0Sz8cjiYRv6kvi5B0Er+X6DPhwZ3z3Ju5mLblS0q/MdMxlQG5chjX318kNR2440O0dn2Y2PDju1FjQ0EoaLuNifCS6NpHJFfaKrjHRNCsnAM3XNJJdpRzMD12AHXnMPH2Yl3U5VEmTKbcd17vBky2EQlZhce1WqUP+TwdEzA/bNrxaNTjsz4enBIoVcWxdzJ2xvkN0KsFl2mchpr489At3manMcTn7aiRDSamgeGYObQrl2azGxwCQ4U4ht5V8IdAYEFARqB8cMNaozDPsucfqHh1FPjX7dskUrYZE94usFFZqWV6MNsHd0HkKXlBMQlT3keA3zC5ZnfJ3RZwS1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Background
==========

The commit d7597f59d1d33 ("mm: add new api to enable ksm per process") introduce
MMF_VM_MERGE_ANY for mm->flags, and allow user to set it by prctl() so that the
process's VMAs are forcely scanned by ksmd. Sequently, the commit 3c6f33b7273a
("mm/ksm: support fork/exec for prctl") support inheritsingMMF_VM_MERGE_ANY flag
when a task calls execve(). Lastly, The commit 3a9e567ca45fb
("mm/ksm: fix ksm exec support for prctl") fixed the issue that ksmd doesn't scan
the mm_struct with MMF_VM_MERGE_ANY by adding the mm_slot to ksm_mm_head
in __bprm_mm_init().

Problem
=======

In some extreme scenarios, however, this inheritance of MMF_VM_MERGE_ANY during
exec/fork can fail. For example, when the scanning frequency of ksmd is tuned
extremely high, a process carrying MMF_VM_MERGE_ANY may still fail to pass it to
the newly exec'd process. This happens because ksm_execve() is executed too early
in the do_execve flow (prematurely adding the new mm_struct to the ksm_mm_slot list).

As a result, before do_execve completes, ksmd may have already performed a scan and
found that this new mm_struct has no VM_MERGEABLE VMAs, thus clearing its
MMF_VM_MERGE_ANY flag. Consequently, when the new program executes, the flag
MMF_VM_MERGE_ANY inheritance missed.

Root reason
===========

The commit d7597f59d1d33 ("mm: add new api to enable ksm per process") clear the
flag MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs.

Solution
========

First, Don't clear MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs, because perhaps
their mm_struct has just been added to ksm_mm_slot list, and its process has not yet
officially started running or has not yet performed mmap/brk to allocate anonymous VMAS.

Second, recheck MMF_VM_MERGEABLE again if a process takes MMF_VM_MERGE_ANY, and create
a mm_slot and join it into ksm_scan_list again.

Fixes: 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process")
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: stable@vger.kernel.org
Cc: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
---
 include/linux/ksm.h |  4 ++--
 mm/ksm.c            | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 067538fc4d58..c982694c987b 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -17,7 +17,7 @@
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, vm_flags_t *vm_flags);
-vm_flags_t ksm_vma_flags(const struct mm_struct *mm, const struct file *file,
+vm_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			 vm_flags_t vm_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
 int ksm_disable_merge_any(struct mm_struct *mm);
@@ -103,7 +103,7 @@ bool ksm_process_mergeable(struct mm_struct *mm);

 #else  /* !CONFIG_KSM */

-static inline vm_flags_t ksm_vma_flags(const struct mm_struct *mm,
+static inline vm_flags_t ksm_vma_flags(struct mm_struct *mm,
 		const struct file *file, vm_flags_t vm_flags)
 {
 	return vm_flags;
diff --git a/mm/ksm.c b/mm/ksm.c
index 04019a15b25d..19efe3d41c75 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2617,8 +2617,14 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		spin_unlock(&ksm_mmlist_lock);

 		mm_slot_free(mm_slot_cache, mm_slot);
+		/*
+		 * Only clear MMF_VM_MERGEABLE. We must not clear
+		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
+		 * perhaps their mm_struct has just been added to ksm_mm_slot
+		 * list, and its process has not yet officially started running
+		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
+		 */
 		mm_flags_clear(MMF_VM_MERGEABLE, mm);
-		mm_flags_clear(MMF_VM_MERGE_ANY, mm);
 		mmap_read_unlock(mm);
 		mmdrop(mm);
 	} else {
@@ -2736,12 +2742,20 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
  *
  * Returns: @vm_flags possibly updated to mark mergeable.
  */
-vm_flags_t ksm_vma_flags(const struct mm_struct *mm, const struct file *file,
+vm_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			 vm_flags_t vm_flags)
 {
 	if (mm_flags_test(MMF_VM_MERGE_ANY, mm) &&
-	    __ksm_should_add_vma(file, vm_flags))
+	    __ksm_should_add_vma(file, vm_flags)) {
 		vm_flags |= VM_MERGEABLE;
+		/*
+		 * Generally, the flags here always include MMF_VM_MERGEABLE.
+		 * However, in rare cases, this flag may be cleared by ksmd who
+		 * scans a cycle without finding any mergeable vma.
+		 */
+		if (unlikely(!mm_flags_test(MMF_VM_MERGEABLE, mm)))
+			__ksm_enter(mm);
+	}

 	return vm_flags;
 }
-- 
2.25.1

