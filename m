Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E1E606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9toOPFt
Received: by kanga.kvack.org (Postfix)
	id AA84C6B05B9; Wed,  4 Nov 2026 08:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A577A6B05BA; Wed,  4 Nov 2026 08:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920376B05BB; Wed,  4 Nov 2026 08:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B33A6B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE4EB140666
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:03 +0000 (UTC)
X-FDA: 85397449326.09.D0DF10F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0E7E92000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9toOPFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EupeGjRb75MNjqEgPTABdH073sRIqN74C/YN1OkBtlU=;
	b=bYKFGC2YBR8z0fhXQZNs8l9zGjIxracjD7JPDL551k7r/FdOesQcVhXa4wMTW8EeGRt2Za
	aKKim9jZh2AGphxcHWQ8dbYFXTyczb6dYbJsGB3ut72RGLbdczwpMiBdrIkA3OHyqrHdfb
	iGnzR1KthDCyDXTsh/vE5eBNkapwoPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797321;
	b=w/apgKtaXtQ7A1hyUCGcB92ok/x0wgxXQCaHcs7nKlwHY7wwjU0sx/Lskm3coTH+Rva2ft
	P2031YLWJoO9OsifpWkR/HqpaKfmPoHCo0piOCz+NwiWpV2YBY9sxJLR7xj+Pabucc+JJu
	txQt1UbDzulxGz9WpQBujOMIA/YZV7s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9toOPFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 186FE44808;
	Wed,  4 Nov 2026 13:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250721F00A1F;
	Wed,  4 Nov 2026 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797321;
	bh=EupeGjRb75MNjqEgPTABdH073sRIqN74C/YN1OkBtlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9toOPFt0y+F/Eqv4LrDBmWo3ILa6P3hEmVvm/BqsjcA9y0c5dynQXKp/VtY0Jh9o
	 /LxArk/d9oYbabXFCX141q+G54pVsXqLC5MTtQ2yh/WjhxYmhR+vIotiZVY7rtLTqy
	 KBwIvVS09ShnFFZ4f2XfxrT2NbDWaFVInyiPQ2E6ZgjWntLRGuKHo8oTbDRh2SnQlV
	 KMxyIb3f8FfsGrRV3Z5V8KygMfeRdxhhhtPnITTGtIgI0QN8kqYbQEOJSOokHM4i0p
	 sUDLw4YPH+hf2Ly4hh5LetchJuR6oFv5uu9nM4XEhAMHDk9bZsoXC+K5uzRYoyfxVi
	 SUALefRvZi49w==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 068801980054;
	Wed,  4 Nov 2026 08:01:52 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 04 Nov 2026 08:01:56 -0500
X-ME-Sender: <xms:wCzrahdthJvf1Ksum-_Trp8E6coKAxuCeB6IpomqWfxapiUoBJWE5A>
    <xme:wCzrakcwdmtbXYDC67eyln7xSJlJd-Fk6GnZ9Zndu8UCQULChDA1wcmYpHojDtVEj
    zDkvSRbLYxDo2RstfujLCvGgw0IfQc2nabXpZclfi5xPXVYeIvjZiqz>
X-ME-Received: <xmr:wCzratKncigBZZvftdPOQJ-w8MwSWip1FAn66dkUrelfm4a0NJrenzdFh7E>
X-ME-Proxy-Cause: dmFkZTFnMVB3J0HiCMx6jd1ELkzwNAjOB9sD3KKCO8Jh/oTQ2Wxy6relTg3O6gfcv7zM8M
    eTaBBuPFg+E7mcCmv32cVM60oGUW0vtD9PJs4Ggt7A8bSf27wgs/KbqZqYfysoNXSdfbJS
    uDN7pVQSluWZA8VAvimLABcpSfkA5Kk7vwjK4BTKWKiq6LQVLKTvO/5cCJzpn2MdnsR4Gs
    3XNsuUp3QPqjZDwfKGFhSVnz4zjhEFM8/KpnhFq8S5iPznJUgdAC48w2fdW3UFtgvONs2A
    P0nLgc7yVVbOklaJM9xm5GgvEFD86ZNlCansaxJabR5MXldQB057xIEdz06tdKFYngb4r6
    G+UsDQ8RoUEfwRFYCcgXZGmnO8bRlAFd9ivdJD7kH1u+35w44vSrx6fzQbENhgIMfqzwRv
    y103X+1y8Y1omQ4/orDSeUB14FYTxpaO7MgOntu+XnRFFgjr2x/sZTdSvKm1UVOWD3iL8t
    smhf/pUSJHFb359EyOyIfD4W/y/Ztlc8QQo+lbWNlEaOUp+6LtMs4AR+uOnWSGjYMES5J+
    hGh1GKH33JTIh2hknuLoxlUuXaUH/HdViIRSTheoESlSaLUu1QF1Fe0OBDGpbSz40zAgEW
    q7hj+iz0lzPjKf+48632T9H4mq/jOmhbZdaVpIlg0J5gSLat6+eEo0kF+ZBQ
X-ME-Proxy: <xmx:wCzraqo8984EblIZFpMYeQwZrKKi39ATyzYmaocEQtZVs4hHOaQA6g>
    <xmx:wCzrauUelk1k-fkToUOIfp93dI7ZcXHE8B4euseiv6qnZVvAffK-EA>
    <xmx:wCzragb4IT_qOxG1giJNnbn2Tb2wLghdAE0vUcDe5-Sp_XZRry8_og>
    <xmx:wCzrans4VIdvZ90oO7iLNkxp4hXwtjwnrHxsve1TIFYB_Vghx8FGdQ>
    <xmx:wCzravrT2ceR5eRMuUZhXtUDUoR411Qyamn9bn_W0XIBterIIsPk_Dr_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:51 -0500 (EST)
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
Cc: Miklos Szeredi <miklos@szeredi.hu>,
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
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 05/18] mm: expedite the grace period when a CPU has many deferred frees
Date: Wed,  4 Nov 2026 13:01:01 +0000
Message-ID: <20261104130118.2507513-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x4mfm5swere86tbyduddqqr6ejrjhpkn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E7E92000B
X-HE-Tag: 1793797322-732879
X-HE-Meta: U2FsdGVkX191kDXTLs0rgazeHMG3zBI8ejSERSepCDKrxOL44V4RnTpJOk4Jha0VBRtqbRYD669SHVM1Nl4Pg2EunXn6ux3lUcoJQXyXF86RYM0NQj2TfpZ09QdPCL7si1MZr/8MTaLVWBQxWqDQLdodIBMF5fl4sc4vfs5Pll2xGHVggYWjsAIuBq5rNdIha3pcUK05psJ5S8qd72m/QPQx8NtihA0gUg6h9yd3AZBpq6c/AQ8XbLMZ4mttGCPWR0rSX4WNUnHO3x8noq6oNW22HeN4kljUCcApRx9jD0CgvS039ljVdK9DNX7ye+lViT8JCPWZEgP85TKrJH0b0NirItvL6qLRO3OIwej4MqxmQHMaIR0mi+2ifgD7MgaIZCnHqYIhVlH+zRsklzcRv6aANcTH3I7VCp0Lnwik7Fa5O6IAR4AlQGcOTr1MQpltJddd30GZCt0dmcztzmyVzMOzJNAB8607+jn1r8++16oCYgCJwh+R+FhQRZHZ8svhGm7JF9qjaYtpH9wKWxuDqxatxeT9AiXb6AeWeq7T8UII7+LkAPd2Nm/DUpFMZhuNU48ccqIPtNY+srWePLXSTZFOUyyvh/6ZDlsR1iXhGQYe9ebrljaVoQ+r+Gw8KrDYaxrKIIGr3gjK+IKAlkdl9O12xS4KNrDv6lPeTwTwlLkzM7wBXDfskbyaTMlsMFL4rnQuXcEFfD5dD/19aYRGGPDj/VgdEM2CIh+L5BCKF0EXYT0O07PBQ5u6b6BmBFS+kEQVTyhe+apv7DedrYMu2HJCAuT/cgIcmiw+oVcMVGwQTlDb4bAM3WrDCO5GvPGBYfNfAVa1mDdflRJwhTx9VV2ECyBioB177r0vBXEmU+D+1z0k6lPndgN4WHdGrWVuGfqGs7CWqX2qneBNu8gkLprpmlUgQnl5G70VYAsnNwqyYvWPDIXwxRX7hF+Znlpy4n3UrKOhqsMA1gi7np/
 UtTSYeVZ
 kRMZU5SMI+kqDic1tsVmyC5hQ1/xuIs0aQ5nZYH7iF1T8fGTjT8SY0VuaYevzCcxzV9y+TTpFsqka4qvCfWQcL41mjAZz0emdEMxqZ4teI7W78LZyrbnmNC7GXa2tTT2Y++3xIampo7VD4ZwQT/iiULpdI/uhrxp9Y8bMZ8YJXOm0m8IL+xEICD1rz3492DCJIL+ypP6xRBpQobFTxfpDyHeKzWQdZInFBeNozlWQrq+mqlMyJTPZCf9o3/DObtXreGzZD4wUYjNug3Mc08Kw3TfFKH+8gOIazKQHq7xzRlhBBoNzwdc+C0Kr3va88DSgNVH/QXLzche1/nJNq36p1hMIQKkKr783jyn3ZT9AaZxIy3W9nvvKxkn4YQ/FZ9Ui/C5BzzI1rzGfASY=
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

With rcu_normal, the expedited grace period is a normal one.

pgfree_rcu_expedite in /proc/vmstat counts the expedite runs that freed
something.

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


