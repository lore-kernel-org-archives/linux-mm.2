Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D13960A6F4F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=SuN2p5S7
Received: by kanga.kvack.org (Postfix)
	id BCF796B05B6; Sat, 14 Nov 2026 02:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FCC6B05B8; Sat, 14 Nov 2026 02:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB126B05B9; Sat, 14 Nov 2026 02:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDC86B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7510A7D5B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:17 +0000 (UTC)
X-FDA: 85432850874.18.BE8B72E
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12717A000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SuN2p5S7;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l21X+DxpKDHlSbVBLdY73zXQHc1CePcjyPM6zZHy190=;
	b=Ff6uKaa9+XIGs9B+mxDdyKBYUtJirHZJnytGPfompQnFuwRakV0YOEhWaSh6xC33UTVFgU
	oxYICsTNKRJnXvx5RMc2+KqSBBYuAdKi07DzzPEBJe4fvt1j1hDEEOLwaeBoNR0KzR+Qjf
	yF8kJlUW1lZQ0H4EJi4NsSaZJNonm70=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SuN2p5S7;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640216;
	b=dZSwAhzF288sbvgRlPfu2j9A8QV0mcbdqd+NhpAd+BPjZJXOfKHPO4OQlV/wrLiws54/qG
	9p3Sr6Xw5QJGl7iX++O8aFsxN7xLZCyYr9ZvtiEH9uoPbWQWzYJnqsKymZBT2V1HDjFbv2
	pASyNZAjLH6J76wnJrV1078hI051P+o=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91eb449364cso32556186d6.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640215; x=1795245015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l21X+DxpKDHlSbVBLdY73zXQHc1CePcjyPM6zZHy190=;
        b=SuN2p5S7D6SRmoCuQuxuhz+/pTPg4w1wj6hLUVsyOJL3IIx5TfDsyfgQaJzBrb/igo
         DJvRNMIRgWwfev5Jp5yXvkzWYssKTDtH/Ppm/q14aoATY3SpKlezoTIUW9vfFAndDdte
         NiSGPEbMuh7GptRSyrY7bi2W0BjBfz63Eo4dlW54jO3knmF9xqtDW6M6cH+V/p3AN9CU
         /y+pwtFc7Rl9hUXjakOHD04t7Xb78uyYHCAJqSLFrXRVe+FBx3XD29jvEsXgihGg0oLh
         R7hYold8N5V/rNT2tcWmhQRiTtQlc2aZ83V2wgcQVrIsbEt/18JA57Z4yJQ1FL2WtskT
         TW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640215; x=1795245015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l21X+DxpKDHlSbVBLdY73zXQHc1CePcjyPM6zZHy190=;
        b=JfiHWYyV3SSFL/qPdn7NSToxeOakfrmw6fk9qvl4GBZihJ7TqoGAUsRVmmUprA4jcD
         DQC+LdqTPoFa3fSXHPZXmFTFFwfJ++yrTz8sM5iMGXL29RxPuMmpn7H+SfPCvRMX3WNi
         zc8QCIsXY0qOMD3HE+O4zU9oN8+1zq7PO8bRTd+uOaFde5DQVCLz17bsQWk0M+Ioc60I
         Nc9tn5TYjhehnPM1iXLwOzESr4TldWvaaBAdUVqdojWDpa6f63iQuugdQMn50y0Won0W
         CcZrc5oIr0ioyIycwaxb6EHBwRcmkiHbfrd4uL/h1D/tptGfOtGylwWApsaIW+OobtfW
         16wg==
X-Gm-Message-State: APuU4Z+1NQtw7vfxve4l+HQZFd3Kug1H3zMJXPZ9ywuQKP8eHW6M7QpX
	oWMQeyQup7R1vAd+hoPUx1gPml201YuXR+z1q1UTetsVUlkN4wWFlrxqiEbJHS8jqdlg2cbo9m2
	enXxz
X-Gm-Gg: AYBFou3yWg+HLhmu9qE/typ9vMOBazT3pHcIZb5sd4ExwQCTB1YyERb3kdpY4VGpiSP
	LCSk2k5VjK74IAH1O1FkgFMKgBtdjb3vFJXBPZk9E9UColrimSsnQrIJmxZEA/f120qgZb1hOSJ
	vdff8bsxEVLZhkigSRIL0yj3nRjnmt5HHoVKQ+nnBy1WTIHHjSYQTMdcbF7D6Oo6ZOpg7ZRKi8B
	RAcZ0rRKJVuqiF829wJBM2FHwRVWqJrBJ0++fjjtrh04gH2Y6s0YWNjYXUFL4BmVlHjAmqDPk+J
	1Dc9U/JYN2lUexFOUr/TRSmAEAruJ/SGbR9JvhSXQFU6ZgjCdk4KFZQGCmN3eMPbzvYeHdfUClo
	Cx0BjMKK4KNTtT7NdPQKtaUcyRaY6Bkjm5R8kAJbv6LA2xa6mrCcBq1zosSfszMQyWhC0fIh1Oy
	s6Zexo86kY3AdA/4VXBnbTWem8WxGrHwgJ4UlfKLHCcdLVmjFFY5e3MQtu1wSpiHpCUrafVqwVJ
	6TWerW6iKaGOySlv1aV0uTQ4qtGcEQaYC7U4GTyQFlcHUkIXedyzfrEOMlFnUI8FoiOf27ZEML4
	hMojIGt7A+A4ptTFT15oRdjpPbn6ajQo+dQuLydHMkhjAf2Eqk6Pp/QXQGIb1Cc6crvnSQs9sPp
	8XiZCula94bkxo78=
X-Received: by 2002:a05:6214:8581:20b0:91e:a16b:7f59 with SMTP id 6a1803df08f44-91f241f7044mr56496996d6.32.1794640215081;
        Fri, 13 Nov 2026 23:10:15 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:14 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 05/22] mm/mempolicy: keep interleave and tmpfs mount policies on common memory
Date: Sat, 14 Nov 2026 02:09:42 -0500
Message-ID: <20261114070959.3490008-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12717A000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: coy4qi7ct9f1cgjdwc9dh6ogi7fpyzt9
X-HE-Tag: 1794640215-829859
X-HE-Meta: U2FsdGVkX1/ehs7Y+wl6ruaV7mqvSPWBSFS7Ux5HsVbU8JMvKIGnv4g3F6AJHwh7gYJDkf9QGkrmIOlh+aOOyROlxNDHjYXQGgLiwV78eC8xpjRoyS9dAoji9Q+mYmXxCG8i/y8MVIROEs9DdenRu98lYJLEIK5grvP6TR3HUSMGMXoBRcviLv8qNfFtGJsffLObICYrX8Er1taIQ/z5T6hyQLWbDDCxjlmhZCSjqlqV3y/fGcupluom6JRM86nztFen/UzG16nR9qEQBzDDZ9D1t1hjmvO+JEnUR+9x96aUf5lMn6mYnEesvMbAryF62Zo9e3fhjpTURYyZ520338V2MOr9+FSgZNz8A1RdYok9qPiSxEe7ZvPRW+XgQLEca6VDHDM5KbnpQtDmsTnJdbPmdg+XFsnyayGBaYW9bCd1MEOJS5v2fAhd65rYK8mXZhFnaNAg61awqI9dN5O7LrRY6O7UI9e7LDYZyLPZxYkN4k1+IV/uD58oYyY9jLIhXXq1RieV0I/4p5A5wsKWV36AuBSk9Sc6rnedx4NE5SLVore4iZjUH7JHWmraXs3XEjRY34GbZw4KH95nYNYV3qY7252VKjCIT5hkR6I4u4V30vU+HNRGk5d9i4ZhffAvGcUjVpM7UaccvWQFKU/nzrBaj2mTDP9TFoHdgOf0fgtC+HPyI3WbLpIWTMIH8Dn0ppJ1Nf2EcD1294RquwTkq1xs+9xO//9bCs41HIbnGlzUpBNvuX9fq/T6l6+yBK+nfBj1D9HJsx4f2P/g3fxjm9/H/ovBDFrOANo+Wln+SQWzN2vaeNKD1oWfSzrgWTsj0PWnbRrsL81MWqEJ2Ob7e2ghs8Krh2g8HcexEixjFOJv+OCav129AAVvr9/Ivu8Fe5V8wonffkItVE2E/DPjCOcOJ0j4KoqMnZ2ScI20M4lxI5t33SkhU097wXIOqpptQltXHA3zq8bHGUZju0h
 bC4NbJLW
 Kyiy+4bRBN2toKeNMftzue5WZXHtfNf1JScFN/fQ+LcKcFcG9u4MFhb7iHboIj+W9WlrkrKNPQgSahqzEgLExi/jLyQ/v3bgHAGLxmIz7Ayn52DZg6T3Vf58163klyerrGydyf50khajP6lm+ZekPw3o3TyphLCiQkxuIXZL+scgscBTklsjcPLoWVXaUNsmoJE490UB7llOluhKKH5IVG3cU9f6LObC6QdXAwgHU8nYzKSSsaz/sRud2HzAFcywCY7lp95q9TxiGm4gOwljSIwRJA1hYJt8ld35uSonCEzCTwA/LQchrxDfXV8yHNCMnWWgv5zU3hPoiZvIXb7hch/pAi4650GGUrzUF9LbjaHgWXImqrGyVx5wscKDElVtPo8xK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use N_MEMORY_COMMON for boot mempolicy calculations and their per-node
sysfs entries (weighted interleave weights). 

Restrict the node set mpol_set_nodemask() applies to set_mempolicy()
and mbind() masks to N_MEMORY_COMMON nodes.

Later when an N_MEMORY node is omitted frmo the N_MEMORY_COMMON set,
they will be stripped from mempolicy nodemasks as they're not eligible
(similar to memoryless nodes today).

All memory is common at this point, no behavior change at this point.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b10c098e9c2a3..662ab420fe03c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -213,10 +213,10 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 	int nid;
 
 	/*
-	 * N_MEMORY can change while wi_state_lock is held. Remember the
-	 * nodes contributing to sum_bw so all passes use the same set.
+	 * N_MEMORY_COMMON can change while wi_state_lock is held. Remember
+	 * the nodes contributing to sum_bw so all passes use the same set.
 	 */
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		node_set(nid, nodes);
 		sum_bw += bw[nid];
 	}
@@ -439,9 +439,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	if (!pol || pol->mode == MPOL_LOCAL)
 		return 0;
 
-	/* Check N_MEMORY */
+	/* Check N_MEMORY_COMMON */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY_COMMON]);
 
 	VM_BUG_ON(!nodes);
 
@@ -3400,11 +3400,11 @@ void __init numa_policy_init(void)
 
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
-	 * enabled across suitably sized nodes (default is >= 16MB), or
-	 * fall back to the largest node if they're all smaller.
+	 * enabled across suitably sized common memory nodes (default is
+	 * >= 16MB), or fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -3476,7 +3476,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY_COMMON]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -3508,7 +3508,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_MEMORY];
+			nodes = node_states[N_MEMORY_COMMON];
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -3903,6 +3903,9 @@ static int wi_node_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case NODE_ADDED_FIRST_MEMORY:
+		/* Weighted interleave spans only common memory. */
+		if (!node_state(nid, N_MEMORY_COMMON))
+			break;
 		err = sysfs_wi_node_add(nid);
 		if (err)
 			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
@@ -3934,10 +3937,7 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 	if (err)
 		goto err_put_kobj;
 
-	for_each_online_node(nid) {
-		if (!node_state(nid, N_MEMORY))
-			continue;
-
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		err = sysfs_wi_node_add(nid);
 		if (err) {
 			pr_err("failed to add sysfs for node%d during init: %d\n",
-- 
2.53.1-Meta


