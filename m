Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F93CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949C88E0043; Tue, 14 Oct 2025 02:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAC08E0005; Tue, 14 Oct 2025 02:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837F18E0043; Tue, 14 Oct 2025 02:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 744598E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:05:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2241547331
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:05:36 +0000 (UTC)
X-FDA: 83995683072.03.E6DB6F6
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5A6A1180008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:05:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T9f4Lnch;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760421934; a=rsa-sha256;
	cv=none;
	b=PPair/TOFo/K9R1VrS0QnKe5twKs5XoH6GQObMlXitNxcPIapORLhIF5BuxbuawoyuSck5
	3Nb/BU0i0eX/enTffM51WzslY1gVcv4P56Q81o/XTJoV69BIfzJqVibZp8MUDT2k4KrFzE
	G4DMIZN2HGKIDuC9fm8Yfx9oxM7KFbw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T9f4Lnch;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760421934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HHqnznsT0SOwqI2tDjUXYkjuoGbZvuJjFziumXqVraE=;
	b=Ng9wJjuJJw0kfhuJQE3xUSC7AJv5y+oZvwRoljEfbiyNykwcnuFJBKQzpFH2f6IHcy4YYf
	Uxm4l+KzVg0nkpPfOZHvVQzSuk5jgc/vsAifVYwk4azKwuuQ2V3inq/mtLPoNFZaFfZm/Y
	kvni3lJdMSXbk8CwDVQxcnfb+MExlns=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3383ac4d130so4213291a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760421933; x=1761026733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HHqnznsT0SOwqI2tDjUXYkjuoGbZvuJjFziumXqVraE=;
        b=T9f4LnchpSEBPG5t25rmSGbrT6pXqgNjKl1pYytrIiJV8QMn4Ts7yn+/K9ZZX21Rj0
         QFGo36z3snrsrsUhlQCOEnwZLd0A8c+aa6JtU8JYnK929o9EF45CHWqZvk0xLo7iaVCa
         iedNViDUreYrcHIuU/32eGb291VnGDqzx/EN5FG+sUxNQUPM+GM3PNmNXbSrzCbU4ojp
         vTIcZe0jbkdBYaTt/uqTb2/MM2ONUiiH3vFo13DyjUHPRu21w2eGDEIOE3tyCYy2z/47
         amLTZZW3fkUtByw9STSXZk4eJbaT3fwGHU+mNW9doSl1rr0Q1ke1audhKV4A+sKaxLFx
         bYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760421933; x=1761026733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HHqnznsT0SOwqI2tDjUXYkjuoGbZvuJjFziumXqVraE=;
        b=G7orLqOf1IgYaWbkgEvN+5Qys9dPGqEdcrMaU8qRwM9mBY8n3u9isw1jrm8doiXLbl
         ZKGFqgJcv8INx2nOUYSFVj4SdhRjzR1VTOeD041SPUR7Cjf9GQ0rc1LcojlHpBsVTEcH
         WKQs6eCnHoRrjqBE6E1goOMKZ6iF6KPo2oEfNyPY561XV8c2B/5mBKQw5qexCEVMv4kY
         ga/IDZ5XchdHq246nxEWNbaDkT3po9nzhhsFH4Ybu4DIn8on1+s30XxQan6/kQpcCdK0
         BZ7dVQ1Tc/aObzCYiYWhX/L5isegSBlSkJibqIfWvv2igJi4b2VLi6Uzr2M1OAGVTyoq
         G5fw==
X-Forwarded-Encrypted: i=1; AJvYcCWVozg5UWcoRR1PqDviwGYTSSQuZdPiecxWo6JAiyR7U8BLGruxPFivD0e8Cne5JG42O3TqgcV8vg==@kvack.org
X-Gm-Message-State: AOJu0Yz2Ei8DLV7GABUV7tCqYvwSlHmsPYwTn7N3KSkHIAq5E2344Ouz
	xWhWazKPaRqbwbAMqHu4Dadbu/rrlv+ssE8vZQ8lbX1huwr8aJvpy52q
X-Gm-Gg: ASbGnct4Qsy8vCAtjV4SYuYSs6/aFMIcY8/cxPI26txqgImtN33xlfQO0ENgYY2VCkD
	Qdb0pr075YbAwwTAu02HyYVV2hRj6iOD2Gb7LRjXJAaxZf5+P1D9qRuaC4gnwTAefsnkkdnTyYw
	YMe5fIbCtOuwLF/YBPaySjbLN0yjtu1dtyFbtTxYUGVW+TCglWov7elqtBgsUHUf5IYJ20ZqzIr
	+2JzC/BM9KjZgKtgHO2XiqFSV5cZe4FhOZQyo+2gdYraR7MSzewNSHYbU8ozSGTdIDEwC4Ifz92
	rhoKLIQ81imkEUHINLOg3bSJqwcXfK+VIVCT2DajpCa32B4c3hCy3EyBkx+UM8ENOR/PENgihYF
	2ZuCxZz4wh1oxzNeb2sPlQtt7/pGeQsJc5uRC94cQNew5
X-Google-Smtp-Source: AGHT+IE/bSBVC/4X++gZ1NL/yvcqA6f/k0gbNSg/p1CV28T6Zcy3HyCXNpW/DJjLf00FJ/ax10zCWA==
X-Received: by 2002:a17:90b:1c89:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-33b51399970mr30703695a91.34.1760421933015;
        Mon, 13 Oct 2025 23:05:33 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:1c15:530:dc8b:d173])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-33b52a2522asm8313102a91.8.2025.10.13.23.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 23:05:32 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	craftfever@murena.io
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Tue, 14 Oct 2025 02:58:28 -0300
Message-Id: <20251014055828.124522-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aujfgdzq11ho3tdtkbn7ofk3cy1aorn5
X-Rspamd-Queue-Id: 5A6A1180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760421934-641724
X-HE-Meta: U2FsdGVkX1+ZBKK9UY9PubEP9vM4x3kRXhrs7NoYRgvd+z7VyNgFu11jFVOfTM17s14gFXZjxhmDXFGKlp4+1gJRC5YCx6HYBmrahAmrzd8y4zRrmMnPx9a8gSL4tlugBrFKylStPos7qTZZ/BSPWim5nsN7+g0dAlbShEvNeFZ7pHZwbF17rm1SVmGqPMfEHLyshtytFNWGcB6siZ/Yem+6MoIOPENKDKipBIccyPLZfv45hVjjUFuzdt4C/QQHDWJtfy9zRE7Ugj2Nn/OSvt6KMMjsBFQSrYu30pBklZobCbGVD6UUpABqn3ckAsjS6MypzKUxWVb0VY8WyAp7v8YkmnxHBgRywNXiQsgQ3+8UQzv1TSJN30rzke0DZNXIW10tAa2SGUVG56QGt00gic3rIU1lgdEp+3QT8R7nx/1Gppqehfmni/C2P0obf1QaOQ/NDzqKhasLOFQxv0IGZUVbL0hze3oDGYJQy3zCCf0WXh+XpFPG5HTO92mcTzhpZZPyvCawq38GMpTRS7yxC6VgxWNNEJdw9SQAM2OdJS1sqqHUL52SP3y4HZRQGgHBShpG5XjjZkZrO+7qu6L6sGbBTHRbmvJdehN55mRY4Yu+XxFBr4vHWV/7AGxeFPpbsrRhyYltfjJYdcgIRTOf0iWgpYHea7lo7HULP6ExX27TMTvIG0nLxOGrvgkw17/nWkwhgCEZ5Ao8Q32K131XLex9ICDN/fP8oZ3bGxva4KnGxnmqA7jDoc9dLbWCLWMzJlSklGYRtn+uTIOhZ88XkhbQYmnSnCAMSKfoBgE2zBe+jbvqSdk8GrwfAX7W540axKkOE2CxhL4O7tBGJbuR2lxBeNnBZ8BZCYY22qmxFVWuQaYL9P9CYt0oqaOu/BkjWpH3GVjE8P9fNeejOVGvVguR4FwLORIAFj2mF/qqmEAap5EOB9d2SEcyoLvh/QuwpikO+rCx6mIIZ7SAw8C
 nVwggJTs
 TP0OCFwJHaDlHcZj4xlU5IaCn/pjoQioTDdiQFpmZcL/m8p5qubkcZlSxFYnJwNq4vR5Bi7eaddd9UchSCUhckYiYP/uNp0h1FK06nJb3qbiOtvgwoWptnr2CYdKnDUgaar8u05lKlNZ9lfRl1Sbttyp6avjZUyc/eCJvDEMaVdwyiUmGs0svX4C593R9Y0SBXrxt16ZklxxVroucaJ0xjoYhlIvRffvZgHhIFZndzEAD+5gAGitdHEEQotNpkxxPAfZyElDwHtO6at7yOX/ZP4NLC7/fZGtGzEv3IlEkIZPA3pXCb3ZZCqMlB3SdszxK1BGm8/WfbwLLnPQoJcA1r5xySGBb7v8PmAWa8D1lzmfIFDqU7oQ0bmpw5m2w5/7PYfKkBlzl0wEzOSoOf9qeihoLYHOc7kHKWZvhATg3RLiU5NkIt6XdYRJSfiRE5o2lpCKFb/LN/DEuKhO/Z+zT9z6+PMop56lY2AR9owhBUEUiZGuCLBNg6/DSuE1NjWVxnrFAnxHi62ZvWqA=
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

To evaluate this change, I created a test that maps a 1 TB virtual area
where only the first and last 10 MB are populated with identical data.
With this patch applied, KSM scanned and merged the region approximately
seven times faster.

This problem was previously discussed in [1].

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 136 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 79 insertions(+), 57 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdce..584fd987e8ae 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,15 +2455,80 @@ static bool should_skip_rmap_item(struct folio *folio,
 	return true;
 }
 
+struct ksm_walk_private {
+	struct page *page;
+	struct ksm_rmap_item *rmap_item;
+	struct ksm_mm_slot *mm_slot;
+};
+
+static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+
+	if (!vma || !(vma->vm_flags & VM_MERGEABLE))
+		return 1;
+	return 0;
+}
+
+static int ksm_pte_entry(pte_t *pte, unsigned long addr,
+			    unsigned long end, struct mm_walk *walk)
+{
+	struct mm_struct *mm = walk->mm;
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
+	struct ksm_mm_slot *mm_slot = private->mm_slot;
+	pte_t ptent = ptep_get(pte);
+	struct page *page = pfn_to_online_page(pte_pfn(ptent));
+	struct ksm_rmap_item *rmap_item;
+	struct folio *folio;
+
+	ksm_scan.address = addr;
+
+	if (ksm_test_exit(mm))
+		return 1;
+
+	if (!page)
+		return 0;
+
+	folio = page_folio(page);
+	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		return 0;
+
+	folio_get(folio);
+
+	flush_anon_page(vma, page, ksm_scan.address);
+	flush_dcache_page(page);
+	rmap_item = get_next_rmap_item(mm_slot,
+		ksm_scan.rmap_list, ksm_scan.address);
+	if (rmap_item) {
+		ksm_scan.rmap_list =
+				&rmap_item->rmap_list;
+
+		if (should_skip_rmap_item(folio, rmap_item)) {
+			folio_put(folio);
+			return 0;
+		}
+		ksm_scan.address = end;
+		private->page = page;
+	} else
+		folio_put(folio);
+
+	private->rmap_item = rmap_item;
+	return 1;
+}
+
+struct mm_walk_ops walk_ops = {
+	.pte_entry = ksm_pte_entry,
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
-	struct ksm_rmap_item *rmap_item;
-	struct vma_iterator vmi;
-	int nid;
+	int nid, ret;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
@@ -2527,64 +2592,21 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
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
-
-			if (ksm_test_exit(mm))
-				break;
-
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
-			}
-
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
-			ksm_scan.address += PAGE_SIZE;
-			cond_resched();
-		}
+	struct ksm_walk_private walk_private = {
+		.page = NULL,
+		.rmap_item = NULL,
+		.mm_slot = ksm_scan.mm_slot
+	};
+	ret = walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
+	*page = walk_private.page;
+	if (ret) {
+		mmap_read_unlock(mm);
+		return walk_private.rmap_item;
 	}
 
 	if (ksm_test_exit(mm)) {
-- 
2.39.5


