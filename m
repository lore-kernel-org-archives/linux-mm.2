Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38290E92724
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962BF6B0088; Mon, 29 Dec 2025 09:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910826B0089; Mon, 29 Dec 2025 09:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2026B008A; Mon, 29 Dec 2025 09:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC196B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:38:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D468BF030
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:03 +0000 (UTC)
X-FDA: 84272763246.05.4BEDAA2
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 468841C0006
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767019081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
	b=pELYrLai6C3v8KqXHhiB0SQcm7RXjBsat+lroLUT5kq6vc2KPiMYVQArGVkTL9HrW8nfmn
	dDFNFrB++iGAK7y5haflDW1doGHepjX6/Snr57kdoedP/wPCIDGW8itv8l5YyphRwAtpOX
	es+4ZTqoQ1k/xl6LV5H6jyXIrGvTDZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767019081; a=rsa-sha256;
	cv=none;
	b=f3M//GqjRkFkKYqsgQgpnqAxyQULIanbPdbbcSduijItU86VtBwsx2WPu5GUwTilmJ3rAE
	ZJBTZkqGNAVnMZ8VYi05fzA5/XE1vMUgu8T/8p1EDwZ5AI7kTB+8LUnBODgzWqOySYmJuI
	aQbGSkhDtAhnZ0j4r/b8Fi0CLGqDxQQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a099233e8dso75178305ad.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:38:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767019080; x=1767623880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
        b=mgL1huJmdRR8K1adXnHih2sa4Pr3DFfyHveOeqCpB5nAXe8AqNoTRiZ8AMnwcW+Nm1
         PQ/x/3LZZdOdD3A3G8edJdicIqDrFIoXNgy/453ZLQkzD4ABQexkQDuwHoiNDeXhn0Mt
         Npg3HG/Nuq66ZIjQOwLGsDBbIPpkpWANfdk4attCZYgEsPf6QNgWwB6yJtc/UuoIf3D8
         ca+t8ttNuQVsN6sKXjmctxVVVJ+/l6vIBXh/reMabV65J/LdL4h2E1uzoAIhIFp/qavO
         TPcH47/cTp1G7hPniViuAM6uH3TXWK6k2XvH7RYsRzCIpEJEIgwnaANJ+2rW52hLrhX5
         YNHg==
X-Forwarded-Encrypted: i=1; AJvYcCWO3ZXmg3TvzSc8201VGltI7tgPGrVBLY3pNskXKSSdtLGDAe2V5KBKrtbXm0ujanFfcZ1nwu1UOw==@kvack.org
X-Gm-Message-State: AOJu0YxA/b7j8wKO6TkQLFJ4SsggIR8bwxi/imyjRBNyu03JuRxpk8JM
	5Vqo6zGff7jzct01NiXxCqgaY5/LFdKzV6s5E8db+1Y2AoXHRAlCPjiS
X-Gm-Gg: AY/fxX6N9ZYEvyP5vWluTxEDLqkvmH8zmPTHuLYazF1EkkANOYpHIQ+5/F+wFwmXHUB
	t34XvNk+MKhOqX5rKMv2rMWnJCAt+RXjj/uLuWJ1gj2KV9j3IjKXSBaScaRac9ZoqAYFjZs7BnF
	xSKIHTLVpHWV8IjVlnh5mLCkrnHAc7f45NCOy303rUI9N4o09JK2VHW1t/KIZpyoJicYcUNUW/h
	dAYADUEUQ0i2/7n4BQvHE2nUrldA5/qP7SwCDJsPRfvmYMW60mMIm381skPwL1NZdLD/zI8o62V
	6Y4FdBC1nUWfrbMqIVJgEwpuWlqzgkToqAremtzStHIaGO5oBdpQ0IQxfyYLv074vqSUY7GqxX8
	IEplt2Jx7CcaD8xJNFDxIoal95tktVd9xIkdQtiWHb4MjW6y3rvbforRfwlCmR42XC6hUoYHIQ+
	R9B2ogzSn3sL+cOiAlkgDGJD66l9fKKOU=
X-Google-Smtp-Source: AGHT+IEV772w153pVl2WpyWEJno3SC8dcLG3m0A8YzC4kscVWxvA6UP//UDe0ihAoD40pu8neBRzLg==
X-Received: by 2002:a17:902:f607:b0:295:9e4e:4090 with SMTP id d9443c01a7336-2a2f2a3cea1mr322095945ad.52.1767019079997;
        Mon, 29 Dec 2025 06:37:59 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([45.8.220.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d7736fsm279669625ad.92.2025.12.29.06.37.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:37:58 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RESEND v1 1/3] mm/tlb: allow architectures to skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:36:55 +0800
Message-ID: <20251229143657.76968-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143657.76968-1-lance.yang@linux.dev>
References: <20251229143657.76968-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 51diczge5nhaskua3b1tqgaoe6djek55
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 468841C0006
X-Rspam-User: 
X-HE-Tag: 1767019081-558736
X-HE-Meta: U2FsdGVkX18tY9mhQsB4Wk9mUmhagBZeiqiaW0xJl3zDNawvrQrq82YfKZ7Do3G67IifKi0ael4W6mQuBoPdL3YRGQhWZ9NvNUrSS83dkz7Zxf5SkV8zW1eoID0mLF20TrwjoVezlrtP9/X152opNmQoNv1IGKm0wkuw4n9DEFEljLJFpFV2fP4I9idpNbUXZjEexq7aD04uJg1X2lMY3c3ozrEjbvF9l0CWa4RPT7iDyNMSXGkkjIxwywySAfPQOY5uLeDaB56ujvYNMcJYwwpJxATsQXFfGNsJ6xiGDYD6mZnguCH6VH5eI++K5+q3ig4gp/prgIO3kupuobQyyVxFNfg9HZSR/vzSmZk8QHBCvgjPhMsfhTrErqrSnFOjdEc2URHJZfp+4AoIbwW+hjaWJ/Q5qPiSShYS4s0dGyFTAi06g+6LxOYFRLhtvq+afQNCTYWNiCMmcSgxb5Kepz4OWds9IvElbWpwWawuTHFiwKdYDVJjbvbrfdQOIUSB/bz7CFHbTDnAOGS0sqhiJttGpd9z8tqXBVbxRZe8jfGaaJtXZS0jpYmEHyvesaJ2JAo+sgyzCni9BstLJrhtBx3WDVhNVJdhe99ofI93Z5AWslCx5BmObwtfrIGvMy43TL+zOiQqDiH6ZnqyXJNoxs6K6hxPOWL6CMPSWZ40c15ajbZiLeXjPtTBOyi8GSPPE4hO3Q25yPpOfof0iYLY4I/1upHPK1Hw/dlzIUuFPZNfM3iKJq2tV23ainGqUhLh6qRsuTpaokHEk/lOjOiu+SkEdlT/l52ynuv8MK9zx1WI3w+FILQQ9kUIdWhcNrawSDsnFgX30szL3bfHqK+jMUNKAFW7Yn4qO20MrinVfav2MJVDDd6MG2U9J0WlM+FqaIdK822BQeZ67aufm0rNjVuVBiFwG6j51ARl4pwAHjF25suSRG9AQ5pj7g5JpShhwdDUMGgQBElqi7+iAyJ
 Wcb2G6Mi
 37Z0XQGCwDrO0XBDHlyR5I17Tie4R70ucyjgabGtiCUDUeAdp4VOrt0yIbViXdaXGe8CEFETjY/RMxIwbP77iK9ChibKq06+pS7EAhbuUZsIXYJZdt6pkLHrSOJ9y0oAaJLgfQ13lmJyt6iO0NaTNe31e0KI1xf8QN8CkGgX119MJ/buwt7aTRjuow059BF5AbRPayohpuLZYiyEafsFZDdLA/2FFgJ9Q0RLqJ7jBlC8UmnKwNTJIRNSYLzoAT0/9T6rJeFnx2rqhJ2YeLrWWkISJC25vFgukKQo25hs70w81C0DJI05JnGG+xAlsKgngcDcxv5SrPWFEdZhyY1QKXCXGwo+0gtUTbubDf1h8bG7X3PChnVoDFoD36jLODQ51l8QfkB2miD4Av2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When unsharing hugetlb PMD page tables, we currently send two IPIs: one
for TLB invalidation, and another to synchronize with concurrent GUP-fast
walkers.

However, if the TLB flush already reaches all CPUs, the second IPI is
redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
completes, any concurrent GUP-fast must have finished.

Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
their TLB flush provides full synchronization, enabling the redundant IPI
to be skipped.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4d679d2a206b..e8d99b5e831f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -261,6 +261,20 @@ static inline void tlb_remove_table_sync_one(void) { }
 
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
+/*
+ * Architectures can override if their TLB flush already broadcasts IPIs to all
+ * CPUs when freeing or unsharing page tables.
+ *
+ * Return true only when the flush guarantees:
+ * - IPIs reach all CPUs with potentially stale paging-structure cache entries
+ * - Synchronization with IRQ-disabled code like GUP-fast
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
 /*
-- 
2.49.0


