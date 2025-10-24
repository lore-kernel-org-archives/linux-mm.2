Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BA3CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E75F8E00CA; Fri, 24 Oct 2025 12:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A308E00C9; Fri, 24 Oct 2025 12:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D418E00CA; Fri, 24 Oct 2025 12:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 278988E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAFC4160EDD
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:08 +0000 (UTC)
X-FDA: 84033494496.20.E34584A
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F9E3180003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="FN/ZeDeJ";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGi3YkJalT3Q1XsBDOyYfr2SHo9OSDS0oxxt0K7ji6k=;
	b=iXurkkUGWVtr84+pTHFv2vW69nJkmwG2M/SwzjF8LuLZDOhOSCWHIrW1Wn11V+/YrQh8V3
	w1ZgCatLugpl4NrMXYP/qw3kO9cJJJa3PcIRltWFieZNYcZTh57BNQPZDuqx495iHeENjK
	z2HJ/1oSgZa8wfUMopBXRTbFETFkdpo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="FN/ZeDeJ";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322207; a=rsa-sha256;
	cv=none;
	b=AnL/9K8ZuzApQlARawc3bEhpxmrhNo1dWyAFj7G0I4sCr3kxALHQcsSbMxXUaDIQglWZFC
	dHPvz+p38myte/aBizBd/71yeBc7QtLtWzYVPiiOlJe2KRJv3MeFCW/GVbL3Cn7K6EhAQh
	u3jPNew8gj9+aUtGrPYSSitU6rp9KGA=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-783fa3af3bdso26855387b3.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322206; x=1761927006; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGi3YkJalT3Q1XsBDOyYfr2SHo9OSDS0oxxt0K7ji6k=;
        b=FN/ZeDeJ2ud7oui7iNtljQpC127SomxIjjqOGcAOzWJE8QHaYd94OituuUbn88+/TX
         rKYuNfnWNAZ+DvBvHI0OoXep/XfaCX71aeQiYq4GZllX3RKbvtv7763LzQ93V8Fv7tRc
         cjD4+WU11y0Dowf09uXiCQhpDAgRPt4cjrf6bx/mUu7iElJbxk2aWJ4wkXzNY5P8khbp
         IcGt1slAKMiSv0nIVQHYAoia4q1SCgKwohZKXdEtkKIOb/KnsoFY9+cUKCeqlAcCt8lc
         8URO6LH6wGH2Dm5y0wJFKDa3+kycZqjYANLIsIL4l9WkAh8KgClAOX/wCB2zYmdow5b/
         vI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322206; x=1761927006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGi3YkJalT3Q1XsBDOyYfr2SHo9OSDS0oxxt0K7ji6k=;
        b=bOPHvZsxYBhEwOJl7BXghcfBkPxLe7qvrnc1zfq47iG+jLzy7wQRcoABAQIHngE0vX
         J5/GJbmkrZTXNDHWLL/ZmKuUY3/sBFcy8oYaSQneoCannZa/zwlsG4b9nFR1s1GbWFf7
         65yd3gARAp+C6iZ775lTZTyhJCKAXsJdqTUqEkaMqLJBI2DLtYVaZuv/+vb7k9ahOf9y
         iKRjn6w+pUoOpZOglMWjcCbGOoPazenTRGyz6oqAqODQ0/lHFTeJCPcU5cG+axPBI11s
         cOB+bcMzWkKs8DolfmIbkXW0D9GyzCy0MuLYxmccRqXUi56S6YxzHbjhYxI+cKUsvBP/
         rLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVNfEywJau4emUhd1lea0e2Ups23ZrVPsWBBrL99x6YLug1m00H7Ze6W1UdDvpXustVrraqG0XWVw==@kvack.org
X-Gm-Message-State: AOJu0YxtcSBjHkigeURhNsb1pt0/DqPHML2c2lUBQc9QKWki6P8ODvQM
	AC1hsbM8RqIaf+wLu2MsnRndBr5UNgGUM3tq2Ghjq4n4ScBDYILWC3u1M7bkdpg668k=
X-Gm-Gg: ASbGncuWs5VJeVkk/3qCFUspS13rGpkDNCcHQsY4wBxXMwyKCVhsk+vOv8aIgg03seK
	zGi3o1aTzJskhDYZhSr3YEJvsG0XiX0kDGd0t0T3a6/Xutt5FG9k3MmMxpV76zyH8087KvPUW2W
	+ui3nLkc1dZRrlY8Z3/Fkvpmopsj+vP+Qo3VcbbpnnNSYn7qBjXDGHzRw/4edjrjstXUqFTGuk/
	X2vzir7uoxWV1wTRuu2ZNNvuG8coyPUWd6dIkYOPA0MZ0imdl5TROxVTNyUfrkfWvSe8U9ccmnl
	OzXDzt2WRGVr+T2DfvhlAu1DPhjs1fGUuq5sVu7hSemApqzW3H9Ial2AdVe02UqEabIJ29cfJI/
	i9oOI9ht4aZ2k8ARS9I7T9a4fGHMiifi1naHi7RhKyJRa4EFnMoyBnS1M42FJs/GF+NY8ZAEn77
	ubuGSI28WeyxpdjwkdLHjrjjECxrY12P8sIySx1Nwo4xpazjsOcqFa/IH49IGNJ+NsenRD8WXxL
	HHwq8WxqrBYjDwPq9AnbRNi0mbbaHWkCA==
X-Google-Smtp-Source: AGHT+IGCBUncqFwdegj1nIKiQJ0zvGzhhfJ9Kfw5HDrBRalX9t1H7m201KO+uSq0bq9de190LiRlLQ==
X-Received: by 2002:a05:690c:338b:b0:73c:d011:5769 with SMTP id 00721157ae682-785e02318fcmr25454717b3.52.1761322205946;
        Fri, 24 Oct 2025 09:10:05 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:05 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v8 2/8] kho: make debugfs interface optional
Date: Fri, 24 Oct 2025 12:09:56 -0400
Message-ID: <20251024161002.747372-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5n8eqdsehgkabueay6bbxthjpcknjyoq
X-Rspamd-Queue-Id: 4F9E3180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761322207-80678
X-HE-Meta: U2FsdGVkX1/ukxdwIhggFE97xvkOmMpXDTIJXupD9BIzqKd7Y7e6DWyKzImMvigifjefLG0xt0JMwjsZefc9h8ggV95wYyDZ67U2yDSKqRYWClKt4AqWaZxa+e+ygRL7sAW/F3fgNpTrQYJ5fGgo1yYh/wC9H0wr8m92JqaNbhL/SfmSPZjJOuHg5pageJltOMpeR3uDrAI2AIDKkHU6DRpDrdlPZuIS1lTM/KeQSRGweZ1sX2/7SsRIsf8FDHRIFOlaNZXtbLxZhk/vRUi08AtHMb5++2Hls06J2w2L+2wC0AxAQlyC0tAQrNfga8+SekV4f28aS8U6vB+hyjcaw8cXkX1uQUfjPvuLWe082swxxl9nMJ3eYgacYPehtEax7ms40mtTZ1SOvJbbuis5marVomhcleV2sjkdXno3YhNTGlzy6ppbMqxaW1JB5pzVNQ4ap6inafMK8GjH1FKRTs6p5xsjBKzsMWcroMzGlVi4IBFuh2A7TQq/n2ZcZfZBP9aCzH+Hfs4ktn/NW88PizPTolLXDCFg2enQSu/g2HbVlqK/gSTPQwyktgphy31qJl2wq55xvoFcDEgm6ryRS7/bfsaNDLGk7UNVMI0aVZjnbl3Jc3B9441I0iEIQcgzn3SsZ7SCQ5aWmPV+dtkws6Xl9Ag4dn4pgpCOo5EamwfTyTz4xc8f3ROkAMeU0cScb5aQXXWb9iqgIbVNiwb8tIaCO8yA9ljookbpvRwGjNjWAmMwY5u8X13OoxvuHCPTczEWWRRK///spqbBfewef2fznWnS1C53XaYMWOe3f1dOUYrHs9/q4TVRS69SeElu9Pj8r3Wm592mv5d6QMaXUdHFRz4gLccOopvulCJKvIrRlp9vwGcNv2MahMOqL7WfJUtb6ywQAiFolQq7FxyhASqu5FRLi/Z8nlfZxNcw1kD727IxghVnBrIyEU9Lv4EgN1PBKfxq53a1mnkon5d
 OEhAg2Fr
 9bd6juFyw3Geirzljzo7CkhG4EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, KHO is controlled via debugfs interface, but once LUO is
introduced, it can control KHO, and the debug interface becomes
optional.

Add a separate config CONFIG_KEXEC_HANDOVER_DEBUGFS that enables
the debugfs interface, and allows to inspect the tree.

Move all debugfs related code to a new file to keep the .c files
clear of ifdefs.

Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 MAINTAINERS                           |   3 +-
 kernel/Kconfig.kexec                  |  10 ++
 kernel/Makefile                       |   1 +
 kernel/kexec_handover.c               | 226 +++-----------------------
 kernel/kexec_handover_debugfs.c       | 216 ++++++++++++++++++++++++
 kernel/kexec_handover_internal.h      |  37 +++++
 tools/testing/selftests/kho/vmtest.sh |   1 +
 7 files changed, 286 insertions(+), 208 deletions(-)
 create mode 100644 kernel/kexec_handover_debugfs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5ea78444f035..35d7942b2082 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13815,13 +13815,14 @@ KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover.c
+F:	kernel/kexec_handover*
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index c94d36b5fcd9..9308a0fb1419 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -118,6 +118,16 @@ config KEXEC_HANDOVER_DEBUG
 	  scenarios and the extra code might be adding overhead it is
 	  only optionally enabled.
 
+config KEXEC_HANDOVER_DEBUGFS
+	bool "kexec handover debugfs interface"
+	depends on KEXEC_HANDOVER
+	depends on DEBUG_FS
+	help
+	  Allow to control kexec handover device tree via debugfs
+	  interface, i.e. finalize the state or aborting the finalization.
+	  Also, enables inspecting the KHO fdt trees with the debugfs binary
+	  blobs.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/Makefile b/kernel/Makefile
index 9fe722305c9b..2cf7909a74e5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -84,6 +84,7 @@ obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 6458f369a346..da071277d85e 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -11,7 +11,6 @@
 #include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
-#include <linux/debugfs.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/libfdt.h>
@@ -30,6 +29,7 @@
  */
 #include "../mm/internal.h"
 #include "kexec_internal.h"
+#include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
@@ -105,8 +105,6 @@ struct khoser_mem_chunk;
 
 struct kho_serialization {
 	struct page *fdt;
-	struct list_head fdt_list;
-	struct dentry *sub_fdt_dir;
 	struct kho_mem_track track;
 	/* First chunk of serialized preserved memory map */
 	struct khoser_mem_chunk *preserved_mem_map;
@@ -114,20 +112,16 @@ struct kho_serialization {
 
 struct kho_out {
 	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
 	struct mutex lock; /* protects KHO FDT finalization */
-
 	struct kho_serialization ser;
 	bool finalized;
+	struct kho_debugfs dbg;
 };
 
 static struct kho_out kho_out = {
 	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
 	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
 		.track = {
 			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
 		},
@@ -477,8 +471,8 @@ static void __init kho_mem_deserialize(const void *fdt)
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;
 
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
@@ -674,37 +668,6 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
-struct fdt_debugfs {
-	struct list_head list;
-	struct debugfs_blob_wrapper wrapper;
-	struct dentry *file;
-};
-
-static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-			       const char *name, const void *fdt)
-{
-	struct fdt_debugfs *f;
-	struct dentry *file;
-
-	f = kmalloc(sizeof(*f), GFP_KERNEL);
-	if (!f)
-		return -ENOMEM;
-
-	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
-
-	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
-	if (IS_ERR(file)) {
-		kfree(f);
-		return PTR_ERR(file);
-	}
-
-	f->file = file;
-	list_add(&f->list, list);
-
-	return 0;
-}
-
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @ser: serialization control object passed by KHO notifiers.
@@ -716,7 +679,8 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
- * ``/sys/kernel/debug/kho/out/sub_fdts/@name``.
+ * ``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with
+ * CONFIG_KEXEC_HANDOVER_DEBUGFS
  *
  * Return: 0 on success, error code on failure
  */
@@ -733,7 +697,7 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 	if (err)
 		return err;
 
-	return kho_debugfs_fdt_add(&ser->fdt_list, ser->sub_fdt_dir, name, fdt);
+	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
@@ -1064,29 +1028,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-/* Handling for debug/kho/out */
-
-static struct dentry *debugfs_root;
-
-static int kho_out_update_debugfs_fdt(void)
-{
-	int err = 0;
-	struct fdt_debugfs *ff, *tmp;
-
-	if (kho_out.finalized) {
-		err = kho_debugfs_fdt_add(&kho_out.ser.fdt_list, kho_out.dir,
-					  "fdt", page_to_virt(kho_out.ser.fdt));
-	} else {
-		list_for_each_entry_safe(ff, tmp, &kho_out.ser.fdt_list, list) {
-			debugfs_remove(ff->file);
-			list_del(&ff->list);
-			kfree(ff);
-		}
-	}
-
-	return err;
-}
-
 static int __kho_abort(void)
 {
 	int err;
@@ -1136,8 +1077,9 @@ int kho_abort(void)
 		return ret;
 
 	kho_out.finalized = false;
+	kho_debugfs_cleanup(&kho_out.dbg);
 
-	return kho_out_update_debugfs_fdt();
+	return 0;
 }
 
 static int __kho_finalize(void)
@@ -1206,92 +1148,23 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	return kho_out_update_debugfs_fdt();
+	return kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+				   page_to_virt(kho_out.ser.fdt), true);
 }
 
-static int kho_out_finalize_get(void *data, u64 *val)
+bool kho_finalized(void)
 {
-	mutex_lock(&kho_out.lock);
-	*val = kho_out.finalized;
-	mutex_unlock(&kho_out.lock);
-
-	return 0;
-}
-
-static int kho_out_finalize_set(void *data, u64 val)
-{
-	if (val)
-		return kho_finalize();
-	else
-		return kho_abort();
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-			 kho_out_finalize_set, "%llu\n");
-
-static int scratch_phys_show(struct seq_file *m, void *v)
-{
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(scratch_phys);
-
-static int scratch_len_show(struct seq_file *m, void *v)
-{
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(scratch_len);
-
-static __init int kho_out_debugfs_init(void)
-{
-	struct dentry *dir, *f, *sub_fdt_dir;
-
-	dir = debugfs_create_dir("out", debugfs_root);
-	if (IS_ERR(dir))
-		return -ENOMEM;
-
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
-	if (IS_ERR(sub_fdt_dir))
-		goto err_rmdir;
-
-	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
-				&scratch_phys_fops);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
-				&scratch_len_fops);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	f = debugfs_create_file("finalize", 0600, dir, NULL,
-				&fops_kho_out_finalize);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	kho_out.dir = dir;
-	kho_out.ser.sub_fdt_dir = sub_fdt_dir;
-	return 0;
-
-err_rmdir:
-	debugfs_remove_recursive(dir);
-	return -ENOENT;
+	guard(mutex)(&kho_out.lock);
+	return kho_out.finalized;
 }
 
 struct kho_in {
-	struct dentry *dir;
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
-	struct list_head fdt_list;
+	struct kho_debugfs dbg;
 };
 
 static struct kho_in kho_in = {
-	.fdt_list = LIST_HEAD_INIT(kho_in.fdt_list),
 };
 
 static const void *kho_get_fdt(void)
@@ -1355,56 +1228,6 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-/* Handling for debugfs/kho/in */
-
-static __init int kho_in_debugfs_init(const void *fdt)
-{
-	struct dentry *sub_fdt_dir;
-	int err, child;
-
-	kho_in.dir = debugfs_create_dir("in", debugfs_root);
-	if (IS_ERR(kho_in.dir))
-		return PTR_ERR(kho_in.dir);
-
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", kho_in.dir);
-	if (IS_ERR(sub_fdt_dir)) {
-		err = PTR_ERR(sub_fdt_dir);
-		goto err_rmdir;
-	}
-
-	err = kho_debugfs_fdt_add(&kho_in.fdt_list, kho_in.dir, "fdt", fdt);
-	if (err)
-		goto err_rmdir;
-
-	fdt_for_each_subnode(child, fdt, 0) {
-		int len = 0;
-		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
-		if (!fdt_phys)
-			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node `%s`'s prop `fdt` has invalid length: %d\n",
-				name, len);
-			continue;
-		}
-		err = kho_debugfs_fdt_add(&kho_in.fdt_list, sub_fdt_dir, name,
-					  phys_to_virt(*fdt_phys));
-		if (err) {
-			pr_warn("failed to add fdt `%s` to debugfs: %d\n", name,
-				err);
-			continue;
-		}
-	}
-
-	return 0;
-
-err_rmdir:
-	debugfs_remove_recursive(kho_in.dir);
-	return err;
-}
-
 static __init int kho_init(void)
 {
 	int err = 0;
@@ -1419,27 +1242,16 @@ static __init int kho_init(void)
 		goto err_free_scratch;
 	}
 
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root)) {
-		err = -ENOENT;
+	err = kho_debugfs_init();
+	if (err)
 		goto err_free_fdt;
-	}
 
-	err = kho_out_debugfs_init();
+	err = kho_out_debugfs_init(&kho_out.dbg);
 	if (err)
 		goto err_free_fdt;
 
 	if (fdt) {
-		err = kho_in_debugfs_init(fdt);
-		/*
-		 * Failure to create /sys/kernel/debug/kho/in does not prevent
-		 * reviving state from KHO and setting up KHO for the next
-		 * kexec.
-		 */
-		if (err)
-			pr_err("failed exposing handover FDT in debugfs: %d\n",
-			       err);
-
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
 	}
 
diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
new file mode 100644
index 000000000000..a91b279f1b23
--- /dev/null
+++ b/kernel/kexec_handover_debugfs.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_debugfs.c - kexec handover debugfs interfaces
+ * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) "KHO: " fmt
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/libfdt.h>
+#include <linux/mm.h>
+#include "kexec_handover_internal.h"
+
+static struct dentry *debugfs_root;
+
+struct fdt_debugfs {
+	struct list_head list;
+	struct debugfs_blob_wrapper wrapper;
+	struct dentry *file;
+};
+
+static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
+				 const char *name, const void *fdt)
+{
+	struct fdt_debugfs *f;
+	struct dentry *file;
+
+	f = kmalloc(sizeof(*f), GFP_KERNEL);
+	if (!f)
+		return -ENOMEM;
+
+	f->wrapper.data = (void *)fdt;
+	f->wrapper.size = fdt_totalsize(fdt);
+
+	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
+	if (IS_ERR(file)) {
+		kfree(f);
+		return PTR_ERR(file);
+	}
+
+	f->file = file;
+	list_add(&f->list, list);
+
+	return 0;
+}
+
+int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+			const void *fdt, bool root)
+{
+	struct dentry *dir;
+
+	if (root)
+		dir = dbg->dir;
+	else
+		dir = dbg->sub_fdt_dir;
+
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+}
+
+void kho_debugfs_cleanup(struct kho_debugfs *dbg)
+{
+	struct fdt_debugfs *ff, *tmp;
+
+	list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
+		debugfs_remove(ff->file);
+		list_del(&ff->list);
+		kfree(ff);
+	}
+}
+
+static int kho_out_finalize_get(void *data, u64 *val)
+{
+	*val = kho_finalized();
+
+	return 0;
+}
+
+static int kho_out_finalize_set(void *data, u64 val)
+{
+	if (val)
+		return kho_finalize();
+	else
+		return kho_abort();
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
+			 kho_out_finalize_set, "%llu\n");
+
+static int scratch_phys_show(struct seq_file *m, void *v)
+{
+	for (int i = 0; i < kho_scratch_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(scratch_phys);
+
+static int scratch_len_show(struct seq_file *m, void *v)
+{
+	for (int i = 0; i < kho_scratch_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(scratch_len);
+
+__init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
+{
+	struct dentry *dir, *sub_fdt_dir;
+	int err, child;
+
+	INIT_LIST_HEAD(&dbg->fdt_list);
+
+	dir = debugfs_create_dir("in", debugfs_root);
+	if (IS_ERR(dir)) {
+		err = PTR_ERR(dir);
+		goto err_out;
+	}
+
+	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
+	if (IS_ERR(sub_fdt_dir)) {
+		err = PTR_ERR(sub_fdt_dir);
+		goto err_rmdir;
+	}
+
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	if (err)
+		goto err_rmdir;
+
+	fdt_for_each_subnode(child, fdt, 0) {
+		int len = 0;
+		const char *name = fdt_get_name(fdt, child, NULL);
+		const u64 *fdt_phys;
+
+		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
+		if (!fdt_phys)
+			continue;
+		if (len != sizeof(*fdt_phys)) {
+			pr_warn("node %s prop fdt has invalid length: %d\n",
+				name, len);
+			continue;
+		}
+		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
+					    phys_to_virt(*fdt_phys));
+		if (err) {
+			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
+				err);
+			continue;
+		}
+	}
+
+	dbg->dir = dir;
+	dbg->sub_fdt_dir = sub_fdt_dir;
+
+	return;
+err_rmdir:
+	debugfs_remove_recursive(dir);
+err_out:
+	/*
+	 * Failure to create /sys/kernel/debug/kho/in does not prevent
+	 * reviving state from KHO and setting up KHO for the next
+	 * kexec.
+	 */
+	if (err)
+		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
+}
+
+__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
+{
+	struct dentry *dir, *f, *sub_fdt_dir;
+
+	INIT_LIST_HEAD(&dbg->fdt_list);
+
+	dir = debugfs_create_dir("out", debugfs_root);
+	if (IS_ERR(dir))
+		return -ENOMEM;
+
+	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
+	if (IS_ERR(sub_fdt_dir))
+		goto err_rmdir;
+
+	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
+				&scratch_phys_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
+				&scratch_len_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	f = debugfs_create_file("finalize", 0600, dir, NULL,
+				&kho_out_finalize_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	dbg->dir = dir;
+	dbg->sub_fdt_dir = sub_fdt_dir;
+	return 0;
+
+err_rmdir:
+	debugfs_remove_recursive(dir);
+	return -ENOENT;
+}
+
+__init int kho_debugfs_init(void)
+{
+	debugfs_root = debugfs_create_dir("kho", NULL);
+	if (IS_ERR(debugfs_root))
+		return -ENOENT;
+	return 0;
+}
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
index 05e9720ba7b9..28c0e971613d 100644
--- a/kernel/kexec_handover_internal.h
+++ b/kernel/kexec_handover_internal.h
@@ -2,8 +2,45 @@
 #ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
 #define LINUX_KEXEC_HANDOVER_INTERNAL_H
 
+#include <linux/kexec_handover.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
+#include <linux/debugfs.h>
+
+struct kho_debugfs {
+	struct dentry *dir;
+	struct dentry *sub_fdt_dir;
+	struct list_head fdt_list;
+};
+
+#else
+struct kho_debugfs {};
+#endif
+
+extern struct kho_scratch *kho_scratch;
+extern unsigned int kho_scratch_cnt;
+
+bool kho_finalized(void);
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
+int kho_debugfs_init(void);
+void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
+int kho_out_debugfs_init(struct kho_debugfs *dbg);
+int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+			const void *fdt, bool root);
+void kho_debugfs_cleanup(struct kho_debugfs *dbg);
+#else
+static inline int kho_debugfs_init(void) { return 0; }
+static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
+				       const void *fdt) { }
+static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
+static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+				      const void *fdt, bool root) { return 0; }
+static inline void kho_debugfs_cleanup(struct kho_debugfs *dbg) {}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
+
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
 bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 #else
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 3f6c17166846..49fdac8e8b15 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -59,6 +59,7 @@ function build_kernel() {
 	tee "$kconfig" > "$kho_config" <<EOF
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_TEST_KEXEC_HANDOVER=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_VM=y
-- 
2.51.1.821.gb6fe4d2222-goog


