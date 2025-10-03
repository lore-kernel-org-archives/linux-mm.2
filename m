Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31915CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0448E0011; Fri,  3 Oct 2025 09:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FAD8E000E; Fri,  3 Oct 2025 09:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767BE8E0011; Fri,  3 Oct 2025 09:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55DA18E000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:05:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1766911ADED
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:36 +0000 (UTC)
X-FDA: 83956824672.20.1D7D64A
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id C58E2140017
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=R2Wq9s6z;
	spf=pass (imf26.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=dVfMJO4CCl/5sMzjZelw03llKA8hvRUzsO1zKDULSEQOczxCWFRTghd6HnhoWNLLlE0M1F
	B5/Z1T70XBU2AjdxAOz7efy+yjpM0+HXh8h8mcpd/7dqnBf+xd7wdatIOwg7eMi0G+cGii
	QM6BBGuPwjdutKa13sDvQ+Zpg0fHqbE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=R2Wq9s6z;
	spf=pass (imf26.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496734; a=rsa-sha256;
	cv=none;
	b=FrgPvE0cM/FHLB7ZcnRNY9l97fPwwp4sWD4OQqgm9WWjfz/9uK+BPR/Ta3ttUqqdhJp+cc
	t8tqPh2XqCs/c7SY3cj/1OFaz6UDJ9O+4frdo0CmmAo7YVhK8HZ9n9Vpv8WurcyghuAp55
	VRk34z3h7kEiTRnaUQOhJuB/sh6iGL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496733; x=1791032733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=R2Wq9s6zWAH5/8/SayNFXXuopBnf04jONcyeRYBcreuv8TZ2xmM82Die
   yShQK1iJquJUX8zjurLxvgQOLSFg+3l4J1dJUYwoxu3vyYto0ia7cwMwf
   C8DQgu/U4H833EWg6w1YzaqO8J8Yx7+maYEBrcgvtU6hkRpVR3U+fEtMn
   8kxr2AoeYoFUu098OpjpogoIJfRnBHpZy5ciL8uP+sAokBq61ReRrz+Ng
   3lrE57+VYFc6RzvElOQwtYTIJO1MmCzUsOUDZrIt5M2wYvg1aRmvrDIbd
   Q6NkCW3jdPRZIOnMDBzCH+J8Jy9WEZXaAsjVSnrbDJWJjEHTEHavmOIrm
   Q==;
X-CSE-ConnectionGUID: 7dECYYD/SOmF4vlFMcqreg==
X-CSE-MsgGUID: W8dBbgL7S4Oa3B6A8g8h5A==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="2954290"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:05:23 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:11996]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.52:2525] with esmtp (Farcaster)
 id ecfd0dbb-2715-46b5-a53d-b6c09400b0a4; Fri, 3 Oct 2025 13:05:22 +0000 (UTC)
X-Farcaster-Flow-ID: ecfd0dbb-2715-46b5-a53d-b6c09400b0a4
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:05:17 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:04:51 +0000
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
Subject: [PATCH v2 10/19 5.15.y] minmax: simplify min()/max()/clamp() implementation
Date: Fri, 3 Oct 2025 12:59:57 +0000
Message-ID: <20251003130006.41681-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: ts7uzzz9o8q9oor1hwpnizmetuurhmnz
X-Rspam-User: 
X-Rspamd-Queue-Id: C58E2140017
X-Rspamd-Server: rspam04
X-HE-Tag: 1759496733-965279
X-HE-Meta: U2FsdGVkX19r94W9VXNPvsVFiQ86Zu9pSMBhREQP7sMyOVut7kXqv97C12arXuNnGJzQkAo8+ie46wpPMpeFwfX+z+fD7szHNLytCslSp6JYYhcWHpvvW5CLJ2OXxJU0+1duOkAGtmskqt5oXFz9HNJsJ+RnYR/zPZMpe7Aa/tHlk2JrolahH8okZPESqzzDz+TPqc7WSVnGusm/j2j3gtE1FqBBtmXNyC20v5cq6EQfBnhJmlnl94hx/Nlt1wbRhk2q3j09xfE6hIWGVI1tVZL2i4U77dAqOiWieRCEcCu5r4NZhR5yx6zZXDhY/+h/URl3irOPys8UmEY+pbASQNBPFbbqb2cbIC9Ln7gNxuqAgwiPzquusIhTonVdCLIAcQzY0qbSr3ejA0qMdDomHFxx0pepnTwYeZzxTRaz9opEA1TP2oshwJHBmNRfRDVbud91uCaw92WqaX+QjZhv7+utkYSsiEqB/9eUSVxmiWOd5x008PDDwaRim8jGeVMqcDL6AFFJKH/Yjkt02xK+UewFinIzYNlQogLIoooLYn3IrVmNRzi7++DGmCtTxOuie6esagUJ44V2H0u8LiOOg5cIduEKPbaH3k4NoV4XjHFmUU6UpnWcCL+1go8mjsVbfw+2Izs0QIM1WC+iibbjJgg4KZQxiPZUL5ohfJJCXMMBuzc0z+oKXQc0PKkVlei119v7mBxq3VxM3mW0UEmxiCgVye2RpN8mHvCyf0H5a2naCOqpQ8LAqDmz1Foz87v2NatiC+gxr1PTDgDA3wK/z+DZsOLf3Fou4z3Vzk0+sEkeGpBH+VCD9dxdBgCz6hk4CunLP7vvbsL5vE5I0tfJbI5FjD+aN6qmNkoB5YJAFzf6d2Ho7AJFq4IP/okK5uWxY7YbzHCe57sme54Q4iJNa08zsmEzeV9NEElOFhn+lBF/MHG4GBHnda8fjJOizUF9jlfhbIP46XHYSnNY5oG
 fjUb+8wB
 Xhn4fHJtF2KrN8yes9iZGqe+m+1q2PSzVzlnzNhDo8wtHXzH8t6meD7adSRc7qOZ2TP+NRcVSANa8WEEItLsPikoUcFFGpgU3B1o3rPAv7zI5RqdASDaUBEtEAN5JY0huWWzupZDwlJCVzmZYECGYJPyVhwezAdiZIKYS3zvh/FlHeWhWKBoR4XPCRv+q62jeRaMm2xVR7otsH/mahy8c3Ffi0tjm4FlZ1Z3QuyImlOaGuixvKnm99RsiRH61IHlmbPAXvVnt6PFvzWjsB4Ltq211xZl8aoNzxz6SZSh/9VyJ+Bk3wgmkfdmMZ9gLOqHguviCCCOEe5wWJOoT0ugl6wKaHseZnQc1b8VfNeytDU227/UsQZ924whsExfOPIsmSNS1AECZ90lcGSU8DImU4EuO/VVb+EkIsrEHEg6tvR5u6QnPcN82zXE6XGDWShhS6GYryeblPZWb5OkJYYDlVVkyP8/rXIqNtWtWObcnNl0sJGB0RBUsxsPqCNzScZU6Zos5BN4x1PpCeV0fes8B96EBPE6/71T1ffghYyZpuVNMc/Q0TJYd1BoOP3ahQW6jVY0XWYJPOqFEETZak6vJNQeEbe2/HHcq8Tc2u0jBkdDXPk/9GQTqyFn+Oi8a/25hYitSWXNGqg15M5sDmCxtY2epGUVhE5Y1/O5c6w13oLsgwIpbppj48UACELYMfUZz8wYC70CMRGgHVXOXOvjfz7AAxwOIQdzhbu8+w5jglOq0OO+PQsXQ9/upGizhi+s7VD0uoRR6xN4GlfoED6Eb8txLx/lT8QFhrmG1hqZnsm+T9G+k+80RymLNTCy4G1BAbRZGm8pVSo5V1fNkiMv8cjGj8sgD0g+nFodtFZOTBX7Axf6hgoAwocSHTOE+SyvZ5dg16HoSA/0PLIbOp1iGwQ+bC0hAUgWob+Tj
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


