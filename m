Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474B1CCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7658E0007; Mon, 20 Oct 2025 20:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051038E0002; Mon, 20 Oct 2025 20:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D422B8E0007; Mon, 20 Oct 2025 20:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF3F48E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:09:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 899B6119A29
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:09:00 +0000 (UTC)
X-FDA: 84020186040.06.88EE4C5
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9EC6C000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:08:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Whaxki29;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761005338; a=rsa-sha256;
	cv=none;
	b=xyZ9L40FkjwA0EBldajrEgq1ACRuiJtnAN3+Fb21Dk9ZFXvzAUc91M1JiJJba6fj7nY41R
	HzGvtkRSKpLcc1wsojmrlTuJ+PZtvu4tp1mF1MtxRJkJbbgG6WD63OLJsgi8lzovgaQhUc
	I9TX/wTVyNgDkqxqpeFlpXyI6ax9p6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Whaxki29;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761005338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrUod6z9AaFkGeIJc9frhWccEivwV7gjE944YavE0C8=;
	b=p1zgplWKihL0n47IVyXB6wQ4OeLUBSwj7xSwkPcMSVq+WIKlTIkrnEvBqT5pGDThY8pwsj
	ljX94CTAzW75IzCQ4f/X6KhGoLn4D6Jix9joWuguThQYXv7MjvelMJ0o5v++54FGCrWYsT
	4B1NQQvJxL6AyZ6kdA1OK6tsml6uZtM=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-554e726e5cfso1659210e0c.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761005338; x=1761610138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrUod6z9AaFkGeIJc9frhWccEivwV7gjE944YavE0C8=;
        b=Whaxki29JhBG94hffPKoc13xtXNw98SFQ5hybHzccj4t8upH6Juhngxd9KE+4GFWbH
         JnU55oyF6NH2EEp187qxL941/XreFr1daVuZKaH7ryxvy9higvTACIflcUIWhkDwWZjJ
         L3Ee2YjyOinontEgJiZ+VS0ArH0CVSFCJQNP3EdXO/RLyvzTsX5SPk9YbqC4/m3UMNzL
         rLH1LbtgBj3r52wuTurhQggzJPaCq+5TbrgqNX0AGMDoGcfJsU+ezpKi1dptA64cella
         74uBn6mtWSwBipZLxYDxnSIaGMp+eWA+FCNFt906QKyiYo+qNvWxW3NnQhuIab5I1kEB
         +/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005338; x=1761610138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrUod6z9AaFkGeIJc9frhWccEivwV7gjE944YavE0C8=;
        b=ixeew44TPguYXMsoCeW2/oZr2RQluTpMApHSw+abD+NJ4AV7NmbxTz4KijtdQe8F1F
         ax1HC7rjEf0fEOzvn5AOtIi9V3X0JPPjWkoLjVRKpYYyppv6QeQ6/UXVFvwLgDOp/uFr
         ZJPXV+kHdPa+Ao+s9le7Ii7PkA3BY+0oDSSSwxByaKymMwZMnlpOfnmZXrA5N/weoIJP
         Hj1sZt8dC3IafGwDb1jJPubsHTU72maBNybfiA5UfSQx3K+ZxuUuhvyX6XampA3Yn0Dk
         UPkpSah9YOF78PdInrQ3lDm+2SI7PJiz3D43dh170J2GaB+4RMOTsOXaMPY6n528W4Uz
         PVog==
X-Forwarded-Encrypted: i=1; AJvYcCX/13CNqVI553CDn41REBjvARz/2Eychq7bZmzLkCtUhCeqQGubC0ir6YC4PO2wNLNnoyGW+1BlIA==@kvack.org
X-Gm-Message-State: AOJu0YzUlylJdgxJAbI8AbqZ5te2IOt6qOIXRk+udOj2/BNyxNWn1/QS
	EcCFNpaB9mIYLbdi1XQW8PqL82sLYKD5Vk/poBh1LQKvO3+AWHaVOXZEsYc6YOt2odU=
X-Gm-Gg: ASbGnctJ3KcTuGyiNm4P1UACXOx8A/GblvcmEogCEQXbxTTuZSFdbqyJAqfd3RnkKjb
	6xUWpqHCFOcCnSvA3N8nKDSoobA4PoKVmtboUg5TGn4pQEZbj3oFOEw+AmIZN6HYrkCUyLko2so
	xn3zdzifenT5D/su8pKOng/doXkgkSHX5wE8U2WG9sVuCtepTpli7MSoOBKAX9sxPZD9iWm2Coq
	qUOCMXSDaimKyDuuL8FNI7hQwuliEjOR31fmH0Hy6Xols7CZFv8CAAufnztFE6Bk85+3B0JeqWQ
	/Hylp5AjPHpdYmjAHlTEa1RUDng+GVWjsBfqoHyHOKGpu1GcXHj7EbGoHnjh40LeEmx9XAozO6V
	nQavh876n+XcnSrNFltYg8Mr3LhHp2MavhgvLOFbNLPnpmlhtDDhmrE5bx/PzI/8fxJaGZxIZ6F
	og3ewFn/cTaGhLk2xeIHXw27Dx6mXb3ph2n0paM6PVEhAKenKEG3xYSdaZRctDgrI9TbzZe5mnU
	sM0U5SHhYrbbytW+RroQcnJh+liBO1H
X-Google-Smtp-Source: AGHT+IEXSBVMEN9foAesWnzieDCrIXltrdCTVWZ8zY0V+zYO9XF7MLbCmqXOk7hAXlRHd/2MI6iEIA==
X-Received: by 2002:a05:6122:1d13:b0:54b:bea6:a226 with SMTP id 71dfb90a1353d-5564ee6bfe3mr3839907e0c.11.1761005337567;
        Mon, 20 Oct 2025 17:08:57 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55661f6e351sm2822882e0c.4.2025.10.20.17.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 17:08:57 -0700 (PDT)
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
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or preserved memory in scratch area
Date: Mon, 20 Oct 2025 20:08:50 -0400
Message-ID: <20251021000852.2924827-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
In-Reply-To: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9EC6C000F
X-Stat-Signature: 4w8cppnn99fch417bczm8aaotsfapzhf
X-HE-Tag: 1761005338-927859
X-HE-Meta: U2FsdGVkX1/23sZKIAnkr6PvgS0uW3NSMrfQtHD3lB1d4XyH6S3pKiLhIwCLWSDzReqxmjPv6T9J68aZLKQAlvnAKHL/OSi96p1GasL7BA6XgaC1NPMA5kw4quUylU8lW4TCO1/KsoZEuNfUUgiN22qLOB9CtjZU7GPHAhHUjc4F/pDQOA4OJLCYxkKLd/sppUVFTpznNXrXQxRUaw+vHagbaq1spKl8bhdhJyyancPhqk9V/HH9VBK01T7SiGp0J+AZbmu5MIKrbwqUdk/CQwrqalhcHilw5eQta4DntG6YZpImzeIVSVCYgeLl+g7CDLcVN7qamZG7EthOEkJdC3QA7jNfwE6iw08YJIqf1oHwYWhQ249ijQe0qpIMONpKXVjHWVdyT/M5t+FuQjaDTzsHlJQFSBWer1i1zV8TFf7eNg5yt1Z+uvazW1p1AqSSGUrTbwIXm1cvb/AbbpRMX4nZt98A98tRNsoZD4Bt+kUabjLEwyihuUVeqvfhGMIuvHQ4MEJpO5SjQRPg9LHi17NQn54YDi2zx38v7eXR+7Yrqm7EL/L/i44e42hd5yhiVBugVleOUQpTyKmlEaE1sKj9Yzu/wH7vE1BRx9z5jabGCBEeRs03s+oejsY1iYwpr3b9wEiJlti69n7e89shsXhVjl4cK3qO8xLZEQmcvmFP6Ku/C4arY9uwZAq6SuyrluiVc8/uPtqx+sgnOLftCFXRGMg8JbbpJheRf+B6JfdllDlcWtYHeDH/KlwwQRmFuTd5Ps3PMXhqPUkA2OC2epg9tty8nwMz9PamWBVJF9e0jzexIkTZvid4JUPHHq5SomnRu2t74PpnGCuIilId5OxsR7Sms2ocY3wgEBp4iJcjdjKLH8KH2jBGt69ZaEq23rIZDljrBAFzyIomo16wbfpb1pCidhI2xS+pA7dPzOMEOe87fUqvTtwi1yjL4JA7zAYnV2XvunS+BHkxZSB
 XcLjSsBP
 cvjPomrMKcB6xsAGczYLMv2O1jGCpVPA8UAcSJAojg2Q0Dyq6Ip1rIMppINn3M6EJOLwfZ9MktNu/4XuelsyfH7TYQnfpXvL14YYGsJgbEv640vdrezI5UWqdpQBNfkkmFRX8IIPysOaSML5ATYfsgAPniXf064PKvWGPz4XVntEo/Pxn+NBAVoW2sxLEHzo8894ppawoHRCLE5PaYRwPRTkjHJqbGTv0n1xMN8ubPjKUSZlJm/cPhoHDLnR72AODqkadd3dwD9YwcD33CGPoyTPP48aKYpSLXKVUI2mUGYp5ycz1JMc0oxB6/pAQKBCcNYFO1b1gTcxKFyK+n0CHr4cnXee5F1Y1T/Wl7XQ94vLUMsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is invalid for KHO metadata or preserved memory regions to be located
within the KHO scratch area, as this area is overwritten when the next
kernel is loaded, and used early in boot by the next kernel. This can
lead to memory corruption.

Adds checks to kho_preserve_* and KHO's internal metadata allocators
(xa_load_or_alloc, new_chunk) to verify that the physical address of the
memory does not overlap with any defined scratch region. If an overlap
is detected, the operation will fail and a WARN_ON is triggered. To
avoid performance overhead in production kernels, these checks are
enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/Kconfig.kexec             |  9 ++++++
 kernel/Makefile                  |  1 +
 kernel/kexec_handover.c          | 53 ++++++++++++++++++++++----------
 kernel/kexec_handover_debug.c    | 25 +++++++++++++++
 kernel/kexec_handover_internal.h | 16 ++++++++++
 5 files changed, 87 insertions(+), 17 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 422270d64820..c94d36b5fcd9 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -109,6 +109,15 @@ config KEXEC_HANDOVER
 	  to keep data or state alive across the kexec. For this to work,
 	  both source and target kernels need to have this option enabled.
 
+config KEXEC_HANDOVER_DEBUG
+	bool "Enable Kexec Handover debug checks"
+	depends on KEXEC_HANDOVER_DEBUGFS
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem. Since, KHO performance is crucial in live update
+	  scenarios and the extra code might be adding overhead it is
+	  only optionally enabled.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/Makefile b/kernel/Makefile
index df3dd8291bb6..9fe722305c9b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..7b460806ef4f 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
 #include <linux/debugfs.h>
@@ -22,6 +23,7 @@
 
 #include <asm/early_ioremap.h>
 
+#include "kexec_handover_internal.h"
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
@@ -133,26 +135,26 @@ static struct kho_out kho_out = {
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
-	void *elm, *res;
+	void *res = xa_load(xa, index);
 
-	elm = xa_load(xa, index);
-	if (elm)
-		return elm;
+	if (res)
+		return res;
+
+	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
 
-	elm = kzalloc(sz, GFP_KERNEL);
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+		return ERR_PTR(-EINVAL);
+
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
 	if (xa_is_err(res))
-		res = ERR_PTR(xa_err(res));
-
-	if (res) {
-		kfree(elm);
+		return ERR_PTR(xa_err(res));
+	else if (res)
 		return res;
-	}
 
-	return elm;
+	return no_free_ptr(elm);
 }
 
 static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
@@ -345,15 +347,19 @@ static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk;
+	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
 
 	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chunk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
+		return ERR_PTR(-EINVAL);
+
 	chunk->hdr.order = order;
 	if (cur_chunk)
 		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return chunk;
+	return no_free_ptr(chunk);
 }
 
 static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
@@ -374,14 +380,17 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
 	unsigned long order;
+	int err = -ENOMEM;
 
 	xa_for_each(&ser->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
 		chunk = new_chunk(chunk, order);
-		if (!chunk)
+		if (IS_ERR(chunk)) {
+			err = PTR_ERR(chunk);
 			goto err_free;
+		}
 
 		if (!first_chunk)
 			first_chunk = chunk;
@@ -391,8 +400,10 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 
 			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
 				chunk = new_chunk(chunk, order);
-				if (!chunk)
+				if (IS_ERR(chunk)) {
+					err = PTR_ERR(chunk);
 					goto err_free;
+				}
 			}
 
 			elm = &chunk->bitmaps[chunk->hdr.num_elms];
@@ -409,7 +420,7 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 
 err_free:
 	kho_mem_ser_free(first_chunk);
-	return -ENOMEM;
+	return err;
 }
 
 static void __init deserialize_bitmap(unsigned int order,
@@ -752,6 +763,9 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -775,6 +789,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
+	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+					nr_pages << PAGE_SHIFT))) {
+		return -EINVAL;
+	}
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
diff --git a/kernel/kexec_handover_debug.c b/kernel/kexec_handover_debug.c
new file mode 100644
index 000000000000..6efb696f5426
--- /dev/null
+++ b/kernel/kexec_handover_debug.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_debug.c - kexec handover optional debug functionality
+ * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) "KHO: " fmt
+
+#include "kexec_handover_internal.h"
+
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (phys < scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
new file mode 100644
index 000000000000..05e9720ba7b9
--- /dev/null
+++ b/kernel/kexec_handover_internal.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
+#define LINUX_KEXEC_HANDOVER_INTERNAL_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+#else
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
+
+#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
-- 
2.51.0.869.ge66316f041-goog


