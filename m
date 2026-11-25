Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BFA606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWRSzkxK
Received: by kanga.kvack.org (Postfix)
	id DCD126B0B1B; Wed, 25 Nov 2026 17:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4856B0B1D; Wed, 25 Nov 2026 17:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94046B0B1E; Wed, 25 Nov 2026 17:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91F7A6B0B1B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:39:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5ED6120175
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:39:06 +0000 (UTC)
X-FDA: 85475108292.17.0CBF0A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ECB6E40008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:39:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWRSzkxK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646345;
	b=pLaVT5O3XQU3C4Fvcg6LxsoZxOgkW4mpJ0Z776th763bSpHUhgqEmKV4RlYQjfKj48qkqv
	DXInZHWCYXNOQs/75Q6oT3XuH7JPvrVqG5AFbpYRhygQn6QCxKuZxnZ0hnBsbfImxUqVtf
	vay413N5rqxY9LrXiKb0ehIExfd4z/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li/Z73kIBxQSgciTmM8k7ypsdLM7WIF3LC62JW/m68c=;
	b=YrxlxeG5ry+olkmcJMgauuFWin0NJol54uN3g8dYUFDjNcHAFmK8M4Z+bgzO5kL4vJkXK6
	y2ctfxcsOxa+d9fW16C6I3Mhmt7yDxEYysx+GGywmubRiZkAMQRwl/FcNl9+0YTfWhjnDG
	/BaBYDv9POaXLKmcTAhwmKexoVA11Xw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWRSzkxK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6631662C54;
	Wed, 25 Nov 2026 22:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9E51F000F0;
	Wed, 25 Nov 2026 22:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646344;
	bh=li/Z73kIBxQSgciTmM8k7ypsdLM7WIF3LC62JW/m68c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WWRSzkxKCDtSTbuZO9OMBcIfWezVK/8KYw9obS2Wic3WfhWYL/H4LAa/9miP/KChS
	 dpbbuZdFJ/ltxFE9X+kRMLux851BA9WBn5vEWTSxqPcse4iCblZq5qba3QO2A/gMe5
	 FQFnJoORZE0KObUJjQ/2Bn4TcNDxTBKvTDj9jhnZCkWthJ/s3wfe+5bhC2uxGMPkZR
	 sR5i2IxpIglwqi4IvRpYtm/PQFY3BV1gU+lIDj+y1pzbS1XxQZF9bJcniYUGYlqTHZ
	 /8dPwpDVl/TeyTGIzPrcVIK7kHt+hwdmavgP9LUtMonJZF687RYVWXeJ1hNhz9QRvJ
	 6G+PuPLFnQ0kQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:19 +0100
Subject: [PATCH 21/21] RFC: mm/hugetlb_cgroup: charge faults to mm->owner
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-21-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7801; i=david@kernel.org;
 h=from:subject:message-id; bh=lJ4xfsTmQl063PifoPRspfQkZofQC6q60Ex8KWNPtEc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1TlMoOMzGK3Kgj4P5Zk+ej8QK26jeHLiQ0qKU3c3
 n8Nb3/rKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCKvJjMynF/K8E+uaVfc07Vi
 KzynrTxq+6zQIEH3QH3021A+z7ZznAx/xY4+mfs9YHNA6uvFkR9lQ02+X98cwW7Nsv+VgZTLwxv
 K/AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECB6E40008
X-Stat-Signature: xh8ghfpo8sg1pmwb6t73wh369oamj3z4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646344-690654
X-HE-Meta: U2FsdGVkX18u6UCpiesSt5g1JIO+jrcZjc0+Wb+xIA5dRulvFh2qJyJdc51GVpWbNqHci4kEojECQMu+8hfpjihox4wAxmC7mJYwbxcujW0x2YEPOxUrpPXfNuiutOlwmUCdSZq6KhaMkP7hL0Aymf9zz8g+b58AYoFLF4Cz2tJCQnUre5cwZOHQLtRXuAI94lVdsUbg4+Tj4GnNoCxBq+4sv3OXJRsSr3J9kVoQniGbtloqJ9RK3K2zX9+RAsjULVqi2H/0eViKsba0fNgCzGRt19bFzG6JnKnDaR1DC1K1bW7IweQ4vYhQED974XE3qjGsxaDjn/dS3wHRZbTybFDMd5SeCSf4rbVEdfYvjFx+CY97TUSaygacmhputTjDs540aiewrV6aCaDxw/nXft2AkACavj5basKIeNLkg04/s5gB+yb7c0rgcBH0YLaHNiwI/ll8ng3d6Tbx8xlazhuBB9LxCc5aINSWlewkaxogQjL1q11sHyMkH2zW6/OqJGxt7Kvx5ASt5Z398e9hCUO8sy7Dd9/8ZTWBSW4D11SE0aW+BeiAKUp4yKe6tZ+UNMyqpltdhmYQDoGu3u/6R/OsnYY8SeW/usCe5Z3uYieSEybPdG4amDqsW+ywWE88CNbLs1RZypGoIVRJtcLfnlxayR5+lMv5wtRYEEjYkCyIXgFDqv2U4W4EhxJykQ630WY51ZsPV+KWMjHfaSeehtJ+N/xg+RR+8bZhEo6c2hqxylQXeWlA5EcS6J5uf3NUEI1ghMMd4k867P/E1qX4dLBHzNyVBHxL1cj396Ds981cslzQ8LIbxPby8Ur68yBJNZjzWavb10ACz5YxyFe0VImkdxqf+pU6zJQtIGb0jWSS0mqBENB8ehjhkpiG/CwseeFYkzc4CCjE2uQuihyfAEbFV5TGcIth8O7aLp3sMrRTRVXmSN9b64fE+WWAv+lFtSY3J8WSODqVRRF16iL
 Tgipk4Pj
 Y8iOzfUOQFE4Lq4mkacgn/7offk0nKeVx4MteVa0sVD6XzDM9YWRIURfuZK0F39N1F+TsJONdIntc9xUmMOweTpbhRwjEQg2oXlJPWkwSLtDEwzr1gF1FvR9fl/xvVwrQGK0QCL6xsNJHS7KEiy2hTCAqBRoMctoBqrnwkkjvJesS7BFwcnl7qpPLzMfX+zGVR1jAM/ICL/JZG3f5EQ04wZFiUXWVdjSFsYe9jNi2mmQgYt9FfOXK+1LnTDQbsFoAGWepZn3kdlT00k/5cCXGHriXXh1vHDb1LTFY4/qnOqZkwk6qeJzoRXzJf87ncDc2wgmZezhECu49V44ibGihpO0KAzlCO/83MscvNKhZzVR27w7nqUKWPTYIN75n6x+o/xwPYifSp2AKXwOO8PO/Z6mPnu8A268YnvBtN5JSE6RmUcNWWOsVD0XEGQj4WtCCbkSJyb+Bcn6WE033MQlHVcfjJX5OywWgS+eJMdQoCu5HXYI+JzBkFPAM3KopLuNSJagI0a7PIq3pwwK352Kc92KkBnt5DuBDGABlHBzIS1u73kI0YVACJn8287cm/nYHzFBgEluSWrC+A9nC7gYjAVMlag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We can bypass hugetlb cgroup limits when a kernel thread faults in
hugetlb pages for a user process: __hugetlb_cgroup_charge_cgroup()
charges the hugetlb cgroup of current, and kernel threads usually live
in the root cgroup, which has no limit.

For example, a KVM's async page fault repeats a fault of a vCPU that
just failed at the limit in a kworker, which then charges the root
cgroup:

    vCPU thread                     kworker
    ===========                     =======
    __kvm_mmu_faultin_pfn()
      hva_to_pfn(), FOLL_NOWAIT
        hugetlb_alloc_folio()
          charge fails
        KVM_PFN_ERR_NEEDS_IO
      kvm_setup_async_pf()
                                    async_pf_execute()
                                      get_user_pages_remote()
                                        hugetlb_alloc_folio()
                                          charges the root

Let's fix it by charging the hugetlb cgroup of mm->owner whenever we
allocate for an mm, like memcg does. Unlike memcg, which falls back to
the root cgroup, we fail the charge if the mm has no owner (anymore), as
we would otherwise bypass the limits again. As mm->owner depends on
CONFIG_MEMCG, nothing changes without it.

This changes the charged hugetlb cgroup in these scenarios:

 (1) Kernel threads that fault on a user mm, such as KVM async page
     faults, kvm_xen_set_evtchn() in the irqfd work item and
     iommu_sva_handle_mm(), now charge the cgroup of mm->owner instead
     of the root cgroup.
 (2) vhost kthread workers, which join the cgroups of the task that
     created them, now charge the cgroup of mm->owner.
 (3) With cgroup v1, threads of a process that are in different hugetlb
     cgroups now all charge the cgroup of mm->owner.
 (4) Processes that fault on the mm of another process, such as a
     userfaultfd monitor (UFFDIO_COPY) or remote GUP through ptrace,
     /proc/pid/mem or process_vm_writev(), now charge the cgroup of the
     target's mm->owner instead of their own cgroup.

... which should just be the right thing to do.

This has low urgency, as it only affects hugetlb cgroup limits. Let's
not CC stable, as this might not be particularly easy to backport.

Fixes: 6d76dcf40405 ("hugetlb/cgroup: add charge/uncharge routines for hugetlb cgroup")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 10 +++++-----
 mm/hugetlb.c                   | 11 ++++++-----
 mm/hugetlb_cgroup.c            | 30 +++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 1c437eb2e1c30..97208bb9d9639 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -139,9 +139,9 @@ static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
 }
 
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-					struct hugetlb_cgroup **ptr);
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
-					     struct hugetlb_cgroup **ptr);
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr);
 extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					 struct hugetlb_cgroup *h_cg,
 					 struct folio *folio);
@@ -225,14 +225,14 @@ static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
 }
 
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-					       struct hugetlb_cgroup **ptr)
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr)
 {
 	return 0;
 }
 
 static inline int hugetlb_cgroup_charge_cgroup_rsvd(int idx,
-						    unsigned long nr_pages,
-						    struct hugetlb_cgroup **ptr)
+		unsigned long nr_pages, struct mm_struct *mm,
+		struct hugetlb_cgroup **ptr)
 {
 	return 0;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 438263c2ba3d9..2b0ae201e1e60 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2305,7 +2305,7 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	int idx = hstate_index(h);
 	int ret;
 
-	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg))
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, NULL, &h_cg))
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -3000,7 +3000,8 @@ void wait_for_freed_hugetlb_folios(void)
  * hugetlb_alloc_folio - Allocate a hugetlb folio.
  * @h: Hugetlb state control block.
  * @mpoli: Interpreted memory policy to use for allocation.
- * @mm: Memory descriptor of the allocation target.
+ * @mm: Memory descriptor of the allocation target. With CONFIG_MEMCG, the
+ *      hugetlb cgroup of the owner of @mm is charged.
  * @alloc_flags: Flags controlling the allocation behavior.
  *
  * Allocates a hugetlb folio and handles cgroup charging and global hstate
@@ -3026,10 +3027,10 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 	int ret;
 
 	if (charge_hugetlb_cgroup_rsvd &&
-	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg_rsvd))
+	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, mm, &h_cg_rsvd))
 		return ERR_PTR(-ENOSPC);
 
-	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg)) {
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, mm, &h_cg)) {
 		ret = -ENOSPC;
 		goto err_uncharge_hugetlb_cgroup_rsvd;
 	}
@@ -7011,7 +7012,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	}
 
 	err = hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
-				chg * pages_per_huge_page(h), &h_cg);
+						chg * pages_per_huge_page(h), NULL, &h_cg);
 	if (err < 0)
 		goto out_err;
 
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 6ee771334a3bd..be6a3e0f13209 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -281,9 +281,20 @@ static inline void hugetlb_event(struct hugetlb_cgroup *hugetlb, int idx,
 		 !hugetlb_cgroup_is_root(hugetlb));
 }
 
+static struct hugetlb_cgroup *hugetlb_cgroup_from_mm(struct mm_struct *mm)
+{
+	struct task_struct *task = current;
+
+#ifdef CONFIG_MEMCG
+	/* Like memcg, charge the owner of the mm we allocate for. */
+	if (mm)
+		task = rcu_dereference(mm->owner);
+#endif
+	return task ? hugetlb_cgroup_from_task(task) : NULL;
+}
+
 static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-					  struct hugetlb_cgroup **ptr,
-					  bool rsvd)
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr, bool rsvd)
 {
 	int ret = 0;
 	struct page_counter *counter;
@@ -293,7 +304,12 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 		goto done;
 again:
 	rcu_read_lock();
-	h_cg = hugetlb_cgroup_from_task(current);
+	h_cg = hugetlb_cgroup_from_mm(mm);
+	if (!h_cg) {
+		rcu_read_unlock();
+		ret = -ENOMEM;
+		goto done;
+	}
 	if (!css_tryget(&h_cg->css)) {
 		rcu_read_unlock();
 		goto again;
@@ -318,15 +334,15 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 }
 
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-				 struct hugetlb_cgroup **ptr)
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr)
 {
-	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, ptr, false);
+	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, mm, ptr, false);
 }
 
 int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
-				      struct hugetlb_cgroup **ptr)
+		struct mm_struct *mm, struct hugetlb_cgroup **ptr)
 {
-	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, ptr, true);
+	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, mm, ptr, true);
 }
 
 /* Should be called with hugetlb_lock held */

-- 
2.56.1


