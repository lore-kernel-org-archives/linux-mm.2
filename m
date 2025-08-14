Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23B6CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCD2900146; Thu, 14 Aug 2025 07:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C8F900121; Thu, 14 Aug 2025 07:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C94900146; Thu, 14 Aug 2025 07:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52CED900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 720D659D79
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:38 +0000 (UTC)
X-FDA: 83775168036.06.1E4E325
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9799BC0015
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAxzN47x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171576; a=rsa-sha256;
	cv=none;
	b=SnHTk5H/lV18KZuvzIwOlAIvGZj7I959wrFNlzxbrfmCx89PWjARJsZYVlxJTwp/2QUcbr
	DQpsppO9yv8Fo1bLwWPDF29Pg/QU1G66s2ZVae2kOse2P9pcqaCv56/q4fwweywxOuv1QB
	BKivyUJWZH6WJTfnQUHfPLHyLwb9Xo8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAxzN47x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNuHZOu4rJp5ydgKv6yBABXB4uRFEE0hKx+JLsxn4GU=;
	b=CH9b8U/qYfNpNm8zYBYbNy9SWb3F3lMi43b2HgKLJhGdIgymhnXrWws4ESN+R+Nf4JuZBs
	hkNP/6qJrJ/i+z+uRS9zhsWPy+REKsSauq4Db1/4BfmejnIBLSDt4wMGzXenC8SYdovrhT
	pqOSE9Tz7QD3D1wieJxqR0pKV43b5B8=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24457f3edd4so5823305ad.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171575; x=1755776375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNuHZOu4rJp5ydgKv6yBABXB4uRFEE0hKx+JLsxn4GU=;
        b=mAxzN47xYTI/4gM5WZvqNAxj5zRDeWzWHFE2LxKMPXgeAf1t1ocxVyEd7ZaLbt/2wx
         kLUR2Hz5hE26sbNfTsdGGlVM33TdoQwCWzUuscHtadCdse3eoiUDcXpnWDNouxd8Hzx3
         bKYfDHJcsHSK0BeJjCf9P4Xq3/FRjg65ae/lMAdzDUSJkKBdLv0NF2PzDeDucw0asCEA
         5nuuK1ofE7ZRNoTIPPk1aQLaKJ5h9/cAeDUo7j5khGLGXIwilD5FCdzIzyA0EJ4iBlMs
         8Dria7Y0m2ZD1QXrmw88T//3XeVsGknLEwwOTGqUUeLgBawKhSnTZld2b2h2y8KGfSu+
         gcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171575; x=1755776375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNuHZOu4rJp5ydgKv6yBABXB4uRFEE0hKx+JLsxn4GU=;
        b=Zw8rV9rbKWxS9wrfZkqm3AluInYMW+GGomJHXmcQ7s//JEaC+KBEoRl1XSHv/hkfc/
         rmHbvCP5E7fxqukUB/BeTv5saE523E0hadMD6/9EaptzXwtY4PXzCXzFE3Ri6Q/eNi1J
         4BU293hG1RwaALZo1P1s9VrFUH4udRJU8sNfedyQf2R8WFkHKMA1buOkrKAfHLHtLn3v
         0XWtQgawEqcM8e86P2DRVE/YC+7lbqJu/dhlMrjPzdj09OHqkoObM1OZbxmnTAmnh6UO
         i3fgshMu1Adpzb+YLdZEkLTu9UxIimMD6R0glCHrktrnaiuJxGRz7fhRFyPZajYC/oh8
         FSaQ==
X-Gm-Message-State: AOJu0Yzqje7QQA0kR3wFg882cv3do1qVIyo915EnTa4pw+E1a4XS/s3t
	j1hB7yD4aylUtw5DeRV6P2Bs6CzxbCxdFXSx2sH/PWktXxm4rcZZ040k
X-Gm-Gg: ASbGncumQGe+M+KSJcVzDWWXP9fCf7IdWT4cJUPRVhd1WDBB72hSiAv2SQI3EIzhRCr
	zGCuUwoGErtUFs6yd1r+deAtJbMdE8B0J86RoHQ6erkAd6PnHohD9eR6djd/qexUqBV1F8jh4fy
	6tybQIYH0+sWl5pGmEJ2mUapd35Feq4hRaEV+KhmwI1bR6fv0wizpnbWHP3qQIhz+DSAE6aByhR
	5OIRu0vTTcQtUuDYYOUSTykO09A2lSKEyy16YPcMApiHMaIpBcArFyaUx2j97woxXZ9UZoPgEIh
	tMYBvAKGinwk9dPgnrdXc01Iczalpa8rTZPqy4dPUWL8dOuKTDkud/FomT28zugcnT2YSmOHHk0
	NctQ+NdUaVNVtAfjqTjmCm8R0QG0=
X-Google-Smtp-Source: AGHT+IFsKgNUwOvyog40PfGpaCEvYG2txTVMQ6blgY5tFnvSw46elh2c9XkcDpn2yNrj6B/iK38/AQ==
X-Received: by 2002:a17:903:138a:b0:240:4d19:8797 with SMTP id d9443c01a7336-24458a50a4amr46327525ad.22.1755171575402;
        Thu, 14 Aug 2025 04:39:35 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:34 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 3/7] mm: memory: add kmsan_copy_pages_meta function
Date: Thu, 14 Aug 2025 19:38:09 +0800
Message-ID: <20250814113813.4533-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9799BC0015
X-Stat-Signature: oygd1q4bchkzykms4pq4kojno6ichtoo
X-HE-Tag: 1755171576-640827
X-HE-Meta: U2FsdGVkX1///hVQCV+V1aB4ItpFZ3E0cpr3nmrcnGS035dBYIsv4j9bKUgMa3F9HT2KX/hRWwZkM0S/uFAi/jkiyTu2ZfoWYVhC7yXPWQDsMK0NC9kP3s8a2iF/hzR4A2mGNQcHk3RALkIFyMCnjG6FbYm4pdPh2hWzMRVfFHI8KMrMiAOgJ7ljjr0PdzmVNhbOkK9nu379WsUXAi8iP0OfCDp2uWL4E5tkGrS/dh6AKDEGfATDe9RTr49O85Hvj+8o5+tXj4hjE6EtOMqj8op58t1l1q2ab4KregV147bUVIxuuSo7shw5IlVt1wCPUSYwi+tMxv9z5Q/F7KgmLd8oCjw/ggrtIkFyNLVRiE2pzQYQJ2sPX3hYwhdIQ1gBXJzfb63l2xjYXbu1zYdIBnyyMQfh0Eu2Pmy3ONsl0nTDk3H6gZAoF+zsKrG+WmtlWcK3R9YmS8iBGdGuUsIqg2J2LcqFSuZT7SPpttt2KZHAVUaAR9Y2Ja9IHMI1WigMSjUVy5Y9+bSm1WA4dO09/Xej/8Oewfl3IHdTbhOLEoab/PfI6rVCd3NHPglfzrpcv6TFDMbyx6jbDFjALRkw+SGcyHvBSBS1hxD2hBlFWb4rbA0bqGd9zt1J/5YWxWJIXXf9cyG+epq1qR4Y6QU+mZ89efBmKlFuCpLEyQiM8gRPXaBgAsNVB8K58etNR+ixLjYDLqcPZUs1eQxPNClWAuPXBP0XUQtOewU1LRUq1danClH+Kj56JPHezxq5gMxq9aAF5xC9GUvHb+Wq/hn9MIZ+lpnccKOMQrYOVR4HJkEoyY3MuX+gzjWvtfBI1L/UgWC++RVymrKoVZWTjAPL45Kp6S6GU12QeFsJf873HsuHiqGK2P5aJcnSEHhT2cJSgUYG0jskz6d+U616YmOQLiPyr2b0P4lu+KPYnHNTekPF4kQdJLQA3OrfumUmGeNODZj//BT5OUKohP+d/H8
 St5A2iJN
 b5x0bEyBJgdoeFEFO5RtpUgSeHmU6uOjPOJAKkfImWEgRWSwdXIkR6Zda0FGP1Y8i0dsDgc2cLQ7K0gP6GDGEWDCFtrZLbUxrfamOYA+7kIBtJ4LBj0aO0n8IDziHX0Z608EIyXyOq4OaL4bNDV+ZWTZGFVt4Wc53GZNQLCelJC9YcEXMytEhNq+U2MTi+cckgealHO8GEKKy+gpLnafKqrvvmrbx57jFc1DIf3Xs2Xi5kzqRKI+92NzyyXkiXvokkeEvluXSX15rXzL/anQzO37HgiHGuOX6YnfbATBoYD/u54kVkIV66LdAYJkGxGVU3Fsuverc4Pz2pWnhypX4bwhQhE9ZlcvzbebDxMEzvqJM3dypCs/FRUQICCI7K33VPQl/ANTLJZLYf5+ekQWR5nvg8S2pQtNfUpxhISAO3KsLNZoY//2gPD1b1qp46mNmG8Vo9KHSLtKzLePmd4vOhwXNOSPvTBp2+q1pxIm7iAy/e/ibMC6G+rwHOCyDOWGd8Ffp6sM1JEZ1In9Db32ysboELNv7IJ0kYbYZsGuwAFvLrrdxLZ5qSYD4PWhzoL/po/bFPaaiajfIRoM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for wp to support mthp, add the kmsan_copy_pages_meta()
function to copy multiple pages of the source page to the target page.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/kmsan.h | 13 ++++++++++---
 mm/kmsan/shadow.c     | 26 +++++++++++++++++++-------
 mm/memory.c           |  2 +-
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 2b1432cc16d5..a3f227c3947f 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -78,15 +78,16 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags);
 void kmsan_free_page(struct page *page, unsigned int order);
 
 /**
- * kmsan_copy_page_meta() - Copy KMSAN metadata between two pages.
+ * kmsan_copy_pages_meta() - Copy KMSAN metadata between two pages.
  * @dst: destination page.
  * @src: source page.
+ * @nr_pages: copy number of page.
  *
  * KMSAN copies the contents of metadata pages for @src into the metadata pages
  * for @dst. If @dst has no associated metadata pages, nothing happens.
  * If @src has no associated metadata pages, @dst metadata pages are unpoisoned.
  */
-void kmsan_copy_page_meta(struct page *dst, struct page *src);
+void kmsan_copy_pages_meta(struct page *dst, struct page *src, int nr_pages);
 
 /**
  * kmsan_slab_alloc() - Notify KMSAN about a slab allocation.
@@ -324,7 +325,8 @@ static inline void kmsan_free_page(struct page *page, unsigned int order)
 {
 }
 
-static inline void kmsan_copy_page_meta(struct page *dst, struct page *src)
+static inline void kmsan_copy_pages_meta(struct page *dst, struct page *src,
+					int nr_pages)
 {
 }
 
@@ -407,4 +409,9 @@ static inline void *memset_no_sanitize_memory(void *s, int c, size_t n)
 
 #endif
 
+static inline void kmsan_copy_page_meta(struct page *dst, struct page *src)
+{
+	kmsan_copy_pages_meta(dst, src, 1);
+}
+
 #endif /* _LINUX_KMSAN_H */
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 54f3c3c962f0..1dd0f7a1eb5f 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -148,24 +148,36 @@ void *kmsan_get_metadata(void *address, bool is_origin)
 	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
 }
 
-void kmsan_copy_page_meta(struct page *dst, struct page *src)
+
+void kmsan_copy_pages_meta(struct page *dst, struct page *src, int nr_pages)
 {
+	int i;
+
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
-	if (!dst || !page_has_metadata(dst))
+
+	for (i = 0; i < nr_pages; i++) {
+		if (!dst || !page_has_metadata(dst))
+			break;
+		if (!src || !page_has_metadata(src))
+			break;
+	}
+
+	if (i == 0 && !dst) {
 		return;
-	if (!src || !page_has_metadata(src)) {
-		kmsan_internal_unpoison_memory(page_address(dst), PAGE_SIZE,
+	} else if (i < nr_pages) {
+		kmsan_internal_unpoison_memory(page_address(dst),
+					       nr_pages * PAGE_SIZE,
 					       /*checked*/ false);
 		return;
 	}
 
 	kmsan_enter_runtime();
-	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), PAGE_SIZE);
-	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
+	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), nr_pages * PAGE_SIZE);
+	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), nr_pages * PAGE_SIZE);
 	kmsan_leave_runtime();
 }
-EXPORT_SYMBOL(kmsan_copy_page_meta);
+EXPORT_SYMBOL(kmsan_copy_pages_meta);
 
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 90cbed5ad150..7b8c7d0f9ff4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3589,7 +3589,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			delayacct_wpcopy_end();
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
-		kmsan_copy_page_meta(&new_folio->page, vmf->page);
+		kmsan_copy_pages_meta(&new_folio->page, vmf->page, 1);
 	}
 
 	__folio_mark_uptodate(new_folio);
-- 
2.50.1


