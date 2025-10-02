Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D053CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89A38E0020; Thu,  2 Oct 2025 16:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39F38E001A; Thu,  2 Oct 2025 16:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B023E8E0020; Thu,  2 Oct 2025 16:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5D98E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:57:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A311140683
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:57:33 +0000 (UTC)
X-FDA: 83954385186.09.780109B
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf29.hostedemail.com (Postfix) with ESMTP id 143F5120008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:57:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lkEowbjO;
	spf=pass (imf29.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=BE2/0H+LlkFkkrMPJFyP+4xcr8tbatQQai06Ftvw/aovGgeK3ucvoMQUEj7dBoe1sO+FKh
	gPfkImiLtBBBIbijoVyyex1M64zDl/8W04F79XTzofes4o3LWP18oMcUaQXNPcZYuZ9i5Y
	ZGRUpim2oNQoMVlNTYrTehUCgCibvpA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lkEowbjO;
	spf=pass (imf29.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438651; a=rsa-sha256;
	cv=none;
	b=hGemb1DDCd4Sbae8IMVstrqn6w6nx4S45xl7V2kguh+MarXIsVAA7maPJ0cZIjHEuyv7CU
	U1l8cKQlQQNIIHVkjJ/CMwc8Hr5DczQjmwiLNU/OS/QFGjgD7qT7FscocPgHyABbmeaFXq
	oLvKKehJbNpKcQZHj0KPDnFxkmFfof0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438651; x=1790974651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=lkEowbjO55R/dUguNGFdx043yjkXbdk+3vICDeg3cpjghADnYsDqNVT8
   n4pVfBuB7iY8Pld0HsVADlpkKu7+WRkDm74FlyPUOcZRiISAPKV/b26gE
   hzf1ydUxhqdDz0VLzaO3+oWx3O9/9ksYfwYp3xQhzDEbnhrPw5rEuPjlV
   1PKLUXHI4C9qxX7LKqju7Q0A1RUCSZHVJ+MkG39TBIAC+ejkHxrzgu8Ra
   cP9OdJtB14hszZme5lCRN8xOVmL84dIzqWZXvNhuukjCZeQlPRIMyv42e
   zy6zaNSCz5pHJ/RxLvkb0HH0fH1i/X4GyzbZq32LhXeVLA56o6fUrbQTR
   w==;
X-CSE-ConnectionGUID: h2zY6dTES+aammnS0EEI3A==
X-CSE-MsgGUID: CdnqQ7CqRKKQw4L94J2blQ==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="3031119"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:57:29 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:18635]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.83:2525] with esmtp (Farcaster)
 id d3578000-1116-45a7-ba47-5a8e3d4b0a91; Thu, 2 Oct 2025 20:57:29 +0000 (UTC)
X-Farcaster-Flow-ID: d3578000-1116-45a7-ba47-5a8e3d4b0a91
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:57:19 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:56:52 +0000
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
Subject: [PATCH 19/19 5.15.y] minmax.h: remove some #defines that are only expanded once
Date: Thu, 2 Oct 2025 20:47:33 +0000
Message-ID: <20251002204733.35652-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 143F5120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5udxnhnb7njpsn9wr78dpmgzjt1nu8cn
X-HE-Tag: 1759438650-905580
X-HE-Meta: U2FsdGVkX1+HxiSofbqp8RDpbqlJf3Bi1O5yA1SuYqY4ojKU1r0nvqlkyiGjLaHWS7Tf+ZMLt1GxI82vKSwUmPpfLidDNyJ/+NwnbxhBlhhein/YpH3baNQN6tM/YZonUYYiiDpHMd+XTG8iaQBL4ENdngnHwKiZS85S523Q55nORs1mTuDd/W5FXTLd1EjTummtB2XnHzCRK/dAJjfiAAMcfZh2uvysnmG4AmkzkbORagG27u1HB99OY+n5BSpBsVxL0XunniNYHxvLofpb7WZs4Wg/skkRbo5CkpZM8ibiMtWJqNbRBs4t0iYleh7ER+vsw2z8IAB0LoasteElLu0VsqpJKuTlSw+Mq0xVlch//REXw7PHDpccyISdwM40lmrNOQKzEeIrG1lAqXHUrL027mBNbLw3RCUXYTJvygK96YirOwunGIqeSwP9f+auRJJrWKybt5N3A30QqzowJX1dVPFxLWQ/6jxM2NVqKfYUl3sbH5lqqT0/TBm2h39QifAQeU0qDwzgGOaIf0pSLpJqh4gT+RmI/tMlBNmytqt0Cw1oBfbwTLr9Fga++JYDvWo1Ux5fJsnNU6jJN9T3lBllE0vogUjhyXG9SkEH2ddiTJQhhNqRqRkXZWnd/vQKpwkRJCbV5+HfhBE/0f/Ja1OkT6Sp8aZo/KOqQwyoXNX0jKM9p+nzq6JQFNYUTW+IlfSUv1kCHjjLDd9bnCwDHlLdUyKsMJVTIGMqAOJC3xdCbDasGwWjH8GHCED9hmT+CgtFSXGXCvALr0HmVKdW93dm0DYiZO0N3gfTsAT/7vs80TyVYZy7d+FMbLXR9JhSZqKm4EKenqZMVNNVIIsBjmvUdWrAWCZkgdoxLyEWVESaechaSeIiswO4HpQQFO2cE4BjIfHO8vUHLmmuPRnqvj9caYpNb9XAe5D8dhoL0BqIKYGWo2hPXOpZuy+PVwtsFeATSZQ25kpsu7cjvMB
 Zr9YGgoe
 UYLQYS+iwJBMmrt5tT697cjZw5iyW/KMSN5EZPLVnJgmOF/+QS15e/KZpP0IKQTwcs7MqyrupLX6sVA+Vtll/UKCr4W5CBs8lkb+x4692qqpIJ+ZHpRtMwn9iE5aUt5liSK9P9Stx2wbtiQLLlF5WqP8o9G63TmaGKoUxJr56crFBqxSDlx5srrbQsyr7/JTE7zf1z3PR3PYbSIpshrK9iHWGqDHPKdAtPgrI0LdHqSElb/OkIY5hZi33TcPNRJsKH6T5JiD9VDxqvT49EO7OXZFp5CoLu978eZqak1rEUO7fRDyhccOBKKzywmKxmb3dzYLHM/RfVjI0HdD4X/wPAJ4+/AdCcJPj9UmORDX6ty7VvX+gISqE0bsyypVx637Pu4XH6v68K81VLXsaXR4btIx/5lgB9YwInx8YgrzTWQl6SScS0ynqsAB5gF//wfQd0K96hCtT22I5YwQkSNfdUMVvfomSfwwPPJZRgSX5vy4C0lVlTz/9dNHka/Lx8LJtsOxmbIlchozNnhv+jErXyG3P3tnoe7osvjhsA2c+iZbvEUWLG9HISwWJGs3+x5OGTWY+hHolh2R08hGYxw1BMfNyZt+dm5dXvbpGDwsw9IA9ol/GdV/BxUFV7I+LTuY1VK6URPjiKUvor2ZbEvlB+3pwKbu4rRT3krgcOBYbBr5ranRxU8JAhQebFIHx56BEheK+r4b5wB/vwhvZIrAtcQ57P9XG6gpzhwOru6ikQrrDgXL6hoeRis7vXToWSjyB48WTytSWfmRIQDyit7ArPlZaTSL+wYqw+P4A2+n6Gt4+AojohaFsJTRuEOabrbQIqNLoiiBYc1lXqwpKohIL/2B0GaDQw4ZZTsh0Boylo0uZRUzgCx+c3qv+8jjABOcXAslisNlDGrugeV7DVCTIrziU4n1QGcLzrj7gK3QWWGsA0lQKCtrWJ7NelsDBzN2b6JT2M/5J+8A2VwgcvNjDkDdKFRaz
 L3JYk7gq
 9m/xnAnmbLpwqalAbqcVkTAGvkrEwkh042GZohyrlmQXGlW+8sBF5sSV9fRtTykALhQVerOmPBkb5t0QdrEFNrDQu4Ot7QKue8KaCuufNZCPErJ2wowIhjMROEu5jkqQ65y49asn1/Sq0gqc3WQaypwNeVpuzYXVsUXjziigOPx0JOwPaI6dqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
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
 include/linux/minmax.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2bbdd5b5e07e..eaaf5c008e4d 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
-- 
2.47.3


