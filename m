Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E890BF44851
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FFA6B0093; Fri, 10 Apr 2026 08:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541686B00AC; Fri, 10 Apr 2026 08:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409006B00AE; Fri, 10 Apr 2026 08:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9F36B0093
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFD28160513
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:27 +0000 (UTC)
X-FDA: 84642551574.14.99C537D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34834100003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uunn/bCq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823566; a=rsa-sha256;
	cv=none;
	b=DnZGMazAyddjS+0bjedHRVrA+GYI9tiLXNNfCe+hc72I/M0Sf4/T8lnnHsQ3CgGV8ry8pb
	gBsltRhv5cCqSJD5CWc04vDzge+T3roiGlNLh9uAZb4X4OJtXOhqLP1o/kWo34HsQScOfr
	rtUHqOSOLIe9FBbwJBBhYgDdqc1/t7g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uunn/bCq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=95Xzu/wrSKdgPqpES5U3P7913oi5C0HtUtRZ8A2JYug=;
	b=VMyAviYZh6vPu569LV7rAhbmLBOxLc0b3e/HhayA8mn8Uu35BCOUcQ/ctMM6HAHJtyLaXK
	TynGYqEeHsiNClB2o6zLjuusAa6bq3yxqpeUqheXE5nbI8H9G30n6h0sUutATXN2DhAEG+
	2Eo260eVhralqlGKqAGFY3g97M8U0Zo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5633E444F1;
	Fri, 10 Apr 2026 12:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A057C2BCB3;
	Fri, 10 Apr 2026 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823565;
	bh=tLIpqPCaUi8Lfeqau43+rfn7UZ8vuvPykTPYNUPuuyU=;
	h=Date:From:To:Subject:References:cc:From;
	b=uunn/bCqpDYdqH3aqiI0+2U/qm27AeTQwxnXbKYibcvcv2ZEX2J7abPlER3gpmuTw
	 CBdP5mMh40n2zp7Tno2Q99U//gHXFdOV0IBNQapDNZb3rSYwBD5TySsxa/Td7SLyaZ
	 p+uL6Iv9jGq9ZtmZnt8i06X/J571L31cWnZuiDLMRsOKbpHdih8iJDMdVxjdr+94oH
	 +kfrO2pFRZtB2b/jp8TX3WQWaL7ksYC/uaT6tTAybV37imt1fhiAkDjh2EPTnuViku
	 1P4aDmEJtrdQSxbhtiFRIYbjrzGEHTE4V2Fb8MxeAUFtdhNoavN7essScQIWwWoRqs
	 j/BFBM5JmmtDw==
Date: Fri, 10 Apr 2026 14:19:21 +0200
Message-ID: <20260410120318.320727701@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 11/38] misc: sgi-gru: Remove get_cycles() [ab]use
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
cc: Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
X-Stat-Signature: 78a69suss88i67jfgypoqyu1z95y6na7
X-Rspamd-Queue-Id: 34834100003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775823565-757958
X-HE-Meta: U2FsdGVkX189WmBvLHr+a0XEriK+8sAu4qvQErgsNozkBic1hQ1yegUthezqnfLH/Wl97KeDuW737yX3trAo5PM3YMxXD5boYQyvSNQ86A3jFzLLkcSsxNyqGWACauewYk5TteX3QZA7gF8mjT5T9WRw28CVdgKVL11lty6u5PAzQinIxAC3C9lex7T9zTLhZNXMx9vbShUkbfuFdNlg9pcgLPPiCSzgMWt+PRogSW3/akM73pqD588eaNxZPYPXXCo8YBwYeYwoSp+SdMAFpz7XYpWrnVzuFgbMKX8HM+GXvKzpFaPRCMpt3p53cl3wM091vjJw8/JR4gAGKO/Eao6C7AcxfoYQ5xQFVT+REEF53puHx14PKu1aTXSyYFZ7xKt6NVl+DRS8IUzqJIzSzZnc/7j+gfcfVI8YdKg0IRneeHinI7lDm2LzYe6WFk/JMriLgrR3RqHdRlIarJo+1qQRWwHyT9WlaZ88hDrIc0sENzXnSWv6flIYDoxVN20R5+U5Fq8Ddz0zohRqS00p3EJYkOIaQhxTxlimxOlfO6FX42z/fJNysQe5H2JRMrz5Ucn33LavqVQ3u7gTurCWFl5cv+O2j+MVYiqOHOXsaPYEYLrAelu9qoSfZDJMsdAu1qt41php13imPYZ7WbN6kzl/omF1BWDaKXD0Ek9EFfsy0eK9cJf150mRwxgsloN/pmXJWp+wiU1tuc349fpZCvXOOYuoAfLqTJr7ULxRoK2LaYbeGMHWQsOIdGdi3YposQntptELa1X7jEsUtxxvMaDevfMs/6AHQRntmTh0wUlb9BmfjhxqwRILyoaJF84H0nvqKcXOT/wAgMPoJBqaYj+vPD5yeGZw2NznH9KjkPTZsiNC3TYGLiqdXcoBhtCVfDPteYak6im0v16BF/ZHFTB/6Cg1zFVhnzaoaj3cqjJF4uW6hclKco+Tf+EmgzrhUtFHqX+SARNg4Gp+D89
 O/9cAIHz
 gaKdkSFwB9fe96ss/f1PeQifykBS335uQfTiHBoeZBUUPUVVm9QqSttPxzGbwlVvvSBXQFL/tRzar9agx5nWRFiFXjU4SayeyoMSMMEbL02/Sn/0uyEzqscXn9WTHQptk58+zTdaAx0Kxqohh0Gqye8POLEwqFbeHafNRt9V85+v6Tb/pRnhdjkjjVCW96JgQe2xgsQqhCNVjpfzsHz77hs5x7ej3WTlGoxlCxMAgoGT5v9wuWh27dbHfmi8eHq9SyH823vfQ8dV3GSY29rtiIQwWcY8VYvhhE1BHX0XXyljzRqj8kBFum3068/vu3a+ziOTHxuU2PelWPdJNsblioM0k4E/nWMYt1FPZVyBqLLaovYBUIjxD2AgPPKiGoioVKybyO3UVzRIufG0=
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
+		if (GRU_OP_TIMEOUT_NSEC < (ktime_get() - start_time)) {
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


