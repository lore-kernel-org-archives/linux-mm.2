Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50C910AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385F46B00C3; Thu, 26 Mar 2026 22:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336566B00C5; Thu, 26 Mar 2026 22:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225A46B00C6; Thu, 26 Mar 2026 22:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 126166B00C3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C99838D672
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:06 +0000 (UTC)
X-FDA: 84590227932.26.700CBB3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 185F140007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DjzOCy7C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRAVBAAGLIHNuPxenAu6Zv4mVQpIwOINutBDBMSDYBI=;
	b=Sha3NELjIT3S8j2o8Z6LFuBHFQGD8p0+/VF4zcHT6ln4U/C7kQ7m1lQlOMae1jNsgSIIOz
	HBBwP6AuO0N0o+qBiH0H4MYmcinWOkCGoO80cGLTMZ82jBF0lQgc0MVMDAKr+gvxyxfN8/
	4jZxbcKNldtOaBZ0HYMwxb34t9O22w4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577765; a=rsa-sha256;
	cv=none;
	b=AV+uUlnOgBbHpJujoIDjxQfyYLRrZVLmMGDBg5dsN5a6OVvNtBw8Y3xwPRStJ7Zzx1pG5d
	PXhe7+pWzFb9K1ZH1ltYiPx40YR2Vx9pwxof2647h6G+SasBxszhqOvmC9/7A5D2wk5HyA
	LNG3uZpobaYy171RwPRjILR66CC4wWQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DjzOCy7C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRAVBAAGLIHNuPxenAu6Zv4mVQpIwOINutBDBMSDYBI=;
	b=DjzOCy7CYYN46My00Xi1fs3rAUMoskKmV/KpehE3GWn6mX4MPqoLYrTNgfZYBGEzLR8iqX
	SjzK869MdpGpt78ig/FnB50pdDMBRhVufNL3A3S6FY7A6Fna4cqbAKf1pwbFNITcjpiouQ
	IsF7YtJduydG7B8wGDwJ7Ww4Rl22lmg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 19/24] mm: thp: add THP_SPLIT_PMD_FAILED counter
Date: Thu, 26 Mar 2026 19:09:01 -0700
Message-ID: <20260327021403.214713-20-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 185F140007
X-Stat-Signature: x7roeztxfya64q9ugckpuqyh6xfr7k9i
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774577764-515927
X-HE-Meta: U2FsdGVkX1+SVFL4I4gfalgCFn4jWhYyRK2Mux+Z4jXQGDhE+cuT+EBoQT8zxvnTLYMlsmd6pNZWiEFXdQlv1U3ko8uLXAu3BpdnRV6zDcos54Ua5uZJnYqszB8Tt1epx/2R3h3y8W1UgX4Cri6MIis+bdk6ndWytxIRkrGBOIo4FwmQrd+57OPRk+IIS+c3kjRIv1Aof0lfit2A6K9dh1WrXcu2vBOBA8xyQVPzVMR4shOAXQcSkYF5xo5NbBwbuOPy4VgjrU7OTPj4wOLMy0aTMWLI7ydYckzIoKALwjoyDwmaC/PoBEtPJ/4nzeFZJi+5ngLA6cK4l9njKZf8xKLYMabBMp3nFT6EUuWduSvRuW88c9Z0X3Y48vRGO5zV86wDNaNloN6PmKiHcUkzua9bbYidMeNKskOFSnh8O1ALJdokVz2NMuwdLy17nnYUZc1gfgvdJCrNbcfKCRKP4eVtyUKFkwHVrIGcCfn9QZ7g1qSde9CaioijlTqlwwIFAnsFO9qLRg0nfMhCiJfU5YtY2ou7OFgmbbrOhYAw62CtErMCXuc/USwqwDE3d1T3yzhwnsTRlt9iWOSillt4aNEcTDtXBiBS8SeelGAGhTdIedSoOXwC72Ybd6zzid0LhbFZZYV+VXLtwM46e9kfHwg6xdD4AIfshEQPGGtSaCQGBsdupEmzGsWFkRYmdrd38K9NQRYvnNdGKsY3O4oVLX6qlTbQXjBFqs7UAiN+hhgOP1kW5Mz7RxLlEE8Q27d460DstgyoeUy/i1DtnzhwASGA2niWbiWD+Sfj0/d5+qI2GY05is2HWA9LgFBl7HdxgsODWUZO24KI3uR7CrDqPJun/UpiBcBAkNdfpR1tTQHNfphyQam0Q56gJKRCB+a8TwV5J4lU/XsLcn66MeDUEkC1OS7Qkg0bTVlz3ixtozMmSZVFCuqCj3q/rAt3zsN3vUv+NicQoBMzygflRTg
 1A9V33Pi
 VoBzNij66beTozfJR6HKByPvA5joTMqhGWPJXe7y6J4vYVC0G5Q1CkU2WsdNQXufej0HwLkEMbINSD/PFZVjkOiHVDxryomTV0bl9DvPtE4NulId/Gh1vt+smHX7O0A8XFSgHN//PDX8YvdadY1HGBjr/FFlteMytqdaHcT1CE0qqjoP6Qqq4Ds2WuZ8bU43xGuV9vLwky/EL41hj1UVp8QB7sPodX6fGCnuh5yKEgETLcIuBW8QBiwAgCLomlS/PYTVmuQeaLDddO/G4/cGgOQ5q/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a vmstat counter to track PTE allocation failures during PMD split.
This enables monitoring of split failures due to memory pressure after
the lazy PTE page table allocation change.

The counter is incremented in three places:
- __split_huge_pmd(): Main entry point for splitting a PMD
- try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
- try_to_migrate_one(): When migration needs to split a PMD-mapped THP

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/vm_event_item.h | 1 +
 mm/huge_memory.c              | 1 +
 mm/rmap.c                     | 7 +++++++
 mm/vmstat.c                   | 1 +
 4 files changed, 10 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a0201..ce696cf7d6321 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -98,6 +98,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_DEFERRED_SPLIT_PAGE,
 		THP_UNDERUSED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
+		THP_SPLIT_PMD_FAILED,
 		THP_SCAN_EXCEED_NONE_PTE,
 		THP_SCAN_EXCEED_SWAP_PTE,
 		THP_SCAN_EXCEED_SHARED_PTE,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 48c4884a6f386..b93718931e729 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3347,6 +3347,7 @@ int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (!pgtable) {
+			count_vm_event(THP_SPLIT_PMD_FAILED);
 			mmu_notifier_invalidate_range_end(&range);
 			return -ENOMEM;
 		}
diff --git a/mm/rmap.c b/mm/rmap.c
index efbcdd3b32632..a0180f62d9f69 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2087,8 +2087,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				pgtable_t pgtable = prealloc_pte;
 
 				prealloc_pte = NULL;
+
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
+					count_vm_event(THP_SPLIT_PMD_FAILED);
+#endif
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
@@ -2491,6 +2495,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				prealloc_pte = NULL;
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
+					count_vm_event(THP_SPLIT_PMD_FAILED);
+#endif
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd6..b8df9c7296d8a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1409,6 +1409,7 @@ const char * const vmstat_text[] = {
 	[I(THP_DEFERRED_SPLIT_PAGE)]		= "thp_deferred_split_page",
 	[I(THP_UNDERUSED_SPLIT_PAGE)]		= "thp_underused_split_page",
 	[I(THP_SPLIT_PMD)]			= "thp_split_pmd",
+	[I(THP_SPLIT_PMD_FAILED)]		= "thp_split_pmd_failed",
 	[I(THP_SCAN_EXCEED_NONE_PTE)]		= "thp_scan_exceed_none_pte",
 	[I(THP_SCAN_EXCEED_SWAP_PTE)]		= "thp_scan_exceed_swap_pte",
 	[I(THP_SCAN_EXCEED_SHARED_PTE)]		= "thp_scan_exceed_share_pte",
-- 
2.52.0


