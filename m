Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F158CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1928E0015; Thu,  2 Oct 2025 16:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662878E0001; Thu,  2 Oct 2025 16:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551198E0015; Thu,  2 Oct 2025 16:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 421188E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:52:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D28F13B8E3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:30 +0000 (UTC)
X-FDA: 83954372460.25.768BD5A
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5BBF18000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sGWdrFTZ;
	spf=pass (imf16.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=mg+EcbPQ+L/WydwKKhaYv/cgRF56abMjry0SF0vyxAVggabEbRCu23SuEWRm75mfEBSpyL
	ChZgQyfRAoRjjwzB5yUfgDdWC4Lvtktskm7doPJwFxkkawDvrPhr6Z7v6QyhO+Yy8wTgGh
	UhVjRrZMo/hMLXjTozf7gpBhrCal/TI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sGWdrFTZ;
	spf=pass (imf16.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438348; a=rsa-sha256;
	cv=none;
	b=JmAia/BIi7EM25xlXWOtvgulUiBDC+emUuZnH1wcrQfI/N2xJ006jbSNj0SmNcI20A0lRL
	Uh9oOBLAWimcninbYK3O8k1HO9y3/lnIxHfgRe/zgZi03ScVx3unKRrx/gV94rNDc4VH0d
	egz6GKDsr0qeZPX6uLSZzRrjEgDOV4o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438347; x=1790974347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=sGWdrFTZv+A30lge+RMdSZgFzhhxBXB4o/pQSE5XePH6UgAUaLJCT9w0
   Mcjw5yqo9aN2A3Njl4I7l79AZvAhn7fAgqnj3uqoRI2TPgYq/+LGvghrB
   /n1AV9dwNyjqN9Br9DIM4fUGY9Vhiex41svm9gNS8TIM43FBgaGTZ2uj/
   dHTtFUEvmwFYE82KbIOK85/d6OyysrPqCK3fe6XLVRohOjX7qLe+ypq1o
   p3erCKMPOhH+BZNAsfbyOcOySXGNRAKlHhGpTTJemj/dcLFxwbgVPLMYv
   fpCJPsit7xLTcSojTuPLOo3L7lip4cZLXluwALCF1xbrkRmOgX37sPtjz
   A==;
X-CSE-ConnectionGUID: wHAod7MhR22UT1vGpqORLg==
X-CSE-MsgGUID: gfossYLATOWqowCqaE0HrQ==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2913969"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:52:26 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:9824]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.52:2525] with esmtp (Farcaster)
 id f8d1e173-8db1-4c75-9e58-45e39cebae31; Thu, 2 Oct 2025 20:52:26 +0000 (UTC)
X-Farcaster-Flow-ID: f8d1e173-8db1-4c75-9e58-45e39cebae31
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:52:23 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:51:57 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 09/19 5.15.y] minmax: simplify min()/max()/clamp() implementation
Date: Thu, 2 Oct 2025 20:47:23 +0000
Message-ID: <20251002204733.35652-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A5BBF18000A
X-Stat-Signature: rrqpd1jpp16g69bmujuwrerrpqz8p637
X-HE-Tag: 1759438347-367238
X-HE-Meta: U2FsdGVkX19k57QPgdpTWzWJmiNt5l/x36nwqmP7B2ro7FHE8pHDv7/RR0q50mdyM0OVy9+3MIrIy8XrQt186m3HCCevchXV0RqoalThlaXRmaUIA3cdQMWXwNYkxt179ag6EsLz3YatoelAIsHOqX6ifUAjME+uQI/VWfzl872sYmhxqgykJI1NwSSzEWFJo76Y9B5tLVC5Prfj3YEM1uyQTDe+/95Jolxhr/4OGwjzEonei4xMWlXmsOoXC8cq69LiESJ6v/khonut77tmxYLIM4lR0HCyiQvczy9g/4m4q7ybJmDUbRwUC9vsSc8hXMGYAaBaFFLV/p+bwqv416koX8LvszisW8BmoQ1RlNvBLNgosoobvU3YARwTOqClVU2kaTat+ViedOhPFNyy+vLe2YPTCBFZWfgIw0JBoNj4Y1r5AsEMuOaZadmadIIwiekPq0OZf73dCJ4tfmDa8gVa+fUEbFjShBPhmiEO+zkelaqJk4ssiNdnLgtGCOgD/7/9SziDYPax63vcMhkKVf78EktXPypm+WR2TgDsYFlwN3SPu70K/RhTFzT7ueiPmIw+Pjq5Qh8DZVO4Jqe6b3VGkSWeppgUXBttucWK1fh2D+/H54rM7MWkmDF/S5YF7ZIhpaYDcku1M3HXjSNBNpTh9k+QvriwKwnChUD2icawWo6BICUwUpXnmkUICyzih9ckbZ1l81kV631Sr76Dvt7AqqEJBaTAlBbWEiYH2q4DSf+SYqPiMk2vLALs/2mOc+gotpa1UtkfFauU8AYyLY8jEAsI3xDx5NrwQ51fnRB356JHSq7CRNt6m7Kr8eK+ZIEaVgQcy6bbGtFKMRQ7cvo974Z8w/OZhmNEfVsNP7ywLDQv+kepvlTla0wMjI0KkbZZSvi0ijR2ketvtu8BrgkB57ehyvEcb/iTWJ/Z7EtaOVJZvjQDgnYtkD1rdJLhhRha/Ma4/q607f6dKxw
 EX18Mrya
 Sq8xcvaSrEqf2mAEZ8nRAVWX1EpINcrDrKzT3mXybPRJ4dltae2znDBAcmANweVCXZXsx5lX8LFmLHzAL2gtoQRvrMEOsuw/R3rb0meflfliZcZ3ctDlZrr8dTwIuM1zp9ZyGDuwYzdfOuwqa4JuQNX/JUNGQ2FL4fkxc9SzEyQR/vnw2hHWFUrIsR0qtUVHhtJUF4Z8dJhoIGLvrpCbfOdz+yQTxFK6+icSzVtIvrxDQPTapOxuQoUaIxUZ3hQzUsiAosHzaTfC2o3bQkhnn18nRpF9N9Fj6Cp4CmZYmYQnHfYSIrrs/Apc7kOHAt1XpbRmFc+u7alSLPqiPbUAp2B9i54QKVovE361NvEdCQIJzWS9+VSZK5KzcMsZo85wzcoEuM4yo274ORhpnCzDdiJ+g8vF79V+pAdTnXH+d8eeZS3p7kccjuUtN94ez50JbMyg63FpLo8W8Jv7BJ1MDAaXWmVDlu5atYjeBAygRHXQdhYBlTmDtXTRQf6ImnNUYAEQ/rXgcp1VgIppIIfou1FmUgfxX893xZklfYEb3XiV9T3vSjJZj1FfOc9Du4+umwXyDNKO/U7CaFU5Tc2s2JTiPdFCWdqXNspmczxv70kVTZdA7unWnd5aIwt0kAVxuWTn9X+sPQwQX83IKQ32NzcXE/RJfauctLglTSTfJbmGBMXpE0JyyDHTLpcjMwN1xbIyfnf+9wXooIrbRZs253ZfkzaylWQwcFuDPMMHJO/yw839Lkr8WhG5HCv3o8JxyUaH9nlD+xGbAvQltMrIGXmwGZjksEg+spX8RpQDPGjXcRVWTHtf98MUKKJxX2p2zT0BdO7BNZBhtEulVg/EpKgBr3xR2uzAsxs9MJoZZtDto1NgKkWFqtBsOUQ5uZlHXVR7OC+gsiTZi7hq0wyAl1zztMlNw1kCsQuHw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dc1c8034e31b14a2e5e212104ec508aec44ce1b9 ]

Now that we no longer have any C constant expression contexts (ie array
size declarations or static initializers) that use min() or max(), we
can simpify the implementation by not having to worry about the result
staying as a C constant expression.

So now we can unconditionally just use temporary variables of the right
type, and get rid of the excessive expansion that used to come from the
use of

   __builtin_choose_expr(__is_constexpr(...), ..

to pick the specialized code for constant expressions.

Another expansion simplification is to pass the temporary variables (in
addition to the original expression) to our __types_ok() macro.  That
may superficially look like it complicates the macro, but when we only
want the type of the expression, expanding the temporary variable names
is much simpler and smaller than expanding the potentially complicated
original expression.

As a result, on my machine, doing a

  $ time make drivers/staging/media/atomisp/pci/isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.i

goes from

	real	0m16.621s
	user	0m15.360s
	sys	0m1.221s

to

	real	0m2.532s
	user	0m2.091s
	sys	0m0.452s

because the token expansion goes down dramatically.

In particular, the longest line expansion (which was line 71 of that
'ia_css_ynr.host.c' file) shrinks from 23,338kB (yes, 23MB for one
single line) to "just" 1,444kB (now "only" 1.4MB).

And yes, that line is still the line from hell, because it's doing
multiple levels of "min()/max()" expansion thanks to some of them being
hidden inside the uDIGIT_FITTING() macro.

Lorenzo has a nice cleanup patch that makes that driver use inline
functions instead of macros for sDIGIT_FITTING() and uDIGIT_FITTING(),
which will fix that line once and for all, but the 16-fold reduction in
this case does show why we need to simplify these helpers.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 43 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index fc384714da45..e3e4353df983 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,10 +35,10 @@
 #define __is_noneg_int(x)	\
 	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
 
-#define __types_ok(x, y) 					\
-	(__is_signed(x) == __is_signed(y) ||			\
-		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
-		__is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok(x, y, ux, uy) 				\
+	(__is_signed(ux) == __is_signed(uy) ||			\
+	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
+	 __is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -51,34 +51,31 @@
 #define __cmp_once(op, type, x, y) \
 	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __careful_cmp_once(op, x, y) ({			\
-	static_assert(__types_ok(x, y),			\
+#define __careful_cmp_once(op, x, y, ux, uy) ({		\
+	__auto_type ux = (x); __auto_type uy = (y);	\
+	static_assert(__types_ok(x, y, ux, uy),		\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp_once(op, __auto_type, x, y); })
+	__cmp(op, ux, uy); })
 
-#define __careful_cmp(op, x, y)					\
-	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y), __careful_cmp_once(op, x, y))
+#define __careful_cmp(op, x, y) \
+	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-	typeof(val) unique_val = (val);						\
-	typeof(lo) unique_lo = (lo);						\
-	typeof(hi) unique_hi = (hi);						\
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-	__clamp(unique_val, unique_lo, unique_hi); })
-
-#define __careful_clamp(val, lo, hi) ({					\
-	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-		__clamp(val, lo, hi),					\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
-			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
  * min - return minimum of two values of the same or compatible types
-- 
2.47.3


