Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCE0CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97398E0018; Mon, 22 Sep 2025 06:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E7E8E0001; Mon, 22 Sep 2025 06:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84F98E0018; Mon, 22 Sep 2025 06:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 980F78E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:40:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 330D687336
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:40:44 +0000 (UTC)
X-FDA: 83916542808.06.ACD2275
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id E10A3160009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:40:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EX9jwRdK;
	spf=pass (imf08.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=40GG6tzUcW68XBB8w4YaUm0EDpjl8FVuUAEuwlvNje1qhGDdREXVva4sg4gHwuaWR+G0+D
	S2cXInAiwXW6G/wztaTMftNt0c6b+UGgKI2kmFiKkSLEQ4qIoaVvn9b9md4qOQIMqmomdU
	8tsN+WsxR8qSjW7ZqgUa75qVtKu6swA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537642; a=rsa-sha256;
	cv=none;
	b=F01o7IkH/xIQFIjEUefH6Vwya+USyVItje4w8uzggyGdGiHTTRb0ati5n470K19ZgtWFcz
	QmxzOAtEpeZ1YzyciaAH7Evru/8VQAmxit2z8RiMgpFpAm4Hzjbja41AMM28PRDpZ2DjiU
	RRjG5dLxLVW0U3y+qLrIAbOood+SdOE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EX9jwRdK;
	spf=pass (imf08.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537642; x=1790073642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=EX9jwRdKX7gEHdafS5GdoU32ou7b+sBAQsmHkF/DxQ/Rds7YjGjCcDbN
   yb/ofCirPKWNPuMDhsEY64X6yddpZPLBrxxclGXFb/8wfzkOTgO/PVLZi
   g4uBufCIlDb83iOPTtynO2JVHEk3upF3UCKyAwM5enePvhS/57guUnZ1E
   Z6rIGmOGx4VV8PZ0s/gbC7P2P1WeXXK+2G/r7fTDq6yNwhUqlDx3mTBr0
   4ea8RO9mlEvybcGhPihaS5G04MEU1O0ErRWyzwng1vBtw+NzG5RjTYrx4
   fVv5H+y9rGT0K3rzBQP4VqzuOYDk2McSg7x2Bvtt1QJiU+Y26scBa60H8
   w==;
X-CSE-ConnectionGUID: yPKUa6hNQIyWV81ZIlYO4w==
X-CSE-MsgGUID: Lb1CdkBpSKmBQFpgA4mZdw==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2376821"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:40:40 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3914]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.240:2525] with esmtp (Farcaster)
 id f9be43a7-3f48-4cdf-89db-ef1f9aebed8b; Mon, 22 Sep 2025 10:40:39 +0000 (UTC)
X-Farcaster-Flow-ID: f9be43a7-3f48-4cdf-89db-ef1f9aebed8b
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:40:34 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:40:08 +0000
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
Subject: [PATCH 14/15 6.6.y] minmax.h: simplify the variants of clamp()
Date: Mon, 22 Sep 2025 10:32:40 +0000
Message-ID: <20250922103241.16213-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: oxuwcunftnm9383mzira1e4chpzhh949
X-Rspam-User: 
X-Rspamd-Queue-Id: E10A3160009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758537641-78172
X-HE-Meta: U2FsdGVkX1+kF7rzEl9eElgkrODdISNK1ktp51N+VPtykO7V0uRZ1tnhwzJbY4oK2deuNLzAIG5T/O8SFdmKIfl+6LM3fG9VS1cjdo70Y6vRxn94ouRNKEQQIOFND9+0B0ZEYuIH2pG8dR3NbQ4nYWPcRFTTFoY6S4fS+XzgytNnNpe7onoq32EviAFl0t4dSl5FqpXoeOXacA0PRJvBMZ0GZv/E/DjcCy5EMx9pJe1RcczuIU+Tsm/H9Srb6rAMeDXspPLQL3nOQXGBKANSK6UVHg4rSjNer/DVlcEc0YpA2/r27HW6LolHmx1UEXnq7LE33iL6jWYOgMABHxDAUSeYBSrMktZDvJDoBb4iZ3OeVpup6oxubqC+VkLGaPRRIN/86RnEvBBFU+SJbUr0yxcmrPudYrskiS7EW0C7vZBz6xLQ4tP7z4BRS4R9Cea8Ukl+d8kntdk8luJfIsLWb7vCXwMxgpkVknJZi+HBE28JaflHmsN7ccbMGxnaz/m8EwcC5/+AcZvoHqOUxPXegaeqZ0dZQTdtq20uwLAA9e0mdCVT0aPMCudetfCArR6z2NUz08LccbDThPC2i39nPNtvZwGtn5aLzi8fk3CWXWRJUMEX71ZyYJ5ZWZJEw4Q8UFT4HPFzA0lcyZuIuOIZjMcUiWgi9ix6EVKJ3AJI2OOG648FJbtA0tWjcnCQuJHh0c8RAWTwoXtkz3e2utNwHvrXuDEzKKQucozvgDSIgLzkg/PmKou3tmQk/9BXRh7veF3Vj3mfHc+e7Nq8/nBYmSGp6XcfPFr0cQC1I9p6iPAfCqffF8TrRM9Je7OIvMB/WrYDlwChgYLg/i/NqgpcgoX7d55Befbs252SvMo3ztOTweTygMPMZUCcktMn64GPPlWbd4buDMnYuZlBXcqWvkb2L7qPUfOY2J+p8LtMO9cvrwvOa0/5GclES+KoEyTctx5oa6tRL/iP2vnNEs/
 ZrmnbOk5
 4+orZm2sNwm24cxC+7718AjEdi22FXlcYpPt0VBL/e1sB2LZzAFaXz4XEhZthn2VCl99RpPmZbI5fjHZXkWWJ6UBx4t8KCkro56dST6Rm3SDP+liqlkk1kvsopTx+mcS7IAY4qz3ZLLcsvHMQVKF3QacVNNFOibj6yh8mekAySZBzAd8B9FZrZXu0zukDb3t9azyhu5Ii5qnBX8o0U3QGi/bFq3+avWP+bS6rtwox7dXxiCdLngq8zNAvbFRzcbB/z82DB9+YOAlsi1jNMVj5rPAsTIzdnSDmnl9w1l0+ms+gaE5QVhZ/1WnscqZdoUWBhssEH4wxgqgeGI9r7tJ2M9KZa8lueHsrZKM1/NKdmoSAZ+tKcJp8xq1F2aXPUE/YaS1MM3+MjEu45MBLcVtruwDnfnHahCZMD8fAp5oYQ04atlkKuNjlfOLnt2GtNW8ku3H9UWjj3Zgi5KSZpNBge4B16G5wD5vEgqqFFOMeKbHlrd4e76Ti6my/MA+oor3EopiBXHaerFRIvrPzkqZYzwpzT1/zZHbyxlghjSTHJZTWzMAWu5OXJjkCaNFWzwoIq09JPpeU5hlIVOxGiDMqCLKv1JtJkYv5vyK9KmHZlvDb60qlr/Y6wC+/CnF5UkYBZPSS3L4eSPuBORa4suCS34eFXQ+NgQ/lTfLBLj/0zHh7ipuLiCTNEwwbxUtzlKNWu5NJaOYxQxz0JU6It/LgCN3hXP3xlx4Lsq0bQZrGXJKdQoZoOM7eF9791qcdR5ipyaeGnVDnUoxNW4/WQztRvkN4L3l6gLQydQlOAp/pe1ND36+9clqaoWRx4xuUxcuBrCkFaXjHW3Oiwf+xxaWC9twOEi1JntD5NimZN5Thyw9YMxLE4ZNFHlaPijFhfXpNFCuYDe4OBrD2wpGTXEuKU9E0GPXUt2Woer4J1nD4Xs/xWFTBVgGsGo2XhM2rp9rzaq3vrhfkh2JREFvz4PokCGDC3R9D
 Zm6FB7ZB
 LAGMP12t55oZdWg6wMsuUQDO7VCiR9X+cvFBH6k8NkdZuokcBd19Pp/6RDGicNj/mLoQRDD3197Cc3iFVRgSPnGwAdHsN+5I9oi91sM0x71Rp4J/tCpmjzh5l/jkWwLmWOKrocbM02Ckeqfpb4aNXUb+7AnPbSgMUC6bw2FsPiarlgWz+yDNYVD+oy5hCfXglKNGhpNRjI+WQl0Ma7WcO4/8VoukeGa1b88qfHPxm+krCAgUJFkEvuggMr4pdmH/Rl6m0cOIyNYAyZxzWFmx0BbDOSH1g8eImy05CDwK8qX2nDomAmMrrg==
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


