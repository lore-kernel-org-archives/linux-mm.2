Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66129CCF9EB
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F838E0185; Sun, 26 Oct 2025 16:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321B28E0184; Sun, 26 Oct 2025 16:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173C88E0185; Sun, 26 Oct 2025 16:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDDD18E0184
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88A82C02E9
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:33 +0000 (UTC)
X-FDA: 84041423466.04.265AF19
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id B95B01C0003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2W+QhOd;
	spf=pass (imf20.hostedemail.com: domain of 3Tob-aAYKCKMVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Tob-aAYKCKMVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8fKQJfeDm6lPLiecQTGQk23fhbVChRxMsUUt63Q0w4=;
	b=ij40SquUbTOJ8utUMBIeFPPH/MF1aCd1mkXC/X9SkYW3/A2Jn0GUqFcFfzZWo65vbP0ekI
	MJOAloZ0V7bfQki14Y7TiQDn60XajpwCA2cq1M+cjUzSgI8ZkWV282JJkDbOocv2AA+lTn
	CXGg4GurC/Veela/Cc/KrG9Ud+AXFPo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2W+QhOd;
	spf=pass (imf20.hostedemail.com: domain of 3Tob-aAYKCKMVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Tob-aAYKCKMVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510991; a=rsa-sha256;
	cv=none;
	b=IXq4omwHdm0OqPxlM7JnhlLqqIJv+vO7Ret24A/8Ek9M2/QEHRnV8d8SpKP5ER7HKx6zK5
	Ik/pwBxv6iDSdvLkbK4dHzR1dAfEoVmSncPDuGLi0bi6DA7prA/70FrCyl12GloYlsXt4q
	Y2fkZNOluQEWj+Fx9BBAUcpYpGJGMO8=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2909daa65f2so57171985ad.0
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510991; x=1762115791; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8fKQJfeDm6lPLiecQTGQk23fhbVChRxMsUUt63Q0w4=;
        b=I2W+QhOdEQ0QvPQDOxWRIbH57aY452LbAg7nEt76sPwHy5xngGc78pzRJwk8dD/N7F
         F6jLy8G5kjuRew2NjhWGHu7zE9nBHg9o7LtU4moq6ztV9u/nPsT/5s6so9L9d7OpByxt
         umBjLeYHOui1hKZPOs6GNB75OgECuTareCUSXMYYh+n2qaSwaLRBdWBXgifpVRZsSAqd
         mH1SHGwRx9putuwCdnzBeH/lJoN/gMRdh+SKrm/DU/P7N1AYXZjNASxhbgqiNiOM2Ily
         38cy+KwX8dae/A0y5o+S88JWuhGmkI1uH0rsBzT/i8+4pwqwlMdG+Adbs/v0Q4x8fzDb
         Djag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510991; x=1762115791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8fKQJfeDm6lPLiecQTGQk23fhbVChRxMsUUt63Q0w4=;
        b=VurfeaQSH80n+5sQJE0reHAAdKA21m2Q7DcQlZn4bxTGOFLjP3jOg5WMyop14Ic7mP
         q1tk5G9gjd1jPUdmQu1nbY5DpwLydI0JsRx2e4Yc2HjxsUrXba+zM+UES3Fc9OisrBoa
         wk+tJ8wL5TsWWKgLmBd2rAezRJtPIszvCdm9UCmDzPPxP2EY/IwbIxyRZ4x0wXGb7KY0
         cRt75h1xbOgcWXtl2FEhr7wlFhmEXdJz/mh5SeisP2FYhZWVbxzaUuBX0Ws5ce22azfC
         4KQxow5OgtlVyD8AXDbjACWcLK/gdxl+/PR0naBQ0Ae8v04gDh5lObjeFObpIVPOgJLD
         3n5w==
X-Forwarded-Encrypted: i=1; AJvYcCWAsAnrEgNUvAZ5u6Gutc6eR6gh3dK+5QXdPwYqsHSCRgJ0t/y+iQE+wqmLZaiHXAtqvA6VnKjLmw==@kvack.org
X-Gm-Message-State: AOJu0YySEUxmOPlnbfLWFP5DIuyRr1pNj3Sd2CVuuwibvHVTcKNISnNs
	3PBaN5O0nPK4xTAxvYny8iDStcvQqP4slbCcGhy/686uCCgc8XQUiwSS426+qJb0Hrdy4GsDQwo
	MJhAokA==
X-Google-Smtp-Source: AGHT+IF0KfskSdKLpVux68qy5bYP7cU8OOYanXrqoLeO8zCN1YVKm99EcrKefxwR8RyvHyXu3BZDAiNrGaY=
X-Received: from plgs4.prod.google.com ([2002:a17:902:ea04:b0:268:eb:3b3b])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64b:b0:274:506d:7fcc
 with SMTP id d9443c01a7336-29489d71137mr117673365ad.6.1761510990611; Sun, 26
 Oct 2025 13:36:30 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:10 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-8-surenb@google.com>
Subject: [PATCH v2 7/8] mm: introduce GCMA
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
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B95B01C0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8uyr7deeabdufx5j91ck5x9njqemckaw
X-HE-Tag: 1761510991-584752
X-HE-Meta: U2FsdGVkX18DXp5yxmvjpZ5Xk8eKrddWgTiaz6M1MN9WA0aGtSwuJq3vaEBkhHSWNR+N2kfv5gHc4iu2KiEKCgw86W0Sd//IuB3fxup6jkN7/WA+c24+TL+7jjyPwP2iQ5BuDwB8FXWbd5SrCla/Fxn9JG17pBJqFmneCy3iz/8t1xNk5HERRS54XrQBUz3nNDzaCcxv8Xx5DbaP2aAJcHJAlo520x00MEyvVej/suo5J30ruDPnxSYg3EVmWkVzHUy0JUpsysa+7VvOltJkjM8ikqNP7nRs7R0GZ44jn80g74y2Mn8JHHnoDoN6V46QRbEKhpcns2jRTrJ5oOjX5lQIqsgQow+CJjq86FbkGvwPhzyqXhdJ41TpMyls+tK9fPehWWxnFHHs81ilS3uBO5WAJaCQJzknEkbqnf+YqXrhRwCV4+R3LqJOdwYEar95un0ctSfbB74X8NXOcLGB+JUTMsAduOrJUWNerJ0GAJmKzjLCBxSHz2A+W9nUVAOcDt/qOSX1RZQhU0o/9Ak+ixPztC/HSmlPpMdFNlQ4y9M2oZRPEPNNF+3znrSB9Jqyc5fknaFHBlyjKXTzndaN8agkHwNqRQ/KvNC9fbXuOGvdtMDs4SpQyVixvtmMi588ojMBcL+QM2xq5j/yLabRt41o9nOiopVaSrfP2hqxOukKcdOR50D9fLNZrbSQLzYAv7W0OYIISYFghuEQNzrcnUb3XpZcWVouahw0CStYToI74FWESHwnzrJumexYGGzxfjC/iVH2yS/jgCsfsVtUqBmFqvr/BHQXNpuNZhxPZPqSlCha98WrgWRAjTmcVxWVyQKeW7/ex6uJZX0Xeh6bmzdhmu5/D+rTeYOyNsn1RVnOQXmbhtAWRpaukWWotAlKa/Bm65/iSap8Da+o8s9AtOn345K/qcO7S+vVWNHmtCpdmprzlK+CghDCvNE+an30qwUUZ0GhrmukdelOjX2
 kYr2Wqu1
 svtfFT0Zx3+xUSaGs/oQKmwSOzpaORZH8MhM3349+z/FlIitjOfcf/zLuebuVdQsyZy31oiWhPWwqNWOI3EQUfvXLLSZwugCJo5xZ5y0YEhSRzb+Oxwic125gl1rSrLOUecGSdeeb46cR8bMKPtJsWO1dstePEca6S2jSeIL050YQ54/g76A+XKtrHSe65cUGGuSmh14wbW31bFryoc8Gvlg61MXalXKud2n/KskJaYVT7K1qsORi94ME3x1QVYof63Iq+l7BLsGyW9mU0uKNI9vMi1ui81VTkZSyG9YfLpkgMIl1tYHr8Xs8fKyuCbrr4StHJmA2JsdlmXV23HFLBIyN2MHEdINX8OOkV1o2ujq3k+p7LtN+QdU9kLFvQAavu4LVRJsupyHNg9v65XYeE3jvYlyu+aC4SfDtUxwG8nTRrOBc6ZZpWmccXzbDMsj97Xl+HDGNDlJUhT1hTv1/4YQSkQY6YvKSNfJHSIMLmqv6JNoZYqDVbA++155FJbZSKhYn0glRu5U2LXUVtotWhZC20mbXXZZ2ThAMIz35LLyBstIsUhDspuUPxMIJurzgHtG3GnVEkTCsASrA3qLaVKvA2Olu8c7d2dNTiEvTl6rWF381xo7ztPmPoebNbCbeeXK0OeS9OkbFP8VFfS6dgw1F+394INQ/eP/C0xoPmpTo0SWpQvDdfkAlK7FgeRyuFvdk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Minchan Kim <minchan@google.com>

This patch introduces GCMA (Guaranteed Contiguous Memory Allocator)
cleacache backend which reserves some amount of memory at the boot
and then donates it to store clean file-backed pages in the cleancache.
GCMA aims to guarantee contiguous memory allocation success as well as
low and deterministic allocation latency.

Notes:
Originally, the idea was posted by SeongJae Park and Minchan Kim [1].
Later Minchan reworked it to be used in Android as a reference for
Android vendors to use [2].

[1] https://lwn.net/Articles/619865/
[2] https://android-review.googlesource.com/q/topic:%22gcma_6.12%22

Signed-off-by: Minchan Kim <minchan@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 MAINTAINERS          |   2 +
 include/linux/gcma.h |  36 +++++++
 mm/Kconfig           |  15 +++
 mm/Makefile          |   1 +
 mm/gcma.c            | 244 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 298 insertions(+)
 create mode 100644 include/linux/gcma.h
 create mode 100644 mm/gcma.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3aabed281b71..40de200d1124 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16384,6 +16384,7 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
+F:	include/linux/gcma.h
 F:	include/linux/ioremap.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/page_idle.h
@@ -16395,6 +16396,7 @@ F:	mm/dmapool.c
 F:	mm/dmapool_test.c
 F:	mm/early_ioremap.c
 F:	mm/fadvise.c
+F:	mm/gcma.c
 F:	mm/ioremap.c
 F:	mm/mapping_dirty_helpers.c
 F:	mm/memory-tiers.c
diff --git a/include/linux/gcma.h b/include/linux/gcma.h
new file mode 100644
index 000000000000..20b2c85de87b
--- /dev/null
+++ b/include/linux/gcma.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __GCMA_H__
+#define __GCMA_H__
+
+#include <linux/types.h>
+
+#ifdef CONFIG_GCMA
+
+int gcma_register_area(const char *name,
+		       unsigned long start_pfn, unsigned long count);
+
+/*
+ * NOTE: allocated pages are still marked reserved and when freeing them
+ * the caller should ensure they are isolated and not referenced by anyone
+ * other than the caller.
+ */
+int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp_t gfp);
+int gcma_free_range(unsigned long start_pfn, unsigned long count);
+
+#else /* CONFIG_GCMA */
+
+static inline int gcma_register_area(const char *name,
+				     unsigned long start_pfn,
+				     unsigned long count)
+		{ return -EOPNOTSUPP; }
+static inline int gcma_alloc_range(unsigned long start_pfn,
+				   unsigned long count, gfp_t gfp)
+		{ return -EOPNOTSUPP; }
+
+static inline int gcma_free_range(unsigned long start_pfn,
+				   unsigned long count)
+		{ return -EOPNOTSUPP; }
+
+#endif /* CONFIG_GCMA */
+
+#endif /* __GCMA_H__ */
diff --git a/mm/Kconfig b/mm/Kconfig
index e1a169d5e5de..3166fde83340 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1097,6 +1097,21 @@ config CMA_AREAS
 
 	  If unsure, leave the default value "8" in UMA and "20" in NUMA.
 
+config GCMA
+       bool "GCMA (Guaranteed Contiguous Memory Allocator)"
+       depends on CLEANCACHE
+	help
+	  This enables the Guaranteed Contiguous Memory Allocator to allow
+	  low latency guaranteed contiguous memory allocations. Memory
+	  reserved by GCMA is donated to cleancache to be used as pagecache
+	  extension. Once GCMA allocation is requested, necessary pages are
+	  taken back from the cleancache and used to satisfy the request.
+	  Cleancache guarantees low latency successful allocation as long
+	  as the total size of GCMA allocations does not exceed the size of
+	  the memory donated to the cleancache.
+
+	  If unsure, say "N".
+
 #
 # Select this config option from the architecture Kconfig, if available, to set
 # the max page order for physically contiguous allocations.
diff --git a/mm/Makefile b/mm/Makefile
index 845841a140e3..05aee66a8b07 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -149,3 +149,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_CLEANCACHE_SYSFS)	+= cleancache_sysfs.o
+obj-$(CONFIG_GCMA)	+= gcma.o
diff --git a/mm/gcma.c b/mm/gcma.c
new file mode 100644
index 000000000000..b86f82b8fe9d
--- /dev/null
+++ b/mm/gcma.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * GCMA (Guaranteed Contiguous Memory Allocator)
+ *
+ */
+
+#define pr_fmt(fmt) "gcma: " fmt
+
+#include <linux/cleancache.h>
+#include <linux/gcma.h>
+#include <linux/hashtable.h>
+#include <linux/highmem.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include "internal.h"
+
+#define MAX_GCMA_AREAS		64
+#define GCMA_AREA_NAME_MAX_LEN	32
+
+struct gcma_area {
+	int pool_id;
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	char name[GCMA_AREA_NAME_MAX_LEN];
+};
+
+static struct gcma_area areas[MAX_GCMA_AREAS];
+static atomic_t nr_gcma_area = ATOMIC_INIT(0);
+static DEFINE_SPINLOCK(gcma_area_lock);
+
+static int free_folio_range(struct gcma_area *area,
+			     unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long scanned = 0;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		int err;
+
+		if (!(++scanned % XA_CHECK_SCHED))
+			cond_resched();
+
+		err = cleancache_backend_put_folio(area->pool_id, pfn_folio(pfn));
+		if (err) {
+			pr_warn("PFN %lu: folio is still in use\n", pfn);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int alloc_folio_range(struct gcma_area *area,
+			      unsigned long start_pfn, unsigned long end_pfn,
+			      gfp_t gfp)
+{
+	unsigned long scanned = 0;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		int err;
+
+		if (!(++scanned % XA_CHECK_SCHED))
+			cond_resched();
+
+		err = cleancache_backend_get_folio(area->pool_id, pfn_folio(pfn));
+		if (err) {
+			free_folio_range(area, start_pfn, pfn);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static struct gcma_area *find_area(unsigned long start_pfn, unsigned long end_pfn)
+{
+	int nr_area = atomic_read_acquire(&nr_gcma_area);
+	int i;
+
+	for (i = 0; i < nr_area; i++) {
+		struct gcma_area *area = &areas[i];
+
+		if (area->end_pfn <= start_pfn)
+			continue;
+
+		if (area->start_pfn > end_pfn)
+			continue;
+
+		/* The entire range should belong to a single area */
+		if (start_pfn < area->start_pfn || end_pfn > area->end_pfn)
+			break;
+
+		/* Found the area containing the entire range */
+		return area;
+	}
+
+	return NULL;
+}
+
+int gcma_register_area(const char *name,
+		       unsigned long start_pfn, unsigned long count)
+{
+	LIST_HEAD(folios);
+	int i, pool_id;
+	int nr_area;
+	int ret = 0;
+
+	pool_id = cleancache_backend_register_pool(name);
+	if (pool_id < 0)
+		return pool_id;
+
+	for (i = 0; i < count; i++) {
+		struct folio *folio;
+
+		folio = pfn_folio(start_pfn + i);
+		folio_clear_reserved(folio);
+		folio_set_count(folio, 0);
+		list_add(&folio->lru, &folios);
+	}
+
+	cleancache_backend_put_folios(pool_id, &folios);
+
+	spin_lock(&gcma_area_lock);
+
+	nr_area = atomic_read(&nr_gcma_area);
+	if (nr_area < MAX_GCMA_AREAS) {
+		struct gcma_area *area = &areas[nr_area];
+
+		area->pool_id = pool_id;
+		area->start_pfn = start_pfn;
+		area->end_pfn = start_pfn + count;
+		strscpy(area->name, name);
+		/* Ensure above stores complete before we increase the count */
+		atomic_set_release(&nr_gcma_area, nr_area + 1);
+	} else {
+		ret = -ENOMEM;
+	}
+
+	spin_unlock(&gcma_area_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gcma_register_area);
+
+int gcma_alloc_range(unsigned long start_pfn, unsigned long count, gfp_t gfp)
+{
+	unsigned long end_pfn = start_pfn + count;
+	struct gcma_area *area;
+	struct folio *folio;
+	int err, order = 0;
+
+	gfp = current_gfp_context(gfp);
+	if (gfp & __GFP_COMP) {
+		if (!is_power_of_2(count))
+			return -EINVAL;
+
+		order = ilog2(count);
+		if (order >= MAX_PAGE_ORDER)
+			return -EINVAL;
+	}
+
+	area = find_area(start_pfn, end_pfn);
+	if (!area)
+		return -EINVAL;
+
+	err = alloc_folio_range(area, start_pfn, end_pfn, gfp);
+	if (err)
+		return err;
+
+	/*
+	 * GCMA returns pages with refcount 1 and expects them to have
+	 * the same refcount 1 when they are freed.
+	 */
+	if (order) {
+		folio = pfn_folio(start_pfn);
+		post_alloc_hook(&folio->page, order, gfp);
+		set_page_refcounted(&folio->page);
+		prep_compound_page(&folio->page, order);
+	} else {
+		for (unsigned long pfn = start_pfn; pfn < end_pfn; pfn++) {
+			folio = pfn_folio(pfn);
+			post_alloc_hook(&folio->page, order, gfp);
+			set_page_refcounted(&folio->page);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gcma_alloc_range);
+
+int gcma_free_range(unsigned long start_pfn, unsigned long count)
+{
+	unsigned long end_pfn = start_pfn + count;
+	struct gcma_area *area;
+	unsigned long pfn;
+	int err = -EINVAL;
+
+	area = find_area(start_pfn, end_pfn);
+	if (!area)
+		return -EINVAL;
+
+	/* First pass checks and drops folio refcounts */
+	for (pfn = start_pfn; pfn < end_pfn;) {
+		struct folio *folio = pfn_folio(pfn);
+		unsigned long nr_pages = folio_nr_pages(folio);
+
+		if (pfn + nr_pages > end_pfn) {
+			end_pfn = pfn;
+			goto error;
+
+		}
+		if (!folio_ref_dec_and_test(folio)) {
+			end_pfn = pfn + nr_pages;
+			goto error;
+		}
+		pfn += nr_pages;
+	}
+
+	/* Second pass prepares the folios */
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		struct folio *folio = pfn_folio(pfn);
+
+		free_pages_prepare(&folio->page, folio_order(folio));
+		pfn += folio_nr_pages(folio);
+	}
+
+	err = free_folio_range(area, start_pfn, end_pfn);
+	if (!err)
+		return 0;
+
+error:
+	/* Restore folio refcounts */
+	for (pfn = start_pfn; pfn < end_pfn;) {
+		struct folio *folio = pfn_folio(pfn);
+
+		folio_ref_inc(folio);
+		pfn += folio_nr_pages(folio);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(gcma_free_range);
-- 
2.51.1.851.g4ebd6896fd-goog


