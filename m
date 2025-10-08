Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECE3CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D318E003D; Wed,  8 Oct 2025 11:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B743B8E0002; Wed,  8 Oct 2025 11:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A408E003D; Wed,  8 Oct 2025 11:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 979288E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:35:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 524A659D19
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:29 +0000 (UTC)
X-FDA: 83975346378.06.5B06939
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE06D40016
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=inp7CWPN;
	spf=pass (imf12.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=rogs0b++dd57HtH+sGbDQgOAOQ2abfGs31WiggQ8uX6NV29eZbXTYCZM+xMnJCfL6Ulo5L
	wQnL0Ksmelxe8On752MAQZKIkuIbykAFKeG2YefHUftClouZ5VfPvMXIH8P8yDzkl7w5p8
	U2DOfk5Q0wSNp850YlJ7cbmOkuZWb50=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=inp7CWPN;
	spf=pass (imf12.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937727; a=rsa-sha256;
	cv=none;
	b=5xZOd2UxoXexXWSm40aLh1w5aM8MI9srDJkXa4Y4Z7fBq8+qCxnhQc8ddEXXibCIvqh5R4
	OOmK5ZDkDIgUz2hR3dHFILrJgdITkQl1nFpObpGQy6wofDLB3towDX9Wc3DrQs2uiGqSE6
	+8DaFvst1p50pmm9obbc/OPGTK1Ix1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937727; x=1791473727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=inp7CWPNCBCqRTAJgurde4F0wVF9qIBjI28xlXI2D9cSix86vr92cq0N
   McwiDlmrVCMCErMzVNsj/hHFZ/IJ922N5snybC3q32j5gwY7w8EpHmaN8
   vk5vScOfeB/w9hLt0U12nqHSUKRKBYfJ+DaTIK986S1YlVvnqp8QKm2QY
   fnWxCzZ/jqc2kFj5JFjJuTZKeQUfbgkhFarbian7N0o7fmeiMIqtRUPBP
   wwKY9BuSOtmlgUaww2Mkcg3cNDaThKHw4M4VhEwd8BMMiMsKpJmeJ7epQ
   fydd9AwSt6aefn39CtSsU7O6wZ84Zs0dp4OI1zeeurXZVdjO6gpquzPrp
   w==;
X-CSE-ConnectionGUID: SknRxCoqTs2OX7xPwS0oMg==
X-CSE-MsgGUID: Q5771awZTnia2cYxyNdfQg==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4530181"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:35:24 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.21.151:58588]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.156:2525] with esmtp (Farcaster)
 id f105d5f9-c66e-4916-9152-98efcd88d873; Wed, 8 Oct 2025 15:35:24 +0000 (UTC)
X-Farcaster-Flow-ID: f105d5f9-c66e-4916-9152-98efcd88d873
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:35:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:35:07 +0000
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
Subject: [PATCH v3 18/19 5.15.y] minmax.h: simplify the variants of clamp()
Date: Wed, 8 Oct 2025 15:29:43 +0000
Message-ID: <20251008152946.29285-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: w9cgph6b8wssehht54cwgyx3rgmaxb4e
X-Rspamd-Queue-Id: EE06D40016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759937726-767647
X-HE-Meta: U2FsdGVkX1/KAjohMeNHFoHd3wdKOx/bxodqXI5seaqiKm9PuOCUdGV9gLGGkBOJpO/+x2j5qKcIoknjek7MWpXtFEGyhKREFnIlDtVtjysvR2Ek9ccGCnGOGdYkZLs8UBiUJ24GnD5/pGZmgFiKS6zSAOUPJTd/swaq0lAUDao5E0w/NeYmVVYO6h39U12yfB6FFAuhVnZqxduaXtaOpExkU0W/iI77xasOJ1wdGBIMhNemcHGonkTstgHoXJPX4Vt7NF25jFeLWJU0gEpPgrkh96v6SptBmIz5z0bfYR2OOZFOEK3EegHJyFppMQYQPNWSyDFs7wZtx4U9XFHX13a6FgagAnuVmsrtZ6IrSrHX9AVFUSAWKlFGTBa9ky+DISVr+RYOv6QnjI/92bcdm0z2DHuD5ksM0iGfqSAcr4N4akeRgm/BSrN2lOfJ00uAhGKNkOIYJdS5ONYITVoQGETXRPrxhu1QJl4PJ4GbJIPPdbYI6op4jmm3BYxS2gXvyxpdnx9pCTdvWvD24HvIf8B9vlUm2trqahWomnnk7AsqMLcWc8Cla1/K6cKLVf0ZVm/j2fbHelbN49o+F8QMUoQlwyqI9ceDxNEDkwYuyX8vMRRsFaQC/oRuCRl0Yf5P6miqsL+QC/C0XXHyTL7Hp/ItYnFhNe/isSpCHDXv737CxTlJ0B9yPbENozS32VpF7U8DorSHdfObTlY5esTZZyTmWL7sogb2wWhM84Ol6U4NSOpLHcW9H0Gd7yZaDA0RWzuFKNZ2LUT2OC0yJNYfjJd4wCOaRenAifOrI7fZt91vo4uKSXNYkrhxit/8r0Ih2SzZPdVRXZ2srMU/6Orj74/BMhYeVbX2zVJQakcTj9V1hYnUcmTZEliG5oaBLOG6q+SZVg4kFPHDpzGLCEBv6cg2EHh5A8qMwlw+F+nE/h3WdI1P4ORonVjthRnscr7FbKwaKu3CcMOecSgr7LW
 5vbxvebj
 jlL7gGqTZLwGWQvBPIfl4C373I+9kTgN/PeATwtz95rbhUKt6LTHM99fa8t6tV9AsxqPFPbFPeXlZCAf5W+ApYbpxAQIG/FSakd2vwTMWq6SJS5QPh3m2Q85mglgjv0ekWpYN2ijmjmd7vu5QIefMHMlm+eigbsn8vG+W82lgpfExBFKvMNPIPGoH34WflgRYVzP+PnGjxo/nMWzFZXutkive2pYoAtMa4yyPfyqScge29gQ9rxVOcGr2/1H1ANHpkFhQ+iEKEPWb/BwK9k1/tBMHmF3DUjPFJP2czSHEupC1o4Y/odULYyS9iuBbtECqtt4Z8YdScJDyeYutB16c95BOWRf1XyooHI8blSFNMlQnuMa7bcjULFdwDU98JLrSlVt9i2Bllcpe70Q5eARkmtHkqvfPX7hm1ccT4LdhxtrbGycN1uDNzhzc6mj0eXapAecLYgnIOyWzbFJVq8lDb7Ug2eWP4bHv1RS6yyun7gLE2KrGNGUbjQhEqspg3kEaA9p9hes4+OXXUIGa8xfHX4yu+59T/Ba43Rk13tHI/DE/Ar7it5waK4Dt4NXSWXzNjMiOvEzoLDTy/9sfMO7XnZKsBiH55sn6byJL7jNIOYkVifKWOKfHVw9qD72y3b6Q9xKNZdEIV0gB7yk2a8gOVD8GQHpKYL3xjl8h4uG2qtjm5mmYDbLLpDARlVahIh3MfqU0QuzCiNfXD2/AObwou8GISB8KdV4FD5J6R6s3lw85M07z6xqAokHmzm1AyJ49hf2lgjA6c4y2yIxUc19RlYZD6YtpjUEV2/kMdrfNFZZxIYcDA5wESFrfXlNmh45YPz0bZXdG2FayubLhDwftUFbWDRkbGYAiuXF0XNPqBoOylP7/vAlRYdCTeMXZRQH6gcRH8fbBi0Q0FJpYB0JqpMtphWXAAu3G81NjeNFIGLn8vvDCu+hWzSb7b0AYeujJTpzlbnzkZ26b5CggZW65XghjxALQ
 FAsyxxoL
 K+5ozl4dzurJMekcZ3U+24Q4Juk16AAfTaPueCBOCN/2nEcmIwuhk3+YK+ipUCEP0Q0LfK76QhxSUODAtamn0x0Qj7LkyyWA4UaiYjt5ieTcKz/eQc+bnV1Pamc00UTxtVoZ/v3cg78Is3vtU4Utsg2rn7oy9NK/M3UeN2LX2m98s+jv5R9NOEDqIq3Ju26JjeOSdRc8yJdmGZ7z1E0Bn1Dtb0y0kPMfA3zWDIS+Jpjta2dzZj9I5xC/AmW1r4Gk3VnDFWoNZyE=
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


