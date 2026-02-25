Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7150EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448B66B00AA; Wed, 25 Feb 2026 02:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409416B00AC; Wed, 25 Feb 2026 02:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E20E6B00AD; Wed, 25 Feb 2026 02:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8F86B00AA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBFA81A0498
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:00 +0000 (UTC)
X-FDA: 84482215440.03.744C760
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28D51C000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:53:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g3rebzTo;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evy5ffpxH1pOU6KU8S5DoExZmuc8IAjbV0oiS0M36hM=;
	b=cl+p22zN/Ctj2AyVhRPbVGIFw+f84r8plNMjyzg3kBu3bk/uC/Bt1i4Mb0ucTMEd8P77uR
	n5A4Sq3vBAl7XXPaBdF3/MLMiz0oyprboHFZzTxTcCOAKrXuoGZq53+NXykcs1++6LGqhv
	T8TSiLGUboCJqImigIbibNunuck5GZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006039; a=rsa-sha256;
	cv=none;
	b=yHo272fWl8UdWeQxQmTlJtit4JakwkTbkXWnOcNAmcwPBQ6FWs+tDMAYyCyix+odZ9nmr+
	ajZmE3m4XGSzlnAf9rnErt4WefVJQAL/BVXZjVwkjgykzXJ/SiQ0fGtnk34ziGpiVqIhte
	h2dotsHl/4+yH2Lg5WkCXq+tuK6GAtA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g3rebzTo;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evy5ffpxH1pOU6KU8S5DoExZmuc8IAjbV0oiS0M36hM=;
	b=g3rebzToh1hmOrEwT2+sdp8wYVlVus/EBrCeGuyjsCEjNs2drr/ZTMn+w+VAhfz2d3tNLr
	ifGKzr05BrM3HBVGfTC7WwluBv7BEAvXdSTvJm6omLOYrY6tWtzSgHO7lXA76lsN0OLqES
	XeLwZRjbQWqzjmA+WJTH0BOTXf4hl68=
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
Subject: [PATCH v5 15/32] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Wed, 25 Feb 2026 15:52:58 +0800
Message-ID: <21d1abab7342615745ea4c18a88237335ab44d13.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: qnq3rzuekq4tnkzze318poahhib9ywap
X-Rspamd-Queue-Id: 28D51C000B
X-Rspam-User: 
X-HE-Tag: 1772006038-47662
X-HE-Meta: U2FsdGVkX18odXVw61E9Ap+iEY3VuvILhIyBZC8H7g2KXG57PF0ePnHViFfsRIIdB9cvarw1obrDpCt/3keMbb/CRlnrTk0RewtXMzykYaipcRSUIMJCblai2Try4IdUB+rKHLiBMr1EmNi21rz0kUGCsWO7IGzDnbDZTzmdu4ni1ptyKTM8RSJuW1lO+1M2kHa1LuS2VDwtlIa9hcZdEQjsckWQx+lCL4HIcwxCPofW5e/BN9anPjFT9untTvzFzoKugTSVmPs9B8EaWv4vlo6ApUhFnFLapmdwTgqdTIw/7c/lB2cZaW3H3WlX7m3LnAoull+MMjHpgSCO6xsWae9bZAMCtbESWS6ce9OHbVgoyD8YFXnBJ7BbckjaBmBHAGKBGT+e7HuAkVedXhmuW3EoXSGFYy86bBkx9Vo8amtM3KJfT17O5hGVz7wK6FZvWyW+HlxV4Nl3JF6zpQ3rVsO56M8SXhhI1wGreNzz4dsP9fIUeHXN4U3Law8cNQHRoHuT5e39HqgMYEdA30zAq1SWmusyner2T7MopYncRC+GNRluWJAqQaSWjkmzY5shJ5PGpNi+zlq2gG84Tps/vutFOvHy5tVDBlOTWOsakvZ8yWK3Ho++hCKqDYmPaaGoV9XqBr6GRnzQE6KCuhNvmxDfgnOyNxXYYP9tiUeu0BxO21bYssMgaQEPxj4XE258zmsyu/keva+GdesYptKyqY+RTgE9pAQ8a9Jt9g68MUusevWyBdg/LBRSgOL09jJbdJUWMi6PfLLoB3N+cDn3Ur68iqZR2oyatW/hvzYRHVvNDzhIV7vWmQtTeVkLzyYj6uE6AfATGeK2JMrcE1zSfGAeE5/LrO6aV3ACzZ5+OXXPwIgqhE/nueBGCV6l0YCSj0T5RdnnqcvLbQTWAvdlzshT3pQ2M8kPFqmHO8tH59IUEaguaBRawskU6ZlPYVsxPk33Kflxg2py4a4/j21
 dS8AC0Bh
 iXiLapZ4CNKZEZWhC1ch+cVkcFohOkhMg0E/I9RmG1sGl32C1H/zeiSWr5a5lz0lL1+FMxqnc9TbHslNz64Vqmzr0U1S58s4I448EnqVRn3JEJvGMR827Aoe9kfIZiovbyna4BDhSzvTGUiVSpbbzHYSUPMBzVApL6NOdyvjqsrJTI4rvuFXXyINm4DD+xzlynXUZTCE1bOZBAWjpvwyCk8ufpvruMShCCw0vaWmkWlxzNNHgMWlr9GcpYlOTDx0qHI2d73uvITeMZd65KjEXu9jo1jGiu6jL6lMDFj0vQbZhUZRna1yOvQW5z3ik+YXh7PSV
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
against the release of the memory cgroup in mem_cgroup_swap_full().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a4bb8b8b2c457..063fdfdd58223 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5345,27 +5345,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (!memcg)
-		return false;
-
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			break;
+		}
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
-- 
2.20.1


