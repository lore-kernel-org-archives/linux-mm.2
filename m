Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57683D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DB86B00AD; Wed, 14 Jan 2026 06:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC306B00AF; Wed, 14 Jan 2026 06:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21C16B00B0; Wed, 14 Jan 2026 06:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F62C6B00AD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F69A8BB3A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:47 +0000 (UTC)
X-FDA: 84330362214.16.1D24C81
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id BB1DF4000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EGUnEaVZ;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCopSypjYe82peR7lY73wGmY04x1cNXQciUkTwdGqJY=;
	b=j6Mg+xARyT5m3YrkXJaGDbcTPbb7UyEk/DV7/UGW0XUYvl4TME37j+bLMWfwTM5cW2j9Nh
	HZtsq76EAdYpWuS9QKK8JxQy80tGObNq9QmRu/9K3DfHkfNC9ZD+JkRZ9H2UxOS75r83vk
	P04Jk2BChovChI2UADCajjdS0v2Oc3E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EGUnEaVZ;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390485; a=rsa-sha256;
	cv=none;
	b=oqNjTw9KiChmTKVGYuyAg940KKSiHJDhVVj81HzGJexYlTQdXOXKZldxcf6ywJ6vhE3SLQ
	RQu0pVJqs9Bmm8WyEAqaCEvU6iBinypmN3x1YxKjf06mkxqK0EDZYOHQg0upFslU0zfxRE
	BlmsmDCkZXCu+CvLXuhRnkp+kDy8eA4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QCopSypjYe82peR7lY73wGmY04x1cNXQciUkTwdGqJY=;
	b=EGUnEaVZY5ecLmqLWynQvM1889GDtdaiRYfuzcFinAOWYaXuSUoNw9++8ch5q+nFpsNkwv
	TZvM57lPQIOOMPKpVkSNKlF6qt4KGBSImERx5HgN6Ir16WQscR1fE94QGhIY5LdBI0Qb30
	0xvcPfgqOk4+Ey/3r42TnZgFMnvgdh8=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 17/30] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Wed, 14 Jan 2026 19:32:44 +0800
Message-ID: <061b1110696ba51e454ad0f7549603ec92cdb5ea.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 5ya97ij993hmdfb1mbjjfre95xt86hjq
X-Rspamd-Queue-Id: BB1DF4000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768390485-341277
X-HE-Meta: U2FsdGVkX1+FXYgaAIpXPQEkr5g835qRIFPRg4ZsFbvsLaDE1RW4WffF/HtxTgpRqdSVw611iKvBocRxz72ho4+sISAOlG1gEn7v9WKlDA1zCsTDje1iDyNobd8LOwee3CZM6LOQLIJVEKeZTGcuomGhjlqMtuG9b12bwOYIdCXG3MtkXzE5NctxEMuiu4dSeM//SzoCQtW7YsIkKCDybTvvw/FJbf3WuQHdaK2U9KjItYxompmGOqGfh5XpBNKxvLqgKkzqtnv4blDLLRT0WLIQXfM4ZqfogtuGDjKOvrqYvABR5Xtd3I93+dzCCz7jyDsw+04oQXcO0uZ4xnkHFZxtDCGV0OqLJAfatpRYgyK++o8hdDFnU4OYMa9p34Slu7NNZvqcDyWwLKEEXRLn6bK8AavTgwlFGnaJhkzKdTGf+cjH3k/E+1V2ywu4jGA35S/IY18qfBZnM49JMaICi0E5Q+gj2bUX5X3FaDF3+N66/YGb2lazcuNTD6rtNZ7ek9YcglOS9IVyIwKuzzI5gHK8mqPo3svsmsKTZDxc4xF84mgspsemeZ9bWJpzPs7zKgTeRyPjl2T63D0MXccmUb+TpwUL6CJOvewaeS7hapmjOI+NjPolmrarRBziPj/uaAgxXjNBluGallxPk6e1KR3CniNomnYU1Aprncpa1Cs/PaiuUrTSEfykCtrIM2JVvY8UtVmXvX1vR7dLWtkb1/NkgQ1ArBKpQ5/B45iBCVh52yAx4n3NIs+EDlzlZvnAeRgFaMjMr3B53m723VwOPlJ8lnunPYor4DCbK87U0iIIoUw5kuXey2FcoiXDvok4c0jaPRnChmEDsN/r4GvA0OwzdkZwmjjea4vDm3sSAfHwoX6qVQnl2Gl6QfvnlOF59+iiNyGwSRLP8nq6o8tiki1mg4t1G4A9EVZKXyzs56a9uo5O6XeHxPadMkB3aCEENsvf0yX7sB3+xILrNt8
 9pjSo5jc
 +SLeOFCwi1+mcjHKFMKWkwQezZTsaHyQz1NBi2DXXiiT51h4zirT0gvVro3P7Ap7k6USwuSD3Xd36ik4IjW2k/+aJ4HN81iKPxlP39jZvyk1mcY4kY3XGInq7UA5B/Bt3VPWM+e/VhrrFIRcPKHFpCut1texGGylg1acF4pYwQ6Bbh3e5cB+NZ1nC6DLTatA5HEpCv1HWnYnp/EyyDTdkhF85CLCtAREHIi2ruwrI1PZlbBfPe8XOeDuobwJvZSyb1n7sUDvz+vaFlk2sN8Mdl9YZuNIsSQkOZM7Lwt8xN249N2GTewv0gl9mOT/5bOLTYsuk0HdiPJhCCRG8wrAxF6wLrAgo2OvaABZPFB/PzWlPIcsOaJPaIWKyAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 mm/huge_memory.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 99515838faa51..eb611239c1a74 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1154,13 +1154,29 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
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


