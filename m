Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F39606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=H4hZjc6O
Received: by kanga.kvack.org (Postfix)
	id A16ED6B05B9; Wed, 28 Oct 2026 17:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978856B05BA; Wed, 28 Oct 2026 17:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2B76B05BB; Wed, 28 Oct 2026 17:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E46C6B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEFE540218
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:42 +0000 (UTC)
X-FDA: 85373301804.24.B99B52A
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04792A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H4hZjc6O;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLRMYXw2Xkw2pXty7UKH07C280BxIvWbV39DTe58Hq4=;
	b=8SX3dsJObVhDody9URWYSWva/NJ+wUVFVNukpLgZhvuuMK3JlVqUZLVLcYXAb8HJtjbUIG
	kat7Bzg/GtbZvrS70/UB6Q26lQKrGYjJqKkyBLNulYz2bZtwm/oIR/3i9HAJoSgnMq5fSK
	CqXFawcW3SOoJZKYEbhUUw0LBWnKH2o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H4hZjc6O;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222381;
	b=FNzGC7kzoAZECvvPA3nQXTXFyX17vlCYGElukCqC/IurSmJAb1B4milns73GFE/ELSOUIT
	1ACsk0SW2Ya3u5z5FFTJRnvF8CIu6oqurWttCNKj3A54YS1zFE9O9/mfNvnBhEA0gvTL/K
	AE5XKZi1RCjpnp+32dAULOKkv+usfQE=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91b9e758c50so1502036d6.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222380; x=1793827180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yLRMYXw2Xkw2pXty7UKH07C280BxIvWbV39DTe58Hq4=;
        b=H4hZjc6OEYnH5xj5gHzucDQcRSFLNr1XOPW99qtJrB/MmFa+rif2jZgYANOYL44yzK
         j/wU5tP1gu9YyWWkPlIEw1j2IrivQZEQkSO7sfkVrjR5HaTZvhOqPklppqrrEKN06Bu1
         thomkWain0p87CYrWTcyptFcPzBxgniPFLOwCTbKrDLDCE2w33IxCgVVCinK4jG2NvIv
         +oF16W0yCpXZz4L65/JSZLc1ARTIwdK+CdLgCMyjUqknkaNYvDmpIwoERLqVqUnrX3kj
         ZsT+i/iaPTNGSCTvm3AW5wTb/ln1dB5T4ix+b/cUsM8941OUrVa4K6/rjGa6kcJKbdVs
         n7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222380; x=1793827180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yLRMYXw2Xkw2pXty7UKH07C280BxIvWbV39DTe58Hq4=;
        b=Qq/GF7/3EwSRS7yBvy3TJk84k/eugeXSIbyJM6PwuLK/sCxn2RjxF3voX4SoNhwS+i
         Rk/4XUr8Jrct3RbEd/tw2Uq7ABHFgEwgBtJfycgjP3GRQ2TZU4pWurzX9KOqF1Uy0ygz
         +oHDSkdzL9kL4tmhi0YjAt13iVjSR+Dcpc8jjE/QMDVNt7J31LI5iIhPzkizZj5suo4l
         ifc3xcTbHD061+ZTHHrMxb4ST7F5l9hf48fchyuW66AeKU0o3eyJVUNLWhb34gTW8PWk
         lp0xzRwmNwGNMtycwA3QG6oF99ZHb1YwbmpEg7cvqwXVO1kiJDOk2CnQhZeK4bTXWtfr
         Cn2w==
X-Gm-Message-State: AFq9FYJAfOv1TabmEAJ4OcNdQmK88VAyFecyPP0vuVX4RvDHeL7QOWXB
	ABbf9rVygMKBq5At7OaRqqnbhXTO0w48dkpvTJGEBoeAs7zzTWEK/8g2EkFQb8ktwoG5wK36Be6
	ezAdMSg8=
X-Gm-Gg: AYBFou1hLtyD82Bc9lVqVB9lnoSyGSpdeVaNXof31vJUJpghSR2jPAMeNoo0toLNXP6
	jl5FMeM9GBkhL9XFecTtRvIESJJzJax+dJpEzWe3GfuWpQCs4EQwuwFdMSN8mj2U83PchZ7HrDw
	jn+Nd9rgJco27Px4zlm5lFVAhWBIlQ1ISP3r7CPAlWL8JJtQIIMYG+oiIP0gwK80BbpXUn4FvBU
	xsql4mbgv1FJIhGpuiz/257G1ZbRkXQFpqjt2qGC7ABhly/JEWAvOOkjjMltn6C/CsW3o+7j01Z
	t4EOk7H5ZHu9W8L4E2tEruB2iAfVxfenBqJYemtcYgOpb2UV4x9VqiHX9myEddfi4ugIW0yFyS+
	r0mScWAsHl9RKIMoUkhxXwKxcIFeRwLzYglBm242lVK3cpQcbl5p1qcCTRukyXCmlRO9O8sBLER
	JyasN7J9mc/0l2soFfOZ0Hjugryr9usnY+eMiKp3xbpSq5tBwA3wS5rS1CK+uf/+RtWy41GKz73
	+dsG3mGoh6lp1Zc6d2SBr4cN0fQjz+m90JXsRjuffXHNElPJ63p43hoXk/mulnu3upBZIU3fhjw
	b6GEYZ9ulbLRON3TPO0QYs3/8WiRJdiMUS6luOv4A/pmQ6PpJdvtCSBtCh/CI1RIl8B2lBWH0Th
	JmMgwQrsex8g12oU=
X-Received: by 2002:a05:6214:d86:b0:91c:7a4b:fb7c with SMTP id 6a1803df08f44-91c903f4427mr14649536d6.11.1793222380129;
        Wed, 28 Oct 2026 14:19:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:39 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 5/8] mm/page_alloc: retry allocations that raced with a zonelist rebuild
Date: Wed, 28 Oct 2026 17:19:27 -0400
Message-ID: <20261028211930.3504634-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 04792A0002
X-Stat-Signature: x1kuguimqwrstwwe1mscf5bf4iib1ri6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222380-117271
X-HE-Meta: U2FsdGVkX1858jQNLuqJcntiF175W2C8q05UK7CbLK9gWCWYIhsIqIjahmpjIXqcaQjEwwxdFOYkDgnorth4gkL88y7aBW6AbcXP02billmwvbpfgYvwl+97Li5JyKU/9gMJP8d8t1xWP0abCWGawUIQLxS9O1K+Id6EBWsaw6D+T6apiVtB6+XXWYmiycP5qVphGFny2Ij8jodkdMDMQwluKAo5gmapS56ulE2kR95taK4Usw53YoMtZfoDyENHTaW6wy+yrQ1Emh+D2KD9o0XL4bq48CQw3ekvkeiwFX7CtowiGqFjTCtcKpfQkmGHfr6nzeexVv+QKc3+v5RzQhVnD4CJTGGyU1cXvUmf7UkJCec4AU//fzLX5BqZ98HD1jr9iI9xPhiBbjbIi9+fBiGu5B9O5Nl7DtZwk7HIZ41VE/bDHXXVan71goJIyQeviTw+4YZWTgPQx5qgfHQHhPxMMOV9wDHrlE/vetXP/84MSSwm3F5boPacXSrOMMN5w7QFD6LS9wmZl7Upw73xEc8Z9let+UTIDYTgfyVlex1J0EIaHNrR2nEx8+wj+Px1xh9BDGETVZsYI9kjwBV+RT/Ms9PeObIIvs+kViWYGrolffBRzirtCKQMSiMd3EAd0c30ahoQO1CH6BqAbFVGf407B6IqqFC/vK1uzaKeCQNtjDyoOMV4o8Xh2L8dOep0B1usLpqj9YTVmbgM7pi4PZG/FsYgvHL+U1z3aHhDPzindlWZpDTRpZSWNbIcmIOl3pudc1I4GI8COmkTzDhCZEdyuU0n2kbZ0Ut1BpQ6/7Lzenp0DgIma/jL+vrljQTahSoJ9erVwpGLK4NWFoAZh3gl/jpmHsHhroUSs63Oe9ePLfrnypZ1oHT3OWVg1GjbiMQCGbO4+6kkN6TIWkAjpPRcxzzdOQJpUVhPYaHlBKONHFUpxL8uE89UA2JKVoyQWrOwU+dtOYF8WZS6ezP
 rR6zp6w3
 oQRY9rre1JGxKOQOFswulqt8LbsePe+GbQ5RS9E4CGAmR10wnJREM8znZ8fncwmUKSp4vkZTipGwn4ezCoKzaGriw99GtDw8DA9u7jH3G907qRuDJEYT/0J9mfIjDm7ehH/cLkG52szDsL4K8szoway9uedxnpHaHjJSPAYpr0lDVH7mbp32VBid5PG/7LlnUCSeaDmGpMmYlTcYUX2dCUwULO+jr6rL7vMogKPkYbLoNiHagUAm74i3MbDKARLzs7OZlFNdybg2+iCyaY5bWoRrhXbkNbjrqSyrjPYrgZDyL2Waydm8bhilgT8MFRYHCUJjQnOJZdT5etm6ZPVSRX8crzWsHrvjalpazBAjt+B/H35KO7amCotOxmDoVk9flwG8uUB22n+Rl21FoSVW/21GMid5cXhZ1fbIKI3bCQ/KIn0kytcZ2LkaA8bPtVdW0Uv9s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone.  The iterator approves a slot,
then the allocator loads the zone from it, so a GFP_KERNEL request can
land in ZONE_MOVABLE and a nodemask request on a node outside its mask:

  CPU 0                             CPU 1
  prepare_alloc_pages()
    first_zones_zonelist(nodemask {1})
      slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1, NORMAL2, ...]
                                        -> [MOVABLE1, NORMAL1, ...]
  get_page_from_freelist()
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    allocates from MOVABLE1

zonelist_update_seq detects the rebuild, but only the slowpath's failure
exits check it.

Check it whenever an allocation succeeds too, and if it changed, free
the page and retry, as the memcg charge failure path does.  Eligible
pages are dropped as well: zonelists only change when memory comes or
goes, and a retry is simpler than rechecking the page.

Freeing the page does not undo a block the allocation claimed.  A
GFP_KERNEL request that lands in a fresh ZONE_MOVABLE converts a free
block to MIGRATE_UNMOVABLE, which stays until the zone's movable free
list runs out and a movable allocation takes it back.

The fast and bulk paths read the seqlock's raw seqcount without waiting:
an ALLOC_NOLOCK caller can be an NMI that interrupted the writer, and on
PREEMPT_RT the seqlock accessor takes the spinlock.  A sample taken
mid-write costs a retry, or NULL under ALLOC_NOLOCK.
check_retry_zonelist() returns 0 when compiled out, so a backport
without the hot-add change stays harmless.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 24106c881ec2..33aab9deaaa1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4419,12 +4419,25 @@ static unsigned int zonelist_iter_begin(void)
 	return 0;
 }
 
+/*
+ * Never wait for the writer, which an ALLOC_NOLOCK caller in NMI may have
+ * interrupted. Read the raw seqcount: on PREEMPT_RT the seqlock accessor takes
+ * the spinlock while a write is in progress.
+ */
+static unsigned int zonelist_iter_sample(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		return raw_seqcount_begin(&zonelist_update_seq.seqcount.seqcount);
+
+	return 0;
+}
+
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
-	return seq;
+	return 0;
 }
 
 /* Perform direct synchronous page reclaim */
@@ -5115,6 +5128,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
+	/* A rebuild during the walk may have handed out an ineligible zone. */
+	if (page && check_retry_zonelist(zonelist_iter_cookie)) {
+		__free_frozen_pages(page, order, FPI_NONE);
+		page = NULL;
+		goto restart;
+	}
 	return page;
 }
 
@@ -5199,6 +5218,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int zonelist_iter_cookie;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5239,6 +5259,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
@@ -5288,6 +5309,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	if (unlikely(!zone))
 		goto failed;
 
+	/* The zone was chosen from a zonelist that a rebuild may have changed. */
+	if (unlikely(check_retry_zonelist(zonelist_iter_cookie)))
+		goto failed;
+
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
@@ -5428,6 +5453,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		.alloc_flags = alloc_flags,
 	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
+	unsigned int zonelist_iter_cookie;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
@@ -5457,6 +5483,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
@@ -5473,6 +5500,11 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 
 	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
+	if (likely(page) && unlikely(check_retry_zonelist(zonelist_iter_cookie))) {
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
+		page = NULL;
+	}
 	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
-- 
2.56.0


