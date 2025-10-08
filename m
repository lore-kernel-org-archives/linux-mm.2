Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D1AFCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73208E0038; Wed,  8 Oct 2025 11:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AA98E0002; Wed,  8 Oct 2025 11:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60FB8E0038; Wed,  8 Oct 2025 11:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 961EA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:34:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34D7E1A05B5
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:24 +0000 (UTC)
X-FDA: 83975343648.16.BC7190D
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id D99C2C0011
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tgRuiBKk;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=LULtgbbVIp1sBJ/3DgMJyd+T1KcxMpM88pP2jQZl67+bEg5eCzI3/e8zq+mHznuaXX6ecJ
	yF9afAL5wxGjYFRNeAbKmYeTebeg6WjVqTl1cSpH9hmUgiH9B9HM5vvmll0trPOaI5fwOz
	9fMzf62L9edpMWdqIhmh0NAt8rk9sJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937662; a=rsa-sha256;
	cv=none;
	b=kFMt//eVtmSAEknr40FAEIj2zgq5nwIw53KEWEBhdPCVQDMihNiGYpv8Sh7tKsZ/Ssjrbk
	8KommXoALP69ULAxFxWjpIYg+N1z+rb6Y8neXOdkHmiiIdmTc6oornxK0uNUjYcDOl7Zbt
	+fue9Zv/wNjOESfXQoLtl56/21VWd4M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tgRuiBKk;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937661; x=1791473661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=tgRuiBKkhE/uRe/ULkG9ePg53bzLv11Zoa/SePyz0reQN2tZKY6X295R
   1czjd/yL5ZCKSAqlc09n838EOafk/sVSKW31lM5YYqDgqF/fvWLEXkomt
   Wh9/V2sPMeTapCNT7ySIq1y1LHD9eZXr/HXZaMgn22UZuyeexqGPivg9M
   vnvFOIlND7WILzYFA8KDlQn5gIM3cV8uptdk8b+84x/3Y5qYbBgIcNv9B
   grcynAMd0cTi4nHTdwuyy7cH4dJlgPhMPQkqKZQ9Y6iwa7W8HV62cNL/8
   fiewFCyor3J9r+KqPuiOBNxWo8yAJRa+J1bxHAXoFGWZqem5OZfq+6vTm
   A==;
X-CSE-ConnectionGUID: gLukBxtNQKGGct94M4/5Uw==
X-CSE-MsgGUID: uUIyK8i9TEafYIklmFnKXg==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4335130"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:34:20 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:14896]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.225:2525] with esmtp (Farcaster)
 id 6f1d6760-0446-4fdc-a5e2-0aa8f0cefc04; Wed, 8 Oct 2025 15:34:20 +0000 (UTC)
X-Farcaster-Flow-ID: 6f1d6760-0446-4fdc-a5e2-0aa8f0cefc04
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:34:16 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:34:03 +0000
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
Subject: [PATCH v3 14/19 5.15.y] minmax.h: update some comments
Date: Wed, 8 Oct 2025 15:29:39 +0000
Message-ID: <20251008152946.29285-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: D99C2C0011
X-Rspamd-Server: rspam02
X-Stat-Signature: hci1bixq83zbnmsfixge6gqyfyhfq6bw
X-HE-Tag: 1759937661-19625
X-HE-Meta: U2FsdGVkX182v7aHT8E6LKR5WSlJ51oiYBIFPUffJZdJaMijBbnlae3YIuHe7XGQJ4LAhDffDfrKdzZcbVcT3c147LWPAfZMMZG9m4LYOftNmu1IhPAneUcEPe95/VOBiRGC7Vi+xBKCzuxKtLRkX1+vBIDVrNUWO+pXeaG0G9a59N1gM5nBgeirZKCeIpBO+ClFLDz35XJMJGMDk4F+H3pArJc3btaTBDcdZDbDSd6Y8JPYR/GgQAhxEZRU5erRRylq0QZZG8VYNzltijhUoHd2iiCal2aId1zVKPzbiIGuIyk7rrP9UX0HvolSnLx/SIKQzyFoqwChcsHNTWUGqJbPo5gDoBcw+YzNWouR3LIhWutGmNYmUsFzGLQaUoIhwxs5GkhSuCiGW88JNJX4GRG6kZvzskaVmdkAIxv+fIiqcTfNWdpmksIKtB6VFwyy5pferyVTTCtKged5A21zk4LMXQN7QQsCOdQxZ2V9Fq5O0TXnHANNoLVgurXFmZc5dNZuZVKKcFi24aaREg9wFqaMjBQDOOnvqxPafMoXD30AwUBsl48/PXmJ1Gkxr+YfXK4vFIbxKdDPaaEkbg/yDT5L5iv0RodZsokbdrDq1pIsFL4n2fqzwnfjzmK2+bFKootbo4uyPT2JSYqH5OxMSUN1adiuSv8V3tzXnapbn3ZiaZ5wVF/O7kJ1T5AbtYrfayc9Nz5U6ESISJU+tq+JTI995Dw0tML9Ffrw8ULA0pG3irgD737OHR+whc3BRI4EILfHaKNrIJwJ+OQ6X1ve4egFoYEsPvt1h0i3kG9DFQdHLwGN4n8RbpBJ1Uu3RCfW6dH72VPrab/D8WtrxOTzJFhED8dVud1c42RaLPmacuvshPazIMC7hln/cJSO8go24/TtO8U6P4uIb1T+9ifN/8D9dIJrHacC6z/5zOUKlEd367OVuOwK3HWxcxZtKrQT0FoSbCr1qMLcpwVjFTA
 GhaEFRWi
 Sob6wj8PzUUdFSae0SdvqvCEaruMGZ4TUrkBxj8bWEkoIMRHc0jIKAILT4h7jx4rqa3vjmRYiGzMLWP/mfw+wQPGXWB22/jO5VRQi0VVQKXrPvplqo+mjumw/6AoqGB9Lrsd8TL/yPfYt0Lpo2OlfUn+WXJuS6GaoeLF67WxqcN3B06yep2LZn9+l1l2vaRivGPRuHR2Nu0Iu6JsEIfckU1f8QWXKRqtOX78BvNs688GbIpzPmPsKUhEMFSBgWC3Sx2ZneeP2EyMjRoSdhPyTwrAGvIi10hNgqw8CrVEID+jhIAPwJfZ8pys1sBLi5YCjsRsrQYrgWvqwCzeSpSF17K86FuVrTHu/w7yvWjrGX5paQP0CcfLIBb2SQh9tWFr4th3+sXhvveZ2pN8UGRDxepRA5A+UxwoPAjX2ZzDyH7b9fuEwNzmYNtoa6a1hmbL5bRKcu+mKkuCTuwStDlA0WvuPSlwnNDG1o+EOXhA0bx8WIStnKRJrDdlUW5rROgBH4LhdTx6E7FIFfaPbhslLS8UZ/KvqSwfSRclWWvNw0L4PuK7LcqFHk76NSsv0tCrBXegircfVy3JsNJHyI+ZCnEczpolTx86cjc4EYy4PkOHLQj3uUY85ToD75xA6zf0ecVMv3gqOusv6Pb7I8bWl+zdtfZP3RdstL46JLt7pyJF8/sA7ubaBIGHBEsfezmi9RuTRiop718e3RfXDZH/OMMqF/DXxT88Xni/sAxrugrw8xVc+GXU/bkIGxJEKb+cOvA+nIK2EE1KXY5ueuV0rzrCDCuQIelXkjI9zBjfaGm+jWm4rYYCqlSHanNwB6U0FRLDc1q0Tv+oumt86t79NekUzB+gIzisCFDSWzid2u4WZNTAp/crB8P98Axo8ygIUWe+T4oghXzDRORVpEt6A53P0ibiy7w+I9SNJK+JTVT46f+Jlc4kAiUdrzK1+HUI7/rvzjiVRTk0NuBwAOl0gbEOKf+vS
 Cq8CUntN
 QheFxnzNPyWNVcg2jARGcZ7PkHUS3h88x21TWB+v/7vCDdsPwDpP7kHv/V33SbTLd9lNQBlJB3YSfsut79OeRl1wQ8ZIv4lUPNkymMAtn00ruCocJ+abNm7jVfn/kSzz5aPh5KsA0d2/241LKwj0FPp3EikabP0nLac8redGJIiuR/mcGdL+jezNv3Hr42QkN08jq9EazSIf+3x7ZJmN4+aD4O8oXJLITTcMTC7v/MbjieGZXObOHLEaPuV+bQLwiRMSF9ee5lEI5GnVsF6yUQ==
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


