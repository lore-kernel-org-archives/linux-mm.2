Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D877CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684448E000F; Thu,  2 Oct 2025 16:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634298E0001; Thu,  2 Oct 2025 16:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC4F8E000F; Thu,  2 Oct 2025 16:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39C048E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:49:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9FF013B8FE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:49:33 +0000 (UTC)
X-FDA: 83954365026.07.9D44007
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B7A120013
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:49:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iih4GdL8;
	spf=pass (imf13.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
	b=SySYKjQa4YzYzBOcmZIHMrS5TqYoIhBaK8Lsg/0wvGPu6JuSiIurMNU6Z7Pgl+H0P91zL7
	4PjKG3ZLgPW21slg1TKild5AFcQCcrUhG5DWLOh846NQykG7ZJwICASwl4gSLOY+/xdeWn
	C7nf6jCVy4D9Jf4OkIQbnt7oPcMkx1w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iih4GdL8;
	spf=pass (imf13.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438171; a=rsa-sha256;
	cv=none;
	b=j913KZQ3etBiNTtUfAE9GJuwVw0sk9tnt87jJQfG481JW4tG6n1hC3BvA7mScmya/iA8gk
	GPOEaS+xVl6jbZOqceks23amsGRipicToj2ciK1fegMNtdXTD6TUn1nZUg6zw2kW+FWRtR
	1c5JsNLYExRAj6F4Zj8R+5XtsCkrlTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438171; x=1790974171;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
  b=iih4GdL8GLrWgf9kHjqZYIryAqgXsy1XuPXqd1cNPCrvXgh2KovdvsHD
   EGt1qr3Nea5Wmd7W1kU2RefDWg2kAZvi9xsJ3LNRPIC7P5qPjSQqzHzpS
   cgtd1HQjgiFEMUC4JyRzIKTIlM38y0/9eX6qG2VKTocOa8dfS6VfUaZBS
   oM3RB+soEiOXEytB8UmQlpSvC71oiYBTHRxs4KBMLeUeX55Qdlmo8qVv1
   HZ2Mmv9HSHJ4nSUtmFhyxJYFTZEO7xdTakZS8EgsVdZNhR+vj7hllL2bk
   ZUbOczSxzR0hiaiy4ddn5zHt6f3aoZr7GVtQfGLZLJ4TozYmQO4eFUhp8
   g==;
X-CSE-ConnectionGUID: XeKnj1e6T4m4kCy3QmKu5g==
X-CSE-MsgGUID: BnWh0oe1SOiv0ynMIzPDUw==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2928085"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:49:29 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:15874]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.16:2525] with esmtp (Farcaster)
 id b42f11f5-8c2e-4cce-aeac-cbfeeafa7e73; Thu, 2 Oct 2025 20:49:29 +0000 (UTC)
X-Farcaster-Flow-ID: b42f11f5-8c2e-4cce-aeac-cbfeeafa7e73
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:49:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:48:55 +0000
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
Subject: [PATCH 03/19 5.15.y] minmax: deduplicate __unconst_integer_typeof()
Date: Thu, 2 Oct 2025 20:47:17 +0000
Message-ID: <20251002204733.35652-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: dpai4rhczyzrgttkrgkkumwjpd8e8jsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B7A120013
X-Rspamd-Server: rspam04
X-HE-Tag: 1759438171-850492
X-HE-Meta: U2FsdGVkX1+ujHPKE6vg4gmUn/Olg6neBx0sCnyyAOnfXkthGcUJ6C2uPnFEFwLvyMNV4FdjXP3+OjfoS5zyyJ0yRuL60oybcd3SdGzfJgEnmjZS/BSjqiXWNagqQBlgpA6+enpI68SZn9+CAjlkyR1Nxwg00fZ11meCm3Ay9JjLwZObEy2QMQ8THcTy9+0SXdUsauc11wvh/xG0Pr1dQ3ZpGLNhxGE4scD18QO7oyJfXB4WtmlfGHmKQHzoutbaEiopMhC3SNIYF8rQfnswUUE7/r8VRYk8M23QpYt46P2eaJXVpQXvBWSMUUvNAoynMQe3qMsnf5vl5aN8N7TS2KyPmEFbkoXVXzSc51p2rxWywgRWOGGX7xKSGenXg+SA1/Wf2L25o8fjnq2RKm/611Eeu3U7TJHyBoLk9geVP9RVkJsdl1CR1RLpWV1zCUZ6i17t43EzaNPa8m84DzkA7pHn9Crkcbbb12OO+94Zf3EyAwNmy3rOEUcWjSk641ROGcVNC2xa3vk1X8ZutxoOCv0jiMmShbcceLgutkAb9mna5V7BWYLYyJr4oNhRMLZZqEtWKFf9R1BjyUm/7BZWmSz8b+h6sY7OBX8hd9mdq+Bbb7niJvybq5UnUURrNV6+do3PvU03CJpxso7+yoMgzRYu5GPy7g3i652ERqOE4QwYtF19PwCFImWL7WcA3FIN9KoTRz/RJYY0m8MWposBvq41f/x8yVKPaGxj7QA2Z22khpIX7PMigwN5h4whdPumt8fmCI6/isv2qiQW+TAnPd/Mxp9eGdfoDhMHc1rI1FSewKuK97x2TbBVNTBPyJlfMil482EmjmaLfegJoHipm6h+EEOHPTFOkpkSyaulZYq/RDd9okvsmIErNZXx0CIl/qAzel6q/9AtOzSrL68UTrIT12xvkrR9kOVsKh5qTIIs16cz2adDFYHZ8mLREGwzGaKEjCj+hNFd5vcrvzB
 sYLr3C2p
 suVNpCQe7hz0NMhqcS8UItnhTIeY/T+I8jsuCtkfgw40PpqKYwm4sIynsrnGsbn0Vzqq6/9JxxoO/H0oWMDZQWNz/x5zlD7qj6V3aKlVJWimR5kKl7LRXCNXC3HpkE9SAMd4N+N/diTPYa82SIZlTQp7+HAgvCKTIZX9h3hIRsPYr1u8CeSKnbjT4zJ4AIsqAHJylH84xh2h3varX19XPKCR5d0iFaN5SdZZZI82PoP8N5uqxHirK63qcw8Xrcu+YA6iUqgKFcAyb7HSkMsvrhXXwlralGtaju79er88o7GtxtP0RfwSEQp/4o4RHTTgVX0y/7mhiz47TkuHpnR2T+ARHp1L/n8zVFQSeAGmD9xVf81XcaaSBJmwKfFcQnqYVpn+FbDb7DJLsoqGofwt9/t6J7+U2N0jgg1QHsqoRsI7u5CdKFUWm0ckG/M4LzFsAROIhlgbkO665TKqmo4DPPebEfXma65vU5yNumPFXV2m9T0j2gHBgUFWOn66UdfO/toLhEAHq01npJA3Ydcasok1P/Iy/brS3LKgGpBSNHHAXDYib1WPvnnGw4DsOJHQID7Tgr04+5E7BWNosUvZF2P3xOaH65VicNgbqqiLCOc7GhtrLFEPKuV2rlFIcFB15GFZ0bHTc+69wN7r7lDzEWq6zcyANiGaM0bFKTBxv9pI7y1aiugMb9pz8wNaldb+2hPmAM16KQSKsRw17POvdo7034IOeiBUSiIROGrEqoDdGz1KAU2LaR/ZNGmBfJcxxqOAV9mpvSnbabV1RVeE/e7rcoChEJG2lib55RV3HqAZJ1sj6/mBwx7NcunXoK4Qbc3EMesvym06UEgtGW2dB50fK7mh72wpDJ53vib209slifaZFhVQ1Kt2gFShMUFkQh2JH7V2PusBQeN89LxmYoE/e9A4pIX5lilwFmNKmMV2ubqLGcm7tiX3oUyPjrp17hlBYDbQj7UAp56oeHAFiT55+JHE9
 4Pxh1CQE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index aac0b7d23768..62b0c0a3cf30 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,27 +168,6 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
-/*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
 /*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
@@ -203,13 +182,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
-- 
2.47.3


