Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EAB606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=am3XTgpV
Received: by kanga.kvack.org (Postfix)
	id DD7016B05B5; Thu, 29 Oct 2026 16:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87DA6B05B6; Thu, 29 Oct 2026 16:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EF06B05B7; Thu, 29 Oct 2026 16:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 947266B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:34:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E37421403FE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:01 +0000 (UTC)
X-FDA: 85376815482.20.43EDFF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F1F391C000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:33:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=am3XTgpV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDnFHMjA66BoQB8Vxjf4dtq2kXA91I+j2LTsXqWaqtA=;
	b=1ie1jTt6S6ZRif3XK77uAZotE0GztOIOCs8xWpGw18xRhYUb/q5mAIPi03mY5QyHwfUGU2
	nLkkuw1P8gsWsQA+6KfUcqm96NSn2xMRKB/DaZbljB3EC6hUfI0+OO9G5iRfQmboM4Kp19
	dJ4447QEGi9+xR5kEnLxPc41w0UC8jQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=am3XTgpV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306040;
	b=uRbggJ0CW6w8lkM3Ssws3p3sY7FmdAdcSMS4vgWztFCitrg/N0cIMYmD4tFPZ7WADEfxRa
	7/TJgsTMHEKK5QMbiMkSo/nmX7dYTrVwgVKK0Yjki2Gie0zwaKyEQTPvElBLMhtZXUyH8j
	axc20kfkZSUJo1yV7uc+YBin8FjhFPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF7C40F53;
	Thu, 29 Oct 2026 20:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4651F01824;
	Thu, 29 Oct 2026 20:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306039;
	bh=bDnFHMjA66BoQB8Vxjf4dtq2kXA91I+j2LTsXqWaqtA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=am3XTgpVgHU7w4T2qNJKEWMRK6et1DuqCwcBz+lFGVUX9YclSBZSowWGPpIIV7+IM
	 tEP5omw5Vzsc76le081/xL21kHFi0mU57Zo/UxYgrjd9vjFBziVfQWssZ6DxVCwwwd
	 a5vGIMoc9rL00pdWDUba4bp8F+ajymkeQeip9JVHBkhVDQrqaZ0q/WtsV7R6RPztmZ
	 o3Lqrrj2Hy4L/T8SbZDJ8rfKUMyvKC0VMztk5TIhdV5tescrZ1yrfhQDpQdMB9rocm
	 /bxf+2RUoBuGOuMzXVjiDrWORAfn+A5CwB/wYWROwZHGu9vWzhfxTvQyxEW3T2w1yW
	 4Yac9xTxgMYlg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:32:57 +0100
Subject: [PATCH v2 02/47] fork: take mmap_lock before copying mm_struct
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-2-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3737; i=david@kernel.org;
 h=from:subject:message-id; bh=xdagUeG+am6KY+4B7movMSkDtyS1Wqo3jrGYGcvuKUc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer225Nkv/lfLjom53y+5P53z+3H8sojjThvvT+idNq
 jkbHhaLdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRr2cZfrM53Vy4zepghm7H
 g3RhgbUcrCeYBC7JSO3ie1J8widy9xZGhjmZn/qvLHE9ceaA4JXr89f/6bqY9Ma2s2ZalHXVw1B
 tTi4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: F1F391C000A
X-Stat-Signature: dtntjxbc9bpmx3jrqrbdhrdbpbzqek8b
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306039-189656
X-HE-Meta: U2FsdGVkX1+vka8cONuAwP3ZDJo+J5gWwlyUxCup+o+83lYymNo/ZKM2s+x9j9JXUyCHk/k+l0ItwTgGsbKQCGSDRfjVqKtZ2qyRlDsjvgScv503py2Qa1gJ5V5sgb1cesm3wmdLlVQs4dd3GeMmHwB4sj4IiJNw78UWGUAKXNBIbcF1ooLhXy95eXoHJc4gDpGLOgTIU7AN9KJsIkSJ4vBzXszc6Vg2T9kkbRGRzdgDA3wTdqsbfjWDyxF2D36jPJSZBiXHYZzXF0AVC+RRkMgBOC8sNXPjCZKbMAReVQuU7uzlV+0Cn1C3DUlZB2QGi2Count2ZzCmcP7HP2na5wTYq7x9WRulR4dqZGU9SY3zFApCkcFzR9qFfiKFuuGg1cJgNjhZ+rvoMJYf+ked2g5qWqP4XSQ6YjBDFmMPoGLuwiQHpOBHDEHs4TUOHluzOg913WYRGU1TlAp8RkiTMLoZEfvIaGDyJkfcSnuipZcrbYT0j1BKy4XKIDK+eORkM7FLSuH1dMpcWI6YeK8GEn/bH27TDi4ofvvlKAtOwWQb6IwUnv44oSlEk8/Px8mAAykApqF+4lfyd10NxfN9dh9JkvmTw8sPcQXMFUPczCKWzqxCF19tyJHfUOn72C/TmH1U2JMyfFBuaqlVGNTLAmOS0hRu+DYr7yBak3GuBa/xP3yt5EVfX+vDJrSdE2R3APXz/1vdqX8ZciZ3x8rlBgLun5bRGXtAm5/6wQmkCHvZyEGHiBvbcndcaAJHc0NxMiyx3NJ/F7g/xiARMKI/eGn+Q60SY7NnvIcM/g+FIdU3jxiOCejvst4qnTi7DauyKnSN9JjufBLJ3/BpVmVFrgRGjIzW3uBjoa4ZPPmCd0hlivp4Jz/J3TajiUJ8MPj42fMd1OUM1Y9eFXJR/1IpDutoWHPvhpKsy0poDGcdXPfqdVk3/q8Ngiv+tsrMqKNdCSJw+kXx/Hrvj+3bql1
 YVK1NvI1
 IJn6OQTt8fQcIW99odUN7xc51IqI0bZg5yW7l1QSRnzpWmWNz8bTNdWPvHtjoP/I9r1Y3r9zyTTJtkza2hYWcT2EvjKZZDPTfKmKstZEXZrtDqwc7rfXYOO/cd/c0ARTzq2ArcUwvwUUxUhzkZ6810npRp1gYAH9nv3xJvswwBVgp9Dr/kagCCsOd3oWokTLZyMPriJLGDwDo+dW96K3IYJQpxktHcy8PQuRbMHQtbAftnbDKpHIQ9e9shkMf4I2IaAekPtA+rB+Hn7+fpob/lMco5jWzprBeeL5TR31G91wmgXxEn1AxZBohhDyXLCGJYnsUu+RFZ5BAsnFduJNs2mienqaGg+d833F4H0GDp2dMNYsPRNFPnjxG2rzyHZacsbZ0r0iCDgDhs4+VBsQP1BBLOrl2Vum+ft3GE7J5qGzl1wur6EFF5MhopDx2SwD0wOBUOnur39dM7vW7UDS+6G+IlhggI1GOYnsAYq+RiqU5zDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dup_mm() copies the parent's mm_struct before dup_mmap() takes the
mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
and newer heap mappings, causing later brk() requests to fail.

Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
cause inconsistencies.

As a simple and robust fix, grab the parent's mmap_lock earlier. This
way we don't need to update individual mm fields in dup_mmap() and
keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
exec_vm, stack_vm), as that is now no longer required.

Keep releasing the parent's mmap_lock in dup_mmap(), before
userfaultfd completion, to avoid moving the userfaultfd handling into the
caller. This should get cleaned up later.

Move uprobe_start_dup_mmap() to preserve the lock ordering.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/fork.c | 20 ++++++++++++++------
 mm/mmap.c     |  8 +-------
 mm/nommu.c    |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 18b6dd851642..ee40142dab31 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1533,12 +1533,19 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	if (!mm)
 		goto fail_nomem;
 
+	uprobe_start_dup_mmap();
+	if (mmap_write_lock_killable(oldmm)) {
+		free_mm(mm);
+		goto fail_uprobe;
+	}
+
 	memcpy(mm, oldmm, sizeof(*mm));
 
-	if (!mm_init(mm, tsk))
-		goto fail_nomem;
+	if (!mm_init(mm, tsk)) {
+		mmap_write_unlock(oldmm);
+		goto fail_uprobe;
+	}
 
-	uprobe_start_dup_mmap();
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
@@ -1557,9 +1564,10 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
 	mmput(mm);
-	if (err)
-		uprobe_end_dup_mmap();
-
+	if (!err)
+		return NULL;
+fail_uprobe:
+	uprobe_end_dup_mmap();
 fail_nomem:
 	return NULL;
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 148ba01c0373..7618e72766a5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1713,8 +1713,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	LIST_HEAD(uf);
 	VMA_ITERATOR(vmi, mm, 0);
 
-	if (mmap_write_lock_killable(oldmm))
-		return -EINTR;
+	mmap_assert_write_locked(oldmm);
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -1725,11 +1724,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	/* No ordering required: file already has been exposed. */
 	dup_mm_exe_file(mm, oldmm);
 
-	mm->total_vm = oldmm->total_vm;
-	mm->data_vm = oldmm->data_vm;
-	mm->exec_vm = oldmm->exec_vm;
-	mm->stack_vm = oldmm->stack_vm;
-
 	/* Use __mt_dup() to efficiently build an identical maple tree. */
 	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
 	if (unlikely(retval))
diff --git a/mm/nommu.c b/mm/nommu.c
index 91ab65afda70..6c6f95329674 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1887,7 +1887,7 @@ subsys_initcall(init_admin_reserve);
 
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	mmap_write_lock(oldmm);
+	mmap_assert_write_locked(oldmm);
 	dup_mm_exe_file(mm, oldmm);
 	mmap_write_unlock(oldmm);
 	return 0;

-- 
2.43.0


