Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91BDCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB96D6B0098; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4626B009D; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1A36B0098; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD0A6B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25CC1160130
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:53 +0000 (UTC)
X-FDA: 84782261466.17.72C417F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1CEA1100003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6C6ODg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149991;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojzIPtIn7BvSicfxeh/lGRDL3I9UjWlPlGOlPoyqU2s=;
	b=TABqdwZj8164wyIf7CBnZlcgI+/ZpgC2AEkLCdWl2/EpkAOLIiM/BKvjrQml0N//kGCvDQ
	iqwj1sCsV7NS+gBmPO52JtWgNfxjhb9ovk2gZwKtEA3caq09SPDvQG0AKdatJMiMPI8JSz
	Dg+SodQnuvFksjFKv+rqwcfF/TWMkDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149991; a=rsa-sha256;
	cv=none;
	b=slp5ilxIcIo4D9QHo+nRquTi9LjPqErQZokDjcuIUg4kzATit+6cMdr0e1YLwjd4mdlbjL
	Ei5k3rTrcbgztaxKLJKI7DvJ2SwUof6DWThng2tuyX5RczqL9TEV83Q68RtkSYvOV1Lo7M
	/fena4vagtEIQSL4+8Yim1OYqFeoib4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6C6ODg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D3804455E;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 598BAC2BCFB;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=4pRcmdoszQb1kW+RAvRDYtLTa/5NT++4GEUmZxA+3co=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=a6C6ODg25asan6i8laEWhVV95H1HYC5NafWQrytlq4++06Nf+W3LzmyvwxuCKTTxX
	 uI0Nt874Zxp0C3Vhswe9ewi39wDzTPzhQnZGLp6/bulUMoLVPa3pJ4/4NFf8xxMxjU
	 saw6LbcaDsi9yt7DjqJ3Fpab2/41VskhWHxMRe4WOJOhrwMmGn0BEWc/vYZNWLOuLy
	 7tWtw8tnWDw0sU3lTWpSJenxsWjc1LrcqaUzrUvuiF6DyMJnU5THOJ3bx2SNe/w2SA
	 AfpfKGKWI0+OdWeToOvOtA/mm7jJMXOBUo8oEEb/0Jjov9YhhOnSMn/u5zv2cWkyD3
	 9jgYyg7SWPC5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C132CD4F58;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:43 -0700
Subject: [PATCH v3 4/6] mm: hugetlb: Use error variable in
 alloc_hugetlb_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-4-e14b302477f8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=2132;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0XVqHZOzRz+o5ty9A92C0Mk3eHhDCZNGyrqA29XGPQE=;
 b=aFCnv6H1zaN1sS3mad+QbIK71b5juUR1G+mlB4WyY2Y3mw9BwW1DP63mKit/pyTTPVbAf0h5d
 +889JUL5xDMDkN8PQ3bi9eyZygo2V5kuVz1Cd97ELKEDT2+VXxoiWEB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CEA1100003
X-Stat-Signature: gixky8putsejj8mqspachwjtegfnxquc
X-Rspam-User: 
X-HE-Tag: 1779149990-802237
X-HE-Meta: U2FsdGVkX18CT8ZNf3XVPeGFuIhBwyKWITxJprbpPX6eLzXVfZ7Su9Fd5ZQivn2n4RLkbfgk/cY4SUfsqnI8A30gvRDEnvHifPOkqBtcoND6JEf4dMZyKDlmD9XPbETgQqjZY+BmWfE/WEo9AU/epRJg+RgQswD+2qlkaLTG9OczMD+hokdEXpLghJmNkn5sRcgxfQtapPupf/Vj/FMdmoVV2HS4824oO9HRp83WkxoHhIBArXq/gEyWEHbp99OHgvN2lg6Vx3JUvKtRtVdjXjwaV4wx0PK/DU00yJN9kyDSz1Yt/8D+uhGikS+l8cpvC8KBQvFRdY6RuG2fEgIXmt8BXIPdhbbKxMrvAAAJhy77M95aRJOdLye7qHxXLviRGQaw+Joy9F5FTrm4Uhwrc0uCcDP2gNYpu4/cLK6OO+TtA0wGJJ6m8/LZ98bChjRnoR9fFKL+mbVmVSDgQYE1VR6sG6Ml3ClrViq5EsEXCg2uclvGoUYG6kIPjO8UfGWB5viI1+8ysjH9nErqTXfdbBS+E86JPrQ5/ImWCLFrgAeRWisjrZixS6cOIUwEFGKeP198K5rIszhTJDDRLtMp31lY//Yv9qSYl4xwtnV7FSzH56QeGXETX8BaxnBytkUGMjR8lB3MiPzJkWzrdSl1P513k/hPtBAR3OMhS7Ts9kPDsPMGJqGzHsbuQazyeeYBX2WdV2IpT1PfPM1TcWTqS8CJRy5DK16PNSmJ7tui63OjnK+7Hq2rI26wJOZ7ChyLRzMiWiNDCm1kLTD/JA5e59nFj7ombmuo3ztUUsk4Ct3nzHpZYrAEHeH/bB5x+0dngTYTas4BEejMJ6NHAtpMp4NfK4w+CGwyx9+maqPQutcfCuevbpFZbf3+dpBNpaPfh3ese5WYP2DEGba+ug/QCATc5f8MZfdjZ5Z8MgX1SJX0WKbnyK5Ems5Cf0tQD3Gj7+qrciCYNpSwA3uvs0b
 D+JReeej
 i4rduz6cdeU4j766Gk7qgEhMyMqw+dErNAEzlhuoka7AVFj2hVKrxtco/p6ic+ACUrOTU8FjUYVrUT5qBiPV6nxxHxFvL8C2GInuQDt74yP/B3O4LT5/qMXPYpCUD8P4mgQksATs1JRg28mVnJVvz/KHvtA9GxdbZZAFlJ9nzNTfxuFnO60Jxj+AkqwMwc7JGXtByF+FfyMvkKj5Zn/eRMylgwYuRJazEaZmBeOFHFiM9GciyiU8YAwH+YTK6FN7B/iTcg2jfKDDVhS/y4zHxZCPtQH5NAWnDsZb/ATPfJL8HFovAI/RL6ylEcjZnPRCRgo4uB7ZDFZZDULT4pw/t+kFpVD2UC80d1mqoNzmwgaYnBsIG6jq/Ax0M/E7EyY4D3m7RZneE/lTdKCExnI1SXrA5sucZjt7vfUclF5qJX3VvqR2dtzW9xR9jaQQSBj4TlookJpDWFvH/I8hHwq/XX6hc6u36CD2YQM7U+IGimfSQe0vkW6sAA+qc0DJGX/AdVhwvmvyyQ4ovPQ7xkLP4Fx33/Q==
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
index 9807bbe0d70df..ad07e72d6fac3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2903,8 +2903,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -2920,13 +2922,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
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
@@ -2954,6 +2960,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		mpol_cond_put(mpol);
 		if (!folio) {
 			mpol_cond_put(mpol);
+			ret = -ENOSPC;
 			goto out_uncharge_cgroup;
 		}
 		spin_lock_irq(&hugetlb_lock);
@@ -3046,7 +3053,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(ret);
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)

-- 
2.54.0.563.g4f69b47b94-goog



