Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BF2CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DAB38E0005; Fri, 19 Sep 2025 08:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669FD8E0001; Fri, 19 Sep 2025 08:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F158E0005; Fri, 19 Sep 2025 08:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A658E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC3E3BA931
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:49 +0000 (UTC)
X-FDA: 83905959018.02.707047A
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf02.hostedemail.com (Postfix) with ESMTP id F37808000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i jmm53x";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i/VJuaJG";
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaO9m7USZDrpygot74UDSvojuR6ldLnT3ppbJu8X6HA=;
	b=RaMuCe0zyEGESZk8GiCcbrNvVO2rXNI3lF9KCbjVhZd6ATaDvVBgOLDNMpnu4ucMLTj6xg
	W/P8t/0FlLx/NvAaxzXhGxNnSTcbC/4JOKofLVkBYl66vgaEXkO07nHl4AD4tWkxVXMM0e
	gStIybKtQeTjRQqdl2nvYYuVHqGZ7HA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i jmm53x";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i/VJuaJG";
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285648; a=rsa-sha256;
	cv=none;
	b=8I3KPU3D+PGkdZ68WlccblEeeLIvnhC+YVDqneD9Prdz4+nQcaX0pL8pK0NmaTUKWk68Ht
	hgDNDdPyWvvfUYJIsYLdffp7cgPl5ODYbI6zTlTXRESFLzmiYDpQJ4D1vNBbEUCXcNmwp5
	51LYc3VVd6IKWnFzhPvujZ6P4gkRxrA=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 5ED21EC02E4;
	Fri, 19 Sep 2025 08:40:47 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 19 Sep 2025 08:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758285647; x=
	1758372047; bh=KaO9m7USZDrpygot74UDSvojuR6ldLnT3ppbJu8X6HA=; b=i
	jmm53xzPDAUdcPUioFKoDAmGFp4tcdczwXpAyJ9iWew3LsPRnCro82mtzbqx68hz
	36Hf1upGlF8e00jOhez2AHxsaykCZXzjNFNq9XkBgWbtROd5WU2fQBl0fVBWA+0C
	VaZott2TwvoHzBMTQmbMSGDnEMFrxFEZFhHrZU765KTHMUMI0BfZo5S4RnuhQcRm
	JH0hxVhobBXhnC5jbX9pW4579cx4SeMyba4uAnWIOS3tEHLZifNnDCxLc26mDMvg
	XXiaDzyR1VRuEm9rHgriSVAp3tUrFRWQCefFUN7D7nWkb6roClcURlK53LoShdwP
	JzwZnMxZeQ/6/JnYfD99A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758285647; x=1758372047; bh=K
	aO9m7USZDrpygot74UDSvojuR6ldLnT3ppbJu8X6HA=; b=i/VJuaJGPik9isONQ
	Jrsb97nBw8WpsN2BNFsuFvX9e2k7BD0ZlYRMB/BfN5xScBHtQ6Y5OeZLsDLSyw6D
	UBzKy6GiVc1swjsVen1/3ztwzZwNqGNf4CLQShjVufqKw6lFX9iepMHurL2EH17k
	nrym6YJuL4i9cMlVai5+w7WsUBp4pEsngL0tPFCWTPJzXwTXwgB0VnB3ycZzyoSp
	ehcpM1RRXNLbg3ZNN8Zhmb5BhTOilxGS+5RjQ+Qvtb87URO2qVa+HF3qBPmzL6aM
	pNoaxj+hk1aZcg/2e+ojbPD37iRKW2Rtb+kx2D8y1g6rqvqr8Lsyy/2ohnfFqyka
	dVOGA==
X-ME-Sender: <xms:T0_NaGj-0sQ1ltiD8QHha-Y-Z16YdAd_oCQHrk_3RxPBqPvom8K4mQ>
    <xme:T0_NaIheKdnqriUKoeeabDZMbQcBNXzjgI8WKUDZA6jwWtwIo5tRpbWwQw8M-twlB
    MDYBaqpXGLz4T2R2H0>
X-ME-Received: <xmr:T0_NaLtIkdlwRu8Sgr7uK00MwWuoi8CbbAnZ-HYSChNhoXfFYGykHr9dcJud4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:T0_NaGusV20_v0lst65S5fPpr1Ez0DcA32xRKQQVv2V6Z_IKa6nffg>
    <xmx:T0_NaEMnCa0b9aVK23texrlZT0lmQsJ0jdzt8wX02K2SG5cs0OY8qQ>
    <xmx:T0_NaAcJj3xGgB-NusK7TVPOfBgz06GsiYX_hnAlyYmbCvdjjzXNbA>
    <xmx:T0_NaDm5kVFFR6W87La_OdxrczdVRb11UIKe2hQQLHb4ZzUc3TYi1Q>
    <xmx:T0_NaM1mc7qcc6OruZS35q6AnWwnm-tDrZPWmbdtAi1HfcMNPVydxFPg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:46 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 2/5] mm/rmap: Fix a mlock race condition in folio_referenced_one()
Date: Fri, 19 Sep 2025 13:40:33 +0100
Message-ID: <20250919124036.455709-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919124036.455709-1-kirill@shutemov.name>
References: <20250919124036.455709-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F37808000F
X-Stat-Signature: ctrm4f7j3ysmay4i3igqm6kupeegbg57
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758285647-935894
X-HE-Meta: U2FsdGVkX1/3WD3ahacgEtSvV+ZHw1eqCxOMSTybbGdOmMpgqdEhZXBqCrT91Ak8FQMySJRDkNq5OdxyMmVZhcynwNtQJPIsdQpGT1IQd0qm5RomI1Rn8i475M9FWClWGmVx72ER8SmEqx4W7+cf36izh8hygfHSl7Yh+49RDouXlA8/MEya6iILxskcmwh83vLpjj+7Yw/QrjKipdMMGenP3iRSlDVg2fJIG4thh4+2O2f0yLkUA2iK0DlRzI9iXukSJiruTQ7B9T8JiZ3gl0SRSTF2yYUqWuVRont/3pMr1k0wJsQFTje0AzaRDFDebcKz4gJV/hpfnMP5jdf3JXGlg7pJW0RTviMBaL0YSfu/wxklAUhIknOv/ndQBWj+fDB1ukm6yqs9XSy2MrdBZvisQQ5u2ItqixAS3gbgUIFGa/38XeZkHs81FZNabF4LCjogCBNsBC7ky5RNg8RL+Ra1Kex3EtyC60iPe+pX8M0su6GLVZUpm2Hm0PLYWh4aArIDLXblLY3WTfp1tZE+zp9dip74EmSDB3Fk6zIURMHsYcchQGlleXTrME2vpgzXKqfiB9Z4iYp8ya0xjq8Ygxwn45kZ9NB5x+wNF8wDiL+dxjgsGMbG8ELO6vzgkQtnHVf/+TMaP6iJ1H/qquICfzujvw0TDgWF/Avy0ccpq4lUUJrzgCramwt6yMDQKcKGBjPaUjgMRohyToWTio98aa+ztdP1t9ZKx9AVLfvjDVb1gup567PzwSKZeSZ3q8poiekwbYoyh+pzH/gw/e7cKuGVFdhPjq5UcusfC31letgbJMWHbKexDcpWUCe+DlZ3w+eO6/+OhQfhd8NRqzxW96p+ddXBAikVsgewKuhyCT0atJDLzNzZf8+Uqo1uLXyETJUGu5ocM+1xUQLz1rFZyHaqZ5WOg3tu/NVrIf9YIxRv4SDuGb77yhsDUBxKy1yGA5qI5eBXCN1c5zWA59z
 w9/Gl19s
 UgV7fGqsuEoaxlxGD+hp2PUtCA2de9f9qFO2+q+mDv66vKc/GsRhU39Ub+qK5DEXBxJFGGLHGgSeeyd++NH4Ih2QnDqWxZj50ltRQtxrLepT6n7UeY8I6HfijJF+wZeeRlJ0RJvDWsGg6Yvc2bAerIYDB/rfBBy2pNxJFZ7Lj4kRcxDaWCmheaDf/LNxuZt7bT6dedYchay18k4dFR+ccShswXd0g6gs4WnLeWwPU5EcjWJk1h2adVx6MsfW+Ms2WuT9jOmUn4NKPmhCQGlDUPyhWa1Ic5vdLd8s8XeKmjfvwq0UJrp8hTgvDrWIZ3XoW/AaTdOZZGkh6kORbrVIrYhiFC4xrtOrofvn9N0kWUVZv6ygnEgELGUs632KT5eMBgBJI1SnQAP1FmsPdzzfQh/peRdDF8SGWbN0+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The mlock_vma_folio() function requires the page table lock to be held
in order to safely mlock the folio. However, folio_referenced_one()
mlocks a large folios outside of the page_vma_mapped_walk() loop where
the page table lock has already been dropped.

Rework the mlock logic to use the same code path inside the loop for
both large and small folios.

Use PVMW_PGTABLE_CROSSED to detect when the folio is mapped across a
page table boundary.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/rmap.c | 59 ++++++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..3d0235f332de 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -851,34 +851,34 @@ static bool folio_referenced_one(struct folio *folio,
 {
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	int referenced = 0;
-	unsigned long start = address, ptes = 0;
+	int ptes = 0, referenced = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			if (!folio_test_large(folio) || !pvmw.pte) {
-				/* Restore the mlock which got missed */
-				mlock_vma_folio(folio, vma);
-				page_vma_mapped_walk_done(&pvmw);
-				pra->vm_flags |= VM_LOCKED;
-				return false; /* To break the loop */
-			}
-			/*
-			 * For large folio fully mapped to VMA, will
-			 * be handled after the pvmw loop.
-			 *
-			 * For large folio cross VMA boundaries, it's
-			 * expected to be picked  by page reclaim. But
-			 * should skip reference of pages which are in
-			 * the range of VM_LOCKED vma. As page reclaim
-			 * should just count the reference of pages out
-			 * the range of VM_LOCKED vma.
-			 */
 			ptes++;
 			pra->mapcount--;
-			continue;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				continue;
+
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
 		}
 
 		/*
@@ -914,23 +914,6 @@ static bool folio_referenced_one(struct folio *folio,
 		pra->mapcount--;
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) &&
-			folio_test_large(folio) &&
-			folio_within_vma(folio, vma)) {
-		unsigned long s_align, e_align;
-
-		s_align = ALIGN_DOWN(start, PMD_SIZE);
-		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
-
-		/* folio doesn't cross page table boundary and fully mapped */
-		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
-			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma);
-			pra->vm_flags |= VM_LOCKED;
-			return false; /* To break the loop */
-		}
-	}
-
 	if (referenced)
 		folio_clear_idle(folio);
 	if (folio_test_clear_young(folio))
-- 
2.50.1


