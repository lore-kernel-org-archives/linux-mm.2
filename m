Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F364FD8777
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF026B00B5; Tue, 17 Mar 2026 10:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7961E6B00B6; Tue, 17 Mar 2026 10:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2DC6B00B7; Tue, 17 Mar 2026 10:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF576B00B5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:15:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F176FB7684
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:53 +0000 (UTC)
X-FDA: 84555753786.02.78DB6DA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10D1620013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fL0vQ6t7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3FmK5aQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FmK5aQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20jDT7vbb/pcwg3RWwDlyXHU14Ovqo1gDrXuULw2Qtw=;
	b=yJIj6V6eQLGDI0E8nJNVCC/Adzmiyn+sRkXpJgXBtUwIjFyAGHAG8LhqFZPINDhTl5A0rf
	7Noh3cozERlrDmxNkzqcoLgSHHwkUZnh+6Yu90qfyGqNfS22HQ45GSbFzx1P7moMaUM+Pi
	nMo9wmO3dlYi6dbkWu1PXoctG8xm/T0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756952; a=rsa-sha256;
	cv=none;
	b=7yfuuaDBcToSHF3uC29lkWDa10GmQH/d5by6Ajn6gm7e4uluau5ntGFxvwU/GmRjPDzuYo
	fs6sW4jZjNdY/jkJLT+hdPFk/X3IhffHglmmfJLdmKp3qVSQ/GGfM4bcZoL27TY1+RX8fc
	oVc1xx0UqCavtJgY3PmejzS0w25nAjc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fL0vQ6t7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3FmK5aQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FmK5aQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso76641245e9.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773756950; x=1774361750; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=20jDT7vbb/pcwg3RWwDlyXHU14Ovqo1gDrXuULw2Qtw=;
        b=fL0vQ6t7uS5ItgMeyiMNJIon75p/4rgfssyEpPVbTsvuMzDt3hyPCLrHBL+UmZ5pD1
         OpS1ljU8ylyLRo+zWE5sBfOGx/dX9nEHvBBltg7GOnjCy0vXXKP6XEbSdtJAdbttCKK/
         /bEk4cqVhAyd0tY8KALaGxnKfqg0IVkWK8QDVjkvoQm9gtoZI9FCFrzB9nOyk+Rr/ZSH
         S4pqW+HbbhwQpH8IF2/VBA/859rof2uBSnX7dDDuiuYF9Z+HxPF2VCrahpQB9XFquN/3
         Sgv5LLy+fUwJSQkucgEROuQX5x6vFhaOCfmDWuQ6XPwUb3+locO7GQllH49+2A+aRYWC
         RUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756950; x=1774361750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20jDT7vbb/pcwg3RWwDlyXHU14Ovqo1gDrXuULw2Qtw=;
        b=op6A2vCiFmwpO362Ef+LkgB+8mcssLbhH7HILr7D0o+4x63IkjdgNxdlJ+vVWhFwrr
         eQuRfp9WHYxOGNA7HRlOZ8oX0S6q1wGzqN7y5lwk423DNuGRdANEO153B1xlkRYNl0Z1
         /va5/qoyTS1F/Nytu2gUsSCpyC+zuxAlomh7xiQ4BfwUrW/JP1Pv79gfq3sf5XtD9z3F
         UrpYcXPYSrFGx/5hAUh/OOT5SIDX8insDY9tR7VHEyuz7EGR2VeIxSwgLr5Mnbtu4eMA
         IXaNJ2yITTbFjZyzQGSKkjo0+wh+UVy3SadLKB5si6ucl7cwKsk0QoWIvsQ+9BlFQm9x
         9jfA==
X-Forwarded-Encrypted: i=1; AJvYcCX588Iq9xQ5YfVSL5LJrc/TC/0W9fRF9IjzZzWirQw5Gp9kQcaERlPqe2Uxe7FV/QuSG7xJpzrZ5Q==@kvack.org
X-Gm-Message-State: AOJu0Yyxi1JJLAjjZ4w2v/muQFcL1O0QYfHdEwhVdLMp/bYx6rA/ZV/P
	CIY6UmYIE5UbWRcyRgW2QOtx8X5KNJEKYfEJ2JASBR1QoCtUoOxcfVqDCuJUNK/boNTohIgj1p9
	D5fPoLzTVv+2CJNf2I1FsiA==
X-Received: from wmpj20.prod.google.com ([2002:a05:600c:4894:b0:485:3c21:d5f0])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b45:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48556702853mr281166825e9.21.1773756950287;
 Tue, 17 Mar 2026 07:15:50 -0700 (PDT)
Date: Tue, 17 Mar 2026 15:15:34 +0100
In-Reply-To: <20260317141534.815634-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317141534.815634-4-mclapinski@google.com>
Subject: [PATCH v7 3/3] kho: make preserved pages compatible with deferred
 struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10D1620013
X-Stat-Signature: nz6enkeefag5eu9agsyai8j5h1xmcr34
X-Rspam-User: 
X-HE-Tag: 1773756951-835541
X-HE-Meta: U2FsdGVkX18BWQvJjZn6c7eQA4dsvwVe2xiZHf471DnDDB4YZf2xM6WsV5/72HKP92x8cP57s9FDsteAVnk+89C5vqzGbJwbLzPTh3IBN7iW2Uu7v2O2OcYJbzq4GpcShofwf3iXd5EP9MGmvVb5M2/1EfWi1l21odTcQf8hsklIojUtpKyTye0AFxU7ERE1WsYkB+5yRBJdT0Zrb504gKa2cBlTdumla3BggjPq4LLu1zDD8oxhtutVqawg2jg4nt9P3H1ug0geHFin/tHW3GpCTfCS/kuU2g0Th8gJW2JTF+UOCS+nf5qh7sRGmHPdpw0SXo38mrD62XuGuzbr3TTkr1YdLDBg4E4l7M9yDBjss7UnwxvoUhYu8r6xI8vE+1kfoHZqZnvk+85sqlSKO0IEeE+IvPhGvpPJTGIQo34a0dxutKPY935jqYY+QprddnJJJlIoRLo74IuODfIPp2GN58yvpQotZk9kaNrUtBOyRIg7BloqvkGZ3J26j6frPCU7H0G9Mc1TWo1KSZRCFkJV9RVsHpfWYRAAjxSU4UBg9440W94mB7iiAV0O+hRKliuUSYzuOwjOeHWw0Po8wXBXNGeVRe4QpJMFnto7A2q14Dunvc5P2v8HBYZB+IUd8ToP15HsfNFkMSFXIk2GGrrrx9xgRS0PpUh5IbehUsl1wymcX6A/oCjLFERltIWhIy4dBck0+hOFgv0A7Rzjo19vwWp37U1GY7VAwB4IDOuhCG+V91NUkhooVyMeIm7trMm/ffnIev0gMBv6Lu7rGyDgRDgwSBcOtMlNNC2S6PYR6/Hu2+cf2/Hl04Uv99zd8lM0fpwq+Dj/koY9M0hH0Pfky0ZP+qvx+kpT+4lcViDrHcRhNlcF0k+uFAypJW7SDlEnqY6uvxndA7dgkMkZvVetqntO5dwrOCpIyYoKoQLGkzCqvmZQoUsI9ZKBW+dOU5yJ4Ap+CqcaafMC/mz
 gOmEJWU3
 Y8rzHDhTGmZq6dexj/XYeipgsBiXW+lTeJzgSjHuu3yEIfeNjanXMwkWW9BJpgO43GQFNYByYwhUJsSveAWwnJTZyyYCRwhxvdGlQQd1ThI+tk5ah2qo4Sa3EZyzt0JUd9qHzLUGIdnazmbaI0LlwuqMs7z48ygjbflm++LF1Xb1dvXvgc5pzOq3SIy0btO0ercRaOt2iGQT8S2tl1CCJ/SCRDFyxSojU3Iy8vY3Jl+riyB4LFvgCg/zK0KHU09J44c8oZmVvDYz4MgonXvTlJ0uCIgIhidl7eNPQd0uQKwu1d0vwmF0UpeZk/f84SoJbRduTFypcXlvRid2FOuTV87qrN7XrECduxF2nKzla61mFvhXtbIhhET1DY1aqoMwZgEHfPNHRXdISfaJ5mWEdBX8vKb3yc1sb3zAA+G/749Jw+aOWxIqqypePObRB5TEo6JYDYbKH8rPlzlvfP2TYl5ZymgyFFhdI9ZV70qpXzeymmb3REclfEEWwNFj5Pk8P5YIrX97PytcmLG13osRswvOoXse8m+tzJNn/upVAmCVnHED802KA02/LXut4rbsbRZMfDazrm53+F7ErVkh/Z+UNrhtyHZBsX29LzDAvJL2fiKxUjdT82Fp+iZatlZskfwKAGYutN8JI0kCLr/fGnonwhw==
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
index e511a50fab9c..b49ebcd0b946 100644
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
2.53.0.851.ga537e3e6e9-goog


