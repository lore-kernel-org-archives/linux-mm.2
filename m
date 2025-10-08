Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CCDCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A00D8E003C; Wed,  8 Oct 2025 11:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977E38E0002; Wed,  8 Oct 2025 11:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E768E003C; Wed,  8 Oct 2025 11:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 776E78E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:35:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28825C0598
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:14 +0000 (UTC)
X-FDA: 83975345748.01.8EC5781
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA40514000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=krZ0jhox;
	spf=pass (imf09.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=K9KAR3zF2VY8fXkucQv7ZK4kcHn5GGwrQYMkFvBJdR61C/vCrL3GhXXGh5giqlbLu5jMAh
	Q8RjC/QT6U0fZu7BwvwqRlrGDhHs9cS038Yog6mXBgtirZz7Btc4iZPWOd1LA2LBJCRl0l
	lrApbH9Z94JUGiKTakuVMXG6W5tzOEU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=krZ0jhox;
	spf=pass (imf09.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937712; a=rsa-sha256;
	cv=none;
	b=jKHHb2KrWN+TxJrBgVd+KngJSPeWB3b+V+zO8FrVWT02IjUaI3qAHFh8ovgUmUsttBkgbo
	zI0CFS4N2v7Nl+R3rUPHAvpoiKUZs5ScL7qvV7AU510zPO9JGwsTjp/BmIux4uJxTtn/wC
	paZWhyKnEHqsPdhTHwxFsCv5rdZ0L4o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937712; x=1791473712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=krZ0jhox2py+hy/eE51M5XiMHWX/jklIHpPEcLwcdxmQZ93XJJAQXstG
   ttl2kv0rILijJLhSFjJJE2tEXxu1XKuqKP9mA/f+eQbnVA4k/yZF4hz1x
   l9Z/AT3sIP5qW0vPQ4IR//RnMID19aHF80LyJuykxaOYAWNULIuwHCqH7
   9qGNwKQigYwxt/+sFFYNHZ0RgdimtWtnQkuWdgFnvxKLB5w4tmuYSkuv7
   X6NLVlRUGIfNEsvnnDfcke61SjilnBC6z3weIMNOWZnktay26OXgEUo+s
   7ipzOULGWEYWMd0srjXry04yJg20N2yd00fuDntasbY6Nl4igqq51/xpU
   g==;
X-CSE-ConnectionGUID: JFTwpYlxQF+OdSuop/1SoA==
X-CSE-MsgGUID: l9FLg6/oReqAeyRn+sHnCg==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4335187"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:35:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:60851]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.215:2525] with esmtp (Farcaster)
 id 4967a172-733c-46f4-9c4f-9e2cdf3d821c; Wed, 8 Oct 2025 15:35:10 +0000 (UTC)
X-Farcaster-Flow-ID: 4967a172-733c-46f4-9c4f-9e2cdf3d821c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:35:07 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:34:53 +0000
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
Subject: [PATCH v3 17/19 5.15.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Wed, 8 Oct 2025 15:29:42 +0000
Message-ID: <20251008152946.29285-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: EA40514000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h1edkumuhwnd3ufaxwngsc4a95ci47xj
X-HE-Tag: 1759937711-425269
X-HE-Meta: U2FsdGVkX1+CvL8wEszX4gczg2Kd2k5FAuoHA5CoNXU3qVf625N9qd85Pw8P5xrKzaxMzpuaIZUpQFpuG7QFqM+zRDD9YUDCNJ70hvUGCd0T78f13CB6CsI+LLe09VeAjEVQn7fLOvT0r4Ztf7Bpq2kImVUMxi6wuNdioFkb68IFg6IIKibOlmZQAQqPOgRBnY6jGRo4EEcyLtTP3v0oSfJvNU4sj77Qh/C13MU6QiLLVDwKWRxMx/8RHYNrVlw8Qanlz89jM/gLnPvpFYOscq31+mJ1rY3OvGWHI3kVOcEprlmEwvaP3OuzgvwvGX69tap4nOJNZ9QKsdCF5XxnzGdOAe3YGZvXCQt8FRFHYsJHPn/vZkCl/Zm5pOP0SOfegkS1qoq181hmsBsCcj0xA6eEsSvXFovdJAd+dCszAEBKlFzTcT2ZweuGZf4YD3QrA2OME0j1g2FNgM3vMUJV16KJPCmyMZis89uR4XzfiDN2Gnh2s1nNiClUWGeCPGM6hL7XeWuc3ud5riT2+TFvKv7qxES1TPr2TEp3k8NwD2YvAJsKTKeyKYTp7cjoSjao1jqdaj//OjfpHxJdIztKSvb2Y6bRR2TFc7V3K7f6kbZgpcd6KsWlGGdjDDS5C8FKVzHWts3Ghi+9Rz2kusRmzlXcPU4em6Ocrwe9RwLV5k+Pk7u48jcZsD2UV8LGGQyDIm37n6hsQYv8itPijJJq9LpW0FKdHYEQrFcwbTXiMfIfrwFkJxxHs0Om0+iNB3kmG83c4aPd43tP7BNac/N1x+BcXkFJDuva6ZmaQtrXptMcK5tS0+F8gKCW5uOIsFyA7QttXezm7/rvT12Zx3AgyGhudhrWOKb8lNCiVPr5CEtAQsSzbfmkFO7A247QYsXuLwurTM0ayMpXxVH4HiPuxQUgfQjp5E9i2QpTZkdrFjefxxLg3GCKTRHxJyEOJf8EphylVnm/F0LlJvEvuEq
 cSb8qnYX
 cB//bOnMM6BbfbSulTq2cRLSy2tfPLwMCXksKxH5ejXENy0+8xms8FGd8bKxgsLJT2Lk93Fr8i1d6phUPOW2dIYv1ZpdqwRKtoHXzU7Kxd12lVwHQkb49toWE2Jp3u3gyeQ2KHWtTlGdTP73B3ogPB8UjDHxLzbZViPEJPUZX4tlIFj2lGZr/ejBqsXxrvdLd8TWgTw8IOTKPjk9SvIrM/4E2t4UlqVQzM7ieJEhzFyXABgiVjzSpgRXvA2lIwD71iaNZGavz+fhDMzoSKQwrkkakhaZI9qfD0xdkjdvpi6Z64xGd5QDNjC89Mr3Yxr/oIwJN38uzT0KfF0B4eojWnB6LWufd+4MvU9sagBtpgYeA9i6vDz3MCvTxxUqjl32uPXo2HZRCXKLjL/t2NjjA8ccFCpScoYNXOWV8jKdOXNMFv2CB/wQkXoDOXuU72KqQUD0IUv2crJzpS/OgIEl7APGDoaauY32CgVJJy7FS9pX9Tyg+0MtcmhtmSKMVcmuRXdtznpqVlKGt8DOZF0k1OTXddG1TSyngS48RHSYEftwpB1qYKZNR/ClitpO/YayEDNdQFMmh9MTqq11EX/V3H5JsOqf3gAwPu8/VlvOK3raX4QGpw5z4vT7ho5jQUdg65/a1b0QqBULS3ilm+vAwil8xtfjLWROg3aZgyhHEuw39Kym36zXSx1pydQvaQg/3pZFDzQh+j6io42LKWI2YhnefL98a+E8O5aZMg8D5+QYHFLdSSOEJ1pGR+StCM1ncEzVAyLa8Tc/RyQlyAUErgB4CCisLM6sOrtBrmFTbjO3VOxgSx2eKGa8Rmx/ApdChFmRT44/Byhe9FP5e/2ZSaR7yxmJaUm8a77Y9F1AzqnYBMAeDpgU912PY3Og3vBtKCXbC5MV094Gw2Xy4KVy4M99fChzT833/p6g6O68ELE5ecBOWUKX8C0ZJQHjFtWtO1nt8yl3eawmO/peYmEO49kjS/uP8
 h4K8WZWe
 HqZ1XE8HuebPwbeGkO2Kjg2TsJyO1F/vuCYNE+d0BsF4JsgVDlFeXPPDZu7f/KrUkpeoGeTfeU4es5GZk0knnK3xUhQpwrbBIVzMvulhWyYTstLsL8+E3OGV+/SXBVaJhyIEO2V0Fn56U4jY+arOXQ==
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


