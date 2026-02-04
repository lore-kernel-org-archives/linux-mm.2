Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B9BEA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F9C6B0005; Wed,  4 Feb 2026 16:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCC26B0088; Wed,  4 Feb 2026 16:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBA56B008A; Wed,  4 Feb 2026 16:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15DA66B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:32:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFD731A02E7
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:32:12 +0000 (UTC)
X-FDA: 84408072504.26.ECA9214
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	by imf09.hostedemail.com (Postfix) with ESMTP id 909CF14000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:32:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=fail (imf09.hostedemail.com: domain of tim.bird@sony.com does not designate 35.89.44.37 as permitted sender) smtp.mailfrom=tim.bird@sony.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=sony.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770240730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ibfByY8iQK9Y3JqCrajSiNIKhKDR1x5uCu5uqTcP8Po=;
	b=al7upjmnEdZ4gVaSUsxuQ8YmwToHVqtBi8l8h2c6XYPxU569yU81UxkCbDGErSKDWRpdr6
	2HhaDOJr7yLHobsrGCg+zO/kJmNOtLoiJbrO6vDt4ad61lKBUsIwpEikCwzr4IZx6eQff4
	mTIhodyaH4CSJc/dfLg+mcCb/wIiG68=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=fail (imf09.hostedemail.com: domain of tim.bird@sony.com does not designate 35.89.44.37 as permitted sender) smtp.mailfrom=tim.bird@sony.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=sony.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770240730; a=rsa-sha256;
	cv=none;
	b=z/vUDm0xAB76jqPu9EYfrHXd07USSr5bF+Hv4zwzM8P2aD7peuUiEJrlSB9gL2DlIwBKEZ
	D9KyHYgzsJi1L3W6HKpgy9KfJD20lgRKQhtTPb9SHwuktiRewy+hTEeeDfjKv3xPsCyivX
	zPl/KGCPIVNno5GliVddeEh9ztpTEQQ=
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id niGJvc3nHipkCnkTovYF9F; Wed, 04 Feb 2026 21:32:08 +0000
Received: from host2044.hostmonster.com ([67.20.76.238])
	by cmsmtp with ESMTPS
	id nkTnv6GJpHSQMnkTnvstIX; Wed, 04 Feb 2026 21:32:08 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=6983bad8
 a=O1AQXT3IpLm5MaED65xONQ==:117 a=uc9KWs4yn0V/JYYSH7YHpg==:17
 a=HzLeVaNsDn8A:10 a=z6gsHLkEAAAA:8 a=20KFwNOVAAAA:8 a=Xie9NPzdAAAA:8
 a=pwlSjyV6AAAA:8 a=SwvnC8opRPVetA8u2xwA:9 a=vUoOGYJDS1_Kmot3Fv_X:22
 a=J9--6epWBKc4EL46Yp3Y:22 a=iekntanDnrheIxGr1pkv:22
Received: from [66.118.46.62] (port=46610 helo=timdesk..)
	by host2044.hostmonster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <tim.bird@sony.com>)
	id 1vnkTf-000000003WL-3RQZ;
	Wed, 04 Feb 2026 14:31:59 -0700
From: Tim Bird <tim.bird@sony.com>
To: kbusch@kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	aneesh.kumar@kernel.org,
	mike.kravetz@oracle.com,
	peterz@infradead.org,
	akpm@linux-foundation.org,
	riel@surriel.com,
	torvalds@linuxfoundation.org,
	david@kernel.org,
	muchun.sony@linux.dev,
	osalvador@suse.de,
	hughd@google.com,
	will@kernel.org,
	npiggin@gmail.com
Cc: linux-spdx@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Bird <tim.bird@sony.com>
Subject: [PATCH] mm: Add SPDX id lines to some mm source files
Date: Wed,  4 Feb 2026 14:31:01 -0700
Message-ID: <20260204213101.1754183-1-tim.bird@sony.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host2044.hostmonster.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sony.com
X-BWhitelist: no
X-Source-IP: 66.118.46.62
X-Source-L: No
X-Exim-ID: 1vnkTf-000000003WL-3RQZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (timdesk..) [66.118.46.62]:46610
X-Source-Auth: tim@bird.org
X-Email-Count: 4
X-Org: HG=bhshared_hm;ORG=bluehost;
X-Source-Cap: YmlyZG9yZztiaXJkb3JnO2hvc3QyMDQ0Lmhvc3Rtb25zdGVyLmNvbQ==
X-Local-Domain: no
X-CMAE-Envelope: MS4xfCBbe77XgsuVs3klX5fbk0I8Bkz8VIP8VpF1AtrAGry0Mcy3BeMeZSOi3C1d5ddoD4wo8y5rOpBQ8PR9uE/D0A9Anxke7OMo84y704GZVDKR4Bib4z0b
 uubsIuyRo5gbsRYhVal2INaZufAnLnQtkOAONfuXOlSQaRVOpf8momflw2vRID/vQunKDkzIYWQeQKdszaZVtDtsm/ooiWjNDys=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 909CF14000C
X-Stat-Signature: pbgyocijz5e34k3at16ra8km94k767aw
X-Rspam-User: 
X-HE-Tag: 1770240729-627659
X-HE-Meta: U2FsdGVkX18rRjYEfWhYCbgJ5TK4MElv45FWNrLxH9TlKzZyi3SkU479r6YaSeDEbIwSuc0FQSeu60F4WgpXeZxhvj1guaXrPrI6y3iRg3FZRdTapTcimVT4LeQnsylaAzJ5UHUqVXIY8RrdO8sM4eDFj5bLRfoRnqoHId5qYJpA5G8RfRFlMtFSV6P5m0VpZQgcZLBR0lpwqBNx5t0fgkMoXVawhaUY6SWSXTjANTBwzom3/FLNctRoJUX9Xt81eYP8lhxN2phH+k/9OOPcrFlUYwqeRKySavJzIvI7gfy3TaXebKljYh0R3MzYVsp0zWZ91RnY1Bt0lK2FKQri93zfEn36p4pLPE3bcpa5PzZk+JGpJu6CMR31+ugG5G/spL4b1P/djJzFEjAJTpKj+5/ZbOFQoz687N2dUJoZtBG4MgPqNPTuOEAe4JKZPCmJ8XHQWzPVAaNTLxVPGuZ/HzbCC6v8YQ8koEQnvS2jAqYcz5W6ysIO8JYRBfBsTGIkcAb8IqFT7XXCi9G2gjyDsHHDmlrxUL3KDJNc8wYeCR4JTuuu3jDZHBDRpLOnp9NPEp+w63lkhK4P2gGp7QLFAk8PrKNFQ89mfSASPbewgp7MotK1IfepR8YtZqBjYNh9XUvmAufFRo5Wpo9Ov17Peu0zKJySWEZlGaprYEt2DyAeCLKahFVgWLfXOijeIXky3W8q9Pr41tVt4YkmSPTKaGBDf5hQep14H2PUcJWvxGXPS7dKN7IXHG6FEE0tNm/F2GUviyCRSuxc3XqLicxUnYN/vEh+fkshF7/xl8QCWso1x0IKkgTMYF5Ix9gmZdlkcDHBnWkjur8f1JWDvueT8W8sUcEKeO/T38kZxcF7j3OLrJAdbXuwu3eZmRcbkcfQUeK+dR/OHI7ag5PY/B+4Lmqtj7Bxkx1CDnnHdo0Wl8LES6HeQ0EAS5IUAu+s3BC5GYgsv6swS4ioJ+V4/MV
 mwEZQbEg
 IeTp6ZEoV5DhLcEXeJBw0SHlwIA+kVJASJvRKurxWgbROZBJONOE0lOAHaD51okcQVKmUwlcT4XKtuCRi3hOT03h7Mjowb4U2j4dH515tEkCdAQvVm1XIFMLkViiQAxbxFjK3LDFuEkF7cUnQObt8zYeFBUNFIDoag0fctGgA9AVHfx84hoYNaQlm3kiFI9gHvVqYA/8//ZUn1s9wARcBv8IbFJlTLeAaGUShAplrLXMZr7Zq2MblYGM0uYCdG6SONbxdjWjNBii5YwVlxAjnNQ/WxtuB2EkEl4Z7G64PQBGngWY9AO4XfdiZA2FiJx89R2EYV9d5P1JWIPWuA1hdy3Tj/Og/b8xk8JYrfhdapUNo3IJRBx0XHQyaaT87W4gm+BF4kZ9y9KgAUMkb7mo2Ik7HQt+OlM26yqkoy6c/sy+Bx84LmxooYMyQb4FBXjw3kOIp2hMGZKXAzRpFT/hKZS3y88HcIDm2bR8d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some of the memory management source files are missing
SPDX-License-Identifier lines.  Add appropriate IDs
to these files (mostly GPL-2.0, but one LGPL-2.1).

Signed-off-by: Tim Bird <tim.bird@sony.com>
---
 mm/dmapool_test.c   | 1 +
 mm/folio-compat.c   | 1 +
 mm/gup_test.c       | 1 +
 mm/hugetlb_cgroup.c | 9 +--------
 mm/memfd.c          | 3 +--
 mm/mmu_gather.c     | 1 +
 mm/rmap.c           | 2 +-
 mm/shmem.c          | 3 +--
 8 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/dmapool_test.c b/mm/dmapool_test.c
index 54b1fd1ccfbb..e8172d708308 100644
--- a/mm/dmapool_test.c
+++ b/mm/dmapool_test.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/device.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 45540942d148..a02179a0bded 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Compatibility functions which bloat the callers too much to make inline.
  * All of the callers of these functions should be converted to use folios
diff --git a/mm/gup_test.c b/mm/gup_test.c
index eeb3f4d87c51..9dd48db897b9 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 58e895f3899a..0a87cbbeeed9 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  * Copyright IBM Corporation, 2012
@@ -7,14 +8,6 @@
  * Copyright (C) 2019 Red Hat, Inc.
  * Author: Giuseppe Scrivano <gscrivan@redhat.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #include <linux/cgroup.h>
diff --git a/mm/memfd.c b/mm/memfd.c
index ab5312aff14b..8f1f26de92f0 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * memfd_create system call and file sealing support
  *
  * Code was originally included in shmem.c, and broken out to facilitate
  * use by hugetlbfs as well as tmpfs.
- *
- * This file is released under the GPL.
  */
 
 #include <linux/fs.h>
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 247e3f9db6c7..fccba879f056 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..a91282020e77 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1,8 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * mm/rmap.c - physical to virtual reverse mappings
  *
  * Copyright 2001, Rik van Riel <riel@conectiva.com.br>
- * Released under the General Public License (GPL).
  *
  * Simple, low overhead reverse mapping scheme.
  * Please try to keep this thing as modular as possible.
diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..e460f41d26b9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Resizable virtual memory filesystem for Linux.
  *
@@ -17,8 +18,6 @@
  *
  * tiny-shmem:
  * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
- *
- * This file is released under the GPL.
  */
 
 #include <linux/fs.h>
-- 
2.43.0


