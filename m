Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E04C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DD26B00AB; Wed,  1 Jul 2026 07:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EB96B00AD; Wed,  1 Jul 2026 07:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FAE6B00AE; Wed,  1 Jul 2026 07:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76A826B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDA8340350
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:38 +0000 (UTC)
X-FDA: 84940032996.12.A4DD1F1
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16AF31C0006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n6+QUFQK;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906457;
	b=4AsAHYlJqsxZZjE8wsxq1LnhfXFJ/EN5KJbXA7rqz1fHbJI8LzD6fLvDdENXJICrzxkJi6
	aTxu+kcAKhxO/rRVQE9SoA6HmAtst5tiZFhajiQxvtyLs5S9aYWtdkapxo7Jn8rjRsIlIz
	lg1kN3Fna6BF9stP8P5vJ5JAzSgT2Pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6atn2MDoT9tTt/oDby2aqEaUDrPUuFD6g1qMrGDKd0=;
	b=ioP/lvcs7V4hGsLjtXBsaSMrTxLvgXYoHKL8rrPS4hfqdlGEnBgZTavijzpTpQjE7dbF0e
	KIwwUj9RWeoWLGayGfYj+OoGq1VzRbTZiHCV6JygKJrKT5v3Z3vgm2pMbQygEcAyKAXmjI
	t6LZ0tQnFzcVWFT95VxLrFB6umK1QHc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n6+QUFQK;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30cac93dfd7so1322381eec.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906456; x=1783511256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6atn2MDoT9tTt/oDby2aqEaUDrPUuFD6g1qMrGDKd0=;
        b=n6+QUFQK6IN5/6zSSrsuhzHsQp9A3k/OPS/uhGaQ7ASoM6NU3nQC13Fz44LoabsYN1
         a9JkRJQKriD6LrqFSE7224Z5C+G4Qju4VI8H8jJsvOsK43lIb052HMGtyqLyoberzxdm
         dILrs3B6Inpo2Ib4cc+n6cks0Iqn/J7E1lsgWI+GejTw62lPC7hWszuQpIVzpqzRClfi
         H1KAIVFLQCawhiNogGLZ0Iu1/jwoEEXcGWqB8T2N0w+Bn1ufjBBouC3+ad0gAruk3cuK
         cCjYbS9xuS5kec0i8jkcwBmzE/ypVuX3jmCaDP5uaVWouiRCHnPtj6qfenFemCiOFXtL
         6UhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906456; x=1783511256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X6atn2MDoT9tTt/oDby2aqEaUDrPUuFD6g1qMrGDKd0=;
        b=p+vYFGYuuT6Vw/HiycYAJ8hi8kfx+I3QE86wGHaTF4hZEJo6r/TWbOCbd0jGcg3Jmz
         159dubCv9C9qZZZ8mNzc0e42wao60cZU3LdMCbNy4AuM68pg8stYW+hMEn6Vfecy6uL4
         AiBBgszwcvB2/LiXc6ks16MkzpNtKgUb0lyrBeAlZXhWQ9Bqv7yHUXL04ZfE51hBPsUj
         mUNaAkiASuchD0VXLLxqjNqJbyjvhe849ibKQlKLChGR54IMWUVfhmnGHOveNlCrn2tm
         pUtsu2oljOpmfrfq8RczVL/OP+Q1mC0HRUX8qejtM19P+6WPGip/guispS6FILSD0VfY
         1pMA==
X-Forwarded-Encrypted: i=1; AHgh+RqDEvRRqg2oObFA3C/Ubk/eEDhfNfen2/QEXW+BDjO+a8EhlDjLvnihSkMQAqhQDkfNoog+7AyezA==@kvack.org
X-Gm-Message-State: AOJu0YxP9OiC1WOpSIeAMSGRc/dKBd6Uqzk6L0B9zNIJO5TgBgdDdjJr
	cfhniyacw8QrsQy/ZOd8NsYnBxFlaAr3usv20N6fQOsPeXRzdmTmB7Zj
X-Gm-Gg: AfdE7ckWcSCPPtzRdmdYUDMVy2iLtIrcFnix24o4ikCTZPnMj4EnTX2ymIc/00fNKKy
	8u7ezuSY9Ne7dnZ+EztfCG5a08qsPUpRyzzdxM/uLhX57gB2QaWesRjR7ovIU2JQ9DSO7fGEeme
	2XTjuFyLdZ26MzcXfKv6Zw2X8+wdctpmA1BUs94/eh2bu3f0vFPZqEUyLYuH3UU5L0/LNJ4c0La
	wFmM2dtXEmYwL9pNiucBDNe1GdbOfbbQV75CrXuEbdYxN8gCVCPYUl284IefsYPBeN+sUHid7Jm
	0mbu42TbtNl2i7wfPqW8NbWr4CRemH1f6HLiIL4S1120IOpb56P2IQpkd1ZIH7FZCuXtN19Dx4O
	E3Em2+4eKTyIFSPnMFmx0zRdhwZsC0Wr8ARQ0mgWQ6ObzhZnmli35GDv1dmqSfnIhytYS8lmYpk
	BtDQ==
X-Received: by 2002:a05:7301:1001:b0:2d9:db50:c6ce with SMTP id 5a478bee46e88-30efe6d53d7mr1600277eec.3.1782906455878;
        Wed, 01 Jul 2026 04:47:35 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:35 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH v2 3/5] mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
Date: Wed,  1 Jul 2026 19:47:14 +0800
Message-ID: <20260701114716.56503-4-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: <20260701114716.56503-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16AF31C0006
X-Stat-Signature: d7t7ztx3mdg9ydqk9yke57ntpnhwj39c
X-HE-Tag: 1782906456-128718
X-HE-Meta: U2FsdGVkX18UsrFCluBZ+PQjeQ+Pz2qExv5NtAr8ZBETiqDrW3b6pY6hnFKNpnl7+eJKDizTTYMfBMCE+5slO8eaLamsXqTXmK/2F9spJ6tGHQsZBkyp7WhKTT9l1dENSEFxcEv9E+8mWfty1CUTesKz6ADZId8ncPyRXokIctPi9C33Zl3bbGe6VMjNiyJ38L12lh3ScLPp/KGknEDh8SZdJs1Sh5STz+UAUzuy093s42aC7g6DJDu2HUKD94+56l9P8eDG3WVvbdtgh71RFcL+oHoFqbHfjsr1FM7kgYP74+6NwJxHpCa+UAImrciRpsC7USP3+1QaxKoCneCwD9pfirphZJ7GOtxlPqGiGkS6GjxM+89WsLEOKfOkg8mxsBMJNp57GckUcBmEJDoM8xZXZXHz6fr9K4he6r6Oj7sg12gQrIxTS3ghLpMqOYMQdHk4oI17IFWRNK8lUbBfC4zHjCnkMqisVGFMGjjPW2fGe0O2A4EC+GGterWaLolsi/E7/mQf91kAm7nPhTXg6Lqrid4fN2egHX6vVpZBrQHLgL7Hkw8sNphr7QNTCzj7P8HW0uff/znPau7UxWg5MDBr2y4zaFWZGJ9JrCJvKDK6fQDypS8asQyY5uokmoWUxORyntUbTQ1l8kfLqBkPUc9OdUy5XBtMqqJRmGGpYq/re/npK1NNzhXxB0sBTIz4csVKhztrwMzDuz88sV9zbrVWClDQW8rtx7FJXh/oh58EdyOuBy6i8vgDIN8cTtqKlhRpV4VzkanAzCD2sPBG1pT9jf7ecGjm3xOe/pEU7/j1cvh4dGn3/LfqXDLM/v/e+GtLWA4wtRn2aBrfhDUOFpjzFV+lUcqmHqff7dsFZnb+CYqN6VIpQcr805w5tqseXZjsQk2k8MabZsh+LHgtC/LWLLtPvGggYxsxCK9tAaA2JmS4ak0q8gE+LsemXkbXUJXp57ySX3lwAdm+qCR
 0enNrSYI
 oyJ80cx24aikncD7hTXgPAE/nSESnxewz8T+7ICeK/LWe0Aef3Lh+QckShIcrw+qcEk/Y2lA3wyCj++wujhvnS0aO3jY8xPtGek9H03i3yFhx7ZUjxMNltKCEH0OseilbwUs5B/K5K1sOCOpADZL+z3TQAmUjxKfc6H4WieU/CkMgdauC8sVZS8j1MouzgUqlPJFHrbMDQWGXwpMVnG6ZfAopQTQyoZHb6PgQygeVuaAMyd+EwaCcNeDMCkgg3phR/izmpuKEPFykOfwGOxtJPavVye4Bl7bSORNBIqkVMw+SKOLw9WsVSaPPOX8zATRlD+2/vlkg++ojnwJQoRpwSjrmY9MkZpPQthaSNctRRwc0vuu/2qh3kRgahX6q8iBkiyL7vHELN6IVMePtCvp4fJ8hcXO4bAImWBd3qr90C9BNtcwKVbiLBZgeroxLQnTgIYLacTTmDgu/WZB0Y0qR50kuKdMkG+HpLtFYmcwx3qkHGfXG3UH6dYKfbPXueDtVVy95c2rpRYjAVJfE/6NRHNm7mI79grBqBKWfBk8J1dNBLad1DqsnkU24uEdiq1ydNX8uQyXf4pnIKvtecY9+XKIFaqpcODsFM1Sd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

When target_order is set (non-zero), the DAMOS_COLLAPSE handler now calls
damon_collapse_folio_range() to collapse pages into the requested mTHP
size, iterating over the target region in order-aligned chunks.  When
target_order is 0 (default), the existing madvise(MADV_COLLAPSE) path is
used, preserving backwards compatibility.

Region boundaries are expanded outward to the covering aligned range
(ALIGN_DOWN start, ALIGN end) so that collapse works even after
kdamond_split_regions reduces region sizes below the chunk size.
collapse_huge_page() internally validates VMA bounds, so expanding
beyond the original region is safe.

No external mmap lock is held: collapse_huge_page() acquires
mmap_read_lock internally for validation, releases it, then acquires
mmap_write_lock for the actual collapse.  Holding an outer
mmap_read_lock would cause a self-deadlock when the same thread
attempts the inner mmap_write_lock.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.wang@processmission.com>
---
 mm/damon/vaddr.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603564..2a3757c13bf0 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -14,6 +14,7 @@
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/khugepaged.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -899,6 +900,40 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	return 0;
 }
 
+static unsigned long damos_va_collapse(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned long addr, end, chunk_sz;
+	unsigned int target_order = s->target_order;
+	unsigned long applied = 0;
+	struct mm_struct *mm;
+	int ret;
+
+	if (target_order < 2 || target_order > HPAGE_PMD_ORDER)
+		return 0;
+
+	chunk_sz = PAGE_SIZE << target_order;
+	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
+	end = ALIGN(r->ar.end, chunk_sz);
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	while (addr < end) {
+		ret = damon_collapse_folio_range(mm, addr, target_order);
+		if (!ret)
+			applied += chunk_sz;
+		*sz_filter_passed += chunk_sz;
+		addr += chunk_sz;
+		cond_resched();
+	}
+
+	mmput(mm);
+	return applied;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -922,6 +957,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		madv_action = MADV_NOHUGEPAGE;
 		break;
 	case DAMOS_COLLAPSE:
+		if (scheme->target_order)
+			return damos_va_collapse(t, r, scheme,
+						 sz_filter_passed);
 		madv_action = MADV_COLLAPSE;
 		break;
 	case DAMOS_MIGRATE_HOT:
-- 
2.50.1 (Apple Git-155)


