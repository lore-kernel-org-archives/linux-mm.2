Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BC7D6D232
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31136B0095; Thu, 18 Dec 2025 10:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08D16B009D; Thu, 18 Dec 2025 10:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88446B009E; Thu, 18 Dec 2025 10:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB066B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:58:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61715138C47
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:01 +0000 (UTC)
X-FDA: 84233047962.22.420E78C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7522814000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:57:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FAzQFX5I;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766073479; a=rsa-sha256;
	cv=none;
	b=ew+cNoeUw2EUZSe5Q8dXHrmXZ8kHdS/XJcQQDEC98vfAxvp9XbuWsJmUavLNfNwBdOt4g8
	2ExRbfhbBMhh78URDanzFl0HBXVEKkj955kvPvsemJhavALwh9+AtocjYiwtVdmfJ07GET
	dBT49ojtCfO5mYw477XwM7KNf9Nj6BU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FAzQFX5I;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbo/Q10fOjWM8sV0DuXlsI6QStMFfk28dpPwdp8oFO4=;
	b=XylsmPKTO4jOl5P1+Osuz9tq6zPXhcsvQg7PfIJmsoMfv6WvqXP8WMACXzNUcracIPZ6em
	0mC3SX81u1jjALezL3k/5i4xQknBnOP/5rZ4UPDkT0oD4S1Z3LxGt3QfHdwZJABa5cMZg+
	HPO/Zvxuo8/Myd4vsYmKuXR5tFmJ/MQ=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78c66bdf675so6489367b3.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766073478; x=1766678278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbo/Q10fOjWM8sV0DuXlsI6QStMFfk28dpPwdp8oFO4=;
        b=FAzQFX5Iwxe4PhUn4C6Rrrf+/Ys6ClPNRpfgpyTyZs7Q24pqVGpCjNO3bde4hOBqof
         8TX1UbrUfX1ARvueeGctiggrsl4PesKijNzAldssDpH7w1w5wqDe7pNG5istjbysIs4q
         ON5UWYdWxMVZyZJOKng4nBCOjUFSUYEML039YXIuFqH2YXK+bidL+O3J/kBASxZYlj5q
         HCE1HR3krDseMol1Yy6neUQxjGxhivVoFXWYpIFvyYvp5ZAEXKmBU057FGvOjQakZtV7
         QBbNNGIy1zjoLPYCL5L295gZUxsJ7bnB2zBNtkvDM6MG7QbMpJl8BB2MLUa92mRB3Aev
         H5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073478; x=1766678278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kbo/Q10fOjWM8sV0DuXlsI6QStMFfk28dpPwdp8oFO4=;
        b=unVrUzr5TUdyV1s1LeWP1HJE3Aq/Wva+e5SWXjadpvO27mInJyf3PpYl08uh7q2Z4V
         XT8k5rjWu4NyrC3qbBdavgNNStLfJkoobc1ArDktnMoXOKiSF5Mag1L8/d/NHTXLv24G
         kTTtSC8HT8ZHE5g+7tuZ43BfOvLfdRZypGd53GgCx0/J8MR8v73GoGDQT2eGZVCAcac3
         FgUczV7sQV9j7Gdunc4MWCvxm5V7M2hEQMyY1exqPmLhzw7uerjRudnH8DQyjJEfodvG
         eMl0lgXEMj5XHd1PdMvNZhOJNy7Ac6Em0MOAkOCs24qhYc+X5vJTDVzStVIvvRUguNeV
         MI/A==
X-Forwarded-Encrypted: i=1; AJvYcCXFFZ7IZv8+xPREAn1qOZfPJ16VXc/qWqLkv9mUJhdF6lcl6tRhdjbvA3CeNhXol+uEHwqDnvVdfQ==@kvack.org
X-Gm-Message-State: AOJu0YycQPmo3hgccnKBvv0HVCC5iObCJtiBx3bi+rrULxupubhlYtuJ
	/QIjz6KpV7GQarPq8FwHr62zJX1N5lJqKjDtayVSiRtNXVkFducKIEA+kj75lk5Tphs=
X-Gm-Gg: AY/fxX6pZDdDAu/KWY/iLGMl9RIveeH7p9xl33oWw1oYyvWn5S7wp9hKc5ZwSqTAIJB
	tDfbfepB0cWVWXS+ktas+T6mbo8EL8/vHXfb72Ed91lK4WTREvKM6QJ8crm0DtV0+Ykl0dCki+G
	W2nVhIquQQG50FGjH7yxSG3yCdRb9OXK6gDVNuRqCwog2jvh7eqGygMOVg0hdck9K3/o/tFskWF
	+6ip/GKrKayoG1TaaIvPEKykYg01oSqmoS+MN7y7A1ThcIzYPnyRuf21zQfR61LDHzIAjsK0pPf
	r9dserlorn1WgBZ2KgJezaN+XvplaA1hZfCgfr6F2UAsWYS7cDlb9hVVyvZGeh1qokdtBAqikuf
	SjpAWoyr5L6zoJeBF/Q5K8rL2lgVtrnlNkjwjN9r24CMX6FGEUQBownIdqqMxKb6IxmqHSss1Bm
	+w5h6LO9UwFqL4+MUBMMp5BcT3Zk+c0uMRwRptYJ+p798SjKfWNJ0QCR6Uzs44wfhHzXhtJyLXD
	A8JlXmXA/m44APis/LEQLhRMm7iJmLRqqiN3Q==
X-Google-Smtp-Source: AGHT+IHF15CHFSvn2iw7JiSe1zOiuiDDwSN7HW3uphvKiqLN0UcGgr621SGo4sNapWA5IhaiEHGrRw==
X-Received: by 2002:a05:690c:488a:b0:78a:6fd9:ef49 with SMTP id 00721157ae682-78e66951cb2mr177183317b3.14.1766073478421;
        Thu, 18 Dec 2025 07:57:58 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f52bb2sm9348467b3.16.2025.12.18.07.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:57:57 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	skhawaja@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	akpm@linux-foundation.org,
	kees@kernel.org,
	davidgow@google.com,
	pmladek@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nicolas.frattaroli@collabora.com,
	linux-doc@vger.kernel.org,
	tamird@gmail.com,
	raemoar63@gmail.com,
	graf@amazon.com
Subject: [PATCH v2 1/5] list: add primitives for private list manipulations
Date: Thu, 18 Dec 2025 10:57:48 -0500
Message-ID: <20251218155752.3045808-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
In-Reply-To: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7522814000C
X-Stat-Signature: am3p6uwkrs4dmz8uscupiruegng8enzm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766073479-846500
X-HE-Meta: U2FsdGVkX18CCyoe2rsIPqIl0xtFgc+syYXLHJ6miQMe2DVrMB+3+qHPna/xkUfpiZvrJ8npOdK6juLMp8pBqqtuzYZzejXrrdfByD+xfmvpFkAm6GMsLyAO4cdrR7qcAA2ud28z6McPKjIrODZPR/74M6rkIpXPkm+Q7YfHxnw4jK1rfu+IZqY7N1qbCN3Q3WEAXYgjyquz7uQseJva8Pylm/9vRPRq/3DOUGY0OrEEVHE694xpyftkEd3d81JepI3bLrUdHNcE0cr2/rGB2XSnPHZy/Ak2eXV5zVt/jvWRnsN+rPpyKmbvJprfA9yrL0UQuT2or9SFnbRcTwomlrlUHgsD0n1pBkUgsyRI5A/EMP+0fgk9fo68gYHvQM10zCeU6dCvFibnbwxnG/5iwdHdviL1B0YY7Wb6W17L076Tn62tGB9lo+f8+WA/Vv56LIP09c83KWCK3dCzRLS1lDvzzCE3dwavM3ReyDrWHr9jZhuH8XPUqnsqriNQfMKBVSXXkHIt0aNTf+WNJRCPvKWUZ2/dFKRgcKflO4xcRJdDstm7uxpmMHGhcSVqedwyDirN1//KiOIzUH1wzXTIokEEbH9jdB1fz8bDZ6vhdO2w3kES9zjMzAFjYaVfUATFsgzSlcjoUs30UMwfGnQzNpcAY4Y8KY5lQWv6hkJzye3E48PHh5oPxOQQRvTLlcS3eDL74z/jUJDf+s3IX+iuHL99eaeQcycwDzbauHCw91l6Gk3LJxBG8/TlUuSHMDFf86FUHmTpWXqa7N6GMRD2ZYOfOzbYbKIELocR9DlTgk7iU9orRfBVcts6pZUcQ9COSyJcCO5XtVWoeFIyd8kqEFnefG5EpwV1jV5YQMM7nGZTL1C2EqKzIy8JXymKodAiYtrVfPm8167hqKVLI0TiUeztHBHgD0n0ub8q5lKOw6eV47qX8eBSBTUmWe7ruG1ThtLa2VtgBR7XnoOrrx5
 /Mt6PSWM
 idqTP83Z1x4NjTm4ANbO2UyJAHpJ9fMrUic1biu7m2/V0w7HAbJKw1w0iLUKLC7GdKKrgrnacR2yK0pDsqZRh+dI5KzidInLkooHIPYPkyBTxsSdLh9gHny+TSkquWiM+QaJgpdgOt4dHWWv9KLJJDHMXoUqGJoEnU/fVhTsfRjRAKLOrmeaBVyTRYeurzfkhs/N2K8NmWkRwGpVVoTrN4FlP7nxUyFphFzmqZPUlxnSti/JdEFTt27XYnXDNMvopHhJfudO+YeDS0Bl13dg2XahTWHOSEjPhzZky
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linux recently added an ability to add private members to structs (i.e.
__private) and access them via ACCESS_PRIVATE(). This ensures that those
members are only accessible by the subsystem which owns the struct type,
and not to the object owner.

However, struct list_head often needs to be placed into the private
section to be manipulated privately by the subsystem.

Add macros to support private list manipulations in
<linux/list_private.h>.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/list.rst |   9 ++
 include/linux/list_private.h    | 256 ++++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)
 create mode 100644 include/linux/list_private.h

diff --git a/Documentation/core-api/list.rst b/Documentation/core-api/list.rst
index 86873ce9adbf..241464ca0549 100644
--- a/Documentation/core-api/list.rst
+++ b/Documentation/core-api/list.rst
@@ -774,3 +774,12 @@ Full List API
 
 .. kernel-doc:: include/linux/list.h
    :internal:
+
+Private List API
+================
+
+.. kernel-doc:: include/linux/list_private.h
+   :doc: Private List Primitives
+
+.. kernel-doc:: include/linux/list_private.h
+   :internal:
diff --git a/include/linux/list_private.h b/include/linux/list_private.h
new file mode 100644
index 000000000000..6f93d54e797a
--- /dev/null
+++ b/include/linux/list_private.h
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_LIST_PRIVATE_H
+#define _LINUX_LIST_PRIVATE_H
+
+/**
+ * DOC: Private List Primitives
+ *
+ * Provides a set of list primitives identical in function to those in
+ * ``<linux/list.h>``, but designed for cases where the embedded
+ * ``&struct list_head`` is private member.
+ */
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+
+#define __list_private_offset(type, member)					\
+	((size_t)(&ACCESS_PRIVATE(((type *)0), member)))
+
+/**
+ * list_private_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_entry(ptr, type, member) ({				\
+	const struct list_head *__mptr = (ptr);					\
+	(type *)((char *)__mptr - __list_private_offset(type, member));		\
+})
+
+/**
+ * list_private_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_first_entry(ptr, type, member)				\
+	list_private_entry((ptr)->next, type, member)
+
+/**
+ * list_private_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_last_entry(ptr, type, member)				\
+	list_private_entry((ptr)->prev, type, member)
+
+/**
+ * list_private_next_entry - get the next element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_next_entry(pos, member)					\
+	list_private_entry(ACCESS_PRIVATE(pos, member).next, typeof(*(pos)), member)
+
+/**
+ * list_private_next_entry_circular - get the next element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the last element (return the first element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_private_next_entry_circular(pos, head, member)			\
+	(list_is_last(&ACCESS_PRIVATE(pos, member), head) ?			\
+	list_private_first_entry(head, typeof(*(pos)), member) :		\
+	list_private_next_entry(pos, member))
+
+/**
+ * list_private_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_prev_entry(pos, member)					\
+	list_private_entry(ACCESS_PRIVATE(pos, member).prev, typeof(*(pos)), member)
+
+/**
+ * list_prev_entry_circular - get the prev element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the first element (return the last element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_private_prev_entry_circular(pos, head, member)			\
+	(list_is_first(&ACCESS_PRIVATE(pos, member), head) ?			\
+	list_private_last_entry(head, typeof(*(pos)), member) :			\
+	list_private_prev_entry(pos, member))
+
+/**
+ * list_private_entry_is_head - test if the entry points to the head of the list
+ * @pos:	the type * to cursor
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_entry_is_head(pos, head, member)				\
+	list_is_head(&ACCESS_PRIVATE(pos, member), (head))
+
+/**
+ * list_private_for_each_entry - iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry(pos, head, member)				\
+	for (pos = list_private_first_entry(head, typeof(*pos), member);	\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_private_last_entry(head, typeof(*pos), member);		\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_private_for_each_entry_continue(pos, head, member)			\
+	for (pos = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_continue_reverse - iterate backwards from the given point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Start to iterate over list of given type backwards, continuing after
+ * the current position.
+ */
+#define list_private_for_each_entry_continue_reverse(pos, head, member)		\
+	for (pos = list_private_prev_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_from - iterate over list of given type from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing from current position.
+ */
+#define list_private_for_each_entry_from(pos, head, member)			\
+	for (; !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_from_reverse - iterate backwards over list of given type
+ *                                    from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, continuing from current position.
+ */
+#define list_private_for_each_entry_from_reverse(pos, head, member)		\
+	for (; !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_private_first_entry(head, typeof(*pos), member),	\
+		n = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_continue - continue list iteration safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_private_for_each_entry_safe_continue(pos, n, head, member)		\
+	for (pos = list_private_next_entry(pos, member),			\
+		n = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_from - iterate over list from current point safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_private_for_each_entry_safe_from(pos, n, head, member)		\
+	for (n = list_private_next_entry(pos, member);				\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_reverse - iterate backwards over list safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_private_for_each_entry_safe_reverse(pos, n, head, member)		\
+	for (pos = list_private_last_entry(head, typeof(*pos), member),		\
+		n = list_private_prev_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_prev_entry(n, member))
+
+/**
+ * list_private_safe_reset_next - reset a stale list_for_each_entry_safe loop
+ * @pos:	the loop cursor used in the list_for_each_entry_safe loop
+ * @n:		temporary storage used in list_for_each_entry_safe
+ * @member:	the name of the list_head within the struct.
+ *
+ * list_safe_reset_next is not safe to use in general if the list may be
+ * modified concurrently (eg. the lock is dropped in the loop body). An
+ * exception to this is if the cursor element (pos) is pinned in the list,
+ * and list_safe_reset_next is called after re-taking the lock and before
+ * completing the current iteration of the loop body.
+ */
+#define list_private_safe_reset_next(pos, n, member)				\
+	n = list_private_next_entry(pos, member)
+
+#endif /* _LINUX_LIST_PRIVATE_H */
-- 
2.52.0.313.g674ac2bdf7-goog


