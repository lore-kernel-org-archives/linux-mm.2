Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4E7CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3216B00B0; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3998C6B00AF; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECF56B00AE; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014376B00AF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2E0E1A02C2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
X-FDA: 84720079122.16.AE5C5F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B9A324000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrFpadVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=XyBQCEgtVoczX0gLl8FkiseGGFkOwlJqLSzqr382536SxserBpw161G8KUaZLyf4xuYEIW
	DEpr72GRlC12lPJZbgYxItIDZ6vw5rUuAb/KHK+AHBman7mAL42S2yzHzlWhK+IdTjIfxA
	b2yGmyj9Jzx3OoZk1MwIZi0v9G4EWIY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrFpadVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gg/OKiAenqdd2qZPa1n6URa6257F2mnwSH9SEDNXIQg=;
	b=6nJUZsBpczQkbPhH5FYcG6omlDR8aD/P06gomsQmkBWmIqmWDLpcsPFr6945m5RHMJhH/h
	ATm6Td2khKD8fn9SAMXWaW/wMhJzK8wPzP1FrtgF8f6GOpo+OrpqJpvtHajfD0O2k/8IkB
	lViKo+/roHP9dPVBhuTamvTEJb/FUFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12EC844766;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E63E3C2BCC9;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=rfg28QEetQjYOVfW5ELG9kC4fyTzABEeHPgECsGTHdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XrFpadVAjcYnMwMtQRC5h0OL5Xfhb3B6UTtFDiLq4FAa/+XxUZgn9DCTjiSSp30Jz
	 bWeoEu2HA71j9lgN/W7GYzpXvOk6qfLO25ACzmrRIlxzXo2soQUAWlShbjC7+Hm1x9
	 bJ/JjCUkoNDad+klBWvDBU4BD24pv9mr3Zhz7254cReN+m+w8NlHLb3rzP2ZcqoI4S
	 CXeam9HWUDjKYffswf1x1LJhhw6aup1A8rsUSkDqxIWXfM+RvD/jHz2RjGSMewUvmv
	 iLjISaDHYckoZoOFgMJZUdWkgrduIdve8FkpSR0v9Nwh0LTgg8wMb71O7A7t+v2cTD
	 JRc3jNxbokDHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AFBCD3423;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:10 +0800
Subject: [PATCH RFC 24/32] mm/workingset: use a single atomic operation for
 read and age
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-24-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=2020;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=wgOBUng+uTQYm5twq6Yy1hA/jkGiMMQo7dEmYz74ui0=;
 b=ir6e0a5kqtAwGqvbIavgrfnZJL15MwneqaCVg2lgFlnO9FBbjWzjQcm7j0Nc4ykvHkerskNIx
 VRDLrU4BOj7CxHp3RBUP3d15PVMDXtxI4aCutuGdbgjQxeqMnPjkN6q
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: n6ut6qnjdifrkkr7bx36qs9fbcr78ygp
X-Rspam-User: 
X-Rspamd-Queue-Id: B9A324000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777669459-662952
X-HE-Meta: U2FsdGVkX18TCe4Mj3Z7gpU7Ai5X09OnRIiTWrSa4PjqpSXVR2e4ygQmr7rjI5S2TCI/bAshyIqnsJo5H/x2IUGUvoz67YCZxrBIyTsZ0sYf452FCLO9BviKUXP/4z444CmaG7LoeWN2Z8kr+1kaQvOw41WCXohqHzN27Q5XNWwVZu8nRRODjh30Ah7w9QtG62PrHupSrNc4PuI+A4xoIPe0EraAk8NE4tGC4zTIfwel81wOy0agEYZ7p79L44YfwFLnFVMz14Jvz7WQZUJET2qMZ9Ewm+LzMvvT7CQdVAhTt98Ck+63vDuk5Try12b380K6xaI2h1o74j/KtzgMNuchJseb8YnDObaFGCdrCzTSSI34xT4MVv1nk56i8nWLZGSJSXQ2hQJzarvMjkJ5kcZZXIqLhLHdbBVZQGGOza55TrqJlFffh+VW9nT/a/CkkW1XPUSUobX1WTArbPjs1sKKoXoPKQgB1lhDE05js9Todys9X6RLG8S8JS1Ga/8asxeRTIoS9t8ecwz7eGuXnyEVPM/VTVq48zxcBu6bSOlR1nCqzu+/qks232KVFhLcgYpTW3+yH40B3uDUwCh6IX8nN91YqCPXd4r186W0xJb0SYZNxG5ZAAP+P+L+K1IbIaF9fMJv0PqZeeE17QN2ogdnFU3M55TtNZ1nL3Ciw8ynKf/3FW3qN9GW6Nz1LVnHKDLNRA8OL0/dJUs1iBVI4BNQG6TcnAlhJWdmpU2Rge+Nrdy11vm5XSyXoYpy8gItLuvKuGEC1G4y22GsVPMQn4UF+LhgU9oNpqyoVyN0uxz3ZAIociTs9fV8W2q2IRMeDXvQG4v77F0SRpd3pFz8Ve9G8ojBWYdS/gSx8cwMWchkf4LUC5Rh4NZgmhAy3vgE/Xab5sE+YZAd/KtFvjnBNDpp2reOvPLkd+JYbvysa6ZhvZGQ1SlHRyL4mT7pF+CwinYjvTrIys/n3MhYn+o
 g9484KIz
 Dz4qwpVyT7+FP+p10+hqNR6Y2Z/JeLnQiViCCoen2EzXq/4agaaIQkUarJYYduBLdCYu5MSiBr84Di/SFzNvVs0oSyTtGBfnmN1AXOsaRQkGoVzoXElJa4q1oGfgyQ6SdijK+/OuiIUFJKIK4iDhneDKyJ4XZ3TMQaTtS66Ziz4CierjOzgwKqwAc9WBIH5hLUnBvo8j/vosuayUcMFrMH7gKtrn6GWYRtnpwjOvn9HgGS2/qU8A8jZkznAj9CjAzVPF45lg3RvvuRfku9tltfmXtJQ27qqWQIO/Ty+sUB2XUgUbJy7SZpbVTHsGw3S6XFMY8arn9+TKFSkpXaVtKLXSfvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

One single atomic operation should be faster than two for most archs,
and be more accurate.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index aac68cecdfbf..a77a6c0c3e15 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -369,8 +369,10 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
  * to the in-memory dimensions. This function allows reclaim and LRU
  * operations to drive the non-resident aging along in parallel.
  */
-static void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
+static long workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
 {
+	unsigned long eviction;
+
 	/*
 	 * Reclaiming a cgroup means reclaiming all its children in a
 	 * round-robin fashion. That means that each cgroup has an LRU
@@ -382,9 +384,10 @@ static void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_p
 	 * the virtual inactive lists of all its parents, including
 	 * the root cgroup's, age as well.
 	 */
-	do {
+	eviction = atomic_long_fetch_add_relaxed(nr_pages, &lruvec->evictions);
+	while ((lruvec = parent_lruvec(lruvec)))
 		atomic_long_add(nr_pages, &lruvec->evictions);
-	} while ((lruvec = parent_lruvec(lruvec)));
+	return eviction;
 }
 
 /**
@@ -414,9 +417,8 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
-	eviction = atomic_long_read(&lruvec->evictions);
+	eviction = workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	eviction >>= bucket_order[file];
-	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
 			   folio_is_workingset(folio), file);
 }

-- 
2.54.0



