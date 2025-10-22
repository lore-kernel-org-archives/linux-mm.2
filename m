Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21342CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774818E0016; Wed, 22 Oct 2025 11:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CAB8E0003; Wed, 22 Oct 2025 11:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6894D8E0016; Wed, 22 Oct 2025 11:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5706C8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:33:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 008D6140897
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:33:07 +0000 (UTC)
X-FDA: 84026143656.11.56E0206
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E5FE1C000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:33:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eru66ks2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761147186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bZVnN7fp0G3FFsg6wsk/hleC1984NY97+iWMyaKEDz8=;
	b=QFrG67oA7i9pcMb8PkdNY9B5hH7+ySPTW1j+VEFlK3ho/RpGEeHHW1AdW/wzaV9D1pF37D
	q5/qeeDg21orNFUe8ENQqecOy5nMEXTG9rFYXpzUkWc9g/wpEGYXUSGuViU/6ifaKbdpqa
	EmmKZ8zGI66ONnVzv0LYpFpjClm9is0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761147186; a=rsa-sha256;
	cv=none;
	b=ozm7K6zYhiqSeRFpW6QR2y1jej5d+ZtMJfMTLwmG0h26Fl/Q3Arg9rrVZQlNdJ1t6GwOhp
	42LdbjkjW/3MGo+lGu+i3Ji1gzgoXQnXXe5yB2o5hyu2vlpUEiDdeMga0vLxsMQ5kP9Jw7
	MT6blf0hV3woJayDmWnkXPPKoI4NsSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eru66ks2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27c369f898fso100131285ad.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761147185; x=1761751985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bZVnN7fp0G3FFsg6wsk/hleC1984NY97+iWMyaKEDz8=;
        b=eru66ks2ZHZVYrcUKx8cgpNz3PliWCVtZv5Zzdp5mnpPVevyIo8r00foS34bEZ2ed0
         VksDWTmMHuaAlHwzpIaZgaGl6IFVZeA9Tbvi4Vc24uwyVSqUJ2V34OjqHQKznT9Sd5OL
         8uXxzLnR0VnDdOvxnA5ZkYIhzVhf5LVDWVz0U3oKzTWqH9wc0+wW3TtAwgSBAsaGY4l8
         pKK0KaElQFV++Onebf2n8Lk+G8kHK6+8/gBUGJuL17RYlaaGwfGflIJjvsJK1Dwpkiev
         /f7xdtGScJJb0DNpf5AWb8BgxTJXu38Tq0fuR1zfWoDnbmmLFigeNxkIOankOQ7teIAx
         Tx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761147185; x=1761751985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZVnN7fp0G3FFsg6wsk/hleC1984NY97+iWMyaKEDz8=;
        b=XtLpwC2UXB6GBp56JvZvFXCFFxfwnnyLUa8TjBCsa3OyffjhBqZNAMp7btC8Pk/QGS
         BY+7NfCJz9Pn0JEilSdLeJD8r1m+sS4QpbL/GdhRGVj9gnI4erBsBqoDXA8phHQtaiGa
         j0e9xpYLL3+jbNyRxcg7vEs2sWYOv6XI/Y/E1/iqE0jS0zUf0rKhJN5EybCfjXE9NZLB
         WwLE+6TTiUHj35yd4UAhiaPtb+Egy0c8IfVWm1bMht60M3Xy+RpYR311QInfdeR5XdLt
         RfVqfyMZXIx26ddMOH76GyrYQywG87IiSazyYKVeArHUZEy1c7EQ5Az1ROC6jYMbQ93D
         gr0A==
X-Forwarded-Encrypted: i=1; AJvYcCWuL7PHNcbPdhQwAXu6oDXhRCSRjc4YDVYjdkc24h5zv4QJvzc/LDhwYJBNLVWXOqZHhoprfAgqfw==@kvack.org
X-Gm-Message-State: AOJu0YwbYuMrnxcm/2Mej18fO/cvgBd4xETGABBSwr5UceeTtYZBbDEB
	8UVM0Fkrd1Knmt5dPukCEKFU/nrq8nGrXE/0lgX7sgylTBi8NHnQ/5Lg
X-Gm-Gg: ASbGncuXwAtYNlC7zmbNBuG2qGBX7KcnCOeuH93aQh4jY1jAkkxdmF22LJZ0wS+S+Tf
	Xsm0pQaTlkvfNBIRvQZM7pjzKYH/B+Cnen9UB8EPEmqHb6hE+yzxnbZh8zH0GjaDibv6wPUTZ/s
	KbR5FocSXZ9APD8ucR//x3RT5S/i/gZjPUeDeKf2/qhn9LWMWrbx49oXP5oiu8Rwoi4WXIjPoQ+
	Y7hzpSZy4/Amc9+P2ypr8cpQk6l1YPQN5dzM7umyBNDxvgrOJTRlRyNOt5grOI+aObHgZ5t76jS
	SUTgumwx+Iv6X6x0P/onsIWdQiYc6Oudv7v2jXn84S3rpvcvGN/OqTAdKJUMfCtgua/YekVgap1
	adK9W9PNF/zjjck224Qe/nC9kXPWNlV1mBNgm3NL3wJeAueHWAcs+pyOM+7kcpyIurkPGDR6zyw
	C8SMi4UPKdHH/iiCRXs1zC9YzvEc7Om+G4WRz0sQ==
X-Google-Smtp-Source: AGHT+IGQkq0z/ZJ+qpM4UMe4gES4ssp4l9ztDVvOS3jum1ycvFbCo7Cw2cmJSkRbFVsQ3smyxo4c4w==
X-Received: by 2002:a17:903:46c7:b0:274:aab9:4ed4 with SMTP id d9443c01a7336-290cb65f861mr280258655ad.57.1761147184829;
        Wed, 22 Oct 2025 08:33:04 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([2804:30c:166c:ce00:98e6:668e:c32f:8f4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fde15sm142097195ad.84.2025.10.22.08.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 08:33:04 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	craftfever <craftfever@airmail.cc>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v4] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Wed, 22 Oct 2025 12:30:59 -0300
Message-ID: <20251022153059.22763-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 4jm6ghcwdx4jw7zr86a9ex7zr6qonywx
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E5FE1C000D
X-HE-Tag: 1761147185-718261
X-HE-Meta: U2FsdGVkX18uDM+yRJq0WUxm7pc5b4OUIkMZA2E68vwAgcSCTQbGEm6CQ5rl2onJNgLOw6D9yFIvVk6hncnj/mrGyBpYqBKQwu0hkqVRfrSaZbpsG52S3uEwMenw47urUSU8x9fwR2Fmo4BhChE4R+/Xc+7n0x9m97P97/b0Qe2sEv++skVppaXgGsvtT465XYRvKmWL4SIF1spbqUGBti+yTUUG8vaVZKFsEVeYVYgvWoCrLB4g2Qt3mqDVoxAwYKzCYSaBGIao+QTn8QfSKonQu0E5WN6RQVZpBP70UPAVIipEuaHxQiTTTmzjAwWS+5mzEbLDtLpzzxQYcmjEi1fh2TyGOkrP7yjR8zVeEs4D+v/6mMaBtkwa9Ainpwn52gOrpngnH9sr1UU3ieIgQO95qz/+P27l2dz5XVKUN0DBxmemdX77arrTyqQRq5Z3yxOfp3lj0RHprK9qL2ngKP02uyY6QqptiGOCdxeufnJoI3IYpUJqE+8VKreRaZhObQmcF9UKVmZt1JIG88BEcHERhHnUb6jfYX8AQo1ad4ilyPTfkCogJWKPfYsJwiMZFyjcoRnOU/SzGuKe68vcdfqSTIjJ24rrGxt1ancz5TXbCW3SYUWZz90/aP1NP6Z+u8QFhzfLeY+pwbGyvEBzW3SiWmMn/jtJTH91/pFgT5X4/OKBrLKwjU4SC6FdPYZx4kfYqFZqo4SKT9k6WU04R2JrJlDQOYiU20uj2T2Qel5mt3fW8gRoD5qSnCSYfCPPpxr1TLnrV8rE3UhY/uGsrGaFBSS9BoiIBYTtUgRK3XJnke1qkyazO8l6ty2AWiVZ9/x7uRKdiMhKPuA7fv1lYXjnGPyb3ANDW2l9wTY37COHXrw5prEbX/SPBhe1mzWmncQIt977mjEFQJsLnCrju2CxVpK9QjrzZXtdeDDX9sHy7dM/S40TzOyCTmQDKfNWjNMWCA08Pk02O7cPJ85
 NOP80iC0
 C9J6vuO9e8EYmRWBVXkxB+MnRiQNQ9QYb24jBxOBF5ne9E76i2TKywm+05ywxoiXQHb2R+Wo95M4P1Ki4a/CuYYhdQjqcCRL1wvmqOiyhhNTQ2z8+F2wqC173M02Lik5qQaBJKDio/XBgkIzKo1RbPghhiscMuDBdRHVcfXarvGE54wZ3pJkDd45AiPl3JSaB9H+4dOc36dPth7hbqNx1wiv695nk7md94u1CPk0LUbMcKG+/t0/eOQ9ULXKO8ljYYKc3IhKv2+cv6SeXVLy7bOOG2PgOv9kg/qp9E2E0vNcYZQa+jd+Dl18A7m7I5Rfnf6HDqH/nkO8YwojfpRbJnWGeCiaWTnFTvAU60Uluqo/tYUKWaTKOZI1y3ogqk0drM7gUVVCINnpN342b/OLSeyjhx8GK5GU5d3dSDrRpORExK3yvXEU6rHS54Q==
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

v4:
  - Make minimal changes to replace folio_walk by walk_page_range_vma

v3: https://lore.kernel.org/all/20251016012236.4189-1-pedrodemargomes@gmail.com/
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
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 104 insertions(+), 9 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdce..4f672f4f2140 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,6 +2455,95 @@ static bool should_skip_rmap_item(struct folio *folio,
 	return true;
 }
 
+struct ksm_next_page_arg {
+	struct folio *folio;
+	struct page *page;
+	unsigned long addr;
+};
+
+static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	struct ksm_next_page_arg *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	pte_t *start_ptep = NULL, *ptep, pte;
+	struct mm_struct *mm = walk->mm;
+	struct folio *folio;
+	struct page *page;
+	spinlock_t *ptl;
+	pmd_t pmd;
+
+	if (ksm_test_exit(mm))
+		return 0;
+
+	cond_resched();
+
+	pmd = pmdp_get_lockless(pmdp);
+	if (!pmd_present(pmd))
+		return 0;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pmd_leaf(pmd)) {
+		ptl = pmd_lock(mm, pmdp);
+		pmd = pmdp_get(pmdp);
+
+		if (!pmd_present(pmd)) {
+			goto not_found_unlock;
+		} else if (pmd_leaf(pmd)) {
+			page = vm_normal_page_pmd(vma, addr, pmd);
+			if (!page)
+				goto not_found_unlock;
+			folio = page_folio(page);
+
+			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+				goto not_found_unlock;
+
+			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+			goto found_unlock;
+		}
+		spin_unlock(ptl);
+	}
+
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte = ptep_get(ptep);
+
+		if (!pte_present(pte))
+			continue;
+
+		page = vm_normal_page(vma, addr, pte);
+		if (!page)
+			continue;
+		folio = page_folio(page);
+
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+		goto found_unlock;
+	}
+
+not_found_unlock:
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	return 0;
+found_unlock:
+	folio_get(folio);
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	private->page = page;
+	private->folio = folio;
+	private->addr = addr;
+	return 1;
+}
+
+static struct mm_walk_ops ksm_next_page_ops = {
+	.pmd_entry = ksm_next_page_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2542,21 +2631,27 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
+			struct ksm_next_page_arg ksm_next_page_arg;
 			struct page *tmp_page = NULL;
-			struct folio_walk fw;
 			struct folio *folio;
 
 			if (ksm_test_exit(mm))
 				break;
 
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
+			int found;
+
+			found = walk_page_range_vma(vma, ksm_scan.address,
+						    vma->vm_end,
+						    &ksm_next_page_ops,
+						    &ksm_next_page_arg);
+
+			if (found > 0) {
+				folio = ksm_next_page_arg.folio;
+				tmp_page = ksm_next_page_arg.page;
+				ksm_scan.address = ksm_next_page_arg.addr;
+			} else {
+				VM_WARN_ON_ONCE(found < 0);
+				ksm_scan.address = vma->vm_end - PAGE_SIZE;
 			}
 
 			if (tmp_page) {
-- 
2.43.0


