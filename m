Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E979BCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7BB18E0138; Wed, 27 Aug 2025 07:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6C68E0105; Wed, 27 Aug 2025 07:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB268E0138; Wed, 27 Aug 2025 07:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9426B8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4391A13903D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:50 +0000 (UTC)
X-FDA: 83822254740.09.EEBA387
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D855C0017
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wNIrF283;
	spf=pass (imf28.hostedemail.com: domain of 3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756292688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAE5CII86KHK3JlA1J37woP/VEU59D1d2hbqyEmTE24=;
	b=wXxxs5ij96Zzjw9R43lYpSdSYzOwEPqKKUBOsUiCF4FyVG76684Kwn3hW7ssosEiFU+q+N
	Bf667cCCPeHCKOiihwC2DMVpSI88LE0yN9H1g08+3REw2efNgI22ju9CMbfHblVxCfPN8d
	Ar2hSnPhzgKBnpCToFobT4aZxOIVwEc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wNIrF283;
	spf=pass (imf28.hostedemail.com: domain of 3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756292688; a=rsa-sha256;
	cv=none;
	b=Ds0pUl2wngmFgn2PO3DO7MrJ44XhtuR3qbltus88FNppA9y4kzrHFXv4XHUpzeOQDrD+dc
	scWVatEOIS/tsUEirrXqhtKI41aDiuSbW7lbyZxGJs8HMWdQSHAMRtfvZMFCoZxuy9nKt0
	zVETwErXtRSu4mDF0tQEG9KsdvZF5lU=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb7348249so583174066b.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756292687; x=1756897487; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAE5CII86KHK3JlA1J37woP/VEU59D1d2hbqyEmTE24=;
        b=wNIrF283NgJ4B011MPQi3kGopQ3xZUa8AmRYIOvEC/tQaV/8ZIaUHseQSA6EcSSidt
         L+zuxl4EszeivscYWqe9yaOPSTXpwsSByhb7W199qvS/+H6gDsrGKc0PMjC4SK0+4wuj
         DHl+IhnOGLuuI/6WTM5iHyMxYn4bK3zHpq9vcPqONDMXrymppDuYGpReqJUxIc5OSrLD
         EtENAd82tJPCi4rk1uhc/7enuZahKDx1PieMxt97vDkAtFDrfbCFFgcWJq2+PNfvLpIz
         p7yupji/oYYsenNqY0x5eE3LgPfi0s2r0my2oCdMTaFnZBk791QUuBiNsISPVLBoaT07
         zjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756292687; x=1756897487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAE5CII86KHK3JlA1J37woP/VEU59D1d2hbqyEmTE24=;
        b=YgIcpygd3jrcKviDTRH8ORV2krN2ue2S+VIWzGw9y7tt0ZnfzN2SF2oldHGj5Ijz34
         CsV8rZU8fVlPMnHhgPquCfbaG68w+FIgv/HDb+W3XLBwgbA/7Ac7frtYo/ohu9coA7ad
         I7MucaMZSqMj0tUUeEA2mIiK0KPyjEQQ8WCWAVtFtw/DEnd2ZwnSKOZ7QgFdThH2qX7V
         vXQly1dz4olEgAdyTEXw2ujj1+owcmO+Gsjt4fDcY8N7BWvJqhVBGnVOJv4qxGRsZkhH
         yhAzr3Bx/jhwn2IcKQppb2Z2gJEw0pGV6iSp2H5DE9nWUz6AKjRESuTIiogPA7ove6Hv
         obng==
X-Forwarded-Encrypted: i=1; AJvYcCX1AguiEhWDmQQ0L4n/2zL3sN0QJFQ3hHPPyalamozdV3/xiY4D6STJWAPsSW/cnhbyR2RjW0aR9A==@kvack.org
X-Gm-Message-State: AOJu0YzGTk/xLylLd39gl0jsYfCpBuiExvUeb8Exatw0fSE9GxRd2i/l
	8uolIYH0CKC+KjOV5JUwM2c/hvcd9MgemsVxDBoI2t1p/ElMMx0oXtfJikxemW8VIfh9l11MBJ9
	7alHBckJD3Dzl6w==
X-Google-Smtp-Source: AGHT+IFps824G1+9A1E1L6AAWpNXIwur9m1JpZYdYKH4pXCtjT5yIMTBrMWE7hKq5tOG/iUqapsb98A/ivv/rA==
X-Received: from ejctk13.prod.google.com ([2002:a17:907:c28d:b0:afe:94a7:8b97])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c93:b0:af9:d80f:645d with SMTP id a640c23a62f3a-afe29793340mr1744344266b.57.1756292686965;
 Wed, 27 Aug 2025 04:04:46 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:04:42 +0000
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
Subject: [PATCH 2/3] tools: testing: Use existing atomic.h for vma/radix-tree tests
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: ft49i8g1rx879jowxrfypss9gkxbznmy
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D855C0017
X-Rspamd-Server: rspam01
X-HE-Tag: 1756292688-625846
X-HE-Meta: U2FsdGVkX1/6flXWs/u800NgbyVzConT7a4OCeqRQBZ7ih+JPjglLwijXCDcHeLZZutauTIjL30fjgh0/azQgaplh3UdIuV55nL+q6T6eIWoTOSNU51j6F8ukZ1/F48ElPdwjr0jlnypLqrKm7ZtfAcCmmWzigBucGaXDBC9ia0Ux/P0s+WuVVB4/mqYhclSu9GvTtoYR5Cdmrw0xdE5/6+zpgS/OLTN6UO/e8K3hvkTWtPL+5VYLsVrkmxeEPEmHznwkQXZlCkXlkNk999DwOg6bglUDHXW+k7w17FklgyI62pLqkKV6wUetvh8oq8p6Zonhm6w8YhmqpjITSOEuHsjplhqqavXKvSgYxappn3VyLEcosmgW4t1Si/s76HpyDEnoIbqLMDDWgXTGT9DjebiPKc6GUSavN/pTSrkUPJROz4Ag4eLDu5DlU6JhFJWJ6hYBXRvTl57cktHZbwpdhsAzRIkIy+Cnf/84lDHQjvvKn+UaxwZ/kMOfVaivuVr1xldx9L9+5YFVUndI/fKUxGANvZEWo10IluQS06o0goN9YCaiZRusyKvBiD3XadmxBlgvPpV5Svpp0Bu1sJhzcy9prUspPQa0ofJ5tFgswvyQyNmLUN+PVs41tiI1ULulll9p/T5/Q+B8UUIeTy7KdleaHK5yD+/hAf693W3VnV1MAbaRLp+2Yt8FopT36E3JdHAXwplHbJ0zoFmjrzgafSEEBwwAcoOMxxtLGPvt9VqtNOy8zibyEnHU24lu64S2QmnL8Hl+lKKHLHjZYeQTnoG+BxXPKLH/qadM43uiHKumahfRblW+2CQASYI903pGTRwBSIn0ypj49LFucmxOnlrU/EBfLhLkT/T9gn/t6MxHFL9z8d4Qxz1ayWUCZtNpGQb+UR7iVNIFpN8CXCEwFvmXmZdTyjjc0iScLJU3FotaabJg+0hrs6IhUC92bNCUh4O5BNgnac/BU+VTMm
 7qtLXK2K
 UvNmFEQ2702D/FIUTN80dQILbHD5NpIMXXtU/xHsjilO1DyuSnnjFOHP7lZwi1fcSQtHGWOA7w44CM6l8BSwV70bsGvmjaye8xi+T78iSBbuwjzUeWckawZzbcRiEaRyRHicr+W430cR3V63yrl4IHt5msOBnZUiyTgQM6UNWX1e0pq3+ODS/5WNVTxzLmv5tzeVrH8slDqscxR+jK4HGxPrcAv88maiCsTXtgVW++D+qixr7IXcb+2sQ2yEphZ8akoMIBjg7SRHI5vLEdG6LmBfUcPgVs/KWby34+nuQiEpmwzDf3Y9tfGAgLNBCibIhJ3tZmy9c2RKwHNKl/v0vKUt7wKzcW9YqJCjyPsOFES33e+7ET2XliAUmn6Trkfqzvcuvdv8RaTt/NkJhfG+lqoNc1S96vHZY5cGcoNFodPSXKJm8UyBCSmchHIbC+3UGQxaGy0ElS1iMiYw/ByqoQYmm8coSUMtG4sEBih8eGXjjZvqCP1MdDCXsnMt0H1rvo5f8AZyAUGki653+uQt3jt/7QbiT++Aqyr+umiFGiZkaVx70GvFhyOAe/W1sgTbfK4wQLkBAJ1QNpQkNXiN0finXvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared userspace logic used for unit-testing radix-tree and VMA code
currently has its own replacements for atomics helpers. This is not
needed as the necessary APIs already have userspace implementations in
the tools tree. Switching over to that allows deleting a bit of code.

Note that the implementation is different; while the version being
deleted here is implemented using liburcu, the existing version in tools
uses either x86 asm or compiler builtins. It's assumed that both are
equally likely to be correct.

The tools tree's version of atomic_t is a struct type while the version
being deleted was just a typedef of an integer. This means it's no
longer valid to call __sync_bool_compare_and_swap() directly on it. One
option would be to just peek into the struct and call it on the field,
but it seems a little cleaner to just use the corresponding atomic.h
API. On non-x86 archs this is implemented using
__sync_val_compare_and_swap(). It's not clear why the old version uses
the bool variant instead of the generic "val" one, for now it's assumed
that this was a mistake.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/linux/maple_tree.h |  6 ++----
 tools/testing/vma/linux/atomic.h        | 17 -----------------
 tools/testing/vma/vma_internal.h        |  3 ++-
 3 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/tools/testing/shared/linux/maple_tree.h b/tools/testing/shared/linux/maple_tree.h
index f67d47d32857cee296c2784da57825c9a31cd340..7d0fadef0f11624dbb110ad351aabdc79a19dcd2 100644
--- a/tools/testing/shared/linux/maple_tree.h
+++ b/tools/testing/shared/linux/maple_tree.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
+#include <linux/atomic.h>
+
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
diff --git a/tools/testing/vma/linux/atomic.h b/tools/testing/vma/linux/atomic.h
deleted file mode 100644
index 788c597c4fdea7392307de93ff4459453b96179b..0000000000000000000000000000000000000000
--- a/tools/testing/vma/linux/atomic.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-
-#ifndef _LINUX_ATOMIC_H
-#define _LINUX_ATOMIC_H
-
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
-#define U8_MAX UCHAR_MAX
-
-#ifndef atomic_cmpxchg_relaxed
-#define  atomic_cmpxchg_relaxed		uatomic_cmpxchg
-#define  atomic_cmpxchg_release         uatomic_cmpxchg
-#endif /* atomic_cmpxchg_relaxed */
-
-#endif	/* _LINUX_ATOMIC_H */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3639aa8dd2b06ebe5b9cfcfe6669994fd38c482d..a720a4e6bada83e6b32e76762089eeec35ba8fac 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -21,6 +21,7 @@
 
 #include <stdlib.h>
 
+#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/maple_tree.h>
 #include <linux/mm.h>
@@ -1381,7 +1382,7 @@ static inline int mapping_map_writable(struct address_space *mapping)
 	do {
 		if (c < 0)
 			return -EPERM;
-	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
+	} while (!atomic_cmpxchg(&mapping->i_mmap_writable, c, c+1));
 
 	return 0;
 }

-- 
2.50.1


