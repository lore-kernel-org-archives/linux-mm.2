Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A8E606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWGKIQZI
Received: by kanga.kvack.org (Postfix)
	id 8B1286B05B2; Thu, 26 Nov 2026 09:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889026B05B3; Thu, 26 Nov 2026 09:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C69C6B05B4; Thu, 26 Nov 2026 09:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59A496B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:36:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1352816048F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:41 +0000 (UTC)
X-FDA: 85477521402.29.2CDFB95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4CB86C000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWGKIQZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703799;
	b=dhB+RJaePv1WuPaIw92pXVXC9JJMhiHD2XxHIEwTlHyMpglJnQ7Bw0OH8bL9QL3VezAJnp
	+5WM03rYCwcKb0UxB4oQ6FLz4cRbahYABJlbtfEgvVJJqnkYDexWsjZe2xtsvuULTVpOSv
	ry+mC1aFLvNiYnSCJnRSfQOgR/6nXHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzhx4S6CgopYZuvRvzMNNuzmkmo623ZyQL4HnSkBQWw=;
	b=nPrANNz8KzArkiSdVf+Ip8fh48eGr2yQFhaow1NGkvK8fIrBIDaOAKtgcQ+UxS1UE/Dhq2
	CI8cStY5YLLNcb3m5jP50PPltBrkSXswuACC3uD6SAuwbQ75DhqOqruPHfDfFDH6IN+DNv
	cFkH8OYzuA9+MhRtsoaQ+17gLumjGng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWGKIQZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E038763585;
	Thu, 26 Nov 2026 14:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AD61F00AD4;
	Thu, 26 Nov 2026 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703798;
	bh=yzhx4S6CgopYZuvRvzMNNuzmkmo623ZyQL4HnSkBQWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NWGKIQZIyXqUnKnO0h/KH4YoJGuxxSTsJFUlW4ha1yW6+F4HDf8oHE8B1eRDLwWs6
	 zWSJipOAO0Cre3cRd5mym7yWU8se9TAuWXIdNWgGPhGDHIdEgB40Ucj7IbF/apqda9
	 OUbLG1nXBTzlH67WKF850s3zUPYMIF7rQ0Oy3puK4NrRRQBaqbcnJz2xLGdKWi5yKq
	 +ReT6YyvNcq0nEmMqm7xUyh5lf9RDr+t6RoK3nGOBccILyNZt2YjEKjjfo1Zp3mjHa
	 dc6lmKzE7f7Dp8W1acKveRddT3Htz28nw1gR8tz0uMACsyfnR6jZU/O+LxGSsXGFo7
	 f6zHNlcTO+68w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 26 Nov 2026 14:36:19 +0000
Subject: [PATCH v4 1/4] mm: update walk_to_pmd() to explicitly return an
 error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-huge-pfnmap-fault-races-v4-1-feecd58bb14f@kernel.org>
References: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
In-Reply-To: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2608; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eSgawdzudFWcEtJVM1nuUlLqHr08H2o5wA7JaB1bBJQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5nF8cNgl+y3yl2ZAlVE94ewdfTVxjZCrL61cGqyS3r
 OATWtHeUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkIvWVkuPbBOOX8FqcQtdqS
 CY+Xur7PDl8r1PKlx/Hv8QcTKgzCFjMy/H1w9fJV+RUPZnHp/a7c7n6IIUbp3K6bTF9iYtReCDb
 84wIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CB86C000D
X-Rspam-User:
X-Stat-Signature: wfbr93rdwmbjaru1wb9zufthkpebady1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795703799-992713
X-HE-Meta: U2FsdGVkX1/VAV8pbV5/cD1IZCBrzPyLZHnUueu/4KtKtjxe9H7zelU2BlO/iOw/g2km+vcAOiRsmmk1S6RNgjcjqOxeEkWn4eWA7tdpc1iAzm2UkwpRBGh3U24cIr3U/nzUInGpx0HLpoHRCQ3BJDMA5VCokp20gZTVZVg3bD02qf9W62SLSzV+2CbHJeZVDxVTUs/9kHvJlnhVJE7HKmFwWOwn1Vluk108zYS97pEVxFWZQzBeen4MaBoGF9ksPBVkvCY6EMyZD88AQpYZqLKyfRXypSyAu9whzfWUEPZdfyLHciB+iQ0g7Vhu37Wcjvt6fTWRaXneihGFGmypASmEwpAorvdayAKOfzBDy5aLiJAaajMxIbAkcJinARw8Pmopwhyj+oBHOSWkVsD6eszFn8fUusM43dKY1pRid3+4AbJSt5PopK/oJ0P410XI0eqsapcLWDiXQ754J167yxBACH0GE9j6wqpsQ8EZelBEmwXSkQaoBS21rqVWzJ7SLw9GscZ9zYJDdNxpOq8n5/L/W+EBOJZdOiTlipideHJCVPYcUe5VN2oAIErtOzvKBvnpZ2CsT58mO13554H2+3bKtJ2WxMNouikXvuhwsrntrCqMnvbAs/C/xRYSajN9HJZN3i5pMXQa8ler24Eg1yzqXmqIrmSTiWzbAGVwQscqnKN3zKSG7maDepbD506lom2XbXImtA7EP2eiBuZ/zyDLVgizZ2nabCWZHDRIAOUYzM6rYU2rH8OrPfoGC35htNbZw5YHvn5C/sbcPsk1lFcIjQkoBI9k7kfGCKFIV8vLru2y60G02tls6wA3JM8g6IqHnDgayul52pwnDLoDNHPXzWr99mhSbxYTsXexO1qKd/7z+0c2Sq2ow/KxSizOlawKAsYv9TRpswzLCJrSaNahvohFHTp9sAdi+xre4mvzf+E3xrFl3MD9/qVZNRQCniv4+oo4yPki0BQGENj
 DJMVDOfr
 ID9GxCK3Z1HuFWLji5wtDJHUafI3i7IpvWuMDqC4hgai+Wb34kxKQmfu9O8OGW16b2J1LFHlvzj9p3/G4YJ91sZACWgylw30lJ9EaK81uesk4XbiZtc7b0nsEF2xtgg6OlxMo2qSPRU68Wg1igjNX7maGYuF9/7mBGfmzh4Y6p2TtTZqSRkCV2aUQy96wTqUdxTZg29MbtcIg+Q94aJc0r/B5j9PARFs9EBs7TbduamfAyH21r/dgW+BzvbePJmEa7UxE58VDYcI08xky4yQR4WYdPAArpl+VECuX//t7FXXpOyr7JA+6sXxNeClg+LrXfNjjeZGSn5GkW1BcZZBGGqo82CRAdWDHCqHAxyOR6Y/iHafJaZyMS8bOUXfqFFhelfxbrHgOUprMBsV5H9Ikhe6WmVD483WaloomN3uu8qEFlnJEkEfKkpKlxc1kvw8snCxRNH6xQAOwOdp03ury0XQodOwm5EcUsPd5TyG39bANCiSCKV+I8DEDkooQi/+9JNV2N64JHzjvpA0PAtdz4GknYBsd2ivoxF98O4cZw6ooTpksz8ALJ5sWtOsmPpBLvm03iltTAlf7f+1WHr5o4x/POw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rather than callers inferring an error from a NULL pmd return, explicitly
return error codes.

This allows different error codes to be returned for different failure
conditions.

No functional change intended.

This is a prerequisite for the fix to insert_pfn() which follows, as that
needs to be able to tell a failure to allocate a page table apart from a
race with a huge fault, so mark it for stable alongside that fix.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d238985dbf01..0e994f076bf7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2383,7 +2383,7 @@ void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
-static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
+static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -2393,24 +2393,25 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	pgd = pgd_offset(mm, addr);
 	p4d = p4d_alloc(mm, pgd, addr);
 	if (!p4d)
-		return NULL;
+		return -ENOMEM;
 	pud = pud_alloc(mm, p4d, addr);
 	if (!pud)
-		return NULL;
+		return -ENOMEM;
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
-		return NULL;
+		return -ENOMEM;
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
-	return pmd;
+	*pmdp = pmd;
+	return 0;
 }
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
-	pmd_t *pmd = walk_to_pmd(mm, addr);
+	pmd_t *pmd;
 
-	if (!pmd)
+	if (walk_to_pmd(mm, addr, &pmd))
 		return NULL;
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
@@ -2558,13 +2559,11 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int err = 0;
+	int err;
 more:
-	pmd = walk_to_pmd(mm, addr);
-	if (!pmd) {
-		err = -ENOMEM;
+	err = walk_to_pmd(mm, addr, &pmd);
+	if (err)
 		goto out;
-	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));

-- 
2.56.1


