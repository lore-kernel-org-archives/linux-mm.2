Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC1CC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324376B0096; Thu, 17 Sep 2026 22:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB7F6B0098; Thu, 17 Sep 2026 22:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212C86B0099; Thu, 17 Sep 2026 22:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00CAB6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:56:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 798ACC04D4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:39 +0000 (UTC)
X-FDA: 85225370118.29.2B0DABD
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F6DEC0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OO22uDOx;
	spf=pass (imf22.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789700197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nu/1Qn5aMB6eE8agozr5NGLxQFUYPH9tczqIuVOPWg=;
	b=aoIWlvxydv/o+NGvhpuHavq/4pqQMLvmvw6FB/lwIm9hWZwSK5KOOo/jG3otZz+LKnWV9t
	mJgp4ds5l7k53sEm/cI4VJlGLjXXPEgZaxJtUlChr6oqF3e0tDWuL52eNwk55etZsB2Zb+
	0ZVqIWSm1X0uOH5KfOB6LZQ6/akxZBQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OO22uDOx;
	spf=pass (imf22.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789700197;
	b=mC/EdFkjdEo6nUxZwrBTunVk4ViRqjct8V9xZr2Al63NeMHZ/fsjUWMtNwzZl/zklGwQJi
	AjlQBYfDnmSSxP9G5mogPh6CKrnetrxJqmTrug2ErdZqpeiVGKFcqqmAvTtJiIdh5WAkkg
	iP7vi9Hu7b2kcNaeJDkQnmsiCArhb5A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9u6epy2ZAg7e55qO1Fon8xryNFbohlp/e75WuCwRfPs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789700195; v=1; x=1790304995;
 b=OO22uDOxXILEOeYIwRkNS6xATYfJXsM5caSAsWGGGtr5GP/Rp8bZYzpGZs7yzVIn7wHt6lK4
 uNcS5xC2ZU48jsUvVfV9YZgdMFE4qNS3GGm74/9r13mgZ0WiFw9MevCAK/wIZiIvq0gS/cTA0K5
 3f8nh5/PWoIiU61q2og7mbzs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e182d4fe0f507fa4;
	Fri, 18 Sep 2026 02:56:35 +0000
X-Mizu-Trace-ID: e182d4fe0f507fa4
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Fri, 18 Sep 2026 10:56:10 +0800
Subject: [PATCH v2 1/2] mm/hugetlb_cgroup: move per-node usage on cross
 node migration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-for-hugetlb-charge-v2-1-2b6d8c2bdc36@kylinos.cn>
References: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
In-Reply-To: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789700179; l=2631;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=0UZdbc9Ox8ZjROT1qQ4ifIs6d3OxXlfJxcPA9bn5O0g=;
 b=En8vl3OUqwBj0Vz+EXcDxP2ydhp6W543BGUr7oBnxhYZP63azlfAA49Euwx8FD1ItN5ud6Nrc
 aGbYMXI7QnpB0T9B5Tu2kpkD02NR9nbgeegmbkYHlWTj5lj4ymZUe5z
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspam-User: 
X-Stat-Signature: d5mjbwiuid3ixczewgyizwrpxisfwhgj
X-Rspamd-Queue-Id: 2F6DEC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789700196-664605
X-HE-Meta: U2FsdGVkX19RlMvI78hjRTSqXC22Krck5WkJMRl+fQO/0MGdAwDPllp2vKs2m7jDeoQQ8lgwOgF3bJeGFCZECzJhDB8caY9Q/7f2Co/OZzP3C2HYZXdJkTpwsHp2P9cp/ekgTagYCiSHa2QLU6Ro/I5TdG300E5l5Anp1DVa8rwoCJyHd+hGwTWIWDMkfzwBGmw0HjkuZ4YM+Cl3/9OrYnXg1IxocFYg0xSjZpJn1dKzGnpscnGyZNkBK7Ilm6/BUed2P4mWiHsP7HgqvLkXAobNBhScG7nWpWh8G5x3k1UAypJR3nDXm+1bjxNjY7DmF88piAVKqxpu1ry6fJA6o6BbPYQJUgmMsLiqEF5ry0Xrb/DMOJuRJxtgLMWE3AtWurs6gEAAfNYosoq7zIA264HdqeZ88gZDJQv4srO8fQHWnlaWw3aHuvfaNUe6b3HeljguuEoDLFyqX/Yuy/jVJK2uMzhPQOsn5S18y52JlJzyozBu5yFSOk65v+C2MRah4CC0gmMXF1xKG0eLyi2sfkifGQcOWvyNqsNLagGGYvXtVIrgbcySeoGuK0nwbLX0uIHPZVyO/JxO3+SLbkyTYVwDtuT9d4pXNY1DzCJCn9eiTEoME7HmxYukEdxAT7/r7pJGFohgY/XiqUglUVZIixuBtgfc5IlXY1Zm6AbgbhcfKNMDa+qqxn7TirdPiaQWT1t38DSOLUgZ9OfhgZL8DQeiobyHcmHfAu/cV+k2ge/IAW5/K3rb5fthsBKkTmru8KPoiKP34zl+1CMLS+qaSnBtU/kKkXPLUKFiaSbAVDJTxpJ+oODK1VRi0A+vZ1el39G7HlqtYmRKCYsd9xiFzKVT2irul86VqIKiMJJJm4Eg5W1s9XSALJ8NTDz0X1Ym6asgKDc2Z8zHBWnrGs81vyg7glKmONmn9SoRf7mLDr6uipi22G8Z4PIzOuBpajhk4/V9K9BmnI1eIpRShTP
 kWRrol5v
 R0YpUfUHYpcTIfdYgDnaeF0X6YyQLZrCCLJM5Qqa0LthANtE73nscyTHPqpBkbOLsNw/UYziGpOf7UFekvoZ/5seUUnIiUSZcMIAvvQ4MHf/eP3AekjkBXndJY0BU8mInEUpYOCyU9vFauRbwU2/PmQ0ZfcMpIpPJiywMRBsuqTo8m/D+ZS4MOOheufcR+kjHNX1ailNMbYMdU29wswG8YMPUIeDPh6O+phxE4BQDzwkdnemPRQzxXG/e/lhuD3nTn1N+rbWP/xAGiZLiF31KnvcBpXDfrzkYGuJR3v4vuZ2AAZ+yP5u8IJF/xyhMbCQ9H9npvdXw67RTP71V8siwBUgOSHew0VVbNYL0q7UckCEvMu4ROUNKKiCb9XsCJX22a15R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

hugetlb.<size>.numa_stat uses folio_nid() to account usage in
__hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio().
hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
per-node usage behind on the source node during cross-node migration.

When the migrated folio gets uncharged, we subtract usage from the
destination node counter. This creates stale usage on the source node
and unsigned long counter underflow on the destination node.
The hugetlb.<size>.numa_stat interface exposes these incorrect per-node
usage values to userspace.

Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
old node to the new node, and call it from hugetlb_cgroup_migrate().

Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb_cgroup.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a..7cf7c18119b4 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
 	hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
 }
 
+static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
+				      struct hugetlb_cgroup *to,
+				      struct folio *from_folio,
+				      struct folio *to_folio)
+{
+	int idx = hstate_index(folio_hstate(from_folio));
+	unsigned long nr_pages = folio_nr_pages(from_folio);
+	int from_nid = folio_nid(from_folio);
+	int to_nid = folio_nid(to_folio);
+	unsigned long usage;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	if (!from || !to)
+		return;
+
+	if (from == to && from_nid == to_nid)
+		return;
+
+	usage = from->nodeinfo[from_nid]->usage[idx];
+	if (WARN_ON_ONCE(usage < nr_pages))
+		return;
+	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - nr_pages);
+
+	usage = to->nodeinfo[to_nid]->usage[idx];
+	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
+}
+
 /*
  * Should be called with hugetlb_lock held.
  * Since we are holding hugetlb_lock, pages cannot get moved from
@@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
+
+	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
+
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 }

-- 
2.54.0


