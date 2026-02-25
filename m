Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFACEFD200
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF356B0088; Wed, 25 Feb 2026 02:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCE76B008A; Wed, 25 Feb 2026 02:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF576B008C; Wed, 25 Feb 2026 02:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB046B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:49:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14970B977F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:51 +0000 (UTC)
X-FDA: 84482204982.06.255ED2A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 669AB1A000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n/za7M6f";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005789; a=rsa-sha256;
	cv=none;
	b=4miX2mU5rjDFdbudgJTg2DjWUw4YV2FyzaEKGMQclcVW4i33c9RiKASokfbFKagyTgJLDs
	0bxybAxfTzAaqaHusLyrF3kUVQFSfUMbTQayeTO0UfSlN8rTD0z8l+Z3f56bNcWSSr/cTJ
	onwy9FUEyhsOMKwuTCyivAyP+btL85c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n/za7M6f";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slvzxnQOZnGyEx6uyl7ed+CIq1Y9lBOT7LEWCAJSIOk=;
	b=f3h9HWVlbAwNij/wLm0dUJtvMQJWLJf9SuSoqNv2K8jXVulO7/kXjwc7WLe7DS/0Q3pX/L
	svUjHB01TaDxqkHHSJudcq1U7NSny9nl3oKny7sRZEWoA5ieYSPteJlH97NfBPSoFBfkGH
	sjI1/GcfgpEmBEaymRVgwXYX31DNFfo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slvzxnQOZnGyEx6uyl7ed+CIq1Y9lBOT7LEWCAJSIOk=;
	b=n/za7M6fo6nAu4gWx7thBhD988RRJ+hxPdZ8vV4kFz0EnhpV4KBccby0iZimCxWy9Fs2oX
	ZK5scZWB3gpITU0egFxM6O50nOnKNbEwwGljhP0QCXEPE8tfSZrgPg+YZdPyhJZgiEiWEE
	wc0pyCUup3cBHzoFwWpNFLS4iG1HQn4=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v5 01/32] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Wed, 25 Feb 2026 15:48:34 +0800
Message-ID: <f4481291bf8c6561dd8949045b5a1ed4008a6b63.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 669AB1A000B
X-Stat-Signature: 7wce418w5oxh86s89to6pzmb5ks7hryu
X-HE-Tag: 1772005789-481169
X-HE-Meta: U2FsdGVkX18oP7Hny0SO28O8TSf/gA9H4fRBChl7xsyQJI44rn3PWyYBZerJXToVZKJU4q7QUnBDZc4hHh9hHpzKAwI2QLLwXv2K4T0OFIO6z/RlWemBVZ1sNsqtMsfJ67pn0ktLyRFgCY7A4RsFmO4RrNHHAkt16xc+tNkL0lt2qAEIdvbdrWKoPCAwbe5uRH2wpsfqqwk5R/1Mh5Vq9qvxP8nvukj5h2f3ivXSMSnl/vJYq9WOFljgeBOD16craeQzTA1QWMIAiiqtRPyd3QzgINJCJIQa5WarLiyZ9zrEA6cWRGGI/SJuZzzg8xO+Dk/fc9fQhtB9H2gdBKTmoPny/+UvHtDISPDOop4ArOc38QxVWSnhPw+1vb+PyRzlt1ubJRAgpMJgPe0VV+OwiWxHoAaB9C5Knc/+X/cGbxCnEY/BzJwJD4uQa5jwR50z8jQrFPjRW4tDtJGrMz5E8QjVmaEQboWxXatLKJNFpUOXGTCnLBi664HdNCijD6wQhhp38dIvMgN+aJvcusj4rfoxxfr2RppXU6ubOOa07SpK1Mm306sTeHOwA7u42yPfv3pfLj9lauTwpVa9TEPrRGKUhxBbIs7acBA3Ht4hr8tKQaRTBtjsc1HYW90Wcm7jHyGtNXyxTUkyFIifP/v9RsaCUCmVdDn5t8APRIxmL+fnZA9jfn97EgPQlySpsk4fzG6U5BZyZReraF8Mo3msjvTINgHCVH1oU7rwOEbu97ReIooLnAfJu5CEhkBG4HWrqRBpToVvStjrtlv4RseRuy39bkxQHt68e8MXK+bPoXmmNmQfvvJg4UZPuKOZgGuMjtBFMK33WBltVsW4w9j6dKtv8f5yPytBh2M6A8pj5KEbTlAnb0N7r7nnla2/8j0Qzxd7/LDiCfXmKFB8l0rNhtcRfCcsmRJyi71GZIP7nGTQtJTIzGJ+cSx2EMYleiciY6o4Bp8uJALmonsPB6l
 Km45bRud
 OuedZRWike+eCSEffoUY2PyOxB+TEqVosHak5xQ0CW4h009CCxswV+tbDDACnHYvs5OtNVUS6PK8csuDtduiDX6Zr0DmY7gWVw5sh68of5mL5+j5FCPe1QO7rEAIGNNgk20fRVJLF0u5JUrLt/KLAA+rHbc23BbS+ZQuGXIJH/rlPyI4HfNbQ37KKHHylC02zFEmlT2ol4Nxxa29yXV667umrUFVG7Jbd6wU9uH9ny6F9/7QmNpuZdJPbiV8zQDFzb8XAphD6Y5tNSoputT7TRZiEY2ZaH0H5bfeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Since the no-hierarchy mode has been deprecated after the commit:

  commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode").

As a result, parent_mem_cgroup() will not return NULL except when passing
the root memcg, and the root memcg cannot be offline. Hence, it's safe to
remove the check on the returned value of parent_mem_cgroup(). Remove the
corresponding dead code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 -----
 mm/shrinker.c   | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db59fad3503f2..aab863e1822d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3424,9 +3424,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_list_lrus(memcg, parent);
 
 	/*
@@ -3706,8 +3703,6 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
 	}
 	return memcg;
 }
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 94646ee0af63b..4cd33222256ef 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -286,14 +286,10 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	int nid, index, offset;
 	long nr;
-	struct mem_cgroup *parent;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct shrinker_info *child_info, *parent_info;
 	struct shrinker_info_unit *child_unit, *parent_unit;
 
-	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	/* Prevent from concurrent shrinker_info expand */
 	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
-- 
2.20.1


