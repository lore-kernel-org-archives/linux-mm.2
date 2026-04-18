Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96785F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A256B0280; Sat, 18 Apr 2026 06:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041C46B0282; Sat, 18 Apr 2026 06:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A4C6B0283; Sat, 18 Apr 2026 06:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D45676B0280
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E99EB97E9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:44 +0000 (UTC)
X-FDA: 84671381088.04.D301D8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E49C180011
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbz5b8Om;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509983; a=rsa-sha256;
	cv=none;
	b=NJOWNvPB3nhNDmFr+Fs88ezjlz8xgsBPyDuxEkwcuEmt/U5nylcoaiV44Q69489FXiCMab
	sE0IIAshUDYFq1ZMvIaQYzIaQ5yK/tT5vtTyQy3aXxkcNy6CkHlPqIJTnm4dpWWK4urL5D
	U9hW26y0EZEQ9tJIlMUp3bmzbmDuP/g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbz5b8Om;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aKzt+jdDm04yuoe2mTtjxi6tR51bn3+Qe/Ee4yaJ/c=;
	b=bYJ6bYc2FG56N8f4RPfU5GGnLje7ap6YuHGLf0J99YHWDNCIP9Z67cFLLcrlQKzKfkjMWK
	rIdfxPQ9/v/7Zdb6kK2Akn4gfMatQX5AkKjIhOQ0tuvIOVg3bzykrWDRnTT6jAumBEO/Hl
	T/ZoAKFPkO0xB9gKjWQteuKg8U8iDnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C4FB60138;
	Sat, 18 Apr 2026 10:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5EFC19424;
	Sat, 18 Apr 2026 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509982;
	bh=F5Wx66XeR8OpgrD7KwXUlLY+bzqPcaE/6HGIjMYJD1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbz5b8Om0FfnosyCP8hYZhe6QvCcEJXMCrYtfkSmRMjD2ryRtB4aozsMpSynpM2/a
	 GqIVvYrlSRrNBiOmvFHK2dizYwpA1WYspVxS08tZKVS1fCj0z8HfxtuAjbTBqa7ThC
	 NZzLlDYNybslEe+bpDMdQKjHw651mbVQctFCkbdHmTWkIaIjZxvcyfA0YkaBVOfaVo
	 pXO5zFH+OcAmhvZphPeL9NNCmV/6fWyMcyLFeiv3T2aDRgaqL+ypWKgyoDNo1T/H4I
	 stAnfY+nu0H1XywfifEqLlf8A3n2bXHmh4mxaqNthPiozCQzfgqHiJ+yXcJwlU6/Ju
	 5Toh4ilx9724g==
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
Subject: [PATCH v2 38/53] selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:23 +0300
Message-ID: <20260418105539.1261536-39-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: rexzdz9yqprfhszfzfnxk461x78ugcqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E49C180011
X-HE-Tag: 1776509982-477688
X-HE-Meta: U2FsdGVkX19/F6H9qya9EVNU2gPGa2q6VqII7Wa3+zbJSm4V389vn2mYB7mQ9SXxsvO36GCFnKFeRYcKPZ02ydtcfTwAP8sTqQe0I4Cqo6B3kmweUdM42QdxofBWdNx0d9Mw2W72tV3ZhdV4yzHUTyJc9819/tnRh3lPlBsmrAbqNuHZ4NjYt5WJtYD290ASLXBLtvTPwO/SYH1RP8VeklE7M8a15TPO1M1To8y2HPmCdE6O1WA4Q4eeGhB4K+3p0p563M5gMR8geIHSkPZI8vfMjmLDyc0OnOqpxzul+OI7YmgNHBXe8L5UVi6MifKWaqfrzcFkC/yHla/tMXZnAMBMWvisgH1vZEP+J38ngGk4lDyLwC0f0y8L+wbYw5rh/LKEEHOwrXhpTgaZN/204W80hcdjzgrOEDo/kByqEi18DjAWrFCAFfb1Bp62jhAWLAoalqHABhy/M1mWchNNgaIuCDsMq5ELrPGZ0ord93uTrKbL4aYJ2mnxtAUVdb+fKYG3IayxZgEBIcjNIy4bOuCuqwO9ILfEewRlmweLoEIr4NcTh5A7WzTQrfsbfl+ZcyJsP3/3/qzKyA0Y61BWNzYRt77bwrzoaK1y0nXONopEiKWhQFPFYqdJ/iIxsyjBGU3p2wIKVzutt0BSePgiNyNKgPUPCkTflXhpiQoJfdqnwQ1qbVg2gLGiS9VYOD3FtRcu+WzBGkWaE9xrHVK+4Dd0TtPTmmwaJoUMaaQhlGg4E9PFZRhU09FY9ofhZ4fAr9XZofiALPP0dYQDYI2XGc9wv9aq8j/TaRbezIgCo4D6MZETSbEhRXx8oJqzazKjr6GwtFYZ+lSoMx4RLhOswFIAjAnP2oApehuNaY/g1FV4iJQDlu9Xs/8OWN5KdiNytFLLCL1eV4Ps+UzPCjCzdgtDnG1lxvWX5rqaPeqgS1QbsrEWziQO8Sh/fRYox6CSzl5tGhz8dgo4Q6wVEcR
 jN8fo4Qx
 f9j+ZuP0ZJfK8E8XiWPsWEbrpqc/tj8EsZMk6a0MecYvrOVlqkcQoy8b1lMGup0wXoMvvq2KY4WnGmzZNLtYxV+VLhMNAEPQsNBNuWP8xUfUYajJ/iWeY3m+knKapS9YDNsHh0vH8RGQ6mhi+SgCyGDMD50OdL/JDkOyqwTRyzGUN+tWcR67PSLYUUT60dbgRTX/sff+9RPKCBtUujnyncUL0gJqyolJCx3wG7+a1h2YmLYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 3a7dd630f425..d629cf22bf5d 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -106,10 +106,9 @@ int main(int argc, char **argv)
 {
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int shift = 0;
+	int shift = 0, nr;
 
 	ksft_print_header();
-	ksft_set_plan(2);
 
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
@@ -125,9 +124,13 @@ int main(int argc, char **argv)
 	}
 
 	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
+	length = (length + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
 
+	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	test_anon_mmap(length, shift);
-- 
2.53.0


