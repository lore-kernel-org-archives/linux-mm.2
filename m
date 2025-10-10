Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5EECCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62368E00BB; Thu,  9 Oct 2025 21:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10CB8E0002; Thu,  9 Oct 2025 21:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A2E8E0002; Thu,  9 Oct 2025 21:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4C68E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 626A3B5FE4
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:10 +0000 (UTC)
X-FDA: 83980448580.11.8B31974
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8A1E3140007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PbXDM9DL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3R1_oaAYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3R1_oaAYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEIUd4ZHclhGCkol/EpGDU6dqFXNl4VLKrOL2ZuQAlU=;
	b=tEPI0qlL2GsZ/YYTHvDU3hOyMj4WKDwb4XBnmZOR34NPd9Hgjpdu8SC5+ZIT7SqTBPvrMS
	7soe60DQowVwe8+NNdzI+SAwnCxpl39tNG2yTpXv5daj91tzeRQPuXClFZ3xRnBI7W8HFn
	6ewJqst9LamaLB+PcRB/YlKOtK5WzxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059208; a=rsa-sha256;
	cv=none;
	b=Zol2YEKZEILmbsltGHIZ5MJmam6LSy7OxbeqSn9tc1PzFovkWd8OXrcnef6U+88cTp9bE8
	XrHe7iUi62M9PSM5Qx6xb/u8NsyPsf7eVf0BO2wtlR7Z0KuCmaRj07VHPurI5oKPtlLbOA
	3+X35hHTe8bP6jSZ+u9X6BzKE1EGmQU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PbXDM9DL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3R1_oaAYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3R1_oaAYKCPQoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28bd8b3fa67so23153085ad.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059207; x=1760664007; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pEIUd4ZHclhGCkol/EpGDU6dqFXNl4VLKrOL2ZuQAlU=;
        b=PbXDM9DLIq++0gUJzvUuqEhjlwbYg3HLfqCy18F2CffapCqb16a/9NrQUrXFVMRr5D
         e8UFQRUfibbMnMRVYf5hvmY8z0rexs5lk7kP5rvp6ESVTyHuE26LJ1nItZ2Mfp6xJKfH
         4kYf+TcgXnq5ZketTHLGxtbqrcmE+udqUj4foXCOK/fBu3/5aoBbzqYBNuKa2hGtHpXg
         tn6AqB4tjNMx4DmQuZnkVWGkJeCqsfoYST258agcjG/EhcQ4NNnbXvsX/VBbsVRQp0eQ
         L/YhDT+nCFYx2r6nXkzku9TnQBuaDZPvDX564wm+r8UK8v68v9d+OUDd4rmn5C0c7weu
         4ekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059207; x=1760664007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEIUd4ZHclhGCkol/EpGDU6dqFXNl4VLKrOL2ZuQAlU=;
        b=RiRZDg9lhO8WcvahZsESBfVcL/Ffizr3cR+xpfxqObm2SGz3oeHj2oIe6JObB/dfTB
         UMOIRfwJjHdnM02CP7spZgA93vzd6Jgm3wDArsjr5SGAZyZv/JD4HzmdDVE/ArbM6VlK
         nMajrFJnQ9Ht/MT/iAtEIbCfT2OmEOTYWA9ouuJGWB3ZFdRHlfXUOwVtZ2E7uHL9xK9l
         +nesP01bKsNljl+/epmfS9gE032ov6i4FQJE0a8ytkU8fWh4kaXTOnB+MVvuwnkGPzDl
         6QcVaLVfUmSv76E5xk8tRy3ShWp9H+I0C8woA+e42VRiRbOCLWuJiKxLaNKbR/t0sQyI
         KhBA==
X-Forwarded-Encrypted: i=1; AJvYcCXixK7zZvR/FlyMeYriI7asBgHh3tQyYv86AQ7lh81Fznei/KPRuG9OSoVlQLCKDfHwxpRCcCp5rw==@kvack.org
X-Gm-Message-State: AOJu0Yx3PWszTIbM+5KKrUpITYSi5Qvm573vAkerpVnC6hT+F/kfpvCN
	NAJMF24BCmokIhO7ZgXqPKbqWwdcd+xFJEFz22/12A76xiL6BhcaPsyKSIVmd1lUn3K71O5ckEV
	1Mj+sag==
X-Google-Smtp-Source: AGHT+IHEfcZb//+A/XoFxHeEt6Ogc1LHbtC/aY5NYrm9NviJtA9b0iGFosX3+0YfoF7OGZYkFgLjPVJGLKw=
X-Received: from plps24.prod.google.com ([2002:a17:902:9898:b0:267:de1d:2687])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e943:b0:264:f714:8dce
 with SMTP id d9443c01a7336-290272c2542mr118120205ad.36.1760059207349; Thu, 09
 Oct 2025 18:20:07 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:48 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-6-surenb@google.com>
Subject: [PATCH 5/8] mm/tests: add cleancache kunit test
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
X-Rspamd-Queue-Id: 8A1E3140007
X-Rspamd-Server: rspam02
X-Stat-Signature: bfqnpri367wn1gezzpzo97ear8nmz6ro
X-HE-Tag: 1760059208-11991
X-HE-Meta: U2FsdGVkX1+syLwMIOFz4TMuMKoae98hOX0VQXxJOfOMESfO8jVPKS2+zjYHYCh3+mmCe25FDKUtaeV2coKvZFgts7GIb7MdKcFA0M5gbIy7cno+FgWlXQ6OK7Wo58TKlbelKEMkqMRHR413s7iUSV+/w9dUmx+s8CYXrUjovfDmPkQ0PNurDYM6O5jsVtO4oDmsJ31/VRPi5F4KODdmM8LSIQ3hWQRi4IaLaMRSvLUYzH3+WbZNr7P8rHZ9Fd+FAtydqnoQiDFS8KFRwLRJsPZ/3Mfbbw/BJj/njD+HEmgF5gUmcy/IcLaFsPu/ZCNEYEDqt3dXG4nh9Gc1ecpMF+MPY+QdNaahoUXSYuMFHp/ClAC3Ul5o1hSoBs50Th1Yb/ItVe1noexxkq7O0q2DgT9r7DnA1ak+T50ctkoUcpWLNiI0XnYwgPk+7NGsB32R1Gi7s2FBIDnIzDSHXvBMcgTJ9ZiURNg9O1quhwFgUjMYKL2DAxhTIJ9JrZis5QFgcIVoeU4hFW0iE+l9XZsMDJBAQh80dyZEtzHY8b8DGswP8zvDyZxdIvh0u79NvGp2hmeE+bcw9sqLr6aPpQmneXl7iKY+Fdqhx7QBpRGJP6WRzCPfjExAbZlm8/mDI6mr1BVKewIdniX4x5qGoz7Fwt2nVKpv8fx3BVzkFUdWWDz14k3IOc8M3UaXdXXvyOafMychOiTm3FZP0ocVYgy7IqLy8UiklRIox+l2UvnzeKUi7XqIuYy+UWiKaCmxmpSKnKtd5Fuy6lAIo/70wkvboAUta/KtNUaaYgWNnPfRkWHgb1d+RMmC6YJUVG0iyxICOrCXXWdvsXW9F1b6vCvKhJ04KcdqKNd2kMF8bBH6s4KqI9+9i+8dF8cIR96h4V51OH+QrLHrTfTREk0HNxmvhVxnCJLm1AE+iH6pxjzCKmUlwRVe8sUPLNtMzgBQ4M9EaHdeWwCEvILseP9RJNu
 jWJMFPZq
 DULPYuzyPUpOYKwK5kd0HQ6WGq9I+tpgy1rR9mM8jmueleoA/6lYlfHuwCV8WKpBX7Yl492JHHPukyrgaVp5V0U4bRE4CBnvqJbtZ1L8KA1NHy8P0THycsfoyWMwRcQrl6KE/y6bRwGiYcymzmut9UabLpj8gsoHB5aZKehWWb2Fi/mQqopweIO9cHNTBS4Jq+UMJ/bDp59LpqwmykaTwMulMWHNxkl4o/3whWRbz4gIJbYuBQw9/bbNqLZNdJ9vlEO0SZ+nFrhgJoNEPeb2f6I2mgjgttkBgeuTCN2KxqHJyJSmgWG/xV9n3ERGzB2t8fsV10XzxrgQgfKAbW1UGLt7pco3l2sMyyk7CK/1tyyqC33ksfV8ehrAT8Qvma2kDe+YcsflojnM11IyAZAy1jDBiv1el5FWOWSQ5hyoRPMnCNi8JaP5YSEqodiloQ79GILHY0OLV0sx2XeF8uRK6ict5B19SfZ9CFtegS9o0t04q2EWi1l6ZduIHX6MzovCY1wPcPwg3k8Url5fYZH0aokWqn31/r86DqDiSJE2Ir8i2UHcrqHR3WXMlp/OLOekY56Nu8lVvGuKjaUFtZfp3gwksVQVmi50/R35f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kunit test that creates fake inodes, fills them with folios
with predefined content, registers a cleancache pool, allocates and
donates folios to the new pool. After this initialization it runs
several scenarios:
1. cleancache_restore_test - stores fake inode pages into cleancache,
then restores them into auxiliary folios and checks restored content;
2. cleancache_invalidate_test - stores a folio, successfully restores
it, invalidates it and tries to restore again expecting a failure;
3. cleancache_reclaim_test - fills up the cleancache, stores one
more folio and verifies that the oldest folio got reclaimed;
4. cleancache_backend_api_test - takes all donated folios and puts them
back verifying the results;

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 MAINTAINERS                 |   1 +
 mm/Kconfig.debug            |  13 ++
 mm/Makefile                 |   1 +
 mm/cleancache.c             |  35 ++-
 mm/tests/Makefile           |   6 +
 mm/tests/cleancache_kunit.c | 425 ++++++++++++++++++++++++++++++++++++
 6 files changed, 480 insertions(+), 1 deletion(-)
 create mode 100644 mm/tests/Makefile
 create mode 100644 mm/tests/cleancache_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f66307cd9c4b..1c97227e7ffa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6057,6 +6057,7 @@ F:	include/linux/cleancache.h
 F:	mm/cleancache.c
 F:	mm/cleancache_sysfs.c
 F:	mm/cleancache_sysfs.h
+F:	mm/tests/cleancache_kunit.c
 
 CLK API
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..c3482f7bc977 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,16 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config CLEANCACHE_KUNIT
+	tristate "KUnit test for cleancache" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on CLEANCACHE
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the cleancache unit test.
+	  Tests the clencache functionality.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index a7a635f762ee..845841a140e3 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -70,6 +70,7 @@ obj-y += init-mm.o
 obj-y += memblock.o
 obj-y += $(memory-hotplug-y)
 obj-y += slub.o
+obj-y += tests/
 
 ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 56dce7e03709..fd18486b0407 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -11,6 +11,8 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
+#include <kunit/test-bug.h>
+#include <kunit/test.h>
 
 #include "cleancache_sysfs.h"
 
@@ -74,6 +76,28 @@ static DEFINE_SPINLOCK(pools_lock); /* protects pools */
 static LIST_HEAD(cleancache_lru);
 static DEFINE_SPINLOCK(lru_lock); /* protects cleancache_lru */
 
+#if IS_ENABLED(CONFIG_CLEANCACHE_KUNIT)
+
+static bool is_pool_allowed(int pool_id)
+{
+	struct kunit *test = kunit_get_current_test();
+
+	/* Restrict kunit tests to using only the test pool */
+	return test && *((int *)test->priv) == pool_id;
+}
+
+#else /* CONFIG_CLEANCACHE_KUNIT */
+
+static bool is_pool_allowed(int pool_id) { return true; }
+
+#endif /* CONFIG_CLEANCACHE_KUNIT */
+
+#if IS_MODULE(CONFIG_CLEANCACHE_KUNIT)
+#define EXPORT_SYMBOL_FOR_KUNIT(x) EXPORT_SYMBOL(x)
+#else
+#define EXPORT_SYMBOL_FOR_KUNIT(x)
+#endif
+
 /*
  * Folio attributes:
  *	folio->_mapcount - pool_id
@@ -184,7 +208,7 @@ static struct folio *pick_folio_from_any_pool(void)
 	for (int i = 0; i < count; i++) {
 		pool = &pools[i];
 		spin_lock(&pool->lock);
-		if (!list_empty(&pool->folio_list)) {
+		if (!list_empty(&pool->folio_list) && is_pool_allowed(i)) {
 			folio = list_last_entry(&pool->folio_list,
 						struct folio, lru);
 			WARN_ON(!remove_folio_from_pool(folio, pool));
@@ -747,6 +771,7 @@ void cleancache_add_fs(struct super_block *sb)
 err:
 	sb->cleancache_id = CLEANCACHE_ID_INVALID;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_add_fs);
 
 void cleancache_remove_fs(struct super_block *sb)
 {
@@ -766,6 +791,7 @@ void cleancache_remove_fs(struct super_block *sb)
 	/* free the object */
 	put_fs(fs);
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_remove_fs);
 
 bool cleancache_store_folio(struct inode *inode, struct folio *folio)
 {
@@ -795,6 +821,7 @@ bool cleancache_store_folio(struct inode *inode, struct folio *folio)
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_store_folio);
 
 bool cleancache_restore_folio(struct inode *inode, struct folio *folio)
 {
@@ -822,6 +849,7 @@ bool cleancache_restore_folio(struct inode *inode, struct folio *folio)
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_restore_folio);
 
 bool cleancache_invalidate_folio(struct address_space *mapping,
 				 struct inode *inode, struct folio *folio)
@@ -853,6 +881,7 @@ bool cleancache_invalidate_folio(struct address_space *mapping,
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_invalidate_folio);
 
 bool cleancache_invalidate_inode(struct address_space *mapping,
 				 struct inode *inode)
@@ -877,6 +906,7 @@ bool cleancache_invalidate_inode(struct address_space *mapping,
 
 	return count > 0;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_invalidate_inode);
 
 struct cleancache_inode *
 cleancache_start_inode_walk(struct address_space *mapping, struct inode *inode,
@@ -906,6 +936,7 @@ cleancache_start_inode_walk(struct address_space *mapping, struct inode *inode,
 
 	return ccinode;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_start_inode_walk);
 
 void cleancache_end_inode_walk(struct cleancache_inode *ccinode)
 {
@@ -914,6 +945,7 @@ void cleancache_end_inode_walk(struct cleancache_inode *ccinode)
 	put_inode(ccinode);
 	put_fs(fs);
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_end_inode_walk);
 
 bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
 				   struct folio *folio)
@@ -940,6 +972,7 @@ bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_KUNIT(cleancache_restore_from_inode);
 
 /* Backend API */
 /*
diff --git a/mm/tests/Makefile b/mm/tests/Makefile
new file mode 100644
index 000000000000..fac2e964b4d5
--- /dev/null
+++ b/mm/tests/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for tests of kernel mm subsystem.
+
+# KUnit tests
+obj-$(CONFIG_CLEANCACHE_KUNIT) += cleancache_kunit.o
diff --git a/mm/tests/cleancache_kunit.c b/mm/tests/cleancache_kunit.c
new file mode 100644
index 000000000000..18b4386d6322
--- /dev/null
+++ b/mm/tests/cleancache_kunit.c
@@ -0,0 +1,425 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit test for the Cleancache.
+ *
+ * Copyright (C) 2025, Google LLC.
+ * Author: Suren Baghdasaryan <surenb@google.com>
+ */
+#include <kunit/test.h>
+
+#include <linux/cleancache.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+
+#include "../internal.h"
+
+#define INODE_COUNT		5
+#define FOLIOS_PER_INODE	4
+#define FOLIO_COUNT		(INODE_COUNT * FOLIOS_PER_INODE)
+
+static const u32 TEST_CONTENT = 0xBADCAB32;
+
+struct inode_data {
+	struct address_space mapping;
+	struct inode inode;
+	struct folio *folios[FOLIOS_PER_INODE];
+};
+
+static struct test_data {
+	/* Mock a fs */
+	struct super_block sb;
+	struct inode_data inodes[INODE_COUNT];
+	/* Folios donated to the cleancache pools */
+	struct folio *pool_folios[FOLIO_COUNT];
+	/* Auxiliary folio */
+	struct folio *aux_folio;
+	int pool_id;
+} test_data;
+
+static void set_folio_content(struct folio *folio, u32 value)
+{
+	u32 *data;
+
+	data = kmap_local_folio(folio, 0);
+	*data = value;
+	kunmap_local(data);
+}
+
+static u32 get_folio_content(struct folio *folio)
+{
+	unsigned long value;
+	u32 *data;
+
+	data = kmap_local_folio(folio, 0);
+	value = *data;
+	kunmap_local(data);
+
+	return value;
+}
+
+static void fill_cleancache(struct kunit *test)
+{
+	struct inode_data *inode_data;
+	struct folio *folio;
+
+	/* Store inode folios into cleancache */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		inode_data = &test_data.inodes[inode];
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			folio = inode_data->folios[fidx];
+			KUNIT_EXPECT_NOT_NULL(test, folio);
+			folio_lock(folio); /* Folio has to be locked */
+			folio_set_workingset(folio);
+			KUNIT_EXPECT_TRUE(test, cleancache_store_folio(&inode_data->inode, folio));
+			folio_unlock(folio);
+		}
+	}
+}
+
+static int cleancache_suite_init(struct kunit_suite *suite)
+{
+	LIST_HEAD(pool_folios);
+
+	/* Add a fake fs superblock */
+	cleancache_add_fs(&test_data.sb);
+
+	/* Initialize fake inodes */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		struct inode_data *inode_data = &test_data.inodes[inode];
+
+		inode_data->inode.i_sb = &test_data.sb;
+		inode_data->inode.i_ino = inode;
+		inode_data->mapping.host = &inode_data->inode;
+
+		/* Allocate folios for the inode  */
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			struct folio *folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+			if (!folio)
+				return -ENOMEM;
+
+			set_folio_content(folio, (u32)fidx);
+			folio->mapping = &inode_data->mapping;
+			folio->index = PAGE_SIZE * fidx;
+			inode_data->folios[fidx] = folio;
+		}
+	}
+
+	/* Register new cleancache pool and donate test folios */
+	test_data.pool_id = cleancache_backend_register_pool("kunit_pool");
+	if (test_data.pool_id < 0)
+		return -EINVAL;
+
+	/* Allocate folios and put them to cleancache  */
+	for (int fidx = 0; fidx < FOLIO_COUNT; fidx++) {
+		struct folio *folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+		if (!folio)
+			return -ENOMEM;
+
+		folio_ref_freeze(folio, 1);
+		test_data.pool_folios[fidx] = folio;
+		list_add(&folio->lru, &pool_folios);
+	}
+
+	cleancache_backend_put_folios(test_data.pool_id, &pool_folios);
+
+	/* Allocate auxiliary folio for testing  */
+	test_data.aux_folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!test_data.aux_folio)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void cleancache_suite_exit(struct kunit_suite *suite)
+{
+	/* Take back donated folios and free them */
+	for (int fidx = 0; fidx < FOLIO_COUNT; fidx++) {
+		struct folio *folio = test_data.pool_folios[fidx];
+
+		if (folio) {
+			if (!cleancache_backend_get_folio(test_data.pool_id,
+							  folio))
+				set_page_refcounted(&folio->page);
+			folio_put(folio);
+		}
+	}
+
+	/* Free the auxiliary folio */
+	if (test_data.aux_folio) {
+		test_data.aux_folio->mapping = NULL;
+		folio_put(test_data.aux_folio);
+	}
+
+	/* Free inode folios */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			struct folio *folio = test_data.inodes[inode].folios[fidx];
+
+			if (folio) {
+				folio->mapping = NULL;
+				folio_put(folio);
+			}
+		}
+	}
+
+	cleancache_remove_fs(&test_data.sb);
+}
+
+static int cleancache_test_init(struct kunit *test)
+{
+	/* Pass pool_id to cleancache to restrict pools that can be used for tests */
+	test->priv = &test_data.pool_id;
+
+	return 0;
+}
+
+static void cleancache_restore_test(struct kunit *test)
+{
+	struct inode_data *inode_data;
+	struct folio *folio;
+
+	/* Store inode folios into cleancache */
+	fill_cleancache(test);
+
+	/* Restore and validate folios stored in cleancache */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		inode_data = &test_data.inodes[inode];
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			folio = inode_data->folios[fidx];
+			test_data.aux_folio->mapping = folio->mapping;
+			test_data.aux_folio->index = folio->index;
+			KUNIT_EXPECT_TRUE(test, cleancache_restore_folio(&inode_data->inode,
+									 test_data.aux_folio));
+			KUNIT_EXPECT_EQ(test, get_folio_content(test_data.aux_folio),
+					get_folio_content(folio));
+		}
+	}
+}
+
+static void cleancache_walk_and_restore_test(struct kunit *test)
+{
+	struct cleancache_inode *ccinode;
+	struct inode_data *inode_data;
+	struct folio *folio;
+
+	/* Store inode folios into cleancache */
+	fill_cleancache(test);
+
+	/* Restore and validate folios stored in the first inode */
+	inode_data = &test_data.inodes[0];
+	ccinode = cleancache_start_inode_walk(&inode_data->mapping, &inode_data->inode,
+					      FOLIOS_PER_INODE);
+	KUNIT_EXPECT_NOT_NULL(test, ccinode);
+	for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+		folio = inode_data->folios[fidx];
+		test_data.aux_folio->mapping = folio->mapping;
+		test_data.aux_folio->index = folio->index;
+		KUNIT_EXPECT_TRUE(test, cleancache_restore_from_inode(ccinode,
+								      test_data.aux_folio));
+		KUNIT_EXPECT_EQ(test, get_folio_content(test_data.aux_folio),
+				get_folio_content(folio));
+	}
+	cleancache_end_inode_walk(ccinode);
+}
+
+static void cleancache_invalidate_test(struct kunit *test)
+{
+	struct inode_data *inode_data;
+	struct folio *folio;
+
+	/* Store inode folios into cleancache */
+	fill_cleancache(test);
+
+	/* Invalidate one folio */
+	inode_data = &test_data.inodes[0];
+	folio = inode_data->folios[0];
+	test_data.aux_folio->mapping = folio->mapping;
+	test_data.aux_folio->index = folio->index;
+	KUNIT_EXPECT_TRUE(test, cleancache_restore_folio(&inode_data->inode,
+							 test_data.aux_folio));
+	folio_lock(folio); /* Folio has to be locked */
+	KUNIT_EXPECT_TRUE(test, cleancache_invalidate_folio(&inode_data->mapping,
+							    &inode_data->inode,
+							    inode_data->folios[0]));
+	folio_unlock(folio);
+	KUNIT_EXPECT_FALSE(test, cleancache_restore_folio(&inode_data->inode,
+							  test_data.aux_folio));
+
+	/* Invalidate one node */
+	inode_data = &test_data.inodes[1];
+	KUNIT_EXPECT_TRUE(test, cleancache_invalidate_inode(&inode_data->mapping,
+							    &inode_data->inode));
+
+	/* Verify results */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		inode_data = &test_data.inodes[inode];
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			folio = inode_data->folios[fidx];
+			test_data.aux_folio->mapping = folio->mapping;
+			test_data.aux_folio->index = folio->index;
+			if (inode == 0 && fidx == 0) {
+				/* Folio should be missing */
+				KUNIT_EXPECT_FALSE(test,
+					cleancache_restore_folio(&inode_data->inode,
+								 test_data.aux_folio));
+				continue;
+			}
+			if (inode == 1) {
+				/* Folios in the node should be missing */
+				KUNIT_EXPECT_FALSE(test,
+					cleancache_restore_folio(&inode_data->inode,
+								 test_data.aux_folio));
+				continue;
+			}
+			KUNIT_EXPECT_TRUE(test,
+					cleancache_restore_folio(&inode_data->inode,
+								 test_data.aux_folio));
+			KUNIT_EXPECT_EQ(test, get_folio_content(test_data.aux_folio),
+					get_folio_content(folio));
+		}
+	}
+}
+
+static void cleancache_reclaim_test(struct kunit *test)
+{
+	struct inode_data *inode_data;
+	struct inode_data *inode_new;
+	unsigned long new_index;
+	struct folio *folio;
+
+	/* Store inode folios into cleancache */
+	fill_cleancache(test);
+
+	/*
+	 * Store one extra new folio. There should be no free folios, so the
+	 * oldest folio will be reclaimed to store new folio. Add it into the
+	 * last node at the next unoccupied offset.
+	 */
+	inode_new = &test_data.inodes[INODE_COUNT - 1];
+	new_index = inode_new->folios[FOLIOS_PER_INODE - 1]->index + PAGE_SIZE;
+
+	test_data.aux_folio->mapping = &inode_new->mapping;
+	test_data.aux_folio->index = new_index;
+	set_folio_content(test_data.aux_folio, TEST_CONTENT);
+	folio_lock(test_data.aux_folio); /* Folio has to be locked */
+	folio_set_workingset(test_data.aux_folio);
+	KUNIT_EXPECT_TRUE(test, cleancache_store_folio(&inode_new->inode, test_data.aux_folio));
+	folio_unlock(test_data.aux_folio);
+
+	/* Verify results */
+	for (int inode = 0; inode < INODE_COUNT; inode++) {
+		inode_data = &test_data.inodes[inode];
+		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+			folio = inode_data->folios[fidx];
+			test_data.aux_folio->mapping = folio->mapping;
+			test_data.aux_folio->index = folio->index;
+			/*
+			 * The first folio of the first node was added first,
+			 * so it's the oldest and must have been reclaimed.
+			 */
+			if (inode == 0 && fidx == 0) {
+				/* Reclaimed folio should be missing */
+				KUNIT_EXPECT_FALSE_MSG(test,
+						cleancache_restore_folio(&inode_data->inode,
+									 test_data.aux_folio),
+						"inode %d, folio %d is invalid\n", inode, fidx);
+				continue;
+			}
+			KUNIT_EXPECT_TRUE_MSG(test,
+					cleancache_restore_folio(&inode_data->inode,
+								 test_data.aux_folio),
+								"inode %d, folio %d is invalid\n",
+								inode, fidx);
+			KUNIT_EXPECT_EQ_MSG(test, get_folio_content(test_data.aux_folio),
+					    get_folio_content(folio),
+					    "inode %d, folio %d content is invalid\n",
+					    inode, fidx);
+		}
+	}
+
+	/* Auxiliary folio should be stored */
+	test_data.aux_folio->mapping = &inode_new->mapping;
+	test_data.aux_folio->index = new_index;
+	KUNIT_EXPECT_TRUE_MSG(test,
+			      cleancache_restore_folio(&inode_new->inode, test_data.aux_folio),
+			      "inode %lu, folio %ld is invalid\n",
+			      inode_new->inode.i_ino, new_index);
+	KUNIT_EXPECT_EQ_MSG(test, get_folio_content(test_data.aux_folio), TEST_CONTENT,
+			    "inode %lu, folio %ld content is invalid\n",
+			    inode_new->inode.i_ino, new_index);
+}
+
+static void cleancache_backend_api_test(struct kunit *test)
+{
+	struct folio *folio;
+	LIST_HEAD(folios);
+	int unused = 0;
+	int used = 0;
+
+	/* Store inode folios into cleancache */
+	fill_cleancache(test);
+
+	/* Get all donated folios back */
+	for (int fidx = 0; fidx < FOLIO_COUNT; fidx++) {
+		KUNIT_EXPECT_EQ(test, cleancache_backend_get_folio(test_data.pool_id,
+						test_data.pool_folios[fidx]),  0);
+		set_page_refcounted(&test_data.pool_folios[fidx]->page);
+	}
+
+	/* Try putting a refcounted folio */
+	KUNIT_EXPECT_NE(test, cleancache_backend_put_folio(test_data.pool_id,
+					test_data.pool_folios[0]), 0);
+
+	/* Put some of the folios back into cleancache */
+	for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
+		folio_ref_freeze(test_data.pool_folios[fidx], 1);
+		KUNIT_EXPECT_EQ(test, cleancache_backend_put_folio(test_data.pool_id,
+						test_data.pool_folios[fidx]), 0);
+	}
+
+	/* Put the rest back into cleancache but keep half of folios still refcounted */
+	for (int fidx = FOLIOS_PER_INODE; fidx < FOLIO_COUNT; fidx++) {
+		if (fidx % 2) {
+			folio_ref_freeze(test_data.pool_folios[fidx], 1);
+			unused++;
+		} else {
+			used++;
+		}
+		list_add(&test_data.pool_folios[fidx]->lru, &folios);
+	}
+	KUNIT_EXPECT_NE(test, cleancache_backend_put_folios(test_data.pool_id,
+					&folios), 0);
+	/* Used folios should be still in the list */
+	KUNIT_EXPECT_EQ(test, list_count_nodes(&folios), used);
+
+	/* Release refcounts and put the remaining folios into cleancache */
+	list_for_each_entry(folio, &folios, lru)
+		folio_ref_freeze(folio, 1);
+	KUNIT_EXPECT_EQ(test, cleancache_backend_put_folios(test_data.pool_id,
+					&folios), 0);
+	KUNIT_EXPECT_TRUE(test, list_empty(&folios));
+}
+
+static struct kunit_case cleancache_test_cases[] = {
+	KUNIT_CASE(cleancache_restore_test),
+	KUNIT_CASE(cleancache_walk_and_restore_test),
+	KUNIT_CASE(cleancache_invalidate_test),
+	KUNIT_CASE(cleancache_reclaim_test),
+	KUNIT_CASE(cleancache_backend_api_test),
+	{},
+};
+
+static struct kunit_suite hashtable_test_module = {
+	.name = "cleancache",
+	.init = cleancache_test_init,
+	.suite_init = cleancache_suite_init,
+	.suite_exit = cleancache_suite_exit,
+	.test_cases = cleancache_test_cases,
+};
+
+kunit_test_suites(&hashtable_test_module);
+
+MODULE_DESCRIPTION("KUnit test for the Kernel Cleancache");
+MODULE_LICENSE("GPL");
-- 
2.51.0.740.g6adb054d12-goog


