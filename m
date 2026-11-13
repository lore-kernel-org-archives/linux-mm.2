Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D44606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GD8xfZZ6
Received: by kanga.kvack.org (Postfix)
	id 7B9266B05BE; Fri, 13 Nov 2026 09:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A736B05BF; Fri, 13 Nov 2026 09:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632636B05C0; Fri, 13 Nov 2026 09:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36ABB6B05BE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:18:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEDA1802F6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:18:08 +0000 (UTC)
X-FDA: 85430300256.04.D6AE11B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA26CC0011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:18:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD8xfZZ6;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmO8NUyn+tw3LA8pc83LOjgpNgEXt2U57dJm4LDr0Qs=;
	b=W0bbmxCcUiBeLYkcJcMWEzb66CNKxfheAPZYEiErZuKJXu/HM4YFhjTDE74yTnvs/sGtx+
	9OW+ikgmVXXyneLbhiI3rsoRWeiZ/hv8Cv08YqR4z0TwmXOmlk/YXf/Pcae7R1KmSRiEHl
	szLgdaVaFFv9Or8HvVYk5otIIgvHht0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD8xfZZ6;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579487;
	b=Bpn2hJpJodlHJtP/U4tUR5ZUUP6gf4qpDXqnlHsxAmIczmOBFHIXIDY2z42NroJxB0zDfo
	UpkDLFTrTyY9jObK2biNQiz1sLBx1AQLIW08Bwq/tqxMHevnwQSAPLocovkywIadlK+Ywc
	wX9Eq2A46EQ3q/V+A0n2LSFkGV5ZDuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53D2B6021D;
	Fri, 13 Nov 2026 14:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BE1F000C5;
	Fri, 13 Nov 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794579486;
	bh=wmO8NUyn+tw3LA8pc83LOjgpNgEXt2U57dJm4LDr0Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GD8xfZZ6MYl0IGuYyHhFAnauT4OtFk32JIXgpTiHI7EqSSQ7XEAno6vGt3dHVqb1W
	 AmkHxMCfcONSeeJy4uHIl3HYUXDrKmf+mTdzP4pPEW5bp84+3V7uoBaswtYY6zHw/v
	 fC7LTH/OkJAKQDWWIY8+hFLMPF2WDsjTwMkJK6RGmO+UcAZ5BHVvr8Ozi/VzZLNT+i
	 rNkdegz8FyaUaNXoBiJgTiq/KasB3nfmDfN80pDjEzWVvKkVvyxcXzEB/bLDODVinc
	 L6yJVb+jswur5EZK7gk3ox5kTWCOKW7bPxk8RTenuj7CAgA3DnVvD0O1ZcHI7eNKM2
	 nAmuiOZWWo1nA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 23A75198003A;
	Fri, 13 Nov 2026 09:17:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 13 Nov 2026 09:18:02 -0500
X-ME-Sender: <xms:Ehz3ak4aLUgJsblyMmkl8jL1KA_eXJ79yd_-l3z01R2dm_MVMyOqhg>
    <xme:Ehz3avtnK5kQmOn1gm0OocAPY0V157PKv_yjm5OhTDoLc-rX3aiwKV6GjJYDcdauL
    xvWyB781GIDN33g8z_mlsWgCt5g9FiExp3ZlEu_k-Yq-_guSocQP4wb>
X-ME-Received: <xmr:Ehz3anL-BV8TMQQ2Jj8pX6zmttV-3Xr3je6Rm63xmG3uP0bd6oecY5I8dl4>
X-ME-Proxy-Cause: dmFkZTEzMCqVlLYFNyqlxeWBK3QY4hUxX3AkiisQ6Wsz8rpHRtq4ZcMku0cF0La3OlvjnX
    /xfBuVvDa3RHdhPiwhvWLpjLqrjGEGADEqiOHV9/JXSwTz8JdIOh/PEHYmMrRbqOyF2B/s
    5wTS+jpXngPrQ7qt+MCEkT8tOUYG65L/2UMjxT5FV9coWU6S3yGe/kRrXja/Fw4iIzf9HL
    wqHvIk5iIbUxzWZJ1djtF/fN4ey41t+TF9WgvIk/Vj5Lbla0oBToXpnmcTVMy4XJtn3mRc
    8CR2ix91u3bcsoeFp9EhIFd7g7xAw5JjSY1e5qWfOxQybGryE8O5y6QyVEMNM2DqWerEik
    /HYvMVEChadsXI1kuhw+cn+noZvDIArvO8rrybl27CPTT2g/Tp2TxV1iQbVkjEZfztr2gf
    u5PqCUtFGr//dBWYZ5+GwJFSuzuVjNqw1GpGGGwIfQbVnHTEU3e7wOAr4MBMiZPsqsLdhU
    WQTSCyvBE3aUamUav3yX7wDqK32rtzmJOtXH9ci1O91APr1HcwtJTBaQ7wOp/8rl4afBZt
    rjHcExMGuudSGnR3Qflkg2k4sfH/Ici0rFMsifOVe47kiQzvkbIJOc8Ufu5Bndys3rjsB3
    zcij66R3Mj2tZNL+JtX4Pbw64q+UFyW8/eSkIkJINPnxWOc0o+sVZvUCCxjw
X-ME-Proxy: <xmx:Ehz3akHOxfGBIrZOunaR87PIFpLQKJCZAcw2hs1m11noV-eDVPHp6w>
    <xmx:Ehz3akEHe9q8TFlCeUYlVctbdAgYsjvACB7Q71vFSDTazzoUyfH87w>
    <xmx:Ehz3alrWo29Qx76A4G4gj1VMGxUQWDc8AXf63QctGjgB2uO65Dl1Ug>
    <xmx:Ehz3akTEMc0ENh-z2qabklkhHalU22ue1-3bisXZJ3m9O6NaVKa24w>
    <xmx:Ehz3ajPThdxc6lLPh7A7RBToKsfvEBY7-I6iuiWa1pSjlWT1vJLSMIQi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 09:17:53 -0500 (EST)
Date: Fri, 13 Nov 2026 14:17:52 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
Message-ID: <avcbg96XgusgAlfS@thinkstation>
References: <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
 <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
 <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
 <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
 <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
 <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
 <avWv-0LafPyo90ln@thinkstation>
 <fa90c536-3b3a-417e-a09f-011a12e73048@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa90c536-3b3a-417e-a09f-011a12e73048@kernel.org>
X-Stat-Signature: nbt569wfemx1eg3fnhjcut5xy7bwq3yx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DA26CC0011
X-HE-Tag: 1794579486-457398
X-HE-Meta: U2FsdGVkX18UjvnhRr0gk5S8TvV2iQEZIeVvLn7OLA9JHec/p6cw+/anedUvAwfywVMdiUDXWTrHR6U8j5xj/skdKqz6xbdRhB67/cNITzcMnHoQ4aLH+p8b6nCY7lf1XUqVXaNo0VnvZH8JbtDJJiMWL7/NKMrc5pG0kHN8oBfSOxeN5xUqxCs40WsEP183rbiALWkxHKWQmRC1x715ru7zZDbddeam91lAn4xI86UM3XBdJ31nUhz/jJemVugH77MKPb3WlLz/y9+z3Hr5r8atcWURIubpa2tWkJQDUSafR3ZeWreW7bEVxN7zj/7AKdMWaK6UDQ9tmZB/ntTThXf6ZI8LLpFlr4WP3Y75WUJMjnvPu/q1dphNWWb9wdQr6EpzjJ4l0lSuxf6TZltdL/Y54Ma6swfjJOQYLCcHjZgG5NM9O1EMj8eZnTEszcykvpVuG+ODT7x01ElV9A9gvJ/R1gFysbt/+88TaA5oeO0jsNEZmnmru5XEmj76ezpD68N+t1fNg2fhwgx71Qd9bAiVgpa4o2lbCsi3WGrConmjiNIaQEMNzbWIcdCzqiM6FSjP7E2OrpRTt9lXPyYk4p1K7qNpS4Kk17ELQ4KvpVkFenNySJFunprBrG5bvah/aJ61a9AdsuvoiHNWPjEeY65XR+6jC14nEL9KsJRBCs6UWvgzSsIS3MA40fJqOU6TVdhZKIzGF8llHp8MgAi7y3W+0KtJwxK3DviRSc6kGnaVgRVmE0/AcKuZKmD1EBXAteuUnXevhROuxRJu5XoLH5gL7rdytXkQpkxUOWb+9kH5C28CxKNEi1Zb0AkR36or4JvcggPOkiH1T5LQJO/y1RCWD5MIdPk10hbYxIv7EE88E/Aa+mdl653wm9yV3quXng+s0C7tf+0cBnyyReOUSdD1YbVLSBZhvfb9joKgxcf1BWLqcJl3mt7vfuqx6zj1tN532mBDjMYuHLhJbHd
 4X8Q4RVj
 mGo0n+YE+d4bXwqFC2IUabpjH8N/YkE71VktGePPG/3PVwej+jjnd0qjodpHHQWO5V5xc5ZTU5guqyuyzTCO4PPM6PijA8INhyp7JBliBBFEw9V+CFODdTaajXtVM/eu3ppLtLNx1giuT+/a57af/BAeMsn890oR/Oqpt2UQ3o8f9MJb3d6XiIR7qO+Q4D8OlFowHXO6U/S+cys70Dvyz856+ne3DOZm63Vo679y5VUVAxTaA6bPZNtiPz4ssIgs8dWyQuD3Ab0Ro2urKpyTN76MXUrL9oK2/p7QmEB1NJQVfFNg82PY5G/ejVii2Jre1k1rBGwXnEi4d0jBsjJnw0jo5kQQIJdc8Kcddt7sovo86y00tB3pEnsMefSCu54i6uRo5yZS9WNojRDLOJpStxIl+pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:32:02PM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 13:26, Kiryl Shutsemau wrote:
> > On Wed, Nov 11, 2026 at 11:03:38AM +0100, David Hildenbrand (Arm) wrote:
> >> So I might be completely off, but what I imagine is that the memdescs will get
> >> RCU-freed (these are not pages), and once they are then getting freed, they will
> >> probably take the physical page with them.
> >>
> >> And freeing memdescs through RCU will likely be memdesc specific.
> >>
> >> I really don't know, Willy might know more about these plans.
> > 
> > Right: once the folio is allocated separately, the lockless read
> > dereferences it too, so it has to wait for the grace period along with
> > its pages.  The per-CPU batching and the waits in the allocator later
> > in the series do not depend on where the check sits.
> > 
> > Until then the folio is the struct page, and __free_pages_prepare() is
> > the one place every page cache folio passes, so v3 keeps the check
> > there. 
> 
> If we go that way, don't make it effectively folio-centric in the
> implementation. That's what triggered my response in the first place.

Is something like this what you mean?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d3862d68a8d9..5b9ac91d25ae 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1314,7 +1314,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 /*
  * Each CPU has at most one grace period in flight (@queued), covering
- * @batch.  Folios freed meanwhile wait on @pending for the next one.
+ * @batch.  Pages freed meanwhile wait on @pending for the next one.
  */
 struct rcu_free_pcpu {
 	spinlock_t lock;
@@ -1354,28 +1354,26 @@ static void rcu_free_take(struct rcu_free_pcpu *r, struct list_head *list)
 
 static unsigned long rcu_free_pages(struct list_head *list, bool direct)
 {
-	struct folio_batch fbatch;
-	struct folio *folio, *next;
+	struct page *page, *next;
 	unsigned long nr = 0;
 
-	folio_batch_init(&fbatch);
-	list_for_each_entry_safe(folio, next, list, lru) {
-		nr += folio_nr_pages(folio);
-		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
-				    -folio_nr_pages(folio));
+	list_for_each_entry_safe(page, next, list, lru) {
+		unsigned int order = page_private(page);
+
+		set_page_private(page, 0);
+		nr += 1 << order;
+		mod_zone_page_state(page_zone(page), NR_FREE_RCU_PAGES,
+				    -(1 << order));
 		/* Atomic: memory_failure() may set PG_hwpoison meanwhile */
-		folio_clear_rcu_free(folio);
+		folio_clear_rcu_free(page_folio(page));
 		if (direct) {
-			__free_pages_ok(&folio->page, folio_order(folio),
-					FPI_NONE);
+			__free_pages_ok(page, order, FPI_NONE);
 			cond_resched();
-		} else if (!folio_batch_add(&fbatch, folio)) {
-			free_unref_folios(&fbatch);
+		} else {
+			free_frozen_pages(page, order);
 			cond_resched_tasks_rcu_qs();
 		}
 	}
-	if (folio_batch_count(&fbatch))
-		free_unref_folios(&fbatch);
 	return nr;
 }
 
@@ -1421,17 +1419,20 @@ static void rcu_free_expedite_workfn(struct work_struct *work)
 		count_vm_event(PGFREE_RCU_EXPEDITE);
 }
 
-static void rcu_free_defer(struct folio *folio)
+static void rcu_free_defer(struct page *page, unsigned int order)
 {
 	struct rcu_free_pcpu *r = raw_cpu_ptr(&rcu_free_pcpu);
-	struct zone *zone = folio_zone(folio);
+	struct zone *zone = page_zone(page);
 	unsigned long free, waiting;
 	unsigned long flags;
 
+	/* For rcu_free_pages(): not every high-order page is compound */
+	set_page_private(page, order);
+
 	spin_lock_irqsave(&r->lock, flags);
-	__mod_zone_page_state(zone, NR_FREE_RCU_PAGES, folio_nr_pages(folio));
-	list_add_tail(&folio->lru, &r->pending);
-	r->nr_pending += folio_nr_pages(folio);
+	__mod_zone_page_state(zone, NR_FREE_RCU_PAGES, 1 << order);
+	list_add_tail(&page->lru, &r->pending);
+	r->nr_pending += 1 << order;
 	rcu_free_start(r);
 	spin_unlock_irqrestore(&r->lock, flags);
 
@@ -1452,7 +1453,7 @@ static void rcu_free_defer(struct folio *folio)
 }
 
 /*
- * Free every waiting folio now, straight to the buddy lists, where the
+ * Free every waiting page now, straight to the buddy lists, where the
  * callers look for the pages next.  A concurrent drain holds the lock
  * until it has freed what it took.
  */
@@ -1528,7 +1529,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 	    !(PageHWPoison(page) && !order)) {
 		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
 		count_vm_events(PGFREE_RCU, 1 << order);
-		rcu_free_defer(folio);
+		rcu_free_defer(page, order);
 		return false;
 	}
 
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

