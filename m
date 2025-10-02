Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F833CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A868E001E; Thu,  2 Oct 2025 16:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2818E001A; Thu,  2 Oct 2025 16:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7088B8E001E; Thu,  2 Oct 2025 16:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5408E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:56:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D140C068A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:56:41 +0000 (UTC)
X-FDA: 83954383002.13.82744D9
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf22.hostedemail.com (Postfix) with ESMTP id D92E4C000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:56:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AtNSUsVo;
	spf=pass (imf22.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=O6MqsQG/qOMhVXbP4loYOgjZpbfCaHLw8iIlMMsZsOi6/Cds0SiCRI0n2wKyZOfdRuoQ3u
	MHxepf6wTFSam7RV0QyRe0uoy9F6zNWby1bRbZAuSSUKBcUgAmVJzn9gsc+ZCtPZT/CXTF
	88NMm3l2fDxSdMEFR7eNgEmwpkHvGco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438599; a=rsa-sha256;
	cv=none;
	b=SIPcoqYtGteKKN3gJuSFnP9X7SsEBi7rxI55V8wevPjEQn6cbg3hyJ9pTD8WIb7IulwrTU
	mCGlzJPr9F8UDaGetAkp0gm1EFNExz3PfUruoqU83/5COYBa2fUjmLellZXdNVwFx0sogL
	EfE/frLRbiFGd5LM9KpH5fo9IjIl9jw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AtNSUsVo;
	spf=pass (imf22.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438599; x=1790974599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=AtNSUsVoFDxALGtcksv8LBhV0Sf+VycP24ZcIoTrP84PDf6jQFuVTsi8
   kESS77Ks+J5Bybrr9YlRQjtUJBD12PtkUgPQWQlX5qkBLURyLkhxRdQt0
   szNy2zjvVi45NT5d9v6GYxZBY9dNPT91DCfM8QWQOhwA1lTmzgmf/5BpT
   ccf8Yf7AKHNObKPXsSQjEWxiCJMnXqEeN2HhjHh3758O3ixfJ30lxHnWL
   0oF1eIMPdoPqX/6KltZyCEFC3rS8ErQjzTnedck2DOuoe8HvmH35G7Md2
   emvxUnHXkNmASRAq2QtnWg1CRJdusdwlyFyHbZqlWu9HopFab+6aqjHAJ
   w==;
X-CSE-ConnectionGUID: lVnOTx8FSBmPEuD/GU5mbA==
X-CSE-MsgGUID: bCsX1AYeRWOHz2xXIQtmSg==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2927040"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:56:29 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:10312]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id f0969eba-b91b-4df1-9132-ca72a5d841e6; Thu, 2 Oct 2025 20:56:28 +0000 (UTC)
X-Farcaster-Flow-ID: f0969eba-b91b-4df1-9132-ca72a5d841e6
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:56:26 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:55:59 +0000
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
Subject: [PATCH 17/19 5.15.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Thu, 2 Oct 2025 20:47:31 +0000
Message-ID: <20251002204733.35652-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: pi585ewige86pfph886iw8rf6w1iyegn
X-Rspamd-Queue-Id: D92E4C000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759438598-289255
X-HE-Meta: U2FsdGVkX18fL6jvRbjbbX3fF9Nb90gxAm5YU1mUuBvFAL5FK/xXx3sjLMn3+ptgeLK9GaGztoP/Z4tMhyh3i7O3l0E3F34D2C8485YUqOOrHLRNbReMAu/nOvKJo5udx0671s95ePQ9iigMOMCSCkQFgavEIE4eEPOWnNOaNEvnnuia55FHgbXz6T1OXT5bXrys+5Qwt/l20tOJrEJjLfHgPCVUMeZhjA3T0D01aERJCJTziA36Zg7esSuE2yz8ytcqzO0eQTDHDKAZFZZrSInCDJLZ8ZU7+RmQqAM47bx0IFsW2y86T4rjglFeJUmoP+aKuLYY5JCWGkaB9gVzsV+gimhyllNtFtGvprOl1hcBOGuymple4RHoPhSXLyNreZXr14ebQHzO5tvnxi0CUoh6Yvde/zMMDTN+hwoLj71rkXYh+4f1wWxz/JCRCWRKBVpGaFmo0yxaV21zrnUAbyJx5StG36OJOxmj7m29matSfMTrm8rN2+TRX6BMyNe7d0baOwyNp0KtwQZ8LxLBbKx/3GDGQwcl0/OTx7Oy1eXcsIzmiVeBKQ6Nxc2zhQcqqC5kgNLGCbnnSNoGqPUj4HJjzhRIdJR5pRaa84dwGgBTMUTJ+9o+LdOqUwYtHi8cwOgOOEzqP1mZVKEyrOgKzEeOY/R7wjCafk8uoewJqprrZLl8cJZybD7xibVGidIrf+owdVgULF/AEx/8SlZBCQnBnlThK4tVjVr9RwkNrjg3ciz9MSFG1k/OTCaeRGIZR9ucd/jk9Vp8s+FQ6SHfBSbRS9QjwTPHWywfh4woG8Their425Ssbe316UFHH6RA947z4lVHxd0dWBSFeEMfP+FslAVDc/tQ8nmlUthWHEoiCu7ApRgGSvxvapTlwiFmsX+sghkFta/04laTxx6nhorhzc9e53CXO3GxfcgYK30FEpgRaXFjkF370ZwP4EMhUB61iPxVZvzfbe8mvrF
 pEF8srjZ
 24ryTUmYj1zs6wSEJOhUbJI4aVB4+3MnfoyqJUqap6FzlZzSAaowl3KoGfd8PXK85iPs71FwTtk8eLbHbv4QXno4//efQ1UzDoMm1zCK8SxJEMVgIQ4XZoyv4NbnZqQYJkCO9niLc1iTrDqOhkHrwtR+VZrSi04Flm4olW04gomKtOYk1cBbRKW6irle3z89Cz+J5usc3BxWu1+eWd4i2qvV0Qhue2yj/5TjEpK5ofg3lwPxHdji6nPsu4ijxFMbxWRU7OOSibC6BrRn5ZAJllWgheW4QbJ6BSFQPpY1VN70i1YL+xzxCpKjhK2Wp+3Qrh4uxqGkMC3LdfROLz+0KZxQZDM5glc0WlEJs3KJnyPnLI8EkYBl15D1GyJlrFC8etZI+jedMifQS2gKeGLS88BLsfvka0IDuNv1dwJgJVJ+C0HyBB/v/5X+mAcrNGgz+FL887bcWu7NGtemtc4/CL4/Ei6SNSz6fqKqrUf/alJs9EMwbSLfu8Xz2MnbLjbyPmXmQrGHpvERq3+XsnvzF0OdTkh3GpNcR16CT9vCbUtunwRJCHp/UmnHdKxfVTIwHRrgUlJOadNsdGMrTQ9xhM5xzuXXRxGavAvkb+3dEbOs00A6eK4ptQpLSY8cR3V4fmYg7iirUy0fGKmDHuSTBXE4mnDbkEb4D++AIDR5sfVgRlSnVpayw0dcsHTTXsk5kix3bP9+VT0R926vTDk84J19edpH3n76QExNLn4yAqIFS6ozR7BKfaFX0+iu6slrBZ23bGnzV5rCgnxtOs50+WYtPFUdq7c8ZDaU4Nn81cB0ppuqzPKFzzv9Is5tQogEJ208VnCe4yzWvP274GMkOurQOkZ/w3ksxi3F42xmNupNt+JX31E6jdGlYcZoJ4gkWFlzU2k1HqXygonnpyQ+Di10XRizJLXbpEirkFePQZSSeovIaqLernjupvYEoR8ldtK/TGpuiLLDVJqfi6rR7uhw+H7Ko
 FlhLrviN
 xeNXFXYnu9QO4yCz2cxoe/Kld9EcV/HYzvm9ha2s0rYCYlRWWS4TfqFYG9U2IbCufr6Nt/BCQAXnqmx5Mo7mjL89vxWR+HPzhHzUOc4+4CVee7kUR1zzeI7Fg8f/GDIjiho7a9mJp7lIdKoHXM0Yzfdko4Y9jOJmDzO8nIdLZqZ4wn+DR7ySXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
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
 include/linux/minmax.h | 109 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 91aa1b90c1bb..75fb7a6ad4c6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -170,6 +154,22 @@
 #define max3(x, y, z) \
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
+/**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;
-- 
2.47.3


