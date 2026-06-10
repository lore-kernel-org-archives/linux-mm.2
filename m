Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7011CCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0E06B0098; Tue,  9 Jun 2026 20:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93ACB6B0099; Tue,  9 Jun 2026 20:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7662C6B009B; Tue,  9 Jun 2026 20:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B50E6B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18EF8A0789
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:13 +0000 (UTC)
X-FDA: 84862078266.14.9F5BF40
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51401160002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P66CYFWD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Fawoag0KCGgGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Fawoag0KCGgGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hq94XP/6nim6n9o42jIr9a4u0pAoRXZGfLL46kf9Ra0=;
	b=Qs+UNSWyOx5wBLSgIZGKtTKY7ixOsw2JMx4tZlCAR0gjBWv1e1/i1GhxrcvdsvsJRqC0kB
	gXWhEtWCjAKsNXp8sTh7nrVi/eEPr/EXKgaLFwDWfuaqFpKVdm/9CmVZgL/uUIvqXzZvYY
	KHIOIMpqKvYrcyB+1Qu00ckzDLwySPE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P66CYFWD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Fawoag0KCGgGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Fawoag0KCGgGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050391;
	b=ojcZ1Get6LbfDVbUtHQR7q3M2PhGIRquTclfOmbQAn3FCeeh1JUYbl0oAcgSRIx68709/+
	CapMjgXcBJnorj2NCHkEjq0jQ6qwfH8alv66mioqAEsIOSaOWhtt+rhNn3Lm/E5eb8jnvS
	FpA00ffSDJkiRAOUgXFy4dMUmJsoxYA=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304e4636205so45351eec.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050390; x=1781655190; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hq94XP/6nim6n9o42jIr9a4u0pAoRXZGfLL46kf9Ra0=;
        b=P66CYFWDkLF/KqNORT9a71Fjikzc0sQ8uhMz4UUaeThspqiPazqOhEZuYT+SIBmbpl
         8ml/OsvfQnwMn49H7dH1UmPzEQkAXH3KYSq29/DiVZsVQa2zKcqtT4e5vNA0IPYqOPwW
         v/0yZntjcmKck7Ij6Ad4pqyXwqfncYnMMuWDilg6GnK9Eb5kNaNYkT7gdSn5STV7dWhg
         bYn2bs+sNPGz9RsI+ol8Bc95qHsNXgJKPSjNbOnl07ib17SpBfAV1I8anLWNt/KKKNrw
         o1C6dq2tSx372Aha9LxUQFHBakEfmKX8IubA0o1TF9JZ9iSU+pNJhKvA68JbZXejMuY0
         hCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050390; x=1781655190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hq94XP/6nim6n9o42jIr9a4u0pAoRXZGfLL46kf9Ra0=;
        b=a0lOCz7JfbVVpgh/qCCpFVseEcFCOKHDV9w+yuisNNPR9heDNv+GEuDFPmrwHGcRIT
         XaNvvRXUlpPvSWYccA3kohqqHsZDvpCyH2UBceUQm5o+hb/gdshHeUjGK99ln3xErasR
         /VqKOH3iOU869xgSzIY5R7tg7Vm9O21ufdPX5QT5E8B4QDi55eYNu475VJPpaRjtpcMd
         k+sW8MOE0tBwlOUpjiRlGl0BHtCKLhaMFsIxqItN8OnBJyyIocrsGzDksgsESrLudtXj
         KIGX7seSHfUBZ0ctE/pRzpozyTGkUD+RbXgLsUbdHkUMqPb3o8REMsoQCZmH7TXvqfhp
         MGAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LM2Ef1VWSS6+zEthnj/NSvXVk6gM8YbjjQAO+wztgw9OD04ddml6MLlvVE7j7d0sgPn9coDw5Ug==@kvack.org
X-Gm-Message-State: AOJu0Yz3EllC3J0zPFIUca6YJMjnMmV8S7U8XeYP5eC8iUbIvLygdyHf
	MQLRpScrCkRPwKwV3xvAFXjiYW/TcJICL2XuSB5FyaCktuzkQKtRO5NAeeRD/mLScVyGqb3KgVY
	iAAcfhBxgZD37QzCPhBYcvgSRwY1gMmGX7g==
X-Received: from dyeg12.prod.google.com ([2002:a05:7300:538c:b0:2da:2af9:bfe2])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:5b88:b0:304:d14b:b706 with SMTP id 5a478bee46e88-3077b271f5emr13780687eec.27.1781050389798;
 Tue, 09 Jun 2026 17:13:09 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:54 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <b58a0d01c8bb6d7c1d2350599c1b0170be161489.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51401160002
X-Stat-Signature: qyxr4ty8qm1ek8cuu7y7cbmb51wrrhzb
X-Rspam-User: 
X-HE-Tag: 1781050391-905432
X-HE-Meta: U2FsdGVkX18iNdf/YJdaH2S3CndA6BHySuiJgRawN/MFRYgnrMjRYCt/wa48sx2UIm1/3OEa3I7uwPqjacSOnLn25MZrje1jLssVAA2bRDs3LFgZw8PgTnokMDVyA8UjlgzF1LJzkpAGU0lyJGYhXflXRpbjVqzlsaorslKuekjnuS5UQqE+kG4ooo0tu5Chi67xpQW+9BlGKNBWhfO3OrMYREp0w1h/zuQj9I45oCXvBJZh1hgQHXpWXKvU5R6cj+76m4e4J7JlchswJc9KogD3ecVvfmxaXdDNkl+BoAZVtYhb/IgwGD+x1pdbjGb98RgvwJ29QNpynLsSYHGdsRNIYuMLhBm4Ht5uvaOW6WVRHwhUyKOTr9F17Qp4C2P3xyeOgOX+3S5bVoDAYJ3d2aiq3XajlLDNzLN6zLfTmykQM7dnyBVmP4A51togGWdZf7V1v64+tS1m3fGVdScHhZpacWhOzOhlBwy9ZxZ2pcxaVQ/XHo899u+/GIKiMG/7wjLg5atF0Ay7ySbteRNyN15zOrEcARM8Cp3HYNNpxuKWHZXZ9OJZhv025XaniMaIS0lVr4e7r459USB+9smsreV30Wp3Dn9TaV1WI1SMWwG/HpIF238tMFfp2e2eAfmWTP8loNg1ZKRr8rCeNI/bAcHNwpFx7Q8hXhmWea2FDjKZHeUM80ZEb3aKDUML00NvZYllLdcD6VK4htEP8F/H6QnZT9pk7XdmXS50xfN2gY4jReZSCyk/v/E1yTSZi1XUVq5HcV5CcIcvxMN1lxFILPVKrBbsi6cqTPOqhXCZrOLZlOb6pjF6ahiFOy05hd99TGH6BAA4QkgKP6WMQIXC/bhxOHW/6tsqQRf1vTd5ddNZFR7ZQc1bHLc0bX27rhxccN+e0A0zqzCY7NOCIplqHxLyx64g1QT6+Lt/HaDgmo7j3XqGBbl9G6iSZ6uFJfa6PEDRMpxGgLKohqrhFlQ
 /jHcOM7a
 OxhvwI1UwBL5wpkVwt8GATO71JZO5DltdX8IqKZeEP4gv9cZxJTTM2F+4ymtqXhpi6gHH68FiRwoDR5SF6z7WuY87ty4rpeFDI5CkPknUJw4tOxSOt7AWVb+tDWd/3zTTC6clgCTG07jYI27gUe5NliuRIyrEDBLVL/KUbWmtA1MQjwfFY41LwQN2yOVVfCxJhgu52mQyfZEEPeWxuOQikE1hwjWWvgDhj/VCDJ5bk8auk8VK/nBTeRO/o90Sq6hFdDkwXmm6q9eTLRhVLNdxyaRaAjYBIxA4Vx3o2DZRiZN8vTPlsE5efyY7cINSQOv/qzplP4Gt3R7RwV1KqD53623UN4iRsm5cRtzmz0n/McXY8wFD5S5QSt80jBgDgvIQP9XxOgpPK8wQZXLlbNfy++3YcMePutGolLbs0yoItfdQ0BC+F/x9WL4P03cJNRBMD7XwbKX0+rDApiA6naAyR/32CPJs9TkTsdBNfxaPQsfBDtG+ewcqmpHE4+024Pgb/ckPwKHf0X5g/8Jk+V1BA5SbbIiluhnHJkpaq6YCtCSt0fXCsnDoQNGYrA7ZgUQNBBqmBS7tVh+0ulx4ykKDFMAjnNSnSBdA1N33dbK6x2SoBYHOTdkSQGXn9hPIfEWfIvN7wCdJOf0zEv+tuBBZfb71G8DqaR5udXoWJygitroHzXQSVuM/8zMrmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Suren Baghdasaryan <surenb@google.com>

Add the following ioctl commands for /proc/allocinfo file:

ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
to check whether the file content has changed specifically due to module
load/unload. Every time a module is loaded / unloaded, the returned
value will be different. By comparing the identifier value at the
beginning and at the end of the content retrieval operation, users can
validate retrieved information for consistency.

ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
is the position of a record in /proc/allocinfo.

ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
one. If no records were previously retrieved, returns the first
record.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 Documentation/mm/allocation-profiling.rst     |   5 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   1 +
 include/linux/codetag.h                       |   2 +
 include/uapi/linux/alloc_tag.h                |  60 +++++
 lib/alloc_tag.c                               | 232 +++++++++++++++++-
 lib/codetag.c                                 |  18 ++
 7 files changed, 318 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 5389d241176a..c3a28467955f 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -46,6 +46,11 @@ sysctl:
 Runtime info:
   /proc/allocinfo
 
+  Profiling data can be retrieved either by reading `/proc/allocinfo` directly as
+  text or programmatically via `ioctl()` calls defined in `<uapi/linux/alloc_tag.h>`.
+  The ioctl interface supports structured binary data extraction as well as filtering
+  by module name, function, file, line number, accuracy, or allocation size limits.
+
 Example output::
 
   root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=iec
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 331223761fff..84f6808a8578 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:luzmaximilian@gmail.com>
 0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
                                                                        <mailto:luzmaximilian@gmail.com>
+0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
+                                                                       <mailto:surenb@google.com>
 0xAA  00-3F  linux/uapi/linux/userfaultfd.h
 0xAB  00-1F  linux/nbd.h
 0xAC  00-1F  linux/raw.h
diff --git a/MAINTAINERS b/MAINTAINERS
index 65bd4328fe05..019cc4c285a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16713,6 +16713,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/uapi/linux/alloc_tag.h
 F:	lib/alloc_tag.c
 
 MEMORY CONTROLLER DRIVERS
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index ddae7484ca45..a25a085c2df1 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -77,6 +77,8 @@ struct codetag_iterator {
 void codetag_lock_module_list(struct codetag_type *cttype);
 bool codetag_trylock_module_list(struct codetag_type *cttype);
 void codetag_unlock_module_list(struct codetag_type *cttype);
+unsigned long codetag_get_content_id(struct codetag_type *cttype);
+unsigned int codetag_get_count(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
new file mode 100644
index 000000000000..0928e1a48d49
--- /dev/null
+++ b/include/uapi/linux/alloc_tag.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * alloc_tag IOCTL API definition
+ *
+ * Copyright (C) 2026 Google, LLC.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI_ALLOC_TAG_H
+#define _UAPI_ALLOC_TAG_H
+
+#include <linux/types.h>
+
+#define ALLOCINFO_STR_SIZE	64
+
+struct allocinfo_content_id {
+	__u64 id;
+};
+
+struct allocinfo_tag {
+	/* Longer names are trimmed */
+	char modname[ALLOCINFO_STR_SIZE];
+	char function[ALLOCINFO_STR_SIZE];
+	char filename[ALLOCINFO_STR_SIZE];
+	__u64 lineno;
+};
+
+/* The alignment ensures 32-bit compatible interfaces are not broken */
+struct allocinfo_counter {
+	__u64 bytes;
+	__u64 calls;
+	__u8 accurate;
+} __attribute__((aligned(8)));
+
+struct allocinfo_tag_data {
+	struct allocinfo_tag tag;
+	struct allocinfo_counter counter;
+};
+
+struct allocinfo_get_at {
+	__u64 pos;	/* input */
+	struct allocinfo_tag_data data;
+};
+
+#define _ALLOCINFO_IOC_CONTENT_ID	0
+#define _ALLOCINFO_IOC_GET_AT		1
+#define _ALLOCINFO_IOC_GET_NEXT		2
+
+#define ALLOCINFO_IOC_BASE		0xA6
+#define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
+					     struct allocinfo_content_id)
+#define ALLOCINFO_IOC_GET_AT		_IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,	\
+					      struct allocinfo_get_at)
+#define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
+					     struct allocinfo_tag_data)
+
+#endif /* _UAPI_ALLOC_TAG_H */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index d9be1cf5187d..a0577215eb3d 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -5,6 +5,7 @@
 #include <linux/gfp.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/page_ext.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
@@ -14,6 +15,7 @@
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
+#include <uapi/linux/alloc_tag.h>
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
@@ -47,6 +49,10 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	/* ioctl uses a separate iterator not to interfere with reads */
+	struct codetag_iterator ioctl_iter;
+	bool positioned; /* seq_open_private() sets to 0 */
+	struct mutex ioctl_lock;
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
@@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_seq_op = {
 	.show	= allocinfo_show,
 };
 
+/*
+ * Initializes seq_file operations and allocates private state when opening
+ * the /proc/allocinfo procfs entry.
+ */
+static int allocinfo_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open_private(file, &allocinfo_seq_op,
+			       sizeof(struct allocinfo_private));
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		struct allocinfo_private *priv = m->private;
+
+		mutex_init(&priv->ioctl_lock);
+	}
+	return ret;
+}
+
+/*
+ * Cleans up the seq_file state and frees up the private state allocated in
+ * allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ */
+static int allocinfo_release(struct inode *inode, struct file *file)
+{
+	return seq_release_private(inode, file);
+}
+
+/*
+ * Returns a pointer to the suffix of a string so that its length fits within
+ * ALLOCINFO_STR_SIZE, preserving the trailing characters.
+ */
+static const char *allocinfo_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	/* Keep an extra space for the trailing NULL. */
+	if (len >= ALLOCINFO_STR_SIZE)
+		str += (len - ALLOCINFO_STR_SIZE) + 1;
+	return str;
+}
+
+/* Copy a string and trim from the beginning if it's too long */
+static void allocinfo_copy_str(char *dest, const char *src)
+{
+	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
+}
+
+/*
+ * Populates the UAPI allocinfo_tag_data structure with active runtime
+ * profiling counters extracted from the given kernel codetag.
+ */
+static void allocinfo_to_params(struct codetag *ct,
+				struct allocinfo_tag_data *data)
+{
+	struct alloc_tag *tag = ct_to_alloc_tag(ct);
+	struct alloc_tag_counters counter = alloc_tag_read(tag);
+
+	if (ct->modname)
+		allocinfo_copy_str(data->tag.modname, ct->modname);
+	else
+		data->tag.modname[0] = '\0';
+	allocinfo_copy_str(data->tag.function, ct->function);
+	allocinfo_copy_str(data->tag.filename, ct->filename);
+	data->tag.lineno = ct->lineno;
+	data->counter.bytes = counter.bytes;
+	data->counter.calls = counter.calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+}
+
+/*
+ * Retrieves the unique content ID representing the current allocation tag module
+ * layout, allowing userspace to detect if modules were loaded / unloaded.
+ */
+static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_content_id params;
+
+	codetag_lock_module_list(alloc_tag_cttype);
+	params.id = codetag_get_content_id(alloc_tag_cttype);
+	codetag_unlock_module_list(alloc_tag_cttype);
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
+ * profiling data and returns it to userspace.
+ */
+static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	__u64 pos;
+	struct allocinfo_get_at params = {0};
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	priv = m->private;
+	pos = params.pos;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	if (pos >= codetag_get_count(alloc_tag_cttype)) {
+		codetag_unlock_module_list(alloc_tag_cttype);
+		mutex_unlock(&priv->ioctl_lock);
+		return -ENOENT;
+	}
+
+	/* Find the codetag */
+	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && pos--)
+		ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct) {
+		allocinfo_to_params(ct, &params.data);
+		priv->positioned = true;
+	}
+
+	codetag_unlock_module_list(alloc_tag_cttype);
+	mutex_unlock(&priv->ioctl_lock);
+
+	if (!ct)
+		return -ENOENT;
+
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Advances the ioctl iterator to the next allocation tag in the sequence and
+ * returns its profiling data to userspace.
+ */
+static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	struct allocinfo_tag_data params;
+	int ret = 0;
+
+	memset(&params, 0, sizeof(params));
+	priv = m->private;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	if (!priv->positioned) {
+		priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+		priv->positioned = true;
+	}
+
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct)
+		allocinfo_to_params(ct, &params);
+
+	if (!ct) {
+		priv->positioned = false;
+		ret = -ENOENT;
+	}
+	codetag_unlock_module_list(alloc_tag_cttype);
+	mutex_unlock(&priv->ioctl_lock);
+
+	if (ret == 0) {
+		if (copy_to_user(arg, &params, sizeof(params)))
+			return -EFAULT;
+	}
+	return ret;
+}
+
+/*
+ * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
+ * layout content ID, seek to a specific tag, or read sequential tags.
+ */
+static long allocinfo_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long __arg)
+{
+	void __user *arg = (void __user *)__arg;
+	int ret;
+
+	switch (cmd) {
+	case ALLOCINFO_IOC_CONTENT_ID:
+		ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_AT:
+		ret = allocinfo_ioctl_get_at(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_NEXT:
+		ret = allocinfo_ioctl_get_next(file->private_data, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static const struct proc_ops allocinfo_proc_ops = {
+	.proc_open		= allocinfo_open,
+	.proc_read_iter		= seq_read_iter,
+	.proc_lseek		= seq_lseek,
+	.proc_release		= allocinfo_release,
+	.proc_ioctl		= allocinfo_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl	= allocinfo_compat_ioctl,
+#endif
+
+};
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
@@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
-				     sizeof(struct allocinfo_private), NULL)) {
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
diff --git a/lib/codetag.c b/lib/codetag.c
index 4001a7ea6675..a9cda4c962a3 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -19,6 +19,8 @@ struct codetag_type {
 	struct codetag_type_desc desc;
 	/* generates unique sequence number for module load */
 	unsigned long next_mod_seq;
+	/* bumped on every module load and unload */
+	unsigned long content_id;
 };
 
 struct codetag_range {
@@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type *cttype)
 	up_read(&cttype->mod_lock);
 }
 
+unsigned long codetag_get_content_id(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	return cttype->content_id;
+}
+
+unsigned int codetag_get_count(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	return cttype->count;
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
@@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 
 	down_write(&cttype->mod_lock);
 	cmod->mod_seq = ++cttype->next_mod_seq;
+	++cttype->content_id;
 	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
 	if (mod_id >= 0) {
 		if (cttype->desc.module_load) {
@@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
 			cttype->count -= range_size(cttype, &cmod->range);
 			idr_remove(&cttype->mod_idr, mod_id);
 			kfree(cmod);
+			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
 		if (found && cttype->desc.free_section_mem)
-- 
2.54.0.1099.g489fc7bff1-goog


