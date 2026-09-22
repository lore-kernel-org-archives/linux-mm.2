Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63522C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BDA6B009D; Tue, 22 Sep 2026 14:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CE06B009E; Tue, 22 Sep 2026 14:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9631E6B009F; Tue, 22 Sep 2026 14:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 696B06B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5BF1120543
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:37 +0000 (UTC)
X-FDA: 85242236394.02.007EC92
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf28.hostedemail.com (Postfix) with ESMTP id 34227C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="pWeaj/VF";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101776;
	b=jgOaN40Fu+yzaI7J9HJk0iDT7RQzlLGzjfdzlI8Lp/LFAwDuH7Vlv12mnLNamZVWR6G17m
	7TcmNCOdjkTbFAAvQCZ9mE6NfUGCtO7nhO94UfKZIxyHeLNwM9k+IGcjkqQFqi98ZhCLx2
	Zsv4jYmOv8yh4imZ73GoqQDuJ+p//P4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="pWeaj/VF";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRwVfr0lfTUMkgCOhTSEinsHZrcpdOMoOOSVu7rzRt8=;
	b=10AEt/WJWP1/WkXGjOowWRzkNg0CUspkOgGvcs75+L5rTYeLcns/ddWWeYcFjRM6fJJluY
	RbX6HWzNp4/y0BGO6F4BGd2Ymun3E3EH4306BaKjEefvgcsWWUMxeccTrmjDbPFS9uxobb
	QkUJMvssf1O4c9Mh+gMS+Za97pg3qwk=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939ca12ab70so18248585a.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101775; x=1790706575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NRwVfr0lfTUMkgCOhTSEinsHZrcpdOMoOOSVu7rzRt8=;
        b=pWeaj/VFIlZib1oDoUad34l1UBr5+CnMWMG/lMsGNq9LRFczc6hiOaJYRyhumlZQyw
         BSCBzBD/w6yfndNJ/xd4xPmaONKLlUY9IrQ6wVIdSn2Dd9eG7LAwXpCaoomfk4r3JOUi
         ZfcRmU/KHQZzv2rePGrtD3jYvA9UBK/fBIwj34Rk5F90iaJ8VrFfd5jx8A1LIAL7URfw
         bH6/CqQBoceR1W4vpDaEplslO1wz6osL6MknImTFhuqfjKL78mvCtv9K1arp5M0ffqIg
         6VmGcv4Gkazu9C2gjR8bqjsrSbonWyCtOGHfbMGgfoTrs1cAf3gzS577J+fDo+Szs0re
         sTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101775; x=1790706575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NRwVfr0lfTUMkgCOhTSEinsHZrcpdOMoOOSVu7rzRt8=;
        b=1LXPEtdU5fZ//GgdPdw+BPQ+B7tQIXb4/e70jTh0T7/3NLIn5yIqdZOl3HFfKkLN9w
         c6VVhALUciOhJ86671cJoIOyhymD6eqXbUSksdf1rgl+ouuP8esxOLhQ/W8J5C29EaSy
         7uCsgB441CPnaq5FOu6MjRBbpwR+msZdOMTnFCv7x2h6/BzmgyW/dfux/wQdLPnQkzAi
         MYgg7hBrM4MiRfGkeg+c4e0MsrY4n86zakeOapKKAh8h96Dqrnxmvnn2bznntyTzqdfL
         8akCd2VRr9UitRdPz625R11OYn4jqApJBygwRk+A8HSh+EUDBWeXFeTzcZ2SU7GzpsXG
         i6qw==
X-Gm-Message-State: AFuF++kTdGjWwgzTTf2qd8KxFv6pmoFJNx9q6PKFM2trjRM9noAQ3Hnu
	uvgu/zuKlLOG0Vvi7cAw2TEcTCbf98AojLvRu6+GT6Y9XKnUDk0hWm8LRexiGEL3foyWU8uvLlh
	1uAePkCo=
X-Gm-Gg: AYBFou3CShUbnt8wK8lSOaIK3ykIcg/qtdlZZsMRxuLE0emCyJCTJPFMWva62ldY7nC
	yOJPaQ3peDJLM1EYHdbU91ON/kdC/o2/TD3iAWkW9RRwx/60rxfyT6nNfUevbXEflO5yiN/6CJg
	v+Qu8zVewPtmRbGRMyTguGypg30Esy7aWtdQeHRxUQvVgwIluMYzknVyW5LkALu3RZ+exVkCcxe
	7zsyNORpmmiTl/3yiqm0fU4VQTymsXNIMMy7vZY2FBRTKIUdsjeIPPX15PvYe4mDQ56YZmNhPlB
	hit54rrklw9KDdM5JAcW2z0bOF4nQsMu8/VAy1gJ5nM+grzzRc3V02r/CF+R6ZqOSQw1iEeeDpb
	dPA3jCSBU/weN3iwkYjbFORbi7F5rJ3PTxO8TbckOAk6hgwBhtd+uMgtfRATG/KKjjO7asx/Omz
	C+UDVHFAbiCKy8UPFrAbsMTZQHiXemn0xQZU+Z/E7bXFNRVEv+j8tBjtZgI20vLVBrFJejzvNFh
	UJqIihtPPaDpQdxVREW8H1vgo7JVD9sw5wXJcKpQ5DPUsRRHGaGz7XjfNiW8FEuxOB89QI=
X-Received: by 2002:a05:620a:8006:b0:93b:c209:b6c0 with SMTP id af79cd13be357-93c250ad128mr41734385a.5.1790101775234;
        Tue, 22 Sep 2026 11:29:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:34 -0700 (PDT)
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
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/7] mm: allow shared folios to be promoted to a fast tier
Date: Tue, 22 Sep 2026 14:29:23 -0400
Message-ID: <20260922182928.2199090-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: z1jtx33q36xhfbu4i8jgyyaww7ccdas9
X-Rspam-User: 
X-Rspamd-Queue-Id: 34227C0006
X-HE-Tag: 1790101776-605459
X-HE-Meta: U2FsdGVkX181BQa6BfpmYIqoIpVanT4DFg/jb3FwuKblecxDvp4h+ZwuqIf72LxTlYL92cLF2nw9gJikcGESv4emmCnqtThcN1inJz18ouNgsoCR6Oq4LuttxBXpwOUGE94F67x3FeR/b5O1uz/XfU0njIsizCayJqlsofwzPhiMGGRJOpClBW33WtiJFQ1OwzIHqXC4rCSpdyoThCtCUg0R451nQNsKKuuj1lFTQ0SQODpF/xNJ3pv6aq+I+VJ5M2mAGJdJL9o6ESk/v7fK30qyF5Yu/+qmGkyMKuYsHfl9RLWpJkbzr7XtW90JV3Je51B/4L21DmDw92/rq0a8ztqoMDHp1zHmVHs+JIlWd3RRxoZrHrus1UwjoKaAmhu2z7sNLXF8sMyqTF8VTG9mDH8J5YYXtUIg7W+5GGDN4fP3xbN82TfrL2OJ1kmjm+BL4muzy7g3qFiaTVfwhngkMDXeohEyb3FO303+QGKxekQYydtl8/kNy+j7ISiXMhUvVp0gRm3UbnlFDFva9cHfGe1yiawtzSwqaLSXIs3CEycIQ5heqePo2y28rxn9catG6Xz9DJVQWoZjg1WYHqGJb5dOpM2UbpCBCYWCsHZDn0MiwanE9AzUWbxg4LUB34S/QFDQwyPJA/vAJm6hhH1I0hnljpNt4dsiWJOYO+cYLGgvbnz3wTYuUbSFx4HvaYhAJ5/6NV61gdmAS1Mjnl3fYx1BKVkut2wm3LphJVudMb+bM2usc0oeFoHUo73hhkqsBtwi5sp83KN4LpuYsYh6AGwgM966DF+VA39yjUq+U5Pkh8QzAKMYLxTGZuI8DJYIaWuDqVC03g4WwFFyqOmehe9RikNWY6G/T3KWqgBVGLwiZsMNp+V4cEzoeK+9YZqY/k44gJgoIVF5p+J+oUDbcHqNclRIKgisqeZ77Nx/SHwfUfpAs/PVznooVhFt8vYro7mySgHh6LKRk/7kCOW
 moFhOldv
 X1F2q/V8g20AvRb2lYTOJGU+67Wh/7u416xQ7KZ0OXlRtIQ9kGImtTesNtQBbPHWN5mrmhHiPTimRdaVI0wnXWpDABQ+cGb5UeJnV8GxOgX8jHNw/hugdj7oRncnDjpca2ZYiH+rFr+CupnnPVerV0e3mbsd+1ovzmMWp+ierZFQCNEUMAlpnpfjXvSgi+yNjFjBR0EqgmLndc7DYHPhOwziwi1vLEgHNrCo/kdVbEBzN4hnxAWQR9cNXGsnyWKjlQKFgFm1NqvhLTGBqhOft3jzRx9LB9rJrtKmPM85oYYQfX5EQbOkN6isYs3UJRJRWSFv8wqh91dN4tnNJaEAs3ME0UmPSb4QVT2PJBbxcMaU40IHiwIw0+zJkKlMkrzzy+l9zx4oGDYf3LHJtrbIaX42rFqVm/fZporYuzaVGTUVCD2g=
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

Rename folio_use_access_time() to folio_in_lowtier() so the source-tier
condition is more obvious (timing is the mechanism, not the condition).
The helper retains its existing behavior.

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
 mm/mempolicy.c      | 12 +++++++++---
 mm/migrate.c        | 14 ++++++++++----
 6 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index beab621e6f88d..225ba26c9d503 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2671,7 +2671,7 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 	}
 }
 
-bool folio_use_access_time(struct folio *folio);
+bool folio_in_lowtier(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
@@ -2725,7 +2725,8 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 }
-static inline bool folio_use_access_time(struct folio *folio)
+
+static inline bool folio_in_lowtier(struct folio *folio)
 {
 	return false;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9f544e3df9490..dc78d24ed8bc0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2734,7 +2734,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (folio_use_access_time(folio)) {
+	if (folio_in_lowtier(folio)) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b586..082ca74d51ae9 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -53,16 +53,19 @@ static const struct bus_type memory_tier_subsys = {
 
 #ifdef CONFIG_NUMA_BALANCING
 /**
- * folio_use_access_time - check if a folio reuses cpupid for page access time
+ * folio_in_lowtier - check if a folio is in a tiering-managed lower tier
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
+bool folio_in_lowtier(struct folio *folio)
 {
 	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 	       !node_is_toptier(folio_nid(folio));
diff --git a/mm/memory.c b/mm/memory.c
index 79fa57a381ce0..f05c469e32a2a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6240,7 +6240,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (folio_use_access_time(folio))
+	if (folio_in_lowtier(folio))
 		*last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		*last_cpupid = folio_last_cpupid(folio);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 1427e1b6213b6..3c3ee28f0142f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -864,8 +864,13 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
 		return false;
 
-	/* Also skip shared copy-on-write folios */
-	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
+	/*
+	 * Shared copy-on-write folios are poor east-west placement candidates.
+	 * When tiering is enabled, folio_in_lowtier() identifies a promotable
+	 * folio on a low tier, which needs a hint fault for promotion.
+	 */
+	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
+	    !folio_in_lowtier(folio))
 		return false;
 
 	/* Folios are pinned and can't be migrated */
@@ -891,7 +896,8 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	 */
 	if (vma_is_single_threaded_private(vma) && nid == numa_node_id())
 		return false;
-	if (folio_use_access_time(folio))
+
+	if (folio_in_lowtier(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f8..6a08690cfe219 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2694,14 +2694,20 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 
 	if (folio_is_file_lru(folio)) {
 		/*
-		 * Do not migrate file folios that are mapped in multiple
-		 * processes with execute permissions as they are probably
-		 * shared libraries.
+		 * Limit east-east migration of file folios mapped in
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
+		if ((vma->vm_flags & VM_EXEC) &&
+		    folio_maybe_mapped_shared(folio) &&
+		    (!folio_in_lowtier(folio) || !node_is_toptier(node)))
 			return -EACCES;
 
 		/*
-- 
2.53.0-Meta


