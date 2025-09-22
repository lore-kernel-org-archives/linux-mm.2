Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DEFCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B408E0014; Mon, 22 Sep 2025 06:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42728E0001; Mon, 22 Sep 2025 06:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58C08E0014; Mon, 22 Sep 2025 06:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9189D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:38:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52E8D86DE2
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:38:48 +0000 (UTC)
X-FDA: 83916537936.26.528F150
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E46C2000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:38:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Fyu1tBlM;
	spf=pass (imf13.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=7JvxaCnwYIzoIe25gTJo2FEd9IqDaFMQPWiBr2tYW7jnDPMzn/4flqFYvj6k701y/LtWf/
	Y3Y7yPP40CEARxrdKDEc3MjJb9LwoClxOLrRYSEWgxVk0LWuI29UNsNHvCCsEWuIm2qToe
	4MvwthVDbOdoVZBF2zR3eifBlIGneew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537525; a=rsa-sha256;
	cv=none;
	b=l3fupN9udsWd7IpG7bGhkrVE4rHUGCFz5WQxoQplblOVEX3QwnT2YQoc+FIbntrB6xzFv9
	xNtkQOfFrUr9mzsD45zRvH7XZ2ORTvtH/k6hyYA22da4EI8U5BeyfBsP/ks5JhtqXSLs25
	jHE5TmcGGE1iSKbuWgysq+V3LXsByEY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Fyu1tBlM;
	spf=pass (imf13.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537525; x=1790073525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=Fyu1tBlM8ggPKRTmeQtQo1oXrk3KKdW6VroE4BoqKmwyW5DaoDgAd/iC
   GgQHuTo3y9ajDfUV1FIU71+/3+Wzz25jkntHsYdjaZFu5h/D4kStzM1Dc
   3dtJXUmNauEjd1kMqDjveHV+rMd7yDBIRpMKgNbMuzewQD4/VNtocqK8n
   rU3AvZv61E/vsu4mXB5you27He6HWedDxqjdLX9Tauh+WtUNfjI1aGDTg
   FwT7DDvXCoAITrMNhebdh3a4roVPP7/mPSUAnXPFDE4n9pXBlXE2+9Ont
   nwD5yNKc2LhGBnL9nz024yjAhB2iBhYMC6Md/6U5WdY4tqidioDGKnWvc
   g==;
X-CSE-ConnectionGUID: vsGVL5/HQSebir4eYno5kA==
X-CSE-MsgGUID: /muRbZ7GTbeluEFQ956+0A==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2475920"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:38:33 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:17701]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.240:2525] with esmtp (Farcaster)
 id ffd30fcd-2f00-48b5-9ba9-81c6f494ab9f; Mon, 22 Sep 2025 10:38:33 +0000 (UTC)
X-Farcaster-Flow-ID: ffd30fcd-2f00-48b5-9ba9-81c6f494ab9f
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:38:24 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:37:58 +0000
From: Eliav Farber <farbere@amazon.com>
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
	<johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
	<samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>,
	<wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <pmladek@suse.com>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <minchan@kernel.org>,
	<akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>,
	<keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>,
	<David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>,
	<linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, Dan Carpenter
	<dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Jens
 Axboe" <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH 10/15 6.6.y] minmax.h: update some comments
Date: Mon, 22 Sep 2025 10:32:36 +0000
Message-ID: <20250922103241.16213-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E46C2000B
X-Stat-Signature: ie8xqhs7proa1rdyxajezp3fzi1tpyzu
X-Rspam-User: 
X-HE-Tag: 1758537524-775200
X-HE-Meta: U2FsdGVkX1+zJmIqbzd9RhTWDwSNJRfzy4IrrNtgmCgIE+bKp1eU9ztCKMWc+kYfKITVtS+F4Dl99Z5pwGyel/I1ESM+UeEDFwHQlpH76W3ejZmhHi3nRyDNCXPZXmJm1im8VLA9Hjq5hhWYg1aXnsi6AQwcoxdXESqGmmpnXzm/7uTbX9aFL1Qd1ZzfwGGt9vrSPHRcImTIr5i/AgP+qX6dpPVaq1e3zVokvSEipB8N/c/AFkScn+OjB5YhOo4EXI1tYFVz/SabbqiFVUdRqpZsTWZgKk2PrSAHbuMCGApgmpapspXEBa9JG58E6dOQfRrurZFJ4W6nCs71xhkQLaukygkO2Y7MGiUd6Z41D4vGdiC+tai2b5PMabqoqgJrzKQgO1IPHNyN2pCzZsRVxw7yZ7/Huc+sKyTEBrWI08yY39KjsPdokKBk+RMGU2tk0yVW1Itvzt1jScAvEDMScl3Mwru2HMb+ZkIA2QozfJvVdjqeIw95YjZUQ6dBLChnjNHOVeLDZf30u85kRClnGJ2mw/mzq9EsC5PmmTPgFLtcJROd34NQpLyFFZeml9Oeacuk/GWasAqvAPtVPoD0w8qZkAZz8H7f2Y/c7mMMsm/wzMcmUtbCsSYbGv3lIJh7ER6Q7UXEY/H5zGejPC6oSl+hzk6ZrGvWAw2zOO5u/RYq2y0YUHsD9Dr3S/NfYWYGkSog/R9iKWmLE3+n6Yn1sYtc03yUGSI0Z1rVSPIjNISF0sZSd90gXRUpHBeRnzgMnNG9/M5rPs+tq+g8GBH3wcsDslJv6WKM4XPUyfPBskMoWsGZK2cppOmZQWPNDoDumactN5e4AWpthPuJ+25L8OIHDm8b2a7cG9RRfcU4L76j4Yoeuaufi1WNWmjmjOhIAzTm1Aa2sF0TA/eidTJo+Ls+trKhKiOcKhyDZKPDq+JeQTu4Hi0I2Ha/QGch9IJWtMXKDa0s+lm+xhQc9q+
 Ac3nlA2S
 Ts7amyibl2iHR+xHu1r3yNTNZZDYZxbOZJ1Kzg8/I84pSHbuvpPQsTxiwOfAZN5SQqZv6gJr4/rAOBwlebojH16zjGrHaOF8Lx1pLf7djZLTP3y/IrTBhliW775vGzb5vWOI8DATkBxOeM1aQrh+9JsyfNQJPG6xIRJhPWCIZ4+biV4FyAZyyQXjqHbgoQu6L6dtoaSM+fy0uM6elsEyxe+j6reX51yM762SifBcG7edXFQ+7ETuLpIC5B8EQpuUGPuaWaV3drdEwUZ6c6r8RQYoGTCr5Y/hjHkee3/iVonwNHqs1tcRdrMke6GzEo9YedAsllofuqaV3QI7NZ9ekshRpvZZbiN85DfEU26i/qLPys8CjW1zBYN+ujBTfMXxHLzKpjmRNuv565X6CoaBWsS2BnKg4temLhw8RvwhWnZNz7eL2OUIdhKP/ipdPnBjYh92tez8rjqGL4V+ILLuRUreGlTcvQjEwazJJqiehy7s0CaW+ScBfvQojtUTKx3ukcBOSmT568CB3xN4rydWL0lj8kgBDAkgOOg5e2M5usbMTM0BBSkQes7rNgA==
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


