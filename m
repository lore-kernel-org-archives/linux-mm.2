Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469A2CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC126B0093; Tue, 26 May 2026 23:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3716B0095; Tue, 26 May 2026 23:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3806B0096; Tue, 26 May 2026 23:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 898D36B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A7B44033B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:43 +0000 (UTC)
X-FDA: 84811838286.30.51F1E0A
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76CAA100005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ef+HSC5J;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779854201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76e5d+OwDFACeBsZxMFHmjJHOEXouBWtuBdAHT+B+xY=;
	b=OwwyrhuqannXB0PsNgWd6Y5VbdwJkPTOhP+Ez28/KIK9Z/tjk60SyI9YtYB6SDyVyeOfhU
	IKMx6RsFtWJxIuvTZ/xmbHpLJrgJaFfNAWXc4dQPcA0Mk4Yqezeft6wh0Z6fHcePmpd1Z7
	WHC66pgi9PlIp5LyVvERN1RQpD+NZNQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ef+HSC5J;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779854201; a=rsa-sha256;
	cv=none;
	b=4ia6PYbQPCxIIvX8BgBLTI7mwuwIBwwdh4Xx/hwpUnCKCtihuIj6M4h33622oPHE81ejEV
	M6s6iJYyuKSAoBwY2sF+JrbIi+/TP0mrkeNnSkFgzwbsI7YlAP2bj/JaIB8p5m3XW1thfb
	LuQGlD81sXhA0DOQfm2HsB20R/RS/sM=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c8239019aa5so499313a12.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 20:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779854200; x=1780459000; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76e5d+OwDFACeBsZxMFHmjJHOEXouBWtuBdAHT+B+xY=;
        b=Ef+HSC5Jn9BQ11xvZUXiXSwzl2jhGPQ0xXJaE9hL8WqBBNhovvwy+O/qeTyQr3wy07
         KPrUn0OBrmEjUN6iKGjNO8vuEPuEmqQjGM3udZHpeXbEnW5dhX8jIjGTk6M1PBuLDMXX
         dvOJYOrq0yrjynuEH7cCrmTbj8/vWXbTd/6Jlnhe/aa4oAsGhxT1m9t7R5K84nABmgCW
         PV8iqk3+wSSAxodOtRRVfbEMYPRE8o0uEHYXI5nrBErq8EGw/rSSPWMJuaQwoq3JpPvf
         1kVu3oQQyZg4mZyfv+KI95V08l/DSbI8Pw5uncQzHUFK2PlZmZAV15NGqaTSnb2ZVZr4
         PGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779854200; x=1780459000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=76e5d+OwDFACeBsZxMFHmjJHOEXouBWtuBdAHT+B+xY=;
        b=hqXjbj5aeniacM7h61/4vtdSZOrZvd1oQ24gxmFgvIhr0bWQXGabTxsu4CbnZVROel
         mijHhib1d+yYEIrDt4QMDe5WNWSQkth5k4Sc2BCWtXFlGuTcbWTHHYjPUL7q/WuhKTVn
         4iWYNWMJBTuH+k3uPrxVsivi2RSA4bwH2EdbQvxIm4gpkrkzmBU6B7Gmkn+nU0HQ2dAx
         C3Z1JCV2Pko8U1kS3IphwzPSJGE9hMP8mQIA3r73V8+XE/GCS29nj68VmUB2+0+/h3X8
         J1KKsxTT2eq+mw2jGVyUYqjIzF8nqxfDBWaUve/Gj7eiMwRQdgSZK3Uk4WH07DFhVz2y
         rF9Q==
X-Forwarded-Encrypted: i=1; AFNElJ9FCo06lOB2AfKU7FGrw36I2F4cywolP+jonOTmSW3QOYuTwmPIfO0Kyo3lCVu+nUVlwoIvOz+EKg==@kvack.org
X-Gm-Message-State: AOJu0YzFjxQ/ZPGHWqUouKnIdRZoqR4eMIB9/YYSa7KUOqrGzs5Ddqez
	eEswn4Emwb1WsNlbdksMMZPITfNnzXr9PjVGZgUpLq/x2RI6ARLM/ODD
X-Gm-Gg: Acq92OFBYjlgq//Oyu5Lg3Som+ngPlIip0joN+hhxS/imaUuFYHWpbwYBkyqJf7PzYA
	5ey/9BcN/ibUf7/roTgvXaWm6veh1cq/dnKcu4UXRc5EhYZ3L6ch8LW0vsIVHb27kT6oHayDcBx
	yO01N+XBfP7y0uwal+eji3yJd1hg/lhQEYsnDK90HAtrE5p9In/3ZbEDGWYWKpKsm4GNcRRRP1W
	XKrXlwJhHfzAmjMcoKe1A/rjTnIz+40jaM2aAHB2xYnl3h7QKdLVEdkTNcbXVAg+J9BX4w/CTMx
	fPkuK5N2I7m+6J1zFdkgCA71ezeloEYgkgjOhRWJY6pjx3anlWKtgD60RTNklQBJIN7XM7bQ7ff
	2NHntWOMDOZmvt7+de6LqIfVbAnGYMCCiKegsgPJjJq4SIZ6SaxN7qJJGYOJJLEn72IL/OUslJz
	kJlKVxlx2Eq2k9OY4hMt3Ap3vVXSkPRfz3DF81FojGQXTreNajq9s8G3WkiprQ+CVEICfRMlISc
	RbH8sRrkq987phPb1XwErJin1g=
X-Received: by 2002:a05:6a00:3a14:b0:82c:ae58:46a5 with SMTP id d2e1a72fcca58-8415f3495d1mr10604971b3a.5.1779854199491;
        Tue, 26 May 2026 20:56:39 -0700 (PDT)
Received: from firefly-aio-3588q.. ([36.28.158.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70f1ed8sm828385b3a.43.2026.05.26.20.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 20:56:39 -0700 (PDT)
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
Subject: [RFC PATCH 3/3] x86/mm: make huge zero folio read-only in direct map
Date: Wed, 27 May 2026 11:56:07 +0800
Message-ID: <20260527035607.14919-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u44r9dj1xdksqbbkqa8g6nzjtwtbrddp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76CAA100005
X-HE-Tag: 1779854201-617374
X-HE-Meta: U2FsdGVkX1/D8ZDCWh4OyDaRp4eWKRI54TeJ06kKPq53I05nhDJb6NaBrDLjSlXJtqifnrZ0wUAUP/sWVqEZ49iN+STkmrOkbEaQrnKW0GD0EmhUB4JBchEQV+fn3D9a5P0USjNO4xQY+u7eRRbBhozyUcFO4bUKr/fFmrpcp7IvDsulKkjOKs8DtCNg81YQ7huMRzvrSflApZsWdOJ0BNKE9ApgKHhBkv4g6P3PCI3bN1Zov04fvrn6gr5zgNVARJgffUmEQ/5rY/KBK1FT1RMEZBN4XOS/Krxf8PzK+IzhiCflYoucSqqmvOYXi8Y+Mvb+PIIGN2SB0cvR2J7sYrmGSI2yN5JNUFB7i7PwsFJIKQJ8nsewd5fBW6NoGnaSBcyBNvv/7awG/AbgwIiMpPcJm/4f6vtq4kbM8wohERip9UfV32ZgLEzREjA7rGPEhdjxRvJyFr1pYVr2P2q1KSAXVQ35m0b49qQqxrTnIjCsfxANsPp3gLTuGWm6zNeWMsdDQRYp++qN46y3H0A2zd3uQBWGn0uWgU5Qlq7FczyE+kYcFFB3v8qY3e0MhuO8BhBzeo/83Y3WsfVF9KmqRJWkl1wNtolNTE0KMwADMJxG4nXHCcdQ/CHRVZSVgx7/uAqr83/hnbh3F1MIgcml/PbiZ6QCie5gYI3/5wOO/L8Cwkdp0RQa1SmiAKmHTUpDPCTVmuB3ZMkJUBDMQZnDcl32Qbv0LgJMO5REuX0Nc51JSobEpzfmFLEXWceRjMnQemh4zldY1qSb7UI/3nGKgenynK6MDS7JfEjsxGexdecy5ZVtBixqsnhP6WbrDYgROPHxEL9eEYZffwf+P3qkSexZONZjOymvuotXVhlEI2WFSUx6WG42KMBwHGwXGLWhNsWmNxJ55u4mETOe5+ZRt+cvuRGcP3CjDNRwXcU/8YZTr+fmPgaMfbwoINVrYJGHngQVFm0tpNzdyCYj3pG
 TH+yRgVq
 aajgab8deYIYTQlkICsy55tILuR45lTvPEPsAWeMunVkg87fCZc4dDR4A2Jlih6jHWg071ntfVbkhVpy6UObpwgnlqTbBy2rWhXcOkfCYHgeX+j/gVLP8HqTNUnFyjwBFDVJJWpdg+qBrlRxQ3hgv0tUJYhKkunIQ8e+pDGysK/PmGS8jdkd9L+ofM6cGjWAbDGgH5+C4NM8nHwERWyeydvp6ecXFW2X4Qnty9wWbn8qDSN8eEMS08WIq77MYON+5Qiw3cu5rEoi38scbeIoacvAuhTgwd0aLiQWt+RAOVW4QJ6JCCaappgvHh43ofDYmfMK1JfE2Eq0S6QKiRmFzBfXQW1NQ72nvDAUx8YYKUFJ9dTIG+aPPeA3wEotX8DMK8rrHWiCjCBOD2tJRmabLTTmfjy5TXcNK8O9gzrVzDRx4XWaXpudnoENZ5/oQ1inq80yh5f/xsGzlAvszuF/m4nzXRo158N2MB8vBTO0qm+fyfy2cpmzkGIwac6NnSCvS4JCsmCl13RHjK+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Implement arch_make_huge_zero_folio_readonly() for x86-64. Once allocated,
try to make the folio read-only in the direct map so unexpected writes
fault instead of corrupting shared zero contents.

The set_memory_ro() update is best effort: if it fails, generic THP keeps
using the writable persistent huge zero folio.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/Kconfig   |  1 +
 arch/x86/mm/init.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..81f9478d2803 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86_64
 	def_bool y
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
+	select ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fb67217fddcd..ef721aa2ff0c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -3,6 +3,8 @@
 #include <linux/ioport.h>
 #include <linux/swap.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/huge_mm.h>
 #include <linux/swapfile.h>
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
@@ -38,6 +40,15 @@
 
 #include "mm_internal.h"
 
+#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
+bool __init arch_make_huge_zero_folio_readonly(struct folio *folio)
+{
+	unsigned long addr = (unsigned long)folio_address(folio);
+
+	return !set_memory_ro(addr, HPAGE_PMD_NR);
+}
+#endif
+
 /*
  * Tables translating between page_cache_type_t and pte encoding.
  *
-- 
2.47.3


