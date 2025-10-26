Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85D5CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C458E0182; Sun, 26 Oct 2025 16:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25468E0120; Sun, 26 Oct 2025 16:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0F68E0182; Sun, 26 Oct 2025 16:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0B58E0120
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DA77586F5
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:27 +0000 (UTC)
X-FDA: 84041423214.04.6ECBC7B
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F75C4000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4IGEr2fv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3SIb-aAYKCJ0PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3SIb-aAYKCJ0PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510985; a=rsa-sha256;
	cv=none;
	b=HWaj3hVzkyOX4fE6SDEjeVgnPl3IFpMsBglF9sVXrS9BPnx5ufQ1qhkzRRImldCRYTRqms
	5kHFkU5Et8hnd0ITgB2wDNCThGnxT96O8oaENPp3xolLFayVhv49b6IfmiyQp5F2FYF/lI
	fzL3/tkkbSV9mx966xSgmSZGAeBsR3Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4IGEr2fv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3SIb-aAYKCJ0PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3SIb-aAYKCJ0PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQ6iXUx7fdxDQQtP216r+2zXM18ReAZgBiEpXox9Qzk=;
	b=E+sqeyN4t2sovOCUP/CIQbsJktRQOMS9wyGuhKAZrm6J+C9xzP7Yv0kWBFR9jvYKTtOn4f
	o/CZlot54Ezpf6K1KP5U4nWNGviG4Q0J4xwQ6T7d1pSP+sVUFBcwSZRkVKVf+jUxm1FGRK
	iPSHJ91KyEGisUKQ4gF9/3lLzCYEe8k=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so3635166a91.0
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510984; x=1762115784; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ6iXUx7fdxDQQtP216r+2zXM18ReAZgBiEpXox9Qzk=;
        b=4IGEr2fvUoZ+CURDwMNLTJkNjwtHzsQEz2hm8I+m4yRreMTyR7WogrZColHlT7gprR
         /PSW97bAqUnjILM0HTsZhzdaaGbl5GnANKE6v1rRcb40iaw/Gxw013Z3yEErqBDulrZE
         zkq7gPwI6EpNKuqOMtkPqfCXXTLQXO25b8wjT1ONY3Yj1kLYLtLpot96sW2Bhholu6a2
         MkdAJ4O0GulsJvgfA2b47zgsYpVPVRKJMOQtuBTK9uf/0n6RHEBrIbPPndyPGKWFDlNe
         +XrILTNrgoUNx3vh6AruFWQ2xhJdJNHhkLVWZTwlYdTojcm4KopauSI2za8vVbYJjTBT
         4fpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510984; x=1762115784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ6iXUx7fdxDQQtP216r+2zXM18ReAZgBiEpXox9Qzk=;
        b=ZCjj/+qSD8u2p3vAvm/OKDkkdI2NiCEx3Z1Y+SB+x1SOSR8yUy3D7YzcDk9YLDxe+b
         cvFtBqdE/JO/4OOBEcrMvKP1OIpxaCGVkNWu7DATzdGgHZG0n7Q3srBpLH+8qhz/OWrU
         yp9KJQWxu714kMzN9d7YxL2FV21PaWvphsyOyb+VDs6bO85Tw127EiD2cr6VNQAcxlKt
         m4kw7wNNXzCWwBgx4fjOkgepVAMdZgn3czO++hNI9xjrVfL2tPSQS0F4qJP/rqjfYz+t
         vVgG/zB4eGmqkBS57tIij2MHzUB9WZDHRsHwD1nNqSZqSDqXlDTEq07IXFXEabYTwWyn
         zUDw==
X-Forwarded-Encrypted: i=1; AJvYcCVeAnduBXvYdB7hVckSiYu1Wi0B3rHjCLk6Zk0F4zcQQIk0ehe7449mpfumQNmUEWDfES660V4uoA==@kvack.org
X-Gm-Message-State: AOJu0YxiQ7IBCqHs+0mdo0B3qNPgOy9QFJsUEAxOguzcjrsTta2tTSwf
	zZOoHhdl4GHOiHFA0vBw8p2G2HV7wNk66PNSaHEGLOp43sg8pmL2S3IdggmAWf+SUjuu/DES53U
	FytrXNw==
X-Google-Smtp-Source: AGHT+IFuTXFJaYUk8PlETNcdc2dA3jjCPbMMSpMoPQFxxPNRetezNstDACl0wQ0NFejn/XrjXpIWmWOUlEM=
X-Received: from pjbiq12.prod.google.com ([2002:a17:90a:fb4c:b0:32b:ae4c:196c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164a:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-33fafbaabb4mr15962311a91.9.1761510984182; Sun, 26
 Oct 2025 13:36:24 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:07 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-5-surenb@google.com>
Subject: [PATCH v2 4/8] mm/cleancache: add sysfs interface
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F75C4000A
X-Stat-Signature: diq4a9z3s7aky43cx3rb8qza5fnqs9ym
X-HE-Tag: 1761510985-83242
X-HE-Meta: U2FsdGVkX18gBJDHTcgmG8g3NPQKVzyG9zZ4qaA7DZTokiMgWG7nKGZ+Ygm62PI9ywluX56CgMz1w9vvTVQrNbDD5aRSixFp3KrsVCcT2eNFbEILwJnhTYIMYWHDsN2Eu5nUIZzYJkvHAFHQs6/LAoDsrj3Pz8axvR1KeJo30g4C+PhBwNbpkWEJWnZXe1L43/NuAM4ggYnf7k+QagctUVBItil9QR6/fhH4CeivOf0Ex3IPdgD52IFzOlNrDtrEfbn8Zb8jEic3wg/nyZ8umc12o+54CV9H5L3NmpKsFP+Ilz6kA424S5YkJLNoiOIPJD1DsvDUxbZRCCl6k8nKHWpIHCVgfsqIMh23xmJyk4Cc8OBnF9+IfFFM6CfbiO7BdQzqrn8Tif6oT1cdo73LhdzPRfr3uu282FQQWa5QfRWdBCREnrS33xIWpB2PN5M5NZ9qVN0+bbLxFVi6sq8D19DHnz7rUs5tXV39n453KlPubAAtw4af5+wneReF2n8HbEOhrfglWtDKOdrLLXPw3t4kaGVKumKM7037XR26AVHCOKYDhvzuDm10DmwTk44fF85/HvP8hBzR6W9WWvN2ePQvgqPuRfHCJPl8NrFPTYYdtLj187qFgc8zO1xncmgsr+yDNs06uukR+LgOUao1QcT+GaWzadmqB9wngiO10CZ9ae8MlPwjE9Af4lJuzGiSQSQFgFe+I4+d6mN8gyJZn4LCrbBzAerGW1243H3r/nUUf5HvNkIxC85JiG/spsB+Qtfl/9ZkQuzTQhQcmg96nFa1Bw5/4HFy4v5Jeoe3kPYu5nXI0BfF4fNgt9EJsW+VWn/v94sog43P+S81tEVEYhqjhZgKghR+cUMgixz1KGUsx3tQ92K7BJeF06NGoXTk5h5Fe05etWQvNbWLta+TS0p/XHIFaB6Yfkr+9ltiwWE6O32LqVzudap8EuIPDII9d1Bz6xVm8h8vtxrJJ98
 g5aX/lzP
 OPIa3zgu6BYabeR8PAiqs9pS9w6aS0luBJhdGANdFYEL9RIVjWmd5GbkqQ9e+895XoQqRboEInxlopu9YtKnQGPl/cbUzBOsmvxPysfFMDzyGs5CBVcvLdeBW4vxuULtWjrMAQ18e97fO5yZ8UnR+6FVP2XXNOYiSmDj+KlJ+rEHNOyiMA7UIFZhuj1nwsE4lTZXaQjxqPgTGd5zw990cZne8u7Y03SBP6Bn1oLUMOx0UfsvahdklBtgEOFsxMEv7OlsYdfFhmjUFkAxGHvrf8WRlZpmYFfA6nAvTvjJBcfBxt4hVfYcU7+FIjWd1YBeBxNa7gQ65tCf9livZEXcOOvPkrFiy7TzRBGujJ9sy9K7MS1/1XoyXxV49WnmvW68iBUi7qmuBUqimgy4ItAmNK1FFZIngTwPqiNJvPp9z6ByeVTCS7kp196SNC3ra5l3bTJCYMqkvMzfsyUpvQRWrTCT9tGoRyDgf24zywAhy4tzFGrbSbjViUUXpjLcIFHVnIqZCEjty8NHPc2c/FR6EH+HUh9PySebw88mwJ+a4rRIag8ikjSnv4wGX57ZfG6ihFTToYLVEAAM8ZvmGjuJ20xq+0J7twg4sTc2eEVxCNqPZZA6S2Un1cYJ3Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create sysfs API under /sys/kernel/mm/cleancache/ to report the following
metrics:
  stored      - number of successful cleancache folio stores
  skipped     - number of folios skipped during cleancache store operation
  restored    - number of successful cleancache folio restore operations
  missed      - number of failed cleancache folio restore operations
  reclaimed   - number of folios dropped due to their age
  recalled    - number of folios dropped because cleancache backend took
                them back
  invalidated - number of folios dropped due to invalidation
  cached      - number of folios currently cached in the cleancache

In addition each pool creates a /sys/kernel/mm/cleancache/<pool name>
directory containing the following metrics:
  size        - number of folios in the pool
  cached      - number of folios currently cached in the pool
  recalled    - number of folios dropped from the pool because cleancache
                backend took them back

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 MAINTAINERS           |   2 +
 mm/Kconfig            |   8 ++
 mm/Makefile           |   1 +
 mm/cleancache.c       | 113 +++++++++++++++++++++--
 mm/cleancache_sysfs.c | 209 ++++++++++++++++++++++++++++++++++++++++++
 mm/cleancache_sysfs.h |  58 ++++++++++++
 6 files changed, 383 insertions(+), 8 deletions(-)
 create mode 100644 mm/cleancache_sysfs.c
 create mode 100644 mm/cleancache_sysfs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 90a6fc0e742c..84c65441925c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6060,6 +6060,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/cleancache.h
 F:	mm/cleancache.c
+F:	mm/cleancache_sysfs.c
+F:	mm/cleancache_sysfs.h
 
 CLK API
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/mm/Kconfig b/mm/Kconfig
index 1255b543030b..e1a169d5e5de 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1049,6 +1049,14 @@ config CLEANCACHE
 
 	  If unsure, say N.
 
+config CLEANCACHE_SYSFS
+	bool "Cleancache information through sysfs interface"
+	depends on CLEANCACHE && SYSFS
+	help
+	  This option exposes sysfs attributes to get information from
+	  cleancache. The user space can use this interface for querying
+	  cleancache and individual cleancache pool metrics.
+
 config CMA
 	bool "Contiguous Memory Allocator"
 	depends on MMU
diff --git a/mm/Makefile b/mm/Makefile
index b78073b87aea..a7a635f762ee 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_CLEANCACHE_SYSFS)	+= cleancache_sysfs.o
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 6be86938c8fe..e05393fb6cbc 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -11,6 +11,8 @@
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
 
+#include "cleancache_sysfs.h"
+
 /*
  * Lock nesting:
  *	ccinode->folios.xa_lock
@@ -56,6 +58,8 @@ struct cleancache_inode {
 struct cleancache_pool {
 	struct list_head folio_list;
 	spinlock_t lock; /* protects folio_list */
+	char *name;
+	struct cleancache_pool_stats *stats;
 };
 
 #define CLEANCACHE_MAX_POOLS	64
@@ -104,6 +108,7 @@ static void attach_folio(struct folio *folio, struct cleancache_inode *ccinode,
 
 	folio->cc_inode = ccinode;
 	folio->cc_index = offset;
+	cleancache_pool_stat_inc(folio_pool(folio)->stats, POOL_CACHED);
 }
 
 static void detach_folio(struct folio *folio)
@@ -112,6 +117,7 @@ static void detach_folio(struct folio *folio)
 
 	folio->cc_inode = NULL;
 	folio->cc_index = 0;
+	cleancache_pool_stat_dec(folio_pool(folio)->stats, POOL_CACHED);
 }
 
 static void folio_attachment(struct folio *folio,
@@ -516,7 +522,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 	ccinode = find_and_get_inode(fs, inode);
 	if (!ccinode) {
 		if (!workingset)
-			return false;
+			goto out;
 
 		ccinode = add_and_get_inode(fs, inode);
 		if (IS_ERR_OR_NULL(ccinode)) {
@@ -536,6 +542,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 	if (stored_folio) {
 		if (!workingset) {
 			move_folio_from_inode_to_pool(ccinode, offset, stored_folio);
+			cleancache_stat_inc(RECLAIMED);
 			goto out_unlock;
 		}
 		rotate_lru_folio(stored_folio);
@@ -551,6 +558,8 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			xa_lock(&ccinode->folios);
 			if (!stored_folio)
 				goto out_unlock;
+
+			cleancache_stat_inc(RECLAIMED);
 		}
 
 		if (!store_folio_in_inode(ccinode, offset, stored_folio)) {
@@ -562,6 +571,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			spin_unlock(&pool->lock);
 			goto out_unlock;
 		}
+		cleancache_stat_inc(STORED);
 		add_folio_to_lru(stored_folio);
 	}
 	copy_folio_content(folio, stored_folio);
@@ -573,6 +583,8 @@ static bool store_into_inode(struct cleancache_fs *fs,
 		remove_inode_if_empty(ccinode);
 	xa_unlock(&ccinode->folios);
 	put_inode(ccinode);
+out:
+	cleancache_stat_inc(SKIPPED);
 
 	return ret;
 }
@@ -583,23 +595,26 @@ static bool load_from_inode(struct cleancache_fs *fs,
 {
 	struct cleancache_inode *ccinode;
 	struct folio *stored_folio;
-	bool ret = false;
 
 	ccinode = find_and_get_inode(fs, inode);
-	if (!ccinode)
+	if (!ccinode) {
+		cleancache_stat_inc(MISSED);
 		return false;
+	}
 
 	xa_lock(&ccinode->folios);
 	stored_folio = xa_load(&ccinode->folios, offset);
 	if (stored_folio) {
 		rotate_lru_folio(stored_folio);
 		copy_folio_content(stored_folio, folio);
-		ret = true;
+		cleancache_stat_inc(RESTORED);
+	} else {
+		cleancache_stat_inc(MISSED);
 	}
 	xa_unlock(&ccinode->folios);
 	put_inode(ccinode);
 
-	return ret;
+	return !!stored_folio;
 }
 
 static bool invalidate_folio(struct cleancache_fs *fs,
@@ -614,8 +629,10 @@ static bool invalidate_folio(struct cleancache_fs *fs,
 
 	xa_lock(&ccinode->folios);
 	folio = xa_load(&ccinode->folios, offset);
-	if (folio)
+	if (folio) {
 		move_folio_from_inode_to_pool(ccinode, offset, folio);
+		cleancache_stat_inc(INVALIDATED);
+	}
 	xa_unlock(&ccinode->folios);
 	put_inode(ccinode);
 
@@ -636,6 +653,7 @@ static unsigned int invalidate_inode(struct cleancache_fs *fs,
 		ret = erase_folios_from_inode(ccinode, &xas);
 		xas_unlock(&xas);
 		put_inode(ccinode);
+		cleancache_stat_add(INVALIDATED, ret);
 
 		return ret;
 	}
@@ -643,6 +661,53 @@ static unsigned int invalidate_inode(struct cleancache_fs *fs,
 	return 0;
 }
 
+/* Sysfs helpers */
+#ifdef CONFIG_CLEANCACHE_SYSFS
+
+static struct kobject *kobj_sysfs_root;
+
+static void __init cleancache_sysfs_init(void)
+{
+	struct cleancache_pool *pool;
+	int pool_id, pool_count;
+	struct kobject *kobj;
+
+	kobj = cleancache_sysfs_create_root();
+	if (IS_ERR(kobj)) {
+		pr_warn("Failed to create cleancache sysfs root\n");
+		return;
+	}
+
+	kobj_sysfs_root = kobj;
+	if (!kobj_sysfs_root)
+		return;
+
+	pool_count = atomic_read(&nr_pools);
+	pool = &pools[0];
+	for (pool_id = 0; pool_id < pool_count; pool_id++, pool++)
+		if (cleancache_sysfs_create_pool(kobj_sysfs_root, pool->stats, pool->name))
+			pr_warn("Failed to create sysfs nodes for \'%s\' cleancache backend\n",
+				pool->name);
+}
+
+static void cleancache_sysfs_pool_init(struct cleancache_pool_stats *pool_stats,
+				       const char *name)
+{
+	/* Skip if sysfs was not initialized yet. */
+	if (!kobj_sysfs_root)
+		return;
+
+	if (cleancache_sysfs_create_pool(kobj_sysfs_root, pool_stats, name))
+		pr_warn("Failed to create sysfs nodes for \'%s\' cleancache backend\n",
+			name);
+}
+
+#else /* CONFIG_CLEANCACHE_SYSFS */
+static inline void cleancache_sysfs_init(void) {}
+static inline void cleancache_sysfs_pool_init(struct cleancache_pool_stats *pool_stats,
+					      const char *name) {}
+#endif /* CONFIG_CLEANCACHE_SYSFS */
+
 /* Hooks into MM and FS */
 int cleancache_add_fs(struct super_block *sb)
 {
@@ -820,6 +885,7 @@ cleancache_start_inode_walk(struct inode *inode, unsigned long count)
 	ccinode = find_and_get_inode(fs, inode);
 	if (!ccinode) {
 		put_fs(fs);
+		cleancache_stat_add(MISSED, count);
 		return NULL;
 	}
 
@@ -850,7 +916,10 @@ bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
 		memcpy(dst, src, PAGE_SIZE);
 		kunmap_local(dst);
 		kunmap_local(src);
+		cleancache_stat_inc(RESTORED);
 		ret = true;
+	} else {
+		cleancache_stat_inc(MISSED);
 	}
 	xa_unlock(&ccinode->folios);
 
@@ -864,9 +933,18 @@ bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
  */
 int cleancache_backend_register_pool(const char *name)
 {
+	struct cleancache_pool_stats *pool_stats;
 	struct cleancache_pool *pool;
+	char *pool_name;
 	int pool_id;
 
+	if (!name)
+		return -EINVAL;
+
+	pool_name = kstrdup(name, GFP_KERNEL);
+	if (!pool_name)
+		return -ENOMEM;
+
 	/* pools_lock prevents concurrent registrations */
 	spin_lock(&pools_lock);
 	pool_id = atomic_read(&nr_pools);
@@ -878,12 +956,22 @@ int cleancache_backend_register_pool(const char *name)
 	pool = &pools[pool_id];
 	INIT_LIST_HEAD(&pool->folio_list);
 	spin_lock_init(&pool->lock);
+	pool->name = pool_name;
 	/* Ensure above stores complete before we increase the count */
 	atomic_set_release(&nr_pools, pool_id + 1);
 	spin_unlock(&pools_lock);
 
+	pool_stats = cleancache_create_pool_stats(pool_id);
+	if (!IS_ERR(pool_stats)) {
+		pool->stats = pool_stats;
+		cleancache_sysfs_pool_init(pool_stats, pool->name);
+	} else {
+		pr_warn("Failed to create pool stats for \'%s\' cleancache backend\n",
+			pool->name);
+	}
+
 	pr_info("Registered \'%s\' cleancache backend, pool id %d\n",
-		name ? : "none", pool_id);
+		name, pool_id);
 
 	return pool_id;
 }
@@ -930,10 +1018,13 @@ int cleancache_backend_get_folio(int pool_id, struct folio *folio)
 		goto again;
 	}
 
+	cleancache_stat_inc(RECALLED);
+	cleancache_pool_stat_inc(folio_pool(folio)->stats, POOL_RECALLED);
 	put_inode(ccinode);
 out:
 	VM_BUG_ON_FOLIO(folio_ref_count(folio) != 0, (folio));
 	clear_cleancache_folio(folio);
+	cleancache_pool_stat_dec(pool->stats, POOL_SIZE);
 
 	return 0;
 }
@@ -955,6 +1046,7 @@ int cleancache_backend_put_folio(int pool_id, struct folio *folio)
 	INIT_LIST_HEAD(&folio->lru);
 	spin_lock(&pool->lock);
 	add_folio_to_pool(folio, pool);
+	cleancache_pool_stat_inc(pool->stats, POOL_SIZE);
 	spin_unlock(&pool->lock);
 
 	return 0;
@@ -967,6 +1059,7 @@ int cleancache_backend_put_folios(int pool_id, struct list_head *folios)
 	LIST_HEAD(unused_folios);
 	struct folio *folio;
 	struct folio *tmp;
+	int count = 0;
 
 	list_for_each_entry_safe(folio, tmp, folios, lru) {
 		/* Do not support large folios yet */
@@ -976,10 +1069,12 @@ int cleancache_backend_put_folios(int pool_id, struct list_head *folios)
 
 		init_cleancache_folio(folio, pool_id);
 		list_move(&folio->lru, &unused_folios);
+		count++;
 	}
 
 	spin_lock(&pool->lock);
 	list_splice_init(&unused_folios, &pool->folio_list);
+	cleancache_pool_stat_add(pool->stats, POOL_SIZE, count);
 	spin_unlock(&pool->lock);
 
 	return list_empty(folios) ? 0 : -EINVAL;
@@ -992,6 +1087,8 @@ static int __init init_cleancache(void)
 	if (!slab_inode)
 		return -ENOMEM;
 
+	cleancache_sysfs_init();
+
 	return 0;
 }
-core_initcall(init_cleancache);
+subsys_initcall(init_cleancache);
diff --git a/mm/cleancache_sysfs.c b/mm/cleancache_sysfs.c
new file mode 100644
index 000000000000..5ad7ae84ca1d
--- /dev/null
+++ b/mm/cleancache_sysfs.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kobject.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include "cleancache_sysfs.h"
+
+static atomic64_t stats[CLEANCACHE_STAT_NR];
+
+void cleancache_stat_inc(enum cleancache_stat type)
+{
+	atomic64_inc(&stats[type]);
+}
+
+void cleancache_stat_add(enum cleancache_stat type, unsigned long delta)
+{
+	atomic64_add(delta, &stats[type]);
+}
+
+void cleancache_pool_stat_inc(struct cleancache_pool_stats *pool_stats,
+			      enum cleancache_pool_stat type)
+{
+	atomic64_inc(&pool_stats->stats[type]);
+}
+
+void cleancache_pool_stat_dec(struct cleancache_pool_stats *pool_stats,
+			      enum cleancache_pool_stat type)
+{
+	atomic64_dec(&pool_stats->stats[type]);
+}
+
+void cleancache_pool_stat_add(struct cleancache_pool_stats *pool_stats,
+			      enum cleancache_pool_stat type, long delta)
+{
+	atomic64_add(delta, &pool_stats->stats[type]);
+}
+
+#define CLEANCACHE_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static inline struct cleancache_pool_stats *kobj_to_stats(struct kobject *kobj)
+{
+	return container_of(kobj, struct cleancache_pool_stats, kobj);
+}
+
+static ssize_t stored_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[STORED]));
+}
+CLEANCACHE_ATTR_RO(stored);
+
+static ssize_t skipped_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[SKIPPED]));
+}
+CLEANCACHE_ATTR_RO(skipped);
+
+static ssize_t restored_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[RESTORED]));
+}
+CLEANCACHE_ATTR_RO(restored);
+
+static ssize_t missed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[MISSED]));
+}
+CLEANCACHE_ATTR_RO(missed);
+
+static ssize_t reclaimed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[RECLAIMED]));
+}
+CLEANCACHE_ATTR_RO(reclaimed);
+
+static ssize_t recalled_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[RECALLED]));
+}
+CLEANCACHE_ATTR_RO(recalled);
+
+static ssize_t invalidated_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)atomic64_read(&stats[INVALIDATED]));
+}
+CLEANCACHE_ATTR_RO(invalidated);
+
+static ssize_t cached_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	s64 dropped = atomic64_read(&stats[INVALIDATED]) +
+			atomic64_read(&stats[RECLAIMED]) +
+			atomic64_read(&stats[RECALLED]);
+
+	return sysfs_emit(buf, "%llu\n", (u64)(atomic64_read(&stats[STORED]) - dropped));
+}
+CLEANCACHE_ATTR_RO(cached);
+
+static struct attribute *cleancache_attrs[] = {
+	&stored_attr.attr,
+	&skipped_attr.attr,
+	&restored_attr.attr,
+	&missed_attr.attr,
+	&reclaimed_attr.attr,
+	&recalled_attr.attr,
+	&invalidated_attr.attr,
+	&cached_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(cleancache);
+
+#define CLEANCACHE_POOL_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_pool_attr = {		\
+		.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+		.show	= _name##_pool_show,				\
+}
+
+static ssize_t size_pool_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n",
+		(u64)atomic64_read(&kobj_to_stats(kobj)->stats[POOL_SIZE]));
+}
+CLEANCACHE_POOL_ATTR_RO(size);
+
+static ssize_t cached_pool_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n",
+		(u64)atomic64_read(&kobj_to_stats(kobj)->stats[POOL_CACHED]));
+}
+CLEANCACHE_POOL_ATTR_RO(cached);
+
+static ssize_t recalled_pool_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n",
+		(u64)atomic64_read(&kobj_to_stats(kobj)->stats[POOL_RECALLED]));
+}
+CLEANCACHE_POOL_ATTR_RO(recalled);
+
+
+static struct attribute *cleancache_pool_attrs[] = {
+	&size_pool_attr.attr,
+	&cached_pool_attr.attr,
+	&recalled_pool_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(cleancache_pool);
+
+static void cleancache_pool_release(struct kobject *kobj)
+{
+	kfree(kobj_to_stats(kobj));
+}
+
+static const struct kobj_type cleancache_pool_ktype = {
+	.release = &cleancache_pool_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = cleancache_pool_groups,
+};
+
+struct cleancache_pool_stats *cleancache_create_pool_stats(int pool_id)
+{
+	struct cleancache_pool_stats *pool_stats;
+
+	pool_stats = kzalloc(sizeof(*pool_stats), GFP_KERNEL);
+	if (!pool_stats)
+		return ERR_PTR(-ENOMEM);
+
+	pool_stats->pool_id = pool_id;
+
+	return pool_stats;
+}
+
+struct kobject * __init cleancache_sysfs_create_root(void)
+{
+	struct kobject *kobj;
+	int err;
+
+	kobj = kobject_create_and_add("cleancache", mm_kobj);
+	if (unlikely(!kobj)) {
+		pr_err("Failed to create cleancache kobject\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = sysfs_create_group(kobj, cleancache_groups[0]);
+	if (err) {
+		kobject_put(kobj);
+		pr_err("Failed to create cleancache group kobject\n");
+		return ERR_PTR(err);
+	}
+
+	return kobj;
+}
+
+int cleancache_sysfs_create_pool(struct kobject *root_kobj,
+				 struct cleancache_pool_stats *pool_stats,
+				 const char *name)
+{
+	return kobject_init_and_add(&pool_stats->kobj, &cleancache_pool_ktype,
+				    root_kobj, name);
+}
diff --git a/mm/cleancache_sysfs.h b/mm/cleancache_sysfs.h
new file mode 100644
index 000000000000..fb8d2a72be63
--- /dev/null
+++ b/mm/cleancache_sysfs.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __CLEANCACHE_SYSFS_H__
+#define __CLEANCACHE_SYSFS_H__
+
+enum cleancache_stat {
+	STORED,
+	SKIPPED,
+	RESTORED,
+	MISSED,
+	RECLAIMED,
+	RECALLED,
+	INVALIDATED,
+	CLEANCACHE_STAT_NR
+};
+
+enum cleancache_pool_stat {
+	POOL_SIZE,
+	POOL_CACHED,
+	POOL_RECALLED,
+	CLEANCACHE_POOL_STAT_NR
+};
+
+struct cleancache_pool_stats {
+	struct kobject kobj;
+	int pool_id;
+	atomic64_t stats[CLEANCACHE_POOL_STAT_NR];
+};
+
+#ifdef CONFIG_CLEANCACHE_SYSFS
+void cleancache_stat_inc(enum cleancache_stat type);
+void cleancache_stat_add(enum cleancache_stat type, unsigned long delta);
+void cleancache_pool_stat_inc(struct cleancache_pool_stats *pool_stats,
+			 enum cleancache_pool_stat type);
+void cleancache_pool_stat_dec(struct cleancache_pool_stats *pool_stats,
+			 enum cleancache_pool_stat type);
+void cleancache_pool_stat_add(struct cleancache_pool_stats *pool_stats,
+			 enum cleancache_pool_stat type, long delta);
+struct cleancache_pool_stats *cleancache_create_pool_stats(int pool_id);
+struct kobject * __init cleancache_sysfs_create_root(void);
+int cleancache_sysfs_create_pool(struct kobject *root_kobj,
+				 struct cleancache_pool_stats *pool_stats,
+				 const char *name);
+
+#else /* CONFIG_CLEANCACHE_SYSFS */
+static inline void cleancache_stat_inc(enum cleancache_stat type) {}
+static inline void cleancache_stat_add(enum cleancache_stat type, unsigned long delta) {}
+static inline void cleancache_pool_stat_inc(struct cleancache_pool_stats *pool_stats,
+				       enum cleancache_pool_stat type) {}
+static inline void cleancache_pool_stat_dec(struct cleancache_pool_stats *pool_stats,
+				       enum cleancache_pool_stat type) {}
+static inline void cleancache_pool_stat_add(struct cleancache_pool_stats *pool_stats,
+				       enum cleancache_pool_stat type, long delta) {}
+static inline
+struct cleancache_pool_stats *cleancache_create_pool_stats(int pool_id) { return NULL; }
+
+#endif /* CONFIG_CLEANCACHE_SYSFS */
+
+#endif /* __CLEANCACHE_SYSFS_H__ */
-- 
2.51.1.851.g4ebd6896fd-goog


