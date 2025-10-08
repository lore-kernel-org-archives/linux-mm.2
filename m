Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C02BCCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294128E0031; Wed,  8 Oct 2025 11:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BB48E0002; Wed,  8 Oct 2025 11:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181378E0031; Wed,  8 Oct 2025 11:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05FD78E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:31:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C87E111A8E6
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:58 +0000 (UTC)
X-FDA: 83975337516.11.363BA45
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FE3314000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FJbqpNhR;
	spf=pass (imf09.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWSej8xbBt1No+Mk4Q7cDNVqN1sPbiSh6ZSRtMK8qI8=;
	b=vPc63QAvq96p0Ei/8M4g4lBHeAH+qrncHBxZ6+Klv1uVTfX4enftBRrczHBxiylJ3ZCG/k
	y188SVFzieaAz61Fz8Indo8v5f/ffCH4cKLAjqLyDnfV9Nw4fCDxFEnrZrScGYXnTVr2Ik
	YSaG7AEDJ3eSh/POVO9f9qtsx+AbjaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937516; a=rsa-sha256;
	cv=none;
	b=a9aqsgRgvtGbmtqKd9T7gVu+pmwU5e+eiD/S0lgCzwDbzzrefSkakFBsJr83co2Uf/czWH
	TBG/ai/UYlx7DDwAL5hNUAbbl5ibvoUf4jAhZZvNZq4Q/KyuCKgjdvd3bAc6Vo0X+IuqTy
	O49sFuLJObA9uZrae57JS6LkGTdSYqE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FJbqpNhR;
	spf=pass (imf09.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937516; x=1791473516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nWSej8xbBt1No+Mk4Q7cDNVqN1sPbiSh6ZSRtMK8qI8=;
  b=FJbqpNhRVAZS7YXOeVrQRJqC7wyBMudDhpYjZxRQgIvsaXHBFKo879JE
   j1O5qaraJ6dO29p2Dy7371SJ6MVzP43BIllmXe6VvGGIwlXdz0fQjHSWW
   X8VROwPSb7swQmwtVKB6AqKE71nkQU8aKknQDsNwajzpRaoUREF1HfQBH
   q9tkn5GeKxaziPr4SXuPKVhK+IRCSO0iceiqpiDmgwAFdDzflsmSHjXSo
   TJP+m7Z+s5ScoStxCjV9p3L5QyTqd5HntdnFVax8ONcLezoqDy2Z0ZWCq
   Zv1Ksw1fzzGwSlq043nj7TmEsHbgv0FgZHXG7oxNhsOt+bN6LufbKREOd
   A==;
X-CSE-ConnectionGUID: ycDfQ159Q52OquxNui086Q==
X-CSE-MsgGUID: Htks0LY0Tz2E6Ou+WxB4jw==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4334930"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:31:53 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:8640]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.171:2525] with esmtp (Farcaster)
 id 0a7c58d4-562e-4eb3-b770-43495007b45e; Wed, 8 Oct 2025 15:31:53 +0000 (UTC)
X-Farcaster-Flow-ID: 0a7c58d4-562e-4eb3-b770-43495007b45e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:31:50 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:31:37 +0000
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
Subject: [PATCH v3 07/19 5.15.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Wed, 8 Oct 2025 15:29:32 +0000
Message-ID: <20251008152946.29285-8-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Stat-Signature: msoqrnhatw5596bize7cp7mi157x1q6m
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FE3314000A
X-HE-Tag: 1759937516-12324
X-HE-Meta: U2FsdGVkX1/sz6kSS6EwCrGIONW9f7T31tpeEFLFadWGcH0JQ8VrCMqZhVvECVTZ7Y91lTA+TCkkLujzwv+uR2NtyzyIl+/p3eMqi7zjYhDBWR2bDTNGD8j4CWbau3wo00IP+esrE+Vg5DMSSIqQ/kco8l7wP+TbMMlA2EOmHd/NEmjUwb518XYqluPE9CzazKqJ+rBWUfBU8WjUf9drB/ovW5aPCqjdLciU0imv1dWtqfd+eOKCQ46HvxG/veofX99s8t1aC+1SunkeN8YMRNOzjOhM6v/1G+OWbZ6YdrSMlv+4xD+3oO+mu20J01fhJdvQktwpgwPtdyf62sjGXJxOcBG3gI6ZFBJGPr+tW91OuMqlm1drW72GRSKuq9TWi9F+JtJgg4NxuAluSpq3BshQy2zPHiCZxUSGcYLthM2BK84cMkbDVMY01f+XfquKA3QzP/R3rkXQDnP4/kVJB56xntzDEY2o5V5817McL5hcrTycicOPS/L3xkxfGdM7vJrTtTN64fG0QYdabwNd5gtbSDDbUITudVLuVBTgnkC04UOqxAj/U9GR5AJEAHVk3YGK7g5jOkv2VTAoR4d3QFdGcDKoOwqbaUqLlSHli9U9RRaXIaK81KuE3nC9+xeKGrJYJToZ9PMMd/umTqXvJMEPMt/05QnCbSjrPLOMTRLtOAy2LwL/IYq1qOga17l8qjieSCTZRy58Pa9WHJ7kDIeINSe7zFwTTILniR2qw23HHXlwHU0r2rF3DrjqHAosKFIRyW98IW4xNEeu5D038Xe03U2LciK/r+Cp1Dz34US2hTnngk5jiOkz8hY2a3e0SJec4QKpcX1iUGaBYWav2FSaC7WOjZHquZyVoc+ZA5akIqUtMACr/AV2R+dOfxl+/Odbxdyzeh0TVjzw9YoSUlT7PXvqxkUXdpUMX6CK+9+Cp0mKjyVuTc4R4latHNa/wh86TUQRqDiMYmSHn8P
 1dms73MA
 hb7uSZaX4PLaS4JboftuJxJlTdDeFcYTLWCs3TQ1yJnS5FEbcac0HUYT0zvsrxde+y/TOvMpLjPu6JxxLR0IcHd97BlmDrEIMWqeJ08y+l/V21v2KJEQD2BQ6ceGKa83rSjqkLpktm8zA4L5KRQY1FcOMZsrCFYwTipX/rHWBt/WtU//5LKGmBujPQqN6MUmPODeP9GJTLUzF+0soKMyWYTZILvP4R31T/Z8Dphi/qRUglqj1Z+LU7HmFPW46LuaWwh5vbn9JDxbYZEKk7HmdPdMYkqrfSYeNM/I9vhjtx/02b7ua1gxFn4DRfeEKHXhwcBkxchFMvPfrhwP2bJMYBxU/WKuz/QMOj8q6GF1t+JyDgCTVMbtG9AEpTm/NkUYr3eOLnE2K5W7zXRmUbyJ0ALcOqQ8QhrTqDMQKrh5zN21+DKo+AydZDM0Fqw3900rLtVKPpFVY6gpzLKii1zyaQ1A/bCLFyPq8T/FWsMGZk+cicfFkq1cTZkRHgZhRpFTXDO6Nyy+HWNFdHs5ZhByjA1eSQaaFf17I8/U228Vj5BsSi88KnGegbgvUHwXLZoHHQfyOMNuJRk5yzwjtPF+dDCag1PJJlafN1urRxGqC2uG5GUrqUt+Rbb6F/G9DWWpXwX8J/S6EOu8F3fq2huvKvyTSrL4fgOMe3xH5p7tFM4T1BTIoQCsiQyrCYYVS7WrURQZxnGePll06RkRv1TxQBm+nxLVQ2My4z4PV7BkydnIGIX13zEyt2L7uVE97hlCKFMCGTyG+7BOrW2OnyARH5Jr8oo2UelhljDGb7Aqi8QQ1HWYKaMn3RWxCusvWAVRJ3CUpC6Cyy9hqXlJFy63RnOMRGhS5m3x/oD09gJN/2pn52q+N/iTtdRhYXnTUCVnksLYLp9CAcb0QITWjMnHE7D7C1E5iVGYlZ+nJ95O68r13cqiunwPJH//eQ0M+Lzlb+Y+Sx4+6ruNKij8X5SO00FLnogNu
 GAfPJW0f
 R+4V3UiKWNiMhedWa+AQftxF6jxHLVsLZvqO4XvG3Agb9BPop9QQlw3V8dSL9Sw7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
V1 -> V2:
Use `[ Upstream commit <HASH> ]` instead of `commit <HASH> upstream.`
like in all other patches.

 include/linux/minmax.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index a7ef65f78933..9c2848abc804 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


