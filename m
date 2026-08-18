Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B46C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883D96B0130; Mon, 17 Aug 2026 22:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8346E6B0133; Mon, 17 Aug 2026 22:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7239E6B0135; Mon, 17 Aug 2026 22:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399FB6B0130
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:34:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7D5DA358F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:54 +0000 (UTC)
X-FDA: 85112822508.21.6B746C5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id D14D5A0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020492;
	b=eZba8Klq7BErkoak9ZeRWOtZtVgoooA3mn8Urx3A89PSPnc/zMdsro+6e4VSUF915zN2cA
	Ug0YfblbBurDeLI8HerFiAzuv8FvKa2BLEF7uyj47L9I5Fe27Mcxj3h0jZjBEgp44ZZIvz
	OSYQXLBUSioQxPK2Gb18BXIOKe0VQ/8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/0svh9j5ScLk/qqecFkmM0VlZnlwFAGqwxBn7vOuhTw=;
	b=HixolUSwpuu4s98tujUtIUVaxsCTw1Bz/Hg2M+U6zNKctjjivHaAPmxJTz2wi2HS2Blzig
	nkEBZ5CqkxJP8vXM12mjZf+ZCBTRKkRaEcfin0CTreOMDUbKCLOKFE2ATFw9+RrDYQtJfP
	DlBoLFvZJ8CZzxcpvY03roQiQL24QkQ=
X-UUID: 5dc877189aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:40fbb603-83d4-40e4-93d7-8c15ea63e4fb,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:40fbb603-83d4-40e4-93d7-8c15ea63e4fb,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:2ac71e1d8fe337a34aa18802dbdd9618,BulkI
	D:260818103445VLMWCMQC,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5dc877189aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 906498104; Tue, 18 Aug 2026 10:34:41 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
Date: Tue, 18 Aug 2026 10:31:19 +0800
Message-Id: <20260818023121.100613-7-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D14D5A0004
X-Rspam-User: 
X-Stat-Signature: 14edbf1rtutn1ppsihr1zt6szbihq6ym
X-Rspamd-Server: rspam06
X-HE-Tag: 1787020491-737295
X-HE-Meta: U2FsdGVkX18awuJFKS86GBDGj08Pi1Vg0E9UyisyuC9zVZl0tFGdjX0NtVGRZ5z0uGK6nWcd6eFNZdejD+kfpIPh2v0Dt/+5wDQYG8OQp2EivA2rwR87znFPoRQlVxF2at/54fddVp9RdkzqMM3xVOP16kSbXrtSYTKBsFVfXWM/dQGLwdta8dmoV8CXOOs1Lymo+Unyww0PtwOx2jQmOPIBRG74Ig5qQAREJsXyC8xP93QAsJQKi0b5KHL/CKSLcgHjuvmOld+zUqL4kJTLpmubeLcJ7gijudONw3cHqUPXkozCtBMGgBMHmCApBh4JIkLuLgXjE2Qlbl19jusOtoG6Bo7KwsE4QIhb5S1EixWPx4prr50nhi6206bmOa8QpqX5huvq2566WL2S7CVM+fo6f95IhbkDyNRF/pi2a5g8Xt2z646eWvT+6wHW9/5O0CO4DSZVCXQMFKMBfO1I21a9sGzWiJJDrYO6vszPxX3/yOIFbmD3nN/D4HAcc5jp5fWcNXVr0EcA4I+euLbabXoGyGKJlPV04yixnAplFQIRw8j9yIZRszxwK/+l4W8wXfKjrLDjuPBxgqtEnHAd+QKiX6UNQlUUjqPpeQE8K2efTDaFSmAAaSdugwDx3XU63Qj+CksrikmlYk4WcbHT81mbYHMp6B+rhvUw1R/I85NKmZVomtRzhvyqqT3Rn3lmgzYqpFOdf7EwLbl8RelFBmSdMzmwRVfc+frXOlwoDyzRALibClSDP+rWYl6UYrsMk+nKif4WyjHdjjnHazHTaH/lnUEs/HsJW8ZFLi7adewYlAanhxfHBBGtPhoaZvvcPsZADLr8p9IV2l7QgupE2Z0RAp48I+E0JCfthr4SSJloxm+914I8haTm1FmwtxPNEqd2szJ0c/I92DpSguT/Ad2ph55W8TDF/ICjmCa7B7Dj9VwlzW69PXPCUMNjZDlgGv7za54S47z+KDDGDYi
 Xr1OJezs
 hF+cs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

Introduce the memory.tier control file to expose per-tier usage and limits.
Counters are pre-allocated during css_alloc or memory hotplug:

  tierN.current=<bytes> (read-only)
  tierN.high=<bytes|max> (default: max)
  tierN.max=<bytes|max>  (default: max)

Writes are parsed via page_counter_memparse():
  - high: Sets page_counter_set_high() and reclaims down to the new limit,
    scoped to the tier's nodes, mirroring memory_high_write().
  - max: Sets the limit via xchg() and reclaims or OOMs down to the new
    limit, mirroring memory_max_write().

Since counters are pre-allocated for all online tiers, updates require
no memory allocation and return -ENOENT for unknown tiers.

Example:
  # cat memory.tier
  tier4.current=1048576
  tier4.high=max
  tier4.max=536870912
  # echo "tier4.high=268435456" > memory.tier

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/memcontrol.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3aa55c287248..a6c6057f0e4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4822,6 +4822,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct memcg_tier_counter *tc;
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
@@ -4835,6 +4836,13 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
+		page_counter_set_max(&tc->counter, PAGE_COUNTER_MAX);
+		page_counter_set_high(&tc->counter, PAGE_COUNTER_MAX);
+	}
+	rcu_read_unlock();
 }
 
 struct aggregate_control {
@@ -5331,6 +5339,96 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_tier_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	struct memcg_tier_counter *tc;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
+		seq_printf(m, "tier%d.current=%llu\n", tc->tier_id,
+			(u64)page_counter_read(&tc->counter) * PAGE_SIZE);
+		seq_printf(m, "tier%d.high=", tc->tier_id);
+		seq_puts_memcg_tunable(m, READ_ONCE(tc->counter.high));
+		seq_printf(m, "tier%d.max=", tc->tier_id);
+		seq_puts_memcg_tunable(m, READ_ONCE(tc->counter.max));
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+static ssize_t memory_tier_write(struct kernfs_open_file *of,
+	char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	struct memcg_tier_counter *tc;
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	bool drained = false;
+	nodemask_t nodes, *nmp = NULL;
+	unsigned long val;
+	char knob[8], *p;
+	int tier_id, err;
+
+	buf = strstrip(buf);
+	if (sscanf(buf, "tier%d.%7[^=]", &tier_id, knob) != 2)
+		return -EINVAL;
+	if (strcmp(knob, "high") && strcmp(knob, "max"))
+		return -EINVAL;
+	p = strchr(buf, '=');
+	if (!p)
+		return -EINVAL;
+	err = page_counter_memparse(p + 1, "max", &val);
+	if (err)
+		return err;
+
+	rcu_read_lock();
+	tc = memcg_tier_counter_find(memcg, tier_id);
+	rcu_read_unlock();
+	if (!tc)
+		return -ENOENT;
+
+	if (!tier_id_to_nodemask(tier_id, &nodes) && !nodes_empty(nodes))
+		nmp = &nodes;
+
+	if (!strcmp(knob, "high"))
+		page_counter_set_high(&tc->counter, val);
+	else
+		xchg(&tc->counter.max, val);
+
+	if (of->file->f_flags & O_NONBLOCK)
+		return nbytes;
+
+	for (;;) {
+		unsigned long nr_pages = page_counter_read(&tc->counter);
+
+		if (nr_pages <= val)
+			break;
+		if (signal_pending(current))
+			break;
+		if (!drained) {
+			drain_all_tier_stock(memcg);
+			drained = true;
+			continue;
+		}
+		if (reclaim_tier(memcg, nr_pages - val, GFP_KERNEL, nmp))
+			continue;
+		if (nr_retries) {
+			nr_retries--;
+			continue;
+		}
+		if (!strcmp(knob, "max")) {
+			memcg_memory_event(memcg, MEMCG_OOM);
+			if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+				break;
+			cond_resched();
+		} else {
+			break;
+		}
+	}
+
+	return nbytes;
+}
+
 /*
  * Note: don't forget to update the 'samples/cgroup/memcg_event_listener'
  * if any new events become available.
@@ -5500,6 +5598,12 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_max_show,
 		.write = memory_max_write,
 	},
+	{
+		.name = "tier",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_tier_show,
+		.write = memory_tier_write,
+	},
 	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
2.43.0


