Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF89760A2605
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bjEryxGI
Received: by kanga.kvack.org (Postfix)
	id 8C7F76B05BA; Sat, 31 Oct 2026 22:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A32A6B05BB; Sat, 31 Oct 2026 22:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766846B05BC; Sat, 31 Oct 2026 22:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE4A6B05BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D75E5409B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:03 +0000 (UTC)
X-FDA: 85384929966.06.DA425E6
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1A50920005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bjEryxGI;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riPBcqO3vkhc0O/om8wK7f8cpXASGUa4k9CTnWK2v/U=;
	b=KT3wkbtE2nEzGXjfq+AlAQ01t9RYsF1KzzbCmOszFti4gdA+msQh3UTWddn4kKrxPMsxmb
	WnJHp5kdhmcTjehFwtv6PG8BjSEqaiGWY0VjxK9tsc+9hSFC/R1HMo/TIJ1TrrlXzLKXwB
	6392JiUPbjJEC4zQyAKZW6/Qd3BO99c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bjEryxGI;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499242;
	b=Y0+F8k0Cw7HULD4hIAW6CgUd01DCOtCHfVMGfibtJHTxOcuPpXva9YvqeoFoLvoBjsrpQk
	E6gmxx1gKC+zqsC96dE5dPS4gSuDl9T2rr1thn3moCPjOUfp/TXfO+nSOozKarfhEjBtW6
	xwFK/kw7khth0a0XfkdJuwwRfV2xYQk=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-54465f79af8so9114631cf.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499241; x=1794104041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=riPBcqO3vkhc0O/om8wK7f8cpXASGUa4k9CTnWK2v/U=;
        b=bjEryxGIAhCPVLu2M0qeJ2skPQOMFK0PUmkedxmF34/T51Amm4ZM/BUJiEF2TMywkw
         ebkV3o8nn8CfICaPaEj3Os4+DGG1hIJC7Uh5VVsIGEfXt5LkImUF6h/NS2zob0NSAT7T
         SsiArtj8ie3AB7lWURHTL/nPrfwB4+0af0nfkha+VBS3CXYSAQXPTWXPAypNjY6kmJFT
         jCR+zvB8he68gblw1V+4y9HIqUfLozr4g3VtXI/pxOkJvDwlzgABAGFidnptbc48FzPe
         D+o492K946ARImApYSdcgqIzJiQc0DPYyRdwwAleyDfJZAvKwaJnvUw2Q3IDOjR5BFoy
         hQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499241; x=1794104041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=riPBcqO3vkhc0O/om8wK7f8cpXASGUa4k9CTnWK2v/U=;
        b=r406N0umKuH5oHMadpUG47dMBIwI2ED3Sn+qGNpxxGMCryl+l0oEdmnVU1OkW7B1BA
         8/0pDkUIErSw5WwnQfHnqHL8VaTaG52IhcV2GVZGEInLmzqYYYfwfsL8/aKW/nGGYo/b
         bkQuQ9RZ33M7ucz4miCbuMHxey1vK8IKcfWkZdZPuMB/d2eYtnnSD6CMH19SaWV7YMtn
         jFN8lQeCFXty7wsC/hO+J5/QFn6JjauV2Hv2vpkIZciFuZ706C2dBtMFzue845miQ2bt
         McF/JWCosB3PLT+sEQhbyU3tojBPVVAefrhEVSTGoGa10XlXgdghhAohuim3RfhVssnI
         aIaA==
X-Gm-Message-State: AFq9FYLtxitvaIGMEbXdicNhH6SRdaA2bdfGWiB2CNVMhzglPHsXFCXW
	V+htPPStDddlNinORH0c+4eR0suf0wzLxeNBjLctbvh3UNowNNSNvWL0exhrHxwEPj6ibIxJTa9
	A5lAh
X-Gm-Gg: AYBFou3w3t9qsR1AU592RnABYr5XWvQ1QtQHqoHUJ/YedoIDxBfPcIk+rGEwzvynAFq
	jHyUArNh8xmh7ZOfgQW4sdyOJ642leof4LobYsfylTwxPFuNwhSVX1l6e5tSrt7FrzosKFY/izM
	FcmYE9sGCIvEAIsEZgePF0lFH5jiBlM353Ry1MP4FM5jGlY3QoJz3EbgbTG0FDbD9ROzYE5DfEy
	EO6SiZU9WjjddeKgTuzcsOBXHRC8Fx7uws3nMnGhli1c+6LSLCnm+sVhQzd7qEz4SW8WGZLj7Da
	a05QB94dlmELmBKac8jzn7a0oVvWkwou/UahtU+Yu1JonxfdOGGAPXmViqL5TjewrcFspwuy+/m
	1A8Xf0X6B3WvFC3WIpoGVO00VLNnUMt3RuytNpVQblZCCn1iSx6LHTv9p1VH6wLb15L9jKpmU9p
	m4tWHLk/WDxSATRsShpg5INpqzims8hepGG4ncJcZrvhhJPJMQvhMWZVFsurxDvZBkQ5JhNsJYk
	Smx2TO4bk6sUMKM9NUb6+2UdH90djD3gIeji4mbcMSWXe5Gv8N9ghXtvgXvhj9IoSe9jLOLzjT6
	e+a6UUm/bOhhKw0nnS9h6u3bGkSvux8zUWx10HzWiRZ+YohlRNUUaKQfByN0PSGiLBtdZ2u+GnN
	q/rVBM+ihFg==
X-Received: by 2002:a05:620a:440d:b0:943:faab:a144 with SMTP id af79cd13be357-9442175cf9cmr1087655285a.45.1793499241148;
        Sat, 31 Oct 2026 19:14:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:14:00 -0700 (PDT)
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
Subject: [PATCH v5 09/12] mm/hugetlb: retry the pool walk when the zonelist is rebuilt
Date: Sat, 31 Oct 2026 22:13:37 -0400
Message-ID: <20261101021340.2251928-10-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A50920005
X-Stat-Signature: gtd15y3padg4qomhb3rsrgfp3qsp5mt5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793499242-35354
X-HE-Meta: U2FsdGVkX1/S/gz24U6VkrtYVzYy5I5w5pTZ7MN7JaZc7JUk5ZuYFnAzqTRfXO27Lu/ziXGlX+x1Nd2E2UID+5OJj73ppGYP0pO1GNpayWV1YJYVHGESXcq8Rvc4Y+KTo2VwaOOeX8IqiCUL7cO7Uqoa7mUgit3yDyXJsiQny45W+NJtc7nLOy9bTSz1rKrgJgtRTvGHv9DMOPeCwh1fVMmYCzJeGFXk5jt0nRDrzM18ZMvjQmCKjBxcEeiVqZdS5//wsWBJYZAbtciUPCzHe95sNntbKDZBH98Ksi7stq3CspnMLnckWG9xjJRPsPP3mjV03ETOFnFxahjejRu4bQ/5Lshq2PsPu6KcenIo5YfRyf/weGafM2Cwq7H2JKDG75GZ+gfu/ioGM/wBAeu2AtE+ZUh5lgvNx9URnEtETgC/tQrFi0bpWLFl+0z26BCV0zbX/QiCpubzOnVWNtMtPRsrSG32KIEB69aMhXpDgmcHec0KPESMQnsbjvGBAPK4dWVSlJzW39VS2t3i2y6LwekOg86iw7ommEFGdF274NPzVEqFdhFAgXY9tUUw/A9kCZ+4OOdSDNHFew8WsaPyRStBqcRPMfQ0WhwaRXMptLfUfMif+pwjQWqYqmFeyBSfCwudG/ubEzMg6dWzV6hr9bKduq0HfJDKm+IXdwMVNl1oMfgYDsKN8b1z2T+UCJ9z0viVZ/DdmrVSbVvMQB5gJadQy1iUaayMtYbqLRGRY3yh3YYRWHiGdkUJtcKx6WH4eBlLeZNSBnjLP/8FS42zhLn2TSTLBYdbhHJLnJiR/YU8aAQ9Ia+22Zi9V9LvQeiVDb6xO/fnjcbf7PAy/Qp3TnWmYyE7w2f4YQHibfNCOLNmQwBmc7ZoDeVYCESqUdGFTxfXtb5VKgYQawCHlOhKJZodPY8vlp0DImBpX0ko6GH7LxZfWWh3wmZws19z0RYKMblYXVlt/wwsItTfTow
 90uVqVDS
 U+Es0CEzAt/UulGaT+LXqn0dZmV7FYbpVkK/pdo5MhTpmWvQXiWfKeW2+0JcDUlkSDV7ptaSKwdLSoz4249ZFDW4Lm5Lul/CoNzCt5kZIsbv2mlbcs6zoArJu4ro+5/iFx+mwJvlwIo+se2ZCTLhVKpGmPg5GyZBmpUNOuoXraQywRiU4XvJz5qeMQBEpl0maHNuC0zNUp+z3ZlLFDh2kj29Uu/osiPoqwCiN47Al3p+rF8lsFVe+MwRuxsuKPAezew3y8bbstE19Pvp9DHY1S83sav2WtK2rwmHJKMzH2k/EvFoaHEumsvnTc4Usyzgfd7Nyz4A76FOxZs2PzZTWGj56YhGiz9gioHvzkxRV+7UBEb7UfclpE6fnq2uZ2zqTInC2rReRz1DiDL3GHs022jJZiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone.  dequeue_hugetlb_folio_nodemask()
approves a slot by its node, then loads the zone from it, so a hugetlb
fault bound to one node can take a pool page from another:

  CPU 0                             CPU 1
  dequeue_hugetlb_folio_nodemask(nodemask {2})
    slot 3 (NORMAL2) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [.., NORMAL1, NORMAL2]
                                        -> [.., MOVABLE1, NORMAL1, ...]
    zone = zonelist_zone(slot 3)    /* NORMAL1 */
    dequeue_hugetlb_folio_node_exact(h, 1)

Check zonelist_update_seq before using each zone, and on the way out
with nothing found, and restart the walk if it changed.  Checking before
the dequeue leaves nothing to put back.  Reset the last-tried node on
restart, so it is not skipped.

With kprobes holding the walk across the online, a fault bound to node 2
took a node 1 page in 3 of 3 runs, and a node 2 page in 3 of 3 with this
change.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/hugetlb.c    | 13 ++++++++++---
 mm/page_alloc.c | 18 +-----------------
 mm/page_alloc.h | 19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..b8a4fc2a996c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1293,11 +1293,11 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_mask,
 							int nid, nodemask_t *nmask)
 {
-	unsigned int cpuset_mems_cookie;
+	unsigned int cpuset_mems_cookie, zonelist_cookie;
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
-	int node = NUMA_NO_NODE;
+	int node;
 
 	/* 'nid' should not be NUMA_NO_NODE. Try to catch any misuse of it and rectifiy. */
 	if (nid == NUMA_NO_NODE)
@@ -1306,10 +1306,16 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 	zonelist = node_zonelist(nid, gfp_mask);
 
 retry_cpuset:
+	node = NUMA_NO_NODE;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+	zonelist_cookie = zonelist_iter_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
 		struct folio *folio;
 
+		/* A rebuild may have shifted a node outside @nmask into this slot. */
+		if (unlikely(check_retry_zonelist(zonelist_cookie)))
+			goto retry_cpuset;
+
 		if (!cpuset_zone_allowed(zone, gfp_mask))
 			continue;
 		/*
@@ -1324,7 +1330,8 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 		if (folio)
 			return folio;
 	}
-	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie) ||
+		     check_retry_zonelist(zonelist_cookie)))
 		goto retry_cpuset;
 
 	return NULL;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f2f7e96bdef2..242bef2fe400 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4409,15 +4409,7 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
  * retries the allocation if zonelist changes. Writer side is protected by the
  * embedded spin_lock.
  */
-static DEFINE_SEQLOCK(zonelist_update_seq);
-
-static unsigned int zonelist_iter_begin(void)
-{
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		return read_seqbegin(&zonelist_update_seq);
-
-	return 0;
-}
+DEFINE_SEQLOCK(zonelist_update_seq);
 
 /*
  * Never wait for the writer, which an ALLOC_NOLOCK caller in NMI may have
@@ -4432,14 +4424,6 @@ static unsigned int zonelist_iter_sample(void)
 	return 0;
 }
 
-static unsigned int check_retry_zonelist(unsigned int seq)
-{
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		return read_seqretry(&zonelist_update_seq, seq);
-
-	return 0;
-}
-
 /* Perform direct synchronous page reclaim */
 static unsigned long
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e238ee91ed24..10a40ead6c00 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
+#include <linux/seqlock.h>
 #include <linux/types.h>
 
 #define ALLOC_DEFAULT		0
@@ -265,6 +266,24 @@ extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
 extern void zone_pcp_init(struct zone *zone);
 
+extern seqlock_t zonelist_update_seq;
+
+static inline unsigned int zonelist_iter_begin(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		return read_seqbegin(&zonelist_update_seq);
+
+	return 0;
+}
+
+static inline unsigned int check_retry_zonelist(unsigned int seq)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		return read_seqretry(&zonelist_update_seq, seq);
+
+	return 0;
+}
+
 enum fallback_result {
 	/* Found suitable migratetype, *mt_out is valid. */
 	FALLBACK_FOUND,
-- 
2.56.0


