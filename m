Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051B3CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3816B00A8; Fri, 22 May 2026 13:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF976B00B0; Fri, 22 May 2026 13:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7086B00B1; Fri, 22 May 2026 13:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3390B6B00A8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCD191A09FF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:50 +0000 (UTC)
X-FDA: 84795783660.27.1FE1FD7
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id C1B058001A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O+ZI3KOS;
	spf=pass (imf30.hostedemail.com: domain of 3S5YQag0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3S5YQag0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tXuuAhgXpxxwMsr1wnQWACrH8a9haKBpqgpQfYI6/w=;
	b=FiTKGmxzJMnlcbkxMCB1o3e1qavF73KDamWl9wXhPeK7NSMPZlmnC/3pi4HIeOdhaVgTeL
	iT+xIcv1HI9sl2yBePCRA3/c8s+IezAt3gZe8+6++CRTiU3+97i0DwkHXSDVeA2r1lglss
	TNNjHh+WGbOgViV4CFE1n9iPQFlh3nw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O+ZI3KOS;
	spf=pass (imf30.hostedemail.com: domain of 3S5YQag0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3S5YQag0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471948; a=rsa-sha256;
	cv=none;
	b=46NEEcVJnrGC+69aiiaJdJPcqlZt82mhHQVhLQBcBMDtPsCyt6QCYfHhJ25I0yp9yVZE7Y
	kEElHoW+wwR8jScH6YGpF17VIOZy285i7k0subECK/IhaG5uYNb/eXaur4Ut7OZuowxESO
	BiwOtA9Jcv89a/NHwc6ZKpMHrwyMReM=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-303b38ec2f6so11063978eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471948; x=1780076748; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tXuuAhgXpxxwMsr1wnQWACrH8a9haKBpqgpQfYI6/w=;
        b=O+ZI3KOSVM6MNTXygNVv4g2KFqMAgAUJS79+rm1KVrcyqqAxHc3QCdalz5oTsjzGjz
         g+1oz24qEHdMykwBMB/3l+YnL5wfE6obHrXxW49mA3IDsN4WkZEGFX1YpsNWcIrgKp33
         QxKincAv44IUtxF4XtVtB36Q+o88eFbF+ggH9q6bonRPBZ9/mkr+8MDxB3iylzWxXVxR
         kvuPA2+q/P5SXEslF7BVmw2dfZ7x9gY3T8oOzQkmMXfv2CDsdegwLoJVElbXcpbKmWkJ
         1jXfSwi+jCepOdq+bKKcIX+no5whNaj/CBjQNB94/L76Kehtlf63zI6A2oiFv4lGGski
         OGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471948; x=1780076748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tXuuAhgXpxxwMsr1wnQWACrH8a9haKBpqgpQfYI6/w=;
        b=da8z/KmFQ23NAClmyuxX55Vdiuek8aDxN3Bf5eLWs+u/qjlNezv+PTDEMYgaap4EJf
         16paax84WrcM/7NrjR7+DC7rkRf2GSxKeybC56oXHFcNNAx0dFqNhOtMeMHQZfOSDG0f
         ZP7mp5veRFLeL4oX9SKOUQi1+tHHhH3NIvKFxenWc4USlOm/E0cihqTye4E1qJNRPal1
         3omB6USB/acKTTPrYz/g9M7+nfvua9t5kKa0UYBs9i9dtGsR9h//l+m/1VS3DZ7n1Apm
         LeE/kCoXBnpqj6+11zyeXathFjA1g7q5LF3UyF2EnxHiyBpVslluSL32LKvuVzaf5zAk
         /gMg==
X-Forwarded-Encrypted: i=1; AFNElJ8qkN9XXLJLd7MXppQ41ZFeGWsU8Df1nUj2gMvAXb4+jaQvnFE5MRwSLpzPPqWIMpWnp5Oargr7Tg==@kvack.org
X-Gm-Message-State: AOJu0Ywo+TpMlE3PUbYRA0EPppuBeigrchu2nB43nCzDHBsPmyqWud6J
	ibve6PPf7jqssHbRdXg/iIaKS9Qd8473Y9c3Em5/IHUM0MQbcCDK8Z+sYjlX8+QA28l5HVh8VYI
	k0y7ub68TBhL4wnmSUZlXHWhyRSs737t/cg==
X-Received: from dyw1.prod.google.com ([2002:a05:7300:8801:b0:302:542a:8cad])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1f0a:b0:2de:cc07:e83 with SMTP id 5a478bee46e88-304490d3d01mr2242275eec.15.1779471947395;
 Fri, 22 May 2026 10:45:47 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:33 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fr3bs81y88pu5ie5kbu5ykh5w9jsp1ge
X-Rspamd-Queue-Id: C1B058001A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779471948-186344
X-HE-Meta: U2FsdGVkX1+OyXbgb/H5u3iIwETlv+A8c9GWQc7BjH9aFMhrp5qYtl9nECDXDQYVP9jNavREuUPoP8g6NtqjJWSdm4PzRveRtpYWl8dSiVfUVZ1ygsobxlX7VmkN+82hSXY1sNR22csOdRP/kBQM6bMjzIQaNQOSzE75tVvKE6pD++zOXvb/LWYfkBsr/4asY1WzPPUzK7wvXOXpAh93MZ6BGnY8DS/pUSYoGJ9YNvURFBwrt2eFYy32YlnnojcFUgsf5ku26EMyq9O0iphlNVPaVP2he0U3ndnVM/gIzvy46i6kxEEj+k/Kdb4UoEbIhOmt+54S6lfnnbvh3/Ut+0uuBTvklDXXvRKljOdL0KBL65iCkxXGzKa3uqkIF+pRhooODaTuEIsn2VBQgaQwGz85y+CuDCkx16TKIbHqkgBa1nxsKBglZAY9D3nc1QXMQ/L1Gg2LmzpIamQ/WGb3IaZiWNiDza1w5+KtE2WW1WcT8NwFkRTAe7b3/Bb+PGCRoKLh7wiOhOJeS5mDr+tDCH2Of2LLf50Ppn8yJ+VJr8lLVaqO2mqH4qsxeGspMaU6r5kEWAEyDldFKbborhNJuchYB4qnyVFEmkLasVt83WRN2fhMjqT9RX+j5yBRl3gpTGyxhEg3Xc1biWVAsvGwKJmaFKLUFuBYLNkE+b2YSvT00snqwEfWa8kvYbGQeMf5P6hNKUlNuWLhRXEyDIqOQ5ilAZ/fhqd61GLE/6QCW5lbUrViihJepgQN1bR/pwLjLoBfDZBOfxKaseCHKR/NMwx50GpVGRX6dBGtS/OfentQ5IQ5Uldn5eU/bHe5e4xJ/nYCLzuO3rWE4zigyx+RGZWWwp7pjgPbT3iTkAfkK4N7aVGRFeTYijuJk7g2NakF2MukNrFA9AEgQIh1nBMcRSIKAxkraKEcyCPO5oZz0xUi8GECEepwMsn14RZkGZ6PCN7bYVQ+d+xmQE2Q0jG
 HI6cjCP+
 pYKJYoGwMg2MNX1NJWVGonx6tn6GvS6zP7BZqbDuHKonrdi1syX+kL4H/+nuEdtT7+2/Z+J4Ba9+/fVdxESnbSRGSLaqsGdlOn3mIbcOGWqeOahzhhgejUWhO32dzpO8Vx/4iUKQNtr5v0vbgzlS8szxYQR13aF75QTgxtcuK2G2BbAR+gG1nd9iK3MP80lCXS+7uICGlWvXxnzO7z1C76ehzIAvHVrd4BSXuTpMtP3sWkT68XKk/dcD73lRT80zul8MJwvhRMegWMLv27FJdRS0YoqeJjiNBpmq582TEAvd+qd4PukPOUxkt6m3VYf3XpQt2aUPGCCh3L1q63I61PB4PlhWVzBOEhcWrnhSFat5CeEOgRiGXIJHMDiBOlzk3UizxCP8CiRr/gTVTY+R1fzaLe3Z+p45r1P7jrcVPHg8EvkFf9Sywldi2qQaxwcHRC4sQteWL/8K2Si5bGoR/Loxj2iqOAv6pJSrytAuVEIT+dEpIi9PqJhkCBlEZPYrK8dZNyuPGFLlgfL+zkmfc8BqVaTKE3q4deFiQ+uTqM9O8JgDnQg2WtmbP2R9kckFuNXBwqqnxzVuGUSimDGgEArC+VNb0ilus/2ef+Q6BOknGUpkP/Z2XY+0rh4bpPWofbJ5+OTw9OnWxC96p+cf+A+meyWWCXDljuuTn
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
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   1 +
 include/linux/codetag.h                       |   1 +
 include/uapi/linux/alloc_tag.h                |  54 +++++
 lib/alloc_tag.c                               | 193 +++++++++++++++++-
 lib/codetag.c                                 |  11 +
 6 files changed, 260 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h

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
index 46ed0f0e76d8..d176bde8fbfc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16709,6 +16709,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/uapi/linux/alloc_tag.h
 F:	lib/alloc_tag.c
 
 MEMORY CONTROLLER DRIVERS
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 8ea2a5f7c98a..2bcd4e7c809e 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -76,6 +76,7 @@ struct codetag_iterator {
 
 void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
 bool codetag_trylock_module_list(struct codetag_type *cttype);
+unsigned long codetag_get_content_id(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
new file mode 100644
index 000000000000..e9a5b55fcc7a
--- /dev/null
+++ b/include/uapi/linux/alloc_tag.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  include/linux/alloc_tag.h
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
+struct allocinfo_counter {
+	__u64 bytes;
+	__u64 calls;
+	__u8 accurate;
+	__u8 pad[7]; /* Add alignment to not break the 32-bit compatible interface */
+};
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
index b9ca95d1f506..3598735b6c93 100644
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
@@ -46,6 +48,10 @@ int alloc_tag_ref_offs;
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
+	/* ioctl uses a separate iterator not to interfere with reads */
+	struct codetag_iterator ioctl_iter;
+	bool positioned; /* seq_open_private() sets to 0 */
+	struct mutex ioctl_lock;
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
@@ -125,6 +131,190 @@ static const struct seq_operations allocinfo_seq_op = {
 	.show	= allocinfo_show,
 };
 
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
+static int allocinfo_release(struct inode *inode, struct file *file)
+{
+	return seq_release_private(inode, file);
+}
+
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
+	strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
+}
+
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
+static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_content_id params;
+
+	codetag_lock_module_list(alloc_tag_cttype, true);
+	params.id = codetag_get_content_id(alloc_tag_cttype);
+	codetag_lock_module_list(alloc_tag_cttype, false);
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
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
+	priv = (struct allocinfo_private *)m->private;
+	pos = params.pos;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype, true);
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
+	codetag_lock_module_list(alloc_tag_cttype, false);
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
+static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	struct allocinfo_tag_data params = {0};
+	int ret = 0;
+
+	priv = (struct allocinfo_private *)m->private;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype, true);
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
+	codetag_lock_module_list(alloc_tag_cttype, false);
+	mutex_unlock(&priv->ioctl_lock);
+
+	if (ret == 0) {
+		if (copy_to_user(arg, &params, sizeof(params)))
+			return -EFAULT;
+	}
+	return ret;
+}
+
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
@@ -989,8 +1179,7 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
-				     sizeof(struct allocinfo_private), NULL)) {
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
diff --git a/lib/codetag.c b/lib/codetag.c
index 304667897ad4..93aa30991563 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type *cttype)
 	return down_read_trylock(&cttype->mod_lock) != 0;
 }
 
+unsigned long codetag_get_content_id(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	/*
+	 * next_mod_seq is updated on every load, so can be used to identify
+	 * content changes.
+	 */
+	return cttype->next_mod_seq;
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
-- 
2.54.0.746.g67dd491aae-goog


