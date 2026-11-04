Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC0F606D802
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAVy1aq4
Received: by kanga.kvack.org (Postfix)
	id 8FA606B05BA; Wed,  4 Nov 2026 08:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA0F6B05BB; Wed,  4 Nov 2026 08:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799686B05BC; Wed,  4 Nov 2026 08:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46E096B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB3D7A073F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:09 +0000 (UTC)
X-FDA: 85397449578.30.6397CA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A697B40011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAVy1aq4;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797327;
	b=Bk3bllCWjXRG/5AobpLzPItHfC+FRx4ziW3MWpjVuwxIHPy5/A+QYwZQPFQxuV1tOc5G7M
	wAusXOD8r3ze5keuN9yXI1LFxpxommykTmf9ltyO7QZLh6pGaOJ/KqJ4Gj7f4mTbmVLgSr
	pPb5zLBNsjnGEXcUPrnuLFTASn8iV/4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAVy1aq4;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuvypyKXkvfgnjCKntl1sVjqX8ynUBMAu1VHo8H2O0w=;
	b=gcJKTry1qdYtvbgEtI80BLysgI0FdLmsmQ4zXyAVmzy2sYkOBzjlroYufKQqy6nKIvCFIz
	VftX85eJvaAoB/n79vRGwS+gQ3tdN9xZETibnmWGEBCZYC314x0pLVkQCy4Rzo3esZnNKP
	HdufmWCTuI+RJkv0z55E4Dw4mYA8AI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC3CC41B17;
	Wed,  4 Nov 2026 13:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5411F00A1B;
	Wed,  4 Nov 2026 13:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797326;
	bh=MuvypyKXkvfgnjCKntl1sVjqX8ynUBMAu1VHo8H2O0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAVy1aq4AH98+wOOlciHDprnT9XfIEl5VR2K+UJbRBAt5fm7KSCYgCX2UmT28RHQH
	 5YuOEB/BwOlx5phcGi4bzU8J20rHlmiJhLls81aA/grZtXLUngSmV7jJM2riL/PoSE
	 lGzFpdveL15BMB1Vsykwgx2Z9wfvzB18AghhOb3p8js3Pen3hgaRbriKwwb9LXIc/v
	 orauOq+PWHnOsa/51+hPmOA0drRJWh2G2NDU/jTXLy11M244NgQi6vioMwtqTUVJ0O
	 08+wViwFVcx8TXOph8mN7jllrKPKxcoLzpf9taDwUxGZ2yyEHEid82nYMVMShnCUvU
	 A0NJIaQD/01eA==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id F352D1980052;
	Wed,  4 Nov 2026 08:01:58 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 04 Nov 2026 08:02:02 -0500
X-ME-Sender: <xms:xizraiSWy-4H7AG_pZZvtZetoIAysOTr4p84v68H9_RkH8KLBjBLRw>
    <xme:xizratBYoO2xIZYxXCnerwnpK5DXMzx8dm2DRPDWz_r5Gw70w1wBwU6CjM25VB7uC
    cf4Q6I4MFIkMYWNN69XDSYhytk7sfpFbETC9wbWqX-0lspoAx-V1H3C>
X-ME-Received: <xmr:xizraicAHaFKAdsE4Ts3PPAcOABRY--oxGB0sgk-IpEypWp53QSE4aoldoA>
X-ME-Proxy-Cause: dmFkZTFnMVB3J0HiCMx6jd1ELkzwNAjOB9sD3KKCO8Jh/oTQ2Wxy6relTg3O6gfcv7zM8M
    eTaBBuPFg+E7mcCmv32cVM60oGUW0vtD9PJs4Ggt7A8bSf27wgs/KbqZqYfysoNXSdfbJS
    uDN7pVQSluWZA8VAvimLABcpSfkA5Kk7vwjK4BTKWKiq6LQVLKTvO/5cCJzpn2MdnsR4Gs
    3XNsuUp3QPqjZDwfKGFhSVnz4zjhEFM8/KpnhFq8S5iPznJUgdAC48w2fdW3UFtgvONs2A
    P0nLgc7yVVbOklaJM9xm5GgvEFD86ZNlCansaxJabR5MXldQB057xIEdz06tdKFYngb4Sa
    dcpGjR+nW9hlp0B86T8kjxGZZasLlfGmW5A4mVQF+UaAc9V1dg0DWSFsqfesESGR5MHuxu
    983K4nxENnEPRHEfU9+0z6PdjJgmHjWgsdqpvLzkpvQu1lqhuffDl3eg8GGi9ZlQozFYs9
    TvGgEsLEVdv9xvjk71bt1sgFTl61dzQd+7YvB15LtYepoUu2BM+nVnMp7TUcfZQVZxohp0
    rkmaZnWJ5tjTnG3PPIQy00/KmIZRXLGMDNh1j7EnA8GIA5vW+94UWn2jph0x18208Hsf+q
    Zn4Vtr8jRFhrbHCSkLAE4Rpc4drAamvOyFPnx2NKlzTKpZcC6lCnkNl5avqQ
X-ME-Proxy: <xmx:xizrats2N19NO023_btc3N3LmIbrclF5iuh4w6ITRb5rSrRWGBS8sQ>
    <xmx:xizrasKrx1aqRo0O0Pql-188QO4VrNuK4rIRUibs00nCZJKTfzPcFg>
    <xmx:xizrah-AhS_HjQaZE65Cg9XW2ZrFFXY44jU_ftYMki1MRajVqBZuAQ>
    <xmx:xizraiChB3NMtThVJ1-miOPHjm0A9elKB9b71-6plkMrp1cv0R4Rng>
    <xmx:xizrajugXeE8nMm6Cdz2zcRN_Zw3xFCBRlnTkOYKjKp5d1UDr34NkAPk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:57 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 06/18] mm: free the pages waiting for a grace period before OOM
Date: Wed,  4 Nov 2026 13:01:02 +0000
Message-ID: <20261104130118.2507513-7-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A697B40011
X-Stat-Signature: jjap7px89qi85qyxgmcuypsr93dbick5
X-Rspam-User: 
X-HE-Tag: 1793797327-922513
X-HE-Meta: U2FsdGVkX188rOsZXFeBkM2hGstLiIxvUK54WVDc7gY5gIELjqOcUhhpOI9lltlLKIsV3eSupOBlYAlRzFmlGoEopCX6exoJ0/E+CKXroEnywIpL0coAITSZNfuLthoYOe00Ni76FzLJK9SZLtAbwvcMXhSW1USOLvYcHxGLSy9InK9JJBHqlTUw2ISiiQKA8XuwNGOmSSxqVi9U2lU7RtYP0SQ6Uo9xuL884VoSEcP964qGIMibkc/QlHziXl7ekQMxgo6T4HnRei0FZJAurVYvKF/HvMILLkMY4Wuab1KPV/jqyPFa7oOcEwFVlrdIRGlggMi6ezjSbZjjOqbQ7GoOd9gQLERo6zpRnkDgjLcZEhvogL91fF92azaLmcSMqeXhLqVkn8gpiUSmlK/iz0SbWXgM3YmpRCueZsWyN87PWIsq/9eIpYoa/1/vKK9/4dEORlFo94AOEuVWWAWh82KV8BLtqzOB4tnQDd7TG+nylU4/+ygeLZdd/n1c6CQPTK8fQH8ey3B1WBgSupjN4tkikQBEV6UnYIcsYrXArkJv53nC4sUjvS/pqK5uHNcoavlgIOLRayNq9asEpwDvU974q++eoJRaaLOi/zfcpNStb1BHiyGOIArZnZcYY/qWpqq47fAXr807wmmugaWSDVM4WyC8i889+TTn+Jf0HrrQ4h39wYygxCB6v/MDAjXp3Y9kQBA/Mm1924BLNS5brwloULNWwq3nj+/uzPQOL5p3J1x5Nc1skbbevPNhaarZUsL1kzZctmR21Csi4DjJ3aO/qkaY/FZv3lmzjYqFbhdSCiBCAop44DpTRR0WY46wyfFvKTYEO+UzUcoD/+hNvNmUZd95TOd42i6oiAou/EFZj8A7MwDlFGbgbWf566P2jPOKrJKMIwwBhk9P6I3iOKcAmMVqrki/qUgsigKhh23QzCqCQvtp2VoS/TaptM9ZuYpclJFu49/AWlC4sKC
 L163aYAP
 OsqQAceUO9BCk+ewzTQiB23rvIVAPqMro1egb9vOD6cwKyuSFEjnQPA/cBttoz/oipNyEaceFWwWe6sI1/nVxe7BRPU6Vl5veZMjkyeA4CAQpecIlFITIxCyiEGPijgDkPIIRyNOeew02THKnX/oaik7GkulRIrmV05YsDNAg1dk875P7AF8sHFjH8Rd0u82TNbaROvEoil3+fEs63wok7zp7AkDpcTEfDkYryxVOzbYiAWApsTxKJ9vqbe029d2tYNoP/tSme1JZfwJWI3lSgScJaI3T+sz+2jhxepy0ekAQQko73bpeOFFYUsM4/b9SHo1CA+78aVDiub7UCQySH14/kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When reclaim fails, should_reclaim_retry() looks only at free and
reclaimable pages.  It can hand the allocation to the OOM killer while
enough memory is about to come back from the pages that wait for a
grace period.

Before should_reclaim_retry() gives up, free the waiting pages if they
and what reclaim can still free would bring an eligible zone above its
min watermark, and retry.  The drain frees them straight to the buddy
lists, where the retry's watermark check sees them, and waits for the
expedites already in flight.  That costs an expedited grace period,
which is cheap next to the OOM killer.  The retries are bounded per
no-progress streak, so a drain that does not help still ends in an OOM
kill.

pgfree_rcu_drain in /proc/vmstat counts the drains that freed something.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/vm_event_item.h |   2 +-
 mm/page_alloc.c               | 119 ++++++++++++++++++++++++++++++----
 mm/vmstat.c                   |   1 +
 3 files changed, 110 insertions(+), 12 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 45527fa7d0c1..7626a3e3a07a 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -36,7 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(ALLOCSTALL)
 		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
-		PGFREE_RCU, PGFREE_RCU_EXPEDITE,
+		PGFREE_RCU, PGFREE_RCU_EXPEDITE, PGFREE_RCU_DRAIN,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREUSE,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a9058d414f92..9caaa57bf51d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1355,7 +1355,7 @@ static void rcu_free_take(struct rcu_free_pcpu *r, struct list_head *list)
 	r->nr_pending = 0;
 }
 
-static unsigned long rcu_free_pages(struct list_head *list)
+static unsigned long rcu_free_pages(struct list_head *list, bool direct)
 {
 	struct folio_batch fbatch;
 	struct folio *folio, *next;
@@ -1366,7 +1366,11 @@ static unsigned long rcu_free_pages(struct list_head *list)
 		nr += folio_nr_pages(folio);
 		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
 				    -folio_nr_pages(folio));
-		if (!folio_batch_add(&fbatch, folio)) {
+		if (direct) {
+			__free_pages_ok(&folio->page, folio_order(folio),
+					FPI_NONE);
+			cond_resched();
+		} else if (!folio_batch_add(&fbatch, folio)) {
 			free_unref_folios(&fbatch);
 			cond_resched_tasks_rcu_qs();
 		}
@@ -1376,14 +1380,17 @@ static unsigned long rcu_free_pages(struct list_head *list)
 	return nr;
 }
 
-/* Free what rcu_free_take() took: the grace period starts after that */
-static unsigned long rcu_free_flush(struct list_head *list)
+/*
+ * Free what rcu_free_take() took: the grace period starts after that.
+ * @direct frees to the buddy lists instead of this CPU's pcp lists.
+ */
+static unsigned long rcu_free_flush(struct list_head *list, bool direct)
 {
 	if (list_empty(list))
 		return 0;
 
 	synchronize_rcu_expedited();
-	return rcu_free_pages(list);
+	return rcu_free_pages(list, direct);
 }
 
 static void rcu_free_workfn(struct work_struct *work)
@@ -1398,7 +1405,7 @@ static void rcu_free_workfn(struct work_struct *work)
 	rcu_free_start(r);
 	spin_unlock_irq(&r->lock);
 
-	rcu_free_pages(&done);
+	rcu_free_pages(&done, false);
 }
 
 static void rcu_free_expedite_workfn(struct work_struct *work)
@@ -1411,7 +1418,7 @@ static void rcu_free_expedite_workfn(struct work_struct *work)
 	rcu_free_take(r, &list);
 	spin_unlock_irq(&r->lock);
 
-	if (rcu_free_flush(&list))
+	if (rcu_free_flush(&list, false))
 		count_vm_event(PGFREE_RCU_EXPEDITE);
 }
 
@@ -1445,6 +1452,33 @@ static void rcu_free_defer(struct folio *folio)
 		queue_work(rcu_free_wq, &r->expedite);
 }
 
+/*
+ * Free what every CPU's lists hold, straight to the buddy lists: the
+ * callers want to allocate the pages next.  A concurrent drain holds the
+ * lock until it has freed what it took.
+ */
+static void rcu_free_drain(void)
+{
+	static DEFINE_MUTEX(lock);
+	LIST_HEAD(list);
+	int cpu;
+
+	mutex_lock(&lock);
+	for_each_possible_cpu(cpu) {
+		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
+
+		spin_lock_irq(&r->lock);
+		rcu_free_take(r, &list);
+		spin_unlock_irq(&r->lock);
+	}
+	if (rcu_free_flush(&list, true))
+		count_vm_event(PGFREE_RCU_DRAIN);
+	/* An expedite in flight holds pages it took off the lists */
+	for_each_possible_cpu(cpu)
+		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->expedite);
+	mutex_unlock(&lock);
+}
+
 static void __init rcu_free_init(void)
 {
 	int cpu;
@@ -4792,6 +4826,58 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 	return !!__gfp_pfmemalloc_flags(gfp_mask);
 }
 
+/*
+ * Reclaim is about to give up: if the pages waiting for a grace period,
+ * with what reclaim can still free, would bring an eligible zone above its
+ * min watermark, free them and retry.  Not for a dying task, which frees
+ * memory by exiting.
+ */
+static bool rcu_free_wait(gfp_t gfp_mask, unsigned int order,
+			  struct alloc_context *ac, int alloc_flags,
+			  int *rcu_free_waits)
+{
+	struct zone *zone;
+	struct zoneref *z;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return false;
+	if (tsk_is_oom_victim(current) || fatal_signal_pending(current))
+		return false;
+	if (*rcu_free_waits >= MAX_RECLAIM_RETRIES ||
+	    order > PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+				ac->highest_zoneidx, ac->nodemask) {
+		unsigned long waiting, available;
+
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+
+		waiting = zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
+		if (!waiting)
+			continue;
+
+		available = waiting + zone_reclaimable_pages(zone) +
+			    zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		/*
+		 * Count pages only: for order > 0 __zone_watermark_ok() also
+		 * wants a free block of that order, and the waiting pages are
+		 * not free yet.
+		 */
+		if (__zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+					ac->highest_zoneidx, alloc_flags,
+					available)) {
+			(*rcu_free_waits)++;
+			rcu_free_drain();
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
@@ -4805,7 +4891,8 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, int *no_progress_loops)
+		     bool did_some_progress, int *no_progress_loops,
+		     int *rcu_free_waits)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -4816,10 +4903,12 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	 * their order will become available due to high fragmentation so
 	 * always increment the no progress counter for them
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) {
 		*no_progress_loops = 0;
-	else
+		*rcu_free_waits = 0;
+	} else {
 		(*no_progress_loops)++;
+	}
 
 	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
 		goto out;
@@ -4872,6 +4961,10 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	else
 		cond_resched();
 out:
+	if (!ret && rcu_free_wait(gfp_mask, order, ac, alloc_flags,
+				  rcu_free_waits))
+		return true;
+
 	/* Before OOM, exhaust highatomic_reserve */
 	if (!ret)
 		return unreserve_highatomic_pageblock(ac, true);
@@ -4961,6 +5054,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	enum compact_result compact_result;
 	int compaction_retries;
 	int no_progress_loops;
+	int rcu_free_waits;
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
@@ -4985,6 +5079,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
+	rcu_free_waits = 0;
 	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
@@ -5163,7 +5258,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto restart;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, &no_progress_loops))
+				 did_some_progress > 0, &no_progress_loops,
+				 &rcu_free_waits))
 		goto retry;
 
 	/*
@@ -5206,6 +5302,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* Retry as long as the OOM killer is making progress */
 	if (did_some_progress) {
 		no_progress_loops = 0;
+		rcu_free_waits = 0;
 		goto retry;
 	}
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index aa7280b5e69c..d994de1fd739 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1346,6 +1346,7 @@ const char * const vmstat_text[] = {
 	[I(PGLAZYFREE)]				= "pglazyfree",
 	[I(PGFREE_RCU)]				= "pgfree_rcu",
 	[I(PGFREE_RCU_EXPEDITE)]		= "pgfree_rcu_expedite",
+	[I(PGFREE_RCU_DRAIN)]			= "pgfree_rcu_drain",
 
 	[I(PGFAULT)]				= "pgfault",
 	[I(PGMAJFAULT)]				= "pgmajfault",
-- 
2.54.0


