Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A18CFA76A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCD96B0096; Fri, 21 Nov 2025 05:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C9B6B0098; Fri, 21 Nov 2025 05:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BCC6B0099; Fri, 21 Nov 2025 05:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A74F26B0096
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:09:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72EA81300EA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:02 +0000 (UTC)
X-FDA: 84134190924.17.2AE3A6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B545C12000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=m+HFjavS;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719740; a=rsa-sha256;
	cv=none;
	b=elKuuaIvyDLgdjqA/CkV92IZqHH+Kl8KuOuIWjDOboXvjwA7Fp5YYlbt6mJyPUe2pTP4C+
	bhylIqJPDrSuLPgYwoo0e4GUG2NNWPZrHndYLN9lCuveAHZ/N7boPP9AOWOyWl7jFmAja9
	Q7lTv1g+FriTyyN28ueTT67SaYBe1Dg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=m+HFjavS;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=uyEfYg8olS641I34AUOB7lbf9n/cBgeFnheeT/mfWp4=;
	b=VAy23wAoGYXGMQG1VkKbWgD/Y0nl3YEC2J0/jOcCbgxUM2BfbK0Qa4+wIDkhXmzl6ahSo9
	/P+gPr6uliyG2Qyq1z51lN6V4LqBmBzgmUMfkHaK9Z7wzileBEDfdb4ayAdTz4Tw+aeogu
	NH2VVUIOUunIF+eSaZ7MqEGpYZMQrds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8A8643E11;
	Fri, 21 Nov 2025 10:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ABFC4CEF1;
	Fri, 21 Nov 2025 10:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719739;
	bh=juORx77pm+6NURK994E6fiedVBvBZdhszpgl/u4qUvU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=m+HFjavShpjdDnCW/3BWK2pgWqi3hVCkMgM+Q/r2r/fimd6xc5vypdSNvUw7+LJ8s
	 NtTTNrggnWCJ/txM+wYpfk5QBPeehO7VkiQ4PEMmvkVZxw7BuC85x2CSZf7TTgdGB5
	 Q/u+ly/kIPrV691WOlgDYPH4eE85nHk0SB5oPZoY=
Subject: Patch "mm: memcg: make stats flushing threshold per-memcg" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gthelen@google.com,hannes@cmpxchg.org,ivan@cloudflare.com,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,longman@redhat.com,mhocko@kernel.org,mkoutny@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,weixugc@google.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:43 +0100
In-Reply-To: <20251103075135.20254-6-leon.huangfu@shopee.com>
Message-ID: <2025112143-cattail-revivable-3c5d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: B545C12000B
X-Rspamd-Server: rspam07
X-Stat-Signature: nccoeucg5hekkoogeifzfqwkzwjo5r79
X-Rspam-User: 
X-HE-Tag: 1763719740-604800
X-HE-Meta: U2FsdGVkX19UnXtpRB+g5KCMBqNwOD9DKjhxF71L4riwD5LvvkSWYEPP8XGgkMMbw08lZBQ72epQATrMSpnYhQIyad71qE+mEC0ML2YwA/pQ3ZKQHKrIcOu+M8ZNqwWp72knoevHLcjxhSwI2oLERGcqnP0rTZI12wdjJGws62MkyiVRFHoaHL+ob7OSOLdkxqCtJ8EnK1M5mjQGXw1C7BkUhJmtt4xjSiA0lvB1p60KDCCxeVijP9Ji/0QPmTJbti1m9StHm/5fcCsxEZEbif4h7hKXLMTtyrEry4p/u+N+e3ndf7RFE40weQV34O45apk0cZfL/OTGcnyEdGCraETsKstDlUrySb6wMD52YKrLjjAjHXjZij2gKI5K2yVOu71CfkUpV4KWH37N8O5IEliQpR8Q1KPgFf77Adgq3K0t9BiT3xWe+uk+bt1dAG02wG2GYUHRA1dgr7XC+fSsEFrZnuFMOMF9Gy6qC8HPBPeY4EUFP9FMAjgOTaGr0PIjgUagsAyrn/5Gxw5m9WSev04C62Q7w2qfNgjptTUkVNMwppyakXl/0WOL6Zh0K0LvmyHXiOhx6RhuMQc9p7EH2Jobcqfd+w9q+x0PQz81ID1NaTN7IZ8fL7Uy9If08LdzUhBSyHgjT3QOXUu2yX48Zzg1DwPEf+LYal92NCXfP2myI6r9ZT+/Xv7KD9S44E3qu2JueREOs9xMVxOKGzDrmycAWrcFkpsy0N0CwQ4ZMk1ll7En77az9A657n7tJO6+TLc4oj395xV0X6KowS9t7MmR5oA5mYv4drojIVXugIwixXMLdkXURNzILFeFeQx6+27SdIAjRnOM8iZ4dHewdlptyA6AH905JP/SI3ioAVoMKrY1KF0PJVZP8BzCRGpVlsCSizwpV8biRufYXjU1FNtbEGaSFdYSXd/q0J+gozPBUfoeFtaqOX7Fb3iv5rUbqaREI0uXnVEjQJzddFd
 3i3V+i+B
 X3oukAaOhq23G+PgdUkYhHPfwFOvy8CgJ/n9cEU1kWyORwNs/z+xGu6TTbojlrPlv5OjiAMRM4+Jh8Mkc0Dg4rgd6cSZe97o5kXTN+jmHG/nbBoTtQ2kU1Yqmc6fpHhuePd4HtICVCNd8p7yqctC+JToIl7WMEBGEm7DuKO520SHwP/Gc5YFXCnwarsl9UzvHlj9Rg8j+XxnydmD+Q7qz4VYEnIx2MAHnPq/XcxDXtHgKOElzSMUnR4E8Eux8tYN5p+4whMtnpV4jdespISV1Bin9+d6EMEeV7hQF4ybiRIGK61XYD8h9WqII3ZPtR4XBjNSL+mMSwKfd4hwjWlWavOVA/EMennl9BlphMdZ3B/R5AsZqiZeWtLb82HUakrdv5gF7SIXVLFfkyRcz9ixezu48hz+7J2EEQZQjiMZco8/Ugi0DorH4vl6/OMh2fT5eMiX5BukCaErLrRyyiOw5ncrTT1U+Mui3uzymvXpaNrt96y1ZNjrZKUhhm3OEFSRx8lAtT4Ti0tnGR1qqIGZctBi0x25MvCrKN59k/MPPrdgAkpkF86pRUNhICKBkNdnlVuvXupz+2vDOJ6mwFvaodq3a6uZCZhQzCMHIobaX5YQRtKATcgdjHr4bYjN8JqtN04Gu85ZdLhyGk5F6PYAbLyaJmuQpckuL3dAf2DQY1vdxk8TY+ZyfOdmucbfRBbu+hqtcj/l718DBG0GyFQyFLGRd4kdDmxOLh6xsdB9+KRw21sh+Q1zKY3vysX12+AMLFkgOWbYBDMaOnh8p38vjh5RwZPs3xK1U8VPz1aatzD5kghzV9aoDQbkHqZCVTO5wWbRTq7NXEwTgSCWQMfz1GY093BsKQcHLr0PXEbw7m/uJzulQ9/JTEZ8gWaFIFgcTurTHReMRsXIcslYzdeSCgNw/V1STxgLtiqKwBpYjjkpSEprtlnTizmNrStcdCl4aDLchYnTCQ3krZGYOyZfaIEUra/tf
 L9Q665R2
 sZ2wN+/nNKUhcT40cxi8PbXdla+Zgm1VcMmnj5cX2bqZ5WbtWAlE9VvEE39xnqSLlsAe+4Fx0y8I+HeCjlx5HZyDVkqKOjQQ+OBHQtG5UiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: make stats flushing threshold per-memcg

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-make-stats-flushing-threshold-per-memcg.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:30 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:33 +0800
Subject: mm: memcg: make stats flushing threshold per-memcg
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Greg Thelen <gthelen@google.com>, Ivan Babrou <ivan@cloudflare.com>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Wei Xu <weixugc@google.com>
Message-ID: <20251103075135.20254-6-leon.huangfu@shopee.com>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 8d59d2214c2362e7a9d185d80b613e632581af7b ]

A global counter for the magnitude of memcg stats update is maintained on
the memcg side to avoid invoking rstat flushes when the pending updates
are not significant.  This avoids unnecessary flushes, which are not very
cheap even if there isn't a lot of stats to flush.  It also avoids
unnecessary lock contention on the underlying global rstat lock.

Make this threshold per-memcg.  The scheme is followed where percpu (now
also per-memcg) counters are incremented in the update path, and only
propagated to per-memcg atomics when they exceed a certain threshold.

This provides two benefits: (a) On large machines with a lot of memcgs,
the global threshold can be reached relatively fast, so guarding the
underlying lock becomes less effective.  Making the threshold per-memcg
avoids this.

(b) Having a global threshold makes it hard to do subtree flushes, as we
cannot reset the global counter except for a full flush.  Per-memcg
counters removes this as a blocker from doing subtree flushes, which helps
avoid unnecessary work when the stats of a small subtree are needed.

Nothing is free, of course.  This comes at a cost: (a) A new per-cpu
counter per memcg, consuming NR_CPUS * NR_MEMCGS * 4 bytes.  The extra
memory usage is insigificant.

(b) More work on the update side, although in the common case it will only
be percpu counter updates.  The amount of work scales with the number of
ancestors (i.e.  tree depth).  This is not a new concept, adding a cgroup
to the rstat tree involves a parent loop, so is charging.  Testing results
below show no significant regressions.

(c) The error margin in the stats for the system as a whole increases from
NR_CPUS * MEMCG_CHARGE_BATCH to NR_CPUS * MEMCG_CHARGE_BATCH * NR_MEMCGS.
This is probably fine because we have a similar per-memcg error in charges
coming from percpu stocks, and we have a periodic flusher that makes sure
we always flush all the stats every 2s anyway.

This patch was tested to make sure no significant regressions are
introduced on the update path as follows.  The following benchmarks were
ran in a cgroup that is 2 levels deep (/sys/fs/cgroup/a/b/):

(1) Running 22 instances of netperf on a 44 cpu machine with
hyperthreading disabled. All instances are run in a level 2 cgroup, as
well as netserver:
  # netserver -6
  # netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Averaging 20 runs, the numbers are as follows:
Base: 40198.0 mbps
Patched: 38629.7 mbps (-3.9%)

The regression is minimal, especially for 22 instances in the same
cgroup sharing all ancestors (so updating the same atomics).

(2) will-it-scale page_fault tests. These tests (specifically
per_process_ops in page_fault3 test) detected a 25.9% regression before
for a change in the stats update path [1]. These are the
numbers from 10 runs (+ is good) on a machine with 256 cpus:

             LABEL            |     MEAN    |   MEDIAN    |   STDDEV   |
------------------------------+-------------+-------------+-------------
  page_fault1_per_process_ops |             |             |            |
  (A) base                    | 270249.164  | 265437.000  | 13451.836  |
  (B) patched                 | 261368.709  | 255725.000  | 13394.767  |
                              | -3.29%      | -3.66%      |            |
  page_fault1_per_thread_ops  |             |             |            |
  (A) base                    | 242111.345  | 239737.000  | 10026.031  |
  (B) patched                 | 237057.109  | 235305.000  | 9769.687   |
                              | -2.09%      | -1.85%      |            |
  page_fault1_scalability     |             |             |
  (A) base                    | 0.034387    | 0.035168    | 0.0018283  |
  (B) patched                 | 0.033988    | 0.034573    | 0.0018056  |
                              | -1.16%      | -1.69%      |            |
  page_fault2_per_process_ops |             |             |
  (A) base                    | 203561.836  | 203301.000  | 2550.764   |
  (B) patched                 | 197195.945  | 197746.000  | 2264.263   |
                              | -3.13%      | -2.73%      |            |
  page_fault2_per_thread_ops  |             |             |
  (A) base                    | 171046.473  | 170776.000  | 1509.679   |
  (B) patched                 | 166626.327  | 166406.000  | 768.753    |
                              | -2.58%      | -2.56%      |            |
  page_fault2_scalability     |             |             |
  (A) base                    | 0.054026    | 0.053821    | 0.00062121 |
  (B) patched                 | 0.053329    | 0.05306     | 0.00048394 |
                              | -1.29%      | -1.41%      |            |
  page_fault3_per_process_ops |             |             |
  (A) base                    | 1295807.782 | 1297550.000 | 5907.585   |
  (B) patched                 | 1275579.873 | 1273359.000 | 8759.160   |
                              | -1.56%      | -1.86%      |            |
  page_fault3_per_thread_ops  |             |             |
  (A) base                    | 391234.164  | 390860.000  | 1760.720   |
  (B) patched                 | 377231.273  | 376369.000  | 1874.971   |
                              | -3.58%      | -3.71%      |            |
  page_fault3_scalability     |             |             |
  (A) base                    | 0.60369     | 0.60072     | 0.0083029  |
  (B) patched                 | 0.61733     | 0.61544     | 0.009855   |
                              | +2.26%      | +2.45%      |            |

All regressions seem to be minimal, and within the normal variance for the
benchmark.  The fix for [1] assumes that 3% is noise -- and there were no
further practical complaints), so hopefully this means that such
variations in these microbenchmarks do not reflect on practical workloads.

(3) I also ran stress-ng in a nested cgroup and did not observe any
obvious regressions.

[1]https://lore.kernel.org/all/20190520063534.GB19312@shao2-debian/

Link: https://lkml.kernel.org/r/20231129032154.3710765-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
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
 mm/memcontrol.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -628,6 +628,9 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
+
+	/* Stats updates since the last flush */
+	unsigned int		stats_updates;
 };
 
 struct memcg_vmstats {
@@ -642,6 +645,9 @@ struct memcg_vmstats {
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_NR_STAT];
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
+
+	/* Stats updates since the last flush */
+	atomic64_t		stats_updates;
 };
 
 /*
@@ -661,9 +667,7 @@ struct memcg_vmstats {
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
-static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
@@ -690,26 +694,37 @@ static void memcg_stats_unlock(void)
 	preempt_enable_nested();
 }
 
+
+static bool memcg_should_flush_stats(struct mem_cgroup *memcg)
+{
+	return atomic64_read(&memcg->vmstats->stats_updates) >
+		MEMCG_CHARGE_BATCH * num_online_cpus();
+}
+
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	int cpu = smp_processor_id();
 	unsigned int x;
 
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		x = __this_cpu_add_return(memcg->vmstats_percpu->stats_updates,
+					  abs(val));
+
+		if (x < MEMCG_CHARGE_BATCH)
+			continue;
 
-	x = __this_cpu_add_return(stats_updates, abs(val));
-	if (x > MEMCG_CHARGE_BATCH) {
 		/*
-		 * If stats_flush_threshold exceeds the threshold
-		 * (>num_online_cpus()), cgroup stats update will be triggered
-		 * in __mem_cgroup_flush_stats(). Increasing this var further
-		 * is redundant and simply adds overhead in atomic update.
+		 * If @memcg is already flush-able, increasing stats_updates is
+		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
-			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
-		__this_cpu_write(stats_updates, 0);
+		if (!memcg_should_flush_stats(memcg))
+			atomic64_add(x, &memcg->vmstats->stats_updates);
+		__this_cpu_write(memcg->vmstats_percpu->stats_updates, 0);
 	}
 }
 
@@ -728,13 +743,12 @@ static void do_flush_stats(void)
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
-	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }
 
 void mem_cgroup_flush_stats(void)
 {
-	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+	if (memcg_should_flush_stats(root_mem_cgroup))
 		do_flush_stats();
 }
 
@@ -748,8 +762,8 @@ void mem_cgroup_flush_stats_ratelimited(
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Always flush here so that flushing in latency-sensitive paths is
-	 * as cheap as possible.
+	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
+	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
@@ -5658,6 +5672,10 @@ static void mem_cgroup_css_rstat_flush(s
 			}
 		}
 	}
+	statc->stats_updates = 0;
+	/* We are in a per-cpu loop here, only do the atomic write once */
+	if (atomic64_read(&memcg->vmstats->stats_updates))
+		atomic64_set(&memcg->vmstats->stats_updates, 0);
 }
 
 #ifdef CONFIG_MMU


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

