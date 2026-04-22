Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 676A5FA1FE3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2EE6B0088; Wed, 22 Apr 2026 14:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52FD6B008A; Wed, 22 Apr 2026 14:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42446B008C; Wed, 22 Apr 2026 14:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A26636B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:43:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5041A1402D3
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:43:51 +0000 (UTC)
X-FDA: 84687065862.04.9120941
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id B3AA71A000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:43:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xuhhYAoo;
	spf=none (imf19.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776883429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C/jQBvGSN/vL5SCJRxulNknlRj6DDvMi3AO/4NCyTu4=;
	b=fuyDc8Rm0V5NDR5osl5T7bzddQsyjZbtJSPK0FOB1rBZk9PclYqT3n+JiKNDU3XfGpQYeU
	ehHOSjarylwkOIT/NJ6qrofppWQYv888B96tQB5ELv5v/adxcdNqKKmnVqDB/hoNsWJkmY
	ELGSH2t4o5PYftZ4KUjCwxts1WEK0oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776883429; a=rsa-sha256;
	cv=none;
	b=NPnsrla6K2ICI5MA64KiU2OEgnkIXnHfOrmKqFGtMzFXHM/b/CO/d3WY3jV4RMQ534XR19
	MXHsXOkaV7hdD4SF17oJhy76DbDd9XqGlcA4tLihfVgfydaB8uDjXS15VcdMHmA0pq4UOn
	1ymvRdiDIwZhmehHbEbYtABkIgDL0z0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xuhhYAoo;
	spf=none (imf19.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=C/jQBvGSN/vL5SCJRxulNknlRj6DDvMi3AO/4NCyTu4=; b=xuhhYAoocSea3Gfx/5cA4GB4Vr
	s5Iiu+GUrsd9ENMMlrWyYcGNWYzGgfI+P6CnYkiCsLfq6IIHuBdO4nVbug4ls1+aUBNryJ2Zq9FyB
	UEe82SBaXKQ0RvQPyRCb318zGXahA8VvFAD22hvJcVEKlc3yqXpZrJ2tKi7J0isubWiaxKur2XiKA
	+inFo3SJee8EiU/ZT0Wp68+u8CDFxzfrHAvKT90nbsfgO0Ko1xSJ+S+tFZCPRhn2HPZtaAy3mjuRK
	B9m7ar+Nm07r1x5R1rt+jCcmDkNvm338dCctscrnCjjQOBy4YHgvFsvGsHXkweprpKWx/yfLX+A3+
	XCicJwqA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFcY6-0000000AdmY-1Xsv;
	Wed, 22 Apr 2026 18:43:46 +0000
From: "Liam R. Howlett" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH] MAINTAINERS: Update email address
Date: Wed, 22 Apr 2026 14:43:10 -0400
Message-ID: <20260422184310.2682901-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3AA71A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: trwkb6dm8z97fgz7u8ok1it1owdpnb7b
X-Rspam-User: 
X-HE-Tag: 1776883428-177663
X-HE-Meta: U2FsdGVkX18eiUwZBd0K1jhgMJsmBjbh8E517hPRpDB1xAB2cWUHTrxUjP1C5ffTm1DFFNCrYFg4WkwtOBO/qvQd4/5ggRgumVIfqwi0gOEHdCEJhyuUPHSjdL6PE2MhLN31FC39B5pYbCxD9MksYY3bzWvC5NS2spigtHOVWrKfjYgZWeQQOr+qHFfn1NYcDvE0Wy6ElKHvL6ktOjVeS1gkfHdqlPFbaweGPghaYOEHiw6i+Qm+fpDaAViKURHBtkPpugywUdP5JA+9IhlRUO9236jaZH1ISCmM9io6PB/Rpim9oWd7lSC/tEz32s8M7p9d800HFPIA6SsFkGaIWLL7j9p1FevHv/8gnBjH6r2vQOOrWW8Rak0oH7PsKxQajj2pe2TvR2/mDlFzWHx67yECEXmvnhttNtxtfF8cy0M0agc7a4z1yl9UV6A0XTptf7zFzq8zQkPQnt6uBIuWtRFHKF78CtQjZqLO2YM03eDNLVIqXCZ5KG8FA7WgdzG3o8dt+aJr2j6LxeniKV4+IkuCMqdKPkJ5hJl2gxX1VqJmjLn6YwD4YnJyP26JzqywyQZPdMYIgCOqF93CtehlX0xpoQmA4WUIiZ9W9TO13BW8y8QLqCniXXjrm0Tf28ohAbNUTlVwN6q7yrGNJJ2T4VIvtLC98xHpSqSKkivj8p3wEo+ggvEnA8Ng/EYHW6aTMebp8FiY9/yHXNAVdqsc8v5Tkcxx0tv1zbBadLSoH7GtnXGGAij4D+qsBQMdKV2RHsqfejNl8GnsO8UDislvLVmVBKGkdAjG4/fbRE934kZ+PFlAlQk4hBqBe05/WkfsjyS+HbzscHEzePbPBW8RzGn0M40lCg/RYd5vjU+8NHtMc+cK30uEWibtS+roDyOYqstdE5PrdIkbTAlQb7tWgrbrTGJe8dCE18Lw9BRkbvYurU+IDBbMa3EsooPrv8J/zpDpN6NMEsTHp0146Jt
 dJw0j2wJ
 pIJAChKIQrEcRt0vE7oE3ztMGKNwFocsaEQhkX4JRtS1+iwfi7Shq+l46mnxhrV9qc+Sxy4o3K9MQCdjNq6SDe6+JLyJATE9WgJIMWOVOEYzMKx9GlQ3J2Zdh3xEd9cQP7TVdttBxUIe3HekS0XxXRnW5pUFwA3xu1sFN4+examlQYnr6+xia//OefPOJWOZXLdHyczz20pdjkFRgGj6z8qWtqHmBOcs4Z6S+LwYrw8UMD2M7l/FKXA7jnoCgfFKI9lKj7hprtnjrJvkespJIWkotHgNWf0R4vhGzjPHu5OOiQyEhen5lAQ6ktX+H5JPy0S45m+MpVjfzn8/fFOblEEMsN8e20vHlYdcm41u9dMuga1lZGbYI/V9+Axzo8TZ+0+cqpBSIxdxunRZKbkmy6FFZbpooDE6KD0ZfTe4/4t3EGx/tvCf2vlajJPg6AJhJrcqC3Zlp4e8VJFw45XHR0b8GqTcT6zmVZ+yk0vpW3haamDdKGTs/lnrm+YMyQrCb4lFG90090IQFlUPd+/p64onyA1mJ6aDMD/uHwV9p2GWuOcoCohXph0Z1tGbfuP6U9DX0fUcOnHHIlmB1MWdcNZKix9FUYC6z9VOOyJzDUoUARMP/jdhObar3TP+sn+Xz6zpBKe9vUY9ZQA2zJwAviUnfJZzpizBiV1vI52M6eV3VCcYZ4vP4+KIe2WdeUAT3pLyzIdl22ZrpkPG+7h14g7sE5SuCrpfV9YmYILf9ekJmcx72URLvN9Hq3nN40ZqhbENYNvCyC7Ztc88ywZqvSSPYkvSQmzG0/Hybn/G9y08wW5RP92qX2zVf7W161472urc44iqe0ZzOtddbAoCZJV7tPpmWXAKa2z5vQjuMoMxMTkZrVmv77fkj3WNZdloER83rtW1j2GKd2cGk1G+fugryA/VrJ7/bBnV8tJ0xQYV7dY22vWIPtHBHKAhRoYj5BLhFr4im5+eFO9zniQXncGdFbCMB
 VogSoCSO
 7YFjbyOAWgjmSbJ1v/a5lfh9DKQABT39M1zRIgYcNG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switching to private email address.  Update all contact information

Add an entry to mailmap at the same time.

Signed-off-by: Liam R. Howlett <liam@infradead.org>
---
 .mailmap                         |  1 +
 MAINTAINERS                      | 20 ++++++++++----------
 include/linux/maple_tree.h       |  2 +-
 lib/maple_tree.c                 |  2 +-
 lib/test_maple_tree.c            |  4 ++--
 tools/testing/radix-tree/maple.c |  2 +-
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/.mailmap b/.mailmap
index 4cdb7986fa43..8f3d4dd29da7 100644
--- a/.mailmap
+++ b/.mailmap
@@ -494,6 +494,7 @@ Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
 Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
 Leo Yan <leo.yan@linux.dev> <leo.yan@linaro.org>
+Liam R. Howlett <liam@infradead.org> <Liam.Howlett@oracle.com>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
diff --git a/MAINTAINERS b/MAINTAINERS
index 76d8291237be..45be574f5a5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15397,7 +15397,7 @@ F:	include/net/netns/mctp.h
 F:	net/mctp/
 
 MAPLE TREE
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 R:	Alice Ryhl <aliceryhl@google.com>
 R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
@@ -16757,7 +16757,7 @@ MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16893,7 +16893,7 @@ MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16994,7 +16994,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17041,7 +17041,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
@@ -17079,7 +17079,7 @@ F:	tools/testing/selftests/mm/uffd-*.[ch]
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
@@ -17093,7 +17093,7 @@ F:	rust/kernel/page.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17125,7 +17125,7 @@ F:	tools/testing/vma/
 MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -17140,7 +17140,7 @@ F:	mm/mmap_lock.c
 
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
@@ -23385,7 +23385,7 @@ RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 0c464eade1d6..4a5631906aff 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -4,7 +4,7 @@
 /*
  * Maple Tree - An RCU-safe adaptive tree for storing ranges
  * Copyright (c) 2018-2022 Oracle
- * Authors:     Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Authors:     Liam R. Howlett <liam@infradead.org>
  *              Matthew Wilcox <willy@infradead.org>
  */
 
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d18d7ed9ab67..60ae5e6fc1ee 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2,7 +2,7 @@
 /*
  * Maple Tree implementation
  * Copyright (c) 2018-2022 Oracle Corporation
- * Authors: Liam R. Howlett <Liam.Howlett@oracle.com>
+ * Authors: Liam R. Howlett <liam@infradead.org>
  *	    Matthew Wilcox <willy@infradead.org>
  * Copyright (c) 2023 ByteDance
  * Author: Peng Zhang <zhangpeng.00@bytedance.com>
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 434d8a2fdd99..b9367c61e8b5 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2,7 +2,7 @@
 /*
  * test_maple_tree.c: Test the maple tree API
  * Copyright (c) 2018-2022 Oracle Corporation
- * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Author: Liam R. Howlett <liam@infradead.org>
  *
  * Any tests that only require the interface of the tree.
  */
@@ -4021,6 +4021,6 @@ static void __exit maple_tree_harvest(void)
 
 module_init(maple_tree_seed);
 module_exit(maple_tree_harvest);
-MODULE_AUTHOR("Liam R. Howlett <Liam.Howlett@Oracle.com>");
+MODULE_AUTHOR("Liam R. Howlett <liam@infradead.org>");
 MODULE_DESCRIPTION("maple tree API test module");
 MODULE_LICENSE("GPL");
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index feedd5ab7058..0607913a3022 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -2,7 +2,7 @@
 /*
  * maple_tree.c: Userspace testing for maple tree test-suite
  * Copyright (c) 2018-2022 Oracle Corporation
- * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Author: Liam R. Howlett <liam@infradead.org>
  *
  * Any tests that require internal knowledge of the tree or threads and other
  * difficult to handle in kernel tests.
-- 
2.47.3


