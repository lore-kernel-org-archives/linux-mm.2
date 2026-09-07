Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846EFC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7686B00AD; Mon,  7 Sep 2026 04:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EDE6B00AE; Mon,  7 Sep 2026 04:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DC16B00AF; Mon,  7 Sep 2026 04:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9596B00AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:19:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10BEB1606FC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:40 +0000 (UTC)
X-FDA: 85186267320.28.D47D999
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 225121C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NnJ3qfES;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/RWRSA0ZA2qzzMPuAQiSXWyOP9hrQASFFXioMjq9RI=;
	b=nAHMfm8PD3+STNmUXSCZJB8uexWlcu0/XuRBxZBydJKh5/oNQI2IBpxadTNuTTbjw7M01l
	/D+MiJWih0O1S2BvpKM8vGva544ihZaIkoR8g7Jm6TSi4y2NhobOqKRUeNvjMSsjJVvh4P
	MujL2O3AaoRPz+FATrfWl2AH0sJFdZU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NnJ3qfES;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769178;
	b=x4kCq6c1OJ/X0Ku6bCUzeb1v+SmR48RhLdv9ioQpSovx0QhQbC+4DMIpype+N7c+doOET4
	6n84VfRkbe2H3nnJFEjUoFce2mm3qwWBAkS/OgvAL60M6SZM63b/3ELh9R4srx0vraMW4e
	8jY3Sw+ESyXnX0v/vLnjWEZqzr+hZeQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FEC91A32;
	Mon,  7 Sep 2026 01:19:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7606B3F7D8;
	Mon,  7 Sep 2026 01:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788769177; bh=v3lJLJ64R7nLhf+mDAkhjmHG3DMXCLSo7wMzBe1cAD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NnJ3qfESypCG/7s7VquBc3/XfgR2n8t9EM6vFOWw3zdnY3Tvv1TvVRy7AWYq/RyoN
	 Et6SPOvMpe3ZL49LqM2togYdq8LBddGWT6/LbFuH90rHVB83wvFt/W5/K2mR8f15pf
	 TdO1dh7OnueAOz8ujibMNlllM11syoCR99TQAZ/M=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 07 Sep 2026 09:19:26 +0100
Subject: [PATCH v5 1/3] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-fix_split-v5-1-822b810458bc@arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
In-Reply-To: <20260907-fix_split-v5-0-822b810458bc@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2716; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=v3lJLJ64R7nLhf+mDAkhjmHG3DMXCLSo7wMzBe1cAD8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqnnOR1zCSMGM7Z/DwbyT+XNBI5kcy3peCZqhUP
 2YNQyjt8cKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCap5zkQAKCRBt1cPRWsUx
 M3WbC/9AcaZpg0ZOGpEKvpchDwI0fH3k+z7NXbEUuycIc7rMvohUVHUQkKblL3McQgw5FF/+Gwj
 g7ZRakjo6geuS38WpmXWjEajtJrLTi7f79q/FFrJYtRDLkMYAgK+/Wk5o4AxVNgJLgZS8VOSz/s
 FFaVd3Ia9GDrUxy+vNnqjtsPDX4RhrIP7jwhOYwDudA+Y9jGKpjRTg0G2keZDHqDq/RYE7rwgCP
 Ra1oLS9Pkqgk5w/zOnMZUHzosIPzkcQLP4mUdJZ6MA83STGnWVXMdr8nNDY6qCuMYB6w+mRLlQh
 3Rk13SsY+AP7BxObWRUnvsXGB2pufzUXBxVABSU4illlE8knM5lUzel3OdZQPF1zfXIys8xuGWC
 81hBCcuoesDSlh6KEmvxJxLIixOA/fBKim5hBl4BAsePVcBf9mY7GbTuKDIzRRafFfiwkN5zL1i
 KUlYSZ7B/0xkA9n/zU/QP+Cpm5N25CDxmVUZkhAxieoNxiXE7Y0oXAFHhgLHOmm/0jG8Y=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: yc7zme8fkejd1zqjwgu95ars1ur9n81o
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 225121C0003
X-Rspam-User: 
X-HE-Tag: 1788769177-528257
X-HE-Meta: U2FsdGVkX19nmRINVx11PKbi3TWWalXQK0p/jt4UaJGYeYq7bak9ATTl2Df1ahShoAqKV7aCbO3NfLSZpyzIoFOgLaY4WcSNvYton8OW2t8SL9xTxoaEqqr0MS6JBlbu6xxah0USReEqtf19aIdjpT9xGo3xb2WPww8Pye2jGraKZf8MV9T/gPijnWEKQa+ujZ0Umdl/I5xYNajhdTQU3HDeQIsG7Q2yxCJAXv6fX9tnSAOqmWqM5e/JpQSfyjl8iq7SSc92835sWH15SPUbJxAN4rZQ7S/UTZpXE0ux+Fv0k82+VlXUWMyzRUlqmuJpbsn7XXV7g8r1CzvntcS4f+xHxWfh3linKX70PXwRJwo7wbcpAKcDvtgmRLCfd30/Sk5RudQagLGYUc/YYt8KI8wIYevhPyrVXEpvsNbieGNWCY6bdYS7sxOxeeJgZFFPAu/j6iQ6DepUML9n+1MiN+3mz1+U2Pxt/owLvx/IIEkJxH1U8M8w9162mzC3XQw9DyotjVD1vvNsCQUz2fyZ4LSuOZMpiByXCSDt4T6GwgiPZqEXS6OS4nXP1M9ehz/qnoN0zpUNuUX4YFo3m7eqbrhrrCgn4JvAK5SLp25Jp2bT8LAMOAfC01Yv4HX8g4CaMFEJsqPRoINtaGxZELd8fQN8V65LDbgAAD0Ht/mMvRWb+S7ktjEHRKMx/VyPlhec6Tnq2xlCpvMPbLf/AHckz9xD3BDHtg87a/1jwKJ0St0B/LHD6F/svIl6SSHrRSdO3/KDWePf323s0DslHc3/zuIvsUdbl+mtrQ6IyvvsB9RA++5E5eyDuECXi6cB8reBKSFN02wzvIsrfPIUSs2YZ/HhHnZsAGkdXOSgYKA3Yes8u7lZHEjsLHCQk2TrYdaUZGjU9oyh+RQbUSEnZptVm6IBgfKCspMZh0+w5//5iY2C3fH0H3pDAunAV/4t1Nk+h3NOTrk2QximfwSVLps
 tshV/GSZ
 JUEIFnMRi5sYoEsvF7+NrOYfNttYSJn1aeoimErbcmoQY5hb2qx7xDUYmz32jKP0BnuMz5nyvIJgJeakxibIZw9V+VWmdNTORRYccM+D3LWU2XYQOB9QuEeWvfDtzxfsEQB0Ol+tFj5qwi4hC5LEewKMQtJw7xJQOdmvvEs5ZOvPqb1IAfIa7b3dWXcu9pEaoeMCGg+JnW9fAmscFywfEgfVV1Axs1e0U/eW2WwwpXeAYmX1alK4ifug1LyuLKHvHmEfVyYPkTsZd+RzEIjWkA1HOBgHBpGdFwfnYsAmELmNPaJxqrbY7w25HHA==
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

Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c01d227d7fd6..cba327f77873 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -167,6 +167,18 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
+static void disable_khugepaged(void *addr, size_t len)
+{
+	/*
+	 * Disables khugepaged from collapsing THPs in range, existing THP
+	 * pages remain.
+	 */
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -179,6 +191,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -226,6 +240,8 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -274,6 +290,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -541,6 +559,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


