Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FF8EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A346B00A6; Wed, 25 Feb 2026 02:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B936B00A8; Wed, 25 Feb 2026 02:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1486D6B00A9; Wed, 25 Feb 2026 02:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 014BC6B00A6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:51:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7598160399
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:16 +0000 (UTC)
X-FDA: 84482208552.30.252273D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A3158000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnqQdkxj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005875; a=rsa-sha256;
	cv=none;
	b=BUJSxDNk9ZfJLgiDwY3Cl3C1f+Bn4kC/yGo3lwsdOFNq6gzI8D0gqJ/QyMx+RxxfXMK38h
	TUXhU2K0NXXSrsTPxuz5bhJrg6N0El1ONDcRcqVc7+gHmHIHGtOmcWlcqt4VMukNitrK2q
	s7YJwK7OELONTVjemkeR+reYjK/SCuE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnqQdkxj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFugfqe6/ZOVEb7BRYdC4hEvLiQEcyW+5o69Lqfswgk=;
	b=QJzA4Jo3Cu08XuL7MXqlxWfhRPVm/yXYztHA3llFC/kQR727w8aRWVFYJIxFquBXMXKQBX
	zFjwQ4Z8p1sxaDPasETVlV2DG2cd7XBfQzCvl1egn026Q61S4syS+GpGnWyLIReGHKN/rE
	kdH8eUKSuFxmUgjpg4mvidhEOb29wFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFugfqe6/ZOVEb7BRYdC4hEvLiQEcyW+5o69Lqfswgk=;
	b=YnqQdkxjJbx1HzdwiQPOBZhqi2P1B4b2zXofX9tiSXRbhKT9I1/WPJy/OUavIlU+LGKZm8
	aICEhysMrnj0hqLpt+QiHOtPnJdAQBbYD4AnTpf3XUfccibxw2WJgi5UicTv8TTbtPtjv/
	mJtq1WEfhDHT78dursyOZX0mlHOSaNw=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 11/32] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Wed, 25 Feb 2026 15:48:44 +0800
Message-ID: <dea6aa0389367f7fd6b715c8837a2cf7506bd889.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A3158000A
X-Stat-Signature: ncfgprj7c5fz9yfdfapokz69cahow85t
X-HE-Tag: 1772005874-762631
X-HE-Meta: U2FsdGVkX1+MswdBrqaY9xvdlWmF6A8DmeONvBM6rN4V8uYP2jF4CohLDLwgnzORvn6tlgH+E6E3TR3+6KLLWm1VQ6ehy48aISCGF6Qh876xtJqtQuxi9t3qrI8u+ijZFcty6aWjJtRWkWqQU/W+cYVPuonZ8IuMy9yZc8ZvjyjaPUdc0W2S82wNdhqCUbGz+oWugpeR1fVG+ECu5vCtzJ968O7i3m9gbhp/5fKLkvNPnh4+4Tk4zqjtnohzFvepQM1RzL1TcHUtmVB3jv2emJM7/mFkQ6rTyML/gr3eeO/YbbiXtLjLYVcsNHD9nWxyu1xNSRPRLOPUdORLF0hHwt4wqXYl7n1bcleeJvGjzXFFIp7BBNixGLCzDwzcW7s6FZK1jlaJfo4xwcutikLpYGgtMeaVAcTSL+KR8AmXNBSw8pbvXjU0I07b08ypbymPYqFWye5+4/OCwAn7mGF/VVs25mgyuQk4qeQ90zS/Vh5kvKBzwX02+vLXu/DmoJ07NCARyukmny1yyF5SercBMgK3GaQcDLjtB2pzZ8yUG/B2pyn4y0iHB0CsVG1rx2SYCd3w6GutGKWFMBzH1t9UU1+G6jUDOejS14pcfW/Ss3CG8X5GNCdJhS/p+3mgHXvuzNTan7m5Zc8KhQ4YtYFEkr73b7uXu1XGbMU+VCOXfIVRqCwBJ0gAjWytDNSc/9oouKCFNtGN5V5QFbvYNdiMihW81+rmgXcn1USLpASBygykIsIiaFcQ3eKvgZ23T5lQp7QMTabkbcsWbfIJO/eC5EhZnpYJRRRGTk7VxER22FiDb6VzQ+mxOQjkNecbOMN1/PwmnGie+3BAWxuj6HfhUGgSTLB6KTM2fP4riyY0VTbWLkNnebHisItvkmcf1IDHa01iNoKbtuZu6lmXA4xJPFqFdY+jKkOHnRDMHZRqkemm74OtoNi6l2uLAEur64v7S/wTps3cxkcngPewtkv
 IZuw0mok
 AWbdsp0AvEnpeQ+ZT0HxnptotD5COgt1JQRJqfIV+LfiWv8TdS4gvGuJg3b/apfbXPePJ37oYNRqUZZoqg4D1jq+ilblrSgzDoysyGLbW68SDhyvk46qyYKGMK8oTzhedbgMhTvcLgUr8FVJoWD/+6NMxwscg+3fPHOZR99lRKgpAYE6ZHZmkj5NNMzd2SFEbn3C2LnhzxXkHQ/u1WMcL3+v70duHxiF1eknusRxtnxJ/iNkspfhyDvgG5Zdwkjao3O1RJdt/S3m8vePF2ihc56eO6qGqfsavGorTRSCmSR3WoQAIc85vm4hYEjN/9fMgc6CmnkIRlBoYgcXWLZrEKEIRDVzlW85gwXH1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in count_memcg_folio_events().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 20d38262b984b..0fdfb8044458e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -976,10 +976,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (memcg)
-		count_memcg_events(memcg, idx, nr);
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
-- 
2.20.1


