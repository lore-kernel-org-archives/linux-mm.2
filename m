Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F89CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8045B6B009E; Thu, 21 May 2026 21:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBA86B009F; Thu, 21 May 2026 21:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1CF6B00A0; Thu, 21 May 2026 21:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0C06B009E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:20:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E5701C1EC9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:20:16 +0000 (UTC)
X-FDA: 84793300032.16.F0D186D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D52514000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:20:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jy/r4gRI";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHNkZOw2UW3I07VSJDEzsPCBLxzvWAd9K3Bgudx7KQM=;
	b=4YHdlReZkePkBHwu5/GLuv8Ix5pKD/Ngg5Ovt7KELu6TTGkEzagD/6fe+dpXE8iE2qYBmV
	r1R4z+CvED5tvgvUeqNBbNponGjwMx17DpUlSN5C+NusRP5jemTg64jE4ix/Hj6+qOhu4x
	HFjYb8iLu9QYygfDWjmruDHqJT2j1Mw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jy/r4gRI";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412814; a=rsa-sha256;
	cv=none;
	b=C5YWptww7hR+YeUJisc1LH+XklLHyvnoSe3vC9jYoYkHhZrUDHCzy7dfNxA7s1c0rLEuGx
	yBNb7oiD+qBCUBiDhhFRoPvByI5C3OY5e55d/i6nhx9uJLjaDNRA3CFwur3ZRVzYAS3dza
	PiuCqBYxryCoGkUfMJ0IMowkxXjbFb8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779412813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHNkZOw2UW3I07VSJDEzsPCBLxzvWAd9K3Bgudx7KQM=;
	b=jy/r4gRIe+INC0fMlfJlaVAV5x+Nb+kKW1ZjbpReCKKEkZqCimx5YRDWT3Q3+hCVkcV9UX
	2YgRNKrwM6EBzzzk6gUti1L+SEw9QMo2ynp9MTl9SL4EgNljClhgVgTeceWaHS2AmnOZWe
	xndOWTYnRO2WY7oCNwoD4m2/fxcPkao=
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
Subject: [PATCH v2 3/4] memcg: int16_t for cached slab stats
Date: Thu, 21 May 2026 18:19:07 -0700
Message-ID: <20260522011908.1669332-4-shakeel.butt@linux.dev>
In-Reply-To: <20260522011908.1669332-1-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D52514000B
X-Stat-Signature: 5noshue8ikkrcoiwrdu3mbu93qa9ufyf
X-HE-Tag: 1779412814-970118
X-HE-Meta: U2FsdGVkX19EasS/UZOlDgCzyehBsTKY1QjRMew/dZunuahXyEs7qSZBLwuhNx2l/Oc2s13Kh2693TFBcbNeBsa27HT24aKm9yE9DkkTTpaii3MP20RoMfmKA2VPOR712DWuU3blRGsRXK9ua9qImlxcwyx/rlp/Rs+y14nEymQiQVk+1LmRr1Dn3CIphsQLIeVFE2lfqWxwnN6da/tDIqMGO1llw7txiOBPI1Z52vDZm8rH48FGelZonmDS0vqd8XRB04/N36NV3qrFIGucvIUTBtJscHEK/hNQrLfWGX8aTpfSK6CJkAFntSkeq+KFkzgkTTC6ghNTy6akTcY3eH5jAfpU1yRT0ILHveyQi/J9BCNYKc/OV0Wn/ScXP/gP/6KYc7m3Rr0kHnrBz21umh4eAprmclsqJtU1zJ1/tqF0dwL9Gfm1laMde0SfPDNgV7fj1KDTW+aXn0hxh+PC+b9X2ogn/TXHKj3rQ9dlY3F7bVCKg1gRC3wqm7AXX5NwLbLMmlCJp5w9TEY4gbk/3qybEqxvVoQKWGP6qjR55zk9ZbFPa9iMoPNkToXtPqibXvhHdY+eutQ0P7SbP9FE6uF6bZ6zTor/mqiHRqppZBhm5w5WpvPa69sMFD5HAVp3087z08asSUX9Y3W1q01KjtMxIPaBfFhVttWYwSlb727wq7Mo/UgnAsd7lyrV/6SEAWIBp5e/vO9r/Rj/gMzbrXSh1Vu+zCDQ9RPmBl93c8FzxDPFjB8cWVlPI2LzE7F1Ytsu/3sHoiKs2eTvLJ3qlzl2pIzMUNlCLisw8w5GbRbzUdBe0I6LOhMz1ldPmUpST8uhRuEVd+YYYdumJ5FaC+M9JAiLk/ENno3cy03V6UHHMzWCdit/kga4WmaQZupicUIXt1usW6+DwKqKVMYtoSi4FMek8ILVI2T8iKMuNEg+l47vSNCAJyfPPdoCM0FZb3zlOKsfDO1lGdxW2ES
 be6fAMhk
 GPkaiZaY4C0FQbi+VDOHRNt1+A9QEMNgoGy8tYkH5RgMr+UC4qQ+sKPVPTJpPiWULP0SvwjGONZrTud0mCPOi1kICjnH4oI92ZQazHKw0QcbpAP1x+YmPy66S9eFQ6eDi7rn31wyPTomq5OFmBjZKACwaCKYcN4kZWsiNzdgmVvG9MK8oaUjehqTDHhTRKYyyGPJyoBsK37dbtfIa7nsGz5X7esW7wR4VPJaunNyh0L9v0/Ft8DzbIyS+PadtpHjtdPdEs1/HpvNdpZs8Re8dyRSU2dYecrSxMwJA4xylvnX+RylKnhd3LtuO+Kup1Lnq7ADbK2hYaG38mU0=
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
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
---

Changes since v2:
- Collected tags

 mm/memcontrol.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e4f00a8159d5..78c02451312b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2022,8 +2022,8 @@ struct obj_stock_pcp {
 	struct obj_cgroup *cached_objcg;
 	uint16_t nr_bytes;
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3158,7 +3158,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3195,6 +3195,16 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
+	/*
+	 * To avoid overflow or underflow, flush directly if accumulating @nr
+	 * would push the cached value past S16_MAX.
+	 */
+	if (abs(nr + *bytes) > S16_MAX) {
+		nr += *bytes;
+		*bytes = 0;
+		goto direct;
+	}
+
 	/*
 	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
 	 * cached locally at least once before pushing it out.
-- 
2.53.0-Meta


