Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F865CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90ECD6B00D1; Wed, 14 Oct 2026 05:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF836B00D2; Wed, 14 Oct 2026 05:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDB06B00D3; Wed, 14 Oct 2026 05:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60E536B00D1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:46:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02D9DC04A4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:46:47 +0000 (UTC)
X-FDA: 85320752496.07.C6FA249
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB9C580005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:46:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WxmUyVUp;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoGHK2d9o+Gv89lihwm7ZyHMnSAieOGeRDgz9v8xE8U=;
	b=H+pSYA9j+UWeUgXF+Xjgj/Vfi4wWx6JsYklcUXOjYUo1BtEVX3ajzb4gm3tfWUx7mjJDoi
	dwhdATwZQ+SZYD4/XA+iExiqK7SYAXOMviKzdHcWN6q4KWcPGr3hQqJ4vVhO8J5Ab+brHs
	uA6iMgWtJ4qTCvh85qsXqj5HQPTYi/8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WxmUyVUp;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971206;
	b=8WEWynqFAs4Jbm2ittHcS4FlZfcm/l1HZZQerF4Pti2JRosNkx3o8hGLIp6ZMuXGO72k70
	DyjdtPKDCgrEcK18dGW2iB7W0uOOdu5GYa4oemeYiEnKdOaHOmPGmQji5oHHPwayXXBX9Z
	WPAy67FFTc/41bOZ0OUB2M4dTLTgY90=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971198; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EoGHK2d9o+Gv89lihwm7ZyHMnSAieOGeRDgz9v8xE8U=;
 b=WxmUyVUp9f0VkCdRUyFck6O1+gg8N6BM8V54dce6x2J51ylLnREcTHnbg8xoTTh8WX7ule
 UcDlljtAxYDJe9PZGMjF9/ZvsFUFuCiP7cNzOo4KvW8n+ZbBsHOdEG/87PdCu0TI9g2CdI
 0HC5T6BqjjrLsGNx1lvyd+pnJhrHspzWLKDPAN+8f3kE+KDgaSeg1gR69Q0SzPCi1/8Lml
 i9xXN67sncjoqc17iXhoOMQod+ysi7jn5GxeCr3d0KpGbMIXI16S00Rd45OdqpHMR7nc9b
 oR9sm2Vp/zf8+J+U9fxLoJ+32QCdGvh7Tb3HfXkX5eEAMi5kDh1JtDqdsTuqTQ==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261014094347.99157-6-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26acf4f7c+deb21c+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH 5/6] sched/numa: do not feed tiering promotions into task placement stats
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Oct 2026 17:43:46 +0800
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB9C580005
X-Rspam-User: 
X-Stat-Signature: imncc7wssq46azrnr6xeade1jy3xdna7
X-HE-Tag: 1791971205-986264
X-HE-Meta: U2FsdGVkX19WpGOJiYSH8ULk6gajFkxNkWunqlMNlS1h3rv1ZukNbux52a4Hv+VT0E5XhE9EweHj7v8tg87WVRMRKTcZPnLL6Re6uEWe/VRJJr2rNCJgV1KwcTYe3PYr1sTH3G2ITLHML8g5OpxGW34CY1Wn/Cb9b+fjE/Y7yuVtnoJZxmcj2+2Z0QujlkCHH3nZ6zhwMleXzmiqvsHzeSnwYvWgc+x9QK0CI8+V6Vw3KcaGJ/+eFEJQthkv8xkmlbdRUy9rlJRbHsEIBNl0YT9yRKflCYP9h/1J+VqObt0PB+sXrnBR16zBvgeypN3BvPkjEE/WUrn5uaJCM4J0QcJOfjbfx1bcXCQOunxT0XIzWIGZkFvpD4m7SEBTDqzLxppN/Q0JHFQ37quNZkUGuorUERurhvq/YS0ZqYe/PHAMI8uF7xQKbyhP8qMvGk0SkIRanXUb/NZech2juS/zQlRIB3QF4e7gQvTOxHRC26MT85UCgnTD2v9dnH+Nszu7DJ+07bKsb9xJCt/2irljZJC466zIVRlOnvwEYKsgkJCQe+fZ+2AI4uk1h1tZbFnHVOH0uwpPXjX/LHWztSDWwqwLk1NkCfo8fHs+3izzqEk10o8G8s4aTotYiWPQomu7dybpMoWrUqkA5WWjwo4aNMvGuHKmmoedZUsqlv2/YP0MyWwHKD6tGhEu7gTZoUq0rts6g5jC8oxCSJ3kKk4kxNZ3ppYjySCNakV0UQ22jWwu9fhFKyedIZgL/+3JGQyDxC6BxueqmNK6xPGoRvfqyyQpSTCUKjRnrYKsQ7MeW3e2qPVOchnQs5z6vT7QaAvsUutAKGpOkEo5Gx21oVZNeG6aQYHev+AXfR+VAlcQomz/0uIu4QCvS2uJb4aTLrAREBMzaBU5TvZdRuJJCjL9B74pHpjSeVMHDAzTzjIdG10XK2LqZ1JJQqYRR0Dg1UNCa8Z+lFuWjPCwOG8+twQ
 4hJ1rEn3
 lM8BLv9Zj+wJg75y8nBxaPo4jgNOFUoY3vdHym6zWH5zP9FbPA1u9b19sos+NTQofufweuXil0YejNQnbW4xx/DVytfFuQoOQECFyhm7ddJaFL4IuLkDFk38MgbUKxM0qoNwHP3VeJnLyRvJ751BmCOvSEb1PzxRPXZI4927rzM7JrHcIq2YyhJD10/Dj5vKWxi15YBBgEbCrBW9w5FvHHAT2C+3aSLrT64gITycNOIAW9Xgo068G7spa//Kcx4KZJf63Yn5AqMWDKSObhdS2QaqQ7DJxtE3UqtHw3HdzgFNIxM1DFUsT3qk04nH/lsO8esx1dy9NWpud7Lc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA balancing has separate mode bits for normal task placement and
memory tiering. In memory-tiering-only mode, NUMA hinting faults on
slow-tier pages are used to detect hot pages and promote them to a top
tier. They are not normal task-placement faults.

task_numa_fault() already avoids normal placement accounting for slow-tier
faults while memory tiering is enabled. However, a successful slow-to-fast
promotion can bypass that check. do_numa_page() reports the destination
node to task_numa_fault() after migration, so the fault is seen as a
top-tier fault and can update p->numa_faults, task placement state and
the preferred NUMA node.

Slow-tier PTEs store access-time metadata in the folio last-cpupid field.
Before this change, numa_migrate_check() returned the same all-ones
last_cpupid value for those faults that normal AutoNUMA uses for a first
or unknown access. Those cases are different: the ordinary unset value
means there is no previous CPU/PID sample, while a slow-tier access-time
value means the field does not contain a cpupid at all.

Name the ordinary all-ones sentinel LAST_CPUPID_UNSET and use it for the
normal first/unknown cpupid state. Return a distinct
LAST_CPUPID_ACCESS_TIME value while the folio still carries access-time
metadata. If normal NUMA balancing is disabled, keep the migrated-page
accounting but skip normal task-placement accounting for those faults.

When normal NUMA balancing and memory tiering are both enabled, promoted
pages can still feed task placement. In that mode, the user has enabled
both CPU placement feedback and tiering promotion, so a promoted top-tier
fault is treated as an ordinary unset-cpupid AutoNUMA fault.

A stale access-time value can also survive after memory tiering is
disabled and later reach task_numa_fault() from a top-tier page, where
the slow-tier validation no longer applies. Treat any remaining invalid
last_cpupid as LAST_CPUPID_UNSET before task_numa_group() can decode a
CPU from it.

This does not change whether a page is promoted. It only prevents
memory-tiering-only promotion faults from being consumed by the normal
AutoNUMA placement heuristic.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/mm.h  |  5 ++++-
 kernel/sched/fair.c | 26 +++++++++++++++++++++++++-
 mm/memory.c         |  2 +-
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..bb0c72640152 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2420,6 +2420,9 @@ static inline int folio_nid(const struct folio *folio)
 #define PAGE_ACCESS_TIME_MASK				\
 	(LAST_CPUPID_MASK << PAGE_ACCESS_TIME_BUCKETS)
 
+#define LAST_CPUPID_UNSET		(-1 & LAST_CPUPID_MASK)
+#define LAST_CPUPID_ACCESS_TIME		(-2 & LAST_CPUPID_MASK)
+
 static inline int cpu_pid_to_cpupid(int cpu, int pid)
 {
 	return ((cpu & LAST__CPU_MASK) << LAST__PID_SHIFT) | (pid & LAST__PID_MASK);
@@ -2468,7 +2471,7 @@ static inline int folio_last_cpupid(struct folio *folio)
 }
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
+	page->_last_cpupid = LAST_CPUPID_UNSET;
 }
 #else
 static inline int folio_last_cpupid(struct folio *folio)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2e11107bf5ca..ec08406d1364 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4214,6 +4214,21 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
+	/*
+	 * Slow-tier pages use last_cpupid as access-time metadata instead of
+	 * a real cpupid. Do not feed these faults into normal task placement
+	 * when normal NUMA balancing is disabled.
+	 */
+	if (last_cpupid == LAST_CPUPID_ACCESS_TIME) {
+		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)) {
+			if (migrated)
+				p->numa_pages_migrated += pages;
+			return;
+		}
+
+		last_cpupid = LAST_CPUPID_UNSET;
+	}
+
 	/*
 	 * NUMA faults statistics are unnecessary for the slow memory
 	 * node for memory tiering mode.
@@ -4223,6 +4238,15 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	     !cpupid_valid(last_cpupid)))
 		return;
 
+	/*
+	 * A stale slow-tier access timestamp can survive after memory tiering
+	 * is disabled and later reach here as if it was a cpupid from a
+	 * top-tier page. Treat any non-cpupid value as an ordinary first
+	 * access before task_numa_group() decodes a CPU from it.
+	 */
+	if (unlikely(!cpupid_valid(last_cpupid)))
+		last_cpupid = LAST_CPUPID_UNSET;
+
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults)) {
 		int size = sizeof(*p->numa_faults) *
@@ -4240,7 +4264,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * First accesses are treated as private, otherwise consider accesses
 	 * to be private if the accessing pid has not changed
 	 */
-	if (unlikely(last_cpupid == (-1 & LAST_CPUPID_MASK))) {
+	if (unlikely(last_cpupid == LAST_CPUPID_UNSET)) {
 		priv = 1;
 	} else {
 		priv = cpupid_match_pid(p, last_cpupid);
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..212e9d1d5b64 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6173,7 +6173,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	 * to record page access time.  So use default value.
 	 */
 	if (folio_use_access_time(folio))
-		*last_cpupid = (-1 & LAST_CPUPID_MASK);
+		*last_cpupid = LAST_CPUPID_ACCESS_TIME;
 	else
 		*last_cpupid = folio_last_cpupid(folio);
 
-- 
2.20.1

