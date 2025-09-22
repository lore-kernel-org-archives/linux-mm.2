Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4810CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E078E0013; Mon, 22 Sep 2025 06:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4159A8E0001; Mon, 22 Sep 2025 06:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BD18E0013; Mon, 22 Sep 2025 06:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21EAF8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:38:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5D6BC05A9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:38:24 +0000 (UTC)
X-FDA: 83916536928.14.540944D
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92446120003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:38:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=D7g2WNww;
	spf=pass (imf29.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=GLtFE37Abt/KPYY18JOKJrCDkn6YMS6MX91fRLOfOLesuebhyWwLsr8kj1UWHi+vsZ5SBw
	8xOVps3mkMEjD1s2FPTGRR8jxLxLH/Vid3uEaqikpjWEp18tH91RzPNxX3pJ47RjnzBNf1
	kTpyp0BUJsWG8aQfgUAQae/4FZ2zCyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537502; a=rsa-sha256;
	cv=none;
	b=k3BIkbGYCQzQygQx+l2vz2aMX/rogOmELVeA0Hd7SAO80AKhoixS1Ly5ssvZAv6bfH1jdh
	M9mA13VRAVs1eLle9ibzVn0Sa8sWxDuV3k25j2pCaQRu8bRGM57T+xGwlEvBEHATvzjsvV
	1IStFbQvckuc1sDAwk6kpXjnj5aIe+k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=D7g2WNww;
	spf=pass (imf29.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537502; x=1790073502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=D7g2WNwwFeVZ9nt4piWZQLeWO3ivcj+MHCi5NURfO31VNrnPR/5HQJX+
   hT/EFevrgG3Ua+zbyfEMXGLr7lZkJMrxsDuHh6Pv4j8Ad2I+7wDpQXEZn
   hO7tQ3thf4v9T4YAIItrbo0V1HjxIdpKPJj9TyemCo0HvXeKZMg+9EsRB
   PchTzPCIDf9N3ZzLpw0/Gxkjb7ynJJLh3zukULqnjKU2+JdOCBVH6+cR4
   PdA8RX8/OJMCIzdh4hHP4c/VyVOEMUKbW9RZekgifo42YY72B9uV9m1J/
   aYdGSTTe+KG0HQKkD5P/nKsTJ02tZ3823G2m0AxAHdMu/rk8CyhfnYIQo
   g==;
X-CSE-ConnectionGUID: VxD2L9QmSRKftLbRtlXCBQ==
X-CSE-MsgGUID: uuvVt1i1TAeI+VJw7UWbHg==
X-IronPort-AV: E=Sophos;i="6.18,285,1751241600"; 
   d="scan'208";a="2375252"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:38:01 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:16102]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 9f52a6de-5c14-41ff-98ae-8549e737ee90; Mon, 22 Sep 2025 10:38:01 +0000 (UTC)
X-Farcaster-Flow-ID: 9f52a6de-5c14-41ff-98ae-8549e737ee90
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:37:58 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:37:31 +0000
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
Subject: [PATCH 09/15 6.6.y] minmax.h: add whitespace around operators and after commas
Date: Mon, 22 Sep 2025 10:32:35 +0000
Message-ID: <20250922103241.16213-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 8gt7t919niqudkue4me9gty14fycxcbk
X-Rspamd-Queue-Id: 92446120003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758537502-914487
X-HE-Meta: U2FsdGVkX1+6y0as6fagmEiJ6iMlkhNreub5/PlUNGNrmvcvQMmZIySL4qk5+HMmDDLrpBw7JzD553ECCHJhrELODfTAGJ7AjbYVBmF+DLv8dfR0XjCQaM+JvghaObEAF2fBiz5VYi9wQJIiBqHqOaWAtTAo1sD2fUlaHPVCuzf9eJGFlL0VSLPCAolXaQ8E3YvQPoJpHZioHbyU/TPgaI3Dz5GYgWYtESbBCFcwJ4VAFSS8oYtYxx66myCPF1wUj3M/fT7aKX6RJxNffne8ROceJx62UKdL53NzAVloIBlGxBwEPdftYkJsTSea71/4VHNqOXQtfkXre1L6ChQ4Og+qwne4q6hEA0MNBF7URh51/Hk41UDuHrvqwoej5OZ3rMg6NiP9vgJuY3fsffYf84qkDS22RQuvLsdMIldx3M4oQvDvPDlR2cXWbWKVaQsb2+yYblkSbDv+sDzlYDWT4kRmJcMtmALRJYHYHEY9HgV1TCRpdoHUmxuJy+tas91KPpWObQqRbr2eUDZ43xEKCb5XteGj8RvZDqw2ejV8Yyd4FT884XX6TOmGf5rh6j913+Uxj8SIXLb7JDY3quVRQ7Ve2Tj4AV8nzyQKbA/zYs8ForCtwnLyQgX5EnOcfMQT+Cd2diaBuF1fkvoWCphjZNgK+r87/lHObuyBCXyGvxSTwXp1TylmYFOpIS2jdjAdsMoZ83PbIxxS4+hrlUqPqmFWWoB42HT1QGu58UdTmYTCQersl/X5mwX3McDwIRW1jTL5FxXSVh/nspuHEXqCldly38b2ErT+iMP9UfjFr6/Kc/bFoOzgj/ujrev/py4H0E2jf+47EAyXNYZh9nyd8oxrvdb/VVBgBw1EdjUkeIlSA1kRsSgfkkOIBSM1ex0bdCDoKIu3bi+3HT4R3XCLh+nFHtZFTr7NiALrIOtztPDnm19cMW7UgK8lBtm9WsvoFOLU0MUxKeyPuoUwj3l
 OEb9wKiR
 xwm/GD/+K9V5o0/m0MCe2xQKnQTL9SAG9Betg0E+QZ2kFW0H2ngVCT5E+z3aaBJWXOEtsIwsL8h0Qsceer1EqK6Ggv82ARhfh8QDbATyfaFTiS7vHXIhSF8nDH4RGoAEHjsHl7mjiGAi2/BHnZphKPXuPV/Fay1bJ3BbEJz8c1v8AOvF68ER0Ddm7rAdTvmkL+koHtjPzkoIMiXxisFkeoNRDE4G/0gIWJuvb3HCdMVJTDQAO5Alp+s/orEPtxK88O3DIafK7vHGLvszvfkhXlq/MirOdIQscJdHe49+um6USgIop9UzbjVLWmjOqo8hjkDr8z2vx1HEQR6DXSaK5m/z+4axMwha/jIo6MXILPla5Xj+JP/SrfTXijFriP8EAxTyJtz3vvs3tzc2egjYIeh633jSqA6g3BhGTFpwqnUEDl8cmXhXB3NZksG4KlbNa6zQp6A+5QMBlSl6DJ6oZj+7mJP6L91j2DOutd2DGNKmtgGFOKJTqN9cG+V7h5A1RddP+sxuDYPxTq0BdyrzDiLzfeeYGRNtoTKsJ2DL6HezuPMvSed1d/Xy+HPbgwqcztPr9XF2nro31YyG/Jtq1xEmXnySHGWU2bFJuAgublOWk5GcjFdPMjmQKTA5Q1R85Wz9/cVdqvmAg/d4nNQ1wF7YN9SKzwCXReoFui0WnapK/BrdXgd6x5tY6LPu+yAq+a+OmdQPchFA0L/W9j3LzZbU8kUf085Ky8n0ZQ0j5Cr9YW/8UMV1QBJxpyxuZMVmSsP5FRiDPDPAGz+6+z6hdEk6tFUqdaQJAhLO6QB9v3gSMM85Y+Ge8vyvGNwu923YYv+tED4lCcRNXZhS5gMsasFDXVwv2ztwraIaIj1JqbNUIE3pSsppKc1PSTjS57m4hqundVZOZ8igqrAkZ+1suc0ZNqR+mns8i+BxL5GQpLkNy4UmE+iRJ167eedN4tN4xntO6yrctckzPP35A+I62tU+14NiW
 sJ/gP+12
 Q5UBfGdyiUYVMf1nmi2IS1FRt6IN6gTtN0YOipufKEUwkXdPGsJRUSkzzjT/WrsXf7wzyDAO6tb2atpwxVOvRmASEtOikMcOksiNqQMs1YoIEveiMMHTzKny9mU5qgvNExdZVbPDXW3h8JlhzBegLO9vTHzEarXiXCMgby9P3FmdHXjYUsrhCPCWhw7loaC0ygineBx6RF25O2BMKctz9XQ2KRuAKERGCxaPQHsmah7h8J84K45irD2qEAYvsPuiJ5g5PQxcwNp8bo4h6aUuTndXzU91SgPP2b7W9LCciuwzsSO4uxoE3A==
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


