Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB54FCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E068E001F; Thu,  2 Oct 2025 16:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEB88E001A; Thu,  2 Oct 2025 16:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004718E001F; Thu,  2 Oct 2025 16:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E446A8E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:57:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD1481605F9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:57:02 +0000 (UTC)
X-FDA: 83954383884.15.8C93BB3
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D5B010000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:57:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sz8oIpjo;
	spf=pass (imf14.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=kKCybaCRcWhIGIA1E9ED+dCqgya7WrhETsdAF6Ij4HXUStldDvC/4iFL6kQgpTxF06/+el
	pSEnQqyTHbGVPAYzRNDqKBRjGsiGCfaw9/q8AHmHCSWu76cDygTYP9LVvS8hP0u7OE6/4X
	mJRTf0btRp4kRvQ7UV6vUu4yFNZu/TQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sz8oIpjo;
	spf=pass (imf14.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438620; a=rsa-sha256;
	cv=none;
	b=4Ah468JQAu2SxupAsMi6JqpBEtTydpFYPF9bl7J8a/lTOEy8e7qhauPjOr/HgP/4hCWLI9
	nwbRM9ToPOX5j20uTUBG3ArgbUAWPgmL1b1FN38PxK0/8oeNawi+Ro46bXnpA/Zj8cKzVZ
	ypqaHL9AJPpP70KTjA8ZcnTuXi51vy0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438620; x=1790974620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=sz8oIpjomPKcbSbtdWte5LWCtkHGe6p2aM4seWYK1S2KgDxDT3rWrpD0
   KYxfV3p4zNr7XTRmiZLQ7B64qieGai758aevd30zjZYLVSsQlLbfz3KCQ
   mA25U/R7QGYbYY/zNJW+2kiM7JVDlyv97ShNlDaMlvjiRD6WLjr1euwRE
   VHX8WxCd54v+U/th+HfcXoROtUV5kE4ws8OYb7o7+ye1jYVYHQUyLHw/O
   GyJZ9rAv4xMqcqPsctLNTDn/S8miNNm+1npAZA3wHR/IRBiyYL4v7aPG5
   PlOZeghIXDJ0nT9c3ynjvtmpFMDUiFKOszzBNbHB99GR0f4k8xUfEd628
   g==;
X-CSE-ConnectionGUID: pa68K8p0RQKi9iAQECHrJw==
X-CSE-MsgGUID: F2QbikbWTMiwDr6lf2tDIw==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="3028731"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:56:58 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:23304]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.121:2525] with esmtp (Farcaster)
 id 818ae5b4-4d34-49f1-b54f-e6d737a4bce8; Thu, 2 Oct 2025 20:56:58 +0000 (UTC)
X-Farcaster-Flow-ID: 818ae5b4-4d34-49f1-b54f-e6d737a4bce8
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:56:52 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:56:26 +0000
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
Subject: [PATCH 18/19 5.15.y] minmax.h: simplify the variants of clamp()
Date: Thu, 2 Oct 2025 20:47:32 +0000
Message-ID: <20251002204733.35652-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: b6sorcxt94a5zcmqjaznwjecx85drcki
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D5B010000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759438620-794194
X-HE-Meta: U2FsdGVkX188J0OPujh0p9NGCQlvwuIRiJEDx9d+wr2TlFivV2Zvsabijui8hkofMh5KtACEK1rvSsjFwLKGUVn9xD+vQ+HpNguczu2a92Hlb1ILqwAJ+gz1uuELAh3djb7XmIqYfdpAVEBRCJGAddWDC+n9WKjkj3bimDbYEt7ANkMUMeo4+7UD1q5ict7nVUC6N6se8RRtzDCmyjabhGnGnwFfo1q2aIcFmr8pKA7pAS+lGDtzJKIk4w/Wg1MvrK+hwyGfrYIM7cpA0k3Ap5WPFRuKuc1uLEBhJHuJAlP5d75e6nLqy9reib9tYD1jwi21/E0PCtRmxWbql3BUYYO4Hd8JzWC4W4m8fSykRge6nfIyiywYjNYPySLdBgsy4xjcWZEw9sY/STSq0uAQUDqw/kkNGiMStEY4uECiHCgnxFiFwzSDf7Lf+rACKaoJVSUg5K7c9TgA/O3+3cGYpDJDQ4uLTLo27/GAgX4uFAXw9Ame3agXct5/lyKrH7/w2gSMY80L4uOTElbwhbbNwVNlvG0i/zEwVamTaiEM9BllBuOa4ULwndYaD8264exCvqvwDIiDZuyIyc56q2Ym9F3cXykONOtKrZ1Fwdo9r1lDvNKRbhvH6dBF8F48UNH2XxoJnm0GkvgkJd3rPScSb+B6/dFy/y1lgBrnezdYYi//RgK4xgn6Fk9HqBrQNlNubJ/FreBefRuPqUpP5PTAyLflWhqi0t9vSwFUWxdnHhcpad0VaukiNci10gg2wk7jmNZjjrjpBHkbzE5ZJUMwjD14+tzRr+9ZgPIM7pMrekuXZ1P5xv0i7RwxVbTPHE4s018gR2KkoavzaaYzRkAN7H87ZgbcDcba9ZqFLvt80TQusJbXk32XOOruztqpErV75ZRsfJOm1p56aRiymtNqKaJ/MDOLvREuvi/KnzUxVxzk1nFVXem3UX5BTqDZAZ0D5m/i8Ys4hm/n4HK8Smh
 yA30iFzx
 3gYOQKro8ZJ5sr47K4V+Qs6XFydmRHC3KuFM741MZt6w+3XhBN/hB6+z1FLqC1T63gHw+HzSbf3muWJbxoDVhAXTxWjFr/x1tV0dmHg8uSiUlmqH5qejuylksRaZzMV4/mgKg3QNDMeCmfaHuXjt7CAInyR2gHlN6P3kf3FYKAQrH2crqZ2ojny4iTLejnYecUGAft551wrHppfcMqNUdDUy9c6e19TKN5F5g+3isH2J0dmPuE/v0zOTA+hpYp2WYs3hx04FMMz9Sd90Zup7KLrUryHXb61EqmeD4ioFoTKF/Y+4zqN8ws/bkiSqdWHJ4lAuzj8MtW4zCkAukvSFEOdu4K/kqj9DMA8J7qoI9heNInkrANwRQS3Yl+W3c1ULAn0c19IqJZ8k1TqaOrnpCdRUEuD/I11bG23ZP9rjlSCElkHq45hoeX5O1tNiuBH8d1JZYjqdJkLrA/T1RBJFfBNEaWixsmhfbP1BiPTwM7Eh5WaNO097vQgTd2PYdzXD7Ap9FW9KzYH2unHT8c/jItJcUJkXK3Gm2t6iMDDjjRz14z26ucr0KewydRYQKE8Wb1l9ZlPnPvhuggHy26KQTGR/NJ0ZV+1jYSbbIMYsucM3TisQTTvw1+LqdREwAEozL/yiKR91B73hROcAKgo1baDded19KMx/20nUFfLufyC7McoDtozckf9KbVSSCsmTFlvpfMHpMZR5tiKGMIt2KFKalF6PSV8x/rnav+/jRf45OJuQT3BLbrKF5nWN4VQipCJjYrOgS4qKZXzyG3fYr55Hk3nKbI/YMVFVcktLMl3MM1CVmuwrm04yxeN8EH6ap26Khze9l2jKUZkuIsWoA5+xYM7rd9HXyfxFrzZvrmD73lYBRYMfnysPdwfV5aaLsoFiyPiv/UjEomQKVkH19woGl6eciXfLEPzWHr37tfF6wYiMDuIxbyO21sno3B6d4BeIEyl5l5teGPi1JrXLDyy5Hs11k
 Dulb7+Sx
 iNuNElrB/l/ksY05woNLnasm2KpWrMo3TFfvOkfFAdCxR+3R0sTkS0RZkRrTwYyKFJsIATkiYE4MEBuQyrtogJxNnS6/xxsnNKqgkepDsFGn0r25jPFvWT9nVbtIOKXElSi9aurq84IBnw4pg3wPixmV6fj2737A3NLSSUov8vRekyqCOa8g7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 75fb7a6ad4c6..2bbdd5b5e07e 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


