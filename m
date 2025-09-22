Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93374CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0C58E0017; Mon, 22 Sep 2025 06:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8728E0001; Mon, 22 Sep 2025 06:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE6A8E0017; Mon, 22 Sep 2025 06:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCC058E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:40:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7602E59AE9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:40:12 +0000 (UTC)
X-FDA: 83916541464.06.DEED3B7
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B78E1C0012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:40:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=c+v2pWtN;
	spf=pass (imf20.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=VOPe9w+vxSJ5HPsLBg1uDPvGUl4Ln+JHYsqH8gTNh55ke/RH/Xc1CvlB5c7T3k2k5RY0ZS
	S+wFKqvlnvA228B+mTPzBiMHe32mggLlK1+nWzOWGVvTRLIOsK/P9dFssdb36xRdBKX+3n
	7UGNfpBmKOkFrA58dnGJ2sojjzFPI0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537610; a=rsa-sha256;
	cv=none;
	b=JDV32HB9q1wU4/3hCZ5LMnmTruHceNmFtxkG1tKyTcbZFQF55TVw0rgOx6KafEitfLcRMI
	v+0RIZ89MEYOQkxRl4W297go3kzNvOyPvlmZs4ejPktubGmdZ/kdqeWvvxPDsTJMyxLDds
	83HsrjusVFYWYtWCv5cSH0TsKNl4++Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=c+v2pWtN;
	spf=pass (imf20.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537610; x=1790073610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=c+v2pWtNGhfbLFkpixCNoosWSRdaMTwclGTYqpnKiaknpbfjJDWyW+CB
   MXtpgznFAEDdt40dfaoMn2vGPjLdjhhfGZXGMlc7HM4LgsI8mE4p9ckfx
   DiJEzwyFOpZZC7hmC6aG7kH/USXD5zBG9qqzbAZycUmQOU84nVoP2nBVE
   Xyqh0Hp8ZubpY6zJHh8yeCc9GHR8zQHCJLoZsHb7iwnT6W+pDGARFV3ac
   /KL5/RZqrBSMZOBEPLxRgNzWlFv4G4iUc4tVrJqXCavXvTK6/HOTIoQkq
   oaTaTQc/jY92PMxmsyx31xhr49ESg1C5el1jRwWq5zjKsK4gFntFD5mQo
   Q==;
X-CSE-ConnectionGUID: LWPz0dB+SMOpTc8+9pAINg==
X-CSE-MsgGUID: 3lL1NnNVR+uXqKkvB0bWyg==
X-IronPort-AV: E=Sophos;i="6.18,285,1751241600"; 
   d="scan'208";a="2476377"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:40:08 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:1957]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.238:2525] with esmtp (Farcaster)
 id a51e5f9a-9cea-42ba-a48b-3a66a8016ce1; Mon, 22 Sep 2025 10:40:08 +0000 (UTC)
X-Farcaster-Flow-ID: a51e5f9a-9cea-42ba-a48b-3a66a8016ce1
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:40:08 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:39:41 +0000
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
Subject: [PATCH 13/15 6.6.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Mon, 22 Sep 2025 10:32:39 +0000
Message-ID: <20250922103241.16213-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B78E1C0012
X-Stat-Signature: 5sjyrbrfr81fp5z4h7z76tx94ne7zsid
X-Rspam-User: 
X-HE-Tag: 1758537609-743806
X-HE-Meta: U2FsdGVkX1/DRQb69X8Xxo9UO3iYjAkp837RI+iCmUna35HAUQfcCTtp0JhUttCHC2iUaFWDMxBeL/7Xz3y8QXcN1LJK2p0ZX47E5Dcr0d0D0SabgYiuRzsLKkkwtafvljmnvRhZQq3S8yj4v+JvBNttTpzMbjBT03gZDIQN11YuyQt69bekKBIWSQeQP2zByXEquNzC1hPqUqCmwdXpjQOhlnqxOPcMPllTbx0mDRIIiWYcth63L8/F5cmy6+KZlfhVs9SOAXXLtn+EYGUufVTxsCV34Ype5fHUlBVua31OyjlOZWnY0ISyPAJWGVBGXwZp8S25tFZiN5pdXXwrfllmO+IABPgvZcRZX9zod+JbIqrqGYiaEKhnAZUDySwYHRSTzujLb1HZccU0zhy7qZ6hTzj2Aoo3LqHZrTrRYXGEX28gkKcRh+3ChBLT0pYooN5CsAK9P5sMiPVn/VsbJ8MnY3VwyteJKZIgkFXu4S9VLuBoDHzjVmy2gYFq+ZDzqVKoWyGTtrt0ybnDoPHkQOzf2fkLuXgMsgWKtFLsTuK3FpV7hUsVyktd6TYRq7fjRsYcm1426e4AmH7IZIx85rBCUZXqck57rgjAEsjR4Jvtso+HzQAICRqKrrc6R1gTgWkbZvICLTii3yha8qOg6VEyqpftUdEQpt4clNC2GyXesvHSPEA+gYGEhhme2J/Z90QOZu6kuVwvmZXD1jC3WC5q8pD0r0rWMIGvEPwZ6vBjKpMVuYrVbUVi9KBIpnwvIiqMblIIrRtWWSp4NM9P8Pf7k6znXAWWSVWd0zM6L641QWnxtbTEp2HPEE/VUzTx0OJDHYkZ5n/BpNkyZ8Vr2rqL2t87VbMRCKkbVoV14D5V6tpOmuFsO0OhvCpLVB1AWlCPma4TuRCoeIPUBEJEy2rcBNFmq9d/4c66LDfx4beK1BUaDT5rfGETI0OWyXpTkfcuwoYwW41viGncFRo
 uETWtobM
 2/Qv7C5wNHllx7BczI2HlQ9xKddjzkGlRNpTU1VyAGSMyklcqR6HR+NVAntsTfvQoWSh10TmxVws+fdP7ZB2PB7ERqAemH24+1lfhRl6zy4GnyAMNsQrWTIz1LgcljikypxdSvyIBt4jkGr80h6EL4k5EmZLjwDAdF8IUAg6Eyi1M15z0Tb4lgW6Oilfn5ywMA29MVOeboKlzg2CH1fRicm9dFsmZs4BjQ4tpp8QJYdmhKw5VgRlJJgDzAEUwpzShG33VTvvNT4ZIgUzwLMg46HthJIdsDtdnc14RwuLvEFpfUOWLEZAvZhXhhp/d7RKUpHAvr7pQ02lB+JIlpIn0lTkNY2/tUL1WsD5wz+La67/IFMUYUZP6Lzp/N+LhshE8qVPmfJj/kfT1iuQX4SlHJsL4VmJ1IbvpGwH9rwwW9pFjyaseQIkcQ2j/ilFDIC2zKc3G8ldi7yOZRqcdJmrS+vuX6Ar6SEhMNKS2zwfTCcuLxPc5NEpJcPLw+6Ir/ixcRRv17bcGr5pMm/8FNxKp15lKsAwZ/rNEYPcMg3dNhhJSd4c1o+pexxaTB9zP8MAGpXya1lDol7o8BJEkGoW2W//KtgDTiAk7jG0IFz9Q7Y+JAkNMmLVjY/k9nv/mF419qrgushiun7wNKHn5mQzouneOwPclbhiCcRN0iYk8Yu0kuklYsZ5ts7vDX16ViyLGzzjyQQq9eqP7XcK+04W5VS1PhqkCTMTLyRAqnWYL7ytqK9SpiFbgfLqjRQ8Q7ntddJh6rg7rT6OrogRLODzOys9elbbuG3rb7n775QjIZjuf6TavN9D3jQRqUsGge0AYMnhKYPBbuaaR9owtje93Tx8E0WD3hOkEn2GGcxeNLsyV8wpeiP+vTHTxbNMSyXrT89rFIAUjciWlsRIFbCGtnghZSW8sEE0DDrWDT8PmLznEtVC1P8VNZexZ8btGV79vc/OXQZvCHhQAR5W63EvvZL3vDicR
 bD2Xgg9h
 1LqDDtakszHmJCr3zOMmH4fiZrgEv5zhShTEnBlhCs9+C6Gbus8mTFadNmorMUDtbaJbEsr47I/b2XQKOUXSIfb8c81iUI5l9VhsX3pOTMrAzWeEOTGo9Db6Phuv7f5ZYCCsLcxDtcvxtjGyZEWvJEX07jSx1KTRxYcpPp0W+dN5jiIWhi1S2qnY3/9fNfK3+IItQHna1X/K1QAF50GPf+bx34F1lGXhAeORqhtv5BacfwRwRaIR2lWcPOXFezw/ZWMIP5GrwsIrVD11HwYnf588aAFC1rt6OdzDH6Qeb4Ini6Ku4u0nQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
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
 include/linux/minmax.h | 109 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 91aa1b90c1bb..75fb7a6ad4c6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -170,6 +154,22 @@
 #define max3(x, y, z) \
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
+/**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;
-- 
2.47.3


