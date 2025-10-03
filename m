Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971CFCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017D88E0016; Fri,  3 Oct 2025 09:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AA28E000E; Fri,  3 Oct 2025 09:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD22F8E0016; Fri,  3 Oct 2025 09:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C60118E000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:06:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7991CBB736
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:06:52 +0000 (UTC)
X-FDA: 83956827864.02.15A3BA2
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 388F540017
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:06:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ak0P2Vyg;
	spf=pass (imf12.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=T2sCODGvwaYYHGFUjsuT1YFrgJwtDfImmcXgee8RsaWeYyYQnEQos2eWom8jpmAzfLy9/Z
	TaCZJHnMoXAEZHI6BTezzka51PAGql+6liQEq0Dl8KceJJOSS+gb+TQbxKPI7bVseLeWLL
	sEwsDi4f4fEOuOZRsQvjNlyVTPCKGqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ak0P2Vyg;
	spf=pass (imf12.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496810; a=rsa-sha256;
	cv=none;
	b=RJ8YLMTvH7ZxP/512YIbQ+DfUm/qHch7c5hCmkk/+xW03SV6ECIphlqJ1HNXS0VZ1KfNCX
	B+/JLAZY+82o0H3GxYLSUHBggKTn3bkyOsKIMxFrybVvA2PfyJwa5eYFX+e/XgkOkLH6Jx
	uLyzwwNHr2Qw+HRqf4EnpeOyyxzZWqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496810; x=1791032810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=ak0P2VygA1w4XSDfYiafZ7w7E/QqrbzZlbvo53Fw+pBherZP5ZqA60YQ
   Y2poYrzIiD3cv2vDCY5X0fjfu6AHt/6oOZM4msC8m26hH1UVagznp8o5b
   8L6AFRtxJ/xG0Yegf2FB6A/sgQ9IOi/voUAsvXGkBCQpifaWLeiblWJ7M
   CEYfYOY5tmzuAk9ct1sfRbirvYmKwJVKdLvdHXcmodqbJmglgruaFrI1/
   k0/zwkzzF5Qu0I59IYIxtruZqVn0Sg7MpL0wWwKOMccfwwHEdSVXRzfJO
   WWUL7snOD/Afxqo9CB/rehBlxu+CoaQT0zkMD8VdICwjvCZPvbx8Yp3I1
   Q==;
X-CSE-ConnectionGUID: pt4hlqOiQdqcoHSW0eyxpA==
X-CSE-MsgGUID: KlQeKwr1RU6y3LLaQ5GibQ==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3063031"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:06:48 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:13694]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.121:2525] with esmtp (Farcaster)
 id b1b0766b-7155-4d3f-aa73-553e66b7eb4c; Fri, 3 Oct 2025 13:06:48 +0000 (UTC)
X-Farcaster-Flow-ID: b1b0766b-7155-4d3f-aa73-553e66b7eb4c
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:06:47 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:06:20 +0000
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
Subject: [PATCH v2 13/19 5.15.y] minmax.h: add whitespace around operators and after commas
Date: Fri, 3 Oct 2025 13:00:00 +0000
Message-ID: <20251003130006.41681-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 388F540017
X-Stat-Signature: u9fn6a75d6d6dbruqfukb3mhctfdhiph
X-HE-Tag: 1759496809-284828
X-HE-Meta: U2FsdGVkX1/VM82EF43KHQ/+XI8Fw9IGvFXQHbcctORquS4WuKKZBfT+7xZDcBnKIfthJdKNnn0kpRMCtNhQktlcSE8u7wyJdSq1/K6a4/g++qE7NXlZQ3P6ilzW2icej5ojJgaz3zFvag5vO4vh7MwPzlH1qlMQs5hnSACPCCBxuVfOTAcVGXH/55TEfgJ+QWRdzsSEtyyccyGEXG4JRrkVLBwbLQmQT52scsH7/+yqjECQzThIk2yT4H9Scg3QWIaBxOnKUX0e5Knxc7jrCSNVk1oRedKQ1KRjt68BICL5pZOGDZ9V0tSu1Lh5mDwr7wOlwaejYpwtpAe4QykGHjNry9JABNmlrFajEVpxGv334jXHcwr32cTZELBvn31KV2I+k+ZkoWyUW6Ej7hvoerhtLHrUgTX2E6ZrYIiIKcF3a1LcPSPpDwcQAOVYVLYMkaixQxrTcJ0py9XIyiZ9ad0swomOueMm6OY3QzAoui/hxk6HvxXTvgBqAg/1GmikUugkWNvuGsMxYw3sObireq84HRhALv8i6B6Zf1/vmAx5vHkP0crgXylUTWf2x9+ECM+plID6lwpcPUsPHsFUKjNzpwiJb/BnwXpP8EKOZsQQMuI+0Xkur7rfeSaM74WjgFz9hqgxyjBRPF/A2G8L2Pg7JlW8Ruk9QH6I3mq17ZA+IwAlKAg/0kDIqWmlkxmLgQ/MCnVsBhWMmzQNNmrrGjLYoAjZdibSXTXwkvXOAFWouEIMrPkRcax81WllsAILMqWWBPaO9vYs1y9sDcEL5lhPN5lyd26y3bNyNXFeHOnMlQVoMMjJE2mings72fYsziQ4ifBM1htc0XOcBJqgUdWxtr7y08QSNBddxmT3SIl8xMFXuUWbgagNBM2WcHsoeq/O+mdNthfdQ4D19Yg5f3CU1bXSaY+poIreT2MmOXJc1HfeluvOtAwY7/vRT9HwTdPUb8AbX79YUsWMCwf
 1IaI1XOw
 caG9V9igZ+qlR5hXe5S6YnUNru1Gtm1jcpqbddWBFUnSPpRgCGhJgUgXLJsRUY9zmvJyxfZhqwC7javfRZYLTzMABqFALWgKrhNNkC7zzZnVriijztqJKrYEOWwToa5NIBEHSae5Z2KrWaf9QbIG+pICvo+71QPXF6j9CETwTVYw1banqqJ5hckiDoWwhGnhNJmXrdSg2nN8vOYvwzsgaEAgrenzV6IHz69cBBnfnECSwVAmGF13UhkzFbJ6dEhwE96wD+/ZVz2xA7oWuT9Vy5IcsZyRy8lnh2n8UZZIVQ0SPov9BX2Cv1N27u/UdcozzDiUgwNPl0YPPGIwKpzD9xa9NxP3/Mj5A4rKfiFG0mHuEGx8i3LNGr9D+oDtmV7qdEhpY2zZkKjYVEf05ya86d4azUpYsBp8uE3MppMBi1k6umoyIAeMDcxbezbo45I8Z22bJ7MyHXCCrniKLpXSsWgiEHD1+ktmybj0+zAwWcuKIAjp/JZJeXo8ssL3TFKl9g0MRfrVKj0+SRlMDNYVRjOzWtk57NgLZiT6Iaqbdwnjvi8glUqNZl+Iwiv8gkuZWmhxc5MhvEAwixdiy1kf3gKRaNSkTzqYDaMcjZybj9tekuoQjCQfF0yEzwaSm4gHwoSc0vIFmLGwK1YVpeHhHWuE7aosLS+L2a/5mY/onGRiuiO9m5pqkx1gd8KrcXPNae8AyCQjYA+iMQcJ9Oq6Wj/0u0k2NblIcV5d816KCkgdxNZ54sdAC/UL6nk/RDEHbLDyWLNsdZdM5f6+qguydBOdvslzlDF3O3cnpSzEhe/8pk3AsTAXot7r7+AvegjMCxVFumN+xagdvKL+BTx052vIzWid0e/A/JChzsVPPQRZtDY0H+mmTezzxrqqoSYQKbVslJLn1k9Vj+OEkOcw7MynObB+BxnnZznK3p69A1d2pmlC/epM87ge8eeO2ZEkp1fZqObjSbnDGeOBJeUst5a5p/g4V
 Tesyvfh6
 moy8BKpCp0mJR+y+psO13EMV1ZSbyWWyDg1TIatRU5HYh0f/7SvDKcAoZ0wEMxyDw/rGVtZphKrD/YlGlCjJ05Hb0WfNir3ATR0iBhlGulc2vxSKR4YxDiiTySNCv8br6k2OJLx2R8iQ/dyhGpL4Jw==
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


