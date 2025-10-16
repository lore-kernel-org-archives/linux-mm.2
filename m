Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC4FCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290608E009D; Wed, 15 Oct 2025 21:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268108E0008; Wed, 15 Oct 2025 21:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E138E009D; Wed, 15 Oct 2025 21:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05B828E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:29:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC814160166
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:29:50 +0000 (UTC)
X-FDA: 84002245740.20.E6A279B
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2C3CA40015
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:29:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MK9rmLp/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7VYxBH2d0zpUlNbfQbUIMot0C8+u83RLKKdWC9mUtFQ=;
	b=L5qFf2GqLQ5PAMzVNv0EIE5uUoyG6GDbKegSXhX7xXEFxablpaDIB1Cpt2PmT7iKjyfIAt
	gOTYWRNQtCVhzxSSgOxI4ZU8ocORhYTUmG/I8HXJzN7GN+KtbJUyFYLmrgG8Hp9qnk5iw8
	3sZ7iqPIz01DbVpJFfaQ6Z0fBCNC7G0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MK9rmLp/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578189; a=rsa-sha256;
	cv=none;
	b=iFPhfxsbfJeWEYkxEep7aOvyG8BfVitcwdxFMsRmfDqoGlfwL8pL/gRnyBA3L2oLnYNPA2
	+wuaYolN3d5sVWgVE6JF8tG5/l+6Zr54HxpesN94Fp4R5b6lEo3NpJfY/lktx7OPBJV92k
	BZk6gtvzdsBc19BYsznoUTcWD9Nw+yg=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-54aa4b86b09so98208e0c.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760578188; x=1761182988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7VYxBH2d0zpUlNbfQbUIMot0C8+u83RLKKdWC9mUtFQ=;
        b=MK9rmLp/0Wg6kR6+8+cn0b4dLBkKFsUJfMrL77syi6fykuUcl6VZgXUNWXEk39f8n7
         UZcnThkymjokHAuRB9rdrtrTSXpXRsihFGrG/nvA+5QWJwD1L95bwGSuaGQTC1V27h31
         QRR7Edg5RCOqvE12+uO0VhR7AwsBbac41V0I78eBD+wPbAjtlbaaBxWdzFiXmd1lR3G8
         CUbS9Lzx9hJZoA2X+MUlL3NfW7+l5B3oiA34g/5hWFt8P1hyXIgovIx+SojAPsCNy9XE
         674T104csc3Mh9qnQOEpTRRa6kOj8UD3996MA6U8DagbejM9voY1B9qvUD3gblE4fBFy
         Pm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760578188; x=1761182988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7VYxBH2d0zpUlNbfQbUIMot0C8+u83RLKKdWC9mUtFQ=;
        b=tmCS9J7y3Xg+xrOqnAy9zQH6zGANu+dmL9cZkejV5nzvaHNxxuAWvriDGFsaUd0Rae
         WRIB6F8BtkpSVNcgxsXx+37dbQ8Kk0Yn+QRM3278zmQ0ck4NIbWy/GOXcvbiDBCuww+7
         5R7U5e9ysShrrWq7RZVH/0LwezeJQlvi4o9zwTBvi3l5jKTzjB1BvqSd2d/w7V2aZrKz
         UDSsH5EvtvH2T079285WsnY/DJefDGI/100bqWTS6qlBz5wx0sRNUwED0RnFmlUy+6AE
         tshOgxcdA7eHQo7Wl6IbUEFBU1Q+NEUUBTl1bzVJ3Ig3WNQfzJzt66DTOak3V9jAriZW
         G65A==
X-Forwarded-Encrypted: i=1; AJvYcCWvN9yLvTrwC1Bd82LsPOZYkp8dxCAnfEFj60uxsQOAkO1e/yZTNphB2wavgWXkjwVT5/I0TWX7dQ==@kvack.org
X-Gm-Message-State: AOJu0YxbQIMvTfq+iQkRe4X/iT4FWz0xUaNE9nFXowKWoCJj/J3XovJ5
	+w/Goj+h6YnkkP31rQWXAVGMf3sLH+vnFJMMorvQUYiMunre/24fOKAZ
X-Gm-Gg: ASbGnctSBUk3XtICy1F9dma+FHPxfRLRFkR94rHVhCZRpXnN70RpCWVgIMiL8LzwqDW
	ZMnhdOTCPDNDcTehvyWaIdI8cIL59lOU4i0sz6CqzbP7nrk7B63aKvsK+zBM+FXSUTtYS5PZyOv
	A1qEkuRRPUHrEG2jgorwnUwB98EDu6NBZer81fD0LTOe06Hv0qdfUIIjTqcAH+JYo+Yk87wvs9L
	Ysje5E/IO0kEyzpkm/M4OgOUoGJ26eEXZLyWZutIL5SQLs2nEOfC63X97SQJ5Xu2wYkA+x6LeEK
	Y/xAo9WK2/rYwgP9RwaN95LTfjg1glFJFeHUNYQDk6ZlAYe6zdsP3oFbGiw5A+JO/tUCMHxyr5R
	PmIYNLie3xEWhI6XaAqUPu4Mne2DuJfxd0sPCVOPe11RI9u/WbQnRCoeTPQweAJy7h1PhBjPDvp
	W1qF81
X-Google-Smtp-Source: AGHT+IHnQYhV6RpXvrx84+8SiCk6AEfJ0W8ZNrxExGEv4WcaUsJUVVRkqjZtXqYvBn/+YQge5wi94Q==
X-Received: by 2002:a05:6122:3c92:b0:54a:9e02:f9c2 with SMTP id 71dfb90a1353d-554b8b6e7ecmr9425746e0c.6.1760578188061;
        Wed, 15 Oct 2025 18:29:48 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:5e5e:f0d0:4950:c448])
        by smtp.googlemail.com with ESMTPSA id 71dfb90a1353d-554f37d2ea8sm4069649e0c.4.2025.10.15.18.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 18:29:47 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	craftfever <craftfever@airmail.cc>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v3] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Wed, 15 Oct 2025 22:22:36 -0300
Message-Id: <20251016012236.4189-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3CA40015
X-Rspamd-Server: rspam03
X-Stat-Signature: say95wgt9qijwo4cp5zsifs5j47c7uuc
X-HE-Tag: 1760578189-433749
X-HE-Meta: U2FsdGVkX1/dFq426DMpUIrbBrX9mvhk/mx8RN07DtXoGbc5GpT1iwodM6Hzbq7eR0P7TNkZcu42gUt1/3kRbdEQ5klxlXppGxuwY2eL/gJ2Asqaju+B2d0YjThXst1q8W++Tp2/VWIgOWGVyqbxSQjY41tvRvbeOBlPLyKC9bitOQYR9+GvSgY/hhBGQf9UndJ4XrbudNrwmAN3vL6fJPo2tpZD2s/q/yhz8+bT4+tPWfr58nuZdVYWN1Cx4KxvDXTDJJ9QbPeRVar4GZqdrgNVukNgePl6NmYfGHQs0JXlbP6Sa6PgC28m/qvkuxf9ogf7DjXeXQF3MTLXW9ULiXZ2jzspgZZHyYKCnLPaqomXooKvqcfTSBk3pWg9dzKJFGJORCvzwteZxGrxnzkbcmbI04FhbhzErEntnNyL2Kr/3aOrB7X1kIP5upYuGHJqcxjp7bGA2l52I7akajV9qrL3hCN2DwjC6ckd0StrjkyOjWldpEbpk09ZoqSIMINnotHGqa2OJxzmYFVk/r7KZ87BS514NhfivWPMwaRmRhO+lB8kQR8YNAXmXIEHpaEEBc2OMVLEkLs/UaVZR8ZFkNSKHWR3cR9QvxFMOQAGoqUD8+v5GszVo9epL+mKumo1ZWVUxrySHqSAfWNSXgrhAPhFqTRG+xhhogfsRo//uIC4aAfSO198hEa9VEl/a6castzc97vpEr3+TgxfSV4FVflueZjiScdZ3jikE1uagE7zW7QQCxQIvnnsEoFq/78BLcI92h5CdP2nu5o9b/ApRm0p4jORSNHVzqhWXCXdQeMz8t3joCJfzyvKKVvQK6VI4WV/1CHNH/AWbGL7g9ajdEFOp3EsIuCoNEPIUeiH3nC814Yu2uCAm7sleXlel3Gpr7+J4vqBlzMvbqx8CDmyoUSN/0rL5orPvtFhWnX9Jzh6uLOKVj+HMWzeQ52Sl3o5FoqGSIIhC8zgB53rhVl
 GTrr3mRu
 VUDMqFCn3z3iIHSFOItOpgucdH3A1mn4xMcTxeYmcyJxN/5xTSGybEIV8wEC2rHBSxbVuAynbXHOfL4MapiaftbGB/SGURS1kufcXzZwmlF3bR8HGuP0svu8aaHlSbt0YMWhWvXZ0Aei9yZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, scan_get_next_rmap_item() walks every page address in a VMA
to locate mergeable pages. This becomes highly inefficient when scanning
large virtual memory areas that contain mostly unmapped regions.

This patch replaces the per-address lookup with a range walk using
walk_page_range(). The range walker allows KSM to skip over entire
unmapped holes in a VMA, avoiding unnecessary lookups.
This problem was previously discussed in [1].

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/

---

v3:
  - Treat THPs in ksm_pmd_entry
  - Update ksm_scan.address outside walk_page_range
  - Change goto to while loop

v2: https://lore.kernel.org/all/20251014151126.87589-1-pedrodemargomes@gmail.com/
  - Use pmd_entry to walk page range
  - Use cond_resched inside pmd_entry()
  - walk_page_range returns page+folio

v1: https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail.com/

Reported-by: craftfever <craftfever@airmail.cc>
Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 185 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 135 insertions(+), 50 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdce..403e4f102f07 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,14 +2455,119 @@ static bool should_skip_rmap_item(struct folio *folio,
 	return true;
 }
 
+struct ksm_walk_private {
+	struct page *page;
+	struct folio *folio;
+	struct vm_area_struct *vma;
+	unsigned long address;
+};
+
+static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private;
+
+	if (!(vma->vm_flags & VM_MERGEABLE))
+		return 1;
+
+	private = (struct ksm_walk_private *) walk->private;
+	private->address = vma->vm_end;
+
+	if (!vma->anon_vma)
+		return 1;
+
+	return 0;
+}
+
+static int ksm_pmd_entry(pmd_t *pmd, unsigned long addr,
+			    unsigned long end, struct mm_walk *walk)
+{
+	struct mm_struct *mm = walk->mm;
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
+	struct folio *folio;
+	pte_t *start_pte, *pte, ptent;
+	pmd_t pmde;
+	struct page *page;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	if (ksm_test_exit(mm))
+		return 1;
+
+	ptl = pmd_lock(mm, pmd);
+	pmde = pmdp_get(pmd);
+
+	if (!pmd_present(pmde))
+		goto pmd_out;
+
+	if (!pmd_trans_huge(pmde))
+		goto pte_table;
+
+	page = vm_normal_page_pmd(vma, addr, pmde);
+
+	if (!page)
+		goto pmd_out;
+
+	folio = page_folio(page);
+	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		goto pmd_out;
+
+	ret = 1;
+	folio_get(folio);
+	private->page = page + ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+	private->folio = folio;
+	private->vma = vma;
+	private->address = addr;
+pmd_out:
+	spin_unlock(ptl);
+	return ret;
+
+pte_table:
+	spin_unlock(ptl);
+
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		ptent = ptep_get(pte);
+		page = vm_normal_page(vma, addr, ptent);
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+
+		ret = 1;
+		folio_get(folio);
+		private->page = page;
+		private->folio = folio;
+		private->vma = vma;
+		private->address = addr;
+		break;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+
+	cond_resched();
+	return ret;
+}
+
+struct mm_walk_ops walk_ops = {
+	.pmd_entry = ksm_pmd_entry,
+	.test_walk = ksm_walk_test,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
 	struct ksm_mm_slot *mm_slot;
 	struct mm_slot *slot;
-	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
-	struct vma_iterator vmi;
+	struct ksm_walk_private walk_private;
 	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
@@ -2527,64 +2632,44 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
 	slot = &mm_slot->slot;
 	mm = slot->mm;
-	vma_iter_init(&vmi, mm, ksm_scan.address);
 
 	mmap_read_lock(mm);
 	if (ksm_test_exit(mm))
 		goto no_vmas;
 
-	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
-			continue;
-		if (ksm_scan.address < vma->vm_start)
-			ksm_scan.address = vma->vm_start;
-		if (!vma->anon_vma)
-			ksm_scan.address = vma->vm_end;
-
-		while (ksm_scan.address < vma->vm_end) {
-			struct page *tmp_page = NULL;
-			struct folio_walk fw;
-			struct folio *folio;
+	while (true) {
+		struct folio *folio;
 
-			if (ksm_test_exit(mm))
-				break;
+		walk_private.page = NULL;
+		walk_private.folio = NULL;
+		walk_private.address = ksm_scan.address;
 
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
-			}
+		walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
+		ksm_scan.address = walk_private.address;
+		if (!walk_private.page)
+			break;
+
+		folio = walk_private.folio;
+		flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
+		flush_dcache_page(walk_private.page);
+		rmap_item = get_next_rmap_item(mm_slot,
+			ksm_scan.rmap_list, ksm_scan.address);
+		if (rmap_item) {
+			ksm_scan.rmap_list =
+					&rmap_item->rmap_list;
 
-			if (tmp_page) {
-				flush_anon_page(vma, tmp_page, ksm_scan.address);
-				flush_dcache_page(tmp_page);
-				rmap_item = get_next_rmap_item(mm_slot,
-					ksm_scan.rmap_list, ksm_scan.address);
-				if (rmap_item) {
-					ksm_scan.rmap_list =
-							&rmap_item->rmap_list;
-
-					if (should_skip_rmap_item(folio, rmap_item)) {
-						folio_put(folio);
-						goto next_page;
-					}
-
-					ksm_scan.address += PAGE_SIZE;
-					*page = tmp_page;
-				} else {
-					folio_put(folio);
-				}
-				mmap_read_unlock(mm);
-				return rmap_item;
-			}
-next_page:
 			ksm_scan.address += PAGE_SIZE;
-			cond_resched();
+			if (should_skip_rmap_item(folio, rmap_item)) {
+				folio_put(folio);
+				continue;
+			}
+
+			*page = walk_private.page;
+		} else {
+			folio_put(folio);
 		}
+		mmap_read_unlock(mm);
+		return rmap_item;
 	}
 
 	if (ksm_test_exit(mm)) {
-- 
2.39.5


