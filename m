Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB25C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3162E6B0170; Wed, 29 Jul 2026 10:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F066B0172; Wed, 29 Jul 2026 10:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2FD6B0173; Wed, 29 Jul 2026 10:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D982A6B0170
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BFF7C064E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:03 +0000 (UTC)
X-FDA: 85042116726.22.FFBD9A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1BBCC000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=juQFDwcO;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKqc31TeZXFcHalUwtLT8t9WbNac7HeKnH2JgkerxJM=;
	b=w/8AUsPDuYHAI7ltMio184m+PCbZ/RnnxKL9xRbHn8B1gBZuK4NHd6CmDL9JitMYHH+kqN
	szV8mxS1XMOUaKtPwhlPponbS8unHj63DZTlqKv62BoSpGXvLOEH1BlWpS+4cD2UjNQXrs
	GC4LdvtUcGDQGgE/UKd4tM77S95/Lbs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=juQFDwcO;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337021;
	b=qM9Og+SrUvdz6zroR/jxhgogbyYwMn++CJj36nHZsux3GLIgaNCoZXVZzcpYxQvJuhheAQ
	mqtqfJu9QF4712EwceA7J6dV0HiKsEqeTZw4INrcS1GwQ1VXJILx/02sILXzLdiSh0Je62
	EnIwoYoFqfZkfKdwDblQ7cqsfpQjoK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 751C560A72;
	Wed, 29 Jul 2026 14:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F31F000E9;
	Wed, 29 Jul 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337021;
	bh=aKqc31TeZXFcHalUwtLT8t9WbNac7HeKnH2JgkerxJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juQFDwcOSX/yMI2cIAoSl3nUUm1pmJ1ja+LUjuPw5tlGZaNZVtTqBKqRVOs3KodTl
	 hMtQ69g6p6eJAxUi1KXWlYfz2KXCAhaDIwItbQAHmXda/w50XRhu9TaKDWUNehnno4
	 UUyeEGsf3sgT4mePV8gRDdoJ+EPaI+HbN2esnx2hcITv+Xa0YNw0hFRy7ezDZ0/4AL
	 QYGk6j4Q5xkiqhTDCO6Qdk6jjlm77p80167CL1fabpW4aBOzNn0kLuZyEGzsntphsZ
	 Fs2Q5zZDwnRJsipCAPbpLghO3BswhKKMIWK3GHPU6trV03b1NyFrnVuPIF2QmfBcYO
	 orcHcE6jBh5ZA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 15/22] kho: initialize preserved memory map radix tree earlier
Date: Wed, 29 Jul 2026 16:56:00 +0200
Message-ID: <20260729145610.2827231-16-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D1BBCC000D
X-Rspamd-Server: rspam01
X-Stat-Signature: c7bs4ukjf1orzmfndnydwo86w7dedibm
X-HE-Tag: 1785337021-840182
X-HE-Meta: U2FsdGVkX19cUz6LFQAJOpK9bzozsSr0Ye3+xmELy4TvCyU4DbMzOx4i6JSXdXDggczoCqIpycImXlrKgsVkUZBlMi26rdFgF8AVQ23E6axAmzEW61oOm40VNNoPxC3spH49JJMcu0y69U/Ue1FV3ZrA2zn4GGENtKrDETiS4I380t/nFENEJCmd4sVprE4Yx3BE8yNY+4CJQJs/ElDGJV3QF1kjWne4Yx5XT3mEE2fxf5Z3jJAeLEWLH+ZgRNdptcwqZicV0HjVGTdVDbW2rEg6w6+LKImCw2smmaJPwdJ4mTMw+jz9dqLXDdt9Yv1QcOD1lDAbaNuYrhkW4aSLzxECb5fcbd+ITs5UJAvVWPwGRZ2env8XuBckIVpQDW+79iloKuQVK1FwcICcKqkv/iC59j38qQYU0uhE7IBslzci1MJTSBkl3aa9WBH442M4CJQcVECgzom71eZnoRo86AqddSdvYxXNdULA2DeDwHBfZxVUqDg+W7XYp3fbNXVEzBmervaAay8UZyUkasX6u0XnlFMGSkMu++B85ytQ//Z4c7+L4V09G3ZYHvW3/2E1v55UraKOmZRj6/8ak0owUVJpYgRklLfLI0O1UDIX+jTi2gRODlsKNNaDEZ1mev8auLIaWsZqj1o3YQChRVPQ4T947kOBAf5sg1ETX9oiEcTv2viElVhSuNIU9gGsZY94twgOaIfgiNfr0OZydV76EdcZTLWotyTq6MPaqdSIBb3kpKFeHi8nGUWWjyTzBLL9KwmKmcLqN61utw7MfZdc4vF1T2U94nqRouT1l6jRKuFh6qEgMVrGX9fbplNZiVqNSsSFncENUUWrF1RwrGEQiXOJA0iwY2KwWHCmcWl106JduSnOfQxHddR7zUGiuhOiZq4ImWburvLh0wEbXZTeBj4OXoUXqCuHtnmqOwSDiMO/HMnbT17Z5exx3EOzrf6LSBFrG9GjcGEGLISnqug
 R/3TuAzJ
 1wDDGB1RJyfs0MMpArT56KyxUElCOh/Fiok+IWMYLqzHGC8AbNABFTIQ372gGOdUa1jFiMO+rkJG9OP190nxGEFGLgsbV3JIU1vXFECYhhMnmKTtibcv5QoSgVFsNQ//aF+hvPkazfkuq0Z/0JWG3qO8NpAxy7wGiP5b37a/Bwgmq2iAHCrwDVPlQkcJRPq7ClOiDT6rfa8XdYt2bmLlbb5gu64hd/aM5z5E3aItUjxcJJ3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory radix tree is initialized from
kho_memory_init(), which happens relatively late in MM init. In a coming
patch, the tree will be used from kho_memory_init_early(). Move the tree
initialization there.

Simplify some of the code in kho_mem_retrieve() by getting rid of the
err variable and jumping to err directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2ddfc804cdf7..6e8682469bd7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1531,20 +1531,8 @@ static void __init kho_mem_retrieve(void)
 	const struct kho_radix_walk_cb cb = {
 		.leaf = kho_preserved_memory_reserve,
 	};
-	const void *fdt = kho_get_fdt();
-	int err;
 
-	/*
-	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
-	 * catches that and never sets kho_in.scratch_phys, which stops memory
-	 * retrieval.
-	 */
-	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
-	if (err)
-		goto err;
-
-	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
-	if (err)
+	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL))
 		goto err;
 
 	return;
@@ -1756,6 +1744,8 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init_early(void)
 {
+	const void *fdt = kho_get_fdt();
+
 	if (!is_kho_boot())
 		return;
 
@@ -1765,6 +1755,20 @@ void __init kho_memory_init_early(void)
 	 * early.
 	 */
 	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.fdt_phys.
+	 */
+	if (kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt))) {
+		/*
+		 * Failed to initialize preserved memory radix tree. Clear FDT
+		 * and scratch so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.scratch_phys = 0;
+		return;
+	}
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.508.g3f0d502094-goog


