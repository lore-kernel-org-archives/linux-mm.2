Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E68CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30BF48E0019; Mon, 22 Sep 2025 06:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCAF8E0001; Mon, 22 Sep 2025 06:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2BA8E0019; Mon, 22 Sep 2025 06:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1728E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:41:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8D7559ADE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:41:10 +0000 (UTC)
X-FDA: 83916543900.07.49C1123
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EE328000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:41:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UaJOHXp9;
	spf=pass (imf30.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=rrlC2avZGodw+hDyz+3UyqmK/FX/P8RM9Rw7K0AtSJyxR320vRaHrUMtWKUggfacwUq2zx
	d8AykbXDNjcZ8Kf0RjrQH/AALaJ0iwfoE9dtu8LA8ax6Ev4qcsJZVaVSdSgaBrzvA0q/Ov
	QDg5C96bzb+/zADLp6SkOcFhdJwOpfk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UaJOHXp9;
	spf=pass (imf30.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537668; a=rsa-sha256;
	cv=none;
	b=aA0P8Aa4SS103PC8tOkhJqoXO7YB3JhUVUV0ubDy/ww2qMRy0zkKtO6V6bHcCSA4C+FAq4
	Xa/+nPu99+OG5qy51Q2yvUB8c9yTs/sfKR3G6ZH4Stnp8xhomFriTMNaEFe/Q5GOhkwyM1
	5drbC4heNvz0G7a5BHD49z3QOHMpg8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537668; x=1790073668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=UaJOHXp9GcV11cG+I5FsQa8dH7gxyHwf2RUjMKgeZ9FwBhQ2cBr8gQ0u
   2+rxSdLpsYtHqmJhaZJdDpJAczOProZ3VF0Wx1o+1SSkAjoB97NXzfQ7a
   PU5ZtRHyU6crmYGrjofmCiwlaESOtBxZXF7eBe1p2j5yptMZDcdPWYt/P
   PPUl9xWQpjkKF+b0qgsQiVjq2pZCc4ynh1rO8rn2GWZYJEtoz7pEtGhuC
   zN9TTC27AVlOEuCIEJLFK7GJ/XM/yUZgVCbdw1CGCuUXjAVvY1NT2d/b8
   Px1yQnaYm8BY+eqYl7l99UTrQU4o+9S2HHsoKmk47Y9OS+HJ5k0Eom9HH
   w==;
X-CSE-ConnectionGUID: nGdSMg2KRJqwFKGugNMByw==
X-CSE-MsgGUID: 1oNLGvSNSbarq0bxcHDlmw==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2372418"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:41:07 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:9689]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 549405e1-3e62-41e8-bf89-796f0cf76dce; Mon, 22 Sep 2025 10:41:06 +0000 (UTC)
X-Farcaster-Flow-ID: 549405e1-3e62-41e8-bf89-796f0cf76dce
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:41:01 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:40:34 +0000
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
Subject: [PATCH 15/15 6.6.y] minmax.h: remove some #defines that are only expanded once
Date: Mon, 22 Sep 2025 10:32:41 +0000
Message-ID: <20250922103241.16213-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EE328000A
X-Stat-Signature: h4dgf44eu588umrbbuzpri8pd5haomgx
X-HE-Tag: 1758537668-506991
X-HE-Meta: U2FsdGVkX18is9jiINb3twrdEygJn/qujM57Um+aTtpcnWkpxOk3I9gDpS985NWcl3lvvvjNv+Dc8va0SsNXF9N7cYWLpJzztW2WK+c6inDH3a4J1qR+BWPdF2ceTtxaOM20jpzkAaGhAgJm66v4Y50oKQoloD5fHR0bAvNRosxJZG+r4kTEiAT2iFKenqfNbxjMp9aieEXROqjJTXIhTVLGLTu886e6ZvNUQ1zZGmPmQP6H5VWpNCbDIHbZVuUayIB82/U6RBpGZZ80jKL8ZuwJaDKmjzM3jPpavwTnjdTkxlMZFffvI2I+sYcV72kMVr8JZ6KdJmZg0YIWk3iZEt3O/YIKlDp1WZikgVp56rGJzbqAYPSptA7DxjIDayr65m67hgfOAc1mSrMstOcCnJzpiV/+DmeV95ODEqoil7iTVUq1gWh8VM3YlJoc83gGZ6Rv2UR9gctUbUmi11MN1IuRxaKfo3dEPHY/978HAAByvjcjL2nYc5fzVxXv8hvTbp9OMmeTsY7PZ8OS2SWgzkf0lhyLsQqBeXC7RytEItSPtzjRKRxlLbgyIx0ZUoMiEJkh0FpVV1ivH3TOn88L2Psd0lDL6WsEQqKdmhPDL0bxsfceOLswBFjcatV7fhlFqa3Y63w6Fj/UjofDjDiv1GFyxP1bfKbetgJiZoBOTshsQMt2h7YOfAkJKuLL9WGG4A0bh2vKQDPGovRV8ldyiO/SaWxS8TI/dV391eiYyRYGkAXnm5lbMyVVEOny6RgQIH5Qsaa6EG09zFT/40y8w0V3YJwciQdoTOpi5B/HxKZa2ufu+h9KvGoAghGBq+wYq2LEB9MbGOlLlZI1qeDQM2eYsc0P3lFSZA1pUXZxplegMzPBB/MXCCKyQgxeOPqcOaJ0JYlFRQ9MIuaivL4PeSPs3ONHttTNA5Im/ZC0ZxSj+Ah9gqAA2vnAGmXkwTUTp7eLTD0Lqld2YtVIS17
 fInKCAB6
 QI5Q6XbZ/eFMqfUDbC7uPDVDETEJOyhLxxAv6d/pLOy1/lDHIU+cTJB/cCJIl0rKMuuIBOCGm9uqK5142fWDfd2F8Zd/zTK6HItUEKPNloWy4Bq5Bl6UK8aU0mHdtAb7uQrUO+gzrwJYIn+7F1F5QLx/407nqOZkBnHoEX5qyBhdfEE2+lo0CLJ4EuAWq25aAf1/E4hPdtgF13OKRbpcenv9bVUJz3aZ1E/tqGTfIpx8GukWRy8muYiOC5chxwBzWkiAMSsxxTVMyduMS9QBEsmnP97Qzf7xZg5qJS1PSDYdVf7KfiKMH0w2kqFl3N0i2Go5A7bgnHF++TgxeQwBJ8CdWRW4ankxd/C4EH27SHNDzrNkFOVrQqneu4eSbw9cNKJDsoPozBavzFZETRGCV06VHtILZMVycLFg/j6bFARwyqCbJYzEjTbL7qCEDvuzWcicBQnfMNvmw9qEt8wtMI2uwWgekwxJ9amFS0a55ixe2wEQrQi35cpJ42HBAEcHf92sLEzCA72uUJEfG/cvhuiJtjwgblDKf2YzCk1Di5hUrUz/EOAnxmHnduYEuVV2VPAheEiRtwdGapQeI3Sv88j2zlUAl5oOuyfjk/TFtEBwEPAXiQ5U/lCd/vI/rvc1HOHfZOWJvjEyJm+vzl84nyfhfH3F9TTVv3DScBz2PCJ1ConUnJyagSKOZyGakdMJWOnZ042eFrBBrPbHrSZmqBV20gb0Oj+ggdfU/K9FeFnx/yT2HxHtPa9y5jdIlKtuBORAI2HLHPeuJneysAqrDIEl98GcO+chPtwTh3nwy2zlQ2jWSrWFjtyQBnJiopvj5oGNVBfFKdiPwCbfWehshgl4mASF91C+MgGsjQ0D9czzFxf85yFgPRzhRWoy4ppYNJlU0wHWbd6rJoDV6jgBzNrLCNP5p5pIwQQOqKwhvrABC/Bg2IAeR0OTg03uqRO+cvo1nwfAe81416xHDCQdyL6e1X+A6
 dpddGRL8
 JNIBcQkxtizaPADvk2+jRxXlEnVMaB+MQQ+Og2odkoc1EWxRrRHL5jvrb8UosGg1/ZUSNvo5LtYJ7gQ7w0UNarjG+PoyZMqTGofrc5u0KeicIhjqpm07PrpS+D4h3shbCcNBrAgF+nDNhpEu1OY2yxtD1yWe384MEOBlJblSam9VGppJrRX2Ds/ty99Rnh1eV8qjUmZV0OdnN1E8VuChJ7FjGHls/xFCNqs1eEjRu6mMEphv5ZFfFpwkEvd27znGp1GGbOtGPyrDkZ9LFqrEUqGHvuXrDzj0YAaUQoVtOham9pKe6wPJTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
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
 include/linux/minmax.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2bbdd5b5e07e..eaaf5c008e4d 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
-- 
2.47.3


