Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F82ECAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5E18E0012; Mon, 22 Sep 2025 06:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DDE8E0001; Mon, 22 Sep 2025 06:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3978E0012; Mon, 22 Sep 2025 06:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A77B58E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:36:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72C1A1DF972
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:36:46 +0000 (UTC)
X-FDA: 83916532812.17.64659E2
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF926C0002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:36:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jVYrM4LH;
	spf=pass (imf22.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuDLxbukezbKvm9K9qJc6kdbP/O3m0CMIC8okLoytJg=;
	b=hLvSi8D3VXXfCCqJDnuB6mcCkTmK6GBPvWtD8ZRaB+PVM4knwMouDZnH3mhVlOWyFYfbd1
	t7at8ZFDK3uWTlnjElbM504xlttaPw6HPt85eUJ8ac6UeU2YaDhxxQpc4V9PnevP846VxS
	iHBwdzCjCj5ObfHNIldKPrNHWynO/yc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jVYrM4LH;
	spf=pass (imf22.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537404; a=rsa-sha256;
	cv=none;
	b=JB4PKLuIIxHmZYLpt6o8bTMTi6wtibgLfNj7j2FQN6fU+FoWIIqXN5V7mk/YOmb5HKlj9y
	B70h9m86m1O1Zw+W3P53VQVUkzd2Mfm4whMUOCnWUnhP95BDvgH35sF2GF3gFCk1tnar4R
	RUaDRou+q6CVHM71IRUNH4756EqFuIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537404; x=1790073404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tuDLxbukezbKvm9K9qJc6kdbP/O3m0CMIC8okLoytJg=;
  b=jVYrM4LHOhNag+V7nech3SuC7SzZ9mr4N/YWkV4dsL6V51NNVlpQERBY
   K40OwmBo6KSIb4ke/6pAp84AykNpXfWm0jjt77fWVw1J9j8vQmKHTOh2v
   PCG1pYCEv6sV21o6W7atzixh/m71grr3wpfHFUpzGMSEZ3O1dnaPSgxXP
   YNfjwAjT0WNHdjtNDa9w1LqAydmaH61FVCLNm5Xg2UU+FVCHdCLcoQGPl
   +1SRTpzMk+oJDdw7584vZnc24BLpxOo/PzMxBo8YrkRdSfgoQxZFZ+wg+
   BVX+XKOWOMfEs9H5cvpoJvhYGGStg5voscGQdnp0qjjlXWQ+9VB034X2j
   g==;
X-CSE-ConnectionGUID: CLU/dw09TKuhwh39bzmFeQ==
X-CSE-MsgGUID: DaH/F5TjTKqq8WUxpTT0rw==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2363918"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:36:38 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:13404]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.68:2525] with esmtp (Farcaster)
 id 2f3b1f74-d60a-4374-af80-eb8e63d2b393; Mon, 22 Sep 2025 10:36:38 +0000 (UTC)
X-Farcaster-Flow-ID: 2f3b1f74-d60a-4374-af80-eb8e63d2b393
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:36:30 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:36:04 +0000
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
Subject: [PATCH 07/15 6.6.y] minmax: improve macro expansion and type checking
Date: Mon, 22 Sep 2025 10:32:33 +0000
Message-ID: <20250922103241.16213-8-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: bdqxj7hw8s5yduasu8gkygzwggjci9nk
X-Rspam-User: 
X-Rspamd-Queue-Id: CF926C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758537400-928601
X-HE-Meta: U2FsdGVkX1/U91ie6QhMljb5+VnjTjZdSs37dGt1I1xXUraFs85lpQfFyQg16K+uGcWafPhaIuBIqTAHHGE9fksdACzBo8HcmgY7lYuN6qT1v1Sw4VHYpz9tmQFLlNOHI1gBYs6ig2TuvLnuE2+zADOD77XA3FUSqJeL80wq3vfAlwHHImMn5P3AogWmgYgiPoHQCJkf6MsqRqWI8/Iy8cXAaXtybkv7k3FYrFRaOOixOC29SCY3StpCS/r6b1Bcua2yDkZ3cwuD9w/YOpiUE3dUxgMF715+1BxAb7mY1MCcrlEK5BBFcdPGs9AmcUBKv/J7zxbCEtZ+F59GT3ZZWUZpzWbm2akMDoxC+jKeZx3TL3BOwy09N90cdgasChvEhL2F+aoRTMGZzEZgnArgf7vnPRctcEfki3oJFMb8X0eFZiQCYcCvMZEp8CCzfiPTI0gbQ7U9D57CSxkYkDE0RkLCxXIriOrY2+pkb3KQYxJTSWIVrzBjCTtRfGduPBecqdJ36gVsw4euHeJPIPAnTCa4EDETT0JNjBC9LLumhumSP2I27u5tnh4A/CjXjwy5bDiWYe67d9rimvyvyzz4t8ecJbaXyGts6kI9+0Omg21XQMFqzH/EXUd/MH4CDeMMCKGMhG673E9aqDXTgD2ATqMez5GMZjr3SSeymWXZyr4xaOIAPYTn+RHkJCzbjgqilRLDZIA50XO5ycgwDKGucHHFogjHr0wpIlhw4xfmnb60qESU3WWC1oJRheuFKaZmU4Y+YgrvQJtlKAmmu4vF/vztuCuwE5C56YgMaGXH+M6rXT398S0AghiLQdh/NJaCvvJrkvLD7/QwLgRrpFntHQPP7T0GvUM9jzmZd2AOP4xV6DMqR7xXfA7U3kMup0rpKtYxiNurIVUHrCxa7FVuZIfKrUiZFwObrs9osqcf5DvoKyE+PfkJFSCtAqlrMT4p5jzXY6tMPoYwLsWN53n
 7O1WaQPs
 JX4TcnoNN5npeJbozt24USdt+lQJwIfqcP29WrK2PYqs3NoQh0byAJ+3G4g2ipVUDq1KBdk9m8u0Oj1mzfHXZjD114Qp9KoZgPTUyTkB8l7n0hLfQAVtAnZNUrg2b90H40nNlpt5n5xYZwRjkAOHWCWds5mJzw9ppnS9m2k7rOYXUYLYRGgOoIZWKzL/HwhoKX9TGCwRLRfFXX/4J3xrvpTM11zEWL7X2ZPZSsmOHA2f4ZDUrjJbqpXgDJcSSBiTUVewwpJDHgYWZWF5i33w2uzUomsU4kGLNPcvkvzYDqmn2S7L0cucxf+tnbYZaYzJDuGBNDC56EZRxfSolUz/3nWBaJsAqoZSHPO1abwbFb/TllEobMdkyrkWThA+HY7mq5KooUpCewRWLlWPYTHit6VXzjOzmf2m57DxkBd9S4kkKt4jRbRa+ihqJRMyePTjjL15uuM4udhMbY9+M3V24IHz2YA3Rxh9zmWpSDhI2muBMOpg+vB9XA5AoJI6Ujo/iDdApaNsIug6KXExVu6P5zYZIF7gGd9MINdOKa8J8rmKOvAl/9tS8+XTCVUf4s6z4PgfNEBnT/MtkHnaw6vFf5uiTrwVBkgHIYGJulkqvkzcYxLSJSezDxnJvTZe33AafWMkP+G0EJ5pxQ+v/W1MiZZOUqdSB6BZM1cHqJhCEMHU381eIBuZGP6uXaUNKiQ8U2sCC7O74F2LSfPmvs9Dxc98lPp+SdDSkvIXER3K62LDCsX4CHO9MWbswDaB94s2glrdsKrtu4eoIxdIOdILvRruIX6vAhJU7+ojHfopGLb0j8xgIHr5EzBmwdtWVMHa8z3aiVMo1xYfyjvd4K86aJnF86fVgJbTb0D+ycUfuesdKL5qJYZes/rX7XVmZPXScZ7ogJKHdlPiLXZ8=
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
index e84ed3a43f1f..1d4f23ea3105 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -244,6 +244,15 @@ static inline void *offset_to_ptr(const int *off)
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 #define is_unsigned_type(type) (!is_signed_type(type))
 
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


