Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7097606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z31I8IqM
Received: by kanga.kvack.org (Postfix)
	id 067AA6B05C1; Tue,  3 Nov 2026 03:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017876B05C2; Tue,  3 Nov 2026 03:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49826B05C3; Tue,  3 Nov 2026 03:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5C026B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DE1F1C1C70
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:36 +0000 (UTC)
X-FDA: 85393131432.21.DACBB36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70E82A0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z31I8IqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWZCpgpSE4xczAweJE+uPCbv7xVI0QoZiK1kGNr3f8c=;
	b=k3h0m2ygDBw/WPZS3HueB2Izm3b0MbD9H+tD3T0mspgSsIQUOWATozXDwNyVuKUZ4YhQ8k
	gEAjblMbd/qrFlgbLvoQyNmVDUiQSAkRmT83fDOQ0Ufwdq+GsOeSv5aSjp0L/MjbwTrLBO
	c1HoWNOrogCuH3kWa37e1Zj//x+B9xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694514;
	b=pJaPsyFWXUhz3inqQ1AZL5wD2ATDVUBxuS0tPNSsykdg+gHKnosEXShb33ZFtey9t+9XJ1
	bLvenI4Q3YqT4rKtiK57yp1cVjRjH4L19EHh6zb520ltT1sRkoRaIOHF+e4yCx/x9iMCFx
	Llva53EGMNIuFJrCWqV2g85e8I3IluQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z31I8IqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D08409EC;
	Tue,  3 Nov 2026 08:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D095F1F000C1;
	Tue,  3 Nov 2026 08:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694513;
	bh=lWZCpgpSE4xczAweJE+uPCbv7xVI0QoZiK1kGNr3f8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z31I8IqMVbsI8+Br+RX+8tnZmcDMO745pd+5tnTuguMk45nAQd38B9mrIL5aqw+Xo
	 3abS0yWUrNrIZOiOdsSyq10uxZYLtvTL2vxM72c3AvjILs7IatM/SO1nKBdOqOKWcf
	 9uLmReebTlj9mTXY8Rv509ejntJL7zSK/nEyrPB4DmtZY/m+8AyKdIE/1bFVAfRzfl
	 jxW9fcEXUrMSAraG4QghGpQQ5Rv4Oz9QpukNmMVruOun39vetPZVysexoHGKSd6ycS
	 v02e2SLVBqLUHI2Stt4zfmf4A+icUlekHo+Ueh4xcBeemE6G8OCDMk6r2qPYWMyb/A
	 xw+cCe+jf+YfA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 03 Nov 2026 08:27:45 +0000
Subject: [PATCH 4/5] mm: add and use mmap_read_lock[_killable]_nosteal() on
 contention
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-khugepaged-latency-fix-v1-4-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
In-Reply-To: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4017; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EoPq0IDllGnii01JUoCaBZU0cOdJF95yfNLtLlINCG4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezuZp/7ta5d2DUpN9O2IXfJ7SxFSTyR76R/zjnzeHj
 j3xtU617yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEGgIZ/kqnZN2YUfNf72AR
 u8Xyt+z9pRYHDLcKOwt+ZAjojZ+Q+Izhf2Ka5aL80pXMHxoOVE8w4uyZuPEny/wcedcbBvtSHrU
 7MgIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 71ywfyquitn1ap8zf3uyza8d7o8yhz8z
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70E82A0003
X-HE-Tag: 1793694514-331680
X-HE-Meta: U2FsdGVkX1+UHITT/BZoePWYcq4nLnb+2pejgfxdikqfvX+3ah9EuLUEW8i5JkfJ/ogojjPCUzgHAgLtDld8xkcwVSTR7cONSF5E1IRIhCh4nZYz1WB0OveA2uTEJhSHEz7pt0dTCfqa0EPVoivk1tGIKeTyBSFndqM83iVMDg4AUO/f3KPrOEilcujX99xTIejwEeTq7PuO1n2W5TfImtN80oYCifhbjumqTVTuBLMLb29zdMGeMlITcru4E8VIRsyZNUHaY/YHMk05d+ENq87gh0ClhdgzoYjisoL4YJA36M7Lf876RRASkBoe5WvlbrAs84jraeo9ihVFBK5RRDG84PVLG7bBx7rvq0X/Opbgw0bPlfkhRCdRki59SJ7l2t8zSAyXMNDVtWVAzqFuODDazGsSW+bRhlihqMCR3smHBgKoM0Xh2Kg2WBlefnHsQgH+r3KEELlm7LLSI1dcw3rxxceMQO8Meu8CfsDNeL48bk9QPc36rkxIc5L/ZftYQ5nnI2Xeutmc1Zpxst3pMf61EuIaiX96VEcvV4S7adr4tCfh3heb9zMmbExihzvhLIvdXgnKc/XHZnncfAqNuewJ1xSWHdXRiGP603zteJQIYm18rFdsoRFrPOD4X/CYfkGrKRJqb2bnRqIfZhtU963ETu20ZmLf19U//o+D6u3QQo3xzR1HfuB3ft3ZLfh/xXZKJUV5F/UQBrGYqb8O7mILAV2bkVNTRXn2IJbJgg/BjIFra58YXJxIqk1ybv73A+EkZwxlyhPvGCBRO5pN7PIjVtB5iSX+aqchZWFDT/mFtMZlcc6M4wtbJKyjmccwaaRY/XKOlwou22g+Mpd0I33YEbcOx/kAGR40nWnawRkEu+faDoCKbC+qD243cLxjQcf2vO2T+8UtEF7bxLfwecf+C+fDPXZHavMfUNR8+Fh4OwqVai0OGL+LlH7AycWPqMAL5ojwacxxuz7sbVC
 Mfl8Yie/
 ZNpBe64QKQDuPLM/IcDwSDTSHsIOgX8Qoo422GrioLTgVkGc0hhU/F/CKYji1TS6qcC4ww+uHbagjj7yq+FjrvrWEb0oMAZEtv8+bg8DiQ91fmcx+ElG4KTQHPcw5u+qwaeZ31CuuZ42NhEwlpKw8EcEbrjU94l9NrNl/+KhODcWO/Z7xoEim7D3tlblOSb4gq2z6wMM/wfsXsJ6SsrBBm/+j7zgy+n7IeyX/+LS5bMAXFNdtEnWkfrbq3KolZgHoiG7HBaK+cAngafdEvB3h9gEpRnCUj0T3yb3odIKiPmUOQwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With down_read[_killable]_nosteal() available, it becomes possible to
release the mmap read lock in such a way that a queued write lock always
takes precedence.

Expose this to mm through two new wrappers - mmap_read_lock_nosteal() and
mmap_read_lock_killable_nosteal().

Make use of this in scenarios where the mmap read lock is dropped
explicitly for the purposes of relieving mmap_lock contention - the BPF
task VMA iterator, and lock_next_vma_under_mmap_lock(), which is where
/proc/$pid/smaps_rollup re-acquires the mmap lock after dropping it on
contention and falling back from per-VMA locking.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/task_iter.c    |  2 +-
 mm/mmap_lock.c            |  2 +-
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 9ccbbcbd7aca..88906ecd6ca3 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -627,6 +627,31 @@ static inline int __must_check mmap_read_lock_killable(struct mm_struct *mm)
 	return ret;
 }
 
+/**
+ * mmap_read_lock_killable_nosteal() - Acquire a killable mmap read lock, but
+ * yield to any queued write locks.
+ * @mm: The mm whose mmap read lock is required.
+ *
+ * If an mmap write lock is queued behind readers, but its handoff timeout has
+ * yet to expire, releasing then re-acquiring a read lock can steal the lock
+ * from it.
+ *
+ * mmap_read_lock_killable_nosteal() will queue in this case instead, which is
+ * useful when releasing the mmap read lock specifically to relieve lock
+ * contention.
+ *
+ * Returns: 0 on success, or an error otherwise.
+ */
+static inline int __must_check mmap_read_lock_killable_nosteal(struct mm_struct *mm)
+{
+	int ret;
+
+	__mmap_lock_trace_start_locking(mm, false);
+	ret = down_read_killable_nosteal(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, false, ret == 0);
+	return ret;
+}
+
 static inline bool __must_check mmap_read_trylock(struct mm_struct *mm)
 {
 	bool ret;
@@ -637,6 +662,25 @@ static inline bool __must_check mmap_read_trylock(struct mm_struct *mm)
 	return ret;
 }
 
+/**
+ * mmap_read_lock_nosteal() - Acquire the mmap read lock, but yield to
+ * any queued write locks.
+ * @mm: The mm whose mmap read lock is required.
+ *
+ * If an mmap write lock is queued behind readers, but its handoff timeout has
+ * yet to expire, releasing then re-acquiring a read lock can steal the lock
+ * from it.
+ *
+ * mmap_read_lock_nosteal() will queue in this case instead, which is useful when
+ * releasing the mmap read lock specifically to relieve lock contention.
+ */
+static inline void mmap_read_lock_nosteal(struct mm_struct *mm)
+{
+	__mmap_lock_trace_start_locking(mm, false);
+	down_read_nosteal(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, false, true);
+}
+
 static inline void mmap_read_unlock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_released(mm, false);
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 2ee7b3b3c10b..b455306a6b52 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -486,7 +486,7 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 			info->prev_vm_end = curr_vma->vm_end;
 			op = task_vma_iter_find_vma;
 			mmap_read_unlock(curr_mm);
-			if (mmap_read_lock_killable(curr_mm)) {
+			if (mmap_read_lock_killable_nosteal(curr_mm)) {
 				mmput(curr_mm);
 				goto finish;
 			}
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 834bbf86e004..41b11b843211 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -412,7 +412,7 @@ static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm
 	struct vm_area_struct *vma;
 	int ret;
 
-	ret = mmap_read_lock_killable(mm);
+	ret = mmap_read_lock_killable_nosteal(mm);
 	if (ret)
 		return ERR_PTR(ret);
 

-- 
2.56.0


