Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA19D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825A86B00BF; Wed, 17 Dec 2025 02:34:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFED6B00C1; Wed, 17 Dec 2025 02:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730916B00C2; Wed, 17 Dec 2025 02:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639916B00BF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:34:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19DB46052A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:19 +0000 (UTC)
X-FDA: 84228149838.22.8D49FDA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6D1ED1A000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AXc74V+X;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EV6q27Ww1Pi8gdjbSvPXKtgD9Ua4KYVSU4hxepzaQ/c=;
	b=22EY0Dovpo6UjNNOISiNS/XheF23A6Gw2316B8kz2FEmRXmqxSFkubq334TcrtZmm6SzFh
	SCGqjdqPGNDFcshZPYcOie0ZGV8DuLRrsOTL85NW9Ozth7pgOJfT9qDHVQIT3IBZRHJawH
	t4JniaLBsV1c+KyF7hoFZ4iYVsmPXxI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AXc74V+X;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956857; a=rsa-sha256;
	cv=none;
	b=IkIrEYDSBSjJ1DoEMU66D7W1K2ivCbr3iIgrnBijnZJJHnRub8G/WZ/CGnD2nW2SMKPaXK
	3q6pxY1qoRAxKrdVxN1sQaP6HwG4AyvgpMvTZWcl7OmBE99urmoq6IYSC7JsTT1+5xWQxs
	k8/t/GpZv4dbNunnNCddga2YU5bgHRo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EV6q27Ww1Pi8gdjbSvPXKtgD9Ua4KYVSU4hxepzaQ/c=;
	b=AXc74V+X5J85APZtey4ZYmzvZIJ2n7TB8CPnOTzJ7cjlFcn2vZ3x3ewYMJKyeAZsbiEzDu
	FKOiBmq0kxoybbzgvggqr2RteHqX3hID9EFLyHUtckL6onKDbRzk9Ec261fXIQOpz1aFq2
	eiGoRqCmHtDMmXsNBl3TymksjA3OhxA=
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
Subject: [PATCH v2 26/28] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Wed, 17 Dec 2025 15:27:50 +0800
Message-ID: <8e4dff3139390fc0f18546a770d2b35c9c148b8b.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: wjzi4drrufky8d6y5w1xbjpt4r1rqrzk
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D1ED1A000D
X-HE-Tag: 1765956857-741096
X-HE-Meta: U2FsdGVkX1/RuohA/qa1ZLrK9EESOgOemAH1Ei1Trt6cwgXW7t+yN1CCqjP8+QSeNmTV0NUCi4PsKx7nFnnirdtKs78LJjWgBfFsC3RiKC9JRGg9np2StKCWnkHII4WWFn/mq1ua6sp7WTL5ahRH/haWQZn97Ucy7BhYWyh1e47K+hiB+1iqs/qBMn7G2e/Q/UEyzQ+9LELYqnHyX4IcKgbTq6DaEsBjZpbmfHMZNU3AFWeYJOlLifZEKSM2MdOpvmlHLjIg63tLfYhT5u1UfmqQaoA380fwhBtjQ+HrWV7IxkJzPKbqG4xow5GtYovCy4KPTmpsFdkajnv24F9tM+7Gz0iYArtW3qh4OLqpGHzRx/JX4BsHtNed8x9eMkomi1mOQE95MU/h01FZSgploOr2EIzx4P0LrxBCQQB76gv/0SAepdPBxjvOFQuzIP7tB85jfVo3pWd4iomIFGpJW9fuRdP/CefPycbIDA5dGHWA+WMMN4sDyNO5seDwx4EDP6gFzpAwInCevE86VBZSBA7zJ1qAtauX3s3z6/yVHAs+cwTNrgitBb6+xFxP08CBQU4F3OKkolbULxqrQyAsV6m3yR2nxHcLAhsr5g373vpbMfGHT8bVmkCI6lR50CTBMtchBjWFmeYn1gjzXx4ykX2FiWSQn0wV0+nTX3X3aHB3p4GRhGxcMd8I+Xz0oc6zfdDmA7MTIiqQNtdfKQLXzmIPk+SQAQzLvYVz9LfxLWAWils/GZp4LlMB3UZvW+xhCT5MBIg/U7Z6p9Owm51Cz8GwKcYQsVeeny0OG0ecS/jS1Q3lJMk4ZpiWArgwnGXvefs8bfgWtMKnRgokAxDYr6842Ldf3zYcf/RBAFv2umKq+Ld7kXtYZejgUpbXBsnRlUN92KV2pXJ8G2Q4XrbcVd+BoipBXi7jmxluP/NzYbq8flWJvPBiuKL69nWCTgVt/ynjypd7yQXpGX2C9A+
 7meoVsls
 hOlIfXMOvCTUrO8Fk5gyRwZsdmxk/exIKieXuTleFssaLVoy5lMc3Oqed4VSo/lu0VMRiyflAVfDHmszCA8wBfxXlXyjk6y+vUu7M2fbKmjSSAEptEJfj2TOfoaW0j1/N5BcrzQIepOiXVNF4fvv2TuKRMbDsK4xd8sC9ZsmC8fdb8mflrwGPUcOw7F+0o9s+sWg8hOtWoEylmaHV5vyG8mYmzxd5D6ItrzfdJBlOWmzPrzf1ieQXy+uuOg8OtLBo1h5Ckz/Nj5TgidU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
LRU folios here.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 930dacd6ce31a..3daa99a0c65fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -206,24 +206,41 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static inline void __memcg_reparent_objcgs(struct mem_cgroup *src,
+				    struct mem_cgroup *dst)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-
-	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
 
+	objcg = rcu_replace_pointer(src->objcg, NULL, true);
 	/* 1) Ready to reparent active objcg. */
-	list_add(&objcg->list, &memcg->objcg_list);
+	list_add(&objcg->list, &src->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
-	list_for_each_entry(iter, &memcg->objcg_list, list)
-		WRITE_ONCE(iter->memcg, parent);
+	list_for_each_entry(iter, &src->objcg_list, list)
+		WRITE_ONCE(iter->memcg, dst);
 	/* 3) Move already reparented objcgs to the parent's list */
-	list_splice(&memcg->objcg_list, &parent->objcg_list);
+	list_splice(&src->objcg_list, &dst->objcg_list);
+}
+
+static inline void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	spin_lock_irq(&objcg_lock);
+}
 
+static inline void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *src)
+{
+	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
+	struct mem_cgroup *dst = parent_mem_cgroup(src);
+
+	reparent_locks(src, dst);
+
+	__memcg_reparent_objcgs(src, dst);
+
+	reparent_unlocks(src, dst);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.20.1


