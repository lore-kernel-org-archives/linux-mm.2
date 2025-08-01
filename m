Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31666C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33406B009E; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD886B009F; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83FB6B00A0; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5AA56B009E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 672E11DD886
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
X-FDA: 83726928390.12.6B54EFC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2BE2F40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lLH5evt3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQasQmY+lijLbqdhEydtIK56oYAjQrrNI/6fQhlxvjI=;
	b=PmbJqZNIQoS3qhPbVseyvIspURhzLI8J7wYK4PIVUGJv3BlgY1InR4OVhiwVkLoSNTdhK0
	zULCU8cXGAjyZTuJNI6/yzSciekZpYFql6av42uvVmQZ5oCEoVLgYnH5v6RgfEzQx0De6r
	SfxlTV+MedQtkrtvXr6t2Baj4OLZb0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023013; a=rsa-sha256;
	cv=none;
	b=XdZrYyPKKLDGHbqtXMu9kno3XNaZDS9sCgA3T+aHmrHMjFxkdijqkliHzCcL9J7oczUCjV
	EPLEOw1GglK06Zs7y7oVUFOXoLcMZkd7BLRxx/IXXv8G0VQYKt+DUeGTOsZ828mScyOqbo
	+0DTFmn2Gy6/LbNQvmqET4Ue5smcwkQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lLH5evt3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023013; x=1785559013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k8pd/3MTSN/7vkQpkMIbnuQbRgRw0twoX8zW3WQAXxc=;
  b=lLH5evt352X2ctJxibnon5wYOLlrd3H/TTBEBB9gO5IlnwF1f+ykguDm
   WnQThHzruKNVYVhqPrqHFOcqDcktc5RjL+e2r0govsrQbdNPnLPYKTozx
   u314/VLEz1skC3dBIxf0C+yaG4mS8fNLl8z+7DtyU7oE+LCv1XA1c2DoC
   bpx/dpEOnwYQzyHpzcx5LxoFqqNlJecjaNd/sufFgFUcNEDJheVSgFaE8
   Nqsovk3cPGi92rPIb90PmRFFYdDeWSMalZ+Iqm9s19+IBQ3sDIJWzgXug
   td/HoCv9xGb3xqCUwfkIUM6+tMScqEaTiF/YrLmwoEm/pZVJ3m4dEDncQ
   g==;
X-CSE-ConnectionGUID: 52PGz6nYTnGpHcq/QR402g==
X-CSE-MsgGUID: PVa2QWGYTKidqkB3CJosDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820265"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820265"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:45 -0700
X-CSE-ConnectionGUID: YHno+N/fQiKg+1zn3UjFpQ==
X-CSE-MsgGUID: 05jUf3pHTVSu9p2fm6Bo5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796258"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:44 -0700
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
Subject: [PATCH v11 10/24] crypto: iaa - Rearchitect the iaa_crypto driver to be usable by zswap and zram.
Date: Thu, 31 Jul 2025 21:36:28 -0700
Message-Id: <20250801043642.8103-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2BE2F40002
X-Stat-Signature: qwryghnj81oux3pym6z5m4b1isdt55dd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023013-149299
X-HE-Meta: U2FsdGVkX19ogbFSR8OF0fjawdpcqYmCHNY92MdZZWkOqWBBlnHGj7KqASeiw2zryjj/K7OGFeH+zhsNJbf/HBLNFHuALLSGmEUh6pmq0WoL3Qpvj9XY8Be0dq0/CD44nSmdUyErHGrl996rySfGCbnVNPkplBieVWAwypOIOSPbVU8yjrln90mtDW5jNZkUgzmMVelxC2n8Ntw5RVPG1rwXsMhlLnaD5AcmodkVLb0m+NsipHsxGg3zX/EUqsEsZQOvhIXIsCVWxk3pcX81QiOvVp3g+vRseVcg4ezlh38dIkquYndDTuf/14th8ytK8YX1srPZCs+NKx0aY2OdZZgQ7wQ7SGHM3sYsDCBGqCpPqVpTH0Jap72MgT1o/HDlIdCWDoAwEvQCuBQmZyWAOD0W4HffkBHEE9Sj7z2z/uR9vXAy/lqXWl9JeZTLo2X1pAKoyhRF84Cca1Y8ZkLXthrPWdPgIVcMunD2OE7W4+Zdddp/X8gIveON1oury8TMGX9iwQCCQVsjHl2lCEZrGhwJwI2RtwQEoIjxr5y1gp6/hu22tqubndMxYlJdFEHxNo6F/9LqcUHpNMhtTK+fePvDi/LQ/iVeulgJYs/B6fIXOvgNuszWW6adkJ4Hlr2tF7yy/nuOJW5Q3o/vSeeP+0j+FobOMV4yk/w2jFBobi+goDZtAuu44quMlQvSg9lpxKpsD9MkfB/J39ySGjEzsFRpap8jHB2d4lpX00SHZXG+BFJBAmcPdJw9bYCUyYXtqvtEZBbuhhpL0ITcl3aw7psTm/AujK8ZV9wnLR2BvcB1mI1m47AZrK4ANPyFH+DHrI21wC+m1KeE48RcmTMYdowZJRcfszYHnHBrH3pZWaGH9XknNFEmMZJ7cJtBU1OVoSU9ZMCrI2Z1VK/Wh44itAPOfyywtoqUm1ZU/K1TiRhMJotrn+CwQMQYXAExzQA+8f5gAKxlX3Kpi2JFwTK
 rylNYZYk
 6yTqpyt3dTAh4X6WgwuJ9DFem1DYr8fGQBd/o+6HWPNaUe82epk/P6KILVHT5cc72BE1LphlVdxzjYxDoDWZZ3puX1/bopaCkZBAUhgGb1zWaQisFUGB8ifWPCa3tW8h7SyE6hgAkMEifeLM9V+ESS3q5DRU8vyNWV5/hp7Uwv3fBzppH++TmsZbS9QKvEblx7mugBWPxxc3MC9+7QAiDswbqdXxxUlSZiaj8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch rearchitects the iaa_crypto driver to be usable by
non-crypto_acomp kernel users such as zram. The crypto_acomp interface
is also preserved for use by zswap. The core driver code is moved under
a crypto_acomp-agnostic layer that relies only on idxd, dma and
scatterlist.

Additionally, this patch resolves a race condition triggered when
IAA wqs and devices are continuously disabled/enabled when workloads are
using IAA for compression/decompression. This commit, in combination
with patches 0002 ("crypto: iaa - New architecture for IAA device WQ
comp/decomp usage & core mapping.) and 0005 (crypto: iaa - iaa_wq uses
percpu_refs for get/put reference counting.) in this series fix the race
condition. This has been verified using bisecting.

The newly added include/linux/iaa_comp.h provides the data structures
and API for use by non-crypto_acomp kernel code such as zram.

This allows kernel users i.e., zswap and zram, to use IAA's hardware
acceleration for compression/decompression without/with crypto_acomp.

Towards this goal, most of the driver code has been made independent of
crypto_acomp, by introducing a new "struct iaa_req" data structure, and
light-weight internal translation routines to/from crypto_acomp, namely,
acomp_to_iaa() and iaa_to_acomp().

The exception is that the driver defines a "static struct crypto_acomp
*deflate_crypto_comp" for the software decompress fall-back
path. Hopefully this shouldn't be an issue for zram because it is
encapsulated within the iaa_crypto driver.

The acomp_alg .compress() and .decompress() interfaces call into
iaa_comp_acompress_main() and iaa_comp_adecompress_main(), which are
wrappers around the core crypto-independent driver functions.

A zram/zcomp backend for iaa_crypto will be submitted as a separate
patch series, using these interfaces from iaa_comp.h:

       int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req);

       int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req);

These iaa_crypto interfaces will continue to be available through
crypto_acomp for use in zswap:

       int crypto_acomp_compress(struct acomp_req *req);
       int crypto_acomp_decompress(struct acomp_req *req);

Some other changes introduced by this commit are:

1) iaa_crypto symbol namespace is changed from "IDXD" to
   "CRYPTO_DEV_IAA_CRYPTO".

2) Some constants and data structures are moved to
   include/linux/iaa_comp.h so as to be usable in developing the zram
   iaa_crypto backend.

Fixes: ea7a5cbb4369 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/Makefile          |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto.h      |   7 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 368 ++++++++++++++++++---
 include/linux/iaa_comp.h                   |  86 +++++
 4 files changed, 403 insertions(+), 60 deletions(-)
 create mode 100644 include/linux/iaa_comp.h

diff --git a/drivers/crypto/intel/iaa/Makefile b/drivers/crypto/intel/iaa/Makefile
index 55bda7770fac7..ebfa1a425f808 100644
--- a/drivers/crypto/intel/iaa/Makefile
+++ b/drivers/crypto/intel/iaa/Makefile
@@ -3,7 +3,7 @@
 # Makefile for IAA crypto device drivers
 #
 
-ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"IDXD"'
+ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_DEV_IAA_CRYPTO"'
 
 obj-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO) := iaa_crypto.o
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 9611f2518f42c..190157967e3ba 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -6,6 +6,7 @@
 
 #include <linux/crypto.h>
 #include <linux/idxd.h>
+#include <linux/iaa_comp.h>
 #include <uapi/linux/idxd.h>
 
 #define IDXD_SUBDRIVER_NAME		"crypto"
@@ -29,8 +30,6 @@
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
 #define IAA_ERROR_WATCHDOG_EXPIRED	0x24
 
-#define IAA_COMP_MODES_MAX		2
-
 #define FIXED_HDR			0x2
 #define FIXED_HDR_SIZE			3
 
@@ -138,10 +137,6 @@ int add_iaa_compression_mode(const char *name,
 
 void remove_iaa_compression_mode(const char *name);
 
-enum iaa_mode {
-	IAA_MODE_FIXED,
-};
-
 struct iaa_compression_ctx {
 	enum iaa_mode	mode;
 	u16		alloc_comp_desc_timeout;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 182c41816a97c..fad0a9274a2de 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -11,6 +11,7 @@
 #include <linux/highmem.h>
 #include <linux/sched/smt.h>
 #include <crypto/internal/acompress.h>
+#include <linux/iaa_comp.h>
 
 #include "idxd.h"
 #include "iaa_crypto.h"
@@ -51,6 +52,9 @@ static struct wq_table_entry **pkg_global_decomp_wqs;
 /* All comp wqs from IAAs on a package. */
 static struct wq_table_entry **pkg_global_comp_wqs;
 
+/* For software deflate fallback compress/decompress. */
+static struct crypto_acomp *deflate_crypto_acomp;
+
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -93,9 +97,18 @@ static atomic_t iaa_crypto_enabled = ATOMIC_INIT(0);
 static struct idxd_wq *first_wq_found;
 DEFINE_MUTEX(first_wq_found_lock);
 
-static bool iaa_crypto_registered;
+const char *iaa_compression_mode_names[IAA_COMP_MODES_MAX] = {
+	"fixed",
+};
+
+const char *iaa_compression_alg_names[IAA_COMP_MODES_MAX] = {
+	"deflate-iaa",
+};
 
 static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+static struct iaa_compression_ctx *iaa_ctx[IAA_COMP_MODES_MAX];
+static bool iaa_mode_registered[IAA_COMP_MODES_MAX];
+static u8 num_iaa_modes_registered;
 
 /* Distribute decompressions across all IAAs on the package. */
 static bool iaa_distribute_decomps;
@@ -353,6 +366,20 @@ static struct iaa_compression_mode *find_iaa_compression_mode(const char *name,
 	return NULL;
 }
 
+static bool iaa_alg_is_registered(const char *name, int *idx)
+{
+	int i;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		if (!strcmp(name, iaa_compression_alg_names[i]) && iaa_mode_registered[i]) {
+			*idx = i;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void free_iaa_compression_mode(struct iaa_compression_mode *mode)
 {
 	kfree(mode->name);
@@ -466,6 +493,7 @@ int add_iaa_compression_mode(const char *name,
 		 mode->name, idx);
 
 	iaa_compression_modes[idx] = mode;
+	++num_iaa_modes_registered;
 
 	ret = 0;
 out:
@@ -1434,11 +1462,15 @@ static struct idxd_wq *comp_wq_table_next_wq(int cpu)
  * Core iaa_crypto compress/decompress functions.
  *************************************************/
 
-static int deflate_generic_decompress(struct acomp_req *req)
+static int deflate_generic_decompress(struct iaa_req *req)
 {
-	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	ACOMP_REQUEST_ON_STACK(fbreq, deflate_crypto_acomp);
 	int ret;
 
+	acomp_request_set_callback(fbreq, 0, NULL, NULL);
+	acomp_request_set_params(fbreq, req->src, req->dst, req->slen,
+				 PAGE_SIZE);
+
 	ret = crypto_acomp_decompress(fbreq);
 	req->dlen = fbreq->dlen;
 
@@ -1447,6 +1479,24 @@ static int deflate_generic_decompress(struct acomp_req *req)
 	return ret;
 }
 
+static __always_inline void acomp_to_iaa(struct acomp_req *areq,
+					 struct iaa_req *req,
+					 struct iaa_compression_ctx *ctx)
+{
+	req->src = areq->src;
+	req->dst = areq->dst;
+	req->slen = areq->slen;
+	req->dlen = areq->dlen;
+	req->flags = areq->base.flags;
+	if (ctx->use_irq)
+		req->drv_data = areq;
+}
+
+static __always_inline void iaa_to_acomp(struct iaa_req *req, struct acomp_req *areq)
+{
+	areq->dlen = req->dlen;
+}
+
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -1508,7 +1558,7 @@ static inline int check_completion(struct device *dev,
 }
 
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
+				struct iaa_req *req,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr)
 {
 	int ret = 0;
@@ -1547,13 +1597,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 	return ret;
 }
 
-static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_compress_verify(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1606,10 +1654,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	if (*compression_crc != idxd_desc->iax_completion->crc) {
+	if (req->compression_crc != idxd_desc->iax_completion->crc) {
 		ret = -EINVAL;
 		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", *compression_crc,
+			" comp=0x%x, decomp=0x%x\n", req->compression_crc,
 			idxd_desc->iax_completion->crc);
 		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
 			       8, 1, idxd_desc->iax_completion, 64, 0);
@@ -1635,6 +1683,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
 	struct device *dev;
+	struct iaa_req req;
 	int ret, err = 0;
 
 	compression_ctx = crypto_tfm_ctx(ctx->tfm);
@@ -1660,12 +1709,18 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(ctx->req);
+
+			acomp_to_iaa(ctx->req, &req, compression_ctx);
+			ret = deflate_generic_decompress(&req);
+			iaa_to_acomp(&req, ctx->req);
+
 			if (ret) {
 				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
 					__func__, ret);
 				err = -EIO;
 				goto err;
+			} else {
+				goto verify;
 			}
 		} else {
 			err = -EIO;
@@ -1684,21 +1739,26 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		update_wq_decomp_bytes(iaa_wq->wq, ctx->req->slen);
 	}
 
+verify:
 	if (ctx->compress && compression_ctx->verify_compress) {
-		u32 *compression_crc = acomp_request_ctx(ctx->req);
 		dma_addr_t src_addr, dst_addr;
 
-		*compression_crc = idxd_desc->iax_completion->crc;
+		acomp_to_iaa(ctx->req, &req, compression_ctx);
+		req.compression_crc = idxd_desc->iax_completion->crc;
+
+		ret = iaa_remap_for_verify(dev, iaa_wq, &req, &src_addr, &dst_addr);
+		iaa_to_acomp(&req, ctx->req);
 
-		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
 			err = -EIO;
 			goto out;
 		}
 
-		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
+		ret = iaa_compress_verify(compression_ctx, &req, iaa_wq->wq, src_addr,
 					  ctx->req->slen, dst_addr, ctx->req->dlen);
+		iaa_to_acomp(&req, ctx->req);
+
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1794,13 +1854,11 @@ static __always_inline void iaa_submit_desc_movdir64b(struct idxd_wq *wq,
 	iosubmit_cmds512(portal, desc->hw, 1);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1848,17 +1906,18 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		}
 
 		*dlen = idxd_desc->iax_completion->output_size;
+		req->compression_crc = idxd_desc->iax_completion->crc;
 
 		/* Update stats */
 		update_total_comp_bytes_out(*dlen);
 		update_wq_comp_bytes(wq, *dlen);
-
-		*compression_crc = idxd_desc->iax_completion->crc;
 	} else {
+		struct acomp_req *areq = req->drv_data;
+
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
-		idxd_desc->crypto.req = req;
-		idxd_desc->crypto.tfm = tfm;
+		idxd_desc->crypto.req = areq;
+		idxd_desc->crypto.tfm = areq->base.tfm;
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
@@ -1882,12 +1941,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	return ret;
 }
 
-static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
+static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
 	u16 alloc_desc_retries = 0;
@@ -1931,10 +1989,12 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
 	} else {
+		struct acomp_req *areq = req->drv_data;
+
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
-		idxd_desc->crypto.req = req;
-		idxd_desc->crypto.tfm = tfm;
+		idxd_desc->crypto.req = areq;
+		idxd_desc->crypto.tfm = areq->base.tfm;
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
@@ -1985,20 +2045,16 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	return ret;
 }
 
-static int iaa_comp_acompress(struct acomp_req *req)
+static int iaa_comp_acompress(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
-	struct iaa_compression_ctx *compression_ctx;
-	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
 	struct device *dev;
 
-	compression_ctx = crypto_tfm_ctx(tfm);
-
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not compressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid src/dst, not compressing\n");
 		return -EINVAL;
 	}
 
@@ -2034,19 +2090,19 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	dst_addr = sg_dma_address(req->dst);
 
-	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
+	ret = iaa_compress(ctx, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (!ret && compression_ctx->verify_compress) {
+	if (!ret && ctx->verify_compress) {
 		ret = iaa_remap_for_verify(dev, iaa_wq, req, &src_addr, &dst_addr);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
 			goto out;
 		}
 
-		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
+		ret = iaa_compress_verify(ctx, req, wq, src_addr, req->slen,
 					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
@@ -2069,9 +2125,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	return ret;
 }
 
-static int iaa_comp_adecompress(struct acomp_req *req)
+static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
-	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
@@ -2115,7 +2170,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	dst_addr = sg_dma_address(req->dst);
 
-	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
+	ret = iaa_decompress(ctx, req, wq, src_addr, req->slen,
 			     dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
@@ -2132,8 +2187,9 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	return ret;
 }
 
-static void compression_ctx_init(struct iaa_compression_ctx *ctx)
+static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
+	ctx->mode = mode;
 	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
 	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
@@ -2141,26 +2197,164 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 	ctx->use_irq = use_irq;
 }
 
+static __always_inline bool iaa_compressor_enabled(void)
+{
+	return (atomic_read(&iaa_crypto_enabled) && num_iaa_modes_registered);
+}
+
+static __always_inline enum iaa_mode iaa_compressor_is_registered(const char *compressor_name)
+{
+	u8 i;
+
+	if (!atomic_read(&iaa_crypto_enabled) || !num_iaa_modes_registered)
+		return IAA_MODE_NONE;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		if (iaa_mode_registered[i] &&
+		    !strcmp(iaa_compression_alg_names[i], compressor_name))
+			return (enum iaa_mode)i;
+	}
+
+	return IAA_MODE_NONE;
+}
+
+/***********************************************************
+ * Interfaces for non-crypto_acomp kernel users, e.g. zram.
+ ***********************************************************/
+
+__always_inline bool iaa_comp_enabled(void)
+{
+	return iaa_compressor_enabled();
+}
+EXPORT_SYMBOL_GPL(iaa_comp_enabled);
+
+__always_inline enum iaa_mode iaa_comp_get_compressor_mode(const char *compressor_name)
+{
+	return iaa_compressor_is_registered(compressor_name);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_get_compressor_mode);
+
+__always_inline bool iaa_comp_mode_is_registered(enum iaa_mode mode)
+{
+	return iaa_mode_registered[mode];
+}
+EXPORT_SYMBOL_GPL(iaa_comp_mode_is_registered);
+
+void iaa_comp_put_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes, u8 nr_modes)
+{
+	u8 i;
+
+	if (iaa_mode_names) {
+		for (i = 0; i < nr_modes; ++i)
+			kfree(iaa_mode_names[i]);
+		kfree(iaa_mode_names);
+	}
+
+	kfree(iaa_modes);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_put_modes);
+
+u8 iaa_comp_get_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes)
+{
+	u8 i, nr_modes = 0;
+
+	if (!atomic_read(&iaa_crypto_enabled) || !num_iaa_modes_registered)
+		return 0;
+
+	iaa_mode_names = kcalloc(num_iaa_modes_registered, sizeof(char *), GFP_KERNEL);
+	if (!iaa_mode_names)
+		goto err;
+
+	iaa_modes = kcalloc(num_iaa_modes_registered, sizeof(enum iaa_mode), GFP_KERNEL);
+	if (!iaa_modes)
+		goto err;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		if (iaa_mode_registered[i]) {
+			iaa_mode_names[nr_modes] = kzalloc(sizeof(char) * 30, GFP_KERNEL);
+			if (!iaa_mode_names[nr_modes])
+				goto err;
+			strscpy(iaa_mode_names[nr_modes], iaa_compression_alg_names[i],
+				sizeof(iaa_mode_names[nr_modes]));
+			iaa_modes[nr_modes] = (enum iaa_mode)nr_modes;
+			++nr_modes;
+		}
+	}
+
+	return nr_modes;
+
+err:
+	iaa_comp_put_modes(iaa_mode_names, iaa_modes, num_iaa_modes_registered);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iaa_comp_get_modes);
+
+__always_inline int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req)
+{
+	return iaa_comp_acompress(iaa_ctx[mode], req);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_compress);
+
+__always_inline int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req)
+{
+	return iaa_comp_adecompress(iaa_ctx[mode], req);
+}
+EXPORT_SYMBOL_GPL(iaa_comp_decompress);
+
 /*********************************************
  * Interfaces to crypto_alg and crypto_acomp.
  *********************************************/
 
+static __always_inline int iaa_comp_acompress_main(struct acomp_req *areq)
+{
+	struct crypto_tfm *tfm = areq->base.tfm;
+	struct iaa_compression_ctx *ctx;
+	struct iaa_req req;
+	int ret = -ENODEV, idx;
+
+	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
+		ctx = iaa_ctx[idx];
+
+		acomp_to_iaa(areq, &req, ctx);
+		ret = iaa_comp_acompress(ctx, &req);
+		iaa_to_acomp(&req, areq);
+	}
+
+	return ret;
+}
+
+static __always_inline int iaa_comp_adecompress_main(struct acomp_req *areq)
+{
+	struct crypto_tfm *tfm = areq->base.tfm;
+	struct iaa_compression_ctx *ctx;
+	struct iaa_req req;
+	int ret = -ENODEV, idx;
+
+	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
+		ctx = iaa_ctx[idx];
+
+		acomp_to_iaa(areq, &req, ctx);
+		ret = iaa_comp_adecompress(ctx, &req);
+		iaa_to_acomp(&req, areq);
+	}
+
+	return ret;
+}
+
 static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->mode = IAA_MODE_FIXED;
-
-	compression_ctx_init(ctx);
+	ctx = iaa_ctx[IAA_MODE_FIXED];
 
 	return 0;
 }
 
 static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
-	.compress		= iaa_comp_acompress,
-	.decompress		= iaa_comp_adecompress,
+	.compress		= iaa_comp_acompress_main,
+	.decompress		= iaa_comp_adecompress_main,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2172,29 +2366,89 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	}
 };
 
+/*******************************************
+ * Implement idxd_device_driver interfaces.
+ *******************************************/
+
+static void iaa_unregister_compression_device(void)
+{
+	unsigned int i;
+
+	atomic_set(&iaa_crypto_enabled, 0);
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		iaa_mode_registered[i] = false;
+		kfree(iaa_ctx[i]);
+		iaa_ctx[i] = NULL;
+	}
+
+	num_iaa_modes_registered = 0;
+}
+
 static int iaa_register_compression_device(void)
 {
-	int ret;
+	struct iaa_compression_mode *mode;
+	int i, idx;
+
+	for (i = 0; i < IAA_COMP_MODES_MAX; ++i) {
+		iaa_mode_registered[i] = false;
+		mode = find_iaa_compression_mode(iaa_compression_mode_names[i], &idx);
+		if (mode) {
+			iaa_ctx[i] = kmalloc(sizeof(struct iaa_compression_ctx), GFP_KERNEL);
+			if (!iaa_ctx[i])
+				goto err;
+
+			compression_ctx_init(iaa_ctx[i], (enum iaa_mode)i);
+			iaa_mode_registered[i] = true;
+		}
+	}
+
+	BUG_ON(!iaa_mode_registered[IAA_MODE_FIXED]);
+	return 0;
+
+err:
+	iaa_unregister_compression_device();
+	return -ENODEV;
+}
+
+static int iaa_register_acomp_compression_device(void)
+{
+	int ret = -ENOMEM;
+
+	deflate_crypto_acomp = crypto_alloc_acomp("deflate", 0, 0);
+	if (IS_ERR_OR_NULL(deflate_crypto_acomp))
+		goto err_deflate_acomp;
 
 	ret = crypto_register_acomp(&iaa_acomp_fixed_deflate);
 	if (ret) {
 		pr_err("deflate algorithm acomp fixed registration failed (%d)\n", ret);
-		goto out;
+		goto err_fixed;
 	}
 
-	iaa_crypto_registered = true;
-out:
+	return 0;
+
+err_fixed:
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
+
+err_deflate_acomp:
+	iaa_unregister_compression_device();
 	return ret;
 }
 
-static int iaa_unregister_compression_device(void)
+static void iaa_unregister_acomp_compression_device(void)
 {
 	atomic_set(&iaa_crypto_enabled, 0);
 
-	if (iaa_crypto_registered)
+	if (iaa_mode_registered[IAA_MODE_FIXED])
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
 
-	return 0;
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
 }
 
 static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
@@ -2264,6 +2518,12 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 			goto err_register;
 		}
 
+		ret = iaa_register_acomp_compression_device();
+		if (ret != 0) {
+			dev_dbg(dev, "IAA compression device acomp registration failed\n");
+			goto err_register;
+		}
+
 		if (!rebalance_wq_table()) {
 			dev_dbg(dev, "%s: Rerun after registration: IAA rebalancing device wq tables failed\n", __func__);
 			goto err_register;
@@ -2340,6 +2600,8 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 		pkg_global_wqs_dealloc();
 		free_wq_tables();
 		BUG_ON(!list_empty(&iaa_devices));
+		iaa_unregister_acomp_compression_device();
+		iaa_unregister_compression_device();
 		INIT_LIST_HEAD(&iaa_devices);
 		module_put(THIS_MODULE);
 
@@ -2456,8 +2718,8 @@ static int __init iaa_crypto_init_module(void)
 
 static void __exit iaa_crypto_cleanup_module(void)
 {
-	if (iaa_unregister_compression_device())
-		pr_debug("IAA compression device unregister failed\n");
+	iaa_unregister_acomp_compression_device();
+	iaa_unregister_compression_device();
 
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
diff --git a/include/linux/iaa_comp.h b/include/linux/iaa_comp.h
new file mode 100644
index 0000000000000..ec061315f4772
--- /dev/null
+++ b/include/linux/iaa_comp.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2021 Intel Corporation. All rights rsvd. */
+
+#ifndef __IAA_COMP_H__
+#define __IAA_COMP_H__
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_IAA_CRYPTO)
+
+#include <linux/scatterlist.h>
+
+#define IAA_COMP_MODES_MAX  IAA_MODE_NONE
+
+enum iaa_mode {
+	IAA_MODE_FIXED = 0,
+	IAA_MODE_NONE = 1,
+};
+
+struct iaa_req {
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	unsigned int slen;
+	unsigned int dlen;
+	u32 flags;
+	u32 compression_crc;
+	void *drv_data; /* for driver internal use */
+};
+
+extern bool iaa_comp_enabled(void);
+
+extern enum iaa_mode iaa_comp_get_compressor_mode(const char *compressor_name);
+
+extern bool iaa_comp_mode_is_registered(enum iaa_mode mode);
+
+extern u8 iaa_comp_get_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes);
+
+extern void iaa_comp_put_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes, u8 nr_modes);
+
+extern int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req);
+
+extern int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req);
+
+#else /* CONFIG_CRYPTO_DEV_IAA_CRYPTO */
+
+enum iaa_mode {
+	IAA_MODE_NONE = 1,
+};
+
+struct iaa_req {};
+
+static inline bool iaa_comp_enabled(void)
+{
+	return false;
+}
+
+static inline enum iaa_mode iaa_comp_get_compressor_mode(const char *compressor_name)
+{
+	return IAA_MODE_NONE;
+}
+
+static inline bool iaa_comp_mode_is_registered(enum iaa_mode mode)
+{
+	return false;
+}
+
+static inline u8 iaa_comp_get_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes)
+{
+	return 0;
+}
+
+static inline void iaa_comp_put_modes(char **iaa_mode_names, enum iaa_mode *iaa_modes, u8 nr_modes)
+{
+}
+
+static inline int iaa_comp_compress(enum iaa_mode mode, struct iaa_req *req)
+{
+	return -EINVAL;
+}
+
+static inline int iaa_comp_decompress(enum iaa_mode mode, struct iaa_req *req)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_CRYPTO_DEV_IAA_CRYPTO */
+
+#endif
-- 
2.27.0


