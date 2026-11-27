Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DC6606A329
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwP8tvtq
Received: by kanga.kvack.org (Postfix)
	id 789D26B05B7; Thu, 26 Nov 2026 21:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A3A6B05B8; Thu, 26 Nov 2026 21:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677AF6B05B9; Thu, 26 Nov 2026 21:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38DE76B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:02:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21E57A01BA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:02:33 +0000 (UTC)
X-FDA: 85479249786.10.EBF6322
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49D47160008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:02:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwP8tvtq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795744951;
	b=QwTr6MXNhObzSfJLtsnctqRXN6jHmq3/OgPf0Ez5VcSm5rL8l+q2Gk9hvRQGAauySTUW59
	9meSuidPQvvihyA8VEHAm6XNJgkest0l6Yr4GvERVtxbOm16lmrPtax9v8WS3sF9ihM2Gn
	W6U0v9eMcDSg5+9HyRx4b2CbXCLPLJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HqrvdCaoRLWQfr32Eh+EaYearFMhIXj3DWUunR1Bq4=;
	b=MpBKUQoQli+LsVPT9NWZL75+H/vS8c+GI3VHaKQm8cfBG3PocenG1Ab+OkHeiGqOLnBggj
	PMZHxWkn5ZjQTtQcIpWgpXPn90P352zerkdIWemzOT3X4ZWwZS+VNUrAWeEtNsRKaYN9MV
	GjkGTkTy7HkWwRtIs+Fy4IHuH8xp2Vc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwP8tvtq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E415612ED;
	Fri, 27 Nov 2026 02:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281741F00899;
	Fri, 27 Nov 2026 02:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795744949;
	bh=4HqrvdCaoRLWQfr32Eh+EaYearFMhIXj3DWUunR1Bq4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DwP8tvtqN9/NfnynhYi9TNTQ7JpsRb3uLgBeM7RjC9RvUdUGjAwVqZxiZzAovza84
	 PfmJlad3Eu1JV4b7jDvr2yUDFCoYWsuZ014SJvZHMmryyh8rgBlQe0nMgj0+mJX3C5
	 /4ZhtPZULIphwef5B+qmUtWgogyOIGuGFhv34/JQ=
Date: Thu, 26 Nov 2026 18:02:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH
 <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-Id: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
In-Reply-To: <f188775aea9580f9ab2b477788503434@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
	<f188775aea9580f9ab2b477788503434@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49D47160008
X-Stat-Signature: af43a5x5feho6jppzbaa6esoxduto8jw
X-Rspam-User:
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795744951-159819
X-HE-Meta: U2FsdGVkX19zG7I5TEYI3U6IV9r3QuNk67tbcyKBfTtAOFqx5JWPoLxfpd0Kt6nwUU+PrcHj7TTbmY2ObtsSA8AGACWclotf8xrkBEEvF4Z9g7igb6Pwvud5gmqrsBnAE9AZQ0K0Lg+RurVPbze9rdx1pRph0oUHGcwBrUn7SHNOLROQkwyjvA+jMDDkzAAVz/N23gDj8WSxF9luYKF8re0YcOWJCXn3dWEmehk8oUnsNq4tebreLceuaRzb/zUWsfH/wyudsFPa4l/218XNNmaQQhUTf+YG0nc84aDQlnkYGkH9v3fUwJSbfqnI/E0KlTK8TnbexED563QtK1OG2F5l2BqaCoVKhaSgHacENT23pyMPyexCT7EfqZmHIdZlQPP6wdLOORD9/Kmomln2TPYKXCWGR+CxaJrLCq8K0L9hnfvTMEzXPpSYo9C4aMsPJ0xqTpsWC1hroqUyC/SglAeZ/u656VguY5xBwxv1I92mJQ817HrfzO+qOGJdXEW5qLC7z9qqJdNoM1hajE9j0Ek+gLjffsdZV8hbZGQFYMcLwv8q2AsOmrjgVukrU69aHseT17mxvpIJtwNYZ1ECo4KNDJGLtfvXOgmz1s6B3kJ1Ur3eqF+wcK70He04PXK7O3PaGT8wR+gnD/2xzbJX5Aipgbt+iwRJi6Mk7lTE7BwlOxgD56Q9gUBj5Di5WMDfVbyJ6oRGLiC0lK4yuJ6e++8p1Kwwmp7L+S+7BIjFYkKol53CvyOeaXWp5KoRZrx+VbmTex1NHW27X8L58V0ydLPGdHaCLiIYAKalIa4o/g8KLXK/NPPUA6Vo3az3AycTa7UgiE9KUTOTavgd5zOuPy36UwUVNgAcjRYSFqxwHckWJuApasyzesbJS+VZKKSzU3HxfwRX1mVeq9N7hGYRxqS3rsBnTADeHhxjipt+lk0956JEMwTSvWhiJTHVa+WWj/hCvTRRByIq0svbsQb
 FrGWqUDw
 +NZC4P46xoUixv3BJ5fj687ZW1b7XVpwe/usFhkuGaYgPk69mWqaPlURj15KU8SBlrNSSu6HmZZucVy08ASBOvnD6VlEz57ZgpBmFJtp4qC8k+CWwSe1rXvCPxbpE0+9Bo2/rFRohH7ze541dVzVACBE3eyATgHqO6o6wrmzNHZnaY4mPS69CtAGe3IVMjViNs22169+M2CMIkgYJTyxBj070V1EELF93+EVpUuX0i3TIC/jLSiShyKii6n4xzPyqBP2TmHc6NaeDbXFD19Nfhoay+sbBmLvpES2zxN3KzJHYHAZoe3lRdDvYBcS7AX1Xd4/vdnpprSi4YEWYqwmoE/2I4S8/1GbKI0bKSXFH2tJHhV2UOmlr1jRPEa7osSgLZD9y6tulVkglfZ7BCRuRPAYaVf+4bWX7arCXFL3ZQSczi5u8Ml/o0VmJSJ0FQmmzGtnbwpyigijup82C50NafhkzJ7s+OUJmpO65WrVbOnH7KcwwzuR8f+1N0z7GN8rkzl4OQN15msLDA9OoHfPtNmTCBzSML+UsvhLeEqBKdGracm7xtqlWCk6sfHrpx0SbzLFLFr0d+no0AK4fx/2NeogjAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 02:17:38 -1000 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
> target", applies on top of this patch and tests fine here.

Cool, thanks.  I'd forgotten about that ;) It was a hastily slop-coded
"maybe you'd like to include something like this in your patch" thing.

Can people please take a look and suggest whether it should be a
standalone patch, or just fold it into this patch, "mm/vmscan: Fix
legacy memcg reclaim deadlock against filesystem freeze"?


(That's mem_cgroup's fifth bool - maybe scrunch them all into an
atomic_t and do atomic bitops on it?)

(I am told that moving wb_wait_skip to just after oom_group would avoid
increasing sizeof(mem_cgroup), but that puts wb_wait_skip into the
read-mostly section. wdyt?) 


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan: scope freeze writeback skip to the reclaim target
Date: Tue, 17 Nov 2026 14:04:43 -0800

The freeze workaround sets memcg_wb_wait_skip globally when a memcg's
writeback wait times out.  While any superblock freeze is pending, this
makes reclaimers in unrelated memcgs bypass their writeback waits and can
drive an otherwise recoverable cgroup to OOM.

Store the flag in the reclaim target memcg instead.  Use
sc->target_mem_cgroup, not the folio's memcg: reclaim against a parent
limit scans descendants.  This also keeps the skip across successive
try_to_free_mem_cgroup_pages() calls in try_charge_memcg(), each of which
creates a new scan_control.  Reclaim against a different target must first
time out on its own writeback.

Reclaimers sharing the target can still OOM early during a freeze.

Reclaimers of the same target can run concurrently, without a lock
protecting this flag.  Keep READ_ONCE() and WRITE_ONCE() for its lockless
loads and stores.  The flag does not publish any other data.  As with the
global flag, a clear racing with a new timeout may cost another 15-second
wait; the timeout path can set the flag again.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>

 include/linux/memcontrol.h |    2 +
 mm/vmscan.c                |   52 ++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/include/linux/memcontrol.h
@@ -248,6 +248,8 @@ struct mem_cgroup {
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
+	/* Legacy writeback wait timed out during a filesystem freeze. */
+	bool wb_wait_skip;
 
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
--- a/mm/vmscan.c~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/mm/vmscan.c
@@ -1171,39 +1171,49 @@ static bool may_enter_fs(struct folio *f
  *
  * Reclaim can't tell which filesystem a writeback depends on. As a crude
  * workaround, memcg_wait_writeback() times out and, if any filesystem is being
- * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
- * reclaim neither waits for nor throttles on writeback, so that the task a
- * freeze may be waiting for isn't held up in reclaim and can drop its freeze
- * protection. This can cause premature memcg OOM kills.
+ * frozen at that point, sets a skip flag on the reclaim target memcg. While
+ * it is set, reclaim against that target neither waits for nor throttles on
+ * writeback, so that the task a freeze may be waiting for isn't held up in
+ * reclaim and can drop its freeze protection. This can cause premature memcg
+ * OOM kills in that reclaim target.
  */
-static bool memcg_wb_wait_skip;
-
-/*
- * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
- * frozen and is cleared here once none is. A freeze that starts before it is
- * cleared inherits the skip.
- */
-static bool memcg_skip_wb_wait(void)
+#ifdef CONFIG_MEMCG
+/* Retain the skip across separate reclaim attempts against the same limit. */
+static bool memcg_skip_wb_wait(struct scan_control *sc)
 {
-	if (!READ_ONCE(memcg_wb_wait_skip))
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
+
+	if (!memcg || !READ_ONCE(memcg->wb_wait_skip))
 		return false;
 	if (atomic_read(&sb_nr_freezing))
 		return true;
-	WRITE_ONCE(memcg_wb_wait_skip, false);
+	WRITE_ONCE(memcg->wb_wait_skip, false);
 	return false;
 }
 
-/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
-static void memcg_wait_writeback(struct folio *folio)
+/* Wait for writeback, unless a freeze stalls this reclaim target. */
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
 {
 	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
 		if (atomic_read(&sb_nr_freezing)) {
-			WRITE_ONCE(memcg_wb_wait_skip, true);
-			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
+			WRITE_ONCE(sc->target_mem_cgroup->wb_wait_skip, true);
+			pr_warn("memcg writeback wait timed out during fs freeze; "
+				"skipping waits for reclaim target, may OOM early\n");
 			return;
 		}
 	}
 }
+#else
+static bool memcg_skip_wb_wait(struct scan_control *sc)
+{
+	return false;
+}
+
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
+{
+	folio_wait_writeback(folio);
+}
+#endif
 
 /*
  * shrink_folio_list() returns the number of reclaimed pages
@@ -1351,7 +1361,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    memcg_skip_wb_wait() ||
+			    memcg_skip_wb_wait(sc) ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
 			    (mapping &&
@@ -1377,7 +1387,7 @@ retry:
 			/* Case 3 above */
 			} else {
 				folio_unlock(folio);
-				memcg_wait_writeback(folio);
+				memcg_wait_writeback(folio, sc);
 				/* then go back and try same folio again */
 				list_add_tail(&folio->lru, folio_list);
 				continue;
@@ -2138,7 +2148,7 @@ static void handle_reclaim_writeback(uns
 		 * enough for cgroupv1 writeback throttling to work
 		 * on a large system.
 		 */
-		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
+		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait(sc))
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
_


