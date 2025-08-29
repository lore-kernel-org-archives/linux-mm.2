Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06EACA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37D46B0029; Fri, 29 Aug 2025 12:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C956B002A; Fri, 29 Aug 2025 12:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95566B002B; Fri, 29 Aug 2025 12:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CACB6B0029
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:22:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D269616071B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:35 +0000 (UTC)
X-FDA: 83830313070.04.75FECE8
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE901A0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=r0kx329R;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756484554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKqb+mo8c5YOBYVE1Ay2NJr1wYHFuWGaBFA4CjRh+H0=;
	b=XC0XxdMOTVazDUJZXesZzwoY8hjuvfygcbLUEeixwhHtHBGNoGpv9iMuxA/IxsnPkH1wO9
	mHCVvMz3L2hMfaRcHQRMrSYtuZb6+Ye2KgEsKxtj75yPkEfbpjUW836nv5S4Vcyl6NuEVP
	naXQSoFTlV1agrGXuNBauFpq+c4zjjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756484554; a=rsa-sha256;
	cv=none;
	b=eTAxHiSQrhBmSRa91O/wGesAdB+F1wD6QPXOWkw+r6Necn5QVykel0AO4uwnTK74+2nu+R
	TfhD2nwY45rn+u/eJnW1BLTNocQDs9emdzLP3WT6G2EBIhKXw2uL2xaVSEIzQQakAfwKbw
	ZWqVqsWMxQ00Jj8RqFpawwaA93esdRI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=r0kx329R;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3cdc54cabb1so888939f8f.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756484552; x=1757089352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKqb+mo8c5YOBYVE1Ay2NJr1wYHFuWGaBFA4CjRh+H0=;
        b=r0kx329RK3LpUQamAcoS0Fq2bZRHjlKagQNiRPEorpYJMMuk5TSWmlPe+CYGZoa8dZ
         UTVLtyNdC2+CENhIoIYlp5QSALEBbISBYGAcTZf+GzSXEAAJzfuVG6eD4teqNPj6gN6/
         Z0qjpdk3Jck9HpZZNF4fr7ekgLjnNPIwCZv8d+aAWTEiZY6a6r0u6YZGcF3cLNDg+Mt0
         sC8WLhy/tYwVHSHmOSRsWEOL8I9Cv4mJnx+CDb4P4FgIGYjLakHdvcbNABSanptaMOWJ
         DBojmhK4hlW9DxfWFmF2yBw9uGJj2tuCsg4hUCDuTrhCtaCz36992zNMQgkUDm+5xeO4
         COVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756484552; x=1757089352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKqb+mo8c5YOBYVE1Ay2NJr1wYHFuWGaBFA4CjRh+H0=;
        b=jQH/XOOOdC0AupEUj+AeurIGm0wgb+lRqjL8SPPDhRJiaq2fxxDeOgc+cGsBxFquon
         NUcUT5xxO+GGLAtl+aLk5qs7jMjLM8pYmaMdgjnSbHc5s3R/WETFMRhxkGdNkis7ScKH
         qOMOOwx/ofpJFeRsWIOOlSFQsWdcOF41DJF2bzKK0tVG5SmPhSTWIKyhbyDisVFHqmAf
         duFsEy3W7uV112JuGDkhRd7nud5YWpbB6yAGm1HFXMcs4bHcfpOy4YjBePjkNlfX94Ei
         DkYYK5rZgONgN4VzCTFSQCqWXYEeSeqogfdUgPEARQ17WLNw9TEDv4kaai6OgZV/7NEV
         p2fg==
X-Forwarded-Encrypted: i=1; AJvYcCWh7bmqYjfvGvavAUEiB1HlVLADLzIkCSBQTxoPNx7BJT54vtn0XlBdEOC9RWjo2RaVLb8QvnfHNQ==@kvack.org
X-Gm-Message-State: AOJu0YwevTcRcXhdGtB9MKSK8LX2AhLSyftfouaDdsIAp7SNq3HHW22q
	8RfZq5m/I54xGgbaeiO7fyvhDmx2ukGDI0zHu9nNEt39/r16l0Z/BHXcVlmPE1jF+TI=
X-Gm-Gg: ASbGncsBj2ezFqAo597dIcAnuCR+8cghAYDvLLYEIwpW9XLP5cjQ/PJIGjNWeeaXeeu
	htpq+nzbeqoWHQFmV/eGqQWMe+opsIGqK4Z3U4zgdjfTQnOJVqwXiXg+y9s5NMYzO6IOeT7wHZw
	Uon8gLPrQiK9vZRMci8VaK14j8sTkSWGNe4zhGmz24nKg8lYaD0ftlGQngwmZfDmmEsi+zERLjx
	tefh597C/aqeQFaFPcqUSoexxdOe3H9TsJVyTH7SoCgdKJmsDlnKH0nbmE7fTLh+RSkdo7HIVxJ
	6ILe/ERte+LhNbL5cR3dxHN9ahpL+kdWEFWdSRanBSiY5bZx8kor/jxlLR7yY1vDHCRbfC+tkDs
	4+Fw=
X-Google-Smtp-Source: AGHT+IF5r4ch8VgJ9lf0pLM9LepqQrx7y0p63EHYU7GY0DjIm/bdz0Trn7EVc7AZJrYBUY0yFILr+g==
X-Received: by 2002:a5d:584e:0:b0:3d0:bd48:246f with SMTP id ffacd0b85a97d-3d0bd482902mr2019862f8f.31.1756484551871;
        Fri, 29 Aug 2025 09:22:31 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:954])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6f0d3073sm139737085e9.7.2025.08.29.09.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 09:22:30 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: remove unused zpool layer
Date: Fri, 29 Aug 2025 17:15:27 +0100
Message-ID: <20250829162212.208258-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE901A0012
X-Stat-Signature: rninstjcgcxj3iyn6aj64j58tqafq54k
X-Rspam-User: 
X-HE-Tag: 1756484553-824021
X-HE-Meta: U2FsdGVkX192LzkiQW0brDrxkPyNiBe/qDG4ggt0/Tj+/CE5rWQo19gfVCegBrff+GsBij2+FSXmEmFhwYqIkcrfaqYMMg8rZh6ViRrYAdUKa8nLYLNfUuOQesBiKB1SzTT4PmuRriGL4z3imA+pDpHDoCkZ2o7TP8RFWIzVrrHe/OzOGWZohFrJpbsEt3mrcV/24ZfMPKs52bcORxzvhN/sIbqW/lThIq7Lf111mSWrlw+t+Yw+F+HhqPRbgO71m6u7aWinELLkAFNLsDyowMBLWuLckovmrRGrHnoBvnSWrkKJmn0BQtekGldz+WiGjGHqnO1y3aNmIPtX9KtWN2JqeDsnuAUGnISJ583516HSv+ATwAw0LaiyiO+hxaCfXfg/gcuI2jKfGfj/l1XH9K01AeoZAL3UJhhB3Xd8Kngut9NvzAbT50aRHoj6ueJE7E2hvrnmugu1PDB4XASWpthZqo5B9b6YfOyHKrH/YEmmWJVbcOXldQ76yUcXRQQ1s9CBeCVIixUXnZ5z5lHFSweKmiTswrjOD4xBQTmhd8UJHg+l8Uo5eTJeEpeqzm+fRgYM+Xt7HRBE4/kBscAczvBl3KsdCdRNBTM9Y16YmfUiuHlw6EVg9IsY+NqegIxCZJy5ODv9m0U6V+BGzPHnhGp9z2amysiZSiPDmAravVPAv3JcWcvCwSa7U6rcExzj2oPJXBJEN6ASviXokF0njTN/HYeIBid/5EG5YQh3J2WQxXk+cf5HXW0zs7/Z8gJ/ccfHWuZmYIu/qaPXY9XwW6ozeL48BEV9WGnP3TOnjC220+Bb/3ivFicjgPScLCgQ5SwNLDpst+ZXYKsHERLpy5XTrZNVVW8dA2u1MWsC4eQkbxBAfX5YRBdtguxAYF+0+CNS9P0e09ONpv00sY+VgTWq4dTe4qnZ41nc0nXHHoDmghG1chnvfNkUdJ+9fgl0qAHBvmYMkkda3Cdylsb
 mu80olzm
 M5tlGhENacbf6QCX1TN46YHp/zHHwdE8vkv7RB5FOLI3H2ctK1qUSSdIWAccqxXIlJTf0FvM12BGx60ZzhBcWrpLDTdrsw4VLiWrniw8SZi9OKL2fzf9QUXmZ62BmyM/Zj9vg2P0+ZkqOjavedg32cZRR9kevOzWJta8nt0vBkZF58xRZiLJXXA8ovThX69X2w2HvBqZwvnVSXaL4tPz4jM+RqbEv+ZR/1hIK2jsc17d8MnHSZf8pfzj4Yt9j3hr9giMrTR2eoRb+pVnNz2PgyNnYdXBJf7th9ZEu8MegqWN5j2vQ1e8s29eJrmqZR64Wr8REOuf9fp0QWQom03CVNHlSLJUPgnw90/KmE2TlrOhSkGzLl8XiR1iWrHBBZ3nWOVbTSfkPhCsS8p+dDQrPtIjjli5XK4Dj00fps+a7b7Os5IYG81V3nbrdfvNya6BIfqsCR9LEnfr5qGPn9k6+x68HygmSljNsMbXjvTZn7scV3mnhvpO0RrNXxtT7xLJpW8W2Mvt4dzdITFllI/yw4ComOeLkoap2ZVadvfG/sRjvssThNMIfx94MGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With zswap using zsmalloc directly, there are no more in-tree users of
this code. Remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/admin-guide/mm/zswap.rst        |  33 +-
 Documentation/core-api/mm-api.rst             |   1 -
 .../driver-api/crypto/iaa/iaa-crypto.rst      |   2 -
 MAINTAINERS                                   |   2 -
 arch/loongarch/configs/loongson3_defconfig    |   1 -
 include/linux/zpool.h                         |  86 -----
 mm/Kconfig                                    |  49 +--
 mm/Makefile                                   |   1 -
 mm/zpool.c                                    | 328 ------------------
 mm/zsmalloc.c                                 |  79 -----
 tools/testing/selftests/zram/README           |   1 -
 11 files changed, 23 insertions(+), 560 deletions(-)
 delete mode 100644 include/linux/zpool.h
 delete mode 100644 mm/zpool.c

diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index fd3370aa43fe..283d77217c6f 100644
--- a/Documentation/admin-guide/mm/zswap.rst
+++ b/Documentation/admin-guide/mm/zswap.rst
@@ -53,26 +53,17 @@ Zswap receives pages for compression from the swap subsystem and is able to
 evict pages from its own compressed pool on an LRU basis and write them back to
 the backing swap device in the case that the compressed pool is full.
 
-Zswap makes use of zpool for the managing the compressed memory pool.  Each
-allocation in zpool is not directly accessible by address.  Rather, a handle is
+Zswap makes use of zsmalloc for the managing the compressed memory pool.  Each
+allocation in zsmalloc is not directly accessible by address.  Rather, a handle is
 returned by the allocation routine and that handle must be mapped before being
 accessed.  The compressed memory pool grows on demand and shrinks as compressed
-pages are freed.  The pool is not preallocated.  By default, a zpool
-of type selected in ``CONFIG_ZSWAP_ZPOOL_DEFAULT`` Kconfig option is created,
-but it can be overridden at boot time by setting the ``zpool`` attribute,
-e.g. ``zswap.zpool=zsmalloc``. It can also be changed at runtime using the sysfs
-``zpool`` attribute, e.g.::
-
-	echo zsmalloc > /sys/module/zswap/parameters/zpool
-
-The zsmalloc type zpool has a complex compressed page storage method, and it
-can achieve great storage densities.
+pages are freed.  The pool is not preallocated.
 
 When a swap page is passed from swapout to zswap, zswap maintains a mapping
-of the swap entry, a combination of the swap type and swap offset, to the zpool
-handle that references that compressed swap page.  This mapping is achieved
-with a red-black tree per swap type.  The swap offset is the search key for the
-tree nodes.
+of the swap entry, a combination of the swap type and swap offset, to the
+zsmalloc handle that references that compressed swap page.  This mapping is
+achieved with a red-black tree per swap type.  The swap offset is the search
+key for the tree nodes.
 
 During a page fault on a PTE that is a swap entry, the swapin code calls the
 zswap load function to decompress the page into the page allocated by the page
@@ -96,11 +87,11 @@ It can also be changed at runtime using the sysfs "compressor"
 
 	echo lzo > /sys/module/zswap/parameters/compressor
 
-When the zpool and/or compressor parameter is changed at runtime, any existing
-compressed pages are not modified; they are left in their own zpool.  When a
-request is made for a page in an old zpool, it is uncompressed using its
-original compressor.  Once all pages are removed from an old zpool, the zpool
-and its compressor are freed.
+When the compressor parameter is changed at runtime, any existing compressed
+pages are not modified; they are left in their own pool.  When a request is
+made for a page in an old pool, it is uncompressed using its original
+compressor.  Once all pages are removed from an old pool, the pool and its
+compressor are freed.
 
 Some of the pages in zswap are same-value filled pages (i.e. contents of the
 page have same value or repetitive pattern). These pages include zero-filled
diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 5063179cfc70..68193a4cfcf5 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -118,7 +118,6 @@ More Memory Management Functions
 .. kernel-doc:: mm/memremap.c
 .. kernel-doc:: mm/hugetlb.c
 .. kernel-doc:: mm/swap.c
-.. kernel-doc:: mm/zpool.c
 .. kernel-doc:: mm/memcontrol.c
 .. #kernel-doc:: mm/memory-tiers.c (build warnings)
 .. kernel-doc:: mm/shmem.c
diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 8e50b900d51c..f815d4fd8372 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -476,7 +476,6 @@ To demonstrate that the following steps work as expected, these
   # echo 0 > /sys/module/zswap/parameters/enabled
   # echo 50 > /sys/module/zswap/parameters/max_pool_percent
   # echo deflate-iaa > /sys/module/zswap/parameters/compressor
-  # echo zsmalloc > /sys/module/zswap/parameters/zpool
   # echo 1 > /sys/module/zswap/parameters/enabled
   # echo 100 > /proc/sys/vm/swappiness
   # echo never > /sys/kernel/mm/transparent_hugepage/enabled
@@ -625,7 +624,6 @@ Now run the following zswap-specific setup commands to have zswap use
   echo 0 > /sys/module/zswap/parameters/enabled
   echo 50 > /sys/module/zswap/parameters/max_pool_percent
   echo deflate-iaa > /sys/module/zswap/parameters/compressor
-  echo zsmalloc > /sys/module/zswap/parameters/zpool
   echo 1 > /sys/module/zswap/parameters/enabled
 
   echo 100 > /proc/sys/vm/swappiness
diff --git a/MAINTAINERS b/MAINTAINERS
index e791f18b61d8..7ceda15372f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27877,9 +27877,7 @@ R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/zswap.rst
-F:	include/linux/zpool.h
 F:	include/linux/zswap.h
-F:	mm/zpool.c
 F:	mm/zswap.c
 F:	tools/testing/selftests/cgroup/test_zswap.c
 
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index 34eaee0384c9..2b8df0e9e42a 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -106,7 +106,6 @@ CONFIG_CMDLINE_PARTITION=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BFQ_GROUP_IOSCHED=y
 CONFIG_BINFMT_MISC=m
-CONFIG_ZPOOL=y
 CONFIG_ZSWAP=y
 CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD=y
 CONFIG_ZSMALLOC=y
diff --git a/include/linux/zpool.h b/include/linux/zpool.h
deleted file mode 100644
index 369ef068fad8..000000000000
--- a/include/linux/zpool.h
+++ /dev/null
@@ -1,86 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * zpool memory storage api
- *
- * Copyright (C) 2014 Dan Streetman
- *
- * This is a common frontend for the zswap compressed memory storage
- * implementations.
- */
-
-#ifndef _ZPOOL_H_
-#define _ZPOOL_H_
-
-struct zpool;
-
-bool zpool_has_pool(char *type);
-
-struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp);
-
-const char *zpool_get_type(struct zpool *pool);
-
-void zpool_destroy_pool(struct zpool *pool);
-
-int zpool_malloc(struct zpool *pool, size_t size, gfp_t gfp,
-		 unsigned long *handle, const int nid);
-
-void zpool_free(struct zpool *pool, unsigned long handle);
-
-void *zpool_obj_read_begin(struct zpool *zpool, unsigned long handle,
-			   void *local_copy);
-
-void zpool_obj_read_end(struct zpool *zpool, unsigned long handle,
-			void *handle_mem);
-
-void zpool_obj_write(struct zpool *zpool, unsigned long handle,
-		     void *handle_mem, size_t mem_len);
-
-u64 zpool_get_total_pages(struct zpool *pool);
-
-
-/**
- * struct zpool_driver - driver implementation for zpool
- * @type:	name of the driver.
- * @list:	entry in the list of zpool drivers.
- * @create:	create a new pool.
- * @destroy:	destroy a pool.
- * @malloc:	allocate mem from a pool.
- * @free:	free mem from a pool.
- * @sleep_mapped: whether zpool driver can sleep during map.
- * @map:	map a handle.
- * @unmap:	unmap a handle.
- * @total_size:	get total size of a pool.
- *
- * This is created by a zpool implementation and registered
- * with zpool.
- */
-struct zpool_driver {
-	char *type;
-	struct module *owner;
-	atomic_t refcount;
-	struct list_head list;
-
-	void *(*create)(const char *name, gfp_t gfp);
-	void (*destroy)(void *pool);
-
-	int (*malloc)(void *pool, size_t size, gfp_t gfp,
-		      unsigned long *handle, const int nid);
-	void (*free)(void *pool, unsigned long handle);
-
-	void *(*obj_read_begin)(void *pool, unsigned long handle,
-				void *local_copy);
-	void (*obj_read_end)(void *pool, unsigned long handle,
-			     void *handle_mem);
-	void (*obj_write)(void *pool, unsigned long handle,
-			  void *handle_mem, size_t mem_len);
-
-	u64 (*total_pages)(void *pool);
-};
-
-void zpool_register_driver(struct zpool_driver *driver);
-
-int zpool_unregister_driver(struct zpool_driver *driver);
-
-bool zpool_can_sleep_mapped(struct zpool *pool);
-
-#endif
diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd96784..b971d35c43c3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -9,9 +9,6 @@ menu "Memory Management options"
 config ARCH_NO_SWAP
 	bool
 
-config ZPOOL
-	bool
-
 menuconfig SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK && !ARCH_NO_SWAP
@@ -26,7 +23,7 @@ config ZSWAP
 	bool "Compressed cache for swap pages"
 	depends on SWAP
 	select CRYPTO
-	select ZPOOL
+	select ZSMALLOC
 	help
 	  A lightweight compressed cache for swap pages.  It takes
 	  pages that are in the process of being swapped out and attempts to
@@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
-choice
-	prompt "Default allocator"
-	depends on ZSWAP
-	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
-	help
-	  Selects the default allocator for the compressed cache for
-	  swap pages.
-	  The default is 'zbud' for compatibility, however please do
-	  read the description of each of the allocators below before
-	  making a right choice.
-
-	  The selection made here can be overridden by using the kernel
-	  command line 'zswap.zpool=' option.
+config ZSMALLOC
+	tristate
 
-config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
-	bool "zsmalloc"
-	select ZSMALLOC
-	help
-	  Use the zsmalloc allocator as the default allocator.
-endchoice
+if ZSMALLOC
 
-config ZSWAP_ZPOOL_DEFAULT
-       string
-       depends on ZSWAP
-       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
-       default ""
+menu "Zsmalloc allocator options"
+	depends on ZSMALLOC
 
-config ZSMALLOC
-	tristate
-	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
-	depends on MMU
-	help
-	  zsmalloc is a slab-based memory allocator designed to store
-	  pages of various compression levels efficiently. It achieves
-	  the highest storage density with the least amount of fragmentation.
+comment "Zsmalloc is a common backend allocator for zswap & zram"
 
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
-	depends on ZSMALLOC
 	select DEBUG_FS
 	help
 	  This option enables code in the zsmalloc to collect various
@@ -175,7 +145,6 @@ config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
 	default 8
 	range 4 16
-	depends on ZSMALLOC
 	help
 	  This option sets the upper limit on the number of physical pages
 	  that a zmalloc page (zspage) can consist of. The optimal zspage
@@ -190,6 +159,10 @@ config ZSMALLOC_CHAIN_SIZE
 
 	  For more information, see zsmalloc documentation.
 
+endmenu
+
+endif
+
 menu "Slab allocator options"
 
 config SLUB
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..21abb3353550 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -115,7 +115,6 @@ obj-$(CONFIG_DEBUG_RODATA_TEST) += rodata_test.o
 obj-$(CONFIG_DEBUG_VM_PGTABLE) += debug_vm_pgtable.o
 obj-$(CONFIG_PAGE_OWNER) += page_owner.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
-obj-$(CONFIG_ZPOOL)	+= zpool.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
diff --git a/mm/zpool.c b/mm/zpool.c
deleted file mode 100644
index 0a71d03369f1..000000000000
--- a/mm/zpool.c
+++ /dev/null
@@ -1,328 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * zpool memory storage api
- *
- * Copyright (C) 2014 Dan Streetman
- *
- * This is a common frontend for memory storage pool implementations.
- * Typically, this is used to store compressed memory.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/list.h>
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/module.h>
-#include <linux/zpool.h>
-
-struct zpool {
-	struct zpool_driver *driver;
-	void *pool;
-};
-
-static LIST_HEAD(drivers_head);
-static DEFINE_SPINLOCK(drivers_lock);
-
-/**
- * zpool_register_driver() - register a zpool implementation.
- * @driver:	driver to register
- */
-void zpool_register_driver(struct zpool_driver *driver)
-{
-	spin_lock(&drivers_lock);
-	atomic_set(&driver->refcount, 0);
-	list_add(&driver->list, &drivers_head);
-	spin_unlock(&drivers_lock);
-}
-EXPORT_SYMBOL(zpool_register_driver);
-
-/**
- * zpool_unregister_driver() - unregister a zpool implementation.
- * @driver:	driver to unregister.
- *
- * Module usage counting is used to prevent using a driver
- * while/after unloading, so if this is called from module
- * exit function, this should never fail; if called from
- * other than the module exit function, and this returns
- * failure, the driver is in use and must remain available.
- */
-int zpool_unregister_driver(struct zpool_driver *driver)
-{
-	int ret = 0, refcount;
-
-	spin_lock(&drivers_lock);
-	refcount = atomic_read(&driver->refcount);
-	WARN_ON(refcount < 0);
-	if (refcount > 0)
-		ret = -EBUSY;
-	else
-		list_del(&driver->list);
-	spin_unlock(&drivers_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(zpool_unregister_driver);
-
-/* this assumes @type is null-terminated. */
-static struct zpool_driver *zpool_get_driver(const char *type)
-{
-	struct zpool_driver *driver;
-
-	spin_lock(&drivers_lock);
-	list_for_each_entry(driver, &drivers_head, list) {
-		if (!strcmp(driver->type, type)) {
-			bool got = try_module_get(driver->owner);
-
-			if (got)
-				atomic_inc(&driver->refcount);
-			spin_unlock(&drivers_lock);
-			return got ? driver : NULL;
-		}
-	}
-
-	spin_unlock(&drivers_lock);
-	return NULL;
-}
-
-static void zpool_put_driver(struct zpool_driver *driver)
-{
-	atomic_dec(&driver->refcount);
-	module_put(driver->owner);
-}
-
-/**
- * zpool_has_pool() - Check if the pool driver is available
- * @type:	The type of the zpool to check (e.g. zsmalloc)
- *
- * This checks if the @type pool driver is available.  This will try to load
- * the requested module, if needed, but there is no guarantee the module will
- * still be loaded and available immediately after calling.  If this returns
- * true, the caller should assume the pool is available, but must be prepared
- * to handle the @zpool_create_pool() returning failure.  However if this
- * returns false, the caller should assume the requested pool type is not
- * available; either the requested pool type module does not exist, or could
- * not be loaded, and calling @zpool_create_pool() with the pool type will
- * fail.
- *
- * The @type string must be null-terminated.
- *
- * Returns: true if @type pool is available, false if not
- */
-bool zpool_has_pool(char *type)
-{
-	struct zpool_driver *driver = zpool_get_driver(type);
-
-	if (!driver) {
-		request_module("zpool-%s", type);
-		driver = zpool_get_driver(type);
-	}
-
-	if (!driver)
-		return false;
-
-	zpool_put_driver(driver);
-	return true;
-}
-EXPORT_SYMBOL(zpool_has_pool);
-
-/**
- * zpool_create_pool() - Create a new zpool
- * @type:	The type of the zpool to create (e.g. zsmalloc)
- * @name:	The name of the zpool (e.g. zram0, zswap)
- * @gfp:	The GFP flags to use when allocating the pool.
- *
- * This creates a new zpool of the specified type.  The gfp flags will be
- * used when allocating memory, if the implementation supports it.  If the
- * ops param is NULL, then the created zpool will not be evictable.
- *
- * Implementations must guarantee this to be thread-safe.
- *
- * The @type and @name strings must be null-terminated.
- *
- * Returns: New zpool on success, NULL on failure.
- */
-struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp)
-{
-	struct zpool_driver *driver;
-	struct zpool *zpool;
-
-	pr_debug("creating pool type %s\n", type);
-
-	driver = zpool_get_driver(type);
-
-	if (!driver) {
-		request_module("zpool-%s", type);
-		driver = zpool_get_driver(type);
-	}
-
-	if (!driver) {
-		pr_err("no driver for type %s\n", type);
-		return NULL;
-	}
-
-	zpool = kmalloc(sizeof(*zpool), gfp);
-	if (!zpool) {
-		pr_err("couldn't create zpool - out of memory\n");
-		zpool_put_driver(driver);
-		return NULL;
-	}
-
-	zpool->driver = driver;
-	zpool->pool = driver->create(name, gfp);
-
-	if (!zpool->pool) {
-		pr_err("couldn't create %s pool\n", type);
-		zpool_put_driver(driver);
-		kfree(zpool);
-		return NULL;
-	}
-
-	pr_debug("created pool type %s\n", type);
-
-	return zpool;
-}
-
-/**
- * zpool_destroy_pool() - Destroy a zpool
- * @zpool:	The zpool to destroy.
- *
- * Implementations must guarantee this to be thread-safe,
- * however only when destroying different pools.  The same
- * pool should only be destroyed once, and should not be used
- * after it is destroyed.
- *
- * This destroys an existing zpool.  The zpool should not be in use.
- */
-void zpool_destroy_pool(struct zpool *zpool)
-{
-	pr_debug("destroying pool type %s\n", zpool->driver->type);
-
-	zpool->driver->destroy(zpool->pool);
-	zpool_put_driver(zpool->driver);
-	kfree(zpool);
-}
-
-/**
- * zpool_get_type() - Get the type of the zpool
- * @zpool:	The zpool to check
- *
- * This returns the type of the pool.
- *
- * Implementations must guarantee this to be thread-safe.
- *
- * Returns: The type of zpool.
- */
-const char *zpool_get_type(struct zpool *zpool)
-{
-	return zpool->driver->type;
-}
-
-/**
- * zpool_malloc() - Allocate memory
- * @zpool:	The zpool to allocate from.
- * @size:	The amount of memory to allocate.
- * @gfp:	The GFP flags to use when allocating memory.
- * @handle:	Pointer to the handle to set
- * @nid:	The preferred node id.
- *
- * This allocates the requested amount of memory from the pool.
- * The gfp flags will be used when allocating memory, if the
- * implementation supports it.  The provided @handle will be
- * set to the allocated object handle. The allocation will
- * prefer the NUMA node specified by @nid.
- *
- * Implementations must guarantee this to be thread-safe.
- *
- * Returns: 0 on success, negative value on error.
- */
-int zpool_malloc(struct zpool *zpool, size_t size, gfp_t gfp,
-		 unsigned long *handle, const int nid)
-{
-	return zpool->driver->malloc(zpool->pool, size, gfp, handle, nid);
-}
-
-/**
- * zpool_free() - Free previously allocated memory
- * @zpool:	The zpool that allocated the memory.
- * @handle:	The handle to the memory to free.
- *
- * This frees previously allocated memory.  This does not guarantee
- * that the pool will actually free memory, only that the memory
- * in the pool will become available for use by the pool.
- *
- * Implementations must guarantee this to be thread-safe,
- * however only when freeing different handles.  The same
- * handle should only be freed once, and should not be used
- * after freeing.
- */
-void zpool_free(struct zpool *zpool, unsigned long handle)
-{
-	zpool->driver->free(zpool->pool, handle);
-}
-
-/**
- * zpool_obj_read_begin() - Start reading from a previously allocated handle.
- * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to read from
- * @local_copy:	A local buffer to use if needed.
- *
- * This starts a read operation of a previously allocated handle. The passed
- * @local_copy buffer may be used if needed by copying the memory into.
- * zpool_obj_read_end() MUST be called after the read is completed to undo any
- * actions taken (e.g. release locks).
- *
- * Returns: A pointer to the handle memory to be read, if @local_copy is used,
- * the returned pointer is @local_copy.
- */
-void *zpool_obj_read_begin(struct zpool *zpool, unsigned long handle,
-			   void *local_copy)
-{
-	return zpool->driver->obj_read_begin(zpool->pool, handle, local_copy);
-}
-
-/**
- * zpool_obj_read_end() - Finish reading from a previously allocated handle.
- * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to read from
- * @handle_mem:	The pointer returned by zpool_obj_read_begin()
- *
- * Finishes a read operation previously started by zpool_obj_read_begin().
- */
-void zpool_obj_read_end(struct zpool *zpool, unsigned long handle,
-			void *handle_mem)
-{
-	zpool->driver->obj_read_end(zpool->pool, handle, handle_mem);
-}
-
-/**
- * zpool_obj_write() - Write to a previously allocated handle.
- * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to read from
- * @handle_mem:	The memory to copy from into the handle.
- * @mem_len:	The length of memory to be written.
- *
- */
-void zpool_obj_write(struct zpool *zpool, unsigned long handle,
-		     void *handle_mem, size_t mem_len)
-{
-	zpool->driver->obj_write(zpool->pool, handle, handle_mem, mem_len);
-}
-
-/**
- * zpool_get_total_pages() - The total size of the pool
- * @zpool:	The zpool to check
- *
- * This returns the total size in pages of the pool.
- *
- * Returns: Total size of the zpool in pages.
- */
-u64 zpool_get_total_pages(struct zpool *zpool)
-{
-	return zpool->driver->total_pages(zpool->pool);
-}
-
-MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
-MODULE_DESCRIPTION("Common API for compressed memory storage");
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 153783d49d34..5bf832f9c05c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -36,7 +36,6 @@
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
-#include <linux/zpool.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
@@ -433,78 +432,6 @@ static void record_obj(unsigned long handle, unsigned long obj)
 	*(unsigned long *)handle = obj;
 }
 
-/* zpool driver */
-
-#ifdef CONFIG_ZPOOL
-
-static void *zs_zpool_create(const char *name, gfp_t gfp)
-{
-	/*
-	 * Ignore global gfp flags: zs_malloc() may be invoked from
-	 * different contexts and its caller must provide a valid
-	 * gfp mask.
-	 */
-	return zs_create_pool(name);
-}
-
-static void zs_zpool_destroy(void *pool)
-{
-	zs_destroy_pool(pool);
-}
-
-static int zs_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			   unsigned long *handle, const int nid)
-{
-	*handle = zs_malloc(pool, size, gfp, nid);
-
-	if (IS_ERR_VALUE(*handle))
-		return PTR_ERR((void *)*handle);
-	return 0;
-}
-static void zs_zpool_free(void *pool, unsigned long handle)
-{
-	zs_free(pool, handle);
-}
-
-static void *zs_zpool_obj_read_begin(void *pool, unsigned long handle,
-				     void *local_copy)
-{
-	return zs_obj_read_begin(pool, handle, local_copy);
-}
-
-static void zs_zpool_obj_read_end(void *pool, unsigned long handle,
-				  void *handle_mem)
-{
-	zs_obj_read_end(pool, handle, handle_mem);
-}
-
-static void zs_zpool_obj_write(void *pool, unsigned long handle,
-			       void *handle_mem, size_t mem_len)
-{
-	zs_obj_write(pool, handle, handle_mem, mem_len);
-}
-
-static u64 zs_zpool_total_pages(void *pool)
-{
-	return zs_get_total_pages(pool);
-}
-
-static struct zpool_driver zs_zpool_driver = {
-	.type =			  "zsmalloc",
-	.owner =		  THIS_MODULE,
-	.create =		  zs_zpool_create,
-	.destroy =		  zs_zpool_destroy,
-	.malloc =		  zs_zpool_malloc,
-	.free =			  zs_zpool_free,
-	.obj_read_begin =	  zs_zpool_obj_read_begin,
-	.obj_read_end  =	  zs_zpool_obj_read_end,
-	.obj_write =		  zs_zpool_obj_write,
-	.total_pages =		  zs_zpool_total_pages,
-};
-
-MODULE_ALIAS("zpool-zsmalloc");
-#endif /* CONFIG_ZPOOL */
-
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
@@ -2248,9 +2175,6 @@ static int __init zs_init(void)
 {
 	int rc __maybe_unused;
 
-#ifdef CONFIG_ZPOOL
-	zpool_register_driver(&zs_zpool_driver);
-#endif
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
 	if (rc)
@@ -2262,9 +2186,6 @@ static int __init zs_init(void)
 
 static void __exit zs_exit(void)
 {
-#ifdef CONFIG_ZPOOL
-	zpool_unregister_driver(&zs_zpool_driver);
-#endif
 #ifdef CONFIG_COMPACTION
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
diff --git a/tools/testing/selftests/zram/README b/tools/testing/selftests/zram/README
index 110b34834a6f..82921c75681c 100644
--- a/tools/testing/selftests/zram/README
+++ b/tools/testing/selftests/zram/README
@@ -14,7 +14,6 @@ Statistics for individual zram devices are exported through sysfs nodes at
 Kconfig required:
 CONFIG_ZRAM=y
 CONFIG_CRYPTO_LZ4=y
-CONFIG_ZPOOL=y
 CONFIG_ZSMALLOC=y
 
 ZRAM Testcases
-- 
2.51.0


