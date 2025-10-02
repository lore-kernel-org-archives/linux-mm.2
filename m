Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CDACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C037C8E0010; Thu,  2 Oct 2025 16:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB42D8E0001; Thu,  2 Oct 2025 16:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B8B8E0010; Thu,  2 Oct 2025 16:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 922F58E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:50:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FFCD13B90E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:50:13 +0000 (UTC)
X-FDA: 83954366706.23.E76FAA6
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12D221C000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:50:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tYY8txHm;
	spf=pass (imf18.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
	b=2MbJypezF41bCKLi0gOLH4L054v9Bk/CETTnM1gK/XIwWlSZxu3AP8h2vUcEI8AVQDv+9X
	5uDDFYzv3yZzSWYXvb+fd0+lmaiA1HKWpvyEtjRroBn8tVrG1wGLrhXLggWYZCRLfsyp3j
	emGe9nE5Y0wUc828cGvrmDoexvRjA9I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tYY8txHm;
	spf=pass (imf18.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438211; a=rsa-sha256;
	cv=none;
	b=gZ/l3P2HBqofHg97PSnNL7qm2dCWO/HrnXvWh2KJYBEQ1sgnbphzez+e+xS+/M9NMVIrin
	tm8uC62ecEUbh3aLa8sS2ReKLNezlO+AuGBNZQXb4smm6lQ/rzGSvPYGF7F0V/a2OBsT12
	hFiergsJwcWrCW9Pvv+WdcXKm0xp/Yc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438211; x=1790974211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
  b=tYY8txHm3ym1t9TQp6mLXvfpbM72h5ldmBLP5KxtznKvarrqeaVAryOS
   YnroD1j+Q6G/ShN3Qu0gv2IYioE06hnpQ5EiLkwpf4rhJ6JsAzON5hgIK
   zPZcKM9sRusQNDjhBkpbWSkXITF7qS6ASEwjXDnwsrX+q27U/9qwYhfgX
   pfP5W9WxvTG/+cF+DBRtYvjzrwhgwJ6v94DkhnUVNK5EZ+azavfAPtTFq
   D66N0S1l4OCy+J1e30B8iX3kVNyc0aS0LQ9YwiSXfTWzK+fZ+fkbfQxbw
   kyDE5BG70hBwF8KiyeAZ410p1CoI/jb2evcoM/mi1NVMC96dZVz7hkNfQ
   g==;
X-CSE-ConnectionGUID: utlCpslsQsGOylyVYCd5AQ==
X-CSE-MsgGUID: aB51SxZXRUu7bS1JkwJF5A==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2929237"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:50:01 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:7396]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.52:2525] with esmtp (Farcaster)
 id c3bf194d-31fd-4dcf-beaf-1d9e157b04ba; Thu, 2 Oct 2025 20:50:00 +0000 (UTC)
X-Farcaster-Flow-ID: c3bf194d-31fd-4dcf-beaf-1d9e157b04ba
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:50:00 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:49:35 +0000
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
Subject: [PATCH 04/19 5.15.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Thu, 2 Oct 2025 20:47:18 +0000
Message-ID: <20251002204733.35652-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 12D221C000D
X-Rspamd-Server: rspam05
X-Stat-Signature: mpjor5wdwiaamq7zz13f6ujhqcxqhoks
X-Rspam-User: 
X-HE-Tag: 1759438210-49287
X-HE-Meta: U2FsdGVkX1/raF7JB4V7sVEyItNcN3NNSCQEsMONbr+Z9SvBjuCZ+UkD+qnSCU38MK+XCUb759hB1DBa8n7zzh6uGv549jS1lLVasDeubdBWhlVjMtfyvLqSkzKcO7u4kPJG4haRrC4DZcuxh5BI6KzTaXTc09bUPsSVaWsHJg5eG87/zbPHafckW7XNKcE/mnk3sKNE7+omUPstIUo/Y6dQt/BQsvDdE+rBrydI+htTyJxG10WaB9EF2NF+HyLon9w0WG1SuT4EGaN/JisHDJP1wj16EVLUwbeu1OtCicMy+rbfuHSN8G96lrqxX5rd0MyRNhonjn+2ykVIjVokgs7dhq4UpmpLtrNxB0tnuCYPuBg1Zw7g7os56xbl+EnNDVMlnm7hCVIW/l8KHcA2DJLzkD0vlqsJ4TAasDvpku3nK+sKLN/Z2D+jzMgw+4zLNiRzQRs9UcA7rCHq7Tj3tc7GeuKFdsjXxSPwtzsEkgsr8qA39dK8ekM6Jb9RIwirngplyLMmTsIYQuid4K0tDc+TdzIKTvdrkIYawXnNcIx1cNRpCyML2MauvwrL4RkjjUPdvYQUWxBolRkQBaJI5ptX3yxwvnC6Ywc5gLtA/QiBDEVoVxnidVvRwaY95cIm4LXXSXzIwu9fhOho19GT8Z6PrLJtk71x+NShHuV2VavVp/i4yvMkrx9fTHMSYxAmkHtvSxHAtlgwPPCIV1p1zybmUI9zpnHpt4ce07lIOg/18f//65G5x4NnOK1PArd1lPM+Gpx/6zdPvL2V3RdL8wGrqKasV5DenBojctmwAX0Jf9YJ6RD+jrfGJTuTwcjMDK5FeyN/92uo7MOWO4M45e7K/RcamwoNFTrySggDTgqC4eNXoVTvpdqWtjRnknqhcntHi8qWfkgiuBFoYRfUxI+YOAp6EAQVFVpojJRm0xqO3/0K50CtTu35ShYxe4oeBBVSpft+Fnp8z2xCvno
 GwhEm3WW
 x5OB5LBYOiaJmkJdcwA0eUgCahWhT59wliNcJz0/urSdTBlYuaUfKIW0eFJZgipcNgaG8gj35uGlCWJwmEODDfsCOh9ANrK9+lwgZKimeB9Dy2CYyvMvDHGaqo8uWwjDiktGyZCCSZIHPwJPy9mqSR0NoNUS7XVrfCkheVrejwC0/TnMlEWjzvp23tOvbBfLDPWwa19rNu8xCDOc3FHwfNiEAqPl+6JXCjJX4M9Ucb6kxEkwTxWTWc4poxLZzTBvStneppp7hC4njF3EX27/fKerF3CZaft1yq8ORpHq5rOvS2vApUQ29/A9tzRNZBjHIKPUzWL81yE0nYkz57Xr7uOS8SplZskCHWk9RG4m9OPZXBm+vwRON4F7sDMwepUPIg5+mB98CZlnz2zxfr9bVq8/A9ZGH1yVDRwSv2T1pyAf3cxUAy8wlTm9zSO/tKk32M9AOKh3mbI0EIDaNC8clf5sJVPCJYXC90osa/HscRRxtT2akWETfq3nIR/a/HdlUxcPt//P/gUkMmz4TE9VgkRLQbdfN0bOYfOZlUPaSOBiE/Ysc9UQ4rXXEGcsvoBW0Itf5SF2lVCaszumK0W2S02IhkqO1mSkQGnDxardmebEDBbic+qg4EqhOaa/ESI/09IpvSS32UjgoKjdRIJxTcULIGm/2980ZmvHk+8UFYpx7AlISyt8u8fxlk89f8UdNgy2BU5gUONPe9opbAcCMMwco21+0NFXLeOIgrHF2xaHdWdJadB0SNJjifwhqRpvXNJt7W80okwPSS6qFg5yT5kRO5021lqVP7V2jsXGelkI9NRwEoTH4LybAxs7Igh8gyJSKkIJ8NOgwCJMiZi/iMP1XbDM3Pli0PGQmA/TaUhYwA2yioKwbZo38h5lWWUTW0Kbr2Kc/dyWU9DeaTU9S/cTuPxXmfUI55UMorVa6KMWPkI4mOp0f3jXb2ueMMGGSnjuSLMwwmH1Ai5JcELygDaec6Xh5
 Ul9E0N+4
 8aCpmHitslDtIr+kcA7xzBxb+B45y68YYM2J02pL/GNlYkSQ2TXOshVopRRxuXjI4VtXXSSI6tM15jyLYc84EMtxPiKiRuogT9ch72DBht+jJ1I+NYdx46nljyWhDFlk
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


