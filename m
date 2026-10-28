Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4255606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=QPVr+U0A
Received: by kanga.kvack.org (Postfix)
	id B69006B0974; Wed, 28 Oct 2026 00:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B456B0978; Wed, 28 Oct 2026 00:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A314F6B0979; Wed, 28 Oct 2026 00:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 833546B0974
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 188F9A88CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:02 +0000 (UTC)
X-FDA: 85370717124.08.08F5235
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3B2C9140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:13:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QPVr+U0A;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160840;
	b=zCezQOJm5DXgeNzEa9wSuuD97t6AGY10ous5UYJUoabGvNlwd0GxUY4L3F96d4G6njWxoO
	Wfio0D+h2L6BgihuqM5GyQ0R1+8WNLJFm1sh8tzIxy8Zk6vCHmqGaPmu4x3ZSyijqyejkT
	eumILaisySv/EpE0UkYYu2OaHGzb/bo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QPVr+U0A;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ufn0FgIJu+3KUWz3Ja9xTt0y5cutm6hq8a8JjEz61Gs=;
	b=wA85NFrc3Q2u0eeOutjTy5uptcX2WL1wd5HR+TneIWgyZoOh1fdSUctX+QrmCCIZxJ9rbK
	U6HtSdsXmuP09P6+jjJI+cJSWGRcbgI0A1MSqxy5UmSOU43fQ8FpCMTdb4TMzoOMciJOdd
	rK3ep+NFz4E91BrrLLZzcb2tzif6iXI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793160831; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Ufn0FgIJu+3KUWz3Ja9xTt0y5cutm6hq8a8JjEz61Gs=;
 b=QPVr+U0ANHSlCCAX8olEc2ciXekwax7Kkr/vj4atUOGWVA+dOWxQGoZuiJxcUyvDthqQq3
 LEup4EKSz9FnUrqUTaTbLR2baaXNbD6AelTh+18wnSvsJjiClny4VIt8UpAOfeaYGIELS9
 RpRfi0iIlGTTle4QzucTwM6ycY1+otCjFiHBt2lQVf+mszioWks+B/m51wNemHM/z6tzvK
 OF/TgbxZGts6KwPU4ywCGe8bN1y0bGC5R8RC3Amslxq8bTjj3HflrMQtf/t4jS2LYH2Kkx
 F0xTER+tNqYR28NjSwXCyj/pcJCXpSdR3HMoClWjq2FqmJACupr/wfBxZcXckQ==
Subject: [PATCH v2 0/3] sched/numa: refine memory tiering promotion heuristics
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 28 Oct 2026 12:12:50 +0800
Message-Id: <20261028041253.74839-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ae1767e+95bbef+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: 37uemj99iaq4i5mguym16c1c1paqbu6f
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B2C9140002
X-Rspam-User: 
X-HE-Tag: 1793160838-867405
X-HE-Meta: U2FsdGVkX1+fp3XYrHGEuAaVQ/q66cqPuUF6vOKh0pzSIw1LvMpuaEHZb4+d0Tmgpik0QFrFJF6IsRBLjV1F3pgeyf+7pydBhiGXW1/KW6sLHwuUY3sljsecrW0/FygGDUe8GelZoSbDeJ8XAPUSiqZ2FlAYoW1wTc6ns0VUhdGRxJlGV0EE8g1c8/E6bUyRGYf7dg4b0gQeq8WDg47dbxi61Bv9DyKht6gvzne1FKgZOvX/7B5NXsUvNHC0ko359Cy/eaJE2TyvReYkRr2w9D7OBpoCFA1Loq5pz6LjMJfsSwF+wfkQOCH8xaLUXeMn9HcM4Rgv+vGy1FLPMLb/iGIYBygQrPWT4ninssFGKoX3PRUJJMKL1AQELJ+73mLHjiQphmovVJcD6eDQQRlAVKzqoCarForNVRazO95UCeOmKqkpoBEo1yuAAbBVX2/pfQp1KsX8wYf+QiaaCBHtP877MSTcTmdI83b/K8eiA+Y6p5A+464XOtjd7UDkFJtP3tVP3ICW38dKuKkYINMo0fLOqeI0t/eAynY7z1YoqZulw3ZYTeVQRW7YCqzknN/NTHaf4xZ7aoryjQ6SKV58DQV2ZiSPGF5RIu6VIvItjLY3YuaetV+CkNMuBWKT1ZIzEVyxf9vRrnDQniKwxD0EI2yiPlinPOZuoxPESW651akCNygTOuGZlvFMIG2Rf/s7TYcCpUU9ExE6HrCqb28mxpeMWiMb+gEfKAorTICoqYP2kIZjcP+UkaDYFdNK7fY0wyAaCSwwANOk3AIsXJc17s1yMnSv2gtQM+y/jYIeKUhPMIxee5ZdE7v0AFxgmm5kmDgSl7VOwEVRYly1wTLFKKH4JV6RV245z5SnFfqsUe9d5KRD7UawUAkg4VPFY8rjJw/gdileeeTX3UgqqUUvTo6cyWdKG3iCJJjf9wOTUNNd/nVviltDlG7h5S+99+Ackz2jbcqwfzaGqPLmtWB
 CQDcJbBI
 P5TDC7xzoMencghvTO/Vy+5UrjMTIK/4LxSswsaqauwDKWFrj6bVDQ+cP7N7V4FpUR7t9o3HKloM5uPCOGlGEhL1KVpGkPc2y5UiAEkF+kAzdmFoA+Rsu1xqUc/zOD1TKIls6XYB8cwJmdnV1kSbefd3xq4sCr7G4PUd3YgrdhEEhR+kKz8J/foWEK26evvctd9kWrISnlnNF9I7tS8aCKakY5nrC6YK8Zgc/lCSVS549d4cpz2lMVwLPUcDYz54/fh0kEBCjh/m0lrTKjyLEGSmGuYIvdjBpBb0daIa1MKpI72L6vratFLJ4P+ONT4o7Q3RpUjsV2pubpV86ioqjUSPXKjR/ns8rTp7cWySufpIWxdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This version narrows the series to memory tiering.  The generic normal
NUMA balancing cleanups and heuristic changes from v1 are not included.

Patch 1 makes the free-space promotion bypass configurable while keeping
the existing eager-promotion behavior as the default.  Disabling the
bypass forces slow-tier promotions through the normal hotness and
rate-limit checks, which helps workloads that intentionally keep part of
their memory on a slow tier avoid short cold bursts refilling the fast
tier.

Patch 2 keeps memory-tiering-only promotion faults out of normal AutoNUMA
task-placement statistics.  Slow-tier NUMA hint faults use the folio
last-cpupid field as access-time metadata, so those faults should not be
interpreted as normal placement feedback.  The patch marks them explicitly
and skips the placement accounting path.

Patch 3 builds on that separation.  Once tiering faults are no longer fed
into task placement stats, tiering-only mode can use tiering-specific
outcomes to tune the scan period: hot feedback speeds scanning up, while
cold, throttled, failed or empty windows slow it down.  This prevents
tiering-only promotion feedback from being handled by the normal placement
heuristic, where repeated promotions can otherwise push the scan period
towards the maximum.

Li Zhe (3):
  sched/numa: make free-space tiering promotion bypass configurable
  sched/numa: do not feed tiering promotions into task placement stats
  sched/numa: fix scan-period adjustment for tiering-only mode

 include/linux/mmzone.h               |   5 +-
 include/linux/sched.h                |  17 ++++
 include/linux/sched/numa_balancing.h |  10 ++
 kernel/sched/debug.c                 |   2 +
 kernel/sched/fair.c                  | 140 +++++++++++++++++++++++++--
 kernel/sched/sched.h                 |   1 +
 mm/memory.c                          |   6 +-
 7 files changed, 168 insertions(+), 13 deletions(-)

---
v1: https://lore.kernel.org/all/20261014094347.99157-1-lizhe.67@bytedance.com/

Changes since v1:
- Dropped the generic normal NUMA balancing patches.
- Added patch 3 to dynamically adjust the scan period in
  memory-tiering-only mode.

-- 
2.20.1

