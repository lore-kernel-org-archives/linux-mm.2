Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0D5CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175A28E0012; Fri,  3 Oct 2025 09:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126208E000E; Fri,  3 Oct 2025 09:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F300F8E0012; Fri,  3 Oct 2025 09:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC2348E000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:05:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CEEA140803
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:48 +0000 (UTC)
X-FDA: 83956825176.30.C41CDE3
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1C271C000D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Xa2kvYc5;
	spf=pass (imf18.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
	b=u96OdPV+JzLDZuYAvEiBeoD5/6XV01mMDKhdYlAbeWYD3jWUHbzJDB4ST+s+ZTjGwd2UAg
	zUEcfD7yJKYV0mUCtXe2/6BJBBRZ7r6l1R8O6z1GT43I+nQxliFOgnIkuf8FtG2Cn9hI9l
	b/V3UzMaDt394nEgtTtDXYs8OZ/Msuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496746; a=rsa-sha256;
	cv=none;
	b=rG/ng/0XCDruKv5l9LtpC6WGzjmANgrI4itH/SRT8yCCUFmRWPlYvsbO4p6/wBdIrzOw6P
	NcCPuzW4w3DoAnXCTEmrbyFIjd8Ior4H7+bG1mOAn9db0UNLrM3kKkAQYJxoP6NyQGNCIM
	QOwk4CquQC3B8PPstkmx09aYTtZ5QAA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Xa2kvYc5;
	spf=pass (imf18.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496746; x=1791032746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
  b=Xa2kvYc5HZrlI60WQSmY0ihu+85zKDzmVlfwaq6YGaX0FRA8T7WSOa2O
   qiHl1r76EoMtK6NZhDTq6tOhpaIPlukLf8sogrRoDj0VJnfCCBhK465+r
   aDHoU4/ZrOy9NEApL3K88U1rwffJPLsSXX8Iz9rlbmAmPfhrwNkA1ObSl
   CcsV/8L+V28wI42fSGEBgiGzHmWrZ+JnzkFawBSr1SJi07feXRsBKF1So
   MxYqgnC/qvFHE2Q+He1wccjzH5VsddM82q1GpLANKvj8hnvZAH7BnzAmG
   ocaOBViCl3sEa4SVXuwBqPkH/pxh+CbIs1d3Qk8YeJJs9SGqkwh7J/jSC
   Q==;
X-CSE-ConnectionGUID: q9hX2INbRai8iizRYjoy5g==
X-CSE-MsgGUID: gH0zXrj3RR6UykESXRuy2g==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3066632"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:05:44 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:11118]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.147:2525] with esmtp (Farcaster)
 id 4646b2df-6880-40f8-9990-9e5046ca457f; Fri, 3 Oct 2025 13:05:44 +0000 (UTC)
X-Farcaster-Flow-ID: 4646b2df-6880-40f8-9990-9e5046ca457f
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:05:42 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:05:17 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann
	<arnd@kernel.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 11/19 5.15.y] minmax: improve macro expansion and type checking
Date: Fri, 3 Oct 2025 12:59:58 +0000
Message-ID: <20251003130006.41681-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1C271C000D
X-Stat-Signature: nrcrh9et8idw3bqym8u7k5c37x8wwhxk
X-Rspam-User: 
X-HE-Tag: 1759496745-828599
X-HE-Meta: U2FsdGVkX1/SX/BZ6fg4t+RqwfbwCnnSTOmmw8TOi816xe54YFYsy1gHM9jN0/X5kVp06YmDtkwEd8oZL1RgBp1ln3chgqQRcGnmZME922SNRb8hKe+r0Bi3hn6u3xMryAnZrBIbcNrPPIvklFH6u5vQ8jj7RjBz0gEwhcVYoYw19Dr77T1FAU+5GikK8nZ80x9AzGhx7cDr/irYzV2Vmx5RipZcYrNvbijFjeoVCETcAH/1a3M+vgYcIdvAdRd9KPp4+8ip57BJ6WU79QEpNy/TPztZ6Mm3yfK9pKlus/U2cgUXPj2zzOuWU3VtYqXfPutUWN+5nig6pTSZctzM8dceI61Ol0BmlvozIW+2bfz2/xS8RanZqXnHUJh3q0SUObtSJonx+PTwXnOmOU7vonzsadArEEY/DyOyHru86pwvSup2TU7D3KpV4Q0Tat9syC90znFRxN843raPHnNPGMl5Gp3dolDOfm4sYTyBdAS82DPcCIFi7ZV/S7ylvVSDNz8CJROh7QBbhcRjP/a+eZtTTE0iHwEgY1ck959b2idC9cBSDsrBDe7IiWeVUt4EWin5/uKxxfjRZvEAG/5Vda3iOUZiLW8hDZXzT2uKUbngoCcqix0Ssh4bEIjdvf+N1f60cjCFffPKjYNNILC6y7JCUQ6Fh/29dECoxGcYGUQ8UpUh+ZBkwKsiLIGb0wMwWrklsbZUZ0/7uZ3Y61c7B3hEzH04tctZs3VE3ddXJUDVpyL/WD5TsZzNgpnRYfbg2jlRRYqK8V07RijfylhRPMdEo0xx+gb42MR81oVSc6NkewNurNPL7uEnNeMvF4yW4it5HSqMcRe9eX9Ogk1KWqSW0CS470H76qHvDUB/qSXDrrG4ZsHj067cmEwjdn/wr402rHUTs5LnIqe8w43b09KXFtiBZALwvonUV/VdBh+Krp13FFUetSkRZwta1qbBBbvm+Op1sBdSD7ge+hA
 2Kx2zF+U
 Irsl5k8JHnz/6ZhaV0ISRmTyQmIPse7DXSMJlJjY0Y7b5ZgInrJzY+MuqMIfcL4KqsE6dpGFbtau8pUjgbuPTg7C1D4vv02cO9r0lo62PtsG4rdLpcU9PHQp90dAzDDomw0lcClO9jFTwETmcNI6PkYCNtrCfSbtEMvVGvebI8efby6evdHHdo9AI3ucacPBt3c6cITMEXCVxVo/CWYOXDx0J3tRoxC3s3wN/saEIheaI/XGxpe3yH2Tpw0i/0Fjv++18WpF9eAFaIG6xkA6DLYuVXEX1KCXD5RtCNHm4dPEOi96bgMj1SwNhPXbKxEoa19cUp7AtR+8qrQC2j8sAiizXHQPuYc6fFpiB6OvEFhZJ6JPFMskHTnnCWeO4UYs/gAOBQKNcT44uZo5N5WKSO0SvnT7tI83C/QOcf74oOJnIGwOFz/L3RZ50JPpsNpYJo2swS/WRkDwd0CY1EaliCjRDZEdRDInY6E7LOFtNFjENvIxgeP2ekDqrKAU9gz1gmuXEgoIyEXUZ2YOVhQIlgrzupCSD6hhYW/E45E4YAcXzjlMgRnp8dYAiwFCY6Jo5OIHEb+TCSOP2D62jq78+k4QF2HpQL/m9nVrnpN66I4XJwAl5X/+TVgKUoefcNon7zWCUgsCP+owmQsCMicnFqo8BuOZhST+0PuZkLM5yd0U9gl+pd8DCEfvxB1jh49CFnfEje3HrmlGe0p0O3ZEdXi3cK8mcVNfETYP6NAsliDUz4OUtyXzx98eW0ZcnTxvdgYxpivUKL5m45qvg/nd3Jnoh8ZtMFQu1KuLk13yn5B1V9fTy85D3KYyBzFJxQDND5ynLeNMi0yj+CTL44WbS9BxJbtXMdu6X1BMGmIjw6qeVJaIrQxP+A0XHfKxOu64OvE8C+nQeIKyfYHk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/compiler.h |  9 +++++
 include/linux/minmax.h   | 74 ++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4f03dfb6de0d..ee9e39d315c8 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -258,6 +258,15 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
+/*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index e3e4353df983..41da6f85a407 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
 
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
 
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \
-- 
2.47.3


