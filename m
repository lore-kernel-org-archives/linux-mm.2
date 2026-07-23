Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A3DC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DA06B0105; Thu, 23 Jul 2026 03:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3856B0103; Thu, 23 Jul 2026 03:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C20A6B0105; Thu, 23 Jul 2026 03:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D216B0103
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B46AE8033D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:59 +0000 (UTC)
X-FDA: 85019267718.18.5727331
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12CAA40003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kqm5Uxo8;
	spf=pass (imf11.hostedemail.com: domain of 3pMdhagcKCBU4JzDxvD19916z.x97638FI-775Gvx5.9C1@flex--jyescas.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pMdhagcKCBU4JzDxvD19916z.x97638FI-775Gvx5.9C1@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqLzhDVDDZLVR/FPTjNaPDqvXax9+3/sETwGozJ8afI=;
	b=dLqC9CtkNzRpjBymcuJ3vjrSV8u8YU2dMg55WpnjOT7skpLXWTeZV95ckPIhctcqG1ovko
	th0EeAlaUHE+ZAdHl/G/qMUFMp6iVHzdhDonDz6BsGFu3my7j10lcKT6ENtR/uJCgnD6Tq
	sfwnH12QQR/XNNuHgMei5e1Ak4O3h30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792998;
	b=qKgyv5rrtz+j0ZJkAr4MKDcj0vPy0afXQa1TkqagDh/+fBeV2axiU0MxDClzOajA971WIm
	2Yy+do2c928qgIA60ZhqPjdZLfR8yJGKUDojn3XVBWhFrCwshx8NKX8SRZSD2/xyiVn7y2
	dth0RTedykJZMEIfB4kFVJkb89PgZEE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kqm5Uxo8;
	spf=pass (imf11.hostedemail.com: domain of 3pMdhagcKCBU4JzDxvD19916z.x97638FI-775Gvx5.9C1@flex--jyescas.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pMdhagcKCBU4JzDxvD19916z.x97638FI-775Gvx5.9C1@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so591133a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792997; x=1785397797; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mqLzhDVDDZLVR/FPTjNaPDqvXax9+3/sETwGozJ8afI=;
        b=Kqm5Uxo8PVugHS6oXhLFZvONCN7UDcFNKQzxS+GRb/83o0zLREeIJlpMxU21CWT/e2
         gRYKJ+wD+dUuG5/Bl1v/JpIgvN9iIlsU26DyjxfcYgCr9qrxU5EJax98ayhiQaILXmUD
         3Xycml3Jetegi8CzwSmz3ZPlD0572Vw44Xj0Navfhtp3TSXkxhbzVZvJvb2Ung/z2DFq
         AHuMDOifHEq8J4gyFgitHcTFH0qHfxPQaGKFp+WIp2KqnU9SYT9WVNHgdq8UrH7itwnZ
         /HjHMspBabexItYfFsSxrr0vSaPllAaCrMj2ILwD19oxUOCilq6nc1joBCP/UStHAsG/
         3GsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792997; x=1785397797;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mqLzhDVDDZLVR/FPTjNaPDqvXax9+3/sETwGozJ8afI=;
        b=tZwMPB5S8u/ogBt5kKXN5c3XS6/zQPygoVkZVke3LwrzS4GcOEOOXEZIbTz5ZI8G5c
         SfeSJg3aEHdb2acuWLA8HNDoFyKz73cGpiXsg+XKSpzX5VXSRgAxsJ82El1LLqhwlaqL
         9Fck+SdeY4rerqLHcot9DPjk3Mqh3IB43SOIQ3nxMkzOVox5QzPp8w02BxubEEVO+zKu
         Acx8A9G/ELbYz0OtNFqiWXDlueW7nnSO6Dg3BR6sqC+Y6swQCuF1idBjaHDmJ2qxMU/1
         t+Cxff1TKybkCCDhnm7tYqDqIR6xbY5VD70hD/89m5WjKIX3jlFE1T/c+L3ra+psppFL
         ATrQ==
X-Forwarded-Encrypted: i=1; AHgh+RokpEzdduciVyrMR3Fz1KhCFQOM3ZYUROT2ajYCasgA0GLd8Re0ZweQ1lFcBWQuZlVH9MRtx/aiwQ==@kvack.org
X-Gm-Message-State: AOJu0Yzv0Fv+eKgChITzyhkRzmapdBAlkBZEdpIh56qCMgyD+SyQqOhC
	k5EccWo9iv36PAnyKlbfqjc7vyPpkvjZ+VXdTijbN0g2WkDYZxQK+bvsYwnQoe+tpfITorekbVV
	ZbDG4xCRoGA==
X-Received: from dlbrh17.prod.google.com ([2002:a05:7022:f311:b0:13c:ea63:bd6f])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4c:b0:38e:524:8797
 with SMTP id 98e67ed59e1d1-38ec645e505mr2022963a91.13.1784792996824; Thu, 23
 Jul 2026 00:49:56 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:09 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-6-jyescas@google.com>
Subject: [RFC PATCH 05/16] mm: Define function to create a dir for populated zone
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 12CAA40003
X-Stat-Signature: c6rjju83knw4a5p9zmfd9rjt75ys94bk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784792997-304543
X-HE-Meta: U2FsdGVkX1/fr/WH//eVCaouH4fw1PHYVC0Mplg2lmii2MXjiC1+IYyx498SoB6P3PaHmf7/xgJ0FiB3BcLr+m+3bSE8HoYlGMEv/7tkqY02PPLdEBGn1qxoZx8ViumUg77mQQ1zFAWnFjgDoKfpoJlRYcXRpIqObbjosQ8lm1hZJNMgDKhu++Ij5kTurlHcc1PbWAzlNycL/mSS8PfnfVw5xD/48tPq29MxSo5eOqh7n76jZGiarWq22elIPreDFbQilZDqjlxZ30Ces/20PxTo2vGseb9HxgVmwhrHjY+fhsz7pMmqKAZz0ZwuE1+qo7V2paaccvxgbHA9ZzXkriYwMINOaM0Budet//t/rHG3MU4uj17J/UvPwUCrjMNxyPHTs1UTo5FqQfWROAiN57BafN+Tajnr016OdE/jjEixOUq06tt79NXLvZlKOdD/eZ7jzAherVq9zfbMqOmzDOZCvy35yWRD1kWnD8EqnOv4WGtJYDac7TfSFn57jeOqB9YZ/hLt7mZF3KqWUqeOt1d2nB5Sjfpk8NhFfYg99OoETD6y8TybeWySvTj5rlCGZTNDHGetF+tmeU+GGwlFKd67e6y52g//6qD0dVCAGZHjDpsr9/NQht6tIUhUKVd9WNgHcDc0ub2qAy4Ky2bgY1q8HAbIpfDelWD6rz7Yt6E3aIzZBKzrjmMQR4p74CKMqHY9d14ZMzePerW5MUS9SXxDkvyjflU4qKfrIQtyhg5sR1AedjWSEenLDZPkIz8YqK7UEiU11W7qxbyg9JzXZyChLd+oXnLpiGDBMaaJM8LiUB0vqKO9xzZP+bAy4+MQHVnnrfLqeXAamhw/NwMVM41KXHVGCVnupxzY+cUICAdcwWQkfOSXq65vfI2q0aUlcAqu64o7oaRAyTGVfyFct1ZUVl2QrDJh+35J23oupq1L9KUZjWJOElC/PgpB66n1usiRYJ1JNc/cQYO6BUq
 zzaLOTzb
 wts8h/+O+zH5NbM/qJb95Yzexhsk6mkDCMq16GQZwzTf/fXIyGVmjkxG0wWk94tlR+tAsnSAILpHmg0psBJDd1BsIQNjkv/xScw1p4BCqBhKqmsDNl44tNV/C7pvmIz0ivHHXyGSE89F/XN7sEf9/0kqAivsCZaT/hHYQA98tHCjt5/SgPLnusdKsDg91EPNLNPAXfOqGFwLJ203oyOjjHvfQgeIltUTuGqmFgrkGNjXl9aF+8k0QfW9cMfOd7SS9RMVpTuqln3nlL1RsNFDL8je1pyBRHJ8mIhIA0vmb0C6JWq4ko53j5qZiCCvKc5GIOy7BwhvZ1A5zVCZ9ts2Q58DAOxhJox8z+a9hyMQ+bbW4SzGc5iv89wzGKBfWqJGx6/Qgnj5Hm+s0aOe8kE1ghBFeZ5HkL2bIvV75LcDDqRTRnsxbwHlmTy1Q/1DrIRHXRKJbQnWAXOOutkmjPbVcA589Xxn+BjwTeF3Ku2XB1gfrLYLB8PLfbRhJ0z/cqXhpztrX3ql9k8CGW1ZY5MszFf/z8ldVd3f+7lseHmzyuUYibMjLHHEf80wIKN6SJ6wwQ3xBbDZ7GbXXoLPqOtj9nr8jG/Dx8eD0Nw1cOky0SLGJga1NXrfXGQzc8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each populated zone
in the node.

Note: ZONE_DEVICE pages won't be exposed in this driver
due they are not managed by the Buddy Allocator.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 880de1a6e9ea..1cec9ec5e35e 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -88,6 +88,7 @@
 #include <linux/gfp.h>
 #include <linux/gfp_types.h>
 #include <linux/kernel.h>
+#include <linux/mmzone.h>
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/printk.h>
@@ -126,6 +127,41 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_zones_subdirs() - Creates a directory for each populated zone in the
+ * node. Once that the zone directory is created, it creates a directory for
+ * each order supported.
+ *
+ * Note: ZONE_DEVICE pages won't be allocated using this driver. The main reason
+ * is because they are not managed by the Buddy Allocator or CMA allocator.
+ */
+static inline int create_zones_subdirs(struct dentry *nodedir, int node_idx,
+				       struct pglist_data *pgdata)
+{
+	struct dentry *zonedir;
+	struct zone *zone;
+	struct zone *node_zones = pgdata->node_zones;
+	int zone_idx;
+	char dirname[24];
+
+	for (zone = node_zones, zone_idx = 0; zone - node_zones < MAX_NR_ZONES;
+	     ++zone, ++zone_idx) {
+		if (!populated_zone(zone))
+			continue;
+
+		/* ZONE_DEVICE pages won't be allocated using this driver. */
+		if (zone_is_zone_device(zone))
+			continue;
+
+		snprintf(dirname, sizeof(dirname), "zone-%s", zone->name);
+		zonedir = debugfs_create_dir(dirname, nodedir);
+		if (IS_ERR(zonedir))
+			return PTR_ERR(zonedir);
+	}
+
+	return 0;
+}
+
 /**
  * create_nodes_subdirs() - Creates a directory for each online node in the
  * system. Once that the node directory is created, it creates a directory for
@@ -136,12 +172,19 @@ static inline int create_nodes_subdirs(struct dentry *mmdir)
 	struct dentry *nodedir;
 	int node_idx;
 	char dirname[12];
+	int ret;
 
 	for_each_online_node(node_idx) {
+		struct pglist_data *pgdata = NODE_DATA(node_idx);
+
 		snprintf(dirname, sizeof(dirname), "node-%d", node_idx);
 		nodedir = debugfs_create_dir(dirname, mmdir);
 		if (IS_ERR(nodedir))
 			return PTR_ERR(nodedir);
+
+		ret = create_zones_subdirs(nodedir, node_idx, pgdata);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.229.g6434b31f56-goog


