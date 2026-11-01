Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6B5606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=LnfJkPOc
Received: by kanga.kvack.org (Postfix)
	id 1E93F6B05B9; Sat, 31 Oct 2026 22:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFFB6B05BA; Sat, 31 Oct 2026 22:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9776B05BB; Sat, 31 Oct 2026 22:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33696B05B9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E1031A0876
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:02 +0000 (UTC)
X-FDA: 85384929924.28.FEA32DA
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8094EC0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LnfJkPOc;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2CqNGtb20G7+NWXUngS5SFkSTjGBoouQclrEPz+fGk=;
	b=yyajEGEnjwBrUCFuiORiFJILmalkIyNY5qAFpWhJMGITGf4kltK9yyXJwwg8y0LK4ye0OD
	hOpNf0KCpf/PhlYVhtUf0D1YSFJO9LeKRTFcKBARh4mPpmLZd9gOjA5ZnQxJHUhpEcF89l
	yHTFlzDNysH5MkmVFiNp78s9uuIjPHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499240;
	b=Sqp2/mXc1DVbDWxVjYip89lJj2XbDNeVlJiJYg2ZEuL5sPAosOqtxe0Wl5hARjmsajkQdq
	1y3vVSdA6du0+XBYLmH4ulA6TfMzJx7taqdyjpoqLdInsv1rDQcTrFd+dNe4DSAw7jUSMm
	vw5MQq0yev0aFFkOiE93TVeaNpY2Wac=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LnfJkPOc;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f1cf92c9eso184308285a.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499240; x=1794104040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j2CqNGtb20G7+NWXUngS5SFkSTjGBoouQclrEPz+fGk=;
        b=LnfJkPOcWU6vqyxwPdmg8kjZLKXelTb7f1mFrat7mdQ0cQOnFGaqk6SxITmjxKx352
         AqO1zCDpB41RgJuqv4SvpRhwXy9i5vWdacIu5eiHukxRaNj+qNiddFMSyr5twJJBe9H2
         nsYbcLqE2Qj9xZchk30SRjTkkz8SC9qc2Ob6gs986UqXI+AkeFRDsGVH2n66MkglftAs
         A3gmZKUbPA/wpPtw+5+GhQB8g/NAUs7sTv8okulBVbQ7r7QQmk7FuSJvHRgeh+dTmYvG
         5jcTsSZmQSST2CpvShEemVfjyit7j0td0l4RRtsHYRGNkf4K/46Ls2pBUCaUAwB4ulhi
         R4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499240; x=1794104040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j2CqNGtb20G7+NWXUngS5SFkSTjGBoouQclrEPz+fGk=;
        b=UR2qdzeW5lJomLOzcXlR9NDTY+3BlAB6QPPHJo1VBnjOfTuX8QQglqROrt+nBbu0dP
         MRs/N49vvYIVwZ6lywWMjJcPgmquGnilJsJdrPiOLG1cPDT9q+zYTl6ul81iHlRDO0Ek
         U+V3KZ2cBvmE2QpBfI8EN50sB5s84JnVlR/vuzJF5b3ubflIBOhLrUWTqI8ZsMu41mLi
         CPH1jkfUOYFnYNBiQrNiHDPu5RcF4l2FfM8nhGgRAqmr+ftgAZnmgYhUP5+CGlUPESLk
         f0RGqNMYjRe43V6/G2choBE1kjokO5XmBRAJ6/zoKjAx+1vMQ6w4QwUPPnF0Zpcdrxp5
         PYjg==
X-Gm-Message-State: AFq9FYLzv4qEjjkMJvdzJFLR9fhzPLHYTopiVFFacTEg+5KFOqsWAz3E
	keRn50hFPRbPqqrT/+iq2sf+rT8m2ssjzETQaX9Duclu14fiOhdwrPmZaihduTR8L0p8zvz1bEg
	H/V2m
X-Gm-Gg: AYBFou3G1ZMwrJD21gAZzZ+rkC9WLvdvN1h+hR4JCt1evXe6TnNxdBYIs7ucByVUaI9
	85T72GT8Fy1lkSpSY04XoMFpumvd5oQyuClRFt+LQRE6cle5PWm+0UeGVvTcDOCYvGS5Sm/IaOs
	WtniY7XodPuhxbk08MTyhzRd6EJuTpsR2lhfGhTI8b4vfR2+oCFmgrJKpyW/kel8ys6XROupM9Y
	+snFkqzQ+eGc2gKd68yzvDayRmOG7ZndHE3kHE5XjR4FFxuIY9pbRfsMW88Ut/i117NsXNdq7xg
	evYwx9BkmJoBaA/OQKiqlOwnvXi34Fv3K3OpRc7lVex3ROmSC1BO7uYfBjXzIjd2SPo6w+KCEsT
	D8XsMwbaFxtaAAjNP10TboPznf8yIzOxwy5NMGK59zqwxYOAUg4JBobFv+4cVMzCPiBtEx+Mrd6
	ooN+dUB5LasS9IrkzhLhfZksX/SIaPCOXNa71E3RhLsLvDEcHsoVnnQuU3DUR+VEKmgU2FQtJxD
	7sysl4a+f8+595+Oo8pyvxk2EH1JxC9MFRGfmyhqeUFeI//4EadLjO8jyyzYxrOBMFNVOhNGnCk
	X/7Oe+wMtC2O8UqOyGi9vnZ6cvaLwL9CT741X/huBB7ZjroQIK207PjSjF5F5qdS7ooykS0TDLF
	gwlej78w/Hg==
X-Received: by 2002:a05:620a:460b:b0:940:f224:5a70 with SMTP id af79cd13be357-944217f9c7emr1111740485a.72.1793499239606;
        Sat, 31 Oct 2026 19:13:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:59 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 08/12] mm/page_alloc: retry allocations that raced with a zonelist rebuild
Date: Sat, 31 Oct 2026 22:13:36 -0400
Message-ID: <20261101021340.2251928-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8094EC0003
X-Stat-Signature: yje5uunste4mt3o7in4wjsgqga4t63ms
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499240-630307
X-HE-Meta: U2FsdGVkX18nwUm+DVyiBwJU44RtXUmVkmQ5fmxhS1U0Qxb9toj0gvFTepeZUoDD39pdS1fMOr/YORWmBUcFugUMn+zXWoSI99e3hL40uiVUQxtG+uHf13mqlT5J15zH/U7GivafRftUruJtqaA1jhTGQIz5weLjgOoSpPpNG8aTWIcml0HcMRte1TDhbLeu5r09+sTDzK0j7X8GJLKkOeSgwm/sFb6zY4prwaE7BAffNTEtKHM0B0CcBdX9H36bS7lq0HAHTmyiZfxareWCkyplqknaDmQGnq1nOsJJE4CH+k72BkjmKBvQny7denIc17tEQAB1MSrHyOJ/H1XWw20R/4p1hY4h6EGvKieFDUwuZm66h4jTPK8tNg99IMszmW/p5k8EtXl4DwLzngBm75AKuo51MEwMurnrnZmbXw3Zb7qx9xlro6GGm6BkYpVocFwFRGY0doafqjNU7c9Ar6PnNkewdiswZkYCZg5ZD0ricmOsz/WLmY4mltIXbnx47ZEWkiMJpTk2YKTQMoqfZmNDNBC9eZcpX1zGOAjrsHevXhJKQZbt6xls2fAdWzWgAFCyKpv9pI6HlYQvXDUybJn6A4GQ7V/ziVUj5S5u7MthmV0nyY/S+c0kBWTDx/IvlFgLqvQYXlQa475sADcwS0THPG0q74woqyIjisVb4MIaK95r/CXjfaa957adnEYQVSlhAt1/L1GEP7R0P/ZZ3ixZf/EQqGTZ3vfsaW20VNiZ39cwfConeuQMPR9jGm7zfZhBh/xpdCbO5o0U0gZ9bYp7fETqICI84XMSktS6IWDiNmIYLqtyQr93R3a5Eq1YBXl5VmU/sZujcFd3OjlM2PIIEYJ1acW6fDJo/4ZPudIxxBtbbnami69CzUf1TvbHTMTfMo45JSENFg3pbZDRotyzxtogdRXLucS4+CkYPKlb5rVJ+IwzsaVd+S+LXrJLW4l3bOjB2d56reJImEe
 E0/eGzzU
 UqGVz4UU9f2WW8ZZUHS4QEHMyeIWCpAonWkhql1barZeWt+KQUidIYw1hhketBEs4/kTtzHicA5J5i1iAyTm/1DcCoLDJMNB4EHpR8zgeX0w22adz9gpXoWcJxdYuFACnae4JP5HDRtQfyRE9rZ/ryKJUprwQtMRPJG4l+OLx1e6CY+6XIUZZJYRE5qN6IiA/g4nSVcCHIM60++soUthQIFi85k/uNNG/puIJxXfN5wBe0B334qr6tfkRRTxvYYKxXX68L1clSNeJMAgovhqxom9G3ixhhQEcLDaYPIheDAcVTbCPKjuQVXzDgpHg7/U0rhSI2e4ZwCok80uLipSszE4qWfEq31TbVyNxKg0qryUE8dTRmAb9PjQA0kmLbPGaAop6nkPhNQduHufuIliFEEtiEGDBLY35AiLL6L++C06vp6BSWpvuH5VKnQhtmsKM2fud
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
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 28d46f987685..f2f7e96bdef2 100644
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
@@ -5100,6 +5113,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
 
@@ -5184,6 +5203,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int zonelist_iter_cookie;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5224,6 +5244,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
@@ -5273,6 +5294,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	if (unlikely(!zone))
 		goto failed;
 
+	/* The zone was chosen from a zonelist that a rebuild may have changed. */
+	if (unlikely(check_retry_zonelist(zonelist_iter_cookie)))
+		goto failed;
+
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
@@ -5413,6 +5438,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		.alloc_flags = alloc_flags,
 	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
+	unsigned int zonelist_iter_cookie;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
@@ -5442,6 +5468,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
@@ -5458,6 +5485,11 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 
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


