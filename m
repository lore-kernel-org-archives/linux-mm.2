Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1120EF46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767696B0208; Mon, 16 Mar 2026 07:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A926B020A; Mon, 16 Mar 2026 07:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6856B020B; Mon, 16 Mar 2026 07:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4176E6B0208
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:56:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2AEE1380FE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:25 +0000 (UTC)
X-FDA: 84551773530.30.1305D87
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 238DE140012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eNv2Gl9d
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrU8iiVUzo7pzSuSlrROr+d13XFM4fDOr9PEDnip+Ig=;
	b=YRXB4MnGLrw+NI3viCdHqFMTtasCaPIKVA4rhV8QHx3Xs3PfwbeiJrjOd046M7yIuq49iO
	uT0vL1QC/sgJTAXP91D2z2YEHGpSBEsVmREW1BbXiU7BjUn06ilccGrCaa+I/ZFWkezeaL
	uewJHqHJxO17SMcrJKZJgAkZtiVfzXY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eNv2Gl9d;
	spf=none (imf09.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662184; a=rsa-sha256;
	cv=none;
	b=arKIeWlxs5k6JZ1fCLyDRwhda4ss/CMYVRJvZ+ES2k2wmOvJCg/nynx//ez2tUd7mggTvS
	PfcB1dngjsT0It4RPlufm0z7soIrWVhomPSKHOw5PdztK3cwvHzIgglsYOc9bXiqCiHPQC
	5l4ITeMJ9j5HdlReLXjPBjB+U6YOx9Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=CrU8iiVUzo7pzSuSlrROr+d13XFM4fDOr9PEDnip+Ig=; b=eNv2Gl9d4wYCGxiYb9k5o8EJfY
	eNiOmFRtE5PUpTBnH28VW7jwhd/8SQe852fGq6zh51WyuRLYq8TgQpz2wIN8lOgYb65Di77WPieLz
	WC8fqGpv1Ahls+R/W5QUGkAjc4oMwGT/BMbCVCTOV6nZn0+ANauxTK0aY+ISlRJ4pvvdt6LvrN0Mg
	4Oae993m4dkSRkyXLMRCAblIe8b54fYdDrYmHZf6Flavp8mgwVymBHqqL3NB2vZE0oofbQ4Nu/sBL
	AV9dJN8MY5VDLdVnSxwfx3Cf+d5Nwhm97/wjT4ktXeqqoxvF+VLkY6fRdf8hpdYALmI3fhneTF7SI
	Pg884qZw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w26YZ-0025zV-Rq; Mon, 16 Mar 2026 11:56:22 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 16 Mar 2026 04:54:34 -0700
Subject: [PATCH v9 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-kho-v9-4-ed6dcd951988@debian.org>
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usama.arif@linux.dev, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2322; i=leitao@debian.org;
 h=from:subject:message-id; bh=NdnEnb82h7S9muDEUV3/7Wtzdn0YHHb9hUPR57PIUzA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpt+/QHPzXS1ApQQHREue5wikETwUmtKSVrZnZ3
 eHOP/JL5c6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabfv0AAKCRA1o5Of/Hh3
 beOTD/42Ij2t2+/+Rqjfwm8NNjanxcOJ58mHmWDZuXoyPvGHmSXH/SY69y40/LrHEJNf9TRZgZ7
 Riyh8VL6H6HMJnHTYFuQc0cymBgEBTn9QqDeiOAmWjWJTfH5fCufmVWTTseNRrYFP3xhtmruHxz
 0kdGvpz7a4DUsJhWlnwyWJSZrGDVXp/kI+jkNDvYimoO3pVwt1txEhOn01K0Y6bQV8RRfLJTcHn
 Jd/Rj3qlXJB0v/oN4WevdrZjExLxykDRwkDKVvskGGCYEmC/kQlEnSLvrM3YjQmSgRwxI9O4LRn
 bjQSLwEFSMrqpO1KxeKe4X1B6GEWPWHaxappsva0lNkH25FFgG2Ofrj4b+o99ZrvoXGq4icPr/l
 Oa469NQz8su/0HBEfLvGCTxZniQiqhYVCXnEB6AzRhOKvnTgllFFp+RtZ/MPUVSxjs7lc8Xlkv0
 c+U2TFB/5HSkDgtXv/2ikSA4Jpb0mvjR6fZbvae9o4wcwUG1OKKTak59W9WUuJYWW0+2Rak7oxL
 uJ2ARLkaLXLLCC2yChKodg58TBI7OZ5UYJP7lAoxttq4fcKAmEDKCyZIaT31W41MaHg0pNUcwhD
 DNvuh1KVfOSK7/3Gms85Qs86wJ1kZ4WVif2Soo8RK1jBObxAvGjvjWfmSn5xICgcPVoO/VXndkk
 14u+16jjvmFTo0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 238DE140012
X-Rspamd-Server: rspam07
X-Stat-Signature: i5iywxuqgaq3d3j8hqm4poqfx71fa9mn
X-Rspam-User: 
X-HE-Tag: 1773662183-880853
X-HE-Meta: U2FsdGVkX1+hbvjPW2HYnnHfo/WDhopxU5f6h0GU7ICq8IQjn0EGLBdZwXGrXiPfhR9VYSVTsgFkrvYzguzgvtfgbdh2w+ShrQBqEkU1oQSKVUp9XuUQ6jdCu7cpKuTbPEiX7+Acn0H0Fss47frdwVXcykSzbbtRDZ848a1dlGR9vnMa/joh8g4nD0n+5tBYgoB66e+zB8CV5T20FEj5yMzJdN3nFb23AmjJX/nYNLDLXgz4jw25B+GOY1ArGiwAL/K3ISvjNVgPTqO2OTSSzE+V0paNjir/1pxr8OBMhrsdSgn4uEMTQCSeJKAMYsinjQR3ZBgnIkc4IylPB/BrDcdOcYJC1yaGSqmAfX5VneywG/bgwcwgPf/B6dCLIvlnTM4+jvDLipy977NBp5eCguVWxUmNHpjpV8/l6GFdxFNrDSyK7JLYKb4ZUd7rxMEGmFp5OWFoGogUI5t/jZIvWtZFizDs1/9Zc5HL9X+NbTJ74GKo+8Ox/eNodr2oDn00KN5lwWDb3TywsFgWJVgsjO95jHp74A+OvuGwUulZMHmYs2GZNIOKUC84gHWG9/nLsafPLvy1N1SA93fNJzrIFDTSdAfIrzfhFPmko5bH0XA1IGqGeS5oSBAizoJYY3xD5U6KkPGglknZ1UrtmC6HAz1ZhLseCoHncW2Qk/5tnXElZ9XvKrguoorjgJmjJFT/Uk8X7zpTcWe3pCHfWzAuv+D8WU86iXjIpgttytHFzTPBXGjU1i8CUbmlq0InwF9dKvkYEpt3rFkJIVKbtN8enxfUnMrNmpENn4PAbRlud94fstTQ0nc1zu319YQ/6Er7aUGFXNaaqGwDvHKWXpMgSimCI5wFaiRgeQB/YA1MlEFD/JmMD1EaePpjKIKkT5l/EDwRZd9Avm24WHg2COXMYxhBQ8LlfbMASMfr66Q7c7mPj3ZQ2eNyhsXiO7ZPB/nRpT/+c24Os1kDySVC0mC
 fCieG/i/
 j4a3X9w7rMjxpVBFIfWuMfHrtb9ivHP4NEtF8CItjGkBQR8R/WG10IPeiLM6TJo6Ia570szJiTNQ74GfnQ8amL/jeotJ5OwfRkBey9ozKLEja/pHuwe2Oo3t0nSORMzpSwU4nCdb81FEac3kuVucpS8Oxtv7I+D1pY/h/Q31XyeDdjlXnaV2hxCm3aukQ9YRI+8jmavTeWNT4aGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_in_debugfs_init() calls fdt_totalsize() to determine blob sizes,
which assumes all blobs are FDTs. This breaks for non-FDT blobs like
struct kho_kexec_metadata.

Fix this by reading the "blob-size" property from the FDT (persisted
by kho_add_subtree()) instead of calling fdt_totalsize(). Also rename
local variables from fdt_phys/sub_fdt to blob_phys/blob for
consistency with the non-FDT-specific naming.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 32 ++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index b416846810d78..257ee8a52be66 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -122,24 +122,34 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	fdt_for_each_subnode(child, fdt, 0) {
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-		void *sub_fdt;
+		const u64 *blob_phys;
+		const u64 *blob_size;
+		void *blob;
 
-		fdt_phys = fdt_getprop(fdt, child,
+		blob_phys = fdt_getprop(fdt, child,
 					KHO_SUB_TREE_PROP_NAME, &len);
-		if (!fdt_phys)
+		if (!blob_phys)
 			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node %s prop fdt has invalid length: %d\n",
-				name, len);
+		if (len != sizeof(*blob_phys)) {
+			pr_warn("node %s prop %s has invalid length: %d\n",
+				name, KHO_SUB_TREE_PROP_NAME, len);
 			continue;
 		}
-		sub_fdt = phys_to_virt(*fdt_phys);
+
+		blob_size = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+		if (!blob_size || len != sizeof(*blob_size)) {
+			pr_warn("node %s missing or invalid %s property\n",
+				name, KHO_SUB_TREE_SIZE_PROP_NAME);
+			continue;
+		}
+
+		blob = phys_to_virt(*blob_phys);
 		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     sub_fdt, fdt_totalsize(sub_fdt));
+					     blob, *blob_size);
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
-				ERR_PTR(err));
+			pr_warn("failed to add blob %s to debugfs: %pe\n",
+				name, ERR_PTR(err));
 			continue;
 		}
 	}

-- 
2.52.0


