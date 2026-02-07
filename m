Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B12EE6B76
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E366F6B0099; Sat,  7 Feb 2026 03:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0186B009F; Sat,  7 Feb 2026 03:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC416B00A0; Sat,  7 Feb 2026 03:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C11156B0099
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:16:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91AAC1A025E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:45 +0000 (UTC)
X-FDA: 84416954370.11.4482E06
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA92080005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WVY8JVvP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452203; a=rsa-sha256;
	cv=none;
	b=Dl5cPqz64lYm84/NuG6Nu8/ZURztXV72Pixg15qdrD+OnwzN+xACN3r8kBWTky2ayl7umC
	AA2iCVhVplAn9iMG4EEX3/jwdBgIvAGM92Vk8jogqep3JYkXE5fE/GBtHfj2w00cn6U2sY
	6+l/6l+DGfJc7fxU8HU6Zl0WT0HJjig=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WVY8JVvP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
	b=Mrmkb7+rQLYGapF55X09r/Kc+0ll8xtoDsO9r7xVcar9k6N0/4dptm+djp770h1njuA1IF
	ujbVvlRjEhbOWvGCgDjp06PeK6ru7DH19TdPL2UOXoBW9p3bWYvpdwt/q+165JFhowvgpc
	kcKPxfA4Iujws5CGOPJZ4ik2xdUBNlQ=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c6c444e89bcso1038122a12.2
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452203; x=1771057003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
        b=WVY8JVvPi2L2z6MPDzQFM2qsXpUb20BfP9OcYqhj42sG0jrc5DCIZSAjRoCr8h/yYl
         zB0MJcrT0P/GWWkLYvDy0Lr/WptgFAujf9n0gy4ut3QNwa3l/U/7FxFBWUPVXnDbTsLC
         Ih7MVPqf8in2PnAvA7sW+wRVxatn+Yf8T8EzDFWq7Ca+4DlKKPX1zrVIV3mePEcUs+04
         UsnRaStWizNltO813kvGuVffnDq3k/sqf0nOhHjPBrt/dWQeHxmTIUc65nWQHxzFJbB0
         8oO3xWCwV6HuwOal/wTrXEaX8iqHgFCWjDhqh8egwhpfWDaYTnugGXRF+yj43KYUKvdc
         Z4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452203; x=1771057003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
        b=vxczxdECMLcPvkkb+mKymmRhevZJby1HmfNPe2dz00C8F5XkpTmult09E+KAj5BP4N
         3BUlFCbHPttreQz7+0gpMBKte2g4NQ4yRI1V3GHlFTWBQot0XZr+kKNggjjBJ4y0kOPK
         gTI/ChnAZggcJCdL/fKbA04s1LmRg1lK2/6G6hV4AtJVqKMl9mJMmeLlNpanw+iEEck4
         SWa/UucbbQUzcFU2CpWm39MZXY642eU6mV4bFwv48YYp7c5Di5kyxdB+HrlDFDwYxqHd
         qsjeI+OluHGm/LjpqRULU+Inh/mvVZ2GwZWb6S4VrHfjRgur6sbwJ6VvkjMIQ9lOSIy/
         Fm9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMsS4KHH0eVpwkleufSponR8Kdd9y2sHu2Ln+VaRt/imwJ+LdwkJEcD/mHH7rC0NXqrKWm5CdmJg==@kvack.org
X-Gm-Message-State: AOJu0Yy7S9j2kcu6lWNP+mLEhEKV8PI69QLxe7f3AQE4N0Zml43QVJGk
	GyJEI+2R/HG+zafQTxmSYLolLk/cr4SQyYspsMvgRRucoE3t0l/lH9nu
X-Gm-Gg: AZuq6aLraU8hiV6RT9BToR7NOgtwtAPkTJPn33h7ruoSR+3+0FECdVhlCgD/XFjQFsE
	ft77A31612fqtN7JSvqr1ky9Rw4+8SohLsu3eyiad4x719qYY6z9L2ktHtFjCmvac8dZvqci0Co
	/DvHCJdI5Bq+/Qon8FjOIkl0Pb5Co2QAam6aUTyfah2IjmH1TEXKega1PGpCJ3x6kMVYywT/RGP
	iVbJDsD3DnRtdUjq4vOnldsbtHzjrG59UkA6TlWfME1rPVwzVmxJNjwcBaR6mM2a35+Av5HNO6p
	A2GOQZYyrB0HSAPYrT08n+G4l1wdjwAAsA5TrmuIEeZO36GqCawhDCqat5PLrMi/RQcwpbiJYYW
	fvcu0sKntFzF+beaX4atgM2aG5BEyDnTS+fuj8pGWoOWDGIniBu4dTEaRRmvuG+8OU+BPBG8CGJ
	p+N8svL8Ew3kfoxK/QHKigIdg=
X-Received: by 2002:a17:90b:3c12:b0:354:be2e:c056 with SMTP id 98e67ed59e1d1-354be2ed154mr2936251a91.18.1770452202653;
        Sat, 07 Feb 2026 00:16:42 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:16:42 -0800 (PST)
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
Subject: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
Date: Sat,  7 Feb 2026 16:16:10 +0800
Message-ID: <20260207081613.588598-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081613.588598-1-vernon2gm@gmail.com>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA92080005
X-Stat-Signature: ag7wachys94acbe9wyjiah9an9mezyx7
X-HE-Tag: 1770452203-327231
X-HE-Meta: U2FsdGVkX19JkTs6Ypt/haYoojYnkt1lYu60YVgR/rQ+CB5XT6GQoAajT8q7J+4tihFS8YGYR5/Z1PL818W7gTwZLViuQn73tiDvyzik+x72Kp+qR3VGbDrAtRsX3Q13Oxh2B0xfrDIqsHa5mdeL8CJWMooY1ev7n/T3lNifdvd0GTLuU0mKMZNgPyVJKGWwHW+a0TfHeSG60jjXNAgdIEJLgzvlD7SjwkgKg13cmn0u/z+GQwKYkVsdJv0GvAlfaeRWhclUdq54A75/mmA1tgCIeD/bgKreYn6c3SKZouHy568IUhmJi2RY5fFDrEUO8+DQgCawN2zjtpEbSCzrvxUluN/aGXS2a4SA+6E5fluAiWMMON+YefwXv1Hr7KeXqXfitcCsXagnP88n4Zn5az+eIK/rFiJnEHQGMTR2oePemB1AlH+inIMHso8RdSYppXTThoU/e8iY/4ZLuEFgCaEko0p+jtwoQsmS0CPPBbregJFP+2UwaZGXkeWdCym5G9N4obVtwIoF1QqX16Z/NCy+ensZfM44gbbnXtDYKQssT4J2v4BohudUhsxSfYwaxDTH4OcYLkdO5ZXQmEcgKYu+vDmYF6YrUIUX1sOcf/X05UyjzKTOapWVSZ6Bucfr0L4OfBFxyDqc8HwJI1DjLrf9VBEQEY6NJDPx5eDO6AmSVDouTZ7omXgk+lMECYH5TyA59A89EFmIYq+gTAqzfL+ENJRd5QUuG9MKt486priT1yzLtB3/hAShKKpp1jHIwLzL6Jq1eOEyDl+86dL2F1pFFo1M+bqyBy5ZBnf/eYRodbVC2e+yhB0NaKfBURaL9bShhRwrnBwfGgS288SnzvPnF1Q1IvTAps0ASsb8tpUJJgU6OgT59Lsy2t05y39+4pV44GAKOzC3QPVuO9oLOXn5elBpRq/BEzHqemsgTR0HikRFME8oyr9gYCsQjQlciZHWh4SNcVYHwI1s7VS
 DBDh46Jw
 hPRB9478DfOPLp5nKpOy76OXq4FDb5Pnitqj74A3AkREg8frhPZfdIoVvWAR1rYoPR8z5h1PATaSrYBUaN4rMlePfSd7meOYpV8MsQBcHm7bfdhbCkJucSRaPn1/H/fH0SCDJ07vZScnUlEE4Os5zjM+ZkAUv45W6f71LTJGO95YO7Ls2vk1ohhd9TX0KgkbvYrcgXpQXuCx/It8UwRYJ6kODMk/QvQt40cKnGpivfO7VUXRHprpJUfsH8vnLmbkVNBlPnOA018oXsctAx9p5KW2xSuUpgqkhhh2a/3LY/z4lXTtyJg5CJMFnjnGe85MyBdrAcx1dM1LYMvi057CegxGuSyzns93FUtRor4PGZ763oOstU+iAxSwV02Wu5M47oEbtP4WTL34VfyxS9dSyrDtUXcPq29moktglcWUmeR76chrTeCC79/sG9+RZB8rG5zWC
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

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4049234e1c8b..8b68ae3bc2c5 100644
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
@@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
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
@@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			cond_resched_rcu();
 		}
 	}
+	if (cur_progress)
+		*cur_progress = HPAGE_PMD_NR;
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
@@ -2457,6 +2472,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2473,7 +2489,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2487,7 +2504,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2495,7 +2513,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2818,7 +2836,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2833,7 +2851,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


