Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE1EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFEFE6B008A; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF7F6B008C; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D507F6B0092; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90AE66B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FB66402A0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:34 +0000 (UTC)
X-FDA: 84966376908.06.DCD7B9A
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5795A2000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wMb9+pRt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WR6QxsaPCrt++TY3BJQ5aI/b4y1G/4uhZ8ktrx9hHco=;
	b=WPQeJhzDblq1X1R3U53jXAuJhGQRR7uXtKRqqVzXdr9oaMGlT8eL8308vJR0ldyLLYHGZ0
	o+YYyBxPy/MQVkH6ZQRFwEYxmpRJfvYNNRzjsnMXqI7e0Q7f8B3L5LLMR4fb9a5vOvgS/s
	ldRXdUH+ar7r64QDTRS98KXLs/3xelI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wMb9+pRt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533692;
	b=FxjmBw4KfsDHUAFNtfWitN6VJdJt2S2q8QedlRxkrNuEC738dCI7cSenfePsvaylipFv+D
	R1CV1i99hvcigdaGadlglM80eNgH0P2HE8M8B3P8eT6tjJuA62XL9+xdfN68az5qIdl1rx
	AKdT0Oze9vMnj2E9i+bIeVCXJxTNfds=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c89956023dbso1411269a12.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533691; x=1784138491; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WR6QxsaPCrt++TY3BJQ5aI/b4y1G/4uhZ8ktrx9hHco=;
        b=wMb9+pRto0mYxzau4Wg4qSpDYpKv0XUYDrP0nO6p9K/9bxzLUmiW6h3oG6NxJf83K0
         FkfmRWMFTaQvuKr2/a0XgAaWNkaDp7K5m1VmBex/V6QDyQykrHsCyKNBhJHN9c6VAy1c
         0+EcGz6LNVHiQ8WFZvd4EsucTAzUfIOV0tjV5X6mMbvb7s4Ea1ywFup1XvQBZ+kT6fhN
         xAMQbP0Wi+Wbe3hHdTInR3Nl91AmykNOxRxGeeUEd1EQfriPI62CQy2hduVBD9x38FN0
         9PDUg1gJoVoRUJlGymgiSfzGOaE4GVy5U2KinHXREKCPj8OqBy5dXXl5U76Ct9QyhTbb
         2WcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533691; x=1784138491;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WR6QxsaPCrt++TY3BJQ5aI/b4y1G/4uhZ8ktrx9hHco=;
        b=FAZlFhSJvPkVWnIfks1RQgZH7myQcV/r2VMcj6LY9+kiTtL77IAkOe0oE6wQ1ZwUHe
         MM71hIeCQyJZCsc4al7eyF2jeh9FDpMuqdApBBGnkDuolE8GU6oCNEnfNpbtgz2aNqJw
         sfK+YEh9FTebZP8KavNax3k5cUK1K2D+VW0T8e83Pg1Slhc6LEooDFo1F6wAqY0jBy0o
         ik9Y12fCXZbky30PIqN08EXgGvcdTabihMrCKuujI1dxnF9fH4d58l78dwqrZpXJoZ1D
         LmsYVqz36spRiii2hmkrvLWo9YdBkKkIndfIIn1asLLke4LQ3Kq+fcSmLW/Jlk/X5tVG
         mFog==
X-Forwarded-Encrypted: i=1; AHgh+RpdID3nb5i+qqnLmFtm9qOjB2lEfXcOpHmlveJ3CrvqE0qlv3vSjdObwlnKqtbOnCgrDXJoPxfBIw==@kvack.org
X-Gm-Message-State: AOJu0YzUf2ZbWUkvqznkpi4P/7EwudkdF+NNB7kt0YULYDW5BIe3rV0v
	5s9uVoX5pgPEhFxyCCMs59UQY14gihAbMbvt+cABVhKhhB/+FnF7lxLHmKcLgiNhQXlHmS1riAd
	3o5/Xjnh3hrNoXmtrIGVbTvOBxXwdWLan6g==
X-Received: from dlbov11.prod.google.com ([2002:a05:7022:118b:b0:13b:54e0:b3c3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:682:b0:3c0:9c1a:893c with SMTP id adf61e73a8af0-3c0bcce3492mr4220807637.68.1783533691103;
 Wed, 08 Jul 2026 11:01:31 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:23 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <15596de2607ef13e7c77c6d74763f4ae992ec475.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: stob3o8dn5d1wr9nh6y5njoae3738mu3
X-Rspamd-Queue-Id: 5795A2000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783533692-211203
X-HE-Meta: U2FsdGVkX18ckmK0hPf+ORqlBXfJUyvd/t2YvFUPnnzHLnM5WjVsLFviKDz/Dtpas51BZNq4EUt4s4Y4u0+0hH4sQrMNKmRtt3dZkrLueKgF+WDLSZ34BLT4DjXEDi4lrxijMPrWsKRijeFTSwUSMS49Mklhkv3+eaicUSTPpsu0neqKewE51+w8g5DzsXH47Oi/V7o5tPu9YS2TxDinMjQZT+ES4ryWfQqMVEuEyYesDqXoTfP420I8UZ5unm2h21/RCZ2xilKblXbzwBREvo46E2YedfzM9j/N25zzqg5F42hrWAp3o8pTaCVcF4SkpN7mO9dmjW2ELzKTZn0hYHLOYpJvVKEZnrj+uxiPocWo2liRgA6zh5njynML0m7Mtl91LSXl+0FK0l0FmlgEqd9hu02mMi2eJMZrQcFtr0D76y8pvmbr4tvzpHZWmxvr+yTM8T09o1nvT1YtPAmZmleLYYRjzA+OySNKdyZwTLslLhouZIXel02cWcBHaKSI0mV/+4DYch4yzrdUuCqsQMxBZqwrnAJdRI8eu9rBk+OUm6AZKxCDA2qnOJ8YZ6kufn10kgtWdc/Izuv1643FjSF6ue79mJejaZUu5udooA+ACfeRH27invV2AmRz7ZXCuEiSUBRf0T6ssbKujiQMPjpJsf48yjAYgw0E7xpP/Er8xqnrP7pmrRcQshD4sY+c9dIWLUCEYEtiW2bfcmCfpTqGgEcPssw98i7GK8bU3T54bdkJRPSXB+vBMbMn+HqhuJ6O0Dui41Lz9T10MbLyDsBTntjpVDNakTjM5q6HUcSVgYj1uW6SkaaDlL4Qg2TZvF4wXewI7PL3cqx0omdaBiUr7iW/mDO+86t/6GTKFxu3qqLYfP8q7yz67CZfZoKFS2dMf5eI9vxHcpHRIae6jmnpDErWCEU+k9lmajHIMXSektrO70vLtSR+QkLWUdZKJX+wV3zpvYe/X9CRSIx
 8tPlEHLi
 D4IEk3e4VOZ1MizitxY6LUv+hoW9jund1PdkcMVEIb77eUPXnaeLtjMgcCRYX3mY2QIMBqBvNvLQ0tixRzswTnw11RPt/RQ3stCRaia/ivxMaQVyrYFnJ0JupA6k5aMdLHtuwyvpouG+e7ECQ8Toqx3Jp0yst48iikcciXQav2jPbI+jMo9iioSUE0eUxoiSC5O8pjoLibhsbui/RtXtfwNYw7YuoDVqPePFjnLjnChtc8zn22Ig/3p9GKonsLfaosUXKLyXVfL1vpx5m1NIfj50y11i+HNQLWneVoUoxToemdjwTnugqLhsZcydZuL3NfAyvXz93QczDaq1N3eoc9C025apyMteJnZGgF/nub41VBNiKH7qGcJwXS/0abobCmlPB/sMdgGYZ3f2ccmUL0H69L5QpgwxbSV+bCurS/I/RVa86Ewqu50M7YzMaegX5BdxNd0F8zLD6sA+8rk/3Dmkyb9lNEbJbOkBlHyEzCJ17hnLK0P2mLar0wZExrq9D4rBp41AXcvmrb+s+SNZNSzTgIHJtMZ/78mt459ek481De1eSFwxfQxNR1X9WwAsm8xovyPXmXkWE/7iuPLgWlID5k3dT2LHmNGyXlZwpOMjQ8BKRNM/v7tmGVgYfUnPzINIuKsrrbFDR/h7qjLbHT3TrIiQd1u65K3SKbXm5F4OTGcLn25e0Kuf2l19cTQzqoks0RdsmIWaiAJamMkTTSL7cLorVvn9lYzhx
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
 lib/codetag.c                                 |  18 ++
 mm/alloc_tag.c                                | 238 +++++++++++++++++-
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
index 3f0ef1e27eb0..2fc53093752d 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -346,6 +346,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:luzmaximilian@gmail.com>
 0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
                                                                        <mailto:luzmaximilian@gmail.com>
+0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
+                                                                       <mailto:surenb@google.com>
 0xAA  00-3F  linux/uapi/linux/userfaultfd.h
 0xAB  00-1F  linux/nbd.h
 0xAC  00-1F  linux/raw.h
diff --git a/MAINTAINERS b/MAINTAINERS
index d19822d574fd..8e316eba7b4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16936,6 +16936,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/uapi/linux/alloc_tag.h
 F:	mm/alloc_tag.c
 
 MEMORY MANAGEMENT - BALLOON
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
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index cf65e9992fda..c414117e1e97 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
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
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -50,6 +52,10 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	/* ioctl uses a separate iterator not to interfere with reads */
+	struct codetag_iterator ioctl_iter;
+	bool positioned; /* seq_open_private() sets to 0 */
+	struct mutex ioctl_lock;
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
@@ -133,6 +139,235 @@ static const struct seq_operations allocinfo_seq_op = {
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
@@ -984,8 +1219,7 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
-				     sizeof(struct allocinfo_private), NULL)) {
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
-- 
2.55.0.795.g602f6c329a-goog


