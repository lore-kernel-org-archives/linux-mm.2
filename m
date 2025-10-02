Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9508CCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1C68E0017; Thu,  2 Oct 2025 16:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2148E0001; Thu,  2 Oct 2025 16:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90488E0017; Thu,  2 Oct 2025 16:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C41308E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:53:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 552F587B70
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:53:28 +0000 (UTC)
X-FDA: 83954374896.05.B32CD92
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id 127EE4000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:53:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Sv6JleMG;
	spf=pass (imf27.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
	b=JTDeva9EJTBjqMb9LXPrb8pJWNQL0VC+zGn/sNkXxuT2yzGtzTPyzPlfjW1YP/sZDGCREp
	euTaX+6zLmDPJY5T5TuGQNtGAMCOAiac6PgMP6CHwnnDJ3AXJWEOgbqcEQh8YQp4Db5SOI
	RKG8sf9M2SNO9OW+K22gAWOHyVJUaj0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Sv6JleMG;
	spf=pass (imf27.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438406; a=rsa-sha256;
	cv=none;
	b=Bdxj1yj6YpY4jcMJb0BUv3tAbXwxUXFvXIEsUuJAN6fBR0vrocaA2P311CqEL/m7UlIVuK
	rhjvBHGZW6m/2fS/PsYgEcXU+VEpTOkDX6hOWvDfFpz/8QZX3xYXHZXF20695KKhFhI5Ga
	Ml7vwuCyLvLSVzCO1SxMDPFU/sjXaxY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438406; x=1790974406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
  b=Sv6JleMGGT0mTdy4t0Tn9d/KATa5S1TV9T2JawjSzU6FKry94WHP2PD3
   PmYjZ6DLOcXmnlxYVZmZqeNZoP/sUof87ZBp8mPOMM45vsKnSEl2ak5M3
   as/YtZO+9+pE1Y0CkN8JMPnu4OPrpdjVXiPVbbB7C/0EjXhP4OzFpomps
   Vk8YobOBhnWVhLWxtcxp849b5XGaYMMHaLTB73MjLc6DwxKyF7b9jZLla
   xpsvrF0nNz/DGjGCQiyxf1uIy+IrfhyhlC5lWwQQSMbV29usT9K2Onkng
   0yx/92/LHNInQMuLq6fNAY9i0Rx4XBL1g+H2fXQArbvDb9QXOjzZz4ODT
   w==;
X-CSE-ConnectionGUID: 60l/H3NaSDq8iZZRRpPBUA==
X-CSE-MsgGUID: zgI3gS+nTMSxnVW3l4Ycrg==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2924593"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:53:24 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:4086]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.83:2525] with esmtp (Farcaster)
 id 6998bfd1-38e3-4797-91be-3a6925938509; Thu, 2 Oct 2025 20:53:24 +0000 (UTC)
X-Farcaster-Flow-ID: 6998bfd1-38e3-4797-91be-3a6925938509
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:53:14 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:52:48 +0000
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
Subject: [PATCH 11/19 5.15.y] minmax: improve macro expansion and type checking
Date: Thu, 2 Oct 2025 20:47:25 +0000
Message-ID: <20251002204733.35652-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 127EE4000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6hbemeh4pdwhxs9otgd6e7zpporyf4yp
X-HE-Tag: 1759438405-151447
X-HE-Meta: U2FsdGVkX1+qcg91yzPYXuuRyoOnXhK/f0IuEul67GoC6/Z9rYF8DhKHmMk8eqF7opsep4wm2Tuq1aY2gryCLBTeYAUVd4C5E+kMFNtEWtDSZ1b7PaurwCc6RN0jplK0Vxbi4fnlvSlrnP5enpUYzdThg1e4KRJVZOrKD8e2egnbscxMUurG9z0FY9iWfY5cUoE1aHIHhVSzBPu6WOP0UfYyAjqnuoLD2Yz2S4NBZOoB/gYAeEyMGZ94T0DfxCNVOCboBpYe2Z+xdPwtVVQFgfq+D1cJH7sh3XK+hxg3cF5msuzIAuiX01zyzZZ0ewaHCMRg8NvoTV3FG5VOXl6pdsCJ2Fc2jOhR5olh6XBwIjRTsJLwKwSPtJp+yDr0gJx6zhrRhzEaCv86sNqu/rBv7wUrckyOr57uwoURUaH9TQcTrhAx9bmrIU8d4/ysaSGl8UlEIBedr8mfge71qAUapMSOv3ubdVfW+Il7g5SsGh/bn09D/IZH775iZzfciWaF96Iw09jdo1cMiKiW7BV2bZAImgj5NWtIw1QH63HitLrKgJxkeiPV42ylXgPrtaCT2v0Z0ddttA11naFK0UY1HgzA34WNWIyfGGtB5whm+tbLvVnAhh9ZdmKHq6r540+5hiBD6U9zsVdztXbyTXCJVgrO5A1vK1b6Y7/9doiCHfsT5+K3/jZZWwGN5d9uotEgu2UnwKOWK6iyKIrnuSUFyQmwW82s3W6z5OSufiIyEZb0xgdlzDosD3E+2mESVkfSp8AOXjP0W04NK/tCPTmPRwG51+O4MBlvFvozQl7lcHIjmYLiQFnmIE7iC44FScGMU9r5gHfAw2MPaKZv/zMarKX6r+kZxhQxqGaCXKuW6QpdDxjNQgydv7cd85uKGztMSQV5d6kAQrKsVQuyS2ZTfvVrS31kT2zMDBr2y4KMrhZepI2Ze4LQ6a6AvUt0I3wOnTyuqePVziYnrFo3Aej
 wgxk290o
 MURyGQmRtQYlfzVB4un39Frffq8jGQ64NjcJOE1tDxhNDJDxMLG9yduH8Om+Xu6GrjN9Vjw3wQasuYvJQ11XRn0+ZUmekKbucYdieqlE9FG8LdMPZDiMc4PnD6kW7EHVC4b3zhhSg9bOJ+bfncbgvtVTO1aCninuEm4IeavFdu2SfGAMB+fpx2dqEWkBrj6vUTREoNc51blg1Gr43GQ33s1rtlS6J1XK13Z5Zwx9wjRudzHdHUbs/mbGQiyp4744b1L76rZUSXHIUZ81sqPOrvfcoezPjWcAJpvq9XLeGXlfytuyHwVzDbdvNsIZksQ5HCkXvr9eyLpfdxI7ErDesFLmNVlbNJRZ8gg4S8FFj46RqaZBkkYZ62lXPv2Yt6zd3jVMtUGqeHZV0FalcpjwznIkoqnJb4FbizKIG7n81tNu1yQsZzBrJr06X0VO3Q8OKGGhkFIJm0+hyrGa5FrabRJn1q1igQFfvS6NFbd+bUKWU92xfmrg9qEQHMe88j+R/xDVNKWBM+fNZXIyDnB2QBrbhGCkUigSVGbXrLP7FFRjP+3weqTxSMJLUUMfPsQs6++BhvM9KMBmDskLbEglhzEgG2fVcBzHvyVphjCquol8QfuCk+uX9StZaxxOG9/pjfmZzo2PI4LY8xrO7DtGV2wKjBazTTVO6YklUGZkVqsHVEKHtHdEbs1RitSXiOIWe9+cS1kP1lT9/53MMkirkiKqnzkuBb2dRIJr+etwsZoZIbFvUmkA+4wiCNCzELsoBDw7dSkzpagPfYEn3PjRUKBol/oNa3vKrKRyto3LqE/8uZwfpTpEmiseUuH+TKA2bOY+C9fucgxR9ktQqQ+UysE8o+SBnjFuMYFsdacSIYqG5Gq2Mq+uNic+9cJqN8EFUWB69GQoM52wC75qlDVRa0bKxJuuMJitvUJc5E3/xR++zN34=
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


