Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AF1EB4917
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8776B0095; Thu, 12 Feb 2026 07:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6246B0096; Thu, 12 Feb 2026 07:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC9F6B0098; Thu, 12 Feb 2026 07:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDFA6B0095
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:50:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3297FC029F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:09 +0000 (UTC)
X-FDA: 84435787338.06.3AD9B01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77D5880008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aUIK2xj/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900607; a=rsa-sha256;
	cv=none;
	b=s6L+XFQTDUHWK0I00AFW25ZxpWQkMmX0Gsc/KkcxyS4vY21hipjvxWWv1aW2TKUlj/pUv4
	r8IqIf0k4TjVIb1QB1AaVIIVJnjnVd9GSh1ccjBnnyIhcknU5tLYpGDnOIHSzvonbwfL6o
	DRCI8SsyqJlYoDCz2vsjAjIdyt1QShg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aUIK2xj/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nit8m3oaYzPkr/DHNj61xP6u3VIDPL4n4HKttTvb6ow=;
	b=UeJehrsN1xptJS1/dfopg/6jQ9mpbOJ6Wu7MgAFKT4G0peLQIgF09DUmxY4XuwZGZPTRRq
	Q3BKDCg6VFG4ST0T6wl9ExvGhdzy532KggNcSCK1hSrXrwXp+7M4oaqj0y+rvB+33qw5h6
	iOydaO4TXsUgGUd1DRL6gT7nTUPFlMY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770900606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nit8m3oaYzPkr/DHNj61xP6u3VIDPL4n4HKttTvb6ow=;
	b=aUIK2xj/pNmMfZa2MU4HmKUiJg3TeZZqyvpeh+dNkyDguiPzcP+95wpSizFZen39jiw64O
	RaQ/35zQnyRMD4uYs+wfxwPLlLZTT/NdgKrzPoE46/52Ma0R3UCkr1NYoo1x63l/UIZUnr
	DH1LeuUyrSvrBvrFxLJn3iyA0RjVcCc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-jdHh-XruOWCeD0ao3BwDRQ-1; Thu,
 12 Feb 2026 07:50:03 -0500
X-MC-Unique: jdHh-XruOWCeD0ao3BwDRQ-1
X-Mimecast-MFC-AGG-ID: jdHh-XruOWCeD0ao3BwDRQ_1770900601
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A624195605B;
	Thu, 12 Feb 2026 12:50:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0EA130001B9;
	Thu, 12 Feb 2026 12:49:55 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	brendan.higgins@linux.dev,
	raemoar63@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com
Cc: acarminati@nvidia.com,
	linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	gpaoloni@redhat.com,
	Alessandro Carminati <acarmina@redhat.com>
Subject: [RFC PATCH v3 4/6] char: mem: expose devmem helpers for KUnit testing
Date: Thu, 12 Feb 2026 13:49:21 +0100
Message-ID: <20260212124923.222484-5-gpaoloni@redhat.com>
In-Reply-To: <20260212124923.222484-1-gpaoloni@redhat.com>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JDTvzNklBeJyBEIy81sLQujuwUF3PjfcIQ2opaIrahU_1770900601
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77D5880008
X-Stat-Signature: wpwrou9e4zmkr7fdsi6zdx1q8ank7dds
X-HE-Tag: 1770900607-324123
X-HE-Meta: U2FsdGVkX19vZ8uNMUym/Ldk0r3OPiV9EDsICrglrwvwgYvScJqlwpYGwBLnpIw/I65wLnW9hHhmGv9z2zK5mcN7uhuw7ntTbDQbgvP0VhazWcSBJRH1X8DxXi1Fw0bDxm1wPmVuWL2RWg1rf4q8NjDPpT4/PKD2VkIf029aRskAUHMFJIycci/Mj8yHI5E9cl0c+nRJFfdpkpufZ9bwd6HCFwGbIrcCw5sXsas5BJQzdhMqkbNT6qbaA4/kyNDWbouj/yx49r5edFuMPyjiVm3ZbRa8IjOObtpyeR2aqPU5aM3/+JFWsMKB8NAQ4N3noPSZqVzs21/zjiTNXg2HjLbP06qDZ8qt3ZVugyqGAOgXQBpZE45XjJ+g5vre8dXuPVVliQRi/T9fpWKzJaCSej/i8x+xizB13RkJ+9JE35OwX9LYb09sZetE/RSd+kkJK2shVsk54rDmjqyUa73Go5AZ9vcRwJ0O6pmgXwfFtNYheYG3NL2Qwx0p/IkX78JlLtFNRynG8/3Vz6FABBs4u8iuJunerjBws05qZrMVyjcDLv9R7cMcKITrEWMHev8L0JS5c+gmkenpSh851Yz5gtjV002lo5QqsEtjXkaGzMGLhuxl6t8MO6Mg/tAkVyTcwCW1xLEFyeX1MJcjer58/r/E3b6Ygf9T2DlLuouPqrqDkidwebU4Zr14NlmzqdJUqkHVsHTVsy4qV+pyfIWxoJbKb2Fo0gXi0nICXxdQQE+v5KOuUAEK073xsJHKbT59spblKLDrIj+N4s2k9Bhb2hbU3EnS+BhV16wJQ8BInKgaE0G61OYyyJvqfCS8NIPMtJr2iwkWL85kl64ErcxG2IWCbt+IoVCA9SePn2VwtvKrgTMJ2Cbqz1lpAUwwkL+sX3voJa9QVDw2rEiydUnCK9hOcE8ddD8yR7fa3J2AI8N0sviRBHwTDwxMoJd82HP8oCI2moIfDmsbZGR/Hsa
 hPlvvR0U
 wlEKME+uDy8jdWFsqnOy1GajX8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alessandro Carminati <acarmina@redhat.com>

Refactor selected /dev/mem helpers to allow access from KUnit tests.

This change:
  - makes page_is_allowed(), read_mem(), and write_mem() visible when
    KUnit is enabled
  - moves shared declarations into a new internal header
  - preserves existing behavior for non-KUnit builds

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
---
 drivers/char/mem.c | 15 +++++++++++----
 drivers/char/mem.h | 17 +++++++++++++++++
 2 files changed, 28 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/mem.h

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 9aa589ea2ef5..f1d0a2c11819 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -31,6 +31,10 @@
 #include <linux/uaccess.h>
 #include <linux/security.h>
 
+#include <kunit/visibility.h>
+
+#include "mem.h"
+
 #define DEVMEM_MINOR	1
 #define DEVPORT_MINOR	4
 
@@ -57,16 +61,17 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 #endif
 
 #ifdef CONFIG_STRICT_DEVMEM
-static inline int page_is_allowed(unsigned long pfn)
+INLINE_VISIBLE_IF_KUNIT int page_is_allowed(unsigned long pfn)
 {
 	return devmem_is_allowed(pfn);
 }
 #else
-static inline int page_is_allowed(unsigned long pfn)
+INLINE_VISIBLE_IF_KUNIT int page_is_allowed(unsigned long pfn)
 {
 	return 1;
 }
 #endif
+EXPORT_SYMBOL_IF_KUNIT(page_is_allowed);
 
 static inline bool should_stop_iteration(void)
 {
@@ -104,7 +109,7 @@ static inline bool should_stop_iteration(void)
  * * %-ENOMEM - out of memory error for auxiliary kernel buffers supporting
  *   the operation of copying content from the physical pages
  */
-static ssize_t read_mem(struct file *file, char __user *buf,
+VISIBLE_IF_KUNIT ssize_t read_mem(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	phys_addr_t p = *ppos;
@@ -190,6 +195,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 	kfree(bounce);
 	return err;
 }
+EXPORT_SYMBOL_IF_KUNIT(read_mem);
 
 /**
  * write_mem - write to physical memory (/dev/mem).
@@ -234,7 +240,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
  *   be copied from user-space
  * * %-EPERM - access to any of the required pages is not allowed
  */
-static ssize_t write_mem(struct file *file, const char __user *buf,
+VISIBLE_IF_KUNIT ssize_t write_mem(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	phys_addr_t p = *ppos;
@@ -306,6 +312,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	*ppos += written;
 	return written;
 }
+EXPORT_SYMBOL_IF_KUNIT(write_mem);
 
 int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
diff --git a/drivers/char/mem.h b/drivers/char/mem.h
new file mode 100644
index 000000000000..dfeb5f1d5ec8
--- /dev/null
+++ b/drivers/char/mem.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025 Red Hat inc Alessandro Carminati <acarmina@redhat.com>
+ */
+
+#ifndef _LINUX_CHAR_MEM_H
+#define _LINUX_CHAR_MEM_H
+
+#if IS_ENABLED(CONFIG_KUNIT)
+ssize_t read_mem(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos);
+ssize_t write_mem(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos);
+int page_is_allowed(unsigned long pfn);
+#endif
+
+#endif /* _LINUX_CHAR_MEM_H */
-- 
2.48.1


