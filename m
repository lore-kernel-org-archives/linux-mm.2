Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5E1FD3768
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727EF6B008A; Wed, 25 Feb 2026 10:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D25D6B008C; Wed, 25 Feb 2026 10:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E17B6B0092; Wed, 25 Feb 2026 10:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C20D6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:40:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E094F1A0630
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:11 +0000 (UTC)
X-FDA: 84483390222.11.EE01907
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 159C0140012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dyEETV01;
	spf=pass (imf23.hostedemail.com: domain of 32BefaQoKCNcF5E3IBGLDB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32BefaQoKCNcF5E3IBGLDB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772034010; a=rsa-sha256;
	cv=none;
	b=wvzUPzVtEYF2pYkRW/MYpk/0eTWux1K8J5awFnbw6gEW2hU1XfByxjCq9amnHW9ya2svqg
	iJZPllP2Zp/GHRHtbqfcTsxCLfn074gkC99qUXkU3m6P0LRG896W8ffqtJ3u424hFHF6hI
	D2t4lHn7ASGw3cfOjouQpngmuXOgvI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dyEETV01;
	spf=pass (imf23.hostedemail.com: domain of 32BefaQoKCNcF5E3IBGLDB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32BefaQoKCNcF5E3IBGLDB9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQzAMSBymjIc7twUCIwXZitW9lygfMtcVFGOkxE5cgc=;
	b=NLHx7+dJIlU+fDtux+g/SmKiRt32lZWNbs6tgHlp49Zyev/D7t68uTfvHeL0o5uSvx4cDF
	mXP3w0CKGjz3k/RMCzA/fLDBoz8k+7QCzVycW36VRDbUBiZbkLiZO8ep64qpMK4c5Dt4xx
	xwNMp3HT57GZfa9bosNB745jgN7Fwiw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so62033605e9.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772034008; x=1772638808; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQzAMSBymjIc7twUCIwXZitW9lygfMtcVFGOkxE5cgc=;
        b=dyEETV01h3+ArNm7ElnBA4cY52ELTukk5Cw0jVge1lmLT8uRTNXvre8noEWMUiBAF0
         KhW8DVP90ymYCW1P3FBKIotJknRH0qncmQ806xXCEx91wyRb9MSOTxGEvKL4VfNQDQZX
         JUJ0V75N3vihKn3HxtbC086kiZK1faTggrBhIq4gcE1AMtDkWygIyGcJ72MqTIinTngQ
         5IR3DadMbBBB9aULhJnFAIo+v5yZZ+1rwV4jbgCMbdgnMaFlYc7QKrUPaCI3/VsAX8Nv
         op/WlmWqJ3d1LoFzaDGwbsGgacP5l/8eLBL0y1Up9AlFMGm7/wFiETgcBEpa1k9U5jKu
         0Kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772034008; x=1772638808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tQzAMSBymjIc7twUCIwXZitW9lygfMtcVFGOkxE5cgc=;
        b=hTTjWz4fNZq9lquBtG6Hvk7uy48po/b2lMxLRFOQIsif9D/tcx0169Stf6hr7v92t+
         NhmZf9bgzKO3v/tBE7Z2cNq2nxGnPp+dbsnv3zyHF7U2ikNVR/MiPw4kP8mdW9ntngyZ
         eeQ3qOzhBQm35RkunjM5YjdBh3tC7J9spvAgZo1AF7VWsXg5BdGtfAYylGXLvsp/nyDG
         uNoEuH1wJOM52mxha0DTCxv5SMyOCrQ6JUQ8n+6atSmVRIgXceSZRMPwZFDFWhMi453p
         E6reSt7RazxHCIRIck/Y/ZPDNPV8vioDvHc8sjsEWfPx/TxQaGxdDZS0g3cFx69lF0Li
         Iyqw==
X-Forwarded-Encrypted: i=1; AJvYcCUi+PSlBXmpbcyJNTXUBnNl+Yvb610CyZI7v/xquvWXS48e5uuRHiFdDUO1JHeuGA9SbJkr0iqhXw==@kvack.org
X-Gm-Message-State: AOJu0Yy9igDP89j3Z4CErFd416dNcOMGyyhROEstrLFUoo1qfHjRqXeU
	mE/7RuD/LdUb4PdZMntr9uBGwpa55vNyy693vbDudY/XmL9f9BdQmz4G8YzwUnL0kcxHIfSwPKL
	PSe38lTzcKAx6Ca5mOVQMsA==
X-Received: from wmjs3.prod.google.com ([2002:a7b:c383:0:b0:47e:e47f:de89])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8595:b0:483:badb:618a with SMTP id 5b1f17b1804b1-483badb6355mr83029045e9.27.1772034008494;
 Wed, 25 Feb 2026 07:40:08 -0800 (PST)
Date: Wed, 25 Feb 2026 16:39:55 +0100
In-Reply-To: <20260225153955.1006649-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260225153955.1006649-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225153955.1006649-3-mclapinski@google.com>
Subject: [PATCH v5 2/2] kho: make preserved pages compatible with deferred
 struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 159C0140012
X-Stat-Signature: 8gjxntbfiwxuba14gesu1mbjmiep9ro3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772034009-358315
X-HE-Meta: U2FsdGVkX1+CPyC4lIXRhsA3PSMjAnrIOU7m3EaKwdBnavCx/Pi7d9G5p+7UEY54U0JvxkEIsZss7kV6UavNTh4HBqS/qhMF3O6l6VN3zbu31KMrdrFnAznRxF7162XdFpp0eH5lnTUNBA7vIzxuaNgwxQQrENm7nf7Yv2J9wUM7MQnAz9bs2L3vRoC93Q0vUpTNq4Js6ztlO4mRJvzQP2PU5kzGIIiclQCGFKFt9RMIo+RHU4i6S20k2kOl33mD3VcrAof7vI+VKy0O6bAgAGwYzuSOluID4e7ffwQqsXvdVwC64WfT6VeupP065dKtlnGo2LLQWG3SSmemlktOKhEQYLt7Xnwi++J05Tsh2eZXloK8GW+RBKP47Sg4jZIlbgQwld2h6oEiI1jGggbW3kBq4bt3tShGMIencVFJiMsaZznSra3GN56IjvMC8OcYDNghdURheihPPkcCqzuMxDBfTcjYBZotS816JaJdzZJ91YMzU7/GxRS8ohdGucgWGZq04Kj7m5d9UiGVSdzc5hdPql8tIGVoT90p7ViwKggqmIXoOz/e9/B3x5uZQqNikXtdcoZMc5nISki3/U/VijsdBKsg2Ty8SogEY7v0Vk5FW1JNH8J6EccjqKQS+CjhLh1EqnKhcO4IrQ6m2RyLKhShhRx3+Stf5fp76hw2KgHz1ogtg1o3ICPxppppsPsH5du7/zfG6oetOPRuaGv9KGJ9/hRop8rrgZfX7Xo3yRrecj9Fi5/pFNf/0dQFBDXSWC8eJgQaEiI2arGy/dOaRRSiLZei7ZnyTd7Si3bCeS4LUBUckEbsd6g4Fm/lPHXN5+YFXTs6lnoB9BWDsrSYybQCzihQRPoqHv5f6h49LrLL+eu2bsB8v5hO65OEnDuRilw7GoGbyAUgaOBWVoH72wviobEeLiJMEm7aXyc0O22NH0Jb8i23caNe+/TQi4Js2eFeSYU1vBlEsxLDrtd
 Pd43LNcG
 CiAHDlOk2qYI3VsEXvNIF/0Wsofs+C85I5FSx1BXsdqBlYndPks3HD88aKuqVaj4giJ0aHFgUDxu8RMwUgneYq7WHJMo/zupVlgh++CePoXuHXG0tmkVC7IEsU0O2Otqexs5/Hh9GBkPLei6upd0S9EJMGx+o0+Z/I2cV6SioyW9OkFmAzN8xFEvkJEuI1qpJOLk9MQi5eUtsf3Ogp4830xjqXMRaMi1kVaTId/V4lFN0O0JZtBeO/BXs4s9EduoRRHLSxuzrUH885E4V0ZnT7QF1vatsJBi9RN1+prOd1m6m3vwM2Riel8t/RMS+qr3eXTjK5glPkvVUFx5fcCIGmhSf1TZ2Y/WIIySM9yC4lMrDoWdzckQmlBKef3DfEzVQ0iQ9CgDqk/QNiLKomN4V7b1njnJudbxGyNVwLtLkWwhmueZC3i4FdjU2iWsPh+Ww2ao7lHyAMr5AmZ8QtKfebM5kRmZjuRtu/9Xn8iaDVYiFUZLiIFcnJUSYGLF/dazaDgaaJtPs04MAmo+v4YGknbU7HiV9eSgc0Nq4Z37IWPwIBR0TGYRR6XkKeq5PtBZQj0G2XlMKtBTWnZeoMsW/f/pC747WWrT+xlEn09SEEu275fDP/I789dSbB3Pv84Xlhw3mvOuQHV0yVJFxcZqRJyn2kHlVgNuQDXdEqTuaHWC6QaFEvxBKaHIIyUplzv6Zjm4L1jWTI5iOSLofkaT8j3eWbf2y3bY4pjuQULPG+Rg4F3A=
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
index 1e1f69b10457..761d7c9c1ed8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -470,6 +470,31 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
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
@@ -478,7 +503,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	u64 sz;
 
 	sz = 1 << (order + PAGE_SHIFT);
-	page = phys_to_page(phys);
+	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */
 	memblock_reserve(phys, sz);
-- 
2.53.0.414.gf7e9f6c205-goog


