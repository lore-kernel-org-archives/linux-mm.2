Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD54F606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=XXbSx7eL
Received: by kanga.kvack.org (Postfix)
	id D67356B097D; Wed, 28 Oct 2026 00:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DFF6B097F; Wed, 28 Oct 2026 00:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BAC6B0980; Wed, 28 Oct 2026 00:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A46846B097D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3683880BB3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:53 +0000 (UTC)
X-FDA: 85370719266.28.732B044
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AC7640003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XXbSx7eL;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KU/0A4X+KAaLkdtLWi9oM8/JR72sv7pM4/duoNwVWJs=;
	b=s54p8TtKzHh8/NnPtRyfaR2s6bE13v5jlSkXAGyQ/GqpMZ0lYfxWrVGo2WRoHNCdXNsPWf
	6gINgkA/1T55z8ubhpY6GiLCcU8R8JOvjVK47wNhlaODEMUeODwDTMEbkDAossv2z7vd2Y
	is4gIUBayn2XKt0E11fRQ6FwUbfHt88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160891;
	b=8qG6Rrnex15agB7Qdf2po5oZHE3vQW6PZ3ZzhN62XtMEhcZeb0JKYPXVyelNUxw3Crb4QE
	iEyS2R1xzm4aX4N6HHW66lyXXWuYhhWTk/LvWPhHj0IIL5jrnVfEdvMTlSlzFtf3wLfuj3
	BzemEsuiU2GoyumSrOuozb0QzuPItn4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XXbSx7eL;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793160879; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KU/0A4X+KAaLkdtLWi9oM8/JR72sv7pM4/duoNwVWJs=;
 b=XXbSx7eLYDocUKAVPFz96s7iHNCtBWnzh5RGvprfSAOtgjov7vGLJCeY6lstCUgdhf9RUH
 p0EBvrsDdCnfzPCQoKbN2L5OOZXYaBIf6mTEZwwtvbpyJphS2DQXBI5+sywEacaZSecLTn
 gkVdy8J/6emXRZDD9z+mlZwOfTE0I9qe6ASup2D1zAoS8lyLJT/XxZXDEzJEbd5RoJnu+0
 qhvFNc1j+ots3oaJVxsx3AXzOk5Tv2A2yCRCrQHTYIJtccSiABF+lAfpgFdUOzFVpMaPWa
 S9o5kw6b+iPc4XuswspbS+mLqs97xS/t6yJqEROXs7t8VHedytes2hJb8uD5Zg==
Message-Id: <20261028041253.74839-3-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae176ad+6dfaf8+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 12:12:52 +0800
Subject: [PATCH v2 2/3] sched/numa: do not feed tiering promotions into task placement stats
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20261028041253.74839-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AC7640003
X-Stat-Signature: bmzibu56zq5trmaqs96furtb4p419nfn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793160889-914
X-HE-Meta: U2FsdGVkX19KTbQbOcUaVXn1C8+mIKCT6cZa9kWpE6MHrce/c7dInyLUKou/tXZnJXeaaGQaFN6MBgg2ahsN5gDAiUzuBitpExk5D+Un4Yt6MhejW3dZXESN3hJ9eurP0ylZdXOTRNcIxWCKz5w6jvxia+5UNO4038iEmI1jJ0nBWvDNDnF+lFIa5ZXXnQXXRj0xfAHLpc/EAKLusxekgg5MTv4DProBrJ7nivO4nkfPmihUW72/1ZgTv8R5chQGdkIuGmVSTobO6TNoEO0NkOxqVtHIwnn2aDiPRNbkNOEni5z/98wNVLA9hypb0bgXduA8IplDCr8suGI+PN/Hysjt2KSw0lB/UnUD3gswN9dF5L+6dMTpemZA5Bl3iYctbNvw5z5TpRW1Rs/mHykRTsFLRcqVDNnD2CCVHnvIa1LF5eXkc2psTRpdwXzeXl+G954aKv1qQHj+HI+N/1j8oeEpqk+R2E16eZJmT1+fGvt4A/DzGeqxPjqfBx5p2jucWkdHuVbxQsZLyB/1GkfWG8bKtMIHWdTM/3p93R75JuNeqS1sTSTpnne5GZ8x5FyGwCQ9BPdML5LDJHdQj/eiav3ZvcVmdeTAiXE/cdawizTvCrU9465ckfPcghdD1kaiBD+NkYNF9GIUCTcsR/En3oRYhgR06e/3eXGvUkFSSW87GSQ7iUzvVWowh1Ed/gudsWWwapOVJNnyM49nAZRK4dOVINxfBR/LYxMuJ/OHnBeQoWOFkh/8DG2OOxO7WYHYjaNILvGxGnW+XtSOrUwA8OYTqas8TxuR6HWrAyiMz9B5DB5vfG1SLwwv9X8Ij07i62UK76fp/2ZNyOkErIFWCOO4BvHbXBR/05CYbRqWFr+GDYqagY29ThzF/on2XUTEyqvAP9HcCnG+H1vz88Zn404BunRyVF9mkVt8736rnyhH/DA1MuxNgMgq+xzs7bpo7yT/oUeGzSfLCmHE4wl
 VYatI74E
 nSsnM5XBXJ3lFc32d9XTtx4CT94JRWSnGJxK0yo42Oh0GPPZde8C6a5SXMcjARMBeaXmOiiVtWjNfZCg0f2jdhwSY8C80pbL2JhzeLWMHL2MGH/DK3pc8l/+121QvY1thtjiQMn7+rXmA7GcDDPbin7tqe3zToh5UQkGg7bF0F8TuAvR9m/AgLn4U2rrnTNjSXD4lFJcVoT4pyjWCFZsOmJtY0SnSQMUQreBXz3qeqdj3DPrlRE694jVmo8mVZnK+6A3gvCiL2O3OCx247OoNRyT6Z8g4LuelrwwQ4B+rqXZDsm5TRfM1CWcoPSQ+FGlWcp1dFObkAD84h44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NUMA balancing has separate mode bits for normal task placement and
memory tiering. In memory-tiering-only mode, NUMA hinting faults on
slow-tier pages are used to detect hot pages and promote them to a top
tier. They are not normal task-placement faults.

For slow-tier folios, memory tiering reuses the folio last-cpupid field
to store access-time metadata. numa_migrate_check() therefore cannot
return a real cpupid for those faults. Before this change, it returned the
same all-ones last_cpupid value that normal AutoNUMA uses for a first or
unknown access.

That can make a memory-tiering-only promotion look like an ordinary first
private AutoNUMA fault. After a successful promotion, do_numa_page()
reports the target top-tier node to task_numa_fault(), so the existing
slow-node skip no longer applies. task_numa_fault() then accounts the
fault in p->numa_faults and p->numa_faults_locality, and
task_numa_placement() can consume that sample to update normal task
placement state even though normal NUMA balancing is disabled. In other
words, hot-page promotion feedback can leak into the CPU placement
heuristic.

Mark faults that carried access-time metadata with TNF_ACCESS_TIME. If
normal NUMA balancing is disabled, keep the migrated-page accounting but
skip normal task-placement accounting for those faults.

When normal NUMA balancing and memory tiering are both enabled, promoted
pages can still feed task placement. In that mode, the user has enabled
both CPU placement feedback and tiering promotion, so a promoted top-tier
fault is treated as an ordinary unset-cpupid AutoNUMA fault.

This does not change whether a page is promoted. It only prevents
memory-tiering-only promotion faults from being consumed by the normal
AutoNUMA placement heuristic.

Using a fault flag avoids reserving an in-band value from the cpupid
namespace, where any masked value may also be produced by a real CPU/PID
pair.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/sched/numa_balancing.h |  1 +
 kernel/sched/fair.c                  | 13 +++++++++++++
 mm/memory.c                          |  6 ++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..200f50075d5c 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -14,6 +14,7 @@
 #define TNF_SHARED	0x04
 #define TNF_FAULT_LOCAL	0x08
 #define TNF_MIGRATE_FAIL 0x10
+#define TNF_ACCESS_TIME	0x20
 
 enum numa_vmaskip_reason {
 	NUMAB_SKIP_UNSUITABLE,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 46a11f5ddafb..136207b62d87 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4149,6 +4149,19 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
+	/*
+	 * Slow-tier pages use last_cpupid as access-time metadata instead of
+	 * a real cpupid. Do not feed these faults into normal task placement
+	 * when normal NUMA balancing is disabled.
+	 */
+	if (flags & TNF_ACCESS_TIME) {
+		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)) {
+			if (migrated)
+				p->numa_pages_migrated += pages;
+			return;
+		}
+	}
+
 	/*
 	 * NUMA faults statistics are unnecessary for the slow memory
 	 * node for memory tiering mode.
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd6..00b171e2fe23 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6241,10 +6241,12 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (folio_use_access_time(folio))
+	if (folio_use_access_time(folio)) {
+		*flags |= TNF_ACCESS_TIME;
 		*last_cpupid = (-1 & LAST_CPUPID_MASK);
-	else
+	} else {
 		*last_cpupid = folio_last_cpupid(folio);
+	}
 
 	/* Record the current PID accessing VMA */
 	vma_set_access_pid_bit(vma);
-- 
2.20.1

