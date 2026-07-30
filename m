Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590FEC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4813F6B009F; Thu, 30 Jul 2026 05:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459576B00A0; Thu, 30 Jul 2026 05:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3489A6B00A1; Thu, 30 Jul 2026 05:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0404A6B009F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:07:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 746A64095A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:08 +0000 (UTC)
X-FDA: 85044863736.11.41F2610
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6286140009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tElfY+Cn;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u00RxS2OEU/Jkrk6J/93Lztn6eTwvbQr7TbXJRpbv68=;
	b=RGOutlL+mcaYxIHpGNM5Q3ScmtTVx33UsXN1SjZQWHGtzlesuNC9jIATYy2RG6VHYF+v3F
	Bn3/NUwzi7VSGre0ft3hcJINLRAKkWJAe3aDDDVHwXLyEWTKmbEBw8U3OAV2vkGv3ZAkw/
	KbUl9UPBI3qliKHjPvPQt05RjCpLSno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402426;
	b=GHa5sDwNTAUH7zwecOgnWEm7bhRdEje31k4qa/s2qloVU04YI8h6i/4mbLGD8AItc+BfRo
	3nPkTtdSQXeMolW1A8N4CRf25vY10gbqbQY7uimbKcZ/Q0CHIei7WQx0kuRiuMWaVGWdB2
	CVV58/z2OaE4JLJ2JcC2m7cPNTjA1Kc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tElfY+Cn;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84eb53344afso166744b3a.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402426; x=1786007226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u00RxS2OEU/Jkrk6J/93Lztn6eTwvbQr7TbXJRpbv68=;
        b=tElfY+Cn7OYpcoPWvIglYRzxEISEsZ/7ckDLEQl+1ITv0KqFBiQRdRFb68fgj6iNoM
         +ZLu1V22hyyUD49OjdBTvgy29CryHini/OMhbZNJLr/GPjmo99c7TsPkdtQpz5BmnvfS
         rmEW7C4I+5FZ+9KbNeAR9p7Sb/VlclGrCUStIosI7XT1p5hV8a5UPv4bVusoCpX24V9D
         GmiFqpQDPMMFNEWyc2g6ykFQLs5nxFTLbLv15lh19iMcPxKsf554oHzk0rNK4ZcfdQMv
         yhOnVEi4T36Qto7P1VIM26nfL7RtDywaAhv91WhQO0NtVs0pY2FBiwnouSQPfgOb3XTh
         Ixfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402426; x=1786007226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u00RxS2OEU/Jkrk6J/93Lztn6eTwvbQr7TbXJRpbv68=;
        b=A5LwNAAr/7tjLqa9qt/YEE063Vr/7/Q5iEESjmbxxyWTnGMh9YhJ2Ay+NlX4cneiZy
         iA/dKJYlj8jt/xmQ+1V6oSU0uzvg8ya6rsdW5nUAvcMpkZQXELEcZEi0BDo1I8XpOWQV
         QOBngB2Eby6wSIDY2ntXQsXJ2K6N6qWlQNjU9DcatfqrjoticJzKkMg9c24qrHRjAhoA
         U8jVxpExmDaXMCZf398oLSv7Ixtr7C0jq0mlK64VosWxYWLIkWSe+bGYSJlIGvTRitmX
         rH4WXyUDnDhxHXkvAA1XSUcK/omtTUniJPgwnYfQGFMQGANc+kEFWhpUYMkfOhTxGUkB
         kJTw==
X-Forwarded-Encrypted: i=1; AHgh+Rrs29rEH8FnN0+75ftyPJ5AfZOQ+UsNBiAyhHT2bO8tYhJQdIyoJvTE8bdwtWEoh+NySEj1balxwA==@kvack.org
X-Gm-Message-State: AOJu0YyQRyYIEMBvOfWq6hTj/pYuCPDkdfErzcJscdYFJ+hbWd5tm2O8
	/yDb0+igsV5VBVKlqksAGrEndjGa+OiPjKbEtuvXUTc3d+ZG863TjszK
X-Gm-Gg: AR+sD12FfulEsbMCKAyJmr8c4tIf7YSYHBL/1sMMIJqy0Zg+nWlV5guBzGL58kfQGFi
	IKxbeFH0UMU2UZF3uhfwkyC6EY36OobVXcx+iBxZ3YUvn2ENaYDIOWhzbra3eDs8BYhfH9T0L8j
	KjVVecRk0iTeQAq/0EI+9LFlMXDEg8vAZxs9X+ATOJcPG8hjaPbK/lbNYM0JD/iPzyYmesfdACL
	NblMKf5sZp6M3H9OAGHacFsS9nfDE8OsWFkgwWUUj77adaxwiO3jDkLcyr0WmOUrmGgvDdAbAUM
	CJtc4RsdawiAHjJj98e1gK6wkJcCNTjJUgbAMgJ6H/+s8dW9n/fZpoVeRBhI8LLKhxbbwaNPThP
	Wnko/R1V+L3a/W4fOzrshds5lrhOLThrZbXfExGEqmF1y0/o9jly+4gkgsL+iTXAO+rQvbWJugF
	e2LZDbnoaFug7YML0KOVMHWYOaR9BInh6BgOukK3fQqEyH4YVdejs6iZh9TYv4tkTprZq9z3EG+
	hsPfZhZAwZZN6s4rueTtZzGoSyuKNwzLWBYZfmZ2Ka8aEWqjlYoL+v9pUFPflR+
X-Received: by 2002:a05:6a20:7f81:b0:3c3:2dc0:7cbd with SMTP id adf61e73a8af0-3c900541df0mr2314097637.1.1785402425540;
        Thu, 30 Jul 2026 02:07:05 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba447107sm1902510a12.21.2026.07.30.02.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:07:04 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 1/3] mm: make persistent huge zero folio read-only
Date: Thu, 30 Jul 2026 17:06:45 +0800
Message-ID: <20260730090647.2401252-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6286140009
X-Stat-Signature: b8agmsm1q9qq3stars1x6hbcq49stqjt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785402426-659754
X-HE-Meta: U2FsdGVkX1+gAMiztUNXh1n4JkYuCKRiGX6SSUhAEuK2vMNfTyXca/XMr8O08pDsH9TnX5ubFyr3lHK9/27Kv/j/qFK+XuITW9e9COL3qZXwI5J772JsoebJiZ+iH/j1EuvUCVeTuVlXp2Zfhbp00dUTz9XCXIBhNcv464ZzwuZH0ij75a7w9w2L5HCCEyIjQbqChyhyEzk7Ri/SEvDQlMiOq67xwyJVuZJY5jecsXqNMu3WgHVYOgeHWGngiLaQt1FkepC95XoJYaEi08N2MFmMpvKuTUej2wHz1mmS7ELz46LwBkGnSB0tvP0pPdwtBCdRuE6JsWd1o/Xww0F8VzMuou4blAQjDKkLMtklI6lPWOp+WOJpasxwsGCP7FSMlWSSt5Qbqbi/rcFBO4U4ZzRX8CrsR6kmUS000zWXtQBsBr/kqIsfp6/H3PsQDebET4cTivhcNVf98ne/oFgoa118L/RxSjjymx3XphJayF8nuBArjoG8Uc5l8PIzxPvkatnk/l5e94DzBZikp6kNWQ8V/l2ckt0HcWKbM2xMXmuuYsSfGEBR1x28tR2ZqMjAuUH4im7vhsTmKFLvdPUjix5jLcM1nch6BxFcLeMM8a1hAVkqRWi6ql2l4Win94iwqvwF651SZuzPWuLnN9u6GnY0j3yQmSqdYK/Y8gr7yTeKJrzIf/89Ps9aiYnkVzvf+cFE31qbYdpL/JdfQTcmpVWc97xnSTujlpAgZ6btBxgGcxl8L4z6mTSk8dz/3UZXieUf6APaI5KPRxKAm8V8mH+ufmp2Uumd8ZwYSl6TiutsxiirR3XpTzg6kUPCh3RLu+N2kXFt4oJwXEW7u8vC6aupJb/nWSaq0F6EwHrlUiWc2cL/0UIj2eEd0AKaabCQCHz9EENvtzeKieOD67Ii9vcL1r/M3UM8tdVu7qRAMglGliURhHuEOo5YfKWxNUbBjNy7dH7bBdN+3T58sE0
 78BjpdVt
 5zCWb1zAmPePBBTonSdXCt8A+OvtfvzK7gD/dNl7NFmXcK9jC5Fmd/MMIktMUYp6ZvOmEwWrnnAQlUB4URdadKpJWH9aAGqzUE45MhVTHKk508ga1FFtk6dSlNSL13Lxko6ycJCAhqj6sOBhyuk8EA8MdqEt/3HDiAdV9KDjQ8X8yRbI+CjwLnqLoK0FIK2eMaOtOZP5FDXCuU+FTE+XV/IYdHdZiPPxEMoGhrNPdaiAw70H+aFubEFV5VKTXkGM47+lsgTtghBhKZudeGBMt8kA0oft7YLH4NOGyYdtF29SLag/JVshlwky+y0m+6RpJb1qfKBceOm1cJAm9aNMR0zB8PqT4Sqe45EWZiZDwahNq3hnLoNGXCYiXVqavdlj/Jt8VpIm/RnxAk/oJvt7jM1ymUkvKsw9ibN3xmaWiJT94Gmve6vWREfFSMzwzKiGVeBLcSiYmkwda2Olus1QhxPoPYh4vxkscHgmpQur7vo7OV/Y74K34WPS7Uns3M7TGZ0C0n/gJwW11iTpaA7KNSictOsrOyOi4I8OuVSaK3N6VqhReCvB5V2xlNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the persistent huge zero folio read-only
in the direct map turns such writes into faults instead of silent zero-page
corruption.

Add set_direct_map_ro_noflush() so mm code can make a direct-map range
read-only. Use an address-based signature to match ongoing direct-map
helper work[2], where existing page-based helpers may move the same way.
The helper is direct-map specific and leaves TLB invalidation to its
caller. Architectures without direct-map permission support keep existing
behavior through the generic stub.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Stale writable kernel TLB entries may therefore
exist. Flush the direct-map range immediately after the page-table update
so they cannot bypass the read-only mapping.

GFP_TRANSHUGE includes __GFP_HIGHMEM. On 32-bit systems, the persistent
folio may therefore reside in high memory, where folio_address() returns
NULL. Such a folio has no permanent direct-map mapping to protect, so skip
the permission change and TLB flush.

Treat the direct-map permission change as best-effort. Architectures that
do not implement the helper keep the existing behavior via the generic
stub.

Inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[3] with Yang Shi.

Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
Link: https://lore.kernel.org/r/20260727113530.5cd347581a66b3279490a604@linux-foundation.org
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/set_memory.h | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c           | 20 +++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..e83ced6a3827 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -40,6 +40,24 @@ static inline int set_direct_map_valid_noflush(struct page *page,
 	return 0;
 }
 
+/**
+ * set_direct_map_ro_noflush - make a direct-map range read-only
+ * @addr: start address in the direct map
+ * @nr_pages: number of pages starting at @addr
+ *
+ * Make the direct-map range starting at @addr read-only without invalidating
+ * TLBs. Callers must either ensure that no stale writable translations can
+ * be used, or treat the permission change as a best-effort hardening step.
+ *
+ * Return: 0 on success or when direct-map permission changes are unsupported,
+ * or a negative errno on failure.
+ */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
@@ -56,6 +74,17 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+#ifndef set_direct_map_ro_noflush
+/* See the comment above the generic fallback for the _noflush contract. */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..2dfc7a4218c3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,8 +40,10 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/set_memory.h>
 
 #include <asm/tlb.h>
+#include <asm/tlbflush.h>
 #include "internal.h"
 #include "swap.h"
 
@@ -932,6 +934,8 @@ static int __init thp_shrinker_init(void)
 	shrinker_register(deferred_split_shrinker);
 
 	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		unsigned long addr;
+
 		/*
 		 * Bump the reference of the huge_zero_folio and do not
 		 * initialize the shrinker.
@@ -940,8 +944,22 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		/* Highmem folios have no permanent direct-map mapping to protect. */
+		if (folio_test_highmem(huge_zero_folio))
+			return 0;
+
+		addr = (unsigned long)folio_address(huge_zero_folio);
+		/*
+		 * The folio was zeroed through the writable direct map. Flush
+		 * after the page-table update to invalidate stale translations.
+		 */
+		set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);
+		flush_tlb_kernel_range(addr, addr + HPAGE_PMD_SIZE);
 		return 0;
 	}
 
-- 
2.47.3


