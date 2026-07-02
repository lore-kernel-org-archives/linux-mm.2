Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF4EC43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11106B00F1; Thu,  2 Jul 2026 20:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8886B00F4; Thu,  2 Jul 2026 20:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8804F6B00F5; Thu,  2 Jul 2026 20:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C03076B00F1
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF2CBA0169
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:54 +0000 (UTC)
X-FDA: 84944352948.19.CA544B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE5CA140007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ti7Mz9Ya;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009312;
	b=w0aeInzwuGyq63eW5NhJ9uYuLnHB+4RS6Z4zl5mmFo2V26WV/HtnQwpNjBqhKuuJGD5Jt7
	50SQ+SWo2x/ZoG55VAcgUNWfggPEn+ekmvcfIfIgQmkncc9nKJTmF1XNtLXv8P34VgdlDt
	s6ymkPkxNtyJg2nvD68wRySWTb9PtaI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVtBCfLol16esaVuoqXmJGwoba2ru0P+nWF+jkVh9xE=;
	b=vYGYfB3Qe7AljCSaqofW24E9ko/qkc6Es2MhOMX01/nJJmI4C/WjyHCRY0wsCl7HFTC8Rn
	e/nKNW5dKH2XReDsNJhq3w60+Py3qXkK4khc2hBmsN2hN6h2Ggl4xoj1Xdhc2FTKqzSiPU
	h1qCdI9cYDui3S05tPRbhnLSlhx9Moo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ti7Mz9Ya;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D732E41B1F;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADD65C19425;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=JKUPHn+ON0y8hX9UPzvrdzLwxV2VFv9l2NWOLxBNkRA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ti7Mz9YatsyoB/gfvjWedQa+6J5Hxlyo33saBqucZRsWKEPxe/Obkk8yr5CMougc2
	 q+vcvBkvkuXdpt7B38UN2by8QBhD06XX4usJ6+7HSiHzOHvUrTiABLWZaS6I/CEcdF
	 wib+eDG1M3BtM7IQA3DtQw74K65Dkx1a8qtQpju6WRy9tiq3psx8t4khfc4l56p8PE
	 J3AEfqNhFzzs86n+ndcj8vB+mquY1+BBLuYQ5YIdMM7C5o+HPj5FXCsn6xN0I3OVAe
	 Kt3t/HDvjVqDQrlijG1Zpw5OmV1hbmwVBvqQeTt8URG4h/Q3+QKehMtwbU+Bd2kA9S
	 Y28S9G2WtEiHA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C06DC43327;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:45 -0700
Subject: [PATCH v4 1/6] mm: hugetlb: Consolidate interpretation of gbl_chg
 within alloc_hugetlb_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-1-d53cefcccf34@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009310; l=2916;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PQsyOzfX9+PQ8T9PPNJLY8Z3RoFea017nxtvG/bhOlo=;
 b=ChgTU8riHdeT6cYfFiotFgy9mfljKEFS6FjcjQLNC7hLvACp4afY2rgZ8Hl8xCz1NDqa98UCH
 k1PJBMRdBDPB9lflpwkwhYymknRTs1IAbUhBpowPwAojL1qAZy4YQg5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: pmgyoj18883f9gn7mmdatdpsx9x9r8k9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AE5CA140007
X-HE-Tag: 1783009312-201318
X-HE-Meta: U2FsdGVkX19htDP+a3QVSZvmFRexjjMp00A/CsFPdJXpVH89oNwo+8wBnCZhs/v00r3nKUVoqJLan47AfcyVM0JMwNcFlQJJ4kPAI5GEdfHg7E/7QKifCyGYx/K1pLbRMvHmR8SEOdf6YowarXgQDeP1yxebmQtd9lbz6CRc9rw3xHOuayc2JMeeJlZFliH9VWkKRNSJIzI1IiKlhWKEKkDOz9K9czGM7t5Wrgydrm3otOx/1I6JCEMSbjMgWUYxC6qVwo+8ukeYOGPHpVLl2IP4Z66c+8qgxuyZvu9bLgSGsHlzZgHfnNgK/RnOEy48kNGkLAX0yDaPQBLiXtsL7S1rL2OAnmzqY+uJ2s0aFpfVGSy0DxYJm2gKSbTK0SM2MyOrdR7DjWHAALRepnsS0en4O6PIREgVmPMOnku6MqyDfTMWUxCUqStOOD8BeeU1PAyGOZbISk8j94A7Tvob8WdkKGErPvdRTcP2WapSE03CUOU1gIPDUMQXVI7EP2OTAn6eBqVAeFdGkl4PfqhUh8ocBqh4mKseDCwHQq4xA7TbXrDFT5UCNxHNJBLQzWpWHGUeru+FhWDB7ZqylHbdzvGtpU5FPI1qTTcwBDRGTROz/LEfUEfXU+ort7/2YEIq1ju/AHL0mXuKKDdifc7hFALqeHnFOIyxai2/oCFsJyQ0d84P11bF6hMaTCWk08k/Bek4f87xh4X3IKMSCaIljLUQBVyQGqotOYAB9BRFhmbAkssrTwbk6v1mnVWVR6oWxkEbIGc3xPP/GCyca1sLzw5XxcAPnNeDXm5/Vx1AliEYsU4WPU2vVOft8RUB31noE+44EiLXMwiUV15rTRkFw6aIbaLFktKo/InnqZA11kv/Ej9dmVpClGRSu9k0ieHXGTP1cOEz+Jc0/Tx+bLtna+IZp8jK9Qnc7dDi/4U/oAuf4EqpZa4ejl+24MkLhMhImmuMCmIz4jHa/lsPXml
 Dzqtrph3
 /DiQkrHxJtqOVljwr2fUojTceCK/sAZNIlwL5t8fZ+FxyfOnICMrg1PF5MtIJ6sUHzo2f6O0pVMNdFvx8ScRP5Xy0iaYNmjiiYEf+AQuekkBgsU12pI7fAsL9npwX4ihV7hMqMgHphDBj9Yiws+WS9KJc6wvtdc9LTKw/+aHx/E3ap+9xOcMYqXfuGDwXzKOFCMI4q38ihOYrK28T0o7502TY3UuyRrHWFSQiF93qWfkaNnMJnG9BP+L9xRNiadBqLN/CeWpe5AB12QLUE6tVZB+lBST+Nv2j29F8iHOtM7DXyfzzP1XmXPLm+IzB6RglIS08ml4lP92O1C4e+XcM2f0Pxc6VKegcWLrCEhs3+IpK4u3sBWeAKT4AL34UnC9FMwxRp9P2YdeqeKb+sKj2bAyDcnFoSzpdLh7GEvv6eR0EoYuAPWAfGJf43nzSuseoIdweRg4QXOW9XWsINFqTcMugA8uKncrPmZUc2ZuA9BwC64mhdYCv3PK/XuieEcs84/Xu8J4jx/oz4M6uXxwgK6AcO3qGRhuNnsxkMW4XJDArDrsoAb72pW5daA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
parameter to determine if a folio can be dequeued based on global page
availability. This leaks reservation-specific logic into the dequeueing
path.

Relocate this logic to alloc_hugetlb_folio() so that
dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
reservation exists (gbl_chg == 0) or if there are available huge pages in
the global pool.

No functional change intended.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..83ab9390db565 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1319,7 +1319,7 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long gbl_chg)
+				unsigned long address)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1327,13 +1327,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	int nid;
 
-	/*
-	 * gbl_chg==1 means the allocation requires a new page that was not
-	 * reserved before.  Making sure there's at least one free page.
-	 */
-	if (gbl_chg && !available_huge_pages(h))
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1351,9 +1344,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 	mpol_cond_put(mpol);
 	return folio;
-
-err:
-	return NULL;
 }
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
@@ -2923,12 +2913,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_uncharge_cgroup_reservation;
 
 	spin_lock_irq(&hugetlb_lock);
+
 	/*
-	 * glb_chg is passed to indicate whether or not a page must be taken
-	 * from the global free pool (global change).  gbl_chg == 0 indicates
-	 * a reservation exists for the allocation.
+	 * gbl_chg == 0 indicates a reservation exists for the
+	 * allocation, so try dequeuing a page. In case there was no
+	 * reservation, try dequeuing a page if there are available
+	 * pages in the global pool.
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = NULL;
+	if (!gbl_chg || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);

-- 
2.55.0.rc0.799.gd6f94ed593-goog



