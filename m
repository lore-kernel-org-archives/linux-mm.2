Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83E2C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9076B008A; Mon, 20 Jul 2026 15:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A04F6B008C; Mon, 20 Jul 2026 15:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569756B0092; Mon, 20 Jul 2026 15:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1647C6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D1458029D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:43 +0000 (UTC)
X-FDA: 85010157246.08.55E9741
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9598A1C0010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UjsPH1gv;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZACuuDSyenseZGNg/vBzUwDZvK6auP3eLRTsBQnq+WQ=;
	b=y+M/+GvAig0fxQ5EeySfTN+gDrjgKphPv8qiEReebojJONy7hk+t2hM1jv0pCgx1gBRFXE
	9WZz7U+GYmtWB81gKYfM1Jc0Fo9Xi6TDP2DGW6Fj/0stWiT0mnnHNLALlwhL1WJ0Q/zlqZ
	BNyILH03i5OARI15B0N/aCwGvTkdN9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576081;
	b=bJ1QBWl6YQRfQmM3sITNaqXu1dStXoubZ+VRsUewHv85Gv4cUq8A1f4iDXZaXk05UFJjbM
	YqJ1FgRQBDFjN3ZmTXD1JIK9xEkhOmPU8KflGCYE20U9Icyl7YCUmQ5YOUC31iy2sOf8Jt
	/FwGq9Wc8DzmqQP5Fwoauhuh2qlVwiE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UjsPH1gv;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8eefd4a8057so64820776d6.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576081; x=1785180881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZACuuDSyenseZGNg/vBzUwDZvK6auP3eLRTsBQnq+WQ=;
        b=UjsPH1gvZ9jryp/BS9gmCs19zLWFqp/N7PL1P1bQyB9QSViuHvmMlVqgyz6EJ4qmVr
         dvvhlXHF4L6f6JwmWRKVbh2cgiDYTR0tHcAqb1bzGB1pw5z+TRHxSx8v2lyVTuBuSE1/
         09CtE0td491r8dCyEcks9MDgtloCE8u7UPjpRAD7HEu00AgUN4Iv+Q0mH8U85eFf572X
         T7JxZkI+cw/K7XgOa68FnLF4Q4Qckxxt15wevHA4ZasK50TmEPAB9q7aAcOXaiA/uS8l
         IV1J89M7lyoOJMvEh65sxxZMCX4z+68CuQzlrmpsos0/JeGv8sxO1xmaOQcWvcinvsM1
         8BAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576081; x=1785180881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZACuuDSyenseZGNg/vBzUwDZvK6auP3eLRTsBQnq+WQ=;
        b=kZvrG4ccwtXDuQ/2vwf90bovV9dCYwDWdapnqmXVCtZ60KuDCMw7lrc82gRd0Y/lkH
         5BI/XVZgTqbVB6jSqN+QgJvaCHZK3EedxtOZ7+n8zzruLiL2O3V2fIxWiov5YkqVVENW
         pYxDquQ0ucQiMhozeQ/+DGdW6elv6w47rIpkWSa6kT9eZ0MIjOLoUGcuN7b092DRjL5S
         x1ciXDiggl0MQg5uFJAxFfpJ6D1PGj1LwBSPBg0MYBjjXE5lglPNV5q4QijtEW7jqtD4
         /r2TDiofaTdOsV5wPefk0ulcUT9ih3OD/QE0U9IpYacRqkGnXmW1lnUh+DAoGWSzHGUT
         o8Ag==
X-Gm-Message-State: AOJu0YyPJ8ENdF1MDIASKUPrQGpoQcUkmDX377LwHLXYJuxQRaRx9KN6
	G7TOOj+pufjPhQSJaqiRYGgHaqxFWSF8wayUVmVvyp6IzipNs1/q+WD8jc67ZvygkooatX000Q2
	EL8gb
X-Gm-Gg: AfdE7ck7QMje7Ty9UWCfn7kctixjt6ofNh2k1H3R0sjyH7iOvg2kGwBUKanaRV1vsao
	EETIbQAFcGb/gKj58NnnRSQDmenYDOnWtERxcu1rt9dn1EgAoMRSMXLcbLEEgDop+3Z7QEVyC8p
	GzNkv71DSWZlHdxpqJYZ3Nn8VTrVF9RhDl2EfPFdedkVi3l3Z+Kb8z3/Swkt6PGZs3ayLQlPVuA
	EZXrnf1vQbsYeoH3kk/axWZRCd3Wkk+p9VSAgLkM2RaHG4Fbzc5viBoxfBI4L688dNeGEsX9Ja2
	e4u51hfteM82HLmmvWkvD+vtg4yJPd9OVr1sHk0E9a6W9QbW6ER4AKcgvn6RgTF8LTqLuH0ua2C
	uBd8HczMkM+SY7DBEIiHJP0Mx06hQTghloUPiCFCs9b72NgnZO47l7Z1pl/HKEWScEl5Dat92ay
	6g6HGEzzpMYz6oNqq3RyWo+SNys/fHKn8SXi4hh4eYoGdfgRL7mvkyX+x41iIFP+0=
X-Received: by 2002:a05:620a:72d3:10b0:930:d7ba:7e5c with SMTP id af79cd13be357-930d7ba80a6mr431148485a.21.1784576080645;
        Mon, 20 Jul 2026 12:34:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:40 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 01/36] mm: refactor find_next_best_node to find_next_best_node_in
Date: Mon, 20 Jul 2026 15:33:55 -0400
Message-ID: <20260720193431.3841992-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9598A1C0010
X-Stat-Signature: uwwqmz3yzm6dpkkckd4jmyrb7m9s6dgo
X-Rspam-User: 
X-HE-Tag: 1784576081-635079
X-HE-Meta: U2FsdGVkX1+I2rNyaI0OzNFHXUTNKFmc995t8H27iHIlkTmpHS7XRy7Rqgia9JRX7FVx2DhxoKbv6/lbthtIcD8HGGsNVw3KrfPhPunAlheSgM8Wvjr0jbhpO01rasEEM0P73yesOvwDpVdblJzuM/FUmbeVRKlKo6r0nqZW80QfzKkJyyiKwZPmNCHvdTS0YVR1h4DBq7yBn7hdNzbfeTB7JRrnobnAbDuO91V7Dv769u9lR9Z2uYg/FyeWbMSgbjOXByyIfiZryH/EBORqbAlXKQNseNMyE7C2O8Um6QM/dJ2C2pwIWT3Lsr1n/ggmQTi8muCJwF2TQF9Es349m+kcvSInLH4VO6jO+DBlPKCl42TPvXUzdO6uNh75Xfd1yIkG8DSjxI1R0idOsp+bTnXdi3++DHZqnlGiWeepwg0W3n6zc7gZ6gXyhF/t45ZnF9G1XE/PRgAJYSodoqLnYFdCzltxEJEGEU//ni625R0t0bOxHPFDOlF8GliuOIoff16p0kzAxp9qreedK/9SMdvDeZYeDL5mug0Q5ld6SDmPCKD66sX1buZQV0gejRM9dzbTGiwehiRXvbp83y2pE1nAbaeR1yD/CR2R2mCaGXQ/El9vhXxCgLxEfCJdFHY4OrPHQzPllDRXzHasrylbalPRSwgwKbVhm77f4yH85cV0XRxZl/IMZjs3ZqQ/Es7bdG4VsDk0wc/yFasUcPn/PMZCKCHeKcDryOeps+6AxtoHE8lI489xm2lcwO3dCB6UF4QtnkFAqRRBDE0EuhX2nZG6tRM+7Oqk8Rw7GJSUL1PR+movjhcGvQUGAGyZAUhzMOqQ8ptDBGZf+bX4ZChDStvg+IhbDWfl7gr43XjS+ImEb+oU0OAGftNI56aIPFqb9usuC8apmPPLNLjGtSFMvTeUqNl2nxyo1aKU6yVK1XR33xo6lSMyQxu++qyn9GUNB1Vlo8lPRCfRJeE2/3G
 KVUY7M2r
 XXpl1UmJzmQlJh2uLEihIRppUwWr4fgqf4aaKaIKTVIxAMR0z9EE8JyOFR5jwtflwttMG2siidAZ0MusazgecnghkLd4cPybMJQVQtM/A0scbEuuVC27d0B1rTrW2hHYf0qeSltsDIDxI/+UzfEty1KW4FrtC+KKQLQ3nUPIiSGz2T1oFNbuO80hgY/Np+XBLrsCxM9hp/xiiq7gPC7uUAIyTtt3NdaYUXPfhd/lTA1ehQQ3cAYGLvyY8KyK4YnE43h/mkCBniLHHjxYyly965iXvBWORQBBJFN4l0ATMsxaE97h36mf0EoU/yGXLJcaDLibNMIoVOGkjEAQ4uJGCBUrxWcUQpQIZ9s3andtKrRjB2fdXat0mgRWUZzL2EoyEY1PYlxekl7YUSdhWiEPkLo3D+/b7VbGC/ol7QhqJDnOBcJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_best_node() picks the next-closest node for a fallback list
from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
which takes an explicit candidates nodemask.

This enables building fallback lists with non-N_MEMORY candidates.

No functional change: every caller still selects from N_MEMORY.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/internal.h     |  6 ++++--
 mm/memory-tiers.c |  7 ++++---
 mm/page_alloc.c   | 13 ++++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca28..96d78a7778e88 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1103,7 +1103,8 @@ extern int node_reclaim_mode;
 
 extern unsigned long node_reclaim(struct pglist_data *pgdat,
 				  gfp_t gfp_mask, unsigned int order);
-extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+extern int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+				  const nodemask_t *candidates);
 #else
 #define node_reclaim_mode 0
 
@@ -1112,7 +1113,8 @@ static inline unsigned long node_reclaim(struct pglist_data *pgdat,
 {
 	return 0;
 }
-static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
+static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+					 const nodemask_t *candidates)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..25e121851b586 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -370,7 +370,7 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node(node, &mask);
+	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
 }
 
 static void disable_all_demotion_targets(void)
@@ -450,7 +450,7 @@ static void establish_demotion_targets(void)
 		memtier = list_next_entry(memtier, list);
 		tier_nodes = get_memtier_nodemask(memtier);
 		/*
-		 * find_next_best_node, use 'used' nodemask as a skip list.
+		 * find_next_best_node_in, use 'used' nodemask as a skip list.
 		 * Add all memory nodes except the selected memory tier
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
@@ -463,7 +463,8 @@ static void establish_demotion_targets(void)
 		 * in the preferred mask when allocating pages during demotion.
 		 */
 		do {
-			target = find_next_best_node(node, &tier_nodes);
+			target = find_next_best_node_in(node, &tier_nodes,
+							&node_states[N_MEMORY]);
 			if (target == NUMA_NO_NODE)
 				break;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f93a6bb9a872d..acf096f525f49 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5743,9 +5743,10 @@ static int numa_zonelist_order_handler(const struct ctl_table *table, int write,
 static int node_load[MAX_NUMNODES];
 
 /**
- * find_next_best_node - find the next node that should appear in a given node's fallback list
+ * find_next_best_node_in - find the next node that should appear in a given node's fallback list
  * @node: node whose fallback list we're appending
  * @used_node_mask: nodemask_t of already used nodes
+ * @candidates: nodemask_t of nodes eligible for selection
  *
  * We use a number of factors to determine which is the next node that should
  * appear on a given node's fallback list.  The node should not have appeared
@@ -5757,7 +5758,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5767,12 +5769,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
 	 * Use the local node if we haven't already, but for memoryless local
 	 * node, we should skip it and fall back to other nodes.
 	 */
-	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
+	if (!node_isset(node, *used_node_mask) && node_isset(node, *candidates)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
 
-	for_each_node_state(n, N_MEMORY) {
+	for_each_node_mask(n, *candidates) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -5857,7 +5859,8 @@ static void build_zonelists(pg_data_t *pgdat)
 	prev_node = local_node;
 
 	memset(node_order, 0, sizeof(node_order));
-	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
+	while ((node = find_next_best_node_in(local_node, &used_mask,
+					      &node_states[N_MEMORY])) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
-- 
2.53.0-Meta


