Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250ACC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314E06B0095; Thu, 17 Sep 2026 07:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5796B0096; Thu, 17 Sep 2026 07:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB836B0098; Thu, 17 Sep 2026 07:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E72EA6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48F80120302
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:21 +0000 (UTC)
X-FDA: 85223010642.24.3E2FA6E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96B5FC0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DFUAoyAC;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644019;
	b=bLOO5wU/sECtY648Puc104BGz8H94gw7LiB4v8t99NRxV26umq0uU44GFtGK6cUys/GEkR
	xwzHTt8EvRmZwq2U1nwbpmwYLU+ckKlrN9+maOrsXfmowR6CY5zxFtaDbR8j0Vmn/THgWn
	1ZzZkvwe6jyBxZq0pNxe0zOIvFSoLi0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DFUAoyAC;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW1hZ5OhV7RR8U7Y0Wfaxn6tPBXe5YZA3XF7qJLWqlk=;
	b=q/iN9MauFJzu5hSbieOcImdWKQcK2WmPYKyjpaHZ8BuwEORv8JpUdlKmGHKqPEODvJ9b8A
	V4vguJ/gafF5dF1byUaI3pWaGOV0a4GnRGSyIwu8+FlZ8tacQZh9W+0ju8JCAtuwMWDjTt
	U1pkTDDGV1a03ZkbpQQOpz+HS24kXiI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C11E1F91;
	Thu, 17 Sep 2026 04:20:15 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 877BF3F7B4;
	Thu, 17 Sep 2026 04:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644018; bh=8FIDVRnmopNIAGdnpQIyQoSfJVd6Jc6AKeojxfKddjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFUAoyACMXV+je7j3KrKEcFwQqXT2R7/ETBB+IWWL17OYWl34QqpHPlTfqH5uxcwA
	 I2c+6eZ4SOFqMSowtcS7TqGVL8iNFR6pGPP8R5BQlHKm5IRxfYWadVw/FhlDBPKyfU
	 KAMveMSWQpFR6uuTmkZ6BI2+yoTc+Civ6jxP4PRQ=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 3/9] selftests/mm: mremap_test: fail unexpected mremap successes
Date: Thu, 17 Sep 2026 16:49:45 +0530
Message-ID: <20260917111951.188266-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96B5FC0008
X-Stat-Signature: e6hgam6kcf1pto7ihxi4xuxifmojsfhb
X-HE-Tag: 1789644019-430533
X-HE-Meta: U2FsdGVkX18YT1gGc+b2agF5irghhUnnasSJ49KcmgVUzBDZgekagL2c1ZESjgoQOm7ZfdLHMbf1Zr3cIhwJIVfymuZDmf29PoNu/JUuHwLhCt1r8v1v5vdFIVc8S4hM+s86aTO1K9F4gijmWlH5SRkVteX3d/UgHATgrDiWZ4gHz8iP1RBe4X+Z06i/NPCAtWe1r5KBEgzZwP13rdGD5FQ4xLV0ZPUBXG5Qlfsg5DAgxp65KGKe+imo7I+8PduMjP2nU+qwFhmY4p7DoGomX+zADzRfto3vX0ISv5p/31oUCm4P5Hc4IuoHk0yBGo7Lh0QmbeOcdMuBWThypgP9nEW1fcbSF7OIGauajG6v+7aCcTvQmniUmm2eLj7JmGHx5Rff/ZHzfWFh2Zaergvt2ySAg9ixlzS+aBkBZoKeDr7QZnRImn28siH3qM/3e4axSLA/EbtDbU+WUSFXykkhOr9HuQkP7VWIB1ahn9q7KRRi/mOz3Fa6EZ7O2plRWxC/J/m2a/SI8JoTC+GX+G9W2JFpNM3qj8ETMrHcVqYO9K8G7bJ3iYPJYvUDe6Z7+yW6gvnG36ZKic+qltoFg8cFp3SCAozC1D3OHTflmPS2DKTaFBpb93cHU/82obtt1YMLuikZ00iZ46/WBhtz15Mq5nJlwjpNZGxQeR2krevIHXJcD6y2iJTjXNtyLqjAxh85LjEyk8Af7CracGzGgsA2g6+NEmhYA/6XQc6Px62iUhNPGzE3fLFB73zB5WmvG3jJIVmu0q4WE84LrMcjP+oS7zLYiIlzeCNDU6TDh4GyhYcQB18DJWwx8JhH7tET9JQgfezr/fX3qqzN7WrDy3UDD0cMgVtvjOmfjwJgrOn7zLX5EfPDQ/CfalBE1LRKpPYIHMAESbQud7UBv3evL9RF12RYPuFG7IIJR21qHv3dT/Jni/wDRuQm10l0/dMuiBh4WfqeR3f8QhxRUTVSg7F
 ZG3oOLa4
 pjS38//fy5QFOOJat1KkSTkSOVeoqKraX9Lt8LmMEGshUoEhCW6xVw0jurAI88y5Qb0qdljjkqOR58F4JwmX0UPdjSCvfxuREmAb++c6+qum8Wz+nuwUThTrMc/wZ6857O7I8eT4uWbyk+1b1ae2F97thqvRyMt4nqbtqf90bXwHgXb7DNZPQaFG+NoX2NNKLLcRGMX0hX+sWGg862ojciG651P8XCFq7N3vYlz48E25pQ81Og8a/yNWujK7W1UWaCzoSS/w5mIyvZXqIjwEJKiwQIw4dyeAq52R+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_mremap_test_case() reports a test as pass when remap_region()
succeeds. But if the test was expecting failure and remap succeeds,
it should be treated as a failure and not a success.

Check test_case.expect_failure on the successful remap path. If
it expected failure, report a failure instead of success.

Fixes: 7df666253f26 ("kselftests: vm: add mremap tests")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index a5813a5e8f5b..ba9b7f7566d0 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1138,12 +1138,15 @@ static void run_mremap_test_case(struct test test_case, unsigned int threshold_m
 		else
 			ksft_test_result_fail("%s\n", test_case.name);
 	} else {
+		if (test_case.expect_failure)
+			ksft_test_result_fail("%s: unexpected mremap success\n",
+					      test_case.name);
 		/*
 		 * Comparing mremap time is only applicable if entire region
 		 * was faulted in.
 		 */
-		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-		    test_case.config.region_size <= threshold_mb * _1MB)
+		else if (threshold_mb == VALIDATION_NO_THRESHOLD ||
+			 test_case.config.region_size <= threshold_mb * _1MB)
 			ksft_test_result_pass("%s: mremap time: %12lldns\n",
 					      test_case.name, remap_time);
 		else
-- 
2.53.0


