Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83E9D3B9AB
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B476B000A; Wed, 10 Dec 2025 20:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4116B0007; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38026B000C; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD6146B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BB4413BAC8
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:24 +0000 (UTC)
X-FDA: 84205497768.16.D6C8DC0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86137120012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765417522; a=rsa-sha256;
	cv=none;
	b=i4wE993Td3Sb4BY3SU+BjGdhBJ9s85g4Y3DRun4Nk1NTDzIdUusmjG7RHVIlYe5dmGedRm
	w7OQz8vrd4bY7O8TO2mFY7X1g455/4TvrAvZpcqf8jiEU1UKjzt8FmiAtCoRQ4qQcPqZW7
	XOhDWRZLv7RUWsiMoDPcWKhAhq26eoM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765417522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34BMZA8gs8ZLWrMrazutP7Uj+MptvOK6WMsUMF92mQQ=;
	b=MQO67Dr9TOyrX93efNeCIZf+FxJB+0kVsRjOlywtqFiN8E9cC9VWd6uqN5ptxfmBL5MdMN
	xOO4661E7IrfjZ0PSMjPTgNAyWrSLtx8pHm4kp+DlhFgwT7xC35TsyHg3LIIvXnVOrfjfi
	jS2MrXOXkRPD1zxo/1UVK5/bYFAjt0g=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dRb4X2xD4zYQtkx
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:45:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6CA261A06DE
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:45:16 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgB3VlAgIjpp39lLBQ--.49534S4;
	Thu, 11 Dec 2025 09:45:16 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Date: Thu, 11 Dec 2025 01:30:19 +0000
Message-Id: <20251211013019.2080004-3-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211013019.2080004-1-chenridong@huaweicloud.com>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB3VlAgIjpp39lLBQ--.49534S4
X-Coremail-Antispam: 1UD129KBjvJXoWxur1kKF4UtrWrZFWUKw18Grg_yoWrCry7pF
	sFy3y3tw4YyrW3WrZIka4UZa4fAw48ta45Jry7Gw1xZ3ZIqw15XFy2yw18XFWUCF9aqFy7
	Za90yr1kC3y2krUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRRCJPDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: doegsjiiywtx5wo4hsurkggrc85rpfoo
X-Rspam-User: 
X-Rspamd-Queue-Id: 86137120012
X-Rspamd-Server: rspam01
X-HE-Tag: 1765417520-968004
X-HE-Meta: U2FsdGVkX19ju95WoIqGwCH2TWgcKJvD2pfkAAKOCP+xArNAHydtcGXZyqUiohTlq6oM6vCJXys/42cp9uNauuCs12wYN3SMXwMrCz/I9OIoImyAfjJK2qwmd2+EJAXa+NGoY2+qU0RYRSMZyFbd1v+dBbSIW2YX0fJfvTewpuqdlKt5AncB3x7lTQ/zm60etgwer+dDkDW7NvOrHvRQJQilI+8PeAlIpDYq2ZfMogPTA0gmFsckXiuBD8Vq4MfvnuNf0SvpT0Pvo2OrOz8i54gXrObxNkoLbSp70tSM3Z0n1hRxNjvRUXmitKfqkkaY3oWvTZYqrCuRQRis5cGCpPMBfOUXkXq7yCguymxit3buvSSxz5/ziGDv6en+T7mCRyDHcRopd6TzZT2IlUOzVeNrA9ddpY08zNtYvAVPuAzb87YiW9JNw9ppi1yGPskKiHD80nZ9br8hWtn57PEcFe6xt0MrJUGVsxguXNPE1zXzZbyExSNSV+DWJNGFMbvls2kBAoqlxjgafCRL1XLq/lcl1LxxxEfE6sw/h6Ol8n2Wt7DuSR5eEzhPvyOVC9j0/dosuOY57s/BqNB/NYGqqpCThH3KvOIFc0zhR/I9JQocTscOxgF41nEQG69cJ2L3dypoVqW/b3OyRXoZMrAvTA5PNp3PLmUoOQ3Ev7xYymvKugsgWf1ZOWdTcgyAJYa4QKhgVN0wZNXbutzOfW+cTs1D49g7WysYIe4JUVUnNdX/SQYWSwiClIC9kUc6THWQJVdFzOeSbI2/9oqWfrdWw/g+BXACv6CIlHJ7mrQ8GkpSJJWowza8PHjO0V7FjgnDR5syxHKNQAKVjWbIqwTtB5cy8VhH05tDE8WAyoGXOjUqomDF+jzcjrxcpfy2jTPlcMISPf3finZnlr9fxCOAs9ys+oGGwDl6WJA4O0LtoAx7E//2m9qZ6jn8AAXTjSzlpRByr9mAEdtXor16pfc
 8xvwm/EX
 bXrS3kx18kVlQDfC6k/0R3egayIJFtDipuZFHEGYRxFSvqr4g5TMZUQMrmB2Qw+oPITIrzTDfuVmSPErB37KQCt0/U9kKCKJNm+9EzbLGcfLVpMgQHwpdhb9jNIoCT+Y2/aPxZdlAOmOGG+H6Vls4CZ+Im8PzhLNH6bDGL7KI5wM0e2wGtAMo6wgSjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The mem_cgroup_size helper is used only in apply_proportional_protection
to read the current memory usage. Its semantics are unclear and
inconsistent with other sites, which directly call page_counter_read for
the same purpose.

Remove this helper and get its usage via mem_cgroup_protection for
clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
to better reflect its meaning.

No functional changes intended.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/memcontrol.h | 18 +++++++-----------
 mm/memcontrol.c            |  5 -----
 mm/vmscan.c                |  9 ++++-----
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a48398a1f4e..603252e3169c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -557,13 +557,15 @@ static inline bool mem_cgroup_disabled(void)
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
-					 unsigned long *low)
+					 unsigned long *low,
+					 unsigned long *usage)
 {
-	*min = *low = 0;
+	*min = *low = *usage = 0;
 
 	if (mem_cgroup_disabled())
 		return;
 
+	*usage = page_counter_read(&memcg->memory);
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
 	 * We are special casing this specific case here because
@@ -919,8 +921,6 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg);
-
 void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
 				struct task_struct *p);
 
@@ -1102,9 +1102,10 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
-					 unsigned long *low)
+					 unsigned long *low,
+					 unsigned long *usage)
 {
-	*min = *low = 0;
+	*min = *low = *usage = 0;
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -1328,11 +1329,6 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
 static inline void
 mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dbe7d8f93072..659ce171b1b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1621,11 +1621,6 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 	return max;
 }
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return page_counter_read(&memcg->memory);
-}
-
 void __memcg_memory_event(struct mem_cgroup *memcg,
 			  enum memcg_memory_event event, bool allow_spinning)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..9a6ee80275fc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2451,9 +2451,9 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
 static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		struct scan_control *sc, unsigned long scan)
 {
-	unsigned long min, low;
+	unsigned long min, low, usage;
 
-	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
+	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low, &usage);
 
 	if (min || low) {
 		/*
@@ -2485,7 +2485,6 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		 * again by how much of the total memory used is under
 		 * hard protection.
 		 */
-		unsigned long cgroup_size = mem_cgroup_size(memcg);
 		unsigned long protection;
 
 		/* memory.low scaling, make sure we retry before OOM */
@@ -2497,9 +2496,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		}
 
 		/* Avoid TOCTOU with earlier protection check */
-		cgroup_size = max(cgroup_size, protection);
+		usage = max(usage, protection);
 
-		scan -= scan * protection / (cgroup_size + 1);
+		scan -= scan * protection / (usage + 1);
 
 		/*
 		 * Minimally target SWAP_CLUSTER_MAX pages to keep
-- 
2.34.1


