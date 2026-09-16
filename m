Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F7D9C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97BCA6B0093; Wed, 16 Sep 2026 12:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC356B0095; Wed, 16 Sep 2026 12:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC9A6B0096; Wed, 16 Sep 2026 12:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB386B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:11:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0F3C80693
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:25 +0000 (UTC)
X-FDA: 85220115330.11.CAFAA50
Received: from out-zbxj-a91.jellyfish.systems (out-zbxj-a91.jellyfish.systems [198.54.127.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id ED770120009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=XgObANkY;
	spf=pass (imf29.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.91 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789575084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCqoXqzY/l2yf0K3cWyQLdt7Osw2JWTjs4N/s2OK0JQ=;
	b=Pnz26Pi5F6+I77f95yHujgJHAKJzGKPGq/usC309r7YargFGkSEsdkJhGUKvwxK/soM9Dk
	0ORgNp+05ZxLcg4gupHgFDscdUAGNm9Et/ktnfTO62+9DPg0KzUfr+g6lSj7uwa3F3WzZV
	i0wlz+FMr7MqGjieDXKrpABRj+5Z1x4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789575084;
	b=rMAATj49TR/lO160yFP/Gs+O0T2GuytYIDGo3RuQUKGS2Jbqxkqq0DUZvvpTs6uvaTjy9T
	YoD9XV8NfTO/AHejbanX/wTJZ7Fyvs0jBoStn5AowXJEMmuBFWlruErTFJx4RLH2Fo4CM7
	GmY37Kdk8G1GaWjpOyNkdS7pr7wh7cE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=XgObANkY;
	spf=pass (imf29.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.91 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
Received: from fedora (unknown [117.147.120.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hlP5L51yBz8sXL;
	Wed, 16 Sep 2026 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1789575081;
	bh=LCqoXqzY/l2yf0K3cWyQLdt7Osw2JWTjs4N/s2OK0JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgObANkYFXECzxCScFkjtwE5q4sLYByt+lsLlpzM+ipo2nW/ZBsmSYqyM/NISCXs8
	 JgLExKMucXFgr1iJxJEWGEb2l1fEBJjbGaYGiValturszHmyJXTYVEQ3crt9QRV0Nx
	 M9Kg/4I4K+nwoHAMJ2ePUKD4eIp0OiTkD5eIM+DpFp5kRWMq9p8+z5JlDWQfptMS8G
	 wms3BflkQ5eR7Zx+KMdkgXBSJ8hMObMbhBclmPTISfq3VphaQVOhacesLqSi5pP3oX
	 Z92xjmYTBcBLIUrzevMA1+0YYxcFvxMElx+Il563T1uigX3jKfaxZovpcxvAV1w1Oi
	 BRdqgHibuxSLQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] memblock tests: use physical free for the maximum-address check
Date: Thu, 17 Sep 2026 00:11:04 +0800
Message-ID: <20260916161105.2548281-2-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916161105.2548281-1-hi@tychen.cc>
References: <20260916161105.2548281-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 958z96hpgspy4zq5cxzpa1ohimp84hnm
X-Rspamd-Queue-Id: ED770120009
X-HE-Tag: 1789575083-447083
X-HE-Meta: U2FsdGVkX1+pfLaPFNN4XCe2GOZD0pv4YSm+niz0vVUy862F15Nb51nQH7p2kvq+0/rfZSGN/A+MF9dKahDP1Nv/pfcq0wFjg/COcu9K37MC5Cyod2iyFJZRMByPIlfJEXBOXS4KOdAaK0v3sFx8SQ34xMOAWH6elS26SvzhjoZQXRefNkeAkorfYaKraClvJYbDUVP10qPwedXdSJZ+1hgPXhW+x0uOT1cAOi0N0WFNPOZ60SR0ysVlx6AeH8BRFvG9UvmITmfsVKfObaIjECtlBs21crpP3Gr12OWwAC+JXb+opkFUhSaJLzTnFqdGHtWDpRAng2V15jvlCHKtneLltL5uga2klUOoF6G+y0S1AuFihYpEPgE6RS3NkV6ZFdgPXwYNzP9BvuaPfGhFq/Xvs7Bjm1xY0pyAr2c0OhjM6aXNKme7P1XYUbQBSJtXKG4cD+S+R0N5LuqYWjl8zmPcgMWMbOYMi5i6gYy7pRJUx4ILIZF1dRpkjDXFZFhfle+uLWJS6GzkTBNXLC6tdNtjTLQgKy4aG8AuTp0q7FS/b91L69NDcSjfekwjirbYlEjt/ZVXjWUD5pCgA8WxHbgmRNHyX69i3kLgI7HrPn3YExCIzr/xmV3oWgZs6MEzpS/+ufLs934lQD7edOFhTndG8shsiQ0keLa5gUuI0LmrYTHU5Pg+QDfJqVJn9VsFvZ/5nj0Z1Jdp4WifIPSz8PPtWdw53MMxGLi2fwoQ8HKKjWKFMx2n5HYXcj3b5VzKIXWG6fktN99TrrlpoU7Lf8BREFLvybaQ1DerVOLUCF9UPYo5+uOw1aJXf7eW9ClGpYnGnIS4vGmJSFgmMXbn5lanFWZb4HC932hdGLerwSdYj7qfTiCX4hcrx08ZVqItlaoHJgcFhnmLzEEYalYkk5o+jR7us9JEWvwZdDMNPUor+Rdn5oQiDp7Vhfydid4a/5mdUrnwfc8EHkIxc4E
 PKmSWIoi
 BTUEYz5Fgf9OqethcsBrAhIFXmF3GF6jlynWa1Jr4BWs6/KUqu0DHOPEbArAAjSPJakredSk0TVsk5R7qnyAKjb9wDzi+cp1SohRuXXptNzGXH9EhGuhA2e55y/+Z6OM9OSG5ZqjEAafSzo3szkoPLx22jjClXc7zw64KcsMTJuG/Hm/5v7TESx+gF/3GsKilwtFCXnMiZ1OYPMXgJdPwpLJiDhqaZQAgYAbA80X3d37D+8Wk4DF9Y4dCPDK4zq1tjRKptH6gmDdc+qr/7b07m+L/j1ufUk1efMTv07lJ029PpYSUY0dmi0NKqKAEeQ+ChtRSgOxzbFTLK1cqthYsTxdVy+pXEStxbNKD
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

Use memblock_phys_free() for this synthetic physical range and retain
the checks that freeing past PHYS_ADDR_MAX clips the removed region.

Fixes: 21a233f68afe ("memblock tests: add additional tests for basic api and memblock_alloc")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/tests/basic_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/memblock/tests/basic_api.c b/tools/testing/memblock/tests/basic_api.c
index 01e836fba488..dfca0153b6b1 100644
--- a/tools/testing/memblock/tests/basic_api.c
+++ b/tools/testing/memblock/tests/basic_api.c
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


