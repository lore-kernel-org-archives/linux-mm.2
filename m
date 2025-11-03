Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB90CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 06:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155F08E0022; Mon,  3 Nov 2025 01:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1065F8E0015; Mon,  3 Nov 2025 01:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B7F8E0022; Mon,  3 Nov 2025 01:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1DB28E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:37:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EEC8BC2AF
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:37:44 +0000 (UTC)
X-FDA: 84068340048.13.3E308E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5B9D40006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:37:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762151862; a=rsa-sha256;
	cv=none;
	b=0xt99oULzak8KaYICh3wQVMjtFwWVTqM3BSXwyGvH7PJzneYKB6+aklcwhVzeB0GEfHt65
	oKF0j8SiEYVCnm6eVVOINtc5nwQ8quIwz5AfSgKuFNVCR9iJ27H4Gqxird+LTB3G1AXx8J
	maPwtnJl0reWNKpKD2L+alDIoFx3Lds=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762151862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GJIPJJXmQ2fWPUkO5lEa/TKja8rwMjMgSN4jo2vTnhM=;
	b=p6Ke4PI7Okq02fH8NpTIdpwLp7j9dQ7NmPhLVXj/tWSCeL5mCNgU9ZFlaxzr7tmVsgkgEF
	YEvcuBPzIzD5oWzRFI1MIRa5ImfU6Dw2Z8D4s+hETI4b/VR7u+bkZaY65MxCYMvyRp3LGW
	o6WnVK1EHHTT6ENtsHYcUKUGIXS8Rqc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 005BA28FA;
	Sun,  2 Nov 2025 22:37:33 -0800 (PST)
Received: from Mac.blr.arm.com (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 258E73F694;
	Sun,  2 Nov 2025 22:37:34 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	hannes@cmpxchg.org
Cc: ryan.roberts@arm.com,
	hpa@zytor.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	ppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Dev Jain <dev.jain@arm.com>
Subject: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
Date: Mon,  3 Nov 2025 12:07:18 +0530
Message-Id: <20251103063718.90743-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5B9D40006
X-Stat-Signature: 1gzio3mn7e4ggwz3sbhtxrr8sky6cwjq
X-HE-Tag: 1762151862-50220
X-HE-Meta: U2FsdGVkX1//LKKxb2NxpnOXZIrcUCKuLmls1kIE+F3c5so3p8PU67o1yrWeHrKLF+33KPSZif4u8TKZZj2lHJTX9tto1TIEGRxxetkp3n1BFDEFJQ4V8YkFcZfl7VxDcIee+vzLJFduD0eYZwGKVBONJEhDGHq5UMF+Uvr11KwBJJjkWJvaIzE0tj5G1XzXB5D25NxRkRJNLfP4gg9TF2l9pc6aOto/2ZOKuov0ZJ3oqrNxLeZD3Kvbiwbqo5cYCRch03vpfpcPJIdnA0+orsnlmjP9BANnoB3lu0G7kCOiUYfgouODwhM7BMT5HLN2bTiW9mj+A4j//nFrrJIGxRZrvM5amfog3wjR0s1CEpFC9R7jk1S3TGGu3mv+9iHXy7WXYz+DmMbaGMdbbMFxTeqZwbEv/86IPtfQ0gz7TpI1jxoXcjEoyNaq0CZtlxDUB+9I1Oj1duuKmq0fbHCMhGHWU1mAFAKUbyh5p1Bg7ahtZTTbg/PPVlbZR117pjy/ytxrK12rVfzrNm6QVnkrYj9YZIe2Evh+ISZokUwoPCD0XW1v9OnAWjdcs95a+yYMwcwHBQjDnbG0PnRFa5F3iH56nk/5xT8DA2TwXLQ4fnIACSmKCVwoQ2iINsa//s1+L0Xs/h7oOcFWtpf6f+81FUZoCvjubS/8F/D2xQ7TaglVy60+0TvbUDa6+gg9qVRTrP4Zr+0cqiD/5JFZcOV1CrVYm6+6fCHZkWT64rYXq+cNhERtSjEECMxey+FGEiQWYlxHHUOjZS8Xy6JnhisBgBuJGu+dVtZYrgS4YqMLLPJ1zM/OpSIHMox6FTjoWFQ8ETzkIIMFEZH0y3NrNPU337flELwvpczF1Ym6DX9QBGruy8EXjR5/Xo8p6wh1BOC3WBBZo1sHw6CwMNx21FXHJ/NroteJ1eXzX/wSTEm6EaN84SHNozVvDZNH+qmiJWoFeCAHlxz0lBBtBsR9r9C
 ++h6VpnR
 0/z26KLStFSeNruQ2UjT2blKS50arTHiZ6kVks8jSlXwURVZrBn4jpmvkrLfizeJzphIMF/RZ65VembolCduPHVowEoY0Oe0sfnw4YAPO9hU3HalmTZ43P8sFOwRFUthshIp6rzsXpT2NDkfJH0amlXkno/K4lMstMOZ/krgB1ZkCuZbnv1NYWIR7g+/yWY6Zsnfk9a1VYr6ZaL/wTMFaLVgDALq+mCQ/QfVmERQCpKLmS+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The implementation of CONFIG_PT_RECLAIM is completely contained in generic
mm code. It depends on the RCU callback which will reclaim the pagetables -
there is nothing arch-specific about that. So, enable this config for
all architectures.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/x86/Kconfig | 1 -
 mm/Kconfig       | 5 +----
 mm/pt_reclaim.c  | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa3b616af03a..5681308a5650 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -327,7 +327,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..903c37d02555 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
 	bool "reclaim empty user page table pages"
 	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
+	depends on MMU && SMP
 	select MMU_GATHER_RCU_TABLE_FREE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 7e9455a18aae..049e17f08c6a 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/hugetlb.h>
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 #include <asm/pgalloc.h>
 
 #include "internal.h"
-- 
2.30.2


