Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D5FCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD608E0006; Mon, 22 Sep 2025 06:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4AE8E0001; Mon, 22 Sep 2025 06:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAF48E0006; Mon, 22 Sep 2025 06:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7148E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:34:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68A3E1DFA1A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:34:27 +0000 (UTC)
X-FDA: 83916526974.27.5B55064
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 340974000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:34:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VkMupMSC;
	spf=pass (imf07.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
	b=Rfxp9ufCqkOjKGkQyQVzNWGTDxaKiAgjB26bW3/1McsR6C0VInHqDS6/8tR7lwwNTcTw6j
	BrYZUxXVwi8vPqXH6O/6swmypvrYm33x9tA5BGwtMxAO0E7EI0+C3Xrk4vS0sY+TD2YQZj
	KvizBXMtwG403sFiFL2nqNOjuMTe3OY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VkMupMSC;
	spf=pass (imf07.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537265; a=rsa-sha256;
	cv=none;
	b=DB9Uq0/q/yJ7pZEm78RzmbDX7ojBoh9/1zi8zJBN/kC9AeTO1aDcbkE4wXEC3awCIDcKVE
	stSWtpT/Ky+PAP23UXAj4MrWDHsladb+0anFu/wOrlByFNy2VMma9GCReAKu2KG7j3xJDp
	AR/Xug56oq/amHvA7tPt/ebTA6u37uw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537265; x=1790073265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
  b=VkMupMSCyccaDqqRSPSmWBO719n0DJmfX39CZnR1P1maE/sX5GbP4ylb
   4T+mi21hkRL4wPa+DpnpFK8StxacLbh+XtNXm/93TZbMtB3vaDeeGNYSr
   mGXFo5vF2v3b4/WI3nOZIJwIkLPgFiWN2H1ylQObaPxYd4mAM+RrZP8+t
   ernA8jVQcr+q3m5KbMLg3NTbGJS6IVXyX5WZlePyIRaFy8dpX1y4xFqw1
   Cq1kIndpHL4OxLq2JvyJZ9heSAPxBTX8R7jLmsA3BosJWfWIUOg/V1vFB
   16S7dvJMRRVvl3eM4J76kZdvIGjMSaPUZ2M/a8ZzHFEbsv9xD9hnYDFDN
   w==;
X-CSE-ConnectionGUID: h9HJdj9ZSL6OxFZaboM3vg==
X-CSE-MsgGUID: olU9DTdMSs2kDNXwuFOHDg==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2370489"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:34:14 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:28647]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.68:2525] with esmtp (Farcaster)
 id 15c415c2-fd16-4370-94f6-83d5598a6dea; Mon, 22 Sep 2025 10:34:14 +0000 (UTC)
X-Farcaster-Flow-ID: 15c415c2-fd16-4370-94f6-83d5598a6dea
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:34:04 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:33:39 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 02/15 6.6.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Mon, 22 Sep 2025 10:32:28 +0000
Message-ID: <20250922103241.16213-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 340974000D
X-Stat-Signature: aa4akgc93xy5xx7y774gphh3r9hnxniz
X-HE-Tag: 1758537264-623543
X-HE-Meta: U2FsdGVkX18QM3xQrLcep1G3sSO6OWVw+9AwVbLti0hwBkvH4zmWRQdlKfMyYOjrwJg/Dxr1pvewqSs3z3gqWKj68Znd6cSUnfo4KrcV9X6B+3OkBBrcJSADNTCnhdr3ApCdSgG7uTJJJedZxBRfryVuC8oyrb6uxfWjFPzT1c4A4qR/DYXUnkRpbN58v7+izgEWrv+SbobSCRX9ZXBukzj/aY5b6jfmi6ZygzOBLlxpfGwpbhP1lLndYXDsRZhAqvtMs5T9UtyxZJy7xzg0S+lUjfRMbX/+QxTxf1Xt6Q7hshipM391qeqdIt0UEKDmIJCjHXkjz9AV9CNNe189TE8R2oN/qelHvvuqpXbNg3CLoa4ImWXPdTn2SdVgz8Bu8AnJQIaIq0Xh59oCBfq7TRCI6z1vLVtoCgPRlfUmmIFZ52WoVjVdbzClgHtWJMXNVnr5QJGGLH9XZu6IdBk5Z5VSEEOpIp/cxpfp93wvuqlXg1D9AzcT8wiV2/fmcRiSzUBUDzUEpegOqNASdciy2uY4sn2AOxoKF0RYZbgclgiEl/6LfYEdFaU/o8h1XyMixpsH0lPFYN+yiNz0dXb5VWuO3tuVcXd76M9iQSH9exVJob8rrhq5Ipiz6TKjtvk38UfBFpY/BdiVCOuObJBYDswMbS5EB2E18E9Oa+Fud4oQ3chCgkaHp8qa7VWbhQ0m4u2XuCBEgL20vwN0kFTpgQSx2rsEU7gvTF79AOiHNWHJ0R/CoJGkdIAGwIw41F9Iedrfjat4PdM+92Qb8yZXQ+Dp2zQA/LzC0Tc0E7TtNOY9PwUYNrWwwG/YczXsc1I/8X9e3B8vqWb6wxUxCYPkQZU36CQsoRKSHyqunO6fynQNJ8IRqqBhPRGwzzZ51A9pQdkb6tyAh6biyZdwtX7GMvkhpSVCwCGcW68x9Xo4jUqfYfTJ8wqZIQDpqzI/kFS1KZZz20i8RNRo0xbvIiY
 MFXpX88y
 CZq94KEhuNwJJ7MrhUQhto2rP4cuwYcr9iRrP/6+0CCBFXF+/YwMYj+pH+pCGp6rbjE+grvOUL8yL+bJxfJiGCBUbWlxBH8x9rsBfrt5hoUCcXRyUuvE2LIUrVthGnpJpiS/YiC9WKy5YU3myMKLRAJwbRPT/HApzZK5ty2FIg2HAi0ccR6L0UDvW21Li1oTCxagjGYdbljZv3tukZqy5+8Flh+GX0K8FjHlvg1t4y8jPm5aNqHUijPUzkawRZpfuZsfMDmKLeHBoQKZwA3ER75eXGbPjVCNUVAekQWk8hwhLAPVyHv9JZAebAyDFkLAmpz6PIUQWqHNJDNoiUH+ql+JKvTX/R/assH5o9Occ5QAhAYdBkbZRxl4VV6q+vPqnPmQT9CBAIJxho/9kE9fjtTttiURxAXjqv/b4I6P2DqAL0iIbeobgnuOpcJFbdsFeDc2Zpkr1FyucyNMuzSYUcERdx5k76bEcc7na+D2NMs7QChL2ndsBj3ufOP20XxI5x8Nwi3vnfRsg/yCVeEwUeF7WGucDlbMKuzQS6oapzykhKckBuMfWh4jqNQPigZueuu+7stjgO/3QFIWab2PVbzaiX6qq9ppW9U5aYqGQNcHZ5sb9zUngm8e8FA3oK2KFxLV1DxDrsc3JuAneue28O6J+Rt6FJX3jfTi6EvgJdKcq1HoPPgG4vDBuBt+1hSmnmsfw1YlZ/XGMZ8+If6GspIAKbyPDJgNgztoLhHyjK9Y2W5JnQTV49C3B2basiy0UMHQPYA0HXTsZrlMDq/bKaO4cxRMptovV1C4/v4ltgez5bk4NJ5c3V7XMbmRfCsbcl5L48nKnRAwvc9LQHKjutqCAX1GAofUXT4CdgrZsL72Lytuz3Ay7Wpb5LD4SJQwlD0Xxr7WxDgyVh/Al+B1Is2fDax75gP1oLH+lx00DsvP5Xcmz439ua16jbbB38yBxYwsQX23cSop/qg4za+Oeg6Ig4Prs
 kasveQKy
 5spb/vqL7USWUqTQISYhP1VLZfQ4BIhdMhlVc5y/Rg7q/CBDYE72Ps2l5y7Vxt1WhxnBagpKtKgQIZ3uLk1gqzw6YiiFeJ9vdKQ9YyMJDsk=
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


