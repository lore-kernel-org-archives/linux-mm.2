Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B60FECFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0482B6B0099; Fri, 21 Nov 2025 05:09:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B046B009B; Fri, 21 Nov 2025 05:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A176B009D; Fri, 21 Nov 2025 05:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C40496B0099
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:09:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D0DBB9F95
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:05 +0000 (UTC)
X-FDA: 84134191050.17.2867E96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BD8E1A0006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=uNzDCMbb;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=NHmSgWJgTiNdy9cAYUuLLrmkjfMX4+UPa5xDfrNAetk=;
	b=SGvtxuJy3TjQyEgHszq17bjPrwJHgUWIqkAE6VQphMURP5ZYjp6hJOaF7+vXIx7VSUfTzY
	G5fj0qvZQkgw+2xyBlJhB0/N6LKO7xDEtUEQ02AMpPmH6xwZf9VHuaffNoyyhn1zO/chN+
	hFvrYYWj1CVrj2SlrLdJgcxZTjiTvac=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=uNzDCMbb;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719743; a=rsa-sha256;
	cv=none;
	b=jXwIJtgzhTmCC5ktW0sKG0eM4Y91fOFoYod3ca+vDpBSgJ00zv9mdLM7vutfBw7lUDhRlC
	UZpz9T+wEFdK5YdUwpbKWE0fpkpkKDZiXvloLIr8RgfdW+3TPjmgcy8oMvVIJsf0HXZYXm
	VY33/WO/6/2VdP3Gm4f3+Ej+B1XNIFo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E636B41986;
	Fri, 21 Nov 2025 10:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4414EC116C6;
	Fri, 21 Nov 2025 10:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719742;
	bh=O8Fy6X2Ok//DwQ3y//6m4LAo25uFSseFlp1fIrTc6Yg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=uNzDCMbbmAsUW7aCaZ4EtGhb/c5E8OihKFHolS4z+lywYoKFJu7J5UiUv1b9XLMMl
	 +A3iGeX3ZZXWVvIFHVviGTyb4F7QdWknzKIySERUuYt5toIOK1/RJLqgjKdlvPjqH0
	 yc86Mcsk8+hrFDnEwW9zbK0V3RHyrpD66TZetGzI=
Subject: Patch "mm: memcg: move vmstats structs definition above flushing code" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,gthelen@google.com,hannes@cmpxchg.org,ivan@cloudflare.com,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,longman@redhat.com,mhocko@kernel.org,mkoutny@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,weixugc@google.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:43 +0100
In-Reply-To: <20251103075135.20254-5-leon.huangfu@shopee.com>
Message-ID: <2025112143-pucker-swoop-5df5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD8E1A0006
X-Stat-Signature: gyimug97ggjomfie7zkzrb5gcc7kiq3d
X-Rspam-User: 
X-HE-Tag: 1763719743-936384
X-HE-Meta: U2FsdGVkX18PNXpVoZQ/Pu2MPDbgqVIyRPTPyH8DGCXClbJD6wmp37T3uQsEBlAOgqVGdI0kz66ZB8+rHhokNQ2+sOE3fzbKlxVJP86MWdab3k5UhIdVacTB2bE9OsKl2evy7mArfe+yWEl0M4+CRPmuQ8YuRnSolJhJuj+wEqQn1ROvAQSP7fPahDirABjAmESjcFqDVzXt/9T1uEElIvdJiZUc9sr6QeKreSV0MdG6vfaje0uCBzrE2kdaX/Sh50UYZgtA4PzYBd4VGHFR9zfUtr5TIKuzVEbYaiecsxvKXmmXlOfqvCyhTxVcTZKxnkzZ6ikE4kI4ID4ZkeB9KeOE5VZhuSVFiO3t66txHdYbhPUQB81/hsjs51OE7dlMH/SwniqdnhW4qZuc95TY2/So1YP8Dc8/Ka9ZNanMoXc1FNF0B7HWjiSxIET5LdWwS49s2b3dT2FGxY3tBHU7/hLWW2yx/PaHUyONMmeYEHGFJudbQ+FAO1Soavcw+h4ArnF1lsVFsIlLQuGY0ROAsm3Sft45ZP8Z/U18m17u2T1IDbrPb2yOASfhtGxa6TQU1DWQ2HFn/T/y1KdLoR2h5Su0aW/UONNctd46Sada5D1Oxlq1Uy7Mjzhd5idmOPVrf4ltPbuub/vbOHkyNkbBog294v6KFCqMO7uzNfafxbqhSQ7O0Om0wAdwkG/X4LhMHujmLspG5SSnbH2QSTlBmhJR+l0hGTAoAyOHpaqnXdE1iO0UAUUOqfRlBnZVGF3yD4Kh4jamE8o/lUAUsW8RF7VBA1Pi1AF8TQ4nh3jonF7M5ppMAl/jSf4rfEZ1LeJ/HlNX7ydwNTEoHnCzbfU99Pejqf5d+rIqRCR17h3D8ie/DH1MovtklIp/MmAXixgurNvBTURvdwxs01nVSDSF2PrUpxWwdDKO9Q6x3BLhUW3LNAZXlF0XcWJdQq70gT+XJUV92RK/03+IYC5JWTG
 7jByJjj4
 UAwGMbAn/Nl3zyGjgLJAIkg9HCUraK5t/fwCHd7yPdrWlzx+YdQaGn8Q9iaipK3PWqlwdqS6kBmvM1ybxAGdRua/GSklW3zt88WU7EYate9dtbWf0g3h+8p3nyfz7lWHs6IqZiXdC6vCiOL5raauTQPQDfOsl+ZSWZ3cr4Ay684vM3p4bnCi1TFPZxbY2SRQYQH4q0N4g+i39VrIvPtupHWdPDrFaz6nrEYHj8mene3s9sxtHJ0E5YMwgipTGO3qEVBR6WyeC+udbIczrmOly0cNn2YLY1fDMHlo84CeQPIleT97gZn3A2p3i5b9i3SEyukY64XTWSkEFpVwWncXNkQcEW0uexmb0Kn5P6kUzc4O9TjeG5zY+Y8EBjnnZOgFtl4w0UCipWERySB5M2V2vqzz79l/rHRiWBHj+t8MuB/4X9HAmlWD1TqudPYJ6pUSwil6BLNnxqO6/xQhM/oxJAl3PRexudcMiR3LD7DhazzmTovcIXA+lsxpOHt/Qvnw6mGrW/gJXJV4onFb5IwfsycmG9w+jQGrNf4b/LGeekgdBNXhi/3UXrUmblKxjQxz4ZZegVTs43o2/rWizVjkSUKzgLWMAojqQ4OF9jrQY4TcXi/sxbiz5tNiFLnYetZl9HQkS/Oj4C+obh1ew/829qKDwbSKYSb5YQKwH8tbFNsTQklJVF/mhYoDBdgWI7G+PF8+JNSqr59QGakeXM/5mz9x28UzYYKV5GvbZEtFDYSGNPhdndbuMWdw52XVsGoysLxESH8Ae8MmBSGlwB25DVvmIBUga7RYK/FZBj/QlTU1B7GBoPpEGElWOUVQC9Hk/tvDHfzTBSfhNNhiylpeHs+zB1xi/bLJNYSn+ZgZAK45RQJBDhozvOaWLnpI9XpneEiJPae6kN9hsOVFM6P5FyIla+4BXpGcQp3tgGd7vmOjLYICW7bka3Zdqft8nO7IuBCD0lNoeLtHTlod9vTc9ItPu7uDL
 pSlqTmK4
 E2lnSFaTSvhi5DsQ/NHmvjgtk+vp8A2MJ81lJaIKmIb5NH3XvH813GP/qKjvfpAVQV3BBBlCMHllazdKqU0vebilEVGADbLgO6MM6gEKvW4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: move vmstats structs definition above flushing code

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:23 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:32 +0800
Subject: mm: memcg: move vmstats structs definition above flushing code
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Greg Thelen <gthelen@google.com>, Ivan Babrou <ivan@cloudflare.com>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Wei Xu <weixugc@google.com>
Message-ID: <20251103075135.20254-5-leon.huangfu@shopee.com>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit e0bf1dc859fdd08ef738824710770a30a8069433 ]

The following patch will make use of those structs in the flushing code,
so move their definitions (and a few other dependencies) a little bit up
to reduce the diff noise in the following patch.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-3-yosryahmed@google.com
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
 mm/memcontrol.c |  148 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -570,6 +570,80 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+/* Subset of vm_event_item to report for memcg event stats */
+static const unsigned int memcg_vm_event_stat[] = {
+	PGPGIN,
+	PGPGOUT,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGFAULT,
+	PGMAJFAULT,
+	PGREFILL,
+	PGACTIVATE,
+	PGDEACTIVATE,
+	PGLAZYFREE,
+	PGLAZYFREED,
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
+	ZSWPIN,
+	ZSWPOUT,
+	ZSWPWB,
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	THP_FAULT_ALLOC,
+	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
+#endif
+};
+
+#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
+static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+
+static void init_memcg_events(void)
+{
+	int i;
+
+	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
+		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
+}
+
+static inline int memcg_events_index(enum vm_event_item idx)
+{
+	return mem_cgroup_events_index[idx] - 1;
+}
+
+struct memcg_vmstats_percpu {
+	/* Local (CPU and cgroup) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_MEMCG_EVENTS];
+
+	/* Delta calculation for lockless upward propagation */
+	long			state_prev[MEMCG_NR_STAT];
+	unsigned long		events_prev[NR_MEMCG_EVENTS];
+
+	/* Cgroup1: threshold notifications & softlimit tree updates */
+	unsigned long		nr_page_events;
+	unsigned long		targets[MEM_CGROUP_NTARGETS];
+};
+
+struct memcg_vmstats {
+	/* Aggregated (CPU and subtree) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_MEMCG_EVENTS];
+
+	/* Non-hierarchical (CPU aggregated) page state & events */
+	long			state_local[MEMCG_NR_STAT];
+	unsigned long		events_local[NR_MEMCG_EVENTS];
+
+	/* Pending child counts during tree propagation */
+	long			state_pending[MEMCG_NR_STAT];
+	unsigned long		events_pending[NR_MEMCG_EVENTS];
+};
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -681,80 +755,6 @@ static void flush_memcg_stats_dwork(stru
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-/* Subset of vm_event_item to report for memcg event stats */
-static const unsigned int memcg_vm_event_stat[] = {
-	PGPGIN,
-	PGPGOUT,
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSCAN_KHUGEPAGED,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGSTEAL_KHUGEPAGED,
-	PGFAULT,
-	PGMAJFAULT,
-	PGREFILL,
-	PGACTIVATE,
-	PGDEACTIVATE,
-	PGLAZYFREE,
-	PGLAZYFREED,
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
-	ZSWPIN,
-	ZSWPOUT,
-	ZSWPWB,
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	THP_FAULT_ALLOC,
-	THP_COLLAPSE_ALLOC,
-	THP_SWPOUT,
-	THP_SWPOUT_FALLBACK,
-#endif
-};
-
-#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
-static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
-
-static void init_memcg_events(void)
-{
-	int i;
-
-	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
-		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
-}
-
-static inline int memcg_events_index(enum vm_event_item idx)
-{
-	return mem_cgroup_events_index[idx] - 1;
-}
-
-struct memcg_vmstats_percpu {
-	/* Local (CPU and cgroup) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_MEMCG_EVENTS];
-
-	/* Delta calculation for lockless upward propagation */
-	long			state_prev[MEMCG_NR_STAT];
-	unsigned long		events_prev[NR_MEMCG_EVENTS];
-
-	/* Cgroup1: threshold notifications & softlimit tree updates */
-	unsigned long		nr_page_events;
-	unsigned long		targets[MEM_CGROUP_NTARGETS];
-};
-
-struct memcg_vmstats {
-	/* Aggregated (CPU and subtree) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_MEMCG_EVENTS];
-
-	/* Non-hierarchical (CPU aggregated) page state & events */
-	long			state_local[MEMCG_NR_STAT];
-	unsigned long		events_local[NR_MEMCG_EVENTS];
-
-	/* Pending child counts during tree propagation */
-	long			state_pending[MEMCG_NR_STAT];
-	unsigned long		events_pending[NR_MEMCG_EVENTS];
-};
-
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
 	long x = READ_ONCE(memcg->vmstats->state[idx]);


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

