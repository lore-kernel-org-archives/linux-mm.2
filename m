Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A66B9EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12BAF6B00AD; Wed, 25 Feb 2026 02:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121B76B00AE; Wed, 25 Feb 2026 02:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C9A6B00AF; Wed, 25 Feb 2026 02:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E47B96B00AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D2F113AA9D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:19 +0000 (UTC)
X-FDA: 84482216238.08.8C18F92
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id E494B80004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Iz0K/Pl5";
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMHHbOrsvMEf7fKsOGegfWk7YRVFbtR0jAiLvTiMweo=;
	b=Of/ui8TxIXxkmpm+vW5njHApIehBHLTo4uB86vXF2A3KTk9bQpUj9qd9hWbTBs6dE6Nh5X
	NuF13v2vxmUxrkxQBZX+zzhLUBwt87mUAl4s+k1bGQ2Vpc2IOC/DHKG8c1UTwM7K0prBKJ
	hrfKBMDQpWGaU+xU8xIcQiVvjY0Pmd8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Iz0K/Pl5";
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006058; a=rsa-sha256;
	cv=none;
	b=gJpg3cTE/E3GOxKk63CpAg9YcONAWZ6f8diW279cDREP61F0DqXf9lzkdF1lXFG1b9oCno
	3YT5CX3UU+ZYI6S56Ybk1Z1G/C1KCXTwgSSxgNcVpkmhZAlek3GtLmA1u6Z9vPFjUtEKiO
	YjKsIZM7YQWWZyGqmSdlWmZ4/zObojk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMHHbOrsvMEf7fKsOGegfWk7YRVFbtR0jAiLvTiMweo=;
	b=Iz0K/Pl5vMwC0NsyCCVJfogSaQiLfa2Kqo2r4y6D39n2JrBCRtGeb4g3B25dqMcQ8p4VAI
	yEGBRf8J8MWYkXBMkr2GlZOUbxqA5d1hZ1j3scz6958pun+31iiVTU8SCsjJBvPkqwBNjB
	Iehk/HeZCy52wb3Jq25kkoruLBDyPqc=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 17/32] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Wed, 25 Feb 2026 15:53:00 +0800
Message-ID: <ca2957c0df1126b2c71b40c738018fd5255525a6.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E494B80004
X-Stat-Signature: ow3oik4mgzdz7eynu15n38rr9d1w3hbf
X-Rspam-User: 
X-HE-Tag: 1772006057-825551
X-HE-Meta: U2FsdGVkX18xLb0ep7Bv71RH1uU6Uel0Bmtavs0DNNkWp/YDS3P7DVOcY9WK7aoLIa3nN+w+6p73k9m2r87FOZ9UR9FWdz19MzeUOXj58goZ3wQb/h7Oxw3WAvmaxektE+6y8ts48bg90TXtDBj3N21heK4khEHZRwarqqq4SADrMnovZik94dyEaduASUDgSOCOraDn464+iaaDDCFd+UpY9ywGwpChslkR5PNhu8/sW/NGtkJY+nCIvJciuNE5EgxF/Cof+QAwwU5j8lUu/GyPrH91G0Ql8r7PV7Mjme3PV5GRqLSNuVwqw/PFPkW0qcL1MfjJphakayhLwiMQy1LQe/av4DFMcdPoqvMeJw5XSY3BDkRyt+UfX3om0iJ/v7ILqrU8Rdh0/94DXNyiMWu0XZV2TqO99BGgqA+h41Oe2yyFao/qYVkuAqWORVkjBKgEzRUgcKasKO67TNpgauI9s1gDn1fJd7vu69jwbYJqd2ZnjIRTkcJb5KFILiLOqFDWXXwVLpcIW9YNOJv10CDZayfBe+UNmGvnMe3nbegX7qGFcKUpB4+jYDEWDiqaCj9GXrNgxkxudDoRDGfJgLMniizwSVuyOX3AMBOsRih+K/dGx/Q6GriYGnkF2jlZd01JXcx8TGakTatDSIeHgybxQ8Ye2yfgENcxQxnLpAwwzxOug6FmF94W7oMxRxKILXoeE8ZPFbWfZIYwoKk/B9JeuQ5Mj1DzkYowaNG6CbpFnRDzFeA3vR+eVaZzJgr+WomMYGR1ViwTn8g3czxoC+Qtpsf6M5aclDM2zpYnOdau4yBVJm3mQwWPcGkM5jhoNXvxH/a4UXe5DE/IahDUijBgAd1CvIiVxssguKp9pFgWrjF4e8fzj2S7gbh8BldoTibrmB9IytL80sn4pZ6ctaTX+qf/zbKThDnrhZggFBY+uwYNNqZqHA4VcPZsaHXQDRJq6NH4rDl2Ve3ygV8
 U6YmZSK4
 qMVJshecTzy2gtS1CEn4u5/9mtKy+1qmtWRsPPEGPg4WxaOv+y4dWiUtMOMVf+k5wPMBn3vxKKSryiz3Hm89Q2/QJOW3WbzPDLyT5tpCfm/eYAENm7DhBLf45wzl1FrrZvTee0IHcVNAMsvy2UKeI1TanWhmEEj+Upks0NmzHHp2NmqkEWbabrbziuyjirF4NPmHC++d+HyqyZ6gPJJ663Qm+F4BIRV8c2KJmBUZHy1+VAuELIjdALwk+YBaJrtzAQypp6z1xwfXTCN/ICm6vmaL0/LNzYpDofbnAdPUMytXz0urrCpDjip2cOQr30vmek23WOQY5ofmK6xtCGtBwbxy7s82XM6+Wp6rFu0rhnp1vT4cOH57O0rCqcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/huge_memory.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f6c0a86055bdc..56db54fa48181 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1157,13 +1157,29 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	/*
+	 * The memcg destruction path is acquiring the split queue lock for
+	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
+	 */
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
-- 
2.20.1


