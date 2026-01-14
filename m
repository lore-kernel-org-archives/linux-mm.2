Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5268BD29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB00F6B00B7; Wed, 14 Jan 2026 06:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29346B00B9; Wed, 14 Jan 2026 06:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48DE6B00BA; Wed, 14 Jan 2026 06:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9257D6B00B7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6043D13B117
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:20 +0000 (UTC)
X-FDA: 84330363600.28.6797D73
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DA4AA0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCBEdXVl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390518; a=rsa-sha256;
	cv=none;
	b=2lH+dcIyNs0GomVh5i4vJoMABcMwf9tYUnrdxkNXDKQOKbA1F7xt0OG8I+Wmp0tNBldnvJ
	YVaawxtm0Nugojna7QFSZxsd3MvpksJSaoboAzY/k5bsByyR16dZ8VcLbNcs03R4JMzVcu
	3Z0pOGxCewECEJknRD4IcTJveIBKWAM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCBEdXVl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=N7eS22aXVYqUZqNDZGtuDyTUi+iDu7aHgfUKGCiEHE93G3JH737C6KZ6iN3MKBGoEWu2sy
	kM1vU44m6RUEEXW+H73Gk7rOxpjW9G3d1ETDSFGP1Mhw7JvAYv6C/jHK83+Muk6XH6Ns6D
	Mu3jl5l7Zv/p4fvO0tpC10ZXjDZfXAE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=BCBEdXVlLqQkp46ysfV3oumStNfgTGk2xCFjGUXhfJr7hPbVLCfcUx0ooPvCE079FQEBjQ
	d5mYDx4hvC/B5S3BE7Mg7thsNh3e5eQYUgGmRZoJLaOS3ACuXv15yRP/EIq9etX+UZWwQN
	ilKNF2+Mnh/m0rfu7RNltXiX2KqJc8o=
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
Subject: [PATCH v3 21/30] mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Wed, 14 Jan 2026 19:32:48 +0800
Message-ID: <80e4240d06e51ec90245accbe7bd038994a35dbd.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9DA4AA0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 8d4w8b7h3ab3e8ttzzpfr7tg41ixxpkh
X-Rspam-User: 
X-HE-Tag: 1768390518-123187
X-HE-Meta: U2FsdGVkX1/bXonoQ+gz/w0UhBbyNr08n4OAdUDnC+8SNktUcQaxULfonXZmm8D+/mBGEqnvrGvZmDFjtYzL1fWEZlSPD+n741+JfZwhpEC/8O+glyZJ6qtUu2qDo7H5KrmxojORZ17jajgG0Rtzv9h71X93P+s685lOpl+Q4O4IeVGbSoEs0ZjfUuyeSJ44Ook72jhHYpK8fJ/SWTc9ICBcdLrYzjcDpPAf1xTPh4HcEWGAU/FE6NEw3/+LqKRAnw06wqiPRaQvVSgYD++OEw/FJLKsPG4JjKqdxwTfCQuZnA1jzAdvvtbac/kYvc7jsonzH26X6bIhS/UFKqDJNT0vQiSLX9UJE7yCSETrLqfmqA0EG1eXsoV/QUZTVRTWFYaISuumX8bpkOPjRL2f/ToOk1jBJ92nL/hm0JNJIBfo+YkRkkQMVQLX/cKwczu7aoIYz6zXsFKXhU4wwe1kQjrLoAzTwVzIFoM8Zxzs7danjjqWTRot2n9xeN1zcT9E2qjiiUn39JGZutnswK4ZBvFktCqgZ3WjILWrbgeBs9jjvOckk8acFDFx9RuGVqbYvK0+SlK+9J99RgtN0N4HGZdewVCFrbY5kRYJdrDYGUgEvSwspIBfVFNuSvRqlYMtKULVq7AZVW5IdW9cW/HNSwjU3FLZL9TOSecHsw4QL1Xiw+Y6FavLXTa+YuNZiFLXVHefABmcJfTh662hXGsUh0x+YbCee2DBeJKLacP0afZQ3FEl4+ghUUinifUUlsULnicEj9FMuMnQ75JpHhVBloz9LSjCd+ReAqz/PR7IjJ7Kvcc1D5CfkUU/eifXLj7n/iByzZJfE1tWHjXRFFz+l1Xl509VFDTgHAoW1xFuLjW3vo3iompbxfpBkxKjDCwoo/UuaU+/oKE6HUmfki7uSRe1rmmk3WE8IbQpPE2ct4SDT+tMBHnTmvvawtKmyrRhfBqSmslwcYs5gmKIqEd
 1xkIDHYi
 xywZyvMOr6Af8LHVkRfzXOS7WuQ5/fP+sn9GffO1/tWpWAJ9HqLI8bN+F2AWX3n/MCEpzDAOZwnsum133eSFPnf6KjRTgWsM6WYtD1ERFrn2GYqBHBJoVt9opI0EhZZdAMZRnKynf6NRx96GGHdj9ml/7KPjb36bQ/SsJfDZX2Oyy6uPV6q4wCI+PklJGKP+ABTSJq60UiShLQt6TzsHmo0y9sbBzK/9Gx6b+BSyDldn38JUcAyK1gd4NAhssLW8bQ1Z41iziEsUiiuy2fxLY7YWiyPaPWS3V19X+morfGlZteJwhM3rGw9kGgteJqITy4Y7I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
against the release of the lruvec in lru_gen_clear_refs().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 245ba159e01d7..cb1148a92d8ec 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct folio *folio)
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
-- 
2.20.1


