Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBCA6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575DA6B00F9; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5289A6B00FE; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB626B00F9; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABDBB6B00FB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64CCA140117
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:55 +0000 (UTC)
X-FDA: 84944352990.21.57ADD24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68191180017
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNluEhtJ;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009313;
	b=u8SfBdeC+9WFqlX5NEqw+Xg/Swz7Pjz9rVxrAXMlSaV3zCAkjRkAVSDrgR+o0/2/AMx/dB
	NtYCsfm3+fEtTmcHzyKJPFnQ3FnlN20CbJKwdk9Nf8WKYLPcdjNlI3wDf/Uzjmgah2Z9bB
	iCA/4zDTV4mvW8T7q2AeRmYrz3IzRjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zc/wt+ppUBqNsAjCs7VCaZhXJSEQ95dh4ph/SRpKWi0=;
	b=ATq/TZwRkHgfIaDI+sIpzIqojp9n29TPjRyQuBxl76EO9ySGM6lczKvni/r5AK9pympieE
	szrJBtPfuFeEKXLsOMmzyNP0ahJ5bFokMhSB/peh8QirS1KwH6UaYDqpAyFw5lv2AZM+jH
	AfbPEk8gG/9eR71QKpijAktcz8oLvCo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNluEhtJ;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F0BC601FC;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D53A3C2BCFC;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=dRkOq8wLX8Ak0u/ptqY8S0iycVqsifoHeK/fBQCsE8k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NNluEhtJPCefQAXIJyCPMWLoyypB4B0gtnMtDCdjTPHPDN7Tfin5/s+0oOAj7lP30
	 l3h5oBdmSQ8m0bwGHbQT/OwMyFkTVKzOyvxGrH6A+2TebCM9Sk0+TaaeJRsJ2h0h7E
	 fbcKhgo870uqW4JzI+zYgkQh8OFr7oI4k5iUOXU8A75hr35bVubRwGbnPj79XzpaRk
	 v5Mx0JAUtdZ9KXvyXzgCt0uhg5R9VAUG1V2o7FpANMNIL5AW1Rz8zi4gWEtgkZfz/6
	 ps4DFroogtyCcWhfTPFy6J39KAMnLgysMn5F9YPnl47seQ2rtnPdpulGNvS0nLf+lw
	 KfA2/hTLM/YbA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC578C44502;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:48 -0700
Subject: [PATCH v4 4/6] mm: hugetlb: Use error variable in
 alloc_hugetlb_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-4-d53cefcccf34@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009310; l=2171;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VvHT9yoH0SmYFM4esBdOfTCBwyHQpet20KtQgj6ZI5Q=;
 b=Si1+yP1dYK4QxTqDyQ34h9O/6Et6U0datHSz68fprIWZU/TFfSmNvOQc/J15AIjbHdBuTz9SW
 sI/IJEyuvfRCgjTVeIxo03PtWf9YcwshIpEBEH5WM4YIW15X1iK3lui
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68191180017
X-Rspam-User: 
X-Stat-Signature: sgrtf81up8xargpukh9y3bkg6caejnp6
X-HE-Tag: 1783009313-298733
X-HE-Meta: U2FsdGVkX1/kQwCnQIoayXo1Op5H/GdPavqvdN1ZSgcDgSFTKlunyNY5I+3glenkprv6pp1Vo7aTphbpKGTyKhXfcqM2i+vS2oa5+jhrBbcPMPBdiaZkg3OhnxorbpcMbEeRYg1fYdGh1sg+Zgc/doFtvKCstApjGt7R+lZe6yMk/SmtBaXt3yBJfUne2z4kJj2mDDS+ENH/Cd78PNlx23F6tzgHq1RUDBjJNQvZg9YPJQLFIwO0A+56FFIiyv/xtMfoufDJh/NMV6eOzvBnh33HSPNGTz7z0b0AWS3SEo82GfEDYAPa2dQQvfbohwTaBX55I+YsENtKtvcjeutKkq0pDID5OSJd0DeuuIW8aszYVhGMjKAU00iE8J4/nC7Piooa1Wbc6/L3wAvdmx3CCqYZC0QREXssPkx2lefLg8l9dMA1z7rHBoFppWBcr5LaRkgkj9Z/tkS+KSNsydz+8PD9WINcATEjF6IomqFgFR0LoBDQfVSUD8G5VWJyJVWBsMqV32TyUERr1qn4hMpX9uyv+BxJwDdv6+Pda6vI936judPrYv3JYTrBLIKSsXGSl/rT14X3RC0Z2Y5AnT7iX/M7QIjBgCkOxoyKKYJ1r7SKdVuu9rv6ANzOv7CyK+dvgREnsopC5g7/aBeznL7tnqVEmmrbWBbWNOVobJL3hHCG1QvWMQpJQJmR+B9RdXPCAYMwDPp7uiUDl6dM9JMwtSZL54bc0+Ihmz8sc+gfu+bJmyIbymxsvuFLzubxPVhY42zUxlWQc+9HO1LxeaaiqYHVigMladOBH7G6a3N7IsCAWj0yoyt/+D1iwyYsMfYM0P/cyQv/AIqrULs3jJ/EGZmioBbBKZMZq/aY3MysiyyulltoRR+JwqkPG9sUlf2JnkWShfKh6qFd+WtW1r8uelMYTOl020DqGYID2Bi+Z3FJRGnFiIk82HQwVx5jZc85deBn+wspUXkuxqMuTCB
 HFFy2ZG4
 9GRj25BIFzv1RIbE6twnlDx0PvOcqqBqX51Zo4O09eMaFY/SbfjbsLmCqOD7A7XMJK9RcxbsCgcwqVuSPHi0f2Qad6MmRBlQ3oTG56nW1afvlqqaBY2r/KW0JP5cke3NUkrI2HyQygfh92I7RZKL7KdjSH9n43PDVG1k7phRB1lRjawEFpor7K9NiMNEw8hVG0pE0mp6xkyMqaODlbtCv8XZMSdt0iZVouRaaal6Jj0MnzpmWuTtkJJ1SZC/ASKBzZ3+yruvLatwpWyhQCklc6uzy5au7FQhjR7a81J/sWm7OGwv2n39sPiUoxgTXN4Yw7rle3pWlwfYnlPMzwMnJEi9e8HQB0BxyPfI7pcN2lt4ZEkVUCjCgONb81BmdW+yXgSkRmj3JEtGuo65mk7/RLbossHYVEypgJHRA5TyqNUolefJsqRevdYvsmYgQBwPlRVgObdDfcimHrnQDazmNoZtaHl9k8dr581fT1y27dq+0Lwaovkk8VAJq6v2O5x5wfC+ocLcF4vSaxZ5EByI3L5a7y6Q2EnBj8EM7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor alloc_hugetlb_folio to use a local variable for returning error
codes. Instead of returning ERR_PTR(-ENOSPC) at the end of the error
path, assign -ENOSPC to a return variable at each failure point and
return that variable at the end.

This allows the cleanup goto targets to be used with other errors in a
later patch.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f595ab15f9fcb..176b7e9130a38 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2887,8 +2887,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		if (gbl_chg < 0) {
+			ret = -ENOSPC;
 			goto out_end_reservation;
+		}
 	} else {
 		/*
 		 * If we have the vma reservation ready, no need for extra
@@ -2904,13 +2906,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg_rsvd);
-		if (ret)
+		if (ret) {
+			ret = -ENOSPC;
 			goto out_subpool_put;
+		}
 	}
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret)
+	if (ret) {
+		ret = -ENOSPC;
 		goto out_uncharge_cgroup_reservation;
+	}
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
@@ -2941,6 +2947,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
 		if (!folio) {
 			mpol_cond_put(mpol);
+			ret = -ENOSPC;
 			goto out_uncharge_cgroup;
 		}
 		spin_lock_irq(&hugetlb_lock);
@@ -3033,7 +3040,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(ret);
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)

-- 
2.55.0.rc0.799.gd6f94ed593-goog



