Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774ADC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1859E8E012B; Tue, 12 Aug 2025 09:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E658E00E5; Tue, 12 Aug 2025 09:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18FC8E012B; Tue, 12 Aug 2025 09:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE97C8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:26:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 925B51A02DA
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:26:57 +0000 (UTC)
X-FDA: 83768180874.03.1EB347C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56E93A000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:26:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IEnMVdw1;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbFrm91SUbV4l5hJiwCmmvNUYm5bhZMJ5aJamdpeZ6g=;
	b=bcXqfCIv4wKciq4a0ySZcmHCBFW34ZpMcqSBqmonaNmQniqm0Nwl/rHBu6tn4eKaF1H7uQ
	JNTypKYELRrYnqGDX3MHwWXQ4oZVLSO7EH0Ml/wkNuvV97GwLT2ieantQ6+BFFwMj5PmEW
	kV8i4FS6SX7oi2qlHtTwULu4NKA0UQ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IEnMVdw1;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005215; a=rsa-sha256;
	cv=none;
	b=OTiO9wPj96X1RhnLTNIfQ/evHazB7BuMa3wx3GjSYJvWJcsC24wAqsCkffawQDR9Olkqyq
	/o12xYp1ZyYZ1PmpVuQfg1NrPQD4aYn9vMycX7zj2LhEVppqukZjlpkTCLw50JKjMV4fI5
	Zmysyh32M+IodioH/0mV+nTudkNk0DM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005216; x=1786541216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9/RZLCMjXQxGvwHsrxYm6WSdmas+FAtxJYkFWNEbaFU=;
  b=IEnMVdw1sUKPcMnz7Fo2YZ/gjMRLShxTvtQk/Bx8pVeA1kmj9P6B+OZT
   kleKFVhDqQGdlFGKXFSikZurV00VN4Rrt3Izbasm+IedCeQMPbp3uwm3/
   SiAVOXguLKKg6eaU5TpoB1I94lBV2Jh5VgDf+g+RfOJCANrQSWrcdfkWr
   Anno6asytPxEz8OYzRgYnBiYlXzWHpjlPb4bVigOYpwFNSc1Eqpy4VQ+H
   dIps7SY/LbYcokaJyBNJPbxoLr493K3Q9VsAIds7krDafDz2d1b+d45gg
   VI+ug0Xp4DaG3IfrT/sUV3iR3VYTgT3jndaIGHDWzEhRMjbtOFRo0BWqW
   g==;
X-CSE-ConnectionGUID: r5GnRCdhSRGdJASau57RzQ==
X-CSE-MsgGUID: 0/KoqY8oQbaFtRXueHTzAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903248"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903248"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:25:44 -0700
X-CSE-ConnectionGUID: G0cKUUX3QdeIuuUQDf731Q==
X-CSE-MsgGUID: HyifQRzJTUaZ4oYqgT0L6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831317"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:25:22 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/18] kasan: sw_tags: Support tag widths less than 8 bits
Date: Tue, 12 Aug 2025 15:23:38 +0200
Message-ID: <780347f3897ea97e90968de028c9dd02f466204e.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y7zigymyb6pbiy1bhmnq6i6dggi3cxa1
X-Rspam-User: 
X-Rspamd-Queue-Id: 56E93A000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005215-735870
X-HE-Meta: U2FsdGVkX19FKk9joDx1y6OyA5zAqdjfFKZq9Yh9keEftD87kTn63eED1FSoLcG9u7UemREAD89kb/3HUJdOHw8N7AlSLHe/sb+SohcFUiELkyceyRfCWr3ExlINwRYbfF4tCyYlWfrgklFbnSXRC2ljTV+FhHhD4i676idEl5m6kyMpTexBSuSUINClywm41+RAKsdJb5m3L/xcOoGvsvbCTlcdbYFSZKoDw7ZkGVQK0qhf6m8enBFZgoJsRyAZ4TfExZI5c86eefv5LoqCasDwInt9nDJ7qoE9upvVmeA28idDtCd8j/NVlwLE8M/+Wr1O8sSEisGFDjhIZETYM9foIL8WxZpddVFDg7UOdlReOzo2CjPoj3HIvYuZVuI+BfsjqJnnP7B4YAPCoUbJsB3IbpykBOjL8iqlRDpsDPkEFTQZ3fCaW3fAGSSFOW4ekhmGuG2BDYAUqWplQ3xD6tbkqfb6PN84En4FsQiDlMJ18vhzUqqgfoLqgWA1mTxXvGtx9E77VZJqhFMtogmvjNMEGodvVmQaiwU7GCY0V73HuJJ/QE65EZIQk34jPRuU3XkWYLIndIC0XInhKX4aEoghGSuKYDvEia+RSDJx7Ie7OmTJhIIVl6g1axEerPOzsRLZ2h9ZyJ7EyUKU+rvQxZ3UMj1Oj6bxblKUqTr9AznIT58SNGp3VpLnMuzqBo5bTWmCqGt8RZ6MwDEg8S38QYcey81qY7g7oi3u0Ools2qjWrfx/qE9u+UhVXbnCXhm5Zu72+iag5qdETA4x/PV0Sv4URZmnuALS/oKkLkbaV4YnfidH6yHr1KMdtCISriX4nj9pX8TX7H2qqBtlvLgP0o3KMBDG7WR0Eh01HHxc/bAUnONeYiXBpBvAhW9+ObYM6lrLgPimRrD0PIP7KcnRqV921Enrs+F+01aougRVCvUoYFryUmwXebwyc18yjzHvzTZ1k+ynFI//Ar9EQ+
 h+Edc6Et
 +MKYaFY0Tqk7GkXnVUdomdN3szPw2F7qKj1suLdwZVQbW8OO9mG78C+gUJRGjIBxIkAFKasHA4djrbqYPV071BwSuTIGMOHBkqRCp+vw35BFK84/khMcGfIc586MbSd+pqIuya/VrOoQntLjkHLsKPwAS9EX6kylp0ky51n+FXjANzfZ7bwmtAH6KtK6EN+l4fC1JQIUHwkjTi64qNOfPvdDAa7rRoaNz/Xt4Ws6nUObbkV9iDT8i+maLmtNTjjtwQILtAlvJWpCzy6mJtQj2dW3Cvl6sfbLgmnv+T3ON/FTo+tVBawLw9/TIcs01U9qHPwpBLi6fGG2Dtn8+cVy4Lgrm6z2WVp6y3cGVue3JpDtkPQ731lCQWyfA8akmcz3MX9FL
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


