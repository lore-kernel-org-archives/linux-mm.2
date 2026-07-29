Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B43DC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A9D6B00A0; Wed, 29 Jul 2026 12:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041AF6B00A1; Wed, 29 Jul 2026 12:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC10C6B00A2; Wed, 29 Jul 2026 12:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83236B00A0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 530B94077F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:12 +0000 (UTC)
X-FDA: 85042401864.28.392EE31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93978A0012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jL5u3VHv;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2frCCTlxfdZhl2Q9hCXWFmqticNPmIEH4CLCsGGzpUc=;
	b=wIrBZ1F1G6KAbZJ+T7OQpU22FNAYn2m8pb1P59KRT5qb3ttfSii7D1CMVvsfM2n6IB+urc
	Pdv2jcFAQEi7VgAj48V6ryDEr1ypTybmiXE1h1ADcIC8/BBhBq5P57946Cz7gvhrwuLWu+
	MDF7T6783RggMlUlooVerRm+n/uTwjY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jL5u3VHv;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343810;
	b=BtOOqoSWeWrl2ICt8RAoHH7FFaBnjEMktaHHzlvPQ4pyFC3686ZFsAurrNG7MD8aspLv2H
	R/u88n+B8wSPUo2oyU4dyBMmVraTkOuek2jYpLmkGlbqHZiiJXVlQygzc9kCU8q/xKKa2N
	DZU6VKQG11MSw7SpItbDRg8F0RJJ3o4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38F2A60120;
	Wed, 29 Jul 2026 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74A11F00A3D;
	Wed, 29 Jul 2026 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343809;
	bh=2frCCTlxfdZhl2Q9hCXWFmqticNPmIEH4CLCsGGzpUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jL5u3VHv67bTva7n3vFw64jcekSbG56ZcwC9S160bcGGoc6vXPo3E5IVdaTP1TGtF
	 QMHFqfMG0YGdKF3neRRSpb1K3cS43NMPsF/z+kl4FYNb7wb6vbvzVlYrya6sNsBCXP
	 zENeYsVP+ChPU2WQ4wWknBwx5TSAXtdDyOCGrHSHSnHSPLcTBn8EOCcMMvUgXud9Wm
	 NkxbkoJpSFdcb3nlbWKrmkDEMdro+WeY6HpdlC0jzCDBgPcFfehcRDl7L49U5VA3DZ
	 m5UA4FX0qr1xPWy0qD0Yzs6RXMAJRBJJpeAxcuve3rkNmeqTZEjVIHD7C9TxLrlZt7
	 Dr3uPkh/20h8Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:43 +0100
Subject: [PATCH v3 08/15] mm: introduce and use linear_folio_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4026; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lc1b2FwyMDkTfqYOJvePy8Z7MxKUBNOu6A6vqoiPYz8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H7Myms88S6d87vEtz32x1KW+/M8V7vrnb988uMva
 mH6p0RPdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiNu4M/wsuhnB7s+08PrFY
 /aTS94jfvjNyAxoluvUd4+S+XnqZXcrwP7BMIH+q0W2X58G1m1dNU58gpjM5MvpJenP8f6/Vx46
 d4gYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93978A0012
X-Stat-Signature: uxoezexnprdkpqr3ojzo5odraph7unrk
X-HE-Tag: 1785343810-182556
X-HE-Meta: U2FsdGVkX1/rS27tWgInAwgWL+VvonXJeY8vmzN19eINjUW9NXoNFrWxP+/Qld8Mjs4wjk2mWqaDr6zLLw5LAXmhlhSfaHa7pGx8U3xx1aDIeMFA8FXR9HpNJrxYS7Gcj9oJJLAuOT4r3jlBKMs50IArabCUxhBYM2Es5e22ygpfD3o8hx98PNyS4zCVRLF80GeSwx9LWHgHI2LuaksNTLsvrBv8FDBpvPczOpnVGlFtmXwOWy9cwwwN35N/moOzdqb6YlH9Hy5keA0bglLoH1T+5e792cHz9WV/G63dPV5dJycZUnFvtDlTcLMV6faA8wvyc7+ETzbhaRBeQ9zpwQ+gVaMRR4/BzuUrCTV/MMSQfUwT6DsOs5vVzwhJqypg6w3usPWfuJ012vbfigeF/lGWLODP1dSK6x9E5/B+ECzQhJvrgZ7URsSQlhaQu5luFeE+hpJYTlbHO0on3pxOFltv7sK7tgTlgMjVFTlkyYKiZiPn/y/0REnWkDChjYe9NPDkoSIN9gsV9sUgp6zWr8jMHa5EqSDNmAJKqBq1V2mB/iFGXAtEXnGXEhOrNdPAeaRYA+YZgY0nHfyfq5hGBzJijfg3ok7gX0glUy0M0D/zAU1OqqU/QZNHbbGuvBNjdQK/R04eFlko7M2W6xoS6xCYATVmW0uEaZOLaxmHmI0qWNJcutmMEkLkVOg3sOSLt6/K9XE2dTzlZJTRCW2XEUjiMjW/eDXj7UfLoGk11qfpjOGB/LwXdvnYAk7GvasVXIYeYKpF23ppwYGBs4TICpyccaWDnmEN9Ic0hFq1e3AHwD0/QxDFP6FMfkH4wXO91Phw48eax/4d1PfaVK9HMwGC/CNe5pemvzQD2gN58s9v3ClOAHIpV0kbuwE4+pkYJJJwzxo7WwySFYNXm+vCZdGInkxRyM9/5qNbYjP+qx6LeHukLZ+mzSRYytuXChCsqxka5BoGznyOZrvl+Sm
 nvP4dxW6
 0DZDFUk/7srCi7SaLFCDUFcsaoMLs0Sd4Fk0z+DmJRiNsCQQXAWE4ryBYoDZW+O7i3RCYlrvOFi4AnKLMEYT3XnBO3NCutEByx4BeuE456G5xmr5ri/dk9gOHhyuPDL2so3vcWUqA6OAvSgD+FAGo26z+PihP+4r9tve170wUZOjabSkKn7DXrSVVbQzaKpBeiqmVRzaag5jIn1YaOxaRxv4fi8BMWlqXTxnzJv7ReJEPji5co/LotPqzwL0VeD13X/db6XXn1z2FNvl/FsHEqdsTLCSvzTZquoj7orbXZR4rDLJEyT7TJaUS1w1w3ZLp52XjiOx9qprWoZw3a7tknHwJZ9qhG0nE1JMLT3nnOxI+2rJgcrBWwEqVBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is, for now, a placeholder; it will be used in future to
determine whether to use the anonymous page index or not, based on whether
the folio is anonymous or not.

Currently it simply wraps linear_page_index(), so this does not change
behaviour.

We update callers that will, once the change is introduced to track
anonymous folios by anonymous page offset if MAP_PRIVATE file-backed, need
to determine which index to use based on folio type.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/pagemap.h | 18 ++++++++++++++++++
 mm/huge_memory.c        |  3 ++-
 mm/migrate.c            |  6 ++++--
 mm/userfaultfd.c        |  6 ++++--
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 259177544b03..6eb8d811ba4c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1143,6 +1143,24 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+/**
+ * linear_folio_page_index() - Determine the absolute page offset of
+ * @address within @vma from @folio.
+ * @folio: The folio whose linear page index is sought.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * For compatibility, currently identical to linear_page_index().
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
+static inline pgoff_t linear_folio_page_index(const struct folio *folio,
+					      const struct vm_area_struct *vma,
+					      const unsigned long address)
+{
+	return linear_page_index(vma, address);
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b1f3b24f7e0..abc65d608c23 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2887,7 +2887,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782..37fe7a9b3fac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -363,8 +363,10 @@ static bool remove_migration_pte(struct folio *folio,
 		unsigned long idx = 0;
 
 		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
+		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
+			idx += linear_folio_page_index(folio, vma, pvmw.address);
+			idx -= pvmw.pgoff;
+		}
 		new = folio_page(folio, idx);
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8fd24c8b428e..258b03182a78 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1352,7 +1352,8 @@ static long move_present_ptes(struct mm_struct *mm,
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */
@@ -1428,7 +1429,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	 */
 	if (src_folio) {
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 	} else {
 		/*
 		 * Check if the swap entry is cached after acquiring the src_pte

-- 
2.55.0


