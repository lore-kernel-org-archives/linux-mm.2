Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD6C606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LMMfsIV7
Received: by kanga.kvack.org (Postfix)
	id 736CE6B0623; Thu, 29 Oct 2026 13:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E306B0624; Thu, 29 Oct 2026 13:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64ADC6B0625; Thu, 29 Oct 2026 13:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0B26B0623
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:31:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9A0EC04B0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:59 +0000 (UTC)
X-FDA: 85376354238.24.F062BC8
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id A4E1240002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LMMfsIV7;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62v7psIL8EAQ47S6rRTJha+UTtgm3E7BPb1/D07Yo+E=;
	b=XNJPFI04nBZ95P9f52SwgY5aHXEezESZDPz08EtgHjP/DsKU6+jwY0fGUSPaPsdJePFcui
	cziGj3DDtCt5fBKqpeNqm2eRbAu2BuiwWWzFZZ4DJOEf83SBKlPxjaePcGY/4PZpajf6Ym
	pngA+tVFvwFEbsVrdoXc/bDp24hLsac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295057;
	b=Hd8cukLe5/l5hNZbi56kqqm1d1iSoEjcGEdSzm4p0PEENSX9nmF9OHKe7TxGyUXr5C9Vqu
	v+FWoMdL9etw58pd8CcELoy2H8vqHp8SUFf7WeQu0R5e0VAwUW7zvAlsrwlcweXoNUJ+VL
	zWA9fOGdyWd4+Gxe5wuNo2my655DxKY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LMMfsIV7;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PxCNVTb6jX0UZU4kP0/sdxuyaH5XxnIihD4Mw61jNnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295056; v=1; x=1793899856;
 b=LMMfsIV7/WEuySCEeQ2ahXjZrszY+S3tecdRjOn+1M62yCAFfHGHSIAKS1DEwfQK1o7OKVxb
 bz2XZ5ru3RXLaPasMWrVcUPjFWcjPvXGUeJ9AOs+lztf4LL72U/mAHJpNKfXXPY1B30JgfpTTSS
 7QgfD0efB+yaycgxYhXyGieE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cdb39e29496ef9b2;
	Thu, 29 Oct 2026 17:30:56 +0000
X-Mizu-Trace-ID: cdb39e29496ef9b2
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 6/8] LoongArch: Enable kexec handover (KHO)
Date: Fri, 30 Oct 2026 02:29:53 +0900
Message-ID: <20261029172956.20791-7-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4E1240002
X-Stat-Signature: nfn7eoiu9oz9fdk4ba4g6aoxt6idgzqc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793295057-162649
X-HE-Meta: U2FsdGVkX1+yDT3QjibX/5htV3c6glXSlhDXEm6Y4CZQB1u4Gpx6LvNunPPKI8Mzrl0DG2Z/umaWh/5CdsKQyn91qnsLvRshuWrHA8j9UdIKRCKJWHn2TdJ94cdiLQo96K+FeVdYHh8vlpRk6RfRz6BmQQZaPLbJgVYDZUyO3FL/7X8yh9aMG8vSpanEGXBngn64kcee0pflhiUb4IQynpXMWI+72ALitON2wWFK3iphZBZaQeIIRTOOK+KzbEAhLyqn+bHQ5v7raL93isOJZsUCztKQh3brh7Y46jdAl9nGF/nlbh4yo25Z10/NTdROFhC/ivb3lnh4nKzAG9Ri3F1NzoxWo+fXP1LrNq/J02r1tLv6QbveyfKZskKzba1Kw22mXeI+XRtIgRHWa7ybepztKHzbyYF9CC8A5a2mc7/nGmrmkdY6S5Xk6x3rRHaEJ5brDaNPhqqzV9KdNe9OTUzx9jaVitTHTChvyPSv07iYg0pyBfEk14sfCsNZbqKknntu18Gm9VXtr55FcBci03AQg7vVFSoKeF9aSsUJT30FUpoqO09JZ8CC4LK6EKgT+z8WBYCXyu0HnbfFWKAP1ZxSXICJWZuUX+5CYwah0Z14j2iC3z+rAKxOXIjeszFAaxyHMC7nONc9yt1b+BkZH77k/GS9YbkAERw3CHDzePNXsUbd156v+FzE1z04aBrMdkP9I7TSmplOE6KO4dg8igSAHq2pyX7Wprd26I5hgqpHvJCxW9I+BXWgwjzMF1Pmq1nxhPTkF52jKNbh+QhQbrEAhB8Xec1SRt5bYQh3thxbgl+r0WFepdEg32amwZjn3zK6ua5vwm+tsSgc0KkG5sNfExsF6ZYPFwOLd3U7TfEy9791fdN5ShrY6O0RWr/sXO/a8ktwHYen0cSYBWOa020YPIZKL/cDbNxqblJBJYKjmqjobECoSeisOuyvNpu5SrfxA7w3oXAUCSEA27N
 A06fi7b3
 EP/pdG7wo7IGIN+VtM+o1N528EDTNpaWLDmoCqm+2cmIvBBCDOr2tZxncN6tvrzWwJU7SE/1QvqU7feJN5Ebiw3rs+ht54CCVSfVLzm8NGoMMBmKnBG3rGR/MFd9WU96PlsKBkjo96ayiqu3KdUgABGuU14MOAkHwKJ/fqETuv2l6E6/CARIaN6h2w+2ROh+ZEVzCzEDQXsmFGvIZTpJ3x2KlvMtA85oiRyea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

Enable ARCH_SUPPORTS_KEXEC_HANDOVER on 64-bit LoongArch with EFI_STUB.
KHO state is passed through an EFI configuration table installed by
the stub.

Disable KHO at boot if the table is missing, since the kernel cannot
pass KHO state to the next kernel without it.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig        |  3 +++
 arch/loongarch/kernel/setup.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index a21f51e5815e..d35ddd6ec540 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -685,6 +685,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool 64BIT
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && EFI_STUB
+
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool 64BIT
 	depends on KEXEC_FILE
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index dff2e0c67ea0..e1023f93460c 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/initrd.h>
 #include <linux/ioport.h>
 #include <linux/kexec.h>
+#include <linux/kexec_handover.h>
 #include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/console.h>
@@ -594,6 +595,20 @@ static void __init prefill_possible_map(void)
 }
 #endif
 
+/*
+ * Only the EFI stub installs the KHO table, on a cold boot. A kernel
+ * started by kexec from a kernel that did not install it has no table,
+ * and the next kernel would not find what this kernel preserves, so
+ * turn KHO off.
+ */
+static void __init kho_check_efi_table(void)
+{
+	if (kho_is_enabled() && !efi_kho_table_found()) {
+		pr_warn("No EFI KHO table, disabling kexec handover\n");
+		kho_disable();
+	}
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	cpu_probe();
@@ -608,6 +623,7 @@ void __init setup_arch(char **cmdline_p)
 	bootcmdline_init(cmdline_p);
 	jump_label_init(); /* Initialise the static keys for early params */
 	parse_early_param();
+	kho_check_efi_table();
 	reserve_initrd_mem();
 
 	platform_init();
-- 
2.53.0


