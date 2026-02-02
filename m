Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF4BE65298
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76FBD6B0092; Sun,  1 Feb 2026 19:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6586B0095; Sun,  1 Feb 2026 19:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619516B0092; Sun,  1 Feb 2026 19:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49D7D6B0092
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AB511A09DB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:34 +0000 (UTC)
X-FDA: 84397698588.05.05EC412
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 34C172000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F6zlxUI3;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebhAyHaFyMRLprG6lnpimbBHIluq1sCYCiZGgVEBcbg=;
	b=ZeatIXcKHiYTlatndtxXJTL6zaPjGkUyIiQzmaV3te3XdLoKPzp9t0cVW4wjzOD9EWzah5
	vv6+s98hpu3qXJURKb5rdP1G5AMcuXZSmXPChZByW6FfHAzoZKyYT89QaKNUUrXwM0HjF1
	p4hbp0KGvjpDX+1dOEiCSapdgOB/5lQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F6zlxUI3;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993732; a=rsa-sha256;
	cv=none;
	b=iMznE3bScWpfNBcAlCUWkqUEMjx6DKjAi9Wq8ssGdNqO2iHToUiXthDg5SD1L50Z/ZuPYs
	LZcUkqXq0CEWDzXPJtJjx6B8fu75i7VyVJBQRT3Ny6WWKM/f+PL+bOV58hai3/mrLR8H16
	DMb9OaNvBZzCnBEWwHpPantFT8HacSo=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-40438e0cba6so2680535fac.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993731; x=1770598531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebhAyHaFyMRLprG6lnpimbBHIluq1sCYCiZGgVEBcbg=;
        b=F6zlxUI3dfmKdQIw3QS+AkG4yce7SCJ9YbpKs2aMnPs5u5Qn78zioCKMyS8tspI1AO
         izX9W94n4OP5+pLQ+0yXBU3zxapIZJpUfOPb2m00uFK2LsygQxbdgCf9p1pZqkEGlGpL
         pq2z+I/j+1tefclTR1rilWRW5gjwhZ9xfWMauvLjh3wr9fv5BL1fLMlzNf+DqwhInX8/
         KubiGJQDB4tiOyQxpUsFmDkyh9BCy9eYGj/7PVltwqE9QDliTkmyscAUMikK5dCUJU7S
         i029UQb2lNjVI8WxbJ8hF0uLVXN8kY5VLSZyMXFiffsHiK6IjHwr7pPVIk7wf359XAhu
         6RpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993731; x=1770598531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ebhAyHaFyMRLprG6lnpimbBHIluq1sCYCiZGgVEBcbg=;
        b=sHGMOuMEzvTuuvV/y5V0ENchoIz/vEnMcRjVJ0oI6TGn+0sHrjoleHiwWtL1kwWkM3
         jDjWTyek2BUNtbcyTINarrNSzsIizYcBwEx2T7TrjXSUs9vtbxH0ucan3GFLGKwTSlCv
         FsaRyPKpTxsA3T8ps3MNsoMX8TvCvC2KOgp7kVnduMdUP+/M7LEdlkSCIgBa7tv6ua3T
         9F7GXM039tBSvPBmHVH1pB2AcBgPrKqKP4Hr+xXLMz4GOPaLN9IFb70kj43vp/y/Tfad
         /D+K/0tWaqe+H+DBEKzZGHBrOz365jWJNaIkhF64nFHNyg2Z8GQq9SmCEYLeNetzqWBE
         n0lw==
X-Forwarded-Encrypted: i=1; AJvYcCUiWgFR46eSkm/2rtDphZSnVnb78mBxWX+Yx6Td9g8w5PmEndouVSm5xhrCw+jNkNT/g28SP3ebLw==@kvack.org
X-Gm-Message-State: AOJu0YzWOtoiveSsyqFeKScjdFwAnNwidBpSDXGTcPoB7DsXgDrJGzuT
	7DFUHvVyOwccHQTWEW795bXDgF1vWhOy6JLoZL5BJRofJ1l57ekLQ5Jy
X-Gm-Gg: AZuq6aJv7elmZNdPsKDNVQtSPctWN/8U2kRJA2i+qmkadnnIL9beuoIse1naCnKj/7p
	qIaM7jehzbkOe2LN7UJ7z7TK69ODz4JfjLGcgdrHJ+7ALhcB1BlePcZXPa3ixgcZs4mngqVAGya
	mbo3Z5Cvg1NgFVWisOguDOZRf92ecye2LnrnO0D2MjcoW4aL4Ih71IhGQvBilvrQtFCFmqPzxSU
	wlS/gSBpHW7winj37ZDfjYdTr8uze0w7I3SBUos5kl9RLU5tP7JGVVfOkNLlzmvRsNZUPzCIxB9
	RUdMSXWgCVN4hnSdfQOOj4j7/auNzgcMdwEXtGn0pKfqmnEHXZ156kmj0ulQ/jfvlnTFAyjTr1P
	sWY3GhctgUxH2e2rrEArHAhTykuPkW0AAomwl+J9RP3Or2AqJ9r2EMvE6uPI8mgTeiHTVGzqC9W
	gCtvMmj5w=
X-Received: by 2002:a05:6871:840d:b0:409:e3c4:6027 with SMTP id 586e51a60fabf-409e3c473e1mr2136971fac.55.1769993731016;
        Sun, 01 Feb 2026 16:55:31 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095756e77fsm10108592fac.19.2026.02.01.16.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:30 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 03/12] mm: thp: add PUD THP allocation and fault handling
Date: Sun,  1 Feb 2026 16:50:20 -0800
Message-ID: <20260202005451.774496-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 34C172000D
X-Rspamd-Server: rspam07
X-Stat-Signature: q1tzz6ujyido18q5qtq6d6jojng58jbt
X-HE-Tag: 1769993732-433122
X-HE-Meta: U2FsdGVkX1/mBzwifRWgRvFLm3KU/1v95q0g6jO3WT2DhwIqK583In1IBUuC7YYdHiWhOqP4SqW8SbhYDOBRdv8JkPKj25jgQqopN3j7Vux+lUhmQS9FGe6HdrEVOKzabtO2TO1UBLv5Jxqbx0LdeWX40HTQo24hBmMEvEt+ZrxAcmCYUNxS/kKq2RGSvM2f9Pxs5RlKZfUwo6wmgnn+ar+dbpA+zujWS5HFT3uKrXMeC6Xbcd9c+e254MTSrG5h7A8gxJtP+ytrEr0zl7ODhjpv6PlEn869iFEdQiCFvbJERCI9IEFOc2Oapv72khaOjWNf4C6DfoQlQ0IQG2Zr+3eXl5e6N6gWHfwpwbtVMqGqQkkIrXmjwImEYEJW7ftokm+TUcpVtIz32h6JqxtD4m9Ryd962xogr8+xXYjIn74a8Jq6o+z2GqZ3RFq5BByV0kv++NNQr0BRVoJTBV4WiRU5ufO201ZLhNkLefkzN4JTOiaRF/UERRxt/EW037rtQn9SI+rbHOneJvJMkuDhIkOd2fwaMOR8AXmJvEkydrqJdWuc3VVkwcQU6HRYyE2ld8Axom9ao4wov3grflcQDkaYo/4r6MqvZP5OwG1m208pGy+VLkgJ2nfHim5zEP8wDn+ShLhBvil7uIwVbXY8+ryfHNLYmzX1/7+/uIyxPJwvtKBNFerrWKLbFJ4lSY8S3bwoVbBsDkwuq3UxbLhZ6g0ZXiL308ayfo0mo4FZKPxtf8Jrgrz8mmeMJ3AFS+vqV+UFfyHsSN172yPiD0rO521JWk6wGUO7ETcxsWO76LRgQxkYPBLRNwe/oopUNWM2UedlIt52CEeOPy/GSN22ivglOQdum/CMvTKqnMpDrW4dw2XIt26niOYdXPYT0sL49Gn8GRDBAtSSIOB3NZad/T25yv+pVtLt/MC65NabjkCFiv8Cinsw0WrRmpY/VIbwUjfqgefSg8RvUJKm1lE
 GaGUJncv
 SGJ7NQmogpgmToND/DjepJSdQFH5hK2ZnEib6TQ0TT0Ohu55MjEEw7y58OzPlAPyOQHDOHl9TlIbAw5a1Ub/7Tb6pkncVMo5tGFkjSKHobiTRQbvA/DNPrjEwltHZCK3cmw+XJ590eiqJlwsvWWTQfWJEYpHz/NtBvDlAjXR26MdaZk/oIxfZ7Ie4KoBEye6ITsGI6cl92YTc4wfycJeYj9mrg3XpgKMitfiBPnkqgYi1KxV19l7x/taiJvncN/zDA3+/+xOIFXc12YwhZedtjf00e9wr4EFnj5J2E64qjjXrvLzO9q/z/kehYUcp72tHPlAFS8Ju1YO3LHKUCEV0WVimq96hv2Z2sgvhlQd4e1Qa07BPA9rR+uErz3VgIho2GylisH2haryupKpCdyk9TfzngAPxPESBrKRctFh4cMwUe07mswoAt40coFB/Ou3VOIeA3eYi+BUXjPrf0Ob/2CVt+Yn6OB+viXTKUoHyTdGnKlXf12teBhDkTrdPt25jOpsA0+KhakqX2kv8YLDyjdb4n1G+jN+Gu+7hTBSIj3McpbQ6y1aeQ2L2Wd+Xa2cmM9/nptzDQgFCIpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the page fault handling path for anonymous PUD THPs, following the
same design as the existing PMD THP fault handlers.

When a process accesses memory in an anonymous VMA that is PUD-aligned
and large enough, the fault handler checks if PUD THP is enabled and
attempts to allocate a 1GB folio. The allocation uses folio_alloc_gigantic.
If allocation succeeds, the folio is mapped at the faulting PUD entry.

Before installing the PUD mapping, page tables are pre-deposited for
future use. A PUD THP will eventually need to be split - whether due
to copy-on-write after fork, partial munmap, mprotect on a subregion,
or memory reclaim. At split time, we need 512 PTE tables (one for each
PMD entry) plus the PMD table itself. Allocating 513 page tables during
split could fail, leaving the system unable to proceed. By depositing
them at fault time when memory pressure is typically lower, we guarantee
the split will always succeed.

The write-protect fault handler triggers when a process tries to write
to a PUD THP that is mapped read-only (typically after fork). Rather
than implementing PUD-level COW which would require copying 1GB of data,
the handler splits the PUD to PTE level and retries the fault. The
retry then handles COW at PTE level, copying only the single 4KB page
being written.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/huge_mm.h |   2 +
 mm/huge_memory.c        | 260 ++++++++++++++++++++++++++++++++++++++--
 mm/memory.c             |   8 +-
 3 files changed, 258 insertions(+), 12 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 5509ba8555b6e..a292035c0270f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -8,6 +8,7 @@
 #include <linux/kobject.h>
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
+vm_fault_t do_huge_pud_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
@@ -25,6 +26,7 @@ static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 #endif
 
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
+vm_fault_t do_huge_pud_wp_page(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d033624d7e1f2..7613caf1e7c30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1294,6 +1294,70 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	return folio;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static struct folio *vma_alloc_anon_folio_pud(struct vm_area_struct *vma,
+		unsigned long addr)
+{
+	gfp_t gfp = vma_thp_gfp_mask(vma);
+	const int order = HPAGE_PUD_ORDER;
+	struct folio *folio = NULL;
+	/*
+	 * Contiguous allocation via alloc_contig_range() migrates existing
+	 * pages out of the target range. __GFP_NOMEMALLOC would allow using
+	 * memory reserves for migration destination pages, but THP is an
+	 * optional performance optimization and should not deplete reserves
+	 * that may be needed for critical allocations. Remove it.
+	 * alloc_contig_range_noprof (__alloc_contig_verify_gfp_mask) will
+	 * cause this to fail without it.
+	 */
+	gfp_t contig_gfp = gfp & ~__GFP_NOMEMALLOC;
+
+	folio = folio_alloc_gigantic(order, contig_gfp, numa_node_id(), NULL);
+
+	if (unlikely(!folio)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+		folio_put(folio);
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+		return NULL;
+	}
+	folio_throttle_swaprate(folio, gfp);
+
+	/*
+	 * When a folio is not zeroed during allocation (__GFP_ZERO not used)
+	 * or user folios require special handling, folio_zero_user() is used to
+	 * make sure that the page corresponding to the faulting address will be
+	 * hot in the cache after zeroing.
+	 */
+	if (user_alloc_needs_zeroing())
+		folio_zero_user(folio, addr);
+	/*
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * folio_zero_user writes become visible before the set_pud_at()
+	 * write.
+	 */
+	__folio_mark_uptodate(folio);
+
+	/*
+	 * Set the large_rmappable flag so that the folio can be properly
+	 * removed from the deferred_split list when freed.
+	 * folio_alloc_gigantic() doesn't set this flag (unlike __folio_alloc),
+	 * so we must set it explicitly.
+	 */
+	folio_set_large_rmappable(folio);
+
+	return folio;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 		struct vm_area_struct *vma, unsigned long haddr)
 {
@@ -1318,6 +1382,40 @@ static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
+{
+	if (likely(vma->vm_flags & VM_WRITE))
+		pud = pud_mkwrite(pud);
+	return pud;
+}
+
+static void map_anon_folio_pud_nopf(struct folio *folio, pud_t *pud,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+	pud_t entry;
+
+	entry = folio_mk_pud(folio, vma->vm_page_prot);
+	entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
+	folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	set_pud_at(vma->vm_mm, haddr, pud, entry);
+	update_mmu_cache_pud(vma, haddr, pud);
+	deferred_split_folio(folio, false);
+}
+
+
+static void map_anon_folio_pud_pf(struct folio *folio, pud_t *pud,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+	map_anon_folio_pud_nopf(folio, pud, vma, haddr);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PUD_NR);
+	count_vm_event(THP_FAULT_ALLOC);
+	count_mthp_stat(HPAGE_PUD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
+	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 {
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -1513,6 +1611,161 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	return __do_huge_pmd_anonymous_page(vmf);
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/* Number of PTE tables needed for PUD THP split: 512 */
+#define NR_PTE_TABLES_FOR_PUD (HPAGE_PUD_NR / HPAGE_PMD_NR)
+
+/*
+ * Allocate page tables for PUD THP pre-deposit.
+ */
+static bool alloc_pud_predeposit_ptables(struct mm_struct *mm,
+					 unsigned long haddr,
+					 pmd_t **pmd_table_out,
+					 int *nr_pte_deposited)
+{
+	pmd_t *pmd_table;
+	pgtable_t pte_table;
+	struct ptdesc *pmd_ptdesc;
+	int i;
+
+	*pmd_table_out = NULL;
+	*nr_pte_deposited = 0;
+
+	pmd_table = pmd_alloc_one(mm, haddr);
+	if (!pmd_table)
+		return false;
+
+	/* Initialize the pmd_huge_pte field for PTE table storage */
+	pmd_ptdesc = virt_to_ptdesc(pmd_table);
+	pmd_ptdesc->pmd_huge_pte = NULL;
+
+	/* Allocate and deposit 512 PTE tables into the PMD table */
+	for (i = 0; i < NR_PTE_TABLES_FOR_PUD; i++) {
+		pte_table = pte_alloc_one(mm);
+		if (!pte_table)
+			goto fail;
+		pud_deposit_pte(pmd_table, pte_table);
+		(*nr_pte_deposited)++;
+	}
+
+	*pmd_table_out = pmd_table;
+	return true;
+
+fail:
+	/* Free any PTE tables we deposited */
+	while ((pte_table = pud_withdraw_pte(pmd_table)) != NULL)
+		pte_free(mm, pte_table);
+	pmd_free(mm, pmd_table);
+	return false;
+}
+
+/*
+ * Free pre-allocated page tables if the PUD THP fault fails.
+ */
+static void free_pud_predeposit_ptables(struct mm_struct *mm,
+					pmd_t *pmd_table)
+{
+	pgtable_t pte_table;
+
+	if (!pmd_table)
+		return;
+
+	while ((pte_table = pud_withdraw_pte(pmd_table)) != NULL)
+		pte_free(mm, pte_table);
+	pmd_free(mm, pmd_table);
+}
+
+vm_fault_t do_huge_pud_anonymous_page(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long haddr = vmf->address & HPAGE_PUD_MASK;
+	struct folio *folio;
+	pmd_t *pmd_table = NULL;
+	int nr_pte_deposited = 0;
+	vm_fault_t ret = 0;
+	int i;
+
+	/* Check VMA bounds and alignment */
+	if (!thp_vma_suitable_order(vma, haddr, PUD_ORDER))
+		return VM_FAULT_FALLBACK;
+
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
+
+	folio = vma_alloc_anon_folio_pud(vma, vmf->address);
+	if (unlikely(!folio))
+		return VM_FAULT_FALLBACK;
+
+	/*
+	 * Pre-allocate page tables for future PUD split.
+	 * We need 1 PMD table and 512 PTE tables.
+	 */
+	if (!alloc_pud_predeposit_ptables(vma->vm_mm, haddr,
+					  &pmd_table, &nr_pte_deposited)) {
+		folio_put(folio);
+		return VM_FAULT_FALLBACK;
+	}
+
+	vmf->ptl = pud_lock(vma->vm_mm, vmf->pud);
+	if (unlikely(!pud_none(*vmf->pud)))
+		goto release;
+
+	ret = check_stable_address_space(vma->vm_mm);
+	if (ret)
+		goto release;
+
+	/* Deliver the page fault to userland */
+	if (userfaultfd_missing(vma)) {
+		spin_unlock(vmf->ptl);
+		folio_put(folio);
+		free_pud_predeposit_ptables(vma->vm_mm, pmd_table);
+		ret = handle_userfault(vmf, VM_UFFD_MISSING);
+		VM_BUG_ON(ret & VM_FAULT_FALLBACK);
+		return ret;
+	}
+
+	/* Deposit page tables for future PUD split */
+	pgtable_trans_huge_pud_deposit(vma->vm_mm, vmf->pud, pmd_table);
+	map_anon_folio_pud_pf(folio, vmf->pud, vma, haddr);
+	mm_inc_nr_pmds(vma->vm_mm);
+	for (i = 0; i < nr_pte_deposited; i++)
+		mm_inc_nr_ptes(vma->vm_mm);
+	spin_unlock(vmf->ptl);
+
+	return 0;
+release:
+	spin_unlock(vmf->ptl);
+	folio_put(folio);
+	free_pud_predeposit_ptables(vma->vm_mm, pmd_table);
+	return ret;
+}
+#else
+vm_fault_t do_huge_pud_anonymous_page(struct vm_fault *vmf)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+vm_fault_t do_huge_pud_wp_page(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	/*
+	 * For now, split PUD to PTE level on write fault.
+	 * This is the simplest approach for COW handling.
+	 */
+	__split_huge_pud(vma, vmf->pud, vmf->address);
+	return VM_FAULT_FALLBACK;
+}
+#else
+vm_fault_t do_huge_pud_wp_page(struct vm_fault *vmf)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 struct folio_or_pfn {
 	union {
 		struct folio *folio;
@@ -1646,13 +1899,6 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
-{
-	if (likely(vma->vm_flags & VM_WRITE))
-		pud = pud_mkwrite(pud);
-	return pud;
-}
-
 static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 87cf4e1a6f866..e5f86c1d2aded 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6142,9 +6142,9 @@ static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	struct vm_area_struct *vma = vmf->vma;
-	/* No support for anonymous transparent PUD pages yet */
+
 	if (vma_is_anonymous(vma))
-		return VM_FAULT_FALLBACK;
+		return do_huge_pud_anonymous_page(vmf);
 	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -6158,9 +6158,8 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret;
 
-	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
-		goto split;
+		return do_huge_pud_wp_page(vmf);
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
 			ret = vma->vm_ops->huge_fault(vmf, PUD_ORDER);
@@ -6168,7 +6167,6 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 				return ret;
 		}
 	}
-split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
 	__split_huge_pud(vma, vmf->pud, vmf->address);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-- 
2.47.3


