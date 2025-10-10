Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D49CCD18C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77718E00BA; Thu,  9 Oct 2025 21:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28098E0002; Thu,  9 Oct 2025 21:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8C78E00BA; Thu,  9 Oct 2025 21:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2678E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5785E116C52
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:08 +0000 (UTC)
X-FDA: 83980448496.16.3F82A62
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 829E518000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LAchgKOa;
	spf=pass (imf06.hostedemail.com: domain of 3RV_oaAYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3RV_oaAYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcN6OGexdDN4REs0WUDwtbwKs1bNtyrXTB87BI/xDL8=;
	b=1Fjy7s1Sx017mRJ6cUfiL5pkzbUoWQ7dLjdeHFRJxr5m3eLrcvz/yaq4yaQkzWqS4E4vRj
	npI46SY/CVecpDsoH3zHAllL3n9TJkGiXpzv3F4In3U8xp9raWliink34BjgRvE23Tv+9T
	NE/76gJzS9GJ8SlZSe42Gsxb+GFkivs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059206; a=rsa-sha256;
	cv=none;
	b=aWRzgbeapPssKLWmjLkrCaXICU2q8ns+xqIakgpr9vXZJBpy0a5kj9eV4omE7RP+MH1lh7
	ABFeBxArgMdjsIva/997pbOn71HizdIvBJZMR+XiagH+CZMAr6qzwlGl8zAxUEXLPcKtyk
	GIvcIC/rI/4ihuAhJBLzVSSbWcG1tC4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LAchgKOa;
	spf=pass (imf06.hostedemail.com: domain of 3RV_oaAYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3RV_oaAYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7811e063dceso2296937b3a.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059205; x=1760664005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tcN6OGexdDN4REs0WUDwtbwKs1bNtyrXTB87BI/xDL8=;
        b=LAchgKOaXkabhQcQdwXuQV9B5LC87sIxsnAFEcc681RNhFkjXCtIcTSEkVjlKvIbJt
         TPgnyTIQs+UDhB9HMRxfuG6bNWIcTu0BIViTyX3KjZgPWl5mDrOWCIYges00VLCzMRxp
         8BH+l8juC7dDUne2+MJURxXnV77/aB9dfEj/ejgt/bX2ktnaR03nxhObBWvBnOuwpUNo
         8LhCnUlCYxoi92T4/BCdO+vSPhKHHADGi5qawEd7zPC2xkjCopcz+gnKwsGQVPXYFIn/
         0hOOZ+l0+/vF+BOIkn78axxgjRWNuTXNTxZHqU0Uh81tbD2HEoCWUer3AnF5ZMQ0PjxK
         mqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059205; x=1760664005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tcN6OGexdDN4REs0WUDwtbwKs1bNtyrXTB87BI/xDL8=;
        b=jE8ju4bBSpjjljLy2sZnzwTC36P7+R+eKinZLnYHdg5JXE8mzbPrXY+hBTPd7asMA7
         JQsP+Mib+lD27hfteEZk9J6m+H/5GWqgJ94s/MMKvwVGQQjTJprjWaEouw7356ZDM639
         R3Y9o/TWTryDnhIS+JXS2GpUx3QpfqdGPxnG9DETlBwlVPYsoi6wbuC9HDzTXXW5S2j0
         6pfH0e+mluqe+e+GMAI3OEGAqbP9h+j+pGuY7fE+YAyVGhkQiF9UqyNRv5EB1olPaIxN
         f4ZYNcmK9aSg3all2UaoZjwlnL+ZsoXKxbhEZTKOMnVsch4cG2M3CjDiL5R9xAgc9J/E
         H1YA==
X-Forwarded-Encrypted: i=1; AJvYcCULoUOt6nL/rqkQom9SHPaBZuRDAxBIm69osqXRyqhaX65saMy23d0KRkwQiAgOgkFUyUMlvvA44Q==@kvack.org
X-Gm-Message-State: AOJu0Yz9Doj3gn4ZpiTIbCqw6nMMvPIZVurjBdkfi0HWcggRTf5n038/
	abaNE++ZsGRkxUJR9SJCJ4/q4rcGPIQzdK/nEPJ+hsldcwxpSDwvo8xgGkaxR8nq1ywik8WgaQA
	nZ4WE5w==
X-Google-Smtp-Source: AGHT+IGWo2umirCkNnF3dRSzHnJXKgnnR9cLHUFGdmby3Duxq7TZVj0L2Xz38+ViMs5EtsI8nLTHCdiBjWM=
X-Received: from pgar12.prod.google.com ([2002:a05:6a02:2e8c:b0:b63:7a61:419c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748b:b0:32b:6e08:fa19
 with SMTP id adf61e73a8af0-32da81345fdmr12546348637.1.1760059205122; Thu, 09
 Oct 2025 18:20:05 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:47 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-5-surenb@google.com>
Subject: [PATCH 4/8] mm/cleancache: add sysfs interface
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
X-Rspamd-Server: rspam05
X-Stat-Signature: ycth9ebuz4wnbk3hjyt6kzuz8uzumj64
X-Rspam-User: 
X-Rspamd-Queue-Id: 829E518000C
X-HE-Tag: 1760059206-713911
X-HE-Meta: U2FsdGVkX1+EUV/I9Ms5TzxtlgPfT9FVrbpHlNMvCbXeIR9dN/jKu3Jmke48HCIgL/WkDwzXQCxUrcqViZtIOG8PHguCCk4zL3D8P+xHtI85XQr+FEC92qSI9NgZ1hMP3I19Gy1VvDhrZ071YO+R3amvDwEmQWuognWFwGTV/7VoOnbp79l3WpJWVWKGsnmYDFZ1yv3RtZW5bDEurOSA3DlOQvkRUb7Cm82eN9H6RELZh3CIqvl99WEyJsBsq+MLIAHbHjIns/j3RyTd5lyvnm4+8ba1DvnBkBRv/nxxiBKWAmcYqpA5R1R8af2nYQW1KG35KnQQ3CC5L7MK9vmqoIiFpinLWF8uNqYhhVx+L7VrVtlyyia/9UPdRfKxUTMqTQx6AyTkHxD7L+v4Iras8mBPytE3ud4yCeU4JV+dMNrAFyj+3TBYub8QjBvpassydYAhmGAVAm7UB/u2XiXpVgyOQX6HEbLCSjCftlX+v9K/WOG4Flg2cM23vhkKb3Q8rHy4xICB8xd8WxSm78Z0H0aGGU5aOhOFktDmITlMdNJoTpcBEjEHfCqznImvkkLjxpWJzrQUha1PnRY4/Cv17kXAnTXEMA46Q+HeowsTi9SsP8qcfMOC67OJBxBwa0/cv3u0GOEkRvA81kRLmfNXCN3CA0zvorA06fbiAqMQVY9Y22NJsMraGvCtKECB5a/aUodYF1t6Upt93aT5tdIal+YCCVuH4sNhNPEMWJwtwabM5almBj3LTU/gpwTQRNC5vuE/UqZzxoKtjGLAWUzdxvk1Vl7Yr2NF0Q0L2IXDDG0nDHkQPE2cddxULBYCRTlWsFbJR5UujwOEKN1sQV6b5ikNl+Y9D0eq5S2MVWs2w70JiI1/Osv6cVvbhXZX/sSSpC/0TI1zAgi7XrYwiuifkVzrB/NBhjP4WW5sBXVOpSzK8MWWqag37ORyA/RpXPFM7RylyD+W3UfBbCIN0H0
 sUKNqxDl
 KQfxPp96b8Bat589Y+2kjLxzldGMSWjAPpGJSd98sXzF/HKes+xEtp8M4QWaZra4zVQjK8Q+0EvKmizWgrvo8RR9RNgxyIuPoizD4j66w4Ij7Z/Guep1JZnfvUyKf9z5uPdMVxTUnSRHojquLQXmggIKjAFjyfg3jWLHEqcvJdEMXS9HZswC7p8qm9U2aKEksRQ7ZASWUzb3QluVcYTlWi5O4Jrxfl6xyNuC+RImp68KjMoVNJzMzZuCtzJauYpp5KTMWxlq9GuL7fmtx+f36GIvIobtBITuauYaZjaiFkNATCN+++MOgNMGYDD1qI/WujMpY4G0A9SdMS/z6lBHCEHFeUf2Ij0NrIRhOZTku1yuxYF/884ZYprS6HPMFtoML6hY9l6h6OdgEcCYWsqIbPiVvaV/U9sxmxCRtZsnekLdtt+ovPfwpzjJn1HO/moRFz3Kl20h7FJQzd3HQ9xnGaN8pzawuxUSP4W+ci1Q42obA3jHu4wNGkH3UdTPGZ69u8WGFjIJgbwrBEgVAbf8TPJmcR9SSnukc3pNFZ6+ZsO4exaMMN1b5nQnXpCuF3x3OjRn0Emf8gWSGjoAQzfWysuYqLIr8r7lKUVWQgu+57ZT3SCiU3OAboshXdA==
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
index de7a89cd44a0..f66307cd9c4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6055,6 +6055,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/cleancache.h
 F:	mm/cleancache.c
+F:	mm/cleancache_sysfs.c
+F:	mm/cleancache_sysfs.h
 
 CLK API
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/mm/Kconfig b/mm/Kconfig
index 7e2482c522a0..9f4da8a848f4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -965,6 +965,14 @@ config CLEANCACHE
 
 	  If unsure, say N.
 
+config CLEANCACHE_SYSFS
+	bool "Cleancache information through sysfs interface"
+	depends on CLEANCACHE && SYSFS
+	help
+	  This option exposes sysfs attributes to get information from
+	  cleancache. The user space can use the interface for query cleancache
+	  and individual cleancache pool metrics.
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
index 59b8fd309619..56dce7e03709 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -12,6 +12,8 @@
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
 
+#include "cleancache_sysfs.h"
+
 /*
  * Lock nesting:
  *	ccinode->folios.xa_lock
@@ -57,6 +59,8 @@ struct cleancache_inode {
 struct cleancache_pool {
 	struct list_head folio_list;
 	spinlock_t lock; /* protects folio_list */
+	char *name;
+	struct cleancache_pool_stats *stats;
 };
 
 #define CLEANCACHE_MAX_POOLS	64
@@ -110,6 +114,7 @@ static void attach_folio(struct folio *folio, struct cleancache_inode *ccinode,
 
 	folio->mapping = (struct address_space *)ccinode;
 	folio->index = offset;
+	cleancache_pool_stat_inc(folio_pool(folio)->stats, POOL_CACHED);
 }
 
 static void detach_folio(struct folio *folio)
@@ -118,6 +123,7 @@ static void detach_folio(struct folio *folio)
 
 	folio->mapping = NULL;
 	folio->index = 0;
+	cleancache_pool_stat_dec(folio_pool(folio)->stats, POOL_CACHED);
 }
 
 static void folio_attachment(struct folio *folio, struct cleancache_inode **ccinode,
@@ -525,7 +531,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 	ccinode = find_and_get_inode(fs, inode);
 	if (!ccinode) {
 		if (!workingset)
-			return false;
+			goto out;
 
 		ccinode = add_and_get_inode(fs, inode);
 		if (IS_ERR_OR_NULL(ccinode)) {
@@ -545,6 +551,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 	if (stored_folio) {
 		if (!workingset) {
 			move_folio_from_inode_to_pool(ccinode, offset, stored_folio);
+			cleancache_stat_inc(RECLAIMED);
 			goto out_unlock;
 		}
 		rotate_lru_folio(stored_folio);
@@ -560,6 +567,8 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			xa_lock(&ccinode->folios);
 			if (!stored_folio)
 				goto out_unlock;
+
+			cleancache_stat_inc(RECLAIMED);
 		}
 
 		if (!store_folio_in_inode(ccinode, offset, stored_folio)) {
@@ -571,6 +580,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			spin_unlock(&pool->lock);
 			goto out_unlock;
 		}
+		cleancache_stat_inc(STORED);
 		add_folio_to_lru(stored_folio);
 	}
 	copy_folio_content(folio, stored_folio);
@@ -582,6 +592,8 @@ static bool store_into_inode(struct cleancache_fs *fs,
 		remove_inode_if_empty(ccinode);
 	xa_unlock(&ccinode->folios);
 	put_inode(ccinode);
+out:
+	cleancache_stat_inc(SKIPPED);
 
 	return ret;
 }
@@ -592,23 +604,26 @@ static bool load_from_inode(struct cleancache_fs *fs,
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
@@ -623,8 +638,10 @@ static bool invalidate_folio(struct cleancache_fs *fs,
 
 	xa_lock(&ccinode->folios);
 	folio = xa_load(&ccinode->folios, offset);
-	if (folio)
+	if (folio) {
 		move_folio_from_inode_to_pool(ccinode, offset, folio);
+		cleancache_stat_inc(INVALIDATED);
+	}
 	xa_unlock(&ccinode->folios);
 	put_inode(ccinode);
 
@@ -645,6 +662,7 @@ static unsigned int invalidate_inode(struct cleancache_fs *fs,
 		ret = erase_folios_from_inode(ccinode, &xas);
 		xas_unlock(&xas);
 		put_inode(ccinode);
+		cleancache_stat_add(INVALIDATED, ret);
 
 		return ret;
 	}
@@ -652,6 +670,53 @@ static unsigned int invalidate_inode(struct cleancache_fs *fs,
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
 void cleancache_add_fs(struct super_block *sb)
 {
@@ -835,6 +900,7 @@ cleancache_start_inode_walk(struct address_space *mapping, struct inode *inode,
 	ccinode = find_and_get_inode(fs, inode);
 	if (!ccinode) {
 		put_fs(fs);
+		cleancache_stat_add(MISSED, count);
 		return NULL;
 	}
 
@@ -865,7 +931,10 @@ bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
 		memcpy(dst, src, PAGE_SIZE);
 		kunmap_local(dst);
 		kunmap_local(src);
+		cleancache_stat_inc(RESTORED);
 		ret = true;
+	} else {
+		cleancache_stat_inc(MISSED);
 	}
 	xa_unlock(&ccinode->folios);
 
@@ -879,9 +948,18 @@ bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
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
@@ -893,12 +971,22 @@ int cleancache_backend_register_pool(const char *name)
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
@@ -947,10 +1035,13 @@ int cleancache_backend_get_folio(int pool_id, struct folio *folio)
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
@@ -972,6 +1063,7 @@ int cleancache_backend_put_folio(int pool_id, struct folio *folio)
 	INIT_LIST_HEAD(&folio->lru);
 	spin_lock(&pool->lock);
 	add_folio_to_pool(folio, pool);
+	cleancache_pool_stat_inc(pool->stats, POOL_SIZE);
 	spin_unlock(&pool->lock);
 
 	return 0;
@@ -984,6 +1076,7 @@ int cleancache_backend_put_folios(int pool_id, struct list_head *folios)
 	LIST_HEAD(unused_folios);
 	struct folio *folio;
 	struct folio *tmp;
+	int count = 0;
 
 	list_for_each_entry_safe(folio, tmp, folios, lru) {
 		/* Do not support large folios yet */
@@ -993,10 +1086,12 @@ int cleancache_backend_put_folios(int pool_id, struct list_head *folios)
 
 		init_cleancache_folio(folio, pool_id);
 		list_move(&folio->lru, &unused_folios);
+		count++;
 	}
 
 	spin_lock(&pool->lock);
 	list_splice_init(&unused_folios, &pool->folio_list);
+	cleancache_pool_stat_add(pool->stats, POOL_SIZE, count);
 	spin_unlock(&pool->lock);
 
 	return list_empty(folios) ? 0 : -EINVAL;
@@ -1009,6 +1104,8 @@ static int __init init_cleancache(void)
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
2.51.0.740.g6adb054d12-goog


