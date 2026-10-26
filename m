Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D09606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iytSdu3W
Received: by kanga.kvack.org (Postfix)
	id C12B76B05B7; Mon, 26 Oct 2026 19:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2F86B05B8; Mon, 26 Oct 2026 19:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB18C6B05B9; Mon, 26 Oct 2026 19:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15CCF6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:18:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8FDC1608F7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:33 +0000 (UTC)
X-FDA: 85366343706.26.747CC49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08AE51C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iytSdu3W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxHPlHEX6J1Jb0GTlHUy6KXWfE7ZloX8JtCL08WPSIA=;
	b=B5vpr0vGOKrglrxC7iVDcBfF5/L3sWu1bX60XQWFCJZbohtkI+3Y1led+5Ut7tACFDgcZy
	rncSUV2Qzhu7kEMVqivPwINEwgAadz/HyFsp42gnryBwmtZdlU05ePpsuUyw9BD+VxI92c
	ma4bDq6mgd+Dw4hqp+r83/5akgXOwLU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iytSdu3W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056712;
	b=BddwX/GSkwMqIQ/gq6PXn3Y/zfMYZw2ZMI6+xHi4sYx1BQFNywmleLUePQCUJ8CS0C7YpX
	P6bhy9v0t5CQi+YNL/CGOBvUKj8Y9F0fdMN2se412ip+kTipHFVWl2fygS48UmwlVYTgRy
	8gDrZl6uOOlU9kOigm66JKgYgjjcAgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87DC4600DA;
	Mon, 26 Oct 2026 23:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A31F01825;
	Mon, 26 Oct 2026 23:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056711;
	bh=SxHPlHEX6J1Jb0GTlHUy6KXWfE7ZloX8JtCL08WPSIA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iytSdu3WRKSm0AWi2Dcs1aQDb7RNBqjiDDM0NMUZJrtMNx0GYDkBNwa8EwDjkQUW8
	 NPbYuIl9oSbAcWnHairzTpeef2xfSPI1Fjz0L0snR6L9W9kHDS4/03QjrUx+hdcUsx
	 TsGtwLu2PjpRCZOqaobcS5D1lKHM9Q3/3/2ULRbPw/u8NFjDoXW4Cfh7A3aG/WNFRL
	 OK4XPzFSPDzZj+JCrE5AsvtSgTyK76yB3xbAI/hSWXiPfGeP7fPNpdsu85wrYjMAJY
	 RI2ArgsZdB4dstUqZYknWhn64iwP2jU4+koGLpGHKT3sa36fke4yYD2aG3fJfb9A5j
	 fhpWjZm43KDVw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:22 +0100
Subject: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3444; i=david@kernel.org;
 h=from:subject:message-id; bh=NBxDvFwe3/BSRK4CxO/FpUhlaAcubfwNoo3/Au7L+uo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+cYVIv0hn0/rU9e7fQ4nX+s6dkL4zkTL727Utjr
 raB6cdpHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExEw4Lhf7xhWuB7Q+czL40a
 fzNvW6J487uYXJ1UVNKSN7uvi+0/c5CRYd0ahbcf82ZNkK0tOF/RatTn52YiyyG9q+OuI7ML8xo
 3HgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 08AE51C0004
X-Stat-Signature: n8s3ym1siwza18q75kpk7d3b4eqeakcz
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793056711-760958
X-HE-Meta: U2FsdGVkX18nfm+FxIput46+sOFkv0hSmT10t5RC1i8PRyaAuvctDlkml72IyfEkKwA8rd/OND0rW/ho0vFKV5SRiAgJvfDN1Dng4cjUJ6AqzADsWDPsFLZrfqG27Yz9Cn5V3aubztS67m+401wC49L+ftn6EiIP9leeVOwyebs1p1HfY2tMIpQZ20ECH4L/PjGfDtHZy6bs4Zzn+VbMNkz0+rb9Y7rWeDfYlD8PijI3QbwmPBdzW3+AJKI4MRfpCfdiIEoL1E5yV6XRdEuZ5QbbT7nrz5PQpl1iThvQVXq0l2wvWcTCETJaye99SFKBOxWVqcw+RJKj75JgLYdPGM+E0AsqqVTraxRMupRZhM5zvzes6sTgyXXxRWt7l4xv7xyH/6yVXvny/WFYPWyfUPqZ8nrTDBRreu/s187cP+bV6NlXpQ8Em2NSb7f2Vhjz3NVSVHA0PI0mUt+jpd+THJ/+DpOD/7dGXdn+MTiRz1g4pXRu5u5mNEAJLpQqNiUKVr2s/8oMbe2Ka1DovaWX3LV62Lrz3LpwovqJgUnzdgx0+cRVQG5P8Z+eXQ9e/iU2WMoe+pPXEi2fbd743WQUOEwEskA4KLfHAbd0Gt+/MxK58mOjg8Z0p806XXTABWHMrIP6bJKxsRmhukWhe6+3h4WCykqJv4ZVGDIBIwrRlggG7UOMgzuc9agnl3FCretwL6NfGcq08nneZ6NLoXYo4Qs5eWqr2ctohIQsXqUvjlOPa9oNHNzxrl+c03O5za85COFcWHDHp2Tx9POEBpHUks8kR6L76EXs8sH1WfQ74uBSuNs5cW54ypbYxtMFVTPydbqWA+F0EhVh5yqwtjfKo0fhZV8rvNqGg0cCnXhC6VjE1/SHEcE/bJXknccXS0Hvt9PgS23/iEUOD93pNzQlXclVUkM4JqqTjd3Y4MCVBWVgwgCx3dX8L0Qv99zMEymS9Nfpj3lZXvUg+xZgRzB
 lo4Pw+8f
 O/MRxow4Gj6MKGXDfZx1kpOTQTJwCwlbhvFUbr3A3r5ThZuDtF7ChkYuhSafn8dIKj0haJo2QvIGH2arAtlj/YG6KdZGlU9jmuoBl4lg7lB5twQ+zZ2CC+Lb+d0SSacFjThjzDfqkYsQmpF3g6EeioaurHnoqfyQ+Wl0fox0FF98P8XModfpj4dhV2Lq5rCYKBF2F7cSCFgqBJWgod5mjPflynbELhxzGO6ulBaCx+ymqWJLdsyF+l9YGQP/xiHHb25fkNz4cV/8xbznNGsKbC8G9h3hzjyYiiV1WnlOb57hHJE+TJOnxjo9j40uYshArG0p+/yee4IZr3qatd3LybC+F13JNnAOBhJ4Og0/Uh0qAXe62XGqOWX0SEnWXkuvk+bsR4ffFaHzwLpq4XtwoXomaGE1rmyRbws1JN0LwYrtcot0=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/fork.c | 20 ++++++++++++++------
 mm/mmap.c     |  8 +-------
 mm/nommu.c    |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 22eaf5fb844d0..c8948cadccf71 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1532,12 +1532,19 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
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
@@ -1556,9 +1563,10 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
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
index 148ba01c03739..7618e72766a52 100644
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
index ed44510e37707..6e0f9c7da2364 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1926,7 +1926,7 @@ subsys_initcall(init_admin_reserve);
 
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	mmap_write_lock(oldmm);
+	mmap_assert_write_locked(oldmm);
 	dup_mm_exe_file(mm, oldmm);
 	mmap_write_unlock(oldmm);
 	return 0;

-- 
2.43.0


