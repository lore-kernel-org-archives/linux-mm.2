Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC46BCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B488E0015; Mon, 22 Sep 2025 06:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242D38E0001; Mon, 22 Sep 2025 06:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1319F8E0015; Mon, 22 Sep 2025 06:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0027E8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:39:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0FBB11A806
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:39:03 +0000 (UTC)
X-FDA: 83916538566.02.6052EF1
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58EA7A0006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:39:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=U1aE4YgG;
	spf=pass (imf15.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=mMQeE+O6fbaQvNzwoeGXWoooLto7vKXUlE+KpowmGHukQ+HpSgEdIs9QttMAT+plo8s/F3
	oMrYZYQpYu8oldoLPQT4inA58xTCWeJtA1lVlszQH99aGcvO39dWdZaFQb5eq69Wsxjrak
	0t7tFMDdkqESlVBIML55LWZPLg/Q7Ec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537541; a=rsa-sha256;
	cv=none;
	b=3fW+76bE2dPQBZDim7J+m5bt0YeKVNg4MUfAGppKVBdYY3XprkwAWZFzWEZ6nS5HBgz9Sw
	ZrGabeIIGCmKj+rzWCUE8Sf6WBsfkNJqNdvrXLwQzknqE1a2rlIqKRNCDGLVcUFiH0iJdd
	DZEAN+l1Li/gCoXsOlDN2GE8/zOyvNk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=U1aE4YgG;
	spf=pass (imf15.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537541; x=1790073541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=U1aE4YgGtWb/CuW/LwxG9CFH71fxl9GJRomX81LHCORaUxhp5SyYvBZK
   BRdYAcLGuf7bOM/KQBGDToaTE+fl4aCeKQRXrVsJuCQxQhUiEgoUs7BLU
   trkaFU2YVbm2+An/nU+TXBWkZV4SP1Lqk42vCPRrvCHhz6Be1vssMZDoc
   JjeLhc8yNa7IRDm5DoW7/H3797Ct2/yjUmKoH2TH5nFOuouXPbfmoJUiC
   LDkwBv9CK5SstJdbcQ3UrZsi0c2Z6oAdwCcTz7rPHz0xejUgsDbhhbwP2
   b0sPLe3De98Da/nUrV61mRsnFXcmY3A5NAzVl+2ERhKBf+32VVMnkNbTL
   Q==;
X-CSE-ConnectionGUID: U+0QhBQLQF2wVxeXkCCcrQ==
X-CSE-MsgGUID: NI31RTy3T8ac2Pq6hMYlBw==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2372264"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:38:59 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:23789]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.238:2525] with esmtp (Farcaster)
 id 691c1a69-1add-48ff-bcbf-344b86b25a0e; Mon, 22 Sep 2025 10:38:59 +0000 (UTC)
X-Farcaster-Flow-ID: 691c1a69-1add-48ff-bcbf-344b86b25a0e
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:38:51 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:38:24 +0000
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
Subject: [PATCH 11/15 6.6.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Mon, 22 Sep 2025 10:32:37 +0000
Message-ID: <20250922103241.16213-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: mtgw8azuz1gc9pbxeeb9n6449sajy6ef
X-Rspam-User: 
X-Rspamd-Queue-Id: 58EA7A0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758537541-768926
X-HE-Meta: U2FsdGVkX18ELHny3/EsCF8YS/Xqzc1c+fJaSdJpJADK7J91AOw4pTZvIe8GDFx3ph9hg25+c2OrUZqyytkdTbffFJAv2JDg3KfBfTvP3YGf922c/onuaRqhJ7J3/Rghunct3MU7iGWEzRKDB9k4AIw+QHMpYEPUsOoG56KHgnvJ1+gIVdBvpSj6FFlOmZgACzHaXP9EKXEZOWnspNg3xmlhwU73oFl//l/S7w5R0ULbSjOSPbo/dOjyOy8bUr87t1kUNU7gJGO5oRnmsnLskPEnjIt+K2pNGP57B1n9LFDPDkvSnTHkM8ztuU6RCvO+fs/HZrmoPucI9zuFsI5a1ZbpRsg+IYaGWwV+p3hLstwHzLzE+PuwgzgU5JjtKtsn4ffqHBn3W9qUle655OTEZg//SALJltQ8MvSBKVOtIbVSjyueno42HnjLu0fC7zKB4Q8VXuRtBiM55JUJWaY76jp3nVxdynXsSRTW2GwQLuvJ2fH2puQMyiR30N3Etw3Ole0Y1Vpy4vyOcDLhexk0VwT8qteRstXlwRxotG9VlnzYCdKZSxPaiy3IoUgW4KxvARIm2+2GwI1GpYSxGTt+qTZ8sOOoRcGWE+l1K0lPS/IlAwjdISTW0Cu8MEbWL98SsAAM4wsPfr3oHbX4vSJ4sK7SC3OlDf/lx3UczJhfwjB9xcCXUYG63lKFJINzpCZfeTHwrLdMhpGoqwte2si7iFLNG0EpesMcpV/HTFev9opmdtvjRneNvYNVFpwQdjCLuD2Xogpm1n0wEt25nr85cwshhLG4K2AmlmOeRKWTu2jAuYpA/mHLGbsIAJbCqxzp78HpRjBQ6lgaRMiIxBvQciuHWOuX+i1uVHIqwtMSGe7T1cp0jKjEhYHwJkGMk5aYVP3pUdWjyYKkkFQqgtcIM3LFLzEE1oKWuImpiWs53qdOck49blPtsQSQ6hKSU3DWpayMlE4NBaDPe4OnGBy
 C4SzBd08
 v4NIOgbQcQh7emJoY6tJoqD1CKtF/fZFogaX2+1iUuCNd8nksituSFivzDONhmSL9nXPvGmt1CNPS2xsoMpc9teaRvuJmgUd4hjTyM8/6cgwyYkGQLNZvhBqMzZODQW7oLsQOZtvYZKaN+r6i/jY7sSLIPdI4plSSS8/BxC36NF+Y+SXvP2pVwXXPRdkUzjeGKqhsH1OhN9KLc1SkNLncb82TSqJbBv54rkaylga867QFrazFnCiQRWIUPpxqaVXVeyYAJbBURQsXQEXy4XDtwSdqBJ+zumpKwZNYAv1Gw2ff/e2rT00vepyVe3j4TcaLAQGwdS7hlKZnezwjmRlRsJ/PsATQ3o73ml4DIfHRXIK64cheKq+4LYMh6ltfhh2TyqkAjEmjoQVvLWLLt61EsWl4d4pem0pJkljca4m85EmB/ncoOQ2qp7sGnmgftADdbgsOyl9PbaJrdypu8T1CGB5kgN0OfdsAB9pySCsjfLLymw9DaGj2vXHKb9+1ebFSsRR7ryImmycnkReTFcLI53XRPImg10CnfC3T+Bzk9pBz2Pjae8AbJ3ohYlVqSGuo9PW3FCePn90OYbYpo/AgjUJD3sSxPHB1htqHIRBa7sCZizAJ9XlFgTuFejC1a//aU8yom3tFVog9i1mYkEAub8cxe2xh6A8+3e05zNOwMZab6rP6iOXvohE9p6dsnTJyMHoT+y83tqq24GRkT2YRa0PPBIkuJRAATPllbmk1WKcYu5+hgiNEDtfBDUn59KMsOqj1y4Ytn9djZ3zcsvilNd8xeQ/jpn6X3aB+mbRaXUR9DaeE7EX1YEkp2gdN83kGxaNrEz0630GPltEUk8FuqYna8cn9fLLxZ+30WTVR1n25pPNpKZwu7FmLmVUEbWn5sirOTp1R2rHP7ZMnS3RBDbv9E0/X+seCwrr1N8CRR4ihLNROpWultiYuU2u8A5P9J/TAQ5OGTKI+OJsa5WoAYVbBCp1Z
 bma9DXFq
 QnkPbmT2AStF2jKon1Svt1U0ymwZNCvm9UI2516wQLThkXNL8OASTmZWBCBV9fdjGHIAKk4G5n/cz9PD+PhTHQsvXaAH4n28nhBHh5BFslBxtiYBAeXJMHFlUmagdikeLk1CShntJF8ekye8AGMKX/mYQ99JDRDGnMyVTG3wXDx7G+MypZl7gPiytGWeswUMvugAzsmwEH6kKPJjYTJ50UGWU1FG1IRZ3vw2MCj61SFSd7RulRzFzdjy1SOE91E0Zsk3sJ0sSmtdqLKNFhULc2PD9/ZhE/NoQ+VXgI58lJquKKLDE8drYMWb7mxRNnsgZtMpiQvLi6U1E+kmF8Pt6A==
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


