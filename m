Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AC8CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0158E0030; Mon,  3 Nov 2025 02:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770918E002A; Mon,  3 Nov 2025 02:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638118E0030; Mon,  3 Nov 2025 02:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7358E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E58E5B904A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:23 +0000 (UTC)
X-FDA: 84068530686.30.CBE9ECD
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 080C7A0006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=itRLBKTo;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf15.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156402; a=rsa-sha256;
	cv=none;
	b=5cwdSXj6TXUF0uvuposj4eqwYaS317UvavQUOp5K82iNLKa+GFswRx2QtyL9ZYyTAOKnM2
	HWPxxQx5FRasyPIn5lWFIQ1dJDpN+GlxtEruhirktQCiCfVJFU/aeds2QUM6Tm5FNQRTXf
	YMlHsUEUlkcRQoBDZucqEaIfEp3CenU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=itRLBKTo;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf15.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbphvwlZY5Z8mMpRxJCeoPt3Sbe7fHbYhkrPsa2IkNg=;
	b=itcXl7b+bvPtHIGluUoR3g3v7CxA0KZ0liiP3jMMQWO9mxFxWPeq3omFUIgX3prNQNSbjg
	oP9EgMBjcFtYskYy24rUbjDYM/X7VrZHXsn6VkHLcavAHmdC76NrVKI84wBGL2RGtRN7YM
	hNRLrG1Oc9VMzQVu4c3+85FpI45tT0A=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-339d7c403b6so3732257a91.2
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156401; x=1762761201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbphvwlZY5Z8mMpRxJCeoPt3Sbe7fHbYhkrPsa2IkNg=;
        b=itRLBKTokDEVkn0J296EQzdoPr+MDmwG3R3r4trza5JHhyC5uUUXGm4mFbbs9S0nM0
         UUAM7252rrWMwjodzaoNILIgeqwsvc7tS6xgCxclY0TwPmTUxg7/kwDTVmucPL9rxEPm
         G1VW7XwO77Z23x6Fv6FzUycIEmIlOVUbMehcIV1hYt9kSndeaijaw+uG6a7ojfUfXDCb
         3U1bSiNNPNiHrJUAkq2Wn1H8zDudC16+5w5tQbo5OVAJM03JFXZY3c6Tmlr92NxykUHE
         E/GmNW/azzHeG2HioOTrQKKcwKwFi0mDe7ckiSO7PD3ZKnvcraiQtCnqS4f5bO4gyqmj
         n1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156401; x=1762761201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbphvwlZY5Z8mMpRxJCeoPt3Sbe7fHbYhkrPsa2IkNg=;
        b=Z4EjZK2oZcpM1Y9lpbbWIAuqdIwwrVFvk0JzBAy1DdpraeeavDIgSN81m7IUBwwqiX
         H0dwjfAjN+eNWOvxoqharRkjPn7FAO9AavTlkfcbk/ACGPVCCOZcdShd+PXKyJrGjZsJ
         n1bOyfM0R51ZgQ6ROohGARVFcO/WyU3a/SufVf/Gb8b2GMk+pCCjP4gTqqHEIP9kqs4c
         SXjpy7lIapu+SVLdwyKDEN1vF2VdxXJs5vsf8gt9z96FLviC1CS8e2dip3EJL5NFG1oE
         sdQngyG/BTiT/sWDlzx94DFSCluDV5ckm3io2wUS+RvCJo9o5n5HMe3lPwwHtgsa8DDU
         Iy1A==
X-Forwarded-Encrypted: i=1; AJvYcCWlaF/bXDbtz0kj8mMkU5np1gxR/LzkUBd55nhA9ePSPNwkxMWkr5GKY0+pL82KOucOvTjmgrYA1A==@kvack.org
X-Gm-Message-State: AOJu0YweJGRW++ZmA7vKYVi1PiR68v3U+WdoWa2CPVTC8jbXgPDGQ6Hu
	q53i3l/l0DpJBSJtD9mg3nJdNY7P7iS7LLmYonGzRXUeSzScho9M21q5y/7XzsV8MBA=
X-Gm-Gg: ASbGncvD3T6FHpjUns4WXWPIxCUTDqYR8ja0g9YH3gOP7cIZD2SVDNr8cOKRcy7aFXy
	ng1avtM2r58cw2liPxhZe3XIorcD4Qq57MOjl0OmK7YEZG/4hGhSGUbsYAWtHawoRzQKmF9LDRS
	Nd2JSMw85ynJxg7o9z/TeHfpKa8u7F5xl9F6XNAOY1tCH4fLhGaMLup1XQd+wojIf63zGK3B9Sf
	7MWPKmu3/kDYzDd2mu7vAFTlSt7xUwdJP0+dDli1TIUlP9K7a+0eYqjLqZug0tR/KALq7Y7WfqR
	XkQLBnpCbpSsO/YICxjMGEX3k6QjfrvPell6hyYVREzG1FaE5kB/6WGKs+4cwmI4YQZNd6acRMC
	C/wU+pzi/U4wL1qPMiQSwv+bkAyASj8fbeVwAYNsxjSbcwRQFTEgpyhgiDi4h53zjD7+KEZWDOQ
	iPYGne5BpQq/wOVVNIPpC9/fdAmSo0l35iIo8=
X-Google-Smtp-Source: AGHT+IESJtnYCC+6tKU/IMMlAFX3OXThvg7/IT5AO+qIlJZ6EL/qIntowvs3vVciOZabgFGZ7594Wg==
X-Received: by 2002:a17:90b:39cc:b0:329:e4d1:c20f with SMTP id 98e67ed59e1d1-34082fcc5f5mr15216714a91.9.1762156400905;
        Sun, 02 Nov 2025 23:53:20 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:20 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>,
	Greg Thelen <gthelen@google.com>,
	Ivan Babrou <ivan@cloudflare.com>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Wei Xu <weixugc@google.com>
Subject: [PATCH 6.6.y 4/7] mm: memcg: move vmstats structs definition above flushing code
Date: Mon,  3 Nov 2025 15:51:32 +0800
Message-ID: <20251103075135.20254-5-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 080C7A0006
X-Stat-Signature: 5t4trfi6cpi8gue11mizcinotigyttg6
X-HE-Tag: 1762156401-691808
X-HE-Meta: U2FsdGVkX1+Oe9b0TZ+66+mniYDD2u+aBUodMXAcF+YmE+dLN/qDvkzr2ZUXKK4MW9JHbF0Q+LC/6QrJgbz/5QTte8QHk5D372BacgMaSSmFTUDwRhSA95WUZw8sh/k2LXlDgq2Be40RzugaiNhc9iIhgRkmoEYbPYQUQWf/BmXAqawUY6qN/xQ+qtCsvk+voIarGfuKixl+EL+c5wfNbwhrys/YGoc+t2c+6W6t5gmsDwi1Pcswv1uiRxQAaVJ840c0llMyAw5C5LaZix77IsDCvfLGnwYH8xyQ9ru0WMkvQTaKfKwIhV07MAQuE2zodxsaSdmO+FvaPAWnqmn1XV4ivp2cPs+DXIkOMrURG1RX2BVW41HSwwWB7j/+yv2EDDlF/3Zgzqaa29dX0M1dbWV50mHtIHo/EiCyt/AHx5i+DDvH/mjq9xysVSRz9s9f6UOqRJLEVwPEfs3SLKX14rLDrNjfrN457MbqOp4hbVg7+sQNvuLMh0Iw51qNeaZVyxa2bFfJI1dE0QrwCa326fAsd/VB2my8V7Xko/3NMkcphsEbseRpcWXTUdQC32+4BQkUKsJ15nq8mtANStu9cLXxY3LTMCJAT3h5nPjRHr6haWMp430F8JXSuk9kteXrlKcppDUbjKyhpwEswaMqTZ8d905zxaihfWF3zClyNHjtCe2aHtOK+Q2rAJpbxNbEkoS2Q04APhL23Vyt3eWOparWpaD3kqBHPqYWTr2C5mMJ4jayOpx8uQ8luvdYn0Qxlkx9ghdJKHIvQwhrDXxg4QQ6qhQzu72lrXbmPR/30GTs0nIW5ZqYRdeJ8KkTlyDPV7pN8hq0JUTYjDv2xs1GkLcYIJkEpa+a+Zm8fUBm09n7okmJELREw2QyHiPhGiw0EmIGsMd/Cv2As42xN/rhblQtsI+/cNiVKFIAc3dZ7sn7WteblZ5aFJ5erN6gOq143EqBCKvKPfK7qIo8oH1
 V/CCzrTC
 JR03CjWIU59F9pqCwQsVfJqeQGpuJjG5MTXRonV+CdVq3rf/4VGvtKSlcE1qPKnFOP3PAraSCxhz7cyKeuud+TH9YMPuaV9nYmRIfI6dr5b1zK8JVYB/Y44ksi7uaB5n9DSZnmJg7qxUJ/BQaxmjnKhQvOlKKNsk3XjJtyHDHlnhC9NVdN8+sBUHlehYuMBu+4ZyfkkIIQMlzTd0tShaJp1YQ14nJUlgtgFPmayTxctiUBjZxdAQiL3AlIVetvkoqKPDoxFaT6EYne15iyhe5uwfknmjWhotKL5seUJSo5OjSXwf5Avd8YueYxmCJthxzvEHwx4P9xeCeKvAupT/WLEhRECD5v3ssqSU/30a2ayh/8M1w5cutWqP20eYXlMeFF05f+2shvU+RHeQcRCIKkDKJi3jcLiul1FS/7YgqdWK9vmZPoMvxp4ptSb0i9Btp9QNra76vSgZEQpKW9VjfWV4lLcrnMvazzm4tUirwZwyN+AvaDeGQm1SAFPNtkD2+S/f2cP6WH7/FPo67KIaJxOF520uFPvOiD35uy+dUCpJreSb49bg8RzOPKaQheG/xXMe7IKdI8cYAM00LrSALUV2ntigyk/8M2mvyuZjMXLkmSE0220ton9itfk1/kA/CBpsYQvUoCuqCGHbBkJIIWcudE3+059eFhtXeDK1jwF5TxbWcxfSXo7GBgt3cgBgFl7Kk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 mm/memcontrol.c | 148 ++++++++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 433cd273006d..157be6820fd1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -570,6 +570,80 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
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
@@ -681,80 +755,6 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
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
--
2.50.1

