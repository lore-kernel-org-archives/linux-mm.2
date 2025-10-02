Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CA9CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85058E001C; Thu,  2 Oct 2025 16:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C588E001A; Thu,  2 Oct 2025 16:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72978E001C; Thu,  2 Oct 2025 16:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A34D98E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:55:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 503091406A8
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:55:35 +0000 (UTC)
X-FDA: 83954380230.24.34EBF5E
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 228C6140007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:55:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FTGwvnev;
	spf=pass (imf26.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=bLA2M15h76woZ7lOjOqF/MfYps4KmcsT/Vv0ArnGxVcTqmuAxeYfOKPUOCVjXQGaoetjZ+
	Z2Yvrrc9CbPh0uJMBDxJ+8kIN+mhkjr8860eD3YCJy0R2gWHc4pQclTa8RY1k22wRmn4ZU
	qjL3+usxeyLO73w1ZOp5acav36KGEg4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438533; a=rsa-sha256;
	cv=none;
	b=J7oqUEZqPECXUdOsUvER3DsGQHPp+ZNFhYu79F+A02hhLVaQjgyomsqL6qsSkyO2MTzu/E
	Ir0q3KejcnNX9KMlSOWGSW8I80pSbGtfA9NVRkdsyitQ6LcZegm69TAbw3A1g4eCGga73c
	LFS50LLuiiu8ORzwk6oQzJD8a2JZ7NA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FTGwvnev;
	spf=pass (imf26.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438533; x=1790974533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=FTGwvnevrxfI2DWDIZ4eHvaCCX312SzLAPM4isrio4saganFe+kwf9Hv
   QGiH/dPtVPEFFpCGyyLtS6tHz4jbIp894Y93EB/Un3NW4LB4QJcDNVoBd
   nEyNYVEhMki+4kkYRWKISV9eILMBuBPNwvrXoY8fnR5V85BCBHV9zcldK
   vYwZFJTP7MOpWHWKqEfiP5cvGz9sOTELH1EyxFymNw5an6YS0ikDAeTjk
   nw6dsv2TPYr00i8H4+hi34UGC9BQz95DuqBzSW2xVI9FMl1dtL17AHrsn
   hSmx5kRoQEKFipX11DYd5MjxCQrdKjOmO4UgnzuSGCiftUnizKAl5UYil
   A==;
X-CSE-ConnectionGUID: w758DzLjR0WOdjDX61Rabg==
X-CSE-MsgGUID: CNMfFqiKTyOeBvKtI+j5Zw==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="3028058"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:55:22 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:10348]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.52:2525] with esmtp (Farcaster)
 id 5f6d6403-b502-4efe-a0b7-4ea6cb06795c; Thu, 2 Oct 2025 20:55:21 +0000 (UTC)
X-Farcaster-Flow-ID: 5f6d6403-b502-4efe-a0b7-4ea6cb06795c
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:55:16 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:54:49 +0000
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
Subject: [PATCH 15/19 5.15.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Thu, 2 Oct 2025 20:47:29 +0000
Message-ID: <20251002204733.35652-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 228C6140007
X-Stat-Signature: pz97w8589zxy1ht9c1ndztkkd1cygpe4
X-Rspam-User: 
X-HE-Tag: 1759438532-799200
X-HE-Meta: U2FsdGVkX1851tTjFwej50lpf+trR7c7XKTxxSVk4nVNgVxxq2de1odyJwprjQ4y0JrvOeNay7bUEwurWo93bJPEOm+78FHgZAEHy+HbGhzlSql5rZNXFM9ORxwZAQTCCFuyS/TszfD1XV3QZgzJzTGuFKeqU9Fv6W5T3KYsJP7q1qBhr8/wEnft1yq137dCbwneWcURie1vmuCqk5yqWlledBJVKsM5neGR5CGlVu1z7Nvs9EylkAikjTkmwDrWWpaKImG9s0DWY3YLklrugBXcJEuD/4ThAOsBzud9KYX0CjgAr3qpkKid1jh7N6pOeeOLalwnNIGk+do2DOYcKKnlytvaECoeqjLRZ2QBITfSiRbYBfcje7th8SIznZcJZPpiroL1boyddKqO4ywWpvbOK1/z0dCss8F827rOxI3agTxnzzpyz0y7RHpoMEpC64mYQdg7Sh6Brs/H3Wvc5y6qcCS87erPkxGgLst/VYNDfIvsVcf7MG9SLfhi0qXuftLiKY5vJrsL25Bj/ABTXHK5KfOSn+xDOfxstdvJ/HnPZma5uEaGxnxp4v2b3jgRVGcxE1JQsca7VYr5CN8TJXXoE5MVaz9Sfiz0DNMIIzjp3TvrQCXNFoipVDQe1OeMMMcGAhoA4TlrZPtxaUmGHYYyJqF7Qf/CdwQBcVJr9h25TQ8dEJRUpsknSfikBnhXZXhYhuV1h5dMDGyg7LsPLJ0H5+OH/o2wkx8wxlfST5k4XMRaCb8kfQN3uU0gKsr+YlIznCngQmUuvcIJxotnb8EEXLCZue2hiG61Q+SiD/hJFot2R2bbiA5YaCrx6Xc1Op8w4WvNlV4m5qWjoxw4dMNMT6seEjyhPhccQeHV7eA0tGKF/IPMTqso/gTQrorwSdD5uP9/MeIUM432kljDO3AVTPydYLoAdk5Fju80+sQkpAEhJpUr373ov60DC1PsjD0gQaPTJ5aZwN/Lw+Y
 nWjl+RLo
 94+KyBkxbWClFAAHGBBFXm7V7BR88RnJtmCHOJrzBGyd6F8pUx9Meb5tle1P57xDRCmM5gLdsxQUGTkUsRoFVj4+TIKvhBaqV0m9hkxt6Q2ByzVA2OJ0LC/mmS5+MBO4wFgIwSPnx5hsnnEMV0C4SmDW8ZbYFlw6zhb32PAE8DoHqNu3M7tA44RxKKOsKfwV/SuhPFaMDNqUfFYNYU106WG7nb/k3t7vvpPOKsYzXxNqDAu1qVuVhk5MHn/X5J1d3WeGVFoPrQRQALYPboSZcP0SEkSp2tQh58g45CX+GB9ocy3yCtFJaM4lSorwIQ98OcIKrXEEjqca7UOHTLLr0XCILIGPCI5GZKRVqw4EC/b5pToS2WIPJHetM3iLyKy0Mr2svdLb9bxoEpe1Hi+QyoILvKVB90C743u+9Rjbx44Bw6r6Q6Zfq1Ng+XA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 24e4b372649a..6f7ea669d305 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
-- 
2.47.3


