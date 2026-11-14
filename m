Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4A4606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=loe65/hT
Received: by kanga.kvack.org (Postfix)
	id AE25F6B05B4; Fri, 13 Nov 2026 19:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72BB6B05B5; Fri, 13 Nov 2026 19:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E6C6B05B6; Fri, 13 Nov 2026 19:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 574576B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:30:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7841140169
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:30:00 +0000 (UTC)
X-FDA: 85431842160.26.6613A4D
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEB93140009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:29:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="loe65/hT";
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616199;
	b=sCcjBHg4bTalVXq9p3FY39DHV/G0kONlG8wKLgzmcVeQMG2pr6879jNTcOMnp2lVrzPpL+
	hmMN5Z/yRfBfk/U7HcvHQgJ8hLZF9skDhHC8kgVD29u9sSy9EeWTSpDY12jMzOgnFww3CF
	5NbUwfY9lCkKN7DLLb76I/EFgbJTpfE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="loe65/hT";
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
	b=4LqopYI3JSV3LsTDr/uwcsrANIAAt8JZ92fscz2T0Z8HQ8KW7lfvnRYN9k4QRiDUudios8
	DLaIzTbHy5hvB9vhRn8sRX+Vp8gljSPOMpvqQIQijYXeUgodkOSHEfHHTxilSvTD4ugthc
	QU54u7eE9kWYKebm5+6/x//l4FFP7ic=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6798eb0d190so1264560d50.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616198; x=1795220998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
        b=loe65/hTvnOXL9G47xUuOX0W62JjpS7s16tM44YoC4ZraymMe5zMxaXea30s3D45fS
         5YiFnpE+2Nl8bi9woOFbD+oQn67wOIdKOjXIGSe/017P3k8rDiYUTXJ7FzGQ7j2cV79z
         UHLyt4/mrQm6hJlCchD6/tJWIUH43efW/+Hv2VTKksm/vs9zkXRQ1jz62D98mshuCbpi
         79IP9++6AvQT6/wVNI6/kdq7V/l4DTr1yXeAAEHAXZBnK+4V+5tzySZkMz+MnixKwh7b
         4EsvLCuQVvCK9bnQnKO2MblqFYfChvJ7BkPc7+bDOnoGNd+s/jzDtPyTr12oBbD0KabX
         FxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616198; x=1795220998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
        b=nszzeE5zXoXN02YZ4gSEnTua50C3mrzNVkt7vtshSDr8pR9Oljshqt4crnIs8pbuKO
         Zem0eV3qdPlBBPV19eOO0BF9b+ZwAj8Ve1i1BZ4Ea2loWQHzBZOJBOwsWVWuJk3b5wW4
         Uiia3SXMEwLRPnI4Vd9pZDEOmCeRHG5IpAAG+IQrrBMURtQdSgUlsL4hR2vu5bGop6NL
         uxMZDwi5b0W27rg6Zmg61+4vOnoQdhTowfD71/MaWsbG4xX5PuralRRHCb9Uww5GGRVa
         bydbLYsRQvd86FTLxDDEENQbRDY5T28V3m0NhNocgBvD5vJsUI9Pz/ibjbYTAaecpTte
         O+uw==
X-Forwarded-Encrypted: i=1; AL+hErEDkhkP1izUZB11HUGm98IU3rXPbNZSPKF4CuYPQ89Gdz81uHvBt9ZgBLIQLPFb/822Er/OCGq5kQ==@kvack.org
X-Gm-Message-State: APuU4Z+uCyeyosn4yO7lROGmCFJvc3G3Z1cm75Gnxybbl9iCZRUKWQs8
	z9Idbu/QazPcNJBbP7UND0A9zCK1CoFrDhdIY01hFaO8ye5JAVe0r1Wu
X-Gm-Gg: AYBFou2/AGbwB0Jbxzf0Wj2Iq5euuGLACL5QE6+C1QsyZkhth+Zm7q6KTwcNhOEn/+2
	H3F7EEH42mxAneadgy7+jTuavuYvNELdTJ22SiNO+1FBlyBKz/H7IBeO8fAhKd/sncwOi9zBCKv
	sF6AVKjOKyLT8lbJ531i84fn3oTj4Unt5+l2ZzB2lc5Lazb7I85ctI4RXfhbNom2ewCNSfoFeln
	W4CuzCn7eYf+u72WcY5Ce8J4eh88EyPF+M9fORptoUaQVQESsT8RpHBWYE6tBC+uYif9UfFTm+D
	KlRFadd1U75febaA00r5xNnmiQoUzN6PfKIrXQiSZd/v87pLXbbzFfK0GeZnDIX1KmtVVqOJWtv
	2FECcL8NAzS00OTRWiZESnosSbuQNYvlMlg/CCh5zdFLlY3J5sxB8nnZafEumX26AVaflqUziNX
	kTfqq/kOOuH436MeHUE44bzi8WJNuD0ogQ3ZpZH1HXIsqHjgV91iVpL/6BRkBjE9CErHD5w7rq1
	sJP9Q8LS4OPZ6SqmkRetJGhmkfJMwzSxS07P5UFAgf7TSoISSLX35b7KuDT4pSlWNLZlveiVaFo
	4q8fC79heVQiS+ZH56tfXIRWl14jdppXep4WpWtpELf58O9q0g/vd6OXiZHGUr7Xzr5qZH6gnTc
	iPyPb2w==
X-Received: by 2002:a05:690e:144d:b0:67c:1fba:b42c with SMTP id 956f58d0204a3-67d896508efmr2961856d50.45.1794616197983;
        Fri, 13 Nov 2026 16:29:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a555cf0sm3448893d50.5.2026.11.13.16.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:57 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node counters
Date: Fri, 13 Nov 2026 16:28:20 -0800
Message-ID: <20261114002822.1043378-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 16o64zu674ypqh1dgpr76b19f9e68nkg
X-Rspamd-Queue-Id: DEB93140009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794616198-768200
X-HE-Meta: U2FsdGVkX1+Dv9knENj/l2GYv1zbNEj4xQd+bDYdDqswswymJ5IVfq2o9RaaDz8OQHuY8yrOqxpaDl98tdYsu1wEYMgbMVvGbQboAIDFhrQkJkCk/IPrsf4ATHx9EuE6audanAGzDuAI+hOyr2k3ghuHYSn7DT16uIMPL/x7tWHL6uNBtoKK8G5jNVdzJsrJANBmcWGK1fFXTfGJKr+p/esJPrW5V5j9mz0Sa2yKCIBmf6n8NfaPFVSfOTe1PaOze96Cue8vbNl20eSwQPGCySTJ6JdGgXCVwDQjf+UtnyQXpuulD9Qfos3ImJ4PwhK6/gjkABRYuaNAhKNdzTN+wNN4OHW8za5ba6iJnigh7VzGqiOzbak3/Pxu5IKUq+ah5rOLcdvPLihwDrcJ+NMYYa/4zHNVBft+lxKAVetl8JPPj/gap+PnYdmw1anOdTO9IjSrL5bckUCD3ZTzd9iHr/KbA/RIRYVLHUCcih7HqDhsC9cYvBBXxJEf1nAu1PSmgU2AyH6sfAeqbAia70YHFdzXO2KzW77bKwvK2Ya34qb+eXfjur5J0dfd/Jqqe3VA0Fkk4zpmgf1vqtRJkoNTXAHXtsGV8ujjPOTnSCoYPmwZGOje9r+VxqWGPJQh+i3qYh9Qc1LNfHkfQ0QKu6nuIinbHt4T7FSN6uHPb+JnU7pFNNwMtUe33E42QNpQyM9FO0RuQCpoDHu/nnXZnlhSOlHEsSWLQMVXmAoQuB3T2+yEQGRn9kJeK0ixV1y/zlNszrBCTt+iGbELAl8IqsPhZE9ljH7bDz/NjT186yb6Ahhp1o9euU9UVAG1lGzqXxATyYA2pOcJlee3PFLO3g55UV8HKy9Ox6PNQkedCkrtqnVAMvgDlC8r4Yeag3xcRvNyMII93Wz6pOLCtpjZN87mkURv5y2lko9a1QgUSV2xNliYCX6yWwvA9nIpiDMXkSwEP9mth93HJnrwCL5zgYk
 Ur6ZWlXZ
 CkhNuTuHX3ncwz1xTaLyhAXK45xxJdXVwNFuPLhIr13Suoq4UWWRGJFneqqxpqTJyWYMTaXqCwIjAbbmeN6ziavYH4Cc9GfhLznzwjReE5qt4zlIj5VlwjtUuZlwiW1KpNxD0H2ndKl0Rrrlzhx2x4nseVqrLlU2p7yiKydA0UrNXZr/TX6l50CfqngCQJ6l9DEcded+sLNS5Huf+bAgehoCoXH9CPmliKn395AoyqmE8EuoTslqdUCOHWLZyRCZ9GLNlMUtAgmqiPN4wemGLVQEYhmPibIijcfV1RjIhrGVsKX59Mly1eiNyp7h2H7WzSMaEaeld2ohVHLhHBYMlkb7dnPEqqouFiYqKukxWA9H1sg4jFV550pb8TIPharBgJmWUdwmA9RNLMwiDM3MBUqfaz8o2sqRSuSGDcsdfg1+RAUcBsXOjg1iiDsBDd2GQcpmZe4pKOt2bscK2OYDcmM8h1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For the root memcg, lruvec_page_state() returns the rstat value, which
needs a flush to be up to date. Flushing the root memcg is expensive, as
it flushes every memcg in the system.

Most memcg node stats only track memory charged to a memcg, so the root
memcg's hierarchical value equals the node counter, which is always up
to date and doesn't need a flush. For those stats, have
lruvec_page_state() and lruvec_page_state_monotonic() read the node
counter for the root memcg, as they already do when memcg is disabled.
Callers that only read the root memcg's own lruvec then no longer need
to flush it, which the following patches take advantage of. It also
makes the root memcg's stats more accurate, as callers that ratelimit
the flush can otherwise read values that are seconds old.

The exceptions are the kernel memory stats (slab, kernel stack, page
tables, secondary page tables and vmalloc), hugetlb, and
WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
objects). Their node counters also count memory that isn't charged to a
memcg, which falls into two categories:

a) the allocation isn't accounted to any memcg (eg kernel page tables,
   or hugetlb when hugetlb accounting is off)
b) the allocation is accounted, but it comes from a task running in the
   root cgroup, and the root memcg isn't charged for it

As such, these stats still need to read the rstat value, since the node
counter value can be higher than the rstat value.

One user-visible change is that the root memcg's memory.numa_stat (and
the hierarchical_* entries of the cgroup v1 memory.numa_stat) now
reports the node counters for the non-excluded stats, as it reads
lruvec_page_state(). This is more accurate, but as a result, it may not
exactly match the root memcg's memory.stat, which still reads the rstat
values.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..196c0382181b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -504,13 +504,67 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
+/*
+ * Whether to read the node counter for @idx instead of @lruvec's rstat value.
+ * This is only done for the root memcg for stats where every update also
+ * updates a memcg's stats, so the root memcg's hierarchical value equals the
+ * node counter. The node counter is preferred since it is always up to date,
+ * and avoids an rstat flush which for the root memcg flushes every cgroup in
+ * the system.
+ */
+static bool lruvec_use_node_stat(const struct lruvec *lruvec,
+				 enum node_stat_item idx)
+{
+	if (!mem_cgroup_is_root(lruvec_memcg(lruvec)))
+		return false;
+
+	switch (idx) {
+	case NR_INACTIVE_ANON:
+	case NR_ACTIVE_ANON:
+	case NR_INACTIVE_FILE:
+	case NR_ACTIVE_FILE:
+	case NR_UNEVICTABLE:
+	case WORKINGSET_REFAULT_ANON:
+	case WORKINGSET_REFAULT_FILE:
+	case WORKINGSET_ACTIVATE_ANON:
+	case WORKINGSET_ACTIVATE_FILE:
+	case WORKINGSET_RESTORE_ANON:
+	case WORKINGSET_RESTORE_FILE:
+#ifdef CONFIG_NUMA_BALANCING
+	case PGPROMOTE_SUCCESS:
+#endif
+	case PGDEMOTE_KSWAPD:
+	case PGDEMOTE_DIRECT:
+	case PGDEMOTE_KHUGEPAGED:
+	case PGDEMOTE_PROACTIVE:
+	case PGSTEAL_KSWAPD:
+	case PGSTEAL_DIRECT:
+	case PGSTEAL_KHUGEPAGED:
+	case PGSTEAL_PROACTIVE:
+	case PGSTEAL_ANON:
+	case PGSTEAL_FILE:
+	case PGSCAN_KSWAPD:
+	case PGSCAN_DIRECT:
+	case PGSCAN_KHUGEPAGED:
+	case PGSCAN_PROACTIVE:
+	case PGSCAN_ANON:
+	case PGSCAN_FILE:
+	case PGROTATE_ANON:
+	case PGROTATE_FILE:
+	case PGREFILL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
@@ -551,7 +605,7 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	const struct mem_cgroup_per_node *pn;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-- 
2.52.1


