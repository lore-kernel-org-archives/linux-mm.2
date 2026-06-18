Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D46CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEA56B008A; Thu, 18 Jun 2026 13:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6046B0092; Thu, 18 Jun 2026 13:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ADB6B008A; Thu, 18 Jun 2026 13:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7BA6B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC2948C526
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:42 +0000 (UTC)
X-FDA: 84893738244.17.190710A
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0BA1A1C0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jh636Bdw;
	spf=pass (imf18.hostedemail.com: domain of 3pyw0ag0KCCoGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3pyw0ag0KCCoGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cF5jQ5tJT2uZF60ESi1BIZkiOEzJiLBY4qt7NfDR8CE=;
	b=JapuXHUWu/N6zKpBo3v1ePAH4cUgl5opl0syzvOh/OBSCdE74v1MnTt5l0m81dkHb4baXh
	kPTwVUeqae+bU9HBUdFa/NsPW4DzsfJtTy88GVJNeqjF/wR4L3Q8bSKix8G7uxi1numUfD
	+PFkDK2XYGUh2Ccl64bGv4JYUH0VWqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804201;
	b=PHR0kU2CivHc6u2NGef+kNJt7nq4WIhL7Esu7nEHHyph6YsH/zftZUIvu9aSpm2ki5rg6y
	5Ab8Y/c2EhaPXAAZRGlwYj0sxQm3imeaXNbVHdx4aAqt1b/zqa+fW4BQ5oivwkFkqYg1rQ
	Z/W7u1RPaDo+zcGqh5j1V+Rn/YUZPOc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jh636Bdw;
	spf=pass (imf18.hostedemail.com: domain of 3pyw0ag0KCCoGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3pyw0ag0KCCoGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-139553dd8acso4852857c88.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804200; x=1782409000; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cF5jQ5tJT2uZF60ESi1BIZkiOEzJiLBY4qt7NfDR8CE=;
        b=Jh636Bdw4ddwZKLqxJ3QYqrUHwoHntUKWOphKRuOfsvK4uNXTckKIq0yrgJNonrA+w
         +5VAUgJ5n0tERlmjRdxNLNBIFJDw5ttShwz3Zp8RSQVr2OMqoEp+hXzBcwieXGTVwogh
         /1zg/3OpqTVSbtLZn6GYXo+uS3is1ITosALdfwinnREjHRuOie8+zjjwKoXTzHIa4sYT
         Te+QGrlfbmtje4se3oRrEJiSA+bSk6QnaWsp2nEKczJmOZQ770r48FJYkWXXOF8QU1jm
         yLxDl6ANbovPKr1Q1Ka9yF8/jNAzOmhYyotI/hgGwokhLWpFrL/scrZCxSZsFmzEB15S
         SBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804200; x=1782409000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cF5jQ5tJT2uZF60ESi1BIZkiOEzJiLBY4qt7NfDR8CE=;
        b=EmcdcdJTrrs5p0vLwn6HizHkxNugeYBDqx9L7PpN/ZP+cTGORqYFg1p4Xh1dmJIdnH
         vFNvyub59oyTCq7qf3ybqOEbOMiIn/yq0r09tW7jpqDqTledmfzd+iY+XshxJL6V2l0C
         lS/TgBOm2d6Vs3y/Kt3Qt0I/rGwZqrHs6qXQVoq1H1SSSKWuJljteHJ65UNw/TwRjNJH
         agq3ROkRShaVbuKnlF7Grht8tVsGjUzeYAb7d+MMDvrFLH8IRYeHvvh74zUDPQ5NDESN
         tph46CKgQO9dnWQEC4+JzuopL6Q7susPTkAtrkS7Qz3GngD3JUDKbiE3mAeHimJWQmX2
         /oKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+dArvT8tKn/a2xjln6D42B5fkmr/2gFHn7hmL65/RQ2sK9K7cFvOWCprVAUN4BOBMZu/eW823TQg==@kvack.org
X-Gm-Message-State: AOJu0YxY69KgG55LBXCj4EC8dbysHZevtz0teTltH+z+L6VuSM0QgA2f
	A71lFKDUewCtkbrTHwso0Agsr0UBltdk46F7Fzns7I/3EJdHZqZtMapbuSCdbUjzTd+1LnWGxlc
	vBL908Bx+u4jQldx0r6WgTGwtNcRvoa1Xtw==
X-Received: from dymh25.prod.google.com ([2002:a05:7300:1c19:b0:30c:2e1:d2bf])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2509:b0:137:ae1d:5b58 with SMTP id a92af1059eb24-139a2194979mr516145c88.20.1781804199379;
 Thu, 18 Jun 2026 10:36:39 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:30 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <d26397bdc6823ec6e5918efa0ced70ce65277888.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BA1A1C0009
X-Stat-Signature: d6oz3jpps5tjxrkk1o8kz4gepm3aje5f
X-HE-Tag: 1781804200-14424
X-HE-Meta: U2FsdGVkX19M/3HP4U7UxCh12dLSOWt/cNJKRjUti1QPAbJhuSuP2y9/KuEanAxie5yco4O2ZO68aRA8ns9LF6rjzB50Wun2qnoZi33vMeuUV/b2pOowa/cxA+vBDOIbhnGai1QD2J41JK9hcwqMd4vfl8YWXB4m5RKP6aciX+jhB63kFymktRr5cgCwYKANxC49jf/1XuTVWAyAeJDQ/rFB1qLJJ5aqF2DHTiTglRuwZYqq1192sVRn69hX0d7QJOWo6o+Mf2I8DrNKrdHHw3So3kr5Pia6OuLQIAIFks87eIB8E9dv3XS+WZcVo+h53JsEbHI2s6yKY9n7oULpZ3+rbdS25su4vGk9e9WmcQ1SfYXYxjiVpiTqWgz1QxSd53oKMLyTbS31KLtiQg7ypbJFQ7f0FqtV+1ncB9t7zaFCMJfSdEOykUXvh0HUOPz8WGEQhutKskQogP+HtN/ql0uciADnkcxES3GoqGYaV0T4Pqyq0PIuZhpF5hBWMnCFeA9CtqOuaFi+ad8aOOTB15HMi2Fbpd1zTGiAZHnVFNwUA155diwGXvz/KmVyL5OEJWavQj+nNxxCx+BSy6i3urXkjyajTT1t8WxUEifrxE6X160S8lUxuQI9k4p2FdRdz+LMlXxEZjN521JvzCYZ2Q89c7pBDOawIEbM1Ytwozd1Wc1QdamfzU7IDyyeP8K4bPHs/+mKkW3oaVQ5nuw3dQHVuGWaeynBDfEWi8KtW6EjNgNmBAKVd4+HXDgWqF13DJ+6TxOcBU/cdFR9Df1ROMDTy8D0edUqxoEL0Uo6Q+WByqZIUzk8wkczTclHYCeotudomWNXT30gTezL/usGZXSpNR9J9VUm0U11m4sD0WgtiW+r2PM2ZBTOxwUIn4BkEiDXV4epsoyp8YWWfAVmuARhG+iAl7qFr/AqjfdOuL4z8buBS4v7+IKI8a7PUrznqxnHyJnaniT/hAWVfmD
 5lNTecTT
 XojTJxJjPmAFcVI2tBmAj2vk28AtI4ff2tZkARA/YxI79tP1rw05ywasVFUKVlAl++om6/W+6V9qT0mFdzeGqcMfPMiekdDlwB7jOyJS5+B/9o+qduhaArgwCyvQanp2re4uJKixP4akCb9PKMS+8Rrrehh+2PCAurAyAZa/yyI3KkOYWoNotn+SJseEeII7Y0NSiU58E4YDFdaSRR5ExXr1MbGO1vFFd2W469Ou5Aeo129R/7CJ4uu/6SH8IdHnVVhBaabqaF56aLjos7YfNcakVe5VefFtj3tV829+pq/qtUCJ9/nubLK96Mbe1UqCejTqFonQmbGub8x0CdISFOPs/U3IvT6nEcVJslwBp3H16Wr9RW5ue8gC/6eshVTp/Ndo/4R5LG2tMjEhZMLxGGsDu6/a6n+xVV64/ndGUpRsW1V9imZuwjjJRpUdcQZLFpDq5sxSGyteuP/T8CJ1OVcv3BzsEeAUkco1fCA/4hHH28+7HcaLZXbuxS976o+vAFbkP+ok2VxiiJ43o53meRZKJ+DbhjVqiCqfSbZ+GJgQNwDrA8p6qN+qpdXOkF2BZgRMqwqz0KrkUEcxISebhkVxjYsqDy1bhnbXV5YAKsx837H2C6EglVHc+6bHlCDJPlUTwyVAPbiHPA2zrJHKdk5nflCcuYiimEJXA+FRRB4rCErXM3RC1QDxnXu6BS2nxL7xOu089xZ/y1Qn8u/oXbFcHP0rbJgonvD6PTEFQ+oRtqV8+AUmP1J9igddb8LEXpeaPgSqD4/TUfAU=
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

Note, function file and module names often have the same prefixes,
therefore when filtering for them, we compare the last 64 characters to
minimize the chances of name collisions.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
---
 Documentation/mm/allocation-profiling.rst     |   5 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   1 +
 include/linux/codetag.h                       |   2 +
 include/uapi/linux/alloc_tag.h                |  65 +++++
 lib/alloc_tag.c                               | 238 +++++++++++++++++-
 lib/codetag.c                                 |  18 ++
 7 files changed, 329 insertions(+), 2 deletions(-)
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
index 000000000000..ee6a023cbaf4
--- /dev/null
+++ b/include/uapi/linux/alloc_tag.h
@@ -0,0 +1,65 @@
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
+/*
+ * Function, file and module names often have the same prefixes, therefore
+ * when filtering by these criteria, we compare the last 64 characters to
+ * minimize the chances of name collisions
+ */
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
index d9be1cf5187d..c73195000830 100644
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
@@ -130,6 +136,235 @@ static const struct seq_operations allocinfo_seq_op = {
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
+	struct seq_file *m = file->private_data;
+	struct allocinfo_private *priv = m->private;
+
+	mutex_destroy(&priv->ioctl_lock);
+	return seq_release_private(inode, file);
+}
+
+/*
+ * Returns a pointer to the suffix of a string so that its length fits within
+ * ALLOCINFO_STR_SIZE, preserving the trailing characters.
+ * Function, file and module names often have the same prefixes, therefore
+ * when filtering by these criteria, we compare the last 64 characters to
+ * minimize the chances of name collisions
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
+};
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
@@ -993,8 +1228,7 @@ static int __init alloc_tag_init(void)
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
2.55.0.rc0.786.g65d90a0328-goog


