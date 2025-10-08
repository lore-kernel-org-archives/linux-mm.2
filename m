Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E919CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA808E0034; Wed,  8 Oct 2025 11:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B178E0002; Wed,  8 Oct 2025 11:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42B28E0034; Wed,  8 Oct 2025 11:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEECF8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:32:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DCDE59CA9
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:45 +0000 (UTC)
X-FDA: 83975339490.20.2A2AA34
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 020C180010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WoqtXhuI;
	spf=pass (imf02.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937563; a=rsa-sha256;
	cv=none;
	b=XPiFCwIJ+ztK2k1w4li7uY1GCZrEwQWL9VPfXQCrvtPNhfugZUSlIcKYXhmPELWreJ2jAc
	qn2VI/3p031uvctRmORRExbQbgNe6Ih2zD4bV6wgTZS2tN21sZW7I+5CNrz+lN9egOylGV
	n4mgi/5w/jmhiqI69FQ+gwoMNSOtGiA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WoqtXhuI;
	spf=pass (imf02.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=v1BUBMvtykOX9pYS0P6pHrelbkJQcgPz1OFo8MpEk5o/LPq1VFvOTTe0WG1E5zjYx33xSu
	9IO8AUId586Yt3yxwAzpvbpWyeDQ0UTWRx8iO0xEqZdVgKsUHuDmKH123MYDayPsB4o140
	3DRQ4xODzEvW3NzJtCfvOPv8mj+RULo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937563; x=1791473563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=WoqtXhuIJ38I5+CL7ovPdH3kPnrQzFR1YZt1HbkXTIuK2Xi8V40HQoWG
   vaQqbrApm//DYatnNYLg3PS4X9uPSAFRw9UEl2mIO8h9DKKQ6ib2qxJDw
   SzeOuwLabEr1euKEg6VlWLcpgHFDxH6EJEkbXYRfPXy+BVYjV4fsWw6ns
   EefWKHY0kpLCKSwgS+b4gM4xzW7S6gPj99a9sudQPFNLIx9Rj88vxl8vg
   FBIjFm91kOBiHYOMKVyfwoqLKgIcS9O6MdLt5swq0u5CjJKWFGOQ3NUQP
   HOuGh8405b339pHMKvtRieo1WhVcACtX8Y7SukByM2itMnb2KQ8KHPx8A
   Q==;
X-CSE-ConnectionGUID: 1l1j8F8/R0O5YqH9bBt9dg==
X-CSE-MsgGUID: 9jhKXSElS+C4fdkMXST5jw==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4534017"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:32:40 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:29235]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.215:2525] with esmtp (Farcaster)
 id 598c4386-b8dd-4a9e-bdb3-5a41bd32dd6d; Wed, 8 Oct 2025 15:32:40 +0000 (UTC)
X-Farcaster-Flow-ID: 598c4386-b8dd-4a9e-bdb3-5a41bd32dd6d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:32:39 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:32:26 +0000
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
Subject: [PATCH v3 10/19 5.15.y] minmax: simplify min()/max()/clamp() implementation
Date: Wed, 8 Oct 2025 15:29:35 +0000
Message-ID: <20251008152946.29285-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: hw1jt7a61fnnhmqohws5rdtzy64ddfqy
X-Rspamd-Queue-Id: 020C180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1759937562-344635
X-HE-Meta: U2FsdGVkX1+OfkKMflK6OV8hi6xPox/OXQLwiet0iUT6PiBo5NafY58kCasD25vAYbinRkhs+EvUDq4grLInN9b91sO7md17Apm4eTbD2J5ZpISd4OfXiE673143tOwIw3TpBLgLaKXPqMK+3aGroJmNgTyXibIQcbsnwsh2R/wmaTVclZVQPSSOLjBh2HnXfwKVo1Yse+ASojhiLs7uZr3PKkhf1XfoaimDojaYQ49XoIx8Id6EdF1QpvJP8OzbjiaQTH124FQHqpzbccpXHnF3KYOi+z/fDplnaIOYKhSSw3n0DqnjVtQfOCVbS2xBcTn4MGRdofXF4x+W2IKUIOeRacVhwkWvd45AK/v+ba8f+zs/+eCa9YxvcbpMEhZpMhWWPfWXraln9P6yQN93IpzdjNvtEqymOpqlM41NEWUy0tYOYUJKqAsJzBMXh/K9zM4xHKla+ohouksO0V2y2nGTXT409gsZNOxVK7RlrpKOGFwtlfKoM9ZEiinBagp1y5MASvVtWFyhypLujqlwfRyABCNtra8AXrUz0y2CgsCqQl4Xa6ewi73AtP+H9MrPT8822jP1cbz40yBnm59fXHmDSUI3/ubGfMrdTD/iGSGmUQWFxtws54B7wHm4Tvb/mJP/xi63yRT2s/iKrWETxCwNBsedy49llucWSR4VLLH5JfBEDz2r7wLzwtsCl3OUuFyqTuHXRA1IB+zHEADybOOyah6X0Ovnw27laIXnMPkbb/yBJAjLEOfvtqfL9bhrfE5heeKBkdDkgD76tR/BkqNZxMBlNO7G0WRbq8fjiEriGpmctId04VzmQd+8QygewKY+BRtNHJnhLOC5sl7PaaEvy+984t9kGrMG5P51VM9aXwvceHwK6XqaqprvgVB3EnqrSUBBf3Xy/P57uLEBCjZEXbSq9MvfNXJP9LrdC1vfpa2dh2s7WDDnsYXGl8y7O2JxuJJznGRzbly+6BE
 oJK9nb0e
 0WJwpJMruibbxPjR4nuWCKTrbFPdiyk+CK4Jssb/Psvfkt91v0DbNMVAvo7H91IauKksgQ13amSG3G0IFT8hR3/sAn+axIvV6pOXYrZvVbH7asZ73DED1iUHFf8a/vzhgBz+xfpXKtXoiJgJ8iknwnoW3zb8+oBma33eD86K68CmXEcc/lmRnzHOr5N0OnDvClbnSv6pvFdhG3cyqu6aPhTO8NTyljgJJ5pnKp4KbNtWleFUORDyo/s64H8kqPDC4hAxyJnLnN6aEHSYRx691HV2zalqKAiAm8JAnR46xrdtazaZpjXHrpg+7R/jO1ohBkSKV4RKQYF2L9Egs93HQUOtSsVCyxwbg+SFNY1u1/2pqvtsX/EJeFJY6J4CC2mp1TNRSv3dybUnL3EE3Ci3japbIbrKWj1RyaWnJM2+GGoe+p2yygBRrsnE48lAqaND2UdNDhd1q/8ehnDUZXKPyGBxy7pemyVu3JOSDO9hgUjJ5UXR2FXqtRjjxeArULRUN1EuIrI1x1aRsBPWWhZosiwNZiiIjwuq7WyKKyEd2KZS+STzv8tWZi8/vVBU/KzYCxD71ylnzcQJIvW5g1zs8RWfCtHcmA6Yr8dksi8/o2VFovXylLb7131FUnd8FVFkOk5K/KaAXlJ7dwh/zXd7z45o79peEwfmMqj5yylnWEnlNskei7BDlqdmr66ikPyuXlSMQJFjq49nf1pQP4jsQ/moAje3P+JigIO5kphDNoY5hK7RsiDdlpxF2T+8ML9z3FJ+dyHO2q+oba5w7af95EVXBsWc0LR2RoVsG0birhe2P7pV9Zh9EGblfY1kcA2G9JdTCT/aY2dy9y8MOdLufmvT+5QhMsyBwOGFwGP4DQcjqyVW/2T3TP1XfYeofgOeZEau/
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


