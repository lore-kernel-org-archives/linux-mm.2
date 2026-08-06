Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B88C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0DF46B00B7; Wed,  5 Aug 2026 21:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDE56B00B9; Wed,  5 Aug 2026 21:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF0B6B00B8; Wed,  5 Aug 2026 21:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 426676B00B4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5264640624
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:30 +0000 (UTC)
X-FDA: 85069069260.06.A853C6D
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A55E180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dsm9fDOD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3e99zagcKCGQLaGUECUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3e99zagcKCGQLaGUECUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8abuksqZM3TFFDeoiYatQV1rWPvHTMlTEjpMkYl7Nf8=;
	b=KQzkvjcb7gk8ZKTMU7xEXDTj5RpRTIor9VnYbIzSXvQZmVZ2BbggKLu0UOHkJvkPsqZQL1
	e5EYwgcEdL50HoEQQp1N0LCLWvzCYaQiyjhyTXF/0KOPfwLkRokZ8Ri/vRrL5tAc+31SJ6
	QvUDo1vXTeL4+3v0/mbq84x6xnUcbVU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dsm9fDOD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3e99zagcKCGQLaGUECUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3e99zagcKCGQLaGUECUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jyescas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978748;
	b=xcz+5PuAb3hJrjcgelnCt/YX2vv4U/j6GHJhLLTwfCA4Q788NEOFVQ43lDjpcDSl1+dnnF
	KlAJvXL5Mj5PYefTQVTaGGxmA0lMT8i8qQGwWTva4i2bznNDwK7jiCPjD2dPB/QsEahFx1
	Q1Uh+RQieHp9trhja6dD70esPfzjLhU=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e7b87ce77so846150a91.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978747; x=1786583547; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8abuksqZM3TFFDeoiYatQV1rWPvHTMlTEjpMkYl7Nf8=;
        b=Dsm9fDODMaEzRdzPVOkS3hzCv4H10zpxWSkMva50nFuClW675TryzxUkGQbXqbz1V1
         nDt9bCTPCn0N9biv068d6lHH3BaOcFUm6PDdNw2LVQgUuCBtfRuObnrmp55c++bIYFoQ
         IVzk+nr0Q8uHSt0INC2oyCr9wgn0iXxAqsb4WOGaHgpR0V9OG8Vj/f8dPXrtm/DWFBXh
         xWoAwDbGtV7TVH5im1OCW99tpf8zqsFuVLU2L7KkpvsiB7MilOy57y5IqByurvdixv2t
         IAuc/sMLzCOSuh4688j893P9sgjz41XPU/shI20ocbhdURIUc5LVBkJzYlLcGSiwpa23
         +Q0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978747; x=1786583547;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8abuksqZM3TFFDeoiYatQV1rWPvHTMlTEjpMkYl7Nf8=;
        b=OlzF64YbBKEBffh3g1jfUi3MTKqPKl0xg+8/S1v8qI/vpAcE/GbKULZ6RAn6Xtg5vE
         Rivr9GvIXWM9GCil9bqX39BQPdoG2RCy6UFsJcrTYmzjXX9MWsD1Nz3++5Cl2uuAEtL/
         X6fTOeMoMIInCMqMerCYT9sxA3VIkW5tewIiu441Wzkz2Jd8Lo4Ir10hPQlPls5GiwKF
         KqLRwdgrjygBC+7cb3weX87UYry3ci/ubJxpDii8zEI+cDCe4iNC6lv0j23SArH5NIhF
         heE59tcAKiWZn0nQlBIS5AQA7c47DRsSJDNI6QVPP1+gYPM4MyULhqNQ1jnBQDW6YYWp
         zm0w==
X-Forwarded-Encrypted: i=1; AHgh+RrK0RvqzA4J9UUS6ruw0vBy38Mbceu91xd+UymRqtex+5crnmty3pD+ldK1WC+JGh0Pd3u+uEcObg==@kvack.org
X-Gm-Message-State: AOJu0Yww2XTr5z+gZO36c04Y6lsSFceNeXR7dffczMUkSsb9YcQk7NnD
	eaAAdRmVijXnyqjjG3WBJUuDQV1+9nrwYYoKs4gOV8FUeHLi8ahmCGlLoXtcCs80ciX+XpBv58v
	vX23ypAMh4w==
X-Received: from dyz1.prod.google.com ([2002:a05:693c:4081:b0:314:2a38:b2a1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec86:b0:38e:bbf1:de34
 with SMTP id 98e67ed59e1d1-3903c537a12mr12089869a91.7.1785978747238; Wed, 05
 Aug 2026 18:12:27 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:09 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-9-jyescas@google.com>
Subject: [RFC PATCH v2 08/16] mm: Define function that creates the
 "nr_pages_allocs" file
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A55E180008
X-Stat-Signature: dasxpzytm55qaztpxgs57u5mgubessmn
X-Rspam-User: 
X-HE-Tag: 1785978748-452243
X-HE-Meta: U2FsdGVkX18M00rYUsvN7aYSsIc9mimXhbNJHXJ9zt2cf+6RgFEUQ1YFjQy/ZQACl6Rr7Qmj5B0fsxTH8m17Y3N8ARLsHrB/v7ZLm+iOj5rWMrdRQ2kmZVOgsUDhUJfaZguLz4otoGkBMrmpDaMeLOVMqUEg5Hzvx5/fn0OwSClk/mCL6He0w6pNPdfn25T08Y7vT0kqMmpzqEMb59/jw7JPAGsbDaef2z/5nTjdJKLLq+b7S85yjZeHFOYarZO6OtGstTpbYCTvgmCtylgBvP8NnezLKUCfeKAFeziu73RRbwS+wvjvA/Sa5L9A2uWXkKPGLamtjwzRN2z2z55KUhMCiElmRx7TVX7KATRECa9cMlwp7n2rLfFuGkqEtMY0g2u1yi5E4v8iE9QX9kJFVae8jUGq2f+SGOlJ+dfkn+Ed2uXF3KjWCWuYPBrKrW6RHW6WadZgFy+RJPDNY2aGTHq3XVToqbUb4NeczPS2qLKHp1X9NBANp4AUhx3uP0cU7QH/yP77lMYMy4V2TbvBgr3GPmfQt4G33Gk7ZGS6DF9PMTVHyIEONMALrlumFZekUCjTUj0j2OyOgHHnVVLpqoe/2Qt3dIcfly8kQW8iV0Jl5VuMhEHYju05cj18nYO+Cy4rlUopK84R5FZ+BxkkWUzi4SLZzLNyqggtGseQ/sWwYoJfm6d1GF1kVvGBcgFZ3yc2tBVuFh5x4UewsCqFROOXXyc+nrAvw4sPlKRCtZKhv4UlKX8ctYqFZpIa8cJVGc2I/18kIadpdvnO81ABuyuQbYbivRVBFk5xf34UJPesivlBlAI9udeAQRZG3wLdi2600QSSbtii6uCh4er0LLfbgNIs/X/PO00bAwIzUgoxH3Kyox3GFij9DVs7ODc25t2jEBzme5+oP97JrlriEDbu3SA6OtsiV908jAHJCYSkYs7vvMw0jMeabjZhtM890PYkDE1MkVhDjfhIUBp
 nyzq5u3M
 NOWz79WmlBqVMOCEnyrM6s4dWsUFnKBBEIYKjObwysvLp8jqKProIsw52vcY8VSfwI7J81Em3LXGaCEXSR2vxoV7nBlyqWuca9PH6tclEE7sbq9GEJxDGUBcP1zeZR/YmA4233SxnwU3QU2rW/1SZAG4++46KH8VQ2ETBMVaV4/W+BFMggkjj3dUdxFJrEPn7bo8uQCkK9X626vl3eLK//Rm4preeBNd3+d8m3GBe9vxj9MPDMh2lNr9N1tYgB4ekLH/yVhD6lhkA3ngrdDeqtBDqVzv/rYIPNOlYd96YcDkVE4jo6vV2K6qh0L1JuRmOU/YTLQz990wZ1MTaqUMQ2s5hwPyItGbRpS6DTHrUc03sVRrmcaVI21n3eQeUHdpTBTwQrz1OCwFZoyHUZ++42GAL908bHIbrXxAMtp0mRPTlTL1w2EPTiR/foOPACEbDqChQhp2rijEDH3s6F/J1XsZYIbvEyBEvImKNsrR79B+KI9Y7YYHV56Vvs4G3W7qlv5MflatqovgnZIQQyNDIA7aReVjCU4DJqpbySIqJmQtePhzF1m0VU3gSC05oOyoz8q9AliaV0cQVc7Z5Dy17Yt805fK84Z9r4bExYPsz/3WvjDjIE/4O2qqBaIV7QrUJLtK9Uw5MgvDF3muTh0q44/EpbYkVKFB7X6VWF+oIBPO8T1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change implements the function that creates the
"nr_pages_allocs". This file will be used to make the allocations.

When the user wants to make an allocation, it will write
the number of allocations to this file. For example, if want
to make 56 allocations of order 9 in the Node 0, Normal Zone and Migrate
type Movable, we execute this command:

echo 56 > <sysfs>/mm/node-0/zone-Normal/order-9/migrate-Movable/nr_pages_allocs

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Update file permissions to 0200.
	- Free req_alloc.

 mm/page_alloc_hogger.c | 81 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index ab39ea300704..ded3f0fc6641 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,14 +127,70 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+/**
+ * req_page_alloc_write() - Allocates the pages on the requested node, zone,
+ * order and migrate type. Once the allocation is performed, a file is created
+ * to free the allocation later.
+ */
+static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	return cnt;
+}
+
+static const struct file_operations req_page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = req_page_alloc_write,
+};
+
+/**
+ * create_nr_pages_allocs_file() - Creates the file "nr_pages_allocs".
+ *
+ * The "nr_pages_allocs" file will be used to write the number of allocations
+ * that will be performed. When the allocations are performed, a new file for
+ * each allocation will be created in @migratedir.
+ */
+static inline int create_nr_pages_allocs_file(struct dentry *migratedir,
+					      int nid, int zone_idx,
+					      int order, int mtype)
+{
+	struct req_alloc *req;
+	struct dentry *nr_pages;
+
+	req = kmem_cache_alloc(req_alloc_cache, GFP_KERNEL);
+	if (!req) {
+		pr_err("Failed to create nr_pages_allocs_info");
+		return -ENOMEM;
+	}
+
+	req->node_idx = nid;
+	req->zone_idx = zone_idx;
+	req->order = order;
+	req->migrate_type = mtype;
+	req->parentdir = migratedir;
+
+	nr_pages = debugfs_create_file("nr_pages_allocs", 0200, migratedir, req,
+				       &req_page_alloc_fops);
+	if (IS_ERR(nr_pages)) {
+		kmem_cache_free(req_alloc_cache, req);
+		return PTR_ERR(nr_pages);
+	}
+
+	return 0;
+}
+
 /**
  * create_migrate_type_subdirs() - Creates a directory for each migrate type
- * inside the order directory.
+ * inside the order directory. Once the migrate type directory is created, it
+ * creates the "nr_pages_allocs" file.
  */
-static inline int create_migrate_type_subdirs(struct dentry *orderdir)
+static inline int create_migrate_type_subdirs(struct dentry *orderdir, int nid,
+					int zone_idx, int order)
 {
 	struct dentry *migratedir;
 	char dirname[24];
+	int ret;
 
 	for (int mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
 #ifdef CONFIG_CMA
@@ -150,6 +206,11 @@ static inline int create_migrate_type_subdirs(struct dentry *orderdir)
 		migratedir = debugfs_create_dir(dirname, orderdir);
 		if (IS_ERR(migratedir))
 			return PTR_ERR(migratedir);
+
+		ret = create_nr_pages_allocs_file(migratedir, nid, zone_idx,
+						order, mtype);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -160,7 +221,8 @@ static inline int create_migrate_type_subdirs(struct dentry *orderdir)
  * the zone directory. Once that the page order directory is created, it creates
  * a directory for each migrate type.
  */
-static inline int create_page_orders_subdirs(struct dentry *zonedir)
+static inline int create_page_orders_subdirs(struct dentry *zonedir, int nid,
+					int zone_idx)
 {
 	struct dentry *orderdir;
 	char dirname[12];
@@ -172,7 +234,8 @@ static inline int create_page_orders_subdirs(struct dentry *zonedir)
 		if (IS_ERR(orderdir))
 			return PTR_ERR(orderdir);
 
-		ret = create_migrate_type_subdirs(orderdir);
+		ret = create_migrate_type_subdirs(orderdir, nid, zone_idx,
+						order);
 		if (ret)
 			return ret;
 	}
@@ -189,15 +252,17 @@ static inline int create_page_orders_subdirs(struct dentry *zonedir)
  * is because they are not managed by the Buddy Allocator or CMA allocator.
  */
 static inline int create_zones_subdirs(struct dentry *nodedir,
-					struct pglist_data *pgdata)
+					struct pglist_data *pgdata, int nid)
 {
 	struct dentry *zonedir;
 	struct zone *zone;
 	struct zone *node_zones = pgdata->node_zones;
+	int zone_idx;
 	char dirname[24];
 	int ret;
 
-	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+	for (zone = node_zones, zone_idx = 0; zone - node_zones < MAX_NR_ZONES;
+			++zone, ++zone_idx) {
 		if (!populated_zone(zone))
 			continue;
 
@@ -210,7 +275,7 @@ static inline int create_zones_subdirs(struct dentry *nodedir,
 		if (IS_ERR(zonedir))
 			return PTR_ERR(zonedir);
 
-		ret = create_page_orders_subdirs(zonedir);
+		ret = create_page_orders_subdirs(zonedir, nid, zone_idx);
 		if (ret)
 			return ret;
 	}
@@ -238,7 +303,7 @@ static inline int create_nodes_subdirs(struct dentry *mmdir)
 		if (IS_ERR(nodedir))
 			return PTR_ERR(nodedir);
 
-		ret = create_zones_subdirs(nodedir, pgdata);
+		ret = create_zones_subdirs(nodedir, pgdata, nid);
 		if (ret)
 			return ret;
 	}
-- 
2.55.0.629.g250fe7f194-goog


