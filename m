Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55840CFA76A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD966B009D; Fri, 21 Nov 2025 05:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947936B009E; Fri, 21 Nov 2025 05:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837586B009F; Fri, 21 Nov 2025 05:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 629CA6B009D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:09:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 380621A04E6
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:11 +0000 (UTC)
X-FDA: 84134191302.20.DA3C7A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C2ABA0013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="o6/KeH7i";
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5k9wZm79MgkCq7NgQibQc0j/wuN48LUD2rDfYr5Xfgs=;
	b=44pQpyhVf5g2pkWSB1VPaxN6LJMT0ZaTR/LSsUPh8yKn5v834/Q1rGhaCkc52UbAnvrJN5
	gmaqS7KBq+2swDEyaaOc0kMWow/BUn8B2vzcuYi0WsOgK65F0xwmi2CZiDVW/0+t6ZAcll
	3w5ctm5UplqCeXk9TPI0RlV3s7sSYgA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="o6/KeH7i";
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719749; a=rsa-sha256;
	cv=none;
	b=VW3IG8u+RY5YWsZgiqpG3xlD8OXJXiCDwy2GBIBntBlsj/JdoVrZAIezVjc09RDZk24aLE
	2QycFtAbWJPbzn00HT4YfGSO05CVBzuSQ5p14ngnqkHQxx4ELvdhsBOUeq2iz8X/ekjOof
	OwMHtqKFlwmtX5jTQTUcciX/meU8o4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D917B60235;
	Fri, 21 Nov 2025 10:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ADCC113D0;
	Fri, 21 Nov 2025 10:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719748;
	bh=YFtxtGNp7cb+q5q6Sseypq1gS+0YRHh0xGjN/pf1TVs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=o6/KeH7igaaEWPrkTaimQFxLnK9ms/bvirnyZPAXHwNgsBEuv3BgkH7SpP5UgCuXy
	 iUTPsuLzLMPkTCWM3uO3H3PC3vbOXnqF99960vHQ/cAy3i4M62VihL9WKNTDVl60dd
	 XlLKxdl0REyH/tSaUluqbLQIGRZA+JpchPgzBNos=
Subject: Patch "mm: memcg: restore subtree stats flushing" has been added to the 6.6-stable tree
To: CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com,CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com,akpm@linux-foundation.org,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,gthelen@google.com,hannes@cmpxchg.org,iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com,ivan@cloudflare.com,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,longman@redhat.com,mhocko@kernel.org,mkoutny@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,weixugc@google.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:44 +0100
In-Reply-To: <20251103075135.20254-8-leon.huangfu@shopee.com>
Message-ID: <2025112144-deepness-sinless-4272@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C2ABA0013
X-Stat-Signature: n63hg6jz8gahm5fjzr16m5yu7fjmods1
X-Rspam-User: 
X-HE-Tag: 1763719749-740750
X-HE-Meta: U2FsdGVkX18mSqJ90Ha4V7vSTWw9kintF+I6S4v7H3nFZr9sKt/fjF6dzcKFsSEyAArjofL9lrDiXR0YnK/m2UlqykNHD4eKbyqFOyAwB2quQPhcSgARb4zYXGArp5lbHYB7IVKFjztocka5Cdf2T7kkeHA2WUG1Jdl1whv8TjIKOI92uknsJ/dIPlaDT8TSUFu4VbmGYa0+Fc9eql17NbSgsFDi2OZsD+yOiwyrWiylzU9f7Zi8WZPWRldguvGEV5dyDrtO0p0s2FYmtfpvn3x0KKjzhkDbXf0ElnVE6p+r46KevrJ8DSK52+is3/TNARbT7RfCwXjXH36sfKf9y0BQiZv7nfSjt/Oc2iTSUYxKl23ao1H2eFL26VWGOEtF7ZEahXY+Tah6aHAUijNm2ZiWskjNW8hdwSy1f2FZ4srYNiNz/0amRWWxgZl6v0qjjeDNZMyiImD4eIo+EHYVuK/E1mPD2gXe9BLuX0gjvxk5NBRRLMRg8LYG1cC/YkW7ZvbXcAgh1wfEvp9FT4kx1639O7oonBuEkHcFQnajqyKJYfXKcXCme2RDhq+r+cDK6iK7bvBfoTYGhoPKwvETsz13UMPRrPqVLF6brN7BBQ53Q8kYKaQ0+HdvT4WXSMPvfKhH6W7mhrzQrAb5I0b33kCWerQJabPp5fG1T7Ot7y7Mr53Q6M87cdJHVppEhjtLSTt5xbsbKqfxSWCHsE7iNw3OztINUi69N0rjDF/Un9Cfg6VR3m2PVoLQ3IzwSw1POzj4UWWWIT/Shv4EDBquJIZvEIJOLcEJppV4xlsVPNWz5hL/Wk5L5JYujs7bRLlfu1Ds0lkhdcb16sOF8lDOKu1Ui1KSEQi7RouX+Zmqdv+LC//ae1qk4d7JE6nHqC318DwnRhuUTUJ6Vo7QrczKlNPc6tQv8Moc38R1NviJcRrJrohoEze/WHEnJOWY26t01S2MzB3832cwII1yc7W
 GG1hTWjL
 hckoJUnFkhQqSlnS7WOPAYJ0q64ydejgaElXUe5LKFziYG5/fdiEgh7N6K5YMLXECtwoXVHzuXY/Mvzl5YzxNX2zRXQKH5vKBzOwAHFv8dZXVeqSfMBI7MMh9iFiSONnMXFD2FLiiVzO7VDMaedIdxibJDldXlOlrZybkmVzo7sWwAie5Vk20v44IGJ2eB6jLWcZCiVFeTPV1dJ90VGWhNYMQXlVhkbfvn0FlLlUxuSESQQfw7OrON2jQ5Fpfthtq4c4t0K65OoCDS9ANL7lAyDYx2QWt5ti17bPD7XrpMlra4M/ceMQl02n5U1RajyzxlB1NCNcFiCIl60km+bJa+pT+CZ4R913mJCxnf+mrrQNWv46bTtV7ObjKKPz1uaF0rynTuXQcCP2cQXQMrnFzXeZtudznQuNtNF3RxLVTD6reJeT7HyjKMZDBeEjjejsh8gYjCGSLDLgr1iAOCEogZTx+9a2mvP77PZidDJV8QRw7lwcdUMqpl/KDkgrT9U62yO+aWYCNxuNSl0fCnHvHO/5/a5O3ED1drYq2ZGo7C0um9ooxszIRl7bBBMakFyVgwihkj2Pp2Z3xbE+M34P8vZCXVtHywdg0CIYGR9HOGcBeeBPHxajb2d93z/+ttx3tgKQOuSgd6VtZJtmr7xUv6UaEvpQhGnWNniid/4ODGbVSBH27JU6VQefZpMSsBvQydPWvqHmiYxwZ9YoKlW0udgOdvnMf13Ct/KWI+xKrqnsfmVkybFrVUYRBcgfqoe+UQu6X5SiPSAo/bhsMv++drh/IjdMzLEnZnypFrB5HeePErhz2M6KMie8s88nJtUhK5DPGokhx/56/2sbcHRlq3a/RpDv4nPbA5SpmeTXm0TFhWY2YKgmjH7g086eIF1+p+bKkDklv99PJt3dPPmqwYJP5u4d0otvq0JuDqLs8DJzYsQv1iWVc2KmXemn+rkFTPomf/3QoDoJ7H/bwUfSMVZ6kUW4C
 mO1NTcGN
 w1agbrlQhaUeFjXIWi3FNydprWj+bBlfxA+IxJzBtdzqnY12ASsBjgHNqvfy+ZZdc1YOnZufp74km8wNddQyhE3zPNxzR0Y2nXy87WCPC4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: restore subtree stats flushing

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-restore-subtree-stats-flushing.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:44 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:35 +0800
Subject: mm: memcg: restore subtree stats flushing
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Greg Thelen <gthelen@google.com>, Ivan Babrou <ivan@cloudflare.com>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Wei Xu <weixugc@google.com>
Message-ID: <20251103075135.20254-8-leon.huangfu@shopee.com>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 7d7ef0a4686abe43cd76a141b340a348f45ecdf2 ]

Stats flushing for memcg currently follows the following rules:
- Always flush the entire memcg hierarchy (i.e. flush the root).
- Only one flusher is allowed at a time. If someone else tries to flush
  concurrently, they skip and return immediately.
- A periodic flusher flushes all the stats every 2 seconds.

The reason this approach is followed is because all flushes are serialized
by a global rstat spinlock.  On the memcg side, flushing is invoked from
userspace reads as well as in-kernel flushers (e.g.  reclaim, refault,
etc).  This approach aims to avoid serializing all flushers on the global
lock, which can cause a significant performance hit under high
concurrency.

This approach has the following problems:
- Occasionally a userspace read of the stats of a non-root cgroup will
  be too expensive as it has to flush the entire hierarchy [1].
- Sometimes the stats accuracy are compromised if there is an ongoing
  flush, and we skip and return before the subtree of interest is
  actually flushed, yielding stale stats (by up to 2s due to periodic
  flushing). This is more visible when reading stats from userspace,
  but can also affect in-kernel flushers.

The latter problem is particulary a concern when userspace reads stats
after an event occurs, but gets stats from before the event. Examples:
- When memory usage / pressure spikes, a userspace OOM handler may look
  at the stats of different memcgs to select a victim based on various
  heuristics (e.g. how much private memory will be freed by killing
  this). Reading stale stats from before the usage spike in this case
  may cause a wrongful OOM kill.
- A proactive reclaimer may read the stats after writing to
  memory.reclaim to measure the success of the reclaim operation. Stale
  stats from before reclaim may give a false negative.
- Reading the stats of a parent and a child memcg may be inconsistent
  (child larger than parent), if the flush doesn't happen when the
  parent is read, but happens when the child is read.

As for in-kernel flushers, they will occasionally get stale stats.  No
regressions are currently known from this, but if there are regressions,
they would be very difficult to debug and link to the source of the
problem.

This patch aims to fix these problems by restoring subtree flushing, and
removing the unified/coalesced flushing logic that skips flushing if there
is an ongoing flush.  This change would introduce a significant regression
with global stats flushing thresholds.  With per-memcg stats flushing
thresholds, this seems to perform really well.  The thresholds protect the
underlying lock from unnecessary contention.

This patch was tested in two ways to ensure the latency of flushing is
up to par, on a machine with 384 cpus:

- A synthetic test with 5000 concurrent workers in 500 cgroups doing
  allocations and reclaim, as well as 1000 readers for memory.stat
  (variation of [2]). No regressions were noticed in the total runtime.
  Note that significant regressions in this test are observed with
  global stats thresholds, but not with per-memcg thresholds.

- A synthetic stress test for concurrently reading memcg stats while
  memory allocation/freeing workers are running in the background,
  provided by Wei Xu [3]. With 250k threads reading the stats every
  100ms in 50k cgroups, 99.9% of reads take <= 50us. Less than 0.01%
  of reads take more than 1ms, and no reads take more than 100ms.

[1] https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com/
[2] https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com/

[akpm@linux-foundation.org: fix mm/zswap.c]
[yosryahmed@google.com: remove stats flushing mutex]
  Link: https://lkml.kernel.org/r/CAJD7tkZgP3m-VVPn+fF_YuvXeQYK=tZZjJHj=dzD=CcSSpp2qg@mail.gmail.com
Link: https://lkml.kernel.org/r/20231129032154.3710765-6-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    8 ++---
 mm/memcontrol.c            |   68 +++++++++++++++++++++++++--------------------
 mm/vmscan.c                |    2 -
 mm/workingset.c            |   10 ++++--
 4 files changed, 51 insertions(+), 37 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1039,8 +1039,8 @@ static inline unsigned long lruvec_page_
 	return x;
 }
 
-void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_ratelimited(void);
+void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
+void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1515,11 +1515,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline void mem_cgroup_flush_stats(void)
+static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
 
-static inline void mem_cgroup_flush_stats_ratelimited(void)
+static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 }
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -667,7 +667,6 @@ struct memcg_vmstats {
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
@@ -728,35 +727,40 @@ static inline void memcg_rstat_updated(s
 	}
 }
 
-static void do_flush_stats(void)
+static void do_flush_stats(struct mem_cgroup *memcg)
 {
-	/*
-	 * We always flush the entire tree, so concurrent flushers can just
-	 * skip. This avoids a thundering herd problem on the rstat global lock
-	 * from memcg flushers (e.g. reclaim, refault, etc).
-	 */
-	if (atomic_read(&stats_flush_ongoing) ||
-	    atomic_xchg(&stats_flush_ongoing, 1))
-		return;
-
-	WRITE_ONCE(flush_last_time, jiffies_64);
-
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	if (mem_cgroup_is_root(memcg))
+		WRITE_ONCE(flush_last_time, jiffies_64);
 
-	atomic_set(&stats_flush_ongoing, 0);
+	cgroup_rstat_flush(memcg->css.cgroup);
 }
 
-void mem_cgroup_flush_stats(void)
+/*
+ * mem_cgroup_flush_stats - flush the stats of a memory cgroup subtree
+ * @memcg: root of the subtree to flush
+ *
+ * Flushing is serialized by the underlying global rstat lock. There is also a
+ * minimum amount of work to be done even if there are no stat updates to flush.
+ * Hence, we only flush the stats if the updates delta exceeds a threshold. This
+ * avoids unnecessary work and contention on the underlying lock.
+ */
+void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	if (memcg_should_flush_stats(root_mem_cgroup))
-		do_flush_stats();
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	if (memcg_should_flush_stats(memcg))
+		do_flush_stats(memcg);
 }
 
-void mem_cgroup_flush_stats_ratelimited(void)
+void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
 	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
-		mem_cgroup_flush_stats();
+		mem_cgroup_flush_stats(memcg);
 }
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
@@ -765,7 +769,7 @@ static void flush_memcg_stats_dwork(stru
 	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
-	do_flush_stats();
+	do_flush_stats(root_mem_cgroup);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -1597,7 +1601,7 @@ static void memcg_stat_format(struct mem
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4047,7 +4051,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4122,7 +4126,7 @@ static void memcg1_stat_format(struct me
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4624,7 +4628,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6704,7 +6708,7 @@ static int memory_numa_stat_show(struct
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
@@ -7868,7 +7872,11 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 			break;
 		}
 
-		cgroup_rstat_flush(memcg->css.cgroup);
+		/*
+		 * mem_cgroup_flush_stats() ignores small changes. Use
+		 * do_flush_stats() directly to get accurate stats for charging.
+		 */
+		do_flush_stats(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
@@ -7933,8 +7941,10 @@ void obj_cgroup_uncharge_zswap(struct ob
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
-	cgroup_rstat_flush(css->cgroup);
-	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	mem_cgroup_flush_stats(memcg);
+	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2911,7 +2911,7 @@ static void prepare_scan_count(pg_data_t
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(sc->target_mem_cgroup);
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -464,8 +464,12 @@ bool workingset_test_recent(void *shadow
 
 	rcu_read_unlock();
 
-	/* Flush stats (and potentially sleep) outside the RCU read section */
-	mem_cgroup_flush_stats_ratelimited();
+	/*
+	 * Flush stats (and potentially sleep) outside the RCU read section.
+	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
+	 * still needed here?
+	 */
+	mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -676,7 +680,7 @@ static unsigned long count_shadow_nodes(
 		struct lruvec *lruvec;
 		int i;
 
-		mem_cgroup_flush_stats_ratelimited();
+		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

