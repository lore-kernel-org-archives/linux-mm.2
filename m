Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD603CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333898E0001; Thu,  2 Oct 2025 16:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E46B8E001A; Thu,  2 Oct 2025 16:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6328E0001; Thu,  2 Oct 2025 16:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E27FC8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:54:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A45EF11AA7D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:54:28 +0000 (UTC)
X-FDA: 83954377416.30.003C4A4
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F56B1C000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:54:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VrNXWIF4;
	spf=pass (imf18.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=8jh3XWhimqiA2krY+At44s/krnZN1pNHYldgWIbgSm2uSqqtm431lrA6bt5MRJ/N2yE9jq
	MhSzfvllGS6eYold9DEPb6pRSQQkeDb5QU3d/72uMmICpzqf1ahoJf8biYlikK8JVsA/Or
	mp/q41WFuhgZBzamlwG8o/Bo2Fh+ujI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438466; a=rsa-sha256;
	cv=none;
	b=rrc01tZFD/NZ1ag6ScA86RZhQH0vWugif8lrHc3+XIFRIObwsjPBMpar7VNn2sUf1gTdpt
	gdz4oeWygnNR2qo8nXi/rIEj5yhpUGNoTytMXSzOfAnD8FhyCz5RNPztvyYogDoM/UNccl
	eWAGj3EcKxcMs30fqfhWD6oEblr7rHM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VrNXWIF4;
	spf=pass (imf18.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438466; x=1790974466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=VrNXWIF4/EkvgElQJOv5nyu65ycWpAtQI2uMbpO3kPi/e01DqfI0J7b6
   XtvUQN/4kzIJWZUh9fyQnVrLnIC+PDcsgPAIvoMgIogZUAvuGMfvZQD9m
   +70m4p2OgRGsmudWlXzgUNqVFkb/Wn+zUVc8fYHNUWzUjW53B4A8asaVM
   Fkl5raawLkLlZCSa4Ry4fxeR4aGRdYZT/QfQbP+hIHvfysciVJxCWE/cW
   zpEap34OkJmmujv4PLpb0KO65qtPIerwcOmaI0UlSoV18p+mEa0/LOZQ0
   1JPzanKkt7+RAxQbc420tyMJJXwXZs+WYTsorfop1/svJUaBa8Hl1YCv+
   w==;
X-CSE-ConnectionGUID: xYn4xRcwSFae1c2g5SLaZQ==
X-CSE-MsgGUID: gsVVIyccSoOJWy9uutCapQ==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2924605"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:54:24 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:27330]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.83:2525] with esmtp (Farcaster)
 id 01e0a970-bdc9-4af0-9f69-62d3da8b75df; Thu, 2 Oct 2025 20:54:24 +0000 (UTC)
X-Farcaster-Flow-ID: 01e0a970-bdc9-4af0-9f69-62d3da8b75df
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:54:22 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:53:56 +0000
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
Subject: [PATCH 13/19 5.15.y] minmax.h: add whitespace around operators and after commas
Date: Thu, 2 Oct 2025 20:47:27 +0000
Message-ID: <20251002204733.35652-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 6F56B1C000C
X-Stat-Signature: ird3f46sh7bnx9n1eydaqjpdy33n1e8r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759438466-306371
X-HE-Meta: U2FsdGVkX1+jldAgXVDVq8IsULkti2EsqNyMtEPv+PvnSIGuYmrLnvmj8PduZB/ttQ976giHCGnTSSMNVRUTGasLFvDxbE3YpRD9T1pMPWDyLylpT7c+rRQIQjNAOBC1mfF5XF6d4G6pPOaZSqT6Fw5tcpcI3ouI8ASahc+ir5bX8hMGM3A1SuB1njNVt+2SPYH0a8bbbqTXGzPIS3WBSENmVZkYKf/LTNIDAb9nB6L4vM0esOKzJFJfwy0O8tz1wyfhlt/pj5cWO3sEYDqo9HFV4juDXkuHi9q8zUATwzDjDxiacCxNYDSHfEV/iAsNIKqv6Ud08IVOISBstifL1gEPf3Qlwhz4it9Q1gM515yEuR1Ggy+WWEQG1JXU6HLCgncm+4JkcyWeCzQqvBfi9oeryT5hDMVToBqkOLB7XaiaxzVKDz1uffUVv6gZzolPumL6OvLthypyWUkmkVKgqt9bce6TVM/gsh5Obc1lRofAvNXU4PBRkefQMwmbU4K84zARBcX2BBQNlhxGsNDeoJXGgEqvW21HF/rGV9JZkboIlUL7TgUsG1OobZSo6BL8vuuCn0VhMP51HeABO5vkHeq8y/fp96AsLN0+J7ymYf6kwCX/LI6/cTZjCG9jZF0UdE/+OZ9BCwlU+R03/ODGxLkEUGy51I7IBTYzjLMaf3wwIIGh60IhMfZT4PPlqAvdeTYJP1+xXvIXiGC8/8F6Fn2hrvwEF9WqJrw9nzfUZQMcBhRqWSS6AI/lr2TLOzoJnOqtFdTjoLySeqSlsIILUqbhlYavqgfVEHdUl6PCl5nzD1t2L7ZvhKbiCt8jjBNk+MkwUGH7JnYXVZytm0qOYL5oku1OyuJJIuIi+re4Pf91ijWPY6ytuT2TKtnDzfSi8pVcCAxhFuXPIiW6ELZV3P6NwPeLn5IdZ1Jx8ctGKv8VyMYro8looLBLJ0ohLVMRG9Su9ZjVxPHqoMOpgGI
 NCg/w2GD
 jyF4lMm1iwu0Z5hvpBNV9kmbPq6t3FXM8oC1U7JHYNyivJNbjJRM8vlCT2VhOvwCw+CsJ4hrHuMdlMzz48R6VBNSPaPIw1/VDbo+Zx18JdTxWYT5Q64Duv1I+zDCpi1L1td+3R6zRwiePlGFaDM3K+YG8jrOGBPczBNwCR7RQToAjsRqkMARgaL5F00Myw9PirbKK9ZpJ4CCcf1VX7Qu6Z+DGsy4hTBeAceExcpomyRakLZv4z047T+rWIeHmOiFIR0o++AMFfrowYOIO+YFz+cNqv+xXQC7mc+EjpyLtbSzqjWvQJcdzn7QF5bZ8Y2ReRmPC59kmnVK7k0r75g09yXEGie3B8ft3sZFyJ0o/ekWSboX5QFKqnsGRTY+Dt2a41Yw1wi6QWohZTMhIoux8EKL5me2ToHvcEzUi7KzGrgC6sgOOaLTwjpcQAMQ6i7G2poL7ZDQTR/7ZwNJo5k3NthWLVxhsGRIzD0ENTnSGaEt9zoOIrBEbbPCQzbWU2M5iwV3S/QAARMG9WxEfE8It9WGU1FDP5vxcS9FtG38R9Un8FvkpJqZGb8jUovOm2+OpS8Y8qGiPrGaWyOrBTIGZlHbQ49X6L09PPfm9DWzbl3k84LhNANfypeKaiYyDduO7UHBmP8V7KrRvp1fUS2IiFHC9VtyFFve61fXeCDlA4iOf7R4gI1K0LdRHqvFRysLpqzZPxGIDDoY0uZl+tBiqXhcqcaN3BpFyI93hLQ9qgRfCjEsX8zmCOR+EVsaX1IDge3Guxu+Uhd0F8BwLikaZ+jcsIzgiXRK4MkYRImZ5Jq8UFn24P2O9r2Q8IM2hlavac5onmCDU7fcCa2DdIbQwDn0Ox4rwyeXFZvlHa1BTdAxiu9wFzG3rxOt1JFVzhHuvjbkW/DcT2PAoyJgb5NKiAybqpvpIrBfHsc4yqb6NEAXqjzg66uhRUFMDGw2i1cRgbmTDauC7Q5K4dbFko6KSNCZo1LdX
 c5q6jvfO
 bsYY/n8ixg3spSKZNBWdBdJSvrLzmYu8HOyIg5KrD8pwl2LoMKTnysTYeVc8+j5gy0fUeTJcnA51z5yfIEa4X8XYw1FL1i7TQS/Djb8J1kscUojk7L1NOCXEPcxpKwOH5HTLafpfOVm2E3XlGZvDSPPL65hV1l4Y5Pru76Er1mRvk/okieYxdw==
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


