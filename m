Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65361D65C7D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DE16B0089; Wed, 17 Dec 2025 11:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C702E6B008A; Wed, 17 Dec 2025 11:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9932B6B008C; Wed, 17 Dec 2025 11:38:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 849166B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:38:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49E79140B44
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:38:23 +0000 (UTC)
X-FDA: 84229520886.21.6749298
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0D0B140012
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:38:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765989501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68xIy8TR2vZ7SGUApCF+7LoXIIR/VjU2Kv8yZ1lFSig=;
	b=MMmZZs1yVBAZaX3bq4zQ9dMw65gU6ViZZLd9zBg5BQD7+72Ll0vgeGj4N47G8joIU9q8kP
	Lal+nJLmT/WUdiWYRmhoqjefRVVxed3flI3mYFQYcJLF+syyYwy2AKq4ySLgt4FThTOaLU
	kGt+2Rk3xXtN9kt+Xsnmx85Zf4WumRg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765989501; a=rsa-sha256;
	cv=none;
	b=oW7yTeb90Dv2EzUSoE4NaXlqobAg66ayYI2ttU8K5iUMJfYgN7kskDtXGFYaJzDDjHhiFI
	wBQPvyDyMeJ5JALN4woZMxIONULqJtkU7x2tsf45amSl3jO/XWtZSoEKo0yceydzNnmPdi
	lzqEao11iiz3lhtnE6VKaFgd8miBNn8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7612A106F;
	Wed, 17 Dec 2025 08:38:13 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 100133F5CA;
	Wed, 17 Dec 2025 08:38:18 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH] mm: Add basic tests for lazy_mmu - fix for powerpc
Date: Wed, 17 Dec 2025 16:38:12 +0000
Message-ID: <20251217163812.2633648-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bd51fpfbfocw7tzjxnem6u6w7a6ragr1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0D0B140012
X-HE-Tag: 1765989501-580838
X-HE-Meta: U2FsdGVkX19rQW6deUSkD680zaDU8tItrcgM5114TO6MYTzBbNh0DyBtPjg4z3Pv8kI0oL3AxvypiKYK/YKecl/Mwh3BQYl4muJk7bdJw7NqnoTSiBra2b0nMDSRkGIUSCv0TYnOp1sMRRNya1YsgjBaO9p0zQbwY+fzgHTbsQ+LCrwSwXO/GXATykwZA5SBcGr1eVzEdYpZHECnZ0QuPNK9AmK47SbkDknpssw8QKT+WEbC0Q+25Fst3nSWDFee2pffyWKXC2qJNS9toFGgYU0PQ+b4bT6Uc/Z5ubgEmNM/3bi5C8Ik6HrrRdzjXI6R4uDisoT1lv61wy5RdEu5xryC9Ugy2f7AyjJSBOe5+sGIjDTJUQy3rYAPLw2RDrEquz6BAft0nAjobYTCOqsdBUH7mds9lSgzXYPWKO2id9SbHWGJWRnoGAo3yxpZhqIuljhTo7II/njQnNoUPSGA90jQ6XGD0lchVGuGS+PqZMe9uxq98gpjx/HTilXNw6uurKnKV4OFV+ItZZm4FLRM+MNmeKaFRKPKvlrFGG0tklijeNj2/Ya7eONLN4SNexB9Gm8PkY2gV2CUngM+u4evPpWXiAzADDpRn+qNsEp3BhWbvIBiuvwm1mxSyV+oNbx+A0iiWvHZgD5cH3Zq9gk0i7JxcN1T5L+S+DfeY6lxgn3bY3jviu+8afUL+VBlinKSg/knmQ2RqRs5ypkjH2L6pQTpI+U9YlFcJ+GrloalxW7xuu4uH9U0EDD8N4cfW1x6vyJKue69FZN5Y4sMKDYnVqRcX3NRpKFcMqmG+P4GKhk2J1gXaWlNQ/iftk9mW7xObz2dHuyUNieriws0ej5YLTyFWO/Hk/KRGmcpFeI/m9mZcdETn1hGg3ruPpjb6M2W8vxe3ePdy+3dN4MtCdDfVTx3BzEaSyy594ZRwy3zWjpNX3mptiUI7FT3PaVtRPZhWUianeB9mJ3nxs1ZOmd
 +LfP611p
 vTmYr4qyWvGwNfz2ucgD1YQJMTcnJ5T5zkCE4hgQtESu7Q9z24ygaO8u7q2cqLVLmaspz1jpwUY97jnhdK06LZ8k5HsIHgMSCdQfYPrB66oUrhTzM77yJMIAMGGToLzJm78RmyalUkMjw+8E0kINOlFzEUGeK0gdGTZ9gS15E2doW2kICsNPSd6KrUMwtKQAOBbQt8Dh4Uy3LaD8ZPxMxmwnoEc+uD9LNseE7Pdfw532XxIujE2l/CtLDHX8X9HmeOg54CQ+JB219QJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add MODULE_IMPORT_NS() for symbols referenced on powerpc.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

Andrew, please squash this into the last patch in the series
("mm: Add basic tests for lazy_mmu"). Thanks!
---
 mm/tests/lazy_mmu_mode_kunit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/tests/lazy_mmu_mode_kunit.c b/mm/tests/lazy_mmu_mode_kunit.c
index 2720eb995714..1c23456b467e 100644
--- a/mm/tests/lazy_mmu_mode_kunit.c
+++ b/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,6 +2,9 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
+/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
 static void expect_not_active(struct kunit *test)
 {
 	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.2


