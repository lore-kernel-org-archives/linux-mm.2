Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA876FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6216A6B00BA; Tue, 28 Apr 2026 16:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1B96B00BC; Tue, 28 Apr 2026 16:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1646B00BD; Tue, 28 Apr 2026 16:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37B886B00BA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED3FB140433
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:05 +0000 (UTC)
X-FDA: 84709144170.29.EDCDD36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28396180015
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P65sTN5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlguagbjnrantmVoLh8ptO+HFRIfNMOGf6zz/7EV/d4=;
	b=hj6cZEcaTgXc1i6YdMvOD4sdmjRX/RB0C4LC8jneAoH4CPldraFOnysuw5O4G+z2utJKIn
	6lMN+4qm9HHbx0N10kn0FkY2pBJyy3zJwWT4DBBq6cs6V9n3zd0KD6FYzPVUU4P6wGQ6e2
	/54E4zi2pLDix8uS2JAAPVA1MLZl9+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409104; a=rsa-sha256;
	cv=none;
	b=h9aRmAqj/mDJMAQEVcYr9T+BkKd7FTLs2SLY3tkIXIRnKgEVsB+baSYL45RbffoM71+RH+
	9kiVFP2VBid7eY2XwdCjpvRs9kPsoH6C6EarDsPpGaM9TXiQVeUOQnN7kQZKssQJBNPeeb
	H16rApr2su2iZuj0rLUY2iGu+j78GaY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P65sTN5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C24E402EA;
	Tue, 28 Apr 2026 20:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF202C2BCB3;
	Tue, 28 Apr 2026 20:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409103;
	bh=pVenT6kXm2JiaCrXk0cfnUIIgxC+0Du4A0hv+H/HwsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P65sTN5sY8cpNcym7Tn18YC9GdenJ1QnEX9IZQF/c5NzKm3q+04G6pvsebbX4IJdM
	 /znXgnc76JesXrwbhtSspUSRRUsYL0wtEU1uigCpLhQ6iPg4kMu2xLT8PvlQF10icO
	 bz9mo4hxqfY+LrBKfV4YsZ+a4jQzoXgkr17S+QlSzS1Iwz/Y7az8DpXKJYYTL2l2/S
	 5Iez7jBaO5wLedg5qp6sV/+IZjac+tZ7w7NRQJaI/nhiw+H4a+aGB1DdN1QUmMbEFu
	 jcwNML8zL9BWdJiSS+lbT9sJyMJacqYuHmWDWeaN8qctOIRZkyrXj77MQdqdEo2l/Z
	 S3rDeXfgRfcZw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 20/54] selftests/mm: va_high_addr_switch: use kselftest framework
Date: Tue, 28 Apr 2026 23:42:06 +0300
Message-ID: <20260428204240.1924129-21-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28396180015
X-Rspamd-Server: rspam04
X-Stat-Signature: wi3i8rfkxuodrkdpgodcaakw9979u6cr
X-HE-Tag: 1777409103-347718
X-HE-Meta: U2FsdGVkX18xu4gIrhFPfg95uCkfdwocm+cvfrxMIp8IF8jJr+XkO/K1pDRbu9Z73VKeU0Dsi4QIdV6P8aRzy6bl4cqKw0hvA7vsUgs9oJj9fViKbK0Q+hew7Dmlh3bNUilqEpYXbILWcDeba7P4O8Qt/tpjV1cIsUjt1Kk2cbSMEhnMDRg7BCBb0oNhjw+R+j+nD+2UHfa1LJGVbNfpRGYdKJLjxhV3u1l8y2rEJb2gEJzeW01J01BRkppRSO/AHjoVseVsba70DVgtj6jYogn7hJCaOcc8Ds3CzAWIDzz7TaC0lbaQuwhpEpBg+o3t7KyB5ED9cN1mbX6ULwuOwAAdrx2VyQW5XeQ0Cf1P+xRU6hJ0DYlwjUz+L2uds9+nFCUavdP9SoG1TwuDR37PcAuHAhP5jsvYovZ5o5K9AhNwGX9PaYAwV0mGxCtjXZ/mgrkfdrAJDBhGHOMZZhtHTyLWs2nhrNUVCXUod9BNCSp7ArC31Wyd6UnFerbUWojOk2xUDkrdJQ5BSJ3LZyLRvNyon7URoEhJL3fjq10MhtWMFKIXeLPUF0qq6AWczi3yiNtixh+KiHwZgQy+RyHp2iokROxzX2DtQ722tZBsA1XQTZeqFEPn2WkNLLEFNYamMSuyPuIkKdK+5ntRD7yIxF2LNbpJH0FZIQcnnvXWEtgpbZlZtWpF/EpEC9xGIl6WfiqnfsnYYLcfbugQN40+Oc5yhN9bXXyMBPgy2+VZm9fDO+/CXSiAe2RBhkmQTGgt2NWfF2a7ssqODeekKn9e9nDDQeMwgcrmOkDtpAdTZd+ggA4KzCMbDTaSp60HRhRg5FktCblNUl24hkxfg0DdNfeG1npZaydT4/no+Gb3FLhRvCsjn24QTYMsYAtqTiGD/0UQh25Lk0FGZALs6xFoVwGU7tGYrZwzwLyOdaAp0+UVBy2FXZB4iPrl0KCvgg3PLAva2Phk8Vn9OHho+gk
 mpv4TQzy
 VbPhJt811LrdTYtlZu5IgL8FQBF3fPHCX18CTbQahlVfv7LMFxcIL/ZyhjgtQImEO0ah9OYJNRBwdEyPr02SPTLjCzE8WrMVLdZlZ5utUn9bFGs25dBfglNbJqWKMP8RxrEuUaBYMkxqanl/dfUAgu/lZCepKoSHkYZaRPM7ksmlLxldGOxQPNfpL4U2TE6fMFLJg37KDtRR1sdJyUzTltkscW6dwdLRApRSEaHWB8Z11YQCjw+1wSo/0is0hr3YP99mlfCKDQM7IVUQWBkpyq03qBrRwKVkn07/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert va_high_addr_switch test to use kselftest framework for
reporting and tracking successful and failing runs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.c        | 41 +++++++++----------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 51401e081b20..5d38735ea60e 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -257,40 +257,35 @@ void testcases_init(void)
 	switch_hint = addr_switch_hint;
 }
 
-static int run_test(struct testcase *test, int count)
+static void run_test(struct testcase *test, int count)
 {
 	void *p;
-	int i, ret = KSFT_PASS;
+	int i;
 
 	for (i = 0; i < count; i++) {
 		struct testcase *t = test + i;
 
 		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
-
-		printf("%s: %p - ", t->msg, p);
-
 		if (p == MAP_FAILED) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_perror("MAP_FAILED");
+			ksft_test_result_fail("%s\n", t->msg);
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(switch_hint)) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_print_msg("%p not below switch hint\n", p);
+			ksft_test_result_fail("%s\n", t->msg);
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
 			 * bugs in page fault handling
 			 */
 			memset(p, 0, t->size);
-			printf("OK\n");
+			ksft_test_result_pass("%s\n", t->msg);
 		}
 		if (!t->keep_mapped)
 			munmap(p, t->size);
 	}
-
-	return ret;
 }
 
 #ifdef __aarch64__
@@ -322,19 +317,23 @@ static int supported_arch(void)
 
 int main(int argc, char **argv)
 {
-	int ret, hugetlb_ret = KSFT_PASS;
+	bool run_hugetlb = false;
+
+	ksft_print_header();
 
 	if (!supported_arch())
-		return KSFT_SKIP;
+		ksft_exit_skip("Architecture not supported\n");
+
+	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+		run_hugetlb = true;
 
 	testcases_init();
 
-	ret = run_test(testcases, sz_testcases);
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
+	ksft_set_plan(sz_testcases + (run_hugetlb ? sz_hugetlb_testcases : 0));
+
+	run_test(testcases, sz_testcases);
+	if (run_hugetlb)
+		run_test(hugetlb_testcases, sz_hugetlb_testcases);
 
-	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
-		return KSFT_PASS;
-	else
-		return KSFT_FAIL;
+	ksft_finished();
 }
-- 
2.53.0


