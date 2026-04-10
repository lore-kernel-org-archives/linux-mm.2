Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24FAF44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652116B0099; Fri, 10 Apr 2026 08:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603896B009B; Fri, 10 Apr 2026 08:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F25D6B009D; Fri, 10 Apr 2026 08:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB056B0099
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:18:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAFE014052D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:48 +0000 (UTC)
X-FDA: 84642549936.14.D00001C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A65D20008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYJITPmd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823527; a=rsa-sha256;
	cv=none;
	b=dU+padRQbHgrZF6EZhkKZGlhXGor+8TsGSP08pfmNrQXnEi18lvXNVMRJsTjus7BMMGD/T
	QgQ0fKREzYbfU4bM2YwaqhwYFc+B6Lpv95GP4KH0JQbgoLRnk9HDRy+a2QHJ/Zrgl8Tl1X
	lI1JXjmk7eDF1tezqKnMSecTbOnZmWM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYJITPmd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=QNbKEqaPolXnyDtyb0N89kzCxyVMHVZnkdKQSB7ziQU=;
	b=oEgII6KLJy3IigiP5DhM/vHhuNX01zGsva8gVN4Ba3TqMI7N/kVpEdINx4QutvhxN6CbPH
	GiHs2ZjT/b824gAcXy6zPvu7KNPvXoUgOqh2OuaYC5kjIBVXTvyeTVS74pMJZM7H+xEryv
	sca80BG9+MAmyUPs9fCuHODxD4N/34Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 562114415B;
	Fri, 10 Apr 2026 12:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC1C2BCB0;
	Fri, 10 Apr 2026 12:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823526;
	bh=OWF9pG0hQ95RygMnh7+vDhgeHyKnJRYOWEj0GBEdTEY=;
	h=Date:From:To:Subject:References:cc:From;
	b=gYJITPmdy2GNPsbI6AD2iZ7zhMgePGS+gqPbXQCs7WsAhhu/qyX8hH+Xi69K/urPl
	 BoSeBlt4BbqU4ZnISQ8slAdj5VCjiDRcN9bfEzsBBE9dj/wWUHwDFECfvHb21gTPQ5
	 cvjmyUKF+jJ25R6iZ5vAzO3xaA8XXwp+1aea+F9V1esc/zHHX5PN7paJBTByHcDBl2
	 auQKRV9dXMsXdujNzqathwxe2n8RWyCswG/DXqH2EllhOxm/ndPsrTIJX4WzacriA/
	 t/DalYn89VnEQy6E+ROiviOqorgI/E12LPFkiSGiJSdwmaaiky6k8Wx7OG7Y+w6GUr
	 Ni5ruNMG7XCYg==
Date: Fri, 10 Apr 2026 14:18:42 +0200
Message-ID: <20260410120317.776571540@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 03/38] x86/apm: Remove last LATCH usage
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
X-Rspamd-Queue-Id: 2A65D20008
X-Stat-Signature: bccfexeqfhyj3fkn6mmke5msxrzoquoj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775823526-754094
X-HE-Meta: U2FsdGVkX1/7CZJG1KmgQ3wLe6uyehJ1ce1wVg063z1ADTy6+PCaTiWrbwVUSLU2PMDcjqSuc6FvdVA+IUguZLt+C+asZ1ihim9Uw2rt5mYKTyhf44umkwwiLbK8QVlpYGI8I6VbrmA0wvOhjDWXP9AmoxiaPpmp9lc36xTIIw2TeJunSQt9j/xy4gM13ETPa3c9OFJIbF0gg7wu2eBOTC+vz4e2HmQLy1J5XzYv1ofHx6py/BU/vjf96K3wBItNWo0thMEKqLATW07+dAvQWxSST8jy683OyTpc52Npx4UcpQdhAwyhR7aTxklMPaypjWOCEtDeX5PiZVT9gYybPJ+RjDVb4bBhNiHvxF5BRugMXeWFh4k/hDKtbSymJ1boOHOr4fySK3fnJRcJeQxvkfWb0ew1nGPtFtK3F+6CmyTDR5WAvN+4/W/nLg4CEIY1yKjmUte8VHktu/crY22NB19MCtw7pd+/QiGM1RnX5ZWh/Bja9n7L92HxI+JIKtNH08wlBabnF4FoPUr64Zp2jA/GlA6BMqyzHlBf46eCpcidCZKGJaKig3+jXsMMvUAjrlbvqUSAPkmiizWdZy43srabPPfKE79YajzqfdqNWD+IF0wZMXeri+3qOGhXOGs/3PhIh00fLpi0SinXjxJ/cX345vt1jqvE9fiwCqo1UkPcx+wX4Z9z/UaXq8+SX3CMS3aEFacTCOolsWicWKielAAlOIyQsnR4ZjzDCgAwVZ+7bjyLXiV6ngNnyngIu+AD8xVotP+Qpcf0ZyU8uHuIsVCVeJzSWnu4Hjb3kIxzXE78lt6WJsGyqwl6UmDU+HOyGUzrYLZjEOxYtwQVVO11GUsBFv6uHFu8qxBPOm3N+AIWSac2pDcrsLP/AwSFeZER093HpBnefmJNitKRp9Hg3MBt6lFWymyXvVoMOH6bzJGi/3nfttIiIvKYshsPn4vAx16IusWsSFmmVCv2LFy
 NfBFj2IF
 1HUe3wGGam2nx4ghjYJfZhGXaGjH/Q/3MHbNwVLcQtWMunVwVarB0cBwwGCfuPshRPYfSDAT+fnpbt86xPU1gUxpqCgbybSldB2BikCoGgK/kLTBGSNolt56NO8ZdAvhC2hMHNllUlgv5Hobhsh/zCS2RPp3gd/dSlhRMG0ZI7yYAmf4FJKuiuJZ8DLtcv+AK9zWWk4DwmMl3GlD04twpOw/IJZh4tjFMoqE5c9eHv9bcaDgXwQmCyx9hd2Ca+fgr27kOnZgM1DMP5YbHrlaJYGnpFqpD3RH4v9ZNqDAIvT0UKr0lUx+5TzLtTKAKbE83UqZi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LATCH is a historical leftover and has been replaced with PIT_LATCH in all
other places a decade ago. Replace the last holdout and remove the
definition from jiffies.h.

This allows to remove the otherwise unused CLOCK_TICK_RATE define in the
next step.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/x86/kernel/apm_32.c |    4 ++--
 include/linux/jiffies.h  |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1196,9 +1196,9 @@ static void reinit_timer(void)
 	/* set the clock to HZ */
 	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
-	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
+	outb_p(PIT_LATCH & 0xff, PIT_CH0);	/* LSB */
 	udelay(10);
-	outb_p(LATCH >> 8, PIT_CH0);	/* MSB */
+	outb_p(PIT_LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
 	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -56,9 +56,6 @@
 #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
-/* LATCH is used in the interval timer and ftape setup. */
-#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
-
 extern void register_refined_jiffies(long clock_tick_rate);
 
 /* TICK_USEC is the time between ticks in usec */


