Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36E9CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E8D8E0019; Fri,  3 Oct 2025 09:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF458E0006; Fri,  3 Oct 2025 09:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4872C8E0019; Fri,  3 Oct 2025 09:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 348F48E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:08:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED63C13BB7A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:08:49 +0000 (UTC)
X-FDA: 83956832778.25.291EF05
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D40CC000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:08:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NWG9CUww;
	spf=pass (imf28.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=daHzze2JuS7aEJOARELRSAVBrG/GqkgvP64p1MuyZiMtURg/USPu+GyuDGw4PfJmNVGCI2
	iZbhVEFfVPHl2+/cR5/hFL422L0klu4/o/kwC6zlfFjdKxNQfClnq2vecITWGDipVzzlr5
	v6qMziakh3MqjZdm/7n7SHxtXBV1ZVM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NWG9CUww;
	spf=pass (imf28.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496928; a=rsa-sha256;
	cv=none;
	b=hERyvHrLkRITGMfhwS67dEtZbe/XqtfoZS/NPSjyiT6jzjngIVmCQRPaW0c8SptKa0x5V+
	OIIaUBw01SFD62wrPY85p9hdlbIwz0YFbil2u53Hr/bVLXVX8PFjbaqp2MQUAxlSXW2GdO
	PooRwdqLENNEfu6Glq9RXmY0BI3W8FY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496927; x=1791032927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=NWG9CUww40GVq/nCCvA1ExIi/guOU5JENPBL6kO9hHt5jAejfB7tLRVS
   aGtXAPFVuNJDXUOG18q3ZW6fbFV5vy9nVne/HIvoipXeXVL+cVGce2cRW
   J7+LxoUvrRBZ9+tbaxW2lyUHViosX4hP1J4kZcVBEKm325Sd2lYq53O3h
   aX+deAqwHP6GYesNjQJX6P1jgLEbw9VQEnX4M4CCYbG86Bk1uRG3ZM8Iw
   L41KxNabh1+Bgh7Q9H+qu900F5Bde9Vghoiyj2TP0THi5obzNwnwfB3dp
   ro9c7rDb6zaRM1aUni+ISxJz+HFmTegxkNMEBQ4O3bhyDOzIn+OSUiGMK
   g==;
X-CSE-ConnectionGUID: P6E2GbbYQx+SKkGcI3XHAA==
X-CSE-MsgGUID: d6KVPbK6TEawnmtfkxxOCw==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3064254"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:08:46 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:14296]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.121:2525] with esmtp (Farcaster)
 id 241bcd0d-74e9-4577-a094-c4b66350085f; Fri, 3 Oct 2025 13:08:45 +0000 (UTC)
X-Farcaster-Flow-ID: 241bcd0d-74e9-4577-a094-c4b66350085f
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:08:45 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:08:18 +0000
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
Subject: [PATCH v2 17/19 5.15.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Fri, 3 Oct 2025 13:00:04 +0000
Message-ID: <20251003130006.41681-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 9D40CC000F
X-Rspamd-Server: rspam05
X-Stat-Signature: imbkqb1zzfy4wcjxjzw5camiac1zaq63
X-Rspam-User: 
X-HE-Tag: 1759496927-994194
X-HE-Meta: U2FsdGVkX1+ldXJzAHlcrhrnU+1b9HDKzPQSKHlet9RZtsmOFUlcYOsA5NKx71l9G2xAll0n7Oban+XMiRPzN+HUsS5XFyQ0X0I3Pkm+aWY6rkIKil7dgCMz7fGvrN/8HhYYXqUqKegt5Zhp6Zydu1Yy9jQZD4o1ueBvAdbelX2ttwa1wWVqsJTJ/tZ2IkC0kCq/OrBgvVUqWkV9IOJp/IjEi0X+2EGBqoIZHzffTLGw3rKdhBw6eCM6ZNGD6DRL+5u3L+dGGOUOkcGQz+QU103GAtajClzsFIbLqZF+edbi8hx+H/1/nAgtYRg2IQakfIwwjvnZN1Ue8v7/4AjfAh/XXAl+SUIQdGGy2CnRuunHdjyRwnQ/BGmmjA1HokmvyLiGivu6+vDKURjwDVEdqJhP+MhFdCyl60V9nOraDXo/cgvocordwexlW0Z1OuUc5X87BuCee/XkNd7wbJlCKjxSVl/sC9PwPFFvOYLOt+DtQCgOhASPHs2lCkcxkeUGQSNWYVRBMS9Nl421uRo/73JrjnaAD+YCbiOcw2aE2ueAInEeFb7PE+Db5nX68/sKwOBaXgTC8QKG+s0dY2XQSBiUnyzcZEkyfrX80XaV1BSp2lYqLfuN801OApoghkLDK3Uuzyzp2ng3dp9bkmULDLk2Zosnn3VAl+X0o8PFhGCdhaN2eJ8SKpUJ+NNhZWA1EELPsCyaWNREG/eUt0AYnIUsK8K+ra8YpnQLE3Dn8SO90gm38GeavUmpiu8bBXM8jwEGDWYMkIXpDBQ78SLlWmU5a5X/pNL2z+Z0xJ0jIdDM2GdMxxZHvVF+FSwaeiavm6jVoz3Qzha068l8AptZoqXKIgLxkysluvjawXKTWBPrJWWDMv7cqFzkHNT1Q6pbBH+cw4O7ZX5hCuyedqWbSVpQA4ZgXDLrscfXs+O4dyRp8ljr5r5CSevvodZEUwTAkie0yXRikVFt8p46q5Y
 jqLpueqb
 ae4Srwy36UITV4JAp3VD9p4/EZ2kbbEwwFnF27bypFtg/PicGS5SEqI6dSnYr/pv8L/ZMVUUDHcfh4GRwasRcqHXksXoCSDLD+9KVOm3je9VyC+18+IlEAhAxqQqlDt/wOjN50/2Ggygt762iwlHVzlPD48Nl83hEdtCCXMGqmfOeSulO9rzvfI+BMvv4hOtPEP8jBUaF4ouklTsbHl9+r/yx4zDn1PaesFTbNFQdxQwvr+qiZRqqmSvTvv+CqBGI/GPIU/cQ1B9zxmyujNtn8D6X/QscpozyL5khIaYdYHQiraivLiu60ww5icASOS6DqMC5StC6j+ledeixTOdjc7VHa7/qOSGnZ70JOt+tBKSRo6cyop9179CHpj+6tWouFMoaZUlaLxS1NohI6b5eXcSYRX2COWAvdMHnnNTrKkvHxL4m22eR3GbWhu8IRyU2IABbsiIIeTuLraHsegHT3BFSvqoxRON+fn4sVEYC4t3YFQRYIxDBbffx+bze21udtGsy/a43AWafFk0DDn7nyUI7SyS/PNcyrBH1Ye+APWHY0hT1fHM0J/ihLDzvLrCqfM4ymg+OLq1qxGdM9BzCJfSw+5Xwt3Eryl+zb47MCJLDjF6y7NwnrU/zoHazGiHQ1dTxpZTMFs2EykxiouHIEEGx0WNlAknWRocxSq+7kKf71AOfhDEUKBV+9tl1n6bzOapyuJN5pR382dgNcwdQ5z5uObYm1WIybKH/5DSMScSs+rtLKhzjLTnMTHJTl6Ee0LgT3vUufBxmtsHVR6M6kJB9QNUMQeL5Lr4l4P4lpK14fngPLf6dmhYUR+PgyUo/TZ76iUW5ZgL3B4L7bSAzsVhphXHuigoevITDObD6W5vxeTUCNKdjkJs1RTSWUAlyki1tPyHN1+1CbmaguzkpRLm+WKjtMUHwSxSmayLIwXUR8+LnPQXGq2HA3iXY2hQ3ETePsiLU8Xy3jfbq4aa2qVkk8S0m
 Obft0gOC
 VZ/N7+KMHnIxS5OB75MANYwo95bDYaiXVUTCyOKnY+O/fk/1qUcBLNoUB6TZfmYtedPI57UJY3RHbyrCgqXjrQA+J6aWD3i6JtlXjvywcikh9RCucdp85Lnu20eRfslf2RrZTur3pnhSwrmbqO3SNAqnMF96Xbvm7cNhDqPwf7XYHEy772MChg==
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


