Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B51CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB378E0111; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825BA8E010E; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5167B8E0112; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3E18E0111
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED7A44A872
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
X-FDA: 84072359574.24.0F2DA03
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id B7C4E1C000D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Re3BtqlW;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfUOr2xA0IxNa0NyRpwepc2eILb6XeAv76vJz7Mb2ik=;
	b=qh8Ql7B/OtGRy352MV4qJi7af3P+wVr7wVvYHSI7Ym+HtffsYWWz5CKNS2w9YarXyB2TEA
	X+thX8B/tzbUKB26ATIxrnm52epl3A/+iFG+4sS9FiRYL9e713mD9Hn1DD4ZzlEeueNi7M
	vaKsLehkoGQv8XGsZemQa6aOe27DzD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247566; a=rsa-sha256;
	cv=none;
	b=ycBet+lmEHWehCtVZmjgeQx1cr/BXzF0U4c/o6NZkRvCtQai/Df9387bqpnaW1baGYcTxA
	/9qYOq7Q+GL0dv+oSGSamyGitLzqRuDphGduI0TS1BTadIBEioXEfQyQucBqC1VjFLdbdQ
	riWqYib7OCM+n+ONFNQtMhYPZW8ZZjI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Re3BtqlW;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247565; x=1793783565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tfu36l+S/Ni12tERScoXLzx2fxIij7PzhnFOcTPV1ow=;
  b=Re3BtqlWHEFlcxYxo8E4Oef0YMtRMj4r5+OSKXDdSAGyUCf/3Brn1A9/
   Jja2HTrZGt/CJJDUq5khWDmqIwJ3DjJArj25ppK6A6cmuHS4dE0y4ZFcy
   950iZ8xUaPM+gPnloxGcKRABDDfYiN7hkC743lt7fpuFGPzlGkj/i+PI1
   HGumgy5tC3beWS0WoFNh3UMOc8Mtj03TqPNINu6BEqC+eIQFH8tkszPIT
   o2eXzd00+jM1EQE6V9y4EAHVjEOZ106/cQM5zWHKAetJZXW99Rbrdwomv
   lPNru3+MvTxUiiw+eRVZW4HKOVAFDgE1c6BJANrG4iyfxZKIQ+na7hNhJ
   w==;
X-CSE-ConnectionGUID: fh7qJN/fTBWVIpd670Eztw==
X-CSE-MsgGUID: 9kw81qrhTmSlpSz+Mlo7SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265185"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265185"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: +R6ouizKSOyydx5RXCC/tw==
X-CSE-MsgGUID: DTpc8ClMSk6q0q++i+0QGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795808"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 11/22] crypto: iaa - Rearchitect iaa_crypto to have clean interfaces with crypto_acomp
Date: Tue,  4 Nov 2025 01:12:24 -0800
Message-Id: <20251104091235.8793-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B7C4E1C000D
X-Stat-Signature: 3j48njjzwhe7u4rzb4zwqtstrpozemn6
X-HE-Tag: 1762247565-398746
X-HE-Meta: U2FsdGVkX1+DOuCbib13gPxCuC7+IkiQWvJPu1htDL5biWg+QSA6LYMklJkmOoDX8D9CxR0jZ2lorF0hgCf3aZ93+sKagZTg9HXhSjfRWYeb74TM5E+w9/idNTjlJFzp98nVaw3oWxi9rZf4bFezSWL04QFETd1G2MITEr9FruB6UxGr8Tvq4fccC20SAK7QKdVvNVW/4CFTfb6wLCynn75t3GGrnfKDwPiuLreIwyvC1avtUxGCdKR0jdJD9R+oiHx+MsAhUAuH1kMMInaWXAgfDjUaIF4ix2NCukGTns5ki0fE6b0f6k8sZuAggEGCY8ZGm647vHeNTcUKMq2kN30jpAyDJ3EzIfCmeb/PEo9e2N3dNuUBtEDl0hWy/wIRCITTfMJ3b9Tv8qs+r3d7xeZair9sMAYySd9BZdyq9lEujPgaWT1/LvdV8KPM9VyCeO/O6F2E5HmhawzY1swFe6eyvDa0tCFOCmvow3b+2Aw2fTqZJ335CnQddOeId/QPSnTEmbqLIgtRujBw4jXqkuje4We51JsVWfZ4FIFoYEgElLNT/37WKzHRPVmj6TMvTuXZfdN4Q28/N87RAGEElv+6M5F0y9i7+lSfnRMFNQvxKaQ/ZRqP2UpqUXMhOHwpCZGk3kBCUG0xMUW+g/mmtL69kUhGFCHW8LrfjzmescZvRUYDytC4/IEhXNUvxsaxHeChRFrE4E69s948pEGfdbsL7LzA2x/I9ZBAE6Wt05TN7TiVxViUyD64Pq7s7uD6kWzuVpkUGeDJc+ffU3L57bwwUydlIyvJDTsLZsSBi/8YwVcEXNGnh6QuZmdm7NxYtIcF5IlUs5sN3fcEjVV41bHXb2E5vlSY7Ayn7I54nWMb0nIJNVwRx434N3JvqTErBOg4E5EQ2mfYA0zIdSb2O4V6OcOcTD8DB80zKU+K7N4KpuL2fsdZfMiCPRjXOhD9ES7mjuTcN7p9gdAiy7w
 93GDYWCL
 2NiiF/yWJu71/vutzUYJFsdrJ2GuFmMja4DO6cGn2igWkaRixXaamGURqXN9zCxcgv0G5sH9oBZuzXQi7ZnR6Fif9Dyph+OtuS8znyYJjvJ4XL8ui+qj2RKSxC3gKFveRKIjHKF/7SUJd1XFpibIq/DUhhC9BU+7Jagr68QRzzOQiI4xxYkGylnnPvarjco9/cRpi8dzwX19l5VtfbAhpsE8Y1Bi7DAFFnwZX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch modifies the core functions in the iaa_crypto driver to be
independent of crypto_acomp, by adding a layer between the core driver
functionality and the crypto API. The core driver code is moved under
this layer that relies only on idxd, dma and scatterlist. This leads to
a cleaner interface.

We introduce a new "struct iaa_req" data structure, and light-weight
internal translation routines to/from crypto_acomp, namely,
acomp_to_iaa() and iaa_to_acomp().

The exception is that the driver defines a "static struct crypto_acomp
*deflate_crypto_comp" for the software decompress fall-back
path.

The acomp_alg .compress() and .decompress() interfaces call into
iaa_comp_acompress_main() and iaa_comp_adecompress_main(), which are
wrappers around the core crypto-independent driver functions.

These iaa_crypto interfaces will continue to be available through
crypto_acomp for use in zswap:

       int crypto_acomp_compress(struct acomp_req *req);
       int crypto_acomp_decompress(struct acomp_req *req);

Additionally, this patch resolves a race condition triggered when
IAA wqs and devices are continuously disabled/enabled when workloads are
using IAA for compression/decompression. This commit, in combination
with patches 0002 ("crypto: iaa - New architecture for IAA device WQ
comp/decomp usage & core mapping.) and 0005 (crypto: iaa - iaa_wq uses
percpu_refs for get/put reference counting.) in this series fix the race
condition. This has been verified using bisecting.

One other change made towards a cleaner architecture is the iaa_crypto
symbol namespace is changed from "IDXD" to "CRYPTO_DEV_IAA_CRYPTO".

Fixes: ea7a5cbb4369 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/Makefile          |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto.h      |  24 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 275 +++++++++++++++++----
 3 files changed, 240 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/intel/iaa/Makefile b/drivers/crypto/intel/iaa/Makefile
index 55bda7770fac..ebfa1a425f80 100644
--- a/drivers/crypto/intel/iaa/Makefile
+++ b/drivers/crypto/intel/iaa/Makefile
@@ -3,7 +3,7 @@
 # Makefile for IAA crypto device drivers
 #
 
-ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"IDXD"'
+ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_DEV_IAA_CRYPTO"'
 
 obj-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO) := iaa_crypto.o
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 9611f2518f42..4dfb65c88f83 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -7,6 +7,7 @@
 #include <linux/crypto.h>
 #include <linux/idxd.h>
 #include <uapi/linux/idxd.h>
+#include <linux/scatterlist.h>
 
 #define IDXD_SUBDRIVER_NAME		"crypto"
 
@@ -29,8 +30,6 @@
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
 #define IAA_ERROR_WATCHDOG_EXPIRED	0x24
 
-#define IAA_COMP_MODES_MAX		2
-
 #define FIXED_HDR			0x2
 #define FIXED_HDR_SIZE			3
 
@@ -42,6 +41,23 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
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
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
@@ -138,10 +154,6 @@ int add_iaa_compression_mode(const char *name,
 
 void remove_iaa_compression_mode(const char *name);
 
-enum iaa_mode {
-	IAA_MODE_FIXED,
-};
-
 struct iaa_compression_ctx {
 	enum iaa_mode	mode;
 	u16		alloc_comp_desc_timeout;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 04602df8d173..75bd455b3b34 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -51,6 +51,10 @@ static struct wq_table_entry **pkg_global_decomp_wqs;
 /* All comp wqs from IAAs on a package. */
 static struct wq_table_entry **pkg_global_comp_wqs;
 
+/* For software deflate fallback compress/decompress. */
+static struct crypto_acomp *deflate_crypto_acomp;
+DEFINE_MUTEX(deflate_crypto_acomp_lock);
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
@@ -1440,19 +1468,46 @@ static struct idxd_wq *comp_wq_table_next_wq(int cpu)
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
+	mutex_lock(&deflate_crypto_acomp_lock);
+
 	ret = crypto_acomp_decompress(fbreq);
 	req->dlen = fbreq->dlen;
 
+	mutex_unlock(&deflate_crypto_acomp_lock);
+
 	update_total_sw_decomp_calls();
 
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
+	if (unlikely(ctx->use_irq))
+		req->drv_data = areq;
+}
+
+static __always_inline void iaa_to_acomp(int dlen, struct acomp_req *areq)
+{
+	areq->dst->length = dlen;
+	areq->dlen = dlen;
+}
+
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -1514,7 +1569,7 @@ static inline int check_completion(struct device *dev,
 }
 
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
+				struct iaa_req *req,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr)
 {
 	int ret = 0;
@@ -1553,13 +1608,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1612,10 +1665,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1641,6 +1694,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
 	struct device *dev;
+	struct iaa_req req;
 	int ret, err = 0;
 
 	compression_ctx = crypto_tfm_ctx(ctx->tfm);
@@ -1666,12 +1720,18 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(ctx->req);
+
+			acomp_to_iaa(ctx->req, &req, compression_ctx);
+			ret = deflate_generic_decompress(&req);
+			iaa_to_acomp(req.dlen, ctx->req);
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
@@ -1690,21 +1750,26 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
+		iaa_to_acomp(req.dlen, ctx->req);
 
-		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
 			err = -EIO;
 			goto out;
 		}
 
-		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
+		ret = iaa_compress_verify(compression_ctx, &req, iaa_wq->wq, src_addr,
 					  ctx->req->slen, dst_addr, ctx->req->dlen);
+		iaa_to_acomp(req.dlen, ctx->req);
+
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1800,13 +1865,11 @@ static __always_inline void iaa_submit_desc_movdir64b(struct idxd_wq *wq,
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
@@ -1854,17 +1917,18 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1888,12 +1952,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1937,10 +2000,12 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
@@ -1991,20 +2056,16 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
 
@@ -2040,19 +2101,19 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
@@ -2075,9 +2136,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	return ret;
 }
 
-static int iaa_comp_adecompress(struct acomp_req *req)
+static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req *req)
 {
-	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
@@ -2121,7 +2181,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	dst_addr = sg_dma_address(req->dst);
 
-	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
+	ret = iaa_decompress(ctx, req, wq, src_addr, req->slen,
 			     dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
@@ -2138,8 +2198,9 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	return ret;
 }
 
-static void compression_ctx_init(struct iaa_compression_ctx *ctx)
+static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
+	ctx->mode = mode;
 	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
 	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
@@ -2151,22 +2212,56 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
  * Interfaces to crypto_alg and crypto_acomp.
  *********************************************/
 
+static int iaa_comp_acompress_main(struct acomp_req *areq)
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
+		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
+	}
+
+	return ret;
+}
+
+static int iaa_comp_adecompress_main(struct acomp_req *areq)
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
+		iaa_to_acomp(unlikely(ret) ? ret : req.dlen, areq);
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
@@ -2178,29 +2273,76 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
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
+	if (iaa_mode_registered[IAA_MODE_FIXED])
+		return 0;
+
+	pr_err("%s: IAA_MODE_FIXED is not registered.", __func__);
+
+err:
+	iaa_unregister_compression_device();
+	return -ENODEV;
+}
+
+static int iaa_register_acomp_compression_device(void)
+{
+	int ret = -ENOMEM;
 
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
-
-	return 0;
 }
 
 static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
@@ -2270,6 +2412,12 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
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
@@ -2346,6 +2494,8 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 		pkg_global_wqs_dealloc();
 		free_wq_tables();
 		WARN_ON(!list_empty(&iaa_devices));
+		iaa_unregister_acomp_compression_device();
+		iaa_unregister_compression_device();
 		INIT_LIST_HEAD(&iaa_devices);
 		module_put(THIS_MODULE);
 
@@ -2387,6 +2537,13 @@ static int __init iaa_crypto_init_module(void)
 	nr_cpus_per_package = topology_num_cores_per_package();
 	nr_packages = topology_max_packages();
 
+	/* Software fallback compressor */
+	deflate_crypto_acomp = crypto_alloc_acomp("deflate", 0, 0);
+	if (IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		ret = -ENODEV;
+		goto err_deflate_acomp;
+	}
+
 	ret = iaa_aecs_init_fixed();
 	if (ret < 0) {
 		pr_debug("IAA fixed compression mode init failed\n");
@@ -2458,14 +2615,19 @@ static int __init iaa_crypto_init_module(void)
 err_driver_reg:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
+err_deflate_acomp:
 
 	goto out;
 }
 
 static void __exit iaa_crypto_cleanup_module(void)
 {
-	if (iaa_unregister_compression_device())
-		pr_debug("IAA compression device unregister failed\n");
+	iaa_unregister_acomp_compression_device();
+	iaa_unregister_compression_device();
 
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
@@ -2481,6 +2643,11 @@ static void __exit iaa_crypto_cleanup_module(void)
 	idxd_driver_unregister(&iaa_crypto_driver);
 	iaa_aecs_cleanup_fixed();
 
+	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
+		crypto_free_acomp(deflate_crypto_acomp);
+		deflate_crypto_acomp = NULL;
+	}
+
 	pr_debug("cleaned up\n");
 }
 
-- 
2.27.0


