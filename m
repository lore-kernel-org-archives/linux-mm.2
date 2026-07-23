Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2659AC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA9F6B00FD; Thu, 23 Jul 2026 03:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292EC6B0100; Thu, 23 Jul 2026 03:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180F86B0101; Thu, 23 Jul 2026 03:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96876B00FD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:49:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D9B01A03EB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:52 +0000 (UTC)
X-FDA: 85019267424.12.7DFC188
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7BDC120005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c2f1Qn7+;
	spf=pass (imf29.hostedemail.com: domain of 3ncdhagcKCA4xCs6qo6u22uzs.q20zw18B-00y9oqy.25u@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ncdhagcKCA4xCs6qo6u22uzs.q20zw18B-00y9oqy.25u@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loRVgN9ulm8PnZhPf0JyRbFqzx4gb/PePxillDVmero=;
	b=QnXmJLY1LLgCJrvg56y44C/gccrpspdRLJ8gVOEdlAQwfcOMUa0VDFwENIUyM6H5jZhVKR
	d9mbxSzmxPXQ8s680nD5DiaWHM2Xm/EWAzqTP525Mc7l1dINxk63UPsGu+1JtWVXk6u5bk
	Rkm+Wi2xg431waO6M9lJiUtzVWJdwzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792990;
	b=gRIJgIEbeMhXy0zVuQN2lQxOygNknzVtUyzXjCEf9PhLI8BEh7vPXlNMQFqTr5xxqAu39Y
	hKSttgzrzT8M7rNusIfbV3Vodtd9+FfuFn7pANDId3zRP+adQtCnLN19SXjwOHZt9XaT6W
	AFBRx41AkywYv3uFD2Qzxt1OCxzC+sg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c2f1Qn7+;
	spf=pass (imf29.hostedemail.com: domain of 3ncdhagcKCA4xCs6qo6u22uzs.q20zw18B-00y9oqy.25u@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ncdhagcKCA4xCs6qo6u22uzs.q20zw18B-00y9oqy.25u@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso647544a12.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792990; x=1785397790; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=loRVgN9ulm8PnZhPf0JyRbFqzx4gb/PePxillDVmero=;
        b=c2f1Qn7+0QTrHi32DJhUn41VEXDCMf2VsUOL5en7E2J8HYbrRg8QjIRX6GRL45RVev
         MjnQ6StO6xqvrp+jZLW5gGDUeM+bS/HeeRXuXTm8GGwwWEFf0T3Wum4447tvTnpHb2HY
         1LHJotOj24r1/pfcD4Ud1hXFiS7Kja8xnAfR9HssQp1khNd6KXNw8r4wX43Zd7bEDLFF
         F7XofLiaH6ylq6v9QQ/mssthmb1kbB7l/MzpQhEOTB1jxSOIlEpNCf8X9m6X3hU+cAQb
         ZoxvqJuX4m+s+YB1UsHMB4IDDfBto4fUdDsW4WAzvXm5Rqrmvqa1W0DrnbGcoXBxDRj/
         T+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792990; x=1785397790;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=loRVgN9ulm8PnZhPf0JyRbFqzx4gb/PePxillDVmero=;
        b=SaAnzO777GaWOyxrbEhkkCCn26NGjLWJEnn9ZzBovSj+/5Dcv6UyE+039X8FBlaVqx
         xY4U55FkrVHV4Cb+vLeNgk2zyqwV5ZApD6QaWtEHeDq1LEXaSidG0TxztQZvOlOLLT8M
         dVUQ0b/A86hc1cfh9sJhhN6lMD60UWzziWQLrtHWXv4vtEcUa6+0qkG+wcaKCtiTcvsJ
         iAKGGWqwaCutCXkvvkh/WPGdxqZ+je2HVbtxNs2CSpoHe1z0ql6HAfkQ9f6okEW6N6uH
         Y+0bJYOu7XShxxME1tvZNbEKU/dDR/y6gPGfvjEHjQPoTQeZYY/oPmo6ReOIKh0qfz+Y
         DMnw==
X-Forwarded-Encrypted: i=1; AHgh+RpdloZjdfkHrf9EYcKcckLo3XcttuzDlG4JjaN9GlQ7dmkui0ukMmswezrI5p6frGiaLOzlzRvL2A==@kvack.org
X-Gm-Message-State: AOJu0Yww7wH7p5tHm25B2oYtNOzJai1Y7RJSgflM7lrk7X8DsaHwk0Q/
	HkyzOVPuKmG9vDpWThHttmNp3+uWfHgPmK71P4Es81hd2VXWu/SPFksJ2WrStMV0LXwIbg6+YRH
	oBqJmDaasCg==
X-Received: from dled5-n2.prod.google.com ([2002:a05:701b:42c5:20b0:139:fea6:ad4])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3994:b0:3c3:bd32:4587
 with SMTP id adf61e73a8af0-3c44b1c86bcmr2158597637.44.1784792989393; Thu, 23
 Jul 2026 00:49:49 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:08 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-5-jyescas@google.com>
Subject: [RFC PATCH 04/16] mm: Define function to create a dir for each online node
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7BDC120005
X-Stat-Signature: o89ftwknhfnqew4md3h53rg41pe4fpw9
X-Rspam-User: 
X-HE-Tag: 1784792990-99509
X-HE-Meta: U2FsdGVkX1/f9Hnr2buSmCSLLQHQOH4bQ05ICnd9D7AXnJDu312GBwU7qJ04w0ekBcmJzIBld2Tj//L1taxdrNztjP1P6URWzOpPSprFW1OR7FeK6QQYl4C2v1UzYVT05gUKhw6diKYxZrFdlZ5HZXmIdnDOQ551fZIpLbDIOZM/nvs3hvl9YhF7jJFpeP5tdfOyrqJYkfCHi5E+SsYKl0uOsHpJxfhuJmS+0Hgv8R8ieAwIFTVvlZ8AZ483ogCC4ITqhxm2LoEEODEvXM7VCTSH0yEhuI4qX6mTyHueMzhM2opHEwTYK/l/m1kpftpcTa0IYFJsBVSsybbnP4xnGO/I6aCS2D3Gqlj6NMqmsYEMtWp4dK63SnaZqVYKuSC9AVO/+NSCkEnnJZB5PS8xOygLfG/hiGzhqB718IrpzYl+3xc9ZIg3yWJuJU2kjiN40KFjXOmghQYlF33KNLXmmh//DBLJLVRzCtoVJel3NKGE+Vrogmqj4vf5ovYT94Prt6MnNiEQVgPfW8PMrDFwAf+1zPqYduCelHepQ5Wl0yLeTF6/FQQ/B4mcqhUyEk0AQ3Y0jetxUY9yxHxQ8/GMkN7tCkowbGuqIH2Py00nlZKbs1Hr7RO/cFXly+18E+8v7FNTnUM9DTsUgtOPScZw5A8sHB3iTPtWbLm6lSO7j/l1J9Wp87zOHnlLEOPoXbYRQmhAOGfTtuOmSa/yo3TCJXjRwwtj3u7ySC9GvbDpfIZHGNp8hJnieQ763BPzIVf5Of9G8Z1SE3f8dRv2N4jZx6K46tE7QhTY8G0j4t93kG+NcdhGtrLzL2THPfm/+M+GDyelSfwio18pvIilXs/UHjfSp389iAWuJSY+3JwgdqdhC35Um7GOuyPj4uKrhFsFQnXrWHF5GMqo6CCCc09lGwrTXAATv9/IRthErmdeIjajmngUST/jJHGulLJxjc3xf/GdM/l6SYtOWVcICsj
 dINtIQAR
 ALVLIZp9KawjpyRCSb4tcjp7BiWm+DNgIkkgTBZR8Hmfq5yoayG+ni6U4qmh/Nza1gFOU5vg051Z2CPDvKVYwVYkcDbpEFVv0E5bMnyNeWmK/fRhnN/9Zd31l5etpRH0ypYdyMlPKhpfR1AFmDFuqRkV/7H7YYIPqt43Hs/rhlqvXpEZqlZR1AW2n40SSSBw8Kx1f9xO6oxS+GN+Icpe0avuBFADHr8Ov/3VIaMHMQ40mZ3EI8I4b9uyQGBM/Rp7W4f6m5CVkn2gZIEh38X7N5VRqaVhCP6owXVrqMkHSTqbjFCbZwREfTuVv9nGsJQ+3fvN2CLTCaAFI2hemAKQvEr+CoicMbNl1e/8MWDZ3+9+2VbZrylMcYcjPDjmqIITPh/sU8z4CJY1rXtdhsCawm3elM9hS2CGQi8zQDJsGTEqwU4ie+fVlsXOASYMyW2stDk1A8mbMZU+WStjQnGTI5QbImb13fODVkdA7/hvWWwIzkDVENt0cgw64c5O8epClWpH4MYsUH9RBeNSpPVTqm3WmsyVg5gaAC6k+86pHzDIQBzPi1IHWhXZicADyGKNMJzm+i95h3qSVEbg6difJDrQWJ96pE+9NFdst9ynUDIxhB19A8E0R9QKxBbuDWFlchAH4533l57P2zmkvSyMIkupv+jLXCd/ur8nX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each online node
in the system.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 52ccc6e99eb5..880de1a6e9ea 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -89,6 +89,7 @@
 #include <linux/gfp_types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/nodemask.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
 
@@ -125,6 +126,27 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_nodes_subdirs() - Creates a directory for each online node in the
+ * system. Once that the node directory is created, it creates a directory for
+ * each zone in the node.
+ */
+static inline int create_nodes_subdirs(struct dentry *mmdir)
+{
+	struct dentry *nodedir;
+	int node_idx;
+	char dirname[12];
+
+	for_each_online_node(node_idx) {
+		snprintf(dirname, sizeof(dirname), "node-%d", node_idx);
+		nodedir = debugfs_create_dir(dirname, mmdir);
+		if (IS_ERR(nodedir))
+			return PTR_ERR(nodedir);
+	}
+
+	return 0;
+}
+
 static int __init page_alloc_hogger_debugfs_init(void)
 {
 	int ret;
@@ -154,8 +176,14 @@ static int __init page_alloc_hogger_debugfs_init(void)
 		goto clean_page_alloc_cache;
 	}
 
+	ret = create_nodes_subdirs(mmdir);
+	if (ret)
+		goto clean_dir;
+
 	return 0;
 
+clean_dir:
+	debugfs_remove_recursive(mmdir);
 
 clean_page_alloc_cache:
 	kmem_cache_destroy(page_alloc_cache);
@@ -166,6 +194,7 @@ static int __init page_alloc_hogger_debugfs_init(void)
 error_exit:
 	return ret;
 }
+
 static void __exit page_alloc_hogger_debugfs_exit(void)
 {
 	debugfs_remove_recursive(mmdir);
-- 
2.55.0.229.g6434b31f56-goog


