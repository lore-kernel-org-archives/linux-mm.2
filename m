Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA36DC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA336B00B3; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F49F6B00B4; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAD16B00B6; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE9F06B00B3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:25:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DC211401DB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:58 +0000 (UTC)
X-FDA: 84959180796.24.D87DCED
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 770F114000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gTr36Tw0;
	spf=pass (imf26.hostedemail.com: domain of 3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362356;
	b=yD/ejOoIk5TzhaGSOS3VKYgoprHhcUK584vCXJm1zulMKIOaJIFWEPbMYTbl1f+DRn7isu
	YzNTJCSU9UXPMB8fHp5Bn6N4DamNq0xSIRTL8l91zuN84nx90iaBu5hh9zwSJt8Wn2Yai0
	QdCrVtM8mI9w+t2ocRoAB+UhEChpBYw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gTr36Tw0;
	spf=pass (imf26.hostedemail.com: domain of 3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lfZp5DIykJmBXzZZseK2vblkAIMJZ1w1tIpIkuiJ5w=;
	b=7y2Rjn5hIJSjQbNreOqjtENacyYOi5Hjd0Hz5yNKp0hE+lJBKF+iurO4gTJvwCv7VUhopq
	hEGYfCRxtEJsEGyLsAIHMUHl9BCAWMVuFOf8i/X+VDYo5pvgiSpwSfPho0UVPYtlxNP1pn
	/SYDCM4oCuxjm3WBNTp8R1OnpVf+XhU=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c889d1eedcdso5310701a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362355; x=1783967155; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lfZp5DIykJmBXzZZseK2vblkAIMJZ1w1tIpIkuiJ5w=;
        b=gTr36Tw00ytdNtUkpCPt5W3m38JDWvoWxf0QBCY2CbpE1n61H0RTJxKZeMCsouPR65
         9MpJwtzVk7Ad29KV/zzEpVPQvg+z5K3frYNqSjt9N7k9vMc7Jp9mxsRQFUz0oFqgFGgY
         1TDXlypP8azaxOuHe+ndiVv6oH9gzHP84vNd3L24RsOHcFcVvIBa98uE5V0/2rSslV7B
         0eg/EvilOKADn5IT0FOrzzCrbITbFdW2Z2Y0Z5OFqanrX3zYg+7fUxJNBtfJC5Bitlim
         xm1FbkrofnglnbsEzh6y1ya3OZUC9jqpdMi6trsirXr7Viy/hw5bQH38BGaTJFThNE41
         JzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362355; x=1783967155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7lfZp5DIykJmBXzZZseK2vblkAIMJZ1w1tIpIkuiJ5w=;
        b=Kf5jn9/nEFQbM7nWA5EThPjNOT4M0OPq269ic8V2vII+kUMnB4hfN47axvp1v2LfgU
         X5R7S4SkGV8KVxVmIUWeQF0owAEzhzFMJ2j/noTFMV/nAkEG3cmYtpQCrlznlFelaKO5
         NirnQ0TcAIopsSdCfagdi0dBDavH15gbo7wIzgEJo38cz8OkxBWdVS8WeWmyMrZqrvHc
         gu0dHAKLzECiWsjnodtXc+BLOV9yjFSR5Dz4RXStvmS1qvcYMqnVcyj3SrLzCIXkw32k
         L/T6ta/GuWWuuIFHypW/07OC5rYhtIJMfJe6dOv5lqkgJWlSVPaxVlckkXGNY+Tj/PHM
         I72g==
X-Forwarded-Encrypted: i=1; AHgh+RonsT2Y7bC9KN4/NDM9JHW0t/CU2hApdYzpK6mlTzJ1uZOdj30PdroRa9A3CSPau54woz6E3otmMQ==@kvack.org
X-Gm-Message-State: AOJu0YzCqaJDGiC2csiP9rCvdCGaWqOGbqk86rLgO6iKHyglXDd1vcrq
	ndz0Y8iOoIsOOY98EUqSTNpmGHIxJA2KbXWf0gof5T9rB1MT8zD2Ju88DpvXWdHjxZxaTh47570
	PZwagUhoZyKSrW2scxtAXx95oIqNpJbgUjg==
X-Received: from dlbsw7.prod.google.com ([2002:a05:7022:3a87:b0:13a:1e7:e4fc])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:2799:20b0:3bf:49c8:f73 with SMTP id adf61e73a8af0-3c08eed6b4cmr1216687637.35.1783362355164;
 Mon, 06 Jul 2026 11:25:55 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:44 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <f9ce7c708346413113b87f1391e7a5e6b1e36db5.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 770F114000D
X-Stat-Signature: i7ae96n8ysgbzpxngjcxj9jf9omuni3g
X-HE-Tag: 1783362356-268849
X-HE-Meta: U2FsdGVkX18BVqZuMxI07x1H85agkOTJJevQMwt9/ldeXwNmd2q3ptsuNGrrkWwnn81CPQ/xEl5w5yayMIwotCxHqPx2brLXPrQJa4/qFycBCm+IorJwUw6n8Bp9lGqp/BXwvy0XIFT9ZfSDIcbMXRrBwt9iFwfTfd6d80zhkZ8ez32CJlfAQ8AAFqe2r3iG0SDjsbSvz8jGdLLWvjk+XQitgREkhjSP9rFEtgLCX30hIxkeICqjmImVJv1B/9xloK8FXmebPG0csqMcsVLDSQ9fSyr9ceaKAexntuEFHcKJ9gkUWxo8JOakinNrCI2AVt4kxLEuKpre5GF6ibzZrdVMplgA02sDP2CT+bcnGO0nzx+Vj1yRCk6NQZhVhdo3LyBbnlECwWD5umv+Z++jM4WOvamPLKu0iBa3LSHKRjDBMp6BTW9g6ACzDKx8DNjSj5Ubg0/dz9aRBodDeKA/2CyVDVrdXJBS5ViJ4RgWFyhVh2NL/G6pMiveXv+jkiVKTPM6QLRH9Y1kPgFS9AIVUtknBy07GEJBRddZPkuAyvKhh6lH/GB4W+j83i3819yfSnjm6t4mHZjx5GfcMJ1OYcVZduc1u6S2YYwPNkqvZSWv6cUoHeSMy/A00AbaLEp40HVly8mVLDhGwk2hRa2M7YrW1SbMoi0oHfG8Lp93vhFOBs+NcH00ZvhHFiHykgFD3XzKbzm0K0IgAEj58MRUBEvuM97ISdB6NzQp3iEDOP1w2LnYnYwKxyiC2QmWcHUm/Q3/GfAY4fL2qnb5LiRqtQZmmGoI1mpbHp3Hm3ZZFFPBtJJEW9mrXwl9ZYdeBbRKfh6SMHTpFH4zixw3i5Ie5SoDk1wC5DNUCESlkZXY9gChUK4EkVjnbN7yhxjzHYNP2b+avfXP2f0H8Jks/jID+ow0/sTsrQDpQjMBhoqqbTJP8A9NXqoiY77ZqSXvh3jg3643TbBVm95DCaEGuEr
 AI3gPXmg
 T+YXSiu/Gr0PLZlbEu0mjpAyhCJrzxd5Am91g2NjBfHGAWyCjtD+8lRUsjb4BRPQp6XkpwTDlm5c7olvGIoKS98zEmRTQ/+V40iDZ1EfAI9Vb3fA169sUb5Z1b1JQmbOZaZRLm24VtT/8SJg/ObrmUMzDeOLfSFknXHSulmqsxcu+18uEcRHeMvHs7semGfNaRZdQRQAu9+zIyCkoEaIWDMv6DAGAqcl6HPd+RDyU9T8dKzgzuu5ZDp/ey3mB0veehdlW7E10SDDcu+tAUrObgyHX6CKKp5zbQyMT1o2U9ICO/ido6KecIqAscbmSW+kVBfKBgBif0Rj1uQWlX55cmYFxTH/xrDeABk26EViFm6+DBM2YIRcRouicbxGe+8bazTAb3/z19IsDNvdGb+tBJJ8/sg4jiX1KDCLlWuSaWViY9JuTv+1cTrSQjwTgB0bZ9B/ojJghlv/Hfqj9LpSM/UPvqVFOcpG6RIUkXWxyRdE7ZBkXa57pAS/Hrz6AhW3SY50RYphT8hpw+Veij4AJQYjn9OtFzzgG5VUWvC7LNzpr3XCL+2ZToLKYWueVEPnbHgIXU2Y0EVmQdFL8SwmN9iMSp0Jrbev/WDbW1soI/CfGWFB2HT4hpixUiflxqSYl9D06Cv3sMBmP87I91P+S0y6Z9jt7hzZ0LrdkbZlcYkyd/TJrG4XIiOd5/rHvzaQjvjr7a/vhGnMop1h7Dj6ilqie086YCLp2GPnf
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
index 29c302e9c17b..200b92ec1ef6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16937,6 +16937,7 @@ S:	Maintained
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
index d9be1cf5187d..c73195000830 100644
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
-- 
2.55.0.rc2.803.g1fd1e6609c-goog


