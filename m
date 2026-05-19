Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDCECD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DBA6B0099; Mon, 18 May 2026 20:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734556B009D; Mon, 18 May 2026 20:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6248D6B00A1; Mon, 18 May 2026 20:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD946B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17FC286D74
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:55 +0000 (UTC)
X-FDA: 84782261550.05.1B898CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD56A1A0009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fP+rcvHj;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149993;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TswVYOPWHVfR0Yx5KfTBbFmrWoPmfNOTiBA5UCwIIdQ=;
	b=j8l3MnxrhdCCYAfgFxUfimJfrVeP+E1djUqBCkk9pGoOii+BFoydWQra8N6cY5ziAUOsnv
	DdpacFLcR+K7JO0LARpgIFjXOTkRmOMwuYxRo2NQPkrAdXXE3PgVp8JpoSwlCiy91GTd4r
	YXBqNu1mM4h7ICrn8OE2Z3tAeaENnng=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fP+rcvHj;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149993; a=rsa-sha256;
	cv=none;
	b=GLCLLqMpvm/Ps/G/9qAwz7hUq/4nnicEGkguTJ3jYMjNDiokSTDi/S1UcxOKbFG9dpr49f
	SkC3vOgdZLa2asxm2WryGR3LI4l0gKtBCkwWgC3jDGqbuvwJVM1bAcNPHjt89SXUVWvMP1
	aUMoyCvAzgtPzjfT0gvuYJXqFksj2iA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3A4544589;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86E48C2BCB7;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=Hzt/De4mOk+Mrf1ClqEzbjx7/3o5fPwlCY7Yl8WAxDo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fP+rcvHjoZRdF3Es0PDdaC8inQibLP81EnJeouUhnH0sNoDR2R5iV/YDhxIVzMCJg
	 rDVz4sWtRyHnbaGNA+iozbhkAlHLLHyH9DR+d52pcqx6f8oy225qebN50jDA1ayC+x
	 lAB0zpd1/25JPHiic18kb4de5VqJj2d/8ZVd2iGTmcBCO7AAffDiX/qtLdJKMtIyie
	 QEFPHkmb9xUbvW9LQ8iV9Hopb9TWdwnvHWgvZGK1dcjwIBjY6hCa89EMmbPlUTcYJC
	 XgrCVknyiy8fhw8Y6GuxK93APqSnSTwJSMJsUQZj9KxDqiMqtrYLCz/MMH9Be/SOA6
	 PEhedo1UJnFkA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFF0CD343F;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:45 -0700
Subject: [PATCH v3 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-6-e14b302477f8@google.com>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
In-Reply-To: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=10377;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Rm+Th8lyn4N0VMVm3x2XIXppuej/2vu+OQYaa8lCewA=;
 b=y6o3OBX386APgcc0m2g7ZJsWrHXUNu6KGXPM0gA4cXK8pSE2pB9R+d+OoAfGl2fStV8hvVFTI
 nI3r4KVxx/mDHvHL5ItCeqgiwEdJpbJJJwg6p6VZpBHT3nLu5QeiwDv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD56A1A0009
X-Stat-Signature: 4zrhfdp8zup6duexfgd9dcmk65iepr47
X-HE-Tag: 1779149992-120845
X-HE-Meta: U2FsdGVkX1/Ao6hiNk7vILtWwLyg65/yzXbK689I6aZBBQYG4I+p904WwwM5BrOEhQRr5PVKat+AP+9jWGcqN3F2u6OI3ejaOP+Hqk5VO//a0RzhnFrzSK9Y/+b+pYyYQSKAtvEoL8RV+MgyDIC40wmaBW6v+wnJbLo1r37A8cDTzXzKm0RJGcnKT0f1ueB8ntjonO6bQzl2avlLo+N/2/XhTB1cIMHNxaFCPQhkvtgwkEaTYmivgWIIrO7lTf6O2OH7abunCWyH1ZPivgz4yMVgOOWrX9py8In1zPiSzfO+XucsWT0vVMe0b9Fb2YERX20G1qsSnIB1/fhBPATMBZK3zeCsaKPQlHTwEOH3QE70sxBGuk9OsVpgdogAswKMSwu9CJUwzXFwk0knRfYFNfnHvRAzaDLWUankj7UBYNuY7W88fVjHVKKDTvvYSAxgfYQ19yvMH+oAW4wbdr/ntyqoWEvVkc1UcB4FChH6OftcQkz79hJJPZG82ww7zV+Kv9oCW9HD3sHnh/vgnlw6t1TuR6op+nZsy5/1HHL5zEXDGr9LsJkEk83113MUmRAQt4o5YyvsNO2QOnlrySyhxr1jgil9H5rLggYzx97NoraRMiXoPj27Ua1bANkKwK9I2h1d5APPZ/Jgmj/CnQ7b6YzYqBbCNK6OCVDgAMBifRTmrYRrG0o+6z79Yotju0yIxmx1U10gKkgeNgPgtqc39VTbTKpLqjCmxBB6EJwROKgRZxZ9aEdm4O36wUb+QMBlpBe9bZi8XvQfGsbtnphwPtKEN+JHNGvnx2sp3JtMi6XvbxQP4x4xfFsNfprXSaFGK1/j/VO2rRDGeufTHjFiH1yzlqelGWKxAsd/cUItKskP1NRPJlNiY/xoF/q7OmS0LY2UffIy+eXzVMKpmt8pXtpf7iKq/VfgH31T0E9QAq+juZCkcPhFfP+wQYvlMfbw/sP1wb2bHMdtwiKnKi/
 LLRhiZ57
 k9rO4cJvTJmDG7KZQTQnQebhAz8kGt+HbK5K/RofMYYX4he8MQGbInhJD976tmzPhI8PKycJuRSfgPFdrJu9ebH0k8giH5Rp0W0fXXCxYrQkzT0KljXcVEJY/GsHWN47iHgkbJ59wfiXs4rsGNrOKvGRVT4CzKJ290cDLzcCog/6J0SFhJQ5GMzwAADoG0E9RPClvsceXvCi2U7VQz+MbP2EHVlPrNPLJREHDNATBlg1FsQZpNImrjR/3Eq8+PUuKwmL2BGyg7j+Y9YBaUxqC+v5JFdgPThiwV99SPXM6V8LSRekuAUf7XifEIdC1tdvVHbxA1rn+zVUiuG8MftBHz9z+Vv8i91fdPCEJJjm1r8n5jmHbPaGGxhBTnlUmSRZKdhDZWyvwdy+1yX/3ZrlOsY21bLYzL0A35mER/kZ6kbKLIQeMmT0GQXirXkI9DlbX6cSDLFEowhkurx8pp4CAtEZCx5dN3VGu6zTBvfI2AyaRX8QLZ8FMf8L0yk71uCEGOrvud0tXGJZZxyZjxgc+lSCveaazgzpk5o15
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
 include/linux/hugetlb.h |  19 +++++
 mm/hugetlb.c            | 188 +++++++++++++++++++++++++-----------------------
 2 files changed, 117 insertions(+), 90 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5f..9a0222851573d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_HUGETLB_H
 #define _LINUX_HUGETLB_H
 
+#include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
@@ -705,6 +706,24 @@ bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
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
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
+		gfp_t gfp, struct mempolicy_interpreted *mpoli,
+		u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 81e73186dff09..abce2ca76fb9c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1334,12 +1334,6 @@ static unsigned long available_huge_pages(struct hstate *h)
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
@@ -2829,6 +2823,90 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
+		gfp_t gfp, struct mempolicy_interpreted *mpoli,
+		u8 alloc_flags)
+{
+	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
+					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
+	bool use_global_reservation = alloc_flags &
+				      HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
+	size_t nr_pages = pages_per_huge_page(h);
+	struct hugetlb_cgroup *h_cg = NULL;
+	int idx = hstate_index(h);
+	struct folio *folio;
+	int ret;
+
+	if (charge_hugetlb_cgroup_rsvd &&
+	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg))
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
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
+
+	if (charge_hugetlb_cgroup_rsvd) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
+						  h_cg, folio);
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
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
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
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg);
+
+	return ERR_PTR(ret);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
@@ -2864,11 +2942,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
 	int ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
+	u8 alloc_flags = 0;
 	int nid;
 
 	idx = hstate_index(h);
@@ -2916,23 +2994,18 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	}
 
 	/*
-	 * If this allocation is not consuming a per-vma reservation,
-	 * charge the hugetlb cgroup now.
+	 * If allocation doesn't reuse a reservation in the resv_map,
+	 * charge for the reservation.
 	 */
-	if (map_chg) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
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
@@ -2942,70 +3015,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
-		mpol_cond_put(mpol);
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
+	folio = hugetlb_alloc_folio(h, spool, gfp, &mpoli, alloc_flags);
 
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
-						  h_cg, folio);
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
 
@@ -3038,12 +3053,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	return folio;
 
-out_uncharge_cgroup:
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (map_chg)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
@@ -3054,7 +3063,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
-
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);

-- 
2.54.0.563.g4f69b47b94-goog



