Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42EECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F32E8E0016; Mon, 22 Sep 2025 06:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAED8E0001; Mon, 22 Sep 2025 06:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1318E0016; Mon, 22 Sep 2025 06:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4DB8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:39:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE26359948
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:39:45 +0000 (UTC)
X-FDA: 83916540330.06.FCA6AAE
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A57F40002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:39:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K7EPMezX;
	spf=pass (imf27.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=3yRQp+oGFLm81Fff5KJ4rZnFL7K1Fv3Tv6aKfmexihUiEMZz9Iswou21psHTgBCTg8fUJu
	58kXcBF3LcwoC1oBArBwjI3ozKaezgz9r5jomzXJXSaFYzs3wRZqUPILR6+3iXdpuGfhAa
	5rXGtCNnr0GYZmyI3JIX019S/RmPXtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537583; a=rsa-sha256;
	cv=none;
	b=xF3gAgrrou7xtD+j+q5xpVIxUqJxC8QLXwvV/CYU7h9A9LR9bi5Wv1WQzEDSU7tBiSsHou
	Mt9LNZ/XzmS9qulij5T72N2NNzlUbUiC012XxX/Xs5UY+VMYLaV6viZ8P8Qhvd7XKPt6yS
	VM6cTNMG2XUtKIcCiNasNVRRDR+ys0A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K7EPMezX;
	spf=pass (imf27.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537583; x=1790073583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=K7EPMezXs6GGIUqaY0rqDyM04bebXVzROwSsbi4g4+qjFhJ1486HffRm
   lr0Td0L8BS9L7IL0Tf5R+h5sgWuzJeqoecm+r7Yabu/7V1CGu5THbxRNI
   cJ8QoU4Lc0wvtp74obaWcYBiLijvQqr29kfLjCUPiT2ViCPOfWGaSDBkH
   s/EAXb9n+u2ecqmUjo/00D18zNcDIqLOdFHw29ddJVg5gAQbKMndfr1ZX
   Bm4KakKzaa1FJHb+LyBUHYoG/q5hb8D1TLOIy3TkP6+ISosI1jYwXRnGa
   Dq4Yeo7GcgIJQw5w8jR+5PrCkMfSKl+6aVddQqMmBKB6UD3/vp6gVR6Hf
   Q==;
X-CSE-ConnectionGUID: Yy5MXqq0SuOr45TAb6+6eA==
X-CSE-MsgGUID: kIXRtb3+Raib0zF9Z0evOQ==
X-IronPort-AV: E=Sophos;i="6.18,285,1751241600"; 
   d="scan'208";a="2474300"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:39:42 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:13983]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id 3a827211-6b35-45cb-8651-0153a666f439; Mon, 22 Sep 2025 10:39:41 +0000 (UTC)
X-Farcaster-Flow-ID: 3a827211-6b35-45cb-8651-0153a666f439
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:39:41 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:39:14 +0000
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
Subject: [PATCH 12/15 6.6.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Mon, 22 Sep 2025 10:32:38 +0000
Message-ID: <20250922103241.16213-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 7A57F40002
X-Stat-Signature: zp1tyr7bt8yz6s7q14asotma1fb6w5zp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758537583-855986
X-HE-Meta: U2FsdGVkX18QrQbjxOds1wr823UC7lPMKJPSaujYZX/f1/W1ggcX8LJMH3lyzIAwZIfo3yGt9ytSndKSXQc9vlbtWDtmASE8mUsJLH0J32MCPCZkJV42olsbF6g6P2jn4P0yShMxoHkTsMI3n0wJZYtcIbIqVmWIL5894tjFQw72AvBT+RZ7YYMluaSh0DvZaKylLkUNfns2ZrtWROG6iTtgCKPajDa19f6OJlDhUICDxj4P5ahna2qwwaEf22h2pcujrAHRZP1piZ9KpmRrDljIQ+ZWFtSNdQPFB4ujrtY4hRfztY8RjEcanWyJy6n5lcl9aLR+nAFR8Q/VXTzYpgc+07/fmIcSPaVk4ed6M2/U5SpXIMMXn2vrsj0WqLzEfKjBWyNj2+zxUBANjRCcdd6RVk5CWDIUxGT0GUnsovEU0B+tmIwmv81bClfWNf2iENgT7UR45OIph5IWf5faj5d9viuzfHznoH8g3rDXwGxQstMEj2Tst61TzQilcYIzbdzxNp27bPECXhNR299cDcAa7RtcqnGg22ujFjfgqrnBITul0G/kwbEDfDgFlusyPhU5yIZMErLfJs8ynUWZDqRybAIaN0xj/oSgPj6omf4ZrTMkNuv0R7s7wG/nikFAgraPjhX8l3zrn4Dr2+31H3F2HmWOuwdZMwEuL5U1WMbVUy1yjv/C2eJ0d8QRL8fMhjdAPQ/6SPQqWp43QvOVtoIeLGulo08E8Ct6PR2HQm73fL9+pJ6VZqDV5Vj2bL9VJAPcXXJVs4UyyYNBFfnjOvKrbwsVF8y1jEB8XVoHZykLKhQJD8N8zpYNkRPpNwaENdsCTbkR4n+IEbs6pbsCiEkcmL7bzSwgwrYlXzSQy5VOapW94SllIFQJoIY+frWk50quhc0CSuoIpcVPlqFLMo7EnNw8P+stR4sXRwGgENfp3pzSOyATVYzIcXi9B4c6HL6R41jYjPnnmjOZlAY
 3a72JiLj
 iNe86OihDGBbaFMiGBtuh/IP7QQaSD/Q+BMY8oDskcpcDGHCVDwiYT32V25gMSDjTnFNSsA3FQrIB4gm5ykoytzUPj8+erRdGAlu8NCJITW954BJSQm6oRC8WkHAnA4qpjEx+AIpP0yEE2CTdVSXk1N3jWBaMfkhkPSfYs81CIYfQVMAMuWaKQTWE2TDEeYl0Dpjiir96AMR/G7+4IddB1s7TmerWgs3cnXBl6p4qhNl0t0+HeOQ4pm86EsyM8bx711gFt19lqFgehErm+nGhmKA8amieNzurgD9NoVcLKBMZJ+VIl+oxeU78w+vgIRNp+oR40n4nxgb6QtdDqJ31uRSlBWHD45uIsuEypM/DHhqRdPoQxkSqo4tZe5xSvtCN+McRYdfiM29Dnb+MSiaM4KA8wk8KnurXtP7kxRRCRBHldXEXT8+tgvhkISExXx/Xp759dSYGvb+6gdz0CVYku2X30RBf7mFVrJ8cdq78Mzbts9m5889/eqMQwY7O/TVpjlrLiCQ8lTDBNT2ttoOlZQfKhlPwdsNtTzcEyFRMsA2w9/OrKaWmE+4bvy+6ErTY+LpDVFGarRTk96Y46U8Ni0U9f7jwwofj7OxsFnXapeSlZXzAPEM9fwUzkQt9/VkKyAPMLzPfNYz4zO3oIKTEvkXva9dvaaW4Jk/FWOLt9Z/hPGm9mJ4DHpp0dlSxwAJ3twP+h9QEjZAX4hjtWCN8wcUCwopFdp4b6Huu992RyFykVTqt3cYrKXFHaUl+wMsk1aJvTFD9Cw9c4i/d7oy0zUdRWL7Vsdh3jMCG/4PISMOCx7IwZ5PxMTr8jPTS9mmuJOA5WK2mNBV9aWUxcDHhep471UEEACuXm1Qcofrmv6OxiphRwvsmlYQG8x/9gu7W5mJV+yRrMpbvJSQb+RrQw1vqgfIBBCkNW4R3+xKPXv9pc77vnxJYO32WRcK0ie9u5WJrpA1/hX+XkvPKGDCjKJVlZWwA
 LwDShu+l
 UaVgSi/bNOaQiAEQ83WIBzh0kVtm7dC3NBG0ebFikmCZzmlKZkUxg0bxMnhSV4z6mNgw+EeL2f+yNfF1pVZS/V23IrfIOJDWWmlfli258E0p9sB1fAubYMuocM+Dg+xnJsH/wTanelLXWlEej7wSyZwNXsM1WRT4NsT7ifp1jGBhTNasaVPy2USnQVaORxJ5UJPgvGrRyh3asMlUS1tp/fPGbnHBJym+FIqbZR3THPfpnsLC8n/I6Xkbh5A/u/1Uc+CT/QZVgoUk5K+WcMrqrs8+r9d0a1CbYlEM3NEl8fMJXP6IsKhCsTDvnjBddK8hi5kki4SAE4qVFDwHlXvikDZTjVYSMD8/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
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
 include/linux/minmax.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 6f7ea669d305..91aa1b90c1bb 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
-- 
2.47.3


