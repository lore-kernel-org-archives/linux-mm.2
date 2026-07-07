Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C14C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1E66B00A2; Tue,  7 Jul 2026 12:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289A56B00A3; Tue,  7 Jul 2026 12:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178F26B00A4; Tue,  7 Jul 2026 12:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E79F66B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65C628ED45
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:12:05 +0000 (UTC)
X-FDA: 84962472210.14.8013C38
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6CB8A140004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:12:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmiP+Zs+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdtacZ9QZNs8NBfbxYniGWvkfMZyXJuYZ+uj6tlE4eE=;
	b=iG04mmpHhqsteZ26LO1M4UU6HDUUQ0yL0fmfot/9lfxF2LIJqs/A+EUwhoYMDZRqBAtFlv
	LTXAj0SLNp2NTS0aFUpKJyh5t33J36bFuErq2e3SKiCEQUPvjdd5pO46ZCkwi8B63vS7vo
	NnwWXM5MM0bXWn2MLWDUMzPnuEOep3U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmiP+Zs+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783440723;
	b=1pMXAsFV0zg3Jc+XlDqbLmmv9WgGXWivwYyadBYqls7hQlu98LCXW/V9mL22/dJFeMWNc/
	R9oOhM6x+sfshv/QSeUYHjGgxanVJ9/MVfE/23KRlvjUMS0eMKegC07fzIPlutu4ExL/oj
	CFxMnsRasVk6L3KOfq8mDpUd12/HVw8=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso3325326a91.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783440722; x=1784045522; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NdtacZ9QZNs8NBfbxYniGWvkfMZyXJuYZ+uj6tlE4eE=;
        b=jmiP+Zs+BuHjAaq6YuK9dnAWxnstx29AuIy32EMI84bEm7kxcM9puQp5DlbVDEQU8E
         CIW9WLfpMAREGi4E48Pyr1t0576G17kOY62oFKRH66z8o5i2W4VqiMpar/yXVqTSjqC7
         f4wbO3rccG1DFMp6RhncK+cFDbByUglktzvKRmKhNFgh0x4nztGQRX7EeSu8FckR2xsP
         ZIYcIUD5aP20OTgQz/9uxY50AHgv//100SmmYBeIX85DjUxpRhMdaGP8Hb1S76w9j4nu
         GQLvycbJp2ltAvLbMVvrlX8aDiyapGwdbpryujTOYZy+W0SV4NlYXsYaoo/xE9Kbu7ZM
         AC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783440722; x=1784045522;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NdtacZ9QZNs8NBfbxYniGWvkfMZyXJuYZ+uj6tlE4eE=;
        b=eYr8LJRWwEWTu9aYju1SWirS9Sq4gm0HX+N4izU6I7Xu5ukg7P7Ed3t2lFwK/WQcNy
         Ii/PdggpcVe5UNEkuH3C/CAvT58u86+XuA/qC2A2e+nIbZkKLRYq6ZPktKVWguqV5yVd
         nA1PYNHoCu5GEqBZvbYpOO91V/hf1wGklS/2jEV9AZLD5hKVG/BhGLvjnQkc/r0ONQ5y
         7Uq850S2esIAQMD9SuwmBfvqQNcl6dh9ljy5xIaWtse7TAJXzRDNT5M7O/F3v2weREYe
         QYWCKEX8mjo7CBw3OelwB7Ss2x4xIjaJX+zAq2WLJgY9A8Hw1eDxEv/Lsaz+RV+mqp2c
         HsKg==
X-Gm-Message-State: AOJu0Yz00b066Qf0BNxSuKqNiIhGVAvaG1AiCz2yTZbAQE6bcVIBJ2sr
	vvaRNMMP6Z1d55el4zGDGmrzH+Jvb96IrsX9xFl962kFk6rpywlPhD3o
X-Gm-Gg: AfdE7clTkyT2HaC5/QIzcjcmwl+VABc4JSuYc+RacvuYgbhC0H8UY6nV1RLjlerU4ym
	9bgjzZrSaUTcH+xxUZkDupDuNU3zhjfl7N9lDOi6u5Rs/L5uT9yoPHCLqK1FMO6C/cmzlKoK3aa
	7ixLt3Tj0M18envTswcEGxT2zt/WJdcfIlYTIacmhqVP3nltrenbMoWdGhEsqBuW/PAofaUhrMD
	SXid8o0MIQrLfNloimUZqOhMkyagiNsfJcFUKbzc9NIV5FVoycjNxikleUctaWoFvhUuc6GVCMZ
	G39YcPfqyYdrPnKdpeNRSFaiEJzEO+5r+Nw3onQUZF1tZvU0NDs64iFNsN7sWZj4EKVhInl7M3/
	A3yBas4gQijcA3mX2cG7sQPyVfliCZUD28fMDK8KUVM674wapSviudOZGxPC75bMVhy73E80ugW
	Z8PtnJrenU4yb5DK+O1pz/r3YeSZ8Bccc2lYt1ogIPEkK0iWZ7agvEsmSIxir4taGL8YVRabu3K
	qEMYqna3S03Ie3l+jcd7H1YywBm+A==
X-Received: by 2002:a17:90b:390e:b0:381:270c:4dd1 with SMTP id 98e67ed59e1d1-387572b2e6amr5654864a91.20.1783440720732;
        Tue, 07 Jul 2026 09:12:00 -0700 (PDT)
Received: from [127.0.1.1] (ec2-18-162-112-89.ap-east-1.compute.amazonaws.com. [18.162.112.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfd443sm14712115ad.30.2026.07.07.09.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:11:59 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 00:11:28 +0800
Subject: [PATCH v8 2/3] mm: rename swap.c to folio.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-2-e816812698a8@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783440691; l=4030;
 i=wujianyue000@gmail.com; s=linux; h=from:subject:message-id;
 bh=yq5j8WJXfLbQ2tXMHiZDbuoRUdTLBMAg9V0gGqHlseI=;
 b=NJEaBL4+AOhOrHGWbF/kPX3jLuw2n2Y4XYsEhov8CvK30sYd6ByGXTw9d7ln8OZGjjU6uHBw0
 tDSqDrQhw+RD9vu5kF0vIsfiHrJg6eaNGmrQIwTn4WQrc3nsiNflpkB
X-Developer-Key: i=wujianyue000@gmail.com; a=ed25519;
 pk=49tqjvkqDVX1TtHEyTCiJGlKLg6SQ4BmgzG+HoHQW6E=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6CB8A140004
X-Stat-Signature: 84tf9xr8tyk4smr19qbqkhidqmwjuika
X-Rspam-User: 
X-HE-Tag: 1783440723-761055
X-HE-Meta: U2FsdGVkX19VbJ5Q+Pr0yNanOtxuCydxdO+Gs3Hyd7LzcN67bvo7VYV8vm+HndFcfhv/beH+GdhtMtq9ywdZ6K8/6APn+9M9jpDCH5Bp0fnsj4UIAtnRDKOqgaqZbC9Imx8VRZ+7ooixmQ7QnyMKOQY0vb3sfWEXQbZrXTHnMDoMogB2Mmxm79wLlL/4GoFpq6WkLC0JObOGK7xNlCfJRSy2bGm8ltuIn/xjgYeNUCzNn4djuyyMS7i3ONEa2FRfbnkH5ZFKtP2b+CSA1Zw8yvXL0vMI+uhXNkJ2PNxrfGh3uAuNtfW46SUsvRBNETbx0+/GXMWxK6gotaasaolW17ChxMz7bEYbNnYCLuYi4EsBWQTsNSsJ7SKVn6cBDmvgGvbWS2cPWDBVkVtTZgToQWLgSy6tpHOmP3FawnmKcSwkfzuGQujGfopqZvMyjlbuGR/3AD164QQL2WRu4q1burVwl5qogY3AEsVK1Kk/4MG9L+LxYBmSBlUhiy+/nzuWDqp0kIym3B0xpj6sW2erPnf7oGsAyOCqkp6t7zIgCfoK17RNhNva8YqOXA/lwq6mRnZj2PIV50NUanvbhQ2558VVeqnXJdGViry/xhr9+bVcAwhvHYjgvb50jl0qwzsMmDQvRedN3Koif+RG/XxJdY4VrVWU1f1RWjkKREav8Zv+zmLuSrVAwT6cRJezWKeYliMd2gc5LqX1j5TUUORrSzBd3NDe6+nBaAITOW6vg++JS7abx2VKBZD6sWhiIOFmTP/1MSRFqqHD4ZtrbRNbBzU7gJZijQwQW1/8FGL4z2eGGmPkLJ6FNIDFlIlZiLhVTPxGmC3zeXy4kpV2Am40Pln0oPc6LS6YFCM+CrrhZYW317rKtQDrYe4nMKz6Fpep+G6zuKql9mNuWtFtpktQq60yGe+VfoodAsQpUGTkb7cSR8s+eQIuxLk1eh0cFJLZ0keneGtbxUOdeDWLaOB
 OzhX3dFS
 m4qb9UdJrT0EZZo2UvZay+G4ZUS78J/JIhJkNxFdkyK0HRPhuz2eqqIV+8RHXSrlGgQvCKE96mkI75oHTkOcBvpQoGy/wAHWx/KgxDsxz83ihmb8SVojUYXnf65ICHcR+Zk/6lczPYBhHl6K4S9w8mrZLrS0sQ6IdYT7Z9FRK6GBP4qEBJHYuMtoQcR4QIA5kwvdp+IBcdfvB4HTvmaEZb/AzCXJRphs261V8J8w6OoNrumESvZH6y5I0rGqS9GhMR2Cohgi6VPQ1SDVGOi5t16Nwxhz1hf2iVMHQqdvLrzq7qNMFuRJPCNohJeKrF9iQbpfIr9Srrts1XdkRow5x4ySaOIHn5HnWxgCMm1YC+78tko3NyuDaF+xrtvZEuO1S3Rhynm9KW++81YYqGiXlboHR+NeOIMBHbpK2+MupPCrb677luUYvjrk1dFII6X1l/76Y2ANa7nVrwG0wJk8zP2SARpbLaD3g8ysY7s4akylMGolTKb12NVdR5jNAkbdesF4idMR64zQeoqSE+9jGNN9voXZBS2eUWtGgMcGRE2hw3QchdjPWHLg3JIgSlMZQoVq5a50W52OXeMXaxyshlDhbwY3tkCahZ7ad2oP0+QA+z9tXM6AXQhOK5ysLeu0g65o3Jtdv3pRs+OCDQkgRFMp5zGkbby7MkUJaVu31AMWATUr/e1gpJMJPNyjjGvfQX0l8gcnAnLc7tVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename mm/swap.c to mm/folio.c so the filename better matches
the code's main responsibility.

This keeps the implementation split from swap-specific code without
changing the published LRU helper interfaces.

Update MAINTAINERS and the remaining mm/swap.c documentation references
after the rename.

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  3 ---
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +--
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 10 +++-------
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 22cc54cac3b2..5b318d17aa4b 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -19,9 +19,6 @@ The files in this directory can be used to tune the operation
 of the virtual memory (VM) subsystem of the Linux kernel and
 the writeout of dirty data to disk.
 
-Default values and initialization routines for most of these
-files can be found in mm/swap.c.
-
 Currently, these files are in /proc/sys/vm:
 
 - admin_reserve_kbytes
diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 4df7d5edbee5..c1d03a5a2a19 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -118,7 +118,7 @@ More Memory Management Functions
 .. #kernel-doc:: mm/hmm.c (build warnings)
 .. kernel-doc:: mm/memremap.c
 .. kernel-doc:: mm/hugetlb.c
-.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/folio.c
 .. kernel-doc:: mm/memcontrol.c
 .. #kernel-doc:: mm/memory-tiers.c (build warnings)
 .. kernel-doc:: mm/shmem.c
diff --git a/MAINTAINERS b/MAINTAINERS
index b359ff4e0a1a..c39707e9ce9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17086,7 +17086,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/swap.c
+F:	mm/folio.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17238,7 +17238,6 @@ F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
-F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
diff --git a/mm/Makefile b/mm/Makefile
index 4fc713867b9b..8e7e964b99a4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -50,7 +50,7 @@ endif
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page-writeback.o folio-compat.o \
-			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
+			   readahead.o folio.o truncate.o vmscan.o shrinker.o \
 			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
diff --git a/mm/swap.c b/mm/folio.c
similarity index 99%
rename from mm/swap.c
rename to mm/folio.c
index c88643e56af7..d2937600cf72 100644
--- a/mm/swap.c
+++ b/mm/folio.c
@@ -1,17 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/swap.c
+ *  linux/mm/folio.c
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  */
 
 /*
- * This file contains the default values for the operation of the
- * Linux VM subsystem. Fine-tuning documentation can be found in
- * Documentation/admin-guide/sysctl/vm.rst.
- * Started 18.12.91
- * Swap aging added 23.2.95, Stephen Tweedie.
- * Buffermem limits added 12.3.98, Rik van Riel.
+ * Folio LRU helpers: add/remove folios from LRU lists, batching,
+ * activation/deactivation, and page cache release paths.
  */
 
 #include <linux/mm.h>

-- 
2.43.0


