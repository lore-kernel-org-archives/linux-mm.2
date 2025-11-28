Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E2AD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E577E6B007B; Fri, 28 Nov 2025 12:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07326B0088; Fri, 28 Nov 2025 12:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59FC6B0089; Fri, 28 Nov 2025 12:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6D766B007B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:33:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87F4CBA972
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:18 +0000 (UTC)
X-FDA: 84160712076.13.EE0785E
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id A94261A0009
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bMdmNE5J;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764351196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzVmZEhrWIC+aQZyznc5Rubu1tLJPaR0ZiI+G8KnN/c=;
	b=yBdgVD39Rjof8zBj2iG7i3CJy08+WrYWg3Dgcf9kihzBuRK39uxpaOr97PMGMeP9MUT2/M
	f8FgbonIlvXkR4J9JoXFRWkoFSW6b5jAGa/gJ/1csN4XGbBvsdk04yHR+cvdS92XrM+YBB
	+kbfcC4L+0fPsRhZoKjHn4wM+8oX3bE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bMdmNE5J;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764351196; a=rsa-sha256;
	cv=none;
	b=JNcMrnOvtliGZNwv5IV8i1q7SKI09S3MOmLoNCGNbBbnfp04SPzUjkLOSP+BdDKBplFpOQ
	XaBzqmEc9xyucxtc2AyuvwUfYtbcHhQETxs3iUPQcseTQnqPoTi23LYDl/qBs2/cET+Jy7
	8Erdn3lyo7U02Nnd9gCM+wrFWUrqM4E=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7c78d30649aso1542611a34.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764351196; x=1764955996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzVmZEhrWIC+aQZyznc5Rubu1tLJPaR0ZiI+G8KnN/c=;
        b=bMdmNE5JKKBtoJLc9wCvvV9wqRSK7dOC/0HYxotTLoTqaoG1fKNV57hRMCjiqmPatq
         3mPZWo1LSfdpAmWN8JVWBlR+mSqDP8Ww5LesHFc5eUQqyYWNuL74pbK/gk3iyLRWawTH
         tjqo7FkbWOg0ZKy5/PfL4opn+ToHx3nOTtrkkOZ3pyUDaezfqNAnlUangT5uFIEuhMKD
         VPtGoQXqs9rKH0gVQXMP0EyhjKwgaM7FFEHJ+FvRn4zYo18ZsH9pKbeCzAMNAi5DO6g4
         bA/lkEB6099hhNjCSu5LsUi7bANBnedNLorQ97Teu9kIMcBaTi1G4B4+Chg6+bjwHR8D
         DUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764351196; x=1764955996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bzVmZEhrWIC+aQZyznc5Rubu1tLJPaR0ZiI+G8KnN/c=;
        b=TqWbTKrHt52kFCiGe3wvAVp5XTrahaxaxbi/dPa2cI61PclaIi3WgxLf0R/aRyllsz
         GN/MVa2ANanKKp5Xwh+ooZTUXlGC5d6Qwdyha9KagseXDs6mBn9gedXfIQuwrx8LCDIK
         QIBy/bfilTUYpEfhRhDE+1dmHoXDQ7e0Bg7YorC1U5YTaBzF7bw8gKmwSO4Ixlg/Dmt9
         yMqI3jkbckaRtCbT6McLzIproy56EtdWo/3dpst+upoFLYQ3LrD2nxX28mx+2x2hTuOG
         yahWD0H9Lfjqv6N51VMAegXpjJThr7DjQGmdaqpITjiK8A/dr/jc1m+sPXd/qTU2nfvG
         DeCg==
X-Forwarded-Encrypted: i=1; AJvYcCWLQedXoQxev785oujXIE9kA1N4NG4Rfz5DNW5zzWCh/E96eYQo+ateP6oezZSo5msjNgDHPLWSGA==@kvack.org
X-Gm-Message-State: AOJu0Yy/npjOgGgmZxKr1ryS1VIEwCNDruYFvI1xJu7jsSw0o3BGTfdb
	7rHMNcPaN/X5HOwXb30qj3diWh4l4AGtQ6Pw83dJtgooLh05mAIwV3sh
X-Gm-Gg: ASbGncucCArJftMBTCig1DjknWhc4FkM9ZTx6zZUNcBEsedcWj6vW6y1RidrSeRkeH+
	WscNfk9w0TJhhL5wxxb7AhiGA8h9/icahSjDNmvrK2WxU7YoXtNiWcQ2W4z2vEJRhdWs3miVc+W
	uwxfbnGC2zu6/oKgnbFEZzciD0Ptl/xvWaSsIJh1EfqYRBGgVGxrI8YDcPxMjHuSQjQrAP7SAvv
	kqmxWMXpfX5hygrnmhj/3tRL3iRXSsWNnoUVmk1p+uO41q9yKi14qlbLAN9p8529VblIer7012L
	4OvwS/3LZH5jXW/hc4AlhmY0X2to+GnHc4nkJl0gkwgSjnUSHZ5sx6E+r0GARmYWMQiSWsnLoIa
	qCuJwFMJJU5YgRl04MK1S0VDij9OZBZmT7izBmDfWcBj7mGXK2J7zYNmddrPWs+G09FXe3TbT8I
	07YaxeZaG4VDCQhPm6r69I
X-Google-Smtp-Source: AGHT+IFtERT/7TfmhkqmMJead8jqcToHnN489Nt4KW+PvO7c4NBncwinwClG8PD/VeK3DQq8gpMMGQ==
X-Received: by 2002:a05:6830:4186:b0:7c7:8280:edd8 with SMTP id 46e09a7af769-7c7990bb98dmr15434592a34.37.1764351195677;
        Fri, 28 Nov 2025 09:33:15 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90fde227asm1758310a34.18.2025.11.28.09.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:33:15 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 1/2] mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH option
Date: Fri, 28 Nov 2025 17:29:33 +0000
Message-ID: <20251128173257.969322-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128173257.969322-1-usamaarif642@gmail.com>
References: <20251128173257.969322-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A94261A0009
X-Rspamd-Server: rspam02
X-Stat-Signature: chs69sn7an9iy7gg4zzwmdnzt3t5x1ht
X-Rspam-User: 
X-HE-Tag: 1764351196-194537
X-HE-Meta: U2FsdGVkX18zDeerXBKGc3UYSewiH6COGqBVYGrgLMTDdVQJHxSnu6H0v16EpcpXtp2/JbhQVcITcD/lbuJhz9PUBkhejuju2j5vzoCZnc50D7ShCm/7riaY7rQGhr1Nwh4ze+ympJJYmC/WmHZMZZR6/CT1wqzpOp3K2FcQqFA58VcOeHpvQQ3R1fl7LPg3Y9oRScg4o7E6TfnDJ2gfWChngwsiI2Vb4bZ41+B/NI9pXi2dNdC/fpzwOVVDZNvM8wpq3bJcA2YCKJXtdbgQBiXVt0bFTn01Yi1E8zM+Urq2uNlFEna/vdyn8UhiSHVWNtnsWgx09AhJlUHIJ8CyVy/fit3aMnpgD2JiVMFTpF70eSFPE4iSvFcQQFn7VGmEy/vDqxEOKv8BbZqyKXIHj2EoKSOQQZQyw46g25+UE05ONfRkJTwQj4Fu7eKwHH++02HcK1nFdNX1l9AnBw9Jg8pcBVqi9ejWa4kOy2XfmZgRUkXr1N/dcTQ3zI5PISXyI80WIUDAJm+fiGVMjuV7dAJDij4Timcg4CNZZNdpTkmVZKB8GRfByvWBZqgk++f9rc20L0WaATpkiK+/uxzfPjg/CL5rL3ODIlyoxiLyS4GZeKB/nwZYmWhxSd1nCjbQ0Qzm4dVmesgRx2xVftvBQDaHJYR8o2TSyAJpL7ZICPoq0mqOzCZVtsuKadcVTYi6fyC7Bv2Fs4+oB8kGlBpoBT4YpRvZFBd8Fth9MV58mIleAgKBsQ9yNlH0yx41ixaUbFUft27kXdN2B6QmqFjB2mycGGSlGX2ri8oIKuEjnFeoGxEvpQjpYeV6udb0fykIneTnTh1B2KejyMEVU+hZGrQbXhzpQUnKxnffzAiq+w5LW49wHeFMcPJfHNU6QKsLdRTccmrzEGmBhqBOzdMBWFkFxcLVryoLa4lxn4eYcTA0BfOfUVYQFBMuWG8it1ZnHq6V9O41qfKAvrvDA+L
 U03FSyqW
 EuMVEcRtx+x3JWx0/y1OQJOdRNbga7X5ankmPYxJ7rNO83+cL4l7mYUX73bvjKhPNBNlU+NGCFW90JqQ2TLgkj2N1npSH4/Q8jDEI3lUYzh61t0T4GBuSDI+NKcTZ9wzYYd+kIzHMyBLw/o8Vr5jtnEjZdhEVOjARfVabOFp7LTuYCywCnfKDiU2gqKBpMXJzkUq0ThaklIYKqjxBJ80INBfrQa1Qlr+ANvE4ZHUlhLjVq5z2OQ/6OW2mj9bZGj8idPdynyKdNd1TrlNzXmeKJzXvZVl8W9XWR3mti4Yd4uUfv5vyYT7Hjj6kj5SHn2KcNskHlT/2zCm0nMGK3AH5Iu6VjIkLnBapkULs10HIuW9fRGyqj/skXnELXiHbXxF5RkSp+Uca7psTXLD9dcxaRGRoe8m5wSdyo0/8zf2zWL3+hVZuvuLUnaHSdX7deER5gOn5wR1F19Gs8KFA1dSXpgKAd1J7dfMZCxsoW4diB6lHO9Q/+NoYlQIdZYNGX3/ZT7iHw7I4FM2N+Nap9uzF6emx16RtS9kVEu/DBxhzwf7r07+HCt8wpO5cR8vGQW6mbks1E4q3uMphtopmiaN6oqSYwUyqQUAM64dk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only cofig option that selects this is CONFIG_KEXEC_HANDOVER.
Replace CONFIG_MEMBLOCK_KHO_SCRATCH with CONFIG_KEXEC_HANDOVER
to simplify code.
No functional change intended.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/memblock.h | 2 +-
 kernel/Kconfig.kexec     | 1 -
 mm/Kconfig               | 4 ----
 mm/memblock.c            | 4 ++--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e1..8bd9bcaccceb8 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -611,7 +611,7 @@ static inline void early_memtest(phys_addr_t start, phys_addr_t end) { }
 static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
 void memmap_init_kho_scratch_pages(void);
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 54e5810726176..06a7c43652cfd 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -98,7 +98,6 @@ config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
 	depends on !DEFERRED_STRUCT_PAGE_INIT
-	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
 	select LIBFDT
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af82..6d6002f57c18f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -442,10 +442,6 @@ config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
-# Enable memblock support for scratch memory which is needed for kexec handover
-config MEMBLOCK_KHO_SCRATCH
-	bool
-
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b3..8b13d5c28922a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -112,7 +112,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -948,7 +948,7 @@ int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
 }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.47.3


