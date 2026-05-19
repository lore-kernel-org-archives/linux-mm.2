Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B568CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821296B00A2; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E726B0096; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C296B009D; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E18816B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F4A0400B8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:52 +0000 (UTC)
X-FDA: 84782261424.24.ED8E496
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80126A0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrlmsOvl;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhU+tOA2VMpQw+72pE7CPBvZT2d9lV0RBRBhekKo8aM=;
	b=QBS8/f2HX/y+dtIeXXvFfUBNu5t9hDc0xd5q4aVOoq+k44SYFmvijdHxHPLTW3Bh3EFPu2
	+WN51cknscxUN5tY+39mvlvD0nR7Lbg7d8aepZcYQECpheX9fP5PIoHzZyqkqO/Yu7T4ub
	KZRir/tHMKLdOj8snk4knwy3dWDwATU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrlmsOvl;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149990; a=rsa-sha256;
	cv=none;
	b=Eb1lBvEPgbESzz/elBXp+/g5wDahjo263yLvH/JYfFIHZrm+vwazFs9+cN8t4knOaQCMi9
	bcudLsgYldHTkJuoBtFKmRZvpThLHDyKb4XOSOkR2ryGBWvcM+CkZisdEjkWaNWxsXc3tr
	BpXPoLkb6XwI0d4DDYghdjA4RabXtZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5677544521;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31ABFC2BCF7;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=ADZ2XOBOHQDWc7jjdUHTLF/VJ0O9HDOTr3qobMe2dh4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GrlmsOvlcXlX50eqKeBJtRqX8nJkcoAgQHucGYdw8yPaMb6jFucryTNvKAIWLE7HX
	 P+smS5nif/3oBLS+HNNjo6D0GnN2z3K8hShSg+wnIAyUcY/iWthYtnA2xnlCaBOea9
	 wVR00+ybGumGe83mF27/Iq1Pacmaqx7x7TKFA5fO/BOvpAue6x06D6Tu2tZ60NN1rd
	 1+okBrB22/7z88sJch4TWl8pnXOFy24MdZD4dDYCb4j24MUFRfPmvkdbcE6r0eFpDf
	 yI6Afg4Wz5THRNF1Y1fuc51KohhszEbwE0PGiEt3WYNj5HLyathudGBSmRMVMgZqj/
	 d+bs7yA0KGMMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC8DCD4F4A;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:41 -0700
Subject: [PATCH v3 2/6] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-2-e14b302477f8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=4657;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tD7lNPr5Joukm7mZDeaHgQAhJLEw2bXVLa7MLfuBvEM=;
 b=+LySESN/X13IMDWPIx+4vGv56FS9Ee4/FyVcwQEipOHfVF27nIF/LxESvqaveWWLkE45UaMt/
 vbkI70tcrkaCNtpnsPRp7fpNkAFz0egcOdIsdTRnIjSTJbyqCickbv+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80126A0004
X-Stat-Signature: koetjgrtdtya19zkdy6m3nima8afygbq
X-HE-Tag: 1779149990-106767
X-HE-Meta: U2FsdGVkX1+JNqfWBmrS+qTQuj2aINO6J40MMMgO+sK+0CB/zFWREClG2ybekEbKpXDI8aalzBybUa2BpP8IYztjKuHaHWT0zZtJeGVYWDmue1pPapuakuBzKJlC7C7XQFsj67sqMPJ60lQhfpKvrUR4OrvlDHhVAMJYlvRiJoZveTMY2hl6Gc2u/qBQZrP6j8BL8YR7bVsAFC3oaSenKekQkFMga6yiGfAZnsliAgb0pEIYYWt1UhqU5r0ap43bvoCMW5KkfutdKa+WED4MMo9xcqJgymI82GHACDeHvnnFsybm7iXMuMc16Ro4dT/nzquEyCWZj24yysLEuxL10Jvp2vGPOWXiF9zM6ThlifwsDL1PKc6gFWimifyJ9PoFEtyiJK2X9lso70OWizsdZoTa/I6IUu3v5l1alNZLeP044haOfvZBbGTHEkclKwbKXwxdqz2JfJmGgyEvkieVTKpqxSv75oTREBydGr25Nx02IzflfpnCLR9IURSKi02XScGfFzp5srpNoMhFrzLW/xe9QnRCLUzPrFunrgHXC/xDpHET602AxJsjjM0ML8v+5RrINr2+Xw8Kd58hV9qasPCWL4jpHugjAUEtLJPUvg5Y1k0p81e4vbgysXUzZ74qDYLE0gn59SRJx8Nobsv1fAQEeNh+sPTYFS4L798OFibUKezlQmZBw128CVhMoY+v15TQCEQJ9f+bwEE9e0OPr3LWuMESq1lKmOtemBjyEyx+qYeh1eKglEWx9ppSf9y5HYjG31Cnjbk1AFReCPdwuwxC6B+KYD0rm5Y31XUkV4yg4UOKN25/dy9PdOQdwq10lX1dOEzkiriqvIk+euv4bKZZZoyGga/cfvSCISi4Xe30Ozg8P9zmG/V9nG17bG6EVkGaMFJo5G0JoHZSrHgJ12HCljKAnFWcJSggrAmtVpjhO5NugevXTmy8UXpHptvKA+hhxfl3fj5ADpvUWGI
 pvsAKS9V
 iYfuhVmQGHGQxTHjsxNrCeZNMkW7gqslBdDGIcX5v2bz+sNo1XGrQhMHEkZw2W1GlMRi9CfiHXIrYIIT9/7aHUkB6kqPcaDmWFu8Vio/r15cSUE4CPWkrlMWFEuCs5UDIMvo7GoZ87gvAqr2mu03IujAaDIF8jYNVu5jr2yrWeGvAMv2fVwkXy+ZXPmv59JOWi+kkx2YOFE+jngcnRY6o5+59I9OEVht11axbXEk6Km/j1v6hoRb7FpOh9zvra1nw6eKyqKjowjK/9XdJ/Ql7+RaMW/UTyR+ybQOAVRlUveFJhIBtGJLdydTygeUdcx32L9uqlz+Hn05Lols//nzeoPR2UYTE63GZ0UpSlpoJC9btx+96GubXkcUYYz7UtyRq4G0IXVOS0Y1uwUea3Uzf2SpHJwlg8rbdnHGfUGmIzjlA4wfuF3uC4Lq7Q3XRnKaMb5hx8gZkZ0B+XHpX06y0UMkzbY+kr+GUgX7Ybf6Du7KdvuRKzv60XuElnMbGtaGV7I7ZYFuQjpgRgCFFoXO9OgNDxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move memory policy interpretation out of
alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
separate reading and interpretation of memory policy from actual
allocation.

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely. This opens doors for other
callers of the HugeTLB folio allocation function, such as guest_memfd,
where memory may not always be mapped and hence may not have an associated
vma.

Introduce struct mempolicy_interpreted to hold all the components of an
interpreted memory policy.

Rename alloc_buddy_hugetlb_folio_with_mpol() to alloc_buddy_hugetlb_folio()
since the function no longer interprets memory policy.

No functional change intended.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/mempolicy.h |  2 +-
 mm/hugetlb.c                   | 50 +++++++++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 6c962d866e864..7f6fc9599693b 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -16,7 +16,7 @@
  */
 
 /* Policies */
-enum {
+enum mempolicy_mode {
 	MPOL_DEFAULT,
 	MPOL_PREFERRED,
 	MPOL_BIND,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 190ab539a97d4..6a5f69b3b1cb4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1334,6 +1334,12 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
+struct mempolicy_interpreted {
+	int nid;
+	nodemask_t *nodemask;
+	enum mempolicy_mode mode;
+};
+
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address)
@@ -2155,32 +2161,28 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	return folio;
 }
 
-/*
- * Use the VMA's mpolicy to allocate a huge page from the buddy.
- */
 static
-struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
+		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-	int nid;
-	nodemask_t *nodemask;
+	nodemask_t *nodemask = mpoli->nodemask;
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	if (mpol_is_preferred_many(mpol)) {
+	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
+						    nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!folio)
-		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
-	mpol_cond_put(mpol);
+	if (!folio) {
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
+						    nodemask);
+	}
+
 	return folio;
 }
 
@@ -2869,7 +2871,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp = htlb_alloc_mask(h);
 
 	idx = hstate_index(h);
 
@@ -2941,8 +2943,20 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
 
 	if (!folio) {
+		struct mempolicy_interpreted mpoli;
+		struct mempolicy *mpol;
+		nodemask_t *nodemask;
+		int nid;
+
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+		mpoli = (struct mempolicy_interpreted){
+			.nid = nid,
+			.mode = mpol->mode,
+			.nodemask = nodemask,
+		};
+		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
+		mpol_cond_put(mpol);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
@@ -2998,7 +3012,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and

-- 
2.54.0.563.g4f69b47b94-goog



