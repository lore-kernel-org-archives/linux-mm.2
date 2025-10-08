Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE94CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA0B8E002E; Wed,  8 Oct 2025 11:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6AAA8E0002; Wed,  8 Oct 2025 11:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59D38E002E; Wed,  8 Oct 2025 11:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 947538E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:31:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4995F13B707
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:17 +0000 (UTC)
X-FDA: 83975335794.08.4710371
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14BAA120018
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K+Qpn+Eq;
	spf=pass (imf29.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937475; a=rsa-sha256;
	cv=none;
	b=QWamvZZaFD6SYFnjBLfN0pm8bUtjTeux5zzIeMeJHjse7C69Om+96r1+Jiq4Nd51RJxohX
	wxU1iZXZX4ckoDtE5HKJ46BBYpf1Zd0Bia4L2ZDVb4tK1pBMvWpfwP6uqkypxoLWIqPjY4
	2NUbz9/GvWeswszQR5+atqhbjjZjZgU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K+Qpn+Eq;
	spf=pass (imf29.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
	b=TZRQkxa4G5o2/8qs6bitKSHeEVe6Of2R2FeoXQkAVIE7IaapbICgunrBbmx8XqBoIQtub3
	I/HcU7rh9pcfdB1+haHc6Uj3ys+qMqmIdA7d3YPaLcd3C76am3OiKL7ea8Hm31F64qBgHM
	rgLaZFWxQ6ep3wPhWsJndeV8TGMhgAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937475; x=1791473475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
  b=K+Qpn+Eq4srUahIDvVnfIiDET7hFcJMLxRuAxbjeT4hYY/t19z773LFa
   iF1vw81Mx6hMiuqjsDy3Twj2aqMivplWT/j+nzrYTRBWSXWtWWZ78Q03P
   E92pJdSpCoG78T+XWUrr+xT8EzQFubtHYDLj5mPvvHlDzIWKdX3tsw7aV
   RvWKa6zvrCjGkHGch51w7fu01skPjtIhbmyyJsJuoAdrdfVv1I2KmEaow
   3uc7Ky3dmOItAbNP4xy/E089FqRFBtkkGzIXDy1uypEP3bKFwRHJpwBH4
   D1U6GNbAE9JNFKuTYb7+1IoWhsO9iRfIXPQy46l2khXSCOF36VMohlhbZ
   A==;
X-CSE-ConnectionGUID: vSaBz5PhTsunYvGPPxfYOg==
X-CSE-MsgGUID: yH7yVe3dRluW95yVSErRYQ==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4322243"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:31:12 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:31857]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.125:2525] with esmtp (Farcaster)
 id 17bd1fb8-7218-4dda-82a4-1941339f1880; Wed, 8 Oct 2025 15:31:11 +0000 (UTC)
X-Farcaster-Flow-ID: 17bd1fb8-7218-4dda-82a4-1941339f1880
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:31:11 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:30:58 +0000
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
CC: Christoph Hellwig <hch@infradead.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v3 04/19 5.15.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Wed, 8 Oct 2025 15:29:29 +0000
Message-ID: <20251008152946.29285-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: b8afry1n4b8myyzmdmajioqychs9kzqo
X-Rspamd-Queue-Id: 14BAA120018
X-Rspamd-Server: rspam09
X-HE-Tag: 1759937474-323328
X-HE-Meta: U2FsdGVkX18Kj6Xj4V4+VZ6SJ2nZrnF5k7CPNE+psRtJ4JH3nUcwXC9rFwUTK6tHX6PUnGk1DRpYxYTMgvzo37c/J6XgmbbIEX3Nf2RHOAbZV7s4ejNzQzEdnWHugLgakGUf95PFx9Yyy+qfzy+a/W4fL7cNEKjsVR88fmftvx6RzJF6znFX/a1l9hkKr5BNzy/boM4x/rF/uMfIB3floVB8T8aGj873Mu2AYk720+jny2QV2DNdvUVOibuRa2bISYoKamgg5av1svRwfz3L9uD3zCZq9dUZJs8U7MwqQe+OOvJzjpgDYbpbL/AleKm5TRj7KHeozIEvU0348CTSO12sF0paN570Of6MRtuOon6vfl8wPmSJOsd9nktS4eN4WN0W2BTz7WbK6Jwck3u/1MQiCKg/A4BauHGr3CujgW+gkiv1yqzNsgE279LEhBCBpDzB3AioUHIwPAX6WOZWwur6oLKi9z5DRxHYRq2mtTw5u97Kt2ZLE859Qj/+L3tH3JcbodSG5ADhGxuZTer2YDFlQOPxpfrMUC/pXm3qVjlFUqQHBj23PE646Q4KMbkpGvoLnjXsSR9M/MJ19kSpe0jV1Zj5KOLCJOhpSeqgZiN4j4zmaQQZasLZat7fpoY3tPv+pApcmRY8mwgxp2aakiU9BoAg1ffDXWgOBuvPRMGxM5yZj6bMvUX/rtEJfRtezhnixjm+4vANNhPqicYC2ffeZH14jdcZh8adnoXrVznuXW+RwbnNYmApMJvPz7q+dWKhkojlHT5uQ066r8aZAYTPPrpomxumS8zB1PWlMeefHWk0Ja2PaqaDL3WR/G0uM6yftpHmajhIK2ktxRiAdx+CpeuvuWbKUt2dqFsW48atnT06pTrSldd9Ayv0vOt68btRs+QwnH86XKnMlwyqqLpL2Hr7JBS4igMdKFOVdUJpGdoESj0OvhvpjIljRthclxL1z8zXLswWTWQibZT
 FYxS6BhR
 xwI9S36VGhZSr6oLHhcL1qPgE2WYCLZ5kN5dSh2dWHcuLFTeCeXzaj6u3dgenEwARu3RdxCQ53W0HjgOafKLm2he+wOVyMnNOnY5AyTN/7Ef8PkfAeeLHuvXGAspBm9UzTjBRH/UzbtSjUhVB9lZSLoGBEXu/xbw5q8gjd4xxmX5JzBR0C7LusHcKqabvawGrNSAn1FzjVR5WkTE+XKxomuxG5fpjnmqqKPOG6KUanlr6UeuzYP0Fso0f8HSU8inMDfMYjzCFN02peBAGmjhk7ymjtqbIiDtqAWGUDTJ/nrVAIXx111lMZVAGQbZxmtSB57+xoDYR9hvpKPOs5hnMaJ0I2KTjWIjw22Pzimcz1HUVSSZznGU/8BErsaB+9Ys5ny8LQqTpnEGXtxWWjodydcVYuu6RauWZBCWndbfWOD++x85mv/8oN2VmzEKc3IwfZqvjKiCwx1e8Bt0Lhzakuf85sFQrb3kMfaEl04HcxGwD5OlW0dFjpJun5W0NoIWeyWl8wLut9JPaAYcAPpQhPILDJaH+BxofoCxw7qTrwCmDVr4ReQ85+6ZIyjUEFJuty4M8U567wSiwrwEtNV9HAypF8ytzYHgAMMEE4YQ+ThVXLZQjWKIJbe2z9+gDZfCLvuSPkM35Ce9GXGbo+tXw9eVtQegNvBr2xNO2yBDBBb0vFGd16jXnGxX6XPv6FkBFkrYRxW5eYYVY+RzNqHTbVFDPnS891jWXKsT8l5bhsLlkv2uxm1n3GGHS/UeoLkVZ1mqTMx/agQW88UGTrfAZSvGfN7d+qw7fZDSfc244KazIATmf1sg4af+82UIYTpnTjmA/Npx1/S5Yhtf4g6jq3TTHW6aDfWinl5om3v/8r/z6ppJ0vJotQx5QQi10aNRjp2maNQq9zTdJ95y1qEyh46VxdAExa+bn3g0Gfl5W6MsCKQBNoM8S5BkBidrAQXC1u6KHL63yHS8ZkIUY3b+TH8YCg5Zg
 jHwZ1oKE
 A3f6+JwKNC3BHnM3SS5ppXB4lkodTNQML203Fn7QqJCypDdCwXwna8VedyTP82HNd72HDxKbc6Z+EtBWJUHXcUjA5osD60lODhVYi6qUD2AShzFEs/T7mBJzxDCJopigmZZ0Sr5QvM3OQV0Hy6IXAKYnt3UBSijexmG9R/mhYC+fMWRqDMYkwgKPkA0Nq6qOJPy/NwwY/cQtHuLEPjZtug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 62b0c0a3cf30..2ec559284a9f 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,11 +46,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -60,16 +60,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-- 
2.47.3


