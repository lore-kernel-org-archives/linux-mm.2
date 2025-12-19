Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72661D711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 03:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEDF6B0088; Thu, 18 Dec 2025 22:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C806B0089; Thu, 18 Dec 2025 22:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999156B008A; Thu, 18 Dec 2025 22:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 874D56B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:09:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DBD7B92E2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:09:01 +0000 (UTC)
X-FDA: 84234738882.28.370FFB2
Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	by imf12.hostedemail.com (Postfix) with ESMTP id 40FA440009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:08:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e9kneTzz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766113739; a=rsa-sha256;
	cv=none;
	b=3GguYbGLqPYhiAFGJ2CaoAxSFEWqZEwsOOGGYCiMxBkZOEOC/h9Mwwqr7Xj1v2lMnZhsCO
	IiTKp4s8VOko6+enW84qBWoRRWAceI4rC5xENcLiKcsgpBMfU/uMpG0Hd7XFjTsb53ILsj
	3muCQYTR+jLBoXJtUzJZMpAEa/gn/d4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e9kneTzz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766113739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r2/OhVQU+QVH8G/cODFOhwoAozt9Fs2Kb3PN40QPAds=;
	b=xzOd8CwA9g5aULrvs0H8fkKuR1crdkQHGvlk3SFeEFTrQMTtXslKMbW1oNNqxk5JJKj4Vh
	2wcWIlHC2UUS3Ctooht8WMMfOnnrcCOqUSOTwISUNSn6xUVo+VGUfQ7pGWLWe6wQTMeFAa
	dC2ZVZ49R6kYkg8SePQgC0aHrnW3j7A=
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-64471fcdef0so999736d50.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766113738; x=1766718538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=r2/OhVQU+QVH8G/cODFOhwoAozt9Fs2Kb3PN40QPAds=;
        b=e9kneTzzwqhVybYvFUnP8RhhUN2s+DY3mRSREI5GZoxyWZ1FMC5H+iwOzRVqT/pPf3
         UvjEPMng+497ZU8RQU35PzY7l7R7oqJFBmfNazYQSEJmyihkL6yBbn4ivJLHAO1xTnxq
         BCPgTnd81E9NGXdMAdTix5MkHaGzSaLk7GNi1FV9ELeQLMlcbmCDCgo9P8Yh2Q3Evs05
         9w1Fh7r8gSQJ4iU5+jCVePPIkvILdzmrMMjvO87+tUTPU2icevWt2ceMBEWL1mbR0StN
         //Kg2yahwY6fCfN+K90wJFbd1ajgrdCqKvB1hAcFcxNPiC3TElaLd/Iuh1LAet4PxCVz
         5adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766113738; x=1766718538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r2/OhVQU+QVH8G/cODFOhwoAozt9Fs2Kb3PN40QPAds=;
        b=lnyHcLGi4jxyHEO/nwlpZiMJnNYkJFPA9Y1KksUzHJD+dk9w9bu7bd2yJ5ZUdK1zuJ
         z2qCsmQ1RfsDkSzE3njTpSYm/N/MXBC5x6bO/dL916mI7TAAjKDNlQbIqROe1B2TtbKa
         hOXi8BZ+e0DufZ5XmovTgXZFpRpJ7sg1NiJO79N42cw73d0xmUGBZwg8iUzxUsxckkBI
         wWKGMzBkdqiGF4Q6TYPx2DI5NnCp0JO16NYC7PHVTjqjbbdcihYIOYgmfxlCAZ0YpE+z
         OuVgqB5ycIWEdJHh6kFWHqGDv079g1LY7zdQcpZdRDP019dp9JlClogy7p1CGwzAh+Gq
         G5Og==
X-Forwarded-Encrypted: i=1; AJvYcCUmqicqS0dZeB2gzTFsNXTJN+CyJQ8u1yCjwIPotwJriXRM2lTmsFlAceVC0MFb4g2021TR1MzxlA==@kvack.org
X-Gm-Message-State: AOJu0YynoCEhzusHDU1eozk3rA0ikpNULtJHv/Iclrlbf6L9m0a9Gbsg
	AGAYKjHVOotORU/GVeNKP4f6FlUAxj1s3eZRTnSIfb3A2BBhJ+5OPiN0znG7dKQHzEY=
X-Gm-Gg: AY/fxX6qVfFmBxqK54zia54wHt//y52a6Z8Szwufgigw+8TPwI6rqKgFpreSG2xWZvy
	8CF+qv4Oww1E75i/SGsqI8VHFqs9sO2+GTjEHxNfA+B3pattGUYzosaGWBd4pjvnUVN5Hkfztwi
	7/M48lUQlExE/NsDL1pwtZXtjyZSfJZgpgHyHbFTBzKXSli8yURl8V24KCBuFGRU6KJMlHaB4HG
	dqRqGhhYVOcOQxOTMVDdYQUNdNO4Y2Uy/3B1CWMd54Cm586PmsrRJPDxT3T6dXzk+qmba114muW
	zSsuAEBLd4np56hvN2CDkJc1uc0bsygULGaWS6esrxt4P9IxE21vC0i/zEpS+tIudySJLngYlCd
	RCi9X8YpO0R+bfo0gqWBmoXECbSb8cs6PRy/iUj1Gps2BEqrxgQNFAs+k4TowzvEPXpAKH4NiKT
	LDN0yflOF2+4xhJ6RR2XJKin5k0RLmaPc4b7WQ2BSeYPYMn0BxZrtwRIkjjxXdwxQb28A/WpciE
	mdkHNU8eZIct49a0ZtDcrR8wsK/uzCXzpMlDA==
X-Google-Smtp-Source: AGHT+IH0SFFGcLuZ3Rz+C1B/s4/iGdSlEwbIjM/JS7E1t+K9R5SfPZNhnq31cCe+ZYL8cHIylt29xg==
X-Received: by 2002:a05:690c:c4f6:b0:786:5afa:375c with SMTP id 00721157ae682-78fb40d9808mr27748627b3.67.1766113738125;
        Thu, 18 Dec 2025 19:08:58 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb43790dcsm5069027b3.11.2025.12.18.19.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:08:57 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	pratyush@kernel.org,
	ricardo.neri-calderon@linux.intel.com
Subject: [PATCH v2] kho: validate preserved memory map during population
Date: Thu, 18 Dec 2025 22:08:54 -0500
Message-ID: <20251219030854.3527871-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40FA440009
X-Stat-Signature: 7z8gn84dgx9o131ass93shugi7krto8e
X-Rspam-User: 
X-HE-Tag: 1766113739-111725
X-HE-Meta: U2FsdGVkX19/mkSh8IwU+9Otvyqpr84sFlo2onDIvDi0qzSsIVCtxlEzbXp4WRT4YQxuauxIZfZpW7u1mE31cxcxjFo1BOt76iO0mTHF6Jjuae7gQanWtX1TnKzGwGMd6B3Kyeond8axKS1TfbrWFkCToSC/P7mK1RJ9W6t0efN/J5jEmgRyqa8rIBm0tp0+a8k4P5DdjkEyB2UbwON0m+SjPadLtVSldJxCIUjaTr22CBtFh+kEF+YamGuDaLhnrY36NwSXZMaNoM/lKnXbM4j85KpobO7LDipDB/2MgxIF508MjmjRb5XpaHs0DfvIcHYRr7lR6GeLUiPv/qu9d+8bVU+eUiPORVP+VBC+Z060xfFagfMPgbj++YkW5ZAD91iHbM1dqcGNOd+50PjwIuSbxUtquEmCf9RwegANlY9AtWKIpheC0Kt2cI5eIjf2+60xH6csNO3B45gBEzPiINrik45QYLGHol7V8GfqQunmX9PqlAk/tRbI8LkOJgQYEVUWsu8p+0UkR1ntGAPG9G0D6U6FJmSI/io9ZkC+A7H4FTqZQt7RbHPQnBpc+VU+sQ6whsDqtQ2Wgci73SM6wNSm3mum+O5zGonER05A/cRy8qYN3sthHrOdFlK4HtL4AcMB81eqxAWhpkFZm+SLLI7UYuTh39BKTaUxkj6prNGkdAU/KFAB1hogs+kwXbF2ZuFokAhDI9PDReFZ/NWsJsoprvMnl9mhRG59OWldHvZ//YYi79KqH+oH4yTiayU+YzohzdgH6LpxyMBG3CWklI5ngjcywsOxq4tmZlhrTak6DRuJgrfE1jfLsoE+WdWv7qNFO47u0w7l6T0yusaN3SgqV1IK44HlNLR0MwrItws3tIBiQOfUn9qMl0u/XL6yTApo+/adGwWK6yyp4l8OBT5kdLQ43JLYU23UhyFwTQVFKnSxC7sSMKyWaHqmQsBn3iw5gpF4Fgct6T0R+/W
 c08KIY1y
 DnAFgE7A1j0mnmhYRbcw3YavDv28xQ0JzcCETqiBIbSAwDc7h70hX1LjokSaIZR/QoIUAyb7GNG0f1gdcHd4TVeRkT/vP1XWUdmGH53dyHnVGTHHdv2hRheX/UuDnIXeXGzU5lukfUe1aoj64mPK9T1MVc4zTVFVe0rxf/Cn5aKVgzHQnTEcSr/e/zTRrMqz9vP0ZQV4NyH/WupKefMJDfz+zMyo3KHJX7L82zWvnEM+Se+SL8yf+PgF/NwhDAk0XG2zHDEjPwCwIb/LxaalUwTxP30+1QapDuK/ZqOeKe8KF91MUWnZJGNvu6jVGOTbk3/qHgGiID91xNT4uFpK+sHsKWQUM62SE9WzIWz92tCI5qVnU+T0/e1aV6W99pnXUI7O7pKOsfL41mPOQTBG2Z0tWLZ/4e8l7DLmvh+UGqkIPhqrN1n5ZWFIVMg+nqFNwLp2Yv5qvwae7LJkjUfppYfQwInS+KKd8A/uz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the previous kernel enabled KHO but did not call kho_finalize()
(e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
the 'preserved-memory-map' property in the FDT remains empty/zero.

Previously, kho_populate() would succeed regardless of the memory map's
state, reserving the incoming scratch regions in memblock. However,
kho_memory_init() would later fail to deserialize the empty map. By that
time, the scratch regions were already registered, leading to partial
initialization and subsequent list corruption (double-free) during
kho_init().

Move the validation of the preserved memory map earlier into
kho_populate(). If the memory map is empty/NULL:
1. Abort kho_populate() immediately with -ENOENT.
2. Do not register or reserve the incoming scratch memory, allowing the new
   kernel to reclaim those pages as standard free memory.
3. Leave the global 'kho_in' state uninitialized.

Consequently, kho_memory_init() sees no active KHO context
(kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
allocating fresh scratch memory as if it were a standard cold boot.

Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
Reported-by: Ricardo <ricardo@example.com>
Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
Changes v2:
- Removed phys_to_virt() from kho_populate().

 kernel/liveupdate/kexec_handover.c | 39 ++++++++++++++++--------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..6ba554208c81 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -460,27 +460,23 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-/* Return true if memory was deserizlied */
-static bool __init kho_mem_deserialize(const void *fdt)
+/* Returns head of preserved physical memory chunks pointer from FDT */
+static phys_addr_t __init kho_get_mem_chunks_phys(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
 	const void *mem_ptr;
-	u64 mem;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return false;
+		return 0;
 	}
 
-	mem = get_unaligned((const u64 *)mem_ptr);
-	chunk = mem ? phys_to_virt(mem) : NULL;
-
-	/* No preserved physical pages were passed, no deserialization */
-	if (!chunk)
-		return false;
+	return get_unaligned((const u64 *)mem_ptr);
+}
 
+static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
+{
 	while (chunk) {
 		unsigned int i;
 
@@ -489,8 +485,6 @@ static bool __init kho_mem_deserialize(const void *fdt)
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
-
-	return true;
 }
 
 /*
@@ -1253,6 +1247,7 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	phys_addr_t mem_chunks_phys;
 	struct kho_debugfs dbg;
 };
 
@@ -1434,12 +1429,10 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
+	if (kho_in.mem_chunks_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-
-		if (!kho_mem_deserialize(kho_get_fdt()))
-			kho_in.fdt_phys = 0;
+		kho_mem_deserialize(phys_to_virt(kho_in.mem_chunks_phys));
 	} else {
 		kho_reserve_scratch();
 	}
@@ -1448,8 +1441,9 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
-	void *fdt = NULL;
 	struct kho_scratch *scratch = NULL;
+	phys_addr_t mem_chunks_phys;
+	void *fdt = NULL;
 	int err = 0;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
@@ -1475,6 +1469,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
+	mem_chunks_phys = kho_get_mem_chunks_phys(fdt);
+	if (!mem_chunks_phys) {
+		pr_warn("setup: handover FDT (0x%llx) present but no preserved memory found\n",
+			fdt_phys);
+		err = -ENOENT;
+		goto out;
+	}
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1515,6 +1517,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
+	kho_in.mem_chunks_phys = mem_chunks_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 

base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
-- 
2.52.0.322.g1dd061c0dc-goog


