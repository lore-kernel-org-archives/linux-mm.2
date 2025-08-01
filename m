Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5B7C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FB16B00A0; Fri,  1 Aug 2025 00:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EB46B00A1; Fri,  1 Aug 2025 00:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6DC6B00A2; Fri,  1 Aug 2025 00:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 961ED6B00A0
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65611BE697
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
X-FDA: 83726928474.02.34BF796
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4F6DC40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KmTL/6yX";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023015; a=rsa-sha256;
	cv=none;
	b=e1g9FaCe/Q/7KlVUlcWBCtZ9cSb/bC7qpNaMCO6xWtDZq8/3mxAtMzIsoRGcb7u5FlcxIh
	uneD7pivfwfSuTL1NwW7upfH+9lCUB+2zJWKMfcdCWTIzC3EEV65XIBk98HK+b4LvQRHX6
	ttQ4rTf28JN1W/XrRoxzKO1vBMrr3Ew=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KmTL/6yX";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cI2a78gzOaiFMKbRUK+R3Ki+VJFi4uE+TXQL9tcHGuQ=;
	b=RdS2yWZrOMeaT+9tppT5zuFVR0LdbJSh37gfNdQkTw2sWTLCgHk57HZKxthZINRkM7pfjC
	4cJZi1kWQ9Fakvm+8e/ydbGZpdYPEFvO0QwK4bEZhgjMjEjeJlb8OuersvISYJlvJ0891J
	fqZTaN2xQ/6eiH62ZdIEqEG37p/GJTA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023016; x=1785559016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kmk+iJsQT2Exsw/kR1m8SAtMwjqShpsgO63jDQplw8s=;
  b=KmTL/6yXQv/YJ2Uxdn+g8jFq21zEud/CfTUQr7cHFCfhQTokBI1DVB3I
   O02K0XI/sRkJwa6lLiwG/s5ztgeXDzxkDxuktn/m5D1Wr382ubyOurQcA
   UXhG/dB2vE680sgS4n1WNVMaR93U//7fNeFO8vDCC1Dt7nWh5CMi7Ke4I
   QZBXK6u7CwJK0c3KuUqrMwapp55silWCEjzhFZMllVdHTm5X9ninxkQKO
   S6sbbAuEymQdUC/h+6M8vEjTETcYKVKM2RGGAshBsDFghdFOu+e5kARhk
   My2J+athJbstcxHSNglqsIao6hJEfm6GML+qZeuncZG7YnZwwv1fMimN1
   Q==;
X-CSE-ConnectionGUID: noBSkK7IQQi16niYK9Czew==
X-CSE-MsgGUID: IUnxBDgXQzSLyQJ9NtuhxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820293"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820293"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:45 -0700
X-CSE-ConnectionGUID: HQ+jdxk6RnOiSN724BwVlg==
X-CSE-MsgGUID: 3rcGpta2QbWn93R7RBNzZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796268"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
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
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 12/24] crypto: acomp - Add "void *kernel_data" in "struct acomp_req" for kernel users.
Date: Thu, 31 Jul 2025 21:36:30 -0700
Message-Id: <20250801043642.8103-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F6DC40002
X-Stat-Signature: t3tjkfm6fk8wj44k9odum41r6g4xwbrc
X-HE-Tag: 1754023015-391742
X-HE-Meta: U2FsdGVkX1/ZN4Mt5fOiDKa5FvIhSFxpQy3XNOj2K9FxRHZV/XdYdSCozBSmIQvotNARlLP3+vzO9ZxFXME66hPda50lPPNXXdnD62ZmvW6dLn9gy/4vrXjzHB/JQH5y/8XahDyV5yCaiC5IYmoswe0C59K6z03BO6tR3CIEauLyfJ5sDZT8bl6RbQTLBa/DU4aDj1HVbIHzKe4oJE6SgodM6qHDM/Nezo3t6SkWiJKrtR2kYFZlfFdcVYNkDdkT7n547D5QeX6n3Ep+F2OlNRw+GqpuK+Qr2gpYUkgTS/Fck+h/u1fAP9sT/Yr9X+yM1nN2qmVN2+itNbyUQ3/puoo5j0heNYaz5Wb5378A+EXRa8GWOepuPqWtGerSBAZPpJBhCHBI/Fv+anugOKAqDkGbplWIVeKae8eRCDqUfKoTVqCfVg6VQTNws1HsbOGq91dE1vwuk2tgtvw/ztFqa36FoZccQTH/xOAt/5rgj7XQd6M6JutQEhUfdZRJW3+4jq/wikL4f4btq7e6d12PyClHh3MQ2lC8dNgiI2HuW6nKF/MxpE2vbhVG/zSQsMeYXSEMl6AYaaoElPEaLlz0NEFVpK9f7GrG0MqYOvkvpwhdeRgQRlw4pUoTlYeI6y+8dkMA0xdcDnjECnk2gz0tOE+VRekphOBzCk2+yg1nSm+bumVG4WNo4TbGTY+FxI/LC0ryWZ5wk2O/6gCWRc5WHE860y0p2gxTXvPDU9RkzTJhREkxZEPrzJCkJTKbXpJIXoqImASJL5LwoGQruOC7vPwVsGM3A19tis2CyN13Dz7hjFSzaHusQtdowZgSwKzNkXw/1acSjJHwVvbXVgoT6f6C60ZNZYIfsI4TV3+alULHtf1I6cZE5cqAp15+ky3g6LhTE8l+tS5oucGcgbXoTjKwjGEgeZfmHiBTMk0T5tBv5ly0+uQ4iKjYUtTHLquwpPx8h4/eRZica8t2WU/
 9hBEe786
 WS1PHmtMVuiyT1xgk2eC8g7JuKvO9/ALtoo766XHTTOY0pjHIICeb15RHC3rtG5P+Wz6g16o2rQ9+djLKAO7DkKvHmz9CzFDAdZV9pjMTH7UXjeD7XtDxSk60Kn4N3QdWET7bdmRiAT+tG+jcEak/IGXnThITJIVXzfWUt3a62VH+9LIjCbohVbBodkRcatRIjoJe6cSzVEQeRkr1i1pNKcCoyECwd/KE+qyY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a "void *kernel_data" member in "struct acomp_req":

  @kernel_data:  Private API kernel code data for kernel users

This allows kernel modules such as zswap and zram to input driver data
without interfering with existing usage of acomp_req->base.data.

Since acomp_request_set_params() is the main interface for kernel users
to initialize the acomp_req members, this routine sets
acomp_req->kernel_data to NULL. Kernel users such as zswap will need to
explicitly set acomp_req->kernel_data for interacting with
crypto_acomp_[de]compress(). This usage model will be covered in a
separate patch-series.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d7..0312322d2ca03 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @kernel_data:  Private API kernel code data for kernel users
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -95,6 +96,7 @@ struct acomp_req {
 	unsigned int slen;
 	unsigned int dlen;
 
+	void *kernel_data;
 	struct acomp_req_chain chain;
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
@@ -354,6 +356,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->dst = dst;
 	req->slen = slen;
 	req->dlen = dlen;
+	req->kernel_data = NULL;
 
 	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
 			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
-- 
2.27.0


