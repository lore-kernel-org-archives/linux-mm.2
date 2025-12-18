Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DB0D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDE46B0088; Thu, 18 Dec 2025 10:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B456B0089; Thu, 18 Dec 2025 10:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A4D6B008A; Thu, 18 Dec 2025 10:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 232056B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:09:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B89DD12AF3
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:14 +0000 (UTC)
X-FDA: 84232925028.10.55390B5
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id C593D8001A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dePocgN5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070553; a=rsa-sha256;
	cv=none;
	b=E2sPXSS+EEUiDLDV+QyH4TZlrHhMRg17MokThS5CyTU/hBNY7OFa1URV/U8uBU9/fW16IN
	QQu++6Q/aMDXpTGPJyqNxdqlL6ThyqGPZ6I5VRtuo2QJX61nsEhM8FXn7qFgPbewsHnYaG
	CRMFhu+MhU762ww1wbC2xsynHpBGwZc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dePocgN5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RQnvrflM+4VUGrDiX0hDzFZSzRTNeGgrB9knnQMS9Oc=;
	b=o3b4vnidcK5ehuadeUGqtE+QbCHqht1YTt1rTRUBcHlsA4uglsEhyDE3GYxRtax1pejoOM
	nW/r2/lbvId8vV7EnxpvxdxJY3WVCJO+m5YoNdGACuuNYTDre74Ujoflh/20ar+Vlo5O1e
	gaIHuOaqanGMUUjG4lt9yIJh6NqjNTE=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-430f3ef2d37so528026f8f.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766070551; x=1766675351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RQnvrflM+4VUGrDiX0hDzFZSzRTNeGgrB9knnQMS9Oc=;
        b=dePocgN5E/9ucwyw2YKBRJOHIzy14iC/KJX5Ez2n2jOeyIYITce0llcm6qmIGRoqaW
         GOtN4o8XOrS+KRJpxtDHv2+u4XMo6+yOjyBFvjoUuozvCcZibYVHHgwapJI0RX8EjBEI
         O95mqkL6wBrGEfQzuq9qxrh9sllXUmqWNktMhPFpXF/j6pHzBugXp0nPiFzUqeHJ6y0y
         5/8ZVLKvDWM+7eRX00F2K9/lzn2Rbt0f93q7LO3mQwjOR42a/UlhauihdOfSwBIdYeTT
         Yb+mLDZyOBECE0mal6IE84zVu5SzHplAG/1v8z2xnfxy6aVnw5qtxfWTBQsOFhAp2h2d
         9rBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070551; x=1766675351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQnvrflM+4VUGrDiX0hDzFZSzRTNeGgrB9knnQMS9Oc=;
        b=sqUuTsVuS2zBL5k85eq+GYcuN40W8aeJge95bjKCGUEH08a6WKWsSjrfjqOzKhOvAZ
         h8e9OPjJTMrUVqcXgruOV6ZX10JqCJjkde7O7m2/VPUJnRarwMwbLajZvQzvmm2T5paz
         JhAFksAjkitpEpuaffuGwi4g1g9SoiUFHvAmDi/GwYInNgepsuU5pGuVrpXB8kim0vaa
         7EiduilasoOCbBK9n9zLuUIhrPY+eCv69x5YeC1WDNEQzvUG4D9Nf7klOVeFnPFZ0Ohx
         cpK6ELEBjLu/R7B3gd3nLAJK7GecrlJpCG/n9x1eJF28eIi+noPtlBRGkMECtjb1Rmwi
         u7DQ==
X-Gm-Message-State: AOJu0YwlRIutO7oZ/+a7MWNgGdQi2jKHm0j/uyW+v5vQnxt+V7MEHzWz
	pGyw1iPUQ7g9VquGg9EOOlN6Ndfpfp98a1zwkU0GF937U4bdXzLanOiGghghvQ==
X-Gm-Gg: AY/fxX777VRCtI7ZEt4olPgWzwVWDpheXy0Ib8pHW7C3hE1HkZw+yJ5Q4s1StjmzkM/
	lZ5vzkHS+Pvbw1iKpwPwkrOEliytnluAuZrTWCZabNAVNExqKRdM4J9GnSHdAkT4hf5XBn8o8a2
	V4S2A82OO9R+oIxnToZKNAIu3AxVg3xbrOlKA4JEHyuNkftYsaOuaqmb9q/DQeK6FJjjQsETQPp
	6G4dpwtZajCwtcoGRsBdg4CJL8504OXpFy6yzM1SZWsNrlUsIK8KAvammNtSsM9AG/2sKQ0E/KV
	GWpBmL0NL18sD3Q0xiU0UgfbMQtbRmYJFYTW/29o6Ub5gqG3zv10dm2e2Y7WvaQEhvHFGOHESuj
	XkmZTOXNq7Tfc9SLEpwUNqAAjDwiOKK+yw+XkyZi9pz+37aVW2cWlei8C7VaPWoVCuDIQ4qFb3/
	QSoYs1U2s8yALGuBMfwm+I/CKfqaZOmeKYkX/JugwsweGWjhDJ4zoev52b5rJDYrTRDoZHl1+jo
	Anzl6D2twXhRYRM9Q==
X-Google-Smtp-Source: AGHT+IGFWLhnIB+xJDV0gALdWMWgZJk9I2zVSufc3aL7vUW62aA1qxW5PSap4+tTDdTl0aBTCtwmyg==
X-Received: by 2002:adf:f788:0:b0:42f:ba58:6599 with SMTP id ffacd0b85a97d-42fba5866abmr17691697f8f.35.1766070550232;
        Thu, 18 Dec 2025 07:09:10 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244934c29sm5601224f8f.2.2025.12.18.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:09:09 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH] mm: fix minor spelling mistakes in comments
Date: Thu, 18 Dec 2025 16:09:06 +0100
Message-ID: <20251218150906.25042-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C593D8001A
X-Stat-Signature: iqg73yqcz893aikx7g5kgc59oqn9hdgc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766070552-619
X-HE-Meta: U2FsdGVkX19sFdVVhBsZqq/YDQpdZYlfwrE36IrFaF0rU9AyTRFzyHkwuioTuEhBiy3yhtmWgZnpPMzZqY0Dy8MeSmIx+zOl+uxP+ipH1MSXjcBl2TRkqbIBJ1q+z2drnY2xiJCPKXhccA7KuTTMZN/7SV+Od3hw/APMo+3Ke1cZnUUHgvPTVgkN9d+HQAmetknH/De3HjY0M41MgVQWNDjqMzuNTqUfiC+UbkZiefZOfADlJdEFLDaOBt+3n4g60iWaJ0lGttBanU260dsl/PtWBGrn88R8XAtnTmpCeRAoiQ471fusFrH8aUnAnJIvF8NUddiHGywgqRGEi31/R/CaF4+80Du6dnejfnoi6bIntiXiGLIuIdoZoo2MGfSdjNRaZRSOKnh58ekPuy1ydnCc8B3a5VyJvoT3786oQ1ns4R+A7nz89KG7f6ra6pXwPdOaPpSd3OvBomuJlGJfb8fBtFfTXlLNKPlncavENjP1Yo+ISBTC+qo1ytsXmGYo8xXkMezmuuNHY7NGjrisicHtQ+yuzvUHwwgnj1MgqBGp3B9/ryR5PnygXX+g4YGzJFO+8DKSJ1ujLF+/siWdzYyQTUPUsScGbmxA9VFLJeA+xkh+/Jo4tb6PafSemCmLEMXgntnUNzL6pq4nX1rHb7g0psRUneujgIK9tBVy2NwA/SHot2V69TtNwDYuDx7bw1HUcIlxkZVFOxXtm4tsY9CoPovB51ZYBTYVPSkxsB0jNUbM2l77wSdsO468iJ1SQfgBn5N06q+/Jt1wfSq2s+FQBzal4TGQBunbiF2Bf2Eh86v5tP3a0wp8fFYwLcw+AmCExCFYDgd1YQhuNTkgvntBt6HMjue85VafovNOArKADwozOpIhgfks4PsmbQPbzxgSN8d22zEOVSa+pLRyVcXHsPkAYZ1iriyuDNvYL0n7m8R9ZSP/dJ6A6dMtZ8Hf5oAOr4YMWKyWS6xD37S
 BGG1UJMp
 D6b0/TIEzt/uQd8BkhsBMwUrq/oq9UJkJiL5ABOXRmUQgaCphEYGerwkxPq1VRyt2wgYbajXm7VDAc91Woga/hNmcXgo00U9yIGlsXQsqNEYoBK5D/SF0rmJZuxbNol5lv1rgo5V6ghHYYtuD16S9Eg5GUhpmAP+j09FJyCQaqd+7Vmqa2UeEFlppo1UKjA5B4jl2f76L3fUvOCZL+jDJZm5GwVciRJqPE0BLvC3qqhYYSp7Rz/aV20kwghS4KyK1O/nONNp7lAL0zrocdJX/CmLHo4AZRN+Cey9FjuvjsBVtNfdM9IPknWYSvselKDxELeQWRqiITBE3oTIKcAH2b9NhFAys+m6zj2/UuYikTorNICBJssXwjMk2ctiYnU5XTiZbO7CxTEg6ReeP3qLTrx8Kt6nhxIMQ7fdI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

Correct several typos in comments across files in mm/

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/internal.h       | 2 +-
 mm/madvise.c        | 2 +-
 mm/memblock.c       | 4 ++--
 mm/memcontrol.c     | 2 +-
 mm/memory-failure.c | 2 +-
 mm/memory-tiers.c   | 2 +-
 mm/memory.c         | 4 ++--
 mm/memory_hotplug.c | 4 ++--
 mm/migrate_device.c | 4 ++--
 mm/mm_init.c        | 6 +++---
 mm/mremap.c         | 6 +++---
 mm/mseal.c          | 4 ++--
 mm/numa_memblks.c   | 2 +-
 mm/page_alloc.c     | 4 ++--
 mm/page_io.c        | 4 ++--
 mm/page_isolation.c | 2 +-
 mm/page_reporting.c | 2 +-
 mm/swap.c           | 2 +-
 mm/swap.h           | 2 +-
 mm/swap_state.c     | 2 +-
 mm/swapfile.c       | 2 +-
 mm/userfaultfd.c    | 4 ++--
 mm/vma.c            | 4 ++--
 mm/vma.h            | 8 ++++----
 mm/vmscan.c         | 2 +-
 mm/vmstat.c         | 2 +-
 mm/zsmalloc.c       | 2 +-
 27 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..db4e97489f66 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -171,7 +171,7 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 
 	/*
 	 * OK, we tried to call the file hook for mmap(), but an error
-	 * arose. The mapping is in an inconsistent state and we most not invoke
+	 * arose. The mapping is in an inconsistent state and we must not invoke
 	 * any further hooks on it.
 	 */
 	vma->vm_ops = &vma_dummy_vm_ops;
diff --git a/mm/madvise.c b/mm/madvise.c
index 6bf7009fa5ce..863d55b8a658 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1867,7 +1867,7 @@ static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
  * madvise_should_skip() - Return if the request is invalid or nothing.
  * @start:	Start address of madvise-requested address range.
  * @len_in:	Length of madvise-requested address range.
- * @behavior:	Requested madvise behavor.
+ * @behavior:	Requested madvise behavior.
  * @err:	Pointer to store an error code from the check.
  *
  * If the specified behaviour is invalid or nothing would occur, we skip the
diff --git a/mm/memblock.c b/mm/memblock.c
index 905d06b16348..e76255e4ff36 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -773,7 +773,7 @@ bool __init_memblock memblock_validate_numa_coverage(unsigned long threshold_byt
 	unsigned long start_pfn, end_pfn, mem_size_mb;
 	int nid, i;
 
-	/* calculate lose page */
+	/* calculate lost page */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		if (!numa_valid_node(nid))
 			nr_pages += end_pfn - start_pfn;
@@ -2414,7 +2414,7 @@ EXPORT_SYMBOL_GPL(reserve_mem_find_by_name);
 
 /**
  * reserve_mem_release_by_name - Release reserved memory region with a given name
- * @name: The name that is attatched to a reserved memory region
+ * @name: The name that is attached to a reserved memory region
  *
  * Forcibly release the pages in the reserved memory region so that those memory
  * can be used as free memory. After released the reserved region size becomes 0.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a01d3e6c157d..75fc22a33b28 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4976,7 +4976,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	memcg = folio_memcg(old);
 	/*
 	 * Note that it is normal to see !memcg for a hugetlb folio.
-	 * For e.g, itt could have been allocated when memory_hugetlb_accounting
+	 * For e.g, it could have been allocated when memory_hugetlb_accounting
 	 * was not selected.
 	 */
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(old) && !memcg, old);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8565cf979091..5a88985e29b7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -864,7 +864,7 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
  *
  * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
- * the buddy system, or hole-punnched out of the file mapping.
+ * the buddy system, or hole-punched out of the file mapping.
  */
 static const char *action_name[] = {
 	[MF_IGNORED] = "Ignored",
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..20aab9c19c5e 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -648,7 +648,7 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 	if (node_memory_types[node].memtype == memtype || !memtype)
 		node_memory_types[node].map_count--;
 	/*
-	 * If we umapped all the attached devices to this node,
+	 * If we unmapped all the attached devices to this node,
 	 * clear the node memory type.
 	 */
 	if (!node_memory_types[node].map_count) {
diff --git a/mm/memory.c b/mm/memory.c
index d1cd2d9e1656..c8e67504bae4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5932,7 +5932,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	else
 		*last_cpupid = folio_last_cpupid(folio);
 
-	/* Record the current PID acceesing VMA */
+	/* Record the current PID accessing VMA */
 	vma_set_access_pid_bit(vma);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
@@ -6251,7 +6251,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		 * Use the maywrite version to indicate that vmf->pte may be
 		 * modified, but since we will use pte_same() to detect the
 		 * change of the !pte_none() entry, there is no need to recheck
-		 * the pmdval. Here we chooes to pass a dummy variable instead
+		 * the pmdval. Here we choose to pass a dummy variable instead
 		 * of NULL, which helps new user think about why this place is
 		 * special.
 		 */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..389989a28abe 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -926,7 +926,7 @@ static struct zone *default_kernel_zone_for_pfn(int nid, unsigned long start_pfn
  *
  *   MOVABLE : KERNEL_EARLY
  *
- * Whereby KERNEL_EARLY is memory in one of the kernel zones, available sinze
+ * Whereby KERNEL_EARLY is memory in one of the kernel zones, available since
  * boot. We base our calculation on KERNEL_EARLY internally, because:
  *
  * a) Hotplugged memory in one of the kernel zones can sometimes still get
@@ -1258,7 +1258,7 @@ static pg_data_t *hotadd_init_pgdat(int nid)
 	 * NODE_DATA is preallocated (free_area_init) but its internal
 	 * state is not allocated completely. Add missing pieces.
 	 * Completely offline nodes stay around and they just need
-	 * reintialization.
+	 * reinitialization.
 	 */
 	pgdat = NODE_DATA(nid);
 
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 0346c2d7819f..0a8b31939640 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1419,10 +1419,10 @@ EXPORT_SYMBOL(migrate_device_range);
 
 /**
  * migrate_device_pfns() - migrate device private pfns to normal memory.
- * @src_pfns: pre-popluated array of source device private pfns to migrate.
+ * @src_pfns: pre-populated array of source device private pfns to migrate.
  * @npages: number of pages to migrate.
  *
- * Similar to migrate_device_range() but supports non-contiguous pre-popluated
+ * Similar to migrate_device_range() but supports non-contiguous pre-populated
  * array of device pages to migrate.
  */
 int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index d86248566a56..0927bedb1254 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -187,7 +187,7 @@ void mm_compute_batch(int overcommit_policy)
 	/*
 	 * For policy OVERCOMMIT_NEVER, set batch size to 0.4% of
 	 * (total memory/#cpus), and lift it to 25% for other policies
-	 * to easy the possible lock contention for percpu_counter
+	 * to ease the possible lock contention for percpu_counter
 	 * vm_committed_as, while the max limit is INT_MAX
 	 */
 	if (overcommit_policy == OVERCOMMIT_NEVER)
@@ -1745,7 +1745,7 @@ static void __init free_area_init_node(int nid)
 	lru_gen_init_pgdat(pgdat);
 }
 
-/* Any regular or high memory on that node ? */
+/* Any regular or high memory on that node? */
 static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
@@ -2045,7 +2045,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
  * Initialize and free pages.
  *
  * At this point reserved pages and struct pages that correspond to holes in
- * memblock.memory are already intialized so every free range has a valid
+ * memblock.memory are already initialized so every free range has a valid
  * memory map around it.
  * This ensures that access of pages that are ahead of the range being
  * initialized (computing buddy page in __free_one_page()) always reads a valid
diff --git a/mm/mremap.c b/mm/mremap.c
index 8275b9772ec1..8391ae17de64 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -678,7 +678,7 @@ static bool can_realign_addr(struct pagetable_move_control *pmc,
 	/*
 	 * We don't want to have to go hunting for VMAs from the end of the old
 	 * VMA to the next page table boundary, also we want to make sure the
-	 * operation is wortwhile.
+	 * operation is worthwhile.
 	 *
 	 * So ensure that we only perform this realignment if the end of the
 	 * range being copied reaches or crosses the page table boundary.
@@ -926,7 +926,7 @@ static bool vrm_overlaps(struct vma_remap_struct *vrm)
 /*
  * Will a new address definitely be assigned? This either if the user specifies
  * it via MREMAP_FIXED, or if MREMAP_DONTUNMAP is used, indicating we will
- * always detemrine a target address.
+ * always determine a target address.
  */
 static bool vrm_implies_new_addr(struct vma_remap_struct *vrm)
 {
@@ -1806,7 +1806,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	/*
 	 * move_vma() need us to stay 4 maps below the threshold, otherwise
 	 * it will bail out at the very beginning.
-	 * That is a problem if we have already unmaped the regions here
+	 * That is a problem if we have already unmapped the regions here
 	 * (new_addr, and old_addr), because userspace will not know the
 	 * state of the vma's after it gets -ENOMEM.
 	 * So, to avoid such scenario we can pre-compute if the whole
diff --git a/mm/mseal.c b/mm/mseal.c
index ae442683c5c0..316b5e1dec78 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -21,7 +21,7 @@
  * It disallows unmapped regions from start to end whether they exist at the
  * start, in the middle, or at the end of the range, or any combination thereof.
  *
- * This is because after sealng a range, there's nothing to stop memory mapping
+ * This is because after sealing a range, there's nothing to stop memory mapping
  * of ranges in the remaining gaps later, meaning that the user might then
  * wrongly consider the entirety of the mseal()'d range to be sealed when it
  * in fact isn't.
@@ -124,7 +124,7 @@ static int mseal_apply(struct mm_struct *mm,
  *  -EINVAL:
  *   invalid input flags.
  *   start address is not page aligned.
- *   Address arange (start + len) overflow.
+ *   Address range (start + len) overflow.
  *  -ENOMEM:
  *   addr is not a valid address (not allocated).
  *   end (start + len) is not a valid address.
diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..7779506fd29e 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -465,7 +465,7 @@ int __init numa_memblks_init(int (*init_func)(void),
 	 * We reset memblock back to the top-down direction
 	 * here because if we configured ACPI_NUMA, we have
 	 * parsed SRAT in init_func(). It is ok to have the
-	 * reset here even if we did't configure ACPI_NUMA
+	 * reset here even if we didn't configure ACPI_NUMA
 	 * or acpi numa init fails and fallbacks to dummy
 	 * numa init.
 	 */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7ab35cef3cae..8a7d3a118c5e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1829,7 +1829,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	/*
 	 * As memory initialization might be integrated into KASAN,
-	 * KASAN unpoisoning and memory initializion code must be
+	 * KASAN unpoisoning and memory initialization code must be
 	 * kept together to avoid discrepancies in behavior.
 	 */
 
@@ -7629,7 +7629,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
 	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
 	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called form hard IRQ or
+	 * confuse PI logic, so return immediately if called from hard IRQ or
 	 * NMI.
 	 *
 	 * Note, irqs_disabled() case is ok. This function can be called
diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce3..a2c034660c80 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -450,14 +450,14 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
-	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically (scan_swap_map_slots),
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, swap_plug);
 	/*
-	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically (scan_swap_map_slots),
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f72b6cd38b95..b5924eff4f8b 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -301,7 +301,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
  * pageblock. When not all pageblocks within a page are isolated at the same
  * time, free page accounting can go wrong. For example, in the case of
  * MAX_PAGE_ORDER = pageblock_order + 1, a MAX_PAGE_ORDER page has two
- * pagelbocks.
+ * pageblocks.
  * [      MAX_PAGE_ORDER         ]
  * [  pageblock0  |  pageblock1  ]
  * When either pageblock is isolated, if it is a free page, the page is not
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61d8c..8a03effda749 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -123,7 +123,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 			continue;
 
 		/*
-		 * If page was not comingled with another page we can
+		 * If page was not commingled with another page we can
 		 * consider the result to be "reported" since the page
 		 * hasn't been modified, otherwise we will need to
 		 * report on the new larger page when we make our way
diff --git a/mm/swap.c b/mm/swap.c
index 2260dcd2775e..bb19ccbece46 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -513,7 +513,7 @@ void folio_add_lru(struct folio *folio)
 EXPORT_SYMBOL(folio_add_lru);
 
 /**
- * folio_add_lru_vma() - Add a folio to the appropate LRU list for this VMA.
+ * folio_add_lru_vma() - Add a folio to the appropriate LRU list for this VMA.
  * @folio: The folio to be added to the LRU.
  * @vma: VMA in which the folio is mapped.
  *
diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..3dcf198b05e3 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -236,7 +236,7 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
- * used are valid and stablize the device by any of the following ways:
+ * used are valid and stabilize the device by any of the following ways:
  * - Hold a reference by get_swap_device(): this ensures a single entry is
  *   valid and increases the swap device's refcount.
  * - Locking a folio in the swap cache: this ensures the folio's swap entries
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5f97c6ae70a2..c6f661436c9a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -82,7 +82,7 @@ void show_swap_cache_info(void)
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock nd check if the folio still matches the swap entry before
+ * must lock and check if the folio still matches the swap entry before
  * use (e.g., folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..76273ad26739 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2018,7 +2018,7 @@ swp_entry_t get_swap_page_of_type(int type)
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
 			/*
-			 * Grab the local lock to be complaint
+			 * Grab the local lock to be compliant
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index b11f81095fa5..d270d5377630 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1274,7 +1274,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	 * Use the maywrite version to indicate that dst_pte will be modified,
 	 * since dst_pte needs to be none, the subsequent pte_same() check
 	 * cannot prevent the dst_pte page from being freed concurrently, so we
-	 * also need to abtain dst_pmdval and recheck pmd_same() later.
+	 * also need to obtain dst_pmdval and recheck pmd_same() later.
 	 */
 	dst_pte = pte_offset_map_rw_nolock(mm, dst_pmd, dst_addr, &dst_pmdval,
 					   &dst_ptl);
@@ -1330,7 +1330,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		goto out;
 	}
 
-	/* If PTE changed after we locked the folio them start over */
+	/* If PTE changed after we locked the folio then start over */
 	if (src_folio && unlikely(!pte_same(src_folio_pte, orig_src_pte))) {
 		ret = -EAGAIN;
 		goto out;
diff --git a/mm/vma.c b/mm/vma.c
index fc90befd162f..bf62ac1c52ad 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2909,8 +2909,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	/*
 	 * Adjust for the gap first so it doesn't interfere with the
 	 * later alignment. The first step is the minimum needed to
-	 * fulill the start gap, the next steps is the minimum to align
-	 * that. It is the minimum needed to fulill both.
+	 * fulfill the start gap, the next steps is the minimum to align
+	 * that. It is the minimum needed to fulfill both.
 	 */
 	gap = vma_iter_addr(&vmi) + info->start_gap;
 	gap += (info->align_offset - gap) & info->align_mask;
diff --git a/mm/vma.h b/mm/vma.h
index abada6a64c4e..de817dc695b6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -264,7 +264,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /**
- * vma_modify_flags() - Peform any necessary split/merge in preparation for
+ * vma_modify_flags() - Perform any necessary split/merge in preparation for
  * setting VMA flags to *@vm_flags in the range @start to @end contained within
  * @vma.
  * @vmi: Valid VMA iterator positioned at @vma.
@@ -292,7 +292,7 @@ __must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		vm_flags_t *vm_flags_ptr);
 
 /**
- * vma_modify_name() - Peform any necessary split/merge in preparation for
+ * vma_modify_name() - Perform any necessary split/merge in preparation for
  * setting anonymous VMA name to @new_name in the range @start to @end contained
  * within @vma.
  * @vmi: Valid VMA iterator positioned at @vma.
@@ -316,7 +316,7 @@ __must_check struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
 		struct anon_vma_name *new_name);
 
 /**
- * vma_modify_policy() - Peform any necessary split/merge in preparation for
+ * vma_modify_policy() - Perform any necessary split/merge in preparation for
  * setting NUMA policy to @new_pol in the range @start to @end contained
  * within @vma.
  * @vmi: Valid VMA iterator positioned at @vma.
@@ -340,7 +340,7 @@ __must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
 		   struct mempolicy *new_pol);
 
 /**
- * vma_modify_flags_uffd() - Peform any necessary split/merge in preparation for
+ * vma_modify_flags_uffd() - Perform any necessary split/merge in preparation for
  * setting VMA flags to @vm_flags and UFFD context to @new_ctx in the range
  * @start to @end contained within @vma.
  * @vmi: Valid VMA iterator positioned at @vma.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 77018534a7c9..8bdb1629b6eb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1063,7 +1063,7 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO
 	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically (scan_swap_map_slots),
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..bd2af431ff86 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1626,7 +1626,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 	}
 }
 
-/* Print out the free pages at each order for each migatetype */
+/* Print out the free pages at each order for each migratetype */
 static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
 {
 	int order;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5bf832f9c05c..84da164dcbc5 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -105,7 +105,7 @@
 
 /*
  * On systems with 4K page size, this gives 255 size classes! There is a
- * trader-off here:
+ * trade-off here:
  *  - Large number of size classes is potentially wasteful as free page are
  *    spread across these classes
  *  - Small number of size classes causes large internal fragmentation
-- 
2.47.3


