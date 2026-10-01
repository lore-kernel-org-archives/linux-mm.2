Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A1ACA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3D16B008A; Thu,  1 Oct 2026 11:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5216B008C; Thu,  1 Oct 2026 11:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C9C6B0092; Thu,  1 Oct 2026 11:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 218496B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:10:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A617DC044E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:10:38 +0000 (UTC)
X-FDA: 85274394156.14.F784266
Received: from mail-dl2-f41.google.com (mail-dl2-f41.google.com [74.125.229.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id C1526100009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:10:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aMItt9AZ;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.169 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790867436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7HO9HjcV+veIH/3O4cu1aJQGXCcymcqVyGYdv+R+ZPE=;
	b=BAQGoPQeGYjRHH+UTwOf1gfgMKk79dSL7cLKmCZgkZqQAT16/JjsHQyKAteHZI+0tgn9XD
	agrN0nMzECYV7WQdnTZfDxakgyb2Ya1jllRTnoONd7PpoBBDSYPykArIHVZbZNE7HPXn8W
	KKgK26AylZ+nPeQJuxcaHKFh8VVpkqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aMItt9AZ;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.169 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790867436;
	b=MxfPGZWOBihCeTjmu3IMK8/k9q2Jwgmfhl6g33VAqx49hH0U/5cFHXMakhqwCWvZq8VW/a
	vY1732d9JdOsf6+QlZgmhvajkWGvdP75DcH6lVYjRF+PaEO0BUUWefi9s4s+eFCFSjMH6h
	oZjVRCiM/TwXl4IP/RXSqWR49NvANf4=
Received: by mail-dl2-f41.google.com with SMTP id a92af1059eb24-149d5ec8e96so1587238c88.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790867435; x=1791472235; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7HO9HjcV+veIH/3O4cu1aJQGXCcymcqVyGYdv+R+ZPE=;
        b=aMItt9AZCFUxls4zPUAM4kS0j5lmqtbe4solXWCR8J9nJS6cq8qfGWu8bL6gtVAhAb
         /ahIx5NJ2pWnrZVlSr3svRchhv19Isugj1g2ZPtueVll3fVr2vrZQeoJBvD+4eTRms3H
         xFYk9t6xGdYXsTJF5tb+YJEHWcun1q5wIP7LrbZPrIs9B9GxABYkpoVSqFVUoCF6zn8O
         dUtESeVpTn+jnvK+O1PtS48Xwm5iM0nbFF0bs/qq4qbjoEkfSXJZUdWvElRRxSqsD8OC
         hEB5Uu3/TiIQnGAQD033nMy1wgv2cL4o6WzZQHhrN5lcpBClPREqf6zFSIPdNuJtA5rw
         Istw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867435; x=1791472235;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7HO9HjcV+veIH/3O4cu1aJQGXCcymcqVyGYdv+R+ZPE=;
        b=YhI2phq0IeDNznvfrVTcgxP0FZVQVu4kKKUM5xkwTxDhPl7dKY0WaG3J0DG+3LfVAn
         v2jT0O7ELy+6l3oYrDAHQ16fSO/SnRFUknA9BGmBCE9wqg1/k7aU6LgR9aO7H7SqlZbA
         fNhbjshor/G4Xc/if5QzbwvxvyuVXogMwR/6mgJotae7BRIYCGHtCMmylwSZd3KSiSPC
         9HiUs4nGJAFtpAPZxDDpmSJhmN1R35WvTbF1y+wQSb89p4k7PPnLtFdusld3HxQAj2qr
         ucp9TLRtQX3BMorc1b5cNwOD+lnp2Au7ZBnzaMs63lsv7K7lm33swhMZK/ouXYVYAlng
         pIvA==
X-Gm-Message-State: AFuF++naXD6/AHyrSpyzTXfsXXLQ7+EAy0JFE/JMb7+bwIR18Xs4uBlh
	XBkf3HGIPiA8leBZAkQXw6cDRqWHdZleJI5JIAm2kWojWR3s8XwZA8w+
X-Gm-Gg: AYBFou2UO0j+FyGECBUX/AqVZ7LM3G7iF5gqcZSDIqwiZH9J471EaH1AnTiT4zV0TuY
	Q3IHSX0B1Jbm13R4vA4CmrqGBalYHh+DxYK3+sOmos8gBtZL1YpbQj6GA0Yvs4paUtBS6CUJSAn
	63nh05wY4kFar6Q7cWedc2+TFYKriCkITmo6Socbg/sK//CPZBGzhHsQvoM0pS1edbw9K3U1fdI
	zIciqFBnKhLn1umhseuqr78XVjwDihNlwPhErBFDSrQnSFkIgZOJCBp0IMSyUrz6ApsymdrPOvg
	s9aBqGKPQxj3XqudQ4z87R9iWu+UuDx9wZ+wQnfYaGnHWdG4LlNXCENwYcLvLN32Utec39TjtIK
	wPVsWR+iuaCgnmQKftXXgx0TSYAI72gwA2jFj5+pg9UMxALidXle0ldbcmEajZW1KzSBYn+Omrb
	17cZ9evoXAI5BEpbFUSEKJerjve+uRByw1VmJ4sAasykbJgt/HXMnovQOGrWC7WqoE6w==
X-Received: by 2002:a05:701b:465d:b0:143:26eb:18ea with SMTP id a92af1059eb24-14d330b0e85mr4662029c88.29.1790867433781;
        Thu, 01 Oct 2026 08:10:33 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f2766157bsm37986c88.12.2026.10.01.08.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:10:33 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 01 Oct 2026 23:10:26 +0800
Subject: [PATCH] mm/migrate: look up consecutive pages together in
 do_pages_stat_array()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-bug-mm-move-pages-stat-batch-v1-1-255b7e915744@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOF3vmoC/x3MQQqEMAwAwK9IzgbagnXXr4iHqLHmUJWmiiD+f
 cse5zIPKCdhha56IPElKvtWYOsKppW2wChzMTjjvDXG4ngGjBHjfjEeFFhRM2UcKU8rLt6R+zI
 1H99CKY7Ei9z/vh/e9wfq4ZDzbgAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1526100009
X-Stat-Signature: k78noawbb3qp6j8jujn4mpex8c3xezd7
X-Rspam-User: 
X-HE-Tag: 1790867436-562010
X-HE-Meta: U2FsdGVkX1/Rp2kcclccBi/XoFN5TEZLtWFcqBgeo/A1ZvUAf/gdI85bMueSNib5TnWIxM8DCgObWrArNGlWqNidBSyBKhucCwl22ziHZYjGn62kKWlAIP4yO4uUhmnMPlDg8YNyx5olad1NXHwgBCxpLFcDKiGdZlEFSv8PPwRAn4AyjLn7omFBUWTZcUVCiV49OOa/ZM9VaeWVJyGD4AE9WXt3sDB4U68L67wNXqnM8c4W5oJ0xe8gQcm62Vl6Rl+zRgP41SeM6irGg6oJGVokTPm45RpcFiL6zATsNANmRDKticd8vNHHd+L7/E4qg9MdgFRzJPPToyavHXVMdr6p0a5az4M0D07Uy/I7vclMEQtkrSj1XkLvHNIFu95A64KbmwUnx41OmajIR5aalEvO+Kt8A5a8EIQkMbTJ0rXWm1VagNkCcIKaLRe1N1qAIXXshbL4+KJlIcLmTRQ/VmMFxiDm6ebA8wIJUVmSO2VsfjH11CBEngYqrhQHB2jT/9TjutB2RXyLKNBFaFosCTRzAGLly2B2JYQxm9I7MIrYv8AYrDaeOXQU520UMvbOl4Wx7VwRTyhN48NQaRm0jbfYYogdpdyC3GLK1a9LDq8DzIk0YX20TdwgiK+3NPXRmka8E0FLEdJ2vnwGXE+/Zuej+yIcw1Y1X+MtVZdSzifcnUmVaR6pEtw6JlGXK6xe7fLo5Qp0WVJ9SPFCBTJZ0fM7gcGMwpT6+hAj79/v3Vlb8zn5JGGDWOYPCJ+fw4rh2FNedhv3m/q2FyAkvazKbznZ/qnpnPibZwswk5/B0i/3yfENybj4VNb+8DbvHgHODvRQtIqnA2i+pAxguzMlDDQkswjJ0L/2rBHM02+Od1pVLkvOhYzh+SSE7rJF95eT+YtxevXO8ZKBG5iHzYezjZHM4/hoNISXrVPgdamkyZBWqWhfbOLPxyT4d5H6Rcwnsk3iaOWPWKF53eqMpCn
 Aj8EedPU
 MWysSeeVe8VZipEV4I6xLdwiT67XL33dyD9sWoSnoaLdDYASXcyQuIYYygr/N2qMk6ZqQgg4LSNHc865/1Ho8I/YZ4q5y5NhpHgO0mFS6R+Ww3Qcw8r07Q3sEAPuIeQr0SrFUu3+XJkwHLaYcRvQWldFdzh5foxqov3xQY44ttvNNS+OXKn+Wm9qQCf9mldbk6kF25JCE4PiiijGI5Ni9NvCeC9dfZVGVQvx6Gq+tY4pUdlDBFEOcAbAm+k+kXKLOhjBba8ft83YL0OtnQAiOW3BfsxdvAL+jE46AMKrxoS8iv2Y9MwJPZ1uxTyUSxGT8xXNGmGHg+mGEoxgzcy7ZsyB6ufr6CrhCOlqp0hYmeu+HEOIUXwypeahnKWQ9NVMh/DeUfDLR/3VpTdk64BM4l8+7TXxi1iB/NSJvJBZFeYSFV/kuO4ydPij5Dr0piAe/ne7KcT0kyYUMo230z+JtMvRV08MiOr0X+hKw49TkIMbi6q5oeyEn0a0VVyTUEV4hCYj2AC1PjJLxl+NoUBhKkKTS/L3yBxkFoNqiCnuTZg+WXlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages() with a NULL node list reports the node of each page. RDMA
and KV-cache transfer engines use it to find where large registered
buffers live, querying every 4K page of buffers that span hundreds of
gigabytes.

do_pages_stat_array() looks up the VMA and walks the page tables from
the top for every address, taking and dropping the PTE lock each time.
That costs about 105 ns per page, so a 16 GiB buffer takes 440 ms.

Callers almost always pass consecutive addresses. Reuse the VMA while
the address stays inside it. After folio_walk_start() locks a PTE table
or a PMD-mapped folio, answer the following addresses under the same
PMD from that table or folio before releasing the lock. Other
addresses still take the existing path.

On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated buffer:

                       before       after
  4K pages, per page   105 ns       22.7 ns
  THP, per page        92 ns        13.1 ns
  16 GiB, 4K pages     439 ms       95 ms

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/migrate.c | 83 ++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 22 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa7..5f470dc7dc746 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2451,44 +2451,83 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	return err;
 }
 
+static int folio_stat(struct folio *folio)
+{
+	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
+		return -EFAULT;
+	if (folio_is_zone_device(folio))
+		return -ENOENT;
+	return folio_nid(folio);
+}
+
+/* Look up a PTE in a locked page table the way folio_walk_start() does. */
+static int pte_stat(struct vm_area_struct *vma, unsigned long addr,
+		    pte_t *ptep)
+{
+	pte_t pte = ptep_get(ptep);
+	struct page *page;
+
+	if (!pte_present(pte))
+		return -ENOENT;
+	page = vm_normal_page(vma, addr, pte);
+	if (page)
+		return folio_stat(page_folio(page));
+	if (is_zero_pfn(pte_pfn(pte)))
+		return -EFAULT;
+	return -ENOENT;
+}
+
 /*
  * Determine the nodes of an array of pages and store it in an array of status.
  */
 static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 				const void __user **pages, int *status)
 {
-	unsigned long i;
+	struct vm_area_struct *vma = NULL;
+	unsigned long i = 0;
 
 	mmap_read_lock(mm);
 
-	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
-		struct vm_area_struct *vma;
+	while (i < nr_pages) {
+		unsigned long addr = (unsigned long)pages[i];
+		unsigned long next, end;
 		struct folio_walk fw;
 		struct folio *folio;
-		int err = -EFAULT;
+		pte_t *ptep;
 
-		vma = vma_lookup(mm, addr);
-		if (!vma)
-			goto set_status;
+		if (!vma || addr < vma->vm_start || addr >= vma->vm_end)
+			vma = vma_lookup(mm, addr);
+		if (!vma) {
+			status[i++] = -EFAULT;
+			continue;
+		}
 
 		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
-		if (folio) {
-			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
-				err = -EFAULT;
-			else if (folio_is_zone_device(folio))
-				err = -ENOENT;
-			else
-				err = folio_nid(folio);
-			folio_walk_end(&fw, vma);
-		} else {
-			err = -ENOENT;
+		if (!folio) {
+			status[i++] = -ENOENT;
+			continue;
 		}
-set_status:
-		*status = err;
+		status[i++] = folio_stat(folio);
 
-		pages++;
-		status++;
+		/*
+		 * Callers usually pass consecutive pages. Answer those that
+		 * fall under the entry or page table we already hold locked
+		 * instead of walking the page tables again for each of them.
+		 */
+		end = pmd_addr_end(addr, vma->vm_end);
+		ptep = fw.ptep;
+		for (next = addr + PAGE_SIZE; i < nr_pages && next < end;
+		     next += PAGE_SIZE, i++) {
+			if ((unsigned long)pages[i] != next)
+				break;
+			if (fw.level == FW_LEVEL_PMD)
+				status[i] = status[i - 1];
+			else if (fw.level == FW_LEVEL_PTE)
+				status[i] = pte_stat(vma, next, ++ptep);
+			else
+				break;
+		}
+		folio_walk_end(&fw, vma);
 	}
 
 	mmap_read_unlock(mm);

---
base-commit: 551c722f40809618230001baccf219193e22fc5a
change-id: 20261001-bug-mm-move-pages-stat-batch-f62a29ea5867

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


