Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF58C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0466B0092; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3530E6B0098; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F36C6B009B; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4AD06B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D3B11C32CA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:57 +0000 (UTC)
X-FDA: 84967010394.10.F922526
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E1DA40004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktXBXh0g;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3GScABCrbR7JFdER6GVLwwEq+tars6DKR69wq3XeV4=;
	b=RzDlTcGndd/qsQlIRfUV8a6n8wzsDbDHwko14ntmdFTmm4aPc6Uu3jrKOJpX+ZAJ2IkQds
	vsadr0szF2X5AQKPEPm8SuxW+ns9Ym/KlDjL3IpWrabnz//9cQGr59K1/UWbejdRthDbjU
	xs4r90CIsu90pipZFST0Vn3fbTlYRmQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548775;
	b=EUffejtJJrWdCaOfSst/0MTbAonzVMUJh9kzyE+TBVnyLW/4rf6k6zWaQmLf15XVocYvUi
	FGKLvEQujuQvj5KDB9g5I1S2vNl2J7zI24T+GjGkCpzlEWuLkRtjoNpnTt3nzZZYovKCjp
	gMA2/q+/M0cFG7kDt4c1QW+fDg9fHfY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ktXBXh0g;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32B0143D2F;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1748AC2BCFC;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548774;
	bh=AkD3Vk4B07kPFDKXwHOUP1icWldJ4DzrSHE+2Ogit/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ktXBXh0gg83rtUpyKeXx9mhQdiyYqSz6tJeiXLUCum96riA/ZNra5XlFpqJxaKmYK
	 6meg0aIDbU9cxnh+Meww9xzd6k388a4T0Ttgl1doB9b7uy0mOB3J8alM/BbJGgvB+Z
	 mTJz58DZgOiQstziNPPdo3lDJHzv7Q4eN4p0BdORDfj4H5PcOtUltPsCDMYZ8MBUqY
	 OdluOvRKOg10DD1ll4sN05Ao7cXRxqz/ytgtJxTVEW52772mbjyytdD56uvUvC3GBo
	 68uKrBD011EjRUt4XovUsJkg/Y9xms2g51EzUHQ+l2gRrCOThtiVJKfGZzaVao9bLh
	 iUAfikyoSV8Vw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06639C43458;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 08 Jul 2026 15:12:53 -0700
Subject: [PATCH v2 5/5] mm: hugetlb: Move memcg charge earlier to prevent
 reservation leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-5-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=2730;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=aDc4LeCjf9Msx78DCPQ6R0pVUvWtCQbT0+pt5lURw5A=;
 b=C/Vy+QfzINHzFrWHsVd2Hc4hHJO95u4DUt+Y/R5xhEOPitzw3jg3OzKoQPYxnnBqtqUyIy91U
 VA+6kJWQ3QyDecXnoBFpg9D6y68TwiYF811Q3SspObCEMxjI1Nd5bFn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E1DA40004
X-Stat-Signature: 43rwjcj883j9nrjxqct9udy8ogno1co1
X-HE-Tag: 1783548775-134854
X-HE-Meta: U2FsdGVkX19EDKgGnjJ/nHw0XbJSnFsWI4xcb+buK9iK0IhhfhAVHtDd3SQV7R+iHjQBKx5Ff/tYzU/AtwgY7O/dkOD2Bhr7E73Eu/HMxd6BT9o9EdqUNzhxmMCH19eROY6unAOBoRSY8Fs86++tl5QFZ49f5wRvYD4Tlbj1WJeyAidA94mHJvSxyBp04VpWS9vnqQFRM4R5SI6sFfrMVRwwc0FZjhLRJEjvrNaVgxB12y7sejSI8vDOo68uUxAFy4DIjx3by7yLLYadHp07eHbQnGLv7w5/ewAw6DboyRwtm2O19EgVpk+lsD9AlDKDH2cReXq2G/XrEe0RhcrJ5rYcmPLTot4woVUVxhFlTAJlcnRFwjdJnMXTZntMO3IDVZ8TS1Yg+gRq29Tmu3xA6kpQkR/8lsrR2IJHg2GRtr6zaGgJzddKyHZ6iYKbRiaJsSUL76ukYhkUFMDnc1qp1i1hpd5osZ4Y+rVgsWkVTAhJWDoodIVNJohCjzF3hr/4wLEEng1Yj6bKAyY3wQbee9Hkw+oeUxxhw60Mqls0RGU4iVcVaBNE0YUVZevT3NotB1yALMP6hhAb6Ynbf5haPN0B57LxJ+7a1dBk38J8vPjeoRNbTUBblnVtON4fwW7yI9aMyfUFkzpJTv6ZmYMZZByiPJvXdtJrZ8bXDAI6qWiQvdfNpusoEpyoDo3/3VhQFEbumOPuOi5LXEBLZy5HNJKsHZsF3i/pbzNKHjIWidDxCaa9kfv9ZIl7gbC6BdVDywap8C1UC9uziSpKjL64FPKQiX/VcFCqcLpaIij2ujF61U2cf5oKDF7t6uOo9wCWxyvnrH4KkgIpFPT+3gTB10BaBvw/d/X+SsHVNG+P3PRDkoRoLt87F2sApzjHO9wQGv2QiD/qZn8qVE9lEldtbe6UKXyBZe18i3qrmgXOxZiB6ZmMG7GqWpsRuJwLnTn5yljFJKL7meir55z/rDW
 qhVMXmdJ
 f30Rfab2dsOaMpyVBLnmrmWtMhqSz9aWJ31oEEl7bz7EQ8/GwXKhyBpPvVxvugSM5vjL/fhrun8UxNnLdq716yJY+BhG/cxQyoQHNTrsiqSnqbZIjCc1LHESdk1s+t+yxlzmm9SLAfB9sM11PyMkh3ITLaau771pQPNNM/Ck62bAqNhlLGcgBsHMRxgJoeruF2sD4sXq3Bgjn/nPgmlA4yl1ftuE+dFlM+xKLOpILl//bfeAV8cXzff8X3jpisn58q9s1VFKtwEmtd+XKg3HnNZ7LcGxU1BEeLs+nv/nPpPCriGialPXd5wkd2h6FwKAxK0tlfjrEOkwT89dmmOboZXuQlUZsW3SaM0KH+jB3QFxW59slVNQKbMMmQgKWGmhlGOMEiMf4wBkexoYUBYU2IShiHOeGADNsozv2oTt9BCVn3/kmJrP+DXH9ksPO6pxbG314KXb9HdD4LpOTxfzfrLPLXrNwllLinpNT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails, alloc_hugetlb_folio() clears the
charges and frees the folio. The reservation committed via
vma_commit_reservation() was not undone, leaving the reservation map in an
inconsistent state, causing resv_huge_pages to leak when the process
exited.

Fix this by moving the mem_cgroup_charge_hugetlb() call earlier in
alloc_hugetlb_folio(), before vma_commit_reservation() is called.

If the charge fails now, the reservation is not yet committed. Jump to
out_subpool_put, which will then call vma_end_reservation() to abort the
reservation and keep the reservation map and resv_huge_pages counter
consistent.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3e1d99f03c70e..e000af6f28585 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2954,6 +2954,25 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		folio_put(folio);
+		/*
+		 * Charges to hugetlb_cgroup for usage and
+		 * reservations were already committed, so folio_put()
+		 * would have uncharged those. Go straight to undoing
+		 * subpool charges.
+		 */
+		goto out_subpool_put;
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -2981,19 +3000,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
-		folio_put(folio);
-		goto err;
-	}
-
 	return folio;
 
 out_uncharge_cgroup:
@@ -3014,7 +3020,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-err:
+
 	/*
 	 * Return -ENOSPC when this function fails to allocate or
 	 * charge a huge page. If a standard (PAGE_SIZE) page

-- 
2.55.0.795.g602f6c329a-goog



