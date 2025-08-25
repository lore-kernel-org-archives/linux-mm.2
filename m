Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C8BC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D908E006E; Mon, 25 Aug 2025 16:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4AA8E0038; Mon, 25 Aug 2025 16:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B238E006E; Mon, 25 Aug 2025 16:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80E508E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:26:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 265C659652
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:26:19 +0000 (UTC)
X-FDA: 83816412078.22.EB79ABE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A35018000A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:26:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NF6aItKy;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbFrm91SUbV4l5hJiwCmmvNUYm5bhZMJ5aJamdpeZ6g=;
	b=LIMqgWHbAZKAnp2rFvPnzAvTnzDN7ZJN6rTJk0xw5/gWRXgQnkwlj3piuZl9PlQ6GfiM2e
	C71F5a0rjxx96fJpAesKyOg3K1clkwGtruiYzc3PpR27o7+V2ApKzzKEo9jMXxqyjn+62+
	pNQbDnTIAC7gn72wNhx16M1CF/bOJD0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NF6aItKy;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153577; a=rsa-sha256;
	cv=none;
	b=atOXO9xA9PrI80ukbQ97I3V08M39+Fjgsvynn8ms9grn41ubt2pjs6ZVt8Qi3qVSDGqJtD
	8b6Kk825XTsJZ7xJ3wr9V0XV6c+s6j2YNavJdO5AcX14rmX/wtIaiLLJOM1X6xXdA6KWZX
	WOVyM9SdlDa6QpkJ+SlOOvw6NV9xo6E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153577; x=1787689577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9/RZLCMjXQxGvwHsrxYm6WSdmas+FAtxJYkFWNEbaFU=;
  b=NF6aItKybEokVAho7tSGxPKJdyTuTmqZczbR0D2RMa4/w7W5EpIPhS3e
   lrUkDbEQ/jzxPd6AOvghvvo3Tz618nZ3SI0sya6M/JLNymNR7kQCEZc6l
   zD6dMD0v6LWAIfJxCKt4pxEB0G2aQ61YTZQKX35RQ7rf0DR3loCPmCCJ9
   y9s500b0rWefqe5DGNXs6BWgCqTBrKH8TMim9RDTDQgxbzwmGploxKPMg
   kAVxQ7kX9TBexD1lg5l8CZD3d7GZv9w/LgLFg/vuLvfWINCQij24PNOHa
   HtSfCLJn1AtOPDGMB/TTsrzk/GsE3XFTM+9QA9fIAaAfdVZ9xA+QXUXTr
   A==;
X-CSE-ConnectionGUID: PAohe5LUT4urCgVr/M0NVw==
X-CSE-MsgGUID: PMJjZtygTXyQ81MjnXQqAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970325"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970325"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:15 -0700
X-CSE-ConnectionGUID: +L18yj8dSzOfEZlF7N6ftA==
X-CSE-MsgGUID: jAlCsbyqSiWfjyrRW8QvcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169779897"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:25:53 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 02/19] kasan: sw_tags: Support tag widths less than 8 bits
Date: Mon, 25 Aug 2025 22:24:27 +0200
Message-ID: <83955e7079c0fb9c11169d25adc6303f0c66c1ec.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q7rt9w3k6t8dn9bsinr1mg4geumwn3d3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A35018000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756153576-915047
X-HE-Meta: U2FsdGVkX1+91Z5gUu+lxgvzcm9ADVNIwrPR8x3h4TkZBDNLXvgvdxM0cSch6gxK/dfwQFwh4gIgtGM6T0/7l4b+ggLZH0bQ5POtqyW4alFKKR9JBrwWn2Q/q4Q85jpiU20hJkw1UEWGce7F6hZLqCkZZGbC+q2qxI+NaJ28S27hvrtvR0kdsCKLl8FrHip0PpIcwyHN8sKgObH1nVXnl8IhFrKn9bUZcAnkaAM0W5a16J46vTflvwap6y5Mxcc14JiVlNA1DnC1d4upASeR4GD0oXQZktf330w9JOYYbXMLcYh9a87i0NnR2MKT7Q5nURztrkmIeHomzoKPMMMnWWxNOrpTm0KIh7I1Rctsw7eFWNSQNN/vN41gdftZUyieBh8iNaUwVeOqjGuVJCochnKJK25HGnV5j2U/uIeoAhgfi6zhVRKXFh3c7+M4EdRgYvTjmee1pBngq2HaIT3Trzc+tsDqDS9Mn3TOYtEiuIFV0qdNbuGNVGCCjt0hHjgBjhGFZFb5YQCpM24ybmm0iMwphWfjPV5Gr+OljVZbFQxL+CyGsc6W94A9VyWPKqP1pKejAxIaNp5GMxawN2lGpQEoZuXBnMTwPlPvBWGzwrOe8FOb+wOWLMiJMFT8874Rsix+Y3edULsR9JFTGmoX9pVQqBbFEU4VrpsJ+OjvkQ3lCmv8C4aNN3QP2AA00G7YUBzrY/Px3ggPJnuz+kQePpZzDbsWR4JeqU/QE6eEuPKunSA9NtXYO9JW9z2HG+xIuBi5ieJSupzvlOh2w1norGNR1h4yiMECz00ekIo/N5edlLiK7nYHNYwEYKGw/1uBJovq59cRaiUBpzHX6Qs8Y3URKzCd3oI4n5rcGBUCEu8QKTmLVnVduesKIe16Z2vYnHENNjRuvvZjXW4Y4ANc4Xv+jumHNaL0uyurPQ9XeolG2KaMLcskSOQygq6rGq16QQV17ebwpIDSBd8RKpj
 8DEWImJb
 hXstrWxtOBv7TDYV0HfBQ0HirAAIT2VhBemjjJDAU5/5kGSdJ4o67Y3J5lRVT2qstZOFRs6YcYTcvVj0AUDUd45gzkJ0x+E6cFDpaw16AzufF87YJbSwDy9DweyhuHw6GkGh44Oz6t7L3spt0bVGujQUWI1g8Fp8xHbrZEe3dtI7mHP+PEoLCIiE+sNy7n44pVeIu1T6BlyaPfvQ97p4MkvzO5PFm8xZB6jHSOENoB0Xuxcvzg1KPeeN6xLdKI6HnKCtAPZT04cjERTUiW2OnnN399sGPNCWiD/xF4/JDsRhCguX1aY8EVSPxFErw1at2fqrLBBPGGMholgLOqsmSKeV3Eol0Ay+dmdeodGGGdIOxTmV/lZvT+0fi3SwYu2Zq1TEI0DylUdl+qi/QwXWWNxp7KMeusw9Qmqyu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samuel Holland <samuel.holland@sifive.com>

Allow architectures to override KASAN_TAG_KERNEL in asm/kasan.h. This
is needed on RISC-V, which supports 57-bit virtual addresses and 7-bit
pointer tags. For consistency, move the arm64 MTE definition of
KASAN_TAG_MIN to asm/kasan.h, since it is also architecture-dependent;
RISC-V's equivalent extension is expected to support 7-bit hardware
memory tags.

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
 arch/arm64/include/asm/kasan.h   |  6 ++++--
 arch/arm64/include/asm/uaccess.h |  1 +
 include/linux/kasan-tags.h       | 13 ++++++++-----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index e1b57c13f8a4..4ab419df8b93 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -6,8 +6,10 @@
 
 #include <linux/linkage.h>
 #include <asm/memory.h>
-#include <asm/mte-kasan.h>
-#include <asm/pgtable-types.h>
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN			0xF0 /* minimum value for random tags */
+#endif
 
 #define arch_kasan_set_tag(addr, tag)	__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)	__tag_reset(addr)
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 5b91803201ef..f890dadc7b4e 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,6 +22,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
 #include <asm/mte.h>
+#include <asm/mte-kasan.h>
 #include <asm/ptrace.h>
 #include <asm/memory.h>
 #include <asm/extable.h>
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index 4f85f562512c..e07c896f95d3 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,13 +2,16 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
 
+#include <asm/kasan.h>
+
+#ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
-#define KASAN_TAG_INVALID	0xFE /* inaccessible memory tag */
-#define KASAN_TAG_MAX		0xFD /* maximum value for random tags */
+#endif
+
+#define KASAN_TAG_INVALID	(KASAN_TAG_KERNEL - 1) /* inaccessible memory tag */
+#define KASAN_TAG_MAX		(KASAN_TAG_KERNEL - 2) /* maximum value for random tags */
 
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN		0xF0 /* minimum value for random tags */
-#else
+#ifndef KASAN_TAG_MIN
 #define KASAN_TAG_MIN		0x00 /* minimum value for random tags */
 #endif
 
-- 
2.50.1


