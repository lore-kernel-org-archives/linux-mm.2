Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2547E63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876416B00A8; Sat, 24 Jan 2026 22:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E196B00A9; Sat, 24 Jan 2026 22:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDF26B00AA; Sat, 24 Jan 2026 22:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 597506B00A8
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29CF9160493
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:02 +0000 (UTC)
X-FDA: 84369072564.06.41F0945
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 19C23140008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FGoHm3Oo;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxSqLIWUFqoLJKkSUBX9R+yKK5enlimwvQOSHMZK1kE=;
	b=ALytJTfQgTFhoEgtUmkO7M0vzBxBzCi6HApka+pp9HiL6MyBHz6aMNCb+9zS5Y2feGj5En
	PVqBxTra9eBwGD+6tL4iDyP7yQydUagp358UmoQ9UsuzZGAUrmXVtCRQwX7pIi7BcuBS2M
	esys18oeVrlbM6QGVgYU1Zq0RUNaudE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FGoHm3Oo;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312160; a=rsa-sha256;
	cv=none;
	b=StF4Ltc/yeJ3DhcuU9W7unlvFTgt6keBFWeG/IMdFY9uB1DffC0C5mLmCIjNzlnYrERoby
	EwQ7sLd88Z/oEzE6hquhXNun2Pko9vM8a1Oo1akDpQng6QX54+QGZGgQldpO2oNpOneR6t
	gtejFzqQAZ1bQKa+opL1IjuTi3gdzIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312160; x=1800848160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iZsxDdWF2NK1BJ57K8D8/hdtu1PFMhaa5X62fuQilRE=;
  b=FGoHm3Ooi0NRq8n8iCVZjhL3QV/bBcp+KVFX/QHteNYgA/0T0BvPqGHn
   x+X3SqMkg8rDTTF4g1YPtwVBmDGCOmk6EMeuJITc4p3mkXb+jqUT95ikO
   +ycX+W239a425Zk+SPNNCkW/Amdjuun/nyFlpoj5sNhtxwxy1dlJmzmOr
   mN3feRFs1Zxm1Pqt8MHg1+OPkCzsPNoD8HxP7frOT/ZGsdw6nOD/IlU6P
   BRbjMOfMMffaqLBFVmLdQI8ndtB7qIistGhy+V74ok9J7HRYfRalsxlQ8
   h1mWHyMg5z8ptOg3FA86ffqXoPDgIRk7n6dy/lpsln/YgtZWqSU6TUdP1
   g==;
X-CSE-ConnectionGUID: 0MlGR7DqRBCYTy9wfEMaQw==
X-CSE-MsgGUID: ZRq9t77qTxGUcv89GE5leQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887513"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887513"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:59 -0800
X-CSE-ConnectionGUID: mHNlEFcuSZ6CiJ6gsuZB5A==
X-CSE-MsgGUID: TOHf7fr5QoqJz3LbsQFzlw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:58 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 14/26] crypto: acomp - Add bit to indicate segmentation support
Date: Sat, 24 Jan 2026 19:35:25 -0800
Message-Id: <20260125033537.334628-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19C23140008
X-Stat-Signature: yzomrkx6sm1hmaphhqx51gpsrdu641pr
X-Rspam-User: 
X-HE-Tag: 1769312159-612096
X-HE-Meta: U2FsdGVkX1+gehcA69NDlivhZOzww5oplhe0dgQZScbXIyLJcDj845g9Vk47/hzu4/N4Xd7nR8NJqxuIE9Md1WGlMwPNI76lJUVoZRFUDd+cVuxo3S9ZNyjwUehndX2U5ukZG+SYylYq+YjkUOQqDRPOBA2yplkJPdqiS8xKb5rf8y2mNR/kDoVz9bHuWwGjvpHW7Ni4IU2XqJOu33b7PrcLcV265l1a5gMH4P/1D75PuMTlWqNWYT97+MKQnDs3tu9Xc3yBcNGzYEQQYo7w96zvyoEmvLGa6zVrWxrjuX9uHeTJR6xgrz4S8RtL1F35WIrIHIVkURUkAgyIJ33aBg8UBEpatm1jvjSdcR0dz4ZCfYj85c5du4XH4gWRL0QLaeL5DrECwSk28Ve0Lwr/tsjRaGz9DqKuT5jPrCqXTxwsgaGNeINXFYtC/mFe1G44jSA0ITMaN6ORCNlSFmBQ+zuQmN6Sh4xYJ9wSGaW1oiwSv6fXJ3ekAaYeJg8cpK2wZ140fJDorps1Wp23JSMSVjFqfGqA5iaj43lgQ1NiftTW0USPr8koiEWOluwI3Xu/DLANyoWtPXsjBpLl4f66DTG/ijeNagm90Nvkus+N5jTOFLrJRxd4E/HK4US2Huy5a3k2i/fWJsjuHpXvBDWW+vhSkgd915FWgcs8ZFJQUWV/XjRu1bil1l9NhPt0Fwy0ufrXuXz8jPes0EzMGugvrFYkAeYK3AR4IQ8o/BqsEEuyVs21K3xH3XzYLDS0bNImokfg/cd/coeLIHkixTHbHakSLkcxxdvJ8rQ8ZGvML+CU3RsPjcf5slmsSMTAyxphj/5MLg5FWfWaealMcEXjekYUddJjcdYZo114vtnXpbUismYqKPOjAIOHh7tG61FqDLEPsJmRSPdHrkyEYl1IvwhwpgW/yYv+nHM1DXfzq7FGeZ9c9aa5DRey4RsAUPsQ7fZYBeO9hY03pjEmVoX
 wC/uynG2
 HN8Bo6MQHB+/OJjaUO6rUAog6vjHfkFUGRVMhVSD4QdKrnlSYxILVDw36yu13hH7n6efKvR6C6yGZxLQrJwkoUc39SC6JStZACKfxYyOgYBcvi9ZrBb+52dJOS+1sRUYv4L4IzJid/XTZfZDYR2nQB3LHDsHrn+t7/aSBbKJ7tmIK4uvNVzMwfx4smMXvc4be9uqqfFahNKXRKhAiMcAdEpra2NqxRbpqZ7eWQxexwd5EQ4sk+wBDtd+ilg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..366dbdb987e8 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -188,6 +188,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a2137e19be7d..89b9c3f87f4d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.27.0


