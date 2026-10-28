Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977E5606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=nDvLHPFX
Received: by kanga.kvack.org (Postfix)
	id 2001E6B05BB; Wed, 28 Oct 2026 17:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189E06B05BC; Wed, 28 Oct 2026 17:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052126B05BD; Wed, 28 Oct 2026 17:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEC506B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A1221C2762
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:44 +0000 (UTC)
X-FDA: 85373301888.18.5ADD498
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E6A31C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nDvLHPFX;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIgZaCWO7ouB50zgNC7x8DTFvAXbflI8ZAgrOwWkY6A=;
	b=MWro5DHOoiyowJEZS3wdd76LZFuSedcpZf2ng61sN+6lcDRoM905KfkRxypPxFGmoOMueT
	FUMq9EV4bsSQXLS75izuMC5NyyKK/c3P9sdWAQyURD7pFzcEyh7HJ5gbJkX3XvDmxeyx1V
	lr2e6yUGHjslUPpu7O4z0N35YUbKN7k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nDvLHPFX;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222382;
	b=D68y1cn8wpINbbq+7CWmqNlzkBwlME4oesVav9r0LO+3CB1P1IsYOmzofJ0QJdC/AArJcR
	tiO3VZHpoDVbRvOSdM4ceC2Ql/Gafu6ucNbRcAxz8zRZVIfNPQuYcQ1KJBnj5AFlxa83Ai
	mUx3HGECD61NdQg++4W7SmpoianJ8so=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-9196d8543cbso15071806d6.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222381; x=1793827181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZIgZaCWO7ouB50zgNC7x8DTFvAXbflI8ZAgrOwWkY6A=;
        b=nDvLHPFXx1fXhlEv3h4idpAt7XPjxDYkrKp06a/ZXI7x3/p7ro+RpK9mulwTZaqpYv
         ApuCNOsyyuTN1Itu6UzUWGOBHZBZY2dNNJyBZBKox+44anqb+1ZiK7N2VqCwY7seNFqq
         2ypIWsOpt2EzilsTPvz7kE7XH+mxVSM4m46e/2GLpFhfevT03HUQAGiU6u92B1HUUMzo
         ZIsuhSA2NJOBTgaCoFZZ2zYiovnac2SnEkSWEfhaPHdq1a9dUDAlmE4EmQGG8tjQ83xr
         wRrSLeQWwV83wVZB7AulZkiiVNUay5Sdi69f9aU928cbxNodtv74cl1okq2NRevEFiKZ
         gtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222381; x=1793827181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZIgZaCWO7ouB50zgNC7x8DTFvAXbflI8ZAgrOwWkY6A=;
        b=Yve8gq1emQNxM/jJVMTgsMsyC6hT4lNSfcq2HizEgt5vmtFXnLvx/e5iCWIwhi/Mlt
         2vhwPa3ciNzzMrN85plhkvP41Kayaf/lW6Kl3kGhsuT9+b7/7o1UNo9KY6t6csnAGnZu
         f+6HWe5xACWJiLjKmzfY0i7XYEQmkfWhrXBM5R5gadijJPBcTsgv67d+ZH3A9kSzgGjB
         GqUGqVBXjAp4pmuv6fw9vii6ZyavPbR8qkHC3ZHObKT8q3hrQxS/42Nd7O4W6NZ8zkkf
         y/5SdXybueGax2W9jnzauDWHYfo/33UfWXfmtArHKEMr5tCtmv8wixdJn+45tMPHGBSy
         z3nQ==
X-Gm-Message-State: AFq9FYICQ4noddRQHmh6SxrvgUL2xGjDxGVFLJ/sncKDQZ3KKT+Mn1SU
	5QrrqA4aygJNYuN3wBhWWGvavl/IAyWY50+TOvPGmT6Lf75ojXg7/A4cM4egU1tO9Uz7y003U2V
	arC6L9cM=
X-Gm-Gg: AYBFou0BclY2qH3UQbg8rZNgDcndOZNCisqdP/vEV/1oZEOPqk3osXXFcAgfvq9Pzes
	XMUbLASqxIEqGBql+TrmnOFDfJlLn8Ytuy2o+n082enAeI20QnOtcDLv7QeUDLbvwBeek0yWc24
	KlzMPyX7/Ng4W6Aq3ZwjOkA3VMXr6tvkwwkUZ5JltWkAXT4IUuEC/ie1sporfotzgWpC5gS1JNe
	GvzLI/IzHKmt2pNEaWOesWGseneIg04qzh6cc5+ghtaLgmfvN6Rzgsd35ZdCyuCFEpe9poDGEPH
	4Oa9zjLpX7hBcyZ6XPbsB12YlJyjTOp7qoJFvIxuvbcn9amNY9BEQ0ZWQ/pQVrWxOmiODy1urcS
	1LTCSTaq0QqWdMcXfG9Xt7DGsbSVrjtD7OqTWvheKBmol/jb3vdUxowUrVE3kE8bg7u5vy6auOi
	kJt0+yJgndY44mY4f6nd6w1D/VhqW/WpJ+2JL//uZBn5P5kUe65AIamXzBucPXFR42ijv7byQFa
	7H5AX49rNt3AEFhjy+qHzOwtpL4IJ3XdaYYUqVODVWYRifAV+YOcikH3rxlv+fB3MvXirFy4QW2
	WATI0pSu/eYCId6WzKzy2kxWKUHTW8WaQDkq5fbnHAzpPHB/PaLUw80xiwZFaCdeoJKEjzvCpET
	mPKR9TzhkgvAbk9k=
X-Received: by 2002:a05:620a:2629:b0:940:f224:5a85 with SMTP id af79cd13be357-94408d6a286mr556498485a.71.1793222381385;
        Wed, 28 Oct 2026 14:19:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:41 -0700 (PDT)
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
Subject: [PATCH v4 6/8] mm/hugetlb: retry the pool walk when the zonelist is rebuilt
Date: Wed, 28 Oct 2026 17:19:28 -0400
Message-ID: <20261028211930.3504634-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E6A31C0006
X-Stat-Signature: 8sqwyzaynfd4dm3y9wxqbb35tc6zrhm5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222382-750084
X-HE-Meta: U2FsdGVkX1+gSWUDNCAI8HfZ9UE1OlR6bkzcTnhULt1Vssnc9KDem7ntyROxz6ZdtfnSkcIu2CLWEYG7BQI/nFpbcmCXsDjsBVGTEKA1uBdFN8yxcqariHyBylCtJex2w0esl0hMPj9EcCcIauIICTBfX7o+kEKhdlYjQdOdDGO3fm0u+t4jH8V8pqJfwAeztBAWIZxlJQLuwUbNYu6HPYDTdby2v3gTG/AUQ8K/w1jlzRveXo2SMkdevEIB+pjVbb8ga2DSBPQvoMlkfHdHi9RwOxwvzlw8yj95/wcpWntwMObxu04IqKnm7vou41hLg3bjBIZjQDy4WBVdopdaFb6LDjPlP5fG+T6f9I5Jloybjhf/oAGq+JUNXbAO/++DoHWSBWXjKypVZTOnpMBwuJDsW0HmumAbdQXyz3d6UlIdaNUctgN2nLpH4Ver4nqA0mu64qCUHMz/xYqy4lauJu3dclm0pNdawRUdTeWUA511RAZqAqJ1ZVCQhfe4GYWM2hiOdkZ/73oLylyQruO2RblKPT9UwG4Ezq8+ab6iZ0ryKTXPcQ6/t0zMCthPfVFD3IWCwxWFOXLlW0MX8n27XVPP3H8qZb3QqqMeAt2T66miN657Iq9zjXQR5fJRlxfVzmY3/bmnP7+iuZyqe+tsOf3oJWmCTt+JFoEycZeW3mNrS5gOm3sK/zpxSLvwp5XvTbQ5JAmrKUJPmF9jBzpH8Qd/U09cg1NOE9SQlIDwOjM85V5cfPyOu+Tyqi3pv+t6ngE2vCuRsTly0jBHQ7KCCPJSWVg29TLTUvRw3ipDLvgd2RL5GPVkVW6bAK4U12+MgEYhvUYni7eHCZHyIVF3xrlZR8lQ5n0xz0mFUcy0+0zM+L2tzx8D0T1TsG5WlLX/lEth/xCBCEsuXmhYYjWaL0XnARDQPUvNN73AAtGJJ+RLy1iqhIC9FNdkYi7rmsCX0eItB2IfBQD8OpdwmqZ
 kgRX8NGf
 GgQ35rV/TbgyrWoa7eQUtbhbcqwtCVNvrU+JvNGRT9OJ9LegJE+/XVTuSlBl0H1aC6NVEkT8+tqZOJbYQDFJfXwNAlWFYidATZ/ijYDR4VgI7qNW5cm+ohhU+7EpP5ipu+97jyiMJLXhHBmuMSTeGMBGKFVqvUAYmpY6V67tKvvCvyyCILvb9m6kta34tk/bvEWhxvAAazxQQwR7ngPRo36kpUxFxmPtK8kPO0AkJOkKEiYPkU7WxMmCWqLPZIA/IIkGqjkmUwu/24HoTiQq47oZyUTC14/8L657E0SKWq/i6v8fZBcokaxDWLa7OYuawt68UDYMIMAOtyHQoSjhpl/whDS+0GpvIz1VS5Kx0ALPOk1sj4cUzoU/2U5+1E54hPb1wZKq0beMksIdiMSlXF8LTXg==
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
 mm/page_alloc.c |  4 ++--
 mm/page_alloc.h |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc..8edf323baf0f 100644
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
index 33aab9deaaa1..70830689048a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4411,7 +4411,7 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
  */
 static DEFINE_SEQLOCK(zonelist_update_seq);
 
-static unsigned int zonelist_iter_begin(void)
+unsigned int zonelist_iter_begin(void)
 {
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
@@ -4432,7 +4432,7 @@ static unsigned int zonelist_iter_sample(void)
 	return 0;
 }
 
-static unsigned int check_retry_zonelist(unsigned int seq)
+unsigned int check_retry_zonelist(unsigned int seq)
 {
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 2b1017a91928..53df6b8a0c00 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -265,6 +265,9 @@ extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
 extern void zone_pcp_init(struct zone *zone);
 
+unsigned int zonelist_iter_begin(void);
+unsigned int check_retry_zonelist(unsigned int seq);
+
 enum fallback_result {
 	/* Found suitable migratetype, *mt_out is valid. */
 	FALLBACK_FOUND,
-- 
2.56.0


