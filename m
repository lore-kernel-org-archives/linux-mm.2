Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B32AF30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A4B6B00C5; Thu,  5 Mar 2026 06:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04E36B00C7; Thu,  5 Mar 2026 06:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3116B00C8; Thu,  5 Mar 2026 06:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB2E26B00C5
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:59:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7447B13BE66
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:00 +0000 (UTC)
X-FDA: 84511863240.07.02167E8
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id C5AD240006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOcfMfGt;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih1p6IEUWMwvOImSKCL1YcoSFVupYh3GoMOZwrQGBdQ=;
	b=0vgmaylwjjlOP+smAIX3KuOi6AYmvhmq1QEh4tGqEuTOh11fwHvPWxQfZDkCgvWRBc2kUL
	JsEQCW42vb5j9QRt6tL0JneL0hKCRUyaEeQlISVMDS5O7QlhYzVOV0/5fTpQ1Lb1QBUg6h
	QQAj2szMLbVDFNgf86rN9TishAdOfJs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOcfMfGt;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711939; a=rsa-sha256;
	cv=none;
	b=Ejlye74y7Ep56Sm+h8iCnmxr36CcAkcXMBge6YhwcGc9OtaYVf/SVPuftfz4LRGxzXkLtC
	IzJfxDdUs0P2G6RAVQLlMe2t3MNp3gpLE1FI0Affgk/VN+AJIE6/8brULTbGjDv/QUUIKw
	uG3HNmYkmQYsDd1x0fvuQ10IPTm0BlM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih1p6IEUWMwvOImSKCL1YcoSFVupYh3GoMOZwrQGBdQ=;
	b=BOcfMfGtjpHcZp+xS/IpT3JULkLv02uZSYMCkCq8bDAyt4Jvy92uC0aTckuxqn3xx3Jxbb
	q/M0pn2SWVc7gCp+kU8JZd+USDTs48XoIopK3xpPraNBcil60WNqxgue3ZE0S/NnoqLuR+
	zXFJzorToXtaCX16OVcQD6Gtc39QfHA=
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
Subject: [PATCH v6 27/33] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Thu,  5 Mar 2026 19:52:45 +0800
Message-ID: <2e5696db1993e593a51004c1dacedbc261689629.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C5AD240006
X-Rspamd-Server: rspam07
X-Stat-Signature: djhdfoi9e366zfisgx1neb5h49z4igop
X-Rspam-User: 
X-HE-Tag: 1772711938-323125
X-HE-Meta: U2FsdGVkX1/mU8+U92PkMKwsNP6GoJftzX+JK/7dJ/yB37kEgxbLDBW6lP2GD+XrDI1puvQxpf87Vyn7DohSAcnFlDtVVO38vkladokt52nzioGIgWl/JgPQkQaIzyVVRQzXq8fo8nvhChwDIP8xG6J0pZ0BCCTprhvjuw1ckqcWKjCCcIw7lCIAFDAXMYfqTFE6OIk8E5OdMPwtC7EzvuWXYvWmebpveI9DD0MLcDhn7Bfz1ki1/DSQPEj95Qib57S8T7mBzfyVJPAFJ0KEuFgvCyMC1kYecoc0/sVsXn8xleiMio3BnSa7Jy7yjdyMJkyBs1tv/FqnmvdzNsxe4jLBFN7UEsV94twQih939gaS0IbhtgC9109BenckGx0lJ047UgK0lDzas/RyG5hZ6xs2Ppzxidiyr4Dm1mnNec0oSNv9XC3iC9k37ILgYsxNsrI39wiQfTpIWUl1OFRqnTP80Bs/jRZFOvt/qEalwfCAqGi9ffPsaLyBc8fPIddeonorqBhN/reItAiyLQHAtpNQk+7SvoSmAc6usCuT9Hg6GgFMK8WToSHhN1AzbegtGgXauFDgaE/JvKArb0fsvaheScNE8Jrnh/hDpNjjo3NC3bXIGt6bMz6qDHfeHn0KZkXIjdWwAn7Gm4Vj1V+4c71ms20OJsoDFbhSAUltTT9gANq4mdPxl1OwqDGgJN8Z6VOseKDjYZLf+4e4xzZ2wguh7ga0jCayBeL0YTWYlpIZMKdfKGs0DEvlA9coSqrXKBd6irIKbcQTQEgK52qG7JEczUzOnNVSMTzfalPj3pxhOKolZ+a8a/m1zw7R/EqkJE2x1KF/L9SZpk+aVwwN4a+iOTvO31uqyooVCg6zRusMB9BYb/bFyinN9WEkqObm/xkU1IyPyCBztkHNUmTDnjYkexJ07F0W4dS0x5nGZx9wJkNsroMAtl5J+IiDuxISt8PZnkZtZNwQl0z2pt7
 QttrN5pQ
 dfRFmSLUcqvxQekCU1SIZKRY6CE7Mudyi8ucUdAV2hd3gmSUw6ImomLE9c7q9NW1ahcJDaNVRPwPnFXKCgsS4Bu+GCBcmF3ljjiHDP2HdZdzN4HVM8o/tknA9WtY2Fhnj2ZU3QhjGcQzneu2seIHzeMdjH8zFHB1sUtPom7bCnklsp0gJGKiqu0bQBO56KumcIJOZhoLxIBGfS2RImyizTxjHyqjw65kG71SGG3fJaqUXFlLBLZgs4AZyEQ1kn3pEJELw4bJ97/KdsAu3sm+9ghUPEzZUBySk9hOJn6u/fNidJ87+Wjuz5C/oGJYMmTEMuwa0B/k/TF8hv8X26FsTGR64var6XokaZnwK
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/memcontrol.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49a076b7c2e42..5929e397c3c31 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -209,15 +209,12 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memcg,
+							 struct mem_cgroup *parent)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
-
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
@@ -226,7 +223,29 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
+	return objcg;
+}
+
+static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	spin_lock_irq(&objcg_lock);
+}
+
+static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+	reparent_locks(memcg, parent);
+
+	objcg = __memcg_reparent_objcgs(memcg, parent);
+
+	reparent_unlocks(memcg, parent);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.20.1


