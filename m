Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B472C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890726B00A6; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB736B00A9; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C056B00AB; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB836B00A8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF01B1A0E5F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
X-FDA: 83726928558.01.B0D5A86
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC3DA140005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Js1HyjGS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023018; a=rsa-sha256;
	cv=none;
	b=wPomtmvDVHGUnT9MB0MqO08xDz8TYNxeosBPzgq9igZ77WDz1+sKi74hvGKAlFzdQsuMco
	wcfm3DaSgvpamMvc/I4P3c3ow+pTSe52zpik8C+uTyF121gNaOyyw4ufObx3Trj2BrGjVS
	wX8rUEDY4ce191DzAc2ZoMNmUkhbDio=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Js1HyjGS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIj3+IiNfASghi4Hj+cRUleEdbHVozYkf/lKuK+WNoQ=;
	b=hSoPfu4ygGW0YeqHh2V+XRRk1rLl8wiCDbOEXnTpkCYWmfic+peNfIJW1cnIOjnkjVZGs4
	iqA6HJLPrdc9SBPlIlFHYDBpQ4bDYw1ZPQWNG1Xt5+nCCB27rYkau75KpF4+9xgqftpF+h
	Gzm4RD+V3EOvJlSAGT26Hteum+8rcKA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023018; x=1785559018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fq7MZDilO7lVu2uGsJJOhXsPqwASyKUR4bW+bt5RQZY=;
  b=Js1HyjGSCwQGZEyvalb33qCCYbqeV8GBXu+PSFtgSWYW1epJNGsFQc2A
   aW1P1RMakdpBVhHX18I6OVBMyE9A+tf6tWFIubLWRuYQzC0bOR9oxv/A4
   FtycTY6u8HXNB+vqdU35CuFvMArFUHgfGYDjC1CrGRob2NO7iNRdyAISY
   gDQp/1+H5Aha4AtVtMglJMjFLEye9xz+LqFgTf3+MMvwZGkKwAbPXBhDE
   1QMkJa1+t0PSHmSo+enXc50tvJL6R2vZhDHfiMOdMGNCt0MCWqPowfC8X
   yXCzYbgqlhmQdgizh+Ph1kYsYWrKCZMj163EzH248TF8rW4nn+KGIZHJm
   g==;
X-CSE-ConnectionGUID: eWUFXRhxSHGPgbbm2CBSGg==
X-CSE-MsgGUID: /qVZEimWTpeb0n8CC21d+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820363"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820363"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: sWNWH++YRqaYINahgw30bg==
X-CSE-MsgGUID: Ue9PT1sCTl6theBYfA0qxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796293"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 17/24] crypto: iaa - Add deflate-iaa-dynamic compression mode.
Date: Thu, 31 Jul 2025 21:36:35 -0700
Message-Id: <20250801043642.8103-18-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC3DA140005
X-Stat-Signature: ehywohrcjiwpnfu8ee977jyyrtsxegyi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023017-853630
X-HE-Meta: U2FsdGVkX1+WesK4n5Lo+GTRnNAWFRF7aekYpJ1myO7KtrwoR1kp/ffe8aiciUzaA0orFWfUjJpyWIpYjh1Qs28XTnWwMERn8LOcm+XVmyym3khpceO1gPmOmSfiiq4onMb2Da1qYSTKeWvprobEDTx5BaZDm2CrGoFXi1KSq00WqnWyb3ftvDDWkhE59EiNRV2m+Kjp4UdxtaTOH+wBkJk/iMgB26gepMCsFyFYGpv132NWhclcefg2AT3udswUPytwcRPFUcN8J+e1RXtA5FlCdPvJ+SByR/DLJQISUMp6U+KyqWkQxNllcGbqFsB7LtBOdOGg5qJiOgmI/L9Ee6RgCS2HxI1EA9SDrqsyUkPkYpwFt13v0XcJWr8AvEzUoTC72QoTpgxMyvKBK0b8BG4QNg9zL7T4uAM7OIKyDEEe3XtVsFBwyidg8Sgryrb2Y7pQ3z/K24zdERz+4j4QJqcdmuvB2jwrRaiNHNMvyxF5XXSOCjPYeq0Ij/2fUXhH4gewHB09iakLzpZh0y/aS/iW11uHWsM0W4dCUvjUpy5K0SVybHNsYcNpwyHNCob/Wl8naJfhBpnbVxWgFgWqnnr9V6R6eVo0MglEHRdKXfgdl98KqEdeXk61L9j1xoKwDKYqjkh8t1uSVo31NA6/g1BRWNqPDia4tr2YFa1KgtKpvfcTw8dNM9wSDqyjpuE0GJLhCCk3I+lWlaWFE3qaX3dZa+4xdbuBRptOO4uL7WGN8vc2bXD3H4bIgnxVYrR6lAGUqt8xtiao1pmvCdorKlqIcFoGLkjrjcGHQ0SZckSatg23TMF3U31lqtclgE8WKAKKaOYI4nMhTcpDWViNEeoijAVPajE7kKbC/KnEdC6dgH+yQNealMvfL6lI7fcB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some versions of Intel IAA support dynamic compression where the hardware
dynamically computes the Huffman tables and generates a Deflate header
if the input size is no larger than 4KB. This patch will use IAA for
dynamic compression if an appropriate IAA is present and the input size is
not too big. If an IAA is not present, the algorithm will not
be available. Otherwise, if the size of the input is greater than
PAGE_SIZE, zlib is used to do the compression. If the algorithm is
selected, IAA will be used for decompression. If the compressed stream
contains a reference whose distance is greater than 4KB, hardware
decompression will fail, and the decompression will be done with zlib.

Intel IAA dynamic compression results in a compression ratio that is
better than or equal to the currently supported "fixed" compression mode
on the same data set. Compressing a data set of 4300 4KB pages sampled
from SPEC CPU17 workloads produces a compression ratio of 3.14 for IAA
dynamic compression and 2.69 for IAA fixed compression.

If an appropriate IAA exists, dynamic mode can be chosen as the IAA
compression mode by selecting the corresponding algorithm.

For example, to use IAA dynamic mode in zswap:

      echo deflate-iaa-dynamic > /sys/module/zswap/parameters/compressor

This patch also adds a deflate_generic_compress() fallback when dynamic
mode is selected and the input size is over 4KB; along with stats
support that will count these software fallback calls as
"total_sw_comp_calls" in the driver's global_stats.

Furthermore, we define IAA_DYN_ALLOC_DESC_COMP_TIMEOUT as 2000 for
dynamic mode compression on Granite Rapids.

Signed-off-by: Andre Glover <andre.glover@linux.intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 .../driver-api/crypto/iaa/iaa-crypto.rst      | 21 ++++
 crypto/testmgr.c                              | 10 ++
 crypto/testmgr.h                              | 74 ++++++++++++++
 drivers/crypto/intel/iaa/Makefile             |  2 +-
 drivers/crypto/intel/iaa/iaa_crypto.h         |  5 +
 .../intel/iaa/iaa_crypto_comp_dynamic.c       | 22 +++++
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 98 +++++++++++++++++--
 drivers/crypto/intel/iaa/iaa_crypto_stats.c   |  8 ++
 drivers/crypto/intel/iaa/iaa_crypto_stats.h   |  2 +
 include/linux/iaa_comp.h                      |  5 +-
 10 files changed, 236 insertions(+), 11 deletions(-)
 create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 9d2f3f895bdd8..5632c5072a90e 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -33,6 +33,8 @@ compresses and decompresses.
 Currently, there is only one compression modes available, 'fixed'
 mode.
 
+'dynamic' mode is available on certain generations of IAA hardware.
+
 The 'fixed' compression mode implements the compression scheme
 specified by RFC 1951 and is given the crypto algorithm name
 'deflate-iaa'.  (Because the IAA hardware has a 4k history-window
@@ -43,6 +45,25 @@ the IAA fixed mode deflate algorithm is given its own algorithm name
 rather than simply 'deflate').
 
 
+The 'dynamic' compression mode implements a compression scheme where
+the IAA hardware will internally do one pass through the data, compute the
+Huffman tables and generate a Deflate header, then automatically do a
+second pass through the data, generating the final compressed output. IAA
+dynamic compression can be used if an appropriate IAA is present and the
+input size is not too big.  If an appropriate IAA is not present, the
+algorithm will not be available. Otherwise, if the size of the input is too
+big, zlib is used to do the compression. If the algorithm is selected,
+IAA will be used for decompression. If the compressed stream contains a
+reference whose distance is greater than 4KB, hardware decompression will
+fail, and the decompression will be done with zlib. If an appropriate IAA
+exists, 'dynamic' compression, it is implemented by the
+'deflate-iaa-dynamic' crypto algorithm.
+
+A zswap device can select the IAA 'dynamic' mode represented by
+selecting the 'deflate-iaa-dynamic' crypto compression algorithm::
+
+  # echo deflate-iaa-dynamic> /sys/module/zswap/parameters/compressor
+
 Config options and other setup
 ==============================
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 32f753d6c4302..36ae7a8b42860 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4703,6 +4703,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.decomp = __VECS(deflate_decomp_tv_template)
 			}
 		}
+	}, {
+		.alg = "deflate-iaa-dynamic",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = __VECS(deflate_iaa_dynamic_comp_tv_template),
+				.decomp = __VECS(deflate_iaa_dynamic_decomp_tv_template)
+			}
+		}
 	}, {
 		.alg = "dh",
 		.test = alg_test_kpp,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 32d099ac9e737..42db2399013eb 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -34575,6 +34575,80 @@ static const struct comp_testvec deflate_decomp_tv_template[] = {
 	},
 };
 
+static const struct comp_testvec deflate_iaa_dynamic_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 46,
+		.input	= "Join us now and share the software "
+			"Join us now and share the software ",
+		.output = "\x85\xca\xc1\x09\x00\x20\x08\x05"
+			  "\xd0\x55\xfe\x3c\x6e\x21\x64\xd8"
+			  "\x45\x21\x0d\xd7\xb7\x26\xe8\xf8"
+			  "\xe0\x91\x2f\xc3\x09\x98\x17\xd8"
+			  "\x06\x42\x79\x0b\x52\x05\xe1\x33"
+			  "\xeb\x81\x3e\xe5\xa2\x01",
+	}, {
+		.inlen	= 191,
+		.outlen	= 121,
+		.input	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+		.output = "\x5d\x8d\xc1\x0d\xc2\x30\x10\x04"
+			  "\x5b\xd9\x0a\xd2\x03\x82\x20\x21"
+			  "\xf1\xf0\x23\x0d\x5c\xec\x0b\xb6"
+			  "\x64\xfb\x2c\xdf\xf1\xa0\x7b\x12"
+			  "\x3e\x58\x79\xae\x76\x67\x76\x89"
+			  "\x49\x11\xc4\xbf\x0b\x57\x43\x60"
+			  "\xf5\x3d\xad\xac\x20\x78\x29\xad"
+			  "\xb3\x6a\x92\x8a\xc2\x16\x25\x60"
+			  "\x25\xe5\x80\x3d\x5b\x64\xdc\xe6"
+			  "\xfb\xf3\xb2\xcc\xe3\x8c\xf2\x4b"
+			  "\x7a\xb2\x58\x26\xe0\x2c\xde\x52"
+			  "\xdd\xb5\x07\x48\xad\xe5\xe4\xc9"
+			  "\x0e\x42\xb6\xd1\xf5\x17\xc0\xe4"
+			  "\x57\x3c\x1c\x1c\x7d\xb2\x50\xc0"
+			  "\x75\x38\x72\x5d\x4c\xbc\xe4\xe9"
+			  "\x0b",
+	},
+};
+
+static const struct comp_testvec deflate_iaa_dynamic_decomp_tv_template[] = {
+	{
+		.inlen	= 121,
+		.outlen	= 191,
+		.input	= "\x5d\x8d\xc1\x0d\xc2\x30\x10\x04"
+			  "\x5b\xd9\x0a\xd2\x03\x82\x20\x21"
+			  "\xf1\xf0\x23\x0d\x5c\xec\x0b\xb6"
+			  "\x64\xfb\x2c\xdf\xf1\xa0\x7b\x12"
+			  "\x3e\x58\x79\xae\x76\x67\x76\x89"
+			  "\x49\x11\xc4\xbf\x0b\x57\x43\x60"
+			  "\xf5\x3d\xad\xac\x20\x78\x29\xad"
+			  "\xb3\x6a\x92\x8a\xc2\x16\x25\x60"
+			  "\x25\xe5\x80\x3d\x5b\x64\xdc\xe6"
+			  "\xfb\xf3\xb2\xcc\xe3\x8c\xf2\x4b"
+			  "\x7a\xb2\x58\x26\xe0\x2c\xde\x52"
+			  "\xdd\xb5\x07\x48\xad\xe5\xe4\xc9"
+			  "\x0e\x42\xb6\xd1\xf5\x17\xc0\xe4"
+			  "\x57\x3c\x1c\x1c\x7d\xb2\x50\xc0"
+			  "\x75\x38\x72\x5d\x4c\xbc\xe4\xe9"
+			  "\x0b",
+		.output	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+	}, {
+		.inlen	= 46,
+		.outlen	= 70,
+		.input	= "\x85\xca\xc1\x09\x00\x20\x08\x05"
+			  "\xd0\x55\xfe\x3c\x6e\x21\x64\xd8"
+			  "\x45\x21\x0d\xd7\xb7\x26\xe8\xf8"
+			  "\xe0\x91\x2f\xc3\x09\x98\x17\xd8"
+			  "\x06\x42\x79\x0b\x52\x05\xe1\x33"
+			  "\xeb\x81\x3e\xe5\xa2\x01",
+		.output	= "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
 /*
  * LZO test vectors (null-terminated strings).
  */
diff --git a/drivers/crypto/intel/iaa/Makefile b/drivers/crypto/intel/iaa/Makefile
index ebfa1a425f808..96f22cd39924a 100644
--- a/drivers/crypto/intel/iaa/Makefile
+++ b/drivers/crypto/intel/iaa/Makefile
@@ -7,6 +7,6 @@ ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_
 
 obj-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO) := iaa_crypto.o
 
-iaa_crypto-y := iaa_crypto_main.o iaa_crypto_comp_fixed.o
+iaa_crypto-y := iaa_crypto_main.o iaa_crypto_comp_fixed.o iaa_crypto_comp_dynamic.o
 
 iaa_crypto-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO_STATS) += iaa_crypto_stats.o
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 3086bf18126e5..60c96a83e0ae4 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -19,12 +19,15 @@
 
 #define IAA_COMP_FLUSH_OUTPUT		BIT(1)
 #define IAA_COMP_APPEND_EOB		BIT(2)
+#define IAA_COMP_GEN_HDR_1_PASS		(BIT(12) | BIT(13))
 
 #define IAA_COMPLETION_TIMEOUT		1000000
 
 #define IAA_ALLOC_DESC_COMP_TIMEOUT	   1000
 #define IAA_ALLOC_DESC_DECOMP_TIMEOUT	    500
 
+#define IAA_DYN_ALLOC_DESC_COMP_TIMEOUT	   2000
+
 #define IAA_ANALYTICS_ERROR		0x0a
 #define IAA_ERROR_DECOMP_BUF_OVERFLOW	0x0b
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
@@ -133,6 +136,8 @@ struct aecs_comp_table_record {
 
 int iaa_aecs_init_fixed(void);
 void iaa_aecs_cleanup_fixed(void);
+int iaa_aecs_init_dynamic(void);
+void iaa_aecs_cleanup_dynamic(void);
 
 typedef int (*iaa_dev_comp_init_fn_t) (struct iaa_device_compression_mode *mode);
 typedef int (*iaa_dev_comp_free_fn_t) (struct iaa_device_compression_mode *mode);
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c b/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
new file mode 100644
index 0000000000000..3a93d79134431
--- /dev/null
+++ b/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Intel Corporation. All rights rsvd. */
+
+#include "idxd.h"
+#include "iaa_crypto.h"
+
+int iaa_aecs_init_dynamic(void)
+{
+	int ret;
+
+	ret = add_iaa_compression_mode("dynamic", NULL, 0, NULL, 0, NULL, NULL);
+
+	if (!ret)
+		pr_debug("IAA dynamic compression mode initialized\n");
+
+	return ret;
+}
+
+void iaa_aecs_cleanup_dynamic(void)
+{
+	remove_iaa_compression_mode("dynamic");
+}
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 2f25e02ca0aa3..480e12c1d77a5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -102,10 +102,12 @@ DEFINE_MUTEX(first_wq_found_lock);
 
 const char *iaa_compression_mode_names[IAA_COMP_MODES_MAX] = {
 	"fixed",
+	"dynamic",
 };
 
 const char *iaa_compression_alg_names[IAA_COMP_MODES_MAX] = {
 	"deflate-iaa",
+	"deflate-iaa-dynamic",
 };
 
 static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
@@ -1482,6 +1484,23 @@ static int deflate_generic_decompress(struct iaa_req *req)
 	return ret;
 }
 
+static int deflate_generic_compress(struct iaa_req *req)
+{
+	ACOMP_REQUEST_ON_STACK(fbreq, deflate_crypto_acomp);
+	int ret;
+
+	acomp_request_set_callback(fbreq, 0, NULL, NULL);
+	acomp_request_set_params(fbreq, req->src, req->dst, req->slen,
+				 PAGE_SIZE);
+
+	ret = crypto_acomp_compress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	update_total_sw_comp_calls();
+
+	return ret;
+}
+
 static __always_inline void acomp_to_iaa(struct acomp_req *areq,
 					 struct iaa_req *req,
 					 struct iaa_compression_ctx *ctx)
@@ -1807,9 +1826,13 @@ iaa_setup_compress_hw_desc(struct idxd_desc *idxd_desc,
 	desc->src1_size = slen;
 	desc->dst_addr = (u64)dst_addr;
 	desc->max_dst_size = dlen;
-	desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
-	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
-	desc->src2_size = sizeof(struct aecs_comp_table_record);
+	if (mode == IAA_MODE_DYNAMIC) {
+		desc->compr_flags |= IAA_COMP_GEN_HDR_1_PASS;
+	} else {
+		desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
+		desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
+		desc->src2_size = sizeof(struct aecs_comp_table_record);
+	}
 	desc->completion_addr = idxd_desc->compl_dma;
 
 	return desc;
@@ -2063,6 +2086,9 @@ static int iaa_comp_acompress(struct iaa_compression_ctx *ctx, struct iaa_req *r
 		return -EINVAL;
 	}
 
+	if (ctx->mode == IAA_MODE_DYNAMIC && req->slen > PAGE_SIZE)
+		return deflate_generic_compress(req);
+
 	cpu = get_cpu();
 	wq = comp_wq_table_next_wq(cpu);
 	put_cpu();
@@ -2539,7 +2565,9 @@ static int iaa_comp_adecompress_batch(
 static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
 	ctx->mode = mode;
-	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
+	ctx->alloc_comp_desc_timeout = (mode == IAA_MODE_DYNAMIC ?
+					IAA_DYN_ALLOC_DESC_COMP_TIMEOUT :
+					IAA_ALLOC_DESC_COMP_TIMEOUT);
 	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
 	ctx->async_mode = async_mode;
@@ -2768,6 +2796,30 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	}
 };
 
+static int iaa_comp_init_dynamic(struct crypto_acomp *acomp_tfm)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
+	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx = iaa_ctx[IAA_MODE_DYNAMIC];
+
+	return 0;
+}
+
+static struct acomp_alg iaa_acomp_dynamic_deflate = {
+	.init			= iaa_comp_init_dynamic,
+	.compress		= iaa_comp_acompress_main,
+	.decompress		= iaa_comp_adecompress_main,
+	.base			= {
+		.cra_name		= "deflate",
+		.cra_driver_name	= "deflate-iaa-dynamic",
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
+		.cra_module		= THIS_MODULE,
+		.cra_priority		= IAA_ALG_PRIORITY + 1,
+	}
+};
+
 /*******************************************
  * Implement idxd_device_driver interfaces.
  *******************************************/
@@ -2787,7 +2839,7 @@ static void iaa_unregister_compression_device(void)
 	num_iaa_modes_registered = 0;
 }
 
-static int iaa_register_compression_device(void)
+static int iaa_register_compression_device(struct idxd_device *idxd)
 {
 	struct iaa_compression_mode *mode;
 	int i, idx;
@@ -2796,6 +2848,13 @@ static int iaa_register_compression_device(void)
 		iaa_mode_registered[i] = false;
 		mode = find_iaa_compression_mode(iaa_compression_mode_names[i], &idx);
 		if (mode) {
+			/* Header Generation Capability is required for the dynamic algorithm. */
+			if ((!strcmp(mode->name, "dynamic")) && !idxd->hw.iaa_cap.header_gen) {
+				if (num_iaa_modes_registered > 0)
+					--num_iaa_modes_registered;
+				continue;
+			}
+
 			iaa_ctx[i] = kmalloc(sizeof(struct iaa_compression_ctx), GFP_KERNEL);
 			if (!iaa_ctx[i])
 				goto err;
@@ -2813,7 +2872,7 @@ static int iaa_register_compression_device(void)
 	return -ENODEV;
 }
 
-static int iaa_register_acomp_compression_device(void)
+static int iaa_register_acomp_compression_device(struct idxd_device *idxd)
 {
 	int ret = -ENOMEM;
 
@@ -2827,8 +2886,19 @@ static int iaa_register_acomp_compression_device(void)
 		goto err_fixed;
 	}
 
+	if (iaa_mode_registered[IAA_MODE_DYNAMIC]) {
+		ret = crypto_register_acomp(&iaa_acomp_dynamic_deflate);
+		if (ret) {
+			pr_err("deflate algorithm acomp dynamic registration failed (%d)\n", ret);
+			goto err_dynamic;
+		}
+	}
+
 	return 0;
 
+err_dynamic:
+	crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
+
 err_fixed:
 	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
 		crypto_free_acomp(deflate_crypto_acomp);
@@ -2847,6 +2917,9 @@ static void iaa_unregister_acomp_compression_device(void)
 	if (iaa_mode_registered[IAA_MODE_FIXED])
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
 
+	if (iaa_mode_registered[IAA_MODE_DYNAMIC])
+		crypto_unregister_acomp(&iaa_acomp_dynamic_deflate);
+
 	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
 		crypto_free_acomp(deflate_crypto_acomp);
 		deflate_crypto_acomp = NULL;
@@ -2914,13 +2987,13 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	atomic_set(&iaa_crypto_enabled, 1);
 
 	if (first_wq) {
-		ret = iaa_register_compression_device();
+		ret = iaa_register_compression_device(idxd);
 		if (ret != 0) {
 			dev_dbg(dev, "IAA compression device registration failed\n");
 			goto err_register;
 		}
 
-		ret = iaa_register_acomp_compression_device();
+		ret = iaa_register_acomp_compression_device(idxd);
 		if (ret != 0) {
 			dev_dbg(dev, "IAA compression device acomp registration failed\n");
 			goto err_register;
@@ -3071,6 +3144,12 @@ static int __init iaa_crypto_init_module(void)
 		goto err_aecs_init;
 	}
 
+	ret = iaa_aecs_init_dynamic();
+	if (ret < 0) {
+		pr_debug("IAA dynamic compression mode init failed\n");
+		goto err_dynamic;
+	}
+
 	ret = idxd_driver_register(&iaa_crypto_driver);
 	if (ret) {
 		pr_debug("IAA wq sub-driver registration failed\n");
@@ -3168,6 +3247,8 @@ static int __init iaa_crypto_init_module(void)
 err_g_comp_wqs_per_iaa_attr_create:
 	idxd_driver_unregister(&iaa_crypto_driver);
 err_driver_reg:
+	iaa_aecs_cleanup_dynamic();
+err_dynamic:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
 
@@ -3192,6 +3273,7 @@ static void __exit iaa_crypto_cleanup_module(void)
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_g_comp_wqs_per_iaa);
 	idxd_driver_unregister(&iaa_crypto_driver);
+	iaa_aecs_cleanup_dynamic();
 	iaa_aecs_cleanup_fixed();
 
 	pr_debug("cleaned up\n");
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.c b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
index f5cc3d29ca19e..42aae8a738ac1 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
@@ -19,6 +19,7 @@
 
 static atomic64_t total_comp_calls;
 static atomic64_t total_decomp_calls;
+static atomic64_t total_sw_comp_calls;
 static atomic64_t total_sw_decomp_calls;
 static atomic64_t total_comp_bytes_out;
 static atomic64_t total_decomp_bytes_in;
@@ -43,6 +44,11 @@ void update_total_decomp_calls(void)
 	atomic64_inc(&total_decomp_calls);
 }
 
+void update_total_sw_comp_calls(void)
+{
+	atomic64_inc(&total_sw_comp_calls);
+}
+
 void update_total_sw_decomp_calls(void)
 {
 	atomic64_inc(&total_sw_decomp_calls);
@@ -174,6 +180,8 @@ static int global_stats_show(struct seq_file *m, void *v)
 		   atomic64_read(&total_comp_calls));
 	seq_printf(m, "  total_decomp_calls: %llu\n",
 		   atomic64_read(&total_decomp_calls));
+	seq_printf(m, "  total_sw_comp_calls: %llu\n",
+		   atomic64_read(&total_sw_comp_calls));
 	seq_printf(m, "  total_sw_decomp_calls: %llu\n",
 		   atomic64_read(&total_sw_decomp_calls));
 	seq_printf(m, "  total_comp_bytes_out: %llu\n",
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.h b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
index 3787a5f507eb2..6e0c6f9939bfa 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
@@ -11,6 +11,7 @@ void	iaa_crypto_debugfs_cleanup(void);
 void	update_total_comp_calls(void);
 void	update_total_comp_bytes_out(int n);
 void	update_total_decomp_calls(void);
+void	update_total_sw_comp_calls(void);
 void	update_total_sw_decomp_calls(void);
 void	update_total_decomp_bytes_in(int n);
 void	update_completion_einval_errs(void);
@@ -29,6 +30,7 @@ static inline void	iaa_crypto_debugfs_cleanup(void) {}
 static inline void	update_total_comp_calls(void) {}
 static inline void	update_total_comp_bytes_out(int n) {}
 static inline void	update_total_decomp_calls(void) {}
+static inline void	update_total_sw_comp_calls(void) {}
 static inline void	update_total_sw_decomp_calls(void) {}
 static inline void	update_total_decomp_bytes_in(int n) {}
 static inline void	update_completion_einval_errs(void) {}
diff --git a/include/linux/iaa_comp.h b/include/linux/iaa_comp.h
index cbd78f83668d5..97d08702a8ca4 100644
--- a/include/linux/iaa_comp.h
+++ b/include/linux/iaa_comp.h
@@ -12,7 +12,8 @@
 
 enum iaa_mode {
 	IAA_MODE_FIXED = 0,
-	IAA_MODE_NONE = 1,
+	IAA_MODE_DYNAMIC = 1,
+	IAA_MODE_NONE = 2,
 };
 
 struct iaa_req {
@@ -84,7 +85,7 @@ extern int iaa_comp_decompress_batch(
 #else /* CONFIG_CRYPTO_DEV_IAA_CRYPTO */
 
 enum iaa_mode {
-	IAA_MODE_NONE = 1,
+	IAA_MODE_NONE = 2,
 };
 
 struct iaa_req {};
-- 
2.27.0


