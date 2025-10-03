Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 577DBCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D498E000B; Fri,  3 Oct 2025 09:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD6B8E0003; Fri,  3 Oct 2025 09:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3A78E000B; Fri,  3 Oct 2025 09:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8056E8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:02:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46E92877C1
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:02:45 +0000 (UTC)
X-FDA: 83956817490.24.7CE56E0
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id F35C84000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:02:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oxFeBSNl;
	spf=pass (imf04.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
	b=HMVHh0v3LzSowm0+cx6ds4x6m7WPXs/criwewfd4O6Gjm0Ba6O/hxAgLdlB7DpG7SB6mPk
	NqEinNfg52bWFEVIPk6IK/eZbcsRtZy9XVfabB7f5+3L0F3FE8IQcTZFXWIYIQUdBCntRS
	JYG/EeQ5l/dK2GvsZtWWUvOU/nLa6Fw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496563; a=rsa-sha256;
	cv=none;
	b=K4DVoCG/nZciniI29ms5TWqihtrBtCMEDPs4y5TCgGbIqCwIlFixYThECbZqcS1rYmGC2y
	ayBZdAzx0MxpBZfiyMR4EZowlnLdy9C1d13PQauVxN2borekCmC1EdBki+4zyqVhzBeyrk
	29UYd+2P/6JFy5TFlV7amG2zPSFQKXw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oxFeBSNl;
	spf=pass (imf04.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496563; x=1791032563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
  b=oxFeBSNls7cpsCfpCmM24EP1M2vK0BdXN9bSZkSdlD6kYuqtTH0IZ4dl
   JShREuqHvJAFdsOrBbKqovH/HdmEB1J8lTpYNKnCqqJKRu4hwnmb16HlD
   0EuBMIC9GaZkNuJ7iesagaAqQTSsMXbncpXhEFK1J5fHhLtXOWzSMLfLO
   D8NItJJ/jjWxZZejImVg6SpVN6NPR726nxcMzC6h32aVn+o8KiTYoruDJ
   vF5YDMGS81Dbx3h4HP0LCphgIQgTF6FQHMgworgOFJJ3kojXwsNtjwjnl
   /W3CBIZFsiS8ASKeVJ0jp6krk/3f92oyySuc3e9DTkL3eK7/xj1bUwMlc
   w==;
X-CSE-ConnectionGUID: 41ClxvC8S8aAD1BJSu4SsQ==
X-CSE-MsgGUID: LhM5pSuERA2b/lFqNkQAPQ==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3069152"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:02:32 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:5043]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.15:2525] with esmtp (Farcaster)
 id 9688e442-2cfa-4aa0-b6aa-8d3525798e44; Fri, 3 Oct 2025 13:02:32 +0000 (UTC)
X-Farcaster-Flow-ID: 9688e442-2cfa-4aa0-b6aa-8d3525798e44
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:02:31 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:02:06 +0000
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
Subject: [PATCH v2 04/19 5.15.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Fri, 3 Oct 2025 12:59:51 +0000
Message-ID: <20251003130006.41681-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: F35C84000E
X-Stat-Signature: qc6duj1gzie4c3mmdaezzokz8z7xu416
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759496562-359807
X-HE-Meta: U2FsdGVkX1+6zkhCwk8uapv2vxc5R2L4Uo+E1pdBCeycSrgKsfF5iQr6hSftMZWp/+v7RMtggIRJl7OsvznSTnWRIuTYrUXOBkKJ54SZPaC95hKE3J5WnLluXI5I+VdoCImrA1xNQHhtJQ9yrZxmj0dTiN8kDgvM2aFD0M1zH646yvdag52Sg3M4/HBuLbJ04WycnP4WL/VK4y/VIqonpf3/UwXW+7rJhPj3jh9kHWketQziClXaoHSBYxMzCSgbvKFTxWlBjBFN/A5byVdUUojwf0+bmF+tGs1xlRK/6T4sMlwhk/uK56pHkEq0g76HDw98imXDW79gkVxQs7uGIo5Wt6w/A2S/elmAYCZzailn/XEEYjQjPurRpknCkd8AF+4et0wQX3B72wGVQcwnIzQ6jw3FrHyTS5VD/EeFF8LQ0fv6gb1agQEC7lCD23DaNbzdcUUAs1O7NLC57eQnd/S96OpIuDyc7jSDVLvEm/4CYHik86B4WxjlYTHEEtUpfQx7AK85O+7L5YxfqNW5sCNNH5uX79kz9LOTa341PVAgI24khBGElGwXsnzmXxHGD4eEOE3BOzhygcbc1B1qf8guFlJlRfjk1Q9ao0zlk4ilUYX/inOMakMgz4d+0LGPVJOQHCM0jXSsMhIkTzJdiDlo27e2vqadrPiisulHw1z8vYuHWzlpZMqpBbeGizZ5wezBZWh0drpDfkeHdMTh9IJF7EOwQJbsErmsgUq1m00i3DXkeQF7PSEkTlE/kxysOPpb1WleEoW+Kw/UGImak36AlpzRbrjPk4iYApFh847vjDForZ0MJUbsI7hPdcPfgPL/TZAwcnbxuhlxNQK86XeuyUo6adxvOBntXq3udxk2uk4r6aVeROpBKwQvqPJnOM4AS3RAUS2Pa2cgxjTHyagXZglhbQH54eppQidKP1Z3wzBAWbrZiPS9LcHWOGwUBCmEplTSq+cRJcLeiaA
 og5QfNtn
 dvLsFiymJV7UiVfwaAitY/KIsrccWEKW/TJ3PDRkEfjZHewoLGL+rqSHOgvhEDpMlSD08HySMANPk7THbPjMQDGd5Bw91q7bSXnAWGhFQwfxxoCrPUlmW5J8fDEY4vpCpge3biwcCin2Zxj+4A2W3D0eqhdsSDyxbD+8MrcVp4M3AOJjzEQagJolBzQLG1MKl9NWfvJSYYicweMwY3fC0qljYBFP6ZlmVJYyZeDfLiFseO95bPHL2vK4U1KXnrc6fCL/dNdu3diB6mFK8gnlulXeN5dvXAGY5YSCtFgUNiwjjvUiKmAzIU+B+kHGT6WK6uaHNcZjPUj9lTL3GOHWB0Pb8PlFFrAzUMUmym0dElAm31Kf54hDDGylldEtP+L5NwSuUnA2UxdIso9dI6mOdPn1oTyY6QAmVBA/sQNd26kejZZkI2NuyJaTAqX9cD4kDB7/vL/F2L3X3ujLg+e1cOGesYs5QNz7emTCr9mYOSpR0ZxzhF+d/QRp/4pY3Hildyrsjuqd5N9b3CEpcnhIywKyeF5ckdqzXDpzH0Pe/MCWD6+sKeLGTnbSExy3JQS4C8z8j0VbowFU7DZtDWAxuPkxi6g==
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


