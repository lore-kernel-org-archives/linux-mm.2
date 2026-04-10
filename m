Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D49F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 20:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679F16B008A; Fri, 10 Apr 2026 16:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B8F6B0092; Fri, 10 Apr 2026 16:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5413A6B0093; Fri, 10 Apr 2026 16:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43FA86B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:56:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D260A160609
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:56:19 +0000 (UTC)
X-FDA: 84643854078.21.A969161
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 072E940014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:56:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQ142PFW;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775854578; a=rsa-sha256;
	cv=none;
	b=fnGPZ/sOyV+5sEwgg8EWJmesxliIK/YyIba50/+ICLhlB3hXMVFFvzhEKYttDouVUbGZCO
	J5rGC+FnEZrjgsKFi0SC/rQz6t7ogrGmnBOSH4LM4qcaQtgr/MuGc2BOFOz7oUWoLEbnoR
	xBleXQyUFPbE45owZA1CP0PYQ1aXQu4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775854578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2X9IdtUnrT50yiykczKjUwFjhJemy6Dkqp8i9B0154=;
	b=wJTWoE+80OXze9gHyfr0xF5bHAMdlNxbxuvd8SUNUkKqkjCpaVmP4aWStzbQCmjgknNqf+
	FWALel/PnDp6G5KnlBX2hxFz65cCsah/IKg9oNmP7f+20GoLuoLqiq//bUalC02QJ34Ns+
	HzRPBxA3RiDWvJUXw3lqCqcS2d5OySY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQ142PFW;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EABB3403ED;
	Fri, 10 Apr 2026 20:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2163C19421;
	Fri, 10 Apr 2026 20:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775854576;
	bh=Pl/TPuj3MEjAUAkiR6iNGQuG7vTK4etd1CQHextbc1Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GQ142PFWFm6CPGgxzIstxv+Opw0b8SXuQ9OyBP6RDGrB9wMYrgGJRlAIcXmjiMiJQ
	 uvHLzYRX996/8mwPCxIT6HNprAxZjHfiZYVGdKL2zkx4tDdEJ1Qjhj23YsuYeVWZUk
	 qB897HhG8G4RkSYw8g0MDIEY8t5mxlaTJQ0hQJRlVPLc72Bfpv47WYQcen6mmTC6UB
	 IDYz08Lq5Ox+catFPgX2TnERo0NsyMmc6D+DEo5bfEi3Zb8CozxsaaIUnftUYBffz4
	 eRJ2pErWPmB+XVojMvRq9gH2C+KSLENGTN6u78aH1Po3BWHW2gKcN/A+CamqsNtu9t
	 mhyolj1ID3OUA==
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, Bernie Thompson
 <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso
 <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco
 Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [patch V1.1 11/38] misc: sgi-gru: Remove get_cycles() [ab]use
In-Reply-To: <20260410120318.320727701@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.320727701@kernel.org>
Date: Fri, 10 Apr 2026 22:56:11 +0200
Message-ID: <87ik9yzg9g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 072E940014
X-Stat-Signature: 1r31wjjjyuo5p3yfu34kak7wx3yu8xdw
X-HE-Tag: 1775854577-713407
X-HE-Meta: U2FsdGVkX18IPr4qzfBm2rYoYMY6PC8RtMeUF3urExZEaf3IUwALsvMlnaZztbneJsr4QkE2MKDsGwcNoeMTIJ9cE8I2qyP9i1vIth7eBwnyCw8+dWT8D1oqpkOmew5BWEA8G7ChqkJED7zjP9QiW6UeQNAN4rj791j5IBoCA02CYZnzW7iIr8y768FfAI48R7S0mlL3TfPy5hJUDYqGd7BIlVrGqHOzYuSp6Gi0TqN62epA9Do0DWS2AuwqeVvQp6/VRIJ51ev+6QGuBOQWJPOChBqabNABlhPPjcXfAc6E0dOEa04Gcb8BiRSC4MCCvvZ0puDxL/IBIAozwZmuvsuC8BKKg8/LVT52LYHujAyEJ01g1P/DdFoOmK+6y/ot7Nur4E0/KYZUjUDnUL96/HhcVg7o5KI+MTduA47LrVaTUMzPwlPD8NBLDIZUgmoA0LG2ZrccpBWR7fneVln6w5AnilEzHS/zKZt5L4Kvt7o0sRdpcpbDxq5ooQSIHls3V56puZI8vM4v9gK6O7h+GCdFyr1P8/fQ9KkXG3u42qQPJkR2pfurSo144xdMg7ZcBnat5719+V916mUkOeUZeZdsoj6j56YM//n5P5EzoyketRNUgnQmhLzDUEX3lICRn85Buj+oUN3hjVGdO70gRIxJPfWqKLrlEu3PgnJPv/O9RFO9NzBJ3+58grZiGPMNVe+MEHCVIc8g+YvMbtCzmSEtzs3Yh6ZuzNJf6wiwKr8Im8p8+1Zo9h4bRnkXniK7NbrrsaJE2R5eAoKGWYZ/c5K5OYJCngDEeCGSfAFp3YeXtWGuBNoxppkLFf9MYRl3aFGKeSVe1C8IVn+R/R4i389soQy6jFcOkROnBtKdS/nk5yl5On/5QkvzB5E9Ua6RsOrd3F/pkzF08Jg+YA84NexJxDswKRL7KBxE4fXOH4R52Rczbt4dLw3AL+1Xc7mQ0c+7mvuUjaC06F/wZKC
 8bRCvouN
 c2hUYLHasvXu9v0rkdOZQ7g1risz3U+EK6UB6AlabvQEMX+ZqlgtwJanrAGhUkXTUPMnpEKNiPPxg88r8ypaf/Ns+/ed9An4H4Yi2P80vGH+FCT8OSY9fEHwrnOVVwuVIIbkjWUcG0ER9A2UwQH6XC8ypPeEHL9hM8a/uCYJe3v1ltKI9rtW52GcK4OcXZrJOKIqQ+5ljej/aGTUeMGOP6f/vpX5HAcHvh/b/FnY4eurGWOqXahB5lNnreNm6EiDEyz52ymIocCLET8j5RLpgfEqqpCkhTuhLdtD0dX5o2GyGWeFCFP9UyEBMPoDk+BU9a2wmDhEvqS8jU3x0+6jhgR1K+oXE4gjnZCpKoFdQTrLga96yz6PBFwY0SL2AISJxuANhRDjbaw3kiyDK/qRG7fBLzOGlPpitqwBQmZ/dLSKoxcozkpJmfmeQRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calculating a timeout from get_cycles() is a historical leftover without
any functional requirement.

Use ktime_get() instead.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
V2: Fix typo
---
 drivers/misc/sgi-gru/gruhandles.c   |   20 ++++++++------------
 drivers/misc/sgi-gru/grukservices.c |    3 ++-
 drivers/misc/sgi-gru/grutlbpurge.c  |    5 ++---
 3 files changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -6,26 +6,22 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/timekeeping.h>
 #include "gru.h"
 #include "grulib.h"
 #include "grutables.h"
 
-/* 10 sec */
 #include <linux/sync_core.h>
-#include <asm/tsc.h>
-#define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
-#define CLKS2NSEC(c)		((c) * 1000000 / tsc_khz)
+
+#define GRU_OPERATION_TIMEOUT_NSEC	(((ktime_t)10 * NSEC_PER_SEC))
 
 /* Extract the status field from a kernel handle */
 #define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
 
 struct mcs_op_statistic mcs_op_statistics[mcsop_last];
 
-static void update_mcs_stats(enum mcs_op op, unsigned long clks)
+static void update_mcs_stats(enum mcs_op op, unsigned long nsec)
 {
-	unsigned long nsec;
-
-	nsec = CLKS2NSEC(clks);
 	atomic_long_inc(&mcs_op_statistics[op].count);
 	atomic_long_add(nsec, &mcs_op_statistics[op].total);
 	if (mcs_op_statistics[op].max < nsec)
@@ -58,21 +54,21 @@ static void report_instruction_timeout(v
 
 static int wait_instruction_complete(void *h, enum mcs_op opc)
 {
+	ktime_t start_time = ktime_get();
 	int status;
-	unsigned long start_time = get_cycles();
 
 	while (1) {
 		cpu_relax();
 		status = GET_MSEG_HANDLE_STATUS(h);
 		if (status != CCHSTATUS_ACTIVE)
 			break;
-		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+		if (GRU_OPERATION_TIMEOUT_NSEC < (ktime_get() - start_time)) {
 			report_instruction_timeout(h);
-			start_time = get_cycles();
+			start_time = ktime_get();
 		}
 	}
 	if (gru_options & OPT_STATS)
-		update_mcs_stats(opc, get_cycles() - start_time);
+		update_mcs_stats(opc, (unsigned long)(ktime_get() - start_time));
 	return status;
 }
 
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -20,6 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <linux/random.h>
 #include <asm/io_apic.h>
 #include "gru.h"
 #include "grulib.h"
@@ -1106,7 +1107,7 @@ static int quicktest3(unsigned long arg)
 	int ret = 0;
 
 	memset(buf2, 0, sizeof(buf2));
-	memset(buf1, get_cycles() & 255, sizeof(buf1));
+	memset(buf1, get_random_u32() & 255, sizeof(buf1));
 	gru_copy_gpa(uv_gpa(buf2), uv_gpa(buf1), BUFSIZE);
 	if (memcmp(buf1, buf2, BUFSIZE)) {
 		printk(KERN_DEBUG "GRU:%d quicktest3 error\n", smp_processor_id());
--- a/drivers/misc/sgi-gru/grutlbpurge.c
+++ b/drivers/misc/sgi-gru/grutlbpurge.c
@@ -22,13 +22,12 @@
 #include <linux/delay.h>
 #include <linux/timex.h>
 #include <linux/srcu.h>
+#include <linux/random.h>
 #include <asm/processor.h>
 #include "gru.h"
 #include "grutables.h"
 #include <asm/uv/uv_hub.h>
 
-#define gru_random()	get_cycles()
-
 /* ---------------------------------- TLB Invalidation functions --------
  * get_tgh_handle
  *
@@ -49,7 +48,7 @@ static inline int get_off_blade_tgh(stru
 	int n;
 
 	n = GRU_NUM_TGH - gru->gs_tgh_first_remote;
-	n = gru_random() % n;
+	n = get_random_u32() % n;
 	n += gru->gs_tgh_first_remote;
 	return n;
 }

