Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA3FCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397366B009D; Thu, 21 May 2026 21:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E8E6B009E; Thu, 21 May 2026 21:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284286B009F; Thu, 21 May 2026 21:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1676B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:19:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D36BC12094B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:53 +0000 (UTC)
X-FDA: 84793299066.12.6A0E281
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4935E140009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LBjWDd/H";
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412792; a=rsa-sha256;
	cv=none;
	b=RbIkbcwqtxsMProYTF7b/ZBpRrNuVtzlpBAVjPMe5pr07YRt+pEyf4qijyPRU3pyqoO6U4
	XGQJTRVu2yf09rbci9wD0Sd5ACqQFZ5wyMVdFhIWhoJxZ+8pSvhgDrY5V/4Y2rXYycq6Fo
	IIzyihCWjWuwe/TEnUcoSfZYYEUYOmc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LBjWDd/H";
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0DDjB0w4E9tMqU+JEwxbi4iz46ciqDj+g3fDXVBUs8=;
	b=Wkqvylh8SS5ADsgcOiSBY/zfAZ40GTx+ZJm481NeQnI2bW8QddqDJIFYFYMTNyFhnk8Jv4
	J6BCHawblLYtrmQEQOZDJB9+zWHB3iu4M299BiZG+AYU9w+/Z04kkfxnc5z4rmw3SMJQyq
	zgLYYcNd4wDidxwMIHgMi23s8KaG6QE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779412790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0DDjB0w4E9tMqU+JEwxbi4iz46ciqDj+g3fDXVBUs8=;
	b=LBjWDd/HeERmF6Rf8dihT6KKDeCm9NG6KIIBMxZfB69IOMazt2pX6Wn1nfoXxIAKbwbL4z
	lfv2KcxH0aceH3Bm/26jxoCn9id9qEBK1UyJ2oUDuD3LLhAQx763nh7zneCEZvHkdNufhi
	qiEAedwMNnd+OQ4XUAgQaNtBDY9ria0=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Date: Thu, 21 May 2026 18:19:06 -0700
Message-ID: <20260522011908.1669332-3-shakeel.butt@linux.dev>
In-Reply-To: <20260522011908.1669332-1-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4935E140009
X-Rspamd-Server: rspam03
X-Stat-Signature: sjtm8pdutn8hjwks5i5craqwfnmurzxt
X-HE-Tag: 1779412792-343614
X-HE-Meta: U2FsdGVkX18g05QyVptsYJ8eyxuRRCiU/tRdO8l+BpqQ4jTgeuQAJGxVfwCoymFgy8ns7gHSgjbsO0bAcugBxTPDv7d3U0wOFpDYO5eTRbMdtNavNwOMmuv9c+YrgQxIx+vK4THcZ3S0jknyjbm0bw6ybFhIFMKjmLrIr4Zljk1YUgZbXudqOABv678Hq9SLiAx5qe36S/E9bzp9Cjg7qOXuMX7QSkqfB98OPMyvus4JkVbJ6unzmWOacgDvhFwyVdCMCc+RxXgvNOVZkT/Ipp0/SyHPD5qOqIwO02YkuBrGIZqMyxkUzZsWH7DAYyPfYaGQbKAlBfSAIbuRQMWrgYc7by/WRe4w7NoxdXrHQ+FFQL6W8rG4gaRAsSx2Jh16OfJjbnI2HPpEBE3kE3kRfKsUo57WUpxJ9K+zIzou/jhsGp3SLeuMXw+NG4sweW/TPrEAg8jUG776C8UVqE+/XmQbcHODDyFOPGXHTUcuegCIUVVkBB4yPlXVj/7GsdOKNArn5QB9KNIUaapVn/TKK7A1EoJNu8Xwvu1oOEIZ765qIVyvH9V+dvOW7PumjD/tN+sYbpVXU58iWhB3pDAEH4XP1azadwJ7Xib/Rz16WSJBOyI3aNsc+x3SgyrblqjJBdDbAGYqWg22KQSmkTa4RQ7WlePKDCZYh3uBn4V4NEIwLFFrpFxp43r5FqSdNwFawH9BmE/7dpsP1da9SawQ8WeWgbxyHuTcvgzknLbVzHZ0tF1kuLhvlXReys/k30fsMAeMUyWs9e8qHjBssZT91Ty5zrriMjGmH8/HpZ3yQJWsai8cO4Kdj4NKqH93+npdSEb12I9rnkt8U/RsozzfmbyKLiFPkwX33s3WCj5Lb4GTGguboVUpcBdbgeq+wZj72UbwuxQHTsRjWI8u4HYyow+j92iK9rtAmoyjDRLgoxG9L0XJJ/YXaVfZfAokbndHJU52g+48sMe8cW5L/rh
 HnJ2Av0o
 8kjqtiNmcqAkKgXMeoatMIf/c0CIyUSAPX/v0oVFyJTYmcN1UtxEkj8Td9tWmrFN6GW3sQ8UAPhQwMsuArVBWVXBLTdQX5MRwdZoizRYIIgrsM2+agDoM7AFDOh8IQHnKL/qFVilVMWiTAqYNGkc32icOZeBTSN0GftIiAH6ni4EHjDT7FpVxOBbtld7frNWtKwHdLNXgbFR+apkWL/CqrXYlma8ERXtoET9JPC7Vy0gOtDTrko/fe0A3j6zlu9Yh3BEL/NNpOLt1BbDTwZeUQ6r6h4NzIDY7DCPq5xE7teHhIftu7XawAQhnZCQJU5jtSpMns0gQww8kUKuVBzh/WNpj6GpddoqnfG8q3aItTIS6Hiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
shrink the per-CPU cache.

The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
_256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
== U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
U16_MAX. The accumulator also needs to stay within uint16_t between
page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
U16_MAX + 1.

Accumulate the new total in an 'unsigned int' local, then:

  1. Flush whenever the accumulator would hit U16_MAX. Together with
     the existing allow_uncharge flush at PAGE_SIZE, this keeps the
     uint16_t safe on PAGE_SIZE <= 64KiB.

  2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
     powerpc 44x), push any sub-page remainder above U16_MAX into
     objcg->nr_charged_bytes via atomic_add before storing back, so
     the store cannot silently truncate. The PAGE_SHIFT > 16 guard
     folds the branch out at compile time on smaller page sizes.

Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
---

Changes since v1:
- Collected tags
- Rearrange fields of obj_stock_pcp (David Laight)
- Fix comparison operator (Harry)

 mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d7c162946719..e4f00a8159d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2019,8 +2019,8 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
+	uint16_t nr_bytes;
 	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
@@ -3331,6 +3331,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       bool allow_uncharge)
 {
 	unsigned int nr_pages = 0;
+	unsigned int stock_nr_bytes;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
+	stock_nr_bytes = stock->nr_bytes;
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
-	stock->nr_bytes += nr_bytes;
+	stock_nr_bytes += nr_bytes;
+
+	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
+	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
+	    stock_nr_bytes > U16_MAX) {
+		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
+		stock_nr_bytes &= (PAGE_SIZE - 1);
+
+		/*
+		 * On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on
+		 * hexagon and powerpc 44x), the sub-page remainder can
+		 * still exceed U16_MAX. Push the excess back to
+		 * objcg->nr_charged_bytes so the store into uint16_t
+		 * cannot silently truncate; folded out at compile time
+		 * on smaller page sizes.
+		 */
+		if (PAGE_SHIFT > 16 && stock_nr_bytes > U16_MAX) {
+			unsigned int kept = stock_nr_bytes & U16_MAX;
 
-	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		stock->nr_bytes &= (PAGE_SIZE - 1);
+			atomic_add(stock_nr_bytes - kept,
+				   &objcg->nr_charged_bytes);
+			stock_nr_bytes = kept;
+		}
 	}
+	stock->nr_bytes = stock_nr_bytes;
 
 out:
 	if (nr_pages)
-- 
2.53.0-Meta


