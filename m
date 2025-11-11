Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B161CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208498E0016; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185288E0018; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF67C8E0019; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8308E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 587B9140188
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.11.82E35D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A95BA140009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTdymFss;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNupf9CqdYcHH/O7Igtt7dga3nnkxEnr9ccMOwh7OJ4=;
	b=TVVgPKt3Cb+b+T/6Ki4AtG4nhGjuCyTc9EU3MDmfDzcjzsRDI5Y8PTKVYuFnlViR+Pe/XA
	BUeMFR1sAVTuFlvTmRM7MHKXBin4dN25zEr8XKy8j2M17O4a0Fg0mqONDxqEu4gZfbtZ9f
	tF9k8LmScD6QG1pbgwbytt7PB20WrRk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTdymFss;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=yoWL5RSBDDI9/9Q2sLQKiNOCx1W64Zp/1IeFWAlj/2WTaH0fFdflq6IPXdlapbCGBbzcry
	IW4m/622PxK3vtS72VAuyovrHNSVVKll3zOcPPs131d2cWQAtKrr0K0oDe5aE1u0bmWCIS
	m6/GABpnnvDceWiMcIxwL4Gh+hEx2gE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 513FC446F2;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA8C4CEFB;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886669;
	bh=+8bf6ecH2QvmrcQl2a7rJm2jNUhjf8tGWK0R12xiYjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTdymFssBjyFKZQvY9G5+u54zM6i/+Y4DTZAt0CIeOQDITh6nLowUfB2sTsgOz3uB
	 pgc2KrrqQHpnatga8xi7CQ5mlgLiVf3IfzofdVbdNeGDtBolgZ6QfixzluMbHTyDUa
	 eyCkNpGQKJM4hZx1bvGAxutK20scr0IQuyY9Ef03FAgYpKn8XsVFcyn0ZKL9/qMIOm
	 ZtcNNlgg9YAMgyymYON55BB6n7QIpZ/krFt+5dx4ZD49Z8WE5GPuO1q+XtFptUMrsH
	 mslTc6T6m5UPLhWDP+Agna40O5ACC3ecBjRMY3r/Hy81pTaaYgrjxhveaA7yi4QLnN
	 VIQt0RDIb5BVw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/core: pass migrate_dests to damos_commit_dests()
Date: Tue, 11 Nov 2025 10:44:07 -0800
Message-ID: <20251111184415.141757-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A95BA140009
X-Stat-Signature: utr67o4byec8nf9by9cxsdx93x3gdxp4
X-Rspam-User: 
X-HE-Tag: 1762886670-311457
X-HE-Meta: U2FsdGVkX19P+rr/G9BMERClaEXsWrcKLiS/+QnbQDqVKqfs4u68tsZ3njTPj5wfsA4WfKYdZYGAVewBD2YwYwuMQ9QQ6ppyL1KsCQLAc8ns5oTncVqtdV6eRRS7yhOOEYK3gvb36xnsbIw7s+hjXG7tXwlOKV78YsUkjSdNETv+ExcvAEcZ9WVJ6DUF8eUNyngFnvpUFntpeoJlupzCJV0LPJ+JGwLDfnDrNPRxjpvpl+nkULDl/buNZEe9zVRc+RYRepHG62oAjc6ok9+ACWGGiB9jpz2w1lhg6qlzZ2naf9EbcbD7Z+Kuc3K8JUOEpo0KQQoCIUneBN7rOuZ/Om+PF6vTkZ20MBdaDHKMeYI2brYwXgEFIMMBJcYFA31U2W6t2WpqgqrtjwIT9OZSOu2QYPNHOWKqlrcXrulfY/K6fgBkgw+LGSxpPmwnYncg8CEAFdRABr+FU2bPmxaWB+7LeF/eDDnRc1kEpZpRiHEsGcxLpjVhyC5CKCNEacQ14YvRJ+ndAY7a3Cv3O8Cov2qb3ftWyBavVEfJT435g6doAbgFIBt3iN/k5ZNJushMLGugiF9Uok1H1yVfX6P6SgDcovneFiOyedVqYTjJh9PSCI8UDG0iiq0l+BZWIAMcro4qEwFVdbxvm3l23jZAu47HwcUYX1CjMdKLQmL73YIh5RGQgVHrzIr519bu4oUFrf2KH8M4PFuxRzMeOWSwlcAOeoVPH9dAhS8qaK6VkidIEysV5FyroMOVpUj/8MdWr92Vb5jeW/Kx4nWIV5Pq+igqI62+fsd9m7Tr9+IwSAjkfa4U8+pLOZSigj72VSmZoMeFIH4WLXlzOKlwaSv2zIrtzMw3t1B6uHRNb5li2BjE8QvrdL6r9RElrha5EEALmUrQ4I/wcqhfH1Ohq7YV1i0hovoDjDn/KiaSW2sglSOW9BRmQhjrEGdaB3TBu/uLiSFhuTUSjekAF/peC3r
 O2zri/yu
 Bjw83pulRKDvbAI+ZUwU8BTMVfzwY5sBOiq6Z0ow9vMp30LcJXX81Jtu7ArIUUfQ9IzuOPdqX7CdLuVaaOAhuAzMwqNBhCd2UpVwMssTtl4VvSEr2+t+sd1L2wOUaxXNSFExK9KZp8X2BpzRYyS3sMRYtlRhOTVnGUld//Z0ClP62r6OncfbjAO25oKMlWc2SXOfMimmds0JQLwdx8ZEj2fiVWcdMJS7XElrFErnP/GbpQauRbxalHpMOTsrv7AfZS1tmRmNt8e8ayE2plOpLoiIA/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_dests() receives 'struct damos' pointers, while it uses
only their ->migrate_dests fields.  This makes code unnecessarily
difficult to read.  It also makes unit tests writing complicated.
Refactor the function to receive pointers to the ->migrate_dests fields.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 06ad359024ad..a14cc73c2cab 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1000,36 +1000,32 @@ static void damos_set_filters_default_reject(struct damos *s)
 		damos_filters_default_reject(&s->ops_filters);
 }
 
-static int damos_commit_dests(struct damos *dst, struct damos *src)
+static int damos_commit_dests(struct damos_migrate_dests *dst,
+		struct damos_migrate_dests *src)
 {
-	struct damos_migrate_dests *dst_dests, *src_dests;
+	if (dst->nr_dests != src->nr_dests) {
+		kfree(dst->node_id_arr);
+		kfree(dst->weight_arr);
 
-	dst_dests = &dst->migrate_dests;
-	src_dests = &src->migrate_dests;
-
-	if (dst_dests->nr_dests != src_dests->nr_dests) {
-		kfree(dst_dests->node_id_arr);
-		kfree(dst_dests->weight_arr);
-
-		dst_dests->node_id_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->node_id_arr), GFP_KERNEL);
-		if (!dst_dests->node_id_arr) {
-			dst_dests->weight_arr = NULL;
+		dst->node_id_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->node_id_arr), GFP_KERNEL);
+		if (!dst->node_id_arr) {
+			dst->weight_arr = NULL;
 			return -ENOMEM;
 		}
 
-		dst_dests->weight_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->weight_arr), GFP_KERNEL);
-		if (!dst_dests->weight_arr) {
+		dst->weight_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->weight_arr), GFP_KERNEL);
+		if (!dst->weight_arr) {
 			/* ->node_id_arr will be freed by scheme destruction */
 			return -ENOMEM;
 		}
 	}
 
-	dst_dests->nr_dests = src_dests->nr_dests;
-	for (int i = 0; i < src_dests->nr_dests; i++) {
-		dst_dests->node_id_arr[i] = src_dests->node_id_arr[i];
-		dst_dests->weight_arr[i] = src_dests->weight_arr[i];
+	dst->nr_dests = src->nr_dests;
+	for (int i = 0; i < src->nr_dests; i++) {
+		dst->node_id_arr[i] = src->node_id_arr[i];
+		dst->weight_arr[i] = src->weight_arr[i];
 	}
 
 	return 0;
@@ -1076,7 +1072,7 @@ static int damos_commit(struct damos *dst, struct damos *src)
 	dst->wmarks = src->wmarks;
 	dst->target_nid = src->target_nid;
 
-	err = damos_commit_dests(dst, src);
+	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
 	if (err)
 		return err;
 
-- 
2.47.3

