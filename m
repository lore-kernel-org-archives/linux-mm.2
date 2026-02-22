Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFEBC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B1B6B00A6; Sun, 22 Feb 2026 03:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10B36B00A8; Sun, 22 Feb 2026 03:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2CD6B00A9; Sun, 22 Feb 2026 03:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C58616B00A6
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8FB9BA180
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:39 +0000 (UTC)
X-FDA: 84471469278.05.A865761
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CF43180008
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cHN0CjTU;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yj+ZkijP1F57uDkd+kIZ1Nriaysy+Ep+EgiXsVeVTU=;
	b=URJfOzv7hrfAHdIJ/73YIsu1pZerXgde+aSqN3Ji4kaSlIR49b7uvrf5f5H++izWNArF86
	hNPNcH581aORHEOy40aHHZrYbbgQZerpe301naVLuXUj9VG+J3q6AZDT7Vq9Y/UXsAIx+E
	d93qOKoq7M3DQ//4HwKTf03RTM6CELk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cHN0CjTU;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750178; a=rsa-sha256;
	cv=none;
	b=FjuxmO5RVCYI1/EAqoHm8HNf1iGfmwTY9oJGnXO4TimU3P11MsK8kTTGFP4xemzuMUR3rq
	Ks2zGeYXbkSiHhyLa+vZzisLnW9WmHCKaVsQnM9FaM859qNC11m+SGo7v/lieoX1oq6xyT
	5kXtxci4IvtU1xLaAlKkc93mRAwKzAQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5062fc5d86aso33208931cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750177; x=1772354977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yj+ZkijP1F57uDkd+kIZ1Nriaysy+Ep+EgiXsVeVTU=;
        b=cHN0CjTULxXzjBxjxyuz5aRLUTPBhkkSLObv1y7DbI/HyQrAjLWi6g3SuwBjSr5iQ1
         7DAZDb/TcRZqAc3LIJuP2qO8rBorX5Vw3zNI5JkiuXNUGJ9leLSHFK170FAkGmpTS3yb
         +wBswVFfu+bSoyEPIf9YNZ2quIq0e2mAYeTTsCyJhHdh0nyokJE7PnVauWGGLAiZLapI
         aTW9eVaqIqMUfbwrIzlFZQmJB3r8f4RHbIJnsi/JedRn9RRgiJUYOJ6BGor9itqJ2yYe
         x0jCfh9kpfATQCNp98FX4x3mAYJPtb9AZYhXaMPM3GyuXT4xHA/SzKi2aFYdKCuNtFCs
         PHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750177; x=1772354977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/yj+ZkijP1F57uDkd+kIZ1Nriaysy+Ep+EgiXsVeVTU=;
        b=DGADO4gvelLgCuk+Cu87lKwziWUF4zV1GDDouK7jmM6o/TvG38+RjIuJLKiXlNN6/M
         TvdvTS1eBhY8SuB432iLSVw2uDZnagnKEX+anmO4d2KIT2qF+9hYTNAgNblCPsH1WZF0
         BpoBaJjRFPVUDb3WttzGIxROJTI1qK8FLcZeeRqMajfRd5UozxUqrsUoITcSWuEKcY7P
         7jDrrqY2S9EPvO1d4riEDmcvt9EDFK1I5NW5PAy9rESDaMjUwpFiYHkjSEZZTXsNVwrr
         cVE0z3cT2G4tt9/XZ4uVS7xPjlflye1Xb/UQPWY8+mM7Cj7CFX4yemHjfluzuGqWmWtC
         hXag==
X-Forwarded-Encrypted: i=1; AJvYcCUTGUc3W21Ge2IbyR31+3qiVHuKj5xzRVvrwKanPazYJs7gFH6sS4gxvc/YcPafXata5ws+zgHD+Q==@kvack.org
X-Gm-Message-State: AOJu0YxYMTd2ke7GQAT9/XGoDQHsAaWERRz97zHqgKM2ge5VrfIRYWfQ
	G2l40guS/85jWSJ/qaE0psNv4q5hTgowZaK8/CIDUndcLZQPYl4lb2IqsFlkPYTF4Xw=
X-Gm-Gg: AZuq6aKuXN+4KdBPZyuWvhRDQQvfjnCl7tkZwmjHWMEEfrqJabzMIyQWr7HtrnFYi+3
	cJ9M1NM1ozWswpea49EdUfStP8xVDlJKhxjy+MJpOxVJhQFpZ5KTa27vpGpRnneHUHgJUFkmpEM
	8Woc4EToK5m/jXB3TRNgz7/MMxmISxgSOEMzyxUWrhr/6zD5bu8UuGxgG4uhaLjuyqdyxanIcBH
	HC1N1yBgy+6zDIVefiLsCVgUVYBa/sewB8SQ+q5VaJurzHNiBG/skjp9rOibBCZjKjLatkEzMK8
	83sZeG2xXsPDQFQ2XDdpRxM8QnrPyyQv+E3ttrHL2kjmsQt7GQn3Q/M6vw+Z/W7VnQswNhyQiVe
	T0XIFsB04mRSoc1GdC++QU1LrMUdaSPmOlrpzOxJhSXf6fkR58B95hY3HsHmu93muUi/0F4xXoe
	M7qFD7o/XQI44HiStR7Xyum+KANb7Vw6fuHTKgQJqdGmI1BhjI85z2Fk3zEl+YvEJY0rMUEx2Fr
	mTuDiwT0MbfKNY=
X-Received: by 2002:ac8:5f52:0:b0:4f1:b712:364a with SMTP id d75a77b69052e-5070bc84890mr75076581cf.56.1771750177109;
        Sun, 22 Feb 2026 00:49:37 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:36 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 11/27] mm/huge_memory.c: add private node folio split notification callback
Date: Sun, 22 Feb 2026 03:48:26 -0500
Message-ID: <20260222084842.1824063-12-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fhxb6xhp8kjp8tg689te49mjomhp7kf
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CF43180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771750177-730113
X-HE-Meta: U2FsdGVkX1+idSn6vxv6M1BA5AZwMD3p89DEtl25h7NhH2jvh+2a6okA9K8LhCWnKWVX8YffSrOaC8K8n/Rifx6c793kftlXQOr4cobTPWsyNDPgzG2GgKPTSS+tK3U9R6Np2r3QeMMGV4+ZeoQdWyZOhdg+FEm/ZIkoJuhkxQ+Al6OAawsSVggH81MTXTQJFAELxGe/IzIFWUfH7nZblkMnXnPH0idO7M6PKFBz8JZyesGt8gO3IR3crbdSuyFc5rfaY0PDdJB4BaircGMtMIevNabTWA/oWcOVI8tlaL9D1atGRw4bUR3IJg/nwIGaMzedKBDYN6qisG52RbOcV3zPbG+9DZAL9koRrITEIaaU+aVZV7CYBfsU2uemPfA2VLj0AwgOIXXn2lneso/8ZnB7iZYrjSw/tQn3q7iHyVRvIX1o81sHUrio9YDDpYyhIvvh40NRSuuOAMerJhYmj6Ar2YcDcjVIIA5Yy9iM83rTxhL47DMGfMVd0VPXu8Qc7LEKGc2bVcGhWJ8czyxHFGDnW74FZ3O8VLLk9qUZQmY7HTuAS+EyG0eHx9Jg4KTZD9BjizCi6kOReZvTWwmWBfnEmCZE4LBbdjoDFuh7dQUQgqi1lUXlqTcp04IqE9h+5IiwiGuXKpFVMwh7FSHFrraqJC45bCw+iwpQ/pHiKE/b2T6lPel8wLjJs+YcTTLgf3t2ZRksEk7dRzNQY/Iu6U2NpeDXxGSaOd68BM7fIlauJiaVcLaERIfz2jEYqOd/oDHylznPJuJHYGmwiHGX2SM9Qsg1QWrvTfRwMMP/8E0lIUlXjlQnmNJ7pToApY6VbmzVHOnO6cCr7o7kkdXTC9bYn/achK6SX6l4PZxSgqVcCI73gniwRzvjVLQUOwe1u079WzH8Q6cKgK5n5aJXXMS2IYWCvI0athGuN3gtudIT3xVqK5E6E4+FLFpvXKvSgnvcS3QV34og5EdvcH/
 K+9bHJVf
 TnlbNZ5F6FGUXrpcRc+QZBnVklYvcHjK+3ZCOx4b29Owenv6Ee1SbyCe54sGdykvSOMrB4e8tOHaKdgJHi/De5dHjXA0Go4y/CKHAdC/YoonCCvTlXhWBoECBtvfRtM6JoctQHbzmc4oCw6tXrOVpT8cYQFsftmNVjuy5H4jNFcA6Hwmtm2bznUVlNKAQ5M1qKnHxyjzpNqQ4Ej4S098GuXCPFtnMbdDgSIM9JZCUx0NfMXuUr5rLy2LBLR8ATWFGivuL3eW2dyOG2bYEqioMGqIwiHezFWHoDncXgz44ayfyeJNiFEpw3Hj+xMQfNuCsB9l6PCTksGKL/PIFNQUsO6nheehc4gMZkTsfn5HLesW77rZ5BacyYnZy+U2BJJgugpOuOAT6kvJDzUHejPDU/RLkYUTN8qUrjYpPzukipqhj7wlnE23n8J2h4iI4BgX06JzbaE6425/YChE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some private node services may need to update internal metadata when
a THP folio is split.  ZONE_DEVICE already has a split callback via
pgmap->ops; private nodes can provide the same capability.

Just like zone_device, some private node services may want to know
about a folio being split.  Add this optional callback to the ops
struct and add a wrapper for zone_device and private node callback
dispatch to be consolidated.

Wire this into __folio_split() where the zone_device check was made.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 33 +++++++++++++++++++++++++++++++++
 mm/huge_memory.c             |  6 ++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 09ea7c4cb13c..f9dd2d25c8a5 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -3,6 +3,7 @@
 #define _LINUX_NODE_PRIVATE_H
 
 #include <linux/completion.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
@@ -44,11 +45,19 @@ struct vm_fault;
  *   Returns: true if handled (skip return to buddy)
  *            false if no op (return to buddy)
  *
+ * @folio_split: Notification that a folio on this private node is being split.
+ *    [folio-referenced callback]
+ *     Called from the folio split path via folio_managed_split_cb().
+ *     @folio is the original folio; @new_folio is the newly created folio,
+ *     or NULL when called for the final (original) folio after all sub-folios
+ *     have been split off.
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
 struct node_private_ops {
 	bool (*free_folio)(struct folio *folio);
+	void (*folio_split)(struct folio *folio, struct folio *new_folio);
 	unsigned long flags;
 };
 
@@ -150,6 +159,24 @@ static inline bool zone_private_flags(struct zone *z, unsigned long flag)
 	return node_private_flags(zone_to_nid(z)) & flag;
 }
 
+static inline void node_private_split_cb(struct folio *folio,
+					 struct folio *new_folio)
+{
+	const struct node_private_ops *ops = folio_node_private_ops(folio);
+
+	if (ops && ops->folio_split)
+		ops->folio_split(folio, new_folio);
+}
+
+static inline void folio_managed_split_cb(struct folio *original_folio,
+					  struct folio *new_folio)
+{
+	if (folio_is_zone_device(original_folio))
+		zone_device_private_split_cb(original_folio, new_folio);
+	else if (folio_is_private_node(original_folio))
+		node_private_split_cb(original_folio, new_folio);
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -198,6 +225,12 @@ static inline bool zone_private_flags(struct zone *z, unsigned long flag)
 	return false;
 }
 
+static inline void folio_managed_split_cb(struct folio *original_folio,
+					  struct folio *new_folio)
+{
+	if (folio_is_zone_device(original_folio))
+		zone_device_private_split_cb(original_folio, new_folio);
+}
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..2ecae494291a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -24,6 +24,7 @@
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/memremap.h>
+#include <linux/node_private.h>
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
 #include <linux/migrate.h>
@@ -3850,7 +3851,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 			next = folio_next(new_folio);
 
-			zone_device_private_split_cb(folio, new_folio);
+			folio_managed_split_cb(folio, new_folio);
 
 			folio_ref_unfreeze(new_folio,
 					   folio_cache_ref_count(new_folio) + 1);
@@ -3889,7 +3890,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			folio_put_refs(new_folio, nr_pages);
 		}
 
-		zone_device_private_split_cb(folio, NULL);
+		folio_managed_split_cb(folio, NULL);
+
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
-- 
2.53.0


