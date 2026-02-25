Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7541EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325E76B00B7; Wed, 25 Feb 2026 02:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6B26B00B9; Wed, 25 Feb 2026 02:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226986B00BA; Wed, 25 Feb 2026 02:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11B686B00B7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB0CB1B484C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:51 +0000 (UTC)
X-FDA: 84482217582.08.5F27AEE
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 250F1140003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKr5VQCf;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmuZGex7AAaN+LnMc+A6Q6xc1gQPncq5PZ4nPQh5Rck=;
	b=vdjaVJpSLlE7QsVmWLjKQXdTWFksyynSYwxLQt3BF1Tk2nu5zlXnsuXg9Y6PDoy52Zxz10
	zY17sB8iE3fhIVqcwAO0WizrQmctDErSKSGplliUpRyrNIuS5SK+rWQJRr892dAWRU90x5
	wOJ+CqF8j5mHMzJnv8Y67NYVkbIiQEM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKr5VQCf;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006090; a=rsa-sha256;
	cv=none;
	b=6udr4HfZeewIL4CnFp/AAquAtcnv4GY7F92rANhFGfDXSUwv4IDYfinApSswx/1CY58rJV
	XLxyh4qnJ7cs2SeSu03G2GeLTefhWJMmDWVj5BLcE5tblkkZ5UPJfQ/yWoOOwhZouNIYz6
	6seCH7jsfShBIsS/fng8DOzV5xdpTZ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmuZGex7AAaN+LnMc+A6Q6xc1gQPncq5PZ4nPQh5Rck=;
	b=AKr5VQCfOMaL1r1ZdA2s7uLOtAB8OR8Axeo3vmCI+yCY7ziAHI7E1bCzR0TvXEghCwEAzy
	xQSCeyVrgFkvt1bccbs2MQgNq8ZdyMtfc6nZTm0Uei6T3BUyofhePlqJ+qFqUUBDXY6wMl
	HZIy8o/MPYGURUna2cM/OJU58dkNojs=
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
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 20/32] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Wed, 25 Feb 2026 15:53:03 +0800
Message-ID: <02b3f76ee8d1132f69ac5baaedce38fb82b09a48.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 250F1140003
X-Rspamd-Server: rspam02
X-Stat-Signature: wpggriiagmiatfkby794y984bygpi91p
X-HE-Tag: 1772006089-114604
X-HE-Meta: U2FsdGVkX1+hA5D1zC9MSD3FoivHUPKj/WHH96opGgAHDvZsz6EDdqgifTaOa7wv2Od3/6LwdcXihgead0BwDjmoAt8CrxSMRtFtZfNkYegn8AGaNQE+7SPvIAPeJ8hk0naDzZZetIqaal7vpmIVqg0dGLBzF0KnpM5pjB8yk6Vek8QTJZCQLFUs5h7GOKUkXdeS+iyTd7R4wwWzuqn0jB1u4+YfCTLLyhWvWf6U2QwEGeU2HgT3gplld2Trgpfc6lM/1Rv00j0qsPCJu+T9BRV5FA8SSiY5f55Vdp3o5rZq2IW5yDsper0hdFa+kOEIYUNgGbwBe+V6xVzDaJrRFdOes+KTaU7cElP8Emf4XpsPJ8yGscZqGDsZPsBaTrSdNSMsTgfOT4/wO002ld31hl8lDo+u1q0jpTb5pqt58YSwHqSIi3nkKOD7bTG8ehIJtIQV24NJYfGS30z/BstBZAI81MCCaMwdoHx6sdw/ZwTL6EDmm1mT00Jj0zRns8KrKuAyz3Dal1Ss3K30S6jVTFotQwLEeStDEVLf9IonWP6yMEI6l2kBFc/5JvM7OdtAl8TWaOMZHw2K9KJD7+vR4LYKjh8Vcjum8OGLZoJqIA0qNm9oEQSb3gIizFGwc1Fx//oJ3ngMuhnI6No7ZTy2bxslrlEZTBfpwL/fT3N1vWZCqAD9icCuwt5s6yYrJ8OKIQ5C5MmYXI+3BVlK+sGVC6P323Ca3FnM9baa6dOH4luJk010LT2Bm+REUXLUcCjm7sTjKfn12LSoJwn5tGY++2l8ZlaZBx0xGsNfRgyYqEgUJiYkXtmJVtgVAmbQWDWNZXr2poBdRanmFL8Rrgz/ydhVUyIBl36158BM34+PjWoOdi1ZMxbzTxMXVC2pfMooXlfzLm0eu3UjErtRmYabR82D0HQ58fA/mstnIjQodRfAxP8oH7Lw0eNKLGDTDkqxjwSWN9rr/o6m5ULRZ0h
 lyeVM++C
 ZeiDTamipxLfdxuMKYFxXl8rUU/H+TREEa95x7aIoVZLgYOYbO8KwPblAJ5o7CRFwFrM6JEZ5r7H8GOlClDx4VWlKhZT3AHJCzRG9fW+i+doJCme/x04ZmfYlFJ+THp6KaYX8V9qq77DG5VX76YanmIaNgHmhxWulT/6TXkbA4nyGEUoTSWLZ2y48j6xJl/3e1/T36BbpDlTBO5AOMTU86NDl2TizBflGTUwlyXi0fI0j/JQyeCXa/ohbzlepq4/odGfPNMeavZkY5VPbEzkYZs7NS15LhLV4AHYXSXP8ZU0K5Fvj5HT4M/glguLczoNC0Apz2Oc0QbIrHGFh7FeXhEx4rQ==
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
against the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index fb525874a1b6b..bdd24430f6ff2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -664,8 +664,10 @@ void zswap_folio_swapin(struct folio *folio)
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1


