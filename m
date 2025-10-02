Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C86CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCDE8E001B; Thu,  2 Oct 2025 16:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD308E001A; Thu,  2 Oct 2025 16:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BD28E001B; Thu,  2 Oct 2025 16:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC1BC8E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:55:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B695711AA91
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:55:02 +0000 (UTC)
X-FDA: 83954378844.04.35757AB
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf24.hostedemail.com (Postfix) with ESMTP id 73451180003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:55:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=mXJViB9k;
	spf=pass (imf24.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=X/rz3fzgBRwwlB9lXmMyjwPHQ7JQgWTFlEEEOJDDajQYXDxjvVw2+uBR/ySoqZiISA20Y/
	Fopggh6dI8ulw9wM2fK2e2QkLILPnq1dXnGrRnil7A6VfPAj3FIJaB87Fw4kri+iQR3zem
	IiwcVfNXzLB7K8aU1bXswPNWct+0pPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438500; a=rsa-sha256;
	cv=none;
	b=gc6FSSdutY7EY5IZZkn9gZER1pNJRx1Oi6mxW/ItVR2u+3ad2fWytL0MFgTSa0iFuGALAX
	3V1jyrn8D5IBcWNlC4O6Z12aqj5W/TQuJmE4gIHcGIBGXgEW2TSDNTbRWBO3GdSk1zxA9h
	vQ5rc6AwOozX+cbXH8oG86jkHKJPQ8o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=mXJViB9k;
	spf=pass (imf24.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438500; x=1790974500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=mXJViB9keezd0fpopX5BUx9y6O5OPQViSBhXLMactD9jozSGRqA8cgZL
   ValGueSgcEzgjJptsB0dOYPtMxp1Fo2Ry/BWhjMnjwhFuNW4DTpRY5AI5
   j6AFmAA2GxsS/xnqZNj2bk6tlAMLnfxxmkg/VvM3IB6M9ZLSGU9PA9cm+
   +lUiQY7awPfXXjN9x6y/QcN2LWxF8q/2sUMWIqnVZqUXMSBH9CznAVCLv
   u6C+kBXhmAX91+4wP9pTrXUkdpF+iPBbG4SAz4rfa4KwmmAO5Opf22uYR
   ZKo7wmHeGm2klNnPnt6YqUVYn41mjEbu5GfSlyLvSpRrUE2od0fZMRBtF
   A==;
X-CSE-ConnectionGUID: sqEmFwKJRe+4WKOe48OVQA==
X-CSE-MsgGUID: gZDZJk8FQnqtouHNWAu8oA==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2914044"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:54:58 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:7933]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id e8a02be0-811b-4e66-a272-0a15e74d69d3; Thu, 2 Oct 2025 20:54:58 +0000 (UTC)
X-Farcaster-Flow-ID: e8a02be0-811b-4e66-a272-0a15e74d69d3
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:54:49 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:54:22 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH 14/19 5.15.y] minmax.h: update some comments
Date: Thu, 2 Oct 2025 20:47:28 +0000
Message-ID: <20251002204733.35652-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73451180003
X-Stat-Signature: jmn1smk1f3eq7pnhsa3nh7adp3kz56sk
X-Rspam-User: 
X-HE-Tag: 1759438500-592602
X-HE-Meta: U2FsdGVkX1/S4DDkwuRGSMoPnMU0k1EjMHsxvEBNMCwyPHXNBfW32WRvTGgRiia4/zNrYuhezdvtK7Lmtdc2SB+sETfMgIYhuwmW6vXuPYriO0KK1hWE0DZgeclhbHDunMEdutXUA0HduJiOfYcEDuBMqSZ7NMA9UkTfMok9ctVfcQPd6sS89OS4gmcGoaz2QDeH7kezgSP6FYhCELKo9zkFlsU2uH7ILOR9TRROLg1M1Zi0bIxO4Deggzj0KJ2HxA0FkE001NQ1IqfpIqWr+Hw43PMf0r12CV075uKG9KDLfBrhR3t417K4Ust5q3o+cPgYqgjB2AUvdkyLvfar3iR2Zlifs0cH+dyhM6XUhv7DW2UE/cEB05RsS7/5930QjPbug5oc2fAIR8vbmtmhCh47L+sipdxtZfZsPAblhElw8Ke4907OsZlbvZ0SBeNOXYgkm4ByHlNqh72z4fIOIX+H43Ylv3+4dDPIQuCG3Rtfvn1j9Bk4IvgI5ef6qhDoHZZX08hUpIjjT83OIfDAEhNktz+Q0HmbkOsVenwIq9I3nRWTCMeU6HoZWeF6EtJw+AvRHequI6uCA0QQy8gF61Y1Y1BsJA+DhTVDZtc/e4/Z3HIEIRpeo5xcNI+ULt+1RyyGhrqzs+SVaQ6DXsslWX+WzOOEQHMIbipAjchMTBf75rAa14QZnbLjyQlW1Vntslls1EtHITCHxfRVsdIBTNXWCahw01pO5EgVo+C7Ay/oAJpQeZz5FF+6X9uNULOPtEBq2Q5/Mc/N3z4PgpREbvIGXIjvRxSvMb6x/HVFf8cRzwgIRpoMS6sYQHPv7ypfJAtw7y+Mxx6JCFyLO5Alx9RzpW2aIBFt8w70umwJVYCD0hlxKl34VgrONac9gENlZXac51HSGVI4x1jeTs9SuZt3EmNck2YRU5sZBj/nq3vWc2xU3LQLHnTLs73kRkyPPpdeJHqc3MFfU1kTw2C
 znMsiYqH
 tQa+xGzCougf8TekTHzbEuP5vipR8mrTLoopPrt/WIgVJqxfuuTz9s25YUsRjI0daO+GQCGYuH1ppSe7YotGAxZQImhQ+pTQcF9kb5B+GplbYuhKHqzZw/T4evM9rYg1qH+bg7L74U0p46jQePeVu0TNebGZfZdnVOgdH6Qt3C+i9DJrO8u4CevHohiYxI1BvcKLntXVpVF2syZauPMGPSyjtdL4dj7QuJSwStpGN+7kcq6PXm7MgbRLBKSY3xkxhlMH6cb98UfMGW7XrjVCiWqvpiPdNq/SRheTI87CePwROP0hrwxSbVoeNNip288n9wA4KmG+1Tkan6diABXf3dm9baPyiP1OM5omXs0ZMv0B48osbdz4uQqGhGgXbF2ZWvJAWYi93IC5LODUKDR3IqTqyaaEchuPhOuHU88kMtD2/68vyW6D2SEOFoSj1bep3P6z9vMtKTyUPBC5rWdUD3tObfa4k2S5xHB6q5SbLe9gh+p9cgRDyyQPTlx61qeDZuMvN2mu/+YGZzo8leiSF+NYukH0Wa4kniotSs6mJDEmtGiKG4Tx5itWCK3LrO6pgmg6GyqDzkXYUSX3mlNTFypFj4kIXzMxIiet36sKrlMWpa6KCaN93SNpPJHhlBF2Eh498JocOWXonZQCt1QPqRVjnPkf/6n9PNDtS8Pi6OneIJtF9R4zBfDhQ1xZk1372gqiUdj53qWA7JwKjAC7xRhcWdFX+1pGkdyCdmrOeIb8XpbjG1YZB97t+fqZ91+WOHzbt6ZZfXu5tBeHOOG0FsGsp/NSilGGpKwG2t763hmEoXM6ongm/zqETWCzCXpS/MBqwxUJjRLLRxVTEYVfLnIMjKZdjjLRJ0KTJ2KE9waemnd1EZ/liaXs6UVpcIzlJOV5Cf75XXkYHoALLqsIIGTNkz2XMevjYZmaMD/Yft+oYpXrgWJrOMYmZvtKCiLS628bCFMVihtn1Tx1CeJri9VvHF9RU
 BUOrdGsN
 8huSlIhQORs0jCRCF3R72IHfPV6uCE2V8dpwTuPT166JkxqRYuW7m//jB3HrobKrT3qzn9Q6lhGj8UdhZhzD+lC2t0EDEhGaJYCt586L/L1zpFLvEA/aRT6M2/IrS7Wxm8nfEjOHGCVQDYybV1q1TZjbYY+lFG/qqrWbfD2FEKKB2eBCaMWNVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10666e99204818ef45c702469488353b5bb09ec7 ]

- Change three to several.
- Remove the comment about retaining constant expressions, no longer true.
- Realign to nearer 80 columns and break on major punctiation.
- Add a leading comment to the block before __signed_type() and __is_nonneg()
  Otherwise the block explaining the cast is a bit 'floating'.
  Reword the rest of that comment to improve readability.

Link: https://lkml.kernel.org/r/85b050c81c1d4076aeb91a6cded45fee@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 51b0d988e322..24e4b372649a 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 
 /*
- * min()/max()/clamp() macros must accomplish three things:
+ * min()/max()/clamp() macros must accomplish several things:
  *
  * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - Retain result as a constant expressions when called with only
- *   constant expressions (to avoid tripping VLA warnings in stack
- *   allocation usage).
  * - Perform signed v unsigned type-checking (to generate compile
  *   errors instead of nasty runtime surprises).
  * - Unsigned char/short are always promoted to signed int and can be
@@ -31,25 +28,23 @@
  *   bit #0 set if ok for unsigned comparisons
  *   bit #1 set if ok for signed comparisons
  *
- * In particular, statically non-negative signed integer
- * expressions are ok for both.
+ * In particular, statically non-negative signed integer expressions
+ * are ok for both.
  *
- * NOTE! Unsigned types smaller than 'int' are implicitly
- * converted to 'int' in expressions, and are accepted for
- * signed conversions for now. This is debatable.
+ * NOTE! Unsigned types smaller than 'int' are implicitly converted to 'int'
+ * in expressions, and are accepted for signed conversions for now.
+ * This is debatable.
  *
- * Note that 'x' is the original expression, and 'ux' is
- * the unique variable that contains the value.
+ * Note that 'x' is the original expression, and 'ux' is the unique variable
+ * that contains the value.
  *
- * We use 'ux' for pure type checking, and 'x' for when
- * we need to look at the value (but without evaluating
- * it for side effects! Careful to only ever evaluate it
- * with sizeof() or __builtin_constant_p() etc).
+ * We use 'ux' for pure type checking, and 'x' for when we need to look at the
+ * value (but without evaluating it for side effects!
+ * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
  *
- * Pointers end up being checked by the normal C type
- * rules at the actual comparison, and these expressions
- * only need to be careful to not cause warnings for
- * pointer use.
+ * Pointers end up being checked by the normal C type rules at the actual
+ * comparison, and these expressions only need to be careful to not cause
+ * warnings for pointer use.
  */
 #define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
 #define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
@@ -57,19 +52,19 @@
 	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
- * To avoid warnings about casting pointers to integers
- * of different sizes, we need that special sign type.
+ * Check whether a signed value is always non-negative.
  *
- * On 64-bit we can just always use 'long', since any
- * integer or pointer type can just be cast to that.
+ * A cast is needed to avoid any warnings from values that aren't signed
+ * integer types (in which case the result doesn't matter).
  *
- * This does not work for 128-bit signed integers since
- * the cast would truncate them, but we do not use s128
- * types in the kernel (we do use 'u128', but they will
- * be handled by the !is_signed_type() case).
+ * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * But on 32-bit we need to avoid warnings about casting pointers to integers
+ * of different sizes without truncating 64-bit values so 'long' or 'long long'
+ * must be used depending on the size of the value.
  *
- * NOTE! The cast is there only to avoid any warnings
- * from when values that aren't signed integer types.
+ * This does not work for 128-bit signed integers since the cast would truncate
+ * them, but we do not use s128 types in the kernel (we do use 'u128',
+ * but they are handled by the !is_signed_type() case).
  */
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
-- 
2.47.3


