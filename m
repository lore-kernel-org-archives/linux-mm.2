Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A95CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727216B0098; Fri, 15 May 2026 08:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F78E6B0099; Fri, 15 May 2026 08:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7356B009B; Fri, 15 May 2026 08:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3C36B0098
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:44:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA2891A0924
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:04 +0000 (UTC)
X-FDA: 84769621608.09.0EEAF09
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id EE4132000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4247jxL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRwqnsxTLxrW/eYaYg5wfX+DDYr7GyQHDxxuw2ZHfsg=;
	b=ivUI8S9jU/aco1woMN8mvlY7Og6wK7wflV7c8sGA7ttyHetLNgMKfrPmMqc42LNaMy0N0A
	Z/ZKqvAZDl/EDJ0j0PxbfjlpRsK3hc1pdMdAOxWkX6YRZiCErnuRf823chr5lqXa5f8bvp
	C+2JULsdmSVaFIUjF0ItvfOTVrOUfXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849043; a=rsa-sha256;
	cv=none;
	b=1K+fj0kmEbmLLbf4K/MwmxGOaJJWb6XbSUWdAiHkG081IbYoDAGBtj+gkQje9f7lAfPp4V
	e1pNzc+SE/ulbSyGwj4A8GTyZOwnYA0tXHu3waGy9MmngaoQ9s0WihcvpbmTPMgwknLloQ
	n8aeU9HmEKJL1AFJ3G97Q5+Zkr6285E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4247jxL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso56261315e9.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849041; x=1779453841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRwqnsxTLxrW/eYaYg5wfX+DDYr7GyQHDxxuw2ZHfsg=;
        b=p4247jxLPKtA4X/F4v5HAyLPdMFW2UBmlVnlK1Jb+UaO0POYFOMAwpuUahiB0I1YgW
         VZ5adwYjZXfjNh86jFkfYZxgEsVerr0ORZRdUpbSxWdc3JtdVs525druTeuBpLlS4W9x
         /f9Ah/hVLhOGvxzVd2DatX00xQQXRWE7HMClEakfgN2IrNXo5/46VwUA1jBTpgbKwsIU
         b78SqFXdXr8ILT/h/KWyVsx3bPD7KaZnW1GR9OjKRoTfDLIyJ01d55bv2AEp1uP4yodt
         3UcPmDa70xy48neTqEQMw1za5p4MGY4gNA6/wnyiPqq7WdoynqkIBn6jIaej9wFSMxnz
         ScEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849041; x=1779453841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QRwqnsxTLxrW/eYaYg5wfX+DDYr7GyQHDxxuw2ZHfsg=;
        b=rjR5SjxLEbCl0lgqwWr2rVXj3paBFoLHYW5KkqTUkWV+tzdz/JfYlioecPepQSLm36
         uQG9ctYeSkSN/7OCgOe+O0H45RhqAD1e4SSfr9nsywWF/KKD7afuebexuiHZdO37fu++
         mhNURxKVQ6f8Le/bP7zEsF0kkbaaNMXverjG1pb/ngEr3Y5Ow0pUZtTVXFoaokuV5UMD
         szqolS1FF1ShpKbaprDwue9eRh/B4g2VYWuOPMCriFqcsZ5eNsgKqc3OQ45SOOkiynz/
         LEuxjfbsX3Tq9mD2AMTylqGO15qh6sJ6tLkR9J3T+x5C4RusXJjUhEC7YZ9o5ERUefy/
         L/1g==
X-Gm-Message-State: AOJu0Ywi9IXUsrm7ptocPecHulc3p1qy8wUnt1IjKCllsUtzpFuNx2ww
	e/U480f35mo54IrzuwByL2fuzLV7SF8oOHOOy7/Nlli16GOouYz2NQoW
X-Gm-Gg: Acq92OHZkaqM76l1zmyzHjsjCksVSgRV7nNVa+Om2huOa4ua1aiHXe/1vo3RT+6bYKy
	ylbRHF7cMkKQXrVrIL+XLV551Jq9V3+2Omm/S0fNU4/M7jIacfkC0EsUcDVGdJpUn47y5jz0Lfi
	tbiWZfoFxdM7Tocn5XCWoAUOb9+abKGfyfhKDc0uSOYLGjwqXtBWMMm5Zw+AUptb3ZQb3MDR8lh
	CFuQUPae3O8PpMhn0NuSL23mGbcs84W6HNsHPMd8jw9t+9YQ3Q+VQJF9AVL44G/RiDOiukbR6xa
	Rqg43M6LChK3f0U+6A16W9oC3FiAME8yhBrI1iyVGmJRf/vce5Dgj7BeRTXTXpTEojkYYIkUGrZ
	xvXiiVb2Dp4A1zLn9z7yiVsAN82VxGrWUFiWZm7ZPogvYugpAej9BR2T4ZC+WlfVDk8ccjrg28s
	ASjpIL7GiWBpxhM3k/ik7bix7F/xSnkg==
X-Received: by 2002:a05:600c:858d:b0:48f:e230:80a3 with SMTP id 5b1f17b1804b1-48fe6514c31mr42790005e9.33.1778849041339;
        Fri, 15 May 2026 05:44:01 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:44:00 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v4 6/9] mm: set the VM_MAYBE_GUARD flag on guard region install
Date: Fri, 15 May 2026 15:42:16 +0300
Message-ID: <20260515124218.151966-8-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE4132000C
X-Stat-Signature: yd88x9q8pg5ci3jczofma4decn9da8ri
X-Rspam-User: 
X-HE-Tag: 1778849042-730049
X-HE-Meta: U2FsdGVkX1+RFnfva0H1qHR05rLY11TbIX6PXAmX/NiCM78JOL+7tiXls5cVSXxowYjwZIhgKOqmbH55diCtV3myOwsr6k12vIwYAAoK+yCaBFwSiuQD2losq9vimdQ68ws/xjA4AZuby9MYn0ABZup5x4hBE1jfisVi3fLRiMKM7ihZuhLF7ZFgs8thvy+cyIMYVndlAgmj7f0wghywOpSF/zf0du0j0lgpLQ0S9gmFK7MyeXH4g5JWQ3kaLqnZmPq8J4PwfFE8bTKvQJVgVF+mg5UO5lIsxQKD7xGf4rfAGRqOAA72WAGbTHhLYUOauQolnZ+im5EkYa2PZTkDCF6SooQYcbrcj1ldOyWFgqA59sIMVnWjaEeIN20myE7qAsvwtmtZpPujtRGyqRtGsLANcN6S5rxfN5Rlfv4+ZpzBZ3agccTy+mEjp6/wWbWRQhMKUC/YA716WhTdp5JbXzxVD0SK6Qu9V09sf2hVHab4fA3hbruduR6e9dcTRpNZKCEB3bntLFf7cdPewGjH0xf+OcfCkH7JNMQSuu8MgtP90Ipaub8rvpEW7jsGz6LnbetL6ffYOA3FuUfXVbkZBQP6sz/lPabE0l/ZE379BUzyjVDGMvufLG5czBoRK66+Vcrr211FymU0nsLZ0xWYrhIymLSD6fyZSspomrvrVG0crWM+qXWNdNyAOLxWdU264YJNtEPBjdNRVGiSFaXf9DE9YNd+cRHk+sJSjVRaZk7EpExHMM7B+xubGCRmg+NKvJkVMjKGsABQI9rkTKhbYXHmIQYTunPhG+DMYpZtGYIRIjdpuTgmZ78az7aZEiT37GGN9nq1ASnaqeWmxO8vglZLLs1LzEn0VgFlmR4AhHQeuRXdxDQUqwd9c58+UKo3NgPNvjB8Oo3OwmtS1cuGGUvXbftmPaNVHkUP2O3lRBAiq3f2Agz770/j8p43EL1vx10x1aAcqf+Cweyd/ry
 MLDIck0C
 TsNqEGqYtml9mvcU+l+9sxClZVt+1bokhjFugbXC/EPuPvm+Lwh+SFz7eCAVBqhj1ABjtlfvnYWOA4npzPlEXZBgrji5klGCoNzxQogjtuKJude9wKLoARJnuL/OA1I2CIfu7d1iAdB3/d3oqpMdJvT2e4Rfr+JpphhZo179NAErLirezkMymElFSPw1S2S8boVZ9syk1zHfl2xVsbVpLdiu66SUHG281taLEQrE07IRFAc0gkICM5Wuubzxmm1W1gXgZIAtaNgH9lxM10gTHiTPx3eHpdVv+Hsru66ttA1JPy0nGQrSCPB8pRNLbkT1oG5Y2k0f7cW/LCiEaHvcEAfdt1XcbkObq50HXjFx2JcSHRuaG68Q6qksvPx2gfQAn2VRJVpyTrux2T0Q2BkDRexP8iJ4MD65YXQaK1PIOsAM2YTYshUIFg2s3L32M3zprSEdaEWRm6g/hItP4TOQgND4JdR7U5C8sxP9pnCZyIdGe7iXVwSPavY2EwCohv2y1hn7QqggrNytIEQ+NsuyKUgD6BWG4Nv7t9c9qPi2qBQa7uc714anXIc9CoVfa4CjTl6hBvGL72o9MiuYHw+/s+MDBbC2tCEws7MBKgNCYc02otX+IcEtmC/lVxHyQ/9cSUE/uynT1S3b6ETkpAkx/8wwWzCM9Lf+kNFo/SxRgM+7bXYRarxpJSAemrMAybwbkv3oTcwwLQDtxkP/ZfuAWepJMa6IKGqch5vGoqCzNMAdMqFY4hVaPo0fScaODuZjalgZrdbznnHG+1czTcwyIEAVYj38a2mWicfQ8uRIBM0ZeqrK5UOxF/M4Jymf/2aysG5EY1frD024M/TsiJ680nUvVNeRQIxPxB+Taj6e6/OhDOjKEFs2IGw8bxzLwrigc+nTCBvwPoNlFOmHIsMcIZNW6xHfdsJUiH8jdD6coMMYomKs0CkhwQ/y5V6saVVUldETNrYAR5Pk0OHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Now we have established the VM_MAYBE_GUARD flag and added the capacity to
set it atomically, do so upon MADV_GUARD_INSTALL.

The places where this flag is used currently and matter are:

* VMA merge - performed under mmap/VMA write lock, therefore excluding
  racing writes.

* /proc/$pid/smaps - can race the write, however this isn't meaningful
  as the flag write is performed at the point of the guard region being
  established, and thus an smaps reader can't reasonably expect to avoid
  races.  Due to atomicity, a reader will observe either the flag being
  set or not.  Therefore consistency will be maintained.

In all other cases the flag being set is irrelevant and atomicity
guarantees other flags will be read correctly.

Note that non-atomic updates of unrelated flags do not cause an issue with
this flag being set atomically, as writes of other flags are performed
under mmap/VMA write lock, and these atomic writes are performed under
mmap/VMA read lock, which excludes the write, avoiding RMW races.

Note that we do not encounter issues with KCSAN by adjusting this flag
atomically, as we are only updating a single bit in the flag bitmap and
therefore we do not need to annotate these changes.

We intentionally set this flag in advance of actually updating the page
tables, to ensure that any racing atomic read of this flag will only
return false prior to page tables being updated, to allow for
serialisation via page table locks.

Note that we set vma->anon_vma for anonymous mappings.  This is because
the expectation for anonymous mappings is that an anon_vma is established
should they possess any page table mappings.  This is also consistent with
what we were doing prior to this patch (unconditionally setting anon_vma
on guard region installation).

We also need to update retract_page_tables() to ensure that madvise(...,
MADV_COLLAPSE) doesn't incorrectly collapse file-backed ranges contain
guard regions.

This was previously guarded by anon_vma being set to catch MAP_PRIVATE
cases, but the introduction of VM_MAYBE_GUARD necessitates that we check
this flag instead.

We utilise vma_flag_test_atomic() to do so - we first perform an
optimistic check, then after the PTE page table lock is held, we can check
again safely, as upon guard marker install the flag is set atomically
prior to the page table lock being taken to actually apply it.

So if the initial check fails either:

* Page table retraction acquires page table lock prior to VM_MAYBE_GUARD
  being set - guard marker installation will be blocked until page table
  retraction is complete.

OR:

* Guard marker installation acquires page table lock after setting
  VM_MAYBE_GUARD, which raced and didn't pick this up in the initial
  optimistic check, blocking page table retraction until the guard regions
  are installed - the second VM_MAYBE_GUARD check will prevent page table
  retraction.

Either way we're safe.

We refactor the retraction checks into a single
file_backed_vma_is_retractable(), there doesn't seem to be any reason that
the checks were separated as before.

Note that VM_MAYBE_GUARD being set atomically remains correct as
vma_needs_copy() is invoked with the mmap and VMA write locks held,
excluding any race with madvise_guard_install().

Link: https://lkml.kernel.org/r/e9e9ce95b6ac17497de7f60fc110c7dd9e489e8d.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 49e14dabed7a294427588d4b315f57fbfcab9990)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 mm/khugepaged.c | 71 ++++++++++++++++++++++++++++++++-----------------
 mm/madvise.c    | 22 +++++++++------
 2 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..3dcd884c844e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1715,6 +1715,43 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/* Can we retract page tables for this file-backed VMA? */
+static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
+{
+	/*
+	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
+	 * got written to. These VMAs are likely not worth removing
+	 * page tables from, as PMD-mapping is likely to be split later.
+	 */
+	if (READ_ONCE(vma->anon_vma))
+		return false;
+
+	/*
+	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * the page table because there may be pte markers installed.
+	 * Other vmas can still have the same file mapped hugely, but
+	 * skip this one: it will always be mapped in small page size
+	 * for uffd-wp registered ranges.
+	 */
+	if (userfaultfd_wp(vma))
+		return false;
+
+	/*
+	 * If the VMA contains guard regions then we can't collapse it.
+	 *
+	 * This is set atomically on guard marker installation under mmap/VMA
+	 * read lock, and here we may not hold any VMA or mmap lock at all.
+	 *
+	 * This is therefore serialised on the PTE page table lock, which is
+	 * obtained on guard region installation after the flag is set, so this
+	 * check being performed under this lock excludes races.
+	 */
+	if (vma_flag_test_atomic(vma, VM_MAYBE_GUARD_BIT))
+		return false;
+
+	return true;
+}
+
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
@@ -1729,14 +1766,6 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		spinlock_t *ptl;
 		bool success = false;
 
-		/*
-		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
-		 * got written to. These VMAs are likely not worth removing
-		 * page tables from, as PMD-mapping is likely to be split later.
-		 */
-		if (READ_ONCE(vma->anon_vma))
-			continue;
-
 		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		if (addr & ~HPAGE_PMD_MASK ||
 		    vma->vm_end < addr + HPAGE_PMD_SIZE)
@@ -1748,14 +1777,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 
 		if (hpage_collapse_test_exit(mm))
 			continue;
-		/*
-		 * When a vma is registered with uffd-wp, we cannot recycle
-		 * the page table because there may be pte markers installed.
-		 * Other vmas can still have the same file mapped hugely, but
-		 * skip this one: it will always be mapped in small page size
-		 * for uffd-wp registered ranges.
-		 */
-		if (userfaultfd_wp(vma))
+
+		if (!file_backed_vma_is_retractable(vma))
 			continue;
 
 		/* PTEs were notified when unmapped; but now for the PMD? */
@@ -1782,15 +1805,15 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
 		/*
-		 * Huge page lock is still held, so normally the page table
-		 * must remain empty; and we have already skipped anon_vma
-		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
-		 * held, it is still possible for a racing userfaultfd_ioctl()
-		 * to have inserted ptes or markers.  Now that we hold ptlock,
-		 * repeating the anon_vma check protects from one category,
-		 * and repeating the userfaultfd_wp() check from another.
+		 * Huge page lock is still held, so normally the page table must
+		 * remain empty; and we have already skipped anon_vma and
+		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
+		 * it is still possible for a racing userfaultfd_ioctl() or
+		 * madvise() to have inserted ptes or markers.  Now that we hold
+		 * ptlock, repeating the retractable checks protects us from
+		 * races against the prior checks.
 		 */
-		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
+		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			pmdp_get_lockless_sync();
 			success = true;
diff --git a/mm/madvise.c b/mm/madvise.c
index 0b3280752bfb..5dbe40be7c65 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1141,15 +1141,21 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		return -EINVAL;
 
 	/*
-	 * If we install guard markers, then the range is no longer
-	 * empty from a page table perspective and therefore it's
-	 * appropriate to have an anon_vma.
-	 *
-	 * This ensures that on fork, we copy page tables correctly.
+	 * Set atomically under read lock. All pertinent readers will need to
+	 * acquire an mmap/VMA write lock to read it. All remaining readers may
+	 * or may not see the flag set, but we don't care.
+	 */
+	vma_flag_set_atomic(vma, VM_MAYBE_GUARD_BIT);
+
+	/*
+	 * If anonymous and we are establishing page tables the VMA ought to
+	 * have an anon_vma associated with it.
 	 */
-	err = anon_vma_prepare(vma);
-	if (err)
-		return err;
+	if (vma_is_anonymous(vma)) {
+		err = anon_vma_prepare(vma);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * Optimistically try to install the guard marker pages first. If any
-- 
2.54.0


