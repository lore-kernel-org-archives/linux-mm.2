Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59581C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764116B00A4; Wed, 22 Jul 2026 19:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDB46B00A6; Wed, 22 Jul 2026 19:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBF16B00A7; Wed, 22 Jul 2026 19:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 142E86B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C726A035F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
X-FDA: 85018036446.24.4502ED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 62ECD20006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/+b1J2j";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763681;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsCj43JtF0JeEGqh8y/E9WzsYKwKetxSa1YtFd6H2V8=;
	b=zRnGu/PP49pJi/icGzp++0kQ34LmkC2NfBBhewdBQ31loWDJ8YhwRmHQwFh/ugR7eudsZA
	4d13yYMRa5N2Cvj6cO2rEtV17q27nMzoZSRh8Sa17v4f5n98BZRs0GsJeRLqyD/JtntmwH
	KkMeABEB0FgBhlPaUUEnu9IxrR73NZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763681;
	b=qNxsSgt1ynQH89HiNt5DsNuwty5tDaTAZlsfMGHrGBckX7reLwfunF9tuNid44oDZGjwmB
	GGKs2y7AFhFXEfgtgXNrcRFWhElb5HaNgrC3MDXM9rPsHvzKLtqhxgimXboP7TLnGME4LT
	R8WhmjGFGWmkn1krnPzzPJ756giCtaI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/+b1J2j";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E15945081;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBEE0C2BD00;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=gdyXfp6oV2z7yddoLW13M8klm/MDNV0FUwUjUXRLoak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Z/+b1J2jr/NLTK6eDcWdxX8SF6KLayk+pvoOrE7IGnih1EV3hEMXO4Zd6HuamfKeF
	 SDifgvho/8/TKQgoDuzA2ZSYkS9pZ25zVo8tzL/ouRtU6pKTksopLgtD3XziJnD7HX
	 IT1RbjcehTU3JJAXnufFjVSCU7dK0htbcOhvHxpXoSIVaku1S7dEPMIO1mEj9m6hyJ
	 imJmB6N4r9Fq7a8ad5ltb+mHj9yGrhass7umXJ23HpzTWUgfr1kCulHvbx5egVAppE
	 hyu1BTeifjBoIVu5wHcp0csuHPXizP8Sa007V90gfP+q5nmiX6L4maSb7SSV81DImV
	 d3LoFfzi0sFeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CC6C44532;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:11 -0700
Subject: [PATCH v4 03/16] mm: hugetlb: Use try-commit-cancel protocol for
 memcg charge of folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-3-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=10726;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=vqQmK3vN70VbiuGHrvYrgKdPuFJc0Ryl2R9yY2WzCMc=;
 b=FrpFLnNeyQ3odoN5g/ynV4evoTr/eoT6mQ2NGQz780SQ4+n3wcukCV/XcDDhN/ShTiyR4BlX1
 p8UNLtHCnEMCI5eROYm7u8CY3JSd5dEg9TehHnOB1fSlzXl16S/e3nL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62ECD20006
X-Stat-Signature: cr8fbxdpmm1ofdsuay8moe6qsf9uciat
X-HE-Tag: 1784763681-452126
X-HE-Meta: U2FsdGVkX18p0qrtX1hCU04lRj7GFYgZ4Ovj+nQKoBmpLZmg7WM/iqZ2qxJZhOwZB23ybicrptoNzNX5Pe90ekvIqKIklWujE5TZW2Qq5hiO2uV++uVt2W8WlCXn8/yNHUIr19hSr49y8rfYZ1ZdRr6DEDW+Nqg/Q9Ay+NfeiwXWs4wCKekBsKpt+QJMZiecaVlfrywLer2bGr+E1deGWK8QzWkobKDHF2pL4iF8tXJ76EB/2VZKNP2/83bDp2jyjFrDHwQSXM+Ax6by+SkDiXYldJR9mnQgq+W0+C+xSxpsU4Ce66tSF6GV9XHFcHM/4ey46qz5kZhLjfLvoEMBfXFHlXkbVaPcSp4IlnWq+Z/Ux79TrxEYm3nEdy1UfTfcRuNfoaG14aJqnGNxkh2h5I9GWiMTPr0Fdw65YlWUTmp+ammHaKJZTTX+V8oo5elWCZH20WoqLQVKvXo9YMsRyECBNR7Peft5uFriuQD3Z9yebc4snduFxpsYAGQQ75HiohQWFpYtejYtqs5brZP+/Y8aPDgbVZhKrjkylvxbl4+wWePzbcKyHC1dulmwr68mq48r3XlIzecoaP58TI3FHocp7tMeP631v80h3p5wlvg43Ng3edBT0dfjVke2Zq92zpflVBsKnvlr2KDlk7uTCQXOflpIm8vTrAPb2QvzrH81hG2oO88zuIP8pXbqTeORTcdlasIxuXaOOn6zJTjNtwTYo4y4l7/1KoD9rMNxVzz8xtRf75R3woBVczv6wfNJoDpMG8zvB67lMPkZmIbWX9Wb4Kp0ya6UHNn0MpOyJ/K1cto9x0AQzhaed8X+Wnq8Xv38ifpQuBYjkRbkIc7uxsa9eQdlPApuJb1mg1BjKNLDeTfPQrxFfegBJy/q1KQht/XiMANe1x6+AtO+jEXpPLEolG692pwstIN8uAjORnXAIUFGeVFNjt6veOoNqJhZwm9JGzkPl5Lc1Uerzn4
 R3AEuhbn
 OhmUVIN7l3jbRS3/cnKTcQqkhFsel/WBlRHqf8fqQdE32iRAjZZ2CAZaR9nxNAs4PqVxNWA3wV6zxluZjNPXQYa3pZsGbpG9gm8Y9IjC+eYpTaVLitEg2aTeSRncvKkcoKYeuMLe4rjCUHjlntus1xjVqFhIwFupA0iTzXYyeqKZ8u1kzzITfGTLUv+gI5oDcaPNdSinHOwwRcTpbJ3SmzHWVanDD/aZ8UGNI0rDgvg9McjxSYsxzxgVGKCXkWUtEpoX5E9ObRYyDqjRMEM/qK8p5Y2mURsh6apjChY4rs7/KVLXSaWFb6pqqvYXu5j3x3Jna5Gw92LxOD7kB4KEGAGz2IUiUEfOioDzrOfODUMOwHab39usWOBjxsLhN392Ht8TqbiXZrVXs8lpQl6HXZ11GITtDPn0QswVmrfApZGxUlk5gcSCf4rk5iYBNSmUA5puviwNHQlAvUFzOE/p9+mpKeg8GrTIwuK/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Using mem_cgroup_charge_hugetlb() to charge a HugeTLB folio during page
fault creates a reservation leak bug if the task hits its memory cgroup
limit.

When alloc_hugetlb_folio() commits the VMA reservation, the reserved
page is removed from the reserve map. If a subsequent call to
mem_cgroup_charge_hugetlb() returns -ENOMEM, the allocation is aborted
and the physical folio is disposed of via free_huge_page(). However,
because the VMA reservation was already consumed, the reservation count
in the reserve map is lost. This causes subsequent faults in the VMA
address range to fail with premature reservation exhaustion.

Additionally, dropping the use of free_huge_folio() on the failure path
fixes an issue where free_huge_folio() was incorrectly invoked on a
folio with a refcount of 1, triggering refcount mismatches and kernel
warnings.

To fix this, introduce a try-commit-cancel protocol for memory cgroup
charging of HugeTLB folios, matching the architecture used by the
hugetlb cgroup controller. Invoking mem_cgroup_hugetlb_try_charge()
before consuming the VMA reservation ensures that if the memory cgroup
limit is reached, the allocation is aborted cleanly without leaking
the reservation entry or having to dispose of a partially initialized
folio.

An alternative would be to retain the current usage of
mem_cgroup_charge_hugetlb() and free_huge_page(), but freeing the folio
performs reservation management for subpools and global hstate, which
complicates rollback in alloc_hugetlb_folio(). Using a try-commit-cancel
protocol is more consistent with the other charging performed in
alloc_hugetlb_folio() and easier to understand.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/memcontrol.h |  30 ++++++++++++
 mm/hugetlb.c               |  30 ++++++------
 mm/memcontrol.c            | 114 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fcf..2c3e2c62f4176 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -642,6 +642,15 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 }
 
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
+				  struct mem_cgroup **memcg_p,
+				  struct obj_cgroup **objcg_p);
+void mem_cgroup_hugetlb_commit_charge(struct folio *folio,
+				      struct mem_cgroup *memcg,
+				      struct obj_cgroup *objcg);
+void mem_cgroup_hugetlb_cancel_charge(unsigned int nr_pages,
+				      struct mem_cgroup *memcg,
+				      struct obj_cgroup *objcg);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1133,6 +1142,27 @@ static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
         return 0;
 }
 
+static inline int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
+						struct mem_cgroup **memcg_p,
+						struct obj_cgroup **objcg_p)
+{
+	*memcg_p = NULL;
+	*objcg_p = NULL;
+	return 0;
+}
+
+static inline void mem_cgroup_hugetlb_commit_charge(struct folio *folio,
+						    struct mem_cgroup *memcg,
+						    struct obj_cgroup *objcg)
+{
+}
+
+static inline void mem_cgroup_hugetlb_cancel_charge(unsigned int nr_pages,
+						    struct mem_cgroup *memcg,
+						    struct obj_cgroup *objcg)
+{
+}
+
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 		 unsigned short id, struct mm_struct *mm, gfp_t gfp)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 15f9c5a9f75e2..5ee1bc5c00bfe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -38,6 +38,7 @@
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
 #include <linux/pgalloc.h>
+#include <linux/memcontrol.h>
 
 #include <asm/page.h>
 #include <asm/tlb.h>
@@ -2876,6 +2877,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	struct hugetlb_cgroup *h_cg_rsvd = NULL;
+	struct mem_cgroup *mem_cg = NULL;
+	struct obj_cgroup *obj_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -2935,6 +2938,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (ret)
 		goto out_uncharge_cgroup_reservation;
 
+	ret = mem_cgroup_hugetlb_try_charge(pages_per_huge_page(h), gfp,
+					    &mem_cg, &obj_cg);
+	if (ret)
+		goto out_uncharge_cgroup;
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * glb_chg is passed to indicate whether or not a page must be taken
@@ -2946,7 +2954,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
 		if (!folio)
-			goto out_uncharge_cgroup;
+			goto out_uncharge_cgroup_memcg;
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
@@ -2973,6 +2981,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	mem_cgroup_hugetlb_commit_charge(folio, mem_cg, obj_cg);
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3000,21 +3011,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		goto err;
-	}
-
 	return folio;
 
+out_uncharge_cgroup_memcg:
+	mem_cgroup_hugetlb_cancel_charge(pages_per_huge_page(h), mem_cg, obj_cg);
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
 out_uncharge_cgroup_reservation:
@@ -3035,7 +3035,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-err:
+
 	/*
 	 * Return -ENOSPC when this function fails to allocate or charge a huge
 	 * page. If a standard (PAGE_SIZE) page allocation fails, the OOM killer
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3f..0beee5c0ce93b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5180,6 +5180,120 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
 	return ret;
 }
 
+/**
+ * mem_cgroup_hugetlb_try_charge - Try to charge the memcg for a hugetlb folio
+ * @nr_pages: number of base pages to charge
+ * @gfp: reclaim mode
+ * @memcg_p: Output pointer to the charged mem_cgroup (if successful and enabled)
+ * @objcg_p: Output pointer to the charged obj_cgroup (if successful and enabled)
+ *
+ * Prepares and tries to reserve the memory counter for the folio from the current
+ * task's memcg. If successful, both *memcg_p and *objcg_p are populated and their
+ * references are pinned until a subsequent call to mem_cgroup_hugetlb_commit_charge
+ * or mem_cgroup_hugetlb_cancel_charge.
+ *
+ * Returns ENOMEM if the memcg is already full.
+ * Returns 0 if either the charge was successful, or if we skip charging.
+ */
+int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
+				  struct mem_cgroup **memcg_p,
+				  struct obj_cgroup **objcg_p)
+{
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+	int ret = 0;
+
+	*memcg_p = NULL;
+	*objcg_p = NULL;
+
+	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
+	    !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return 0;
+
+	memcg = get_mem_cgroup_from_current();
+	if (!memcg)
+		return 0;
+
+	objcg = get_obj_cgroup_from_memcg(memcg);
+	if (!objcg)
+		goto put_memcg;
+
+	if (!obj_cgroup_is_root(objcg)) {
+		ret = try_charge_memcg(memcg, gfp, nr_pages);
+		if (ret)
+			goto put_objcg;
+	}
+
+	*memcg_p = memcg;
+	*objcg_p = objcg;
+	return 0;
+
+put_objcg:
+	obj_cgroup_put(objcg);
+put_memcg:
+	mem_cgroup_put(memcg);
+	return ret;
+}
+
+/**
+ * mem_cgroup_hugetlb_commit_charge - Commit the memcg charge for a hugetlb folio
+ * @folio: folio being charged
+ * @memcg: Target mem_cgroup obtained from mem_cgroup_hugetlb_try_charge
+ * @objcg: Target obj_cgroup obtained from mem_cgroup_hugetlb_try_charge
+ *
+ * Finalizes the memory and statistics charging for the folio in the specified memcg.
+ * Transfers the pinned objcg reference to the folio structure (for automatic
+ * uncharging upon freeing via mem_cgroup_uncharge). Releases the try-commit reference
+ * on memcg.
+ */
+void mem_cgroup_hugetlb_commit_charge(struct folio *folio,
+				      struct mem_cgroup *memcg,
+				      struct obj_cgroup *objcg)
+{
+	if (!memcg || !objcg)
+		return;
+
+	commit_charge(folio, objcg);
+	memcg1_commit_charge(folio, memcg);
+
+	/*
+	 * Drop our try-commit-cancel protocol reference on memcg.
+	 * The objcg reference is TRANSFERRED to the folio by commit_charge,
+	 * so it will be put automatically by __mem_cgroup_uncharge() when
+	 * the folio is freed.
+	 */
+	mem_cgroup_put(memcg);
+}
+
+/**
+ * mem_cgroup_hugetlb_cancel_charge - Cancel and undo a hugetlb folio memcg charge
+ * @nr_pages: number of base pages to uncharge
+ * @memcg: Target mem_cgroup obtained from mem_cgroup_hugetlb_try_charge
+ * @objcg: Target obj_cgroup obtained from mem_cgroup_hugetlb_try_charge
+ *
+ * Cancels and safely rolls back the prepared memory charge for the folio in the
+ * specified memcg. Releases the try-commit pinned references on both memcg and objcg.
+ */
+void mem_cgroup_hugetlb_cancel_charge(unsigned int nr_pages,
+				      struct mem_cgroup *memcg,
+				      struct obj_cgroup *objcg)
+{
+	if (!memcg || !objcg)
+		return;
+
+	if (!obj_cgroup_is_root(objcg))
+		refill_stock(memcg, nr_pages);
+
+	/*
+	 * Drop our try-commit-cancel protocol references on both objcg
+	 * and memcg, since this mapping attempt was aborted and the folio
+	 * was never committed.
+	 */
+	obj_cgroup_put(objcg);
+	mem_cgroup_put(memcg);
+}
+
+
 /**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
  * @folio: the folio to charge

-- 
2.55.0.229.g6434b31f56-goog



