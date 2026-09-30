Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66836CA5FBE
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7606B0092; Wed, 30 Sep 2026 07:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE1D6B0093; Wed, 30 Sep 2026 07:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75D46B0095; Wed, 30 Sep 2026 07:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8415C6B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E27A074A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:17 +0000 (UTC)
X-FDA: 85270189914.08.5E68E7A
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C5A6A0003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AO4HI+6w;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.76 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lgfVC6O2+5z+LvR6FnOaw/aw8yOZeotv1eEzW1rW6w=;
	b=Wr6AUj0Jv+jrB2teIuF7O/9z8tE702PDFQk7/GfWo4LQYWQ9rFhIMA1Gog/DguoyF+3Cwx
	sM5w446V9pZDhfaXBy8wRyXV0ffaJRW1lpFiIM8SIE8fvhAAXiWnPks/en5t94iEDQr49f
	lk3gm1qykWLHcG+5i/su4WSzDrbhsP4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AO4HI+6w;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.76 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767335;
	b=woCw/G4eiSUqFMMdYi0Pm7ZGxvOfG0LN2PDKARD0hSU5K9KQyLIjd5aRhPXFRxlkSJVup4
	mKusldLulm3cDbrmr9wbWfdophcbPjwNn9hcGaePouNEBVmxC4uZ/F04nI/1mQl7HnMFRB
	oo3KRNKKh3VeylW0H2UAj+BNUqZnoXg=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso4201480f8f.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767334; x=1791372134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+lgfVC6O2+5z+LvR6FnOaw/aw8yOZeotv1eEzW1rW6w=;
        b=AO4HI+6wTxaeqjFqHGaABqA7FwIdKci0AUoUWZFvRcsU4cqOD5ArjA4dhSEUAGx/Tz
         fj34TQNwUjYAaFKKbzo8YETXYY2ko18NSjUZN1jmwqDaQMPV2Uodi8ZSvFADey/cbzng
         wNmp+qQOY5PXa6SlExZz97p2Zep3ykRXsJBP2I1TWpLToymq4WLFmLwqhOWmnlNVDt6i
         hHCZd1ohdE/ThCccz5vJ7OZUoVOvb0KcqqOxEkeBoXhEncOiKZ6d0yINpCF92nyNE/D6
         eKhTFDo3jIoYQUAoZG6rzkNJrxUWAF2e1bzzirBtv92Q5dQ+m3nQRDFhqhCJp4lTXCpq
         ziAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767334; x=1791372134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+lgfVC6O2+5z+LvR6FnOaw/aw8yOZeotv1eEzW1rW6w=;
        b=KQ3YqWCaY6JX/y5aMgZ4QCSJrEnV7p8y9TwiuGFrLewBm0OguoxqJKzfB/LJeQv5fq
         b2uHP4duh+k8N9wCTDGT8GFzWLEvyAoy0osajfreSmu2Gvd0j3jDmI5B9E2RqnTWe01V
         R5KdQTZ+TQ57RA/SN3/UvIGdxfX1nIsVq3z0Z22ijKlkmOnqovERD05q/o4GvnbXvoLN
         MrDgUyl51Bk+VAAhKmvR5GOJEql4cE06Ab/BvJutd9XwKcyc0gErWms5NDgCRwZiyav0
         +E4ERLtfaJZNY+BIEqVuMGnL3kNBsa/YOewMYw3/q61ZQ+jckXd4YyILBDXbctXR8Aww
         SSkA==
X-Gm-Message-State: AFuF++mKtBrCfwNteALkcOiHWY/fuxomoxrGOJ524eYLmEUqLRXFumqx
	hCwpDkLRUBHCawn0FebVX7Ttg8NpLkp5XwTlOcoCOW9CUKII5I3OIwXfICqFxS5zxydBqgC3cBw
	GYL7Q7ow4Rg==
X-Gm-Gg: AYBFou10LGdKKmFK8QNvJu5bcHyYw47o2ykFBNziYVgDnsC2vi9ytTtpAQXecYCGMo1
	JEJk8r8eqMJxXyU/AOCZWUczclmUMavqGNp5Yai5dSd7A//GE2wyJWg8ZcLBOBYZtshHMBn5Yte
	BKVqR23zlRRua7gVxVXnMfdhViaXBz+jYcBWgOaoRui3UdoSP7/MAGOe42I/8gRhVTLsBQ2PjcB
	gPbsHBRCLmTR4QXJiVzytIGDAkJVy+lgAGUZVBwptxIK4mOYWdKFOseanmkwwL/FszDYy3ZZCYK
	aH4UaUyRYNwicKuCN9Sx3bXiz7GCVlppI+5SMXzAxszsJ5tDensk7lg5CtV3KgudTFd9vmm7uga
	HV2Umrwj+14vET4veHAfTAwQVRgaLotwi+rykrzras6Vll9vX+E1v0alAMP3IUewoBXcIC+WsRD
	45aLw47EW0pq0H4nNdDyHG6hd8L9z7YrKn0F2T1KSlZ+T34ph/9N/G2OHPuiI6ELjfO3ZZPyNHp
	eL4Wbzw+8xh5gWHGVzx1IL3vGo=
X-Received: by 2002:a05:600c:4f56:b0:49f:ce73:4b with SMTP id 5b1f17b1804b1-4a01b010271mr22762315e9.35.1790767333702;
        Wed, 30 Sep 2026 04:22:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:13 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
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
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
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
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v4 2/7] mm: allow shared folios to be promoted to a fast tier
Date: Wed, 30 Sep 2026 07:22:01 -0400
Message-ID: <20260930112206.205083-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d4g9mnaa4b8n3m31efk3tfohpufntimi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C5A6A0003
X-HE-Tag: 1790767335-732997
X-HE-Meta: U2FsdGVkX1/7rlDo7NUlik+H2AFGrIMtWtTn0GUzTs/VowFuaGisWHkwLuhkLOYms+Hv4zx1ZprOrVZWqJ8cGAKrRouJKODs2O+HqLyl8XP4eh4eT9W89lOroplQcCRfViS5xTbKl5I4N6BkZF0rEqlW3wTeiX9sUhHU5QtQfRYwYqarMxMrmwXg98BPa7Ni9WhZSdNmq2Ly7DEjzlC3XsADAwBPhj9O5eTM146NnJet06NR7nGsnbsM3lLTvAfHgcsCsavfU1Jskl/ImrPtVGS2GzXYU4ntXM+WWm57bHqbaZP3UbfT935QP9bomZ/3CWBhnRGlpGytnjEdyxMB+vCLWaZN9b4CM3CMSLeHhsLqdNaP6L8BPYU3SXvnaL+w0GcF5fO/PKGG+I0v7GIvdpw/kIhdxThC13AMS+T1EeJLHsOb9pR2Q22EVTckq7ENV67lpMhbyDjm1PSqi6xVnl/2LBHXP14AKSna+DL1pLcOtoesTOuazdbAo9RZJS7GStMlJBoZb10oDvqUvVEhquthMJ3kmhQMg3Oe4pAqdIwf+LQU1y5LFM0hIhK2TioVWjNCwwJ63F6C+V8xRsiG1uufGICliXXSEjzG1Rn/EyLW5hf2mGLr7SQ+NIPWTGSOuw9c0pGKgBlqtkdaDCwbDwe311FYk3uESomgKW9Ypl26EDVjokhTPhKtw8C0zIeCk0QXgT6P72xzzVvOZmrlQ13eFkQ4DluaXvn2Dgc43X7xFaloDnYtFqFb8rwIiyhp4utZtEzfnJ8iRViY4tW9uKJBvZaH9r7SAm5gsuU/t+hqFnsw8x6bCAnFpPBFL8vvXm39PHymN9XJkxuqYH06Nk2MOz5veqnRsAJcoYFR2IjTkionXHtS2nzYkoT4sMJG4kD0uAzzDCtU2UxxH9RsfdqMnPUpQ2pFq6WjdFpnnAEyBOgvRDUp5GI244PSs4edsk8bcOT3gmwa59mNQsf
 8YX88YD6
 AWKmyG7vD9QsBvklP89HgxscXMV6EpK9khEvHBXIS79blooSa6AdxIuARzIOoXUSYx7XHugUEKrbQZQOsIm3bSXu+i/L/1V9LDyxrtfYdWNQujQ7HPlx9Nkgb5XjMK1XHGQHiDuaHMMaTYWRw+fAk0guhtCpiUBZ1IalJalIbuMYENqP3z54ompR7LffZN5FVEOUxkUag8mfjP+EMPZqZMrg0lU4jsK/sF5rtWPA24FlvvHeYrbrueEjA9ejP+QE3JbjdDUl/rUbm8BcytHExCFkkGTkqpv0aHkMZbBjtvFgUcmbvXA1HKFMbB454zJIsSoGw+rwA0d3rz/TuENjdk85OpzG+d3r98j6D3Q0kPivv8u11JAYe6vV8tFZ0lXdKjw+T8fEphfXj9A/mv3Q4L7EQh3iEsek5fJxASXZ1/fbrC8e2eyexCPS7dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

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
index 623ae61e52cb..69107e877fd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2672,7 +2672,7 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 	}
 }
 
-bool folio_use_access_time(struct folio *folio);
+bool folio_numab_promotable(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -2726,7 +2726,8 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
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
index c3dfa398d0bd..3be18cf10eca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2742,7 +2742,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (folio_use_access_time(folio)) {
+	if (folio_numab_promotable(folio)) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b58..086d5695e656 100644
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
index 330cde31bf8b..4ab6db22ad4c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6240,7 +6240,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (folio_use_access_time(folio))
+	if (folio_numab_promotable(folio))
 		*last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		*last_cpupid = folio_last_cpupid(folio);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8ff37f60b710..f70f4f795840 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -864,8 +864,13 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
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
@@ -892,7 +897,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (vma_is_single_threaded_private(vma) && nid == numa_node_id())
 		return false;
 
-	if (folio_use_access_time(folio))
+	if (folio_numab_promotable(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..c0f5f3ac71fc 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2694,14 +2694,19 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 
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
2.55.0


