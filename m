Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26068CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CBD8E001B; Fri,  3 Oct 2025 09:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD0A8E0006; Fri,  3 Oct 2025 09:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC358E001B; Fri,  3 Oct 2025 09:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 571D18E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:09:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0260913BC3C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:09:47 +0000 (UTC)
X-FDA: 83956835256.26.F594BD3
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B5341C0018
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:09:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AN8sshw3;
	spf=pass (imf21.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=wFr/BGE4O6f6iCWsHwAsbLjN9chGCm58X+2sjJknIguk9r3/ZRT6Y4BG/q8cQ4MWDnBeRm
	i2Ny1HKepIciJDS4bYoTy+iEzK9jG9S9Js9QMY5rWNsusm3oJifdwIOrHWkhFzPszoAmDp
	g8chie2TSNzfQdIsb06I/hWOH6sH738=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496986; a=rsa-sha256;
	cv=none;
	b=xnYxZeuXUwNCfmW+Kv21Vkqz8moLJiIVDKz+FkyXTu4uXNHw61pfZb8GOJI32Xvfx8mdu3
	paYuFhMfwT14CqjCJxTVV7Qs8qPRzlFHomDJkKwfgc20GyXdpGrqB7BW4Q7QhD670AvGiJ
	gviYpvVsmzLZ9hx6T2Dw2WopU+qIHf4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AN8sshw3;
	spf=pass (imf21.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496985; x=1791032985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=AN8sshw3s5FbYom+zir6eMaMqsAyem4+szUIdNdWJvuCm/6uE0n4D9NX
   t9r6hekzHVDPBED0Wp3vuLfDIejP63n5Tf7/V30eOeMOwu7rhlC0AbbUF
   n2RQ0q90KfIkbl6nBIjV8vcng2EjZTrwsc26XfJGiWDyE/mXcNyBMSjGY
   ubOTC6jEfGyTsTjX4ppdUtZCWeBWMQin8CSx3+YGlFnQC8Ttk2aso+/qG
   b7N9QW1QITKMUjymRZtiesE313xxganx843nuMEwEhKy6ocp7dnackscN
   h/rfPd/6WjGECidGuVuHbvjqFFfXbJjaxcYd7I1MA6pInGIwctv1chEUZ
   Q==;
X-CSE-ConnectionGUID: pOpShtCIQUC1YxeGDT1KYw==
X-CSE-MsgGUID: OAQmpc4qS2az1wjc1pwbrA==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="2963326"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:09:44 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:13822]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 337663a1-1fe2-42ad-b6e4-6137698a0a8d; Fri, 3 Oct 2025 13:09:43 +0000 (UTC)
X-Farcaster-Flow-ID: 337663a1-1fe2-42ad-b6e4-6137698a0a8d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:09:39 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:09:12 +0000
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
Subject: [PATCH v2 19/19 5.15.y] minmax.h: remove some #defines that are only expanded once
Date: Fri, 3 Oct 2025 13:00:06 +0000
Message-ID: <20251003130006.41681-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: rfn1yuar8y8q4396im9rwf8docgqafn6
X-Rspamd-Queue-Id: 9B5341C0018
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759496985-401865
X-HE-Meta: U2FsdGVkX1/TwD9C1uHlKSARBlHwaPHeysBNvBlmtplkHrs1/KS4lYYB3fr4AD3Yo/gOTRj15ngJC+tZaG8LKT0hHZ0HjBA1Fj95h2aUuvQkUZ5R4tNCN9SGBkLnscQnoPdR+E4QZH0GQw49HJrQRgxgxfJWmlc9iyYEGsHkQmJ+b8pglIc4/f0IfYFwGLapecXZ4iB7sLJdKrf7vboVDw/UIR39yCCzFZ2C1Pv1sEtf+mTUdvvjwktAlzVrL/Q+26TkBYj064a4J8AZsTBqrcrVtvy/5WBxVV/Umu7qsSl2PtPoKJXvISSLsl26NuhdpjAsFWUc/F7v0LSTQ+w3Hwp7C5822agtsbYUkae5jhPETdLVtUHjR3PWBtLQpFeorfhYACvdaye64lh9n1HuX5VbFCgjUMedrYIYHndti1T87shcWkQtQ0ia22aDPPPNH60bL4ULicd4aMzAUOPYrjWJ+8m19ellcDcNINUSfvXl5zYDYpm4qqdUk/m68Y+R66/7lCYJJxn5A+zXp1b2wtbW3PGtfq+oCnp2xiE3PZL4vqdfjMS735G4QBjipTBz2nXiWpm5AyzdHvG09J7+D9QL4DImdghky3zTlfCFpdeWYFVvBiAvrRpzjPqQs13VNagrIbxbIlJyC+LEC5xDmF+06T2jZYOYArM8uwUvO0VbBFxmbyweEEw59Z5IoLLWYh/3mUBa1Pl+NWx4OWGSctQYWdJZpRXp0YnbopvOOZ9dE4nY32BHXAlxostc3AU79qSiTH2x/iXIRQIoffGVK3xkOWy5egpUvRYh8W6gfxSOkMiVGwkT6PKao0sLIbW8zSFQKHYGQ2Z0PyVVCBop+xNzx7NV75dHNWuhR9h3cEdfRskToVA2zOl9z42Sn/9IfEdU4q9bAACywkwaIgjNixeyBmKlP0aJAruDEKd0nzkdgWDYSzpkcjwcdGCYN1SGMcM0XEQtQmPjJk43MWI
 OYrEvJh8
 eOW1HhZiueATATMA3SBYvnzEPP6a9f0Yksiw7xMCm8xj68UZOtcbiTZSXOwT8McLpE/WAWpZ+DTBGOz5eVrK5t/OhlZALhqgy/g8nv+/3nBw3Xod9YTSpCyB8+OL0qtbct298WR55Egzzk+LeWeeItePajPfDnr7fgllg3kVc9m9ocKG/NEbS4FV4OGI2zI8nHc3cizk0F12uiiufSOfBVTBFPm3cwXlAj925nqrkB18DwyfFNb7NLoHgm4/P4EgURYMGH3bEObNw4NNH1rNCA3Yu4Elz+cdqdCUf7RfhTDqrvj+qJ9EyISd4koEFJFo0KhoLWMbWk1zSU0dOtbQpFsJEQvdIRmPNl23+JsfIEGyKYM+PaX2sBjuru96olOnVMBdulLb/Jqj2VVD6SgtlL54bXEQ/kaw7jXT/QIDsNfqT8BHhlmLI0Sn9LIE/xyW/i4OVL6plLn+2KNKnuD+hgYQnCFY/CQJ4zJgX4ZNbmkJwJOf4NW4P+gqKqgEFqEF+whQg9uBqdDt/aoXZ00xVTMGl+LC6bHNHQonG4FyJeK7rpGb6RyAow50muy0Pk5Xn3IdSvmZXzjP09kNqV1n9iPstIIFBmCLP/xFSDpZS9gyJCVT9S+3BfyqN3aKXkcCoD+W1A85K8McRe59RMj1gzZkOhiRLw7V0QvZHeFz4R/Fd2p0K7KU8ztyX2jK9nc7gjPhgZSYg82YWT7wE62XRi4iE89R8p53Krn8/Yam/ICYC9fmNc2TXq2dsH/KNvHXEU6CaX7u7lUigYsco2+dDZ5LjOghEbSmRLfUiMFJKlFqD70Bwrw3v/9N3YUe+jThhVpxWdjtvFKdUI4q1pKOMOLZqi56nT8Usm0QRN9D8fIeVzJG2VzsPCd3CJsYffcl5XZFQYqIECAKXQUH+YmLMdXwUBQZlXVsUZlpwcnuxVcZOE+P0DofGYorklZt4PbgOE2eGaxPI1ZxCCxt1/smzkxKJsLBH
 XKhiFfJQ
 nIS/tjWRwgZdb2p+ZcXFRrBl/VPmCL+uDAhYjM4aRrynycwROG64SVkPsBpBJJcYU5Nr7NYwTdSgD1mu2nRKLP/BdiEid50zqJ6OptU3Qmk4bUAOKA+TW8a00rAlk/m0NfX3ic8BD1UuSYbEMMFPs/ZdMFi5UiErl+Go8rc0nTox0+oygZMDXA==
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


