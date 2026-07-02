Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA029C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B7B6B00EC; Thu,  2 Jul 2026 20:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BF96B00ED; Thu,  2 Jul 2026 20:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B976B00EE; Thu,  2 Jul 2026 20:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70E1D6B00EC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:38:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E349C0900
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:55 +0000 (UTC)
X-FDA: 84944352990.01.B0981B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 383A720009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DT1jqrFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009313;
	b=TEl7JSopxikWdxgkRrRbSOnB9aTd2DFXRXWdiFg0okOxzwTzbFUZun3unofIfYh/XR/GOj
	WBDEYoV2ufyk2U5tjbLfuOki2xsx6jz6lFVfy1U+b/CyCVGamsY6eXN6U6LiNbLM/XefRg
	KMCY2jRRZY3Qhd6Be8CEQ94FeL9Tmrs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBqqDNZEl5+EHLqYjdFvzelVGNAWv1bS2bg8u6KXaV8=;
	b=b8Dhk7zTmEWqyxYE9/j3TpquTo/r9f151LFQVH3X+vhl4ondf+qSts+xh7BcYkYXFSXREF
	Y2Ml3pqFrAxc9VKZTEqOSyz1H3FB/C1ZgdP9Zy63Gn6IA5KbYQs1C7O9uii8+tDgO/Gty8
	RDp83AZwxQ0ON7cFX5hR2ZQVFYaUpJA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DT1jqrFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D5AC43C3B;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 172C3C19425;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009312;
	bh=u+i9RMZUlA1ZtQC5XQrEhQo3OPuJSKxInkQBOd6zHBQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DT1jqrFpvhcaqcT9/4hriaot/CypmVeyK8PuqueJRX6wDqvCA5rM0qhO9bsyllk+9
	 02T0Ym4Cv1N6UxMS9FNKmm46CNWbx7Lmgle3TN543ZsKdB7SPXoc6LmugEOIKxiqnp
	 69PVHbO0OUwSEttoou2xLmDwtlTvQqqjf+grp2ZZI4y4DK/Kayd3guZ/upltqS62jx
	 UuhJEJizSEP0DIlYkWXzqL0gGlgrOE6Jrwv/t4hV6ZSFYnryKRNy7BX0xkThsedgae
	 HLw+tfHXgY+BIb1D2WBrPgK3msyoSVCjzPanBi+TemxljRym3m0aXQwhj4t7ujHSeC
	 r9/5gSe1kQH9A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0525AC43458;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:50 -0700
Subject: [PATCH v4 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-6-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
In-Reply-To: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009311; l=11012;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NJwdshB7i4S52gDDnBvuAQ3PyD1VvUG+tN68S1geWHc=;
 b=R/V87kIQdD9dRQqZVMfTTR+QNvQPgbrUQ7l7IXFThjHH2W//SRXR8GYYXmYjJMADAg5i/uuAS
 +TRwy4u5z2zBowi46epKP4I67MrcyRnO8KlPa8f9wgvM8rM1FlzdSc2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: upwch5cinwpearobf4iqyzgq3wf3sxp9
X-Rspamd-Queue-Id: 383A720009
X-HE-Tag: 1783009313-594773
X-HE-Meta: U2FsdGVkX19LPZIrSgdclGOHIO+SMMN8SzmPaKfcMUdN/uiT902buShjX/xr3fG2TDvGcKm3sapQrDXXwIz0/uhQFNhX7TWcHBtG3nsiCBKifJ4KCMP4u4AKs+QUVzQt4tpKPfEt29gxTgvBAzxoezFF3D3fezTXW8Ysp0jV1bKV6Cc5sW7IUdr1SJqrwJrSqYus5OuL/uZer/cP3oClPaxak1wuE1C1o76k28ahf0Wr3yJ6RGGJGuzDqlbmukrBmNTQKAdBrOhHUu85eQlwrnIDDPqat+ll32F2W1ZMp6wVOQ1ZQ1xAx+PJ07b1lUfxcKrxNCzemCSz2gHDnDrpiuk5GkhXKEsFlUSN8UXmbRdW9m9/+7b9xe+c4z4GNqmKV/W2Mr2UNqlhDVGzEqGj3m/Zapai23/cbWWJA8xANYz7zi2wSnoVt6KvDkNXbL9evG+EoowhJZGfWa8rRQNMmJXM6DRvJnCr1g4WubCSIK2qC9uxa7wZZQkLbD+1JcT9+HnpE2XYzhVC9QcTwE4Fv3c0jmXFKuxQS2Pi+f2Gec+av2KWfeFqVxpU/cqQKSdLboKZbNkYm17f8KrO8st+sybaPc3g4qr0kWVcoMK6BNjddZMvF6IVqjoEfcnJMyv88e6r9tgukP/6jCAVT2giqqtFc8pDHD38She2Q4/9ybtutCOgC/dHofZrRNkk+CTikj5acWspdquG0boiZWtS77RnLNsA1AV4LTVPIbskNXGFYIT2MEqsAGfSJSDyCXdwJEfzbMQrRhNqhDZ3IzW6NMNIwBaZw6GmrexMVAU5gxc+zaIRWdsd8i/ql+rGj7Ufe7+4eufM1YtSm5LHCrjlgKOSkSAv7Djjz61fjFBq6AznrjtTQ83fliwC5/hutwAtYzHf9Q4OWOZIoIeI+MRA22BTs54221LLRk5Adlr2rhnUYPVAKem/Oi/ky2P/QNt8LxlxLWDWppHCm5RQgKo
 phQU8GNS
 o/xN2LXnPv2OEVzhlCB/SfS+pfyxvvFoQFX6IDHk9e2w81omkvOgap+l/VEjuhXOPSFyGQ16XiFzfzmJH0K1VBiYw/97vBmq1gphsMUmQTLKisaYgNsdNuWpiNuOUjzXuwVWLF+ptZ1NCgXvqLv1Oekq8zftcI1wvECy+cwxd59Fex8HPZonQ8iUdBh90J6jw4ZQzPsOaDs3J5mU3eViNzK2Ho7GYcbTrK+k9Xh1/WZq1kfsjZAu7Eeh0OhyF5Q6veT7er3mQuUM42RtYtKJINlGalFGqCBkJBCgweMci1kO8p8BDO/pM8SqjbNj3hyqk8PWqM1U/bDJwhEGDOiokSCWftYndGKAul6GxFBiToQUEkS++Iy9ug2klTnMNUV82R7WSTgirYcknk7Z+ahzAiKfP7IV1PSnkfJAx/yzY1954GcNXeNmGwkffogHD3spd30adHVKt5dNf3O0zknC/0Cm3twH1Nb+qwIzy1MHq6M+3Nedo8vwmm4VvAId02X+iffD11ATbiyrSl3rZnU9mdTf/VgGNEZv5hWIW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
handles allocation of a folio and memory and HugeTLB charging to cgroups.

This refactoring decouples the HugeTLB page allocation from VMAs,
specifically:

1. Reservations (as in resv_map) are stored in the vma
2. mpol is stored at vma->vm_policy
3. A vma must be used for allocation even if the pages are not meant to be
   used by host process.

Without this coupling, VMAs are no longer a requirement for
allocation. This opens up the allocation routine for usage without VMAs,
which will allow guest_memfd to use HugeTLB as a more generic allocator of
huge pages, since guest_memfd memory may not have any associated VMAs by
design. In addition, direct allocations from HugeTLB could possibly be
refactored to avoid the use of a pseudo-VMA.

Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
subpool is stored at the fs mount. This is also a requirement for
guest_memfd, where the plan is to have a subpool created per-fd and stored
on the inode.

Provide and use alloc_flags to allow more allocation knobs in future
without expanding the number of parameters in hugetlb_alloc_folio().

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h |  18 +++++
 mm/hugetlb.c            | 206 ++++++++++++++++++++++++++----------------------
 2 files changed, 131 insertions(+), 93 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..d506348ae2f0e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_HUGETLB_H
 #define _LINUX_HUGETLB_H
 
+#include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
@@ -691,6 +692,23 @@ bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
+
+struct mempolicy_interpreted {
+	int nid;
+	nodemask_t *nodemask;
+	enum mempolicy_mode mode;
+};
+
+enum hugetlb_alloc_flag {
+	HUGETLB_ALLOC_CHARGE_CGROUP_RSVD_BIT = 0,
+	HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT,
+};
+
+#define HUGETLB_ALLOC_CHARG_CGROUP_RSVD BIT(HUGETLB_ALLOC_CHARGE_CGROUP_RSVD_BIT)
+#define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
+
+struct folio *hugetlb_alloc_folio(struct hstate *h,
+		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 08ac28111e694..9a639800eb79c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1317,12 +1317,6 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
-struct mempolicy_interpreted {
-	int nid;
-	nodemask_t *nodemask;
-	enum mempolicy_mode mode;
-};
-
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 					   struct mempolicy_interpreted *mpoli)
 {
@@ -2812,6 +2806,104 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+/**
+ * hugetlb_alloc_folio - Allocate a hugetlb folio.
+ * @h: Hugetlb state control block.
+ * @mpoli: Interpreted memory policy to use for allocation.
+ * @alloc_flags: Flags controlling the allocation behavior.
+ *
+ * Allocates a hugetlb folio and handles cgroup charging and global hstate
+ * reservations.
+ *
+ * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
+ *         -ENOSPC if cgroup charging fails or no folio is available.
+ *         -ENOMEM if mem cgroup charging fails.
+ */
+struct folio *hugetlb_alloc_folio(struct hstate *h,
+		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+{
+	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
+					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
+	bool use_global_reservation = alloc_flags &
+				      HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
+	size_t nr_pages = pages_per_huge_page(h);
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
+	struct hugetlb_cgroup *h_cg = NULL;
+	gfp_t gfp = htlb_alloc_mask(h);
+	int idx = hstate_index(h);
+	struct folio *folio;
+	int ret;
+
+	if (charge_hugetlb_cgroup_rsvd &&
+	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg_rsvd))
+		return ERR_PTR(-ENOSPC);
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg)) {
+		ret = -ENOSPC;
+		goto err_uncharge_hugetlb_cgroup_rsvd;
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+
+	folio = NULL;
+	if (use_global_reservation || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio(h, gfp, mpoli);
+
+	if (!folio) {
+		spin_unlock_irq(&hugetlb_lock);
+		folio = alloc_buddy_hugetlb_folio(h, gfp, mpoli);
+		if (!folio) {
+			ret = -ENOSPC;
+			goto err_uncharge_hugetlb_cgroup;
+		}
+		spin_lock_irq(&hugetlb_lock);
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+	}
+
+	if (use_global_reservation) {
+		folio_set_hugetlb_restore_reserve(folio);
+		h->resv_huge_pages--;
+	}
+
+	hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
+
+	if (charge_hugetlb_cgroup_rsvd) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, nr_pages, h_cg_rsvd,
+						  folio);
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here because if
+	 * mem_cgroup_charge_hugetlb failed, freeing the page will
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+
+ err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+ err_uncharge_hugetlb_cgroup_rsvd:
+	if (charge_hugetlb_cgroup_rsvd)
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg_rsvd);
+
+	return ERR_PTR(ret);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
@@ -2846,16 +2938,13 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct folio *folio;
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
-	int ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
-	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
+	u8 alloc_flags = 0;
 	int nid;
-
-	idx = hstate_index(h);
+	int ret;
 
 	/* Whether we need a separate per-vma reservation? */
 	if (cow_from_owner) {
@@ -2900,23 +2989,18 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	}
 
 	/*
-	 * If this allocation is not consuming a per-vma reservation,
-	 * charge the hugetlb cgroup now.
+	 * If allocation doesn't reuse a reservation in the resv_map,
+	 * charge for the reservation.
 	 */
-	if (map_chg) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg_rsvd);
-		if (ret) {
-			ret = -ENOSPC;
-			goto out_subpool_put;
-		}
-	}
+	if (map_chg != MAP_CHG_REUSE)
+		alloc_flags |= HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
 
-	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		ret = -ENOSPC;
-		goto out_uncharge_cgroup_reservation;
-	}
+	/*
+	 * gbl_chg == 0 indicates a reservation exists for this
+	 * allocation, so try to use it.
+	 */
+	if (gbl_chg == 0)
+		alloc_flags |= HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
@@ -2930,69 +3014,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		.nodemask = nodemask,
 	};
 
-	spin_lock_irq(&hugetlb_lock);
-
-	/*
-	 * gbl_chg == 0 indicates a reservation exists for the
-	 * allocation, so try dequeuing a page. In case there was no
-	 * reservation, try dequeuing a page if there are available
-	 * pages in the global pool.
-	 */
-	folio = NULL;
-	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio(h, gfp, &mpoli);
-
-	if (!folio) {
-		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
-		if (!folio) {
-			mpol_cond_put(mpol);
-			ret = -ENOSPC;
-			goto out_uncharge_cgroup;
-		}
-		spin_lock_irq(&hugetlb_lock);
-		list_add(&folio->lru, &h->hugepage_activelist);
-		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
-	}
+	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
 
 	mpol_cond_put(mpol);
 
-	/*
-	 * Either dequeued or buddy-allocated folio needs to add special
-	 * mark to the folio when it consumes a global reservation.
-	 */
-	if (!gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
-	/* If allocation is not consuming a reservation, also store the
-	 * hugetlb_cgroup pointer on the page.
-	 */
-	if (map_chg) {
-		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg_rsvd, folio);
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
-
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		/*
-		 * Skip uncharging hugetlb_cgroup since the charges
-		 * were committed to the folio and freeing the folio
-		 * would have cleared those up.
-		 */
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
 		goto out_subpool_put;
 	}
 
@@ -3025,12 +3052,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	return folio;
 
-out_uncharge_cgroup:
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (map_chg)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
@@ -3041,7 +3062,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
-
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);

-- 
2.55.0.rc0.799.gd6f94ed593-goog



