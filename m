Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9FDF44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7AB6B00B5; Fri, 10 Apr 2026 08:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5681E6B00B7; Fri, 10 Apr 2026 08:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457D96B00B8; Fri, 10 Apr 2026 08:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3108F6B00B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0075E160389
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:53 +0000 (UTC)
X-FDA: 84642552666.19.06E3E63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F4A640006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okWRwWiK;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823591; a=rsa-sha256;
	cv=none;
	b=w9cumjAwFEC5QAqmYDLvNxXQ3DA+skH09stPpzc0f4tDA3o+b9uAxdbsHMq6JgfycisQmH
	TReb3/nZHZd+PJrd/JWNS/AKVo8PEAl68yeM87HZ7V/g1/gyKSeUZ0Y/HJgu3ifMBq0nIB
	5U+60JdOWEFafNpEKVz3WRpD+0BDML8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=u2KrsjOZZc+bQEPw3J7+YcyUcAZcAFTN5sTexf8i1No=;
	b=E6g4lGavpb41Rd6Oo0AtIYHyhEBOYgRqN3Q0pN1XBh8Tae57Eqz0mZ0szXz51FV33JR1o3
	Ag1ZdtHVgy17x6gSAFU5PmeVsYEiURWfDzXv/JV5PDYU3m2xXW5iZYU9tu7f85n1hpX8Sa
	e5x57b7dw4HVpaozjnvAf0PP34fddJ0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okWRwWiK;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7208F435AB;
	Fri, 10 Apr 2026 12:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704BDC19425;
	Fri, 10 Apr 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823590;
	bh=r17Pe0N1ahBhrB3JYh2nj0lozuwWxFWE8s4wbHnNz1U=;
	h=Date:From:To:Cc:Subject:References:From;
	b=okWRwWiKRXWxIOYd0Peg6lhswEXmgs6TDBmjhAnD7Q9a6usCqNg9OYWu+roqFftQt
	 CXuq9wugiKbiMxTD+p64hE/DfyXI2OVOyYyt+MQaYOMvBz3HQvYNGX8W9+b4gE14hU
	 1DViHL5lpk9k7rS0TYmec/vPv8+l0l72HHkjevm3yaDtlLwCxfiyVTiYsTY5w9OTh5
	 Ju9iD//e8k54q8KUH3ojDg3WjR+Vu3B/cuQgNtmo0Zn1MW3hNX3wOdJ7kCRM+fO7Bg
	 3Yz29lBDAALUYxAqFMkB8dpm5Y3XPhihE7EzHhldnKqOW+zQ+3nRrzSdk9MbluRvBK
	 0NZT2IviOMPvg==
Date: Fri, 10 Apr 2026 14:19:47 +0200
Message-ID: <20260410120318.658719117@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
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
Subject: [patch 16/38] fbdev: udlfb: Replace get_cycles() with ktime_get()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F4A640006
X-Stat-Signature: qkizay417da5imn7np6yhhgafm5iu1gz
X-HE-Tag: 1775823591-390339
X-HE-Meta: U2FsdGVkX1+xw1XC1SRsEnKpDvjY+3AVgjEmivSGboU4B1orwi6QsClDY3S+NRK9gmc8SDI17r+27MyUdPllKGYps0DvNRnHaMEOxWgfXOXwpOrYAh8FEuIzDZ/RR3js/TfQDEBYiilppLITWjQlLBJ9Web3kVcTip2Wua7wrLiflElm/PemVMBSuqzl6YIzQv/KJca32EcnMxDLPRYAfRMr/KeMD0wmz+KTvJPo/i69w5RpYnGAkW7N/6mSdF24M90MpMH05ba42+U23D1cUkzKfoWt/SDhBfleKGcppWrZauMKu1RzU6pL46rzpzTHpUvBJbYVGkfmR4GsN1RpA4+zve7/8WxMkG5SgBpDf4ddM9t5J6FVpABRdJE/bOUqcxaeI20WEcMriGyWrpyWMwJFWszfJA9XuEPusLc8/Vru49I+bCAWfQifBs42AJZ8EUdBIp5kJFyDfiGbP8T8nmyZkwo1SUw1sRX4fc/s3myX+xdAEOd0zOKB0biGdaxbWjnIJwXX/NqCe32heoFxUKizTuRMqAfF6UkOG7IiBddQNtdXk3CnKu98q2Z6NGqDmch8KJdT4P9w8UF1awLOdFcIFXdonX300zgqMHmACBB4tE5rVP9WRXeEvqzFUAwr2pQ+EI7UjZlbEB+j3myMUF4fxOCbUAPy0YRMYYqa+VRSc3xH7wmrfENHdkGv8w9Flg/ycKApHTBPKFUghMW1m6q/Y4e2FcSl8i824Rzak+CVkHu0W8V2FdSIXTNyQXp8wzX8xJcL4Qqcbn8PFpXpyKdLB/XYvPW5a5iwZyAyBMv3TyMvQz3Q3+AV/FJhvbLK4tsQUp4T3YwSejDRtp4FnLcuPH39P8DF9inDt7qLLZWxi1lG0AHoaD2SfEj4/aoQqom4JL6ft/hCvhmw6iesNqrzHRhCS0H3wPceAyqtVwQBmVUmuOr+B3OZ9L5/49WzbmFPcJgVucEaOJ2pnqk
 PsfIonSB
 +RzFdtibwuGK94TwIjIQSl4KsoTg6qJljJv1aKGK2mleKGO2h9h7kMEvuAwiNoI3Sxtvzmj5yBgi3cLKPKzXfyrJlVMsZ+tOWCou34qWc2umnJhwfhD63IOZdKIud352JbZSUkQrbsZa2+IeM2qscwuH8DeQx1G1JbA0XbMAiSTVywSq5E5oIVK/LaMi5Fx2N+ytAiVyP1Wfd6+V5s9iFivV9+kq/1L4juvifLa7a+TEaiGAUoRbx/sN1H241ZaQIKDMw7yInOhISU2B5mRZxHmarAwBsnteUl+eNk3TH6SS4aKUTpe8UZlJEzY4wqobhz+UIxfKtIuTLCilovotbpNeybAdafAswaBwJxyVVmTdT9j8rOa9geB5EC8svlEyJrleiVONb+MWiVbxT1GBEkSsdcvpzm9zZZ3pzlgeMLyUd9tyvGAenMiBEsSOBAPYAaOuv7VdT//O9IVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These metrics are not really requiring CPU cycles and as those are
meanlingless when the CPU is running at a different frequency, this can use
ktime_get() and achieve the same result.

Part of a larger effort to confine get_cycles() access to low level
architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Bernie Thompson <bernie@plugable.com>
Cc: linux-fbdev@vger.kernel.org
---
 Documentation/fb/udlfb.rst  |    4 ++--
 drivers/video/fbdev/udlfb.c |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/Documentation/fb/udlfb.rst
+++ b/Documentation/fb/udlfb.rst
@@ -156,8 +156,8 @@ metrics_bytes_sent	 32-bit count of how
 			 USB to communicate the resulting changed pixels to the
 			 hardware. Includes compression and protocol overhead
 
-metrics_cpu_kcycles_used 32-bit count of CPU cycles used in processing the
-			 above pixels (in thousands of cycles).
+metrics_cpu_kcycles_used 32-bit count of microseconds used in processing the
+			 above pixels
 
 metrics_reset		 Write-only. Any write to this file resets all metrics
 			 above to zero.  Note that the 32-bit counters above
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/unaligned.h>
+#include <linux/timekeeping.h>
 #include <video/udlfb.h>
 #include "edid.h"
 
@@ -600,15 +601,15 @@ static int dlfb_render_hline(struct dlfb
 
 static int dlfb_handle_damage(struct dlfb_data *dlfb, int x, int y, int width, int height)
 {
+	ktime_t t_start, t_delta;
 	int i, ret;
 	char *cmd;
-	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
 	int bytes_identical = 0;
 	struct urb *urb;
 	int aligned_x;
 
-	start_cycles = get_cycles();
+	t_start = ktime_get();
 
 	mutex_lock(&dlfb->render_mutex);
 
@@ -661,10 +662,9 @@ static int dlfb_handle_damage(struct dlf
 	atomic_add(bytes_sent, &dlfb->bytes_sent);
 	atomic_add(bytes_identical, &dlfb->bytes_identical);
 	atomic_add(width*height*2, &dlfb->bytes_rendered);
-	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
-		    >> 10)), /* Kcycles */
-		   &dlfb->cpu_kcycles_used);
+	t_delta = ktime_get() - t_start;
+	/* Avoid a division and approximate microseconds with shift right ten */
+	atomic_add(((int)(t_delta >> 10)), &dlfb->cpu_kcycles_used);
 
 	ret = 0;
 
@@ -727,9 +727,9 @@ static void dlfb_dpy_deferred_io(struct
 {
 	struct fb_deferred_io_pageref *pageref;
 	struct dlfb_data *dlfb = info->par;
+	ktime_t t_start, t_delta;
 	struct urb *urb;
 	char *cmd;
-	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
 	int bytes_identical = 0;
 	int bytes_rendered = 0;
@@ -742,7 +742,7 @@ static void dlfb_dpy_deferred_io(struct
 	if (!atomic_read(&dlfb->usb_active))
 		goto unlock_ret;
 
-	start_cycles = get_cycles();
+	t_start = ktime_get();
 
 	urb = dlfb_get_urb(dlfb);
 	if (!urb)
@@ -774,10 +774,10 @@ static void dlfb_dpy_deferred_io(struct
 	atomic_add(bytes_sent, &dlfb->bytes_sent);
 	atomic_add(bytes_identical, &dlfb->bytes_identical);
 	atomic_add(bytes_rendered, &dlfb->bytes_rendered);
-	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
-		    >> 10)), /* Kcycles */
-		   &dlfb->cpu_kcycles_used);
+	t_delta = ktime_get() - t_start;
+	/* Avoid a division and approximate microseconds with shift right ten */
+	atomic_add(((int)(t_delta >> 10)), &dlfb->cpu_kcycles_used);
+
 unlock_ret:
 	mutex_unlock(&dlfb->render_mutex);
 }


