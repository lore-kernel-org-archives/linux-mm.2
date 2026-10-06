Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 986F6CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8FE56B00A5; Tue,  6 Oct 2026 05:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67806B00A6; Tue,  6 Oct 2026 05:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E006B00A7; Tue,  6 Oct 2026 05:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74B546B00A5
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A166A05A7
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:33 +0000 (UTC)
X-FDA: 85291668546.16.23291ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5114FC0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OzD07csJ;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyriqiAYxXxXrQ8ApAc7aysVDOHUswxyOiWslfj6F6Q=;
	b=F4s904SBh0or+uPEt+zynHkgzh6qJAK4iVv8fuZZBgOvcMj8B19suZIbkGXPx/f9yXyVJq
	DZbzPtPBWji800zX1g7+jIfEqZ9pvgxA6ldQ2tCrVxlZ7/yE04GiFJnkUAx/6Kwyv5r73b
	poJ8CcAODf7w2ma/F9Y5Q8NcrSHnelg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OzD07csJ;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278731;
	b=pvClNY/AXi9F6XsukOC/jnaphQC12C1O21aEgdXghL3BZSh8/asY0PMHTfbAesIwo0Zlrs
	cF8g+wjKe1sUku58Da6lXQFX848dnOojOHm62fyHo+Wm9zzsU103/dhDg88Y5bzafFvwrc
	xrce/aHcrmxfTB8bvXc7IZDbe0pG1AY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F210B152B;
	Tue,  6 Oct 2026 02:25:26 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 178663F763;
	Tue,  6 Oct 2026 02:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278730; bh=rT9dP+qi1lu9WTSbwSfaqr1GwJLKLuxgpDVmof6dow8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzD07csJ+pYeoO5LCpdCLD0TEiemxhh4995NGck9YbzWvxwT+Sew2JezCs0TC7JQM
	 mnliVHtWtjBGb9mF9gSqX9OVrflKe//lmOQ5gYSM78W5wPc5/hrk+u/850lVFEJjXV
	 4ap2PA7jVe7uhQs8ROOhK4+IeuEMli5iGMK11cHQ=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 01/12] selftests/mm: mremap_test: remove command line options
Date: Tue,  6 Oct 2026 14:55:00 +0530
Message-ID: <20261006092511.145776-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5114FC0005
X-Stat-Signature: yhhtk7zc3q1qyoxu6igebx53p7aqrwcd
X-HE-Tag: 1791278731-670949
X-HE-Meta: U2FsdGVkX19m4u1nBUICvNSdbdEZHlNBPVLi24+KDr1DDg+KqyJ+xT8JiTY9dPEEaLXjD9dBccmoO5KC+9BmM7Glcb7ZpTrAjQK1+4394GBuqF+uyR+tQtRFZFNi23MI6ACyXS9hXOt2MCc0/LyZBIkE9upD+dUrhMtXt5NhBZA6i9E7r8LmyoWTNoeWU+5X3DE3iA3PZHFpSRH3XU9cNxMKjTHFpErPYAqfyyxat17tGZQV0BhL7U35r4zCjWk1a+b9s2x3/G1l+wiohXal5UK1ccJrEVYkooZCiP5Tb7PQOHQdSnbZ1jfK7O2AqhahzgiO91G+RYyK6clO+91ATV8KsIJ5ptnpniKCFiwLYDIC6tYOk6kg6d3ZhcM8vAYWuXQPA7VqcJZlIijHZuw6zg1mVUH32gkntLVlqWV3XefO15aI8qSk2/J5fgCLDKgKIgPcTwsGuwBS7Qy6iCUt5EHk2caS4jfsd45ZCHkGpPax4gGRay7CIACxZTKJ22gV35mqfT2UqTrNiV1x5OrrrmCTUyDF2YS2VyhJbS75BAblmvZBxDhszW8VOMVZNEwUKubRR9csi9vuSaTUAe5f0TjMMyMEt1gRmjZ+fDAg+L3vMhYlaWUpDuLa1akalI7YLctELn4imFxFIVZCw26z0k0/oIzR1UnaWaOGZQ7SpOkTbrOfbM1n4LO8LZ0LlHKHdOwg58NWID/YmyaX6bu3hfHSYdXcwrYj+3zI+s0RZqbEXDAlBrSRfNaWS4hlqEns+zUPff9Ukazm8GGTzVXS0Ql/Gml/goQPU6s07TjogvTDoNS7CFlBNCtfseyXDcZ87zcfv4vXlLG/2X49CcoiM6v3IqKxo3rxeUJLGXkmydbCnqD5HsMEgPmvVdNhFzQ9LoTCRM/wjfjdmzgArTDNtbChG61LT/anIXeQ+0oHSP6cAf/b8PVaGkmzYpdFvDelhE6yEoatXtHv568praX
 isGEIKNJ
 H3b1brJO9dPpBxRyAby/K3GQPp2cJRJvTzmXz6xCJyECOh61ecF25LKFcyLGmek64bs6DEK5h8+Gj9NmE0MCDpO8s7muH5108X/lOyQpTgwbjDbKeYh0AudxmatlhilOZ44dUG+njpxIQifxb7QWOTh+3rMOW3OLRXm8xbgojIX+gHbEVVUuEbVzIOaFwurmxFJJEQH4YGg+OxJTYTl0tuwUGFwDfHpaqjhjxRSq118L84fwdTTWNX7eRbhhloujc5gdZDP0vtQ+QALBGPxSmwd/eWz0XzKUNdEZxEHzWSd3H8FeNHyKFItK6ZLqHdOhr3V1Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test supports command line options for changing
the validation threshold and random pattern seed.

As part of a larger series to remove validation threshold
and randomization, remove all command line options from
the test. The test is already invoked without any
arguments in run_vmtests.sh, so no runner changes are
required.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 45 +-----------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 97abf4713cc5..41f211c39c83 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1188,49 +1188,9 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 	}
 }
 
-static void usage(const char *cmd)
-{
-	fprintf(stderr,
-		"Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n"
-		"-t\t only validate threshold_mb of the remapped region\n"
-		"  \t if 0 is supplied no threshold is used; all tests\n"
-		"  \t are run and remapped regions validated fully.\n"
-		"  \t The default threshold used is 4MB.\n"
-		"-p\t provide a seed to generate the random pattern for\n"
-		"  \t validating the remapped region.\n", cmd);
-}
-
-static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
-		      unsigned int *pattern_seed)
-{
-	const char *optstr = "t:p:";
-	int opt;
-
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
-		switch (opt) {
-		case 't':
-			*threshold_mb = atoi(optarg);
-			break;
-		case 'p':
-			*pattern_seed = atoi(optarg);
-			break;
-		default:
-			usage(argv[0]);
-			return -1;
-		}
-	}
-
-	if (optind < argc) {
-		usage(argv[0]);
-		return -1;
-	}
-
-	return 0;
-}
-
 #define MAX_TEST 15
 #define MAX_PERF_TEST 3
-int main(int argc, char **argv)
+int main(void)
 {
 	int failures = 0;
 	unsigned int i;
@@ -1259,9 +1219,6 @@ int main(int argc, char **argv)
 
 	pattern_seed = (unsigned int) time(&t);
 
-	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
-		exit(EXIT_FAILURE);
-
 	ksft_print_msg("Test configs:\n");
 	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
 	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
-- 
2.53.0


