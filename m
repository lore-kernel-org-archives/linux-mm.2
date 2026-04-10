Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0491DF4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC786B009B; Fri, 10 Apr 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C9B6B009D; Fri, 10 Apr 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3446C6B009E; Fri, 10 Apr 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2321E6B009B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:18:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE348C1DA3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:53 +0000 (UTC)
X-FDA: 84642550146.01.BA57292
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2330014000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C95dlBh1;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C95dlBh1;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823532; a=rsa-sha256;
	cv=none;
	b=Ce3VLsBbuZu3tdiXFCxnAMSbON9wukDU/h2s1am1vjRBHESu1Rry2VzTxOh3/pSyDs5aBY
	N3uq4RA+kqOZuq+n9HdzjewhKHf/sN5x4NWdu6G1hCiv1f1QDsmVZtGkmNFcfNz7B7KDH4
	OvLvzyiZLriq8paARmNfhnUwqu+xE8g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=YQzJkFKLTggwDr4aZ8p5K5IXIPCjwwK87RXbOM/NyyM=;
	b=n+cpBGR3JUKOhy9QchxqsX5P0adZ03CT2nXOlAyzgB1pi9uW+jfB/WY8l3uZr5U1LDKsqn
	cF792HIW9CbYJgELH0qs1jwvdMPC2nKV6/J4hYBCkFKP5HRrtYZBAHz+0AxIIdEuzmUc1R
	U8GViLor4dZSNqPj9LmI/zGYzhykITE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E54A42A40;
	Fri, 10 Apr 2026 12:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41928C2BCAF;
	Fri, 10 Apr 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823531;
	bh=d9g4tptgi4bHAMeSUYU/X2RKjwFUxFqrN/mhP3KVNVE=;
	h=Date:From:To:Subject:References:cc:From;
	b=C95dlBh11sE1EDcg7WkfMi8fo/Gu65tTzE/T1Srv47O6KGVj91UAmlXjU/FculsKY
	 awynI69i3I7OzFyIZRoLHG74aENkFw6rGItybhxSqe437lYLBTdjTVnjO/BdcaqFmm
	 BXfUg/n2zRCzaQYn/z/fsuHLl0WmkcWVFMRkJhLQ5RkhTFRVvrz/UodergNNz9SIp4
	 BVs5UNoonypUPXLwnttDKrM12mG46vN5EiYmDA6MeZqU6JoMxzzH1xMf+HYNN+Suws
	 7vEfC+JysbP6o62RQk33gA7qFJeSKzf6pdk/9/gi1eWOgpyfVkfoVSPrkQiIoyiqxd
	 pjPaBhdVrzMKA==
Date: Fri, 10 Apr 2026 14:18:47 +0200
Message-ID: <20260410120317.843419270@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 04/38] x86: Use PIT_TICK_RATE instead of CLOCK_TICK_RATE
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2330014000B
X-Stat-Signature: m364nktpohiiw1azbqiakf7nuwg6ohdi
X-Rspam-User: 
X-HE-Tag: 1775823531-368421
X-HE-Meta: U2FsdGVkX18VscdCgQmLHjIso66DVzR4xdUMtZ8yjRVjq7mTyCmAQNnKp39OUC4UF200uTd9KZG6XwAvMHuHuwFAN+UH6G6PW7xEIZuXeEPLPR4yOw1rxI0MWeg5WZanStC47C4QbGEhTPdX5FRVMlgSGIBr70PeCGvVGbe5SP0wOXEiQKZKIxspD8tUO/VduC+5+/yBBZGsU55kO1v+C6Nlnqq9HwIOS0/iGoT9hLGPTueYOkw59f4xnC2yAcplj1YOYre2wZU4LzkIpIIow60MyY+mYZl+pDfB6oh6qlR5M4gfuFuW8wiGhaoW3JnpwJHbKWqbydbthEaHU2i7EP1Rhy14V+h6aJE4IfxChTuTd6CFWuZB+7rMxkJg1LfLz5hXoRvLdRQ3+zPLz8/uqN+RoHIY+YU28obAP6B3L5Fbqe/RSIbpRMM1zL/SWJVrDsu01i25vJ9lIy9YlZ+X4tBUmt7EP2bBvc4lbOVyP5ihJQmJroyD3nk+F7z8LgcIHbF4v5cagUL3w1zl3HYN8/oyIeBDAtATtKnbuE8dt6lUaNLEQqY/zuzG0Aa8x80Vlk/6fCLSp9DjLgSA8BKpNHGzBdVr7+dfwaeCIL49hCursuhdcUg0BEIV5G35EIPQwYCQnmadPn9NCLQQqLf6SLhqWY96g9Z1G3R3X0RZx5a9AHutpkj6efZFA9nCBl18Qp8ayZ6voCaRH8iejJa0l/B/fw/RsNO5RtPXzPJtYaAquKs+7g1ydOjZSIi4hLKiTRlp6vESQoh6qFC3XBlmILINuvSR0un8z2hTP6ZZ/NFCFZTS09tLgCLb7ObleV1WelQPnG0aEoOB1f5gJxBgHHvh0cLLejY9Wnvf7LmnqkZKA3mag4TkZKGjBmeIlHpI76Ic/YRy/3XoJLAuw7JWIPsRIC6pw5Gtc1XCR3SISqII8uJdC3IKQiY49PrHGOltPwQaAWunDDuVwtF/tw3
 kJ+IOnSS
 BuHG3z7zxBIXITp2GOrlN4VH8/1jwCFe8kNYVnqerZ8E+X6sTkRNSILh+faQ+jTa0U5/zfV1/qjtmnIueUKCYjQgcULvFrNs9u3bJ09pxOKXLmY8eUJF9kmuwSwFqHrdv04LduNNkmOgPvy4FXtJQXpjcXR9orDKfTDK9Q9sAFNIFWYF98zK6qZW21/f5BI6+1x3uNAr8GMVHUznL84tTDgqsNLC+Tf4/LeUOv8f4PFbF1r0nvIJJ94DUAorpTZ+JPA4tfGQCuCSXurXFRe/pAcedL3MVY96ZVeHUnv9fF6/5ln1+R/wWfuSpk6AFTIUD2XqgDO0BAmaTpjCuocIvXrZJoS0oK4aXCWG7BeR9WJXg/10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CLOCK_TICK_RATE is only used in x86 but defined all over the tree for no
reason with comments that it's scheduled for removal for more than a
decade.

Use PIT_TICK_RATE for registering refined jiffies to get rid of the last
dependency.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1268,7 +1268,7 @@ void __init setup_arch(char **cmdline_p)
 
 	mcheck_init();
 
-	register_refined_jiffies(CLOCK_TICK_RATE);
+	register_refined_jiffies(PIT_TICK_RATE);
 
 #ifdef CONFIG_EFI
 	if (efi_enabled(EFI_BOOT))


