Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AD2606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=XKKUgZC1
Received: by kanga.kvack.org (Postfix)
	id A1E626B05B2; Tue, 20 Oct 2026 22:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6BF6B05B4; Tue, 20 Oct 2026 22:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C5B6B05B5; Tue, 20 Oct 2026 22:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFF16B05B2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 459191203DB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:57 +0000 (UTC)
X-FDA: 85345078434.03.80D1568
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id DA51220003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XKKUgZC1;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIfdYuKrZowGGWCzHHgolNoCF8XMtQxMyZQ9b0XJkH8=;
	b=oB+dMFylPq2vv3xfLZoGEjvNpz15qNZcXErdXqvluYH/ltjDeQDT7FS6PRjYlOCyKjJnV3
	MR2zbmKJDmEzmqy5EGpejAEg5fE1GfrrHANZbrw+38AjGQFlwZXerjBtRWFpP7m68soOom
	KL2jil2ilRQ+8aOa8JWUvBfCU+5g2I0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550395;
	b=v50lKqpYjcAvNxNaqDpOHAhK+DuzUBA5+SS542GMDcV6QSVM7VntZdBTg7wcpWqofyHWO+
	hb+99PULk+/6b5yYNOwzEh3VVYNxvHDO/wlu5Go2IjWlokJXy7i5Efdip7fZGiASVWowzt
	5wKTquESJiqC6mbt//gjG7phtSoMcio=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XKKUgZC1;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f20b304c0so29371885a.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550395; x=1793155195; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SIfdYuKrZowGGWCzHHgolNoCF8XMtQxMyZQ9b0XJkH8=;
        b=XKKUgZC161qUsMhoRv0tYjQISFFtXG1932dh0RK55dikmSudCr7BJTvfnoExFgPu1O
         BwvJxuXZZxLdM272PuDL16ogfH9nEN+AFfHF23pw8INLpK0/nRBz+aUSaFNmGg0EmFIc
         pBAIihJHqB+dk/YaTBeBBwIdk2QBCGFuWCeV8cYZ5RxgMQNyfGinfUwiNSHM1MJ006zN
         EFuJ2du69vgaO15b/VsxnTrV4Q8tDXsawIP6MtkWGObJMIME0y3P76U9SBmId8u/oqUJ
         NVtfDwWcvALGD11GRysYBfEJPrzeJpQy+NUyy40sSFUGuWmfHCbOesL3p0rKyEjNG/On
         /dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550395; x=1793155195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SIfdYuKrZowGGWCzHHgolNoCF8XMtQxMyZQ9b0XJkH8=;
        b=wu1+hfe8e6w9gL9BhfoeHclc3Qh9Gp9LD9KKe8IFBitN0IyemHruLi6QUL1vJqdBsB
         LO8Cd/O7OlWSD2qqLs4hu6+FXidhN9yIWfvtlAjNNYklU4hNWTgx9vCeTtppT7L+VNpZ
         kd+kB82soCHEMNysEYjtnp1GQc4/7Ls009AOLctul5xgahE1fkHL5/xEohct3Wo/Dl8h
         O1KemU5BrdG3+XdfG/2wbASpV0NqSr2GxRGTSFnJHqDijjY9LssKkiMNncE3w/WMAN4y
         dibARY/pXrQ5J5vuk2w+UqzHt0OLSOnOfOeEMePRcQyFtYqKxTmSfbJ5PdkREmia2x8R
         1Iiw==
X-Gm-Message-State: AFq9FYJTw6UKpE2GBh97WqVBh7pMHjaq/j0NLJEzyw/QBQVZk38/+Swy
	XIWye4/J8+Fqn6DlarX0D+w4NgJejdSsQTNUQl+fQzQdavBXLkCvpwZLmOFrSzThf/8kKCRWKqy
	LYWjJ
X-Gm-Gg: AYBFou32qK6ywF0lQ8FICP5TJ524QsEqT5EXpv7k8YlIfucfqzv/k7BH/G7SO4TQQlA
	nkxjDAfGkGEpeJJFGU61F04gcf6DtUg8NOxT7J1n3tWDTls0Y3jrugVHyoIwYGYS61up+OaOnOy
	AkluifbR7GqM9h8JVIfZ4aDq+kYi/j4KEDdGaui+2mS6B0gd3duaeBCVM3wVEOPl3q2bwYtISQm
	wpqhNo/7pDLWRRPg+s0Lsgskbj/a7rcfTW5AggmSliKAWS/h0kIQIkkHcs6mCeMISoGXw9FHpb0
	5qDsi66AizbZK/mQbGzs7q0/QYjmxuey0gmRjhMxrStbQbxoOLo97fpN5sLAamxFBkrewpNjD/4
	sauDZi9ZShERkuRW++N/9Z5fovIODIHYsaeIGviEVISvJ40UsCqzejnL1X7fk0vAC9Hyt6kLS9e
	LyqbsLiDmjVIisGoS1Ei5bO6IjHfNc/OqmbIXmLIrtRMXEz3Xc3OFVUeoOWOJB0PYXVJnRyNLkg
	19ZhSl+REvQ9v9a5uasTt0ntE525eZbO7rmRGfNMHHQeuubo5YrrJd2wKHdotMyD3xWD2DtFQRY
	0G8/tflTzF1WGP5W3Mg1IEcj//hRIgFqIeinmuUc4vOExbbDL9REUK9i93YQnFM=
X-Received: by 2002:a05:620a:260a:b0:93e:48fc:aa85 with SMTP id af79cd13be357-93f57f1d75dmr211957385a.43.1792550394720;
        Tue, 20 Oct 2026 19:39:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:54 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 6/8] mm/hugetlb: retry the pool walk when the zonelist is rebuilt
Date: Tue, 20 Oct 2026 22:39:38 -0400
Message-ID: <20261021023940.1940971-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA51220003
X-Stat-Signature: 7n6jbi5oahf43pm14umsr4jqh9cybt4x
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550395-773068
X-HE-Meta: U2FsdGVkX195S6HpMR9LEwiKG+Hfkj7iX9w69c4ohfEZCGklJjEaYBhOdJN8YUq/TaZgE/2B+P9s7WeWSlWbdgM1/6r6pUWA1t3uyCAbRM5XLEaIksFYJj95aOHzAARRcsv1P8mw2AUga8b/G34US2Cy27k4rr1iiEXA87+VkAqO7t7979V6Ocmyo4+yQheDT5y60wTGaUMFTvHbHphIQMsVXR6fOIfQAtitr+bMOteb6cZYQUIhwKVIXNCRWgSixw8G7klMaUe3Guozp9GgjGXDn2lO2lzBdTIOqEkM1kuMApZs+9HlKphpYOqmj4iNeCbkWNo06VnuNUzpJo6I8XXQ7OYtSyLgbypIAtZZrXjkQKmwEIg1Y8rFYb1+XVtEpo8g6x5TYjKn4zk2v7XrOMRCZLLXlg9VtIetJFlS+CJftcL5rAtOn9HTyIf7B5j12H7IFl8ThgKal1EwawMaEqKq9eHiBQI1Vx4rC7htzOg4GTL+Knk/SPhAcIuq8hZBdCkqTJ++xMpORB10Mr/p3FZtGhC8PTAMb69/xoOa4tv483YVYaKz+G4xspYEgJQ2LwsqfKKZk7F1yI+q30wuYfDunA08NPHn5PFY5MpORn57YF6MGBcmFlgAJSgx2PjN9wegihuV+5JwRtO0pASkWbb/gULfOema1W1MWpH91qCdUYpNCZNkNAhOHmyAIjFX1Ixkq6ayP8LjM2dbxKDP/AUEMnWcjzq70ZJDJrHaibKrVJ3qD5PbrVKh4Ir76HteBSCNyhzykM4Z5peIQQyHagZeimYLJQbRyqk7CT4tcYF1vKsQhWl8mCdn8crg7dcInHw+JiiL77gj2ZtczrdvwmJNMS8Yo/uVmRqmKauLeh58eG6njH0KsgMzJlnmACZWcy3Oc7lYeKlQPb7zMKJkrznwWNchDN2KYSVA6m/b9qG9s6YVQV8X1kQDcd0XFFWkanh9lvfQMxgxb8BT7b9
 Z1cV/Rqt
 skm5o0cIzARThV2t+DoGBj6rTLWR4v1wZiBDfh9dKIQn3YHVYoUhr7hEnzlxdDcZ5EylSC+hoHaUUM9O+gXKzFr6NfaRndlyXy1ZRPpAP7dPAW5qk8I8gbk23kxALptbSW5853CTsFJljtV+hqdc1qZnEji4bi4rM1JlDJ3mctAoa3KfWdUSf79avuH5IMRXSENF4iGuJYkfic5DquIfCFqpaX1j7c8jc7+33RmPY2jcUDyNOopNO0Rd/4ZFsommQx5mS29/kY3NIQVTcHsXFYbARAPOxFcyxbBjpY+fcSNhxWh0FTe+xgVT6zaJoEhZBoUeglLetlTKpbaZkOLvK50aUV+/kmmZbQEstE7Jd6tBUpF9bmBCq8Scv1opvsffn8YsTk9VWOphmIcBsBZSWRJtF3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone. A hugetlb fault bound to one node
can then take a pool page from another.

dequeue_hugetlb_folio_nodemask() picks pool nodes by walking a zonelist
with the policy nodemask. The iterator approves a slot by its node, and
the walk loads the zone from the slot afterwards:

  CPU 0                             CPU 1
  dequeue_hugetlb_folio_nodemask(nodemask {2})
    slot 3 (NORMAL2) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [.., NORMAL1, NORMAL2]
                                        -> [.., MOVABLE1, NORMAL1, ...]
    zone = zonelist_zone(slot 3)    /* NORMAL1 */
    dequeue_hugetlb_folio_node_exact(h, 1)

Check zonelist_update_seq before using each zone the walk returns, and
on the way out with nothing found, and restart the walk if it changed.
Checking before the dequeue leaves nothing to put back. Reset the node
the walk last tried on every restart, so a restart does not skip it.

With kprobes holding the walk across the online, a hugetlb fault bound
to node 2 took its page from node 1 in 3 of 3 runs, and from node 2 in 3
of 3 runs with this change.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/hugetlb.c    | 13 ++++++++++---
 mm/page_alloc.c |  4 ++--
 mm/page_alloc.h |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc9..8edf323baf0fc 100644
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
index dd8c9046f9a06..5ca8e57c5fcbf 100644
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
index 2b1017a91928c..53df6b8a0c00a 100644
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
2.53.0-Meta


