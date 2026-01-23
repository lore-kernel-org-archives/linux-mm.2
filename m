Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 986A5D7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090B46B043C; Fri, 23 Jan 2026 03:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034166B043E; Fri, 23 Jan 2026 03:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FB26B043F; Fri, 23 Jan 2026 03:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5C766B043C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D7011AF62E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:07 +0000 (UTC)
X-FDA: 84362538414.26.0156BEA
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59B8740003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZHpYw/iW";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNFjSEtLjmo3zavrqqxSndVZ5Mb9BZ08qMwOVvVVYnk=;
	b=moKyccLZSxe/PDLPUsjZMnV+ZHZ7lltsWBl0KCA6ED20Eh+zxPIDtEas5SDgd9ff0je6gP
	A4NcoIxG2sYaica5ynHV7uVbTAlNj1lBYzf6Z3aTItpSYpAzV/dxjlCR5iEXLunC34N8Ys
	Ymv0Dj02mUtWiEPcjmgDNqEURGVe4ig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156585; a=rsa-sha256;
	cv=none;
	b=mSpPyo08Ghc2+XYpmUU4j2gvw/yq3aMuqF8f8m4k5XIrrMkkOndE2m4PEb96ywQgnSQwXQ
	MasL/ZKEiNHvUqJEI3A3Uv0UojSgjY2ctd0cSSoTHrXWXhxs0i2GWICKfKwSOvU/maP+Wu
	ZzfZh70tTcsAbriue78SGKvZ/yylg6A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZHpYw/iW";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7f89d0b37f0so1526068b3a.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156584; x=1769761384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNFjSEtLjmo3zavrqqxSndVZ5Mb9BZ08qMwOVvVVYnk=;
        b=ZHpYw/iWikxNpt89+u1bfAhv1b/peW2D2+DMN1P6EUX8pH+ISkk9/0JX/Kw4tFplVW
         UUabGPyvJpGMh3bQOcZPa7DrtdI37eTJ8JBZ4DZ50QtcpS434p7cFyiZHgssFELWO4YJ
         LxKtYcGLSPnBf2Qh87g/2FecfOfhnPHfJ1r5acHU+X6Rr9tbMfK7QskQcKidF4fnn5AR
         Kuu9sP6lq+jvw+XqQ4um9+tybMRs9+DFndiDz+wkQoM3Hdt1nbdiFX8h2UKoS/pDh7s9
         D/HeKUX00sAdSysEXLuqK6yJ+92461d/RmJXTP6zOB3rUwTc4Iy3JOEhHUDc6507TN6R
         8a1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156584; x=1769761384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gNFjSEtLjmo3zavrqqxSndVZ5Mb9BZ08qMwOVvVVYnk=;
        b=AVmZ3PUbBz3k8os2wRQS1L/iE4bgiqqMWwt+vZp1dopLmrQC+i1arG+x+3r9MMNmRu
         lfW9ZGyl8bhwn1BWwyd/n56qu40sDIlwXpQIczfDxIlKDZwHtHWC1Me16kUXGH1O4+i/
         RJnOXZmaNL2grvRve8lEPYbjIWFvNpgbOQ3jiyUDL0o/pce4cSNjJvtMjwAIVvTCeodW
         sodaz22vlfutzJ726oPo0/MhtqaLaN3afMpw31PbztPaJIvwykg0AaomIxBAlxHmZt8K
         WSgGqPRk29DR5RogptEBa8kWA3kgwe5s/3Qjyr7nkc0SqJr23B8eML128MirTaAaZgP7
         qsbA==
X-Forwarded-Encrypted: i=1; AJvYcCWh8jswV+DPZroJXxRIBapasTGTW2ODI7EhdfwKozjkBBTKAdyWwPCq/Ir3RDKpJTGJer4wxdYJSA==@kvack.org
X-Gm-Message-State: AOJu0YwJ0Ghaqi44XefNEpu4IPbji8lZDQpuFnJMmzO6cAFCoitc1eLp
	r8VfvHEL4tDSrFN9wgN+yugYevWVAzRkBGoL6WTbcqf4VBEIt/DNIXnp
X-Gm-Gg: AZuq6aJXU4mUddBZMbHBClXUnm7uCaj7/t53qFzRWGtM1X+mT/1y44phQ7ho1PQo9y2
	oeQ40k4jmPPYay7sshPjKfyzrTFci4V8L+iF57ri7Nxlxtn6l2qjIJFhAX0zLOPXYO/Ee/qgtC6
	4w/UzTxhfPU96YEy1RsDibxpzvTpYDpA+l5dCfr6p5YSMJSd2tMsQIiQM73sxNn9HYEs7ZCXL0q
	C+1D/nIVZyDnhBkgHW/3Q1wjSFErF46dTQVtpAFImGRxBLbRk1572fQBVwgJmZ2H0JdnHTEWCk3
	ifh2Uq+ptFCqWvIdAziZEAKcAo7mQywz0zUI+7vB1LEz0lZhMAkrHU+/1nq1CAZyVRmNrPHD4GJ
	O9wPqq+EL9xosWtBZrheFoh/0QWhc2fkW6UZppF7Uguw0ZQVAxHdeXFCrqg3Ag4a6XLKy8Gv7tF
	v+5sg4jfcd/3kvc2eWeU6pVrmg
X-Received: by 2002:a05:6a21:116:b0:35f:84c7:4012 with SMTP id adf61e73a8af0-38e7008e9e2mr1886524637.29.1769156583989;
        Fri, 23 Jan 2026 00:23:03 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:23:03 -0800 (PST)
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
Subject: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
Date: Fri, 23 Jan 2026 16:22:29 +0800
Message-ID: <20260123082232.16413-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123082232.16413-1-vernon2gm@gmail.com>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59B8740003
X-Stat-Signature: 3chjncwtef88yorhbq5w4bddrcg73tgf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769156585-45196
X-HE-Meta: U2FsdGVkX1+3cNABfxQyDoEmoLKyP8EyzMHRJM9tizR401yU+GcrH8QU+2uHSTXeFN3BLZM5SodwjOxsWkcGMhxnkOXgTrn8n0M2jXj9rgZPtK1X0RksHI6RqdKa3TuRrOYwDxZgbBudo7uv68FbH22XHzjKufz7uqMOOHRwN8/9FYMBkaXM7Vn/BJrIauGqgEGSypnuM5d2bsRiCJG75uasGvaY0CtPvdC2C0vw+vWoV2V+IEni4qoZDa0gbiVd8hZ3WeJoZavcR5x1lxkRBsHkpUbkNiAauV7z0Y8Ezm+o56TdyFx+FD+EaRwLSWhUe67Q7+mP0jbIcDi65Fpwrne1uO9z0OnRmgcLS/YPzFzhiL9BybRFQSG4cisKjrU97q+31SWMQWI9rbYSn1RH8+Pv4UtTPZTMlD+6O7wb1fO0GmqbvvuT405GQ/w2299DW5CJPPhXpPmjRr5B+zTMio/YtDa7KQ2cNHIov5enfqGClOsOHAA4X3/H2pzGHR/Fs1lbEO6U/SxUj067QPrjy9AfSy82kFz/pvj6XpHJIZMEvqxg6Ld6kz4lF1z6W5GnI9yyg8OuyFoP+IzSuStgZa8zr+LWWWoHujujbdZTwgyfaSaVhCkwJKBMFkOaSv6B/GgeZKqcwbYtGSojZg9IfZ2zSr1cEzPaq94WuGt7hWaINjwsW9Av0GcvYOOKb/Jnh+h0qZQaboWPnNMNfgB6t7g3dC+NYGNdJil6tjfnVXIDiqPmNQPjdvVxBkdRPH20vsPQ7TFQndLr8gzn1N60oonb7SgCAzt4XGLddk6p4GVOQQmbg9N0nvVMRK40cwTIRLRiXH6cCkWfYWCaGihHcqCVTGwXD7gNoKdEBplxnutY0yaupJTBuYx9rulkGDIkzviu/AQ9Nbstulazjm+eanBwXZuQOvIF6egB+mqGktLqxscTTw/YxZUdF0MQRzBZmlm0d6PpoVcfYJen/yt
 Lc8U5yN7
 duyygwga2m5KKjx2r9onBD9hN6I9UxNc4X1WmCbv9Tz8BCvxpttCDA5z0KzOqW/yIS4xYjnZ623GeaZOAtTaWp2365Wrm9UpMHQULstIi9YuUHU8FqfEo/Ptn4rktienIYfgLWs0HeKZZyAKH07S156TVQ72uFKEXPjvg8HnpnhS2CNUPuBLpNfMcax9Crnpt1j/TkjBvk4VpHGYR9y1/z+ML/FDPRvWY5VRvfXsmzRbn13/txY8o3TqA7GZaCK3knvogZ6lnRgmxJTNQf9R/bWPYF0KbVWPmcyCJlU+oVrCFn/+/PjB/H/gxoLSJAT1j1WONowxbE9WT4/45fQi9Q0eRBgVXA6uFmCw9QnZP0R7545NoUlhqRUE598XnEwQdZKby12o0+tSdhi3AJlv5N0DqybudGrVVCTHhk0UZCABRiY0xDAjqvdYE0dHK/HjeNDkAeH2Prss5/T3AKegm8yXq70Bltx6Tkh7z
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

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
@scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
@scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
total progress size: 674 MB
Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs

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

@scan_pmd_status[6]: 2
@scan_pmd_status[3]: 147
@scan_pmd_status[2]: 173
total progress size: 45 MB
Total time         : 20 seconds

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/linux/xarray.h |  9 ++++++++
 mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..f77d97d7b957 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
 	xas->xa_node = XAS_RESTART;
 }
 
+/**
+ * xas_get_index() - Get XArray operation state for a different index.
+ * @xas: XArray operation state.
+ */
+static inline unsigned long xas_get_index(struct xa_state *xas)
+{
+	return xas->xa_index;
+}
+
 /**
  * xas_advance() - Skip over sibling entries.
  * @xas: XArray operation state.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6f0f05148765..de95029e3763 100644
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
@@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 }
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct vm_area_struct *vma, unsigned long start_addr,
+		bool *mmap_locked, unsigned int *cur_progress,
 		struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
+	if (cur_progress)
+		*cur_progress += 1;
+
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
@@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		result = SCAN_SUCCEED;
 	}
 out_unmap:
+	if (cur_progress) {
+		if (_pte >= pte + HPAGE_PMD_NR)
+			*cur_progress += HPAGE_PMD_NR - 1;
+		else
+			*cur_progress += _pte - pte;
+	}
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, start_addr, referenced,
@@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			cond_resched_rcu();
 		}
 	}
+	if (cur_progress) {
+		unsigned long idx = xas_get_index(&xas) - start;
+
+		if (folio == NULL)
+			*cur_progress += HPAGE_PMD_NR;
+		else if (xa_is_value(folio))
+			*cur_progress += idx + (1 << xas_get_order(&xas));
+		else if (folio_order(folio) == HPAGE_PMD_ORDER)
+			*cur_progress += idx + 1;
+		else
+			*cur_progress += idx + folio_nr_pages(folio);
+	}
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
@@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


