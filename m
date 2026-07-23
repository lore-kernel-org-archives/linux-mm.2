Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6104C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B454C6B00F8; Thu, 23 Jul 2026 03:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C796B00FB; Thu, 23 Jul 2026 03:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BC46B00FD; Thu, 23 Jul 2026 03:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 668EE6B00F8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:49:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1E111603DD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:44 +0000 (UTC)
X-FDA: 85019267088.07.2241DC1
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F455120009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8AILtv1;
	spf=pass (imf29.hostedemail.com: domain of 3lcdhagcKCAYp4kyigymuumrk.iusrot03-ssq1giq.uxm@flex--jyescas.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3lcdhagcKCAYp4kyigymuumrk.iusrot03-ssq1giq.uxm@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxFUoK0o7AOxXwUayK1WHtnxjmfT1NGEks3Fz4KRfjY=;
	b=KdDxhUbg4lERS93KEIwlFYJTwiw8GPON11VJZIWAYnk7zdmzwNNFqVLxRBWxzu+sdJ0DBD
	J9asAYlJMmn1w90xMrLaTk6xop7cJPcstN71u4l7G5MgFH71WbAT6UM0bfkpDF9PNEULHc
	FL/amgQYegy5GIwuxA5jdAN5miWBBuk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8AILtv1;
	spf=pass (imf29.hostedemail.com: domain of 3lcdhagcKCAYp4kyigymuumrk.iusrot03-ssq1giq.uxm@flex--jyescas.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3lcdhagcKCAYp4kyigymuumrk.iusrot03-ssq1giq.uxm@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792983;
	b=MViLnP1CQZN4X30AIjAkA9zgzFHNi893jm+z/FMqKfUuOqYMYnUKK+0V0KR75Vs627jESs
	Jo0tMmD1tLAjPkJxLPuE6VkgDN4DRrG3RO5YpXJrEF2mm4rAzUpgJJ6IWDl4QgCKS9Llt/
	pnuMQSXePQ2E0XX5JrpzhWrQiqVXBIg=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc640dfde3so5459275ad.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792982; x=1785397782; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxFUoK0o7AOxXwUayK1WHtnxjmfT1NGEks3Fz4KRfjY=;
        b=Y8AILtv1soHS9IkPkdoEznlAgIKHgqZLq2ofktGdzpF5fCK/oWSArADWQU6InrZJss
         ZT9Xoj/MoGqL2t/MAAZild0ivLAeWYHcWmF8bwR09tzmrEGVEkv3o18n1x4d0mVUv08O
         e9qYU+lt7tdYPrRIYSBbUyGEL3zoGat2NKx6yvDpkl3s+XPPikwNz2I2mC/qfgd0bo9N
         RgKzW38KvayUvM57aDXTkXIKgxPydzddlre5YhV3hYNkB3bVJKNeSPY8HKkhWz4yKGrr
         iCh9A6JkDCVk+vGzYx+/IY3/KbuGo0t+ZI5gIaBDKjN5YLsOl/zj4MZv4FwSQSsBIYnG
         NLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792982; x=1785397782;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CxFUoK0o7AOxXwUayK1WHtnxjmfT1NGEks3Fz4KRfjY=;
        b=AhShfl/DlGmMClp0qHnQJFr1fN5xvRKcU1Zc5aaV0dRZwU/nw7lBYh7WNVu+F7iF3A
         44O/Sawa6xVcycBDVZanlunlxsae9rWI9f3h7mMbZ7EJk4LRA4cyGO3Iih+5Uvo0+cEH
         0Sz8eWJfPhzTx2BqpJ9poeJ9f2WFTFGqjm24NB+8m52229oRKquQy0jotZBflKXsDb/R
         IUdQdBlrUD+B1wJOI4x1ryW8CPjYEsKNhLuYPgDg5wktkoctzCDceT2IJN4EzcSZimxE
         5+4PT5gvwBsjFX08JysS7+SMyb0fOfXmwDQMwxWRajux0E1IaQjeWNUA3KWfbpD6iqnC
         gs4g==
X-Forwarded-Encrypted: i=1; AHgh+RrxjuOd36P/8XEo+p2lnLkieLiTe/lDeRZvK0+Alyv3EwpYWiZAM1WvQnjaJsQcj5s2Wic6WK1www==@kvack.org
X-Gm-Message-State: AOJu0Yz0VWmKUIPmpPRYYVTM8BvNLBxYktFCxdXz0E6gJ9/Cx5ZSnW2g
	hdGHRNSlm7ivkK2BZS9tkImk1hjI6mfDshbpb1OMI70cwdPn/gTxkrsmXJe5suw/HrhEY1t82+r
	8iAYlgOCnOA==
X-Received: from dldyr4-n2.prod.google.com ([2002:a05:701b:4504:20b0:13b:882c:fd28])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c12:b0:387:e0db:bc34
 with SMTP id 98e67ed59e1d1-38ec688a747mr1713501a91.42.1784792981876; Thu, 23
 Jul 2026 00:49:41 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:07 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-4-jyescas@google.com>
Subject: [RFC PATCH 03/16] mm: Define the caches for the structs req_alloc and page_alloc
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F455120009
X-Stat-Signature: isngxkia3xh6roct3kkutdsnw8c86wg1
X-HE-Tag: 1784792983-154218
X-HE-Meta: U2FsdGVkX1/2m8rfVkqidQMoa4TFMiv35HGgRWPT+cSBj3Ek0b2Oa0sciM7IlyCbDgZ2VzLbFHapb2e/bsEUP9MXG5qr0HuDGGvp3Zd7MUf9KAvqfuuCqvemCk1UK93lr3Ylnab7J5RbNCpEccIf//QYA6IoZaMkHqil67eCvtZJdWYfpF4hCobdYAfIcrcAhvvm/jw4xqkjX8O0CZYmCzeXKMKyrhwsr+NpM/7xJa3JV2lIVJd2StayXinRjdaEPGeGT/ug5f/u/09HpQizzVszBcl6aanemGnC7wLVNDHljbiuaQPuWWzotJlg8H3WZhU/k0wNL9IpuTBcnF/tuyyITwZLv04KfOS6eZkEUIUCtr2NZZpIR3KAhsZSDuU2qUVlVBLWXwVGdhMbtZAA00AHwi7/jYraAzAlaoK7VgF02AJmLQBA9D6aTwgUN9DrjeZx4GK99Tnf6esfDLPuayC3xiQ3kGOtf+NLiIB1sJCJ9tHZ0eV45b8Z033/ZbCDJXogBZnnDeZZSZjxDpBSsrZMi2w37eT1w5aOGzeyFnPSEjk4fFzZBwbVO2K1LYI5Fa/HmRvw31b/ocA3D1qJCKU43zw4hiDVETiweEtXI3NhzE8PMrYtUX4ZwYpmRhLN7ZsNK8O4Cs+sUfRPQ/xUFNaar5NxnW7c7kMr2kFkPoloMlBaOM6Pl2rxXBWHPR6P3CYwTkzBiFozNp2rp9bdl3jvkJHwHxKGhT9ZTYGT1ZCO9rsY9FQisCbS4CHIVSH1i443zaxHDP0ehpfKsoaUDEgsusy+70Y/sYWo1qSs9hgXhZs9fCRT7brocMbs+AJaJA/9EoS9PaQkODuP0MVmLJDMEVFELVgG0b5c4d5m9GX8haUbNtp+dSOIUNtVuYT+DspDaaQZpqW17wT9rfXrdj9P9YOz9upDP4/MsJJUPz1hl9TtkGJsI2wZQSc9NYWbDj8pjPwggqaB1wiZyiV
 W6anMofk
 GU0W0HzB/O4qlkv9d4+CHi7ynYYT/oZ9RkNVDQ2BjlyADxz6jbFRXQ2yjmTxcNjOCWUl7gAPxXQUMg+90DUzwg7j72DNjqpfOE4T6pHznURDacFjvhXPGCa3lTj/fFH/8pmslmi9eYTJHlhl0a1M1ZQmDsJhERpen/UjIg7YCYTN67n88UbS0x+MZT1I0uxwVt7uZQTgaAu4731T0WQjK3mNPzMqqKaMi9TS0u4kfjcb4/Hvmorsue4QGlDSlmvJDMYVLlSNykuyL2LclIW8D7iQkLu0tY2CpJ+mlO7FuyroSrKpUelf0i5v6x8JFy6u471282DmIfuF6dGO3G7jvIQSh7a3xSrqwaFfS4i54jp1iqyW73+niQTuzY+ZHKbiNsiNcvnjlMAnR8WFwxkjm/GBO2886ldj7DpCg7d8HzZUkWkmHtRJd12/9WwkBSwoHjOexCGgEyAQPeZLJoa2KA6tYXWKz8A/3cHdt7d2ni9xCk2jznXyFZam8QG0Ri6KzkOP3UnJ+ypQh7tyXXBS9jkx7DJLsk5ZPLz/WGCXwiGkPF/J+OzPq+TWtIG7nTWpt7Bjnpt+2lG+kVLHrxaJLj524Qc59gzFI3NSCW4H6RL4yFLnlizADaEnT1IWnqJe8LU/f0BEYDcQSJAZfM2TK+tZqOoNWCHg8q8d8QKjlIJDIRGuHesF1KVn+PnHkTWWrmb98Kh2bxRRvb2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change defines and initializes the caches for the structs req_alloc
and page_alloc.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 47b08d056978..52ccc6e99eb5 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -85,9 +85,12 @@
 
 #include <linux/errno.h>
 #include <linux/debugfs.h>
+#include <linux/gfp.h>
+#include <linux/gfp_types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 
 struct dentry *mmdir;
 
@@ -119,20 +122,55 @@ struct page_alloc {
 	struct dentry *alloc_dentry;
 };
 
+struct kmem_cache *req_alloc_cache;
+struct kmem_cache *page_alloc_cache;
+
 static int __init page_alloc_hogger_debugfs_init(void)
 {
+	int ret;
+
+	req_alloc_cache = kmem_cache_create(
+		"req_alloc_cache", sizeof(struct req_alloc), 0,
+		SLAB_HWCACHE_ALIGN, NULL);
+	if (!req_alloc_cache) {
+		pr_err("The req_alloc_cache couldn't be created");
+		ret = -ENOMEM;
+		goto error_exit;
+	}
+
+	page_alloc_cache = kmem_cache_create(
+		"page_alloc_cache", sizeof(struct page_alloc), 0,
+		SLAB_HWCACHE_ALIGN, NULL);
+	if (!page_alloc_cache) {
+		pr_err("The page_alloc_cache couldn't be created");
+		ret = -ENOMEM;
+		goto clean_req_alloc_cache;
+	}
+
 	mmdir = debugfs_create_dir("mm", NULL);
 	if (IS_ERR(mmdir)) {
 		pr_err("Unable to create mm directory");
-		return PTR_ERR(mmdir);
+		ret = PTR_ERR(mmdir);
+		goto clean_page_alloc_cache;
 	}
 
 	return 0;
-}
 
+
+clean_page_alloc_cache:
+	kmem_cache_destroy(page_alloc_cache);
+
+clean_req_alloc_cache:
+	kmem_cache_destroy(req_alloc_cache);
+
+error_exit:
+	return ret;
+}
 static void __exit page_alloc_hogger_debugfs_exit(void)
 {
 	debugfs_remove_recursive(mmdir);
+	kmem_cache_destroy(req_alloc_cache);
+	kmem_cache_destroy(page_alloc_cache);
 }
 
 module_init(page_alloc_hogger_debugfs_init);
-- 
2.55.0.229.g6434b31f56-goog


