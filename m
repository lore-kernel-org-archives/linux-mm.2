Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AF0CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15068E001A; Fri,  3 Oct 2025 09:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4C18E0006; Fri,  3 Oct 2025 09:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB45B8E001A; Fri,  3 Oct 2025 09:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A66DE8E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:09:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7084E450DE
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:09:20 +0000 (UTC)
X-FDA: 83956834080.29.694A034
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2CE19140009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:09:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=KPiMCqHk;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496958; a=rsa-sha256;
	cv=none;
	b=A9xhU9UfVYVEwziZawxmyU2g/nBsA58iCC5uQ/H74I9MfG75crxbbsAkjhoDDBCiZrUauZ
	rBKcUq0JsL/DT+O9bWFYlZjVjlxN2+BshjS+lPeHl5QuSULsHWeAv3hgEJTyEpls3+ecIW
	TIaAximVUrpxW7uucW7UP1sLMmXLjxs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=KPiMCqHk;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=R/EkI7chl7zZSq7oSI8kLTfqG8gZyIlMkJ+mO/qSKVYNAZWZ5ULgF3veB43INuE7raRYog
	pVTpwEeVoW5rdnvKHM2m1DgWpxOK7LAjVNRTJKwJq0miPfSYuhvADRM+YtPiYJ3SpHg3B2
	3rHDGXHy0O9YLPVuUDUfzX3Wz1cU4Ck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496958; x=1791032958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=KPiMCqHk4rPLPkNnChvSJKTGz8CUGAeLjaIXwOfA8Pf7YCWPgjZCWwgY
   wH6VAeXScEnycH/qe9DUYbnjHC0kk/i/kGBVmLJDtg6pzRehMdqfZiliF
   d0hSgI5wc48Cj8k+BBHvECbgUi3H+CQ0IYSb1PgWkNAwzHKTK2dawf3un
   Y3R3QXGAd1frvNsBWZVO2Qj+9D3zrMlpc3/jIJVBP1eVE00VymodVEtGT
   vFbISWzrc/lLJaG2ICHCSuxpC/ihPVi11zvqxELk3NhXgLDViZEsBaKEF
   S4AK105HdVJdt+y5HWc/wUUVdZe5ZkOmisZ5sm38kaS25wz7r/fOP7spX
   Q==;
X-CSE-ConnectionGUID: SUoML2EER6C0dlUOoW654w==
X-CSE-MsgGUID: 7ixtL/v1Thy/Va4PrqSK/A==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="2963305"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:09:16 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:8117]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.83:2525] with esmtp (Farcaster)
 id f85ac67f-50a0-4f2c-98fb-56ddd297f685; Fri, 3 Oct 2025 13:09:16 +0000 (UTC)
X-Farcaster-Flow-ID: f85ac67f-50a0-4f2c-98fb-56ddd297f685
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:09:12 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:08:45 +0000
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
Subject: [PATCH v2 18/19 5.15.y] minmax.h: simplify the variants of clamp()
Date: Fri, 3 Oct 2025 13:00:05 +0000
Message-ID: <20251003130006.41681-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CE19140009
X-Stat-Signature: yswfodys6wnc3zm8ghn55aqu4piufqxy
X-Rspam-User: 
X-HE-Tag: 1759496957-25421
X-HE-Meta: U2FsdGVkX1/FwbB0j/y7JQw1ywOze4UGWhkKdLRxkSK/ltrMsxBD0BKCHg22407o/s+ETsy1uCidVy+172kwX3x+pEKA4uEhmcmh4J2f9W46Te2+tyf7nk234yNOOEvCXm4PERqbxYcXyy8O7S+NCEtoxs5klkHI/KAzfMCHk8LPPyvdSbt+DHEFgwBaQPtKHZ2233XJfc9yYivsI1JW0MqbblyU5lvkCh7G4NGEnepeBtZdT1l3XZs1tKjhgZu8nL7MBwEi+CLFR2rSsnCwRYorx6qX3LFGuazqRUxoREPAGnoeixxQYxekdSdqz2gQV24y/xiKk78ZxNhkEbKfzg/B8f+zcDvpYcOuG7VQTp/AYxwyIj012WoVenjSK0YEA7vncPrROIcBO23LaUk9Tcv7qZWQMjiRGmQX1C2DiTADLybsrkfibLy4DWjEYq8+Z/EwhRmrxmKyz9i88Pon9sRR9SYk4SoSyLr/GvrB/d5RccZeBRof4UjcTDlf/SN+c5zt72vGvJzEgdxTgTZBD0xGnzrsvUSJYTAWNy2v+176hsfM4wWp0T8vyhJ+Cy0OPeteDi4Lf/BSAbsZTqkND8btSUgHrpoD96qkh8w4LhTRIXRkzGIJXlJzoBd3pVAabA8DzF8ONvoGI4GwVE6O2Hn4SDhNj0c8NjrOMLC+GFqjp/BO2CarsuIfFYU6VPCQgNVebxsOYpDpmibCy5qPxjyecXoOzMeedY4zWfihYS1NLiL835CI3YYZl6LHdQXI6n39EHORbcbzNtKP2fbGBN1dfZSyDMHpBQ2w1U7R7pztTzyYeGWQj6yWdfbj4f3A6d+BseHFnLybqJzyI4qJzC8S31zwYP0C5yx4M6JDh9EoK2EGxlIE15hiAAq5+txsEOxI4suztQhIyy7X6r+c6DAvPmtAskhP4ta5+al51H1T5RFU4SAP/zow+mxxqnDEe6UBodUWtFX2WBoa21N
 YG0ouoBG
 tcCJpd+scKFiP+4Vk/ylbRFdlUb1p20IIDIMRNpZH+4aFTpTUxFCdffDsG+9Nobae+SsJv6itBqxVBL/RvFtRfyBXKj6Bs23OoEqBdypT+xjA0oogNyiEg9su317aBWGoFB7RTO4vk5HvbrhOBTdkQzYAjfxJNrvSf3o10TnysDuE6qVec2ESx+oS42t1/DDr6gRalLXy/SEuCMy9qenaTOCBURHjagd1HGdKSF0Jj+QccwPXgCsh8ujXY2MO67Ghv3eZcqJ/TQn38y80M331S1VtvYyAl884TFHXkNj0riIXu248Mg38dg4WMpq5zkMfd2u1unFv5oUOTLzrm8Lsks5Ad5RLReZH37298TX9Og6xBuKv2gILk4BDX3AekvD/2WbgMtYDSEFz/GkMDplFtJJhbn8u//B99xOx03phCTphwFWrOYsQyxA3OUsZ3MgkSWfmWy6kxndouPkfHNfvUzMUysk0sE+Ola7SgcYu7+RmFdjI9SRigHteOSEQwsUikUWz4Hb2VWapkEp0+/QBG3L0QlJU9WURCNb1HX7NR1meC3xiew0QYFky1wCeMLLBHeztFZgfAJH17dx3jeXPBNDETJw7iIFWJp/ikXmKfwjagtPsykE48trlS7pd4MuILjf42pHBmUVIIewdbEGfxUs8nvPk27Nt8ibe3AxZs3zcF5wp7F5KjTjGJdyL6qqOn2X+lVzhHYJXAMjmc7Oc635cjLp9eZhIDyGCQszQy4gFnhEzGPe7TqjVONUYMHhX75nz9nD/ntl8oO5DKAxcrZdaPwAA2aLvOuLb4ZdSc+txTLzlmDWy/VusVA+zceA0zlwPrFJVhM4xzCrlj6zCXYVFXzYk7VBdgfNh9cndIGB3j8+Nds6DZPa0TmLox8XcUoy75AFRfemZjJjNzdrXoWt7hN2T9uQT6+0Icf0+IPru72oYpv2wf4eCQ95HJMEcgiqKd75dEFU3i47W9l/ZnNaxcgOL
 rDW8IWTF
 ZMIfikzOWuEEu7+RY7sfJUJ/LHYA15nAEa1E3EjwUrXNlW4OwEP0wcsi7wzrfbHxlvAyy6oibAmVGlcnpWQ9rvtb0z3P6OOuClCTl1tDBXe4SCuikSXJyvT0d37ZqcLkrq5PAPBOMOsw7oK20sWMpsnKFFf+MVZZtiL1zsWcJvWKzYUrn9EkFEc5w+u/aYdkdNrwlVX++geHHA8h9P+YrQKPbc25AS3zNpH/bwnu19RXi4VCTjSHq/EI93IHIy3iCPVxvWsrclkYkuL3GkIPMyVKx30EvNm2Bs70HaHXSRVX5JiZ3LskaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 75fb7a6ad4c6..2bbdd5b5e07e 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


