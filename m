Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAD5C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6AD6B00A0; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431BA6B00A3; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB786B00A4; Thu, 17 Sep 2026 23:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F02846B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AB6C1A055A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:04 +0000 (UTC)
X-FDA: 85225527408.22.CC81633
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf20.hostedemail.com (Postfix) with ESMTP id 55B0D1C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MhLMeKEF;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGEA7g9C3seBG7Njk9iXotctiOXVjOvcLMoVwj7oXRY=;
	b=ajGVrLYakneqMZCRFlOLbxM4V22zg4MUnrbRJ0WJ6olv4i1xjiKEYvO42vHgetTXickDeQ
	dqhXX448zLJKjfCpWUWvADXIi3BwYVfVJ3ukcb/5li3q6bu2Avw+tbKLIpt1Fn/LP1VdRy
	oyVIh20p0/d5ftm3simKFH/jXecJOUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703942;
	b=tbph+LuccxqLg3VHOLx7CVRMKmkSv4cp/4pTtlzIJRjgOElYk+oLTXTy+FnHnWuX5cMxJH
	22r2m5IsMfqRViXMrECXa7CL7mTZm8bqLvLxZHdwGMXm2aY93vr6zwIuJOQYj5Tl+dR1tG
	hHunFHO9BTRwGNBjBmcr0zTPzu7XS2Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MhLMeKEF;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703940; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JGEA7g9C3seBG7Njk9iXotctiOXVjOvcLMoVwj7oXRY=;
	b=MhLMeKEF5yMWeEhOck6msS9p83WCIbZV4pcX2juF98eqyxwrZM5KdDFRMqMtuIVHii04ci9l3w/7aQZSwDas6Ig39wfnht7wh5LrknYx4MKfUu1ctIgXA15Cdr1AghctT9lilweBaWXxXiHd6v1rjwudCtID+ycOYv7ayxy78cc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9uK6u_1789703936;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9uK6u_1789703936 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:57 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] selftests: mm: add shmem mTHP collapse test cases
Date: Fri, 18 Sep 2026 11:58:43 +0800
Message-ID: <5f0b54de46dfe0dabaeb78e8a68bbe828ffce9ca.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7wgopzbn5f1sozuezw1bg5acjmdcqtxz
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B0D1C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789703941-610531
X-HE-Meta: U2FsdGVkX1/OL5nJxqZ4+k99Qpk6XcmqtgABinCLT+uL0B8D23QyT75Kfx91RNY4JHqgI8qV3MINKo97uOtPuqLqtacz0CcAz7YwHX+bmdI1zyri7hN6tO5NZ99O29fPCp5xI/rCS9T1X/hcloWIYg4BVscyhi+NAJJIbnWgXj0SblHZ59Wpf/L7IIyVou9ZEe/RdjCn3jHZ10mpUCsAQi8Y5xZNZANpMrrJ0wM2S/qhhJSqY9uw9xllJXdnDIoxxdqqrK3YT4kGcN07UOU5+vKjgF0ERb3oOZ3VDIsPLJagsNWX8kNF8KCvfvH2cHTT+3id+rV45MjlMpbSRa+t2x9+woCeXap/5qYxbpt862NYIxkloAkP5krV6JiZbCf9IGXq5JXPjRFCapXaMA0WAksqlmHW2XqLo4eHVYLdMtNOnx6SIMAR0I3WlOigp8wwbXbQ/bRhUYCaYvgIAXub1+69ATOifGE6Wl+bGfIpKrmB5dQCxncu522I+7NAdspuC4PEk8YA66Pc2U0GQcaziuROo8gkpe628COWII9vKY0qe6+o9wmvEwKWqoIskcMeEQqQJowIIqLVRXzytxLdVcdEQ846bllj6z4zdglWdke0aevbXOM0l5ffmqeMgtoisn/bOMUZMzLVumb1TKfxaKc9eeJwebgy3MLGc3x8uYQtu6eLZi2FOU/i6kVgWHzrBT07wtFOvQkhkdrSP+8vAprSFnNWGTls+te3tc+D7cSrTvjjRKTl1YjNtOCxk7AsqoOtJCtVfuHxDrT35kBBNfUBr//Yn/Zy5D7Hg2klSmcr5lcQgkLSZCDxCiNGCU13zE8bTeT4LlXYzSc2OW1xYUBOT8xlv6VWdNhYIXaeNWyxq0wQ4zn/TLLBhydLpbnoLeUAnIUHNJA2cZi4Pntb6ZOGBIDhG9OJportykIoPBl0H7G1cGgMOIJ2iAokmo8Huom6hd7Wvl7i51xlAmp
 JMUvwtvA
 kVfNhz+OPU6agJeX2fFSlNfBlz7F9jrShPYoHCszh1T3bwqo8ZAOq0Xpmc1JSksahNqDlE6NuVaI+2FcpGfMWZscDU+Z7Ga5yAZaTL7vVOEIvzAY5hbK3VII1x+xTVGMjgTUv7A6Hx1wU6yyDG4EjWOM9wtApCnLqScuxB192lxXeAoiAbL/JlrPxAOm2iYFcuLejoVr53at+Fr/3OhzfTw6Ad4aYtnjf3QaGwV4ApUch8DEmQKRlY81s7+4UorUt6FP+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add shmem mTHP collapse test cases for 'collapse_full', and 'collapse_single_mthp'
for shmem. All khugepaged test cases passed.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/khugepaged.c   | 7 +++++--
 tools/testing/selftests/mm/run_vmtests.sh | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b4..a205b7afbc85 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -627,6 +627,9 @@ static void mthp_khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	if (ops == &__anon_ops) {
 		settings.thp_enabled = THP_NEVER;
 		settings.hugepages[collapse_order].enabled = THP_MADVISE;
+	} else if (ops == &__shmem_ops) {
+		settings.shmem_enabled = SHMEM_NEVER;
+		settings.shmem_hugepages[collapse_order].enabled = SHMEM_ADVISE;
 	}
 
 	thp_push_settings(&settings);
@@ -1260,8 +1263,6 @@ static void parse_test_type(int argc, char **argv)
 			usage();
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
-			usage();
 	} else {
 		usage();
 	}
@@ -1358,6 +1359,7 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_full, mthp_khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1369,6 +1371,7 @@ int main(int argc, char **argv)
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_single_mthp, mthp_khugepaged_context, shmem_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 19755fb4edb9..e1e404a612cc 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -427,6 +427,8 @@ CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
 
+CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:shmem
+
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-- 
2.47.3


