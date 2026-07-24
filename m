Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A8BC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CD36B00A3; Fri, 24 Jul 2026 06:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD1D6B00A5; Fri, 24 Jul 2026 06:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2A66B00A6; Fri, 24 Jul 2026 06:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 248936B00A3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DA8B1C0526
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:04 +0000 (UTC)
X-FDA: 85023287328.03.B8543CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C175840003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=su4bVAnm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9B0AGZfQK2J8HufoOdi7PTgNMGb98FuuGJF+jylaU4o=;
	b=8BmEJ/rZ5h67iJlxerbN5x+4NizOxZDAve+RnpPTlYE1b8pOBt+1B4+KqFf28+VstC5U/r
	U2QzbqRAUJu9usPrp0uHxm5dwSAS+RU8tJkn2npqSG8/nMFOoE7g3BeG28KZJEQ1HjME0m
	sas0Ph08kKb9yAbQF6quD9Gmkzfvab4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=su4bVAnm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888703;
	b=KBioL2NtV8JWNNhwyILeoaS0L52njbnE/QLekGLNoKKfo4FtBDy/d+afYkK7OZB0/wNGL7
	ETfnZq1b1xDq4Xgzbf9T/NDcGSJOrCKBqu7X+/b2/aPgR13ucvkwGDXexgjEKikayjkkqS
	c7u2X5LicqAS6Iem0jA4gZ2kS6fzWZw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 285471595;
	Fri, 24 Jul 2026 03:24:57 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 227853F66F;
	Fri, 24 Jul 2026 03:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888701; bh=EfYVwz+NK1/iRlKs2gYESBuvvKYJIJMJC6PoEmXo+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=su4bVAnmZBoo2ATbYQzURgZRjznCKZUwulbqfhLZZiOBoMjqIQ35Hxafm0nvpLpyN
	 aBCNKx1AWIm+hFSLyGvxrPvOjkzmRd6Pif3wv+bV3IKeyS1Ds3KaXKozIMKFQYTIq2
	 jSxXF2o334/FJKgadnG7nlb2ga1BsRyB+LT1spdI=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sarthak.sharma@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 1/5] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Fri, 24 Jul 2026 11:24:24 +0100
Message-ID: <20260724102431.1199519-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102431.1199519-1-usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C175840003
X-Rspam-User: 
X-Stat-Signature: 59tj4hho3zdehkj97iah4ndxyni95pbf
X-HE-Tag: 1784888702-710998
X-HE-Meta: U2FsdGVkX1/BZ69v6e6QdSWtpvFqj3S1ZXJAJmLbe5E27TIYm7yBRzhVfBm3U0plW1knRZ/iJA9hWRPvAaBjHDClCPa1Yk3U0UlaERFA/RlHMv85T4qbR9bd1a8ZN8lR8yJT43V/UPKQ6ILGcY7q+zQpITU4o9sz1t2PjrGK9sO5QsbAMC4Awvld9RTSzgxpqSU4Gg/4likq33sviG7WJ2Oci7IwM3/uSQyYZy2ct7zQzxfZ5oWnzxniH5o+cLhpY7cxg5KEKKSYclIdjelqKFy7OUWV+1IX6/ijnzi2AIv5IA51oL3LQD1nVaVozglh60nZFX1c1DZuQOT/QjWQLc++h1olSfPLezLtfbMyhejRpTELotqIMwtB1YIBDm9by5jMK0t6ntXNWTWHC+Nd8M8qqQyLHb7avjfyBMQKhxQqWkQFL/Z9DpqFhVCNfeN04f9AwlZw1SKrlmy+cN4oKCD4TvmPVnSJOSd9dJEiuzXFiXTWMHbN2U1ky77FIqGhunZsWeT0qPjuywgKTRhAkfgHcBLfJxH36s+Vn+IvkcNjRm3v1UONoMUHuzYlZPrr3AxGxs6bYMfzLpWKmy0D11cEI6BcoxlQvKKg+GalFeSqMHxtXIAKcTgLHlzbz+ibCKx72MTkpFitcqk96Ln+ZJAAlkenQ3JeME5lHrI8ZHcaQq5gRb2/sbrb5N9bTA3lL2UT4Xl85Pl+Ffts9vHX6YG9EWIIcq/N0EmMm1ZhTB/vM1PEBtFghVpPW5JQQTX1ec2eTUWvOrcfwouEFwLKq8Fv/hAUy4uHF9HC8Iw3BIkofcd7PsWR51XL6Wvshz8hVP3YYS9znFZTy1xQyN0WflGU2X7apzX4HYpC9X5EuCvB2phpDdLKj4D5kT92k6RHmyFmKImo89CkpRb2Xhp3Db49TlpehTY3vn0/VESNohj7Nbao780oyo2omBr9md7T/xYqMaHkCCCkkoRcfko
 fxCwnuH4
 c1q4RnxJbxZOjSWypeK8XmOS+QYzsyL1bhEyoCZ2o/WPZbz1YGXT/1R5bzGwvtbDoxddCPpDEZmGV7P9UA9OLkcmJERtHntTNob/RsEHn5+N2PeG/Ph5oTaEH7GuHGQjX/QGPZbo2hZ45d4ExzAcVXALD4oqHWdYGcL8aN/vj9uiqDhAcFUx6bxH9per/vZkNl6EVGTABHFjRDGoA5+MjXu1dYPeBc240NmEB1JMSWPABKbmhNoXxP/YQsjARl1qEnXdx5OADS/mY7/I6TrGqpy37Dim/GLttsfx8bOnVAAsVZTiP1T5dxYFXYM/UC1qbqq4C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds
noise because the test prerequisite is absent rather than the COW
implementation being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/cow.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 0c627ea89ff7b..c1b8920e29342 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
-- 
2.47.3


