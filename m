Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9620DCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F2D8E0037; Wed,  8 Oct 2025 11:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45F18E0002; Wed,  8 Oct 2025 11:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C358E0037; Wed,  8 Oct 2025 11:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5BEE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:34:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7141187B92
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:07 +0000 (UTC)
X-FDA: 83975342934.29.54F935D
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5744240005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z2qmbTET;
	spf=pass (imf04.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=tz+QQfR0XAv6yFvBh/x5IeVO44JTxlL2qmMm4Y6dGVyLeQx3+4meiVO5KOswOasmnem11F
	9m7vZwUGX7ZEhrqaAxHeaGSvN82wC2jo5GgbLYZQ0el6tSlu5nkHwNWglmmwZlatnwb6sv
	Vk7q8eQxfoZVBcWIZGps29y1R0d4u1M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z2qmbTET;
	spf=pass (imf04.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937645; a=rsa-sha256;
	cv=none;
	b=agr6M/RkujnklkgDBcs14XfdCfjEE99aEHvkDZ2Vki7X8N9fYS+12/ur7jbFuZBR706jHo
	KADg3AxnBELk/Kk+7Xbu07GF2fEXKUvNkoxMWd0m5axjKOWncqUUtdh7ObLmvPajBwztb9
	gydpQvyIzJDHR6QcQ+RERBcwp3n+ZeY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937645; x=1791473645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=Z2qmbTETV3PxbLv/qirIlXcAr+0NECkLUi1S5DfbWYFnuao2AOHShYzg
   WdAZSmOvA+HTiTPxG3waFoKkbXC2GIYi2gHk4jgAsVkq30yZUJ8a29Pq0
   tWfhUfXMpQ/p1renrzK7e3XNTXULVDmct+GdMc8jt2D7WlhgAXpxl6Xhz
   4ywmdNvAV5G5o12v3DMyZjFL2A+plBX4Vf386eyx9sakawGUw+/XuOyrQ
   9SNQYgf0Ni0yOGR4ehhufCJH2uX+beN7IZy86yTWrHQs8rnPW0va/s2qF
   Y1nllcnmdrAiLg7FrPPkkV7sJ+/n4FI/DHdRYSWYPSRqkkdCT2sPQoZXG
   A==;
X-CSE-ConnectionGUID: wN9/yR1uTWy7wWnGw9KtMg==
X-CSE-MsgGUID: hFx8SRMcT7WHNkJhVymiXQ==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4534333"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:34:04 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:54436]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.125:2525] with esmtp (Farcaster)
 id 79d525bc-5784-423d-96e2-ab266eaa064f; Wed, 8 Oct 2025 15:34:03 +0000 (UTC)
X-Farcaster-Flow-ID: 79d525bc-5784-423d-96e2-ab266eaa064f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:34:03 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:33:49 +0000
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
Subject: [PATCH v3 13/19 5.15.y] minmax.h: add whitespace around operators and after commas
Date: Wed, 8 Oct 2025 15:29:38 +0000
Message-ID: <20251008152946.29285-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 7mpp6wm1m5q8rs6wbw668b8b8wqfxtyz
X-Rspamd-Queue-Id: 5744240005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759937645-660086
X-HE-Meta: U2FsdGVkX1+XtyrKfYqDCyrtMo5Wb/UVSA1uyo+5A54GTAeXO7WzTyz9XVA9tWswb8kPVdhv1pfrG+emIOpUMB1xPGMWKCI0FUNoVBJddYP7Eyxy7xYPN0WVCYkOgpVWChjBWjEdnvgTjRZ2Vh1SsSe8mzBTXSU6tAATDUPB6R+2OxFdH14FgGbOJ/ypFn3CCAr8qIXYT6qx41+YTHyHEDm5rqAuRBmQOXELhl9q/ml/7bTLAH57tc+v0iMoM+Da3kchOJl/3xcfTcIwMkq82uyLLNtBbjuKPys7jsoz5WpWnO3c5f1t/rtiIgfDmpO9Ye3OTbK+zRc/eS482Juk1n+E000pGNP3AJIAWiyy8RGGY+th2rsp5l/q3cvGix14aOpbQ1tOAZUWgFjufGSnvq2Cc4NpBF6uOgtIquYC/dQKmNUpNMfr4uRMDBj7Sh07AXLiIduOBN1Fm1CH/2kRpuPdV4YvrjnIV+qrPZpA3cue3byX3C+gSu1DLPeV4rHqrSHhR3JJ2S998S056merpDlur0qmtvjWob+fdOecrhd3UndCMHEIXzHmF+uCRfoL9VerPfU2qfpTGEDPH99uAuOzfyzgx8C77Y6nmK2V7jhJbOE2HMIT6egpusMCOkoomnkw0FexhkjR537uDWhqnMBO++S3YbK6d9DEehU3LwU2JiaRarVpWj9FCdXxEXqlHcG3S5T2ZhN0YwBgBfFM2YnfxHj/kG9s5RZUnCfcrLlqZqtkV1Ia6aQt4fHyywvA1r8Q4ZAZoUvmq+GRgeuasMehcbdSsqr8WIFdsCojzxearSC7J1RUtZ9N+k0zI6+RUQwq/rs1nrGEhItzOTpfNQnLGNT5z0B2aGy6M0OZ4QJlJj1rErMPOWeww8Hk5Rcms7Ly5C//fqmjtPpphQvKVYEz3OnCCGqVjLT8RVEdX+QgEOKpxcU+mEVE8zEiHHE00Ufz03/uvxtUZsxEd1L
 wfkBgevW
 V5XFJiYZBQRoG+VtUbDOXDPG2ZxW3uQL5NWLh0fbosFGjs8K6JumWVx1WBqBGc8u34SCZ9lHHwr2LHbsifYIYMx4GfN8iWm2ZPD2hSshSS0DyAf2WO1NbepQFAPUvUqguVCTAJwHemCgRydihAIJkd5iMMKGZkTq9UyBodwC9axCNW+BjAyZN6d+jXfjz42DXcinOCfZuwW2O74ETWaepx5TQvF1jm+iWaVkpEft0z+55DRlZJUlLZ1Z6c4zFRCsuc8y4GcqWrN+aqiXiyj7AljWifsKIGybPEgrplgpi7myKLwB2JSVC99QHy1eILurJu5ING4gF2ALavgFTu18HwDPN07e3zZJ6aoeGT9fMi8+btF+GasvwFrJzceqW5qxkShbre4bxfM/uk5lRKUmAuOGVuDoCuyqbvwqAWDP9Puhh6D/2kBEv3rGrnvUI28yK2NIRT66BfnZPNDM0sKfabCspP1DKLCUtHpgbNMlblc1oPuHg9YAbMVKwXI3hYsYbpSgKdjSqoK986ttJ1C63tiCWuj85p3jJ0YHxOWwklANZlflwuGkQGPpnWx5lFwVttYmm4+VCJe4VR5SoH9bOJTcW0jNbyLBkiqMfBYnsO1ox0Zow/voTQwmOti66HbgqgyQAYf5dGJeO/M5FgwJFg95NaXjSlQuAtnw1i+8M76ChMyn6pQBI2Tt0Rh3Aniof/75ozX+Ovagfr1GPA7PayltR0IO/jRtdvc8tPFbuMxQnhPXH5/wJlo4iSXkjT+nHcHkueBFWk8rgwOnDhJWBnCidLCjZ+jFkQjLjGoJWz6rNAtZFevnfETl0OAfCJJTzcgW2wMlZQJsvTsG876ZcpVM/C3mThYdRYHZ9GMtKqIrr0mbxXoN5g0qizBUErRy/pyKJN2QRLwubFyQgXIRA5T1DtYKK4dBGe305uVCybEfTu8aXR3wTxZLG/5elU9/6hk/sbeSp2qF35S+SJAhNXAddSy2P
 b22on8fL
 MKvZGM30dZic6TpU712PRfyxSojfGftPbVlRIJwFy4n3jlEhGZ+f31vyBcaDbFjsr0ech72seO9mzhFpSMxIL8V3YTviAcCgBy4O831lr6qk7jhIfycbFLWkSFjWapvAFac3cm0NmzolKxPXfWm6Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 71ee9b16251ea4bf7c1fe222517c82bdb3220acc ]

Patch series "minmax.h: Cleanups and minor optimisations".

Some tidyups and minor changes to minmax.h.

This patch (of 7):

Link: https://lkml.kernel.org/r/c50365d214e04f9ba256d417c8bebbc0@AcuMS.aculab.com
Link: https://lkml.kernel.org/r/f04b2e1310244f62826267346fde0553@AcuMS.aculab.com
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
 include/linux/minmax.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 98008dd92153..51b0d988e322 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -51,10 +51,10 @@
  * only need to be careful to not cause warnings for
  * pointer use.
  */
-#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
-#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
-#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
-	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
+#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
  * To avoid warnings about casting pointers to integers
@@ -74,15 +74,15 @@
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
 
-#define __types_ok(x,y,ux,uy) \
-	(__sign_use(x,ux) & __sign_use(y,uy))
+#define __types_ok(x, y, ux, uy) \
+	(__sign_use(x, ux) & __sign_use(y, uy))
 
-#define __types_ok3(x,y,z,ux,uy,uz) \
-	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
+#define __types_ok3(x, y, z, ux, uy, uz) \
+	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -97,7 +97,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -114,7 +114,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -154,7 +154,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
@@ -326,9 +326,9 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
-#define MIN(a,b) __cmp(min,a,b)
-#define MAX(a,b) __cmp(max,a,b)
-#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
-#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+#define MIN(a, b) __cmp(min, a, b)
+#define MAX(a, b) __cmp(max, a, b)
+#define MIN_T(type, a, b) __cmp(min, (type)(a), (type)(b))
+#define MAX_T(type, a, b) __cmp(max, (type)(a), (type)(b))
 
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


