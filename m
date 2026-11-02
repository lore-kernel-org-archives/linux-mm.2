Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07B260A262C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HSbNQsQX
Received: by kanga.kvack.org (Postfix)
	id E7CFD6B05BB; Mon,  2 Nov 2026 05:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55596B05BC; Mon,  2 Nov 2026 05:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92176B05BD; Mon,  2 Nov 2026 05:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B663C6B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D4D7A8AE6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:20 +0000 (UTC)
X-FDA: 85389741360.04.E842679
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2E9418000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HSbNQsQX;
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613798;
	b=YcQEDqwHWa00EZLX7PSyXBpfCZIeYf5cu9xK4R4AovYhskALcyTf0eLBlQsYDm/TMXvik+
	Omx06rMwSi575to3W4NFE9zi76OOs6znxPP+s8ubOcmwbPFjPmA7SMEUqwoGLiAcQuF0vL
	fllN6rraluTAOzlIeRneRV7c6UKXSjI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HSbNQsQX;
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8izb9PqMMklTelG/61RmKlhnMnD7pxGRQkRjnQiPA8=;
	b=khsbSZapwcgl6uZ0pGI79jbH32sCp1xfTc2nA79+hlJue4fWjOM1CuWgvgEAE3C7hCOsPG
	5s1m9vdMTyEHtJg4DcNAKApq0xUMG2a55AVBFeZCMjEyiV6Mq/0JKOuQsD4HRLf4e0jurt
	AQG0NveoW2HHmTRFWHyBKvpcNi25/lA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D61141595;
	Mon,  2 Nov 2026 02:03:14 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7EB403F59E;
	Mon,  2 Nov 2026 02:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613797; bh=oSxZOGxLsR5uqrMDGNEtoYyQjxBFtNAV737u1zMG5mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSbNQsQXgcbaVwap0bQgZKzq64AEwJIOoHUKDagnDKOxKb5pju8OFQ8PV6pUYWOXA
	 c1ZP646n16SLOVpvdDLPzMb9yZFAUKrVth7pr5t944JugwHSFOm3eHXss4Bv/H5tTS
	 rNg7v8RxjAdpM3AXtUGfHh4r4GI80sn9vmmQo434=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
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
Subject: [PATCH RESEND v2 06/12] selftests/mm: mremap_test: fail unexpected mremap successes
Date: Mon,  2 Nov 2026 15:32:05 +0530
Message-ID: <20261102100211.141831-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w9akjas4ioq4uzma4uahaw8hwiqqkneg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B2E9418000B
X-Rspam-User: 
X-HE-Tag: 1793613798-499915
X-HE-Meta: U2FsdGVkX1/2wsWMA0MkAUPwhYr3o8DonHrNsXLgLJ5u3S0qQ9oq7UM2eF+aMQjf9mC+Fi2wWmERrSfy2wap1diz6Go8EUwepZMUoMHvxJKHnQcik6+v7iSTkea9+bmeCBHUfdKvZUwfb+eKhiahjvDT7LZjwmZSEwKmWPLrKw1KEC3p0V7Bpfwc8IPANXy3ryFGkTFr+uTQKPb/cXIwB/GZEZwOuwGluRVuwx42xYgfIu8sDXuSykYL0gjFjaCPIMZ7AxCZQ91ARSQM7hDvsxkOmldq81vMqbXU69od2vKTpLkFN32GCEmYV08cnKTNwfiK+qjA+1AbA62HUBtFeWgCx/ESFJlYPsdMNN9sCVWdWtUnR1O+zsEpmB//SRbX3KuUSnc4cKDTPfiF0n7UXMgHI6lYUKo4MHHMznTOeO+z9y1GB3v/SZMdr8wfKCNxBUHBr9H1jVbIwmbZo5Xjg0PmFCkgHqCAdqvkyg6cKG0HZn0+ayDLPrx9OImwdM6ACUxr0KBDHzjbbFL4cbJ4EuSPXWbgHHwYpAFe0X76pUcEWeuSVC/hP/soAKrRk63KSu1fYlcJMrxxwusBy2TfLlmWRJrYuW/FsdqQeRg4mVT/O/Cw/Tl074GxdxLS7WDxaWsz5Mlav9USoIoxJaBtJSjXd0cDmecbU7Npi3YyVmsAHHbQQMe7QGyqPqRKjI1qFjdpiUIkzg2kfh+MWfloOpYkDqsg8VtUAG9phlZEIwkOutjDrw+SabYcS65R6v+jHwWU0TrngkZUGaiALARWXvbHDHyGBrjrMbKzSYJ+Mk1MEikamYlPjMU1w+PUeoKmOrx017QzS8iaqYEx5BT4GHZ/dpUMxWFbA+5/NtDId1u8WR5eGshgmlSCkELX8qHwHw7goOP2YaROJDySzjQgDNoxzYHnN0oxDgU1YQjqJHbETVgIqS47vmCCf2OH1SOnMUnzui2nEXFm+ydVeHf
 0ldeLjH9
 BpnCeID+D547L0V+61E88C+kTexE7y9XvjREL6xkf/qsn/xVLinep6zKFeANm85lpPoNPR/n1Tp24qVdntiPezaCIwF3IqPLRRn+bghFfqJQxoFEEb8IEHOSm9SQHtLJCc4x9jhEvRRM9gKmCAucjGhLrzyTKYSKqZoJJrTdW8PUqDy/2oIxAx+WiExi5hselmx2DwTSDn4BExelEzsxUA3crjmOvAmwElBBDbtYO9Es8fOXxKTN+u3o3wLhX+2+hrwQBwpAbAQPn8ejklQES6mvr2beYFPluWc3FAtgkYn9bOMK/vRaoEsRFUp/+E3ljMXM0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

run_mremap_test_case() reports a test as pass when remap_region()
succeeds. But if the test was expecting failure and remap succeeds,
it should be treated as a failure and not a success.

Check test_case.expect_failure on the successful remap path. If
it expected failure, report a failure instead of success.

Fixes: 7df666253f26 ("kselftests: vm: add mremap tests")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 5b3ab12c2207..111cc3414073 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1124,12 +1124,15 @@ static void run_mremap_test_case(struct test test_case,
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


