Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758A0CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2168E0010; Mon, 22 Sep 2025 06:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89558E0001; Mon, 22 Sep 2025 06:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9FC28E0010; Mon, 22 Sep 2025 06:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 975928E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:35:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 674951605DE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:35:43 +0000 (UTC)
X-FDA: 83916530166.03.705CB55
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11BC7C000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:35:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="fjhyEl/k";
	spf=pass (imf10.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=K3YjZNIm/qlaTiRlpHInUz4u8yeg1fx5f/AfwtKeJJrJn9uVlNOFHvVDF6QIznQQiqWyHg
	xNLygRh0khLKKu56GUGb+g2FD1dtH6NFW3sVW4J2LddVnJCu2hNhT2lV8BoEUBKKW8hV6I
	q8RTbwrztVunBB4SiDQ7+73Gg1seD0I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="fjhyEl/k";
	spf=pass (imf10.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537341; a=rsa-sha256;
	cv=none;
	b=Z7uk6t7ZqGg5SgYGu9iefPcRQbn54WaZMIDqE+3s5Ud55cYsY4sz+SWR9UFEwnavi2nMF1
	4HL5WiKkBk+FBatkzwR9IwMnJIKS38hBTbcqLccr4WIlqtVWkmqhlQ22qN6tANOWYtln5f
	cQqDPuu5cfQqU2i6AoT1nvxSixGLVBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537341; x=1790073341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=fjhyEl/kWv8xQ6b1RL8fGHIWh3nxHUwgnKbzfCEm956xTb0bla7nBDMB
   /TGEEQQ1JhAojnJrMUhbYsqmNVyisgZpRvBwzp1tcP500JsapYPCp3iV3
   QDL9mtRjCyEE8KrQNr5VCdXh9cjRByGYkHKjYf5EBSl1k2C3veKRi0rsZ
   NrqnLD4RV3UoB27anNWyj3XZKQEyZq4MyEqAc7SzGRIjk/TTICf9XaGJx
   hQFnDYGAHewHg9kcmu3rVUSQOAwofNYYQJ6aWzj4rekhCa33aPBQx7y7i
   CH4psThfB1bk4C2GL4Owvp47CHMCnSvQ90R4ADN+wAF+bTbFcUmuWo4M2
   Q==;
X-CSE-ConnectionGUID: dc34Dpv1ST64k8pKCIcm6g==
X-CSE-MsgGUID: Y30gA8RjTCGlmKhbLkashg==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2371970"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:35:39 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:28986]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 8fbdb317-0ce5-4877-b268-6c650f776def; Mon, 22 Sep 2025 10:35:39 +0000 (UTC)
X-Farcaster-Flow-ID: 8fbdb317-0ce5-4877-b268-6c650f776def
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:35:38 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:35:13 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 05/15 6.6.y] minmax: simplify min()/max()/clamp() implementation
Date: Mon, 22 Sep 2025 10:32:31 +0000
Message-ID: <20250922103241.16213-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 11BC7C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 1ommjajyoa8f6bqhiyuqwngbhaxhmxx1
X-Rspam-User: 
X-HE-Tag: 1758537340-318635
X-HE-Meta: U2FsdGVkX18U+OJW5Ze9JrtqnMJp4Vx35MZWNx3hC1ztaeIeKwSRyPZraQFhx63np5A6lsBgbj86KSfsaE8GrkG3e4hpQPiKE1pF27AgnKanOT3MXssRazaT4kA/RECvlfNZ/YgmOW29JWMm9nz0UbDz2mG4aAqWyzm56oCM1g0nWQ7v/Nj0XaMTU8+1VMHRJ2ssnPMl8mdnye0GBt7ktawum/rX2PKp+pGvQIuiaPS38FCex2y1vBdKeMDRufBAnJpiytk/sf7xMhMMJWKsyVjyyWV/SJHOTQ8Q0D7tvRws5olFdMWLFtoHsDylqpYOihnMnrDB1nVuMIoVePJV/YPqjg7jDfPS6qKuJGs1l5Gq4oOSTtHwJKzg1c10NSu6affes73Hl6cU6nklreC410aQ4BRui421TGKq7HVDzYCwJI1hvDUMQxlDpZguEeq3MC+2ezdqAUKVm9ZHSTVKzJbf0HhE6DCbl8XUjZM4+wkd58ixnuGLBOlZc5G9r1YkYowp1uco8wdC15jWdaWpPq26QDWu32A7bu8oe1bQXfPYcidnGKMdq6aFrc3Uw62n3zIqDLmhC6qbjFoCNcpLnq3+xTLDzc3GPCt2wsZdd/XSQJSohbgZgzN2+31m7NPp+BBVzeolggCbU6A3P2xMZgzFsJ7AHhxL6/r0bkrPn9q4aZr70mCRAGJhHcHJEb15d2T51yMQmgmpOBXr175h9frTsd9Dx/oIj/OxDi4Zski+cscoPeINa/7qvw3OJw4ArvdOSqlPxS8Crr/LCSRZLaBpRm6VDZrsogjHRk1B7TAZ3P0fmKEl6jUNPuH83UenPrlQorvjfffngvG4mmcmSdyi1Vb/pHT1xBMwDm3GF6K1hAWt1KWu2sTz1SIHnRWyQ5jli92n500crZRI2xJO1cgQPkRHAQjs9r7l5imgMD3wuvmPVm0B96K0VVGw5x/MfispFhx5ynQ+YgYRYjO
 pU6kMWGo
 Y4jWWi+sG5qZ9hKGChRVl+UVAK6qGuFZYAjBzaEvoVRXgFUjF86kYoQOKDOsHIs1NAJBmgC33kbk4H6n0B2MyGFbBEGaCyPGZeuTbOMBj73Ol6fsJmVGC3Iv4TSkEcFWuWkZFyYzpN/Iyx2RYFCHc8tuSNqZ0zd3oJapZDf9avx5eK05DDHojIdeYvhe6K+8wjsRH0phmJBynC5yj76TQd9wx/MRx78ecPfuXcGRRQ05haHB0TBhtGUnD8yViPFXBrNFp/k9ouyV/IrLpfA0emnq1L3Sp55mGq3vfHVSyoBA9ZgQyc44FD8A7L23hs+YXKDfXCiWmMgqSCbIRIr+ndgWLVWjght8v1IrGDoykEu/81DONsQ2BZLTUlvx/1PApq9xl0hTwMLhoj6su9OPvBfCu2aJoss+Ih7MAOpW/BzF5dbln0ZnyODGv6CrPsE5UXVVba//XQ4XPCnWTYN00e9FUDrLfQ/9HvtunZDW1yvjhpRFAwJRbSHjmWgNuh3/W2i80jYbkA+NQQZgzNBds+bBTuQQ1oM079sAz/lp6XVUySy1SyP8HJ505gOLjqe7ZHJl1qsR+mur2oHCVK9tPTBqflvYaF5tZxrt+Jsac94/SXBwg4+1C//dnOrYrVxDOnWI/kjZrGit2U0LIpCiUiMVrpsDyCYvp3enicf7sPt2IgTNTKHP/lJUP1o9RDZJnR//qxKMSK6cPjMRsuXbP1aI2Cz0CN4lKQIyKBZHltYNB5L+YmJ6egvrHW8SgAyFpSoEJWV3w6DpVfGmqGWU3INisMhTZMRJS6ETZXx1MVXjJC1lE5kQoSS9Mzq8OV9TrLASclfCPn+Btu0asfXK/URaw4O2pfyZQQ2U2H5/9hlM6s+Mg7kw45GmxUj7I0DXTu/nS4slgY9MtXkT772NOHl9evIFd+8imW21PRRQesJTJKTaD8pvT94h/a+gsx/Wkihoj74t96tyD8T318oBYoZnaZASJ
 d3Gc2KBf
 Sth8TkyrhfAazg6CdfVQ92S7T71XyjnGsD14bS0v3Xluh6Qi+YOn/Sf7Sy951/Z3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dc1c8034e31b14a2e5e212104ec508aec44ce1b9 ]

Now that we no longer have any C constant expression contexts (ie array
size declarations or static initializers) that use min() or max(), we
can simpify the implementation by not having to worry about the result
staying as a C constant expression.

So now we can unconditionally just use temporary variables of the right
type, and get rid of the excessive expansion that used to come from the
use of

   __builtin_choose_expr(__is_constexpr(...), ..

to pick the specialized code for constant expressions.

Another expansion simplification is to pass the temporary variables (in
addition to the original expression) to our __types_ok() macro.  That
may superficially look like it complicates the macro, but when we only
want the type of the expression, expanding the temporary variable names
is much simpler and smaller than expanding the potentially complicated
original expression.

As a result, on my machine, doing a

  $ time make drivers/staging/media/atomisp/pci/isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.i

goes from

	real	0m16.621s
	user	0m15.360s
	sys	0m1.221s

to

	real	0m2.532s
	user	0m2.091s
	sys	0m0.452s

because the token expansion goes down dramatically.

In particular, the longest line expansion (which was line 71 of that
'ia_css_ynr.host.c' file) shrinks from 23,338kB (yes, 23MB for one
single line) to "just" 1,444kB (now "only" 1.4MB).

And yes, that line is still the line from hell, because it's doing
multiple levels of "min()/max()" expansion thanks to some of them being
hidden inside the uDIGIT_FITTING() macro.

Lorenzo has a nice cleanup patch that makes that driver use inline
functions instead of macros for sDIGIT_FITTING() and uDIGIT_FITTING(),
which will fix that line once and for all, but the 16-fold reduction in
this case does show why we need to simplify these helpers.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 43 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index fc384714da45..e3e4353df983 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,10 +35,10 @@
 #define __is_noneg_int(x)	\
 	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
 
-#define __types_ok(x, y) 					\
-	(__is_signed(x) == __is_signed(y) ||			\
-		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
-		__is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok(x, y, ux, uy) 				\
+	(__is_signed(ux) == __is_signed(uy) ||			\
+	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
+	 __is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -51,34 +51,31 @@
 #define __cmp_once(op, type, x, y) \
 	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __careful_cmp_once(op, x, y) ({			\
-	static_assert(__types_ok(x, y),			\
+#define __careful_cmp_once(op, x, y, ux, uy) ({		\
+	__auto_type ux = (x); __auto_type uy = (y);	\
+	static_assert(__types_ok(x, y, ux, uy),		\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp_once(op, __auto_type, x, y); })
+	__cmp(op, ux, uy); })
 
-#define __careful_cmp(op, x, y)					\
-	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y), __careful_cmp_once(op, x, y))
+#define __careful_cmp(op, x, y) \
+	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-	typeof(val) unique_val = (val);						\
-	typeof(lo) unique_lo = (lo);						\
-	typeof(hi) unique_hi = (hi);						\
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-	__clamp(unique_val, unique_lo, unique_hi); })
-
-#define __careful_clamp(val, lo, hi) ({					\
-	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-		__clamp(val, lo, hi),					\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
-			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
  * min - return minimum of two values of the same or compatible types
-- 
2.47.3


