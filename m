Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA167CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F198E0035; Wed,  8 Oct 2025 11:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5068C8E0002; Wed,  8 Oct 2025 11:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C8F8E0035; Wed,  8 Oct 2025 11:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3094B8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:33:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B372E45F9E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:33:02 +0000 (UTC)
X-FDA: 83975340204.24.3C09F59
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 908041C0016
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:33:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SZsOKLM9;
	spf=pass (imf20.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
	b=40SYjvSODHl3R3Sq3+9KJY1mvA4Gsa7GgVRYUOlHeXfUOK2VN0joyUbM+Q68WCsWAh+88F
	JD53poN1YMCk10jYe2MZHnWyX21Y74vEOrwxdQfURAktRkfaR83asd9L7KrmgLR4PGDIQM
	rdbKEQQj+IOZFkuOjQNKmW+7ihbWiWk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SZsOKLM9;
	spf=pass (imf20.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937580; a=rsa-sha256;
	cv=none;
	b=Y+IczjWIYWi7ZHId1HpFcbfVcM0jUamxFtCaDV7BFKLmr/AGyUlXRoTT9v+NkLxMhQrHqx
	VD1RZnLjPIs0ZRF1eicWYXeBVwYll/n6uN/JfIARrmMulnwcePGHgTLcg0sUBHXiCwKTgP
	Gq5YMvqOwXlvG3CtPiO2nAPpasufnIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937580; x=1791473580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIWZLyJTB267mf1gB+7eM+QKWeNJa7R50sbMR1WI3N0=;
  b=SZsOKLM91fG2rPAPeEIOaMI8JV3vzv2wyI1VSHd+Lvv2axRwvGswWvy3
   HTYoBz4YHRJ1r305lsUXraG67leDVkdxHmkg0jHE8NKcYf9lzqfidv14p
   fXwiK3IzJVTXtlr/rDhaCIA8Tu4YRhAshPCNoiBUfX1d/SbcFmmSdwloU
   Al7K2WsoSCwkRSz4mihsxj7U+kuthj/2PzPTtoyXCPb8d/EuPSB2QVhVv
   OOlFHNXg4Yuu2L7q6ax/GMKM3kUp/sYNB0GnESvKSoG3mrv1nAM672BYS
   d62qUvKuBPDNfvaQYSxSt1zybWKR9O9U/97TclA/EshRNXXvMmyWO92yB
   Q==;
X-CSE-ConnectionGUID: C0fPTfJ2Sb+HaXYqhUIJkA==
X-CSE-MsgGUID: FfMpWZ+cT8iGEwxcwe4Cww==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4530353"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:32:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:61111]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.156:2525] with esmtp (Farcaster)
 id 2afb6f4e-bebd-41f5-920d-a5551f70852a; Wed, 8 Oct 2025 15:32:59 +0000 (UTC)
X-Farcaster-Flow-ID: 2afb6f4e-bebd-41f5-920d-a5551f70852a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:32:52 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:32:39 +0000
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
Subject: [PATCH v3 11/19 5.15.y] minmax: improve macro expansion and type checking
Date: Wed, 8 Oct 2025 15:29:36 +0000
Message-ID: <20251008152946.29285-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: mz485sha8tsaubrwyazrbcbhnas69918
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 908041C0016
X-HE-Tag: 1759937580-405917
X-HE-Meta: U2FsdGVkX1+VI3HnS0XW03OIp47FKBWsWILxYZ52n+9vlQixOL2RQYWN20Z9/QYlEi9HVnVAsXrWR4EzgzbTVOJCA9+I0/xUyfWSKI++N0jcJrSXzocos1LWzSdaX+1p6sqD3WWqbr7ooX2IY2oUVyDb1+b8pvAHDmy7F4BmV8h7D89n5Isd2DqdfG0W4jzy0NLtb29UcOKr5kbK0FKY0ooLnrAClWiYr3n1i4/ts1oNKmgDRhlqdUF6UbyTkcExBWnHzjpFyo7ZmV0EMPvKpEMh6OMlIJLiChs9y0vI2TJWmxkVdfw/nv/C8TbZATfuMReg3q5dxDlT7nCYObXJOdpqJyyBoIDbMP9c+G0xj6pJrZYLyHalM55C1etIvSwHiqHTO6BWqn3h39s0NJGHSw+ccW0VkHrqot8MDmUf12peKOyWHZA5Jo1afviuBnrl2k/rEowUlD0/C4ffzI1ZEhg/nUWbkC49onoZzgAdhLkHye0DgD3dz4lSLESyhLWpRH/ysBz2aei4X1WOOvcxdXhxeku6CpQXwKB3BMh3HrbhKsAUc0NTNRjMOXs6MRxblPX6g5P9V2tmIpHcUmm63YvnlsLNkbXeM/bxGD1VZxnsv2/wLR/ImwWYMphJEeVD70ahb2xdZLvcfPi50B44EZzVUEBRW4IffeLi7R7d+jkbbNRL4dJXThPmOkV7pi1ycVWsgytH4+R5eYzkLUCbu0mZtoKptUGoVuMQBgno2mPzPdv70C1CC/yG896INp98bDG/ZdjDy354YzuCo08tRsVGjtbmXI2xmK16TF0TlcYzW3j8VJEJbm/U7bp39hbhUvarFywKdMhPWZ2nuir/bK80xzz0uyvT+bTjqEZ3ZHoK77v9rKtb4MmvPS9isP3yHSJoYpXZFkBSoGknpAT43YGF1iuCZqDgYgmYxcDgS56b3Az6HTV/1w0Mwf8rd8z0q9QJubP9zcpRaTjXNA1
 MMZPUJNE
 KYebc1TnzN1HTBY2fVrNnGj8pQ4Ab83ys9wKx+l5Llm/KUoZi8Tn4k+6ZQSE+fWqpHIDxqDyK4Gy0yHvAtMRLuLJNj8LXXL1XinAhltdTPmL1ZJn7AUIaypqio7RVrtHTQWGzDNJfv7xgFEEKJJeE6MtLxmhlkjVwzXD/7deYykicoa3qc8h0g6KQ7N9Wtd8lqKn8U/0DkV6mNwxvW45siNiX0gsOdfNINw4N3P1mn+oUyBWGSf8NVjx83JRBrevrRxspBVzy6zZXV7tArOcM+y98jVdBVfe3GxcsD27OEOjxH89KdVQo06dR8Baxv1ulxYSm2J+PYSkgtl5LJZG3ONLS+8R19Z9oyRIUJdztzV6dT3GNOmiYKEwn4YTN1LwZqG+EFhfK1qKyW8u0DLOxWhW7MOW4+uC+b1tjqyb933pdU0DcyJL3sM6M47rt4khatRrhZb/opdFdvjHs8MoRXFR9ERpyGzUHFO2EBYSPrJAkQo+i8phg+eXfUkV2w+pJr3rxxvJhT2EQVfKr4r8Q+OxkyYT9uraMuIrtFdvBftxpD4HgjGTH9Hlol/LwEhqCljFiyCEPdh5NvNZpKkOVRDSMzZBFzo9Cyu90bD/DtgsLtWKu2fpqmNpP/F4x0ES2PorD2zO8z2rw5sDqEgt889cu6eJsVc0eoz2/IWIYzpomwXGx/wKCJZosC+GiZJTSH5B9+OsmJRUBpnB/hPBVwG9mS9RkaAhCwyyRvVaTKbrwDQ3JJo/T//sxgyDUA1PacINX0XeKJJ4nY+rRW7t7qLMXp7hw9clTmi6Xe4J2hrncmC1O/teBmVYqTUVvveDcJZy+yD/NblsDPOgzQor8VJ3CBGLX6hvSMZrQHk7jbJYAisWhEchpJTISw5JZzNIAZD3I+pb1SK68s/4=
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


