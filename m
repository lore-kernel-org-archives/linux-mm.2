Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FBB8CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4038E0009; Fri,  3 Oct 2025 09:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74858E0006; Fri,  3 Oct 2025 09:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C628E0009; Fri,  3 Oct 2025 09:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3918E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:07:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4003FC07DF
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:07:50 +0000 (UTC)
X-FDA: 83956830300.28.C9ABE71
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0147140018
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:07:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="KHqctPU/";
	spf=pass (imf01.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=kt68ZO6U2KvuET5FUYm46eO3OY2ml9DaLq4OO2ww3m0SUI2n2GKAXdgP3LGQXpt6b5JokP
	vCGdnKictDQLOghnOMI0DBuC5l/vCziCdYqbZvKjXFTun8nlQ8ed3r6xd7NDvnnjXMEHTu
	9EklecJEVwahq4vtGxJZOcr+U8wBCmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496868; a=rsa-sha256;
	cv=none;
	b=eUq8gmJBezmGsgJ5IwGN0eg/uh/0zvCS4ni2SRyXbHUWwap4upvUY/+HXw6LXmXXtHWo02
	2gwIgV9Y5OjJII6/mPjnoPgEdToQv8qoT3TYSM3s2nrxJjmDUrIzzIAARqHak73PyAqCmE
	KsHcAGhf/jVZQ5LkQX0F3WPF78LHDfA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="KHqctPU/";
	spf=pass (imf01.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496868; x=1791032868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=KHqctPU/0S0ywjmDpinZnpdDd5aokeNyJmLCW/NhkwDNR3gRu5IJ1uBO
   mj6M7+3Vy1SaGuQI7gDY7eXpdU9/yvvv7mnXEP99jQRhaAS759u99DKbx
   0yc0huzRQPEqewo7LICPEVhbosfhaanWBV5x7o9hGiPloc+XoNS1aGBIE
   ofIUKojEASe+NBgf0O3nsHzNd/HehOvNCruNbHJuEzmar7OU6DF6WC4Sm
   wtssj0sRifGwNiisbgWWT/OtvUkw+ysq11aauJ4MteyT0NvzWfpNue/80
   82wxcuPD+gVEVqmITkyD492uq3e84RVaH4gyoPo/VkXAj4NpSPUxB0hRp
   g==;
X-CSE-ConnectionGUID: j2KneathSbauBupdJYhCfA==
X-CSE-MsgGUID: 0jF8e5dCR6yagTvdn80FSQ==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3069526"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:07:46 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:6014]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.16:2525] with esmtp (Farcaster)
 id 0bf3fdec-d42a-4f13-8ca7-5582c1c63715; Fri, 3 Oct 2025 13:07:46 +0000 (UTC)
X-Farcaster-Flow-ID: 0bf3fdec-d42a-4f13-8ca7-5582c1c63715
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:07:40 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:07:13 +0000
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
Subject: [PATCH v2 15/19 5.15.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Fri, 3 Oct 2025 13:00:02 +0000
Message-ID: <20251003130006.41681-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 0147140018
X-Stat-Signature: f83zbirsgnfxz95bpsw8s4r6rorgihp6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759496867-323188
X-HE-Meta: U2FsdGVkX18v+zmOWdjLucjS8eSqYV9QCRkS/70tS1tQCdmnKRXXX4x6GcrGdrTQc2DVGGX8CoO38u1KSYNRhoYLxiQOfr+TwtQU3RlaIUHBb4HLzxVulElaV2IoY9NOGNZhWcNBusPO5UHF9Pt8bKQ1LSfaUQW6p+RIJWZNHeNGFTs3j6pqjyuXtpLpURJFofM5z8nO2opm/pQjVpsGXl/T4nYUshVjkO68Yk7UhhQB7MOUi/xuNgv/606dFEI44XRT7Z3zRi7a01z7562N32A9GsiykvOxTYsNkddXXKt2n/hQVDrEBtfDm1E11V/cKH3ZgYttQWeAlv925/m934SK8A0xzYSP9YEf8a7CJaor8L0ET3MJPVfvUSr/mUTwWS7SAx6yTpbwisdFwyYKvzjJs/0PG9USmTX8AoZqKroUB8NEakbYqbMvHJqi7ylIVK6MpkCHJ6givmd5Vxa2dQBk4Rz3zvRTagtU87zsH9pS5p9Guojm7YwkhORD/Qw6NVZCRrLzkzxnT9BQVgsBBP40VMkjU3D9ElBo3uDL/PQF31bFJ8fTtfrtivQ7pfg+VDO4jPztFpHjN2tyfjnKKwd9JjCJ5/h3V4ZcBuL2UYH0sbM04n5vQJgUuPmmnzFqIKkcu15VIA7r/xz/WMww0xtBN97CD6r5hxBi5Lr6f4YpLDpcHlpkLUWJpmr3Pkk+YIRHRuZ6TClXvVSp6zoAc0sOfNAqIxKCY4eGSqLhDhjra+PVQld1wk6oBmC/gdSPLIsSHAPeudzVWKd/jeOax3A//mwkwVU9sB8LyTxMSAJXI16vm68ur9y2kIxGh3p4nzpMYRaq4prc6xpCXXXoLo61bWEoVaiQ3iLTrRo8dAggX/N57IEdY71qvJIRpMM8tEZGfAHSYpW846DJRUiVFJbKUknTPaeqi1+y0XukEM7nVxOvuAjf0DLYZqH2pi+4kNWRvalXD9bFuhzeCcx
 6wZspZ2B
 kt5ZzPU4JwijWW+nd0pXqefXHlQCl4ijjfQ1RGJg3L/BDOJC92dNXb2u2trl5vv6nlJOUC8GDA/0kgflGp3GmaVR+ltcD8+BoqDACYxoEU+Jov9lg4TLvrxORSpjO367sCFAdP11JlJn8UJguPMQHZniyraOwxudj+WN4HsswnNewlQc1SwkXKr1WcpV6ESEnSBAX+GWygEVdt0u8lU50Y+GQWkDr/N9uBhixNpcwxqEKDG38DSu9nZs7bY9V3j1frGBlRypaBULq1zSLfFprhtEz4Xdcmhnze0PsX9mVtd8RQZqqntkOstrE4lCZ+fnkrhBLyVjJJV+cgcESpRi8SHiFLf/t263gIMigp6Ono0HbeaE8u7Jl1yXTV5ZTcSu+AQF8A+wT3AaQKc2A2TXbENwlUGGhAoNnBPa4Uikjak08mw+at9JAWCBkMxp0FkgjFuWv34x3OOFm0mAyrrTfE7PNMnv44qjvtP2pThTxh7iyD3rnXsOAQu3FYvQu898SeCEYv97a+9c+G+e2/44JbfkykIe2G2K4HTeiy6iay2V1v7IyyonlGujFyeN8l+kCrNmWRIPllHn0lDDGsnN+uQzI6If8avpHGDJulPMaWKLE0szm9L4vIvfSBhKzsjzvPAowWeVrH4wd7iE61dqb91Hs50frGqsNsvXKIt9sOnniDEVXAN3UQewd/OoiPRCpwMu51zfBhhm6VS4AqVscr2daN3unI/QZh171rMqr+dennJZ1PbzZzqUWccKm2JVK1MuKRiyiDl07S0zkq1uZttmJzuUjZscIZDsn/543HTYUKZEKruPflvNpSJoXxEi2OCjI+8zDjpGz288DuIPzm4WGJ/8Z4kSRq6OQlgfg0WgjHxybE8Uz0bdgijTZlKjEnqNSs50SzDrDuYJFAj/IZioBNkglK1BMK6tI5cdxaSPyQpm5jXvqMz0Wuv/zhDBC20DwrC01AEb1UOu8lojo4bEE1YYj
 nILbHru6
 TMBL9HyZqD+nLBKOe2lTfPUq6yEeSFUcJG8tE7lXtKI645nmnojuFbMP0zq7F4N3gngyq6cuqYVjjU1oRW2LxK1Jk9/DVdb+0D/AKrk1xUpYbUW27Mk1fljk5Z67GSDfDl8zCegBDR+vKRYwtwrzAnmwy9n0LzhZvif5sk1pSL07uRuYrlqE3clzq+Jnmr830/IRdtczOXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
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
index 24e4b372649a..6f7ea669d305 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
-- 
2.47.3


