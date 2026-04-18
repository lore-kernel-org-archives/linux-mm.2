Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE46F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23EFB6B0282; Sat, 18 Apr 2026 06:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216386B0284; Sat, 18 Apr 2026 06:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CE26B0285; Sat, 18 Apr 2026 06:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F20C16B0282
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD8FC1A0483
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:50 +0000 (UTC)
X-FDA: 84671381340.12.4F2D40E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35017A0005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LUZXlt5w;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509989; a=rsa-sha256;
	cv=none;
	b=65V8aBmTgLRAukKk2/04jb2FOkHQMxhg7zNtNn8B9PpN4Sr6roxkGfHsaZt6W101/NXd8e
	qhMzEV/Ls7qHly7oNr2FBU4p+/07WQMfJy8yk7lwCttHpPqbwNUG+/pB+iuiqAtfLouADN
	KyWViisJ+E0v6S81GVSWkVy7NWqenwg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LUZXlt5w;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaR8yeTCKZs02E0BVkQWSjQGL8ahxPBCta8dW4kYNk8=;
	b=l4LiDWfiwKB33l5Xo5i0H+NjQSC+1ZTdTjilc1bIUYYP2AD/3lPkWErzSO02kvPjOnuLQV
	2wIWN59aGSfDoMCwasejDshIc6+eBIAmD8h+pv9WwMGoA5dLYuuovQU4MBaJ2WtW5MjCAh
	iwGF0ZEXEyvXwPTEFr8m/D/HSAYzWA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B013A6013B;
	Sat, 18 Apr 2026 10:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC524C2BCB5;
	Sat, 18 Apr 2026 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509988;
	bh=53qqY7PQB/uAj+zPP1JxuvnMAG3AtCcj7DDDSb0K5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUZXlt5wRrXqfRKAmHovZ3JMSpzhHwncgfJ652lortl5wq58UoQvjIQ+c+ydESSGb
	 mv2czE3tEUxi4Ol/Zgpvq4lNqupj63om6xpPM4urrwHcm8Pi03Qfq8jTvAVWv1XhUJ
	 CrszSYDr9DdzRPohCaE2FlosizlkFu5m5ACfuTGlndhpHuQC70gBoCZfa2dhOREIOG
	 QAG3Ydz3xcFD2Lke+5WFijdnQ8LyO2JWN63uSst4jNp8pvpKz+XG0zHYvndMbjNPSA
	 /o2S1KlKSjo9dwM2ZBYz8GieNy1Xhsq1iQpPLiApC7HQZB5+zEVsLpZfNfEUbw2HG2
	 66cRXTN53ur0Q==
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
Subject: [PATCH v2 39/53] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:24 +0300
Message-ID: <20260418105539.1261536-40-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35017A0005
X-Stat-Signature: xsakf754c3x3ffftn6f6atpt9z3x4dkr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509989-134296
X-HE-Meta: U2FsdGVkX1+5/bUPBGEIvZhNVDwXATbPrXmno190X9WtVVO8LnFsLfCAOKLRQDzKqLcIdKeEMla6SgezF5Vaf+RGE06Pua6yCuZbUI5zcrj7yAj8PO9au3uKlVvIb0GcINggY4DU2Lxr8k6851M1Rlcts0tu/QQKJYpQRiBMswMpUaE4T31Khf/umucMaWPDUUILn+opu9oZO45UoK3xV22EY76XzCznBzEEYnm6EVjvh0lJ6eqiwgs0xbROE0zxvJFv1h3kdnUIv7owSJVKpuIYR5kjaVRITQwMz65yzLBMoqxtKuo/vUsI/6ssNWL3sspGoPUi6czMn1yopmVf/y4tcUd7FEnfm0djwplrMtGVgfdUNn1jwodt1ZMkeGGsNN2AhnqDhZhT7I3uTWRjBPp9blVMA7+dVDcpwkLPjGsKG8FDdxQHzZHCkKL2qQqq1R5SfkDf6yrwwsI7jpHYrfE+ox8QjpTwM9WNxARDsuat+pZORtivwC3mEL0YxD2khpZ/zdOcHygA41a4w4i03rsecEjNv+4+Z7GUBh8hHv5uIDomi0zmr56jATFbM8dPVrZZOc014UO0KvFVXZ3Em8i/mnnbxRjcLQ+RRQbUTPXgPVQ1T3caUepIK9LmbKnskvGHqj1etdGkhHffTUqSy8L5qSJWiCu5U0SaPHjUZLH6R6OsSWsybu4hbjomUi8WI7Dvh+1hEjr3Zez3ammFPowGU7JlrOFgqnJb3yXU9Hiq6t8DVbcA6wRUk4R030B9ym61MvJYgQOOTeDIGVWOAb09yjJQx2c5cwoLGcFAUSkUGhtSBI3qqjmeRa+W8usvDcvSmMv+mRwgo8x8ZLdIg42B+H9FfJjr2xp7Bo8qDFWEAMjh2tklYRYObMDJBzbokA7EZ+81WVKE8UmsM/BMsU79JwN6uXiUZY8qnNSzi0oP/sXBo9QHbXyIFNPhjxhm6fa0Qv/PvTpeD1JQzf1
 btKbDgxS
 q80hPYRwP1DeyHgBo8s9U9RNPALvCN1g16oykhLbe2b/l4cwqDv/Xkqf2klqBQx9jm9trpWSqX/JzMA1YdialD00NtnQzwn2bbn0LDTFIvppSeWoGHfhapMReh+OEeG+J5Z68IRVmoQmvCRBxfEXEW+vBAyTF85ibjF5uJGe6mTyGJbzxjC9lP4miEmcHuKS9eQzipSfXTS1pXKoWHQmtkxLmaLA8SPlzOQ5Qr9uC6ZKdtwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 1c87c39780c5..09241a279ec2 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -26,6 +26,7 @@
 #include <stdbool.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
@@ -108,8 +109,9 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
+	int ret = 0, fd, nr;
 	size_t length = 0;
-	int ret = 0, fd;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -125,7 +127,14 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough huge pages\n");
+
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.53.0


