Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 226FBCAC585
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2D48E000F; Tue,  9 Sep 2025 02:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7832F8E000E; Tue,  9 Sep 2025 02:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C6A8E000F; Tue,  9 Sep 2025 02:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50F428E000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:16:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1121DC03A9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:16:02 +0000 (UTC)
X-FDA: 83868701364.14.DE5030C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86179A0012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:16:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RwX4fAJkTt9sLeZk71RnTxTl3BiNMkS7kiEs3tBnt2Q=;
	b=jyT1fAyXEo/RHD5lRlKOtTATpSnVZUv84RKnuxDlQbl+YyvXbnAoSS2cJal+/NC/ja6c0i
	RNwQ6aLd+trhK798/r0fghNo2vLCyWoB47Fz853GzV23c24Ie26aPDH9+rGQc9EfO4vcA3
	hwyg9vLvhpFT1PhlB90ZiwjiWD91uZs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398560; a=rsa-sha256;
	cv=none;
	b=zhA8+woKqQiin54/viRhSCdrU1jSHRH+nNKNZIRJ7zZUK/jEnW/qvyufCeEkZfAI5GbmZu
	AXO7T1ddhF4A3CoqJ9gJ+HhdJ8ipuNHZ31dKaDRccvzihtaSJNR5noOVzH4RjSXMQVpdZT
	NBRNSWiVkj0sZ97mpMGK7kmuEVvdeik=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32773168F;
	Mon,  8 Sep 2025 23:15:51 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6B1CE3F66E;
	Mon,  8 Sep 2025 23:15:55 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 2/2] selftests/mm/uffd-stress: stricten constraint on free hugepages needed before the test
Date: Tue,  9 Sep 2025 11:45:30 +0530
Message-Id: <20250909061531.57272-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909061531.57272-1-dev.jain@arm.com>
References: <20250909061531.57272-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86179A0012
X-Rspamd-Server: rspam05
X-Stat-Signature: akcb58gyqw6ua77he3n74ntksdqa4fnx
X-Rspam-User: 
X-HE-Tag: 1757398560-166256
X-HE-Meta: U2FsdGVkX19/ZpQF13fLquivT2f268bu+YEJQ9wjvpq7C7PrOBU5vBoVJAwhU6IPwniuAGgh13iPDvWVRkeFgIrMivnDowf2eE2NKcytwUeZtyHcmZ6NehV6sk6oEUBYlKrj4kZP2NpyM8tRkIhEa5uiPNm/hLoQ+Knp+IbXqkQzL2BchIk0bLfaS26eXPoQ7eUSErzjdd/GxBZRX4A0anhDjIgR/ZPcRrJKpnf/Bg+AKYESFvsvwO3Turq2S/F1LVo83eNByNDtS7TOiwPgVNw6qsLFDWxGvvHFQGtLnX4N54d8OvRNpJhkFeRCscTC0hhjnsykWh+9je89NUTkYnN3UdzDcdw/frD3KK0PHnGrZEDy3y7YSnLFKefZVcNxDx/8C0v9qLSzvoGbo9t4Rv8Wz/RhG7EZkLTP9+OVP4CEZSrjB8QSIYR9wDQ/lBUvDql+lA3CqjZJIZ3ZVce6vEDG3d3qwbW7YB4myoyjL2x3O0zqxyLdEWZT4yOWNNvKRC+s7CMTpwqsIeUa7akjTQsUXSc4wb9twvnVGHyA9pVXl/q8sWyYeBAHikrA/0KXuFRajlbTaH0pYT64yT1eqG6xvsQnDfx2i9XZq/GhSQ4mtrd+65lkNTWMILyALCHdrfQiHmEuHv8aClgFkrxwdCgLMXpKKnmu9JI7cEIk4C0cir0ZRcfbi8bJeoruXwagpsO1MUu9j7xj/vQKdhh3njSJKJmK3Oxy5T3vJ1N8crXi/7ir3RJsduaQZwES6C+ksaBxmxk1hEfC8AmScEfbZVM1zyfVT5Xg4+IJBqqygh9W7nkvW03u4PyoFJdCUl1uMZ6wexXmaiHLwQpBJ83KKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test requires at least 2 * (bytes/page_size) hugetlb memory, since
we require identical number of hugepages for src and dst location. Fix
this.

Along with the above, as explained in patch "selftests/mm/uffd-stress:
Make test operate on less hugetlb memory", the racy nature of the test
requires that we have some extra number of hugepages left beyond what is
required. Therefore, stricten this constraint.

Fixes: 5a6aa60d1823 ("selftests/mm: skip uffd hugetlb tests with insufficient hugepages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 40af7f67c407..3f6213ae0dd5 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -448,12 +448,6 @@ int main(int argc, char **argv)
 	parse_test_type_arg(argv[1]);
 	bytes = atol(argv[2]) * 1024 * 1024;
 
-	if (test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < bytes / page_size) {
-		printf("skip: Skipping userfaultfd... not enough hugepages\n");
-		return KSFT_SKIP;
-	}
-
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	if (nr_cpus > 32) {
 		/* Don't let calculation below go to zero. */
@@ -464,6 +458,17 @@ int main(int argc, char **argv)
 		nr_parallel = nr_cpus;
 	}
 
+	/*
+	 * src and dst each require bytes / page_size number of hugepages.
+	 * Ensure nr_parallel - 1 hugepages on top of that to account
+	 * for racy extra reservation of hugepages.
+	 */
+	if (test_type == TEST_HUGETLB &&
+	   get_free_hugepages() < 2 * (bytes / page_size) + nr_parallel - 1) {
+		printf("skip: Skipping userfaultfd... not enough hugepages\n");
+		return KSFT_SKIP;
+	}
+
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
 		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-- 
2.30.2


