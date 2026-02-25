Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E8CEFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D034E6B00B5; Wed, 25 Feb 2026 02:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC44C6B00B7; Wed, 25 Feb 2026 02:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3E06B00B8; Wed, 25 Feb 2026 02:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A74856B00B5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F288160399
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:40 +0000 (UTC)
X-FDA: 84482217120.04.CC91BDA
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8462C000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIZR0Qm6;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ai/SdLNl7tLi9uYAWt04inUE82NVSwYAydx9AFMCLgs=;
	b=mZ/bi8R/JQ+WZrr+GidcAj9qanmqyMImkHRJbrEQgs7S+Y23qIZej4T+dLc4Vu4LLnzZS0
	cDXvGSh23zrJ13xia57ZVTQHx1YBlm3jaxVeX5XfxdHoMNgpZe/TeLBuNZOyqFP/32ED1h
	X2TsyOrtBPXrSjlyo47bbt2+LA+30u0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIZR0Qm6;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006078; a=rsa-sha256;
	cv=none;
	b=6ZvDs1geIHzDlWlfcorOtDV6xNu6t3ieBOXhkj3KKwS38TN/T7MTmfW1r7pUKyA54tPE6f
	IPodcAMltobGyqg1SQRAciityIIJjpzBOJ/vIcQghH+rkcO6RN7rAgT9Lmg/delCU/+rMV
	lMcrpOUfk/uekQaRXfjaqVHy0Z2jI7A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ai/SdLNl7tLi9uYAWt04inUE82NVSwYAydx9AFMCLgs=;
	b=FIZR0Qm6YsSN2bu+kckrpQ3wMkRnx5m8rMnPbZ0u/yPdaJZS/plcMwHKY0/yuQiRSTnI26
	v1IUp1pu9lbGYmtwTTAUwyTBfLrEFeLngzNrzcj6ltsC2MNiAGC9erc18yrZDVmvepotcJ
	1KNooDChqwnGs3TJ6DD3JQhD5ELe9lM=
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
Subject: [PATCH v5 19/32] mm: workingset: prevent lruvec release in workingset_refault()
Date: Wed, 25 Feb 2026 15:53:02 +0800
Message-ID: <e3a8c19a9b18422b43213f6c89c451c5b6ca1577.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B8462C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: fwxzrekdnu51ncpa77smw3m7ak7xadms
X-HE-Tag: 1772006078-122183
X-HE-Meta: U2FsdGVkX1+n38boUDxhvCi+LBc/XUaytWnloLUosPkC7vIk22PLrnX1A7ZsOO87NXHROdHYi1/1pv1IX0OZFrH53/+8x2qzCFx3FIvkzYisRuPyF4Qz68tvEWbXbnFp9Fp0KuO1W4i4cmzRAMnUe5X5zJOVu+RF7h0vX/w6Aw5OTdkVFRuzN5ctlS6DSqqadfo4SoAta0sOZRasxqwo5+InIB9fBV79uDATjA2WoZJlJx1x6yaO2eObKiYUJMVHzeTKTurdld0Oxqt2rG4/frUacmWe7gmzTTvJiTDia8o/6v3vGgzl3uonW/HRSo1iEjwv3cVluiPHzaubTNd9U6DdaFUI+AKgpgVpiEiL+etVQyG65rK7nYqlay90qa0noymaFsEpbc/+ME6kOg2VdsgSEZONAKA5NIp9XHACGaHKX5Yxm/1lpFE5VlgyYQ6fKx9I7rPFCflKPI4Zt5dFuFXAnYgmLL2pasBf9QzzH+8Irhso6JgNnEVW/J9V5TwcJpRkdKBBMEgPNeJ77XyrQAdNhb9ozJBNIwBz9iFfVKdH8biGNLib1cV4s63WpV3rRyJgO8ihQOS9la/cKeqWGkUx3si52VnDht1wunmxHdo4pYa1r0keiWdQsZkzvppVNlI6tenSxddSJoe56/lAK9N0CofiEk0qrdxOPYy/VbLguDZjm9hoQ//Kfgl7ULWT/gL99vF6CKEJfNTYIFob9jl7iKFPXSivvpyk3JBCioitLK1BErev76TsrF/N/tyqDIRvbIT1w9xzHJC1FiME+NJ3dsn5zzIN4O2ctUQ91SNt2SCENz06rLZBACqk95NCwzVW2ZV/twScrlCDq3J3ayejmeGKP9isYKyeJjf4xwA/NnGF/ZEtWqnYsgIwYhzcFs2VFLGG1v4BfDzrrawU1CSax39r+boBOYnw6wJ+UXejlqIqjJ/y5xhyUHeQ6XMOjV1Hdq/heEw7Y6VNvRb
 VPvwCDuX
 jEULJjyJXCopzku1CRzZpf8rDmv9+fJ9zX7xwgkxQbugRefQf9S9WZZ7hURUy3b8Ddax4Fg7kV9MTQxijtjqab/WFBJDnCiEzvubenPk9XhGPARkWopnEMxvidO+MGQx1hCR8PGus2T75v0rTa5r+fJSIjZIIFC3Yjc/9NP7C645f8siNvCN61u4I/duWzXL+t304mL+nOomMgcZSW8XrxVpoM7hm+QltpgA+1loBBGY+VdbDZuQ90eN2g885PAkuZItk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 6971aa163e466..2de2a355f0f86 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -546,6 +546,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -567,11 +568,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	lruvec = folio_lruvec(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -587,6 +589,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	mem_cgroup_put(memcg);
 }
 
 /**
-- 
2.20.1


