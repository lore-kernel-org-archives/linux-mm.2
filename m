Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09B7C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D27A6B0125; Thu, 23 Jul 2026 03:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1836A6B0128; Thu, 23 Jul 2026 03:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024366B0129; Thu, 23 Jul 2026 03:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6CE6B0125
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:51:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 607521403BB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:13 +0000 (UTC)
X-FDA: 85019270826.20.9893630
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB18C40003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BTq1bmXb;
	spf=pass (imf27.hostedemail.com: domain of 37sdhagcKCF8GVBP97PDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=37sdhagcKCF8GVBP97PDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793071;
	b=IuFTqXx5rcfY1jbzMKuM7/ALfFK8zYnzCxfs8a38PkjVS4Qt1KCJSZhZlw0SmD9Qwnut+F
	r1iy2v5Ads4YoZ3PKCdY1RBW+OH6acQqbLTd2YBO+aFTcyNHYTShHx+i5g9MKWh0zq/njx
	IvHv0NVtqbxScwdMwHJK4MjcOlfmfcQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BTq1bmXb;
	spf=pass (imf27.hostedemail.com: domain of 37sdhagcKCF8GVBP97PDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=37sdhagcKCF8GVBP97PDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DBUAz0DHEFtyZnsL6ARz3oP4Pqf/8loRhE7mS+17IM=;
	b=Z8rdL7gkP23ukfwguNLvGG/IZ8dsnu9w5mso2zRfQOiZjiLBKqaHpmDJS8B1h/jBw8Sbkw
	nO8hanHQheiPQuRbDvIDAV1APcvc7qGJhOMh6pvS97TdtWlIMsMcCKL6xG58DGcZ2rHuDa
	i2/JdtjzS1yqG7Khq5eLt/LYrz/GyTY=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso508367a12.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793071; x=1785397871; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7DBUAz0DHEFtyZnsL6ARz3oP4Pqf/8loRhE7mS+17IM=;
        b=BTq1bmXbubA11F8TFiOxOsTH4taY+et48/4n3WUETzCVlUEvxHL/z2YIuVAwqug2R8
         +5FIWhs8JFqSk1UXxT7O7rLfLUmK/+mf3R6UjswxdrJtrndSS4B1HsUJRAUc9p0ffKy3
         oF50Um3i3NXlk3u4J8UzdsCKrPUeGvDv4lhbybwlbW8g/KFBbcssisxAD4aFuAer4sqf
         l3GwTZ1tWEkAI/LU2L3PPuONdQQKU5ftXAXH6mJcouAlk20AwwE9KJo831+0LSR6NgRW
         9SCbGBehrvDDmj1KJ+xYm02OstKFry5YRJuRBF5rG1xdhs75F0uo9qaiuaml51TJzIq+
         Hf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793071; x=1785397871;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7DBUAz0DHEFtyZnsL6ARz3oP4Pqf/8loRhE7mS+17IM=;
        b=rs5+1QVs1mzZbMdRpQQYb1kTTzEz01m1DgoMx7bH/oqRWTCirVhUF0Bm4LUWTZZNBy
         aioU/shjNmnV/KyaMYf82b/WFH0sMJxr3I87biJ6bizUkEy+d82qkLoBeUSeE9qBFt/c
         mOu12gAC1Rfoc2lq9DgjxH+lVpuIqqlrbsh5CJ1GZusdUyv0/WBmpuvOIwc5VE1HlxMa
         Ld7VscB/1zE/fD0Wii+1vIs5L27kOieIr6QBqY597NKHoXoX24CjHLVi07nIXefZM/PD
         4ocV+/uzh6xErtLJP6gf9pcqi4PByah7+9Q/wloxcq1NPzMo64VSJVjkLVuxcqN50eim
         GzRg==
X-Forwarded-Encrypted: i=1; AHgh+RpS8c6uTbHlg0hvZxIKqqEACJwh08w20+P7Dq+45CkrX6B4iMFH54Ce0ZpI1RR6xFThIo9DiK+Wog==@kvack.org
X-Gm-Message-State: AOJu0YyflPLUbzYiA9cudo0+rYCT57jBv4LZa3Hqkj/nrQYPAaddbSfk
	VN10lMhv6QcaK5rQ/4gU6uUhma3H6zqFLVA8WZ2+9fIfs1W618gcVHaLflIGgU5HT3wzLi/rxLe
	i7Xa0wyo6IQ==
X-Received: from dli14-n1.prod.google.com ([2002:a05:7022:28e:10b0:13d:1c1d:bba])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7008:b0:3c3:8de3:8eee
 with SMTP id adf61e73a8af0-3c44b222849mr2150120637.61.1784793070348; Thu, 23
 Jul 2026 00:51:10 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:19 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-16-jyescas@google.com>
Subject: [RFC PATCH 15/16] mm: Create the "free" file to release the
 previously allocated pages
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB18C40003
X-Stat-Signature: 9wphba9f7txcdwrp45d536o4t9kkazse
X-Rspam-User: 
X-HE-Tag: 1784793071-978983
X-HE-Meta: U2FsdGVkX18M5gMog3gUT9v9ke3121d4+u5S5iwbB7K/TJ+HeB6WvrnwIaSILzfbLpt1wRuDuxPMOb6qQcSfrfCd2LuOZn2gDQktRlpjmlsFOD+rfEm/QPRNXmt6TWWekdsQog/mCj4qG5XzOqFqgjLLP1RjnQsb1I/uquYvLhwykRJ0gPoDZTFMUt2ImEJ5L4yIOEqmxMLuRofiQafxJm0uMrE2glY0HYTJX3Ab6o4RQTj1ycXjEbKhOmAJ6QMV/SzP4/Zk0jhTP5LlKnDMNLhERz3V1kBA9ZoO57IV/IzJWCLmIAdrUJxe/TJWCbdYv3JcPMUXfu31f1bQ+BbRSoUdOr1EVUX0C9B5kFCZb559PRAhgRvJhdUKPqsCoIuCuawlFJxStJFBF+Ze1z0MJLEoS+qnQzXcPYnaPBJM+3b3xQrPfocsbp7Dr3MXD4uNNbteF/ZANXMz7umnPcnBVjbkTGTHrOQLBYSaeOArQTcev25FgdVL1+X66usGqPPjrdGR8FMBkldMJmhjZp7EkI8T5IMeDzgICCr/OKzmBjmBEfqd5J8se9Q0PuGNKaZgldelYteUS23UI/k9cLeqVL8bcHcq4tgJ/s53Nad9X5425UBQ0EZIXxlazVGEmXg+vjAxniwMEMvvaWs5f4ikolFwB5GpXO27pX9/K+SfNDinRRTX86V/ntAatynZgn5K+U8mrgo5NVRjrtxnt7n53yTcIxwWKJkF49GYHtYJBT1lHDjj7umA/1HeHGe0pQJ8vQPxyHot44mVePK7UVY9c6IyZeicsn4r71KjrFgg9H54DSdO1v+GOhPCJZ4khSDI14rDnsvzes6ogLKPRXEY2PC9KRuH8HIctmu5C+yYczjut+GRgkpQYN7ZGPJhjdtWqi2bUrNqlFMRN9pj7ouIGworx6xtE7pWnnrQsXuopVssH/dB1BD9V95glvfwcEsGhkgVVr8UfmLR0YsmqSS
 0W3l10iE
 YmWq1aaH5iNU+8VVwzDkk9KooDX9bGGiXQU1gELDg2GYnIwVmhB82BYpWiK9yuc29mFxOgb9f4+eMhVkSEbxZPFcN5jDvaV4dILfR1muBnETUpHZYn2XEFPm/PQtVmvCJ7prx5on0ed7xu6fjBMKOpuzmSym+zLQEhQKruzWuA7gFva/txCWDGP5LR/tQ5rVTISd6v+tIjPOdvjaow5bhIP9JJp53Qnyzdz0JBRZp8FiJiz12yh3wUUELwjjkxu+FEfuVwL3qRFSIs0IY71Ueh2CJnJIqIvoIvJfOlPcd9TyLrOlJpBnDPkT+A/MtYgiJziizFiGcSnYGIqmtcPWjin7wm7dGEVO8KxdIq387nPapsgaADWnU5dleWhHPBp1hdgb6S1ViH0C+AaQwkgWfyL/u0FhVd2QqqwuraXgN/LgHKPdmb+vzMMvzk6r1vAFNoHcHJWq1UCGTtt+bm3OlmPcUU5qLGB57CE5t3CdXkUxX/rgbXUlpkhVXL+LZsD6IEZnvnbQBccYcilJOJf9vfa2P3oaAeKQq5ek5cMkln/73Vt77szlAQzRNs2Wt/BF8yG0uTSWDDuJMpUGFtMWW9ho48etrAvrrCYQUFuIg1dSKotlqrMxngGFVgfBeMwRO5xJWuq4EvQMj+CHODUvGRym7qPW3WvG/MgHktIMkSf92QyBVYOWbiO2MDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates the "free" file and defines its file_operations
to release the previously allocated pages. To release an allocation,
the user will run:

echo <file name> > /sys/kernel/debug/mm/free

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index e65aac881ec7..5fe9c545e884 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -83,6 +83,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/debugfs.h>
 #include <linux/gfp.h>
@@ -94,6 +95,7 @@
 #include <linux/nodemask.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
+#include <linux/xarray.h>
 
 struct dentry *mmdir;
 
@@ -331,6 +333,37 @@ static const struct file_operations req_page_alloc_fops = {
 	.write = req_page_alloc_write,
 };
 
+/**
+ * free_page_alloc_write() - free the previously allocated pages.
+ * @file: File where the user is writing.
+ * @ubuf: Contains the name of the file the user wants to delete and have the
+ *       memory associated with that file freed.
+ * @cnt: Size of @ubuf.
+ * @ppos: Current position in the file.
+ */
+static ssize_t free_page_alloc_write(struct file *file,
+				      const char __user *ubuf, size_t cnt,
+				      loff_t *ppos)
+{
+	int ret;
+	unsigned long alloc_id;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &alloc_id);
+	if (ret)
+		return ret;
+
+	ret = free_alloc_helper(alloc_id);
+	if (ret)
+		return ret;
+
+	return cnt;
+}
+
+static const struct file_operations free_page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.write = free_page_alloc_write,
+};
+
 /**
  * create_nr_pages_allocs_file() - Creates the file "nr_pages_allocs".
  *
@@ -501,6 +534,7 @@ static inline int create_nodes_subdirs(struct dentry *mmdir)
 
 static int __init page_alloc_hogger_debugfs_init(void)
 {
+	struct dentry *free_file;
 	int ret;
 
 	req_alloc_cache = kmem_cache_create(
@@ -532,6 +566,13 @@ static int __init page_alloc_hogger_debugfs_init(void)
 	if (ret)
 		goto clean_dir;
 
+	free_file = debugfs_create_file("free", 0644, mmdir, NULL,
+					&free_page_alloc_fops);
+	if (IS_ERR(free_file)) {
+		ret = PTR_ERR(free_file);
+		goto clean_dir;
+	}
+
 	return 0;
 
 clean_dir:
-- 
2.55.0.229.g6434b31f56-goog


