Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2060CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65ACB6B00C2; Fri, 29 May 2026 13:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60ACD6B00C8; Fri, 29 May 2026 13:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521836B00CA; Fri, 29 May 2026 13:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40D836B00C2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAD1116102D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:08 +0000 (UTC)
X-FDA: 84821130576.23.3B89929
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F381E120009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvWVTOzE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYuIV9AvDafYDcSbmI0+95lKITkmfWI6WJtx/j8RINo=;
	b=ou29iDdJC67B64oEobSbKx4MsdhlD86VfkfwKnzLd/U++FXat/S1hMSOSprmp/m2+5KeZj
	F9Fm8JN0SyEumuBP59ygoycpFsY9Ji8UXfoMNjoa9WmYMoJxnlmPcoB/cyx2e8M543/fPr
	rbEjINmduMVevyIadpWWhXqg+v7FReM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvWVTOzE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075447; a=rsa-sha256;
	cv=none;
	b=ygqHico2v8uW6wi1pL1rwEXHfn7vTlSHy6M/IAChnpJJVD6S5SQi2xcVOLo4T7T5qRGine
	gSZycKOt7XfXMEAh2l9XXEEWhJW7TZGSuLqZyhZBFl7nrO3tBModC2eZTSDiHzIuvw4d+N
	jagCxdOt96/w65S5opxJNIdWaxpgOj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D92D605D7;
	Fri, 29 May 2026 17:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3741F00893;
	Fri, 29 May 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075446;
	bh=nYuIV9AvDafYDcSbmI0+95lKITkmfWI6WJtx/j8RINo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvWVTOzEc6sLLsdd4agf0l6vVfQ3dDH3V6mSedWMZ0sIe8WfAkKZgTwvAtegYhe1J
	 /9O9mfzQVuRCoqpPEx7Az7/6HCtpkbMVElfEZx42ZaEquV8f5HlHw3OG4INX4RrbGC
	 F/mpfWR5y73pWB9956SiFHQhTs7Xwfwl1zTpqorsQ+Y6GURSENcSb3wICGdSBxJBu+
	 4CwnPFXu99Z5zip652MehYlCylZTvq/OckJhvgowMP1xFkJuZb9Kd+VLPG9SJz/dPg
	 8uKCgilCOIw/6NI5HsFb77mwYdpIL4yyrKNh6UJUf0OhgRWqKEKKXtgFuK3jGqvdb6
	 Ug4vkXyw7FjmQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4A2CAF4006D;
	Fri, 29 May 2026 13:24:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 29 May 2026 13:24:05 -0400
X-ME-Sender: <xms:tcsZaiZfNBo4HsT7yU7AfTjnsw_oC5UsxFxbzzhN9ulyJ43y5FtDdg>
    <xme:tcsZatVdx-RI6g1CgDTFEycYUwUjeNjQlr27bteqOX0c-lH6wnYxJ6msprJqu5gmz
    BRoIR-a5ShL_dktzy4y-bV8RPH1v5AvctM9j_tYuxeVpbAcFxFnYDw>
X-ME-Received: <xmr:tcsZakJbMtPFiZjdDr6OBXudwfo9copsfwbDDvbgfRNtKVSXSo1YrsT0CeMlow>
X-ME-Proxy-Cause: dmFkZTEZfpMr5/eRRE28w8SXJrP2dhbWJDto6huRdd/cnfVbAAhK4j6L5mXvQtvbZW1Tgn
    qdHjS1xVDGkdt7hr1SYRochmR7yuP2KsuqbhH6HkebbwRdIZkVYqIRv2TfGI9SaQtUiic8
    G8SBlRV6/L2Xtb05bm6QmOQTKoj3b/RGprk0F6woL4YfqntUvh+0D5sL6ruauatQhdAfx4
    sxg873kOfAaKAVmot+PkxhAMe2YWyy/aSlFAam2C/bHdTY9DLsPBVhceLLRJtCvIR2Q+zM
    kaoJA5O2aRPotfcyz8zPVtzBiOjMLe5Pw3NzV/bo4OKaUt+lobJ5eojHQXZMuqCslD6AnS
    ok5QtyObWq6j+DXuni1rlZOw3XtlbsdrBtLk/PduNPZnMWbxiseSW1kQIaGiYoG0Owi9Jp
    9XjI1ZxuqSyNya4Ifrta5xPSeY6MbudbjLqoQOxnqqoSfmGjibIBRAdMYKp0lTqE92dtia
    gIKy/RhhuXxoarlGCcIglkcPQ/ZRLxd6pcw2uj5oCWiJXoJC0ZVSRe+qltKVCgafAsu4hU
    rYsD0f1RyR4nUE9eGm/7OvFVKPnlAstWfYnjFnH6iAP4Dv8Dm284OQXfbNkidxkyt9DHu6
    +bwThVFcMbvJHZ6h4DjLhbKj4GHVfcB11PnXN1U61Tttbh5oo2wkrZpwBzwA
X-ME-Proxy: <xmx:tcsZarGEKZyBHoXSotxu6Euz06YCtqFwMzYwFMdR1gKwaOaJvaCTTw>
    <xmx:tcsZapzX_01yOuXs3Fu_seV961tbe_1QPS9F1Eni8nOvoiWsg__gvg>
    <xmx:tcsZaogtK0IJGEdVqN8B4vq1cIMulL9p2Ir9PFS5eZptLq_rJcn1Pg>
    <xmx:tcsZamKHCfuqMzkPpdKJQMaeEJmPvl6IejKZow3tn3Q_jRgOihC83g>
    <xmx:tcsZajCI2rn5lz_26HGnADnkJBOWToyvw2nF1181XMs9uV0jtDenYIiy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:24:03 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Andrei Vagin <avagin@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/6] fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
Date: Fri, 29 May 2026 18:23:27 +0100
Message-ID: <20260529172331.356655-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3i6yzjnxz9yr1q5bixm4u8cf3e3b8nqz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F381E120009
X-Rspam-User: 
X-HE-Tag: 1780075446-784278
X-HE-Meta: U2FsdGVkX18wO6DvHc6Q9CcP7emREXtgnAnrBA1K1J8k6lepGaSbivWFrsUQrUzzrIKHrYH7cMyEqG/f80h3MeauT0wMIIZ4tMTrIz5wb23j4POwUiS/CzOXimO6Op26zCRIw2q1/Lb8CjCneoE0noYcBwuqN5pVxklwt/kv/ZeVn09EHgHnz1QmAgeRvUvGS+m+FAf7Bom70uHMHRl1IHkanmV09BVNXHlZY9Bp5ed+db83NXfFzo5tBmgB32zzE8S3srsvrQeOCSUK/pcIyYIPnAYEx+uPucTe3iLKMybcWeyNk6rO157l9+Js88OOmbFWlbI5IzjUPiYM7K1JQyz0XXzdhM26xH2BSQy4JOI5lB2FakjrRFa2gn9Ze0y87UM4xDb0p9wftTmALjrFRREsl+6GAvqpB8Dn7Q1LjlwcGnGCTdJAm/Xui2//dM4MOJuAKzC31tNDL5Z/DCXPqYS/Ij4lDb+xhc1TijCHgukQPwePfvXtExIQ9fOShq9jNcb0haKOBsUiHnFgoZwn9734Wgao1KQ6hQpeUyOxPUSZ2Dy+7aoUYEspQZQ5k4Z9XdVfMNGOEeNU2xEUhyvcamlLxEjldMHs0JKPtNfmMwpZWeScJ8S9cZEz4eovwD3TFSoYxNZ26QcK3PFjIc3Ug0Umlg/VeedEYFUXF5S/Y9INwA8NBttUd8D8LBzye8Fqw3j6rpPWT1yg5boKI4+ThuU6YWK0GOSc2SqnlvMCXe0Hyb9+6ddJfzSlim5Xnbr90vg+CaZhfq8vTVdHspZAtmbmyx+xxZ1ygbktXFr0qcPgD2Wy4HMtIPdy0ABtyjWWFmH9qeB0tRfy8CKwypgCyrMn6xjq05iyjAT30+sXarx1+bT24s60i5KmcqhP8+z1QTNni/Kazzxv2cx1JjfemYc4E/EwkblPLWldZNkaKJsqAxn0V8AZ0ejT+84AW3FO8eAtlkff9BQLGuOJLW/
 s4nIO6MI
 /rXDd+l/YwYZ0AVM+S2RC/kkoIhZSga5JXkogp1IUewhPMGO8/8gQDkIjud/Y9vtucBpVYX7fmPyMzHMvhlKUKk47dU0MfLjAhYDOKo0j+wlfb+vT8DXmUwkUHTzYo9c1rqN0R7kJex78hcmcmkAJ/s2pQm6xBZg157/XZErKBFkPmwXZPqgxanf74uE21YNiwfQ0h98pxrpkUiLZPu7e0qC1G6PFNk58NxYrBsPDCIaPmMOQPptPi4iqgVHeqLv2h/gRYpsVRvArMLdC84HYtt6xHVq/v+z/FogRx9IrpkCc8Mj9NssWeZ2KXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PAGEMAP_SCAN ioctl requesting PM_SCAN_WP_MATCHING on a hugetlb VMA hangs
the calling thread, unkillably, as soon as the scan reaches an unpopulated
part of the range:

  do_pagemap_scan()
    walk_page_range()
      walk_hugetlb_range()
        hugetlb_vma_lock_read()           # take the vma lock for read ...
        pagemap_scan_pte_hole()           # ... ->pte_hole() for a hole
          uffd_wp_range()
            change_protection()
              hugetlb_change_protection()
                hugetlb_vma_lock_write()  # ... and block taking it for write

walk_hugetlb_range() holds the hugetlb vma lock for read across the whole
walk.  A present entry goes to ->hugetlb_entry(); an unpopulated one goes
to ->pte_hole(), i.e. pagemap_scan_pte_hole().  To write-protect the hole
that handler calls uffd_wp_range(), which on a hugetlb VMA reaches
hugetlb_change_protection() and takes the same vma lock for write.  The
thread then blocks in down_write() waiting for the read lock it is itself
holding.

The populated path avoids this: pagemap_scan_hugetlb_entry() write-protects
the entry inline under the page-table lock and never enters
hugetlb_change_protection().

Do the same for holes.  Fault in the page table and install the uffd-wp
marker directly with make_uffd_wp_huge_pte() under the page-table lock,
rather than routing through uffd_wp_range().  That is the same sequence
hugetlb_change_protection() runs for an unpopulated entry, minus the vma
write lock -- which is safe to skip because PMD sharing is disabled on
uffd-wp VMAs (hugetlb_unshare_all_pmds() runs at registration), leaving
nothing for that lock to serialise against.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-8
---
 fs/proc/task_mmu.c | 59 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1489c67e88f7..06fb94a965ff 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2977,8 +2977,62 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 
 	return ret;
 }
+
+/*
+ * Write-protect the unpopulated hugetlb entries covering [addr, end) by
+ * installing uffd-wp markers inline, exactly as pagemap_scan_hugetlb_entry()
+ * does for populated entries.
+ *
+ * walk_hugetlb_range() currently calls ->pte_hole() once per huge page, so the
+ * loop normally runs a single iteration; it is written to cover the full range
+ * in case the walker ever coalesces adjacent holes.
+ *
+ * The obvious route -- uffd_wp_range() -> hugetlb_change_protection() --
+ * cannot be used here: it takes hugetlb_vma_lock_write(), but the page-table
+ * walker (walk_hugetlb_range()) already holds hugetlb_vma_lock_read() on the
+ * same VMA, so the scanning thread would deadlock against itself. PMD sharing
+ * is disabled on uffd-wp VMAs (hugetlb_unshare_all_pmds() at registration), so
+ * the vma lock guards nothing that matters for these entries anyway.
+ */
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long psize = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pte_t *ptep;
+	pte_t pte;
+
+	for (addr = ALIGN_DOWN(addr, psize); addr < end; addr += psize) {
+		ptep = huge_pte_alloc(mm, vma, addr, psize);
+		if (!ptep)
+			return -ENOMEM;
+
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+		ptl = huge_pte_lock(h, mm, ptep);
+		pte = huge_ptep_get(mm, addr, ptep);
+		make_uffd_wp_huge_pte(vma, addr, ptep, pte);
+		/*
+		 * A none entry has no cached translation, so installing the
+		 * marker needs no TLB flush. Flush only if a fault populated
+		 * the entry between huge_pte_alloc() and the page table lock.
+		 */
+		if (!huge_pte_none(pte))
+			flush_hugetlb_tlb_range(vma, addr, addr + psize);
+		spin_unlock(ptl);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	}
+
+	return 0;
+}
 #else
 #define pagemap_scan_hugetlb_entry NULL
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	return 0;
+}
 #endif
 
 static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
@@ -2998,7 +3052,10 @@ static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
 	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 		return ret;
 
-	err = uffd_wp_range(vma, addr, end - addr, true);
+	if (is_vm_hugetlb_page(vma))
+		err = pagemap_scan_hugetlb_hole_wp(vma, addr, end);
+	else
+		err = uffd_wp_range(vma, addr, end - addr, true);
 	if (err < 0)
 		ret = err;
 
-- 
2.54.0


