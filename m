Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAC9C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE496B009F; Tue, 22 Sep 2026 22:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F896B00A1; Tue, 22 Sep 2026 22:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75536B00A2; Tue, 22 Sep 2026 22:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C45F6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:31:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3C351A05EB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:31:46 +0000 (UTC)
X-FDA: 85243451412.26.88FABF0
Received: from out-2z4y-a139.jellyfish.systems (out-2z4y-a139.jellyfish.systems [198.54.127.139])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D653A0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:31:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=IwvCtPGS;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.139 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NmJHuTnYwRJLDD5IFTn5S7aIbzSeEjEGBUsClZv5Uw=;
	b=OEZDdvyndn7D1/iBFK25zMwZZ5MU+WUG8XQVEnmWachXrN0un9PRF5B9XeZbseSw2GloDi
	VRnbguhSr+uFaTSsEMceTKsYYdztGrPjgQGhoF7559iJnMozUQiaC6EJM7Clv8vdhihvwF
	o6kFm9MdQ6pS7Wc3uU58gC7G5kso51g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=IwvCtPGS;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.139 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130705;
	b=gpGE877L0gWco0XGrHHPuL3OOKEP3cWrhmbAVLO7APCr6znVQFUxQGX3lic6vRfCBV/urV
	buoLftj9lgzJaC5FfaBSiKdSQXLKfzLk4skhiN93dTFllApeMAxXUooUFaxaxubijnIjBf
	9Zg5oKvW0nqWNWSBQAIAx/mRwOVLy+M=
Received: from fedora (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLZL28X8z8sYF;
	Wed, 23 Sep 2026 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130700;
	bh=4NmJHuTnYwRJLDD5IFTn5S7aIbzSeEjEGBUsClZv5Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwvCtPGSL00D6EVhxp68pIUcsDF5v/TCpS02ROzmyWaN25dgQ/w7fM2ZrfdIOyv3Q
	 XE/m0L+SQFLr43XtMEAPrOJxawXXeYRa2aNst48Hm4dtwVm6yk67eJqpC/obEFO/kz
	 qP/PvcvOAgPx2H6lrvK0FaPVSiszRg40gqSyJjOLd20zDBjXPWdpUT+VG1vfeyyr2J
	 TDG59e/VCES1uW4qtNUyumRAvdMOjjpK2e0L3qcRw2VpbugDhWsLIdU6RV02gRk4Xx
	 AndLiO9jGTt945vGT7VWgW8i/nI6P6PqLdKNvqJ7MVH6C/7ILnrJN6W+tG+FQ+01ko
	 pEoYBQNoMcQjA==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] memblock tests: use physical addresses for region removal
Date: Wed, 23 Sep 2026 11:31:23 +0900
Message-ID: <20260923023126.1910311-2-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923023126.1910311-1-hi@tychen.cc>
References: <20260923023126.1910311-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D653A0006
X-Stat-Signature: c341r9bdpabiuxmtq8e7k9ctq5ra9tyi
X-HE-Tag: 1790130704-81417
X-HE-Meta: U2FsdGVkX1/PLsqYP59xWP7bLhk7J2+mdyHCnndH2Ypo0D5jwRFtEQYJcsciaX0OV/tv18i30IiVliqfjDtC9yMt8YF/Oy8mWec5W1408mFYxRfAaFb2gdbVFA7CcI/w79uP/bhnV6O1/SFzOeEPEixT7qRoezGmq5VvpiBdr2rkykAcgJQZsN54OrpQqPJm+3Z+SGdE+yYT8UDb4upaOlS11HgfxyK5smsS8Z8J3FZXdqvaIjB12j7nGWl6TWfPPGHDf2yYT5CLJLQiNpIqRFWSNE0qJ4DxPj2ZlC1Ascf/bhwn8f4vboBsYDUrMMWobnDaidEOKsOm4MxHunT6mK+PCg4B9AeVP7EelT54xobSIfE4UTg8ZRwUT7Iz9yEgdcyGrnhDLWTuIm6lbRw+VMDiZkS2PrT2MawqdGRLge0EbpsLsaTlyJruEzGL1+2NsvuR5k43qXcw5tjJLdxJSWOgGwUm7CzQuOr+VQK5kyt5GHRa16D5HDq/lelwgiPnDQ2exWOJyq5tpasYsu5aSC9Q/Ad74CrQWiVIvjCRew5FFxXLNcPaPI7O6YPYYO6JsmzjUiqxoCw1OCpf0Qiq7Zf5yG8iRVXlf1gmL7PPnZGqQk7vUE0TqMd/oKkLwz22piKANrgvgrmRbJ/CyEV8pGFsiOoh5NFTr4f/zVMAFGBtMznhVngl22hAApB7OizrZofXr+dGCHGQjzy3zrhc2vNrs0TtwXy1pjvaT/Hs+1kGCPr/JdPbs7pxRpPfSDO9bu94suVAlFAp+euNVDrOyq11RCDd6sYPXI3p7QIpU9GVNoAKMaspnTmML2r88hHX0nU+/UDTBfi1pg5Mx/OXcXOk9HVm+s3hiuw8kv49G8UXkCnfUZAKbgcLhRU4swHzWIKa3P8lkXud8U4FOXB7hf/OTKoWFB4Uj5N4DRHfLkDUGqCQ32k6fBeXWRbP5Qetcnn13vmLRXP3XzCD78Q
 p0Vc40qm
 U4+gNLNDYfmYXr2RZDLg6yuejuAH8AYvksWKJCmV7LpO5kf1eOIShGr1TRYKeKtqK2ayZ4tWIh0kpYd2nv2vf41pk5glS96TGil0V8/h8hexC2Ac7spe/9OqbNJ8vCpfL/BSl/CfTeyOeBvMQqC9KpW5VLY8k0Re82bHPGxUZu+4UBjT+y/qPj93u0FJAePshh51Ivrz4tk28gFjS2mFYBC3cyhft7qvHAieMga0Em01J8VUE/wPTyKxu2c4dwAH54Ke0N3RYGfrK29pbU3MVy+WCHguqFTSNq8GneowK1JdLG+IYBjJb8bDJKOaZ3Mm99N0f+JYlo4bw6y/bGyvoEUJ4dhNnXEsG4nUS5TekME6/AV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With BUILD=32, phys_addr_t remains 64-bit while pointers are 32-bit.
Casting the address near PHYS_ADDR_MAX to void * truncates it before
memblock_free() converts it back with __pa(). The reserved region is
therefore left unchanged and memblock_free_near_max_check() fails.

Use memblock_phys_free() for all synthetic physical ranges in the basic
API tests. This also removes the integer-to-pointer cast warnings from
the other removal checks. Retain the checks that freeing past
PHYS_ADDR_MAX clips the removed region.

Fixes: 21a233f68afe ("memblock tests: add additional tests for basic api and memblock_alloc")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/tests/basic_api.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/memblock/tests/basic_api.c b/tools/testing/memblock/tests/basic_api.c
index 01e836fba488..47bcdcc115a5 100644
--- a/tools/testing/memblock/tests/basic_api.c
+++ b/tools/testing/memblock/tests/basic_api.c
@@ -1730,7 +1730,7 @@ static int memblock_free_simple_check(void)
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
 	memblock_reserve(r2.base, r2.size);
-	memblock_free((void *)r1.base, r1.size);
+	memblock_phys_free(r1.base, r1.size);
 
 	ASSERT_EQ(rgn->base, r2.base);
 	ASSERT_EQ(rgn->size, r2.size);
@@ -1778,7 +1778,7 @@ static int memblock_free_absent_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r2.base, r2.size);
+	memblock_phys_free(r2.base, r2.size);
 
 	ASSERT_EQ(rgn->base, r1.base);
 	ASSERT_EQ(rgn->size, r1.size);
@@ -1832,7 +1832,7 @@ static int memblock_free_overlap_top_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r2.base, r2.size);
+	memblock_phys_free(r2.base, r2.size);
 
 	ASSERT_EQ(rgn->base, r2.base + r2.size);
 	ASSERT_EQ(rgn->size, total_size);
@@ -1881,7 +1881,7 @@ static int memblock_free_overlap_bottom_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r2.base, r2.size);
+	memblock_phys_free(r2.base, r2.size);
 
 	ASSERT_EQ(rgn->base, r1.base);
 	ASSERT_EQ(rgn->size, total_size);
@@ -1938,7 +1938,7 @@ static int memblock_free_within_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r2.base, r2.size);
+	memblock_phys_free(r2.base, r2.size);
 
 	ASSERT_EQ(rgn1->base, r1.base);
 	ASSERT_EQ(rgn1->size, r1_size);
@@ -1976,7 +1976,7 @@ static int memblock_free_only_region_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r1.base, r1.size);
+	memblock_phys_free(r1.base, r1.size);
 
 	ASSERT_EQ(rgn->base, 0);
 	ASSERT_EQ(rgn->size, 0);
@@ -2003,7 +2003,7 @@ static int memblock_free_only_region_check(void)
  * Expect the total size of reserved memory to be updated and the counter to
  * not be updated.
  */
-static int memblock_free_near_max_check(void)
+static int memblock_phys_free_near_max_check(void)
 {
 	struct memblock_region *rgn;
 	phys_addr_t total_size;
@@ -2026,7 +2026,7 @@ static int memblock_free_near_max_check(void)
 
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
-	memblock_free((void *)r2.base, r2.size);
+	memblock_phys_free(r2.base, r2.size);
 
 	ASSERT_EQ(rgn->base, r1.base);
 	ASSERT_EQ(rgn->size, total_size);
@@ -2086,7 +2086,7 @@ static int memblock_free_overlap_two_check(void)
 	reset_memblock_regions();
 	memblock_reserve(r1.base, r1.size);
 	memblock_reserve(r2.base, r2.size);
-	memblock_free((void *)r3.base, r3.size);
+	memblock_phys_free(r3.base, r3.size);
 
 	ASSERT_EQ(rgn1->base, r1.base);
 	ASSERT_EQ(rgn1->size, new_r1_size);
@@ -2114,7 +2114,7 @@ static int memblock_free_checks(void)
 	memblock_free_overlap_bottom_check();
 	memblock_free_within_check();
 	memblock_free_only_region_check();
-	memblock_free_near_max_check();
+	memblock_phys_free_near_max_check();
 	memblock_free_overlap_two_check();
 
 	prefix_pop();
-- 
2.55.0


