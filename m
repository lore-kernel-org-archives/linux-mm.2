Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F31C61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444DE6B0089; Sat, 21 Feb 2026 04:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF536B008A; Sat, 21 Feb 2026 04:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C73C6B008C; Sat, 21 Feb 2026 04:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 191E36B0089
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:40:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2734B8399
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:40:01 +0000 (UTC)
X-FDA: 84467967402.04.2584819
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF184160006
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:39:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imj4vQMv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771666800; a=rsa-sha256;
	cv=none;
	b=2//lOX+2jXL80l7wbXCsdqLA4dE6n8XIaq5YcpVSR7WE/Jp4nO0zHRo1rqsBnmfDez3eR4
	bHMpu0uCbqqKjhChDpfJMsM+fWsydBwqeF2L8mVmrlctJX5K0h88eiKAtkP/Zk/g/RXxJ4
	/Au1/ai1+bbJzWHlqgUHiMJ/H0jcg38=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imj4vQMv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771666799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhfMK34w+7c74FDll4ied9faGONb5ohZzrn5WysTLck=;
	b=76ZEYIBHIgFL9seDe+6RCzF+6Yp0WxmxPPa6PFRniAblPXZ6t0PfEnprQpsDHKNKKctgCw
	JpoqdslVPGifozk1cYxe/ULXmuf6MJcJ1MuLfj5pZZe5BolM1xx2wrkZHnW+I8cH+1Mxlf
	n/K/Yx1IwgA8VLV6UcOsxsbEdwAHgxc=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-824adc96ad2so2922094b3a.3
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771666799; x=1772271599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhfMK34w+7c74FDll4ied9faGONb5ohZzrn5WysTLck=;
        b=imj4vQMvbviNezvlMhCABWMsGqv8Ua29A16ZHpV111xB5q+I3p1KxtIc96wiGMcItE
         FYYCC5yKbic2xOM5tu/my+TCZLKz6ziz8XzjqM50G+tui/H5nTcDHczFpD+Rb2PBXNWw
         Dnxco5tByTYH/1MDIiI9iRJeDMKsoOJnZGqZKsDFoiN1Vq7IS7rvIoDM6eJRl93Ip9A4
         KXDCKdlUASy+Gm2BlLexg08qKabKrtpVZnzj9N2fBnB/uBmYVUqmhjjG3TJZ+F9sgopi
         hCDWyvmTbxBj4Hzk5/Rb61p5gOM/BUiNBrqazjys2RdWN3VRkcDvLswzQh0NsY2WgzMb
         14NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771666799; x=1772271599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FhfMK34w+7c74FDll4ied9faGONb5ohZzrn5WysTLck=;
        b=MVNC2h9uZnmSMi+NgHyKgbuvDIAzPX1pTTZd3dNidgqwlaf8XUXCcEMrVE9958aHxL
         2jjfZyv0IhErThBZzpoUpzbvjlu3B9GF4Q8Izn0v6sTgEZKqpl5n7IC0FfV5B5oc9bAv
         Cef622kIWfl3Gzzr9PrEqHqNBV962kPTfSIIjb+JF/yMnUJ/5z8JoogcoOOSH0+SrEzA
         CCtU9wIvizcpnXiT4y3yQkT3lrwHbWXqpBHqT2y2RQ6SQoygNaoiyw/PCn/7aZhI3F4R
         vGAeCjx10zZm4oMFZKlJTyI5xREUMvVBFTC60lIzpvxNpuDdXcsbexJ5zr5ih/7DurMD
         hUYA==
X-Forwarded-Encrypted: i=1; AJvYcCX/IVDU58K8309f1opDz+fQlROwPkRWOxw0XVDG4wSszV83ezJugf428ONd7fTCYSKLJ0J6wRO6cg==@kvack.org
X-Gm-Message-State: AOJu0Yx0GGcacNvo7WvBKVGwZD10AFX59ipQCUA3aoWnof8gZT2iZfBV
	D7nkl/Sdl3Wyfil9u0eE9BAk54eWKIaN7T2esM9z8uEND9J3iZhUaYKa
X-Gm-Gg: AZuq6aJwEMD++MW/EpjQv0T7R8BIXnILMP5jtrnHPdXjNdTygLBsTC3f4F6edFRcrD9
	ubxbIyB/qDuuKGWGwezKQTPMSd4lJ/SdZKxwOGjk+cF1le4zJUL/9yrTU8LqEYdx7QwI0bI9cZ1
	auMBJ4gWgSXCEcPP6J1++ONxAtnASgnOEeBuGfnY5xFXE7gzveNrw7K+qxkVPcCEYeOpt9+imit
	3SCi0yuJIkeve3viM74SZVb1hfM39H0ZtSS6ifzdN7/Djl73AtcpW0m3ueeolqbuQ7zSrbWI7S1
	RYVhfnVtfhzQ2OOmBqM6EAqWPTYabPj0tarubhNMZSJ/JRi2RlJPbknpZG9eg05QuzCloefMUkU
	1n5QOvIhV7IxfmS4+AbuBDv/p70r8HJPp2lMB6G+wmJhhgiC21gRVMd9AYVYBjB/mtQzW7CUyRu
	8zjXI/v4zPS3RRdhP0wL8yeJ0BbzDWCdawkQ==
X-Received: by 2002:a05:6a00:2913:b0:7e8:4433:8fb4 with SMTP id d2e1a72fcca58-826daa82a8dmr2231143b3a.60.1771666798773;
        Sat, 21 Feb 2026 01:39:58 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm1761708b3a.50.2026.02.21.01.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 01:39:58 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Date: Sat, 21 Feb 2026 17:39:16 +0800
Message-ID: <20260221093918.1456187-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260221093918.1456187-1-vernon2gm@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zg1i9yo8knw31psszmwr4197ft1qto1j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF184160006
X-HE-Tag: 1771666799-596399
X-HE-Meta: U2FsdGVkX1+9tE8Sqpp+TIFigIVJXCBjYSHb7+nH1MhZN23UzSxXWD4KtfIRqzp9rSb5YVflNg/jvJMtnet6ccVVn864KHoWUNC0Vyc1lre1THZq/+6qqu/fniSPetQZX4PSax2pSAzeVz+HkLAgTnF5v9atsV8fvEGRzZRQf+J9dOvcAQJbaRPWGoaK8nwgYMgihPz8b4kmK29qlhkKT/lXvFe64PHfU7FhpvHdyecbJmZ3LUBpanJHtPqoBoLCtNMVFy9FdVRsWOazAuNJfG/m7v/7mBVzuBK+mmBVz1KggnFtLGPGiOK4B/v+E8CdDCpfYE/mCLZcp3/fNBOKwwCuizJv5vHCLM53VfZByuwWweG1aXV/BgoGCe8rHOQoQnj6bbhfzjED6xcXDFeFmt6NbVMY8u8gxtoA0++ncccWouKt9P96C9tbV6fAzrE84ZtbtD218CoeX2yvqJCmkZk91BUpkE6qdqMNYTRNi6lI1G9CpJmK9Zz/tYcgtBoGJnMQexyO8yB7RYazOUW2bZOUJHndFkXHC9lKTqtV5/Wpa595n1TwAbEoteHUuSblxbNaYjC15aNh6D/K++OTB3kYq5f5lbfMKQcxvMrLS/Q/LDRwsyxr6vJmmYMXwgZTFkA96ydW5l1vBilUEpLaOhNzjXGzuMWiqNsYWBjcM8CDAcIE3fpvR+CsirEfKKRyA2A7Gbh5fqk8p0s1Z5NctuMvLRXbRpvtVSdZUhddgXDpvF7ArzqJVqJAyNME4/ouwnah41u18leoLkKskTbaWluHCoF569b1ykbS2eg2BpUGAYSDfcVgcxEbN92zv8DnR8hUd6fGaV62jXa8tmvbEub0URKfDTnm2qnan4szvcGlAO7ZrD0F+sDLGBW65Z5KmxoJnlaAh9irAHU227DxRjRRLfpO1jU3bk1k6O9QsQnRolEKfA/6uuqckF+9EJaZI8SFQHc3wLOhqeGRd0Q
 qUi7Csvz
 F+bjpAK5MHtZOn00Trkdh42OxJ5P9KIPcq7Lj5n/03RIwyhYD5fkZTv2avs984dE08MfX10N1KY7vAWRvB9mBr30Gmbe8uIb3PDGCu0E9rR/P3hfXKBTwz427dOUM27fKCnsEhHv6z+Dc0QKFcy99WbaoORALyegstBngmk0EXalLd7wg0EehlgIvHiA4j0W0EeYGCs6MjBQMuvYrKdUyZ499VnxnzwqwKAQ2Okhk168UPALh/MjY6stK10FueCAUp4RMz4oj3M2O/n5ml845NlLjUn+rqxoJrllfClOPE+v9KHtkgf/PRox6kdmLf1ND/Sq3AW95I2l0vA7j2v0YDVrewN5BnxlI7ehH2Cj5DmwOAXQhf8+uDIbtvG+RP59KyvsgzNZQ/+K9A51lzG6cqsrea9QBO3yDG2LeS2eW1elhCV+P21CA4zSB9ZyQAKquiCNAyfCT92rhElZWCc7cOLZfcMon7cJfg+GxtIJlznWPCycgNkG1rNIx0Ou4yT2Nc4jY8Fimyu4bsW+5/S8kUfwg5jydckMpjqdlFAlgcKIX35DM53ALFciUBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Currently, each scan always increases "progress" by HPAGE_PMD_NR,
even if only scanning a single PTE/PMD entry.

- When only scanning a sigle PTE entry, let me provide a detailed
  example:

static int hpage_collapse_scan_pmd()
{
	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
	     _pte++, addr += PAGE_SIZE) {
		pte_t pteval = ptep_get(_pte);
		...
		if (pte_uffd_wp(pteval)) { <-- first scan hit
			result = SCAN_PTE_UFFD_WP;
			goto out_unmap;
		}
	}
}

During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
directly. In practice, only one PTE is scanned before termination.
Here, "progress += 1" reflects the actual number of PTEs scanned, but
previously "progress += HPAGE_PMD_NR" always.

- When the memory has been collapsed to PMD, let me provide a detailed
  example:

The following data is traced by bpftrace on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
by khugepaged.

From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
following statuses were observed, with frequency mentioned next to them:

SCAN_SUCCEED          : 1
SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 142
SCAN_NO_PTE_TABLE     : 178
total progress size   : 674 MB
Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs

The khugepaged_scan list save all task that support collapse into hugepage,
as long as the task is not destroyed, khugepaged will not remove it from
the khugepaged_scan list. This exist a phenomenon where task has already
collapsed all memory regions into hugepage, but khugepaged continues to
scan it, which wastes CPU time and invalid, and due to
khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
scanning a large number of invalid task, so scanning really valid task
is later.

After applying this patch, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it, as follow:

SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 147
SCAN_NO_PTE_TABLE     : 173
total progress size   : 45 MB
Total time            : 20 seconds

SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e2f6b68a0011..61e25cf5424b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
+ * every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -1231,7 +1234,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 }
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct vm_area_struct *vma, unsigned long start_addr,
+		bool *mmap_locked, unsigned int *cur_progress,
 		struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		if (cur_progress)
+			*cur_progress = 1;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		if (cur_progress)
+			*cur_progress = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		if (cur_progress)
+			*cur_progress += 1;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2279,8 +2291,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
+		unsigned long addr, struct file *file, pgoff_t start,
+		unsigned int *cur_progress, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2370,6 +2383,12 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 		}
 	}
 	rcu_read_unlock();
+	if (cur_progress) {
+		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+			*cur_progress = 1;
+		else
+			*cur_progress = HPAGE_PMD_NR;
+	}
 
 	if (result == SCAN_SUCCEED) {
 		if (cc->is_khugepaged &&
@@ -2448,6 +2467,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2464,7 +2484,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2478,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2486,7 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2809,7 +2831,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2824,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
-- 
2.51.0


