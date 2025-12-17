Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69F5D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4FC6B0093; Wed, 17 Dec 2025 02:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EFB6B0095; Wed, 17 Dec 2025 02:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C26C6B0096; Wed, 17 Dec 2025 02:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDCD06B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:29:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B84511401D0
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:31 +0000 (UTC)
X-FDA: 84228137742.15.6F06B0F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 30EAFA0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TGrKrdr6;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pE9uf1TLSHkLubOWIgm4VTvwh88IAohI6sYrjRqdOw=;
	b=MqTWVzXEiBxcdwYptOsz9Z6fLiUqe2LjC61DBZQrpri7lAMEuAHDimZWX1hc26rtjq0Vus
	hy3W0E182+zmg/b5N3BSyWEimaWPNt9Uqz1ozwL+JImqh/WiSuWnQUA89BmCeS1WmeVvh3
	NFbOtrv5vkHomXamEH1HFF1EUDBZQ34=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TGrKrdr6;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956570; a=rsa-sha256;
	cv=none;
	b=JlaJwjW3rOQ6YNJVDiyFgVmgkJRR6KCC3JtjGW0hY+vVMiyHim8/a6yVIljZAY1utyJEVq
	KvRONE0uSwDAKuaDAymR76AmMnOx5qyahTrvJg277gw9b3p9d5nDqwpBYNgcBheyd+Mqqg
	SN/N9xb5H2keTtapvXmEUZYFrAGsQ04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2pE9uf1TLSHkLubOWIgm4VTvwh88IAohI6sYrjRqdOw=;
	b=TGrKrdr6WtZDtwmUq5jN9ccsCd7ukQJQBZZNWllJP0uWeb2+ozNTjHjwdyOUg/IzcxmjCl
	VxzTkWLpcvHPtjwoj2edd4HShUUS29/dYCI9/pLEjwSRZvJW2apkUhBi80y2FQbmJCmaGM
	BG4fA/ZZNwOv1UCSh3TzY6hIaNXKIyY=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Wed, 17 Dec 2025 15:27:28 +0800
Message-ID: <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30EAFA0003
X-Stat-Signature: utkh4ni1sn31qc4ycqwoy7q9ibih8gju
X-Rspam-User: 
X-HE-Tag: 1765956569-350406
X-HE-Meta: U2FsdGVkX1/9QlCYE7SiTY6LdrfB4dVOHjfAvm0t8tHlHCu0bGOE525MLcoZ1DdNpMWX2lkVo1daKdmsCxz3y+j8EDSmDlampooxJpy6xaHEeif90uYz7X7xcrNYwHjj65gHLVBMk+WQxJcxSb2TfoA+d8t15pVCpKLo/vE0JZxN348U0Q6hgn0PEjEZCDLq/RfrHBWiU6kKmOyFX3Pgl9ylSWr3puWuaDDNdFQgw06xVvY85ZDW/yWRNRbh0xb/6o95m9cbp5CqRzhEkg0pHn0jyAZgYdgKT60TBOet0Q1E2uAry3k7pfL6prKla81K0s8s7Xb1oa2iKWVjMveL9WjnPwnwyiiybXURwBNd3dQfsJLoTVTP6zIq10KoG2bexvpMwD0WkHXj13AsGdL/AutHFjw0+VpbBojyPFVSCODHykN2htSR/SrrItIC0Qkyv4iDZNTfWP0Feu3HWJNcLaYnBJT7pLLzO1vSjSoRUe42TjUewmpn6p0/lsl2FOi4VyMdf/e734NnfVv5ytSX0hgdIXLIzcYhroe6ZmtqANxlHHid2EJoCId4sM6r43gzezxSsjtE+r10L7+PL0MobJ2bZlOCtYCZ4C3tymLPSFX2t2SFnAuFKBDn6EwIeM87r5WsLRw8xwx+PEHRPYBddO9JKPjs09/kHNdb148E5UEvnRGGRyKAr6yy2ClQq2b8rm4fA32prxAgCNm70UN0lodSl38qrSVeoAKHBz8fKVa2iu2C17nQbSot37OCVal38xvgyHCuo5UcfaylYgxdR9Nm9jvBcbK+P+dHZEVTb0cLgvVIdmURf7U2K7Sxj/cpemrWRU7u5wjc9pdbBUe7tgOb1MELa8iq94G6dto5rXr5vqf1M7YKPgk9VzmKKe+T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

After refactoring the move_folios_to_lru(), its caller no longer needs to
hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
and __mod_node_page_state().

On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
avoid using local_irq_disable() and reduce the critical section of
disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
count_vm_events() and mod_node_page_state().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 28d9b3af47130..49e5661746213 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2021,12 +2021,12 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
+		count_vm_events(item, nr_reclaimed);
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -2171,10 +2171,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
@@ -4751,9 +4751,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
+		count_vm_events(item, reclaimed);
 	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
-- 
2.20.1


