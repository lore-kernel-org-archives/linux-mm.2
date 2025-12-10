Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F745D3C526
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 07:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3771A6B0006; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345F06B000D; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197746B0006; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E08F06B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:26:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84BA81349A8
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:48 +0000 (UTC)
X-FDA: 84202729296.13.63753B8
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B76320002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765351606; a=rsa-sha256;
	cv=none;
	b=JdqSLStaEM5l1k+KxlpezBqKkWx2eojKz8hylQ1Lo2Y4+GMLde4RNFVF/hlNIBbm3bwXW3
	BJQ2VU6NNloxvJH9TW2fVopepAn1rPKQh0eNGeMRZIvEW2K4i4323c/7aeIrk2k7vT2rE3
	VcVDOgirMWOZt9img9ZtNAQFL+rXrbU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765351606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9Zgg0673AtA7f6FW1mGjSzMBVDcI2ROd6PjS1t8xU8=;
	b=7QnEA4mjiZHrTaI3fMumE48OZz/JODuoUmgV6AhZUu57wIbSWdPyvvgfneGmi8Ko5ScJ6x
	2iCHeWXrF7nVLHR3UwcF5mzBIxqB1YpcPziZe4YjIrLmY/pxnStTKsZij94cf/sERFpFMm
	XXBbUXNqONvCJywfR97varo7AJuq7QM=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dR6hw5lM6zYQtqf
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8C42F1A1B59
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:39 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgC33pujIDlpfef4BA--.9918S3;
	Wed, 10 Dec 2025 15:26:39 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v2 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Date: Wed, 10 Dec 2025 07:11:41 +0000
Message-Id: <20251210071142.2043478-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251210071142.2043478-1-chenridong@huaweicloud.com>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC33pujIDlpfef4BA--.9918S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1fZF1fWrW8Jw4fJFW5ZFb_yoW5XFW5pF
	sak3ZxZa1rJ398Wr4akFyDur9ava1Iqay5t3s7tryfZwnxtwn0q347t3yrAFW5CF97Xrnr
	Xws0yw1xGFWYkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRMv31JUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B76320002
X-Rspamd-Server: rspam10
X-Stat-Signature: mqxda714xt93iw9z3twddk5of4h9t54r
X-HE-Tag: 1765351604-690136
X-HE-Meta: U2FsdGVkX19XjInonqpdKmNZi0pwiqholo+V0d4jf0W3WTIG883l6vHS/w4gGardlvaoxM6TxFNrkH99Aa4C75uQcWgv9I9g2LuokVJ665wXiFpO3yBxdcJsufnmXC+TgeVK9x5CRfPa/gAac6CnjW6CIYQtOqile8LIqRpHjHzONDlxQRea7bpgSbXMKQ+JN5ALbseBkX4qivD3tj3pyRYMqoaB8vTrINNbIpTPZ5m9YcZHTpdkIk86eEjFw/aTVK05uaJLVqSQHmdOfJJ063mRJrYxYRsS24+fu7mj1eS4JkeQ/mrKHU56s59wOxzC7yob7JzHxIWzdvxx0qtsYb+rdanmtDNKJVlzutWR4ZbzZr7YJkEmV9b/8iTiaw3F1cLV1M3s4zl4cWIY7Cjk7Iw4FsB6Nf37w+1nKCIzAv4GuR0CffEYjRGbIFhWuiqN6jZZCvdD7d3MpiZbYXrzlALZFvWJ2sm+Zf7L9f3fU2pjIlWp7i9R8NpK43hye/okPHvZKM0fQxS0qA3RQSzfz7pv6xrLKJs5pBfqMMsC3jxxg9e69Ql9wBSsZkcZ1NC4V0APmRxTHjuVNskYq1rvEALB5A/UzbaoAJho+shPay+jpkv05e05zP/+rTttj6LHaHNc1Zqd5Ksd18wXIMHCGkdaNv0I6yPGDHBjJjT0SmZVw/UdTJm0Aww/3S2hqkMmcSf+FRhDMwwAfsyYsX41lNrcWC0qZEVPoP83r0Yl6AxK+9KKcy/LiXXavm/OWFP6a6nPSccP+FQQt4H6VTc87o13XxjeJo9/Oj/FEKV2pA3gfwz2bimOPLUmrba01saI5Ql0FPzefXwLTiJMvaxxdc9Ho+MRnQQdo6wMbisNdALEzYiTbA6jqvpK0oZ59q8P73hd6UJyhTXiN9ZWJKeXMRXbtUxsbyFjvA793LosupuSnkfW8cnYza8kympsCrZydDA/ARQaelVcomtr8Cp
 29gyeLnq
 O4JVGjuax3/k3pUdUjSacUTyTgUswPBdYWebVHVLOA7cEsP8OLggjKPflGQhRSrBv91Kpm/rsri3FegV8ZKL+XG3zALuUNPAv9qSExwyo4He8R9zj5u7ajXczcHK7lBc3PKhinuNwJz/cxqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Currently, mem_cgroup_usage is only used for v1, just move it to
memcontrol-v1.c

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/memcontrol-v1.c | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h |  2 --
 mm/memcontrol.c    | 22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..0b50cb122ff3 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 }
 #endif
 
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	unsigned long val;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/*
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
+		 */
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
+		if (swap)
+			val += total_swap_pages - get_nr_swap_pages();
+	} else {
+		if (!swap)
+			val = page_counter_read(&memcg->memory);
+		else
+			val = page_counter_read(&memcg->memsw);
+	}
+	return val;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..e92b21af92b1 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2e49f4ec9e0..dbe7d8f93072 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	unsigned long val;
-
-	if (mem_cgroup_is_root(memcg)) {
-		/*
-		 * Approximate root's usage from global state. This isn't
-		 * perfect, but the root usage was always an approximation.
-		 */
-		val = global_node_page_state(NR_FILE_PAGES) +
-			global_node_page_state(NR_ANON_MAPPED);
-		if (swap)
-			val += total_swap_pages - get_nr_swap_pages();
-	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
-	}
-	return val;
-}
-
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
-- 
2.34.1


