Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAF9CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 03:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5A28E0006; Wed, 22 Oct 2025 23:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3ED08E0002; Wed, 22 Oct 2025 23:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CFE8E0006; Wed, 22 Oct 2025 23:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5858E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:59:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BFBE160A0E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:59:24 +0000 (UTC)
X-FDA: 84028024248.07.44BA5F3
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64D23140005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:59:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LsnjYVmG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761191962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uBFr50VAHKuNJ79/3zzKEUWtJtP4n7VCTW0+FuPTSLM=;
	b=gwY0SbCqAPi+yjs+yC3C0BGYmCMpfUTRb1ZIUy9EFA8Xi3r4oY5ksUzX90y/oDbXwGMZeJ
	xoxLo0nTkwQrjTKRtgn2lTMaTWHGpB7yy6a/KZnEZAMEatssRn2DHrI7eIyltIWIfInua0
	m+u25UUGQGVS+i3R3eLGRcQ6UfZe21s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761191962; a=rsa-sha256;
	cv=none;
	b=2v0J8WknvCKXutD7MS/fR54eZZLudaKjqDlsvQVhjwajLe1OYUZW0ZuPtNtCvuPF2bItPE
	4XXDC+zMUEghEWhfKIN/1dfoFZe5UuYUBJZdYUfWtuPKm8k6k9pXK0ZDviXqONnRSrck78
	Y5HzdJtPpNowfw0i/tYkuT2v0ROYD6g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LsnjYVmG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-59dff155dc6so211482137.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761191961; x=1761796761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uBFr50VAHKuNJ79/3zzKEUWtJtP4n7VCTW0+FuPTSLM=;
        b=LsnjYVmGQRymTMpdd+1fy52Fb7MaEaClcy3wrSRjDmxRXYuMXJSjujpJKItFpvTcgL
         Pcn4t+3SMGIvtKRhkUNxZto6e0b0uTLlp4Y+lb6b8uVN3zkq2i8d2Rom8KPRvusYzQWV
         bUikW/XuigCb/RNsjElhQB2tIAXJGal+0xtpgP9KVp4ndFuGtIYHKND1/S7Gyvth6t93
         qWm0+AkpIZkovh/HJMcFN27zSSozeDeePZlyLcGUsOumkCbS1NG9Kxmws751CoZG8w0y
         CHuMBKOEFGY+fRyj05X31dVjcMnFkvxzYrshErJBuQtg3jdJ00JC9NqvD+dBfUj1M4NJ
         j1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761191961; x=1761796761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBFr50VAHKuNJ79/3zzKEUWtJtP4n7VCTW0+FuPTSLM=;
        b=GqClW2Tfw4qObZ6EqP9twn2J4ScHLWDcVfs75Rk99qXBqKTpf1/GuBuFElbR+PCfcM
         4Si3xBRhQfCkUjNpZ646NuBywMqMFdo1cyPcF2UZGvn1DdxjJZHGZ8pT5Q9dSWwtiRfL
         GxnBld2UFOTQUA4cVWuNyGF3gdxyvweICneVHX56jPbtjd0Eftfcnr466PQ3Ow5qCiSl
         0i2Q84fRJNduhsnSrAvDZHqA3nWisv0raCIjnAui9wPqF0E536rzP8I0H212Z0fi3GJg
         CkVf+BvADR8UsZUkiObWt56sZkFhAyKbKXDVFqvpQQjUUFaTXjx1IMqjLwe8huvo6fmD
         Zfeg==
X-Forwarded-Encrypted: i=1; AJvYcCWss7ueZPv6WKw9ru6JadYHcpJNe2O5aBKkXn0JfBs3p30f0chfz9MNp6Kyop/Xv0PJxZMlWUO99w==@kvack.org
X-Gm-Message-State: AOJu0YyDcM2Tz9KhrW1FDf6Ygxe3oVM4sw/a4wnrts6CV9LFIikcOWLZ
	anMeweuuMVkZ5RU+cUJqNHUEEQj28jzg4M/rikxHG5Z/cEyhUQYeRZql
X-Gm-Gg: ASbGncuiiJ9noYIcTSwAfZ9k0zpekVJytpZArhgai79vl3+zrTvk8MGqRxwtNQMLnuC
	Bm1fWrNRZWOLGLMqTjmisobruNgnvma7r1vERr8jnWBJdFKHQaanO6Tkz1dZydhdmiBXJdVMo1P
	7uQkxpVPbODHx1MERpp310QWg/xB4vtLYp02XXkugd5TpSKArjnZ++wTutp9cgwPst5X+QhEFUY
	aEX9l7gKHrY4NB+LTq8dXGp8MPIzhUgmAiq2exjbjAggUTgjkjY0BZ099y3C/Dji0Bn/IVVri8k
	m2oxnUwzQ8aJTTb2wq7bc/0ffuEB++X8xv7caEz88YJdvBLNitkynjjuSWdo0uwVYQ359sWppbK
	XjZSR9fK3KnQsvU2YkGCddI8WyA7MWxVHjhZLGQP6O9HpbgI/vCIcxHzSSvbTvjbrQ9ENHce/v5
	sRvdBxP5+VrveIo2k4TVBR6++v
X-Google-Smtp-Source: AGHT+IGDEz4I3SDGxTKHO/dcy4ftehr1KubXJjEYnYXzSyK6ZM2ct6mXncFjBzsBf0Wr3DOzlbS+Ag==
X-Received: by 2002:a05:6102:e0a:b0:5d6:5ac:3902 with SMTP id ada2fe7eead31-5db2e55416amr190456137.21.1761191961312;
        Wed, 22 Oct 2025 20:59:21 -0700 (PDT)
Received: from ryzoh.168.0.127 ([2804:14c:5fc8:8033:f287:781:fdff:28fd])
        by smtp.googlemail.com with ESMTPSA id 71dfb90a1353d-557bdbb82e5sm402835e0c.14.2025.10.22.20.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 20:59:20 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	craftfever <craftfever@airmail.cc>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v5] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Thu, 23 Oct 2025 00:58:41 -0300
Message-ID: <20251023035841.41406-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 64D23140005
X-Rspamd-Server: rspam02
X-Stat-Signature: 5gf5pyc1f96io7j84wprhyffe34ycej3
X-HE-Tag: 1761191962-227383
X-HE-Meta: U2FsdGVkX18SKyGc7iY7+obOYWNtFOb/C+Lyn6brcryPkfx1qEAAGRPU1QSJgQV0u3MYWCFVsonPdHVg4/Ctw3fifgq0C6nsXkePVHIKNqLnESz6DaJCHnxCX9RJDguvfIGD8HEzW15ZlZI4da1gVJQBDHU9dnctHwbheMXa+yFgRdrx87Vcv2UtUcp5gx34vBH6Cp50yqNRRJdrExGhnGsT1h+fMjzU9Zcomn+8DMfh3cVEswpBnCnb8A1ednhpU4cjKNUxXsL7rluUN4UKIU500yB0ccd0/hUoWF0elSwGaGZ49/R0XULbvLKAkSiw/Zf8Z5vSvq0gROihmKdwG6QQcUwcqi0uruKL1Ktq//c73Ogl6AcosNFvf99aWqwe95gg9gvOV2JdB7KrQtPNJ/HPCMyHwqOYMN2yylB0wcSKTpoed23raZ2C5IylKBqtnWGy5ikouBIZUUHdRHm6iKROUj84JnBLky4oaCLMOGRCSOtWM44y6AW2L5qxnY5Q9Dsy6tPdAzUA2YMc+Shhy/arvlH9RQYv1i+ezfGvQTHByhrtf1Nhn04xJwB9ga8HlFGGfpde5vwuLsiJx8YiIc6AJANs1GrDjtqbxFRIEm703E1Uxkn/vkjsb8WJKz7OBUO6cQkZq+l7RN3qns+cdFdUPrC+N7ickVrjTgqOzxSeeuTZ6fiewl1ImvFsT8mD3uzwDTNKN8nW/pTUIJclQ5j5ZLUpf89475ALLl5Dyh1ctQVrLhtNiukLGF4OBDD7KlvWR2q32vU56tDX3uZZB3+4Qqy2lVIUBBBmhNFhPxR4SrYiqEcGiGr7DHpdDJfcbuRi4G60nGnBORMhWQHudAy03b+t3/Cr7QTaZr5HWbwxEulmjeYLV+xxYgErq1dlY8HGZyHGTcq/0SXiLKx8FNWRNhoXKYhnAPEbWG/cSiQWESH/xi2JZ8gv2gJ+38hfkyTKntM0rb5N8M+cq76
 hLbiCkod
 1+89E6MpG0UblEwwaPuvqKTpuDc1pimfg9hKiRg1WN6m7a1Cvo8GaIY6MKlvAsld0d3tHZ4zHoMQnH7ObWZXa9t7lIxoa9lj4pmhMletO1hitxt396OoXIOJyEP+vJjXkmydMNKfLfyx7LDpdM6oBerRFamjBiS+2V1kMq9jKDZUl1NrpDJfqFjLnWjmZnGNIb+2+dzBfU+EELNrmfelI33Nk8y1FhqEzGriWJtGnr3fz0/byNhpCefvsPsNIYsIWPrXYjtCU8zd29KhNl+LrK911unyQWpHdeqbpmf7ZFN7rBGdh30gf250piOuTG5olX4ooz/dKEWMSKqkoLpcHbPISwdE9sE6wuxnAxGFMd2XKH26iodRpz6qZzYizkF4UjNf+RQ19uFQvRWfMTb87G0//6Dlk78vt0Czqe9K6qE0a3qrxKXrMZsvGzrFboJoLBNU9Rg6csLLkoCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, scan_get_next_rmap_item() walks every page address in a VMA
to locate mergeable pages. This becomes highly inefficient when scanning
large virtual memory areas that contain mostly unmapped regions, causing
ksmd to use large amount of cpu without deduplicating much pages.

This patch replaces the per-address lookup with a range walk using
walk_page_range(). The range walker allows KSM to skip over entire
unmapped holes in a VMA, avoiding unnecessary lookups.
This problem was previously discussed in [1].

Consider the following test program which creates a 32 TiB mapping in
the virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        pause();
        return 0;
}

$ ./ksm-sparse  &
$ echo 1 > /sys/kernel/mm/ksm/run 

Without this patch ksmd uses 100% of the cpu for a long time (more then
1 hour in my test machine) scanning all the 32 TiB virtual address space
that contain only one mapped page. This makes ksmd essentially deadlocked
not able to deduplicate anything of value.
With this patch ksmd walks only the one mapped page and skips the rest of
the 32 TiB virtual address space, making the scan fast using little cpu.

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/

---
v5:
  - Improve patch description

v4: https://lore.kernel.org/linux-mm/20251022153059.22763-1-pedrodemargomes@gmail.com/
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


