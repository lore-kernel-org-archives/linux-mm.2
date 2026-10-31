Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C41606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVGmBXf2
Received: by kanga.kvack.org (Postfix)
	id 91CD76B05B5; Sat, 31 Oct 2026 05:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5B56B05B7; Sat, 31 Oct 2026 05:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E42F6B05B8; Sat, 31 Oct 2026 05:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2726B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:40:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFDD81C3F71
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:40:47 +0000 (UTC)
X-FDA: 85382426934.30.7177CDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21144100008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:40:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVGmBXf2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7DjIkLabOacdFYfsEcmvwX1npwCjDikHaQkTvm2Neo=;
	b=YhVAgBLh9E8FLp4Nd6f8wkqwCS0ahgtoZSrNNHrzq1IbJAmoCL69MhyQQ/uL9RZjdCL0uo
	8rA9wM8oaX2MbT9hZNJuhtqwQY4l74hAGoE8QqR5/HFatHbgQoTXDoYb31B1gDWvAcL6mV
	/rfURqz7VcgFwUKt8m6bEylcDtxs0RE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVGmBXf2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439646;
	b=KC+Tq8y3eOvynzEwikGUbmMaruy1URHB0iewoJbn5Gk8IniMNhXt5x0kqSWT3f1wx149dm
	VuFveDoqbjbU0Gun6llm8dw8Gbcwf9oVHlcqplyg3Lo1vDl7ceRBlLDK1nohMBnya1LeGL
	kGO3lept0mAW1D/9kE+I0+KFVe7xxg8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE900600D4;
	Sat, 31 Oct 2026 09:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97431F00A02;
	Sat, 31 Oct 2026 09:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439645;
	bh=I7DjIkLabOacdFYfsEcmvwX1npwCjDikHaQkTvm2Neo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dVGmBXf2iikJF+RHAcOZfze4+LkziBHwXt9DI/UnL0jUTHBa085R2oXvkLkVuSfjZ
	 8i+fAkkvD9ZDOLT6kR8xxRhJtpqZRaZEaXumXD9UPN0M1VHQw5Nfbr2R8OYus6lIIZ
	 2IXfIU3MQePN9yX0aw2Ag9ERRVurHYrxKdRQzWge8T7uptXBgPTBOiXiqAg5FgY+gt
	 sp+jZGXNY4nkdQJggTFM1NrA3tVqh3rR7DJk0ivQMbXQb9pn9oNNXxeF3m/tCBvjL9
	 GgVFKQvpsfugBNxgOkXDBSOylwZfOnJZJIe2t/MmpmLNBcjSEDRpC1HgKaHM7dm+01
	 vlh8CF6VUE6HQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:31 +0100
Subject: [PATCH v3 02/47] fork: take mmap_lock before copying mm_struct
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-2-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 SJ Park <sj@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3836; i=david@kernel.org;
 h=from:subject:message-id; bh=OsYjjyoQURJ77TW7YgFGtQVMoukPf386zkXqzXlwm/c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk892Sx5i/lgf/GuFPXwkNTFNVZr/b7sks9m0FzSL
 cOnuWxyRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABM5ncrI8LdjxoM3X/9VfXqY
 n/6E+4WBi/C/iET+pVPqfC3KdFe972b4K7jXaYGk6gF2hjPHlvEevNbjdHOiaoj71rgGH7FVPs8
 NOAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21144100008
X-Stat-Signature: ezprjseoi6m1wkc8xx4e1mocewaa5hot
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439645-366968
X-HE-Meta: U2FsdGVkX18ude01Hetf3R/hGK6xoDwfTTasayKChwCJY2p5PJlXmXMiiFBgs4TDkWJgbawBiGRDnFpcDHJwv/q3QBgvyncUhlsOm2WUVfCdNBetyvIidIMJnx2I5GOQVbB5p7qx3tCKWITyyyIvW5+ydnpiDV1P51cTJe8VgPzDqoMSQsl8K6X1HvB59kcoZS9egXi5lJmYCllb9k5MKtOMjmqqBw28dunwnjG9Ujob5vBa9zObQXFopbbwIQa85vVCKlYjCJQUrSO0oDGgqrePi4nLmXcSUJ90fjUxOizzuMhyKY9R7876GX6bVqZhH344K6NV/pmd7aPCRKLDvuarCMWMnj6/LV6hnVRCLoT/Fa/bPD6Rdd6hyjw9PzDVtCTG5S2IHyo2M9YN5bVa7JcKFlROUPDPi5Szkbl1FsIhsUDjH2zFK3q+QEjRvQs6scj63M9Jzrpv1gdmig8zY9vVyYQyk1uBxZPErDbQNXNo26yUmbYfcMK9KUE81SuuMH8IhboXyduzr3cQ/9gY7RTVfV6DBarFNKsrb0h13ifC9vQwGbfI0gYhY7Vf7TaUsvAVTIqGfuHhpfyZfhVAPp+ngA7i5FWCR8nTIfDPumi0uAJeFSn13YY/LqHLcoWKVSNmDJe0JnKoCsYNhlnB3IAzCa9dhk/dgfWCACd6qdxNh/q6cfc+MQmshU5p/8UPNScn2C8KKPBkBb3OWMyOYe+WLf4VQXGdR9oC5tprxaRj0pTd12zRK/VqRzGb084ZFSm3ImLT76XuaSo6o+DVyIAWkP82/LD323PSKAKkoZisSMS7dkhubireObIZaBoasBmyFBh+PFJzf9LLdGXcwxa9zvemlPtwknlKgQpdXJLgnp0+A8Alx6Mlz+Ezm2dI4E1I3W7DHaTKfkX/vgsLqasCAP6dLLFF4AZD/8+NEWJpTk/0xkT6MLOt6VffbbUV51emkJOVTKXKr8Kj7FZ
 fAUoOAeP
 Y2ezrZ4kv+dPxvcP3pZ9UaMFiXrEEKrSI4Ar2IgNFHaJ/5l+YH3jeOJq9y9g1W2AyP17Wr0ivUrZfdmIMUvrmW5kRV6UFLV1CjFVSiXlQg7nu6Q6P86lrDnRLIF7VD1z+vyN9PmiuPiCTtYK5KmU2P7zoT18IEzAQQtrM5cOBd0S1JmTj7ghtMkCzQPo7fRXSqAyyAg/O3T1Afp7sRCtyw9RXWY7GiLuhSSTXgprNTXvS6QV7fniUrqBW76GHnzs6ZRw8d0TnTHV1xasqzmN9czKmvOUtq+rdiuLhRWRsQjEWsuL6yXgse0UQeUXCbxMzJKO1jjIrE8wcrzerxs54sQl9MuICslemt+yF4oFmAjGsUS64rx8dXUNciEEqezoWtGN0lWuN7cezdvMeKWhfoQTZObEogtPs063RMdqEzu5QTN37VHIhrAFDS5Cc3qWhZGTcamqA/jmFjDoxUrkIm9XojDknCM8KfnOX0gyqOLQoQVLa6MXThYG0Z6dh1Mt1FqAH+1fAvAwP0vtI3c85ObEbzMlz+5okTSX2
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
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/fork.c | 20 ++++++++++++++------
 mm/mmap.c     |  8 +-------
 mm/nommu.c    |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 18b6dd8516427..ee40142dab31e 100644
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
index 91ab65afda705..6c6f953296746 100644
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


