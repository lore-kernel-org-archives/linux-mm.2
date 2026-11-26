Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A80606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZRCpdFj
Received: by kanga.kvack.org (Postfix)
	id 14C096B05B4; Thu, 26 Nov 2026 07:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1238F6B05B5; Thu, 26 Nov 2026 07:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FF46B05B6; Thu, 26 Nov 2026 07:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D11F76B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:09:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EE6E120403
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:09:00 +0000 (UTC)
X-FDA: 85477149240.22.62EA9B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C982720006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:08:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZRCpdFj;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795694938;
	b=d3s+s4c7HvSE415woBJ9B7mcovvQKWl/LgkMGq/ISdMHKjJUFRPfyNJU1awVg97boSjWjc
	vif6cQWU/cl9Rsw/qUbAMswzla44Ib5dof59BrBPZ4YZQVANJiPkdUj3BByrDIJFJLIj6c
	0EW6s+9jG2M4Geo3S6mpD23gNA7uQvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795694938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RJ6ABZmDyn/Dl1B0+dcioahhPK/gYG42Zr7uAiRksnI=;
	b=5ZsskHvogfbEkjNDsAUd6Ux74qTqnfyWQM6Pevw06bQyELXMNtxAslK/t3XbTa5wTyv3BY
	kMy4GdthIciwtiWAe1DwveQ9B7/3IwsKsT/DzgsFgQyyhPAleIWR166tZwLXmxXHAW/mBy
	Zsk0D2CJjxd36RGv78LexxIdRlrZIzs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZRCpdFj;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533E760E4A;
	Thu, 26 Nov 2026 12:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E151F000C4;
	Thu, 26 Nov 2026 12:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694938;
	bh=RJ6ABZmDyn/Dl1B0+dcioahhPK/gYG42Zr7uAiRksnI=;
	h=Date:From:To:Cc:Subject;
	b=oZRCpdFjKa3WVZWONiR2bV3G9Y70FwuGXfrhSRv2rLb/Mruc5Z6jGKM/rmrIgsFKN
	 dgLaZ/yDUJJrPX25DteDDDxzFb7twuKux8nl2CW9Fc/4M2RthlSFz4zCL2Nbv2+IY0
	 PARsMuyP6UBeSqgz5lukDWWbfDrUyAriW2L6RI/WU56QQ4DeFwTu12mh5BO7Fg9Zhz
	 0Cxf+7HeNsT4ca2LB+dqMv6Tbw+I+bJiAVtPzMnrZyCM3tmOfeoHsRTVXAtoEoq1xo
	 LcE2mBVWgZcumD0fu4Mows+Neh3Af80rwOA/aUitItjxexOzIUNBkr8Q9aS3TWhmCs
	 a+3dhMpRRa0zw==
Date: Thu, 26 Nov 2026 02:08:56 -1000
Message-ID: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock against filesystem freeze
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C982720006
X-Rspam-User:
X-Stat-Signature: 5utj49o58uxwaf6sg7ywtxdeaudu65pf
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795694938-280822
X-HE-Meta: U2FsdGVkX180KQf6I0KmRiJN7xiB5FdIaSzBaEohpN3URQW/5H7T8y2jU0VySlLaGuT2rt/InTixM9QLsKxQGAqjSvg3p8eBetBlYhqQcp63vJDdqkDjEpJ/Vu/pOjafmquBb5/dp16vOl4GHuXpd3CJpKkCG8jo3tTTzI/ctZW9EvU482ECn+LykvUeHFgcLi+3VLAfKOlUBsnaKOiIJK+6s7Rn68DoSrX1GGgejHxJASjnC/XuQUtCG1FmhJ1UXwdVuVnQ7EQDDZvBkLysWpHi2hMLDALRljsm5SMR7pLxRCBEflJkuYivky37DNS0qjUMfcXvZjURiTO/uvStbbJ5yi/vJMglkg0cSDrivvtBLamT6LT/sr9QoSaxzyFxJWPOx70TlpvcCgKgyspvmqEApgLlrLVj0jCzV54qjM2c4TZ5dRPGdMCDpBVw3JoVjFUln0JKltywX4DaWagwsJtxDboS8f1XKhOdUsahJ4M4PI9vs/ex2OHKm4KyjMPJEUSl5rSOg965Noa1zaYDFUWM+6RAUj+Rqgop4+3iLJO9T3WbNSg6+eBki16aKhftnGUBSavdXSm3Gi/AosxIpjCm+Ve3KLK1rCravGAlInW+Pq+fMRx3jNFxCZtRYc0fCeF1GXz/FfK4S3OSyzEzp2bvKRblsL/ZmnXyCKxzgXuQdzyd1a5CruFO6BxKeh4u/JLpQQfmMla95a7G66CHwvJ730vWKQMHwfUPlwZKpBtivRUIEVo6P/kvkAei6HJQ77Xy6qQzjFWDJe5OqVj/+2E3Q4NtFhl6vT4ELZkMOBQFZqI+JLAqZNwPkhOUZoig1HwmXkoITCyJP44tCI/oU3oc0d6F55Nemb6ObAI5pPnQt0LKC8ADpZ2Egv/OPBaY8o4p+P+F92vfurIvqU3PabPs4uq004JRxMH69s8qZkPJGHYF0nLy7N/oSMEeNX3AXHb7mH8DWdF8SmvgyUr
 83ZzdKXm
 jMENLm/hWL7M2xoJz5LXlU7sdFH3DgYzZkQUzgI/L6WK6fyEk3ir+BNPi7CE0PedfjGdJY7vmNjQ26geCDlgeSBLRmhbPOSjQUZvbmtU2ETCNmSRdg9AdwC3mxq802JaavSbpuoWmOYh2jh2DP+SnAEDZpcREQd1pW+dkJ4ShAxXbd3qPfRI2ZUl4xm+Ce2sIi44f8cOabRoLWAjcB8K1yzpu68VK5j768nlfC7CRFj/SXz1fiFih5gYQuZOKzUyzcXkVrL67PfsxRQRk3RMdVaAtDyC4dxkKMirY18TczfD7vC0pJuWTH/WmCaSt442BIS7JfGdrH05j3p27LPD4t8rwigtN9IeZzA9/b7jyj36ffdnMjdkhtMubSlUg0U+7bp0pNJI/YnSbr8KLf1MmQT4dV7KPCUUIWXQwQ2h9QXilbEmpjk3YTozYOGlo3GWLe5siDyYw9oqB4U32ZM2ja75BrCYAH+CqAvZrTJNkAEthh1KG043Q9eV7gSgF4HeJN4r35kjwKzG3kwfFMoY/x9ddej8uhMZgV77ove7fl8qfgMkAsqJBoXZglyblbDevSGg3wEh2nOAc89grRCXSTLkRoOcZO+j9n4nw/69FG7c4sU9ERonWol9acIrxYNuBropO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
for a folio that is under writeback and already marked for reclaim (case 3
in its comment). That wait can deadlock against a filesystem freeze:

1. A task in write() to filesystem B holds freeze protection on B, enters
   memcg reclaim and waits for writeback of a folio of a filesystem on a
   loop device backed by a file on B.

2. A freeze of B waits for the task to drop its freeze protection.

3. The loop worker has to take freeze protection on B to write the folio out
   and blocks behind the freeze.

The same applies to any driver that writes to a file on a local filesystem
to serve block I/O and takes freeze protection for it.

Reclaim can't tell which filesystem a writeback depends on. Count the
superblocks that are being frozen and make the wait time out after 15
seconds. If one is being frozen at that point, warn and give up. Until none
is, treat such folios like case 2 and skip the legacy writeback throttle, so
that the task a freeze may be waiting for isn't held up.

This trades the deadlock for premature memcg OOM kills during such a freeze.
The wait also no longer hits the folio_wait_writeback tracepoint, and the
hung task detector no longer reports a task stuck in it for another reason
as the task wakes up every 15 seconds.

Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
This was first posted in a private thread and is resent here for the lists,
rebased onto the current mainline. The only other change is the added
Reviewed-by tags.

This is on top of v7.4-rc4-388 (25faec9ce61c). In a test with a filesystem
on a loop device backed by a file on another filesystem, writers to both in
a v1 memcg and the backing filesystem frozen and thawed in a loop, the
unpatched kernel deadlocks within seconds. With the patch, a stuck freeze
gets through in 15 to 18 seconds.

 fs/super.c               |    7 +++++
 include/linux/fs/super.h |    1 
 mm/filemap.c             |   22 +++++++++++++++--
 mm/internal.h            |    1 
 mm/vmscan.c              |   58 ++++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 83 insertions(+), 6 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -48,6 +48,9 @@ static int thaw_super_locked(struct supe
 static LIST_HEAD(super_blocks);
 static DEFINE_SPINLOCK(sb_lock);
 
+/* nr of superblocks that freeze_super() is in the middle of freezing */
+atomic_t sb_nr_freezing;
+
 static char *sb_writers_name[SB_FREEZE_LEVELS] = {
 	"sb_writers",
 	"sb_pagefaults",
@@ -2235,6 +2238,7 @@ retry:
 		return 0;
 	}
 
+	atomic_inc(&sb_nr_freezing);
 	sb->s_writers.frozen = SB_FREEZE_WRITE;
 	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
 	super_unlock_excl(sb);
@@ -2249,6 +2253,7 @@ retry:
 	ret = sync_filesystem(sb);
 	if (ret) {
 		sb->s_writers.frozen = SB_UNFROZEN;
+		atomic_dec(&sb_nr_freezing);
 		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
 		wake_up_var(&sb->s_writers.frozen);
 		deactivate_locked_super(sb);
@@ -2265,6 +2270,7 @@ retry:
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
+			atomic_dec(&sb_nr_freezing);
 			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up_var(&sb->s_writers.frozen);
 			deactivate_locked_super(sb);
@@ -2278,6 +2284,7 @@ retry:
 	WARN_ON_ONCE(freeze_inc(sb, who) > 1);
 	sb->s_writers.freeze_owner = freeze_owner;
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	atomic_dec(&sb_nr_freezing);
 	wake_up_var(&sb->s_writers.frozen);
 	lockdep_sb_freeze_release(sb);
 	super_unlock_excl(sb);
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -234,6 +234,7 @@ int freeze_super(struct super_block *sup
 		 const void *freeze_owner);
 int thaw_super(struct super_block *super, enum freeze_holder who,
 	       const void *freeze_owner);
+extern atomic_t sb_nr_freezing;
 
 int sb_init_dio_done_wq(struct super_block *sb);
 
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1245,8 +1245,8 @@ static inline bool folio_trylock_flag(st
 	return true;
 }
 
-static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
-		int state, enum behavior behavior)
+static inline int folio_wait_bit_common_timeout(struct folio *folio, int bit_nr, int state,
+		enum behavior behavior, long timeout)
 {
 	wait_queue_head_t *q = folio_waitqueue(folio);
 	int unfairness = sysctl_page_lock_unfairness;
@@ -1324,7 +1324,9 @@ repeat:
 			if (signal_pending_state(state, current))
 				break;
 
-			io_schedule();
+			timeout = io_schedule_timeout(timeout);
+			if (!timeout)
+				break;
 			continue;
 		}
 
@@ -1393,6 +1395,13 @@ repeat:
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }
 
+static inline int folio_wait_bit_common(struct folio *folio, int bit_nr, int state,
+		enum behavior behavior)
+{
+	return folio_wait_bit_common_timeout(folio, bit_nr, state, behavior,
+					     MAX_SCHEDULE_TIMEOUT);
+}
+
 #ifdef CONFIG_MIGRATION
 /**
  * softleaf_entry_wait_on_locked - Wait for a migration entry or
@@ -1490,6 +1499,13 @@ int folio_wait_bit_killable(struct folio
 }
 EXPORT_SYMBOL(folio_wait_bit_killable);
 
+/* wait up to @timeout jiffies for @bit_nr to clear, true if it cleared */
+bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout)
+{
+	return !folio_wait_bit_common_timeout(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED,
+					      timeout);
+}
+
 /**
  * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
  * @folio: The folio to wait for.
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1276,6 +1276,7 @@ struct migration_target_control {
  */
 ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			       struct folio *folio, loff_t fpos, size_t size);
+bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout);
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1157,6 +1157,55 @@ static bool may_enter_fs(struct folio *f
 }
 
 /*
+ * Legacy memcg reclaim has no dirty throttling and waits for writeback in
+ * shrink_folio_list() instead. That wait can deadlock against a filesystem
+ * freeze:
+ *
+ * 1. A task holds freeze protection on filesystem B, e.g. in write(), enters
+ *    reclaim and waits for writeback of a folio whose I/O ends up as a write to
+ *    B, e.g. through a loop device backed by a file on B.
+ *
+ * 2. A freeze of B waits for the task to drop its freeze protection.
+ *
+ * 3. The write to B waits for the freeze.
+ *
+ * Reclaim can't tell which filesystem a writeback depends on. As a crude
+ * workaround, memcg_wait_writeback() times out and, if any filesystem is being
+ * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
+ * reclaim neither waits for nor throttles on writeback, so that the task a
+ * freeze may be waiting for isn't held up in reclaim and can drop its freeze
+ * protection. This can cause premature memcg OOM kills.
+ */
+static bool memcg_wb_wait_skip;
+
+/*
+ * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
+ * frozen and is cleared here once none is. A freeze that starts before it is
+ * cleared inherits the skip.
+ */
+static bool memcg_skip_wb_wait(void)
+{
+	if (!READ_ONCE(memcg_wb_wait_skip))
+		return false;
+	if (atomic_read(&sb_nr_freezing))
+		return true;
+	WRITE_ONCE(memcg_wb_wait_skip, false);
+	return false;
+}
+
+/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
+static void memcg_wait_writeback(struct folio *folio)
+{
+	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
+		if (atomic_read(&sb_nr_freezing)) {
+			WRITE_ONCE(memcg_wb_wait_skip, true);
+			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
+			return;
+		}
+	}
+}
+
+/*
  * shrink_folio_list() returns the number of reclaimed pages
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
@@ -1277,7 +1326,9 @@ retry:
 		 *    reclaim flag set. memcg does not have any dirty folio
 		 *    throttling so we could easily OOM just because too many
 		 *    folios are in writeback and there is nothing else to
-		 *    reclaim. Wait for the writeback to complete.
+		 *    reclaim. Wait for the writeback to complete. If
+		 *    memcg_wait_writeback() gives up, such folios are treated
+		 *    as in case 2 until no filesystem is being frozen.
 		 *
 		 * In cases 1) and 2) we activate the folios to get them out of
 		 * the way while we continue scanning for clean folios on the
@@ -1300,6 +1351,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
+			    memcg_skip_wb_wait() ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
 			    (mapping &&
@@ -1325,7 +1377,7 @@ retry:
 			/* Case 3 above */
 			} else {
 				folio_unlock(folio);
-				folio_wait_writeback(folio);
+				memcg_wait_writeback(folio);
 				/* then go back and try same folio again */
 				list_add_tail(&folio->lru, folio_list);
 				continue;
@@ -2086,7 +2138,7 @@ static void handle_reclaim_writeback(uns
 		 * enough for cgroupv1 writeback throttling to work
 		 * on a large system.
 		 */
-		if (!writeback_throttling_sane(sc))
+		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 

