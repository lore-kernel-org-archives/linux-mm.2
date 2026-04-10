Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A38F44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591B76B00BF; Fri, 10 Apr 2026 08:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542396B00C1; Fri, 10 Apr 2026 08:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A476B00C2; Fri, 10 Apr 2026 08:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3026B00BF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F01A21A04F8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:16 +0000 (UTC)
X-FDA: 84642553632.05.84026E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F21280018
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9r3LlHr;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=uc43GoCkDGKCftnS7MZ3OA0khnbsdPYb8yxntAbHoVw=;
	b=A6i+yVhF/S+IxcSlbfj4Ojdo6+3BvWdIGlkpUI61FKKS1U6WGu4RfBnUjYyp4RT0W76l/j
	TWI+cwPnA3jJjPn2UQQCcBXtYqRCZOjeWrQ8BPMTEnC1BMgJZ11N9M2aCUGMOfNoQRxIB4
	BC6k+EGNuYqYksacXqPtV5S2gHhyGUM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9r3LlHr;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823615; a=rsa-sha256;
	cv=none;
	b=yE3anoNQpdEiPUZoM7OtjoI/CzYRLMq63cmYJA3diMw4l5DE6Doac1uzLMTFvPqnew7lOS
	pb/E6+ns2tTic+vnb54hAQ062IwKzpjo5P1yxrDGHg6cpTzKhHgDXB5ibUZpGATHwBh79e
	GAVA9C12NsTcpBO1zMxs6yg8F2tAEM4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFCF56111B;
	Fri, 10 Apr 2026 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C840C2BCB0;
	Fri, 10 Apr 2026 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823614;
	bh=fBmKDE903B55aOazdk1fgTYrHTdJzb3m7rYXj49+TyY=;
	h=Date:From:To:Cc:Subject:References:From;
	b=K9r3LlHrTcCOkcDztBL2sK/tQ+yi3dZzcdFnxujOK2CvaNmPXdlKrSDZTOaDJVW4S
	 4mOX2OGTBKQ54SjOZcfKwdFhqUqz7KSUNqnVJajtIbXp/GGLFwlU7bEb8zVF3NgHwH
	 1PaUWksbUVEp48mOHI3J4/UWYuvo5lLJzmYA1j3FTzptfyaQ68k1o579nPzwBiXUsC
	 3DfIec/NNOEw9ut9tg7BENSlBdgvHCyF+4+WEDfTHmiMcBanB5cN+csJSB4d+fA+Ka
	 C4Vf48Goy0kDdmbaemETnL+HfFRh1XMMUZS6QyYOK2+NJ2yf87fs8P9lxl4UXibsda
	 2J390A/pMX1Ag==
Date: Fri, 10 Apr 2026 14:20:11 +0200
Message-ID: <20260410120318.997202495@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
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
Subject: [patch 21/38] hamradio: baycom_epp: Remove BAYCOM_DEBUG
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 6F21280018
X-Stat-Signature: 9wrbin8fe56ga78bcqmpemrh68fx8ms1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823615-192891
X-HE-Meta: U2FsdGVkX1+6BaPsKaZLrWipfdNkb/A7YDuJzEzipIsJ1ztotENoidzcpDh340vkUAeej1yCUSZ8J1SAEW9sCNNXBO/kP8lZNJ+uxhh/5HVtnWjchIEout0T61MdsTirj9CHIkDyVRQR4glELfg+bvzWsqs950fL3tBxuiF9q+b+gru3a8wCLufqz9foqSWlq/TdcFlRTM0GGkOxsPjeOz5026TVmkoHBQU1pdZf/j/VCGNv5265vUOv9GxqEubR/oWeDWo1AmDdITZeNzKOfbU/HEjw/NAUcxpbGg2eQJMHoumpI0Tegpk2ySNr8tTmsPPG6RS9A9Qhq4K95aS6L5kQPj2AiFZnrBxpdWVh/ABsPU/tW597/7VPq+YfVlH+4/47Pc9OpmeI0bCUdBqUohz0llQ1hD7emJ5mqoWynkUaVtllvTks2s6IdG4m4rHPMnDHSmqW1yymoYMuHAkz6FQZ9ae+Zo/0yey0LN5MWnYCFVlKtkbgkZ94JfiMPR9NlKLbMwylU/xFrFRYv9LUjVlzdWYbT1j+fQzyKkNsZDx2UU/49RH1f22M0PRfyJx7/DBMVxstQzp+9CNPa+YUwxOEJmzoqapUJis/nod/45BTtbygJ9U4aYGnxYzEFFHfm8g6YTPd0+Cf24ahVLY7/SADNQgA1qNZDwrTHAMicgjtIVtZrdBur83u6HTZ9+6+jufSRCnlYQs/qrCUnd5BTdnAk2wsTmwTFjuneigY/3OQhtx3/zIWYJU9goqCQxyNpycW37MHKKh7J2c5PKZGrPfEsaZXNOaPUOwmjISj3+Pxpx0CAPnvMCIHtRVt4FttbwibLNOkEDfSnkzSv4J6LWk5gFAQIRqRtNsSG4bbBo00jV04+zxcoMuowPkFlkpt98nUPTr81D56vU39XafDws1gKfDwDgLZaQwm3c4UMqItIMHTp0wJZmOeZxlZkExzJSUJFj0AySZxSfdCq0T
 HMIj2MEh
 AqSyFsuJ5x5zlMcvfztZjtnQsMFcZlDA1id58na8UL4Do7eQoKnPCG63xKZv/5HKhwt3+UywJXB2/clDLTORT1ursVtQCDeWDYIUZNeounksUBQS1R/XPSVxzWP4E034Azy1wN+5fgCHJJFHD0Jj+POgkpRM7euvSrp90Lnqkk8hVJthoiYWns4701KJV0O0AhXg36QNy4gnIzEwkT80MgJ87wuFuJc4btQp9RqPF35npbgsYJkqzOAeJPHqsXdUcLdHqtbtzamjjBLBIqr5R5Lm5oMHd0Nh+kxzAfL66octQpjlAA04pD5GZuP1WAX+Mdwyroo7Nm7MpV+y4TW+0/M8Lde9psmLJCJbI8qde4h4hcR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The whole code guarded by BAYCOM_DEBUG is only writing debug values into a
datastructure, but there is no way to ever access them.

Remove the pointless ballast.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-hams@vger.kernel.org
---
 drivers/net/hamradio/baycom_epp.c |   51 --------------------------------------
 1 file changed, 51 deletions(-)

--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -44,7 +44,6 @@
 
 /* --------------------------------------------------------------------- */
 
-#define BAYCOM_DEBUG
 #define BAYCOM_MAGIC 19730510
 
 /* --------------------------------------------------------------------- */
@@ -191,18 +190,6 @@ struct baycom_state {
 
 	unsigned int ptt_keyed;
 	struct sk_buff *skb;  /* next transmit packet  */
-
-#ifdef BAYCOM_DEBUG
-	struct debug_vals {
-		unsigned long last_jiffies;
-		unsigned cur_intcnt;
-		unsigned last_intcnt;
-		int cur_pllcorr;
-		int last_pllcorr;
-		unsigned int mod_cycles;
-		unsigned int demod_cycles;
-	} debug_vals;
-#endif /* BAYCOM_DEBUG */
 };
 
 /* --------------------------------------------------------------------- */
@@ -259,26 +246,6 @@ static inline int calc_crc_ccitt(const u
 
 #define tenms_to_flags(bc,tenms) ((tenms * bc->bitrate) / 800)
 
-/* --------------------------------------------------------------------- */
-
-static inline void baycom_int_freq(struct baycom_state *bc)
-{
-#ifdef BAYCOM_DEBUG
-	unsigned long cur_jiffies = jiffies;
-	/*
-	 * measure the interrupt frequency
-	 */
-	bc->debug_vals.cur_intcnt++;
-	if (time_after_eq(cur_jiffies, bc->debug_vals.last_jiffies + HZ)) {
-		bc->debug_vals.last_jiffies = cur_jiffies;
-		bc->debug_vals.last_intcnt = bc->debug_vals.cur_intcnt;
-		bc->debug_vals.cur_intcnt = 0;
-		bc->debug_vals.last_pllcorr = bc->debug_vals.cur_pllcorr;
-		bc->debug_vals.cur_pllcorr = 0;
-	}
-#endif /* BAYCOM_DEBUG */
-}
-
 /* ---------------------------------------------------------------------- */
 /*
  *    eppconfig_path should be setable  via /proc/sys.
@@ -621,13 +588,6 @@ static int receive(struct net_device *de
 	return ret;
 }
 
-/* --------------------------------------------------------------------- */
-
-#define GETTICK(x)						\
-({								\
-	x = (unsigned int)get_cycles();				\
-})
-
 static void epp_bh(struct work_struct *work)
 {
 	struct net_device *dev;
@@ -635,21 +595,17 @@ static void epp_bh(struct work_struct *w
 	struct parport *pp;
 	unsigned char stat;
 	unsigned char tmp[2];
-	unsigned int time1 = 0, time2 = 0, time3 = 0;
 	int cnt, cnt2;
 
 	bc = container_of(work, struct baycom_state, run_work.work);
 	dev = bc->dev;
 	if (!bc->work_running)
 		return;
-	baycom_int_freq(bc);
 	pp = bc->pdev->port;
 	/* update status */
 	if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
 		goto epptimeout;
 	bc->stat = stat;
-	bc->debug_vals.last_pllcorr = stat;
-	GETTICK(time1);
 	if (bc->modem == EPP_FPGAEXTSTATUS) {
 		/* get input count */
 		tmp[0] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE|1;
@@ -673,7 +629,6 @@ static void epp_bh(struct work_struct *w
 			goto epptimeout;
 		if (transmit(bc, cnt2, stat))
 			goto epptimeout;
-		GETTICK(time2);
 		if (receive(dev, cnt))
 			goto epptimeout;
 		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
@@ -700,7 +655,6 @@ static void epp_bh(struct work_struct *w
 		}
 		if (transmit(bc, cnt, stat))
 			goto epptimeout;
-		GETTICK(time2);
 		/* do receiver */
 		while ((stat & (EPP_NRAEF|EPP_NRHF)) != EPP_NRHF) {
 			switch (stat & (EPP_NRAEF|EPP_NRHF)) {
@@ -734,11 +688,6 @@ static void epp_bh(struct work_struct *w
 				goto epptimeout;
 		}
 	}
-	GETTICK(time3);
-#ifdef BAYCOM_DEBUG
-	bc->debug_vals.mod_cycles = time2 - time1;
-	bc->debug_vals.demod_cycles = time3 - time2;
-#endif /* BAYCOM_DEBUG */
 	schedule_delayed_work(&bc->run_work, 1);
 	if (!bc->skb)
 		netif_wake_queue(dev);


