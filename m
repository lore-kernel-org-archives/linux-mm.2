Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81B6C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEA96B0095; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5ED96B0096; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8376B0099; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58EC36B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C67691A0212
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:39 +0000 (UTC)
X-FDA: 85247455398.08.BCCDB9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F42F120005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WPI4qLvw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW1hZ5OhV7RR8U7Y0Wfaxn6tPBXe5YZA3XF7qJLWqlk=;
	b=3hIOf1jCYWiqzWwJuVskqFSt1BiJi1Mnqee6CWrNebniG5o1Tgy9ERz8BnOxZbiracFXAo
	Eock+CdvVLfKutrJPj2hn8qlwC/NRBn4msKf2+IEgcFMnRXxgjVlw+ofIcnrXP7nUWamUZ
	/ZcvYKpBYaHutXMOFkzfsDbHj2U9E/8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WPI4qLvw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226038;
	b=SGfnj2pAA3bUXrhySEnFeppy7QVvIsP1VFfyWYCnWq4L+cIk3oUnYuqiqPb8jjDJx/8SHy
	Edn8u0BZt838dBW2ddBEILBPrmaWh/hvSW07nVBQpRxj6iybzzhW0dTGONigrl/bIE9SBM
	KFReSI4KY6oqT4z3vXk7Hrm9bTYsOA4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95EF11682;
	Wed, 23 Sep 2026 22:00:33 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C1ED3F86C;
	Wed, 23 Sep 2026 22:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226037; bh=8FIDVRnmopNIAGdnpQIyQoSfJVd6Jc6AKeojxfKddjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPI4qLvwdUzdDaAcHsYAnuy46GwN3Scp+FIR9nAF8J8yclUql//QYe1+s5aFc7zvD
	 X/ZhT7lbND1uaA60GzejcJFO5ly9j1U33hHCgBzWA6BwGZ2jztR5JpNh9RdWVyhq3J
	 uH2JDurHmjmfc74vC3p4am9hwXvvm/FM3KAYKEQE=
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
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND 3/9] selftests/mm: mremap_test: fail unexpected mremap successes
Date: Thu, 24 Sep 2026 10:30:03 +0530
Message-ID: <20260924050009.19974-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rstcfbpiaekgr816qkp3itpcn8xgn3t7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F42F120005
X-HE-Tag: 1790226037-132224
X-HE-Meta: U2FsdGVkX19wvw277FiHh961BMjeslcostO593a55Wj0wCooxVtY5+nmAYTiESvJURNCFxewrH0GtnzzdVk0eZO0p1efbWM6b85DqSdcmPrSaImOQFAuR4D5j7wa78pBi1rErcRHJau2efWi4+lQPxm+AMrXLmJ2srEf+Lu3mR9dbz18dFmN5rgiiEA4xUKv+sPamB7HAreGBiz3dgwMyv0D0G+4LaVqhkk/QxCcRlgV7ZgfQdg/qna4xq6gOS42y9MVAIPRn/Ywl+uSkAfBYZDW1MpevCDNKKdH20t/P23UvAvzoh1cTxXR+kli8CoVySsiJamqiZVlnJZ8BXSs7MkOPk2YBDvKu4j7C+ldgfXoXgzFNi/Bn1nGAxHn19l77XMeOkLQctAsr/TsLh+0SAkVqpm1Z8DT4+EEQOlRcZczbReS1HKKiLhKRnVSwBlTxn6U2VOA8oDHYOxRjtQOqHISpJrjo2mS8mVEqxRpCVtAvVo69aVn9SNAmJdCkkogb4v+21K127t5o8yx5k5IwKoIApiNt3eq2AIR6ZrHR7QLL5M3NPMzYf6Q1o0IZcbsIVe40tlnho3XDONy7UF3KJU4VnjGOp1RT5QozSyTy47R85fx0Hb0Mbh7gMINyDhu9IRxj+WfKAjK9/PpuJIGmAFCz0xsSfGUfQk2f8YEGR76TxVUZOfNXVLRmI8iMdScs3Ep4itrj/mp01rBB/jTPz5W833WLw7XwwpZpwEkfUg8CrDXJC5vKKC0o4B36gg6EmaYZ5IfntAonSx9YUMSGz6u/SZfHP7TP/iLvjabfU1XzE1dt5uVTT/SD+LrXPRzCvgy3J9DfBcsnlqjLHyujhIl9HiDn+OH593ZWe254pgbIh8lAJzIW6O+m3YV0AoaGBVpV1RtntOcQpk99qxHfLdgE8/XN67UWuksDFjJ1nWs0X2Mkdl72YQwI8yxEHjRRAFXJff/+E6rp/PLr8S
 4ZS+Cj8l
 ic9ZxHBLe+y4cfDw8sgWIIO+eHy+gKNbeuFpsJ7UlYxFDRQStOLZtOj0nT1A9VfmWB5uf3fhHKPjrsztkHAM+GvneLUGQ5l/AOaL7Pv7JjNptI471m8Qqn+w0SAwyNJn3viAANbNoOcj2TfEAalF1lx94zs+wqvW7dyRHyMI7WB21nBwxaMwbfyW+qGAZVR5UWpM69AHgywiBjnVigc3ndyh/W3qp9ANCFDZ1boADfy3XM1bMm/OHx8Zign8CJ6WNXoKvNGSmy7PDhsQimK8c8wc3Jvoq/5tYQChH
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


