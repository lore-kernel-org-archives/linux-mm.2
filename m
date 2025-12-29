Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A8EE8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E4B6B0088; Mon, 29 Dec 2025 09:31:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325E76B0089; Mon, 29 Dec 2025 09:31:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C426B008A; Mon, 29 Dec 2025 09:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17A4E6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:31:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB427CA785
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:04 +0000 (UTC)
X-FDA: 84272745648.27.5E70BD2
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id D5A03180019
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767018662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
	b=719J3lLkscTzn6lNckVtBugrPP9c3MyocbTLhnEO1Y6/8Q3p7qgKRRxrYe5kl1G207AS9s
	dtNgiXQrO9COdU7KTF3LxCyT0A2znOaYoCoJAwE3kdmfb1f5gYcytvuxE6cEFEG5kNBZOQ
	nN1fSb3HE56l4a9ot11p5qeUYulgC5o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767018662; a=rsa-sha256;
	cv=none;
	b=S4Irrn+3ssJ/MAcHA8iVk+FvZRuWEmLnGD9fYKRE42dMBvbnvZMEr4nKnBB9uUaoF+etgH
	2po5RUaNtJPOM0oL2Y1ilDjx46rsIPfsrFALeQ6czXtL5j9wjV1csSm4sJzZgsGRrZRCK+
	22sBdJObWOsxCuhgszdoBaDhoQNqq7E=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7f121c00dedso12340606b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767018662; x=1767623462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
        b=uKa4cdWuDCUE6neyPe020bMLCGS3xuC7xqoOTCSnKtLDwEXALJhFZE8ai6nfEWMkyV
         tfNvpF/UB6No9em+qcEgfLCOJhSYTLftQI+03GC0S55eNUB0kdnfj0NTaWt7pVhCN+xd
         k8DJY42OYzkajfur84eRrcjMvkPTpa6o2RVrdi6o7iGuISznSPzxgKxpfV4/pTNCqCK/
         UFPWmm/S/AMh8a+4gbtRPr46tdmVSfzkGuO8AQUrNuM7JHVxj7BDJRF0gTOuMppRZXvl
         ++zLyEvjBLVc8Y72vujbj+lr1b44RmxZWxozfInaKyMRbUp/gAv4FmXb0y1xNH8Uevbo
         ofrg==
X-Forwarded-Encrypted: i=1; AJvYcCWnOn6Y9HH7a6+NxxJQ1R3w2ljJTvd87EcvEN2GCEEV7ZPq5N/roiSg2F6E+EaNxYMnIPWwN6XBXQ==@kvack.org
X-Gm-Message-State: AOJu0YwNSffCRL/z6ylg7fZk0YDSapIwCl7C8DWN9StX6nFBeOzk2o7U
	fdYVHCv+5M2iClmezo5/JpXmD8ioWTwSXsiHUMe41rKSe1h/sYQu9DlUvxS4fg==
X-Gm-Gg: AY/fxX5/xjVODMPpV5/SVJiOePvv0lt6hNMwWzAaB6kOHjALu6zT9/VItgWY1VrJutv
	B4oqKhBMN/R78Ni5SNpooxim85E5JV2oSsnaPEzD1IOiFy8itw2pW77Z8R6UQ+KXg10meTNiszR
	oZ/V27M+l0qL0rirBTSJLS40JORBOSCLrZRZwDnrF5EEg5/9QRsUHVrIMpDNKpsXWI6fXUfaMny
	sF33L3RkFrdxiIxzamuNmnaBkMXwVbf+u2bLD4/jgLmNvdfjpvQgv7/EJd4oM8jxVXsMPKa32sb
	R+mMlZjpgdBeYBbLVRhbuvi0TpGbwQR9O7J4vHxrCRsuzKPYm9NcHD5ggFjKjW8Z3XuwAm5KQ2z
	53bjkduj8gjxr9t6Jd4pHnE/WNgfOR+9XhotJ90NZm3rhUYvOJiQMdVJ2VGpPIUEn/6JcFB7Bf0
	sGWjX4MbdyCls2bnfHC3j9
X-Google-Smtp-Source: AGHT+IEcRpszq5Kq79VNLMGams7x9wFNNmMmBbYeukt6SbJFbwCYZtO3VxeJZmswaHVyyAPRvGA8Bg==
X-Received: by 2002:a05:6a00:4514:b0:7f7:4a39:55cd with SMTP id d2e1a72fcca58-7ff6178be74mr27982951b3a.0.1767018661690;
        Mon, 29 Dec 2025 06:31:01 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfac28fsm29705159b3a.32.2025.12.29.06.30.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:31:01 -0800 (PST)
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
Date: Mon, 29 Dec 2025 22:30:31 +0800
Message-ID: <20251229143038.73315-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143038.73315-1-lance.yang@linux.dev>
References: <20251229143038.73315-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5A03180019
X-Stat-Signature: 51diczge5nhaskua3b1tqgaoe6djek55
X-Rspam-User: 
X-HE-Tag: 1767018662-238499
X-HE-Meta: U2FsdGVkX1/SnCvUyeCgyH2Ntw6uk2H7bep1P+xxIBlOeWSkfUy9HYUhCVhpEyXaRDlPlJE2T3zsq/kD2MnOoGaNaD0Ydxe1GnLD6oU4d9PmJ9sR98DeUPq0acsHZnhdFJN28YyY5lLsqn4ATKxZp2st4fchTCPoZPYP9dDL69BveuZKslj3XxTLOMwM+ajEI2BO/XV/jLr7iX9ZTOnNYZFoUbozDVDEw/6tVlCk1lE8+OmxFxqSUDMez8JuNZ8lxTz4xn8hFyQDW6yPtlkIKG0TavtE7ZTGdUyFNrRr3KuxPQ5Zeutrx3CB19LiZB/wQKt1sp6l/9+ygsqmcXWWPXgQ71vvwBPhQSJC6pfraUDKyE8e2/6518KcOZQzgFRAlCMxXjyPdYRlXM0kL1/njshKOrbJTTQ7gAqTNHLT5obokVXkjPiqP4paYGTJKCHA4Jc8Vi/Q443w3ZUkyNzT8+V5B0/rZSg5DjRhaXrJMV53f1MHaWYEBXOCGU/BPml0ozjmQ2PElOmot2PIiK+pdyr1RaA025bPcULSEM5E9X5p0+PPgsr0Nngqx15OyPCc9bver6MziurLwM60nE/hoaA3yWG6O68EqLKgH3dnQVX6IMa1tGzOrYgEHhAn2BLdQtxmjSaZxg3yQs4bS+iLklqXcXGv03Svka4EIk+XMaEi7r4Rv2jkHsKFNDNy/3xlTwKr7F0ifYxnMZ8GL+QDZatnKuO7Jpkezn77ZJpODxExxs/wFX6VqKGd+24sBV9OJPLQJykIHCCH70n6P6/lDglyZe537zo7rh7wwQGLF3gtzkjjopaEnAtZ0FCXxRCA6017RFFilWqJ8iUxHeJPL/5tvffH1SxPMEIp3qjp1zlkNWAbE23wLuZOHTXA1vHAEVXzIYwUmEnIOWzHs9htWj2YRBAC44udVo64FYf7B7iOjN3mWUBuZn9U91uLtlnWKti7CNsetuZhuqrCCZC
 +D8bv69B
 3rxO6a12UPejZHxD4QwjlzbykNewBfvKlU824DV++mevzJDpp6TaMQvjccBEvo1KjLa4pld+XgideI6pKDt+X3KWux2PZYl0fr6Nx9v1gVsZlueR/x8NQ7Gf7gBrZzNQKod4nGl/omlY2oSVktKVAuY6Tulv9TBoci+y5VSmNF1nlgOwESG4Km8InTe614sQqFMl660dCRA1gTCkgqnGSMAfXgkj5FWbVdOMsU2qGTTBYLJ17xSY1fZ1doIUooXDfzkc+7//w6k4emxBcufWtXmnVJ98tzsdnFuM3xAQUu4PKKsy+159o6GSIJIV7FISB8Wj1K/h4bD3qlbx8QsP9f+kJVJSYPBIPnEOBg0XleKETPDnW0N3BfX9HdYvg7yuUygZKgbHutklkIn0=
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


