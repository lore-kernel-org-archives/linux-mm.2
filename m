Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF383CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DA2280004; Tue, 14 Oct 2025 11:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234DC8E010A; Tue, 14 Oct 2025 11:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12412280004; Tue, 14 Oct 2025 11:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02D238E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:13:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 866D01609A2
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:13:34 +0000 (UTC)
X-FDA: 83997063948.02.7A6E13A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id A77CB20010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:13:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=keEnK5FB;
	spf=pass (imf03.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454812; a=rsa-sha256;
	cv=none;
	b=dsUUmp2D904i0LJ/bIkrm6OyF5GmGzawzihjchLl+stuYlw60A874gku/in4k6ZNTfzgqI
	pqLwmwbPTQdcHO3u9nQz0bV4skNum+EJTEXRWfcfigxfP4DueAZoMLXpqK/T/BmmSFuPFc
	9IVm1S0/FKMjcAGs73+xBpZRJ9sOL2U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=keEnK5FB;
	spf=pass (imf03.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3YnuagVQhWuUMR2PB1jU3wT9rK51QVbuJQu2boh/UDY=;
	b=xvZ9cS1jGlAnjrO82DTTQhG4DczwP8SsOS4XyK8o6LYtvKv+gkdRDGtEDhiaYZLkVVd0Fl
	G2xkPOHWXJycNnIhL64JRdOQ/60wVpniDBCbdG91JgPYUorcKF/O9m2eLCanN0rqiqCohX
	VnZZM2uIRWQCDX+kn8+GmHCieVK8spM=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3369dcfef12so6159183a91.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760454811; x=1761059611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3YnuagVQhWuUMR2PB1jU3wT9rK51QVbuJQu2boh/UDY=;
        b=keEnK5FBUo3ElzvyJ0eY6nHDg2/9ymjW/4zNEu9yH2KWHv8I+f/BFX9lZ8cWAAlOOG
         e9idHl5YpPqS5Ad/dlhVRuSJOtzDnZJlNh2NxMCohlONFL2HLoFXCy40Vn2lpDIREfFd
         oL1BR4MRmThEq3YLxynBTuok9UDa8wZYB9rXtvBdbVmUEAuPVb/Bf+sc/KcsALFjWuOo
         xmL1t3lpoQu58jHINv8EOjjJ/jgXbVHDKlW6Q3+IkLg7yOJjB8uX9o1w+ck4cfv4x6ZW
         KnorLitPMk/SvdlW/5zYtaFg7Qv85c5Gl7k1o8G9fqLOdGv7fC13L/s5u6CfHwxJeq+S
         1+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454811; x=1761059611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YnuagVQhWuUMR2PB1jU3wT9rK51QVbuJQu2boh/UDY=;
        b=wgqX1vc3lO6oNAkGzeyNiC1hpn0XSG+fI7ZgzZyAdK1IleC8dzXA87adIH5BGkLIVR
         DHjiC1/oXIi2HtuUu8nRcDvRNdy6skuMOdwbgmDkNPNEboO/tR9HoUldje8a9xZSUKZ2
         y3bJMZ/+rDK1yAVH8SdrFOPAb+O1hgsEL85B+oXHfVHn2yrEuryQ3Q78Pjz4QZb4fRSO
         xNH5tXdg62mdplnJ7xXlS2rQuCLFUuEBGdTeUkJL6hUCmvOlM/Q198mpu0JH0YhQFHIv
         l1qcjUEK4nM9lcDKIgftQFRdMrU2tGPRr9pQY2MFMaumpCd7v5FteHiCOA8M03RLsR3I
         JPBw==
X-Forwarded-Encrypted: i=1; AJvYcCVqVNsmLMRSA3dFE6hwiMRkgE5zbh/GntdmFZFXr4NnxRp2lnsb/cy+4p/dtVBmsjQaOypjnAm/lQ==@kvack.org
X-Gm-Message-State: AOJu0YwHuber2fTXyMfRhjrmQXuanf21NayxZoKu+XY6TIXirW/ZUqT9
	DL0hl7Tz97pHGx6hPgONZcqX+UDL4oM2X8Z2aCtHGpPC5ZPJ2+iR4AXK
X-Gm-Gg: ASbGncv7XMldn4QC1t6BLETDC2PfaLXeYQSeAHtnF6ho/jQN2js9nIZforYHXU2dNHx
	GFb9yBnZ+29UKHsJ1ir8AdtwYjthhhVItpF+8wNB5owGtoRIQ32HgsuC/dn5kQWu8Avuqh7nAeq
	/kBf8hU1TvCUunVz3KNdbR0q8WvOQLEXmbW/aOkYG/RbL1rl1M7MrS4zm0El7ojjRoX0QurMAPf
	LpL9YCH6WiuQm749q237LpMVCIOG8Va83KuPenba2z3DrUuruFPCIUHjb5uQE8QxI9G1nB7ZNWJ
	/Fd3jdrJP3zMzTf39WzDcWImHCA2cfxoqSxbnBq4W/nQjmeXNWJ45xAK9mSjVJ6GyzuqJfeBjoH
	RGrDcGyAqwYT6jr9zqOA+utnFQ/58fCnoSitzy4WEnexFdVBmVLz66ZTCkh9QEp0HFWohRw==
X-Google-Smtp-Source: AGHT+IHZaYrpTZsCpzU28YgFxe96AWH2+FxFsemxJUtqRP2WWTlSXzbE1fa9gpGrsEXNanTSOrDHxg==
X-Received: by 2002:a17:90b:4b45:b0:334:2a38:2a05 with SMTP id 98e67ed59e1d1-33b51148b24mr34555313a91.8.1760454811380;
        Tue, 14 Oct 2025 08:13:31 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([2804:30c:166c:ce00:5a20:94db:a4ce:661d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b6192995asm16402028a91.0.2025.10.14.08.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:13:30 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Tue, 14 Oct 2025 12:11:26 -0300
Message-ID: <20251014151126.87589-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 79pzp1raxcmoqqrdf6ya9oy3h49n6w3j
X-Rspamd-Queue-Id: A77CB20010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760454812-181308
X-HE-Meta: U2FsdGVkX1+XMxxy7VyQ9ASqcLX+qWXIx5wL59B0w/7OMaJeMRd6xwhQ8I79ElMnSexMNEDzKmwcwcSsVFJAVYebsyIGqZ/cF+EwV+Smhccmy3h9rd5yva4fd6N1x+LKOAxAHV4QxUeFJEcUY3ODN51q44Bg0vCwEWoppxF9e/MwKZpVCL4wLjF4xUr3D/1zYk00m8Vssqd9QUn5lhM+pR8d06ur2XGAW9dwRADNmilT6OWzR64hxjjY7fcF4IGqG56OFIgPFmBxbh9rUA8L9DSxdNxEkT646CxvRNmySr6SI9lEpc8hcDbWLRTiTFTwikRLycMBtmbvVjN4lvBHiWGW1FzIMCHbfYm6KBY+VxLYWlv/YJAG64Xe5rzzkzuXai7ig8s9iwUvtT+wqsdIUSE5LeRoZst8D2fDuup2GTRRD6YvlAV45Vt/+WGeN+dNL6+cagqHJ6MptYJOYwvkGcgs3LUTvsQgRo/5fDSRDPqk4Lli5dcY+al3th2df/Ej/XYV8WSbIGSVDI32392bU4nYxXSagWzdN0EnD8hoFVk4dt16CbyYBRr10BhvZkrByFZl6U76v4WOzlaBaYwrvk91FDJWZVKdkRYBMS50ww+2R2yq7RwAqYYxxr8gybvdwUSRQcF53Q2kaUWBjKf1E/2OYzjTunymttYgOg2X64CpxEsWh+Ms2zP9iIiqEmALkWyoJNCEzUjt6MflX8kcVVI9iEgP+nrSQitKjWGWBizLyo44Ab8EView93GYjseCWE5lKrS4KgeOW0ocz9HyAS84Yc5OMyP8j1PkqkzK5bF79ewKIiExksgLoBd5tfTXI3W27OdEXPjhqXbMCewr829/81LMtufeEXaYDOUrIofPHQCfUf5vX49J0u+CASPE9PQxoxjO8qcNakKzmKY30zU2Gh1+JlHp07fEzoprbX6LsiGSu0B92bXMUb+QyYeKbgmAmyhiB8vIftpJQEU
 3MCLVEDw
 RFUGHIWLYbdTQ3FCHK7rQupJ+yTJYKLV1ih35C8vE4eUAS8tlyAyxVa7WUU2E7pjvwVUUKXQ8rYXaF90P9ftjzyv6z4IUryGTeAlkjPW1O0YYzx9nH3EkSj3wE5w/1VQsAFQKQzHVZJAPcwxrBlnn/XSU7A9bVMQYY8BDEkHKYTAWztV7M2EZvznqWvm4dmwCRwuj5ci1edFBtRT0hPH3VOPymC08vG90HErjVZ8wpJB5tqBwiD3oyC2R8UFZogECr9Xnjut55y4Yhr3uDlzASeFC5gT6CYCZNnR3VDyyDbm9seg0cuNepFiNcxoT5hCjKUb559VdGZkkXWoe39gaDaVt8wGGN3yNFziNGEiVJ2BXviGMjOUug1EbcC6Qs5EkrQL03DP1+s4lWEtfF+KyVJo36Px3AZNpNDvJqGqmJo84kCMd9uq2q2OlebuOYBNrE+uRqhTs8hzSDKHpCErhf6W7Ab7DBNwDcXvqfyGKtOy/r8ah/1ZFVr76cYMLWnfV7POM
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

Changes since v1 [2]:
- Use pmd_entry to walk page range
- Use cond_resched inside pmd_entry()
- walk_page_range returns page+folio

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
[2] https://lore.kernel.org/linux-mm/20251014055828.124522-1-pedrodemargomes@gmail.com/

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 144 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 50 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdce..adb0267a1b7d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,14 +2455,82 @@ static bool should_skip_rmap_item(struct folio *folio,
 	return true;
 }
 
+struct ksm_walk_private {
+	struct page *page;
+	struct folio *folio;
+	struct vm_area_struct *vma;
+};
+
+static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+
+	if (!vma->anon_vma || !(vma->vm_flags & VM_MERGEABLE)) {
+		ksm_scan.address = vma->vm_end;
+		return 1;
+	}
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
+	spinlock_t *ptl;
+	int ret = 0;
+
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte) {
+		ksm_scan.address = end;
+		return 0;
+	}
+
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		ptent = ptep_get(pte);
+		struct page *page = vm_normal_page(vma, addr, ptent);
+		ksm_scan.address = addr;
+
+		if (ksm_test_exit(mm)) {
+			ret = 1;
+			break;
+		}
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
 	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
@@ -2527,64 +2595,40 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
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
+get_page:
+	struct ksm_walk_private walk_private = {
+		.page = NULL,
+		.folio = NULL,
+		.vma = NULL
+	};
 
-			if (ksm_test_exit(mm))
-				break;
+	walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
+	if (walk_private.page) {
+		flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
+		flush_dcache_page(walk_private.page);
+		rmap_item = get_next_rmap_item(mm_slot,
+			ksm_scan.rmap_list, ksm_scan.address);
+		if (rmap_item) {
+			ksm_scan.rmap_list =
+					&rmap_item->rmap_list;
 
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
+			ksm_scan.address += PAGE_SIZE;
+			if (should_skip_rmap_item(walk_private.folio, rmap_item)) {
+				folio_put(walk_private.folio);
+				goto get_page;
 			}
 
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
+			*page = walk_private.page;
+		} else {
+			folio_put(walk_private.folio);
 		}
+		mmap_read_unlock(mm);
+		return rmap_item;
 	}
 
 	if (ksm_test_exit(mm)) {
-- 
2.43.0


