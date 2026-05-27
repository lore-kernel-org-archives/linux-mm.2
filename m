Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3181CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110C26B008C; Tue, 26 May 2026 23:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E84F6B0093; Tue, 26 May 2026 23:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F526B008C; Tue, 26 May 2026 23:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15846B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7576D4049A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:35 +0000 (UTC)
X-FDA: 84811837950.04.D0C279B
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90BAF14000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B59GV/+V";
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779854193; a=rsa-sha256;
	cv=none;
	b=FvI3S16zyPePcq0pvZsoKbo62IyVfxTgv5d6ycSs0qdKHlJPEUtItFTxLqg4t2p8yVgBlg
	JYO32vnNjMgeR7fIRbmBZhGA/MvfO1sAfMjjxbp10BjoCD5J2E8pOYqRG9N6E3cLLxNK09
	/0bm68Jltm1AfhG1gV5EmHM2u7F0NpE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B59GV/+V";
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779854193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxyO1vdQIioBST6/se+LFHwKyw/fhXDOexNC3wOgNGg=;
	b=LKeP1mXkrzyjhVpw9sL5+2AXBrfFP4KVbvmjJoETyTutxLSNANaMrHwVWlzEg0XOO7WGgc
	wnGms6DNlTclczcT8XQ0424H4o4+Q2ETSmPnThZVJOtwKFYoJkq7cRooZdzQWp5IZAy5hm
	AldwserxH8D+0u4YQE4rGG5dMk29PWU=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36add801e24so528380a91.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 20:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779854192; x=1780458992; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AxyO1vdQIioBST6/se+LFHwKyw/fhXDOexNC3wOgNGg=;
        b=B59GV/+VVa8NGGCXIMU+JWF7TK12S5dq599OTHRBq0wRNc4DymGvOpeoX0SVylCBRU
         WOBVgfM0oc1DbdskJKhi5G0o7Qh11iYkllozqLAXG7iThZovfCTC9wDU1gcIBnugwW/q
         RNt5FwDV8/VFyfPfgd05WkXZaWHXw6J4CAVLpoBjmGmWadfX1s4g7TRj468t2Aa7EmRH
         bcFyBGYLI7MB5M9ElgFDlC2c/Vol5PhinCMMAizHMwgM6eJjNXnmqQH58jgYSV2UESDu
         qHt16NNqm+WHewjRZ1qMeCFV//fMFZXWb7GhFptiiPHivD5BaKnZTWRfJsYuCSuVdvuX
         lZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779854192; x=1780458992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AxyO1vdQIioBST6/se+LFHwKyw/fhXDOexNC3wOgNGg=;
        b=STlDmVUJFwhp7H8DuLfsHt+if09VbzN8dtdyQazKd4FeLCVRttH9okVYShI5XOTh7+
         oXpln1q76C4C9ITD2Cf+4RENiQMc5XKScQtRXNfKK05EI5C9e7mxxrUZPu/ArjtKKa89
         crxGr26K33fXW4U34I5ynCWjz0r+8ipRao7lklZwoT3AjLAyAZym7R3x1rbR4lASAGRM
         zsk2LdhabUoioKygbKCCqW/ihstHVsPkdboFMgZ0BFjIE5upEDiplh2zTsSh3N+MEkx4
         hFjWF97xiT0FXZACOvra++BKk3iEJf+N5gpHHQ6ptpDARFKPGb3XWR0FaZcTlZDeieUi
         Iw5A==
X-Forwarded-Encrypted: i=1; AFNElJ8WEDiAZ842AQst7vvucJWk7HSUW6r7t2PCh8v+qzbp8Bs6hc5q61QuMdUWf9Mq5i6pNQL5lEmAEA==@kvack.org
X-Gm-Message-State: AOJu0YwUT4cwjGJloSn6ESyTkaejMTNo+qBf0S2DGyP5DUd0UnZ6FOS5
	5LJsNbeUKylBP/tuyY8toa8+YIB0jQQWe8Cn7DV629mkyDI6DK2CNami
X-Gm-Gg: Acq92OFonoNr37DdG9j1u/3Ft4I/OTacP8fxJxGlDXZn0uTuRO17ssJjqy4HSLi2jiU
	/aIStKaouCPi/bqJsdzdBYazB9E7AbLbnH9+iRz5qQI3aI1heC6RjQYccAlBjARuEKlIUnPzkuJ
	ARt7lMRVesPfKuMRqvcVHIEe0FrzYJwLPWBGkbQr+vpihLDsmwxIlAIJd3KDZoyz2NhYaPyGv+I
	atmqLq0Sx3SfRtrvO72iB2KLjZgDxfdxLC05cJ4IaVMRaBX7cWhNqi0G3YJWjSr86B8eM/pZpuA
	7uXOPqM+xFDT9LaPXe1uEs03FhYeDBBuS4HmBgHPrI2aOCrKXi06nlinLnBGiKIpohM8zmwDqb+
	uKDdMAy/Sj9RIvfoV1eSQUlKYudnHqMwhJA5p2rBx7TbVMgYkEaXiHBvV2G5lvld5LDGkgTAwWd
	voBpQX+OV5JkLIKnsMr2UEeKxkl+uQXbTa7W0jeCdf1RTi2Hp0hpB1/yIR5GPpF37mGuwEYhhHT
	C6SijOMMTU0UWtBe0IpMX+5Pw7ie/+SUlbP4g==
X-Received: by 2002:a05:6a20:2a26:b0:3b3:ccbe:dbe0 with SMTP id adf61e73a8af0-3b3ccbee28cmr796935637.3.1779854191930;
        Tue, 26 May 2026 20:56:31 -0700 (PDT)
Received: from firefly-aio-3588q.. ([36.28.158.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70f1ed8sm828385b3a.43.2026.05.26.20.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 20:56:31 -0700 (PDT)
From: Xueyuan chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH 2/3] arm64/mm: make huge zero folio read-only in linear map
Date: Wed, 27 May 2026 11:56:06 +0800
Message-ID: <20260527035607.14919-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 90BAF14000C
X-Rspamd-Server: rspam03
X-Stat-Signature: hikqwcpq7xso3pktfucjeosdu5zneidg
X-HE-Tag: 1779854193-697334
X-HE-Meta: U2FsdGVkX19Pg8LMqeae+dKP8xqXVJ9G/bN8qu4zdSHjtWvEUQ4ExFTrIISibu5eeVXH51UQ3xn4e3a9jOHzmAKmCsgcuVlaf0YqHPGyWmLKPkXUAugVx8bsF25+TXXgPiawjHd2cIii8efAGT7ZvrCeMo147BVnl3rYHN4pBsc6gbrDID2EjwTFyVmAtZQVzA398Xc+o65+NeHeHdi9Alni4Lmvkboox0Gsy/VSR8A4RtdjGtwkXUhrAEAj5pf6jelCxha1dSV5NGToLo339/aqWtK/VNLk988Q5SlAuHU2VWBGGkQfwO1kN4PtPNCjgE4pIl8cp8GEtgyaldMJ+BrOz8tzRavgiTm4EflxzQGs3BLyZCWhszbjG+HAdF72H9vH4KpI+6YYsjwGc5gvVG3SV1Yi9686YU6PeEtrCBbU0elNvwFyGFmbNk5kXkSDHZYIWYJM8NdUIoTrYr9iGQy1bfEZg2dklcANDSYcK8dG5fx7VNQib7rrDuzjMmfH7/iM4+qiW3XjAJrjp9+4gJe7KNgW6RZA0fVIALjOkwhB9MPAuNtPDPwVpduAfvWMQ7tewjBdOwhPe3kD7dfklQn+cplZbewsbz4oMV0FYuhXO4kB+nZuWsWGbYvhGb904CLmiC+P8U8qWerg3OhJpfl4czwZeZswou30oqN9rsm13/x42p45KRIhnI9rwYNCo4LRIlrpAFRrKT8CvOpGQGnqJZomDU3HGD3E2G4GxWdk5dRxS1rQI6Xw3upcQUNFfYmsc+CGRBe6l+TrkojAMbHsSvYCA+fSgk0uPVLYqvmGGGzZyaiEtQgHYoMVpLDleUNrM+kUxZGwHBH7zFYfIUJ86WKicnxUI/Axj24i0kzq3T4dsVQRW0S+SYW7OcYTKbvdYbqE+h8r32jwOSDCdPgooNxcoHeZP7wtVIlNrUrye0wt2Jpw+35sBlmtT4+TlURwfP8wbkZla3y3sbc
 v11ymG/B
 5igfDbO9lnUw6ETkuXN+Ps8cFp93HOJtQaBHMD18xbisVltyBzhoqjEk7yt5onrYkVZu5h1aJ/qM+LBiIqqHNaW2+OJ02MzYuURS9X/Kcm8rIHzyejG4eO0IwbwJcG3Q12TUmX0XkgFB1QZH7HM6iOycgrkJ5XDT59Kp68oVZCrD1e8Chr8YhPWu9FhRTkyYP47NkiDKSq1fIA9KovL4d3QTpQH89rgfJGb21N10d8NQ+7kZeC0n3pv0l6oQ78UNSgY1k7PUop3wLFxgy8Nx9fu0Kz/XGfrbyT/V17qO44KlTua7sEhpnIwEs1hauyiyBbqLEjSoJE2dF6ERfqfSgkI4ntN9DV69kFq+8MQghfWQZlqsN8+WbMfHI9wOp6UH349ONIWrZAQyqUM+kjHQnYbH6aQUbdG2O/iKaI5F5Bp16XGcv8li02Gga399s8mLUsjI1fx0vOD39StdDEFTbs5jgOjK/dr4dHO/jzDJg8KP+bto+sE8w3QNNFAwokOUFK71TSsLbfQ6ro1KkhZu0fbFN18cJM+yoCvNaTZgs5RWeEni8ow/UenJZZ7Iratr2QN3VTQgtBRXG+8Lkr+E2qzTEb0mQec27tW3748++rQsturmf8RNchv0hpamvMGSg6ZRkAd/dlC+3W3lLx5AyNb3SzZUMSsCpA5eT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Implement arch_make_huge_zero_folio_readonly() for arm64. Once allocated,
try to make the folio read-only in the linear map so unexpected writes
fault instead of corrupting shared zero contents.

Respect can_set_direct_map() before touching the linear map, and treat the
pageattr update as best effort: it can still fail while splitting a leaf
mapping or applying new permissions. If that happens, generic THP keeps
using the writable persistent huge zero folio.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/Kconfig       |  1 +
 arch/arm64/mm/pageattr.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..3cd705dd5251 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -44,6 +44,7 @@ config ARM64
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
 	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_DIRECT_MAP
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..51ce31e74a18 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -3,7 +3,9 @@
  * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  */
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/huge_mm.h>
 #include <linux/module.h>
 #include <linux/mem_encrypt.h>
 #include <linux/sched.h>
@@ -147,6 +149,20 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 	return ret;
 }
 
+#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
+bool __init arch_make_huge_zero_folio_readonly(struct folio *folio)
+{
+	unsigned long addr = (unsigned long)folio_address(folio);
+
+	if (!can_set_direct_map())
+		return false;
+
+	return !__change_memory_common(addr, PMD_SIZE,
+				       __pgprot(PTE_RDONLY),
+				       __pgprot(PTE_WRITE));
+}
+#endif
+
 static int change_memory_common(unsigned long addr, int numpages,
 				pgprot_t set_mask, pgprot_t clear_mask)
 {
-- 
2.47.3


