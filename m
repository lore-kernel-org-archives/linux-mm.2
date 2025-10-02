Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE30CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132858E0014; Thu,  2 Oct 2025 16:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096328E0001; Thu,  2 Oct 2025 16:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6048E0014; Thu,  2 Oct 2025 16:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9C2A8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:52:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC67413B814
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:08 +0000 (UTC)
X-FDA: 83954371536.29.658B922
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D3CD40002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UVtdTufS;
	spf=pass (imf17.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teLsaTNUBK6Nro2wtPnSOzbrxENlIlr+X2oFjCDnk/w=;
	b=JXm1c3Ba/QtVCJdWenCzhsUkoHmqS3Yos1CN31cHMSOghKiSx6oxY9EpN9osHEXPrUmtZP
	U40Z9qz6OWPiIdxzup86SO/v6VFUHOWvxkXEFL8qX0bB14rbqjKKr3cmZZUiM49Q9g2vl1
	LtjOIwX/pLvXCfs1I2hKYfLw5tCmuu8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UVtdTufS;
	spf=pass (imf17.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438326; a=rsa-sha256;
	cv=none;
	b=1WGOE17Y64mx6s1G/nUHicfHKR5xec6O/5JcSawofM6JIInovYPeeQbitjmusxjwFbFCw5
	mEULpNdYTqFcvtp1D62okScOJtrc0K6lvA9CJy2Ia0WGFCXxpH2ooC84pX46QAHnEjr033
	RHK3BOlSAjweUmlRGoqiFI6RCLV1g0M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438326; x=1790974326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=teLsaTNUBK6Nro2wtPnSOzbrxENlIlr+X2oFjCDnk/w=;
  b=UVtdTufSswNi+cFqHnUoGuxQGix+OLArBpDtRyR2TpVBkDY/pyZc1/3Q
   UwmzjqRZ6JbGiOST8HjJHKFzsMKqfcNHGiDZSkv6ZaHGZu5gmnJHK7Q5D
   WQOKUyQIzk6378Y6ea4LVtNU+y8b9ttLFTGisitI+4Ko7qNk5gT4zB8W9
   J97Vw8wal2ZmQokYYn8/FJLm78M+nL3uPm8JyL3bJqz470MJIjhCE/lA4
   n/Kbv8+J9jNmlKpzPeb+M95asIAtjbOIAazhE28nOJiU1sjBFtWIMPYr2
   mLPHvLOcPgoKEpxl4sDfqX9g2QkWcu1pcdj8rxaG8DBrBzVk2TgL3LOXo
   Q==;
X-CSE-ConnectionGUID: LiiP98nuRPetjjRJiVlisw==
X-CSE-MsgGUID: ltUlqHuPSt+4mXMkmRlCXA==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2922370"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:52:04 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:27524]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id d799511a-7212-48df-909a-6ceac3f44b2d; Thu, 2 Oct 2025 20:52:04 +0000 (UTC)
X-Farcaster-Flow-ID: d799511a-7212-48df-909a-6ceac3f44b2d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:51:57 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:51:32 +0000
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
Subject: [PATCH 08/19 5.15.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Thu, 2 Oct 2025 20:47:22 +0000
Message-ID: <20251002204733.35652-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: jt8mxh9qdedxaoa4bpmgrgb1s8q9ud6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D3CD40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759438326-641161
X-HE-Meta: U2FsdGVkX18Dv9KHQHeM715tw8dXI0rmh/nK3mHGbaFtyKm+CV91q7fPKaMVlLFBbmnZZEYR0F/XiPgMyEpy6PZZM5DqfIjWmd32zusXADZ4jh0Xvv6aUAbwv62mnS28zr0/LqVFWdAnPQpxfWaJ2HUFEIkT8mDOPFcHO+GrpFN4K1spNxnJmt0p5flpFaRzfCxre5710Le0AB6uiLqTsrI0SDhWDf1ueAgIq4qusVulYxE3ZGMxhjbqVLQL1KiPntEKilmIGhju/HfSSaSgIIngNegpuZQfzfV7a7CeJs0Y4Ed+PjyLKCKRoHKyL3wE3D2HNKJWGaBPN691wAaSkBO3Y0EE3232L03uT00huFswF7I1kE+ZdndwX1U7JgM2nh1zuJRlvP+VXNEQm4xLZJWuvPhOsDD/YnKeuICOm4h0QExYyoi3ikzx1MjQIvtj77wozk9TvxtLxjpBAWXM0XQ4u72BfE6nh1I0Y1CGr+JBDCJySdbpW8esxmeOzhE16i/my2xVfDtZFIRpDDV2cYSoIVPhWaQz3wj2t7L1c4TXe6rKEQfdu7AO9mMHGdkSGRoX6mF1uMZ/n6xC1sjoKMO476xcS6TwfBjM+FfPjagdmKzOtOvrE6pOAMePMJ+vcrOWYeVlkXiw/F+pAVeFAo7qk9qGSvVVjsFwpWynvysiMm2MGcwDxbujg2W+hZbInEo0VBf9zamObR5mR5QsnDReUZPamzOdP6GQCuN2m4MeZB28yDC3WO7nMDshvr24DIfEr+Lv21/I0bRaUEXfIq/w9hhJ7Y2mV40DXCAH62hh3eOgWZWf5FuG2PKwTZicC/n4kcrrzOgRWU78VwY6jIbINgvb4ecgRwzzxD+VgR14nW4Rw8nuV4fJMJVvnYjbGs1LHzpTYJalkdSqf4UXzRlOR+zqdhWAbSUuHLxdZ5ih74dZHQ5UCe3pFQrMcQ02gVHFTHORE9SYFaBEaBf
 KxQ2GRdp
 wnX/QxBVOScI7PcLbOAonfwGYp3ADFgzIJbx8Jda+zPwiv28S7NKwDoSfhlKI6u/JxCmZ+IgbXtb2Sy93ocTCSGQ8kAssEorLbuSFhHhgd4p3bEGAWPcCMhAF/zJgNslWlJQf9Ab+xaSz0Mmt9jL5Y2bKr4DnEcR7C6GGA1u0fXSjpMoKK96Zr9lP8IQnmmYobnoVtzdoIJ7M/atgE92nHoCqCBS9zdqelHEafHezdHcUmZuk/ADN1qaiN+n7x1j6NK45fDiMzifDHVVw2NutHSmRWbwDE784ImkoBxOxEKhf3uhI7t6Zy5y4T8y6chmixGvRHrHPPBO4vtSldkELsV8C4rAFIJ7lzdvuYY+rfArpEZSAgckt9E4FJedJ+zkK7J9nDPzv6fnW2b4gbvYWrFfstjYJKrLeabxloseviOTFnrNSKdpUxGnaxgPyMgap/nf2pAA7Fcnjs53snktPFX93JvuLWNYN+UoB8TKntGnoB7b9FCkDD994oDeyOKngi0keRGaN/JVgMKE3uaLQsr6khu5Ydp7BL3yrr5x6Z5GvkfmIL7mjnYOAfee6cSiVqVSf0dSpubdqqHuP8AlDTnekNelf05KKA2Bk0bFQkvICk4pmVxyWrYp1UDtBJHVOkXKAMeLJHJFLZrhvAXgMgb04To/+yMYYkMYghxOG/7JKpNGPwmp94W877hzwjmoi80NFrZp+NkN9Cpb6tbC/tDlBIlfJM8rxRSH3Y8KceDH8qyvVYxm4vFRVrW1Zhj8sVvr2ZxA+upDQwLFOJhe/Db4UgEatwLUbKDuOmBzvkJuDGk7iNn89VWpstiM1bf8FEtcN0giTSxHK7V0IjNXOBM0NOEZzumLAfyb2DbtXh149OAHatwD1FIUmJI5j8HfQQf/oBvfoBRhBMbvsObjWd7cH7gxrqDao8YTIl1MadlBSV/6SvRNozh6TkeMurjNVjrNz9Brwb4leQnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 017fa3e89187848fd056af757769c9e66ac3e93d upstream.

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
index 2a40d3550f28..fc384714da45 100644
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


