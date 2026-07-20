Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228F3C4452D
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4892D6B00BA; Mon, 20 Jul 2026 15:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432896B00BC; Mon, 20 Jul 2026 15:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E91D6B00BD; Mon, 20 Jul 2026 15:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D12D86B00BA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4745EA0212
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:33 +0000 (UTC)
X-FDA: 85010159346.11.782C0C4
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7BE124000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CyzeHzpD;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vrQuTcVEPlse/fTzTDhuMYNi8KtlAM6dYGGAEP65OU=;
	b=W/7t/nTtbs4kK1yX6hj3HnQXqsqMSg6q6FgsLpGJE/M4rb0J9oh1FDAvsxz44op265UM4O
	Nj5tbDbTxokWRqQYg5OW+IdRBiaocF+7DYeUPEYxQTp/D7ymHPt4iVHdVVesk5CTlWG0e5
	Tj+0QV5zPn/Y/NIatJisJ+A4NhQc/do=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CyzeHzpD;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576131;
	b=pUVvSb+aXRimduUzJHqmuLxHZyxCTX2B1BJtWkkEfi13pRAunRoi3tAWQD9HbMflDWvCjm
	7BqXO7uuse2rvnCl+mrK2+/MxMCrhUKcv+ao7gdpjzfNbJ4UJrBrv6rghYcxzpth2QmEtL
	oMIWJylE2/dQd9wSvnhfqFrFdpT/WIg=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e7c6ec9dbso548887585a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576131; x=1785180931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5vrQuTcVEPlse/fTzTDhuMYNi8KtlAM6dYGGAEP65OU=;
        b=CyzeHzpDw2sfBy2qR+1yzUyRaljXkVwAQSYFByM231hv5RbKzsMEHeu8VTif4M1YP6
         kbkPSsUAwf1IRUh4kmNY/NQJ8AmEAoB6Oa7DBY0G96yfkk/KyRs5Hh/fABWoNvdsu69H
         qQKTwfCojsIhMyFgd+ZmSqxEzrwjFfkLcrZ+d2v8RbB8sV5QlVN24mJOmqSwvplzyBCh
         RuVA2F/cHx7yupYa8t7vkmQ8abbqPPD1/1z/VvM2Fj39TL/jIKP638GxrY/KTPv6kavH
         ipmj7dtBet8f6XU1pmwZT/agtlP/6QXXkjNs3Nl3szXK+/m1N0IbkBoR2794zTF4y5d+
         s2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576131; x=1785180931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5vrQuTcVEPlse/fTzTDhuMYNi8KtlAM6dYGGAEP65OU=;
        b=PwJjolEs2R+gI2lEGigBQ5pZZrwwZDtj9txd4XNevU+M5DKLC8R43SxOP0cZzJR2Lz
         28Q9dwKTIsxK89ljdk1Z5ZEtjM9J6v6EKPlJ0aq2SomFHIMMYB21AVT+H1/e38ofoJ6s
         iK8Jf9/XF8aFXAj3WG19j53cKU9ZkJWhMt0dezhAytc33om+LcVjg4xw9kDceg0AgYpv
         yQjJrE/V94xCKwEfPOtr4HjgaS1sXKMLGXa7SM645wWD/VAVrZbdbhpAr3ZBqme6GMRT
         6yaR6zrtpEBqEYKGZbBCq0R8fMZVo6Guwv7tkv0O1ZKLO9RMTkQLJinV2CbKfutMfRVU
         5PvQ==
X-Gm-Message-State: AOJu0YxLLxlshcpMy/Z+r0D9KvDLuZEp2pXkc4aIByg3bWckuz+qT1Fm
	vwrUuwdikqBOSjso+701eV8Wz2Nwx/LGg7KOyw9Cf6/5jBhoClORupAdGqUlbJ+FtpOxrPhbn5f
	G9d/b
X-Gm-Gg: AfdE7cly46h7jEc6hOZbWXzU2G6pNiHciFVV4uGTtZJ7/ZnHDp2339xfz+qWjagSUok
	o2koN2GasQoFUZ6rjj8WOVMM88SAn8pJhrGdxQ+4neE5EVMBK4SQF81rpNIFEFgXFF936+fLydl
	AHRH2kQhCwkBpCoUN1eYnTKsDxyC+ycUunOqA36YEH23PY9GYVx8gk+C14fIUlHRL4IsW7tHj7D
	oV/uC46u70LmRhrrOGDaPgWjLg1IqYkPDyAE9WMXb+F4QnkkHcR/5sjPRHlsoUqtKviWmjH+yZz
	aNg10S+s+7IATw9cOp+WtaFDV1QkylNn3fLtUJk+RZeC5wVqi6MW8wJPTt5F127+DCrFjt3MZ3i
	xNk7s7Db1w2gBAg6phVKKz39h+EQdceMIMMfSotcatrjY2wZiX5J4MIjSKHYBEeUxoSE7VyljGw
	e9Liw6DPFJNq/8sRrduh5+dn0BOR2Y4RPFyVPgsNaSPAdHZIocfAyYVT97nB74jZU=
X-Received: by 2002:a05:620a:4606:b0:92e:c117:5ecb with SMTP id af79cd13be357-930b430a072mr1502942385a.75.1784576130602;
        Mon, 20 Jul 2026 12:35:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:30 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 20/36] mm/memcontrol: account private-node memory in per-node stats
Date: Mon, 20 Jul 2026 15:34:14 -0400
Message-ID: <20260720193431.3841992-21-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7BE124000A
X-Rspam-User: 
X-Stat-Signature: siczkrwbkwmc93w5hjzzmao1r6te484r
X-Rspamd-Server: rspam04
X-HE-Tag: 1784576131-74812
X-HE-Meta: U2FsdGVkX1+/LW/aoJakit7E/LU2QYH95aKWUTvZInnEkLxBSuzSx4pVwiiKmF0RBJbHCP3T6OJDR7gzdyM7D6zjN8SVsnpLCz12axGLbqWkc3WhiYoTDZZxU3AAEWDAat7w7GpLUF9APmszzalqEmpwpm3e5HuGnWkA3idzq/++GhxMmrSpUGrRNrAyzCIcNmaonSUHJnU1WnD45lawbtjwsr0fIg4LU1kTkNb/PRLbey9WbHPR5AFTh9WvfmQ24w0skJI1NsOGojhDmk4fK9Nid+F5ffm6JU4+cxe6gpBXldkE9+aCjREZAmNxqrK9wWMFiCcIhYy1w+3AvoaIEdq2Z05Ag6PETgNKLpZaSRnaEbtg6Z5YpkCQDZUhKC3FvHocqfK6xUX4uQPq8N+6u6MOvtXzw8rsGHOkALkUeE7BXQRfexXrlEeJLD/fnsD7gPXXkAWOOZNegTYKfNB65WWnWusS2LUij7vQdULPWdlL1wiMvDsCbQsHa93GgliLRxiWD+f12fRmaR9DJxtgovAWsUzsIgWr0xrRqLEQrN64AoLwciQ0xqlw/RYojbMV48I+42BnRvoCUmlHTrAGQZ0CVRd/bOrgO/cTWV1PzgpmD3TeB1o1zEjPCk8JTZuF3qusAvOq8olSCs87zWdsJO6KboVImfm3yARu8VEtJiDKtR2qAaXSrEmb96o+nus/pqa5bKFR46aMlp8es1QhQnTzB93yptjtmkZy/0YvRqOui2dj6JcNIgPvebe3ZAFSxnku1syyPGZzLPl4ehLhAJXDgGJDpk7B/KjbmpVFLnqBfsw5XuOnSb+F/ZFwB0+W/jA5IxX+9sggrUj3qA43RcpaNQHIxrIiKMVk51fBLIomLFm+ERbX8ZwUkUFX6oPtttscl2hS3h14BhHDsY1BL5nSOb9+KNw9kcpXqC2lyGw+lub9zf2CCOqZEwuT/8mLVNNfzYPupYxf+9d5+zP
 JYSPu8YV
 1ONHVK7Wcm7AXLtaMg/0Zjui8InMLRZn/G2Km1anxg26cYOS3Qkis5SvnqcLCBtqVtcNdhqLvG7kU847qWPfM9adtPM9QSafsRBPuw2qmQCsSUBb4mW5G4UX5DyG+nYajG9BCU0fn6NwWwwTptjiuGDPjzKHhtft0ulSxd67/yWnJ2ST0yVQ8qf46CB7wfnXzHWxMNgrUEZYR703qRDU8o7YFkmk0P3tQq1qUl5QnSk8xVTs98e6SF4pWj/gzF3NCL5juJhdEwZ9NX1tEPfJUQ7hwdXiSazkAxrutqmmgwuwx6zI8kHL+JD7cEMpwB1UAQbdfaRbquzvesnXfAQw4du7HcXhuIzY14oYW7XmKPzwCSrkk9jYGoOmyIOqFApr4Tul2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private nodes folios are charged like any other - the node's per-cpu
lruvec counters are increment even for N_MEMORY_PRIVATE.

The memcg-level totals in memory.stat therefore include this memory,
but the per-node views do not:

  - mem_cgroup_css_rstat_flush() folds the per-node percpu deltas into the
    aggregate only for N_MEMORY nodes, so a private node's lruvec aggregate
    is never refreshed.

  - memory.numa_stat (v2) and the v1 numa_stat skip private nodes, so they
    never emit an Nx= field for one.

So memory.numa_stat does not sum to memory.stat once a cgroup has memory
on a private node.

Include N_MEMORY_PRIVATE in the flush/display process so private-node
memory is folded in and reported per node.

This is pure accounting of memory that already exists and is already
charged, so it is unconditional - regardless of future capabilities.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memcontrol-v1.c |  8 ++++++--
 mm/memcontrol.c    | 11 +++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d006..5e464e52dfb9a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2132,14 +2132,18 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	const struct numa_stat *stat;
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	nodemask_t reportable;
 
 	mem_cgroup_flush_stats(memcg);
 
+	/* Private nodes hold cgroup memory too, report them. */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+
 	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   false));
-		for_each_node_state(nid, N_MEMORY)
+		for_each_node_mask(nid, reportable)
 			seq_printf(m, " N%d=%lu", nid,
 				   mem_cgroup_node_nr_lru_pages(memcg, nid,
 							stat->lru_mask, false));
@@ -2151,7 +2155,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 		seq_printf(m, "hierarchical_%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   true));
-		for_each_node_state(nid, N_MEMORY)
+		for_each_node_mask(nid, reportable)
 			seq_printf(m, " N%d=%lu", nid,
 				   mem_cgroup_node_nr_lru_pages(memcg, nid,
 							stat->lru_mask, true));
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f0dde52dc9e0e..4d79e238bc57d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4496,6 +4496,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct memcg_vmstats_percpu *statc;
 	struct aggregate_control ac;
+	nodemask_t reportable;
 	int nid;
 
 	flush_nmi_stats(memcg, parent);
@@ -4524,7 +4525,9 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	};
 	mem_cgroup_stat_aggregate(&ac);
 
-	for_each_node_state(nid, N_MEMORY) {
+	/* Private nodes must also be accounted or numa_stat is misleading */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	for_each_node_mask(nid, reportable) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 		struct lruvec_stats *lstats = pn->lruvec_stats;
 		struct lruvec_stats *plstats = NULL;
@@ -4947,9 +4950,13 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 {
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	nodemask_t reportable;
 
 	mem_cgroup_flush_stats(memcg);
 
+	/* Private nodes hold cgroup memory too, report them. */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
 
@@ -4957,7 +4964,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 			continue;
 
 		seq_printf(m, "%s", memory_stats[i].name);
-		for_each_node_state(nid, N_MEMORY) {
+		for_each_node_mask(nid, reportable) {
 			u64 size;
 			struct lruvec *lruvec;
 
-- 
2.53.0-Meta


