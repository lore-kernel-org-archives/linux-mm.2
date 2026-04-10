Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D01F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05AE6B00AC; Fri, 10 Apr 2026 08:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB69D6B00AF; Fri, 10 Apr 2026 08:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4FD6B00B0; Fri, 10 Apr 2026 08:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C603E6B00AC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FE711404FA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:32 +0000 (UTC)
X-FDA: 84642551784.26.F9AA8AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E3FF42000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bpuk5rSR;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=AhOSzTxD+cV4MqoaDbRxHefm2I22dte0YETJ6P0JjKI=;
	b=mIfusiu8uqdyn+K0nsb6BzUejPtAd2Q8T+oMwkUs7Ap03I7G+Ag4WgN/mlcseiB+ztWhIz
	CWKrKZHaZ6I25zolVOHGOSVMH+bdRHfE/2C9tX3Z3++La45CvVRmH5lNciq7GXmaHjVR0r
	Cg8efwn/p4yBshI7/uKnI9w9cNbQeeY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bpuk5rSR;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823570; a=rsa-sha256;
	cv=none;
	b=R8s8IsdoNqr4wj32pd7Wpi6O0OlG5iQOO1dZ2Y1K95g6sUF9YwO4jSgdyRA5UTG34foAZg
	FNnV6WulHhuEDIil/3ZnewyX1U5s+8aGv9DE/P24DNo8MTLq4NctAF/aVhci+NKy86I5L5
	QIFQMqTsutd9M/yk0lGo6JIy/1wAQkQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A166091C;
	Fri, 10 Apr 2026 12:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4F4C2BCB0;
	Fri, 10 Apr 2026 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823570;
	bh=gx3RztExl/RgjhE+RVjeBSM72TbSvLK5CUYrt3EY96I=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Bpuk5rSRR/rs1jSmitZH/KfJL+3TNuP+dz9xwjVC8e1YVix0oW3s2Pp/y+L8X9oHD
	 FfGXk8B3TY0jbEAZNS2FVq5qwscSTPNozRdmP6S1az7QsSRwh37CnHDegYmWg/dUhl
	 oXkQ09dlNxtpDlZfCfFVBtb5yeQYcj5dZxd8vIShSLkbr1gWWPlcdAHe/FZpu8mplV
	 u5Y93dLHQf7k/6QZkYgksDu7FYlgnX/m++LNPEYIEnDd7dRmUlTkWsJQwVidroG1Bi
	 MdGUi4KzTqg9X+Zn0ce3HiuHIaE9YE1XVzPbK1ak8XvacDL5nVhYnRULjmYf5QSMQ0
	 DvaPTMl303Xmg==
Date: Fri, 10 Apr 2026 14:19:27 +0200
Message-ID: <20260410120318.386500288@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
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
Subject: [patch 12/38] wifi: wil6210: Replace get_cyles() usage
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: 1ocf33xs9qwuuzhzkp97tyicajbarsbe
X-Rspamd-Queue-Id: E3FF42000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1775823570-633350
X-HE-Meta: U2FsdGVkX19+ntuiD6YCMTTfre26RQ8WSocnHVTM/klVkDhwtglBxd9kePKmt+6/gtRd5G7wqgKOjW+tPphdRUlyEcz5+70cVMqPBIR2H2NAFq9gGd7HBzRWC7qBdjSwl2Da7dk/FslVR2M7pHOxZLucKe5Tpsa5IwLjHSwGSKYNbraQO+N79b15o4GEKNJc2hZBWd1o6u6bd1cPD3HTiAEvW555LtG7EqjDGjnCb3igCZmhLINHpqTI4MlPctx9H4ETgp9ot6Kxkfhz9//prdje9viqDwMFVXyCZzgfnCDFY0hi/K9ly7XYOby6AdUpKq8m1dCWba5zAvJZ1vwdcL7duZhL61SksL93rOVD0IjBeEB1ayxRau0rvoAveux4G8QHElRAZXV4JpRWfJMAlsjJIpovltmi1PRDDwr5p01NLTkekeq1iFr+fTUvTHRzElSOULlLo38nPaW/rSF7mK0kBA44EmonXOMB3dq8gqOdt9U9Z4FD0r5mwHm2pgenn0GuI7kmnN7JfkLbGH24+y2i5Xk5Nmxy95KdpqSgyFF0uD4hdeD56S5iJEXgHEN6XNDJwJI8jyYOj+5vuQrhPGzbO8npguKJ1AcqnD1ArDI5FQ+ZPNB5c3qkrEbd+UI6455Kpf5zZvhaLTwIbx2HTvdz2dvoDjgMaKLjikO0NPaYLdYx4EuzssB8AYWhD+gQcvzFlI936E/h83kxWMQm1UOw0KvxEmejnngRYg4IxbCf0yev94IgyB/jGD6KyQYISgwH7iSBCA/YFhKPVIV24i/oXz7Tss91Yj8bsREzHAm4nmuWj/F6sLOR9fi2CEUJryfiTvAedrn9NpwfXOJKx8rYmRL3nQm4JWZ5fgq7WjjSlAR1VpIJDRbxs6uTYe0ptHGYhzFwpMvUQ1/A4veNHx6pymBnSE9Obami573VsfcGzAFV7EEh3eTlmleMOvI29Q5nnOVsoS4xGbugglm
 k6njaOus
 FM0guwvgQDE+aHyRBEyklR8JzmXYJH0sygNy2D7wXDPhrji8B/HSSQX/axZfq7LzsUFOTgtJ6lRD1ZjK4IUQflLiWgVEDCHqK8u9WhsBnWxzCHqK2EJ3Lo12S2jMit3rcCjwkVIrHcInNW07QbailbgQCYpRUw+ByCUfvIvTCCINP5I6KAk4tmvVdJxrbyd/UGg1807aVaU9zbaaLjPQy3MAQMrMawzz0ojD6EGJ1Si5UoVZb730JY0yTH57P5CK0YGuR/qVQ2COK1VURkJbbgLYe+bhBAcwMaFnOcXESyhFjPED8lY3OWNgN9/bgqLqRXNye2lplGPbm25QZJnlt41xga+ooVgk3yvRxBB/Z/OCwg8+VMuyQzCmPF6Kdj9jrMxHFQvIL4SdfBko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason why this debug code requires to use get_cycles() for
timing purposes.

Use ktime_get() instead.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/wil6210/debugfs.c   |    2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |    6 +++---
 drivers/net/wireless/ath/wil6210/txrx_edma.c |    4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |    3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -151,7 +151,7 @@ static int ring_show(struct seq_file *s,
 			char name[10];
 			char sidle[10];
 			/* performance monitoring */
-			cycles_t now = get_cycles();
+			ktime_t now = ktime_get();
 			uint64_t idle = txdata->idle * 100;
 			uint64_t total = now - txdata->begin;
 
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1976,7 +1976,7 @@ static int __wil_tx_vring_tso(struct wil
 	used = wil_ring_used_tx(vring);
 	if (wil_val_in_range(wil->ring_idle_trsh,
 			     used, used + descs_used)) {
-		txdata->idle += get_cycles() - txdata->last_idle;
+		txdata->idle += ktime_get() - txdata->last_idle;
 		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
 			     vring_index, used, used + descs_used);
 	}
@@ -2129,7 +2129,7 @@ static int __wil_tx_ring(struct wil6210_
 	used = wil_ring_used_tx(ring);
 	if (wil_val_in_range(wil->ring_idle_trsh,
 			     used, used + nr_frags + 1)) {
-		txdata->idle += get_cycles() - txdata->last_idle;
+		txdata->idle += ktime_get() - txdata->last_idle;
 		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
 			     ring_index, used, used + nr_frags + 1);
 	}
@@ -2531,7 +2531,7 @@ int wil_tx_complete(struct wil6210_vif *
 			     used_new, used_before_complete)) {
 		wil_dbg_txrx(wil, "Ring[%2d] idle %d -> %d\n",
 			     ringid, used_before_complete, used_new);
-		txdata->last_idle = get_cycles();
+		txdata->last_idle = ktime_get();
 	}
 
 	/* shall we wake net queues? */
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1286,7 +1286,7 @@ int wil_tx_sring_handler(struct wil6210_
 				     used_new, used_before_complete)) {
 			wil_dbg_txrx(wil, "Ring[%2d] idle %d -> %d\n",
 				     ring_id, used_before_complete, used_new);
-			txdata->last_idle = get_cycles();
+			txdata->last_idle = ktime_get();
 		}
 
 again:
@@ -1499,7 +1499,7 @@ static int __wil_tx_ring_tso_edma(struct
 	used = wil_ring_used_tx(ring);
 	if (wil_val_in_range(wil->ring_idle_trsh,
 			     used, used + descs_used)) {
-		txdata->idle += get_cycles() - txdata->last_idle;
+		txdata->idle += ktime_get() - txdata->last_idle;
 		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
 			     ring_index, used, used + descs_used);
 	}
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -14,6 +14,7 @@
 #include <linux/timex.h>
 #include <linux/types.h>
 #include <linux/irqreturn.h>
+#include <linux/timekeeping.h>
 #include "wmi.h"
 #include "wil_platform.h"
 #include "fw.h"
@@ -632,7 +633,7 @@ struct wil_txrx_ops {
 struct wil_ring_tx_data {
 	bool dot1x_open;
 	int enabled;
-	cycles_t idle, last_idle, begin;
+	ktime_t idle, last_idle, begin;
 	u8 agg_wsize; /* agreed aggregation window, 0 - no agg */
 	u16 agg_timeout;
 	u8 agg_amsdu;


