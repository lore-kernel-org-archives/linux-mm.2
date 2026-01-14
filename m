Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDA3D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113DB6B0089; Wed, 14 Jan 2026 06:33:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7E76B008C; Wed, 14 Jan 2026 06:33:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC2F6B0098; Wed, 14 Jan 2026 06:33:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF5436B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:33:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAF18160473
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:26 +0000 (UTC)
X-FDA: 84330358812.27.A69A4EB
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id E8A5540010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PQYKnHnA;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYKmKzTmoDz+3hblYyrmsVqHSYCX4thxKqFjYci068E=;
	b=0uDyyGuhQPpU6cNMiXM3rwrU0MdDILP8qNYuBPrEKhV9Nal/IrZSrgzeMMvxWxJ9NbGjKL
	bjo1vcXqBuH+zUE6UHruJYnmpOcWujoSTylFHa4CXiyWDFqIWTRt+iJsgJY4IJPeKOlxot
	4NyxQmDrYwTz9p771CDanNVAbjBXUlo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PQYKnHnA;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390405; a=rsa-sha256;
	cv=none;
	b=UnINyyQkakoTEN8amz6Nx8U4rPy8JCBfb6yBq7a/TNE/rT258wYExWhFnHXRuIEdgLobxm
	5GNyjkKgd87kYLMEQj7vJKgDSHCWzTDQDO+3BQqh2e1NmrPsz6c3sPsZBFfRN9ylcLWPq5
	sXo3bddOM8WapandqguSFORNf8Iuzi8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYKmKzTmoDz+3hblYyrmsVqHSYCX4thxKqFjYci068E=;
	b=PQYKnHnA/WXohtXcryy3wCAj7dsUJLBy+6Tqf/8flvNyDOr20PD6qxaTtXxWRo9MQ4FOcl
	WrXlqIg/jPG8B4awfWDFo++s/vr7h/24OIZVjg5p164uKuULgP5+510o0zDWvZHAPo1bzy
	czy9TwQVzj3XPiK3SeV0DSsBhpTqEhQ=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Wed, 14 Jan 2026 19:32:35 +0800
Message-ID: <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E8A5540010
X-Stat-Signature: 44e19gxkko1y3nji9879zn8rjr96m4rs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768390404-522302
X-HE-Meta: U2FsdGVkX18KLkRHUTi4OIg7Y260XQ+l1Nld7GthFEi4i3bJsEPDisZxtrV40xPppxOX3URtJwUrJNv62rRhBW2AeAadGpZ3G3B84Zp0rbSAI1hnTtr622tVdE+D+D9vxwIeqE0JmRhhcJb2DKlhMvQDN5fSJxwSHGcbBEPRyPiLWUnRh9nVAut5WeFW4iWbFpW92d9YVTCwrLE5OELx4N92fSh3XJp3FVjNRUcAS/HHKdVqohGS6rJGJp5lwAjLynKyK1CWbHt/3UyR7FXbXLL1MLmXU1GACIvmIEt7Zp+0TwxKkKmM+CdNv8Ynhk6sbd28iULocKlfkgnLrLw8Rnf4SYLIYufFSrjdx0Z9SmANViFRsdKnOIagpmwR6b+QDtxND4zX5W4Utec/mXL4WU936r0Ft4xbz2Ky13nydOPM5FxInvpJPCyKEO3SVCO0ZOrnjX2GzrFqq5N5lDvcpfddrfEPeL8CUvIa16WDGm5lrkbYMafVm3pGyDa8i3cS9aOj/VCyMpaJwX6DnMVXXS4I+PaSSfgnYI2bI25vjmEtdHYfWVp37INrIoETkuz8B0O3HiSLUluOcwCYOG4IJWfoCHCHNwo9cfudbgbIYGB82e55d8pDo+idqOo/07smUHUn3M5xzQcZUlt70G1KNJhYKOWi5y+Jo5tYvJeKfRkiaEz37eFDs2xtQtCKcoa+0XPfjBwSowW0sFqgyYp5kDlrM7zvfrBPBY+NVefOSDBK8AO7EQsnSAcG5KvH5YTxk1wnLmK/uvRmloGfo23mhceeaZMxVRa+Gq76P3h6PaPGDTiXRVlX8v9DstPrqqamcVLpFZv8d/KNVzzbWCo0WcE/gVBjMspW3YM8mll+nID6ma8nhKTEgP966GoBEuIpAsy4k7l2EgyDKZVYk+W6kiKLr9yWTtfRxF6wA4kSeH2wrCjz0q5nPeWtFNaBdeEsb2FKg4Ixg2PQa0+plWr
 DloTDbwp
 /EyLlUd0p91vKT0uy0f2cnAOvaJDDC90BNZVBQLbLjT5KEL9e4Nw7rxHRvOAzkEN5mkVytFLsXLvzCId2PTf+ZJBw7DrJbT5+ctkVIS677apxSYRQLO3KSQv35GyDfsCCE5KkFifWV3jwubsjpbdlaVw9RH9o24+lo8LimbnkdKdgfE68lLNtRekLhslEFQ4ULLD24tR7PGTSNTPMQE+hrY2vMrsb1dNDWP7AXhar7+qrvNRX83RdVhs/euVhDGU/1ZiD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
against the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 982c9f5cf72cb..0458fc2e810ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -991,14 +991,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+	do {
+		memcg = folio_memcg(folio);
+	} while (unlikely(!css_tryget(&memcg->css)));
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.20.1


