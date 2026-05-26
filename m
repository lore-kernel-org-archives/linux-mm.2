Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53CE8CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3306B0096; Mon, 25 May 2026 23:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73706B0098; Mon, 25 May 2026 23:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF546B0099; Mon, 25 May 2026 23:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98A396B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:40:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 318901C1151
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:25 +0000 (UTC)
X-FDA: 84808168410.19.79BCA5E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 96EB680005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Je6Ijy+W;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUqtonBf8W/F4/BUz1cM/qYSJHRoI6UWWhfXJV6hdNs=;
	b=RYx+1UWduqHa0qc8T3YIpBsjCP0+6NE+y8CmTM9gcKdVRlcvPZtkWRk/KM4OwKvsvDmwEh
	lDGhSns8pxVgUnPSQlLV3AvBH9bTSGtI2BVbGWo2NubZz21NMU3DtTU9afjdFFII1dzaiy
	m8xqs8sw4PP9G7GcK4P1oz/sjpj01M4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Je6Ijy+W;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766823; a=rsa-sha256;
	cv=none;
	b=kf/Efh+Umr/5VDdXkc5cR7cUuRwnl2O5dA17UOJ7mJXvexRauTGY+VOxfVAIlDTIT/9WJo
	ITMlr74R/o7VhMTFNofXYdlqq3XZ0keNKpgGu09OzqAylh1yTndWuSlD/YcPR3Qg/uaZyn
	/6kjxVAgmolyNIZitmAkBwPXkyGmkK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779766822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JUqtonBf8W/F4/BUz1cM/qYSJHRoI6UWWhfXJV6hdNs=;
	b=Je6Ijy+WC/N5AGJ1y2KE5X+taxE9xddABSxY7PU8tcJ6CSnJ5gycwyj84UAjwTD1/8UgNc
	h153RH/3//HSjvFmIx8ymq5CESp5HLezaBmIjlyPKED9ItKRV5b0TkNdIWACGQH75pHRbL
	CpGWgrr1uMPmRVKYOjzVu0HlpPepyn4=
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
	David Laight <david.laight.linux@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3 3/4] memcg: int16_t for cached slab stats
Date: Mon, 25 May 2026 20:39:30 -0700
Message-ID: <20260526033931.1760588-4-shakeel.butt@linux.dev>
In-Reply-To: <20260526033931.1760588-1-shakeel.butt@linux.dev>
References: <20260526033931.1760588-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 886y9urxrybeak7a4m341stwxopnbwsb
X-Rspamd-Queue-Id: 96EB680005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779766823-771260
X-HE-Meta: U2FsdGVkX1/g4DxBuPD9cPXfxF455Fcq3uKfkSMFmRgzKe3HOLQMfjHO/M1UWkArnhCYLrd9J5Zjk19aDvv8Es9KziQTrIbZTSKirN4h5JwEeZfxyzZXPORtCZZlVepbA0VRROPwYbBt9NEP2pkK1MJFU32Xy2NLt/inguRMq9BYl4czf7Cv40SQmmSLtwYKdmrZhp2sGA9ANZ7heBjfAtAQrJTx5SO1SzDWyZ93qyfCuvZ5Wfh720sq7jWf6RccX55Z7c8WBkmJSLrnm6U6+C3u9DUv6xAkGLeaIiFHprvzmMkzny6Ov5mQpGmuEtFjPYr9dkri2EPzVfYp59ZooIlu3KUKKNi2gpmkElbyb0ZKuMF6NkGcNt6Wl4AOSUpsWD5hy5Q5n8Ak32AxCPClbBDEOrhwRMoRkleREKQXhDkgsdCFWjyQnuOBgIazgcQujOF7ZutgYToZIdKigdAwx0wLIX4VXgfxOS1fJPdkJNJDDIptQKzYpNDZ3sBWbOb6v9Y9djGn5lsI0+GfgQk28A/Q4hIQp5hktvSdrSuhtnoEcD2DSi792/Zg7MbdvmMMQfOTmLwtfmF4NL9g69aDHlV2XzuvOdS4pTSEMjtIJKvB2mc9ncpUThLWXx4Zr8JqlZ1AXmcmIgSYlZiqlbBptMe0aVnmqfBNJJXE9lVHhdYX8b7u6zJXNFcQC+udGokaWe5lue6DrDFXr63GmDZMSro0lPs+wA2vCNz+ZFBWPoEtUxgA33Idg9il9EiUt39tztSbrc9f3ph5Od48x7/rbMv+XcJGZgz1KWdbbMKlsugDZ+9L3InsjjmigYNDT0952Z2rsXxvfuUXEs5TACBCq3bgF4fzfl38VyQ0hIQQLka8MlSJaf3VJ6eLUjQ0i2Bv+Wq7+0VmDz8rVw2Q0y32G2qFEw/z5zmMoFWWeh34VTEdEHaExXzMFKcqA98CSFYrcQ3H8oM3JZ+CiSDTsPg
 RjD9imt6
 fMPcvgN9VhpGvOW+HvKCM7juedb4tfAoaH3GC0uFn1Xif6qojpTuK9dSxdiBlYZuzHJ3eyO0Z53Wuxi73Txp7G2OR9DRqIfZHf/VHUDjqE8AWIxVoxHClgrW+5KGf59Vy1jSIzZdshkBZIzGDjz64nCn1ob4b8HhjpGe5nGcu1rEzV68Q5D0V4zPP5YW4NwivnkCK6Caf+lbtRsTtnZMS3zfPghM37wHEQkonS5tXaHkY/r/dGhP1a/CS4o+vGd1tAwcbizJYRS5cYqAMcoFj3Yd0BBRB85EXibdARYBUimQ8OwmBuEO4yUcLbaOvzCJMazQuO6WhxJgddmb9kjqdCdROnteecxIpmLO8RKZs+dlZby4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently struct obj_stock_pcp stores cached slab stats in 'int' which
is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
shrink the cached metadata.

The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
sufficiently long run of accumulations would overflow the cache. Add
an explicit S16_MAX guard before each add: when the next add would
push abs(*bytes) past S16_MAX, fold the cached value into @nr and
flush directly via mod_objcg_mlstate() before the accumulation.

Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v2:
- Simplify code based on David Laight's suggestion.
- Collected tags

Changes since v1:
- Collected tags

 mm/memcontrol.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be82e52c7999..fbe0e9915daa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2035,8 +2035,8 @@ struct obj_stock_pcp {
 	struct obj_cgroup *cached_objcg;
 	obj_stock_bytes_t nr_bytes;
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3173,7 +3173,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3210,21 +3210,20 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
+
 	/*
-	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
-	 * cached locally at least once before pushing it out.
+	 * Fold @nr into the cached value and decide whether to keep it cached
+	 * or flush it directly. Cache the combined value when it fits in the
+	 * int16_t storage and either the cache was empty (so even a value
+	 * above PAGE_SIZE gets a chance to be canceled by a paired delta) or
+	 * the combined value is within the PAGE_SIZE flush threshold.
 	 */
-	if (!*bytes) {
+	nr += *bytes;
+	if (abs(nr) <= S16_MAX && (!*bytes || abs(nr) <= PAGE_SIZE)) {
 		*bytes = nr;
 		nr = 0;
 	} else {
-		*bytes += nr;
-		if (abs(*bytes) > PAGE_SIZE) {
-			nr = *bytes;
-			*bytes = 0;
-		} else {
-			nr = 0;
-		}
+		*bytes = 0;
 	}
 direct:
 	if (nr)
-- 
2.53.0-Meta


