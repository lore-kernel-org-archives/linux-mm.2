Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A12BF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0425F6B0095; Fri,  6 Mar 2026 07:40:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DFF6B0096; Fri,  6 Mar 2026 07:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71E96B0098; Fri,  6 Mar 2026 07:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9E2F6B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:40:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F4B11B801B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:02 +0000 (UTC)
X-FDA: 84515595444.11.3D9848B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3472120004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=UXPEiSm3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3UzGEG+EMO5hQVHIScmxOOOv+tHtfPy3q+mI1q7KDo=;
	b=RmgeepAcyXtg2caGFXeTRILiqgPqbAp2T8KUPwXTJ0OPDGVwklsBjSBU7j/EO/rh+671iw
	AOfXIhVzNWJPI9247PqO6DWosJLB/40wKLfqmlXKi+1fGZWr0gztoec2wNIZWj362JHi8M
	tkLShpKibgZwUO9mU0LyQ0A00BmrU0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800801; a=rsa-sha256;
	cv=none;
	b=xorUbA/6E8hdU9FxUigpaHO+Kk3uF4cu20sbHfd2xY13f/IbCVgaIU74kTvGmJopbmPJ1W
	c7nNYg3k0iw3s87EDXegYyDol2cAB5d6oEdNBUCosHuIlxOP0WT1bk9Zz3riKRAd0pg5K0
	4/yJpwRDM8Bq+3l2HPdMfEz7Gt/E4oI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=UXPEiSm3;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=r3UzGEG+EMO5hQVHIScmxOOOv+tHtfPy3q+mI1q7KDo=; b=UXPEiSm3MiUPouY7UBy0zb/KBs
	GMdw4BdFGlt2480xHC/IIKzr+vh1Ae4UZPWWQJXZb0h0KlJEsxl3U+9Ud5p3olZKrJZU/w7cm1qDJ
	g52RpheYz9KCzPP4JIkmhIOcyuBrgKl0HHQD04+OOQImCk8mh5rGpO4uUvfvnWSj0mIyK66UjxTjG
	bcFMBzDBMWkRLmLRlLQvPOz2mC2u9ZPQQ4ajYGe51Q+PHFwU2bTPnSXzU3z3L5KaFYGBy+AfccoJr
	WjW7OgUatQCJBnAiipLjrDYgB1KkIy8Bs7nvTs9EYpem76YFB5ji5lgaw1JAHtAzGMxt5/b5Rjiu8
	xIuf8xxQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUTE-00HVRP-35; Fri, 06 Mar 2026 12:39:56 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:23 -0800
Subject: [PATCH v7 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-4-404d14c188bb@debian.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
In-Reply-To: <20260306-kho-v7-0-404d14c188bb@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2820; i=leitao@debian.org;
 h=from:subject:message-id; bh=4JJwA4BhcQH0vypVqf0AFPnXED7DjJgKgSgxLA0Nv5k=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssGmTaJ8Ll+XqkUU13uPDLWy3W9GTdb/bEvL
 kPgndgfIICJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bbqFD/4rbEXrPDtNBWZD7+8GEQ5PvrWyCEoLl4we3SLx+m0aZfb7JTLB1XE7e9YH4zNT0Kfi7MB
 6gm3bkNjfQ0v5moSTjVXPdOh6A2SOi2HN8Hs4tRXI1UUL90QSbANNQ2v3R/ZgMi94mGToy6bA2M
 4jmFTiUwv/pxTYNL4x8BTNB8CI1UOF1qVIO6iQ86ngXmu4pOMunCf5q9yv5KO/a8m6N509BNtbn
 SdbzysegryN2W+0ztpNIx80v7PGY2xNUKZ0HHjWrfvZd8RbBBa/cYu/WOHtl3jKCCoJzRq4HV4E
 v3OOcafotjyxzzK91DNwzKZTLZbPg4dmLIGgws5Yp/0hkMBFT1cLoNJyn/a915HyMBWDVaC67TT
 Za7G1HQNfIjYvWy2CYky9ylPrGNtrtpELbtzuyOFIDJ6skUV/CybdZpHOHu3xPGFrrCmpdxQ0C7
 z3P1+pKYNsuite31v3E9H3IcN0gwG+XWeq5Xe+PofXTVJRei5dGkgnXhoNcQk6BOd87RPW78KCG
 FAB0uY0Ev7+G5dvcIeS/OESx5xfs0Yy4d5EFTAjJTtkGMVZSfkn9OcGd3y+YeSV7JV2g7E/5ZHE
 fBkUcLL7fN5hUNg7cMVY2hsOhKSfq4M+vnPe62VdYNXuhlrNFb9Yd2qJwnTPY/PiUykBuEBYaRT
 6HMrPdq0cPVRvow==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3472120004
X-Stat-Signature: rw3yuamzydqdkpkh7cumwgrgen47d5rq
X-Rspam-User: 
X-HE-Tag: 1772800800-740370
X-HE-Meta: U2FsdGVkX185eI1OwB9whtmIEArtKgDG1OJD15SAmR5s1ZKc3bZbIc5RGX7WNCtgWoYPr8jYRWUpb5TwKTHyTtcLolkrQ5bhbMX2HD66OPZzkmeL+90UlJnrppDEwteZpOt24DCHUd79ahqpigwpKcdlshoLaWj3YpEjoS+E8rOlVASAUV9xcILwEGhNN5rORLppMyG3QzVRXDoor6BGor0kixZHv2Q/YowaCf/ua/v/WKhg4jkyaTjodPObkEavV2SnylEmYmvUaX+CdJjpSIh2xafLMK+EDPIgXmIeefRZrVOJx4ZAnBCgZnDe12YKE6zMIUHTKBx6pRg1/ET1ySZhwvvw9dMKaPEnni7jvs0wcKiDzuTijEQPAA3Q3PJbzXKRHaaKqxbpUGdn5X58/1PNIo/GwllLMIC8NNZuf08Kgo3v8ZVG82/OdkM7FBWMEGhzEr9VcaaoG4dNRsHd3+2d6hd4hgZxBbMtr75jcdBzeUSWChD1pHzqGZ7MoQgB5kEe7ibFiSD2uIyV64MthXMNy1rbb8VID1WjySvI3ICfOoRnXLQUfEef63c/Wu2qQ5m+Rfi/38EkwlO6Dg/RIutVfN3NhdZOXuvl29lanvlGgetY7Nlg73e9WmFStjSgCnIHg641k8uQ7TgCMSx4UP8UkowEwfZzwYQhn9dkyF8j8xPFif4jUBnXswPio03ARR01v0sIGNrBygXLy4tT1jx90EuEjiyahDxUawpB3Ci+R7wTN8ivXy0Gu6biXEqqivTlWMMWJQAU2qJlol7BBnt7vRaOtMXCatWQ/htWSpbDklI+ACYBAjvoJADJdZjNMV6ildm8ibaqIyyIErOo+te3CU8mBA6/KFhLFdfoIGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_in_debugfs_init() has two problems when displaying incoming
sub-blobs in debugfs:

1. It uses the hardcoded property name "fdt" instead of
   KHO_FDT_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
   subtrees stored by the current kho_add_subtree().

2. It calls fdt_totalsize() to determine blob sizes, which assumes
   all blobs are FDTs. This breaks for non-FDT blobs like struct
   kho_kexec_metadata.

Fix both issues by using KHO_FDT_SUB_TREE_PROP_NAME to find subtrees
and reading the "blob-size" property from the FDT (persisted by
kho_add_subtree()) instead of calling fdt_totalsize().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 38 ++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7a100f2bf3947..fc2baa8b104fd 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include "kexec_handover_internal.h"
 
 static struct dentry *debugfs_root;
@@ -121,23 +122,36 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	fdt_for_each_subnode(child, fdt, 0) {
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-		void *sub_fdt;
-
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
-		if (!fdt_phys)
+		const u64 *blob_phys;
+		const u64 *blob_size;
+		void *blob;
+		size_t size;
+
+		blob_phys = fdt_getprop(fdt, child,
+					KHO_FDT_SUB_TREE_PROP_NAME, &len);
+		if (!blob_phys)
 			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node %s prop fdt has invalid length: %d\n",
-				name, len);
+		if (len != sizeof(*blob_phys)) {
+			pr_warn("node %s prop %s has invalid length: %d\n",
+				name, KHO_FDT_SUB_TREE_PROP_NAME, len);
 			continue;
 		}
-		sub_fdt = phys_to_virt(*fdt_phys);
+
+		blob_size = fdt_getprop(fdt, child,
+					KHO_FDT_SUB_TREE_SIZE_PROP_NAME, &len);
+		if (!blob_size || len != sizeof(*blob_size)) {
+			pr_warn("node %s missing or invalid %s property\n",
+				name, KHO_FDT_SUB_TREE_SIZE_PROP_NAME);
+			continue;
+		}
+		size = (size_t)*blob_size;
+
+		blob = phys_to_virt(*blob_phys);
 		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     sub_fdt, fdt_totalsize(sub_fdt));
+					     blob, size);
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
-				ERR_PTR(err));
+			pr_warn("failed to add blob %s to debugfs: %pe\n",
+				name, ERR_PTR(err));
 			continue;
 		}
 	}

-- 
2.47.3


