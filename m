Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB6B1062896
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6ED6B008A; Wed, 11 Mar 2026 08:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8B46B008C; Wed, 11 Mar 2026 08:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F83E6B0092; Wed, 11 Mar 2026 08:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 197DE6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:55:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADF9D1A01AE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:58 +0000 (UTC)
X-FDA: 84533779596.01.76C841E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id D07AC1C000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TKF4nEaW;
	spf=pass (imf18.hostedemail.com: domain of 3W2axaQoKCEIqgpetmrwomksskpi.gsqpmry1-qqozego.svk@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W2axaQoKCEIqgpetmrwomksskpi.gsqpmry1-qqozego.svk@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773233756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiNhESp4ivptJOpYZbbAOc1dWjPibReMWlebFfT5Yug=;
	b=xTCiBBK1upZ89uIvKS+zhw70g7TCHwKdkx8+X2oCg+xIUHTSWrgl/15w3M74rBbVUxgGUh
	0nXP/Y21H5Wk2MNKPn3IoIdPGEJMruqBb5pMChlrSbvaoZCgzmdBAY+UNCXWP0rJxX69AP
	aGjjUTEvcJZzks+QVpoh/e2RcSVh11s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TKF4nEaW;
	spf=pass (imf18.hostedemail.com: domain of 3W2axaQoKCEIqgpetmrwomksskpi.gsqpmry1-qqozego.svk@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W2axaQoKCEIqgpetmrwomksskpi.gsqpmry1-qqozego.svk@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773233756; a=rsa-sha256;
	cv=none;
	b=o+losJmy/KiYXjYfV9Bjm2G1tHQ3QRFLyDoRy/o+KGuAadLkfzt/pj41ZNdYC0bHS+AsRb
	IjE40m/q27lxPfcCoGosj+FrNegaXO+NWzZI549iKYEMm76hu+KMbgOfpSqyiwSkfdWjL3
	kIA1+vte+ljIUd2cwLsY8fofVEyHTgA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485345e2fdfso21625955e9.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233755; x=1773838555; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QiNhESp4ivptJOpYZbbAOc1dWjPibReMWlebFfT5Yug=;
        b=TKF4nEaW4+SouVAHvGYN7xzxPHsipe2uIUpU9J5/BXRHE/8ISjHkKBztm8xFNHtkRx
         HCNXjpAPYqTtavgfwGfLxES4KmyOb66YsE4bOh8bECLy5Dtc9aIND9xn6uAn00xaNTME
         GvPD6kwZ3/lTjEZq8l6ptJA0/DqTmSTkkm5c8MYl5CTVs629yI8p6ni5l3kwA8T7G3qN
         QKYwzBN8IyUHVSMC59oTqGwDRSz/tC94EfnoIPTGAF9rMuft299OWRrn83mdYDrAFVxp
         6Rsu/zpc/Nche4k986oLlvDHqUwT1YPH2o8T6MCoauEgwcanJ3A9MZ4Xgl05fYjNzDhm
         43/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233755; x=1773838555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QiNhESp4ivptJOpYZbbAOc1dWjPibReMWlebFfT5Yug=;
        b=YKzkmKXEHgOduBsrWiddwzFbqxXb4Iqkny/5R/FnAqtHOVjI18XA/HTusAIudD1mPZ
         vOTthha4RneQj4BntBDLnYRg4cIrIhK6/JZUAg93X2753ZBxLtjS3/hZz4KJhvYpeUV+
         Ge0wX8RjLRpQtSSYhDjjMgLeYAu9QD3kumaguUY4s5drOV77aA4r4/j+NU1qcS8HOlFD
         l0PUhUq1t+8G7FazTCcWahKsn77jgqwFGUA/clXlaPjdjQ/P/SphkaiU0egLY3NG+HPW
         FSwNyUZx4qI76ofN1nzCVOcTpJMID8doKwaegeRepkDx4276j8Ly0h53l4HoZiK9NUxo
         ByHw==
X-Forwarded-Encrypted: i=1; AJvYcCXEiqR/DV1Bg+eCpLVmqTMN7AZbB5ybUKzYNnxQhfk4o4RcJb5ME0wkJZ+qMFSMDd8YRYux9X7RIA==@kvack.org
X-Gm-Message-State: AOJu0YzUOT1NS8WkFovzcGM4ZJtG2/bg/6jLIdN34hq+lPE1KMk2uN3v
	IGBV+DjHmkBwm0HShuWB/QIVFkmnQrCnyZdqloGA4qFoqscTqMj/ONW5TZ7OVhnstecZt6dEaoP
	ccmMm75Tp4h+4fcmkUvOStw==
X-Received: from wmby16.prod.google.com ([2002:a05:600c:c050:b0:480:6b05:6b9a])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:458e:b0:485:3ae8:2231 with SMTP id 5b1f17b1804b1-4854b11a321mr35639475e9.30.1773233755110;
 Wed, 11 Mar 2026 05:55:55 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:55:39 +0100
In-Reply-To: <20260311125539.4123672-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260311125539.4123672-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260311125539.4123672-3-mclapinski@google.com>
Subject: [PATCH v6 2/2] kho: make preserved pages compatible with deferred
 struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jmpu3qbpsgpkbc4qsk9rt1muaogxhx8n
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D07AC1C000C
X-HE-Tag: 1773233756-339066
X-HE-Meta: U2FsdGVkX19Yi1dFsuE4r6K97YJ+/XNecMD5r+W+vSfrQElbh2VpR/omJ2gV1VuZrnZTazaBYnlOMvKLHJXw28CM+LlDJ9yYNhn0rH30LCnD5CYGCekksKrSAnmIBCOlm8w/Aslxqt5CFC7mPZhT3cQXlKLah9psqssUKqc2KEIZMfHDZrp0fq7WjZ45qz8p6ABufDj6/VUvwyV75JHH92A3QOYb7X6uvDAIVWySSNLW+4ph8iGroIK3SEbopYXbcp+W3XSRNB1+RhaC6r9W02VINymaUwWdeSISh6NTlZMhQ7ma54MGXfM7jqvA/QCM/bPFOewEzsD4FR0vG/fgKtFKKvZ5k6Aw9CPEkLgmhe0oRPm/4YZAlGzC3Kl/PLGERwmhUydQSOJ3Jh9VA0me4zptTbLk9yK06sLy7Kbao5CQcaK0X9/tkda/PG/2+AixgFCju+dK0K+sOkoJj0KSaVHqs+NGZQhjY7nsZVnGdjthXuEuUFvBGQbAVBKIZf8T8k82ads7+sGJ9vfr4Uy8c9CbRPTn9xir/M1Ze+wg1stTMuYJ3YT5oen3Y70a1D9kjAw+e5i8eZ8fwHpPdqU/Ux9pge7LIfo/csNuX9GqiLVxne0D5RdZFcnLJ+p6Z1b10vKEitvEH7q50YRm/757y3PoX7pnYS6/t/BLWYYzdKXaglzCRAdO0Jj4SVO7YnxhhB0bWzdqdGHMM7QYPfx2vjhTert6BUkyb0Hz0onwB1VFSrdvKhTls142GEOL+GyHBXiJ3LeHeZ7oyHShZCr4KwWk3Es0HVfJNEC6Zmo4cO9wtoiuvmDcvUSquKdo4bG+5WaebbClQEWLpGttBHVRVQNnSPhgC2Pjhz+K37UTIqTqs7BZUVR+zXoWhF3zfbaDhEqr2BEOKv6FJGRGQ0gPLIMvl/CGacbITcE9IRLU6cUO8vFy5obXfV94egHt0BhVZZwrUd/wDkpR+/z2i0H
 Ss730rr1
 U4MPZh54xj+TkjHnlO+3oZdc7AlSLbsor9ZcMLV4Pic20skj459PL2jQD5fgfGYm0uPvkBPULGsenZ/YOH5l1jay7/BkFNwYB3xhjpbrpbqIGbNWj3C2Qgv2uwrXdKS5hjFgybs8py/G7KvTHdjTsoBBg6oIgX81iREFmLIjn8DoimlkTjpsZjWrCH87UYAHrReWIBuyOiZWwuJysIx/Qwpz9tqHnO4+/kqOQzhYw8AcKV4HwPoahBPwL/mXHLb3KweCKrx8dI+ysVB8k/OwBds6+MhZSt5jvsF9uhOvWbbeI7mynp820wLt+rr5m0fYhsfYIsiTDQlZUkJPbwLMuYnKYrV7/hQEcS1RaqM/sj3on5V5dMHMQYg7memRF0h7PK/DNinTI94PwcbvmyE+xf+pFyx/A1deO8xUuf8b60h2mZ5dDTbRCn3lFJfD517PL+hCsYYOjbMhNnB9PY3fGTh0Oc7aDuSU4g0jUK7fceohw0axE8l0FDrnp+zOQTPTDpcbl+3kOpBZvMi40Y9vXm4Hx8oZRONHeMIEKAWFrnOiqGoMxr3Da+cfWcgbMG+r4ka1yGVhDFWCozHmx7VN+M3WW8aJbzUIuvHvJyyb+iE++nDJepUN2aCD63ug1bUn9kyapLSlB1hUxeieAQ6qHsNPbPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Evangelos Petrongonas <epetron@amazon.de>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
initialization is deferred to parallel kthreads that run later
in the boot process.

During KHO restoration, kho_preserved_memory_reserve() writes metadata
for each preserved memory region. However, if the struct page has not
been initialized, this write targets uninitialized memory, potentially
leading to errors like:
BUG: unable to handle page fault for address: ...

Fix this by introducing kho_get_preserved_page(),  which ensures
all struct pages in a preserved region are initialized by calling
init_deferred_page() which is a no-op when the struct page is already
initialized.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Co-developed-by: Michal Clapinski <mclapinski@google.com>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
I think we can't initialize those struct pages in kho_restore_page.
I encountered this stack:
  page_zone(start_page)
  __pageblock_pfn_to_page
  set_zone_contiguous
  page_alloc_init_late

So, at the end of page_alloc_init_late struct pages are expected to be
already initialized. set_zone_contiguous() looks at the first and last
struct page of each pageblock in each populated zone to figure out if
the zone is contiguous. If a kho page lands on a pageblock boundary,
this will lead to access of an uninitialized struct page.
There is also page_ext_init that invokes pfn_to_nid, which calls
page_to_nid for each section-aligned page.
There might be other places that do something similar. Therefore, it's
a good idea to initialize all struct pages by the end of deferred
struct page init. That's why I'm resending Evangelos's patch.

I also tried to implement Pratyush's idea, i.e. iterate over zones,
then get node from zone. I didn't notice any performance difference
even with 8GB of kho.
---
 kernel/liveupdate/Kconfig          |  2 --
 kernel/liveupdate/kexec_handover.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1a8513f16ef7..c13af38ba23a 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 09cb6660ade7..1f9707d11e5f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -471,6 +471,31 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_restore_pages);
 
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory regions
+ * may not be initialized yet at the time KHO deserializes preserved memory.
+ * KHO uses the struct page to store metadata and a later initialization would
+ * overwrite it.
+ * Ensure all the struct pages in the preservation are
+ * initialized. kho_preserved_memory_reserve() marks the reservation as noinit
+ * to make sure they don't get re-initialized later.
+ */
+static struct page *__init kho_get_preserved_page(phys_addr_t phys,
+						  unsigned int order)
+{
+	unsigned long pfn = PHYS_PFN(phys);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return pfn_to_page(pfn);
+
+	nid = early_pfn_to_nid(pfn);
+	for (unsigned long i = 0; i < (1UL << order); i++)
+		init_deferred_page(pfn + i, nid);
+
+	return pfn_to_page(pfn);
+}
+
 static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 					       unsigned int order)
 {
@@ -479,7 +504,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	u64 sz;
 
 	sz = 1 << (order + PAGE_SHIFT);
-	page = phys_to_page(phys);
+	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */
 	memblock_reserve(phys, sz);
-- 
2.53.0.473.g4a7958ca14-goog


