Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFCCEDF04B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E3C6B0005; Thu, 12 Feb 2026 01:27:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C355E6B008A; Thu, 12 Feb 2026 01:27:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41296B0092; Thu, 12 Feb 2026 01:27:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A35E16B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:27:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67DF21B3D99
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:27:49 +0000 (UTC)
X-FDA: 84434823858.25.691D056
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9BE00C0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:27:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hn6qUYKk;
	spf=pass (imf28.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3fhgkTTV9eq12h9CvoXojKy73Yh8kGYUPsNNOceHZA=;
	b=BmxNWF8pI3xquxqZfWQ2JWYq5DQgejc0fu/aZD7kNcRmrxbjGUA96m64OUn6H4wtATFJd+
	UchKFYTalW+gZ7Ya92VmYIWuQUXhYoHEpr0gI3iLZbqd853vN07oMYI3dN6F4QF2jijLqk
	fgi3XyURcMC/9o94xVo4GGLOAdDDq1k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hn6qUYKk;
	spf=pass (imf28.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877667; a=rsa-sha256;
	cv=none;
	b=FSWlgwDpvl2685qpJ+NDHLIaN4rNLuzOKeIn7S0E4rA0FeOBezMCL8c44KK05rKVPRZRBS
	vWdUDj4jQtm8hgOAZa1q57zXuMtnYfay189uK3ktAEFKCBP7oYlMTx8jrfGmMwjUfErNIf
	nzfQqHxigKo8sSX1Qz+K2+jQDkYc6CI=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8947404b367so82976786d6.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770877667; x=1771482467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3fhgkTTV9eq12h9CvoXojKy73Yh8kGYUPsNNOceHZA=;
        b=Hn6qUYKk15lU5aAHb+PQ95mv2v7obEqNgimg+v3hqE/xv35MwkAqluUB3ZaUk9RAII
         S8JmUxHdjVwjgFstiA9pV3k4N29+Blb3serqPbJNI6A1/N/cUY1F/g/mKizW1fPHaDBu
         vF+mfUEBBrEtkd0kCdH/RcMG2/HF/6OoROZiilU3yKiR8XX0cNb5STMEmG5YCT+7STXl
         HgANf9y8I0qIPIZGGl6lSa0EHw7kPHveIcv+S7A8Q+0+Dn8apDxnh8MzVynGkQfb++mo
         GcAXfpGGLWnuR6YX2KMiFoRdl+cmfRPKI2YE2ftyd6M8quGiq4ZB4xT4qraW4QsF+rlD
         loQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877667; x=1771482467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A3fhgkTTV9eq12h9CvoXojKy73Yh8kGYUPsNNOceHZA=;
        b=sRq1b7Sr+zjvq7IupBokwsvblFLGFC8vf1LQUn4XeWqW/RT9zlakksMnvoQbGYnJhz
         kPjVfMQJocoBG4a7BrDL/IzieGTZCvQcCul7goipJOd0JskHcIJZZdxWNP2CvlXztQkR
         nXTWjL9iEYmqGofAwk1bHR81S2LwzToXAzadipOgRUccqxIjUPr0n/TEY+oo51TiTzrO
         l6kx6p1JAHWXjAEd4N8Bn1VqCS4CMC0GRMHRcTIsAkduKFm2kwV3QQRZdOF+KI+7Lt4p
         yk6LiC3fNZCsICkQo5joFyNYWlSWPiUJ3kCL2hrl3qfzP/OyGMn5O80SdAwx1bw2agzK
         DgxQ==
X-Gm-Message-State: AOJu0YxKSkgKMeua2p9YVoTTGlJEPJDMMfJGMaBk7G6PNJ9ObK1DaIUb
	0of0Ownc7eNn1EMttQ64ini/eIYXW4mdr6Rxw+N466thYagY8Ke5KJo3CKrOqg==
X-Gm-Gg: AZuq6aICzNCglI/PZIi9zGeFF9+owZbS6Uf/vHGOGiJm0787XKCI4H/AFFnsYrQonnF
	XnJv6XSiz/QHvH1eJCO+bWqyyvDwQbpVssxkATjmT7l4flxk8To0EwdDIGcToYqw77fIgHuA0nq
	BFc8dxZFvIZ5v64Uq05hrdmHeJbVP9mEvkcWsHsf8LCKTGxuJSkNmOdFNPW2nvy5HvrSeoFu2nL
	8zHPhapEKaumIbQQ1oqjCnHQEq3qC4cJQqVMQQu6cFC4XTqgFWdwHKveLXN8HqsQ0FD46+vAriU
	CUPyBbyfstWj1bqahCoH0Znh9oaQKoFFoua9JI1g26doU2BqehzJZk509MgBS+8daNZSWD2ve2S
	44lPjcXWK4UVC52gdU2SCL5m+uX4S4+6zfdDMLxZrUyU8EMXMgtxRKAfLbKNrpBT6FtF7TEOoPs
	Kc0YPmRfqQXGsvqOOtLoFJxC/GLFYewvNfqBECwmtB2Aw65nD7kw==
X-Received: by 2002:a05:693c:2c15:b0:2ba:73db:3e81 with SMTP id 5a478bee46e88-2baa80a790cmr705679eec.33.1770871892999;
        Wed, 11 Feb 2026 20:51:32 -0800 (PST)
Received: from jpkobryn-fedora-PF5CFKNC.lan ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9daa6151sm2878699eec.0.2026.02.11.20.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 20:51:32 -0800 (PST)
From: JP Kobryn <inwardvessel@gmail.com>
To: linux-mm@kvack.org
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	mhocko@suse.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	vbabka@suse.cz,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
Date: Wed, 11 Feb 2026 20:51:09 -0800
Message-ID: <20260212045109.255391-3-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212045109.255391-1-inwardvessel@gmail.com>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 48p4nthcwcsoukxbinhx4dja4ehhsgdm
X-Rspamd-Queue-Id: 9BE00C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770877667-517924
X-HE-Meta: U2FsdGVkX19nUnWb+1cxAXJZmBAaFJxvsSS4Ha2ZnDoS9AvjOd92EMBeSEC+FxS2PdWVyOGf5BWWg5Y77/SdUgMUUEjvuhLH7RzBLU2lm0KLwJR0h4i4RnzgmzLXmsciy8JCfl0WnQTaAK29Z59wrhJ3czTC7I1OAW9+4koXVZkwLAsN/tQsNzyB3thmaUv1nSvmNSsMSyAwLBeumo7MfSdlC8TjKyiE43497gAJEQN0xQ0PO8yBko9cLHXtI72rkM+3ba6JSUWuT8wyplo3VNJ4yQhrDHOfMDOH0Sq05c+PJaY7ARmMW/gcVYaLVIxB0xK3TM+qzZja+fpnkROvPljtROQCT3W067xBvLA79a/whP9DLJeKkbqEBUS4SRVk+N4mgz86NQZjNP37rx5RkurBX8dHrjmk5di0/v1IW8p922VICOHSl/kKUk7d/pVSSoDUJtiJs+KUDSwFwG50HCFLV4uj5naxG4Gz4hItGripwDGeyBTQo6eKXBZZDw4dR8TyVy6rcSXgDPmQvgEn2wk9espz7FY0zNGdE8O9UrXeiNjtDDsFglOzOMqnr0kESfeps04Y25WC/SoLV6lbude4FTp902VwjcgZhbvfk0q/6JTxoR8U6qEV2FKR1V5z4uN5XNAbdPrKiAPg07llqU7L/Ad2uGhAe4NlJBd3ywFXAn+hrl2MPsPVgFH3xw6yf+RZnRqFxyE1MBBJPT+Tb3P0bHPcXnfYIXnUJmLXdjvzxi3MXqNXq/6mbBZ1gJ0/F9TaGByj+sT//XL2cbp0YmB9HcPjDIlTcjv2TPgOYReDh2IHYk0zUDy3qpRVaEaY4KNzTBh5hjQxVLZOckjNyJuJb/0nUAIPnInt3rAKlGgzrtEhg6KRfNwlQ3ZIGiOUF+V2xSdlLMvjP8PSm+Q4f82F7Fga3bh1MjZGgs1AxZySo9AcjPtnSDb1GoY7Voq5WUuqScvr5XxyaEXbvl3
 t3ShddQr
 n8J40/Jd07H0JdgyG7+eQ4GZ0ApnvZ+Ekuk10nAsq6Rp2+geKmjV2xKsi7D16LT8LpYpSuNOCBScGpeiiDWAZNGUJPILAl90CxRdJbtEMzKL5JqpJs6kFTPk5ON8/5s+6tVnSOCeL7Iyl8EckEDGu5M8N0I1ygvGQhFwcqNAuB6z3j5r1DsnneFPTJhM648I3jVZ1pRjRM/T1IqTdlF+HYh2uc8ND7bqA/StPNF9gt59Lb2bB5sLRuiWWY1O5DAnwBgkJDJQ6lj1Otb2bSY19p10RVQTtic/bX7EA8CKxmssKXmU+IKFp21AJqIDEVr6gwpN4iJDHYLClPPSbfj+7o8p8uv9ngumunqmBrrDkhtua3lbb0fM/K+FfW3Xaj1iij5iWVztE1WROZ6Ol+Xa/RN9qMZlxmgv8N+OLwmu5Q9ptISVz2+dQ82grrCAn0II1d1NsId0vRS2QyOTLhbrm+2ie09Gzj+x/wZGxfdDOTbCLVaTjKo1kXOUekMDnSG0rJoY57Tmlx/D9Eq+9f6fCZRhN9EKJEG+P4KwkrRytHPlMNp0ycNEZiHOtJEhNF7kYI6nlck5Pg82fdWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It would be useful to narrow down reclaim to specific nodes.

Provide per-node reclaim visibility by changing the pgscan and pgsteal
stats from global vm_event_item's to node_stat_item's. Note this change has
the side effect of now tracking these stats on a per-memcg basis.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
---
 drivers/virtio/virtio_balloon.c |  8 ++++----
 include/linux/mmzone.h          | 12 +++++++++++
 include/linux/vm_event_item.h   | 12 -----------
 mm/memcontrol.c                 | 36 ++++++++++++++++++---------------
 mm/vmscan.c                     | 32 +++++++++++------------------
 mm/vmstat.c                     | 24 +++++++++++-----------
 6 files changed, 60 insertions(+), 64 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a78c..1341d9d1a2a1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -374,13 +374,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ALLOC_STALL, stall);
 
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_SCAN,
-		    pages_to_bytes(events[PGSCAN_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_SCAN,
-		    pages_to_bytes(events[PGSCAN_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_DIRECT)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_DIRECT)));
 
 #ifdef CONFIG_HUGETLB_PAGE
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_HTLB_PGALLOC,
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 762609d5f0af..fc39c107a4b5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -255,6 +255,18 @@ enum node_stat_item {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
 #ifdef CONFIG_NUMA
 	PGALLOC_MPOL_DEFAULT,
 	PGALLOC_MPOL_PREFERRED,
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6..6f1787680658 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -40,19 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGLAZYFREED,
 		PGREFILL,
 		PGREUSE,
-		PGSTEAL_KSWAPD,
-		PGSTEAL_DIRECT,
-		PGSTEAL_KHUGEPAGED,
-		PGSTEAL_PROACTIVE,
-		PGSCAN_KSWAPD,
-		PGSCAN_DIRECT,
-		PGSCAN_KHUGEPAGED,
-		PGSCAN_PROACTIVE,
 		PGSCAN_DIRECT_THROTTLE,
-		PGSCAN_ANON,
-		PGSCAN_FILE,
-		PGSTEAL_ANON,
-		PGSTEAL_FILE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_SUCCESS,
 		PGSCAN_ZONE_RECLAIM_FAILED,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..bde0b6536be6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -328,6 +328,18 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -441,14 +453,6 @@ static const unsigned int memcg_vm_event_stat[] = {
 #endif
 	PSWPIN,
 	PSWPOUT,
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSCAN_KHUGEPAGED,
-	PGSCAN_PROACTIVE,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGSTEAL_KHUGEPAGED,
-	PGSTEAL_PROACTIVE,
 	PGFAULT,
 	PGMAJFAULT,
 	PGREFILL,
@@ -1496,15 +1500,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	/* Accumulated memory events */
 	seq_buf_printf(s, "pgscan %lu\n",
-		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT) +
-		       memcg_events(memcg, PGSCAN_PROACTIVE) +
-		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
+		       memcg_page_state(memcg, PGSCAN_KSWAPD) +
+		       memcg_page_state(memcg, PGSCAN_DIRECT) +
+		       memcg_page_state(memcg, PGSCAN_PROACTIVE) +
+		       memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
 	seq_buf_printf(s, "pgsteal %lu\n",
-		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT) +
-		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
-		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+		       memcg_page_state(memcg, PGSTEAL_KSWAPD) +
+		       memcg_page_state(memcg, PGSTEAL_DIRECT) +
+		       memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
+		       memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 614ccf39fe3f..16a0f21e3ea1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1977,7 +1977,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
 	bool file = is_file_lru(lru);
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
 
@@ -2003,10 +2003,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_scanned);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
-	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
+	mod_lruvec_state(lruvec, item, nr_scanned);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -2023,10 +2021,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	mod_lruvec_state(lruvec, item, nr_reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -4536,7 +4532,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	int i;
 	int gen;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
@@ -4595,13 +4591,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc)) {
-		__count_vm_events(item, isolated);
+	if (!cgroup_reclaim(sc))
 		__count_vm_events(PGREFILL, sorted);
-	}
-	count_memcg_events(memcg, item, isolated);
+	mod_lruvec_state(lruvec, item, isolated);
 	count_memcg_events(memcg, PGREFILL, sorted);
-	__count_vm_events(PGSCAN_ANON + type, isolated);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
@@ -4686,7 +4680,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	LIST_HEAD(clean);
 	struct folio *folio;
 	struct folio *next;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
@@ -4750,10 +4744,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 					stat.nr_demoted);
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
-	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	mod_lruvec_state(lruvec, item, reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 74e0ddde1e93..e4b259989d58 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1291,6 +1291,18 @@ const char * const vmstat_text[] = {
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
 	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
 	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
+	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
+	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
+	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
+	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
+	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
+	[I(PGSTEAL_FILE)]			= "pgsteal_file",
+	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
+	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
+	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
+	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
+	[I(PGSCAN_ANON)]			= "pgscan_anon",
+	[I(PGSCAN_FILE)]			= "pgscan_file",
 #ifdef CONFIG_NUMA
 	[I(PGALLOC_MPOL_DEFAULT)]		= "pgalloc_mpol_default",
 	[I(PGALLOC_MPOL_PREFERRED)]		= "pgalloc_mpol_preferred",
@@ -1344,19 +1356,7 @@ const char * const vmstat_text[] = {
 
 	[I(PGREFILL)]				= "pgrefill",
 	[I(PGREUSE)]				= "pgreuse",
-	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
-	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
-	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
-	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
-	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
-	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
-	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
-	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_DIRECT_THROTTLE)]		= "pgscan_direct_throttle",
-	[I(PGSCAN_ANON)]			= "pgscan_anon",
-	[I(PGSCAN_FILE)]			= "pgscan_file",
-	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
-	[I(PGSTEAL_FILE)]			= "pgsteal_file",
 
 #ifdef CONFIG_NUMA
 	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
-- 
2.47.3


