Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749E060A263A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=O1EnXG8p
Received: by kanga.kvack.org (Postfix)
	id C48BE6B05C0; Tue, 10 Nov 2026 10:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9D26B05C1; Tue, 10 Nov 2026 10:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98A46B05C2; Tue, 10 Nov 2026 10:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 825596B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E53E61608F1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:59 +0000 (UTC)
X-FDA: 85419531918.10.8C122B1
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id DA09A1C0016
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O1EnXG8p;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iw8lf9lVVTdEkl4zNFPBG5YINbT+Z3k0uho4I4jJR+M=;
	b=eTBqiQSo9tOtCzPyRmTAASN8x2S7eYlSS6GBmFLpINzDVdwPkElTondmHPYjqWJ69Giwn5
	bo8btbIi1SEnlt5+ozTm3oV93qPNUFS99Kkt3emm9/rKr7OSPi+vKsag5RaVuZffxjPXe3
	paTD7v6W9gIm5pC+PN17Ovmed3XlzhY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O1EnXG8p;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323098;
	b=RncNCLUgufcp0lBFpqKNEI8OUIG8YKgRDd/QiCad9qKw7ntfL/XUO584KnFk0Bf1VbNjSA
	rYiOAcbJKQDy/LmcdugEKbfttlkBjSNbq1pSqJPParG6XJ4kbeIzctvKOMFI6wI0Tcys6N
	WHCdj4CzrDHDId974JCfvU3UuV3VW3E=
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-9950a7530d9so1102113241.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323097; x=1794927897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iw8lf9lVVTdEkl4zNFPBG5YINbT+Z3k0uho4I4jJR+M=;
        b=O1EnXG8phC1ChrJ3ozxrGerRHW5APRqEerCF3mJIIDeHVPFYO+gvATdNBzaOqAMZSK
         ddWUwyxJCZxtha5Gkl44MGvINxqbJmB4SKfLebDfVoufxvTKrDle0sOUYSoiJMQGHUdW
         cGzOBI2RG8veqESg8ESYp/FF1AiKxXPD+X721HC3MNUncjRBqPwooIbIv5Tnzmio4g3m
         +W1EWWJnRYLES6q4PtWhmMTvFY2v/UcoVEQFL5MVtfk0wXF1KZfM+lJ8p3xagvqN9eN5
         sb59Cmat97I3NWr2kK55FJ6wClOcA6KrMM+Uv5jxZ40xXTRcluC88p2CfbcfQfwTuTtv
         qeuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323097; x=1794927897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iw8lf9lVVTdEkl4zNFPBG5YINbT+Z3k0uho4I4jJR+M=;
        b=zQGRfdAXJJezYHQGV6+GU4Nch27DaELqnqAQ9zNZC/h6pYwnyruNRIhNcQ38Swz8Ga
         8hKA06OqefKrtjnYFEvspb8ps+JuOmK0ZYQRuigUwVcyAv86x8VB70E8bZOQUQfWR8ay
         qLodFf68y6smghD1ebetqP24cJ5yrhl9Sg+9/5JjsQLN4315QT0hSwuAOolY27elxtYi
         uipX00lkiW+tTSuPihgad/pvNcbxa/5shXzlD9Ibih88l385jkH7KEigzgMMnaJw6ar9
         p7SHFcP4rXYXIfpftYzEhmXBaH/HCMcwTNim5rrlKj5DKtx6VIwvdZOQ05ucDSsLYmJU
         e43A==
X-Gm-Message-State: APuU4Z8jxABHrvS7DsvVb2Bu+kkwATnB2bDiWSuwaOw3uR6j4OIFpaYy
	bUHHcq35daXpiXw3cCe84QkJpop1NiRAiUeir6Eu+IEaaunzupyVaOXMMWit6VNL8w1FLlFN5L0
	sglQB
X-Gm-Gg: AYBFou0a5oslPzbONflah+Y6r+nzFW9vSbkYAWF5dCeDmqu+Atcfq3OHwCNVgcCuc/8
	igb2Cyi9g+VAMa5oztOYIq5ebLmkruKa9+uD8UaqshVE5d9NvgixrLX0D+4JBhHFRTvhpYnJdH7
	Y/J52u5gFXAaZjarvaJ7SEulP3XgZttlTyk9g6Y8iEiOc8BhcYETmH5HsdiGMxbpvHEj6yLC/Vc
	bBE8FvZfToJAPNUYSCZnNpzFnLipeWc69Pq3zkZVCaSoMYeYSY4Bw4BwoTT0GgzGGZnAu4HhA9o
	OuuBxXfFU4sLYQNP7t5C8kk3ujJlWmXNKw0m+qLVhCuKL4Vn0Z9Y/fZyB5zi7hsDi5eN34JOZ6s
	MtiqPsz3EAj3Hu68ajc4wIbpqh5FzFc19+7oQGYwp9xr6UOFHAPjrSgIC99bR08SzFtIvShQH2b
	Ub0QiHtW98k7/BhYpIB193EIFudiDsqv/SL/1b42mC/+REPg5P4lhjg3CU2A8eu0iZCdElcBf6T
	EFCgGnJ+NztbULleLzi1Ey9CmHvDomoKSWm53iO+/mF4hVOJwtxPCYIVURVsIezXMsJyy0N3TYd
	cPAwbYc6aAA4LoOmNeWWgY8NQtAq/nRnsBMpqgBOdFY1n4ItXYb/ZIz/kQXMIamwYwQKd556low
	EUlXgNfhTocFMhpo=
X-Received: by 2002:a05:6122:d25:b0:5ea:aedd:6087 with SMTP id 71dfb90a1353d-5ee0d0d2a9amr1167542e0c.4.1794323096756;
        Tue, 10 Nov 2026 07:04:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:04:55 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v5 2/7] mm: allow shared folios to be promoted to a fast tier
Date: Tue, 10 Nov 2026 10:04:41 -0500
Message-ID: <20261110150446.2452975-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA09A1C0016
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p68fpx9657ebfc6uwi3eiykwbxjmfruh
X-HE-Tag: 1794323097-210683
X-HE-Meta: U2FsdGVkX18Ojrwq4SPPdiMKqgceZjI9l7/Rh5dOfZozU2pUCJHdSKPsggLYHzSt58gU2WdJzH7B1rZU/IROzqR/Oe5/Iy97B2kuopEKoDnWPaMVVvRCG4zpWVc/5MHxnPX4zVM2KjkPYigPxRgapK+ZuWrPqjdCbJvMj+XW5d5nQgxxVtDNLPYkI0OPABYH6Z2U/ZdBNFgAJKYK9heZeiCiosVBBZ5wSGGi/c1RfrBah8HViiqmPTbmkRsJcw+kjbrhQ+1oHrH04+XdpQp7CYAuthCgA1hrhUnH+G946rrC/VLbVobdfJhcWJCne5J7+84r92u+euklGfBXSg6iLabYzFA9Uo25HpSSpLwytgO9GpQWhteD3fC8OV3V4tbduvgOgXm3m1ysEbf7BEsVpsfOkI1VxZkrbNccmlmRbM1zZtNl3u9QcAOPnNxfclczgh1DdhrNxECTl8hJVwcqjc2LqjyfSK2iouvBqas7hrnH7BWKgQqgDdGzCFRRMWQvJG93WxPI3Qy22Pe48bRU+eRy0pQM9KUjNvEh6jkA93KoPRjmChaG4WHl2YmDrA9AQx5O1jP9LpFsI4hmN7+PHxEUABnwxJJRyyA9h8oBBu8h6OeqDJOVcRIeAGNxesQAG/ePaR8wA2uh97uGs6jylL5w791NXxsqdw22yIeA9QDP999P+9C08nofcKx3j8kqBIXdsrkxDUXibUYavS+yHS6v5VTMaKz37dH/7QEXPatD0Do2uuvGN7rSp9kyb21ADFeiuWt+Q63OjNYz5V81eQeqp88AaO6BrK01D52ByBjPEeqVOf37D+YOsPX9BJoy63zuafgQy+Vg5JobXDFYgNN+rtvw2fhihevvzbEawklnOoe0HRlcCmRIGFtxdNEfZy+swiaLE8e9+6EJTJbREmkaXhkod2swVajoAGPRyldbvzBW+PS1fp27k7/jLkIfCQYdH1vSAF8az+0eUgz
 feb1x7Si
 6iNqKhGWJ4h3v0Jt7bpFrskg9rEoXUuoFNKboHFzz2jjbIzmcHQCVECxqGQyRebrUx+6EAtSy13suMCM2TO9Ld9oiyCeUlSA4ue24iRiOTtfZZ4DR14BxShaiHjcDGYabxXKJw2LICADye9iHcXSXcnELW7NsA/4A1ywyTcn3t3wuHfc7FP0fBcCiPe0PSXrKNPpwsxYaiYWYnH5GQKxDkO3SZGgXnRgmV9hg1i+XV0oFYf6ziUyQmf90sxqJ77ZV12S43TEUiphaGW8F69YFfNIdiqzspkzI8hLQHMTtQZd7Xhi++usM6c8ZjTPBOjd2UAyumB36o3Jq0y5qape6p52htTq4SWJLNIHs5QDsxGUQliPFXgymT8jG4KmDBHBh0SshdY6saWCRcqbNPFe/pWEZLLIRyonxpBMfjBEb9/L2qrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NUMA balancing rejects shared copy-on-write folios and executable
file folios mapped by multiple processes to avoid east-west
migration bouncing. These checks break promotion from slow memory.

Allow such folios to participate when the folio being migrated is
a low-tier folio and the destination is top-tier (south->north).
This allows promotion, but prevents east-west or north->south
migrations (north->south is handled by reclaim demotion).

Keep the existing restrictions for ordinary placement and for
migrations that are not slow-to-top-tier promotions.

Rename folio_use_access_time() to folio_numab_promotable() so the name
captures the combined memory-tiering and source-tier test. The helper
retains its existing behavior.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/r/DLHS4KFPQ86I.1J4LN3352RI71@nvidia.com
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h  |  5 +++--
 kernel/sched/fair.c |  2 +-
 mm/memory-tiers.c   |  9 ++++++---
 mm/memory.c         |  2 +-
 mm/mempolicy.c      | 11 ++++++++---
 mm/migrate.c        | 13 +++++++++----
 6 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 40de653041f92..55817dea7307f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2647,7 +2647,7 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 	}
 }
 
-bool folio_use_access_time(struct folio *folio);
+bool folio_numab_promotable(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -2701,7 +2701,8 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 }
-static inline bool folio_use_access_time(struct folio *folio)
+
+static inline bool folio_numab_promotable(struct folio *folio)
 {
 	return false;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5d3d7b61d0257..e353d3d3012ea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2877,7 +2877,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (folio_use_access_time(folio)) {
+	if (folio_numab_promotable(folio)) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 7fc56a8c66518..0df54dc556f19 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -53,16 +53,19 @@ static const struct bus_type memory_tier_subsys = {
 
 #ifdef CONFIG_NUMA_BALANCING
 /**
- * folio_use_access_time - check if a folio reuses cpupid for page access time
+ * folio_numab_promotable - check if NUMA balancing can promote a folio
  * @folio: folio to check
  *
  * folio's _last_cpupid field is repurposed by memory tiering. In memory
  * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
  * record page access time.
  *
- * Return: the folio _last_cpupid is used to record page access time
+ * If memory tiering is disabled, then lowtier has no appreciable meaning,
+ * so we return false (the folio should not be migrated on this distinction).
+ *
+ * Return: true if memory tiering can promote the folio.
  */
-bool folio_use_access_time(struct folio *folio)
+bool folio_numab_promotable(struct folio *folio)
 {
 	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 	       !node_is_toptier(folio_nid(folio));
diff --git a/mm/memory.c b/mm/memory.c
index d477a4f986bc8..e70885653475a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6262,7 +6262,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (folio_use_access_time(folio))
+	if (folio_numab_promotable(folio))
 		*last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		*last_cpupid = folio_last_cpupid(folio);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f0933e9b209c9..49cfeab501b4a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -866,8 +866,13 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
 		return false;
 
-	/* Also skip shared copy-on-write folios */
-	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
+	/*
+	 * Shared copy-on-write folios are poor east-west placement candidates.
+	 * When tiering is enabled, folio_numab_promotable() identifies a
+	 * low-tier folio that needs a hint fault for promotion.
+	 */
+	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
+	    !folio_numab_promotable(folio))
 		return false;
 
 	/* Folios are pinned and can't be migrated */
@@ -894,7 +899,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (vma_is_single_threaded_private(vma) && nid == numa_node_id())
 		return false;
 
-	if (folio_use_access_time(folio))
+	if (folio_numab_promotable(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735b..50a0a2e11a353 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2704,14 +2704,19 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 
 	if (folio_is_file_lru(folio)) {
 		/*
-		 * Do not migrate file folios that are mapped in multiple
-		 * processes with execute permissions as they are probably
-		 * shared libraries.
+		 * Limit east-west migration of file folios mapped in
+		 * multiple processes with execute permissions as they
+		 * are probably shared libraries (limits bouncing).
+		 *
+		 * If this is a low-tier folio, only migrate if the target
+		 * node is toptier (this allows south->north migration while
+		 * disallowing east-west migration between slow tiers).
 		 *
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio) &&
+		    (!folio_numab_promotable(folio) || !node_is_toptier(node)))
 			return -EACCES;
 
 		/*
-- 
2.53.0-Meta


