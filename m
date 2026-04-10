Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625FFF4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95FD6B00BB; Fri, 10 Apr 2026 08:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46666B00BD; Fri, 10 Apr 2026 08:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7466B00BE; Fri, 10 Apr 2026 08:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D39D6B00BB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60740E3073
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:07 +0000 (UTC)
X-FDA: 84642553254.05.2E4E7F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA82F16000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SQFHopbF;
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=SzqmkoHD6RR/VnMu1Lp5RPrviQ3U1+g7qyWPaG+gRfs=;
	b=AefxxbaKZ0pEy3CZQ09BIIsX47M5N5TQWCUEELIwQ7kV2Ej9jCwj4OhMWgmyvWDgpDNFr2
	OsywVVykefcU5mIuahb6pO4z7hNS76kGzIkTg/5CZw8VhJlswteXUVgK3QvjvKhcIpA1zL
	Q/ak10iD8S/jUolY/YumxkftEFv/CKE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SQFHopbF;
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823605; a=rsa-sha256;
	cv=none;
	b=KWE0Kd78d3mRZEvUlPiIpWiZBnEJJ1jQ4jM8+a7cD26CTitZSSOztRO0V0Vc2D48T0L/bU
	sLi2r4Og+gRU9VMtAYfePv4to5OazDcPPqrJ9CENAmwZaVU4yj//z8eoqybtaLkOTNYuQC
	TpMQ2AzIqztSd1mfLb4JW7WgTe7FQcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D8F661332;
	Fri, 10 Apr 2026 12:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1939C19425;
	Fri, 10 Apr 2026 12:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823604;
	bh=OJyrwmrX6lIri0LIdsFu5GdqSG8VG/nHQeslgTl5R4k=;
	h=Date:From:To:Cc:Subject:References:From;
	b=SQFHopbFA4avzkQltPCDvONKOyWmV73pxkcg27G4tKW1mNfy7PYVk0h6FRJhlowhk
	 TQQGbFN8xcNa+loyfTw/Ao/LMW9fb2z9STU9hSKk0Q9e4TyhUmpic8YPBLcUkWvS5H
	 AbfS/R5YsMQyaoKc/WDlm6lhBx4bXYBfs3B4LA3Z/Y/SjzAwbFrEIx6rz/PfITLKPl
	 d1tT7WhENbDQpyhAelqaE4x97qqSWFBpW6gFyL/Wzy4bWcES9cochVgZgvdNMg3UtL
	 W9F79+f3Gx3pjpImzUkKb/YiEF7KogJM+PPf5Wjs2H8jaVYTBcG1Ittd3E5H9zOpng
	 +M493bQX3+83g==
Date: Fri, 10 Apr 2026 14:20:01 +0200
Message-ID: <20260410120318.862164111@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
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
Subject: [patch 19/38] kcsan: Replace get_cycles() usage
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: CA82F16000A
X-Stat-Signature: sa4iejnddcuoq5qnd79dja8a1pbznfrh
X-Rspamd-Server: rspam06
X-HE-Tag: 1775823605-951899
X-HE-Meta: U2FsdGVkX1/5RTDI21G/wTj0WWfQx4MXrVKwd6A/o/HIYQJff8z2Q2lFyRwrxjaGpfHxE976nfEIXLy2tZTIj2UPjvxOoPgom/NOFA6HwPsyaZgUVgXqKAizYaVqsy56TCb+R4gEo2wEYH68C/UE5zAV4hMMwe4D/1hr1gMHbMe40oMmxQ3TeTJCffDw2my19UV244iQtZVe0MYYXxFZkR7PUglg7aMV1o/7FJqJdH9nXjB6fDIk8IfXVvOAAB7WDL7PgyrRHl2LHQIm8S4BW7aCwdk5EQP0YgTOdkVL6JEE54wBPxVVzJYUTpe5rdBo1sNBn/74OTpEuC99FO/7KlF2jXHvCdSOz2n49QEj5DAwweMik9vlcDQtZ+rbFA+bcLfS/taGkvVBMc/J7wrBvmr6VAmB8w2I7vU/FQvPZpozkAetwTQIG+AniklsEnbANCeIXaN+4Roskgx8dsohbuSQnr8YXINy8cLhfI9o4nDn8lP8wVilI1bO6+y2dQRSUkr/hY9oD/Hov2aHoJVqcXdj+JmclGa8hh+B5HChCX9gWDzr/+BvJPtndQPk03iQIMin2UBo58PxDJBcUHtpDdsXNPigFgadFA/AQKqsB/YUDoVaQ7uYu/Ol9RfVWZ8zWtJB/Mb8eqCElCEGiKaXJ0Qsvkw11idUlXm+82A6lW8kWJ9w5MYBS9OBuYpHVGr1mHVmhvDB/Kz7Jf3sSPk8lYRCbULjXr45Z2qfWviOIwteOn2EguHKJJ4NzBoHllPqYTK9pVGVbTFtVALjplhEgs8mWIIgEalo2uT208RGS/QVezoLDuphumdGFXF8Zoc05eeritOsg0CVobAbVOKoGtqjmO0c3Xt/FZCF0o9rBYCj4XeyXWNamMAuWk15P2IYYLvm+73KY5A1AMuZXqWzK/VjVWU8MGtb8TsHudXhiy83jOJXJQqEdjjHaa+pHXKdWzyHKZfPxUuWmksiR0w
 DRHiUCFT
 82HsQ39+6zYY3Odgejfm+5GK5pnD1E5HikBh7cHqdIFycQ3W++FmB1PHmqt+cvGB7aqRwHt4M3sxC1SJQLewPstbkYtHvjqp9vVyr3vWsI8ApYgf4u//q6TwLHmdGgDZkYYuAh0LHJ4Nigi6WpMvnbCr4PS3B2Ehe656oT4fZ/V7301se1Z2Lpvf6inH21PSsGpsu8WbXfehB7MpxysGlysgRQydfW53CLqGkVoaP2hJo7VxA8/tgHOvCFqaalId20xy8CxpwHOgJwXwTwg7yQGAyzzG0558iOEgMMtSioi5/QxVg/7PmYzV2YI93MGjimOt8NQeUD9+qFC3UVXSEzqjanOIgsXATAawEDdHb1Jc/rLxUb4xl0WN9GOgA9swFqG6aiiAZXfJu6XNs+i6AaDzSFByMoDH3msEPqZbQ0Eul4n38Jf4h+v6wvF4IT8c0bL4T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN uses get_cycles() for two purposes:

  1) Seeding the random state with get_cycles() is a historical leftover.

  2) The microbenchmark uses get_cycles(), which provides an unit less
     counter value and is not guaranteed to be functional on all
     systems/platforms.

Use random_get_entropy() for seeding the random state and ktime_get() which
is universaly functional and provides at least a comprehensible unit.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
---
 kernel/kcsan/core.c    |    2 +-
 kernel/kcsan/debugfs.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -798,7 +798,7 @@ void __init kcsan_init(void)
 	BUG_ON(!in_task());
 
 	for_each_possible_cpu(cpu)
-		per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
+		per_cpu(kcsan_rand_state, cpu) = (u32)random_get_entropy();
 
 	/*
 	 * We are in the init task, and no other tasks should be running;
--- a/kernel/kcsan/debugfs.c
+++ b/kernel/kcsan/debugfs.c
@@ -58,7 +58,7 @@ static noinline void microbenchmark(unsi
 {
 	const struct kcsan_ctx ctx_save = current->kcsan_ctx;
 	const bool was_enabled = READ_ONCE(kcsan_enabled);
-	u64 cycles;
+	ktime_t nsecs;
 
 	/* We may have been called from an atomic region; reset context. */
 	memset(&current->kcsan_ctx, 0, sizeof(current->kcsan_ctx));
@@ -70,16 +70,16 @@ static noinline void microbenchmark(unsi
 
 	pr_info("%s begin | iters: %lu\n", __func__, iters);
 
-	cycles = get_cycles();
+	nsecs = ktime_get();
 	while (iters--) {
 		unsigned long addr = iters & ((PAGE_SIZE << 8) - 1);
 		int type = !(iters & 0x7f) ? KCSAN_ACCESS_ATOMIC :
 				(!(iters & 0xf) ? KCSAN_ACCESS_WRITE : 0);
 		__kcsan_check_access((void *)addr, sizeof(long), type);
 	}
-	cycles = get_cycles() - cycles;
+	nsecs = ktime_get() - nsecs;
 
-	pr_info("%s end   | cycles: %llu\n", __func__, cycles);
+	pr_info("%s end   | nsecs: %llu\n", __func__, nsecs);
 
 	WRITE_ONCE(kcsan_enabled, was_enabled);
 	/* restore context */


