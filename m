Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1171C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0416B008C; Wed, 26 Aug 2026 08:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0B76B0095; Wed, 26 Aug 2026 08:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7126B0096; Wed, 26 Aug 2026 08:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5F36B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:25:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 284211C1948
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:10 +0000 (UTC)
X-FDA: 85143340380.05.6CC013B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0C902A000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uQ4oK8Tl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787747108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qzcazUSCXnL57aSLfLl4TpnsdCTlkhFbBOFQKUBXMM=;
	b=narV3ilS48ume4oGmliBpv8IePO7aO0rJ2UFsxE47X59JmyVvoAeHVRHTxiUBsLf/323Bt
	9d8ZDXhfB5uskQtVfG+gZU/fbA6BtDiezE2YAdP/W1KlRUSSLJ5osCv2SUam95m23IbmoF
	S4ocPHoPrJGlX0mTuExKkrYXJ/xkn0k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uQ4oK8Tl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787747108;
	b=vqstYi2Qkzx5U3Qjy265ep2V0Sh3322BMYHjuigIIu7BRuSw2u4PkCidra8RdkzNN3cg8p
	IWrCguvrX8661tu/eU7JBOVtzDhZMHbq8tvzIwIr0kaiIui83rBQxDg5VVQMpoMrHQk4I6
	9KG1ZPOYJO+ng1anfVAiZunJGasGoHU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5151E1596;
	Wed, 26 Aug 2026 05:25:03 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 313D83F7D8;
	Wed, 26 Aug 2026 05:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787747107; bh=GvQPZ0sVbuduLvQoOF9zM5jXfFX1CSDKvuBA3qmf1I8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uQ4oK8TlYljFlraHfvdRd7Krim8N2tNZDk2qqEs+rKXm1fpcULodS+jTeipE4lc2N
	 HMaynMo8ScJfqIL5txZ4T48K+OCtjAS3KEcQZGDAsXRBzmFRzGuKVxtYd+njkqSBBr
	 gst23nZKEvCkrc5DdiopebD9VDTrtXgc5SVnidQA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 26 Aug 2026 13:24:39 +0100
Subject: [PATCH v2 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-fix_split-v2-1-71153c7f579a@arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
In-Reply-To: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2698; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=GvQPZ0sVbuduLvQoOF9zM5jXfFX1CSDKvuBA3qmf1I8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqjtsbim5lcCrKm1NTonGxRpo+/uWXYt6fnVqSW
 2zH3AZ2+mCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCao7bGwAKCRBt1cPRWsUx
 Mwl1C/9wWoLo2TBd76OtUebEOO9bmK1IDPaAImCIYUhdFcULi+QtYiaD5Dv95d2w/ur8IbUve0/
 H1XJHff2OIt+Cggqmtqw128mL2F0wo+Ak2JZVW1KB0oc8lsbyMHXDswwrZb0lkBh+0IiT5Ne7YT
 XyWGemLyMoggKrStCYhAzx8H4sr4VrxcNAccO8j6O0VFuSW3sgpMTBNRUhhfMUQYkmwiZPMdXO8
 T5/MIBY4rMwZNSg6ouXnHnjQG3F6eFj70MDP7EWR3OijfONE9hx4JIcOGtxEka+E9mizpeb26JB
 ehhQPMO0HbnfXVEWvsaRprxpwpckBw4s5L0mqQAqmNgcJLUIUsMEtBwToVd8lDBxN3szlymtN54
 FKJ3ajlgig/fmTN3Mu/I0vBW8wfk37ly69RS90mhuL5kysqhLDErYPnXRWKTBuLBn0AGEIG0AhK
 /S6GF2qbFCM5LXkiORwjKDIqJLKgTnL8xI4evcfrQX8SFj+13hXf6XWXjbOXX0qRKgRc8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: jmadw1naw8pmeygqgj3anidab933wkuh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C902A000C
X-Rspam-User: 
X-HE-Tag: 1787747107-768003
X-HE-Meta: U2FsdGVkX1/tnqvqrH1Muyoubzd+yRzf5KSFEy1OlaCXqZCXl/8XUeHHmFMHsvk4H8i3SujwP14PT4SpE9JeSDoYmmVcewTzOnwu6hwTcHA+rwEAw/KffZrZmOR69WN+GzjcwjrBdUp9cz20gbIpXB/FqIkxRFSHAj0g/icKjnjSdHgo+O5crkzGFhxnfs3gCq6hBOmVnQmDyqsME2EzonsvaOULrHcYscQbbJ3/rc7iykGKbvAYXX8G3jJ6NSOWWEWCowjkTHOS1RjawhGJunYqN8P7g/SEPwwt8WgLvO2XL2ecR8aRlsDdVLBrp3p8BuczSkIXhhs/X+ScEaUlZGteAthsd4EYqghz/ekf3Mw/Q0f3c6g4xaQsWpODIGn8ZVKH6inOqc1m02Az/8Dprou7BlRSe5yfes1H6/FZPSGa1ErQKb2s1GO2Oupl+gsUvO8/YHrHQNdZ8l8OLkalH3lWuqvOnT/KCIBjav5ltsF7Z5g8BRy7a7TONTFOWIlO4VCAnZ3m0xHx0tMUWBGdhYuct3pyPl4Giv0d/+831gicsBP4cp7oo58f6Ry1wRmVmgegzVGsd/G56f0xOOWPofyUfcxrbyuxYOiKKl8A/n0MTXg1Mp13qClU58JUzxJrL04VXCgsd8XvRZArWDJpPcEk+Invp4KfOAxBWXovloKUdjNsQ5GO/XIqs2m1Zt0dIng+Ck8qunP4CJaW3zHCpF+Ez55h29bC8ZZyDwlSxdtj1VEpP++o1unsnwr0xwr/20E/N1lnLlgy8LI5EVuK0Xy9UoNho2V9nTSqopHDrqGq+51ViR4n2o4e4lgX/GX2nMaSJCfHvLxehAPVSxde1lhEk78vCABaQHd9B3AV545c4lxbGMFlZTaXNOUtZrvpNWg9I656jOE6rVb+KDRfC1rYl+ACnNzrFu/rkwNZkC+yiv55gkYX6AAJWePPcMWOyBjrIVztfts6tANbyGo
 tvxT+133
 ASoOxBe0CQl8zcdyMIP/6F5Zqn7PuuoMv0lCWdBbInGl5CV8FUoKJj0hprYbiy7waVnKcoh1lLprqw02MLrc9xv+oUjYLS3OLRCp8LY59exfPoSnSEpkoFTuguOWqM/WaLRMLXisDMdk347XXxA4skIwY9w4/dGXE+eGM8wjOe36uGMO4SuUOghBOB+JiWTvzwZW6Be5eH8YzQ2y9wUJZmJ99cS+gNBzo4WLAEZrixaIXs5R7Ea6MAzFHMKWO3Yn5cHjhsyZySoicAJYUTiqGcGGBNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There're some random failure for split_huge_page_test when khugepaged
collapses pages into pmd again which had split by the test.

Prevent the khugepaged's collapses for split page by setting the
mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..8f68bc94a5ca 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -180,6 +180,10 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(one_page, len, MADV_NOHUGEPAGE))
+		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -227,6 +231,10 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(one_page, len, MADV_NOHUGEPAGE))
+		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -313,6 +321,10 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(thp_area, thp_area_size, MADV_NOHUGEPAGE))
+		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
+
 	/* Split all THPs through the remapped pages. */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
 		      (uint64_t)page_area + page_area_size, 0);
@@ -542,6 +554,9 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	/* Prevent khugepaged from collapsing the pages. */
+	if (madvise(*addr, fd_size, MADV_NOHUGEPAGE))
+		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


