Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E971D609A55F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=osf7yqoJ
Received: by kanga.kvack.org (Postfix)
	id D95C26B02C2; Mon, 19 Oct 2026 11:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D976B02C3; Mon, 19 Oct 2026 11:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FB96B02C4; Mon, 19 Oct 2026 11:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2AF6B02C2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED82C1406F1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:01 +0000 (UTC)
X-FDA: 85339811802.04.E0E8D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07501A0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osf7yqoJ;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425000;
	b=hGslKx33nmxfg0hDKbnw/zKdcoqY5AIYuN/GI/lY3rglqLu74rUUGTcR8jci8Osu9/wp5y
	Q5FKu6sbFu8GdHrB1e3n1FDD/2sDJkBos8mQQsB1AqnaJ3Bf/aUbkLP24I1MuSmwkz7gfZ
	ZNTblZCuJVtrPWUwhK+5VYWX8snAxSk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osf7yqoJ;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aT5uOJVtAeeBUAkpAajdbtjwvX4raqbOzSyMQgzblSU=;
	b=u3gkS72foR8lhwbvsSaRpXymA52BUh6UBGD4bkpzSFFImgDm9EVu5DkDiGniVtbKkzUDrM
	9Zep+oap3tz9T5Jx1Q9/mQDIY3326ArlD13u8QDeTYBQwEmAhOWMlsNkSMD32vWGM32YPt
	hpBWvSGY05O1FooUNC9YXukz0uGK214=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F2D560D8B;
	Mon, 19 Oct 2026 15:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C327D1F000CB;
	Mon, 19 Oct 2026 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424999;
	bh=aT5uOJVtAeeBUAkpAajdbtjwvX4raqbOzSyMQgzblSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osf7yqoJhKlrME8EhhoSbtGjAm6gNPmqKAsmvl2kCGjexpFvrN8nHScNaqxrShnWs
	 rx3pQs0xuoOLnh5Bk7/rgrzAPYwYcJHMP1X7+DeOs9eDwQREbuS0pw/fa/evwvP96u
	 I4uQ+MN+FcvOcyvZzvvcViGnKdfaP0JIXI+oDtH3AlwWeTC+UfsZhCFWQrG43VzuRm
	 DSy6SAGU8+HHl3aJR+g44pVkVL8BDXWnqJhIShLBw6WNeI/pqXGajX7YlMQI0UWzBG
	 YIGRzvOZ2TvtVAqi57Thvnc/H7wchLUka9mybYRKPQD1tEWoLbL4MjqJHa7ba2azba
	 Q9/+FUsq0JeFA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 620B51980047;
	Mon, 19 Oct 2026 11:49:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 19 Oct 2026 11:49:54 -0400
X-ME-Sender: <xms:HTzWamok5UWFR8ANGfxdeoFbD9Ximmd0pQOUMN_r9x8pvYyoHLYpIw>
    <xme:HTzWap7Q3NW-2VZqpYyj-229kkB_zabELmWEIrmlDtGbYAryTHIwgTJqNqQ2ZaDbW
    NQu-3P5QT4eYwM1FniJmOwkPHYO-uQXdRbznDnZL1Zk8Z0oc7B7dx4d>
X-ME-Received: <xmr:HTzWat0WZ-ym_d0AkN5_hfvYG0Q9Foyga1fm-cfgFLnNnpJqVKrFEYUcpxg>
X-ME-Proxy-Cause: dmFkZTESqR4vElUNfwe4Wb1kabMg9MdYUtHyNIvlHi5jfGRsEd0tjiYfzpqh5FemuLlMuA
    +QzWL/iolJzzDzQk8vzuoT2/u2xyL/YZG/CihU2eaSQe3uAw7YKu/Z/hQfgMIJpEQrBQkK
    hH3KJVpCmjg+gNXnnOIkdBMKpJa1pvTLqzuojrt68Uovke10kpOzVhZrNEf3d58NDgoR+6
    GBwzdAiHoLFFDGJo3/r+XBHeUTBbw+IeFaYdgC0j5JEQlKAOMB5I7tBUfVMuw5hMfUnXf2
    vE1DwOk7N/x2FbtU++Y3QX/1ODQhD5sTVGp3EMvK4jUTItTZrn4RBPsK+PhnbeHfl8JcRn
    8N9/3E1xHLQzkStTAM1kYcniVBbKweqHzIBqUZ0NEcBBHDz6IupfY1aF3rRGHQ7LEKorpQ
    gVm1/ZBoA9VHbQ2f0U4WL3yW8ieJn87dOng4oTtEeVM77LlnanTJPqYvdg7zkq63FOQgKl
    3kot45HjaQuhK8dJORgnME5BEO93itG6PuiaOezy3CdEINnT/QZfplvecCCoMpOpirmntr
    okr8m3b9OCWqKNQ40j0/FGLxSIYnrEYpesykRn74vh+bLDj7UqIqVtDJTDUCObB8Dmfwl9
    3IkUZlxtEaJ6iiXBMcXuT4X8iGRYOeLYeWrgJmoHU/RRiZrC5LOhzjWwUwYQ
X-ME-Proxy: <xmx:HTzWallm8sG8Aup5VZsl5PzNa3cpKK_EC_wAItU7rJav44IhcfYKfw>
    <xmx:HTzWamgYTpnBo_nKl0qojFyfNN3YF6V9kwBxTCSAWrqrrzIwOtQA3g>
    <xmx:HTzWas3mZmVCAWowCp3n3NhDyKfzK8Ci8PWV01R2-pMks0q4jOrz7A>
    <xmx:HTzWajatqHLVXJjoVLB9hIZgmfusCt-Y06NkaWv29lW15FACmNkb6w>
    <xmx:HTzWapmJE6JyTcysaC0rWG8eI7DRl6oGhQTupYC9K73Q5SDPdWJ5qSeS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:49 -0400 (EDT)
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
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
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
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 05/18] mm: expedite the grace period when a CPU has many deferred frees
Date: Mon, 19 Oct 2026 16:48:58 +0100
Message-ID: <20261019154913.1765974-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 07501A0003
X-Stat-Signature: p7f71a9ycnkzwzm6w8pe7ccei5sjm91g
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792424999-404191
X-HE-Meta: U2FsdGVkX18VB9GTKKtRb1dC0vJSibQDDf+fbVkbkcUjT7fV80pemBubp3ZaNqWz2iK/S/vWVeROUCv3gKXiytgjKB1z+l5wTrPZcq3C9/VpBxkTT4FRGi7NrUH2uJs1CEScMJBfp1cwpmg5JdUIYwNgMrKTFHBDkg6yLfwa1t31Akl8rCPSyXgtOPuPhMAq0SWOcV3kQrdhEF/0UzZmjbe7kEFuQXlOmNB30tAatulpBD9U8FoyO6weLZ7eCSPc2PdzvAM7gmafpUFev82KANxgK1E+SDUs8jtzOOZpqMo2vJJcJD5ALYXqHzt20WpQDTiUiVskMg03zjKm6kYg/9oJANau4tRNAFQNlMn3PnRNexFJIvHNclj5GM0dU9AdqYL8ZOydet7NUp0THrWuoi+E3DGcozTGmZBPebR2TY8Xqq2PXbvON3MTZYtzGxsy6v2MPYOaDrbutauTU3/F/pt/s/BiPlujwjxsxAf7aoHXg3Xotcn4Qcymr48A0MPqN/HFK+75KTDvb2/aW0R4oX2hedPrBU0WPQnlDPGj7dPUjOfe1SP9aIVxIvA+8qxBVl7Awodehep/XKAcUU36j0jM3+Hj94kiCEJsoDIt5b9Cl3NedpNnHdHn+jrvd4xW6Khe0AqnND/1RBoABXML+nmHb6ZfKWr8+t5KX8zoc8tyjN5T5yiUf6L3GXGeQsPct1cAofSqkMm2NFFZ9AT8KiSq4AT7XFleLVYhQ2kSAgJ61DtngT6C8jKuwmHIk2tNXZKwvfD6f4hqRfed26ZBqTwiVna5sxZ6gRBQevBNNgwD/1c/tAZVqLmTsf/9pdlR8DLLtwQZlS6hZNWkUPhbbkuwY/bo2pqX0arBRS0K/qDRP8ojqUvzRxRu9sRlTkfOCu1NLD+ikaBHVKllo67KGyP5pfvmPdvZ67i8lvUY+GYJyFQ5p9exf28hiU0vs+2WyPd1Eup6gD9cAcAtm7G
 f5gePDQe
 kIDebAuHEBKqiEvMdVAVo/NKR0uNrJJf2dNgnprawbpA5ccVz6ytjjFCVjxi42wWVZJ9+CW3okoXxrT5lFf4E5mexy3sz2U8mjywTYDclcN8i8ZePCgOuuuPyLtyJRQ2rUd6hQIm/jIarzXFP+Xpm1jgsSqyWj7EaROcEM9tqhA5E3avabHIez75Gb2eCkGvgorEdemMFMFGz58HnyHlf4KFNmdi8TwJuJpOy5VA+YZ39pvZtNLTX13giTW7Czo3zJwhLody5t+XyFik//4f014EWZfgSRJwWV6ymIelIqCqbdc5IH0abo1BUq+aZxje/m2IpHyb5lDJ6t54rpnKeoll6DYB5lmQ+HShDF4Y/KUGty0M5n0iOx7EDhOCgveeiUwuKO+3eWPYJUJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

A deferred folio waits one to two grace periods on its CPU's list, where
the page allocator cannot use it.  A CPU that frees many flagged folios
at once, for example when a file is truncated, can hold a lot of memory
there.

When more than 4 MiB is pending on a CPU, a work takes both of the CPU's
lists and frees them after an expedited grace period.  That grace period
starts after the take, so it covers every reader that found one of the
folios.  The task that frees them does not wait.

An expedited grace period interrupts every CPU, so keep it for when the
memory matters.  That is when the zone is below its high watermark, or
when the pages waiting in it are more than an eighth of its free pages.
The watermark alone comes too late for a bulk free.  A truncate or
fadvise(POSIX_FADV_DONTNEED) of a hot range defers all of it while the
zone still has memory.  When the readers that refill the range then run
short, nothing is freed that would check again.

With rcu_normal, as on PREEMPT_RT, the expedited grace period is a
normal one.

pgfree_rcu_expedite in /proc/vmstat counts the expedite runs that freed
something.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: take both lists, expedite only when the memory matters, rewrote
 the changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/vm_event_item.h |  2 +-
 mm/page_alloc.c               | 61 ++++++++++++++++++++++++++++++++++-
 mm/vmstat.c                   |  1 +
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index cbe849701653..45527fa7d0c1 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -36,7 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(ALLOCSTALL)
 		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
-		PGFREE_RCU,
+		PGFREE_RCU, PGFREE_RCU_EXPEDITE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREUSE,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 15bb66e36304..a9058d414f92 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1313,6 +1313,8 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+#define RCU_FREE_EXPEDITE	(SZ_4M >> PAGE_SHIFT)
+
 /*
  * Each CPU has at most one grace period in flight (@queued), covering
  * @batch.  Folios freed meanwhile wait on @pending for the next one.
@@ -1322,7 +1324,9 @@ struct rcu_free_pcpu {
 	bool queued;
 	struct list_head pending;
 	struct list_head batch;
+	unsigned long nr_pending;
 	struct rcu_work rwork;
+	struct work_struct expedite;
 };
 
 static DEFINE_PER_CPU(struct rcu_free_pcpu, rcu_free_pcpu);
@@ -1337,17 +1341,29 @@ static void rcu_free_start(struct rcu_free_pcpu *r)
 		return;
 
 	list_splice_init(&r->pending, &r->batch);
+	r->nr_pending = 0;
 	r->queued = true;
 	WARN_ON_ONCE(!queue_rcu_work(rcu_free_wq, &r->rwork));
 }
 
-static void rcu_free_pages(struct list_head *list)
+static void rcu_free_take(struct rcu_free_pcpu *r, struct list_head *list)
+{
+	lockdep_assert_held(&r->lock);
+
+	list_splice_tail_init(&r->batch, list);
+	list_splice_tail_init(&r->pending, list);
+	r->nr_pending = 0;
+}
+
+static unsigned long rcu_free_pages(struct list_head *list)
 {
 	struct folio_batch fbatch;
 	struct folio *folio, *next;
+	unsigned long nr = 0;
 
 	folio_batch_init(&fbatch);
 	list_for_each_entry_safe(folio, next, list, lru) {
+		nr += folio_nr_pages(folio);
 		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
 				    -folio_nr_pages(folio));
 		if (!folio_batch_add(&fbatch, folio)) {
@@ -1357,6 +1373,17 @@ static void rcu_free_pages(struct list_head *list)
 	}
 	if (folio_batch_count(&fbatch))
 		free_unref_folios(&fbatch);
+	return nr;
+}
+
+/* Free what rcu_free_take() took: the grace period starts after that */
+static unsigned long rcu_free_flush(struct list_head *list)
+{
+	if (list_empty(list))
+		return 0;
+
+	synchronize_rcu_expedited();
+	return rcu_free_pages(list);
 }
 
 static void rcu_free_workfn(struct work_struct *work)
@@ -1374,17 +1401,48 @@ static void rcu_free_workfn(struct work_struct *work)
 	rcu_free_pages(&done);
 }
 
+static void rcu_free_expedite_workfn(struct work_struct *work)
+{
+	struct rcu_free_pcpu *r = container_of(work, struct rcu_free_pcpu,
+					       expedite);
+	LIST_HEAD(list);
+
+	spin_lock_irq(&r->lock);
+	rcu_free_take(r, &list);
+	spin_unlock_irq(&r->lock);
+
+	if (rcu_free_flush(&list))
+		count_vm_event(PGFREE_RCU_EXPEDITE);
+}
+
 static void rcu_free_defer(struct folio *folio)
 {
 	struct rcu_free_pcpu *r = raw_cpu_ptr(&rcu_free_pcpu);
 	struct zone *zone = folio_zone(folio);
+	unsigned long free, waiting;
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
 	__mod_zone_page_state(zone, NR_FREE_RCU_PAGES, folio_nr_pages(folio));
 	list_add_tail(&folio->lru, &r->pending);
+	r->nr_pending += folio_nr_pages(folio);
 	rcu_free_start(r);
 	spin_unlock_irqrestore(&r->lock, flags);
+
+	/* Unlocked: a stale count delays the expedite by one free */
+	if (data_race(r->nr_pending) <= RCU_FREE_EXPEDITE ||
+	    work_pending(&r->expedite))
+		return;
+
+	/*
+	 * An expedited grace period interrupts every CPU: only while the
+	 * zone is short of memory, or while more than an eighth of what it
+	 * has free waits here.
+	 */
+	free = zone_page_state(zone, NR_FREE_PAGES);
+	waiting = zone_page_state(zone, NR_FREE_RCU_PAGES);
+	if (free < high_wmark_pages(zone) || waiting > free / 8)
+		queue_work(rcu_free_wq, &r->expedite);
 }
 
 static void __init rcu_free_init(void)
@@ -1404,6 +1462,7 @@ static void __init rcu_free_init(void)
 		INIT_LIST_HEAD(&r->pending);
 		INIT_LIST_HEAD(&r->batch);
 		INIT_RCU_WORK(&r->rwork, rcu_free_workfn);
+		INIT_WORK(&r->expedite, rcu_free_expedite_workfn);
 	}
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 64068d73d6d2..aa7280b5e69c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1345,6 +1345,7 @@ const char * const vmstat_text[] = {
 	[I(PGDEACTIVATE)]			= "pgdeactivate",
 	[I(PGLAZYFREE)]				= "pglazyfree",
 	[I(PGFREE_RCU)]				= "pgfree_rcu",
+	[I(PGFREE_RCU_EXPEDITE)]		= "pgfree_rcu_expedite",
 
 	[I(PGFAULT)]				= "pgfault",
 	[I(PGMAJFAULT)]				= "pgmajfault",
-- 
2.54.0


