Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 248D5F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905EC6B00A2; Thu,  5 Mar 2026 06:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7436B00A3; Thu,  5 Mar 2026 06:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0266B00A4; Thu,  5 Mar 2026 06:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5F96B00A2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:55:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0293113BD9F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84511854504.18.C2A663C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45F81A0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bFsZqb75;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98HTAgCgFMLsilH4QRkwk8a4UTEYNMYQTWZIQBuXIPY=;
	b=gDNKMwNyZ78KdetEbeOe4h4CjNMhiLFBTuKN/rZSNbrHghTcE6IALaaQQ2LDh/aGuKnB7n
	UZ2PGjlsF4eHF302vqlBmVbo/Lho29kPL/jmxbvBqv5dwL+cw78nGUrpeltXaVqFeQkZNM
	zBPFitE0/BPFlT6bCeMc6mLFeKHPWhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711730; a=rsa-sha256;
	cv=none;
	b=xpKjTIEcvfaQsw7vlZ/PLCotBLmf/AiLaX2SI022Ka/9W8wCBK2f1b7rsRR4vFAA6h77fj
	e7mi3WSecgCZ+KNU6TDL9W6rXf0F5bSRS0ek9esFqhhdNRNEVYtH2yCwgJHQeGW9XMjPr4
	qoSZuzyI6qKzKE8FsgjF1RJKbOzzrBE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bFsZqb75;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98HTAgCgFMLsilH4QRkwk8a4UTEYNMYQTWZIQBuXIPY=;
	b=bFsZqb758HrKaEvWXtIxtvKoTg6QfwJ7pEZJpokSqrrOoLJ8VF9nif4svxs8qpkAxB4Y4Y
	rdw3fUGGmKpmai/wHzf85O2uTtFcrJ4xtujv6IcY2aosqGEHG2UO+xXiTuPGBskTdgfNuW
	7c8/5gvkCqxiALRH8OnLSByUeqCnatU=
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
Subject: [PATCH v6 08/33] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Thu,  5 Mar 2026 19:52:26 +0800
Message-ID: <a5a64c6173a566bd21534606aeaaa9220cb1366d.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45F81A0011
X-Stat-Signature: ug86o4z113dwed41cfbd6y4arda54wi6
X-Rspam-User: 
X-HE-Tag: 1772711730-142409
X-HE-Meta: U2FsdGVkX1//QFLpxznh2hRy6y4g+XpL618VRP9cWkDlCwNrmCe1Zz1/RenZW8/dnvFthMSk64HiT0BkJh3BJxCSOubkZi+IVM/y/+U6O44jP3N+yTncQUArvkLL8k3NTD5uDxZIrmWYMo2iKZKGArlrjv9KayCTdo21Sqn2+jhfK24xOL9/NyotUNE0S4kzeZO9gE1vrM6VZ6ofRIF4cwZ/R1T3ir7AlBqYi4baPPMtfL6pt9C6oFEq2wZp/rrMeqznMxGf4DxcqdmKSMjDABddqqXwqwQwVIvKtBWtwVzlwwq6hYx/8uRlL5t06yYNiCmGXjjtYtAwnbAFaffbnez+Ti27mNSitU0rxEWFDqRiufCwwvN7wGtPiIEh8ocnXg8ysKhGjZ+wWvMQtcF9ZTh1evreFvUz8FbmTsrjngKl4MBVldzCfDRopincRQXg6xXmOSN+Y5iFREewGxC/vbjxLGtVDPVnX0gtnpwk1fWdqDTYYKgMvmOeXVqwvzb4aQKfXIvpI3bTvcoEc6Y9mPQMSV88yxOAOpOP8eGtxpJLRoRwMJn4ydyYwN2I7FVHO5R5Y/IV3OIzDkqQruF67BR867HouLV/e7M1nMXkqGZqAmPds0lPMfiTh5hlONjUO0c0RbOIy76dk62dmAa4kTrZcec6KV9goD0CaOpwm2pXLNGSOchOkpsnloB2jcx3om0yc4f8PcKwrobRWjR0x4+8B7LUZC2eWrlIyD/Ed1lVZHu2SwpgZbCriSseZxnALcwnhpfm8QHNEgw05+DlDnMP9quLPa0C/bs9hGraUuD6mYJwYsgnR23pnNi8ogZPRXD/lN7JCs15UBY5OJvtnEwSNiaEw999ukZ0mjs9bksz3FmkazvO85s+d64XPYHFZAXy4T1kBPstvkP3JjcQneIA/B/ZG6aYielK5PmL+Ny9ejUfiA/4lJvHPbV0ov+b4lNJsEcbaNpxcIVlbwg
 APka4T02
 uHYWozloMgdB0cLSfOi59f/hS3DSVCmn+jpbuvAiQghV4AC8SbFvKkr24P5KzWLgeu5geFhKorBxNMNb0LYaf63BZNpWkw4bGxjox47MtN2l7i1WLJFyVkf9cRrdK5VJPu3i3PDuCRxpBZ0zig8h5Rog0fXUn4xy+JCipJsb3yCsQwXiwkgBh5k2j6aYfXQ8hOfND0jzfiqzMVZykfLlZ/Lrbaj+EiSuPUkxm14IQKbYGQVf3ZwRew5HkkS17StEmwTx0
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a60b692fb75a9..4820919c0d219 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -997,14 +997,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
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


