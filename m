Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC449606A33B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kwQOA2KP
Received: by kanga.kvack.org (Postfix)
	id E366A6B05BC; Fri,  6 Nov 2026 21:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DBA6B05BD; Fri,  6 Nov 2026 21:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD8C6B05BE; Fri,  6 Nov 2026 21:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 927336B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DF0D8028B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:00 +0000 (UTC)
X-FDA: 85406742960.16.156BAC2
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BB0B1C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kwQOA2KP;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqG48vU9uBN7xTzzzeTd+L9N3Q3z6wcaov7tkp2pAS4=;
	b=kJHIWzra81047jsw0FLjw07aVlB32BgZSWQID700yOCorTFvmiowYnVNu8K0RzYIzx/9Sg
	a5VvtlYb6orW3QLu39MqFT/QxEfzxpOs7D2ar2O1/Ssq499PnRhWA5ZysC7e3OjFuqn0fn
	r/2jMTjfqQaqjjjWSWHuP35n+/xwtH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018598;
	b=l50xFRF9X3KJLVd+zH7x2IRmmVd7tCK4YXyNHx23eNiqs/dxRpFbwOOeCZnCl10hLW2X3m
	sm7LvQwQnN4qmkUOAbtd/CCPvMwx9YzAkF1Tn6Bx2dhYQYr8ER68WK5NUc2m1E0p2ALnac
	OMo3JhrObUKOHICDEYX1HQrdtVgIsws=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kwQOA2KP;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36fb88ea38cso283514eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018597; x=1794623397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OqG48vU9uBN7xTzzzeTd+L9N3Q3z6wcaov7tkp2pAS4=;
        b=kwQOA2KPG+RKnl4i+XEOkfspr0lJV0JGjSc8gdlrpMS1ykEY2Btmk1SshQRdwv2XhT
         0riAUYAd0tDnpFC/Qj3XtLiDUx2h0E00mU8lBsj/zoqxzGublHvIKXKEE8DBi6RqvP/E
         OH75+otIBcREqtFgTHQdgXaqAqAd0Yo6sFxPpgtlJlyywc8HCeALhDl/KNBpfYdrG6hR
         bLB+D08Ag//anY2L49uMl7oOMbvJvwCnHrQ6Ck2asAQ4AnqrsFEVvM2zoUSydKykeaW/
         aks9TGpkgRIotf7T2GJ0OQIeBqJCuKNnlar4x0UL1Oev7iAYQbaYO6Cw0J69kn4CIV67
         22EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018597; x=1794623397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OqG48vU9uBN7xTzzzeTd+L9N3Q3z6wcaov7tkp2pAS4=;
        b=XnT+VZdZMLlaQhRwy69RHyu4bJJRH0qKX9mhZdLtH6tdo1f5RC/V064Et/1iEOdETw
         Yd1UjqVzODoXCPTTSdZgb67G+S7x+B3cYSbx2eFlt05lu6v0b8E5V52k8YEFWaQs4iK2
         HM+mo0IiF7M8PAt3juqV92i8T7mAKoS8TydBSDPCJ38FdYVVwTlsCvmVNVw3I5eWV/FJ
         hDtu8dPy/dhmWoAbjNxgVL8dDrOOLlpEkGclxbvgJJsHZLIWLymN6PtrLQBOzD/xAb4p
         qy2aNHdtzWJBZsZzRCE1moiQt7b7Fjg79Dc5u8e1Oj644zXWaTtC1U2X4X41FmITCmpa
         NUUA==
X-Forwarded-Encrypted: i=1; AL+hErGCWsSsKwA1BZJ0XdjSuEfXBQZbW3Euk57t/1sV6VfSYMC6uMmPUhT1RUVEUMUDnzwaHSVC68WbTA==@kvack.org
X-Gm-Message-State: APuU4Z9/tL2LFpRjqK3ZDETYhJldeVlgXkhySD5ecoajen9uc/MQyWY2
	2GxE46d5sHKQSRsWXXCF2CG1krxiB8sGQSpHTyQl6KSusTApWni9ujkbWqzMU1lDR5A=
X-Gm-Gg: AYBFou0IBgh4ai7edmELJGLI+VGngz0zyNve155n70HGO9mYm03YaFD0dnbNNbJdlhB
	RbKD1nufGJaNYjT2LaPAsS1dBmY1twDNZs2AHXZiWLT8bJ+O11c+ftBpv5mXbYoq/GmdcbdcbbJ
	izLi60GT1PGSb34gv6E0LILL8dg0YAGhd5FwE6aO6PfL0EvFPlVsR7yqG/N4ulztx9hAgvjK59P
	vZbIccad+AZ6E/CQfaAMTkzG2kS3K1fY+W9AApru0EKhjYZJqYb0cq9xVdjdFWN6DzgLuFN0l4y
	psvm6MW1avH9o4JyS58bYESazcYQKbZUZdwi/lVHYqwxmAqAF9mKW3CtC7Bv1mXc9espYatefs9
	Ur8u2LcxzWpV+UdIIJFU0gHsPrHtic+naBLfWtENB7LzKksQVx/Uic53wbed1Qsu70bQNHDlBb4
	1OuZERvmwPcJrksU52GWm/5c7Eyb2JLK0rO9840x//qxYkCxm2GnyxFpMnfhElIJBWPFDrZ4XeG
	6GBcZ1fQCbkpMyFQGLdYFwiA59zel/LNzgalJ6WbbpL9gVWT0443Wk/lw1YcaHyxIFnf/V/xlUY
	+g5tLuTU3TeMz0LF9GSyoernnyhsIhjZZThiJuAwTKQvUHshzG5DEOewnb01
X-Received: by 2002:a05:693c:69c8:b0:35e:af84:bf1e with SMTP id 5a478bee46e88-370f4c6234bmr1072334eec.7.1794018596714;
        Fri, 06 Nov 2026 18:29:56 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:56 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 08/13] mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Sat,  7 Nov 2026 10:27:51 +0800
Message-ID: <20261107022756.77731-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wy3rcnzc5bms6hybiorqi5ng5ktgj8dc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3BB0B1C0005
X-Rspam-User: 
X-HE-Tag: 1794018598-183919
X-HE-Meta: U2FsdGVkX18kGcdyU892k2gLfcYCCbqRqeQC6Z2X7uAxb2LX6xiAeWVFgJzqZogMDwVh1MLqGggYFPdMgp0+sxhjyan4YTTEaxdUNbCW/h/hUlLP4ohp/j8kFOjn66EEMYKyfOgbtxchbu1KMuTb66t/DIjQup6pn5NjcBjoyagh7QDDioNPvQdhSlWyH3aCbHT+Aa4fh05A4+vkcPsiwRBVEmrV7exyC3DW6uw2KOSy9jj3fsnAErK37W8w1eZ3sNth5ZN+DqukVwdHylTuFztcVJF6YmGX+8tmjsTcgHKRVFA7koLXEDX6k7498Zz04Q/AvGe+rsUxhWNh6We6qs2V0Mjgesq281YBypWx9zYP3PQsbKOkEdRE1Xxk5AGN9lv87fbifK0JK1UEhLEGAuRBfwQncktv0BLtTHiVka3aFcKdjwNGe/mKDbweW44ZN/g6/CKzv5vj2oPt91w/HQbrdRgbcsMHqebr973iCyr/h/+a+X0PaFRtMqt8aYsPHu7+Px7aZ+N2zN604+/uJJmw+ylUmiUoQR84kx+juvUQnhYKyUIGaqa0dyZMQqT6pKZPzzzrXuuTaLeei7GpPGxYacq8rv4GmP9lQu9rgkKLQOuFQn4wSYtN2E/hwo453+tiuH/Mapk31A8bqeh5XULtY6WLtMJgOKd8SNqvSGIGL5Kuhem3d9yFZST7IBdVDPDARTUBlJMbv6MknMwstv9OZxcO3+LMpCLRx7m1FnrWfgWSozcQUHaekelSE++mRwpgOS2pyxWHIbWEuaiVtgmPtDcgr0Z6FAreRUltU8GLEw1+jDwdrtc7yxvo75PZF3n0PRFbR4Y848N2ejVxF3WFkVpnpIqREqOMll1+A2uLHNlpiSgcSq7eO4EtT5cSXlkqjEQI9nWF76FE5qC+ucZo6xWzGqjXXHNlGjpbs9UOBTC3idgkzrNpOD702by4U7ozGZ8Au1h0s1O167v
 fyA7D92P
 F1DVgeDNpw56rQ+H4SWujcYrTMEfm1VWIDhiyizKCFYIEHd/3EZ4BwzaMkddaS5V5QY+mZeEu4ePC6VtQPl6jkQHS7qOFdQJbeDDtV5PqV5lFqktbFc2wVQUTS5005iSB+c5VyGXsvFyl7+LD+jD9BA8NlOqATbdbbtnF+bd6WEqUZc4g9bf19QJOMDu5rqSARdxo61s0ZrLgLyddxrs7bN6e4YYhHp/6/6i5zhNHGkB2J49hft1t4b1cD8cbY73dB3LRJpUt4tAxO2ukO7mwHbM+W7u7vAmdR29CK2u2dqxlxz5o+RDONGpci6Xxg3FXeZc/SstLDi8DfHTqisiuRLKQmgicRx7OIvLUf3paKmjFpItQBsbo/DvDw4WuYWRfN/5UtWSYBszaOv3Cj4lyYIdYmrhq6oDt5SRhjn5uQ4JLY5ZeRz5jDYSFe2qL5+PDzLSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The remap walker currently carries a shared tail page selected by its
caller, even though the optimize and restore callbacks can derive the
same information from the folio being processed.  This adds redundant
state to the walker and couples its interface to caller-side preparation.

Derive the shared mapping state in the callbacks instead, keeping the
mapping policy with the PTE being processed and simplifying the remap
interface.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Keep the caller-selected allocation mask after shared-tail cleanup
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Use two tabs for function parameter continuations (suggested by Mike
  Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Update the vmemmap page-list contract for shared tail derivation
  (follow-up to review by Lance Yang and Qi Zheng)
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  6 +-
 mm/hugetlb_vmemmap.c                 | 93 ++++++++++++----------------
 mm/mm_init.c                         |  6 +-
 mm/sparse-vmemmap.c                  |  7 ++-
 4 files changed, 52 insertions(+), 60 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 065840f3c241..858311a71b0c 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -91,11 +91,13 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
 }
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order)
 {
-	const unsigned int order = pfn_to_section_compound_order(pfn);
 	const unsigned long nr_pages = 1UL << order;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7a3af4fd285b..3968dfe7f5a0 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,21 +25,17 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	list supplying replacement pages for the remap and
  *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
-
 	unsigned long		nr_walked;
-	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
-
 /* Defer safely batchable TLB flushes to the caller. */
 #define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
@@ -140,12 +136,14 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
 static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
+	int ret;
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
-	vmemmap_walk->nr_walked++;
+	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	if (!ret)
+		vmemmap_walk->nr_walked++;
 
-	return 0;
+	return ret;
 }
 
 static const struct mm_walk_ops vmemmap_remap_ops = {
@@ -213,53 +211,53 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
-		struct vmemmap_remap_walk *walk)
+static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
-	struct page *page = pte_page(ptep_get(pte));
-	pte_t entry;
-
-	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0)) {
-		struct page *head;
+	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
+}
 
-		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
+{
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
-		entry = mk_pte(head, PAGE_KERNEL);
+	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
+		dst = folio_vmemmap_shared_tail_page(folio);
+		if (!dst)
+			return -ENOMEM;
 	} else {
-		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
-
-		/*
-		 * Map the shared tail page writable. A lockless get that read
-		 * a non-zero refcount before the remap can still do its
-		 * cmpxchg after it. The refcount is zero, so the cmpxchg
-		 * fails and leaves the page unchanged.
-		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
+		dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	}
 
-	list_add(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
+	list_add(&src->lru, walk->vmemmap_pages);
+	/*
+	 * Map the shared tail page writable intentionally. A lockless get that
+	 * read a non-zero refcount before the remap can still do its cmpxchg
+	 * after it. The refcount is zero, so the cmpxchg fails and leaves the
+	 * page unchanged.
+	 */
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
 	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-	/*
-	 * When rolling back vmemmap_remap_free(), keep the copied head page
-	 * mapping and restore only PTEs currently pointing at the shared tail
-	 * page.
-	 */
-	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
-		return;
-
-	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio))))
+		return 0;
 
+	VM_WARN_ON_ONCE(folio_vmemmap_shared_tail_page(folio) != src);
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
 /**
@@ -287,7 +285,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: input/output list whose first entry supplies the new backing
  *		page for @start; replaced backing pages are added to the list for
  *		the caller to free.
@@ -296,14 +293,11 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_tail,
-			      struct list_head *vmemmap_pages,
-			      unsigned long flags)
+		struct list_head *vmemmap_pages, unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
@@ -321,7 +315,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
@@ -498,7 +491,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
 	int nid, ret = 0;
 
@@ -509,9 +501,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -540,7 +529,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_tail, vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..a9d848c92678 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -914,6 +914,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 #endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
+		const unsigned int order = pfn_to_section_compound_order(pfn);
+
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
@@ -929,9 +931,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * Vmemmap-optimizable PFNs are backed by shared tail struct pages,
 		 * which have already been initialized during vmemmap population.
 		 */
-		if (vmemmap_optimizable_pfn(pfn)) {
-			const unsigned int order = pfn_to_section_compound_order(pfn);
-
+		if (vmemmap_optimizable_pfn(pfn, order)) {
 			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
 			continue;
 		}
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3e9d6617c4bb..b8b55e12f5ba 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -241,7 +241,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	if (!vmemmap_optimizable_pfn(pfn, order))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	/*
@@ -286,6 +286,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
+	const unsigned int order = pfn_to_section_compound_order(pfn);
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
@@ -296,10 +297,10 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		/* Map the shared tail page as read-only to catch illegal writes. */
-		if (vmemmap_optimizable_pfn(pfn))
+		if (vmemmap_optimizable_pfn(pfn, order))
 			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
-	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn, order)))
 		return NULL;
 	return pte;
 }
-- 
2.54.0


