Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106C6CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A23C8E0003; Fri,  3 Oct 2025 09:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6529A8E000E; Fri,  3 Oct 2025 09:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9688E0003; Fri,  3 Oct 2025 09:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 374A28E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:04:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0392711ACF1
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:04:04 +0000 (UTC)
X-FDA: 83956820850.30.EB23877
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf01.hostedemail.com (Postfix) with ESMTP id 91A784001D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:04:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fO32HyMV;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496642; a=rsa-sha256;
	cv=none;
	b=SDkoJLaPR4J9k1xx6bc/dQl/UtiFuWZiQSK4/Z4XFHnUrh3HhBGrVGWg/TnSz2XUXfDbVD
	JFrtvmUSZ4urXYaLE+MmCl/1tsihMRyesf5gSs5oZUWaLnTAoI2gRrxiQSAz9MYLgSiU2I
	WtZdUcAPgYPo+ZBCreRmbCaLSe3c5XM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fO32HyMV;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWSej8xbBt1No+Mk4Q7cDNVqN1sPbiSh6ZSRtMK8qI8=;
	b=1f6ojV7tdisx5K48K2kQ3KEM2EukiVcnflafkeTW7WymA6G0WOyiOKcc76s9EwvuQWKbhf
	kVRQ+Zq9QBSL6h/WlINM2bcICZAYr8Ua1saipJQPPAv73wKlbyyHGEHpFuc1XBQdcehDS5
	pzZaawnOceMgVb8BLp6Iv9f5co/smFc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496642; x=1791032642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nWSej8xbBt1No+Mk4Q7cDNVqN1sPbiSh6ZSRtMK8qI8=;
  b=fO32HyMVonkxbciYiwzqF5hfhtxVss8amxU+QIV8Z0Uqd5M4stOzFKo1
   UgRycYTd5AVK6EPUzMnJ/HWsMMoJ6l3EuPpxg4en/8ba1rF8q9vfOxRcf
   glsw8FdM+LHMQaTawUNk0w704Rn0w3VZl50yecmOIJ6BEowcQzXyh8vx7
   CzJWvsr66iIgdkBRAXNheoCDFkUE3Evs+sQAsFUc7TTYinkMxb3iSSC6/
   LIDsMRU+Xu/ECvx1seOQToZ80XL4AANObyvc+fuRNgh3RmTkcZQpXfIYg
   nHDGob9LR9JTMTVoELcpUtb///4mtpxsvS5g/e8xs0NxQE1tuYSRdUaQw
   g==;
X-CSE-ConnectionGUID: uauqHzzGT8CWLIxTZUCqPQ==
X-CSE-MsgGUID: iLEH/C58S9uyrBI8b72WGw==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3066489"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:04:00 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:19702]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 94a9e6c0-deea-40ff-8bf8-c2afea5d2574; Fri, 3 Oct 2025 13:04:00 +0000 (UTC)
X-Farcaster-Flow-ID: 94a9e6c0-deea-40ff-8bf8-c2afea5d2574
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:03:47 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:03:22 +0000
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
Subject: [PATCH v2 07/19 5.15.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Fri, 3 Oct 2025 12:59:54 +0000
Message-ID: <20251003130006.41681-8-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91A784001D
X-Stat-Signature: 77gym9dz1sxz1k4cnwrexj94hkh97b1o
X-Rspam-User: 
X-HE-Tag: 1759496642-314290
X-HE-Meta: U2FsdGVkX19von+hYqvfFHZwFvbrV2Ao8QIrGtZk3uvMB9Cy+Oe3PXhPv2tDkWkOrLCsMXwnnPICcsA9zlCqvPtsWXnZiPFFGo3Xf2DAH3UM4BWS+V304tgsNgdzPTM4yVF0mnusEJbxXLvTticRMv2ztH0U8sTh/5tC4Hyk1hvnS0/Oj3Pd1sz22yocJiMLKw3+b8FZQtxatr7sUMXAkvX/zTZddoHecRsSMEqZKqUkVYBT3csFKNoWPyhnaHQ8UGrW/Oa8NQmlotvFf6dxbY/fvKu/eeA/wE0D6Vd/qJhBHOrvzPrUaotA1fP2tyfuZGTFANGe81/b5qo+JLU4oi1hEVOGPIwvVzjU78M6wR2mH4B60YPoKsKDSH1p+y+pIPKZ/RF/axsD1oAjoc0NGKsJJSfd2cg3FxAxkW0OuKc+nSw83e68kdfuVXGCCARTmmWww4LrPaN7XDlFouGdjOJdorspxeCnoE1/2xSmty37i3Edz+aMJmE1eF3nFPq03V8i2NWkxOpIlcaLk3VeyfwmJpnBnsIccyfAEBjAJvjf/6rUpJjVUogyKkZDXoR+hyzRq9RcjRgxfoyrl3vQToPou3iYnxUMQtPik6DESQ7veRbLpXqGfhFDTtmgs2O1b3wPQB9cgLPS/V3PeWsLtSxMCf07YMuVVN12hER+DCNN4g8WJ3jtrz4dGo0EnYGrva8jtbnQTE4HW8TEo75hBUbZC7+ftMl4TJxu5jfxtk16RRDkTjKdGy8ZUCSXNnj6BXBu0WkhqdZgTUmfvCJw1sO2A65/+LNGZ79ETSkMQjo9McNEAUQLk6UkG9LxHja5B7vqrreKffWt3JWEqFY0NkL0Tq+5VORDr/zZTy4nj4bab92neVEarLjVDB2fvLma0Ue3NBN6AXO+qNvx2f44gIqF5gT2vWoug2ASUHCt6ueD3t+SO7epaOeVMoPuOidTKUky9Kh+6/P/VEMLE9/
 yLBmR8yv
 3Cx9woNL7qGu36ab6cOLOmgnbHFBs7VWV4FEMTKFztdMat0fxzCXz1FsdLU6FtU8L/zSF4ESDtcET2QjOdPNruNFj0TxSWpUWs5637ENB6+GAMNYh0gZB03yEKHZt5au2+ycUaTKMEGspl8+OYSrduoPk7P4FHkWKBAldV2AsDidk83y1JKm6SCVsuQUOpwnULBreO9BY8tg3hRZ+f7if6Tq0GK1nMD6kjt5x3vMLbVUuytTUOTQ7XUHfoChTrWyLPrhx/4zeXFto2urPdxpaGUG4xdL3EPPRb38ImCTgFu9ojcc7EUdhmCWhdRx226hprDK7ShnvhRtkW1kZJbyVjtFRAC7kknTBWNUsIC3GMRaY55xI+eEy8wOGKSxqYqT9QqdiKqmaVSmjfAeAI7hc+07EuL1DIR4BNmlYxOAAP9w7JtK38eNhDc496BE2g/utl1gpRGpr3Ix+W54YS0Av7ccVwgDfgQ5lMYEzwAoICX3Jdpa+X/37FcTa22r8w0loEO1Xtv8sowZ1lglHYDJdAiw72NmkUIZhtyl13g10shDRhwdxKBNq/etc4TdddWmbY/zeVTrsqSBWHSqfgaymYl2Tq9w0aa8LUL7++hvkZYbW1Hjs+siQFMACi8ivrEv/HHYW7dkVBynZUByD8JVka8iKflvhyk+zonWv2ISeD7rCk8nzfkdQtn3zwPKDdYkzfKzpDWTorNsWWPtGmd49Ld9HcMTFBiJ4muSPjG4Ss+ZVqc8iOUYp6625CQkxG/sRQZbKQDCL2JRGBlH/j6go7nLVmG0bcHnxtARpQr/NufN+CDVJ7nf7UxO/K8Ua9DU2hSo+HeQI4lxyaubnDDuoZsuxN1AHbvpLQHFuQjiMob3wdxEbawt+30gXvEZ4STnlzSBQZ5fgmM3X9r7di71QURrNlRRvsIzDcWIZV52+yP5jJHYg1jOBpTOnNmlGz70YKRQGlJFiCvpV+4Q=
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


