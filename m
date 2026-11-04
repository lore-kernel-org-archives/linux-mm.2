Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27976082BFB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrV0p0IV
Received: by kanga.kvack.org (Postfix)
	id 4D3CA6B05D2; Wed,  4 Nov 2026 11:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FE16B05D3; Wed,  4 Nov 2026 11:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3002A6B05D4; Wed,  4 Nov 2026 11:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08AC06B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AA64406E1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:22 +0000 (UTC)
X-FDA: 85398024684.16.C153B5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9260F1C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrV0p0IV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvZ5XnxdxIW2P/kVJf4H5CXZ0aIg/W594yfUcOxNZPc=;
	b=3Sxz5uB8mSQh/VBWy2McTcv7AxqGtGATEw2dNaK+fHRvquSND4QAGocy0Fm5tQP5h/l0QU
	Tb04SK78ImzCNQHdLVGKttLrxEDf4DV7AAHwZKOMcPEVRkg6Zr00yWDJpu/Xqm6p8I0c0t
	N0abLVnTwK0+KtKnqlJmS9SzlGY3xXc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811020;
	b=6VyVeqmDuN2onV179hH0yXKmeD9Aj1Ip80XRq5W8BXGRouumXBmyk2uZ4y7GTcfWova08L
	7iJ6rJkvxQGgwgMxuVk9ro8Y+6G17UXUh2cSlzBiCmn+mCZdop79q4imTz4YbLXTKSJUKB
	aCQLffGM5OSs/7M8gKLk+R/3ndgr/XU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrV0p0IV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D81E043887;
	Wed,  4 Nov 2026 16:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0316E1F00A15;
	Wed,  4 Nov 2026 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811019;
	bh=kvZ5XnxdxIW2P/kVJf4H5CXZ0aIg/W594yfUcOxNZPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OrV0p0IVAw9DP4Kokc9d6E9ta+ht4bkjrdGuDvM1eepif0lae0cEYg1sM1ZcXQBcg
	 J9ChDTB9CYfELh/48UhZe7Jxf5NNvFFccS8qFAyyInz3AYU8osJD+wFdgK5mN0JdDy
	 yKhGlLB7zLJvVMXF4Mw1WMkJAjRyLzml5wKH2/jdC5CuGTWAVia+MkEQ1tZwAhSoeQ
	 ooFzd/iHmeaG3rg4YpJcaL22VPZvae4mjVVqx6L6EumhzvpsiMCrbO9OnqD/PtN7LB
	 T+NlyZLKBSFgQdg94qXVHWFVJvR3ThloVy6yYcEftDrEbICo19QP4zcmf672CU9lSu
	 3Qt6m3gZnsg4A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 04 Nov 2026 18:50:09 +0200
Subject: [PATCH v2 1/3] kho: walk bootmem areas in address order
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: j7ycs9aqrmr6c7bq7fpngna84w4gtmhc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9260F1C0008
X-HE-Tag: 1793811020-376657
X-HE-Meta: U2FsdGVkX1+Q3egteMzrMYa+IxCKS4vQeBd51w3/fIaz9UBGKESZgUmQDm8pJyotJwYbX2DqZCLDeSKpDstk7kX2Mul1y3WSsDQ2ebsd0Pm4CIz8/xdmldaYLhPr/NhTotld+mIqJYeFTdGYwXwOzxPfWhfsd5ElVMvaZmZIW/Rfm746p44n4EX3ghYYt6DqePH0IAC+KFBNr+ZESTglBLLJ6qDrb2Jz2D4KGVqbxmlavPkSp8hdWswU8YpDK/M5r3MY8GOD5X4rR20q4ewkC+xbEbgE1xEv4rC6KfoEgMa4RAXqoj2JdVi53Fh7RzTatmFgLbdbNXvpL4DwQRVV5bSmkPIxOiYhv3BHlsVcaXqUgADiTlp1Lgshdtx8Cy63BjyYZfVj6toEcHyhpQHShOuhuS5+M6bwSHUnolM/9FTJM4Uc83GzTFYWA+LcGNnH1lbkMns9LRNAoDUzEXjkNi6EV3hoiL8IBvCBO1EpDp09uLVDPjxgZl5H4ITksL7uGS0O07Wid/DVCw6/Baw54U7X2lAk03lSIACil00WJ/3+Rx51NtGRYgeolenPg3glLubRYfPimO4oVCfSXbbj4YxGPoqNFwf4MxQcv2gh27s1EsIcfHqOcQ3AhTpucK4QhptYXJK3exyuQ5gZc7MLHMGibJuprAzvnMirzHZneVps82/xfj1TCdPk15XsBIFSd9hrG/V/lZM/6uRReUnciiu08wPXSklnuYvePU+4cVW9LYER0751icJSRMeBJhiPCc2BCW7I0yuVYWKGsJR3Ea4xNbT3fAuasIjNQ5jXcjZT/m5uiEuXpEkkY9OiLCSPcu7OBQFOUExZZve8fXpKgTO+gDjqVfP1RczfmqrI89ndhdq69LCQZEZIVyItLBRKoVLYb0lmZUIX/lEPDkneb6c3BnDthFm4Eky41iXudNOfIdMF/DTf6D3RywkrtlBCuINL6I0G4oOcHescHTX
 F802QEye
 Q/nzmqh8GwQkLk21puaQi5U7ANK9HxHwqOOYhQvMtaLO9IwZpveDer5TqBuT+NeHwM9iG5VB7eFOLrfQIVmBTcycSucGoylzje8fK1T4LZQb1d8WzcvhzBw8piAV0bJIAHRkb09zpnZVSTlBaUVoMiTSGtqj8xw+BJ+pHcr+s9ep3TjyChMKMgh1B2wqSakj8Aed4vfa5Fifk5T5tNsVLvSbaVCDj9EgqBrwaBPOCTCBQ4aL065BpJKzL+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kexec_add_buffer() users may depend on the order in which memory holes are
searched. For instance, arm64 places the kernel bottom-up and then
requires the DTB to be above the kernel.

kho_walk_bootmem() walks the bootmem areas in the order they were
reserved, so if the kernel lands in a small area at the top of the memory
there is no room left for the DTB and kexec fails. For example, on an
arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
reserved first at the top of the memory, the kernel image takes most of
it and kexec fails with

  kexec_file(Image): Could not find any suitable kernel location!

Sort the bootmem areas by address and walk them in ascending order, or in
descending order for top-down searches, like kexec_walk_resources() does.

Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe31819..2ac5d94f33fd4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/sort.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
 
@@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+static int __init kho_bootmem_cmp(const void *_a, const void *_b)
+{
+	const struct kho_bootmem *a = _a;
+	const struct kho_bootmem *b = _b;
+
+	return cmp_int(a->addr, b->addr);
+}
+
 /**
  * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
  *
@@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
 	 */
 	kho_bootmem_cnt = i;
 
+	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
+	     kho_bootmem_cmp, NULL);
+
 	return;
 
 err_free_bootmem_areas:
@@ -2081,20 +2093,40 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
-static int kho_walk_bootmem(struct kexec_buf *kbuf,
-			    int (*func)(struct resource *, void *))
+static int kho_bootmem_walk_one(struct kexec_buf *kbuf,
+				const struct kho_bootmem *area,
+				int (*func)(struct resource *, void *))
+{
+	struct resource res = {
+		.start = area->addr,
+		.end = area->addr + area->size - 1,
+	};
+
+	/* Try to fit the kbuf into our KHO bootmem region */
+	return func(&res, kbuf);
+}
+
+static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
+				     int (*func)(struct resource *, void *))
 {
 	int ret = 0;
-	int i;
 
-	for (i = 0; i < kho_bootmem_cnt; i++) {
-		struct resource res = {
-			.start = kho_bootmem[i].addr,
-			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
-		};
+	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
+		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
 
-		/* Try to fit the kimage into our KHO bootmem region */
-		ret = func(&res, kbuf);
+static int kho_bootmem_walk_bottom_up(struct kexec_buf *kbuf,
+				      int (*func)(struct resource *, void *))
+{
+	int ret = 0;
+
+	for (int i = 0; i < kho_bootmem_cnt; i++) {
+		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
 		if (ret)
 			break;
 	}
@@ -2110,7 +2142,10 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
 	if (!kho_enable || kbuf->image->type == KEXEC_TYPE_CRASH)
 		return 1;
 
-	ret = kho_walk_bootmem(kbuf, func);
+	if (kbuf->top_down)
+		ret = kho_bootmem_walk_top_down(kbuf, func);
+	else
+		ret = kho_bootmem_walk_bottom_up(kbuf, func);
 
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }

-- 
2.53.0


