Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB18CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E704B6B008C; Thu,  1 Oct 2026 17:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF97D6B0092; Thu,  1 Oct 2026 17:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE80F6B0093; Thu,  1 Oct 2026 17:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 907606B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:18:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CD031C302C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:14 +0000 (UTC)
X-FDA: 85275320508.27.CC37189
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF3222000F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KuEUnD1L;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4au1uvSYz6hPzXJBCWZKPqrcb7mlvjmhpIZyOfli+U=;
	b=dmsYbE0x4Tp+7yW2zURlrIBN0l1G+vGoDBRjO3QM5qN/1jrg1BzuM02cq1bQebuRfOBbNd
	5Yyjrdg2YZRy5w79Q0cMUUbIUrC2DL2NoJZmDK8pJdR6DqBTr1OFPb/fhYC5+VH0HFRorb
	olRf2JYVptOdxCf5H3vtyFUfBiFv6W4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889492;
	b=N0LHZagVa2GrE/EOFnpDXX22PFS/OxnZczPb3XTqs8vRsWTfskNPY0UAAqyFken48gbzPk
	X3kqFgwUJmTpOHo3lToCYxHjCNC2Yk7TkxvsReNqScnNlExNFHzxwmvbIZbWTZ531jLbSM
	hCQQDxIVDAL8XG5wFPrN8/N6LrDs/U8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KuEUnD1L;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 797821476;
	Thu,  1 Oct 2026 14:18:06 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E38223F86F;
	Thu,  1 Oct 2026 14:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790889489; bh=QTDzI9TFR5poyDcHbXwN5yB0vq+wEkyrdEszsBvl/zE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KuEUnD1LIbrX/jzzm1mZU/5F3Ih+d9xB1/92+Mz5bXrOPOgmJGXD68Xo+HU4T+sjf
	 uUJU6JOq70hPW4Su+HLIYp5N+9TfL8d/JnhxGV8zCiyqzp4bxpqN5IGQS4LtYIuAmn
	 7L/Vp08sWJtgtf1TkHBorBCIGw/zajASP6GMTtmY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 01 Oct 2026 22:17:51 +0100
Subject: [PATCH v9 1/4] kselftest: mm: prevent random failure of huge page
 split for khugepaged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-fix_split-v9-1-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
In-Reply-To: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
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
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2774; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=QTDzI9TFR5poyDcHbXwN5yB0vq+wEkyrdEszsBvl/zE=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqvs4JqSJ1v+3SCIVc/Qop0U3V/fHOG0In9DYc6
 qk+W9AnCi2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCar7OCQAKCRBt1cPRWsUx
 M3GrDADMQ9d4L9YVcXONl31+8k2UAQroC+yDBfRk+kHoqTncqw/AFZd7JktlL4pZNsOiLhl9MB2
 hjUqOHiPzndcOKMiKCugRHmoiZ21xvIi6JpbXGzNWuOV4KTKl5Zgti4LXttMFTpdKDYMK5FUhZe
 fNyFE5cpSyny5d8rKJk/C2KbwvnYGZvijDOzpHkidAbG75XD8fKx+TQPyA79E3on2eAYmbPw7cE
 QR9lMSNFU7tuau5RgRmRi6N256cX1Fm8S5D4gIvcD8tikyGWY76r0/EEstl12wedqXytcHQpCBD
 ThZt2haAqv9Gt0IiEfCNJgHrzDtxfjrjw3KCHs2aQF93T9M3Lq3QKdvq1+1GJ5nKrzuTf8hof7l
 VFd3Fop4Eef5hmAd5aa6Af9XUJpvc2p1aVH8aP3ZjdvefZsyUjt4GUeXLSPo74mCTn92X2cemAX
 a6NWDcoLLOaJS8FPkHShJtN0GUSFQKiKAY+gwmyp2QuuGBVDTh/Urk7XRGZY9jZUo+eRE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF3222000F
X-Stat-Signature: d1n89jfo3jm9yh67xcatqomioiy9jtz1
X-Rspam-User: 
X-HE-Tag: 1790889491-231482
X-HE-Meta: U2FsdGVkX1/8oj4Lgi46BX4XU38UBFXXUpgRICYBS+NdpAE1QGYA5N8/xonHG18Ts/2dOV/666zFSGwQhpraFsZnKTCO8OFBTYIAbXPPO63o8qXNLQpXXv8OXB14b/6UHt1GQNg6CVFUVmf21PqqvXS+nMINCfH2YX0EGK15vfJW0Agx+dgbJag2CR/IiE5tfHIAef0yIaUTW49cO82K6Q3SDWBqkUpMIj+za9lBfnyyWX9+S6lrdVRAtut5BK/E5bBhkAVbPoXIKghbaB5nqpWqrTPtXj0RifESoLkGgUXaiBfzJKQdqWzlqPgUom/9jBAUHp2X3QEWV0SrrpcKNgJp1iseJhwoA9lKPVhGG1MCRyI6Upjuhx5Dmqbro/cg0kHtKJcvKhH3HTiKsSw+c/otfTQX/dLolD6fnVPhHXE1iBm2Cj1kjuFt9pWzlA/UtGUh3vKIgblxGyIPJEL+7ZMNYJUdIjET193f3JLCYFev86+hdTlvGs3epAD9KARE4QHg2x31uVVQimtg4/ugtzMH/PHoy3TFsLpAl9gOsEuaFyz0hpXM7k819xq18f2nH2NzlWEZiA2OTRV9DjDTvS30r4/lDMlHXa63wx5wbZ/7Qabe6XWC98tyYvrEuqhIz5dAIwmCmkySgDswTnoIIA0wzm2mNkuMEraxxL3To47Libpp6QaUOli4eEMEqOP81L551F552pDZKyyZotBEgTRuJi6m6Wtip0JBwp/7FgySrjAi7PnDg0Vl30uNApo7IdKZl9LeUieCuN26ubd4LksouHNAxuwL9g0e/PISBuBp8808+ISitDBQWipYba9pbF0JJc1ClF2s9sE9CWquzfDVIstssLttCzXvcWY3wupZpCQcV8cRIlzdh8cTPmSOdZikE8jii5JNOFvDHlnqAKTknH0c+4wyBtmY8mxO1GRGVif2gpC6lg2fm5g2gbt9D5A66cyADZFGVuQh5yc
 6VEbzpTP
 KAzG9SDEQy4H+0AYJg1fS8HQFsQe/kfxkJW2oMZb0q36li3C6DY0swrLKZrCZs8k11TvebFdetlpWGWEKFAWEUdMpZw77vAlPHi/5CiyNeDHDYgW3nW92sHMw/dUI/NpkZbF0aLTAsMA4GGgC46R+3ynWuG92P7UVMVX/Qw6IMZckxCyD3VGkam/CwgC9HUtVzmpjmOQfq+ZL/bwfkfbHhOCmrY2EmugXmobxwCYf7sW/GgGqwRqQZ7LF1jSiOIWDhMcqIxpMybm0bzL2jJery0dDeG2erIv/PMjmJx+SViS/hsM=
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
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c5d96a4b1db3..36a6719ff09a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -108,6 +108,15 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
+static void disable_khugepaged(void *addr, size_t len)
+{
+	/* Disables khugepaged from collapsing pages in range into THPs */
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_perror("MADV_NOHUGEPAGE failed");
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -120,6 +129,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -167,6 +178,8 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -215,6 +228,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -482,6 +497,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);

-- 
2.43.0


