Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FE7CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6D26B0099; Wed, 20 May 2026 01:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62FA16B009B; Wed, 20 May 2026 01:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0C86B009D; Wed, 20 May 2026 01:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7366B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:31:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4A7E160370
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:52 +0000 (UTC)
X-FDA: 84786676464.30.8409C5B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D70340009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjfF36VE;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lMrdf7YGJu8aP4LNTUgpxJU2AI9pB1PVPoOsH0nIso=;
	b=7JlKiErTtViGnz9i2vkPfY3xToLfQuvx8UPdiyvWQwyGgklf4pSN40U/Bph27c+YjeOM6c
	xIeYgzpY/+hJWADxOkvEdcI+cbip4xeLJ7h7Bod42/sgb8cXv4fKnxS1lrztLIshwf2iBV
	Kpg8clzDuUKKG3RTdhJH6s0C2E7KHYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjfF36VE;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255111; a=rsa-sha256;
	cv=none;
	b=Pu28Np9q9RKjbc4FMghVmN2NjOkS3i72rg0eYQNgV59C6RAzDP+W3RVY9bTBWRkl67iGrH
	dODNaWFFkgYaZuaoGcRbUnVGksdNVLXeD4rdGnbmAwrylrxhxYnUjC+aXqnEhkAs89G9ff
	NsYQKDghBlXPkOsBZYUOZX5hgmIkWXE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lMrdf7YGJu8aP4LNTUgpxJU2AI9pB1PVPoOsH0nIso=;
	b=MjfF36VE6N0qJIroEBs3c8RWjCvifrIFRf2W+FK3y8LIJRXWDxnQC/v/jUJFBuKam/L0zx
	bzI80G/MdOX7cufTWl3IuwEU71x0Cw4SCh6A6yXRuXXfrGSpy5QNgEMwDVFhQ06NK4oPx+
	hSoRJGXnisy5W5ZAcSXHPP2vrm3quXg=
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
Subject: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Date: Tue, 19 May 2026 22:31:20 -0700
Message-ID: <20260520053123.2709959-3-shakeel.butt@linux.dev>
In-Reply-To: <20260520053123.2709959-1-shakeel.butt@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D70340009
X-Rspam-User: 
X-Stat-Signature: xe6coju4ryjatwyzeu65jyf98ejo4w9p
X-HE-Tag: 1779255111-312456
X-HE-Meta: U2FsdGVkX1+9HGEG+nQQQ52D18ebCvq6u5EARI5NmQKsWm38hGpAEiM+Vwnd4swjUX2vYJ2EhvkP65/xSvFeRj8m/FxfaBghE59TXAKjlcGmD5KZQ+9nV4W7yWybI7g3G0pOt0NgohobUuXGWog8kR0zXlLIbI3ydfgOpirFxy5tIDs2cblVC4B1ASZuNhgcV2h80UvwLvWpmPMTUSmDr8PBPa8+Qvzhvmht6Zn/zAmjgQkkU7xZ36DC/zZJ2S1ZvvZExHuWCrLP1OpTuAp/c0bp/AtzX9fxaRZ0NXxcEJpko9H4HK3xcBRsFRTGiLN+DXTMBEz/HIxrquvU764H7JyuUbNF7DB39CD4BdDZLBm2absYkaICXsgnhsTZUuYz9zX37ASI7Jtg/X/+m2UiivcfCrpaWzApa5m/ab09pEBpP87Mdm69oTC24JcGJQzWbZNRGYRabllJwk1xj0HYGqqiscAVKRMqsh/K3TFckHov+Ak91YQNwAartvvaxkXDa5KfcLfCMcsScVHMi4tj/1He9jemaOHUK0UEYYJdu3zu5K7hmNilmjlL1IKu9LFcLe2zV7mgt69wVCBVzzxqVreBPQERiVPMjavyL30ff7zCut5zHcqaleAbfrMWMFBeUyiPrcOd4Zzk2FckdbVTYtUIo0B8lIrwtXfZpfNy1OUfxrLUfIOQIRuh88jslZS1Oy5P6VRfA04UPVv7I9S7OYMY99k/gCpuGIv0U932PzUjJrLzyfeLdEhdFcuDGPcsQA8+SvdRufgr7kixed/PQUkuHdx/1nYAM+TN3OGbd1mxbr83gCvkG7Mw0WQgI79iSraXkx/y1F2m9fMZVRyowbkFFbpvr8NPOv1O1UWXDeoAfHw+8IpqM9RN0n0gkV5NQW3GgU9ccXggt0TuPAnqeh03dNl4KJTxyW2xRhpBrBmJALnw89hEzCand0lBkXaCFIsiXYR7bx6dE3iYldt
 akaU9WLz
 x1tghLVvxPZnUUJUbe/Y29on7wk/+tgNFs86Pc3ucboKKZcrQafHBI73TLlapG9bl6fiGcJTjBj4xJNZV+EW0b56PLZKomAUOvLuFDcw4oB1jYUVU3pNwKMgKLAnVXqYf/L89BJWbSeqmz0BZwD7MJ4Wfcsb61FrpTgLVLaXMa3PTkxw9OY/qINE2BRb5ZC18O0403Lxg4TTHZSdezR7WnE+rOCA0WeYvqcDE2Hl0iWNh+sIH0xWlYsa4F236n8ANKukP0IalmJRIcu25+J600L1/3T/QuEesn2vT3OoKyLRDZQD+2da6QvHolxx9WHEXm7IZns6w4Q8Yeh4Mvihp3ziI6KxwBva6yejZZZzSecCdJL+646d5ZY7dyg==
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

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
---
 mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d7c162946719..b3d63d9f267c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2019,7 +2019,7 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	unsigned int nr_bytes;
+	uint16_t nr_bytes;
 	struct obj_cgroup *cached_objcg;
 	int16_t node_id;
 	int nr_slab_reclaimable_b;
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
+	    stock_nr_bytes >= U16_MAX) {
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


